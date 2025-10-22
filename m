Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C87DCCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 22:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FAED8E0003; Wed, 22 Oct 2025 18:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384958E0002; Wed, 22 Oct 2025 18:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C4F8E0003; Wed, 22 Oct 2025 18:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11F178E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:45:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A415E1A096B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 22:45:32 +0000 (UTC)
X-FDA: 84027233304.03.6805A82
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf24.hostedemail.com (Postfix) with ESMTP id 015A5180009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 22:45:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="r/6ODfvP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3iV75aAsKCHoYaicpjcwrleemmejc.amkjglsv-kkitYai.mpe@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3iV75aAsKCHoYaicpjcwrleemmejc.amkjglsv-kkitYai.mpe@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761173131; a=rsa-sha256;
	cv=none;
	b=iCXmbGTgM14JguPHzfqCInpbjPwEu8QQ8ZKUfeKfo4plhxBQVRsKa4aYI9O7mOMh3MH0VN
	IGvBOQQIorM83LNL6v+A4r+lfEGRU/Fe8fZBMGa2Jspm+UJKPwSq+ClUPCzR5ocjnwFW/V
	0Tem5JuUeII0ClY3X0lYxZ4ZqVXhq3A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="r/6ODfvP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3iV75aAsKCHoYaicpjcwrleemmejc.amkjglsv-kkitYai.mpe@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3iV75aAsKCHoYaicpjcwrleemmejc.amkjglsv-kkitYai.mpe@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761173131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGF3nY+bQhEuJksVeN/ApJVbDNkeBuYq31H02jFVpBo=;
	b=20l46uV1rDFhb0ItdfQThgdKV/YRjxHbNq17jui8A3lONsUEsYQp8DJqWeM+iYCCjribX0
	LsT1BwDe2ovGL72aZAy/fnw+VpwTl9SjgfHwcAJsUHDjPThvfxJbFCJSeIliW7AD6IP+Ky
	jt+mkuoL386NewbfyX3r/oI1SXhXdn8=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-277f0ea6fbaso1428815ad.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761173130; x=1761777930; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gGF3nY+bQhEuJksVeN/ApJVbDNkeBuYq31H02jFVpBo=;
        b=r/6ODfvPYnGlsqGRvBgc/03Mlk0Xb3GtJlr2oViTtAsPlPSxxg+Bau0y9EWPau38iq
         1VpTpZfdtvE5WaK9Jj+YggUEVb4JFKeT7iNttmfD+n/SUn6qnCfJ/tXqQv/9s20oliMO
         9Bhuw9/P3VqVIzeCbeBispTm0d0lJZb3bVAUxDkxsb6y9Z2EbXNnSJ6jXq7r98rO9eoo
         4v4lJhutmP6u/0/ehkeRwqj5QSsHd/weBx8FfaTRIvdusUumh+mMoTo2hzCes5c5MCOO
         goti/a4FC0WNq/lKWX8RDMH60pytq/8+c87/AkQN6dtAqPqns5Oj9SpNPLuYS1XmNk1p
         YONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761173130; x=1761777930;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gGF3nY+bQhEuJksVeN/ApJVbDNkeBuYq31H02jFVpBo=;
        b=E88TaxbSUN4Iymnym7pN0ld9VrRBZuHKqL4KaKiRtdvrIFSSOgMSB5ktUxftzMvpc9
         XQX4z5uVXxoZ66osm9ecOlDwRMU7jb8f8W2TfM+Wz0AHY3wMYEJoSjFich++eIIpAAFM
         OkP33v+U5Fsp9vc5vCRzsRmT/8SJQyTYZSZXyxUXPcr5VUSJsF6J41jYHxR0I1e2YRSV
         ji2GoACo6plg6FvcOzm9/PVQ0tsaS2WVR6R79SA6PIBTBLa04OKl46vll8E6y9SxPpZV
         SRJE2Fk7oRJnlXf7y1ND5H7ueKvoqwtTq8ASyeqD8zV0wBtdFoDhuLwcExAIG/D2MgHN
         wA8g==
X-Forwarded-Encrypted: i=1; AJvYcCW0XCfd8EzPmrcF4hi2pI3TDduqtk7amqAhNFdZlAzYszZWpya1fEIJDtTGzAJ8p0fiqkQM2x3OMQ==@kvack.org
X-Gm-Message-State: AOJu0YyUh9BYAaWWo6OE9fRYMFxy3lMut9BNVG91T+UH9CEUtRpPcQm0
	Xar53TPeiNC3xzxFV0lWAw+KJzMs6ndmO7vCBIJc+8mt1B7Qw1240VBUJBGYIUY5qiAhqIvCVY1
	24LN27pHK9fTkXg1xtDDjb8tdDA==
