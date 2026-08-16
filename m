Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D87DCC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813266B08B5; Sun, 16 Aug 2026 18:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF906B08B8; Sun, 16 Aug 2026 18:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3566B08B7; Sun, 16 Aug 2026 18:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 292F06B08B3
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:48:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C56814064C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:58 +0000 (UTC)
X-FDA: 85108621836.25.18247BA
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3F87B160006
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="H gHGN44";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=G8U1xcnF;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVoKODTNuHH9tsvnWaADZQ9VZLR8etvBsMTlfNVNhEw=;
	b=JJWYaX+56JhhcCdAQ0GMfM2c2XGKim1Ocyrd9Hs0HMKZFh4JCijjlrif9axkrmg9xBH4uC
	2Uznx8swdg9duozLZogoNyWSNFvx+q6nC6VtKW6Wt/UgyFLC/0ISbRlQ9lVN3eOZSUrKcb
	NMaNVmbt7XIz3bf1fk2759tm4bbskO4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="H gHGN44";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=G8U1xcnF;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920476;
	b=uKByzMw3WSnaGEEmJGkoxCJtQ4P6OsIV6u2DET9vkvN8RUL1SP6XXqIwPzjrKkgtAKryab
	wRgo6R1pLsxSmEcpg2dwWIAtw4K/5czr0pb1o6jLzWPmtqXakHYQDJ+P65IfAgKzFCdX6m
	VC6vlODdrso1962a26/5nP8T5S6vRBE=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C871A14000FB;
	Sun, 16 Aug 2026 18:47:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Sun, 16 Aug 2026 18:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920475; x=
	1787006875; bh=YVoKODTNuHH9tsvnWaADZQ9VZLR8etvBsMTlfNVNhEw=; b=H
	gHGN44biqF8ui1hgPrOaWlVx9x42CW2TrTQ1MBpnq9uZohHvhs9TFO8COYmiBtCQ
	x092f/nn0bFsT4jxcfIqh4yGHRauPzg3rM62tQd+rliAmvov/yjuGh8SL0B1rWY+
	hbGt5HaX9ZWi+CPjnEF7Gpu06s9ZzxKtL25W+JLXAm5m95PwqT58EM1QRCpYQ8Y8
	A9SznxPCoxfH4y21kjuZpwwI58y6krWsOdIdjexXUSbQAu/m2ylSEVTAiMpyulSj
	Mf89HJ7jwuv3gx0AfmaaIxd4QsMTQ3GFYKUXKqbtO6l7ASEFDRt1X9lgRkWYJoMx
	qHj4B8Rlg2SfjUyO/jiNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920475; x=1787006875; bh=Y
	VoKODTNuHH9tsvnWaADZQ9VZLR8etvBsMTlfNVNhEw=; b=G8U1xcnFalpJlNLkp
	cMJJl5lDt/0JdgftmpIqkcaVJ5istmKoLWtdXShZo572ZMnXxNWs8lUmlTfJuUVZ
	sJ0oKdAlnJeAEi8RfwsAi7Zow0AhAJpDGHKGFzUYuC9vKVZZ3PpKIcX1iGaU62fD
	ZbuD7OgEZo5Gu2GQntxsilcY+newcgsOQAAVWUddpN6x81U7xrB9zkrs+XTN8Iau
	jK2PJm6aPa/liiZhSlJ0HCJGn0lbtkeauX7LWN/kL/puId4wJ7pGTwhBDeEaN/Yb
	mXxkUN6NBnt2KB3cpwfp7jM+S6qVsdwcameuR29CIdoVXBb0UioyoXaPv5xBveZP
	C9zig==
X-ME-Sender: <xms:Gz6Caoal4FlStzYDBFIdE2tm2uGtShL8G4GQm3nQnWZ68beuoa9j3A>
    <xme:Gz6CaosTWK9QhJo2s8EFtvVm1tqYtKMLXaXM5lwdY41GHSphMHiSeNndnIxgi9agA
    PEoX_eIHdkVxqfE2UqxNMHFdx4Fc9pGihXX_HG9h2fP3_DzP7bZ0z8>
X-ME-Received: <xmr:Gz6CavArAbWlv_aIh7Wts9Fp_BPY0_i62aAeUQpeiBVUDzwHo111WdiXB_o>
X-ME-Proxy-Cause: dmFkZTFX8QZ1Abcp//ElmtP0wYUsUMnb+KjPA544aOlJXhXcQAudkXa81C9Rj4L11ediC/
    SYpDnD1LvcyFEAv2YFQNL3ReIx6t28G7cFOXvsWQqNdQRv24cIelnnbcWrHqur16sY2q+b
    PHK84xbhjrx0R6ZFbdj3lDcQr+wbYteZ9PHsSvZgjQoovnxRkTlpJXxI+K+aK0DY9MqaWr
    nM0jSjvJAOtmNeFdTIuI9VxKMOFqeJI9DUUNBafqnTlsaU2K5w1xy/oDJpRmozGKRfcEpJ
    T4FDpTcqBKNo58tTW6I4nVl91YkYNyFfziYdH6IV5aj62MGBqsSUtSYZnaDODTOndFzTnT
    D5+QXiNA7V0+//1GAWfYdWnFUDbJ4PKAYPebwd2vIw25LxzaUn6QnwsCjtV0vOBDOG68oD
    Oqk6cCWO4XKcdDE7GZMuUoxBQVzvFGinAnfQRKXDAj//k/5a2GjRPi+pYfH35b9i57TE0h
    XMcQaJjSBsGRFRkjnhDLw4f5+2D4nvb6hkAfT4rb9iy+9cz89AU2qog1b4xomiUSaQuLKo
    YugSHkz9PMS2Kwoq88m1eRQ5YhN8GUeGt4kbhSAlFnxsssMN8NRLY8TPq77Lu3JPp+uR9g
    JtdJwGX3/UFlAhzoIkkuyY2NCBLzeHHV6BWLrw7FTIxQWDTMxU/KKrZWRpRg
