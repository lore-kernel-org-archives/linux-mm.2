Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40FDD10AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0578B6B0099; Thu, 26 Mar 2026 18:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22CA6B009B; Thu, 26 Mar 2026 18:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E392C6B009D; Thu, 26 Mar 2026 18:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD7406B0099
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B433E087A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:44 +0000 (UTC)
X-FDA: 84589644888.13.C64B0D6
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id 98C8A1C0003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NpL6ai56;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3KLLFaQsKCPcZbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3KLLFaQsKCPcZbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563882; a=rsa-sha256;
	cv=none;
	b=zE+cJeRSydWkBOp36XrKluUIYULWCIl3WqxCK9QA19HL/p6vJhOfB3D6T9/qsf7Yhvepg2
	r8RySEI/IG00y4G8SGj1u9e5D+SIkuAlJGaP5mKwpFOOWculGkRiTd1cckhw3mTn96429X
	TVd0O2dvsCZk4vOEMDALvJxEQ6ca/ww=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NpL6ai56;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3KLLFaQsKCPcZbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3KLLFaQsKCPcZbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scH0lZ1p8wn4J/rr93E4hm/58GW/JK+mDvgq+J6pH2U=;
	b=VBdlghXNjRQACM0TI6fEN2MHTwnRvgxoZCssGj3JeonoStk/OxOg5hVUkdDeB+Wl/MpiTM
	AcGA6Fv/5WWBh8xsMYnz0hIhR6g3ZYIz3W7GjfWu9qpP7yFckj1OvUuFqDwfXpK5HROAgg
	vZeoLEUX9aDXMHJik0dPzdsDEdLnQqI=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c9364612fso357486b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563881; x=1775168681; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=scH0lZ1p8wn4J/rr93E4hm/58GW/JK+mDvgq+J6pH2U=;
        b=NpL6ai56vAHnhRiy9hZusck8qcMP3+ev3N0Bu+5+/3rCjXSJPP/amOK/ZDw1aE3V4j
         bNgh2ErRNnAvUFYzeGKZLFqPSp0otobEkGQqzjcONcpmFBjDIPNbir10IXG8UHg1Ce3i
         IXaI+++KKg25EWIMGASesZoiK5Qfgtcrm3vxmEpb+1AaWQRPVRfQfEjLx87CtTuWftJc
         Loh4ttI2kdxNVMe5d2MdJ8DEs+JogZhe4cJD+jFGflbe1/OTGDCFxuEdLTvaTRxT3Tze
         QRLTcWgYsLeBsCQz+UjptAA8xOWArlW4QOmEWHlMSajdunjj/K61pX+L9Lf2CIA47Lzj
         tSOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563881; x=1775168681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=scH0lZ1p8wn4J/rr93E4hm/58GW/JK+mDvgq+J6pH2U=;
        b=pKr7wnRnUkFkN72GdF85NyDRv79LGS8fBw9rrVpo4UvkJzHek6qeoxoEC6EoR7iCsz
         XST0v3vHVfG7QbSLjdlZ3WdqwBbeMqlNWaWNkWGKdDEFda+4hnZLJSnnBmn9S1aSAlyi
         laB6tIh3bE7mubSDPEmrwZ+UdLO54UNc+/afRBzINXwKFUpX2wLv4oyeWoqYkMpqBvux
         wJmnevB5UxPaaCe6MahEZ6+4t70jqTpjkIJ1tokU34HEUNmYVcqeuJ9ViTnaqJYbg0/l
         huG2paj2eWZgpLpj/Oh6jCyOP2CALHosD3GdZflWqa/5vnnYlc1Y/9wgQZOFBk95ByAt
         pZ5A==
X-Forwarded-Encrypted: i=1; AJvYcCVjI6otWSsWRlT1dNXygACXRu0z1AqrEtt4nUa+53YKYnioom5VWJJlD61ZQYPD1IoJ9mz3WGCuQg==@kvack.org
X-Gm-Message-State: AOJu0YzVZInbthVKh63PjLeeg3/dkj3NppDhM4XbERzjFJnViZCws1Lm
	lyy6g6CcfoMjzEpaB9ICN7GKesMIafp0ZgWHqDZmvAH+kgo132rkVutYbqmWEENvRFhJjnVjDtZ
	Vrbbwh1BMaZrfmWwWHbP9YU/+jA==