X-Google-Smtp-Source: AGHT+IHD5TZ3PlH4BoXojkeR7Hq6pa25rPFAC44tSG4hp0SVSWugJiynOfGyj0/LVdH6RcIi4tLRlKxt4/SfCTBJBg==
X-Received: from pjbfv10.prod.google.com ([2002:a17:90b:e8a:b0:33b:ab61:4f71])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f70b:b0:283:c950:a76f with SMTP id d9443c01a7336-290cc2f91d2mr289431935ad.43.1761173129640;
 Wed, 22 Oct 2025 15:45:29 -0700 (PDT)
Date: Wed, 22 Oct 2025 15:45:28 -0700
In-Reply-To: <diqz4irqg9qy.fsf@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com>
Message-ID: <diqzy0p2eet3.fsf@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: Steven Price <steven.price@arm.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, liam.merwick@oracle.com, 
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
	shakeel.butt@linux.dev, shuah@kernel.org, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 015A5180009
X-Stat-Signature: z6seqbrb7yfo3woh1dckzcp1ugom1ssh
X-HE-Tag: 1761173130-403709
X-HE-Meta: U2FsdGVkX186m6bZJkMys/wiiXhQFLtNTAkupaHQA0L31zWZbYC5RVOUzAr752Chn9kz+1HopFcz7xTc2wDygmBEVzHFUIQRXMIJ3r6fsE1daJqp12SssJA+eIY54GwKF3d5LEO3rBcVdfhqEGemK0H9ULh2JWE+b3MejODef5b8D0OmQV1QIt9iIbCm07Mcmht7jQ3WRmj/ban+Gd6p/PVDf2PB5L26VRj2s/fH3GtvuCr4P4qXcddUr+uMwpYLembn5Knsowy1zmJcx+f0guXnZ7PhkyqYszvZvCEWlSaag6z5e6IYN76eeq91Q4jW0u0LmXAHPdmaeRNqmptZoZmhCQvodqvFfA/9nLusyHzJLi/XiYqQp4eafPFlDzpv5R9GELqFvIrGbwpip5U2YcFcxb29XD476ogaBunlPdLzLFfyVViOM+M89LXXPfOfH6dB5WIm5pXBwk1Tn2WJPovDSbYNPz3R32DXbrxHpePkg/lAvsFvvp3mdmVgPB4gL5kD3Cpuz8V1m8PBnRTzhJJ7JkXAQ3nRqdg/L/cb9aI+V0gzMxKpa5ynOS47Jo2iDdx08ZXxO3XWfPFE4+fx0di27vbYK38jzIAWa0fWZuYiw/hbmNlv25GH+eA/DciP2CFX2ufb3vu3noGo7ppnFh08o8zwQRQJgBTSqlWEKnUk5mJf7XUAKn0axUHXxwSVMGr6PtIPXWBwUOpm+9LbdqrR+wjwGm4omzYtCbAfWqI1IfZrkd++8HOFa76/WkDUiPwg3JJzyKSBPEBRx1QrOnp+ulIsfjVy5k2xJk7q8xIoc1ksvxwXnXfqnqJRykQQkOIMB/q/GMQjveXkSDs4TPx0Iw2UIWVoVcSAoRpbBqTEVjvkITWwRxZfTWUo8ZgNbXSBnDmroirRevOftmhfLkPvD1WO9hzKllYTjoi3u11pwFQ88Ii+zV6/FFUFvfubxq9Bdhnu0RsGZfRHYFf
 vloAo5bZ
 fQiCWoBz1+rzDP4PAvMvOjPuSZZrV05D0f+XIH7CV85rYIl0zEuM+a1Dp6PRmfRQnYE9b0yMxR6kHYHoIZrab9Qp3BVj1jh4B8Eo97SuW4nj3Dx0WcpBXelaBQ5CAbq9td3uEat7Js2oVUimGagsL4C0Kx7TGHa1pXCJpP34JXfo23D3EZD/57Rvne7Ev52ZtW3mJO0tAAlXuiiT6oKEVynsbw1NCQBxbtjxzPpx4ywDJXNbT5fCCbxtdtTvjTC0mYS5vmtX+q42oTTP2YIi/v8wb4EKxyKCeNcrDJHe/JS9uRoSRldaHzCuwE0Jw9Xvi4mpPVPzLwk8CLpR5qIUsMBixC5kRZzhqP79D01NvWmSsAapIpTBABB5Kk0AX6SapQ+V+p/m3hu9AgTY+hzfOuTtE4fjJw3p1aYsYu7MwOIB/6dJ/8Ic+QHYLDbGQBoeNwnb4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

Found another issue with KVM_CAP_MEMORY_ATTRIBUTES2.

