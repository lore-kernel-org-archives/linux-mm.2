Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E2CCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D8E6B009D; Thu, 18 Jun 2026 08:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D9E6B009E; Thu, 18 Jun 2026 08:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155B76B009F; Thu, 18 Jun 2026 08:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAF8D6B009D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:17:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF17716678F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:48:57 +0000 (UTC)
X-FDA: 84892559514.10.1204DC5
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id F312F1A000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:48:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JKeMgoSP;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1dRLXDGB+7SoOnTq/V4woPlttJ2dOjQf7giv2SAznzw=;
	b=5JgqvYha1957+YVHcqOl8WVRU1wkjm0fUFcHrsha7AdYJsC66XL2nICVfcgHIzw63Ii6Kr
	09mz1RLbIxhGdrE5EDxpi1ClyrTfEDCwTRdmTJvEcE0WtM3DjSagPohIrbb/m3eDhX9qCH
	fKEre3CtTpMwHbIEERSubIsQQ60KBxg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JKeMgoSP;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776136;
	b=D1MEjdfGnYtlKY5WkpoFfHNUfaIMiZlzmnr3lIznRbtMxS2hoeOrOtklmcK8MqkOaVu54u
	Ycnomhmo40FRmc6qozWTgHc91wDp+ejjtMgDr92KWHMGlk4JpNQquu7ukF2GCz3YPv5aO0
	OUiADEFanhrAkMTYc9b159ZYStpi3lQ=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-13721dfd471so1056300c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781776135; x=1782380935; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1dRLXDGB+7SoOnTq/V4woPlttJ2dOjQf7giv2SAznzw=;
        b=JKeMgoSPqODsZQ1FGIDWVhP956AUDcaGfdK4Pf8bk5UVzgKh9jfhQyUSOSJigSaeAQ
         mqj4h7lpKs9kQo92R6zpXuykC0ASk43ZYElbes+ufX9HV/skwF00wWPosFZVZd+pudxZ
         Zf+J8saIgmzn3UDqJ9S0fO1Kji9DfmjhGt3N0WQu+s20wE3LAAaSu/An77xIUEteR/G3
         QGXRKMy3pzhztSGsWdxm1AfnN4ojSpoKO1PmeNApyewcEB3ih2VfJckJiUUzMLuy8d2Y
         0iVpEiBCns/xQNerX8rG17tkhteX6eaoEeIJAPblUAyLpGPQuhY4Ov4fHBKaCan5oowB
         scbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781776135; x=1782380935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1dRLXDGB+7SoOnTq/V4woPlttJ2dOjQf7giv2SAznzw=;
        b=bkR0XXT8Gy8CXqqef/kD/7ocff3P3h/2bn9mjPA4HQ61U7RkWIn/z+LGtfKH5rUuFp
         wArtr4YDjg1c59s3KoPAziiNxfNqJZXqiI9Q5TgSfaFFNr8Qdgr+67+3wTk/II2DBXpi
         fFaIHvieCWzgrpeRFBcQ2kGSqa7S4W+iPDkuo8QbECstdTIKdJvukq/UyOj/Yxu1RHmN
         BJXtuFO/1/QvkiHAq4D60yOnA4dGtFZsQUEW++zNhA8pUo6m9u1zDCmetW+cuK+Fe60u
         MOcBlysMzC9wt8ne/HfzFrUs/TkGBTvCSzGq+A8NMdNiaMJveWvuqZNQoCRg0uuWKam9
         ZGFA==
X-Forwarded-Encrypted: i=1; AFNElJ9cvgf6LWcgvAW1dcXWceYC0Xc2vejNUO8a6XnIglwQenbQjHoBLi5Kc8nMNsdRO5w3pvsLu9+4Og==@kvack.org
X-Gm-Message-State: AOJu0YxNSwA7QB9EiqpAaXqjfOth8dDM3LW+doDNKvgd8ELFlhlaK/Pc
	FeByEyamqq98130L+u6/BpFpySU254VDX5TVZRdawJpidT8Kw0RQFbQL
