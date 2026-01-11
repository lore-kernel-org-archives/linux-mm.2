Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C2BD2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 07:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D180A6B008A; Sun, 11 Jan 2026 02:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6156B008C; Sun, 11 Jan 2026 02:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4A96B0092; Sun, 11 Jan 2026 02:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA6676B008A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 02:45:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F7161B589
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:45:23 +0000 (UTC)
X-FDA: 84318897726.21.FC04A00
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 624B9C0002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:45:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iPFbCbDg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768117521; a=rsa-sha256;
	cv=none;
	b=N3bD+YrA3Mr1X/BuF9jrk2xJVGz9b18E9PcVlbOTa/I8pe2SkucV+BAWIqP87jStqU9815
	rpECpvu6L03JrJFIkeMEdG5asyem/Pnl4xr1iLBiKIU0Jrnhz5WsfxVldd8hzwxLXwCrgG
	5q5syQeAfQ1KXiJ9aFWaD8LdC6thSKA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iPFbCbDg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768117521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3W1VRgdJWZtP/35+X4BFxHc1/Q/0kqoYu2dyr3n8ICY=;
	b=R3hLK3wLsRGq1qVs4JcPlyHMNVkab8Ga7ZzYS1SFkMY1SMTmAQF4TViXgPd4i/2SSukmnM
	z5cGP65T1EABrM6zoB9HLJ7nBHDeol4lAOV73i69ZYD6NadiQ/VIftBP5TF8G/h6spUaPZ
	0yR3ByCReIzXG1BSIYTdSeVE+ubHfkg=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a09a3bd9c5so37915515ad.3
        for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768117520; x=1768722320; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3W1VRgdJWZtP/35+X4BFxHc1/Q/0kqoYu2dyr3n8ICY=;
        b=iPFbCbDg+mWUK+HcPTTfhfHjXqByA+3V8y1qUWfeZpTbaDnD36lNIkG80cY84Tt13c
         SKdXJ3nCPYthlIOAL6G6z0iI0Uu9WwlA7pmqgWjX7CoV6hMt63h8t4ya77M7NaAZAwTS
         qnid6tHViAZAHdslFkRV/kaPCqdaJxx6UKKV5PNLEoQt+lvGZHlrRR2f8W5a8nobW2Hq
         S/EWb/kTPrhDseMpo7v9q+V9tzKW+nxhukhxKyUpQf2JjVfMHIYKeenjx80sctd9g2aQ
         eO+metx6or2P5AGOpt82c8W3VFaKgS7uK8lKUXErRPigYnmwiawSrd0DMG0j4yt2HXc5
         hSzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768117520; x=1768722320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3W1VRgdJWZtP/35+X4BFxHc1/Q/0kqoYu2dyr3n8ICY=;
        b=sbeQjg4M2/2P3PVxDcNPFuZLeaf76+qkQErHGlpWOJ4KegRSdgsVVA9N+x7t4QUOL9
         EBPW9yRgl/X+X39ivAEqkuuhQ7RhPFupEZV248O8gVWMCqxzgpENCIMFdDK/pkcKxcIW
         999pPaK9qCgEEAOK58b5+RV3Po4iAZEEu/iDsUDjDGdpSesCemIpFnB7nUPVitLCO1Nm
         jviXfymvS1QQ9MH0Pw7KVT6G11Kl8c0ZN7UGhv5mv1F6EiQ3zgPvRLpyL6j5LOZ+Y7I9
         V0RfT3nc30JWoyPtPuXcBpehSaM2N5ebghQ2WlOVVwJhLptOV9hrRxj3yTFcb5XXS8bj
         +ZOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF1EZIiLH+lv/NESXTtAAmL5VXsP+HSL7j0uu4ZSQva7NmdRuSBiqDiXo5eDWYzJ7GlzdGZdWFgw==@kvack.org
X-Gm-Message-State: AOJu0YwCp81v6Jzc2Jcyh6Dv+/Kl3UKID5Yyi09RfrxchGLqMZBIFY1H
	mHOfuNqab/SEGz6dBXPx+Y470R2CUJn90TbpQhcWmArx+yd5UUK+xca9
X-Gm-Gg: AY/fxX7XsOkhViIa7xcVXKHpkbkBiBwrHCaePyiaqK5Z6teVR/SiT+1uRKDL4wkqhxf
	Ih582xCgU1Uqkup+RDQ6AEYWagIX3vYS1F79S1LYqYlb/NXez3IS2m1sU4yQhwQ/lm6v+vi0OIv
	3Jzcjkct4VqlAQYh8HSDxq5gTHJX3kQKXza5ULHNRD5MkIPopBzt+RMh02RlDMkIOMpyk7N3g3/
	G6j1ULvaLTHZTR2EhlNEG4S5SPV2HWIJi2OJxV+pBjQUbaRV7M/xFLZ0e/IAaOsBwC4TT/0tzhV
	pHQyxF4W0PGCdXpUPfz5XyPItSCzfmIvS5NRt8GPUNbddeNq46mQZlB70tbKMNE3upglCvE/XiS
	yEEPWsIxxIb2aqpGUnGClynp5Xioje4tse74MjdfXN1ShwMf6BUqCQTJ4W+Rp8ljf6TJ86WNXfA
	HdbuyQ8IGVCcPtqot+Y/5I9RoQBcFEow7FesILGaal
