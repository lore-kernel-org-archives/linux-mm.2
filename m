Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED75CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 615BE8E0055; Fri, 17 Oct 2025 16:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522B68E0006; Fri, 17 Oct 2025 16:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4118C8E0055; Fri, 17 Oct 2025 16:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1A98E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E84D31402F8
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:56 +0000 (UTC)
X-FDA: 84008704752.05.7A4020C
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25E73C0010
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G2qUso1I;
	spf=pass (imf22.hostedemail.com: domain of 3RaPyaAsKCKQEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3RaPyaAsKCKQEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731975; a=rsa-sha256;
	cv=none;
	b=8nW9J8ydhBJlzFT3f4dzYG4FPNI0hZyYSSS1gbih9wRyJT7rU+556yYVdo6afsWb+fOgzo
	25uZIxo5EoHt1Ti3Es/x9Lhb12MrmGc20ySzcmfrgvCbkayT+aSTGKi/Jy64IIqpqGIae7
	hQ2I1kn5CfYhMnI6j5rJLqdlQZQUZCQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G2qUso1I;
	spf=pass (imf22.hostedemail.com: domain of 3RaPyaAsKCKQEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3RaPyaAsKCKQEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aywn3p1OuroHc7cbdG3tEKHp3pq1LL6GKGiRpb5Sgiw=;
	b=Fkmazw7ec4yzRKa8e+SpL1jXr5wnx/NE7vz42+nIDV2hB1qNoF8/so2WLTIFH0jF3KKycG
	6MxjomDXXTz+geFgGdLhcqTdFrja4y1tiufOptaYzyR04Pq3Ls04PQgAjh8U5zYdNWLiLg
	PINwMf/3TstljawN0GIspdLGY83DKDk=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc08so4999627a91.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731974; x=1761336774; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aywn3p1OuroHc7cbdG3tEKHp3pq1LL6GKGiRpb5Sgiw=;
        b=G2qUso1IbeWwDvcRsMRngZlucdIzXVgFHmvpyFSVV85iUNwGRLQOxpWp3tvhyACh2U
         lfPks4GOtPwHualg/Oap3g7baPkYjecKjibsGWhyLvksVCCj8k7Zzhv2N5TEm5vBhvMX
         t7cGTnKvtM2VzU0JsnAp59QndkMx5HPdweJpJBIpVK9JQXJuqbmbGdQQshtoWa6r7f0K
         1kWxUC4v6atdWBrbVLkZPo5mO+W3qRUyeUtEFaJ2ONc6N2MFUnObriBR5yfo9gDf3ybh
         ywpM6IUp7ODL8Z5ivC1oHq48D0zpw4sOj9U5qqZh0YgTdxUpykmXIvOHtMtEeN3e9sTA
         s/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731974; x=1761336774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aywn3p1OuroHc7cbdG3tEKHp3pq1LL6GKGiRpb5Sgiw=;
        b=JGx7O8wZ7javLh0MiloFxL43/1+BNHdBdpKZ7x9b1cfuT4Z/jmHCg7jrOQVxGy6sSI
         YlKOi9jByhV2Cl0ZJecywOF0vJRXC2iyGqr7iRNhiPDBfPgE9NtfbvI+77ebo1PhZJo7
         AfrKrpacd3xHDqo8f3hAdVPWQ0ZrSHZh1ncP342XD/J97OvxfPIDx0KhC3uT7uFWLV6y
         ynjjTJ/Uw7zIlBK6y+a49vnItU2LhkgzZ2zglwyB0sZqJefanvka0bIYoNwjXITsJCea
         ZznlrYDE1MiW0BRrKVaYvmwIeuvfZdK0XBYVj5Av3dMZYSAyivLudOUKuQ6uZtt/yB47
         rH3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXe/DY2aXt+Mi0Okj+iUwJNqUOFfF+o5SqyZ3P52m9DFKg0HWCKl0FMpNiTOJVY2pUQ6KxjRdSwug==@kvack.org
X-Gm-Message-State: AOJu0YzMu8bpxaU9lVJ8xriDwoYsAmXCnFu2+lxrY1538GkzeCU2F9hn
	gSOhDkDZ+NNgc+Y+SPpoDk/hFmhg1m5i/IjZUJgcXLLVza37mbQGOhEicVgUne3itqEDrEFixcl
	57o9dGCoZlKcEwWMrmp7kD8Rrgw==
X-Google-Smtp-Source: AGHT+IGCFLZDb5cyrEN1NOozFPEt/0O+VXA7q/ZXGXzCvaMHmS50bIpyR021wTre8w3PZtNhA8jj0eOMny4OOvLYpA==
X-Received: from pjyl20.prod.google.com ([2002:a17:90a:ec14:b0:33b:8aa1:75ed])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3f8d:b0:33b:be31:8193 with SMTP id 98e67ed59e1d1-33bcf85d59dmr6510945a91.6.1760731973870;
 Fri, 17 Oct 2025 13:12:53 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:56 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <19167e80b65bce484d91c7ba4d1967a7d12ef90a.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 15/37] KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
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
X-Stat-Signature: mqzsko93gwdkd97qqwiai6f8dznk6t9c
X-Rspamd-Queue-Id: 25E73C0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1760731974-380558
X-HE-Meta: U2FsdGVkX1/GGKPkCxZ7wlde17hsSQsjkGBYgnL/+A60mYyf+xdcSTSmEGHRIJ5SOOFcVWclwfG683RDJKcVOLfe2ZE0fj7YTdv4zFh9+yZqRIKn897FDLFsiBJzMOYTTfY3gI1io2HBDRQVOlABjn3O1pqHV93oVUCGPGl7NhF1DG+JyWP9VWR5Ga6u/Afz0921YlDPmWCUfZt/iLl9hIsZGDDmDPTKSAijk6FdSn/IHc8/k8vSS4USHZavSWnLoi7hVvzrSVMPx3y2gIbDL4M6XtWrxBsysjdNsezsErzQEE6X23+AjDPHCkDWZ7l+UL/POjmKj9dod1gOfPJXEmDSXQPHAOM8etjdTs0COQI0r6TP76jho2sWi7lucYD6vWa24NfTw2QyLWRJt+87ZtSFVZ9ARzfY9KW+tOxAzYYlh/8dJERDFLXyR+/zCnXXl4goZCjyIkKwdBd1/0PzTJSgVqqxKF6DBq+XRWryQAt7mu5VUy2e4qnq39c2dBf/M0yPosnphPktUrT2C/fzepPYYsWGHJQcvJyRJpHjRoMpOXG4xv4/uklvggciGPKuYslzaHKN+dkEcFsxk/mnYSWVZBAX+4sNi3dZfK5qn8wp1S3ye74hgY/9GOYU/RZGu1RWJMZguoNt548VlUD2SjLOnMRJaWEUxQyfSVdt0GvXWoru5ccziT2Ori6T9LhO40I15QUZvZvaE+OrRYa0vy11Ii21x2jc1n+g1UzcQmKJoNQjjR+aVOAd5PyMLfrASQsPs4RSThyvZQkZoQOygcHNOZ31R8TDZ4fKDhE6JmNjPlkgbglXcLdTiTnPXs1aDNzd32Y2J0MBBKShIcCPJ64nVyFVExFNBWG2T/CSrYcm6gUx2htL4r3MeLedv3cZrkILTrZrgHN5foxMORG6KXz9AM2+VWEErFcdhbDwW6vO0mavQMKT1Q7ruFySTVGgqgasQLCqtgozUuu73Vb
 iLDUwNLc
 1oXBlADq4/1RcYhb52TwW4vj4nYz4SOUzdVFcXn0BqFDKPW8bfbGTbOYZj9HClquMoY96a3ZP+w9y4XYfE4XUpixKyNWCIz6byaaT8v21+8eGBifMAgxnrbVlEhwgScclmGDd/XHGV2mOSeLwW0u87YTlGt2/vl0TRjXrwHfc9q3Y8kqwQ+2VkBVoKUOCJ47nUPQMlCrNNFJF4zaAIwLf4bhgalH0OUV/5IPDq4+ZRBDsP3dFpaioP+KchnnZkhLpBc4dLzYKfCjIviW6iAakgjEuLt7QXzqcSh1JayqLiRZXPjuN4sIhaJdg8+SGlvqqMzCOqPJ2C/LTImsx4obrsBXqyErjUuf/G5ngZS462ySpPZkAFL0dYDbjyX21MSYrA3AMW2gm0cGr5/ppv+lAgbmPdJlTBAgvbpijKVPOSbgKyZEYyVaPNFd5JWJTgrQrCnSXrEYvRb28LCugJ7f585Y8MICAptevsWDeCG8lP0zO0PKCZxbCtzy1RPeLEvW7UFdjx9ri4jLZlg3RDQIK3FxaEWM/+AL7myT/atlMK6QZtbLLwM6YuOnRnN+anT/ShfTiuial9MB/QhM4o1DH5u563Txjc2VJFgkAoUdQ2qcMW/4uqqfXzlAL0PQin6zEHyPnIy0DitCuaXaf2E9Wcspz60Yj3Fi+ZKMhEnVgXq4yqzCbObQ22QjLI4h3HEwhXxjl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Rename local variables and function parameters for the guest memory file
descriptor and its offset to use a "gmem_" prefix instead of
"guest_memfd_".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e35c65a173606..8b714270cf381 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -912,7 +912,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 
 int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				 uint64_t gpa, uint64_t size, void *hva,
-				 uint32_t guest_memfd, uint64_t guest_memfd_offset)
+				 uint32_t gmem_fd, uint64_t gmem_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
 		.slot = slot,
