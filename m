Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F06EC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76956B0092; Thu, 30 Jul 2026 10:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27706B0099; Thu, 30 Jul 2026 10:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F596B009B; Thu, 30 Jul 2026 10:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 696D16B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:24:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2B6F80190
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:24:41 +0000 (UTC)
X-FDA: 85045663962.11.B0A1CBE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id BE9F3A0008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:24:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WVOoUvhQ;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785421480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfnXfNtqGmLSSIHfEvH6536vQ2ZDN2fQBHY6qY0XAag=;
	b=Ed292E+lYJRpfTKcrLFFN2CAWvIm2tq5RRoc4UyqARcFfmcZ0UuOUi8d9B6OBlces/TSqH
	Io9q15hZhhF615QiByGT6CgDgdyBSJLDSJQCPmDr0vBqC8Q9nwF3erII+iT8DrzkrRERYH
	F0eS8OApCmaWWTPln4/uv98InJrlU6s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WVOoUvhQ;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785421480;
	b=HmI8EAPAb/b6lHeK4YBOgGkD5J4d1pavuuoLn0ZRAjmQSp2nnZoOLLiGZSk9T4B4zmNQCX
	2XGVoZVLI1w+MTB3bGsEvr+UtEmHnTXLO4pUCfLfuj5eJQiqMZb+XVlYdpq078rgVaZgaL
	sl+copBLj3VwysEBPt6YFq/7eLkksQU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hfnXfNtqGmLSSIHfEvH6536vQ2ZDN2fQBHY6qY0XAag=; b=WVOoUvhQLDeDubNxFbf3UHp4rh
	Z3peJz+023GdTMP3cihzj8yQ4UZDpDWahQcIf27gnWRKGDXZSwUcuOrMUXFCrw4ibHlqM1fVKA1Ou
	gQas+TJDPjEjGTIGoXXoR5p6HJnT+8D32+P/PPagCkUR34Nwfgc0vo0ePM2DKdYUjy2rIwStcvNtX
	Egd7bg7c0NmlvFyko73HIYrjlcXeQ8L3sMoHhwsUi4kB4aJ5SurJ5p/nOo84oGDH8HrF2FajSCwEX
	YR8IjpiwN4UZOcy29Yq+/0/YMHf5A1/ZPuMInPm1AUCJgzo0LDDgL5q6Lu5J7EZ139PpYPEv62POm
	mn6yG7Dg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpRg6-0000000HRgj-1QTE;
	Thu, 30 Jul 2026 14:24:08 +0000
