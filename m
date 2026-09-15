Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4643DC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6388B6B0093; Tue, 15 Sep 2026 05:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EA086B0095; Tue, 15 Sep 2026 05:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF896B0096; Tue, 15 Sep 2026 05:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 315556B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:21:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8E83C0267
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:21:55 +0000 (UTC)
X-FDA: 85215454590.04.1F1A736
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D0C631C0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:21:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p4rMo+IJ;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789464114;
	b=j/LI1TM7zbhIVmw5TEit6GXjGNdgjplwZ071FSdtQ6Qz6DzksLuzsARAULy/94y9Mcf64l
	qD+yxZEYEI9WiFUN+3Ka4GguN8LnLJ/iXq+GEtAh+8c10nfPv3QIaCiwbFq9Hda3iZhATq
	gb3PWIIhm71+zNdMG7Ye5+8Q2epKql8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p4rMo+IJ;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789464114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biGGHgUQAKdhJdv6OsZMHXAKUuq6/PmgE2meR5B4aks=;
	b=4Wq/xfRsHUM0QTu1LobxW70CHfjXi64D/YwRWE66PK5AIUcqDFzUeUbJJUJdyYFnO4HOn1
	PRAyJOxvrGRG6u/Qc5NV28sEOI4n+uhffXW74MCphTNUQ2ER4C3uXldSoz0y+sYxQl82iL
	cwqg0Q2lX7uAFutLtKzNC97atBADm/k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63483169E;
	Tue, 15 Sep 2026 02:21:49 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F3F93F86F;
	Tue, 15 Sep 2026 02:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789464113; bh=D8etrFh5PGy5HLvPhwqGM1Wl5RU8d5sdnQrtvxeo55k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=p4rMo+IJ/Gkhmw6l4doFJOhI3kq5Jsrz6oPJZQHc42wSQRksETR+uZr0N63rimdPT
	 TulTZLc1rZ7RX5Uo2fH7NNx47T6wNGRrtEkh4ryD1XR5bYqV0pzgpeiWYhM0iI144d
	 fz13VfZSG3KjlMxrf7pKTlhU4YDzO7wL/2D02w1I=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 15 Sep 2026 10:21:36 +0100
Subject: [PATCH 1/2] kselftest: mm: return fail when child test result is
 fail in khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260915-fix_khugepagd_fail-v1-1-bb6f04c8759f@arm.com>
References: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
In-Reply-To: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
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
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqqQ4pqgL4yB1OOTyqBCX0ujLg4uw+AK27HNSUj
 klNmhjYVguJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaqkOKQAKCRBt1cPRWsUx
 M9jODAC1p2pD+ImErVv4cHBblEws2o83F5MqG+kFAp3hq2sM3JAWDCTu/5rzPSZ96XYiCOJhGfQ
 Rz1CgascbrrgUX2lkNITzBJZxvDWiN3vHHkFSDHAq7vN0Nb1JX/FwmMDbUGU6sokZ/crr7W6B0E
 G6uz2lKxu5jE1uaNPROWId6JjXzJN8H2Tk3JQQFCPb/fwWOxZQ9lo1i07Xj4WiNkR/NhfeurO/m
 YhBJ4okasmpw3TKuufoFso92MjiKWPoZHJY89APsnRUuE808RM4W0m3+X2MPEdoHgJv87iNzuIp
 mlE7lt1w9eHwawcgv1VKEtNtN/BfFLuVSOoC/2IqrIvFwEoQr1A4MBCDO/moKVMRO82eYnFoX0j
 EX2FBnBXoIuILwFvQIDXGgCBC/hayweE+WrJL1J2iGBky7rP649fMnf9lsQZEwSatQDRw7ZfVaR
 AFpGz+ZgIS5jCcn7qJr2/3bbGw7p2VjhBZXC6ewfU63Kf22QhYcek+UTvZ0FuUZaIsKf4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0C631C0004
X-Stat-Signature: d39rwamrrs5sg88h36ahxtd9my57ntpb
X-Rspam-User: 
X-HE-Tag: 1789464113-663452
X-HE-Meta: U2FsdGVkX1/AT2onk/n74UXxoY+q0rJU/mjVT3N3vGTutsEc3PVaDfsiTZNUXO96f+W60nyrCXhLKADDROOQWYbDwBfLGfBkAPv/poATJMrvlqDCIi8GbSXkmg6YUZr1OPpL4Lra7HXMF/FWfBWL8J2qjg2XxckgmnQQXN5dUxxGCNJeHv2CXsLtFH9HtxvHVR3gS6Vf6F1XTnGmVQi/N9coJ0epAJudOi5IEXVUyedQOfZ4OzLVIVAYy3qE7IfEWnx/mpvP9zLKdv0i79mnLMjp0PHHq1nlIy3ndqgxsNYAIWHmy5mLYewg/j5alINC6G10jv4riwZhuxDqsw8EFt5CKwlPS4BM3iv18Wo5CzbmMG8DkE/hZc3ziaWCC7rXu/e5EJKSfpoYs9b4huFUVipvilxvpdZkKOEdVJVvUevPJFwFKJ3vaYR0YJNmfYa51UYuWZm/UWCxxAx5rcGLbEmQPDsDaPzvHVgDU4ixyQ8M1glHNq1KPYrlBe6sglC0L24+dfnnbleRMYzMIy5x5PsSoe0gSSEhfi24ctaKHxrVrNpf2ItTruUljNi+CfDg14nJk4iY2Kps7laCOAlV8kKO9rf8ZI7vyWPZx3vO/OHjSHGROFmruc8rOv3XN0s6FqdudG4C1rLWD7F8rJxm1FL6gs/42Aae4wplAt8pHfao9HWNNdr6TYiHSjRifj010RU9cdE6+9RSFj0NoryLEt+FnCVI4zQygw7B+HvJaTFArsZdMP4PqIFmABsPIPhKBCOhBtuG5WvB9YPrxC+rlWfBoiGQYy5EaZlPrr79TztBmzLCwO8arKQKXbLngjCuOStjg31O3XGYyvFHW8W8cL/GMi9mVdo0ZmkeIda5v7GJQsHA4IAusQdAXK0sMqlZog5O6YyG8pl7QbNrL4i63oWHBmy5fOaaWrHkOnnb7BIfCWvo4qxbCL7HXyMLqFE8GfgWjSG/CTrYi+0z1k5
 PRl5U0H9
 06lunJN1MBU21Os0LAHhYUT1Z2HVhhNQ8m3X5HQs4c5XTErOE2wE6malkOCgAAzvMZmW4/fNyKGYik2B0yS4nc9iofYBgwN+H0OMLGlZldTIwsD2J28Z+IT6Y0UZOZoG6aufg6jETTOBrrlguqecUNJMzmt7ahFkufOuR7Ck3ezJEoZIFzYM/MWsuSvLh2YJf15MIDFHni+1aTxfzeAeWLaGa7/h6qPtJP5iuUZIQcqc4UVmKnFog669XRgCiOQOzUcvOaqE3cXoItI1IwP/4I/a0EFeKx1PGJDO1
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


