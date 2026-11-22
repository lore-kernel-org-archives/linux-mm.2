Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B1B606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dnAGf9Jh
Received: by kanga.kvack.org (Postfix)
	id 21F0E6B05C1; Sun, 22 Nov 2026 13:45:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188A76B05C2; Sun, 22 Nov 2026 13:45:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049536B05C2; Sun, 22 Nov 2026 13:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D86B16B05BF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3385B4061E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:14 +0000 (UTC)
X-FDA: 85463632548.27.0D91617
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf05.hostedemail.com (Postfix) with ESMTP id 734B7100009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dnAGf9Jh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3NjgDawoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3NjgDawoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373112;
	b=UeCGZQfPpb6HxMt8ekNHsYwbEpuAfbfCdFggGSCb08WGKXZonY7yOM1CyjBJypXNDgOU/Z
	oLYHwXq7y9wNejy40LLDFzdl17kGQugboEl9I1BKyx5foRuO63wWvn6UOwhobnuBKA6FDq
	u+RNzywlC893ZFcx34sq3rcLDfXsPc0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQ0rA8yaqA1vSCBqSZZVZvjqdV+T4ndirWABYJGy5RI=;
	b=sEiJaZma4HfFrjxmLrl+nlY66HRawdTxDiXc/LUUiqE0M5t5OGKHrfHQUwIf8ASazozp6p
	rogcdMmMbb34+1unxPJUQeOPbsBPV4oR8MNAvlUPs8V5i39Yxwc+g+DintLqpCZpxeSJ9h
	DvEVmy5g8tlfWdViwa5VtTWG5IwGs94=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dnAGf9Jh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3NjgDawoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3NjgDawoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2efe8f2bdc0so20142635ad.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373111; x=1795977911; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EQ0rA8yaqA1vSCBqSZZVZvjqdV+T4ndirWABYJGy5RI=;
        b=dnAGf9JhOLy6KIQ3st/mxWZf2CGY4brkZR8WE0fvb34KEI5KKBCQ42HRq8OEWUaUEw
         HN9yng2oDMKRLypbo70+aVLJXJffttG4/4OIMa5jyrpdpF9rSf4+TuDXrhTaEOY6j3+O
         +G+/KqZ1+VWs/BPhkT43SBawRCdWfmKTxaYxAihhKDph8p/GAfEU869021ScZqvHd6Um
         guPkhV+kg2Bf+vnJkpK8VAo8A6rTmwMS9MtEA+BoLWyTYlLy0UMj51WkmVO35ppA70Oh
         m4TTd/W8l/lyGo0wwI9t85OhfQu31y08coGFAsN3tEMOwgxeqL3pHLzI4eNVKYCiivGG
         Vjqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373111; x=1795977911;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EQ0rA8yaqA1vSCBqSZZVZvjqdV+T4ndirWABYJGy5RI=;
        b=meCeRObMQ6fmfoGAYOaJdNxibedLYVznAJ9/zZoM8VvjDBLYHU/lOI0G/eR3Wsio+B
         rMJiNkT6egi+3jhK5TCy4Pu6SglB+9NwPWnwTIYFRgHZyRI8elNiIlqZYSwFtOrCzisL
         HbYxEOjBnVwnVMUgeXNRIlwJp0Qd37UtqhRz8Dqqc8ABMjxI8Z1jRgRQKAyw7qz56bWc
         7HzuIKCZevD609pO/1Tsh6iwrmoAHTQm/GwJTPZdj7qjffn5JPSppPAKeQpzPCyh2r5Z
         7SJIEjATqMIodTx8NjByQDOQ2FBQdvEEvmohgSEIgdSSVSlNiNtM4p8dcfUWvLp4h720
         FsKA==
