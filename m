Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED93CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218668E002E; Fri, 17 Oct 2025 16:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7428E0006; Fri, 17 Oct 2025 16:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC31D8E002E; Fri, 17 Oct 2025 16:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0B758E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8626F140263
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:43 +0000 (UTC)
X-FDA: 84008704206.12.7DFC7AD
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id BA2CC16000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0qG+2toN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3OKPyaAsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3OKPyaAsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MDtSfe5nln5u8FC0aMBs1MU/8Rk9O8Bt5que00tflY=;
	b=Y0jRfq+bLP7Ub2L+t8O6NKUsdNrs3bqLRELc8dqsgD3JGjS3IenFZaYwZBqnx0p8r64/eD
	mTcvNAPA1ObEUX3mQAOlQgCQjjQmbzcAuk3oPugLY6EYvq1Y5Tb2IxxHPYNo86QzcjQQRI
	Nh31avD36rLU0rhsyoHihCaB+w8gkS8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731961; a=rsa-sha256;
	cv=none;
	b=jh4JFh+A9znnWlSHjnz3kx2nhGgFN4uMbVJ/lxOHQwLBiAWEfiM9SZrHIxhsHIKKit5rUo
	5T9aAjqipPR/YCEPk/6t+T1t3EZXWg2+TS7rY7By5MIKNIuTXBV3zlOf99m7NgguM6J4UY
	CaVn6T8syXahpddCFaSXALOj0VPl/ng=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0qG+2toN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3OKPyaAsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3OKPyaAsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee157b9c9so1961249a91.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731961; x=1761336761; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0MDtSfe5nln5u8FC0aMBs1MU/8Rk9O8Bt5que00tflY=;
        b=0qG+2toNph3Mb3WkEVjz81OW2k3HAXrueSWI1zg+ZS9GodosZNnrgx6DM29xCzcLkf
         YUvU1JJ6AzcG9aeSUTK2vxh2S6MmZELWS7j8DebcLwmyhGwoa/E2Nv1S5jxppQRTMOI6
         8IGqXGfDdh9bjVTAeUMOLPpMeRSAaiU2e6v4L4yokyw4nzRwulhSoppUR+xe9Ztixqr1
         9JcDQ2TWsy8fCxOoedFAnSNc3N8g21e+qRN+wUeQF5vRfwnwETadbCMAx0W+orWDN2BE
         SvO6ux0TlyPAVbW4UkkPwlbpP4ahsQMpmfUHb36EttEfy0knjsCu15qSaFetphbLxLVD
         zCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731961; x=1761336761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0MDtSfe5nln5u8FC0aMBs1MU/8Rk9O8Bt5que00tflY=;
        b=mLz/SJQBp90tDEuZXCIHSvtaoB9S+1KKBKw3Mk3R4dLHSbx2L+8R0uCXg1nhi2leMU
         F7Dhbz4v+4otd/y4sxfArhB3weKQy9FfDqPzylW76vzhRRa05vBhj3PoZggHL1ciFLJ1
         VnajitL9H8JpqJV45f6m9E1V4fHA34fcEyG51z/Qn3m2AD+NyWCNGdcvEzlwuAPWs2pa
         GkAiQrOAIXZV7rMH4ysDK/FM1DiZ6aHP3+jQxriRphPNvp7WSTdUuIE9ccP6OqnzHoQJ
         TrdNU41OicZF6OEfHYr1iNcwtxOmWv8/BjaSijs49AbvmDteGHhlyTr0doRGG8uh3Zyv
         BlkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmbUV86ZyQGebemf5uzPtPl/nKZBDePdq+0YS8VRPGNgQ7ZoIGH8fw/GpgPsMZwQ3VMTN5iN/hvw==@kvack.org
X-Gm-Message-State: AOJu0YwcdQNbS8xv5GZ7qdAcqP4QmR0ne1Ug6T4kYLnws86lkNgRfXbE
	T4y14CvXWhN32WjTqE0yxasl5Qb02lRrVdnzs5hgdhf7LBBpgTld0v6rvE4l7ZuuPnjK5OFl/ax
	LJ0EiRRAmmWdGQV15/1xefvCCAw==
