Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CAB9C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF826B0767; Fri, 14 Aug 2026 21:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6336B0769; Fri, 14 Aug 2026 21:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC3D6B076A; Fri, 14 Aug 2026 21:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 959916B0767
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28B00802BD
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:40 +0000 (UTC)
X-FDA: 85101847320.09.384C499
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf08.hostedemail.com (Postfix) with ESMTP id 586F4160005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r sXM3TN";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=d2mRcc5i;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qPwRkvpOUtfuWl8Vd1ZbS3CmUow1OnKorGDRJPSt44=;
	b=0i8350uAJjMq2UU/0/2dZxG80+rxXLgV6n9s/A0cy7tAIT6dxAdMEC2jL/o43XhHvxFYMx
	GeNDf6tZzbF4qd+PSDEdC7IE+cSNeJUzGoEH1h7Zz0/rCC8OHbSoswkUGidI7RB++bZDGW
	c5HDqs5IT7JPu7S6r9Iy6ox/WkBC5KA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r sXM3TN";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=d2mRcc5i;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759178;
	b=JOEB9T7EvTFNosrZFyj1T+Jn2bNRLTWfmYzojbee6nTtuzOn4LnQIjvWcgxKUSxEJapt3G
	fRQI6Y71w7A9w23z5tgBoq6aJZnN2RpfpdjMVoWZ/8EJC7yQfD1NJmtS/CIvI74PEjViBp
	FSAzkd+wG/b1DXWF3nUjFJFfhpVdMzw=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id ED405EC022A;
	Fri, 14 Aug 2026 21:59:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 14 Aug 2026 21:59:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759177; x=
	1786845577; bh=4qPwRkvpOUtfuWl8Vd1ZbS3CmUow1OnKorGDRJPSt44=; b=r
	sXM3TNOpkQ0bDeikayo57HaHNhnZFPxRt75G1/GaU9VjnOJd6Dx28jcDjB9MgJ1m
	Bi4i7urR9KcvIF0FoY0VY2VPT2HWUOC6f6rwhjNVwyxjhz3BJtAZFFvoXYlJKN0e
	56tyL1CldILvlz/uoJ8g3fUSdJxYyTKIhjCT7CzbQcnDsNXAMlD4Qb7lvF/ddzUi
	yMKRx2KapfEyjrHR6GoJWGvOZ+NobGhglYb2b7COYNG0RBYoj+s7Z/wpZMrHNIpi
	shDxeiq0kXbNtJ5ckkIWcAnmnG762dE95fF2+WaX29szf2PDmhCLY6ckoZDkRkYG
	GOEfygKz5PdL1CBcS8/eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759177; x=1786845577; bh=4
	qPwRkvpOUtfuWl8Vd1ZbS3CmUow1OnKorGDRJPSt44=; b=d2mRcc5iYTpWw90KA
	+ukgAtBxmM/BXvSMYtVfjRq7FFNjPCyJMaDVXB/cpO+cUsqB81g4J1KPx0bgwKHU
	jEZ5rg1aSEV5Bac+0wBeA7EQCDrML2ukAl/3wQr+m8Fg2ykzivLoPQS2WJj01gNs
	aVD3VPG3hoHvMafkysQr7nV8QO3acQUgoxrkTmBO85icJ3VKIOGATz21kxBhGgK/
	vQ6x5urYBBGMg8w/Dxd3egYlfcheggsYeliXz6pkjX704bLAu5NYu3P0M3tlmqJC
	g7rEvEM5vlmq8NbUpOvwAQGGWnGLlugyeWGvEACUNGYnC2c2cBsfxqJxaMaZ2r/4
	MDbjA==
X-ME-Sender: <xms:Cch_anTw-CV5WEmxftfZRwCAM4L_cnjw9W6v8UNFeToM06BFH-0fvw>
    <xme:Cch_asvgIOTM9JjpRj0hLXE770tKR_D52JhJw8lNOTRJKxVnVx2N5vlIWACTUdfo4
    i6iR-CU_V4s55WcXEmPtfPLFo2NoG8s--lkpqRuLZ2CRDCi_XMeog>