X-Gm-Gg: Acq92OGmMZboecwxzGGJ+KMhhqUydT4qfZsZ1r0mxZUc0dwwKW5DJN0y+xtLX8/Yvm2
	zNjCcAw4BJQ4JT7D7oF+zauX5Xc7lEwNEUaXqiNpqhzjwhY6Ld5ZGV0avmUWUS5ldWh3w9pL9O3
	Mx3fe4Wo1d5QinI/FOezGqv0+v1D+dDKdJsnTZ3ny2nIDHeo0sMslFiMktOWqcLebu09OQA6gwi
	+4fewSTynjxd9WAzIV/4QgbdvUZnRvFU2ZeLheAR3n/I311dzS68M+SBl6x2m/Az72B8eqN0NSz
	NWvF6TfJkxWjOmg7H3VMBWdZHav1kiflkFGQUQ3qmehKDUqo/uw1d9Sdg9RmoCTKmShHbpCxAsR
	t0YcJT4HSXSmp+IAQt5ucqhL1KdGNrySp6BbfnsBnnn7o58c6C6QxbAaWYDWorzraM/t66fJ91Q
	CEYn0wZyC1QyAymaRhpXWPpQPb
X-Received: by 2002:a05:7022:ff44:b0:137:1ae1:bc0e with SMTP id a92af1059eb24-13997bc5980mr2010752c88.13.1781776134708;
        Thu, 18 Jun 2026 02:48:54 -0700 (PDT)
Received: from localhost.localdomain ([104.28.158.224])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b91a4c7sm18069971c88.8.2026.06.18.02.48.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 02:48:53 -0700 (PDT)
From: Wang Lian <lianux.mm@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: npache@redhat.com,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com
Subject: [RFC PATCH 2/6] mm/khugepaged: add damon_collapse_folio_range() for external callers
Date: Thu, 18 Jun 2026 17:48:34 +0800
Message-ID: <20260618094838.32805-3-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260618094838.32805-1-lianux.mm@gmail.com>
References: <20260618094838.32805-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F312F1A000C
X-Stat-Signature: 4or5yrfw8uzbj1uqizjbx1c8rremc11d
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781776135-282861
X-HE-Meta: U2FsdGVkX197BqY+o+B+1xKOCykT5/ffesTrlqXTdWuA0GdR7WKYT/pnYTRi5CrLLfUTHiMmkQnn/IZ+9Q6Krf/WpBiVrnIkdv7nsFtoJmDrO6FrmciSO4IYu0BzQ+o9I2TfmuduEWKFSJDEhJnNoD0VtmdM0Ma3begl1CV2Xw2YgK1lrzn54LssIbMFF7GtMPxyK9O0L1kHU/DxfgnnFuVPY60Itn1QnP9o7UOu+umwrnypK7Xe+AJIW5e01iJgzTZYYGD9VEe1NQeuuyhTcBY7Y3P0fdrxrisco63IHyycGJq0+FXOicz84FA4tdBaslK2b0DuDyX3MRZeViGNMNEPf+uU0kuU/M5q+Z2uVFj53C3inc9Tw3DMOJEQQAln6p4aQxPCR8QFfg/6tphfSf2+eR0ehasDNrHSk3txQr5GvtcAgf7oMNH+jsmhRB/S1zcjW3Xh1VUwLHxJ6fev8N8rgGNvoL75A5//J0rV93D2x+7QKbPr7Q1x92FYWIVoFplRqhF3zX5NrLjouhWSG1Ps8TZp+CKZEVO8Scd/2Lx4D5UtYe9GT8pM9I9s5bxP92l/Wd4wpVtOEiAeAW8kDC2YCgAOkPP2jyCcdrHfyRbo91qjkvTWmEAip2s3N/E/wONzrDSjF2SVLP/s7Ro8K0SJQmaFES4qdUZc1cbLVmpzvGHHUiIdXyqOA845PzoWbFu+etsSbuq1cDXmApTaO/WaGtAI/88zU2HEdJ+g83UKXq+I8MH40ZpenUatADag2xBXLMiAiiJhJQHonx5Cm9UtM5oFlf49SRhe5FiVIenLTc/ho8cFWKae6AyxpMuZujkdyFd6LByVnRbmjuGxQaRzhra2f0zqdCwPg9vdEywv3DFJHIDF72gsLZKLoRgpsdo2oY2Ath7mWvAHC6VvQgfhxRyZvm0bABDRTSZLdUycrhnoZbEzr1R2WMic2c8lk9qGCroKz1qzzSLTg01
 AFBZH9Xy
 5MZeqsTOYs9PU6JexwGKSRb+m+My8CuI7NCbip7Kxfgh6lCjTl3AsFOW1Ao4NWGoxLqOB2WhWFtfRDCt6VPOfkdUIhBkERx7ym7IUMj2Q+ZmekzrTCeIj4TLhPiJvp+JrG7kvoCTzW5bSx6mTNsaJKkOKZf5bM0nrcN5cPqBsKDy03LB5lzAzECTmCPuo/Gy09EYxx8Nm21upKGX0JVjOiDT4jp7T6ggaDAtlSa0x7TpNKZyki04JxU8zGS6WK5DF/iZ9sDzOFOpxx6e+fsk0sjovUdHT24Z8Uc5F72iepA8fH3U16mMd/bhcyNLlwoxRBlGXW1Rs82ORhTNRSqY4UhIrJ7YwQr6ym8PHhDHFD8+qTE3Hu+kT/2qNV5wCozgO+c7cVXyJUHOZE6pN7JLCVHs/XNDfRrcotYfFCyN8ABrfl6WBSwTSAHPICejzdvK+J7unnMWTv7TI0GDTgrLyfbyIfgroeP7EQ/sP+NAM+MrhWQB01GwxGoZAVF2HNIKqSiz/XnWf9qoJcg4mvAo8mRvFKFAzmTZfTTcaZ9g4mK+8GoqG9eVUnKW+NbmS0zJDYFZho/doPFsRy06GbyPewiCvm5m5QF/JxzOoo+MYBz10VvdqZwgEy6FIfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Export a thin wrapper around collapse_huge_page() that allows external
