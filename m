Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B274F9D0FD
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3166B0095; Tue, 14 Apr 2026 21:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893776B0096; Tue, 14 Apr 2026 21:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6713A6B0098; Tue, 14 Apr 2026 21:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 566DE6B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:10:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A49256D10
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:10:43 +0000 (UTC)
X-FDA: 84659010366.07.CBED193
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3CC2B1C0002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:10:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L0YisQ+v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776215441; a=rsa-sha256;
	cv=none;
	b=nB/Q19e+acrBMwKlkmtWT7dPiT5M3AJepUaMJ3xM9tissZcT5iW4JzVh6hHed5s2g2CycO
	WRLdLtsIYunxqVWEx8OsSO79hx/eZo6CpoiUF1XvTnINKG7LZ11Vq5oC4z/XcTWEr3TADH
	ypldGE32hPQmxWoNxy3hCHQ5tsq8aok=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L0YisQ+v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776215441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=UzbQS16YiYErUGPo+QUpLwZuMWjgtggZhXgzZpLlewg=;
	b=wscxlDcUu44nrrgPbNlWhbNeXeoOj1VBXG/juzRbqLQeTty3vLBiywTLFTdnOpzkcsl8oW
	4GbU7p8SlI41T05klUvgyxq09AY1Yb/ohQYt+8heB+bWIa2m7UGC7HhEU2PqinzjZ2jwjR
	HiLEGWdz1+2pbUpa9LVOjrJRJuX4s+A=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-671dad7cac8so2251108a12.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 18:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776215440; x=1776820240; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UzbQS16YiYErUGPo+QUpLwZuMWjgtggZhXgzZpLlewg=;
        b=L0YisQ+vYat+mUyi+zzLsv9UCTVQlyTIFKi7/PkheYB3ZNSJWenuI8iqMd4jXDa8Sa
         AItXx7opsgRewerKN9lTy8LaKnmJ5gw1310ib2wDtzG5U6cwZx4qY5ozzzBrxmxsJaTS
         8AaAu35wi6zLfuehqPu8b8VVK8tLOF/hbEGIflXVwPCzTb5tuI7+CXePqT6aFAciONqa
         Jr4IM0pJkHo1iyILueI6b7UogX8SEJwoJX3BwYB9MaItERDHt0Uv1HUzYk5xYHYcF+rO
         +hIVaxusNAz6zi3QljTaPt4M7KBWimZoR2LCkHbqsSmK+2nfDrFSLm4kfTxQmV+nRuMF
         OCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776215440; x=1776820240;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UzbQS16YiYErUGPo+QUpLwZuMWjgtggZhXgzZpLlewg=;
        b=WOXAM8JOr98TklyWTUzQLt+lK/ipKmLWk7Lidpv+Fwtb2V+GcNCB+9ZYcYBNfJdsYi
         jYP5zxDYPDDbGR+Ar5LZDnqkUNBip0JPSCPoZAMBjq6x3HGX0cucWeo8Lnssy1RjZ1We
         UUnB5lEzTfbG7HUBYx1I3bIdmZdGoepUCwug12c2okJajwTje5vrR1XRJFcDSJJAaJOg
         a1O7h4crTm+eriv/4Ka8odViIZrlbxaSWjMPLKwY1GUwLmZ9reQRiIYlhpo8qxH+oiKI
         QVOgnWiDv9+/UMCsfg6TwkZzEq0Ul3k0K97Gge/cmPmcPi/eFNH5r+eVRNTECMWsZnTN
         FQCQ==
X-Gm-Message-State: AOJu0YwADlbrU0ut3+vYFTOCWRDJ1rQclVjZv8PLYiAIDg2S/dMvBIPo
	vXV/wyW7ukY1GAp90+GIRNtHkOu2SXo+B5pEgxfNZGyJrLV2B8JYxjuf
X-Gm-Gg: AeBDiesIJTPUrkNIahNdacRufq5HDWsptNoenwJMrKAkS4Tqx8PZdTReAmVLqGm6fbW
	wiDWzfbQGJIQ+pPMQiq55JD/NR6Dg2zk2g3mdvDkkmrjGqiKJ8jVzOYtPN6s6Vs0HA1DNfSil7R
	99HPcEZmGU1mJYQFGqT7kgeQkfYKB3hD0qsl8LJtA6OQV7gvqEZkmrweF23i27Ta//r8tHTAEyH
	KWx+dMnYYGwkfWOoVRgM6/vYlJpy7nlEwS9fFdCVPv1wYlfkVUE5MtnFY/nj4EgF7WJxRHjRYc6
	mF0zaV/ZTmRUAbHK1NO0MDRWURF2T5Mq799s8boCdWPqGn9ChWKeybSzWEp5Qor8dhuJwVfty+X
	qpW3eI5/sWYLwmEs98fCc8drWEI4+92fPIn4dzeX2E2LpK8IAkXCUe1olNu7LZMFzHcpdumVS+f
	qz8e5h3kHw5+yMigYJLQzz8l2ief6kBv7G
