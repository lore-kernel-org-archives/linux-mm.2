Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 671B810F9976
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB3AB6B008C; Wed,  8 Apr 2026 16:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0366B0092; Wed,  8 Apr 2026 16:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADFF66B0093; Wed,  8 Apr 2026 16:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB1F6B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:23:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36FA48A419
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:23:38 +0000 (UTC)
X-FDA: 84636514116.04.DFDD6DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 58B47C0002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:23:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I1g7fzeG;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775679816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtFsGlXVCNZRVs1NDyUPzRrR7AVvNvSaLq5qYA3VmaU=;
	b=UpRqDBabFw0pmFPLirF4Q6HjeZ5FpNclG+/TTjLGjPeBNmqdwLtqO7585nLUANXzNZvGsg
	pUsmWx8PZFru52e9y1/ut0hrucKCp0ULF5FrkLs5TAUxvb1lHsxaHmxIaBXLdVqkOt9NDG
	IbWpY7Ri0fIHS0RhA6rGwSboVTHgod8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775679816; a=rsa-sha256;
	cv=none;
	b=DIVWqU0gxUpGe+E318ncnW4tz3SnwQNYtTQANcLlyi6v82+cAMCYtKlr67Kr7R3yAutxPA
	o/35hNH4qtfhdlLYbuS1rqbDUxTTx+JA7CbOTTtygaLYPamPxQaKraoxDDUwSRAFO5IJ8U
	fcFtcWRRSN4M1+rfne2j2qa/+V1EM5c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I1g7fzeG;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775679815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtFsGlXVCNZRVs1NDyUPzRrR7AVvNvSaLq5qYA3VmaU=;
	b=I1g7fzeGCtj426O7dHMc9sTZ66/fCVHgG0MrM8FohF8fD29pZHmpPGmvLjfyjsaFWy8lvj
	1he1AgK+O/dK6T1H2/A9ud8FVSO7mOk+ti+wrdKYOqBW8h/oCwwIMqkHcvP7+LaoMYLjWS
	cnIgcNc55dpRiZ4+z2WGWZViqgffbak=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-aSJQ2lfzPeqXC-V-aCP5oQ-1; Wed,
 08 Apr 2026 16:23:32 -0400
X-MC-Unique: aSJQ2lfzPeqXC-V-aCP5oQ-1
X-Mimecast-MFC-AGG-ID: aSJQ2lfzPeqXC-V-aCP5oQ_1775679810
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC4EE1955E8C;
	Wed,  8 Apr 2026 20:23:29 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D3043180036E;
	Wed,  8 Apr 2026 20:23:28 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 10/10] mm: thp: x86: cleanup PSE feature bit usage
