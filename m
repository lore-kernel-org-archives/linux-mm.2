Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C68EC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971A76B0092; Thu, 24 Sep 2026 15:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9495A6B0093; Thu, 24 Sep 2026 15:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885CE6B0095; Thu, 24 Sep 2026 15:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 652226B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:11:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75C1A1C2D6E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:37 +0000 (UTC)
X-FDA: 85249599834.08.18B6FA9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 651A2C0010
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LBHSCsIo;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790277095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13hOtGo7xgx1AZMH7zv3V36SDiF8l0tOoXqJVV/03R4=;
	b=bRXSa54LJV41bAOOgapZa6ZFxSBTvMK+AZNnRmNflIadiMZZhMq/XZ+hwOXBW1tl4dwH2T
	IXyMusq828GsTXo7vi2qZY5bER9WL0prvr6sgfDiPm8lR9zt30XCkK9GSe7WQOcWS0U64X
	R2uEROlmRTEP9uyFCbpsC9zqYx6Yvck=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LBHSCsIo;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790277095;
	b=WjonOUuZXTKEsh6BRtAsCSweC8U7mpTehhN7cuxTArT0h0PZr0qa/L8fJf8eA0UPau52PX
	6P2rYMf36kTvilf8qteit5ZXijxHyni5QIAMVNgHDBo+tEThuMNSFSFRGAX3Gekhx/Xv5q
	xuoRGkKi97Ha9FJzJP/BN1OVrQLPUR4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4DCB1E8D;
	Thu, 24 Sep 2026 12:11:29 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE7FC3F86F;
	Thu, 24 Sep 2026 12:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790277093; bh=Cp04Flq0uAtUr4B5wboFRQwEJBDejnd6LVB0IHI+q3A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LBHSCsIovix4NKw2QVz9ASL0qMoTQSCzI/HtXhZN1rnUVLy/HckTBXKlMu7oSmxhv
	 LBhZh+4Cp2BaUS1ZvfBbrQFQ+K+r+00tZJRMnxLWbrqj+kEVcKay3Ah1vmsSGJMGN4
	 HDWR0b2QRs4sTRc5zU+jVPOFwW/b0XYggwieCYkc=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 24 Sep 2026 20:11:16 +0100
Subject: [PATCH v8 1/4] kselftest: mm: prevent random failure of huge page
 split for khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-fix_split-v8-1-cba7359d882a@arm.com>
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
In-Reply-To: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
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
 h=from:subject:message-id; bh=Cp04Flq0uAtUr4B5wboFRQwEJBDejnd6LVB0IHI+q3A=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqtXXcbujZXi+XpYIK57ZqF2h1gdqKzbbdnd1tc
 /WPH1DdxI+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarV13AAKCRBt1cPRWsUx
 M8E5DAC0eBy5F+3A6LbX3CvhUrMPz514WgNRmJz6yMM1DmIcrO7HnAvnTU5LrUm1sFNxjaOxsHF
 Ocg7mTwtnP6axffBSXJbyo8NmCs8YY1iDpbLSeigMOg2Jw3IHcr6XYELBb0N8cGuiW4HlbAuXc1
 lkNvBqOeNgKaomCSOv7Rgo+iPVkPM/z+DVpeeEh8a3j8AOuShl2vPcmlyaQRdkhNvtJNee68WcG
 KwudWeAIVwT1JdokYRp4/m+bMBL4O4z8laxQoacJkAfkC1vsUYdrXhPm8b+p8JEMXOBlAupxPyC
 bFpUiNleofMa99dxQQHXo6El1xYgUDVLHS45V05E+eoaXPlfGI8BgHJa1odRzv9J/EjiwDgv1Ft
 2zUmDRpY1iHc3y9hDmCdb3H3JmH81dNXppXP82mz2a6/vYixcVbxzZUqNPj8Aey9FMiLmTfkPnD
 SBHwFTvyyInl2c4MuI+7rIsXwBLuZmROBR6DieFJGbn755fOeWCcjuoSImQlauiE599BQ=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 651A2C0010