X-Received: by 2002:a17:907:c39a:b0:b9b:fa57:d5b2 with SMTP id a640c23a62f3a-b9d727d5741mr1034057166b.42.1776215439237;
        Tue, 14 Apr 2026 18:10:39 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba1778c3ea6sm3743266b.45.2026.04.14.18.10.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2026 18:10:38 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Gavin Guo <gavinguo@igalia.com>
Subject: [PATCH 2/2] mm/selftests: add split_shared_pmd()
Date: Wed, 15 Apr 2026 01:08:39 +0000
Message-Id: <20260415010839.20124-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20260415010839.20124-1-richard.weiyang@gmail.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3CC2B1C0002
X-Stat-Signature: mqz9qgpdkonhaapjb5hs75tgstbrbju3
X-Rspam-User: 
X-HE-Tag: 1776215440-322020
X-HE-Meta: U2FsdGVkX194VuTgzrHVaHBxhOBqc/ZBbaH2JW8EusKYWtKnR8GiWMxhvS4UPymIBwzJ4NEqUbrgqYTj4SBk2U4F9aTB4oqk29Dv+gCs+rKRyN8AY8sk9NR8+jpoKwBfG7PBYhAvX3oPFsU4Uxw2PxELjouORHYGym7SPHhJTxbOHewIYG+3ZXdbCWw75TrBC6N9Tu5e4AXpfLUNSLc/b2gUqcIaQ6OGVukKr4k07XxuSdT8ZK0Bkoq9Ewy8EFaVtGP4rXD2+9q/fC6lh7JxuiTCKOqSQj8SBPwkqzE2rxteQ4vQ7hHu4Ngr8V+iXyiHRDvSBl0+NNbqso1WR9SCGR6HXyNLOUSAx6vncOFeHahDMmTfHq82AscF0VxKm2Sq7iE7OQonQ3IBHNdRwpPoIypP0ymvBQMgwZibawSNqU7jA/acIW/E0cRv9K+Jg+kSYX2wcpsJW1JhDT3BQX1a6Zuy/R6XFnKt3KfuHcsSZXqlsSJSXsk+vmMqc1fczdpG4wgJgo/lCOhgKm0kNKKYBH/d0BtieupdHOOYoLh2jIWufn4MrcQoPh0lrdgDbH4yRqVR4mLDmxl7Vue2zZU++iym3t0nr/VGS6AueH1xKoUj83Fw9e9wHDIiyz3SNqGAQ5LGBuaV/y6Yofo0DEtV06/YZbnxosNTmxVixsRw4iDKSm5WjzRnt5zdvKfL11qBiu/OHjGw6vVQcouPJi6UTbwEBMYyiYigcAu57tGZSuQfbY1oRruD/bUyA8a9Ll1i11+QifLkPsq566O7Le/32hFM6VWRZFt2aJj8q59UD+XW4iaEAiNoWoSa+HGxep6u6Io3YjBWyl5fDQU5dihlIuo3FiUBicfNMZusHQUA9vzttvaurmiiEdJ5lGTb5XXXCRlzSGtxZcy59GBhoZd3J8pMZuTZ4m8ZhhF9t7v/lAqgS2IT81xZWebdL9bLCtBmUxH0n6rLDktNldrGQnA
 +vHqtk4C
 QSRdb+GOp3JqxltrPMQbLs1u9tV6PLlGozbnGu52y/v6WddGaLsCLAWdJn1feCM6ax0OLWaHxsr9YHLznxdh2P65XqCM+ckWnClmJX0HbfOMylyD5ysYXggj9xByqH2RKh6ohn3MKyYURyQwKumO9QYTz96euRXfWkWUwHMl2zNDY1UUtJGW4A2KFagXbrB/Fjsyp8kyOkukH7Uyz+J0EJB0GxfIvlPlxVZrEesH0kLbGV7hrmWm+p10DqMwahb0ptKA4nBurMTl5UNHCTRsW0Kq7yZRT03qYhLXyjTFmFzEMq3RAjQZOaVG0udL7sUl5hEETjDvbw29QEqiWmEab4kEIx2SPs5kKArQwqZe+pc1JsI1eXtbZYa2LTotSkkdfvUbEYPqh2jQRdXy2Mx5rs3stR1OjgIdjYoUP3gm+739Lh4bW62FSxttvndGJp1q2XfFdOBrtJbOV6gdu9JhbJxKsH/VgywBT55zY5uOftNfoPpsL9KZEAX2nGcrLi15bybJFkp+vISRUOXRX5zHwXSoa3+D9w7bm1I9bpTOZ0tID0/8d+ZMymwzwIDTk9Uxsxdt7/cJmXnzIj5e4Pulzy871F0LBPlOGbLF+VZhgGYHaWazVEQL4wgwpERUByXrp1u9OxgMqF/pkvk3u83oiwgqbg5CZEfMK2Lzs2EaJ9RqzW6rz/NzsYRq4EC2LxT+r57fw01MsoOX63i8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
