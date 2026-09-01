Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F159DC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2BDB6B00A1; Tue,  1 Sep 2026 04:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09526B00A5; Tue,  1 Sep 2026 04:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA42C6B00A6; Tue,  1 Sep 2026 04:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7A66B00A1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:35:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04C881401A3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:35:06 +0000 (UTC)
X-FDA: 85164533454.28.4A552FD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 38C2780002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:35:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RVdmaqYB;
	spf=pass (imf02.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788251705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oq0AQTfqbuYthhT2zNJ8SjlzOv5rTBfPmcsaD89dz6o=;
	b=X1SRlT4yEppqvTq2xTfI/HuCZu2V0kYhBp9CGP8KtL/JIZDg6rykIL2RjI6xBz2JSJmjcV
	5tDsf9BM4Tb1mewuK/ganfOpo32FHPxaxdNUmVdjjOknz4Cyl+ExY/7XI/qtbPvh//2ELj
	h5pYotrAdydVECHRJdnR6R3ndUvr1V8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788251705;
	b=B/y3jzZhndvZ5V0RLj4nDzNQnZx7HT5GT2wfxSgAVJwKphQtOfL76FFsU/oMYZCJe7I9Je
	gk9pTfh86NQ/z3Eg1CDMHjsrBeYJ361Egu4r7yMIvmzNLJiCv6Usz73g/nuN85UG5qWgWK
	LjFWkOZnWCdMexH/UK514PY5LMXmMs4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RVdmaqYB;
	spf=pass (imf02.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACE8C143D;
	Tue,  1 Sep 2026 01:35:00 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CBE093F882;
	Tue,  1 Sep 2026 01:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788251704; bh=01OSK1dnvT0YlysA5p5+l4Ifl3lB+5p66nSfIvzM40I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVdmaqYBgbzZk60+h641RIfkq7oZFXC/JfsuqxHADWz3/2LUzWEqUdz9TltVgKPiF
	 w1ODnyplswTEaj9K/mpBHIqcyW5sG/YjUyDk9ND6XhMFBE2kLiB4kbM96JL1jGVPR6
	 3Awzd3MeVhS2DtbOm1Iir07g4w+02o7eJ44JVjZs=
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
Subject: [PATCH v3 1/2] mm/gup_test: prevent overflow in GUP batch calculation
Date: Tue,  1 Sep 2026 14:04:51 +0530
Message-ID: <20260901083452.115365-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901083452.115365-1-sarthak.sharma@arm.com>
References: <20260901083452.115365-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38C2780002
X-Stat-Signature: bhmtdkh34zkc5qbukfnh51mf57qz1784
X-HE-Tag: 1788251705-411432
X-HE-Meta: U2FsdGVkX192ocRgvE54ORsRkKnLmvwRVSrnFE/322wFO6VhNVO46+Em0aa1Fc0iRXe3UrHrOZ2jq1XptN9WybP6+OU/CRz5LBIAD90GL24P+dD3//hCiRPbAG6RsUThwulN9ua6+7bLjaAGjft7jR3xHfMx8TYg9clFBVve7ZZedQuk8ry3opmcwIQUmQVQSA4U5VPWale4Gz1rW1UPGw8GCk52eah+8+60R58ueExUgIZe0n/Sg7HDdSibxIzKnETApMjv8RO/UiFJLgcvxAKKSAf0IMSGvQODUDXaUyuTGch6m9UnyI5zdkuhh0EA4TGX6kVsGsZHpNZurKDyiqHD/pXoQwhX3zFsu3t6yQSMOQQgamXCpOICQYv84k9F20IJq32K8Vo4jYkzOi4rSIlYI/LgHzgKQ7VmrjixdimYE9cMKw8twHI1zant2QBuaqpwSMicZEZh7/QmFdVRlS7bPqxvX4phly6zO84IdnfX8b+NEGXAffj7yMXqkx3wdRlicY8S14FPEdwLK5//3UIAqYru9/hb2IvqhlcRIjS+iBgaBAI9UQfSQ9iQiJur05lo/1YvRsC5EM/JbyKLRvmS9dBRyTEMDHIR11pKnLe5IFk4NJ6drtUYaqhLmHejaYaouUf4PXfuPb0j4SXBxNdDLNlFf9QBNWSG3AsoKVs51FiFlOL3CJE65sUiYVnA3rnDuWjaGXgFX5BlUsf/O17LJMPhy7gCp+UhVmF7FJ9OJ/8Cvjk97eF8SmNFnlHv6BVhG/hXANhEOa3qRPAAyGIEYpdFqmBlk7Vvc7Fl3pkGvmHbx7bjl/5Nxgh/RTIaDQjjYWBsVvoAIJN1DrH3LF+Sp6z4yMfyziKQ156uoRi7SugnaPRM0oaGzSoGc1KqmLXJy6uRH3Kxi/YvC7d4LJBLPFt5KK7Axm19hxs/9KwbLF05hR8R13IwwhC0ZVyf93kLh5xivW3Q1RXIUiu
 iHgxI8Pb
 Tet9e2+Q5nkcTwc1nKvTh3ZhsZWYNytQGqkZywmiZatXu5Yzy6iGg08xbKBFgz2/6/e9Z9RbEbU0Fyw78OrsG+3hJfldxchvxgoU+k6ZAEzzk5o/fUG4qnX7rQMx6M3Nep8tHIysTqR4SZAndTnjuPxgDheyE4kNdtYZEqm5a58eVPJhPviGLfUt4L70b9b88WepmGeEduxaM++z/XU5OggcTi5heQaJ1RLO4ZNFJhq0Lvx/SFxgLVEgxK1ZSTMqopG0lVbByLMdEEfXNiKv+FqbMBFNmwkFHDaMf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__gup_test_ioctl() calculates the end of a GUP batch using:

next = addr + nr * PAGE_SIZE;

If nr is too large, it can cause the next to overflow and wrap around.
If it wraps, the next > end check is bypassed and a large value
of nr is passed to the gup call, even though the pages array was
allocated according to gup->size. This can lead to out of bounds writes.

Compare nr with the number of pages remaining before performing
the multiplication. Clamp it to remaining range so that next does
not overflow or exceed end.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 mm/gup_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 44c1cdfb9c37..910cbef709b4 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -139,10 +139,11 @@ static int __gup_test_ioctl(unsigned int cmd,
 		if (nr != gup->nr_pages_per_call)
 			break;
 
-		next = addr + nr * PAGE_SIZE;
-		if (next > end) {
+		if (nr > (end - addr) / PAGE_SIZE) {
 			next = end;
 			nr = (next - addr) / PAGE_SIZE;
+		} else {
+			next = addr + nr * PAGE_SIZE;
 		}
 
 		switch (cmd) {
-- 
2.53.0


