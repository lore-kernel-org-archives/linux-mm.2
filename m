Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEDF5D4A5EB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 03:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CBBE6B0005; Thu, 15 Jan 2026 22:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A056B0088; Thu, 15 Jan 2026 22:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085F36B0089; Thu, 15 Jan 2026 22:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7F076B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:18:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9076590F7
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:18:45 +0000 (UTC)
X-FDA: 84336369810.25.AD445BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4450F40008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:18:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tYWr05Vq;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768533524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYdbKP96ivtkfBj5J0K53L31USCjKjGpmExmW41xOpI=;
	b=4wJcJjdo7a5P1LzZRMQrxb5XidF2ArjEcy+tZT37bakLwAh7xaG7G6G8df5S+rMk3ZnGxy
	zAK6EtJmVpw7wRJi8OwVxYavgaOB4nCzbmSgttszaIz3K9iJo4Z3KWzWLjuuQxennECZSn
	y5DdiVm474eC78BfhKDvPhNs8YqbHfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768533524; a=rsa-sha256;
	cv=none;
	b=pdZ3cOOLyJvV0mQK97KMWlysXqDgJlc++mN8SBN314fYt1n9fphj01h2deB4+mbd4a/huT
	PWzARAbfeEWQzxvBeuLEXvK/b0K7b9to2O0ySB60MCky4QdqaHbpPOqweB0VSgg5y9wjZW
	u1smAKfvXRuyJPahE4Et8V1kvpZvC08=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tYWr05Vq;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF4CF60167;
	Fri, 16 Jan 2026 03:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B01CC116D0;
	Fri, 16 Jan 2026 03:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768533523;
	bh=KEsxUSnwjGF4pQxArZWJG8UMArvuz7FnxwUyaaReGms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYWr05VqUGfZCU4UNdsPkbnCkKzql6AFkxRBrIge9Nay2wl9ZhP93gID2fwWkLoxu
	 QC2yQTBVAinsMGdpwouXACSdaPKDDyTyo/HSYnjDe+3LRhj6w7mm8pkdnNEEmSwZLt
	 c9bhJgetOIuabcEBRDd5gSpuYpFrgAbY/FvPCO773e4i+Z3MFnyoryEBUR5tZX3Vn5
	 Ng8Eo0NnZDYMcxKbnMx19DM1lHhie/UtN152LcesqeQ5KVRFwF2NxdKFw881V+n9q5
	 V2wzVRiE3vcehY5Wpvs4uQmgJ40wcuBPriuKAymjVGbg4ld1QvA6ymlDXqmwPXG2xT
	 sTHXmU2/WEIMQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rgbi3307@nate.com
