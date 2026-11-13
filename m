Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C10F606A8AA
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vuPUpEsQ
Received: by kanga.kvack.org (Postfix)
	id 8A44C6B0651; Thu, 12 Nov 2026 21:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B706B0653; Thu, 12 Nov 2026 21:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A766B0654; Thu, 12 Nov 2026 21:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 401E36B0651
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:51:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C89734010C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:51:34 +0000 (UTC)
X-FDA: 85428570108.30.4019810
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 029A1100003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:51:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vuPUpEsQ;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794538293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=541U14IJrP2hrNeb4y3odC8xzLwDlMERY6cgBOIWeKs=;
	b=VH7G8i4nzQokwuSqtT1Vd3nzbh0j7VaL8LezzV8SrbyBqTiWNMSuyx0qG+jzNjVAS4f0BR
	Z4qJRRbrC7DvQ6imsCTpJsycR2ejUl6NNPZK6J7bquOVVL7yvPmJS670I0tm1rSmU/USPq
	KSOpnedqJvT32C85dtzG1r6BX2GPcME=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794538293;
	b=u0N7mkCbz9zVQhLXXRAfSdCbLDsMNsE0JrHYlBf8S+lGqm+oCwflPIF5XtiCzt+DlVB/0t
	Ew5aynWCPjpGArfEWizLekiMAD3F8xI8ZpdoaIhzyxOuDwEV9cXCmz7RUCaXLRC4HbK4Pa
	c1ofnAiR7Co4fpL1pJQUl9tm3+XRAiQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vuPUpEsQ;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a2761c69fbso978421c88.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794538292; x=1795143092; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=541U14IJrP2hrNeb4y3odC8xzLwDlMERY6cgBOIWeKs=;
        b=vuPUpEsQPsMwy1GMhY+CIZo/RYZFTl6bmKH/eBiMFjoB1GxmbuQU+7yEafsr6/EGNn
         fEDzVeUXmfxtBY9v/j6zCzO2wHJPEjqqoCnnxcYdqQ18aIZPbyl9+rCLDKTrnSfPhB67
         FOlSBAGAiFTDme12fOLzOLO6vMpRC0kMXV7kBhHmd7nvg7XC48tsKdeYe7z07mtsBK0G
         jYb7w5Osg0x9JfVyjE5SMkfqNK0Sg3KxCBYrbj8LPwu4nCUXb++CbqsqNbGNwehP2B1/
         pRjqk4pRwnjVlrhnmwhx2otTGWxEKpFtBfGjuDAaXD3GVso84LjrXKrKFjjZSw1/qXwt
         gr4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794538292; x=1795143092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=541U14IJrP2hrNeb4y3odC8xzLwDlMERY6cgBOIWeKs=;
        b=Qa5WJBWJf7Mtnq1ot7hbGfwy9VugvDe0D33rLwPSQB5VemHDB8pZSm7KpTAlWMxmjd
         5bxsoEgpB19v8oQPzZq0RjH+RzaYaRja0E1JuLGKa3y7RwwG8HX+PO0n0woP9/ZQMyQF
         fP3s5SKeJH06J0bKLl/4z7RMQFM0ldTFq/bhPEj7OtoFM2XvwRwoRUMaAskihKTd9fls
         8shK9I9kNFxUwTKpvvi+N6MfyV/Bdy1y8NfxEdSzm3UYek+vEtVRDkDLD2mqRtzfUmxc
         XVzW17zrUeju7syLU7m6SlMl7eqQX9DFawwfJUdt/zRD3MPKwFbBaDlsIpLBbGzEd2pt
         WmVg==
X-Forwarded-Encrypted: i=1; AL+hErGu+Tj5A1CNCRdrE87y0CmLDE1QNdPpFeHK/8awawdMvE0C0p0iuzsYVu6QVJBGBLcq+/+92m1omg==@kvack.org
X-Gm-Message-State: APuU4Z9UeZ0AeOBnvWQx1/N3Ht5SA5uaMnK1+BqbNK8VxGo1CRhj8O8j
	KsTffpm78zNYBpChGXg7Hsz0agYCrN2lRR1Oo+DX0+frvRg8W2Wh353r
