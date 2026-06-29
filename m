Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BC6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 03:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92BB76B0005; Sun, 28 Jun 2026 23:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902F66B0088; Sun, 28 Jun 2026 23:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819A66B008A; Sun, 28 Jun 2026 23:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2C46B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:46:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3D12C23D3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:46:26 +0000 (UTC)
X-FDA: 84931562772.28.6A57983
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id DC245C0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:46:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vryJ0VFh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782704785;
	b=n8ceigWujfCrzrOVH5/S9L0ORQXIphcBjZ+MYIOhIidWPuRgeCUSwJstOJBFmcis3osMZv
	yxexFbQWq0YoAUW5d1ZKWT0J2w2A+d4jtu0FzoZis2bcyGLpGP4dVIZJNTLzZOEzspp02e
	kU3BtXN8GbvWKmrL1Az3UR2zXEtkC/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782704785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qz8r/hl20S5jbVHVqODiKamQth9h5AenYMdwUyLz/g=;
	b=PB8DT2PLzoebCcwaDcVCLXEXbU0OuX/MkSaluBHY7IgGPjGZYZju/NYaLTIKoGMIEzlvxe
	fo77yPaI5hGYHkZ4jSKVBKn8M/Gb3JG/DMSl9vIL2vV3B3JRScgv3agvjSSIqDTABbxbPA
	MTe0MPeqK8c6PGs9z64ezpx+zzjEku4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vryJ0VFh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/qz8r/hl20S5jbVHVqODiKamQth9h5AenYMdwUyLz/g=; b=vryJ0VFh/W81ftqIWGwcDlS3ru
	tDiKqdZP19f7xWY9G6v/gxMP8M6hXXT9fz+rrws+UgyTJTwNYkRDQ8AyfExEILu9kKCjTuM/Co3ui
	wOod13opc8NkapiFBiOZXD96N8/seC1PRsfh4YYn6CT1oSewa2lYwLtJHh1Js5DiKHpiX8SvHuVuv
	p9h1vwnQ5e1hNZcsMDTl04fy/IqRLVDXTkG7JmhQ0txAN6ekgeJdA8rh+niISn7BBGSsZMRCRiQfp
	pPK2sM63dN0PMXdohpkXAYD27n4IEUS2C3nm6cj/ltk25iCr3AgJFHJPmR/q36g+2o1/IS2Jfr7E7
	j8FVlBuA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1we2wb-00000002Y6X-24CG;
	Mon, 29 Jun 2026 03:46:01 +0000
Date: Mon, 29 Jun 2026 04:46:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, muchun.song@linux.dev,
	osalvador@suse.de, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, peterx@redhat.com, usama.arif@linux.dev,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
Message-ID: <akHqebup1xqlgC0E@casper.infradead.org>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC245C0003
X-Rspam-User: 
X-Stat-Signature: yssbnhxq9jx3pzejfmjzpu7nkkcfdqim
X-HE-Tag: 1782704783-280428
X-HE-Meta: U2FsdGVkX1/uyYPF+HcVBkI+4W8w09c5cAELjJg21lwYDWzDoGAFaww7QBSdIh75v4PbqFO1zgR7FJFN+YaZZhp/l+r8//c8tbhELkZ2cMkE/FUD8wsN8FfI8rhErwF8KEXy1XvNOocRW5FPQD5dDFbR0kR10RcXIFl1UDZdr5i+G09YVjscu3aP5qzRBXf9j3yVjsYaAIPiuPvQx11nJOJLw55JqE9THlyZ+G18ZrA/s2To4EI7pR0C9UN72l8K5rVIihtjdTEljsIiP0CbY8908mmPG4N7PsFqjNCLyd/8GoSdS8Ezwx62BvoHAVFtnja1/xMSUByson+6VLUivknyWSVI2/Q7ubhf8mM0coOXlblFwYdGbA/NJ3KeHidEsGYy57yof5KeUQpkcxs+70lI2CUuqjbAXWhAogN+VNgqiZBrsmOk50oUgzyq/QSZNTyTcGJVnqHEaX//v7gDO82HLUuLD41S7zRWfkCGAF3zlRZdBN0LD5A9CWTar3hlnJCN9+KRGdHhOQe3DvsyWdTHq72c24jJ6/3hKBaLnFg0vJuXCd0tLDfMxavhdUQ0difwWgf1wByGwY2EYpyRGMWELu/OQ51lW0F453OwK4trc9wHUCEbN7DHNFedJlbfBNILijH8MaPucrpFw1V0eHeB9kWrQyDope7XBVAbF7hmbSS72oP0oDGJ3erEQE8bGEdcWZjSqu4ZUVmK8A5U9uXw1dVtwY2Q6I3VocWLap3PQ8Kxvv1swz+5Ui8s9RD3cxoYgYq/lqw06e1I/RuqjhsHDz0ATiz98RhFmOqjXLWYDz68wIcZwMmuIUdsREwMClGsRwZPmPMi2zvYs9LNkT7XtccAmCNIj8om1bh0wLJe/HNrf0Qh1sjcsJ59xQk8SCKN0NOTjJIHfRFRsW9wcxKRHkUkmrKqV42Xx6jUM/9DfBLp6YPaCzUrlPZUBjWhRFdGRZW4oR1uL+0HZ/n
 VhEPHnF0
 C/P3vSOF/YLHbQvEJuuNVraK2Fybh6rKy5GcJXv3NmXjjha1SVs5HxZA0asg9neqoQqB5+MxEsYbNqzgzS7yG/sPPGaz73CCs3TrcVjWIzPYSTsfiYpq5BZEupxH20Xieg7k+4Kat/Kt5xZ1bQzPfDiouCsMfaZD1wNFbIplF3RtfK+sp3IgTZwz6gLpXVbQDVPdnjoyAZwfLQy0PT1TYpAVZbwSC2t/0R4IA6VmYCjqdGlzN8mO+XebFdPkjBBjY3X0c5FNIO5PRWIiT9j2zLOATUou0yhYxhqJuIzmpNpcTc2/3gY3s3wmIqWo0o05MkPMT2p5C/Vd3SpPs74XRzpQ5eURzsloucTxxFPScnLrSAywXtqah9sNChkjsuZZ2p0bT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 03:21:48PM +0800, Qi Zheng wrote:
