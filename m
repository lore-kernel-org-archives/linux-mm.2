Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CEFB606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=I6OZmYRm
Received: by kanga.kvack.org (Postfix)
	id D05286B05BD; Tue, 10 Nov 2026 23:33:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EB86B05BE; Tue, 10 Nov 2026 23:33:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56EF6B05BF; Tue, 10 Nov 2026 23:33:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 693D66B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:33:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD3531401BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:33:44 +0000 (UTC)
X-FDA: 85421569968.09.6ED9D04
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id DCFB0A0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:33:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=I6OZmYRm;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtHR9MeyGTyZM0OihaH+eIUfUqxCL6ogGNdi0Oy2FKc=;
	b=QSOEC9RdOOLOXbMIgMYVH+rX9xUb5GV2M1/ypIKf0cTG/9UHMeGp4/JdiRzzB8KekU630q
	gZ9MiDIqCttMuey7pcO6DMLsc65qP4gMZZeuUTdd21LCSHS9CQvLPEHb2HmsTwkzAhqC9X
	uv39hV+tex/tSpruBT/oE5Gigkp8dGg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371623;
	b=LQ+1EILaUR2L04IP0myk5F+f/IEQFuFc8MhU8ZnhHmvifuvRp3vE1daKEGV7l+JyXaP5Cb
	hZ9yj1IyDETZNSckqfBgRw0N7NAj1PYFtzxN+BqDKykjk5o2PySxAECd6/RdTA7u13WiwD
	gzgC+dzyB6rvJogEQw8s6hWUBAecDnc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=I6OZmYRm;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b09a83d12aso1911437a91.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794371622; x=1794976422; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GtHR9MeyGTyZM0OihaH+eIUfUqxCL6ogGNdi0Oy2FKc=;
        b=I6OZmYRm9DrNNUPe+G3KNlV2MzIjiLWY2n5DQ/W22dDl3MVVV+gh7Nuc4k0Iiv5A7C
         OmwopxwwvORjUMsrE0Ee+wFrACDIHVTwQcdCV9/CQIvmh4WTfeOBFnEAo9XUKiYNOzbF
         8i76ZIOOfHYUVmaGCEiZ2pjJtecrudh8bIlT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371622; x=1794976422;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GtHR9MeyGTyZM0OihaH+eIUfUqxCL6ogGNdi0Oy2FKc=;
        b=UvLU9sZe//4d/Ul1zMNIi8kErFocghJntBNyxTL7jgEL1cZGWQkZNm3zYRaZDL4akW
         yFotKSwP5d+z/0nK4yuuH/rAF17xkjePZe5YposuGs06TYAoHQsK9jsDxlN65c6H9RUM
         XYqvg97RsYWxm8tKKqJn2Wlf0yOi+T1QfXvy6wdPWwzpJp9NGg6HyhagYeJQHwWFK/Ha
         5J0mcoKj0W4+aF4YSGiIRgoDMoOoxbfmekuDSvnB298geunGyTnTf2z+2Ss+UCvVuuwl
         uoRntPKhjOSFtOa9q+hQbWU/Gn5RIkOmmmUy9FoLkZJaBGG5M4lB85J7RSSgAse2KRUb
         nUZA==
X-Forwarded-Encrypted: i=1; AL+hErEM7K/fFI4XMMpaPYJCFVWkAAQAB7xamK2o3ekjwvvErXWOtJOSiaO7UDBEnaGWZ2TggPBOqyTu1g==@kvack.org
X-Gm-Message-State: APuU4Z+cuhK3V12irPFPsa2cUpONKqPNr09PufDnXOyIKe2zzbNlaKm6
	uUI1vRIM3uHw+IrRnsEtE8lBv6JuOOW2EQF/Ued+2rTJdJRSdOihPQPfZrsTb8p+dA==
