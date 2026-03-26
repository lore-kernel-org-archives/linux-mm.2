Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC03C10AB833
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D952E6B0095; Thu, 26 Mar 2026 19:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D1D6B0099; Thu, 26 Mar 2026 19:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84476B009D; Thu, 26 Mar 2026 19:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF6CE6B0095
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:37:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 714EF160F26
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:12 +0000 (UTC)
X-FDA: 84589827504.26.ED47FF5
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD186180005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xb0Qte2e;
	spf=pass (imf24.hostedemail.com: domain of 3JcPFaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3JcPFaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGHA+MoXXkOWLz+GDyK6vuU1BU5bAOng9gVTAO3EQWk=;
	b=Hr7VORJ85CokdtSDODBrKrubSF8xIdY8aVo+vggZ4wKcGitWubqAw8l8RVgbaemYOXpkKv
	SXB/XUhmqYC03QpVmluyefsMWbI1Rzc3bzisyOP62Ll+HV+LdajHCPmNfuroFfZANMnULo
	wt6FG/Ib0NwYwi3Iuj02r3xNs67FPxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568230; a=rsa-sha256;
	cv=none;
	b=zA69yzQEzSvblsmsmc2bm4s+lkrL+uXidVxuOSFEbhkSUBJ4TsQIpqSJPuWednX5GG//BQ
	tzAhgdnTeQ9mlfEhZkcOI4AaujHQSxzZDAvpnankQaApFib2Xe+zlv93+dbHfimKdqHjOL
	eJ0oglbRfFUzHfHVC98/HcWJcxjspqQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xb0Qte2e;
	spf=pass (imf24.hostedemail.com: domain of 3JcPFaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3JcPFaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c675116f1so2999006b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774568229; x=1775173029; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qGHA+MoXXkOWLz+GDyK6vuU1BU5bAOng9gVTAO3EQWk=;
        b=Xb0Qte2eTUKvNzUyM57u7rZxSWGUQv3FNoSmKm6fkt3i2kszK+k60lPDBiEnSk4/1J
         0Nvy93mzuOH6kwSG2xJOqytpd/BaC1OTAvHDSDN7s76Qf31QTWp4OVL4tmZmi2MJBx9R
         YoWQWwul2oEJ+agjuRA/0Pg9mDx8QMI4zoE8txaQvpZDBE4sr7xOY1dWA7yVVWUtn3Ck
         XRWFqyZgOgR7AK59YUAx379OdH+OzFBc9k6aAVJxR86vcJbYpAuzYQGjdgNpvDQj4LtB
         MZp0ZqclQ9Hj7dIJRM+nu7LiiRZzMZAS0HOKE6CH7k/cBxRfYQxx42AMLpmSf9/s8fle
         53OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568229; x=1775173029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGHA+MoXXkOWLz+GDyK6vuU1BU5bAOng9gVTAO3EQWk=;
        b=p7kVkWHZgyHsUjSnJucb3kkMyfMVJCAWycCmGTIhsWKqkWeamSo+kOs4e6BP/VFVt7
         2cAG4KpP0JD9TzF08WPU5/xPWe6R+BHOTtDOtQjcdB8VeIHwlPRG8Yr3sZ9WLXQLE2Bn
         vn7rCAXrSFOwxA8DLLUsegpfU1egtRnACZQTO+Fq2nRMaRgPHU7kzcN8wvb/NCPwcTs5
         +Nusfbz20LB1jWoVN8wV7ynuEY98vBRniz69kS9fZTL+CFBLn+MPV6b2wkvQq76PlHas
         zLb2tRq+viWT92rj+JbgG6Lcft/2BL7xVqogM+49fpzkuWRdJirfl4vWe5iEs+QvzX5d
         nC7w==
X-Forwarded-Encrypted: i=1; AJvYcCVo8JFXuG10xHYt5/w1J9GRPagwcQSBB+smYn9ePGwcehXTByUkPeMSuIdxGygx7/kKgIrtjsT8AA==@kvack.org
X-Gm-Message-State: AOJu0Yx426nnrYXKwjtlfce9+LR3jnFW39EVzAVYgY3yiJSabVrTujp2
	Ow4C4WXRgkojnnHZ/dAqPZD1w3H1kNbz4SKroTZYKOo6yN1YxccvPdU3CzD2DAZMujEvm08aCJZ
	9ES8J/7v3c12NrPXeHvk1dk6/1g==
X-Received: from pfbih20.prod.google.com ([2002:a05:6a00:8c14:b0:829:f706:70e4])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4146:b0:82c:20be:57e6 with SMTP id d2e1a72fcca58-82c959d4d68mr331958b3a.11.1774568229229;
 Thu, 26 Mar 2026 16:37:09 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:36:44 -0700
In-Reply-To: <cover.1774568083.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com> <cover.1774568083.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <ca43f8054abe83d7fbca69c5b2f1a831f3cf86fa.1774568083.git.ackerleytng@google.com>
Subject: [POC PATCH 6/6] KVM: selftests: Test content modes ZERO and PRESERVE
 for SNP
From: Ackerley Tng <ackerleytng@google.com>
To: ackerleytng@google.com
Cc: aik@amd.com, akpm@linux-foundation.org, andrew.jones@linux.dev, 
	aneesh.kumar@kernel.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, chrisl@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, forkloop@google.com, 
	hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, jmattson@google.com, 
	jroedel@suse.de, jthoughton@google.com, kasong@tencent.com, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org, 
	seanjc@google.com, shikemeng@huaweicloud.com, shivankg@amd.com, 
	shuah@kernel.org, skhan@linuxfoundation.org, steven.price@arm.com, 
	suzuki.poulose@arm.com, tabba@google.com, tglx@kernel.org, 
	vannapurve@google.com, vbabka@kernel.org, weixugc@google.com, 
	willy@infradead.org, wyihan@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: AD186180005
X-Stat-Signature: 4sa1dwrxmgpkx98pqgc5t45atkczyxky
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774568230-41454
X-HE-Meta: U2FsdGVkX19bC1ca4yWw70YCU8/C2UI8FhEIo/qmtpjj3L/Jj8TBEWRh/p7Jx/1NaHjWsaMxR3jqEdD92wXoFdhJlh8jfg8K2WdRv+e74UFDD7KWPgFdp9C/aAu/E1Z4vKMUV2/qngE/MuR4eec34LWoNKSvBptYgqa222AmtuCoX3K2YxZAgMy+FJH0ZSPa13Fbhh3QqAzmqD1k4jwd7Uxmh9DgOf7UqKvUhd9gZ9PTL4FI/Qm+geFpPZiqVvbTmZXcyIofkpr/Leou1qthp9WUFpUSG/iurr855HCdFiGrQyjcgoBWYbcDswn52KVyEP3Sjtrw6VmvoxNGVDpYees+OUNJ55Ht++jr2aS7Q8esZXdt1hRWUkczeL3Sm+5P8vEXSaIEB16XJYXZfzUHD3j8E+e4d9dvZtgM4ofT/NwHqfUObx9JaiGvtThWpzUI+dJinmy1zPAECaXg+1PO5AHYiTQ7sSbbTxk9HhPghVDVUuSURmUTYuMhsEfnfJJ1mDK/z2TT9yME/U5DVv+L/ZQ/Bv08g7tyAE+9Krs3asbGAaBJLjfJnnuhv/gCRaU+fgCC7VYjB6+zMIHy59xWWDMDypfyQ1Hqc0umoHvaJAHimLyloWCmydJivjcQLkAhkB++nDqwKnuc30U4rB4BbvesXQQ0g3H3dydGSZRTQKCfb7uCZdo1aJOiaO3D/rB1LR/ee3HqPz4bRuI3iSKi3J2LNnjcke8L6sD7v2ReBGSgo1ECIV/+F8ksmSlUfBUKs6Bf8OFck9T/RiBoS13rIWzaT+xVWM0ARG53t3YGfcVMVH/89xQizbgeRe5qo25aICeK6hG8VdSKo6ZgnJGKkwFay+D7aZl3QVyN90XRnYytniCrEA+VgTHvtlES6cY+SGuKR6PPBY4/ZvpQ+sK09EqKLaQK1NSsMcHUpoGvbOTxoTzd1VN4ADGhcko/gdbyTBi2og7AuZGwRQmu5w3
 zCx9JIsy
 +YK1puatMSXkJ53G9dJv61H7ZCx1qM6BKUN5Q2tFuY0eJaIUrkhDUZbOvWtNnXa+TO2Po4mZjNJv7M+wuhRtVy3WktkQJ+SxnIadkxMfECQtgHZb9IN9NXMoXNr3hcfDXq2h+2973I4cG1QtQyf0ntSmhVbEBs1mKFZSafjhZVanFHPfTH3bw0GqJk6d2gXiIuoLQ9AH6DWbTapVDEs/sD40T8bftJ/N75FXGBOE88HNFqj8SZVziYItaRRVhC30M1p5x+27CKZupmA+FGX3QL3XTbBTDFbT4JIT16U/VgEj8lTQyE+1qbPqdsb6QBEKBjuZSHzj0WsOpSjaEKFXInOt3zpVI7vY7KEKuNIYdpVueQ0kEM6upxUi3XOVzKkkPBgOjr2ysKLzeGoW7xpPvdYxfQf2MsWP803j21UX0+NeYwbXky9yqq8/UMuB8HKDSv7ssrIXP5gKAZrJ+bMQDPcsC//+RwodGxNQAmy9FfZg/+KY50VPSENCTbPQeODdZPynRZosTKwkZPDsJ5fwk9JYmATTLPjxqLVvFsT/IGvirnUVE9qzaKTmpr6D6SfwHb9PxYZ9lg0csi4+c0CU4MHfrUUw9cpwwYKjYT0yHsOxR3XMPbfvI/j3K2XKOjviIfQVfaGY8eYPj057EpKdodX90tXDylTvjKG2J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/sev_smoke_test.c        | 47 +++++++++++++++++--
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index c40c359f78901..b076e0afc3077 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -365,7 +365,26 @@ static void guest_code_conversion(u8 *test_shared_gva, u8 *test_private_gva, u64
 	vmgexit();
 }
 
-static void test_conversion(uint64_t policy)
+static void vm_set_memory_attributes_expect_error(struct kvm_vm *vm, u64 gpa,
+						  size_t size, u64 attributes,
+						  u64 flags, int expected_errno)
+{
+	loff_t error_offset = -1;
+	size_t len_ignored;
+	loff_t offset;
+	int gmem_fd;
+	int ret;
+
+	gmem_fd = kvm_gpa_to_guest_memfd(vm, gpa, &offset, &len_ignored);
+	ret = __gmem_set_memory_attributes(gmem_fd, offset, size, attributes,
+					   &error_offset, flags);
+
+	TEST_ASSERT_EQ(ret, -1);
+	TEST_ASSERT_EQ(offset, error_offset);
+	TEST_ASSERT_EQ(errno, expected_errno);
+}
+
+static void test_conversion(uint64_t policy, u64 content_mode)
 {
 	vm_vaddr_t test_private_gva;
 	vm_vaddr_t test_shared_gva;
@@ -409,6 +428,21 @@ static void test_conversion(uint64_t policy)
 	TEST_ASSERT_EQ(vcpu->run->hypercall.args[1], 1);
 	TEST_ASSERT_EQ(vcpu->run->hypercall.args[2], KVM_MAP_GPA_RANGE_ENCRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
 
+	/* ZERO when setting memory attributes to private is always not supported. */
+	vm_set_memory_attributes_expect_error(vm, test_gpa, PAGE_SIZE,
+					      KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					      KVM_SET_MEMORY_ATTRIBUTES2_ZERO,
+					      EOPNOTSUPP);
+
+	/* PRESERVE is not supported for SNP. */
+	vm_set_memory_attributes_expect_error(vm, test_gpa, PAGE_SIZE, 0,
+					      KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE,
+					      EOPNOTSUPP);
+	vm_set_memory_attributes_expect_error(vm, test_gpa, PAGE_SIZE,
+					      KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					      KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE,
+					      EOPNOTSUPP);
+
 	vm_mem_set_private(vm, test_gpa, PAGE_SIZE, KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED);
 
 	vcpu_run(vcpu);
@@ -419,7 +453,12 @@ static void test_conversion(uint64_t policy)
 	TEST_ASSERT_EQ(vcpu->run->hypercall.args[1], 1);
 	TEST_ASSERT_EQ(vcpu->run->hypercall.args[2], KVM_MAP_GPA_RANGE_DECRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
 
-	vm_mem_set_shared(vm, test_gpa, PAGE_SIZE, KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED);
+	vm_mem_set_shared(vm, test_gpa, PAGE_SIZE, content_mode);
+
+	if (content_mode == KVM_SET_MEMORY_ATTRIBUTES2_ZERO)
+		TEST_ASSERT_EQ(READ_ONCE(*(u8 *)test_hva), 0);
+	else
+		fprintf(stderr, "test_hva contents = %x\n", READ_ONCE(*(u8 *)test_hva));
 
 	vcpu_run(vcpu);
 
@@ -441,7 +480,9 @@ int main(int argc, char *argv[])
 	// 	test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
 
 	if (kvm_cpu_has(X86_FEATURE_SEV_SNP)) {
-		test_conversion(snp_default_policy());
+		test_conversion(snp_default_policy(), KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED);
+		test_conversion(snp_default_policy(), KVM_SET_MEMORY_ATTRIBUTES2_ZERO);
+
 		// test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
 	}
 
-- 
2.53.0.1018.g2bb0e51243-goog