X-Gm-Gg: AYBFou2AEHothn8DglUoCY1hUMWT2cvAcVvuPIBA8N+V92NfMOAZaqX5oYBv5/wPx5m
	BikiFygT2JDa0CLxuErGuJ/Gf7cfIhpab5/s7MeyBVEvNpI9xRLn3iYPzg8r8AYfuC9HwbwxS9v
	Z2yCmrFw6slVCuAJJxe4bMN8MSZVXc2i3W1pgLKhSoTLMs63oxCVbwzEYGskaen+jaN/ceNH7aC
	SJHI2dsqpFszqlUTBXTjOnOqqfwK3Pa2RssICZNYt04hjfysfLPoZ7QUW1HHd1f4HIER0POMZmO
	o0SuT+f5KyrQijP1HKhRDRUCxaXGLcPAjAg/BhNay1r+yT95YsCkhnjXzKhMcL+g4RZ/UdfMNAE
	TrUyX5PNDpbjuJLPEInqtcoV9Atde3jPHohoFzlWM9kqzCbxGHH53uuR5/lQatHsEIIcriaHvTU
	MOZyHC5L0KcUvFFwoJ3iTZLXMkyWfd39KZ/ry4EDo5UCAMp33qf7C7vcUVAoqX7/wUICMibYAN+
	RIqSLJXxi68xIP7j982Oy2rVpL4u7IczqCd3b0UThRQgyOwE9k/NvFTIsFVzf/r2+43b0Nt4bmp
	oObxPVib9vnU3w6Xf3gjvTls6/E+lE137w==
X-Received: by 2002:a05:7022:3a82:b0:1b2:6855:998a with SMTP id a92af1059eb24-1b503199e7cmr1303894c88.34.1794538291748;
        Thu, 12 Nov 2026 18:51:31 -0800 (PST)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50319d40asm2853771c88.11.2026.11.12.18.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 18:51:31 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	chleroy@kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH 2/2] KVM: PPC: BOOK3S HV: Use ksm_disable() for secure guests
Date: Fri, 13 Nov 2026 08:21:14 +0530
Message-Id: <0500fbfbb98776091c89584155368610095b4dd5.1794537345.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <7510ddb55a34e8a669eb7c2624d652264701bfba.1794537345.git.ritesh.list@gmail.com>
References: <7510ddb55a34e8a669eb7c2624d652264701bfba.1794537345.git.ritesh.list@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 78t3etyznn84wme3d3tkerjyfxczqcrx
X-Rspamd-Queue-Id: 029A1100003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794538292-950990
X-HE-Meta: U2FsdGVkX1/VSM+143dJ1IwMJGX63USx0+w1g7/xilOUMpQ+3/2KvZlybI2rIuF+LLjQk3Sta/lxInKy8ftseuP0P2+5gOUrfyFgURvM3HZfY3qJiQ3D0ccuLA5v0GD2sjZ0gR59mmtzNYj1G7LtHpZP/GpNZF9MWzXFZrw+kFyBsIzFLBAaIpoxv7iPxopaHjR3kL5tL2qnAGM/q8dOS3KP03qplP37R/JkidTLW84kHOhWIqJ1HrTT4NlQLVzQDUzzL47lIfcpAfw7C02XX+zm4EHvEEvKDNCsYXw5b+2QSDSvLdxtHl90BU4cIKy/23DUdTi1mLLULLYGs5vLfpNBHZ5D2vWH8P8o+zCsYiBT5FQj54ivNrvL58m9Y9FTdUneLVKzmzaGn8kSbz1kab0WyfhSHZaeRQVlaYeEVHXHTbvPoITV4Zv/S4xwcwJGBfkRGh7vS2XwbUknxwcVfgRMSegCj14LiqZN/VPQiDuW76hhA+JPQBlEF4Ce6uX89SgZpf/hRpgHdcBRcZ0XeLwR5um87zSNsOjTnnJ0qw3QLe/Xj7AvCFciExiYyBdKw9+BlsHiC85PLXktkkG8+E0ujzVO5I+3Hazfk7Er6t9NgFmxXmH6lSaGfWHXkqhzJDr5BBadW1mxso4HfmYDnBBro4rkvRPaCcbcG4cpcjkWz6bwmW/v+Fb8YjGWAEgRuD3X1uPS6uLB1Mf6pKSN+npfx9/oipXBBsFyQ+C0cafQuHIIhN56DNeCsmuNCmQsJio4a3vxKyceO8ksJSMBMVY15vepXs+HvUdJgng0XmetNtmG6KM7sdXrPj7Dbqdjn1ZObT2+/smsSq0wAx+pe3NnANmmHaOYZp1JwaLjOYTcNb0h5KxP3GWX/5n94ASmIjz0A1rV1jBThRjI17k8wiYFMSDGhmeVcWmHaLu4ne1ct9RygPBuTy64QO0gjep8zXV+ZNrrX/xrq1WWFd+
 1GLHhYCw
 PqDrNNuwOHHSIOqO21HR20tDX6cSseb0BcAgYjBvtARSAs/AsTyPQLehQvN6KaisWt2OAkcsDPrg+b4UEZfvgA0pvR03SYYiPgUrNkx11SOXCGbP5rTsRlE6O0gJz1XxYJ8EYO9MXJljhHtjgqZK3af0hy5/XKp0oraxSR9v9OiQdSU3ko6FbSQqjyakQycIhGO8Fd2uEqtj6keQl8vXrBSy+kMVQChkJhLMJM3PoXcUioBXm3Xh06vfXZqI0Jp80XeErKkz60aygZz8XtOetM/MT7bRpwIIed8jVqOaRK//d2UZzflyDU7Wo3AwoOjcH4cjKiH1etMdsjKsXRKdVWj+jPv5x+rBKQM5hIjIaMTt7MF9/9Q4flsstaG3ziLlZ108lMNfUQ6L43MPZT9iKeMil8sNWHmnJbwYpS7ZRTcB7TsJ0NqY0h+kAPXTfZhyZKwG2kUKsyXedTp25iagUeI96QqWiCjSBsX4cX7yUeNNXqyOMcL/D1IKqUd5nHgwFvZF2Jg/+spIYvu506wlqE8YhxVPpHmYMktFqBSA4goiVjlCge21DRvAT/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pages of a secure guest are moved to device private memory with
