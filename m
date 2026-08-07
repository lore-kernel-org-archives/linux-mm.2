Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3379C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172DE6B00A2; Fri,  7 Aug 2026 07:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061906B00A3; Fri,  7 Aug 2026 07:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43C86B00A4; Fri,  7 Aug 2026 07:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCC826B00A2
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F4F2A0389
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:19 +0000 (UTC)
X-FDA: 85074272598.30.1EC0672
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf19.hostedemail.com (Postfix) with ESMTP id 897021A0002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q OJdnMD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HcUNMZRs;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDwmOcIYA0DElOIzeueyNhLx2hbSZ552mVI7ZkHow+M=;
	b=rUqhav8P/TaH35rku0SAKJueUP9Kngtx4pUs46tGYFuZj79a894tjMy1pe35LQ7DhYC4Ig
	J0z+xzfRU/Zmzlf9cWwGot2dGjRrvTOgPBfET+2eLCJpCrWKKkWrK31o35kXD2UqLjIBYK
	jN77wHFbHM4GAN3RN95b/uwghwwcMDQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q OJdnMD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HcUNMZRs;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102637;
	b=EwxVIoeuAe3t5OUQ5LuI3XHy9zbwNpDltvmMWbwdcN3CuIxM75f/6meW/aqTbbKb2nSZat
	lHi8AoYQEjHICZA/BW+yo1MvSYOYuvh3VGdugxxW//tm2wZdj52cH5UQ8xsb2ZogGho39j
	npw7lYdkMvzWFozqUZl6E3Nu97TkBUk=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 651537A0125;
	Fri,  7 Aug 2026 07:37:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 07 Aug 2026 07:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102636; x=
	1786189036; bh=zDwmOcIYA0DElOIzeueyNhLx2hbSZ552mVI7ZkHow+M=; b=Q
	OJdnMDEKaEpsGhKkFkXswda3CyYDZquipaju8fR91AVa54DsxnTagFQiTjs+NSbW
	fXr4brLzf8xHbJkynxgc7STv8PLEvMcjCRKSwWTntt3XztwtxzxWPoj0V6m98C2B
	OmSe5Ww3PK36yeQjpAQmvt6NF0bwW6b2KW4PbHWPH2d4S+Z+doaIKuMwMT7ONsNj
	SCro0sbv/IQJLyg1iuqeHgfC1KdzFwtgwLwls4VcRGUYaQMsDV0TYmPcx9Bbnn7h
	IOXyMWaOSP9aPEtvQnWEWFKjh7J3K430e+muJ+gDmHn/cF3hsZq4FJqELnCeNsFP
	f5nLbOLmeQ3NbDCAkAfrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102636; x=1786189036; bh=z
	DwmOcIYA0DElOIzeueyNhLx2hbSZ552mVI7ZkHow+M=; b=HcUNMZRskVTum2QsU
	He0NQ48mK65A2jGlUCKYJmm24mArfJXKF+DYfd7Rjy31jQ+2snNRIUqJKkec5EES
	MWmWV4thUnScKCS9Wsh1PmLpdhFFSVOsMx9U0Ccbb0fr2Q3qxdl7dkU4t30SoPWl
	ufOUCM3rjnfi3GUjsG3rz8EuwrXqQggZA/olmMBV+9vSoqvZDpL7OszQKe52Er8H
	jDWu6oKS90Wf9OEAnTKL+hhstygmtGJDU7evkDKftsc0fkt+AAPNUwir7lIJcyIK
	UDRDBQGDhavSL2SUpffpDj4PzgzFsYZLsB2/0ysGQYChs/xQXah3P6EYySvGOA2z
	T9JSg==
X-ME-Sender: <xms:bMN1agskpYVb0qNH9GPWwFJNt1bt9zHyp-EFsLJZ4vYrHGunCarcMA>
    <xme:bMN1ahaCANhu4dcLV0Pgu1CqnwtD1oWGE57_8lwSiKT-8mJi-kD69z0j5aSXiUv6b
    n_RgNtVk_1HCStZ624FgY7WeFqk_5KvVh1l1aNighUNgtWKxlAoD0ad>
