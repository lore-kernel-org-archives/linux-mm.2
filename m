Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D3FCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10AB66B00F6; Fri, 29 May 2026 13:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF156B00F9; Fri, 29 May 2026 13:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73B36B00F6; Fri, 29 May 2026 13:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC25F6B00F6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:28:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EBE1A0249
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:15 +0000 (UTC)
X-FDA: 84821140950.28.D6E68D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 81AD32000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ljUaxZEa;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhHhE0AQrKlVLBggXJvX1A2KMhQJOt0DmZdnuqiw3VQ=;
	b=v5DvfaHqQBglzIKT+XRyIzmJpC0oPoY8Ilc0F6y2sEBEazOAGpYJ66wjHVgY8tFXM+pC5c
	AHmmbpSOr8GoDkl9A56ct+gMm3ONV4k3HEqoTgzDnd+JcMLkxOD6yCibTI3xynuWCwtkCo
	BQ52/5fNfdmjkI4VzGyWw71OrynhnRA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075693; a=rsa-sha256;
	cv=none;
	b=fTQWVueYE2KQeuE0cT7JGPAQcgGf6P32GqHxjnCKDf8q2zTF++QTriOxtKagRbqZ8E2+yz
	TriF0Mv8LsqLmeWO1JqLCS+v5UJEYqbmw+fkyfCXdMBhOW4Z3gfhC8rcbpM0IaVllgOu+z
	Zls0/Nd/RdcIRZoJOUbjNgAkZGjgIbM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ljUaxZEa;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A440642A40;
	Fri, 29 May 2026 17:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB44D1F0089B;
	Fri, 29 May 2026 17:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075692;
	bh=HhHhE0AQrKlVLBggXJvX1A2KMhQJOt0DmZdnuqiw3VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljUaxZEa+08agKK3MuSVhkapXfgigLbEqKFfqCyEWQnSiza2JwQzVScvvBd/rcxL2
	 WTYV9GslTApBfARYmPNX6JFzlWjM3jmvS58Dq5jB6PPKEm3aX1s595ItvgJ3InZcWJ
	 CnIUAOhhpRnX+xu2vpR7fLDa67mqFB/4HtQ5letg/sdNQ+GR7Ycgr94sxNk8EogUIs
	 9gAmgiKjoN/MILYV+10m/cMJidFV/Ytelk5hk2ZjTAZLoafi6pXgeT5ti0LhKx9LHd
	 TqNXm/AKn89E7Sdv6h8snPnsy7ExJ3STYVpdD7x4YW2zvd/jLlV8OvbyaK9jAsc9YD
	 bwWSnu7Tq4daw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4BFB2F4006F;
	Fri, 29 May 2026 13:28:10 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 29 May 2026 13:28:10 -0400
X-ME-Sender: <xms:qswZao75OlmQDh3Dyff1EsaAX8hSVrRnIgq3h882AU41rewxwieBgA>
    <xme:qswZat0cZPty-cg1JPDTIB4ZD20MhyHQiDEVUtvFHyAMwa4R8PYQhlItUjN79CW_k
    3M4rDxy6VVxLg4zZSKsWGqI2cWiLW8T2Ekt8CfkchSVBSyjkpEC0npZ>
