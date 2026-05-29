Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8522ECD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B0E6B009E; Fri, 29 May 2026 10:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902556B009F; Fri, 29 May 2026 10:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F6D6B00A0; Fri, 29 May 2026 10:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77A846B009E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 360F014011F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:26 +0000 (UTC)
X-FDA: 84820758372.11.F4F3DE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3C0E320010
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YMSxq6CV;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srMnuqfW7MrAn0vD4FS9vCIY63pbslXsQEhsyeCn9fI=;
	b=Rv3wMKXeSfYEcYNJvYEYekLLpV3PScVl3xjw0ai/2n7VSYiQkUB41yzzSY+TVb//I5BS41
	d20LmboB+fwsBAkvckZtU1k1FgYuPxY7oalk1XMJvnb37ZgkwkGk2z8KuCwZKJCy6x6Lne
	nsAtAYXlA8RVuAiYNgnWsYgBkoSVrqk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YMSxq6CV;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066584; a=rsa-sha256;
	cv=none;
	b=7xN/7+aCZmWq1TdmkZIfjRKHg4zq/YqL+oQH6oJCcmtmmnYb0tViXEhZWxgK7oY7kQonME
	aoSzAGLk9NRjSEDBpO/efGcRMT57TXh16J6k19h21Wf3rS48hR+/4KIUONJ2U5480ZALTQ
	kL1MOp0CuGo89KdoVLfYOh+ry+kuod0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=srMnuqfW7MrAn0vD4FS9vCIY63pbslXsQEhsyeCn9fI=;
	b=YMSxq6CVlGikJ6ZYNk3Zsr93YdRzoixteY7ZPS1ur3Jfsd5/UIQRXiKFbk6w3nNp4Ys91b
	c33jOZmdZtrHCf94KBh61TF3POwLoddhGsCPj7oO6usl4sfl7kMxN9ieLcXg6C/+MiHUHG
	A2AlrUignobiLH3qXa61HPAp45rk4WM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-407-uPgCCNhAPN6xobiyp0IDjA-1; Fri,
 29 May 2026 10:56:20 -0400