Date: Thu, 30 Jul 2026 15:24:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>, Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH] hugetlb: Use invalidate_lock instead of fault_mutex
Message-ID: <amtehrbov9qrPNJc@casper.infradead.org>
References: <20260730131431.3613545-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730131431.3613545-1-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: BE9F3A0008
X-Rspamd-Server: rspam01
X-Stat-Signature: j7hoj655y6g3i9hqy4otk7mxz74upmn6
X-HE-Tag: 1785421479-319767
X-HE-Meta: U2FsdGVkX1+GBbJJ7mzv2cr5FBt1fWoPQxG9ixGsVd7WhPPccPSXrBMmG/6KbzIracuj4BaGwkJiuSZ1YivMs/LuqgUWBlnaVY3eVbuKJROsC8FzL28mP+AHIMVH1crUPErKKUoG56fGgtiKtLeC9nZGGCeIL8ht3U3rT7M+KbHOy05vmfhNHxw2LFMVp6AdD2CN9CkwHIenYPcxnIZMK/r3Jk64cP9YigDgvyhUu/VIMbLEisPMPKsdKm2JXH4/eBnikDWjh0ge4XYk9geRKXfr3anbn898E5IxXsQq6WH8GbNyHhqAOC73ld6WDrnZsnXH+/FCt1OXAu70bVDk/dlOft+nziqnGLNdx49zVXoIIEmpIqoBSTJ46n5w511ClPZJvImjvzxAgUE2HbJA2pS7ikkul8HPtGuI8kUuz7SZBDuI2RZM1I+AVcuEjKaXOjum09Suw7TuqcQCWrVflS7zCTtk8U/aV9QBVl81g6iF87oWfFhzGwrIMZB2l+W8kmXSTwnsz9X1A+4QGtn8Q3bMqwGjBjGMeJNiJ+b20hpBr/yxCQpCL3lV1VaogaAodru4h0FHw0B+Q77cDr9mdLpcAa6rMRLFoznl95W4qo6+XXsOdngR/I1wULfSEuyleDCnvgfWBb4wmeJ43DZXZxs6ZhlYG2STWA5tRRv6OrCqQibiUETFRhEf73CmcGqqLTaIjmfS+P4SUGXg7ZQSZS/+ni5fr+UeWP2eeBjP2WWmlKZOqUOjCvlXYplsnWQFS/QZ/DJVY8WdD9uozRE3caQEtdFwf3bbcniMYrQi08f6ce5tXgm0LezrEzzpTsHw8pgf0u8eKz8WJgJU4bk1WgRtzTZb2BtIAcomx7TmDt18cYXNDeWhyb8rFFP2WYPhG9q3TzVQEjmbicBdzydKIyQAm7WNk7vWiYqDX0PNxaH888k5RGP+ZI5Q9boxXmSJGhQ9Ghjc5VieTWlT6J0
 X7/T9Xcp
 NBtVEX5u/OU6nX+lYM8LTCnfXZu6Uzx1TzZIXksWsQDznjZAvqJQsh61wxWjWoeuM5eZaTi4bXynWBgivH4EUfaBkc6pa10jQA906LTXfWlLWUjoqfm8IjoDN64nida8PaWC7I87W25F3SF+cotE/ikPARYgmiUjr03skHeRgd5pDjC/Ym0PgoiSBSjvm2+s+ekzzkEuASNY9ALW7AgYV5Z4HXxGMkGIUV3Ux1p/VYWkeVTZtmXYLvzWVSXvdLxqeuG16kzvbIw5UwXfZe6V5FabeuHKnO/L3nGLFaI4Dxl/bXvj52kH9zaGM+gV8bJbczRfZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In addition to the "oops you forgot to" stuff that Sashiko is so good at
catching, it had this useful thing to say:
> 
> In fs/hugetlbfs/inode.c within hugetlbfs_fallocate(), does this change
> introduce a lock starvation regression? The filemap_invalidate_lock(mapping)
> is now acquired entirely outside the page allocation and zeroing loop. Since
> allocating and zeroing gigabytes of huge pages can take a very long time,
> holding this lock in exclusive mode across the entire loop without dropping
> it seems like it might block all concurrent page faults on the file for an
> extended period. Would it be better to drop and reacquire the lock during
> rescheduling, similar to how the old mutex was handled?

Why do we zero the folio under the fault mutex / invalidation_lock?
The usual way is to insert the folio into the page cache then submit
I/O to bring the folio uptodate.  As far as I can see the relevant code
that reads the page cache all handles "Oh, this folio isn't uptodate"
properly, so how about we do something like this?

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 991142eb034c..57c32bbd8631 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -679,8 +679,6 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 			filemap_invalidate_unlock(mapping);
 			goto out;
 		}
-		folio_zero_user(folio, addr);
-		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
@@ -688,14 +686,18 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 			filemap_invalidate_unlock(mapping);
 			goto out;
 		}
+		filemap_invalidate_unlock(mapping);
 
 		folio_set_hugetlb_migratable(folio);
+		folio_zero_user(folio, addr);
+		__folio_mark_uptodate(folio);
 		/*
 		 * folio_unlock because locked by hugetlb_add_to_page_cache()
 		 * folio_put() due to reference from alloc_hugetlb_folio()
 		 */
 		folio_unlock(folio);
 		folio_put(folio);
+		filemap_invalidate_lock(mapping);
 	}
 	filemap_invalidate_unlock(mapping);
 
(this change only textually depends on the invalidate_lock changes;
I can redo this patch without that change if we decide not to move
forward with it, or I can reorder this patch in front of that one if
that would be better)

