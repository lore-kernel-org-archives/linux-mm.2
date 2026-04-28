Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF64FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0E66B0100; Tue, 28 Apr 2026 19:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B296B0102; Tue, 28 Apr 2026 19:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989D16B0103; Tue, 28 Apr 2026 19:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84DD46B0100
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:34:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D83BB1C15B9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:40 +0000 (UTC)
X-FDA: 84709548840.25.CA79E8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7B2240004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LSi4BCso;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418738;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eS4lEF9TUKP7+h29M7C7IqJIGFMQseU7pf6+c0aYprw=;
	b=A73AR6y/KvZYpFbAkctbU4fbXKcYQ7cbdfRcmBKzL5AsZHysV9ilOYXqqDIXlqE0nIvXUN
	+aYewmz4Zfqqw7eokwIfn0epholb59fb5vLdnuPv8/0v4gP9B1pmDOovumjUMY4EXj/SdW
	KRcMUX+xE+OY/KP400z5GxzdNRNREow=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LSi4BCso;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418738; a=rsa-sha256;
	cv=none;
	b=CSDTVknj279eMpv5cwNQtw3ZwJrsL66dxph2UR87M0zMBaFBBVj5gJr0umFcxti3zT/G/A
	cXZ7T+KIk9djDmoypgN/PzmkskgKTvIgGT26yC6api4u37SWmAAyMuqku6025qIPDC0Zkx
	Fz5K/DsCWsJldaHRSGRJFNmqSaRErbg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B85244450E;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91507C2BCF6;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=k74W65/sgUamQSqwCX6QPTIXutTYcok2/gXOIvWj2PA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LSi4BCsoodSXa1Wtr13JwRzUK7xTLAqk5OWVYFi2qSZPJ8zA7D+SSEZ1D48CUQuT+
	 rWdSDWpaqxHqFxy+C8tpaeex+3XlA/tdpLIO8UDkK6nnXxZD/h7cmmE++U6gJk3C2D
	 veEGJHjGxJutmaCwOy1blzJNkJVTaVSnd+qKK+/ZDF65hFJXLzL5k55DQNEwpVZJjs
	 chf90qFJ55yGB1MFvKtI6gllnnUEiMFUB29cB6ag4flt/+o5SeW/liCAjjEA/ap/W+
	 KqNkstYd+cJqeIILMDbXblEpphRxwalJU5tVTSbo+mhaujLAi01uGpsdsuhmLwv/N+
	 8Rv/jZsXG7DMA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868DAFF8877;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:35 -0700
