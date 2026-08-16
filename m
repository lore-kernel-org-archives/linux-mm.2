Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D575C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA156B0898; Sun, 16 Aug 2026 18:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEA66B0899; Sun, 16 Aug 2026 18:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A066B089A; Sun, 16 Aug 2026 18:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0797D6B0898
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 716281605E5
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:31 +0000 (UTC)
X-FDA: 85108620702.08.3D26776
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf01.hostedemail.com (Postfix) with ESMTP id 858E940006
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="B hepOWU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="k/h55XPP";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aj0XhmlZKMkc4zRSewDPCH6H4jDvf0UGdOKiLur85eQ=;
	b=5oE9rDcQaFLuCouXGf2+aRJWUuon7/lKCLDUv9QVIaO5pMnetgECA6XJgZXSEuOvwtaJm+
	UWHjkV6VirJ6ykNsXgoQWSfS7xTRCKb0R8nLTUiRHIReE933/UdKV7vJGyTNcAIw9FpdGu
	WpVjYOZ5qgt3+XQgAitpy4qtKpzRILg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="B hepOWU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="k/h55XPP";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920449;
	b=5q21w5xsXujLTNRoeEoPr9DcEPp80GWJPB9q7kafu8CzOL0Z4ggvkkNqz/VbC8EmjYAN6a
	nXN0zohztGrNhALx6yFXa3TVycs+r1oGABFraduR7w4XyVWmvSuEwMCEbTY8y1xuzNK9OD
	iu0vUdQPiuZ8ZxXcLXm/ZmJlIMzww/4=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1C5C514000FD;
	Sun, 16 Aug 2026 18:47:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920449; x=
	1787006849; bh=aj0XhmlZKMkc4zRSewDPCH6H4jDvf0UGdOKiLur85eQ=; b=B
	hepOWU2udgD96fUUwtE9ixv2rB8W/u51vG0/xWbPODW9XQc8uFxwwY7kIN25f5tJ
	RL/ZuQec3DaHCu1usTRQlGM0w7Ub2FJEyf4XCdczxJDeHGJla6Rds+sl25tkSeSy
	ZZI8wiHH4PMgE60hcAhyY0nLoyUVV/DnA8gYgzm5O4lkUIRpEofVx0fIRrr0bN/1
	77WnGWzwEALGiu7r3MQCZlwksyfOB+JFNi71Bv9I07HQPHOc5M+NgIKpxIIu+zxA
	e+qGCM3DGZ14EcTK3FWOpD8uZO3w0vQOphqYeIJooyT5w9P3DxtLltVC4rQajxCn
	sfo4e+qWwmTBVxVpOOHOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920449; x=1787006849; bh=a
	j0XhmlZKMkc4zRSewDPCH6H4jDvf0UGdOKiLur85eQ=; b=k/h55XPP92QK72IdP
	n+QMfUYKLUCJQTPtmap+pScLQ+Yp2ae8jj00qGBBg9ob4Hhy3m9T/wMxyXxEdXMr
	hadvv/jmjBS5vM/lxpv2OmfmUpmllRz237gk/pTbswnncVe4D0V4cm+GA/HACKBG
	F7XIPXb7Cd0pI1u1TDQ1+60zLMKRvtW/ZzE+Ckozhyovat2U2Patacuew6HTgcQh
	ch3v4fUul8wDcNmzzL2uRDkRiciRCIM2rip1km2yZIvqiFX6Wf7kmtd5KDA3/2DZ
	86/UBUszSBfVSKHnwyps5X0bRgTXKfvaw29WUO27o2CiNV258MIdajXNxy5xKDhN
	PsgEQ==
X-ME-Sender: <xms:AT6CavuDFeb1gIpHC3OIF_tenQM0F9ow5yAms306M9gdVHdKty42dA>
    <xme:AT6Calzpk2vJRsNDkI4pCa0fr4dorjBjzhfRazfDiXBlp2QLQK9CtMLZnvu2htJ0H
    0hbjQr24HjbMoly5kg1MkMPF-ynJ4f72noOnRcg189X9lheJo-3U0c>