subsystems such as DAMON to trigger THP collapse on a target address
range.

Currently restricted to PMD order (HPAGE_PMD_ORDER), since
collapse_huge_page() does not yet support arbitrary mTHP orders.
The restriction can be relaxed when khugepaged gains mTHP support.

The caller must hold a reference to @mm.  Do not hold mmap lock:
collapse_huge_page() acquires mmap_read_lock for validation, releases
it, then acquires mmap_write_lock for the actual collapse.  Holding
an outer mmap_read_lock would cause a self-deadlock when the same
thread attempts the inner mmap_write_lock.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
---
 include/linux/khugepaged.h |  3 +++
 mm/khugepaged.c            | 39 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index d7a9053ff4fe..6fb8a6857790 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -20,6 +20,9 @@ extern bool current_is_khugepaged(void);
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		bool install_pmd);
 
+int damon_collapse_folio_range(struct mm_struct *mm, unsigned long start_addr,
+			       unsigned int target_order);
+
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm))
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49..0387841ba2e7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3272,3 +3272,42 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
 			: madvise_collapse_errno(last_fail);
 }
+
+/**
+ * damon_collapse_folio_range() - Collapse base pages in range into a THP
+ * @mm:         mm_struct of the target process
+ * @start_addr: start address (must be order-aligned)
+ * @target_order: page order of the collapse result (currently only
+ *                HPAGE_PMD_ORDER is supported)
+ *
+ * Thin wrapper around collapse_huge_page() for external callers such as
+ * DAMON.  The caller must hold a reference to @mm.  Do not hold mmap
+ * lock: collapse_huge_page() acquires mmap_read_lock for validation,
+ * releases it, then acquires mmap_write_lock for the collapse.  Holding
+ * an outer mmap_read_lock would self-deadlock.
+ *
+ * Return: 0 on success, -EINVAL on bad arguments, negative error from
+ *         madvise_collapse_errno() otherwise.
+ */
+int damon_collapse_folio_range(struct mm_struct *mm, unsigned long start_addr,
+			       unsigned int target_order)
+{
+	struct collapse_control cc = {
+		.is_khugepaged = false,
+	};
+	enum scan_result result;
+
+	if (target_order != HPAGE_PMD_ORDER) {
+		pr_warn_once("%s: only PMD order (%u) is supported, got %u\n",
+			     __func__, HPAGE_PMD_ORDER, target_order);
+		return -EINVAL;
+	}
+	if (start_addr & ((PAGE_SIZE << target_order) - 1))
+		return -EINVAL;
+
+	result = collapse_huge_page(mm, start_addr, 1, 0, &cc, target_order);
+	if (result == SCAN_SUCCEED)
+		return 0;
+	return madvise_collapse_errno(result);
+}
+EXPORT_SYMBOL_GPL(damon_collapse_folio_range);
-- 
2.50.1 (Apple Git-155)


