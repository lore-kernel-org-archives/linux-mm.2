Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50DBFF3C245
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3196B0092; Mon,  9 Mar 2026 08:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22EF6B0093; Mon,  9 Mar 2026 08:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25676B0095; Mon,  9 Mar 2026 08:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 918E46B0092
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:38:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2920AB624B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:38:58 +0000 (UTC)
X-FDA: 84526479156.20.EDE412F
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 46900140014
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:38:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BWhTOltR;
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773059936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nisfAIds2waJYT0R56BEFoM3l3b5O3t1RahsBzDsKqc=;
	b=ATj5eBTb6MuxWaG0tD7WL8dCgg6F5UEW8Ze7eCclgLDCRlAOngFpMZ+pi1ZecHNP0CF1JK
	ixtdcwdzX68dXZfyDaSIArxzlWY/zrGe9xtc1WcITOjUIG/PRVWeKCF/JVPgmtMdyoMW2a
	BkErAToqvRPmHrW86y9EJjY4l0LafCM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BWhTOltR;
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773059936; a=rsa-sha256;
	cv=none;
	b=zNrpyVqaVSRYFAhKHO06oeLWrfyZdr4z4eo7u9PeVFLaqllg6Xsq4Ejp7m0/w7d6taGgXB
	X2dmRPZOWC1+mGCOvQhVF7P2ORYrSNP7Iadiu/Q23TaaG0hbiLIDgpakCZ1RLviViECwbr
	wXQCp+yzcKg/6NV6N0lid61BoJZ0dqk=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae5423b02aso53250975ad.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 05:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773059935; x=1773664735; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nisfAIds2waJYT0R56BEFoM3l3b5O3t1RahsBzDsKqc=;
        b=BWhTOltRc+YJSYQTYAJ/HHsMKrfSitNokq6MRfx7B6xVrJO9H4YPaeerdBzWHPW58x
         2zDWpEgdWiogbmp+Xy6AjrH+hBDExU+0CU1ugn2eyveob+1X6kro1yewHn6JQLHDIzFp
         5Z+LWOrk/d5Kj7f3bAMXk+8CMV1vZBxbFAMOvDBK1NisGJdWzuacG+fAY+MeEizGXocC
         xxwXxpQd1WVsGXtXPXkbHRGlIefvmzcxzt9d0aKCxobm2m5Ll3gqK7OzqtY8hoAM+wKD
         189FcXzovbGAwUxGmK5cuYZxceAofoiUHg7KHTuhxO8T5d7p+kULUL7VCZlf8vwz+kF7
         ZsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773059935; x=1773664735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nisfAIds2waJYT0R56BEFoM3l3b5O3t1RahsBzDsKqc=;
        b=gHe06bvNabqHKxmfneLIIJYIT7qOcFgmyFmb0vF5/BH1cgIsLXk/n54f+QpSY9bSMV
         oR1nVIGLR/gMj2kTkseWKr9wBT0Ra3guR9c5UNCisXolUdhnhF8dQSVw4EmlJcIsSM4l
         ozulFCyjjHC6BqoNXJFEWt45ii+TGCf1x0PBXuH1GfK+g0HPwoeQYr9oaeYmvm19SaWi
         BFIJLgOJK0rDCDzHF4Ggz8Dqve+5/wMiwKNxeNBYlbTet6zihEJIPa7yzdYWTnYLG1RB
         J2/JfrXJyccJBbzA0OK9dJNVm8J1LZhROE9aEKnDmWxtsgmJFFXAIpvnYbfy9eEtlz9h
         N2YQ==
X-Forwarded-Encrypted: i=1; AJvYcCVn18JgqtPUeCMKWnFAWvsLxPAIOPiPBb9CuSM7ej2xqYszLnuvs2aRdTdEQSQaSIVxVHFuOHGaqA==@kvack.org
X-Gm-Message-State: AOJu0Yxle9x4UB414IfzhvL+WOmX/J2Xv7zEp8GJoj8EFarbkdxO8u+3
	2Xbsnbwjry7NYNgIqSieJLZ2N3DtXA7V+g2c+5WtnEJFyc6Yy9wDLxPE
