Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4A1C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F526B00B0; Sat, 25 Jul 2026 13:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D86C6B00B1; Sat, 25 Jul 2026 13:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FDC6B00B2; Sat, 25 Jul 2026 13:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60A276B00B0
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:22:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9033402E2
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:22:23 +0000 (UTC)
X-FDA: 85027967766.10.EB9D68E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 44107160003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:22:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9fIEhVy;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785000142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxTUe+ZTLtTyF8qsexavFqzxBST5EZcJ5kz9myxc9Sw=;
	b=tvF8sE1FqbuAneezJ7KA6HDvUp+JXwPHNtwY3p8nf4EnVsQvVFPj3DTQx/XF9RO1mrmd6b
	2VqvxG/0bGyGidXnEGmRndB+DYT7pcteB0PczfaoBTkkh8qkAFh+z2LF8i54sIW9M1x1Fz
	I69Q+48jbfuATmwuD9MM038EAI7CwxQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785000142;
	b=XhwMQts5rpJmnTFMXCPfZYZWw81ufS1QpNTa4eLoBjy79r1wvlERyg25C5GffXUZmLQkRM
	06jsYyTGJ6ep+FIEqJSMbwyU21E+V0ZhN5JP2sN7g8K01cP+xIakVmdDR/DliNIpiZICeo
	DULCF5HWRE3yEJLpOw0AFjEnsFTvEGs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9fIEhVy;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D48DA60A9C;
	Sat, 25 Jul 2026 17:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6279A1F00A3A;
	Sat, 25 Jul 2026 17:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785000141;
	bh=fxTUe+ZTLtTyF8qsexavFqzxBST5EZcJ5kz9myxc9Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9fIEhVydg6PY66G5SZ0FhttHr1YhtNNHJKxH0h2mFtMAbyKlqkL5PW7eOEv2rKjv
	 dZkcGLvn6Rl1hAKsQUUzhpAKChMNb69cWHFmFNYNtORBvx6Ow0Io9GUzdq5/xaRRp9
	 F+WHVGUX+GVyUzqhXFto80lD6y7pA+NwXBZU2gd+uk3Hj136r/ubZcBwdPYQKGRH1W
	 LPzqmPKOFiR1VWBf4VGfS2x73W9MSc+y2nqVELe8GCDECi1qy6xq13UdCZ9VnsT266
	 l0K50AHf/o2BjXR22Maf4aTMKh+3xULWlXzJNWBv5kaVfzuXWUwWQN+79L6k0xXEaX
	 2bgAxSu70qccA==
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
Subject: [PATCH v4 14/21] kho: initialize kho_scratch pointer earlier in boot
Date: Sat, 25 Jul 2026 19:21:14 +0200
Message-ID: <20260725172133.4018491-15-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
In-Reply-To: <20260725172133.4018491-1-pratyush@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 44107160003
X-Stat-Signature: h4zyicp873x7j3d79iup5dn3g6iszmes
X-HE-Tag: 1785000142-570414
X-HE-Meta: U2FsdGVkX18DfAvudBkxZrSzJoIkI3eJ8myWEQjwcxHlBgmunLb//WMC9UQLF/4OleO4f+GRenMVUV212U6F5q5Mgga3uRmOJtHUu7wiqivaizZ/T7FwOkHMReZashcIeMZyjULQzc2z084CCvKOn0txKqcXO9iwPmwQ1KBbaEJlIoW3zZ+gaAEOulgo4NZPEc7wgpg6vbjW21UJRiQTKKBwvcnXG6rpNngcMzUSNpeA8MXZRocADOBHpwrwxvlZvbh03g5xdzpsB91VFasB2XCnACUc5ewD4Lg0KFvMSpt9E5EaCp2W2opvHVZrms50/b6hEcD/lssLoaXob4BSyDMJtbeMwpRo568SNQ6p1VCXxrZ1b/cid6+71qAjnRWSilcNBbWD1azNolO2/RBc9RbM2Pz1SoFy2kXXcCcFHt+9+sTTGqURgoEvGbC6bhb3aJAkwJ5a2Z5JParvYFg7C0o+ERlOVTNOW7A6ziooo7D0d5LjBKF2nXI7uKnpi0alJUZeIkkBuzAKSSoeQDJU9jhddDXi8r74Sa9lKMVfZ6tVmPKhx+FA9t7tjL2rlzhPxtftQ5gZHmdo5wBIg4y58oB3f2M/dH7ridRtwakxlr825g08IjzB51yo+C3hr8u5XCNxbwkTOZ3gzBVhMWW2JjVSjM5UJYbQDRT2fGais196W8+QKw32iBVCDAVcRq+1v0yOS6Jmzspq4/gjfs88oo/b8Avpp4+fr5MXn1NI9qj0pkSmfvhPpNLqT8/5N8OBqfsEkyQiSVDa9sTBdGvQal0mwiwiCm94ApiuNPVhJqEypBZFwlnP3TSY4nf6LW4Oqhhk62iWsdv/gG505i1amqPOv1oXfJ4rQcrDlMomLJVcRKaoJemQd9fhg8x2IftPS/XKFumXsk2Y5+Qw/ANGnnrUw54GGuqdfYns7IRdzIOU1Omw33aKFrm84gNcdyh7hBEmP420kEnU1+d0rpL
 /t+LKebB
 cRWkb2qLQDhPXOutxNjPv/X2RX/5JYo1My/NaAQCM4mIAn439qeqhAx45qT/2hqv7mkB/ErP9uG7UISjC18X6hXHbT2Aiox08ic7vSXYPDSRFOxZ/ZWYkgIaNYkD9ToZzee6wqGvhP2LGHKAZc8FDl7lOrTZHPWBrUODhos4ndWc8ra0ulxXkWyawIrkeaP3lhiDkbq9CpnShZ/6sPckfwdquI7b/ESoo3eZwMqnXSWwz8Lv9OjfV0/VZQCPvceyjVHIItGC6A0nTLEZM6kPnKFq9Cg==
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
2.55.0.229.g6434b31f56-goog


