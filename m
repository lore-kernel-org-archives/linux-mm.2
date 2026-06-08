Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C94CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2E56B0005; Mon,  8 Jun 2026 14:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38AB66B0088; Mon,  8 Jun 2026 14:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0E46B008A; Mon,  8 Jun 2026 14:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EF4D6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:10:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B19F88CC1C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:10:14 +0000 (UTC)
X-FDA: 84857534748.06.65CC25A
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id DAB11A0015
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:10:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K88UVJor;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of praan@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780942212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEllMNXAKazcdxTo09h79Zq4pXvu6XvS48U9FqZI2UI=;
	b=sWEXpLPxk8MfAF4hNT8COZTobCMKS83chA2vioxjGUZKMiTMWT4KPv6xzms6N+3DhwDGey
	ENcPR9lEAQ5N/egV1CZvDWazB5LlKWi43Ry5V29StuPp1l4RaH9xrnN+EGR6ng53Ai3wrk
	1VdXZVHDmYWKpUKYwGbPiR4lIYyW2cY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K88UVJor;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of praan@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780942212;
	b=B/D1q6RoRzcHqmGN7Hi0nOX4vaPOhvdljjNdTQE3kNGRP4FCXS0axxNkLpX5bOJDpKNy4b
	PH0Xd857V316zcrgq4XK1/jji2A6vXexEyJLkPm4acFSC9uHMdnbUPYXdukHUAoqtE2m95
	1EmJxl9gz42FZcHUjHzZl5WawqoTwv4=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1336742714fso34358c88.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 11:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780942212; x=1781547012; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xEllMNXAKazcdxTo09h79Zq4pXvu6XvS48U9FqZI2UI=;
        b=K88UVJorORzWpqPSM+1v4K4UCYRZKKFsrm2s4pM/3vHqTopx0jU+y0fAR2eLtdWAGw
         W8apyt5ngFh6asluO4PQobNvnOLaaTc0OM2UuwxJ1PhX1hSxEc07vM03u1YWZEZx7Elh
         /jVLHYdBrucyIoO1bl3gwx2oYr7CByf90te50fmdrRsoBgbPdEH6QXVrxM3sJAU7ztqy
         V7rcPx4RXUC3DiyzlbJDbqM/EvbJY0j6XtBUsp34OfYr/gKRAvIXTXfzLKq6PXlLOA2W
         +wvBEpL5V/JpfoV1mO5jOu+N8s3WNybw4tuErPwZWBy6tVOyLfgih66Ks1S5EkiqDis8
         MHvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780942212; x=1781547012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xEllMNXAKazcdxTo09h79Zq4pXvu6XvS48U9FqZI2UI=;
        b=hGwbhjcqFOpx/fSglrnalifjimVPTH1hH30esx/euWsSDiAKh7FtX3wqIR7PVbJvX6
         7T3pDMR7jrhiWib0Cwd8E6FEPaA02RxonQa6HhNSIwu5bUy6wbyfnc0xad5PDW2+icki
         HjSt4akeDf4Kl8eUdZCXo8G4inWyN08aqs4P0SYwtRVr2+OoVXgPlB2JFDDGUMHAyGWX
         eTjO/eilAK/rWLTXxqeCg44yKLI3ujTtAPdYG/SZamh4T+kCiy1bOpw/rsIkPRm7uY7p
         w/YFe4a14xnRl4ey7+6htI6lxMhwSVmj14sU8EKK0NoP2eq82sWr2giBIkVMGt1GtjUU
         lceA==
X-Forwarded-Encrypted: i=1; AFNElJ+hOZ3Fc93gclazjhSw8eGAA2j243Raj3JrQSTmyahorlerv3EPVrhv6U4i+cDLrVolBdDrrsn/aw==@kvack.org
X-Gm-Message-State: AOJu0YxYAKfElE19RSOLslk4jdn8YtI586xqFSoyBLYEJwHzl9A5iyzC
	ERfOOWCwouv9zybFIgWWb0ZzQxDKDsczutNtWQUn9BeMAo5oj9cZVsUSwxNzV7RgvA==