X-Received: from pfbmb26.prod.google.com ([2002:a05:6a00:761a:b0:829:a3d9:9345])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:14d1:b0:824:374a:1424 with SMTP id d2e1a72fcca58-82c96045159mr128711b3a.58.1774563880905;
 Thu, 26 Mar 2026 15:24:40 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:17 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=7356;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=rr13v0ReufuLtKHyRyN4FDB898pT6Hlku9bGOsppn1A=; b=nFeFzTX8ygVbPanVDLq7QCIuwm0m3IM+MkQCg+3Y/ZgpL4egW6yC/P2AYDQ3LIc1fpYcY3/Vc
 q5YdI9LOQx9CHKVyQhNKOkJtQCHUwiYrJZy8/+KcXHHCuWBiotb3HSv
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-8-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 08/44] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
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
X-Rspamd-Queue-Id: 98C8A1C0003
X-Stat-Signature: t6ayb9jqnup1xmq1inak1ko49ehmwjqu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774563882-548439
X-HE-Meta: U2FsdGVkX1+XoZneVttybW/ooECE3yrvaQXvxtCd0fpLLYDjVyCT/Zehb4rwFD/HM40XF+i3etcl4V9PtexGX8fe9L4hqVloiLHkVqu1CceV2HfO2Pg0lqa2S+grbNqfGDrYJ01GdLdUpf3Mstt2soyvQb36BbZ5oPQgEK1uHcL8FSv7ESVlz53c0I9nFLY0IjZAw4C6ddhtIB/UNdcOf2Z/B/5iS7ayKpslj2ZQHLxdFsBGk9FPqOrHJASfy3nDLEbz+Vv7sD0OzInnDRaGbbbvOKiG279q1S5q/l3qPGm0efIc0z7jLOoWbvVgqiPuvFmH32CGvvWDm0UkJYV9otO+qNcndOB82BwhhR95CfwfqQ6+8PWWts54RbbYHuvAhOGP/7mde7rBUJ0TN+ImLc9RsWz408m0WLRqrCzweS2FfqO+ydVgqxhWhceElUtrjQVw8fO5iqrKg+VxvsnWjQxgAYbw5k0SaQ2qPafzHaYy19WdRApUXHWf3YV1YuMIjgfbHNlPTcDKinjN9krgS2exyBgnXQeyJoxWGM7DkKP/0NgCahvQ/x1hDezcOFajUicYr+DPMZDVfrFTcSAxPd/zJmOL5yI5Y3KQ1n5R+9c9EzAqjBnqsglqJFJYaFUOWI20Ak7i6Yy+8xge92Yx+CIQphZ3mIQPBOg0ykAUH4dMWBkOe+QFGptKDycPaupJWmUnhKdeJTzLgzTVyUC0ezi5lt0NePl9iw1gUajIouXP1rZvRPsKV9R8Py7kqM0ObhNoUQMqOopNEAEW3w+knzQoUHUmelKP8l36kkt+Ze/SFe8X8SG42A6VreQjnC/BJQhhm4Ah7aNHSYyAzr6VVPwzJ5/jizGqiuEkWVNWyMQO6rFthJPNjwOcKXN+x1oHY8ltYP72WxrRN6uIOxS/5osF4OHGPGYh9fFp3Y8v2hJglRNz5PSv89Wu+cygIZ4L+kLP+GY7P1q9jFFO5MR
 K6VBeQzN
 /Mk7+V8NvSNjuuSo14e5ToLlaqoniNx7aRU8x3TR4yHdjGtcuHE+PBv28xLGDkdTcKLny/AZCnpxgERlA0+iLaQyhF7TfvbXBCBPcFbvhOJ2xbhkOodzsNLYx6LNAFhcxzECJEaWyahS8u2OyOMqULjQpExqjPibMWtgOvIiNnI7YCHQlVx4Bh99EzDvqNApamIjVPC4tDecSEzfZcBpUoSoH/UC+Ma8UE4CUSdoO0d8pCcRBLGAgM3s24N49SVvxFOBLwiiA1SrR+SkW1Nc/ZJTtOthBGNWZMkgMbKHy2mq/OHaBjM9HRRLKU+02a/yrDKUGrW1gThm78UgNi5XTvMVzMZtm1nAGfJvEYKkn7mSms2WHf6khSXc6dcwbnTCfuXknZaTBppuQblaeUwdaSmqlGQ+WQC+LMsQgnEFTUE92xRQVrtDERveDzK+7Qsz7f9tAk6sW1NjGyPV/dvuCkoyXKHqedoJT4DSZrg6h+wQ8RFDFFqDK97J3LXqOGyYLqYMCQ/E4ff7N5IydRze1XJg+9+18wAlaS+9YV2qRbWtgjWUV2kW5L4JKRo3OXTNt7/xeqHmnD6Ksg+e2A2alw8r3NG/SSVii3dvMaKoqcxSPKjupbbIERR0edHLF8xL/dwpwZtBZuR9qfi3J2rdrnSLUi2A4UjEcF838V76lmimcp85f864VDkuMQcxEatiVO9NszekGLooD4Uurc0N4PR3+7w==
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

