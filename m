Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC60CD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A79B6B008C; Fri, 12 Jun 2026 04:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F1A6B0092; Fri, 12 Jun 2026 04:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495936B0093; Fri, 12 Jun 2026 04:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37A6B6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:51:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA2A8A037B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:51:15 +0000 (UTC)
X-FDA: 84870641310.30.752A9C1
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 055F7180006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:51:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LNeUche+;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781254274;
	b=D9W118L9TZftpPEJLxPiWgsHvnzdb8KGSMs9/l4cIpc6Vn+bK7eVITvbp/sATUvLO1e4mV
	uopwXE2ZXjLJJvVkCUdRVKXgY0P2E0l+SH6ZxlFQzCgMIeVboM21SXOm49+RPtClrQPtHK
	hztuX6YDY4SNXpvPhLve1jLWA+LKdcs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LNeUche+;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781254274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMRz2y+ODLJ6wKlv3rNNMZU4weQYTIAWYxB0lbs16Jk=;
	b=bXoEDqpWS1hzBiAv/5BgtJfoJQhRwXjrrozix68Eh3Lk03qxz4Kvq2Q9sY20Qm9A37R7Jw
	ZlrGe5cxz5f3kq34fjPzSKNEjaL1TDkfEFjyJj6BEHHbhuN1xUUDhSyU1bVcjDFcKs6DsE
	KML4wAc0PhXnF3tXk5zcuPHHMGX5kyY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781254270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMRz2y+ODLJ6wKlv3rNNMZU4weQYTIAWYxB0lbs16Jk=;
	b=LNeUche+JRlDEZ07XeGplyh7cjJDtU4S4rjfet3lcLu2WF8hArOXKYGDIKX/5KtZ1yJwo0
	P0EsaS8CzW1uD/5F05mWujwaFAKutRKA3KqAtKGptztP9H9iw5aLrUmRP+B+anpHulaYJx
	cuyBrm5lk/TgrSvvubaf9jMjjeHa+nY=
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	linux-mm@kvack.org
Subject: Re: [v2 13/16] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Fri, 12 Jun 2026 16:50:27 +0800
Message-Id: <20260612085027.5401-1-lance.yang@linux.dev>
In-Reply-To: <20260602142537.198755-14-usama.arif@linux.dev>
References: <20260602142537.198755-14-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 055F7180006
X-Stat-Signature: huotr8mrmfn9rwdd4fqrsfs3fqfsaqrk
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781254273-997509
X-HE-Meta: U2FsdGVkX19QrjqbICp4J3NvBrkTAEhkhQdd8qaP8VYi3NATU6d4Fg51QLeP34552hPe3LhuDmfdfTOgyHsNTsU1vITX57xjZrLOO/ouGcDsSOxxlXxtl+CdGm6uwEZQbE6VmzRqVs0RbQ7LKrQZcuX823KJh4OJt5iJ2xOwfOO8Svy5OwVBwSwZ5Nk/P3BS2wq4VJdprOzy0MkLS8IwePdvHz3gl0Se9+ZxLQIK5CXGCe953LZaPN9cOhsPCAX3QUIjXov9LByxN241aqLiVALJNaynOr4FCPDsliWm4RtfeOXS+4hm22HydUUKLzJwV8UoGgwxfjYNh8yRSRvvlrbm8NFH/wIi0a0B6BaihMNUUccz1AwJi5BLdUZmWeTktS+qP0oVhYJrsvGaWMKMa636F7yBfCoaWWietphE+0iqwM+JUwslXjASrk19XapkA8cig2XsU7ve3NdP/pb9DJIA5wR8FABETMezqQUPY2GgMAg8eguGYwZt0UPxVcqleD+0f+nb6+ViUOEk+lP0G++Ne7cfZiRDTPPB+Y0/H0vZl6b9GGlB6fy7ttIF7kL8rIhq8OrVnDCoS9G5e2teIrJ3L93kzFfPC8evXqgGgP/z2kYDEQfDgP/Xa0ddNbPY7EVxa4x+c1at5KqVVIIibjUouVmEiPEDlMwIbGd6df9MQBG/y9XP9wROpZ/MPVYfbbJInm0OL6N+t/SzT2XbyrR9iRdx2fbKW1jUVdxnNg7i/+Q1nfBRWDvpBSAxuLGC4zojlH2vuhhfN9atdMf7HNDK35iDZxGRpVvj8gEm9kidh4bUi6q2j3AWQoSpGUgKSmySsBaaQ4KOOYqUxqDKoX1ONxP5qTdr6EDVRRAKSO8BHuR6+/SxxVoZ2VpB/Khx5JU3SYkPFt/CSSvOvHJF02VPtvpBnzYxoXs5jLR1wOnXAJUzFLU5rPRvhViV0XfVUfM2I0Svrs+VcmQt64E
 O8ZS6ibU
 96mUYRK1mvvTRO82U+wjDtKxB42cAc3JzYr4uMFc1jSKzaBbcbXzuN9/O2jeIXARrgEL4gJwYZw/faFQGu7toP87jycLH6Q+AGF4OKzZkqmdhbcveCJGb/l64EHa8kVJqIaTDI11KXakVY1UwaD1HrRHr5EnEPig3JLBDageyikPkwteCWurJ9u8V6nu/o6c5UcAKG/Q3J9oq1VO/5q74xpyOwrKuPnkxiw2YbgyKaVuTeIOHX4nBQcal3/AxLmQWZ9IG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc linux-mm