X-Google-Smtp-Source: AGHT+IFOxUt1YWvqb3kir1Ky7DSpkYbp7DHua/UbMFooiLjcrZeFDAph0g0fbWDK+tgumDDxk8azBQ==
X-Received: by 2002:a17:903:2348:b0:2a0:d431:930 with SMTP id d9443c01a7336-2a3ee4b244dmr150938675ad.47.1768117520166;
        Sat, 10 Jan 2026 23:45:20 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2f8asm145284015ad.57.2026.01.10.23.45.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Jan 2026 23:45:19 -0800 (PST)
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
Subject: [PATCH v5 2/2] mm: Convert vmemmap_p?d_populate() to static functions
Date: Sun, 11 Jan 2026 15:44:53 +0800
Message-ID: <20260111074453.66728-3-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260111074453.66728-1-pilgrimtao@gmail.com>
References: <20260111074453.66728-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j1s8z9zxbf96yd4k8o83bayh4jrjp6ap
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 624B9C0002
X-HE-Tag: 1768117521-284600
X-HE-Meta: U2FsdGVkX18uq/zH6Q1QiS7Fslv8616XLELSOjVvZaPsfp9247HZVjATj4+HOMJ6PCl02+HEMTJqpAmqKSkoxraRSKIPD3XMfsvt4mIAIGAOKaY4VRAxVjynxkSMqLZF3em3BUzr39sPyO3YRZ56FPnOdTxqMMSSIEUNiIe2Cm1SWrx7rZ5+L2WdknGNb6SJu4thwVCsj6/W/efuyd5u8iemNnzuUZZ8anOQROsLvpBukt+XQMIivxe9WcqRYIlnf/fpqoLTXbv/X+QOudOTunFLy1Zw6g2+BrkMhsawabAQPHnaW05qWRWFS6yV9jn5biLdPmVjlDRQIS15csyMSKnvjm5acGziAmjR3svGVBv16tzDaQrbcoGzY9ib9QDJDXoLdwFMrbJU6o3DWlQ3+wHaq363Rq3V3qlPNdobN8eFHYhps1/LvKxZVGK0zpJT2C/N3GP1iFZwF42uJglnI1kpldNG4qzrHElo8vykhsG2sNFvQQfp7Xy31jPvZFodR67Ww3sQ3x6ypOtPS2NmdKIxnmU1R7HcHomFLqpDuiLsLCZqwp2pbMaJy/01QO/hi+AvvzZkPczGT7ZrPj2yc5l+jb3+M/5TtQbw4mEVDT+ogUEzer+8kzdwsJR+YX+ivBFFhmhH6HQSHaByr2wk8R58wniolw97hsiDXJtJuAPlVUof/v2nyb2kaT1UUaltkzc4lqR6wFCQ1yecVitG+PC5QchxBR6Vd2dk8HRbbC8NBM2K/K0h2i3ujawSS0VddKdXFbN5F2d2HIT9krpRQF0NGFHbndk17uH0SS+ulMEhZP8wXnwvExjbuxqPuN4Uv1UM/k0lk4MgJcGE30r7NlJBfXzGyt1tPyQHqwwl9sbDQ6FhDYRjxHsWhJeB+NDe7nmuk6xH4dASLtuJ5/t9g3/PC1pFHP7VTZTm9uzRWX87R6XRkakyafieFYm6S53cStcS5p33p7WMc+TluBm
 nmEtrhJs
 V5mKA//XgNL9UVzDta7gGsXy1vceeHqV1zPb+cfifK8ZDtJWIIQ4pAT0028Q0QUws4zpKvSejLC+G4wzIZ102YhtLCCCr51j4IHI74h6LADbEfsz0HPZZi6wOuQxmsETfQAUy3bmgD0plwv6OqnHoSRswvoCaIAs/DHJzrKbOhc0TXWVsHrTHgQE5RYXaTx7f26Dm9R8Po6Lxy0DRUx3ohn1BUmydGOBPYitCB/0EqgTVKQVB1X0Itk836+BNxcjywTbHpjxT2jlxF5d7whvl0jsQTTfVi58Q4HWeAl1bKsPXtmKhAk5/rhELQIbDPFGCVCevHrI2gsB86zwuni/PW+04cYDmn1XGXe2rzOAFO94PBrfcI065GHYnvGEoiBlyVhjKkF0UaDe6yNw2uvjkN8D7CcDxAIprffta3WDJR9hsA1Qbb+XhORqTQHKsef1tgGtVRyYIBmqm2d4PRSimntCkIRdMBKWLsrBLoOs50IUmAPbOIh2s/l1ddhY7+Hzc/TUqEqT2pEsMFL4U+m435MHKPOpa6CRDdBGoWSHpG3DCDew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

Since the vmemmap_p?d_populate functions are unused outside the mm
subsystem, we can remove their external declarations and convert
them to static functions.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h  |  7 -------
 mm/sparse-vmemmap.c | 10 +++++-----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..322fe72b6ebd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4234,13 +4234,6 @@ unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
-pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
-p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
-pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
-pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
-pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap, unsigned long ptpfn,
-			    unsigned long flags);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 37522d6cb398..67f9a08c2376 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -151,7 +151,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
+static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
 {
@@ -195,7 +195,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 	return p;
 }
 
-pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
+static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
@@ -208,7 +208,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 	return pmd;
 }
 
-pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
+static pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 {
 	pud_t *pud = pud_offset(p4d, addr);
 	if (pud_none(*pud)) {
@@ -221,7 +221,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 	return pud;
 }
 
-p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
+static p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d)) {
@@ -234,7 +234,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 	return p4d;
 }
 
-pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
+static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd)) {
-- 
2.50.1 (Apple Git-155)


