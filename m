Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EF5606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FPcZhUkb
Received: by kanga.kvack.org (Postfix)
	id 357296B05C4; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E146B05C5; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0398C6B05C6; Tue,  3 Nov 2026 11:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C79DC6B05C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:18:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 533F6804F0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:28 +0000 (UTC)
X-FDA: 85394315496.13.BCA13C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1AB86100008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FPcZhUkb;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722706;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vo6hoMiBPUDbh+fzkkc+CS2eJkSiAj1jtuZ3hhzrg8k=;
	b=aswdV4PIraIIZ+V794idBwNvHY/3xO8hmKOx2BFvE1D0ozEfCp8T9Cif89ugA1z71vR1Hm
	d4FI3YEP3UoUVBW7aR+hfCJsuXD3Ubu+thQ1XuTBnPosM5fg06yvyMwPUf/nnPLbzhjf/U
	Khsqu7KxkHLr6JA40MH8T/7cehFNObc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793722706;
	b=q218/CC7O5CFjb9icYNJB9x8LFrqZhrIyz9gsskXMgtVhgMBIDGCK+gqkgNsONOdcEtny1
	XWnXQ6H1ao6nCMa/KdNOCnuK7YWWpTJKREdvt5IAdGFrhCJn/DbI+Vz6MEwtHc9QC9d5xn
	z8ecqy/DqAbmHsLc2+7tj235Owq4TxQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FPcZhUkb;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60AD342489;
	Tue,  3 Nov 2026 16:18:25 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793722705;
	b=Lmcy/TpioDivGcJTAluG6jdSpd8CMjoF5VP5UW4N4hPnGO99GgjE0dmIZnbL/obEOSsu
	 LNtfzHvhPRufdGwXcNijXLtmkknr3dYFYuoBBAF1ra6lpVJStn/6SBaY1yxFQDOWHE3M9
	 bj7NpX//4n6zaTy6AvUo96JLwEM5giCLhbDv21sK1d2S220/Q0tUkbrAXCWvhbYiUvBJU
	 8ewHO3vdGTH3+p+vbtT4dfg1nr4a3m0aWxs8TLeNUrygc2KgteFZNX3gssjKGgUA6QliN
	 trUJM+y6pPu8bS+rUGhcArqz2ziScejKKerL+sxPI9M2DMoowLX+3nKyGQg1s5XjNqw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793722705;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=Vo6hoMiBPUDbh+fzkkc+CS2eJkSiAj1jtuZ3hhzrg8k=;
	b=Pvd2xxEqBdtmTjwvKRmYlJZDrqUc8pCeIOaDiJxJs5YUHtz+nHT01z0DVnv/CKd8d6Mi
	 RTZfQIsPPHxae9FLl7RsWuVmYET37Fz5/YvLU1zhX2/Yb5/lacZKHsdadejiW3XmrNjBr
	 Vm5DSLGBgy7cSOw+MSPIOSMRmT1ll9Mov/rfyu0jGt2N9yh86czUxtFZTEpbHuDTGFNzn
	 yYREplaM6tcoPK8S41BObKnksRIGy3L3QNB/FxW8RrUdaTBLIQ3B9WjNVWgj7dEyPxdGB
	 07dyplCWg97MShRhizTN0q31pyQrp53wwMjEvjLUlrZwbq/dT7yQxTMi+wPvxpiBvQg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F1C721F0093A;
	Tue,  3 Nov 2026 16:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722705;
	bh=Vo6hoMiBPUDbh+fzkkc+CS2eJkSiAj1jtuZ3hhzrg8k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FPcZhUkbFbEluHYKs2Lmn3vZp8MZPqhq73850b++JU7cQ0v38opb9i7ECAFMC+QM7
	 q3DM8Ha39WEMS9hlX9BDFJqlVmTvJuYaq6CeXwvMr2qlVRUCasC2NEe70e4T0/F9tv
	 s69bM16ZLpOvMSfLJcc/nV4KjdMEP0PRA8LJMn2GhU7QP3ZmsmTfiV4unQhpQfI6A2
	 x5/ptwHXCSlHWzkQwEMZy82XPfEnEAb7UGqx320s0r0Boh4YxnCBnATE7YUXESnCg0
	 R+3KF4O55nGbeosM8aZwKxDHFCbQ/gNpShGRUk5Y5jIKdhcpDRG3QTmTR8vfI0FyYz
	 iei3IJnz7qH/A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 69F9646A0F;
	Tue,  3 Nov 2026 16:18:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 04 Nov 2026 00:18:15 +0800
