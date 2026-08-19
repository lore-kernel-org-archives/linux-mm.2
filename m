Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8F7C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93DCE6B00A0; Wed, 19 Aug 2026 02:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913766B00A1; Wed, 19 Aug 2026 02:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A226B00A2; Wed, 19 Aug 2026 02:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58CB96B00A0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:58:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C99651C17E1
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:58:49 +0000 (UTC)
X-FDA: 85117116378.30.D43CE4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 270A3180006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:58:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNzWMTF0;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122728;
	b=K138jFKJWm8sQs68Mmv3OQMunmcBriEYiJ+fFUedu00OwLn5Hase5v+ONptC/rjk63gC1T
	hfWmqklGn4WSYoppu5WA+PTQpZuSPKJ2wSSiOIVregyPbFOX35Zr6jogCxUh4pDebpvm0T
	SAxvyz/da4L697F1Lipq8EeEdP4NvVU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNzWMTF0;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCLT/7ZUHNcQuAmZ6+5iUDuFRLxUPUSlNNQDS3IWLY4=;
	b=iZUVYtXBADhpvs/qRKHIaIk2D7/ddbDQk/eEJE749WBbU/JA62XZ+6MBXnihoj1S6amyNj
	hOn3WHC/KwC3Upuo+D08umm0uPB1r/W4pei7nXeAfQIPiJanHF00HyDB7N32Ri94Sq1Nm1
	WLg+jrStToQMg8hZnLIyWN8hxOVo2zY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F97B404A2;
	Wed, 19 Aug 2026 06:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECAB1F000E9;
	Wed, 19 Aug 2026 06:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787122727;
	bh=MCLT/7ZUHNcQuAmZ6+5iUDuFRLxUPUSlNNQDS3IWLY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bNzWMTF0sZIwiM3UDwCmPQsluKHj4rPAWiAqY6+TjIPW6OsMLD3narXNw2elexzvk
	 GiYymRkAB7NNLUtxIQUlyZHzrUDSKyoBCg/k0pYHhd1pMc7bmwUrm0UHvp8SoUAVc9
	 FnfjixCkhgdpirhHo0s+SNVf2LH845bZhuqX2kgGZHiya3HCMObtpFTXnLLdsV4foA
	 mypV7w9vFhI6uKJWxn+xYq+2YWbx4G11aBiHs3D02d+OWqrXwJbm97My6B311qwCeV
	 JlqOkuAcanP70XEiY7VYpx5D3s82D0S8jVZo/W5G8ABR6RAPEmQ/y9m2TaHcWZsyxW
	 NiHpZ2lpHZYXw==
Date: Wed, 19 Aug 2026 09:58:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <aoVUF2pgl8JYNyIU@kernel.org>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
 <20260816-execmem-set-vm-perms-v0-2-v1-2-90944a3ad43f@kernel.org>
 <aoNFZU_QzghDBgbZ@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoNFZU_QzghDBgbZ@milan>
