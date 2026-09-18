Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE334C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82806B00A5; Thu, 17 Sep 2026 21:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AAE6B00A6; Thu, 17 Sep 2026 21:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72746B00A7; Thu, 17 Sep 2026 21:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A55F46B00A5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2B19801B0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:57 +0000 (UTC)
X-FDA: 85225194474.14.1EC8E88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id E00521C0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N7H94Q95;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789696016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsETOCxsnGoxp5I/fBy/awngfGJ8vwYAl7i19XvMBac=;
	b=agBQagEnSk7F4v4LjMRLyrGsf9eMQ2L1CTpPcBBc4O2q0kmGl+61lYHOw9rzHgFdv/Np4d
	KhMngzY19TDcA8rn69Yew2vXgR3jouD0WoIy7vwjdyNKQ0p7yN2/29DioAKddzKiEaTOxj
	CCw8QWOuIGcEF38oQ+2qUmM4Gqn9B/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789696016;
	b=TYyIRhRXtMPn7agmPsl4nN5epLew+6L2dREltZzbVIBp4RZ/IZ7gFVMeG7p0eXTYbbps9S
	6rDU8xAkIOQnYYKMMqtMviYz2jmZ3ztVj2fBvYlcm9g8eGfyjA+qBpvAdFkzj/GQjCW+ZI
	MccEgcft9quU7BMHtl4JWno1Rhssn+c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N7H94Q95;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789696015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rsETOCxsnGoxp5I/fBy/awngfGJ8vwYAl7i19XvMBac=;
	b=N7H94Q95T/L2MnAIxD7tu/9axuJuEn31PJlWfruH9EdjBgTggCH55Z6Ht5LGqdcBVzMGlC
	zto7vOMISQqZiAGrqiacTJPstMoUrKZecYweGeB0j9oAgxMGzT3bRY5tLv3BpHznzWeCDS
	u69bgeZ0PZnCkBpXAL4c0U+lUDqw/Ys=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-7Wjpv7WeOSKWc1MHEwt8QA-1; Thu,
 17 Sep 2026 21:46:49 -0400
X-MC-Unique: 7Wjpv7WeOSKWc1MHEwt8QA-1
X-Mimecast-MFC-AGG-ID: 7Wjpv7WeOSKWc1MHEwt8QA_1789696006
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B658187A5F6;
	Fri, 18 Sep 2026 01:46:46 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF113180034C;
	Fri, 18 Sep 2026 01:46:42 +0000 (UTC)
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
Subject: [PATCH v8 10/14] mips: move has_transparent_hugepage() out of THP guard
Date: Thu, 17 Sep 2026 21:45:31 -0400
Message-ID: <13b8b68cde4d6cccd6eb9b73cfe083145bd1f014.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: c7CIrjkQ_FUVlc9owNBhOcTzek6eV4jbQiDvxMRw_IA_1789696006
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E00521C0009
X-Stat-Signature: 6iyzbmgyogctgr4c1ibk5dg98wh5orxz
X-Rspam-User: 
X-HE-Tag: 1789696015-48568
X-HE-Meta: U2FsdGVkX19/nOkjgw6GtA8wAXmeitcocqUbsuD0tV7OB++isaMiru61g9R/x0Ymj9mlGPIY/Ka+CLgSqEtUHtcDmrwZHhZVv8avwiHri7OjenC7d2lH6pde5CWL7xjMNJHHb5wzaNX2dkhBhgHHrsn67oYfeSMmru2jOtSWO/542KsYdqE7sDGtKK5tkySMEHjnmFHrWsQu1ZCZbXXBGXq7xczxwqP1jqUiUigeZwOVJwLbaZQFM11QnBUpTfSWWWLaxjsnzc9W3NLcL7zaNY8ETUA8dP+I2QtACvYtc7YJTRmnbKqJvkIdjtgNgWlghc8o+VT3ZTvZTsJfcYOrWTHLEIaUw+Ka4MNYCxIb7gPljilIJ8gVQPq9u3u0MCzsJm1RiSr6IAKIUk1/14ZMjAYiVPFUGlcVQd0W0ADOfMwBSQQpo6/Vegof9Xe08XeacgVw7zJPVB9EZPiPsjXwMkTbEmC+YHIT+qJ2YxZ13mcYdXuDFOlkkwyHPvWXiXL2BpRoQ6uunkpruzJ7bLABcpeQC/2k/HRlyasODrvwentK7VevIbfWrTD70CmZfpe7bbw/sWFkFthr7LMMivIVlkkgQYeyXwSFB3syL71yb/V+w5mgu60mx1JTyLj8Z8HcNFshWcbOniKsAorERMv6dbxC4OTgOyuG0jhSU4d/5OrYevE9bxtYOvNWX9MewQxEvkkoIcEFJbAJs6l+mZz7OgMrsiYRcRjc+//PaA0s8UYPnlwdrn5whuG1RcYfqeLvTTgMA9SNxig8C94VecwBo2CKw1ZIp2Ax6NoFdfqwuYaC+1rrj+tRMkLgLX6ldOSBkkbDwoEZe78YuJOjCpajXT6bVp4Wn7uZiPrzVVIiAJso6wso7O0uq74wjKhR8ibwB6k9ZUlJU4Too2/s3GQ6yGgevMoGJvyHen1Dh1OzR0x8DS3skOkmLGi6VMA2CHIsiJjME7BTEFC6y/jA56W
 cN9NdZfF
 C9bs2LTL6S8u1R+TmVnN3tPa9eGNxEZj/I3dqWS0JJvdnLbDYZnxzfScNU9Ya/K8JTUXVel/M00q5iKOM9KUtkX+Nd/U42uDM9PEoX256TXpEVdxt6ARC5xHhnVBQuNV35Z3QVCPBXNdRg7CMMvU0eoaczOLhwaJLGkmni+GjSvLi+3z9JuqIfWvT5cDhINmugJ34aHYsALX3TRJUvXPxj42Fbmc/BTyp4raIzWPAu/fznaeX8fd3uBb0UunZMkymPv1jCtY00ocUbuNr5JMlkS45C/L9pFGGI6r2XTY0EtZspeAX3A/v6SBRNV5+YOH3Y5JzjawXUsmvocHoECMzYs4UP9jOo8q56pherENIxB4MbSXWydQjTHjSUywJqubukU31zL5+HYkRsDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future commit will introduce a kernel API to allow for checking if the
