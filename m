Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D896AE94110
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 05:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA8C6B0005; Tue, 30 Dec 2025 00:54:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E076B0089; Tue, 30 Dec 2025 00:54:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56006B008A; Tue, 30 Dec 2025 00:54:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFFE6B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 00:54:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E37DDCAB77
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 05:54:07 +0000 (UTC)
X-FDA: 84275071734.05.8130C2F
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf04.hostedemail.com (Postfix) with ESMTP id 12B684000E
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 05:54:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=kEwyYJ+E;
	dmarc=none;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf04.hostedemail.com: domain of me@linux.beauty designates 136.143.188.112 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767074046; a=rsa-sha256;
	cv=pass;
	b=iCfA2255GM0ua3oj8mePedLdI45PtRUjmLf1XAIx+66cE8oRCcNMveGViSEe7uDI770xjY
	lLOX5DEaiUIR10iZ+b83CsaaRTfwxTVkBLKeTHMx8CTV6oEjN7yjzX+WWHflpnkfzcqpgn
	fjnkKNRo7j9IbUrRl42anTPRAhV8X08=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=kEwyYJ+E;
	dmarc=none;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf04.hostedemail.com: domain of me@linux.beauty designates 136.143.188.112 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767074046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1e9uUTBz+40NmI3fTdEqfK4QSWJZfTGjPJYHjncr7mA=;
	b=5XPIFLmGazC5tn1zuDUhKcqXqboxTRQOqmDq1LftOz9b5VH5V0pajy+FQKEbtA9s5Vjkra
	NIluBY23Dik+z9I1XyxXfsxj2mJee0331yEZmKRExHt6p5J1S8NgvSyw2ux3e/aT4ouQeu
	1uGDVSYAnASclLJgQMAVrYcpXSQxcxs=
ARC-Seal: i=1; a=rsa-sha256; t=1767074035; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=F3LqCm8Wah5SBnBGInhkixRT8PUDVR2E15M73CB8WywTLJSMDzNgCe6FVWotXanoYQeZzamIjDpy+CxMh0VU6a+GEtMM6On8v78MeQL9Xmk07DwcflUna9e2FNcQ+ahFgYD4kEYRytVCQxpWU3DM7IssI+RzN6psRKcXspy0BTc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1767074035; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=1e9uUTBz+40NmI3fTdEqfK4QSWJZfTGjPJYHjncr7mA=; 
	b=aabst8O1DRV87rkCvI+Ifr1GD9xnXvDzDYgX66zJkTSgM3sCFBwgiGRUdXdk5hq47G+gyMVQE6pf4e0pNCOtsFQB9NXF147493f6M7mlx6/133nNk2eFOET710657yZ0rr40QO5RSaTI+a3ImYHUweHueqWp59xLPs2CMsfPWgg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1767074035;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=1e9uUTBz+40NmI3fTdEqfK4QSWJZfTGjPJYHjncr7mA=;
	b=kEwyYJ+ECDAUV1X7n4SwslKEQ85vASPzYdmhkXNGkZXzuI8Rvho6xHz70H4YDWOs
	4s07dPdxdeFuOxz4KAKEo5ZgT0sB9sKWCUqd75EKOsVA2bC6cqEPjZyoScDWk2QQCKu
	QrFcPol/o0Q/sTpIhLvTTL4W4X4IWvwtj3BgyxfI=
Received: by mx.zohomail.com with SMTPS id 1767074032492365.5149488909235;
	Mon, 29 Dec 2025 21:53:52 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH] liveupdate/kho: Warn when kho_scratch is insufficient for sparsemem