X-Stat-Signature: 1ifhsssjbzewm6e6ggo53hx7pygfsmof
X-HE-Tag: 1790277095-880362
X-HE-Meta: U2FsdGVkX1+IKsAcZN8A7tBCCfZGAILqm4REVARooGDnOhyf2AsztKNK3fMS0dBcumcmfUUHXuKt/NwsXJ0gMDxDMfeYzB2b4xI54LdUKaRkdFGfJadU6bXyFP1F+Cch0MyU6UOwduxa2eVuKJ/Og0IUa3Lkkr/MSBSQ8cTl9iib3kjmgbTYbQHoi/jWOvjpcCyGvc8nzIU/wvJ0nDgSQ91L55PJogxUQUVj1BLhdifo0I5LmY9C8ep0NB62Kfe5sJ4MrN3dkp60BonMGpngCbmT6Cz+bJfGS0bz0JHTPqFfhDjU1bJZ4Mn3i0XKoESwudRkHP8ASToT9691KNT32H3MFQGK4AkbY69bh6K04yH6xcO3a8jP9bDMxAOzE+Cs2ZTJJ9K7H3McEDMQUzUrr+vSGfMC2QH5L0IIoXNmFPe0wBTBNYL3idbkz1oW1Fl6PX7hEiK3fZ4SSzU1Q9PuPqmN4+XK9p3jZ8J6isYNWsEX7RmUavI6Fx9vmQVe3mm/3U1cFH8JbVWUWrc0mq/l17pIoMvgefT1PEn0Zg140cZ7dbuYue75nmQD/nv1epOEntYGeb7Js6LglcD42Wmn6D8kOPrCj6/0p+C4HbGVMMYSJJ8MYKK18ZZXHcEXp0Xk87VaH1SziRFysnsk4oNIGUPF+N4RFuF2o6imiUFWRDueVObdu6wjX3m3+S1tqWkuYtmbZWoLkRxe2v/L0Df+T7o+D5V3sh+LIXBJ/J+nmHvofR+oTA6tUE2IIQVtNEcCRV9hAMd2x1tatDPKP31LXssuPF5Y3Jjt4rJ+l89Os8uY4LdW7n3sQUGjLaRRrMoWYPiRLGDUwkHCMBH1lpxhcXv7lsfAgRYxrgbjxNB+TCUGqvr2Cf5YMFErC3CcOeAcAboJZH9+5PiTJRbrX/IFgG/VmToSvI1I5xpi3+yqHTRQ58CZotEYSY2XarZn1RSORcmOuLErvIQonYJFbj5
 waD+f8Y/
 Wf0fLInXYp92wKgWX43q02BUz22FYE0B+2p5OftLolBJAj0C6TZWeimOpdXJf+i6P77HVOw/qvsDfDMdCxQ1hnPMuTxpfQIdTj6dDnZAZ6bIqh5+MmMMC/i1GCRPVxSnLXl5l9IBZ8cDhzI+pghKKsihbHhewe6QVELsrIODg1qfhcHcAhTz3Xn1O9V8KHg5/a9htPuHcEHFEX9u9wXuRv55kd50j/MIDebY+wo0e73x5PHXzj45pxyeSe1comH13DW0llQ52lNO4EDWqL7EBRRxAwMQSH8ZXdR9cWlXUrGX8wY4ZWoZlis7n1A==
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
index c5d96a4b1db3..ef4058662b91 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -108,6 +108,18 @@ static char *allocate_zero_filled_hugepage(size_t len)
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
@@ -120,6 +132,8 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -167,6 +181,8 @@ static void split_pmd_thp_to_order(int order)
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -215,6 +231,8 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	disable_khugepaged(thp_area, thp_area_size);
+
 	/*
 	 * To challenge spitting code, we will mremap a single page of each
 	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
@@ -482,6 +500,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	disable_khugepaged(*addr, fd_size);
 	return 0;
 err_out_close:
 	close(*fd);

-- 
2.43.0


