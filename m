Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB2FC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC1F6B008C; Wed, 22 Jul 2026 05:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AED6B0095; Wed, 22 Jul 2026 05:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F7F6B008C; Wed, 22 Jul 2026 05:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6CCE6B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:12:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 659AD403E9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:36 +0000 (UTC)
X-FDA: 85015847112.07.AD92CD6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id AAD6C140004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EmAJ1LXn;
	spf=pass (imf26.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784711554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zga/fR/fv8EsTGbCfDXjBOx4IrmeR3Uh7/Bxr8YjPPQ=;
	b=5M9NIvoVtTozl0eQ8qjeqMNtvH7oqYT3LrEiGotng3OT09iRrYfXHbHgXrcQCBFQfsGLHz
	YrL6+7wXcEST8SUvzJT6LcRI2fCU844D1MuVlY2fChxliUU7zH422D/U/aESlsunMyoAJK
	fB0Tk7B0wL+H3fqcEF2vS5r28y3Ek3g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784711554;
	b=NOXGnEQQG2TqnXSqA2wcCozvqvOxnBRrghQgC5G5B84tecwQeDDEKlzW+lTUA8uIs4iOJi
	Q97HkneD/4aFb/zmraAsWvw75ndCOZ06DwT8jmpIGxc/9sjIny2NsvsVOwOYsF+dSUo4Yz
	TPzWkNsYfDcrlqDWFFX2Oa/YGodPrl0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EmAJ1LXn;
	spf=pass (imf26.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82E901595;
	Wed, 22 Jul 2026 02:12:29 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8FFA03F86F;
	Wed, 22 Jul 2026 02:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784711553; bh=czI4JpkN5r6Pglkijn4J8uwR+W7cYaCz20UvFW25E0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmAJ1LXnbyStBWZbM+XZg5iX3laoJLf10NFRGKMkjGikFAFWrOYZsGWQfQA7P06+l
	 MWHlx+JH85ZMa8pFF2rSs2oP7f0pfganXr7pKQvt60cxXDGGO/l2vD0BKxmIV9ARmZ
	 e7vXe48ntKqdSUc4bXVJMnjCIV2L9+NEpIhsSzxY=
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
Subject: [PATCH RESEND v1 2/5] selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
Date: Wed, 22 Jul 2026 10:11:36 +0100
Message-ID: <20260722091219.61504-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722091219.61504-1-usama.anjum@arm.com>
References: <20260722091219.61504-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AAD6C140004
X-Stat-Signature: dnqpjxsz5zfpq5h79wbpjubph4393qqf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784711554-915667
X-HE-Meta: U2FsdGVkX18evflxEDrYdVANtOIA9+dOKuqPE5r7CgvZ5K+g6M4uIfBsKleLPc7mOR4JqFfdejvgOI2+q4YYPEG39CJYGmKTogP4jiXTS/Urs1eZifDXr2wNnwZEnkMTm/CEMvZ44sr56fxWvipgyDzHgJ7jmXyFD/Mk8GOhU/Ezzmr01VhrX3AwuxiBIDrv5rCDuOb3/g/8skHAYHUGm62ug1GkSPEKcNOO5faRnc3w8f2uuJHezF4EUPDqq1GYjq04OugqNhlilL6TQTvNh3sLayTy9VHB/bgo15D88X8Gv5cydbBa5M5BBptB0hsLkc1HyN2WACnMIfvS2VsQOJQSyK6Eb5+wgsGffYPg2yRDjE6UsjnfQA3Xosro4VXTYDAE4yhyDyucYV4P8srTU1wxts355m0pJtxPqYejmGb3RH+lGEIRXa5Ny7mRwJVHVXW3Qvw+4D1h8L/l7xXw3Igq95ZhDIo6xoSEYDWYsYaPD4tWKgHNkVugJEHjxP168xHbpldi+AgBht+GFxSo9cpD8ECzUk/mubDVEQcyT36rRBqgYw5qmH424dZPu4AnCB1vpIRygamE8UYzDcXkyAqKoOnPTs8oyINMXLAVMdsT/vIPX0kCvwhwLT2S3wmB5TbYuZ+wBpyCH+06RJsf5A+OHqPHJV4RmxGN/VVKxofCOPWRkZubDNMgDdCaTH0EthNETHg9PP8KEtgx3NMCfOQJvDNamK2ClBLHpStMqr6tzzE0yotLJuQbiBmusqDfz0PTRTbTqTPa+zdg2HH2v30NLBWOVAIXo+f9kt9HYwjXe59/Ig2QrAJAWaWxkeYrHSwVcW27BwrgeEwtAgVmW/g0WCaLWcg1ghR/HYfpW8kuLtjvxPnNgQs2QMhxNKHJUFncZkmCLUqvN1d5+ohZp4ZPxalx0FNyKAMG0jrna7QRx1kyEwdvsE4mqScoiXLuln+d9d7/M+zb4hTD9Bk
 xaAIwdF3
 C9D1QZirFGfpWy6JPTnR1pgnvhWqbPG8jxqdC5mJ7XInsPz4U3kRS2lh5llwE1QS5jFJRjGb1c2uPccJEGTG8Zzt+QAZCZI3H6AtQLI25P4KZzNqUDiaKnZpFz1qwmBLQhkXLgGMuNkJen09q7mGeNTZHTeC6ysv0qBEYrCscuF+ERJ775o1kwk6saMcfTT0BWnmUs3rmhKhD/nzJArhwSscs5BdE+7kVzb5ife/DGbcF/FolwjnHsSm25vSScncPp6bD+MlCpyJk+owp4vYadcXOeDog1/x0vSwiAvUUa3xFxDL/7+qZhICIigSCzT5lFZIvuz/1C0kdGEDls6XX1QVjCh8EbmtNKqOGCfExT8zZtZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hole_punch case verifies that guard regions survive MADV_REMOVE and
that the backing range is punched out.  MADV_REMOVE delegates the hole
punch to the backing filesystem, which may reject the operation with
EOPNOTSUPP.

That result means the test cannot establish the state whose guard
semantics it intends to validate.  Treating the missing filesystem
capability as a guard-region failure creates a false regression.

Unmap the range and skip only when MADV_REMOVE fails with EOPNOTSUPP.
Preserve the assertion for all other errors so failures on supported
configurations remain visible.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/guard-regions.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index b21df3040b1c7..5c8ec3ca75d7d 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -1912,7 +1912,7 @@ TEST_F(guard_regions, hole_punch)
 {
 	const unsigned long page_size = self->page_size;
 	char *ptr;
-	int i;
+	int i, ret;
 
 	if (variant->backing == ANON_BACKED)
 		SKIP(return, "Truncation test specific to file-backed");
@@ -1944,8 +1944,12 @@ TEST_F(guard_regions, hole_punch)
 	}
 
 	/* Now hole punch the guarded region. */
-	ASSERT_EQ(madvise(&ptr[3 * page_size], 4 * page_size,
-			  MADV_REMOVE), 0);
+	ret = madvise(&ptr[3 * page_size], 4 * page_size, MADV_REMOVE);
+	if (ret == -1 && errno == EOPNOTSUPP) {
+		ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
+		SKIP(return, "MADV_REMOVE not supported by filesystem");
+	}
+	ASSERT_EQ(ret, 0);
 
 	/* Ensure guard regions remain. */
 	for (i = 0; i < 10; i++) {
-- 
2.47.3


