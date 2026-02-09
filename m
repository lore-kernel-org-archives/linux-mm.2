Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D315AE94617
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC8C6B009F; Mon,  9 Feb 2026 17:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B1A6B00A0; Mon,  9 Feb 2026 17:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0EDE6B00A2; Mon,  9 Feb 2026 17:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBDF6B009F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:15:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 696A41A0300
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:09 +0000 (UTC)
X-FDA: 84426324738.08.FF54893
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8ED5D18000C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Yw/w+gSu";
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0qxewW2YSQTThSWCJkjfHByvyqMVZJcNKxWE2448z8=;
	b=S8WPpRYGlcmb8Ch9D7y8wLfSZpFf2nkW4xap7O/JFOlygERr1pGjq9zTC/tdAnE/JZwRoi
	YdjW7G84Yzo3Wk2PoZtZC0bxfxiaWpL3VxzfdBH8bZ6Yv1gUZ6UsI6CNABXmgg/h/KDVBm
	EexpfNE3bMlZc3MGBS6btFvynXeRbHU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Yw/w+gSu";
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675307; a=rsa-sha256;
	cv=none;
	b=bQ51aFEAbp/RKR8XNoBYceHT1959JmC0LqqusOTJ7u9Tu4svOSmezmKJn6LvYg/bxq19oj
	/KOaU7HSp/WxgIxJqBns/Il/1QdrReQycCySaRynAmIYndyRZiwHt+J9m7B4lMDcmagERs
	O0+a1YnL3JyP3ccd098X7Ioyt0wHxXo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0qxewW2YSQTThSWCJkjfHByvyqMVZJcNKxWE2448z8=;
	b=Yw/w+gSuP/mn61jv6NJ0J/FWhUYAVpyCWQ+uUHv8Tp5C9bcncMGlr+wJFVbjWL7Z2JZco9
	QYZAGnYw8WqwI7fiuShqXIziyjhA7eQYchVN/3nQNidnrOrCiTsYeEyxfqLNzyyiCwEA6s
	lOJwB+xXiG5ThPHrdOEnz6Kl58D7UFA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456--g__dwcwP3G8CSOQpiOS9Q-1; Mon,
 09 Feb 2026 17:15:03 -0500
X-MC-Unique: -g__dwcwP3G8CSOQpiOS9Q-1
X-Mimecast-MFC-AGG-ID: -g__dwcwP3G8CSOQpiOS9Q_1770675302
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40DB61956095;
	Mon,  9 Feb 2026 22:15:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2595318003F6;
	Mon,  9 Feb 2026 22:15:01 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 11/11] mm: thp: x86: cleanup PSE feature bit usage
Date: Mon,  9 Feb 2026 17:14:33 -0500
Message-ID: <c9d9bcab76605457af2bec0ede42c25c52d8bcbf.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: gHYXQ5BKAbu4zn-sXJc3UHKIx1Hf-zN6Z7nt356B4jU_1770675302
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 8ED5D18000C
X-Rspamd-Server: rspam07
X-Stat-Signature: n44dkfnpsn59d5kqahmtzydsjqyb6n87
X-HE-Tag: 1770675307-801471
X-HE-Meta: U2FsdGVkX19SjZ7mkOXuarhsWTRuRaE8b/BxGTm+ZuWxh8oZq+zDQv84GhUok98MosHU5ZD6YGSRILAvnbOsxFVXpxjHBE08FEo2XHLYGdTW9Cw2TEm3KdlNkk7AW+uF4Z8cq2+rCafhNkbjIG0mdtodI5JW1Wh/8KwiwmYNgyuOP7Hi4g9ccs2leyN+qeA7o4pF71CHFc+By7ynLAHkZ1MRlRQxkZWReJohZEdK6diHCs+seCTesPZRa7UgSAG5SmGr4pxHxOfNR6MCf7QYPKKRAChrRkoT6uxO9g8ZiIb8+ZZ1HE4ksJbxCUN4OGsDyl6L5DVeELuPvnHOfegBIZel5LamfiQg/TQkgSU76AtKdCJuvWj3cBL66kvS4KLm1GnexnVzkeQrNorWmJc4GLs1WsqJcAOQexSQpsH2zXG9zoENkD+Cb0q9yD0zE1plERB8pMYVNEHTZaoT3BU52JyfMJRjOpGQV8pucuH79EngBTht50hpRSXjFJwSfXvZn41DEnYDU8WoAx13qGk0VqPXVW/1QAkwwx6z+hVltYc0OGYYl+XKrtUPOg8lN/RIrL9GU1XFqnYsJATM24vvprlZ+3/cBK7CJFBYq9SAT9vMtklC4/dzGOwErrauwSu3bUVVzEzTwnitwur6vgNDfQTOSaURQoZNeZg5Lp5yOT6U5mgryUYc/LNkA8X8HXhkgufHhmZ2/Et0/pjRre5Vue8vLfEBvFPg2gekYERh7AG1QQNYwLv7X39uQYtsFJRW6fpXfIBcbhCl+lAGzkF3HFqy7KP1Q+PqOuKqVWEgRXsXS5KkjKYRqu+lcIBjIP/GCKzRyns9ch6biowhF6cwrv8WZ0pOqTzZkpJj7tm5BKhsGanmRkbCQYUWxmBRMIIMJQC+O5C/gPeloA1zbLRWb8MHx/Ws8yu2uJ+mU1pp9tfUX7EW3N7FsFbx9vk45CQIiRYYzdxD+Uxz6NGs1UT
 rywDB1/D
 o+HY2d+UjNR5+5gcIdHISA9FRKSXqTdPqmrY708KW28rp0KhS8AC0+zvCokPCLGlJu3D6+mJEDMl/D7d3sxgF+laYgE5NtSmFqqfUUUdtmtCKyFJuzpx60x8TcU9KDcdcMP+3nZW6gFy5NBXTXADXNJUgu/ocUj0U3ZWqXr7tTHx2/AMBvEnv7YyAZzsRXE0nUYHqxPORi41iVM1qT+NLlF5QeUUbHKjen8ny58Xths7EKFuY+/q7TMDpJUEhzFuzdBVrTNAAlLq4O2S75/cS4fYzh+mNUU9l7uFS2fU3A7LtiVoUZc74X/zYM8bv1Jm+6mMK8fSCkKCxuHqHx17PwrG+4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 08d109280e36..55b88de5178f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -313,12 +313,6 @@ static inline int pud_trans_huge(pud_t pud)
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
index b612cc57a4d3..3bd51cfa431e 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -45,6 +45,12 @@ do {						\
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