X-Forwarded-Encrypted: i=1; AL+hErF04mDPu43mVYI86A4NYmsekFRXqiJOo2QqIrAp3ifD/jqeOPtxx3g/aOoQctwBi7xvYzknTrwi7A==@kvack.org
X-Gm-Message-State: APuU4Z+wIEZLM0gmXNFU5+ajahGKA8h7dlgdbccTLEAQG+tRxGNmg94v
	et9Bo1pOJP4FrGwO6/c8jQR5wOagcfjEq8j/Bl80Z7pw/+Ktpq23XNdQ/86Gn1z/oPzDZw5LTdm
	alkGifA7WTc6Xbsq4gxg+yw==
X-Received: from plbmq8.prod.google.com ([2002:a17:902:fd48:b0:2f0:4f32:d57d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:eccf:b0:2ef:e465:5049 with SMTP id d9443c01a7336-2f03f156193mr88468125ad.10.1795373110869;
 Sun, 22 Nov 2026 10:45:10 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:46 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-13-jthoughton@google.com>
Subject: [PATCH v3 12/19] arm64: Support hugetlb vmemmap optimization
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 734B7100009
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: kafjt8e9hox1sncowbgk8876zkut1n49
X-Rspam-User:
X-HE-Tag: 1795373112-485721
X-HE-Meta: U2FsdGVkX1+Ttu332eLxUxXFDAodcjvBJFCG/C+bqb6FFXLrZJu3qfHb7UmnNuF5720okJbTH+vE6oDr3b8zASwqN6/V+RDAK7gPSqLBC3+GoDjIPwsASYzcAbQUtR0oabMHxWiWx7tT3raJaWeD34iyAIIkdQD6UAUvp78qQ0ppAto9EkWMVovUCIyGy/Q6kfES4J8230142jYKMVG7/XMPfok2Al6rb/9HJVhuEnU2tSDu5XOzCf+DqcQPEt15ihhudp7zLQD8QUxTlXpEbDPB+vx0tbyuVXUYVNJAfYRAGNKQ42IznkTSyP5OVPRFiFUu4iYyc25Vbi/2cC5L/dDxOyanCj83X/kbH7BZ3ckEhhalfpnFN9ybxqNu3Aj/yxw+HkZ2JPQRHZnVDXtrHk5B/YICWW5+JxyYaVxH6xrmvy4mw26x8OqaMX6+uH4rxEEx6846t63Ritq0ODMgO865aWdvymi3bIm6YJD5CblMaUne6B4FZtI5ltXySrUzQnFx2aalTvQI1XzpehbA+zx3kiKTS2+9kzn5b5zpnZ1JunVkKCrduIRoXVcB3pufIPAutGpnfGyrzAzF2T9gCNv3ODCRI98Hgt6SfHS0YJjIEIYBhlIXu9jHaL+sB1i7YE1kNY+Z2LWFY8YfypEaajqmC9Ix7cf+OaLPO6kvkyu1PeoGvHd3QnNCf40sCKkJQ4f95biNwkw3ucEgCPoA7uAZ2YmaCke5Nb77zuO2ni8dVW3dRR5xsrGsUU5+kzkOED9x45knmuMq/pGV6G7t7KssWUnKKfkhp3sSDCbgU2FrPm33mOuhtWgVDRnYZO8UEj6wg44LVNJxk8s3xHTkBbvHo+7Vue3gafIqDCVm+vbDidU5JK1rIWYVd2ch1QdylYVi/SBJikxlRSu4LxQpa/Tt1QuyDI6E/Ux6ugNd9xQIIesNaDQzDyTlYL7Le+4Mln97Sq+jmpZ955WrwXo
 oEUEoLG7
 RH2AjWNGB1kN3tIp/8Y1gmUsHV7VD1NLODiudAfJN7IzUAhi974P8g7EKz/L+FaaHNfL+BhWW1XTcv2v/7/0kZVIf4JwOMAAZVaER7Eq7bbRdEe0diZ1d9WJWeHQ+nUdUmno5Ku19qDLNGJ0nSEEfisxC75WlMcMCRDw3Vic/BN18oR2z4uu/7QQhsWNqv6gDU9Rxot14ecanZIwzD93etoJsriwi+mM696suXBkbcRWPngQ4x7rabCkJYbDvBCbCg2d2rfpbgOV8HSWhB+HbyJ4mBgGYiMItP6HYCfqlhkPHH6s20+cuDyAzEhqsZhrap2z7MqN7odgRGzYIHn8r74utBrcj8qIAlyR9ILNYLRGHjXoFUxxusc3Yn/8hAdk3L4Ouh9Eq+nkRXhIBMDMjyQ0kXb19X+2gJFrGpuxgznW7jup2UH6CBVYCx9qqGj2e1GzyKfc5cq6bs7xaBnDbx/y9wHxzyytux5lAsAAH1BV5jARs0R4RXrSalIHyKpq3zu6aZP7nuYDKJCpehlwJp8yrgbgq7otF5gmhvESNrkOIQ6XnbqZXDu1xda0++rpoC4iaGxbchpHOu6Kh3ot9vCu/l3sRXfHzLgOcAdgaWcenScBmAl6Xu/rxJzswE+2zkT+4CXhKgDZljcrzcSFiosqLThJEC0J8mAZAT+RqTmQa+SHK6rF+8HLGJzOOiRujoNSJxzCziXHZlWNJEipVPwzf3T/e00Ld02BXppQQQgn3QNi+qbpkjtNf9iPz49dfdYdRCLz99UsTL9yaSGcMzApB7bHAwiBd4ccRGApxGi1v+CY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support HVO if HW AF and BBML3 are supported. These are the required
features for the vmemmap to be modified in place.

On arm64 systems that do not have the required hardware features to
support HVO, the HVO sysctl will not appear, and any attempts to enable
HVO (either via the command line or via
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=y) will have no effect.

Because HVO support is only known after the vmemmap has been populated,
disable the section-based vmemmap optimization in vmemmap_populate(), as
LoongArch and powerpc do. Boot-time HugeTLB folios are then optimized
when they are gathered.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/Kconfig               | 1 +
 arch/arm64/include/asm/pgtable.h | 6 ++++++
 arch/arm64/mm/mmu.c              | 9 +++++++++
 mm/hugetlb_vmemmap.c             | 4 ++++
 4 files changed, 20 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 4cce60c2de66..b13618f0ace5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -95,6 +95,7 @@ config ARM64
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
 	select ARCH_WANT_LD_ORPHAN_WARN
+	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_HW_AFDBM
 	select ARCH_WANTS_EXECMEM_LATE
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7421c0a048ff..5dadaac54bef 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1931,6 +1931,12 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
+#define arch_support_vmemmap_remap arch_support_vmemmap_remap
+static inline bool arch_support_vmemmap_remap(void)
+{
+	return system_supports_bbm_through_af();
+}
+
 static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
 					 const pte_t pte)
 {
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a61464cf7367..bc3eea16004c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -30,6 +30,7 @@
 #include <linux/mm_inline.h>
 #include <linux/pagewalk.h>
 #include <linux/stop_machine.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/barrier.h>
 #include <asm/cputype.h>
@@ -1843,6 +1844,14 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	/* [start, end] should be within one section */
 	WARN_ON_ONCE(end - start > PAGES_PER_SECTION * sizeof(struct page));
 
+	/*
+	 * Whether HVO is supported is only known once the system-wide CPU
+	 * features have been finalized, which is after the vmemmap has been
+	 * populated, so the section-based vmemmap optimization (pre-HVO) is
+	 * not supported. Boot-time HugeTLB folios are optimized later instead.
+	 */
+	section_vmemmap_optimization_disable(start, end);
+
 	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) ||
 	    (end - start < PAGES_PER_SECTION * sizeof(struct page)))
 		return vmemmap_populate_basepages(start, end, node, altmap);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index fb6da64bd80d..a01377c37c96 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -79,6 +79,10 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
+		/*
+		 * On arm64, this requires BBML3. Its support has already been
+		 * checked.
+		 */
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
 		/*
 		 * Modern MMUs allow overlapping TLB entries with different mapping
-- 
2.56.1.809.ga0b61035b5-goog


