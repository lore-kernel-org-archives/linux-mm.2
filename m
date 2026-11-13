Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B76606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GGxeeDnm
Received: by kanga.kvack.org (Postfix)
	id 530476B05D5; Fri, 13 Nov 2026 16:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508026B05D6; Fri, 13 Nov 2026 16:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E0C6B05D7; Fri, 13 Nov 2026 16:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9756B05D5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:47:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC1BA80156
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:31 +0000 (UTC)
X-FDA: 85431432702.23.C17C3D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E0ABC1C000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGxeeDnm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HExK7kLwtGYxqqtHxCbELsXf8y47tPfO+BJxdX9pDIQ=;
	b=8iOViyVTz/2vQ3u79KZjDKyG2n2Gd7UT+99RRr6lBxA7K3mSSwF5YKYjsrUqytdqAoYMFZ
	f6LmTIeQTk3VTmDK6nFTN5rNrWnJkOQQ+7isI0dNz8hMomYtQ6isOVaU12LnfneAu3nBS3
	ej2oqL5eddUt3AJoZMEf8QaHpZDyoRs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGxeeDnm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606450;
	b=MfrdxJBlLC+P4lNuRdAHI0yx/gcuMYLcmTHL3V6rlBeIY4vdQ3pP8eH3JqzJa4VVjPmXvB
	Vzo5vQcW0xbYkFPGHnpna/6DcfAHxr8SnwIAoMaWw+CdiucWeAGM1HK5xoBAseHO6WtHK5
	H6km7ijCCVok7w4Gl8GqVqdkaqwAtXs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42B71403A2;
	Fri, 13 Nov 2026 21:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41BB1F000C7;
	Fri, 13 Nov 2026 21:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606449;
	bh=HExK7kLwtGYxqqtHxCbELsXf8y47tPfO+BJxdX9pDIQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GGxeeDnmymBNFEyqfNOYwbzHXLtYqa2OtyXWU1xL0DuWktPQjz29XeofxjK+fTUCY
	 I9hyJPH8hSrWmTR2h7UKvtt+Fk3GUT2N27+78vMItTvhsHKl2cMhyUjAdeoSMQIu90
	 gjlhSVeb1dCkFwrpjlPcrWsDJ05e6fCgfWUu6yZU2ENyl+fh+vPLUw+DJLIsYAUhti
	 JUsyZZoSJQ/1ZVkCtUf1wdNIL3EJ3HxhOwqlhv0k+xkJ9sz5cFGMveAREJRjXtMa8j
	 0bQc+ZP7xN3reWijKGQ7T2J4UGFulxbZ4trpt3eT1yjc4gtTVJ80Z1H/rYN0zmBFnr
	 6mYuCEsX1m4ng==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:29 +0000
Subject: [PATCH v2 11/13] percpu: fix contig hints that are too low
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-11-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6398; i=ljs@kernel.org;
 h=from:subject:message-id; bh=tYXKOKPBvvIW94NkzmeBl1JGwwOkBZ9Xv1fW/VSYwh4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/y88dti70eXyqx/VhOfXV1mePf656k9aZ4SP+f/T
 xdbxGFe1VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJmK1j+Cu/cOr5Xe9cBb6v
 281X+eate5uWolXkx4cXnzu3x6+d97aEkeG4EWv1zIWR0dMau+bbzuqe8fLjoi1Ozh9cPyTN1to
 idIAVAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0ABC1C000E
