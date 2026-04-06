Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0EEAF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E146B00D2; Mon,  6 Apr 2026 10:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355A86B00D3; Mon,  6 Apr 2026 10:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292DF6B00D4; Mon,  6 Apr 2026 10:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D21A6B00D2
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E33A5E14FF
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:05 +0000 (UTC)
X-FDA: 84628342890.22.B707A88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3595340003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pdQtychc;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tW63MfJ4Ood0qwn/Lol3yNzgWQPHJJneODL7qiJ8/jE=;
	b=SnnT+371mtrYPM3A+udv/tzVv+dTCAleq9yL1Z35qnC0QpySZk9tznhzdMsw17fN0iKB29
	/zv5mOGbv8vd8cLBo8C+ivKURCt15Y1vne2gwP9H5jngPsOnhbQs5zjGxH41mTN+fR8XjE
	rrODkQXtuxVuz0IdSwDHXdrYzhpeDtY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pdQtychc;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485264; a=rsa-sha256;
	cv=none;
	b=dTCHlMMa67z5L1bXMJPTZiF0T17ETUoJa/zuRnexmifqo1XGC1Jp3gCOzqj5yYa9zaLUnG
	jz2JgfIbOG0QJ5zE47fQ5+mDKkDMUrKA17xAVVfcLeeVjSADRjuiTOFKiO4IqCKXMbrV+2
	gPFpy3TNd/d9whCrnLgn+4d+Jb6D4Gs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5923741970;
	Mon,  6 Apr 2026 14:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD53EC4CEF7;
	Mon,  6 Apr 2026 14:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485263;
	bh=dW6FhGF6pU1ym+r/rDESusHBHIrjPAzWgWJPywW+wGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdQtychcMReUIrt09oRyA0UJ8OmK/l26NtUky7BjAammmLCIwIgyeqs2T3kiqfLOB
	 TZ/5J9UlCUcOOOGCXKQ6RjNcZiBe3V/xWcy53pB8MX3kNuaASkFssiGh1jxkCGGZ4y
	 HfFLFrBfVuUcHv7/kCZw1WO7nuDrj1A5o4uOjZ3/11ySuYO1sLLXc9i14SUJuE3j9+
	 RBEnCU1r3TPgJSHrK+67xoLAGboRkfv++aI9CSIilLwcK2xjQFadHyI8pLLA6O4a0b
	 Ipx5uedNL2cAgPjpQ59NLEhWRVLKACF4qKgKAuo0FXhwgROiGEydYZBhQ6jGdC/Or7
	 ZNYzfa4r8S4Pw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 34/53] selftests/mm: hugepage_dio: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:16 +0300
Message-ID: <20260406141735.2179309-35-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3595340003
X-Stat-Signature: c84fbksnis65g6tepmr44q88yrrrfn4j
X-Rspam-User: 
X-HE-Tag: 1775485263-691877
X-HE-Meta: U2FsdGVkX19y3pE6ufrqEextVZerlHbOq1LP2toG3YFX0mlB7iJtMNWIqy01CQJMVL9Z0sKTapw6vy8My8K04fKRJ3TCPvVljoEhIZCCRKmD7niOtwYbRX5uAUVanibaSY3fQC6Tvl8hw9NzYA1Q9IULmovfQKEkqJJW/1v0Gc7jVIWRtx41zvAQH7YjR+JP0vE1U2FeJzDqo1N1dFYTUpwqgMUOArdt8rcKfghfRVHh+9imu0/hyR8+JiVyUoMfsYsxHRkDZ4klJYIy7PqiDmtSsp0C5ZKxCS5/QF/gBL4fGWn9A4pt8AMJYqYk044RC/fhgJghNrH9wjMMzDGc5gJXOgHAOZxcjBKDnAzLQlcInVbTSIoEs3RTOTxq64IDcBgZ52afBPaEokA3PefprKVoDo0nPbOVxC6j3iTbzqy6GYxQTWd675cj0lA5/zdAfQB0rm0X3xl9r2GJCnx2ChGG0Y6SIl9TouhIRjLgpPCTtmmRTemu9bjLlYFQJ76DriAxjME+slWUisZ+FRbHF7ALbLxdS84jByl4CbQTww5cyaq3nxj9T8/2nnb7qEMPYqbmXioKpr5pp8oO1kMUasOX7PNse/I6eQiSu3a5lavz/AddeJaADsrR9B+EnvZhjv/dS2W90lj7ncxpsDojGeiGfs/ZQ7w8mnK4gTLblyTGRRyJsZA8An02M0NbvsnplrMN10T8P3o1YLe7mjZFiD0td7Nvm6V1qA8Ud5SQ8y8e466hXF27FDRM0b02P6ghRrbJkHwfNhi4FdW5sYe8s8kzzHWatt7rSmEGpuS/IORWScQGv9DansXcbR7hqADYrPQDQcMCJMlSDS5HflsShgOPi3P+hZbTVE+Yh+AS/vfEbZsaz4rsSAT8T8YqkzqCOyONATadAKBYvlkd9hj1g2Iiuf1JB5l6+bIydzett/1gLLVMgo1EsgCa98DnheyaMk5BTQRFqjwskeZWSIj
 kczTJJwe
 ZHRsgV2zwt3BZ+vj5cugzMCR0oMCVvk6pTrUoeTYZ1KAPHVJPtrBKK83MeSJ92//uNNzNLB9yarqQ8cVZPxOdB/ABn42O9Uzusn/ath4P/ijONS0oW9I3F2DEnKWP0CJdH+g2OwLa3MIlsu8osR2HuL0IN5NSu9QbsdTkgr1p9tL8GfrwLbNWXI10DCZVGIP7LsY5mGJn0hF1T3CAZnMVjrWe9sihuxc2s73e5j+Yx/vrYZNSTiMzdflK2l/xN+tFHnjwcOIBQypa2iTlqr4eKikgxcIeHf3D8FL7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugepage_dio test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb_dio.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 47019433ddaf..fb4600570e13 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -85,8 +85,6 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
 
 	/* Get the default huge page size */
 	h_pagesize = default_huge_page_size();
-	if (!h_pagesize)
-		ksft_exit_fail_msg("Unable to determine huge page size\n");
 
 	/* Reset file position since fd is shared across tests */
 	if (lseek(fd, 0, SEEK_SET) < 0)
@@ -94,10 +92,6 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
 
 	/* Get the free huge pages before allocation */
 	free_hpage_b = hugetlb_free_default_pages();
-	if (free_hpage_b == 0) {
-		close(fd);
-		ksft_exit_skip("No free hugepage, exiting!\n");
-	}
 
 	/* Allocate a hugetlb page */
 	orig_buffer = mmap(NULL, h_pagesize, mmap_prot, mmap_flags, -1, 0);
@@ -141,8 +135,8 @@ int main(void)
 
 	ksft_print_header();
 
-	/* Check if huge pages are free */
-	if (!hugetlb_free_default_pages())
+	/* request a huge page */
+	if (!hugetlb_setup_default(1))
 		ksft_exit_skip("No free hugepage, exiting\n");
 
 	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
-- 
2.53.0


