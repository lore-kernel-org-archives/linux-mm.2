Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E105BCA5FAE
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19B16B008A; Tue, 29 Sep 2026 06:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE006B008C; Tue, 29 Sep 2026 06:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69D66B0095; Tue, 29 Sep 2026 06:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0046B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:33:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2018B80485
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:33:54 +0000 (UTC)
X-FDA: 85266439188.29.2E132D5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF2C11C0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:33:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uwm464og;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790678032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hvAxCRFO3Uoiz8xsXoUsHls+l34TP1uxr1w6pqGBhU=;
	b=evfqDSD4d0NwqPWw2ECo7jmj2a/9LhfUngf94N3uiwoj8lSrDLzOuoQsjrgUPJpBegMLoS
	Yt/PNUXYoYvhUBLKr8MdmZv4cyocuToKgoKYq2HqNH77tbQbuDMbVbsJnAGyuzX866VKWY
	yXnJ/XOtmHSZV180D5Cr1gvpcUKoxdA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790678032;
	b=SQi9fCRD+T0RwpUV7hpznKvndB/HFfSYxprjDwPhjU/WMUDPlzoiBmCMANOXULI5KDwPUY
	GLR+MMNERxymg22f9nw7v4yUaR5pAaqiCfnHUTQDfLtRTfRJpOYubs7JCZlfUKwyIQulza
	XKBVStN7EQv254teB2FEe27qSg2SQ4s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uwm464og;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F3631595;
	Tue, 29 Sep 2026 03:33:47 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC3353F86F;
	Tue, 29 Sep 2026 03:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790678031; bh=WSTvNRWQyuaddIQjTCFjPpl7RHLGjlTjbhV5ffZ1XtQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uwm464ogtKMndLYwzgIDwjup1cl9OhVkcWS/AV/r4tMFqkVcQKYYsK1JLHE62Nfga
	 woVvJ2SuDQMbqrmGlOj2aZG3uNEHXdYIf1jUKHXwFg6x8UN5wMlllz3YIdwD343+z+
	 51hvEFcT09Mrc6l1DEtzV3l5CyFzIpWNDlmose+0=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 29 Sep 2026 11:33:18 +0100
Subject: [PATCH v4 1/2] kselftest: mm: return fail when child test result
 is fail in khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260929-fix_khugepagd_fail-v4-1-2169c18f2576@arm.com>
References: <20260929-fix_khugepagd_fail-v4-0-2169c18f2576@arm.com>
In-Reply-To: <20260929-fix_khugepagd_fail-v4-0-2169c18f2576@arm.com>
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
 "Gregory Price (Meta)" <gourry@gourry.net>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3582; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=WSTvNRWQyuaddIQjTCFjPpl7RHLGjlTjbhV5ffZ1XtQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqu5QHB2PFMwVWosw3cvFc7rbAWFvMN8pv0sQXO
 w6V5S2hzeOJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaruUBwAKCRBt1cPRWsUx
 M3uHDADQCD6tIH0Z1Qgk9WT4zJ+C8dK/TsckskhZrs5M525zQlBloSYPjeLtgbwzVZhSTsJkkFq
 /7XMO4L8EDiD77HjkDh4uylcHX8FvUI/FaUEM0uSxy/gFSY5c1Yt4vlD5Ur+NfvB3dNCQx04lwq
 FiLHZJM7c7gGlHzfO2OiLqg3H/JCKnM0VazHdgQlzD+gURWnkN8WJpfB9ICokm7VEhv4mqHu2A8
 4JKVv47iplg5rSSWVsvaEge0nYJO+U6OeQFH+bHcCT/Ho11kbml4qO5yeSn3jJqAWhoXJ3M6hp7
 C0ReJ7U37THHBz/njC2BPdmvzJiz3ArcMqeelkq2OdT/Ug18Ku5G1lA9WyEIzefWPBKhBfq28/F
 bNDeVtOm+K4/bfnUqzQsSEHurFe0xwPC03opCvnW7uk356r5R5bnc37X6Dm9hOssfJGUOyFJAjr
 b6lwT3py/C3fZPEJ+rEnufp9TtH7Es6ovmFJoPKQynNnARZScdQ5JhMkBxRaeCd1Iykxc=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF2C11C0002
