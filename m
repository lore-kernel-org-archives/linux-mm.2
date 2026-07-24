Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF1C3C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4B96B0092; Fri, 24 Jul 2026 18:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD0E6B0095; Fri, 24 Jul 2026 18:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B2D6B009B; Fri, 24 Jul 2026 18:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF9A76B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49E3B1401AA
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:18 +0000 (UTC)
X-FDA: 85025114916.26.C0661DA
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id B9064100002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=lDGkdWSg;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phv1B9Yxat6YIEopEPUTNjYYzL54eFSY9r4GoCdruM0=;
	b=HXzl4qBjubUdCYT0RSymQAOUWr/uNQllqxNMkomGNjc1RPPT3aD3wO1Bi7G1bVnE69ESfS
	H526Zo2GOuZ9vroR5OGMzOBG1YiIwf1sF63nRKVMmUAYT6BERO8QngCGpONtYzoZetcoAQ
	6I+Gaz60KCxQ6i4lstHfjgezYeQgCqo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=lDGkdWSg;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932216;
	b=W3+9xS0sBIqeAf/OpISXDl6GFCjZEjCyx5Nu4SE8neePP19b0tyq+LOO6LlMgnLOG41MMf
	T0Ohz8NYR/ybZ9BWUV56eCuSznjfEU/ePz/+Lyi8zToCAOX/5mmK8jEiJQMHU7ZR0diiip
	Hx+3S1YhDKYTyHfOVSgkzvSR+pxNJwc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=phv1B9Yxat6YIEopEPUTNjYYzL54eFSY9r4GoCdruM0=; b=lDGkdWSgenq2WUBSSLwgIoU2bb
	iq5fO5pwGwjNj4bxQlt4EaiKdpGhKGWYtAlH8V4HscBe+rLdz3LpbJ1rz4Eo+8VHi5Cf2YozwpoKa
	/EOf7b6Fj1trVqdHRewh1VGmUqt2Uelwy48tNNXJNpUrXhxN2zVXjdupFpQVDCV2E7dnQLmXL8+iR
	L2uoBhWRMCi66UhaWFlC12UuNvV8vGwQzSm9dIYb5f6FEjYNYvE+3V+Vz3IqDYqTDL0zb61Ac86UM
	/peYQvZJXj0L62/5Os+HC3VsJDdWWxk6zGgLEgSYvF8x6yeOIqsGogSrLBPrd15tBYdhgtMl7L8QJ
	6fXo9UZA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-1kjG;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC v4 08/12] selftests/mm: cover /proc/pid/mem access to VM_PFNMAP memory
Date: Fri, 24 Jul 2026 18:29:30 -0400
Message-ID: <20260724222934.1463812-9-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9064100002
X-Rspam-User: 
X-Stat-Signature: 7ozyxtoj9qkrdcsobpobnuc3x7eg7qga
X-HE-Tag: 1784932216-294135
X-HE-Meta: U2FsdGVkX1+IZST1Uwx0uWIPQvIKayGx9PKNtBwTSVRDPiQoaDnYBCqktmkN5nIjt5qzxednR3gLo4rPCtbLybgjLgJEQnvZId0wbLbj/AfrE/9DUlVWQM18qZTw0TUwZ+8cAELXwTO1q4dU7l1b+Vw+kLoG+c5R3F7BsjhA9adQKgQTbkbJfUuHcMS3XkL3hF6c3chKIO8EXgPwEhyWayAt3Q/cHCCDBjncOlOBF5pcehWZfOLrn3Gc5L5J6kO32P80vwEygiOJiE1UJPdhaAB0lZj6ckSd7t+rxg0CE1vnb94TEaDxWbKtjPZ8SEs5JMTThoHTAkl6nKGjhhPix24zMXLgFfB8Hzevu8hINBUIyHzxli5zvCRPeloiqqBmCvDvYeEX70C1uVyjdzaNl3/TAjhYM3uxFEOvm6RWi2K9Vr6UfC6pmTopEkQcwA6s/T8unnVJiTSAEe1IBUcOQTg30DHKQd6LkG7qxfaJRTfI3M4lVz899Hk03RjJNHmyTnWWkDk/0eU3xgyUMVihrz+YqSAmT5/5UvmReW3p9gVx8+PubVYRFxz2kHpSR178DSnWV+iGt2jrr2g2cVlTSUwgAum1wDtP5YiLqz6HcftJYipfzoUiDYQ+XE0OZpeTvbClRi4Kruac/VZn5QJ8yanm/5SAUF6qGYJBZDpBPqHsyixKGxEvvwalPs8JH9+mCcp3wTxblzxoIAEGvhykdReNXc3lDKFq5FkT+e1ywG9of3evwTrI6bx1Hf4K/Hy6OsE7S8fG8jy92YoQUaTCQnBFo+7s475aGFFIPhPUqENsyDO9p2hOMIqIDczq2zJQlVRfGW5ALvKGS38vlDr3NXZRKZ8XfDEiURLT6hGdiNYQjxdHNcy5WjjrgsaKQ0ajS0g7e3xGZZkGCy3KGdVx3oTIS3FoKABGi+TCH7XKe4q79Ow+YwzKKJeJhqnyQ53IZ+pu9JIK8atw4MUkJO6
 F+r0qsJA
 8QP+bWzjwMRykZ6Co0LigU58QhvFqpZdNw6niIPHTl7mTJLr1/VCrnjZO6Reo5hB2aXh1/a/nZmCadrETRJqQtV6AS1mw+5dl71APqYHHW+b0QmUsoyjmpNrthgt/4NB9tHf2BoaPkVcIEnhx0AFaKvLMjMFGLVRYB1hfI6/gEBe8vvsArzkzJYvw/pV3Y7fI0S0NGIFc4GtcbO+b92dmWEfs/hBeqiIiCCL8Gs9rkQ7WlgZD+Wqb6pzfyjxNL+TK3/n/2rV6ii+l79k07PZziuEfjony3jyBiCidbG54Wqcl8IeT89HUUMPl/A+5Jmh5aBvL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading a VM_PFNMAP mapping through /proc/pid/mem exercises
