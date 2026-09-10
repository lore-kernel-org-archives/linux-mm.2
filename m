Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C23D4C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59C46B00D1; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4B06B00D3; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2796B00D4; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB536B00D1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B879404C8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:54 +0000 (UTC)
X-FDA: 85199513028.15.6198AD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D01E40003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eXTIJbxE;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084552;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGWNsNhzEnE3ocLw+3QF9KJC/nEBkLjQbwf5q44MHVE=;
	b=jRmvsrAYuPVwgJlmPrDHQMhax2i5Fwg7gi/40V9E/pCF57g/Xgr5f2PxRFzhIdXwQ+r1uG
	cpqnMK8MN7rlgoZJHAdUZDA/PNHl6/wrOTUe4aTJz742rFetjbv/a6wtY5bBSIZ6gBC6PD
	QTmUPSbGutmG2hfOeX+7gLIIFRijZR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084552;
	b=2HQ6YThz0DlAETVHCIYMNAx80YuSAT+LPPDqjHIoAM1WWU01v9DYnGLFcO4GbshQsxHXnN
	eWlQyQ4V7eVxr7OGwbVHosODIwcv3QaOQgreivVpYdAEtQVdsAyzKa8BC5c5YwYWc9giNj
	K2bx8p7Tnhrb5tSyHxnWngY+ej5ag7g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eXTIJbxE;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71FF344974;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4466EC2BD04;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=lA8bS1JMhm4QXGExONG6B3nelYs4YLHMSFoPVXriV/A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eXTIJbxELKx/NV8c+2LmzyX9znzxvDiMQ66NwgvzKCuQCCqOFnuu8lqkRwt5oNX3I
	 FPbGIzVNgsFtzpCvIDqlLL4G92UqQn16jnCSbbzLWE4cjyspyePByO81yM7iSFtFS9
	 IIlR1VQfGcfmOni5Dbue2YA6q6FbseDBg3e3bF3dIJ21oOESoAs1D3jdKu/IyLCQwC
	 2tnG7fRUyYljLT4xYvzkbv7K2NoY4RvtmVGLIlpEmssGbCZa2uIBqidZjHFDNnV/vS
	 vKy3J80aRsIIjUx4Ogtfb4it+ivG+r91cVGXp/JHdMxyA2KzEPrDCfFGzVYdNGs8uH
	 0/FCBcniYreRg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E758C88E41;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:01 -0700
Subject: [PATCH v13 35/44] KVM: selftests: Test that shared/private status
 is consistent across processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-35-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=5043;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NatKLPwBc3zN+sgwD1yptGfPaJSyXn3xro4ZzLKzXNA=;
 b=+HCfmDQYtRRHU+KdI1880J9NXIgKQIU35pCgLEzsuOdShxo3wup3kgWBYmuKzRe2bbUSJDlt7
 VE7BNNX2WzmBuFaBraSzGYiBEe4PzR5wWsQPNnPzsRwucpJGngF8CUq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D01E40003
