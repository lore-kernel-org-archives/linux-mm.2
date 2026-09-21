Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD8AC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E800D6B00E5; Mon, 21 Sep 2026 06:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30486B00E6; Mon, 21 Sep 2026 06:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EE86B00EE; Mon, 21 Sep 2026 06:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FFAC6B00E5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:40:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 155AB40126
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:40:20 +0000 (UTC)
X-FDA: 85237425000.28.16ACE35
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3C6EFC000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:40:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QSuAO5qf;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789987218;
	b=Q0nnLMSvU9RNYOHqGCPtt6lPMeAPzObNGmHh5hKDe7VceQNGzmh/+t/ItzkA45zWP2olFz
	sbRWg1eGgWdqLlopSDd9bEk16wTmdHZphaqTXTmzrAy63t3d2ALMkcit3w4ZXVHOwQefZN
	aA2yqCJsG/um6K3eMpIQotSw+KVIv20=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QSuAO5qf;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789987218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnRbW/70F648aMkTD4Uy8yihxzh9WUA3o4X2vlsxGDI=;
	b=UjYJCrMGr0PHZB0q5amKHeGknj/YMSSv7h/TTqWJrfD5O8mJRm5e8anRjdxv0qjQJNHxEG
	RUuiDhp0Jo6436vs9ow1HtF1dFnyEg1DZBm7dgMX+iDzqLeTX1DmGGvZqx+g54PcYz7V/j
	9BjqI02QFCfu8nEVFkhmcXkG/sW3/5I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9C531CE0;
	Mon, 21 Sep 2026 03:40:13 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 603FB3F86C;
	Mon, 21 Sep 2026 03:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789987217; bh=nAZ5Nu8/Na8ryFI4SAROqdpt5betZtOhodIgZ1vFN/Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QSuAO5qfdzbTBibtYalj0EBb9NUMvqfJDkEzxiDY4t6TCHh5A8OVXvvXEkZOXyuPN
	 9w/gciK3NISvJLcCd7tpD1zOypNB0ER7HlT6QXFWHKFTpl00TijpVcWh1gcEh3hUVI
	 wbh7e19sl5OpXZCLVbJSbN2aATyAwAjJIHCEglEQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:40:07 +0100
Subject: [PATCH v7 1/3] kselftest: mm: prevent random failure of huge page
 split for khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-fix_split-v7-1-d25ec991159f@arm.com>
References: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
In-Reply-To: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2772; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=nAZ5Nu8/Na8ryFI4SAROqdpt5betZtOhodIgZ1vFN/Q=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQmJS49uY0WTGO7xDTb8XJ1buCo74SJ77Ym0b
 1aLUL4K+WiJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEJiQAKCRBt1cPRWsUx
 M35vDACoT1PIgox1YUsx6mvHqeplFUSysSKEFx5zDxzyaHYhM7XddIhMZuQbuRPtxopLYkvGoXH
 95U134cSKw9csvK5zS9PkJwkCcBRVzGElv0U5EkqPRtZtSRBjofPqir5KsLhAbsnaV46XfkRcGx
 B4xn3KQ6R0cB4Yl5hg9YygocTcfDVrRRw3wTgh2TXTKfSW4DrV9mFBH79WTXHEA0ed7GPd6MdPa
 hzVCq1NKEk1V6tnk8/2d5eSzTtPNpOw7jDX+CzLSNHZieAm+ofDMKVOIHhna6qEzoR4xo0/40qh
 wdyL+afQBouI4BC/Nli8X7BSN9xqlpFv5+D2Gk6muNYYGceRMYgeOO+6o4Jgj+NV+xJoNO1o10q
 /ewTkqDsTHxxeElOg+EcOTOay1fUmd65mYl+ydB3oxDHonMZCyTdO2F0sd6leullFPRteOIPS7k
 6xZqRkiQK1IiUFE+DgrXm4s02W0VNYd6bYXoFvscCkU4R2Iy6EtIqd2gO/VFrWtAgy5os=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3C6EFC000B