X-Google-Smtp-Source: AGHT+IEYshsuE8FxW35uelOE0C5Ch6ZMZdsl6Nijf9n+mUUmWCNCcwQSxH8wyzRqvi20yqwXxi+lF7cWMtIb7g40WA==
X-Received: from pjbpt2.prod.google.com ([2002:a17:90b:3d02:b0:329:e84e:1c50])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d87:b0:339:d227:82fb with SMTP id 98e67ed59e1d1-33bcf8fa579mr6458510a91.26.1760731960501;
 Fri, 17 Oct 2025 13:12:40 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:48 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
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
X-Rspamd-Queue-Id: BA2CC16000A
X-Rspamd-Server: rspam02
X-Stat-Signature: hutzp7dbdppbyekazw6ianxr8p6wz3oh
X-HE-Tag: 1760731961-282057
X-HE-Meta: U2FsdGVkX18BZfTWj5nYSFfwUlp+cu+qAkr8JGoDTyYFDiJmq4PVfHUkd92NTxKwdO+cM+6vwV+6GlCuiNw5ndUYEXId+82GdUpQmvDuf6kkBpnjfj9yiI8ilbNG1L9yppGDkZiPQwieY3ScYiiqow9YRoJ94u5U6ufTgAGrYaUovs+/+yw34sFhDEkZdfzBGBChB+aPP0rY1Jee4Oh1Ws5lzAbVXMUW0yVCJqvwmBObks2fu4U11q8lL9+ete7lK8SlJKOdV9MsDG+ZWgGiZlxj0IWwnnF7d0LJCIamEW0ZEjpRNngJsj2MmJPK4Dq3243+fR+E+6ltiPRbXE1kAmFZFRbHtKnBGhY7ZjT5Vtpv7I3B04wgI1FMa3GjtqbjXsR7uM7XgD//ZITYcjRuJoLLHpTdo/L1CRPGiYb6k7jrbtPIV6nSeMwTFdNTlKUua3rYcxiC42uUk+zmYiDnQYwi9pzHJefu2cRODhTWT87yqebpyUesavDBTgFsljAYQj/FKc5KovPV2gbIqqbXsMxDIkPYK7XQwcdu4A6w3Wkftbuz61GGos0ztxWDqPjBO0nOWdMbU7BPrQpbPD8wfyX+6npPoqEfXLGkspnyjLGup4ONdDH3NPVcHQ/kkWqpT8EUZVRrWclwJhntOwv7JMWtmiwvDQ6Jo4KjutT16phyGaKwg3UI19e4amdNkXpzbBH+O1APbBAn4TTAjkzMxBzCVa+hURHsRmFJIRt/1bnic3WhLUh0Y+HUmhtnVY1XuIU0cWebn1YxIk0DX37o3dbHZdHnce17+TyqMQoZQ0Nlb07NKtmcCRwsCUUJrsqUH5sRtsDx6B1CIvc1qcfIsnYO51+48iyxnSpKOxWHJAvFCClykBefy+6GqoR5V2VzacFS6y65LGiJIipcTahGyrOSltzUn0/7G6lCqXtxyIVCYsyFHhCKUJ/T0x1tX1ItAa6KQCLsmkjW9PCgIOo
 Lbn2S0Oc
 wbFBqh7TiUNPH/64FMdEfq8p1xQkkA5blTfqmIwSgZYrOU34IpyqatEHLWDs+N4Qa4A1Kk+mo61K0tCrOyDIKAdsZaVCfJL0FqqyoCl8LUcZH0ftgtLKLXp+4x1CfzXnxaV8e3xRhjZAxuF5Y24wIB6bmtzpBzOIuFl25PHKZgetMpsMmB4uFcT+6AToZ2VYTf2pOKC0naYs00evxyuxr2/JMlg1KhDONeG5GXRrAUdNtH4EDy0Ry00yRj6HPo/i33NMUE5DHkWbBHNlf8bjOsTuarMkFhSrDN5GUCqNyRg3NzRMoSJuBW2CFLu2A4YQNKTbHintt1OZm4sV7NFTowIVhJvKopNrynHdnLPXj8MGv5xT84LfaYww4H/4J6K5J9F9mdMDqZr52cy6Cv/BIqTaAbz+ig0bhq6Q29yLV28w6w7ch2NOyehU6IF4UQsbhjac5dEVQkV0EwWApNwy1sDH5WC3FQSyOuSlUyI1Nwp7T+ROt+RID8D3NYEUVerjOyAaNI1Bar+Myp691okNSlzxMugJ7ZU3+Kw1q3PcL/s62DaIlupKzQxR27zgBNtmMwdfVXScEG7dpOZL355Mg6gU9DKEI0m1fQCmQZWGVmOGRtqFRDxX3JlMTJ7oYKeKKd0mUgClevAtA7G1zd6Q05RTRvWxrm+8Cuj6aD9OdkTpMkRc0AEu705Ma4UxTDdmtkrLM9jJdCmt7RXU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a "version 2" of KVM_SET_MEMORY_ATTRIBUTES to support returning
information back to userspace.

This new ioctl and structure will, in a later patch, be shared as a
guest_memfd ioctl, where the padding in the new kvm_memory_attributes2
structure will be for writing the response from the guest_memfd ioctl to
userspace.

