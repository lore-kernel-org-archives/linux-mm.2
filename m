Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F11C5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06336B00AB; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A649F6B00B7; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77EAD6B00AB; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3586D6B00B2
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEB6F801E3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:53 +0000 (UTC)
X-FDA: 85075823826.27.C935F6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EBDD92000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HYk4XNP6;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139571;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDjsa7hY0VJfEC2j+fBuN7dN7ME9E5m5dUEGzwbSDLw=;
	b=5wCAed/4n+oapnQzWU25JVW5EEL+i3zuiosivIhseNo3DVRHYGtotaoAxmOjFO/f77IBJO
	24gIUzWac/4rWHaPxT4F8WBTc5SYNx6AZ8iXX3XSVsgxQwjgRVxDdfWXSKGWMr7L5Ky7Be
	twC1M7ft8BWbzvXHowj1K7vAT3AXwmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139571;
	b=bT1r3xbabUqyZS2c0FuhjsdSn2KPbZJfOvJ/41bmxdKpchcobJXts28qX7dafGzJneof9d
	y3ieN7ghnS2NaiK1thE87IvTK42q7wVPoyu6gxV/xTjDl/rg19HNHk1T26ioLBrK1VKQkG
	JxoGqs8lDDY1UdIMa+CB3B6ZEKUzgNE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HYk4XNP6;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D655601DE;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AC8DC4AF50;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139571;
	bh=9/m2jxorN/mpEKB+0ZPDHMOy8YGWYwwh289K8iE9S8Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HYk4XNP6WcB3voorCYEt9HWu65TvP5LOmDMD8qRaZLEzx2ayWooIfmg2YOYZfc+ur
	 5jLW9Uzmr2kJeiFee7GFmIqPBjd24vSGZlqkP1/CbrMz1OIOFA3UzcxFBCk4ddGHaw
	 0dSWKmqfHm6ni63LH56/9oQ+hlRbA4jSHQ/XEKrl09KxUzuI3Pzs68yloF3EJtjgPG
	 P07fiM0ZPtx4YT0arK932gKsf9uOIm6C2pvFmFt06Eoiivrs8UvIxyQYkMhhLTpUiR
	 O+wSMGvTPE5Z9UQr06D1lIE4bv3SVCMV/k3db9OMfQnPe71/1EqGp0Nu90vsByxk8z
	 o9JpNQh5mGdOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E063EC5AD2B;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:12 -0700
Subject: [PATCH v10 33/41] KVM: selftests: Test that shared/private status
 is consistent across processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-33-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=5042;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Ms+Uf3765Ivoa4b0Xh9VZFehp7g2sgcWofOdWHtIXiQ=;
 b=c6u1WfppRWCKD7i14xOqzWZctHUQCeSAD2vB1tMd8H8ffRAIjeADz4RVPXWO4m1EiMTPF5Xw4
 gixah2IQwpCCXkFvbLunj/SQn9fKtGcTGMJZJ0Vkbf5QRsv9aJCBlU0
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EBDD92000F
X-Rspam-User: 
X-Stat-Signature: 39fi31ew9m3gchurpecmx55kwzw3wmni
X-HE-Tag: 1786139571-307202
X-HE-Meta: U2FsdGVkX18581bAGQnGAAA7HUPfM611+nu35KC+47n1eh6HRoEXydfRxo0fjHmqi3gzGRDmekNhJfwSS9QdjUx4cnUCRPHR7HvI4oTJ8LDVTDiP/mgcAG6suCkFfs+PO5Qp+VUvOPpVg/LB3uANd3E4OijCY8cLHVxuozyDXdVonOwnTpya/ZE/EqKpEQe6cSeWPsAfXtgegRJNn6hTAwXa9y39Uw64hTh5XWnlScoQQAUJUqRis90FZBWgbHYm/dXyfF4o3HEjnV9RVTsQUMTznH//j0dZx9iX1JNcHBW60AGnCoszi6Vh/vzad/ctZnYbkQWb2BwWEX99Qjz1slc0Gg/mVIpWjnlhcXOuePaaOELUMk79Dp9rs+XYH7E9znTwnmtRkaVQnmW9PnMTb6iGJobAsRNxko38JsghYo6zeIxnk5mndk1Hl6AbFGsgArdDGl5hqo356R7NoYx/WCBrKZEpGvegRiQ9I50bLLfN+E1fs1ZymLvoAeuLqMBqZQKkGZRa2rKIPfEV21zqMgmN5w38GIXP8IPisz7xY73OoTruDm6pThW7OCsh8EMTBa968g4vRDlHJyycHBwklJfgUaB7Tf57ex3bJJM1H6+PudwmlctRWrX1oQtGhq8DmTrmUp9VLfVHb/UDk0NoT4WxMruxKAIFvnNrAzofTJSeHI9M2QR8gl6YFSuItIWbRmFvepo8mkCoeEEV8J/GHj97sf4fJWOCGAIN0QppUWleD2Dm9uIY09o51Ra9HsTADmurZa72Il5cHG846TkJ6uRvgcDnYGdW7vjFjdlyjzfx/oqj7mDB2VPlpHPTrjl51qBv8Bmhu9wcbjfiHeXtgtJLLDRFGNlrhYT3FYtA9ShF83vhFQhxAtQnI4E2t9OjAuJuu9SH7d3wI0jm15A7tJfFcNztN/vWHI0G0t7hyCv09CdJoR6t0AVswMXJ+0K3HFzelnCN5HixzEl5pOG
 G2xT3y/J
 vzVx4lASQZ3IYnghIuj3CozcOZ+lfZcdedFPO6/wA7n+2RB0v/D6WHWStbpgoym88U0xCkKIXjHqKoYIxVJWhhC5t3wppzg2ye8F0GzeaSpLbej7FyJgS3ohsPrOCjEtlvaEx6dX+HvzZ2q6MD9VEc5Ac3Q3Khgb9BS8xBE9xibHN3WdRRn+mxf5K/rh8OkxgT8TGt9BCBjwkzw3SQQXfSZ/QNAO3D2V1NAch5ri/jkPx+J0O1llWge0mMZenyCl0gWS9BlLGMJxtIXH8AGuSjNQxGP+RNjcvQEl7m2sPKawqS9t390A2x0senVVeBDUfh886xY7Cxq8nM8xo/eIypmuGEri3II3n8MKxxJl3cyRmkKfiuVLrLjNhVBNyfQXoDfnWdrAbWtl98xlbUEmwUlKAozLaFF7tI+5D+IJynBxwMeKSoCp4x7ULeBWwczPrjrhRUED2khgKPKuF6CRqkxYByry55oq+R1IxoLsf9dUCIfs5kX4gOQrTVTldyaDvQg9gkCoymj5UXMY=
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
2.55.0.654.g21b8a5bc05-goog