X-Stat-Signature: mam7uho9bmtgsoq96735qm9jm1n1syua
X-HE-Tag: 1789987218-662810
X-HE-Meta: U2FsdGVkX19gux2a69w6Sf/BZBHbON8VsZxfyUik1y0ik24BEHfq/jGChxHjjQlxFUx6qpOfKJsYCW3kx/Ew5GN6aeTG/ijwAqBxxRkOkF9ybtawPfUWmkOHw2dtotZTOGL677RUZfN4npE2Xo/6y3gaHbHA8vpTdXY0PI5YSsSPDePjnx+1Oj0S3exHTQn4zpYY2pRGVZ6ueGYTZIolEry0ikh/Y/gxyCJdSMhOm/IBBS4i9ea8zHJQb5m4QjUCokRSlVIBaYQIDxAdu62AcmsaNvjkoTDgIBQeYGl/BJnk1ir3+G/tGIaB7jPWBPvwQel3PNUDwFKhtPxLGsvLlzKrLM/np78YwsJnTLRTucsZOb3hFVoGZp07uHjQY2dCxa2nXlcpzg/sVIiST1VMl9yOktLb6+frVgqlZMC/waTwW8S40vjx+NkW3zikXZYd3+N6zNp3UrVGXmQP7+0Aga2vqL1U/SrxGKFy5HpMFE6U5Rb/JNGK3C5xxMqNwR4ZE36ue1MIz8WgZp/+KexCzm2LBbb3y/RCB1W4Hicb+OPDBQ24DoO5VveLslVgcp5hD0ftIecSGX2rgD1MhtkQoeYr4JjBf2cBcK1pXueIMbrMDDt+hJ7rfC3iQDXh17vfPAR7qc7g4BMTKkV+w9CVYFkTIdnhXqaPeZFH8W3BMZK+o8BXlqsV4/CrDIt2FDuib9hmGEi8+BGWVVY0HiRFu+1S5qcJX5gN0Qad4bDoxORlmMbrV3i8kEDsQRasvQPNtuaE6qbs+Q7NPiYIj7/Y7+cgI5YeQ1SVzWxSOYRBENhr21kLJcYbjQwL+ItIYXDJX0h0OrSNul04vRSEruJEyjwyJiB3Tfm0ckFlA3jguK1bN+qJLLS0jyw7uw/Foo8AZxw0JbLUP9Iudfx3Y5qg5/jRLNmZSN6N4oAo9YlMZDBE7wiCEJVCX732OXjILz3XeKYRsbISTWQkYdmTbMe
 nMfzUVKC
 tw02fdG4z2GKBBiQ2OqJVo32TilmRb8Op7+kPSCuzeFFm1st9Yfr81d+5BpCgfNGYgckjnKrFuAV61we3THT0vJZoiRmTMvlsG4UbIRfH3TVJMX+TXaIIMndQQbufT/YBEg5QNr7FPNrtR5eqTUleg98VT7KaZUL9tuV4wsHWdC441QDmpeRGV5rbcAeSfJJc/wzTFczkcfioWY4HcMxpPVhyd64sZ6M62/vE1KBVkFtKjTMymJw4xtnY6R+x1Bb37woT8Xt7V0cI+9Mt8dP8rFHU+8Z/ZZwv2KrCbx1xXiQ6ZfvxhjVDhDeNKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There're some random failure for split_huge_page_test when khugepaged
collapses pages into pmd again which had split by the test.

Prevent the khugepaged's collapses for split page by setting the
mapped pmd-huge-page with MADV_NOHUGEPAGE before split.

Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index c01d227d7fd6d..cba327f778734 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -167,6 +167,18 @@ static char *allocate_zero_filled_hugepage(size_t len)
 	return result;
 }
 
+static void disable_khugepaged(void *addr, size_t len)
+{
+	/*
+	 * Disables khugepaged from collapsing THPs in range, existing THP
+	 * pages remain.
+	 */
+	if (!madvise(addr, len, MADV_NOHUGEPAGE))
+		return;
+
+	ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);
+}
+
 static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
@@ -179,6 +191,8 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -226,6 +240,8 @@ static void split_pmd_thp_to_order(int order)
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -274,6 +290,8 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	disable_khugepaged(thp_area, thp_area_size);
+
 	/*
 	 * To challenge spitting code, we will mremap a single page of each
 	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
@@ -541,6 +559,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	disable_khugepaged(*addr, fd_size);
 	return 0;
 err_out_close:
 	close(*fd);

-- 
2.43.0


