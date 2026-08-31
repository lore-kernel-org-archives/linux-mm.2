Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8590CC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F239C6B00BC; Sun, 30 Aug 2026 20:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB0A6B00BD; Sun, 30 Aug 2026 20:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75126B00BE; Sun, 30 Aug 2026 20:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A55D96B00BC
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32C27803B8
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:42 +0000 (UTC)
X-FDA: 85159671324.15.D90BAA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1EABBA0009
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u9IJ5iK/";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135940;
	b=RRMehdukXjEF4R51avlhywsOpoqh3lfyq5Y5RZvRKzHplyckA6KfgzmqfEezSkK9KRvlnj
	wzMeM361wa7l4RAwQBtEv9Nur4D2IcP0apRtwaskTobPhQZp6bznf+IkqdX94WrC9zAgyJ
	BFfWDNsrJnH2edkRLIxwLswP7liQdik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135940;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJc1PsPNXDdZgfeQC9Nob4Lb5B0SnRye2QUjRNyLxOY=;
	b=z74QFTJ3P+YjHh7tN79707kRc2uHFeaVKiCUVDKhSN8D66QAIJfa1dnbzGbVktM6BHYglz
	kXyagM+XpWXRm7AdoEMP4aExGQ9A/FJBWzqADaIy78wzfxR5APflNnUWf4gHmXVn/LjB6V
	1bc6xOOv55LgXw2PwMr1y6V4qW4RSJ8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u9IJ5iK/";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9139344994;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B5ABC4AF0B;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135923;
	bh=XlXlwtPHpVsAHVmS0wCTOzfJJ8Ren1/HCkQ1nzWHDlg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=u9IJ5iK/6z+oTOLKVBCiBM1jcEUKxQGSbYxCnOSuLnNIHilNS7dP59fFkbGBOaMGx
	 kfcOimvxRq6yEPDEvRMHKtQrp1c5fcAxn222JmD2i9xkvqnmY1X6BbnT3ZggsAKjv+
	 WyWPflkh6Lq7ZSu0Z7Iudcuiy6F/kdgTBcnOS+7+ZvJMV7JaHJ3krWZm9h+hbbjWNJ
	 fAaelo77ccCMb8Y/Dojp5oWfk2bYovKXhsV98r0CTVSgci6VwWl2p48KNuQFli4Vas
	 WchKwNuUplpS5NpZ6FBR2wQEPA3H7tu9qtfWtqaiiYD00i0LeO+EoV9wcsrd2DvEr+
	 h7+ov7sGwC63w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FABDC61DE2;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:37 -0700
Subject: [PATCH v12 36/45] KVM: selftests: Test that shared/private status
 is consistent across processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-36-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=5042;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=eSll1fxb3h9LF8Yf3q9CpNkCTF4Ydzl3TlGQL7Ph+7s=;
 b=a39svXm+jG0d08eS29xYIfcHadhb0Rsn115zbUmWat1bqwzQXYbDtRwIpu+8p+IQlZLDehNZp
 958MlnX5Tw/A6TcC3FJLKB5t6/4/NYhZHNn1Bzru3gDtGYVNFpwCtfs
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1EABBA0009
X-Stat-Signature: rycg3bd1ggnd19we9wh7ithy7mapyyej
X-HE-Tag: 1788135940-229300
X-HE-Meta: U2FsdGVkX1+0+7HjodLutPqjI+AbSfrWv198M4zN0S18DcfsoEe6awEzf4pb0UwM1KZkIc7Z4stddWU5lqb5MWLenUlIrG83+AoGxu+OVJx4H5bYrbaJdTXhGMjFDfrJSrKgMGg/nd5DUYMWT+DOf0sxJZQgx7TQhCa0v6a8rij4dts7yR1xojGHyw5F3k0r5lg6jv8WC+vNhhT4khdK9DG5fRYm0pzhO1fdoyHreEBONHzuHiF5qbFOLw2t651uM+VClor2yNzRyMWdrAij1gXfVgz7er2RCJpBanDk35vLu0cru14XQoVamn0sEm4QiqU3SGYfvo2T9iBaGEPdTq/jTJvm6d+MEy8TMbxlBT0ujTlxrdQaLVuPtYv5uQyZ5mhwDZ23kJpynPAktam4ap9ncj46uUv294AMNP+m3hcbF7ynnKhJFjh40abiVy+qHQ6egHZ6NLU7O1sXT2Ys6xIOHMaBOgsNkI5i15+xRRE4YlY1ECAAmgt9W5NCt5HKi9UsP42D4yX5qICkgiViAtprw1jTp6yUkBu++HBcB4TJ3UYT6c2RkY25wZDsTdlczbOxQrvFM/9vOxUW3nTm7ZNF5zJMTdWgCkQ0eupNMkdSHZlA8wrkBbo6DkbW8m/B5sJqNDrzI61nEWza8mKjteyBLev6jH9IGHF890RkNtDM2eam4FjSEji0VuUXriQBLE3L8kkdmg+2ICuZMC1wqWdR6S/+ng7H3dxfDFEy8k5uAwkOFR95Bhji53HX8wgKEQOqFgwrHHqXgZGhbJQBYOMMYCLsAEfPjmT8kx6Em6GZfe+6lrWm/JBIOFUZXZN5TpeEs2SMS7KZrFcKbe+J6oY7Y7DcM8qqr6chgmANs6PNIRm8bSe+nXGe7dlogWfE8jRTCnQnPMbzRyJ8Ul8bS6u9b1bzXjPVliGG8MvgTLfKhXNvHQsa9OLJ7905TBgg/+5P9TQ/WdeUdZEhvqM
 BWx3sWBO
 gYeZ6FoaY0BC3jC+kBD1dfsl1Wf9RB8GUFa4lalCdJ63dC4nZm1EfVBTPgLRVs8KLWb+UalzIq4wa+85XjCd8m4YCuq3UnTNGhVtIqFZP2d6xlbkdOlTSAkjCBEDvFMubEm4ZsD1D5G9aV94NJ9rdRU69wcfYHU2/TDfowWz1q7fA2yWVcGftMxnirdJET/9ACk4tOuxoaZWusyD8RqyV8+KxSo2CRV6pfbUP91mp+AsiRaJ3rfl1+4ePj3x2FtuTE/xccYZx7nnO4lIHl9MWuEyjz/ty+zkExItnbrKB1ap8dxKgAq0DjUa6W/HID+8MCqLFwgkHqOheLO/+c1Y/q+DQSR7s272armA/fe9auk9fvrF9v5CvsicNE2ZmZOFWNbkHrf6scEuCAx/LSsyKgd5NiiYtJ92alJwIOk3zDtp2cYQiz9A+8vB/LpmazpsH26pSZasEgZM+FGjhVeoDXI3IjdSFKhHEjF8x
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
2.55.0.897.gb25b4bd76c-goog



