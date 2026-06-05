Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15129CD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EAE26B00A2; Fri,  5 Jun 2026 14:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D916B00A4; Fri,  5 Jun 2026 14:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3606B00A2; Fri,  5 Jun 2026 14:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA506B00A2
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E65B1C1555
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:46 +0000 (UTC)
X-FDA: 84846712692.26.15E5EBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4190C40012
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BydKaYKs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPgTzFffYY8+ZzNyhPkuE1ZkvrAANKQQVvr8ndIw9wg=;
	b=P499Ydhq7jpkMxzg9aTdGpE52KaQCIfTrKK30duO/Vidkyhcth1UK4D/q4Wy5LWSLfhoQC
	Dx2JgDEuKu9dOAGfLBkhHT4pEyK5C/ULiNfZZW4McC1xZBAiJnhEIZsoq2ADz5femYh0pV
	aXsYnZgPKo72T1kah8FcUJbcOkuJRlU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BydKaYKs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684545;
	b=turTf1VAVPPKqCiyEF87luGDvltGZ7FveStJWPEpMJSN7Nhgy9QLa7yryfUxNOvQa15o2w
	1hZ3hDScl8eRJHMZPGlbXwm6gGqGH7wJdQmb9mcxy6hkak6/bj/7CxqOdXr7sWBpczoZLB
	tVMdPf7fLyE/7k+zih/0nzrIi3QITdA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AB0D42B06;
	Fri,  5 Jun 2026 18:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1941F0089B;
	Fri,  5 Jun 2026 18:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684544;
	bh=MPgTzFffYY8+ZzNyhPkuE1ZkvrAANKQQVvr8ndIw9wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BydKaYKsPPMaQYb1m+R//+fdgzANeeVCNM2zxeJ3Ypk4tYKIYwwCiv9GLWp4ulG1h
	 Hc0purKydXxPZ3b9Mx47+4HFBVaDU+3r7gQGNx/2yAa3EfqD+rQdVRvVDlrHpMsPDW
	 bW5KJdUUu3EF28QEw65ZeOfcTPHx3ZyqRN2Pl8WUd/c8pPfpC41wFOsOqYPfXs7Flb
	 vtRghhCn81f64hN8Gbj0kumucDSXUFDTX5zyeWyDBkFFc30dUcc9meDdHNPc18VGId
	 U5YcKmUUpNpAS/Tl6BvmYi4/U4k/iJw2G0iQX3Y1aSUT/0sF1Cwo+Cv0Bi7hTXg2nV
	 3wRBscIKlW1Bw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/18] kho: initialize kho_scratch pointer earlier in boot
