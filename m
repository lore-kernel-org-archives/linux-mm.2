Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7FFD2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 07:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228F66B0089; Sun, 11 Jan 2026 02:45:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5986B008A; Sun, 11 Jan 2026 02:45:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FF8D6B008C; Sun, 11 Jan 2026 02:45:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F40E36B0089
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 02:45:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A03468B82D
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:45:16 +0000 (UTC)
X-FDA: 84318897432.28.BA2BAB6
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id C0D78C0002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:45:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H8ThmAfH;
	spf=pass (imf10.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768117514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErDkSB/YcKlAv/NjNwMo8qsmxcHYpWxJ6GLrwPIMkds=;
	b=gtK6f7q4D3x/rExuOn38SsdDieGHcobW7vvcJZRTP5FizF4payEIpIJcSA8AfwrfIcPG3p
	a26eWVbwtGzJ2+qdLEgK0Not4XpBZPqMTMkPA2p/qwCW8L84WB1PeqTVFf/HBVZw2kAXTB
	BJwCNzdBnOLwQYg3AY+vfJylfcFnrSk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H8ThmAfH;
	spf=pass (imf10.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768117514; a=rsa-sha256;
	cv=none;
	b=d1wkoj4ytm/BPUHNIIutFCRdgHDPtgiquoh3umkFo4talFH4jh6SyKQ40M7yXrO8JshwxW
	SjiexZFUytgXy+Vslv8Agl8uHyPBZXqt1L5FH3PmoKAN1L6Zpl5JTXvD6Si/O4M6fp4hcn
	HIuLNfdQTGnpBZoHIR6LU6my59RZTdQ=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a09757004cso51204085ad.3
        for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768117513; x=1768722313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErDkSB/YcKlAv/NjNwMo8qsmxcHYpWxJ6GLrwPIMkds=;
        b=H8ThmAfHxCAz5MeTKW2uPQrPOF992QYYjY5unRU46kVlJYyKvzi8iZFsufa45IC88Y
         RJeUC3SW/Ol4ZZpoPmxHF6nVAsBxwsj2VtQHnlK0Zy1sT+IvBxr/jEX0RpgjdZL51Csd
         74nEoMW++Q8LdH5G6dcGbZbte7wSSHWQH5MiPaz6E1EJDwk4d96eUEL2sKSyiolPPhyu
         gOEoQzllu1IfJB+a9Z7H1wqaEvTOnp/+heGBkT5omAedw+6WleQM+9CdComveU+M3i6m
         eYxObR5sJjAgzr+8DTTU0xEp24c1d4snxO99ApSFgOnbztIXXYxnuEMkIYVLFnMCMCtb
         zPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768117513; x=1768722313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ErDkSB/YcKlAv/NjNwMo8qsmxcHYpWxJ6GLrwPIMkds=;
        b=WB/dfBItsVo6rQopI9wgdyxPPkhV6w0v8y/Av0UBnHoodrliyIAmrj05VoTgp6C/ro
         rmoyYbJmYykyz9VErHvach+BTfwGI05882c9e1wm70K4htmpjRRDX0JkXj/A3SXIbm/F
         lxbbTliW2k/6SgVqeX1KDBov75ATBly9fMrUSVeD9RjG/2Dre8jrad8aj8tIIisHDu7R
         LodL29JET8HBkri8q53/62egINYFz3zvuq+leKDlgDJ6IAmUdCK3xJBNjmmtZmjogJ38
         k7EYdZX0weRvkISmfEeQibpJbTIdpGyqePF88+1vJmwIpbGOqEc8ws08Us8Cu+aQzi9g
         AdYw==
X-Forwarded-Encrypted: i=1; AJvYcCXg3wE2W2G6KlUhOglfWjf3onWci7VpA+hiismaq/Zgq6E12MIsYDmw8Fy7r0PcJ9cnAA7w+bkM9w==@kvack.org
X-Gm-Message-State: AOJu0YzudpgwgQMC8Ekj5BX8Q+UIz+LznwmcAH7JyFHqb/+Arzf3oklf
	2UdUyusOEDCDnuaq8ZYvgFh9DVYd4hiCW563aLYOq6unItlHEvV28/5+
X-Gm-Gg: AY/fxX5SeR+CCCGDbEG9mU8Ixy73oYQTBBaLNph3WYZYWTv98T9sjB25aQvDfa1QVHQ
	LJyjJ0BemQVP334vKd8E685wm+DYQzr0dRdu1dOBOArd1TqlCJVc8RuYygLCHpFWnbNimv/f9OG
	19ZgbYvnF1Fw2pm5j3FIplpxqJ4S2HydE83jgk5oEv1pumFYMUMBoK1JvdOa8gAqc5d7SuTt1RB
	vIzsyhjGp6dofmo1jQkG/2EpF3le7tmSoLZOGsNu3Hu411AUncRd41u9Qi5Tfm9050h6A23oeO3
	a87HWXlDAeFLufmYvHB+Nc1aLHdIKFLI02kf/2Xk0HuNp8i4rRQ8RwEhqQNZkHj4gOzrI1+S69c
	NXSfq47HUQu4c05Iq+juS853UxJ46WEGHFO0VV+qRkJPoMoyHHPREQ0/MvPFrhn8g1Pz9zJePDo
	F+eBjfj/lLVb8BEiR+FVdK+s9s9/BvYNN94M3/r6Ar
X-Google-Smtp-Source: AGHT+IHEY2L02vHLsHgqVo8Ud9CELmE+U6IhLRIOoCjAfiREzCyIRITc84zZTfAj9tRvsfC/hMJRLg==
X-Received: by 2002:a17:903:1b4f:b0:2a3:bf5f:9269 with SMTP id d9443c01a7336-2a3ee4151f0mr155587325ad.3.1768117513511;
        Sat, 10 Jan 2026 23:45:13 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2f8asm145284015ad.57.2026.01.10.23.45.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Jan 2026 23:45:13 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 1/2] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
Date: Sun, 11 Jan 2026 15:44:52 +0800
Message-ID: <20260111074453.66728-2-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260111074453.66728-1-pilgrimtao@gmail.com>
References: <20260111074453.66728-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zhdh9bd586k68a3my3846qewnixdjgza
X-Rspamd-Queue-Id: C0D78C0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768117514-378135
X-HE-Meta: U2FsdGVkX1+OSXjDGVRBLlVM4a/zjS2Yre3tcdDQYc/RlMmSML1VlVJsqsYW/1bRlpCtc39krQHsAN2//iNbQBvASAhMKxseDFdH3koTR/g7RJEw+uk+PJqv8+j0f6FyEkOlVBQit3MViq+uE88VnCFF2UTvwDBGuGV8RInPEngsRUFnpAAmhxtBwrjVXsjdW0+1n3oudm4vQBbT6/RJQxhwamSysOHt1TLsoO5qC5fWFQ6/B7pR1fPDmLnCwJF8ttSeCXQ3RQhtMRKx5Bm5GKuIS/upUQsa2i9OGLZrLRPBJH/GCAQZzKVcI7qNqzY262nOaA/tPjWVYe/Wo2OKHJbhjGFCgeIAztel7ebextXu+2NXCG7On0QwnkYM4h6/YnKp45DRFI896tpHjKq2W4PhOlsfDqmJ0FK1Avps4dEd0TNa214sA++v46erDWPDl7L5kPC4gkNuQNgHzMYVVepvutL4+bGsT6i9tKIEDAYAtqTW5xQ43EEeUqR+OJOQ56SKk3QbcEijsMgsbfFr2bsiGAhUoK3+DL2JUstfInQxCDypHBFiykBpr4Pfwzahk+6g+86kVFKXsjYD2/CcZ0QtaMdBgfUDzhIUoIqnsP8RsKueL/T3y9jAjpcJ7siUg04Ga6oxrM+yX8VQgwK/CAIAjVazaklr/lppwtGz/1M7zSQpXspWz9+m51yD4NumYKuiVV0+X809X8knF4Y8LLSvgHuo+8eGw1Iq9TXzQ+d/AQX8GRVabu231UDUJykRuWHFewogLwLwtSFqJ2jZ05ZXrMFURvadLLN3/0WxshRu2Time3P+06Y/Nb0tkgrP43xTuHW/pR9cmUgFgmllAhjKDW/Ss4Mrm9GxoP8IUFuZk5TGcCvgniOLk2Zj1lhYQB/XTNXFiL1TEC4GNE65gQsTPwiWwrfNS9upuwLp6XCU9osvgieciwUO5rM4G/LKpfW1w1jD+9ZemnnjkD4
 6Za4rGK+
 Jz2r1reszgnxbv5orzfu/XWpfQ2plZYaX70TUK2QECf7MMeqDNAN7z4OEhbH/2xkByNNUnUwKsJ31BM628s3zk41vPNoQ+NmcEGRvoFeD+fINUbdXmR0dOgTegnwgXlEM1gXpaHrWbngHum9+bOTa01BMNKyOx2SSdvr5tsC7PbJxB/YxnOkzhze9jwjVZ0WynLO4SRRZ5LpADit108a35mPY9bYBlPfJYWOdLT1/V4wsBbfZ6AavrckX46+qx14iD3NvxPXMgbIAbk3ZWmxq3UFMc0Oc7TY02TygMZ+/fu7uKKSJpL16VUWDvmuuzy5Njl1R9wo/Xrg9VsxzV+fgyFoNpSgQq9JLxN2ZhuDmDJKk1BvPpVe2Ntoj1S9VfZvmzA8W/qzL55fu0m34Id3TFm8ZpXkOTbRe9UBBTAiSOJ6RcOiMdna8ocOma8wLBIwNG3e4+CRR8QjmU7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

1. In the SPARC architecture, reimplemented vmemmap_populate using
vmemmap_populate_hugepages.
2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
when vmemmap_alloc_block returns NULL.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index df9f7c444c39..858eaa6615ea 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap)
+void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+			       unsigned long addr, unsigned long next)
 {
 	unsigned long pte_base;
 
@@ -2595,39 +2595,24 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 
 	pte_base |= _PAGE_PMD_HUGE;
 
-	vstart = vstart & PMD_MASK;
-	vend = ALIGN(vend, PMD_SIZE);
-	for (; vstart < vend; vstart += PMD_SIZE) {
-		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
-		unsigned long pte;
-		p4d_t *p4d;
-		pud_t *pud;
-		pmd_t *pmd;
-
-		if (!pgd)
-			return -ENOMEM;
-
-		p4d = vmemmap_p4d_populate(pgd, vstart, node);
-		if (!p4d)
-			return -ENOMEM;
-
-		pud = vmemmap_pud_populate(p4d, vstart, node);
-		if (!pud)
-			return -ENOMEM;
+	pmd_val(*pmd) = pte_base | __pa(p);
+}
 
-		pmd = pmd_offset(pud, vstart);
-		pte = pmd_val(*pmd);
-		if (!(pte & _PAGE_VALID)) {
-			void *block = vmemmap_alloc_block(PMD_SIZE, node);
+int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
+				unsigned long addr, unsigned long next)
+{
+	int large = pmd_leaf(*pmdp);
 
-			if (!block)
-				return -ENOMEM;
+	if (large)
+		vmemmap_verify((pte_t *)pmdp, node, addr, next);
 
-			pmd_val(*pmd) = pte_base | __pa(block);
-		}
-	}
+	return large;
+}
 
-	return 0;
+int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
+			       int node, struct vmem_altmap *altmap)
+{
+	return vmemmap_populate_hugepages(vstart, vend, node, altmap);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
-- 
2.50.1 (Apple Git-155)


