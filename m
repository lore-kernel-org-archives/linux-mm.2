Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F12C1C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72AF96B0096; Mon, 14 Sep 2026 03:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DCA26B0098; Mon, 14 Sep 2026 03:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2A76B0099; Mon, 14 Sep 2026 03:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35C446B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:30:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC9F6811A6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:30:23 +0000 (UTC)
X-FDA: 85211544726.09.13E16AB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD1E840006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:30:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cl9+8G5o;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789371021;
	b=sOPDjd3uKSDQ+XhEV1rtNXCqvYUPzXtIZTe7CBUGe+0siH3BY7wtHXQBoQMU7KKHnkc32b
	wgjRIOqAP366XmoFg3nJDNUVl2cumjkWSaV8Ei0rqQ3Wtrb+1u8y2Je/HtcDS5C8c5SMhv
	Tcc96oFBTcQ/DF2KX6PjOlL280n6StI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cl9+8G5o;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789371021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mx/tF55kn3cejyrWMwQCQ9wwtjs9SKgnBH+my/WYtVw=;
	b=5PjTQ2aEWjIkAnYqB3xG+Hjtz3eDpD3gO8VIbfjojhB8rtbUZWdR8erzNV75xFc2tAqL05
	Eq2RXU1w2NWNZVTQ6fDwFE6vaBIba8tF2qnoEH2ghoNiRvcZJTDDzLOvTeAJaJZXYpCqGa
	gF2Y1BRO2IAUpQ4u5CprGVt1pkxTCmw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 192AA1570;
	Mon, 14 Sep 2026 00:30:17 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5F053F59E;
	Mon, 14 Sep 2026 00:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789371020; bh=SlD7ZbVM7WnFOn0I9sN0RsC4FPCdY4XpHKn67Smm3qg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Cl9+8G5oMdP7lh+WHNE+fCbazaEny8SPmxKwgj1dFpDiT2ssk7ppCGxxjdzRMq06C
	 /zoIkoQFHy0NpNotetR3VDpQRW96FOjmkdKLOjMq5ZZeAPKux2A9UUbVvFiyURJEDi
	 rvJwvfnYCTpRqKKOdv+Ce6ZjXo7FLj8uEX4OKkFA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 14 Sep 2026 08:30:10 +0100
Subject: [PATCH v6 1/3] kselftest: mm: prevent random failure of huge page
 split for khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-fix_split-v6-1-16ed7123800b@arm.com>
References: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
In-Reply-To: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2770; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=SlD7ZbVM7WnFOn0I9sN0RsC4FPCdY4XpHKn67Smm3qg=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqp6KE5jWbWA6Vl/LXzSbh4vusoY1JIpxqui00b
 WCllym4YfWJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaqeihAAKCRBt1cPRWsUx
 MyaxC/4q7Yi8BdaNwgF0uMQXrfTyws7nuywQBhuRw2f17xDGs+9SWebUV/TRY5zorq5APlq2rDn
 vAUc+bmXYBEZwGbDMjf1ge7BNaUlLdNacCsSVHLerps2U/Xf/DhVnI1Vzd84p5FeskRGOK9qUED
 NBiob6Xsls1V5MgdJlmPP3Vsajbq1LuPWT5QqEAbjgVbxsm1IxlwVlIARb7qVV44vCAPWAKUiqQ
 eMRpCJlIor1Hqu3v0RlbmqDD+Iyt5jJyzEwBN72cP2ZZT0puysglKmmG3NpZFqOa2BV06M7Jy/g
 74W98j8VURt3oU/3voT6uRYQgdn49bok7Fe3SraE5W9QZDt9Dro+1hdTbRnYi86satdvGQf+pkA
 Q/jmXBA93OT83ye7CmKMfzkPv1DQRi5wDIP0apRp2OHqYOwvevdfA04ncD4OrpOYoR+uXXb4waA
 Nw/pwiqvqKAevRt8Fu6fYf0WuOabIzy+4wWqxYSOrvva3ehFb+CcX0lwQqEOcHFTP4Xvo=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD1E840006
X-Stat-Signature: ggei6aryxngs49mqq8sgg47kmpkeqf3a
X-HE-Tag: 1789371021-661689
X-HE-Meta: U2FsdGVkX18gjSfoyFlc2W9Y8JctEyMxMya3+Ix0JI45eUZh4kqOJ8A7tcRAmTdn0Ac5Tds0GoCjy72t+5P9sOBgGuJTrynPfKlRRgaC5DdFWAw7wmvkSbsnZziTbs0KNOk1zTohDb8voB7bFFwdgLWkCQR5uLWYH2emEY6uIN/fRE3bMhK3xPsT3kT3aBB9JWNZPm3VL4ncTlPU4bHMAAEF3rk53t+FjYGcEvSItsXBq69TjyYkrn42ou1XjTbCRyBXEMV2F+e7Tb3DLygztO++4jIMQdJCIUB0PZzhoFUPNa9e/Ey4rS1qQNxtf4Hz9B1Vg5c9jc39rNLW4MQRtLcO4POClOcI9MYgeEei0W5iMkE032ZGkxpsdP5qOAJewN3LH3e+VntIdpfayvTn+9ukvw+avlgyiQ+i+TLuSH0gWyhsmloV/80PQd218zaG2EEdc56n2CHVeGbvfQiXxV35Odm+FEUi7X7Ket5bTKPRmcJ0RVwj8V1So9+uevcd9RF1RorS87Fmiodjxxs/oI+TABZVjEbUuke2hmhKpKhONBu/pg7Ci01Qsr5+Qq4Lxmc63oMJwDVtCa934upIC8Z330c8OgIbNQQlpB7HD1xn1fhh7A4/Y0sPo7InkC43H/eOJGQkid054Y4X0ChyLktRsAAfIpSNjrD4cynmIMWoQPwo60PHMC35DIip2fWWvINx3TJvkDzrJCdvbBb5oNiXJ0AcvR7TFI1TZpPFJRCGgRFlERkM2JYJhncDHGlbZs1Z1yq9yCxXGhQ60O1N7owWo+Nk7c78nqfItyKo0Ki8axlVBlroHk8JIt/149D5AY3FKCKL2UV69BduARpGRhDMFETtOnSbE+xwf1mum98nG8sVKKAB3gPA/sWdK4invfG/ohEROjwtzUnIDPZJ2EJAt3DTIfEotCRragJrzjjb9SgBTlxDMD29O+haWczuTS19CgT6KiYcBpUHezs
 FhuZ0eom
 V+iLzrcJO+JSNcIfqXrKQyMYsxDuQU916N7CR4wMRo428WteFcHwr0NqJk/SL2SvTlccpUq4x6sl1sA9ayClFelW994UsMWG0fjmsYoIwqzYuY6e68+DbBvkw0A4SeLLom60AZVt9u66kAOaaj3J7GJdu6oC4mM9CWF73+FvgZ1lf3UwvLfQ1wCENdmC7sb+E/tNaGaFVYqUeHeBUDD3Fcy8NYCitc95pE+xvjPHpRkGqkFMSsv0/H5c1Dz/cKPvfXWve0szdQRysE45ojMQ3p3HCrIwIkrtTy1OQnN9ks1TRlYIYgCZHQ562VA==
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
index c01d227d7fd6..cba327f77873 100644
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


