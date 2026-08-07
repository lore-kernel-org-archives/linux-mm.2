Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67280C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088016B0095; Fri,  7 Aug 2026 07:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060616B0096; Fri,  7 Aug 2026 07:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5F86B0098; Fri,  7 Aug 2026 07:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCFFF6B0095
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 471A01202CE
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:02 +0000 (UTC)
X-FDA: 85074271884.23.508E5F0
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf25.hostedemail.com (Postfix) with ESMTP id 45E54A000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h 5zdipv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gssPUSgF;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfbh3GHFEDkfsexwK0f+yG1zta9ZtoxopU3TBc0ckuA=;
	b=L87mJttoTLlF6UrWkBkNmeE8oJdg9hxjnuasKO/7Bo+4GCvQE5xKiSoXU3HgBMIwvbBgWQ
	pU75Xu2Ty+VB7pPATj7/Sg0xYtaBugOEIDSLyydFAxbXQPJOYtgr/a3vPGsenpu4pi9Byj
	bRRo3QSyhwcex0L0jdIffOWZUnjrDiA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h 5zdipv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gssPUSgF;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102620;
	b=0DEXcK+mjJfsFzQcqjkWNDtXkKEz4NktieVJjlo7CT6Kr8OJVxTv1+HxZz19MrRJ2MIYqb
	4r4LnYVqsPSIQrAfjoRNCxFpdRfU7PuutBlL+1H7kg2X8jGZ+y8GYkWni3naHNKO6soEGw
	8gTjnbYIcyvLOCZmI8IowM7n8uViyq4=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0D1587A00C4;
	Fri,  7 Aug 2026 07:36:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Fri, 07 Aug 2026 07:36:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102618; x=
	1786189018; bh=zfbh3GHFEDkfsexwK0f+yG1zta9ZtoxopU3TBc0ckuA=; b=h
	5zdipvpvC02jD1Mf8nIqPvjVbTcuzSYiXHGXFxb+7el/Svcri/ADkztxbLz5GWL3
	KqfGfeF7oWtK3HIa2iebgzMTmX8hVd2q1d1vWi52xdzrdFR45O4HcAAQh05g/c9o
	2qOukZfHTa4OiaUzl86d/xnEBJ7QE4/gaQYEeUj+hoKYH4KKQoLm13HkE49dT540
	g7zq+5u+63wrlJttq/T0ie8rKfBGbfg0JcKHnsw7B/x7j/4peSbAQd2iJ8knd+Xy
	u8erj9JSdUMy2gl5r71rsM72CNrwN8lF1YP47VYsW/CTl8qVeieJDWKwMpR+U93/
	4evmsh1zumRZw9vjclrpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102618; x=1786189018; bh=z
	fbh3GHFEDkfsexwK0f+yG1zta9ZtoxopU3TBc0ckuA=; b=gssPUSgFT+Q7INiV2
	tQ1/YcEp833EIqd+keLsa6xOPmgW0gQlR4bZPJUnvaoOtQm8kJHA/v4/3YL1Jm6L
	YwZvYMF9sMlMok7tgJT8XrMUP+3oDe+1veAwjdAiR/PN+RKIgtHAr8t9IlUhJcQl
	c46NfKWL3XuCCdbbYf16kmkSV3u2g4ZTtFYt4bRd6wonYMfLs9QrNWYjhtwTDDiO
	dS7+Q3arOWlkGrjB30NABNDSFtB9BH+uAm4i/+XZ3TN99dOOfsaxCrM//85El/XB
	L8/SiYsVD5lFT6xDPZ47cgl1vu3mh4T02YGFvEJnKEvro8Rgm4/7i3Daa8y9ifJE
	2z86w==
X-ME-Sender: <xms:WsN1ajxhdv31ugW9kEmmV0CNnu3z6wPvJaFttsmDtu_ELA4y8zbORw>
    <xme:WsN1avOVPcAmM-9DgFTmfpOOPto6j_-iYOjsout26Zbei3C1s62ht1RJ84Nh9u87j
    wPAle8csmBC8HDLYLm00Ox4DKiJWZxsfRqFzSOvYGXW4PuNDC2fBrUs>
