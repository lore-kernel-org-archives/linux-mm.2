Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8BD5C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9E46B0096; Sun, 20 Sep 2026 15:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7911D6B0098; Sun, 20 Sep 2026 15:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6597B6B0099; Sun, 20 Sep 2026 15:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23E306B0096
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:37:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C34CB1C2A4A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:21 +0000 (UTC)
X-FDA: 85235149482.11.200D7D5
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id F10EEC0008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hupz0Fws;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WQSV2M4dYwT0nemuMW5I3vbKfQKNkPtdhJ2W+zZzFM=;
	b=wtuK/iND6UVul+raJVmjZNzKbfAEvk5eb5wz2W2IGJaA+/DM5I20P7lauvvZds5mZH4yNS
	GPBCwo4rDBSP1QChDs4m+naA4a3sQvrKuAiArYIQNjOeYuLze+KFj+lwU76GLHTrcNAz88
	DYtE5Qcjfg2PdFFLU/obQeHU7UN1pxI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hupz0Fws;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933040;
	b=hlCzSFsdw3tnNbXVi+QjWevdtTGWamvgqBUN5wC6VSpnqhiMKx/mV0duMkd/9+FXFd74Hg
	mI2Ul3eVjh+gRfSceUPp9g3V2koPMAsdiska1rwRWvqyKdqR7DtdJpWqns8Jya3WgEoEb7
	w1pCVcxOCaZ5LUpEoqZ6MSujfWnG3Ks=
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895353e9051so18815467b3.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933039; x=1790537839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0WQSV2M4dYwT0nemuMW5I3vbKfQKNkPtdhJ2W+zZzFM=;
        b=hupz0FwsLvD6Rwjdv4hv4oghOPZxiwxIGL5ldasZRPlY69tyqk2JSLyJuQYDkFDvI2
         VpJgRo5AMjMtr4NNryIAha0EchhJx6de3wELu2w5O6CdzupPIxZBrI49ll/IuUtfV1KP
         7DPnZhzguhTn8vZIpz1PKrUdFpWBPYdTXIh6v+dqwk55VlmAFQ8F0V53pk0EdY00YOIX
         tLVLd6NzdhGx73ufNsPFrv6oUjXraL8fndpz4h82TfFGg8ooDYub5A0kW1ckHNbZzXZs
         Vottdh+mNoSG5BTmzVzkuvD/nkyWZaK4ru1XuJZp3yWIbfxGerL0Izl//Ypmfk+bPl90
         Or1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933039; x=1790537839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0WQSV2M4dYwT0nemuMW5I3vbKfQKNkPtdhJ2W+zZzFM=;
        b=kuhB5Iw6ZEk2Df/t60giUAm+1nZTNJ17WOYAdBlYZCwoxTdvqFYaclrvjHkMue4ShM
         v61p355FnmTNYF0bUz07WNGnMWLvX9DHNG7TlL3JjHcfYHBsq1y/ICjhp/aqPpsv2aEb
         eJDXjrpyNqkw+jd2ih1iQbZEW/dV+MMihmblr9C6HBVwUqoQsnnGEv1yumLnWwra7w8O
         c2EEfGKj7GjNnP+OIxX+kY/1X1n+GTX6buNqBSOUd5aWEqtrCZxjRYgGZDTJVvaWGTe7
         KFeAfmzW2jraBdEk4e3Vy+SpIIYCE3Pk3QRYFD9OpiJh/GMyPqGBtQfvA4TLzYkGbaJd
         z9Iw==
X-Forwarded-Encrypted: i=1; AKwUvBymNIkng0S1NLbc4GRcDpBqlfO/AMo74/j8LkOY7TJdBMTcG+cGzQWTw7dKunYv5d1mOncoidyf1Q==@kvack.org
X-Gm-Message-State: AFuF++mdax0aWEQGARfMIT9UXpGCKuHvc31u9kvGOYfpMceTwM87cOoo
	i7vYePYPmdON9a+LrV+2LnqszzWnlap4M38GyAvkWuiCK79hf0PLWsQJ+ruZ8VAzT/g=
X-Gm-Gg: AYBFou0fyQzjTLE7zpXApcDdqLQeJuOpqoU0q9Ti7eknyYxavXSGmlu0UUWYEcREfnj
	ufmv0InnjSMeM3Fa4+jbJrtjyJPGh5jE6EgJ+Q3lPLSZqTnyiAoT+Hx9SfZfBiq4uI45LVsfhQK
	2XSbZnHkm3ViGuUCsgRRoZAG9V2fRqLN1L7l3WHY/0Z0qSL+iCTZtCTa1OR/q+l1iEj/Gj3DQfb
	vhjbcm9OfYoisOWEB6L7uE1uUXyONbR4LDjSBqIyHQPMRJGnEBbXMHJ3UF0Z0OImhEifccfWBbe
	WZNTCSZw7OjNDfgsrY05uIlK5DHWDHqjuluAtGCbxnRStZJtamERXkpnJgIT3vmhZfsDDPmYLMU
	lmWDSfFonFPDyg5KygWhnPS3bf52vRdbIhW/T5DcStaGxFG+izJLWHO+klKi/sL9ErMCan4RlCG
	RSpOCD12W08+aT0Xyc3xEkt56cQxzSrgcD5YOjFtqXHQivXmEdYs0EwKZ0Rz9lrr4y4yyIvQ8az
	35VI5Gjzv5q+4Y9GQp51gGjzze7Oga0gZYjzmnQgjYDAkYAalG/htqMnSuz+9ssF4Jta5Dvg4wY
	zmd2W3ZP+iBfXfYbNtk=
