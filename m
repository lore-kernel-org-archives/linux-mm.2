Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EBFC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E966B009E; Fri,  8 Aug 2025 08:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076B36B009F; Fri,  8 Aug 2025 08:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF55D6B00A0; Fri,  8 Aug 2025 08:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E381D6B009E
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:12:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DC9B80384
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:41 +0000 (UTC)
X-FDA: 83753478522.09.BD09788
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf09.hostedemail.com (Postfix) with ESMTP id BEC8914000E
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=ZaGJdeS8;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754655160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hl5pR6KEXqqmRKm0XQhFRqtMBlaQMUsVvgjCapFINjk=;
	b=OLROR8RSm7vpExqypMWXE1dxd03l3rIGlVO8pbUdqlhzacOE+GQrjgcgWb3dCJZOiCuY0s
	CDPSXLsj34qv+mlHBibBf5qGURfsOWPuMUl8V8IfPjNUUMOeH55CdPtuF66Hy1R++gQpRv
	Wu0v77Pr5a6dF0N1ytQmzBOLxzvE4/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754655160; a=rsa-sha256;
	cv=none;
	b=nV4mX6Ry+xKz+BobeLZD4iLOo1OzP9TYs8XocFeX7VQFzAF8gkHATO8PEmR81ZZ1kqZ1dm
	2RIkriC+/Lpxu6kwFA+6D4Cp3YtBqRTMdh2xo/T5xrA2d4pqv5NqMc0hupI9bRqQpcyijv
	iP92yMKilxFaKO8LDZfqgADmJgEyfaY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=ZaGJdeS8;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4bz2wN3TVnz9tLL;
	Fri,  8 Aug 2025 14:12:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754655156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hl5pR6KEXqqmRKm0XQhFRqtMBlaQMUsVvgjCapFINjk=;
	b=ZaGJdeS88MWI5NXG3Fy0kv05JzmFrCMryJvIIsk5SlxRa/OALrQpqUbO7OG/n/G7Yr4Sda
	dC51E4KZ2b2T2b4idAP7ty61iehCdDdUhNOLDSNhW1AF2IVMbXYgYSWs+s4UbOZupjCiQQ
	CrMfrkJTIZ6UhFu+zYI7Spvlm4qnjI34BohLV+Vnri7LWcR1fXSnQ3t/Qf/irCwFmBkh7d
	hbvaESdPDVdP+WiXUHeLXGApaEIyCK7tRLfTRQ4WfL3gZ9UmLIjst16rr58es4oLMunmUK
	J0tWLUSDz85HNspTwwtHPZN/P5PNBzW3xm7K3eSDeHBU2sWkWZ+zVs3Re+/L3Q==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	willy@infradead.org,
	linux-mm@kvack.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 5/5] block: use largest_zero_folio in __blkdev_issue_zero_pages()
