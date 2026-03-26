Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9070E10AB82E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F266B009D; Thu, 26 Mar 2026 18:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16AD6B009E; Thu, 26 Mar 2026 18:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD616B009F; Thu, 26 Mar 2026 18:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A91D6B009D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 586575CA04
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:48 +0000 (UTC)
X-FDA: 84589645056.22.A957821
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7625A8000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i+W3laAT;
	spf=pass (imf30.hostedemail.com: domain of 3LLLFaQsKCPsdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3LLLFaQsKCPsdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNz7dKp3qod8Iu2OS/CY/d/eVhoCNMajDkSF7493OBc=;
	b=49JaxXEbtrYRgI28BkOq84Bh5XV61w9Vmn3j4Tgcs4TrLHJDY/y6I4Diy8i/3Ss0oNMc7N
	eoiW4JrQArbaxCdo4pbvlAnYfEcQjFq8CW70Z4HaINgMPxBb0+lrYGAFVL+sTZYNQjCxhj
	n0rBm3ST0o+BZ5jo8SoFaUT+tcHF5Yo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563886; a=rsa-sha256;
	cv=none;
	b=Mk2hZVDm7kMUqUZiTB//1xDWBdw4d6/ipk5RtX1+biL37UCYMh8OfYLOYsNkfDDMlzlbES
	r/bVLn2MRPtTL+9ejWF4Wb8l02QCrKRV52LYuowvkmwl5B7j0/uLiaHiXtLLMbRaK0m8cV
	pNodtIl7hvz0rV96WfXM4gXPdil6YbE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i+W3laAT;
	spf=pass (imf30.hostedemail.com: domain of 3LLLFaQsKCPsdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3LLLFaQsKCPsdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7381a95fffso986521a12.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563885; x=1775168685; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hNz7dKp3qod8Iu2OS/CY/d/eVhoCNMajDkSF7493OBc=;
        b=i+W3laAT7t93uNVntLTKA+8oIXCpn0Sruw3zJmKa5ZMHF4Kk3VXFUL61c90aLryrKl
         YzSMMlIStOQe1GwWhAkdxbXudjuLp0OXbiRG+7mQgUZx9gOEso7JB/ZncjdO6Vv8EPwZ
         JWR8PZjvbFeHeS7yyLC+YM3ak41RvLk7RwR9399BzDamimLG+JF1lCi8F10CNZ9WXXCS
         rSQxV82XYzaWGKO68PhehJs5T4n6OmWZ1/lse/jkrN6UZ7lhwc0I5TSt1ByzXCXAij5R
         A84oteTsYpXiOwgjUcIl0rGFgcGKhu/ztClK3F7qy/G1TREYL9EJ5dUc4vDTLGNEpz9q
         I3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563885; x=1775168685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hNz7dKp3qod8Iu2OS/CY/d/eVhoCNMajDkSF7493OBc=;
        b=SNtY5xQ+aEawTKnJdZ4KURODgL+RGI5LlvEvzlronIoCqX7jxhSG/EkkJYIZfot345
         NaBouZdjF7Vg83fyS7L1gp+sQ8grD0UPoOyAWeTo9JLVMfpsIyMJ31qo2vGRlnzho6Qf
         Y1JFcAycmcTNgVPb6DS/KYUWmATqEKiJvb4uhGhYoajth+JH4WXNjQ4ZrW13zTsuMY8Y
         1ekgQ0p+MIKaGW3UHP3dKk1eQW1AvbR5TyanDa78CraMVb3eHQbphaVIc4EwAkl1njzF
         E2JSutd9CHCWrVewNh6cFbmAFOeKwTFBKATsDPlOBYfLdFf8BY/sLF9g3KLRFdbdbHay
         DvjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP9BzJ4mDRuA4M42HpEPVRJpxhM6ZBtWHUeWXUdSsa/BbD2ow5rnOBWb1wVHhdv+RCpuXGt01q8g==@kvack.org
X-Gm-Message-State: AOJu0YwTEYRnmYB3rkgKfa5dS18OsPzPisQfe5cDVBckiog+bzplXYGF
	1o2f6s9x8KzJC3E191z1mk8c2LcFlgWCGtYgpZQg3TrQQuVuy2cA1/ooL8TAeL9YGCWfbUVY+Yx
	lymobSLJdqYk3v80hvWG5c0LsEA==
X-Received: from pfbig17.prod.google.com ([2002:a05:6a00:8b91:b0:7b0:bc2e:959b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4b12:b0:82a:8030:f574 with SMTP id d2e1a72fcca58-82c9605623dmr135288b3a.33.1774563884826;
 Thu, 26 Mar 2026 15:24:44 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:19 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=15781;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9ixsRIaeC9vea9dnhRR9Gp60vmsiq3UD4+TPS2FFgGw=; b=sPWuy+R3a1t7m79dAJ8Gjh7qEWTks+CQpdvcIIbeFS6JR5Nko6LhtlHnopauaj4S6vicH4i/+
 BNzZoot3Wo3DVChCt4R5+ygp4SnrF1R73nQKNf30EpJff3nUhKr+FCA
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7625A8000F
X-Stat-Signature: dmeo4z9kc1txip1ui8b9ges7ahcjkq47
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774563886-551117
X-HE-Meta: U2FsdGVkX1+2iJgKrd/vva3MubwE46Ct2L5+7Cxu0UeRifwagaC7vVtAuDdUiuiS6sxiVauutKzVMIqjTOdKmTL/13lrdFV1e8/P5beFl8hR6pg4spysRFtdKiEwCT4ygEuXOHbqSA4KEVRyySH+RJ73v9uGrTHmba2eMz7T0c86UN2X8ygUy9VpUgfzTu8mKIknk/RTq1f786VFIL2jCwXtmfHVn/gHCA1x/FwS1UOhURrxuxqGOHZ62Eh5b3J/ynhLFtSHbEXerSJsTjOLYmnTbJHSd20bc6z/2vzj7Skmty1AXIKMhoTasvBMR4W4FA8Sl0AQq8vaf55hFf5TZ2dc++j3goFDHT5DwRWI45AsJkShmL9e6e+5OE/JLWfgmIvViCytTSH8VLgppeZB6yKTb1wnAlfdnaibNNEEszpEk3redPto0Spb9nny5q8+8XQ2DRLE0LjS3fYvmK+V1aAMndRocZ2uyVCKHiOHL2qr8leS59ngzwz2sfPMB2tehETI8qQPLlahhywH4Z7UVLpYCr+Z9UBIUN5FXDNUyUHmZ+M+GU2Kp7u06MMKlou827fwksKnjkfTEd1QaCMJnhlu4MeZvCkzjCDe8C6eoaAbPM9o1B81I4XMZ9SO2cpwq8JHEdTtZDGlg5Osm/26JNsOWzOecEwbEeVyx0DqBoU+SbmBuov5nfsaBu3ZWCZMxAVVlZsmYSodff8iuRjh3qoV+vSRPNvoBRL3eaq/Vh1XyhjDnCcvDEqi6V7bxyCq0yGQr2dutCRFYSJPSRfD+sSTimO7LWgdQP6zTPx1S7eMHjANQBBGPk/jXa3WYoPKBff4O6pfkzNcVBmJUoEJNGIMpng68SawTHnA9IsTnD72c3iuHVz8N5leOOzYWx2zXn9lyKc6JzXSOH+Vm87LvtXV+d9h/OgFyCrdkAeAKctQNXHugak9ji2wATe4zV3H1SABrz32N5wKr1EPIqz
 TvML1Cf4
 soOJp9BDNL1YRuFVaDV7PUaLiggXjdJ1iqOOMPSVnbTVjnbvYTlVunFd1vcrcucWWqKraWQ04Enf09Bi27gysW1yYhhBCWK19oxsK0xSbcVPJHQsobHkw+X+UkEPCeH+2LxA8XIfrZqcUauEtSuTxz2Gs3qmkNTTnHyeYZ0ulyTslXqR4rN0NMWOaM3dtZYbyIP/JXnLkbwdzcTiNgvLhwaFSMBUMwQ3c4/HJvli35htgLaBC2mBYO1m4Ebm2GVkU5/+v0YB+9vYC3Obi1QSa0gAyGXDKee06FR6ooU2+M9ym3W2zqSulfprvgT//IPWGXVVc69h3Dq5TteNT/S9w7YsPF9zXD1eQcWK0JGMnlQAva4VABDSSfxBw6ZqEykfUC9GECnm/gw4Fs/dTJlyqRgSsHHtkpQSxOGIGozmHfJWr4A4AK8zeQ4rPHjly2vrea1kCadykWthFTGCqbXDzLPGkRwmGcWzwUCY5diI6W49X6fRqXZosgD7Bz3rDliOxACAI5A2ZzmdH/i5+J4qtud9Zb5CwFlLxcWbEpibH9H66vw4HDi4uaNHS7FxLcBpJM0qqlpaHgLjzRnCO2I3+kHRS5+D1EFuH0yps3ZaXs3P7jtp+v4oOzMN3CG3l9tuXM44welI5IboeKU6UNPGLyb4dMOA5igUeLgNlU7qFv6KEnHRykoCAStuTKkaVXwdqIaISclgKJAPhKh8FuEO58KlZzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For shared to private conversions, if refcounts on any of the folios
within the range are elevated, fail the conversion with -EAGAIN.

At the point of shared to private conversion, all folios in range are
also unmapped. The filemap_invalidate_lock() is held, so no faulting
can occur. Hence, from that point on, only transient refcounts can be
taken on the folios associated with that guest_memfd.

Hence, it is safe to do the conversion from shared to private.

After conversion is complete, refcounts may become elevated, but that
is fine since users of transient refcounts don't actually access
memory.

For private to shared conversions, there are no refcount checks, since
the guest is the only user of private pages, and guest_memfd will be the
only holder of refcounts on private pages.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst |  48 +++++++-
 include/linux/kvm_host.h       |  10 ++
 include/uapi/linux/kvm.h       |   9 +-
 virt/kvm/Kconfig               |   1 +
 virt/kvm/guest_memfd.c         | 245 ++++++++++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c            |  17 ++-
 6 files changed, 300 insertions(+), 30 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b61e2579e1d8..15148c80cfdb6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -117,7 +117,7 @@ description:
       x86 includes both i386 and x86_64.
 
   Type:
-      system, vm, or vcpu.
+      system, vm, vcpu or guest_memfd.
 
   Parameters:
       what parameters are accepted by the ioctl.
@@ -6557,11 +6557,22 @@ KVM_S390_KEYOP_SSKE
 ---------------------------------
 
 :Capability: KVM_CAP_MEMORY_ATTRIBUTES2
-:Architectures: x86
-:Type: vm ioctl
+:Architectures: all
+:Type: vm, guest_memfd ioctl
 :Parameters: struct kvm_memory_attributes2 (in/out)
 :Returns: 0 on success, <0 on error
 
+Errors:
+
+  ========== ===============================================================
+  EINVAL     The specified `offset` or `size` were invalid (e.g. not
+             page aligned, causes an overflow, or size is zero).
+  EFAULT     The parameter address was invalid.
+  EAGAIN     Some page within requested range had unexpected refcounts. The
+             offset of the page will be returned in `error_offset`.
+  ENOMEM     Ran out of memory trying to track private/shared state
+  ========== ===============================================================
+
 KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
 KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
 userspace.  The original (pre-extension) fields are shared with
@@ -6572,15 +6583,42 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
 ::
 
   struct kvm_memory_attributes2 {
-	__u64 address;
+	/* in */
+	union {
+		__u64 address;
+		__u64 offset;
+	};
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	/* out */
+	__u64 error_offset;
+	__u64 reserved[11];
   };
 
   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
+Set attributes for a range of offsets within a guest_memfd to
+KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
+memory range for guest_use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
+supported, after a successful call to set
+KVM_MEMORY_ATTRIBUTE_PRIVATE, the requested range will not be mappable
+into host userspace and will only be mappable by the guest.
+
+To allow the range to be mappable into host userspace again, call
+KVM_SET_MEMORY_ATTRIBUTES2 on the guest_memfd again with
+KVM_MEMORY_ATTRIBUTE_PRIVATE unset.
+
+If this ioctl returns -EAGAIN, the offset of the page with unexpected
+refcounts will be returned in `error_offset`. This can occur if there
+are transient refcounts on the pages, taken by other parts of the
+kernel.
+
+Userspace is expected to figure out how to remove all known refcounts
+on the shared pages, such as refcounts taken by get_user_pages(), and
+try the ioctl again. A possible source of these long term refcounts is
+if the guest_memfd memory was pinned in IOMMU page tables.
+
 See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
 
 .. _kvm_run:
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 19f026f8de390..1ea14c66fc82e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2514,6 +2514,16 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 }
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+static inline u64 kvm_supported_mem_attributes(struct kvm *kvm)
+{
+#ifdef kvm_arch_has_private_mem
+	if (!kvm || kvm_arch_has_private_mem(kvm))
+		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
+
+	return 0;
+}
+
 typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 16567d4a769e5..29baaa60de35a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -990,6 +990,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_USER_OPEREXEC 246
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_MEMORY_ATTRIBUTES2 248
+#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 249
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1642,11 +1643,15 @@ struct kvm_memory_attributes {
 #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
 
 struct kvm_memory_attributes2 {
-	__u64 address;
+	union {
+		__u64 address;
+		__u64 offset;
+	};
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	__u64 error_offset;
+	__u64 reserved[11];
 };
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 3fea89c45cfb4..e371e079e2c50 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -109,6 +109,7 @@ config KVM_VM_MEMORY_ATTRIBUTES
 
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
+       select KVM_MEMORY_ATTRIBUTES
        bool
 
 config HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d414ebfcb4c19..0cff9a85a4c53 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -183,10 +183,12 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
 {
-	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
-		return KVM_FILTER_SHARED;
-
-	return KVM_FILTER_PRIVATE;
+	/*
+	 * TODO: Limit invalidations based on the to-be-invalidated range, i.e.
+	 *       invalidate shared/private if and only if there can possibly be
+	 *       such mappings.
+	 */
+	return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
 }
 
 static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
@@ -552,11 +554,235 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_memory_attributes);
 
+static bool kvm_gmem_range_has_attributes(struct maple_tree *mt,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(mt));
+
+	mt_for_each(mt, entry, index, end) {
+		if (xa_to_value(entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
+static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
+					    size_t nr_pages, pgoff_t *err_index)
+{
+	struct address_space *mapping = inode->i_mapping;
+	const int filemap_get_folios_refcount = 1;
+	pgoff_t last = start + nr_pages - 1;
+	struct folio_batch fbatch;
+	bool safe = true;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {
+
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			if (folio_ref_count(folio) !=
+			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
+				safe = false;
+				*err_index = folio->index;
+				break;
+			}
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return safe;
+}
+
+/*
+ * Preallocate memory for attributes to be stored on a maple tree, pointed to
+ * by mas.  Adjacent ranges with attributes identical to the new attributes
+ * will be merged.  Also sets mas's bounds up for storing attributes.
+ *
+ * This maintains the invariant that ranges with the same attributes will
+ * always be merged.
+ */
+static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
+				    pgoff_t start, size_t nr_pages)
+{
+	pgoff_t end = start + nr_pages;
+	pgoff_t last = end - 1;
+	void *entry;
+
+	/* Try extending range. entry is NULL on overflow/wrap-around. */
+	mas_set_range(mas, end, end);
+	entry = mas_find(mas, end);
+	if (entry && xa_to_value(entry) == attributes)
+		last = mas->last;
+
+	if (start > 0) {
+		mas_set_range(mas, start - 1, start - 1);
+		entry = mas_find(mas, start - 1);
+		if (entry && xa_to_value(entry) == attributes)
+			start = mas->index;
+	}
+
+	mas_set_range(mas, start, last);
+	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
+}
+
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
+static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct folio_batch fbatch;
+	pgoff_t next = start;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+			unsigned long pfn = folio_pfn(folio);
+
+			kvm_arch_gmem_invalidate(pfn, pfn + folio_nr_pages(folio));
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+}
+#else
+static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
+#endif
+
+static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
+				     size_t nr_pages, uint64_t attrs,
+				     pgoff_t *err_index)
+{
+	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	struct address_space *mapping = inode->i_mapping;
+	struct gmem_inode *gi = GMEM_I(inode);
+	pgoff_t end = start + nr_pages;
+	struct maple_tree *mt;
+	struct ma_state mas;
+	int r;
+
+	mt = &gi->attributes;
+
+	filemap_invalidate_lock(mapping);
+
+	mas_init(&mas, mt, start);
+
+	if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs)) {
+		r = 0;
+		goto out;
+	}
+
+	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
+	if (r) {
+		*err_index = start;
+		goto out;
+	}
+
+	if (to_private) {
+		unmap_mapping_pages(mapping, start, nr_pages, false);
+
+		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
+						     err_index)) {
+			mas_destroy(&mas);
+			r = -EAGAIN;
+			goto out;
+		}
+	}
+
+	/*
+	 * From this point on guest_memfd has performed necessary
+	 * checks and can proceed to do guest-breaking changes.
+	 */
+
+	kvm_gmem_invalidate_begin(inode, start, end);
+
+	if (!to_private)
+		kvm_gmem_invalidate(inode, start, end);
+
+	mas_store_prealloc(&mas, xa_mk_value(attrs));
+
+	kvm_gmem_invalidate_end(inode, start, end);
+out:
+	filemap_invalidate_unlock(mapping);
+	return r;
+}
+
+static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
+{
+	struct gmem_file *f = file->private_data;
+	struct inode *inode = file_inode(file);
+	struct kvm_memory_attributes2 attrs;
+	pgoff_t err_index;
+	size_t nr_pages;
+	pgoff_t index;
+	int i, r;
+
+	if (copy_from_user(&attrs, argp, sizeof(attrs)))
+		return -EFAULT;
+
+	if (attrs.flags)
+		return -EINVAL;
+	if (attrs.error_offset)
+		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
+		if (attrs.reserved[i])
+			return -EINVAL;
+	}
+	if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
+		return -EINVAL;
+	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
+		return -EINVAL;
+	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
+		return -EINVAL;
+
+	if (attrs.offset >= inode->i_size ||
+	    attrs.offset + attrs.size > inode->i_size)
+		return -EINVAL;
+
+	nr_pages = attrs.size >> PAGE_SHIFT;
+	index = attrs.offset >> PAGE_SHIFT;
+	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
+				      &err_index);
+	if (r) {
+		attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
+
+		if (copy_to_user(argp, &attrs, sizeof(attrs)))
+			return -EFAULT;
+	}
+
+	return r;
+}
+
+static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
+			   unsigned long arg)
+{
+	switch (ioctl) {
+	case KVM_SET_MEMORY_ATTRIBUTES2:
+		if (vm_memory_attributes)
+			return -ENOTTY;
+
+		return kvm_gmem_set_attributes(file, (void __user *)arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
+	.unlocked_ioctl	= kvm_gmem_ioctl,
 };
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
@@ -942,20 +1168,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
 				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
 {
-	pgoff_t end = index + nr_pages - 1;
-	void *entry;
-
 	if (vm_memory_attributes)
 		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
 
-	mt_for_each(&gi->attributes, entry, index, end) {
-		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
-			return false;
-	}
-
-	return true;
+	return kvm_gmem_range_has_attributes(&gi->attributes, index, nr_pages,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3c261904322f0..85c14197587d4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2435,16 +2435,6 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
-static u64 kvm_supported_mem_attributes(struct kvm *kvm)
-{
-#ifdef kvm_arch_has_private_mem
-	if (!kvm || kvm_arch_has_private_mem(kvm))
-		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
-#endif
-
-	return 0;
-}
-
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
@@ -2635,6 +2625,8 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 		return -EINVAL;
 	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
 		return -EINVAL;
+	if (attrs->error_offset)
+		return -EINVAL;
 	for (i = 0; i < ARRAY_SIZE(attrs->reserved); i++) {
 		if (attrs->reserved[i])
 			return -EINVAL;
@@ -4983,6 +4975,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 	case KVM_CAP_GUEST_MEMFD_FLAGS:
 		return kvm_gmem_get_supported_flags(kvm);
+	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
+		if (vm_memory_attributes)
+			return 0;
+
+		return kvm_supported_mem_attributes(kvm);
 #endif
 	default:
 		break;

-- 
2.53.0.1018.g2bb0e51243-goog


