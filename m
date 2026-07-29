Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68E6BC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C816B016E; Wed, 29 Jul 2026 10:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6976B0170; Wed, 29 Jul 2026 10:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD146B0171; Wed, 29 Jul 2026 10:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73FB16B016E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:57:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AE10406C7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:01 +0000 (UTC)
X-FDA: 85042116642.29.5767214
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68EA81C0003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRHSPdEW;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBpg99Yp1sn7eiU80nxvGo9wGcsTad4UkrJU3swiclg=;
	b=rJdhGs127jSwA+dMLTJLrX2+Bxijy22WI0F3xdXycBNcLKLHyZPv/mXn3VRo7m2/jNyPP5
	6MNoNhf6gsS9JxolCV/+e2zw+dFXsSyjJ30cr2GdMSfQUqzapLDtql3avS4KD2lr/4NXK8
	/dCCat5rvo3jtiib1lV0r67PTd3s0vU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRHSPdEW;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337019;
	b=GQ8z2Pvvs6oAEMJyXoamED8ZROaa5BsemiAF2RyGG1faC7yXDT082MINU74jacp2jRtwP6
	f1zSZp5NATjsEI8KnvauQkciIl4rXe7bSMAMO9APeodC1OTqYAzzL6Ch42oTA3JGMXns9Y
	AI4DT+utlCm2V9bU6wqR+DpW9WsoEX4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B18FD43A48;
	Wed, 29 Jul 2026 14:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4BF1F00A3D;
	Wed, 29 Jul 2026 14:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337018;
	bh=bBpg99Yp1sn7eiU80nxvGo9wGcsTad4UkrJU3swiclg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRHSPdEWnGheoGb7gFN/sfjJOwW877OwuAVMsPZl98nS29xWj+bw/LjXiuTkpTSQH
	 Ey5c1NwoDAH8/vLP04/H05PG7ktEe8GzKXPzQttyyoSBM6NB92BU630jq8RtIkcnjR
	 AqBi8XGVEi7clxNja6suADuEXc7ph8u3ofRx8a8hXc2N/A1NJzLBbcVzzuLwdUXnaw
	 i1G7VydxYiZp+eLrx1Stll0+1MfPu1oZu4YWLAgUuXGnhsEnZ6n22Q4IVvfVaJmqhE
	 UglvXDltNgoe19PZ/JaQzW0hdZn8AWWtnAjIUosrE9uTJYm425nsHlv48MMlxz7MS8
	 LrwHk7msmVRuw==
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
Subject: [PATCH v5 14/22] kho: initialize kho_scratch pointer earlier in boot
Date: Wed, 29 Jul 2026 16:55:59 +0200
Message-ID: <20260729145610.2827231-15-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 68EA81C0003
X-Rspam-User: 
X-Stat-Signature: yf8rs4jdekkenef9bybap7how1i1kf81
X-Rspamd-Server: rspam04
X-HE-Tag: 1785337019-934414
X-HE-Meta: U2FsdGVkX18QsMyi3PH4tCGcOFOXoo/10zrkFJKeNfqK5qPiSG9+/INr09xMlX+IcIrvCPM9UJ+sw8eSWXTONLEy5VD2zvVmXIGItNMBkD4/0jbF60WChAvaRnFfQQA6beSPgFfkD8Ivd31glC8f7iQrYszCq7VQU/FH0GFNSIc0ng+QIuLg3igMVbP9+UpOt+Werf1HXIUYGS7LK0vD0tg1X0t2PYv8nYlAcFJQBYAg0IaZ28obPT3iED2eQtGECmlqPK2AWIxJyZde62eho399PPS0HVhkY/ujcgeTVyJEsCbkl63ksEJy08UNg3VyEs8vYEtxxGfvWDNAqTfbvS+co6jAssXuIPgdJtbfbuBw15h08hRx5Tmrqek+NNDPn2hOtor0al/6wW0eYk1AVcF/UglSAQhnsT5uh0zYqAEsyKlSrU316TTm4eHsoBjTiXGw0yWJGcytY82VHtqQmD2NJtzpks6EMzE/C/4pq2gpRkei/DSHFwSi4IAg0JS62h96cszTRiXnZk9udAoz0K00IdWTntRqDryBJ8lfr8FXYKkOTMRnRXtwOKk06BzoNJKVsX10ef3dtKeZK1eT9bKZn4exKW86UhUn1BI80OP29/WYiGgxagNBngWg4xchcTNth9l1kMqIAM9RMHSZW2SLLMu9yAo0Zt+U5yiVrldCCoZJZwQTdyiL58KYz2Zv5fjIUCkZE9Nr0y8qAVprGF425thXfXA2uKr+xXRTu9PE6Mcb23B/+qFsOYRT+W0vMm7Sfylno2n7NdvHcHiCkx8yG1sEFVSzFdgj34mH119610YXpSY8E4DeQW8D4qALVpuM5RG1skuweB9nLOJhVQu3XWov+MgbiE0BtOn0THM4TWKt4qQDZhzpX0QdjD6eftceYSVpeMTJ0PW2zAqQZ5zxsWPXhpT8nuoEhxfRyG10C4k5Sn9L07ZnL/Q/4BEBTJ+gP3VjDVWsH9JxEGd
 UNX/ulWL
 Pi4v8y30Wymi5QlPpC64rO7xDwNAIAvoj2qWqnja5sRTTw0OY6AzXmReaDCBwltHb2GX4h48CmGIJ9//ls4sEEReBckyNs3SLbJLUdQ67d9+js9NUNaUcPUvnPpuBbDkLCWtHjjOXvjZ/uEN7jVbETAJQTFzgZPHsRRuMbpFOxrdWaGcaziQgVMr97ppfIOBRaKxSLggMclhHavu0Pg+uCyzc5vYT3hz1TuY3PNiK3xxTwkHgiywYY2DKQ3T4SVRKoY7/jvq0TyyXuvUXj0nQTj++3wuKGK6SO0nW
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
 kernel/liveupdate/kexec_handover.c | 15 +++++++++++++--
 mm/mm_init.c                       |  1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 40cb95a80981..18ba417f1ada 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -33,6 +33,7 @@ void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
 
 void kho_memory_init(void);
+void kho_memory_init_early(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
@@ -110,6 +111,8 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys,
 
 static inline void kho_memory_init(void) { }
 
+static inline void kho_memory_init_early(void) { }
+
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b3b97a6ff9c8..2ddfc804cdf7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1534,8 +1534,6 @@ static void __init kho_mem_retrieve(void)
 	const void *fdt = kho_get_fdt();
 	int err;
 
-	kho_scratch = phys_to_virt(kho_in.scratch_phys);
-
 	/*
 	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
 	 * catches that and never sets kho_in.scratch_phys, which stops memory
@@ -1756,6 +1754,19 @@ static __init int kho_init(void)
 }
 fs_initcall(kho_init);
 
+void __init kho_memory_init_early(void)
+{
+	if (!is_kho_boot())
+		return;
+
+	/*
+	 * kho_scratch_overlap() needs kho_scratch to be initialized. It
+	 * is used by free_area_init() on KHO boots, so initialize it
+	 * early.
+	 */
+	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+}
+
 void __init kho_memory_init(void)
 {
 	if (kho_in.scratch_phys)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..84d4b1c997bc 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2687,6 +2687,7 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	kho_memory_init_early();
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
-- 
2.55.0.508.g3f0d502094-goog


