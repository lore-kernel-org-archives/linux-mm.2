Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB225CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9718E003B; Fri, 17 Oct 2025 16:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662328E003F; Fri, 17 Oct 2025 16:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA2B8E003B; Fri, 17 Oct 2025 16:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79C928E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47F9BB78CE
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:50 +0000 (UTC)
X-FDA: 84008704500.24.40E5586
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6ACCD1C000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ZHx/GjPd";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3P6PyaAsKCJ48AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3P6PyaAsKCJ48AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731968; a=rsa-sha256;
	cv=none;
	b=zQpSNMrEHM8YVagxNRiXzFMzvt6QJmauaFcOn/qhM1bsyXlW8P7/JeFsmbWSokSWXcRmHj
	4n4kKIzHpeq2zwW4u91prlhl8DbGQdiQmSbkuczrJhes+76NNa/4RAwq56tWnRbqIJtfkW
	3orxV2VaSRFOtE5DNuLkxZmHXhZkcDY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ZHx/GjPd";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3P6PyaAsKCJ48AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3P6PyaAsKCJ48AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2MJNKUzyfpWZ1q1vEvG9dwdn9W10ieDvSTaPXJMXFQ=;
	b=FmeyYK53VrIZeA0rYgCJclLpsdnWvOGh7GoOzRxHI4lh1wEj5LN3pJbM+70YGYsNw0c8Wr
	2FgyfsXRh6sdF1jbW4i5eToSrZx4FMg5PdKdQrjKFjOJKJZ5nM+zJ9i+TA5qLniq2WiT1M
	6iPkjnS5u0PLZG5IakwM1t9ixlvoZPw=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6a2409137dso1976586a12.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731967; x=1761336767; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q2MJNKUzyfpWZ1q1vEvG9dwdn9W10ieDvSTaPXJMXFQ=;
        b=ZHx/GjPdxTQgyXDp5qAvH6aiOxSR6S5zgIhRJ+p2X55WfW8HlvY+z34L7On3FB9TMx
         mwWma7OzGX8Gd2uCkrqAwpS0ZXNv6w9TLhOAosMOqvqU3ISyLR7SXgTyCo2pN8eu0cJU
         6L4WyC6Be7uoWhTvea/5SfzKnmSpnXBkUtxvye9KP0l6LzvbVQhY+rZVNkdueDWEF2bj
         4ZtVT304Vv0zUi9g+xHEJ9IZduoytKcawpErvxixd7YktO0t0Z02bmuTTN5yAiQAnbdW
         PUEhVtqNHxJa0f4FflNrZcX7hxZ2tb3RjHvy5HQfOOyXDi7Me27Xh0k9Z/t/rwPG0NJm
         StKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731967; x=1761336767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q2MJNKUzyfpWZ1q1vEvG9dwdn9W10ieDvSTaPXJMXFQ=;
        b=RKGYFgCAmX9y69awyhy61BzQP81sap6XturhmPT33nlmtCb+shXkwbdumyV7aIovSE
         97D6p5GbwhG2Gcs6j2pvAmbzyFy/dnzCDbsHPaPzeCUg3agSt7XNsVrnAcFYWaitJty2
         1YqD0vMzJCpHmodqZXPkrjHclr0mua1vt1NYzBeFQuJPyCW9YP4eCrqrjuPHZvT5JQlC
         aGO235txuhm6mqhQbl1NGjwDA+nvUugJF7sw6HvkqAY0v9Hd49VzBVmQ1qHBsEe6nwSN
         VFlldTY4umcv3shDZc0zqRsaQRCBaBYyGTNbVd+1XFu22fZ+KF7bqB0G1RDmpFGEESZu
         o96A==
X-Forwarded-Encrypted: i=1; AJvYcCXCuc65Vvgj/OVVi1wo9yKOFnNEy2kHT4neb+AyEob2iHBv1diKe9TzAPQKqY5M/lfz6pZyPc52+w==@kvack.org
X-Gm-Message-State: AOJu0YwoNBSBz9sni1jl6nZ2V5bDFYqvfB+pBnrLetTg/2DTS1XS9YND
	xIVmhAb7hOj7wmrJSQuobXhzMoSLgCbMwUukd+QOR63JYQAJQBQfn+sKMMnYX837NXkHw282Xit
	/r+ALOGSqdmstLd8Mnn5JkHoIRQ==