Subject: [PATCH RFC v5 40/53] KVM: selftests: Test that shared/private
 status is consistent across processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-40-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=3473;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=za9mbinhXQlrBGNX8T7yWO9RNCSzSfL649W98OVJnA0=;
 b=lkg9YFQlIbB1hlTVjPrGIukY3fzR7s6d2zyamzlqVzgGFcxL3JfBdyNqZw0C9MA3wGvekD5Qw
 vGC5eHP/UQ6DLO56Vn4ZHsd+yy/F3u/Qr3S2vgUpUxAbrEbmXmlAi+g
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 5ybkrc6phciubpyxdmk8zm38m13j1ibt
X-Rspamd-Queue-Id: B7B2240004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418738-264392
X-HE-Meta: U2FsdGVkX1+RZaXn9JDdxzX1t0Ut6L/N4DUP3SWzalghPB+R2BMvh2ZPmL5yxWIX5/9rIcE/m7YboEbdQm5ITv5xzycEoZDznUx1q2z3D1hXbArfPKljlStJ9zIC8+XQJQTpbC5Tqb13/4FyU4Ceg5tPlcoOmYxHdK998DmEqs+dVEkRWvRbCEYPZhHPiEFHxHzEfVfiev0XiLFJC/wvSs3F0b3c8a9f9tzYy/ZIoosZ9GWgtH2RxftM5pcDdmri77OLWq3ZaLDW8psMy6JIToFtZIEh5jYbDgMZpDKP3LTJKJJXZChOFxh0RFW3RZeNdJKkCbpRuZXuSoRJroa8XKEw9AAvj7Cvq3x5EXdlVSiLxQBgexO55zy3J9TUxIw0pZS5JZMRNJLgpwd3VS1U+cPOMo4ipEdSjHGDkmVxZnjNKBV0P7rJukySYYyQcvSUHsCuzU5tVIZYIS3/T9mpk3uVW14Z/C65Ws3cJlBe7UbtX5q21uvwSaVO2netYxRZrdR+U/myxzHfOMgPLBXMDemXwIixV+994rmGqDtqcyHZtZpZ8V/0SqxK7VnNsmEzZR/lDOzwMpNk2AYjjklQ/ZwSV30tLolhASSrF5Ao/vW44dPpK5Af71Cs8Ty2V/KfTzyAJXwWvALkuAFHXylbMHMVJM0zKoEiIwpt2Z3m5zEHIs4OlkA9O4OzkIYx+8CWsqGyTaYh9yyPkR0Fd7ObPkBy09cEvRWTqOtCCEFj7PloRiMQOaWqIGhtSaYd252hz/+Vw7j6Mk4+HY5hD/fy47IPfSKpEHUTjJfr10/zK8SJZ3wrNti1nd6J4hjJ1lyteBhNgtsIqu+2r+2Yzd9ka29VpdTxcQMAVswzPUn6UEjwTyfY8l0SugdjtFCMY0/PX8mZ1HOUYwB5cWpZaGWm4ZrfEhhpQAPGg7WFfVXqlDmjgDZw9p2ss0j/rCh74MBSBipFxKLaAU91vKdTwVI
 gZihziEZ
 tAC0WpEKqhqfgU9GhtqBpRcN7u9oNmLYnb7AIFyTlT31wM4uKcrjPUr/jzRJZXA3PCC91zF4Q7QpyoUoMbJAAUfiq6eWckGoRmLHJtZH7CFj+sUdvlQDEZN9FIifcF7wrp5cEbWGmkCtyFHpEdQ6yjLXhbb0sHOfPzYAyj91DWpeafnZ/cZj89bdLEwMSdTmzO9gy/e0Pribm/55frMXslNsC6toStyx6vgB1ELABRGG96JsbWptvE1Cd8nTrTeh4PCpR8S9aKk8uhHH0LQFYgWbD+mZN+6WjUVHIpdL0DJqJGNtLg8tjnrZoqEye2ZP/N3aVXCev2yLIRkxwzvfYZbI6J3AMBDPA2B6YGdPG88fSjrcK79XnNJhXqnS/5O2AllpNE/DY8lmFDnpe+Mb5mX/GpLxtjDW7vtBm8VK2B3/l+BrEc6zKqoM4EQ/4DT6ekgFUYaa58gCJuOo=
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
 .../kvm/x86/guest_memfd_conversions_test.c         | 74 ++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 8dfbf3630cec2..21918b83d3792 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -334,6 +334,80 @@ GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
 	test_private(t, 0, 0, 'A');
 }
 
+/* Test that shared/private memory protections work and are seen from any process. */
+GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
+{
+	/*
+	 * No races are intended in this test, shared memory is only used to
+	 * coordinate between processes.
+	 */
+	static enum {
+		STATE_INIT,
+		STATE_CHECK_SHARED,
+		STATE_DONE_CHECKING_SHARED,
+		STATE_CHECK_PRIVATE,
+		STATE_DONE_CHECKING_PRIVATE,
+	} *test_state;
+	pid_t child_pid;
+
+	test_state = kvm_mmap(sizeof(*test_state), PROT_READ | PROT_WRITE,
+			      MAP_SHARED | MAP_ANONYMOUS, -1);
+
+#define TEST_STATE_AWAIT(__state)						\
+	while (READ_ONCE(*test_state) != __state) {				\
+		if (child_pid != 0) {						\
+			int status;						\
+			pid_t pid;						\
+			do {							\
+				pid = waitpid(child_pid, &status, WNOHANG);	\
+			} while (pid == -1 && errno == EINTR);			\
+			if (pid == -1)						\
+				TEST_FAIL("Couldn't check child status.");	\
+			else if (pid != 0)					\
+				TEST_FAIL("Child exited prematurely.");		\
+		}								\
+	}
+
+#define TEST_STATE_SET(__state) WRITE_ONCE(*test_state, __state)
+
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
+	kvm_munmap(test_state, sizeof(*test_state));
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.54.0.545.g6539524ca2-goog