X-ME-Received: <xmr:Cch_alVY1zkeZDOyQVYjRKj6lGhe4vvx6wL1jZL50eN5xv0VGLfQJwbLok0>
X-ME-Proxy-Cause: dmFkZTFzGpGFm5W4vTTPFWblEwVteikp8ZQmNhgJQ39PW7T7XQcfx50sk9SsorwQ5kiHE1
    GkGyp58aXi1XV7w9FWqCEkAAXyywQWDaCYDP4jk79Tj+fneRM/f70WhpHyk68ivSHa8CNO
    EHCv/WuNeVKTxC+1Am5pTEbXGz94MYKYsyM7kpGX5dHsQKSWoIOFoaOZhong5pPq1D5dt9
    kZJFmHpp6Lnk5BJwnqgflVky13nVISEGlBe9NK3zcAVq5kZlGc2PqnLHdjdexqJ0GH5I+D
    CyEe7NNeMVRnhwRmAQGYSBBJ6RBvmXxfczeNb/t4Esr0tR7Igh8W/aIlPiSt8FyWTQd+Pj
    ToEO9Wkaygl0tzRAxiOsUatANGv0MavqvzeRLvpV66n2CVAAFVetansC73Poslu2NI22gA
    LuHvDL56Nnf4nUNnsl4rmbfcyV9TlDqb+JYRr3GQDIpUzFXIeaG+3jlY1/8ryaOqdzRLTK
    VtHSqOmREIUGrw8+Iys5g1m2eidfl+Bv3ONAEXMe4a64tisQZfxfMPAUAo/gKuVWCkyEEG
    SUz0UTj52k6v+IGP3gFtAK34688BHEl6p0pyK0rKrQrIGqVfA1wGz39ATLzIvU+mkOx07L
    1otNCfkXJ4SeWOft+a/+wzrLVnGem4uE1OwH4u0ngNjV7ERIrg7+vp0XONPQ
