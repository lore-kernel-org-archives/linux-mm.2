Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC11CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6476B008A; Wed, 20 May 2026 03:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97016B0092; Wed, 20 May 2026 03:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACE76B0095; Wed, 20 May 2026 03:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9B4E6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:15:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 475851401AF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:15:12 +0000 (UTC)
X-FDA: 84786936864.30.3B5F4D8
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3123440008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:15:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CUiLEEns;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779261310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYOJ9GFvOFI2LL52SOYreIR2jRncnDyPiCnAUZkvQc4=;
	b=1gjUU8dHj4E5LiQzSyctUdj3yDiXl7yQcSFjpTzJJeAs73/xlLHBzJuVa9hXkfs6hLtP2I
	6CtR+RbW8f/BaTFEIv6xwerNnEyInXF8B9U+hWSPWqVaywM+Xg7SgsWlb+uWQ66VUHWTax
	g4N+bU9y8gfWZjSxr4G+QYicrbKHmsk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CUiLEEns;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779261310; a=rsa-sha256;
	cv=none;
	b=tuISALPoJRgSViRqQ8EZvKBYhhY/dLfgL1Sm2a2OVz2A1Nlu7RBfykyUWL/d83fiXfn/Ha
	1xs+yEL/HlAHHDldA7bKNVL4zIpN4UhIxcJXYNcMyssvGhYrvsdTGQdgcdcw4wvOr4gBSO
	W8+Y2q07a91AK5hP0N3UyZiGZImdpis=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a8704dc3a8so4835824e87.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 00:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779261308; x=1779866108; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tYOJ9GFvOFI2LL52SOYreIR2jRncnDyPiCnAUZkvQc4=;
        b=CUiLEEnsW31iLmotF/5m81J/7wAVJY/m9b0+KfxwpsDqzo8NBGYexbFqdGeuQH57Gh
         Tn8+VhRcuQS4CKfjkU84A5sbhjmFttFKQYk+som1PWsglhHhvuymBldHWAq0g+zcALnA
         m5T3jIjbXgSl+UaXjdSPbbBDJsVsmlPa9j6YmITFnBt4mzdGt2Y3IRzoUmG3s/Q53d1g
         zYa9kF1gUrcF3L02PGKN8YmpsZWBXucAbwMuK8y6ZzwLOb/4QxJeQQ6nJYcYuueHSyQ5
         vqIQjj4EUR1bCT48KzlFgeIV4c97POh9sqjeGEkZNzA+iIqmZ/DjicDXfAQqE0nxlvpq
         FVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779261308; x=1779866108;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tYOJ9GFvOFI2LL52SOYreIR2jRncnDyPiCnAUZkvQc4=;
        b=YL/8QiErJTJn4SevFUGrCXr/j+CalI1ytdjJBQZ0DteFyGQIaswnbqTnpYD0JEXDL2
         7x1VpE64COvzos9F/RKyNvgFK6Q4iJWzuWTA9F431Hl3sQEZfLw5ApTiPM1HinY1pXAN
         rN/bN3nAH/ao2d+YG8Uhu7xZtvOnu9WtE/+ViVkM6pmvE4T6TqNF78Vxjn1yT61cBMiI
         nxS6VnYZSWjNrmBJTzY4QADwyV0HJFg58PjvTxpE3hCLTpWGMcnAkBrZmuvJtxSOnd/0
         CesOFbFcwVF5Vbymg3R3gQ5VKn2UkxO4tVRlYSnw495Y+bk9qIseG/Dgrrwfy5ViceqL
         cfaw==
X-Forwarded-Encrypted: i=1; AFNElJ+nXj+ADeqLdwnv/s6AINn40DW0dd/HDA06eGUfUUQ5dVCWyhU8fA8Pgex+F3uKlvIkAhQM9BKNTw==@kvack.org
X-Gm-Message-State: AOJu0YwxWl35wJ31s+WydPTZkabupjMpH0jhR7FdSdwbGecJ6xCj5m/7
	zWEwTpVeWMOYpDlgiQpbMQdeMrdQ4FScClCSFthYfzLVcBSTMQN8Cg5b
X-Gm-Gg: Acq92OFTVb1yP5e7Q++hl6VYPMLEdgENsh2VmDjchPMtQszJZLB4kuWf0JKPmc9hWWJ
	bevT7Ol9JqcBz1I41FS2obJP5UwyTCwGqPozf7WxBQXskq/wg4bpD1hcMUHwY1SdRdM0W08yuOP
	NFXEFOzDTLn/RPBoyVCoz14BBRNoXgJe1vTF8UxZsMRmNCV0ptki7cniVcoPKYNF+AhJA62rP9f
	iTiYjJM+0kU3nOh06fjfQvc1/dR61ayb5YMEmEtKO0K6BIqtHFmtgtGHpMIDxJYQ6Wlw2RM9mSX
	ytNQEEbeMt2nAGL7lhC+XUf4olmJjwd9puoHfs/FLJZvgomtA2m+RRLFUn1PdXL+0cKQCRRC2d0
	ymz2THM3MdF+O5cKaI3diSHGiNjMhWYRMl7SSkddu3aS6RJqHgMRhvvWuc5K7dbNZtE4eOYB3BH
	k=
X-Received: by 2002:a05:6512:695:b0:5a8:f984:1541 with SMTP id 2adb3069b0e04-5aa0e7640c7mr6248441e87.37.1779261307775;
        Wed, 20 May 2026 00:15:07 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a90f10c944sm4837460e87.6.2026.05.20.00.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 00:15:07 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 20 May 2026 09:15:05 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	will@kernel.org, urezki@gmail.com, baohua@kernel.org,
	Xueyuan.chen21@gmail.com, dev.jain@arm.com, rppt@kernel.org,
	david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
	ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: Re: [PATCH v2 0/7] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-ID: <ag1feQwK38vd9i72@milan>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260519131738.11a78ba88e1be28ba5cb26eb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260519131738.11a78ba88e1be28ba5cb26eb@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3123440008
