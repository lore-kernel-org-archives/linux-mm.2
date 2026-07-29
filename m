Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F41CC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E046B0099; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CFC76B0093; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB15D6B0098; Tue, 28 Jul 2026 20:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A60576B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 339FB1C0E0C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
X-FDA: 85039944864.11.7DF48B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 23FDF80006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JpASI3w2;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEvruEa9NLWbvEMdsdaco6ctR9vZrC/+Fbr2IMf28vM=;
	b=opZz6AGAYOFhdqBmctwamQnvn9CbAS1BH6BF9pOGEB9HnQ+O+mbKnypJ/hijfhOwmFb7db
	RtDffbI1yBkjvHvYHJvA5ZUThCMiq4LgQEUaYXT5G6v5CYzQ46xey5PfEpv75Am7E1/Miw
	0MVDgIhEU/5ztyYEwmMwsdva/xTGI78=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JpASI3w2;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285310;
	b=2ghZyC5sHPd8Z8z8sq7N9k6W2FmWKR1eVLyTM+snVIwCo2polUysvg8pL1uLMVlokgp5B3
	2DR72bh49V/JIj72ed2WWY8QrvG5E2zYW38hplVvAKQsiL7tpHXR9+BepPgidp6F9hEjI9
	5QCywFOfbkPK5sZ3XUN/xv3KOvpLfIA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67D9245144;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18173C2BD01;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285308;
	bh=8+73BdqsM25sQR+wTIxvmnX8IbvialmLmWHCbNVQcsw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JpASI3w29t+dw9j0YMSHFQJuOlZgcclzF/sJUh85n8BKm9x9n2bk44aLd8JdCjOVq
	 rgWmtYeCANdMOkhfPSqoNaMm9kPkFbJvSR3eCQ1LCNRnSvJxnWVrevGkwE4Atac4eZ
	 a2X1f0oxPx1mjXiZsb/XVzGa9cdHUa3j3RnR2UWtThWbJExL2ww/ofBJuDndUETTpf
	 j1bPcA2tVNhkW1aGz4ZIvKVMVw1CUqYqdVofkNu4ysC7/6I6sll/boXjnoyY0O4BGn
	 r5pXH5K/HSak8vcf0hRTTnlcDQMadejPttc8TLij2YhKGDMGEulmT45yGBUQ9RZr8D
	 OBHRwf70dq8+A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DECC54F57;
	Wed, 29 Jul 2026 00:35:07 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:03 -0700
Subject: [PATCH v9 04/41] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-4-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=10592;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=V2L+DlFSqyd+pJ6dVFa6YPtuqhzTWsVr8T/4Uer0S+s=;
 b=aJSt9f07XhuomsB10Z0LoJTR7V78UTeLuh1tyQGeHWbzGvJQiD+4iQ8ynatTz2KIx2dZA9Kv7
 YkRev+Ni5plAThZn8MI/3SlkPX15IvtbfJNBeP/uQimNsLNt7lfv6kJ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 23FDF80006
