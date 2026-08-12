Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2222DC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF6B6B0145; Wed, 12 Aug 2026 09:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C816B0147; Wed, 12 Aug 2026 09:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33EB6B0148; Wed, 12 Aug 2026 09:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7F1A6B0145
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E7751A03AF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:43 +0000 (UTC)
X-FDA: 85092684726.15.AC08829
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf24.hostedemail.com (Postfix) with ESMTP id 53A4E180007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u hASvvD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=BLzgpCa1;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541021;
	b=y+6koAFWrFoz39b21G/JWfjAtTNmWMTBU3CjwNNDQ4O+0Tz2RrpfFV1J1ZDwVJ6mZhu4ll
	QrsbERhsz8PrcQDScr0dOg1R8zI0KOdSS48PnyMaTLGxqAHxx1hezfUllOsvQse3VqG4OT
	N/Ij/s/J9rSJYqzx3QqW1k40KUTqSi4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u hASvvD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=BLzgpCa1;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yE9UcmZWN8CYeDypZM4ijLjNlZ/odamXd7gxHiGqY8Q=;
	b=CyVokWbnvfj+7mrdhxoswA1UZ25tQWuvKVXUMNiIlj8ZxNZKXxbHEbe/Qq/jikBK9jcOkA
	eL43MtXtgzrnJOuRM+dKny4b419rIkVrRTTWfRCx1PlgfiUmA1OpMtypESBpEi8YXF3Prw
	pyOf0Q986i7SoA3Jjh7sK6fdU0HpFLc=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2E3357A0176;
	Wed, 12 Aug 2026 09:23:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 12 Aug 2026 09:23:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541020; x=
	1786627420; bh=yE9UcmZWN8CYeDypZM4ijLjNlZ/odamXd7gxHiGqY8Q=; b=u
	hASvvD7GOICdfoUSDkwvcr6MX9Vjo+PMCAx2KtGmcxRqgEpZKxMd/eKMLzP+HmC4
	hzCd44Fns4gIdUZ+IsBC8SBRewsa36m01xE2pw/QzoIfRLnASyENuLC1zR/82e5B
	HgtkAcfrxQ+22/4ZWHmal45bbi4M5kiXpAudHDhGhVVKtiQVOC8xM2NNJuK1kiRJ
	EHIkxrXgMiGF8RpP7Zx+Hc73ADIoKjzqi9ZesA1X+jOjeDu0wVnOkXZnDWGybX7G
	LDYvUmFIt1mJy36cmrxHK+SmmE4XKxckQEur71fzrqQD8gStL3Ar+BCj5eYZsRgg
	+7O6wa562NK1IWPzenO4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541020; x=1786627420; bh=y
	E9UcmZWN8CYeDypZM4ijLjNlZ/odamXd7gxHiGqY8Q=; b=BLzgpCa1S2kn7xZeV
	2LeFbPCgkhGmw+Hw0U6ntUMsMrg9Oe1xF5IyYAikp7vZpH6WlJlRjNrFjcEaaE4M
	P8zAjw0mYsuqXchpvtcDC5CoImsX8lQ7EU0YwhPWZ3bMSJG/zgSPt9rsCu5l3CJW
	yEZxFzh1wEBoCBXb1FYvqE5/fx8fC1GDNGgIpVf41yZ54p+vNs7VBRNaII+wNxxZ
	TZrp+39ejrWWNapiL48k5xqaS3aQaDSsbk4ujlDI7ZQLIHJCpJlF4wh6d769v0nl
	pxinCaIpmwvELQXCeJ5g6/OG5TQc9D+FlLbRS+X0LTpfdGTTRCXlHP1JSX6KIXJL
	EBxsQ==
X-ME-Sender: <xms:23N8aoY8-jGmFjNrfkpCSq7wjP_Xdu-tJ7WaGJuPiWEaL0lq-DKhuQ>
    <xme:23N8anVwnueuqhCpQom-tQxs5R2ar8C4Wxt7iU1ecBiNYQHQmMUmbzAbSPhCeytsx
    2ayXkpfcNvjuAjHf_VyLvE0ADSD-rtAkrmMhkhhS0f57Vo-wLDG75pI>
X-ME-Received: <xmr:23N8arc_GGIqpzaHKTaU5gtPiIyCdzkRaiOdTPY_ZueBetSqD2lZVIApL_c>
X-ME-Proxy-Cause: dmFkZTEJjeAG5mPidrlxx5WYeorxbJVgJIKvTA5wXegfbw/cux8oxcUciNIpDIuTJE+lqf
    6MvKMtIYnfrpE9CE9brIFiUghXXeSu7acy7yTiQzGdGRUaVwSNB0Wtfy8GXhxbblHF9PD0
    zPXwLCOAHUDQMRV+OGFoRd51Bfw/8mHZFt6NMjCskGz8KRys5NyppP3tQz3pg+1FIu5GBp
    PJQAWgZTF13VhomE3d+3g7Xo8LQtMXvrRUSh5YzlZkIRUVCw4Olhx0/o/iEmltBto/jcsB
    4mCen6EwKCCQNN9U1Ldmtp3E1EMhPbaX1d9tgEecmRx82uYLegpVLGl6lWthe5rRIcaIdx
    /lwSL5gwXuq3E4Lw/HBc9fXact2cFi1yiSHQEFhRz3naFma7cY/dEuMeG761JoaF7Uof1w
    yNYdpA0Vx0SkMA85H6uqkKj9m0fa07KOU7GdORi9GqP018gPW4vRu1GctHkp9pcAKQr9VY
    V6xLlZDxU4h1joU2gZbKO9mvfcFNQ3VDN5H8Abq4XpZHcYQlGaJC3eev6f8qvLelEul0qw
    MWLochdmzlZ5pPWIk+kn8fAx8gPJfBacUdqwsMyz2EcS75QJjh7GVkvlKwhnSVI9gZPKn5
    B0l+LcBLnsBrLvRbM/n1z5H6gofPVqbnt06qPATKf9PLHA1qbXOIxeQ6u2OA
