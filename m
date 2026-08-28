Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DA5C61DCD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 08:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D7C6B0092; Fri, 28 Aug 2026 04:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866166B0095; Fri, 28 Aug 2026 04:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77AFB6B0096; Fri, 28 Aug 2026 04:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFF36B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:11:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAE57C028B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:11:48 +0000 (UTC)
X-FDA: 85149959496.23.989880C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id DD7F220004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:11:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="uzaOz1/o";
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787904707;
	b=ECXQrmbgB01/WuwxWaAne4mijWEWvxtpOd5Ij39w8++kui7zu6GF8JL7xRRteWOxd23Zju
	dt4kHQdToLRfvUrH5CGeIhXdEAxcnGUP2/J2pCNQPd3ViR3dUgUhzB4s980AZq45wckPxD
	goM51tQA4xkLhkLFvXt9Xgo1SFDAUEo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="uzaOz1/o";
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787904707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBbpZ4oLp0PjN5m3rXnDLE27ICVXyB5bUMovxnmt0SM=;
	b=Te8GU1fMnlTka0F+Vj7my62lEFTpwQPsGXDI8Qgo3joo34BwyElfjEJ1FdILywK64sOOAa
	SQkHwRfHfmYdKJyaIZFL3BVALCJ5m36cw9DUW0218ZXPDRdnBRyXvksjamUKIVQxoYAmQH
	LWIxVEm/jQrTCkzoUCgP1GKE3bA5z1o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A3D31688;
	Fri, 28 Aug 2026 01:11:42 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 794223F85F;
	Fri, 28 Aug 2026 01:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787904705; bh=0I8+Oez4/Fvep0PwEfY0VNcmLGz/KZXfSGanwudrUEc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uzaOz1/oJlW6bR6EV5BEwzUO3ZWDtOkiX8kQqTvtQIU+8Gstt90P/EfK0V5xpWkNj
	 68OSVH/YFW5zcfNWR7SNP8y2tmqKwNcLcLslb9UHvON4/PDR4Qmh3g6BKvZDU9lIay
	 TSFu6UJYE3d/Bf8dt+2bNttsDZ8Ly2mXLvKiGusM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Fri, 28 Aug 2026 09:11:33 +0100
