Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3403C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812BA6B075D; Fri, 14 Aug 2026 21:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9436B075F; Fri, 14 Aug 2026 21:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D98C6B0760; Fri, 14 Aug 2026 21:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 394896B075D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7031A2821
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:31 +0000 (UTC)
X-FDA: 85101846942.24.8525BC8
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5EE0160005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h zITPJN";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="G9G/E9HX";
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759169;
	b=ZmM7zZ07TGz+Qd/La4VZG69XakLBomDrVbFd4simDWyehXHwj9OJFvVRHau4c5+l9PHQvD
	50ihW8Eh7oOT/XOkBv0ZfRN4aYCuKf3GermwZmce4W9wKrH3YuzQQ1JVqlLNIivSjSEKkQ
	7H6ebrcomYdqnYI10SVF8IRx9+FFUEc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h zITPJN";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="G9G/E9HX";
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/N4uH7e9xwqe95L8EVPoUAk/HrCwQSNsTbS9xlOgGE=;
	b=IpRGBBRWKL+3Nn94EIa5tTZWO+0SS7g6mxQnMZQruLXIw21LaBmHpqRnNI0tkfe1dWc1DG
	99e+r/WMyj+y6Mxlmudj5G9heRCBS3OAYbobroFRjj/PRMae7jQfvu7pX8zP+ceQTVBDaL
	pUMgzio5QSHDQmro2AMRFgmH567Gces=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 884B8140011E;
	Fri, 14 Aug 2026 21:59:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 14 Aug 2026 21:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759169; x=
	1786845569; bh=u/N4uH7e9xwqe95L8EVPoUAk/HrCwQSNsTbS9xlOgGE=; b=h
	zITPJN91H83Wz/W0BY1/dG0cXsoMVzbyhrLEHHbizETwXdKFDBHCaZRBV1Lf81iS
	CW/XQasGuFG0/3dTp4Fl9qn/4d6OBa5oL/ZikbhFDPUpWrk18AFYKgv3bF5Vhqq3
	myxFdJ62NhhN8IGT9gsgsro8VoUDSCpnDkmcm2N27vClzb8kGF4WBpYnNxlrbefk
	Jp5GkDavEcNt4L3Q729r4sw68L2PKNImRe5mCLlQJJfXxEGGfRnseeo2tDVFPJBO
	cTqrvTzbOUZhlO19cmOtvEl6b1dHHGw+TsFYtVJPW2tDOv3Tp94Idx/G8vYE0J9y
	8VQTa5a9gLVC/NUBRGMgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759169; x=1786845569; bh=u
	/N4uH7e9xwqe95L8EVPoUAk/HrCwQSNsTbS9xlOgGE=; b=G9G/E9HXiMTOh5B2i
	mbf1cWioF7YzSd4XH0gEwRzeOCfxSR4RRIAfyWGPywd1clhGRU3Bn+FArilclWJQ
	vNqAtYbxViHytHAv0RMiqCe17gnE+t0ViL1GWBQVr1+bX4tdv8kcGxNjFuvfK/Aa
	UgIO6TFLoDMo1uMIFK8xpf+TQsw5geaoDZOsTg/xiaFa1uMkDCiN62x759IJZrpl
	CIQo9moYgdPGUoyNxCevMBW44oh4Gx6ZuOq8Hn2jPeT1ekxDceiZUJMuiC33B2fT
	8DmaZHL2tYuAtair80tP6RHY2cxsHzM73cpN6HtBh8PoksQ/K43dq88XZ402VOTN
	iqlMg==
X-ME-Sender: <xms:Ach_an4OKoHJbLfHz8scryc3fj1xgaxB12-VcGTgyceHIIXhFHi1xg>
    <xme:Ach_ag2nPzYDtce0YGvMWpME_hUoBtShXczpR3TYm8f8wAUc5yI0_Gd7BNnKP2IXS
    rWbpkvY-F9nmP8f6nHTjw2cgvHIOI3--HzilNgE-Nmcd6jqoq1_og>
