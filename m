Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC89CFD647
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 15:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619726B0088; Wed,  7 Jan 2026 10:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C766B0093; Wed,  7 Jan 2026 10:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4C76B0095; Wed,  7 Jan 2026 10:26:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6B16B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:26:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAEBF1403C8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:26:17 +0000 (UTC)
X-FDA: 84305543994.15.FB942C7
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0EE5D20003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:26:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ErDyIwxE;
	spf=pass (imf13.hostedemail.com: domain of praan@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767799576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbmDIhCSS30gfIV3g50RSwwLGOW3EzTKyBm3a+7nOf0=;
	b=HMUUrWhFYPsh+pGZD4OcetSo4Jj6dXBPRQH9XjOVQAjWtd/5JTib8HiX0qD9tw8a7mWmqO
	pIeVj5lb6G7+WWDGxphRTYx9rRcH/cV6jdiFPkW3YV5Kez/hoPU7fhPr1/KiNqSPcTZIEy
	XJ4LyeFn2U7ZI4kbdviweXQPcwMTx0M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ErDyIwxE;
	spf=pass (imf13.hostedemail.com: domain of praan@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767799576; a=rsa-sha256;
	cv=none;
	b=EPj3bQinsw/zyPEkXLiQAPdZnxw/5GiFYwZABVMNAVg+VuJn4DHDpUJIpTrNhW4Owk0/7J
	+l+jFdgzPJDW6uYuqZ7bJzOoiRPbIiFCrkVHymfxW8jiMlrRT3ogX8FidvSurJdLFZiJs3
	q4LpyWYBJYiQGaUJ2jMpoV80+t1I6Jk=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a0d06cfa93so77585ad.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 07:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767799575; x=1768404375; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lbmDIhCSS30gfIV3g50RSwwLGOW3EzTKyBm3a+7nOf0=;
        b=ErDyIwxEZ201TSiQVs/JNg1K/qgSi0SfHuW9+4nTo0nM4DYsJUuojsLMHaVU+Z8xkz
         2JE4djGofcFFfd68MoxDjRrr9XomdqCVTIau1iOfF6wFQOdYAId3LnIhkEGN4t+/s2g5
         pZ5WSZc0A+dLPUX6uCZlUI7qduyxymXJoQMyo8CER9spkTCH6cInADPmXrptU5L1paZL
         mG4kwiTBHpjjdCTZH9p9tg+XA+TvLGlpgnxTbmuRGHOSKi/EMeLSbq6uaPDxusgJlrNO
         ujiHcvLWKqRS0qbST4PUyBpnOsjwdrdi8ptsZpkHJbi78l2vlitBubUrE5jucwVvl5Ov
         gHrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767799575; x=1768404375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lbmDIhCSS30gfIV3g50RSwwLGOW3EzTKyBm3a+7nOf0=;
        b=WvwiZXeLOYI0R+8x3O8jFJ8/H031Z4ga0+2cjxTK6wpdYdS6+zZJeZXyqUIQQwR6Ku
         POubLEqmNb2XeWRa4IZRWKS+S+XXwmN0z+vqc4XfDP/TsAQQ5YPsi4ij5u7BWh9DU6Ma
         +Bfge0/xwFEdaIt4EXpJzq+pmDy0KiF3Sunh+KvUMrjoNbwNHD3kD1ryoi7BCipG67HL
         WY/qT+qbavNZoK+Ht2YgRtjs5uho+qvZ4BUy00/JCF46BoI/+HTc/Gtzo/Kg0r3U/ZfM
         NtAvOuL12WKDuvliXaLeXWi3cE/aNX+BrujEXxUqdwJBTIJcKBZRJZfR60TWqQOWfZK4
         KtFg==
X-Gm-Message-State: AOJu0Ywka7i09I7X+42mu7jJwdetR3uLqg44WVYeqd16cLV1TWdCFBfD
	9lmM144fHfCUqRCi2wTDJFUrgWJQBjoyLGOEQ5kpVPwkUoHN7Wy1nlM5S1E0KKHoCA==
X-Gm-Gg: AY/fxX7zZtglhegC6it3KnpL6RZl1NVay2qPRsGNuL1uC4X3SOw3gH9fk5R+1186lDF
	UI23Nu8Z8gOlKHjMI2H8s+vJwwxVrUUnzncTRNXVnJNDt/xGCvjTTJhE9mI8hUDo/qLYMg0Y6yT
	UK68o8M/GwwK2d9X8YrInfR1rhC7qk1w4aTT1+J74IoXtT/4iNv77Mq1YEuuDERJDuuPmGJbJx0
	MzxbLi3oUS/rAMgmaUB+8wGGGA68uBulmJC2du9KRfeeDHtE2RxvRAdrYotreCNUi6kzEZvYLMa
	XyuVnnEKCKG1mKLgbXgcEtaBRvxMag24WDySjJCU3JtqToUhs/zhvwChZKIyjxCUKYeHJR8TKPF
	l6AclimWrEC4HmWUP10v6UqXtzOaNypnMlW1BIbsObx/7jBbbQ2e44BqKXxIBQdkCi+CUlCsSmw
	W97wh563aMfsiFuk/lGuoscx3QSlV83ZZywQMuEm3nXH43zrXQ
X-Google-Smtp-Source: AGHT+IH+lNUdBDeuVOlZ0XFJN6S6o7z6ABkgQgy9tsTiSGmVL2tsojD37/6y+OgOeGxqXsN0knzcZA==
X-Received: by 2002:a17:902:ef0b:b0:290:cd63:e922 with SMTP id d9443c01a7336-2a3edc1a4efmr3144205ad.15.1767799574721;
        Wed, 07 Jan 2026 07:26:14 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd2b3asm53637475ad.88.2026.01.07.07.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 07:26:14 -0800 (PST)
Date: Wed, 7 Jan 2026 15:26:07 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Subject: Re: [PATCH v5 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
Message-ID: <aV57D6OiuKi2359h@google.com>
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-2-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106162200.2223655-2-smostafa@google.com>
X-Stat-Signature: nfbxpqokqtn5561a7ow67gqu99s8dpiq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0EE5D20003
X-HE-Tag: 1767799575-65839
X-HE-Meta: U2FsdGVkX18gWuLcvTbIzixS8nZrwr+8+rUSlf78zSfE7tjEoSa6boF41Wj+//oxjKHJK/yoVPZ0j0lZGj/PvKb9Gt9+DFhUrduvus7wlelfJG5FEE1QoRd9Os35LvSzI6q6meMfHzWfbw0k/IZszQeOmBrxXp3S6BrELIErqpPwARFKanJbppcDS6Af6CkaDvt/0vQKXbqrA5ZygRqzVhif4shbXlgoIVrUylo8UJ/sxwoTGoRJkE+twUjQkVLZurMHSwJB+LYZhKHOdTVWne/Ky/ZuHZtHL1TkBA6N9KbwZn5IT+9vR5qa//o/cXUE5nSA1BfP0EoVzrX52Xzw6tHkZSaa07e4Q9GBn30bnXRdBdrK/3TeRIhVY7ZNWUeLuxVrXydmrhTjIuhsVvNqUdgiHsb7J0v5vkWfIRmPZ7+wXs2YBM2X/fJlJ8nm0/+kuw39lS8PB58a0iHFLyVh59jkIoA20tmRap4cfJsmGEer9NE3NscCBu1I4d+Ls9E8w5p8HtewW0JTAYlUnGgfopnMlK0LF5tuOX3PWH4nW1GmvTwoRHRtc/QDuGOcuZwHRAViaF5eOYsxqXURRJAxefZQyIfBue1jbwYdb65pyDFUZO4o/xjlsbqKxuLmioOjVxN74y877DZbdjWLMBXUcY9hQfAzC11sXVaauSdYBXe6VonwmwiApSpw5kctylmGDqHAh/lcgR7NWnHK4k+bSgrfbD39Ud1sMLX1PrqUwo0jeXe+fPuy5pS7cW1B2wyXFS0qc6zXkc5/6G0x1TUHRcd4cTT9Ywc/qh3my8gWLBle4k320/yOjG9wxhczwwsBr8aMLG39GGs2UEgOTEExMLp3PZM6L+lE878bTkVewhruzM1u4KUKEnyNjnfxs1Rhrqz6LiaSM3lIc+pRw8C9LFn7Ivk5EJwh6RUeh2KSMfmfNR5FNRKVw5zA64939sfmzkgVKTJ7BHoQqxRQqB4
 Nxtiw1uz
 J4QkUso4i5N/1ByvUvwtQutBBJDt2QtjmQ9/DMb/8BHj8yVgejJ1o4SWmFZxDjEVQ/vONrYa0kTqdFuSbIO9tm8KekvqoJtdDO9D/0RlDhs3eWEwBlhGGngDGl601pE8mQYALE2qTakkf1bnxQUx9QYRaAytayoBW85KofGR6/3wqipYx2SGm6Kgv1lnQuLshI3I2q7lDoPzn9OltX80vhnIPAhVsID/Gslm7LwEsZfeafhk6vZp9eLo0t3uNdyZquuNMyQBTVHc3IabWueUY9L6bv2sOG/vm4iEJk+bK1lDgkczjV9HRYxGN55/3+sw12XRdYcBMfP3y1stshMB/BnciKTNo/Oqjd5k5e2BskMZXU7FB4jkxXOOC5XtuX9eB1ru2cmYidGzSMBfspqPhY5998SspGksNOAljCnjrsclpg80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:21:57PM +0000, Mostafa Saleh wrote:
> Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> page_ext.
> 
> This config will be used by the IOMMU API to track pages mapped in
> the IOMMU to catch drivers trying to free kernel memory that they
> still map in their domains, causing all types of memory corruption.
> 
> This behaviour is disabled by default and can be enabled using
> kernel cmdline iommu.debug_pagealloc.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  9 ++++++
>  drivers/iommu/Kconfig                         | 19 +++++++++++
>  drivers/iommu/Makefile                        |  1 +
>  drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
>  include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
>  mm/page_ext.c                                 |  4 +++
>  6 files changed, 82 insertions(+)
>  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
>  create mode 100644 include/linux/iommu-debug-pagealloc.h
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Thanks!

