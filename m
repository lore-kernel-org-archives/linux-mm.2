Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B5FECCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13128E0052; Fri, 17 Oct 2025 16:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2708E0006; Fri, 17 Oct 2025 16:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16048E0052; Fri, 17 Oct 2025 16:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99B338E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59303C027D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:55 +0000 (UTC)
X-FDA: 84008704710.07.ED9BB88
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8056A14000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4OsKrnrz;
	spf=pass (imf09.hostedemail.com: domain of 3RKPyaAsKCKMDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3RKPyaAsKCKMDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ao2Kri++l8bJKnFCz6AaoQPgwufHNu91Ime+tmGl4cI=;
	b=SpYTUbmsq2l3L6TMVd0PhGgnlnPint3EULhRxQJqC2fjq0eK7dxU5KDB6OnbSS/voVj2w/
	1fuki3AHYx0L8kIC7A7sNfk6eVuAM86Nr2cfA+DnnMghYY6muORJah/sv7DWsTW6i/eSZP
	iYgSAKMlLZqvMgt3jQ30xczkx+uhAtk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4OsKrnrz;
	spf=pass (imf09.hostedemail.com: domain of 3RKPyaAsKCKMDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3RKPyaAsKCKMDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731973; a=rsa-sha256;
	cv=none;
	b=ZXY0tkAtYskhubvDy3E0HsvsWgLV1XW/6S5QHoNDPuOWwsd5a+lPvHQ1fMJaFvzqf/t8uh
	epAj9rdK2J99R7EnwnAbdZxy83U3xxH+wbTxl6drrZZur/E01nuQltZxDeHB4s0BsqIrez
	sg+2/AafNwJZ7B7WjFMuAWwd0uU/Zvk=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-336b646768eso2679881a91.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731972; x=1761336772; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ao2Kri++l8bJKnFCz6AaoQPgwufHNu91Ime+tmGl4cI=;
        b=4OsKrnrz5214YOdsg3aqB2fWWFsIB3x03WW3pns/K/TLUQ/tSmi0jTxSgWOZlEL9o+
         jGimIPUU+0EoiBLMlFWzdQBdT3+oDu04IpQj6ZftxRkuorcSSCkOxr5RPQt+ka1kzg/C
         fLvOvGfl63V/2gcbvYG1WPjfcBnP6SEuw9ZCC2UBHEA2m1qMsbde/kzC8kTeezq4GYKA
         BMeHVRha95AB56bAetSeYlewv5emWaDdJJU8il42me6U1F7WN5FTUuuos3Ozzwcp+mdX
         FrJ+7TXdGcuVlgTH1l2jossScWkWShPwiAWdEVFsNCjZVfZt50vEjEw4jtYHF/ZLVy4D
         fmcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731972; x=1761336772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ao2Kri++l8bJKnFCz6AaoQPgwufHNu91Ime+tmGl4cI=;
        b=D6faNIrmowEn6HfH2RXpJaVJmU25UGd32iL7nmAtFFTe+Z1bKjfw7N1nds3tXVSf+x
         FL+mqiIg1MkJwgSKGvhb5FLq3ptCb1YjrGq5TtoEhj+//SJLPYYkMcPVtGzSfIQSBtHU
         fjsT+Qa1uThPKq4hhpsEfaWBqCTd9YQ0mvoM2BI8sA2exe827nNVGJclk7lddO/y+EBN
         VFHeaXB2qFjpQ3xxatUEkmselavwxtDErtdXxkd3iCJ+l9YszanADXp2Tfbbsuerb1zh
         J7FFrj5MCHfCjgojmFiqbWZpIHe+RtX6eFVYdff5vyBul955kgyNUebqcPFbV0Z2igKZ
         Lexg==
X-Forwarded-Encrypted: i=1; AJvYcCXSIDju01y0mNGMe5UgS71HHvPY3KEnbRumFfAidhSpEgJstbFCMunrtFKc6URg2hKIjaZK62EN4w==@kvack.org
X-Gm-Message-State: AOJu0YwC7RCtH/tBXT5KdVeZ2xXLu+aaBY04leJG3v1+r1iT8xK7++6W
	N11upSB/j5JBzHIg8cTNrtbFuSGnRxF9KCf2lxabG3DiOx7iiPGqZpMUBX18bDL4aeTw13Uoc5I
	GxOKocI6f+40KVcqpXotdEETjCw==
X-Google-Smtp-Source: AGHT+IFKI0OPxPHpIm/VduWDdNt5Az35Cg66pdGdSmypT2yzUK++BzgJqMs1A6JN527BCeH9t7suOJAHUyZ4cW0VZQ==
X-Received: from pjbfa18.prod.google.com ([2002:a17:90a:f0d2:b0:33b:51fe:1a94])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c48:b0:32e:d9db:7a86 with SMTP id 98e67ed59e1d1-33bcf85313bmr6308556a91.7.1760731972070;
 Fri, 17 Oct 2025 13:12:52 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:55 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <5ee20908e7a67204215ed17c502a466a516d0ae6.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 14/37] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
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
X-Stat-Signature: gmhuyts48gqcrrmtsfynh1pxdfoaoi74
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8056A14000F
X-HE-Tag: 1760731973-949234
X-HE-Meta: U2FsdGVkX1/LTBfEIscVSy56jxhcEiWDaBUCfaiTXi7SykuKv9Ks9VmZbj6eynEBaFhw1AxZu9QukCLceqEp3peKapIJw27RMlCJiZrekZ51zAbRHHoYC8aylKbopYD4KNoOPYYhfaW6ZSCGSeqqbqDTN2a9ftSpf6FpZ6jbLGKRDMFYQXc6nSX2QV9wjQBPgH0hCvtUCd+bZ19oGgjjC04lENIJUckzlHtRhVjzmGFfbCHV8iI79we1ldyvmfqpc8EHQvfpUSFYvV8CG3lf4zE0hXINLuZwPx8PlN/IJYXEbyTyCLFQIsWHhkKx+E0BaQapORjwand0QYAwge49Kigvyci4ZoUMVr0U/mYZkBdveAHJ1j8//EJGjMmCeVvZ3BNEzdOuLyXdBUkE8nsPuzR9aCOtEvrZakYHwMaLv7JZyi2kT0IQF9bhZ/wKhM1Uu0wPO0jPoyTqxxdp80MPJKX5IMo1G/i82eWTPGSLj2ugZOVoc7l6qy9xGoR330Aq6463Zxq1OAHVh9g+fx/UV3AXqLZAMmdxnTHkzilq1hZe3pDNiYtWUq2bCxqKvC9dhUyamuvEGp5i+meXBibUoqHuUIst7NAmc61jVS0EN5d5pLe2uO9oKyqMDZWjO57tsf1GqAXkTe+Krid01utu6lyAejPZ4la0Q6yxChNHBRHfcNum01Jq9Uw+HXE7q2SXjtj1nezl1KzEQIwHwpqKyfNqJKjpFeLgphe4GXqS1aCUEzhNLfub5YZikYwwT7fYKoRhGhDqklyqeWONT0leTMTpUb/rKQO2bG4tavM9iO1KdZkrvXWapB0U9BA/3pTGd3awCsUPYKt92UHhnO4YftIsOLn5SWQZjGbuCT2eVSeHe9wNswue+V8wi4O/VegovW7IghaHRTUItCY5L2qecBHvSTvkbNEbi4O12teO1sPd/nG4BsD8rVK1rxSwlDmb2sO92yWMtlxzX32+O8l
 0wqpObgU
 dqZEgiL6urzdByHbEJQS9GUwGtK2JdIOMDiPq+3FT0NvugyYHArclJ3omrqpiO09ol3UjpcVt1wJa1MEHNULohc/mEiWAwkMEBsZUYQlAea8sLwwiFZTTST8hQW2aKHVbNXrXDBDaeH6YYVqYsrEJSWekLkDo2NviBwAZBltTsbUwpxQTaVJp9igLpsoL0AxomwtiSZqMLeMvwua0jxIHnws3fPYqZEApHMiRD6YzT3dzZKGaOPu+K63nA5COrIxqMifZcOkT99qRLhBWv6FmpPFLZHNkfmYibaCqi+8TTwEkg1yD1G8AqPYBDHWGsm8LhKFBe7vTiAvMY+cNncUK3ZKIVPr5QYELNamJsbtqCZhNg4s6yxjziMeFWnOsCbvs08SVHat8WVEam2jtP9DCI0s/4YQlD3cTxatuY1sa0Azxf66Zo9xMQ2ep7BruKfe4JQIXd0iJrzlUuv8qIzK+3+zkCiHOjTCk/gHEpwwtJysAR7Fb6EVvjHbHY2Sugiug+cUG2L+foIISrpbcD8I0VHJI48j7dcUO32PUJ8MwcsB8FX0ZnyS3WPCvsgZkXN6hCfkIbbfwgStKBQC1URdF793zvIRv1/p5OpTC/JJIj7zA/6sQx4MRRCCercbfRyCLVGeqhnVB5ByF7x5Ivwzz4NotUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

When adding a memslot associated a guest_memfd instance, create/dup the
guest_memfd before creating the "normal" backing file.  This will allow
dup'ing the gmem fd as the normal fd when guest_memfd supports mmap(),
i.e. to make guest_memfd the _only_ backing source for the memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++-----------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index eef6de9a7f4b1..e35c65a173606 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1026,6 +1026,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	if (alignment > 1)
 		region->mmap_size += alignment;
 
+	if (flags & KVM_MEM_GUEST_MEMFD) {
+		if (guest_memfd < 0) {
+			uint32_t guest_memfd_flags = 0;
+
+			TEST_ASSERT(!guest_memfd_offset,
+				    "Offset must be zero when creating new guest_memfd");
+			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
+		} else {
+			/*
+			 * Install a unique fd for each memslot so that the fd
+			 * can be closed when the region is deleted without
+			 * needing to track if the fd is owned by the framework
+			 * or by the caller.
+			 */
+			guest_memfd = kvm_dup(guest_memfd);
+		}
+
+		region->region.guest_memfd = guest_memfd;
+		region->region.guest_memfd_offset = guest_memfd_offset;
+	} else {
+		region->region.guest_memfd = -1;
+	}
+
 	region->fd = -1;
 	if (backing_src_is_shared(src_type))
 		region->fd = kvm_memfd_alloc(region->mmap_size,
@@ -1055,28 +1078,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	region->backing_src_type = src_type;
 
-	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			uint32_t guest_memfd_flags = 0;
-			TEST_ASSERT(!guest_memfd_offset,
-				    "Offset must be zero when creating new guest_memfd");
-			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
-		} else {
-			/*
-			 * Install a unique fd for each memslot so that the fd
-			 * can be closed when the region is deleted without
-			 * needing to track if the fd is owned by the framework
-			 * or by the caller.
-			 */
-			guest_memfd = kvm_dup(guest_memfd);
-		}
-
-		region->region.guest_memfd = guest_memfd;
-		region->region.guest_memfd_offset = guest_memfd_offset;
-	} else {
-		region->region.guest_memfd = -1;
-	}
-
 	region->unused_phy_pages = sparsebit_alloc();
 	if (vm_arch_has_protected_memory(vm))
 		region->protected_phy_pages = sparsebit_alloc();
-- 
2.51.0.858.gf9c4a03a3a-goog


