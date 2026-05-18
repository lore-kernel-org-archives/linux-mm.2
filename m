Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79F1CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46986B009D; Mon, 18 May 2026 05:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07DA6B009E; Mon, 18 May 2026 05:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43536B009F; Mon, 18 May 2026 05:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9533C6B009D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59D24A0850
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:54 +0000 (UTC)
X-FDA: 84780036348.29.01FC5D0
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7D65D180004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GETPpbfa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3st0KagkKCO8kRilejRYlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3st0KagkKCO8kRilejRYlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJXHhvWcO8WVbNSPa5FuUDQ4B9keuIjD7ZJ/qh+m6Pg=;
	b=KoDsuLj5fJBgiUCE4x63/BBxhe4+1bJHpHVAJ6CbnzM269RVxAInrQZ8CfKgwm5zpQsiBA
	99eqPIGA8CyeBQHz7zPvqTT/TWnJj+cneVOm8wYEJ6Q6a0aEwkribp6neX3MigqeFHVOGg
	i5VguHwG2V8MryAe6qN7CSOu/644tb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097012; a=rsa-sha256;
	cv=none;
	b=z1c1d/Dg36wDxG7kzN90lghIMxDXZ4V2+LGlPk+IXZMEpkwHVCskXazFDGmkiXrnUmSG5d
	dv9wddjBk96oqjM/LUq7eiRZx3gyjBdr2vlw2scHIJ//w0rcImGJAP+cRggBnym7czKjkz
	r49SDl1tEG8RGXALShPSBIvgWTZQUvI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GETPpbfa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3st0KagkKCO8kRilejRYlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3st0KagkKCO8kRilejRYlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--tarunsahu.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bd548eb1008so187767966b.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097011; x=1779701811; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJXHhvWcO8WVbNSPa5FuUDQ4B9keuIjD7ZJ/qh+m6Pg=;
        b=GETPpbfaDZP2DXWY9X36T+LUrmrVWhHFkbfwycwV7Mjt41xdkibgzGIsKiPtfrRiB5
         2AyejlWx0UCRGOkByKpSO+eH/v6D7cfBkUmgOekveUACO00EukZi99n5VfWtf6ex0Hga
         QzydSW/epinH8tFrKQLRoOj+ayP2iSpeanjJ8K3qhbyWIi3N4idn0XR4sdghV01jLyoB
         3KvhRYmZOrqkeexcDv/FVmxkdfooGhHnSBh0MC/R3PY29hqzZgV8ZGwc/Kctd4pWfzsD
         POBcv0htLx5Lh//4NICsKatCf4rFqwAe+C6ZqH3CnP8uEMboj0To8cPiYdBPFx+G9i1U
         Kbog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097011; x=1779701811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJXHhvWcO8WVbNSPa5FuUDQ4B9keuIjD7ZJ/qh+m6Pg=;
        b=lwGjUEoeNkaeefPmo6jatC7F7oOYC1VtzDFuSfVsLEezUE6lDgAANvq6QCr4rkareB
         a1uBbkRn5LK7PvN2epuP2JDN0z6JP/ZBcVt5vRc/98yLUV/a3bpsyxNTPzZsBOyXN+ZC
         I4PJJbdYdow2bFmdCcqmmfYtKhkHqUU6Q6yeuNmsUVRIDeGfRy7skvjbyCOvvx0AhoM0
         0HpupLZu8/HVrqbOumvxdrwh1dz1X/LGXSwriXFHMwl87eZT+YEXLPOSx6CY+411pP0L
         PihK8NU4kFxiJ+kRrTEpg/MZkvlVxLexpnS9koI3DEfsb5tj4Eb9QCNo9pgRVzstVsV4
         5plw==
X-Forwarded-Encrypted: i=1; AFNElJ8XK2X24raJIMLP2UQBdPfOmmJQOFbtDNgSbRdw63FqHnwz3i9hT4LbE5R9YrfUfPLdmOK2mN17BQ==@kvack.org
X-Gm-Message-State: AOJu0YxRiU1fx9gVOC5iYFkPpDCNRLNlUagJ8rvPsqLbdgCH4XoZ7xTA
	g76xY2mn/4Q/0BvteKQ13gxIgyLmnqOIL25kvchCNrMSr+LG1BtVrjZzD4aUiQ7bz6wyzIuAm1D
	aAgsVoknh63zHGUCQqg==
X-Received: from edcc7.prod.google.com ([2002:a05:6402:1f87:b0:67c:a74a:6214])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1b1b:b0:b9c:3d56:e4ec with SMTP id a640c23a62f3a-bd51797a576mr551071666b.24.1779097010457;
 Mon, 18 May 2026 02:36:50 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:38 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <8bf92f738d3456ea71ffe2a8406714e0d2afa114.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 8/9] selftests: kvm: Split ____vm_create() to expose
 init helpers
