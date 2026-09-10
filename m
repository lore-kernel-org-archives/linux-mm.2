Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53345C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8366B00DA; Thu, 10 Sep 2026 19:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F236B00DB; Thu, 10 Sep 2026 19:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E796B00DC; Thu, 10 Sep 2026 19:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B45B56B00DB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 374231405EE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:59 +0000 (UTC)
X-FDA: 85199513238.14.284ADE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3528840003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhvGaerX;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084557;
	b=GYf+we6XVP2IYAA27QcaegzifCa2O6ZIvMVSEzj1gE2pOGDuy7FRapf6fAaOm5F1OThEIp
	49nuN/ZOczZz7D1tFVBNhvMNmFjpZmGAm6qwfc1mwdUFVDO5gE2gCtY1iGaF7oYCNroyBD
	Ed9sJH1DK/c5jRMEZCZpQcTwV0GLkFU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhvGaerX;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084557;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/BidF7qO2c9WK7aOrHzS9a7l8CCjPJukiLNzWGk66g=;
	b=WpvZ3mkmIYN1P1mXDAggVY3Cfa0MjyUksm4KvR8oSQeci6IM9Aqz5lR+Y9fltsKTMUl0EQ
	CMWEw9zXeunjzbBUu7xRQRMGQsTWECoWRfeE8arBAHZj7rIhrcNDPbScjFYuL44Qf8+1Mq
	vD9C0kLzUTWM675CIiCWTlD1Zqg/Ykw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46C6A44807;
	Thu, 10 Sep 2026 23:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2120DC2BCC7;
	Thu, 10 Sep 2026 23:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084541;
	bh=wz1joYubyC9sBFss2cubJfls0BSPnVFGoTr3Kf+jPIA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qhvGaerX/8ukW3A+MDtN8TqD/BihswxNKIwo80fna9qUtchiAt+i4TMfy1Qlt/YQL
	 p4YQWtzAIDedxTr9t7UAojiFjspRIwF6tHVrICDHQf0xKlAH7j5hsgnFYl1t79Vksv
	 nlAm4VWPRtluDZJzfxyn5v+ENsDDvZcE+iNaGm1BVj2czrc8JGMtz6nvKr+CZVXAfT
	 rgm/Z4cOam0JNzr4M7+msW66MmqQ2Z1ep+VpiLtRZ+uTygvvB39qYZhpGAvf/g/dtu
	 jXp/sRFjv1Oc4QmXc8r+SmZRVfjDEnmwbEoicWz/gN4QT3J0Q4buBzM5PvVE0nCk+1
	 SmgT484gmdN0w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095B4C88E4A;
	Thu, 10 Sep 2026 23:55:41 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:10 -0700
Subject: [PATCH v13 44/44] KVM: selftests: Update private memory exits test
 to work with per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-44-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=3876;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=kG4M1fipOsouCgA8R0C4+Zo3TFMa1yM8FRwgKEfMXIw=;
 b=VkVQQTiR5fKR+Tjiv7AhqYj4gaD2VTWMmQaiT0JMuMt5nv3wd6uwY1PRhfR/6iJVbGDZHZWH0
 A9NHJ4d984IAC01HfYYfXn35gCsjLvPGTuO3Q8sPJMOkaw8uptfi1gX
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3528840003
X-Stat-Signature: 5fhcni64g7mu71reps4trodz98rp9cjh
X-HE-Tag: 1789084557-128481
X-HE-Meta: U2FsdGVkX18VQDD3gOfur1BfguWb7By4AdABXSeTyJPxvibKVJKduWHzX8GhUw9xpLcoMlZN//ykwf9EOCIOhCeMK/kOHsce9PsYt9+h8NDT/TwJst0tuvoauSlFX1d9XVNxP0ggTkPrzHpCb5Jx3dWMhuf39tGyPl3/SmuDEo2KZbC69bM8GXWnSbGX01eSTdClzlbY4PULiaTN/AobQzLTQ6CRSqPOFKuQyOJT/KffnUSYRbKkTeIEWK32TryinQH6mnBEJi4KWQXEx6ejwHtVnTA0YQXOs8J/hMmgaqMM2Y5iBxZtlnDiqpHCckkz11geoiTrSr6bhvy0aSoIDMlYKzeDdK1UUCUcfs07z/b25pjyx4/3vRNRCn30HGvO7R/Sfb2QjJHPKWP5IP2AWiRWHyqLVesov1IvrGMnaX7X4+f6Sg3bQV/uZKx1beJdnrOjg/NjkMxitdROEwU0nCv9MwkZeaBRhmftrdEIdDSZFR6cTrqtmfliZtCBpun9h6V2sKqoMX8KDmT1aaEBoF1iogBfKbQrqygyXt/xrqX7pnZx2lk0KUYBGUJ6YfVO9fxoEWvZkmN9G3fT2/aY1FwwF2v7XZVWFwENFqOerksFB7BWx3K1X32udkWIMY647Rbv+rj6ol4ue/J5349YQ7GVUy+qptJ8gnKXqZ1Vx7L/nmXdGQRTDLGeTkxdqCPknI/TkEySji1rR9Vs/kSKKp1/lj9cXN4r73OoeCfrYXGx44tZ0dEeZTFypwDmDEscdtfQFSy7N21tPyqeJN6IFbFlkuc0X+6ODHdFqGzy2jLZqqxagJjeHy4HpoFShIqmnQklViclcfFp0WP3leVgWna8bv4fs4rtQQMLxO3+d0CgWzokDiKhu4ar6l3pYrZ10ivXsEKtjoUcNeY4Upb6X3v4m9F9k//zj9IUJqNmFeoIa6RkwacZ4ELjTSFgAFbu6ABIuVxondieivSxfEI
 MjpmZE7+
 9hQYDxwA8W80FNCO/U0zmupw3yPzT21wtHJC3rhS4rtw+62h7YmnbLs5fIHmrCSPpxqhV8CRMwM3nNh9W8LI3LPfx1Cyu9okOuFZwOyOQ5qBRUwbtaD8WfGARFJt7/Z/sottDk2RpZPg61AFqzBzAhtiFvrvvMnnEo61JKWhwbDCCT/HwbCu3dpKEg4jjHipvSUubjq79hENptPsoRDW7saIj+iMhwdnOj2HNxfUwHQpRcfNJbWfZU8WXmBRffdM2RdKs1l9VGU1jbguzYqUsIucRSGFRdaRg/FB6/T719hVmXBifyIPu2pWQOikEs1jDRShHp7EfXgtFV6ryX7kUWlUtWHCLF8zOpr3PdckXuL8SwCrbacDg3qno7KX9b8+c8I/O7wjcXbQriZxcsJyj36RXDphjtvwHCIFUc8VzhdRxfizlrSSopjJA2VYpqvc5UJl8yDTVvCaa0ZbpFX7cBP+7+ruvJOh84iq3
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
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