X-ME-Received: <xmr:WsN1al1qsm1_qo3RhlILNBoFynolNwu0n_Oh1rxDoEc2pJLk65V01he_ebk>
X-ME-Proxy-Cause: dmFkZTEfW3x2Qrq7ELqxlr/x69vk0aYaa/E/2AWrFAl7yu0Vg+jIGlS0mjOCk5J5e5/NJH
    T3J+l8M+cQ15gxg/u6FQhwxKudsrf7tN5cWcEThveGDS0KcOU0uMrzGx0YBmylEV4PfT2X
    SbTqClZY3SINVohR/2NzYRxeOu5tU+SgKqY1sS5oM8U15+ky277S+G1Ww7YAUM5Z6EK46p
    TQK1COWwyEQl/dhwe51H5lWCLFzTj8K9hkk/JBO/DvOgEgoe5sMihzFP04eKTIrZCF8dte
    tQwhoNU+zszgTlPncqprVsvTwAgpjyPciGBDZXKQScTz4u1orAuTZg8Fi2VomZsbF2qQaQ
    WX9kdIRFJUsNCeKzkNq4ymbXB/KQlMUzSHaY6cbAlDEBIXeOB8GtX5Jz9IxAs98YfmqVys
    qUOg8y01tLyLpPI4SZiwG0rtop3WKpCDrjgtoKCBxJBbeU2IEMYlxdlFMk+ayLhL+ZdCO/
    Y0kh9rPsL4eHcdlVUWt+xNYtPyuayojfxejvL8/ENVfvKva7UlexDsqTLfQFmefHNhwFLC
    NeoOEpJKUI6VIxeoPeAmv8h5L4IhZEzFBGCicLsjv4uRMpUGftkrAuJrOk0BYmnd2IBnr5
    AeBmqb+s6xoyvl+j5St0J+JNuAsOzEMoing/A1ja3RJXzjvRKr2LdXQOvUpw
X-ME-Proxy: <xmx:WsN1anHoHiakJwuHo2xNTPLJeVUkUbp_26I55ofeE_gD698vgR-5zQ>
    <xmx:WsN1asjQ8hR_hTycDaX3luy7QfV0udqf2j8UotQ6Eee3Nhxiqss_JA>
    <xmx:WsN1agenn_oNmPbYa-scVgvrhpz7Yv4YNFgtUch8XmlPjmrC0Ta1xw>
    <xmx:WsN1aiyOb4K1irk1ZVG_BYoDfnM1eHDC3M193Le2i1SfjrKFfWqlJA>
    <xmx:WsN1alSF04gR_c-3msl0R029L7vEpaT0libcMEp9GS2lCxmc8nH2GOIV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:36:58 -0400 (EDT)
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
Subject: [PATCH v2 03/17] selftests/mm: skip khugepaged page cache cases without a PMD folio
Date: Fri,  7 Aug 2026 12:36:33 +0100
Message-ID: <20260807113647.3744609-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 45E54A000F
X-Stat-Signature: myiygzs75jk5ictm13o8ehft739jxpbm
X-Rspam-User: 
X-HE-Tag: 1786102620-700785
X-HE-Meta: U2FsdGVkX1/fPj8bPMDo31fUqYlJtg2onVU5eRHf2BdmoCazY4FYKHGFehIR5kgnfcKLWgrbD805q9XbD9zw0+JXmkma5waAxnZ8yre2OCaPY7wVT1+kQKeKCYH5vaORN3UNPuDTSAhPfSdStg/VbgBqjjAb0c90C0gUEHyUfL3kU2dLXGtAqCO1m1l0dAmu8M+gadlFBp5jntoXGbLEhab3j2SsSQOLRv74ruDZ+Kax3GvrbW6wcsZTTexXqjDF7ATsiypp60cHaO3GN5aRfJS+lTQEiczSSoySTZxOAkcjvd3mbhCpejMPb3hqmXBtdXspQrWfnzg+G5FNzdpkxhNNmctAxlfOXU7wVbGviUj2E2N2cpoxKwBSM8LLHNth0IwYcnX0XDJToDVl5k7wsrcpvdrcBMxnq8vZ74MLtP4u1lto+HP0okJ1RO2d0Uo7OVN9BOEC24h66QpT6MCForEnUmL7xK5p2c1Dj8Fcf6oXMq1jegqzOaHUB+Dlr+dqwqDR/R7ZNvCSuiyMJHs3mDr9XPCLP2wG5j1EGVEPE4mD1WCVFmyFLgzIMEFirdnIQ46rO79Z7lJ36xtvrjpYWEbUoY444boAMHdT6NksWdndOvCnglINv380B9Z9Aj7Hj5GgPohB6TAN5VjJKpYVlKteZNAt5z3QVDmUmgUrrL5oXe7dve3tyu8mrcTo2gHdhtnSBC0gXBBbZ5X7q8lygKo6aQ4Dgekgcdz4KZafkr4La6Mv39thGT+3aGle7mCTZIEIjRJ5IXRuzqrnflDCXPriDBVTgrMX6oO6OCjttK2RwXeEeKyQflXLKUyDUT6MbxMOgiOWJTroTtWsAZsZR5IC/V607P4OaA5mRYldBtiKw79VLd0cCMhzmSUIT96Y3dvL2tn6MJZsKeEBRg7HlRV3C35qdcytHWl/OE9craZ/pqnC3n1aG1vzh5ZdgGV336y/w4azoeW/d6cJl2R
 In+jccRP
 wqy2AeyA6vGTk96zrhMZv1/alzhWaq1sggt/dpyfLr/0nLd3r8EoRyZdceYq7WKaplDO40/W9z2UEQrfVvsFXInDZtT16BpUlfLwiTre3m2aMD0rB0uA1EmWOKEl4JZir3NRwJZ+aSuZPqYQi+zuka7isxAVZXk34Bnori7p8TXV58Wkyfpf3+0WveZ4k25iEqO6xYqKp7g7ALB5Y/DbUSQDOcmKvkPmZ4KyMX0KI2k+MkxuSyhPELzMlQlUuoFvL9vMUhPYp+fL7pH0TMIQB04mxozY6P0dU6vhJmIPzk5Sk1NAdWOLq8auHwsWZ/BR5zdSfOwnsNF9xGvO3gcKwZMpoFYhtiHV3DN40/JT8imUR6LtWY48M0KdDwM5lC3YlRPB+H/owYs0+aEXSc8VgG3mxcGL+DfhnVmVd8kJOtHl8qgt15czWN4MUQngTYIO5zad//ixRAqSxvHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The page cache caps folio order at MAX_PAGECACHE_ORDER, which sits below
