Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6A1606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=lAzga9KQ
Received: by kanga.kvack.org (Postfix)
	id 962A76B05C1; Tue, 10 Nov 2026 23:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9192E6B05C2; Tue, 10 Nov 2026 23:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD4F6B05C3; Tue, 10 Nov 2026 23:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52D386B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:37:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6D33C0202
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:37:29 +0000 (UTC)
X-FDA: 85421579418.21.3C8E92F
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id DED4E40004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:37:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lAzga9KQ;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqUC+/6z93QymM4YxzfDDeUBQDkxF93aItbIpXtMw+w=;
	b=xHSGv4RE3tZ/36wJURr2xdT2y4aD/bxiSNq3dFkcHtfFuJWU12OFi8Db0NbB9sSTjCK/oL
	9YVrSgCkkhITB8h6wJqy89EHGKhjYuubKqaV5q6LF/UD5o1ZvGetD7NNNOADX9RTDuAWbu
	tP4jUCG/WK/HmlIEPxesToiv8E7Yc/E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lAzga9KQ;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371848;
	b=AzjWuc/SVOBWWh9nhYKFDyE1phBfmC7OH4EMmHw0Q5lbYP/0CifDsP/JcJLU7KLFM2oZ+G
	pLBTusfuWS/zAXa/Gb0UBdt5BY4MMxwTwot6/tVYRkpdDp7eAa9jY7ewLt/QlZv5Oz2fP4
	a1WipOIoJ0c6k7QCIDjwCaUvlheBVNA=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b0d09df973so2177373a91.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794371847; x=1794976647; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aqUC+/6z93QymM4YxzfDDeUBQDkxF93aItbIpXtMw+w=;
        b=lAzga9KQrDQBBVltocKop56w4oubBLfTEc/qmlmVH8G9oyilw4Itm4jdJMUOCmA+Hr
         lgD34PZl7jfDXU6aL6A70+QbaUAVZ8+kxFozC6/7qsm1uOIdTMmG8mjAMrPC+YQsg/uK
         b5ZEzka4IZtE/uRGmgrx2MJfhP+Q/82tso4Rk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371847; x=1794976647;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aqUC+/6z93QymM4YxzfDDeUBQDkxF93aItbIpXtMw+w=;
        b=tk5VUjVAPu2EOsFADa2kMCzR1bQdPdmsbeSuMzZKS4nFBFJDuwjOxFS+3tsn5mPJyC
         FZHMrocw8kZ7fHRv3vznz12aPlF2Q5oVQeS/uS1Z+NTKLGteLzJRTjdogaA/PnwWu/Gw
         tcwsC0tToQhdZ3Pqyb58q+c4oPuFarYPgRCXifxzF9yUCvPchUzPKr1d9pWBKcJeKEeQ
         c/u0ovt9R++RAB5XRxykOl54A2V0YMmwGHO20KLaAWIjp7bpIDbFq7+i0Bh+UAQwBvbZ
         801Y0GyaGJsf/djF45chpU0OZ6feoUZfyO1QX7mjmpul26KP/K7AW4Yc+quSTVg5Raz/
         hK6A==
X-Forwarded-Encrypted: i=1; AL+hErE8vXaU2cmKWWC70m1I0glhw+6SkIkWyO0babXuNEtGCwHk8m0kKchAGGte2NPw4ncPwsjUDLRoAA==@kvack.org
X-Gm-Message-State: APuU4Z9zuK5OpZd2Z1rc99om8vxlzKJJcJ+/SWQOBioxk01B7/HITEjE
	wLgfm/UWFCG1/lWhfiyHMk7GcVowULg7cX1ak79v6qqG6JmG9SmZyWyj1UznUeIwLA==
