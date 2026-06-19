Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D55CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545A86B00BB; Thu, 18 Jun 2026 20:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C936B00BC; Thu, 18 Jun 2026 20:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4F26B00BD; Thu, 18 Jun 2026 20:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 058AC6B00BB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76A7B140146
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:07 +0000 (UTC)
X-FDA: 84894785094.21.400D92E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7A53520002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZBpHuGb;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829125;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3wQyS9CJpzZqtVHodNkoRHG7VSj59EiNosVBklss2M=;
	b=qVNadD8rdeLRt5c8vy0yhtGemHbz8/OxMxLn6ULLVzvsUQdHClortK6ioGFD1nawQNhPaS
	GPt9mnV0/BuV1Q6+7Bc8XgigJdb4EzV7/YqfYM78zwQLwvm/+f/lbOKwhPy7REB3dvmoMo
	zoxMqqceJ2QsZyomz0183t+I7R3iZdc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829125;
	b=4FLD07ZC4FvR6S5EOK1uyhcNdn9pWyk4NbfipCOAHQ/f/i0c/CLqxbmztogyOCds1H8wbn
	G86bpyoVSBzbxP1Vul3lb4JMjvFfHu2/VEjRxeC8AIVWW2aF3/7o0D7GzJt3habJVgBAig
	wHvwAIVPfWNzKB3IxLL+n3+Y9/X3/T0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZBpHuGb;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E493744DD1;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA38BC4AF55;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829110;
	bh=OrL4CKMYwmB6iIWg3HkCxDUl7gZtW0zGcxry6xJCAGA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FZBpHuGbKG9ZfT2UrF31X9LcBjDJoh39wpiJnpOcHn4wpVJsWkzju60a8ZSveji90
	 wKDusZCwLkIg8Xfxje+xgSVzUDy2RUvP35qmrmE+r8nS3odcE+sSDteWXpTPs1mav6
	 34fNMJESZt/MDtOOY5quwZOcwkV4vKsbU7e6InapcbYScx55HVKKgdktN6CMMVue/U
	 tMFECn4N4mFGVjF7av+qY4H9azkEUuMDmFM7KxUTPc/9S+lEu6nQImvUqTUX09xqt7
	 +zdbHl5rsaYRsUauCewY03dr1UhSp+xuzbvfQPzdwwEd4jQFT8sciQuwyl59fTmakr
	 4UHUcpBE8b69g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBF9CDB461;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:14 -0700
Subject: [PATCH v8 37/46] KVM: selftests: Test that shared/private status
 is consistent across processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-37-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=4931;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=QFGusShJmmZT9C364dWtwaxifYzefTMauT7Y2OJejBw=;
 b=/UTfA/taWQbgDxeNW73fbVoFb6WiUw4zOYRQkXrqRDA/4nbmLmfFXsf6OPMtJ0KxVYS9QVcFa
 b6J6hH9WV9ZBzPvjqKyejWNQ6snhl7ULMHAl0xf24U/n15KydeCKNv5
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 7A53520002
X-Stat-Signature: mmapxbdmketme11cf6q1j5fazwo7wa3o
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781829125-500942
X-HE-Meta: U2FsdGVkX18lL6/km0P7SFfR+uZa3O7sbVWtJdY/ktKUAITG6RHvibbiXKegc2cShPx7oVqRn0u6wAEJb94psj+GweLVYNgWHSpXLqtKATKmrc9dgw80h4JCaz+/0j7NXIEpDy8rnsQhSyEtDJvaZLiPz+u5/yS1oim/aFftByhdBvHhHGVMdn+XeG6HJHF4tG8zLRjBbruKG4iv66/Ql7XY1+/WV8+6nh4GF856MpRpxu9ivxeQKWVuYxVA391Zvu7EX3SilDjOQRVgj9+Y8jCXViqq5l5fyjpP0WDwvYUYQY8+TuylwVBOQAWyr2icj/UcK9+1ua0DgECjyZvAd1VpzhTAMXAVWecZRBbalryUy3eVk/iJrsoiio3KNcZuSssPu8xwr4ZFnU3lXbmC2I9jaWp45n8YxkKs+Mp4LoPf1+laFQt3HiKfW5d0LAw4EKMTetmfSS4oyGUi5xoGahLchZF6mylfZ0fNes/EYwwhe1231lfCDqUml11pbu1exuWu/TIIzhQqkD/7AKVeDuVgyRkyWm7RlGTDrDGcZNi04svTnSkE9dJ2biT/4mO8aWj6iP1VyGp/4icf4BdGSMPgKqpO9NqsHfBDqbChyAQ9PQ/thwe5mI71FjPds6xuJEDEZENsKK/7tVZ07/NRXZn/IFck8DiJ27f1n/a74PBYj5jCY0yU+s8NxxeGSN1TSX7L5YnW6QMYjhAO4jbg2+fOlluMUQds/34C622CvUVK3dXeRuGiKLsWmX14hch1V25xaeM399Q1f1k3tCTUc5Zina0jatb+SzdrScwDWDPhsS7XVr3XbR2TIprLj4mERmuvh9twOPZlPhB84POBpMmAxttD2cmE8cnpqDY5TjmjSKOqmDjQ+LtwqG1yWMg5QyU83SJm5TxgMU1Y+nIsFS0UVED5c2v4acbtzJO51DtGOgM1/BDZKPuMb3ye6L4qVCJ/ORJAR7JYe3wNy01
 d+Oducud
 5XB461kMHkXlUgTQW33MoDXqzFTk2XJY1DGyuncDKbVqr3rJLiMnAkDEDg0Gg+X32KMYkUCGlnhgHpQnjs4D9HcvQWK+tEBU2VJbo8ezsXY7RCFMPPRstMX7tdUB3uHdwtuZXGmY6zbV9/i77A09Mx8MIGQV/hYqlJBh3Q8cVCj8JsLTVNXuUx3dYZ997E3Ft27guJMdivmll8crdBOACj6xsp5XpAHIAeXnZfroVDnwW6XanMt/EMXtKsU6KxzgEANYOSnuQRYVMsNlPRu4dVvMIwqEujsCAPD3MrY3Z/d7he4hAGT260B3e6Q1o6xcUZ/8vrDJ/WfuYab4DLOOS/Q80gnQFUSjJ5T+qboZpuXV9TAVrAOKLLy8pgVk4l+ixJmm6gtTYi/z70tg7GOeD22NJJs+7zXbZGmc1UCZq3HaSbKne3ehJdQcfUW5kYS01QPq1f4xBUfsKma0=
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 118 +++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index f03af2c46426f..99b0023609670 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -2,6 +2,8 @@
 /*
  * Copyright (c) 2024, Google LLC.
  */
+#include <pthread.h>
+#include <time.h>
 #include <sys/mman.h>
 #include <unistd.h>
 
@@ -323,6 +325,122 @@ GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



