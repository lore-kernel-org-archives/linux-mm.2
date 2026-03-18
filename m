Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDE8103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E6B6B016A; Wed, 18 Mar 2026 06:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF2A6B016C; Wed, 18 Mar 2026 06:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5126B016D; Wed, 18 Mar 2026 06:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C75D6B016A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:52:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D60EE16066E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:52:17 +0000 (UTC)
X-FDA: 84558869514.20.01ABD98
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf09.hostedemail.com (Postfix) with ESMTP id 53300140002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:52:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HTzulNC7;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRe3+W2n2fG8F2HBagQfFXDlHaZMpeWqaE/ZfB5jUeg=;
	b=JZ4/khr/44j4LBmIQz7ql6ZXlkVjohEazP3MI/2q1zQaCjTflUTUpWbXkwsNHeC1fdPTHL
	BS9DHBXgn/ehJJHFboh0bBvmXHFLUCepobjJ2XKB26yKUwjRMmufhJE+EGG6qkpBdPclJ8
	ktg2iPiLtMwGE3vqBlHruz6mhsW5R84=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HTzulNC7;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831136; a=rsa-sha256;
	cv=none;
	b=BuOGLwdg27xrqomgJYF3uGkKvTeIUpXmhP5pGEmdM5+YXrMU35wa3NVBmPVESNL1EI4Q3G
	kzpzr1OXY+XvaMIcZuiQWEYvme4Df7taUi69miJEahvY2BqGbgVKftfEJfZRffjMysJm3Y
	j2Ii/JsmSGPoUrKErQWYpYrxU093IjM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773831132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRe3+W2n2fG8F2HBagQfFXDlHaZMpeWqaE/ZfB5jUeg=;
	b=HTzulNC7TmnoRRs81XeJFxHqGip8FTuymoI1DL0IeQSI2urpVw4z8Yds5eUbtWbitD7AfQ
	4EtgZC0aqRllbSOqqRhQLeFV/zJTTD0u4hAtvwR4X9cBj41pHsg3RpEVHY+APSS0Gg2CO5
	5ZLnpP2D2M1KH0x8QDQGurlvmjDExu4=
From: Usama Arif <usama.arif@linux.dev>
To: ryan.roberts@arm.com,
	r@hev.cc
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	jack@suse.cz,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K pages
Date: Wed, 18 Mar 2026 03:52:00 -0700
Message-ID: <20260318105203.3288727-1-usama.arif@linux.dev>
In-Reply-To: <20260313205541.3830595-1-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 53300140002
X-Rspamd-Server: rspam08
X-Stat-Signature: smmeckqmb9rcweysshfn3dnpushgu969
X-HE-Tag: 1773831136-146271
X-HE-Meta: U2FsdGVkX1+JZGy0X97OdZtaqOuqNrj/LqGyCu75YDyiRLFrFBxWg6+1nfaTWklJ3v7TYZH5Nb8dBLyLdYCFbFKb/NnvkZygEVZXKdsxOqt0bgXuRwXuePYcP7DxswJnKAiGmTl39yDCjWUKKF1UxwW9fAH68jUapToZwHX1CyeXZtUsh2iDYPo1X6dlkh90QOiZ1yC5ZzkfJo8KI/G9Co5+2+0raT63b2Ou4zSflgERCZMZYq+S3CtUPrKLh8VmEuemHuead4dD9FfySZLjxd/eLdy2cyOz9wprRSyKwg5lF0W0aI/a228KaK8LRxvydGGb4mC2fNrGh0T4bNpRawjyM2UrSE1C82cpe1oQzAVTdonmGoPnu+KocdHMRKRcxweozVmReA2aLi/CvmLS/Ni/Hyp0ucuY70Wl38khOvCqFjgqu+NnX64Rm20+7EelM+Fr/nNUOH6hIZU4dQTVxekars6E97PrwWYnUbFBz3rnRs46A3ZipIJYLbxwRdDzZsrp/96KLCUnvgCbTURlYb92LB5aqxV51F5k1gCjE/8/+aqZl/Y7yIg1/Gn6S8UxJ8/0EhdezjJ2mXJ/Ds+cJIYitfYDsQUY5dx0obTb9pKeGefFI+cm0U1RnB9cxgvsU7iQXwS49uVUOgqni+yVM1dJgHPQ/nMe+6j6S0X69dDHMSWz+ZqjCQvqF20B8qJBW/XpeHHJm/h/rWyVX284xuRY5Bx71KtXocf2O6DG0Xs+BQlH0q4jy3VNYyU+XLbSuxeYkiYp+Ho8KtenXFwmvJk4a/yes7ilbIg5jc2vs8xdIF6OGqlBubqugyusc8jvRv4+oXKvZdqwoanQ9SNNq/OTaTYfyKw86yUTHScZKebUEnKctnXuOXBiLXdRdxEHIu8oOHx+9YMkbZV5BpuFgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 13:55:38 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> On Fri, 13 Mar 2026 16:33:42 +0000 Ryan Roberts <ryan.roberts@arm.com> wrote:
> 
> > On 10/03/2026 14:51, Usama Arif wrote:
> > > On arm64, the contpte hardware feature coalesces multiple contiguous PTEs
> > > into a single iTLB entry, reducing iTLB pressure for large executable
> > > mappings.
> > > 
> > > exec_folio_order() was introduced [1] to request readahead at an
> > > arch-preferred folio order for executable memory, enabling contpte
> > > mapping on the fault path.
> > > 
> > > However, several things prevent this from working optimally on 16K and
> > > 64K page configurations:
> > > 
> > > 1. exec_folio_order() returns ilog2(SZ_64K >> PAGE_SHIFT), which only
> > >    produces the optimal contpte order for 4K pages. For 16K pages it
> > >    returns order 2 (64K) instead of order 7 (2M), and for 64K pages it
> > >    returns order 0 (64K) instead of order 5 (2M). 
> > 
> > This was deliberate, although perhaps a bit conservative. I was concerned about
> > the possibility of read amplification; pointlessly reading in a load of memory
> > that never actually gets used. And that is independent of page size.
> > 
> > 2M seems quite big as a default IMHO, I could imagine Android might complain
> > about memory pressure in their 16K config, for example.
> > 
> 
> The force_thp_readahead path in do_sync_mmap_readahead() reads at
> HPAGE_PMD_ORDER (2M on x86) and even doubles it to 4M for
> non VM_RAND_READ mappings (ra->size *= 2), with async readahead
> enabled. exec_folio_order() is more conservative. a single 2M folio
> with async_size=0, no speculative prefetch. So I think the memory
> pressure would not be worse than what x86 has?
> 
> For memory pressure on Android 16K: the readahead is clamped to VMA
> boundaries, so a small shared library won't read 2M.
> page_cache_ra_order() reduces folio order near EOF and on allocation
> failure, so the 2M order is a preference, not a guarantee with the
> current code?
> 

I am not a big fan of introducing Kconfig options, but would
CONFIG_EXEC_FOLIO_ORDER with the default value being 64K be a better
solution? Or maybe a default of 64K for 4K and 16K base page size,
but 2M for 64K page size as 64K base page size is mostly for servers.

Using a default value of 64K would mean no change in behaviour.