CPU supports PMD-sized pages. This API will be based on the
has_transparent_hugepage() implementation but will be orthogonal to THP
and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.

This commit moves has_transparent_hugepage() definition to
arch/mips/mm/pgtable.c under CONFIG_CPU_SUPPORTS_HUGEPAGES guard in
order to ensure that it's only used in CPUs that support the register
operations performed.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/mips/include/asm/pgtable.h |  6 +++---
 arch/mips/mm/pgtable.c          | 25 +++++++++++++++++++++++++
 arch/mips/mm/tlb-r4k.c          | 22 ----------------------
 3 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index fa7b935f947c..b038da872ec6 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -615,9 +615,6 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
 /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
 #define pmdp_establish generic_pmdp_establish
 
-#define has_transparent_hugepage has_transparent_hugepage
-extern int has_transparent_hugepage(void);
-
 static inline int pmd_trans_huge(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_HUGE);
@@ -743,6 +740,9 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#define has_transparent_hugepage has_transparent_hugepage
+extern int has_transparent_hugepage(void);
+
 #ifdef _PAGE_HUGE
 #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
diff --git a/arch/mips/mm/pgtable.c b/arch/mips/mm/pgtable.c
index 10835414819f..4515fa42f0b3 100644
--- a/arch/mips/mm/pgtable.c
+++ b/arch/mips/mm/pgtable.c
@@ -23,3 +23,28 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pgd_alloc);
+
+#ifdef CONFIG_CPU_SUPPORTS_HUGEPAGES
+int has_transparent_hugepage(void)
+{
+	static unsigned int mask = -1;
+
+	if (mask == -1) {	/* first call comes during __init */
+		unsigned long flags;
+
+		local_irq_save(flags);
+		write_c0_pagemask(PM_HUGE_MASK);
+		back_to_back_c0_hazard();
+		mask = read_c0_pagemask();
+		write_c0_pagemask(PM_DEFAULT_MASK);
+		local_irq_restore(flags);
+	}
+	return mask == PM_HUGE_MASK;
+}
+#else
+int has_transparent_hugepage(void)
+{
+	return 0;
+}
+#endif
+EXPORT_SYMBOL(has_transparent_hugepage);
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 24fe85fa169d..625f1c0dd71e 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -432,28 +432,6 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 #endif
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
-int has_transparent_hugepage(void)
-{
-	static unsigned int mask = -1;
-
-	if (mask == -1) {	/* first call comes during __init */
-		unsigned long flags;
-
-		local_irq_save(flags);
-		write_c0_pagemask(PM_HUGE_MASK);
-		back_to_back_c0_hazard();
-		mask = read_c0_pagemask();
-		write_c0_pagemask(PM_DEFAULT_MASK);
-		local_irq_restore(flags);
-	}
-	return mask == PM_HUGE_MASK;
-}
-EXPORT_SYMBOL(has_transparent_hugepage);
-
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
-
 /*
  * Used for loading TLB entries before trap_init() has started, when we
  * don't actually want to add a wired entry which remains throughout the
-- 
2.55.0