X-Gm-Gg: AYBFou1gQEYrURCnGUSyTxbd68nvnje0MD6LP8lOWeKDiIbpqizmF2HZzF3s3kiXNol
	1xfVfrq17K6QAj7kIpjZSqV8ZztVoLjQB5Ef6yTo2kPnFnj7z3BcHSI18MYD78+mG/D3f17RL0X
	0FI+Z0up2arPwb1ts+bk89i1RfSDIz+MB5NdyQrCr8ObI1E1jCELg6cLqNGTsFhI9TuWp6dkWAK
	uRvvANDUFM+W+jMPhbO9eXNr/fIWxzA+BrV124wzKh/JQEMpgV2JC4nPQwFJ6FbcZf2mm6hCxko
	bVE1CMbuMSZUhBnOCcfpGznb51ypuSQLeObWNiIW+AcXRg5YDsU34XSwnmFJjttpVyvK/rLgqjQ
	c6fky+R5AF9dLF4qxZymhWNuEpMSca2VumnLs+CgiHEvr9iPWhvFvBYLQObRK4Va6AhLRFsOFvX
	feOu/6+XulaQ+4YEcws5rC93uqQLbTofLZQMy+pPzezQ6mc9YAfIhHvWP47HHM5Q3w6+hEcBjMB
	n6RhPQNgvBw6fs4vXRXDdE6Pm0CLzvfeT9i6qxlsrDIUxXqS9eMOWbm59kzjoy8y1Q4ZKF+W8hZ
	R0xDezb7XHjLff6gSVv21Gr9OAFqb/4VjKh2rck7WA3FngxAA84qW/aobCD8o7XbmaVSRQ==
X-Received: by 2002:a17:90b:37c3:b0:3a8:59d3:5317 with SMTP id 98e67ed59e1d1-3b182ebe741mr1582140a91.32.1794371846525;
        Tue, 10 Nov 2026 20:37:26 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm1509639a12.5.2026.11.10.20.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:37:25 -0800 (PST)
Date: Wed, 11 Nov 2026 13:37:22 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: remove CONFIG_ZSMALLOC_STAT
Message-ID: <avPw3zBWbqmKE93R@google.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-2-caee41684aba@gmail.com>
 <avPvrCY3AywQRz5j@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avPvrCY3AywQRz5j@google.com>
X-Stat-Signature: ypz517t775i53qbj79ftqrd9rhiz6ui1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DED4E40004
X-HE-Tag: 1794371847-806078
X-HE-Meta: U2FsdGVkX1/axsQZscWr/56uQFM2HagfTpdfEflPeUr4bWJg+vUlhwengqonD80tAnecjUrhen8DOtUH5GtvqPqMYJ+Ro/QkRlKIvOKrmOaA0opfWZLiAH9QuWX4E0/FwlSgAhb/3zBOLQSk/JwwNDJchDMMmF867uE2v6L5H2NKHEM9GUHv4Zw+kwhnjUdjqO/gxsdox6NRyvQ/JMloKuwHTv3hRvWuS2rEe3GmYmFU0+Xc8j5i8kpaScc9EVEfInDGe6c6rpR5YIG7Y3jbDQkbQffyTqqoyttEX4qd4SoTE0dVxhA8e/J56naPoaM0ye423YgrA9t7XQDQaL9WCuPLa73Uygrzo/wYY4xRwKCuZ7ZloDztsV8I3pTnUoseK9+VB4VnMr35Qeo1yPCjgvg+dDXzf/5zPQDZAhd1k+34+CTcNYt5M4vev4VuhAFAfyOhkI3fkgajsHRUnbSPRSH5QMfnLyvm7/4ngJwsgai1w+pMyo5SEiuY0LfPtfOOvs42U52ysEGEAFkZ8N3E0a8Mq8t+50pcnE0nf5+OkCrfAA6Wffwo4FqcyXtwSBIwqeGRgGpZAYPAxPsUmAp7sJHdDYSQd5UbsPHmcN9mv0wY7bQfnPtOH+AXT0nsmJwvbySnXD99+FSnEm9eJCb0LSILPOdfK9AArznx1UT7E92gEb5QU4hBzvVD8Wgd2fRAb4lZ1yBzfzkwASDGHH2GO/M/7FusGy9mjb9C5YFYA5orbzinKGzDHGLHUJJwlImQ8HdoFPtmaccGi9neRVqsRbNIsIpu7bTqCVZNHr3ENQH3Fgc4/ylavSONwOl4b1SaMnhBzum2rAcFqgh8HWjnX3XvxJkTj0IZE7o7+18IXJLsO4NjW8Cbt3QWi8JshtxEgS8ztR0FYQdrXeXalAMkcrQpS03c+xVpiUQnEqR+YLL9NCE/DWgyggLLYC5LM+lpNLtbgRZU6pOd7Mbbs+r
 6WVg+uYr
 qFfNv9Qm34lUnWpkXoIsBsBBdzRFJcyZ+9NB0DKGie+s2kwx2Sc5okRX0qTqyFkZOKYADhUQGhsc8rEQOSIrXfZg/KsZA7J3SQfjW+2actiZyHk9c8QaydiDQLDs7kw458xpDGSajl0rcW8AOBCw5bZfqHT0Jqi4BMd9ZGWFBGxFS3xMqQtBHsQffT/JlsFbJKXcjmBoh5G8hmUdN4Od8ia6Sb5pcRwbD/0chvyLHoYUDy3TUpVYAgErjv6xnhuBScDS6jzQ3jEqIVzfp8SUNKGJYnRMPlYauRNDhB2bCbNryd2fD9u3EMHW1wuSvArngC4kEwaSFVlXvb4LIRNYNkyuDeWNTtp1ovvSt8/fDGDYQnaSY5bQtfLN+sg60pYvEAF4G1S+Ymd6+fI8Y+eDsdLNgp49imV1WNlqm04uL15t6LuJdEZLMF7iAgVjZTpzep5+Fizy4CgMgpuInAW6WPNiQIuMkxxrh8C6k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/11 13:33), Sergey Senozhatsky wrote:
