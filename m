Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC01109317A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 06:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C770B6B03AE; Fri, 20 Mar 2026 02:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4F076B03B0; Fri, 20 Mar 2026 02:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DE86B03B2; Fri, 20 Mar 2026 02:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A402E6B03AE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:57:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 348A3140897
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:57:09 +0000 (UTC)
X-FDA: 84565534578.02.4591BD7
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 590CE40009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:57:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=itAORN16;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773989827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uB3o3s0T22p//pHJUM9GCy7rvolCUexjSjOz2UT6Tjw=;
	b=cOtg5Q/5rTQpnl47ulLcyuFAFFbPwmhXKhubwZhs2WK/OkCOhNFSG4tZUmMTaFW5mM9X7M
	PXqAmvphkJYNk3NOslg5/VhiUcLu13LcZGhS6Fbt719jrwa5uS4FMkUs3zyYjrTg3d0Vuq
	ZFcPqzCcxaZAvdXUVi2W8JuwQ1NyZlI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773989827; a=rsa-sha256;
	cv=none;
	b=DQzezQgzAydIivLjDNwdTZmtwEKdTPJgY26sbvgo2+xkYzNAzhdnqLEZCP58MlGVROPkTy
	GqWkHzK3N5/uo/F71efvJvMWW2KuRDNPd3yTRW1TlY2KLAOvP4xxf3vuxUt4oDqwzkmnA1
	X6dZ9iHk9ujtv7ysVQ5NyXzzDk5oZek=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=itAORN16;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-358d80f60ccso1029852a91.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773989826; x=1774594626; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uB3o3s0T22p//pHJUM9GCy7rvolCUexjSjOz2UT6Tjw=;
        b=itAORN16Lamg//1H+qgs5Pw8RusuVaQM3tCmBVnxwgqU1jA62/KuTSQ4m6Eyvt152m
         jbMIShA6pB7MAKPokEcqJrS7O+odaQ4oFrMawT5cHqqqc6WULCRb8KeTbsKdtAe8pamt
         2KbmL+s3Lwb7BITIh/CdHHsOdbWbDBw54MR5sNYlJplWMejGuhmC/n0BNxBaTfaaqF13
         FdFHBH9FYHAkk9gg01GX5b2buev4VWsJk6UmYJ/51KRtsCsF6tYdvpvGRbOJF/7hcqfb
         J8MSAUWPkclhWxirgvY4QLd25G8H/d8SpJWL9v02gXwgw5a4d5ljqsjJ4/GTZkgVYKi6
         xo7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773989826; x=1774594626;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uB3o3s0T22p//pHJUM9GCy7rvolCUexjSjOz2UT6Tjw=;
        b=eI+OraFzWiSwRLZDW6F7//Bbl9D7CtTpSRri0tkxezdn218EVhzhKPURk0sl3lwZE2
         ZCyJBOhL0XY7G3bcZIoqOixDheEvdg8nCRS5QfyADwmzlmhfdlYRKSnmyMym/1Hiw+ef
         fFyPHozBCUl3Evw/9V1oj8VkPB8kEd2vKJf+3VYXCStpAqn+FnMyX1P/7YYfWirCfXJT
         2bdIXOMmniytSZQ2I8eRwhoJ3jobgty6cy3aHUWiHaeU1FfcgTSVMs4Qhdbm12xG4D38
         Bq6yWw+DnfvySiNhL4bKjFizuY55uFEhhO3al5dynIAn7Tssv0axQwhsMRHoXjmqId42
         MOUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXF2RRv5Fc1q/++jldOMGdKYf3ss1gL3CatRTwZR9NujKpuFn7W0DzExCfcT9QR7fHwf1BoQnfJJQ==@kvack.org
X-Gm-Message-State: AOJu0YwaCmKERaLOzpQcf3LmtZAqCRO/2W21Zq6WmthR/zfe6pIPRl0r
	nrL65s91n5drz2fN2fv5nRyJEmAMV9yp/IyX9DnWG4jPQZVDi5GUn9/f
X-Gm-Gg: ATEYQzz+7J66vvEQf5y7zXo2nLqu/CuPRxSpqoEzsss9FyZtW0lizKtfOB3aYCRD5Rr
	HxFNRcxfdkttupEF9CjFysJdgH5VEnPz2khLnc4pYTNwosRD/ek46/CXCYebR4KWQA4d/vEMX5J
	JXleNQjVMj5Bjhr41osYJDQSXHgIfHo5YKgWQYO1O4plgd17t8GFBlpvv216r9hm03H4hVhVXav
	C65K1DUcBmLi6GrRIh6pm4oCx+EdWfZr1pcbNrkoBFizG5tyXAmpLjsXfE7D70lEnKEHD0KGKQQ
	2Y3vZUC292ZN+HjvF0R/x3oR5mJsazUBSkx28DgeKCZuX53MuCWKI9ClafV8N/ViVKu1tvRcjwp
	LDOmHht3OTlFzX0QX7RoqhyCAriLY1oZGNIcFwZk++G/VYx4jWkEGD/raEiuUEnoh2VszopT6d5
	tHSSMF66NzWH/KPXHHC+OcWtigZcwCOm7ivgUPBj9+8sHNRQGpz1TM1+oGsW/A89bAIVbM
X-Received: by 2002:a17:90a:ec8e:b0:35b:9777:8bb1 with SMTP id 98e67ed59e1d1-35bd2cb2acbmr1551565a91.19.1773989826091;
        Thu, 19 Mar 2026 23:57:06 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd41347f0sm948262a91.17.2026.03.19.23.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 23:57:05 -0700 (PDT)
