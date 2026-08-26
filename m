Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E898C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559A56B00C3; Wed, 26 Aug 2026 05:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509366B00C4; Wed, 26 Aug 2026 05:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E886B00C5; Wed, 26 Aug 2026 05:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 060E66B00C3
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89417A372B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:12 +0000 (UTC)
X-FDA: 85142871744.24.CDB25D6
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id C652DC0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A7BLMRmS;
	spf=pass (imf22.hostedemail.com: domain of 3ja-OagsKCIIgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3ja-OagsKCIIgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ip4vM408PsiT+R6udna4cozvVeqGNG7oQO0VV4Lz3WE=;
	b=cpCGYVtpUkcCTZpdmkS9x6fqNtXFK+eOY26YTJtKWChMQ5LTv7MezRj+Z1b8W8GcWfGsDI
	qF4G6vKLC1PCbqg1Bv9vhexe3lfZJ2Wa+7dPjTi4alFBqpsc+fQnBpC1zvpRmRwN5MqlWL
	Q6WPxP5Zlp5+5hbhQGEq0QuXLm/CI4I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735950;
	b=J6jMRthVh0MSBNhFGk/8n+s6WN0OOkuF3bg03DUyBT/JoEMonYvtiWvwBSGRglIrwAzsMT
	Hns10HyQ+/mWznjjcDilodFOhr9GnghX20SnzI8A/r00LQnQYJSawsMtPQvPAuHTngxJ6d
	7bG6JxyJDBeQ1htszmEJRGvpSELyJYI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A7BLMRmS;
	spf=pass (imf22.hostedemail.com: domain of 3ja-OagsKCIIgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3ja-OagsKCIIgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-848d21bbb55so1001862b3a.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735950; x=1788340750; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ip4vM408PsiT+R6udna4cozvVeqGNG7oQO0VV4Lz3WE=;
        b=A7BLMRmSJUu0NttBXV1Dq+ngUmLzEieoHTBV3f9M5dBz8LSXHHhAJnfLpybjahh6LQ
         huAo6Q9/yhLqkFhhBiBIWYn1svLrNzvixXld0PYqOqDpRWN4QrDsFquqFR0n5rPVe4Qn
         E0YhuE/B4wiDEIn3RLBBKyDwZ5PonRbWq2+JUWxT9HJuyi1MXHrV0oMc6+RPaMd5dt+g
         3RUzy22FwdXkD6fQjcg9sTl/5fJq51me0J4XQHqJTeP7T2XeYpfQwWf+HRb528d1I8s9
         T5on2NdouBmDtEOeJmhJ1CCs8FW4eX6YAS8VncgheK0DusKm6GE56LZnerkVvHLRUNnN
         /nAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735950; x=1788340750;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ip4vM408PsiT+R6udna4cozvVeqGNG7oQO0VV4Lz3WE=;
        b=EuICTQF/0UgFHiSPpH8tVGKe13b7JySvn2rQumLPxYFot2j2YY/FI9/5cvCn23Skv/
         sDsxIXQBHA3kQf1xiHgljf/EdRHgdHcT4cHjw/xAzp9qUtiyTyqidgzGBR1girN8BNWi
         lMRza/mwhTuyAxppCBPjyGJe5pZYRduudNLl0sKh8qZHzSqMfdttxBHO73eWccDq3s67
         ZfhnmOIprM8U0nP6V63TV0eIECXAu6vakIX42GFvcN0FrRNjRRyHfERMDqj2rmMJY7l4
         mbH+ZaRT9Oy09PRZKwAO9oR43zAPVOB6pskIIjUmoemxrRiUcVGcd9tCRWi0Pne4Uv4o
         lwVQ==
X-Forwarded-Encrypted: i=1; AHgh+RqGO81wILBXHqB5EJ7oZCPH937rNFiq4uwYk35teggmx7Seju6zqzqdTxogSDTEwsxXrFscsz8g1g==@kvack.org
X-Gm-Message-State: AFuF++nAebJaSsFFd5wfmerx99b8kkUB2LugWutt5CcMzxiDrGk3/KzE
	Hz/L6a8s+fyWSL9mc++kpnJDAduW9qhoySVNgG7kWISL+r8wHLisYdYewxkueDC5CfEYpLb8mkH
	VAqwVcHLyvI0vRROpYM4GZ4X3SA==
X-Received: from pgvm9.prod.google.com ([2002:a65:62c9:0:b0:c8b:6fd:f93f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:6c83:b0:84f:a82e:d32f with SMTP id d2e1a72fcca58-85371cb0dd6mr10170051b3a.3.1787735949013;
 Wed, 26 Aug 2026 02:19:09 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:34 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=5042;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mgO9cNUJjKY+AKFX9MzbbDfHmswDZG4pLv666WpGGk8=; b=4sXWR8XsmwnCwhSpArHLWN49pbbGfoT0AtcPlI36HRG/9GlMeMoVWb/i6RtUbq1xqd13MsZps
 yhnSFfxp2j3CfnwMrDrkdGOUO/3A2kREKcloGz8OlQCALrg5kqnLxLv
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-36-0a15d8a799aa@google.com>
Subject: [PATCH v11 36/46] KVM: selftests: Test that shared/private status is
 consistent across processes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C652DC0004
X-Stat-Signature: t7fn1jxypu8rjereowtbt6cct73ze5rj
X-HE-Tag: 1787735950-671692
X-HE-Meta: U2FsdGVkX191YDLdya0InZ4QWFJ1J1r/mVXzH4gk3ZaRr9184M3P0rj85r7KoGb3w+kePv5BmWSLzFR6cvGDBBrZW44XZreOxPtZMBaJB3VYDLhHRNxTX8ACsPIRvBKuN804/7LzQmvRsK94EPbSJ/NkCkRHqMdBGVCTsYLmcsiA06c+wpqyj/chjNE0aqVyLW39i40gcWhhTrwtzjXPMNJ9weWKDN1wHck07xlWxKSOz5o8E4guLl47z8J4lr/alg8SUg+x2JkTVlkIK4Gl8199uQClKABtUe39S8yH/zTowuKa6q/Dr9PzJZZKzBSltpwGC9GrzPcfD4k6RhVVfjBvgwWCyAHaGg5xOJVcPHW7FfmehLV0T6JMZjZp62HMX6TVmPMaE+fvSvShswGjWickItURAl3OBZjxZUGz+pldbv+E6c50dKgg8+xLxg29E8JtTBB5/uZNbuCXryjmRObzfqkYJS2yCGWbLS50YPH2sqA33NrIktBGbEJcHFS63G1L/4T8DtZqsBxfWczTgVrGRPOxN+e8YRndeE/aB6hVvBBIIcct9DweI2MXFkZKT+mNOrHijv8NXO9IrJfkcRX0Jx+gHLS02FdB+okWjqVwifWkz47p3wfI6M/LGdci0OXwdOyPzJtGu+Ihx2ahaleG4utxsrOaYmCKj61ZCsIq/poS0/NZZXC3TpQrkPVddknseATYa9mRDqB/OG7MvEhAGZfHl9fgKEh3g9BC5mIGg4I7gX65KDzboz0cfe3slEoAgUMfQuDLUhmYAyJ9GQpzR+x/Fqq11kBPrvBH+NLsxwHi68nKQPBRTUw6dXbAg6ikjQKthwhRzaqaPiXCJTSGC/HDTldFttLILAMYkZq6T9i+avJzoBdsOcicZxTnkRMz1WQFcGpMjhDTTcnrsfwsWp4cDAaPAMqKtIoJBAPrt8LsGYPiPktTwI3jD/Mekr635WntBoJBjFjn7Ur
 /rhw/6YC
 9v2CMM3CC/ecY4t0k8pXzpdR8Q4CuyYCBvgvRsAcl+NrRUq+UCS+nt7Yg08tDQkl5lw5vGZCQYHPcvey12v2yk9AhidKwMvs1LVXJN2tG6pUECUczzKz20tm0p+gI02sEYfPU9ehZniW9Zxsk7wGtmv/w0iCW1XWtfyvoIeUK6CHmu+0lWtFMxIPiKg1JdbrrZjV2bjyIWZmr8SGhuNBAtYai781JqK5EBcBnhesMKQFFoe479vZbJKMJVAR7zgTqqBMYkuu9Yno6irM4w41bZjO1yGQgsDK+a89ih7bQQ0/Y9YwSr6NIHD9G3KLpFdbgzs9RoLEs1c5F8bj5wOqTX95tuQqWrA6anOdiC2zYr9oF632lbEftq+oL9PbPXur35AERgoOADvHNH1ZiRwVa4Nw1RstksdY4KFa0XRogevDZ8L22euDI4m5oVf8Qg8qEOiPEF6yZhgdFuafaBr9hJi6meEY+9H/+fHDZzLZkAbG8HkW0XPOgvL6ATCOexfBd5W157k9nr9E9VB4r/w4aNXa8jOdjA3vmi48p76BFzTGG+ggDu3iZE2y0IgbZ0brrBX/lMspjgHmIPxxZZc5FW6Umox1odsgvFp1/0sKc3+DNBxSvKf2iIILUXc9uWCFdrdpZk9XIwKSb7dc=
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
2.55.0.887.g758fc8c411-goog


