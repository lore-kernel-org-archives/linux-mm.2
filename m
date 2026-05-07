Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEEA5CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A62D6B00C0; Thu,  7 May 2026 16:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EED6B00C1; Thu,  7 May 2026 16:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246716B00C3; Thu,  7 May 2026 16:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F38326B00C0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B4E41603FE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:18 +0000 (UTC)
X-FDA: 84741748476.29.ACB5777
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2290C40005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XQ0fVhTD;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185396;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DHY/y9gFTfZGBlll2BW8wKnVi2ytRQM8+P66kuyjqe8=;
	b=Z1xzNd0ag1mwgu9FdV9cqez9gyY8Mw3qW0iHMkXZtmmgIYamMB97gdj6SUj5RNvLB6LYDT
	FZlm24tJgiESc1+JraxsOxu9D3Wp16Zck1Dje6xk4JxjqUzxYYdsGEKO3aZ8X/5yddWxd0
	XCQKq41/aDISoGi3LjrOfohqJLNEydk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XQ0fVhTD;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185396; a=rsa-sha256;
	cv=none;
	b=t9WNFqRVNmAGNgfeazPbXRIS/4OelJRA3kRabtquhR7dJ+NMpXcOAPy81ypeTwWQCiiMEE
	+biojZV1nQtWIJS4poAZBz3/NS3aekwv1IC4lpSnTIfCJfcq4NDOjhz6C08F0M0hmYEJeO
	oL9/0DwruzTEs2Zc5RnX1oZ6zeQKCK0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2E0E44926;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 945E1C2BCB2;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185373;
	bh=YsF8COWix+6Yxb8XQMDjxkfCqLW4zILwB+rmik6M5mQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XQ0fVhTDhJP6SPeSC4SMnPAACq1rJ+oht5+P74v03LqecI7lrnv0WGsLBrhHbJqlv
	 Ll4yiSxTGAP3oFJwEwkdvrFr39szvMAu39mOyhBE0MJ3DGMnNCZn+ubaIZ6Qrr6HtO
	 gho6fLSvZBgHa6+aadC1+c4g6QvcTA4cSnGedwixWa5G3wptq6ReVY5mgich+HYd0c
	 OmGxPlVRcVgZl9+q2EzxyezbuHWGtDD+V9i2oCnG7A5/YZQctd8Bt0ofoAL6nINofm
	 iJe0D52FSoUiU5/ef1lsj9YmIjm/2JtywOEyVOfAsIAvFRs2hwPpiFa/PFAKHxseCj
	 OjIWzW0G2PSUw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8702FCD343F;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:23:02 -0700
Subject: [PATCH v6 43/43] KVM: selftests: Update private memory exits test
 to work with per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-43-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=3772;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ilZNigktr30OWW+44f6wWT3BpvfT+Tlf9WIw7xVQWhA=;
 b=RQQ4ZC6yPw+UZAXfzoD0aKRDxzFge3XopvPgK6qmJWMHQatSwRktfz4EuYp2f+79LWhBgyK0g
 Fz0LXdKV1VPD5JTPG0+IaBIN6RgGKSBh9m0iv9m1sl3WAOpntYe9Zwh
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2290C40005
X-Rspam-User: 
X-Stat-Signature: u311kmmf3wi6454eesyefg83ko7w6nse
X-HE-Tag: 1778185395-114293
X-HE-Meta: U2FsdGVkX18Y+4IBi9j5LZJJ5UQ5JBZEPSp963Abqxyyz96Ptdh2M54eoNhRprXr6owWDWMJC22MsK+HqbN8nrE26nCJlJh1ibSx5DROz+Ruu11VvRF4IEF62cYEjuS1eTN6eMpTedCSMpzVNqh4KWLuU4+ukPZw/eQzUJ7dmu9WVpYZrE83ezwoaPvCjg9kYthUrQ9FkhCgLf5nXu2HpOlWbFblFMDuYCRgM6dVDIAPFG65m1AJ8LqNuS5+/G9xHNR8KlQRR8pkaejvVjIcj0uYJK9UR6Asfii0pJ8Ot77wyHe1wbktatcqaHl/SmmtpgYgZ05YrFBS42qw7rIr1RPANqE28WlP6/7COxVrC2YBGkEZ1ZW5gdtV3iy/IGfGAiGg/lcQ9SrIpHSN3kn4s7NKSJy+pNphvP4rg26yBukuPE8QlDuM7VMk5vwiUcxrbQUeFpjyn8JWcI3NEO+0gArplOI43yBIXsI8qgqyhGgmyQBGUCNGmFE8euzAHI1/hyn9Ems+ZM/G6Q/qgSVzvvIbkV4leP2SE7JXROZXruOssmDt4Mh/oTQjZ5tL0Ct5IvlJbcVQBxpc+Sd+36NtNCXRIkxo7uQ9tO2hP6I1csl5B5h97TupldRAJCQsg93p7SvzOOs0zSLyR0h0icHUapcgPJe64dWnhgKKcMH3nfhXdOiQ8cmT93WwqDDR8cSlyM1l41BLpBJJJ7MMCjL7NPt/MH97jxpY5FgcT0KDEVRQJLOli6HmWEIK4Evz+jGjQWA+TkmTxC0LAy0ty6/kmF7/O+OWuXoE0Ltzk4Q64kEzsM8oSWT7sru8upL6GcneNUK/R2I8Yxqiu1A6cj64rFHxnz45WQy1Y9hHky8VW/9wrPcSDmKhJvDwKF8Mzfli/qRmPBXJ7YxFy7NeJjZlh5Z3yHUyg/PH7WGvIM82hX9Y7CgwhR2CQ9WdCGTTyUT0pgtYJMNdFseAOadtRN3
 96zNaoVE
 a6pHxcMsRCN7BDpxzqrqdc0R9DOUHYbTl/1dzWfIcJDqa86xR02pFjMGecS3Ynivh0LsiJvXklkndcsLxRZN70/e8ljO6c8j3WknqSRblWODo72W8nldTDOvVP6rAg7cdqlqxnmp6ouugGK/wa72SBDkgtLWsctBcUfdfCTVTRvoIznXj7dXx46iFaxR1TPI1XGBbQsuR0z3z9lEigP6BUCscSNb9m3OBoBXw3+fF0yUJmFaUuxru48c3V3Dp+hXEuolOoCP5P+m1DgfaN7WL4eeq67ukFfewxtN0CAS42PEfAiXe6rkBgM5q0RWl4rWpyuNY9llhZuOCtjlkB3yvM4+kdQdvFGVoCVGx0GR+OTlilwLcWCll00a0zvU0Iyi1+O78yafsNPw/keUmt6Fy+MCoJJpeMm6JYy3c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Skip setting memory to private in the private memory exits test when using
