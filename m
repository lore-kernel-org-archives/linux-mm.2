Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C7CE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 19:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417226B0005; Sun, 21 Dec 2025 14:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393056B0089; Sun, 21 Dec 2025 14:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295A26B008A; Sun, 21 Dec 2025 14:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14ED26B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 14:27:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 821C513AA2C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:27:55 +0000 (UTC)
X-FDA: 84244463310.13.E818FC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 02DA140008
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:27:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TOckPfkz;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766345274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XF5P03+yZ/wmSfIv4NsJchkT6R+hudfbrvRTHo7Ymgo=;
	b=Fk9usFheeIexw0S6PNQa7VLX3QWFUNwV08d/Cobs4jcH0iholERgfvwzHzo7rVO5SDnt8Y
	Pbk8e4rkxkap0ier8HL8pkPU09gdX/JV/q3XkXj+XwhyR1qHuJBRTP2JlRgfcStZy4mIBj
	LOLroQLNJGy3KjNZeyPTYHQ/zvimqZ0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TOckPfkz;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766345274; a=rsa-sha256;
	cv=none;
	b=aiPjXlIv66lqeOBA+cisR+eXweMe4AhhsfPStuMTAsG4s5jscFZCQuvlvfE8pozUnmCZB/
	5KxG1HF+EIGIPlU5lXNV99+ei1q82F8huPcf9gbS/8BSAkhsKWEoCKaIz2c5fZqWgwDnxM
	ixwrKsov/T/vYmrvv0d/poHvThqZrOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A738600C3;
	Sun, 21 Dec 2025 19:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0983DC4CEFB;
	Sun, 21 Dec 2025 19:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766345273;
	bh=7F4TPMVb6bOzlf1ttXAT3unF5sWnabnhKyb4rPY4OUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOckPfkzVyDWVRPTUlGTXT2Y5N9C+tgKYm06vcUwNmzBNR8STdiHzelZhq4zyio7C
	 dB01Bh9JO5Z5/IHCtKN2My5ZEsIJB67JdsH5rhqQwlpBCejHkxeIioVOQamYxl5Pce
	 foeevengrQikpbKOOqbS6Xe9IJkxY7gTabg65Br1rHyrlMyT/XbtTsV/KnkDG6kaXY
	 /wrFYyzZzAwILKPHZTpIZ1P/GZJbvLQWDlTYGVRzY5owroIzhi2EVSydOqC0ZB/ltR
	 IBN1ZJM/OVayWl551QQINU9itAVnmCVUc3Z9sTvf0EhCiEJRLr6sdYbcrppgrt3RMF
	 zQ4l73tmWnypw==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Enze Li <lienze@kylinos.cn>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
Date: Sun, 21 Dec 2025 11:27:50 -0800
Message-ID: <20251221192751.42586-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC4opA5kdX0c3RrUL0g9e95JJb5hr=ZaGS7FGoQ-nxgF3Q@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02DA140008
X-Stat-Signature: 8317emed77e6649rgo6phw31we5mfuob
X-Rspam-User: 
X-HE-Tag: 1766345273-727764
X-HE-Meta: U2FsdGVkX18r5SHXcvkgZlAZDl8shPhgCRmNvcZ8uN8kSb+H9G9NVuvp42RdAsTHF8tNMapa6yT41awfCjjlAX47+x2khQjXNBDp/51NZ7oaLQuHwkem3i5fLqNmrAWMRh3rwhy42osI7fiVgXr2XaaGCVkjXbwQZyqdwtvnqaaUoCDae+79T+3RP78+KBr6v1G48kIWa2DqovwBDu+Wxge20kAJLvoxAWYBq/KKn7btL04LVn56a/5iPw4+ocmNTMcVfTigL/h3HFB2WWvcP65WLgGIF2C5H7p8MJRrnNJnZvBmBXpNYna7czdapM1pnMwCD91CCETG8cPmwD5qTPC969d+PLrIj15MB93z2ZqXcmmmXvieu6v+Og03EQLKuE9yKwgr3PL8YgkLiCHqxXnGckVt4PKfG2wz3xTqEPSPlF/ExFMYiSSj0FhfYKESHUsQ5bcbVig/dCmTbo2cFODYpIB5Ehtf/OdFyQWvfr8O3NyXe9xqoo48m3JzTHuxDrXnlyRtflyQAageQK2UqS4OvyxiZxq5ZSPME99uUMCWa0ej9BUgd+AFwTXWwwH0YK7IKr0jc1yNjkFlQKp6caKq0pyJIpYKFNcjGjdjJm1dtF8+dA05hz0vSLyqQdwof/jD3p2A91SnP0xMhXH3WjGsRoSYsd/iaSHd6bJ8nOJoYbjxCvvutor/1mNhVA0e2F96RFS0s2By+nrEP8CUGK0z8rf0A4NqNN0fKHMvZ+CMfk+pFJopGbsa11/XmkROBfKi9wCCxDLxYpvxD89jYO1B/AdKuVLN04mauYKJCXPckVutn9HTw1BY+WslHmy13uoZg+I4LXrpXJW7isznDS1SghSGDDDcxRQYFD2bvlL/SCA6u8tCDHEQ8QaHYEYzqu2Jm6+mNKWZBndX4IhLCYHZEIOvN+VGkAICM/tZYEKffaBjL37krCyf9eulqYiDUW/YpUgrpLoK5MqI7YL
 P9kn/Wqv
 4uSx9j9U0h7lLwIk2YeLmUqnMFzZD6pb5mwuzn9GS06F9OEl8yMlrfG0ymhcKZDC/RsrWxCh3NEJHn5FkrWTgB8uz0qMoAlduF0XAKRTe82CpbKoyyNWjdMHXvpWmDzCmzjMQbXGJZabzSWBOnVofzxKKNLjIbzRx0b8tBAzWIi7u90GTfNEer3PYLNXkLpEiKclfvcVLLb5qO99X83Ces6Ok8cLiFUN1N4Sb/pZbJvVhYwfSepsbkX4G09BeH15+2LBDlujCB9bI7KGNj2ZN/nC3HA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 20:04:23 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Sun, 21 Dec 2025 at 17:12, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Sun, 21 Dec 2025 11:42:43 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Fri, 19 Dec 2025 at 21:52, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Thu, 18 Dec 2025 21:46:37 +0800 Enze Li <lienze@kylinos.cn> wrote:
