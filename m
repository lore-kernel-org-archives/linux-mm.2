Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B945CD6E79
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55E846B009E; Fri,  5 Jun 2026 09:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8366B00A0; Fri,  5 Jun 2026 09:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6C86B00A1; Fri,  5 Jun 2026 09:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 286FA6B009E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:42:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF60140116
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:41:59 +0000 (UTC)
X-FDA: 84845972358.12.3E7077B
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id 043DF8000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:41:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dltdmevv;
	spf=pass (imf02.hostedemail.com: domain of 3JNIiagsKCKsLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3JNIiagsKCKsLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780666918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUZLRDZINPeKp8iZBTkFhcKneeUpQ2lNxFBRVRcVkWQ=;
	b=SjwlWiYvUDxeaeVlDtcUXEq/42TCq64boWVLDc0WyVKSuSCjXDo95q9KJu+USEw77L5qRq
	JJeBRaThfvUr2N2tmA7UVF0KJX9E+ny3HVJayhFKZ+5WhIpk0XGu9AvV2F7G2tBnN+SeS/
	Pa5fVYgA8+5X0umvYJPpgv7Dzlpnu/A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dltdmevv;
	spf=pass (imf02.hostedemail.com: domain of 3JNIiagsKCKsLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3JNIiagsKCKsLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780666918;
	b=rRQp5P7IC2PQZZRufm6opBY7INEcdAsaCYT+z55PDmpeUaDqxNHi6h0di+FfY5xa2/5Ceb
	iYkwm61oI8dx6oZb0KKoc//ziohhOtyAZ6UsJgI0iEm432ja8m8g0lFNjAxVe8sv539gWb
	Yt0uMPELSuk1mvi26D5qJvmSKzEz7CE=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c0a81c1738so12934175ad.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 06:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780666917; x=1781271717; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EUZLRDZINPeKp8iZBTkFhcKneeUpQ2lNxFBRVRcVkWQ=;
        b=DltdmevvPsdKSu9qh+xa84f1AdceX0eA/YMyf1iX8kQ3zDsL9QKDmmuIG8GtbJD47e
         9SJ9GIpPpCujAZu5jeAvDWFnNsl/JYr+wlLKQgwqkCiDc/9CKxkpEdE+v0AF2N51GYQQ
         1ri1TecxKbQowZaAlaeJlelttvmk4YWLH/aNyahcrB7pRaLFOWAFhtUOoSmD7SyHsQP7
         1NTUA/1qoyj/R1LUARIiDgh0G8xc/0UpffbniLs1MGZs6ojG1qvVTAviNddI+5K9YBsM
         HFy4pEnLuVnDf8HNcQspDHrJpH5SCq+apRURzeJAbE3VRbg1a6NQF2aEYu+mb6lPljH4
         9qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780666917; x=1781271717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EUZLRDZINPeKp8iZBTkFhcKneeUpQ2lNxFBRVRcVkWQ=;
        b=oslF/LsheLphkVp2S5SzM3/8RMo5iRQ/OoY+5bIta5xi3CfTdd5q0WDNCIHwrxEUyu
         hGYnYYudoJZVFrOYEAsxu3+ElzAdktCdTMB206sH0Y84QrP/RHVphhdKzdx6ZztdCJpO
         G3788dnKUVkZatFCQ8Lzm6dOOqaz5AtkP39StKJ1YEV9vaKsnDB2FoFRA7Fu8vRkd776
         ufrNGaLwveJL7WvAU0Kc/aQZ5cc8WfktQtDAe1pxrMsbC7w3ALe6K2DvHKWtDKLXFmBz
         RL1cGmVghZeTwCUU+W5jykI1KPRBoQASBjyBUYQNRB1eBhCw7IVpBhGMoj3ATxrjWtjs
         3obg==
X-Forwarded-Encrypted: i=1; AFNElJ/Qnwd9+9/oVKBVsMQ8rtKo4YDSzDbJALgrVVWXkX0GZel7d7YxIV8POxfemv6jinBMC+ns2ACsgw==@kvack.org
X-Gm-Message-State: AOJu0YwTaS8OjIXIDEF3JqzmvCcDjIZZXBm1wzqBM33t3r0E3rT4gH3I
	3dMhVt3Fr513IDSiU1sV0kQibw2EFLkOU7xzaBsBbBnZG2TV4QEoey34z0IBlRRv1pvkgfW591a
	E9Ys2INff2bdM26QhAUsHSEwlgg==
X-Received: from plbli4.prod.google.com ([2002:a17:903:2944:b0:2bf:238f:8196])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1252:b0:2c0:c625:4010 with SMTP id d9443c01a7336-2c1e8102377mr37507845ad.32.1780666916287;
 Fri, 05 Jun 2026 06:41:56 -0700 (PDT)
Date: Fri,  5 Jun 2026 06:41:53 -0700
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
Mime-Version: 1.0
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <20260605134153.204152-1-ackerleytng@google.com>
Subject: [POC] KVM: selftests: Verify conversion works with TDX
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
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 043DF8000D
X-Stat-Signature: eb11c7siw6pex75xae8a56qbfiqftd88
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780666917-541440
X-HE-Meta: U2FsdGVkX18yvdRKPJbjOIXnSdO4Ji1Z1SGgOv5jGP0Ln9tDz/wy1BtdoPPVyjr5LhhwjQXsj0BoS/HD1l8btFFGeZI7YCSnhHi0zLbmmcbQ6xMv1XXRFJqRt8cN8p0Uv24BmJOs1sNC4KVYK1rhaW/FMAkzV9n8dVGl27OGXyeDu7RdEdj3nEHUSXJE7TQLNbyzjSaizn/0w5SSXv8s79j2QTymullanlnzx8w0cpBwTHKKWZH5Om6xQsECeKFbNNUo/84g6gmeclNvEU/Df8gmLGHTvVQRxNtne8xOkv2MmffRkxt3JNRh9WX0Zof0k/3kdY2sqtj9H8NvOqGYLTtMkBgY9YHecYaQBNeqTSgJkCUrtaBrVqSAtGfg3aVaJn4UQQkDlxsV4h8fInBY3419AJ/F/KsyB7zkC6abXgmDxUTfTJTgAGccsh9C/u7/9MpR/NnmTsiN6Urzlwwe60XSiBayp4lGudjwhq8QJ3cgccfQElG0DLf+HhtaGfTmVHwuMS9LalUBf91EVkitGH4m9Kgku5ibxWOtD+OkwBb/2Y/MbLeIMt67Pdaba0mfzHAgs1HF7xmHksY8YkbsUCpsy/fuN7TLfpgr9HMib9T9YugBX7q9cQakrTlqdg2E5dYP7m9kvKUl2LuviaFmnD4f35BTZGkcHQqoJAlvzgu+8cwKR+SCq6lDvUgPJqVgIqJEsVV1hXD3JpTFrdZuqxkeI6teNzqyxCb3rt448343I4gJpARGIJq2fQlZbqQXjsJZescM7XDRwT3nWmhf21SDvMMnHk9pvVGh7JZS39EO0wg+wo2dUqmCvZBmjm5k1gFiv26RCg3fMKNxER4Q1GhCAsjpXxrgndKAp4WOFcIlUucy3zFX0PnI43lyFW8A8H7Hu/IicCzX1TR4uqO84VpNmqpmqAx8IKElwuzQlXRVf1ImN0thHHklclB0zbNPwE9EJ4D6xkl1xtiGkEN
 ykA511AW
 f3HAZlgQrSYaF3Djh3Hz/OEjS0Yx0I8B4NAJs984H0h881/G3ABblGRtoLisYWud7/If45ArsgcJiBdbgjhWU9C/+ND7pmHzEl5rcDS3Yn3JJdB3Di+iXRJ6SLH/gbmsvnlTjmWrSiZHUc7C231dgO/wS4BAIXhXEgKoYeESweEiT2zlgDCad8x2vbxtLfj86slNGFY/uwiBaOTUdU9LVb1OKqIUOYECMUDJ2Tpfhfv76pTt+5Ct4ShQ+uKy26XRipjym/hp9p/qmoIu+nGTWPJyLX56dTN8A/u5kd0uS0rPTiiHw7ksOFgF04mhynJdhgDq710yI3NpEQWtp8FoR7rEh2viDP93ASJYICb3lTh3oPPInuuvrTe/uGN5bFu8C1Bt2q/KxY9Ly17gjLZWPOejco1wxgsKSxp+FDk6/PgeDMESgqSdWgK6I0cZjkVDt0nnWv7i6uThGgdrmWrGmXkYJfXhZLE1CY4BMlueBob9KJsyEi8MnFI6tou9a7RBvSrmYV0sJAFHBx9hv4pSKTWnTBMk/G8+aHsBiiwp0zKlfthMRK9pdBs4YrbVhfiwZaH+XvJvU2bOSc40Git37hfIYLdAB4rgVoVd0o8v3vXzfwQN7jkTyK8wwZYZzA8s3QaXc99uPCaayu6hqozL+cGSGhcJgqIYwIPyikzOhJOz35HYIM9o559kdOKqUxo/sv/PPEuexKbFnVjwMVXHvleH4R4KrcNRtS9UXUxaKzyOTWTM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This POC shows that conversions works with TDX:

1. Find 2 pages in GVA space, map those twice, once as private and once as
   shared. This avoids having to manipulate page tables in the guest.
2. Use memory as private memory in the guest.
3. Request to convert memory to shared.
4. Write shared memory in the guest, check in the host.
5. Write shared memory in the host, check in the guest.
6. Request to convert memory to private.
7. Use memory as private memory in the guest.

I based this on Lisa's series at [1].

[1] https://lore.kernel.org/all/20260521-tdx-selftests-v13-v13-0-6983ae4c3a4d@google.com/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 154 ++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
index 7cdcaf33b585b..093921af7d93e 100644
--- a/tools/testing/selftests/kvm/x86/tdx_vm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -26,6 +26,160 @@ TEST(verify_td_lifecycle)
 	kvm_vm_free(vm);
 }

+static gva_t conversions_private_gva;
+static gpa_t conversions_private_gpa;
+static gva_t conversions_shared_gva;
+static gpa_t conversions_shared_gpa;
+static size_t conversions_size;
+
+u64 tdx_map_gpa(u64 gpa, u64 size)
+{
+#define TDG_VP_VMCALL 0
+#define TDG_VP_VMCALL_MAP_GPA 0x10001
+#define TDVMCALL_EXPOSE_REGS_MASK 0xFC00
+	register u64 r10_reg asm("r10") = TDG_VP_VMCALL;
+	register u64 r11_reg asm("r11") = TDG_VP_VMCALL_MAP_GPA;
+	register u64 r12_reg asm("r12") = gpa;
+	register u64 r13_reg asm("r13") = size;
+	register u64 rax_reg asm("rax") = TDG_VP_VMCALL;
+	register u64 rcx_reg asm("rcx") = TDVMCALL_EXPOSE_REGS_MASK;
+
+	asm volatile(
+	 ".byte 0x66,0x0f,0x01,0xcc" /* tdcall */
+	 : "+r" (r10_reg), "+r" (r11_reg)
+	 : "r" (r12_reg), "r" (r13_reg), "r" (rax_reg), "r" (rcx_reg)
+	 : "cc", "memory"
+	);
+
+	return r10_reg;
+}
+
+enum accept_page_level {
+	PAGE_LEVEL_4K = 0,
+	PAGE_LEVEL_2M,
+};
+
+u64 tdx_accept_page(u64 gpa, enum accept_page_level level)
+{
+#define TDG_MEM_PAGE_ACCEPT 6
+	register u64 rax_reg asm("rax") = TDG_MEM_PAGE_ACCEPT;
+	register u64 rcx_reg asm("rcx") = gpa | level;
+
+	asm volatile(
+	 ".byte 0x66,0x0f,0x01,0xcc" /* tdcall */
+	 : "+r" (rax_reg)
+	 : "r" (rcx_reg)
+	 : "cc", "memory"
+	);
+
+	return rax_reg;
+}
+
+static void handle_hypercall_map_gpa(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+	u64 attributes;
+	size_t size;
+	gpa_t gpa;
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_HYPERCALL);
+	TEST_ASSERT_EQ(run->hypercall.nr, KVM_HC_MAP_GPA_RANGE);
+	TEST_ASSERT_EQ(run->hypercall.flags, KVM_EXIT_HYPERCALL_LONG_MODE);
+
+	gpa = run->hypercall.args[0];
+	size = run->hypercall.args[1] * PAGE_SIZE;
+	attributes = 0;
+	if (run->hypercall.args[2] & KVM_MAP_GPA_RANGE_ENCRYPTED)
+		attributes = KVM_MEMORY_ATTRIBUTE_PRIVATE;
+
+	vm_mem_set_memory_attributes(vcpu->vm, gpa, size, attributes);
+}
+
+#define CONVERSIONS_PRIVATE_VAL 'A'
+#define CONVERSIONS_GUEST_SHARED_VAL 'B'
+#define CONVERSIONS_HOST_SHARED_VAL 'C'
+#define CONVERSIONS_STAGE_WROTE_SHARED 0x99
+
+static void guest_code_conversions(void)
+{
+	char *addr;
+
+	addr = (void *)conversions_private_gva;
+	WRITE_ONCE(*addr, CONVERSIONS_PRIVATE_VAL);
+	GUEST_ASSERT_EQ(READ_ONCE(*addr), CONVERSIONS_PRIVATE_VAL);
+
+	GUEST_ASSERT_EQ(tdx_map_gpa(conversions_shared_gpa, conversions_size), 0);
+
+	addr = (void *)conversions_shared_gva;
+	WRITE_ONCE(*addr, CONVERSIONS_GUEST_SHARED_VAL);
+	GUEST_ASSERT_EQ(READ_ONCE(*addr), CONVERSIONS_GUEST_SHARED_VAL);
+
+	GUEST_SYNC(CONVERSIONS_STAGE_WROTE_SHARED);
+
+	GUEST_ASSERT_EQ(READ_ONCE(*addr), CONVERSIONS_HOST_SHARED_VAL);
+
+	GUEST_ASSERT_EQ(tdx_map_gpa(conversions_private_gpa, conversions_size), 0);
+	GUEST_ASSERT_EQ(tdx_accept_page(conversions_private_gpa, PAGE_LEVEL_4K), 0);
+
+	addr = (void *)conversions_private_gva;
+	WRITE_ONCE(*addr, CONVERSIONS_PRIVATE_VAL);
+	GUEST_ASSERT_EQ(READ_ONCE(*addr), CONVERSIONS_PRIVATE_VAL);
+
+	GUEST_DONE();
+}
+
+TEST(verify_conversions)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	char *test_hva;
+
+	vm = __vm_create(VM_SHAPE_TDX, 1, 0);
+	vcpu = vm_vcpu_add(vm, 0, guest_code_conversions);
+
+	conversions_size = getpagesize();
+
+	conversions_private_gva = vm_alloc_page(vm);
+	conversions_shared_gva = vm_alloc_shared(vm, conversions_size,
+						 KVM_UTIL_MIN_VADDR,
+						 MEM_REGION_TEST_DATA);
+	conversions_private_gpa = addr_gva2gpa(vm, conversions_private_gva);
+	conversions_shared_gpa = conversions_private_gpa | BIT_ULL(vm->pa_bits - 1);
+
+	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
+
+	sync_global_to_guest(vm, conversions_size);
+	sync_global_to_guest(vm, conversions_private_gva);
+	sync_global_to_guest(vm, conversions_private_gpa);
+	sync_global_to_guest(vm, conversions_shared_gva);
+	sync_global_to_guest(vm, conversions_shared_gpa);
+
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	test_hva = addr_gva2hva(vm, conversions_shared_gva);
+
+	vcpu_run(vcpu);
+	handle_hypercall_map_gpa(vcpu);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+	TEST_ASSERT_EQ(uc.args[1], CONVERSIONS_STAGE_WROTE_SHARED);
+
+	TEST_ASSERT_EQ(READ_ONCE(*test_hva), CONVERSIONS_GUEST_SHARED_VAL);
+
+	WRITE_ONCE(*test_hva, CONVERSIONS_HOST_SHARED_VAL);
+	TEST_ASSERT_EQ(READ_ONCE(*test_hva), CONVERSIONS_HOST_SHARED_VAL);
+
+	vcpu_run(vcpu);
+	handle_hypercall_map_gpa(vcpu);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_DONE);
+
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char **argv)
 {
 	TEST_REQUIRE(is_tdx_supported());
--
2.54.0.1032.g2f8565e1d1-goog

