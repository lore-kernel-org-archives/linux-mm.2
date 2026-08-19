Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B041C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 11:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1BD6B0092; Wed, 19 Aug 2026 07:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1994E6B0093; Wed, 19 Aug 2026 07:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088426B0095; Wed, 19 Aug 2026 07:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D26406B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:48:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 664EA12054B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:48:45 +0000 (UTC)
X-FDA: 85117847010.29.280A136
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E8F7A0004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:48:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U49Bh18W;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787140123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Neo+1K8ghUMGN3G9vUjB7A1LbHA9OhMwHPbvzVv5Wg=;
	b=5zbmZe1rPefIU4nFDnZ9QwMQyUp7AWZUz+MT8rXnJFdFGjV/lcZfAEdDAqz6XQIlLLXCSK
	l3C9sILNqPo5ei+J7J316sb/qU29v/qHkcYh1ZCqA4Q61itEvXISF0BQpMPVphiGo30ZWE
	TlglV9QLrxW2OruWAqDgyHgiH/4mTBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787140123;
	b=7O+L11n7hMNFrRwWtuEkJSRBy8ke+uyIkMpxQiEmPsbs488CwnPDyD3arZZ8ZdaSkc+CWG
	gC2Pj+w9lJGWQq+EmwtoaQ+H0CqMN+4jusSxOysoL9SVlkfsPW3d08E+HDVZqi6S1X+lVD
	tortDTQBZrzqXDmRZK+TkIU5FNw1nZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U49Bh18W;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5aeb98460c6so1113217e87.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787140122; x=1787744922; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1Neo+1K8ghUMGN3G9vUjB7A1LbHA9OhMwHPbvzVv5Wg=;
        b=U49Bh18WF4Khceruw4jFPnPKA4G0ymxe1B01n/Bz59bmzfkuf2wttjAJnAYrqgcgcx
         VcMBp8wRah7Y9Bwyb7jIrdOcPIfVtwsfJnDXys26IXts26jfuffYWjK20iR/lK0PghJp
         n63aGpSRhqGdduWaNlv2Ng1nnG1JriZpACUITTzZv/7lYDHHJ1BvuE+ICxmmTv2SlCLm
         nZmWsp30y3gjFu3aUpD/SFxN9H8DppwlEZKII9mY81z/68y8JrJmmA4t2SEtB5NqcBjo
         xPDvRmOo7zxD8t9i3e/G20FF2JWScR6bhzfv1Ngim7n/GYjDSdp4a+/fZr8X+CG6arF4
         s/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787140122; x=1787744922;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Neo+1K8ghUMGN3G9vUjB7A1LbHA9OhMwHPbvzVv5Wg=;
        b=lrS7+6MVo+9IJD/TPusQcmt38gkg+qhTg+HFIWiXCQsGhliaomBpxfKTDCaGm626NN
         XcQpLOQZ03VxO5ni2a50oD9dMDKGASA40Qgfmmtvls9/20ic8E+8EOKNlbSZOd37LuLX
         bkrKsTdjFTCEreG/O+kYeghifKQhKfYkQ1GoquhXRy3TacMKz3eJ6w8Sv2oh7hUYMufR
         HPOgem4/9PYZ9QqymEHsulc1UOD+QjH1mieyHywuqcHmm3ApsmUsYvYKGkO+4EnGZIQo
         9tzEUpPTqHEdx4Rd+8NmzgmqikY0/BXkluAH/JDfybnAtZxHZCVIRZNtMgMWx45iTPsj
         5/Lg==
X-Forwarded-Encrypted: i=1; AHgh+Rpgyqs/AOUcLTdiYcFwxG/Ii5pojiLbtyWGQ2d8dJw6uKF5oGHPVmsX74zDFl5N1tRAYkfqQD3Luw==@kvack.org
X-Gm-Message-State: AOJu0YwKcQvR7D49oaAAzRs02CYsUyeM+woByFYKFOjMZjlqVOz/7NOD
	E7NKlpWIKPMiuv6EWEYlcku9pYvjbEGC7VPmMA5DaXtivjdk9xYHBKm6