X-ME-Proxy: <xmx:Cch_agkLRbBIYG60hz5IfPn4h9Cm1Wobze2s-t5-4uaDtD-C4A2nEw>
    <xmx:Cch_aoAbZN4zMSYj3_OYPILMG6Yei6IjGJF7nftTN3FPVdRNu3MhhQ>
    <xmx:Cch_al_HnfqA9QqjZoLdGvDxyONwtI8Md0NS87loOh1pqGzJ9hgMBQ>
    <xmx:Cch_aqRj0vNwu64A-NCW5napaXHnvGkjEh7EF3Umi3okoZVOCUZ_zg>
    <xmx:Cch_agw4jd-SExfx1QJwjyB9voTG2HQGW4G3GNtXE4uwJ5VSHyarN1Z8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:37 -0400 (EDT)
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
Subject: [PATCH v4 17/19] selftests/mm: race collapse of windows with holes
Date: Sat, 15 Aug 2026 02:58:59 +0100
Message-ID: <20260815015901.1236937-18-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 586F4160005
X-Rspamd-Server: rspam07
X-Stat-Signature: rguxaw6359ffa7c7kkrfmqqubpe4b6z4
X-HE-Tag: 1786759178-284776
X-HE-Meta: U2FsdGVkX1+nLA3nLgqtqGquGYNWi/yuVtTLWOQ8NcjByeO0ROIJiUEjxl6GJDJGEd8tKfGLYrDeWjUpLj0BG4wHBMZoSj5UmNqasRlDCgKCxv9GuP0UGAuubTciQ9GsJbGFVEF6d07CeUTz4g8oqA1F5L/3PkMdRyBGxorfeYvw8ueKL7aHwjVOIeTGCDO1bi7NUPGi/9YdWVpsaKPAiH9mtdnu7WVvVReJJOVNLgbInBcQxsdp8iqdvaNwdoXJfPcf6sqLc8UdGzw0henTlRhjVPn6GRjA7gIyum378rri+WQGAcOngRUSeHDfwf5XFcLfPPEIHanEtWhnSff1CuS+u4oOTN/6aRCnImOTm9nnMGM3CsvJNIX9d3TgQ5WOzibhZGxXOftArcJ+AylLLN5u3k8vN7ycMLCFkxNvwJzv7svZ6/lMgaaLW7bu2Otjq+fs+5K9O5bbPXxm9jS3iTxeq+9oq6kHhBEe6h8TurEI0TGXEkVCbSK8hiEJ+jDBXYT7p+4Pa+0/260gmIC9eYIvU569KGuQCezheOx81wIl8oaH8W2Y6cBzrqCX05xGi08eDA4xSriPBPpkc2o0uYg7hcWPXTcZxBXK0UNt2F7pflrcDlLL4SuJF6/gYahmq/nmTLrXJUjf4Rrwx0Ih/KCXmwYAYyRfq6k+4gTpoBUeqIGCPbnL4z7tapHP+bYr1Xzum6fWJO/ORcuAta1cu9T7YZlVQfUe/zOp3A+8GYxnUFQonRgkggwbJIR+GNJgQfjNGOsbygsdVSSkRFzdkimsW9q0TuT5a585aXm5YUk9wbVW+PwjagYkyenRXTscrpv1QdDTyiRqdXpXcm6lAF8KPRE2r4oACw2Ajq4S+EgipsOnKS8n5cEfFdl9GHMVadyGBHvtY9VyawUWiAnLBbSlC8AkWLlJ2J1Jlem/NBHSenuc1xMN75thG/QxKPkT203d3Dvnk9TFT54YPBV
 ZBRQUjPG
 bUj2894jexGd9i0PMBUMgO/JZVnv6X9VHIOK0IkRhJfTyq2YexIcldkGVZZY0/H/bo5fbFoRFqp6G+db5M16HBjji9y647ADGxTNYGa6F7g6c5O1LYABUxEiomGvbxP/yJTNFSvWb2MvOCCm0G3Bj3b/ZVeBpphvGfIAaTBuwjN9MuWQO3mBpaMwLND7lKFQjTGY0zj/2/8cyZ9MBYg/NoxAvzL9hzE6OhYcdLWo3TKAS0/u7yac2628LugquN4v5dCrLdGDnBf8TNEnSgJ+jhNWac2kyz2Qq0CgFQCfDEQkx3a0f/5XK5BMLwYlX/Z1EjH2d7mxqN7ojIOhaWL96A6yyPJJb2xWKChEw/qA3h2cd7zlHQChVODM5YRDN8oT0rpPjsp7oOZXGL3qVVJ8ty/o6vMr7O9H2sWJO6A82xC7stGgB+Mcie4Lr1AK5+OAwl5IjzQf0ZIrs4PltiukcXiVY+nlEPDklS0KyHuEWToR/BBIYn3FKJ064NoF5df69Wn5V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness pins max_ptes_none to 0, so khugepaged only collapses a window
once every PTE in it is present.  A window with holes takes a different
route, and never gets raced.  A hole is zero-filled into the new folio by
clear_user_highpage() rather than copied from anywhere.  Which slots count
as holes keeps moving under the racing MADV_DONTNEED, right up to the
moment the PMD is detached.

Run both ends of the occupancy scale for every driver mode, one after the
other.  mTHP collapse supports only those two, 0 and HPAGE_PMD_NR - 1, and
coerces anything between them to 0.  Each result says which end it ran:

  ok 1 stepped/strict: 5s, 231 steps, no corruption
  ok 2 stepped/holes: 5s, 194 steps, no corruption

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 45 ++++++++++++--------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index 3128031e28bc..3b369046edf5 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -11,9 +11,11 @@
  *   free	khugepaged left to run (scan_sleep_millisecs=0), for soak;
  *   madvise	MADV_COLLAPSE and MADV_DONTNEED in a loop.
  *
- * All anon THP orders are enabled (inherit) and max_ptes_none is 0, so a
- * window has to be fully populated before khugepaged will collapse it, and
- * the racing MADV_DONTNEED decides which orders it can still use.
+ * All anon THP orders are enabled (inherit).  Occupancy runs at both ends
+ * of what mTHP collapse supports: max_ptes_none 0, where a window must be
+ * fully populated, and HPAGE_PMD_NR - 1, where a window full of holes
+ * collapses too.  A hole is zero-filled into the new folio rather than
+ * copied, and the racing MADV_DONTNEED keeps moving which slots are holes.
  *
  * Correctness signals: every racing page must read as its pattern or
  * zero (MADV_DONTNEED), never anything else.  The faulters and the fork
