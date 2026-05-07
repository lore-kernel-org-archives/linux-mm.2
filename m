Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E5FBCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959416B00DE; Thu,  7 May 2026 16:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870576B00E0; Thu,  7 May 2026 16:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75EC86B00E3; Thu,  7 May 2026 16:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D70D6B00DE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:34:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1739A1405FF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:39 +0000 (UTC)
X-FDA: 84741777078.16.C85FE0B
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf17.hostedemail.com (Postfix) with ESMTP id 145B940008
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i6EDJXGG;
	spf=pass (imf17.hostedemail.com: domain of 3W_f8aQsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3W_f8aQsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778186077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3rSsfG+RQhLqlg/UzpmHhS2dOMMTtnfzAhKgDM/p2is=;
	b=Qs15kewXpD83bT5TpoZvAYii8VCNj6dSdPWyX7y77kOdUhjXjYMnjzqHnjzguhq1Wr/Ghw
	BXoyk72S0mRlOuZz8zpYFENcLltcPGHcivVX0wj+8IXcoar/e4TknEPyGdN5VF91b+ks2t
	DSWEZDv9kc+/EUOSpHH+VTPHcMAGdtU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i6EDJXGG;
	spf=pass (imf17.hostedemail.com: domain of 3W_f8aQsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3W_f8aQsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778186077; a=rsa-sha256;
	cv=none;
	b=HeNesVtdpaRhbvC0B71r1kHpQJ+aaU40A8jUuLLK7CUADbe5MZ3wnyDoyxv4WEZcTkbG2K
	+WH9a1vj45LyaIpsQ8AdKsi2o/2O7AclTCIe/Hb+MarI7Yr7UVziHyk5E14CuXkf5TwJzK
	1r1ggB3TDnP7+APYmCulYbzEuQJoczA=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c70f19f0f37so764673a12.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 13:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778186076; x=1778790876; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3rSsfG+RQhLqlg/UzpmHhS2dOMMTtnfzAhKgDM/p2is=;
        b=i6EDJXGGbHn8rv53vprPQjtcR05yOmUCoi7EBz/0WasiSAk8Bg3pEeBGI0ZvgPo7bX
         YjsCVEXWdijegJ4BKehcaP0lGVH21eCyPh8DZxwvTXS8IjWkBjalAw19cgBryb3+oX0f
         fagWIO7HG8cKtDEZjxPbWyQe8fhpasPhhtZ52/q9gHe26oFGGoU/TLdqs9A18mv9TYD1
         GLwvE+fxkLF6KkyA5f5L53BULYQ/28XcbIoCVd9b7ICyhp5nrWx0ULRFFNkKXiZul8UB
         txRCpRMWpR9ax08evRtJykfSIp/nzPIF/IXlkCVhLsS5lmcELfNn3PWGFG9bOgJvc481
         GGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778186076; x=1778790876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rSsfG+RQhLqlg/UzpmHhS2dOMMTtnfzAhKgDM/p2is=;
        b=su7xdzQeF9wAIQ0BfLvK8pDfBuJ4fU2bMny+qxrb45RQnkKT0JEiduInZRuMeE1uQP
         q/9H8fBAt4wcWYtvpErC10pXeqwepY7fDRS0tqTJOi4ts7lzy9DmnthlB6X7DL5r7nHX
         93ThMT/+/erguksImQDty9BCauXH6iCMX+WjN1RZsBC/SqIJRctkb+38bwD0zM7dLmOJ
         7lEXOeCtvj7DayFI3mNqcFy6mmikwE0oiXTUZntqIG5k6PK+qfO74Ml8ylQUV7l64Kp7
         AwuzfLCbsZ1wsAQPJ/viKIcg9IhqGD26pRJ/57TBdPr8IZ1E8PXujqII+8YQTcOPUew2
         hFng==
X-Forwarded-Encrypted: i=1; AFNElJ99odhjty0jH5Ug3aCCbIVKpSf7/9yZUvYGNI/DlWONHvk979A8p2e+TXMLWFTKAJKd+/leTFZE5g==@kvack.org
X-Gm-Message-State: AOJu0YxDk8Ep/PWbg3WfyiNu4Xuwn/HxpORrnRP3mApJQBpz8pBE7xRv
	zlhqFU8sV618cFFC1KF20hntwqpSHTt+d+B/VbJFr8DSKTzcLGtfTvqCsZqL8fapRsYKmj9KDV0
	QiDuGRRF70ojdxnOqqaDwlXoPZQ==
X-Received: from pgbdp8.prod.google.com ([2002:a05:6a02:f08:b0:c76:8ec1:5090])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a108:b0:3a2:f05a:795e with SMTP id adf61e73a8af0-3aa8be52328mr4117250637.3.1778186075304;
 Thu, 07 May 2026 13:34:35 -0700 (PDT)
Date: Thu,  7 May 2026 13:34:22 -0700
In-Reply-To: <cover.1778185936.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <cover.1778185936.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <47758a2b79c4bc570a17c9216929693953bdf5a0.1778185936.git.ackerleytng@google.com>
Subject: [POC PATCH 1/5] KVM: selftests: Initialize guest_memfd with INIT_SHARED
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, liam@infradead.org, 
	linux-coco@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, michael.roth@amd.com, 
	mingo@redhat.com, nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com, 
	Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 145B940008
X-Stat-Signature: 3d5q3dgc7wri6jqwjoxpggrwd3cngw8a
X-HE-Tag: 1778186076-704554
X-HE-Meta: U2FsdGVkX18XuaQ+eXC80k+MYysF54v1WjkqD8H1oz8ToJ8r2cHU8z1WSe8iFM4qAQyay9CLUIalVJt7pX3CjAhJyPILxDsWEhugYP4+3/ekKlgmZawJUQc1wwUvHtA5+zUajvV/7KYDYl/klxClh4kbo59T3t9Xr7Pez60e+mOwbWvseMjMh0lAJiLaJK2TdmJcXc9aA4StL0Mcxq13OIE8+G5zQGHbOytYBMBlb8zwCGnwZb4znU3Y8rGujrCph24wusIjxU6gzB5BgPkP8lcqbryVKU/29AWMLTDrRZ2DK0rB2OaOML1u4ePvl5jU091vcLk17xpJXsl2cDcMhZTOGx5pDFx49GXMq+5EiyTf3FyUQlNZ+Pr69I/q1pUw2PNxxYKseZh1ztQ0sz3/stx1V90DQiBQlgXCUoRJF3QTz0JF5+DKJh3yzjcNjjmLKGK6QpfLDPLubx1kc+9br5vPTe3HVwY5fqGoRpUUaSTMiW1RcVVDcBM8MEuxqSc0i5peqfP3YsK3pdRFH4dsqTVJFJWWDgGXqVnHtoR15U2GGAzLAFXP20c7aRMJUPfILqQCcgBokDucLq4DdfFUCXGlNqYRThshAJWimeSA5qd267MUFd5AfooSf5fvYouIeho42vcCa/+gTnV3qbJIRLVuxFBeSr1h+eyrmo0i89RVQ7U+PEtIn3q/r48bHHySCOZzld4197tOwopCtg9qjj3dSrF01Fkx4WeXTtuB2Jlq5OMe1ZSnNdZe4VliIGAatG9h7RvMfCYAk5WTIToK91qsWKg2oYNSDxIeVAyRB1+gFqgfnMVD1VbpjS+Emp/R1NX5BGbWE4YCIXn7xoVgy9/Wd21m6Xbb8Kqs6rgIvXzSsmRcgmWqCUSXI+tznad62iD8/D3TDxPiHkOKIMR96XvnIuc/oDZNjEGt9hiVXDaHyp2fdzEZd/kdtmOPlpc1PDYxrxx4Rf9y6WaCdfJ
 kRIKZsof
 sajHL47yfGPsrzdAKzpdRJ+2Ol8LpIE6uzpAdXMWg1ttH+YWzgjIqOh9Zz8xwRUS4DSLYLFV3emETE3PlRHcHkSMYRSKhYq1U72HxLzqrIZZvHnQlMwGk8ZaE+vp7qDBpbkftMMwyYNSi5I0dxI4fNB6ptjo6pvE9iCrU9Z018JaIv/W+gd2yXxcX57nYkETQtvFxa0gNu7j12k8PLKfftwg3ITYAPapU2AMvwuV4jGf0Ao3zUGLyHuBRRmaqAeW/cpANCvwmAg350+fRGXLnQGapTHGqmTvLOUwyu1WIVX7mLJRyDmYzKPmSjvyWNQ4iPXSl0wyrGoPDuOWepnTfzl0c04LgGOACcmcCgU5krUtc2nEP/H7E7HiEzv51q64hia8jp9zB+K0+4urff8/Zkt4CB2y5hwzofJysSMBVjhxaqEyZ6lIWE99XHL5AutSddFrBmEF9kMTtgLDnE8XnZoS3bZdVDi0HVh0AMppSpCDPWRBXlB4/mpxxEWQB9WU+32ZqvEiUfuy3nocBSeBiDDTK097PSofkyvAqYHsIF8K65JmaDFqaMCggJe/+aBX9LcGhMKokkFVPcYbezgBz0cs0y7Truned82UE+4QSluIwRHLDz0r+QYJAgV+Xe2UrgGb08mdbwQ5BhSXXXAi916cLTXYc10NKaa07f00y0yEyFoMc6yfCrLCikLHlsuhNcPAwdEUpvucTfk4DdRRJCIQ2J9K/Vxxm2VL/5keacTgBEyKHHaJ4hTIVz301uhDRoAe6gRvVtddo3Rt+3Zh4S7EnXGOSBeT0Bc4X9ecgCr/Fsd3unNwQIsW5bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize guest_memfd with INIT_SHARED for VM types that require
guest_memfd.

Memory in the first memslot is used by the selftest framework to load
code, page tables, interrupt descriptor tables, and basically everything
the selftest needs to run. The selftest framework sets all of these up
assuming that the memory in the memslot can be written to from the
host. Align with that behavior by initializing guest_memfd as shared so
that all the writes from the host are permitted.

guest_memfd memory can later be marked private if necessary by CoCo
platform-specific initialization functions.

Suggested-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d1befa3f4b305..a377e5f333116 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -483,8 +483,10 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 {
 	u64 nr_pages = vm_nr_pages_required(shape.mode, nr_runnable_vcpus,
 						 nr_extra_pages);
+	enum vm_mem_backing_src_type src_type;
 	struct userspace_mem_region *slot0;
 	struct kvm_vm *vm;
+	u64 gmem_flags;
 	int i, flags;
 
 	kvm_set_files_rlimit(nr_runnable_vcpus);
@@ -502,7 +504,15 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 	if (is_guest_memfd_required(shape))
 		flags |= KVM_MEM_GUEST_MEMFD;
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, flags);
+	gmem_flags = 0;
+	src_type = VM_MEM_SRC_ANONYMOUS;
+	if (is_guest_memfd_required(shape) && kvm_has_gmem_attributes) {
+		src_type = VM_MEM_SRC_SHMEM;
+		gmem_flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	}
+
+	vm_mem_add(vm, src_type, 0, 0, nr_pages, flags, -1, 0, gmem_flags);
+
 	for (i = 0; i < NR_MEM_REGIONS; i++)
 		vm->memslots[i] = 0;
 
-- 
2.54.0.563.g4f69b47b94-goog