> > > >
> > > > > On 2025/12/16 07:16, SeongJae Park wrote:
> > > > > > Hello Enze,
> > > > > >
> > > > > > On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:
> > [...]
> > > > If runtime controls are essential, I think using DAMON sysfs
> > > > interface or DAMON user-space tool is a better choice.
> > >
> > > I also think the current DAMON design structure is suitable for DAMON sysfs
> > > and user-space tools.  DAMON sysfs can run multiple nr_ctxs, so I think it
> > > would be a good idea to consolidate it into this.  As Enze mentioned, DAMON
> > > was originally designed as a kernel loadable module,
> >
> > I don't recall where Enze mentioned so.  Could you please give me a pointer?
> 
> Although Enze did not directly state this, His patch is a loadable module,
> which implies that it was "designed as a kernel loadable module."

Thanks for clarifying.  I understand you are saying Enze's prdm module is
designed as a loadable module, while you are not saying about other parts of
DAMON.

> 
> >
> > And I'm not sure based on what you are saying it was originally designed as a
> > loadable module.  Maybe you are saying something before DAMON's mainline
> > landing, but that's quite long ago and my memory management is not good.  Could
> > you please add more contexts?
> >
> > > but I was curious as to
> > > why it wasn't run that way.
> >
> > Maybe I could give you an answer if you could give me the context that I asked
> > above.
> >
> > > When executing the damon_start(**ctxs,
> > > nr_ctxs, exclusive)
> > > function, nr_ctxs=1, exclusive=true is passed so that modules are currently
> > > executed only one at a time.  Therefore, there is no point in running
> > > DAMON
> > > as a kernel module, since you are not running multiple modules simultaneously.
> >
> > I'm not following your point well.  Could you please elaborate your point?
> 
> So far in my view, I have analyzed DAMON as follows:
> 
> DAMON core  <---------> kernel module   <------> damo(user-space)
> mm/damon/core.c         mm/damon/lru_sort.c
> mm/damon/vaddr.c        mm/damon/reclaim.c
> mm/damon/paddr.c        samples/damon/*.c
> mm/damon/sysfs.c
> 
> Above, lru_sort and reclaim are DAMON core characteristics, but they have
> a kernel module structure because they are executed with module_init().
> I personally think this is inappropriate.

Could you please further clarify why you think it is inappropriate?

> Additionally, currently, DAMON is
> executed only once at a time according to the exclusive=true condition
> when damon_start() is called.  In this structure, I believe that the meaning
> of "kernel loadable module"  is non-existent.

I have to say I still don't get your points.  More elaboration would be nice.

> 
> >
> > > I'm doing some more research into why we run modules with exclusive=true.
> >
> > Hoplefully commit 8b9b0d335a34 ("mm/damon/core: allow non-exclusive DAMON
> > start/stop") will give you more contexts.
> >
> > To summarize again, the intention is to avoid kdamonds interrupting each
> > other's access checks.  For example, suppose the DAMON context for
> > DAMON_RECLAIM and another one (could be created by DAMON sysfs interface users
> > or other DAMON modules, say, DAMON_STAT) are running concurrently.  And if
> > those pick a same page as access check sampling target, their finding of the
> > access on the page depend on a race condition.  To avoid such a case, DAMON
> > modules call damon_start() with exclusive argument set.
> >
> > Maybe this is unclearly documented.  I will recheck the documentation and
> > improve it to make this more clear.  If you find the rooms to improve and have
> > ideas for the improvements, please feel free to send patches.
> >
> > > One more thing I would like to add is that I think it would be less
> > > confusing
> > > to move lru_sort and reclaim to the samples/damon/ path.
> >
> > No, I don't think so.  Those are for real world products, not for samples.
> >
> > > And it would
> > > be
> > > a good idea to organize the core sources toward
> > > mm/damon/modules-common.c source.
> >
> > I don't find exactly what kind of reorganization you mean.  But I agree there
> > could be rooms to improve in terms of the files and code organization.  Any
> > suggestion is welcome.
> >
> > [...]
> > > > > Finally, I would like to add that designing prdm with an extremely
> > > > > simple workflow -- load the module, set the target PIDs, and enable the
> > > > > switch -- will contribute to the promotion of DAMON, allowing a broader
> > > > > user base to benefit from the DAMON system.
> > > >
> > > > That workflow is definitely much easier than directly using DAMON sysfs
> > > > interface.  But, for the reason we have DAMON user-space tool.  Using it, the
> > > > workflow can also be as simple as prdm, like below.
> > > >
> > > >    # damo start $TARGET_PID --damos_action pageout --damos_access_rate 0% 0% --damos_age 2m max
> > >
> > > Where can I find the damo source or documentation?
> >
> > You could use https://github.com/damonitor/damo and its README.md file.
> 
> Thank you so much for sharing.  I am trying to analyze the related contents
> in more detail to improve your DAMON.  I'll try to organize it a bit better
> and send you a patch.

Looking forward.


Thanks,
SJ

[...]

