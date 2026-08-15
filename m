Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37446C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1686B0761; Fri, 14 Aug 2026 21:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32876B0763; Fri, 14 Aug 2026 21:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4936B0764; Fri, 14 Aug 2026 21:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FDFD6B0761
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1665180114
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:35 +0000 (UTC)
X-FDA: 85101847110.14.F52E445
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2889B1C0002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="H ZzCPkD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Sa/gT1TL";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xu5XlzhsRnyO513iPV0tSkUMOqSCDM46ogGqM3hnkno=;
	b=Z+HiT7bYr5kQTv87D0T/Rrj5Dh3wQRqC94alUwBudpq1OCmdU7chtmjjrNmmZ4jNmy9J7f
	Nthf1wWjYn0v5v7U8o1/BK2GY7z6+adSO1KZmsxi2+WjqzU3X3g36OgLe4/K/G/R9QmEUk
	rtM9Hge1g5f9Xcjku7FXcqdZUxVcNT8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="H ZzCPkD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Sa/gT1TL";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759173;
	b=zf5PjABF8MsQ1oueLnjlcK2kfJ/qg+smQddhToQlcFgznr6eyBYzSVbbckooHRpdX+pBn3
	zB3SJDuc9U18ag7OnuBSZwL1oW+4EiuqazWrp3NJaoMjsCmhO3VyyB0Z+r761kXlaW/QM2
	2v0e6uYWg5VLPIq/OQV+PMmqNwLdgJg=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id BF4A1EC0222;
	Fri, 14 Aug 2026 21:59:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 14 Aug 2026 21:59:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759172; x=
	1786845572; bh=xu5XlzhsRnyO513iPV0tSkUMOqSCDM46ogGqM3hnkno=; b=H
	ZzCPkDELIGrsL/SPZkH13po6ok3Xzu82j3gEVLFd4py9K0hQqhsH6tbb3v4s9uUt
	USKjCa0InwtttB36LBy71X7RGJ/6iWdwahgP8rtEt2KvG9XCXfxbuoUdeNaesCsv
	65WytTlI1SzNc0LC9j50V6LTwMAIaekKK4Y4ymiN4WDGI2Uk7ZfGIwQj2DdGvdqR
	zzz6HE5GFV5ag1fk5kwW5t0OEMgKsT9VdyvZIej4/B/tICPoG2K4cdzEv8g8uQh+
	HiNYcTF112LeOCpqidFJL0wX7nshUl2mV/GHtKheDjTVMTHrLsUurx++zV9tGEnh
	X4i2nB6/7ZBMtpOM1I1+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759172; x=1786845572; bh=x
	u5XlzhsRnyO513iPV0tSkUMOqSCDM46ogGqM3hnkno=; b=Sa/gT1TLJH2prrjz6
	jViLTzOr++s0aYqElJ4N7NepM5yMRkSpi6XX9qQCKXxitcOd9q07RjiGeynTXG9u
	QgxGWcRAlpvROLZgl3QtuE8dHdP1VWcPxlS5KNWn8qOI4EZsrqNa7VHiNvsEfgQ4
	stLgu8jrmAhfBiFklZKfhig3FzZfvFI92r5fHYilkDghoO2SISPqxXQhYZ+kL3Md
	gF16sd1fEYug5UskwBAmbtEBhIqlRL7RMCAt5I/1Tt2SPVoEj1nAzN3FIVN+evOq
	7iDCTcNoGcqfwzV+UwqvZC6DT/UgltfbfISeXM8+NoOTHwEZFQ4dhyEW6CW4tm+H
	XtOuA==
X-ME-Sender: <xms:BMh_aoS0ELGSJBIKz-3pApn4Kx3B8UKBVfvMcJr86NNr_Zt-k3hshg>
    <xme:BMh_apu7JRa9dC3zi4DhwJX6_vdzzgajcDbS9zbsREz8DJRpx2C6TnuvyAFsgyr9X
    IaIadlHNeJKg6qkpslb-VksI6_S38gcjNZzxYNuHGCR3s75YCOecXg>
