Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89CFCF99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F106E6B027C; Sat, 18 Apr 2026 06:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE84A6B027E; Sat, 18 Apr 2026 06:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE066B027F; Sat, 18 Apr 2026 06:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C93486B027C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BEDE1404DB
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:32 +0000 (UTC)
X-FDA: 84671380584.28.7407BE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF976180008
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R5BJ9msl;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509971; a=rsa-sha256;
	cv=none;
	b=DPtU/It2zNHtjK/2uLOxOsdMMmaWpz/Q9TOZJg1lxaJKy5t5gLxWj5UbRUfdmRzAskcMY8
	JtPqRD/D6cSoOcGLCfl6+OfYnWShjDWY6EQA/o8dT9UXzNawrQC5AU0uUHtv7Bwj3VH7hq
	obhRTce0E1/KxWwM3iavSlSOQ8TCqmA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R5BJ9msl;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXA6sPDV6T7/i7t4cfnDVP9gKpNUMqTULWLo+ZC9cdU=;
	b=Y43LzMN0Zghoxo65drNMuYbMBo6rpVN/IdNtzmjj+6zZGclUXhUkiykcoS9OZ0BIT6NjbN
	Qks95S2tOCToDjcMWIBRNTLba/MBU7AmD89094xPWo9j2k2nvUgZZpVak9vMtE+xBzTLpz
	y6qivOEcKmM0iUebnb3v//h6HOGmJv4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CB434194F;
	Sat, 18 Apr 2026 10:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5527EC19424;
	Sat, 18 Apr 2026 10:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509970;
	bh=1E1PaJAheFq68IlA7LKJisHu/YP5aoXijmYjIj2LOcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5BJ9mslNIuk/rQ8w8TVMGSGl81yQn4ewVmXUObVsJbqOt8XM5keJgOYEHrHoGslk
	 K1MzO1HAp+qmj6fR2Bkbly0NUW2cLba/0YYw28pnpAgbtei4OfD1+I9hxuRX5FYH5q
	 938IgERuWpQz6+mBbT9ZcA6/BeJM3vws08TRSfZd0GclXUKsgCGWQchBYZjkZaa80e
	 4nXhHzzXpdQ06MXAqCiwilWujY9A322auFRdoakjn7uGTJhYvxBhgv2QIlv1Fpuii1
	 g78xSm3lAgRrHL0/3MJgHa1TmG573fCQ/ZzV/YE/+j/jqJimqj4eNZmXbdhBQ5LzuG
	 ggYScjwlwG/Nw==
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
Subject: [PATCH v2 36/53] selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:21 +0300
Message-ID: <20260418105539.1261536-37-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF976180008
X-Stat-Signature: 19pqqmefzj9juhx4mwy8hq75o9ffrkyu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776509970-249526
X-HE-Meta: U2FsdGVkX1/JHKNVObPOPD2c1LUBr6CZrJ7BXCaKRa0EBMeOTL+RPEeYZQ+5DZGan86W5OQoFvy0kPzzfnoVuUrBk7+wnuxPAlS4LculdJ6XxtyZeZbGv1PgcoiXcl9BlP2ZJdgjFf2oL5c4tt+/yPJvdx552I1jrVtVZC41dcjMdj5mwn9nmAvI9IG/tStODoYdAWvjyBsVceTKQUrCyhacMfD8IwRLwhesDnnpugxJPm/Rlg1dyk8LjV3ViaKPKJRjQVP1BAk87dgRIkrjBHMz5p7abFW+sDvj64RYnkC+ZQXfgsyoAkq49uJT8b4lssldOnaz8yfC+HZ8zkdG5WSjIOHY79WKUxGU4csuEI2bUGWPHlQa80TfS0XI3iyV7oEgbn1n6LXNPAJPuy+lJ98VJlGtcCk9//cFuT0tZFVPbZKkLRPcGV4yTlnrxCMQbgs65T01iXhMPvAHiG53BPsFlAbuKA5rx08x+VzqSNY6srnZtBq/XtwfgRhcw1T6dlXgfxWSOleaYFMga+N40m0SBe+D6oiWcOxy+jsHvvdteNosXwBAeekwQggxz8XzITBpTfdBaXljuo5rDAR8a8mLu0OPM3gELfvF3UGUCk513Z7zyFoCCpphM8AEUotQMxxWZCgZvlPtsEBb6u9xP5ZCykdxzRas7qwz4iAWYBtfemc0tjMyq9fiAG1gUwXIlfMgTi0/eVkY53u2/FbIp3eckZdl5yDHjktxvCB/i5/Hqy/vVhv70AjIY7mr7rlabB5y6WrQWNCJ8TJp8AHrxGKpMciClyQ2FDjplODOSo+W26yLiwLVyAKxxsMpNk5f/nT8Gdo1hHXU6yRIXWSKDuRhjVTsjdkeKQm+z70hor35RLlSNOBzkik/FlJwNCjTXRa0JIF7+8bMsRx1h8pV2xV5PMcqf/L0boxhNZgfyAkeUfw5sdAf190hGBUkL1C0JmGjt0txOGchwURr6Sm
 vIPKHQ9v
 zl3/bQX3EJzvyoYKhhwvFbO4bxuL/uIh6gs0sBwq5HkPf89DowBZpSzi/XSQXDg4Eg8QGeV/cIwExfglOzzTKuX4T1uSzjKnB5t+0G5/QSHs728wq5owkWWXEnu3PQz66Tg4oA0cWWSHBZU5Y/VaeGywvlM5T3Z6Q7FvjJriBc6GDxN+oA/G3kFHUdubW6qbmrX/5MzT3P445tnEj2MBCZK7ibQeeOf3jY77pAN/C5vVlISA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-madvise test skips testing if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-madvise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 3c08eb6db6a2..b20648d025e6 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -68,9 +68,9 @@ int main(int argc, char **argv)
 	if (!base_page_size)
 		ksft_exit_fail_msg("Unable to determine base page size\n");
 
+	if (!hugetlb_setup_default(MIN_FREE_PAGES))
+		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", hugetlb_free_default_pages(), MIN_FREE_PAGES);
 	free_hugepages = hugetlb_free_default_pages();
-	if (free_hugepages < MIN_FREE_PAGES)
-		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
 
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
-- 
2.53.0


