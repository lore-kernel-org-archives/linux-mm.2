Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D801DC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1E46B0101; Wed, 12 Aug 2026 09:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592806B0103; Wed, 12 Aug 2026 09:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482316B0104; Wed, 12 Aug 2026 09:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 183726B0103
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0D651A03AF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:27 +0000 (UTC)
X-FDA: 85092684054.01.2ECF3A1
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf02.hostedemail.com (Postfix) with ESMTP id ADE7080002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="w 2m+TTz";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=URahXN19;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541005;
	b=Rvn+ox2c4zYwv9WWw6rEdfpW2dM6KRSCCvWQhjbVoxSGCxpIyoGeLsLA9ORC1W8QHcw5nc
	pvupw0V8LFIniPc9RNYVXxm+/l/WkuUxhuZAhl8kGfEqs5ouuT1Tm5dEjEOjoqWpzCBlL5
	SF0LI2AXa68KOMwahjvidb75etRmGS8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="w 2m+TTz";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=URahXN19;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efnlWGTfHMI6UMevBb/oPcFQfcqOFRMF5YmaGx8srVo=;
	b=F+aC9GPVjf6UizZE0MVR+tkQfT86MmoB4F7yAPo7IlDl7rPiV6j211vPY6HAIb3m6Av3P8
	Us0YVw7ozA3UknQD9RdM5Xv9x+iWqB/T6LOQXdhbCt2h3+xLwrsKSZVDAK3WMEaA/XYzBN
	NEBoMFLP4zwya1XQfQ5PceETdWY/mjk=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 802567A010C;
	Wed, 12 Aug 2026 09:23:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 12 Aug 2026 09:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541004; x=
	1786627404; bh=efnlWGTfHMI6UMevBb/oPcFQfcqOFRMF5YmaGx8srVo=; b=w
	2m+TTzekYG1h2SgpHz+DmFwZv8QAutAiRxEHITxyhsnhwvJcV0ffY2o81i38szb2
	f12Dvx4R9vZXnO68cJo8Bh6fxtb9HY7CycYIdJOLVsFu2sTyPidiEq71XxqyhoSa
	V0PwymnO1QnfLn35SkvmzLGdm8wVxVuhGJXsYrmgPicrkIPyMu8NUcs47s9L9H/H
	EA9IBHprvsdhO1B0pd+QnPhQTi4+lljOGc/rbvMBqWjwmz8z+iYMd/iIFzDj/Gcn
	xtrIxivXSj6l5dkzO2C9qYd784fpvjqC/GqBy0Np+1tCMPcmXZocSg5lrhG+BnxX
	fwt88UmdnJZLrA04OH3fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541004; x=1786627404; bh=e
	fnlWGTfHMI6UMevBb/oPcFQfcqOFRMF5YmaGx8srVo=; b=URahXN19dcwX7z748
	0lGwTQVtoA+CYQz3cpK7WFrOHv/ag9pN6XtY9hA5Vf0yFXdYu3VR/CvBXWtXzCs1
	zR1ieziL7KNn0nczoD8HQVuhUalYGO+Qsvy9roJ/GQhAuulrJ9GKeu8yKR5pHTeI
	XS7t7xJCzJhSABVyZzftZeBQDcxbNi7Y6xmzWFfkeWCEMLdw3OdOCQDgfGwVHyrn
	MGX7R9Z8a957xt1MAFyNz0WwWzNi0rs64+gudhyohRcQaAiAgfZwAkyrr+zqi2vS
	1B0VMcA9dgtcmEX2/UNlDDubD7MQKgDF1wBAguyVknpaToHupi/MKicwAr9W1SMB
	as7nw==
X-ME-Sender: <xms:zHN8alvdfRpj0CZnGWY1AEcKYjqQ1v7haP5jSVvuaryRZgRlhTjtNQ>
    <xme:zHN8aiZJhSQf4cDUv5Ov6aGSLGZBmKyKKgd1Y9dkSFl7l01JkflZFiMf3HcHf5LHU
    Wj0ntsswMO4m0KSc4WDxNesJTqZEuUnmE4vWE_uyDwVUGmpUCbztaA>
