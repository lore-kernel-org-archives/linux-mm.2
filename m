Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3EB7C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C976B00D2; Sun, 20 Sep 2026 15:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934906B00D3; Sun, 20 Sep 2026 15:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C5D6B00D4; Sun, 20 Sep 2026 15:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 459C26B00D2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:40:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B619A04CE
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:07 +0000 (UTC)
X-FDA: 85235156454.05.042E09F
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9E38F80005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CpNKffh1;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933205;
	b=LCXk/cBjpMJwFkeKDBap6r/VGsnI2oHB0Bh0ylvKLC0rEL7BIID7fcKnyzNahkE741Ez7B
	J5HqQQCZBbiKHFaXRgfEmoGbyYXFlgbBj43pG/PPQFbZxeNi3jCSRRjd16I+yHziyogCm9
	vWx26B2uACwSV0BS6waGCTLytTZrRUQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CpNKffh1;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xCjTdloxc6nkdYmhJBIoS65cvexU8uxkyprCbgscSQ=;
	b=YdldfL64y/k6ERe8xGB33fX/eOLgDJpeZdMuGnjqI4n1KsvD4E9JcX8q9Y5n+GZNbmb+sK
	c8xlo1Mp3eo13IPHRuTNXyzQMMtRTxJ28HAohhtbRxHh0XpGcN1NAvOl2he2wiPA7wfW9O
	yMDkv1aROZNXMcMnH8nQF//vCvKRcuA=
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895eaf31683so18042197b3.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933205; x=1790538005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+xCjTdloxc6nkdYmhJBIoS65cvexU8uxkyprCbgscSQ=;
        b=CpNKffh1kX0j37xYvU/Kg547uvAxUS49Q233sbOMKuEKUIiCrZYbruRiTDYrL/j/YI
         iuWUp9an4RM0E9Ahfyx+BDr4u5wfSSejv0BBX6ejtxSSEo1bEkLzqF0m6UhUC3qwAvvB
         upgRnzFgmWbcDVXl4Qk4ok8gDITb8suWUnXoWkqS93bOJunl4ZK286xyl0u5abZdJDNu
         8HWRi0y/CWa0bc6cv8dpPo79QvM13HBecN2vyS6Md7qpnbWEY3XYi11olc2s1JBu69lK
         bfO3T8ZTX85msezUyH0NlsPO44OZcM4kRRD+Y5EOwUU2tp8HL5eq9bCB6tgEoeUXMM3T
         hhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933205; x=1790538005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+xCjTdloxc6nkdYmhJBIoS65cvexU8uxkyprCbgscSQ=;
        b=r3veWxoKfWdg6gggPwW76uzRNaGtU8R3eEc8JR++ZnF8LV6RbTjCRtVM9wTq7aZxoE
         ZW31ahDNOte0TO/Z2EvO3yDfsMZnuBMGXK4bWBvBJQz04JXFjGT/2hJZ1C0hZqE3H82s
         qnu7tSTwT/4Lw91jd5iNZc21/0/GnDuytj9F3TFSGxbcZgxtpqKoxBFcIulIEc3O19nI
         +TBwOLKqNtWyBkiMGaKkVDJnFbz236C9QBYy8E2GIuIFfjCXrz9ONXXufjLiZ4sYgXLU
         Dtmq370HBieoJ1A5Ny7sf2ocH2cBAfXdq7n+TkUSspM401Y4t7awglims2V0At3g2GBr
         ihmA==
X-Forwarded-Encrypted: i=1; AKwUvBx8JAJEDZKcUncCKpdBesQFD++7tG7iiikj8s3YknNFjQ6FKY6f5Vg+6OlInVwGMxRojVmrS5pZmw==@kvack.org
X-Gm-Message-State: AFuF++nyER1p73ciU17eZ1RE08FGP4ZtcJRqqZFbpINl3RJpWUvnAZIp
	zqcsjvtzal/RzfILL9EbltrOfJf9MgXWjQXeYcwJnch0Qs0CSgzgZ8KHC0NVoApHJWg=
