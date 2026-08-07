Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0423CC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00836B00F4; Fri,  7 Aug 2026 17:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAAA56B00F5; Fri,  7 Aug 2026 17:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFB96B00F6; Fri,  7 Aug 2026 17:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB186B00F4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 258274005F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:11 +0000 (UTC)
X-FDA: 85075824582.10.0D9893D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 30AD340008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6k+aRHy;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139589;
	b=dCSNa9B+oUrgpgRXCR+gR7kGx+1tJZHMUdpzbxBZQgz1d45kmlBqbhsdXL/AR8FGQ81Qzq
	/VjVKJDklg6ujAeUJKdngEqypbbXN+oEtmcqtzE4ZHjVPB378j7IqDRfN+DuUevRAJkrJ/
	UYkrT6ugMLEQrjWBoSiiVTpZADe9GQU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6k+aRHy;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139589;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79olWelO+aGew03FKRtwY5cBNDISmSjCDX7W64108/A=;
	b=ZqA9Vnr+SG/bXz2uNvQ4xkFKTg9pB5rDvj0sYs0qnLjo4VOyDqAFEaZ0dku6A/ZbZzo1iR
	eWkhNc9eM68wnDGb32fUc49r+kqKiQ2nadPem4DZEQmfLoP9Q8w5sFicU51oMvEjllEjW+
	TOaI1cyAvSVuDE4l+3qKEXLt/9EMC4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A65045301;
	Fri,  7 Aug 2026 21:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6D3FC4AF11;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139571;
	bh=vTCEVKZlUYGO1D+z51D5hocvKIebLL912PEubVOUuJY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Q6k+aRHy/8bmQ4Ezu6BObDrvY1H53BJJ932ktoEJCl5oedyReWQGnyPs2KEYHLgFT
	 WUH+v96gxMjmcsUcrs0vuFYx/KGgKTiJLq2pTJtA1ut42GpTjG9uGqt1/vqL87Wu2p
	 idOM5kcbg6r+rjFxfHsUZnwrJM6iOWlrxWvyjE8HQtwLTMgCzHeNC5elR1e73WnSjP
	 Q0XtYxNwDimp50R53tvWS5AvEbzpwYT/h2Wqc55+KVD+0IJhhmsUwryl8tilQ9ULTO
	 bRsqtlROQ4R0ALCGNyLX4rPcxu5T81v9p2QADwH4HsuxQJID76bqbwXHqvUMy25omK
	 3/SJc+O28xa7A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A3EC5AD48;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:20 -0700
Subject: [PATCH v10 41/41] KVM: selftests: Update private memory exits test
 to work with per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-41-2fc18ee6d3ba@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=3875;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lUvT16Y2a9GQsXboRcAXXwS4SVcVvLUE9PQbscannXc=;
 b=RHgI6k3Qdcn2KcFNrAue0i6g/CNiZUlSD125Ql3KxD4G4Y+EqRZTNa9NXQvYC6mjhDdbURQ1i
 hreDiZbMWy9BQrYjVxBBA36GyD9KdbNAuCR/uoQvC6duAUACoi+C4L+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30AD340008
X-Stat-Signature: mnhbto4imaf8i9h3c6n5wu3gfn4y6j56
X-Rspam-User: 
X-HE-Tag: 1786139589-905221
X-HE-Meta: U2FsdGVkX1+F1XTpkG3YMV2CshUad5gTH6PlC1y7CNJvvn08M0NKAdmf2wMkvptiCaUstNk/F7SIVqcjeiZFMujd0OJtVVRJ8B8PzOhRVZ4fgOsazoQpc5kWRi//2ySCIm2ALha4A5adKsOFInhQ/slQ0FBS3hu8T2oFrecG/jHti5nt3c54FDpOh8XCl/jB8uiaIoqskXM7GIrjTepgEeotszUjYSuCx0rqTuEtIc1f29O+Z/6f0ZzsEzTjrKlYZTfZYInz4lkRTz1FmWcP7mpCZXWwS2L9luUhtsYPOSHoaZOX4aTKoS1SmZl2Ic40zMB/cSfm6s81w+GElUcBZJ3fnBYZ5C/jbPckp7NMgitJRtHfW3eGDduGsKI5n2JRA9XzGtgIa23ildLbcgcMM91pY407mO7+k+jvIOy6gWUdbfm6TyCUaIT3u6K0xulvrstmHL8zVkvDQNuH9Xq3JWoSDmRVe/gXOenDAkrFxlj711PQcoNzROk80uWlO7aWKCMd6ouhxnVaYI3iIJEmpQZZS1P2RUs0o/u1HEHijx1yFV6JAvTU530FXgGBv944SuQIBidaQ5fiHxy7mnJ13ZGNefm0aKioTmAM8ZExylP/nTuz3uV1GpQha9l6cKwdboZrq34PD6GwmSldfD2zi4Jj3sGar48scIZpU4MZ0hA5gvKA56hOgKIep2h0bUTs3KkdY84pDpvnZEUKPhXxkKE6DrwDAqFriIZqu1Dmqpgg4BW6ygo/9CB3/NECTVxwYLECEv+cQZU87mip1WYknvntHjy5PsG8+oAPZdbAlqkJdMn8wHvC97nXdL9IUJAz//265eQSyhw3198+sl2A4sPj6aqFdYYz2kO5hMy8TUoHeV9OqYCJxPvE7gngoT+SzGIT0dpMOR+JN4HcHWkf4mVH7Oz/4MKfSadLrGNS7ylx8SsSoZ0pUgBqyqJqSTT+tgMloGIPzXG731MeV8K
 LzRoWdwv
 ii8AHHdBdexhaUH0C3TGSkSqKOi7qyCnGZF2+PM9620roZG2Wfb0xR2sKGm4Kg/iR8lk1TGxJUGcO6Qi4KCXN6v0eV3iWQSFZJ5vanX2wUC1G3+TBMCuCbCNYyx1jt/dlQ0Y1YSglZil0IWejalvadHxxwgUX/2X6O+So/j99riZc7AbW8E1tJg3IxcxkDsUMkAAXb4rr9aO1eh4nfvOMs5DhHPm4Xrj6h1N4NXM49qhnqEFoE95oQJLAb9Xj7CA6mpPWGM/aBS0TeH5VtvJ8dEf+9ec6w+H2VQAayAts4PN4G0rMB2UuY4MAcOxmG/GHFDcX2XpStlz9D5oZUhFxq2H7Ng4fApQ3uCSJlCGSs0pWLgmqawU/sR+AbYzjKScijzjms99oRXyOn173JIg6GlfKktycSMLMV4MaEx3+JxAVtlyKUcG/+6DiD/qt3b7jmnToWEwhV8H1WVMJIN3naC9iIx70KRFyl/Cwa+YQBs0TwAfmEvmhXrXK/EkEyF2ILefcm65u93/0AP4=
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c | 36 ++++++++++++++++++----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
index e6d16e9d61200..f7228e0f1ac61 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -62,8 +62,9 @@ static void test_private_access_memslot_deleted(void)
 
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
-	/* Request to access page privately */
-	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
+	/* Request to access page privately. */
+	if (!kvm_has_gmem_attributes)
+		vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
 
 	kvm_pthread_create(&vm_thread, NULL,
 			   (pthread_fn_t)run_vcpu_get_exit_reason, (void *)vcpu);
@@ -73,10 +74,26 @@ static void test_private_access_memslot_deleted(void)
 	kvm_pthread_join(vm_thread, &thread_return);
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
@@ -87,6 +104,13 @@ static void test_private_access_memslot_not_private(void)
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
2.55.0.654.g21b8a5bc05-goog