X-ME-Received: <xmr:Ach_am8O6dcasafE--QeddlyZ7zwREZGmNzpeOLJt1KrhKIaiBPznfn_Gkc>
X-ME-Proxy-Cause: dmFkZTGF7teVIHNqoa5p2A8iL+trOmU4pExV0BsGEGBxavUqSy3vvyW/t2uVaC82ybAhbC
    FZe2jS418ApiE9B8lCjDVAvs2O/1hVxxIyd2QmVeomYKnxIQlXrdOkpVI2/A6aay1R5wM6
    752pE1oD84VvsYvCM8wHufwfHzQzVg5WF64m0thPV1o6CCL0N8QD0816LOjK9LaF9KdRdp
    ShDgDyNTb/bU59JqJj/g3oSWXYBnQXQHEYh7kafl/PHtgQjoSit3F73LPXI/q1yj04b//y
    CUybFuAxuhlNqjceRELXNaCNxBn+qS4c4JK+cmo8T/HSoyzm/Kml9mcKob58Fnvz9v9LWE
    nNmRLDy6osiysgx2iCEJ3pwXFBkRpHwTdMWlzFr0VzVRxFjUFgk/QX1VAGpcrxNr0+Cez4
    Te957jer6VGOf6T93BBz/Bi+W9G3xUIm82OhU9tP/yJkl6U86+aQidXFudg9c7KcHzc35U
    aRCO/dV5njQzP1yXynmLgGAtWKPTsLHZX2pa7BFJmmvUrtdwK0AqpmzVDHP2IOXhZ4LZu8
    /AHFEeuMAY4IG2J+eVWCE/1SH9hJYpCnI8mpJTva/PcuMNiwTVwiAuC3i28H/nn9npdOe1
    nLq2CauCln0aHynZYpMNoY2xUzWncmq04dwcHpKPNLb1dC57B/mxF1p889kQ
X-ME-Proxy: <xmx:Ach_ahvwYlPCNw0cH-cjqLEVaHcdXv7N7R_yXIPIzKfP00u_8J7tZg>
    <xmx:Ach_airQhPbdfQW-ZblYuWWj5lTZdfrU7VW2BS8OZfZi3VBOtOfskw>
    <xmx:Ach_asFvk5vKRrMaQ97duzdmnOgLh_61jQ0Rt2DYSyd2TvFWApitcg>
    <xmx:Ach_al4hC2jCZgAF9ohzeKjAWubnka4vDUwvrxNBL9KI5DRbJ21d5g>
    <xmx:Ach_arYa3SpCrgABFIa3eKhcOrplwSATr-XMGZGxR5Pd7hSF0Ro6kMwQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:28 -0400 (EDT)
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
Subject: [PATCH v4 12/19] selftests/mm: parameterize the mixed-source collapse case by source order
Date: Sat, 15 Aug 2026 02:58:54 +0100
Message-ID: <20260815015901.1236937-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5EE0160005
X-Rspam-User: 
X-Stat-Signature: kxhgcucb1mhfw59ukttksu4eba7q9aad
X-Rspamd-Server: rspam06
X-HE-Tag: 1786759169-331947
X-HE-Meta: U2FsdGVkX1/73n/DpNvFNKuAAZCvDGnrsEDqSStCfcQq5Mxjyx36rPLAgnBhACnvM2n6iHx6ZePmEEyykRE9Q6ySEfqAOOPn2QlPX32KOQsck/rzsyoWwUbFxqFLZpkUdVZOXKoBl6k+y4CNxWoygMD9FimFA0oZfJlfJIvGshdgkkDmg7qVdC9tv4wkgK2VVn5lZ4/iI2IzzwfAIRrmLAoJsWzFSh3ZC/Z4nn9LfHMUC5bPOIMDB48NTT3ho3abU4F8rvuxwb2D9x4cBjVLSg9/Iq4flmD7GsrebCUvWcX0M8ov3J4hfPMHiwpLE9sgrswFxOJB/ord7uRoESGkG/gbLDu9V6rhiikILLvOVMs1jRUe2W0YJJTstptjcj/782Ojxro70TvZsSIEUo3TbRPdmipgD3n6y66x8f+lZM4x34AfDbZIdYemDCiGVEB39dqUs/Lt+sa8c/7xRFlTEuZ5rgHbYQvACpNowrz/g8WvfFM7FwsFl8o8PF/LnCKhGaFvIdoko3zkSBsEBmciS8KrCSQ0kPTHCes78vETvFo/HZr7buBQwotHbFrOy+hDo4XXsl/R93Qcg+4gofRhfutk3rlrkKteUTwd3sDKlGzvgyaeVu+JgFcyQS4kkqVVPYtxbzuLW/AIE9btbEDbdkmG8y2g3M2ynGTKU6umRJoWRfxqLnhIbRSUkKcoLUjL2ATpVeMvv+rv8nN4VSuUfOyW+hZX0ktUJt4UxSdxnU9pDpg2dOaZAwagQlSQRKcalBaxzCr4tAAo5GWjlYkC3Fc9iqcvub4Su/PEqu7GtnzQBGACjGtDsRn0uo29nuxx0YhgHbDHmQjgfp0AcIF9tG3EchsY3kjgHdhy9xVhK8ZEEnZidF2X+eAOGW3yA1rIXcpbYfBAxxiuTYvk4oZ3kCCgwl6VWiWfK2JLnxCE5RITBbpMx/VJKIKZ1vCrMsvZ0BaSrAjD9v8cW30oiBa
 WtG4N7K4
 HffT4teRhXAoNLZB+aG5apV1PBSSE/YxqRA9NPWyhKszVHlW8M/me96wqoC6QX3hHtXaajpWuiS73p76vpJ7oXUcreymuY8yYSLjo3DU2SsUReytaQc3PgOBQd3gHrZNbdO1nnjhYNSY72nYzq7jFbpQtwLcldMw1yNqEks85+dttW01fO4ZuqzRu+1tLpwgzQighZar8KvCO7rEx4T9lTOV2Z/T4TKBC2POhfRr8BU9Cu/W5xizmh3+tRS94H4N1lfRmu97gosu1YnjCUUBQLDkkqv+20bjtaZKO0QJR33uNq8G039g9uny2yXdAgfwTZMCjCk80Z9dqI+1rLwDfAgbWnxmtHdACELoARLwZmQviIC9VwJgLgykcBgyzzAGk9AC831CadjeQwlm1Yae+kB6/G8zGEbHzJWRcyAfsSTFeHB4R39gePL5xMso+b5jGerlDjqHKWkVFcgzrm9/mu8c1cgLztQ9tUw+0aScjrI81NHSZ3a8em8TxT5JE8kCOSC6c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_order_mixed_sources() faults its region as order-2 folios and