X-Gm-Gg: AYBFou2CZaAwcWdeSN6OdLKzzZq2mYJornNXQ45pY5hLGApYf/uUFGrjoqRk9kuWLyL
	1GWUnIAiF3BGmbATOF0uZPnNIvgM4TAHxsSx6mVaOrPl5RP0BN7Km8EVMJxckGCo3hVq5TIbgzI
	S0fla5GURz0SV39cDXid389F7+t81MI9TNnV4lUKeOVhZR2jyiFz0M6S6bwEgNqrBo142KXHMfq
	Y+iS5FMQFl3KiO9SWFJfcg239qnW0TeqDIY8r9Vk+mV9Bav8dKa7yI8/NG/dDSAZsfpQHsmpcbc
	MQSDXKs/ww10bX1P4Gx1NqOZQKNDajEj7wpAJEJhOez7oKOR6Z1vPl21GiIWSMfSsHmi6bRr7kD
	8O0bonIh9AEddBJbRu89xjY5qz/tNEYGQZfiNVDUJHUgrOYT7lTcExTJrvAe9Ksxn9LK98vpvPZ
	5LKzTiP5vVDij2oT/imjiie99YIWYZ094zzsln/ftwtxJJgudzXvV7+zY352rMse2ih7D65sR72
	0q+aF4XurIZiDJ1l6IuDXutuBJ2JD2Y7+Vvpi6b4zbVjvLqyhEBBt856AvNf0fKjOM2KsZ72e14
	BheIoL8Y5q9M2fP5mWo=
X-Received: by 2002:a05:690c:d8b:b0:873:5c6b:a2ff with SMTP id 00721157ae682-89736f266a6mr23324237b3.45.1789933204717;
        Sun, 20 Sep 2026 12:40:04 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a45d8de3fsm18926787b3.8.2026.09.20.12.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:04 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 32/46] KVM: x86: Add TDP MMU KHO preservation helpers
Date: Sun, 20 Sep 2026 15:36:36 -0400
Message-ID: <20260920193650.3373435-33-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E38F80005
X-Stat-Signature: 8enz9nrcwmjymbwt5u91u3p4mra9h1o3
X-HE-Tag: 1789933205-523252
X-HE-Meta: U2FsdGVkX1+dJxQ0o9lX1T3DSmHHllBw4O1sqpPT7hVzjq6Jv6pSfms91SX6ry2wXLWJgJG48lSTBZBo77NQbrsnIurtpoN93RKSvttIJNEjr03IIYSMaz1BKwodgGxgHy+3YEVKMaMOo123dV3f8jr7RMkG7KA3wFjDxqYIkAPLZmanJy+f5+Yss7Z4o6vNgN2E0t6X8kvGDSEBxL6rqHKsh67MQ2tbpYEBtWEmXPHWhAYP//UrifNbOaEmxhVOUHEj7/C5nilQJrS37eJERJy6Ge0rXSZEDqUEGHVMubZM7enu1TwzJELTiqU3c23nHI766ePeEJ4u/fd16AlY9zJy0sTrM2dmk16rJRvv9xbt38WBXTciKr0cPa8wTaXGCSaatJYonEuXYtdCve2qkbvMI9amTs3AKXvvPfdGtfQ27r3iuQbd6aQCMS8UlyZetFbWMGE++JtE5J8pOxnSMXrduvG/prL5+CLg+kz17H3tMFruIkBQ5psnp/sI22K0WOQ5w/H7G9zSehQbzQf6/DN9mQ3+5Y5w04xMJliVdKolSCkN0f8nLIEYru3PnvXgbjzd6SPSFDtesSx8RUYyQQnyjKOuSHF3Z/IMARnhwnuxJKFZuKiXffQUesisEX08Lmdiu4EHRyZ9USPdCopXHAkORpFvHzV1tlPb+F9dRjHCJyNODcRJ4P/henZKu5hZGcRJRjFdEFpYk8BfsZF4ndmUFZODCmfCQYBD+RbX+lAEcIXB5wveZbkTupFBLOpaW5Cck/chho0eyERlfPqZldKQ+ghY3HV+W3Q30Ic96FVCEVmBE/FQ0AvnCr53AOXvVSESsz4hWxg3e3SoZgO0+IeRb8iDEe4fuxNYSf7L+jj0Zs9oexVW4qBgXi/dtFH8RloE83RpIlSIG/z7oCis9JAxkl21IdfJ3qo8+L32AEjH+Fjd90DTZ/tz6agW8phGFYfxPZcuxOXLrhyFewp
 3e8ougKs
 7okbE/aCxC29vBykajikKcKcnw10Bu5sJ5mcK1aNxgu0GnSW/oLeYOpNcMM/fqqU8vgP7o/CSSsVWhwHlF5KFTQU2xgxb4rMe/GbxYnCOO+R6QndftLr+WywTuppL/YGcWTrBQhyLbaDCa8fMnikKg/Vn668yZYFTvxeT7SIDUaZrtC1i2h9eNNS4dyJsBoMRgdOBnARaR6yN6SxmMxLu6vyId3uQrf9UrT/3I2Q/2wi/WIVnIGW7H4cqzWaPQFKl6Nv0W4UwzsVJYSIcAi0NR2vLiLlW2LuBSLInX13FXOjkMtejVcEV0icWgONRqcBnGpBPDLwUXYA1sP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add arch/x86/kvm/mmu/kho.c to preserve and adopt TDP MMU EPT/NPT
