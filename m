Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5233C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61DBB6B00C2; Mon, 31 Aug 2026 23:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7156B00C4; Mon, 31 Aug 2026 23:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EF56B00C5; Mon, 31 Aug 2026 23:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 177086B00C2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67FCCA3BFF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:05 +0000 (UTC)
X-FDA: 85163721930.14.C4AA88B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E3EE80003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OIKUFzoA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/uIoSPqM2R1drx5bO2xtSm3XMBl+fSHryO7BumUdVU=;
	b=RJQMFTG1A8OSG+w1jK9Vtim5lGRlp7Rkgr6IAO9LLcnv4IUyeurDW7XpgQCU6Q7FIUcMDs
	UO7gDM82/m3SJoCbqsLhzA8yePBAdk6QfzGOavG/UipIV1QrSa2RNy+zEpBUuZ7d3R5WZL
	SzbtLKbi9AD0nfk8ezHPw3LuNCYlMKg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OIKUFzoA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232383;
	b=PgSPqecmyGNlx9SeCdXiELQtz6cFIwuDn8RpUrxDRBXRZSom0xJfUtShx+aRvEKNew+E5P
	UXom7Q08EfTIYTVroC7jKn+x+4ene2VxDQEr6yA8cIlzql5qL6D6wPvYZvG9dfQzP4pRLs
	FDxjCLUvw5PDZHhArCI2RwlmI6SEuOI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3/uIoSPqM2R1drx5bO2xtSm3XMBl+fSHryO7BumUdVU=;
	b=OIKUFzoAChys2av1FldfKkxD5zDbRaRxEh8LZW3eR9Pazs69zhT8xOFXYOOtVgVB2qex4j
	qWCNGuJaz3bNOR4LY64TTbkUXJU7bFH3rKKyUSEuFGeI1EUXOM2bllr1hUJJyrj5PtN10+
	8e4jlaDFYGfeEOV6RR0APkrOZY6Gx9g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-8Qe_BjHDOQeJU0moI1Z-Vg-1; Mon,
 31 Aug 2026 23:12:57 -0400
X-MC-Unique: 8Qe_BjHDOQeJU0moI1Z-Vg-1
X-Mimecast-MFC-AGG-ID: 8Qe_BjHDOQeJU0moI1Z-Vg_1788232374
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C6EC1843AD1;
	Tue,  1 Sep 2026 03:12:53 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0738018005B7;
	Tue,  1 Sep 2026 03:12:48 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v7 03/14] mm: introduce pgtable_has_pmd_leaves()
Date: Mon, 31 Aug 2026 23:12:07 -0400
Message-ID: <57cfee4b4c203b8c5219739d5da1ba7d118d2d23.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: AwNVuVO_nIy2K7jI1_VyMQRwJs1Yt2TkDPyONT8JixQ_1788232374
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7E3EE80003
X-Stat-Signature: cx8r7na6hiirm6iqmy6ap1juwe3ux47w
X-Rspam-User: 
X-HE-Tag: 1788232383-937012
X-HE-Meta: U2FsdGVkX1/CjmlNL93ZwsDzYY7lBUO71X3xP6+WLBD0UWDopYNdwRZnOL13do+QWA6/syxfmi+HXf0z93NHAxhkm1bzleD53F+tsInNLN/HEYy47HoKLDIySqlH5w2eGQ8Yqrz2QCXktDO4f5RVhlMg+7NRv+5dHiTwK7TbzAwGbsvVl4tpnTC0HVYU+QDlAGlJmCZ+5PSGRcAJnDPtdCqViBjRA32oNANHThZ3Bk08Og2fUVulBGtw8bzqItwRGeiWz2NmoeLJpi/qe0u5hQmX7uounUEolb8YbkeBvbZJGYajEw684Z43eSqYyecgBw9K+2/PpYJsHf3UD4lJ5mcMi5g7abuO5/lwdsu2kpWXwY3JZacAmUP4mYJiPn9D0CWd1BJGxQDqfvrD5xmWe9EzKC4cjZmqyYYSRWNMTDiTJciVuwSejpHraUsQfK7XH0+vthMkAVv+tiOi2KnyniQ3cMRzSzts6FNPpK3miUcIf7nhEH5Kz4hBkc27ztp4vu34pFzBDo7SS2BPSwMQHzzOL8GcB9X3wApRCKuutoVfXad3OrpVuDKoKU59uQB3gp+pUVW23aoepIf3TwyNkfs0IFzsHYaY55Z6gR3Z869inHN3Rphq1oJP95jHXvA4awPoIc1foI1/yD+IkF214j+TQkTPr8yzVUaA+3mqyUC6utfDRcv6RZh/F/P4PaBSqNYOnDYpHKBWsZbL9mz9psp8Ag0LOChuHtOh+rTUadr5Le37lcg6Mu9hkiEG19dY9RrzNISHI5Lix8f6CqSXL0EGAqKXVn9KeeHBTGF3droiN1OjPdkS8qPyN0/XnYcRBfoP/KT1Be1YrI2e3nHBRxk6to/A4fBD4GWrRosxbsi88gRfh2JbHCWNYS7JWVtL1JBungMbjMvnTifIEO+js5VwgMER9uZGgUAB/rHM13VNyw3oKNoit+D4mDLHk7mLjsA0rT27sHiGWaPk98a
 wbNnEaZG
 ZsiVCnNePkdP0zFPwRNk8mQilH73H2WHsZwl/ZdtfFZwlb3YRAG92oLi9jQYWJeFlOWzdrfaGpk/s+7chK6oE36nntHtKURDIdSnJGfl3uwS1WYYidrENBmp3TpRxOq2jH7pk7AWsFh5AX24DHPf4h0wzfJUzJs81z5t9GY2acQ6AMC6MMHRfQ+2qmZqhP0DAGEsblm2r9nDuoL6ihv8bbNWvTSqF+ewN3SNM7Slg1l8BULd7kQ985tAbt9eZhmoeJefD9ge2rleXrjTjgXFc7ulff9OHLL1huKZCYi+Z325s0N58RvnMLDreRO4GN643rk73CoCmZZXgVsLQw2EiS1GjP8QOkBmvlgmQUHo61Vmu5eAHLxlt+rVzUbkex0RwJs5hG2vMUuz3xJT7J5EhJv5pf5CxP7fodVotvNG/RX/vaaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, we have two helpers that check for PMD-sized pages but have
