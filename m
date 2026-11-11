Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD30606AE24
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrLnn70U
Received: by kanga.kvack.org (Postfix)
	id CA50F6B05CB; Wed, 11 Nov 2026 13:15:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F416B05CC; Wed, 11 Nov 2026 13:15:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6FA6B05CD; Wed, 11 Nov 2026 13:15:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83A696B05CB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:15:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A59C12038F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:58 +0000 (UTC)
X-FDA: 85423641996.04.113016B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 503811C000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrLnn70U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420956;
	b=lapo7Le/SrbxbIbmqJose6eX+Et4N9DcH3uvvrDToLNWgbCUNRNKNYO6gp+c6s5MMAnlh7
	Z5qFmRtqZINOTQVjqwPisDoSvD//qqKdFmaVlbil8tVAfAEjb+/oLKlpmtii+hoje6BW1d
	HjhlagOUOgvK+xZD0C0twBgHSInA+1k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mm9n3peio9qUu21qZhqNukBQnTfc4SDNnkRR/crQvhs=;
	b=wy3GdbGbjWLG7WszhjcogCXI+CZc3QL0L7gL2a7rwhquwI1jjdIhrYdYIucJFP9YWlXktB
	0T+y1QKWuqhg+WGQH42A98r6hEFgb7GE555Cg4Rl8Pd4AeE5ptgRyGwVJrLdexyR/pLTGN
	xNSZN8FHJddfZcgP0QOkx6GgkWA60aA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrLnn70U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAE0461CCB;
	Wed, 11 Nov 2026 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064241F00A05;
	Wed, 11 Nov 2026 18:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420955;
	bh=mm9n3peio9qUu21qZhqNukBQnTfc4SDNnkRR/crQvhs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OrLnn70UVzKJ27gp/6Hro8tBdsvJ1PvIQWsDLGEXRqEse7iggDwnzSfBJ3KzYI+Ow
	 tkn8fPWyJDeM3jAKcJhYfXQOzMiLgMK+P6vhV+XPdnL6tV8nAD/sXGqG8DjzJLWEe2
	 4S1Ixr4i2iRJOjaTJLyWctKzef3qB7j0laoJwgPzcIxPTxGLQPGZUGJGi5XfJIx8pz
	 +On+lbx9Zd/xwcfC35ZnMD1uhdwr9bEnh6iMh4s/8mCr7X86m+eNXQxLL+h54V1hMr
	 EoWYT/cOcXuR54AE8W633bF76ZqWNQg8IURzgF3oct9MgeibeF6alTIkJEnTVVYZlD
	 0P1GR/0wqlA3g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:25 +0000
Subject: [PATCH 11/13] percpu: fix contig hints that are too low
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-11-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6290; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1FS7D/GzWO8a0dM988BcDlXUDKyEVksiXk4ExIzzEu8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMjRkJ6+S4vdPZRp/tTL82cueOcU06i69/+nC/FZP
 1Qb69d3d5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAihdWMDJ8Kyx2czrIu/uG7
 99xMtXlPctL8eI51LDKJz51jamUuPpXhn52usp1aXVht7c2gsOWsvL5n731bx+vOvWlKl1DqHb0
 /LAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 503811C000C
X-Rspamd-Server: rspam12
X-Stat-Signature: 5syzz14zmoxxhhypaz7axhd3ei9hh34y
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794420956-40128
X-HE-Meta: U2FsdGVkX1/+Hyzqs4Qb+JCJR2XWkEz7H3yQTMurRQ/YqANj7Fc/oU7M79uHPIS4fRIaSOK4o7K/jNObuaN6G++VhBQBncMcxZ7OiAz0918X5riJKE09+7WcavTsFKyaDTagJvVbSo1ZTfXDPF5pIUpzYnIJat0YTi9MdlXqDx+gL5r+dXjzL3hV2CCtrmA2Fy/zq4QkvuJ7pxSkma2BEaa+Y12aY2T/j7T+fJOSoKn5Hf3VojVhop0hMgpCBKlq82+fF/ATo+nmSGZxPSxFYQYc4Pns6VN5QcreWCCICJfG4PjihMysaNKBxQHwsQOwjApPxJAxWUKtlNnNfzoH01A3/AHOILe4jaycK+6wjh1LhrXNDAYts0NLArwWgjl+5UcLlmRve8OQs99LTYBmbse8vQ+atP5REfnFpGJYkFv2Ota9ZgGSYH2X4DCgOomh22slkzfAT0Yu5Evs0Z4XIYtS7BSVWEACabqKSGlBkbSYaQ4izVDTMOy4DH04Oq0AGJmixXrQGjgmj9e4Z40EwDneIg5u/t8gK0qKtl+XnZN4hcc48UQkKPGP4lSM1kUomKhvt2eapXjU5clzKtugBK9KeEfz3moeEe6gVRFtN3fcbGBPptdPpuKhHfvnO5D6gIV2HZRLrQBAB/jqYg0BcQTCtrsqs5YDmPrZHDs4ne1BEIAqh1757OT4aodTXgRTYqtdEWjoXSFy+FnLTuX5xSMRCEn5V4/L9KcO5npoh1HnYyRHv8nQE3W2f3LYnd7aJhKGGex22Ll5zOYyk3COGFGoPZfhTbWTTw6coF6ap4UScvWbM//xNhMgSABTMCXkLDOIpJyzBXhV/Cevem1ATcN1WJRFvMbDjcs4otundpK5YrsPDSVKrQqQpZliWxDseJ57sVWi7elFFYoZsNBtvIiAGS7sF/STgu4160tkrtneCpGI56vL+sKd9qcMEXMRc/jP4iM9tvZzFCvndYP
 H+GuVQJ+
 iR9dvIPyOeO2skkq/PGR1UfFm9XWSHMQh8GZHvcmZumgRiuQ0Qemumpqp8eFRmF+hWwD+zQ5q3cAzPpRg1DGZ8rfVrDQQf3OHmiErGZwfLE9d+pkgSGZBmI2ALcH59jVV1bmaN4Yh7FBZKubN7algpXUIlOrtUunuZJMukjTqxJi+D0kjNO3+wqSsjm+Tg45qxRK3HWHVYBu8zEuk/4yRqf4cd9DZTy5MvvmQYFlbPhBb+HF2XZM40KkDot9GGepHdkjOSsRACT3KKCjlrwPgpsFYDGFLz7CP7Ny/UGygJMiKwbClAjiUmlsS3dCvbg8lxbchHy5tlzQ3fBw34LZiS2Stv6WmLFCpbalKbBBgPK+n6LiIM3bAd+n2SiNmmygp8bx9dZLemOYugJhYpW6dYRa+B3UFQVfSbZUHtujSB1Wj0HCsnZr1jFV6Rul5vo4aKa/2/Q0N7cXlY7wlrBJFtG0k9w==
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