X-Stat-Signature: 6kf6hsj9yoty48qoq6docf1rhg3oyk7y
X-Rspam-User: 
X-HE-Tag: 1790678031-520961
X-HE-Meta: U2FsdGVkX19Dp8ANDP7ASkRYsEWyjUJsITDbOPGp5nJM1H9jdpnhTbx2DwtimRlG7eCDpVx/jns2CVQtKo7O8HTnVjJ6vImw0YIahFX+VAnVcJk8dqOcjZKlBe6y7vCfkW2XAMUVbbH8r/7iBBtb+Oc8O59cwA6Ol1n58gpCKyQrBLsPdEKGVl0mmqN8pcA2B9vFUtbkZ5W2ou7edR5g+CpG2Pn5xvhCJhxXZuY0f6v05jZuY2NYy50VEmyCErAsU8DK5VuboiIqkSeYvagedTFgHqZ8KLy/md7/PShkirpZOWp7mJREyiG6FrzbLuhpBWGIHNUy4thij8yKEzv2Fsvv0DMxxxyCTtosv887Vdz6nWEXamV9buxJpeoGTH0umNDkj9anT7Pzm8U2XNDY3qbvxVYnvdvq0dOQ1iAzlB9ATCXVRRAmmI+iIB7JqmVw/pJuwZU7ze3bJPeWj+ecIt8ygYQEAGB0VbJCaBM2s1BBeJCKMqdWVg6vzXnqGtjnvPdLVTlSiVJQZUnnWAwXf7HXz4whFU/oRhcjVZLN7OsB+u6zNRN7nxCazximkGI6CTPK33L2gKuvyWj7vavMuGs/RFqQcO8ehgsyUCJWL3W+xwYpjpYG/zvIKziG6UqJgQK7irAmY6hPzg9nNA2PYVfAvT40ofsqjqP9jFz/mPQHgk7JZzzu7Rboc5CQ9Vgf+uoLe0XHW1/yRMGvEvannmYr+opnC+oZfihgguTcgp7PBMSIw9JuweGMrOG2TXksZ1BdF+UJhps8RfXdJ8dT9/92lRGVsRp6Skt3OzauCjBQCbTCSF3dnOmTUEqRAxfSHIoF7MVC16Xj1gCCeU7n9Xs9r5WH7ikIQI+rkNm/mXL+9MG8G5AKBqAq5cC+ImoxD+A0feZO4+jfKlHf7loVLv/rpUlUJss/DUoACfN+pnnHwxSLwYnogUahGJzozzVqQDbVRSNElnjzKdX7gab
 7SIzPaPW
 jwxhReNswAnKoWcymwxFdAoLUAWdVNZ3Da2W4VSppAQc9FLIglGTKoh39WZY5e5TpXSRgy1xhtrnlVGYahj05mPc+oAoqe77lhUqY9FpjpdlmY0pqC9OxMSCZHJcuHNUX1FYoznuI0gGlQAEW/wU8MD/xO4U+0iLgxpW9sya+0XE9d3WHTH45IG/kssJJnXYmpZpXf0AaRntjHGJLFBTr0OFvaFkXQXUs4e9IQiKKrsMk5wlt3SZCz+3uP4Bj/FJ2FwO5BxpPmAOFpJSRuhg1Yji2bR5TLmzsHX3TafdLv6SPHdsJGUy5Za0Rs436njI5hb9EV67cVT6UKqIQZCE7nJF3ZElNRt2ozE9dy1bMeCScvs4ODTCZXxkakdeP0Dd4nYK71VXafXJPbnM=
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

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/khugepaged.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index a2ac3b3ca5de..2aa7c9197158 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1053,6 +1053,8 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has small page...");
 	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
@@ -1060,6 +1062,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	else
 		fail("Fail");
 	validate_memory(p, 0, page_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1100,6 +1103,8 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
@@ -1107,6 +1112,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1158,6 +1164,8 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
@@ -1165,6 +1173,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }

-- 
2.43.0


