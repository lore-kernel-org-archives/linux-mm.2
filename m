Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B66C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8716B0146; Thu, 16 Jul 2026 11:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C71BC6B0149; Thu, 16 Jul 2026 11:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61116B0148; Thu, 16 Jul 2026 11:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 886CB6B0145
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:12:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B1551A0153
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:17 +0000 (UTC)
X-FDA: 84994607754.29.46017B4
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0B3A2C0002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ETS84PG4;
	spf=pass (imf10.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqzuyyB7zI40Qj8rdd4/j/Hz77YcBH2L+r/0EHWbI6M=;
	b=M6KpDz945/JJ88VUykYEYVxx0XJWu3TwgNsVA3uDZzxzR0MR4T1XNdgUFsqQ98vwwdH2dp
	gFQrx0xT/ylskgaWHAgnFhnpanVhoBbh4/BXnXu6KAvE8FbNf5jgDiwQ6Ec0q9V2Zl8PfO
	k2Ca0a5b1P3u1QscXn1CWfQ8QmuRyRY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ETS84PG4;
	spf=pass (imf10.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205855;
	b=BXPfhKi6eGT4ADAnY3jJlNj7+aRpEdVbRiX38WNbkNlAz+YOxvTYCr2msx4q3mE/eQFQMO
	9med8iQRGqXl3cgTyIDU3mneZ8BMw4RQzqajIRW6i/VbDJIceZwdMHpl2Bu6OfXJ6S2Kun
	K4kJQR9zPj50gqbeJ777nqCLcQMu2Dw=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8423f236418so2681232b3a.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205854; x=1784810654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZqzuyyB7zI40Qj8rdd4/j/Hz77YcBH2L+r/0EHWbI6M=;
        b=ETS84PG4u/FD4Aq3LnvlGy9FtDvtYgvDG9MyLKM4S9lnZqD3SaA48+6siBYgndP7GQ
         2RaTYQIaWMcpN1ZFm0PRMoWKVd+Dp1/9W46Jw0F9IVx6SIWQA5pxSHN8izZMr4J8z1C3
         prZGgmapn0GeU7gbwCtt8sTAPjVnTWtUOJZcs1XYLZ6+dJ/J0pDGwHqGAc1KAqcOicxh
         iDJIosroEYPwN/Pr7JtuUmSTOM1oZSFSFQq383Wr4UPkpiZUc05zNL4mrUHR96K0IbPj
         dp3suyjl5DkEITysmXzfc+fs8ansc/7jZhikSpY+Px+/5+uHa27RYHi8Z5oaQTZb8bYn
         C5kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205854; x=1784810654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZqzuyyB7zI40Qj8rdd4/j/Hz77YcBH2L+r/0EHWbI6M=;
        b=FHZ4VPcNQsdfRUVc+aKAoWJMD/DVHeLPT5Wzk+SgFUQrSQftUsDyv65Qwu9deLbCmN
         ho4p6a/4aqrexjRkCwd47E457Y3uNPEYhKiEnUT3Hm/hyasL/2gGZX1LfvecjLK0IlcZ
         tiFPA8nqZRkFpY3hE+pIIJ7gee3x6Y4z8fbTrmerqlbmybeCOJ8zJ/WMro0YMHZRqiq4
         3Zyo0qrJyBtO5KZCPnkFXhAN0HEzXmYdrW5wcUg1t5Pj+3Ox8ENmQK+e6JJDa2IMuQx3
         rxvGwUkAEYyJ+oqedERZxbh8wVZs36J9pgtwODR2tSTqgWACoram7WfJXija96T5k28R
         w9OA==
X-Forwarded-Encrypted: i=1; AHgh+Rpiurn6PK6bkDbJt13Kf7ORQghDKgmt6ghuV0htY8nSrF9WNRpvVZreVimI5XOOmmZdG8uyHz++gA==@kvack.org
X-Gm-Message-State: AOJu0YytEhMIGH8udv0udwnvQwmRnRKO6qC0nI0bcN4lFQQpRA9sLn6Y
	gp0ob3r9UIrEmqPnS/5mQsmduW43STVzXPTyoWrZ06+pvSDWMnXx6TkTsLHuJcOVYvM=
X-Gm-Gg: AfdE7clNp3RO3SJdyKiwBWvB4AIGuIGEJuRcsvRM3PVCcqRM/q9IwVC82zU3mAYt+Hj
	Uis7vmt4f4BkVUgE1O0itjx5sHnP2uM4anmuPL7te8UZxhsNXkojLhUYLxAQJjodYLVF/UD1jDQ
	Y7qaE8hzyEBqBsjic8IxLwsbAVvzgEw6W79toA/taJ/mizq51Xu8OD6Sv4bSO3XrYwzTsNJXVC5
	cqVg2ClraImOD5YifL5reNwiINAe6MKm0DT3yFK+YBjgJtHxEEo+PcX3arBStuQb36j1lGcjq7U
	jqE5Fyl4Km9j8R6Tg6MEBAS98t77UDXdj6sOUWEcTl2TNJzaO+mTrqJ6EncBZfFW7Yt89VrAgqY
	9SLv/KOUqGrm0eKRP8NSDJbflH3HUQSB0Gc7gWd5dnq88m9jgFtfAX5wsSmbXz6K9+1h43AOsT4
	k9eYIc+VBUi8P34Qhc5mg2SIQ=
X-Received: by 2002:a05:6a00:21d2:b0:845:c6fc:2821 with SMTP id d2e1a72fcca58-84889604f51mr19555102b3a.22.1784205853705;
        Thu, 16 Jul 2026 05:44:13 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.44.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:44:12 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 10/15] mm/gup: add fast-GUP specific lockless PTE helpers
Date: Thu, 16 Jul 2026 20:41:45 +0800
Message-Id: <138d74aa9863ae8ff445e16a2798d062895b75bc.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B3A2C0002
X-Stat-Signature: xpstutmdncckme5fpuw4xpox5mzysseb
X-HE-Tag: 1784205854-65639
X-HE-Meta: U2FsdGVkX18U4wdRGfYGJ2oqNekYEdHbi4nYzRDZyrGTR3oQnrRmjV/bSFGAs4m/OrtO/06P1n8qABNvtxVmy0QDa5USOSxRrASr/CIDsfq4xMqrjxF50o1ujSwQLyQxfEHyW4LJst4Bzsx2wcYIJ6XIBSiuKUp+ioHuRUt9K5OSmH5MijcEqrRjkuw6Fx3EQKT7FKg3ZdPnGojVwgKOQsvM9Qqb7CswSBm5QVNV5K0P5ecDL/5FBgxuoneLfn3oshsJ+Ut+AMEbRU2K4jN1/lIoIiOoOOKc+ZT/4uSP/gay/Y6rFXUGcFuNQqPkm7omdC2zCqNEMsxWQwYYy2f2+ISzLvSGx0Lqtw03Rc8xbGnFcC/FbSn08qP0dCGjcJJQLOhxBu/h/uN2EQcIDRj5rYd+Kc3T3k4aIfSAxNp9DiNOt5isa+MThVROTx97Rny58mNx9sGrAImVWOBdVk2eIUnkH2NkHwu05A6G7QoKld8ZD3mFWqECdAMkqmiAzkwGEIPXjQeq+ENNuKfct/IH6LzBwwVgyJwpzQTatAain+8BbiEAROCbuUXEeCgOlN3RAn8d23Qp1aSPrknoHm/khrNYo50wwKEY0zBU8YIpRcpoJE8Zi+7VzxJI+rXjr0mursaxvfu3kjXdg9DdkEGZbeJqizTxxFVWajK/y7xszE+/Yf9Qof9FjdFBccCKFxNdWXBhx6rD/Ar/cI/cyBAPlnWNjTV4yBreqb73F83hNQKDdWF52mLKZbvNZz2b5NKCcKSqLP2C5iCSNUP1mHVcLLeqIls1EQ/4O3hyhoLsMN+6VZ5B5QUTlEN82mYY30kG/GQXsdsgs3+ptqwoSbeKz5ZLLSxy18PcfFlc4tRbVB3vzUNocQsPMGKX6/BZlr87UWk5u+TCgXJ2tkWWgIZPKU2wuC6pXnOdzaw+cPrOQwkPiiCL/Vj2xMntwTBuY0olSDbMFwFXjPJgprH/Z38
 3wFnSqzA
 j0+NuBMdy9hdf1j5cT8W/ZO5j5bPrx+S2gFLnmq4YjItWTS/UqxAs7BmhSj49cpbyn6k+aadnQ0Rj7pAs+YLbmt285sToBsjXLUtR9t82f0O8XiTMxTsV/2sU0Xcal5QwiNp/F56/aKb+huHdZxrFdenCe0DXdMsCir2Rgo2HWx7FbZt8jaY3In+I/A27J4F0Q20kn2pCsjUNx4nGXEWBqb3dA4aYtFd7yVaFTuAqMhGC1Q+d/6pBJSs6LgwxShzuorItL8Css55Vim3jsQqqIcgAiuPcm4X+OzJicXqUvNaKkpuE8hdpUfzl817Eq5f0IPFG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fast-GUP snapshots a PTE without holding the PTL, pins the page, and
then revalidates that the PTE did not change. Keep both reads under the
same lockless PTE semantics by defaulting the fast-GUP revalidation to
ptep_get_lockless().

Introduce fast-GUP specific PTE snapshot and revalidation helpers. The
default implementation preserves the existing ptep_get_lockless()
semantics, while allowing architectures to override the helpers when the
public lockless getter provides extra semantics that fast-GUP does not
consume.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 include/linux/pgtable.h | 18 ++++++++++++++++++
 mm/gup.c                |  6 ++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index da14328093a86..62943fcbf7046 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -813,6 +813,24 @@ static inline pte_t ptep_get_lockless(pte_t *ptep)
 }
 #endif
 
+#ifndef gup_ptep_get_lockless
+static inline pte_t gup_ptep_get_lockless(pte_t *ptep, pte_t *rawp)
+{
+	pte_t pte = ptep_get_lockless(ptep);
+
+	*rawp = pte;
+
+	return pte;
+}
+#endif
+
+#ifndef gup_ptep_revalidate
+static inline bool gup_ptep_revalidate(pte_t *ptep, pte_t raw_pte)
+{
+	return pte_val(raw_pte) == pte_val(ptep_get_lockless(ptep));
+}
+#endif
+
 #ifndef pmdp_get_lockless
 static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 99902c15703b0..72fb147193e55 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2842,10 +2842,12 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 	if (!ptep)
 		return 0;
 	do {
-		pte_t pte = ptep_get_lockless(ptep);
+		pte_t raw_pte, pte;
 		struct page *page;
 		struct folio *folio;
 
+		pte = gup_ptep_get_lockless(ptep, &raw_pte);
+
 		/*
 		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
 		 * pte_access_permitted() better should reject these pages
@@ -2871,7 +2873,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 			goto pte_unmap;
 
 		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
-		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
+		    unlikely(!gup_ptep_revalidate(ptep, raw_pte))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-- 
2.39.5


