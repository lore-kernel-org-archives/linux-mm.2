Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5A2606A33D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=BGKY/K5K
Received: by kanga.kvack.org (Postfix)
	id 33E096B05B1; Mon, 16 Nov 2026 16:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE086B05B3; Mon, 16 Nov 2026 16:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6666B05B2; Mon, 16 Nov 2026 16:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1CDC6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3EA6C401EB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:45 +0000 (UTC)
X-FDA: 85442203770.18.01F1682
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf15.hostedemail.com (Postfix) with ESMTP id 27DF5A0012
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="BG KY/K5";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uJdfltHhZFAvsReHrsmgovSCjxHOC3yyFwbkaqSO30E=;
	b=uVXs9tgeMUbrHoSCfOygflXkeZWcDALGslSd0pQgS0uZexOyi74KdS2I09X3ulxqlPC989
	Od2hbyWP45dDU+hKo/tW/t3VfalaWKqpBMkSMAEaSwafn5Hzxjdrwxz0S/N0xcz/Zq70gl
	Cd7HlaEiqzTUD+rFT26av/CR1MtPXLM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="BG KY/K5";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862903;
	b=F3EdDjTYQ18o8vY3lzqns5eXpFvx836IEjfZzwV2VqPCo/L8yrZVGa7WsySzpcrJwZDKdR
	XIpYzaUe5lgPLMy9jZSuuQ4lVNQP9KnTL1p79gajz14BYpvhyPs39XJ6Xc1pBFEvsxqdTa
	VWR5EWHr46YNSJIKCLlsE8+Ns8TIIKA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=uJdfltHhZFAvsReHrsmgovSCjxHOC3yyFwbkaqSO30E=; b=BG
	KY/K5KvnCDFysVuRpMO+kWN727fUdTGksJQ1UTnyMNvTZzzUuEURJE/7tqThDTBp7bZBYOTa8AKI8
	LnZddo+QYa9w8TiaLejx/aJAEip/w2/nJoyyjO9c6StSF0uSjOR9sdqXwvpM0EljYCX81Cl/711Zf
	HoApVer98IjYj7lqoMQX8lUF1Reb7sg2xxpv2uqe3SKD7L0YSfDCa46Vx/2WM2JxPjeOUJa/3YGob
	nUYw0cZKfgIJnmeVv+nWIH4oq73U6Ly97ZGDEgGteW9CpDbpiHLR0Pbr0XvA/sObg9tGZsJcLEKBu
	CIOs45KGYA7ZuI2eYr94aLjvmgIpKHog==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT3pS-00000007LIv-1d0B;
	Mon, 16 Nov 2026 21:01:30 +0000
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
Subject: [PATCH v5 0/8] mm/gup: walk and batch whole PTE tables in slow GUP
Date: Mon, 16 Nov 2026 16:01:19 -0500
Message-ID: <20261116210127.3837898-1-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27DF5A0012
X-Rspam-User: 
X-Stat-Signature: j3tnmq1cm3fhth3x1do13dog65gpenz1
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794862901-326919
X-HE-Meta: U2FsdGVkX1+clp2ZQAT7t1HyAMNCVVMRhgh9oCZGAoMQuMhLB+S3lYz7KRanHwVnE6KoLiLfrGRXwO79swGAn/UcnLG0ZbCxyPKEeMSxl3qD1gTK9McBD6RAOb+o/rDt2aBQZompVjx4KFU+liJgNeciVAArdurenpbepTmGZsFJGIylov86A6aLMGpXxEkz1bHnrYXeZxreaWJ5f2JM1zVlCx1vCJlhtYZlXwk5YS/FaCZqrM/uzZzf1oqVvP/7PnUfgrx+HyFRlPDmD4amth2EvZE4u+Bx5mmUjoEhQ78YMN06JkNWetIMsM5wbD45X1Z3Zyhvjwy2XFiraIZrGnKdHN7squiRoPIZzstY8DoyNuXaiVuz3QvFVT++ox+Nb6wDJ0sj2mh3V83cOW9WH2i/QRwNYE7M37IAx9ai/NywOuIX6B81XMTskAP9bGkaVVsfr5aeneCFeF9/V1mwyvt4Rv2lVVWb0CIu03zsN3xDdTnvTDEf/rfMJkIvDo7zZ6yKYJmdtP6xKDNP6bdG8xHVFdjqK/Ay7l85OtHe6SKkF5RLQlOJvPsumpOFxbeezHYYtjJJnxyXsJG1k/QFBIi/IrSgSVDvXcVfHqwHj8RVcGhNXsM4bSBlobiD0KA7x9VA0FQaxNIlo5SW/+h78PXTnvF0985xvP7a2gwI6CRVyDExwBm/9K3OsZ0ave5P13SvKsblaO+aC9tcj/TI/MRYyiC2jPWSGvGAfQda1/XM9XyxxVbFQzY2+Iem+aAVUW6mHGCC2X7s3spkV247b0aAIvZJ9o3kvcdREsSs74ygWOJe5vf2+KcTwlkUYBp7IugTX9vpgsDOxfBzrhYoxicEwhPJbQExe60oTFkqMOytag2q1fviRAl4TsLuyPLbW3vtZ4oSyU5wbbTj6Xs5iwXZjCBSiM3JuaHzPV/BKJX3Wf7xBMOtVeijvQV0xthfcQs82NfnBi6ifpRz2C3
 Itz6qCL1
 NvnuOzU2t18xLCyL8R0xePpOQJM+A0aHajkhKpJhCdEm8tkzBUbc49UC8lDf5YR+UtCBOw73lDZaCLc64rj0nN5xOpVgDgFVAmoiFn+BDaREngWNGuGYH/gI77Vtzfkr4bThzGC5yy6TereaoTZ/QochV5s+kgyl2epPLCf9BZzxAObBiVb/3wGMffV6P+M4gSf3sj4OkmZYSG2Bv77JQhH5W9PmYjN/K1KX6B2GmT9fULi2R4AzYACkjVH9YX09vVlqRwmsc3lWCEde+77kr/vwLXCT/fgaFwyCBix1ilVOodtWujwiBKh2geh28aftdKBkdyWYaqM0kuHrye95i0tmnpBpVuBxf14OF
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
the multi-PTE walk, and finally the same-folio batch commit. The
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

Measured with mm/gup_test.c (PIN_LONGTERM_BENCHMARK), median get
time over 16 iterations on a 256 MB MADV_HUGEPAGE region in a 4 CPU
VM, folio sizes confirmed through the anon_fault_alloc counters
(4100 folios at 64 kB, 128 at 2 MB):

  gup_test -L -m 256 -n 65536 -r 16 -t
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

mm/gup.c only: 347 insertions, 226 deletions.

Suggested-by: David Hildenbrand <david@kernel.org>

Changelog
---------
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

Link: https://lore.kernel.org/r/20261102193026.3860700-1-riel@surriel.com [v4]
Link: https://lore.kernel.org/r/20260811025157.1632867-1-riel@surriel.com [v3]
Link: https://lore.kernel.org/r/20260801031540.2742891-1-riel@surriel.com [v2]
Link: https://lore.kernel.org/r/20260730035350.1fc95dd8@fangorn [v1]

