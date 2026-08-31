Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 232C1C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3150D6B00A2; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC5C6B00A5; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1677D6B00A4; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E76F16B00A1
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7336FA0381
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:27 +0000 (UTC)
X-FDA: 85159670694.08.8060198
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6E3C020003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ejh+TJUI;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135925;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FHaa6cinKdMevKfZ5HnnpOMRlndpq3eSwtd23Pu0Vk=;
	b=nMzcB+enSBuQUCeI0LZ2gFulzSn+Ekf0c4in3tCPvj0pvbW5J3JyS4aWUb0/heSvAxmG42
	HF2fwnI1UnOw9aMNmR0Fto3Mx87oORG6JcE3B9DdcgzN6UfOsAlicOovtP0FgcebFUiEaI
	PSX+X8VA/Ef864qShgaQwQ4TcgX9ByU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135925;
	b=BoBobvwG9/8zGQ4jUoGl5437aBE8c2NQ5giAcCEFmokv8d5JEVJvxO8CkfbyQ4+aj46awc
	ikHfrMo11CICtGOZzd5Uh7wBr3VL4gkj+gYTM7b1qfbSbmziaQCWEn4RAyhYgkboNkb5ll
	Mcepk6/hLWW09JQqVd/wyK+OaIZeZz4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ejh+TJUI;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBA9C447B0;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E7D0C4AF1A;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135920;
	bh=DZpQ92XBOjBoM1b7sYZ3t5UrnywIOYsWYCcTY22qsc0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ejh+TJUIAmD4GchoslTswo/jrht6zz88x9ItWgmyd9LuevRCE1a0wSJeEFHK0GF4l
	 Epd+5/TbrepFHtHaVDdQxnTi0x/HBmdPZpoGzTSPuCcP5QJUYkDL7gOGIgERoezzF5
	 w3XYrQMZoBLZVvNIhdE0UlVzGSc1XB6rhTlsi9AxwIgKhpEueo7tSWGq3iXpIL3NPw
	 4Sz0P43mfZffHtzqewT6KhZR7bIAUXQ35h+VHQ1G48bqg+sT7Vp5WYBzzN0CIFbr+Z
	 AyGOzeiqto7HibazR7JWSeqTc4UZbFK8+K5OpNi4EckoFmwduN0x86Sn0KaB/NHxce
	 ls8OE0I88TfLg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D83BC61DF1;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:11 -0700
