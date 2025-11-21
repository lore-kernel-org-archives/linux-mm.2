Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40009CFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2786B0029; Fri, 21 Nov 2025 14:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999E66B002A; Fri, 21 Nov 2025 14:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AF6B6B008A; Fri, 21 Nov 2025 14:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 752616B0029
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:42:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12DFA140719
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:42:49 +0000 (UTC)
X-FDA: 84135636858.16.8B7F44A
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 33953C0015
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:42:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XjIbElVd;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763754167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHczAXBW36ndePVrSwtAmC2KCcD+LQ9uYV0CS0eNwa8=;
	b=ON3hRhnCWAf40g8TVSl1APHI80pI079xPaEoWPqapJ9CHi8wDQwsOr044pLhkEV1bajD4E
	OMv5wGtr1e+q3WK2AQFTW1RAwFE0RItwVrMpyd9xJvNiZr16b1Ac7a6eSgd3jNvUruRj4B
	cfS1TAEEt3L+g1tydPHT5Vk1OihWEiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763754167; a=rsa-sha256;
	cv=none;
	b=QtP9YLt87M7Yg3n/E4sRH9T8UtPbCdtHIAXLhKSS/qdY/qmPnqxAmQGpitPX3ZoELi7FG/
	Yvtt7R6BXr5lJenWe6V8rFXeq+mDYyPHZipBaiwpRWppnI9WXGWAsVrgI8jQ+8JTvRgK6a
	g2Wxi+T4EzAZrK6rodeqbcGjRG1/ZWg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XjIbElVd;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso31608481cf.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763754166; x=1764358966; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tHczAXBW36ndePVrSwtAmC2KCcD+LQ9uYV0CS0eNwa8=;
        b=XjIbElVds01M25RQtK9DuWrFh2cAGWeN1bomeAFL8TUqFw87r02rl5XO41mZzhYSJE
         WrYDL5GFFvqWwYU7CydCsKYqcXCGT0AA1XaJbYc6PEwj4P7l6jbE0MoxjlQAIJ2o3lRj
         Q/WDT0yCBAdggT3KvsYOGss1Mgq2/AmPOiairlRiChaF3q5F6TyD9jUCgdE18IFCf2SI
         gUC2cb7JjmZCepZ1PWUuhnHtGJkPNKCNUNO3FwYSNxmoZN480+FCf66ThiVMsioS6+Jz
         Ir8d7hVqTpk5rAmvc4v9VFmzGY/jl0wy8V7b+utcMVlI8Apm1yoqn/FZoHafK8pz70g2
         T5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763754166; x=1764358966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tHczAXBW36ndePVrSwtAmC2KCcD+LQ9uYV0CS0eNwa8=;
        b=EXEXQHV8L2IGBGTok+XfpibtcOS8fP7r2EvGveMonD8GMwWm5wm7FCOs2lbu59ZSSc
         vIpIT9zKYxUeeEveJA1TRPvJmPz9XPHypgnbg7CLQ/qer7Ywa7m/NG6MfiWbzZTs22q+
         dNJPOTca+vsulUKHlIw1g/QI+k32Z0jelOOcM7NvOGFev6zcAvIGUYAb8shLsz4TU+N1
         RJlyEMzyDHv27pCnJ1wnkVaQGSYC2rIzF7IvDhavhSwKdhA127H3kyNs0p09Ln+EzDYf
         +6jaQOeAAByWtwfeNSnQi/RvZwGBPYcYywc1+T+iFVpLibD5YI3LlEJz1P91pl6dptID
         r+qw==
X-Gm-Message-State: AOJu0YzL6oHnIABnaMV4FDSyM6MYbRNrrfCYNOajXBz2nmzUChc8UFma
	Trld+NwhHlxG5LFhCN2Wl/eauZsJo8Kg1UcBRT+RG5g1zZypLaZ0SOges5WQkVgG6co=
