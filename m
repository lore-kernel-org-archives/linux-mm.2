Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07615CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE846B0118; Mon, 11 May 2026 12:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387F46B011A; Mon, 11 May 2026 12:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276CE6B011B; Mon, 11 May 2026 12:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 138496B0118
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:32:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2B4F8B4F0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:47 +0000 (UTC)
X-FDA: 84755682774.12.1D6948F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 26EFD140019
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZk3EYHQ;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qr95VMXaQPWjVkmx8CuXGSZk0rBXl9DC2EPB0Iuh7os=;
	b=cKWtx4wUkAoFo9PWFb3m3v+iP91EX2prxiy3D+nxTF9zRQb+EvScPHB2BTcYG/3zbj6D2z
	LPl8530Yer/QAqxHQ6vQYXrKfEZ8w+TQ53/DkIkdYKf+vn7TjLVBV7+Cpq9DOQyA8J/wO2
	CvAT/L6dy+1ypqKiVje15h3+pXX5FRI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517166; a=rsa-sha256;
	cv=none;
	b=3cT1T4xzgoTpJYZuhlSQ1SvfGwhI3QFFYDtSxMYQnktm2axvzVx3oSKUnxK7jQpv9wWmxq
	EPkIrL+Su0TCGrjmLhgzQbmSIwcWoHq1JW9FzS1jn0sy1zSRLmpOgOQxeUHtly0/kGn4om
	ridSmP8Tq9qZK7e0Qp7f+6R0fk2IbkM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZk3EYHQ;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C84B43276;
	Mon, 11 May 2026 16:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E79C2BCB0;
	Mon, 11 May 2026 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517165;
	bh=eSj2HOcZZJ1TzufbeDLXNKJ8+QbsvqHrjQXzH6J2+Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZk3EYHQKxuhBmae3L6zj41HXD+DPELkgRKG4Nglv86qgcPIp/h5KlPdLx2SM8FtY
	 bRotDz35AFxrmf718x2JNRbz6hOM5hyO//ramYxwK6XjtRCEVs4l5oav35mctMzyXv
	 V1hjoPEQwyiTsEnEtMjkwWM+dAnnhnmhIZXHTwd7yIG1jykcT29zmG8e0A8qj3PFQT
	 vwrAT831+W4CgfI5/PJXaZAR+Qsa9tqPChZKi8Evb7CAYbD/pgXN8myfCQFSYsTHcQ
	 GtHWW4aKU+NQRLeInRY0c9L3794K/v3HObeE/EoddzBXhzRkKB5+sj+/v43S40qJNx
	 NVpxLVu8h7Wng==
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
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v4 36/55] selftests/mm: hugepage_dio: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:20 +0300
Message-ID: <20260511162840.375890-37-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 26EFD140019
X-Stat-Signature: iwxhw7hota1ji6xe573aghtuc49pbgur
X-Rspam-User: 
X-HE-Tag: 1778517165-423550
X-HE-Meta: U2FsdGVkX18W3hsgP+5GTs0sA1RzAuayI9TM1zL9Wwo/BoDOhb+ZmRtxBbznBFiqSanbupAaz1SKc6yOBgyxu1TWKcpsNJV1Lv1o7d9YUnsxg8brXib0wqzNvMR+n6SvcUSNqrlBofw8EDKdX92xzd76v+lV3mCJKfrdlRS8cmHQiiF0KMmfoNZFqkbkOfV49QrxJ4xhSlwn2CzjpKjaNqsvp1JmYmrN3C7CRRuoBipPeNpUgSdQHC6eO9W1OxHe3t7046rfHnfcCIwV4Z8bRcU3wcd0ovL1e/ZGlkQIjgn0uQ5LuVwlCW2yrDML6dh59DN6EQSKL+vBPX7JzboxcbN5MxIPoGNyXlVNJQCV1DBO9wBTNX1pfPSj72gRJsIZ6MgSkvwpXYduRl/7oEWLTQO2+eDDkU+Zo/w3BwGM522shEDrojWuigoGUOCprd9Pz684RIDOrulpJs4NNGPsNK4XegzfXLwD+/YLgM0lce/Ei1839DSRDGL0ZZBxwgzTkKlPyQ5UZgJfILb8XpGPMfBIdOyyjtiWjRM0eUdStpX0/y78xir8N8Oz8DalfxjbL3e/hdMvYoylnUSZ8zboEjYE20IpB2SrkfMaTDRcpEQfgw1I5wVfa1V7HoEuxKWNLri7KXzRZhdF/tJTJNqsr+6Qtt6hAgEZgU3UB1NQj+L8JwXWwNHWICivWP7GBSRdYImdxzpL1Z4aFUsklt8VKOpQxHemJ8rIqGrtiSi4g+PXh4mklEdKbpvPnHFl6jP5q8VCJUUtgLCPQ8cmnxj71d1nAPCpEXJpr4s/En+8bdQyzCFyEq2ZJ5t94tB6o7sY0lvIiio1du5Q3XNSIq/sAn+nhgfT5yVCytQUvaknkStb9ZNRdzN73FHE0yilWp+NVqwXWs5Ih5f+s5izvJQEczEhbgbZtEnoWOPz0tvpKd+z5prHNp+b/36oZ86PTgMbwnUDeg8+5uaZzYL8mU4
 lt5m2HDx
 KW0BFhh6j3l4Fvr+9pCQ6SumygrlhgqPmPLHzWB+IsbBFVqehRhgGceEMSJldAGzwmNeSyzwi3hnhGlY+G/JfGDZsG+THPgjhGcbSQ4nL1XGmvin80MuJ/5lvS9zsAsTLfFXv/b2SLhZ+zva/7BSt1kTZtn7Q3/asShuQekySyhG0scSGbWBD5lipJEaMOc6fTL5h/2HmEdvxxAVpmG2D9j/i24BFeqZqbdfqzcZNzZWqki3Uu4CEND+YFbyAyGl+BYzdJGpJX/NZWjWOu7WKmKp92pvVnEhLAKa69+FpZYOKr8nvvOkvtp7POX5VN7GJ8TN3VfTZB87xZ62u1M/2/AyjFjvFXoYMRJISASrLPeT5Uto=
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
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