X-Gm-Gg: Acq92OFMbSzg6HS0UAiw3JbNBWDA/y6/TlVw0TpOQGgswJWPlDXmaibIPYeijU3Nfzk
	gRyt2LRf3gaHZiIvjKLuNU1Fqa3/+NIhlgHeOdtNv1wBAr/t3zvP2z0DA7IkSzvwfv5/xxMf8Y4
	0jz6Dy8aXIJeGk1fiJR3qZJBWHTdzok3WUXBQnNlL2qj6H60t6k4hzjQ/qlIoW7meafz+E6nWyo
	8U98OnyYm3/2FGxXr/bkjwd7jVRwg+4fTDcaZBNWR3u3Kpbs17Ax9beWGEFy1FMcFP2oQ5+OHW3
	OM0WKpsFLZ89JjQkbzQ/zXEPLLH6cHRTkYRVhmDvIR40rfNnRI4qd0IPI+OfvgWQ/Ky4FxvKDWQ
	C2U18J0f0j6tjA1AmB4MgNBnYqQHRhBlWWaU2SImxGKK3I004V0bCJQmVW1lBu6TsWImQNCB9zF
	EVLY+PBxky+gDCAQKJaeOVj9yLjaMvspCewaBpI6ptMqo7xRbXXYmn7FAeAGSuj6aHOfgD0pk=
X-Received: by 2002:a05:7022:38f:b0:11a:2c18:9e70 with SMTP id a92af1059eb24-13807c516c0mr439910c88.11.1780942210090;
        Mon, 08 Jun 2026 11:10:10 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137f5550bcdsm13363034c88.14.2026.06.08.11.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 11:10:09 -0700 (PDT)
Date: Mon, 8 Jun 2026 18:10:02 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 2/4] dma/pool: Add an API to check if DMA allocation
 is from pool
Message-ID: <aicFes0uxUFQAduC@google.com>
References: <20260505002737.2213734-1-skhawaja@google.com>
 <20260505002737.2213734-3-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505002737.2213734-3-skhawaja@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mi3wcxeqtsgsi31px18k5h7na1wiou61