X-Gm-Gg: ASbGncuyC6knihB1Bqf08L+1xqPoRYLSoIzpAOY1UCEAdQOcpTSv2Yxe40+Z4WGzx6B
	K/EbByfKsw21gMW8IbfivadJljQVbHPQwdVZqAbni0360wQ22acMUI9fOjZT3ir04Q3yfgvJVyM
	w/BtmCfgnpwN47Tyo3Dz20wZL512lMBPUkXma/+CYZZQQJGogdygfFkZEgj6m6yDikYjB3AsyfB
	kimOHoWSrBprawmb7UrXgRzwekd1Hk2E5lw3aYNFXHdCj520/gk3BuJzKM30IGaSmnj76xe64LK
	oRHZ5g4Db5Ja26SxTFtxqd7/F900BL4YLJqZ6602/8AsgjlPEjQuH5onm32ts7GqalyNhKXNN1D
	NYuN6gbvXZKzWaCPX9j+TFCAVh1hcxbkTgl2D9zgdCUAsqBK9kcC61Lpv4XTsTIBUk3YoIAh5fq
	BdMtJjrqGjfvPXaHdP6ancVRTG/QanDhWal8gWl9XsqF2fIpdjiZ0fQh+ONUVPpvr2a9wesQ==
X-Google-Smtp-Source: AGHT+IFqNQg9VGR+ih9PF1dPXeGmqhotPlRcYalUXtahRUMLDoaN5FmikK8sTfrdHPaIneNGj/5byw==
X-Received: by 2002:a05:622a:1b88:b0:4eb:a24d:8c17 with SMTP id d75a77b69052e-4ee58857093mr54018581cf.31.1763754166168;
        Fri, 21 Nov 2025 11:42:46 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48e46ed0sm40315241cf.20.2025.11.21.11.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 11:42:45 -0800 (PST)
Date: Fri, 21 Nov 2025 14:42:35 -0500
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kernel-team@meta.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aSDAq3Wj9XN2D9ER@gourry-fedora-PF4VCD3F>
References: <20251121191540.253624-1-gourry@gourry.net>
 <20251121113138.9955cb18d9b6c7ce812d5c0a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121113138.9955cb18d9b6c7ce812d5c0a@linux-foundation.org>
X-Stat-Signature: i5xeojwi6b4n58rqdd6queazpi6kzoaw
X-Rspam-User: 
X-Rspamd-Queue-Id: 33953C0015
X-Rspamd-Server: rspam10
X-HE-Tag: 1763754166-398227
X-HE-Meta: U2FsdGVkX1/Dj9LasvdOrwSEIxVzSmiSfbjPx458n9z7T6maVEkopA7Uvssuc7ujqr5PnHyvC+QBefgoPk8uH9eIJ/nfwUqn1xGi8djhZl/C45Qfm3r8I1RcAYZMJeN3AxxyFpu+3YCJ1AyXWlCg3/U/Hr63zbr4uJhGhExk0gCdPOZUZECd4W/Nr5gzbsPFNIpwtNm/mxtJWRaFbRycDC8yGTYH1ZcOA4CpuNJqILgkbM1mvnPQQxebJltYLA9d4hjvfxsZoOE+ulDrzVtifaBnddLu0FUdliIULdGOT5SRQh91NScncERI/WGjZMAUpbqKg5FQwbxib0PlnuzRMOT7cGfstj/I9FZ8s34Rsq3bhGJ6zlT+0wyH2NBSO8+OYFePOfvMwUxRp3e7+Rsg5BS8eXVOA3oONBUdeWH0NX+9xwDhoYxMJi+MAb7ehhFAJGNd6ikjVk/bzizFn0USMpLLVoeNaRZ3R0dYEMrAaeOCqco1hQ4FXy5T15iNx0jwxW2lLvRGzybbSK26/owPpeDprVdWdWf/QejCybuZKLOTyaZ+M4JKg8kIFaiiwqTJZHtI140D1Dw/y5QOBaLpjhkPs5MzwZTwcKgWhOggzbEhtijMHdrXk/LKM18v+qp08WupXVuz8uc6fOSGI+F9Ud9MoZcwRXmx7nqO1kwcL4r7ksJadQ01VqxDfK2A4OmrGP3tS20ssAyl3M0+dZFltYraNjDSSIlOYTcLGR0E7WjxtdSSoQ3UOw4oEFdxcSZKXf7LXycVR5l8FsUYlqMvXbGp0LuLGD5ZnQpwDzdQgACqO+sQJG8yAc8s/QNZXFn5oJe/GHSuwUyZ59dLmYFekoG4gBO2uOoW1fWzv0b9XhPE0qH5w/gVJmY6SQli4WYSnICjpl56fqWO+7GUrLUol3PYPs6nhu8EP5x0ldVnKgXWrEQT/zxyawdF/IFMrcR+jxXFlVfgIAOytXGxetr
 RCF6xCyP
 MIwwvCpo5tYfXhb+SUGePjkQeA5f7z4JGjnYYb2hVy9s0HCVsnSa/UOoLINkvAp+Plq3XC0UIJzKeqUUdQgc8TJ/BO1qGO7lSYY/oePmDN1GRjPv6UG7Pnist7tdELpoA6GkD0ct6aBq5AgjirsPtXQ/2vMIQBL/ZS6lIQncq0mOagHcslqFw3mIHyBROfnYs67zkrcNS+i95N1aPO1Bdh9kUF5vhLk6FcBSTkhs+2O1jJkl5e5pCUzKu9o0Xn444NuCmQgUyINmjHhrA7f6Opw7PhKtkkqmpiBnr7PTv3DklgIlTDFs1Rpqrz3CmJKkAel39qqltpI44USDV/XR7pXsp9B7US0YuNy35QDg+lyJEdMSeA0gI4xf/gXSHa6s3mzrMxq0iDgEmGw9zkpvjOKGzPX/6xs35wbdRGebLwFXRVftm8My1gsbMb/cAHMmOjVg8B7+E1CdsyEpfVEWO990lH2YEmKzCBkvURMwERT5LiGqomzNQod2HatEzzQMAeYtrAM0pFvsFMJfMJNA6iCK1xETrp6sYVm/tz/9hVTLY1XI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 11:31:38AM -0800, Andrew Morton wrote:
> On Fri, 21 Nov 2025 14:15:40 -0500 Gregory Price <gourry@gourry.net> wrote:
> 
> > We presently skip regions with hugepages entirely when trying to do
> > contiguous page allocation.  Instead, if hugepage migration is enabled,
> > consider regions with hugepages smaller than the target contiguous
> > allocation request as valid targets for allocation.
> 
> Why?  What benefit does this have to our users?
> 
> Some runtime testing results might be helpful?

If multiple types of hugepages are in use, alloc_contig is less reliable.
In particular when 2MB and 1GB HugeTLB pages are present on the same system.

The same logic is actually present in isolate_migrate_pages_block() as
pointed out by David  which is called in the stack from alloc_contig -
but it's unreachable because this filters those regions.

I allude to this in the second paragraph, but it is worth spelling out
explicitly.  Will update.

> 
> > isolate_migrate_pages_block() already expects requests with hugepages
> > to originate from alloc_contig, and hugetlb code also does a migratable
> > check when isolating in folio_isolate_hugetlb().
> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> 
> A Link: here might be illuminating.

Ah, fair point

Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/

"""
However, it also means that we won't try moving 2MB folios to free up a
1GB folio.

That could be supported by allowing for moving hugetlb folios when their
size is small enough to be served by the buddy, and the size we are
allocating is larger than the one of these folios.
"""

> 
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6849,8 +6849,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
> >  		if (PageReserved(page))
> >  			return false;
> >  
> > -		if (PageHuge(page))
> > -			return false;
> > +		if (PageHuge(page)) {
> > +			unsigned int order;
> > +
> > +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> > +				return false;
> > +
> > +			/* Don't consider moving same size/larger pages */
> 
> Comment says "what" (which was fairly obvious).  Please reveal "why".
> 

ack.

> > +			page = compound_head(page);
> > +			order = compound_order(page);
> > +			if ((order >= MAX_FOLIO_ORDER) ||
> > +			    (nr_pages <= (1 << order)))
> > +				return false;
> > +		}
> >  	}
> >  	return true;
> >  }
> 

