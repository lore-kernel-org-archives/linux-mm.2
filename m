Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A0BE10AB82F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AAA16B0093; Thu, 26 Mar 2026 19:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382336B0095; Thu, 26 Mar 2026 19:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222316B0099; Thu, 26 Mar 2026 19:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08AD86B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:37:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCE5AC468E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:10 +0000 (UTC)
X-FDA: 84589827420.30.B45D0E9
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id EABFC14000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MCFo4JB2;
	spf=pass (imf23.hostedemail.com: domain of 3I8PFaQsKCBYwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3I8PFaQsKCBYwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iqU+PNO7bQVZ4XweKo6JOzshp2g+Q7QVegeGT2TX4U=;
	b=u2MuVjlmBwqWbyHCE/WdDTs8q8cp8H2vVti5v4AtU9ItKYCe5wVMN5BuXWEOia9baqRye4
	eRAdL6SQyhLXdM3lC72XNrmMgLELRArCmiSBkmBQYrxKbuiLLu72/HxBWju6dNVSuxdKMd
	oD0P9NJePxWqbZaEO1xGIdE+wrXlHy4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MCFo4JB2;
	spf=pass (imf23.hostedemail.com: domain of 3I8PFaQsKCBYwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3I8PFaQsKCBYwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568229; a=rsa-sha256;
	cv=none;
	b=EPVUZkKIh/JaBXA77jVPc2Iej6tys0WH9BhrHxUFsnIEgCuRyOOjHPaHfNy0hcy++sRYWo
	kvD3oDTy3gYQ9KvOHolV/VoTbfjnt993y9PeO8DHSvP80NhasK0SUehmGYmU0tiN7eOr2Y
	zpPOG5nIRPRcnjGERlZao2xHC54ROo8=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358f058973fso2127528a91.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774568228; x=1775173028; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+iqU+PNO7bQVZ4XweKo6JOzshp2g+Q7QVegeGT2TX4U=;
        b=MCFo4JB2nFHWkywZyWe+XBS2plkZ5cl9rB3L6Kfk0pZmKpd3ZBv9IxTvP8pNdOPcBT
         uVOcAMnE3Dm1y0VcEIqMYOZ/iJ5pDWD18I6bLfB1AghujpWceqlkCSv/AIPpSFV8n42x
         6TKCaiDJb4bQAWryCi7D2c3P+PcvEVt34VjjIDTjYQwF1EYWfnMoTq/MQoBxtZLTvXsi
         KI50IgC+hvzySZM9Fg0YSm383o2bGiWiKgu5doKkp5tTXNFhQpQDLOzPnoHFJ4ZXGrZP
         KjoiMNc2wm4oJml8CwfL+KMIS2QJL1ajefHyK6ZPjXrkNNT+z7/hkUrf6MV0NgczlXN2
         Wt0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568228; x=1775173028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+iqU+PNO7bQVZ4XweKo6JOzshp2g+Q7QVegeGT2TX4U=;
        b=gcO9oBwzF5Rgp6ZKyTm+07vcNFBvhs4a1XVREE0T/py20x0kx6CeyZio8OX2ne8fgu
         dMnDufU1A7qB3aTKpy0cJYAcAe55ObtvYUlEH6JeZlGQf0Bc5Yn4BjyBDnHrdvUuw/Th
         MRvty/1YjcpOiX6gaUc9THh3clnPXRPt6pFwVH1jFZ5GRsdQXb9tzQ7GZ/oPDJagLrVl
         epOAcOSpp7wmMN/cgUXRDNcLReluEIZjXQZ+xdI+O8UCDqJ9INZNWSU0nG78iR81dkri
         Z45bdUfibuVY6W1j/r8AGH+t+6JmeZOLaigJSYAy+Fr4wUhsA6gPgDn2QWbN7fSrhitb
         leYw==
X-Forwarded-Encrypted: i=1; AJvYcCVpXm0o2aT5LhWcl4j6Rlv3rkm25OjDjEXZQ3o/sB18XPYTwtZ1rw2ntPTha+5jX7sDtm3Ykg27WQ==@kvack.org
X-Gm-Message-State: AOJu0YxtlXYWNuvA+tb3W3OIDOGzlNDLgnja3pUnXH1oj+gpt2xHc62d
	/Xz8FZjsaKr4REN8rHc4MR2V23rhSG0kAUu5FX2cl2ZXe6fzP6L6crfQZFc2W+70D6EQ0xCHttG
	d/JzJM9PC7ZEbJuaG4Z7QMvJYOw==
X-Received: from pglu12.prod.google.com ([2002:a63:140c:0:b0:c76:3cb2:929c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1642:b0:35c:17ae:4e2f with SMTP id 98e67ed59e1d1-35c30155f02mr371172a91.33.1774568227491;
 Thu, 26 Mar 2026 16:37:07 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:36:43 -0700
In-Reply-To: <cover.1774568083.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com> <cover.1774568083.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <92f152f8df72bbfabf69ecfa55ee65287a018cb3.1774568083.git.ackerleytng@google.com>
Subject: [POC PATCH 5/6] KVM: selftests: Test conversions for SNP
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EABFC14000F
X-Stat-Signature: saqpqzya4jb6dmadyjzmkhsfscsbra9h
X-Rspam-User: 
X-HE-Tag: 1774568228-846525
X-HE-Meta: U2FsdGVkX1+4aAqysZ/wGLKdHOfdVwekJwgPG6N4z8f+IMyon3RHclXQ4E9OE0T1X3J4vCS1Gy6KlI8jOsPk87LjtYf3eZZ51peuCITMvn6h0rHlmSOjtF2IGt2Zs7xyoMIasuUbQ9DUSZYaQUnbT2m92lbudB5AXcWGnFV95YWJkscW0GEK+qQbhbiUB7OD80x81AYvt4Zv21pRNvwRTUOb2emI5OdWDj6DYkNHXsNfoTt82+xmcWWtGKcoWalUlGFbPBoBX2Qzr9UnE5aceRWKl4elwl7obeXUBNXCoZBymocgZlNSW3s4x0MwMyL3B0oSYIkfedB7u8MAlrn57Wr8Rll3qC/TJyMeypVh5GSQ8UOPhAQMf1Rn+6EJrUoQTCYneqyPVTzN3zZ5xINbtV7fOEcRZaLcFTOXSkFxJp8thLqOk9h1kp5BgCL0SzYu9LhtO5qyK1pZp5uHEil7H4xAyakMe0b8vY+lg6Eic3yyrIyJTOt/tfVySw6XRhmEYYkjelPmO+DzJCs7mSI1mtSCscmihDhYCf0M3NWNKj8d1GUG5SklG7svYto9IdOsaR09eRMiDef5pF9yoswaWIMwI7RAAeTI0bI8mYkBdw0+r1RWm1aHTjTUsP9tdI6CRslKNfpSm2XukNiq+dKEEt7NgfqhXS6bxBT0sj8gWeihR5Uxyxg70YjxlZQ0fV6HOce8dbNJpZa6IBuDoN2DtJekCPRa7Xj0mns2/yu74+c2CzI9kfS7hH+EssEYolnmu8Rh4Ul26NpLh0PZi/Mzq6JbyjrOSY4Scy62UopUAvf8p6BhOJsahX7KGa/Z0d2FzTYD2Ln7DY97tpmBKt2bRKo+js6Kr0mTJZazSlCnNKSyOCM/lArfF9glOjQAWz9XZXmwwbxjRlbm0K7HitrVERmnAT3hH47TKkUWCUq3U0s7t+as3f9VZvhI0maCpGei3k5YsEborGNlG6Kc9W/
 rReUFoW7
 H459U2zkiqitePHSrf3zxJrrFy3jisJv+jkBAfYmu4Cy8f0In5q174NsRzxAwuVM6R9OZ05AtW+uvHJ1CDWVD85LRV0yA9Qfog3wmREwPys0o3XhfhrnbWncdrBZGK4hjOdT/49/2DlKfHgGCVt1QJOYX5tYBrknL6GdqE6pueZ/d75zprEkvQOnUlPXTAvZK7SdzN6b/A0Puf3dFdSZVUM/Q1MbGNZI+xYRothN4uhbv/i9g5O2tR+fzXq+KxKYfYtY7J8GPIO8ejTFB7GkU1F04UOHMI5PBcGLX+mMma8febl7qpIkuUS+p2kLZ5RoK1ti1A9f4lgfVZGmskMmaUGGHaa/CQ9IzSmbX3GbuvY3Ltyf4Sygra9GZrWnhvA9A1pcyNyxc7vPXl36C+SFHi97JDfck5r1OacKsqLpbfNpUWgn/apCUxnrHW2RaDdTEO6dSTtoxbpyDgpSyBgpOFcrxpfT9jUTTItP8+/a4DPs7QqsGM7WsZazTYDCD4OGP/uAHSnYsCTnjCklF078wskUl+b3LTCynqwm0CYMmOC/aKVWcCHCAVCi/a2+UuL7VNGRGM+yhui0MwYa39AzuDaRpMIm5vrS+QLwuH+nfXve9+h0hawkdMqu40F9vc6PnXMrReO8y+UazYDxHp4JVUYIRPEovzx7tOoQA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/sev_smoke_test.c        | 190 +++++++++++++++++-
 1 file changed, 185 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 7e69da01cecf4..c40c359f78901 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -253,17 +253,197 @@ static void test_sev_smoke(void *guest, uint32_t type, uint64_t policy)
 	}
 }
 
+#define GHCB_MSR_REG_GPA_REQ		0x012
+#define GHCB_MSR_REG_GPA_REQ_VAL(v)                \
+	/* GHCBData[63:12] */                      \
+	(((u64)((v) & GENMASK_ULL(51, 0)) << 12) | \
+	 /* GHCBData[11:0] */			   \
+	 GHCB_MSR_REG_GPA_REQ)
+
+#define GHCB_MSR_REG_GPA_RESP		0x013
+#define GHCB_MSR_REG_GPA_RESP_VAL(v)			\
+	/* GHCBData[63:12] */				\
+	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
+
+#define GHCB_DATA_LOW			12
+#define GHCB_MSR_INFO_MASK		(BIT_ULL(GHCB_DATA_LOW) - 1)
+#define GHCB_RESP_CODE(v) ((v) & GHCB_MSR_INFO_MASK)
+
+/*
+ * SNP Page State Change Operation
+ *
+ * GHCBData[55:52] - Page operation:
+ *   0x0001	Page assignment, Private
+ *   0x0002	Page assignment, Shared
+ */
+enum psc_op {
+	SNP_PAGE_STATE_PRIVATE = 1,
+	SNP_PAGE_STATE_SHARED,
+};
+
+#define GHCB_MSR_PSC_REQ		0x014
+#define GHCB_MSR_PSC_REQ_GFN(gfn, op)			\
+	/* GHCBData[55:52] */				\
+	(((u64)((op) & 0xf) << 52) |			\
+	/* GHCBData[51:12] */				\
+	((u64)((gfn) & GENMASK_ULL(39, 0)) << 12) |	\
+	/* GHCBData[11:0] */				\
+	GHCB_MSR_PSC_REQ)
+
+#define GHCB_MSR_PSC_RESP		0x015
+#define GHCB_MSR_PSC_RESP_VAL(val)			\
+	/* GHCBData[63:32] */				\
+	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
+
+static u64 ghcb_gpa;
+static void snp_register_ghcb(void)
+{
+	u64 ghcb_pfn = ghcb_gpa >> PAGE_SHIFT;
+	u64 val;
+
+	GUEST_ASSERT(ghcb_gpa);
+
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, GHCB_MSR_REG_GPA_REQ_VAL(ghcb_gpa >> PAGE_SHIFT));
+	vmgexit();
+
+	val = rdmsr(MSR_AMD64_SEV_ES_GHCB);
+	GUEST_ASSERT_EQ(GHCB_RESP_CODE(val), GHCB_MSR_REG_GPA_RESP);
+	GUEST_ASSERT_EQ(GHCB_MSR_REG_GPA_RESP_VAL(val), ghcb_pfn);
+}
+
+static void snp_page_state_change(u64 gpa, enum psc_op op)
+{
+	u64 val;
+
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, GHCB_MSR_PSC_REQ_GFN(gpa >> PAGE_SHIFT, op));
+	vmgexit();
+
+	val = rdmsr(MSR_AMD64_SEV_ES_GHCB);
+	GUEST_ASSERT_EQ(GHCB_RESP_CODE(val), GHCB_MSR_PSC_RESP);
+	GUEST_ASSERT_EQ(GHCB_MSR_PSC_RESP_VAL(val), 0);
+}
+
+#define RMP_PG_SIZE_4K			0
+static inline void pvalidate(void *vaddr, bool validate)
+{
+	bool no_rmpupdate;
+	int rc;
+
+	/* "pvalidate" mnemonic support in binutils 2.36 and newer */
+	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
+		     : "=@ccc"(no_rmpupdate), "=a"(rc)
+		     : "a"(vaddr), "c"(RMP_PG_SIZE_4K), "d"(validate)
+		     : "memory", "cc");
+
+	GUEST_ASSERT(!no_rmpupdate);
+	GUEST_ASSERT_EQ(rc, 0);
+}
+
+#define CONVERSION_TEST_VALUE_SHARED_1 0xab
+#define CONVERSION_TEST_VALUE_SHARED_2 0xcd
+#define CONVERSION_TEST_VALUE_PRIVATE 0xef
+#define CONVERSION_TEST_VALUE_SHARED_3 0xbc
+static void guest_code_conversion(u8 *test_shared_gva, u8 *test_private_gva, u64 test_gpa)
+{
+	snp_register_ghcb();
+
+	GUEST_ASSERT_EQ(READ_ONCE(*test_shared_gva), CONVERSION_TEST_VALUE_SHARED_1);
+	WRITE_ONCE(*test_shared_gva, CONVERSION_TEST_VALUE_SHARED_2);
+
+	snp_page_state_change(test_gpa, SNP_PAGE_STATE_PRIVATE);
+	pvalidate(test_private_gva, true);
+
+	WRITE_ONCE(*test_private_gva, CONVERSION_TEST_VALUE_PRIVATE);
+	GUEST_ASSERT_EQ(READ_ONCE(*test_private_gva), CONVERSION_TEST_VALUE_PRIVATE);
+
+	pvalidate(test_private_gva, false);
+	snp_page_state_change(test_gpa, SNP_PAGE_STATE_SHARED);
+
+	WRITE_ONCE(*test_shared_gva, CONVERSION_TEST_VALUE_SHARED_3);
+
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, GHCB_MSR_TERM_REQ);
+	vmgexit();
+}
+
+static void test_conversion(uint64_t policy)
+{
+	vm_vaddr_t test_private_gva;
+	vm_vaddr_t test_shared_gva;
+	struct kvm_vcpu *vcpu;
+	vm_vaddr_t ghcb_gva;
+	vm_paddr_t test_gpa;
+	struct kvm_vm *vm;
+	void *ghcb_hva;
+	void *test_hva;
+
+	vm = vm_sev_create_with_one_vcpu(KVM_X86_SNP_VM, guest_code_conversion, &vcpu);
+
+	ghcb_gva = vm_vaddr_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
+					 MEM_REGION_TEST_DATA);
+	ghcb_hva = addr_gva2hva(vm, ghcb_gva);
+	ghcb_gpa = addr_gva2gpa(vm, ghcb_gva);
+	sync_global_to_guest(vm, ghcb_gpa);
+
+	test_shared_gva = vm_vaddr_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
+						MEM_REGION_TEST_DATA);
+	test_hva = addr_gva2hva(vm, test_shared_gva);
+	test_gpa = addr_gva2gpa(vm, test_shared_gva);
+
+	test_private_gva = vm_vaddr_unused_gap(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR);
+	___virt_pg_map(vm, &vm->mmu, test_private_gva, test_gpa, PG_SIZE_4K, true);
+
+	vcpu_args_set(vcpu, 3, test_shared_gva, test_private_gva, test_gpa);
+
+	vm_sev_launch(vm, policy, NULL);
+
+	WRITE_ONCE(*(u8 *)test_hva, CONVERSION_TEST_VALUE_SHARED_1);
+
+	fprintf(stderr, "ghcb_hva=%p ghcb_gpa=%lx ghcb_gva=%lx\n", ghcb_hva, ghcb_gpa, ghcb_gva);
+	fprintf(stderr, "test_hva=%p test_gpa=%lx test_private_gva=%lx test_shared_gva=%lx\n", test_hva, test_gpa, test_private_gva, test_shared_gva);
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_HYPERCALL);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.nr, KVM_HC_MAP_GPA_RANGE);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.args[0], test_gpa);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.args[1], 1);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.args[2], KVM_MAP_GPA_RANGE_ENCRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
+
+	vm_mem_set_private(vm, test_gpa, PAGE_SIZE, KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED);
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_HYPERCALL);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.nr, KVM_HC_MAP_GPA_RANGE);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.args[0], test_gpa);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.args[1], 1);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.args[2], KVM_MAP_GPA_RANGE_DECRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
+
+	vm_mem_set_shared(vm, test_gpa, PAGE_SIZE, KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED);
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SYSTEM_EVENT);
+	TEST_ASSERT_EQ(vcpu->run->system_event.type, KVM_SYSTEM_EVENT_SEV_TERM);
+	TEST_ASSERT_EQ(vcpu->run->system_event.ndata, 1);
+	TEST_ASSERT_EQ(vcpu->run->system_event.data[0], GHCB_MSR_TERM_REQ);
+
+	TEST_ASSERT_EQ(*(u8 *)test_hva, CONVERSION_TEST_VALUE_SHARED_3);
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
 
-	test_sev_smoke(guest_sev_code, KVM_X86_SEV_VM, 0);
+	// test_sev_smoke(guest_sev_code, KVM_X86_SEV_VM, 0);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
-		test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
+	// if (kvm_cpu_has(X86_FEATURE_SEV_ES))
+	// 	test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
-		test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
+	if (kvm_cpu_has(X86_FEATURE_SEV_SNP)) {
+		test_conversion(snp_default_policy());
+		// test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
+	}
 
 	return 0;
 }
-- 
2.53.0.1018.g2bb0e51243-goog


