Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FF4CC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38C06B00EA; Wed, 12 Aug 2026 09:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9C26B00EB; Wed, 12 Aug 2026 09:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D83F6B00ED; Wed, 12 Aug 2026 09:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 754236B00EA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFAB9403D2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:16 +0000 (UTC)
X-FDA: 85092683592.17.2E9DCF1
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf07.hostedemail.com (Postfix) with ESMTP id DC92B40003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="p RC/52N";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DWl702yu;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786540994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QU5cOor2Ab9pLoeGxJ+Fiu9sKQhetOKhAO/atZ7UTrU=;
	b=e8LDEJUGPe9wCNhYAGoXRR59fQCLxGNpWIuAjOU+2KGNTRZhkhfFlwvZKllNdCPMssdrFG
	Nfw0itQ/RahOKWQFpPmGr/bjIi1Ip+SRUZ83LnDiRdYzS5q1D48sfNlW3JO1rteu+qOpBO
	zl89GQSAK7XkQBjZqr+J7F5XGIa6B2w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="p RC/52N";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DWl702yu;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786540994;
	b=ueZwNdgqn3O0aRiek5pkiKVAYIR7N/GlJUx4r99fYqovw1xldOnXZSxv+qMOaS9E5pUMmr
	a++oIGEdBkL9Eyv2U7t6ZJadF85yR1k2JmKH8zzM3mrLak0z4O5whBb7/hQERZkEFN0Gqc
	6nR1YM7U6sYdKN03ach+xf4BhHANieM=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id AF2DC7A0106;
	Wed, 12 Aug 2026 09:23:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 12 Aug 2026 09:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786540993; x=
	1786627393; bh=QU5cOor2Ab9pLoeGxJ+Fiu9sKQhetOKhAO/atZ7UTrU=; b=p
	RC/52NzJJsirR+4TDQ7A08DdLIlBhGNLqUZLDkxE7dPfazDfVjp1DZdT9Ev5mShu
	vY+ADo1LybGGDNx2gTMaztsuRmpJq2ipzy6Mlx4Wy47ib+xRjHniNzlOgSrJY0Xf
	Cczpk3SlgHB4vjsJv/vMSwRDuH/4FxE6bRVExfluLUZ0FrYtUdaZPiJ7II4O6Kxq
	2wJETt5+E5omyL53ncUHwyT7uAVrNMTiOWBO5HDlD7Iygtq7s/7xgKpwh9kMMYfP
	xJqediQ/D7uRXY4LEJHIWG+9WIoEHq/KNmh8Kmz3MKh6L9yV8X46bJyoU0zIY/OH
	HKgDwLRPAIpMQZ6X6na0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786540993; x=1786627393; bh=Q
	U5cOor2Ab9pLoeGxJ+Fiu9sKQhetOKhAO/atZ7UTrU=; b=DWl702yuuHnkiOlUX
	X+ssNVIK6b19rNaaywVIH+CKKITcBO+w1IllVjvijCCevOg+gzviAqtL3LxMR+Dh
	e9sT1MgVr9NjCrV3xMFwckk2Wi205eEMHsDfds8zycdBrqCKaTTsYLMLUtZRtYds
	6G3git8eoEaKmP/dqMthOjignJOuMb0W4M/wDOwIXwLxOoga9XiEwM/ehwAwqkRo
	nHsexYmodp7LPUL3uDYsG/T5z3N2NrxbnaRyYBx53FwHRT8RKgN4oRauHcb8Z+rw
	GhHePx8sjGhQhe36kvNas2rczX0Ok9al/I8l6K2eKYVXxzaI3n9poYqpjt2Yxb4T
	AHP3g==
X-ME-Sender: <xms:wXN8akSNdxjty8FjrVFVq4atJOIHSwsm6vxvoTig3-9kDMY5kbe9Aw>
    <xme:wXN8atp9P0-TQXs_lq08WOEkxvF7y2TRnUXDK7ocp-gVihaxrgDZ4PkfmD8M-X08H
    htHQ2_KgqyFHC_hIVeQCXJpKXT3HVGbElE0CJuDqMkxUcoO3kfKBSSi>