per-gmem memory attributes, as memory is initialized to private by default
for guest_memfd, and using vm_mem_set_private() on a guest_memfd instance
requires creating guest_memfd with GUEST_MEMFD_FLAG_MMAP (which is totally
doable, but would need to be conditional and is ultimately unnecessary).

Expect an emulated MMIO instead of a memory fault exit when attributes are
per-gmem, as deleting the memslot effectively drops the private status,
i.e. the GPA becomes shared and thus supports emulated MMIO.

Skip the "memslot not private" test entirely, as private vs. shared state
for x86 software-protected VMs comes from the memory attributes themselves,
and so when doing in-place conversions there can never be a disconnect
between the expected and actual states.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c | 36 ++++++++++++++++++----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
index 10db9fe6d9063..70ed16066c63e 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -62,8 +62,9 @@ static void test_private_access_memslot_deleted(void)
 
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
-	/* Request to access page privately */
-	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
+	/* Request to access page privately. */
+	if (!kvm_has_gmem_attributes)
+		vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
 
 	pthread_create(&vm_thread, NULL,
 		       (void *(*)(void *))run_vcpu_get_exit_reason,
@@ -74,10 +75,26 @@ static void test_private_access_memslot_deleted(void)
 	pthread_join(vm_thread, &thread_return);
 	exit_reason = (u32)(u64)thread_return;
 
-	TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+	/*
+	 * If attributes are tracked per-gmem, deleting the memslot that points
+	 * at the gmem instance effectively makes the memory shared, and so the
+	 * read should trigger emulated MMIO.
+	 *
+	 * If attributes are tracked per-VM, deleting the memslot shouldn't
+	 * affect the private attribute, and so KVM should generate a memory
+	 * fault exit (emulated MMIO on private GPAs is disallowed).
+	 */
+	if (kvm_has_gmem_attributes) {
+		TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MMIO);
+		TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, EXITS_TEST_GPA);
+		TEST_ASSERT_EQ(vcpu->run->mmio.len, sizeof(u64));
+		TEST_ASSERT_EQ(vcpu->run->mmio.is_write, false);
+	} else {
+		TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
+		TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
+		TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
+		TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+	}
 
 	kvm_vm_free(vm);
 }
@@ -88,6 +105,13 @@ static void test_private_access_memslot_not_private(void)
 	struct kvm_vcpu *vcpu;
 	u32 exit_reason;
 
+	/*
+	 * Accessing non-private memory as private with a software-protected VM
+	 * isn't possible when doing in-place conversions.
+	 */
+	if (kvm_has_gmem_attributes)
+		return;
+
 	vm = vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
 					   guest_repeatedly_read);
 

-- 
2.54.0.563.g4f69b47b94-goog