X-Gm-Gg: AR+sD13zIDrsC2b/qOz46Uym0cz6LEnkXpfHaU8YpAhsOF/Mc3wzo79eroizMUvCEAB
	632qsGFBBHT4fOyoGrFrfJxoAtwx8L7e4jVQ2b8uu1C9sp8ZG908D2CG793A/bXWzVA3+rEOFHr
	NRexNAzhOTLh5JwB4eSN81gSqUaTiC0VQ/VsB+GfapAb7PFzKBm1v6sBoEryJBws8VeRucoOYLg
	tRLzCVxCEwHUfCrQXYU/cDL1y/3L0ibyrHizKdFTv/GpChCwDNc9g/70Df65xUvbgZh3bikqCDj
	lx/inMgjjfnzrguZSs5oXY92lCuhGYvTqRlOmZsLKNWtn+/H4EnQ6Xtm/N8HEdEPLP9z9riSgPG
	hVJC/xyMgZ6swMbxGlfijhB2s3NsFFohcZ3McvQZamSG1Tnbt/H6bIIGgYok05dkvw+/IaFVzYb
	cM+xeuvJymgvOPwhjLcixLAwNJF61mPlAIdR9DP5bXhSJEGk2RCRS4l3XkPw9awJqIxgc16QMVD
	klEoOxtklfh0VyNmdmpyFw6mQkNPQ==
X-Received: by 2002:a05:6512:224d:b0:5b2:f453:1073 with SMTP id 2adb3069b0e04-5b478b9070dmr1376566e87.2.1787140121681;
        Wed, 19 Aug 2026 04:48:41 -0700 (PDT)
Received: from pc636 (host-95-193-137-165.mobileonline.telia.com. [95.193.137.165])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b478853971sm482752e87.10.2026.08.19.04.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 04:48:41 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 19 Aug 2026 13:48:36 +0200
To: Mike Rapoport <rppt@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: Re: [PATCH 2/6] mm/vmalloc: set area's page_order after allocation
 succeeds
Message-ID: <aoWYFH_FJXlMK8fw@pc636>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
 <20260816-execmem-set-vm-perms-v0-2-v1-2-90944a3ad43f@kernel.org>
 <aoNFZU_QzghDBgbZ@milan>
 <aoVUF2pgl8JYNyIU@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoVUF2pgl8JYNyIU@kernel.org>
X-Rspam-User: 
X-Stat-Signature: i1f5i556icuodech5yht7o8kgr5icfte
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8E8F7A0004
X-HE-Tag: 1787140123-493798
X-HE-Meta: U2FsdGVkX19+W79NRQkcNH2bmGV1WASTcEsVi5yaXt4dWiCObO4os7jGlToDXX70ZgkCxzM+UDQXXHUz0WjOxQ6BARczIQHCeePWTawwnuo5gt06QL0ujN31y7l11stwI9ijqchuj9eTdWprS0T7a9ftH/td6+6wuhriEDRlKNPn78M/xd5JlqgQMkTD3Ed8cW/UCnjy7e07Jo7rfvSqr9Pg528YGjjJBHWG5d3+PG4OTeSvPQ6yCjb8i8taEDpiq71DbIk+HTjr/Jvdwb+lSZFXED2uXzdMsJkaY3XmQ/xKaSULZ3kvrKbvEI9STRbKpwzeXlJN7aoIzbeT9HsV9SpzEMa2ByCQ44FMKYbubFtO0szCj7cAFMnDLkShRVhRzuGCp3zok1unrhpbyfZuYsEk/ssMLvSR4yqDTmrgxz/jnLEGxI6hlNAiEUetJWcbMT36ZnDQWshK8XRXzVtWwZDm6i+penkipAyKxsTIjR3tbW3e4JkQAXZaMtMsvAzfzFDA2o2a164VtonQgLo8aDGgFoZSHodYDsO8Jl7fQGKxuTdWWWcbyWkzc1LrZysnNozsSwsphl02KmWfTYoRQNJV9KLcYAXNuyP0KDVZCmylMC8h3WAQAQmH411lzp2AUBKdhjb1TYGCfurixo2GMS0OHWn4uxzQEziaGFT67kL3RiKryr9TNf5kOYoPB6x1+o1rjQNbjAmMXmzpwUDCTNEhOyhQBaGfH6VBy1pT3lHfArMul+nv4RkwbUvfwNnIZGmYfWgM73yEfe1kSGczstl++zPIYY+FDTW9Y33qGCqYupNGpdZMEd6/CszKhu4gsMg5Z7LVTkvWysuNL6FjSUrzVibgroCUXhIXN4fpnhS24xSJCBXvNyidQkqaXjmLCywAbbgMU0BA5j3SvNwsCFnnu85MN0v1+DdWHPkuAQUquf1CvnvH78sNC3ZBoPgfbLacnMDTNJr7eVtdBHJ
 stHdEVBb
 U/Cu2qvXlpA08K4sXm5U6W3/FhWbhdsZWfrt9NrwX/OGe8RW/rqIAKGFgb4wr0Y4xUV+OHYk8GohHgwRn6mu+s8BeETV818wevtJLCGi53GfOLg7yG7oUB5iClq5SjzWXTeO69qflsos15BWp7WO7VAUkG7A8MF3uvvr/t+N6jCF0BgSogb8cMw08X4BiFJOWDlmu2Bmlu3VZFYk8MtCdKIWwQbUw0jDWIPB6mnXxkefwdQ4gLk2GVH5nmvPX1p4tGpdqvnrl6oXNLLE9kzVvwHsOfhY4XMsgwsDEbiT/Z7Wsi+aeBzU+cuY5zPCaVxq4XmFZO586jRkm/GsdAuWC6BE5+YkhBxF868NMjKj7yyQoCVt3MOjFajGBQEVhVG0uZj2MM+kr15O9q3AgyTIEuunBcklwqrdOOryG+BjXnCOVPvmN43jiS2t1owK5YLT2Ppk8LTNTF3Xsi4eP9ocpRSraAbV7Ho1tsTn7sQfdvJXso4jyw7OUebjU3UrD149pJ30b2ixgajnc3H0gPDDFaa+gfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 09:58:31AM +0300, Mike Rapoport wrote:
