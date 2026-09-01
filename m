Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3895C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB616B00D0; Mon, 31 Aug 2026 23:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74CB6B00D2; Mon, 31 Aug 2026 23:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C81E6B00D3; Mon, 31 Aug 2026 23:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE026B00D0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D719D802B3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:31 +0000 (UTC)
X-FDA: 85163723022.02.30D1D94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id EF46940004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fcvssLbp;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTRmmRqhPEEdzIyvqBzqpo/dsWefXC0sTAvXgcanp6w=;
	b=mZJ1XEiUrn4xeA6BodR3Fb6tX9IPUWs2YqXK9ZYtqhwo/3aNBPynpcjNvz+qn4cZNAn948
	/v0Jt9fUgcZp+zllI54skQK4z0OypcYvBAjxJ/0BXJr46JQrjoFWuaAGbisDoowYDqsbl9
	343/Y6jCFGZwjHOqE2bQlrnL5T3TxEw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232410;
	b=cE4hA3ESF4M7NWA6EHoimG3a3t+yNtyD2V/1op+YUbRALlvrAGm5WD1EcdmGp4ZvytDO8S
	nzio2I9vV/GeVI0AXbj7ER60pFj9DMepFcaX50i/8jc0NXAe0f7pIqEGhFP5jW5kf4OIfH
	npilnMEkUqrZlwtN3K+3MxsrGrEKbPo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fcvssLbp;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kTRmmRqhPEEdzIyvqBzqpo/dsWefXC0sTAvXgcanp6w=;
	b=fcvssLbpihYmEkHO9adzlC/mgFlLw4J11xEPQQNvufR0u0EJkOsypBkBZlSsHZEOxoNnIb
	KGBL5GYd13NNDje+VsslC6qLPJS3eDh69NEEQx97HZ7h3NVn8LC75QbvoDjX3MJmf6YFtN
	LIl+xjSc7AFG3IotWmzfgFQGQxDO1bM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-4vqw-M50OOqPm7vL5KfHpA-1; Mon,
 31 Aug 2026 23:13:24 -0400
X-MC-Unique: 4vqw-M50OOqPm7vL5KfHpA-1
X-Mimecast-MFC-AGG-ID: 4vqw-M50OOqPm7vL5KfHpA_1788232401
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62DD1185FBE9;
	Tue,  1 Sep 2026 03:13:21 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E45CF18005B8;
	Tue,  1 Sep 2026 03:13:17 +0000 (UTC)
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
Subject: [PATCH v7 10/14] mips: move has_transparent_hugepage() out of THP guard
Date: Mon, 31 Aug 2026 23:12:14 -0400
Message-ID: <371e2d3a7bcac265ac748ad3c67b74abfa238422.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: okIvU2bUcoARxeGScnNPN_Ov3_pmmzX70fLbeYeeFbo_1788232401
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF46940004
X-Stat-Signature: gu38zbon69qnth79qp1xnr1mjny5p1pd
X-HE-Tag: 1788232409-862706
X-HE-Meta: U2FsdGVkX1/UK7dOa3QnhRqnYlcG9pH0EqAEqyMExzalNYXKJ046LcrcQ8s+9vKpmYbHUmpS4cciJYt4EjF/Ho9gPG5vrwRwVNMu8GlpBZ0ySkK2fhAZ2N+6wCpKPLqU9nE+lcOoQUkDDMUYee6izdvzWHmiUjJFo34KriLn+EcG2yLkGskNSYim0Bfy2iLX/IX2Fl/o8d7nG1CKf4RZda/kCZd49kwHOCGgwykgOU3fDOyELlQtTEQh9JRYtM5LrbN2UCB4ItmkpysJx8yn2nrKTF3zRsi6geiXFBkI3qnEL9xWYTS+q36JmVD0/wakomOkQVNMt6tLEyu5H+pYenyRr3X1fPStHHkDkn9StYXiHHXe8p1jbk6m/BB2xhOaZlPjDLS2to2Az1Hko4SN4c6E5aU/nLYc1jlf/MEd3mD1TUUyYORoAqBN5lwaP1jf2mNYiMLSLtDzHxM2aN2OrQ95ZKkINlb3DfufkI44eO9imPQZ9SnaxSeuWBQPimilNV4ru+X/GOSyqxjWksB7codz0yY8GJk5+NC1ehFx1s2EF8xg2NODngkYpCKbpM+slxkWz0Q4WA8RxmoLeFzH4aXLvfUfM/u1HQsUrtSNYA7vQE7p0KuDk0Q84w6bvmwbu1ZAAPpB04eDHrx0CYNwiyaMuaUM0EJSNDdYceIXR68DuBtXQ6DvK8s35WJAOD7zgOjFF4tKcIecueDcKQDamaMg1cgqPYl945KPnyzMkkpqHSTffFbSWC3oXSoMpA35vSo8s1Es774jazXchcXbi1gsdXlyXA9HHKrZRrpg8jL4Z8IZSHTs2YruZBD31XojUJVo52utXWpFD0EewqEGbKZZ+FFUPpn1INZLQVqasB1JSO7wDtIdmOZoaRAlQZZRZqx97Kn2ESTC5Lp9koBBr4Ido6zMTeX6L40tOI1IOs0fRqPO7oUTzg9GqKy9s3wS5Tz/Tx2QTRBbslypyHR
 xn788h1Q
 DUESXWzl44Y1hscK4kLc20xcpSXSZz2wGOmcamdNOe5/wkprV6LFhRWHkbb7MdOIEmYoj4DMY2zFvG4aEY08Xse3x9e1sHPp+u4IPoIq8oHAiixvm8D7XoNBNF9y4eniZDeLwhMbd4YSeRO+x+/uCqVtaglKGQ/u2Q/E0bKGUudd0PA8Znqk6UXLIV/JEL6SKIl+6nt4623Ogf4A44uT4Ad6jJMNwdeV/sSOQO10Ib6AOGyz0pcg3gKn/ZJwnkW0ZZMuj+6PqcgD5gkK11dqPbF8LLWJBVOP7hjFUKQSNvDnJv042oPw4NLhNRK0zCAKZAPsURa99m1wXL0ZjBQ8uV2J8oc0T1ODDGJCb5DJci6rClPdqNKHFK2D1h7e7gKKMOX/cczHB/TXy8Z0=
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

Move its definition out of the THP guard.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/mips/include/asm/pgtable.h | 6 +++---
 arch/mips/mm/tlb-r4k.c          | 4 ----
 2 files changed, 3 insertions(+), 7 deletions(-)

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
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 24fe85fa169d..f4e369342a56 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -432,8 +432,6 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 #endif
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
 int has_transparent_hugepage(void)
 {
 	static unsigned int mask = -1;
@@ -452,8 +450,6 @@ int has_transparent_hugepage(void)
 }
 EXPORT_SYMBOL(has_transparent_hugepage);
 
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
-
 /*
  * Used for loading TLB entries before trap_init() has started, when we
  * don't actually want to add a wired entry which remains throughout the
-- 
2.55.0