X-ME-Received: <xmr:AT6Cau37QPcCfj8URZwoi9NC-tKE5cUwLsRpkKqtuQh1xZggj7GxCpd-TT8>
X-ME-Proxy-Cause: dmFkZTFe0TBuCSyWNWlaTWnsnH38dlt47jt5E6w/XYzg/0RtV5IwtbmYp4d/5OEsZ8sA5Z
    UrBtcKKYpJCYixx+ecrdsB329OhriQaNA5EMshLJupqSJKXKDlX4l+JTcK5if7dIpIi6UB
    +BFP7gkTqf7K8f8t8WCOU395N0ODAlGoFtgYkIRXoqS0rIU4lzr7JCi9Af7Sg5tkZu5jni
    VRAtq63fYeOiOdPNGAwbZJmoZoc8niBcpDBe0ZRzWrmdU+90wGMFCi1p+kJaaIoKSIjuYL
    B17M0nHwdihDuvGDXIV2beIJ54RuD10DDB0gu/vUckC8ggwfo/FmZIKnlAb1GvBKZWmqU2
    UfCGDF4pDeDY2wtd30oVyTlAsy4TVuXAOh0zLmHFyWKfHtL9tC6Bk6daO343oI5hPRxCYt
    AvxBtZGfE/TipDf//xzVRUb31ZRkOT536+bpGgVZ8Kxgfgtcru0nhyvvmxR1jbSANi4/5p
    2evqh5MIBhwBqfmKO5qfjsxs94IIT5rta9PZ+T51i0Pj91x8kBIn94YXuBy1+L0KxPoWkV
    3zowkEzOOMvATrbD07q7UbCI9+OSWbkjcmlQGuCGoYv44HFiNF4xr1KtN/wJWrlEAKKVor
    HMGWpvWt8PaF9v6Rr/7Ww1RdG1DWJQmJnBSNOEqc6Wj+6LY5L57na4cUDNcg
X-ME-Proxy: <xmx:AT6CaqwUC0sVQ8wqEJ7xmcmSI0Biuiy-dknpE5_XvypV5NTaR1Ruzg>
    <xmx:AT6CamOWOx5IFycY-VJi_1JyBUFMPNXHAUzmcz7MuZAv9nUWtGNYMQ>
    <xmx:AT6Can4YwfUSGLCDlh10RM_hiCtzqRG5aYAq6YKzkosp7rpbAc0r_Q>
    <xmx:AT6Calf2KFRpA3NKsk6OqpzUY-9ZkDEtd3Hse9yzE7juyZjOUBfkqQ>
    <xmx:AT6CaiuTvhczamiktPQDFuLJGb4bROpEB-Bq6iEzgAIzYbJR9e2EmUxb>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:28 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 38/57] mm/collapse: report the round, and what it made faulters wait
Date: Sun, 16 Aug 2026 23:45:50 +0100
Message-ID: <20260816224609.308019-39-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 858E940006
X-Stat-Signature: rjcyeq8xao6ecsghpgscsq8pic5a917k
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786920449-164428
X-HE-Meta: U2FsdGVkX19JOC0merGV+AQRi4eYCsTWkvMD5jGEXkIts1XvnPA+fjsSLabgAXgk+LlSVTF8jHxctHSzDAt6Fg3BlS/9GvKahT+HGXT0IHSATjAMEF9Zw75ejBvjmn4n67ZggOUh6kGP8gyWv2HZIUv/dW5htmpIvcCDJTCfYDFTJQQ23m0PJhKjQf4eZgcBaY5QzJMhsQwU3fEhEQ7iPR2MDtInAqgZmKqtZ7q8g4JtGzuWM8FnWEKdSwf+BKjZ6j6Oev9syR1c2q1Vn0J3cgTcYv4SYDEeopz61m2MjPIU7pxS6lkCI4lWT8a5qb/gupNlA96E5YG96n1ZOPEgclarG9BxTIaMaPpMlews6uoNBIY3ufUHAYVbew8ZFmlkQh6S4UD7oifBAaErJFzUZQiFv6YVLLuJikzbKkwDE85LozaR/GGyeZ7iJ7V2ysLloqGbuCGNcBT3b6H4nBlpIh0QVBhabkjmWqLSWpiObk//wITFKBhJtbUQjwY9RLYu+DTgZRp8vpOzSEVSI/tSvHxRs6nWGUuqvtv75xH9uklol4h1CtXFCJcf7zKDa6MiqGq7heocI3qZWSSPow729g1M+l4R1HS3iAj0zWgqLtZct6saTmwvCcKgWXa4B1/iJvfy8ggu0kUu5Fc7nHEobGhkj4IYN2h34E0KokF5IshX4/jIt9ed95G71WCALZWge6kHZKI0imF9egfvtG870YWU8qV9frZw3l8lQvEHMobjgNThuOnqcixOivX/gbochjZS+NsX2MivFmaR2qmcubgUYn+GsyLWuOQh2mgGZAt4VcYgxKhWgQJhnOAjAseqSyrzl3ODwWNnlymi+CoJ4eVw+UWziFiFHrRcSBQmmNFsDuvTx3LiTfdpBYBj0m8dqvzCuT482H//tdQMz3/uHkZzCtsiYlZZTiQu90ZC3+p5vQKU5wQQuGJczGFGN+6kbkfJfRNq5WoEpQ9Wq8K
 LzC3qL84
 ajbWzR3wTgvRrKi3pjIM2Smp+wSI4tfPxbBIX5PZaIHCj7QNzEk/JEZXvKGloX4sgrfGUSCeTnPOspvqa8haDlqL44ednvgTRY2kpzOJoG8oxkGVpwdGZc44K5T2HARq1Pa3aDpK1aCBlOyeAGzSMWYtrlaFIlTqyScig/PPK9sYJTGam//e7aOohcQvliXLmqASFCjf2+du/1foyvm2mXavXg7CFHf8PXLViby25zAGJcp0U9H/AxkEt10o95QCW8cEJ8YSXL293CGsseQ7iEw8HYbjJqiuUqE2YkzLIzXbXLT9aRgea9GeaiwWNHtitSaN7aVCQeyW6lpCBAFThYwZmdHaYlD4WUuSV+zNU5+uLOYCBxhKGz5atuEZ4eWInQ+R9oEPIdBs+WjP1bPbbJu1pqBqo5molP3y91CWz1SRtbWysivjt7BSz5k7Dpk9jNTe5RF0WssCN+7Bo9qe0cARYlimyFGPW6Pdv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A round is the unit the engine actually works in, and nothing reports one.