Subject: [PATCH v2 2/4] mm, swap: fix large swap-in across swap file
 extents
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-swap-fixes-v2-2-204be064be5b@tencent.com>
References: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com>
In-Reply-To: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Usama Arif <usamaarif642@gmail.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, Mani Tofigh <mt4022@columbia.edu>, 
 NeilBrown <neil@brown.name>, Christoph Hellwig <hch@lst.de>, 
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793722701; l=4359;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=GjI89eGPjvzC9qvQaI4jjtxoYQv3OiREh4hio0wcSS0=;
 b=pXMFrpHnqc8Y7bcU7BrglXc0aXr6LGVBrXIlirVMe0LoXG5Xvq83pvj4Gryb44+ssrMYimEuw
 2ZjnLz71vp5CAsZXIzCj4CF+hwVkkwagCFtNgAhzHznxu6VlSGuavgk
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1AB86100008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 77rubkem4nka1bmgpndt5tz6cc5ueym1
X-Rspam-User: 
X-HE-Tag: 1793722705-647015
X-HE-Meta: U2FsdGVkX1/9tMoY+3cqJ6saczBf7KmBFZrwo9tNGdOKgkl3OVEX4txODJD7P3j2lMcvUdewcMw7u6zeXqJ507sy+mnWw/20yyDWiZaGnqzh2L54YhNAZvcVD4nBt6TovaC92ZuPC1r8FG1ijNjWeCR9o8h8uuiWz7hJW0b/9hrQMKtBqQlbGHfSHf2Nurv84Bwau0GjIWc671ZuZ+h+YtFYZzA2llCNO2C6+yZ10EwndInwMdKUXxTMp6cCnugdDCx2CcWsGM1Jbpl9eOSETAS+QsdkkIEGfTveA3InOGk3Zv8sM46HYHa5KugZ0v2qMTjbFbWspl/O6rKCPPL/iAE915R3phP1Tgm8X3KJEOuWgq5/0JwjuTz07xeJ7PUm+8k+EFU2rcSki60aarsh1G3ra1TQUDCK7MdQA080R2rW2YeiG5vwZUfzBtHiF7BS+rhhLX1S8KtWKqWki1GCiwGaLQo5JQ++Z2BK0MwxRvEnEiQuQWEs6RDulXJSMDxHqps5b6ZLq2/xHEHzrb39U3K4UIWYoaAGgLvOXo084MZUVgR8fIx+GGlg6Myskd/IcFYEgzh2RlaP3zW6TpOr3HOjK5HoO7B5WRwXB/aDxT7bXTIVK3uuN0CMNrhkFj0+1Gkao5wVnMB52Iu3xRUhQ8keU8LJUoSVqZuU1z4qIJutRWkXcH08zsnndYf4SjdYAK2g7GelXHfcLZvavCgK3oawrMIdSngmCCd6ChmpJkUnn/v0NldVHab8sryKxqhAd3WF8/P+RHS8s2zQlU4eWkEpqwkYLV+wgfgo5pkZWQBq99eVKh4q21xsLuxpbHdR3a4h2J5WVq34XzjiG5uGdZhzgqMkhE2q3AZDdJ7wvqm9xF6Wk0ixyqR9J0hBKR8J0gcf6RCbGkdF4UGDn7rViGIYed19AcBhkIXQHGNT69bF1xsH0bzOjq9i9x/vGT5dQyXE+Y5Nxgj0UBurMJ6
 prrcb5N+
 Xmy4OyaGBwsGQaSxPFCPKHifTnq7HrE7vw14Bc4KGPam/edIchdiACR4nAcn45iReoQ/CYIM8l7HmvoF2dTDnoWrJeEMnX/IIO2GumKgjWfclw6TLPhoigslqbKF6PagLQ2OdBz35prmCjJjCejRfjPT6EbVUN1J7TLKIEhAha/od85q7IT0obwUyxWFLHK1xJd4MDmGuZtMKOKkjPK9W/g6b16CTeodzuUf6NNiBAGDyTYmsc9SIMLzDVBXwg0ZZIUF0cK7QtEso+fWh8s1OPvruSF8KPjzfahbhv8AWu4oxtEohyaw1dmtM4xoxPZqzjSeo4FPii3OdwrOIF/v43oKVCvLIRJgSVlELaMLDHgUgl9175RF1ZYGCB4j0rh6sehDvDIkWQ5ximNZX9/kM0ekIgdyesl1RS1vR6oRjEHS6ZratWrRKW64RJB1hRoMsXRczzCqlgKvFo+HVcYfiTd1VoPV1Hz9WqUmdhYtL6oZOUjKPQ/6An7q2kSgZgD6WRwWvkcQDq3reRFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A page fault can give an unprivileged process blocks of other users'
