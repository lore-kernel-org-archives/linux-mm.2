Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F15C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF86A6B00A6; Thu, 17 Sep 2026 21:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFE86B00A7; Thu, 17 Sep 2026 21:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5636B00A9; Thu, 17 Sep 2026 21:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B42586B00A6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:47:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26E641A052F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:47:02 +0000 (UTC)
X-FDA: 85225194684.13.56987C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2870B180004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mxwbi1xQ;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789696020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrTuOGC0ZZQ6xfwNevyROwK/DQ0EXDFg6sIlh7G6Yxk=;
	b=R7MpPoVgh9SgfnifEbV7jQPOquHEZ36fIeq/49dGIdUYeNQICjw9HJobPmP+50koj8oIJ9
	A4mB+COA5FJN5wD2OqzWGcy2Pr7M+PuB95fTMi80RXd4U0W4CjyvKxIJEwcsv85M56LRlY
	PGKaN+9c7fCKS/1QYMElvqnNI3b8WtA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mxwbi1xQ;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789696020;
	b=XdfvfTyst5Uj0uhPF3hbwLQitJmC3UAY/F7qSUyfzTYANjwaN0QeuHUwXJEFt8K4WD30uU
	u5SiJSK9R0hGBv3Dc+pqtbGDSxb1V/9ZRyyMsE/Ylu0cK7CE4TQkhK/2CRi2kgRkk3cUb5
	+ziJuf1EwsRaMlRT5QNp3iQ+PLfNsns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789696019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rrTuOGC0ZZQ6xfwNevyROwK/DQ0EXDFg6sIlh7G6Yxk=;
	b=Mxwbi1xQO3ucNH2omaQyhM6vvejqfjIbRHagSfg+ueh3SS2rvlcCFu3sO+OKhK8yPdjtkQ
	qFlCKNDboGH2jsmxwWCmZCgVlAygFIkaQZTXcwI8VvqhIa75Wya2Fm/7FsWDAwOvk5a0OI
	g2p5o6DsyxxlJQF5fd9h6hi83UvNML4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-414-8fUCrc4nMma3PteMWBX0ew-1; Thu,
 17 Sep 2026 21:46:53 -0400
X-MC-Unique: 8fUCrc4nMma3PteMWBX0ew-1
X-Mimecast-MFC-AGG-ID: 8fUCrc4nMma3PteMWBX0ew_1789696010
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 657EE187A5F1;
	Fri, 18 Sep 2026 01:46:50 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D2D13180034C;
	Fri, 18 Sep 2026 01:46:46 +0000 (UTC)
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
Subject: [PATCH v8 11/14] x86: move has_transparent_hugepage() out of THP guard
Date: Thu, 17 Sep 2026 21:45:32 -0400
Message-ID: <a9f96668979173500096b2df96a96cef84559bee.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: _0pe8eh-f_O1nwsJwuis9-HPaR4bdPia8TXrOLb2fzo_1789696010
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2870B180004
X-Stat-Signature: sfxj9askigdcqfr577tzg9g3ghdgdpxk
X-Rspam-User: 
X-HE-Tag: 1789696019-950209
X-HE-Meta: U2FsdGVkX1/2CCxdNQOMdZ2W0lnCoPTcg5Xs4uk9CCznKucmPsGBghxvHlIOKV3vnMoBlV7u9MNf/xqvTm5txjPs+Jj9d98X6Oc0x5Hr0zelTZsJChYg+T8WgaLI/z2+b/t6wz9G+IHpipksf/SOidgDz9AowEw0RyTLKSRByLKGBu6fNrUGMMmVzsjIflfV9sqopy8Qmd93ZGJwvttOZjh3O8m6bQAzcYVfQPW4f/2/OK8cSWusoBoRGC7yf6QZ2czX8lPiDtW7/KGVFCBMfcEzK+fUxAQr9QK7HeRfN2Io/PibYuCDCyyBbCslb5C4a1okFF1YokVE5HN4E8e6dOl6HVqW66SFrA0ULH0aPEDboUFjoQLHHXupEcm+vWPd/lf9MEojR5vEZmR0OJiRCJNwbIu/dXwuzkfnzTQBh0ZopEnTixPCjRnBH928eNg5rdguOmPicHduD/28ssYYiqfzNJBez9TX0xWwrmebTXp4B1a9qrkhUEyO+0jLfopuWJsblMeeeSYbrmF2PHp3cCLPrG3EtP6OaDK5wGssvgvmapAFfR+zcCKs+Z17F0R75RP/w1SeAn4dt8nSQZaktOiKInf9/QuxNorBd5y2lFl5DMGwk74g1Mastj48OgnwnhI7PQ0TikFz+CT5wA1EyEHQjRhT4lK7tnoOArBE0vnoOTrmlX4bY544Pj5aHOqtzXvpWIrNG4jYWdXkId7AE9L8FzQwfuHxzxBd3+2nqYQRZJY0zV4o4bYjbWETUwN0DePMJH24+XegxtnoPu8NSJlafm1gCGpQ1YmtFjWJCd6Br9lAXBElcgBkYcl52zeF0K4RoennAt7dskcLRN5B4j578EXxx9KGnJAnQaPqDhYXeIBShliOP3sRA/qE4OF+TStMKLDtgMgGlKxCz4uALuGHeu8Ohh6qbnIbVxBNL99LJVqIAHNcKXWyj0+8GPx3/Hb0ptklYtBIoSjhQVi
 e9b5vD5B
 Jt1tanUdDTlusmFU7U0Zfj9kQ0TwRIfyuVQr8m7hrbxVWSHCWSA86jJbkWYuYZ4ZbqPVpCRiRwz7vkaD8MY6cGJGN4mL+gLi1a+wPI/98XESg8+0HOfaHbUnKkus1gOLp609H2AJV+sv61PxtaZ6ZBC3FUANr8BBQRgkHRXv4M9ITjxma9NUmloWQIW0NgqjAD3GSpmKCFuhgyOhYNn2Zcb8DKluQ9zSHoIDFGvlamQdAYxnNpQdZWi1/usktiQcXYN76kw7KProxdUN+eu2NuFw9C95hM6Yz6Zwdz6urjjVhv3Ntlpqd56cpXGjyXbnmTME3bvZ+l5Wb4UYC0z/oduiTFNUgrYWiIz1tb0/YRFSm4yxrCHJyNADMCVFS5WSICN9TFVqYmymZGsg=
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
 arch/x86/include/asm/pgtable.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d551120a7c88..f46c1b502eb1 100644
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


