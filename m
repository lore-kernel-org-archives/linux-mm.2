Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD87C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4499A6B00D0; Wed, 26 Aug 2026 05:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383F36B00D1; Wed, 26 Aug 2026 05:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE136B00D2; Wed, 26 Aug 2026 05:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E15806B00D0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D0484031A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:29 +0000 (UTC)
X-FDA: 85142872458.06.F4F72D5
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf30.hostedemail.com (Postfix) with ESMTP id B28548000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bh90re4s;
	spf=pass (imf30.hostedemail.com: domain of 3nq-OagsKCJMxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3nq-OagsKCJMxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHYRx/PxkM4WDh18sJtaYTvnxr7wQel9FcKfTX+J+bs=;
	b=6/lKC72K9Ch0SysT1ay7AoF9UB99pJCC1mo9coQ2N2HnisOX1uYSf+FWDsDfZvVBcRsUV8
	17AwV+0QZAojk20wd/KKerVWgF6/KpP8rb7S+tVIlFOrOfMGOsfhDnmQvZVz+X5e6cf9Bq
	BHx6QxcmEYiuwKL4vP/5PERFqif83j8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bh90re4s;
	spf=pass (imf30.hostedemail.com: domain of 3nq-OagsKCJMxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3nq-OagsKCJMxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735967;
	b=kEQHy1Cjo0Pb4Nwsk+zy2GC9y3anVgmllkNr7xBnMrIQ3RRpNYQNNQfwNKd96QegcZBsBz
	6xtGfRjDQ02fKDLWSCOfpJsSNqleVGcZVnv76K9cwZd1ZhWfolwybilCOD+rRPDVfVTs2s
	nsMSvRpIvEKovfSqrTWu0cUoxR304Vk=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6f75c1219so17215635ad.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735966; x=1788340766; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zHYRx/PxkM4WDh18sJtaYTvnxr7wQel9FcKfTX+J+bs=;
        b=bh90re4s1Jq6wxIjORyaSmlsAfPWms/0UlKpD3UidNZaImmJBQGnomIGF6Kx9ElD+h
         rqmJh3/aeAdIOHpYQvxgi0COskkeg2U0Ibagvru2dfvXkWCe4oJrpCrZj4/R6hLTb/nA
         1LyJiyH3mMYaIqyEbv0DpBSohZcY8r6WV8AUH1390sHeBQ3KQlinyfkqoz+oweowm8au
         QieeNZ3Ze6EkVnW7b/tp1WOSQbxSmDD4j0TJkEbvvGuVGQPoXEq5gtaWJ/12MLHmZXRW
         oZP15KXAAcdJWXp211LUF0T99aGfA8rbgEh8V7zKXMRJUr5E3UQSa2lduig2EltHdJBA
         uPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735966; x=1788340766;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zHYRx/PxkM4WDh18sJtaYTvnxr7wQel9FcKfTX+J+bs=;
        b=Bc6VgtmtcqYLcKj8uvRiPFjwrJfX9wgOuJBy8rklRv/AV30GJqWWUqBKP8AN0uN/2i
         OHdY2rRHfTwV0dRcZ/4a4Th1FlPdoQ3ajALPvPDbhf95AxCXi31F1UbdviylgEkiapJA
         gQlCOGSxTVG81byUlS/rtPYUFvBgLXQgOgem2huaaeH5cfICC8TLvEvi/FscdOE9bIaK
         aJtRFhJkeGEYF/sNyzEZfrnzi7RbwhlsAS+PiCYezs4nadwTOmstlF/kinnpIR/2LKcU
         7K44PofxljAyp0LlgPMaxWZqGB0ZeatDXSc4cF95uevGwysPoNFZvgyblDNpP4dABUZd
         SWag==
X-Forwarded-Encrypted: i=1; AHgh+RpLjQZXNgSi4hL2vy1r5a4VeMksrOc2eg9y4NTmndijJmMVdprg8xl+nlJCGExnQ2bx2XDUma5uqg==@kvack.org
X-Gm-Message-State: AFuF++lNC/nKS/gnd127ZPl7Z8BR48UAKoUSB6gg1iHJqPG+xaBbsP71
	uSwFivet3xt9aPrm1gUspOeqi9aUDljKEyqnddXlFpxh8vzulnXW4iZsRGTFbJT6zjw/7YpjR8F
	40qZfG5ERc30z4XPwXHWOU2iGXg==
X-Received: from pliy16.prod.google.com ([2002:a17:903:3d10:b0:2d6:df8f:1c1e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3c46:b0:2ca:4f33:e86f with SMTP id d9443c01a7336-2d707b416famr96063915ad.12.1787735966143;
 Wed, 26 Aug 2026 02:19:26 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:44 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=3875;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=vQ9v01kvEacWoPdLuKsaPZxtunAeY0dQj48sYbjG7N4=; b=gbSXqT9glzhdzcG2yGJgFOkdSClBH/STykulhxs5pk8VoHTx7tcW5OXCdDyC3bBspy0Sm3l0M
 Smrl3PHW5YSBsLqrwOgzhnFVcWIiLWq5w/qaGmstHG1iOBhSjmBT/ar
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-46-0a15d8a799aa@google.com>
Subject: [PATCH v11 46/46] KVM: selftests: Update private memory exits test to
 work with per-gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: un9srazaherirt3eecwrsrena3daain6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B28548000A
X-Rspam-User: 
X-HE-Tag: 1787735967-848217
X-HE-Meta: U2FsdGVkX18kHOcXoAi0K8UewrF2xU/yHr4oz2OXfDRN1iggHONsFkMnhZ+4OmPLBn4+/eVi+A20CZBiJOK/+GHa+ZGpZnNML/tyPloB+Xv/iCxMWnLJfaRvylBS8cwDkce50tkhVAUehc+DPlbOKi/JN39WnudhyJ4PvTCVSIHv63KDWG2rHEP5St9tW64FRCFZZmyHo/09XxPyVdsGAVfDVmONqmQWpd7KshQP9wzidSDXvSQ2t/N2s4OqgrBLIYKCii5H3Fa/ijT3nxUT2s+SbqNg8gkE0/flFsbaLkWxA4IiOpb38u6cP3VTFqB3+BWnmkGMiMCwQTr5p19N8xV/GKmAKdN3r9FbYUrWbwKw7bAfFaoLJY8PAz1q/+idB80NaYNfCkbSZ5W3OttGD/u2uWijbmXvFoNeKslAi3BlIRhcB/eKTbQ8V9zHB1TtpUZAyRUjZs/HT+Wtg4v5jiHbFbI8HHMzIjw2JCJC4cUIKvV8EGG+wlaK3cwR5mMo9zGXuD9UWHUQ+no9ftApZB7XrJkuFNtrH/n5QXaV24Mu8kjOjJTR1Zq237ZDt1Ro60oc0AopDQyvLJHUlbV4+F4D3IUn8Dz7x9b5i/7xqIDhl6MEgGUytybpwgd+zARNC3377tSjzZ7zlfpkue26FydTQwVnFwf8qljkQox4I5xMeLdxWqp1G/Hy2FhHgi/dmAKc1scSSB0DxNbRtTl6TR0n+6TeU9p5lRgoaNSHHkc58wOdkXOuDReTlGplFAGYX11sq8UmIso1apKZ3yF/5YnRB1XQVVDb1jWhpfutoo757VKNyd4MJVrrYUZRjLlGIFvE7rfvp3nGRRA/uDUg8O/SPqRg31M/sgt3Wo2yCSMIlW84JFidgP1erwGd95Z/tuHC9cBYhBtRctCImOxmOM8oj3qHltMgl32c0jGK5ZYO8IivKjS9wat/cbMXz2wHtm59RpOfGS8CcY1ePyQ
 +j5VGtpw
 NTes2sBdSrjksfQAoEgUZMeCJajuaa1p6W5qTppEsZBzM1Ecez9KkF5UdgB9oAp4XiiwX9/187/kUahr1TVKtZ2fow/7up0ppOyvdcjMlEvuphEflDcOl44VJ4/2w5rb+M8GbciYL2mG+rHIieXPl0RNZXvb5CexC6HwJhOWTg7c1ET9Cwi5/binL0YJ4lQSUMRb+heoAyLwgiUv/VbC5w4Vl93Fv9OnNHYy1rX5I9EBktuIgxx07SqbPkOIaxnPWF75HSql4uUgs1p0m58ggO0+aBEZ3KEDRVP4qwMSHfa6iAgI8unXKwdZ40vdMzPveaLzBREcHUngkbvmnwB7TD25bcKmCt4BYzVpDLZtkbI0U6lSesQ7XQ/HOuo83te2Vt25AF//9HMlwVSdQWYX+j+2dIB2xDv6j1MwpexCQAomGLY6R/KPdCH9ziMiqUEzQljtlVolyBVg8lh203P/b0Arfdd87hlMTgUmO0YKYl3vo760c6eDjkjMyJdvWe3b+qMmtfc8V1QIOeJCakDBmAaQPyh5XHbXyW5vTf2PmF9SBzJXyJKsIF/dPHRgIJNIkDs0td1CeNYeuExW+3zfNQYMguH53BT3zqjmQTX6IlJYo0uqi9LtiTsr+OZtYKGnivNnsk1LzRpoFkrM=
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
2.55.0.887.g758fc8c411-goog


