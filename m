Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF1BEDB7DF
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 09:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790016B0088; Tue,  7 Apr 2026 05:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F426B0089; Tue,  7 Apr 2026 05:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655A36B008A; Tue,  7 Apr 2026 05:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 541AB6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:43:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2D36B7A4B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:43:20 +0000 (UTC)
X-FDA: 84631271760.11.2E33E71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 43976A0011
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:43:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M8vGXNiL;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775554999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3G/mnukwt+jo7r3Qp7QylKY9PKqMEjE6FLsH5b6yA4=;
	b=fQpDGET9WY7vjUG5WoYugv7faKQ8LakmHmCjVI3W6iShA7FtMaLt2VQHwNK6jnVSMPxeju
	ZHaGGrys6zJPWvJAU5yes08xSa54YdFvysxPrfr59FmIf7viL4IhwZH3LXLWCh44xWB/63
	D2WXYU35UOIHYXKOGs2jAkEfEYusGuw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M8vGXNiL;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775554999; a=rsa-sha256;
	cv=none;
	b=3I/i1+nxhjVFQa54XOsMeHmJiG2blbc0Uatgt0RTxfjwpJg7Ctkkrz7BViLeJk2pxgb5r2
	/AxpSp4xiJn7dIEGmuKHd9JajmrCXhY69YLjAueMjRDVbPM4iGvKwiEkiTetEMw9V6WgYo
	eEWmyn078bABXzk8fZztqIWN0E+U2tA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14A24416FE;
	Tue,  7 Apr 2026 09:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D096C2BCAF;
	Tue,  7 Apr 2026 09:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775554997;
	bh=YgnbCZ/PlXqZfBNZylsy/NQmWaxBLGRGqWF3Vx8vf2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M8vGXNiLZ4uoTTuW/1OzIrvqrP8aTwkJHYrLRW4RN0yvsEeEf4sa7nmL9znUdjY2h
	 /COUlUvjP4OIf5nBqcmLqJbEGgEYxO6R61Bl8KJ9fE58urltoaB/ndm7+0FDrn7x/N
	 oBp/wjqkhzAehzr9B18xzI6h2RY9Rzm3iUJuilnjGx/vsKVqAplg3SWuabgoQUuIYZ
	 B83yy4zFM2SHk9Y0KESVhA5TvrgPwNi1b9Z2jwZlPE1RTo9uNxOGpYgEtIujH5AuSk
	 vqubOBW0cweY0Aug77PlDNAesXkjZ9xXLD+AiexEmli11drGK9ZaQypvkdEnqvgxwk
	 kN01hq29VEWqQ==
Date: Tue, 7 Apr 2026 10:43:12 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, xu.xin16@zte.com.cn, david@kernel.org, 
	chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
	Michel Lespinasse <michel@lespinasse.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
Message-ID: <adTRPwNMzogT1OYO@lucifer>
References: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
 <02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
 <20260405140132.3a518740c6c1d68843f44aaf@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405140132.3a518740c6c1d68843f44aaf@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 43976A0011
