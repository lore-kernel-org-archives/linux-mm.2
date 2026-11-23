Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 311A8606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=FCqETidW
Received: by kanga.kvack.org (Postfix)
	id 349276B05B6; Mon, 23 Nov 2026 14:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9EF6B05B7; Mon, 23 Nov 2026 14:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210286B05B8; Mon, 23 Nov 2026 14:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA0606B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F7F8C0A11
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:28 +0000 (UTC)
X-FDA: 85467440856.24.36A9086
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E835100003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="FC qETid";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463786;
	b=T3a3mL5hxTFwgxgAVKVtYKnVibSbVcJrpWxAAVmRy2jwMvucI8Zroa+SxHFvq8D+PR9c9P
	Jzi+DGDLj2fuF6gjGSxxOoxSqBLBQAY0lGN/wENCJz98VuboRnfianGNKxbJXbW3d+azyj
	tmoTZZBssQxjfDP5aoULjQ84SrntWPI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0l0hI0hPW7np4LU+X+ck4bAX6L3V8X+HfM8xQdpCOOc=;
	b=syPt99lKKAiS5wPT3rMdMcwYh3AzmeAKfOXXXreIzju9+7/q2ObYYVG2iyPU9VWQzJD/60
	ns5g05b9vlXoyfIerZvWkbVLK6CyyKwBSvgn4XrKdWULINjKH9+CBJJqqO+laDkDSpk1ub
	LAisLo5zQ1r7cyRqmcb3jAZIuUV4eHo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="FC qETid";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=0l0hI0hPW7np4LU+X+ck4bAX6L3V8X+HfM8xQdpCOOc=; b=FC
	qETidWA4RKNXtqQZJF/Ja0utDNejMx4YoeL0Jy31s8JWa0lHCEwVBWKz4TIwu2fxC7+szCLKIcKiq
	Vcr6devcAEeBjI/nsSOywlJqFYzJWJ6JAKym7x3YVRHhAjbqKSTnTHTABrBNcfOXZDS4NGKIBibiq
	W7z55h7VKp9vWFC+1bGn8XfsKwCGRL3ExaAvtMl8ZpgF6LilcKG7rvqr6oiBrut/POboUFKqVZUHh
	LxMDHyXsuzS5TUBmRZ0W+XODBVNSyq12GTTEKvD/h99mE7oJ6tM+hpQFNYsulqfwLhMFCXIR2EcGl
	YteFdaL6C8I6LDDo6qOSlZfAQaQIHERg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xVa99-00000006IU7-13XX;
	Mon, 23 Nov 2026 19:56:15 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH v6 0/9] mm/gup: walk and batch whole PTE tables in slow GUP
Date: Mon, 23 Nov 2026 14:56:00 -0500
Message-ID: <20261123195609.4115244-1-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t5ysytebidyutwy1f94xz9kxeff1p7yj
X-Rspam-User:
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E835100003
X-HE-Tag: 1795463785-191280
X-HE-Meta: U2FsdGVkX1/426VLkEi2eDj6MRSbR6/tqyporDuggdFqtq+mqPUwTBWx3wHLUnDEw3KT/AvR0dXBwe51ILhMw1M62ICN5gnsAOEjkZGvv5zHJwd+sqd92lRjJJmnvs4rsXWTTmTiHdS7faL6FFKR1U70dawVvXADypsEy6nJs8/pgMhiniEbyhqAe5/AXoPVy10t0kpBMjUYglhALtfwNkDPBxMFN0XG68i4pFtEBvukgHmd5CT8tRX4zeqEv7pOTV8IUwxhKdAw/9mOQPKEKFTsA/fVq6I0E79QJpJ73XiPxHMghZ3sFkia4ASKR7qr5gphY6+Jp4KxYB9mR524XYs4ExMPrYlhysYYnV+/AIAzPTRUbaRtscSVofXHTt0bFMDXPYOhjuACYFVzv+kdvrdLJ1Zr3kY1oq5i/m7dGs9mQZdCnWlyzQVml9PYMIKDBtwo21svwz/FsdVYWsxEeECeY9hpYqcov2xSscbd8s7pFESNR6G2D1+D4KtuoHduGyFjjjUuxci03e8BcQHN+/ukDjx9NeOKtFPw7lkP6n7JbnVzjn2Hvi9XCgKyrWaLi1y46upPSHI1VcimREpp5UGh0i+YVxevGCgf/KUk8hq6CeNsl0vQMlBeG7L/8v0B2/enIRseP+HrT3UtaolGgix2IAbfo8eEcS+hZ0a5aPqKHO1lBnTmjmhPvazo+s18B/vWm+wFFoPLDtscdUfWl159G0NxMWC9M2JeIGxXrziOyE+cRTtLYxTnEt2ECUfNo62JUYJX8PKLoWTUVCdt5Aij08hJzR8OCbeingLs0n0+jetaCm64n+Z3U+SfcAiitlTLBu9XWqJOzVa70H1OQgDcaMIQSC9DBiBwTtR5Q6vBUMGJz1cobV9DoLcDrHseDaEhTSP2cwzDIP8UkngplXbuV0MhODG3oL9n7MwHdTnQ4kgzgLXryngC/0eKlTea8P0gUNdv8j+Xbkt8gQ5
 YVCHiNvV
 A6ITHgi3TklJZIUW01YP56zK7wxNQ0u6hj/GtfW995iZmfDiXjHnMMs0nXGX4i5W+38Z/zYJH5H4XSPFcSMCnI5ZLVBvHB/UhfTV6xle4c6Hy8pqPeAvyBzOV2EcV90QFo7RkU2Ws6i414mgWupTvJ1QUsdafi46NmYSDzBVa/gxOSzsZZbd12FyrNwQfFsd8Mcyd4zZjhuQqyuBZbsZvZk1X+uxM7vKqP/MTawtojDd1H/dUmNEliHVJoAkV9nDEr900BETbzVocjMRHKBQITnOYYFTrQlEFOK/lwVxutpe/XwjHiM4xf9Vy6yhMhqUbt15XcxENZnJ7Aun+gkF2Y/oCxzRywP/wNjBUgWUDQV7WpXH+AADUL4RF6yLCU7+CVfp2aI9BzNNPudveydds2HYoSPaHe7X0Nb4xoMVebmJjCHJ14+4lIJ0SHZqZlCaqBUHloBDiuScZNFSk52wlPzUI05075vYpPKPrhdM0uQTaJHZ4f3ZKwtYelg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Slow GUP resolves and commits one PTE per follow_page_pte() call, so