X-Stat-Signature: n9qaro4pio6kz3dp1gkyxw8cx9mcz3i1
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606449-850383
X-HE-Meta: U2FsdGVkX1+Pype5niKZ6aZ8zd/NrdPBb77KcOUk48aoUSTrx/+VpnVccNv6bwcrX+r6bifFCH+Re41FWMTMlQ7S8PyBxrzXQ3WnCV7NrvmiitRgs/GdKv8FRDPG73Hg3VE6MwqXFIfukJB7lqONltTlPj0OmY6dvDv5l8GLSpZP1b6Gaz9kErfMHRFFEuchtKYLGw+WkVv9Z1dOPyvrvDyY7S8bE76OMW+fZqArr7tnurXuzUsAuiQxxvQHShZN4rHQ5M3Y0dlqq2/u3UGUg+FVEg4ewVvrRDW0asLPds85T0RNKL/PzlheRM9E7JweWHOZDSkiW2p/0fo1Eb0e02ZliYrEqMTqcRgJsrmxNcpzf5YMRVoTFQ4iztFe8JYh9bm4je/I4dW99/1gH2ruO2kZiYntGjO2BPEP/xMAF26ewXmeyFz5sArWJsLh9OFyEhaCle2zXIr494Q2uN9IccS2dAvmW6pX7ERNXXDveD30JFxvng6DZ3zT4h+KRedUNkOw8SRFckWS6MQzCMqQOlFCDQnF4O2RzeYEDSwfTYwmg9ydnTWVUvJK/MU6dXXysMuegmhFrmiUwVyT/Sm/bcrVec8IfOR+e1MsBo5+mJf5OXWkM3ojtfh0fqle1iJdtMWPJtGJ3nJYOEiryc0O1NTbBHHsjodO5tIdtnN7RfNx6eQtMB+c/OQzFidIsVEDDiqCm3HCZ+70qb0vhJC5W1dnaSBPm7lndIylFy+uNCiRxGF4nsbofvSPyvNqrWfmRVDDvgoHSIvqgsTpgCM6Ibsp2TI0Omw6TyMGjlTP/AHZTyOND3LCWq4MOWU5HV6RDo99KKWxnPENWu6bhIbISnprliC9W5Wj8LGrFJMrTY3gHEvfDeO4bnrv6BK57uLHW4bFuKj+N292LEjg0woSmup9fOdwAAc7KOPmO907zS8eA+4hEWBtGubdTMYuNH3STVlefRPgAD+Ar2o4szy
 dsMyCYw1
 WvtD182O2jRzfxej/uoMe3KS3OwJ7O6Xb4eTnccNjdL88uil8fBlEbKu/51ou3Aa9KNgU17JdRvq7Thq/Mcl5n3huC12t6Y6jVQfSlQ6sjgsaHIdcz4U2y7pWT/srM+2pS60IkbJgu1Wqwc9SSHjPm1wPA8cneouW8NvIh/NykibvWYtxr2p9EQ9VKbS+XnjrkndDCLFC2V6sz7/JKQF6TTT5Z3yFhFjfI8ALfea09G12Mgzb1MV9PDLsvjEdb/qKdW37YTMRS+2prnTKcEF+QWA6gQboTER29C3nlClZ5ROZhmfx2+kMwFfCT8Nqa0XGux85wFTgcVbljUGYTDSWUU1J/vqt1eB7Px5Q/20a5bjdCIDQ3QduJAHKzrRSkkcStTlv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

pcpu_find_block_fit() skips a chunk or block whose contig_hint is too
small for the request, so a contig_hint must never be smaller than the
largest free area.

If it is, atomic and reserved chunk allocations can fail spuriously, and
others can create a chunk which is not needed.

There are three ways in which this can happen:

Firstly, when an allocation breaks a contig_hint, both
pcpu_block_refresh_hint() and pcpu_chunk_refresh_hint() promote the
scan_hint to contig_hint and scan only what follows it. However a free
can set the scan_hint regardless of what precedes it:

    free areas    A = 10 bits, then C = 50 bits
    hints         contig_hint = C
                  scan_hint = 0, cleared by an earlier allocation
    free B        5 bits between A and C: scan_hint = B
    allocate C    contig_hint = B, the scan starts after B
    result        contig_hint = 5, but A has 10 bits

Secondly, when a free stays within one block,
pcpu_block_update_hint_free() passes the end of the free area to the
chunk hints as a block offset rather than a chunk offset, so in any block
but the first the chunk hints are not updated at all.

Thirdly, that free area stops at the block boundary, even if the free
bits continue into a neighbouring block.

