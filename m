Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87632C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504D76B00AC; Tue,  8 Sep 2026 08:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6D26B00AD; Tue,  8 Sep 2026 08:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294046B00AE; Tue,  8 Sep 2026 08:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E158F6B00AC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81A06140371
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:41 +0000 (UTC)
X-FDA: 85190581602.21.B0E6D1F
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf19.hostedemail.com (Postfix) with ESMTP id 992D11A000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H Tpu1xQ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="D4q1B/++";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871899;
	b=xRkWih55bRKgdNEhUkZd1xxdTjLh/JglMGHzwLPDaMD9T7x796WY7JcJ6HJCflArT6Xuet
	F//f/GC1nlywBsQvIFNR+9M2LOil8VWf9hQ8QpKrwDyuC8LiCs2pMamOtr90U3VrIu0IrI
	qr2J4NeC1GJnAHTc2+jbYulwb2unpMk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H Tpu1xQ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="D4q1B/++";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JApbG+zgN459BPFaPp1XWqEKWXjju/uVB62sf4HaQ60=;
	b=qXqhdAC7IxfjzG8MR696EqQuzWvzMaXlL3Q42/1bbs1VCMJ4aCHQvUvwDNVwQ2alOj092Y
	cDS4P4c6XbKLjrYK2Ue0ZEYX8K5Y5fheWcnMfzMMVCarb3L6yt6aQeo2W92RXVatzpnHOz
	4FRkQ02nS6gA09FPrZxaI4cgRc80TEo=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 371D1140005E;
	Tue,  8 Sep 2026 08:51:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 08 Sep 2026 08:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871899; x=
	1788958299; bh=JApbG+zgN459BPFaPp1XWqEKWXjju/uVB62sf4HaQ60=; b=H
	Tpu1xQNfJPjJcrMwnI5zC0euosdiHKzWh9LbQ9nJKv0lr9THAphvK+OauWaaIu25
	sPS+1g8JKgURGBaZ13Fy393fm6xWesz5ku1hmdfQHJB9HNE+YR1KuwvAywqgH/kt
	vJGNrpZ9nSM8BD2nrCGXLTaJhqsO9gApq7yMd7lsjiUKPkd5Wa3CzuUZi0AhLSQv
	Qw3gTsF+Qzxl3GtC5YHH8cbwj1RWvpRuKWvQNzNF3rYKvluMrH5si+tI5IT5wNeg
	+RC4gw8bCrE0n1m3iFH55SILyhT6kYlbXrHzTS45SbALulDUChY6Aiu8Nv/8FLpG
	YUNH883l5WxKKpDquSD/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871899; x=1788958299; bh=J
	ApbG+zgN459BPFaPp1XWqEKWXjju/uVB62sf4HaQ60=; b=D4q1B/++hfBNlEX56
	dsEwQAGIQf5czBRS6XBCiIZ2CHNEuhegMwsT+U+Jnr3R0jOCisPqx63ljrde1boh
	lxNWuRoJiH0tAut9Q/5uAdV3OxGoa4yqTgEVua1UsX5c0nTw1qyeHsKXxyTHbR+I
	KRIZ+qm8vYylB/R503dtgJM9Roh61tz/wkKpBtw8kXhkuLMHnI9Gig0vHGrErEpw
	SVNYRWaPg5ELJzwhCp4KG6fBxV5ypBf0tVssCR3VpKC22ShcMM0YBgycZbalHKpr
	65sauOZDcR9mZqDrNaaMEbdGIInA+BcEHmzKzeO5aGnygDUcV4P8hN+0ITuxdmbS
	t7/6g==
X-ME-Sender: <xms:2gSgaqUTmL_n_Db1gDiVMxXnR1PGfqMD9sWm28qTdP0Tyhacav7B_w>
    <xme:2gSgau8zx9G5kVEE53ZhQ9aXcWbJKlJwJXx9uZsG2okHTM11vJexPHLGEHFsQ9RFA
    BJSaNzeMvFFMitM5ioMA_GXbcKn0S09AXRHTP227AzNLX9_SUq3uNz->
X-ME-Received: <xmr:2gSgagkvkpcx1dTF_WTp-UkX2HUrBxK-U8QFCwwe92msyQOXKdeCYZQWmRg>
X-ME-Proxy-Cause: dmFkZTFCT83ts3xpHDuUgDdlzQtELcoAknrXBpsFepmdcEBLccwduWOOVyAuau0VlYvm49
    objBvbnGefvuHsKXiB+MOl7qErn3M4/Q7Z72R+asBFni+WG6jRYqPjjJBv1F7ovmfnEZp3
    uEJcbLADGcdxsWcYxdWct2wwV9KQaoOTpGWM7Il7/oKOILrVOp7MvqHbWAXdA0mgRBniUZ
    2M+Su4Zoe9zFbzekNirjNltohahTSfzaLbYZTkGXD/hRQ+ajqkABo2HdEn2GJrc7g0w4Iu
    PhTUexE0AKZ4j2dsA7W9i19VnbZvZZgTTujH64lpg2nDW6KlKK63jDlRsrLETwVfJ8WCLQ
    UtmPZMHn5ay6tSoqiUnd6aERERueDUk7m1Mgai0xS1+/KuDn4S87fMT5aaKasKywkBgE6M
    5mAQT7N7pXGr2zqzH4MUoTyBkuHaDOCs6jb4yma4TOqJS2Agge58jZ0eWBs0O4U041BCgp
    v3uVn2+sOHEEb0jzEkvs/X5aSPHcXSCFEzS+xuSKoWu4vPBUoRt2A4533btw9z4rbJ3vux
    AP7Ot8KS571U9VQFPuETi6D7vhJrqU+nDWHrFlRbU2lO3ukuxC6nlRKGG4SMeuZCm4VDea
    S3mVzB5nkhgLKRjG7R8N+1/8PJoC4wpvvNpB9I5aH+Su1LDqiLPEzyN1MBww
