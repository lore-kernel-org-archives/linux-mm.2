Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED758CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 10:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F1B6B00AF; Sun, 23 Nov 2025 05:27:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54EB96B00B0; Sun, 23 Nov 2025 05:27:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43DD96B00B1; Sun, 23 Nov 2025 05:27:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BADA6B00AF
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:27:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D902013C08E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:47 +0000 (UTC)
X-FDA: 84141495774.11.CC9BBA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3479DC0011
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UlDoHH5Q;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763893666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rvu5ERu2ShmTxZU6KDsFQ75CH/dfzj/xM1wZSCf7TE=;
	b=a00+mWHI26jc7sbhIy5w3gbGCaMcXwoIMCSF7JHu6s1Owjbj/01YGpFW2F70jRTPZWQgX3
	3DIA9HUVDisftlcJaqwVI7QXnlpQgExl+Jl2AKoIWesESpV/DDYvr50pH8nlbPyQGGa9+y
	Xohbb6XUGzDE9kEso1PhUPe/r60idwo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UlDoHH5Q;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763893666; a=rsa-sha256;
	cv=none;
	b=PH5zC4XcGQgF2qpF4kAico+mHg0/KsmmW8DgsZwTn5Dgr2Fn3EpBB+1oFKWbS1xitXsrT6
	OCDtb5wz5QKEXtdG8cyygP9+drsTxUNwXJi/OjNs63Y7P1XSX1bSHgNgL+XXKS6EWTSHjS
	NNNbNLVsoN3z6dsYDG3w/MAkL5r0V14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D90D43FFC;
	Sun, 23 Nov 2025 10:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A77C113D0;
	Sun, 23 Nov 2025 10:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763893665;
	bh=h8iM1V294GwM0YHrw7ozBTpi1JGWrn7/s48f8890vrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlDoHH5Q8Iv5mSabwAMbk7PJJOWlKmQbXeamae2ZPKxq9eOP//D3ZPty956O6D6M+
	 48trdFwBAydNWx+vtYd9RJPX+7eqK+QFQsbv3tl7dn9srde9x0DN0u/Ne7yu8CTWGW
	 2p/p9d6oBMv5kZDX4dzi7RKCi34VyTzW5zDaOE9oELBy6If9Q1EI0V2gIZazVZwW/v
	 9bee9AoJXJ/KL1UktjrqcwRHS+OYF59lpHoFkb8oB+JNJ38SSRE2u4FjHkCj+3vf9u
	 o8I0sN3cnEl5beAuz63QypaDUtW9hGPi1rcELbYnK+X7wlNuCG4pU8uXnL+Yg2ryyR
	 oJIbW/pZ+OyIw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 5/5] KVM: selftests: test userfaultfd minor for guest_memfd
Date: Sun, 23 Nov 2025 12:27:07 +0200
Message-ID: <20251123102707.559422-6-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251123102707.559422-1-rppt@kernel.org>
References: <20251123102707.559422-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3479DC0011
X-Stat-Signature: ornn55yoam8j1gfnqdnpb188wsq6jbus
X-Rspam-User: 
X-HE-Tag: 1763893666-307838
X-HE-Meta: U2FsdGVkX187F5i57+D9KujpMTR+xOjrjoHBV22Jwf2iWHMtZvs3Rk5Y17QkU4FzKRALPWvf5fnvxdn8VGAnVPwkpuFIwwY3U8nUf2HMbcpVY1Yho93QdzUvUjwCFT66zGE2fpBOcRhJ7HQF6NXhEJ429nUs9baBMhQE9TWvbZgcFHo30zAIGknQpOTNM8eJx9ROzDZLN9TDFRtGIey2cL9G8W0dYuVUyK79jSn82gzQGY7vwn9Ne5UFbSSwUVxRjbFwOerOo0dl6ifEEjXtZsKa7cw5QwHA/QwucweCKuPuyDZtEUM0TqbHHUARGvrvs0v2paglB8oKzNWk+TPRFkHmCraAgje/6vRZYrmsOW2JrIHPtK+oU8rgzzSONIg3SGbFGax16F8orOxgTIYrgpGXT2Oxjom6yG/b3REcC/4UStlWy3OAm5QV92GXU/54mBTg+ZWc9PnHfp2uv9WRRhwJ7aVXr7WnCuEOX1qzYByxO/C4EW34OfFd4miIOYmBd6Nv8668Dpne8/DHEYbjmrk8ktQcsDRvGoBc3fSjgVMZwhaIgzUHwKQkjH+odQYJcfRsuifuN4ZJO1AQiEqd6i4ORshjGBHssWO8a0pNAPPfehyCrEsazlw9vH4rc+1EVhlaWIzy35oVfxJ9t7M5fQxjrCjteds50WCenV6FBOfUTWal0D6BB7KOsscebi/RrgF09RtRSqFPYocx4fdVU+Y/9KEq7yEdAYlYNsSKsgwZKHOBvyl9188CI4qfFkFv1VJMxt0BhbZY7DkAH/jjwxCYLu5HsKR4Gdrv5n5xt/DdVDJOLjn4//sIwVePo1Eb9R9bUhZh/qVHN0VIRbLDab6NCgyfjOnS/UePswzV10fgVKwkLrnSXQovcTJcEhuvkViqX3M1uJsagJeeEkjZBeuFGhIIKElvmaQAcs3Kx4PTxkvtBj3Mwb4DkDxgFqFVaRfHWFXJ3JQj+i8vgz0
 vXeODGkZ
 MzX+YopdUifdR4Yj6EY/JRKxej8n2Ce1ZYxs99B/DslrJdZ+raZoVAimxK6PZWxcrrVxmIGXvsC49L+bMh5LTCDIuiwyQfzQL9FXAy4LBo4ipFUBiAAYBS5SiKb34wC1VkclHjbNQCq7dr1PzFLbAqLk9t5iKl+WB7JdmS40AwCziBihRXh4h1KX92EZCO7L5gAxgc4hN39rBPLo0J1TjC5oow2xhxRFbB0f2kO9g9pPzYRskLkncJ60mDBXP8JjfQ2CH+acy84uuyoJG2L5prbs8E2QVvTp6F6fNbYQgo75U0W6wCqK/3i/NMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

