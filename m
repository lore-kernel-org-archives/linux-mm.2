Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF4EFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144BB6B0092; Tue, 28 Apr 2026 19:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07FE76B0093; Tue, 28 Apr 2026 19:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A626B0095; Tue, 28 Apr 2026 19:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D4BA46B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:28:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EEDF2160533
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:51 +0000 (UTC)
X-FDA: 84709549302.21.1798388
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8390310000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NkFGQkhT;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418749;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YU5TBW6K7CZPucdXO3yB/O/fHIjVR1WMMmxF+9gKgUU=;
	b=GoF0Oh6DWN5FpMbZMoz3BU67QyGKD6+MGOzJLFRKxSXdTTl0H0M7/94hPfqsfrsUAX3Siy
	pEL6AfdI1dkxtBYkFYFmNfyhB0xiW1HZzIdoiMynSha6sF3l8bbGkzvOSZz839z4i+7gKl
	evHAxph2UWhtbk916aRGPnNXaUNYwTI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NkFGQkhT;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418749; a=rsa-sha256;
	cv=none;
	b=JN42jCmT2S1X1yUMY7bADxGT55SK4+gLP5qAcorz1Q2ZopnTYpWCTu779j5BAsgKTlV/mT
	pV0uHTbiwnzjeRPMeh6HDp+AuDxS3aK88wlgppgaSG7nEfE8J+05ROqIp8uKuW4l37KRXn
	5n5u9mR3mdLth3QWgRvsJwV6+mmWiXQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB14044758;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7880C2BCC9;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418721;
	bh=7TWBjI3OxAUYZj+UneVBWzFdFelpn4CAc9Eb9C+VbsA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NkFGQkhT4VGQfkjzXNid1heAsxml10L5BGZZ6EOTtuFWApiACZldlDPo1i9hFQ8Dj
	 s/2WVxWfznLYdMaIGRP7KJWYpD6SZXQELk4r7vLy4QR/ghIFLcDNj5jSkEAz43Oufc
	 uxaEaLhew1U/ejPF0jYNy+F76Qc4IyBvXVY/6I6XSL3j5Vm2Gewm5brQMeQB/C/e9Z
	 QthLgB76cMPqq0eeNDD2l2fgLjnk9He6zCTGhrDk6RXGT/LZTN5CwSeqD64RDWCXQ2
	 FtD3NYPrA0qECScgVdtOQ9aj7a00SxTiRqeTJN6aF+diK2PvaN52csp+D+wtVM0eAL
	 esoiJlXzKZsFA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFE1FF887E;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:48 -0700
Subject: [PATCH RFC v5 53/53] KVM: selftests: Update private memory exits
 test to work with per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-53-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=3778;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=VPHJK9sWgKRQC1WS9+rcIzMlY5jj2NwY+5XZf3L4tTs=;
 b=6nli8lXsnVmi7WR7iNKhXLupaTTnxmJDXZhik8mxwv6RIdW10qx4HRVm/Pfug2Ys4bRTDZiE+
 6Pgp4Ftn+SoDVqs3KMzEOlW01gT8LFXXr0g9b7EKS8b4k04bM0TRWQl
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 8390310000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 78i3wo6xu7rs58zwxoxmjdb9qo5quqyu
X-HE-Tag: 1777418749-276539
X-HE-Meta: U2FsdGVkX18CK9BAM1VHo/PvdyKIwdPmYiSc4EGMZ3acJCCEj/HU/vbGmWk/W6yUk+1Y5sIFEPYT+UCMGPAtC9BJiKKZOQR9XBs1Om579ekpntYSfDtjcsqgu/0x4s8Q7ScHhG6wImlLHJETwTjKWwGnrsaUIniODW2KIsLm7AvASC2zHDfvLREntaMAgVEL8YxpqDx8RqXBSLM4ay9qH8smwyxTz0iVppRa3ySwuxfQbsfLdndnjWWOl+nk4Li5S7Fkos3bXz6rid08zkG+9W+aL5i5HVNqeZoxCWKZitGvYZW1omPuJmgeSuTBpdtYew+6TfU4mpKqrJVe3hYX32VrzPzSGWrNBI0Rm0g+PRGRXpxvpDs4vji8AeZvAC7s1L/D4wbwHNqd6EgrHqSrxH2PPC4+NRCAVTA/2lBY72nC8UXYim1Pd8Bq+D8MYWmsFdLPQC8yp/3V09ftGXqsnNDOj8yuCknlITQJ4MQWwm2innsRC/6Yp9LezsMD/KtZOTnM1QHcB2LTXcLIyFfPlUzJ4mdnlQXhmPhFzLUoLoSeQ7Pu9Yeb110va/JwmjGwdKUFFLuhR5XVUi+Ns/Noim8MFvKyS8VGnqRbPAxRAT+VC6KJ2mXdJKTltOtGmXrxQvDQ/F+RcK+Ql5ce0h7NigfDQKXLapnVbfEGEwNJ9l91X1C6UN/y7Z4bTnmsrYa/hN3uQKpLiKnzKVQLKFqIUy3Sgho+gZ0ee/QA1e9SuBm9kn7LvFbrAUZmTTKgzgPjfruKXVh1A0d9hzDNu8DbB2TC+nLjhOK9OVRcsVoUbGQbofTED4vGaf4rEg78e3v9a4P2lHZzhtMnC/XaC/H4c7HR1/qmb9PoTZkf0bKQfy5TECOHZgy5thllJMjViT7/RznTvPt5PDlSZxGplsQmQCpauObwsfbr+KaB7GHZHrIgWryQlFVWQMARndXNnDhFsSKMbTRgQ/M/VmAebSN
 QEc5tLjD
 USugLg+n7jIKGNxfcc57P/lvQRBJrDCsijHR6UsthVF+WID2R+ms+0So/p0N+6lDlT5v1E16sXhGCV1kk15kE1dEicU/4tBuyWbtn6eURnjhdUKk+OoIBkqoMedQIR6Z2ynYxOu1riXtQbIoqNH4C7Hp7/NxoBftsdoKbX4YAPyVpeZFNosY/FMX635a7Orec1llC9VbqrBtwYJ2/jyesRZuactG5L+VlfZuFvI9s5TIqEuOZJDL5xeyadARVvc6kTwP2RPTOLor2UCJSqq4H6mVO+jBCFbV9WQaDvRg/6kE0iFSbkUIj7XGIMwXFkEheBVkqI3SkF+DEMx6/37PLABvgkw/1ULvEXU2yuM4J3Od4ao4m7gN6d5BWxMj5KVR/Ws2A+iN5QzYmpCpdXcmsk16yrbwQBQUKs/fu
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
index 9309d67841482..0bf115faeb827 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -62,8 +62,9 @@ static void test_private_access_memslot_deleted(void)
 
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
-	/* Request to access page privately */
-	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE, 0);
+	/* Request to access page privately. */
+	if (!kvm_has_gmem_attributes)
+		vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE, 0);
 
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
2.54.0.545.g6539524ca2-goog