X-Stat-Signature: u4a97n67mi8dwb3ajdwze3a74a85ksxy
X-Rspamd-Server: rspam06
X-HE-Tag: 1775554999-884580
X-HE-Meta: U2FsdGVkX18AQLmmHH1P/xg9DAeg1BTPb/tuaV/OuHGT2rTWJCsJFlSReEKwwrSc5iHufzY9C1AXM5fU5jsqmb36LYar42e+JPft004zTHJmUoNZCuBwXWQpP46qxncBy+SR7JGGz7EkYy/pLE+mBd1SwSfjHOP3Wfb6lrksZa5rBNxAyHrxIHxFQGJPfG5y63tUvZRwJae6nzGy01bW0tPyRtUU47b/0bWqXp2l+6D+Z8QPj58zhYDhT6y+nin70u9abqJrd921GsN/khYqD2fR/DQZ35crvSAN8QRpTHy088HWCt8jgz2IddQhLVOc8irjRSY/egyAVv8E00q/q9EzRytua42t6rBw2hIQVmniosgkM+Cu6QK2lXUL17/VmNnIAzMbBK0Ny0Mitc2Ut/ey2qx/m6IOIFIqnniZRKGqcVEp//RUiTtSWx4Z2qnNJtvg9qL7LYFeHjrGYkTz2UdMNSzE6pxlFzXBxs4aEGGBarO9d4DmhXUUVU9E6FgQNdyoQYeSaXJ3jfJhuODhm3sik9JTyClbkNQTJU3rLaJ2nwrUc0IvBG9MQQ8krvBTjW245Z5R2af5ZxHp5A2KfjULJcrVDyJfl8XXjIIzIkaQmGU5u5OboQ61LhqLLMPZYPqS3MBNspLvFFI+9H+FT15bB/dcPRJZ1FYPFGZ/C+A46m5YY1W5h/S7yuxkbA0n7PmQSuZ94LWFdK+xDJBvaW5q+I5NVIWwQQ1XKIqvB076bb3lo+Pq6eaP9BZwJgpjGHtEqu62N2/3zgkeZmPQyaNJoK40th0FCMVaLjojDKiiE2mZ3qmfQLMmzwBPfHvNE8h24Q8cAjj/dt2006ss/7uybYAVBKJuCAhiIJOjMsu2I75lssmqeFOSmYrpMUjeZkksMWsI+fgwsT15E1goLS5GjaDO3gnrF0VKkerXejGqWiqimHUkHCJGHajrpR9YO5mGbF/iENvtL4DyaFd
 jYGPO2rN
 ZggqS61ShpZCdidtqIaaLjNtlPuqGzicXAcCd6A4O5/y8GsbhfeQYPJ4UqFUz/+gJZLWZqpYyAnijD/GrO6DnP7hYrwCDZ5r3OgJvMEzbq5+MD7BrfeDo671xQllCO2bHKAr/Dlnh+lSltzA2UltpRtJvu93hjMjh3TEkMP6S2nAQYUnP6zyw/PYxz8IUW50AS+Nr0yn3bIvC2OTFUlqFU0kgjq8+9TrqS3avxPsx7eDT6FXvIo6PeLz0cOU2YgqRtm2mEXDqR+LkPb2h7QT6xsRWJpDJcvZdPeafpsBD621xZ9/FNIw3M2+pPa0L4sEeBeIR+n+pd8o+AiPBMIXEFjLCaKB0U7ZynShioO0RlOWI/JsKCkxrNNUFy+/xFGheYyG72ONcAkpJ3bA4ykwROxthaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 02:01:32PM -0700, Andrew Morton wrote:
> On Sat, 4 Apr 2026 21:44:14 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
>
> > This is a very attractive speedup, but I believe it's flawed: in the
> > special case when a range has been mremap-moved, when its anon folio
> > indexes and anon_vma pgoff correspond to the original user address,
> > not to the current user address.
> >
> > In which case, rmap_walk_ksm() will be unable to find all the PTEs
> > for that KSM folio, which will consequently be pinned in memory -
> > unable to be reclaimed, unable to be migrated, unable to be hotremoved,
> > until it's finally unmapped or KSM disabled.
> >
> > But it's years since I worked on KSM or on anon_vma, so I may be confused
> > and my belief wrong.  I have tried to test it, and my testcase did appear
> > to show 7.0-rc6 successfully swapping out even mremap-moved KSM folios,
> > but mm.git failing to do so.  However, I say "appear to show" because I
> > found swapping out any KSM pages harder than I'd been expecting: so have
> > some doubts about my testing.  Let me give more detail on that at the
> > bottom of this mail: it's a tangent which had better not distract from
> > your speedup.
> >
> > If I'm right that your patch is flawed, what to do?
>
> Thanks, Hugh.   Administreevia:
>
> I've removed this patch from the mm-stable branch and I reworked its
> [1/2] "ksm: initialize the addr only once in rmap_walk_ksm" to be
> presented as a singleton patch.
>
> For now I've restaged this patch ("ksm: optimize rmap_walk_ksm by
> passing a suitable address range") at the tail of the mm-unstable
> branch and I'll enter wait-and-see mode.
>

Given we're at -rc7 now, I think we should delay this patch until 7.2, unless
I'm much mistaken wrt Hugh's concerns.

I'm concerned this is a subtle way of breaking things so we really want to be
confident.

We should also bundle up the test at
https://lore.kernel.org/all/20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn/
with this patch (should we find it's ok) as a separate series.

Really overall I think safest to yank until 7.2 honestly.

Thanks, Lorenzo