Fix these by always rescanning when a contig_hint is broken, passing the
correct offset, and refreshing the chunk hints whenever a free area
reaches a block boundary.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: da3afdd5bb54 ("percpu: use block scan_hint to only scan forward")
Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")
Fixes: d33d9f3dd96b ("percpu: use chunk scan_hint to skip some scanning")
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/percpu.c | 59 +++++++++++++----------------------------------------------
 1 file changed, 13 insertions(+), 46 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index d7883507dc15..dfd3ff0a1ac0 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -733,30 +733,16 @@ static void pcpu_block_update_scan(struct pcpu_chunk *chunk, int bit_off,
 /**
  * pcpu_chunk_refresh_hint - updates metadata about a chunk
  * @chunk: chunk of interest
- * @full_scan: if we should scan from the beginning
  *
  * Iterates over the metadata blocks to find the largest contig area.
- * A full scan can be avoided on the allocation path as this is triggered
- * if we broke the contig_hint.  In doing so, the scan_hint will be before
- * the contig_hint or after if the scan_hint == contig_hint.  This cannot
- * be prevented on freeing as we want to find the largest area possibly
- * spanning blocks.
  */
-static void pcpu_chunk_refresh_hint(struct pcpu_chunk *chunk, bool full_scan)
+static void pcpu_chunk_refresh_hint(struct pcpu_chunk *chunk)
 {
 	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
-	int bit_off, bits;
+	int bit_off = chunk_md->first_free, bits;
 
-	/* promote scan_hint to contig_hint */
-	if (!full_scan && chunk_md->scan_hint) {
-		bit_off = chunk_md->scan_hint_start + chunk_md->scan_hint;
-		chunk_md->contig_hint_start = chunk_md->scan_hint_start;
-		chunk_md->contig_hint = chunk_md->scan_hint;
-		chunk_md->scan_hint = 0;
-	} else {
-		bit_off = chunk_md->first_free;
-		chunk_md->contig_hint = 0;
-	}
+	chunk_md->contig_hint = 0;
+	chunk_md->scan_hint = 0;
 
 	pcpu_for_each_md_free_region(chunk, bit_off, bits)
 		pcpu_block_update(chunk_md, bit_off, bit_off + bits);
@@ -774,19 +760,10 @@ static void pcpu_block_refresh_hint(struct pcpu_chunk *chunk, int index)
 {
 	struct pcpu_block_md *block = chunk->md_blocks + index;
 	unsigned long *alloc_map = pcpu_index_alloc_map(chunk, index);
-	unsigned int start, end;	/* region start, region end */
-
-	/* promote scan_hint to contig_hint */
-	if (block->scan_hint) {
-		start = block->scan_hint_start + block->scan_hint;
-		block->contig_hint_start = block->scan_hint_start;
-		block->contig_hint = block->scan_hint;
-		block->scan_hint = 0;
-	} else {
-		start = block->first_free;
-		block->contig_hint = 0;
-	}
+	unsigned int start = block->first_free, end;
 
+	block->contig_hint = 0;
+	block->scan_hint = 0;
 	block->right_free = 0;
 
 	/* iterate over free areas and update the contig hints */
@@ -938,7 +915,7 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 				chunk_md->contig_hint,
 				bit_off,
 				bit_off + bits))
-		pcpu_chunk_refresh_hint(chunk, false);
+		pcpu_chunk_refresh_hint(chunk);
 }
 
 /**
@@ -952,12 +929,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
  * forward and backward to determine the extent of the free area.  This is
  * capped at the boundary of blocks.
  *
- * A chunk update is triggered if a page becomes free, a block becomes free,
- * or the free spans across blocks.  This tradeoff is to minimize iterating
- * over the block metadata to update chunk_md->contig_hint.
- * chunk_md->contig_hint may be off by up to a page, but it will never be more
- * than the available space.  If the contig hint is contained in one block, it
- * will be accurate.
+ * The chunk metadata is refreshed if the free area reaches a block boundary,
+ * as it may then extend into neighbouring blocks.
  */
 static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 					int bits)
@@ -1042,18 +1015,12 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 	if (nr_empty_pages)
 		pcpu_update_empty_pages(chunk, nr_empty_pages);
 
-	/*
-	 * Refresh chunk metadata when the free makes a block free or spans
-	 * across blocks.  The contig_hint may be off by up to a page, but if
-	 * the contig_hint is contained in a block, it will be accurate with
-	 * the else condition below.
-	 */
-	if (((end - start) >= PCPU_BITMAP_BLOCK_BITS) || s_index != e_index)
-		pcpu_chunk_refresh_hint(chunk, true);
+	if (!start || end == PCPU_BITMAP_BLOCK_BITS || s_index != e_index)
+		pcpu_chunk_refresh_hint(chunk);
 	else
 		pcpu_block_update(&chunk->chunk_md,
 				  pcpu_block_off_to_off(s_index, start),
-				  end);
+				  pcpu_block_off_to_off(s_index, end));
 }
 
 /**

-- 
2.56.0