X-ME-Received: <xmr:wXN8aqqC7kvwlVQ6R6L3IntTt4cOqhSoqgZkwq6gY2iPuJI8sZS334_Jt0E>
X-ME-Proxy-Cause: dmFkZTEWZPjKBYDoSh3uCuJ0ogiZvSuDj1RAgMuSmimalRft9LCPvZxyrluChLfTbkjo2r
    KkCK8Ttm4mqxi+W2/UjRoyI4gRuaMCGjIyoE2sYafZhhTXl0iIGCKEOr9/WVtZfHPc/pjz
    XsLpzK8U2Xu6F30SrJOujIlp1bmlomKUtpU/iiXSkRy6wwaI7NV8wAm1PQ0lHgRG0nCRKX
    WKIh8TtevEly/nhHwG2deu/klJhGkXN7h/CDYOOyqjOIkeF7MAFsC6fZtQDVeVkgzM4xU1
    Py5NrFUehZdXXi5LHUYxqNjNVNbuxWN2P2YJW6J2IL8s+zlVHHPN2YdKOlFVuMcbnWK9Qx
    kVqpeqVrcf8ZaStEY2VI8+3FWhIr21qDtmYPrSFHLNbwKtjKBMX5CJhId5vlxW1ejp+ZbT
    UQbEYHl8E0uRICu7ifmawK/TtGPzD9a2v2Ji8WOvraPW5mnOoDCNpqpACSUFLHEzdJY2xz
    +M5SOZpuG/y8PGt3CPQlLKczqCAHQeBmpGFllRpnfIT7qZqUY3cOJeUbWKswmuJkgk4ylz
    yXzzt+h9A4hT4cKZxd/tfRdcL9mdMK23tw3+UIvAnIz3tSRfwXHrJd8VaZt8wDmoxfTM8f
    ba6RfcTYpmZBdecltXKgKCyXs9QlX39+utlhyNGtdi4dYkR0EvMWRVCiudag
