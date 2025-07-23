Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBBBC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4298E000E; Wed, 23 Jul 2025 06:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094418E0001; Wed, 23 Jul 2025 06:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29558E000E; Wed, 23 Jul 2025 06:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFC028E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5FAAC063D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:29 +0000 (UTC)
X-FDA: 83695203018.10.EC247FD
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id D70161C000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eaCUtYd+;
	spf=pass (imf20.hostedemail.com: domain of 3vr2AaAUKCIc4lmmlrzzrwp.nzxwty58-xxv6lnv.z2r@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3vr2AaAUKCIc4lmmlrzzrwp.nzxwty58-xxv6lnv.z2r@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klSLvPZdGJf21T5CxWAvpof28nK2FqTvAw9KK02b9rM=;
	b=aRwZr+vHRr9H2X4cHY/xBwmW7CvaIfyZ9Rf2cQXttW5KPuLNBDv2Kl3nu1KfrHnlHbkYj5
	rfSZYm+8YAckh3jgaFHmml/GJCdPxemuLjI3qNOthf1DIoYiynX3BkcKWzu+rvhzaXBos4
	XYS/8zvAgeAAbPA36QVKqswSldIkCfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267647; a=rsa-sha256;
	cv=none;
	b=5fYLUD5oRN43cNYBX9loQm5Szr5Pj9NhEoLNoh0yR3QtLzbp0UKkOJTyBNjTJMOLuxPljr
	mpTUZG6hJ7S9O1egdHf/lThDbvqltFr1C3z+qYWqM3N4fAwZYFDNpHZQRqBZYSsPt9d03M
	OjOdRr69O1nPMe2lJwXOzfpmgUoGfxQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eaCUtYd+;
	spf=pass (imf20.hostedemail.com: domain of 3vr2AaAUKCIc4lmmlrzzrwp.nzxwty58-xxv6lnv.z2r@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3vr2AaAUKCIc4lmmlrzzrwp.nzxwty58-xxv6lnv.z2r@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45600d19a2aso53946285e9.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267646; x=1753872446; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=klSLvPZdGJf21T5CxWAvpof28nK2FqTvAw9KK02b9rM=;
        b=eaCUtYd+NYDMiU3oh4+kluUy5C/0aLOC37PzYevgt3h60IapdAJaoFS6I1SKYNYbPY
         cmPqVxFyNH8jlO3J74ZPULz68IMVUK9JU8ZckjO+06wdeAurA1mvQhuJLGBLVqQRVBES
         D9zlejGWTWL7FdnDZ88Jk/0dxpu3MehMpLKDG7xihBvWQSpBPELtia4Y+b6WXxZomuwN
         UDElQrMpm3FufU4vSmmGHLRChmW80Ao/N/LekcL7ljJegnxH+acxYSUesZtMjkRryMMM
         b8qm5BNEtDu/gFkZZTISRhdvFk3CU4ZokwAk6lMw58idWT5ovPy/2oKmCnnUG04w0fjR
         k25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267646; x=1753872446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=klSLvPZdGJf21T5CxWAvpof28nK2FqTvAw9KK02b9rM=;
        b=vFlZXulaqBWVn+GOTpcHTGnOyrKcRyvF79CALmgsb/9DtE78s2oXKQi8qBa06cziZ7
         WKXYeHe1/1O/KzocBwcDZeF+VojcRit0644HN8THzQNLAhEQo2AhM+wLcRN+Z9bUQ96J
         5oHFmz0Jr/AXqV2DnCHsYZ38Ncs3MCVQZSSHQY4f10DdZCefyFfxaFjBBrWWj7ggITmV
         CS0/MM2/7mfqXXuAEoFAhqw+2pTilPxCUMEcXKWzuXf90kxPWktepEIAXygNxDPHGjvH
         bfEVKenPCn1ULQyYGD5X2H7KHrvNDA6ye96wfhJqVRdDP+YI5GfsnlC21YglV99COHox
         y2Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUoUbA+M5NFd3KTw2ALIbu6tzwkNY6FHYPc6cyJwLpcCPwwjjrsyQP9AMEcfUPpRS9CqMfI8fJGJA==@kvack.org
X-Gm-Message-State: AOJu0YxtYom4rY/J4HLBBlYkHvSIFzNbZpkkgMKS0LAbKNB2N/1rKjOd
	8/Wha5PQzo4ixaVVY+FJ3I3Xfc6cIqnzV9IiXaPnD8IYZ5AuomiM7YK3DC0PvV80NPXnLxRuCY+
	7pg==
X-Google-Smtp-Source: AGHT+IF9GujN7e5PEevnbfhJVmv/zauyrMQPlcffBVgGfUsoXqo1KZ7TOBa+t16TTquYqLmxApIIyf6F5Q==
X-Received: from wmqe11.prod.google.com ([2002:a05:600c:4e4b:b0:453:86cc:7393])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f12:b0:456:f1e:205c
 with SMTP id 5b1f17b1804b1-45868c74efcmr21231745e9.4.1753267646461; Wed, 23
 Jul 2025 03:47:26 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:03 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-12-tabba@google.com>
Subject: [PATCH v16 11/22] KVM: guest_memfd: Track guest_memfd mmap support in memslot
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D70161C000A
X-Stat-Signature: wjjwjj5w9pknbs7axcyudh9zk96m94g7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753267647-63870
X-HE-Meta: U2FsdGVkX1+wir2VwkRP6HqD43k726P8C7da8DS7jn6eVEGGCh654dwGjDCQMPGzvU/a2QLqJCmI4P2T8Ho8vEDwXXnGCwYnmrZ3K4lFbRbarmrKV5ODCzYwvv3MiJcLxAT5ambAd09bYItpoep7gH62GHtbbTxe+HE1OX8rU0ev3NkgOdfzDrGGvwajDeXQMA8thmtazK/fBQC64MNtkx+wgaHQZnN8fWF7/iIsOBPQ6lq+OiaP61mGDYBO/o3iXBglpvfLq/o8A6Jv/vgd1cm3SH572eE1LM0GaHzPyD+BRXDl9cmVZ5oc1ecLKoGW6Oj2E8NkczQ4I8pniqgY9d/FHyBYJtDvI0MJHGyTg0gUlc279fowXlz64lYay6Zn7ohN2yUGa3cg2AwTzExAh/UW/imKFlr3Xg8OwLryTB1D0P6TzBrQoug2TwXSduD3m3j778VSzccJkkdrA72ZP3qheyngMuCrUTIao6I4xFwbaL1LmvmW6XKrJFO9SfTtkXII7fKfio2i8yV5JJQO4bXGZYuyleFNfk2fTfClXH/Aue4w2fqmkH+/SL4VTw09ve6j/7yF90+NU52fEQt8062HIUifykPSEfbXsBEcnmludwmi0iXYU2lTC2iwjuX/Aw5NSLg7jOLiTxZtAlBTudTncoYREGH9KqyWTrX3F9dV6OnuZQCumhJY4Pt+MFkvSadJG2ygWHGsGi4oFecPQNs1NkdntQoMGDh+M/daKGNdFkblQ6vH1x3vpjC+DaNEvNDlSgtN9J/RKPBPf01nBY8wlLwcKJ+XBtbP/8yG6YKrtJKqc9nepuyiECBS5Riah0B5G+hduzNB24GkMKOfkPa5J+ChhktWECCpGq3zFQcgVV2ds/Lik9wVrZP71hRPdpjBCa5m5MqO6onUft+x044rFiM/13rDB/Y0dQ7XUYKNKZtIqRNxitwDJH83+pGNXe9uqwMR+SZtWXGl8Gx
 Tuoq+SBT
 cjLixrXcU653QpuCkq+AY6RdzKSnWR1EEy0190JO8nu3EuyeDnrOg10pYzch05sEeC2DHWrtom6WTDHszgpvg1oCYR1XNJdV90tBWx+hEmKjPyuhfbimk/ijxIZYvlyaKjGKYYDE662vXFvortcbb2YuI42dtFEwKDmdW9qa5WvJftj97V1f/CYGNR+RLoZ8GqF+cuN+Dhfy/jtseCSJNjIkSl+cP1AzfZMmim5TwyKj6EL/zYw/Y0IfLeErzsgDk+Lv5Mwr/gk69BIOlEW6gIze/R/5aiM6FJmXn8ImYK62WWFydWtUlD34Qr77rKhrAJa1D0MjKvXIOaY7N+ui2YfiZoqUfeFhUePF24HiEuZ/L/ALuFvb84MxbcfsJiV9zb2i8uH7YysDcd6QIm3cfbKPXhcja5PK5ZPiMhEZEwffR+DdkYk1XZ09xBnWr3KQ4uafCtgHYKyDlyl4mVQqcDzqHJS8rOnhqXpBuN+dNcmhUy9IQBcyvq/srp1mTPI8nAaejBShBJYT1z3cDrIwL5IVmQNCWzniYjAF5a9SS5NmNWYkykWe6V1Ejla9/Bl+P5YKiy9PfmQ8FGckrq9Bx1H3bf8ygxYhG6KKG/h6zCHLI30guAn2HPLGRjkgdCAe+eXG1LmYB75Xr1yAjGcYZknwxJs4I1xnGHWbTT+I8DhGLywNfwOUFB3klm2IDOJpZzwSQWyohjygNe447RcuHyLyy3Ngnyzx1WpMwBq7C2q3EI/a/nt9SBMJ5TA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
memslot->flags (which makes it strictly for KVM's internal use). This
flag tracks when a guest_memfd-backed memory slot supports host
userspace mmap operations, which implies that all memory, not just
private memory for CoCo VMs, is consumed through guest_memfd: "gmem
only".

This optimization avoids repeatedly checking the underlying guest_memfd
file for mmap support, which would otherwise require taking and
releasing a reference on the file for each check. By caching this
information directly in the memslot, we reduce overhead and simplify the
logic involved in handling guest_memfd-backed pages for host mappings.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++++-
 virt/kvm/guest_memfd.c   |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 26bad600f9fa..8b47891adca1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -54,7 +54,8 @@
  * used in kvm, other bits are visible for userspace which are defined in
  * include/uapi/linux/kvm.h.
  */
-#define KVM_MEMSLOT_INVALID	(1UL << 16)
+#define KVM_MEMSLOT_INVALID			(1UL << 16)
+#define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2490,6 +2491,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 67e7cd7210ef..d5b445548af4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -578,6 +578,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (kvm_gmem_supports_mmap(inode))
+		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
-- 
2.50.1.470.g6ba607880d-goog