KVM_CAP_MEMORY_ATTRIBUTES2 was defined to do the same thing as
KVM_CAP_MEMORY_ATTRIBUTES, but that's wrong since
KVM_CAP_MEMORY_ATTRIBUTES2 should indicate the presence of
KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2.

Usage is kind of weird and I hope to get feedback on this as
well.

This describes the difference between the previous version of this patch
and the one attached below.

I also added this to the changelog

  Add KVM_CAP_MEMORY_ATTRIBUTES2 to indicate that struct
  kvm_memory_attributes2 exists and can be used either with
  KVM_SET_MEMORY_ATTRIBUTES2 via the vm or guest_memfd ioctl.

  Since KVM_SET_MEMORY_ATTRIBUTES2 is not limited to be used only with the vm
  ioctl, return 1 for KVM_CAP_MEMORY_ATTRIBUTES2 as long as struct
  kvm_memory_attributes2 and KVM_SET_MEMORY_ATTRIBUTES2 can be
  used. KVM_CAP_MEMORY_ATTRIBUTES must still be used to actually get valid
  attributes.

  Handle KVM_CAP_MEMORY_ATTRIBUTES2 and return 1 regardless of
  CONFIG_KVM_VM_MEMORY_ATTRIBUTES, since KVM_SET_MEMORY_ATTRIBUTES2 is not
  limited to a vm ioctl and can also be used with the guest_memfd ioctl.


Here's the entire patch so hopefully it's easy to swap out this entire
patch over the original one.



From 8887ba58f6fd97c529c8152d6f18e5e26651dbec Mon Sep 17 00:00:00 2001
From: Ackerley Tng <ackerleytng@google.com>
Date: Thu, 16 Oct 2025 11:48:01 -0700
Subject: [PATCH] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2

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

Add KVM_CAP_MEMORY_ATTRIBUTES2 to indicate that struct
kvm_memory_attributes2 exists and can be used either with
KVM_SET_MEMORY_ATTRIBUTES2 via the vm or guest_memfd ioctl.

Since KVM_SET_MEMORY_ATTRIBUTES2 is not limited to be used only with the vm
ioctl, return 1 for KVM_CAP_MEMORY_ATTRIBUTES2 as long as struct
kvm_memory_attributes2 and KVM_SET_MEMORY_ATTRIBUTES2 can be
used. KVM_CAP_MEMORY_ATTRIBUTES must still be used to actually get valid
attributes.

Handle KVM_CAP_MEMORY_ATTRIBUTES2 and return 1 regardless of
CONFIG_KVM_VM_MEMORY_ATTRIBUTES, since KVM_SET_MEMORY_ATTRIBUTES2 is not
limited to a vm ioctl and can also be used with the guest_memfd ioctl.

Suggested-by: Sean Christopherson <seanjc@google.com>
Change-Id: I50cd506d9a28bf68a90e659015603de579569bc1
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 32 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 12 ++++++++++++
 virt/kvm/kvm_main.c            | 34 +++++++++++++++++++++++++++++++---
 3 files changed, 75 insertions(+), 3 deletions(-)

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
index 35166754a22b4..d083011744eba 100644
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
 
@@ -4957,6 +4957,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
 	case KVM_CAP_DEVICE_CTRL:
+	case KVM_CAP_MEMORY_ATTRIBUTES2:
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
@@ -5184,6 +5185,14 @@ do {										\
 		     sizeof_field(struct kvm_userspace_memory_region2, field));	\
 } while (0)
 
+#define SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(field)				\
+do {										\
+	BUILD_BUG_ON(offsetof(struct kvm_memory_attributes, field) !=		\
+		     offsetof(struct kvm_memory_attributes2, field));		\
+	BUILD_BUG_ON(sizeof_field(struct kvm_memory_attributes, field) !=	\
+		     sizeof_field(struct kvm_memory_attributes2, field));	\
+} while (0)
+
 static long kvm_vm_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -5366,15 +5375,34 @@ static long kvm_vm_ioctl(struct file *filp,
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
+			memset(&attrs, 0, sizeof(attrs));
+			size = sizeof(struct kvm_memory_attributes);
+		} else {
+			size = sizeof(struct kvm_memory_attributes2);
+		}
+
+		/* Ensure the common parts of the two structs are identical. */
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(address);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(size);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(attributes);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(flags);
 
 		r = -ENOTTY;
 		if (!vm_memory_attributes)
 			goto out;
 
 		r = -EFAULT;
-		if (copy_from_user(&attrs, argp, sizeof(attrs)))
+		if (copy_from_user(&attrs, argp, size))
 			goto out;
 
 		r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
-- 
2.51.1.838.g19442a804e-goog