root page tables across Kexec Handover (KHO) live updates.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/mmu.h     |   7 ++
 arch/x86/kvm/mmu/kho.c | 193 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 200 insertions(+)
 create mode 100644 arch/x86/kvm/mmu/kho.c

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2ae7f9ed4cf8..f35948f0906c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -410,4 +410,11 @@ static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn & kvm_gfn_direct_bits(kvm);
 }
+
+/*
+ * Declared here rather than in asm/kvm_host.h: it is internal to
+ * arch/x86/kvm and has no callers outside it.  Defined in mmu/kho.c.
+ */
+int kvm_mmu_preserve_kho(struct kvm *kvm);
+
 #endif
diff --git a/arch/x86/kvm/mmu/kho.c b/arch/x86/kvm/mmu/kho.c
new file mode 100644
index 000000000000..a04600f0c3e0
--- /dev/null
+++ b/arch/x86/kvm/mmu/kho.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * KHO preservation of the x86 KVM MMU page tables.
+ *
+ * An orphaned vCPU keeps running its guest out of the shadow/TDP page tables
+ * while the VM is detached, so every page those tables are built from has to
+ * survive the kexec.
+ */
+
+#include <linux/kexec_handover.h>
+#include <linux/kvm_host.h>
+
+#include "mmu.h"
+#include "mmu_internal.h"
+#include "spte.h"
+#include "tdp_iter.h"
+#include "tdp_mmu.h"
+
+/*
+ * Page-pointer accumulator.
+ *
+ * kho_preserve_pages() cannot be called while holding kvm->mmu_lock: it is a
+ * rwlock_t, so the section is atomic, whereas kho_radix_add_key() below it
+ * calls might_sleep(), takes a mutex and allocates with GFP_KERNEL.  So the
+ * walk runs in two phases -- collect the pages under the lock, preserve them
+ * after dropping it.
+ *
+ * A NULL @pages simply counts, which is how the caller sizes the array.
+ */
+struct kvm_mmu_kho_pages {
+	struct page **pages;
+	unsigned long nr;
+	unsigned long capacity;
+	bool overflow;
+};
+
+static void kvm_mmu_kho_add(struct kvm_mmu_kho_pages *acc, struct page *page)
+{
+	if (!acc->pages) {
+		acc->nr++;
+		return;
+	}
+
+	if (acc->nr >= acc->capacity) {
+		acc->overflow = true;
+		return;
+	}
+
+	acc->pages[acc->nr++] = page;
+}
+
+static void kvm_tdp_mmu_collect(struct kvm *kvm,
+				struct kvm_mmu_kho_pages *acc)
+{
+	gfn_t end = kvm_mmu_max_gfn() + 1;
+	struct kvm_mmu_page *root;
+	struct tdp_iter iter;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (root->spt)
+			kvm_mmu_kho_add(acc, virt_to_page(root->spt));
+
+		for_each_tdp_pte(iter, kvm, root, 0, end) {
+			struct page *page;
+
+			if (!is_shadow_present_pte(iter.old_spte) ||
+			    is_last_spte(iter.old_spte, iter.level))
+				continue;
+
+			page = pfn_to_page(spte_to_pfn(iter.old_spte));
+			kvm_mmu_kho_add(acc, page);
+		}
+	}
+	rcu_read_unlock();
+}
+
+/*
+ * The per-vCPU root page tables are not linked into active_mmu_pages, so they
+ * have to be walked separately.  pae_root, pml4_root and pml5_root are each
+ * NULL unless the corresponding paging mode is in use.
+ */
+static void kvm_mmu_collect_roots(struct kvm_mmu *mmu,
+				  struct kvm_mmu_kho_pages *acc)
+{
+	void *const roots[] = { mmu->pae_root, mmu->pml4_root, mmu->pml5_root };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(roots); i++) {
+		if (roots[i])
+			kvm_mmu_kho_add(acc, virt_to_page(roots[i]));
+	}
+}
+
+/* Collect every page backing this VM's MMU.  Must be called under mmu_lock. */
+static void kvm_mmu_collect_all(struct kvm *kvm,
+				struct kvm_mmu_kho_pages *acc)
+{
+	struct kvm_mmu_page *sp;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	acc->nr = 0;
+	acc->overflow = false;
+
+	if (tdp_mmu_enabled)
+		kvm_tdp_mmu_collect(kvm, acc);
+
+	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
+		if (sp->spt)
+			kvm_mmu_kho_add(acc, virt_to_page(sp->spt));
+	}
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.mmu)
+			kvm_mmu_collect_roots(vcpu->arch.mmu, acc);
+		kvm_mmu_collect_roots(&vcpu->arch.guest_mmu, acc);
+	}
+}
+
+int kvm_mmu_preserve_kho(struct kvm *kvm)
+{
+	struct kvm_mmu_kho_pages acc = {};
+	struct kvm_kho_folios_ser *kp;
+	unsigned long i;
+	int ret = 0;
+	int attempt;
+
+	/*
+	 * Size the array, then fill it.  The guest can fault in new page
+	 * tables between the two passes, so re-check for overflow and retry
+	 * with a larger array; the slack makes repeated growth unlikely.
+	 */
+	for (attempt = 0; attempt < 5; attempt++) {
+		write_lock(&kvm->mmu_lock);
+		kvm_mmu_collect_all(kvm, &acc);
+		write_unlock(&kvm->mmu_lock);
+
+		if (acc.pages && !acc.overflow)
+			break;
+
+		acc.capacity = acc.nr + (acc.nr >> 2) + 16;
+		kvfree(acc.pages);
+		acc.pages = kvmalloc_array(acc.capacity, sizeof(*acc.pages),
+					   GFP_KERNEL);
+		if (!acc.pages)
+			return -ENOMEM;
+	}
+
+	if (acc.overflow) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	if (!acc.nr)
+		goto out;
+
+	kp = kvm_kho_folios_alloc(acc.nr);
+	if (IS_ERR(kp)) {
+		ret = PTR_ERR(kp);
+		goto out;
+	}
+
+	for (i = 0; i < acc.nr; i++) {
+		ret = kho_preserve_folio(page_folio(acc.pages[i]));
+		if (ret) {
+			/*
+			 * Undo the partial preservation: leaving pages marked
+			 * would pin them in the incoming kernel forever with
+			 * nothing owning them.
+			 */
+			while (i--)
+				kho_unpreserve_folio(page_folio(acc.pages[i]));
+			kho_unpreserve_free(kp);
+			goto out;
+		}
+		kp->folios_pa[i] = page_to_phys(acc.pages[i]);
+	}
+
+	kp->nr_folios = acc.nr;
+	kvm->kho_folios = kp;
+
+out:
+	kvfree(acc.pages);
+	return ret;
+}
-- 
2.55.0.1082.g2b9226bbc0-goog


