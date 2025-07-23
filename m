Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D64C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070588E0017; Wed, 23 Jul 2025 06:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046878E0001; Wed, 23 Jul 2025 06:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D674D8E0017; Wed, 23 Jul 2025 06:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC2198E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CDF81131AA
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:39 +0000 (UTC)
X-FDA: 83695203438.13.BF47762
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id E3C2DC0003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=w+jLcX3v;
	spf=pass (imf22.hostedemail.com: domain of 3yL2AaAUKCJEEvwwv19916z.x97638FI-775Gvx5.9C1@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yL2AaAUKCJEEvwwv19916z.x97638FI-775Gvx5.9C1@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJPhpUUyhefgcIbSkuwiw95QjSbqiQA9zLACcCZ8gX0=;
	b=58QS0S6o+4zBA76lnEyHPA6HivYvi61wHlI3lwky6846rxAy6pzL5Fr/vOKriUKUcVkgtb
	BM/4MMZdd4fjgGjL519d3+NXbyM0iZjrGoaPTAjxbyV17A8ANzuGSGsBvO7f3n7IrPXV8y
	JfVd+p1bnmPonKt5doXn1+uz5ihgWts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267658; a=rsa-sha256;
	cv=none;
	b=64/Rq070/qKy+TT+Hkj90O/cLkXss9hVdavNThU7Dvp075ddLwoPsmhevKZ9abnSWtlk4q
	nEa8jyWUd1dMzs67IVmmBTCVxluPZ9/AOgCwdfbGCbHuLQZm9iOAKst0CCziPjI/LKsYbG
	KO/WX5aOrPSf5/+RZFO6eC+GvfQHFYE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=w+jLcX3v;
	spf=pass (imf22.hostedemail.com: domain of 3yL2AaAUKCJEEvwwv19916z.x97638FI-775Gvx5.9C1@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yL2AaAUKCJEEvwwv19916z.x97638FI-775Gvx5.9C1@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-456175dba68so51687475e9.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267656; x=1753872456; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bJPhpUUyhefgcIbSkuwiw95QjSbqiQA9zLACcCZ8gX0=;
        b=w+jLcX3vdaPBijnYCpsr78EYGzMDWp1FxD//Rkqgomjyk+q10xCjHAu5+UpgJwoEXJ
         QBKyMOxH1ql9dDMbuNDg/QnaKQvdkAqkOS5ZTQIEgyHpgvhEbvMifDcrNgy+IfFDX95V
         iWjX8cjr+HPprWNMBvLO97Aw1oxDSvAH6X/nSYXXGCP/rEXSJHysGE+iScmJuUMKc+6w
         WnqxDyDIYJAierNFmWCbN0kva/iRqqJXCeNT8ck+xR0R1jpVJko3xt5ipuCOoerGnoHR
         GsfytP4y7Yic6nD0+4sac7StVrHjtTnmKbWdSMsrZp6jlx+58JvhYpS0Iok6ejyb3zqN
         h49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267656; x=1753872456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJPhpUUyhefgcIbSkuwiw95QjSbqiQA9zLACcCZ8gX0=;
        b=slxL/EXzHeoK4ywiJbqzR5NonMRPLR+WSGH7+74229L3tkLg23xEvoHc+/5InP7Pwv
         pxWaNutpZ/8aDSdMqb4wi4jsSBZUYsQiA9i6v8z8HQl0N7BoKE9bhODkSppYk7lZ1CJu
         NYU1jXScflXIvnkMFlUhP6EjI3TEn8zOQRoLj36j0ypg479o5qoPoaZ3JLTKs6K4Wb0N
         wvrsJhEfFjQbTFPWMJCJiWqQ6JLJOYWGRWSZ1Cvt+ir6SMPk0UOIY+NyNOUtUitwUVRV
         uKFsWuliErdAxmDTZaVrgQrz/NWf3JlTUhCoV+v4Z3CPTUESvz33aFEEjpbZnG8xNRks
         3y/g==
X-Forwarded-Encrypted: i=1; AJvYcCUTscPGjvOrVC3a+7EbITzSgczJbvpEmznByS5883IslYBTEeCf1f4wv2Yx9ySv6zf9z4tglzu+cA==@kvack.org
X-Gm-Message-State: AOJu0YxAnF84c0MJJcLae8jpoEwvpOWsiiy9hOdVcgiUTR0XIXx6ouJW
	BMnxfrmWD+d0GmYmLHElyuidbpdNtNh/PpngFHROpGD5dE/tXDhs8/MJBVACy9Y/7LvEqzwBv67
	tGg==
X-Google-Smtp-Source: AGHT+IFg4amFUMT8SnQXmGfSL7jQcBmHONqp6DdPspIYde7f6m4gxAAek8vnyOnJeKOMl4Q0IeoumHUzug==
X-Received: from wmth16.prod.google.com ([2002:a05:600c:8b70:b0:455:e7b2:5b41])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:358f:b0:456:43d:1198
 with SMTP id 5b1f17b1804b1-45868d4dbf7mr19148065e9.32.1753267656601; Wed, 23
 Jul 2025 03:47:36 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:12 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-21-tabba@google.com>
Subject: [PATCH v16 20/22] KVM: Allow and advertise support for host mmap() on
 guest_memfd files
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
X-Rspamd-Queue-Id: E3C2DC0003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 6kftigpd5hp9dydbe7hac5b6astqehgf
X-HE-Tag: 1753267657-114519
X-HE-Meta: U2FsdGVkX19xrMX/eAkDj8u/JyV4muIVw1W9QgW/jiokds7cCg0GuamHla0a7YzDNHANcczg7KiH1wuXT5CAzT5ofEfM5BTnZ9YYhTEZ4jjXPzzfcZkikGq4FbPgQCokzR9WqcinEhenVlKpicjOcYdSol2XJZEWP1Awbckkr9OcMByJ3/fVaY6AJXESJqR0NLZdDsPZK8YjZ4fsrIXKRamSDZaeC9Vx8s50xBtpKZGCCYpPCaVFQpNGYd58OBRKEPlArMLOkvGSdxcrFywAYvz5fOaMItYyoF3j4MN7AnVVPyccitetNxidLAMtc9tKskl+w/tpg6roUyyjVBDzAmiAfqO3KFkBZeLIeyqWBZ1ucL/fHjbGizSRTul/fY7wnK91tELqtq3Il8eRWiqta/Fcpeieu/pXfDPHf1bi9LXxot8Cz4oiHhIufnB8aCquU14ZPVZJK4URyKSewoUOSywgHnWdJ/DDmvU0adDOg7iQqG5Qb3UyUAOFxU9g/UmD2t/jhg4/T1oAt1o5Cu0U1A/i7vEbgDujfLzGZYJ109X/5/7gr+z6cH0+brOLAkpBthrWYJaxqt/H1ydceZZ3WxGJbcPXD32lfuDjYCWwvoldw14I3l5B3tAdgA0E78ACJOB/4dz5oqOZirfnd9CYtClDbnuf3Tu9toJwUeFj53iIFTvndkz3uObuh/o75J8WQ/q6c/yZL7VxXoxhI1JIylInN7rpE5RdEqASjUGA439nhXiBc2SXBABaRu3mBrHvlSTeaszepHjEqhWnYKOHl51Vp/BhDvTg4XBYDnpk+xPL3Q5PXXEDyjNWe5QxmqcVf7NKjWZ2dfLuV7unPfwOiVfiI0Tp6znppIfWiBdTK+JV16htMTbK2jHfx0YJf6C7KZpOAGd6aIWvhRnsZSZPytkBIe0Mlh17VBBHkETZ1Gbc2iZv+n5IpGelG4ab7J4HGaDpg+JibW9DlcojX09
 w9ZyHbHD
 AqYs49HE6cj4ij1e2MgM7cYWLBRe24IvpuRkC/G7aBku8Lud3UTBLwWUVSfPCkBeQ4uq12ka7jF/apOqwXdRBm9Q8EJ8PpeODtRhlYWNHC2KHwqgl+Ij41XC1rPbFnzLhcD30Ht79Oz+G30WR1FklJSeYtn1IBIISCSNPAojlK3/JYsagNiPFB3/Lb6BE38IdeSdC/tyrbzE6lLOYx5Qd1EScsRmCnIsqT3zIk4yzoZfh3DMfhk89cDw5IEzkvEfLLOBRxc0/DSvuKizNbhkYs+Ro4hGnsPlZ6xwmYfmZoIZ6lLa+26+rTIzqK/3Ebkaq3N9jorJ5vXIa3AM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all the x86 and arm64 plumbing for mmap() on guest_memfd is in
place, allow userspace to set GUEST_MEMFD_FLAG_MMAP and advertise support
via a new capability, KVM_CAP_GUEST_MEMFD_MMAP.

The availability of this capability is determined per architecture, and
its enablement for a specific guest_memfd instance is controlled by the
GUEST_MEMFD_FLAG_MMAP flag at creation time.

Update the KVM API documentation to detail the KVM_CAP_GUEST_MEMFD_MMAP
capability, the associated GUEST_MEMFD_FLAG_MMAP, and provide essential
information regarding support for mmap in guest_memfd.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst | 9 +++++++++
 include/uapi/linux/kvm.h       | 2 ++
 virt/kvm/guest_memfd.c         | 7 ++++++-
 virt/kvm/kvm_main.c            | 2 ++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f8cb0b18b6be..95a0697ec34d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6414,6 +6414,15 @@ most one mapping per page, i.e. binding multiple memory regions to a single
 guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
+When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
+supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
+enables mmap() and faulting of guest_memfd memory to host userspace.
+
+When the KVM MMU performs a PFN lookup to service a guest fault and the backing
+guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
+consumed from guest_memfd, regardless of whether it is a shared or a private
+fault.
+
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index aeb2ca10b190..0d96d2ae6e5d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -961,6 +961,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_GUEST_MEMFD_MMAP 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1597,6 +1598,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_MMAP	(1ULL << 0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d5b445548af4..08a6bc7d25b6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -314,7 +314,9 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 
 static bool kvm_gmem_supports_mmap(struct inode *inode)
 {
-	return false;
+	const u64 flags = (u64)inode->i_private;
+
+	return flags & GUEST_MEMFD_FLAG_MMAP;
 }
 
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
@@ -522,6 +524,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (kvm_arch_supports_gmem_mmap(kvm))
+		valid_flags |= GUEST_MEMFD_FLAG_MMAP;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4f57cb92e109..18f29ef93543 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4918,6 +4918,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:
 		return 1;
+	case KVM_CAP_GUEST_MEMFD_MMAP:
+		return !kvm || kvm_arch_supports_gmem_mmap(kvm);
 #endif
 	default:
 		break;
-- 
2.50.1.470.g6ba607880d-goog