X-ME-Proxy: <xmx:2gSgapJOKvvqGAIbj-0YWkQ7S36yOcAPdXXobWs51rij_d9ienY6AA>
    <xmx:2gSgamoJBEjntO494nSHxEZ8bZ6kyjdlwqKwZHolriXpKTzwTnwnWg>
    <xmx:2gSgamSd9CdpfO7eLTqaFn-IgxrjL_XBQ_WuvCkaJsSAcDJC_mQkRg>
    <xmx:2gSgap6FsDw_GBuRSLR8CbiwtQJXcwyYMNv3CvZpRTluKebvOVUPOQ>
    <xmx:2wSgapm9D-LWDTdUQy7ZpRBG3KpGR949fE1MKKbTboeV8YdqtGB4RMxr>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:38 -0400 (EDT)
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
Subject: [PATCH v5 14/19] selftests/mm: run every supported collapse order by default
Date: Tue,  8 Sep 2026 13:51:00 +0100
Message-ID: <20260908125105.1510704-15-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 992D11A000A
X-Rspam-User: 
X-Stat-Signature: ok9gbuuoojfycoawz7iarnoowe33msq8
X-HE-Tag: 1788871899-244482
X-HE-Meta: U2FsdGVkX1/q+runYC5re/UzDG8Q3/I0ovTFx5csR6gluNFgfwxQc2PWqIR0qqVhrGRmsYY5T6nnTGzG+HFRH7VyeUgbzh0fhhm2wYAelFjbetzIsRO6ZDviVKvfp2Gszj1MPFqGBozpreD9G3bwfxZ4x9ET3jsMuq4vya2h2oawc/IfCp9mu2TlUri3oCVenp2Jwb1I75wiOmtFvH85dzVFI0se0EkT0TVQi5hRYwEq8PfAX9PpMHvuTydRvh/nTwsba2AX0skbNTRzhikifwiPmMd2TBF0rxa4FRiMdCFbFPUzSbGx1+x7+Sk0OC445vhYDUVdeGTcVwMtMCRnKTzbJjflqqrE8KazgyCgXMzS87V/PhHj1+K6cidvHwCdJPKcrLcjsmLTYob+EDwhjb18Zt5iLdTZztuyiJAAuABB3AIVdbygJ2uW4Idd67Lr7DLLASBZDdxsla9zHxRdzX6HkkSQImHyR5V3bAEgWfj9989PYLbaH+Alvz/DrcEC2s2RwtXSRrj648v0Zr9g5AWrcE7Un/2royxGlM9vQ76B8PVONOBMm9nHqRYzP570cLSfv/4PPmjT5BC+uT/Xq2B0IC8mMsJ7VhzrNJ5GdEvUxHRXoYzSvQ18moaQFZsQr+ZjJn2P8kC/KyCcPBzwTk9CFNqGm+WNWd+BdloAYRvXJIrBUOhxf2qENsJbjy6x3xmyjSYprdWFHmj2vqzw0YgD8rOVSLKmUJsVstE12UA5fz2l5u0hjKDQt0kM4Lm7rrRWfznn4ozCUFK7C5zDCW1vMa1KrzPpdC+bMHIa/5igbKmkMofGzlP5QRSc2S6G3XmXpJlFokl6C73iQw/HBYh3/iCYqSyGN6bD2tjMV1WuP73Nn2O4APmyAKIoxTS2MkHBAKdY8IFGcwgZ7vKvC5uPZc3u1cgNBSlIy44W40IIxub5BqVKkuArpjgM8iSWaPfOwkHESPZElVCoM3M
 +irSLMYy
 7D6ZlqPVIA79NEnTXxs+5EuIg/NIQsVsBi50eBMvsSRh1Sze5gfdsL45XVclzfCuEp8NCRecKa2tp2qeaJ7Gol/f5cuDfu2gYfWvDg0MNPOqimhJtubOGlFXHQ8WO8vx6RxuJBq4K2Bo/+PLN9eLRSM+mlE9Czd5MNh+ymlSipFLhZluU1jHhB3dVA/iJMpRW50Zv2bTgO8LR4UvxqBnve1eVNxKA+ZVkjLyA1ZZI+qXrmJja7Ihg0TKGh20bou4DDI3Z9H1kJDgLMTIzChSXjaI+9TmHQQ5S2esyeVUQ2ezr8RGCVc8w7N1BHLOxCQ5uYRpVAEvrpkQ+QBYiGOtJ9pXh/U29o26VSH1IYAaa1IhANe99it03WbL+09v//w9XI3p+HKTqIaq8i5AKS8CtNl9gR9fc6jVlMmRg8nZ/DV8zGXrVCrX61raE1OH6XK81rleX2UjmexIPt7a7PaGfsCAHP6MglkBJ/9IvLQqZhlWMBAGdv8qDrx0cdS61goWtcBFe0Vg8+/xSiN7GtvfoVbXvCZ1cRSwnTe5H
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
and "all".  Also:

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
from 29 results in 17 seconds to 77 in 29, so run_vmtests.sh can drop its
pinned order-4 line.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c   | 98 ++++++++++++++++++-----
 tools/testing/selftests/mm/run_vmtests.sh |  2 -
 2 files changed, 78 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f5d4847c50cd..335f946eca61 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -31,6 +31,9 @@ static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
 static int collapse_order;
