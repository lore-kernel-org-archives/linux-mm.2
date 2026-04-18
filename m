Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFC2F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E81D6B0278; Sat, 18 Apr 2026 06:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5994B6B027A; Sat, 18 Apr 2026 06:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE876B027B; Sat, 18 Apr 2026 06:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 374786B0278
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3DA858EFD
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:19 +0000 (UTC)
X-FDA: 84671380080.24.77BD8BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 67B161C0006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CBVQPD3N;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tW63MfJ4Ood0qwn/Lol3yNzgWQPHJJneODL7qiJ8/jE=;
	b=QGH84f295UvGOCvbCuTleYIcx824C26PCkkzrtHF0OsJlgmJCfAZ9FYE6EmFlvef2gE+B5
	VUY4h8labOkFZdgtEpdldbWZsD22Z+ujsOq0ncVEanlBqmL7idz8M5VJRKMajY2y/EMQuo
	v/j12E51MvFgh/AuC39eLEDdBhazRbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509958; a=rsa-sha256;
	cv=none;
	b=U7ByiVrXb/VvR5bE6zXB1Vt5ntKau+Ddxn+t9nkNkvK0Snvt1V7HSMm3m8NhsiUnQ7MBF7
	6E37WS0jzbeBF/2aiTwHBrcS3GYAz6L9HavwGQobon8yqqjF4+2oXNRk41e8a4Nljijx2l
	lBmJhZh+CUNK6kN6eaZzdRhO1rm7emQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CBVQPD3N;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0141260138;
	Sat, 18 Apr 2026 10:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10030C19424;
	Sat, 18 Apr 2026 10:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509957;
	bh=dW6FhGF6pU1ym+r/rDESusHBHIrjPAzWgWJPywW+wGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBVQPD3NJnmDJfdCka195nD7FyTgeRzFlFMF2Ngl79g/pBKKalas67xEabr2RsQTb
	 laR6EuV2F4gvUMqiRlbRYhMKSeG8HzpJgYk+Pxzadc6/T+wZk9fbW968UuzStIZxq+
	 UWDVWYEaFTgYnK7lopXHZMObSP5hSWFOogdqOswqMMCk3ZhvPyhb+67KZrKZTtLuax
	 44NBGzs6yRBNtC9zrZVJuCYgapQ0hUDvjhtQUD3+SMHXdIsArS7OQBM2CSZmTHCB8t
	 TyR9fTOP9fS4N9wI/AuSwByGzho5ydfFQ3hU1FwElVtCzlFWFbdHAv6NdTDVTltenr
	 xqsWvQLmRUYTg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
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
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 34/53] selftests/mm: hugepage_dio: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:19 +0300
Message-ID: <20260418105539.1261536-35-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ibn7t4c35dnap79841ytemfb8c9hjxwc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67B161C0006
X-Rspam-User: 
X-HE-Tag: 1776509958-537471
X-HE-Meta: U2FsdGVkX1+RVbv0jEhH8ztrL8bHCX787vde2/K6hZkoA9cNLkKes24Amu+lgsd/cEfrslpPIco+6VNS+4RXAOVDQe1hPh9q6jaQjkwvn7guhkPN4+vKtcX8UWWtDooXeka0S82MAPxyHL8PFfzt7jEdVs/HZzmUkSVzYj6u5IOWmunlHm5a3E3svgXivuWUj7jhTDGWed95vYMvgqLFlXky7aJE9VSDLwDkk5nMOFJFZAs4h0WSV2rfxod3yiHP0C63b3E93I3tAsw0qzH3aWL7avDz1OrYM54lMVhy2k9GNRublYs744x7J22pAPPDBqFL82eRwDKEPMLnsKHnlD0G7td+kWzBXt32HbxqpOG8nhYHsuRUPhZ6ju9CS7Ts3efx9rj2xaR43LIjHU5b7Pr0rA3OIqVaW93JAcVsC0nQGY2INEBnkW5PtIrrq0zM3oCQPDNpVe2guyldqRMBnkit/UGFZhkj0F+3KxnTT0buhtLPeqoJJR2nu3neUkubdz9/g3GbzhJLrFK+ud2T3RRIOgbTpKm+7bAIX8HNqWkzeCaBUUATeEagBJTexNk7pszNfPHcFYbFuyo/VHn5Ppb9GBCIjGJwkDFwPcwaf/dFpGWB57JCJehTZbT9m+9XtshKpR0XDEpYZMcLGP9yH1p44ixoZY2h0exHqkCpt5+m1ktiXZZ21n8x+lWPFBNkRBvqGtFyEbXD/eooE41KIALOOmfew7kkx6j68QZrF4ntH24++k/Hu84Z20PvCBG3MLH8ra21rivPAAegOfMEo+GrSGUPH5QdBP/WRmT4rS4PY4tP08StHvt1+CXBSt9vXvRLI7TpvaOzPGcY3H2zGV0O7hsKagwer7rgJI+3Ya7POi9VNJ+UgAEDIsgJ02ivHsr4cxrx7KYQ5oOZ1B/LZqgY949652H+tRAYxXygIZKiaXEj8Up5u+QksV0VDgWzdHL8rfVd5JWgWzZ3yq+
 Rzi9Mpj+
 WZjxzEmeXi8Al+j1DsQ4TcHIIkLPDZX3myxyv4RJu8PW8+g/6Wtth0lfR5jf6oG76IWxRF62GUSveZPdqla64OLH2vrV9xS6Py9QQUyZAW5uCil/Da0fyjmHO26FpHWQ9uFgPnCBbQ+ggOCzlXjPzwjKYbKVJO9RPAAUU+llGI+uh34BPo0gfZD/bbK1//mNgTAXHL5l/EGvYARu231MYKjK8qPG0Qb4BqNfgCEEuNTraRFTNloHtDoWHB0kOwJOXtwhIsx38CZu5RmtcPeHz3G0LrC+f79GEeyhR
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


