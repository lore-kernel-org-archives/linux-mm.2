Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D80C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADEE56B00C5; Sun, 30 Aug 2026 20:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8EFC6B00C7; Sun, 30 Aug 2026 20:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1A56B00C8; Sun, 30 Aug 2026 20:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 551E26B00C5
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEBC7803BB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:49 +0000 (UTC)
X-FDA: 85159671618.09.3EC0C3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D1D8214000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QDL1/U5G";
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135947;
	b=DvosJuYS+bjyOy6GtvUlta9mq57MgOWcnpMEkibKIclaAo/akLlGxjbUXQp8Wc2Xi0FUTW
	FH83oap/XMFBY8hV6L14+jF75aeh7gjW6C/FYknwPOcSdJINIKrn4xbca/y/yRe3+qiP3b
	qyWkUMVLJpYWRx1DRq4/R4MCh7H9+30=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QDL1/U5G";
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135947;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrq6jU85LpFQzYleUUEG1OaF/pCF7t5AEXSn8KYfUt8=;
	b=Ui5Ey0ZSsBWJlga3YIw2lZeG/6DvpdSuluitzX64+asjXaMNC7VIY7DbfYG+5GZjYfd11h
	ImCVsyEHj093Uu3NE66v7itkMTVPQ5kPD1q2T4PfLO0i3ndT+tpY3w1vzCC4QRBEQykjou
	gEf6huZBlN/Fc1SiEqJOxdiCva9xU0o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76B0F44A2B;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E6A8C2BCFC;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135924;
	bh=lUde8iYPK4GJUXtsVUXDi0w9BjDZRsLdMY2F9VQx/eQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QDL1/U5Gi2tI2Qsasc8gRi1lHT6KFbEmiOS2zkGQiMMd9NtAzAMilbTUB3CKXz5zx
	 ttpag6CJtyLtVicvWYq/9LIjc1XNwVhRvwJ5dIyLS8/waaX0jF3F73MpmmyHU6rfbF
	 q8XZb9UvWYE/5bAWG+W/Wp+5HDew4a4hKCfdXKCcdpuqGecuhW+AM0m39q3uFnO0Nd
	 884bzQI+Q8B6qJLtlZndcQGLmdG3yNSZTfTWyeGeO9ss5Ck9GV/IY4K4XZHUvFpj2y
	 wNMuF1AVUEzTEf0r06Ku3D787meq/w8H4jMg9F8FVYbwDGIB4cVNzMjOXu9q9YkydU
	 DvKIGry0Tt90Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D49C61DE2;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:46 -0700
Subject: [PATCH v12 45/45] KVM: selftests: Update private memory exits test
 to work with per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-45-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=3875;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mmy51FSAm74sXNx3NluUXGdNtIyrfc0yrVpZYstCmaY=;
 b=x1tSYHkMiZA15KG15MvuWidKGKIO9ZIkKkpYPRyas8DXVI2Iq/AGOOCZ5f2nE5+/RixYjQCnq
 p1pUwVfslNYAIHRIX9zYPGrQXJ1fNDZmZcdduy/XQlbcBp8CmqVZs0+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D1D8214000C
X-Stat-Signature: i1unc1b9i1ra8z9uf5f7jdgwna41z5mg
X-Rspam-User: 
X-HE-Tag: 1788135947-722217
X-HE-Meta: U2FsdGVkX19v7PMbPIvlc6nLSKohwfbjKbS6c4Iu/npYfFqoYwJwZqP3K+ILNUESa/k8CqGENCPxj8gG+hiFHeMHT5lEMgqKIRtEO7Cg2Zq+hQ0HvHYyP9IaZ4pYU+5iMDA/UOetg1KqiQdNcCJ2Iaidg0mjSvjw6LXL74QEzYlB5jHGIKzSPCegQ+Pkg0m3ISGwiwAaH2s6gxh86mrpjYxdvIG+YP8uAJsRraQw7OZ2yOUBITHorGf6XfpAueYENCvlHWvNxVtqTZqrkb7o66rq0anpZnu9IHWda0TtpgmkHJcp++4wEJTq70O2ugrb/M1xhZrypT6k37dfxT+zzUeRxGMo13CEwtnynqmJPJzUA4cFhewSXgLtk4Szy/gqLI1IdhshlGZf9VdXVFGRLq+7C27Iz8Z+bd+hOZqKe9sDRL2gscYzpbNnF/KysW+AQzaDham1hiHlP079iQVBRqGwFlVidJwbgdSuXtY4+MUwSw1UucWRl1z6R9RZQpNh5u0hu/YY2saPZ3Vf/WED3LBT8cCVHLehyDKsDZpZ27tMhzuQt+qSCNUQNcEZPHK/S2uukwQ9z6DtLwqvojRXQUKj53+fJxwPigBUtPuqbgo4mnVWYT4+zdu+zJ53fMqPc7LeU3SQa3oFTXFJRn7vtW1rwrlplBEMqppAaboyjYbThvlObQDxNPHMgzVxT+0VeOdo2xY0db5+GMaK0Co3QTunlvTygIGIZk1zNthvHIldr/iKp/YFEv3O7AiH2wmJfY2Jf9zxeR/IOiBwzH6mSGoePPm05tUAe0xuGjv8oPmyko1ZOe9eP04zTXJk42TVxAHiz5B+HI0hQip6EZFCVYogh0kxUvsg+UvmINjBnPMCoOO2TMUjaF4jjKhHvZMemBhIvZqnQQKvDI1kAf1EH7VTklxqSmiCTfF2AfMzYwdtqJsHXadhyPljeRenhcVa6EwSov4Qz+xLQqE3bAi
 xNemTjzp
 hI6WwpRRp+kuKTqGBdbAXxWT18H6AXhzKLlM1IWoJjQkMDj99dT2l5xytncpRKUukssb8ValvrpnPSgucNmL5kW4o7qJaXTrBjVGzZrrQRk/xP0JzggIx29jm0/5fO/fE3RDOrU3zhFrXBr8fMeMlnhcCYzxZwVVPRi6jkDxgt0dzarNaHzzAUxwMPB2Mr8bsPFtWSBAJ4UFRAsWaYLA40p1Qr6k1/FM6EuJkvhUuLDBxZgMfAW0MSOiUU339bilE0DKCskrm5yHb6cTCP/7ZWb3KsBNelbiVvPS1b+CYBjBT3QvtHXuJbwVqg4SR0ptGVKG06O2Bg6cy8c7LpfIph26eFFx5O/nKq85ndvsTiUN9WMChyzasQohyxHaofDecdcDYrSxHQSN6R+so9PoxQx6UoDqdUMRdEK4FDYeBRXz1D1AjJ7lq6FghtsJBivNZ8vGSfpFHNpyomkfXbTEsUfQT9k9V9C5GBr/z
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
2.55.0.897.gb25b4bd76c-goog



