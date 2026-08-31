Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83A13C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B4B6B00A1; Mon, 31 Aug 2026 06:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912AE6B00A2; Mon, 31 Aug 2026 06:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852ED6B00A3; Mon, 31 Aug 2026 06:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60C546B00A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:13:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED18F140451
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:13:30 +0000 (UTC)
X-FDA: 85161152580.08.91DC511
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 14372160006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:13:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cnZL2NY8;
	spf=pass (imf08.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788171209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u4pvdqX6uUUjk2ecyGqAOoGGHy8gCGA80kHxkvMpj6w=;
	b=bT3OdyYkcUjU0affQRbGkZ7wrqmP8Jeztgj17r/WvrWxTmAocFx2ZWrxWz9VmGP7VnpEVu
	GzLW3y1vFZ56sarMEKlTreq0kwQ+oqkyDNcvtXx0eRDBUAF6X3vibYKEAvCvCJ+HG3KfHu
	gaFpl6k3bEAvoNy9uEuV1/ZNUR1F9QA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788171209;
	b=iiAwBDbyEUqXg1e2wBUQ+F8bdaEWHcpwTuhBE/U3JILs0eUxcjKO/tI9EIIIXCUC/InNDi
	ENfwTOsH66bjdIUp6FAY/tcnJNx9bqURyo00ZoqHand3P7FNFDmZu+gwqLHu4I60iy6vzx
	ztn54hWxcD+qCAgIXCNX3BTxDGmwpLU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cnZL2NY8;
	spf=pass (imf08.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D43014BF;
	Mon, 31 Aug 2026 03:13:24 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6EF5C3F85F;
	Mon, 31 Aug 2026 03:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788171208; bh=nAaI25J9nKaPHwn96ct79MsYlooxdS3n/qgazVKWIFg=;
	h=From:To:Cc:Subject:Date:From;
	b=cnZL2NY8ZWMhShcCvjAoi0MLZcRQmkdVeJgwBv8Gvu1K4wK4kM64Ja++SsdLjQYFM
	 hu95J0iYKE4pZJ5ne9Ubn42z8ZdgMEXTPSZNDCUmrWMOnLHzPFgz+ETMZMMGHGcqYa
	 SXy7h3sMOOUf+7Zrs6OyL8NMg44lN3cIg5w/AT6I=
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
Subject: [PATCH v2] mm/gup_test: report actual pinned bytes
Date: Mon, 31 Aug 2026 15:43:04 +0530
Message-ID: <20260831101304.162867-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 14372160006
X-Stat-Signature: z9drf87e4fuh1d1mgiqyxz7bxbauqy5q
X-HE-Tag: 1788171208-383077
X-HE-Meta: U2FsdGVkX19azodqst2aEVTGwQhGS2m5KQpERq8chfO/lBLpHXZAUZ9h210OrRT/T1a12MIawqc/Zzo1kRXl621dAZPzahEkgBFQdGBm/G8vYHCVsqJWm+f1ihP2CwNLkcUB2XXDClJvOj3XTq49mANmZ0c+xvMprwqeVZ1QfDWdKQGzvOabqVuXx6CNtvE/vTci0Svbwjglt+nvZ+EQAmUBrOUQeWG2HmLUKosABDyV7ltIcfZL+T2ae/HmsjV7UoQIHBrFcx5DVTve1xwPdW6OsY5E82bi4COxe9/0jwmuO8YAbP/d9OcH3g05+fA/jIujalaIN2sFY7ZG3ofM2PCekAHg+RwZYxBCYTEGxMnrWRKuq+tvV4jyL/u+PXhWN7CvUbVwKH0YBAacQ0JpXJrE5CCR0Se0USpbHlxq/6m0y639nPqRn4oUbYqKqe0EnLF13lFJp1DG2unBng5oN+Z6QWs1aZkF4iE3oxU2LNBBwGCdTxxx3DLwmXAozID1SraXFoiHT9UElwp2AgoSAaowfCIYroQ/gk0ZteFUcliyJEw2/y/6Io+ZUXWmdH1UPVaYRHtzea3bE2Sl3F6xbkEJqahAbmPQ0qf8wudQSeFsw0yMkhUE8PI0ISXnyeXcOKgWUYf5/PbBwy5QP94UsVkXMpalQZe9EefCy9Td/Qhy/DapQuuGicrwXkRwtdkcreN15Hgdl2eZYOHXoxSR72fb1sBqpxDwcHq9v7kQXPmSNDmclpNqxzAaYW1X/JqXN+p2urSHBmub68bMX+AhNhA5gnArt6dhpkKCqqWHcZaL7gxo+7rsXYOUXdgo+bqBPGJ5+JirA0ufAqoK9/KRNCK5pVmBLwaqe+WYux/RvsSpMMaGcqImJx9pe8yksXm2UIQ8h7TZaI6RjHabC63iePQeNjQckBj3bshuXn0XrYIOv3IIcb0mp+i/YprEpK5645KqVcfR6KvBOdyGO5K
 JJ4A2qCI
 PVDmCHBZcVAh/sBz7f/6gUaPGhJb1IXXXqoR3cYxKIuPL6o/WX1KFfReNKrhKt8VFrK6dU5J6PT/+8gEUOgPJO0CgzQZQD4s3aKdaBtxkoWqW+JRNhDQWfLs+1RIRb6yJ5cdIjDbZj/ESUtI5dZn4atC61XTRhl9g2wPsAIpswRr4T2xgGOOcn9em8AC7h9p+GA1ZpxbOsijfSkAJtqU8ccYV0UU1A2yxAKPHu66YVsa0KjOEYorvNyqu5t/3RDVHZKw0cXEwONGZVPRKvBeTYd7isM4/hEBYdojEujUrkMM+nV6lpDHhqPugxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__gup_test_ioctl() advances addr to the end of the current batch before
checking if GUP pinned the entire requested batch. If GUP pins more than
0 pages but less than the requested batch size, addr still advances by
the requested batch size.

The next iteration detects the partial pinning and breaks out of the loop.
Again gup->size is calculated using addr - gup->addr, so it also includes
the unpinned pages of the requested batch.

Calculate gup->size using the actual number of pages pinned multiplied
by PAGE_SIZE.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
Changes in v2:
- Fix typo in the commit message

v1: lore.kernel.org/all/20260831064808.77768-1-sarthak.sharma@arm.com/

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