X-Gm-Gg: ATEYQzz9fDTcSlybJxKPS2m0BFJOFVLQqYbKcTJnC2WmFNcA9oYbY56cYgrxqWqUh63
	QFd3EoMYIt0WUg2Ur1upk2c54l5H/a4oQkk9tgMaZxxPr8F1d46rmEKSAOq0/Vr5kiQwR7TpKpO
	IfbV8dKyeuc442p5EHJyoTOGvGzXnMzCjohOmWqDUHl4+olCjuH2XO9CrsaAaScvuyXBoQPEHRJ
	soS85en/y6t+0zs+npyXsgtbeGVlWioMhMvDA121D3EUfw271T5pupFZB4jOymtECWX7JO+CdyT
	/sJtyyGwQLlr7gPrcd5U0HLY5yAo6z7rSlEK9z2OvNJjwq1d3coPCMWj4+36uJS3TMVnwOupoFt
	uL4W3yRt2ylOdbnKOp3clYDcKPBX3obw7xFM/cog7oUndKPl7R4mQP5eeeC2knayObsXQsCgpvw
	OFPTGNPqAxFLIb8upuGxLdt2iiEuQ0
X-Received: by 2002:a17:903:390f:b0:2ae:48a0:33e3 with SMTP id d9443c01a7336-2ae82480337mr132396235ad.45.1773059935096;
        Mon, 09 Mar 2026 05:38:55 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83eafc64sm154867375ad.40.2026.03.09.05.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 05:38:54 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Christophe Leroy <chleroy@kernel.org>,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Peter Xu <peterx@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v2 2/2] powerpc/64s: Add support for huge pfnmaps
Date: Mon,  9 Mar 2026 18:08:38 +0530
Message-Id: <6fca726574236f556dd4e1e259692e82a4c29e85.1773058761.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
References: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 46900140014
X-Stat-Signature: 9sdr3aj8ncxp8e3jf9y8www7hqgj7859
X-Rspam-User: 
X-HE-Tag: 1773059936-49264
X-HE-Meta: U2FsdGVkX18rSN3r0imjcKY/xwV6DAhDVPhgOFQdzkV4N3r+P8nowELGoP/XLYUTwqynOwuklkKXYbifZjIAePUU2h6QSbT14hvjYPmxUDq1ut6dJ5LPZ5ZlQPKspkeH5HCBuFK4z1LYnBf7VPVlb/TzGJ7BTI+DhZs6sVS424Dnal73h3nNT2QrABuSztrgYq2qhGLO91T0L2LHXnHZA4eKZTW0D/xvu84vopYJoCktm1/OvmJJm2ztd4XvrUnYtVuj8BuFatiL2+z4BW9P0vPEZEi9sVp4+rW9aOgrIC+nm6+HIw2w0nrUV43oTOzghFHgXS5bLCWBS1X+F2hnphoS6gED4XsrMa3e45cu3/TgfYhgA3HjY7Bz9ha921XLq3XpLJBl64uI21U7daiDlYi22y0vfjbSzZHQCeORjILb2KZ8+xGafBKuZuqi4SxnXcAPwdOcEmqUHyCkE2fmmV7clvo8seZXU5PGhLRrV4XO1CLIb2IfSnRixKtfb3rhAQLLeFrN9XPnMlM8o7JIWNGB6QjdXTLDOXhQYAL54K8IcTbZybTEABLpZ/rpYIgP6K/lvWNlpWOz5MnC2pUQrjCwT2/BVf2a5MLJnoa9v75Jkcu8JHDaKxShrnQ3V+lPnifXB74nV5d8bq3o+51N3YEp8IA3sz3kUiXn1TafDYcHEhuAaaSO5mWu4ahqGlsQZtJStzwJb/JraBYnaYNN1cHJ2euv8OA5QGv8hpGJ41RVmjF+LMfAPajQ1KYzrDtfSdb6z8WjDoBczTKfsSVNib47FHh8sWk2a4wfCO/mZHyv4Jo2pO+mkiRxC8FiBoI01Dun0V+jZ0N3xPlJBcPYCdhHveBchYb1yTgVNEQFc46pNEWt5GrVb2cd8Yg5emMYB1b7LsSmahshPVLEh08HReJPJOlscrn0RIkldyMryCI685I38+xqgeiFsucTdSRWKaCYTquYU/3iNmmU5AA
 llq1YOd4
 V8TaYo5o2fxefmN33cttfLmMCP1KQTd1xZL6HqUJN6U1n/itST7US89dIh7x5fMzkkAW1eYLTacj6ljMCweZAzM8AgcYpetsuYiWnr/dM/NzyDni4488mGVeDC+cuWxxf4yPt2yHGMic1AwXY4wr6ZiCzZqjtzbCxEf3dn/Cz7W+oBfZzEYaekUFRxFwDP8cvOaNI4N2VI4OlE9Tbac+1nUMaaFpDaqPg4ON1Ys1O7EyLgZA2MVZIx69oVfc3pD+shh7sMl8xhy3JCK4IEGt8LCxWfnYoIkLtcTUW7zEEVwfy763/ImJVNKKfIMSyULFjuHLnNMkI/dcQQJVylAlcCWj6ccAgmz3WZNNcxXXzloExrvYn5iS2ysYtjvuaYkJ3dX8dhWG7pUHEqq7k/DU4w38HS/MxclrumxqdFgpexncx8WMb/EM4nHB5pq1K5zARJ+KhOikVQlCxUCfZ/P1Bi1IsdlDdhpfVuUQdPuEyhm1jUmWw10OI21TnvLQDYNjLsYvZC2XjIybrxdF1LT6MZVAMF3dgYxuosleq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