X-ME-Received: <xmr:zHN8ahSJPfhm_GzijgbzexK_0K92o4QI5Yb4EuBXg4uSm7DYJWb1mufbITg>
X-ME-Proxy-Cause: dmFkZTEWZPjKBYDoSh3uCuJ0ogiZvSuDj1RAgMuSmimalRft9LCPvZxyrluChLfTbkjo2r
    KkCK8Ttm4mqxi+W2/UjRoyI4gRuaMCGjIyoE2sYafZhhTXl0iIGCKEOr9/WVtZfHPc/pjz
    XsLpzK8U2Xu6F30SrJOujIlp1bmlomKUtpU/iiXSkRy6wwaI7NV8wAm1PQ0lHgRG0nCRKX
    WKIh8TtevEly/nhHwG2deu/klJhGkXN7h/CDYOOyqjOIkeF7MAFsC6fZtQDVeVkgzM4xU1
    Py5NrFUehZdXXi5LHUYxqNjNVNbuxWN2P2YJW6J2IL8s+zlVHHPN2YdKOlFVuMcbnWK9MZ
    cZzAisCav8t92G6y8EDE2O2NeImb6F3Kjul8xOVSg8SqONLZk/6PbrD52wNSqsb8obsWLR
    iTzUtunyCn4j5KEbFWlb891nKD/xanmWrCVMSvpCzuzJw9KBGCzmwmCvLBz3rjuKGU4szr
    tKrNL81C+NNfaaoVysR8XxTjI0QZ4FKoleflzByOKnCekcdRFTIUq6K5K3qyzNABWCkKDx
    WZQ8tJPYsIIFjU54wpPrYmGPFCHo+Zb8CW+gh6EY8aZUe6Vy9ca3raQLeiMaJHnsr/9F1d
    WIox07JLLn9J2mvuCq20B4HchKOFU0Z36EhhvHHORk2dGFo1TxmzMxwFBbeQ
X-ME-Proxy: <xmx:zHN8alxmpyNmcZ43Wmkbz0GEKL6Rn0tevAMCPqoVU1wAM5-V3OWfQg>
    <xmx:zHN8ateP1YcjmIVEZo2ZA0lWtYwN9bVBgEgc-5MgDn6nYwyaxhQj7g>
    <xmx:zHN8amp6psDx9n_MrDBrGQx0u-qPlZOCcFpy-lnyT0bPgIxrH1HLUg>
    <xmx:zHN8alOBhq4jh5YhXJkwlO2_fXWTq2JH1M7mfQHktkAIkrgl4HJhvQ>
    <xmx:zHN8amO58Bb-CrnWNZ5_bed0NNEPUfn3xlZW7qnI4BvATwTDFvbOjn3H>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:23 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v3 06/18] selftests/mm: move is_backed_by_folio() into vm_util
Date: Wed, 12 Aug 2026 14:22:52 +0100
Message-ID: <20260812132304.199287-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ADE7080002
X-Rspam-User: 
X-Stat-Signature: hfc8auwwrea8ib7ybwd78orj7pexarfh
X-Rspamd-Server: rspam06
X-HE-Tag: 1786541005-912728
X-HE-Meta: U2FsdGVkX1/sGLhC4hxh3AyQNpq/1VXaKFHTZTlyxcQRkmCC4Y7nHTN7xA2MzETp63fX6yRf2ATVGXmQfX+s4a8ksOOjCC7f4W1kg9RNWeKXfj1htV9Eb29+ypVuFSZ00TI7HU5jnijm/QwplxNA9Aj2iIinzD5NgT6cN6Qu0UIhu5L3vedrI2kxZN8J20prxIfG0aUy2L8MdLaLZvb99she09BSqNQQEPPnAEVbR9xnj0j3aaxPNYQvymtiAGKQApd7n9EcpoINNyTPM/oxEhnTVJGs6FQjiJVsEajRGWdO2D+XZtFVWW6VC77oW8a4dUujiq/SOceaJfH+F69e1CEuKGQzEnzGwkRxAYhiYevtaFuO2pgMghpSDR2pYaILJpyHXd/KTRkW4lJgS7KJtWUiePNMM/CI+aSVow9fAt+Z0rf68EjfvRq9tdfBrCI7GlPqcs+DdKMCpnmyKs3j9eoxXg4GlgJsDxN0cgk4hlO3ctvrZolYv1H+id7+5V/aqs2ZQqRzDS4MXVYsDabedJ2czc4rwkqZP/tYRyGmfr9bUbiuZcmigDYyl+mjcFdcdfjT3lfFkgZjqBP59quQA+g8fNmMPTLczObDwISCRG45Am9bW2oBaeNaA9jkUCl0NrfCdRVbdqFrgbTA8FC3fRRTbZIzmX0oC+rNiLUT0zbtagrVinNPHniyxLDdSabNSbZvxLM8LH1SRwaDe42QbG0l5jpTicQMtsE/UHZ8ysAWwrhwZhEoBBLm4y6cXy8lArUWsbqnxJ8I2X1weCjbpqUwnLotXrB4rmIyPHVAx8r/o2yBYJsiHSDux+HkYXKyQ3BZh8Emy1K+pPGOHlc9AyuheIWa+N1NyvGiAh/P38dHUtJtbA7X0M+MuXnszAOml4XDB/zuEwEV8HXj+a47rA1KNY4OtI/ZGiquz8xt2r9pAABuOeE26jKaOS1Mbr55riwRI70U4jlvRLSbzJZ
 IzqGHSBn
 CtAyTD46r4vg1LtPqkAopDqVKHtRCCpmT9aiFXTRV8JVrq60f/93uFTPJE4BZxPeKcyCk6Mp2tEBQIn3kIKMkb6q+iWM6kZCpTqkGi6q2oRGd1myDLpEUlX/9fw5kPx4z/0bqdnR1lymXPk47UaQBQOKVm1oqbHbaY0+MwO6a9I9J5Q8mDMVTkqqdZuaX+jb9GvFTd+9N59kIDoTFCDCUvt6F2iMfTh1FtLjcH4ulr8icwdqoUpFO1+1ah20goJ2D6gBUSjHVttHDBf04TvYNEOW7CFs5apcq1CRidNBfjWsewZO+sAyHBY5yb+qI4walNQe+QPsFqQ1RMuU6axv7dUGcOBkQCgfMTQ5JEShFvrCkWEqgihwIjbs+p2CPC53j1nKZqKJTjNJ9DrtdnGCLRmmIZpkKlLiS0Off12hLUnPwS3dvbMP841k7Pu6k+a8raUAqNj3+L1JQrXN8OaCNgbChR9pvcA73yOGezkaPvUbUZXO+W8UID8enDZcySWg4Kxj8UXISxPNM4Ty057yQ39kqkEr5l58qSKDzGn9+w4mAMPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The khugepaged selftest is about to gain mTHP collapse coverage, which