migrate_vma_*(), which can't be done for a KSM page. So, when a guest
wants to switch to secure mode, kvmppc_memslot_page_merge(), walks the
VMAs backing each memslot and calls for ksm_madvise(MADV_UNMERGEABLE) on
them. It does the reverse if the H_SVM_INIT_START fails or when the
memslot is getting deleted.

Instead of using ksm_madvise(), one can use ksm_disable() on the mm.
IIUC, ksm_disable() was introduced for this purpose itself in commit
  2c281f54f556e ("mm/ksm: move disabling KSM from s390/gmap code to KSM code").

Also, it seems there are other existing issues in current code.
For e.g. The current code can turn KSM on for the memory the VMM never
marked mergeable. This can happen say for a guest whose H_SVM_INIT_START
fails and therefore the cleanup routine ends up setting VM_MERGEABLE on
it's memory.

Note: This was spotted and reported in one of the series which was
converting legacy vm_flags_t to vma_flags_t, showing concern around why
powerpc has to call into an mm internal functions. Besides, this is the
only remaining user of ksm_madvise(), outside of mm.

Let's fix the existing issues and also address the reported concern.

Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Closes: https://lore.kernel.org/linuxppc-dev/1c0b1368-a381-4b25-bba9-7a4f8e92b764@kernel.org/
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  1 +
 arch/powerpc/kvm/book3s_hv_builtin.c        | 26 ++++++++
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 69 ++++-----------------
 mm/ksm.c                                    |  1 -
 4 files changed, 40 insertions(+), 57 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
index 0a6319448cb6..c8cc11325639 100644
--- a/arch/powerpc/include/asm/kvm_book3s_uvmem.h
+++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
@@ -27,6 +27,7 @@ int kvmppc_uvmem_memslot_create(struct kvm *kvm,
 		const struct kvm_memory_slot *new);
 void kvmppc_uvmem_memslot_delete(struct kvm *kvm,
 		const struct kvm_memory_slot *old);
+int kvmppc_uvmem_disable_ksm(struct mm_struct *mm);
 #else
 static inline int kvmppc_uvmem_init(void)
 {
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index fa0e3a22cac0..e39fc28a27a7 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -14,11 +14,14 @@
 #include <linux/sizes.h>
 #include <linux/cma.h>
 #include <linux/bitops.h>
+#include <linux/ksm.h>
+#include <linux/mmap_lock.h>

 #include <asm/cputable.h>
 #include <asm/interrupt.h>
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
+#include <asm/kvm_book3s_uvmem.h>
 #include <asm/machdep.h>
 #include <asm/xics.h>
 #include <asm/xive.h>
@@ -627,3 +630,26 @@ void kvmppc_check_need_tlb_flush(struct kvm *kvm, int pcpu)
 	}
 }
 EXPORT_SYMBOL_GPL(kvmppc_check_need_tlb_flush);
+
+#ifdef CONFIG_PPC_UV
+/*
+ * Pages of a secure guest are moved to device private memory one by one with
+ * migrate_vma_*(). This cannot be done to a KSM page, so the VM is not allowed
+ * to have any and neither get new ones. This functions stops KSM for the
+ * whole mm.
+ *
+ * This lives here and not with the rest of the secure guest code, because
+ * that can be built as a module and ksm_disable() is not exported.
+ */
+int kvmppc_uvmem_disable_ksm(struct mm_struct *mm)
+{
+	int ret;
+
+	mmap_write_lock(mm);
+	ret = ksm_disable(mm);
+	mmap_write_unlock(mm);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvmppc_uvmem_disable_ksm);
+#endif
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 190f64d992d8..fa50c103a9ee 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -47,7 +47,7 @@
  * Locking order
  *
  * 1. kvm->srcu - Protects KVM memslots
