Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 064D3CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 02:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A4C6B0088; Wed, 24 Jun 2026 22:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B3D6B008A; Wed, 24 Jun 2026 22:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52506B0092; Wed, 24 Jun 2026 22:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 756096B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:57:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF9AA1A02A9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:57:08 +0000 (UTC)
X-FDA: 84916923336.15.74DF78F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 11D9740007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:57:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wUfWXj5a;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782356227;
	b=7ZgPQ7Stt1RWgGx4a8P9Oud49Hg1EzLNNmP17rTX+c4KZonKjjbd82GtKnU6j3k+U8yyFl
	UNg+X8/6wHN9Dp5y/fz6EvbGXOePjXApvXphxcD5d4K78rCzrfTYauSfA+RuJ4/P0D4kwA
	WTorX7JpiEoq/FFh2Cwb4mZRShb3k5w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782356227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1VUqMECiZlY9thhbQvmy35ab0ws4JsaGHxxluesab0Q=;
	b=ohfu2ljzuPAQOt6vlQFBeY50jP5NgYfAK2pL7Xyqq6BWc+ASufUO6RZpRL0lBSBwtRSlvx
	qhyCTZUaN/TPiqj29EN/sIxvLiq6BbvdgzIo7kQK8jMOc+R6X5Df6aTJ4sAjSkgy2/vZ95
	uCfgzL5SCFIBRGpm7S3eGQocUz5HBnw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wUfWXj5a;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7FE843C49;
	Thu, 25 Jun 2026 02:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1481F000E9;
	Thu, 25 Jun 2026 02:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782356225;
	bh=1VUqMECiZlY9thhbQvmy35ab0ws4JsaGHxxluesab0Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wUfWXj5aUF9eoVta8SgZEnnNduNGTOKD5CBkcZw8lAQZ5nDQRfynZOikmNZair0Ja
	 xXlXcSLqbYwRVFC0GBj35O/iJAfNJHkfNGgjOUcxYCbjg/mRCa74VQbQf+iHrTDgCb
	 jyvQry5GV5UdWA2ROhhIbcXZti87XuVpMIrNdw/8=
Date: Wed, 24 Jun 2026 19:57:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com,
 baohua@kernel.org, Xueyuan.chen21@gmail.com, dev.jain@arm.com,
 rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
 jiangwen6@xiaomi.com, shanghaoqiang@xiaomi.com
