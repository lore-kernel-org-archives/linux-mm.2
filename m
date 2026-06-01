Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14242CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D7D6B0248; Sun, 31 May 2026 23:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EEE76B0249; Sun, 31 May 2026 23:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003D36B024A; Sun, 31 May 2026 23:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E032A6B0248
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:50:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 895E8876EE
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:50:27 +0000 (UTC)
X-FDA: 84829966494.12.F903D3D
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf31.hostedemail.com (Postfix) with ESMTP id ECD0320003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:50:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780285826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6mL7/hSs6HIFYxxaWt6RnPvSkdfGzarr++ovmkSAQ6I=;
	b=IpbPEyJqB9CFMKeXWEV6pXCOUJVMaZ5uGMRZD2pJzfLzg5N2FBe3A6VsIc3FbFKjxpdCxk
	7hdjXTAWZiVXaELbemd35J3Bxw/txUMtZAIONS9tcm550gv0KQu32CVGL7jr3qk+Q5hgt8
	7rq8ZhP4EG5IzzNC5mYJcTmPoX1sn2A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780285826; a=rsa-sha256;
	cv=none;
	b=bZRVLEw/wPmzorhfUxjZJLI2quFQpSrjgrh8oRgvEHE4/1eviGv87EGh9NMqCCWV1dGsJY
	/YK9AInA9h3MEmwpY2y3H9VE9oebZU1SLHUz2nGic7Poz1Jrkk2Yw3gYHeHTfH9bzdma22
	Iuimmf09hDTFZfkZ9p+NHXtJ4HMRWgU=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 1 Jun 2026 12:50:21 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 1 Jun 2026 12:50:21 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v7 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <ah0BfRFv285gWph8@yjaykim-PowerEdge-T330>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
 <20260527062247.3440692-5-youngjun.park@lge.com>
 <CAKEwX=O-_OZ8x0UC96a_k+0eZfAE+mWMWDdn68uy1LHRq=JC0w@mail.gmail.com>
 <CAKEwX=N2XcMHN1jatppOk6wnmz-Shab5XMtTtzgYOzRvU_6YFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=N2XcMHN1jatppOk6wnmz-Shab5XMtTtzgYOzRvU_6YFw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ECD0320003
X-Stat-Signature: fumhzb1w5hor1mtr3ch84sfdkmx4mrcf
X-HE-Tag: 1780285824-591902
X-HE-Meta: U2FsdGVkX18+FkxAQvvJ1kKtbg71yM38xTAzTOkgxpTvA5awweI7en36vIP5AfcZCl2160+hZ7TVkYevZNElYuLSb9MxfQOLlJnypsgykRIAPrMOunTdH6p1CgTJNVl2sHrDTUjV0mZ0HVdwQvZ6CT+/I8n2Os4EwcitteXCiKQGPjVv9mVCXirI3dPTdAnr/upYMVPusCeWF/uvGmhpz8Qjbtue9BGORUIGfcbOrPgtUh5mgRiBd0bdTZcWHDdhMfLGlniKyONigCsD9q5ajWV4utSI3Vyor4JqJI8hGehVME4IHkpZ8jhQufarCwnlYCylgxPKHFS59G6o6FYv4HtWOJkYS/eF0YYKy48Ud/y4hsO56bYh4uQmKl4KbpWfMbOAvY3/IhqDKmSakswsZATBmm38DFANORY4h7DGBMSjYwgIN82G+owGhF3oeMLO0eEo7Sytj0TrlscjimGmnZRQQw0EswbMVcPdCoBe1ja73rpfn9yA8PwImxeB+4WM/LGz41CunwYUsJrA3jUW9HM21ILuinIsdtRFccJ1YWlOm/KH+s+tHrHRQD9kqjbig90YkjxVulXpMo0KepdVPfO3WmmFeS8pFWLoVvDWGFrgwRZK6oTuKnhgtPRTtyVTxT/4RGLkAX931b6Efj8L0IoN4r0VrAXnGnmKB97w8JB8LP4tPAZkv5yKBX21e9VxgiVTFAyyGupoLLouHVSHdhXelNfkaL2nhsTx4sBZYmYAIvRV2Znmu+bT1cjlg3/5SGYkVhixplY5tCJmQWYy064knzTorkP1URkmpBzKyJlcQira30Jg+F0zi9CtN7lXKJxHCdFKjNUzFC0XddLhsUiaaO3kF7PNfb7ph3pbRPoPwA72ydS/+3RAH1d3FX2WckH4YC+ZzQghsZtezq/66DdSR3k2xZxxrd6KBF7MI7NDO5itwFEZcJXgpQOtfVcmHsB7wyn11ZvcmoQ2eH9
 Lnzrw5qX
 FcYUXhyfXLoyM7ya8Yov4uqyWrEd0G3gzcnex584yuNHDtpKaYRoEZcHl9rc0tU4hHpmPhPSL2hd5+cNt4KWBGarq2pNOEwaCnMDjqxXMZg8Gu0jGcCq4zy1PJ0DWgOqml7xgPeKbVoxhKu+iiIBg2fpnBAS2OS4TUfsQG4+iVJQnCoJA4O58x4knafiLFaMUL3Baa5oZHSpZWoAxHeMw8YGaLh0q4HFHBguHNhoE4f2+FvXHb+6SZ1kF9pcKBi3wfM8vBiDjIhRU7cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 11:21:12AM -0700, Nhat Pham wrote:
> On Sat, May 30, 2026 at 10:51 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> >
> > How expensive is it to add per-cpu caching for each device :(
> 
> to clarify - a percpu_swap_cluster per si for every si.
> 
> >
> 
> ... or for each tier (assuming devices in each tier share the same
> performance characteristics, and could be used interchangeably?).
> 
> Basically:
> 
> struct percpu_swap_cluster {
>     struct swap_info_struct *si[MAX_SWAPTIER][SWAP_NR_ORDERS];
>     unsigned long offset[MAX_SWAPTIER][SWAP_NR_ORDERS];
>     local_lock_t lock;
> };
> 
> Seems like 4 is the default number of tier right? So the extra
> overhead is just (nr cpu) * 10 * 3 * (sizeof(unsigned long) +
> sizeof(*ptr)) or wev?

I agree. I actually considered the idea of a tier-centric cache as well.

You might remember that in the previous "per cgroup swap priority"
patchset, I implemented per-cpu caches per priority, which is essentially
the same as having them per tier.

However, as you agreed in another thread, including this optimization
right now might be a bit premature. If the core swap tier idea gets
merged, I plan to explore this optimization further as follow-up work.

Thanks
Youngjun Park