X-Stat-Signature: du1jmqsn98zqxxk96wwek81bpnyrth3h
X-HE-Tag: 1785285309-132134
X-HE-Meta: U2FsdGVkX1/0IHCAntNwy75Wr+Rm+MC7JuUQOjKsRhpPzk67SkQ9LrRP6bSMBYdh4lfiM1qwC2oitY2Y+Lit6C0TS8N6vwkG4PbrUeFp8ojinEoEvc/qKu7GQAdY5f5DYtsej4VnPpjcd8xJv9PhFr0fkMRFSHWzeBIjaCgenakED97Q7MiA25NqOEMY81oXlzteOv3MzEcTAu0wZIjz6hv1OV/n0AE9WkTCFSBH8mlqUWSlXv/7tQ0cm/F5sBbGkAnldZRdSJx52Hb9X2/dRl1S9zfL+csBsiCP+8/v0D4S0h2TXBpFxj1Uug+p0LKMjvUdFzAvtmuNVvzoWLVoqaeB4ZBk6LQPGYoS7wjO5J+KwN6Wg2E7z46kwJvchRmdDN8Js1glou2f4j9y4wMjNF+qpqvddP0iucAfAmS5lphrpgQq3Cf7JY3jtuFG+7IXgBc3xzPm3nWOlyTvrx1RkK90HGhKMtbYPhDyiZj7GGhTi8fbDRkE50/h4AymtULnyFwvygbZlxb5CxSXLotuuxv8YqlrMEPCpjBi9qTIWjdW7GZ23sYD9dNU/qBmFuo/N8Am6sPxkRNDPjwEpwiiUi09KdVceODZ+k8FpNbzj5FFGWxhAH/8MiP55rp4hZormsN+Bpt5+AIJtUfwtE8JxNffVNPkhg5GwTnb5m7kwfsP8eYCWMTUV7XQF2/tqJX0Vah5EkcONOnpid70lMnzzsWeRGa8L/oEGpd4JtccUEFuViWnTxvAhI5PjFCk0HQGw3JF/Gm6P5BUdd+t+Y70epBkzO5V7bIXgBFNEsLbYvtm/9Av5ixKNGqxTyr5o2ErGxkIYklf4Qc27j7ukFFwLvdEkORLd0NSrdvlZMdr1KpAfJb1agY/GRL44SIkrFdg4+VqMKQynm4zzXTKQrcLAhTcxj9adO9XbgbM2grX6Xv6ykpKNK56uTVvxjSmdhTTr5qJX4/RlVSIPx7cOJq
 JIKeYZaO
 QZ6Ezw19uFJ+B+UQxAXVZEyClE8tNPs9SvI1gPwVzV1pPVWSD0gkBxcXvYyJ8PiAJs86kxlg3OPrKWQXwFHttzKr05Ibp+2ao5Q++xc9NqK0oJFpb4xi+aEhFZzlecV8/Xf0OVBPmYqJQOfgA3yGIIFqnliCqJrvYCUD0KhmBajsIm1n47vP24xmmHsKREQEgsb0168snf5Wzgy0Gr+sqjopGG/az/mgSNdUU54C9rhWi2yLhmX9GjBzPZCoVjTyL4AEyIZFX0CiaR5hxlKu+P70Y4x/iSdggszYhov+l95JIB+Sv1HPHxlDI5Wq62RVS7SR1AEgJ5TagI2br1QYKUQ4wpzh0iBllchJfsEjer4nhB+3rhJB7fEShZ7K1PfvY0IqBk2OT4jwBmPCPKBSDCF6QeIXcNPVyhnlUFpEx/zQuunqCyYpzQMrJxQe+Z9ORBO+7eFcJhYYY1TyMdXhVsoTF/0vOz3wz7dNwICOQA+d+9fo4+t4up2MtiT2V50fPztucsaMaJ/fSJsU=
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