X-Rspam-User: 
X-Stat-Signature: t8bajxh4frusyxrykxei7yxjcgxm9wj8
X-HE-Tag: 1779261309-240922
X-HE-Meta: U2FsdGVkX1/TA343gOTdAY2KwmCLHb7MXf2YmcrMrkJwaEVQm9ZBFohVebIMQ7iIcJTQnQ8CrZmikqVW/tokDlL5/1CW68lp/Exqwc8zTv5Jr3i5/VlHJ7S5InJQsc27re0DQpNGHRIbvnspaumGlTlaVMJGu8QmSofuo9bcapD/krYzITAyCOJX4802S/3b7O8HUQ1D380jRJ2rebw2+dUNqNqyHTZq+pv9zBqCEnMZ9lic6Hwodt99eay5GF8WgiusYBrDTMwmHgAOaeSbngU6ERtugwpwtfwm/C1Iqeuf+v2urKXLUhvSucne38lx9zXyaeAhTzkWE6DwN2Ms/BjAGzVRCFZqofvYa6ZbIhspwBHVqyA9XE5BkUZtZij+/ertdEToKW5vwl0JO0lZXBX81Nr5cYtwOxfCpp7D3PECuoyJKeq1vZtkjkkErmnKhTS76hNTrYAE/QHXgJbj5AYXSACQvkN35QxUgEcVdiK+ZLm0X8ZZi3L10v9otrQgQs2lhz1Fyl3yPpKomdENAIvcAS/iScR4gSHj5daY0aGFWHXImXXqltPs2NNdZt+BaC9rYen6jwDVzNVoH74jlStNztp0F+XoQsz7M+uzCP6lCdtQ0/XRirpQqQqUrWFauI14jlbxs3w2fUUQiIMzQpa+4XuoxH+fpd6ydcIS0UMiveFJiVnI/EF5ItBOvT+E5IZYIk5f8UVH5R2jMFDcJO83+dD2Ykzf4mRq5F54alIh5/xbwfpQ7wyIIXa7zBU0WTvYF8rxjS/9/qKg9SaFIPDGaduRm5jmKNZBlpYnqAPVawxkuO+/THF7DL4mgO/C7BvqTDkrnvNzAwoKB2W283tx5xL2hgdVTFFYg5W+hPg1cE8KBbp/+5DtoUVKYyOEzAT0cO5D0swasfzCoVLxNfAoEZVJrgcE4VQZZB0l0MAUZnXrZOkLzxReo3nQBewqz4b0dLOweipno1MXyM0
 cdYVTGVq
 ScM6mxz2t2FTkp4k5Hst7bJHA8Xor/NJ95PBWyO247JsQxF3oz/6OqqKf5Yzx1EdmaxjaHGJbxY7zah1yMN3xuqdnU9TRJ/tSGHHmZgHoVghqvRnFzxWRnQAuR6HPoLmnUv4PI6Xqf9ibvSf02CEEtyX1cqd7v29Gweq+dLkEPT1YSjjxFC51DSOpF8bFtSe7tFqOJj19Sj5TiCKFUJ52SK0fO9bfPyblHqRasPEWKV1vuAZXJJ27l73S+USUFm04BGYm93E8p0/UpeM5JDoEc4RZWkrGdf59EDQLQ3UrcAFG4s8nB1c2ucow45TH1AmsGxuBoN4I3t9zCnP14NsQs9qu/J9u9mDO+oMyy1MBpl7/oGUUOUy+qeq7w6YmYBYRGYkc82XLocLXhSlOCqq6gPN1yrHHfNYEF9tmIz0rNLEWxUretr6kkngGBLimySdFfDLpKf+5IZlTs1RFe8EdCQA/9hs7cU2tQW3LFp0ep5EHTEY+r0Rq4XYUYqSquXYf/mIxz7deazwP5o10u81jCMz8FE90Ni8PTMt/1qiuEE6e2yng+R5DvJF8vrCyP5gpH5/wxQvFrCz6edGKgeQugeEavVbBM3Il+yW/rQ7v8kjRGKjQFLwV8T4f9kOzqCg9LW3jYcLnFToL9Fs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 01:17:38PM -0700, Andrew Morton wrote:
> On Thu, 14 May 2026 17:41:01 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
> 
> > This patchset accelerates ioremap, vmalloc, and vmap when the memory
> > is physically fully or partially contiguous.
> > 
> > ...
> > 
> > On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
> > the performance CPUfreq policy enabled, benchmark results:
> > 
> > * ioremap(1 MB): 1.35× faster (3407 ns -> 2526 ns)
> > * vmalloc(1 MB) mapping time (excluding allocation) with
> >   VM_ALLOW_HUGE_VMAP: 1.42× faster (5.00 us -> 3.53us)
> > * vmap(100MB) with order-8 pages: 8.3× faster (1235 us -> 149 us)
> 
> Nice.
> 
> AI review found a bunch of things to ask about:
> 	https://sashiko.dev/#/patchset/20260514094108.2016201-1-jiangwen6@xiaomi.com
> 
> It doesn't appear that you'll be getting any more review on this
> series, so please check the above questions and resend?
> 
Actually i keep an eye on it and i have done some stability testing.
So, just need some time. Fixing AI sounds good.

--
Uladzislau Rezki