X-ME-Proxy: <xmx:wXN8ag2xck0-kwzlGXcsM8-96EXzfyIiGpUOANY4L6mhATkuUJjXPQ>
    <xmx:wXN8amgiLIIivL98e5ORdt1KHALqf7hw7F4WsLQAxSlc_nBOY4ZWKw>
    <xmx:wXN8ank8hUs69VOez2wkHs6R-IJstl9zt3Gm5ZH0Nbz3cFLnMm7LBg>
    <xmx:wXN8am-kPeJezlQoHa942CkfMuK8UJ1N0LZjVrvY1YGCnici9WrVLQ>
    <xmx:wXN8asaaZbFYvsPqbrPV3uK5WBCtn_CdFpZIncV3pH9NTeGEUia4b4b->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:12 -0400 (EDT)
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
Subject: [PATCH v3 02/18] selftests/mm: skip collapse_compound_extreme where the PMD is too large
Date: Wed, 12 Aug 2026 14:22:48 +0100
Message-ID: <20260812132304.199287-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kwxy7pg493hbq111h78yzewfg5pj9bkb
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC92B40003
X-HE-Tag: 1786540994-912323
X-HE-Meta: U2FsdGVkX19UJS078/VVwDHoWg2JeoltmSfZ+I+Q8p+OLFrlM7N4ubG+3cB3l17p5A5zAYQ7WSzqXyRe31VoNUqQrk2mgYiFYewJ6FUWxsa7rKL354Iz4mBYDk6sz9r9h7dOovBqTFub30w3GGUxBx7YWxyH5xFsPFL8vPDLLzS+jvSnqiJQK5JPbLNZ+s/IXUkeLO9zxH7UoK4RM4ImH+DWSa8L6FQaKvOYbUNz2X7xChH7asFFZ8zLVGBSiJhrXx66vZiu6DTt/h54XQBN5MfG9eFdQAgv0fBp7lmXUNETUeY2KLJ0gr4Cmd1ipRvGICFLVzr3QCcPa7BCtU1eDFnrRl3ZgGFcDfrO6HLsMRem10zxUc3saXq5WZEaUqMp021rOuyq1I5reQGDiPeb7bUstC4UlGviDQPM7zuNSJWpX0Cl4Dyyb3QF4nDQrAtVHjrQyiS4cV0AOKkq1m++XzWZTa28kiRwCtXF5FGoAKLJ72Hh/z9U7CkhthjOCXPvflu550qCcuYcTBdAAlJh/5DTB+bKT/tXAvvbH1B8kvts2FizSawr4iIW+1CZcSmY4bZyhxK3LhD4wVBf2iiOodLfudtz/VK0osIRl99VekVEzzDVeXtRfXjrcFO5HGPAd6gSBd8wMB3W3rIXbaQ8ax6KsDnB6158UedeEmcYrJt+jeCkpvQxogR+jmmYdIlWozcl/yAoJgRdwvPA08Yqs1wecmMcphEMLVCMvBJZxHWfJPwkge2KCEnqObOyKGmele78N8DdWH8cBCG/ls4HKHHu0FdaJUwxnjY5YoKDE9DT+ZcgrXkcuxUvbAoiDBfoqUMIpuekW6U0jaBsNrropklmEVY0bF5D+Ob4axclxeGr6LC8jsl8XeMPMALREec9RuLK+uY+iP8RBpVVCxlfZwenssk7vfN6M9++WuGQ5eNutBFICKjnqHqjx5g41lz4RJHuhR0uzAnN8nJmPA6
 QCVA+XHv
 DQBJ1rPzGBZV/QzZ5xXXkabiJA8l30TiBoZCuXg8pal+LeQkVPlXlmfLPrYvBvGWJYaWJnC5oeBJd0ftrSM/NvfCnYckFtlSxkJLmcLfCQeN7gvbijA4rrH1rKpUg1ap1LcB/S7jCAoL/EO+XkJxIwkWpDgCXJiydgDnfiroqqZK0202km9FOYAeppfeN1KiktAL3TFZJXw/48Aiwah4PD8R3ODtjbkPLewq7Iovun03JreF+o05jISm/vOiH9jSgvo5X6MK7POaqo7x0yjQP+xddoB8uG1SM/vTcyqJJaoCqcq4RmQpS9FYrFOFT+2AmlS3WJVdEdqqmstOyqYPV9dnm1gwsAnJKh+2NGrBZdZk5fSjWZo6IPemMfZnB9iwBhE+1AqTkSvj3WQWd+9ZYB2VW+wBbomw/TWi4VJXk8tHxE/6X22f7hs+pZ/ZASDi6Wi2Ptx/MZbvBdGCKJMd0YS9ydrNOIKTd3SbqO/f/dON6tGl3+zzoi0ozv9EB+qIwUP6Uxk+gftyEwFs+FUhJynGYOKsW1sx3tAYVdKXOHP2+bVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_compound_extreme builds a PTE table full of distinct PTE-mapped
compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
at a 2M PMD (4K base pages) or a 32M one (16K), but a 512M PMD -- arm64
with 64K base pages -- makes each of those an order-13 allocation, which
the allocator cannot reliably hand out even once, let alone 8192 times.

The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
whole binary stops and every case after it is lost.

Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
still cover PMD-order collapse on those configurations, and 4K and 16K
PMDs are unaffected.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 018b0698229c..48eb74c255f6 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -974,6 +974,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 	void *p;
 	int i;
 
+	/*
+	 * The test needs hpage_pmd_nr PMD-order allocations, which is likely to
+	 * fail for large PMD sizes.  Skip if the PMD size is over 32M.
+	 */
+	if (hpage_pmd_size > (32UL << 20)) {
+		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
+				      __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
-- 
2.54.0


