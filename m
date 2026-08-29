Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E96C61DBD
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 00:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B659A6B008C; Fri, 28 Aug 2026 20:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15D16B0092; Fri, 28 Aug 2026 20:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07DE6B0095; Fri, 28 Aug 2026 20:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF556B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:24:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6831C05AA
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:24:29 +0000 (UTC)
X-FDA: 85152410658.27.D67E75F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4506140006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:24:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdLtyO7N;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787963068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQAWhYNX0SuWWv3eBBuShtV05hfUqpxzn/crb4rmaGE=;
	b=Vil9EgGNE/PZ2vsC1LYjeWQRe+Jxrwd/F66vy84UqmiRMm9vge11snnnXnEAdJxC5/jpn5
	XgO+9QlpIhsq+CeNbGnpP4xp8WkZ1ZMVbHX+op9joDAO8GV7DDhJAyOEumzRcpTN16Esa4
	Ytk0n8VucvGqcN9ZUO50CF28PX1bIAs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787963068;
	b=SyLXEil/2HaWCshwt+TdeTQzH3w06CSoh/PRlhPXadspTYtVhHXQU8mW+ReINW/A/7ad3i
	fXbOtVK7Zs9BLtB4kYRMaktlb+uwRMo/P9Ak+pTjaMvrz/IMxsPw3osklx1qtHud+QXNIB
	Hh9VRMbdbbbrsvbr4iJZg1ilE1qqfDc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdLtyO7N;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24356447BE;
	Sat, 29 Aug 2026 00:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584CF1F000E9;
	Sat, 29 Aug 2026 00:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787963067;
	bh=kQAWhYNX0SuWWv3eBBuShtV05hfUqpxzn/crb4rmaGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdLtyO7N309KcJcf2B3rmobF0/LUOAvW9C6UQJaMu1lMKCx6DC4XdGoxOj4UiURTX
	 u2izl8GV/cN4hj0ap5z+x/cFTftPi2Ua7OboYFhN8s2l/fFyHTJ2pgIklNJfb0I9/3
	 ZxO8jvx8A5+nCaUKwKfQamltRnf1EISoa08LozDqymr/Km//ZX/NHnvWE4owOmVXjG
	 i/WuXevj6My0WlvZjzN6AxoNKKRCEQrcG8wYlPWDn/NZGDEHkG7uPncf+KfseqfvwE
	 09dJvqW6/Ma/e8BBWji8zWA6XL6i3Wy/HdUzLfk88zFi5fMOPNcMk++W1Z01Lhtxu2
	 ypuuaEiKto+Ew==
From: SJ Park <sj@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Cedric Le Goater <clg@redhat.com>,
	Saravanan D <saravanand@crusoe.ai>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap mappings