X-Received: by 2002:a05:690c:e1ca:20b0:854:9062:73ae with SMTP id 00721157ae682-89736b3f795mr32929267b3.33.1789933039155;
        Sun, 20 Sep 2026 12:37:19 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a48d99122sm18294247b3.48.2026.09.20.12.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:17 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 04/46] x86/mm/ident_map: Add force_pte to support 4K PTE identity mappings
Date: Sun, 20 Sep 2026 15:36:08 -0400
Message-ID: <20260920193650.3373435-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: whuszcjz56nn3zaybexdciktr5oisosz
X-Rspamd-Queue-Id: F10EEC0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789933039-994404
X-HE-Meta: U2FsdGVkX1/BdhBLI/4F+ZYv3xqdU56FjLQTNve7Xj2j6urNRCsD2VH7THz3eACBoPlLDWh5wBUSvVSKakSrV6+2s3Mx6P2GbXP869pxANTeJa/Rv2eMhjIAEkL5qoQ8fyQkOa40ZEtwyxwFiiTUNOOFOaZusKruw7P20+WNSYC52Z4iUdCry3f9k3swNTJYW/LFRsPPkY9HHxk4Hshv2FSJV0pFRkP6vNd+jkRifyuGWdxAg79BoHVSAwXmHxkituDT9JBAb32j8v+KZojITR8+EUKw8JvZdUAHbTOmO0KsSpeX+J1gkDl2JMWWpg1Sb4W+l3owaeBVU4Lv62P7dvMxBbZkVBEhOAy9kA8mRwo87sUJ15jYli6x9EoH7nl1rsOB4g3cBD7L8LVfj8yz8TRAwlE0CqkiYAJyA2ZYvsDUxc3AbIpmkkJ2zoGb2Tc53Ki7XhE0705wnAIgInyDiZVRkuq6zqW+WJKaY7OuCREK07rG5WOFJhPrEAcN1KErEjCNtCo1te1omjhJ+sQv1qBoDgpIDY8zFMNeocCHhqY8qwaaccgOngH6sCIC3Wr81k3LDQ///Ht29SCrIZ7QON98bywGdtCeku+Rx2Lqtb95DhrWGBqIuj5QyM9yKMkqhVx+2t+AOe4vMMfis0iHGFsVhPbfeE+1CdlJcoeRARe017mGFJ1uPsEjaQRjBFHLM8QTUwdRjCrNL9c9Q1UC82mzOi94QJYrvEwJnC1zDZCYieO1FRGYY/zgYMpa2FWd554rCqlAKpn0QjUkOMZeHjqiApL6eUVVWuUdFtJXzV/coNrahZ6LNEfR3o2bAmovLQ/cOPBZzfFaVBCsSZEEHmKemBc+9fcyiVA0a4v4Pn7S6UIVtNa++1pa1Wd5PunlkaREHCNmzqMdekG8Vz3CQrUmQvTOZ4Gjsh/J0BCW28dY95SZX5lPRRc/4jbWaUXM+EOHD3y45Us7/z4Mq5M
 mtxDj1hQ
 WpjVOr5YMYaT0XtxKBEz7F3+u4roRXp8HkZrMKKVJUFPxyJA4SeHCEtE/WwSHNh9RNkbx+K7hpeOczMR1Y9YJGk0l7/yEooBvBRGcyoYwAA0sNCQheVTK69p7qYAJ+x8AqNwkSMfYH191JNfEv96BMWgw0WM+VsonfnP2Tu90V7glMlFTL04+lJJfUCbzjxDaMXszp7gR89/BJ9ZOYD5Om2AT9r77tqkFsNwuIxS4DBvnAziqtjb56x0AKYd2qzrvr3iQZvcxXzAGIdiCumx53aLQhQ8SKNuOuHDJt1hkmOLZIxinoNpSyNegyepHhzPpkHECFcnEj4NtoyOt3x3+wijFNYGDNKo4oiaGpO17cwrtk2EV2zxl5lysmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend kernel_ident_mapping_init() with ident_pte_init() and a force_pte