Subject: [PATCH v3 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260828-fix_split-v3-1-374022586a4b@arm.com>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
In-Reply-To: <20260828-fix_split-v3-0-374022586a4b@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2554; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=0I8+Oez4/Fvep0PwEfY0VNcmLGz/KZXfSGanwudrUEc=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqkUK7V9mWLeZ9zL0R9lDWbj29vfP3HZbcACkU8
 XLC7wYRzBeJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapFCuwAKCRBt1cPRWsUx
 MzDVDACIL2ZyqeIY0AqiOfUb3ahEZz0Rfrp9OTdH2HaozEJu//mWMJfgISeHLcX1mIMhRKl1CGl
 YN1+8V4wMX3xvPj1HCQPgBmLNlyLnNm5+I8ELib45qcNWBhqxgzDiK9McBcHwkmhFZ6j+PqMvUY
 60h8P9i7i5Am6skrXngCeQN5hpLtBGyJwRoVy3RJ5eloa8epQpkhri6oqRNaPzXgWhzkTrrswHp
 PhBjE83yLQQXvHWXx78YOkBQAHHRNdp/PdQ7NPdX3e1kb5QlDWKXlB78I8pokt5viPN6R/iurR6
 U70GwNWPOz0yo0l+6xjpVCw5pS/xE6tsD2usTl3/WOPbdJssbinGjAT6AHq1Nv/dscvq+SHTJre
 CzFNwIc8ToSlZ1p8+lU3fOjsBUz2xRNKM4S2yIkLtNHJGhW7fYEMgnu9cPzX2u8IxR9kCVa9Xjb
 eHgKorOz6kpR+tC+1PpeU8FdefGOWSzKZlIyJMTw5FgBrZUKP8r4bqrvxl+KZ6GUtucnc=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DD7F220004
X-Stat-Signature: pmbyg3fdadg8ng9gsskobnm8f45zrgg4
X-Rspam-User: 
X-HE-Tag: 1787904706-491023
X-HE-Meta: U2FsdGVkX1+GwuusYtkDDWX30hnevS06j1uNlL6gyipaacNhw4P7meUqczqyR5ilP69+UpwSkPp8vfAA4aO7nAjPvNulmOV0cT1kBH4ifGvlxxejZGub9lOqT7yIxiIByGgfKNHDDUvFiSDqJjniARyyBHzysoIM0ULCqUHEQNDZMziSUaPwV0paDTnfSoRC2A93wF9uFamTHPSL6JEkAIU9CHfM3jpgtZi7dcurE/hpi1WsM+p51mBWlKYui6ND50EKYDqlYqFlfla8+gIsR3SBX0FFp93ksIs6DdqC9Bm2xUIe6q3o+4SCM+9ZGYZRVK5IuoOf94v3kPr6aXUUIXBVwhu+rcIIYS6vVqDSbOI/1fY4D7rCV3d2/OlfLFZI7IzF50yJlWRQLPswAhvwOk7/UQZW/GE+mXQzAQ6v/E6+B9rfGwPQWgKEn/OfBkCWbekuG0kke8CdT7bvnxA1NGmJOv4XqjwQQy45XYSKb1B2Z8oqSrRQOq5qq+Kq/vQAP3p0+51D8ZxDPsSL+DcnulD6Mbc1jQBSaZKYziQV8py4sq8ffdSLLYMPzSkvOA1P8eGyM9pKg9xOBtJDQWVdLltP6ut2xErXXzbw6gyB0/qyFPm70mDD98QNU2kLQBnYMBAWM5Wl33ZYyBCEs36mkq3NmTQe5k2mNnOR0Hghs8wfZQLIfR6SalSYLC5IkAE3oqa5WOKxlmkJjY8wfkLeOFmgYuSCBql99oE6eZAyjsEuNG3zQZ1tnej1xJQWlb6gLqDQIxfsCsZHMiMuRonS4szC/UCVfA8KpMg/0nObE1nx1t4YqHjwBTGy0200hRNNx0UBNjkb8ZnayE2BBG9L5+Yms1fv6uodIx4fod2obRw/N5ilL8AZWVduJVQUxrzuKLasRfZAbrzRGVzmWoNvLpB6Wy4SqoY/gi+Qvb6ShT37/aofRW+M0GGwruoQ0DvqLn6/Ka1KnD2d03sRTCv
 oQ4tRZX7
 Thyt3/bnDx1xLEKRvyOUkX65E8pOVYyog2MhKprdT+sn07CQKoI3UngABTDy0vEwEc84sq7GmYrGp+TtS9/ygd6Qe7SsTTwIjafNe4IonjiJ4QeUe0UV6RevdteT/HcRvDXz1fuaBQIchyEfSnsLy4Jtcj/3s6+mXRiitPqPZ+doZPo9Yhv3eexGWsQ8ryUG+n23HA9HBbvq9dExdGb/8pY//CdHU6ljP/xyup3ij5eeOSSBnviHnYpTzT6tO4T2gRlzXE+6Ys62Rszvsq1WiLgf0Lg==
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

Reported-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 86a603692826..c718269a291f 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -180,6 +180,10 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	/* Prevent khugepaged from collapsing the pages. */
+	if (madvise(one_page, len, MADV_NOHUGEPAGE))
+		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -227,6 +231,10 @@ static void split_pmd_thp_to_order(int order)
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	/* Prevent khugepaged from collapsing the pages. */
+	if (madvise(one_page, len, MADV_NOHUGEPAGE))
+		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -313,6 +321,10 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	/* Prevent khugepaged from collapsing the pages. */
+	if (madvise(thp_area, thp_area_size, MADV_NOHUGEPAGE))
+		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
+
 	/* Split all THPs through the remapped pages. */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
 		      (uint64_t)page_area + page_area_size, 0);
@@ -542,6 +554,9 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	/* Prevent khugepaged from collapsing the pages. */
+	if (madvise(*addr, fd_size, MADV_NOHUGEPAGE))
+		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
 	return 0;
 err_out_close:
 	close(*fd);

-- 
2.43.0


