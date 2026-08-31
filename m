Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DBAEC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53086B009B; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03F76B0099; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F94A6B0095; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 61C7E6B0095
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8973C039C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
X-FDA: 85159670526.25.2FDED23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E9B1E40005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fbGX/joD";
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135921;
	b=IsiDAn8cbkfhec8ndEXkq00+kUQ/cbrCnbjVxdSKURrnDiwcqRUfyyIpGfktQH0jwftnB2
	xDjJOcOBadjdV9jgnyl7UgAnDXPr70Cvy3EruycTn9zdGc/xc20Dx9jIv5Hczn0FoGDcbg
	2qXeI/wh1doZbi4ZpggBEZB6brjUQdQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fbGX/joD";
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZRjUiwaXTjIZFfeSHmFEfqAKUrGcrovP7/GPtgHoo4=;
	b=aNM3YlnijMs2XnGebTrf3jAVttqP5Hp8DBJrHHfsfJnaMbxAkkxoHwnlrFFxER4eVJJGBM
	JoeO/d/hVkyXBLcj2aF4lsZoVxeG/889L2g5pKVnVRzsAsgnc6H2npgC3hVXytAxokBKVy
	wTE7anE5PzJcyfqnJ/Rx4s1HUp6HKN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BDCE360239;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E81EC2BD00;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135920;
	bh=Fli/DnBLQa0bHgyS0nPH35ihIsGgdhE8vQogj3yPsdk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fbGX/joDHj66klVr6YZzDrsFN+qzMM1kRbN4852/HbLwsIeGF7U1cGvb0uaqY5Z3J
	 g2Vifm6ygULXaJESEtqgs2j+Am/cR+KR+IK5eczGm/IPxQRYBejGSDPv04zX9kP60z
	 yfkkwuMx18hdP2NBjSOy3F4ZB7xXOuyJqNDNxvrszjnjCLXen6F1ZnGUmjS7UWtc8J
	 5Oxmu8xkZ0FRGFDzMFUjBw6i9U7ANRDOuMg6Ya7RQLnMC5tDNTz6rjNtwKZ8Y2oqLB
	 ugw8O24hSnGCCJeYYGtEnHAzsCMSuQWAgtRP411h7W5Zml/vMUsLfL8+9OKLqbNLaN
	 DnRGNIF1rLdrw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B33C61DE4;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:10 -0700
Subject: [PATCH v12 09/45] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-9-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=5719;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=fuPA5g+KPLXd1J5vplOVCQXEWYNrFEGb5t+IM2iiuDA=;
 b=Zl/GFK2YJOqfEO1qjinm3ljaqYpgc7Xmo3lnukUV3NCuYapl+/+wXFtGqMiNeGWakN0SxQX15
 TjkhIIejtvfAdDTFm/ry6aZXV6coxoMu8iqP9u9A4q7YByz7s7W68ws
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Stat-Signature: rtcnsog915pcj4ekhkcufnwnhgns43iq
X-Rspamd-Queue-Id: E9B1E40005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788135921-502733
X-HE-Meta: U2FsdGVkX18mguhujDXC/gQptDoz6pI8ofaEErphFZU0k9jaxTee8ULPMv7fp7TvDOSv5TVvxTYm6bsyBjZq+EbWN8yclFctUS9tANzL3azs2220a5OubvgCha0AzNFGqJgz9SFrf7c40RTxdrzBuGDWbu+3Gkr9HfYyBs0Pc6sPcYUK4pV5fPhUMGgSTdy6U6LEg69tbI1bRdhNJE6Z/NEl1YsEE6BRDkzq+w3MQr7o4GphtpqHq1srULlzJ/zVqG/1sGsu/NVAugTwErnc6Te/fIjH3VIH+lRnaMD5VoLY+TS5zt5QUp/PYYBvrbsJCZdNl71HRH8W+LNTZ6PARVv03NZw1EN8/K0CnSOakisLVrsVx1mcqlLQ+z97p1ohMrFXyu2FL5XG14qXNbpC4D+IIQF6Q2BeRRf+bJGVt4zejyAVj13zUcHaGuMIaKVfNi/mZFeZ5N9cW3CmQE2sMGNM6qqA3vd/f5W/+5c9UrEhT9hgaVhsMDJsw0HB1aWI1/27FMgrxhHjNvvmyuuFzJF2TKaI6e8gS3h9OTQpkstYs4Cx7ndMrIzgjwZpraM0tbJmT1U8w3pgoXUz0n/P2Il50m/bx+/tHtrj+LWKhuFYQ6kgWEHsXmf32P/6IR6CNcpDibPQDsD62oT+oOwdRa/HvFFJG/AeuZmkA/QDu15ah0L5U09b/KrTSCgtLRrsNvzE+aWpxxDWbiE6jAgPgUneXmciXDP7E1awKl7EgHOf4Za7TsOMAV2ssr3wfK8EE/iuhT6LlZhN0vv0yOaKQVpLzo8Bd/Kek9zbQxZjYHPgMWy5YQyY6RZ7DsFKShmExWOB/LgmZ4lyUj2gk0pHO6pw8qnoTBztUiqva6ggNMQFDFnd3h/8HMZ6LnoDrK4j5bykaIfVCtPKIBDmnRIIfu6luRjRUnaUxCgXcFJd/YjJ6PsB2HSRheLoO9mv/bxmGEKIP8rdWlP4896OrHj
 CIdbmXtt
 5P2CiNYVuvOq+zIm8NVZqcTgqqiAZ9ACEl3Y+Mj28kkqL7J0lDV6umzW7Kxu0gKQfFbcfrdZ9OpTzFQPVCRzRtjGDKQGJDAI/sj+azv/GfazauzjkdbeZQy5db3T/m78oI4J3C1IqjUxU2fKErq+uAvX2YNBgET12lfmrQ9QrYjNHDW7k96lEjLebkSfTVnc5wRxGyJNXsCQmqfW9yrzPjgHawGnxXD6RJfH4+grFUDV4TG281KyxV9KBroUvvEYo7jH2DYhUNuys5WVTyZGe2ngMjYZ+/hrZiKxOmsrDwisRKRlz9dHQHoxUjPojKt6PRyf4/2QYd9bUv5VbG3kidxeRyMIMRqBsE7NYqaPHXS982mvuPSydtwz1iAlWOfoOU9N6+2JCoUHhid+Tmsj5HOoUw49f6YtJTKm3U4EqjPC1Bvf4Cgyq6C3ZFefwR6lh8rMcK8PPDQVXA1YEpZ1/zpAkLWPcqofbnqmdZS8lP+Pfx0DhEy28VO0ac4JmBO0cYrJHnICzog2xigQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Stub in global variable to enable in-place guest_memfd private<=>shared
