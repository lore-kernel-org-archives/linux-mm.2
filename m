Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E819606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Krm1hHYo
Received: by kanga.kvack.org (Postfix)
	id 773D26B05C1; Wed, 18 Nov 2026 04:21:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74BD96B05C2; Wed, 18 Nov 2026 04:21:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AA36B05C3; Wed, 18 Nov 2026 04:21:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BBB16B05C1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:21:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A29621C4071
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:21:24 +0000 (UTC)
X-FDA: 85447696488.21.8DD8F6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 00179C0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:21:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Krm1hHYo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bwt+W10TXQFxJoo8KiCnGMFoLN25LK8LTHzrqrXkSOc=;
	b=Mdn8X+ujANoMpUy0w4v0uEi5TJo+Dk/GIHNn+KZNetAqQVohiFiKLz9oqKhBXW9xZFdzXq
	G0wPlK8Ja2pcmF6aeYo/zJyixq4+ferLcdCQtxMm9YQhGdG77E5nCPQ1e79iCAlDymhkq1
	0wVOaLglGCayO3i4PIOQG+/LVGsa54A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Krm1hHYo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993683;
	b=JPd4ifMs6wgk7NjZXhNKFJQIV8Wtw7n0Bw091z3CZMwQGhL0IhbzzIAVeGrbRShqRRa1Pm
	CrvQY+bKKc7AtMVK/aVrYxQc59fGEzKj0NtnoW1sTe9Fs5VS5xLgS5n1HJY/DYwIXOqSRu
	ROmI3/mbowkJs34HaEplDBedjhn1lpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3D4C61F99;
	Wed, 18 Nov 2026 09:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0C91F000C4;
	Wed, 18 Nov 2026 09:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794993681;
	bh=Bwt+W10TXQFxJoo8KiCnGMFoLN25LK8LTHzrqrXkSOc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Krm1hHYolUXKUV8kGXxVGoFFO8pHT4nd92g2hABlny+AAHIkHYUzNTFWYRo8fEFLA
	 11oYemQujHj0tQS1u3CNRVRfWXZYWwfdv9dw4bCwCYU4y6l9GYeJTDeH1vJOtQMMyn
	 IS3sBH6kVI3Pvy0+xLqp4rLrcWcaaAg0qyKGMHghITzpKZF0/nevUgftqUeBgzxS/G
	 Or1enOAY2eG+4TZsewqvVVi6GAnAZRd71X1DguKwTgImBxxw8P/JaScgWUt6wjjFoS
	 eUEM9WA1umgchwM6YPthDeRuz9ORAZck+LfYbF49N9p/cJ9MOnzsfshbatArtjfJ+O
	 djbtdgYe8xJfA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 18 Nov 2026 10:20:36 +0100
Subject: [PATCH 1/4] mm: flush stale TLB entries before installing a CoW'ed
 folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
In-Reply-To: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, 
 =?utf-8?q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>, 
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>, 
 Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, 
 Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3072; i=david@kernel.org;
 h=from:subject:message-id; bh=vwroXr9eWRQHq49VFaSRfOp1HZye8BrM6x31oeidRtA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+5v68u0hITPduqFlXiRqjxrPI43MWrA1YpbZT6T733
 GNXQzdrdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRk3oM/7R1Np2a6j5fO0zq
 4YauGIPgH0Il6dMzf5bNuT7tGH/++seMDJPm+agf3lkXlv/ALu7uxY+fDl1+oTY/YsYp17ybzeo
 HMlkA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: texsb6g3hsmwgbgqwubz9nshum46zgzd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00179C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794993682-308957
