Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA75CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598A68E005E; Fri, 17 Oct 2025 16:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54AA48E0006; Fri, 17 Oct 2025 16:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EACB8E005E; Fri, 17 Oct 2025 16:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 280CA8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE9F41197EE
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:01 +0000 (UTC)
X-FDA: 84008704962.20.9656CA6
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18B24180002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IPTGnmD+;
	spf=pass (imf16.hostedemail.com: domain of 3SqPyaAsKCKkJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3SqPyaAsKCKkJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ih7eFB1ZnHzojALYCX2+JZp6RL2OYThUFb2eXCv9Q4s=;
	b=maGD8L+rlpoXYBRU78DVk7t6UEKz4eTczOY78p3yErWrlvNXpPjwQuavmdlD1pvKuWDcOT
	emy5SHM2N3rOUi+mwXnagqu+wLvOUHAcs077r+n5wd0xZL1Q49TulH6wogICW6KgluMZDK
	xwWp+FC7H485+M3OpYXBYI8d/Y/u1tA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IPTGnmD+;
	spf=pass (imf16.hostedemail.com: domain of 3SqPyaAsKCKkJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3SqPyaAsKCKkJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731980; a=rsa-sha256;
	cv=none;
	b=3LObZo1BMHRiIvkcEbDpjqYUJVW9RPa0pfgX2kjkrKQxJzc2OL2VJyE9TbTh4GrN5C+hFE
	W0O+d0iyY6VP9aPNmsjeJy/aD6w5uRsAs4yS3FuVqrQVK79CUUh5zVDNivEmgehOYP2mF6
	cAtqu6RIFL21w3Cqf70hzO6XR86XQGk=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28e538b5f23so26393675ad.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731979; x=1761336779; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ih7eFB1ZnHzojALYCX2+JZp6RL2OYThUFb2eXCv9Q4s=;
        b=IPTGnmD+V973QONSEkBN2rR/o+odfJWC70Mid8dQ5Rp3oxobIkFz23BJD/gHbUwf72
         teXwYQKPXE3gNH+hia330mmO8gazo38p93JSHrb4p+EzcMvg/LpvBeHTxVTXQp2K4YiC
         0MqZyVWI/6lUr33QuaNd5XAt5YAx9kydsG0h5YFjz4Xf2freQpCZNUMENRgWUhk8/jrn
         U26sVwgTaNB7B5BoJOfz5dJdpuiEUTBG7qPyffJBglyTVhyQEjlexK+Nq9jEromA/xJY
         lnkST+v5EUy7/iOvLCVaaiSvykTt/xzhlo5eZl1YulbsN/6VEa3hRYUnAS3vN7pB1laF
         mlsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731979; x=1761336779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ih7eFB1ZnHzojALYCX2+JZp6RL2OYThUFb2eXCv9Q4s=;
        b=CqkiVBSCR8dUvkwyUKo56GB3u9nqYYJ0+o+jMaAINZLBkKANTvIbvRb3qJ5zRymnF2
         MQeZVGv8aUaMYtCnuqHHH1U6W0tK59mtM2DO2bXXgh7wKxDlSK2KVnrfT9HWaLTMSYAm
         E0sLucXKjfKQFnYIml91C7tpAaWss3TqIfKRh/pMgUZa/KpYwoUGy8pY2RQl8vUudbAg
         RhPvJeYcBHW8LfV/dr1p8KrPB/z1PxYx6Z67xXsNEmMa6P/udwpqTBqVPRrD3NHt+7Eh
         hoXIHj8QEt0s7umif4JpvW14anP/tdBVWcCi8HMbQxu2NUYOYfEgthuUS23j4V1MDqgx
         NZGg==
X-Forwarded-Encrypted: i=1; AJvYcCVTTNtBQXvLgoORUVjrqVnIrzfXPKSHlHsB7X+ND6+fpaoQVeWQJT/r17jMfj7sRoiJnhj9JpLECg==@kvack.org
X-Gm-Message-State: AOJu0YyIMPP5TVkWxwnfrIEPUqHGWnKAvQwGlQadZzXF2G8V1/7gn1D9
	ncb9SxLYaw6uM7tqClNXLgDSN6ph4VWZvnr18IQFFPDXhIpmL5FBo3Yu8yMzRNydVODx91jLw92
	fv+b653jQUW3LuY7YcF7cGaA1gQ==
X-Google-Smtp-Source: AGHT+IFoDqffNyLkbxHKU6loxuUOLo9acaOS7vj4iOn89/rQ3gk/HKCLxFGD5teHbhavZcQDe+xIwKsPyKOuxUa/gA==
X-Received: from pjg7.prod.google.com ([2002:a17:90b:3f47:b0:330:7dd8:2dc2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e5c2:b0:26d:72f8:8d0a with SMTP id d9443c01a7336-290c9c8c7c2mr61213505ad.12.1760731978725;
 Fri, 17 Oct 2025 13:12:58 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:59 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <bb9227fed5a78a26aa6d6651209479d1295fe77e.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 18/37] KVM: selftests: Add helpers for calling ioctls
 on guest_memfd
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 18B24180002
X-Stat-Signature: tgmu5h3ymoye6zeh9yqc43eyjmr53yrw
X-Rspam-User: 
X-HE-Tag: 1760731979-570421
X-HE-Meta: U2FsdGVkX18lxDcqd5UBf0raG7GdRTAFWFyUwkuwTeNfwZ8uCtt6A9wG9V1Dhn6PMMf06t7oIMqiN4+ilTVfVQVx8QyiuVRIE4Z/UqPt6Yz+NPOMkDHxb8otk3EVN5lzQTkmxIOTOEiO8Ewrcg3lPYXaATJVER+kltKIe+kk9EeWgp5X9VY9IdP3+ZJhBrIArQZKyjZE84ZghGBG6bVqETJaOo1YIs4TFBaHpW3dNm7YeDjoDVVyVI0HXjuWWinM3J7tN1Se3FN0wM6isuIkj2zcL6Jrix0X/5h68T3gmaTfwjxUwjO4aRRNxvB1awz8/ISrWo5A/UtOKWkVeIr90yem0MpNs9YaOJdqdI+8XVi6lLRAaeA8N6kEBQJQxHLHKo0vr6iEh6SMSsN0XBLXUq2G/PqO13hsRAVfaJA6ZxVspzYj2ICd8zszJlTmsRKNUCjXmTaK6bvkAgopz/59dWLPd4/J89LOd6ingLgaismbl+FxZpRH9hRvIATWCi85n705lQQJwbq8Tsxc5HTzlt7uRa8suKB/Vbbyqz16bsDZkSFjRkvkeGSMT85r3Eo0d16FYKJzgJ0bjUYTvGp4q4Kh9SHRGJJitLLNtUCuMJj4omN4JB7wTcUgDgB/CfLXiQZ06Y7xkbmltirIsgO6rCRBM0ja6LFFo2lzAZ/jEB82Hx6aCrRBl8kJph849tkBt9MUOg3klYuXeykS13i7ne52UjtFsdluqZgGqXS2srcEkvUl+atIUyDVv3WlcujGUtw9KNv2j6cmjb1m16pxwEg/PWLttYoFti29edGiUq2yUyEpgcekeZCSKqn8s6YHgndzVAXzB+514p41xUhNOmA0s6XsKCKlhJAbercXwenhwZ7++3upXJ5mfXHmiuaNVLYfnHcBzWRNzaebI719ymcyKyUNM+w24tgWMjzmZiTuSjUkxg69eo4WqHQcYMU3LS0BUgdE1sETwDvR+QL
 BoVN5zlm
 YyqrOY3d+3LYWLIksxOCChVumAjfx1jtgdCtcoNMbvqP2XPsuD0JlhhQ9vf6uhvzAzGocpeen69xUqJTtnbbVIEVuGQqSYQBqR7opWQBf8Wyv2TIDP0X+ASkqDSBrFPQPk6RQaxAi2/C3JTVMBVNJt/vx4hA4DJFARtkx+LB7FgZ+qRSGBXcoSiDuxn0n0pdHYpT0tA36xj+KkRoXFqqOBLigteXQTZot61f3LQxdUol1AMgIdD868KiBHSVk7NyVOn1I6XJrTI+vJxti7MjcuUyrsJzXN2q7mVWUsqw4I4u9DRDKz7X51rZZ64rwvF1+hE7Qujr7ul0lHfjGAYXKbwsGcdmdGtgIu6+Qhr2V34dmSQh7FQ/bOUWOLMRyYVqPW4xpboCmQaiLWy9++IMKkUY0XVJg6M2hksjMaeyEVEFWagMNoxBjN/84mgwMdDBT028H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 .../testing/selftests/kvm/include/kvm_util.h  | 87 +++++++++++++++++--
 1 file changed, 79 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 019ffcec4510f..dd26a41106fae 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -310,6 +310,16 @@ static inline bool kvm_has_cap(long cap)
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
@@ -398,6 +408,14 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 	__TEST_REQUIRE(kvm_has_cap(KVM_CAP_MEMORY_ATTRIBUTES2),		\
 		       "KVM selftests now require KVM_SET_MEMORY_ATTRIBUTES2")
 
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
@@ -409,18 +427,11 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 	};
 
 	TEST_REQUIRE_SET_MEMORY_ATTRIBUTES2();
-
-	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES2 overwrites _all_ attributes.  These flows
-	 * need significant enhancements to support multiple attributes.
-	 */
-	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
-		    "Update me to support multiple attributes!");
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
 
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
 }
 
