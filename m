Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D957DCD8C90
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 04:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288916B008C; Wed, 10 Jun 2026 00:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4396B0093; Wed, 10 Jun 2026 00:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9936B0095; Wed, 10 Jun 2026 00:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED53E6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:36:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C3ED9214A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:36:10 +0000 (UTC)
X-FDA: 84862740900.20.FDB1F78
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9423620004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:36:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p0XMTQr6;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781066169;
	b=nLJ/4bc69BHiBILY7qNe6lsrb0CrIYr/zCMbVpeD7SSao1a0mm+pT+hMFVVuqPf6BAyvD+
	yw6zTrHOKJi3w9S1kXj/9UnhroVB+qZnOBOAchFR9BLgegVHS0Wsf1TyzAw0f00CDiktRT
	x9plyhT5AWHN+F8yce+xmD3hIO352Tk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p0XMTQr6;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781066169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tl1h/k/2Dw2YiJ+xS7kjSKS9vL23sab3ZFqA2dA69mo=;
	b=XaDeFQS2L4iS96nXH9YgpaZ5kDagS06a1E1BvR5vsfIuwZvyZbRHlHv4/NRY7riTg06J6u
	cEF4LEhpY+PvM2F0QJErof24p86ggs6jQakmFiuOBYnTav3jECDHKHSbk7mLU4/E+lho54
	HUE8RaqA3XkuO8GafqkxglvRbWV1Dso=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9A0D471B;
	Tue,  9 Jun 2026 21:36:02 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A1FEC3FD88;
	Tue,  9 Jun 2026 21:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781066167; bh=EQ0kWJg0soLbAjU5hu5xaNnvVzvbJHppGej5Gc7U2sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0XMTQr6CwEoVcot48UChEGP9uQKE7daiKe/47nvZuQwoV8U6mrO/xYx2BZr2LdXv
	 BI/Ivkn+7cTvWByYt+ww8TM1i/S107v8sdqUtHwkARvgDfNHf+qZ8mNOFtqm8g8VNJ
	 AdwSsj67tRPGavtpY9I5neVLn1YzLK8K7nllVqok=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC V2 2/3] kunit: printf: Add test for pgtable entries
Date: Wed, 10 Jun 2026 05:35:44 +0100
Message-Id: <20260610043545.3725735-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260610043545.3725735-1-anshuman.khandual@arm.com>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9423620004
X-Stat-Signature: ioor9xsmd691dxcsrwa1bm1tg8rsk5dy
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781066168-880489
X-HE-Meta: U2FsdGVkX18ZEQdfTCgcpRZTaXTP63NCqMB8jwhqtAZUsacx6mHCFvhsCxk0I5cWDzwyFWMF2yKuTEqOGFwLqG1WKuSRubHUq2otEfWV9hTcS9SMTJ/gxtt/H3NIstR1/QTN22n43mMu+edyq1R5eSTrLeHOTUnuU89Jq6yBWMDB+dc9Rp6NZ9yMyGdTlvepk+CHl2h6NjTQHK9gMYT1jzaD45mco3hMW1fpCwVo/938HPgXdaivmtq+EX2PX5KOTuedEUML/yT3M6LJAV+clFIYHzZ3cMSF+f2ikNWIgrJ362J1khO3WCbyUBC54xpVZVcS2WRdpH7YKqK0dJZbRcp6X9VzAUd1xVr5lh1tsGKXlhNP8GyZgaOUksoLyXTUb0IbXD7+DmSpBn9knGaFvdXjULGXKSkENIu3c2xB84M2laAEJJxA8lWCU3oRSF0FqOdyapSjCyNBl8kdIwI4SP0GbNb2GnWUmfMvLRHWyn8vQP/7iqXR40Mrt7h+lF/n0xqM7gV8qu/16EueUM7LWwnHHGQwfnzXhsOx7dCmDBgucIHKBbtRdcs7U0Scc3rmXUKDATsK4YXDsL54oU/BTTBrBmqrDDf6Psc7jBYB7X1V1xC2zVLerA3VjlwHw16yYmROdkMkPL8slRXFKVcvD+P882c6AuZg/Prkuww1G9ZjfGhhhYYmc2Vd9mMjbffzsHYQIbIXpw4nKkMn00BFWeIWpFPH/2s02qHlUKecxRMnIrb1ONFRfH8d+UYaUHxTsTalPc60P+bnCpmGrp/Ycq23A7xvSiwJktrk8ImO7bQavtU7Wh7UVrJivz++wHkH67dsRXrcCpW7JcQ3w76lP4PXzaeBN0P9k90DvgH2z8kQ85WbpmQR2EiQYndAvJCt35yzxzi0XEsdUwgUwEQqqBDHFUuFDJNt31Q0D4GCLkZy49CdT7P5V83YXoqjDiGUo5PY7HO8+W9c4mujuiq
 Wb9CiOq1
 pK7s9pDKdHS8QdsO4qahXBF2bMtRkog/fjbsrq6htGJ5VTm+DYjN6hRDhL5zMtokZVlmonErn3jwmvElPPuMh3hhuefAckZAGiNu/cJNU+iy7rBYL5X2v4AXsDpVeHXoXjETb5HK9OHWJKQv0knee407426GkRqq8SpmdBOnu5d0Pv/WYEwulcBLCr4VCd7ApbLq+UqYzQHbjl4B5A2KTJEGS5JZcoRw33kNtc2nU9sqP72/kHeEitY1FB2wkjFcSh20Nb9TtZScpXkycTmq1CddkV+0bFPHFyj6YTamqkSdFzUuhyUV9/p+W5y++kmiWCBED6qn+LFIFTTHB1vk3t0pPRv+5lvwQzPI7QIITfnqAj6xNLJEKhyiwfY0S/PBoHRo6pKXlcA9AeGDKj//7DbEZoxqxsLjPoIOiFO/jtU2pcBMfIz7ZCybWhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test for new pgtable entry print formats with entry size being 64 bits.

Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-kernel@vger.kernel.org

 lib/tests/printf_kunit.c | 57 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/lib/tests/printf_kunit.c b/lib/tests/printf_kunit.c
