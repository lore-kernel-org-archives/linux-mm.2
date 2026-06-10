Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D2FCD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204036B0005; Wed, 10 Jun 2026 06:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBAA6B0088; Wed, 10 Jun 2026 06:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118AD6B008C; Wed, 10 Jun 2026 06:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00CFA6B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B673212096A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:38 +0000 (UTC)
X-FDA: 84863631636.21.8D95804
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf16.hostedemail.com (Postfix) with ESMTP id B267D18000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nsHtLaKp;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GT0MH/saso5XoNvBa9r1fqryd7oF1xj+K/jBExVfL50=;
	b=uwr1cNzlFY2MRaU4Pel4xg+/tYV1SL8+7kDpid6r97hhJoELlJR4Cf4bd8tILhUpf1z6rs
	pnUQWFcrwPZEMSxnp4pOCnJkV7LNMrv8IJCbyeHVLGsWi9WBzKlGE2VqJt5/B52QWVyLy1
	CwfLQwg0Az9uXPlAABf1657V26YzfRo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nsHtLaKp;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087377;
	b=dk5jacHvxIC9GKkvSMXDT1CVXbigSz/v4wsxCcR0IZ+iSZ1jZ+M3xcEHFESYiIkD8gw/WO
	g3aIRikwpWlh76Htjk88j8wcMyYLEnUjAuG0Mzb/ePZoaySbj25nc/+EeXvbuMaB+cU4MU
	1E3ABkXUQMQlOsh7ps8WigqZyw855uo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087372; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=GT0MH/saso5XoNvBa9r1fqryd7oF1xj+K/jBExVfL50=;
	b=nsHtLaKpPmZN3gB96dCvPqj1xePqNPvDTXWzsteirsvEwb919JNZfHF/kOddOOVZ+tqi0uH+7wNQFyzU9cjDVr4pgFCjr/DWt4qzkEDZXe3UqfN7Yhb7g3eN8cKA76g4Kvrhe4dbt4BsWJBlLBjH8cTLptcqZXA+zbQug9nwcXo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aHmg1_1781087370;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aHmg1_1781087370 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 18:29:30 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 01/11] mm: khugepaged: add max_ptes_none check in collapse_file()
Date: Wed, 10 Jun 2026 18:29:09 +0800
Message-ID: <2ae023e4c9f5270482c99f244af5d3a40fc49165.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B267D18000A
X-Stat-Signature: 4tio5nx8xjbbtk4kjg6iomio1y4q1eku
X-Rspam-User: 
X-HE-Tag: 1781087375-658819
X-HE-Meta: U2FsdGVkX1/c77FqDRQOkm7BeGgNGGA+SXT2VBblaO9vQBjQ7JwXtkudaHPSQjEgO4tcMOQTFbUbeRp+gaou3t7X1ILKXrU8maI3xg3vjkjwwY4rTgbpbdNXjmLQk4oVHMunrzxAf8bA8ErvwmOf9ltX5eV5/Xg5UCp6IPzdmXw5DspHPjNsH4OEovJVf8ghrfa0Kq0gkjKbeXKikBpa3rbHTBcxfNzIIVkKx+3FJdWEb5nBeM/KiHM0b+M/Xl4y580mn5pObhuif5Y9ZMYIsFmKM8tf/hV96dr/85CDcNeyLRry9jlYSHIUjGFadspWSHAzcRstHkqJZpRRjN6DyHU8kIHrRYJ1ZBC/lOTibek6OVxj4TTt+c6rSZFj+K6fgSunPDTGdIfVIv5wWbZrgufNTH1KjT7S1/7klqf4fZdZ/L9cMwElVm6o6GC09LRc9pQbYsVifvzpGBOzgMpU6kESj7L7S004chOSBP0vTU0/CgFEJMnoz5I+u/7LmofZw2nlIgRa0t6SfnzgR7adNypoF+ELxLI6Bx/0kKzg4PUJamnNUcSXxN9NvseGE6jSTA/oZNjF7M9TU/ScMvNIDTfem311VVp/4Ok2Na4McrKuPVV75jUWHYTq3+ZcEeIgzMf41XHcA47cyR4EDemN8XAjY6eF25D7WQY9s3ybqKBdAs94B6Mv4lW8wE/s8riA0v3YTtqRyPcZjelVErt9/dzmbDVYz6ZXHtDR0XCHnH6S85acIiUSBy6djcQEaQWgPK3rpdMOdrT2kUkSttcqg+IPDMpZdCUA6yR6A/ZgxxNBPJ8BNpZoTLmhIak/YkRr/BNTiZ8HPJ53z84zmkNkrG4g2txl0/RkG+46ra5rs4BT75oEmg6V9xTwBPx59GYg1rDBSCNk4sTH4dJrhNts8wAUZhY6o1E1fz9/rz/TfpwPdXG03hrrBhmGXmYCZdjRYLnEM1WFukkoPK0n7FH
 0ydpY16S
 f3Y5T/ZuJxIG9J06KUszgcJdCTjLDPaFjYSwVEmaGaRz1JYnRK6Lp9EBsClUOc0xxdGAW+anFLGe/szyiqo9uxdyqyAo/jchwDAf0JnfpHSuiFuU5+3rWHqrbldrZvgjiguqll54KsDza1AHfJEBZ5Fjgv6i2bB1VtJGRxZ0CFfaG9D8FmwPtFUP3RHv9j06tTsR4IC3oJTIfFP4kN1FC3uforSOxTlk5fHykMEk0O66HTpXbvXfNCvFOyEl+oKcH3DNEpoGE543l3OoA6975A+2ZWLgTpdb3QAtF2tIYSlfXrwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to the anonymous folios collapse, we should also check the
'max_ptes_none' when trying to collapse shmem/file folios, which is
also intended as preparation for shmem mTHP collapse in the
following patches.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b12187709f6d..631459172e19 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2234,6 +2234,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
@@ -2299,7 +2300,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 						goto xa_locked;
 					}
 				}
-				nr_none++;
+
+				if (++nr_none > max_ptes_none) {
+					result = SCAN_EXCEED_NONE_PTE;
+					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+					goto xa_locked;
+				}
+
 				index++;
 				continue;
 			}
-- 
2.47.3