X-Stat-Signature: 8ymdhhm3bpotgjahiiqtixktrnyiuzq1
X-Rspam-User: 
X-HE-Tag: 1789084552-664008
X-HE-Meta: U2FsdGVkX19BDbDa49hLNk4Lu3EgNrVSE3SAwYNEoXPdFPjtSr8JdawSaSsQwDIrQN14M+yoQQA5H/9SsM+kXaMYeRsyiNhLwYUIGaQUc1Qi7B85IM0r+R7HE6LVOW1uX46EiS/5IyTrbCUu9pSFIvvPqw1qrWT2XthBD9powmMvhIh5AlwOsWM0txE58Kmi+oP+UAZ6stJx+uEyrQyTHe2YihL/dgEosvpT1aBFYQePraWsg378tc6oESzb119c0EAHIB4IXtqpk7Rm/28Nw/W7mmXEk/n0tcogpeB0craoA/RP0CEJactoIfCkUVYyMqz7ZSHe6LyfAleKmUpSTFOHWTG7V+/8EcbqJPM4MhfAWO6nXtHR5qccbSZYbExQLtSpqThwEHxQ8ECQNWM7lh6u2eNKQ+HhHjoM+2sumYkwlXBldOkgeNUGIOitcEfqGXc08R/KR25MoRi9ow5D+DNGwx2e1BiFaM/4AH+p2Z9ixxTBcFKc6MjKZ9FnegUIgi56rXg4T3FqvmubJGyp0HGZua8jG/6ND1CeCQEOhkYaZQ7heB6Hov1uW9OhYBLdO2J0jPn9+I6Hbf7fNfEKoBh8F7foxu90/6eK8rBJbYAMQBt2uie7fEsFiBdjXVeJpw+yHdI07l42FmhTkIdfSCtVAmnn04BbdGlE3p/KZIJhxAxFJmnFIZlLloNqaUQT1hVkRazlyaE04rv93kTWWr9mqgG+1KtJUc9Cq/9uCXHa4PHCeTIUrEQXPIWyAItgWRA9utbwQ/gmtzhR1veeHrmGGuxoqBUYUYtnhu9XpKrIAPvJT5JjrxYu1k0whvG6ydrIOaj8Zwooj45pX/Sl5hkMhK3jmQ9lCcmvuSCgohEVX07348WkGiWfy6ZiWz1jFoqbCLiwmurIfYiSzFGpyBm75rH+GRxDu6BsKBgD6GM914zP7ngGvymEJiNqv6NHjW3wIVYuBUXodlAHkPW
 ZqTnLGN6
 MD1V8cmyfMrYQUHpx39H1lx0Xq/SbTyTmm851c4S7iZeafWpW4fOHPnE5ULXokCEkbYDU/SajJ/9caoEvL0ukyqSo354ekHNCHgl94n0lzKwuJPPLvMGvlvYAURB9bHfQvQg3L1hlihrcvubNKXewILTDl5lN+Uaa+rdD2ZpebsHMFWSVOvYuKO6YuWEHAz1goejxMRBkHqNDoZgrh6uCYiLOYXHj1HLWhQ5ChoQz4zaLgbIAfid1qRWZ3QlFQMHpeBSTa3ShRKEmw+G93n2zkZq4rf6RCG59W26Qm801qATNsLNt+PoxGy0l0zWyIwi8fSGcX9mo3Bt5kPgQUdMuQBEj3qKzt+Maqt5IcpFUHp2Wj3M1oCHBvMhmHHTaf8I9Z1PVzCDN/syWOm1KC02rPdYcxiFE+Er6Wfmq1DDdDmQFtCxoQvEgEgsI8vR0mLZB2LSgBVNyyTpibLIDT6ZvYz9XAAW01oV+3RwT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add a test to verify that a guest_memfd's shared/private status is
consistent across processes, and that any shared pages previously mapped in
any process are unmapped from all processes.

The test forks a child process after creating the shared guest_memfd
region so that the second process exists alongside the main process for the
entire test.

The processes then take turns to access memory to check that the
shared/private status is consistent across processes.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 118 +++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index b7a54d2a90928..a972a09c5c6e5 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -2,7 +2,9 @@
 /*
  * Copyright (c) 2024, Google LLC.
  */
+#include <pthread.h>
 #include <sys/mman.h>
+#include <time.h>
 #include <unistd.h>
 
 #include <linux/align.h>
@@ -326,6 +328,122 @@ GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
 	test_private(t, 0, 0, 'A');
 }
 
