Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2EBCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFBCF6B0092; Fri, 29 May 2026 10:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACAE6B0093; Fri, 29 May 2026 10:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA116B00AF; Fri, 29 May 2026 10:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0DAC6B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:57:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5730BC08FB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:57:00 +0000 (UTC)
X-FDA: 84820759800.05.E897E66
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6676440002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aVRZLgTw;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/KxrY6mrVUmdE4Wf1xkGQbDrlUS1KgRvFUz3Rv9DKg=;
	b=Purc0RWi+Uxz8xm3usjnxYQEv3W2GjiaUvEOfMyESIRKoWrIseatFicR+eMSB4J0H67JMw
	zAO6Rb8d8oOUX8q9S2OdHNHXGtkoMadhNZr1vzZoecssY/f6M4f76sHTWae/iaEJqHl/wD
	Ge9bqRpN4CgqtP2rmtvNY8RuYB3cVDE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aVRZLgTw;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066618; a=rsa-sha256;
	cv=none;
	b=FacnVNg5h8DT1EXYFqa70qyIbohZ6VQl7irfctoBnrPq9PMGvigLyz96ole12FvPPQu/8s
	J/WXaJLPbQ0vWUxvjrKAyPEIdim2y/mxhJg+jnEnJ7elBHj9k1idjQ6iKfTnrijdTzihWs
	SoV2x9mrjJSReWJdoQYyJ8BxVvV42d8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/KxrY6mrVUmdE4Wf1xkGQbDrlUS1KgRvFUz3Rv9DKg=;
	b=aVRZLgTwL6PUUDkzNZ37Ou2NB3ZAMOWKrJ+xlNuX4BHLQ8ju/63LLPyfqDAL2GdrSgqTYb
	bHqk/2fo2Y8SrOBiulETSyYysImmZXJKMdBYVSaSo6+9epjNzHNqI32AYsyTIF5GrePH4v
	2gsUM/D8nH+vSqyScskxqrGWjv1388Y=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-148-dQQTWKBsMxiP-J-jQ9IIHA-1; Fri,
 29 May 2026 10:56:50 -0400
X-MC-Unique: dQQTWKBsMxiP-J-jQ9IIHA-1
X-Mimecast-MFC-AGG-ID: dQQTWKBsMxiP-J-jQ9IIHA_1780066607
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7056D1800343;
	Fri, 29 May 2026 14:56:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E5F073002D2D;
	Fri, 29 May 2026 14:56:43 +0000 (UTC)
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
Subject: [PATCH v5 11/14] x86: move has_transparent_hugepage() out of THP guard
Date: Fri, 29 May 2026 10:55:29 -0400
Message-ID: <5e980fed03f7c3161a850cddfc3c876c72c71cbe.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: YB2VLwhTKUz_VLlyoILrDn0HuMXg-H57tMMH_Los3U8_1780066607
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6676440002
X-Stat-Signature: brjpi1hfo7prr9apmpfyk9igqi6royxp
X-HE-Tag: 1780066618-168242
X-HE-Meta: U2FsdGVkX18OXwaBd7UoFP9P/YviXRA6KgvajXqYJ+3rCHn0Kix20iQR2u0HTUnZ1jiV5XNuyPT+DrlWgmmu7MqkmGIyvqYnHzAr0/nP0lwxf5Fpw6wrq2qGF9DgTgkDIg/bIDdDfd/F/BTnTti8nDRC28/npYDcqNM0GF1xdcb/wBWR02qeaDfgSpspsP6hRyPy98ElaZhYe2JqoWEtrY9FbNN0galHGtdJiEYivfbMvKRKoerZ9Yu1FyLQQljBfTxOAly9WkVRBllxtdoC4BCebNAxrOCC3HWE3r5IcuO6oIJKMcBwXZPjIexX35ioIK74Wm/IW/kgaheCBmY0/aZTy6N22qxjrnGCOYORagLF0qAqBZpAIDz1ZawHY3X+S4fQMwWCdw7iYhqQW/BSUjt7Cbg03QktPhL/kPS8Eud44oJzdmNyNwlDfHQwil9assdNc/J0JsbkH37qrnDD7a4iA0gium9E5vYlHyfF1fThRHSYZgyf78AvD3db8HTqTZErH0UPrPu9YVAcLcymd41LaTpAUPnYIWFFm+ABAZZ9V8TLD1H9Aa1qCsznjfB6O7EAEth4/1ScxpY38nj8Zi0MbU19u6eJT0tujO8LYLGTdoEH5uBz6vZDx1gwD0F3zkDZYcBSPJcqDcEuQlnva9uKjtaJ6pwX8VdAiixNSg0f4wNi4JjwXxM7+mTzLuR0jCIpDZ0A6Kbjlj0liK5HRSY3WyQDpC/CATEGff0mqnCkJM83EdGZwrcdB0G05a0dSumhwnBh+PHYmMaudjaQie2ShGb7EVKO+uxffCWgDe6OkSGdqEKfvP6sdwKIFWG5xIuh+d6j/ExyCJoQeHrKkcYCMzTnVOpU0TyDSx2/HZk3ABYI1YwXoy44rmSKx7/6Hj+YEYtAOJqxnqZl9mq4gkDNThmSrFqIP6x/idGVfs6wotd81YoUn5MCQOdw2JAHeSbY/k/IIyZNevkUNlP
 LRdCEvXm
 oY+jsjadvKDxB/i0JpSznCukMm6BmUn6MsfLa50mviRYzEtKK5oGstr62hYKgClhy7mnGqCwtpxgTt1dIzKtcMNYseh1w7abN5Q+WE8MbkSNauBW0ohqasv3oD4vYAq6NBsrB8ib15gwolggB/jh8l2DtySPFot5WLKQyNuJaaqujJxxgLJSaCAtuB1Dry9TFLWCzio0N4AjmqBMQxCN9shKAyLQ46bgORIj1J7XRo2atH8CkgFhALPc8rh4maToxAPlmZIJlMbSewVNHml5+oSIUmGmleqkUkf8d/kfxmlombyGyH5iQgt6CfDlTVyofRfuOMMZVcWvZVRTe/9YYIItXnQTim6/nnwEni2CEsVKweUf8pcrAj6gI5JU3iJ+SIJqJyjXMhQCDmEA=
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
index 2187e9cfcefa..30fd1fa034e4 100644
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
2.54.0


