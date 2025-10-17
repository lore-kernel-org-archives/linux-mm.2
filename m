Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11B1CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770288E009F; Fri, 17 Oct 2025 16:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7E48E0092; Fri, 17 Oct 2025 16:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4159F8E009F; Fri, 17 Oct 2025 16:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDC78E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A96E2B7FF9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:28 +0000 (UTC)
X-FDA: 84008706096.27.B0D31E0
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD2DB140019
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PNQIjqBv;
	spf=pass (imf26.hostedemail.com: domain of 3ZaPyaAsKCMQkmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ZaPyaAsKCMQkmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SpoVPQkxx65srwzLoEmvKd0scDAwEAjWt5gz2bwW38k=;
	b=08dFg1Pw9y0+MDvVA78OHWlabC4kf3OUx5U2q3QQC4seO5YGa0UIGYKQChb6ildcjGpkQT
	VM6XYBa7bgOvg34IR8X90tF4TIYtje0swaCsGFzXdwwpOXWaCvWHJ6/o8dSE/fMg3umplP
	MT6fHhWbPOhSwaum1Blv13au8kIKbqc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PNQIjqBv;
	spf=pass (imf26.hostedemail.com: domain of 3ZaPyaAsKCMQkmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ZaPyaAsKCMQkmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760732006; a=rsa-sha256;
	cv=none;
	b=xgoaxZIwbZcDZ3RXbP13FtAK79j60wqq9ZOFAyY63ew+LPK6MBSG6qzlaAOVmElSmnX0+q
	N3+AoXwpn4VQMksjrAW+hl2Tj5njl4NAKPILn4ZRHmxiGVBgCZj4j7Q7ZW6pW3EhVEKydE
	3BJ+M9v4wO///so+Ut6iAPy6076Sju0=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28c58e009d1so44088845ad.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760732006; x=1761336806; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SpoVPQkxx65srwzLoEmvKd0scDAwEAjWt5gz2bwW38k=;
        b=PNQIjqBvb8Dfiv0xfnbo2vnc2gmXp+4LQ40SBW5Ddos/l4eQdtLxwfqB0xmDToaBG5
         ngqDFcdUovxHbFPUUHgguDn0xGiJadNaf17Oatdp11kuc23ma4mXAEC1C87AM+hciEpi
         a8BeCdrVrsls1FP5/XqxT0RjNFb9e7scLNnl1Z69l8q1/W0TMFuYtUiFcoU3liBCkoe5
         cFHYPiXgt5voabBZkNPBXUe3Vm1+QL/AqZY+v+IC/Ae/CpZq5zvKhgvjUaschgtfNMmw
         1oCnUmZqv2Il2k5QtYM7okeMzvIlB0F8N86fp0c3uqOQyKMDP+/M/MguGyN3eDQt7R52
         x2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732006; x=1761336806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpoVPQkxx65srwzLoEmvKd0scDAwEAjWt5gz2bwW38k=;
        b=A+1u3wvfBJNAMJAX5Crgd4+PJRG/vNOlwZiIW4jlrSQGfdJ8hxP4k07ho78q7ymILp
         3eLJBDsAF9j6Bs2+Wqx9bn7Y+S+WuLD7xrTQ++vtXDGd+emeHK2+C9NNioYtSnpxarl9
         npgOmJ0wnCaSG88qb57eCBeMV1OrSE9wyyLRdZY8GZT4WmGX3KJH+6G2mNy24fkn9YF+
         BX+N0BcK10UjLh11NaiL+vp8dCSusDb8wwgPRD5g8/FxhggY9w0ubZERZ0g+Dq2EUTOA
         KfLTPYpmJPXBqpNRLdVCr+jCe2cgpbdh94xkORAVWpYt5jXNaA46M5wOASC/6QJv2Zv6
         soHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvJw6E1p9cbZp/JjN+44ZMCI0sZufKr2/vgHHc8bA+MCOMvg4i7FgVy/Md6OTeibZk+copI+dyCA==@kvack.org
X-Gm-Message-State: AOJu0Yy8FEFc5EumM0F4x3qvTf/lq+EzhBZ4Dh8vT5SnKdKAlLgr57JE
	JtAdPJ7vKYGop8lW8kcoLdZ/KyMGYnlmIGjFb51fyCm3xUTLEfclauIR7IWTjlXrqRRSK6hNob+
	nnVVupl0VBpzSJbvHm3orXO9MiA==
X-Google-Smtp-Source: AGHT+IHMvWCbFk7zNWAcA3iBXitO6Giz/tz8VDGZaOcvvFaw8VizJhdk71JqmoT94RqN4E0zZSOTnwVxAhEK+wEYkA==
X-Received: from pldr21.prod.google.com ([2002:a17:903:4115:b0:290:a6e2:2006])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e543:b0:269:4741:6d33 with SMTP id d9443c01a7336-290c9d3740dmr58504095ad.23.1760732005539;
 Fri, 17 Oct 2025 13:13:25 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:15 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <4a1ad1015657e90db1e81c1b51dc07f62afe29ea.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 34/37] KVM: selftests: Update private_mem_conversions_test
 to mmap() guest_memfd
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
X-Rspamd-Queue-Id: DD2DB140019
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7w8ekizw8m94mnmxhm4iwrx4cznb16ut
X-HE-Tag: 1760732006-574250
X-HE-Meta: U2FsdGVkX1+zQaHjnbVUrZ8R6xCAkXWwOG8f6l+P4lKiLlnLAHp59rpVPlmK6o/CGlX6p/zuqeYZDI204yD1iL8ousoYw3KgeJajjNFX356522gnXwB0llTJM1tq0a/ZjNFr15DvsNvv1fwpl5bEBF3pgCM3Wo8xk14pbIhPQ3xkx5dWDhel84CuZVvLOGvQtMfG7wlnraTslMLIXd2/0U7DXQLhLu05/cdeqz89PrDZyBVA38mECzldF0m3/bNgJp4e/CvJfsko+cgL2u7i68jWMaunYbXFkMfsC/lX0/Q/+bZMkd6DUhzZ2cn0PCqs0G0LhNAb49Xjgj9N2d4Fj9LxHE3F5QfH+H4QwtQtGBieSdowSaYBYCen39kTtEYwixU4CXUbxcM29J9EuY9FrJ7u6JlhULHBPCV9PYDDZbBYiIDSPbqTxSn2emU+BrqKiLwohi4RNinLU7LpZwu9FF1BlDvt+Z/50KdS55QjGtOE0kJZEtwmT+T97CxGAMQ4yxOat8ekVw7s5zFq6V/vQ/HfYkCMBb9g3uJG85PNHY5mxj1cROFaaqcd5acmrAeSfu1YEJxaxnbnok0+DgNT4jiBc23OSYhSeOcDl9gHVeCXi3TYtxnJHvaKHzPCZ2vO/fFLGRYoBk1hNP4xxo9yUBEcZRGOUl3WNcPVGnHh1AHk19LjwaAEOo3uv//5h+iYJ+E2lUGkw6xb8ndz51VIBvvut79AiJ0KND5i9rSlVMJPQvmwck2PI7BUL17O/dxFuW6hwUHNL5KOkTCdpMh8SP4Np3pSSPpblrEek6Rs5USM280cT8QsnLR0pMqxkZGVxfIWDYF0PH9tD7fl8+R3L1VcQ4+KqSg+icMHDtxeQeB/vmALX7MmVgRGubztg8sh/yFQOSzwufoTwoaBJIGFr4CH2ZE+/W/SSQ2NNsIhE5eTRH9fwUxhXhRS8DiU6c+n0XT4TTdGhJh+J5YT9P1
 zohtOunT
 gzq3Ouwg+ur/7eDQqdFjV1ucK+7Yt6JLiKxD7eG5EsF/fDPayiHiyBsV91sAxsKVzn9mn/Z0PAvlM806Mpe1ARqXiStg7fn+qmx8BFtro6aeTVKHRWPOj8BwPwY368LUPqI2bK++uKkd1RYuBbYWOejiM2zn1dNSmqh+dSaJ4YuorScZcovEhah3ddLpK7DQx5cF8qfcPW67YJj56J6T4cnTk3NOiU3Bp0S6Rnvb5NBiAkBdVSCUY3Xx3gA8dsvRmd72foqhB7GalJ9PNTQqFK8ridT39q+hfG9vUbNbFIpyk9UMRLJKM5zX7wkIh2HkkKrKXVQRB6GiROgfyX69g1BGVtLkrAj5n8Xn3J2qei1c4rsKpj3HM5ZkSXOHTzqAYp9ldADrTOJmBf8io/OZfkbq6YuHYg0BDcuYKv3NjVef++r1RLpZ4SZzbCGz7UEcbhHD530p4e35hHXoVlNoIPI+VIuubMsKJ/q2hOKvsG+6MyTFmQ+4KpQxzhzGAzBLzyWAMeJQodVvUdsJ4/EGbMFXiwkBcLBXI2DmohZHRNQgkli0929I+1Wf2vdyhwkyTWruqgdN8fzWYqZ+LuXbXJTtywRxepwhASag4S0rZckbC465iiR1q509hv1Vj0Yxwu1ktLuqGmxjkz0Qzvs2d3jzaYgvEI4EdrContQgIj1DIePfSH7prWJ7hVkqg5dM7cTXDke/pBdxzS4o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the private memory conversions selftest to also test conversions
that are done "in-place" via per-guest_memfd memory attributes. In-place
conversions require the host to be able to mmap() the guest_memfd so that
the host and guest can share the same backing physical memory.

This includes several updates, that are conditioned on the system
supporting per-guest_memfd attributes (kvm_has_gmem_attributes):

1. Set up guest_memfd requesting MMAP and INIT_SHARED.

2. With in-place conversions, the host's mapping points directly to the
   guest's memory. When the guest converts a region to private, host access
   to that region is blocked. Update the test to expect a SIGBUS when
   attempting to access the host virtual address (HVA) of private memory.

3. Use vm_mem_set_memory_attributes(), which chooses how to set memory
   attributes based on whether kvm_has_gmem_attributes.

Restrict the test to using VM_MEM_SRC_SHMEM because guest_memfd's required
mmap() flags and page sizes happens to align with those of
VM_MEM_SRC_SHMEM. As long as VM_MEM_SRC_SHMEM is used for src_type,
vm_mem_add() works as intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86/private_mem_conversions_test.c    | 44 ++++++++++++++++---
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 814187d06fcca..6730923af830c 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -309,8 +309,8 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 		vm_guest_mem_fallocate(vm, gpa, size, map_shared);
 
 	if (set_attributes)
-		vm_set_memory_attributes(vm, gpa, size,
-					 map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
+		vm_mem_set_memory_attributes(vm, gpa, size,
+					     map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
 	run->hypercall.ret = 0;
 }
 
@@ -354,8 +354,20 @@ static void *__test_mem_conversions(void *__vcpu)
 				size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
 				uint8_t *hva = addr_gpa2hva(vm, gpa + i);
 
-				/* In all cases, the host should observe the shared data. */
-				memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+				/*
+				 * When using per-guest_memfd memory attributes,
+				 * i.e. in-place conversion, host accesses will
+				 * point at guest memory and should SIGBUS when
+				 * guest memory is private.  When using per-VM
+				 * attributes, i.e. separate backing for shared
+				 * vs. private, the host should always observe
+				 * the shared data.
+				 */
+				if (kvm_has_gmem_attributes &&
+				    uc.args[0] == SYNC_PRIVATE)
+					TEST_EXPECT_SIGBUS(READ_ONCE(*hva));
+				else
+					memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
 
 				/* For shared, write the new pattern to guest memory. */
 				if (uc.args[0] == SYNC_SHARED)
@@ -384,6 +396,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 	const size_t slot_size = memfd_size / nr_memslots;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
+	uint64_t gmem_flags;
 	struct kvm_vm *vm;
 	int memfd, i;
 
@@ -399,12 +412,17 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
 
-	memfd = vm_create_guest_memfd(vm, memfd_size, 0);
+	if (kvm_has_gmem_attributes)
+		gmem_flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	else
+		gmem_flags = 0;
+
+	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
 
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, gmem_flags);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		uint64_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
@@ -454,17 +472,29 @@ static void usage(const char *cmd)
 
 int main(int argc, char *argv[])
 {
-	enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
+	enum vm_mem_backing_src_type src_type;
 	uint32_t nr_memslots = 1;
 	uint32_t nr_vcpus = 1;
 	int opt;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
 
+	src_type = kvm_has_gmem_attributes ? VM_MEM_SRC_SHMEM :
+					     DEFAULT_VM_MEM_SRC;
+
 	while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
 		switch (opt) {
 		case 's':
 			src_type = parse_backing_src_type(optarg);
+			if (kvm_has_gmem_attributes && src_type != VM_MEM_SRC_SHMEM) {
+				printf("Overriding mem_type to %s to test in-place conversions\n",
+				       vm_mem_backing_src_alias(VM_MEM_SRC_SHMEM)->name);
+				/*
+				 * Use VM_MEM_SRC_SHMEM, whose size and mmap flags
+				 * align with those of guest_memfd.
+				 */
+				src_type = VM_MEM_SRC_SHMEM;
+			}
 			break;
 		case 'n':
 			nr_vcpus = atoi_positive("nr_vcpus", optarg);
-- 
2.51.0.858.gf9c4a03a3a-goog


