Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA5ACD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94706B00B7; Thu,  7 May 2026 16:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C1A6B00B8; Thu,  7 May 2026 16:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0CBC6B00B9; Thu,  7 May 2026 16:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E98F6B00B7
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14A8E1C050F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:09 +0000 (UTC)
X-FDA: 84741748098.05.E3F6C2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A0F1100003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J5WLqvCW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185387;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQdBpW64Ge1y5nmQG0UjxDlbuuslQ/u8fAnu0jeda3c=;
	b=g28HXdFQ1lRlBlDgDIZmeMBxnSz1fOSucQbR7lAp/G0ECcUX4sjiRoHVsJ+ya5+Lu+2y9f
	PfDtYuEzjFPyT5HFi4navZo5ay/0VQ6+rXOtOHBgDagV9Odpip+7NEBq6Pizw05R4JnDdh
	BKM3xzrgR6Gs2lgsAnpF6nNhT3DJbEM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185387; a=rsa-sha256;
	cv=none;
	b=Ch7IoW7s6fBzLAPMpGmoaVBbXVe8ExsgeaNm4cBYglKxTQj8pWajMLuHl6WEqnSs0nMr+a
	x6+NrQiUWtsEg2OONF3RwkXUOtkoLN2qhGpRfe7/OhLS2WOfhQtklK22D8bnHF5UdGpx8F
	W7Z2ccQr2QRzms2joV+ulwKljaSn13M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J5WLqvCW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BD6744725;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A67C7C4AF4D;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=wb2CsjdVWQPunqgfq8q1u+5NI+J7zzN9yC4lznoz+lc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=J5WLqvCW3p/mqhxEODo4yVtRVM4C9m7oUVW4uODfzu5rU7irFbAiBo7Hb0T/DPfLL
	 2dcOlguLdf/tlAOJshiPhyiYsx5NZiGZ6Xo3aRpDLGKatORzyVS8BhkYzwo9wPr/UF
	 6qR9Lj8eEBdMoyZLNWO/45dcEwbJ9l1wIIwpi8yr0+2uVV67zzChhq1HNVr+VAp/yE
	 wSF3kE080gGRPnBwELHjbWGETRZd8TaMe7oTzzgl3tmSXh1YecF+o1wG/q5YxltaGA
	 9yfqEgOzHrA1/vQCd+53lrSG5PGQKPOBd8IBOv0OKenez1QMl6Z4obbglZgefXNAa9
	 DfBUdmn9AzMWw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934C2CD343F;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:53 -0700
Subject: [PATCH v6 34/43] KVM: selftests: Test that shared/private status
 is consistent across processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-34-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=3473;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=MrxYeYSTma0Mb5XDzsYrqnIjX6xeEwn3G6JnrRNoe3g=;
 b=0VEP4skWhIQasWMjxcAcMDpcs459UKxYi8KdDS9s3bb1dg3rVTnuVx6nr1Q387wZ6AyFWuVYZ
 xPqbT2t+67dAu32GIEYRnXHMoOH2qaV3dFEzK28LeXpEH9K3ovaObhs
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0A0F1100003
X-Stat-Signature: sm9bxqfiqmommx8c94rhn4rgnk7f5oby
X-Rspam-User: 
X-HE-Tag: 1778185386-345632
X-HE-Meta: U2FsdGVkX19Clm29Dj6uL2o/Y/2ABNBG3i7dIHNmOQfd/KCsfVn9rWvcn48nhF2ILd1UWxDI/61+KBGgO27i7iG+AU/uw3TS3dg4kbmjwW4q3sg6cs4bRJSgEdnKwJmwdeYbuyQrnTIlOyw2pazFO78z+BP7fah4GdeqHqQD0lwNn1FHnYOF+euJXra8fNs/q/Juogxytfx+PFJTyu2AMEuhOjSdwH1CV9uf2cYXJEVmFSNgNdxU5+e4rBxZWjYIZgJyyusiyMa4/6cuBfNlaZW5A/ORkMIQ5Lezy7J80wMpWcYpZ17p+h/Wy7soKU73I8KI/hE7c8fmFu8LAJeKpVShzwHr7+zgJhQsqC9yqT6j64IIuqw5WbhQM44+GidFfQNQP5IraRXW5JXax3Ms86piGedKfGv+zxhKRBiIn8LGqcImYRlOJ62AZk7XMQoBkTAYNqMVQ8aaCFURWSdLIEveh8DNNazTMBt9/WTtKwBNrrCqbS2ABHdk60EJnvzwP5ELzQ7nKqfYx6pGEkP+Xa0e04LfEFGfEsgBA9vJRlUPqO3+A4FGcx4pEpD4eRo9wFAAymPNkh0WVdbebYdYpB9GedS4TQoY0fikQzRvgZPm0cx7YcOH1ZvWittBOrL+PX3Mr0zPD8S+NJpXw6zLMmPUjqXNR6jYNbDaYOHnaFOBx/ZQM5Ef3l04n9ZT9RG4rA36N3VZFbaOeslwEQnZr6l0QaRpYr+wXniM1/fJzTBSsIi0g+LY9nlTHYSxYDdF/PH1fZP7h3jCCUgU6U+r5akfdsYy8odZF3TckSl10mi8Ne/TqBZNGzElLmpyYz1Y/TBcpZIAuipyE+39tFMJu9iXWsSjXyFqQrEcOJ8TfxAuhbXwpQVewqM9CCQwAIdZAQyClGk5opIIpkZss31D7vxe8fLFRv5eaFe87dKzQ5xLbygZS65jX3/otBW9go2Lvqm+Gj7qw63QiFx/+Hk
 03EB9WXh
 72TPoU+L2VyIHjqLjh01pJceLSN6PScEW7mxUtoQz8K/k10w4YsnM+tc+1QAAYDIfKFNysb9bD3fkaTzQPfRR2oX3ssB+U9rGGmc1XPKrr8oafEVWnyvE+6dPCvG5W2Am4Nj3nNL9Ptkg2kMyc/8HGbG8R16mi/KR5uKfxB60G/dSxn/YYWn07e+0vWEOMwydS5iIIFzKaRrTh4SEDesJIlMDsf1Yo9JIDmrNI1sknT5FjObtf2IzBno/D2iUgsVM1nCgVSrOi0WlKiMgTd3OCCFgyNRcfUZP7MBFP7rbMwZqr2q5PAX5u8bFmaXcbqMyDOVD4hlgJ4XSI58WtLPttZUkCHtCk53ierscOjSN2D1M/nao0s8tose1K4xnGKQR/0FJLGBJDL0q6rJR2QHPfmD6mcuk5bW1aCFO4a4biKv2TF5hhJY+wMXAexX8LrlFBgJJPsr28Wt5ZBc=
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
index 960b2da8dd16d..4c33e21f04972 100644
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
2.54.0.563.g4f69b47b94-goog



