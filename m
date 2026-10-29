Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16A6606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jiKV/D3Q
Received: by kanga.kvack.org (Postfix)
	id 406536B05D7; Thu, 29 Oct 2026 14:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CEC96B05DB; Thu, 29 Oct 2026 14:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220A26B05D8; Thu, 29 Oct 2026 14:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC1996B05D7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:32:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 627B91604EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:32:52 +0000 (UTC)
X-FDA: 85376510184.17.9B3EFF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36CA4180007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:32:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jiKV/D3Q";
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793298770;
	b=iNeZR4O0xLvuL1lCMnW0U61KhaD1ahclNv7QuHKIVoO6X3kSq0EuvNXX5nAYAqujw+vxXp
	7QkWpnOcr079bGqZTYOlJNuUkQ2D+E3/B5k9twXQ0+UZM0vt8UNp6l/6uqnYhKW7K77h8t
	yHsxITRSAd0HU6jj/VaQfzZC09Bn5uA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jiKV/D3Q";
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793298770;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pInFMaDInEWGSOqCBRl9P6yDu2yO8Mv6XuOl76c7C+A=;
	b=1yNFDudsCH47jsQz66whI+Dc5JCN2iANS0K+dpPmtmDyHzE+COe73fTwSmyTHHOdgVWJ/Q
	w2KiVVQS3qC1qO9X3pCBiYKVb6kQt4HXZR+kNeCyUY7EL2N+C+af351buP6PMYpD70iKkY
	SAOYVCuHW7nuK1dZfNFtxtMCWU5QTUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A59A43EE3;
	Thu, 29 Oct 2026 18:32:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793298769;
	b=DZ4adl39rjfKR95nXF9uDnZ9ndz0kW7Cyi8/J2y2JMZCF6ygMTj8m/4A+cCx3Nk0GrLu
	 AJc16os5n6a43RsWyxzZdC/RfTQd/v5ZMQF2j+BuDEKM3bzNsB0OV1sCaqDLYyQ2vteAv
	 PMm8HLJ1ihlzumZls+uY9GBrBLlMSkSZ5wJ9xA5tSp1uSER9p+ksOE8KuEwCCmYFGE4QY
	 pI5WOb3J+yI0/Z01+jhDF2Lrb82qoJ6tWtMihSucdRoHCocSfOJlLCBlTCaGgfC12xlIu
	 5ROUPllWwp/TmSxbCWjFCB4E6ta3RqoRThTt7QcbP68wNiYGJ8ZqxRsLI8HBzCuGG2g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793298769;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=pInFMaDInEWGSOqCBRl9P6yDu2yO8Mv6XuOl76c7C+A=;
	b=rzCpMNkmjN5mT8GQeIR9SPLc6m58Yc3sD1H9xhjB2fHc2697WVQDqkMbpAQb4geVPUYJ
	 6W2tSn7EXPhV2POcQIYWZ28vDUvQL2VWve6peWg6ChtACsk05Q0tAekVD31Q0MMWoGEQu
	 9HDWtRmCE+RTo3J9RiNIqqW+FHne7MEpq6OXvTDoowYLNQAMg2Yg7uSTWBXa34Lqd2PzL
	 fOFkry+OdjzEwBlrZrty0BdSd2sRcFW9V7ONE9DUmhcXCELQ1yBo2O0UjDXf/KMOmT8b0
	 8XmsqPFARqc/bhKeUfPTeffYZGRE9CLmtl+h2PvnDVEltvxa+i7UivVoJDQP5JxlueQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A1A9E1F01826;
	Thu, 29 Oct 2026 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793298769;
	bh=pInFMaDInEWGSOqCBRl9P6yDu2yO8Mv6XuOl76c7C+A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=jiKV/D3Q6hOFXhvEgtEvslTV7wuH38wTyLx389uMpqujBhVehSs5JAV8SZPJnxBfM
	 rT4egI9h1bB4wet/lpY5PWOHF4zaavv0I4R5D2qZeUUg4etrtHUicGQlCwvdqsNwnG
	 bB5kaLnhJl5i3/EjotR6IhDuH/NzHOOO7pl8bQ9nmnkECc5e+80JKZSP8f0eq24kxl
	 JqJvOg9NsTEluK6UMIAb2i2WlvSzGWn4Xu59ZweEJUyqAsHEkhqw1xXMlr4Fzx6zwr
	 FuvOSxXa6Ez8f4v0jv55c8gVbDMbuUBTsFG1m+Wy3RIU7HQlAdIedxfCVUvKAInC60
	 Lb8du/2BCYqpQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2664A45960;
	Thu, 29 Oct 2026 18:32:47 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 30 Oct 2026 02:31:43 +0800