On Tue, Jun 02, 2026 at 07:24:21AM -0700, Usama Arif wrote:
[...]
>@@ -2846,11 +2902,66 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
> 	}
> 
> 	if (!pmd_trans_huge(src_pmdval)) {
>-		spin_unlock(src_ptl);
> 		if (pmd_is_migration_entry(src_pmdval)) {
>+			spin_unlock(src_ptl);
> 			pmd_migration_entry_wait(mm, &src_pmdval);
> 			return -EAGAIN;
> 		}
>+		if (pmd_is_swap_entry(src_pmdval)) {

Looks buggy ... unless I missed something ...

>+			swp_entry_t entry;
>+			struct swap_info_struct *si;
>+
>+			/*
>+			 * UFFDIO_MOVE on anon mappings requires single-owner
>+			 * semantics; refuse to move a shared swap entry.
>+			 */
>+			if (!pmd_swp_exclusive(src_pmdval)) {
>+				spin_unlock(src_ptl);
>+				return -EBUSY;
>+			}
>+
>+			entry = softleaf_from_pmd(src_pmdval);
>+			spin_unlock(src_ptl);
>+
>+			/* Pin the swap device against a racing swapoff. */
>+			si = get_swap_device(entry);
>+			if (unlikely(!si))
>+				return -EAGAIN;
>+
>+			src_folio = swap_cache_get_folio(entry);

We only check the first swap slot. Imagine we have something like this
after the PMD-sized swapcache folio was split while the PMD swap entry
was installed:

page table:
  src PMD -> swap entry S

swap cache:
  S + 0   -> no folio
  S + 1   -> order-0 folio in the swap cache
  S + 2   -> no folio
  S + 3   -> order-0 folio in the swap cache
  ...

>+
>+			mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0,
>+						mm, src_addr,
>+						src_addr + HPAGE_PMD_SIZE);
>+			mmu_notifier_invalidate_range_start(&range);
>+
>+			if (src_folio) {
>+				folio_lock(src_folio);
>+				if (folio_nr_pages(src_folio) != HPAGE_PMD_NR) {

If S has a non-PMD-sized folio, this returns -EBUSY.

>+					err = -EBUSY;
>+					folio_unlock(src_folio);
>+					folio_put(src_folio);
>+					mmu_notifier_invalidate_range_end(&range);
>+					put_swap_device(si);
>+					return err;
>+				}
>+			}
>+
>+			dst_ptl = pmd_lockptr(mm, dst_pmd);

But if S has no folio, the initial lookup passes src_folio == NULL to
move_swap_pmd(), , which only rechecks S:

	if (src_folio) {
[...]
	} else if (swap_cache_has_folio(entry)) {
		double_pt_unlock(dst_ptl, src_ptl);
		return -EAGAIN;
	}

So if S is empty, the move can still go ahead even if S + 1 ... S + 511
contain folios in the swap cache.

>+			err = move_swap_pmd(mm, dst_vma, dst_addr, src_addr,
>+					    dst_pmd, src_pmd, dst_pmdval,
>+					    src_pmdval, dst_ptl, src_ptl,
>+					    src_folio, entry);
>+

In that case, checking only S misses the order-0 folios in later slots.
move_swap_pmd() can then move the PMD swap entry whole without calling
folio_move_anon_rmap() or updating folio->index for those later folios.

Note that move_swap_pte() already does this for PTE-mapped swap entries,
because a folio in the swap cache needs its index and mapping updated to
align with dst_vma.

If those folios are later faulted in at dst, their rmap metadata still
points at the old anon_vma/index. Later rmap users derive the virtual
address from folio->mapping and folio->index, so they can look at the
wrong VMA/address ...

Should check the whole PMD swap range before deciding there is no folio
in the swap cache to update?

Am I reading that code right?

>+			mmu_notifier_invalidate_range_end(&range);
>+			if (src_folio) {
>+				folio_unlock(src_folio);
>+				folio_put(src_folio);
>+			}
>+			put_swap_device(si);
>+			return err;
>+		}
>+		spin_unlock(src_ptl);
> 		return -ENOENT;
> 	}
> 
>-- 
>2.52.0
>

Cheers, Lance

