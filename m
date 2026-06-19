Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFC0CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6CC6B009E; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF5F6B00A1; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4C16B00A2; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9991A6B009E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAF30A02FE
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:52 +0000 (UTC)
X-FDA: 84894784464.20.C9FB772
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E0423120002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdVppgS5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829111;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RStIFm980Gq8pOkxxt19rOCbJdNm/MR3+jLFrDOCdMI=;
	b=FDasGFRys8e9K3IZB1nvVx43OMJs2VmYcJDiHpdpwbTLJFegAvyX7Q+wPuL9HRa3TzzDFX
	GEJ34oeyMHnhc1SDhYQvizoICL+ZBM8EIjVEYT62Myvu6zQAZZEinIGUo8xjZ0+xH8DsIG
	RtMt9QT4MEWYCT+xlOuP8A+Nbr3E+ek=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdVppgS5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829111;
	b=QLCoSkVHGokpnrp++SaYesLdldQY4S1lSKY2rz+PF7xiVq6yieb2XVHxMTURjJsPGRymjs
	9OAGufKT/UcZWis5antZZWJdIS7Y5T7z4kLP7U5bdv79tKQ9U/jxq6QBATruOpDJtr9Ej0
	xmJkRXSUrRkkqxDnp4KIbO0zSu/6J50=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E961A44616;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63DC0C4DDFF;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829107;
	bh=1NTs709y4DTPCBcgvKMrVMqdUEznnT+kzcMcEHdMlcY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TdVppgS5XP+lnt/yl+wzYe+zzjk1EBMbQqGJbgKg7HaqMiyVduDbNYECSPsKDb9kl
	 lJKa9lsJwF1pUYyN0nuVwvKSIHU1iQPLn96rfhOxY6T0FHyT/z8A/tab/p7L0Vz0rH
	 cIJn/6ve94HOvHUHvam5dn5bZHuZEqC29Fi2N4Gf0bYk3CztNllQc0aO90YBxfOP91
	 nAuvOU82nptgMiV6v9PCQpblZRvK1dM+Gn9Amyz0wqiOkdg+ckGK9JKXgsTdTvPWAu
	 tS8NbAdjgKfnqBgbi8jieSfEBmjePdAFJNWbTNnBEXnJ9zUrKnNELuQsRj+D+T31xi
	 iAOQ4GW5w0pXQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 509C6CD98F0;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:44 -0700
Subject: [PATCH v8 07/46] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=6750;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=AxBihaCLX0GxTHg2jIViDGPzQnVe7kaqirasKB6Zq0Q=;
 b=RxjUxb5mhHLRNGU/hAwlj5EfVbs3uZkdfvx7fkXSaQxT9NbNDR3MOrMAp4Zu75NstEPFxYqRG
 pPKqh78kvtbCGNwrzmyKIAEIKAqKUiluPwb+X/DPY5UqiV32KOjpTOw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0423120002
X-Stat-Signature: xpgdtw39sn3st5r64ow34hzoknxfpnhr
X-Rspam-User: 
X-HE-Tag: 1781829110-389345
X-HE-Meta: U2FsdGVkX1/Iv4KdWq4m77gZZY6H47b0Q7RlU5s6IBfIYK92LjMY+YT/6gHYPhnZ4c397HX/qwJVswE6AF4V4PNFIA51O06GWxtyh32892aZ3bUARt2L1RBIwiTExMVs2sb71D4pkjf/JAE9a4o9x56GW4RSNoWiQeTT5cxkRTOwYki5Gbe2MR5XmW3uG+AiNWQKNuq7rjlL0i1bp06l26zD6R2eeyuKnQlmRivjWckP2/GllOUbJYhlyXWI59g0fwj0ZqPxtH9wdQcrNgRo3A/YMLxREumHLZSrUu9nRqCcqsAXeegnRKZY9WU4NgpIs5bmGw0QodKA+efQpDatY/DuJo1mRNYTT/HaOyateyC/06hGwk64h09W3FZfaZ58orZbvTwduPfmsIMLit7h4LPbTqyhExC/b3NNPXucLpaVPRKexmzGmYGSarzNViMfJgF3Va1tmJ9SL3QfesNhTNEZN8V+QJ7aOfPRbMeZTgIuF5lI7kob3LjOt+Task0ORPjC58cAcmbZjABvVw1PQL/if4WCET2RHYQQQmSANjf0E2YZLuFmKu2w7ilahQKdhXag1A1/dEPhyV/17+VnCmyci9FFsG1Bf1sa2uqgupLbqsK+qXwvVFirDtRVawLkt9gJKSY+Cu4T69I5dqK1vZxRWITGBG6WxR4zv/AQo7fgIOPBwxnkwRo/QX4j4QacAzNvf7iXzRef0pKGRu5E1rXrF0uqBD9LrCDUodADj7o0qo1agaIYrhiRTB2RngxDW1xQxtOszVu3jqhfdJXQnVpw7za+UgiN4erMo3I1lX63pKr88NTex9f/ABxhdE14WA+C4h/4SSng7MmY8BBcgL73WRih5NB905z1B1FAgWVEAd/m5WLpUVvOxd5kSLjPuU2m77v1dkiEgG+QEL1TkbTbHyzrxoLv060w4HihaarAcQTimYhG5GKSfaEgosr0kPVnOzhiXEHWY0I+H1/
 jgk/rmqX
 8DZ2X1QfCdJlmHUFd5BpdaLB+NK8ZIYV/XQlvtXQ43RuXl3uOySGKZxnNUdYy9ioK3iVS8oSD7KXC0DYZNVqEIm+XJkau8kfqDu7XJ3zQoU8s1Izm8nY+cUbIYaBsIiaIrfTFLVe/pSVomn3g1eCl4fIAJxGCTgZW1fzTajkBNC2RLKCnB7btdYi6J2Lf4A8e9JiZhJIJ2ELCA+jGpb2E0aczESE77t+SszD9iUo0NQravSGH0xJP2UGAjZc2m4jGT9Eh4qNAW7k3Oy4VwKDF8T6qDKCXVFYTTf+TGAirucobO94z+NPHQth31rCDiKzWKROkXwCS0+bnxU9j7644OAfNp2WzloSWSQ5Zmc7MwgIjc3ZTU3pDVQx2loUAvf/8jpdJmdgQ29I5CRRhkF3y2vnYQwPZ2XPcny/SAlkUMnYWyiXMnVNkFCQqSlvzJuDuF8KaoOvPrLHMmBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Rename memory attribute APIs to add a "vm_" in the name in anticipation of
