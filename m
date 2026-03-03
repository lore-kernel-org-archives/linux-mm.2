Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB3CEDEBEB
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C046A6B00A6; Tue,  3 Mar 2026 14:42:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6FD6B00A7; Tue,  3 Mar 2026 14:42:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB7A6B00A8; Tue,  3 Mar 2026 14:42:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99D306B00A6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:42:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 342EAB7EA0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:42:24 +0000 (UTC)
X-FDA: 84505773408.25.2BAB7B0
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A3E71C000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:42:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ewy3ljBd;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772566942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dOCB92VFaJvp1/msg1aXr5lsyHqZuKZRc8ptpqCWqZQ=;
	b=D85zWDvq51WDzPbC4vg1I9iupIBERnwhE5JhrNlE2127A61hFab258xb/dsg5B28cPsUnx
	SZjTmIm114q7eMi0e1oZTfQgwoF+A9EO1FJBJ2AxJYJFUxJa0xHJsxbKlkQaZ0v4//vrwH
	YdqQcLI1dE6/WCe+rKVcO6m6kVlk98A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772566942; a=rsa-sha256;
	cv=none;
	b=ZAhFtvkRCEssYlg/2zdcry6j3TfthHWJKajgaVH2ZWt60+9uIbLLbUckSAFr6+bO+uuwn1
	XUyq5mdGy+jiih+f3Nfo4uup++0OXcxBIrOLGPEM91sZaPTOugkCz/YtSXzYRjttH4cXPK
	vRyOTgXeH6iM3KMTBYI4uajKSyTgb1g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ewy3ljBd;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2be1b5fe11cso2234771eec.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772566941; x=1773171741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dOCB92VFaJvp1/msg1aXr5lsyHqZuKZRc8ptpqCWqZQ=;
        b=ewy3ljBdHkxzmWv6k5aRg/xOvHVFCB9vWAwWr09ierQu8Cbv6WZOkzuXvTe94YSSUs
         rdiU5plq223NZSZ64k4glHWWhNHs3P/xE1CpK1oxqPO+6U9laAuoIEJhaC/NcErqjxO/
         WKmHwAiQqujq24xxUnYXbNnOyY7j5vHZ/8i7IUi/Jw5vPdgF3Vk3mMjbY8PV+3Y7V67U
         8ihCoqUxAwYeW3Xm7Ge7tsBHztrg5kgKBM9m6duAC2tMQF+3qQfUeThpmVaLicxlPb8k
         +usN1sYbgj3wgUZBBDqFTF7TByozW3zTORujqZhhCKg9/aWOm2sZsQFzriNDZUvfzerb
         KXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566941; x=1773171741;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOCB92VFaJvp1/msg1aXr5lsyHqZuKZRc8ptpqCWqZQ=;
        b=o3SkB7ksfLdy9GBoHi2pPOu808K8f/mOAZ2XNdL9Tc01CtXW1CKBFE5rnDaBwP7lTy
         1ZZ8/WqQUDrMgHsy1L+8MBiLRtvPX1Pl5hp+qgXOQfAu0rA/fQEABcq5Psb11cNGWarD
         0ZoJF/SaLxfpaVmrW+W0bdwInoFsxrvgNh/PQMe8Qkw8H6N5Ww9BVJlcYu1KUmYiyiCE
         SVRouQbGSXPnrFMPo2boN5SSe0MidzB+UmwehecCBdm0mzB2N1pxwHIdbxowslSrjDoN
         D4J90UUTY49ao0XAeNrOlEOoAno42KiS4FxgBmZi4EeCnnB1zGnvTBL2pd/42ojaIGNA
         MXGg==
X-Forwarded-Encrypted: i=1; AJvYcCWI+jd8x6eA1Cuyu83zcpH967DT5VoNZLNBdvJgyk+y9wdvtkkxrt7xgsThLtHHSNu5AXnn/SlrZA==@kvack.org
X-Gm-Message-State: AOJu0Yxc1/RCdDzGW2YtHWFtok0KHgWkJx9cLHBIKIFHPWxywIDq+m7z
	rJ0n7FMaj1SXUJJfxxxqcJB1lSfID19jrZracNB4BGwxbb2g7mP90PKp
X-Gm-Gg: ATEYQzzEgcUmxW+6EBa6ypWT3kOXC+WRw4BJ12kQ3rV1rGFtEW/+0o9G0C6akXTJtXm
	t5uTPS8c/AECOtv6Tp8hIxtWP7SKPPh0qAxUp7LaaPvOLLN1kjuSruJ7VXxRQhoMA9HAGupFAP9
	YhijvlnDhsg+b0z4tCZLTYXX+2JPFCdwCK4uohA9unGfprx6WpgGUXKLZzR4acdsklXzhUXGZVd
	QiVH4YrGlgpUYx95vqL4tGWfe9RHX5d3/4r/dsWMQmzoqobLR/P48SbY7hqyi6JVhJZAbdeMSft
	1yvdvkqbQdIK+/EQ45xbxUf4KL51L7EZAHwEeqX4HvjbPmqn9ym2E4VtHWLNQ7Q15FoQJBzO5Xd
	/YeW/FeaDaXhFhuIcZddjGVPRgGDamUw76D34U34Ax/s2g/cOYWpg/vWRtSG7tIS1+/HBr3NWiJ
	Cwi5nHeXPVXYhuYKKmrFT/FXxLZTARABhR97xpDJNArq+jcP0zwwYJM4pXm9RuX4+bBv1K7Az57
	mlDeSFPS117y7M=
