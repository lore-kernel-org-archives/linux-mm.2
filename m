Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2B6C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BD2F6B014E; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9C86B014C; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398306B014D; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3E806B0145
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:12:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1997B1A0165
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:26 +0000 (UTC)
X-FDA: 84994608132.01.283758E
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4C8CA120007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eK24rjpU;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MW3VkNC58mnWKcn8BtrFop2mUDTlw3bfVwg/aYM+yrM=;
	b=uEfjbNA5lp59+z1K2yIQyIhrq+dtKXsvG+fb+Aezr/U+0PGPXjcpwAMR4HpIu8NwhLz4Jl
	arD7D5GHIn5MF1z8RsBigq0Tftt0850KgYU17ssoOZK3UNXI4iauj+ZNAn4WHGfo+8locM
	wEYlxCZdY37BltPf3PftaZ/v3yug0d0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eK24rjpU;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205864;
	b=kKQ+tFMTlrsDB+kJ5Lrjz2CZ96RtxAtCyigKFkrd/TaYmMZeeBvFUd4/gaeMN9tzFdA3Zj
	clMbxzeluJARo02H3SQ2FRO0+NMygpbDmXziQxkgUaNrBL+lscVpm3vIP2xhpY7ZN479oY
	Rik46ZsQQYXUJn6gw+G08pXwT2rp37c=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84861fc51f5so3650289b3a.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205863; x=1784810663; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MW3VkNC58mnWKcn8BtrFop2mUDTlw3bfVwg/aYM+yrM=;
        b=eK24rjpUbjliyhxIvEC3Ic8bGhAILiQHYqukxYVTeBt19MuaIkBjtPMK1RhOyZVys2
         PWAQKdMS4GXv0066ZvodJpmTbk8vvRzVLU6lv1QzI8IoyszuQJQUHOtnBLumwrNfPu9t
         yZ70kp0N2UhuVlayyXkYsaaDUzFkgr5zMYnIbWW3haWa9RU5kb/gYhU80gkJcr2MNZQ3
         oJZJ7JhIjiybCD2m1g49F9yTXOByn7nz+9rhkSvQiNp/+AW/GNLb9P4Kr/n3dGeKNN4P
         sAAhQGZ4FENoyzrCbvpRAF4EM2BffvnTHsDHOT8UtKt3cYOrhSbVS72aazTCKZu802Mq
         ZGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205863; x=1784810663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MW3VkNC58mnWKcn8BtrFop2mUDTlw3bfVwg/aYM+yrM=;
        b=PjbjLa8LHxfnqafn1aFbXWyaSraMqMId6L98rt78mwFMTEZOCoSWukwk5qU9v8v35L
         ms9Roci5Q5MP4rKnxhe4l5TTDpSQI9DHOPNGg/1WOF9oxHqggJuTdpRrdxWQ8YB6w/W0
         RUArJ94sSjsvUBmInV7AK3nBNaGFQKU481/S7qt3t4qMZ7IChCGSthE3oNbjxgKwviO+
         v4MyFuVSDEJViAk+ZxQO1C/43yU7DmJ0GBb3bcLyudveP7H/LJyCcXxxeH4t3SAhEONV
         JFYxIjs8kN0MF0um+X+A5T3OYINnqE/aHtFDXzPTaEJlHBPS+Xykqe99V9RO/U8uOhJO
         BRFA==
X-Forwarded-Encrypted: i=1; AHgh+RqBFwFRN+DbkYsk41d4OEiS74ah9xB3o9BS3wh7IfERWmDwvOKXIVI52XJ2mttvh4Cv5s8v7qyXIA==@kvack.org
X-Gm-Message-State: AOJu0Yyjm2oa5tbPi4YSbk8D7JSMc7AwcbqkivGvcq8MM9W02+/VopU8
	1KiMeTf5SNPB+tLZ5+Cnc8+YsFvFwnC0dVLrdcNh6xWIB9U0dqMwU3Sp/WQF34LffJY=