X-Google-Smtp-Source: AGHT+IFtb+WIe5Ojg24HFTpIMzVd4i2DEaeT3jlneCzRUkfycGPiLZfNyMXO+QnJ48jhgWddsus/04aVcLybN/OzNQ==
X-Received: from plxe8.prod.google.com ([2002:a17:902:ef48:b0:269:ba45:78f9])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f605:b0:26e:62c9:1cc4 with SMTP id d9443c01a7336-290c9c89da2mr55093245ad.4.1760731967098;
 Fri, 17 Oct 2025 13:12:47 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:52 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <5a4dfc265a46959953e6c24730d22584972b1179.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 11/37] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6ACCD1C000C
X-Stat-Signature: 9np38dcdxzgdtnjkpx1x53fgze3gj333
X-HE-Tag: 1760731968-77519
X-HE-Meta: U2FsdGVkX1/9Psj0GEIAZWwcTQWNarviDErjTiX+3/jThAWW8hvUB7eNWmmZ4Talx3K53BnKZrh61c7a4EdZI8bFG/3FULZ601BgFJcIwUpNsqBX4C7QPPyQ0lKagsNjFjiU+68wwlFyph8yFG93DNU/g13Djp1XTgVMpRC3eIHhIiVdBrjmQrBi5B1CA6Kt6vivS7pc2IffSrIl+PPPCm2UR6PFi0k/FcNi3OS585NalH6KuJOosVjMu1aAo+O0TyflGszFNxu2PcDOtgQiaI3DAhP28M4vhuVw1eEiSSHq9kg4kmLE3f6pRhrpiWoJAp8T1wzvXtRudFK27OFTJP9S3q9Cik1FlxkYTMmb19csw3ZhN+9mvtidf38nCEvdlcoMcqiW0+tUMA0UXmAWtyjDr6AoP1HcW3L5s9hvgLl76CMyOyJapxbzz1PeAhnpZ78DNx5Kz7WOgFYNE4dNM4ardI4CwpY2ep2TpRSXNOD0vWb0kTsEMiafh1eU5AHarcGrs7FqYQ9FMrou3iLTdMswzNUssMgZ2JWC7U/1y9Xd43vx1N7yQvgpE1Epu4L+sVqXsvlj4sdh11A0PeBcyQIwlEoacN/iVVMsBVrcJok4zA+ikOxCyg+4WGFwj/USHroQg8dyYo1SDuFNFCBmrelwgY+Ay+SM4ZVjsfZyifEOxpHNDwwj5eWBFZdxbp9gmwV7mRaZWvwm/dAd1uU8CGrqiYyUQGHI5mUwSPNmm2Uep9PRCFyW9GsUg9IExZKfqqnkr4S2ImPo10TH571FAdTSKtGGOoczvF5+iHF4kM+STHSYLvINM0Juf5mSrHyu8NvSd2mUwBfGK1D5OUIwf8atGZHltbzBNdjnsyoIz8aq1gdtmHIP/mDwD1xYTY1Rysww1WtlWG43dQFsleYLxomAjH/SMfg0+CTlv0nYWmvjPxZBOK9nmwyNoZTFy8HTzPkSevmnTPoADP9NXg2
 VFKp7FZI
 ZzYdDiFpp824wuYh1kLg7WKZ/6Zvg3U9m398tfXcRLKhXxF96/rbvJNoS4kMycsGy17jAbESgMvaGW7aTG5MrmFh/YbtDbm4to7Z+LiQRv4a2n+NGAack6KajLYJ99LZybIUp6YG3XMei50J3kzIZvMxt+LqKSS/o0CxJc74WnjH8It43IcVq36Y5hrID03/YDu0dB8pKBkrpJgEhWxeTRiwFuBL7mlWh+kP5uvz7nZgEMK3PGO1Bg7jw4RSKKlWO51z1m0j/tn3TR0I93LCJkAXT3rYeG7MAa6gQz+xb15DzBd+zeM6wwfkkjz2GV8RbpPTSd6TfzsU4pBPRKoMvsRvmRuHvh1SQMcQoJzK0nlUhq66p5yW4imQ8vTnl7BkZp2N+N2N/zhVpzwdyU25ri8bVeuzoxTo9f8OD158xrqphgYt78uEGDqmbnK4EYVoZn2fMfHSbp6yr8asH7pqd7pG9rc0D2RVmoGk3NZbaIlVd4Px+Slo98hE7oXGUtIVvlxYK/daw0dk11wC8yo3xi8iRGh4yOBm8p27xK8imqJpzxjhhO2sY3Dfkg74up55YoPbFauYH1+x144J4ctY2vzEwra0D2v81SegWi/d3zVvBbQ46FgS6JBE75a+w31zqnC5hn4MkiK2gug5bj0d8vhgD6oHcu+6RADAlyktMxrBMhCV9kDSw2FAHbxOpJGsuTPsC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

