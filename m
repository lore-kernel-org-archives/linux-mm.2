Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A0ACD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401816B00EE; Sun, 31 May 2026 00:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1CC6B00F0; Sun, 31 May 2026 00:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C85F6B00F1; Sun, 31 May 2026 00:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE4B6B00EE
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:28:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE92B1A03B9
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:28:25 +0000 (UTC)
X-FDA: 84826433370.02.660AAEA
Received: from outbound.mr.icloud.com (mr-2001b-snip4-11.eps.apple.com [57.103.68.23])
	by imf24.hostedemail.com (Postfix) with ESMTP id BA733180006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:28:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=VR3BYHPX;
	spf=pass (imf24.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.68.23 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780201703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhbmzU8f+DtLeo7/JiKJOt5bFOzMaSbF+v57Q12naMo=;
	b=0y9kM+LQeW/KC2E526o8DYOxixPg4Jk3AJTH5Ce7eJiJuCJnQp5AUhRH21KyULXrg3ndhE
	Fk+D9IuzRcI/SNunFxB2wBHNfeBQlvvQlzJzzgnkppiqoF5rr0zDGXrwu6UviuW2NmdoLE
	89GEhvB9l3gasNL3zaKrjBGCHR6ALEQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=VR3BYHPX;
	spf=pass (imf24.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.68.23 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780201703; a=rsa-sha256;
	cv=none;
	b=h3v8uR1VNeAeQgW2vMH2e54BAJpb2jqPIs5S1Gbi4ihgid5GEdohqreoH8xv85RL1SQbR4
	oQHXMqG8YYV/D9qoT7OXSJxNpK+BAkyYVFccQ6+ZQRydNx/sUPUmHtYuo7aSb8EZ/gaAtY
	Qy0CFJDLwrSF6E/RAdWDLATbhPYzNwA=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-4 (Postfix) with ESMTPS id 11D151800171;
	Sun, 31 May 2026 04:28:16 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwdDCFVHBUc0UR9VFFIdRA5tGFAWR0BBWh9EFEAFWwRYCxNdTFBfVitGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780201703; x=1782793703; bh=bhbmzU8f+DtLeo7/JiKJOt5bFOzMaSbF+v57Q12naMo=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=VR3BYHPXC/5ooK91OfM9H7foeW+CQSHUnC+y9ZCelBzSsdaOv6XMTtXaOQs+HSqO5UeF7fLQ2IJIZA3Z7uVVyeQI+vCvWKqu/wstdMaHb70qGkAbdM2PLjM8YFq0I8Zp1zbcur1RDH9YmLLBI4iHjB9bElUEKgepwYJoZVOy6V7HeOZNjl10X8Phe+QJNFCyMgbqgYPVuYpC0ciuBjk7Rd6fCWR9Z89PJEJ9+TThbcYh5FsDyQo+W6XrCifuaaXxNH8T2pteqrRCQ7kbD5FVBoBgvNf4GRzV72pa2RbKE5nwCcddgBpyEIClC2/j4giwkKgpOh6wS1wH5awxvFgOEQ==
Received: from [127.0.0.1] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-4 (Postfix) with ESMTPSA id C45731800114;
	Sun, 31 May 2026 04:28:06 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Sun, 31 May 2026 12:27:20 +0800
Subject: [PATCH 4/5] mm/khugepaged: add accounting for successful hint or
 non-hint collapse
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-thp_collapse_hint-v1-4-866339cd4c2a@tencent.com>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
In-Reply-To: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780201643; l=3543;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=fMQSPKl1zRvOYMdFUia4IDMTy4aTjy06OEcQUlcbylM=;
 b=g6hskuajwDifuMlmQvwXr7m3gvsQsG3xboa6bdOJ6SgjH/Fyfhd7w2b5Q80kpTF2fGF4LNo8F
 0yMQCfVmh3mArC+6szHFufSG++WLY6mSpGGl0aVod/sTQ7MAhojQ/Pz
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Authority-Info-Out: v=2.4 cv=AvTjHe9P c=1 sm=1 tr=0 ts=6a1bb8e4
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=0Ztl7DgICfUfD0EaiaYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: yz54fiqE8TjX4RhqkROvSzCb1_eTk_JV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0NiBTYWx0ZWRfX6jolbC6oTORJ
 jDnOhHXnV+NXz2xs37S9CoZAHvweRKv5SyS3VtzwTOkjyvw7C6aQkmgdFQ6Zim/eeFsF2jhmPod
 AoOFBOPvCz9EX/SSpHehGjp0fT6niK7Npb3Dzhac6aEIvkF5m09cSyMTw8CZbPRnww38EO4NYQp
 naXS1Wi4WIMDWuT6nN8LnShZL9p32T1od0eDceDXhBXp9Ob09iHPWS2okUGhXpCr/Rgq71n8Z5O
 Us38k33MJiQkrXn1TfNeAaQUGWiOz3yRh3JZiZEcqe1EH9oUY7uoib0htE5dLIX0fJpTFTcpAjU
 zIkJ/PsXG/MvhBUpS0PdxgFMxtZPOHe+yjr9erkbx0hLH+cdLl636DHL9DyjhU=
X-Proofpoint-GUID: yz54fiqE8TjX4RhqkROvSzCb1_eTk_JV
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA733180006
X-Stat-Signature: t3rgnar1ustga8m5rrsxfuo5bhrke6jg
X-HE-Tag: 1780201703-396504
X-HE-Meta: U2FsdGVkX1+rKOHbkA8lmU/Vx2Lb9ObcuZYwn4G087UDiqkiQokH0+9lzMVnHm6PmIShkZu74boBOfWcGz/v0NAlFEEFRWYY/Dk37rAetd0dN4gylEKrrxb53yNetWBxUoqlCtAc2y2xjmTchwJ3z/vSuuRt8+iwfGpheyDHB/Y7d8OCSiuGbSAIXr3Y4jhYIEgtdbnGzCr1g4J4n6uD+6wjVsj4C+WJoZaxzkTS2eQ5CtGcijLsjtViGC14duFKGBKPUk2igpP2jYTQqHCBSH4Xz8wK+GhXva3qGm2SDTgkiLA4hB17sJrEhWJ5b2LTqaU8vxz5QR5cbwz0xu4ZsXFlykXPqJ3QLVca0JC4aS4l9Sag9qDVABI5C9pG+OW+lfJbIzDJPvtgy8p1AL25srCZ5R2fvXKJ9nBvFCnM30u1WnaytkE99H57TqYnBLnPpR8QKiDA+yZZCiiE4FgYiTh1s/rmgLm/uWpJtgJMbZ4ppCaAUNdENDjaVtufxDLT5GA5hZA/YKz5JYvvq1FMu6msTxsQLIGORS7H33vPc1mJF+JDsO3fNP94jjRAhTbYizgYuEzgKI08OFzonrZ6t9QxC6vU1R9Me4tOBTlNW0p9oVbvN42ftviaSHnCK7/ysRUFAFAsIj3yWJYChoEXiVrn3DupSF5E0VIyIAANuFeujkbIsp7D0OOeVC90/wt0uvBw3wzXMyFPHy6SOKjEfghGd75v1AjyBwpffdqKn66Vx+rGBiDzhGERowm9HG//azyz/jMlQb1ZgsPeMh6rmInu3GUvNuwpJb2cPP+nJMaAKFS2vbv253QQoU0WysdY7ec++TXTx3352txZrCT7rnKVlkoS2rAaqqx4BddhQ0GQ+MWfZhE78NdmK4uWVXh0Cr4h2oeDeC5QHUO0M/ySH2MnhF3pOqaczFFmjCBL7oRqMlS+CqjHpFziG5KRQfdiL1hi9d6fvwlTNIA9bWb
 hy/fRdnh
 YxUGoJm/YsgGavDuYHc90XBzEUp8topOhWpWuql9araYGlGsG/v5w5SDMrhc5baeo9fjYyGd+fa2UXfCPf2Q/hKBYnMXPy0rEwMQqDAtxBdPMZm1wXPcjMbaDgUZNWdqA4OolTbeI/wRVzCBtaEaC7VFCT8qFETtBF/+3uh3Cbkz2vZfql9f9JW7EiaK+YOUA6NAcoXj5aDMzhNqFsq0CLyp1elLiqvJamdkm/KGurxfE7pPUyblqdCPmweeRWTxOxCogUjc8efoSgtnoHnl7j6OEwAAGAgwSuEGz4k2Jk4Ru3vp++Y6cEQ+TlY0o5Hctfu4mr43n7MjizjHKFAF6WQbqLtdVcHOElna1r4CLNgOM+wvKrQm62Zq6/q85Lx1j2+9O1PNskDC1fORF75W8RwOR5GrnAs0HwH7HjFKLUkEYiFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

Add two mthp attributes for the accounting of the number of successful
khugepaged collapse, either by hint or not by hint so that we can know
them easily from userspace. Note that these two statistics only care
about the collapse initiated by khugepaged, and they will not consider
the collapse raised by MADV_COLLAPSE.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 include/linux/huge_mm.h |  2 ++
 mm/huge_memory.c        |  4 ++++
 mm/khugepaged.c         | 18 +++++++++++++++++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index edece3e26985..9df0d7f71e95 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -147,6 +147,8 @@ enum mthp_stat_item {
 	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
 	MTHP_STAT_COLLAPSE_EXCEED_NONE,
 	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
+	MTHP_STAT_KHUGEPAGED_COLLAPSE_HINT,
+	MTHP_STAT_KHUGEPAGED_COLLAPSE_NON_HINT,
 	__MTHP_STAT_COUNT
 };
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bf9b480bb3b0..0031fb4b0b09 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -720,6 +720,8 @@ DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPP
 DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+DEFINE_MTHP_STAT_ATTR(khugepaged_collapse_hint, MTHP_STAT_KHUGEPAGED_COLLAPSE_HINT);
+DEFINE_MTHP_STAT_ATTR(khugepaged_collapse_non_hint, MTHP_STAT_KHUGEPAGED_COLLAPSE_NON_HINT);
 
 
 static struct attribute *anon_stats_attrs[] = {
@@ -775,6 +777,8 @@ static struct attribute *any_stats_attrs[] = {
 	&split_failed_attr.attr,
 	&collapse_alloc_attr.attr,
 	&collapse_alloc_failed_attr.attr,
+	&khugepaged_collapse_hint_attr.attr,
+	&khugepaged_collapse_non_hint_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3f5eb8be06d1..2f21c0b6ab46 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -147,6 +147,15 @@ struct mthp_range {
 struct collapse_control {
 	bool is_khugepaged;
 
+	/*
+	 * True while khugepaged is draining a collapse hint queued via
+	 * khugepaged_add_collapse_hint(). Used by collapse_single_pmd() to
+	 * attribute a successful collapse to MTHP_STAT_KHUGEPAGED_COLLAPSE_HINT
+	 * or MTHP_STAT_KHUGEPAGED_COLLAPSE_NON_HINT. Only meaningful when the
+	 * collapse is initiated by khugepaged (is_khugepaged == true).
+	 */
+	bool from_priority_hint;
+
 	/* Num pages scanned per node */
 	u32 node_load[MAX_NUMNODES];
 
@@ -3012,8 +3021,13 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 		mmap_read_unlock(mm);
 	}
 end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
+	if (cc->is_khugepaged && result == SCAN_SUCCEED) {
 		++khugepaged_pages_collapsed;
+		count_mthp_stat(HPAGE_PMD_ORDER,
+				cc->from_priority_hint ?
+					MTHP_STAT_KHUGEPAGED_COLLAPSE_HINT :
+					MTHP_STAT_KHUGEPAGED_COLLAPSE_NON_HINT);
+	}
 	return result;
 }
 
@@ -3227,7 +3241,9 @@ static int collapse_scan_one_priority_entry(unsigned int progress_max,
 		    addr + HPAGE_PMD_SIZE > ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE))
 			goto skip_hint;
 
+		cc->from_priority_hint = true;
 		*result = collapse_single_pmd(addr, vma, &lock_dropped, cc);
+		cc->from_priority_hint = false;
 		if (*result != SCAN_SUCCEED)
 			(*fail_count)++;
 skip_hint:

-- 
2.52.0