X-ME-Received: <xmr:BMh_auViP_omZTsnkTJoYAa11M1V4BGJDDhT-OBDMkQA18Yy2X-fVUXY3No>
X-ME-Proxy-Cause: dmFkZTE4LsllL5mDr4jgINBzNWNyncOxykfAHbUnd5YNeufniPijDKZ2Q74nct+xKCifs1
    H2Djkg7H/6yFeHnJG3ZaS3y0lvG0agappzf948+VnP0i9yBGlC75HydJdxE+VaLcaAo1iB
    npgWdh437yabl0tcqFtMCkfLO+e8hKTIM1JoCtbRkD60i2JQs08ndCsfMPOXT8PgyeyXeh
    uq46vXE/qDxxY4OZQldbm4iR2S+h71iOzjsUxq79Ie/EJboDCHFVxBfBy1NevQy7IuvBPJ
    BK4YMBoSmlYE8wkBs5S3mRyvR8BaiOuvXRijp0iKeXpkOL2deb0peaX6b452jxbs1L3IHc
    r6EiA8aJhaBPU/Y029rs+sLysD1ij4of89NgQURm/ilFRab3dDIN42+Xtstkr7g5Gok8lW
    yOHfx0QBtVuzJJ/rRXeXzo4Q634fT0KPqQ08vCkS19rKppm+Sa7KTKZKI9TnlH7V6ZIPiv
    1MYDx+dy4fSKd4WLXV0SFEtxM2wqzZ+UDXLR3CW8cb3ZiTkkqwZag+Z8850Xgw8JMQTvVE
    FDWj7+OXg5E26baiBESDB5UmHEERvYLbIdWytfZa1VFSzsinRjay+Bh7TTtu1nK0hnAeki
    /ebZk994hv1njGYI3bVVndIMsVEYk4Ys3MmNYuCuUtOfEnzrxswPkrSqE/NA
