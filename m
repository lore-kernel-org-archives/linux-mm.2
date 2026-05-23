Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1DA0CD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C436B00C1; Fri, 22 May 2026 20:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9996B00C5; Fri, 22 May 2026 20:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713C56B00C6; Fri, 22 May 2026 20:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9C56B00C1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C125161A37
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:25 +0000 (UTC)
X-FDA: 84796772970.24.6B0F4E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1511C100006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jW+U1MWi;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495503;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aQ71Dg9ruYwGa/4CnVnCeD9vwNUMrkxAyCneWcrnKQ=;
	b=S6A2WmGlfwGbHJsfnvr9YETIbb43hPjdURsqKZC36TfV05qd0S5J2SrV7+SG8EIKuh3DE1
	VA+iA17NkzWBnE5Guz14VsQT1I/cY6UYMs+wmEdQWk7MB/EvPInwIApf+ZZ+dcxuyv0H/i
	1VXiK5dJhbUErNCaCM7FsRHZ4cbLPWY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jW+U1MWi;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495503; a=rsa-sha256;
	cv=none;
	b=ywWqOt3etZK1junuUoF4rvAsKn+C1+ksBoGwgvxZthiakyyKBE3ckAYkzEzAUZ49VxTshp
	OmRdCco5q1LK6pIUmXhaVJS0zicyDTAMpS93IbetKL4/pwEt8pk4MKRyQUXYpyoMAgP/2n
	NxRmh9i6hr7tVcwJvaUM4+NqFR/UgQE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63DBC44E62;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26017C2BCFD;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495487;
	bh=KiCjq5pAn/ujlUTPsvaBF27LUM2KY3nYlbe0z2G+roM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jW+U1MWiQJWom2SgPlokK3cz0WZ5OxjtbHGHeqL9An4Fdzj0zVpYhSl4Xa7G/sRZi
	 Gb7KOhf2wLpWDMpIRCqocOHfQ+gp9z/7qYHMdJ2mfEqeDI+lcTeayo21kLSI1ivs14
	 S0majg4erGq8pGPr43R4I1JiVWt92DCMBrZiY12e7sEq5E1YNS1lNjMAFB2faPODnS
	 LnbeUjCpqrmu57G70UXM8HUEWqWplOUsq7X8U029URGLGrhbW+qrFtmZOD3QUd4HUb
	 M5RsHC0y/Gcaon08LD64WSoUtdgaE3URFbZDysslp2sWr39spl8qqHWokFx9Z1VOAy
	 AAoo4w/AnTh+g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2C2CD5BC2;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:24 -0700
Subject: [PATCH v7 42/42] KVM: selftests: Update private memory exits test
 to work with per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-42-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495481; l=3772;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hYPink6uryd0sBR7FpUwEPEeeMvCkWE3NN5OHnrBbd0=;
 b=aMa7DgNRkSCwfgv8CIcxEnvwhI4+vvJrCFZfSdUdGE2Q6RqmCVlvuXPdDhX2ec+I5ktjI2RFF
 IDi2tcrxpkED2WPa5qzWjw+OTdH6o5XmuBdJ75HAU0/GiLoYn0RHI+R
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1511C100006
X-Stat-Signature: jqa9eeizb5q17z7mq5nf5irgt65qeap5
X-HE-Tag: 1779495502-707115
X-HE-Meta: U2FsdGVkX19E7zP+UId/X16Rq/ufRGxy2vSNsmkTKc9QhzoMdcJT/pZ2snvkPiDrhy5LSxkIbYIxD7i2otOap11cCi6oz1baYnPJMV3DL9Up8d1RvNuUfhQptaf72wWoVGqDXEbcwQrl4NbJpNWSZ+XcDLwDtnK+VN5hF0bTOXLACaMMg9x3jmvkD1W915Pun/DGqr46C05XS7fFOCGgwG0fX8AdYwL967gy5/JhDYHJfgbIBsO5V9/PREsjDsJQfuI9AeIKmPyZ/eSwLGAtaCXRF8CL2582HcAD/bJtFPcIdYu+A3dR/Q/eHdRsFNeXsrKglNHJfiIhi4BHT6neBxdWBAS3xX5NMK+wMXF1OppLqVC1muPg6oRangxt8kJaPwHFafasmGvXhAo1bKqxxm1Hwgom+SU7Y4jCQUZ9oGN+vtwktWW+T+MB8aBz3IudUKwHmB2P2CRe0+ydd/d4yleTawPXx/fUSM5EEVTXVoQAQphAam8+UyiJyHxcJH0i7A1BrvOoJfRrueOqJBvWPoB9qP7QXVyDA8nPWVAe+DowhH/+dN/axLIPMqN943MuPksQmHtlq+etpwlPiSRQ2zoAX6AcgiAE9E53Q0qKsHuIbxu8aIQM3CFe0Qd7K80KLXNVKm5kzc8xBakRB7EEnOENGjQG1iZB0ZtgkN/CqKjoz2W2JgIlhOQJrpwV5AWdg9AEOHfLgOtc4zGoHC03QWOaSliNJDqwT5P56J/yGMdff6ho2Qql++KIWVkOl4/8xABLETC2X6b8CiGz+Tu8Ej+sXEZWUBCeX0/UrKopfOgVYW3lRfXljXwymvbnwkLWIR+3+KM1jDDz8znU2IdwtJAqNCPDnxs2y9qYn6pa0oQit+Pk9WUdfEwBI48i+WsqOG865uD6LyRsWb0JOQW26SI3UF6uuoQ/WuGAi8kVyTV72dI27AO/IgTIw/7luLRjITiYsK+kFQyiUJZxj6p
 uuV8jpFz
 FmX3RZ2L1tWgnBQX7DwVk0ChF+fTGwzuapxWzvguGLhPrLyQ4tkVzUMoFeXSlpneLs/LqfIaAwsqUJuSMN7IoHEGhwKAD9nWPCmCW9TyDryyJXhPMl/kBx/GPre4qWfuKF4nPCt4kSM7Oy+E3F0v3Xlr0pl1AU9PRC2gqvyx83HOqXY4L9sOsOsa5f8i7L9QgC7B5aavhuIieUBDkd4UU5n08h1hRLwprFc78CYtkCB2ODCkSie45MtJ1sjRHNR/7xOoO3MRMWEXrguZQyqZ89BrIqzVwl5I8pKBseefsLV9RG1B6VwQRQkvjAE/5NXUsL1hlwIy0EIgfj7eAccB9IN1/0X7fyLsTfQ/dJkhh2s39Q5SRQj6cMynzdTBs/g/IcejkccZaySq17Qnvp5jVmLbIKgYp4DeMiWtY
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
2.54.0.794.g4f17f83d09-goog