Date: Tue, 30 Dec 2025 13:53:45 +0800
Message-ID: <20251230055345.70035-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12B684000E
X-Stat-Signature: 76tahunjww46z1ozjd61dtzkqxfdpo58
X-HE-Tag: 1767074045-577411
X-HE-Meta: U2FsdGVkX198k+1aXTV3eE0ElWv/HmxvIgt7QfHPE+6EY7L5uLXY8hv/PAzS1X842F7Xcm6zGaf3L7sWffWR0AjmgPbJ05wKmBKWSTRCiiJDoWW5jAycB+2EcbZ+G0S0piwA+eARRzJLqABiEDgM8aGZpLbbbFlYSMqexVQkNZI1WbrbJdUOH9KAd3LlIDzUoqkV2F8HmdL2zeVJ/32uKYyYdXnyVM/XUcgDbhpw2TnQ9mrHwc3WlTKRRa5+ns471P7GT4EdBx4G+M4lzTbbs+kh/tWdh1uM6METTbJ1wYQb7vUyXyGiX/QBCrI6VcSeAAGqGfwk8D8L30X9ugv26kwoeD4Xd6f/42Bk7v1sFdJeZecxAwC/73kli6aDn/39O46o6qszC85lS4AVeIAOBEFhG4UPngCH30y6vzGbMVUg9if18AUBwilZEttEhwc696YPoJkoN5egQSjDkmb/Quxj/IJh7gmxdRbylN3I9VseYaUfcglWDGVcvyGY7NESDW4BA/IGC9SXVXFdc1f+2AWXtdhuUsI5N8Kfc54yvzro55/M54uz0wn1+3ELx+P6kkLzppx/tcEOFDKKia8lQF79GlYkihYsMsgvJXivBuls/cMtfVLkvbvfFW83NzeG+BO5ytRBQntwn0w+SNuFbFnt7xUlHwVAUYaTk/0tkBwcIo4IS5ijvPuFb1H78zcdSB9FxBwnzSaKq5ZvCXmtwnemxLRvF9pDcMcFn6hJ9USOKWOsxK0Ru/wjA+wivbkFVxDusKG+rNKx9lIijei5HuUns+4ov6icF9Loeld/h64ULASYTVYbG3H5ncYhuEaV069npWn30U1jjKlbMyPB83dnKKGTkMye394lL6BF3zMu2a5i+lmLHjC3FzUEWGDChocL5n5JeZEpNGqUkDkkZl3OXptLO22glI7OpbWJ0Z1fJM3+N62pfZuPQGHx5X98Njq1x7gdZjZXzEBTz6z
 j68oYVaq
 7NL+SObFKfpZDrwe92fPZLYepAlTAHeNAY+Y1S4TarW9FMF0CBLJFmS//EUwwD7wCJD7WZoHCAIaa6KET9yx9DqggUEsLzP+iQrcz28AS5TivLVYVwxRr6eQ4rrCMgcgbRv+cByZLQeJuI+RCYmQ1rURA9WpewgIEPPlYIq+puQ13j0m4A4Dhk8QvJEt7mQFBHv4T20VmOqJ9X1fjHCtWrcS86Ofd2jdmOXpuf5BRA8HL46cepJ2vrMeF5nEs1TTW9CzjhAW3rvEN3c/ghhGTWzJGaXIamLZz5CoV++YuWrXSFy+vEGoSUkYMTSt1CrTBmdITDcWP5tc3+49HkWdPVPEkydfByfJfuxPQoCMlIIFAAI5mnsfg1NyO0DiSC+xdk8Lqewy62TVqp2RiG+Z3mCo3p/KrHiEmTwxkG0cBm0h7IbRgY7DTycBq5YH9doOV1Ty4CONNklSm/uZFhYTzGPfZff7QsgZ2VQ4B/FLPTZk/fYbh0UHEePmnCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With KHO enabled, the successor kernel can temporarily run memblock in
scratch-only mode during early boot. In that mode, SPARSEMEM may allocate
a per-node scratch buffer via sparse_buffer_init(map_count *
section_map_size()), which requires a single contiguous, aligned memblock
allocation.

If the maximum usable scratch range in a node is smaller than the
estimated buffer size, kexec handover can hang very early in the
successor kernel, and we may even have no chance to see the error on
the console.

Estimate the worst-case per-node requirement from the running kernel's
sparsemem layout and compare it against the reserved scratch list by
splitting scratch ranges per nid, sorting and merging them, and applying
the section_map_size() alignment constraint. Warn once when scratch
appears too small.

This check is a heuristic based on the running kernel's sparsemem layout
and cannot account for all differences in a successor kernel. Keep it as
a warning instead of rejecting kexec loads to avoid false positives
causing unexpected regressions. Users can adjust kho_scratch accordingly
before attempting a handover.

To reduce boot-time overhead(particularly on large NUMA servers), run
the check from a late initcall via system_long_wq instead of in
kho_reserve_scratch().

Signed-off-by: Li Chen <me@linux.beauty>
---
 kernel/liveupdate/kexec_handover.c | 396 +++++++++++++++++++++++++++++
 1 file changed, 396 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..69f9b8461043 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -18,9 +18,14 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
+#include <linux/math64.h>
+#include <linux/mmzone.h>
 #include <linux/page-isolation.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
 #include <linux/unaligned.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 
 #include <asm/early_ioremap.h>
 