@@ -920,8 +920,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
 		.guest_phys_addr = gpa,
 		.memory_size = size,
 		.userspace_addr = (uintptr_t)hva,
-		.guest_memfd = guest_memfd,
-		.guest_memfd_offset = guest_memfd_offset,
+		.guest_memfd = gmem_fd,
+		.guest_memfd_offset = gmem_offset,
 	};
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -931,10 +931,10 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
 
 void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				uint64_t gpa, uint64_t size, void *hva,
-				uint32_t guest_memfd, uint64_t guest_memfd_offset)
+				uint32_t gmem_fd, uint64_t gmem_offset)
 {
 	int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
-					       guest_memfd, guest_memfd_offset);
+					       gmem_fd, gmem_offset);
 
 	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION2 failed, errno = %d (%s)",
 		    errno, strerror(errno));
@@ -944,7 +944,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t gpa, uint32_t slot, uint64_t npages, uint32_t flags,
-		int guest_memfd, uint64_t guest_memfd_offset)
+		int gmem_fd, uint64_t gmem_offset)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1027,12 +1027,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		region->mmap_size += alignment;
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			uint32_t guest_memfd_flags = 0;
+		if (gmem_fd < 0) {
+			uint32_t gmem_flags = 0;
 
-			TEST_ASSERT(!guest_memfd_offset,
+			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
-			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
+			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
 		} else {
 			/*
 			 * Install a unique fd for each memslot so that the fd
@@ -1040,11 +1040,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 			 * needing to track if the fd is owned by the framework
 			 * or by the caller.
 			 */
-			guest_memfd = kvm_dup(guest_memfd);
+			gmem_fd = kvm_dup(gmem_fd);
 		}
 
-		region->region.guest_memfd = guest_memfd;
-		region->region.guest_memfd_offset = guest_memfd_offset;
+		region->region.guest_memfd = gmem_fd;
+		region->region.guest_memfd_offset = gmem_offset;
 	} else {
 		region->region.guest_memfd = -1;
 	}
-- 
2.51.0.858.gf9c4a03a3a-goog


