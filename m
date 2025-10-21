Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539AACCD1A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 02:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886688E0009; Mon, 20 Oct 2025 22:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836C78E0002; Mon, 20 Oct 2025 22:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773A38E0009; Mon, 20 Oct 2025 22:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 654DF8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:44:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D39B3119C46
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:44:38 +0000 (UTC)
X-FDA: 84020578236.02.4D5BF78
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id E0D7A140007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:44:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761014677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=riflaN3sTi+fCQ0hYe4quH3jFY2KRyiWt7VxXNkxkfg=;
	b=PffBUDLoWTqMVXmhnuZR1WVQ0erSVppxkdqKOyAa4e77EJty0+CjNYQBFMswfNgvs+t04w
	IMyYSaanIjYo4G8BoK1rS/+AuJ9V5puG4Uwo3x/bvxQC2DHva5xNzSomp7Y8A86dU404IX
	BIOPo7mXYwcPNlW0n9Jk5Eg6LidfcnU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761014677; a=rsa-sha256;
	cv=none;
	b=b9fFNn/LtHgEnc8Waw+fBnbU6QTQS5RvFuNRniUufCGLdKi5HBSMaIqAqX2jGs8HRE7Kqy
	IfqAp3rROFZnmzE2uVh/q9vz82qixPQ4b+DnjUY9dCVc5IjCTdjm3zIe5K1XSKUJM5yyIl
	fkiYTapMKlxWkQ3E7gJ//B3bfOX6GnI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB5C61063;
	Mon, 20 Oct 2025 19:44:27 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6D0203F63F;
	Mon, 20 Oct 2025 19:44:34 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma() tests
Date: Tue, 21 Oct 2025 03:44:24 +0100
Message-Id: <20251021024424.2390325-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ytraxbkue4asgsoo5g7uhgwps4uqefch
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E0D7A140007
X-HE-Tag: 1761014676-273833
X-HE-Meta: U2FsdGVkX18Fd4DYvH0w/SbQSlm+e5gMYhphRl5aAD7BSK9wzEX6koJ6vYY+cJMASQR15jhCvCZu/9Mvkk2w0e+B0T1Mt0kCUOIOPdYoGfwBG+1ST06F+GYpTDgO6Rkx/9sIzCZ6hGCe8Yu1ar3gp+FeGtLSrcjiDjy+jdMxTLCnTvu5LTtOhL6sWMDBSK5TmUw29JbD+Or55kQOfXDeMYHneEi8F4NiV8VAjZOLxZLG1Szcq1VRFcwuFoQ/dZT8IPr3i6SJ/D3gqaEQEG3FdPnAevo5HkHrQwQOV+7vvPw4iBdFboYJltrt2uiQuk2vW2DMKxLpiEj/x8vfWERIz+DFDyYYTlLqeUldAbu1ipo8iV5gXOJSxlw6+J72TACiFdcbEat/EU29EkIc0155/Pzrjn9sRJIUoRl20fb7Elek6WRAOpT83LB+55HG+5hoO+Upj4b3z467aCdqvAhfYSepXOgi78/DduQ9ZRFCY+lBqIuXA63CY0K1tfwcsbPfJHN8Gu/Stycm1yZ8yXO1Q3/5vfgvp3yrjMsUxF2j6CD0TbKPMNZfpGPTs8jh/Cv4Bx5HFueRr6Cdtm/vAiM662Ygx3JKv42Kdr8JVp9/9Wb3TYbyey7Q8TTasjiPRE344d9FsctuElrtg+P1fHYivV7Dv2uscgHoyOFkodwLdg63E6lEWXM7jp8NRHkRFQ1EP2J599GGcYNgIMs7EiM93hpNvrmPu4uHf5Kj+H7O3eyatFhw3HSQUcKYki+ocQ7Uh5zqaqUjqcRB35UPQodzQWOYO2yk3S8+qXCbN9nUFXCEftPZ5LeLFAczKQ0YKCWMRVba9o0fXiZplusj5qwqz7tIDx9X4Ow7lD/M3VomfWDkHRze/8I5/Z7H2csFStgKyZN65+dwTdPzib8ouxaftZjVTw4DInWtWj0YtxcqB/UR0sd7IPA94CgPF9zNmnfgypX+0yxdLsYn1ELS4Sj
 dbsghZ8f
 TNl8uvnZaWsQ5aVDnEL5Nf4Q9wcIiaPk3gOCpLoSPrC/jFXNJumiVLQvQaBFNNxv09H9EfW3SjxOKRArnIRObyXosQl9mM/ykgsWfzfaMLsn5CGFO+6B1MPW6IyCysnBCuJryWgRPTxts+Vg9EiJezdxbjoDdFoLeXKi8So+FRabDArRX+MXpEwVaso3d2seioOqs3oLLv02ZfFJiyQo+hbWQzuxX93g0R0gbHo80lrKEdgDgxoYOiiTPcKV5E9ETMki+DHvvCBME91uKzWd+2mYoMOhcQZlwoyh8jKPrpRK4T5LQ3XEXxiMChxfgMLS1iilTJAITMUcqa7cAtOJj4WsWc38sothflEcX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add some [pte|pmd]_mkwrite_novma() relevant tests.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
These tests clear on arm64 platform after the following recent patch.

https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/

 mm/debug_vm_pgtable.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..b9cae1580782 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -102,6 +102,11 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
 	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
 	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
 	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
+
+	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
+	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
+	WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
+	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
 }
 
 static void __init pte_advanced_tests(struct pgtable_debug_args *args)
@@ -195,6 +200,11 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
 	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
 	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
 	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
+
+	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
+	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
+	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
+	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
 	/*
 	 * A huge page does not point to next level page table
 	 * entry. Hence this must qualify as pmd_bad().
-- 
2.30.2