Date: Wed,  8 Apr 2026 16:23:05 -0400
Message-ID: <16fe2db0becab98db70f53e4ce1422450a9f40ee.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: LvWWuIU618RzhZOjv1AQ7hoQpP-MZ6cOGn--g2bRynM_1775679810
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Stat-Signature: qe4rijguhfreknqz9c3f5qhot3gjkadx
X-Rspamd-Queue-Id: 58B47C0002
X-Rspam-User: 
X-HE-Tag: 1775679816-503816
X-HE-Meta: U2FsdGVkX18Y2W5JPUzVntxZ9TXPOfqFczi9XhpizU/u+OKTYCXZaIy+Kr8Ib/cONxmKyXswF/FzSSdKv6lRSLCnse/B/TnCau2fWhiZ3UrrDqcvvkQhFCL4fUGdHFnSv754h6ceqaPxCqtihS20wgOYzt0K0a9G5yrsd6cA7KU1r1HS1gG4iRsY78sAEGWjhGl35CLRTJB9ORWrErntpP57gcwMu2VsKsBUYHO5EQ9OWFaK5+NcuVOoQgDgDoMlTw3aqQ360iZgz8mozDTZ44xruaYvKNg1F7aAzV+BGsjDFt11HTnhFwc0UCgKNmqrtdI2hwb8IHmy/P1iqyY37mzMZKmEMALpBurFJWQumRfWcQpaAMgHW4gsqdkp0GnNjA6w2dscGJnaR8v8px9xp+ZENlmfDVq/TI6gtBkbA0L5N1ic+xxDPIk20V2sN2PyioyPJIBJjb1xPzjUog1BDS2J1A/kzWeSWze3nKDJU9zqwCTp5jyxLJZrkF7edKQYQoUCOBDrYHiY8flThGXGU1lwCoSUYtkry3+1zzhd9CLiLhFtU7Dk8NsHP4D4unMlBt+7ZYGCxzGrnAe9zS3SlOrYal2tiJSuzC8pOvuSYdwg5IBWEbKJBmiwxVodMlySb78KcZ66frk2HIjovVYFM6FOpbbPdi05igLNc6EFmrp3syP53TUWRz9VeVaBZ+9Br5ZOoC1oo9E6wKsDM2vFwqGDQG3OVNN6YLxSE066Ym8nEjWckaENJlp0lGyh6LMYg8VZqxqYKIH6tD1zVqd4DVl6mkMEvXV7kFze7M3saE2uMdvQIR1IiyEvD04M2Cu3VVKQL4FveoTAJVwUJ7BvH7bm98F5Gkluox2NzAEEUrlAtJIX4rNYpIi9SAggO1GPUfaYL1WByDxZhIRLQaWMXlf41Ei8JgTV+h4MYj649wPw5RFPWLacAFAWcjcUNC76y5wjRp+1kWSeV1DfHQD
 1lh/8QE1
 srEjFjuEqtpH+dgRCgm5bwA2iB+gPnrGWj+ZUteUVRDOf8mu2e+lcpC3wuYfC+HPcD3E18fqyXADPlKKG/6htDRSSTpkcBzsAVdQLD9lzECuLYNCl6PjMO7rPhhJbBAWr2puTXDg3buZ7T696mvxtn5b2tYi3dUoDRXxI+evWksnBZl4yGEqIsyT096E3gL6ebZCmL5T06GVEIWPL+KtPlOGTcloErO4L5qXu0OlrpafTFJWjx/84ilLIlPRTiNTN9l0+B2EwHAbAVe1Nvy7Pex+TTrVzpqTiv4IzBp0lQWRnurtIvSBqiocL14DBCBdgwOTjSUeRNUPm74CYpgsd00YeeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically, THP support on x86 checked the PSE feature bit to enable
THP. On 64-bit, this check is redundant since PSE is always enabled by
default for compatibility. On 32-bit, PSE can enable 2 MiB or 4 MiB
page sizes so it must be checked. To clean this up, this commit:

1. Drops arch_has_pmd_leaves() from common x86 code. For 64-bit,
   we assume PMD-sized pages are always supported

2. Checks for PSE only on 32-bit by implementing arch_has_pmd_leaves()

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/x86/include/asm/pgtable.h    | 6 ------
 arch/x86/include/asm/pgtable_32.h | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 8fe95270b713..f45568f9513c 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -314,12 +314,6 @@ static inline int pud_trans_huge(pud_t pud)
 }
 #endif
 
-#define arch_has_pmd_leaves arch_has_pmd_leaves
-static inline int arch_has_pmd_leaves(void)
-{
-	return boot_cpu_has(X86_FEATURE_PSE);
-}
-
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 static inline bool pmd_special(pmd_t pmd)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index acea0cfa2460..1db3214cfb45 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -44,6 +44,12 @@ do {						\
 	flush_tlb_one_kernel((vaddr));		\
 } while (0)
 
+#define arch_has_pmd_leaves arch_has_pmd_leaves
+static inline int arch_has_pmd_leaves(void)
+{
+	return boot_cpu_has(X86_FEATURE_PSE);
+}
+
 #endif /* !__ASSEMBLER__ */
 
 /*
-- 
2.53.0