X-ME-Received: <xmr:qswZav8XCIYaveTHcm3NtdV65_WEiMeKe3P_9m4N3NFpEwGdyL7FWIrmwYoI6A>
X-ME-Proxy-Cause: dmFkZTEHS1Z+n1S80q4BaszFx9bNnHLQ6sgL6J9HpxOFXRfFtKsh6le5cKxaCZzZ/qH/SJ
    zONNCxWzVoPiQhYsD9dliy9AdrB2UY/Bhb82egQk/l96x3r4UUhrX92dr53s7Ptki96Mx4
    DvJi8H/xrcKSa4upwFZAuWyRsvkJtw5DUL41fEdJBQDb5TWXZV3TgknVzb3pm5Cw5eabt3
    ZKinBz9XCIvsS/RAa3Cb6hoIPIA7Rb0ceUklQcqu2F89W2umMVSE8bbF5HocBMl20u4Nxk
    92MelAoY5r8qDI90ESLS21z7KfMewjRnztTxCHQfAtq0f2Qz4D8wiVPs5MI39B39+ARIGQ
    toaraB83DZx1MKp+787umVvzqQ2JbE75vd7MUy4ysmmk+rBYxtaH0RARCKQxF2G61VQFcl
    4inWZRnDnejvmYWqFrPurcEl2AofQYWk4MAZKCjclffwtiL3qKxOwXiKafPBG6FFPEk5iY
    8mnG0IZh5IBljh08tJgvamBAq0+l2mOTMpgzlBqvc90Kf2uhL4XBwf4P0aLced5sKbCmfC
    o0p/KGJdrxNuYB+ocWMFBbRP8FJEyCF6ZG8j9rzl2AAyb1d7pReB3MzwVE+Cx4bjWuHIzA
    wTNqhnIg5px5TYEeePqdtv0SYg4BxxNh61FF+PAhpHqt2/2A56AxMf0q3JZQ
X-ME-Proxy: <xmx:qswZamti8QmaiZBP1niWdYwKNfqQY8Z07AL2vb5A4m_tXljpTGmLVQ>
    <xmx:qswZajpcn20ifT7aG69dpTOzv2FNF--1pKCdtcV0KwIzb51OMcdykg>
    <xmx:qswZapFydyr0yvUS_neP5hHFNhwc6eJDyP4_zkrKkCmlkpw7d14LTA>
    <xmx:qswZau4zZxGrR-UE7gdXi_Q98p60ecg-fIeTJ2TeoJx4jUwqwhJUYA>
    <xmx:qswZakAfo71ILsXnV-lHCgDWT2PD6xKQGQsmM2lrHMO35O6U-uwXEutK>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:28:09 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v6 14/15] selftests/mm: add userfaultfd RWP tests
