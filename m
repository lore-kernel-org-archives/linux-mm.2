Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376871061B1F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4316B008C; Mon, 30 Mar 2026 15:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C676B0095; Mon, 30 Mar 2026 15:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8CA6B0096; Mon, 30 Mar 2026 15:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A84E6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:54:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDD8613BBA5
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:54:27 +0000 (UTC)
X-FDA: 84603781374.04.8FCAE36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 27D68A0011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:54:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mmH6caD6;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mmH6caD6;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774900466; a=rsa-sha256;
	cv=none;
	b=QxjB0jd1J+UkaqhADkv5BLgalEg/vkqQEMDsRUe54FmegkqkdDr6Sbzfwsv9OsrnUyNOFr
	BlFx6dfhWWpfXR3IwEYThfVFWe9G3T/uX2FGmma4TXa4Jj2cmUv4sgXg/kZcp4FoTVzCT3
	ACI2sDVYsqAgjWYuobvzyTdRNWG/Zq8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774900466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DlxZdB4vJ6qSPBcJ7ScIZuh/mIwRyixeLuiUfji1Cxc=;
	b=GNXvRBU7nXOSXdV/XfCFRHcsJK+yV3SCudNo3YVzY/WcOgMGQFnYug/OVeMCaUFDPZ9fx5
	YQJJXUlmymdM48tSqn9pM1VnwUCSceJKqTkNbGBHbiP2Yb4Tt6hIFvsHGnxlGC80TahynH
	UupwC3hQ1FeGEC13iSxclwIwSFq9DFc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 322CD60121;
	Mon, 30 Mar 2026 19:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19772C4CEF7;
	Mon, 30 Mar 2026 19:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774900464;
	bh=PVggmHFroeTCysyxMzuB1gpR33ZPKG+IwSLIbZBkreE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mmH6caD6cf5ZzhC0rQz1KMrVf2wx+yEwqntoWzM87S8JUIu+KlW5rT2ui/qXnKvz5
	 GGCdaqeYY+TcWZ7rJNCO7bjpaNo8naiq2FqdOn63pssh5xZlFSNEP0PUjY8dVIZd9b
	 ZInP9Szdi2A1JQQXjXLO2fJ1oCYmTHfcC/voVBJQ=
Date: Mon, 30 Mar 2026 12:54:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andrei Vagin
 <avagin@google.com>, Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, James
 Houghton <jthoughton@google.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin
 <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 00/15] mm, kvm: allow uffd support in guest_memfd
Message-Id: <20260330125423.90bc3c6b0e9164d19e8a3995@linux-foundation.org>
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 27D68A0011
X-Stat-Signature: uu9dmy78z3wpstqfpxdaaowsz63xjq8z
X-Rspam-User: 
X-HE-Tag: 1774900465-104311
X-HE-Meta: U2FsdGVkX19rcDD+++hKEB0g2Nze+PqXNtmBwkKe9crHzoaahrTKhIRQKZxY2JpfQ0V5i/7oCXipLWqPezKBFceKOrX11uG2CHlG271HUiRnGZ9891UnvF4nxYphfoYIkCI4xcqQhDb0oyRbCEBCrnVuYwSypQByOTvUifKVPcbrN5HcmmrXrYECzq1SL/+J78eEU166lrH7A8qxK3BXdOCd/QPUbITt15axwhy/eUhzfbpuQh/laqVCdbpLgc3zRPBJ4KrCnS9FpwWa+E0hgMvY2PvRPDHgCiGBARo/D7A+KVOwymZY08HHDulBpus0xmHuBFkR+WZkFIR3a9m62SCCNambfcn01V4miAGy2k2P+11J4tUaloa0GqeixXs5pIGMpUyzWhgwYzkqy1Jy4DjR2rr7pTNobg8fiBQi33ye8Qla5DWWZkwIKjWkJ5may6gymoeoD4kWdgB3i4zpz0qLCi8uUp520ZjZSrmrXqG4Txa6bemqjLghHdy84v+vmj/ITKMmEmdeatLS3oOzeBNH/R2kEPJvu+wLYSGh71H/AY2gQRlW9tVjGPwlQVJiOV0rrFtfZMCa29ZS15AbtwmGJHJapvyG53hmRFz4khqEedzIFdcK//kRo2Mw0kq+qu/zEiovB5npz/eEfnUfJjEdsjs9CmcoagaE2irXz0QUY+GW++G2vw5QaC3tH3RQ4jdKO16TY+QVndz30/nSHYW7xq7Vy5Hnc2PsYu+8/LgrB+4LEBEg98ThltKadm5T2/hyYIuDeT+elvhc5slpOamk3zpcPEMHfnrL3XypopU5dVsVJbBtTvda7HKskw6OaHNTtoxE4jjSsMLvshH16rK4EmOujkR/tJkZ7hDfP4Azs/A0dITswzgwR7LwWNGp96OjWfqGam5CgVXO5b/k16X04ui43G52pgQw7WgRFhuzb2Mhl0EZByFMjqWSc7pJUsD3WTDHmxddWe5gNnP
 Bj0PQdPh
 eWaech6+gbbS6hDNektA8CnktQieeumKb6EIsRSOjsqK2NeNfO1VgHRzBLGVRWdTho6P2pbfqtV5/gtHNmSh7d36OcA1kyQ4oequPlNsRJxFauopeix4L+r6R2BxQWQ5d2czV4XPn3nNmFCgumeQTCaWjTortg2DL71HO9UykWq/gHluV0PTrw/ztGq5LL1abD4w6aQFqu4qTx0lx6UTIEUu5HiiNvhLaF3mtsZ6ZrnhEKcd6+5OM/w4hzkedyCp4okK5TYM3X/ubF0/0d4vFcYWBtJ0XQVyZjl77Ix0sTE+6+bPcxr2DOGDCk5U/8DS5v8Rt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 13:11:01 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> These patches enable support for userfaultfd in guest_memfd.

