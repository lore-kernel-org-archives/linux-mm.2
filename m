Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE436CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415B48E00A2; Fri, 17 Oct 2025 16:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3306D8E0092; Fri, 17 Oct 2025 16:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2788E00A2; Fri, 17 Oct 2025 16:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03A378E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CEA08B8045
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:33 +0000 (UTC)
X-FDA: 84008706306.02.F4113D4
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10D6E8000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r+zcZ+bO;
	spf=pass (imf30.hostedemail.com: domain of 3aqPyaAsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3aqPyaAsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjvPBfWPeDDoysxeGmNxm2XVFXiN0LW7diKaU3jXVt0=;
	b=ePptQXH6kP0ywY4T0SvwVK7hiEqPV70ltJJzBZsnL7LCIgHhpJHLqNq/QYlUWdJ54eJx8t
	CG0RjMDUcV6hj+jU23PFtFuSGcBh1iwjyGaMMz4jEGXlw2G5dP8WuCcWDfJiTwjLe8i2BA
	OfHNXF/fgncbfCCldq6TCGEpBEWvSRY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r+zcZ+bO;
	spf=pass (imf30.hostedemail.com: domain of 3aqPyaAsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3aqPyaAsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760732012; a=rsa-sha256;
	cv=none;
	b=ks2+OUFgEgQ0emizUZzduU1N6ECUoo3z5lkowdH0VeahoYGIN3mCDyz/Tv4gMZdPw5m22L
	y4UHO+7gxYjybv8hNuDs+DZyldQghVrjyEbSWvWEhpZpA+jpd1c8YxSbXQid7bQQIJNI5J
	jVWXwFC85wtTZ7WR4lzta0Gm3G4+x/0=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7811a602576so3228140b3a.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760732011; x=1761336811; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gjvPBfWPeDDoysxeGmNxm2XVFXiN0LW7diKaU3jXVt0=;
        b=r+zcZ+bOCdoeC9K2WjV0Oy0Q+FzrDTmCf53Pd5EU8CSkH66tCfwJas2vsXDxEZX+nA
         NvJBSSq7aA+I9pAUQwLklL/MqOvRvrURulicvNDsFtsubfDd3UUh50y6fM5YMpJJX+pK
         FgsVKzXTL2BOO+de0MrabLj8sF9hz3h3WVG8FemAuYM3es/kk9jmrDumXDGfxtUbUMye
         NjzS/IKw5lF2Xa73+HnTtEQoOxACpZS6vnMxjKPWZMmFhoABjbhFkZofkEG2xW+JMWOD
         mqgqDM/3lwMhic1GKEDLPqeH934LO3AjAttzPgPm8/wIS7IXKHj2aTd12aA6UM0AufIi
         80fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732011; x=1761336811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjvPBfWPeDDoysxeGmNxm2XVFXiN0LW7diKaU3jXVt0=;
        b=ElKTkPWMVHv8i8xv7UCcVdjk0I+4jU5XOym5GzU+BGQUTqd/y+AA6IILZxNdBC41BF
         Rkp2Cp3Wni0P9jkuZlK/8EgqJYDVh3kelalg2Xppg97OJtkQ+IwnbC0ffLbyd2sBId09
         FolOw7MEyA/rA3E+rrXonlx9l5FAr3GIva9rcjKt6BsXRtZlo9AlvK2sI9rdUPNm12yj
         /4CbNVL/MqUMbmtbGPCSjzii2FCX+sHuRrjspkHcK0j1PPkuk/ELnHHEpMtShyLRUzhf
         3eMmM8uzGHzXH5ZD+5VvAU8LgENFRRE0R9AnTc49LXq7K9fre4St1RUKNCbBDFK8BC1N
         KPlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWITm1dvQM7mtkEqxA6epCcAdLWUsVglQy68N8twIrjZAgnkTzK4ErybHvJxiYPZEtv8b70Ohzajw==@kvack.org
X-Gm-Message-State: AOJu0YzPkUgv9erTIdTpDs8/i9pd+BgmhxemMFkJncGsm3t5BO6f2TMk
	P32RW08ECaufk0jaGff2wRyo+mabpjMUTHGVvt8qN6n8sKLbQ8GMzfQ+WQlRb1Sco5HW5WEATfE
	OIhInGhHbJhU5dJDc3U+dwCkDKw==
X-Google-Smtp-Source: AGHT+IHIFgvKx4iQssAvfWvw05fzS3tjPMxtqzDzpUfFs2q0tZQVlLhulOrO+VXHlGdzU4khsfJPAu1rlwqetjJf8A==
X-Received: from pjbpj3.prod.google.com ([2002:a17:90b:4f43:b0:332:4129:51b2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9997:b0:334:9e5e:c2c2 with SMTP id adf61e73a8af0-334a84c81famr6743421637.13.1760732010737;
 Fri, 17 Oct 2025 13:13:30 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:18 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <f326fd44695d94438b6061c0c5881c6a17ad84d3.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 37/37] KVM: selftests: Update private memory exits test
 work with per-gmem attributes
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
X-Rspamd-Queue-Id: 10D6E8000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 614h9655jnxx7t5puy8nowweoqctx9ah
X-HE-Tag: 1760732011-437005
X-HE-Meta: U2FsdGVkX18CQ+MyGiIuiIvg/KuCTiGsyvObUcKY7+CxnSfP0WxgFJ04Lqhn5rDNV0jy2KEorszUOyvwIkkAg6X/NUalxVZvXAr3PoUUiSB+i0IzUa5VQjVqasIdQeHyi0/fvhIojaM2lFa3R4Xc835za1rr3yz/xAVC+H/EhVijJsk11o75JUX0HJl4wgKql3vLdx417X33XORTqUR3iw0u9RX+d6Vx51Ti/vAANo/IKMBNyeA3bZ9kqa1GN9/AjTvZAO/2bLgC8q6KOKTbx2O+bFEuMS5F2CchosKNi5jqh1xm17l9LcyHYu2CwlRFfXKBysOwTt3CNMDlNi3nCafYaWyeHFKSg+vLIVyiOlB1hxP2OY9LCEdruEJ2mFau24A+5vMsyp0ZI7LciLuOauGYmnN4zIwkbz1jUj3FP5vnFUTpJ8BJGAAlpBN0HbiGvA+RTslEqT9pVw5ZWcQNb8UT3IiFUQpwgXTgscImMVrDApgNclycMDuUfPbG0AJBvbc60CZQ05d//n/yKQuQyQBBZpSCbc2Oo7QwT46yGdv94nCCbFi08acwso3WYvMZF7itygifdHOWWMU/MpsEMY4OF0lmXNPAte7gu4lF1OI+LZBpCirgjQG5ZZ+Ca4XsjCpaVJi8pXprMm3MFZLx6/bCU/k4n3yigf9hGPzx9Ztx4v/YtmyRiphg0sZ3khi8zaU3p+8lufi6JYdpht7tIyeZV0GwU/tjlMLXSJ/2RIKoav936iP21sbW/4ptmAlMg/SYq5t9JfsWMgJLW4wUYI3lSgFjcG3IFyTadhoNMCVRr8DUGWkGLDwxDllb/hA9z38yfA4hw5Fh14G8B+/VbfPLvG98nA+t4v2brjeeP1OkvG5ekuyYrrroRrfa4IUJca48cVAozONL5BLgSteUJzxVL4x3uhCnsbGeOQMurTgS75l6R5E3LK3aKtOXZzfVdpmXulWNk7BvTyl88mj
 A2tuQ4a1
 jqy27ACGOuyu+l0u9bSc5Y6LTruq84q8ZH37B9oQ8fkRk/crxbLj1iIg2oYI7ffkvOsbw5k4hHgefP9M6Vv8hQtCX6yMav9kXMujILaaRdoRXZAOLlKwSCmQGmkSrTwjavczd6Mw+mFWchLXiNbDI9xaNr5i+HL5HQ67kWMQC1bvWempxwXSZ6K0e2T6x6Jr+NqH5XWQ7TINxJucX+FppKDstp8d+L12AsiyHOPaO+ZUZjpddiaOEY7QA0gSGdo0ZEMTqVQx8vbgs9lZiBQa+gQehwcFpc9NmiM+y5qJnxHYoy43SRG/OxW3tw+NgurxIqZ4DachMt1rJSOyxTaaTkqjCkmpWcd2/6hx82GWTo51InglK4HmWZ2v5kDaV4/SEG0yS306/I/UwO8Ed4nwyPEwrCJlSICq50ovjb8bcCtpmHblea3gWyVv8tTvOozt/TQNomLkQRGhr3fy8Qtl2TjMV82F8+4zRdSLXuvWGh+1y27hkhIyPnGquu/hoJTSZD3XMlPB2WakDk54rKm8hgNAmZA5232aknamaTqg8E8inX4DhsAeSc7SizbmkrVphpIdYzxU/HgvtN/kH7NPhhBMvceIqUIXcrNQpL3GHsoeNCJdDdkWmn8r7PSZL5tm+hq6mL6qCF6CHRx7LgGLpMKRiSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Skip setting memory to private in the private memory exits test when using
per-gmem memory attributes, as memory is initialized to private by default
for guest_memfd, and using vm_mem_set_private() on a guest_memfd instance
requires creating guest_memfd with GUEST_MEMFD_FLAG_MMAP (which is totally
doable, but would need to be conditional and is ultimately unnecessary).

Expect an emulated MMIO instead of a memory fault exit when attributes are
per-gmem, as deleting the memslot effectively drops the private status,
i.e. the GPA becomes shared and thus supports emulated MMIO.

Skip the "memslot not private" test entirely, as private vs. shared state
for x86 software-protected VMs comes from the memory attributes themselves,
and so when doing in-place conversions there can never be a disconnect
between the expected and actual states.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86/private_mem_kvm_exits_test.c      | 36 +++++++++++++++----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
index 13e72fcec8dd2..10be67441d457 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -62,8 +62,9 @@ static void test_private_access_memslot_deleted(void)
 
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
-	/* Request to access page privately */
-	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
+	/* Request to access page privately. */
+	if (!kvm_has_gmem_attributes)
+		vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
 
 	pthread_create(&vm_thread, NULL,
 		       (void *(*)(void *))run_vcpu_get_exit_reason,
@@ -74,10 +75,26 @@ static void test_private_access_memslot_deleted(void)
 	pthread_join(vm_thread, &thread_return);
 	exit_reason = (uint32_t)(uint64_t)thread_return;
 
-	TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+	/*
+	 * If attributes are tracked per-gmem, deleting the memslot that points
+	 * at the gmem instance effectively makes the memory shared, and so the
+	 * read should trigger emulated MMIO.
+	 *
+	 * If attributes are tracked per-VM, deleting the memslot shouldn't
+	 * affect the private attribute, and so KVM should generate a memory
+	 * fault exit (emulated MMIO on private GPAs is disallowed).
+	 */
+	if (kvm_has_gmem_attributes) {
+		TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MMIO);
+		TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, EXITS_TEST_GPA);
+		TEST_ASSERT_EQ(vcpu->run->mmio.len, sizeof(uint64_t));
+		TEST_ASSERT_EQ(vcpu->run->mmio.is_write, false);
+	} else {
+		TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
+		TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
+		TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
+		TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+	}
 
 	kvm_vm_free(vm);
 }
@@ -88,6 +105,13 @@ static void test_private_access_memslot_not_private(void)
 	struct kvm_vcpu *vcpu;
 	uint32_t exit_reason;
 
+	/*
+	 * Accessing non-private memory as private with a software-protected VM
+	 * isn't possible when doing in-place conversions.
+	 */
+	if (kvm_has_gmem_attributes)
+		return;
+
 	vm = vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
 					   guest_repeatedly_read);
 
-- 
2.51.0.858.gf9c4a03a3a-goog


