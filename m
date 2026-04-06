Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D072F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D430C6B00E9; Mon,  6 Apr 2026 10:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B5D6B00EB; Mon,  6 Apr 2026 10:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57F16B00EC; Mon,  6 Apr 2026 10:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B86976B00E9
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8960D16049A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:57 +0000 (UTC)
X-FDA: 84628345074.28.DA54897
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D6DFFC0011
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qz4ev3vM;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485315; a=rsa-sha256;
	cv=none;
	b=AexBNkCrrdfnbXkA0TVB3BCM38CldX9gmWZ0eWkXkcTjCwJ5h6r1S/SfVCTbMMagg8L+du
	3VklnHBjQ6qYfNyseNLBAoxz4ocp7p56s0PcJa5HWUHqUn/cI38AtXJYXwLa38/oWLl4u5
	xMkwayPEre1HtC3JalWgqV6Udq6HAfI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocTnSYy1KxNgPzpQMQrdurE88Vv7eYufvdv32EmtaKA=;
	b=Bm+ONvF0HlHUTxMSPXfzavOrNR2vRM1dzqJOy26/vwrUX774Czh8ZaAtwMtmrlqgj/7aNq
	5EQrv+jXD1kh1eUgWQpwTi6qZk1WJRlRsoii/B+cHyKS9dIG6lXr6o65pP+NLmx5xNsEKt
	fgrNkA23Kib2o5lDLjyg58AQ9MGydmc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qz4ev3vM;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6597B60128;
	Mon,  6 Apr 2026 14:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0450C2BCAF;
	Mon,  6 Apr 2026 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485315;
	bh=vCnjdXeTkcOgDXKHH4wTrbHB2ThXfy9k351DRlaWe10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qz4ev3vMyNDmP0KmG7lLNnA398L3h6LHlWRGk0c6u8ZflSN0OmjEc8kDVS6idFXjq
	 UzbwnFHPTGjr7GRlO7RyMCKBMNVYo4/0duoqLb5m0yADaGftrIhpwUlkMGF7VYSpIw
	 Vd9cCj1gk5awmow67SpPEsvmFXt0NKzCPzpEvf8FRrgCYMm51lx9GZcaCzQ+0Mg3Hc
	 17bLZVpV2NixENoYj6g/F7efFEHkcD1TOkLFqBAPWXTKh6Cdbf9yk21k/ttK+qy3HI
	 7QJRq7Qe8N5M1hNECEkA20Mg1RkFTcP9KWH6AQ4WlAvCtGcZmKR8P8NKYxOmDVrUWm
	 ltJwvx8tz+d+A==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 43/53] selftests/mm: migration: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:25 +0300
Message-ID: <20260406141735.2179309-44-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6DFFC0011
X-Stat-Signature: hm7opea5egrq8dwx3adcuj1qjt3716bt
X-HE-Tag: 1775485315-166232
X-HE-Meta: U2FsdGVkX1/rHKDFkKvneRLhq5llGluayzBu/9f7ta+0WCShMEiwQAbfYcBK4vIpDcQJPGN7laL4rQq0y+W+9VVlxd66r6peBzuXuWzX+yEPP+SMeMzOxMBQqMm4rSZ3OpudwuCdaR9tHXykCP9YegLgLgjL/1wtuhA95s4iDdL9g2DNA7HKHQNz0ilt3kz+Rup3GlA1mqecTucxgcBT8rL68xNWEI/Xr5NJNkqNIeKRnxVW6XsJDXlD0hbkqdE6lGGMvdnH71gE72jA3b2ZMUcFYh17hwQl6ZMkNn+D4rwV2KoHGhPaX6P5XcOFY4TZRGmVev/aeilHmH260Zp+Y+AooRCOeCXFJfEyOPRpFCrCzWgVssmrJssgUnA348dRRpCU/DdCNnjV7i+PCpr8ZXRtLFrQDs5zDlFyMq1IbSpejxj8+vpP5egcT7MJMEocJEx6zBNQaG8WsLV96WMuDueFKDimi96cZA0hal459Zk0mEN3XW3OhYZoEqh4I86BdL+J6OupTAcduI5Q3/29SDsBrC2ZfJqTlzIeRWSpaW7zRnG+osu0Qjf9xldijMpCCdgnyzWbewGAiCY7EznN3xg5LuX2jN/5pugLT77KGsoXEudaGdYsp8Hgln0iJL6zEl+9XCui4WwYjBIxwVZMUTXej9ace+FG+lKEfgmJ+nJUw35ICJIw+RQA/2pcbKToXp+1IFE4K64oirkGUzRNsSjSCV3sd3pr0k/RXJSuXXJRlpYpOGV823eW3E3vmDxwQwcvIWRgdbNVm0S25AYNkp7j7ECAZdQ5QhQY6cZRl4BrIuwr75k6YgX3YfiGeQF3YKk+44hIK2TqN9Y5KNGW78qbJsljxOk6kpR0xVO+Fk1TsxwIAgv2xwg8dz7eGM+1eKedTOCv7zb0glmATG40XA7A4dBvEA91Trb+pmqXE0WpfGgRb7MGvAwut3p9ZeTPHqjaFSz7DgTykyO8hB0
 YmNuVY+5
 DSksbTX1rgm+E/FD+Ibi/G5ZyeAuVAVVDRH28L+evf0JHg+inWzjbtyDA8C4HHNOuvHO4igIcFlMtC1sqMai9g3JoneYCl2be+yJpPvy8+27zNXax1t4Re5Flcsz3A+m6vWsxuAGWWXBxKkXicd4Al0KofU+ni+xCMOLzqBUfJQ4XHtJWNEqA+ru6C5KG7EuaVleRXbUOmtxdup1IiXaunZ1aCdONiilaza2aA2tly5xFMnc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

migration skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Since kselftest_harness runs fixture setup and the tests in child
processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
that runs in the main process and add verification that there are enough
free huge pages to the tests that use them.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index ccf42002ce86..61fb00953f83 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -23,6 +23,8 @@
 #define MAX_RETRIES	100
 #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
 
+HUGETLB_SETUP_DEFAULT_PAGES(1)
+
 FIXTURE(migration)
 {
 	pthread_t *threads;
@@ -277,6 +279,9 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed\n");
 
+	if (hugetlb_free_default_pages() < 1)
+		SKIP(return, "Not enough huge pages\n");
+
 	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
@@ -308,6 +313,9 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed\n");
 
+	if (hugetlb_free_default_pages() < 1)
+		SKIP(return, "Not enough huge pages\n");
+
 	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
-- 
2.53.0