memory conversion, which will eventually be exposed to userspace via a
module param, and wire up the __kvm_is_private_gfn() static call to the
guest_memfd version when in-place conversion is enabled, i.e. when gmem is
the sole authority on private vs. shared memory.

Cc: Fuad Tabba <tabba@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst |  7 +++++++
 include/linux/kvm_host.h       |  6 ++++++
 virt/kvm/guest_memfd.c         | 26 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c            | 12 +++++++++++-
 4 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e0430cc750c9e..90a29424c54c8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6382,6 +6382,11 @@ KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
 on-demand.
 
 When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
+userspace_addr vs. guest_memfd, based on the state in guest_memfd, which is the
+sole authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD`
+to find out more about the creation-time shared/private status.
+
+If in-place conversion is disabled, KVM selects shared vs. private, i.e consumes
 userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
 state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
 is '0' for all gfns.  Userspace can control whether memory is shared/private by
@@ -6429,6 +6434,8 @@ the state of a gfn/page as needed.
 
 The "flags" field is reserved for future extensions and must be '0'.
 
+.. _KVM_CREATE_GUEST_MEMFD:
+
 4.142 KVM_CREATE_GUEST_MEMFD
 ----------------------------
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3579feb631775..b0110143d2ff8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2580,6 +2580,8 @@ static inline bool kvm_vm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef kvm_arch_has_private_mem
+extern bool gmem_in_place_conversion;
+
 typedef bool (kvm_is_private_gfn_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_is_private_gfn, kvm_is_private_gfn_t);
 
@@ -2588,6 +2590,8 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 	return static_call(__kvm_is_private_gfn)(kvm, gfn);
 }
 #else
+#define gmem_in_place_conversion false
+
 static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2595,6 +2599,8 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 #endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
+
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 #else
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ce5efcacda36e..cd966eef45b69 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -478,6 +478,32 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct inode *inode;
+
+	if (!slot)
+		return 0;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return 0;
+
+	inode = file_inode(file);
+
+	/*
+	 * Rely on the maple tree's internal RCU lock to ensure a stable result.
+	 * This result can become stale as soon as the lock is dropped, so the
+	 * caller _must_ protect consumption of private vs. shared either by
+	 * holding guest_memfd's invalidate lock for the entire duration, or by
+	 * checking mmu_invalidate_retry_gfn() under mmu_lock to serialize
+	 * against concurrent attribute updates.
+	 */
+	return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private_gfn);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 78278730b2ae4..46d2e123448c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,6 +102,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool __ro_after_init allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+#ifdef kvm_arch_has_private_mem
+bool __ro_after_init gmem_in_place_conversion = false;
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -2423,6 +2427,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
+	if (gmem_in_place_conversion)
+		return 0;
+
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 #endif
@@ -2634,8 +2641,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_is_private_gfn);
 
 static void kvm_init_memory_attributes(void)
 {
+	if (gmem_in_place_conversion)
+		static_call_update(__kvm_is_private_gfn, kvm_gmem_is_private_gfn);
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-	static_call_update(__kvm_is_private_gfn, kvm_vm_is_private_gfn);
+	else
+		static_call_update(__kvm_is_private_gfn, kvm_vm_is_private_gfn);
 #endif
 }
 #else

-- 
2.55.0.897.gb25b4bd76c-goog



