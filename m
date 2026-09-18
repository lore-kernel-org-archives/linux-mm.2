Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6517DC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4213A6B009B; Thu, 17 Sep 2026 21:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1696B009D; Thu, 17 Sep 2026 21:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B6A6B009E; Thu, 17 Sep 2026 21:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C82926B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27CE71A0531
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:27 +0000 (UTC)
X-FDA: 85225193214.25.356B0EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2ECF814000F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F1uUWPQm;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789695985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fp/JTknm2HmMVKkPZDQSkPjhzxNQSd/nlZgjgxUnixc=;
	b=dYebZNzPxrJNNRyeS5ODVqwE4LSO6Va9DlLovegm44TXKf0IokuF0TKcjoxaDIpTapkszC
	NZAtyd7UN2KTjxHA1tA9ISpGtHhPaEBdCSo6qmyXJHLfyV8FK0PI6EQXz0/bdVq6Ii2dn7
	yG4/nQkZjLNxxt8N0sNJxyMtKJ+6wi0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F1uUWPQm;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789695985;
	b=a1WVm+3tBzUJ9BSdW7iB331zDr1Jtci/vGxcdNomalMZWMONX2gnue48XYPpU00wd24hh1
	TrlldVI6iaVl68LFdEyjugn+RJFrEoA+tD7CZgfRRRALrq0DDn+CiNkdDZuPMP9k5ZHuIZ
	vj3zkk5gbNBSM/EL9tB3D+JLED0vvFE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789695984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fp/JTknm2HmMVKkPZDQSkPjhzxNQSd/nlZgjgxUnixc=;
	b=F1uUWPQmCWDV9NROg8iFIsxlj1RgHaQXk0MGleySPxQIQRfmUL5SRECVjEj4UDdhE0KYZ2
	wH45KWGdBFk1Rz3Zn/JgnYbmWDUElr45JsmcpQj+vt0rNqxyPHSuwlSFxqkUBwFX0ttS8x
	Sd72Dps/WpOlhhnOW9n+TzcFPhTSvys=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-2mtBXmLqMh6KR07oldneiw-1; Thu,
 17 Sep 2026 21:46:21 -0400
X-MC-Unique: 2mtBXmLqMh6KR07oldneiw-1
X-Mimecast-MFC-AGG-ID: 2mtBXmLqMh6KR07oldneiw_1789695978
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1126195DE67;
	Fri, 18 Sep 2026 01:46:17 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C8FBB18002B1;
	Fri, 18 Sep 2026 01:46:12 +0000 (UTC)
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
Subject: [PATCH v8 03/14] mm: introduce pgtable_has_pmd_leaves()
Date: Thu, 17 Sep 2026 21:45:24 -0400
Message-ID: <f0b6d8a8036ee6c2aef2a63e9a03d94292a2c599.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: wKrYyKYtb_NVcfRcOqvd3-fQ1pILiFPbbo5jx_Kc8ac_1789695978
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2ECF814000F
X-Stat-Signature: 7b5jj18rcf3wtyh4h77in7uhfyknxqu4
X-Rspam-User: 
X-HE-Tag: 1789695985-745462
X-HE-Meta: U2FsdGVkX19TKfisbscVQuKIrbkMPdOAuY/F3lo4NkDrA3xeRck2ehDa2Oa7pACT9IAupO6UWGReme2orVOZaSj6jtXIkD0XWDmZ8dvAEspFk5tNSMzYzjNq05Lm8ZSOIgu403GM0I7V9aRb8zjHRzZNLJRw3ud/EAgmBOU2Ii95HzLhSxIZe+29n9FBX0lfl40pIFtWbefObIjTpRaPJzV6DC0aG2CRkGq+Dsy6Oe/BFYBZrgcy5XV2lQzg2LChtg6gHl2W6Ze0UE/h1jXKYwObH5a6SKengDnjdl5k9lIODKh4WwLulT8s8x59m5ko5eBRaEF0AC+WJi0Ypbxlln1WJwACLphP6gsS+TINGBiUyQ7JUMmTzfvwW4eHtS6pEl/VQ2wYuKY/GDeOjxnYtGWYW5uA8c+xUEY860MxmmH4JIs85Pw+D0Upzrj8TjPxCE45silbjTnsO5+Q5lCyH/MyOCC4j58NKJUDbuqoyIMGzwVZcD/LNkQqqcdmn1fadMRV7HkElK6YfOPTN+a4X1EwZCsx2+HplML0f5U2TE6iMz0MRlUKEGwihmwOpUwR+EHmVRyNIdJfEzbZ5TJMs6YMjEEOj4SQwwrXk81XrlQ1NtuZfKwvXnNREBJPMmZhoK9t1C1fENF/AZMkqLfRXsfhfzn5YmEg+pfHhJWsDK+JZWOPWEZ0WUa8gcr5IwX3ldzyGyYleOnEFCOM4Ueh3vfcpORWSXLHgVGtUQN3edl3Ol9VV+m11c8oAfU+V4NXAbZSGKxJB4xNlkFUy4nTVU5hD58r1mcAFPCfmNMdk856sy73Wsn8qBDgx5cFE/WPJ5/ZtDTat1nYhPmpvJKOU0EjjGer8DeAViCuXlp6DxtIpBHMBr27L6iyPYe1lQ0Bj6culFqYshZTUcMwKvwTk0Rx2vUtrspQyLNlhB5CUjUp5edJy34g+D+J7Hj8toDL8ZR5wWEcE254VP1L835
 vRXxUKfd
 UnPsT9CLe7Ovgac/3RUGwJXToOJ3YbllwG0VHLKRb+CUWhri+3LOd1smlvDRLL1x9USmMJ4YdkAM+gY62sabQkysSnjpknPoZKRae7t2SsPSgT2wf0ajdKJRjpgDMbsn6FwfzU1DZRkT0/3F3feSR/8HWTVARKav26NfYY/bihV6WNg8CXJwJBhiwUe22OYze1rpRLSrdDBtQKqTvP6TIo4ItNqtOGVq7qofARwp+EMwjjEL04bF/svKzMcXL4P6cOhJxUQS4FftVzJUEToQFd+TyTqjjrWZ8czpn92ydGUgi0xCvrJ1xNsJWDe9Yl+2+MpYegjSWxf3GCzinIPsHxXsgS9mMVlilF6GONT6d8bUS2ujt9JVS7Ti/IS+1+4HZ0YZRAgdtfTg0o5s1lyG28SKP4kUvU2WQPCTLIc/PhZREO98=
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
 include/linux/pgtable.h | 17 +++++++++++++++++
 mm/memory.c             |  9 +++++++++
 mm/mm_init.c            |  1 +
 3 files changed, 27 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3c8ab96941c..ad852a415114 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -14,6 +14,7 @@
 #include <linux/mm_types.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/jump_label.h>
 #include <asm-generic/pgtable_uffd.h>
 #include <linux/page_table_check.h>
 
@@ -2327,6 +2328,22 @@ void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_
 #else
 #define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
 #endif
+
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
index 9e4a70421a6b..900539acb7d9 100644
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
index 56bb4567a494..28685f766234 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2693,6 +2693,7 @@ void __init mm_core_init(void)
 {
 	arch_mm_preinit();
 	init_zero_page_pfn();
+	pgtable_leaf_support_init();
 
 	/* Initializations relying on SMP setup */
 	BUILD_BUG_ON(MAX_ZONELISTS > 2);
-- 
2.55.0