[..]
> > diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> > index d44674b63715..83193ef8efb9 100644
> > --- a/arch/s390/configs/debug_defconfig
> > +++ b/arch/s390/configs/debug_defconfig
> > @@ -100,7 +100,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
> >  CONFIG_IOSCHED_BFQ=y
> >  CONFIG_BINFMT_MISC=m
> >  CONFIG_ZSWAP=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >  CONFIG_SLAB_BUCKETS=y
> >  CONFIG_SLUB_STATS=y
> >  # CONFIG_COMPAT_BRK is not set
> > diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> > index e00e252d4694..694a309377d5 100644
> > --- a/arch/s390/configs/defconfig
> > +++ b/arch/s390/configs/defconfig
> > @@ -94,7 +94,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
> >  CONFIG_IOSCHED_BFQ=y
> >  CONFIG_BINFMT_MISC=m
> >  CONFIG_ZSWAP=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >  CONFIG_SLAB_BUCKETS=y
> >  # CONFIG_COMPAT_BRK is not set
> >  CONFIG_MEMORY_HOTPLUG=y
> > diff --git a/drivers/gpu/drm/ci/arm.config b/drivers/gpu/drm/ci/arm.config
> > index d7c51670da2f..fc0a8a4bfb18 100644
> > --- a/drivers/gpu/drm/ci/arm.config
> > +++ b/drivers/gpu/drm/ci/arm.config
> > @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
> >  CONFIG_ZRAM_MEMORY_TRACKING=y
> >  CONFIG_ZRAM_WRITEBACK=y
> >  CONFIG_ZRAM=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >  
> >  # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
> >  CONFIG_BLK_DEV_INITRD=n
> > diff --git a/drivers/gpu/drm/ci/arm64.config b/drivers/gpu/drm/ci/arm64.config
> > index c46125c1f80f..10b01b55a66d 100644
> > --- a/drivers/gpu/drm/ci/arm64.config
> > +++ b/drivers/gpu/drm/ci/arm64.config
> > @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
> >  CONFIG_ZRAM_MEMORY_TRACKING=y
> >  CONFIG_ZRAM_WRITEBACK=y
> >  CONFIG_ZRAM=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >  
> >  # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
> >  CONFIG_BLK_DEV_INITRD=n
> > diff --git a/drivers/gpu/drm/ci/x86_64.config b/drivers/gpu/drm/ci/x86_64.config
> > index 7ac98a78691e..8225b806dad8 100644
> > --- a/drivers/gpu/drm/ci/x86_64.config
> > +++ b/drivers/gpu/drm/ci/x86_64.config
> > @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
> >  CONFIG_ZRAM_MEMORY_TRACKING=y
> >  CONFIG_ZRAM_WRITEBACK=y
> >  CONFIG_ZRAM=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> 
> Really not sure what those are.  I'd rather prefer not to touch
> any configs at all.


Never mind, scratch my last comment.

