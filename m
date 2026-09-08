Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4644AC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5046B00A9; Tue,  8 Sep 2026 08:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356D06B00AA; Tue,  8 Sep 2026 08:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C216B00AB; Tue,  8 Sep 2026 08:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDFC06B00A9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9728DA0676
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:37 +0000 (UTC)
X-FDA: 85190581434.18.E8EBA1C
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf16.hostedemail.com (Postfix) with ESMTP id AFDBF180004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="T MV4cmo";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=iFYTl03s;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAoOR2JpHpeae+txrvqhct8oCjiMK1u+dO7P0yt7mGY=;
	b=TWjD9TCU5bdfHIOO/+Ijsh6HwHep8TpoNmt2fV/S2FD5yp0+fj2bI69zFOUUSiKs8SJWt0
	CFgKKahRtrzdQIGM2ifPo1DyQvsD/ahhosOlN47uxHg/PGYK5YmubhMlQ2UsQoeKmp2/yj
	enGtQgxvSVuo5dnE/huJjobCq2k87Kc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871895;
	b=BY4TvNP3xLI5gTB+ofRiQe7Hp1jXRjNfmJy3e3TXntSrg0qOEn/u0HhTrt9Y/xmnhY0F8l
	HFVKyPYmyOtGGYb/mvJ3Tas5/pX+jdTcRYXvK/N62EKKAxHo5tCjAoBYiViX7haJkx6YJ2
	ErOZsZrR5itmB37V0n4UxtduNvoMhfw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="T MV4cmo";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=iFYTl03s;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 3A20EEC0032;
	Tue,  8 Sep 2026 08:51:35 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 08 Sep 2026 08:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871895; x=
	1788958295; bh=aAoOR2JpHpeae+txrvqhct8oCjiMK1u+dO7P0yt7mGY=; b=T
	MV4cmoloJrwMWev3RQ9drw5GaSxGrwTGLJqzy8wDPst53OjD4n7sATPRu7Y59jhW
	KGUSMXMIFAKQSyQ0JhbBTT1/zQKipJ5szN3yGai4xryF3F5uYD6zat/fo509pQun
	+LVXHKDat2sXYDQ/0WDZe4wg8ifiytXcT9VPfhumlTK73+kAmYpom4wypkAQ3c9u
	ph+M4ui84MCPW3jJIjzWx4yuWUa3HQ0tvkM/O4j0AK/nArhbGpBCEQOCjw4ECzrT
	5ogMDkyp0qNR1BSLckBpxBNiFZ3dwaoKCU/XgyqzRUyihqpNF+5Z9DBu5XkPMaF9
	JGegXEKQUBoO8g8tkcU4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871895; x=1788958295; bh=a
	AoOR2JpHpeae+txrvqhct8oCjiMK1u+dO7P0yt7mGY=; b=iFYTl03scM205lMti
	zu6nsqBavzBq2vot9GYPyOX1lNWHP1CX2u0WwoD3jYi7bYIP9eoqC3mYFFU+x59h
	gr49yKlvjlOtgFVTZfgwoB3QUo53oxfrBryZHdyRZMD1coag+yFEE6eJdLR3eM5D
	1Uu8Xg7SHaglbkx6SRENp8anIJ2e0LQ2eYDcoZgb5r8hbP4KwINCrdQ4bIhR0ley
	kVp7fB19LPjWufW4sKkTzlTeK+YlaNkrEpi5RK0NYER9GyvSW/uXHHwrQ2y4kLHj
	V2AtfcHAeP4I0MrgrskmL4Cb2/0mO68doabZgP8RU9+8I4XH3FnYu3YXPxtY4IKi
	oFO6A==
X-ME-Sender: <xms:1wSgaj393UJYpkOctWYyXk5FJvVwN-oTwaBpr66ew5d3tr3IEmCsFQ>
    <xme:1wSgaqc5iq6f8cel7KrgW4oUlp0Hbpw7dAqyaeSNKVAYNnXJ3WdX6P1MXdjjT2lZJ
    QCvRlt08mlRC9GlAzKBp9rR5IxqiN_JppEw3QeDnbFcfbTY_YqnFKk>
