Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740F910AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253DD6B00BF; Thu, 26 Mar 2026 18:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DE306B00C1; Thu, 26 Mar 2026 18:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3AA6B00C2; Thu, 26 Mar 2026 18:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E36BA6B00BF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ADF2CC4484
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:14 +0000 (UTC)
X-FDA: 84589646148.20.BFF3DA2
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id DDBB1120004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K9Nq60Yo;
	spf=pass (imf29.hostedemail.com: domain of 3R7LFaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3R7LFaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJLCurHGT9Ozv2z9SVGQ9QgPs5YFI09GMd1yNupksws=;
	b=zSDtCIioILzcKl4Vj6wWIl2PkeKJf+PLyfetTwbnqadTZuflHZo6jXlhl3X0dTejlggGNd
	4EsDhZJo3jVcpjCGl3MV3VspchfraO/kXWljrZitOTtW+jCqpqfhNjepD1IyRfvJb2tzCI
	NXU2sHZ5kM+wi7ktZEjPG+9DEVYq+xg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K9Nq60Yo;
	spf=pass (imf29.hostedemail.com: domain of 3R7LFaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3R7LFaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563912; a=rsa-sha256;
	cv=none;
	b=DXvqm1NPQii74v6ZIOXCcj3FQQGb4cbuPobW9yDDINhla0vXTpRXPvhfwZMn8DMBiW6+u3
	gvUN+EpVHzBMwm60OmlYr8ho1oKXkbcwdIBLka65MV1yEKQjVwo7WLSIh1gcOZoKvLvvTw
	n58Be3hjYe6xeE9Bpw2oKG59JIRI/M8=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c89d4ce16so636933b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563912; x=1775168712; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iJLCurHGT9Ozv2z9SVGQ9QgPs5YFI09GMd1yNupksws=;
        b=K9Nq60YoI8Qv4mTNpHfmV/LKiuBWnTYyWcr2nrqWWWcevGYyKm3yOS0glQzonYshMb
         rSXTlNzf5zYVFNXmZfrNesACExmvIwjDbnjn72FZgavxDQb6iSJ3CGZMqwOgzIC/yMzg
         LEImNGKJLkTbiau22R6zD0BmUPoyrd8rvHfIDWd9F87mBfg9dNetuZ1FVpAjW9uk9roo
         crqnmFBqRYQNLXfG0ys6WVTq7g1UJhY+EsHG00tMWBh0kEXusWZDfxEPFmyvnwz1bRKL
         MX9jioGPCzzd2Z75nrv90QIpOJBoM+FO8LniAM48+xPFZlhm2cmowlvDvcF+/IHZyhcG
         uUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563912; x=1775168712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJLCurHGT9Ozv2z9SVGQ9QgPs5YFI09GMd1yNupksws=;
        b=MkZzq6srfs/zS9GX9i5k8aarpBLlynMv7VM1zanSzS/sRuD0e77qI27p0VLHNrycyS
         B9M82BjAXrVaGDyCbdr4ngkX+CL78Ln8GWRjA6AltTbb412F7/5nQgOkfko1Rt2KnLSb
         VuMI+UnmHXqdr229aXYCx1kNfQ5vfamSDVXCTWlZkjDlnAe0gsZ/bTDOSEoicMYQpALP
         M8D4+OHMLilNcrGU+ehpVSAdaeZKhW9wECoPKCGaeHrA9lpT6idC7O4eNZMfpw9WSUQz
         bS8kFuMKwOnJmUq51264xNLeMato0st0VG4KQGc+I5i8VMoC4LLagFoCmm50c7CDDlG8
         Q4Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWsNDzZfZa8ld9prO/+7gIT6wakCvTUH/uU9em9DP56PdUGyDS5B1RR3YIlrC/ud/IyOUDAAjNiCA==@kvack.org
X-Gm-Message-State: AOJu0Ywn0hiRiFOg90gnYHGsL2fHM6xkp2sPC2RWukjO92pP+SArMFHA
	RRdlD+rn4F4NbX1/QPYhtPdui790FzN77SRAMqx1mvfCUcw/KkCjSXQd+efUQC3rHHZjgAO8+aE
	HJ54O7M2onChXkeCbihfF/66T4g==
X-Received: from pfbbe3.prod.google.com ([2002:a05:6a00:1f03:b0:824:a502:8fea])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ab84:b0:81f:4884:4fed with SMTP id d2e1a72fcca58-82c95d2f63dmr173790b3a.7.1774563911494;
 Thu, 26 Mar 2026 15:25:11 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:32 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=5492;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lS+IBAVYXwyHlv6WRF1Ol2Kaf5AEubNCdwiCGV0mlpA=; b=UaxYPJnJsXBYpB+JCRQ8jNBQhVVjBXkwA8wKaHeliaKJ/42jC2aJMtTG8w6UgKW7fyU8fJPka
 BfSgymmQNisA+eaG58gYT/0dNC446XTbQbd/0mLQJ3e1SiqrLkjcNug
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-23-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 23/44] KVM: selftests: Add helpers for calling ioctls
 on guest_memfd
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
X-Rspamd-Queue-Id: DDBB1120004
X-Stat-Signature: kxt7pwda3gorq4rz4i1zggi6o6jgmy65
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774563912-353350
X-HE-Meta: U2FsdGVkX1+PxmX26NSulTlvzBwqlwMivrSTVKp4VpLW6/aHA6NoytIrKF7b/Wiv7Mo86fkddsSFKIm5Sq+Hk9YQf1MIqBtOi3ZPe4s3SI3NU4CWrXNYrb/Wg1fXS2Dh9TvbEVcVQYIC7c2PX/hdL05fXakGHd+YB7h88yRNn+CqEchDhCml08UdwxQ+B9uxY9JURivB2JOr+UDYsVL0HPylz7X+hkisE0EoPwtSb0d98mCqPlYpr4NU1p2KCAZVywzCKUZUVpFbW6Ev2X6zIdbl1V3fSIufWimBwMGjYlt4LwP1x2ipdW7Ubji6zs2cMeb4lvntTpv1Jc5dDQBgXRjY4ENWFHJTh42PCMlgDsoEFh1EMxc+1r+pwAgT+/iLBYAnARMsF6yz3gOh6A7ohhdUlfnBimfOgqKOBSw1/tPuPwxq/O+mMsQ9VyNhX6c+jZcfw4uMPmVH2RlAPxM6b+UpoI50YIwrUJv1tbMEa+jknw+yS8dAhstBN8Ns6Qk3TDmE7gdePwH2omV2UwYyi3UbdVdZJ5yc+cpnyJk7bg4bGp8H+Ifg50o18bjqPWsKir19O8GwEFmiUSjBuXPbwg2plqPBNoEdI0gm8U6OqwEWHXTn66WaaGajD5DGFKYjdw3pcnT2+g7Xfc+xJAPXeYg/XXxqWtizaX7/Enl1Izj7rAUlayyBjLCs1FB01zGmxVUPN52VemmFHa7elYE+jRC2Cq+ot3Bjl1gsTp89fXRjefJc7fp19UjDb+r6N/vT3epcVPD2Cx7c/3NT6lSaCr6AftvIIMQ4GDdFwqunV7v2kBo6306aUWu/vBE2f1NvqG7cMETXx2Px/fFFWFGkSm+IisTnJJ+fYMoDckKAoyN7av2HLQ8LBrXrw6qTHfAvoC5gDlmEaigJCqUed18TPoJKFr4HTX1XM9fbshdCqOJPRHzYfbSQMk7WuSYn8zt5XOuLN5pSwDZ56uZqwNq
 DDOKZhr3
 az+nl1fL/C53vISU5a0f3vGLinJi02kg90SFid+i7sTT+2k3Gt3vqFy+eVz2dRrsBNj8YkVRpWTEbUf8ven1EmTEN684u4kIhu4RVNvYQlsXEfxDRHLBDP1NzZev8qEZ7+73NM4KmS2D05qbfvTd2Dcc3VGq72uabZ3IL1PwouPManphF7aYK83hbNxbm1QGR8qxTScP2nvUII+uw2AbIpQh0Ocyzurch6AOkuSHeHm7OhNCNyRYgqGmws8MvfU9S9jGBWxoTDrI5W5wENFlj6fYj1K98tulI8tbhkhcAJRUYPZJfe4ppNkuHU4fYL6vTRAiFarmokIfRXtVSAqimo0RJ/+YuX1qlTF+h7XYKyXKIkXNBPohJLfEDfQuG0yns2YoW+A3yBlCShzLbkkcTyLMonqvRhFGXs+JeBR5WZyZTbrUGBJEgOl69tI3J+AAvK86pnexBX9w/9Ntma7GfrRNWzZ0i1hwnyLWRBoxvnSgrb0S8V6mhCOJmFMF7zOMBLhZd+9iRrtcb23tgIKKhTA9Lwa8T9kOIaZvHiWJ4lDQkpuChU8gp+3dMKG/15JDDdB0C3kYJwwXll0v7EZTW6tzQUEQkhNGhEww6M6oYME2sx78xT6KoMUNelbXwz7P2UOM2/1Oo2Ub4DsomZWPuxGcf+zmhbIASepNZBDpFr7OKn78DPnXnrGgvB0d4+osOygO1ijZALxTfs0M5eAFEwrmS/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add helper functions to kvm_util.h to support calling ioctls, specifically
KVM_SET_MEMORY_ATTRIBUTES2, on a guest_memfd file descriptor.

Introduce gmem_ioctl() and __gmem_ioctl() macros, modeled after the
existing vm_ioctl() helpers, to provide a standard way to call ioctls
on a guest_memfd.

Add gmem_set_memory_attributes() and its derivatives (gmem_set_private(),
gmem_set_shared()) to set memory attributes on a guest_memfd region.
Also provide "__" variants that return the ioctl error code instead of
aborting the test. These helpers will be used by upcoming guest_memfd
tests.

To avoid code duplication, factor out the check for supported memory
attributes into a new macro, TEST_ASSERT_SUPPORTED_ATTRIBUTES, and use
it in both the existing vm_set_memory_attributes() and the new
gmem_set_memory_attributes() helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 94 ++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 1e00bfa59dcd5..a539a98f79e08 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -333,6 +333,16 @@ static inline bool kvm_has_cap(long cap)
 	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
 })
 
