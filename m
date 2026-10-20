Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D2360A2622
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JfOyaD4j
Received: by kanga.kvack.org (Postfix)
	id D04C96B04ED; Tue, 20 Oct 2026 11:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC3B6B04F6; Tue, 20 Oct 2026 11:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19276B04F8; Tue, 20 Oct 2026 11:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE736B04ED
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:10:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F886A7868
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:10:14 +0000 (UTC)
X-FDA: 85343340348.30.68763E9
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 505E840004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:10:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JfOyaD4j;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792509012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LM7ZG/o7cRFGsvk7gWfEkUQJIfUmCsf6qM2w0xloGcc=;
	b=vUUGZdW0OrP06R3cMiZJxTA+lSAsyIty8d+ZpNSCjzWv/CqWorQobju+/piZ6HttCGlDou
	P19UJzZXIT5gct7dx3BVB1J/xuJZK3jmapAMpdYMXcDZJ88BgHBPEVdZ91wuLznwDKFTGq
	a76YrMM56hwoPlUR5cV9jXTDVGmxSG8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792509012;
	b=sFmbaJ0LKYywP/wYQPdbdL88dnwoJcFM2Yp+3XWHiOuhgSCX2hjTflDbpjYef05g4sEQSa
	xDuG6/Hie9dnigUf5lX8+pD0OshlB8AwnB2pJ/KIRo1RpOv6NGLFc4T5+sG0ILSkGwwbds
	Emn/0pyx39SJczkViRtbdFCxWdbuOHY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JfOyaD4j;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a1dede3c2cso39752505e9.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792509011; x=1793113811; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LM7ZG/o7cRFGsvk7gWfEkUQJIfUmCsf6qM2w0xloGcc=;
        b=JfOyaD4jWhwUaC2SPojSOQNwhiZ1YqnqtEynuoNcgQVKN0UH7ShN/h44RNpiTpMjM3
         FRMmhhO2in25QrL2LFECHQ2Veig1Lj5AoI/tWJXOXb4RuZ94gHDrgHqLdN+jghmmRLaT
         epCAWRtvFmAJ4UwPWzSVXNiTd0nyRbVJ92GVqGrgNlEJ9UFnki4iHgBaDJVD2pb5KRsO
         onR9JqUR8dQp8jORuZjr+SYiyO1z3PVnE5+pd2306T2NAvu4K8hY/Ar4EpjaHHZsnm1+
         Lsjht42o3Xdg53jhtxBDXOPfssVB5XS+t3ckD2iw/C80Enq0iRuwb72Tj51DGaEwDdcG
         GqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792509011; x=1793113811;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LM7ZG/o7cRFGsvk7gWfEkUQJIfUmCsf6qM2w0xloGcc=;
        b=FLvMXcdIJ1NAX0N/T6hKOQ6EkixO4hNnnrt7VzBbIW6lMAfWcKtUAroILWQ43kkMbS
         KJehkmVB8GvVfM0FPTnF13O/uc0PB5kl6TmpfpVwvECq3uhH/KVpqHtqMeyNkE7GE9F1
         xNrQ2opn53pmU4XvaMkG1Jr20GLgFHNo7Y9bJJCiCOoo+FnPM2hZ5YaFtYblU2bo4+zS
         2aJvt1+8gZGNXg4G8BvDJDIcSU+/2WGQ2nxadg1j1MkF8pJ9ON+l1gtk4k3rwblZ0y4R
         WKwPu7kzD5f34jH2U4nXYa5NMQDturXianOQpAaBkP/o18ZDLLLMcgiDkFNR9dPW3Qte
         +JTg==
X-Forwarded-Encrypted: i=1; AKwUvBzk/KMMYxwkfJeNPCdo4OXpOvYtHKucZDL6ttakim+FHJgxJ/tD93Ct++fkca80A+6hSEvcSFc1fA==@kvack.org
X-Gm-Message-State: AFq9FYLVm5a/0PqyQc/cvzWwtsjK+O5wzB62uYMaueZ/1CyGUqckg7YB
	WGZjdeyhtPu7rOHIwu6U60rSA7ocoG2qOMs+gCmM1nNgMft9psQ0fw9q
