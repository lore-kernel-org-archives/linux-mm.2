Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CFACD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EEA36B00A3; Fri,  5 Jun 2026 13:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953086B00A4; Fri,  5 Jun 2026 13:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5776B00A5; Fri,  5 Jun 2026 13:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 558416B00A3
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13F928CA66
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:55 +0000 (UTC)
X-FDA: 84846493830.17.F54BF68
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4DAA51A000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j6INSR6z;
	spf=pass (imf19.hostedemail.com: domain of 3owIjagkKCIw9q7A38qxAw44w1u.s421y3AD-220Bqs0.47w@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3owIjagkKCIw9q7A38qxAw44w1u.s421y3AD-220Bqs0.47w@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679333;
	b=DTuVbLPtrpktjtq1UhXYCeArRViEpsAxEU4lVpi5WLoierM/65bRpEMns6ocM2OSOyTjwD
	gx6A3+quVhrxpTW4tQmBkw21lXkmMPgkPyqZo8/swOMwlLIpQWp5wpuZgMovTqVTgUaB8Y
	PyWySPZ5N27yaZD4q3L5DZkoFzmSb18=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j6INSR6z;
	spf=pass (imf19.hostedemail.com: domain of 3owIjagkKCIw9q7A38qxAw44w1u.s421y3AD-220Bqs0.47w@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3owIjagkKCIw9q7A38qxAw44w1u.s421y3AD-220Bqs0.47w@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2ojTho6pPozBEn1mINsChz/MA151sbs8LFhRJ1lhS4=;
	b=wN0t08b9netLcsap8xJY9uV4ssi0IE/oUk4Rbil7xrdDxvH1i3i7Wj55SpHR1LgcuQlBl3
	noMd+F+JWerBjBsTxkkO4VFHj5fy2k6DMvRZzzDawOa2ncKraKyNeWfJGd0gMFubAeZBjq
	6WsTSin89F1sqAcE2Df7nvmLgAffeSk=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-68f9f08cfcaso1695135a12.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679332; x=1781284132; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g2ojTho6pPozBEn1mINsChz/MA151sbs8LFhRJ1lhS4=;
        b=j6INSR6zQRNchLyqtz44b0M95L0ut4JPzuHknjWypb6HEv6XPRTs368O1TCEhUhmNN
         Zgg68s319b0KM4zNKvp5/sKPgaNUn7TyJRp3/G9MFdoDSC0uLyNEqbuRTKfKKogW2OHX
         nRiFhCq8VYwQoTKFY+oMcZs8VpCyNBKLh1wy6JKMnNAdy8cujheGS/bJEczO2iq/7FI7
         1Hb+3rUaRToB/mgcXYvj58ooqHRTPN+/tqHbv3uRm3YqsjklPxOM2Rrl4Xr1nXD2iQlQ
         t52+ZVILcOFEZpzzWL+j818iC+Bg4Z7Iqgh9oF/rQuGCk5FPMMbPA87i529kgdtoOawo
         E/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679332; x=1781284132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2ojTho6pPozBEn1mINsChz/MA151sbs8LFhRJ1lhS4=;
        b=k977wJPVB0aYtQA1kxChjYaD0dXuc25Oc1q05XLZDJb9Fs3c7XPENVDi+3IGLvdeCZ
         /wObCA93yb79PjL67NFFGJodVZTDlS98v5y3YAJp0hwu2r2crwIOiVFZ5E+M+WzEjBH9
         CGuIciePwrf/jP0VDLr7cx+DK7WpyxkzbZy7wCGg1lQRWeSuQgwiBp4HheWq53IUjVPa
         D0YRHDW+CFZ0QxM81qsLKkFa8kV2M4BS0gC6F9RzShQyFdML/C6QrLtdNCF0RBEmzT8I
         uDgEMhgRPKEGV8wgcuxaq/3jW2d9qn6O0EwGxJ0C2Z0gG6ho2TZwaPo5f6JPhnRktiPO
         5yww==
X-Forwarded-Encrypted: i=1; AFNElJ+eu6AGW/ERrfteaUMJzdDCamxt27VmAjyt7JUxi/ibCWxGke6EQS0gfwGEqGbVLkeqhEGFRdkKYQ==@kvack.org
X-Gm-Message-State: AOJu0YyoAB18Tv5gXIyi+fOBfBcSLnoxGG0HB4TSJhrb6BL0p+kewCBp
	KC94VSs3n6rmQKmokfLekQMA6nrPNYqTx+mnpa75qVJX2HM8Hyf5Lc35daMLwEH5hjDkVK+TwME
	OV62bepB662TNPiaYog==
X-Received: from edra26.prod.google.com ([2002:aa7:d91a:0:b0:678:e4b0:ff8d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:11d2:b0:691:5124:45de with SMTP id 4fb4d7f45d1cf-69151244880mr66851a12.16.1780679331513;
 Fri, 05 Jun 2026 10:08:51 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:34 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <4af286e970b7a44b539f78d746e92b91571c18fa.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 09/10] selftests: kvm: Split ____vm_create() to expose
 init helpers
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	Tarun Sahu <tarunsahu@google.com>, fvdl@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, 
	aneesh.kumar@kernel.org, skhawaja@google.com, vipinsh@google.com, 
	ackerleytng@google.com, Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, 
	dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4DAA51A000A
X-Rspam-User: 
X-Stat-Signature: ekcqbjpbqrpe6jkudwyrebfwk9wg86xb
X-HE-Tag: 1780679333-239208
X-HE-Meta: U2FsdGVkX18Kjczmh4/H5m3nUJ1+2/2JgRc8X/kcrMTv+zKEVJCIcu0O+3yr7w0l+ynmxeBN03irm7QV2JeyWjdpHKHTfusomGALSG0kVMEiBjkKE5xkqyPK++5SVc6n2u8yPh36inai/ABdZV6kv1tvuSy4KChEgzH6zd6oU7ZgPxnLOAflCHQZvqvUqwaaCwYVZdgIp5v/xfV70Y6k6/c9fEW7ubaSFWJZFWe0Ag722phGYYr6AsxlV/hZ7QgbvVwa4YrI2EgKQbtrGIlzOpYta4EeNaNBkaKTFe63zQZmk/oQCuL47tyaV5aY3J6ySBXYVDrFGc3cJyYMqWPvw29jWCzZVeF4KzIUI0rVBEN9efdfekIhAB3TtBfvsrwr1d3KBF42kD8HYOem3uWzuR0nBDkbVOcy7YYAKA1M57dr1PZ3QEf0HdtFUfG1kxoyvjGhlQI16s0TZP2zjGfrO8iuCt6g4D4T5WiKm3NGcljLYWX5hd/74SbympaeXjTpUpoX2Ej9ey8hp19/E8YhsWFnLo+NTW/TUyrdIoJwwg0folovOFNvRbzfmk4tM7OLZJliJaYnqAktWbHACqMQ0WKi4nddN1+uvXCk14+HdmaIc5+iiqFtlcSPJcIVdsKyeJGIBFtBGsMqHlMwHGR9sk+dpT0e5xakaxM8v76vNR8bQCIziyHWB+A1D0kHHIgYqhdARIwVzHgfirto17NBdEbLa6hqGfsW+sH5dC8w6O6WBCsuY22NWuGN+jE+yk6Jr+e1RVVX/ffzw/d1l/J29dOD6/uQ1g+Wai69Dm4k3XwI7waAzO4n1gGJqR3c3iume1rbimshaxJxAGoK0XCpWBOCKm0z0m0SJT2hROEATaWlCWounxENxKI2aniBh/qj8AXTcfGm8QN0qsVl9ul3k2OPy7mUGoQ/FxYIlZQziWzIgrRdcOqJKlrV30kzI4zkLu5JPOpMGIS81ohOxgz
 OQ3GEQk2
 ij6n+JFxGFpOvDotlR9OqKh32TyUo+72JBSdlQmP33qK5WeKgq27b3pUNCfUKyqqZACqq7ay2uzZwIR+BmS54LrU8kj/oqIe/S2iI7CqU2hXVQ3t0nI8Ub70CcNjRLq0/WIWoPeWS+FndbM+TeIkcaTn1a8X6YWEsE0Bxu+jUaoVeMtEmrCiC39fc4CdHVFcG576JHu4wUNQLKWJmA/FsjwTV8tEkffRqaNLHuj6QAzTC0Ixyseh5eP1aRwGAGivugLDOAVVklZn+GMDH3/tUCMgUPETPSpIzVyu4UpCYkIwdI47ikDfeKO603VyeqX6RidWjNZ2IOt2+mENge9TQZRcbRgszauXsGwLCu3zFV0t3nbpCKhAdcr/MTIlE1FpWW9CXw2+eQhO8YC+Yay8Gu/MQ9DNHx4bGanKXBeRUHwgSLfNz7dudksdZVZrj1K/EQI04gUxnoH2FxLdV1Gponu4KcC4uEAWuFWXSTzq8WyUPQ1LNUx14/FzqQcy8VCZrgeC13EOQ0h/oJh7Gpjm9MRF4zXt3Odl73GNAsSvReHyANqWgZXGzZpN/Q1ehJFH0EI4QeSEumxdX97qMfgYRRSNAfsv+1UnqzUzLtcDeaFgDIys=
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
index e08967ef7b7b..d3e6508e9863 100644
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
2.54.0.1032.g2f8565e1d1-goog