Date: Fri, 29 May 2026 18:26:43 +0100
Message-ID: <20260529172716.357179-15-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 81AD32000A
X-Stat-Signature: fj5ofmn97rjmi3fiidb34s73k55bt5jt
X-Rspamd-Server: rspam06
X-HE-Tag: 1780075693-81098
X-HE-Meta: U2FsdGVkX1+JKU/MMleHF7TRSg8QaGxz3UazH+amDQVdaJRYr0Lh3hHSwc55EmIfU9r0SKXGAfISk5lU116aei+mwTLUJpdd3cv5I9bNCISltThCK9DECbfX3yZbT3v5ZGRFskXJdGsqUuQIWfzABSPnXAo69/4qAh1mHaZtraEQQbsy/d6dyYm11/HXIX7PsfmWYw9eTwf0c5kRg0ADrdHGYXUSfzrP0/kkTsuV49LBqDAnhogzEqi6O7mETzkg4Ue2skqHQtZcvU8YHXts9IZCtq1p7mXPZVq5UJhn+7yP1iQhQpSsh6LQVhhJUJ6/LY8iCfAgOl+jB3W7CB8Yt/yh8YO020WzOr5J7hP/cfssZyo3FR0AQg2yoi7YZZhFAWrc4tP/M1y8+gva/fTOkUXaacF7wP0PcER+A8uYe2lE35RcdUbnbIsbh3jE/P7N9Jd7F/rZnR9dxNM8pgedEZe9GUnOaiZg1O3YA/DIFSsAlhBNaS5A8hiVnnO5plDBVA1qoVcEEn0QPhJ4FKWXBpu0S/1t77uzhTTVE9vXWQZCDFKxJCIk8W2ysQke/aMsY8vaYeNLCx9I9f78VDre4ixq6ddl8zky9wQqAfqrmJPEHdtTOI9ZvaHKl7/wVsNUCqXC9+dE3mv8HOh2sTxQ/o7lwiwfgW8YA9VbH/2cJODp0G+ZFg2MIvoB7emk+pm9FADcdleiApkg3JwD+bzWqiUriQyyUZNtszGni5Szul2LWsJJwNSeI9NiYf/Zkar15QXg7ZdvS5Hb4w7r6FSqjD+IJuW6FvdBOxqLs/j4vhL3GrdiDvb6s4j06VQLd0ccrapMAOjWA6bSJaQer0RMPLrqaHaJHz9c0A15k/jJLwTBRH9Rd1m7zCpHKRufGkZ1DeorcwcySWehF6TmYXCrF/rBr5Gqspod1Z7p8BNTzm4/gDDze6530K81zmorURVhm4shUz+/XT/qtCkCqzn
 mmZgollJ
 k8bWIsPc03zkPhRPXWGHIMm81AgqyylB9dHTPTWYR/UlXuz8ObD4SFeFqUG1hnP1JPetLD0mxrVZLpXCPgozO8uJFNPoTrKRVWCU51f/5gnlbGtM/Fo2iyZdkdO3LtfAtRPWRmuDZKHD1cOxToe5LzglDT51mmwVh3VZSsU6WtFQRXy4m3Fe24AoBQZ/+kc/k+X9pJF9+t8Qklbz3wZFtBAk0Xu/+3pmrnuXz+cuyC2DuKnjLokMEToW1c59kOTxOxTHEi4VFhHCdWnnnPzIGDq/2e9AeMlDzk3B/ll8ZKUimxS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Coverage for UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT:

  rwp-async          async mode — touch pages, verify permissions are
                     auto-restored without a message
  rwp-sync           sync mode — access blocks, handler resolves via
                     UFFDIO_RWPROTECT
  rwp-pagemap        PAGEMAP_SCAN reports still-cold pages via
                     inverted PAGE_IS_ACCESSED
  rwp-mprotect       RWP survives mprotect(PROT_NONE) ->
                     mprotect(PROT_READ|PROT_WRITE) round-trip
  rwp-gup            GUP walks through a protnone RWP PTE (pipe
                     write/read drives the GUP path)
  rwp-async-toggle   UFFDIO_SET_MODE flips between sync and async
                     without re-registering
  rwp-close          closing the uffd restores page permissions
  rwp-fork           RWP survives fork() with EVENT_FORK; child's
                     PTEs keep the uffd bit
  rwp-fork-pin       RWP survives fork() on an RO-longterm-pinned
                     anon page (forces copy_present_page()); child
                     read auto-resolves and clears the bit, proving
                     PAGE_NONE was in place
  rwp-wp-exclusive   register with MODE_WP|MODE_RWP returns -EINVAL

All tests run against anon, shmem, shmem-private, hugetlb, and
hugetlb-private memory, except rwp-fork-pin which is anon-only —
copy_present_page() is the private-anon pinned-exclusive fork path.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 765 +++++++++++++++++++
 1 file changed, 765 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index a6c14109e818..9f5a5ccf6044 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -7,6 +7,8 @@
 
 #include "uffd-common.h"
 
+#include <linux/fs.h>
+#include <sys/uio.h>
 #include "../../../../mm/gup_test.h"
 
 #ifdef __NR_userfaultfd
@@ -109,6 +111,10 @@ static void uffd_test_skip(const char *message)
 
 static void test_uffd_api(bool use_dev)
 {
+	const uint64_t expected_ioctls =
+		BIT_ULL(_UFFDIO_REGISTER) |
+		BIT_ULL(_UFFDIO_UNREGISTER) |
+		BIT_ULL(_UFFDIO_API);
 	struct uffdio_api uffdio_api;
 	int uffd;
 
@@ -148,6 +154,15 @@ static void test_uffd_api(bool use_dev)
 		goto out;
 	}
 
+	/* Verify returned fd-level ioctls bitmask */
+	if ((uffdio_api.ioctls & expected_ioctls) != expected_ioctls) {
+		uffd_test_fail("UFFDIO_API missing expected ioctls: "
+			       "got=0x%"PRIx64", expected=0x%"PRIx64,
+			       (uint64_t)uffdio_api.ioctls,
+			       expected_ioctls);
+		goto out;
+	}
+
 	/* Test double requests of UFFDIO_API with a random feature set */
 	uffdio_api.features = BIT_ULL(0);
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == 0) {
@@ -602,6 +617,685 @@ void uffd_minor_collapse_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *
 	uffd_minor_test_common(gopts, true, false);
 }
 