-
 static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
 				      uint64_t size)
 {
@@ -433,6 +444,66 @@ static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
 	vm_set_memory_attributes(vm, gpa, size, 0);
 }
 
+static inline int __gmem_set_memory_attributes(int fd, loff_t offset,
+					       uint64_t size,
+					       uint64_t attributes,
+					       loff_t *error_offset)
+{
+	struct kvm_memory_attributes2 attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = 0,
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
+				     loff_t *error_offset)
+{
+	return __gmem_set_memory_attributes(fd, offset, size,
+					    KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					    error_offset);
+}
+
+static inline int __gmem_set_shared(int fd, loff_t offset, uint64_t size,
+				    loff_t *error_offset)
+{
+	return __gmem_set_memory_attributes(fd, offset, size, 0, error_offset);
+}
+
+static inline void gmem_set_memory_attributes(int fd, loff_t offset,
+					      uint64_t size, uint64_t attributes)
+{
+	struct kvm_memory_attributes2 attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = 0,
+	};
+
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
+
+	gmem_ioctl(fd, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
+}
+
+static inline void gmem_set_private(int fd, loff_t offset, uint64_t size)
+{
+	gmem_set_memory_attributes(fd, offset, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline void gmem_set_shared(int fd, loff_t offset, uint64_t size)
+{
+	gmem_set_memory_attributes(fd, offset, size, 0);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
 			    bool punch_hole);
 
-- 
2.51.0.858.gf9c4a03a3a-goog