__get_user_pages() restarts the pgd/p4d/pud/pmd descent and retakes
the PTE lock for every page, and a PTE-mapped large folio (mTHP) pays
one try_grab_folio() per subpage. The fast path already batches
PTE-mapped large folios; the slow path does not.

This series brings the slow path to the same shape in reviewable
steps: three no-functional-change refactors (store, flush, return
type), two splits of follow_page_pte(), huge-page count reporting,
the multi-PTE walk, the same-folio batch commit, and the unshare
check every batched write run needs. The
batch-length helper is shared with GUP-fast through an fpb_flags
parameter selecting the scan.

Patches:
 1. break out gup_fill_pages() helper
 2. break out gup_flush_pages() helper
 3. convert follow_page_mask() to return a long
 4. split out folio grab-and-store helper
 5. break out gup_lookup_pte() helper
 6. return a huge page's full count from follow_page_mask()
 7. walk multiple PTEs per follow_page_pte() call
 8. batch contiguous same-folio PTEs into one refcount grab
 9. unshare-check every page of a pte batch

Measured with tools/mm/gup_bench.c (PIN_LONGTERM_BENCHMARK), median get
time over 16 iterations on a 256 MB MADV_HUGEPAGE region in a 4 CPU
VM, folio sizes confirmed through the anon_fault_alloc counters
(4100 folios at 64 kB, 128 at 2 MB):

  gup_bench -L -m 256 -n 65536 -r 16 -t
                        before      after
  4 kB base pages      2753 us     1178 us   (2.3x, patch 7)
  64 kB mTHP           2946 us      231 us  (12.8x, patch 8)
  2 MB THP (control)     72 us       71 us

Patch 7's gain is the page-table descent that no longer restarts per
page; patch 8 adds a further 5.9x on mTHP by committing each run with
one refcount grab. Base pages share no folio and are unaffected by
patch 8; 2 MB THP never reaches follow_page_pte(). With FOLL_TOUCH,
folio_mark_accessed() drops from 512 calls to 32 over 2 MB of 64 kB
folios (measured by Yuan-Hao Hsu), matching the huge-page and fast
paths, which mark once per folio.

This is based on 102d6c3d5892 (merge of "mm: gup: batch PTE-mapped
large folios in gup_fast_pte_range()" from the gup-7.5-ptebatch branch
of mm-core.git)

 gup.c |  589 ++++++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 359 insertions(+), 230 deletions(-)

Suggested-by: David Hildenbrand <david@kernel.org>

Changelog
---------
v5 -> v6:
- Moved some dead-in-patch-5 code to patch 7 (Lorenzo)
- Clean up some comments and variable names (Lorenzo)
- A few more comment cleanups elsewhere in the series
- Changes gup_pages_not_requiring_unshare() so slow GUP
  FOLL_WRITE writes to shared anonymous pages don't get lost.
- Clamp the follow_page_pte() walk to the page table end without
  using pmd_addr_end(), which is a noop with 2 level page tables.
v4 -> v5:
- Rebased onto 102d6c3d5892 (landed GUP-fast batching and the
  folio-based unshare helpers); adapted to the store-only
  gup_fill_pages() and gup_must_unshare(vma, flags, folio, page).
- Split the store/flush extraction in two: new patch 2 breaks out
  gup_flush_pages()
- Dropped the "fill the pages array outside the pud/pmd lock" patch.
  Separating of the fill and flush helpers made it possible to just
  keep the (fast) fills inline, while keeping the (slow) flush
  out of the loop, at the tail end of __get_user_pages()
- Rewrote patch 8 around a shared gup_pte_batch_len() with an
  fpb_flags scan selector; GUP-fast uses the same helper instead
  of its inline scan and trim. (David Hildenbrand)
- Read-only runs are trimmed to the pages needing no unsharing
  instead of refused; the trim also covers runs of one page, which
  the fast path relies on as its per-page unshare gate.
- Renamed gup_grab_folio_pages() to gup_grab_fill_folio_pages().
- Re-measured the benchmarks.

Link: https://lore.kernel.org/r/20261116210127.3837898-1-riel@surriel.com [v5]
Link: https://lore.kernel.org/r/20261102193026.3860700-1-riel@surriel.com [v4]
Link: https://lore.kernel.org/r/20260811025157.1632867-1-riel@surriel.com [v3]
Link: https://lore.kernel.org/r/20260801031540.2742891-1-riel@surriel.com [v2]
Link: https://lore.kernel.org/r/20260730035350.1fc95dd8@fangorn [v1]