+static int uffd_register_rwp(int uffd, void *addr, uint64_t len)
+{
+	struct uffdio_register reg = {
+		.range = { .start = (unsigned long)addr, .len = len },
+		.mode = UFFDIO_REGISTER_MODE_RWP,
+	};
+
+	if (ioctl(uffd, UFFDIO_REGISTER, &reg) == -1)
+		return -errno;
+	return 0;
+}
+
+static void rwprotect_range(int uffd, __u64 start, __u64 len, bool protect)
+{
+	struct uffdio_rwprotect rwp = {
+		.range = { .start = start, .len = len },
+		.mode = protect ? UFFDIO_RWPROTECT_MODE_RWP : 0,
+	};
+
+	if (ioctl(uffd, UFFDIO_RWPROTECT, &rwp))
+		err("UFFDIO_RWPROTECT failed");
+}
+
+static void set_async_mode(int uffd, bool enable)
+{
+	struct uffdio_set_mode mode = { };
+
+	if (enable)
+		mode.enable = UFFD_FEATURE_RWP_ASYNC;
+	else
+		mode.disable = UFFD_FEATURE_RWP_ASYNC;
+
+	if (ioctl(uffd, UFFDIO_SET_MODE, &mode))
+		err("UFFDIO_SET_MODE failed");
+}
+
+/*
+ * Test async RWP faults on anonymous memory.
+ * Populate pages, register MODE_RWP with RWP_ASYNC,
+ * RW-protect, re-access, verify content preserved and no faults delivered.
+ */
+static void uffd_rwp_async_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+
+	/* Populate all pages with known content */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	/* Register MODE_RWP */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	/* RW-protect all pages (sets protnone) */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Access all pages — should auto-resolve, no faults */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+		unsigned char expected = p % 255 + 1;
+
+		if (page[0] != expected) {
+			uffd_test_fail("page %lu content mismatch: %u != %u",
+				       p, page[0], expected);
+			return;
+		}
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Fault handler for RWP — unprotect the page via UFFDIO_RWPROTECT.
+ */
+static void uffd_handle_rwp_fault(uffd_global_test_opts_t *gopts,
+				  struct uffd_msg *msg,
+				  struct uffd_args *uargs)
+{
+	if (!(msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_RWP))
+		err("expected RWP fault, got 0x%llx",
+		    msg->arg.pagefault.flags);
+
+	rwprotect_range(gopts->uffd, msg->arg.pagefault.address,
+			gopts->page_size, false);
+	uargs->minor_faults++;
+}
+
+/*
+ * Test sync RWP faults on anonymous memory.
+ * Populate pages, register MODE_RWP (sync), RW-protect,
+ * access from worker thread, verify fault delivered, UFFDIO_RWPROTECT resolves.
+ */
+static void uffd_rwp_sync_test(uffd_global_test_opts_t *gopts,
+				      uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	pthread_t uffd_mon;
+	struct uffd_args uargs = { };
+	bool failed = false;
+	char c = '\0';
+	unsigned long p;
+
+	uargs.gopts = gopts;
+	uargs.handle_fault = uffd_handle_rwp_fault;
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	/* Register MODE_RWP */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	/* RW-protect all pages */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Start fault handler thread */
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
+		err("uffd_poll_thread create");
+
+	/* Access all pages — triggers sync RWP faults, handler unprotects */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+
+		if (page[0] != (p % 255 + 1)) {
+			uffd_test_fail("page %lu content mismatch", p);
+			failed = true;
+			goto out;
+		}
+	}
+
+out:
+	/*
+	 * Stop the handler before reading minor_faults: the last fault
+	 * resolution rwprotect_range()s before incrementing the counter,
+	 * so the main thread can race ahead of the increment.
+	 */
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (failed)
+		return;
+	if (uargs.minor_faults == 0)
+		uffd_test_fail("expected RWP faults, got 0");
+	else
+		uffd_test_pass();
+}
+
+/*
+ * Test PAGEMAP_SCAN detection of RW-protected (cold) pages.
+ */
+static void uffd_rwp_pagemap_test(uffd_global_test_opts_t *gopts,
+					  uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+	struct page_region regions[16];
+	struct pm_scan_arg pm_arg;
+	int pagemap_fd;
+	long ret;
+
+	/* Need at least 4 pages */
+	if (nr_pages < 4) {
+		uffd_test_skip("need at least 4 pages");
+		return;
+	}
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, 0xab, page_size);
+
+	/* Register and RW-protect */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Touch first half of pages to re-activate them (async auto-resolve) */
+	for (p = 0; p < nr_pages / 2; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	/* Scan for cold (still RW-protected) pages */
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		err("open pagemap");
+
+	/*
+	 * PAGE_IS_ACCESSED is set once the uffd-wp bit has been cleared
+	 * (access happened, or the user resolved). Invert it to select
+	 * still-protected (cold) pages.
+	 */
+	memset(&pm_arg, 0, sizeof(pm_arg));
+	pm_arg.size = sizeof(pm_arg);
+	pm_arg.start = (uint64_t)gopts->area_dst;
+	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
+	pm_arg.vec = (uint64_t)regions;
+	pm_arg.vec_len = ARRAY_SIZE(regions);
+	pm_arg.category_mask = PAGE_IS_ACCESSED;
+	pm_arg.category_inverted = PAGE_IS_ACCESSED;
+	pm_arg.return_mask = PAGE_IS_ACCESSED;
+
+	ret = ioctl(pagemap_fd, PAGEMAP_SCAN, &pm_arg);
+	close(pagemap_fd);
+
+	if (ret < 0) {
+		uffd_test_fail("PAGEMAP_SCAN failed: %s", strerror(errno));
+		return;
+	}
+
+	/*
+	 * The second half of pages should be reported as RW-protected.
+	 * They may be coalesced into one region.
+	 */
+	if (ret < 1) {
+		uffd_test_fail("expected cold pages, got %ld regions", ret);
+		return;
+	}
+
+	/* Verify the cold region covers the second half */
+	uint64_t cold_start = regions[0].start;
+	uint64_t expected_start = (uint64_t)gopts->area_dst +
+				  (nr_pages / 2) * page_size;
+
+	if (cold_start != expected_start) {
+		uffd_test_fail("cold region starts at 0x%lx, expected 0x%lx",
+			       (unsigned long)cold_start,
+			       (unsigned long)expected_start);
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Test that RWP protection survives a mprotect(PROT_NONE) ->
+ * mprotect(PROT_READ|PROT_WRITE) round-trip. The uffd-wp bit on a
+ * VM_UFFD_RWP VMA must continue to carry PROT_NONE semantics after
+ * mprotect() changes the base protection; otherwise accesses would
+ * silently succeed and the pagemap bit would stick without a fault
+ * ever clearing it.
+ */
+static void uffd_rwp_mprotect_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+	struct page_region regions[16];
+	struct pm_scan_arg pm_arg;
+	int pagemap_fd;
+	long ret;
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, 0xab, page_size);
+
+	/* Register and RW-protect the whole range */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			      nr_pages * page_size))
+		err("register failure");
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			nr_pages * page_size, true);
+
+	/* Round-trip mprotect(): PROT_NONE -> PROT_READ|PROT_WRITE */
+	if (mprotect(gopts->area_dst, nr_pages * page_size, PROT_NONE))
+		err("mprotect() PROT_NONE");
+	if (mprotect(gopts->area_dst, nr_pages * page_size,
+		     PROT_READ | PROT_WRITE))
+		err("mprotect() PROT_READ|PROT_WRITE");
+
+	/* Touch every page. Async RWP must auto-resolve each fault. */
+	for (p = 0; p < nr_pages; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	/*
+	 * After touching, no page should remain RW-protected. A stuck
+	 * uffd-wp bit would mean mprotect() silently dropped PROT_NONE and
+	 * the access never faulted.
+	 */
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		err("open pagemap");
+
+	memset(&pm_arg, 0, sizeof(pm_arg));
+	pm_arg.size = sizeof(pm_arg);
+	pm_arg.start = (uint64_t)gopts->area_dst;
+	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
+	pm_arg.vec = (uint64_t)regions;
+	pm_arg.vec_len = ARRAY_SIZE(regions);
+	pm_arg.category_mask = PAGE_IS_ACCESSED;
+	pm_arg.category_inverted = PAGE_IS_ACCESSED;
+	pm_arg.return_mask = PAGE_IS_ACCESSED;
+
+	ret = ioctl(pagemap_fd, PAGEMAP_SCAN, &pm_arg);
+	close(pagemap_fd);
+
+	if (ret < 0) {
+		uffd_test_fail("PAGEMAP_SCAN failed: %s", strerror(errno));
+		return;
+	}
+	if (ret != 0) {
+		uffd_test_fail("expected no cold pages after mprotect()+touch, got %ld regions",
+			       ret);
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Test that GUP resolves through protnone PTEs (async mode).
+ * vmsplice() into a pipe pins user pages via get_user_pages_fast() --
+ * unlike write(), which goes through copy_from_user() and ordinary
+ * hardware page faults -- so it exercises gup_can_follow_protnone() on
+ * the RW-protected PTE. In async mode the kernel auto-restores
+ * permissions and GUP returns the page.
+ */
+static void uffd_rwp_gup_test(uffd_global_test_opts_t *gopts,
+				     uffd_test_args_t *args)
+{
+	struct iovec iov;
+	char buf;
+	int pipefd[2];
+
+	/* Populate first page with known content */
+	memset(gopts->area_dst, 0xCD, gopts->page_size);
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, gopts->page_size))
+		err("register failure");
+
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			gopts->page_size, true);
+
+	if (pipe(pipefd))
+		err("pipe");
+
+	/*
+	 * One byte's worth of iov is enough to GUP the containing page and
+	 * keeps the pipe transfer well under any pipe-capacity limit even on
+	 * hugetlb-backed runs.
+	 */
+	iov.iov_base = gopts->area_dst;
+	iov.iov_len = 1;
+	if (vmsplice(pipefd[1], &iov, 1, 0) != 1) {
+		uffd_test_fail("vmsplice from RW-protected page failed: %s",
+			       strerror(errno));
+		goto out;
+	}
+
+	if (read(pipefd[0], &buf, 1) != 1) {
+		uffd_test_fail("read from pipe failed");
+		goto out;
+	}
+
+	if (buf != (char)0xCD) {
+		uffd_test_fail("content mismatch: got 0x%02x, expected 0xCD",
+			       (unsigned char)buf);
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	close(pipefd[0]);
+	close(pipefd[1]);
+}
+
+/*
+ * Test runtime toggle between async and sync modes.
+ * Start in async mode (detection), flip to sync (eviction), verify faults
+ * block, resolve them, flip back to async.
+ */
+static void uffd_rwp_async_toggle_test(uffd_global_test_opts_t *gopts,
+					      uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	struct uffd_args uargs = { };
+	pthread_t uffd_mon;
+	char c = '\0';
+	unsigned long p;
+
+	uargs.gopts = gopts;
+	uargs.handle_fault = uffd_handle_rwp_fault;
+
+	/* Populate */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	/* Phase 1: async detection — RW-protect, access first half */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	for (p = 0; p < nr_pages / 2; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;  /* auto-resolves in async mode */
+	}
+
+	/* Phase 2: flip to sync for eviction */
+	set_async_mode(gopts->uffd, false);
+
+	/* Start handler — will receive faults for cold pages */
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
+		err("uffd_poll_thread create");
+
+	/* Access second half (cold pages) — should trigger sync faults */
+	for (p = nr_pages / 2; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+		if (page[0] != (p % 255 + 1)) {
+			uffd_test_fail("page %lu content mismatch", p);
+			goto out;
+		}
+	}
+
+	/*
+	 * Stop the handler before reading minor_faults: the last fault
+	 * resolution rwprotect_range()s before incrementing the counter,
+	 * so the main thread can race ahead of the increment. Stopping
+	 * here also makes Phase 3 a clean async-only test -- with the
+	 * handler still running it would silently resolve any sync fault
+	 * the kernel erroneously delivers, masking a regression.
+	 */
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (uargs.minor_faults == 0) {
+		uffd_test_fail("expected sync faults, got 0");
+		return;
+	}
+
+	/* Phase 3: flip back to async */
+	set_async_mode(gopts->uffd, true);
+
+	/* RW-protect and access again — should auto-resolve */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	for (p = 0; p < nr_pages; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	uffd_test_pass();
+	return;
+out:
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+}
+
+/*
+ * Test that RW-protected pages become accessible after closing uffd.
+ */
+static void uffd_rwp_close_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+
+	/* Populate */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Close uffd — should restore protnone PTEs */
+	close(gopts->uffd);
+	gopts->uffd = -1;
+
+	/* All pages should be accessible with original content */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+		unsigned char expected = p % 255 + 1;
+
+		if (page[0] != expected) {
+			uffd_test_fail("page %lu not accessible after close", p);
+			return;
+		}
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Test that RWP protection is preserved across fork() when
+ * UFFD_FEATURE_EVENT_FORK is enabled. Without preservation, the child's
+ * PTEs would lose the uffd-wp marker and RWP-protected accesses would
+ * silently fall through to do_numa_page().
+ */
+static void uffd_rwp_fork_test(uffd_global_test_opts_t *gopts,
+			       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	int pagemap_fd;
+	uint64_t value;
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			      nr_pages * page_size))
+		err("register failed");
+
+	/* Populate + RWP-protect */
+	*gopts->area_dst = 1;
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			page_size, true);
+
+	/* Parent: verify uffd-wp bit is set before fork */
+	pagemap_fd = pagemap_open();
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	pagemap_check_wp(value, true);
+
+	/*
+	 * Fork with EVENT_FORK: child inherits VM_UFFD_RWP. Child reads
+	 * its own pagemap and must still see the uffd-wp bit set.
+	 */
+	if (pagemap_test_fork(gopts, true, false)) {
+		uffd_test_fail("RWP marker lost in child after fork");
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	close(pagemap_fd);
+}
+
+/*
+ * Test that RWP protection on a pinned anon page is preserved across fork().
+ * Pinning forces copy_present_page() in the child path, which must restore
+ * PAGE_NONE on top of the uffd bit. Using async mode, a read in the child
+ * auto-resolves if — and only if — the PTE was actually protnone+uffd; the
+ * cleared uffd bit afterward proves the fault path ran.
+ */
+static void uffd_rwp_fork_pin_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *args)
+{
+	unsigned long page_size = gopts->page_size;
+	fork_event_args fevent_args = { .gopts = gopts, .child_uffd = -1 };
+	pin_args pin_args = {};
+	int pagemap_fd, status;
+	pthread_t fevent_thread;
+	uint64_t value;
+	pid_t child;
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, page_size))
+		err("register failed");
+
+	/* Populate. */
+	*gopts->area_dst = 1;
+
+	/* RO-longterm pin so fork() takes copy_present_page() for this PTE. */
+	if (pin_pages(&pin_args, gopts->area_dst, page_size)) {
+		uffd_test_skip("Possibly CONFIG_GUP_TEST missing or unprivileged");
+		uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+		return;
+	}
+
+	/* RWP-protect: PTE is now PAGE_NONE + uffd bit. */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
+
+	pagemap_fd = pagemap_open();
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	pagemap_check_wp(value, true);
+
+	/*
+	 * UFFD_FEATURE_EVENT_FORK is required so the child inherits
+	 * VM_UFFD_RWP and the marker; without it dup_userfaultfd() resets
+	 * the child VMA and the test would pass for the wrong reason.
+	 * dup_userfaultfd() blocks until the EVENT_FORK message is consumed,
+	 * so spawn a reader before the fork().
+	 */
+	gopts->ready_for_fork = false;
+	if (pthread_create(&fevent_thread, NULL, fork_event_consumer,
+			   &fevent_args))
+		err("pthread_create() for fork event consumer");
+	while (!gopts->ready_for_fork)
+		; /* Wait for consumer to start polling. */
+
+	child = fork();
+	if (child < 0)
+		err("fork");
+	if (child == 0) {
+		volatile char c;
+		int cfd;
+
+		/*
+		 * Read the pinned page. Only reaches the fault path if the
+		 * child PTE is protnone + uffd; async mode auto-resolves and
+		 * clears the uffd bit. If copy_present_page() dropped
+		 * PAGE_NONE, the read would silently succeed and the bit
+		 * would still be set.
+		 */
+		c = *(volatile char *)gopts->area_dst;
+		(void)c;
+
+		cfd = pagemap_open();
+		value = pagemap_get_entry(cfd, gopts->area_dst);
+		close(cfd);
+		_exit((value & PM_UFFD_WP) ? 1 : 0);
+	}
+	if (waitpid(child, &status, 0) < 0)
+		err("waitpid");
+	if (pthread_join(fevent_thread, NULL))
+		err("pthread_join() for fork event consumer");
+	if (fevent_args.child_uffd >= 0)
+		close(fevent_args.child_uffd);
+
+	unpin_pages(&pin_args);
+	close(pagemap_fd);
+	if (uffd_unregister(gopts->uffd, gopts->area_dst, page_size))
+		err("unregister failed");
+
+	if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
+		uffd_test_fail("RWP not enforced in child after pinned fork");
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * WP and RWP share the uffd-wp PTE bit and cannot coexist in the same VMA.
+ * Registration requesting both modes must be rejected.
+ */
+static void uffd_rwp_wp_exclusive_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	struct uffdio_register reg = { };
+
+	reg.range.start = (unsigned long)gopts->area_dst;
+	reg.range.len = nr_pages * page_size;
+	reg.mode = UFFDIO_REGISTER_MODE_WP | UFFDIO_REGISTER_MODE_RWP;
+
+	if (ioctl(gopts->uffd, UFFDIO_REGISTER, &reg) == 0) {
+		uffd_test_fail("register with WP|RWP unexpectedly succeeded");
+		return;
+	}
+	if (errno != EINVAL) {
+		uffd_test_fail("register with WP|RWP: expected EINVAL, got %d",
+			       errno);
+		return;
+	}
+	uffd_test_pass();
+}
+
 static sigjmp_buf jbuf, *sigbuf;
 
 static void sighndl(int sig, siginfo_t *siginfo, void *ptr)
