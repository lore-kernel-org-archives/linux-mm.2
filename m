Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE14CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 20:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5747B8E0016; Tue, 11 Nov 2025 15:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C008E0002; Tue, 11 Nov 2025 15:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488DE8E0016; Tue, 11 Nov 2025 15:26:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 370568E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:26:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0953C1601EA
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:26:18 +0000 (UTC)
X-FDA: 84099458436.25.9FC9B42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3673C20009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:26:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YISalZIK;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762892776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2mw7529ZlO8+K8F55dIh+NeDO9Yr5NIUZrnJ6I9CyA=;
	b=vLvzvonLUFWKneqLsxlVsI9gHtA4/rAhZQa8VNbUEXAwiESJuLhw/ClDOMeJWZ2Zw/A6A0
	sGIM+qwBrSA4DE6fBZIHkhCKXMTxDxk2eDXH0YGiDutBbC4m0lU+B/mzioD5Lbdq3xrGhk
	CXcs4n5Uk8IZ/8mdHrIro9Y//MexGPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762892776; a=rsa-sha256;
	cv=none;
	b=0KiM/cz1fV/x7Rx708LIJ17ne2nDJogQCHEUn5EVggHEptBZbquypFanTHa8wmQFbg7UPw
	y+BNWqY66xQBm+Z4trWjzsKH+uYv0ZQp94YMsLA3AJaeosq1SF3fd7Fcjihh3qAWlrVm1B
	TYPiN3UfpaW/sU0eVQl7FqXpBo9MZJg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YISalZIK;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2ABF641688;
	Tue, 11 Nov 2025 20:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8212C4CEF5;
	Tue, 11 Nov 2025 20:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762892775;
	bh=g11VVLOrnrPR/EWZfPCKV/WPrJOnLP2exJs3CrROv6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YISalZIK3TR8PTD+G8hE2OyU4402PpTibQm6YhhXgyG1aHMBQaLvYwlEFIpFzOQ5X
	 qoSlvR3ju4pMUrLtTAdx04FnwZt8dBsZWAW0Zqe7hCqv5B0RpR57/3C3aTVO+0fnKR
	 AYFaNnK9pPJ9rFmcOZncZTAMqpw5+mIW6Zp2N6o/7L624FLpGK0gCV4DdOvhWlHOKp
	 VmJx6sCEH1hefU34OhpEg0xJvO+Gar1UuQcXM1UlxP8IVtZQ530bfppIa/5fKNpf7o
	 9kBBt2oZWf/FzCUMy7Bwu4Rn0UxewXeFXI1cH8NEtgskC4ISIoozoNmPZrsaaMNIG+
	 2N7NuwQcalN0w==
