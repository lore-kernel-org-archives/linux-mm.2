Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A33CD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47BBD6B00BC; Fri, 22 May 2026 20:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4536A6B00BD; Fri, 22 May 2026 20:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231C36B00BE; Fri, 22 May 2026 20:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAD36B00BC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3E19161A2F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:20 +0000 (UTC)
X-FDA: 84796772760.15.3DF52C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB585100006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p+gU4LEn;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495498;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gg7jTCqXgTRPp9RNjPw9r5ZYf11jyrKqbd4ZrNWOSeA=;
	b=2s2S2Fjqa9LTUv1ZCIeEtpvhU09XlQ5acUiaqrbiycmIG+Dt8kpnWJc8GDHRp+bH+c+SxQ
	FSLnGKLXUW5EzvjujV0MZF4qY/8hj3USiPW39QK7LkJ1wp69DZqpAQ+XTWdbW0oT2t13QA
	kUrd5uN9acsI6YqYiVqurT1An9RUkcs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p+gU4LEn;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495498; a=rsa-sha256;
	cv=none;
	b=1MIVEu6sy4kTwoEsEfk0AErCu8RZxMumGuw3tLF3lkBLa9wLBlWYrVevZ98RiLzr5CU+It
	LWwAGwt3/BcaQkfVWt7ef8lhkoI8GqPRvPJOIxlU1qfNXVg7tl7O7yVsqcZnqQGIl+wDUz
	dPn8u3/XsYKCUBmykPJFnf1l6i33f7M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D88DE44DD0;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 385F7C4FEAC;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=NIHzuf8+ylZIn4CfgixDo3uB4zWKg1ftLVDRaV1aJUs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=p+gU4LEn4v7vXS07SINyENXThA/sz0Q7u8rmPkX/6A5q3KDmKTPbsmSfOgRcbdwk0
	 06mE4L1VzXqK2OVdYzWiYuX9hFOic9+rErfZy2G/RZ9z/BsUX9bW+3d/1oh9HPWLGX
	 ZH70lGrtsy9RxteStQc0Bfe5CLPVBOgvQE3GIisAA8hI+qxeJT1zAGnQ7tI35lgV86
	 jtw/t4/gNTRr63fgBuQgbw7xViQdWOFmS5DbYCeF0E/KdwGb6wnLN3DR+2wNQ/h8z0
	 5DiVBNfzTULwFJH25o3Gl6SmiTCtfASLwTMdvbfJIJMtvhDRK2X9+TOuf7453fjkXh
	 O/dXVrdaG3lug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26943CD5BBF;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:15 -0700
Subject: [PATCH v7 33/42] KVM: selftests: Test that shared/private status
 is consistent across processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-33-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=3473;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/qDU0n+L2TYG6NEhRjKXD8S43ctoRvdQTRoVnVpr2dw=;
 b=jxYfqfPlXYGYt3tbuePT+Iz77OQWSmNK9BamCbK6kMVGBuo1hsCn8oMn8OuPBNLxjS7XX7qc0
 h8KrOtsyTI1BnvPGTNf4ow2YG5QOl9idI4otsoSCpsoCCDj/hBYSQdV
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB585100006
X-Stat-Signature: bdhh3mr5wknmoeefrr7t45qgg8f4rkpk
X-HE-Tag: 1779495498-97739
X-HE-Meta: U2FsdGVkX190jbXNdmgSmuGPGCwLWeqq28hOlfWgBAaST8vCUbsjXNwxh7JlMPp8wwDNPXlCjgIt+RShq9QTJmsRZor9s87olopdSFPXOiV+2JJRd0menhhyh8kjvdIzVqOcR9rNcgJiotv08v2Lfn25Hgaqq5vny/rfDlkVnfk9ZsQgDKSCdylqfn+88eMhBsuOdRfyWmXzTRVyiAAu9XOdz0LSoN0MYMS5iodCFRH5Ij5J87iLUhz8h6Li53pmAy7wvLgn2txU9iDLtBaO00UeDricytZUC5GWXabJ0A3caOnVGHDeGwhTQvFLg7IHkq2sTV3axkjZB7XqxhTroaXAhyQJCi6+u8xmtjM8yES8uVoMee+I+3F6aMx8g91UMUajAzJd4999AiLgcAeyC2l8jLXKHbTEJ5XuPcdKLj5yjYliaJGP1KTSZIwScnAWkykaX0BQE78dl/p6cHe1xcSEvpyqExRxAGhaWYEW6MgrYP0Fw5nlFq+6zSScwQvfjNN12UcdAuR6MSxSLulrXykfaAcOTsDuFkJNa4OiU6DqHrVBIZTkTci+DDFBEU9F92qGC72+syCVPZRGEITtl4uRnAB1s8SEu4bhfWS7Yp2RSm5MdT9poPLVZGPVq08seGxQaaif4+V1DCo/dOM69eujN3rPEycc2LxbZqJp50EjqTSlltleyJ/tBJ+9CbYHe9sF0UPOcHstsmu3hytgyCuAkTgS3QPifuCSLHMJsOYhXgG4oDknOKt1L5CvWrZ7d8Q6+WIE3pzBPHuWG6JWNCNrvvw8vrVrXJk49RbRYAHkq3907z3+xCwSMZgtJfbREYHOa633hQTfsTsPrJHj+MOPpAdVAc9c/o48frLmN/jbp8uAo/YU6ryoY6j/I5Ze0TO6z0FGFH3ay0xlikqVuxVhvzfCn/Ta2/scKaZFYbSZTDETB0mQyfmNASsms9Rh4q/i99vsQcUtKUCHkdc
 mHS8M5U1
 vNhs4WVvHz2Lwvah4hwFk++DYTVmf39tupteRSmoTGIQvlHf9D8z0Vd3nbP9CT9up0zFu6soOedAOr0Ka34LQbymRsSW5HwwWc7WSHzwqipLo8Jc5k2tTRasjxlthRwbl34vKGIpRZne2Cu7SxO0dw0xccyni1SSiey6RONtCNyfxnDnmBRWRS3ODovXT2lY4dfeKYlOb4Qb/8lrhI9veevYCyN/KwYeKCstnxXeCyz50HaSJ8NlmSc5V5QXFTzh2hBDR/vzD7O4jJ+j8PeCPxfv1p80tIGpFLEyx4NhOgTwTeVPb5OLWKWIGEWO6k3mAKDXybUraxI2LPoslTPCCtLBtNvoXSLLdJ45DGNEY7xZevB7phu7j/qwLlyUSxbuwtxyzK98BhGfn+9b7M0k3Xtl3stA3PpofdS5SB8s/27N9rkvDVan+Qm93m0pKqAsb1+7SQ9osTcUsquw=
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
index f03af2c46426f..04e457409f75e 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -323,6 +323,80 @@ GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
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
2.54.0.794.g4f17f83d09-goog



