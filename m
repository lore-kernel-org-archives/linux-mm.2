Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586FDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485696B00A9; Wed,  1 Jul 2026 07:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433A96B00AB; Wed,  1 Jul 2026 07:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B936B00AC; Wed,  1 Jul 2026 07:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2896B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:47:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8505D120337
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:35 +0000 (UTC)
X-FDA: 84940032870.20.297BFEA
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9EC7FC0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cYSZNz52;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782906453;
	b=KNzhQ9oonKhIRpvnOa+WzY209qzz4Uz/QCFMbHUZ+6rCHAPt4aOJdgcETS2+HXpqerUQGI
	/98Fr7SrAp/wkqXNQ8ZVB3B095lnGftECnnmEAXTajl9YHxzIVQZra9SGU3KXtcUQWELND
	w0XVPmhcTc8yb0p2KqZjkJsbDP40qkc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782906453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prz2mwcezODKOS8in2sKwxdy9E9jg7GzDEkRG5HC3ao=;
	b=ljTtGOgQT8Q1pTRJXekM20EAil9IHHmLyObVpfDC2593VQkv51K5/znBmhnbU+xrzjMx8J
	H73Al1ykp7wYVqpv1EG+tBmaSTzXjsDvL0+7cf79EK0FVkdTY93/rurV1P8crX172zV/Qg
	DhUtEiWPgJk8aiy5q9OzHaVT9scNkoY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cYSZNz52;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-30cac93dfd7so1322327eec.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782906452; x=1783511252; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=prz2mwcezODKOS8in2sKwxdy9E9jg7GzDEkRG5HC3ao=;
        b=cYSZNz52T6vmrXpzZ9gsPf9Yq7yYa/4B4x+StUj+jQVTxinR7DUZrYS3mkyUKyzZqx
         LSZqpdY08httt7QjOvMeH9Svg7JcCu40JWc4SHZzvos4s3L+mN/NtuOl9/3GyYP1BeF1
         ceFHjAsWCOzJTj6QjcyYzJizpqQpKYgUtdb8WnZgrbOe1ZszTiGBEOM3POSZHfymbQEN
         v0NXhmxuecYpW4vbZaz9vmYM0xirT9pkCH8DMEmIK6ZFOgBaEWn5PQiw6KKNQGwYpSWu
         YbyYbvdrkNpYI3Be5QT+GRDTXSPgCD9LCupEESiaLcB9iTBS3Z5ZVSQCBkrnFVNuhrgJ
         Mr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782906452; x=1783511252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=prz2mwcezODKOS8in2sKwxdy9E9jg7GzDEkRG5HC3ao=;
        b=NTZodhCRpJoBjn30OztWcAWb+I+n8bkYM1NzRSRaoSz1MX0MmkdldnOL9D9tZMGhRG
         S71Zmln+hXZrKcX/LgS2MHWT/92gd3/J8QOI8e1kuE7M0wO+fegI8eDzSe+XI1fLe4c/
         nX6fAMFjN3ZZMG3EWJl7Gywnbrfdk7gJ28WZd8FNozsOpee+53nwOYktm0lhIts2h0Sz
         YoplPK6Z0IYnZ211YbOCXF2mekFPU9QU6HMvSAsCp66zs9/lrmG+9Samn0MOfkdEfhGG
         hFtQKGXCh64n/hIMMzIYHCv9sQlXDPLMgNOHVmPa1wZu3XQxlVPxmXGjqQbZDsT715xJ
         0p0A==
X-Forwarded-Encrypted: i=1; AHgh+RowjzIxaeCtsMwyuJQmUecOTbA9eVp9DL1CWLSg3vmnTSaOwtEay/bcTRpi5LmkFE+Wyk5IFeEg2A==@kvack.org
X-Gm-Message-State: AOJu0Yz8/45/TW1xD0hrz4Gx27zhTA4zWVEQsYEKXA5YZdse8N4frMAp
	eKBSCl5xaRkW5nbbpVkPcFmQW6Fqw5E1pXQHmmyUXQKYdQDIm8jcjYJs
X-Gm-Gg: AfdE7cmmsmcDbP9Sj1N6Twfe8019OsvcSSs8tWYmkYaFaWUew9bCT6XrVTQHLSmn7GB
	/W4n6hUK6R85hw1qpossXFzQAY9sSJobRbYL+LQlXfY6tB6/Wvl0HMAh/84boUok6JWG7u3KRyl
	Hd56M9TR0pF4CpEi62E6Xu13xaL9ztCdasICM5ocMtV05EonyG4dsv6Ghdu0PFfkmWvzV+uO6IR
	WcMSGcRk5KL2eoCigz+bP9FuS2He3SFsJVf6KkdOSw55xawHfd62Bj4egyoAeb/Myndgxg0Y/Pc
	u4vEl1uyzkYm+tLFDRB3aIj9gopDImfbkQGWYpSgFAZPr+bWeKoyVN5O/A5tVUXyRlYeVeHTRS7
	3prAEICBN6hFaKiePFKBHIN5jgJ6ElUaJfpx70HYpqD7V3K/1y/HbUAqzk7uiRGbpmKXvyvpOCm
	bFhA==
