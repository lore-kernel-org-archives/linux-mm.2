Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F40DC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 06:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EED96B0088; Mon, 31 Aug 2026 02:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F226B008A; Mon, 31 Aug 2026 02:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6786B008C; Mon, 31 Aug 2026 02:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D56C46B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:48:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4ABC612021F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:48:20 +0000 (UTC)
X-FDA: 85160635560.30.A468A6C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F9714000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:48:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DTT6kbv4;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788158898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PMyea5DRpKqH29IOq7YJCdjek2kE+JMzOsIjlPu1nxA=;
	b=dfDBss/t5MPuAYwZETBZ0qNZ/JKifDQWmLxeRCfxzIK2eBRaYQz7+Uv9FlMEA9h4mWdR9R
	47tiqs/ODHox369aNgPZ1B8ajU6eWn6uxR7MjxAMsEif6OjY7VtQAH/MXfIpJF4EzoF50b
	sxGtim1TTCASLqodKrP60Wx2KPKGvNc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DTT6kbv4;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788158898;
	b=CaosqkQCQf4I/9bj3ePOlhjFB19yr5zmW5xYr4HPYkxIrCq4/RsuXRUkJKCP992bFQoojE
	qo8fh9miroGqKxFooTrrla2KWsgGTLWBLY31q1uuLJtJxz8Zl1Y7mteot2eUb9uJn8lAVK
	NnDDMmMAUWDklRI4s3OdLGOe4t3Bzv8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7ED214BF;
	Sun, 30 Aug 2026 23:48:13 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D48E83F8C6;
	Sun, 30 Aug 2026 23:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788158897; bh=5olqPp+uoUNvpv37aMdMlkQLle9Ih+Y/RgwFUi6iT9U=;
	h=From:To:Cc:Subject:Date:From;
	b=DTT6kbv4UG5s8P5+bjJdSX0aemh/+OhrvlfrqUoL0zHbeVi5RRBshFICR1Sr9YuHi
	 MTNsNCg8h82qS1jkg5TwiL1dVKAzh/BUokl8Xq4h2649HNEb2BPDmaM72azzaKiwCT
	 LxDLLGYtYORTKij/gBSlNcrXsDkgGS7QkxksyriA=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH] mm/gup_test: report actual pinned bytes
Date: Mon, 31 Aug 2026 12:18:08 +0530
Message-ID: <20260831064808.77768-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zs8ksbceab6mory4ecnnpytkyz3ht3kp
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F9714000C
X-Rspam-User: 
X-HE-Tag: 1788158898-540800
X-HE-Meta: U2FsdGVkX19vTa2MwI2tRaYPq2ZMEeb0KSgplYQuuh6AK2wjQtCc2BGwF5C5TIdTBdtV68Fjy9Ai8+4O4bnSMSSY6G5u1kqtPyvXrLrhEVJ9JkaguyyHoYQwacxwUch/UO7YTDhT44UZ/Fhe4fHm3wE2K/dPSmSg29XvbVZrB4CbumU78bSBBLgXDlsDkrz/3cNzRaq4JUY5A58nJUfdvJN2PxOQnfV4B/mFFx9Z8A3cljrCTNgcc9aQnkDv0pKiF1g5wm+77Eukuxze4oB9WksWIt0nrWb4WSphCDFINUY/2JZT44AF3P8yzDPyoSz/E1LGg8c23iwaw2jUDKSt1iTtIE8VXHNmcjTgbJVqiL6NZFgseh6MiN0glGf8Zw5q93JVRiU6ioFeYeRvNr2YR4mrhlKxbQnpPDVhoFd6ibWPuGGTnCwdy5WkZfx+hiKBC6w0AMqjhulliSKl+LluC9QgbX5OqZBfpgDk61ZppZE6iQfI8qCGkqgNvp5fcAnokzzPTe2CG6G6xysuqF18VLRy315gxZQH3X5EidNef7r6gAgs41s0gzKv+mtSSQMzQY2H/uvrTSuqBXKxc8yVCSjtZvnurwcn3EnBaLFI3pjd9e3Qp3ky7avLQo5+atUBush4h3wLZVLDyEl3RCZd1M+Z5knwVwjGmpM1jKdizMJDVMRxeobrHOXlO8sI2btqNkRLHnSWc+7TXqwYlJ3WUfC/vLXzQz3Wt6ZZJOmJtNW2YTourVCOYQRa7VpgV+e2BWnmmj+k61YVvYZehOLmD8if68fcECSTzcAIqK6x0ByMzsoOS3DXZOjPpcBvMhUfKGk477y8WMShqR5hRBmlCLIHNPtAiS+l+snH9yiEUut0K1is2AZnB4FmU9oebu2f/RPt4hDc83dGRY6uKIEAllLWwc0dQ/gg2PFRkZHoymVh6iN+5knyJiU/yHMz8JE3i+TQxngMgm5bmCsROe2
 kAphOj+N
 6Ky91WSwXGLpBrOoPiXds+cpyXpzPHfM2iv7jhpyudt59TRLvo3c/Rdy2D9gufw2fQmwx652lGoxjCQFdwSSpNxH+ZwhegSvtdkMIzo7wj2vNK8wxZ8ZAP5kqZTaImIfE1s+WFunMjL7bZS8j7sbKALsvHe6DD6PlwYx11rpEG5TRaTk3xYT7y7Hj25t0b/fH6pjyzulgdZZOCtxWvq9umtu3yhR/t5DJFu+NgOgMgPSKuRkcswMyJnlhlLt2+4CAZo58M53KBI/TmV1fMHTsnjXWyPEgGPVKJ8mB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__gup_test_ioctl() advances addr to the end of the current batch before
checking if GUP pinned the entire requested batch. If GUP pins more than
0 pages but less that the requested batch size, addr still advances by
the requested batch size.

The next iteration detects the partial pinning and breaks out of the loop.
Again gup->size is calculated using addr - gup->addr, so it also includes
the unpinned pages of the requested batch.

Calculate gup->size using the actual number of pages pinned multiplied
by PAGE_SIZE.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 mm/gup_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 44c1cdfb9c37..185ba3bb8ed1 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -188,7 +188,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
-- 
2.53.0