> This RFC patchset introduces a new feature called "Reserved THP", and I'd like
> to open up a discussion on how to use this as a stepping stone toward unifying
> HugeTLB and THP (Transparent Huge Page).

I'm really happy you're looking into this.  I'm not terribly familiar
with the page allocator code, so I don't have any comments on the
patches themselves, but I do have a few on your approach.

> Therefore, we are wondering if we can introduce "reserved THP", which is THP
> that can be reserved. It can be consumed through methods like madvise(), while
> normal memory allocation cannot consume it. This can achieve an effect similar
> to hugetlb. And because it is THP, it can relatively easily support swap
> features, which perfectly solves the above problem.

As I understand it, hugetlbfs reserves on mmap().

> This RFC wants to discuss another implementation:
> 
> 1. Introduce a new migratetype: MIGRATE_RESERVED_THP.
> 2. Introduce two new hugetlb-like kernel boot parameters: `thp_reserved_size`
>    and `thp_reserved_nr`. When set, the required memory is marked as
>    MIGRATE_RESERVED_THP and put back into the buddy allocator.
> 3. Introduce a new madvise parameter: `MADV_RESERVED_THP`. Pages marked as
>    MIGRATE_RESERVED_THP can only be consumed via `madvise(MADV_RESERVED_THP)`.
>    Other normal memory allocations cannot consume MIGRATE_RESERVED_THP memory.
> 
> This can achieve a reservation effect similar to HugeTLB and guarantee
> allocation success.

I think this is an interesting approach.  I don't think it should be too
hard to migrate existing hugetlbfs users to it.

> 3. Future Plans
> ===============
> 
> 3.1 Enhance swap-out and swap-in for large folios
> -------------------------------------------------
> 
> Currently, For swap-out, THP_SWAP is supported, but it only tries to swap out
> the THP folio as a whole. It is still possible to be forced to split in some
> situations (e.g., fragmented swap space, memory.swap.max limits, etc). For
> swap-in, it is almost impossible to directly swap in the THP folio as a whole.
> 
> But for reserved THP, splitting is not allowed. We need to ensure that it
> remains a whole huge page during swap-out and swap-in, to achieve a function
> similar to hugetlb swap.

So I think the current restriction is something that needs to be fixed
anyway.  It doesn't actually make sense that a folio must be written out
contiguously; filesystems do not have this restriction.  I understand
why swap currently has this limitation, but I'm hoping it gets removed
at some point.  I'm not sure if the people working on swap right now
intend to fix this.  They're already on the cc, so I hope they chime in.

> 3.2 Integrate reserved THP into the common reclaim path
> -------------------------------------------------------
> 
> Once swap-in and swap-out of huge pages can be supported without splitting,
> reserved THP can be integrated into the common reclaim path as a normal LRU
> folio for memory reclamation. This fills the gap of the hugetlb swap function.

Hm.  Then what does "reserved THP" mean if they can be swapped out?

> 3.4 Use reserved THP as a backend for hugetlbfs
> -----------------------------------------------
> 
> This would allow existing hugetlb users or applications to seamlessly switch to
> reserved THP.

If this is the end goal, then I think introducing new command line
options is probably the wrong approach right now.  Instead, "reserved
THPs" should be allocated from the same pool as hugetlb reserve.  That
way we're not jerking sysadmins around.

> 3.5 Add 1GB page support to reserved THP
> ----------------------------------------
> 
> Historically, there have been several attempts to add 1GB huge page support to
> THP:
> 
> 1. https://lore.kernel.org/linux-mm/20260202005451.774496-1-usamaarif642@gmail.com/
> 2. https://lore.kernel.org/linux-mm/20210224223536.803765-1-zi.yan@sent.com/
> 
> Adding 1GB huge page support for reserved THP would be relatively simpler
> compared to regular THP.

Well.  Maybe?  What happens if we mmap() 16GiB,
madvise(USE_RESERVED_THPS) and then munmap() the first 4KiB of it?

> 3.6 Remove Hugetlb
> ------------------
> 
> Once reserved THP can completely replace the existing functions of hugetlb, we
> can gradually remove Hugetlb, leaving only one huge page management system in
> the kernel.

We also need mshare to land ... but yes, eventually removing hugetlbfs
is my hope.

