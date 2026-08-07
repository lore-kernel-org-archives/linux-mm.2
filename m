Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D94E1C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9946B00A3; Fri,  7 Aug 2026 07:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC27D6B00A4; Fri,  7 Aug 2026 07:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988596B00A5; Fri,  7 Aug 2026 07:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 776A76B00A3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1816AA039D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:22 +0000 (UTC)
X-FDA: 85074272724.29.7F768C2
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34622120002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u 0KIY31";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=JmtyROkD;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJEIXCOdsK1VdJ+vTB/+b5PTVsVX+FRzDaAsHSTP7IA=;
	b=vO/FrADFbdBK7RAn97aB3JWnCQ2rlSVG2yAeThZQJtkTYCDBHj2LUSin3By4nJc9uwqnsV
	mLREEr7lmITij2etgR0WL3l7LtzpoNSk+ry+GUbXrZtA7tgiYZGydhArERIChgj6eNldMq
	8FDIfW89dXKUI2VR2q79rLj1xsdEBp0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102640;
	b=TloRJAdbLNFizBXW2n2nZl9GABUOu0f9NB4N7HkX4Z3zLmIF5jEuNKZzwYkD1NQVnSTCF/
	TzsHraGUoXHGeCLUFRWspZwS6B9bHcyEGsaRwjy9JNdoTJwTui24n5t4o2WrA66Bx04xXd
	A5B3d+ycG5BEtsS5L0RyQU4EhlHrR6A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u 0KIY31";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=JmtyROkD;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 1031D1D00082;
	Fri,  7 Aug 2026 07:37:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 07 Aug 2026 07:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102638; x=
	1786189038; bh=AJEIXCOdsK1VdJ+vTB/+b5PTVsVX+FRzDaAsHSTP7IA=; b=u
	0KIY31KUUaa8liCCu9KTgWbh9RLdB7yGDqhdRba/oqA6EqTFBxivp+GvevkcPGp0
	R7V96Ts6E2FSICBk9yItN3plLUxEtbnEYAszGtb28aIN3a4KRsbNKey4OyOrzrtT
	ghye5sOpszFtcxAcAbtiS6IvNp4WR/JlkaEbDJE3vSfnP93AXAZZ4GdVs7oegEF8
	wMxw+4ThCksvj/qsuB5XTEcuMWxYwswDltDOgReov9DVWCKuC/7wzU7yg+7vKi0n
	IZZrh+TXpx0aYbgG9toGyGeh6XLRXAnyPFFXUkr+e1G1NiSot07Ul4p1lf9m1GeG
	XULBL17L3EzhN2w+bMk5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102638; x=1786189038; bh=A
	JEIXCOdsK1VdJ+vTB/+b5PTVsVX+FRzDaAsHSTP7IA=; b=JmtyROkD4PTSKr6Ym
	7sg+dQQSTmcCqEp4Ml+Q8hQb8UgYCm9848RuqaVbWsV7UUih68O//+dnchC1G9zO
	Gjyd6YDThoDcmz1PmrMtCOC1aTJ7zUQUyjbBM23kvrKKgrIZgVfRFLAhn0Fz1zHP
	i+dvA9zf3sa+wRbMWwEG0wiQvY1iigRzyidsVG+zmFC346d35R7ZyaFmFrOREJfe
	KPa3+ug4bZGLhNEAjRHj80VoD4TbcvGRd1TeiqU8ctCD7nbuP/9xC1Pz91ogmMsO
	PjRGeeg5UQ1UlXemhAIft2rK4WNo5BeH3CuzR8tDDsS2nIpurNcfvSiX4yCNTgZl
	f3OrQ==
X-ME-Sender: <xms:bsN1am83wwEFRjVyBKWTOj5i83ZwvQmJrGTeQaRDb7DWHMLCjWQUOQ>
    <xme:bsN1aqqbak4K5CB0mnmpOnc-1N_12a8z-Ekju24FikTYtAU6XDf-oUlcTwYEg0ONh
    sNBlzzfWxH_72bkj8ksNYNf9UMS8MZR5ALmLq9dOguwhb1Mjcydtvg>