The test demonstrates that a minor userfaultfd event in guest_memfd can
be resolved via a memcpy followed by a UFFDIO_CONTINUE ioctl.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 103 ++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index e7d9aeb418d3..a5d3ed21d7bb 100644
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
 #include "test_util.h"
@@ -254,6 +258,104 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	}
 }
 
+struct fault_args {
+	char *addr;
+	volatile char value;
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
+	struct uffdio_api uffdio_api = {
+		.api = UFFD_API,
+		.features = UFFD_FEATURE_MINOR_GENERIC,
+	};
+	struct uffdio_register uffd_reg;
+	struct uffdio_continue uffd_cont;
+	struct uffd_msg msg;
+	struct fault_args args;
+	pthread_t fault_thread;
+	void *mem, *mem_nofault, *buf = NULL;
+	int uffd, ret;
+	off_t offset = page_size;
+	void *fault_addr;
+
+	ret = posix_memalign(&buf, page_size, total_size);
+	TEST_ASSERT_EQ(ret, 0);
+
+	memset(buf, 0xaa, total_size);
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC);
+	TEST_ASSERT(uffd != -1, "userfaultfd creation should succeed");
+
+	ret = ioctl(uffd, UFFDIO_API, &uffdio_api);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_API) should succeed");
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should succeed");
+
+	mem_nofault = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem_nofault != MAP_FAILED, "mmap should succeed");
+
+	uffd_reg.range.start = (unsigned long)mem;
+	uffd_reg.range.len = total_size;
+	uffd_reg.mode = UFFDIO_REGISTER_MODE_MINOR;
+	ret = ioctl(uffd, UFFDIO_REGISTER, &uffd_reg);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_REGISTER) should succeed");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			offset, page_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) should succeed");
+
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
+
+	memcpy(mem_nofault + offset, buf + offset, page_size);
+
+	uffd_cont.range.start = (unsigned long)fault_addr;
+	uffd_cont.range.len = page_size;
+	uffd_cont.mode = 0;
+	ret = ioctl(uffd, UFFDIO_CONTINUE, &uffd_cont);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_CONTINUE) should succeed");
+
+	/*
+	 * wait for fault_thread to finish to make sure fault happened and was
+	 * resolved before we verify the values
+	 */
+	ret = pthread_join(fault_thread, NULL);
+	TEST_ASSERT(ret == 0, "pthread_join should succeed");
+
+	TEST_ASSERT(args.value == *(char *)(mem_nofault + offset),
+		    "memory should contain the value that was copied");
+	TEST_ASSERT(args.value == *(char *)(mem + offset),
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
 #define gmem_test(__test, __vm, __flags)				\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, page_size * 4, __flags);	\
@@ -273,6 +375,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
+			gmem_test(uffd_minor, vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
-- 
2.50.1