X-Rspamd-Queue-Id: DAB11A0015
X-HE-Tag: 1780942212-265615
X-HE-Meta: U2FsdGVkX1+dhoH3BpCY6DFFPt74m+UVhSMaHl/z80klgi4hyZRvl+a9m/34pQyIlJMaTB99Dch65r5SJ7PZ/9CsfXqy+3/J7A2OvPQZyQPbys55p+DmYAaBjSlDpK/fDXbQ0zJJS5rQc77226PxJRCS5EKPw5+YJpp9XiDs9gZyMqO3KG4Gjj0X3ITk0n+FVIxBDHo2D9DsA3j2xMZzFPVfLLW07Ju6qkkMzoTAK1H8fZ6vov7TG87ukw9DTuafmo6FAXph6BrYUmx2txMieQDOEhDEyrgkvrdRcHtLAh9BBLFZo9kgPti+rjHWU0xcGL6YXgNcekdp9TljFce4+P/z1399F7ViLaeW3nc8Jyj9YCOpPmybnpGTdY3aJPYaBDlLgeV+14vk0EGIOoZg5s9QuWa7kesLtK5bAJdMy1hbIc9fRJvZIZ1/+eUxTBKfHQoYsZYypVqwCt90+qPqJXBU9C/KRmZNMAX4RAj7w07uaUNqiYv+w1QLe1SPxQuKusVddfljQA9MLOjknqY0FO3Xn39SBAM/kEcIhcDJCoafkxkUAUhVMqQhHBTAIuKfY5syxljtk3V1+1BICRxsHG1VmKVgeOvtKqF5EszoaB2WbB+E0MNsj5y7xVBavz2JgNd9NZiHYe1ZGwhh6oQO7k16i0Cz8aAGcPWVoSvJAPlVFSmdzPsCPMYyzwI7RVgRrdHqfeWCB2u363ekVJ4/DF0CrgOa6gMfKeTSLW8MVv2L3/P0hfWeaQjVixnA7yhaxEBeYeQu12GKYgVdFSRkkgaoA9oJmu9sfyc9OybGL3oUY9cfigx7Flj6hu1eNx7Z+wB0dcJw8ryxfoi2pemJq65l8AlRaqisQQd0SOIJboAQNiA0wOZMOy2dsmOKlUjSZNbtIsKc4vgLv83dNn2CvZfsCA6SZNrxYJOB4cvCGyhUBeFT+gCRLw5s3eXU8rlUwvNjmXP+ubKwiFP1wYw
 QykD6j7q
 4lBFvPJVPsb7I34T59P3G/v/ceu2lcqLTITZxpPEZWJ+6d0E/pvc9bi+6Iu/ZzW1sIcPzyDSJqTqcOXOZQGYo8PKa24yzNHMWx3R72ltx3hp5YfYw2YoZZOnGlp5y+EbWC2MKB1uV5hv7ogUxay5tfRhZSVtmIHkVcRDnQFeL+Avr475OMya9w5SjTBEa11he3yRmGv3+QJ2OXdsfFWsuZeRJvvx+v4XaLgjfS9ZdLUzObrLKT/PUtCRkOuRYHm6jA2W7X+VS+WWRYNezqiX5gvvoKRZueZeWsr3iav0a4idhBGxcoBqh58jEZ87pHpWXw6BSJR5sEK5rWkhquDVjmpBqFluG2KxA+O2pNPe4vfA7RO5quvdbnqu9IQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 12:27:35AM +0000, Samiullah Khawaja wrote:
> DMA allocations can be done through DMA pools, add an API that can be
> used to check if an allocation is done from a pool. This will be used in
> the later commit during preservation of DMA allocation.
> 
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> ---
>  include/linux/dma-map-ops.h |  1 +
>  kernel/dma/pool.c           | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
> index 6a1832a73cad..6a0bc4ea2467 100644
> --- a/include/linux/dma-map-ops.h
> +++ b/include/linux/dma-map-ops.h
> @@ -216,6 +216,7 @@ struct page *dma_alloc_from_pool(struct device *dev, size_t size,
>  		bool (*phys_addr_ok)(struct device *, phys_addr_t, size_t));
>  bool dma_free_from_pool(struct device *dev, void *start, size_t size);
>  
> +bool dma_is_from_pool(struct device *dev, void *start, size_t size);
>  int dma_direct_set_offset(struct device *dev, phys_addr_t cpu_start,
>  		dma_addr_t dma_start, u64 size);
>  
> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
> index 2b2fbb709242..32ce4d6d7683 100644
> --- a/kernel/dma/pool.c
> +++ b/kernel/dma/pool.c
> @@ -307,3 +307,16 @@ bool dma_free_from_pool(struct device *dev, void *start, size_t size)
>  
>  	return false;
>  }
> +
> +bool dma_is_from_pool(struct device *dev, void *start, size_t size)

Do we need struct device here? It seems unused?

Nit: we only ever pass 0 gfp_flags to dma_guess_pool, should we instead
name it: dma_is_from_atomic_pool() to be more accurate?

> +{
> +	struct gen_pool *pool = NULL;
> +
> +	while ((pool = dma_guess_pool(pool, 0))) {
> +		if (!gen_pool_has_addr(pool, (unsigned long)start, size))
> +			continue;
> +		return true;
> +	}

Nit: The loop looks slightly ugly, can we have:

struct gen_pool *pool;

for (pool = dma_guess_pool(NULL, 0); pool != NULL; pool = dma_guess_pool(pool, 0)) {
	if (gen_pool_has_addr(pool, (unsigned long)start, size))
		return true;
}

> +
> +	return false;
> +}
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

Thanks,
Praan

