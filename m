Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843AEC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 12:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900FC6B0092; Wed,  5 Aug 2026 08:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A586B0093; Wed,  5 Aug 2026 08:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754CC6B0095; Wed,  5 Aug 2026 08:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9226B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:23:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBE65A049C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:23:20 +0000 (UTC)
X-FDA: 85067130960.02.28BCC64
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF8F6C0003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:23:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xS7J7OwZ;
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785932599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQmUlerGIfmDflb91fg4O+jH4m7vxFQJPaUYGL93Kk0=;
	b=qHSzpos8UsGQ/GXHstgHe60pG8iuhVpJA8EBfqHOzbL7GP1bkp8v+euoatSHQJsBMKIkuO
	GJg29fC+uuqpImSxJ976qQtt+/ARcZ5kM+5vvQwvFtdqoBhkkjSr65JEzYetQlJRW6YmtC
	c8GBw2VeGsTEktkGJPZr4I+COzBe3RU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xS7J7OwZ;
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785932599;
	b=BuXV9+pzgVpjOJUxlf36xBRuAP6YTWhxySAlxSxoRiC36fiAcYlGV3O/FkjQRxgZn48MDb
	n913/GEt/wT0CPkVdZMGW0FrQn4kALOR+Ia1DTwZerjJ1u8RMfnoc2Hpzs5+RecHKeGFBo
	I+NYA+n3BjHqHqmUKukYPxPNrTob8c8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785932597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vQmUlerGIfmDflb91fg4O+jH4m7vxFQJPaUYGL93Kk0=;
	b=xS7J7OwZJD+fopQAeje3U74tdRqgJB0AsWNpoHGJEkzgWqKwf9qFkIygHIlawMkK3VMtQs
	u5f18HsMO9MK2G+Q6OxF+tF9DI2si68Cux79IGL0Xwpl0YmQ171WSmn8jQMDJu47YhzGmJ
	YtcXsWB+HpdtuBGNPUqdPQlxviLuYWs=
From: Ye Liu <ye.liu@linux.dev>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Ye Liu <liuye@kylinos.cn>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH] mm/page_table_check: add explicit pmd_none check in pte_clear_range
Date: Wed,  5 Aug 2026 20:22:24 +0800
Message-Id: <20260805122224.2512983-2-ye.liu@linux.dev>
In-Reply-To: <20260805122224.2512983-1-ye.liu@linux.dev>
References: <20260805122224.2512983-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: yup4iz5xcp5nh7nwp7fnu3qj1c1df3n1
X-Rspamd-Queue-Id: DF8F6C0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785932598-194758
X-HE-Meta: U2FsdGVkX18Zk6R9hkGo32TaEyufmIH55FSPAgAZcQo/IF2Z9X4DPmqKYVpkawcVdK6R0jXEsObwDW5wXhJg/CcVfPr87t597PFgPguBRnsX7Ff8z6B2YYWiwpZij3hfmmem0UMmpzV7GQvYIq8dbQfSStHuWhuL+CXDMg7gPdr+tHzjoo2nx58eDF/ZNKL/673NfrsJxaqo0m3BiY+rmUYWUfDt7e8o/eKoK2vnxepSae8j8f5uMAm0oNffrP4OGfQnjmoZWyxK7DY4e1pfreIqRNvNQW8dDEdXltG4KAo2iqyEFZi7F2i/Dv/VQ//PVryez7+uL0uXWpt/lCcCRi8VzSRfJWzPPV+XObEyqaw/Pr15zq+ab41s6/afR3hIkiGH4LoFrs5xONWfZQdBEqtP4LgNeYh0iljwYVhN+xMPrgB31muUM+0HvPD+nH7f7Oz5UQ61syP0PD2yHWm27h8zrk1OizKMh+9881IsfGmY5K0RXsQGlXLQZ+eMYdTCSxcskwVLuT2DEuv78gwxzwUaswPdx2/NBF1ef2DIFkV+50nHhhr38t45SvP/vsuOZPkwJNLsVXIHCbjwjuHsx89uhhcfGPkm1mKqi2heUfouHK+WPPjJ/R9v6y+RCGUXFrrTdUCev22JOA3NzrTwGode9T57OZ7uckJ0SOmrN0+SZvXTF4zL+XWQ31tVPQvMvr9fdAp6Ypx0EOIiIZCUn4bbTzwEJKjcpkQnQ4BI1L6CBRztRH7+D70gctKpuGkCOD+mid+3ISJaSyO0OWrY0uxMJsaN1c5msLeWta3hXDMF9MVmBNuAz7Sa67ISPNCNq2sDC/s3huQ4+yvMMOBpIBvQR72AAkYnY+iWfE4PgeVxlZ2mN1DVVuXlA+M4qk/VjgUCezf4uJ/RrdnGBG+Y0druQ49onTRSmKvluO8WJosAV2+otAc0tmRO+FfU5j0MtQFcvkSJm5cYHXYuEgu
 nClbXUAN
 Iz3vz3TLG7jKalgvTZVoxzMq+FV2xMuXYdgxMEc9uKFCeqwHMRa3AiFAEWffVm4XjRMqFnkARHNY4IcCeEas/bZFHxVftYA3sBZlbM8/6Yg4z/DblOUbnNQl8SZau8i69fdWoyuHLlqiOvPLpc8tdR13lX5VUu2IXIXLNxDDZHK42fy+4iJfES0p9iPAQwFZpu2L4oYYkaMBHNYEa31wbj8xyhWpzZg9h+1cZA/IVQDp1+tqjU56Vv9AAmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

In __page_table_check_pte_clear_range(), the condition to determine
whether to iterate over PTEs only checked pmd_bad() and pmd_leaf().
This relies on the implicit assumption that pmd_none() is always a
subset of pmd_bad() on all architectures supporting PAGE_TABLE_CHECK.

While this assumption currently holds for x86_64, arm64, s390, riscv,
and powerpc, it is an architecture-dependent behavior that may not
hold for future architectures. Add an explicit pmd_none() check to
make the intent clear and avoid calling pte_offset_map() on an empty
PMD, which could lead to undefined behavior.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/page_table_check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 6ffc536359cd..ed3e1a76f266 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -278,7 +278,7 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
 	if (&init_mm == mm)
 		return;
 
-	if (!pmd_bad(pmd) && !pmd_leaf(pmd)) {
+	if (!pmd_none(pmd) && !pmd_bad(pmd) && !pmd_leaf(pmd)) {
 		pte_t *ptep = pte_offset_map(&pmd, addr);
 		unsigned long i;
 
-- 
2.25.1