flag in struct x86_mapping_info so callers can request 4K PTE leaf
mappings instead of 2M PMD or 1G PUD leaves.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/include/asm/init.h |  3 +-
 arch/x86/mm/ident_map.c     | 72 ++++++++++++++++++++++++++++++++-----
 2 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 01ccdd168df0..d9caed494e7d 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -6,10 +6,11 @@ struct x86_mapping_info {
 	void *(*alloc_pgt_page)(void *); /* allocate buf for page table */
 	void (*free_pgt_page)(void *, void *); /* free buf for page table */
 	void *context;			 /* context for alloc_pgt_page */
-	unsigned long page_flag;	 /* page flag for PMD or PUD entry */
+	unsigned long page_flag;	 /* page flag for PTE, PMD or PUD entry */
 	unsigned long offset;		 /* ident mapping offset */
 	bool direct_gbpages;		 /* PUD level 1GB page support */
 	unsigned long kernpg_flag;	 /* kernel pagetable flag override */
+	bool force_pte;			 /* force 4K PTE mappings */
 };
 
 int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
diff --git a/arch/x86/mm/ident_map.c b/arch/x86/mm/ident_map.c
index 5a15bffe6574..83013513ba94 100644
--- a/arch/x86/mm/ident_map.c
+++ b/arch/x86/mm/ident_map.c
@@ -77,24 +77,73 @@ void kernel_ident_mapping_free(struct x86_mapping_info *info, pgd_t *pgd)
 	info->free_pgt_page(pgd, info->context);
 }
 
-static void ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
-			   unsigned long addr, unsigned long end)
+static int ident_pte_init(struct x86_mapping_info *info, pte_t *pte_page,
+			  unsigned long addr, unsigned long end)
 {
-	addr &= PMD_MASK;
-	for (; addr < end; addr += PMD_SIZE) {
+	addr &= PAGE_MASK;
+	for (; addr < end; addr += PAGE_SIZE) {
+		pte_t *pte = pte_page + pte_index(addr);
+
+		if (pte_present(*pte))
+			continue;
+
+		set_pte(pte, __pte(((addr - info->offset) | info->page_flag) & ~_PAGE_PSE));
+	}
+
+	return 0;
+}
+
+static int ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
+			  unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+	int result;
+
+	for (; addr < end; addr = next) {
 		pmd_t *pmd = pmd_page + pmd_index(addr);
+		pte_t *pte;
 
-		if (pmd_present(*pmd))
+		next = pmd_addr_end(addr, end);
+
+		if (!info->force_pte) {
+			if (pmd_present(*pmd))
+				continue;
+
+			set_pmd(pmd, __pmd(((addr & PMD_MASK) - info->offset) | info->page_flag));
 			continue;
+		}
 
-		set_pmd(pmd, __pmd((addr - info->offset) | info->page_flag));
+		/* if this is already a 2MB page, this portion is already mapped */
+		if (pmd_leaf(*pmd))
+			continue;
+
+		if (pmd_present(*pmd)) {
+			pte = pte_offset_kernel(pmd, 0);
+			result = ident_pte_init(info, pte, addr, next);
+			if (result)
+				return result;
+			continue;
+		}
+
+		pte = (pte_t *)info->alloc_pgt_page(info->context);
+		if (!pte)
+			return -ENOMEM;
+
+		result = ident_pte_init(info, pte, addr, next);
+		if (result)
+			return result;
+
+		set_pmd(pmd, __pmd(__pa(pte) | info->kernpg_flag));
 	}
+
+	return 0;
 }
 
 static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 			  unsigned long addr, unsigned long end)
 {
 	unsigned long next;
+	int result;
 
 	for (; addr < end; addr = next) {
 		pud_t *pud = pud_page + pud_index(addr);
@@ -108,7 +157,7 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 			continue;
 
 		/* Is using a gbpage allowed? */
-		use_gbpage = info->direct_gbpages;
+		use_gbpage = info->direct_gbpages && !info->force_pte;
 
 		/* Don't use gbpage if it maps more than the requested region. */
 		/* at the beginning: */
@@ -129,13 +178,17 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 
 		if (pud_present(*pud)) {
 			pmd = pmd_offset(pud, 0);
-			ident_pmd_init(info, pmd, addr, next);
+			result = ident_pmd_init(info, pmd, addr, next);
+			if (result)
+				return result;
 			continue;
 		}
 		pmd = (pmd_t *)info->alloc_pgt_page(info->context);
 		if (!pmd)
 			return -ENOMEM;
-		ident_pmd_init(info, pmd, addr, next);
+		result = ident_pmd_init(info, pmd, addr, next);
+		if (result)
+			return result;
 		set_pud(pud, __pud(__pa(pmd) | info->kernpg_flag));
 	}
 
@@ -189,6 +242,7 @@ int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
 
 	/* Filter out unsupported __PAGE_KERNEL_* bits: */
 	info->kernpg_flag &= __default_kernel_pte_mask;
+	info->page_flag &= __default_kernel_pte_mask;
 
 	for (; addr < end; addr = next) {
 		pgd_t *pgd = pgd_page + pgd_index(addr);
-- 
2.55.0.1082.g2b9226bbc0-goog