> On Mon, Aug 17, 2026 at 07:31:17PM +0200, Uladzislau Rezki wrote:
> > On Sun, Aug 16, 2026 at 01:59:25PM +0300, Mike Rapoport (Microsoft) wrote:
> > > __vmalloc_area_node() calls set_vm_area_page_order() to set area's
> > > page_order before actually allocating pages to populate the area.
> > > 
> > > If allocation of large pages in HUGE_VMAP case fails midway, this leaves
> > > the area with elevated page_order throughout the cleanup path.
> > > 
> > > There is no actual issue with this because the only place that currently
> > > relies on area->page_order on the cleanup path is the loop calculating
> > > the direct map alias range in vm_reset_perms() and it anyway skips
> > > unpopulated pages.
> > > 
> > > But having set_vm_area_page_order() in the middle of __vmalloc_area_node()
> > > makes things very obscure, hard to reason about and error prone against
> > > future changes of the cleanup path.
> > > 
> > > Move the call to set_vm_area_page_order() after __vmalloc_area_node()
> > > succeeded where page order is guaranteed.
> > > 
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  mm/vmalloc.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index 22566e0b6e38..6822f0fe9583 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3901,8 +3901,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > >  		goto fail;
> > >  	}
> > >  
> > > -	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
> > > -	page_order = vm_area_page_order(area);
> > > +	page_order = page_shift - PAGE_SHIFT;
> > >  
> > >  	/*
> > >  	 * High-order nofail allocations are really expensive and
> > > @@ -4106,6 +4105,14 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
> > >  	if (!ret)
> > >  		goto fail;
> > >  
> > > +	/*
> > > +	 * Set area->page_order once it's known exactly that the order of the
> > > +	 * pages the area contains.
> > > +	 * Even if we succeeded to partially populate the area with large pages,
> > > +	 * still treat the area as populated with order-0 pages.
> > > +	 */
> > > +	set_vm_area_page_order(area, shift - PAGE_SHIFT);
> > > +
> > >  	/*
> > >  	 * Mark the pages as accessible, now that they are mapped.
> > >  	 * The condition for setting KASAN_VMALLOC_INIT should complement the
> > > 
> > > -- 
> > > 2.53.0
> > > 
> > OK, can we just set it right after the:
> > 
> > 	area->nr_pages = vm_area_alloc_pages(
> > 			vmalloc_gfp_adjust(gfp_mask, page_order), node,
> > 			page_order, nr_small_pages, area->pages);
> > 
> > 
> > succeeds?
> 
> Here it's still not clear if vm_area_page_order() succeeded :)
> 
> I can move it just before
> 
>  	return area->addr;
> 
Even better :) For next version:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