+#define __gmem_ioctl(gmem_fd, cmd, arg)				\
+	kvm_do_ioctl(gmem_fd, cmd, arg)
+
+#define gmem_ioctl(gmem_fd, cmd, arg)				\
+({								\
+	int ret = __gmem_ioctl(gmem_fd, cmd, arg);		\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+})
+
 static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 
 #define __vm_ioctl(vm, cmd, arg)				\
@@ -417,6 +427,14 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
+/*
+ * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows need
+ * significant enhancements to support multiple attributes.
+ */
+#define TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes)				\
+	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,	\
+		    "Update me to support multiple attributes!")
+
 static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 					    uint64_t size, uint64_t attributes)
 {
@@ -427,12 +445,7 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 		.flags = 0,
 	};
 
-	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES2 overwrites _all_ attributes.  These flows
-	 * need significant enhancements to support multiple attributes.
-	 */
-	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
-		    "Update me to support multiple attributes!");
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
 
 	__TEST_REQUIRE(kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES2) > 0,
 		       "No valid attributes for VM fd ioctl!");
@@ -440,7 +453,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
 }
 
-
 static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
 				      uint64_t size)
 {
@@ -453,6 +465,74 @@ static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
 	vm_set_memory_attributes(vm, gpa, size, 0);
 }
 
