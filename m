Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C39C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3B46B074F; Fri, 14 Aug 2026 21:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA826B0751; Fri, 14 Aug 2026 21:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292746B0752; Fri, 14 Aug 2026 21:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E45A66B074F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E119402B8
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:19 +0000 (UTC)
X-FDA: 85101846438.08.E9B2E79
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf11.hostedemail.com (Postfix) with ESMTP id 64AD740003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="v 8K+fLO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=cA0akQKf;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bljFEbJ6nOpcyGugcFKzpM9ttTNPFcr/ZQQGmFBGNGQ=;
	b=p4dgSVhgGeNNAkoljnd4y8RNjVKD6XZIftMuI7431lcsAVEWucWBdZ9iHSnO/fn9ROuc1L
	EHy9bkqqCGnxQ2G0EFBE1asQWuoyhaKJg4bazZrMf1E1h2gBfQqNi0up/n17cvWCCGrQnd
	n34Q0oZaBkndP6oZwyDP17MZq+28q3I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="v 8K+fLO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=cA0akQKf;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759157;
	b=Fio1aS8SaSHY7j0TdOlyFPkp43mSS0qtmW5GBznFIqZzKRT6vLiP19p9XTRByZfaK7hTGp
	LI+9gqHVOs+lOWxEzoP+7bc7EI/Ma0B+sBDHMyxB1lyWT1OK4FGuJR/bnoZmmc6rGJsktM
	/eIBtIvPxmj6hjKnLUlRsIU769v+GjY=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 030B8EC0222;
	Fri, 14 Aug 2026 21:59:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 14 Aug 2026 21:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759156; x=
	1786845556; bh=bljFEbJ6nOpcyGugcFKzpM9ttTNPFcr/ZQQGmFBGNGQ=; b=v
	8K+fLOCozrKSLZYkHw5wvKkubbHtkGy4qBB01a/I2nfGUKJmpYOKaISYKiPm+AF5
	GveDWj8JXLDbSfkHMYVogaB/ZIJQBHFexFkr1HikMZ+nvKFF7TrX8LLrTr+zkdEC
	HcpOE5paeofRUkNPUG5ZZqrRjQPZYJ17vhbq2ljFrWFxt/ZjL+oVB50OeErSUmGc
	PFC6vEjlcz5RUkAn/T2/AMkRF0ZqFbO9R4WGdQQUDy3eR2HdnIT2IoCzvuie+UDJ
	JV58kBmZCKDI0W1a4PSdZ6y4sRdkRiuZFnGX97+ERsRmT0Mx65XSz+qjJlkE0Vd1
	8vdYphfoc1J1xvAIG41sA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759156; x=1786845556; bh=b
	ljFEbJ6nOpcyGugcFKzpM9ttTNPFcr/ZQQGmFBGNGQ=; b=cA0akQKfu38IBZl4w
	gV9Ov1ersw8ZlDu4zmZ4150TVSoLkM7I9Qss1DGin13bmPtPcgX0K4P3SkH32+iQ
	67hhkc4pjiXqWzT3UU9OwyYUb5K2TlKc9k3bwuylTpd9HLgHGRWbFT9rW0Gv5+MO
	0Ohk8UGeuOxvXFzQmBQpkTfv7X4grVIVkABWcDoV4mOJnL5r4iA+7HxD/sxT4pMD
	KZKJ2UfJDJkZa+bZMdOoW2xHX/GIAWkTVTywyanPRmZTHeyEBsA3efcM+noWn6ZL
	vZ6Df63xwrM9u+UW4XKOpnw55mvDTZH6QRolpfoaZAyks+ulRZPqQk+shhFElEMk
	n5LJQ==
X-ME-Sender: <xms:9Md_amQnouJf3SFBt72totxHPPOcqNMwEKqmHZu-UyO6NrtlbemyTg>
    <xme:9Md_avvkyAT-qkNdOSjVI-G7OYNj1Qv0Dm0gsxgj6eHiuhBxTnykp9APRfQr_IjpD
    jUxyAqqgJ9RtBImFGzm9h8iKgNbPxtI3VXK9-hY_OwS5e52pOr0HqA>