X-Rspamd-Queue-Id: 270A3180006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: r7sgqyi57dwfk14rqj4z6gpe5f97knte
X-HE-Tag: 1787122728-114664
X-HE-Meta: U2FsdGVkX19qsSxloFLK88vo2JXGx6rPLFwbCUKsjFarHLBqhpcPJYcPilWINp7A4Y1xr1tzvoWQPn3CBBcDEac5fvoHK9Xw9COOH7Oga35IK2R8jJjPyoWu5XMR5YAh+RNtuJt8Km4kdbm7qtkzNz6XJ/iQQUtwKS+xLES/TwR1b5YS/k9qQpJZUp7av0+FDBImlNN2eh/Kb/IlTfALygQRJ0usjBelBxEcyqMXRZuX5ml/b+8Z1jg0wwyLJt0FxTuG2WjToCtl/StjioX2O3ebTz2e8+wAiH5vVDu4GMLUo3jDL+BpFaJs0KPAF+xjN8GLKHUD9nG8QMP0PY9KQ9sr90UltVzAVRY6OHPomRZWbd6F1+fheX4uviXYSYfgnuCHP7V0ChkCt1piyeH4UZgConQd4bIv7u3r/uvsxKIEy+YHiZhyUzncirVbsRdzjCVQM8YfMyTuG9fgBJM+1eQ25hjzzQhVzlPOVcqmtOKRVjszgN2ZspD+IXdfvRVQwcDmq2fJNM16iS7la4/eGtLZsTHIdbacUaZ91CDuhWNvvkLTEpV8TIVMvtDeJv8xVY5sJu9lQrOYN8xli4dzJ7v8SUJycRjjBMYMgJvcAbvZ68LjWAMOMNdqeZ3KooxklBptgVC/08Y/vaMzI92/Sln5ChZtCQNS1fC0IAPZUY7AIk1daiyfriBIv0Hm9sc04KB7GhMOvBklxpt1ndnDcFwC/M2Vr6JQ5B26oHLKpyU5bgyE9BNjYS5oSLkalMGSkx2NNFvUleKee3ClzD5qAYc7hyuuV0SBlrvo/Na0DEy+VtCLm+5YmiTV86k2qlpiRbKtGMo1LP4q3+LkOQaWh5ejEfHXdnRAo0hAh+GV1+bcJaQPDIGEj5CdI6eqIL52+rdfxASnuqCQI77SSL+fvbgn+weWjIYeFM8Qi7kYS/pyAY43KQHMGKz57o5wTRHNZ4aoMyiGA2/UTLirZl/
 kIy4Y6sa
 YuS+sO88WbCLfhgE3btcX9t6SbeUmtkNGKRehd31wc45dJHN0MkvOByraP53OXfE3dWEPS36GSbg3Xq4TOGy+FTwVTaOIXYOX+6MGIeciODf6qIa/zah8M9d0O3PJwCjlGPm6OLgdVEPcBNKymugXl8EjYGqDob25Q1oQ0s2G9iyJBx/4BGU4R9oKKUH8zZHvjstxbifZ14vO/RQgEwKu/vAxtdcmGlFEr8gStXzYT7bmSduwVt5hlpcMoLxlXQnkUEsDXbykBy9PQSt9T/rIHGykEPCq8hzoMC+27THcNsXt3yy7zQXFE2WNlAPqbJRcjEkyYhXg5On69To=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 07:31:17PM +0200, Uladzislau Rezki wrote:
> On Sun, Aug 16, 2026 at 01:59:25PM +0300, Mike Rapoport (Microsoft) wrote:
> > __vmalloc_area_node() calls set_vm_area_page_order() to set area's
> > page_order before actually allocating pages to populate the area.
> > 
> > If allocation of large pages in HUGE_VMAP case fails midway, this leaves
> > the area with elevated page_order throughout the cleanup path.
> > 
> > There is no actual issue with this because the only place that currently
> > relies on area->page_order on the cleanup path is the loop calculating
> > the direct map alias range in vm_reset_perms() and it anyway skips
> > unpopulated pages.
> > 
> > But having set_vm_area_page_order() in the middle of __vmalloc_area_node()
> > makes things very obscure, hard to reason about and error prone against
> > future changes of the cleanup path.
> > 
> > Move the call to set_vm_area_page_order() after __vmalloc_area_node()
> > succeeded where page order is guaranteed.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/vmalloc.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 22566e0b6e38..6822f0fe9583 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3901,8 +3901,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >  		goto fail;
> >  	}
> >  
> > -	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
> > -	page_order = vm_area_page_order(area);
> > +	page_order = page_shift - PAGE_SHIFT;
> >  
> >  	/*
> >  	 * High-order nofail allocations are really expensive and
> > @@ -4106,6 +4105,14 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
> >  	if (!ret)
> >  		goto fail;
> >  
> > +	/*
> > +	 * Set area->page_order once it's known exactly that the order of the
> > +	 * pages the area contains.
> > +	 * Even if we succeeded to partially populate the area with large pages,
> > +	 * still treat the area as populated with order-0 pages.
> > +	 */
> > +	set_vm_area_page_order(area, shift - PAGE_SHIFT);
> > +
> >  	/*
> >  	 * Mark the pages as accessible, now that they are mapped.
> >  	 * The condition for setting KASAN_VMALLOC_INIT should complement the
> > 
> > -- 
> > 2.53.0
> > 
> OK, can we just set it right after the:
> 
> 	area->nr_pages = vm_area_alloc_pages(
> 			vmalloc_gfp_adjust(gfp_mask, page_order), node,
> 			page_order, nr_small_pages, area->pages);
> 
> 
> succeeds?

Here it's still not clear if vm_area_page_order() succeeded :)

I can move it just before

 	return area->addr;

in __vmalloc_area_node().
 
> I am not sure there is a good reason to move it out of the
> __vmalloc_area_node().
> 
> --
> Uladzislau Rezki

-- 
Sincerely yours,
Mike.

