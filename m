Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9B4CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E03F6B00A6; Tue, 26 May 2026 02:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8466B00A8; Tue, 26 May 2026 02:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10476B00A9; Tue, 26 May 2026 02:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E00B76B00A6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:38:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A88B91202D8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:49 +0000 (UTC)
X-FDA: 84808617978.08.CA85CC9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0311DC0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X8kXKjF+;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7XPEfUv/xUtp00zs8Iya7071AP1NMpiGG3HtHy6K48=;
	b=BJeCeRzdSLYvvNxz0ahZPuoqnHJefe/ZoNnFcvAqBoQcpFz0CZKKCv8lTfll21u9VVHGnG
	UWCGeyLAL8ZyYRaVjJ2fJcpmgjL2slIucACd2vuJQbAAzcKPIk6gAwKG+DMwMLK9FhJR9r
	EqwNSbUmImGzNF7FAlp3CLoo1UBUVdY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X8kXKjF+;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777528; a=rsa-sha256;
	cv=none;
	b=RsxzP6HE2WdoAeU1qDkUWsNennLLrFMN3Yff+tRfHzq9S7+NNUAT08jdYa55uwnL6P/vqj
	N+pJUxljWUOHDuJAJTow+Xda+KKLM6XUiCWzk74pNkfR/pWrqgcYeXOgf1EuVLUw9zukU3
	4ZikV9RKKuHPoefMTE/0M9E1+6N9Iz4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FE1C2936;
	Mon, 25 May 2026 23:38:42 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 80B2E3F7D8;
	Mon, 25 May 2026 23:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777527; bh=iSUk93IpOjp1RM5o6/wHun7MSHRJvL2xC+E0IUMS7/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8kXKjF+4ZfVXUalFqiqUZpucRJohfuL5setv5FVSGv25j0BBmlv+uo3R0iYnTVST
	 1TQF3XbO7yoiPvfHIbkA5Lwvtywui/FJab0wlynzfiVqhfQTb1crBlOremgF/FQcB/
	 w9UDehrBV76yjtBeexuArTH9f5DVCzikGI/pumMo=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 11/12] mm/mprotect: drop 'sub' from page_anon_exclusive_sub_batch
Date: Tue, 26 May 2026 12:06:34 +0530
Message-Id: <20260526063635.61721-12-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0311DC0002
X-Stat-Signature: gefq1xwmh9o8bqjmabkdogrq779ud8rn
X-HE-Tag: 1779777527-334410
X-HE-Meta: U2FsdGVkX193lErt78VWcGSl7ZSW+rkAvu5zrGi7TQwY3/ZHIEkcgmj2EUlfGbftyB9nUfOAJ3vIYGCWKl+j5G+IoDUKwd7f8vWJbTgJ03e1CTTqag249Ys3fK+ISvSL5Gxb725CPnH0+vbLwcyWfMcCUKAdlXHo2Blpl8tPVIeUSHVAn94T9ZPT78lKPnbvg58I25kQcenPV6YYnGLG/4V77llEdU4YjtpVdYoNyOoWS+juF1neo/IJ5KciVswevoZaU4clQTs9fx6Qf0gmQsMilyOsIVHrDvZTmIQcL14nvF/HRjRKd5lY2JY8lQgHYyJN0Sg0VHObTD+uoE3nqBnU/fuj3Cp5kkcwFiMLbt4skcz8m5W5eQtGtTVsYTRnVNLtM4hA9zxR9LHE9ADwNsYRXwPgml+vz6H44aKRXd5EERM0uuo7ImKbUjwASJH2K+cOvQMy/BNK89cgip2hYcXmr+0ClEq9r5W0tukxz6hDjIdtmDJm8DOD2WyqJsWe0spihMYzRj9N3plH0frhnnJ4Lr3kKusfk+P0sWLigcIqbLhi+5AfNcSKMXtleyvevePpHTgR14YKHPpkvxWEbL8yyM4eBa1tRynjDUMFJfdr7imI/0erNoWDzgB5zpsvUVhTjN7UCQ2TuLxfkDVWgSYXpmdyBxnixkgJxGi38sGwgqjQMSXKgjAg9m3Gx9yAscRPAD17lAHq6+qFRldVEbjlC7ry06CH9KRLNidMnJhiJ6NFitjY1KQL8+nWZwo562jlYVeKbjR3tc2MizurrHDwMwfvzqVKhx6mpAIC3LjTLEeUPeNm+vxViD3HE+4fmalqpMjZaojr1HJuLBbbjdVIbivwDUDOJ42IP0klNp63uEcLVN/lQ1xSI4q2CouFgaxI5YD81HYmKJ/DdPM9uYlNa3G/UuffgHUSLEsFhhAelsgWThfDc5YGSd0gl7mBTSeGG/rhCGtRLYVgmh9
 ZgET/Kf3
 lKHJzIqW35PaqCToBDPZOa+l/VwevK6s+W0c15r33YxU31htoQLhI5tYnZ357OBrq5B25eSKuOSVuCSDr/DgNLdhOEGR6zkDamvdLQ48IzqQRV0Z68Bh/u0tqhxZcG6n66NNlLL6L+JIgyWp18epEMfhWsu2TsPz1EWn30q7Yq0w5jCp9ifla13+GObMRu5cwovarjKiAQiPH7kKnMjVvNuoCrqniH56sekPt4xA9sgLV8DcwuWNvcn6g25XuWNuXvlT7wqvuybQOx0SKT39LubutIHq3sWtA+KZf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shorten the function name by dropping the "sub-batch" context - the
function itself doesn't need this context.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/mprotect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028cf..3357058672016 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -143,7 +143,7 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
  * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
  * that the ptes point to consecutive pages of the same anon large folio.
  */
-static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
+static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
 		struct page *first_page, bool expected_anon_exclusive)
 {
 	int idx;
@@ -179,7 +179,7 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 
 	while (nr_ptes) {
 		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
-		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
+		len = page_anon_exclusive_batch(sub_batch_idx, nr_ptes,
 					first_page, expected_anon_exclusive);
 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
 				       sub_batch_idx, expected_anon_exclusive, tlb);
-- 
2.34.1


