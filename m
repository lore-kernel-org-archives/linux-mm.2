Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D06C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86766B0099; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F396B009D; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE8F6B009F; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 784C06B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7035E1C2A57
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:58 +0000 (UTC)
X-FDA: 85225527156.20.D1CD1B4
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B58640002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="C6/aKmkx";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703936;
	b=439GduSRteAxgGM0DVX82Niqrsqv/M+rUZ9gyNi7nLrc7quLwucxBbQubDK9VHM652E7ld
	FMHzGyMguVuGQdwLHT2NfGBZP4Z6wzeCsGwMuIpE7KkqBjBvquF89VKULxdGh+vXBxz2gh
	s7FdYdXukIHqNdAt8F5nAZpDUngznC4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="C6/aKmkx";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTpaE1iWIra8O6SpviNVFAUm/4Np7UYKQjsgFYl6AbE=;
	b=Z3r2G2mLRaoIQH7ERHPs14aEC3uCKaArGHPQgXM6EDkMYMBRzDNL37AJUu/kr4yax4iyIi
	1/DQOX5d7KRS3wk0hbem2qo03CvE4DzEde0ef7vXGCB1QaEdMI/yckH9Y//2dUbRilVfc+
	j3dxXKdCgf+0LOwhbFKTavEbWIXryWM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703933; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=aTpaE1iWIra8O6SpviNVFAUm/4Np7UYKQjsgFYl6AbE=;
	b=C6/aKmkxcgHvjRd70abnrVGgBVn+jFRf5LILzPYAdhPiKlltfx6KzxoIpB9WR1UZmaHlU9GQReY5mZ97Pl8lyadwe2xN872PLTtqTRRinrjrge1C+COaTFrNLBKtGt/NFX8zXtvPGH2ci2Y6RdX3iXEkin8TU4UstcGRvrIlSfY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9taoO_1789703931;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9taoO_1789703931 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:51 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] mm: khugepaged: add max_ptes_none check in collapse_file()
Date: Fri, 18 Sep 2026 11:58:36 +0800
Message-ID: <56bd2febf013c88e2fedbd653e7cc5dc12c6bc85.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B58640002
X-Stat-Signature: t3f7cr5prkmiq7c33pqp5ywtd9dic5ot
X-Rspam-User: 
X-HE-Tag: 1789703935-235742
X-HE-Meta: U2FsdGVkX19c2+KQc3LksBBOIInyin3G2Rq5q4b5YszgymWD3rmNBjpK3RbQQ1AwgymDf4aMHVd69Hl1htAVgWvHDB6E4km3w2gzcETvmazkDFvTbrAVBiEg/DTMb+gFB2D/9KxD2T1is3trjjlNQfrzKnq+Pje31ex4R6BvHkDIJ/q0AfpjiCeTFbGIU9UW2tJ95i5y9vqFQ9CoadUoB8WgwqpegUuQo9u+6DQZEQNAH+QAcXSCt1OYxi3ikHSkmqbCyWUHhszUrEpIUM/r6dNpFrQiHSlfRc+lvHRI8GDkl//aYFYv2enQwVQQEwqVOM12V7BZrvNFf5HDLiTI/aoEh0/1jk1T03sGgg0O8Ox2vH92OfseNxtNt4T+wS9Q5Tq3Q0Q2xT8XWO7QnwqaRAA/Gm0irs2jWOKh7MCvJlcAzlCamthDuXoG7NjBP+uq5JCn5q8ooTg1yw5mSMHowQ3NUwMxFx0Ickqetv4ks/23SgxhCnfuaklDqeG4nJgnvYneRJj78QZwdCmQ26NXTGoz8lfaXbgdq9DM2csUIhLDVF7QYdSm81V1ZlXazG56vcv50sAABfdE56y/X1ZJaaekoakTRoOsY3dD4RP/qL2BzBxkU2mDPyAMBXRz3Uo6YDa5lcgnID2VPUlaFszzWlX6AC+FafrcXucyiMb0Kjf+SyDd7G3xGL37+vGDFiFnkk4rsfvO1WANkMhpev69fM4dnJpBrVbV+6wf4zw/q6svs+qrsYSF6iSVmvMqQdU7vEv5JPtB6rjEF6WZOVnIGVMRjp+3wgUuspaK6Qz7lHPOmlVUA9qlJJZWusmk038BY/v0JVL2JgbbZ+Ro8GdiJplbpXR+6cFirhZqet8dvEQVeqJqocLMDJtzgd4A/X+J9Xblh2PilXCV7U/5c+tSvqm1t4UDTFRVazfCdkKYI8QN701cTJJXTG1PaQBuArOKsOea7pCTB38JP4dWA9o
 PqdOETsp
 YzyqjjZZ+CrGEG+5lXh+wbTq8X7Aqaq9SBsXpbfyIqbKSa8kkhltT5LqNZnWR4SkuzX35b5i0YJvHF+3SRR8KPuuYxW4oJcwcCBm1d3ktX3ArYFeG7TuZ3j3djxeFKM9k8c6SOjrCMzG0J/wU2oVYeoMV2DSLQeW9DwC0ky6t0iOZD1dPNcrhI9KT5u15soYGyhFUkAFtRJGSBPHXhTcy+NBbwHWHs5YdJC6vUp4SIJQJyYPAq9bIuY4auZi8ZX3rVsliaFQsJrXTb6lXH+SGENxC5l1Z9HayAgzhH7zfndPUMdE=
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
index 249ee91a66f2..f741dec3acc2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2158,6 +2158,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
@@ -2222,7 +2223,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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