This also adds support for {pte,pmd,pud}_pgprot helpers needed for
follow_pfnmap APIs.

This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
VFIO PCI core driver already supports fault handling at PMD / PUD level
for more efficient BAR mappings.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
v1 -> v2:
1. Added CONFIG_PPC64 #ifdef blocks around p{u|m}d_pgprot()
2. Retained the RB from Christophe.

 arch/powerpc/Kconfig                         |  1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h | 23 ++++++++++++++++++++
 arch/powerpc/include/asm/pgtable.h           | 14 ++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ad7a2fe63a2a..cf9283757e5d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -172,6 +172,7 @@ config PPC
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC_BOOK3S || PPC_8xx
+	select ARCH_SUPPORTS_HUGE_PFNMAP	if PPC_BOOK3S_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if !HUGETLB_PAGE
 	select ARCH_SUPPORTS_SCHED_MC		if SMP
 	select ARCH_SUPPORTS_SCHED_SMT		if PPC64 && SMP
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 1a91762b455d..639cbf34f752 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1289,6 +1289,29 @@ static inline pud_t pud_mkhuge(pud_t pud)
 	return pud;
 }

+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+static inline bool pmd_special(pmd_t pmd)
+{
+	return pte_special(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return pte_pmd(pte_mkspecial(pmd_pte(pmd)));
+}
+#endif
+
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+static inline bool pud_special(pud_t pud)
+{
+	return pte_special(pud_pte(pud));
+}
+
+static inline pud_t pud_mkspecial(pud_t pud)
+{
+	return pte_pud(pte_mkspecial(pud_pte(pud)));
+}
+#endif

 #define __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
 extern int pmdp_set_access_flags(struct vm_area_struct *vma,
diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index dcd3a88caaf6..97ccfa6e3dde 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -63,6 +63,20 @@ static inline pgprot_t pte_pgprot(pte_t pte)
 	return __pgprot(pte_flags);
 }

+#ifdef CONFIG_PPC64
+#define pmd_pgprot pmd_pgprot
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	return pte_pgprot(pmd_pte(pmd));
+}
+
+#define pud_pgprot pud_pgprot
+static inline pgprot_t pud_pgprot(pud_t pud)
+{
+	return pte_pgprot(pud_pte(pud));
+}
+#endif /* CONFIG_PPC64 */
+
 static inline pgprot_t pgprot_nx(pgprot_t prot)
 {
 	return pte_pgprot(pte_exprotect(__pte(pgprot_val(prot))));
--
2.39.5


