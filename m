Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136B4C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7C26B009E; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3A86B009F; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3446B00A0; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF1226B009E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13F051A05A8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
X-FDA: 85039944864.02.0D85DB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3035BA0012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iLuQJT2g;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EslbSCbzJ7XLV33ivJO6q33gzaKFvqwAkAOkEroltc8=;
	b=s6jDZ3IrvWOHauYw52M7NkcE8kTGEyLLMAZkyk2mA/tzzZ3IZyQPunPSwDLgnJHeKgAQHQ
	nYdMxkvuOvJlR73mzXkx5V2m2Rgy4j3WVSQ60pQ0pSOMy3IBkG6eKMZDiw5hgXWrD4XpgM
	GEVhwnPac71zUcorbXexVubTz/u2XCE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iLuQJT2g;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285310;
	b=i07QnbXU9Mv4Jris1AsWGgw+tnzwyRu7z0BKBH0AbAzglGSR1HYH+chGVy978aNu2Ikoag
	NJ3XaSzGjq3hNnhEhu/wZdJUu4aRsIvd+kXCqLS2AOx2J58y+8wgRMXnu8hMzECaBSo0Zb
	uannYifKROG6sn/RVczC5HUJQt0lpT4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1595060AB4;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EEBFC4AF55;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285308;
	bh=YU2W/e9zoY8XRLjAHDI08WdN2EsH395vdkPJNoccJg4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iLuQJT2gnRe5Ejz0zTxyOY8hkf6rWZP3jfLjbT2JJE8oC5zGXURlkYCpvK0acmuwA
	 P3hW+880DCyGvFu2zF15nSwyFD4Cd0pdTTEGKQPLDgt2f+874hHzH/nrSLmtIjZPC9
	 oSJUHwXdDdk2+7Y3jXMqhk9rhq0vEkBRHfXWt914CUFAMuqOBrFwli8NK6Ewd3y0/V
	 Chi5469qE9MIqphx72dk72P60pVUqNvqLmardP8ZbLX8DCU8/kIO9+uTc4gzE9cvAF
	 z1ffULI/mLHfHjUv0GaisLvoeq5zpJtiWmFBTN5V6Fgne92fwYRnzVQrIDZhwBejIV
	 a5ViQd+Y97GGQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB63C54F4D;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:06 -0700
Subject: [PATCH v9 07/41] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-7-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=4904;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Khc6sycubGrfoJCb/kBxgxJ7UDuxLVJB5MenqDESOq8=;
 b=c/JKNYH+h7dgoAGoTZo/8qTYbeNkf3QS755Gf97nN6FnguidBdhiMdZ4OfzZK7DSDrl3bLd4l
 tjElD8FU2xUBYgOf4Tg9CW7t1Se5AjSPj25c1x5+i3J/ohAwM5mSBBL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3035BA0012
X-Stat-Signature: a433971rusoihjz59ptduzpr5je4jomp
X-HE-Tag: 1785285310-539977
X-HE-Meta: U2FsdGVkX18rLTEjT8SzpB56HTWOud+nss2rZsXeqhxe09ipvzuGhqwWeUY//MeNgqoPzuX6vP33fOeXayQ8QOJ+wwEVMaRbaBeWlbejV2MFYeb+dwFD9atnwmGmYeMo2dlqBmbZYC6jhByOtMZiM0g891AB5RKhl0gm4wmW1SlPX7UQyBt5LYEADRNMgjMd3suHciV3GW99Qk6xk2M2aKCJ1d6Cl4O/Tkr07t8iho+xhYoCnpnh/LONhHTtuoBS83WzdgptVdig99cZHCeeiw7Cls5CJxSKsMrqEi6ucKoWFDFL5eYGEbITgkSFxEUr2pl4xEzvUkDtuWT9a905JLLuC6cqGB1cCabEKVxweR9UVhL1RiBBirdTiGXGTOwj/C14RK53MPji7cRtJ4EPSAdz+jFX8MMKJoJ4yleIKjb/CeVXhXpSeuYH7Mzs2ePen61p2Z+OrIn8Pg6atEv40+pWQ/R0Uoe3XIxe7IlZdtIlqFuWTFbSHMfJ/mLWqHJfTGkM7MFOOunk4k0GD+ZpG1gIYu0ho49bX28Dyrc8h1/37KOWBBKm1YO29ScsY9hjO4Z7mt3n7338F4pSJBBRUGD7xp5JTiJbTcUKs8XopNVZbDAeYo2b4GZ/e/grdBdEX/ZkX8RxFlzEU6Ge1fnJ9fexVtGzJBEpvdQFyFk4RrtP/Poaz+4W2JDCNWHG7H7blCRovIexHXWmmmq95pJB3sep7aLCVRn0Yd8xPD0GibM8PfTFoQ8ueuwf2WS9AG2OfvNQePZXInaf2y2vbb8ApoM6/PhLiMcvtB0sQgGfFHV9B1aIJ9N2gtu8ztkyJOkOi4mr1ZO2wE9HhOSoZlzzYO808CRImq5NKJP0lLuOW5Dwss1bSnvqydt/MQLU7KLWt7X6XjPawWjl+F4bEfScGIKNCQ2/tN8gqtLi3jPviO2OHPwx6tB5RRRa9aXBy0eWwww9Et497ysH+B04uL0
 sXQCsU8D
 Hh47Fgeg5f195/M6ddhqfr1YuJMKy9JH+xrdsSPYKpT9Mz6qS4j07pgu3g/HfDansMP//LhD4hyRkqNr+tPbliRunmmhboft8tm/QYaJL0v3zXluYb+SQSDmmRcCMax5koFlGaqnO+UymQL3jqBUE/WF3PUClsJ3ObPU9cep0f9x4+usJoV/JG5o9uk32GxNmzpStHQKgoxSzWLleUSsAgsQGhhvSELAs/y+Yk3ljOFljflAB7edVRxFXCCng2pe5+6hVkkduz1/JI2E3C0I7+3gSUYRdbXE5IyMytXKxRnwA7QcgqJL6snR/vAR325uKR8mwJWFx/TjI9UB02nJIbbpYGOximktGGDgorEOiqD89V1FPmUuF8j8DUp6kyBe3esQuO6IXWqxZSYNBz/0ViSXCLxAoOyyibZUSy44FZnxesXbFErzm4BAInT3agZNyR0g1twZ/LO+4RPwMj25COXi17XYz6iB63t1+GooyZXCKAtXXftzKtq27LsB62k+Kw3oL4L9pGQGh4+r+9asPIM/BBvmVUfsPldPmN+XLqlIEyT9TAm3xHwdoeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