moving PRIVATE tracking into guest_memfd, to allow in-place conversion
between SHARED and PRIVATE.  At that point, there will effectively be two
(potential) sources of memory attributes: the VM and guest_memfd.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   |  6 +++---
 include/linux/kvm_host.h | 15 +++++++++++----
 virt/kvm/guest_memfd.c   |  6 +++---
 virt/kvm/kvm_main.c      | 16 ++++++++--------
 4 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e0005a21b6e22..cbc50aef801fb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -8087,11 +8087,11 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
 
 	if (level == PG_LEVEL_2M)
-		return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
+		return kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
 		if (hugepage_test_mixed(slot, gfn, level - 1) ||
-		    attrs != kvm_get_memory_attributes(kvm, gfn))
+		    attrs != kvm_get_vm_memory_attributes(kvm, gfn))
 			return false;
 	}
 	return true;
@@ -8191,7 +8191,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 		 * be manually checked as the attributes may already be mixed.
 		 */
 		for (gfn = start; gfn < end; gfn += nr_pages) {
-			unsigned long attrs = kvm_get_memory_attributes(kvm, gfn);
+			unsigned long attrs = kvm_get_vm_memory_attributes(kvm, gfn);
 
 			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
 				hugepage_clear_mixed(slot, gfn, level);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d370e834d619e..eb26d4ea8945a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2534,13 +2534,13 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 }
 
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+static inline unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
 	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
 }
 
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long mask, unsigned long attrs);
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+					unsigned long mask, unsigned long attrs);
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
@@ -2548,7 +2548,14 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+}
+static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
+					    gfn_t end)
+{
+	return kvm_range_has_vm_memory_attributes(kvm, start, end,
+						  KVM_MEMORY_ATTRIBUTE_PRIVATE,
+						  KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b4c24fdf159f6..8101f64e0366f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -915,9 +915,9 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
+						KVM_MEMORY_ATTRIBUTE_PRIVATE,
+						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7b989b659cf82..6669f1477013c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2419,7 +2419,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-static u64 kvm_supported_mem_attributes(struct kvm *kvm)
+static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
 	if (!kvm || kvm_arch_has_private_mem(kvm))
@@ -2433,19 +2433,19 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
  */
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long mask, unsigned long attrs)
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+					unsigned long mask, unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
 	unsigned long index;
 	void *entry;
 
-	mask &= kvm_supported_mem_attributes(kvm);
+	mask &= kvm_supported_vm_mem_attributes(kvm);
 	if (attrs & ~mask)
 		return false;
 
 	if (end == start + 1)
-		return (kvm_get_memory_attributes(kvm, start) & mask) == attrs;
+		return (kvm_get_vm_memory_attributes(kvm, start) & mask) == attrs;
 
 	guard(rcu)();
 	if (!attrs)
@@ -2567,7 +2567,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range has the desired attributes. */
-	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
+	if (kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
 	/*
@@ -2606,7 +2606,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	/* flags is currently not used. */
 	if (attrs->flags)
 		return -EINVAL;
-	if (attrs->attributes & ~kvm_supported_mem_attributes(kvm))
+	if (attrs->attributes & ~kvm_supported_vm_mem_attributes(kvm))
 		return -EINVAL;
 	if (attrs->size == 0 || attrs->address + attrs->size < attrs->address)
 		return -EINVAL;
@@ -4926,7 +4926,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
-		return kvm_supported_mem_attributes(kvm);
+		return kvm_supported_vm_mem_attributes(kvm);
 #endif
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