X-ME-Proxy: <xmx:Gz6CavM3xp0qemypU0qR-XBXw8eaQ3nXInSdzCphmSY01aisG6dxiA>
    <xmx:Gz6Cap5lD5H8hVGTfr395LWfMDrxzEM2tcghCsf1WL9p4_PGnJjngg>
    <xmx:Gz6Cap1Wg1plDDHzez4r8oz0vBMGOG1iNK9RW5V-1p9JWxL4thpOOQ>
    <xmx:Gz6CaopDQeVzLvBLfcI8PULfw8AQf-En0bRl2QFHJRgtK1looePk5Q>
    <xmx:Gz6Case39aqqM3ygzLuRqDDXwiYAOEZii_dRxfn08yCZjZmzQlMRp-6e>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:55 -0400 (EDT)
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
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 53/57] selftests/mm: cover collapse of mlocked ranges
Date: Sun, 16 Aug 2026 23:46:05 +0100
Message-ID: <20260816224609.308019-54-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F87B160006
X-Stat-Signature: imfwiouwxetba5x8otd5of66c6c9o6ez
X-Rspam-User: 
X-HE-Tag: 1786920476-431633
X-HE-Meta: U2FsdGVkX1+pNuaaSFe/oTuOtjkQVXQURH92BJLG/Uqrvj5kBXz3eg8GEzOP/V4Ril8TzvRcrFHVXnILChtC6RCPeuyvjmtpSW8MlbGx9XBRlTmTn/QGmkMt3NN8bWZPUjgsdwylU1OO2n9UG+6xFPzacnv6OkwSZykmmlNl2BBmHePLKgnAxU2m9XYQoVryc7q6ZHA265e9z0+6huS0ENFTfeLy8elrjjSKHuZViucXKbRkBACOTwggm+v7QCJTkVEyiBxb6lJla+O9ofweXZbtqYIW3NkowKCcggcA8OyXPEUueTDL+OGHwcSUTuZZCr59XkmzkevTWtrAxFZIcljmrSjCnBHFWInDkUdS2DANPJidAOaURI3Wf4wOlunBEKXd71q28f5MVPu/N6ZfLReS+OyEWCXZbqIpy8nvgT8zC9OKteCY/Hhd/zkyEqUFEZwYNJrbIiFP6jRr2X/bBJTIAC9fYPM5LBlOZ2vUvwMpkjTvq3wVFqbsTbofTM1eVrFf26v8jvjMGhUCLrvEgDBe616Svp63DEa+G3P9TH3kU0NPYMVevmSPWXr/FGbiXzWYsaFCJyuXd3OkNQ27EF8vH5RffamjGmXiFxm9XSN8JkwPbm+arFAyfTyZ8dBseNdcI0boc7RkifBuf+0JG8cBpTcROu5Tsq50hVW3bJk00CKv0r/LRZh/tVQwTLAhoZ+jMRmUPG2r8BWgalOTYL+7Lr8gfb8r+NcNnLkvobvp4Jjal2V8b5NFUg8SO0/gbMo8MhPlc6uQFlZ1GUT0MVCZlYSfYa1Qf4dqEzi4xXhXvkYp/mXG2oTQMa4FQ9jUVM5GANJ8fPVwguvrbVh4d6VMmsN7jv87qjR/cWNR/6pVV7i1XIJ9KTWStDmFaaWe9Shwpmh/wdMkww6cgA3tR5UbDne8dBlmffwNfpD+bmhDY3Gd7xKuc2Y7jxcV/04o9kGj5TP3ZWT79OgzdFE
 MLmY/UyY
 yVbPA8McGvL1KG4Roo46xqRM6pqXDhLmQs41DKFG+oJMSp8GMi8PNqUljxr++2RY8QWfVBgV5UiU1gTxskpTNsyYykJDVLNyqiBgbEgx5bMJea7oPNKhhXFM335L1TMiVby4p3PvnFq31Js66DPH+5//PYW3/librJ8pwJHKI5AxEoGPsBgLcw/FiZvfGGO7iZrkybRO7kldXcWhcxMHi32isQsvB17gtXNk2LTR35ch2vEYv3jEMAOypcCUmzNJMaOZ5LFs+2YHuaWLNN5yZMc1qHrggqH703jpZwvUcdF8O27YkVqHKo8OTS1mCQID954TBmBSQ13jojmW8s/kf3bBSumNx417Ug86JcB3W3hdeKXa+Ndudl+cZsoQIxcv924gJK+8QgnSefbXwXcxMzlCOFRNI+qhvHpR9/teqza6H1ELUxIyb47WAuPbciZVyIcI5Oaz7keyL5p8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Collapsing an mlocked range makes the teardown do something it does
