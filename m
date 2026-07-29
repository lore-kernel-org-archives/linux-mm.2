Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA0EC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9786B00C1; Tue, 28 Jul 2026 20:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172876B00C2; Tue, 28 Jul 2026 20:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F6D6B00C3; Tue, 28 Jul 2026 20:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD1436B00C1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E3221C0DDD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:28 +0000 (UTC)
X-FDA: 85039945536.01.0D15273
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 873241C000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QwINtLt2;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285326;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZEbQlEydtGYZDY5K/y4loY/HOvIRDrlSipJU6mlXHQ=;
	b=7qBw40DPFUupuJ3Tje3COs5lKEW7tkuWwfrisaMCzIafTk/0kuRDEcR6mhkl7Ufj9lr7KQ
	CDlnShISATmU7sv+t7N7OKS1HFWSM13hOYj/t5JTrTaYM+eStY5rCkQxrHLPxCuFF7DLde
	trCW52Uo1QOqNg+5llv/OXBgsLIx5mc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QwINtLt2;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285326;
	b=i/kR4e3sWGd719X/bwJF/3ZlwahrIjiSJqGMEbQYbF414W6aZO8TWT7lYQuLGlmiYwr722
	fRi3IpoHrGdmiPR78gDfFSKjXaV8WFjUaxv1/xUv28IVT4++h5dsdyzOrOACNehgXpa2nn
	MEuSmVv8dDvwnAjZCFdndSUgiRCkbtE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A3004516B;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A904C2BD05;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285311;
	bh=C5eRUocXw/GNePSjynQl43Hme2TTs/8p6qo//nMsiik=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QwINtLt2IIPsFVO5GFtY8QDDskGKycJ/6P5DMyq+nEo2CdheZyXl9FJuAJNFC0sig
	 dTcJxW3Q7MKTt51fgijIBqnDIx4pV5bG74nTgDkVBGh01MreuTVCT011Zo0Q7uVsjS
	 jeh/wfyFstIaS7VGRGtsRqc2+lca7ZXeAeHbTgq2ftAqzLc83F8vQv7Cq82zAlZT/W
	 eZ2w4IlK35SFGvCGy6R3xyydJtMgJBHu03VzJD4nZ02xQD58koJ+hgt7OAaTa8WEIC
	 Ovs+BrXmi90GjWlpQ9CFuIkbvP2aa0TFM7wNzp3h7cvSZjjofoX/4RWF8qwEFrk1v4
	 GycR7DQT+6BDQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7B9C53219;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:40 -0700
Subject: [PATCH v9 41/41] KVM: selftests: Update private memory exits test
 to work with per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-41-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=3860;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=OXbxJklB527/baH7YroleLhSK6jGYFBASgJI72afKmQ=;
 b=1EaVGZNxPXcWvFQRM0UerprMYCydw3MFwdosN66H2gElr9s7pSEokltDzvvyRtDiOn6seSpSL
 qw4SjyTOQilBMNqMJhrbpwgjEZ1s8XTs+XJ3E5zC4njCXnoq7W3vK91
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 873241C000B
X-Stat-Signature: 363ouf7kgaa4zzw5y44eob8c3thn8ojp
X-HE-Tag: 1785285326-892187
X-HE-Meta: U2FsdGVkX18/POujlD2PvWWzMeHF5HTw0RASe/6qEVbXNqG8PJtk8ZOYcLoS8vYA1dg8jBOCP8vyY4P10PH1D4DPUgAuoGZwNH1IjRcJWavr8zXCUWdVwVJiASoCHToSqrcdvv9Bh7M53Zs7GNu1W3p9ckZaHcJbLXjaZlnuEDsSVmVleUT0qZocIFc8MohO9yK+dbGl7nCybq3PpLhuF6Gli+x6F/BNbHbFH6CbOgxndLSXTG62HZKUHTD1nuWHTpylv9YVs1+TPxDQ9QK8bg+rOyNU8bZH5BGI1UiwNBYSNYTbSzejC6LiLCti8ZJ08Zu5cGLPFrTMUR6JJjbtxTX3S4GPbmcP6U9h0OXWW46XAh8gUOFwiEFCsE6w8iFcN0vjBqVwvaGm4mwwDyVU1+6UkIVGZ/F65f32bPkrKkTPzRH9pctaS8GFKVwVtQpbTdRC35WqO3wDUmiNWeS7tNqXTWyinCtFAgNUtusVO79wl2yOzd3Fb1ZZU3kjUyfSy8aPSKnV30ztp0wghxqFDmJcpRcTLxyL7HvsHBkaeRwsO5jXuC7M+9bKYVamAKF/b1hkMJGK8OtF16RtKyTObjJtbCTRf4pxPpz6jpEi/fV4S2INoPKZodisVEjdkKq3TRlMsJr4HWmcSHsdrW+lcBJVeS2DXTHm3/M40CDRcFl1ZJrghUn9EwBxAsq8bYfWTOGmDAU+NT3Rw9Tz19JWvvlfaXf+qheHzPiNZLtxQmdIz+Qb8fR/ZWG10F6rt9rmX/eZb8KeEjFq8hNeBRyujD/XLWcdeRN75WLkxbQX0/NLEgTWk0BBdZ/F9rvWqKqZ3l8vrr7+rhwZ6cDDzoFuzihbu0BSNPRw2ZVypyKt+iWGmAZMPTIMVoxyI/ax4sEaRjZau5fIDjrrlisZmrKvYDAyVQbMeShPHzNtW4/58QdMvUeHBg3kvAfDpQNZgri+YvCI3861hcFdprjc+tf
 RSTYZGk3
 z5aEpeJBsunmNLeO6+lRqzr0i4Vzo4BWvcfbYC+1SSp3ppUD9whUKhStRHFBR7E5bAKsnFe+qk1M8HZoXwCsz9/hhgZXVguf5NGtZ2J6Jlus23V+7JTsPEt+bZmjo1xSaQOQlGB2MopXZpEuv0IL+jvvpO5ysVOR1+AiqLMKR5DpROYYjuqb2M8Zk1avzH7HfdrKC8Q4/YJycH7h9FDrQXlYSj5b3cPu+8To+ETMcL19RoM6mNoE/GjKGsgVLD3ailDWllxf8Rclm3CF0sxpf28684109jG6gly5hDGZ/LdXdq7VgYyEFbHXVU/oOiOVHGv/Caj4hqc9KB6hpOXKKeDO6ZN0SJLOvgy8hr68UL5VZKDNtV1HHakGodz1jBFO0LSM6bdMZWQ5CLAAvn0QRBOnXy37Trtqp3Q93o+cg9vZ0dgwxq9ToMi8BIEBVgrRaFCxVJwkKAghLt4IruPL3nbysG23bixylOk+kQhHkLPR8EIikTuIA36tUzxNu9CowNHKBKUib6MsWefw=
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
2.55.0.508.g3f0d502094-goog



