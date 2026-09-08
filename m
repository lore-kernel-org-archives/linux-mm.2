Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A22CCC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD656B0096; Tue,  8 Sep 2026 09:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D256B0098; Tue,  8 Sep 2026 09:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58EDA6B0099; Tue,  8 Sep 2026 09:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34CB96B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:44:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D7F7A0700
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:44:18 +0000 (UTC)
X-FDA: 85190714196.12.01BBA10
Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	by imf24.hostedemail.com (Postfix) with ESMTP id 61C24180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:44:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fad6sxFg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wMvop6GAyoj7B3iuev1XT1EVHGgx5TnkYcJ+QBXhyE=;
	b=OCr5b2NqmAdCG+9BwuoRYBe9DCT+XAgyxcszdZKaWRl0zsnz9HjSWx8c4ajARuP1Xc3wGJ
	yWqXXea/E8DE+8CDvdjbyjxyzsLcreO+/rLiSSPV18S+ixB2YCEwtcr2yjQuf9zxG/sGIQ
	R10QEzHeV+rE29B9FEjwdbXeetjW+5E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875056;
	b=lmMByHs8T7keWSNF5E9xZ8sC7iTvYzZLvzTVYJiMDYiOMunkoMpD+JGw+SrOGqW6vVrRo6
	mityN12gZNoflxk/QtMqjJRoAq8hoz7lnSgLLgv1opAgNOqm6jLlxEjN7o62UaQg+E2yoG
	b3JpyxmPE0HotMEj7CUFLvE0eYICqrg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fad6sxFg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=65dsR/AIsa1KwD07S3iIYP5bJ3Epc26abAu9BtMFUS4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788875055; v=1; x=1789479855;
 b=Fad6sxFgcBzdmpNy3jWqhhFI1K0cG5IVG9G/qh60aeLcUnSIkZ3a3arHJ8sUWD1VeQD1Bu+4
 j6mBw9BkctCkJudw7VzZgEQR8RvhCinzs3ntrpf084Fdc8S+lE0MCabmKv9iVeDGPojdlI/ugRT
 xSz9X6BFTKQVx8oH2WfkiNsI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ce353f69015ecc17;
	Tue, 08 Sep 2026 13:44:14 +0000
X-Mizu-Trace-ID: ce353f69015ecc17
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH v2 3/3] selftests/mm: init page sizes early in pagemap_ioctl test
Date: Tue,  8 Sep 2026 21:44:05 +0800
Message-ID: <20260908134405.84448-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908134117.84405-1-zenghui.yu@linux.dev>
References: <20260908134117.84405-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 61C24180002
X-Stat-Signature: kymtis3yo186sfsgmxepucz5os56qgg1
X-HE-Tag: 1788875056-516753
X-HE-Meta: U2FsdGVkX1+Ea4qqMS4HPRUmt8MWV2uUzLe6n+jixI6PeAkjvnpsEuDhsaSiFeLH4uxU0LaV0Hc2dZUU4zWn8tnypqa298vH55ijYwvntsfAqL/pqiih/e+7QKj0CEGeu5QJ+GhOR5H9Fdjkpr9oqcoZ9Vm/vj/cIQz/F4ciGXh+5R7+hTEghDCGaHsp+cIBWZTzspoopRUDJxQ29zq17fy8UAJtveefvVN18byDLlpF6nFUpdtg5lDgQZuKReLlCkbuqFvyaDbl+Xkxpab+egu/wkS4yPOVV+4ZrTQmHUsyxBAMSZ/RxEFNxq10It0kTIaQJocvSU+ZKnZJZgwg++0DozqvsIialaXe96CmjpwkUNV3TJOB6vFmIgYK8npV5HFl3WDsPj+Wc2IU/S5QmKws3tqYxbx/QglrgA82V/fAZrFz61ioA06RVKJu8ND6g652A8GJys2C51hdmmjAf+8U3Kr5+KdLw6uLXj0q1oFpXS2RtKkuz4gDGB2PHlhox8+AYMgMWvbfqXOTS/aoA+vNt7o4XoZupv0lJwMb85BNvvWfHkNuGQ2touueEqEpdE/tOA8JVDMoRKCAy+AvtkOp4nmAy+SUUbhKXuQj1KrpaP8UraIffAvpbB6oQJET159D5nFITuPYpfQT3Bph4LRPjUzrd54ecP7V6q/LVOVna14QASsO/CgOXceBKFQ9UbgHElaw1U/i4BJRorxU+jTgbUILtCZy++z82dXEQDcYDaces5J2d6dCv+V5UIC884AuSuZbaFWRhpit0R5ySeRdZjFqyJuGH+wo9NOnEanh/rfFlp6hbHzzKW/FEN/1414cicCLYzl44VjWtItkbyypcIYn2Pkh9HGTH08u6PhVl6MoAkEFFQ4xVVxhxZBFypW5rCkiXKw0RlXuyJoqK+mzQ/ZmIy08Yk+z546TzthKdA/PND6VvItR7tSQoo0psgHv0M3pmxHsAcuJemP
 fZ+DK5tE
 6uMgcmWiT21pq012P2oIASnKopWhKm7+uFBu2dOvSf7Lf2ryJCtzwbucySVbcaqg489JujDFHGpVYzx/pj9xmmdEUWFcwCyhvCM6WEqGGS3Jxh3/p8b66SV1YCjK+L3eeuNYHWoXRDjDQArSrx7RhNDNwcSe/jYlP95Se0qYvicya/rHSPyJad8+nZsoBWWN03lKpk8MgNOvmferu9ibgvxNytQn+es02KEkY8/Hf0C0WFFQUtPICNY9ey1Ri14p0bLpzPVErqCCvhcgopWwJf2wf+TeKcxS8ri9ygHw70gZW8IzWq0hhNeZBqAPFN4yG74wz2m4G2UVRo7rTKgR3CzQIQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

Initialize page_size and hpage_size before calling init_uffd(),
hugetlb_setup_default(), etc.  That won't fix anything, but it is safer and
saner to get these globals set up before doing other things.

While at it, drop the page_size parameter of transact_test(), which is
actually unnecessary.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 1a87b7483316..d9a4fb782ecf 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1489,7 +1489,7 @@ static void *thread_proc(void *mem)
 	return NULL;
 }
 
-static void transact_test(int page_size)
+static void transact_test(void)
 {
 	unsigned int i, count, extra_pages;
 	unsigned int c;
@@ -1653,6 +1653,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	ksft_print_header();
 
+	page_size = getpagesize();
+	hpage_size = read_pmd_pagesize();
+
 	if (init_uffd())
 		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
@@ -1661,9 +1664,6 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	ksft_set_plan(119);
 
-	page_size = getpagesize();
-	hpage_size = read_pmd_pagesize();
-
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
@@ -1823,7 +1823,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	mprotect_tests();
 
 	/* 13. Transact test */
-	transact_test(page_size);
+	transact_test();
 
 	/* 14. Sanity testing */
 	sanity_tests();
-- 
2.53.0


