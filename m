Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB73FB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60D16B00B1; Mon, 30 Mar 2026 06:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA306B00B3; Mon, 30 Mar 2026 06:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B346B00B4; Mon, 30 Mar 2026 06:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B35736B00B1
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:13:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 813788BFC6
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:13:03 +0000 (UTC)
X-FDA: 84602316246.16.4000E12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DDF00180011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:13:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLdJ7SF2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865581; a=rsa-sha256;
	cv=none;
	b=laPAGeZuTA32MNdenZbKO/Me3vkpowLW6nl2AwrhExU2MGqJpEd9AZB2kWB/d2S8XpEmR4
	P9WfZe2Q/1r3zJI4sJzJ+CR98Su5lzdcXa36wjfbaiF/jI5tUDRxtle2ldJzHnh9CX9gg4
	zyqWNxLA/RxoKlJLwlgRt6o3wUSUQQk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLdJ7SF2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bj/m8TNOzP7qOzavXuSIEO8AJVi44udp9x7i1Rj/N3Y=;
	b=gKY7p9ers5uZZ7JMjiI5u8KYTbO0dhWJK1+uHGnnHkdWRxcwA/CTGxRctaoMHrsOUYuQmG
	ampXb8/TprdrJx9pRhms4OQD5eP7n2qjbDgT1tgG5yL3B2p3gBAePAITZfaklL7C0LQnqP
	YYId3aMdINE2OALZj6Olde6D0PSwyzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6947F6012B;
	Mon, 30 Mar 2026 10:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC896C4CEF7;
	Mon, 30 Mar 2026 10:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865581;
	bh=vrai7iUOkplMitPBGsDeCd9GnVnwQZI906Ju/ms0Utg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLdJ7SF21kWnRDDIGtJ65jNvNC/yPFzrBLTee8qMaBWvOw5YcRqVANo/wPZlY1P+N
	 DZta0UtCRNtnQwU/023UCx6GnGjy9e9NUxTSJNPlWJ5xllr8BEDCfO0V/Pz5SAmRSd
	 42i3cH7qLRURuLVkfmjlZm9iXCkv33JAA+DafTaK5viTjhFpVsfbey9M6YvQndcHXq
	 UUfZS7pA163lnmZzSeFsudxste4NafS8WT8QCvCvhQVD+Y8AU3+bKokHohpFa+prkO
	 UHs6TWBbM06CQ86CGqW/Rmq1sCM9XW03K7btxDvXy9yngaOs413pfq4m+zH/7LEx1o
	 8Wg2LMxv2DwqQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 14/15] KVM: selftests: test userfaultfd minor for guest_memfd
Date: Mon, 30 Mar 2026 13:11:15 +0300
Message-ID: <20260330101116.1117699-15-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4oyoaxo8et8n7zkh9d1dcbzo6m71wi5q
X-Rspamd-Queue-Id: DDF00180011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774865581-25012
X-HE-Meta: U2FsdGVkX1+scWO1bXeVS5eY8WvV/fkb6WZ0l5Gjhq0mCykHkOMogBrW4x74jVWcbmGNkGeE9O1o2adBh9/ZagnD9LKfMNZNftignPlCkKsoecfucdB2CHhp4We4DlncOgvCvaGLydq0zF5SfUQxln2QG6o0SsgeJWmm7qWWM9YXhtVWm5Z3FYgCigq//cWxkuqTn2s1169PjQZAiKYmW5jP8hzn0wBdlgZZR6JesRiFIH5hqyLCjYV3HVs3HEAob3Kbb2IaR6bcCuxNbkKZxR6FI5Bzh59dO7djZsbxrMDu74h3x1+EPZoYpKHmM0eVuSHhu/f0JCBx6O/Qt60IZHBeP5ztxQwJrZifTLlJi/ZQFZAoXndSEg/Q2HQ+ubGaHJiKtc+IQG85uwUg/VjLNb6q64wNomBJ2mvU8+ZxBUqoEAXUha28nHTa6C/MEcr5qHbhCoLQ0p+5h2RuaUs6G3e+32+K9E+AzpdVHxQSkS8nOxZJdIgohmqtmuWwGfDEDO/MdQct0D2AovvvdHouGs/ZyqvDiOYGb6/856EzWRw2fJaAeG/SHncwfrxPhAOxj6IEq6h1ZgVThN+XdZOSJtr+JZ/nom0LWQpPMSmq2oBqDyd0EzjL3cFlN3fVnXCw7e+b4ukOeWf+IyFY8BZW4KUUamiyxxPfxxfzvwI+oaZ4X5vhrIFk8f5lYe/qEbWMVh9q0h3aNqPcyV1PTMu/wwVyUS6TXWWmM1w3GNVAm6ZaooYvpq8+1/6TTaKffIatG2MPvzEa8f9lKNWMOcXES90gCbnai1T8L2Gr32M17NXyd0KiCT4ylDAS4ktjxzXYYHYrUvdq9iEgVvgVo8cPj0j7It/KAY9aYNHUbKt2Lcg7f0fhksf37i5DPs2j6272iCrp/LG/vCG+C3C+I20IXugz6sd9u2DfFt3YsGWPKgKUxpHYgO9Vz0/EoOt60Ps8oDhWI9aRB7phzPeIUkm
 1UdSL0vG
 2Qm0McNIV7RdkiCTYIzS9eb+WNvF/L73PRgoGQsaRQHR23gzPOYAMfwWiyBGHw1lTXrABCkIfLG+lO8NEawK0WeiwdxjzsHs80OE6gA9922iMzaNe/R0V4LgnKsThLzNiMuG/EqOCPbJP2gRsbpVLy5mcT90Api2WuVaLgtldRcqwcYJiCSpeuqWKvxGKjRom5OJwV31rhkwJKOifkSrtA6BHU7TdYLpKi0mQSzlEoNqv1nOC3YfDP/Pq0LBo9UF2hVCFED7ArUvfUHTEB5J7TANQOYqmcDTTBsu/fp5Kn9KP31Uk1g3y/ze+dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