X-ME-Proxy: <xmx:BMh_alnqzrLhJvURNPduEMMuVpP1DwGpaDOyAWcOatzAjDyoylVufA>
    <xmx:BMh_apAQeg8jU_Lii_2C4V1PbTM7SZ5lGq388BpbMHAiQZWkAVbV9w>
    <xmx:BMh_ai9_42V8YyKV8UXEvCUu9duMVHw1eymtcLdKau9Q1SD3rlZciA>
    <xmx:BMh_ajSHZhc2HG8pUn4HVm4X7hD2XRQWJngo23ZxEdRQU7Ugrms77Q>
    <xmx:BMh_ao3UwIs-UUDdg-0kurkqiWqDfqiIFHyDO1D_jgLWMVsToH9rWNVa>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:32 -0400 (EDT)
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
Subject: [PATCH v4 14/19] selftests/mm: run every supported collapse order by default
Date: Sat, 15 Aug 2026 02:58:56 +0100
Message-ID: <20260815015901.1236937-15-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2889B1C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: q4u9e86q6eo6b5h88grmcerfjd8n6acd
X-HE-Tag: 1786759173-442299
X-HE-Meta: U2FsdGVkX1+nU+gHaMaji1H9HUPrEUzmGWtmipr0VDCaYGBXcDoYcJgdKbqKNzU5swEjvKagoN9H9fpBbjuihsbQqQtp3BDIZktfXUbKldWoN5CDPdErT80SiPoawoL1zErM70XlIwEC2HatmXc1pokWWi/Rq349gb+YhcFM86Y3vqW2OmK/ftF6b9sCjujaaQVf4Sdw9nt0sDgPyszJ3yBaAXE3cKogcIS89EIbSNWUbfpyfI19nAQmPO8V69Z+BS2EJhwqqMQ7Af1SEnBy1BykhLIyiHrDhc/fjPyzy0Pzir/6QFAVvf5ijaxuiUTSn0cids5iTSdVEV0w17JMVhUSZMa4d3oZ6Y8O1etVU9ifh07FVyuV2KsuDOhICMmwMAN8wh0RTbxxFOxD+qpKQjsg6rOJN9iqBhkvG8LJskPtYhcbGVDkvGvRgYw61Kjb4jD7ttxS66Nb/3BUg/Bx6Dhj12Gix44PAtUJ7zETY3BumbQ2BF0NEyKuNsedYsAjHeaeCQhqGSvQqE8jed2yxSZp8gQJt8AG2S10ZWrV3rX6eTupER78V1XEP8ORneqwDVxYoB0ciVCyzeFChH0P4OzJPBTllzQxqDh0UYzRUfg/Qw2JOII1KL2q6FinHyGVlaZhk/1KEQAclgHtXeb4whk0twKiWHl2EWbQ/7tdBCBEARdwzfBss6gt/sBgAlR/brrfbEnLeuZJfk4YjCQp3s9NgANDgeY7bRg+/KMfYEh0+MEh6H4Tp5iTtpqacmx3rS4ac4kMVOYcLqPCcTvkj7A+oqLAPKUF63a6pSYL1I372u9B+JIzNQ7SpeAs9ZqqYMOCD0cdODCO7GxIJZ+NH8U8X4ZPldS9LmdyVbu4F7Wy9xmgv8MVKjsL+vmzI2AWJv2D3cNFb70ctoywapHZgOjHvNjrNOUeHcNowdnZjWoDhrwW3AsXR6WFP5vUU+QEdCbBicCja8qlTiu1aXV
 1sqGLcE0
 Tz/w0r6to+LhZOb0tlo7pvCS1cTiE8ahjuw5GhgihIfh5QN68khbeqt3RzPiP6StOj2v0GmqAPg91aD/vIh4WyNM+Nl5NONRWCDrAdt0ysAM15on/PcI1PewRMVHwHSYA4B4OwAIFdjD0wFq7vQKavLOvy5cp7z0UpzHivck1dsj2QTEJvwWtO0CIoT2DmxIwWfjMr1Il2AxT32K2vWh6qQ3FZm1hXQ7f/a5h91/l4WaMZ+TGZ0kVKJ4tT8dXBiKii+7/FEWkZ96Ua/ym1FgIwD0xdYe5p8rsb5dUd66pmy0OeJKSu7hoktkTyN3XZmFPfABX4Uu414eZ44H8h4RHj78K6NUpgxhqBa5f6SLaOA+B6pdSkcex9hMF5nn92uuO6HY3nMrb8uQrBaLkeJQcgoRIKk6+qz3hArUBObqyX5pP4zwTLBtUJjRHJD/6tCj0wkk01Msay4fk9LHgyIlab5PuOXK+oSgbFg7E+7sNatsfE9dFMcT5b8XByPpoKlceChuC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The mTHP collapse cases only run when the caller names both the context
and an order, so a plain ./khugepaged covers the PMD contexts on anon and
nothing else.  run_vmtests.sh pinned order 4 and covered no other.

Run the mTHP cases once per supported anon THP order below the PMD when
-c is absent, and pull that context into both the no-argument invocation
and "all".  Around that:

  - -c still pins one order, and now says what is wrong instead of
    printing the usage text.  An order at or below the -s source order is
    skipped: the sources would already be the size being asked for.

  - Both orders end up as array indices and shift counts, so -s and -c
    are range-checked before they get there.

  - The mTHP context has only anon cases, so a run that names a different
    mem_type -- "all:shmem", say -- drops it again rather than refusing
    to start.  Naming both explicitly still refuses.

  - A case carries the order it was registered at, so a result names it:

      # Run test: collapse_single_mthp (mthp_khugepaged:anon, order 6)

