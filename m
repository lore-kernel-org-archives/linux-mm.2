Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67058C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61C6B6B00A4; Thu,  9 Jul 2026 13:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4086B00A5; Thu,  9 Jul 2026 13:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530DB6B00A6; Thu,  9 Jul 2026 13:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 219726B00A4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 534FE1C8238
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:10 +0000 (UTC)
X-FDA: 84969949260.02.E54149E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B465F4000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NP7n7JZ9;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618748;
	b=VjZ3ZOQEc1OxbD+p7UDgMS3STSzOa13Bf5qLkZcU1FkeYKe2ttdvOR8Fg1S02wVxF2IUqn
	BGRgdgNSpu2MhrMmclpn2TxtSGOOaFXB+g6il7IWhEnfjKQY7QWJJuZL9eRlysAus1qMDA
	k3+gLO2J/rlC51VZAODwiK61aU1lybY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NP7n7JZ9;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRWHX7zMVtBNXHZRqDliEz73l607WKYgb2CCZt52nTM=;
	b=7epxCd2FOulMa2R65jn7MqgjBVVroBSKtKt/ky1GolK/qVcx4WKJUlQIfWYLf4virKEqyB
	LGfuZQ/ccwSwX4KPvsbfO4fbDR6pZzicD18SdheJhihkFuDVLkdXk7bKu6L66y94xUYL+r
	/HLhSCXtqxjdX7jBFBDfa6NUUhTR0Lk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5272361836;
	Thu,  9 Jul 2026 17:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E181F00A3A;
	Thu,  9 Jul 2026 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618748;
	bh=XRWHX7zMVtBNXHZRqDliEz73l607WKYgb2CCZt52nTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NP7n7JZ9Rsq1UO8wAMpyzD3u7hK4XgRdKJqYMf3NGmnjFDasuqjeoZBnMCWUoF6GB
	 f1ci5JPw4rwRrGPTvwjC/dTnPw1s4Mh6ye2rrl9Y6YuMjGIL7NQGIQvtrkrEKz8gtK
	 EK8kmQgMLm6sgLnfpRjJ5bME6hQrtCrg6ZCYyXX/l0T8PStyNZ9/w+FstjBK+NxU/W
	 RuBck4m0VsEySc92EWwrojZeHbI+WgQGyRsbY5RGT66kNe4377F/QDerVTGDHXtDHb
	 n1s1omuYv14J7fgIi4wf4bCdSiICgQEKHmpBB1xOIukRhMjCt4MzgFDKwM5UtpgfhO
	 aqnx/ryim+bTg==
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
Subject: [PATCH v3 14/21] kho: initialize kho_scratch pointer earlier in boot
Date: Thu,  9 Jul 2026 19:38:03 +0200
Message-ID: <20260709173821.429921-15-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B465F4000D
X-Stat-Signature: csgsfrjj64ox7wse4p33t5oqhjt8yx5t
X-HE-Tag: 1783618748-435
X-HE-Meta: U2FsdGVkX19y6mUhjY+c2mpX1ljk4siMZ+Jk+9DFfkv+iNDcsV86y2P9DN2aK2KPLrvx/4bdZnJEMyMCgb+StJg2/sqpoWIxXlIs3L46MhQx3bFAu/bFJLJ1z3wNTuNTaVhuyDiTDPm2isoOFNbfiHg+NyDHx/Y6jiu7hKEpjLltiRytXeRDSmGKIo9agpEAFiFIgQiMfdCXND1NGEjKYzdfk5KXtk/LH3bJ3dALapKkj81ldHoQY+s4Zd9lOvPo2ZlQYnrCA5mwHzOKuf8+9bo3hCTSW966Iwd6FE1rIfA9jmRNTglndKiAX9NYuca1asfJjCISfYL/aV+6DP/UtKa2cdEM12duKgswKLoTWlj9MIAqpUCH5YRTxp4LNsfCL48Jsb7Q1hEyf2xuRkAFqut6X6RB6BE6GDaJSol4CsxFFC4V2YiZgiKUMHS6Blzyj4JKRiPo3s77nYqLRBIUOgtBaKJXUw66Z18acyQtQ1QWzRwNf9dEHQpWyZq27o2axSrsZkgq4vzh8jb7ogMq3qaJ3+fMeNe4kTZne/kXdvslCgcoGCH/vnac9g7Ec8PBxIyoIfAugGHjRADEI/DuslZDJykQ1NoNwud/4ZXbX/l3b5/NO2wW+m7hGzDEMOCtfOTJO023MzE7ZDvsPJNxnqrL20wNzEIQcppFsAAOFywxECwl7/M4mk8Qk2CEqIM9dezR1zQZtrb+O7pjxUtNvc3z+BLlFfW9ywGxRnP15O5arT4L9j1qO32TsssGqrrTspQ2cOVUrW3wogShj7/GiLk5AjLXQks3xd5doU9Pd66Bgs13hYox9iFGLvkh676+9uNeMwtJWRClNkbHT0jXozfiwynE24fJLjcvhR9kVkGuhOoep9uJ1sSmCv+kKOWgPpJp6oQSIXZSLEhHuDvWWkaPhsAtQ84XPGUcTJaHyc3BNHan7Ci4MsmII0jKxN97fK2bKm0USk6QhBC54bL
 nt0RUVpa
 YXQLja8qE6DcJPrnJsVUB0F2Ff91KyJxoeM53EZ33Ql9Ej6vacYwdJlGCSiW0iNYpy/8WZ9CsC0CzCd/I4LV/bHzsd5BaPn0YaNZXQkaKZBRZS7gnQROs3C6x7UH1QXTc+ZPXT1TMebIurNKHcgAoQNJrpNbO/C18X6/J/BKBe5wMquThXYD0tfs77WXIRQnw1LXLeYwBu0wOxV4DXnbCoLWn6Ku507G3fGs9KJLU0N/qMjqHEA+zDuTuIy9AZswYVbwpYU2vJsY26X8NuN1oSi605I3pEZoOIbLT
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
2.55.0.141.g00534a21ce-goog