Thanks, I've updated mm.git's mm-unstable branch to this version.  I
added a little note-to-self to keep tabs on willy's [07/15] comment.

The series seems to be converging nicely.  Several of the patches
aren't showing R-b/A-b at this time.

I've moved this series even further down-queue, so it's definitely in
the second-week-of-merge-window batch.  So I'll be looking to move it
into mm-stable around Monday of that week (Apr 27?).  Four weeks for
testing, review and little touchups.

> v3 changes:
> * add fixes from Harry and Andrei
> * fix handling of WP-only mode for WP_ASYNC contexts in vma_can_userfault()
> * address David's comments about mfill_get_pmd() and rename it to
>   mfill_establish_pmd()
> * add VM_WARN()s for unsupported operations (James)
> * update comments using James' suggestions

Here's how v3 altered mm.git:


 include/linux/userfaultfd_k.h |    6 +++---
 mm/memory.c                   |    2 +-
 mm/userfaultfd.c              |   12 ++++++++----
 3 files changed, 12 insertions(+), 8 deletions(-)

--- a/include/linux/userfaultfd_k.h~b
+++ a/include/linux/userfaultfd_k.h
@@ -96,14 +96,14 @@ struct vm_uffd_ops {
 	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
 	/*
 	 * Called during resolution of UFFDIO_COPY request.
-	 * Should allocate and return a folio or NULL if allocation
-	 * fails.
+	 * Should allocate and return a folio or NULL if allocation fails.
 	 */
 	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
 				     unsigned long addr);
 	/*
 	 * Called during resolution of UFFDIO_COPY request.
-	 * Should lock the folio and add it to VMA's page cache.
+	 * Should only be called with a folio returned by alloc_folio() above.
+	 * The folio will be set to locked.
 	 * Returns 0 on success, error code on failure.
 	 */
 	int (*filemap_add)(struct folio *folio, struct vm_area_struct *vma,
--- a/mm/memory.c~b
+++ a/mm/memory.c
@@ -5493,7 +5493,7 @@ static vm_fault_t __do_fault(struct vm_f
 	}
 
 	/*
-	 * If this is an userfaultfd trap, process it in advance before
+	 * If this is a userfault trap, process it in advance before
 	 * triggering the genuine fault handler.
 	 */
 	ret = __do_userfault(vmf);
--- a/mm/userfaultfd.c~b
+++ a/mm/userfaultfd.c
@@ -502,7 +502,7 @@ static int __mfill_atomic_pte(struct mfi
 	} else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
 		clear_user_highpage(&folio->page, state->dst_addr);
 	} else {
-		VM_WARN_ONCE(1, "unknown UFFDIO operation");
+		VM_WARN_ONCE(1, "Unknown UFFDIO operation, flags: %x", flags);
 	}
 
 	/*
@@ -612,8 +612,10 @@ static int mfill_atomic_pte_continue(str
 	struct page *page;
 	int ret;
 
-	if (!ops)
+	if (!ops) {
+		VM_WARN_ONCE(1, "UFFDIO_CONTINUE for unsupported VMA");
 		return -EOPNOTSUPP;
+	}
 
 	folio = ops->get_folio_noalloc(inode, pgoff);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
@@ -864,6 +866,7 @@ static __always_inline ssize_t mfill_ato
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
 		return mfill_atomic_pte_zeropage(state);
 
+	VM_WARN_ONCE(1, "Unknown UFFDIO operation, flags: %x", flags);
 	return -EOPNOTSUPP;
 }
 
@@ -2044,8 +2047,9 @@ bool vma_can_userfault(struct vm_area_st
 		return false;
 
 	/*
-	 * File backed memory with PTE level mappigns must implement
-	 * ops->get_folio_noalloc()
+	 * File backed VMAs (except HugeTLB) must implement
+	 * ops->get_folio_noalloc() because it's required by __do_userfault()
+	 * in page fault handling.
 	 */
 	if (!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma) &&
 	    !ops->get_folio_noalloc)
_