+/* Test that shared/private memory protections work and are seen from any process. */
+GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
+{
+	enum test_state {
+		STATE_INIT,
+		STATE_CHECK_SHARED,
+		STATE_DONE_CHECKING_SHARED,
+		STATE_CHECK_PRIVATE,
+		STATE_DONE_CHECKING_PRIVATE,
+	};
+
+	struct sync_state {
+		pthread_mutex_t mutex;
+		pthread_cond_t cond;
+		enum test_state step;
+	} *sync;
+
+	pthread_mutexattr_t mattr;
+	pthread_condattr_t cattr;
+	pid_t child_pid, parent_pid;
+	int status;
+
+	sync = kvm_mmap(sizeof(*sync), PROT_READ | PROT_WRITE,
+			MAP_SHARED | MAP_ANONYMOUS, -1);
+
+	pthread_mutexattr_init(&mattr);
+	pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
+	pthread_mutex_init(&sync->mutex, &mattr);
+	pthread_mutexattr_destroy(&mattr);
+
+	pthread_condattr_init(&cattr);
+	pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
+	pthread_cond_init(&sync->cond, &cattr);
+	pthread_condattr_destroy(&cattr);
+
+	sync->step = STATE_INIT;
+
+#define TEST_STATE_AWAIT(__state)						\
+	do {									\
+		pthread_mutex_lock(&sync->mutex);				\
+		while (sync->step != (__state)) {				\
+			struct timespec ts, stop;				\
+			int ret;						\
+										\
+			clock_gettime(CLOCK_REALTIME, &ts);			\
+			stop = timespec_add_ns(ts, 100 * 1000000UL);		\
+										\
+			ret = pthread_cond_timedwait(&sync->cond, &sync->mutex, &stop); \
+			if (ret == ETIMEDOUT) {					\
+				bool alive = (child_pid == 0) ?			\
+					     (getppid() == parent_pid) :		\
+					     (waitpid(child_pid, NULL, WNOHANG) == 0); \
+				TEST_ASSERT(alive, "Other process exited prematurely"); \
+			} else {						\
+				TEST_ASSERT(!ret, "pthread_cond_timedwait failed"); \
+			}							\
+		}								\
+		pthread_mutex_unlock(&sync->mutex);				\
+	} while (0)
+
+#define TEST_STATE_SET(__state)							\
+	do {									\
+		pthread_mutex_lock(&sync->mutex);				\
+		sync->step = (__state);						\
+		pthread_cond_broadcast(&sync->cond);				\
+		pthread_mutex_unlock(&sync->mutex);				\
+	} while (0)
+
+	parent_pid = getpid();
+	child_pid = fork();
+	TEST_ASSERT(child_pid != -1, "fork failed");
+
+	if (child_pid == 0) {
+		const char inconsequential = 0xdd;
+
+		TEST_STATE_AWAIT(STATE_CHECK_SHARED);
+
+		/*
+		 * This maps the pages into the child process as well, and tests
+		 * that the conversion process will unmap the guest_memfd memory
+		 * from all processes.
+		 */
+		host_do_rmw(t->mem, 0, 0xB, 0xC);
+
+		TEST_STATE_SET(STATE_DONE_CHECKING_SHARED);
+		TEST_STATE_AWAIT(STATE_CHECK_PRIVATE);
+
+		TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[0]));
+		TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[0], inconsequential));
+
+		TEST_STATE_SET(STATE_DONE_CHECKING_PRIVATE);
+		exit(0);
+	}
+
+	test_shared(t, 0, 0, 0xA, 0xB);
+
+	TEST_STATE_SET(STATE_CHECK_SHARED);
+	TEST_STATE_AWAIT(STATE_DONE_CHECKING_SHARED);
+
+	test_convert_to_private(t, 0, 0xC, 0xD);
+
+	TEST_STATE_SET(STATE_CHECK_PRIVATE);
+	TEST_STATE_AWAIT(STATE_DONE_CHECKING_PRIVATE);
+
+	TEST_ASSERT_EQ(waitpid(child_pid, &status, 0), child_pid);
+	TEST_ASSERT(WIFEXITED(status) && WEXITSTATUS(status) == 0,
+		    "Child exited with unexpected status");
+
+	pthread_mutex_destroy(&sync->mutex);
+	pthread_cond_destroy(&sync->cond);
+	kvm_munmap(sync, sizeof(*sync));
+
+#undef TEST_STATE_SET
+#undef TEST_STATE_AWAIT
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.1007.g17ff1f9808-goog



