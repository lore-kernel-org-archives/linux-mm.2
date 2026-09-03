Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 685D7C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0547D6B00C8; Thu,  3 Sep 2026 07:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BF96B00C9; Thu,  3 Sep 2026 07:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC606B00CA; Thu,  3 Sep 2026 07:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C29016B00C8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:50:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53988A0515
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:50:52 +0000 (UTC)
X-FDA: 85172284344.16.A995EC1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B6871C0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:50:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OYX9u3rV;
	spf=pass (imf21.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788436250;
	b=6zNzMmxrUdkw/2m8lXLqajLJDLhl5neB+rNWo59nrMSlaZm3HA6VVazWCeJMNDbhh5wawT
	md1QptBcH3mZM0lE64G7mZNlOp5U+oX2hlbuCP9rNZn3pAmnjTIEYo4iXxYkhfvPJQ1iTl
	F44yiUABFhMUHW2L4CVhm6iKznzkKWE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OYX9u3rV;
	spf=pass (imf21.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788436250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iBJ6FLMh95RWOSuFSl/bU2pnYeqdpg+8U5aicOsw3nc=;
	b=Jh1b3GQAhFtluvLJaVCCaxL1zzTaWexusLqWtbXNo0Z/ubrE/q9X7SBUfFHCgDAmTIzIKF
	poeIwFbI2yeDg45IIDXa8jaWuuv4xSw2Nu0D6+92+5/HTdjo06UfHPHBfVBXyNqtywDhHt
	6rmfiiBdgcMn4+xD72SVoIwZbEOA7JY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BD381596;
	Thu,  3 Sep 2026 04:50:46 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3F4A13FA32;
	Thu,  3 Sep 2026 04:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788436249; bh=xNHHISyqPXjg7FpKlbhA9xX4vuE2G4pegx1UqDrG7mo=;
	h=From:To:Cc:Subject:Date:From;
	b=OYX9u3rVZbf/7HMtRWU9PE36MB1xZwLL4V5baneauVMSsnB8JWcJmug3RYeXRLopG
	 imrOYLEEFVgUTcdWMrzGn1D2vFmf//Jc5QDJFOx49Td8U7RKkFUa/oKIAk0qVH6q28
	 Te4jV0gcy4j/Y46jiobGg8THCPzgaR5kaGZ8tylQ=
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
Subject: [PATCH v4] mm/gup_test: safely calculate GUP batch size
Date: Thu,  3 Sep 2026 17:20:33 +0530
Message-ID: <20260903115033.162218-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dmwizmjdoi7e41tqwz8ta3o1auqbwynw
X-Rspamd-Queue-Id: 9B6871C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788436250-63545
X-HE-Meta: U2FsdGVkX1/IT+9BJNObCnQaTQYlB8iffnwARWolR7Og3vOQbLxxD54x8JV+HcY9FFQTpiKKq6KoQ244YTzr6I5oYkiVySV5598+6kDYaaaxwCej2DL3snf8GxaN21tPGi5daEnquJaw9/BNfwv1YIm0F/tT/U6j57B/DSAQnitw1zOPcnCSJadn45MF/FF9QmPUaX4ivYljDX7yanJ0/n3qe2wqPczm299/oniW/atacfDQRAgZtDCcWoeLkz0X5n0YMhn7ddL9muWwNfYYhwf1RB9TpCDOsowh4aV3x/1k+1pXYJ+DjDMEJdiZHb3govqvEW/IK5d34Fz+i3NCZGrzAQB2n7w6zZK6pXQGMoHczrsLaGW++ThMYCLe6h1CpdWhoW5CpAcDFHSmH9Ikq/ouMOYWQ9OIcEGS/+zzXhDqm/QaX3AdD3frvpGpxUhFR5jwv/KsnDEwpoNzGxyCMkMWALBE8n0iUC/R9XwgA/tjU/U98TdwQxg8gq7uVzfA6ATqAKG9/co2feI3ypXdb9fioUT/XH75Ul1eTe2Iyc8xyzKqf5Gc3Fz0SepAxE4tc/ytkkQbjfc3HLx1BK5bIvGOjRsFoTpNraZArgcROc60Efs2o3BJP9yRTepMO2cuZY/FJFLLkjU04lWly2hoXg28txFukkk9qMUern8osvKBlH4VywBsoBwBFrY3S+4VgNZnIc/rctZSqH8lH4LjN08I6NNjcSHR7cpTzToMdnNPEo/noeENnYE5lirj/4K52soE6blkvZIxcaqtDr6gqdiuBy/HRulUJKSUzF2dbVcS6LtNNKs3k/x0f3ghzFYOw67i5JWZ1QUTGXW29NApVj9AvkiHFsUjC9gDYSRvng5suMZzlN76s1xVN5TIdl9oybCJtK4n0dQ3I+Y4BHpuawHU7g/2VCZcMYt3MFgqOBk9NKoaPE0139HY/92J8APoK5xRbf7Dy6Q4MZ0zBgd
 ILkZQJQJ
 S7aqDmvUp0ezvnMhrX4dkmLgD1+I4rthJ5ukZlFf7NmZvo6SesBaCZFACiWjRq3OJfjfLoLll/3zNqudOaT8mHGtJpz8Ol/5+FWWaX4MplqiULSP+WA89tlD4ZhsHRVIoUnUSn4tV/lxQImxCnSMhaeL3n7onaE8lPy7kkrTKG+C9ioPRGL5YlKCynPpT+BDzCYBonF8DwNF7FWvaJ6nGS0JKh4fkS3cbIMsFzaEzdjcE4wohHlOtqhUYBxfhH8Zzy827yPZEEFNFaAx5bRRoyArCWBDbznFmi1h6I0Q4l7YGqx/MbLepALDJdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__gup_test_ioctl() calculates the end of a GUP batch using:

next = addr + nr * PAGE_SIZE;

If nr is too large, it can cause next to overflow and wrap around.
If it wraps, the next > end check is bypassed and a large value
of nr is passed to the GUP call, even though the pages array was
allocated according to gup->size. This can lead to out of bounds writes.

Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
contains zero pages. The code still calls GUP functions with pages + i,
which can point past the allocated array.

Calculate nr by taking the minimum of the number of pages per call and
the pages remaining in the address range. Stop processing when no
pages remain and calculate the end of the batch using this bounded
value of nr.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
Sashiko reported the issue fixed by this patch while reviewing the patch
"mm/gup_test: report actual pinned bytes". That patch has been applied to
mm-new. Since the two fixes are independent, this revision contains
only the GUP batch size fix.

Changes in v4:
- Simplify batch clamping logic as suggested by Kiryl
- Don't call GUP functions for an empty batch
- Drop the pinned byte reporting patch since it has been applied to mm-new

v3: https://lore.kernel.org/all/20260901083452.115365-1-sarthak.sharma@arm.com/

 mm/gup_test.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 185ba3bb8ed1..1b64e932c4c5 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -139,11 +139,12 @@ static int __gup_test_ioctl(unsigned int cmd,
 		if (nr != gup->nr_pages_per_call)
 			break;
 
+		nr = min_t(unsigned long, gup->nr_pages_per_call,
+			   (end - addr) / PAGE_SIZE);
+		if (!nr)
+			break;
+
 		next = addr + nr * PAGE_SIZE;
-		if (next > end) {
-			next = end;
-			nr = (next - addr) / PAGE_SIZE;
-		}
 
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:

base-commit: 178b3d97bf1f15f598ea7cc615a40c115e528e1c
-- 
2.53.0


