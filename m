Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EE4CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5386B0096; Mon, 22 Jun 2026 14:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D0C6B0099; Mon, 22 Jun 2026 14:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9A16B009B; Mon, 22 Jun 2026 14:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFA1C6B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EB718CCEE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:13 +0000 (UTC)
X-FDA: 84908436186.16.38925F0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id A21FF16000C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DvJEkYUQ;
	spf=pass (imf08.hostedemail.com: domain of 3poM5agkKCOsgNehafNUhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--tarunsahu.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3poM5agkKCOsgNehafNUhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hLQE11StkUlK0CTXqXjUU/EPcv0l0L8NQfDoUdv0GQ=;
	b=4moe3RF17t7wbamWtlcQTpB2fPh2bSFoFuP8wMeTxwNKhtYOWy7byLvq6+ovmDOB14Ju/8
	dOEtlf7JvDCWWpq0QZOWJrOuLoCickw+WIw5pP72lD50CZb0HBK5v3JZQlUpeBB3QAi7Z7
	NloEKU05VaJqOduBQVJ5OALI0aRFkVw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154151;
	b=0fj2KEPnIxL07x/hs7iujhvSyd35Yv91M5WQVtKujDKNhe0qU0WxVMZF10xGSPWhoq26nK
	Cbk2vR6YZVrujzrLxArQZVdG8HvIV1au0iYFYgusksfNV9drcdWOk+RqeCoCHe+yQGvykA
	DwlcDVhm/d/0a9QKsxWb4kBrM+3nPJg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DvJEkYUQ;
	spf=pass (imf08.hostedemail.com: domain of 3poM5agkKCOsgNehafNUhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--tarunsahu.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3poM5agkKCOsgNehafNUhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-49244130073so18792555e9.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154150; x=1782758950; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2hLQE11StkUlK0CTXqXjUU/EPcv0l0L8NQfDoUdv0GQ=;
        b=DvJEkYUQ07tyzV5gNUUY4Nt637LQo57mlnSPLWvwPTsdnE5N1fW+Uq6tXSradPoipI
         MwX08+7yhgIPumGW4OL7X5rlw4EdnMeGDSH9pMuHixL9QBn19L3FmNmFvWpkJGePmIWP
         G1olRDWRlpbvIVBXqqnO9YQwxQ80vlWvQys1Zntb6tNwbtNNwbpoVkZx9vXLgjGYxY/q
         nRwnZ+LW3jfmsRCLYqiCNMbgBtlIHdHc+FDwTUM/3CQuZ4DIVEvDbxvc/bNjRJ8fRiHA
         MER65zGRDcGT4yvbZDbG552YAhHcz6lQIPM8MfJ2LAVIrIf0P6/qn971/QPomGNLyocD
         DxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154150; x=1782758950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2hLQE11StkUlK0CTXqXjUU/EPcv0l0L8NQfDoUdv0GQ=;
        b=bu19MEmYD3+VjNNO36tReSXFzTA0t0HuphCenHEzjQcroEJKlnicmdFalADhINakee
         BVeLn8j3vReddjSBSr/4ni0lLwtNQqW9ngzaNKxv/SVICTqKVsaPBDgwu5Z1L7wnoQxd
         14Ud879Q56aNyB1lUTuT8F2R+j2xDzxnSXTiWFJJSirs3tbq96EtkuoxyfWalNRgh/U8
         F8qbHTz0qfE8IstuUG/K4wAYx7vkTjafVXqXVRDbVHvnceo3auR+OACnJIOXfeKNi3R9
         2fB8lXdl4qM8pL8F8iK7/4M/5X6eMx1dViRSyy63/+J8gWNTuYZ/V0mLe/OIgOtfn1n1
         pcAA==
X-Forwarded-Encrypted: i=1; AFNElJ9mTfTkcrcM7Ypwzk901/KVaMN1f5QPkhJNG2MQb1JCsWNav990mUErCk1NWjrHUaFrb2aARn8+Ow==@kvack.org
X-Gm-Message-State: AOJu0YwP3zvKYLX9Ntz+lO0ttgKgnrsTeAZCIbO1Lvp2he1PzqaVjMpU
	kiiE2xiCpRSom3Fwsu1gHLO1YUHSKbFKtj1QqIeTRZ6Zdbs5rEjTwQ2TjPhSwVBUFufGZrJSQJF
	ndcHfIRLsXOcRrOOhuA==
X-Received: from wmat25.prod.google.com ([2002:a05:600c:6d19:b0:492:52c9:b1a7])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5290:b0:490:bcf6:469f with SMTP id 5b1f17b1804b1-49242189b1cmr243494115e9.0.1782154150022;
 Mon, 22 Jun 2026 11:49:10 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:50 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-9-tarunsahu@google.com>
Subject: [PATCH v3 8/9] selftests: kvm: Split ____vm_create() to expose init helpers
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3c64hmwo8tia3r4w4cup4fwtt3x6aoz1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A21FF16000C
X-HE-Tag: 1782154151-466432
X-HE-Meta: U2FsdGVkX19apdBxRQSXnJtYE8WpE6DvXodxCSQEqxizpn1nzaUffYqt75x6dJ19pG58OVFiTykHIqr3vbA+kQ0ZBUHQeRNj6XQQ/xG58+dxEvQ9GQKiHI4xQg493Gz8vGVQEdG5CtTi9AnV49l7sUrBKnRQK6VwjCAwV7jaOOYzn7WyoGdpt6m9+kR9D/KWCA5l3HxuwD8FCJ5UKdZRTPR4uKXF7wO6NAPJL19/W8dAtf3Alr6lSOjLK+yWkOV9HLSL1+TTTNCme9sX2SQ8u5vopV4DG+5ufwRK7d++WhRWl6BUOMcq6f50vkxoCEdMgB/k1mcf8Nc4cL2N1Co2oj1UJ5cyV3qKConm5w478Np/nKn4nSktMmCe1P+R8Nlzd8nIOu+qbH3smJ9OJOCgmXhvgLlECtYOrS3IuwIULt0nXeCkHpkZvAN94ywKauHXILtuAvLysX2eeCrFPPzaL0oXlwd4xJsr3MqN4qqdzVImLDTMSJsZI1vRo5shBp2n+wMnAmDP/kP5IACp9N/fkYBJ+lP9MOH6pbIIPROEXfFWO9ZJcMyF/0mxrMymuTEtWBnaFoiMlrDKywkI7x1YtvUV5Uv2h91a55xM9jjs7YiSpdbBVopEaIkEbPXlc2vP/tm/C+nkmwxCAq5ROJfWGJIXi9H7MuFuJAkewbMWKU0q5P5SpeE0guomPl8Hm5p8l6Giz13VV9KfkSMKl/vLIcoipVoWtQVqy39tmrlRELnoMAtZH5XJrGk9qSTQ7jtDlBrzxZ4prw1v32FE16ZKRevH1DBe5mxWNjggNrOgR8RwxLXJp2Y4C4/kA5Tal7upt77KDVLu6vEka7RPd4t025CKLn+S78mLWMLFBNqu7W631CVeflUD4nwcQugIv4Y/mBC1LLmE73CpR33bA1eiZxEwjFSYxgIkj4f8fcexm0xvsIIv5k6Bkh21/DCpYsT9LduLjDNBvbDx5mU3NoE
 M9hTAFct
 hcQyFvv8b2jmqjgWDTdM+HDv3Orv71vvVegJ6E6welei0Nd4QMw9VqLRILTwYQgwUK1x8uIgP+1JIWrohYOXMBkroZZTTu3E8W1JFdgryXRP4XVsNqGy7BRbSuE+hV/RBDMbNx5hMTvOr9DVJprtTzcHQclqPSs0hGUu1+Y1n9w83J+FlG8hwE7TeBOr6+17AnqQm4kjXuxRjyQZ47JUOTnJfNV9CTmhlRpgU6IHcF5fW4HdqiJN9ElihTrBjSKDNqyb6RTwJ01tBKOPqg4uEkZGp7GKVmhYcGgJakBaDpdivjM1NHuLvcniE0u5qxxIq4LUKGA+hT+LRT38oQOFo/+Nn5I+hsdEqai45D2vbmZ+Uv1fwKfCKyrZhy4rvpHGGkou+iXq27Q7WFbDFlKoTchTEBl8ofZVZquAY8/fO3ryORnoG/t/SC/4vmRMbLeUd12RwDtJ5GE2xqeSqCnXH4KV14cNZCg6f/gvKwW5K59UxJzfgU85KgHbbWQZ8JMb2gHMOJ4oqE/4zNyqbmXc7/ZXbA3x7ri0hQ7NPaqGu0cExhtr8ySsqN8OR3KIfikL/DCOtluun7fJCEjjCp8ZSQlFGNVovOAbmpB+Pnh0mshVIGQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor `____vm_create()` in the KVM selftest library to extract its
initialization steps into separate, reusable internal helpers.

Introduce `vm_init_fields()` and `vm_init_memory_properties()`. This
allows advanced test setups to perform targeted VM fields or memory
property initializations independently, which is required by upcoming
test cases that restore preserved VMs. No functional changes are
introduced for the existing tests.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 04a9101..88de0e7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -471,6 +471,8 @@ const char *vm_guest_mode_string(u32 i);
 
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
+void vm_init_fields(struct kvm_vm *vm, struct vm_shape shape);
+void vm_init_memory_properties(struct kvm_vm *vm);
 void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
 int kvm_memfd_alloc(size_t size, bool hugepages);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 195f3fd..dc576b8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -276,13 +276,8 @@ __weak void vm_populate_gva_bitmap(struct kvm_vm *vm)
 		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);
 }
 
