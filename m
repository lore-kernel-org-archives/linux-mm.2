Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC4CC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F38B6B0142; Wed, 12 Aug 2026 09:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CB496B0145; Wed, 12 Aug 2026 09:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6EA6B0146; Wed, 12 Aug 2026 09:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2985E6B0142
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3D48140389
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:40 +0000 (UTC)
X-FDA: 85092684600.12.BF7D74E
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf06.hostedemail.com (Postfix) with ESMTP id C957E180013
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V NboEGh";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RIEyJqyS;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pS5GXvFi1fnnWCzMO/zMVeDQZR9m016msjFusJIgzZw=;
	b=GbNlseX5i+90Q3kk1QeteCuOTbLNylMfPyDh+38jU/mrnmdTpp6o+olX1WCVPayN1vzpkE
	uDts22FMXsp1e3WN36DUAJK0/V5Fn1U4kN+XYdtGCDNm0ZOWuzZ7ArrwIVPtRhOqkAmG0z
	/MazX/Fmrhm1iw7IyVT6rBOULO1k8VU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V NboEGh";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RIEyJqyS;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541018;
	b=tqrW49K7XUH5KNNjW4m+BbAdSxtzArcTfx0nWwDrs27739On5Gv6f6l7KcalXMQ11pRlXR
	nx8ZMC4xiV/I3jTmrZWTuaUAGzJmkqvbKLCUl7aH26701+l3690vqnYa/47e5wkS4rOpnU
	4k+lXXBUgIh9NR3Hqk4V+dAdJS/amU4=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A6A447A0173;
	Wed, 12 Aug 2026 09:23:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 12 Aug 2026 09:23:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541017; x=
	1786627417; bh=pS5GXvFi1fnnWCzMO/zMVeDQZR9m016msjFusJIgzZw=; b=V
	NboEGhmK6Pla17ahIWFTw4i3XELykb3oHfqwW6OgeTb3LJu8CUt8hT0s9XQQTZAE
	CdC6PAU88mu3k0sU4/5PmnaWZq+w9QWvCOK0UZ+MNRr9tUffrcbpSz07N52Bc0FE
	SZ8kHK+7kWLXH2YbOdU6O+PBv1QTpsGhT7TQq5mOpMjS+0H3K9H+Nu4xD28OICUy
	COVk1wcbfKNwmJZql9r9XkDs6ax+xM13Bir+8pzy1lx1mVnaERyeKDJNuVlAvULZ
	DMvmjjZ7KmNTBu2M9pxyYxjW7FhtKDsqkPqOdyDA+42k4kKTdXiXg07m2DecEqlL
	Cdq83SEHzYvkvrbNLYAFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541017; x=1786627417; bh=p
	S5GXvFi1fnnWCzMO/zMVeDQZR9m016msjFusJIgzZw=; b=RIEyJqySDJB3Cbkll
	BW1kF8PFqZD2EzQEM5neL7nAOFvxYV/E9ilA8AEuZCrRv4TLnkRMWMQtJorifho6
	b2hlURWa/H6xpDTXuvgEKtQr2WH5yzdYIXhDAFj/Py+IFOmtggnfYpmAmYPdk0lR
	qDYhWXQYpTrZfJQvhr/o/wM22vUEhimghAGLB7Y01o7DoPYVNEtigDwYNwYoH3io
	HYEJNA9b1prHfZ8d/4HmcmHFcXSJQ2teCRPdTa1aZ2P6QMAnrbqhtVKo32v+faxE
	KV1ygVvb1L5Qhm4TIH53K63XiPhoI1QP6zw/CcQ/BlO5a41E3ttxIwpF+/6LKEC1
	rHLVw==
X-ME-Sender: <xms:2XN8agDFv2kkMl6bsL8joFhnrFlt4qCQmDXLzMonFQrQdMTby4kgaQ>
    <xme:2XN8amcoz7uajMOdOynQWduYWUTRaI2eTcjhvbxXaGLcUOvTwW_gaUBpvdibVzsW9
    xLWRzrIbWJMPAEgwChk3s3EhFFpsZEsEPzmbiUUUW1XTDWGp59uQJPw>