different names and slightly different semantics:

- has_transparent_hugepage(): the name suggests it checks if THP is
  enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
  implements this helper, it actually checks if the CPU supports
  PMD-sized pages

- thp_disabled_by_hw(): the name suggests it checks if THP is disabled
  by the hardware, but it just returns a cached value acquired with
  has_transparent_hugepage() during boot. This helper is used in fast
  paths

A better design would be to separate CONFIG_TRANSPARENT_HUGEPAGE
checking, which can be done with the IS_ENABLED() macro, from checking
if a CPU supports PMD-sized pages.

To this end, this commit introduces a new helper called
pgtable_has_pmd_leaves() which offers the following advantages:

 1. Well defined and clear semantics: it returns true if the CPU
    supports PMD-sized pages and false otherwise
 2. It always returns a cached value, so it can be used in fast paths
 3. It's implemented with a static key: it's a no-op for archs not
    implemeting it and for archs implementing it the static key is
    changed only during boot

The new helper requires an initialization step which is performed by
pgtable_leaf_support_init(). We call pgtable_leaf_support_init() early
during boot from mm_core_init().

The next commits will convert users of both has_transparent_hugepage()
and thp_disabled_by_hw() to pgtable_has_pmd_leaves() and/or
IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE).

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/pgtable.h | 16 ++++++++++++++++
 mm/memory.c             |  9 +++++++++
 mm/mm_init.c            |  1 +
 3 files changed, 26 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..4c00cf53e183 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -14,6 +14,7 @@
 #include <linux/mm_types.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/jump_label.h>
 #include <asm-generic/pgtable_uffd.h>
 #include <linux/page_table_check.h>
 
@@ -2313,6 +2314,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+#ifdef CONFIG_MMU
+DECLARE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);
+static inline bool pgtable_has_pmd_leaves(void)
+{
+	return static_branch_likely(&__arch_has_pmd_leaves_key);
+}
+void __init pgtable_leaf_support_init(void);
+#else
+static inline bool pgtable_has_pmd_leaves(void)
+{
+	return false;
+}
+static inline void __init pgtable_leaf_support_init(void) { }
+#endif
+
 #endif /* !__ASSEMBLER__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/mm/memory.c b/mm/memory.c
index bc14cae3c49d..69ab1bb54853 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -164,6 +164,15 @@ __setup("norandmaps", disable_randmaps);
 
 unsigned long highest_memmap_pfn __read_mostly;
 
+DEFINE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);
+EXPORT_SYMBOL(__arch_has_pmd_leaves_key);
+
+void __init pgtable_leaf_support_init(void)
+{
+	if (!has_transparent_hugepage())
+		static_branch_disable(&__arch_has_pmd_leaves_key);
+}
+
 void mm_trace_rss_stat(struct mm_struct *mm, int member)
 {
 	trace_rss_stat(mm, member);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 33ff95141adb..0476d54d0b6f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2645,6 +2645,7 @@ void __init mm_core_init(void)
 {
 	arch_mm_preinit();
 	init_zero_page_pfn();
+	pgtable_leaf_support_init();
 
 	/* Initializations relying on SMP setup */
 	BUILD_BUG_ON(MAX_ZONELISTS > 2);
-- 
2.55.0