-struct kvm_vm *____vm_create(struct vm_shape shape)
+void vm_init_fields(struct kvm_vm *vm, struct vm_shape shape)
 {
-	struct kvm_vm *vm;
-
-	vm = calloc(1, sizeof(*vm));
-	TEST_ASSERT(vm != NULL, "Insufficient Memory");
-
 	INIT_LIST_HEAD(&vm->vcpus);
 	vm->regions.gpa_tree = RB_ROOT;
 	vm->regions.hva_tree = RB_ROOT;
@@ -380,9 +375,10 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 	if (vm->pa_bits != 40)
 		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
 #endif
+}
 
-	vm_open(vm);
-
+void vm_init_memory_properties(struct kvm_vm *vm)
+{
 	/* Limit to VA-bit canonical virtual addresses. */
 	vm->vpages_valid = sparsebit_alloc();
 	vm_populate_gva_bitmap(vm);
@@ -392,6 +388,20 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
+}
+
+struct kvm_vm *____vm_create(struct vm_shape shape)
+{
+	struct kvm_vm *vm;
+
+	vm = calloc(1, sizeof(*vm));
+	TEST_ASSERT(vm != NULL, "Insufficient Memory");
+
+	vm_init_fields(vm, shape);
+
+	vm_open(vm);
+
+	vm_init_memory_properties(vm);
 
 	return vm;
 }
-- 
2.55.0.rc0.786.g65d90a0328-goog