@@ -504,6 +509,353 @@ static bool __init kho_mem_deserialize(const void *fdt)
 struct kho_scratch *kho_scratch;
 unsigned int kho_scratch_cnt;
 
+#ifdef CONFIG_SPARSEMEM
+/*
+ * These are half-open physical ranges: [start, end).
+ */
+struct kho_phys_range {
+	phys_addr_t start;
+	phys_addr_t end;
+};
+
+static u64 kho_section_map_size_bytes(void)
+{
+	u64 size;
+
+	size = (u64)sizeof(struct page) * PAGES_PER_SECTION;
+	if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP)) {
+#ifdef PMD_SIZE
+		return ALIGN(size, PMD_SIZE);
+#else
+		return PAGE_ALIGN(size);
+#endif
+	}
+
+	return PAGE_ALIGN(size);
+}
+
+static u64 kho_phys_range_aligned_usable(phys_addr_t start, phys_addr_t end, u64 align)
+{
+	phys_addr_t aligned_start;
+
+	if (end <= start)
+		return 0;
+
+	if (!align)
+		return end - start;
+
+	aligned_start = (phys_addr_t)(DIV64_U64_ROUND_UP((u64)start, align) * align);
+	if (aligned_start >= end)
+		return 0;
+
+	return end - aligned_start;
+}
+
+static int kho_phys_range_cmp(const void *a, const void *b)
+{
+	const struct kho_phys_range *ra = a;
+	const struct kho_phys_range *rb = b;
+
+	if (ra->start < rb->start)
+		return -1;
+	if (ra->start > rb->start)
+		return 1;
+
+	if (ra->end < rb->end)
+		return -1;
+	if (ra->end > rb->end)
+		return 1;
+
+	return 0;
+}
+
+static unsigned int kho_scratch_count_pieces_in_nid(phys_addr_t start, phys_addr_t end, int nid)
+{
+	unsigned long start_sec;
+	unsigned long end_sec;
+	unsigned long sec;
+	unsigned int pieces = 0;
+	phys_addr_t piece_start = start;
+	int piece_nid = pfn_to_nid(PFN_DOWN(start));
+
+	if (end <= start)
+		return 0;
+
+	start_sec = pfn_to_section_nr(PFN_DOWN(start));
+	end_sec = pfn_to_section_nr(PFN_DOWN(end - 1));
+
+	/*
+	 * Split at sparsemem section boundaries and classify pieces by nid.
+	 * This assumes nid ownership is section-granular, consistent with
+	 * SPARSEMEM grouping and sparse_init() run detection.
+	 */
+	for (sec = start_sec + 1; sec <= end_sec; sec++) {
+		phys_addr_t boundary = PFN_PHYS(section_nr_to_pfn(sec));
+		int this_nid = pfn_to_nid(section_nr_to_pfn(sec));
+
+		if (this_nid != piece_nid) {
+			if (piece_nid == nid && piece_start < boundary)
+				pieces++;
+			piece_start = boundary;
+			piece_nid = this_nid;
+		}
+	}
+
+	if (piece_nid == nid && piece_start < end)
+		pieces++;
+
+	return pieces;
+}
+
+static void kho_scratch_add_pieces_in_nid(struct kho_phys_range *ranges,
+					  unsigned int *nr, phys_addr_t start,
+					  phys_addr_t end, int nid)
+{
+	unsigned long start_sec;
+	unsigned long end_sec;
+	unsigned long sec;
+	phys_addr_t piece_start = start;
+	int piece_nid = pfn_to_nid(PFN_DOWN(start));
+
+	if (end <= start)
+		return;
+
+	start_sec = pfn_to_section_nr(PFN_DOWN(start));
+	end_sec = pfn_to_section_nr(PFN_DOWN(end - 1));
+
+	/* See comment in kho_scratch_count_pieces_in_nid(). */
+	for (sec = start_sec + 1; sec <= end_sec; sec++) {
+		phys_addr_t boundary = PFN_PHYS(section_nr_to_pfn(sec));
+		int this_nid = pfn_to_nid(section_nr_to_pfn(sec));
+
+		if (this_nid != piece_nid) {
+			if (piece_nid == nid && piece_start < boundary)
+				ranges[(*nr)++] = (struct kho_phys_range){
+					.start = piece_start,
+					.end = boundary,
+				};
+			piece_start = boundary;
+			piece_nid = this_nid;
+		}
+	}
+
+	if (piece_nid == nid && piece_start < end)
+		ranges[(*nr)++] = (struct kho_phys_range){
+			.start = piece_start,
+			.end = end,
+		};
+}
+
+static u64 kho_scratch_max_usable_for_nid(int nid, u64 align, bool *skipped)
+{
+	struct kho_phys_range *ranges;
+	unsigned int nr_ranges = 0;
+	unsigned int i;
+	u64 max_usable = 0;
+
+	if (!kho_scratch || !kho_scratch_cnt)
+		return 0;
+
+	/*
+	 * All scratch regions (lowmem/global/per-node) are represented in
+	 * kho_scratch[]. For @nid, split each region into per-nid pieces,
+	 * then:
+	 *   - sort pieces by start address
+	 *   - merge overlapping/adjacent pieces into contiguous ranges
+	 *   - apply @align to compute the maximum usable contiguous bytes
+	 */
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		phys_addr_t start;
+		phys_addr_t end;
+
+		if (!kho_scratch[i].size)
+			continue;
+
+		start = kho_scratch[i].addr;
+		end = start + kho_scratch[i].size;
+		nr_ranges += kho_scratch_count_pieces_in_nid(start, end, nid);
+	}
+
+	if (!nr_ranges)
+		return 0;
+
+	ranges = kvcalloc(nr_ranges, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges) {
+		*skipped = true;
+		return 0;
+	}
+
+	nr_ranges = 0;
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		phys_addr_t start;
+		phys_addr_t end;
+
+		if (!kho_scratch[i].size)
+			continue;
+
+		start = kho_scratch[i].addr;
+		end = start + kho_scratch[i].size;
+		kho_scratch_add_pieces_in_nid(ranges, &nr_ranges, start, end, nid);
+	}
+
+	/* ranges[] is half-open [start, end). */
+	sort(ranges, nr_ranges, sizeof(*ranges), kho_phys_range_cmp, NULL);
+
+	if (nr_ranges) {
+		phys_addr_t cur_start = ranges[0].start;
+		phys_addr_t cur_end = ranges[0].end;
+
+		for (i = 1; i < nr_ranges; i++) {
+			if (ranges[i].start <= cur_end) {
+				cur_end = max(cur_end, ranges[i].end);
+				continue;
+			}
+
+			/* Finalize a merged range and start a new one. */
+			max_usable = max(max_usable,
+					 kho_phys_range_aligned_usable(cur_start, cur_end, align));
+			cur_start = ranges[i].start;
+			cur_end = ranges[i].end;
+		}
+
+		/* Finalize last merged range. */
+		max_usable = max(max_usable,
+				 kho_phys_range_aligned_usable(cur_start, cur_end, align));
+	}
+
+	kvfree(ranges);
+	return max_usable;
+}
+
+static int kho_check_scratch_for_sparse(int *bad_nid, u64 *required_bytes,
+					u64 *max_usable_bytes, u64 *map_count,
+					u64 *section_map_size_bytes, bool *skipped)
+{
+	unsigned long sec_nr;
+	u64 section_map_size;
+	u64 *max_run_sections;
+	int prev_nid = NUMA_NO_NODE;
+	int nid;
+	u64 run_sections = 0;
+	u64 worst_required = 0;
+	u64 worst_deficit = 0;
+	int ret = 0;
+
+	*skipped = false;
+
+	section_map_size = kho_section_map_size_bytes();
+	if (!section_map_size)
+		return 0;
+
+	*bad_nid = NUMA_NO_NODE;
+	*required_bytes = 0;
+	*max_usable_bytes = 0;
+	*map_count = 0;
+	*section_map_size_bytes = section_map_size;
+
+	max_run_sections = kvcalloc(nr_node_ids, sizeof(*max_run_sections),
+				    GFP_KERNEL);
+	if (!max_run_sections) {
+		*skipped = true;
+		return 0;
+	}
+
+	/*
+	 * Keep the run detection consistent with sparse_init(): it walks present
+	 * sections and breaks runs on nid changes only.
+	 */
+	for_each_present_section_nr(0, sec_nr) {
+		unsigned long pfn = section_nr_to_pfn(sec_nr);
+
+		nid = pfn_to_nid(pfn);
+		if (nid != prev_nid) {
+			if (prev_nid != NUMA_NO_NODE)
+				max_run_sections[prev_nid] = max(max_run_sections[prev_nid],
+								 run_sections);
+			prev_nid = nid;
+			run_sections = 0;
+		}
+
+		run_sections++;
+	}
+
+	if (prev_nid != NUMA_NO_NODE)
+		max_run_sections[prev_nid] = max(max_run_sections[prev_nid],
+						 run_sections);
+
+	for_each_online_node(nid) {
+		u64 max_run = max_run_sections[nid];
+		u64 required;
+		u64 max_usable;
+		u64 deficit;
+
+		required = max_run * section_map_size;
+		if (!required)
+			continue;
+
+		max_usable = kho_scratch_max_usable_for_nid(nid, section_map_size,
+							    skipped);
+		if (*skipped)
+			break;
+		if (max_usable >= required)
+			continue;
+
+		/*
+		 * Pick the "worst" node by deficit ratio using MiB units to
+		 * avoid overflow; this is a warning-only heuristic.
+		 */
+		deficit = required - max_usable;
+		if (ret) {
+			u64 required_mib = max_t(u64, 1, required >> 20);
+			u64 deficit_mib = max_t(u64, 1, deficit >> 20);
+			u64 worst_required_mib = max_t(u64, 1, worst_required >> 20);
+			u64 worst_deficit_mib = max_t(u64, 1, worst_deficit >> 20);
+
+			if (deficit_mib * worst_required_mib <
+			    worst_deficit_mib * required_mib)
+				continue;
+			if (deficit_mib * worst_required_mib ==
+			    worst_deficit_mib * required_mib &&
+			    deficit < worst_deficit)
+				continue;
+		}
+
+		worst_required = required;
+		worst_deficit = deficit;
+		*bad_nid = nid;
+		*required_bytes = required;
+		*max_usable_bytes = max_usable;
+		*map_count = max_run;
+		*section_map_size_bytes = section_map_size;
+		ret = -ENOMEM;
+	}
+
+	kvfree(max_run_sections);
+	return ret;
+}
+
+#else /* CONFIG_SPARSEMEM */
+
+static u64 kho_section_map_size_bytes(void)
+{
+	return 0;
+}
+
+static int kho_check_scratch_for_sparse(int *bad_nid, u64 *required_bytes,
+					u64 *max_usable_bytes, u64 *map_count,
+					u64 *section_map_size_bytes, bool *skipped)
+{
+	(void)bad_nid;
+	(void)required_bytes;
+	(void)max_usable_bytes;
+	(void)map_count;
+	(void)section_map_size_bytes;
+	(void)skipped;
+	return 0;
+}
+
+#endif /* CONFIG_SPARSEMEM */
+
 /*
  * The scratch areas are scaled by default as percent of memory allocated from
  * memblock. A user can override the scale with command line parameter:
@@ -1259,6 +1611,50 @@ struct kho_in {
 static struct kho_in kho_in = {
 };
 
+static void kho_scratch_sanity_workfn(struct work_struct *work)
+{
+	int bad_nid;
+	u64 required_bytes;
+	u64 section_map_size;
+	u64 map_count;
+	u64 max_usable_bytes;
+	bool skipped;
+	int err;
+
+	if (!kho_enable || kho_in.scratch_phys)
+		return;
+
+	err = kho_check_scratch_for_sparse(&bad_nid, &required_bytes,
+					   &max_usable_bytes, &map_count,
+					   &section_map_size, &skipped);
+	if (skipped) {
+		pr_warn_once("scratch: sparsemem sanity skipped (temp alloc unavailable)\n");
+		return;
+	}
+
+	if (err != -ENOMEM)
+		return;
+
+	pr_warn_once("scratch: node%d max=%lluMiB need=%lluMiB for sparse_buffer_init(map_count=%llu section_map_size=%lluKiB); kexec may fail\n",
+		     bad_nid,
+		     (unsigned long long)(max_usable_bytes >> 20),
+		     (unsigned long long)(required_bytes >> 20),
+		     (unsigned long long)map_count,
+		     (unsigned long long)(section_map_size >> 10));
+}
+
+static DECLARE_WORK(kho_scratch_sanity_work, kho_scratch_sanity_workfn);
+
+static int __init kho_scratch_sanity_init(void)
+{
+	if (!kho_enable || kho_in.scratch_phys)
+		return 0;
+
+	queue_work(system_long_wq, &kho_scratch_sanity_work);
+	return 0;
+}
+late_initcall(kho_scratch_sanity_init);
+
 static const void *kho_get_fdt(void)
 {
 	return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
-- 
2.52.0


