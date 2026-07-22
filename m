Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9920C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8D966B008A; Wed, 22 Jul 2026 05:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65736B008C; Wed, 22 Jul 2026 05:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53786B0092; Wed, 22 Jul 2026 05:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB676B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:12:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFE4CA0E70
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:32 +0000 (UTC)
X-FDA: 85015846944.15.79F1DA8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 442F280009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=T1kpQAfc;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784711551;
	b=A6x9PTe+aJS6TRkm5aT4wbCoCaSKTtphFX8pYo+kXIC4Hesi2mb2b196eBNacICG72rSQz
	OJ+7fgxl9cGHGLBxW43p2O5NEI64td/b60+au3SD9YG929pWzu85kA3ulT+OLC7YvSEFZv
	IUOv5+KNkuADoPTJ+cTeOdE4LMSIgEg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=T1kpQAfc;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784711551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OI2hlZeqp95T2LUMkBs7oHSwwoZnZoLUGsdasI2s9WE=;
	b=yv3R3o86Z5AnilJZJmqJ6vlrhKodjYmQNapSHSyDhVkfWLNwRWkmN3QJS1n+P/XEXyrYTv
	vbZ20cNXxEat35pBVhL9GFlciG5MaL1cDzsH2wAElzBgSm1SJ+pbjlZUZ0Rwxymk4pOYFQ
	D8RAxRdQzuorLC5V81SrOiFHonlQ9cY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A27D168F;
	Wed, 22 Jul 2026 02:12:26 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 227653F86F;
	Wed, 22 Jul 2026 02:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784711550; bh=UkCBixZE4BaIDZgj4iTqd571WFG+D+00A3uwsD0HWlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1kpQAfcd1h63oG/X29DlrT88eBxwgQGQCmu88mokQ5ya8rJ4hg9ZAOrdZBp/Kd4T
	 zBcqkQYi93Zejo75X4d3zx+HAO0JoSr6pm/Iw/qqXemVOGO6fuVp24q8y+VRaOLsQE
	 KSovYlksTVclqD9AuVzmhvnFkXVIIxEfDFVDKn8I=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH RESEND v1 1/5] selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
Date: Wed, 22 Jul 2026 10:11:35 +0100
Message-ID: <20260722091219.61504-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722091219.61504-1-usama.anjum@arm.com>
References: <20260722091219.61504-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oghqqe5q5dacyyrupbshaaiesnugor8j
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 442F280009
X-Rspam-User: 
X-HE-Tag: 1784711551-226276
X-HE-Meta: U2FsdGVkX1966P1MLgT5ROBkbfPfaRroB6iT5J5mIz769mUDdf+vK0D48KENisVLuDfv+hAo4H/rM5a3xiHcC6BN4Mgvq+MI80jZWFKu23kVwr3bDlC8o5AyqU+ef7f/59EQ0kiSDFrJjO5qMGWkV/vN3OeJjYpakBNIfQxTSARI7VkrZ3a8xi67M2qIruv9m5dLZY+DF6Lrb4gNUCBkKLPzShtYKO9QQS+o5HtBGw6CZDVvY2HJl2vm85v+wqJFxkMrbXrd2LlFOE8J9qHmCtIH1nJdKJMS6Z+PhZ3Wq52xyMfIAGS8LOvLjG7jpq7/pFRObKWafw1LpOMUrAaDtjpetUWAuOPMQ+CIJnDPZqshJjkgRummc0SpZpVwRKWlRtj0eqdTLejkka3mgazUN1ZqPMZfol15s7vXebuWUGPA0Yv1FSqLsvNNR2CCLQE6lXmmNleHrENgFjGGXvKFtspudiQeU7ii23HpIDl9IG30ZoG2L1cZ+JtvKlfaKGJHUAUgkyM27eWLsw1GTXXQSgHW5ke5TUrCStBllJYbT3fR5rIHMV2bH5RxsT+9gljUU705w2jP9eW6KAVNZc/0grUN8fMZJUztlekjpv0a8EEyVBZGLZCi2xCmgrvhXPq1skmCu3gZXTWXWZOjd0ZGnX9qvkOEjcAHdyY0ePj+/lBrDk1jI8v4EHUtUsD9PUEhUGfXDO7HGNbhqnc7RD5hP8GmICiQcCdKAlFjt3xKlBI1z3gbu8Khnmho0ozPhcn4GVvxuh3McHC58BXJveBWdWRczUp2ZDngvOewfZvD4ZSRk7I3+Riije89JSzXkjYX9OEnsNOOkoejpqDsx1IwihSDB6VbM24bjj7rGXvleBCsxsgzL4SDEu1awmFtM4/Kfz5lLzovk6AOhE3QsyO3m/ZevkMYHvMNItxcw+OPlCCr3Nlb/I9jP9+1LqhYc4/2qOeRmUIm9IxdDLVoTDA
 J9PlgMPP
 OwDE7rMZREgi30DrtaavVn26RkUNKYlYZ6Y1sVDDba9PeG1UUDhrJUYgKDNFnnggGnCZrAZgxPNZVTq2wQBeqKM1+Pg/NCb9pt5VhTr4ZXZSYbRiLXiw24V3I6lqtS1XY7sruTSeqWefgmXm0U5WBMHaPkO5BdXWZ88SIkoVrGkGSRrnU+DIoY4XvrW9LFHbgzq6dR3arCRy0rdtCWyXLGYFuMLhYSS+TqyW20JAm6WYt6xmojrM21OZ7jhJYmnr71G5ZF+o9XS8x/0c6ipnV7wappcEX7FXMrJb+GWcEIxYzEZLyxdcuki++P5nflFNs+sZS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tmpfile-backed COW cases allocate a one-page file with fallocate()
before exercising private and shared mappings.  When the filesystem
backing tmpfile() does not implement fallocate(), setup fails with
EOPNOTSUPP and no COW behavior is exercised.

This occurs when the temporary directory resides on a filesystem with
limited allocation support, such as NFSv3.  Reporting a failure adds
noise because the test prerequisite is absent rather than the COW
implementation being broken.

Report EOPNOTSUPP as a skip.  Continue treating every other fallocate()
error as a failure so unexpected setup regressions remain visible.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/cow.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 0c627ea89ff7b..c1b8920e29342 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1718,8 +1718,13 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 
 	/* File consists of a single page filled with zeroes. */
 	if (fallocate(fd, 0, 0, pagesize)) {
-		ksft_perror("fallocate() failed");
-		log_test_result(KSFT_FAIL);
+		if (errno == EOPNOTSUPP) {
+			ksft_print_msg("fallocate() not supported by filesystem\n");
+			log_test_result(KSFT_SKIP);
+		} else {
+			ksft_perror("fallocate() failed");
+			log_test_result(KSFT_FAIL);
+		}
 		goto close;
 	}
 
-- 
2.47.3


