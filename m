Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85978C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0196B00BB; Tue, 28 Jul 2026 20:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6806B00BC; Tue, 28 Jul 2026 20:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB47F6B00BD; Tue, 28 Jul 2026 20:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5FDA6B00BB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4652B140584
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:25 +0000 (UTC)
X-FDA: 85039945410.16.9A3C20E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 381B61C0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cvPbfGEc;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285323;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hT/L9DSnoJ+WLPC3ty7p8Ey/QbZGsnjmf3eMpPlqDHs=;
	b=qsVQPhrFC4BLjyCV8G3JHSL5iD/ghkIxEralHp4Szpl7UISEHfukDkZLVzvSf4jjqKeIOP
	obQWG9ORZx240u4NLj7ha2p3ffNQwoGPk2aGcdq5/GtS5JNq+AM9IdqCCQXFl0hj85Q76V
	4ViTi2Iw2QqFc6xc6spqd5sXZDD9pd8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cvPbfGEc;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285323;
	b=JuJA9cuGBIUMm4aTmfBLRlsxkg7bzhGtjFc6wHL0/cBzX+a0anFrEecYHQcrIe3jFuZqQC
	BwfPPEIXITB8rBJGDR+4vUqqNT3q4lRtlLs0MQcER1OeLCqzIzRVp1rfYXNRzduL91IplA
	ymDF5LtipiQJgWyDlWF0AT4EK28geM8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6259452F8;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A00F9C2BCC6;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=JUBKSBNY0asBXOcUHeemdwv9Kb0rDdRYpRD3KVdZSaU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cvPbfGEcYSuzcjEha4wkPkxauZIQR7ipFcXo8UDa7RKDNIot2CQp0V4bRGn90EZmj
	 zacX+YK7O6fsj319HyI6rjZkOmRTz9ibfrgpDeaOJh3x/2KUevf/RNCakA6ly44SJ+
	 7aKZDzZXEMWi9XT3W2lrIvJPPMpNAWF9z7JH5zuvPGsws+7jrv0KYdBsSSexjw9cBo
	 gQnmhpYI/mWCCGXa6cMZc/ROgnI4wJuK1jq3GUYXiv678qvxL8BHOdd6Gvsc24hIBA
	 EM4Jky6CWr5+aLd6kiCHmCz84mG/n5C28lbWGpGytzbZ7MtJXIi42U2hrw7u/xNzcG
	 XXE7qQqfVVLAg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86618C54F5E;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:32 -0700
Subject: [PATCH v9 33/41] KVM: selftests: Test that shared/private status
 is consistent across processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-33-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=5042;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=21iOJMVcQPitKBzuo1HKMiAFQrUFJN2+cKgzecsY62g=;
 b=tHDPY8J1cFtlQLOYUntiefQusJyIo3csQ28P+VybeeHixpeOEIqCerIUJtU/FCOCTcxnk5tid
 FS8z4mbUmr9BwzqsJ6dEHNQyVvPFlOXgcWlDFqEEnAIRXSuvMxr3UyY
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 381B61C0002
X-Stat-Signature: wq6ts7317jj8p33kusyomz4q6dexa9r6
X-HE-Tag: 1785285323-191402
X-HE-Meta: U2FsdGVkX1+9SqCt3iZkyz3Ib9PblE4Ydd5C6yxkQKXVDS5XeFzDTWSNIRmQjqrTfMC8UTurdUblXAxaTc5jpWiaqg7FArOVft7m+f2ncn2CVcfohPyhsBQkooVO8tT9NqVa0SjfpSHTfhiOxVWUMHI54ZamKcJKYggrqxuSTJTRUJr67WYpCr0z4X5NCQPyhCNpIMOvGy4UIvPQJS3PsMl9ZvQkgUovoc6aJt4/Ue520ArWn6YnLc/0FHPWVqyNvPjzu29UReJQ5VnNyr4bd8CjGkqgbztQ6bpqZUCfPoVoMCa8HPpPtKyA2XLacM8X6v3Uxi1D1X1sGku3qgBhIhdT9r+PT+RnyY05qOCYvxuMruyiGHbcBIQ9prVy659+lVi9MfORIpBjc0Obww54qIMCRi20yPcJUZQg+jItXz617Df1tDWuJ0btj/dYaiReSo8uRxmmAWAy8P5s9qp75YYZex+/ldDy3PJYDtutmC5xef2/jowzrCdUuJigcm9wrjcpjeQky4gofuhzEX9iucp2H4MO/26VKCCbiwNDkhX8sL2/et5WaCAP/R3IPrDOe3apIYWQJqZ0SMuw4yhg85JE6hykiHHMDVnYk4DYIS6RvULExhmAaBWoksW4b2hWXzQdxkpVxFivWRrSTz9yXyJOY6EitsNcfC+U8XlN2n4lksd9zyzZDevfB4jJrTgn2D2rUpKMopK3F3g2yUgHIaXQawHv5s+3dd1KnqKb9ALADGCodV0UfpMRCuyAAeUBNp3r3UivM9453Mm7ZWRcANxIBSeN1HuASoEbU/7eUf4og1ZVuw1TqZ4V0C2UTJQr52WZOkgyBt8KMsigttjlxHzR4JGPO4XkXKKUu8FDuyJniUKptoPNpT1s6D1QA4wlaKtHS/i0UXMgmRiTuXK0elli5n9pt5lm5XV+hiWENM9a2SeiCQd3ZwdpvvxQ4PRn7YaIegkFSokv8zhCvM/
 FDszjpaj
 KdrB7RH4tssVJIgur4ZRNQoAtS0xNKxyvNp5P7uH3/Y4yuenUi8QkjRSXcZby7uTBto/0mKa1vbUZoIJ36bfYwJv19fV5eb/YHnTAY90ixtCpfGgFcbo0JV7JjYcNboHiIKBwE5t/KZ2/GfRgUzpH+lHDcVrDB2bq2EXH9Rxsr+F7ZB7O30OrQxJHIET6whrg+sFLijy8RxSbbl+csmO7p8uuWV1+u8k3BPtA4Bqyt59O2IJqPIVcHCh1Op5RoO5DGl839oqCLYd60SSru4jFUHhoLsebrsE9/rNYiHGQMob9ewAYPHeofnn66xO1bWC5c6ejzPW8/L4sJf5IHx36h2InlTIolqMyxcYVdF4ixENz6u7pgs722LW7p2mIwz4kL0IoCC2lN4K12UC/XOHTsisJicfggvt2iLEyv2+iEPk8ml4HwBiJboEe6yxGHn1fkDBEaytfnrGQKBJ0EZPOUJFNMUwX2MysyAoDpELREuEalCxiPmztMApiite9X4grTtmd2ouzmneo9Rg=
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 118 +++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index f03af2c46426f..e681dac14e865 100644
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
2.55.0.508.g3f0d502094-goog