X-Gm-Gg: AYBFou3RatvR74mZymvW/TTfYVjinrdah2CXU2cdg3X9aIleHAx+bBoO085T3PxnTLG
	6d97/F/Vi4hjHlCUVWdM+dY2uYf5TKspQbAHHgK5kG4SVQuI/8Q/vtd4gJh6NjekHyx66ZVrH4n
	0ct104XjhFocAyufIP9XoCA5nIcBb2fLTX15aOMXYH3Ryn62zr/pz9XHcWHOItBhneFuR3aQKRZ
	jpvMDFMlshQeA9HKvdyP47dg/SfqXIuD6ZbLZV1up+3gZLV13RM7kDHl/MtwZ2qQ7jWZOfpjyTU
	qIss+aax6P6qwoDk3q5EpDts6w6vSmKBnX7v4b5uy7emf6rBFFmOIrUFY1olnNDSUD1OZJbnliy
	3tZvqjvIQ8t10fCfaYKnKeBCTeY25a3xEp1Ubw0wolyDWh1YjqK8HniTUallkZHriqbj/VVVAF6
	sK3AZpeBM2qr5qqxxHPrO5jVPX/PRCIFjuPaC+/2qPtZk0pZQrJjaMfttauS3XmWR+hhOq6s6xF
	XsWSn5Zy9NgBja02FWYGChsRjrlbMMb75rlJVrvWwPxxyAXfBM/Zgl+Hw==
X-Received: by 2002:a05:600c:4f06:b0:4a1:e69d:90e8 with SMTP id 5b1f17b1804b1-4a1e69d931cmr185715205e9.22.1792509010706;
        Tue, 20 Oct 2026 08:10:10 -0700 (PDT)
