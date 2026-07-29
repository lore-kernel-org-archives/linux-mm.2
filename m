Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D3BAC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1576B00B4; Wed, 29 Jul 2026 09:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43D06B00B6; Wed, 29 Jul 2026 09:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BD56B00B5; Wed, 29 Jul 2026 09:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7D96B00B3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:59:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8246C140659
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:11:43 +0000 (UTC)
X-FDA: 85041246486.02.9E2A5C4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id A439F20009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:11:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HQogYakk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785316302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ymf1zGRw1ZnOa6Y87QJuudSR0+u0NhfuDbQP6UxY1XE=;
	b=UhRT0I6/gyZ6Mnzary5ey7472geyH7D2TwVxuSQj4W+7yQtiX2xU25qPFNBz6BHvE0DDT6
	uZqZeuon9z8SKE6na67DmSlUjsj65Sc/JdXZ7Izqo1PMlEK7+6QiJiwWkOBbxO8Ot3eXuB
	WpfAHpwKZhWOxwdn/NGDLoj4fYHZ0kE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HQogYakk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785316302;
	b=LolE+NEtfiHNG6FiJjLJqTHzWWf0GOZ7Reu52ROwgpQF0E899k7qoxyLVu+Vs72hApK9Km
	N1N0Q+1Dbt+b+W/+QR/1SMvT17RqIprDGAmgJlxF+QaDoLzd+FasTfBVbhp01ch5nxbNWZ
	k6G8ra4fXoRLD3rKcJWb1IBxLYUGVc0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F0EA169C;
	Wed, 29 Jul 2026 02:11:36 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 628DF3F86F;
	Wed, 29 Jul 2026 02:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785316300; bh=oNUbNk0r8yn7C9q0VD2yHlmYQNN2PE7c8SHuTfHYrLE=;
	h=From:To:Cc:Subject:Date:From;
	b=HQogYakkJHq7a/AOgN8mCAHfYWa5QINk9+nqy4BrQlz6rSqabhO3GTfB5tKFft0Ck
	 H9QdlliPn4cc8dnHt315SEahF3sLQxxa+w10y/Y/jS5kQ5qVAUepSqzHYJrIZOEobB
	 K+pK9Ai3KB8rfEv5z76nKqzzHD0vXYiKM+bh4AjU=
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
Subject: [PATCH v2] selftests/mm: unpoison pages in memory-failure teardown
Date: Wed, 29 Jul 2026 10:11:26 +0100
Message-ID: <20260729091127.1001179-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A439F20009
X-Rspam-User: 
X-Stat-Signature: 9kb4koyq5w3b1ubbjq9ts8m3sp17pe5q
X-HE-Tag: 1785316301-547782
X-HE-Meta: U2FsdGVkX18XaeIZRtED81cRPITsrN1+EdDz5mwFX6+xYWMy6AVbXL4N7v9Mi+OkIpZ947QpcXXl5e0YwruEclLNyISB6ximmPLBJyGY8gg0V6A1hHlQUTA1Fbc0ikprUi/g0hB9jqj7eTuFgal04UdpkR4JluO0rr4thUf3f1g70s6xNJTkrJoWPAdltYXIGkqTIHuorBb/T+oNlTWSbHjvMi2F66h3Qsa0yi2eO5levtukzsRYYK2EzefU9WksJDwUYSdvF8iOq9xc0h+EYzxwFvidTXzTqyd+1UsojL89zFuU+w2C+IEhLo7Zx8ovpxndNNIgJKQf/N5ewjkAN9p6jDUBW6ye3PTK9nrFm9ZTk9qZFyKFw5gH8ZZgN7jG9WtICglrTw4KMlwibpdJlXEy7/V/BkxTBCJaGtCRFcmxM1G4mDoSzDtzc1PXF5KKnX8L787HENqD1sJ0nEpnbpobzNZCCSZAxRr8AcYEHkIdasb0aVi7+77Wj3ulTif45xkfd1vapGmNXfzRatiMTPkKNQy3LjKcAaRs9HCNtpUBrQ8UvZm93uwFJnP236J/q8RDClZEuLKQsoQzO4a5BHb1tv72qYLpVuri9bWh8J4IQCNyXOraeLprqWvkDTj/rlGme508zVgTbAIuj/XhrpMWeuaQHwkIaJZ33cRIng36PWdrEp9JdX7SwOkrVTnod55rG4dYcN+DvIxE4ILD3V/einxOHLUVyOl2cv9SKwmWmzZHOwt5nH93BKoSVwIRXW4BdsqyaL8C5vyDJVegGTBPWWYr67fxK4k1To9Fh0HVHx/bFsqqQjf/oSoKYmLTvaJHocbEMvRhHZlr9kP2ZtadNDFmddIWziKXFgvJKLAX8zQV5drgdmTXfNow4TsWcfbKywBT2bUw9gsjV6gext3BDQdmhhkZU8I6Oo2q9KcQonJ/lJRdHBBwnHXE2oIyiZknyJuhBCJ312XMIRY
 VJqVvXLw
 ItGmUCIjhF0a20225zvsBnnBruDVXZp76DD57UnRgpJjQ1ntAHrkVOFKQ8Kl2L3xlG+MR91BNFBuvYFohasRaMBSHzQXSAuxaDA6ZCnD3bbFa8HXFY1YLLnF6XrTIXiOiGxGZmd1gHjChtxz8Pwu+0LyumcbGO3HmTl9zEKw2LCemRgtx7ypUTG26lHZnKhPoeyXbaw4jmcGoKKDZ9UxBtNHx2zWxMRpYP3Ig8vnsyfJVZrUj3/bdAMXIipxAONFNjS1Q100lKULVTD50jVureRXxZ9JPgL3S6rchn7VlcxnWvcvDAdDc/a4lLoyx9UV6tTf+
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
self->injection_attempted so tests that exit before injection do not try
to unpoison a page when no injection was attempted. Injection can poison
a page before returning an error or delivering SIGBUS, so teardown must
clean up after every injection attempt. This runs the existing HWPoison
and HardwareCorrupted checks on both normal and assertion-failure paths.

Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Rename triggered to injection_attempted.
- Document why teardown cleans up after every injection attempt.
---
 tools/testing/selftests/mm/memory-failure.c | 44 ++++++++++-----------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 5d00aab31f9b5..f3cb578b16096 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -46,7 +46,7 @@ FIXTURE(memory_failure)
 	unsigned long pfn;
 	int pagemap_fd;
 	int kpageflags_fd;