The test demonstrates that a minor userfaultfd event in guest_memfd can be
resolved via a memcpy followed by a UFFDIO_CONTINUE ioctl.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 113 ++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index cc329b57ce2e..29f8d686c09f 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -10,13 +10,17 @@
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <pthread.h>
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
 #include <linux/sizes.h>
+#include <linux/userfaultfd.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/ioctl.h>
 
 #include "kvm_util.h"
 #include "numaif.h"
@@ -329,6 +333,112 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
+struct fault_args {
+	char *addr;
+	char value;
+};
+
+static void *fault_thread_fn(void *arg)
+{
+	struct fault_args *args = arg;
+
+	/* Trigger page fault */
+	args->value = *args->addr;
+	return NULL;
+}
+
+static void test_uffd_minor(int fd, size_t total_size)
+{
+	struct uffdio_register uffd_reg;
+	struct uffdio_continue uffd_cont;
+	struct uffd_msg msg;
+	struct fault_args args;
+	pthread_t fault_thread;
+	void *mem, *mem_nofault, *buf = NULL;
+	int uffd, ret;
+	off_t offset = page_size;
+	void *fault_addr;
+	const char test_val = 0xcd;
+
+	ret = posix_memalign(&buf, page_size, total_size);
+	TEST_ASSERT_EQ(ret, 0);
+	memset(buf, test_val, total_size);
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC);
+	TEST_ASSERT(uffd != -1, "userfaultfd creation should succeed");
+
+	struct uffdio_api uffdio_api = {
+		.api = UFFD_API,
+		.features = 0,
+	};
+	ret = ioctl(uffd, UFFDIO_API, &uffdio_api);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_API) should succeed");
+
+	/* Map the guest_memfd twice: once with UFFD registered, once without */
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should succeed");
+
+	mem_nofault = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem_nofault != MAP_FAILED, "mmap should succeed");
+
+	/* Register UFFD_MINOR on the first mapping */
+	uffd_reg.range.start = (unsigned long)mem;
+	uffd_reg.range.len = total_size;
+	uffd_reg.mode = UFFDIO_REGISTER_MODE_MINOR;
+	ret = ioctl(uffd, UFFDIO_REGISTER, &uffd_reg);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_REGISTER) should succeed");
+
+	/*
+	 * Populate the page in the page cache first via mem_nofault.
+	 * This is required for UFFD_MINOR - the page must exist in the cache.
+	 * Write test data to the page.
+	 */
+	memcpy(mem_nofault + offset, buf + offset, page_size);
+
+	/*
+	 * Now access the same page via mem (which has UFFD_MINOR registered).
+	 * Since the page exists in the cache, this should trigger UFFD_MINOR.
+	 */
+	fault_addr = mem + offset;
+	args.addr = fault_addr;
+
+	ret = pthread_create(&fault_thread, NULL, fault_thread_fn, &args);
+	TEST_ASSERT(ret == 0, "pthread_create should succeed");
+
+	ret = read(uffd, &msg, sizeof(msg));
+	TEST_ASSERT(ret != -1, "read from userfaultfd should succeed");
+	TEST_ASSERT(msg.event == UFFD_EVENT_PAGEFAULT, "event type should be pagefault");
+	TEST_ASSERT((void *)(msg.arg.pagefault.address & ~(page_size - 1)) == fault_addr,
+		    "pagefault should occur at expected address");
+	TEST_ASSERT(msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_MINOR,
+		    "pagefault should be minor fault");
+
+	/* Resolve the minor fault with UFFDIO_CONTINUE */
+	uffd_cont.range.start = (unsigned long)fault_addr;
+	uffd_cont.range.len = page_size;
+	uffd_cont.mode = 0;
+	ret = ioctl(uffd, UFFDIO_CONTINUE, &uffd_cont);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_CONTINUE) should succeed");
+
+	/* Wait for the faulting thread to complete */
+	ret = pthread_join(fault_thread, NULL);
+	TEST_ASSERT(ret == 0, "pthread_join should succeed");
+
+	/* Verify the thread read the correct value */
+	TEST_ASSERT(args.value == test_val,
+		    "memory should contain the value that was written");
+	TEST_ASSERT(*(char *)(mem + offset) == test_val,
+		    "no further fault is expected");
+
+	ret = munmap(mem_nofault, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+	free(buf);
+	close(uffd);
+}
+
 static void test_guest_memfd_flags(struct kvm_vm *vm)
 {
 	uint64_t valid_flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
@@ -383,6 +493,9 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 	gmem_test(file_size, vm, flags);
 	gmem_test(fallocate, vm, flags);
 	gmem_test(invalid_punch_hole, vm, flags);
+
+	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+		gmem_test(uffd_minor, vm, flags);
 }
 
 static void test_guest_memfd(unsigned long vm_type)
-- 
2.53.0