A new ioctl is necessary for these reasons:

1. KVM_SET_MEMORY_ATTRIBUTES is currently a write-only ioctl and does not
   allow userspace to read fields. There's nothing in code (yet?) that
   validates this, but using _IOWR for consistency would be prudent.

2. KVM_SET_MEMORY_ATTRIBUTES, when used as a guest_memfd ioctl, will need
   an additional field to provide userspace with more error details.

Alternatively, a completely new ioctl could be defined, unrelated to
KVM_SET_MEMORY_ATTRIBUTES, but using the same ioctl number and struct for
the vm and guest_memfd ioctls streamlines the interface for userspace. In
addition, any memory attributes, implemented on the vm or guest_memfd
ioctl, can be easily shared with the other.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 32 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 12 ++++++++++++
 virt/kvm/kvm_main.c            | 35 +++++++++++++++++++++++++++++++---
 3 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 754b662a453c3..a812769d79bf6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6355,6 +6355,8 @@ S390:
 Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
 Returns -EINVAL if called on a protected VM.
 
+.. _KVM_SET_MEMORY_ATTRIBUTES:
+
 4.141 KVM_SET_MEMORY_ATTRIBUTES
 -------------------------------
 
@@ -6512,6 +6514,36 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_SET_MEMORY_ATTRIBUTES2
+---------------------------------
+
+:Capability: KVM_CAP_MEMORY_ATTRIBUTES2
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_memory_attributes2 (in/out)
+:Returns: 0 on success, <0 on error
+
+KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
+KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
+userspace.  The original (pre-extension) fields are shared with
+KVM_SET_MEMORY_ATTRIBUTES identically.
+
+Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
+
+::
+
+  struct kvm_memory_attributes2 {
+	__u64 address;
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+	__u64 reserved[4];
+  };
+
+  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
+
+See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
+
 
 .. _kvm_run:
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab0208..c300e38c7c9cd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -963,6 +963,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_MEMORY_ATTRIBUTES2 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1617,4 +1618,15 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+/* Available with KVM_CAP_MEMORY_ATTRIBUTES2 */
+#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd6, struct kvm_memory_attributes2)
+
+struct kvm_memory_attributes2 {
+	__u64 address;
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+	__u64 reserved[4];
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 35166754a22b4..dd84b377e46db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2621,7 +2621,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	return r;
 }
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
-					   struct kvm_memory_attributes *attrs)
+					   struct kvm_memory_attributes2 *attrs)
 {
 	gfn_t start, end;
 
@@ -4959,6 +4959,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_DEVICE_CTRL:
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+	case KVM_CAP_MEMORY_ATTRIBUTES2:
 	case KVM_CAP_MEMORY_ATTRIBUTES:
 		if (!vm_memory_attributes)
 			return 0;
@@ -5184,6 +5185,14 @@ do {										\
 		     sizeof_field(struct kvm_userspace_memory_region2, field));	\
 } while (0)
 
+#define SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(field)					\
+do {										\
+	BUILD_BUG_ON(offsetof(struct kvm_set_memory_attributes, field) !=		\
+		     offsetof(struct kvm_set_memory_attributes2, field));	\
+	BUILD_BUG_ON(sizeof_field(struct kvm_set_memory_attributes, field) !=		\
+		     sizeof_field(struct kvm_set_memory_attributes2, field));	\
+} while (0)
+
 static long kvm_vm_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -5366,15 +5375,35 @@ static long kvm_vm_ioctl(struct file *filp,
 	}
 #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+	case KVM_SET_MEMORY_ATTRIBUTES2:
 	case KVM_SET_MEMORY_ATTRIBUTES: {
-		struct kvm_memory_attributes attrs;
+		struct kvm_memory_attributes2 attrs;
+		unsigned long size;
+
+		if (ioctl == KVM_SET_MEMORY_ATTRIBUTES) {
+			/*
+			 * Fields beyond struct kvm_userspace_memory_region shouldn't be
+			 * accessed, but avoid leaking kernel memory in case of a bug.
+			 */
+			memset(&mem, 0, sizeof(mem));
+			size = sizeof(struct kvm_set_memory_attributes);
+		} else {
+			size = sizeof(struct kvm_set_memory_attributes2);
+		}
+
+		/* Ensure the common parts of the two structs are identical. */
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(slot);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(flags);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(guest_phys_addr);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(memory_size);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(userspace_addr);
 
 		r = -ENOTTY;
 		if (!vm_memory_attributes)
 			goto out;
 
 		r = -EFAULT;
-		if (copy_from_user(&attrs, argp, sizeof(attrs)))
+		if (copy_from_user(&attrs, argp, size))
 			goto out;
 
 		r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
-- 
2.51.0.858.gf9c4a03a3a-goog


