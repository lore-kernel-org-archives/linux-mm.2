Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA986E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 08:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF676B0005; Sun, 21 Dec 2025 03:12:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0DB6B0089; Sun, 21 Dec 2025 03:12:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE52A6B008A; Sun, 21 Dec 2025 03:12:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADF906B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:12:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1370E137AA4
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:12:34 +0000 (UTC)
X-FDA: 84242761428.26.82D7FC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F3E8C0004
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:12:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUYGvdCz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766304752; a=rsa-sha256;
	cv=none;
	b=sUuW3nPAGZeSOicZC6vqsPh7/megQdvk/tVmOgagW/ADje3fQjwWNk4QLtX3KBck8ey01u
	a/zsx3wnTqSImC2u+6RKJ6N0wmy1eFFYkjapoR0GdK7UYHjV7C1E1W8wjLdeHopWKjdq5t
	tX9VD+1oWVcHtxB/fPyckBWNaS3z70M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUYGvdCz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766304752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w55Y+0RYhgW62bMRoad5Odw9Q2RDVB1DCS6j77dtsro=;
	b=LfMYwz/TID6xeY4yEEDTBPiqkO1EoFVaawxI9HPg40fvl8vvYtP+rsgRR25GJZISUG9jk8
	XDv8BrFr4bkL8i1gBmYU/j+z4eWs7SRl1BhwG/1ENNE5scM+l2hU0snbaxO2g9ejexS8QW
	LEMtoGI0ckENSf/eiOaeuVc+iZWvaZk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29AD443C09;
	Sun, 21 Dec 2025 08:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42F2C4CEFB;
	Sun, 21 Dec 2025 08:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766304751;
	bh=00D3OOgbeeTpnWzepbjIFgllWxUGULUtJy9deaX29vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUYGvdCzzogkQZVJP2qm2k7wNlNF213VR4ZFuthM+Z46+gHzu9lOmRqRyuVeCF2jB
	 VumAsYaRFhT6kcqf4uIMPbk5NVdXNN5jVYJyATfGp8bHkJahEqK/y+Rh/Z2nMECLy/
	 KUkuMVo7QFrVnbSCDcXCPz2v8DvSbNZz7ZVbnm29C/imP2ytipLKFFTBomzzL7StwI
	 loOba8T/HdqXQzuNBU3XkJm6kNwd9m/omBTyGTipogn3vHAU8km6QnrfGC/kvphEMX
	 mPAPru95fiDq7vQwQnbv7yMJQ2EZ0m3Vtf+IJLcEeOrBY4gs05eAiuNpUx5DmVSWBQ
	 LewBxkSMuZYFQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Enze Li <lienze@kylinos.cn>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
Date: Sun, 21 Dec 2025 00:12:26 -0800
Message-ID: <20251221081227.42071-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC7=t0iHEC-BQPZcF+KiKcc2tVyxNOLMifZQ=JwH2GwFpw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F3E8C0004
X-Stat-Signature: xtmiw6xme1xjmgnb9e4iadfpuknzuhij
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766304752-460212
X-HE-Meta: U2FsdGVkX19sdPqvaHdKFyaonWROEedeobSmc1XqMVlxb+S4Nk7pQLg5fezWfo1xSMggchehpG5PaCK8zj/NBW8N/LOYkZzDMw7mhwRPsP3uawSDnWdFHj2hwoLyR7jjdt/CAJ/ACfz8ZhJbvBw4St7h2MOhl3rNs67S7gK8p8+ihzbjK+2ROCy3Wkehgt5A2IgqGgIwOKQn+KVf/Ly1Vh4MU2k135UN5R+Rnk8XroOBPTPmnnqscJavnFk1mAOUO3QAxBfXt44hC5H8LReAayQlCV9L/DHNjgJN6FPpkPR4PCv6Ji/wK6A3Zkf3nNtlFm38DMKw1IZ8ODgzjoFIs2zCwXwbh4qO3iRWaqUvZqkrZ0T9cmWcZMt0ESCMtNwhN+Z8jjFlzCk8pqCQwjIeMZb7yNtSyEe5TgN8E1CZG713p+xJBP0/j0nw3pHddA0OOcruRENo2bcMdUpuSlL4Aey/AFbzS2bevVmxC3MO8gFVgN03GnU7FFGwEC5kkowsLdc8ADlYvMzeBS154DbA0tdci6Wqp7XShwXLrnDNECEGqCiNe9kwY6DflnIPikWhnW3KJQmons8WZ6aeibXHYBzZJlaYNQ1xAbOuYKzAvm2VSj0Pye8yiy7PbDQbSnP7K+XXB/i74zqqlRvd/hVHsQ4OgZHgzDV48fdeMiXPFllVbuuBJmUjqjCTPuDPJ7fet7lrF0OWYKo0Eim8qKkfWVJvxyBl7o3714d9hwh5KBLvzzrBFcN1cl11V+nAYzEyO7nf+hypHGP3QGm1vftZEYa2A+zO3TsAmo7jhLlTrvgbxc+kb1GlLptlhBakiktfDQbmam9FnCkvhbrf+vtPMlioMWmM/Huz+2WxcY3MSVaeFnCxK+YfuGnw6HYSgFVIalbANzDBKej6gIQylau2wqcPicFmpH9KsK3lk6RSl8z0bk7suVaXQd0l2lkmnU/EtTEcnMeyFZhaIpN1d0A
 pe47OJ/G
 ZXetj9iHlVoLVmXH3QjgEix0hlM/nJT8DfnzVWaplxhiY/RjiB+F2G5J4TvZ4c7G/pvfNj3mayOQ89nMEDKT6zGcDWB3eqq3Xl1ZJDgWKqgTkiZ9T8wyNwtzac358XjSuAvRTBhf+rOE1U9UArvF9vep/whvEPBEfkEuad9ZRrI+KiLdQRjgKs4xC0UeYT3BAv/XqnUp3pSDHJ4nhl9Kofk8DYoVdJwuF7eJv62stTWKWjKa1SGMt8/1VjGUBlSq/9E/vSqCTyOBhweyiIIWOwBKoRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 11:42:43 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Fri, 19 Dec 2025 at 21:52, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Thu, 18 Dec 2025 21:46:37 +0800 Enze Li <lienze@kylinos.cn> wrote:
> >
> > > On 2025/12/16 07:16, SeongJae Park wrote:
> > > > Hello Enze,
> > > >
> > > > On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:
[...]
> > If runtime controls are essential, I think using DAMON sysfs
> > interface or DAMON user-space tool is a better choice.
> 
> I also think the current DAMON design structure is suitable for DAMON sysfs
> and user-space tools.  DAMON sysfs can run multiple nr_ctxs, so I think it
> would be a good idea to consolidate it into this.  As Enze mentioned, DAMON
> was originally designed as a kernel loadable module,

I don't recall where Enze mentioned so.  Could you please give me a pointer?

And I'm not sure based on what you are saying it was originally designed as a
loadable module.  Maybe you are saying something before DAMON's mainline
landing, but that's quite long ago and my memory management is not good.  Could
you please add more contexts?

> but I was curious as to
> why it wasn't run that way.

Maybe I could give you an answer if you could give me the context that I asked
above.

> When executing the damon_start(**ctxs,
> nr_ctxs, exclusive)
> function, nr_ctxs=1, exclusive=true is passed so that modules are currently
> executed only one at a time.  Therefore, there is no point in running
> DAMON
> as a kernel module, since you are not running multiple modules simultaneously.

I'm not following your point well.  Could you please elaborate your point?

> I'm doing some more research into why we run modules with exclusive=true.

Hoplefully commit 8b9b0d335a34 ("mm/damon/core: allow non-exclusive DAMON
start/stop") will give you more contexts.

To summarize again, the intention is to avoid kdamonds interrupting each
other's access checks.  For example, suppose the DAMON context for
DAMON_RECLAIM and another one (could be created by DAMON sysfs interface users
or other DAMON modules, say, DAMON_STAT) are running concurrently.  And if
those pick a same page as access check sampling target, their finding of the
access on the page depend on a race condition.  To avoid such a case, DAMON
modules call damon_start() with exclusive argument set.

Maybe this is unclearly documented.  I will recheck the documentation and
improve it to make this more clear.  If you find the rooms to improve and have
ideas for the improvements, please feel free to send patches.

> One more thing I would like to add is that I think it would be less
> confusing
> to move lru_sort and reclaim to the samples/damon/ path.

No, I don't think so.  Those are for real world products, not for samples.

> And it would
> be
> a good idea to organize the core sources toward
> mm/damon/modules-common.c source.

I don't find exactly what kind of reorganization you mean.  But I agree there
could be rooms to improve in terms of the files and code organization.  Any
suggestion is welcome.

[...]
> > > Finally, I would like to add that designing prdm with an extremely
> > > simple workflow -- load the module, set the target PIDs, and enable the
> > > switch -- will contribute to the promotion of DAMON, allowing a broader
> > > user base to benefit from the DAMON system.
> >
> > That workflow is definitely much easier than directly using DAMON sysfs
> > interface.  But, for the reason we have DAMON user-space tool.  Using it, the
> > workflow can also be as simple as prdm, like below.
> >
> >    # damo start $TARGET_PID --damos_action pageout --damos_access_rate 0% 0% --damos_age 2m max
> 
> Where can I find the damo source or documentation?

You could use https://github.com/damonitor/damo and its README.md file.


Thanks,
SJ

[...]