Subject: [PATCH v12 10/45] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-10-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=2542;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6Xy56OcFO1cFOCTRnCIpR40/ey3zdpWxICCe2ijHXsg=;
 b=Mp9gKeORouIVuaIPVdTu0NcWIIpf9aAxcyZKn6ShAp4Mz1JbXX5xFMCc5DPboZ9FoXuUQSGUf
 lZOGe6/A4FVAgRywtX2XRTeKaqWeGZUH6CwkTPZjKiWuiLdXu3/rg0t
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: rnybtif38xzi7oq6ut3qzgqyzczcqiga
X-Rspamd-Queue-Id: 6E3C020003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135925-117918
X-HE-Meta: U2FsdGVkX195nR4zIwnOwFhZg9ViYQJPVTxUtsGGKBeVla9GK8yso3LaOhveq7QpdE1cdhBtbOZIBPma5rofWvytue6RgNwr7R3f2+0fxWLTMcPD34gJV1kLA1i7KBvBpm1Zl9Jt1HHMlxo3Q2p1UViohpLHv5jAilmQCfukRZpLXG494jUzA685vgM6EyvBuK2Jn+8yZdiuzgOOJdhPivuhI4Qp3Z/BMpb4LYL+DiepGSWsyvUpB2O+2yvHKCWHJ917WiMy1w2gJwWaiIACL7SP2R+Ev9/X0RhMlDimxB6hWPAfExUsIeHlwkaDg9x2/8fc/a2SxChlKuZ0SgdusYcWgjf1Gr/UAE/gsq1S+xtdAl7tiOZu5e1Rw1CSHiHIQzE9COZWfaDcpdut9VZ9+7sGL+TtuKkboDnuZWk6KvIi5h8FfwohpaAeP4gNu+2sW+fR02scVVH4FEnU/TVgKG1xuHQr9tRgBrsqeJ4Hgi8Hkb+hiI9iX8pBGuJAiFjsZLjujoP0oogwa6f4ek9EcFpeviAPxGse1NBMnO1UJiQXK5AKo4Iue172qJdzSjZcd+4EiPkfPa7oLsx2K8XBeFaoNhrYuaHxP/AgDX5kH3ckyl2AXuUuXGeTOQanGZXKUXRVA1go4Rp3IbCAFZdkosOiMgq5GZWpJBQBCgYAtkhx6Ofea4O0Ca4PmW+ZJoSq8K377wIpXLA69Gwo+dyOYJAQU8sQsmAqkPanVWnu23w+7VYAYrlqqFwA4OyKZdeP0sVpgcm6YE8KJma8A2Ec9dWtiivOg+3KybAsDUFgoJLpyPv/YjGJj2MGLlNnH018175VRDCkUw3EfVnjq2QES96XLMXm3PWIDIDgkHSksWUmIHb5yWTm9WM4wI07rEjJ9cPSGz5wB+WhgY/CQYRL70ZoFQozb3s9Lmw1eF8Jj+vhR40oFwBfUzKna3i9hEGdDFIIaN/Tve3r0q9i5y0
 wPenTyhL
 7tPxF05P6V/Gf1vGQ4T9PVRZSCLumP7Z0cwVkCnD2yYvvgOJgKsTwH7gXWFxgSkKUIMYcY88dMRtavoC9eqhqvVafGR/vZfO8Mivnwexs4tSywrgQ121RtwRRbGQ9dh97RnogULcno3CFcTyWpAza05YiRrBQ35qQm9Nf8ViTCoAiU5ruorqIs3vGNCI0FJ7Cc/lzL50Gmcy31mqp9F8H5Oq94vaiJQlKS9d3u1d7GwHEgG/zY5GD0ruISEM/SgXBu4FLv9OXRgABeE/3mpXb+BoMxZ/Egi4RrHRhjh5rnzWHjgddwZ8V45PXaqUT7X5QO4NzQ8jSnUnmmNWtFr0OdYOWgGRe6U/mpmv+YSvuR5Y6zBUMAcFYsxnrKsUxooP//TrXuXmHS6NHDOleHcimu7thc6y2mhQGwe7gsN//o/UgA82v2sr0XUYvDZATx5S09eiPUjZX7PNYsrKz6nW5HDfI0eh4ExlyW5275j5OtSnWsjPFKmAAZpKcBnpVBurOLfGT7Dz/H0B19X1+zlYyAvoW6zTA049/Ia7O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Move the kvm_arch_has_private_mem() stub and a few guest_memfd function
definitions/declarations "down" in kvm_host.h to utilize existing #ifdefs,
and so that related code is clustered together.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b0110143d2ff8..ab87effdd221f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,27 +722,6 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef kvm_arch_has_private_mem
-static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
-{
-	return false;
-}
-#endif
-
-#ifdef CONFIG_KVM_GUEST_MEMFD
-bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
-
-static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
-{
-	u64 flags = GUEST_MEMFD_FLAG_MMAP;
-
-	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
-		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
-
-	return flags;
-}
-#endif
-
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
@@ -2592,6 +2571,11 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 #else
 #define gmem_in_place_conversion false
 
+static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return false;
+}
+
 static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2600,6 +2584,17 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
+bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+
+static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
+{
+	u64 flags = GUEST_MEMFD_FLAG_MMAP;
+
+	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
+		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	return flags;
+}
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);

-- 
2.55.0.897.gb25b4bd76c-goog