files instead of its own swapped-out data. This affects systems with a
swap file on a synchronous block device, such as brd or zram. For an
anonymous mapping it also takes a huge page size below the PMD size
(mTHP), such as 64 KiB, that is enabled for anonymous memory.

A swap area is divided into slots of one page each. A swap file is a
regular file, so adjacent swap slots can lie in two extents, far apart
on disk. A folio is read from swap with a single bio that starts at the
sector of the folio's first slot. So all slots of a large folio must be
contiguous on disk.

The swap allocator knows this: it only hands out a run of slots for a
large folio if the swap area is a block device (SWP_BLKDEV).

The swap-in path does not. On a synchronous device (SWP_SYNCHRONOUS_IO),
one that always completes I/O in the submitter's context, do_swap_page()
can read several swapped-out pages as one large folio (a large swap-in).
thp_swapin_suitable_orders() makes that decision, and looks only at the
swap offsets (the slot numbers) in the page table.

Pages that were swapped out one at a time can end up in consecutive,
aligned slots, and are then read as one large folio. If the extent of
the first slot ends inside that folio, the rest of the folio is filled
from the blocks that follow the extent on disk. These blocks can belong
to other files.

Reproduced with a fragmented swap file on brd and 64 KiB folios enabled.
After single pages were swapped out, a fault returned blocks of a
root-owned file with mode 0600.

Fix this by allowing a large swap-in only when SWP_BLKDEV is set.

Known gaps:
- A swap file on zram, brd, pmem or btt is now read one page at a time,
  even where its slots lie in one extent. Its swpin counters in
  /sys/kernel/mm/transparent_hugepage/hugepages-*/stats stay at 0.
- There could be devices with SWP_SYNCHRONOUS_IO but not
  SWP_BLKDEV, so the new check would have to let that device pass.

Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[kasong@tencent.com: simplify the note about the unmerged xswap patch]
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index b65b56fe9714..944f57153c89 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4863,7 +4863,8 @@ static inline unsigned long thp_swap_suitable_orders(pgoff_t swp_offset,
 	return orders;
 }
 
-static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
+static unsigned long thp_swapin_suitable_orders(struct swap_info_struct *si,
+						struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long orders;
@@ -4888,6 +4889,14 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	if (!zswap_never_enabled())
 		return 0;
 
+	/*
+	 * Neighbouring slots of a swap file can lie in two extents, and a folio
+	 * is read with one bio. The flag is set in swapon() and stays, so the
+	 * race is benign.
+	 */
+	if (!data_race(si->flags & SWP_BLKDEV))
+		return 0;
+
 	entry = softleaf_from_pte(vmf->orig_pte);
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
@@ -4924,7 +4933,8 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	return orders;
 }
 #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
+static unsigned long thp_swapin_suitable_orders(struct swap_info_struct *si,
+						struct vm_fault *vmf)
 {
 	return 0;
 }
@@ -5070,7 +5080,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
-					    thp_swapin_suitable_orders(vmf) | BIT(0),
+					    thp_swapin_suitable_orders(si, vmf) | BIT(0),
 					    vmf, NULL, 0);
 		else
 			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);

-- 
2.56.0