X-ME-Received: <xmr:bsN1akhDtGA4SZLvB7pI7swGBrpVhF1_n6aLeWcPBgrRmzSuH4MzBcrg9pM>
X-ME-Proxy-Cause: dmFkZTEfW3x2Qrq7ELqxlr/x69vk0aYaa/E/2AWrFAl7yu0Vg+jIGlS0mjOCk5J5e5/NJH
    T3J+l8M+cQ15gxg/u6FQhwxKudsrf7tN5cWcEThveGDS0KcOU0uMrzGx0YBmylEV4PfT2X
    SbTqClZY3SINVohR/2NzYRxeOu5tU+SgKqY1sS5oM8U15+ky277S+G1Ww7YAUM5Z6EK46p
    TQK1COWwyEQl/dhwe51H5lWCLFzTj8K9hkk/JBO/DvOgEgoe5sMihzFP04eKTIrZCF8dte
    tQwhoNU+zszgTlPncqprVsvTwAgpjyPciGBDZXKQScTz4u1orAuTZg8Fi2VomZsbF2qQLb
    zIB6vfCNv4v0dcseiUkN3H0nffdrzRAjDXnr/zcE4pHIWwhQSIJcHpNKfPSSatE5vtlSwn
    DtWUIKhvp1jGXwuxT4icZJ7eqOMoDp9O3eN/sGEFk1QcUkAUefbMoY+f6cBb/eCJOZp5Fv
    w3A5qOkKNQDIKdjK3fDOPysd5GAuUjiWQZW+5CYr0Pg9TIHi8EHfQKgk6Ip7WUVR5HqKPp
    DudH9yV/0Ag4i+mp5KiXkaccnRZFhzimORXQyyVo6QHCrlCjus7skssIHkNSCl2guqkiYo
    UOZv3k9Fp2gNbtDp0Cw80/IB3MeBJb4AXGUJW88X/CQw/EcsEbAANNWBqb5Q
X-ME-Proxy: <xmx:bsN1aoBmbwnFl-v7J8Y3SvJmF_Iw9I-XYpA2aLheutpBEZUdKDYKdA>
    <xmx:bsN1aiv3TWe3FxxdVeJzjKDJX51ZMwZgn9Dt_WQTfJAQl6UdSUfthQ>
    <xmx:bsN1ai7xLy3fvaCW9ByTSM7DxuO5vQn44k37ZaXoV9DyV8RJiD1udQ>
    <xmx:bsN1ascqctpHOnl9y6vlp5EyiekHfp49MID7uFphqvHO1Nt2MFbhqQ>
    <xmx:bsN1ard8Ua1EsWgVSAxSLBr_UbQwYAS8EhFtLBuT4oNf5-Rn2im3xTf8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:18 -0400 (EDT)
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
Subject: [PATCH v2 11/17] selftests/mm: cover a shared-source collapse write race
Date: Fri,  7 Aug 2026 12:36:41 +0100
Message-ID: <20260807113647.3744609-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 34622120002
X-Stat-Signature: a8n6debq3pe7epzak11k4gw1d6x714hh
X-HE-Tag: 1786102640-51183
X-HE-Meta: U2FsdGVkX1/61ITJ9sdlZr2ahHiC2RGpuxwCbC+gw0uo+1vBswftO/q3m1yIBFqtO3MlwqNi7yCTXSAkKt6qETElF/1kKYqW31fT2Y7zVRUobV3rYQnMpqn7DnDpGequdkX00ODI4g/qhKvq2VCmkRl12V+W+g9GHJUhS+qpyb1ZVrLnr8qVGBr6GxfqLqeRIiEoB5NGURJ6aTydf1xPtEyPxcO0fWsqpKL2ga5qbpZbWw+7y1Krf4cJ4G6ZDlmGAJogWy1XGKkpGbydRvCKZDVmnzVPjMB268hraNY1wfXa6xhWJ+9O3kMnI1sHrQTCBSoE7D7qWBjfohCOxp6sOHOK28PRbmNdXCF9VZHT+cLxxzhWBWVbo6U4lW8pcwilqnn9Vfs0SY9910sov9Va16z80+8C1I34M+ubrzQBN27yUla+5RUJh0tRttZvvXS4HW4aLAs6mradyZDoJ8iHLokJqHhv13gvhTXM4fblIrdA02oHuNh7tzIIkFSYE9Yl/w0DX0sBbMumXq+QW3RXEQ0I/zA+BMKCttX0jeVdhpiEcQOQh0aZJ0Iw0cQzD4AVICjX66M/XlCC0jl7MJ/WqNE6Lxv416tAm++4/O/5/oLDSUDi9UDA8HEjLqMU4Yvuno4qR5UxJp5OgwdRK9RiH25hbI8/Ym9FKDDJ360LVYk3bZ1s73OSNNokgUubgpwUsyO8t1Rp/FMACrpY9YUL37Nc75xBw0GGFWTHhd+znUPJiHnWhcv2q6BmzRpu5tmLDcLMFqKNeokc+CQW9yYK5tzfnHCaOzJU9VY+IiOki3dHnUZohXBrWJz4ZSY+yi8NTmo3o5W3GxJR56YIHjibgTZrqArDsy6LUg1pGFw3lhMWDI2NDBRiQuCQERbGqXlvyefxO0+HAAO7IGZNO4nbPjiFYSHF9JM353wY6gtemAzvTBVEpP+GnLDK0y9LW1UyIulw23sM/0NeRcKXLw2
 lBAAo5SO
 VVzl4Zn6EY3/5OBQDN91xB58yk8Uc/sBdEuV5z4J7W+Nb6EcA9AvGfMJ0fmjRfkMG8dEL42Qc8K+ZOAPZa940ZCFAIpXlCfY7pJxpVQUTzPA/ovEnYu6bFWtL0gT0HcNBgOkZBFAadhQ70qq+lrRPJyAHvb8ZaWT004nmC2gqGI5TexftfJKgPWK3nDf0KCsQEMNZilFtlTWu3qguum3M0zHlCmNhkEcB3znioEVsKNCMoYocbhp2yYV0bAPJozw+8JebDRSy+pus+mRDLdTyp0w3kDkql7vQbGQm2eSsJiikraLWeH7p/w7PYB2YolzpJwyItI/L3s71K9OQ16imBMqnDA0+DIlF0VOWRLKu0bC+7VBacYRXqON/fBH26e4/vARNUC2grNL0/wlFSekMFGDLmxIKW+KHCmgMDXDQOXehTkkBaRNNGsYwK0xChFuieBDb1BNUrs7dSKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_fork checks that a fork-shared range collapses in the process
