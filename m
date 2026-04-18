Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A35F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4875F6B0270; Sat, 18 Apr 2026 06:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F5C6B0272; Sat, 18 Apr 2026 06:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374F86B0273; Sat, 18 Apr 2026 06:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 234D66B0270
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:58:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3D79B914A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:55 +0000 (UTC)
X-FDA: 84671379030.28.82A6E4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3D450180005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GaYvJpiU;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3CydojST8YyCcBkw0GPuSQcYMWLZte5wcCWbjyBKns=;
	b=vEv50n7HXFb5j9M4YZRoq/YUoiD/K6Alr22jaMDosPac0nrpf7gKb6fXKP67S9DdM+KCP7
	7I/UJKq+hi7LUxd1+3gpD4CyfCFv+v1kjwMYz3fbfImHpy90GyMuj7oGHXRnVbjVwNc5i0
	Cn6kZolPFFuJinXi+VGZyjjRH2hq9lY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GaYvJpiU;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509934; a=rsa-sha256;
	cv=none;
	b=qqj2qydyq0mO/eZWUdI8G6WobRDW/mChjL+fXNZZPHexlaKmS6H6EuXZkLMlIszxbvxdzd
	KLA8XGkoaU/+7cLX/AsZv6W5W6qqjuFjvXC7TlCXGhPIeDV8B0at0kEUZNEIX9W4Bgu/es
	cKbdhgA+NviY1xGalheUb5F954/FlP4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40FFC43A32;
	Sat, 18 Apr 2026 10:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C54C2BCB3;
	Sat, 18 Apr 2026 10:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509933;
	bh=1/ugYRnvvCSRn7Fw/zm14SmACzlAtT74uoyJWfVmAG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaYvJpiUhsFjtAZ6oeEfPRx/pDSIplMUmXnj8hsUT96vWC7ZP7+1Ea3T30s/eF94q
	 eKwXJsTOAnnBsGeNPkSmN5Gge3gcCZsHttWZQuA5S1Xdal4Wa+yRCt72wcdTRYVSw2
	 Vq0R2kuAVWMgrcQpyuRkMO5IXDnz2a9IMetzEEpNIDaXWn0UwgA/uq4u2yvXNnuBHi
	 4Yr1BeujIa1LBCQcjvTnNsPjHFQ0aT7tR643fszmn0nYlqhmMbFvsb12hWhn7iVQlh
	 XBgaInMNWixJfVi6KKF27h3E7ulZb1AEgipizlM0LmPhLz/dN865L5L1zq79f3maBg
	 vIGexg/0WiFSg==
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
Subject: [PATCH v2 30/53] selftests/mm: cow: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:15 +0300
Message-ID: <20260418105539.1261536-31-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pozfyennfipngsmtciqg1ahn7kkw3a66
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3D450180005
X-HE-Tag: 1776509933-778018
X-HE-Meta: U2FsdGVkX1+latS8qiG+2PwJ72JqvjMGE1jErRMVQHP5eP3Kivj3lRzVVSYjJaurps8CNJKYb19Qz5ALyQ+hcRqKU8E+ZDX08oy0X7D7kEcKMbmtXZATAclMTr8uI8GTPWDdDGoouSG9o3ZW+xS9SnGYkSVVG1y2Q/vC3trs0i93DM/KtuSutuIN8w9g2L6Z9kWtyTcFlAA4hhdlvcvJzECCIZsw0zRgDIWHoiWvBBzLcc1GPP6Cam2f4ZPuH/KwnN4mas2zJ7Ph5K7A7oc1L+0m0Rk+IoUEguShUOsV0q4zy00xahccJzj2XzVk+M23qWS/7hN9etqwYjBcjuJjeWkDpZhrTXVrn74ZODFh9+w0+sgUtK1dk6M2hWAVaFDk7wf7qmubTYFuUuDV214d6BUFs7oYuXAtHC+DX9lwjYHIFKBT9/OkjxixaYopeYBOvOO52dWj2M2FVynfSqamMVdxRvE7iCqDKSKRkZMfkHo8K/wElzdC4CgahqBUFkiR52rriew571j7MBNb02V+v9U2KZysQG7tvDEiJtimHEbLjkWhYp8fFHpRk9iJl97lnMIb+P6cgjxJNisXgq2HVAMZD6hW5ilIfX2eDq6troSvtssgamY88mx4cZfA+8qBcWyq/SGb6fw/teQ6aiVfdA+4temkX59MAqxW66uE9NRMiKA1D0lHazsD99gfYuTxolekkM4ocVEkGBOkRDUI3A2FnA6egq2eICq/DhdASaW3gM4mM68xG9EtJeyd3ARBCd/bhx834Vjc0CsHVrZBGpEK/5HggTyzXzOWD+V0Npmjew7V1JEAvEiYH1RLs+Iaesu+X2d5TigDjQg5bgSV2bhbZACBNL+UjHMicWf7heXJaJ0fPnybet5Rih/DpVDZPSaob2XEvAatlziLrxFPuV+Uo0Tk7enDzcDttC3Ti7g9Ri0c1NtRuffwWlOhHGDgSl4Yjsc/XpuBdnBpNV6
 1ur5G35E
 fAIp+4NQHL8628mODmUKyusojwH+RcHkcsewT0U+4r9rOlfyayWZSIQAyAES5cdmPcAyHAcAbg9RXueuszxb6EmejDu29FJRvdA9Icdu0kqqT1nVjK2FalPSawJLfim7Hl05rl/G/adKxVZwC1jaR9zpMLfox+2/IwOQg0xLeXky7sLzk7uncoogH/njAGNPMSlF9UitJec7euke3e2WFLVxYJf+KHEI82IINLEzmt2PCs7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

cow tests skips HugeTLB tests if there are no free huge pages prepared
by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 4321f4208fe3..1df513bf362d 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1881,21 +1881,21 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 
+	hugepage_save_settings(true, true);
+
 	pagesize = getpagesize();
 	pmdsize = read_pmd_pagesize();
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
 		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
-		thp_save_settings();
 		thp_push_settings(&default_settings);
 
 		ksft_print_msg("[INFO] detected PMD size: %zu KiB\n",
 			       pmdsize / 1024);
 		nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	}
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-						    ARRAY_SIZE(hugetlbsizes));
+	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
 	has_huge_zeropage = detect_huge_zeropage();
 
 	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
-- 
2.53.0