split_huge_pmd_locked()") introduced a bug to fail try_to_migrate()
early by returning false unconditionally after split_huge_pmd_locked(),
when this large pmd is shared by multi-process.

This is fixed by commit 939080834fef ("mm/huge_memory: fix
early failure try_to_migrate() when split huge pmd for shared THP").

Let's add a selftest to check this is not broken any more.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>
---
 .../selftests/mm/split_huge_page_test.c       | 73 ++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 500d07c4938b..9d1de67f9929 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -16,6 +16,7 @@
 #include <sys/mman.h>
 #include <sys/mount.h>
 #include <sys/param.h>
+#include <sys/wait.h>
 #include <malloc.h>
 #include <stdbool.h>
 #include <time.h>
@@ -332,6 +333,74 @@ static void split_pmd_zero_pages(void)
 	free(one_page);
 }
 
+static void split_shared_pmd(void)
+{
+	char *one_page;
+	int nr_pmds = 1;
+	size_t len = nr_pmds * pmd_pagesize;
+	size_t i;
+	pid_t pid;
+	int status;
+	int ret = 0, level = 0;
+
+	one_page = memalign(pmd_pagesize, len);
+	if (!one_page)
+		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
+
+	madvise(one_page, len, MADV_HUGEPAGE);
+
+	for (i = 0; i < len; i++)
+		one_page[i] = (char)i;
+
+	if (!check_huge_anon(one_page, nr_pmds, pmd_pagesize))
+		ksft_exit_fail_msg("No THP is allocated\n");
+
+	for (;;) {
+		pid = fork();
+
+		if (pid < 0) {
+			perror("Error: fork\n");
+			exit(KSFT_SKIP);
+		}
+
+		if (pid != 0)
+			break;
+
+		/*
+		 * Current /sys/kernel/debug/split_huge_pages interface would
+		 * call folio_split() for each page in the range. So we need
+		 * to create one more map to the PMD, otherwise it still split
+		 * successfully after 512 = (pmd_pagesize / pagesize) trials.
+		 */
+		if (++level == (pmd_pagesize / pagesize)) {
+			/* split THPs */
+			write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
+				(uint64_t)one_page + len, 0);
+
+			memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
+			expected_orders[0] = nr_pmds << pmd_order;
+
+			if (check_after_split_folio_orders(one_page, len, pagemap_fd,
+							   kpageflags_fd, expected_orders,
+							   (pmd_order + 1)))
+				exit(KSFT_FAIL);
+
+			exit(KSFT_PASS);
+		}
+	}
+
+	wait(&status);
+	free(one_page);
+
+	if (WIFEXITED(status))
+		ret = WEXITSTATUS(status);
+
+	if (level != 0)
+		exit(ret);
+
+	ksft_test_result_report(ret, "Split shared pmd\n");
+}
+
 static void split_pmd_thp_to_order(int order)
 {
 	char *one_page;
@@ -777,7 +846,7 @@ int main(int argc, char **argv)
 	if (!expected_orders)
 		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
 
-	tests = 2 + (pmd_order - 1) + (2 * pmd_order) + (pmd_order - 1) * 4 + 2;
+	tests = 3 + (pmd_order - 1) + (2 * pmd_order) + (pmd_order - 1) * 4 + 2;
 	ksft_set_plan(tests);
 
 	pagemap_fd = open(pagemap_proc, O_RDONLY);
@@ -792,6 +861,8 @@ int main(int argc, char **argv)
 
 	split_pmd_zero_pages();
 
+	split_shared_pmd();
+
 	for (i = 0; i < pmd_order; i++)
 		if (i != 1)
 			split_pmd_thp_to_order(i);
-- 
2.34.1