X-Gm-Gg: AYBFou2M9azz3Wy12CMRq7c2Wq/o4x//1oKSZRMI/D7c0IO1Eobb7ULBpkvZW2deKjj
	dnIgE5jH6hBL4CQU9k57gf72rGciev47nmkv4c3avojf+l7pURuMNC+YXB/4mXre0KASwY23Bgq
	AxBFR1lrsIJNOO2YtV+McFyY4bxjGyCkgl6Xx63LYMhhTkwLAO88VaF26nDUIsiQOMoVg9GyKmn
	fd7ri7kZa1xvWOgBzZNDQjx/xrxiPUTdlNWjAZ9tpyjqeMwMTV+cVwIwI+AhqQRrsf1FAeYRUG5
	j7k4zWdbL53vZCUEK2SY6OZK9+Fb+hRkVj7xEudwdO5nrzxCtXon4Pm+lcqfz/l3f8S8pawDiD2
	+NwI8to3dpi6V368umEcKoLR3jgrincxRCMgBWTpSgnQbHnCA0v1S1X0ixwjHU/XMcNWdUcHRwM
	dKgKHvzGvMRTzVKdoaAvqlMW8zc4anusfc1XX/8Db2LMnfNgyNVuP0713quRTqp2FQJsxrcqEBr
	8ZrIFQ1nul5XCXwFOFQviSWdfFhOMCEeAIMazXzU2uFGuX/RHlKGMpAAVgq4CRjcvJ4TnI2MLOP
	gNglztR7KtZ5by4x+xbeZmL7cLmAa4Vb8qhmCK+Wld0h8qN5I1lG+0Lulghr+xkIqseG2tmH9dA
	/103e1i3nrF3lKbw=
X-Received: by 2002:a17:90b:35cf:b0:3ac:d79f:8229 with SMTP id 98e67ed59e1d1-3b182f6767fmr1165692a91.61.1794371621658;
        Tue, 10 Nov 2026 20:33:41 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db7df7csm2506547a91.11.2026.11.10.20.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:33:41 -0800 (PST)