index bb70b9cddadd..850bfc0e3409 100644
--- a/lib/tests/printf_kunit.c
+++ b/lib/tests/printf_kunit.c
@@ -791,6 +791,62 @@ errptr(struct kunit *kunittest)
 #endif
 }
 
+struct pgtable_test {
+	u64 val;
+	const char *name;
+};
+
+static struct pgtable_test pgtable_test_cases[] = {
+	{ .val = 0xc0ffee,		.name = "0x0000000000c0ffee"},
+	{ .val = 0xdeadbeef,		.name = "0x00000000deadbeef"},
+	{ .val = 0xaabbcc,		.name = "0x0000000000aabbcc"},
+	{ .val = 0xcc,			.name = "0x00000000000000cc"},
+	{ .val = 0x1,			.name = "0x0000000000000001"},
+	{ .val = 0x11,			.name = "0x0000000000000011"},
+	{ .val = 0x111,			.name = "0x0000000000000111"},
+	{ .val = 0x10000010001,		.name = "0x0000010000010001"},
+	{ .val = 0xc0ffeec0ffee,	.name = "0x0000c0ffeec0ffee"},
+	{ .val = 0x10000000000,		.name = "0x0000010000000000"},
+	{ .val = 0x11000000000,		.name = "0x0000011000000000"},
+	{ .val = 0x1000000000000001,	.name = "0x1000000000000001"},
+	{ .val = 0x1100000000000010,	.name = "0x1100000000000010"},
+	{ .val = 0x1110000000000100,	.name = "0x1110000000000100"},
+	{ .val = 0xfff000000000ff00,	.name = "0xfff000000000ff00"},
+};
+
+static void
+pgtable_ptr(struct kunit *kunittest)
+{
+	char buf[64];
+	int i;
+
+	if (sizeof(pte_t) != 8)
+		kunit_skip(kunittest, "pte_t size is not 64 bits");
+
+	for (i = 0; i < ARRAY_SIZE(pgtable_test_cases); i++) {
+		pte_t pte = __pte(pgtable_test_cases[i].val);
+		pmd_t pmd = __pmd(pgtable_test_cases[i].val);
+		pud_t pud = __pud(pgtable_test_cases[i].val);
+		p4d_t p4d = __p4d(pgtable_test_cases[i].val);
+		pgd_t pgd = __pgd(pgtable_test_cases[i].val);
+
+		snprintf(buf, sizeof(buf), "%ppte", &pte);
+		KUNIT_EXPECT_STREQ(kunittest, buf, pgtable_test_cases[i].name);
+
+		snprintf(buf, sizeof(buf), "%ppmd", &pmd);
+		KUNIT_EXPECT_STREQ(kunittest, buf, pgtable_test_cases[i].name);
+
+		snprintf(buf, sizeof(buf), "%ppud", &pud);
+		KUNIT_EXPECT_STREQ(kunittest, buf, pgtable_test_cases[i].name);
+
+		snprintf(buf, sizeof(buf), "%pp4d", &p4d);
+		KUNIT_EXPECT_STREQ(kunittest, buf, pgtable_test_cases[i].name);
+
+		snprintf(buf, sizeof(buf), "%ppgd", &pgd);
+		KUNIT_EXPECT_STREQ(kunittest, buf, pgtable_test_cases[i].name);
+	}
+}
+
 static int printf_suite_init(struct kunit_suite *suite)
 {
 	total_tests = 0;
@@ -839,6 +895,7 @@ static struct kunit_case printf_test_cases[] = {
 	KUNIT_CASE(errptr),
 	KUNIT_CASE(fwnode_pointer),
 	KUNIT_CASE(fourcc_pointer),
+	KUNIT_CASE(pgtable_ptr),
 	{}
 };
 
-- 
2.30.2


