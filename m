Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A118C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A5986B00AD; Mon, 21 Sep 2026 06:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DB86B00B1; Mon, 21 Sep 2026 06:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C556B00E3; Mon, 21 Sep 2026 06:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D559E6B00AD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:35:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A1FD4011E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:35:28 +0000 (UTC)
X-FDA: 85237412736.20.30AB860
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 66060100004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:35:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=euyfizuu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986926;
	b=nWofAVAJ+N6Po8F/qFwtLva/IB0BUgCZA/cZHv5XHN4NgwN+KTzcCUzXAz9qnExmpEbF4H
	R/cxl8Q1PibE/2Dfr2yNrnrjgGLRxPAcoSAJUMKJue73kDywvvhAjXag2kcK0XuRpg88L4
	ccOOFpMOkTWO4KJd3sFcH2QDw2Rn7N8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=euyfizuu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biGGHgUQAKdhJdv6OsZMHXAKUuq6/PmgE2meR5B4aks=;
	b=UoU+MZLfEftzd72id4pvXXJS+vxFEDqjd1aCog0Ll30D7QUBXvWq/Wgo9bjWer06mddN+m
	R9ZrZvsY/sE6de3U1QtU11jVHKOgLENHE2uOzep8RHwb3hjjU88OsuPRb3r2g0KuRWqvA0
	zUEx/XGOyotIvzApjDtjy2YDbHJ4OtI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F05721CE0;
	Mon, 21 Sep 2026 03:35:20 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79A0D3F86C;
	Mon, 21 Sep 2026 03:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789986924; bh=D8etrFh5PGy5HLvPhwqGM1Wl5RU8d5sdnQrtvxeo55k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=euyfizuu/5QY080phLSCtFAVG7Fg2gRbfgcZviqYV0drqYHwEq1oalA5OTqMKzy0i
	 AZ+Keq9wAbPgZnGVWNt07LprqQMgTwvFoJID6HemD/W4kE8RfvCqO0rKLf0uCcVhWT
	 fyEqxvhLgAbPo2B9HxZeK3pee9ec0XGUdxpcorbM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:35:01 +0100
Subject: [PATCH v2 1/2] kselftest: mm: return fail when child test result
 is fail in khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260921-fix_khugepagd_fail-v2-1-3c2877beef61@arm.com>
References: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
In-Reply-To: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3364; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=D8etrFh5PGy5HLvPhwqGM1Wl5RU8d5sdnQrtvxeo55k=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQhlwV78WbJb7q4RVD8y5LKAdXtv1aAi8JrPW
 rL3T0NHYm2JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEIZQAKCRBt1cPRWsUx
 M3GBDAC4MNdpWxzYWNr351pgIvQuXKa3KGIz3ZEgRYMpoHVlHcwwB5g71QmxxG6TDWB77nAFBUV
 YLsiJv9z3urIQUe1ZZPfaMiF6wxk8bhue1l2a1ehLzIOdn1nSmaY2IdNmQ7k8Tbp8C45Vx3TCjG
 KMP4Z7F/FPz0RlfzHNOb0EthjIKXZvmoIX6TXKnk5yzySwiWknxOD5H+2pKZiyaYPX+KP1nv9tO
 C5419ZLD+3uW+nUXVR5KM6RRHHqdJ5H4UDvQddisWQeo36WrIGvkb9RMdgqm/hwJXiqUggB9HL+
 X48OitPGXzMxtPXjK0k6SSlVy5Eeo3r3XjBNR2xhgnjA3Q4Xrl3SDa1Yx5ERGSQ+CbPBheeTlN6
 96iL4WJeXB0WepyvAF2TBIJUA6uL5ZXHlHxbc43VJTUbf5TBAMv+MB/uyx4P7TUibh8Cy80HaaG
 cjZddcuqTa9uHzp5mxOlUdwNjEJcPrXjk3/aguJfPklr8Q7mFr8Gb7tcoeXX0GQWIjoDI=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 66060100004