Date: Fri,  5 Jun 2026 20:34:46 +0200
Message-ID: <20260605183501.3884950-14-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4190C40012
X-Stat-Signature: jgghh8zauufgwqtt4ix53n9ib35f4mx6
X-Rspam-User: 
X-HE-Tag: 1780684545-584472
X-HE-Meta: U2FsdGVkX1+YPXn+xi4Q0p602oYFKGwasm+JT6HEsyPRFt18SX1VdsEwG7hTleAJ00wLKE2rRKIu48VCed6iQGsQvi+WCQ4MW2G1xbj4AUh+7kjaMDj+AqhXzjxjzRRgdqZWhoYY5LGGesBvQKtqvzB5Bywgu//3nSGrIflpSGoXuIg9vtWRCDWKcmJIOiYW/93bAdI+J45yzqZfiqAsneOX3rPcHZw+wyUaRWvY0AUqQLYvBHkw6gUfQQ3tvOzCLj/9oc3L+VlvwPW8LgPSFjpPRGQibillSNncrnwc3YKMdGVLhpOGLN+DKFxi9Khr4f5c114ThfOkHoowpdxBniNy7AFk1oxBvG6xxyXmuPky5Q2zfSo/LL9xN4Yhm0wzFd505eK99SK1sAi6sxoLB7nvBQhTuDDSK+uMbZ8tCAiq+AAPbaNnA4MGHYecnA3L8YZHEi9j+hWbR4AOppo3+PRjWYPO7eCVBCc/pCyBHy37AVG0yU6dIno+REqzxXg788/n03wPY/iOIy9JgCdS+fI+2f0P6/1JYpp4QMc2EeMS6ubV05OvdabYyCb2GJBmvBQXQByqA42ZqtJBKOJ4Hgll/JsmkcZ19ADKyBeXDEPCbBrTnyvGrloM5gPazUFYgwJBnHuV1vPWDmKbNhHxZyiRia3YlnvwyLn4ht+dYyoFbwuY3BYmUS75Y4nidUhLLfUtQd+LuDQRSCuA5H+2whaVL/xTeUpGjDP+CJkRQ/m47e+w5biXQBARQuyELUVTxanYtqcR8MJK4EfUflUj8BpJ5fcGFG9BzHM7VhsNPt0XlbUz6cqq8WV4oXtaup2R9+eC5d8IZxlm9lU8JvfWh1kP36JXRPldeVVw5R/PFqCVMp8LSR4y35KDA4/EiRso1EzxVdkZ2eFlRT8TrUURF06mffGdAVX5u+fZTsfeiNVkf7/th+W/jFtXzyqgjBute1CHk2Hdut1B8+hM9cn
 hgsxYn/q
 0goDrObffrHZt+KRVN+WqqDm/hev418azXxhy5Dk0fMojqvd8vNp07kRfGyHETUDmfj4Cy7zuQE5b+59ci+d/cWVEk0rmNZp71MzHz8dUp55ClaOmLD1LgGUo+HVPFx/skg/ZJOXtqlPJut8/A8NdlJk6S1OLPbpq/61orOZHExZKiPyRUGvKTJ8EU7Xs/EOdlmslqwMpbszjNuRQRzoksPMsyGOctk6RwRNIHFTqFg0xRpG3yrGoq6IRnRJQrB/2zh1srLPsy0lB/8yR322+Ue3uZV+rNcmgOPBHMe6YfGo6gccCC8MACanyqouLEPjg50cv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

In a future patch, mm init will use kho_scratch_overlap() for deciding
the migrate type of pageblocks it initializes. The earliest user
currently is free_area_init(). kho_scratch_overlap()
relies on kho_scratch pointer being initialized. Introduce
kho_memory_init_early() to do this.

kho_populate() would normally be a good place to do this, but
unfortunately, phys_to_virt() does not work at that point on ARM64. So
we need yet another initialization function.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kexec_handover.h     |  3 +++
 kernel/liveupdate/kexec_handover.c | 12 ++++++++++--
 mm/mm_init.c                       |  1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 3740c14d970d..9e961032e06b 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -37,6 +37,7 @@ void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
 
 void kho_memory_init(void);
+void kho_memory_init_early(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
@@ -114,6 +115,8 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys,
 
 static inline void kho_memory_init(void) { }
 
+static inline void kho_memory_init_early(void) { }
+
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index a66f23a35389..af22086ca2d6 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1535,8 +1535,6 @@ static void __init kho_mem_retrieve(void)
 	const void *fdt = kho_get_fdt();
 	int err;
 
-	kho_scratch = phys_to_virt(kho_in.scratch_phys);
-
 	/*
 	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
 	 * catches that and never sets kho_in.scratch_phys, which stops memory
@@ -1757,6 +1755,16 @@ static __init int kho_init(void)
 }
 fs_initcall(kho_init);
 
+void __init kho_memory_init_early(void)
+{
+	/*
+	 * kho_scratch_overlap() needs kho_scratch to be initialized. It is used
+	 * by free_area_init() on KHO boots, so initialize it early.
+	 */
+	if (kho_in.scratch_phys)
+		kho_scratch = phys_to_virt(kho_in.scratch_phys);
+}
+
 void __init kho_memory_init(void)
 {
 	if (kho_in.scratch_phys)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index eddc0f03a779..0675837bbfc9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2688,6 +2688,7 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	kho_memory_init_early();
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
-- 
2.54.0.1032.g2f8565e1d1-goog


