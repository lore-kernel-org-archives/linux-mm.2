Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD813C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8376B00A7; Tue, 28 Jul 2026 08:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFBD6B00A9; Tue, 28 Jul 2026 08:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5206B00AA; Tue, 28 Jul 2026 08:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 440DA6B00A7
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AEA21A038A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:56 +0000 (UTC)
X-FDA: 85038071832.07.153F560
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7FDF180006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sjJCj6MP;
	spf=pass (imf16.hostedemail.com: domain of 3iZxoagkKCL4xevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3iZxoagkKCL4xevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLf4NZ8GM7enE5DcNnXkHjbguMY0Wvl4QcagAqNt0Jg=;
	b=EbCLN6eM9aiE2mSu0giOJJ7nPNvLkKJYgPCP63tr3RnqyTyGCj4zXjni2gJL/H05xOypct
	99WrsjHYALu7fmbuFFMTpB+e51Z3tQrQR8lolBD4vlOU4p/NuJsNypRL+NvqkPaOcSD88e
	rj8+dxRuxwj7U3xrUVUaU6dTnce0qV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240714;
	b=tSVMB49crgqHw5jYyIXCEFN1nhG85FX8dXBcdgkBP7IzpgPRqGX2OejSghpcRtgpxHF8Wd
	asmI76b4QV3RzefbZqvTvNCT2U26zPM8caUsfRP9CAWbkOehCoBJn6cBUCXdcvGUHfI0dW
	S2t2cxvo+wV4p8w31dnlBJVwWTtXZ7Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sjJCj6MP;
	spf=pass (imf16.hostedemail.com: domain of 3iZxoagkKCL4xevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3iZxoagkKCL4xevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15d4224f9dso289882566b.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240713; x=1785845513; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jLf4NZ8GM7enE5DcNnXkHjbguMY0Wvl4QcagAqNt0Jg=;
        b=sjJCj6MPo+RSdALBPeNTxJgeB8k30/82FkfZM0RpoQKNM8eQ2Xrhp9hvAQip4Q8hlI
         /wKTxuuRhiGuGzC8FD/SvX51b965FQwcu7P0ec5ctszJo5o05LcM3bE1ziEuZvVmpo3C
         Kk7KvzWhQZYSRNBWnlH03Ys8Fipp7twQMGzkXcha5qw4UqTkxcw6A0PvcQbtUKpumrW7
         sIHLqJfXzn/O4389Vi2HER8C0Oi5g7neaxr1T+TC5FGN0oP8XMtJCCDQrxDzoG+r6tm2
         jrKYsp+PKy5VFciApwWHtCNLhvZ8tx1EdhbW+FMPz9TVzCf7Cghh+GAOBaRcf/9R8u/z
         AlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240713; x=1785845513;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jLf4NZ8GM7enE5DcNnXkHjbguMY0Wvl4QcagAqNt0Jg=;
        b=BHXpmwy4u4dAuCbfqJLRXTA1jD6lOyG7l1NfXhZ+GYX5GwxibCPByd0T4RnNfPys8S
         2kHTdESt6UHlO9YAoS+ELrtMYvI8mWh0Hj2BXvaL0CNEG4yyErbKA+lQ7nprQMsDFyMu
         /G0XxUrzybaqp9OnD+xc020fdM2Ojd6nZwLWOpGQCcWb+C1Br5iAQZ2NOQG0gVwCfqFB
         qXyYZiyzuLg8iDDbAfQlLFBGWhJ+uAOZKeqSG8h55Di+S5yQgQr+PfJ5yVUKnHTE1mSs
         Imr5nfKVqN/wQ+NySNs5rCCsUzJVykecz0nyZNjrxzTE50vbFk953NfBjug5lUBjWCTX
         nkdQ==
X-Forwarded-Encrypted: i=1; AHgh+RqC9FGCgU1DyN3Hhe9501oQTruwP3iuwN7xCZVVbkfzGMdSzQNajku81vRs2szx6NZC3mxIVx8EoQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3CEEWibebUpxfzYzJkkALg7WBJAJZkZ+TGnDx//ZHqgc1/OtJ
	+geV1XW/SVEWii3im3iMHWY2A9S9KWbCBHPNMEy6eTeXNUf/N7ae094ffdQ1AR+tY0HrmXgWniW
	99GdNULnCVEn+s/ruVA==
X-Received: from ejet14.prod.google.com ([2002:a17:906:178e:b0:c09:e2fc:4344])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:6a02:b0:c1f:586a:8514 with SMTP id a640c23a62f3a-c1f725124camr96102666b.65.1785240713183;
 Tue, 28 Jul 2026 05:11:53 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:37 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-11-tarunsahu@google.com>
Subject: [PATCH v4 10/11] KVM: selftests: Split ____vm_create() and add vm_create_from_fd()
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C7FDF180006
X-Stat-Signature: jk4ddsd9t9tqk8b18kwwujaqztq14uff
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785240714-798002
X-HE-Meta: U2FsdGVkX1+7RUoRPmgqFOM8CZc3l8iu1xWcNO4zTFVdeHuTt1FP9MTvNbNRWmkyMaXxsxxOljF7s3u3AyCPPHnpqCDJSl62+CZ6KM3J3jOBXvUBTMjbBBkcM7qcmaGtoWTEMAMle8BRPZTveVtRLGQ2UGIEa4JM78oihBWAVcpSiAHUTZo8PlgaFA3EBb2FHt3QXXddJbC7vYeltR00okaLvFSffyGIsAFi4f1lgalRIzcryLpj0JgyjfhqvSJOaajJQ0w/QbPLgt7vojri6hkPP778z3MefARBP9zmUnmfwInQ2LCKCXdKqbLX59rgXQPFqGyB7Of1M0+mrrnRlaeKKWTNUxm2MBp+htk10EktO5pm0CzoJH9W/+9vcu8jRIRcEPNlLG6+W9nivRPiOX/bL3tLbjhEmM2GUPES5MAhKhUjoOLRk8dT7/dRDnUeQ6sIPLwQcsQfw2f/8dKHtBpnCkfyIKQH0liz4We2+GpeRz/dGg6fQfzU/SjG2dEhn20vfQTqOR9NL5hQ9VSAiR3s6/VfOAyssgiOMcn7LKYyQpWn4Yk5Vw/Y5N0QuYUywE1OHKmdur/Mhu1lmp4cMjrIi6mJ4KWhoD3DPSSzOj1J+VzTGig9LMtzOXBXpbz6w3INnA5jwZ2scm0No7+GHO1h2gLiuUvUbamEOQa1xtIrPOBzk0pZwytn4zRyqO9z0ciloXmzZzfJAT+R2aAFFyxcd8ALIbZkM18xH1QLrpVd8TXAxiKXad+rDSscJYzt3VrA1ZtJB0ghsk90ab4AX8BBl684KYiYXPXs5y7e4oLBUOpYXdeesqMUMbJlGWvtYxm0V8sqmUMIIAq8HYHky/XQgAtQeHtNR3wu1rS5uEpw6JhjRiij79WjeNd7ZQ+cq6IRznBcTxePBEoq0NRz4yow3CZwm++rZ1B91nh0KBU8mBvhgyB5yBuEKBIONBfB7niYIX4vuLtbBaO+mN/
 F5xedBVY
 KUVucStD1e9Pw227FXDhk8qGVxOcv2ve/5twWkPrfS0BZvozQudOYb++M9Yb4MINDxhpJDkmXZYb1YOPR7Idc36q9EHqRDlG6Ubprr2yIcj1DuR60Tts7iY+SMdidKOps4X+pBXrrBg/03C1cCI5TFA4uBSviUa01T9M2iSoQ4mYBdGheu+emuooVQEO2njym8skPGKIV3bx/9Towe1GYRe4cHzi6OWyZQ0EA9Cdmvra98alZ+FZnkgd/5Cs0++4d//DxggMAPbczKwkKeb+Qd7q50eCFNHbTFDydczDeB0b1cnFDK2H4kKcbsJCWxwgA1dD5TmmMf1LQJQ5DYcZOvJQROVC4ZYmcG8uyXYUWu65o3wY4mcyXR9RjLNQchchhy4cIajZhYj0rXDHI4pPQ5r7nm7FRl0q2zRaeORvce3EWPomgI+weP5Mxd+cS/KZObnkzX7ijs7sxbJV5E/4crsdVA2lV3TKBRtYhWM/AJUdamIifiZ35l3c/1tZrouwUociQ5rRBag0RSe7GR74JBXe/9+wCMy87jk6CJv9pMoKLFxX0LbcCyFiegXf1nFJc/p9wZEVIfo3mhSV2JsL66RHr2nPfgTrBavkagyjZdCmTYJyk8gigvJM4wEzj5HGMJvQ+NG2Uc5cRnqAT1qudqWWpgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor ____vm_create() in the KVM selftest library to extract its
initialization steps into separate helpers vm_init_fields() and
vm_init_memory_properties(). Also introduce vm_create_from_fd() to
instantiate a struct kvm_vm from an existing VM file descriptor.

This allows test setups (such as guest_memfd preservation tests) to
reconstruct and initialize a struct kvm_vm when restoring preserved
VMs across live updates. No functional change is introduced for
existing tests.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 49 ++++++++++++++++---
 2 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 04a910164a29..0626efa5a73b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -471,6 +471,9 @@ const char *vm_guest_mode_string(u32 i);
 
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
+void vm_init_fields(struct kvm_vm *vm, struct vm_shape shape);
+void vm_init_memory_properties(struct kvm_vm *vm);
+struct kvm_vm *vm_create_from_fd(int vm_fd, struct vm_shape shape);
 void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
 int kvm_memfd_alloc(size_t size, bool hugepages);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 195f3fdae1e3..d3f98d9eb709 100644
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
@@ -392,10 +388,47 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 
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
+
+	return vm;
+}
+
+struct kvm_vm *vm_create_from_fd(int vm_fd, struct vm_shape shape)
+{
+	struct kvm_vm *vm;
+
+	vm = calloc(1, sizeof(*vm));
+	TEST_ASSERT(vm != NULL, "Insufficient Memory");
+
+	vm_init_fields(vm, shape);
+
+	vm->kvm_fd = _open_kvm_dev_path_or_exit(O_RDWR);
+	vm->fd = vm_fd;
+
+	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
+		vm->stats.fd = vm_get_stats_fd(vm);
+	else
+		vm->stats.fd = -1;
+
+	vm_init_memory_properties(vm);
 
 	return vm;
 }
 
+
 static u64 vm_nr_pages_required(enum vm_guest_mode mode,
 				u32 nr_runnable_vcpus,
 				u64 extra_mem_pages)
-- 
2.55.0.229.g6434b31f56-goog