X-Received: by 2002:a05:7301:1f0d:b0:304:cd0d:9ea5 with SMTP id 5a478bee46e88-30efe710e66mr1921630eec.7.1782906452417;
        Wed, 01 Jul 2026 04:47:32 -0700 (PDT)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee327cea7sm22518169eec.31.2026.07.01.04.47.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 04:47:32 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	sj@kernel.org,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	lianux.wang@processmission.com,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH v2 2/5] mm/khugepaged: add damon_collapse_folio_range() for external callers
Date: Wed,  1 Jul 2026 19:47:13 +0800
Message-ID: <20260701114716.56503-3-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260701114716.56503-1-lianux.mm@gmail.com>
References: <20260701114716.56503-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9EC7FC0004
X-Rspam-User: 
X-Stat-Signature: kqejpuk9zrqogj34be1gmyx9wdbj1ckf
X-HE-Tag: 1782906453-242344
X-HE-Meta: U2FsdGVkX19bi9Q8xWEo4XbyjmHF3mY5U410obiU2dWo7X3glivA7eUEhx5Ad9ES7mu6dc7U7znU77iurUPflZ44WfqWH63VSY8KYbMgMcEUjdNyRpFjDC2u4TtJweCcM4zVOAKLLSyrP1Vrphbma+b4/dJ2y0FwIA65PLDVMrSj/zcj2uhxvi1kg+KlNlGdK+oIqZr2iy7U4pLDgBKH69sqxv8Q/2i2PlGlUY9vXAqj4csm7IZ71wT4t35WTM7cHbK16PBICVNJz9I893Lye/4W4P6kZificQ8rxR3SjjEvp6UwuoC1LOkwvP2Wlym0UbJbDOLOYiJ8zwjwPf3PQgVZToxHP00JbdaxXmhszXci3Z1VIFUAtXhGreZGVDEAQHRnBdBhEHLvHVWoUVFouUB14e1khxZ4LAaStP6cYa615/JeHedYKqY/mtFUsWp99t21GUhAFrr90z3DMXYTEeYQue/ZrIzJ/0MHkCoJulvMWdXAkepNXAQ6xm8ZddslbU1LWjl1iuFaoVVQptbMx/vpZmAIqMkTC8zrl63L4VJXHwG9GV4AahNTwkuParP4ScaZBYikCnFBFD3Q6nqraY4WChBGK2ypYwmLYUix1xJvO3s1MpA0r9N3HQwzciDMYjNJhDee1HYcRmh9a8+iu2wZoAiTkwWeFlfaFlrVTm5hW6IkaBH97RKA3I8XfZOsHAppomna9fsxid6W5D18ouA3rqhBIJ39U8Y9PamX/ZjF9TpNjbdkuCpNetywxUgqEhn9r2EicbeowwmXBgFVMkogoLlYwe7kRI06bVYhCg2XXlQDE8zZ7inYKRQ8UV2LCb4bbBeQ1dbHnqxjR2Li3aAL3DkMVuIfVEpNLGuQLXLJtg8igfXEnxRlveK6szDOLtFP8lRKHoRPcQ9Nvaf+XJtaCmo4h9n/oY4tVpZmgZ3/6dYPcg6apHCKaabDJwbslYcUm6A0vCqB+7vdqq9
 PkpAJB0X
 IoY3Qg5fzMHN+aLDRCGcLQXfuBARX+RX1SabE8RYTghuoiSRLgIf1kcSmcVinItgHOpGOrefZGqyjc/OQuI8qF8lxgsydmZ8uLSJl089Y4TUlGgSVe7+xc3AP+kKfcl1WzEiJgo2LZ7e7GtL5+2dVNFHE/dB19MDIR1AW8FlK5jm1F+MdH+ymFCj0Sg3hcxFV4mBClB7CHkkdvCrQkKBtS7F7JjlWfUG9fYBDW9cUPv9Ch1ZfBYUwTR9+rvWyioubV1fUWVeYwVTGC7eoSHSF5EXJ0RSK2MRE2KFHOXedW3wKU+ICbteL5Os3pi3R9gO0WH1la/NYilbW/TPrjd+0LT7pqALgeIE/vgsvDaTfkCYtDbel3sIkZNoXqrCEjuvpK799YAso5volb7wXHF5bWRC71PPTZ7pl4WxL3gf/JzNF/k1kyxiTu2Jhs2Bw+dBBTffhn+WfGJCrbptsgpWdnl+beV+odUWEV1lj9wIZMQHd8KWyXxIpaqQB1LS2YuYEkijyK1xsqZ5kIVVTG8WG2WN9FCRFslQF4gNFxC+yVPnkpky68D5YozGKLlwWp30vbZM/ICy2WU4XKjPDcaBIrrgWKVyyvjpsJzcF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wang Lian <lianux.mm@gmail.com>

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
Signed-off-by: Wang Lian <lianux.wang@processmission.com>
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