Subject: Re: [PATCH v4 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-Id: <20260624195704.5c29c0353163babb721585ca@linux-foundation.org>
In-Reply-To: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11D9740007
X-Rspam-User: 
X-Stat-Signature: e1o3y61ay7i9e91sseokz3bi181dgbp1
X-HE-Tag: 1782356226-212790
X-HE-Meta: U2FsdGVkX1/dNOh6H5XmycfxcEk5UUZLIrJaNQ3RkoEjXICp+WfsMipTsQKx6t3ZG/jgvM+kjar9l5X7Rz088beFxKboo+yeMdek/yMRFqlaumm2j6i9N+xFDsfVL9WphRx2Tt68Dd5ZaqSJRu/cXZtxTlzMVh9wRIGSjmf7VvrIsfQEfDjKqmVOaNTEiQXDQ/6C/+/05CbOabhX/mtKdNac7MSTI+BKhbuG8S7rShVsC2j1K5wDw9plshOu/shhcXwpgeS6Sy7Rpuf8gtuXAmtijcjDKkLc8U8OHregJwB/MyeiTfvm+s4a9jKatWibWh6XQnX0kTiRRZ6U2YABTlySRcyF36BNl9rcWIaje1+Ua0Xvc7NeEMV+acsuy2vioKBCbxzBJi2QXluIHwnuy+0RDcxotvt0nvgWIbQ4DKIlaLHnTY51zbs1VZDnU5kq3eFEo2Hy9sYrc+ppVWse3aHnZf16jzZL7IZC9tq6JbeJ0ejt0a8vmPjgYX39BxB2POI15xDVKUJJ2GjUsWbHXykQ0cP7jGJtFWxy4x+FSnOFd7spryKTuZj2TKEepJR8NegfA+0QuqsHJo6P412xLVerudnhnaa+bza/7DXm9BysVlwBVBUF/iX0B7u0Uscy8GfVss6KYc+NfJD0hUygCXWY8O821UVj7U3pRLU7klUp0wcSuXmnUhP1dApzXg1jNVLKJEjXiv/TDi6LuQ8/z+ySwQJho/1xSYjYETy9YAcazvF9hFbsxaMfeDxTpJkB4CwM9w+wLK7CTB0sDWnaSBq8IjNDgYs2lHiaH8FwE8VI7vCTuVuz9CY5j/deBv4Gh/q8W4KZ9qSB6WNkcgNxJa5IN0c0YbMOWlcIAmZ/CNJ+Ky/T4anUBH/V9LOxTNMy/nnIs/g933cB8iPZKQEHm4LEqu5U4V1btrqhbW0EBzUHMs8oXpK3Ja/78FJkQSDpuu1mDb8ZIH3P8Bv+bwz
 8egjD0jI
 IoRoAtI356mm0ZvBrg1S/S3jRnxPLo1OOZ0befLLRJBs5bbIbmoOCGrKnzgUwRMIbZVyEbHAFQ6P3g7lnjtILxu3mExUTLXryDtHCZidBZZiwbPN054ZDD6UvKFz3il8D7ZrmXP2723pa2SBa37jIhfSarDorlQDapL3LPYv9qlSqp6GgQBktROQqgcjYxxe2CnFawnWC1g/9gSzjDu65c+NvK+TqUN3dMkT0tjbNarLG9VgV8fLtrZRvRp91dYVALbUjidahI+S4UjNByftdl5h8HmQKqHwA9Fo1oNybC9MQTQPFwaCQq2MrZnUlkP946xm5RW5UhC/DLdKTGHARa5BVMMMEZshqi42/fP2OC2DLrWIKN9pTKGSmpVOqCBJKVTJjYTbzwjODknlUdvZDdRA1nLhmmDvnrcvynD6t+jEEpnvV3mw+uZ4AOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 16:47:20 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:

> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> is physically fully or partially contiguous. Two techniques are used:

Thanks.

> 1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
>    segments
> 2. Use batched mappings wherever possible in both vmalloc and ARM64
>    layers
> 
> Besides accelerating the mapping path, this also enables large
> mappings (PMD and cont-PTE) for vmap, which are currently not
> supported.
> 
> Patches 1-2 extend ARM64 vmalloc CONT-PTE mapping to support multiple
> CONT-PTE regions instead of just one.
> 
> Patch 3 extracts a common helper vmap_set_ptes() that consolidates PTE
> mapping logic between the ioremap and vmalloc/vmap paths, handling both
> CONT_PTE and regular PTE mappings. This prepares for the next patch.
> 
> Patch 4 extends the page table walk path to support page shifts other
> than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
> mappings. The function is renamed from vmap_small_pages_range_noflush()
> to vmap_pages_range_noflush_walk().
> 
> Patches 5-6 add huge vmap support for contiguous pages, including
> support for non-compound pages with pfn alignment verification.
> 
> On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
> the performance CPUfreq policy enabled, benchmark results:
> 
> * ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
> * vmalloc(1 MB) mapping time (excluding allocation) with
>   VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53us)
> * vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)

Nice.

> Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.

Indeed.

I see Dev had a good look at v3 - hopefully he (and Ulad) (and more ARM
folks) have time to go through this.

Is there any effect on anything other than arm64?  I'm wondering how
much testing these changes will really get in mm.git and linux-next.

How is our selftests coverage of these changes?  Is there some existing
selftest which will exercise these new features?

You diligently went through the Sashiko report against v3 (thanks). 
Please pass an eye across its v4 report, see if something new popped
up?
	https://sashiko.dev/#/patchset/20260618084726.1070022-1-jiangwen6@xiaomi.com