For private to shared conversions, there are no refcount checks. any
transient refcounts are expected to drop their refcounts soon. The
conversion process will spin waiting for these transient refcounts to
go away.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst |  48 +++++++-
 include/linux/kvm_host.h       |  10 ++
 include/uapi/linux/kvm.h       |   9 +-
 virt/kvm/Kconfig               |   2 +-
 virt/kvm/guest_memfd.c         | 197 ++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c            |  15 +--
 6 files changed, 250 insertions(+), 31 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a812769d79bf6..156ee69fa9067 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -117,7 +117,7 @@ description:
       x86 includes both i386 and x86_64.
 
   Type:
-      system, vm, or vcpu.
+      system, vm, vcpu or guest_memfd.
 
   Parameters:
       what parameters are accepted by the ioctl.
@@ -6518,11 +6518,22 @@ the capability to be present.
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
@@ -6533,15 +6544,42 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
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
-	__u64 reserved[4];
+	/* out */
+	__u64 error_offset;
+	__u64 reserved[3];
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
 
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b48632ee242b3..962055309084c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2515,6 +2515,16 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
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
index c300e38c7c9cd..cdb00866efe49 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -964,6 +964,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
 #define KVM_CAP_MEMORY_ATTRIBUTES2 245
+#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 246
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1622,11 +1623,15 @@ struct kvm_pre_fault_memory {
 #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd6, struct kvm_memory_attributes2)
 
 struct kvm_memory_attributes2 {
-	__u64 address;
+	union {
+		__u64 address;
+		__u64 offset;
+	};
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[4];
+	__u64 error_offset;
+	__u64 reserved[3];
 };
 
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 395996977fe5a..b3473aec4d24d 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -117,7 +117,7 @@ config KVM_VM_MEMORY_ATTRIBUTES
        bool
 
 config KVM_GUEST_MEMFD
-       depends on KVM_GENERIC_MMU_NOTIFIER
+       select KVM_MEMORY_ATTRIBUTES
        select XARRAY_MULTI
        bool
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index dab2b3ce78bc8..5ec38e9395d22 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -73,6 +73,21 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
 	return !kvm_gmem_is_private_mem(inode, index);
 }
 
+static bool kvm_gmem_range_has_attributes(struct maple_tree *mt,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	mt_for_each(mt, entry, index, end) {
+		if (xa_to_value(entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -219,10 +234,12 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
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
@@ -583,11 +600,172 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_memory_attributes);
 
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
+	mas_set_range(mas, start - 1, start - 1);
+	entry = mas_find(mas, start - 1);
+	if (entry && xa_to_value(entry) == attributes)
+		start = mas->index;
+
+	mas_set_range(mas, start, last);
+	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
+}
+
+static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
+				     size_t nr_pages, uint64_t attrs,
+				     pgoff_t *err_index)
+{
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
+	if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs))
+		goto done;
+
+	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
+	if (r) {
+		*err_index = start;
+		goto out;
+	}
+
+	unmap_mapping_pages(mapping, start, nr_pages, false);
+
+	if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages, err_index)) {
+		mas_destroy(&mas);
+		r = -EAGAIN;
+		goto out;
+	}
+
+	kvm_gmem_invalidate_begin(inode, start, end);
+
+	mas_store_prealloc(&mas, xa_mk_value(attrs));
+
+	kvm_gmem_invalidate_end(inode, start, end);
+done:
+	r = 0;
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
+	int r;
+
+	if (copy_from_user(&attrs, argp, sizeof(attrs)))
+		return -EFAULT;
+
+	if (attrs.flags)
+		return -EINVAL;
+	if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
+		return -EINVAL;
+	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
+		return -EINVAL;
+	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.offset))
+		return -EINVAL;
+
+	if (attrs.offset > inode->i_size ||
+	    attrs.offset + attrs.size > inode->i_size)
+		return -EINVAL;
+
+	nr_pages = attrs.size >> PAGE_SHIFT;
+	index = attrs.offset >> PAGE_SHIFT;
+	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
+				      &err_index);
+	if (r) {
+		attrs.error_offset = err_index << PAGE_SHIFT;
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
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
+	.unlocked_ioctl	= kvm_gmem_ioctl,
 };
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
@@ -943,20 +1121,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
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
-		if (xa_to_value(entry) != attributes)
-			return false;
-	}
-
-	return true;
+	return kvm_gmem_range_has_attributes(&gi->attributes, index, nr_pages,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dd84b377e46db..3506a2f2be041 100644
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
@@ -4971,6 +4961,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
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
2.51.0.858.gf9c4a03a3a-goog