needs to check that an address range is backed by a folio of a given
order.  split_huge_page_test.c already has the building block:
is_backed_by_folio() reads the compound head and tail flags from
/proc/kpageflags to classify the folio behind a page.

Move it into vm_util so other tests can use it.  No functional change.

Assisted-by: Claude-Code:claude-opus-5
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../selftests/mm/split_huge_page_test.c       | 62 -------------------
 tools/testing/selftests/mm/vm_util.c          | 62 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 +
 3 files changed, 64 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 86a603692826..0adfe7dde7e5 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -42,68 +42,6 @@ const char *kpageflags_proc = "/proc/kpageflags";
 int pagemap_fd;
 int kpageflags_fd;
 
-static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
-		int kpageflags_fd)
-{
-	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
-	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
-	const unsigned long nr_pages = 1UL << order;
-	unsigned long pfn_head;
-	uint64_t pfn_flags;
-	unsigned long pfn;
-	unsigned long i;
-
-	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
-
-	/* non present page */
-	if (pfn == -1UL)
-		return false;
-
-	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
-		goto fail;
-
-	/* check for order-0 pages */
-	if (!order) {
-		if (pfn_flags & (folio_head_flags | folio_tail_flags))
-			return false;
-		return true;
-	}
-
-	/* non THP folio */
-	if (!(pfn_flags & KPF_THP))
-		return false;
-
-	pfn_head = pfn & ~(nr_pages - 1);
-
-	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
-		goto fail;
-
-	/* head PFN has no compound_head flag set */
-	if ((pfn_flags & folio_head_flags) != folio_head_flags)
-		return false;
-
-	/* check all tail PFN flags */
-	for (i = 1; i < nr_pages; i++) {
-		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
-			goto fail;
-		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
-			return false;
-	}
-
-	/*
-	 * check the PFN after this folio, but if its flags cannot be obtained,
-	 * assume this folio has the expected order
-	 */
-	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
-		return true;
-
-	/* If we find another tail page, then the folio is larger. */
-	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
-fail:
-	ksft_exit_fail_msg("Failed to get folio info\n");
-	return false;
-}
-
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
 {
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 80bc9f597b52..5db1a7774f49 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -494,6 +494,68 @@ int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
 	return 0;
 }
 
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd)
+{
+	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
+	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
+	const unsigned long nr_pages = 1UL << order;
+	unsigned long pfn_head;
+	uint64_t pfn_flags;
+	unsigned long pfn;
+	unsigned long i;
+
+	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+
+	/* non present page */
+	if (pfn == -1UL)
+		return false;
+
+	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
+		goto fail;
+
+	/* check for order-0 pages */
+	if (!order) {
+		if (pfn_flags & (folio_head_flags | folio_tail_flags))
+			return false;
+		return true;
+	}
+
+	/* non THP folio */
+	if (!(pfn_flags & KPF_THP))
+		return false;
+
+	pfn_head = pfn & ~(nr_pages - 1);
+
+	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
+		goto fail;
+
+	/* head PFN has no compound_head flag set */
+	if ((pfn_flags & folio_head_flags) != folio_head_flags)
+		return false;
+
+	/* check all tail PFN flags */
+	for (i = 1; i < nr_pages; i++) {
+		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
+			goto fail;
+		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
+			return false;
+	}
+
+	/*
+	 * check the PFN after this folio, but if its flags cannot be obtained,
+	 * assume this folio has the expected order
+	 */
+	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
+		return true;
+
+	/* If we find another tail page, then the folio is larger. */
+	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
+fail:
+	ksft_exit_fail_msg("Failed to get folio info\n");
+	return false;
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 9a49af88702e..56a28ce7d029 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -97,6 +97,8 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0


