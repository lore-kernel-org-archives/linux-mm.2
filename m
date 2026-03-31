Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60BDE10F92F2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94256B0098; Tue, 31 Mar 2026 16:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D226B0099; Tue, 31 Mar 2026 16:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0CE66B009B; Tue, 31 Mar 2026 16:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0E046B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:07:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F9D91603E8
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:07:22 +0000 (UTC)
X-FDA: 84607442724.13.378DDF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9940818000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:07:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F5kDC2M0;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774987640; a=rsa-sha256;
	cv=none;
	b=GZltL9xxf99sMq1kwTVE6YbOAWOs3c89cjtkkqnCWFPwnLKp7GfRScFh9JG3+KVY4wRQut
	6mwLJCJWdG++RC3uxDRUsbUgY222kLT6Rf+WA31CxK1oIv+jrZimWvhkGhfB5Mvi5oRm5X
	7AXjXoSEVTfwWQRR+m8pMIitqEHYJG4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F5kDC2M0;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774987640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIlca1NCWUpK/3kdCsRI76cD9epxHEEZh0ckh764bLw=;
	b=ni7ryDaIDwzrWvJkog35WEBXXhYjpMbu3wtEmvUxMenhf8BEvUKnJ7Mi6UkFqPLPpr+Tm3
	7JPNz+QJwB27A+EeHmD6SNIQE4FTizb0T1wl/xiyWCcV7y3Bl7IDnG010io6fdFqhpjEOJ
	3ziJSvGq5GAk3gYEE6aD8ToVrZvRrpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2FBB4376C;
	Tue, 31 Mar 2026 20:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9150C19423;
	Tue, 31 Mar 2026 20:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774987638;
	bh=0zk0sqn0FkmeYVYUijfJAwUUjlYh2sei1OoJrZ+6nDc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=F5kDC2M0Zd2Q9Nll9hn1aqrLNVZ62oMtnKkzFd0rytJKKQD4fbDqggvhvxSfCA2NM
	 IBz18GTZqNlMCvLICiMcXWvvyE4p2yCbmE5eXsuWCL1u5hsk17yhD+vba8olUSHCXN
	 urnibr0i+tagxGXH4c7YroKsgZTJtEWZZ/lr8o0k=
Date: Tue, 31 Mar 2026 13:07:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Petr Tesarik
 <ptesarik@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
Message-Id: <20260331130717.d42b64e5179c4c814bc523ea@linux-foundation.org>
In-Reply-To: <20260331113023.2068075-1-songmuchun@bytedance.com>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f3w5k3fs6socb41u9dmkgz96ghmu5ab6
X-Rspamd-Queue-Id: 9940818000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774987640-484070
X-HE-Meta: U2FsdGVkX19aRchh4boPNWV4aZR22+Q6mRHoTklGpvg/BsDC0dLyUbSNK1+5WT4dzHjbUukx1id5jB5UlBbh1YbmmQHRJcN1uma4xiaiCHoV9pJj/bAf6Dad/w/cqZOFiaFF9vCnR/LEMs6A4XRzUr0YAXR5LuTA2cQlbnEQF7bmN9myM6HpAUxSJq/+vJZ43r8DG4AFYQRNHt6e9koN2DSmZU5c/6f0HBAWAsb5f+CoKDuov46dpbn7GKmgTQQLxlhX+MQTmzNTh/c9/tqCa+m2B7HRpuLqqEdlUs7GWI3fxdZqqJHn8fA7p9LCWnctu6VAPC3yHWEMfxNz+hMQYkLbvBFrlKQkG/+dwqLeeWB/vBml/Fph0vSK5R6n4yTo9h/XjCto59fjnGQzVgHq7Iv6wp6gmromWe177b7f0zSlIccMuXej+FjjmtS55GNKdtfsnBmF0NxgCvrqYmP7gf600Cs+a1VeNEbiaFMKRzniB7Ua9ONqv4r7SjlEhvMCJe0RWK5oTdXcq7tJjD0wbg8pEWIJWZ9sRl4JNPj8LPslsJ96j5cQDxg1rdjYJndOXXyAG3l7GiHg/XcLcwyxTD6+fz9C1NnUBDADB/jBX5k5Te2Cg9XpIHyZc3RzXMpT6xJdxeJISdRLX2MD4IIorcvI6nZl4GXiSLYCR4rmxFL6Kg1xlBNewIWH0baEKUOQvlV1QS0xnWF4WMgkYxf8SaCPT52p/0PgvaegPD0kGGyKHrDhfqaO4zudJTkcHCG+IeVOruYDE4V0J30DQ6aTOCtER1ryOUfnHAOnLwP74VWI3PlwRYKoAxIXHs58Vn6lCX+KyDUP7nty5D26Ht8bOKBuoIvji/665ZSP3GXAa0JP9erYjxYUxxOFUFu4shYuAjOQiBCp0AhybtQchWKEWb8nVaoX8d0BKG3WoEftQXc/1830EbUafuyJoGZIFYR1LWfmx8L8idaKI7QSa21
 YI2oJ8uI
 DYCRL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 19:30:23 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> The comment in mmzone.h states that the alignment requirement