X-ME-Received: <xmr:1wSgamHuXqMAlTo8vcmVvXqQaYmzi4TnLJfr7zY3tsdnwqn1ViPMs2wt38Y>
X-ME-Proxy-Cause: dmFkZTFWe/QI6m+ZXOiH25I14VSUcDEmQWvIJTkoHMAZtN2azwvxUv07K8nNahSlNeJ4Z9
    6eHjxl/BiXM1vPYXBSjNJhxqwqvDDNYnCkPHmLCbq4adC57onKQLlqdPi/SM35ZhUSQuAt
    oRpyp7Ri3t8bYQcmJtPujCQbmd86G+mUWXXI2nu6Mtv09ASCHHJTlzhzeQpnnFQ07IodBo
    3ooVqbRyu34Jvm9Dh+nNFu4XRDq6hWeQ2IW+S+nyO71TFsfO33MG2zd0J+TcVl9g/s7mL/
    x93b/UdXcwtuY1HOdcGRsIdopKTGnoTNDXdbX9wz19n5nkOd3IsxnbGCKHISgqzDlIJpBD
    7kpFqjWaHYh20TF1Po27X3IUf2hMX5WsY2ffOrBn8O33Q4PGlV+0eG26xYkEoVPjpLUQ7o
    K4Gw+1BIHrS6+Df0gszthr8DRxnMQoOSZO0zOGZCNfutMv443eaJo6WYdl2v4wMZGU6svH
    nRDQBsmPu/104D5jb6kvKPpcsMCDluEQBGgVtgI16Tk5ZZuiHVgXQpJO06zvlykLvd/xIU
    O59/TSCW7b4ZnRZQ8uEo0fjBLO2VaS3b6G5vQUvF41wiuhHQkX479nttXU3hp094FjYQbm
    fA2IsmO+3dizMZryokRV+4EP/gN9G0i1r9RtmCtB4HOw9ZiQ4bEiDJepkq9Q
X-ME-Proxy: <xmx:1wSgagrXYKrFe-rvPZLFQP7pn9Pgs_mrPCWl8ab3TPh5A5fe1KLEig>
    <xmx:1wSgaoL0d7_p31uFJBDErwPwMIGiZjkK3DDwl4A-6wrkhUh4vO7uNQ>
    <xmx:1wSgapxGp7OKjMBJY76JK3Ce26jJtc0CgX9ex3S0tIRIfyIyvm2YFg>
    <xmx:1wSganbiassJwc9qE26I6X5tY7_9T21fthP7B5r22UHCbwgn4U1iHg>
    <xmx:1wSgapFr2bLOqY782OVoC6BmJsd1ugUJbMasnQ_tew7ZCRipCeBMeW-q>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:34 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 12/19] selftests/mm: parameterize the mixed-source collapse case by source order
Date: Tue,  8 Sep 2026 13:50:58 +0100
Message-ID: <20260908125105.1510704-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7y5u4fdg81y18nmks7n4mcxfo5bmfzfr
X-Rspamd-Queue-Id: AFDBF180004
X-HE-Tag: 1788871895-355786
X-HE-Meta: U2FsdGVkX18tyT1CfXAZyTcv58hz28IJSI8OAvTg81wa4qyiw+E6HY389tVKp7e2yo1Cd+CKvUtiqg31qxARkt6KN15XvrFShMA8FYh2nmqX+e4GRVgFYLxmg0Ny0O1aCSV45sV6YElxM5IgI67nZ17quspFcnaKWTejsSvabc7Ck+BQjoH6UbfP5UrE9Z4P5OYG6KwzKwc2zMbiqvJcBU5uSE59pZwG24EguqlzFVnrdVf+ztErxY1j09zy7weoAxboyOUEU6NtXv7MSBWtCGSEI2g+TLaynSCyF/6rtGsYtCV2z1yt2nCTpsmQedFlX7z+BMaGij/DGq0O8jHwaHYp2j97M67cvejXy5Wlnpc9xAyhVXcmwN3GfH43nPl7q4Cj5Ymi9DSvnGSz7tSwSdxfsuKatc+AlKTKG2F/OXdA+00SYDlVGcmYsS2iywfiI8CX8UB0Y6CWMIObLVlqk0HQCs5RcJXzwqDLu0UoPTFFKXSEvhzBXiC3QMBoEMF5lswV/UvR1I4Oli7BfHGaAvQFpCaFXWQZByvWIgfktNaPCvDdJ6nE2vy9QhNoHTTBQGeZIa2SikjruujwL9hlvuxkKxGV22NgEspFjZ2hbyN95ay092QS7Frpm8MPDy2dEYWzma6ylt8Kr9FvIjLCc4+YVqoNc9G6i/syjbEiACNwIT9pOB5kfvfnlkbGQhHma8Rpx/ILGXTl27MqdJJSe8SIpUi7hjSEhc05T4NDtOm7AI1oHrb9/nesyv7VvAnS+svMd9N+qEbPFjEoHQZ+tMWYTgdoBlB7K6dfx0BZLWe8umTE8TNkcHZFZjkcfRBFuGNzEY7Q9z1XuNbLzM9fTuVb6XkWX32AoAtaKE+kEpGEEc7GFGC/3NPHyzlAbn/Q57ehjMFKE7T5Dl+POSt88M69doq16Hl5aV+6vWAGzwWWuXGDWAdOiNDfCuMcz5i+xye/aMtevdZujfxA1rb
 qFIN7IY0
 IVXbdeE6XDXRKSILQlff0w+7ltsUydTn7xbGuY8qjeLBvn/iiFE5Z7UJnmrF3L7oNICMTGe8CNOmhwXizOSaYIXkVesTXsr0ka1GHg8JI+DGOyBVBC9BTlvz73QLBilJe5Knoq6OkQPkHJqhnNoJSAB/T/2lulrVcqq6UIGOCHDs7xsmo61+uUYlVBtE9iiEpf/CHkkf3bhxyvC7hr4ETbQ9URApZJXT6bdNJai+hlNqXnAANyF9GMEX5ClDPePCis+GPX3/9BM2TXvQrUTfZWX9ExQzP8i6P6QydOAuJunWj29McfY/uG9qXkDx98KJX55IUUPuocnDeAnbcVTTc380i9XviCuocxVy5QQv9L+o3KwB3kiSKDWKX4fh9r+Ymnle+xkMn2yzCZMv2iTeEwqZCQVBKL5583IlkhQn7WYPdtGOUa1qd5HdT169jGqca3dnrNyainpJMWkn+RPBCY96Zl3GXpWIcVjWkwwtkTAsfquH93UCSuS5UyygWr3CXFrIS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_order_mixed_sources() faults its region as order-2 folios and
