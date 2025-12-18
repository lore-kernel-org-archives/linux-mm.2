Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79ABCD6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B866B0088; Thu, 18 Dec 2025 08:10:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8746B0089; Thu, 18 Dec 2025 08:10:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA706B008A; Thu, 18 Dec 2025 08:10:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BCB7B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:10:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C3D854FD4
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:10:11 +0000 (UTC)
X-FDA: 84232625022.24.B25DE17
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8D46220019
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:10:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TfBrKNK5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063409; a=rsa-sha256;
	cv=none;
	b=4qvLBhNxvynEDTCrQI+OJAVhRJcbVXMrKh3lAEMwGhY2/vU3+4OJ7DxE6oK5yPEHbtrJiR
	36C7Hme/3UUX3uag+jI5o+GIJsTSk3t3bYVsptGrAes1dhvtlJ1z4arnwWhYTG5W6wluAL
	7s2qucdnP19uK9v/pkoEOqPJ/BMP70Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TfBrKNK5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=G3TCENr0pwf1AEzmfzATzYgD/ncjqU5Y+gUYLbJJ/50=;
	b=Gsd+epshyJ4lwK4bv3cnr/oAJTZblM3b3SaTOueS1offe/eSBm1+XWXi3KdRmPv9IOGqWd
	d5x+KmwnD0WUrcZpZHLOm4AphhSaSydNvxTf2HgewKvIEWAzzvOaXfR9HhG201VpPt9sbQ
	hIkEkIxQcvuZEWCTyI2Hl42llFqbhwU=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0b4320665so8737385ad.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766063408; x=1766668208; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G3TCENr0pwf1AEzmfzATzYgD/ncjqU5Y+gUYLbJJ/50=;
        b=TfBrKNK5NjB+AZ5IhnhrBsiKye3XlCu2YRAeXGn+BU4pEQnS5QgfJ3EzRdnE0Atgqo
         A+6kpux0+BG7JNVYKqd6hWfYmnHqvQ+YpNQ7fkTSjhtY+Ml8Xc6uVn2cIqKMq0VDToP0
         mDrQmGelDWmDmiFQT3dAWqD1QxsMNWuRwd0Wh7t+hs62/Ihr/ydphWXRHsNnHc2/7xRE
         jsV9MSCRwlrWRmvp5w42iOrMAiuCu780jvb9qtcgxzWQGu3JtkYFkHjqs+1o40AE0qRc
         0ZB0Hq41HUNM2JzSeZn8ic/8pJ7AuRs+b4UXvYhOXBXOJD5uxei8m/aaUPIL6bTqXxHB
         SK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766063408; x=1766668208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3TCENr0pwf1AEzmfzATzYgD/ncjqU5Y+gUYLbJJ/50=;
        b=L30v0MHmRQfY0Icj/RxPUAXWNLr0E2kclFTBPOHL2HRBlXAVQjVgcj+RffyDA/Kh/a
         nCS4K3CKiRZ/OTLtTtJxl9DXzxJ73ZFc3Luoe2y0eUSqlzqfpsFigTP1W/QvDWjwCKJ0
         VWuqeSDS5/LcPad0QCOmajeRH1qxAuJtK7da9hd8NEf9zW+gL/IWdwRmfM2IrPNl6V/s
         vfIZ539+eWUKWQLQywQcDn9zMP1fKpZNAEEMLY2xyMe8ik+sgfR5N17Cn39jsQ+aJ54N
         iGYB4KyWG4sSQRQ2zTXFIvFXA22C+l9nzLAHZrhlBM68js8vBf1+T//hv6Z2yCmLyRPM
         fn3A==
X-Forwarded-Encrypted: i=1; AJvYcCWFgU1lMuc2U16IgRw7rIkNS/2N52hjOq50w0vlBjWIePb6Trczm88KSeRGisz/qZUSAh2fR6LdnQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8KA4IWCMJNrOCjdNS/G5NIHceS6OwmQ6hfVC+r8PX7Rgin1bL
	+am73xwNRADx7uhayp3Xt7SDEH44E3toQJLbqtllVuWxQ20my8xJsOst
