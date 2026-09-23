Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24A4C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC8D6B008A; Wed, 23 Sep 2026 11:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0D86B009B; Wed, 23 Sep 2026 11:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1BA06B009D; Wed, 23 Sep 2026 11:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D40246B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:30:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79444A02F0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:30:04 +0000 (UTC)
X-FDA: 85245412728.15.56A29E3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 87D30120002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:30:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WMGU16mr;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790177402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZouXTxTcmK/il7m7h0Kmd67F2xvDxfQA9DsiSMtH8os=;
	b=02zG/e4G9qTDEbhMhSp1sw8V18eWDVwtbT/fSUQn8WHDodotF9V6PWD94Ys4XwaricL/M1
	aasYbyfE6JdQ7DIx+T86c/0GOJMOoVhb5vbjZrKLP1yernUI6CUJADPviDaR9cQ7vCK5J4
	DezBVd+T5niJrtv8bkBo0U1PcMGUIL4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WMGU16mr;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790177402;
	b=vGbNkqUi8UTQG5WsJohXsdq7xhy+VU1z0SKEZWmH5hCM6IkQMzEMZsG0wBRHdt6yPQnZQU
	t8n+koeGMsgJ2a+jNQVixb+JtS+JWEafFRbPu1baBtSBd1HV07G6Dh6k7Z/wSmsSenOmAK
	eAwW7qMjzns4T6rHuYV+6uR47BQ5aOg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A2FE1576;
	Wed, 23 Sep 2026 08:29:58 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 921953F86F;
	Wed, 23 Sep 2026 08:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790177401; bh=pIh12rnr/ckKT4a1lDC4z/x0jaw3aErYrMx1KjdCexA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WMGU16mr7jLNRHpkFcYQo2v89xd8hIf4Y5wEbe1MmX6kpBsNK4uZGLLUKj1tk2Ru0
	 kcf5bj3yAQDI4uqDIOnnK5Jnv4tZUnbtzwE2wl937ccgJ2QAqzcrnJaWUWuCSIZgVo
	 ojVST03iCdqh3wLEyOnfYLVkkPv7ttykOwRjlyE4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 23 Sep 2026 16:29:51 +0100
Subject: [PATCH v3 1/2] kselftest: mm: return fail when child test result
 is fail in khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260923-fix_khugepagd_fail-v3-1-b387e92fe1a9@arm.com>
References: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
In-Reply-To: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3420; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=pIh12rnr/ckKT4a1lDC4z/x0jaw3aErYrMx1KjdCexA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqs/ByJm0UJBg1OcjxXEu0FPW/W9n0wXsrir4m5
 i3KrjLTtS2JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarPwcgAKCRBt1cPRWsUx
 M/PgC/wLuFeWfUHYMoDjP+xiQ7jWCBT6B8SaFKYmvq39ggXdaPUl3cBbOqLa6ywtGWxsLXKkYFP
 k5kw0u3iXrFZK0Z+RI6/cP8YYjpprR/N9n03XKUIMy2nY7o7weRI0+zxMbIva65YOIZ4/sfRn93
 vxNcPACJ7BTT6TRQqPHtRaaJjoqEPE5wL9x0VDmFuR79iY+w1X09Ta75/IdF5XdOB5s0BGMwCHG
 B3TopvF4xJnnC6kFNqv596Vak9R8qfa1tt9Q4+kiJE+F9QySoaLPjVS6EpWqC4uLURFPoxcDg2R
 2z4Ii/DuKL+7Tm9954R66NxPpifge2nxoacGq/nNBQQTCes9SAWzsSefUvjR/bqEKt+tQ2YeEWh
 Ak8lQjWERBrSq/JnG55DtSthrpQ4UDjTBb1YeDvMNF/l4CrOqDTUkXVO4wlReemb+k2boCqRHOR
 mLZygUoJaa6iTkrB2C6l4Y+r31qN9yndBNQsPU4+CchQj8mfB3MHDl+MQ9zaPV5KplMnI=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87D30120002
X-Rspam-User: 
X-Stat-Signature: 8dcz6n9umrhj7yykzn9saoegzbhxmtwq
X-HE-Tag: 1790177402-704881
X-HE-Meta: U2FsdGVkX195Oc9sbImP/uZgp3lf4NlKtnmtK6GsKCMA1lYuh/Mql1HnkITSBCyKRHpfnONmHlx2fTa0DC77nsGGYXVUT7VaX74qITaDfkgmdt1zCLTuLE6bIGL/RWJi4vdczLT6I9vITsfyz9BPWa/LiKCCb1GbASosLzUx3qO+SejCt8f1QcyxDrypSWX/19LuyiZU06POzS58imCGJ6x4HAt0nxJoteIOfBia9gpBwEGjOCb9AnP7Ptrrt0Ozuy7luXKe+c9xW1q3MVlkVmzY8bjAtN1HcP6KtpyEtp0uaLg6ZCcvKjAofQ/Y9U6hjnTKelya7XtGeVcbCJoqTxexBdaExSua93Xjg+0rA8AXjHQwkmM3l2XplozmcVVyJYbj2sV3fFUy/JR+2GR+8YRNMEt6CAr2nK8kgflFJlV3lBvYhUN2RD/JSfKfi4WFB+jXPkIFmqitI6jwhBIv+fTBaFuA06fZ9fIisBEG40TEPc0DUqrvwwU/q8SbN/snE2v3jcZPe9/yKmA/okLufMNCcOng4sT+HgV4O4CX9VycNjo5JEhezHoFw7nJ1LShthCtQEanjPZfkreOK2kZIsqYDVmWcBbcAKu4T7rhM0WVCVlurGl4S4+xKHASy0wR5bDrZ1L/kMKcPN5UeBfSQu6kz/ZOsPemX9pehXXzgDANDo3775HiCRiP6lQT843V83KK0tljqmM+Z0fA6lj/9uIK5xSomRAy82TJfZonXkUrnL2/FqUe8MSbnYcUzok3VfS5+Fv6kmVaycPWyr2O/FcqvapVrOvH+bG6Z7rrJzkrR8vZlsZzsK4bf/VOaI/Jh44rAkEVzu357RhaNz7n5CWEwnlAW9b6pisaEilUT9p3FvO3rzkKpVJH94DN1FoG7pAVuaN1xNjFgFs+wjviDUWZLHMxiNi9TLp5sdOPNeuV57DvHqboQiUpOcZGWdaAvvxwmVuvHA22dcVTglS
 ejgdS6jo
 o6cIQKWC6PwMdwUzPYBw7ho7/VYQGBGaEyXM29upSeDvAH1sg/gpteUOXdhrI5NFOdKSus+8vn22xXxZ9XQdWnrUlslWDQdUGtUUeLeSVJ5JERyNor/4arLyZWDKtqoZjsl/uIRuw4+PDOI7oo3MrGhKAwnT+oajfwG/fB7CfD82tz5d0aKYcfu7iZD5QgasMcn4WXfNE92QQ8KoOZ8cAl0fORgwX+K3DsYLd0jk2L18QKXlsbnYdM4eIghy9optZRCgP6mBoWCqvfCYb/ExlUKQVICcggMT4pKTveV4485Wcr8Im8j8Awyk4cg==
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