X-MC-Unique: uPgCCNhAPN6xobiyp0IDjA-1
X-Mimecast-MFC-AGG-ID: uPgCCNhAPN6xobiyp0IDjA_1780066577
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92A2F19560A6;
	Fri, 29 May 2026 14:56:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8CD0F3002D2D;
	Fri, 29 May 2026 14:56:12 +0000 (UTC)
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
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org
Subject: [PATCH v5 03/14] mm: introduce pgtable_has_pmd_leaves()
Date: Fri, 29 May 2026 10:55:21 -0400
Message-ID: <2efaff60d3391c1a2c1d63c8b0f129ed3e02754d.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 9pvpYaZqZaJkfy9nZgXBELz6sT1hRNV67fvAqob7GqE_1780066577
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Stat-Signature: a7t1ou3bpjodhg4qtaht8xeib1bpcnun
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C0E320010
X-HE-Tag: 1780066584-330443
X-HE-Meta: U2FsdGVkX19JCtBXAOl78JtEBc1fhxldzHcXXOi2QqSbEr9tA9+U5WTE+bLwZmYyziScJq9q3iCGalAGECPiVSGpVtBrcuVkkpBulN22stZ74+XTmfur+OIRXQ0D4/jOh0AADWylhJCv17vzXZZ28OmKnPEPHmYdhXzY9ofO2ZWS2qo3S1czX2pORp7SnqaNlw5ylFzsYGm5n93fuSw+2RkjVjzk1fTJ/TZZuyY/FURg0ixZV2WgnlwD+QVVxyc8nUlyt274ZuP37dOz4qdQbv+6UgxS9ZRmNnaFs4p3gpOCB1nLzRL5C/iIyQ1SW/Ffa3jvlPYl5qhS55jHfFqclLYOBhizxSvi+5ab8vn7On+PqSA6sivc1h4L+ehg7P88eb18mtjEVr7qSUEax/W/ZeeYtMn34s1KKZsSEZP97lOJHBQEXXN5yp5m6yI9jnlPaUn98H9ZraB77RsW79VKRQ+riyZ3jgFkrnVVO4Vtf6fXTGQHpF6CPzWPlbkJ397ivR1+7FXgQLFOZ/YBlAmeUwMNBrhkq1c0QYm9DnlP3BXe2oT5yGI77f/jKD6QrEG3MZnzNXpylcse6cvuQVhyq95D04qdGPUxSHCVLjWcN8RtPvJBrjDBFztMW9MFSwOq/A2b/sP7FDTF27MCu6bXHxXJgx50wwgRvuXdEyu41sRjw/8xsbYvIvav80NjlR4NrcOui/RimfYjlUvIwYIk75g80YEOIkkU/2iy+EDaT/Xa4w5grYpHKsSeIOJQIu9k8fah/HoFauNoMBC45LaPfXkhh0mtIU91g/p0o53aH0oDYyXgkXUMe5TZH6CUhP+85FfWoc2c+oMs4VDzrOMowXmyPJlkb117EQhnJ3jk2IsxpY8+q3+LVQywCK3zA4COjtSpWfwW07cgQxM6CXJfYBBFDy1uXytPCsGO4NC+NS/wcdlu62xHWOF8Tl4LlBBjrt+mnt13kxrJUhq+zXB
 8cCWy2jr
 7VEo6N02QiaugYBZFvzjVafY5gShFmK+rcZqPOjEzlCPxUMk+sySTxSPg6K+dS7gH7qG/+U4xx+HKYG7yCFw92BTl7sR1SqhnmKRJjRBeDdjXdSCMcO59b8y+51OolKScU9IHIwRZQvNQ3nAAAIx10mu3oqGW+kiqp59J4bIZwTXYX5neFtpfO32oO9J/8rOip1PgfkGazmIafHGWR0ZlMxndUDggeWblw+qUGelR0ujUM5fH8SiKTsQEmhHMys7i6a07ch8WCCsEHq+0eeI08v4lwUbE1OcAt0UksaPhub0NoH4RcS6d+V6MAiUHxsq1ZBVs87RzXziomvXB08+8eLUSJJy0uDK9WBQFLhRWq+RZAhRcJhIzO6rpc5lqsdiifnZJtpS3eQ94oBwYNWjS89s6i+1AGjRT+HnwZ29DwG0a7hXABmImxxt0Gvtm+09/WiM3hI4MALcaUOD5pAqctsscGp4GFSc2MO6ANtEnDJ9Sxjle1WrJ9dQT8U3jI4DWik4hCNIIElWoXd5EDKQ50zrv7ZjWlodot1B/
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
  has_transparent_hugepage(). This helper is used in fast paths

This commit introduces a new helper called pgtable_has_pmd_leaves()
which is intended to replace both has_transparent_hugepage() and
thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
it returns true if the CPU supports PMD-sized pages and false otherwise.
It always returns a cached value, so it can be used in fast paths.

The new helper requires an initialization step which is performed by
pgtable_leaf_support_init(). We call pgtable_leaf_support_init() early
during boot from mm_core_init().

The next commits will convert users of both has_transparent_hugepage()
and thp_disabled_by_hw() to pgtable_has_pmd_leaves().

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/pgtable.h | 16 ++++++++++++++++
 mm/memory.c             |  9 +++++++++
 mm/mm_init.c            |  1 +
 3 files changed, 26 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..d7899b95d3f1 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -14,6 +14,7 @@
 #include <linux/mm_types.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/jump_label.h>
 #include <asm-generic/pgtable_uffd.h>
 #include <linux/page_table_check.h>
 
@@ -2243,6 +2244,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
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
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..2f2bf7950daf 100644
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
index f9f8e1af921c..913d35fd67a0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2697,6 +2697,7 @@ void __init mm_core_init(void)
 {
 	arch_mm_preinit();
 	init_zero_page_pfn();
+	pgtable_leaf_support_init();
 
 	/* Initializations relying on SMP setup */
 	BUILD_BUG_ON(MAX_ZONELISTS > 2);
-- 
2.54.0