On x86-64 with 4K pages that is orders 2 through 8, and ./khugepaged goes
from 28 results to 77 in 21 seconds, so run_vmtests.sh can drop its
pinned order-4 line.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c   | 105 +++++++++++++++++-----
 tools/testing/selftests/mm/run_vmtests.sh |   2 -
 2 files changed, 85 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 856decd2950a..172e7307eeee 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -31,6 +31,9 @@ static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
 static int collapse_order;
+static bool collapse_order_given;
+static int collapse_orders[NR_ORDERS];
+static int nr_collapse_orders;
 static int pagemap_fd = -1;
 static int kpageflags_fd = -1;
 
@@ -1550,6 +1553,7 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    Defaults to every supported order below the PMD.\n");
 	fprintf(stderr,	"\t\t    With -s, -s names the mTHP source order for the\n");
 	fprintf(stderr,	"\t\t    mixed-source case (source order below the target).\n");
 	exit(1);
@@ -1557,6 +1561,7 @@ static void usage(void)
 
 static void parse_test_type(int argc, char **argv)
 {
+	bool mthp_context_implied = false;
 	int opt;
 	char *buf;
 	const char *token;
@@ -1568,6 +1573,7 @@ static void parse_test_type(int argc, char **argv)
 			break;
 		case 'c':
 			collapse_order = atoi(optarg);
+			collapse_order_given = true;
 			break;
 		case 'h':
 		default:
@@ -1575,12 +1581,25 @@ static void parse_test_type(int argc, char **argv)
 		}
 	}
 
+	/*
+	 * Both orders end up as array indices and shift counts, so neither
+	 * can be negative, and a zero collapse order asks for base pages.
+	 */
+	if (anon_order < 0 || anon_order > hpage_pmd_order)
+		ksft_exit_fail_msg("-s takes an order in 0..%d, not %d\n",
+				   hpage_pmd_order, anon_order);
+	if (collapse_order_given &&
+	    (collapse_order <= 0 || collapse_order >= hpage_pmd_order))
+		ksft_exit_fail_msg("-c takes an order in 1..%d, not %d\n",
+				   hpage_pmd_order - 1, collapse_order);
+
 	argv += optind;
 	argc -= optind;
 
 	if (argc == 0) {
-		/* Backwards compatibility */
+		/* Everything that needs no argument of its own: anon, every context */
 		khugepaged_context =  &__khugepaged_context;
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
 		madvise_context =  &__madvise_context;
 		anon_ops = &__anon_ops;
 		return;
@@ -1591,13 +1610,19 @@ static void parse_test_type(int argc, char **argv)
 
 	if (!strcmp(token, "all")) {
 		khugepaged_context =  &__khugepaged_context;
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
 		madvise_context =  &__madvise_context;
+
+		/*
+		 * "all" sweeps the mTHP context in, but it only has anon
+		 * cases: step it aside for the other mem_types rather than
+		 * refusing the whole run.
+		 */
+		mthp_context_implied = true;
 	} else if (!strcmp(token, "khugepaged")) {
 		khugepaged_context =  &__khugepaged_context;
 	} else if (!strcmp(token, "mthp_khugepaged")) {
 		mthp_khugepaged_context =  &__mthp_khugepaged_context;
-		if (collapse_order <= 0 || collapse_order >= hpage_pmd_order)
-			usage();
 	} else if (!strcmp(token, "madvise")) {
 		madvise_context =  &__madvise_context;
 	} else {
@@ -1613,20 +1638,20 @@ static void parse_test_type(int argc, char **argv)
 		read_write_file_write_ops =  &__read_write_file_write_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
-		if (mthp_khugepaged_context)
-			usage();
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
 	} else if (!strcmp(buf, "file")) {
 		read_only_file_ops =  &__read_only_file_ops;
 		read_write_file_read_ops =  &__read_write_file_read_ops;
 		read_write_file_write_ops =  &__read_write_file_write_ops;
-		if (mthp_khugepaged_context)
+		if (mthp_khugepaged_context && !mthp_context_implied)
 			usage();
+		mthp_khugepaged_context = NULL;
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
-		if (mthp_khugepaged_context)
+		if (mthp_khugepaged_context && !mthp_context_implied)
 			usage();
+		mthp_khugepaged_context = NULL;
 	} else {
 		usage();
 	}
@@ -1648,6 +1673,7 @@ struct test_case {
 	struct mem_ops *ops;
 	const char *desc;
 	test_fn fn;
+	int order;		/* mTHP contexts: the collapse order */
 };
 
 #define MAX_TEST_CASES 256
@@ -1663,6 +1689,7 @@ static int nr_test_cases;
 			.ops	= o,					\
 			.desc	= #t,					\
 			.fn	= t,					\
+			.order	= collapse_order,			\
 		};							\
 	}								\
 	} while (0)
