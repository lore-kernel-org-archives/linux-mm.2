Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A56CA0EFC
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 01:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E1A8E0021; Fri, 22 Aug 2025 21:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03DC68E0018; Fri, 22 Aug 2025 21:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95AA8E0021; Fri, 22 Aug 2025 21:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8F388E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:07:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FAE4138D41
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:07:12 +0000 (UTC)
X-FDA: 83806233504.26.205BFEC
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf23.hostedemail.com (Postfix) with ESMTP id D68BC140005
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:07:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aXtznABH;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755911230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4g18duaRvlT5On3sXc8y81zJ3elPGw2UeQunLoMIFZk=;
	b=ufMVqtbKn8iPnmVtv7EMpJw7UIZK/Q7B1cDMb0QCSGsOQalH+LG/PZsCRXvCtYHdAU3b6n
	dPGPt32eGbdWijJ5W1iR/cBi5rKWfok4hors/P+DhI8y8c507nLs9UTfrA/hxAOZkMAapn
	xKbludcgotKKdWUkjgXLI+MkOceYtuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755911230; a=rsa-sha256;
	cv=none;
	b=1mK993qQ3O2ix1KWA5OZA+GCvutndgsem/ZYtEHacoEesfPQpISeni5WZe1HOGrjyUaRy6
	ZYM8AMQPacnlbXnUobRvz7s8Ttf9eYsIUTcZbmi15aimKW1anCK1rV+/sXOcZYiv3fAYWd
	yKfPVqm14HbIIBoK1TU/7HMidDFCWAM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aXtznABH;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 1A286A58878;
	Sat, 23 Aug 2025 01:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E748C4CEED;
	Sat, 23 Aug 2025 01:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755911229;
	bh=zPA848lcj2PEuJ1vl87BuBrFFkm/q/v1YtYEAu70EyM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aXtznABHufngIYSDtYdd01SpLEVfLER3WrVjAondkKqurHFL/zI/WCeIWW6NSri5Z
	 H1a1ejxqy6k+D1ez67uV9a2ksETHTzdUaomcq7TPd+QKL477M0+e+EFQrVCQOFgRay
	 m/PaoBsedbdvh92ZeQGsXNMn1WlQoqocJ+xh31wY=
Date: Fri, 22 Aug 2025 18:07:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeongjun Park <aha310510@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com,
 leitao@debian.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/hugetlb: add missing hugetlb_lock in
 __unmap_hugepage_range()
Message-Id: <20250822180708.86e79941d7e47e3bb759b193@linux-foundation.org>
In-Reply-To: <20250822055857.1142454-1-aha310510@gmail.com>
References: <20250822055857.1142454-1-aha310510@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D68BC140005
X-Stat-Signature: mcu79dgomw9q4xbo6h6ncgmdzo4biq71
X-Rspam-User: 
X-HE-Tag: 1755911230-152393
X-HE-Meta: U2FsdGVkX19YOnfyvO4sYTYbVrB2Mezr41bbKXi3JzGcdLVW3r4RfdeS1Z1ofoVuad+4PpDIl/pc6BtqLV6l9mqOQCJmj0ItQjiTIAch8RuQGbLlt00+hMh59ZdA7xd8fwLCLnyPmbV8a6bxMxZ3Yao+d7UhMLRgl05kC+QNRKQVX0CJyE0CVPproN3xzsUgN+R9GYLUI8JFGzJpBylHImyC6CJPR1IAU2smwJ8x7xHVyGOquwDmrz5vt22UpoB6ijLgmFMD6Fl+1Un1sWD5Uo0OQrTNv8JtbQ1MdGXZOg/WFyObQh7Y7sE0foJ7NMo69wB4Hnae1zOEj1w4B1dDIrgwrmUBjgSE8GLILwaiLQ5beYyr2LIQ2zgAO6k2ky5CDPa6NhXcL3dagWmDY7hD6WGGBxNK6f+y0g9NiZlBs2dG5tEdlIPimGCTTJb6R4zpc5YrXFKXhngY0mhj+WID/YJAZ8/pHNiZLfCucK0zVkoYwMEvE49Gg3tVnSQGVSjhCHb8bG5gHZJBWQqNy1rj1Ub+2//j+QBZw57FZVRLBnQnrMNe6uL0X17bwgbp32l9fJbqXkRyN2155zO1Paf1KJIYM3UmHLyrwkTderprweNzmc+HPfF2AypvH/CD8+PpjRfA8a8gxHDcm0bDfO+vkZpYiKFztmXjV+AfYyiVdbSsxpGnYiipcdTX/QLqD+vqKJRRnxE/7Pq1vCtfp8ggcfBqW7i04XKjf30/akoHtyeWVLESnHunAs2VZPTeBMftPWc2QR4HKHazT/DVx8tspg9lTc1yXtfazYBmzz7IYHBG/wd4kSYicEhANXaCjuTWNfhYMyWOWPqpRlk7R8EVQkjH/mL1xqhgPCSr0fLCW+UwF9jyC4PyheGQfMpd3K2p1GspDSRb9fQR/SJm+gWCdlebxH+Lzv4v7TTSRP5gbi/Zqej7pr/F2tsz9YFDAruoT7T2iiwYSOBxOhNFtbw
 yPpffDpF
 N67cq8rhv1xJgfA0UxdkyRzcajP4RPKM3IACTnNP3JLf6oEy+rTYDWmn6s3uXXa/vFWirGpHu2WTFXBjv7vdLw+wNAxBZNUoZQ5Z6U59ZCwA2BP87rlgvwDWLiBcWZIYfAhDP3HhWY0NwH/KsJhpUgF7A7Ctb7b4Gix0a1W9DBWZ8BhJgtvu79ICSrgi+ySsd4vQ23uAy7zNn1NFEbF2voIIlMeew73qquhx/AtLjvC7KQabTRrNQdFzb4+zraB9cA+Re2Sp+QEkaJwZ875M86URQ/nee9k2UUdDp2hgy1SXkPGUnRZcxCgMcfBVJDXDpSXdwmzcUkxHboavJgzx52O/Fa9afGj2jfVE3Q2yltQ6+/fErDbz5vSnjVMxYnROID1f2frFqMCd7E3O7huiCjFp6x1ooRKOMTn26SxrrFcqxvB4HDcyDSV88yLqG81r5QGRF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 14:58:57 +0900 Jeongjun Park <aha310510@gmail.com> wrote:

> When restoring a reservation for an anonymous page, we need to check to
> freeing a surplus. However, __unmap_hugepage_range() causes data race
> because it reads h->surplus_huge_pages without the protection of
> hugetlb_lock.
> 
> Therefore, we need to add missing hugetlb_lock.
> 
> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5951,6 +5951,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		 * If there we are freeing a surplus, do not set the restore
>  		 * reservation bit.
>  		 */
> +		spin_lock_irq(&hugetlb_lock);
> +
>  		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
>  		    folio_test_anon(folio)) {
>  			folio_set_hugetlb_restore_reserve(folio);
> @@ -5958,6 +5960,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			adjust_reservation = true;
>  		}
>  
> +		spin_unlock_irq(&hugetlb_lock);
>  		spin_unlock(ptl);
>  

Does hugetlb_lock nest inside page_table_lock?

It's a bit sad to be taking a global lock just to defend against some
alleged data race which probably never happens.  Doing it once per
hugepage probably won't matter but still, is there something more
proportionate that we can do here?