X-ME-Received: <xmr:9Md_asVAZJHxjODmiE_uJnuODqAek-RtZBOiQOQHSbtYV1a5qHfgjIe5L6A>
X-ME-Proxy-Cause: dmFkZTEYpEQiBdLKlCaLp317TOYqYwO99jnuX4YrBujo3RuW+IIGXdYj4qE1ezcGRvbtOZ
    hc7RfnfkdlTehb5Dkvk4VZTcyRAqm2CcEjaldkIQshIttrB2HSeWyAKQfsR+ykmymFv8qO
    aC/+wh3joJiQccaWn5NjVrqLVVMYdoVO37A5ZL6SnR75seJlCquk1NTOiA0EvXHIVSJ25Q
    iFONSccd/wEzNfQZlOvvQQf5bCKiGIALXd0Rd37Vcnrh56q8DfWwmvEu2ZgBGSMa525iaP
    HkMF5MKO3LDiNiHXJVHjo5f/L4XJttiAOfdXhljkaHgZI649okv5M81/eeF8HfhCZr1USB
    aFDwzaDkfOm7MheaHSu0LnQkdQIwPXvaU0CQJ6NRlHYca+Szys49+C+KYF4TupoV0LnHl9
    4oZHEL3wpxshS9kAwizxlp8iJnvvqoORWaf4t/+w2sr70KqtTeuQNBxMGtA6+n0hV1Bbs4
    kUiKpye1DmC2Z3IY+5BCqeqlSxHA96oGURes8rVJevUEfVEdY2gZ84ack6+02xHVk3wkKg
    MCfp5WjQhdx+11zRGO7zRb+mvvFoOEu4JGm+agYo4SaH6Uz0HkHI9pRvk3F6fCs6OR2lTy
    TGwbWLIoANh0cEv1dt6xM/N3WfoyEI1ftOiK+Z4robHef9T3VSKUsgOcnjsw
X-ME-Proxy: <xmx:9Md_armiWPfJzwArAMQkEQnFO3c5soMJn_op_d2U9QTVMu_vioiJ2Q>
    <xmx:9Md_anDRQzJhngG-6nQspCYRRoEvNiVRc6_XO_VaJQO65kqAIoToEg>
    <xmx:9Md_ao_ek4ekg6lbfyx_jlh58EsUQF71TdztknfsfMzg9yCt5S1fzw>
    <xmx:9Md_ahRjrxFotXqbIhKU_wK9J1ZhtSJbuJaFFpfVRyqvNXX735gUFQ>
    <xmx:9Md_au1TrEb3Q34XFxg4hdz-ML_VsBeN2orE7WZR69bx2MglxaB9i0Xf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:16 -0400 (EDT)
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
Subject: [PATCH v4 05/19] selftests/mm: make the swap cases' swapout reliable
Date: Sat, 15 Aug 2026 02:58:47 +0100
Message-ID: <20260815015901.1236937-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64AD740003
X-Stat-Signature: 7wg9ctobtsubo97y8wyrstqdtygaxxt5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786759157-419165
X-HE-Meta: U2FsdGVkX18moMM1k8IEbRom6+1rBOAJ01uzJBxE5Eh+3azD6Rw/ZTRHjm2ygfgKXpbFyJcq1lPyJXxxnG9AwSNJRDf2dm5Xu54acFkH+rCFp+1O4penCei8DnVCuZUh8Acm9WeVkXdD5c655uo8hZ+FYqKP+dbZE9Mlc1qS/VSIABh/Bw6xIBoSKeCrOc7Ky/j0As3N4sO3SMnqzHANjclmf3OYudehzIahzzxu2buUVoY2ixm1yiVnYz1VtD7hLGozvV4RABkM6QK0gbcZiawjMYhsLucv9VVH0XgdGrqPsHjCcMEun2j4o8S29c6lQIk3AjN+dvzKD2fxazjIP7thCpSTBhjiIvB91cmMVmExluO/+5eFu2udwR34fy5DctwMq0ijnLktUHsD/+6z7ZkeZmoG+sPghBAdrOFMWNrF8wZs48or2lUElC2hiQO7Mu1accJN5NBnpmSKY72xhzAWWn6GWSMRZ0J64WH5NE6OkWBsx4vcpjn/CpvG3jkaNRXrhBcP3pRBzyUieS4AC0czRwZO2iblQhcn7DR5xO2NJunddKFCYBR6lFshgny8Sq7Tai5vsQQQ+o1B46VhEu8YXUS0p6GmlpNZeljRZfAwIihQ8eZyj8m5Ojbh1cQRtJzcmdkI/l+jx05O43+FZkIpoHozKPm4sD2XzrP/OvH1FScW2mtFKf673w85RYwxii/iAOwGjr86NZYMzXDWsdv9kVXZTZ9vXNb2pBdUKxXC2szZt9MVIiu7Sj5Tr+dp6bC/q82zve+WpBDJPA9N4x8kzMd7hQE84v0yyXyDhmy7GvU32hW+Sy9YUgXesgzwnp9fhKGuu6QTk+F4b2rdXTktQWPXozm0aKCKTuYp5PVzlwhcX8C5GxIiQOhEXKMG/YQSpvu1pu4I2YQiZjagXcf0pN05NnSdaInzJfSJ0ZisgkkZn/dd1qlBgWx6daYdgzAp7jT0MW/zHpW3xDW
 4W9sSf5W
 XTWetDhfwjJ185qFHh0UX3Ca4eLAQBqGRqYvn2GWVKCI9TZ6jksqkPebEC+3fDAHBKn/sb4xaGrdq3LrGoa0oFV+S8Gyjk0NQarbu9+Msnes5kK6tVDMUc6UnTj8zm8ixFC7xVxVBgzS+34bYldMerYPctyXsrbSdSPZfNvQmXCcSXv1BOixdF+antkphLXaFpyoZC3fi2TVo0MDRvKWKZJBxMb7Jou8k5OTuNBNRSjqgKV3F4hu2RsCNozpmznr+Hpbv89+4qxaQ0Cif24cpGnIT/x4Zy7AxQObKwxnsvUNEhCIw1soyAFyjvTZ/vjS0WsLlQxX7cRYGkHUd4haOSmnrbrEKXESmryA9tIt8aifWIxbYeT+pClckX+zVB7+i55O/hQncCZ4tIXSeISx2Kr1by3os86S3R9+8BK/2ozUFQPaaFNqoH+sRWeaMsKx3XKFeLy89/TYm65EqBmscatJgSMcTSkk9u3ZValCndkIjXD+/Iu+89NRqd6CRNUq8V1Qd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_swapin_single_pte() and collapse_max_ptes_swap() swap a range out