X-HE-Meta: U2FsdGVkX18dw1JcEAG/9uKj+E72GEzxdrKgCoGc2wn5Qj/5+0avHnsn3qRkbatOtuSQTOUN8CCo4l2R+JM3oe5y3Fc00qV/gceHIwgNjalSr8OTjxBA5TSLxvTbVJCfIrMEULKbutRIwBvJhvjgQCzru6d2y9fbFxu2KTw/bCUGqApomrOtx5a5ePGoM9vOvigEBj/RGu+WTbwpUj37kkivb5NkCX4yVYFbTZua6DSinWSvRINT1sXvIIjdZ7g059V3+a22TCzeAQhzcZkrMy483Fuxmxpa0zaPBSNozm6iwhsvUvR/rBpKNLgxzxwVWtZABT/hS+M1NtbFRXhwC/2vjxaXN0xfmdN5cFcXgjIHC9dO/pFWZKU37A2gR0Mo96TK9f3a3aoL25He3GAr9QsEgOyT4r7tenflr9y+eLb0MHHGnzZNV+3D6G9ToY+y+HZk5aQIK67/n+FmwMiOmgjzKyy3VH6IbIFt+clVXaIH084pUAD7XKIrO7r/9zx2OwL4R3mh0eINT575gVluu8em60ZRlq3tK0X2fxmGFP4+pVeUoseU/8KvQM/yxNZwVaBNcCyA14XmjGOwxMWBPr4rhl79bnpfcG7TRfDvPw27y9hJEAaAgUkDjxiOzNOmoS/EpKKD76J3Jr0JhM2BQT6/ouUTK4+/dlo1Bks2SkNKu8e+WcOHq5+x+PdRQiXY4o8L0h3eUpOZw057BX9CVvy/r0ktSF86oFfrT71DViaUqsJOpzkaYM6tpkSXL35eK7wNkMq99IvJ14fwEujFeBAiU1YqJrsYf+UssS8CK3cKL12rP7/z8V3SxqcvPQnwZi+5jKw8aZVfbIJsteKZ6grSbwsWHdH2YHBJ0EECrFoiid0mKewHOVSWOZoqh6j9QrTbuN9RSc8CSfTcYUu0UipnVYWaG6OEsCXVojoOrl5WvBmozfX7mjaNZ4a0zhGs+TBi9C+OrfXlnMMhlmO
 +G5qg/JS
 wGSLYCsyKxrQHYP6M4/GWmaOuPAwhxAjga3EgxQN3hBkqfVSBJIPsfHifJADm7siESpbHeWlhvUWc6tNht3vEPRifFymLpnjtVFwWTlRm72i42JUM7cZQqJvWyG6OvFD+WVhx7cwXKVNj8WIljrZlftZ7ucpKOu+5g+E/uWKiYwCTMAo6at0yzJHcZ6DRNie6ljvqLI4YBJZIdO+ZIVlPJEQBiNMh9AZ5Rtb9V43vnHr+5hfUO22BZaduxZyn71hIJkffKiwl4KJnB5LKnjT2IAr92TQDZMBzihrlA35dfslH00KFZFgDFVoi4h4/KO2ba5rA2ardotTa0s1OeXN8hnCaAMeUZfeeFQtx+VO+1cDDnFt6oIAyvxpo181pVgmStQKzUBDnO/E7k/92+eNtY4L8fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zapping PTEs in zap_pte_range() defers the TLB flush until after dropping
the PTL for clean page-cache folios.

A concurrent write fault in a MAP_PRIVATE mapping can then CoW the
page-cache folio and install a new anon folio without a prior TLB
flush:

	CPU0				CPU1
	LOAD(ADDR)
	 -> #PF
	    installs R/O PTE -> A
					fuse_open()
					 -> invalidate_inode_pages2()
					    -> zap_pte_range()
					       clears R/O PTE
					       // delayed flush
	// Other CPUs (incl CPU0) still cache ADDR -> A
	STORE(ADDR)
	 -> #PF
	    do_cow_fault()
	    copies A to B, installs R/W PTE -> B
	    // no TLB flush: PTE was none

CPUs with stale TLB entries will still read from the old folio while writes
go to the new folio, until the TLB is flushed.

We really must process pending TLB flushes if we are not faulting the
same folio back in.

Fix it by flushing the TLB before installing an anon (CoW'ed) folio in
set_pte_range() if a TLB flush is pending. Zapping itself stays as fast
as before.

Other faults are not affected: unmap_mapping_*() users only remove
folios from the page-cache after their own TLB flush, so until then, a
refault maps the same folio again. The exception is a concurrent
invalidation that removes the already-unmapped folio from the
page-cache before the zapper flushed the TLB; that is an unlikely corner
case that we'll not handle for now.

Note that we don't care about MADV_DONTNEED followed by a new read
fault, as MADV_DONTNEED only guarantees its semantics once the operation
completed. CoW faults will flush the TLB either way.

For example, imagine that MADV_DONTNEED zaps a page-cache folio and
doesn't flush the TLB (but still holds a reference). If the page-cache
replaces the folio, a new read fault might map the new folio without
flushing the TLB. That's okay, as MADV_DONTNEED did not complete yet.
Same applies to MADV_DONTNEED of CoW'ed folios when re-faulting the
page-cache folio.

Memory reclaim, which removes folios from the page-cache before performing
its own batched TLB flush, will be handled separately.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Cenk Yılmaz <cenk@deepfinresearch.com>
Debugged-by: Cenk Yılmaz <cenk@deepfinresearch.com>
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index d2f48d78b0d7b..e1d9759e6fde1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5888,6 +5888,12 @@ void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		VM_BUG_ON_FOLIO(nr != 1, folio);
+		/*
+		 * Concurrent zapping might have dropped the PTL but not flushed
+		 * the TLB yet. Flush before installing a new folio.
+		 */
+		if (mm_tlb_flush_pending(vma->vm_mm))
+			flush_tlb_page(vma, addr);
 		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
 	} else {

-- 
2.56.1


