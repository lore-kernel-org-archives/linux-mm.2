Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D992BC531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251C06B00A2; Thu, 23 Jul 2026 21:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2024F6B00A3; Thu, 23 Jul 2026 21:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2CE6B00A4; Thu, 23 Jul 2026 21:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C11EA6B00A2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3837CA013C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:32 +0000 (UTC)
X-FDA: 85021952904.06.E19F57D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5CA84100002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gaIH85JG;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856930;
	b=wLHcTPDIiqENxpw/fwmrL7NrxE8hO6i0dDaLTGhbv385wOUXG6iOJf9BeB/ZETChUHcgCk
	7DrI9ehCysCTiNz4vmOFm0iTh6FtD/MLJsuFFqkMrbxI34wg1HqpzPDWdx3AJE36bp9iwp
	Op8mA0big7KfsJPFrgMBFcMIN/yiW7I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gaIH85JG;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBV8k5IXd6ab3fSjMUjNqJ/CRTgCYWOeALPQ6DqHXco=;
	b=BBG/ID1op3GwKnivCaGE0ApSYsFQGXtero4yyhPJtSjKei0J5qHn766bLpmKu486raG1mu
	8TjyyX3VagQTJFFnL6l1ohmrO7dutWxrEf+A2TyAvPJm4J9lzw3H2pCv6NeqeqDcteoTno
	WsJg3L8iHbDxG3/nwoYn7oEZc/NfwXE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uBV8k5IXd6ab3fSjMUjNqJ/CRTgCYWOeALPQ6DqHXco=;
	b=gaIH85JGUeFFDk6MWDtvJVPhy4W1d4RpULyiIO1NyXmelztAkA54VEdibDxz1p+k/Fh24w
	tot1+E9MkpGu+uN4ckrG88jDfvvq7VG90ai05RiztSfdzfrDmLTfPqMFXz2CGnetevs7Zv
	rA+8vf1nn53lusyCqSX40c9TuOtxZGI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-U7tegR60Nmuz7K5YbVIW8w-1; Thu,
 23 Jul 2026 21:35:26 -0400
X-MC-Unique: U7tegR60Nmuz7K5YbVIW8w-1
X-Mimecast-MFC-AGG-ID: U7tegR60Nmuz7K5YbVIW8w_1784856923
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4FB4183066D;
	Fri, 24 Jul 2026 01:35:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 465F3180059C;
	Fri, 24 Jul 2026 01:35:19 +0000 (UTC)
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
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 11/14] x86: move has_transparent_hugepage() out of THP guard
Date: Thu, 23 Jul 2026 21:34:15 -0400
Message-ID: <12a6a1eb16e07359439c8c7d14e187a8ad56357a.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: lu_4MekMOJTKpt9E0yHQM73RtXJGX8XIVPs-gm-7ask_1784856923
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5CA84100002
X-Stat-Signature: 1684o54dyyy4ccxs4urk83ik3fafcqsn
X-Rspam-User: 
X-HE-Tag: 1784856930-306971
X-HE-Meta: U2FsdGVkX19zt1ykiFTCg7ZgHGuhX0iS7IPuFyRte+xai3/dFhMq6YmQoPCBry0+GOKZ86WUJMB2eLmtXYWilkK7Fd6dDY0rrrRtV5Flzd4ZfweJAp7M9aLrGj6yKKiGAabcD+fKzzj+VH7r4I5K4vV684BLWOzEejLufXXXb1jFbO4YebUd9MR+K7sUyYLFz1xd3eNsQPaFv+34KCdFPLQSx6q9AzXKyNdAlb0extZs5eQPvIupK1TNx6rzCD0+4pBQkjqK0iKUDCyGQRvLj7oxxeA7LrMuO21A2Ip2kybTiSu2H+1niBVwWMI7c8uc9Lsabt+tQHpiBSDyrr1Ie8tsFGGjWiqr236YZS7KerxVcCHyevJPHf9amCp7aH59rWdOmTRyFLD977xgdJZWa1Y2uzTz8DoUsW9cdb9Snnd/TZXT7hEOIJBH4TJo3KaG2ppVQvy+5g3HGSlWaGgeMTqVV8EIJR4e5H152e6qpJI0329TCWwmpIooSOtY9Cb0UZdZOz6Tb1wSBrB886yFctLkd2v9UoOuZYf4yU2jNzd23U0RFVFUlWjhjHVHnDflS4P9SliaUacGIQ8xv+dWVJQmfwywyWKae2w0P5tsR5CmCZQrKLp9rlY2WVbM5ytyLikHnayBwMeI54dJc9Ddc5fbME/klFXfvvFML6e1GV+nUZ71C/XS2rIDwFWjBfdF2q+LmCDZuEOWJHmG3zYWUywvhe4PqYISr0lUCdhqMXHFqgtMJDWHqmrFbK9xl+/gSJaOi0uN4Fj2Dpg/Jl5IYmZ/LUXav3oOv13C1e/HfaXB9i4PgZaP3OB5UHI2zqRHafP28siBhHGO510nv5a8Ajlb2WVs9zplIRDHMC0puYTm7CHxAKfuATkGNnvDP0PqzyHh/AgmLf7yNnpRJozsEn55m37Kop4hqBJOtX2PEMCEGNXlipzSr3g5PaS2xNH4TjMhQ3iGSibK4T0eJGe
 HLr4jCSV
 mz36vwo/HBoioZlh07j2tofpmg22yIfQtO3WFOaRlr4PeihoiogZmgpBIH0SnAhcuwcr08dlO5VSUZ+hf2s11OcxwwcnaCmeVBjIGbAfuIGOoBM9muqeqJX0rQPXvL44XmGo+6WswjN8SfBndfDV7Z0YXi7r6zSI9eh3N9J5DuPuruIJsTFyYYHfh8iTqVFeBT1vTecKYcFel78ujWXW7Z6Jb05Pu7VFh7T7CX4Bi7Q4SsUtnatO3ufKrJZLNock61ViukozEa5imp1xxsrHSsPjN4bt/xeqJ2mWeE+/Xs4uUvjLs+nUGtMfMobajxEyDm/pC7OUCBiGw/O7ZGyiVyAVXl/8Uew1CufYeOvedp1h//NexJ8wJkPc4Sdq4Zkb4WnuvWZ3hDhPjRFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

has_transparent_hugepage() definition is guarded by
CONFIG_TRANSPARENT_HUGEPAGE, but there's a need to use it when
CONFIG_TRANSPARENT_HUGEPAGE=n. Move the definition out of the THP guard.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/x86/include/asm/pgtable.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 8e0018fadd14..3c62b33147fa 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -306,12 +306,6 @@ static inline int pud_trans_huge(pud_t pud)
 }
 #endif
 
-#define has_transparent_hugepage has_transparent_hugepage
-static inline int has_transparent_hugepage(void)
-{
-	return boot_cpu_has(X86_FEATURE_PSE);
-}
-
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 static inline bool pmd_special(pmd_t pmd)
 {
@@ -337,6 +331,12 @@ static inline pud_t pud_mkspecial(pud_t pud)
 #endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#define has_transparent_hugepage has_transparent_hugepage
+static inline int has_transparent_hugepage(void)
+{
+	return boot_cpu_has(X86_FEATURE_PSE);
+}
+
 static inline pte_t pte_set_flags(pte_t pte, pteval_t set)
 {
 	pteval_t v = native_pte_val(pte);
-- 
2.55.0