Date: Fri, 20 Mar 2026 14:57:00 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, hannes@cmpxchg.org, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/swap: fix swap cache memcg accounting
Message-ID: <abzafIPJbGMeZlGa@KASONG-MC4>
References: <20260320050601.1833108-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320050601.1833108-1-alex@ghiti.fr>
X-Rspam-User: 
X-Stat-Signature: 6smyzktcne4onfq1dyfrdp4gnwce37a7
X-Rspamd-Queue-Id: 590CE40009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773989827-101149
X-HE-Meta: U2FsdGVkX1/I/w5HcpXgpdVjNE8VLFT1YG+gjJuifS5VOmRVTqLASGdSfsA8qBkKHv6BFn51009yLcKYNDwxg7hqNHilOo/i2f/YD41zGDChoVfnZ6PPsC5bVp5CAnFCHWXI1SUDj5yjw9uvYDFuiEeK/td4O4+xFo2+3su+vKYL236Xf9P3rOhO4aZl4IEs+36ZoMmXfwgrkIzeZBiw9ViqCVNIn/D0lknWzzYqDCf+1sDRj1qnlUxoLWXDfEQg9PWBDvu3dExL7ToJE3dlwVQkaZagdp4//cZS76J29S3Z1S+NQdFY/85ENY5OwfUe+ga1SAkyOvM7v0/EYF4SxgllmXTvXzrC9EWhG63MiG1YqOUPbbL9QYA9ykakuNYXMzVI+Asyi1ViM7Oa2cYsACh20/59kJj3kImjWQK3/Nxq4zQyXoUkAokAlveou+4VNRPlx7L/tFhlpz8YeO75tEPyUMMLMuYTeoI2cp7LH3OjLvI+pi9M37of8+0Z3eCfDgrevW8UFPUDEuAhCKKyh3qz1QwEJnceW+vzCFiweeZDPZXqALiSG2T8SCFFGSS2/pRh88k6KmPa1663MgoMxtLmddJv2STMxYBRnPe09p+6b0pSRpatapZW8VE4yhGyVsVBo0dJ9DI23rkVMFuwPsHGS1ObWuaNCTyopAFweqYhKtuTHnN+/KwpYsRRNXc55a+A3SQuciwBCT10L3pnUaj3AYKG8H2dsGNIABSdyeCK0U0l31MxMtG7r52wy1KkZSy4/lVBooVTi7RPiV3sVzRPHlSUKdd/u9+JqkTbBm8tXdzxC5/ao12XoUO0e/mVR+W7SEIBxfjaInVdMxrhwSZ8rYKqO5zJYQLPycUQQ/92TC6bHd6H0JXEYbvhV+snLIOdw95JI9GwfpRL+6xrj59zSvKEyaTA5xr+lYe5EwPYJra/wrqJi9edmmM4jKgrNnNf2QpfHhxMRFEsfTW
 O3Dh8+No
 ori1f2YooVzx0Xfb0pWIL82sjOjFdNgnZYCEuYFwwM0WDGTxy6nQ++63Mvt8U/qWEXsrjK2z0dJwpccnuxHctfERX7JNANAomMuJg4pePJMPzMm+4TGNRpzkMxu4gYsbYUpBE4wB6ioA23aVw3sBqkuUv+YIM8ut+qrbQVx4kTrSZQgSlh6UNgSvWnDK83y8+7vex55jfWGZC2hcSYWBuGzh/hi3DAB7KuGJ41Pnmd0AQJY2jIg8fQSX67ZDAFHzoIX3uGMryaEaj6Ghv1BEn/AiSneuZuqsRTHjnck8JG6szFqNnUXkf0c07YJ5ki/IaeDCQQU0b/1Nqd1Hqk1BCduMiwt/YbA+AjJhVXEae8WQxw8CpC2oEyNOrVQncwoTyGs4QaQeaFuabF/hGZd8Dq8rlcTWgK+W99nvLhjMafMomenJ81vwZ56ase3KHJ8V9cPaCCJIux5YAfJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:05:59AM +0800, Alexandre Ghiti wrote:
> The swap readahead path was recently refactored and while doing this,
> the order between the charging of the folio in the memcg and the addition
> of the folio in the swap cache was inverted.
> 
> Since the accounting of the folio is done while adding the folio to the
> swap cache and the folio is not charged in the memcg yet, the accounting
> is then done at the node level, which is wrong.
> 
> Fix this by charging the folio in the memcg before adding it to the swap cache.
> 
> Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/swap_state.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 6d0eef7470be..48aff2c917c0 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -494,6 +494,10 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
>  
>  	__folio_set_locked(folio);
>  	__folio_set_swapbacked(folio);
> +
> +	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry))
> +		goto failed;
> +

Thanks! I was worrying charging it first could cause thrashing, raced
swapin will cause multiple charge and failed one will uncharge, so
I put the charge after insert into cache, completely forgot about
the lruvec static info part.

For a quick fix this this is clean and good enough, and it
doesn't effect the most performance sensitive part, mTHP and
ZRAM would have `charged == true` here so they are not effected.

Later we can move the lruvec static info out of
__swap_cache_add_folio after the charge, maybe I'll do this with
someother follow up optimzation together, then everything should
be perfect.

And I think we need Cc stable here.

Acked-by: Kairui Song <kasong@tencent.com>