__access_remote_vm() two ways: a COWed page has a struct page and is
returned by get_user_page_vma(), while a raw PFN has none and is reached
through vma->vm_ops->access().

Add two tests to pfnmap.c, both reading VM_PFNMAP memory through
/proc/self/mem.

procmem_cow_read maps the file MAP_PRIVATE and writable, writes to COW a
page, then reads it back. Without the struct-page path in
get_user_page_vma() this read is short: the access falls back to
generic_access_phys(), which ioremaps the PFN, and ioremap of a COWed RAM
page is rejected.

procmem_pfn_read reads a raw PFN back through ->access(). ioremap rejects
RAM, so it runs only for genuine device memory and is skipped for the
default /dev/mem System RAM target.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 tools/testing/selftests/mm/pfnmap.c | 66 +++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
index 4f550822385a..6ff5d1029517 100644
--- a/tools/testing/selftests/mm/pfnmap.c
+++ b/tools/testing/selftests/mm/pfnmap.c
@@ -31,6 +31,7 @@ static sigjmp_buf sigjmp_buf_env;
 static char *file = "/dev/mem";
 static off_t file_offset;
 static int fd;
+static int target_is_ram;
 
 static void signal_handler(int sig)
 {
@@ -113,6 +114,7 @@ static void pfnmap_init(void)
 		if (err)
 			ksft_exit_skip("Cannot find ram target in '/proc/iomem': %s\n",
 				       strerror(-err));
+		target_is_ram = 1;
 	} else {
 		file_offset = 0;
 	}
@@ -271,6 +273,70 @@ TEST_F(pfnmap, fork)
 	ASSERT_EQ(ret, 0);
 }
 
+TEST_F(pfnmap, procmem_cow_read)
+{
+	char *priv, *buf;
+	ssize_t rc;
+	int mem_fd;
+
+	/*
+	 * A COWed page in a VM_PFNMAP mapping has a struct page, so reading it
+	 * through /proc/self/mem -- __access_remote_vm() -> get_user_page_vma()
+	 * -- returns it directly, instead of routing to vma->vm_ops->access(),
+	 * which ioremaps the PFN and cannot reach a COWed RAM page.
+	 *
+	 * Map the file MAP_PRIVATE and writable, write to COW a page into anon
+	 * memory, then read the page back through /proc/self/mem.
+	 */
+	self->size2 = self->pagesize;
+	self->addr2 = mmap(NULL, self->size2, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE, fd, file_offset);
+	if (self->addr2 == MAP_FAILED)
+		SKIP(return, "Cannot create a writable private pfnmap mapping");
+	priv = self->addr2;
+
+	/* COW the page and stamp known bytes into the anon copy. */
+	priv[0] = 0x42;
+	priv[self->pagesize - 1] = 0x24;
+
+	buf = malloc(self->pagesize);
+	ASSERT_NE(buf, NULL);
+
+	mem_fd = open("/proc/self/mem", O_RDONLY);
+	ASSERT_GE(mem_fd, 0);
+	rc = pread(mem_fd, buf, self->pagesize, (off_t)(uintptr_t)priv);
+	close(mem_fd);
+
+	ASSERT_EQ(rc, (ssize_t)self->pagesize);
+	EXPECT_EQ(buf[0], 0x42);
+	EXPECT_EQ(buf[self->pagesize - 1], 0x24);
+
+	free(buf);
+}
+
+TEST_F(pfnmap, procmem_pfn_read)
+{
+	char buf[64];
+	ssize_t rc;
+	int mem_fd;
+
+	/*
+	 * A raw PFN of a VM_IO/VM_PFNMAP mapping has no struct page, so
+	 * __access_remote_vm() reaches it through vma->vm_ops->access()
+	 * (generic_access_phys()). That ioremaps the PFN, which is rejected for
+	 * RAM, so this only applies to genuine device memory.
+	 */
+	if (target_is_ram)
+		SKIP(return, "Target is System RAM; ->access() cannot ioremap RAM");
+
+	mem_fd = open("/proc/self/mem", O_RDONLY);
+	ASSERT_GE(mem_fd, 0);
+	rc = pread(mem_fd, buf, sizeof(buf), (off_t)(uintptr_t)self->addr1);
+	close(mem_fd);
+
+	ASSERT_EQ(rc, (ssize_t)sizeof(buf));
+}
+
 int main(int argc, char **argv)
 {
 	for (int i = 1; i < argc; i++) {
-- 
2.53.0-Meta


