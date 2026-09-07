Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 792DCC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E10D6B009B; Mon,  7 Sep 2026 05:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B86B6B009D; Mon,  7 Sep 2026 05:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7916B009E; Mon,  7 Sep 2026 05:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35BA26B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:50:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEDCDA4C9D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:50:19 +0000 (UTC)
X-FDA: 85186495758.29.97A6B98
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF6AD20009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:50:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T+Vg2ePr;
	spf=pass (imf03.hostedemail.com: domain of vdonnefort@google.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788774618;
	b=PESmL19gjhbSoBIr8LvhyhWBRqq4hdFyndmRXr1Wz5b5s1KHnqaAC3MrKczRAnB02GyXm+
	LKR7SOCPpOqIp52rBuDNDB8rWWJu4qut6StHNql2YipQ8KbdDsB+7iWKGXy2GzgoEyqMvW
	HSFKIPKT3Gbc2dkpHPtP6Yp1K8dhxQs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T+Vg2ePr;
	spf=pass (imf03.hostedemail.com: domain of vdonnefort@google.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788774618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vkgu8toociZzIJhvAE7ca3qg7cytH4ujCtgPL1CR/5A=;
	b=kyWP9CgI/1gZ6fVJda6u+VyOTVoZQVbJOj2x3lyfGyOTVqvOvfrIM0G7KF6fHudbHX8iN/
	C8LcFobEZ6W2gbuufq0d8QHesy6Y4Kh0v6gX7HuPnOIuEZ1WdHC/XbrHMjw7BoRQ8gHJL3
	EKW3AscZ+CQPlfQCrGzNjmH3IHLyT4w=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48441a2ba14so2938437f8f.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 02:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788774616; x=1789379416; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vkgu8toociZzIJhvAE7ca3qg7cytH4ujCtgPL1CR/5A=;
        b=T+Vg2ePrXqHr2/NSSSLKp7yu8ToVzY0vsEQdM5fP7sRltYEGjV0ZxTnaR886o3sNb+
         uvrqE7ObqNNqqvPMBE0qVJCviQomLtqGx9Wn48L4p/0fwJxPrNDe8Y0Fm87e3k++6/9v
         QSv5mck46Tzzj6Udbr1Hk215u/tcPT1ze+ybEBGFVuuvnfV0XnM4rnVWd56olRQZwWsD
         Ii9uZavzaAjFUFIR6RG2/hJBVrAaDgOfxYlUtYLBQHMwmg931/CMwCruKfazwzkLf/v9
         N0HyDyM4+ZPk2pMJvGT+JC7rIns7QBIYMEQOM4QgT5n+eMBZen6v7SQ2At59gBfxHNYz
         MLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774616; x=1789379416;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vkgu8toociZzIJhvAE7ca3qg7cytH4ujCtgPL1CR/5A=;
        b=Xew78tE5kO9h6McsT4Un5aFhzHy6q9056W5kB4n2k+7reY3Z6ic724AtgnoQhNuGYQ
         vsQ3WvPjc3wByW7ziRdQF54XUK8MfuEsrhfsnou4eQgbpCMQ1OrEUekCi4D2mtrDFa/k
         b5NN6vJ4COwLGMnAWU3J7UygzUbkYeXS95WQMHJ/8esStrHoOrl5pg/EPdrARNt6gyCc
         vpwAfZCYrlFehRiMjjktuL/f1GZEWL+9V/zL2UcM9cbQURiE5CUfeNxwUlotndB//Zg/
         +J0jS9bBmrSAd4JG8juCRbWOCHy+/Sk8kk+PtyXIvhcdhJrixTMwZ+aPA5P7qFzpCt22
         aFcg==
X-Forwarded-Encrypted: i=1; AKwUvBw/lm/c1qnf3z6xUIJ6VU2NaAMd9NnOSaBuBA4+41VIE77I8JQB/I7K36yCsBRpU5rMgWPqxUmhIA==@kvack.org
X-Gm-Message-State: AFuF++kTgwxD9ww9iZRjV7ok1egqr5uADksgHCuHedQVigDjxUL4zUR9
	ORkZs8Qbitw5e41DzvdK7UmUjab+BSLzgMAF0VfUWWtGEatga8BliI3EjzZT8c55xw==
X-Gm-Gg: AYBFou3h8jnNcY4B/DSK0tcvch+PvMkVPuDB+YNJJ6MFMc2YXltxffYUlKLWoySJTj6
	MfqRPlDzUxGsc3j5wYFUwLKvH5Sjm8m9xXoB+P7P1xQYBYT3i5BsPF6biqAecRr5qFEis8gpYy2
	qHjlg5RjP5fFJ2uvTTL9fEYQpq4LXZM8ZkXFD+V5QzjvN8QwqYzkL7lXS6RRAvKTHXlyrd+q/3u
	zi1xPcIRVgN5tzhvofrc4LOBjpS0ylsCtkMef8xOWtAz1erH7LUVIy4ug3QOa8Avf/SpxBIoxie
	86s6zsgPw0lBotfKfRO1q1/F2FkhlRDtyk4wbJORMPErLCINlkFvGFwJkNyoaZFcZekWw+xAsRD
	J6pdk3xUlnR3aQLspTw+uyjP9VJL+ziFllKbN+y8zOOHQIlEB6VBRSRiX/umtvqwsZuDUWCBnr+
	53EuDnTFGGUThpn0sjg6PMD6bnKm07s1lCya1P7WYy9yz0MeUs9FwvOcUchlcE+RHpAEc9IcsEH
	2+rwLnOumrxS5d2+eh4LF7cx2GeU/sC
X-Received: by 2002:adf:e18d:0:b0:485:8a46:7060 with SMTP id ffacd0b85a97d-4858a46720amr19581670f8f.50.1788774615795;
        Mon, 07 Sep 2026 02:50:15 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d312ca0sm27142034f8f.4.2026.09.07.02.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:50:15 -0700 (PDT)
Date: Mon, 7 Sep 2026 10:50:12 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org,
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/10] memblock: Introduce MEMBLOCK_LLMAP
Message-ID: <ap6I1FN_2ylRzFXH@google.com>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-2-vdonnefort@google.com>
 <ap2_926WXr7uAYVX@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap2_926WXr7uAYVX@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EF6AD20009
X-Stat-Signature: bpuyma7peqgzcmwyxgprghe98xmx63ic
X-Rspam-User: 
X-HE-Tag: 1788774617-134921
X-HE-Meta: U2FsdGVkX1/TMLJE5slBmmO7n4v131ruJelBSKOaeJv4F6ticlLEFZ6iUREwKBPWzF0KyzQ2C3I14aZwuO9zGbyomFi51+zFoZ/am6CZ4z0T4Dn1GxtghEy4KHmxr75idQou1pIr5EMnvUtCe+VqGA6U6y/urYqVJfn3bvn+XfBHrU70IFDY+e33pSJy5OaGPj0/i8nQ+03qVbiNSpBBossI9aAuBq3mzJjaM0z89pD5rxb1xziO5RCvJEWegpHGzOh4sjnNeOEzE50fzvTmhjq43P08P6DoffUY/+o5fjh9vonbEwglU04qlUNbqF/JWRXQZe8j3n+I4KJXCmDUKuW5aU89w+TpD8Hupw4MJPsZ2PgT4ss5KVOlN0nTjlwg5zPK6atmYAJ/qBquhqb7YzWcZAtbo3otclnaJiiEi0R3wfIfoMDsMsZqtgH+rBSke7OjWbFoZnslyP6QyFREEZXlrrTq5bjhhnWQcIlVd4Jh5IDzCi400pVOrc6vfpiwOSij5R7eWELRHFrYqDcO2ukPJBSJ78mR6wKkdvos+F7Ap8hWA6CkbS5Krt86HyG9Pp/924PPwB+qx2AsySnHMyoVYeJ904Mx+EHkqtS+KA1XFNpKgt8wt4tyIZJJ6ZKow+SJ+b/yQk8xZ0P9DAiqyI3rs3QReijeqrs12+JzWQb+0Lnee/TvO4Y1Zg4+8izBdEfJ1lboSli5Bbx8WOEh4kVuZOK1tIxK1XRNnHSVxO49QGhjPbox6d96okw9oZc+/lNxqP9G2ttxrjmhhvY8J0a4e2sh7z7aBez4Hr5lKe4+UJHci0t5t82DaHT6Q8pYCyS0qW1a6/Euv4I3fkx4u+8f46PkpCdICFdaqAkeVgeTUBVS8HsY0hZBMcGVRFaq2Txygr2naGe1gj79hgFT5QmImQ6UnGlBCxTjJDfcG7z3A+LpiSSsZa93gy/0gPa68HTLDanun9oBMcJk+Bq
 v9FDMAX5
 38YyuLvC/r5CpIcLfklqwNjyd1Va3kIBGY12iKp4uzt9PzhCZleLQ8Oo9rbRxgXbIdnG3jSg0eziqfMe4VkmYHNekWXbtiNTy3Taw91slZzfXN6nvbpDnjVnX0m35rOM5k2RxV1/edQ6lTR15ym64xUriKzuwwKNwqq4AreShCpiK1mkYRx98tjVry5eVObUMSuLeme4mn0awEsLC4AndGkon4RdsbMhOP2eVDbKCcVAkLvjeM6thq8yd7iP/vXzjI9UkbliMXWCZnJ26PHChsfAU4Eu6JRwMA3ak+s3ypGh+899QAYz1Fp+IaZH97I3BKfnKQLjgcKCj2bxhTL9BRAwVaxj4DR8CVw0097+YFIb2m3o84gS16t1f5jCX6mgIDhCsXx7z2ac2e5EotArsJxpRmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 10:33:11PM +0300, Mike Rapoport wrote:
> On Wed, Sep 02, 2026 at 11:47:03AM +0100, Vincent Donnefort wrote:
> > Keeping last-level mappings is interesting on some architectures as it
> > allows mapping/unmapping pages from the kernel direct map without the
> > risk of splitting blocks which, under the break-before-make rule, may
> > trigger page-faults the kernel can't handle.
> > 
> > However, mapping the entire direct map at PTE-level is costly. So
> > instead, create a new memblock flag MEMBLOCK_LLMAP to enable the system
> 
> I believe MEMBLOCK_PTE_MAP sounds more descriptive.

The idea was to have something close from NOMAP, to emphasis it is one or the
other. But PTE_MAP sounds good too.

> 
> > to decide which region must be covered by mappings up to the last-level.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > index d62db9e776cf..d40a5ded188d 100644
> > --- a/include/linux/memblock.h
> > +++ b/include/linux/memblock.h
> > @@ -52,6 +52,7 @@ extern unsigned long long max_possible_pfn;
> >   * kernel that we know is good to use. It is the only memory that
> >   * allocations may happen from in this phase.
> >   * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
> > + * @MEMBLOCK_LLMAP: memory region to be mapped using last-level mapping
> >   */
> >  enum memblock_flags {
> >  	MEMBLOCK_NONE		= 0x0,	/* No special request */
> > @@ -63,6 +64,7 @@ enum memblock_flags {
> >  	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
> >  	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
> >  	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
> > +	MEMBLOCK_LLMAP		= 0x100,/* last-level mapping */
> >  };
> >  
> >  /**
> > @@ -160,6 +162,8 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
> >  int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
> >  int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
> >  int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
> > +int memblock_mark_llmap(phys_addr_t base, phys_addr_t size);
> > +int memblock_clear_llmap(phys_addr_t base, phys_addr_t size);
> >  
> >  void memblock_free(void *ptr, size_t size);
> >  void reset_all_zones_managed_pages(void);
> > @@ -306,6 +310,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
> >  	return m->flags & MEMBLOCK_KHO_SCRATCH;
> >  }
> >  
> > +static inline bool memblock_is_llmap(struct memblock_region *m)
> > +{
> > +	return m->flags & MEMBLOCK_LLMAP;
> > +}
> > +
> >  int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
> >  			    unsigned long  *end_pfn);
> >  void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 9ce86349a29f..1591b50503ed 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -1119,6 +1119,16 @@ int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size)
> >   */
> >  int __init_memblock memblock_mark_nomap(phys_addr_t base, phys_addr_t size)
> >  {
> > +	struct memblock_region *r;
> > +
> > +	memblock_cap_size(base, &size);
> > +
> > +	for_each_mem_region(r) {
> > +		if (memblock_is_llmap(r) &&
> > +		    memblock_addrs_overlap(base, size, r->base, r->size))
> > +			return -EINVAL;
> > +	}
> 
> I'm not very fond of implicit skips here. memblock has no idea what's the
> caller intention, maybe it actually wants to change the memory from nomap
> to pte-mapped.
> 
> I'd rather warn in memblock_is_nomap() and memblock_is_llmap() if they both
> are set and let the caller deal with making sure they are not.

ack.

> 
> > +
> >  	return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_NOMAP);
> >  }
> >  
> > @@ -1204,6 +1214,45 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
> >  				    MEMBLOCK_KHO_SCRATCH);
> >  }
> >  
> > +/**
> > + * memblock_mark_llmap - Mark a memory region with flag MEMBLOCK_LLMAP.
> > + * @base: the base phys addr of the region
> > + * @size: the size of the region
> > + *
> > + * If supported by the architecture, such region is mapped at the last-level in
> > + * the kernel direct map.
> > + *
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +int __init_memblock memblock_mark_llmap(phys_addr_t base, phys_addr_t size)
> > +{
> > +	struct memblock_region *r;
> > +
> > +	memblock_cap_size(base, &size);
> > +
> > +	for_each_mem_region(r) {
> > +		if (memblock_is_nomap(r) &&
> > +		    memblock_addrs_overlap(base, size, r->base, r->size))
> > +			return -EINVAL;
> > +	}
> 
> same here

ack

> 
> > +
> > +	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> > +				    MEMBLOCK_LLMAP);
> > +}
> > +
> > +/**
> > + * memblock_clear_llmap - Clear flag MEMBLOCK_LLMAP for a specified region.
> > + * @base: the base phys addr of the region
> > + * @size: the size of the region
> > + *
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +int __init_memblock memblock_clear_llmap(phys_addr_t base, phys_addr_t size)
> > +{
> > +	return memblock_setclr_flag(&memblock.memory, base, size, 0,
> > +				    MEMBLOCK_LLMAP);
> > +}
> > +
> >  static bool should_skip_region(struct memblock_type *type,
> >  			       struct memblock_region *m,
> >  			       int nid, int flags)
> > @@ -2886,6 +2935,7 @@ static const char * const flagname[] = {
> >  	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
> >  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
> >  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
> > +	[ilog2(MEMBLOCK_LLMAP)] = "LLMAP",
> >  };
> >  
> >  static int memblock_debug_show(struct seq_file *m, void *private)
> > -- 
> > 2.55.0.970.g62bdec98f9-goog
> > 
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Vincent