X-ME-Received: <xmr:bMN1akRnHLYnBXo4QDMkZuzQVpsYB1QerKD_pEtrMfEV-VwrD7_DVTnW01A>
X-ME-Proxy-Cause: dmFkZTEcBCtHwgFqhRPkncf0k+1ylINMWkiJotqLKgP2XUmyCnaVLH6jJFUJYUtwVpCetV
    bzy51nCrHgVQnKUbL6xUc35a2wACIZl+NbR3y/w0ModeWlKP4SKCXfcn2Mi8esZBMBdaWx
    faB4jzBJOawj2LBnFTgyCBiywrPp7FpNgfXB5cgYmB0wgvQ/HhhWAfKjMf/weJgLhMF/VV
    yXrMoja9EZiHjuXu8bb94hiDoU2fqI8TuwJJmzzN4TUL6MxSST+GnkpA2ZnKWVewXCphJB
    Lec89iAB+bDvFyV3zsxjbJ8cA1IEQ3aF+gxi5HDHtN75oTRJtbf/Sd54tDaiXy5fa0cQPj
    U2TbJkcb+9iijbIPlEaK0B6F5bw3UDfJ1MYirL/BHTzp/YpPZRiz1Cym40T7pwZTZFigNO
    n5dWOQG0yWOfNnsOVtwP6tYvaWKY1vWY9/4oBQpWn3s15AWbMlP1fHZ6MANq18DJSWjWaC
    RtK+QxWIn/52Vmxhvv0CuwdFUt20EIQvpO6uJltK8t1kkJEFmJIngj5+Q/zb9SjzYQGBIt
    G67NUe2kLEnHEDNAPWT357EKQWHoJMwAwplVSaoOz7AnxqBriAILhGNlYFtd/5P/7xPw32
    rZmePKHNzMbAGsyTYY/V2WtvPfIVkqh1VVxyFxsP7hUrlVk26uJHCY/4rKQA
