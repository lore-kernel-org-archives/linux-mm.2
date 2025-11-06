Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238DECCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06B38E0002; Thu,  6 Nov 2025 16:29:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95798E0010; Thu,  6 Nov 2025 16:29:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D158E0002; Thu,  6 Nov 2025 16:29:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6977B8E000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDC6212C273
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:34 +0000 (UTC)
X-FDA: 84081473868.05.6CB8592
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F695A0006
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Aa+VQPSG;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXoXvGh7icUa4ulh0/ArAKzgINifhHLmj8YOfBJ+Zu0=;
	b=TLfcfR1z8aPHPl3ANOgXssczWEnpX7BsSReSvcw7BbG61bCkwXmK6SFMG03hJaOEN0ozeb
	mfR4UCJoI/ZWkmVfTo5veZvV4Pu1l2oo+2g8tzVGTyn5RjTiufS4rm5d+Vdks+SFMoRPqK
	DR5v5PXHpoVNAy+ZkstgXJx7HmYW8sU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Aa+VQPSG;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464573; a=rsa-sha256;
	cv=none;
	b=o0BzBsgidBYleXy9gl36kfW7E242Ck9qJ+XaI8GIw8Dyc0/6rKtHhXvFr643iGXlatpkow
	24TlTU30UMOMgTLHaSJxv86nr/goZP1s8s6PGL/AZAOIVbXs9elZs5P+xyTFD8P70rNVPY
	2Gq8WeOVecuAUEIvI5WTGsoYaPFdD2g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cXoXvGh7icUa4ulh0/ArAKzgINifhHLmj8YOfBJ+Zu0=;
	b=Aa+VQPSGfVxqE5UQiDUNjAgQgsXN+PYID4xaocx1aEljev5WEjv2leS79yA46dErPOJ4r0
	p5vq9bPBMtD3mI2TeUKYzQQI1lY3zXs8QzXiuWb+heDUoWB8tKNLUwQR8v8awfu38FIryK
	1PyLzTR4fzqG2G9/0AlVg9SnM/iWgNA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-DMJVGKR3MuiElvV9x0B0jQ-1; Thu,
 06 Nov 2025 16:29:29 -0500
X-MC-Unique: DMJVGKR3MuiElvV9x0B0jQ-1
X-Mimecast-MFC-AGG-ID: DMJVGKR3MuiElvV9x0B0jQ_1762464568
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32FA1195609F;
	Thu,  6 Nov 2025 21:29:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3657B19560A7;
	Thu,  6 Nov 2025 21:29:27 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 10/10] mm: thp: x86: cleanup PSE feature bit usage
Date: Thu,  6 Nov 2025 16:28:57 -0500
Message-ID: <8dc0695aa1c1073ec475be18e300ec1046344e84.1762464515.git.luizcap@redhat.com>
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
References: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F695A0006
X-Stat-Signature: z35wkdkryyme9hpiyefgs3gtmoku91yb
X-Rspam-User: 
X-HE-Tag: 1762464573-786924
X-HE-Meta: U2FsdGVkX18HGbrx/0Dv39wSkkmTHmgBCoRO69hhn50lk9MIQnOLQqENVFaMoWt3+59AGh5Rj6Ftks4mVgddxjTDkw7g4ki7uHVHg9Rt5e9Y10zOYck7hN7jRDjHlbX1kuO2aEmZygDQufGVBhrWLVkd9LSGTWjvvU4WrAXNB6uJoEr+JxM0be0TzH/g+ZkHbr22P3d+2lAJEiIfGlmrKb04+XqDm2cPCqdpOGAddEoOxEkpVzQBYaUk/1XJlHYHWLS/67FVnljpV72a0eWrDAXGNgC/v2YxbW4aOhxX002j9L59EQCp4/3w7vPxgdO/mFaBbrH4wLedI9X76EjjIZ332zoLJ1m0y5CS2nSpyAzgb4GrAdRiqI40kwuvOW8ekcIkWTHGiqCpTXOwLhu84FvlrfeW+lEwG2V2jNZAOe0UEzIhhM4hbNLWAis8FRgfjbzZE8z6hrcWSnCvOtwREhWfazR5C2vzE/rYxmpiKVQYSnDGWmB8B0bxoIiaKsf1vGe3pYInVGqYKJWPpqF3zqeB3LISGNY7VAqEQtQrs/0tnh6B1Zx2zWak6w3dSWCSmAUdw9+Fz13liDa4PeiYd46udcgME+LpUnb6zwebdrsw+1jk4Ui8tY04heDXwgNgYP80MeY6wYpeaNKw/+sC+uFFwe5xowLU5w12wcApyZC7zvRvo+XjdDXyEhTOLdXjvDHIK/NTUKjNwfHtlWJUKzZ98rboItP/t9frH3XJ+LBjC/2xIEwi3tvwpFsOxjE4Z34dsDAhYpkUuFG9/KIaiP97bRwhuL4TgtazDHXXniNhvMCPGq+B6vT5TvIeyIQdDazDM6UTqbccfJPookZTWpzlJX50ZFS42VD4R4WHScGWFbsiaJar9AwVTB49t/Nxs0ZLqQys5ICnsrHg03bdrzftY1evRe+LTP1BTiiejAe6K0RtbWnuJWt+FwK7bwxt6GSdNH8F6smPoQOVWsU
 w4IkSsmE
 liTMIvow2+1HE8xKTcH2g4+EBtYw+lLpe0QKIYnusBdXAx2Y8ua5utGJQOjgkUdiFbrCoSVLmIiWjiem/TyQSUCzj/fnxDh7uj46Bo46VxSoCWZgLYCelEwmyx374ExXhJcY8b5Rcio51FHF61kuibrwpp4aFB1gM9BWCyYVuoCoCJNodP4ZB9BT58JPo6zGq1qCNLa/pceUCEIbp5wtLwPh5Tr5XaEVOnQ+y9myHkpWfVKcqWuzMKwj+kURwiejBqr06p3gNWC9W1Az4sLc8nH+Bx1WlCQ1AOPy2JOEVt6jBvzOYYlrd5bhJyHUjHhLaSghJc17E74nLr1M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically, THP support on x86 checked the PSE feature bit to enable
THP. On 64-bit, this check is redundant since PSE is always enabled by
default for compatibility. On 32-bit, PSE enables 4MB page support and
must be checked. To clean this up, this commit:

1. Drops arch_has_pmd_leaves() from common x86 code. For 64-bit,
   we assume PMD-sized pages are always supported

2. Checks for PSE only on 32-bit, using arch_has_pmd_leaves()

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
2.51.1