collapses them to the -c target.  Order 2 sits below the contpte threshold
on both arm64 page-size configurations, so nothing in this suite unfolds a
contpte source on purpose.

Let -s name the source order alongside -c.  The case then faults at that
order, keeping order 2 when -s is absent, and the source order has to be a
supported mTHP order below the target.  The other mTHP cases are
unaffected: mthp_push_target_order() enables only the target order.

"-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
larger mTHP.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 0489967d6ee0..1844ddd77b59 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1389,10 +1389,13 @@ static void collapse_order_max_ptes_none(struct collapse_context *c,
 static void collapse_order_mixed_sources(struct collapse_context *c,
 					 struct mem_ops *ops)
 {
+	int source_order = anon_order ? anon_order : MIN_MTHP_ORDER;
 	struct thp_settings settings;
 	void *p;
 
-	if (collapse_order <= MIN_MTHP_ORDER) {
+	/* Sources must be a supported mTHP order strictly below the target. */
+	if (source_order >= collapse_order ||
+	    !(thp_supported_orders() & (1UL << source_order))) {
 		ksft_test_result_skip("%s: no source order below target\n",
 				      __func__);
 		return;
@@ -1400,23 +1403,22 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 
 	mthp_push_target_order();
 
-	/* Fault the whole region as order-MIN_MTHP_ORDER folios. */
+	/* Fault the whole region as order-@source_order folios. */
 	settings = *thp_current_settings();
-	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	settings.hugepages[source_order].enabled = THP_ALWAYS;
 	thp_push_settings(&settings);
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 	thp_pop_settings();
 
 	/*
-	 * The order is enabled, but the allocator can still fall back under
-	 * fragmentation.  That leaves nothing to collapse from, which is the
-	 * machine's answer rather than a reason to end the run.
+	 * The order is enabled and supported, but the allocator can still fall
+	 * back under fragmentation.  That leaves nothing to collapse from,
+	 * which is the machine's answer rather than a reason to end the run.
 	 */
-	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, MIN_MTHP_ORDER,
+	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, source_order,
 					     pagemap_fd, kpageflags_fd)) {
-		ksft_print_msg("No order-%d sources to collapse...",
-			       MIN_MTHP_ORDER);
+		ksft_print_msg("No order-%d sources to collapse...", source_order);
 		skip("Skip");
 		ops->cleanup_area(p, hpage_pmd_size);
 		thp_pop_settings();
@@ -1425,7 +1427,8 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 	}
 
 	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
-	ksft_print_msg("Collapse region backed by smaller large folios...");
+	ksft_print_msg("Collapse region backed by order-%d sources...",
+		       source_order);
 	if (!khugepaged_wait_full_pass())
 		fail("Timeout");
 	else if (window_collapsed(p, hpage_pmd_size))
@@ -1456,6 +1459,8 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    With -s, -s names the mTHP source order for the\n");
+	fprintf(stderr,	"\t\t    mixed-source case (source order below the target).\n");
 	exit(1);
 }
 
-- 
2.54.0


