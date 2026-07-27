Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE72AC53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675636B00A1; Mon, 27 Jul 2026 05:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64DE06B00A2; Mon, 27 Jul 2026 05:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B876B00A3; Mon, 27 Jul 2026 05:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25F7E6B00A1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:54:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89D04160621
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:54:32 +0000 (UTC)
X-FDA: 85034096784.11.1BB58EE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id C665E40007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:54:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VkVpdYd2;
	spf=pass (imf12.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785146071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iqgxaXVplLnY8f+3ew5nUXRtbyiAVx+b8Zw/XSqL51s=;
	b=HlrLa+5/XDa9HZld6R/7NV3/1MxuR0hDpVaoXivAfQwqgksGwfBnrrkyc/Hxbqhl3K7fSP
	+4gM+F8Imka4sxocp85UA2zDfkMVuGiXene2zLI/wMicoqFmi3ikWEJo+6+LKIXEu/cAtA
	Yi2Nuw3bUgyYuyFjMiTAU1RNzPH/Ncg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VkVpdYd2;
	spf=pass (imf12.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785146071;
	b=xoQdF1b49OJ5C0IZsAE1wDuW8cxE03EIBL2LFvVK/Uu9rdCZa6PEo++UTSRZgmqDOmF1yt
	71Jqo2I4cXVmAxuZ9G3EhB/0V28v9S5M29/jGQW3YmyQMe4/yQO3FAwYjdU/iQ/kv/vq/H
	fsVIxJdTWmfs+Da/QzMRvU1BC3sS2o8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D28AD143D;
	Mon, 27 Jul 2026 02:54:25 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A2F6A3F66F;
	Mon, 27 Jul 2026 02:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785146069; bh=IwWrSDrINE++NYwqj/Bk+VRo4oGJ2eHfAb46LAiKODc=;
	h=From:To:Cc:Subject:Date:From;
	b=VkVpdYd21kJu0+U4OzGUiBxP/KkjUT1DaHuHW8cdr0cIYRPVvg059nd7jIRnT0l10
	 epzhR+iaQPlv+eKwAcvnKxZDzLfcqJOOF6zJaeB7nOXYSKmC9FbT8vqNArEIwj8Twy
	 q6GWXNCWhWjHqC27zmzMXRr2aHzXPeUcOcl+66Rw=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: unpoison pages in memory-failure teardown
Date: Mon, 27 Jul 2026 10:54:14 +0100
Message-ID: <20260727095415.385026-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C665E40007
X-Rspamd-Server: rspam01
X-Stat-Signature: 4nu64bwagiypoefj6wjyj4qba6rjqqxj
X-HE-Tag: 1785146070-22546
X-HE-Meta: U2FsdGVkX18sRcOP9VPAdJ2QLiJ+FE3rQZUh/TosfPY6u64hGxdWHfsl/Ko98fhBQFDilVHViBiRIBI9BOMqrOTC1zUvLYHa25KkNt942WE/tmWkWiCZ6huwg7ZUV9xOMwcDfuJFJclA5HuHKHpZcIowSbbaJI08H/Ux973v/k8KLA4oXUEC358AZjjl+ruyiNa6VHwjHdZB0uV/Zb6nVfUAjPzPrm6xdX5UA0RPmQc1UFZKLgNgbewHBrQ7J8SFAP4TMmPW9GoiLQHBhBhG8+QirYdHEiwAJekRfvt9rdI+FslAKqWbdDpvJ3RFkS1tthjCjtVf6R251KPugywl8I5odcnS6yek+M92LLMKw5ML/bRa4hJcIAgWYX7D4wsvY0BL+pA5E4jL3znPKSA1b5PRi8hogJZUP78QxsdaFAoJHwc+ka1cIYoZ275Rl2I0FK0s/Z1kGcBkCI3y0wIFdKE2GBEXTeA7YM/lOBKi8ba51OpTXPoy3AoTily7bCb+NumI7ZwFZm6fPrDvhyPqKatk0Q4kulmmOBvuXOPp0uJWVIl0ZwuMv2hBvMsNsb0rXnZyQ+jS2w/WeNTUy5zjdFBAL98zlL+41JCyvvtohuhNZsk7OX/OUwhCqHh+mOSHFFwFvHA7s7smqS5MOWIGV7wxjWJypPs0W9+QVOne0ET1pe6NOGrzjCFsZ7WqsY1Ydvi204PVHq2+5tXhFLVhC1sATAd0q3yH7oLjvewctbA92idQcMwPYX4N6xSMyxdFZ/uaM0mqSx+vZMUZdq0K6+sRMl8BCKKk24ttCyVJHBJq9YNSZJPs6+7aGa8NcOpyScFcCuL7HBpRcziktHhr0AH+xTI6O7Oe8hFkZYd4cAICaiYv1IsrES1zuYzSct7oODO6YVDlHQb0x2NNtk5sUVPtVuuhOJkp3s9LKc17dyEdwZRs4ChFvE6VgpYUBO1+yfPfdlBewz6euLwYXGF
 FfdSu8NZ
 AzKKgYFqFh/O2WS7ci9uAObHpLHINGn5A0Mm0TT5JctYv7VF7iNtXFqUO6vsKsnx6vZzrJw3gF4vHJQmF+198pWalSqy/mt7AtvKzih62RkUEeVSRB33s+A6x0U/b1DzlFv2egthxMC3iYXj9dcj6nxRCXj7t0zeA6nYF1NvRQvWx5pdsrY6Y6h+Cpe3H0XcwqoP2dbOHdOMgwVBcLXd9ZQaociIuSHvGIivdIlvqKku9fIgAoTsXgZf2aiyKqhG+1LotBhnWIBGA7S1BLrqKSjyTjjp06ClnXwm3GCMEHtaKWOFEuumSFiuFvhN0Dxcl759W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory-failure tests call cleanup() only after all result checks.
A failed ASSERT_* invokes fixture teardown and aborts the test, so it
skips cleanup() and leaves the injected page hardware-poisoned.

Invoke cleanup() from FIXTURE_TEARDOWN() instead. Guard it with
self->triggered so tests that exit before injection do not try to
unpoison a page when no injection was attempted. This runs the existing
HWPoison and HardwareCorrupted checks on both normal and assertion-failure
paths.

Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/memory-failure.c | 26 +++++++++------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 5d00aab31f9b5..eaa8b9bd401a1 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -122,13 +122,6 @@ static void teardown_sighandler(void)
 	sigaction(SIGBUS, &sa, NULL);
 }
 
-FIXTURE_TEARDOWN(memory_failure)
-{
-	close(self->kpageflags_fd);
-	close(self->pagemap_fd);
-	teardown_sighandler();
-}
-
 static void prepare(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
 		    void *vaddr)
 {
@@ -200,8 +193,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 	ASSERT_EQ(pfn_flags & KPF_HWPOISON, KPF_HWPOISON);
 }
 
-static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
-		    void *vaddr)
+static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self)
 {
 	unsigned long size;
 	uint64_t pfn_flags;
@@ -217,6 +209,16 @@ static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failu
 	ASSERT_EQ(size, self->corrupted_size);
 }
 
+FIXTURE_TEARDOWN(memory_failure)
+{
+	if (self->triggered)
+		cleanup(_metadata, self);
+
+	close(self->kpageflags_fd);
+	close(self->pagemap_fd);
+	teardown_sighandler();
+}
+
 TEST_F(memory_failure, anon)
 {
 	char *addr;
@@ -242,8 +244,6 @@ TEST_F(memory_failure, anon)
 	else
 		check(_metadata, self, addr, MADV_SOFT_ANON, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
@@ -309,8 +309,6 @@ TEST_F(memory_failure, clean_pagecache)
 	else
 		check(_metadata, self, addr, MADV_SOFT_CLEAN_PAGECACHE, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
 	ASSERT_EQ(close(fd), 0);
@@ -358,8 +356,6 @@ TEST_F(memory_failure, dirty_pagecache)
 	else
 		check(_metadata, self, addr, MADV_SOFT_DIRTY_PAGECACHE, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
 	ASSERT_EQ(close(fd), 0);
-- 
2.47.3