Date: Tue, 11 Nov 2025 22:25:51 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aRObz4bQzRHH5hJb@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107210526.257742-3-pasha.tatashin@soleen.com>
X-Stat-Signature: 6db5hc5dtxjdufbojq8bbrib93peiinb
X-Rspam-User: 
X-Rspamd-Queue-Id: 3673C20009
X-Rspamd-Server: rspam01
X-HE-Tag: 1762892776-492955
X-HE-Meta: U2FsdGVkX19nU/RF396Yee/UYjT5BHwfxo8fVr9oDmoLaBHhUX9PZIXSdl40OgBk9Y1jf/K2UFhiQ2Gn2HO5p6FdE8V6dbL4eMN93BT62mUP4WGS5FoSkm7Qqq3OV0x4xrwBMrUDdy9F4uK/zd951XyuHJtnkX4Vz+OiMOWGYT4Br0Xr32cTi4G+yJTFKQXGKQc4XO5Ea8rqbewu99evus72TtMbu4yqmHNrJGGgyHhaysaPdv1HOcp22epfK44ZVVVUQh51dOHH6oclvt9XJ7hKe0R4ndY5JhefTM9LWtpx308XCyJlU4vi0fhetrgJBJFA77zW1XC4ycNiStdzU0p0fY8JeHAbrCEoODuSDwHREVcIagyUohtZPm8JPZQtouc/kiHBx8S8ALxNiWFLzIwtVtorc4PBZHHml5bFdthOF2PRD1WspgidqV3sbCyzO5zVvto+5vcVhnsK2dfDiGM8CGh/y7qgZQRIApBJXP3evaFHO+opWs+6V6A8ciR4dyAg8aHeHO8Eol+4WrfyYYBhzLvz8Xtr5EIZY19CjvjCYkvVaGK5p6XAMKDAYXmUUeEYJmyaeTvxu8cAGs014kXRTZH8nYBv5wANo+6KaKHASjtl+h8PJFLx9W8++28Eh2oUsx+cX/d0m/p8wox1/kgHAi4XQr9/wsGVyuEB840KTdPxRcz2yJP4gsP6GnGhrD4sY2lGRnPIVQOmeobi7ixJi3sP4CjSfwkZ79I06CFtcdBVO/ebRh9VggM0LoxM6qpYUBA/kd/n/gZ4mWEfahJqTlSQvcnkSfB2fqDdJTMpxzXTDBPzS3BP1BuUbe/eofCGI7BZTkRHcfHyFqK1MqIg+jHN1AGfonhab43ptgF6Eqma6XXAsukhLikoyfU4HUr1bEe5fW2IRXOquARNNUB7PYz7Ex8simryi3yPwi70duld3R0vg7BflTjCmAcaplmQSuCvSQ6QDL8Ag/c
 E7xbouXq
 gJ/JFLz+LgDoKhNQUAXlLnv5U5Q8wcSaOrYVNNCjTG4GHmehTXHxd5TQq5cRC24isehOPy7i85QAJVx6E8nFNMTX5lc+vNbYgmt8K5FozFDRsf7EC5SruxeF4JTFqr7ZlEycjTnVV5ltUqrl/I3DT6g9rW2BD5rcrLZzWYLyEsKksGZqt6jvq8ukyOhOcAmTgpOL+aT4ag6h8i0tpjb6WR6dars1lAcXdDEMVUH5BPZ/59E5bvMeQHyh1zGMZdm+iFriTxz4q7WMQNDRvX2MPMwQI+GmXXCYB2wAUNCrdQ0l232cVr8bVRWxozFsXRFy2PRLsTEVgogE0/bKUNkc1AOQUqxfbVDuvYHxUJV4biA2ri0a0fqksmtmYHa5y3fTlrwWN7jMRNO1UJz9L2cY1JYNRLVeHyzybdw+V7NONCVXtel7ChGu3S6XtLfJIkKdDyZDiJMAcoQjsOlunyui9NZ0es1TO87k5M82+rJvz4Gl6ayzup91f2TYjyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:03:00PM -0500, Pasha Tatashin wrote:
> Integrate the LUO with the KHO framework to enable passing LUO state
> across a kexec reboot.
> 
> When LUO is transitioned to a "prepared" state, it tells KHO to
> finalize, so all memory segments that were added to KHO preservation
> list are getting preserved. After "Prepared" state no new segments
> can be preserved. If LUO is canceled, it also tells KHO to cancel the
> serialization, and therefore, later LUO can go back into the prepared
> state.
> 
> This patch introduces the following changes:
> - During the KHO finalization phase allocate FDT blob.
> - Populate this FDT with a LUO compatibility string ("luo-v1").
> 
> LUO now depends on `CONFIG_KEXEC_HANDOVER`. The core state transition
> logic (`luo_do_*_calls`) remains unimplemented in this patch.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

...

> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index c6812b4dbb2e..20c850a52167 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -21,6 +21,7 @@
>  #include <linux/buffer_head.h>
>  #include <linux/kmemleak.h>
>  #include <linux/kfence.h>
> +#include <linux/liveupdate.h>
>  #include <linux/page_ext.h>
>  #include <linux/pti.h>
>  #include <linux/pgtable.h>
> @@ -2703,6 +2704,9 @@ void __init mm_core_init(void)
>  	 */
>  	kho_memory_init();
>  
> +	/* Live Update should follow right after KHO is initialized */
> +	liveupdate_init();
> +

Why do you think it should be immediately after kho_memory_init()?
Any reason this can't be called from start_kernel() or even later as an
early_initcall() or core_initall()?

>  	memblock_free_all();
>  	mem_init();
>  	kmem_cache_init();
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 
> 

-- 
Sincerely yours,
Mike.