Received: from C422HJQPQG-Fractile ([150.251.170.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d82ff70sm6650580f8f.52.2026.10.20.08.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 08:10:10 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:10:08 +0100
From: "Vishal Moola (Fractile)" <vishal.moola@gmail.com>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH] tools/testing/shared: catch a failed posix_memalign()
Message-ID: <ateEUAMoDCgiHrrT@C422HJQPQG-Fractile>
References: <20261020033128.1934349-1-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020033128.1934349-1-liam@infradead.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 505E840004
X-Stat-Signature: 14skhiks3mfoyrjw59igkshrgs361zft
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792509012-308208
X-HE-Meta: U2FsdGVkX19HScb0FD5c4kl5+K3TslOTKzTBVx21RRodA9wdaWJ+QEeSMuGSBk+a2sA7dG0XYA13nOelAnEwJlPIeezS/j/YguyP/uwOYq9DcfbgNoUBhQYBFjNNPlMo08JPiU5H9Aqxu4/QbWCWdolZ6N+aJtX6JyD2zVAD7cptGcm/kew5+gQL1bPE83xw0O5So7qOB49YQ/zZvSA0JRL9KapouJpW7BB+Hg2MEOr2/FS3Agl20TDZjnOdNTzC02yWyOqI2Q55VUO3mfraGa0DLQ63eNZijMhPfn/+2BvcsjNitXzUaQlT5yYOpzS5qXlDP8W+WX3Up7ymQRNt0JR4wAcjdcoaBJZ+QDS5kt0K8Uu1kYggb78gZmCOWQAMd9poMLHH2R1DY2tDqadc4iPCOSmZJVEKf+SELmdxqOOWeAIjOhA7nlZZunDlXmjOTWiWqhD6p6CeCT2MzztV1YP56Uk0LHPk8L2zBAyvd77gqVzf/O+qm5mYKx+2HnYtffowG1iRPeS75CwXVpc4t86khj3zNNQW4ezCfFTjjuer++hElHm/7OwM744EkB+LUSv3TG1XGqBslN3o8+vzAcH6McBo0lryRL9P9vnDnmk8T3DDtb6H0CLTKuIAlfk/5i9z1d3EcGPxC4SVDwvZRGgBX2g3uL/8ViS8Nrq6cv4/02CBsMzJ6djlXN+ppdnO0cx/3RKBl7rGjRUdE6dr2SQmRhSUmcYEXpp+A+cagupqOf/ci1xYeSspVrilYdfkZVqSOfjlk/49y3i+naAKORb7lNGuzdnvrSr55BfvoLaO4J5WkWYpfxxz02BchS29bkRJ1JIMzNvT5kuwz6WkFfNTTpUjdgFI6WUVMRlYX9eeUTc5SZ+IR16mu7DyK5jSkhy8Ena+SRp24pMoNM6fe8pMuVD/bgoc4a0PbqSc51Akd6tySlMQOWRHaitZqUVpyb++ycvYpdqDGhv/pGH
 z7qSj38p
 h0luYd7KT6StzgoU+iNV0AXfUIwseKnN4t7tSGflqGLDiYtE721aiCgvQBJ4OP4nRAqbnmXni/9xCrc9D23vYlNqijOZASryHZJmT7VYVAzYZEDlAM6bJnMlLrVF9tRkblou2N+TGj1dMQBrrjm8UbtAeQwoMrikQcisMoFcHw4/sJyHrXS6fBZVp3Nv8Y8JQMJpc913okAknGURf+xuBfPRqhe1UEL+sS0ujnt6btdjLoONHUOacQHTG4HVcy9ZQcZaQJMuC8Lt9KOpu1XbbK1UIdmYt2L5o/OIaTKY+Qde5hefnGNHYse92G3RBHpEM6Q1uew19AEwkAba6qpFKI+4nz2P6k/wuSNpcu1BLydMcaHOdz/fYnJYbfej+EQynYoisvEIxRaAEuAmsNcC57JqAaSZFRQs94q2g+n+qHvDvh0YOrUDvKqdfI1Iyt3FwN58fhIEGshJ28e5hrVjEFGKItA504T2Ws/TKPF4goiKnlNk/ZyiI6xRlrMd1S7K3SiOcqmf+D36BNPN/+mzOTq+MCiLxDSaZiTfKpR3y1vBMrquaSJe3/YN1XtzdZnbW1yO7N6vvpE1HyNM4v5ISFYlmQdbjzLjXf26WNsxpYViqIRmXha1UiabeGa5gkzI9y5ut
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:31:28PM -0400, Liam R. Howlett (Google) wrote:
> posix_memalign() returns zero or a positive error number and never sets
> errno, so the checks for a negative return in kmem_cache_alloc_lru() and
> kmem_cache_alloc_bulk() is not possible.  A failed aligned allocation
> carries on with the pointer unset, into the constructor or the memset().
> 
> Test for any non-zero return.
> 
> Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>

Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>

It's not really a big deal, but seems this was introduced in commit
8801c35c3672c ("tools: fix -Wunused-result in linux.c"), so +CC the
author Shuah Khan.

>  tools/testing/shared/linux.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
> index e0a0693df08f5..a37d2f86d3254 100644
> --- a/tools/testing/shared/linux.c
> +++ b/tools/testing/shared/linux.c
> @@ -83,7 +83,7 @@ void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
>  	} else {
>  		pthread_mutex_unlock(&cachep->lock);
>  		if (cachep->align) {
> -			if (posix_memalign(&p, cachep->align, cachep->size) < 0)
> +			if (posix_memalign(&p, cachep->align, cachep->size))
>  				return NULL;
>  		} else {
>  			p = malloc(cachep->size);
> @@ -191,7 +191,7 @@ bool kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
>  
>  			if (cachep->align) {
>  				if (posix_memalign(&p[i], cachep->align,
> -					       cachep->size) < 0)
> +					       cachep->size))
>  					break;
>  			} else {
>  				p[i] = malloc(cachep->size);
> -- 
> 2.47.3
> 