With in-place conversion, guest_memfd is able to track the private/shared
status of memory. Use a global flag to toggle between tracking
private/shared status per-vm or within guest_memfd.

When queried for supported vm memory attributes, return 0 if attributes are
tracked in guest_memfd.

When querying for memory attributes over a range, look up memory attributes
based on the flag's state at query time.

For per-GFN memory attribute queries, choose an implementation (VM or
guest_memfd lookup) at KVM load time.

The flag is always false for now and will be made toggle-able after all
in-place conversion features are added in subsequent patches.

If/since the flag is false, if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is also not
selected, the per-GFN memory attribute query defaults to returning
0 (false/not private).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h |  4 ++++
 virt/kvm/guest_memfd.c   | 25 ++++++++++++++++++++++---
 virt/kvm/kvm_main.c      | 12 +++++++++++-
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 73f564b87a324..a913dd57ae622 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2579,6 +2579,8 @@ static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef kvm_arch_has_private_mem
+extern bool gmem_in_place_conversion;
+
 typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
 
@@ -2587,6 +2589,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 	return static_call(__kvm_mem_is_private)(kvm, gfn);
 }
 #else
+#define gmem_in_place_conversion false
+
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 33c9830190e2e..89cf922232920 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -893,6 +893,27 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+static bool kvm_range_is_private(struct file *file, pgoff_t index,
+				 size_t nr_pages, struct kvm *kvm, gfn_t gfn)
+{
+	struct inode *inode = file_inode(file);
+	pgoff_t last = index + nr_pages - 1;
+	struct maple_tree *mt;
+	void *entry;
+
+	if (!gmem_in_place_conversion)
+		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
+							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
+							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
+
+	mt = &GMEM_I(inode)->attributes;
+	mt_for_each(mt, entry, index, last) {
+		if (kvm_gmem_interpret_entry(inode, entry) !=
+		    KVM_MEMORY_ATTRIBUTE_PRIVATE)
+			return false;
+	}
+	return true;
+}
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 				struct file *file, gfn_t gfn, struct page *src_page,
@@ -913,9 +934,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
-						KVM_MEMORY_ATTRIBUTE_PRIVATE,
-						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	if (!kvm_range_is_private(file, index, 1, kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 80317d2c15d07..0dfc91b9478ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -101,6 +101,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool __ro_after_init allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+#ifdef kvm_arch_has_private_mem
+bool __ro_after_init gmem_in_place_conversion = false;
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -2422,6 +2426,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
+	if (gmem_in_place_conversion)
+		return 0;
+
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 #endif
@@ -2633,8 +2640,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
 
 static void kvm_init_memory_attributes(void)
 {
+	if (gmem_in_place_conversion)
+		static_call_update(__kvm_mem_is_private, kvm_gmem_is_private);
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-	static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
+	else
+		static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
 #endif
 }
 #else

-- 
2.55.0.508.g3f0d502094-goog