Subject: Re: [PATCH 1/2] mm/damon/core: modified and tunning damon_split_regions_of()
Date: Thu, 15 Jan 2026 19:18:25 -0800
Message-ID: <20260116031826.72372-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC4kktZ5rvPmJKpeHkOznbmLAxB1GfowU7NgLc1EUA3-hQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4450F40008
X-Rspam-User: 
X-Stat-Signature: igt9119zrrgjy3eitjz4jw5drna4ih4h
X-HE-Tag: 1768533524-317648
X-HE-Meta: U2FsdGVkX18TYruerYriiVCR3Q+dBwuVEAV5EyTMGYey7rcuRVW61YtBxGWHoqk3xNOlpEx/edF6dU9kB6pnYE1QymZZEsbuu8B07TLH8t1Z1pEwXzD8m/c0eZ9bVodoAQ0bSwcNj7mzVvQdprvr6QkUgqniyPRxoiaFcEvnhK9yPwd92L60S1mZRl8AgrgJvx912+1xPWXc5mqP+z9zIFmmCM9DotPKazzB6lj6mTvLEisYjO32BhLXOtExI3rXbIJXQo/sfjpRl7p+lfnkL3dbOWGixWzBwB7sWDXRdaNYCOm2SImFzjdtpRExTzd2b07i0pcYzQIGVLG/vWiJ6DlNLqUNhbzpSi+uCM9Z/+FRB7bd3qmxSEuF70WsTPcXKT82W177lEgDKsAcrcWUqBU/sKgXqk4Sln+eEejIn0H3pP78N2wszYNlI8Y0Bmn3z0nq2cJEO0X2HkMUOoDeaomDo+5HszfR03d3ZgGI/mMmCfESdYfvQYw2YX1M986R1WJRA8ZuuRgWPfd+NKk3GsY+8xl5ygDfm7V1cGr5RJjNtNkF+hiDi9eG8USEaBZi+KiVKv5MCLjep8m3msgiEN/M8Y/8XWgqOw9ReuBAI0p7Nf3nw/qNpjjI7tSSe4f8lQEhct3Cokp4JrPEM6/OuC0HX08sQIBurNB196ftVtusBN3qVefnHhO8EPuSwr7ODjG2ox+Xp4zaLEaSy3bMHQ+CiDTolLTH+5IxAdXivt0A9I78G7IHJH9Szm+921nEn8jNB+5+b7lhq3L0LmsVaQZ/wjhMFO8FEqvPbLWRveUac1NZ1FVw668NuL8vA2IVXyrGR/UlesKjj31m1jhlnnL/673Mb/mvC2L3C1N01qrpvBJH2XwNMw2++3JjFT4Dt6kZASABJmILpF/JPosLirtAUt7d6+OySh5hzGZlZYgyJvYqIIyFqJ4r1Cx1gUM99b0Nc8Vdj425nnQNl0a
 uC0C0IUr
 khKKG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 05:18:51 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Thu, 15 Jan 2026 at 00:46, SeongJae Park <sj@kernel.org> wrote:
> >
> > Hello JaeJoon, thank you for continued interest in DAMON.
> >
> > On Tue, 13 Jan 2026 21:16:42 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > Before modification:
> > >                                                              sz_region
> > >     |--------|--------|--------||--------|--------|--------|--------|
> > > nr_subs:     1        2        3        4        5                  9
> > > split random:    <----------- (*] randmon        LOST -------------->
> > >
> > > When dividing sz_region at rand, the random value may be small, such as
> > > 1 or 2.  At this time, there is a problem that only the front areas
> > > corresponding to 1 and 2 are divided, and the remaining back area
> > > becomes too wide.  If the area is too wide, there will be many missed
> > > address access judgments.
> > >
> > > After modification:
> > >                                                              sz_region
> > >     |--------|--------|--------|--------|--------|--------|--------||
> > > nr_subs:     1        2        3        4        5                  9
> > > split from   <------------ (sz_region / nr_subs) ------------------>
> > >
> > > It is recommended to divide sz_region evenly in the ratio (sz_region /
> > > nr_subs) rather than using rand.  In this way, if you decide nr_subs well,
> > > you can logically match the number of divisions and their sizes.
> >
> > I was thinking about how to reply to this patch.  Since it is taking unusually
> > long time, let me add short comments for direct future of this patch.
> 
> After much thought, you ask a simple question below.
> 
> >
> > The existing code uses random() for a reason.  This change might break it.  Can
> > you further explain what was the point of the use of random(), and why this
> > change is not breaking it?
> 
> To find a needle in a haystack, is it right to keep poking around randomly?
> 
> >
> > >
> > > Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> >
> > Unless you can give me a convincing answer to my above question,
> >
> > Nacked-by: SeongJae Park <sj@kernel.org>
> >
> > Same for your followup patch [1].  Btw, please send patches of same series as
> > one thread from next time.
> 
> I sent you two after much deliberation so that you can see them clearly.

Unfortunately what I asked are still not clearly answered to me.  And based on
our past conversations including the recent one that I acknowledged as a
communication failure [1] and this thread, I expect asking you more questions
will not work for me.  I don't think that's someone's fault, but obviously
that's the current situation.  I will not ask you more questions for the
reason, unless I get a reason to change my mind.

So, to make it crystal clear, for this patch and the one you posted together,

Nacked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[1] https://lore.kernel.org/20260101224420.73826-1-sj@kernel.org

[...]