X-ME-Proxy: <xmx:bMN1aswga6u63tBRchl6CmOKneUmoh_QVg7uFcXWAJkbu-LvuLAuHA>
    <xmx:bMN1aoeR7C6_isZnzkeKzu_G8D34VYOmpKzVuMAfrc_yF8zFioby4Q>
    <xmx:bMN1alpSNr-u8s5oKS8RBMZouYryv1GYIB5UrG_jVH3rTVUK3TPG2g>
    <xmx:bMN1aoMSB3-h_wmfHGUY28tzvxj9_jiNcMWjxTRJoV9OXvVSU0TWWA>
    <xmx:bMN1ahNLC0E9OFi5-M_u5A1_7RkGXdYX88MXJ0l89HQbCnyKbqAqpxjk>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:15 -0400 (EDT)
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
Subject: [PATCH v2 10/17] selftests/mm: parameterize the mixed-source collapse case by source order
Date: Fri,  7 Aug 2026 12:36:40 +0100
Message-ID: <20260807113647.3744609-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 897021A0002
X-Stat-Signature: nrms91xem36tm7e39pmr55jjpwobgp5m
X-Rspam-User: 
X-HE-Tag: 1786102637-984515
X-HE-Meta: U2FsdGVkX1+Gi+I2JSVUoCeb5t5wY8BenidyFGfITK90fkUezxEaDw8gDYyYCTEzUnbxH8KzO8fUA8xAk/nFwBYgEsJgjCE3+0Yas4PvzScuUwtwUmHWowiwPnwNofz0/15Ka9A5wkuSgN3NJMGJZ2vDovwMXCF0S4mjmQCrNs3xI/E0KykSD0ZGVgjeHu3Js8i85+/yVUoicaol4tm+df7+Won25ZyR7u6CWAaZohkW1WMVRjux5EnI5bbYkZ9KXNUAa9Q+DiWHd8j+cb8Neyg0NkcBs11gL+G04jXfxxWpXlz669Oorol9mJdLbGAvqvCxa2FnnMrkYM1OBRspR1XbBUBJN56nOaLNJNckMGVueKp2aDgwlrcf98eUBGYugFMoiC2sKd8NC3SYOxwaZu/h2NBHlzTTkizOYjo2V6UWRbhke0cKz6+zpcElh8qB1jLZEh94mheXaZrODFuT6bNxycabX7AkieTCTcdGV5yPZyKTetwmFWJTBbFIzjk8LlDSjXup470t3MZQHdHqxpueru9VXCUTqDN8JDc0+QMkl9SzyY6c8soln8VsjD09YbOBxCmSoMQpR7v8e7V19PgYpZK1e/+HryXwmifRWcg13qdg7M0hpYmXAx6qz3s1VQXKq47A9pZo8DVaVowqhYPXYwGhZgUWSraD8/cnuoT+AVUJSq8A+IepA5t3GASQLSqhgzx20DgDIr5wMRHi0G5DSg2X3+IZq6rfJmHjwpG1XPw9eABs+UBhdzoX46GIjkHbtIRxbbvtlNFDw4y3Of39pGP77kneh7hLW4zA/DVb9xzt9XU6Cx2+CwBKCQqr0MVwYpa2dhw4L5wJMhzyz1QtBaiUkUFHqjZ9Xc+59HggKVRk7gXFpjr6AfFKK2BhAKDrTMNiiEva6jPyO7BlNMrDPfGX7nhXQZWWrQ6wbqRSlV+bD9miflmDxV6viZ71m/qY8zNoE43VFMVxlNk
 nl2cBOwX
 1Lm8wzzoAfW3WCz4Kvxh6IoZdGIlN/ZHG0b1ZpD8RdwKBVlrlcm1V8dbXedMIqJOxx/paVz87YrSYv1zpinMKyZ3+OkCyAFXNc4wVNeMcepyqkqv+AO1dEfbA1SIn6fy1yZ+tnoqVZbCKcKq/7x5joSdSGg2vce+AEtVtafpn9DJ+hc0leO5YcCq2SwQoSfu8ck/bpAP4m0bb4thDOVs9v82C+KNsjNHWbycHcEH1xhhbgpVUIFxDaNTYsRkuyFh/NhZfrYTdRVuvIzLzjo8EkV3NARIHJMG0jGNtSKwMYYYuQwSdd4nlZU/CFB3XrKKam1FS/Nx0kL5RZj/O3/LEX1EXJlyeMt5bnvh3pp9X8Ouv/Bj/xM8J40LCcPt5H+LAGwczoQHlBwxp2hXnBY7yRrRmSyEn2fCX1/CgHuXV/tBSU9rJ+rrHoDx6TWDd0Hs0Fosdjd1AiAwl0dQ=
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
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index bcaef17e430d..d3ff1b196e09 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1430,10 +1430,13 @@ static void collapse_order_max_ptes_none(struct collapse_context *c,
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
@@ -1441,21 +1444,22 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 
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
 
-	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, MIN_MTHP_ORDER,
+	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, source_order,
 					     pagemap_fd, kpageflags_fd))
 		ksft_exit_fail_msg("Region not backed by order-%d folios after fault\n",
-				   MIN_MTHP_ORDER);
+				   source_order);
 
 	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
-	ksft_print_msg("Collapse region backed by smaller large folios...");
+	ksft_print_msg("Collapse region backed by order-%d sources...",
+		       source_order);
 	if (!khugepaged_wait_full_pass())
 		fail("Timeout");
 	else if (window_collapsed(p, hpage_pmd_size))
@@ -1486,6 +1490,8 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    With -s, -s names the mTHP source order for the\n");
+	fprintf(stderr,	"\t\t    mixed-source case (source order below the target).\n");
 	exit(1);
 }
 
-- 
2.54.0


