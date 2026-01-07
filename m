Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7451CFD652
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 15:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BAE6B0093; Wed,  7 Jan 2026 10:28:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9A16B0095; Wed,  7 Jan 2026 10:28:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB556B0096; Wed,  7 Jan 2026 10:28:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0E66B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:28:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D10BE8B87F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:28:24 +0000 (UTC)
X-FDA: 84305549328.26.C1C7961
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 13AC7C0007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:28:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mk431zN+;
	spf=pass (imf22.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767799703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zr78093NHGdBXXu/mjsoeuNUSxyi1KCAaesy3wXMOKA=;
	b=ZY8hBfwEu07MHN8Qapo1xG1OKEoxiGV9ayEJp3IzGS6aYCssIBSuVpPZwq+pUlH1qDDJoc
	arP2LqluA22DI6p5+8xlmyWFfROl5doKXtx0jhD05CMcVRa11CG7XHcQGKMce0aQqz507d
	YUj4YOM7Pr9sspZHUJnH5vksPNTRyug=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mk431zN+;
	spf=pass (imf22.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767799703; a=rsa-sha256;
	cv=none;
	b=ZlVBgZRdRlW9QXSHQywJDh74kkaevQ+kM6Y+uRPNLQ1CEJ4OOtGXTOouZQTNksIFbYPd1E
	BKCEudDZe0n5ok+GdkoBkXexEt3XuLgPRu0w89HbeVGSXsYd9XZPmwMmqxf2IuJ8b3YFWP
	Z54HHoqWv0u33U0DpTq2BnyFt/WDAmo=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f02651fccso90905ad.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 07:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767799702; x=1768404502; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zr78093NHGdBXXu/mjsoeuNUSxyi1KCAaesy3wXMOKA=;
        b=mk431zN+RQ3bYOHGWtRMf6sVYT+0tXx36IEFI9w/W2hvKj+mNwBJkGwSFTT7fSltRy
         PKh+suSYZN5eVutGCI9HspcAV9ePC7Vbu9G48Zdh7egLOqzmvGq/8kY0GCr9s4aWvREj
         hhph2quBQ3/sUjlkfiD8wh46IBY4kf/PIMHT57mVqiohYiRZAvzs20weIS1nHtrwYS73
         WMxm1Aa6L6CNGMiT1aXLGKCS6PXlL68syKqacMG4liHtGeJyvQMvKHwFbNmWxhDGO3K2
         prRf+XJk8BcyoLNqLPOGJOmXngesW6HI1C7aWQYygwc3IAr+AG2TGkBf0rtkWRDDZyEa
         doyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767799702; x=1768404502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zr78093NHGdBXXu/mjsoeuNUSxyi1KCAaesy3wXMOKA=;
        b=jhASG4cavm3Ii6z04bxg9R+i96ktZQNXZpvpHxv4K/ZwBAoXc8qmhhAx3ca9h4XLpv
         EdicSQH0Zd48+FqeaOD+Kzwr6eO7tdtGxsA8Eb40FxkJSnqx9BzetqH9n6+AAhUuD4K4
         JzqJYFhr3vWKaODyBqlcGefEU44N7s+o4imF8Y3jvaJXyCQfxj6gG1AhS62ki9TrmEM6
         Uv4nViNSs1E0/TnZJ0ch6sSNoFpW6M/h/URc3KCz6JlNgccvTe10p8LKB5AgTm/SwRCj
         7SzBvIjdG4ZSrXE1exRK7cmwn2osHEOVZiC8c6Kav5650eav4Bnlj2wzZnhX3gzLf5NM
         N3kg==
X-Gm-Message-State: AOJu0YzboREU9CMjrzn2yK0G+22mR/6VpuYr7LX/k9/5YI3QZllLHGNC
	X1RXe+LXHIL6kIeN9fGzbzfRgTlJ/n6eC4E8eA/5YEWmL9/x1R1XxNc4s5O+KoaXGg==
X-Gm-Gg: AY/fxX7/u9Sgs+Dx8YDqyaLRGHCuvzPj1w1r+gY8+rMIDs18qwcFGxK5WrtjhJb/dI/
	EoVf23s2WuSyd4KdEFwjCo9y4cqwmh5XHWdMlCwKWIdr97RwQ5/KDPWBNko5+a2w1xzQDpHsg63
	IQ6uw7KevkR1CeYRD8otEpEyX8nyPOZMo/sy2EYA9Yn+QuBAM5bPRAPPYaFdZf+s02mgAoiEtFP
	HRUMec64QzSx4F7OS6ZzRiENX9qYaukMRqYPIh706qqzcA30sSSNCgveVdX+YzuC5WPDEzpSjDP
	v3+JM37pQd/sE/Q3W7Hteijj12SEWQQ08u6FlfJdqi8ajIJeNMnmXIlQ8YAfCuiIVYE6Rb6QsCF
	S20XtYK8OXzkBi4XvaclmtPX/JN9bKfQu8N1OIBxBA+Q69DkNh5hzbKBnGNgWcdY3bHMpesm9ru
	3GRvGntwum9hbrPXcJd81iEaG1COGfkFWCufJ/PHQVV8cvglme
X-Received: by 2002:a17:902:ea01:b0:295:28a4:f0b3 with SMTP id d9443c01a7336-2a3edab5490mr2722885ad.0.1767799701484;
        Wed, 07 Jan 2026 07:28:21 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c5ce06sm53630535ad.44.2026.01.07.07.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 07:28:20 -0800 (PST)
Date: Wed, 7 Jan 2026 15:28:13 +0000
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
Subject: Re: [PATCH v5 2/4] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
Message-ID: <aV57jZiKBfDHXciP@google.com>
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-3-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106162200.2223655-3-smostafa@google.com>
X-Stat-Signature: zndfiwopm155qoz1556ojf3p14z186ft
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 13AC7C0007
X-HE-Tag: 1767799702-805610
X-HE-Meta: U2FsdGVkX1/INfmbXZIWA1dTX65B+GHlLgLdhehvKK2R0B9EJVsZrDFUhBCAoxzEQl5S/70d5Th4ACLdSPJzICH0rFx7hpLVPj7grld/6emtmigWSr09SuqqA2Ad+roLWa47p0+Lmng0dxhxlXFOze/df2MnI0D/nrQ3AUfeqtqG1SeZEEi4rN0owXWc1RHADnXVwwtwsQ5dtylGoZYIWHZmbRVxnqqJjESDVwpb4uztoYhe9UGL62g0RXSvspXWVV4L9cblNLEl8T1KPbJzx5JSX3ok1w8NqQmJsNiBH4K7EIIWa0bJuTgKoCOPE4V+NTdWucuiGxETBBO/sVnmKA/PilUqI+dOAu7dga18wapLd1vHGxxS/BBNUySGMiSqKcvi16HqmHXtErCwYwAk0E2wlihwzOPsAp+Sfeh5blpAjIIhdYD1f54Y26QXD2Om775fe9hFPDYX1/qwvaX51UdoZshGf7M2sUHOwdZqmZvKb01trw4rU+5BVg032MNBc+H67tjksrHhWKCtypK8arHJapiYUJzyImZUh8IWUNkQlum/fVhh7LcllcEYN9A8qPcBpnG6FVOhb0fGcMUY+b4sJXrn9jBRO5VnzzxOKv3zzVkjNzfriGxiVj5fKvacjf42NnLxVekzAWkxgpr6mKbykm75KQmFdS026GyHDYBEeCvEwqISZdppOd5eJ2KTudt+D39t8q219xd5WWNGtQwrq3GSv9iFGSgHMkF/M2ZdRrZIB1Z9qxff/tDxU0x9ylRWdip1GKy307WRSNcMJ+OFJ047FX81CFOGwaJmnCfCCP6mh5sml+vxnn5B9bWxKXcUiOh4yZrVt/qp6wwgt878Vl59EXRCoL95HGaAyBKT67jbTsa2Bqv7TwKz2HSKDc3yI03cWEadC0FyMLRIckjZ64st4+w7mNa9b2s8mp1CAoXIBGaFFE1IXWE4XCJaxSVmQUozBU735p/3xjb
 QrcozGzO
 EPxNlYB+wAYj6Nj5Pe/JhyBsYECGS6R2J89KyPKT6HWQC+S7tdCkjBZQ/MDlUgYhEehdNiBrivBFiTqEo7F5cRxzw0dhUYjOHc4nfwC4oLP8UfIadOiL/1luE0wsW5mQtc/f+kNKfdefm2bnyoyK81hRsdh1sR/UmPLe0f7wuRnHLPUBzofCurI3Kmi1dAW5gTdZNhBORKln0MtCJS0ct+47ruB5tq+oqvzI2IyjSGeXuITqQ64odbH66zgT3c+hSENIhbyPs8yhHGicNv+nDXAVyTNiMI31nov0GKXfEpLoYTblAsfeu5dsWMLUIaB15th8Fm2IasEw3wfInUKocF3trbp9oHWjTbOfCCG6MZMyGqPeSzaYcAThhqC/We+8zzrduLzFAglRelZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:21:58PM +0000, Mostafa Saleh wrote:
> Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> - iommu_debug_init: Enable the debug mode if configured by the user.
> - iommu_debug_map: Track iommu pages mapped, using physical address.
> - iommu_debug_unmap_begin: Track start of iommu unmap operation, with
>   IOVA and size.
> - iommu_debug_unmap_end: Track the end of unmap operation, passing the
>   actual unmapped size versus the tracked one at unmap_begin.
> 
> We have to do the unmap_begin/end as once pages are unmapped we lose
> the information of the physical address.
> This is racy, but the API is racy by construction as it uses refcounts
> and doesn't attempt to lock/synchronize with the IOMMU API as that will
> be costly, meaning that possibility of false negative exists.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 28 +++++++++++++
>  drivers/iommu/iommu-priv.h            | 58 +++++++++++++++++++++++++++
>  drivers/iommu/iommu.c                 | 11 ++++-
>  include/linux/iommu-debug-pagealloc.h |  1 +
>  4 files changed, 96 insertions(+), 2 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Thanks