Add KVM_CAP_MEMORY_ATTRIBUTES2 to indicate that struct
kvm_memory_attributes2 exists and can be used either with
KVM_SET_MEMORY_ATTRIBUTES2 via the vm or guest_memfd ioctl.

Handle KVM_CAP_MEMORY_ATTRIBUTES2 and return the same supported attributes
as would be returned for KVM_CAP_MEMORY_ATTRIBUTES - the supported
attributes are the same for now, regardless of the CAP requested.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 32 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 12 ++++++++++++
 virt/kvm/kvm_main.c            | 40 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 032516783e962..0b61e2579e1d8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6359,6 +6359,8 @@ S390:
 Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
 Returns -EINVAL if called on a protected VM.
 
+.. _KVM_SET_MEMORY_ATTRIBUTES:
+
 4.141 KVM_SET_MEMORY_ATTRIBUTES
 -------------------------------
 
@@ -6551,6 +6553,36 @@ KVM_S390_KEYOP_SSKE
   Sets the storage key for the guest address ``guest_addr`` to the key
   specified in ``key``, returning the previous value in ``key``.
 
+4.145 KVM_SET_MEMORY_ATTRIBUTES2
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
+	__u64 reserved[12];
+  };
+
+  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
+
+See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
+
 .. _kvm_run:
 
 5. The kvm_run structure
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 80364d4dbebb0..16567d4a769e5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -989,6 +989,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
 #define KVM_CAP_S390_KEYOP 247
+#define KVM_CAP_MEMORY_ATTRIBUTES2 248
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1637,6 +1638,17 @@ struct kvm_memory_attributes {
 	__u64 flags;
 };
 
+/* Available with KVM_CAP_MEMORY_ATTRIBUTES2 */
+#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
+
+struct kvm_memory_attributes2 {
+	__u64 address;
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+	__u64 reserved[12];
+};
+
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70b594dafc5cc..3c261904322f0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2621,9 +2621,10 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	return r;
 }
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
-					   struct kvm_memory_attributes *attrs)
+					   struct kvm_memory_attributes2 *attrs)
 {
 	gfn_t start, end;
+	int i;
 
 	/* flags is currently not used. */
 	if (attrs->flags)
@@ -2634,6 +2635,10 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 		return -EINVAL;
 	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
 		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(attrs->reserved); i++) {
+		if (attrs->reserved[i])
+			return -EINVAL;
+	}
 
 	start = attrs->address >> PAGE_SHIFT;
 	end = (attrs->address + attrs->size) >> PAGE_SHIFT;
@@ -4966,6 +4971,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_DEVICE_CTRL:
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+	case KVM_CAP_MEMORY_ATTRIBUTES2:
 	case KVM_CAP_MEMORY_ATTRIBUTES:
 		if (!vm_memory_attributes)
 			return 0;
@@ -5191,6 +5197,14 @@ do {										\
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
@@ -5373,15 +5387,35 @@ static long kvm_vm_ioctl(struct file *filp,
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
+			 * Fields beyond struct kvm_memory_attributes shouldn't
+			 * be accessed, but avoid leaking kernel memory in case
+			 * of a bug.
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
2.53.0.1018.g2bb0e51243-goog