@@ -247,6 +249,8 @@ int main(int argc, char **argv)
 	const int nr_threads = ARRAY_SIZE(thread_names);
 	pthread_t threads[ARRAY_SIZE(thread_names)];
 	static const char * const all_modes[] = { "stepped", "free", "madvise" };
+	static const bool occupancies[] = { false, true };	/* strict, holes */
+	const int nr_occupancies = ARRAY_SIZE(occupancies);
 	const char *one_mode[1];
 	const char * const *modes = all_modes;
 	int nr_modes = ARRAY_SIZE(all_modes);
@@ -279,6 +283,7 @@ int main(int argc, char **argv)
 			usage();
 		}
 	}
+
 	if (mode_arg) {
 		if (strcmp(mode_arg, "stepped") && strcmp(mode_arg, "free") &&
 		    strcmp(mode_arg, "madvise"))
@@ -318,7 +323,7 @@ int main(int argc, char **argv)
 		 -1, 0) != (void *)mremap_scratch)
 		ksft_exit_fail_perror("mmap() mremap scratch");
 
-	ksft_set_plan(nr_modes);
+	ksft_set_plan(nr_modes * nr_occupancies);
 
 	thp_save_settings();
 	thp_read_settings(&settings);
@@ -330,8 +335,9 @@ int main(int argc, char **argv)
 	 */
 	thp_push_settings(&settings);
 
-	for (int m = 0; m < nr_modes; m++) {
-		const char *mode = modes[m];
+	for (int mn = 0; mn < nr_modes * nr_occupancies; mn++) {
+		const char *mode = modes[mn / nr_occupancies];
+		bool holes = occupancies[mn % nr_occupancies];
 
 		thp_read_settings(&settings);
 		settings.thp_enabled = THP_MADVISE;
@@ -341,14 +347,16 @@ int main(int argc, char **argv)
 		settings.khugepaged.scan_sleep_millisecs =
 			strcmp(mode, "free") ? 1000 : 0;
 		settings.khugepaged.alloc_sleep_millisecs = 10;
+
 		/*
-		 * Strict occupancy: mTHP collapse only supports 0 or
-		 * HPAGE_PMD_NR - 1 and coerces anything else to 0 anyway, and 0
-		 * also keeps khugepaged from burning the whole step in doomed
-		 * PMD-sized allocations on 512M-PMD configs: under racing
-		 * MADV_DONTNEED a fully populated PMD area is rare.
+		 * mTHP collapse only supports the two ends of the occupancy
+		 * scale: 0 or HPAGE_PMD_NR - 1 (anything else coerces to 0).
+		 * Strict needs a fully populated window, which is rare under
+		 * racing MADV_DONTNEED; hole-heavy windows collapse instead,
+		 * so the two ends race different paths.
 		 */
-		settings.khugepaged.max_ptes_none = 0;
+		settings.khugepaged.max_ptes_none = holes ?
+			(hpage_pmd_size / page_size) - 1 : 0;
 		settings.khugepaged.pages_to_scan =
 			nr_areas * (hpage_pmd_size / page_size) * 8;
 		for (i = 0; i < NR_ORDERS; i++) {
@@ -415,8 +423,9 @@ int main(int argc, char **argv)
 			check_page(i);
 
 		ksft_test_result(!corrupted,
-				 "%s: %ds, %d steps, no corruption\n",
-				 mode, duration_s, steps);
+				 "%s/%s: %ds, %d steps, no corruption\n",
+				 mode, holes ? "holes" : "strict",
+				 duration_s, steps);
 
 		/*
 		 * Hand the address space and the settings back before the
@@ -430,9 +439,11 @@ int main(int argc, char **argv)
 
 		if (corrupted) {
 			/* Memory is suspect; the rest would prove nothing. */
-			while (++m < nr_modes)
-				ksft_test_result_skip("%s: skipped after corruption\n",
-						      modes[m]);
+			while (++mn < nr_modes * nr_occupancies)
+				ksft_test_result_skip("%s/%s: skipped after corruption\n",
+						      modes[mn / nr_occupancies],
+						      occupancies[mn % nr_occupancies] ?
+						      "holes" : "strict");
 			break;
 		}
 	}
-- 
2.54.0