X-Stat-Signature: ek76jerpy7e1sqjpi398pfd3hywkfxsk
X-HE-Tag: 1789986926-124861
X-HE-Meta: U2FsdGVkX1+FoMt871YpQJr1zqeNpUDRvxzpFfgAjmOu67Y2g0D3WCszua6GEVdIhNBfp4KjAv8ishEqNTygqC7DgP5HilP0LymuQneXtRYfEwzi7QzzHQTbsr1HWIydX8tLQdKWQ6QYK1FxopHcU+WVxtQ9TNdYCfbyz3GICfspMLLLc3zbBbbUAygu4qNLOhqgnmUTRguRW0RH8ZP0nXTf99W3Fo7GG0XAN99EikcETrPjvn1Rp9Wc83nStfI76Oa3YvGxzKzX7QC2k4gqRdKYpHELzomBg7FbqpWnWAaSmV3DHjnpDW+1j/Ya2crg6iC3kl6A8vAHZ97KTrqY0dMLa1+Uiip6vzPSmsemh7Rs1IAFwD/WE6/PmdtqnMbx6D2gEMi5hJEuxKuEyoQC/VGJG64X0nPku7xMRoknBcr9U18d/QnvXyDVBF9gh6gqKtsLjbShi+SIA2A1wFzm5on6IkLCVWpVdrgAgi/n0Bx70UO4NClgAMiNkUJx+zrsspKB1Hy0jT52LHRnTvNsSWmoVR4JL6V3p5I4sE+KH2kIXsBf6WGNUbjCMdKgq/6rccTMvdRZV7f2RRjIOUgj5EbHgDYOMn3cmUHNAaNeSWlxzORioU/Tg9UbbemW2HtSN+j5UsXKQv+Pzd4tEok9QnwRScKYKnCakHLklJ7D22JMEEOaLYePWljviqLfrh1ntL2zI1YrAndF1X7umbGDdCZRlyQD2eMKRfgJcNfLyWhrkVzFGafgfaEH1WMqLeA9WciQcxumLw0Tkx8EpqVPZqTF73S8hQxD6XEbURboM2QyhVipuMCCW0hNZuDTio0LxNCtZyvOCp1DytYMN5evNVOAmfxTPKUL7RYxj2hUMgsyMc1UIlhUTI+EbsJyYhouwvpLyYFd5FsA5SMiblpVCiyR7JyqS02vmDyqBJh+048lLWoJe6ewCm7Zp/TOPfUtfecmcrs24YNYovkjHVT
 gWi3MO/a
 IptJcTTLJMWl6kimCc07FD3p3Z7ucOiXPIbJ3XQSvxBaSXZt2gryef2bheJD8n0rZm6+BbBFulzi11fc6n5OAkItEO6igLpOraZnrGYuRhEOU3UyQ8djqW5B1J00IQnsysvTm/d99NRVDvMLUniuCft1T7g4N/LujhC6PS6rMZRgC4uDrvsdQM+BqCsm/ClT8zV2IVdvATnExisJNzFU7Dkw1SiLsFW8ZxQE2emF2KWzujG/PXq72FWpDgcvTCbja9/bAW7Tp0lJUsR0TGBG0assAKAAIcD+8iGJZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Although the child process in collapse_fork*() or collapse_max_ptes_shared()
reports `KSFT_FAIL`, the result is ignored because the test only checks
whether the parent’s page was collapsed into a huge page.

As a result, the test is considered successful whenever the parent’s page
is a huge page, even if the child test fails, as shown below:

  #
  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
  # Check if parent still has huge page... OK              // parent hpage success
  ok 24 collapse_max_ptes_shared                           // considered as success
  ...
  # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0

To address this, propagate the child’s failure and skip the subsequent
check in the parent.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/khugepaged.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f82673f5f6b47..c32244b565658 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1009,6 +1009,8 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has small page...");
 	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
@@ -1016,6 +1018,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	else
 		fail("Fail");
 	validate_memory(p, 0, page_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1056,6 +1059,8 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
@@ -1063,6 +1068,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1114,6 +1120,8 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
@@ -1121,6 +1129,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }

-- 
2.43.0