that asks for it while the co-sharer keeps its own page, but the co-sharer
sits still while that happens.

Add a case where the co-sharer writes to the shared range throughout the
collapse.  CoW has to keep the two sides apart under those writes: the
collapsing child must see the content from before the fork, and the
writing parent must see only its own writes.

It passes on an unmodified kernel, so it pins down isolation that
khugepaged collapse already provides.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 69 +++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index d3ff1b196e09..a5683f08694f 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1225,6 +1225,72 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/*
+ * Content stays isolated while a co-sharer writes concurrently. A shared
+ * source is copied live (not frozen), relying on it being CoW - immutable
+ * for the duration of the copy; a co-sharer's write goes to a CoW copy. The
+ * collapsing child must see the pre-fork content, the writing parent only
+ * its own writes.
+ */
+static void collapse_fork_cow_race(struct collapse_context *c, struct mem_ops *ops)
+{
+	const unsigned long shared = 64 * page_size;
+	const int stride = page_size / sizeof(int);
+	int wstatus, child_status, i, n = shared / page_size;
+	/* volatile: the loop below must really store, on every iteration */
+	volatile int *ip;
+	void *p;
+
+	p = ops->setup_area(1);
+	ip = p;
+	ops->fault(p, 0, shared);		/* shared prefix, pre-fork pattern */
+
+	ksft_print_msg("Fork, collapse in the child while the parent rewrites...");
+	if (!fork()) {
+		int collapse_status;
+
+		ops->fault(p, shared, hpage_pmd_size);	/* private remainder */
+		c->collapse("Collapse a range shared with a writing co-sharer",
+			    p, 1, ops, true);
+		collapse_status = exit_status;
+		for (i = 0; i < n; i++)
+			if (ip[i * stride] != i + 0xdead0000)
+				break;
+		if (i == n)
+			success("OK");
+		else
+			fail("Fail: child content");
+		/* The content check must not bury a failed collapse. */
+		if (exit_status != KSFT_FAIL)
+			exit_status = collapse_status;
+		ops->cleanup_area(p, hpage_pmd_size);
+		_exit(exit_status);
+	}
+
+	/* Hammer the parent's own writes over the shared prefix. */
+	for (int it = 0; it < 200000; it++)
+		for (i = 0; i < n; i++)
+			ip[i * stride] = i + 0xbeef0000;
+
+	wait(&wstatus);
+	/* A child that died reading the racing pages is a failure, not a zero. */
+	child_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;
+
+	ksft_print_msg("Check the parent sees only its own writes...");
+	for (i = 0; i < n; i++)
+		if (ip[i * stride] != i + 0xbeef0000)
+			break;
+	if (i == n)
+		success("OK");
+	else
+		fail("Fail: parent content");
+	ops->cleanup_area(p, hpage_pmd_size);
+	/* Same again: our own check must not bury the child's verdict. */
+	if (exit_status != KSFT_FAIL)
+		exit_status = child_status;
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void madvise_collapse_existing_thps(struct collapse_context *c,
 					   struct mem_ops *ops)
 {
@@ -1778,6 +1844,9 @@ int main(int argc, char **argv)
 	TEST(collapse_max_ptes_shared, khugepaged_context, anon_ops);
 	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
 
+	TEST(collapse_fork_cow_race, khugepaged_context, anon_ops);
+	TEST(collapse_fork_cow_race, madvise_context, anon_ops);
+
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_write_file_read_ops);
-- 
2.54.0