Date: Fri,  8 Aug 2025 14:11:41 +0200
Message-ID: <20250808121141.624469-6-kernel@pankajraghav.com>
In-Reply-To: <20250808121141.624469-1-kernel@pankajraghav.com>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BEC8914000E
X-Stat-Signature: y7xpadbrdki89bghqu3p9egwe76u68d4
X-Rspam-User: 
X-HE-Tag: 1754655159-932314
X-HE-Meta: U2FsdGVkX1/ngsIpJZWpWHyFC6+3lUi1l4CBSF3JIHxwXEFG9LBiQ4X3Pniv+58ooEsYq/LsTiezS7HSDb9TprrKECizHO/wO96Qya3TMaGH/qroA0aZ1/Gbn7CczTxpPzLS75aLP80n9BX7OOTjNSjq8mNgkmB+vjMWDFBHhJjzbJ8we0ui76Ehl3XPluJJh1BGWdKHMb4LAvn/9l9Vwb5zRSbnBw8ZNl2p3XyiDjCJA15IdFI+Q2M086O0nJtZYBptOicjBc+/lJScOyqbdm3tvItCJlzJZKmgp3l+ODi3LIxq0N4Kk2/YxxHwnKO6t9Mox8Y4jP8IeV0KotTaNhj9wrR8WbrryMhfBmRc7iq6LoDUMKxj+05Ad+JouDZyKoT/WO5BOL5LOvFbjxR5oSs9schpAm1qR/z06yZwwfnN6kdq0/ByOTjpnLkBk3oXCEi7srYsxPW5udZiv84+/LRNIKKPMqxd6Z6h+EMaNIYewn2Nw3KFHTwiT4BoGPAEyNWXNDz8x5w77/R0hivgg4yAHxATgQy6+AUt0rrGB4UFfGYmPSOvCi7xwF+sf843ZkPaylskcSrlmrof0LxcA7B0zAgrQrmAQbVqyZfYrsGUluQtuJIe3mXRTFwQcK4kk1CY2tP8W2xQWnveKzc8xvZniJdvupGKNM27IPatghiytBOfIir5JngKhv7xd2Qf69CKL3oQ5F1mRJCF/yjBLzjigxHkF0Du/mBBDsB33uCDyzSNHlmLxEb5bSVMcNYvO/JNh5XR6wFApp/JPEdNoX/Qns9rAB7RGE9eBULEIN9O5VBNd/+nf50JCqKO+2xkQLH7ZfY86cgfYRE17MCIbHQAJp/M+mhhy+P8qOWLVlIOSWZT/lVvvv4bbLwJwT7NPndqVWdyRKRugXkvPRJLJTnyC+ITiiKgohAuPb5ZTsHAw0CfjLJS9XsHjlxPvXxViTPctD693hbb8vtYsKo
 SzCkbX+E
 zyTDIQ29nkQkb4jl/aZ8u32YqcewHW9bGit1CPWqm/nwSBjOOc8HZ8Sa5LWTwwiPp0+jYsZuYdiX36pMiSpZXtX5Bb5n9uosO6kADxWBbEdYPW4G56i9bo4Z3CjDByoZm/ojnnqB3JgDiKnXylUBBEAXb4cLsQAc/GlsyDl9R1aJq3eSnw6Bvt2fg2kPKHPHR9dPE05nsIUgWizIL1QVZhxeMy5/HLYlYQX6p3i0N4qABi9q2x1boT+nzRaj+mz3YbIGlkN9F25z1c1gDsrCYLqDl/gHO3emJtNM8v1mtyCFwq2frCDfpQEHJUaZtHsKCi4zVqY/gberTh7sC+ZrB2JB+oUUuIDO40OYsx+yyYoyzEM3A412IJ5uAsZAu6jUJUdWfJ6nvCCovOIKIiSfZiZ9mphXnSdb2tE4CQMBv4sHsY06IkiEX20FF8ioooqsZpyygNvwgWNQyCJs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

Use largest_zero_folio() in __blkdev_issue_zero_pages().
On systems with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO enabled, we will end up
sending larger bvecs instead of multiple small ones.

Noticed a 4% increase in performance on a commercial NVMe SSD which does
not support OP_WRITE_ZEROES. The device's MDTS was 128K. The performance
gains might be bigger if the device supports bigger MDTS.

Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-lib.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 4c9f20a689f7..3030a772d3aa 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -196,6 +196,8 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
 		struct bio **biop, unsigned int flags)
 {
+	struct folio *zero_folio = largest_zero_folio();
+
 	while (nr_sects) {
 		unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
 		struct bio *bio;
@@ -208,15 +210,14 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
 			break;
 
 		do {
-			unsigned int len, added;
+			unsigned int len;
 
-			len = min_t(sector_t,
-				PAGE_SIZE, nr_sects << SECTOR_SHIFT);
-			added = bio_add_page(bio, ZERO_PAGE(0), len, 0);
-			if (added < len)
+			len = min_t(sector_t, folio_size(zero_folio),
+				    nr_sects << SECTOR_SHIFT);
+			if (!bio_add_folio(bio, zero_folio, len, 0))
 				break;
-			nr_sects -= added >> SECTOR_SHIFT;
-			sector += added >> SECTOR_SHIFT;
+			nr_sects -= len >> SECTOR_SHIFT;
+			sector += len >> SECTOR_SHIFT;
 		} while (nr_sects);
 
 		*biop = bio_chain_and_submit(*biop, bio);
-- 
2.49.0