nowhere else: the sources have to be munlocked while the destination
arrives already mlocked, and munlocking takes a reference.  So a teardown
that reaches a source before it is unfrozen fails on a refcount that is
not allowed to move.  That is the one ordering constraint in the putback
with no other way to be caught.

An mlocked range was collapsible before, as long as the whole VMA was
locked.  This case is the other shape.  mlock() over part of a VMA splits
it, leaving the locked part smaller than a PMD, which khugepaged passed
over for as long as its coverage was rooted at PMD-aligned spans.  A
partially mlocked region therefore went uncollapsed however long it lived.

Cover it deterministically: mlock a window, collapse it, check the
contents survive.  Drive it under contention too, with a thread mlocking
and munlocking random spans across the race harness's region, since the
ordering only breaks when a teardown and an mlock overlap.  The plain
racers never touch VM_LOCKED at all.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c      | 38 ++++++++++++++++++++
 tools/testing/selftests/mm/khugepaged_race.c | 29 +++++++++++++--
 2 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index b61e32566d47..208300ecb344 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1599,6 +1599,43 @@ static void collapse_order_sub_pmd_range(struct collapse_context *c,
 	__collapse_order_sub_pmd_vma(c, ops, nr_windows, __func__);
 }
 
+/*
+ * Collapse of an mlocked window: source teardown munlocks the old
+ * pages while the new folio arrives mlocked via folio_add_lru_vma().
+ * A teardown that touches the sources while they are still frozen
+ * blows up exactly here (munlock_folio() takes a reference).
+ */
+static void collapse_order_mlocked(struct collapse_context *c,
+				   struct mem_ops *ops)
+{
+	size_t window = mthp_window_size();
+	void *p;
+
+	mthp_push_target_order();
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, window);
+	if (mlock(p, window))
+		ksft_exit_fail_perror("mlock()");
+	if (!window_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse fully populated mlocked window...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (window_collapsed(p, window))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, window);
+	munlock(p, window);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 /*
  * A partially populated window in a sub-PMD VMA: population and
  * sub-PMD eligibility at once. The unfaulted slots must come back
@@ -1938,6 +1975,7 @@ int main(int argc, char **argv)
 		TEST(collapse_order_sub_pmd_vma, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_sub_pmd_range, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_sub_pmd_holes, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_mlocked, mthp_khugepaged_context, anon_ops);
 	}
 
 	TEST(collapse_full, madvise_context, anon_ops);
diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index 6682bbae0a8f..a4710130aabf 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -219,6 +219,29 @@ static void *forker_fn(void *arg)
 	return NULL;
 }
 
+/*
+ * mlock/munlock cycling over the shared areas: collapse of an mlocked
+ * range munlocks the sources at teardown and mlocks the new folio --
+ * the interaction the fuzzer caught (munlock on a frozen source) and
+ * the plain racers never drove.
+ */
+static void *mlocker_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		unsigned long page_idx = rand_page(&seed);
+		unsigned long nr = 1UL << (rand_r(&seed) % 8);	/* 1..128 pages */
+
+		if (rand_r(&seed) & 1)
+			mlock(region + page_idx * page_size, nr * page_size);
+		else
+			munlock(region + page_idx * page_size, nr * page_size);
+		usleep(rand_r(&seed) % 1000);
+	}
+	return NULL;
+}
+
 static void *mremapper_fn(void *arg)
 {
 	unsigned int seed = (unsigned long)arg;
@@ -328,14 +351,14 @@ int main(int argc, char **argv)
 {
 	static const char * const thread_names[] = {
 		"faulter", "faulter2", "dontneed", "pinner", "forker",
-		"mremapper", "pageout", "compactor",
+		"mremapper", "mlocker", "pageout", "compactor",
 	};
 	void *(*const thread_fns[])(void *) = {
 		faulter_fn, faulter_fn, dontneed_fn, pinner_fn, forker_fn,
-		mremapper_fn, pageout_fn, compactor_fn,
+		mremapper_fn, mlocker_fn, pageout_fn, compactor_fn,
 	};
 	enum { T_FAULTER, T_FAULTER2, T_DONTNEED, T_PINNER, T_FORKER,
-	       T_MREMAPPER, T_PAGEOUT, T_COMPACTOR };
+	       T_MREMAPPER, T_MLOCKER, T_PAGEOUT, T_COMPACTOR };
 	const unsigned long pageout_bit = 1UL << T_PAGEOUT;
 	const unsigned long compactor_bit = 1UL << T_COMPACTOR;
 	const int nr_threads = ARRAY_SIZE(thread_names);
-- 
2.54.0