From: Tarun Sahu <tarunsahu@google.com>
To: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, ackerleytng@google.com, corbet@lwn.net, 
	dmatlack@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D65D180004
X-Stat-Signature: 6h486d1qzsyyuipz37ytftxz5dyqkrou
X-Rspam-User: 
X-HE-Tag: 1779097012-963101
X-HE-Meta: U2FsdGVkX19zwN9ux0hpZ56sfJ8nRifNYUDw23Gz2v7xvAAuZNOJdcMuYKorioPfWXW1W7U57G8KO35inlL4sKDdYL7wokuMLwDLyPaAsCcE+FoHmfD2Hfr4Mm7lqbtYuOYLr+dIC+QeOH4+HHzzmH/RTqYhzRKlUijHyuvSSzHeF5TJKW0J0xqRlAeV/uov/omyQfEU2c/9IDbL7IXJRp3goXX7dJnYvXfkU9LlPrk254rgY8K4wy8Y6/QEwf/hQXHJNCUwxryD200PliorBM+dAzUP1KISQUz/VQxhxlRjCm6XAOppS3qyi0O/vt4vgGuz7uWDbtJLJ9VPdwiV1QJwLEcv423/Ftp1f0pVxp5oZHJz1BNrZoGDz59CUyItcCrY/ExgJTAe9DbPjIMqW/i3Qx7x3n+r/6rx9+bFh0CUvyCEh+HYHJajBo/KyXC5clUC1UInzudA4PafY4E1qyIJcbtJqM7BvwkOhYvy6pJPga3f71+YF+VTjHXvjWihiPJDpOnXcP6sfw57fTwxPCyee8J7r6HvVGTe8uvZNJi/+C/WtKjY86uKoWa9g4HLJeW6j0cZQta5z376SHFB5NN0z1jAaGIHmyTaQrGEJjtl2NN0Jp565AvT7CGk8weDy6fDF49vC+nM0DKnHd0q+kEokJUMuRpxgKzUmqa1hPRKVOQ4c9D/SpZqKwuqr1hB/GnrUve/CwvHlgvNCXiC2kbVJwmkZmJKnkCCmg/2nAQPBFmkBsYWCddzGA1XW2eIPloYvk9mqQUw35zNj1opVMgMRnzFij0Rln8Dyer/04pzLb5PZ7Ood0sc20f8tszwuaK8t4puHdT5Y8ENysQNs3yhUNFJpQwL33EjU13/0pS+Y0xMV5cdrtjHrT3EQ6ViH73TCZJ2mdQQcdw9CCUU7m73bVyn726VPeiQJj4s4msTcnHrD4ncCSToAtG0s6VtaS9c1EoCFQ3hKLx/haJ
 +ZbXoFOi
 gYFDnjpGgBENzEQ6I7Z2EFfqWFwmfx9BemFN2el6F/64s/EZDvoaAXmmEAAEGrYeZT8mYMwkQOnnq6iGoFESyb4+jA2vtSsLbluQc+HxRCUxVPzhKT6LKxaSPKiHqz17NRMsjeU6YlqE5cB3zcfwm9R/QsAkb53G5bvX1jmmSuNy9zOMNTENzcAn9Q1ENZEsuxM1i6Ns67BI0eCD/h1Xdq2JKFKr4Gz9RdpjcHcHsquLTS4Ec5nz6R9X8geps3jRjkcG8L3v04CcJ5qKDuzvGiGnyLK5Gym/bPPhHAkkLxWz9jCXU5gcBMZShzXVK1urTH1hIykOoaXsra5M5q8fR0c3u4sibN90AD81ErVddiLdavpRhcJM3f0+J3tPP9I+3XNdex401dpo0X1tOAuPzwOxNbjitnwtvZxaHfcrwLAC4lZHTCVGkA7qIo23D1TAWDBAQh+kl01zCIDpn/sR406kTK/R6k9Uv3IC5Qae4hGY1HNHudrMMKCF5afLAyP6mUD+rm+rAOkoZTZSYBPXrl5XQhHohYuE1rGceZPCrrm4sV8vKAu9NEgTuLhJ1QEfcPcCvCS7+D67eSvIEf9wQOj6+wE89WRdRDwlBUrcnD04XUi2ACHkXFyCdAg==
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
index 2ecaaa0e9965..d10cd25d0658 100644
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
index 2a76eca7029d..f4cd06d34ce9 100644
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
2.54.0.563.g4f69b47b94-goog