@@ -1604,6 +2298,77 @@ uffd_test_case_t uffd_tests[] = {
 		/* We can't test MADV_COLLAPSE, so try our luck */
 		.uffd_feature_required = UFFD_FEATURE_MINOR_SHMEM,
 	},
+	{
+		.name = "rwp-async",
+		.uffd_fn = uffd_rwp_async_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-sync",
+		.uffd_fn = uffd_rwp_sync_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_RWP,
+	},
+	{
+		.name = "rwp-pagemap",
+		.uffd_fn = uffd_rwp_pagemap_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-mprotect",
+		.uffd_fn = uffd_rwp_mprotect_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-gup",
+		.uffd_fn = uffd_rwp_gup_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-async-toggle",
+		.uffd_fn = uffd_rwp_async_toggle_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-close",
+		.uffd_fn = uffd_rwp_close_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_RWP,
+	},
+	{
+		.name = "rwp-fork",
+		.uffd_fn = uffd_rwp_fork_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_EVENT_FORK,
+	},
+	{
+		.name = "rwp-fork-pin",
+		.uffd_fn = uffd_rwp_fork_pin_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC |
+		UFFD_FEATURE_EVENT_FORK,
+	},
+	{
+		.name = "rwp-wp-exclusive",
+		.uffd_fn = uffd_rwp_wp_exclusive_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP |
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
+	},
 	{
 		.name = "sigbus",
 		.uffd_fn = uffd_sigbus_test,
-- 
2.54.0