X-Received: by 2002:a05:7300:ec08:b0:2be:e4b:60bf with SMTP id 5a478bee46e88-2be0e4b633bmr3533687eec.10.1772566941268;
        Tue, 03 Mar 2026 11:42:21 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2be0d7e0d40sm6497690eec.12.2026.03.03.11.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:42:20 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v7 4/4] x86/mm/pat: Convert split_large_page() to use ptdescs
Date: Tue,  3 Mar 2026 11:42:09 -0800
Message-ID: <20260303194209.1406471-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A3E71C000C
X-Stat-Signature: ezbd5tyhi6rikzcuzt1b58q5hni85fso
X-HE-Tag: 1772566942-960998
X-HE-Meta: U2FsdGVkX19vtLXRJ+h4OKaM3M3lqVwQhnCITLB7gg3OEOrF4rXrsislYUv/CjTCCwxZZheiNXg/WhqS3p3jktGjU2zS+5BJnuKpSxwOhxcwhp+ntP6Qf71R292FaVTaOXVV5cCwDU5mRKPeBwufETv1sGM4LN5WDkkpyzeL3eQWulnKRXvtoorEpKA8CwopkVyxblzkVYmVIy+MCQJcl6C2CNrBXHXkV7OS/26w7xsXwTWnBbpB0U5+7tL+26HAdcdzcuBJXFslguz/BHukEY+W7eLO2+mHAgWqGhd2vaD3q8C9oAypbyc6zTp5FSNQZwm4iqf41QaHPN56qFKDUTVpPqw4+TDBzC4+3My1F6Yxo/w3duZ8W96baNYR6grvr2yS8kkTrG9u9VT6xw7EGamm+8oAIWjyW0bHfDuCVn/AgPCxzuqbudhEBc4RnvgYpwzJBQkVl2zH4XSaI0WlX/YhTE8Z8d0kW1lu2AMWM3gkS84im/cwuDyAcSVpsuguKQ7elgkst5/I+glBykzwssuJYE+05J3JSr4fLMh4kvMDlfDnBI1cgyT941bflRMeyP3h9jeKn6e8rGnGPr3h0bzoCIstDzZG7HeACGN6ipT3GL6xr6zAnX6I/GbyoA/dXO2OQdEjPOUxuJtpXo4uSVh1EAECLdpXLt/wDQChlCfDNeYPGfC1I+3hJya+/7QIsRQkFPcPZKxdZVthiqxog5Z4iD+RrIvwTXds6pr5wLr+il9VvugtVG3mloiUFVM3YJvn3BmFLH1LXptSk33XY+191p7X7iG8AZ2PWZusOhyf0kHRFFFPKJmliceGpi+cMOfmslmpyzBwUaJrgDSwfwD55k1/eAizvMvXJuORJI/oihzTJ72j1aq7ZUbqVLSwdmvMrOCl+J6gKiOTakXT9JnyYea7r3R70KQYEpXSt9Qt9MlrNUp0gNgdqKCRDr6k/Kd3gHuQMAwsMftd4v8
 SEc/cyd6
 MEooZfy0h70EdePmwexdRSZTO28qGcGenTCeIdUeQSMTg9hG5kJOaNwHUYGuo2lK+75PGadjYrVKlbLQIrxezrAGkK4YBr7kuQ1s3RB1NfVZDQoFbQ45Spgdc0dbnopL6g3eg3gFDYBfUQVxytcKDPy+s2R6h/PphA2mKMM1EP3eaqgbut+wP/7uTfFzby3EJD/LG6NPgf1jA4WexrZuzWcVrThDETcVlzV/EMHCHPwHkck6/siuTkDyzDVDAa/dMkG7I2CRxodL7frXYD3yd9K8z4wZAqsOKm1XV8gPrNq8UPCA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the ptdesc APIs for all page table allocation and free sites to
allow their separate allocation from struct page in the future.

Update split_large_page() to allocate a ptdesc instead of allocating a
page for use as a page table.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 17c1c28e3491..cba907c39718 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1119,9 +1119,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct page *base)
+		   struct ptdesc *ptdesc)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
+	struct page *base = ptdesc_page(ptdesc);
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned int i, level;
 	pgprot_t ref_prot;
@@ -1226,18 +1227,18 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct page *base;
+	struct ptdesc *ptdesc;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
-	if (!base)
+	if (!ptdesc)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, base))
-		__free_page(base);
+	if (__split_large_page(cpa, kpte, address, ptdesc))
+		pagetable_free(ptdesc);
 
 	return 0;
 }
-- 
2.53.0