and then require smaps to report exactly the count they asked for.  Two
things keep that count from arriving.

MADV_PAGEOUT is best effort, so the count often turns up a moment late.

And wait_for_scan() leaves MADV_HUGEPAGE behind, so khugepaged is still
working on the range.  Collapsing a range with up to max_ptes_swap pages
swapped out means reading them back in, so the daemon empties the swap as
fast as the case fills it.  On arm64 with 64K pages max_ptes_swap is 1024
pages, which is 64M a step, and the case loses:

    # Swapout 1024 of 8192 pages... Fail
    not ok 10 collapse_max_ptes_swap

Ask again for up to two seconds, with the range held out of the daemon's
reach while asking.  The collapse each case runs next puts MADV_HUGEPAGE
back, so only the setup is affected.

If the pages still will not go, skip.  A machine with no swap, or swap too
small, full, capped by a memcg or busy with writeback, is not the kernel
under test refusing.  An error from madvise() itself still ends the run.

Assisted-by: Claude-Code:claude-opus-5
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 53 +++++++++++++++++++------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index ec5c36a19d92..7eb9db0005a0 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -219,6 +219,41 @@ static bool check_swap(void *addr, unsigned long size)
 	return swap;
 }
 
+/*
+ * Page the range out and wait for the swap count to say so.
+ *
+ * Two things get in the way.  MADV_PAGEOUT is best effort:
+ * shrink_folio_list() leaves a folio alone when it cannot reclaim it right
+ * away, and one still under writeback from an earlier pageout is the common
+ * case, so the count the caller asks for arrives a moment later.  And a range
+ * an earlier collapse left MADV_HUGEPAGE is one khugepaged is still working
+ * on: collapsing a range with up to max_ptes_swap pages swapped out means
+ * reading those pages back in, so the daemon undoes the pageout as fast as it
+ * is asked for.  Keep the range out of its reach; the collapse the caller runs
+ * next puts MADV_HUGEPAGE back.
+ *
+ * Failing to get the pages out is the machine's answer, not the kernel's --
+ * swap too small, swap full, a memcg cap, a folio still under writeback -- so
+ * callers skip rather than fail.  An error from madvise() is different, and
+ * ends the run here.
+ */
+static bool swapout_range(void *p, unsigned long size)
+{
+	int i;
+
+	if (madvise(p, size, MADV_NOHUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_NOHUGEPAGE)");
+
+	for (i = 0; i < 40; i++) {
+		if (madvise(p, size, MADV_PAGEOUT))
+			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
+		if (check_swap(p, size))
+			return true;
+		usleep(50 * 1000);
+	}
+	return false;
+}
+
 static void *alloc_mapping(int nr)
 {
 	void *p;
@@ -827,12 +862,10 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 	ops->fault(p, 0, hpage_pmd_size);
 
 	ksft_print_msg("Swapout one page...");
-	if (madvise(p, page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, page_size)) {
+	if (swapout_range(p, page_size)) {
 		success("OK");
 	} else {
-		fail("Fail");
+		skip("Could not swap out");
 		goto out;
 	}
 
@@ -853,12 +886,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	ops->fault(p, 0, hpage_pmd_size);
 
 	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
-	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
+	if (swapout_range(p, (max_ptes_swap + 1) * page_size)) {
 		success("OK");
 	} else {
-		fail("Fail");
+		skip("Could not swap out");
 		goto out;
 	}
 
@@ -870,12 +901,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 		ops->fault(p, 0, hpage_pmd_size);
 		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
 		       hpage_pmd_nr);
-		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
-			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-		if (check_swap(p, max_ptes_swap * page_size)) {
+		if (swapout_range(p, max_ptes_swap * page_size)) {
 			success("OK");
 		} else {
-			fail("Fail");
+			skip("Could not swap out");
 			goto out;
 		}
 
-- 
2.54.0