X-Gm-Gg: AY/fxX6p+wy1jtsvHQxVZGtUkUbB7hrkmOp1gKPl9l8gZkv51q0I3U2r2RjMEEqVYtT
	9ylDkUXUk1EkM/KPRpBgixNs8uMj1usWcm1TgYYiDjouvnNr37TEs+2J/oc+NFqUtR90FGCyToZ
	dWEBUrDNHoKhLBJyJIPg/XQgI5Cw64XXnz/SRE9mEI2J2+I5USGDSCGF4/4SF5gjirZlyxf/7pJ
	p7YHbNA1aRvpObWgTMgYPLcll49ojrHytcPoojR9C8jIdit9EMsEaT4flJzNoJiJM8KVQqwsgyG
	rew23R9n9qkTLJbzjy9szhHpO540bXEDTerMuuQLcxBLtAZ0EMIgaGNK/E5Bvykh0KHBA9Ap9GP
	jvfL9oQWNmZ+g8Z32lnX1B1ZnCRPSMfvQ0MtSd7nqXTdknJkzike55twFrmECqMbH3SY4ZEc2f5
	IJXxKgXyqnyaerzSNRTxoAFFAUnC/do+arX9pMUY/e9w==
X-Google-Smtp-Source: AGHT+IFaf6sCWgD75/ILIq3bALtZPi+pj1h/4krEFrOW2ZcgvzVOSmifnnbQZGCeJL5QUhBwf7aNiQ==
X-Received: by 2002:a17:903:46c7:b0:2a0:8966:7c9a with SMTP id d9443c01a7336-2a0896681ecmr172355385ad.58.1766063408168;
        Thu, 18 Dec 2025 05:10:08 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.152])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d089cf0bsm25475205ad.40.2025.12.18.05.10.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Dec 2025 05:10:07 -0800 (PST)
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
Subject: [PATCH v2] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
Date: Thu, 18 Dec 2025 21:09:57 +0800
Message-ID: <20251218130957.36892-1-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D46220019
X-Rspamd-Server: rspam03
X-Stat-Signature: 47pssx1nwq88m73srd6srwdet53ngke7
X-Rspam-User: 
X-HE-Tag: 1766063409-398859
X-HE-Meta: U2FsdGVkX1+Td7nxkQ81BlpNZZkKhOzwLvCTRMfKsjNM5auGYeJ9sJEmrCr/XYnFySaAIjmUoLH6qrOFgd7MzBmYbNcFZxkHZPlxvEEGJWkb37kQG41JBwKntfwL6vZXqMYUepJE7oU8pkrMJXUcMMJy7p8vtAcfbEgcs1QVXENmOlaU6x19XuyMnDCGzJplRMt+BM3b98x0dRzaK5lSgoAcZgm9huZZxiyKf2Lhau6fWAhh6/Q6p05fKguse5QL6i2REZPdtlaI5tarlJZEdlRn5MJXgaI9cH/lx77IOOoiemhL5GpaTqFMGv4EGVDxgaxxxTJi6nDJ5hN21QlAcp4LCi9zqhA9uZiD0BWbL52ILhXP8D5njpcsIm6KqlOhPIkBW3SjSCsNPXvf7dgbh9Vca4DtYFW1m+eWx0Je727dQTLdVrGwEheuYiTGj+z3sVG1ie8lpD/izxwUxE5e3lGigqiI/kAJdkJP/kwNFd40mGFi+0M/JQU97mVPvDC3lxRjpA85ZhNJtEmEjxON/VMEx1UzHGuX66IhpnKdPktYBOS7jOmf1p0MfvqZfYhDVZxMhjtecVpUBUOX4VKxA1yyaioy3XnPniVHj2hKwxZ+QyUlfsjZaJg2o5tQMO5UI41NtHpvH8wrbPHpFndCL9pusQCX7nImp2ZpyDWbGx7XmslEXdTZbb9n0z/rRSt4YMq/C1e2T4pw9HZkCguOkugNi1JLbLDgRLBf0MxtJ9vfr11W9FHQgzlom4m2BQGbeeQ+7cmjAwZ3Zja6xBxPiyT3TLmbwiOQcA2xrx7spX/2KrkPqrHakT+gqE0oi+wWspMDpSKsdeC5CZDSIkMYNjsttFt1vx3COpjRFBVrTlMqWneAY/GrSiVdZgrM7rKJO0Hr/6JrAVUJDPjK36A3Dfd013KUCDj/9tUQbwKCr3nWVfKpREDAYIiIWET/9WBB1WbwTqinG5L4RK+33HU
 l3eAcTgc
 bsVwFhaA++31RvGvT9NG5ttU4BK0nKbe/77yf2ym8ODKA4YscuA5cSjyi4GFurBEBCIcVD1NhCe1RPWBJSe2kH5bF0p/tlyopgpILSQzl6WKxYHr2yqoWnfqZ+gpl7+cnjZKg3zuUsqOl9cHDFxqfcZeojvrPfnPEqiklmwo2e1m+/0h2KzEJIyf7XXBGF3xpU85V+4B9E1nQ9DdJXJBnTkL31aBWeYQCRNAVbpy9pjXwUVNc1be7xI6BcovrUoGzA40Ke43k26awCh1GrkZFmWPV18E+fMoWVgRuxPKh/aFgsccu2Wvh1Mgvr4zodX8gQ4Q7tS5YuQ/+vTBnCLTtRsomL2mhWhXT9GDXCdA7yjIqMoxRkYL53WJu/poLem3jClB+yWGhqC0W4HKXs5O8ac5AUmZ/5bTV4bGZu+dpHuwcyU2A022U5WMarWDSbGz1735QS2YTDJb/mVXEyMXCe9e2wmXXjG3w9QDoQYm+WyTma0yw5CiL5piK9IZvx9DWlmwm1GXdOl9qTY4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