the PMD order where a PMD is 512M -- arm64 with 64K base pages.  A
PMD-sized page cache folio is then impossible, so MADV_COLLAPSE answers
-EINVAL and khugepaged passes over the range.  The shmem cases ask for one
anyway, so four of them fail and the run bails out in the middle.

The cap is one global, so it rules out every file mapping, not just shmem:
shmem_huge_global_enabled() drops the PMD order from what it allows, and
file_thp_enabled() refuses a regular file whose mapping cannot hold a PMD
folio.  Skip both mem types when the PMD order has no per-order
shmem_enabled control, which is the readable form of the cap: that control
is created for the orders in THP_ORDERS_ALL_FILE_DEFAULT.  A run left with
nothing to collapse into skips outright.

Anonymous collapse is unaffected: its orders are not capped this way.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 31 +++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 0f828bfee31f..9b1da0dd0f8e 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1424,6 +1424,37 @@ int main(int argc, char **argv)
 
 	setbuf(stdout, NULL);
 
+	/*
+	 * The page cache caps folio order at MAX_PAGECACHE_ORDER, which
+	 * xas_split_alloc() puts below the PMD order on arm64 with 64K pages.
+	 * A PMD-sized page cache folio is then impossible, so the kernel
+	 * refuses these collapses by design and there is nothing to test.
+	 *
+	 * The cap is one global, so it rules out every file mapping, not just
+	 * shmem: shmem_huge_global_enabled() drops the PMD order from what it
+	 * allows, and file_thp_enabled() refuses a regular file whose mapping
+	 * cannot hold a PMD folio.
+	 *
+	 * The per-order shmem_enabled control below is what makes the cap
+	 * readable: it is created for the orders in THP_ORDERS_ALL_FILE_DEFAULT,
+	 * which is the cap and nothing else, so whether the PMD order has one
+	 * answers for a regular file as much as for shmem.
+	 */
+	if (!(thp_shmem_supported_orders() & (1UL << hpage_pmd_order))) {
+		if (shmem_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
+			shmem_ops = NULL;
+		}
+		if (read_only_file_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping file\n");
+			read_only_file_ops = NULL;
+			read_write_file_read_ops = NULL;
+			read_write_file_write_ops = NULL;
+		}
+		if (!anon_ops && !shmem_ops && !read_only_file_ops)
+			ksft_exit_skip("Nothing left to collapse into\n");
+	}
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
-- 
2.54.0