> is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
> pointer arithmetic (mem_map - section_nr_to_pfn()) results in
> a byte offset scaled by sizeof(struct page). Thus, the actual
> alignment provided by the second term is PFN_SECTION_SHIFT +
> __ffs(sizeof(struct page)).
> 
> Update the compile-time check and the mmzone.h comment to
> accurately reflect this mathematically guaranteed alignment by
> taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
> __ffs(sizeof(struct page)). This avoids the issue of the check
> being overly restrictive on architectures like powerpc where
> PFN_SECTION_SHIFT alone is very small (e.g., 6).
> 
> Also, remove the exhaustive per-architecture bit-width list from the
> comment; such details risk falling out of date over time and may
> inadvertently be left un-updated, while the existing BUILD_BUG_ON
> provides sufficient compile-time verification of the constraint.
> 
> No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
> the smaller limit on all existing architectures.
> 
> ...
>
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -269,7 +269,8 @@ static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long p
>  {
>  	unsigned long coded_mem_map =
>  		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
> -	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
> +	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + __ffs(sizeof(struct page)),
> +						PAGE_SHIFT));
>  	BUG_ON(coded_mem_map & ~SECTION_MAP_MASK);
>  	return coded_mem_map;
>  }

In mm-stable this was moved into mm/internal.h's new
sparse_init_one_section().  By David's 6a2f8fb8ed2d ("mm/sparse: move
sparse_init_one_section() to internal.h")

I did the obvious thing:

 include/linux/mmzone.h |   24 +++++++++---------------
 mm/internal.h          |    3 ++-
 2 files changed, 11 insertions(+), 16 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-fix-build_bug_on-check-for-section-map-alignment
+++ a/include/linux/mmzone.h
@@ -2068,21 +2068,15 @@ static inline struct mem_section *__nr_t
 extern size_t mem_section_usage_size(void);
 
 /*
- * We use the lower bits of the mem_map pointer to store
- * a little bit of information.  The pointer is calculated
- * as mem_map - section_nr_to_pfn(pnum).  The result is
- * aligned to the minimum alignment of the two values:
- *   1. All mem_map arrays are page-aligned.
- *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
- *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
- *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
- *      worst combination is powerpc with 256k pages,
- *      which results in PFN_SECTION_SHIFT equal 6.
- * To sum it up, at least 6 bits are available on all architectures.
- * However, we can exceed 6 bits on some other architectures except
- * powerpc (e.g. 15 bits are available on x86_64, 13 bits are available
- * with the worst case of 64K pages on arm64) if we make sure the
- * exceeded bit is not applicable to powerpc.
+ * We use the lower bits of the mem_map pointer to store a little bit of
+ * information. The pointer is calculated as mem_map - section_nr_to_pfn().
+ * The result is aligned to the minimum alignment of the two values:
+ *
+ * 1. All mem_map arrays are page-aligned.
+ * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest bits. Because
+ *    it is subtracted from a struct page pointer, the offset is scaled by
+ *    sizeof(struct page). This provides an alignment of PFN_SECTION_SHIFT +
+ *    __ffs(sizeof(struct page)).
  */
 enum {
 	SECTION_MARKED_PRESENT_BIT,
--- a/mm/internal.h~mm-sparse-fix-build_bug_on-check-for-section-map-alignment
+++ a/mm/internal.h
@@ -972,7 +972,8 @@ static inline void sparse_init_one_secti
 {
 	unsigned long coded_mem_map;
 
-	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + __ffs(sizeof(struct page)),
+						PAGE_SHIFT));
 
 	/*
 	 * We encode the start PFN of the section into the mem_map such that
_

(boy that's an eyesore on an 80-col xterm!)