+static bool collapse_order_set;
+static int collapse_orders[NR_ORDERS];
+static int nr_collapse_orders;
 static int pagemap_fd = -1;
 static int kpageflags_fd = -1;
 
@@ -1517,12 +1520,14 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    Defaults to every supported order below the PMD.\n");
 	fprintf(stderr,	"\t\t    -s, if set, is the source order for the mixed-source case.\n");
 	exit(1);
 }
 
 static void parse_test_type(int argc, char **argv)
 {
+	bool mthp_context_implied = false;
 	int opt;
 	char *buf;
 	const char *token;
@@ -1534,6 +1539,7 @@ static void parse_test_type(int argc, char **argv)
 			break;
 		case 'c':
 			collapse_order = atoi(optarg);
+			collapse_order_set = true;
 			break;
 		case 'h':
 		default:
@@ -1541,12 +1547,25 @@ static void parse_test_type(int argc, char **argv)
 		}
 	}
 
+	/*
+	 * Both orders end up as array indices and shift counts, so neither
+	 * can be negative, and a zero collapse order asks for base pages.
+	 */
+	if (anon_order < 0 || anon_order > hpage_pmd_order)
+		ksft_exit_fail_msg("-s takes an order in 0..%d, not %d\n",
+				   hpage_pmd_order, anon_order);
+	if (collapse_order_set &&
+	    (collapse_order <= 0 || collapse_order >= hpage_pmd_order))
+		ksft_exit_fail_msg("-c takes an order in 1..%d, not %d\n",
+				   hpage_pmd_order - 1, collapse_order);
+
 	argv += optind;
 	argc -= optind;
 
 	if (argc == 0) {
-		/* Backwards compatibility */
+		/* No arguments: anon under every context */
 		khugepaged_context =  &__khugepaged_context;
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
 		madvise_context =  &__madvise_context;
 		anon_ops = &__anon_ops;
 		return;
@@ -1557,13 +1576,14 @@ static void parse_test_type(int argc, char **argv)
 
 	if (!strcmp(token, "all")) {
 		khugepaged_context =  &__khugepaged_context;
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
 		madvise_context =  &__madvise_context;
+		/* The mTHP context has only anon cases; let other mem_types drop it */
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
@@ -1579,20 +1599,20 @@ static void parse_test_type(int argc, char **argv)
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
@@ -1614,6 +1634,7 @@ struct test_case {
 	struct mem_ops *ops;
 	const char *desc;
 	test_fn fn;
+	int order;		/* mTHP contexts: the collapse order */
 };
 
 #define MAX_TEST_CASES 256
@@ -1629,6 +1650,7 @@ static int nr_test_cases;
 			.ops	= o,					\
 			.desc	= #t,					\
 			.fn	= t,					\
+			.order	= collapse_order,			\
 		};							\
 	}								\
 	} while (0)
@@ -1669,10 +1691,35 @@ int main(int argc, char **argv)
 
 	parse_test_type(argc, argv);
 
-	if (mthp_khugepaged_context &&
-	    !(thp_supported_orders() & (1UL << collapse_order)))
-		ksft_exit_skip("Order %d is not a supported anon THP order\n",
-			       collapse_order);
+	if (mthp_khugepaged_context) {
+		unsigned long orders = thp_supported_orders();
+
+		if (collapse_order_set) {
+			if (!(orders & (1UL << collapse_order)))
+				ksft_exit_skip("Order %d is not a supported anon THP order\n",
+					       collapse_order);
+			if (collapse_order <= anon_order)
+				ksft_exit_skip("-c %d needs a source order below it, -s says %d\n",
+					       collapse_order, anon_order);
+			collapse_orders[nr_collapse_orders++] = collapse_order;
+		} else {
+			/*
+			 * Every supported order above the source: -s makes the
+			 * fault path hand out folios of that order, so a target
+			 * at or below it has nothing to collapse.
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
@@ -1721,7 +1768,17 @@ int main(int argc, char **argv)
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
@@ -1729,15 +1786,8 @@ int main(int argc, char **argv)
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
@@ -1810,7 +1860,15 @@ int main(int argc, char **argv)
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