collapses them to the -c target.  Order 2 is below the contpte size on
every arm64 page size, so nothing in this suite collapses a contpte-mapped
source on purpose.

Let -s name the source order alongside -c.  The case then faults at that
order, keeping order 2 when -s is absent, and the source order has to be a
supported mTHP order below the target.  The other mTHP cases are
unaffected: mthp_push_target_order() enables only the target order.

"-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
larger mTHP.

Assisted-by: LLM
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index fb4efaf67c40..b15cd07fc0b3 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1352,11 +1352,13 @@ static void collapse_order_max_ptes_none(struct collapse_context *c,
 static void collapse_order_mixed_sources(struct collapse_context *c,
 					 struct mem_ops *ops)
 {
+	int source_order = anon_order ? anon_order : MIN_MTHP_ORDER;
 	struct thp_settings settings;
 	void *p;
 
-	if (collapse_order <= MIN_MTHP_ORDER) {
-		ksft_test_result_skip("%s: no source order below target\n",
+	if (source_order >= collapse_order ||
+	    !(thp_supported_orders() & (1UL << source_order))) {
+		ksft_test_result_skip("%s: no supported source order below target\n",
 				      __func__);
 		return;
 	}
@@ -1364,7 +1366,7 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 	mthp_push_target_order();
 
 	settings = *thp_current_settings();
-	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	settings.hugepages[source_order].enabled = THP_ALWAYS;
 	thp_push_settings(&settings);
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
@@ -1374,10 +1376,9 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 	 * The allocator can fall back to smaller folios under fragmentation;
 	 * having nothing to collapse from is not a failure.
 	 */
-	if (!is_range_backed_by_order(p, hpage_pmd_size, MIN_MTHP_ORDER,
+	if (!is_range_backed_by_order(p, hpage_pmd_size, source_order,
 				      pagemap_fd, kpageflags_fd)) {
-		ksft_print_msg("No order-%d sources to collapse...",
-			       MIN_MTHP_ORDER);
+		ksft_print_msg("No order-%d sources to collapse...", source_order);
 		skip("Skip");
 		ops->cleanup_area(p, hpage_pmd_size);
 		thp_pop_settings();
@@ -1387,7 +1388,8 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 
 	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
 		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
-	ksft_print_msg("Collapse region backed by smaller large folios...");
+	ksft_print_msg("Collapse region backed by order-%d sources...",
+		       source_order);
 	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
 		fail("Timeout");
 	else if (all_windows_at_order(p, hpage_pmd_size))
@@ -1418,6 +1420,7 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    -s, if set, is the source order for the mixed-source case.\n");
 	exit(1);
 }
 
-- 
2.54.0