X-Gm-Gg: AfdE7ckMU8EbU8bavgFqeFgMBuZTjTArETGr8PP+Uks2N5SpqWYHv4ga9OZRsLNuCNh
	y6LdyoLkr8jE+gX/dDevT1zl587CSr+xnPHTnNp2FV/2p7WPXdkuBxr48O1Z5b8FdDUo0AqGc3X
	XoWd+5KKaE/ySX46Wwvj47s1pul5tGn0nGgFF2AU3YPlF/dkwFP/lvBijgYjS1isvTGWgcZD67m
	Vk64Nnkz6613+fMYRwIwn75+GqHdu6gtGq8Qduewmk5jdKGU7srv7oEl+3EU6uX3wxZcBukvuFP
	4Qkz5atTkXMXT7HxMywHHcq0a2lQQZR8bPIXhsv8kv3LaZtdfmww2p1FdeiL+U1pli31Z1eGdwR
	48/4Ss89O5YnoJ8qo6Mr0mRZH78L23pmFJOhzo/H11EFsrMX6FCI/Gm55JPQP1g4bDRicTux/sx
	LMDmecrHKJgAoqM8rzPPx2PlQ=
X-Received: by 2002:a05:6a00:4c98:b0:848:4b27:36ce with SMTP id d2e1a72fcca58-84a673c79a1mr6078389b3a.73.1784205863094;
        Thu, 16 Jul 2026 05:44:23 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.44.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:44:21 -0700 (PDT)
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
Subject: [PATCH v2 11/15] riscv: mm: avoid Svnapot A/D aggregation in fast-GUP
Date: Thu, 16 Jul 2026 20:41:46 +0800
Message-Id: <95699db9c9b90fd1f95310e9d95b000eb8cfc616.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C8CA120007
X-Stat-Signature: 4t5koijhdx6knxrzb79wcsujzzdiye1h
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784205864-805307
X-HE-Meta: U2FsdGVkX1/qNO2CBctokDlxsh2Gpw+0xtZhem9ZOq9kpoZGHATn2dGJp8fGcgWQNvip1G/7L6XffGsowTlCnqC/kOEML/2MEfkdRFJ6RIfjEveiNVqc0ALZert2hJHHXOfyK+pzjegRZEuyFKCHSDmRqEv6cchmy6tWoN4rlL9TfOF+77vlEYiPl2qwVZMCfBZvgs9Y8VHrJIUI/uzQm0jDHT4/4AMDT4m6gSAcakHofWYJdWzSB+RmiKA8OMNjDFJFSSR9EqpVDgn9wpFx9LRaCdg36FfJVhStKISCtDMKAsA1LO5gFgytaH9wN7vkNplAcmA345ltLbUjMEJ9PT7AaKpiUmzdccXty4Cwz/RcVmnDI3zqotQ8NE+h4lHkrO6RqDypwQ/pim+Z/RhlqK7gQGN+m+mRou++NPQ/qB+DRrtAJd/GeMBI8vjDTKvxKztlDPt37rW449LVQUqUk3F0HlZf8ItsI3ncw6QF2Vw2dWsjrCIS8yh6SnV7Uu05cYfimxCLnAIGuJDT8XlxZT7H9eF4S25/sysCaUhXS5sVpsZhEKR2ODWJ++urAaV0xoD1WIYuZ26C0kEuL5ErHamGboKNOFCCiJJTtO3XK9Eb7B8K+zpWOU0+HQUa0eSBYEH+IcteS8LZ9r21HjFZjIQH25bq7di4LntYBA6hu8CLsG8rkYo1QbRKZ9Gb0zwQxvKNVTioZUt5L7Y0NIq1SsMM7S/ss1162GcRkqxKNcb7eZP7uNQgExZ6NfftxERQovsBQ86ao5vg4UGhmx02FKNmLfTY3iqfq1siHwatKy+vKU2bDJNMyyhYSXJ8dNa+gd4LKHu6QQwWz7IhYhKoACAVbhACtSx8pEZPtIoMTMKdUnFdZ3VZbAymNuthEE8n5nNlfIDjsQx1KdiB1HcZFZxjmo087NtqtvhVwPFAqjfTWj5vXM9FJJKaOYaph7F26INBuOoJXhTuEjEk2Mf
 0Y2ptMdY
 obkHzq+E1tTmgFiCTlhkixkZA8To+RtxvU+Lo3eyBAPBzXx6aJ4ah5iICDcoZlwXyaLhHJFf3ducG+BZq8O6ntvV0/LJEnrOJuqO921NzpoFgAkLBtPAudRaIlJeteYDFTxr0a7j9n3pASlejTkWzEhWBJ424ErG07qSPu+dxPsZTUXIZY8cydYQ9M9Te4Y22JRbyh8xcb5dCml3Tpj6gXInNxJ/twrSuvWTLKlHeIcSA2KbadxiJQE1F4ZlFpVgPU+VVypvpIfgxtyZ8Oe6OAq9Zdso9u/YzODHslAQFDjA+s7ZkH7IY4yMrq/CMkgXKeZeB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fast-GUP only needs the PTE state for the current virtual address and