-	bool triggered;
+	bool injection_attempted;
 };
 
 FIXTURE_VARIANT(memory_failure)
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
@@ -217,6 +209,20 @@ static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failu
 	ASSERT_EQ(size, self->corrupted_size);
 }
 
+FIXTURE_TEARDOWN(memory_failure)
+{
+	/*
+	 * Injection may poison the page before failing or delivering SIGBUS, so
+	 * clean up after every injection attempt.
+	 */
+	if (self->injection_attempted)
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
@@ -231,8 +237,8 @@ TEST_F(memory_failure, anon)
 	prepare(_metadata, self, addr);
 
 	ret = sigsetjmp(signal_jmp_buf, 1);
-	if (!self->triggered) {
-		self->triggered = true;
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
 		ASSERT_EQ(variant->inject(self, addr), 0);
 		FORCE_READ(*addr);
 	}
@@ -242,8 +248,6 @@ TEST_F(memory_failure, anon)
 	else
 		check(_metadata, self, addr, MADV_SOFT_ANON, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
@@ -298,8 +302,8 @@ TEST_F(memory_failure, clean_pagecache)
 	prepare(_metadata, self, addr);
 
 	ret = sigsetjmp(signal_jmp_buf, 1);
-	if (!self->triggered) {
-		self->triggered = true;
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
 		ASSERT_EQ(variant->inject(self, addr), 0);
 		FORCE_READ(*addr);
 	}
@@ -309,8 +313,6 @@ TEST_F(memory_failure, clean_pagecache)
 	else
 		check(_metadata, self, addr, MADV_SOFT_CLEAN_PAGECACHE, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
 	ASSERT_EQ(close(fd), 0);
@@ -347,8 +349,8 @@ TEST_F(memory_failure, dirty_pagecache)
 	prepare(_metadata, self, addr);
 
 	ret = sigsetjmp(signal_jmp_buf, 1);
-	if (!self->triggered) {
-		self->triggered = true;
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
 		ASSERT_EQ(variant->inject(self, addr), 0);
 		FORCE_READ(*addr);
 	}
@@ -358,8 +360,6 @@ TEST_F(memory_failure, dirty_pagecache)
 	else
 		check(_metadata, self, addr, MADV_SOFT_DIRTY_PAGECACHE, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
 	ASSERT_EQ(close(fd), 0);
-- 
2.47.3