Subject: [PATCH 3/3] mm, swap: fix large swap-in across swap file extents
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-swap-fixes-v1-3-73f73a59f2fc@tencent.com>
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
In-Reply-To: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793298765; l=4381;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=noZdScpFxNIQJGtkMJULE0ZL5MZND/LDKx/hvQROY0Y=;
 b=oR1vrkIjkjtg6R0rp3bKtmAM+V55cCGputUBDJNxtY6bYlA7dwVCqz/UH34NKd2/yGd9DtfFF
 JOvSxwQeHjTC1hZnmX/wUVYYbQ8H7WbL5/OrEGauUS/BuOGwua+7L8K
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 36CA4180007
X-Stat-Signature: 1ns35c4ubd33jremjynwnqifn91b6dda
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793298770-491259
X-HE-Meta: U2FsdGVkX18+XRGb7IzmEAPMoLmSYL9iLQhq4CDnU27Nse6MSqROBkctTqNmzdMLcVqB/pWR79TVYe9lDYve/0OAVF7qH75o1uDsM0d1CYo7JfGh0sEmMhMEGPjovFYF2mNX0Isw39iey208JdSoAKchekSJ4kTl6dAntHNqEg4OHvBALCaLOtGdbO4j4FA6OlBvRde7d2MAMKKY/dkKYGFpy0HDzaMSwu7H6lHxmgwCGrmmbFYZxwnetwkAs7lDceKE+bmEV1e0O0LTl6y9YXTIOIu3/lm/LzWa1+lovQBQE8gn0NBBGEoYWO1InBNYTtsVO7M359+t5OEX0/6CT3umLOYKSABv2I3xgGpEajYeCW+ZvhQINQz87++mX0mXKYOryEtWiwnQpjlGmY5rgh79BiZpM/dKwBZrJCTDsKpnjMyp57QjejRO1mbCppfvo2cextWUsp/4awN4AZg6VfBcmVU5b30S2P2kdwHEPRAJ4snuBVPPX072d1JNt2CgOO08P939XZPpNLRWcStvoSgLdrCsI5PxtuK+m13oy4ANIarTttC9d3BAVCLHvCEpMWsOaXTg49kHq3YHHxKmnjPNGCim1ewhobnA8Tsnl4lMLEyPqeInpGH8f+N8z1KoHobNXDvjfK+oxBbMMGSB6U+7xMLvA3dJPZyBumk30j9xVh5eBgYKoBQNBsA9K8z1q8DDcVt5aLTlyU1RVxH1Y1vp9mgXvraHAMcqo64rSHW5JFJs76RGQ1aMQzhqgb96EoEVKoFDNmWa76rX9jFfIMpm2pc2xZoI40WhgCNFzo35t6LegmGyzKNJCijYRLruTXKSL/4iNxJQtl5DzhVXDjDXddHsDfw0EycaR35mLuKlv5USZekKNg3VwdgjADDs9VTquZOyBeyQRdbjyx7Jfa5JzqXX0KAj0yoZG6tf77PornIQuCnLH7YYycWpr47b/hpeIpY+JXLouayr6mf
 fpb9Jyov
 Hbqu8ZHGfyRHzJbZofoQZkr96O0px72w8ov3WpyJ2SxoDQNbWAk9nNwAFHfmwlXW+CZjpuJHAcT9HDB9ZuAUzFAmbYPoG2gKJ5TmTd916ilVEzuMYNBwj0O2tEM7wRE2NGPmmOEwiroyapTzu1yiK48pYIkrdzfymhKqiFQ/bnLlS+UdWbC7IAqaAWbrNesfp2q2a3S7enu68rsbFAZpOe17ZUdPKOYg4xWbdWSopkgJgu5KlRs8la3Bh7i367aTGd9QmGIrz946SsegJ72H33+ACaSvepOrV9Mz15Baw942kNLp7+o6JS1FFEYOL+z35v8sUN7K7V+34qqARBYXhoe18h9ts3cto5i6uHX/GhhOc56gcXWP5TuFxNollYL1PMSQpRF45nWCkaL6HNCEN4DW22e+iPV9yEE4L09jXXXYloWfPqU9Coqwnq6d8g0oUcPaErH6F/RffjFoynF1TBtyfPJyAO6HCz5N9DNawIQH9BfCCLhmTtU1DaQ==
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
- With the posted "mm, swap: enable THP swapin for xswap entries"
  applied as well, the large swap-in that it adds never happens. That
  patch gives its swap device SWP_SYNCHRONOUS_IO but not SWP_BLKDEV, so
  the new check would have to let that device pass.

Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
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



