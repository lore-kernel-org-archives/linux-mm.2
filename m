Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86958CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D043A8E01D3; Thu, 30 Oct 2025 10:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBE28E007D; Thu, 30 Oct 2025 10:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2178E01D3; Thu, 30 Oct 2025 10:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACD668E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:36:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58D68139322
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:36:05 +0000 (UTC)
X-FDA: 84055030290.03.08E28B7
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf21.hostedemail.com (Postfix) with ESMTP id C9B241C0014
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:36:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761834963; a=rsa-sha256;
	cv=none;
	b=b5/HpjGAbH2xiRspU/CKFcNAIhRSkprwUaaE5SnzRGEcwHmpbGWUtFfr2/IYT28QWI+mlA
	EvxA/ZeI3ebUIr6Ytj7pQNvNfxeVBfORO/30mJyPm6lyRfaaGeykfpvr2LPPBCuMSyDw5w
	CxMiNtOkuuR6tfMI1MwKxQaFq1otFvw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761834963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=soAyB09a4gRCbozk32f+xkpt8RLEtWcbpHzWpcmIT3w=;
	b=Y24nBvjnEnayRH/7VdjqkPINiZgpQKhVHlv4qo03yNsEM3QgsqWRRwvNXDSnmhT5AA2qMh
	80GfQFLsvmjpuGIVdZgxwd7oP72lUadmKubBR3L2tew15x/pJGFYitymCmbHPgJ3qrp3xJ
	9OBoa7aYqYe7fS/KnbdkP19oXlLkgtk=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 30 Oct 2025 23:35:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 30 Oct 2025 23:35:58 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
	gunho.lee@lge.com
Subject: Re: [PATCH 2/5] mm, swap: Use SWP_SOLIDSTATE to determine if swap is
 rotational
Message-ID: <aQN3zrl1Dru8zPwo@yjaykim-PowerEdge-T330>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
 <20251029085659.2005942-3-youngjun.park@lge.com>
 <waqpfeubqf5sp4qqt5pirwy42rmtb2ld4d3263tl4nlf677rp6@z6va3qr5lwfo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <waqpfeubqf5sp4qqt5pirwy42rmtb2ld4d3263tl4nlf677rp6@z6va3qr5lwfo>
X-Stat-Signature: 8amg5twxyhjopx7a4b9gnay34uiq9fn3
X-Rspamd-Queue-Id: C9B241C0014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761834962-331289
X-HE-Meta: U2FsdGVkX1/pNPujo7logXK1BLYHYK0r68O/tp2MafUT/TVWX6JlwDWuBJFb0/5YEjJJOVdcfHQ4aLmpvy1A8HCSQS35dt9BHzxdlODW9JPxSggkmzGxnm0EMBVttQU0UmdYYFyGHGANxNQmouX2gfCsOi0FCcFmhdGcjnnjfSk0+eUemGI6a5hWTFBJxXvE+5nmHsKMVz3oa1kcBtOksU1S89FZTaYyWgk7KptO+wC/cumrLpNutARO+K+jePPBmRJrN/oIYkI8JJltVpN4/KNa0sj9CKLgpDKEzpLZUx6aRsKRKR4dvppQ8ReX3jX9vAxuBUyrB9MUr/RdpVkbMF/qHlYHGtPOfKA7/7pMvcaUPmCOV37OaIoF2OrauVliEYgOeOMRgugoYS0RnLU3oN2zxyvF9NcjIgiD1S/3KtqD21U5uglczBgWW5uD9HJNec1tszRSOL3jwwS95sMF3waJQ7dLTC14pcJXDoLaZPhtPMECWiewkpL1R2D5LRjlm0UqGc9vR+HUavYyhUL3nB9Y/IDK7mBv/GivOOHVtyPWR1+58cwVTEYJCijnjJaXBIQk2RFYJtgqRGmAd4xFrOAZTSFgBB7TDZ6le/bkoVACwvx1Z0ZMGcA3S6hmqHQaqbDJB1QIP9wpyHkFSBAZ5TZI48QlFXtWK0O8kfac0qsH6EFMyReiWM6x15pyyDr4k7pKJm0R1L4wBoJAagGfBGMixYkms00LgyhmcuIOC1S2ecg8t1t77I3oottVeClozMgtRZPQ49QkEqPK6Rypi19ZctY0qyrpjpcx0R/Uy38qnwlBvqwQZcRBKZPKDbXvA5A6ZZEeDfOr6FG5bLjtF/axREUNSONtRnG35SnC+hjW2ZpxHQlGASwfiV/eMW3MiruPL8C0OslxbnUbbR52KgCKYOZTHRUGmResbnYrjIBbGFVETI/MgLRcYdG4dbIEf8YCQ4GXwHtyxwqFo4l
 lrgxKSqR
 q8kVmU3JrKlj4olYatOnM2dbusXVc7+yDEcZnODLLtb9RTVK5ZQc3Z+pSdWgn6xpS08+egFXgJgHwDz3kOKuSBgCLUyyUzpAE9xJ/HDVf5832f86LAimBKJHWVTzpGlGksXnK1WbNltO9YBpRaZgBcWngP7xzEa2oRhOF22/645mqBVgur7mDjUxngfLjke5j35neaPJyaP0M3uQHh3/2yBTuP0y5o2tIMJKChzC7z6hckC0UlNjTDENYsQAyw8uUcy8yUhqckbQ7la+btj+tM9zpCkFrliw/kzXp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 12:09:29AM +0800, Kairui Song wrote:
> On Wed, Oct 29, 2025 at 05:56:56PM +0800, Youngjun Park wrote:
> > The current non rotational check is unreliable
> > as the device's rotational status can be changed by a user via sysfs.
> > 
> > Use the more reliable SWP_SOLIDSTATE flag which is set at swapon time,
> > to ensure the nr_rotate_swap count remains consistent.
> > Plus, it is easy to read and simple.
> > 
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swapfile.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 6dc0e7a738bc..b5d42918c01b 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -2913,7 +2913,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >  	if (p->flags & SWP_CONTINUED)
> >  		free_swap_count_continuations(p);
> >  
> > -	if (!p->bdev || !bdev_nonrot(p->bdev))
> > +	if (!(p->flags & SWP_SOLIDSTATE))
> >  		atomic_dec(&nr_rotate_swap);
> 
> Good catch.
> 
> Is this introduced by 81a0298bdfab? So we need a Fixes: and backport to stable I think?

Okay, I'll add a Fixes tag :)

Thanks,
Youngjun Park