The per-candidate events say which windows were taken and which were
refused.  They do not say how large the batch was, how much of it landed,
or the number that matters most for whether batching was the right idea:
how long a faulter on a source is held up.

That wait has a definite span.  A thread touching a source sleeps on the
folio lock the freeze took, and wakes when the putback drops it.  So the
interval from the first freeze to the last putback is what the round costs
anyone unlucky enough to touch it.

Add mm_collapse_round: that interval in microseconds, with the candidates
collected, the ones installed, and the outcome.  It is the thing to watch
if a larger batch is ever proposed.

collapse_finish() returns the number of candidates installed, and this is
its first consumer.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/trace/events/huge_memory.h | 31 ++++++++++++++++++++++++++++++
 mm/collapse.c                      | 17 +++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index c2314e26111c..d7c0195ace92 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -160,6 +160,37 @@ TRACE_EVENT(mm_collapse_scan,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_collapse_round,
+
+	TP_PROTO(struct mm_struct *mm, unsigned int nr_candidates,
+		 unsigned int nr_installed, int result, u64 freeze_to_wake_us),
+
+	TP_ARGS(mm, nr_candidates, nr_installed, result, freeze_to_wake_us),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned int, nr_candidates)
+		__field(unsigned int, nr_installed)
+		__field(int, result)
+		__field(u64, freeze_to_wake_us)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->nr_candidates = nr_candidates;
+		__entry->nr_installed = nr_installed;
+		__entry->result = result;
+		__entry->freeze_to_wake_us = freeze_to_wake_us;
+	),
+
+	TP_printk("mm=%p, nr_candidates=%u, nr_installed=%u, result=%s, freeze_to_wake_us=%llu",
+		__entry->mm,
+		__entry->nr_candidates,
+		__entry->nr_installed,
+		__print_symbolic(__entry->result, SCAN_STATUS),
+		__entry->freeze_to_wake_us)
+);
+
 TRACE_EVENT(mm_collapse_faultin,
 
 	TP_PROTO(struct mm_struct *mm, unsigned int nr_faults, int result),
diff --git a/mm/collapse.c b/mm/collapse.c
index 1b5db42b6991..d0d28e8dfcea 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -8,6 +8,7 @@
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>	/* x86 flush_tlb_range() uses hstate_vma() */
 #include <linux/leafops.h>
+#include <linux/math64.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
@@ -20,6 +21,7 @@
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
+#include <linux/timekeeping.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/vmstat.h>
 
@@ -1803,6 +1805,8 @@ static void collapse_round(struct mm_struct *mm, unsigned long pmd_addr,
 	struct mmu_notifier_range range;
 	struct vm_area_struct *vma;
 	enum scan_result result;
+	unsigned int nr_installed;
+	u64 latency = 0;
 	pmd_t *pmd;
 
 	collapse_reserve(mm, cc);
@@ -1838,6 +1842,13 @@ static void collapse_round(struct mm_struct *mm, unsigned long pmd_addr,
 				cc->batch_start, cc->batch_end);
 	mmu_notifier_invalidate_range_start(&range);
 
+	/*
+	 * What the faulters on this batch's sources are made to wait: they sleep
+	 * from the freeze that took their folio's lock to the putback that drops
+	 * it.  Measured per round rather than argued about.
+	 */
+	latency = ktime_get_ns();
+
 	/*
 	 * None of these can fail as a whole: the freeze takes the sources it
 	 * can and drops the candidates it cannot, and each pass after it works
@@ -1849,12 +1860,16 @@ static void collapse_round(struct mm_struct *mm, unsigned long pmd_addr,
 	collapse_install(vma, cc, pmd);
 	collapse_putback(vma, cc);
 
+	latency = ktime_get_ns() - latency;
+
 	mmu_notifier_invalidate_range_end(&range);
 
 out_unlock:
 	mmap_read_unlock(mm);
 out:
-	collapse_finish(mm, cc, result);
+	nr_installed = collapse_finish(mm, cc, result);
+	trace_mm_collapse_round(mm, cc->nr_candidates, nr_installed, result,
+				div_u64(latency, NSEC_PER_USEC));
 }
 
 /*
-- 
2.54.0