- * 2. kvm->mm->mmap_lock - find_vma, migrate_vma_pages and helpers, ksm_madvise
+ * 2. kvm->mm->mmap_lock - find_vma, migrate_vma_pages and helpers, ksm_disable
  * 3. kvm->arch.uvmem_lock - protects read/writes to uvmem slots thus acting
  *			     as sync-points for page-in/out
  */
@@ -89,11 +89,9 @@
 #include <linux/pagemap.h>
 #include <linux/migrate.h>
 #include <linux/kvm_host.h>
-#include <linux/ksm.h>
 #include <linux/of.h>
 #include <linux/memremap.h>
 #include <asm/ultravisor.h>
-#include <asm/mman.h>
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s_uvmem.h>

@@ -388,78 +386,30 @@ static bool kvmppc_next_nontransitioned_gfn(const struct kvm_memory_slot *memslo
 	return ret;
 }

-static int kvmppc_memslot_page_merge(struct kvm *kvm,
-		const struct kvm_memory_slot *memslot, bool merge)
-{
-	unsigned long gfn = memslot->base_gfn;
-	unsigned long end, start = gfn_to_hva(kvm, gfn);
-	vm_flags_t vm_flags;
-	int ret = 0;
-	struct vm_area_struct *vma;
-	int merge_flag = (merge) ? MADV_MERGEABLE : MADV_UNMERGEABLE;
-
-	if (kvm_is_error_hva(start))
-		return H_STATE;
-
-	end = start + (memslot->npages << PAGE_SHIFT);
-
-	mmap_write_lock(kvm->mm);
-	do {
-		vma = find_vma_intersection(kvm->mm, start, end);
-		if (!vma) {
-			ret = H_STATE;
-			break;
-		}
-		vma_start_write(vma);
-		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
-		vm_flags = vma->vm_flags;
-		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-			  merge_flag, &vm_flags);
-		if (ret) {
-			ret = H_STATE;
-			break;
-		}
-		vm_flags_reset(vma, vm_flags);
-		start = vma->vm_end;
-	} while (end > vma->vm_end);
-
-	mmap_write_unlock(kvm->mm);
-	return ret;
-}
-
 static void __kvmppc_uvmem_memslot_delete(struct kvm *kvm,
 		const struct kvm_memory_slot *memslot)
 {
 	uv_unregister_mem_slot(kvm->arch.lpid, memslot->id);
 	kvmppc_uvmem_slot_free(kvm, memslot);
-	kvmppc_memslot_page_merge(kvm, memslot, true);
 }

 static int __kvmppc_uvmem_memslot_create(struct kvm *kvm,
 		const struct kvm_memory_slot *memslot)
 {
-	int ret = H_PARAMETER;
-
-	if (kvmppc_memslot_page_merge(kvm, memslot, false))
-		return ret;
+	int ret;

 	if (kvmppc_uvmem_slot_init(kvm, memslot))
-		goto out1;
+		return H_PARAMETER;

 	ret = uv_register_mem_slot(kvm->arch.lpid,
 				   memslot->base_gfn << PAGE_SHIFT,
 				   memslot->npages * PAGE_SIZE,
 				   0, memslot->id);
 	if (ret < 0) {
-		ret = H_PARAMETER;
-		goto out;
+		kvmppc_uvmem_slot_free(kvm, memslot);
+		return H_PARAMETER;
 	}
 	return 0;
-out:
-	kvmppc_uvmem_slot_free(kvm, memslot);
-out1:
-	kvmppc_memslot_page_merge(kvm, memslot, true);
-	return ret;
 }

 unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
@@ -482,6 +432,9 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 	if (!kvm->arch.svm_enabled)
 		return H_AUTHORITY;

+	if (kvmppc_uvmem_disable_ksm(kvm->mm))
+		return H_STATE;
+
 	srcu_idx = srcu_read_lock(&kvm->srcu);

 	/* register the memslot */
@@ -1107,8 +1060,12 @@ int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)

 int kvmppc_uvmem_memslot_create(struct kvm *kvm, const struct kvm_memory_slot *new)
 {
-	int ret = __kvmppc_uvmem_memslot_create(kvm, new);
+	int ret;
+
+	if (kvmppc_uvmem_disable_ksm(kvm->mm))
+		return H_STATE;

+	ret = __kvmppc_uvmem_memslot_create(kvm, new);
 	if (!ret)
 		ret = kvmppc_uv_migrate_mem_slot(kvm, new);

diff --git a/mm/ksm.c b/mm/ksm.c
index d24b129932bf..9d3db831ac87 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3058,7 +3058,6 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,

 	return 0;
 }
-EXPORT_SYMBOL_GPL(ksm_madvise);

 int __ksm_enter(struct mm_struct *mm)
 {
--
2.39.5