@@ -1703,10 +1730,37 @@ int main(int argc, char **argv)
 
 	parse_test_type(argc, argv);
 
-	if (mthp_khugepaged_context &&
-	    !(thp_supported_orders() & (1UL << collapse_order)))
-		ksft_exit_skip("Order %d is not a supported anon THP order\n",
-			       collapse_order);
+	if (mthp_khugepaged_context) {
+		unsigned long orders = thp_supported_orders();
+
+		if (collapse_order_given) {
+			/* -c pins one order; it has to be one we can build */
+			if (!(orders & (1UL << collapse_order)))
+				ksft_exit_skip("Order %d is not a supported anon THP order\n",
+					       collapse_order);
+			if (collapse_order <= anon_order)
+				ksft_exit_skip("-c %d needs a source order below it, -s says %d\n",
+					       collapse_order, anon_order);
+			collapse_orders[nr_collapse_orders++] = collapse_order;
+		} else {
+			/*
+			 * Otherwise every order a collapse could produce.  -s
+			 * makes the fault path hand out folios of that order,
+			 * so a target at or below it has nothing to collapse:
+			 * the sources are already the size being asked for.
+			 */
+			int first = anon_order + 1;
+
+			if (first < MIN_MTHP_ORDER)
+				first = MIN_MTHP_ORDER;
+			for (int i = first; i < hpage_pmd_order; i++) {
+				if (orders & (1UL << i))
+					collapse_orders[nr_collapse_orders++] = i;
+			}
+			if (!nr_collapse_orders)
+				ksft_print_msg("mTHP cases skipped: no order above the source\n");
+		}
+	}
 
 	if (mthp_khugepaged_context) {
 		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
@@ -1760,7 +1814,17 @@ int main(int argc, char **argv)
 	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
-	TEST(collapse_full, mthp_khugepaged_context, anon_ops);
+	for (int i = 0; i < nr_collapse_orders; i++) {
+		collapse_order = collapse_orders[i];
+		TEST(collapse_full, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
+	}
+
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, read_only_file_ops);
 	TEST(collapse_full, madvise_context, read_write_file_read_ops);
@@ -1768,15 +1832,8 @@ int main(int argc, char **argv)
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
-	TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
 	TEST(collapse_empty, madvise_context, anon_ops);
 
-	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
-
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_read_ops);
@@ -1849,7 +1906,15 @@ int main(int argc, char **argv)
 	for (int i = 0; i < nr_test_cases; i++) {
 		struct test_case *t = &test_cases[i];
 
-		ksft_print_msg("\n# Run test: %s (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
+		if (t->ctx == &__mthp_khugepaged_context) {
+			collapse_order = t->order;
+			ksft_print_msg("\n# Run test: %s (%s:%s, order %d)\n",
+				       t->desc, t->ctx->name, t->ops->name,
+				       t->order);
+		} else {
+			ksft_print_msg("\n# Run test: %s (%s:%s)\n", t->desc,
+				       t->ctx->name, t->ops->name);
+		}
 		t->fn(t->ctx, t->ops);
 	}
 
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 2652a7920b80..8bf898b71350 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -412,8 +412,6 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
 
 CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 
-CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
-
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-- 
2.54.0