Date: Fri, 28 Aug 2026 17:24:18 -0700
Message-ID: <20260829002419.73386-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4506140006
X-Stat-Signature: j1idn1iww7ggqtn1inneqhnbd3oqwt1m
X-HE-Tag: 1787963068-71675
X-HE-Meta: U2FsdGVkX19EwM1PW2yDC2X308WE6+YYeIqL3tZ/XH9Sh7SA2ue04b4QvtiO8T67gloZHk61mbXD5E9kv+F5/a+HueWKJNmmh03Zj3ha4b4hv5+r31B19PMOqaTYcWFC8nmfEONAJa0LzoBWY8jiOY7qWIAfxmoIIUPuMdY3ky+r0CK/89qRZeE17uDkxT+/zVcFKu1LlS5VMVPM6BhrL49FwETbIv3rA3UAB1GQQp5PKcMJT0aJZH9uVBoEyvCrD8zlBcq5yNa+v4qb6/c/lPTJajjBdkde/zUqdlcqWaozFLGXx22BrlNYlYMDf0oI8Rb9iYM8V+JZx9B1y2ka5yITrVYLOKf1NUTBXW6h7Inm+ICeH9DIFk+kpLTPcYSpIlzMmLA+PKuGDLBxyvs861ZisTAcqjdJSqGeOxOggBbr8ZTmKReKUNy3SwMOlnlUE4GVL7q+e9w1+3aN8hiHJIQlfyi6QNGcfghVIJHjopDphvFp/VizDNt1dKcVO+PBtMRxVuACsmKdaQe1lgJiJgv2h+FlhujhWdlCmduG60hv09hXKBTKqGb4WVeh+eGQxEj34WHZ0Ryv+/oi64y/2d9suJjguhGBye5us88vsdnM1zd5CH90CT6DItBAJ02T/DKNvjY974787qVZXvsEGQBkOlfzlWnXCiB8CZq9TfFAJfxah3ahDlqD/PuaTtAh+H3eh99EnIKaj4hSIVAv9zZDzt5S1S1imGxoSSEsIB1UIjtQSWjzVtOSt9tyab1Wl3xnVIBXJoV59tbjet4wZbEASlj8qHhmeN6+B4YFITIddCkzZ6wEIHLksH1V7zITcMD5sr7ihVfg9jyDAUtgyND7g1sb3ahpAAkyoVsuR57KHvHweLJy0qQGl6CiMaFbmZbgBzckWraqrTg7qydpWDS97mQQwyWmI9c/BH/FwQiOoBt9jGQzEEmdulF1XcfZVJe7z2vCEY93UAStPIW
 nfdJyp/+
 QhvANJCHzTm+61t9jAFojJe7sr//86/QXwLKL1UosXjvW7297lB3CbxaF2YZNj6bs5mwWTouVqlHCMyj0XmnEhuo9REa5C+0oIVY5tUT99RuPOznv06swwqeOzf3EFoh2fXkNCD5v0SRwST+P02ZkAAgV8qTwgxm8rv/DsIAt/NdrJHD+K+nxGJU1iCfA9R6/Q+7drdivIEIK9xIzhBdTQdrYp8yqGk+Wm7MJH/B3lsg2KAqwsi4VzRZ7R9WKDR9xy9+8AvMkOLxv+E8RQnb0NikNpkk/ez9ijCqDltqLbGWyI9sDDFFO4Cl1Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 20:55:57 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The sysfs THP tuneables at /sys/kernel/mm/transparent_huge_pages/ rather
> confusingly only control the behaviour of THP in some instances.
> 
> They are not applicable to MADV_COLLAPSE operations, nor to DAX mappings.
> 
> Long-term, THP is predicated upon compaction being able to obtain large
> folios to populate THP ranges.
> 
> However, vm_normal_folio() returns NULL for PFN map mappings, thus their
> reference count is maintained by the driver, not core mm.
> 
> As a consequence, the folios are not subject to reclaim nor compaction, so
> are not truly part of the THP mechanism at all.
> 
> However, since commit 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> introduced the ability to establish huge PFN maps, they have been subject
> to THP tuneables.
> 
> This is incorrect - if a huge PFN map is available (defined by
> vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
> should be mapped huge upon fault-in.
> 
> Correct this by explicitly checking for this while ensuring that smaps
> continues to accurately report THPeligible statistics.
> 
> While here, abstract the entire file-backed THP check in
> vma_can_map_huge_file(), with sensible separation of logic into helper
> functions.
> 
> Note that drm_gem_shmem_mmap() and panthor_gem_mmap() establish huge PFN
> maps of shmem folios, however they are marked unevictable in
> drm_gem_get_pages(), and in any case would fail the reference check in
> __remove_mapping() even if they weren't.
> 
> Failing to map huge PFN maps has resulted in significant real-world
> performance degradation, see links for details.

All make sense the code looks correct to me.

> 
> Reported-by: Cedric Le Goater <clg@redhat.com>
> Closes: https://lore.kernel.org/linux-mm/20260805055544.1568534-1-clg@redhat.com/
> Reported-by: Saravanan D <saravanand@crusoe.ai>
> Closes: https://lore.kernel.org/linux-mm/20260821070520.25759-1-saravanand@crusoe.ai/
> Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>

I also support Zi's naming change suggestions.


Thanks,
SJ

[...]

