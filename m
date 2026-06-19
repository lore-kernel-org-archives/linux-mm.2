Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA05CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2186B0088; Thu, 18 Jun 2026 20:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989F86B00C5; Thu, 18 Jun 2026 20:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F9C6B00C6; Thu, 18 Jun 2026 20:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45A7B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA4A61202EF
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:13 +0000 (UTC)
X-FDA: 84894785346.10.5128DE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC6BB20004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJ65TqOL;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFhMk7oRmLprUjmv7iicXUqS4d1L4+NcROu6Mls6/mo=;
	b=x/4o84sxm7m+Mw1mD+D6VMwGCdbnrPZd9PsdjDoZAhTPqHAB+SGUIROZGnu95s9Ltm88nS
	+Ny+4+JXQO3ZANcQSXyfQvGOlHDC43Bo2/q90qWDF5vSUI0COa/xudmBvTRsQVrjDbEk9q
	s+0BtDQzZS9n9IhMY7p119cbkDtZEC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829131;
	b=xHxBM3Ih4aeM54rpZJMaL6H63l+187ASJeM+Qotyq+w+0u2teSCeKbQGFxLb5a7e4PonUN
	+/vuvESQJewiP5KLzmlvqYfOFg8VNHKHNi36fpA2RG9laU3F0OzQUxH0Qcv6r+bow2C+Ra
	5HHf6f0QeCfw3LU0cJtig3JkpL/dyhc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJ65TqOL;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B78D344E8D;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F72FC2BCC6;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829111;
	bh=tNAUmpS5z/21OzG0te8pXUP3RWNb3fTiwZKRQR9IfEw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hJ65TqOL5Pw53sHOXGFblAtQa460JhiHQh9znV0nIzA+d2tVESXYlEYALmbG0yuRb
	 qEKxuDEZXyS2dSsvROy903yvdzXfPUkUighwQtNiCBBwqOlsyNW+RwZ2uFOS5yJ91L
	 T0l18WForui/BRXAPoFVTHMBqT4kjf4VBoDWKr/SmMuq9M7Hj+cUrY4GGBuGV1/SMk
	 7+ruTs3gTymB+lQGOSxUmuKf1G8rXfiTVh0/xO0didMm8vs/w8uI+eGW7HPQRFN+3M
	 ud4puQ4NBWCHMjxkRgw08SVjJBH+Xh6nlox1u6z+FUSTwzfu3wJfcwKlARJZYIgJhs
	 WrKEkbUsG1zAA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815B4CD98F0;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:23 -0700
Subject: [PATCH v8 46/46] KVM: selftests: Update private memory exits test
 to work with per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-46-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=3722;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Vm6B0jcVpnq5VhVcR58Pd8s5Kl/3lbCBJGBKp5XlmQM=;
 b=nUID8/wKDEk3EQAynE5ah0zGcUawuGh93RpkaOZbh45qXiO2uL0OBjgsC2lb3lX+NX4uC8HGM
 bZfMXvjceB2B0XQ79vDuL7pM8Ke5ZKrxDSbvgzz51c25Ih5BQioa6qU
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: BC6BB20004
X-Stat-Signature: g9a4xn49sd5qnqoq4uoqxpt9gkssfs4g
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781829131-768942
X-HE-Meta: U2FsdGVkX19CqAoePZS/jEVBc0rXzNNGWsNln3T66KMojJ/QjXZ+Gx4EdWC8T8Ks3XYcpRPyaKl9t13+vBaGiEt9yMe2YU5rrgnqaNk8URBFIjPdVxH5Yn+YqQC+Rvv8KKDHB0ENxsu5/649ktG4X37jlADpo7ixjjDqAGwIrfbp1Gx19PKAsCHe0NvfJu7qy+b+jXf9PuxTeP5p5xBZMOMtk9Qi1lqmGOO6xvGGIT/wM4K8q13fuN1sEjCzhMy+GeYlVISGx2VOGTnCpj2U3GX5mEGnOmUHcEnjzkxP0FZgtrOTLijTDTLgCJaIcthQm3cqBrwi5rvnwcPq4DrD7Sir4ucJFs74cSZ3ttgPE8JNPe4EWcuLwIY6NMiSKGxUIDhAp22lDZ0pvUWlT4AYeEeiaPBv4DwgECqGj+Y9LsttXkytkj4f4L3hZrEbRUbMYPjXR0HW/SrSVQdYVwHWUwkYeP6wmQ1ERa/uvgnxiigrxhv+NCiuW5s23B5FeuV7/Su4edSUfbh7R+RbWSjtgSa65mqlfgxuKY2ymQjMWIjQ3tcKben4WTDOniHFbExOJKVVtCNL+ezgNaeEP+wnY/hY5CQSVACwfmj+JSE9Qx8KUoIrj9S6/M194OCYRefncj98Qw0VG8RHIOLbcB2Gvxt7lp20/gLl2Q++4B15lSLaR+jApsTqqB5FOrOogK7dJFk1k1z22iY+qrOtjXtNHlB4xmJnTY0f35QbeR41NZRwoEnaaCrBWOccpmK/VDeQ4LWUmx7ICCc0wx66Gz0uEVe8bvPIYQKCKVEVZ+Cg2/pkvXDxHaFw2YMGeLGz5SciOghBn3m5hgI4fFTxucwL1k3kWxEssYMPlFnackOqkJtQhBxJsJ0XpBL6gRvCQUbk6fI/FxfJBNvsc60pq7q2erKAo4TGq1xYx0M5/RuS7YZE5qg96vD1hXpjt6qH/OiY5f6Rww6khNhSkYO+8Eu
 NK1ZOJm/
 s3oXuKBarD4Ut+2sLdaYKakbOwnVxB8twsByNM4dRtZ8hWpy24KiHKDTyTDh4XCtL+El8uS5p40qO1F3oxoanyzW0/Au1WBOd9M8XmAiGX3xYN31L7WZk/wTv19zb1bh0bCH+koVckQekzxbd7ds4x+Fzhc5Iw5n+nr0uZ3aV+nWswlBFUwSHRgjHV91o0KO7fzYXICcj8Iae1y/cOl6XrjpqtNhMX55WqZT1eKRBhyGekSOwJlxRZVGbS4y4PTzqQGfrfCvwqYmdbWW3oI6UsjnPo8K3a1/4f7+yg1TDgwykrbql+UL36+kOFImU0NC9PRAAvi26NNNDZtFPD/OPExWZyWWVohPRm1BDjeOSCoYeDEJoakcFJwG+tOWyBQPsZnwUWKrvh7/KYXL3hH1CwgySsfw2PZs9imFIwHieZxkHuNOKX2iQ90GBlvlwg7rp9ZAx9ZkLA0F8aFQ=
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