X-ME-Proxy: <xmx:23N8asObIW7XLdxBlMTI2wczTo9N0LKECiBO6z5jgKl2PW2_c68GXw>
    <xmx:23N8arLWzJZESbUxovY-v-MyZXt5KqMONASiINnr0qy1k0du4YAJ8A>
    <xmx:23N8aqlnfIURKb5KhpWU-M_MkqeN-5LUYteu_igVqmGTp_Rfj4E3YQ>
    <xmx:23N8aiYf1whinKFWw6Yyajg6MFpUTMueX9rLglGvM1Z3N_Bq9_VAKg>
    <xmx:3HN8aj55Fu0D0P2gcJZoE0hByFuIlzdqUH76NoCO1sLpYlPZqQMk9F9A>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:39 -0400 (EDT)
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
Subject: [PATCH v3 12/18] selftests/mm: cover a shared-source collapse write race
Date: Wed, 12 Aug 2026 14:22:58 +0100
Message-ID: <20260812132304.199287-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 53A4E180007
X-Stat-Signature: 8y495taujg7bj6cf8siqhjxtfeeg9mfh
X-HE-Tag: 1786541021-887957
X-HE-Meta: U2FsdGVkX1/sDiS+PZ0fo4ZeyOsLwMr1LjsrryKkXl47ZkLw9Q0jyPXpqebfbSpbdlw9mhDJg7dFqpPZTe5uVvAiMd0lG05WPQREFFobhR2pS2cqRUoEve54JC2Y7344nPzJzqS3RD3yS17uWfytSIVvEQxbuJ6QiT+3JhYEidpR5DZfzV7jz5XBOe5VkQ7qW/hf1oNe3pZcDFEeO5elES9kvZuzueho+NNoQpfPP0ZZ/lZWBZnlvgbgLXlPlhL2TssV7X3E/cu3ddElg18/KDD95JYM3AqU9EPoZNFaAAZCcXosRGOVqLMgtAsUPva4cC6GJ/gRgjxeYnoPJapZKI/mT/VGU5xkYxtDqkFzKaulRAFVrobI+8Cre1rBqQYaHCU89sspnjjTCnAesrxe9FBFN5tadmB/2gX+TdNXfqr6Ll2vu3FUQIWGIhwaQCm3s2/ddygcVTxr1gQFvszNDn/rc/oCY73ZzMFUIGGXEI2h9vBXPbBiIgFjnpshAjYGmvoFfIIrYOTffoSDNy924A5e9tadmoev4L5A/NhWC5AfeVr/vHvGbI33qVveAeuZVUdou1y5HDZ5O96Sp+gsrQwMrzn9V/kQFXmiLrJqxjngIl1f7wAb3SS9TmG8VWO1ZWeih2/smhtNPC1DAkbhBGuqI2MFnFVqVJsNHgEsYhqyiUopHV4a6P6ORud5CZKLCQaytinMSuzaPktr9v2fgL1nT4UVJxWHbET3wa+PTP5yiPS3zp8EM3dswKeW0LyTuTHmXeR+ed99dxpzPOa5Obgfo8Hrsp1q4SEJdd+1OdUhc7iLGUTF6pugXNWIAHWRui74/4VicVwmgjyH9fBuNyDU+Cp4Zl46eCIyj6XM+PIbtel+SnpBdExrrMdBV4k0j7f2kTj/CxzwRFNyZZvUe8M1JHmqrPP1hEw73jM426yxcE42mCR55c6FJiA7Ajv7JXYyvlaSMCmV+vIWPSj
 MyIre23r
 E/0ZwZpf3qsezuyHvz70nh638E7aKjk9hR2etLPHAhmJEfN2EyXwM1otIkjU2rkNLg44QAVRgDFxsnbN2scAGI/CksKok5bZr+hA8WKuyGeEmkLC8frVfUkSZ/asNEtYvX6oVXVn+2HjTqNMdPPZ9Az7rdw5WNRrQo8JJAWoe6DuwI5lYuxwE9F3PDsIQATBfakJg0Saky6SNkkJ4dlQblUEdiEuJ8drtVw/I8VuM54TE4+9QzbzRXroy8/G+grZOiwhfle7Yv5AzR7XYgu3ZlFu0Q0SSJC1dL7MVuSZK1RZUx1vFab+xmB8dnk2ycWIPbqCIj7iKsODyM+Q3fcB1HtslMUeRVftpxY0bYwtGRi6Y5/V1BiZZ2M5O7zBb1rXqVvu/rjd9rUX5JoXJjSnwb4ea407RiCHRXuJo4uKQa4sFn+76OJSshD2fesbBkzDfYuWZTrqXjTDKOsjRcVEeG1oNlJsX7im+CDHyPSR6PhLw1QAse8Gn0ET3v0zm1T5NeztL
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 69 +++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3099e7b720d9..9c8830fed0a2 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1207,6 +1207,72 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
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
@@ -1770,6 +1836,9 @@ int main(int argc, char **argv)
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