1. Added the vmemmap_false_pmd function to accommodate architectures
that do not support basepages.
2. In the SPARC architecture, reimplemented vmemmap_populate using
vmemmap_populate_hugepages.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
---
v2:
1. Revert the whitespace deletions
2. Change vmemmap_false_pmd to vmemmap_pte_fallback_allowed

Link to V1:
https://lore.kernel.org/all/20251217120858.18713-1-pilgrimtao@gmail.com/

 arch/sparc/mm/init_64.c | 50 +++++++++++++++--------------------------
 include/linux/mm.h      |  1 +
 mm/sparse-vmemmap.c     |  7 +++++-
 3 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index df9f7c444c39..86b11150e701 100644
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
 
@@ -2595,39 +2595,25 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 
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
-
-		pmd = pmd_offset(pud, vstart);
-		pte = pmd_val(*pmd);
-		if (!(pte & _PAGE_VALID)) {
-			void *block = vmemmap_alloc_block(PMD_SIZE, node);
+	pmd_val(*pmd) = pte_base | __pa(p);
+}
 
-			if (!block)
-				return -ENOMEM;
+bool __meminit vmemmap_pte_fallback_allowed(void)
+{
+	return false;
+}
 
-			pmd_val(*pmd) = pte_base | __pa(block);
-		}
-	}
+int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
+				unsigned long addr, unsigned long next)
+{
+	vmemmap_verify((pte_t *)pmdp, node, addr, next);
+	return 1;
+}
 
-	return 0;
+int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
+			       int node, struct vmem_altmap *altmap)
+{
+	return vmemmap_populate_hugepages(vstart, vend, node, altmap);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..ca159b029a5d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4248,6 +4248,7 @@ void *vmemmap_alloc_block_buf(unsigned long size, int node,
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 		     unsigned long addr, unsigned long next);
+bool vmemmap_pte_fallback_allowed(void);
 int vmemmap_check_pmd(pmd_t *pmd, int node,
 		      unsigned long addr, unsigned long next);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 37522d6cb398..45eb38048949 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -407,6 +407,11 @@ void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 {
 }
 
+bool __weak __meminit vmemmap_pte_fallback_allowed(void)
+{
+	return true;
+}
+
 int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 				       unsigned long addr, unsigned long next)
 {
@@ -446,7 +451,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			if (p) {
 				vmemmap_set_pmd(pmd, p, node, addr, next);
 				continue;
-			} else if (altmap) {
+			} else if (altmap || !vmemmap_pte_fallback_allowed()) {
 				/*
 				 * No fallback: In any case we care about, the
 				 * altmap should be reasonably sized and aligned
-- 
2.50.1 (Apple Git-155)