revalidates the raw PTE after pinning the page. It does not consume the
block-wide accessed/dirty aggregation provided by the public Svnapot
lockless getter.

Override the fast-GUP PTE helpers to translate a NAPOT PTE into the
current sub-PTE without scanning the whole NAPOT block. Keep the public
ptep_get_lockless() semantics unchanged for other lockless users.

With 64K THP enabled in always mode, fio 4K random direct read
throughput improves by about 10% over the previous implementation on the
same system, from 2.615M to 2.874M IOPS and from 9.97GiB/s to 11.0GiB/s,
while average clat drops from 95.54 usec to 86.97 usec.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h | 20 ++++++++++++++++++++
 arch/riscv/mm/contpte.c          |  9 +++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index dd56c20a817bb..3727c148fa0fc 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -597,6 +597,7 @@ void __napotpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 			   pte_t *ptep, pte_t pte);
 pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte);
 pte_t napotpte_ptep_get_lockless(pte_t *ptep);
+pte_t napotpte_ptep_get_gup_fast(pte_t *ptep, pte_t orig_pte);
 void napotpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 		       pte_t *ptep, pte_t pte, unsigned int nr);
 void napotpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
@@ -956,6 +957,25 @@ static inline pte_t ptep_get_lockless(pte_t *ptep)
 	return napotpte_ptep_get_lockless(ptep);
 }
 
+#define gup_ptep_get_lockless gup_ptep_get_lockless
+static inline pte_t gup_ptep_get_lockless(pte_t *ptep, pte_t *rawp)
+{
+	pte_t pte = __ptep_get_lockless(ptep);
+
+	*rawp = pte;
+
+	if (likely(!pte_present_napot(pte)))
+		return pte;
+
+	return napotpte_ptep_get_gup_fast(ptep, pte);
+}
+
+#define gup_ptep_revalidate gup_ptep_revalidate
+static inline bool gup_ptep_revalidate(pte_t *ptep, pte_t raw_pte)
+{
+	return pte_val(raw_pte) == pte_val(__ptep_get_lockless(ptep));
+}
+
 #define set_ptes set_ptes
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 			    pte_t *ptep, pte_t pteval, unsigned int nr)
diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
index 0f66426b0ecfd..b0b8ff0aade3a 100644
--- a/arch/riscv/mm/contpte.c
+++ b/arch/riscv/mm/contpte.c
@@ -413,6 +413,15 @@ pte_t napotpte_ptep_get_lockless(pte_t *orig_ptep)
 }
 EXPORT_SYMBOL(napotpte_ptep_get_lockless);
 
+pte_t napotpte_ptep_get_gup_fast(pte_t *orig_ptep, pte_t orig_pte)
+{
+	if (!napot_hw_supported() || !pte_present_napot(orig_pte))
+		return orig_pte;
+
+	return napotpte_subpte(orig_ptep, orig_pte);
+}
+EXPORT_SYMBOL(napotpte_ptep_get_gup_fast);
+
 unsigned int napotpte_pte_batch_hint_from_pte(pte_t *ptep, pte_t orig_pte,
 					      fpb_t flags)
 {
-- 
2.39.5