X-ME-Received: <xmr:2XN8asH9Me_Qx8ktAVwJynKrhpkQk_vPXG9nzbVDLpzaA7XaF5kBRqjWwX0>
X-ME-Proxy-Cause: dmFkZTFkdXlhB1yyyGZX3J7dnv16PFzu5W734vHfSlZD/y8c/c/hfyf9JcTqEblNR0Fovw
    r+VLRtLwlZT2tYuTqMJsjjjBxJMgoAM7D6pmLt36lViB2yT50Uubj7I3KQF8rzeVMBK9wq
    rm57aKmY5NwWN7q607eE1gnukbthccXm6lhrmbDGqX6XovHG8JRMLfqJj+jBW3X680r35h
    P9o/w0aRWYBwLgRKYH9oTyb2lbiE5fXNRZyQYMHMmm7yuduJ70EU4YPdENzrqcZn4mtIUi
    PPdmMfUKqzUyYVrtf6UgPYBrZU3VzLkrgoUPTsKVKEpiHQHdj45X731bFwNLlQpPGy3QFN
    V7dgSNKYqlBiXdTHQIw/lw5HlTJhpNpUrF9ugBKaUaWKSH5j7b1IYg/YApSXWwvfWBfuhr
    QAXox8IkePgY6WG5m4Oynz5vJSaOTxCdYVSLz9VnAkaKtkRO/FBY+OQ3RH210u/pRfffHq
    w5bIr5qXPR2cA9VuUDzpQKZTnAgtC/nBo+NNBNXkcdlA94Bxo1TKm8bb7GlOnfSIqIBOaK
    J4PtG3ednYkGlLmWVW0qLO319MeCqp/3M3mmL2oqfVzkWFmpPYaL8PhukIYOudoQ9MI0En
    8bK9jL1xCgVmT/Wthen8UJ7B7wOIpYEHlydIpTC1Td5KcLGLtrRIiwlFfnFQ