kvm_vm_set_mem_attributes() already has "vm" in the name to indicate that
it is a VM ioctl. Rename it to kvm_set_vm_mem_attributes() to show that it
is setting the VM's memory attributes. (Drop the VM-ioctl scoping since it
is a helper local to the file.) Update the accompanying trace function to
match.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 14 +++++++-------
 include/linux/kvm_host.h   | 16 ++++++++--------
 include/trace/events/kvm.h |  2 +-
 virt/kvm/guest_memfd.c     |  6 +++---
 virt/kvm/kvm_main.c        | 32 ++++++++++++++++----------------
 5 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index acafa7964964c..2b3bc73845a8a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -8089,8 +8089,8 @@ static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
 }
 
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range)
+bool kvm_arch_pre_set_vm_memory_attributes(struct kvm *kvm,
+					   struct kvm_gfn_range *range)
 {
 	struct kvm_memory_slot *slot = range->slot;
 	int level;
@@ -8159,18 +8159,18 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
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
 }
 
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range)
+bool kvm_arch_post_set_vm_memory_attributes(struct kvm *kvm,
+					    struct kvm_gfn_range *range)
 {
 	unsigned long attrs = range->arg.attributes;
 	struct kvm_memory_slot *slot = range->slot;
@@ -8263,7 +8263,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 		 * be manually checked as the attributes may already be mixed.
 		 */
 		for (gfn = start; gfn < end; gfn += nr_pages) {
-			unsigned long attrs = kvm_get_memory_attributes(kvm, gfn);
+			unsigned long attrs = kvm_get_vm_memory_attributes(kvm, gfn);
 
 			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
 				hugepage_clear_mixed(slot, gfn, level);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c125d2e8155a7..297cb06302223 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2560,21 +2560,21 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 }
 
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+static inline unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
 	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
 }
 
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long mask, unsigned long attrs);
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range);
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range);
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+					unsigned long mask, unsigned long attrs);
+bool kvm_arch_pre_set_vm_memory_attributes(struct kvm *kvm,
+					   struct kvm_gfn_range *range);
+bool kvm_arch_post_set_vm_memory_attributes(struct kvm *kvm,
+					    struct kvm_gfn_range *range);
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 1ba72bd73ea2f..c4d514d2350cf 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -364,7 +364,7 @@ TRACE_EVENT(kvm_dirty_ring_exit,
  * @end:	End address of guest memory range
  * @attr:	The value of the attribute being set.
  */
-TRACE_EVENT(kvm_vm_set_mem_attributes,
+TRACE_EVENT(kvm_set_vm_mem_attributes,
 	TP_PROTO(gfn_t start, gfn_t end, unsigned long attr),
 	TP_ARGS(start, end, attr),
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3d6547c5ba9a6..8c7709a352cc7 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -881,9 +881,9 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
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
index 9501dd8d015d1..6f0bcab7a0ebc 100644
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
@@ -2516,8 +2516,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 		KVM_MMU_UNLOCK(kvm);
 }
 
-static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
-					  struct kvm_gfn_range *range)
+static bool kvm_pre_set_vm_memory_attributes(struct kvm *kvm,
+					     struct kvm_gfn_range *range)
 {
 	/*
 	 * Unconditionally add the range to the invalidation set, regardless of
@@ -2532,18 +2532,18 @@ static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 	 */
 	kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
 
-	return kvm_arch_pre_set_memory_attributes(kvm, range);
+	return kvm_arch_pre_set_vm_memory_attributes(kvm, range);
 }
 
 /* Set @attributes for the gfn range [@start, @end). */
-static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+static int kvm_set_vm_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long attributes)
 {
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
 		.end = end,
 		.arg.attributes = attributes,
-		.handler = kvm_pre_set_memory_attributes,
+		.handler = kvm_pre_set_vm_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_start,
 		.flush_on_ret = true,
 		.may_block = true,
@@ -2552,7 +2552,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		.start = start,
 		.end = end,
 		.arg.attributes = attributes,
-		.handler = kvm_arch_post_set_memory_attributes,
+		.handler = kvm_arch_post_set_vm_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_end,
 		.may_block = true,
 	};
@@ -2562,12 +2562,12 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	entry = attributes ? xa_mk_value(attributes) : NULL;
 
-	trace_kvm_vm_set_mem_attributes(start, end, attributes);
+	trace_kvm_set_vm_mem_attributes(start, end, attributes);
 
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
@@ -2623,7 +2623,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	 */
 	BUILD_BUG_ON(sizeof(attrs->attributes) != sizeof(unsigned long));
 
-	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
+	return kvm_set_vm_mem_attributes(kvm, start, end, attrs->attributes);
 }
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
@@ -4937,7 +4937,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
-		return kvm_supported_mem_attributes(kvm);
+		return kvm_supported_vm_mem_attributes(kvm);
 #endif
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:

-- 
2.55.0.508.g3f0d502094-goog