Date: Wed, 11 Nov 2026 13:33:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: remove CONFIG_ZSMALLOC_STAT
Message-ID: <avPvrCY3AywQRz5j@google.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-2-caee41684aba@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-zsmalloc_stat-v2-2-caee41684aba@gmail.com>
X-Stat-Signature: 5ckjprezy9yf6kjnm4zj1cppdwfeeh5g
X-Rspamd-Queue-Id: DCFB0A0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794371622-710599
X-HE-Meta: U2FsdGVkX1+e8DAMmEjzron/4sAWuezvodu5ULim7xUSZvuSyqZs2sLXQ9VqXvlY53ckTY0wdvVbn6crpXdohzKDEBa18Tvr+5SP96+W3Ubfz8Zr7yT93odanAM4Nd3cL98aTZh6HJBpPH6G0Q1QpeJ+15XNsF2iqfT1RhdFjiuJGeQROVyclSRqXEVRrI/4ypFQgZHebHF1qnVYdSLDN8nCbxP/+HwanE3Hoa2lTRYDmOskU0Len4WXL9gxgcqKpsF1bo4dRokMpaTnn7GFiOE226Yeo700jokhD1nPoixTsqtWbb0w2yRwRZjXW3762bldiJRJF9x8/PenDeBNDPLBsPe3ISBW1IvSio7uOoKsn7Ll3PM7HLI9OgzPwwcLduQ8fIY7OlPSbsLbOR3lIXbhphBXvhXbD0cCLml6BNdh5KanXw3A4Gxx78UJnOvDYOKbMYmJ1WWdMzXt9FmCr09T7J4WX9RsVPvBxOH4lo3vb9ebd9bVJtnlVzVn48EVyrFEQRZpa71ilsyZO2yiqDl9w6dlVWfLH6o236m+ooLJ2fmZLv32x6AKn5K8nohsbtBIJLYFk828vIa3OEbw9bUg6UtCgJxbYMQFf9oNjoj7I2wx3/BLNZDw+DrLPOsswU4RraHZwJOpfh67G5E2fiLPBPkU/thI94B8uNlZCQL/jjSY9274k4CyUwC24zcCf5zaQZd500DkhHANuU9WuXH6sWqHsJsxxxizQgIH0H22EMLlUFnJJ8y3ag8eH6ESPxaU1Z8hq/jJVOTWiDd30G4jXah5KMmQzOUJVex1NDkhkAkeUDgKhWshXiRuriLzlhh8u4F0aZkF76Tx0Nv+KnB5aCTIbKaOY7vKi5RzLYJSaanNtOX/wFArD5qdcYgevJAlt8ocu3l39cjQKrML1w9VHoEByD7UgLyA28jBokmMt/Mp9zsO15cpkIfvfawTO0W2UGbpEHH5UOfgWDv
 notEonKb
 f4A+u3D5DnX+MgmC+5MjxX+qRBn/StxMyNMac2p4GWf3J5oii5V34VwhWLC1K1ftQxIOKmiPAOd5asL7C29bqRkcLHlfPPCHtxF2onTfBVqZaNuNY28LcQh8z3dMRAXY5t41qPQdJDzj56xRnjo4KkYucsNXNYEC1TufJVDyOxO3dEmbVhl7+adWpIGo6yjxHpGjXX0262/MA27sGk5q/w9sIVahbPDO5bcw81/doFolJq8H1mD/BJWdBf4avYvDsy9t1ssb7WIquWErqYa4xpzEgwaatvU4Lhmzdg9Zsznxwt86VUHwZMeYPwS7uuHbV0jSuqrUUesFlv4MRUhYTpRdJRCOt3mx0NyHMISyjX3SNLae0AqVKGm2pKkBi2Y7qI1R90Emp/JaN65p28wkpM0uKrpDIc4nUQvt+qOU+8tcvApcG66akDRt+DwSCxec6ToRiJzZ+8pa8WsylmTzFusTTqtG9cuatWZED
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/09 20:59), Xueyuan Chen wrote:
[..]
>  arch/s390/configs/debug_defconfig | 2 +-
>  arch/s390/configs/defconfig       | 2 +-
>  drivers/gpu/drm/ci/arm.config     | 2 +-
>  drivers/gpu/drm/ci/arm64.config   | 2 +-
>  drivers/gpu/drm/ci/x86_64.config  | 2 +-
>  mm/Kconfig                        | 9 ---------
>  6 files changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index d44674b63715..83193ef8efb9 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -100,7 +100,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
>  CONFIG_IOSCHED_BFQ=y
>  CONFIG_BINFMT_MISC=m
>  CONFIG_ZSWAP=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>  CONFIG_SLAB_BUCKETS=y
>  CONFIG_SLUB_STATS=y
>  # CONFIG_COMPAT_BRK is not set
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index e00e252d4694..694a309377d5 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -94,7 +94,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
>  CONFIG_IOSCHED_BFQ=y
>  CONFIG_BINFMT_MISC=m
>  CONFIG_ZSWAP=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>  CONFIG_SLAB_BUCKETS=y
>  # CONFIG_COMPAT_BRK is not set
>  CONFIG_MEMORY_HOTPLUG=y
> diff --git a/drivers/gpu/drm/ci/arm.config b/drivers/gpu/drm/ci/arm.config
> index d7c51670da2f..fc0a8a4bfb18 100644
> --- a/drivers/gpu/drm/ci/arm.config
> +++ b/drivers/gpu/drm/ci/arm.config
> @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
>  CONFIG_ZRAM_MEMORY_TRACKING=y
>  CONFIG_ZRAM_WRITEBACK=y
>  CONFIG_ZRAM=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>  
>  # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
>  CONFIG_BLK_DEV_INITRD=n
> diff --git a/drivers/gpu/drm/ci/arm64.config b/drivers/gpu/drm/ci/arm64.config
> index c46125c1f80f..10b01b55a66d 100644
> --- a/drivers/gpu/drm/ci/arm64.config
> +++ b/drivers/gpu/drm/ci/arm64.config
> @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
>  CONFIG_ZRAM_MEMORY_TRACKING=y
>  CONFIG_ZRAM_WRITEBACK=y
>  CONFIG_ZRAM=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>  
>  # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
>  CONFIG_BLK_DEV_INITRD=n
> diff --git a/drivers/gpu/drm/ci/x86_64.config b/drivers/gpu/drm/ci/x86_64.config
> index 7ac98a78691e..8225b806dad8 100644
> --- a/drivers/gpu/drm/ci/x86_64.config
> +++ b/drivers/gpu/drm/ci/x86_64.config
> @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
>  CONFIG_ZRAM_MEMORY_TRACKING=y
>  CONFIG_ZRAM_WRITEBACK=y
>  CONFIG_ZRAM=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y

Really not sure what those are.  I'd rather prefer not to touch
any configs at all.