+static inline int __gmem_set_memory_attributes(int fd, loff_t offset,
+					       uint64_t size,
+					       uint64_t attributes,
+					       loff_t *error_offset,
+					       u64 flags)
+{
+	struct kvm_memory_attributes2 attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = flags,
+	};
+	int r;
+
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
+
+	r = __gmem_ioctl(fd, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
+	if (r)
+		*error_offset = attr.error_offset;
+	return r;
+}
+
+static inline int __gmem_set_private(int fd, loff_t offset, uint64_t size,
+				     loff_t *error_offset, u64 flags)
+{
+	return __gmem_set_memory_attributes(fd, offset, size,
+					    KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					    error_offset, flags);
+}
+
+static inline int __gmem_set_shared(int fd, loff_t offset, uint64_t size,
+				    loff_t *error_offset, u64 flags)
+{
+	return __gmem_set_memory_attributes(fd, offset, size, 0,
+					    error_offset, flags);
+}
+
+static inline void gmem_set_memory_attributes(int fd, loff_t offset,
+					      uint64_t size,
+					      uint64_t attributes,
+					      u64 flags)
+{
+	struct kvm_memory_attributes2 attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = flags,
+	};
+
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
+
+	__TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) > 0,
+		       "No valid attributes for guest_memfd ioctl!");
+
+	gmem_ioctl(fd, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
+}
+
+static inline void gmem_set_private(int fd, loff_t offset, uint64_t size, u64 flags)
+{
+	gmem_set_memory_attributes(fd, offset, size,
+				   KVM_MEMORY_ATTRIBUTE_PRIVATE, flags);
+}
+
+static inline void gmem_set_shared(int fd, loff_t offset, uint64_t size, u64 flags)
+{
+	gmem_set_memory_attributes(fd, offset, size, 0, flags);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
 			    bool punch_hole);
 

-- 
2.53.0.1018.g2bb0e51243-goog