X-ME-Proxy: <xmx:2XN8agWCDIAgNyK-484kYDai7wVa3vrMyVY5yxEuyJ0E34ow_YpSCQ>
    <xmx:2XN8aswsiMNPeQbzEf2oqtlVfghaaVHcnap93-EI0BebUITn2mKLOg>
    <xmx:2XN8artsk8wYWIprdWGR2a030PqmARjSuwdE6HXtMY5bDNhcn93FIQ>
    <xmx:2XN8atBzykQHw2b6S1aTku59c6Va2ElDMQ84Ti1l-xJ6kybvLX6Msw>
    <xmx:2XN8aljNVfoWXa6BQ1tceti8DVu9CNmAVEvlIb1KVqQstwoCqfTCrnwo>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:36 -0400 (EDT)
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
Subject: [PATCH v3 11/18] selftests/mm: parameterize the mixed-source collapse case by source order
Date: Wed, 12 Aug 2026 14:22:57 +0100
Message-ID: <20260812132304.199287-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C957E180013
X-Stat-Signature: 8q886ndhkdkz85xtcnmp5f376g3faomi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786541018-913574
X-HE-Meta: U2FsdGVkX19pr/As+Rs4KtfWYk7/X3Js1/JcRCie6HshFhkPo0f519Bxp/lQMSsDd+zcuecUo3XPZeo9TNJ8tESvsBTWcm1tfkjLMBQPLl2l2vv+zjP4egOztqes6l2jrTBBdeNOOHKLPyfJQL8rQ7THcRb/W0dJ8Xc708MTw1LsUD6ODkjkYuzQ+gE0HqMuYk6Lwjao6yF7BMI84swFXeTzjIQZetDIrG2z5ajnhFAiukAbYyEIWOS5wl9RK0dYH0aw4dUSBnYBT+vD3rmb+JFFeyNk4yqdVbjkWWl1cUOh+aSS20ebBWqjp+W4Ca0+TnpQh9BsosqWbwKgR5e7UoLY4mUfTLWmghu7vIdouB6UH7/1uhoG5aSfum505BL3gnudWwCFQILaJtO8Qmbj1GlGlmwvfAFR6oRCfJK1a7XzIAYq+8GxegaG9j+voX/eB4NA04SQcwtHHpLdLtFi7CLIb/M2qjeMPYCe3YgpGhlEeLBGGRdLDpIHUac2kGRSAtznSZyQPGI73pc3po/Io2xJujaSiYx56q4z0fd3kA9upgNmxW4PWR4Q+5a/28FrG/geg1IqR0gqTteaJVC47u+1jMvkTJTwm3lyntXeV7KEKWdqNnzqdYMdFW4mhzaqCC0ZTuJ4O5dz9OY+7G1FE3RCdNYbBpw1bdb9SnSNmXAln/GwNmP0XrAnvnFl6gGsPGjDTweL2GlPl4sSxOoew1lvYooDrfCw/uFMzxifI/qo9yMVDnxLWTo1LkLNOZC6Ws5Z65P0T+J+tOWUcnKgGZKZbpaxkFSOml0pbaYzUDKi4tEKy19JGic+u0DCK1sVIu3S4o+jtJsYHptovXQBG/JTirDfluACAEFMQRRvKiD3agQsFpgmIu2ieWNSyCaY4JtR5zjcKiwhSw7jIHpCOcN+vMOOz861Ixl4wQuLgcWxNPh4U+9XaokapI7V5eom0vsOtQf+mahnhAt6R6w
 HFAYE2a9
 X7AJNu1LYJ+Tm1gzSuHnZZlclhsPnqLELvxrtOOhjxvU70ubQrCHnOjkc0uSQMDV2hC9xp0DwCVJM/pWjKERS0P/U1h/sTuv8uJ4kEgGNdIqYs5NH7DJ0bRgHVa8SplNs/lzc8CK5Legi4BotmFHQ+dOnxga51mX0O1AUd028bh83zFU1HIh9QTkwE4xTKw/WOe7A5ZCp+1Efj+yB+ovEwPU+H9tRTlIie+cUXDvXTwAfsjbQZzu5FCBqmOHxtz1j3US/+YlHP1zAldwtharfIcHx6iV9FgPuyCY3TTgpHsUmPtzAtbkr9D1cHElPEARd1MdoFkckr47nwyjk69EGPUNIu/hOAGgcqBzRk94wvFoZ+h2rLSSGXhQj6X4cP0LWEBfhoYpvYe50XCVpZc4GN/qBH3n2xopqop+w5aPc3Fe73tJp2f8Ug6+WJRnhNl5QMJ+LvW73/vMefHMXEkuLkyUpQeGH4xChoAjS6+qOdjz1RE00/8t4fSz+psOl+VsnIGNh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_order_mixed_sources faults its region as order-2 folios and
collapses them to the -c target.  Order 2 sits below the contpte threshold
on both arm64 page-size configurations, so nothing in this suite unfolds a
contpte source on purpose.

Let -s name the source order alongside -c, which was rejected before.  The
case then faults at that order, keeping order 2 when -s is absent, and the
source order has to be a supported mTHP order below the target.  Other
cases are unaffected: they enable their source order locally.

"-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
larger mTHP.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 7889ea1cd322..3099e7b720d9 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1412,10 +1412,13 @@ static void collapse_order_max_ptes_none(struct collapse_context *c,
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
@@ -1423,23 +1426,22 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 
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
@@ -1448,7 +1450,8 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 	}
 
 	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
-	ksft_print_msg("Collapse region backed by smaller large folios...");
+	ksft_print_msg("Collapse region backed by order-%d sources...",
+		       source_order);
 	if (!khugepaged_wait_full_pass())
 		fail("Timeout");
 	else if (window_collapsed(p, hpage_pmd_size))
@@ -1479,6 +1482,8 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    With -s, -s names the mTHP source order for the\n");
+	fprintf(stderr,	"\t\t    mixed-source case (source order below the target).\n");
 	exit(1);
 }
 
-- 
2.54.0


