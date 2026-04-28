Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0933BFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE056B010C; Tue, 28 Apr 2026 19:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67EFB6B010E; Tue, 28 Apr 2026 19:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5459C6B010F; Tue, 28 Apr 2026 19:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B31E6B010C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:35:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC351A0D20
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:37 +0000 (UTC)
X-FDA: 84709568874.02.24EEBB8
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD1421A000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OtTQ2ajB;
	spf=pass (imf19.hostedemail.com: domain of 3zkPxaQsKCHEPRZTgaTnicVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3zkPxaQsKCHEPRZTgaTnicVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777419215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0syyhb9YeGFgBqpqjZEPjnNFKpLHyAFVq8K7QF7sEE=;
	b=dExlo3dxbvsh0mbfEVoOthOWCMCH0wcQ6souL6DBBPA0VuPJ3h5UTmv8hw/sgewSO/uPOg
	TD93lcncJYpy0vP/YWT5KY5ZPJWdi51WNn6XGxzbbcp00wjhrMEC9ZRn8VP2ZmvknWQq3d
	M9jZY/dIqiVXb/Y1wsHtBAB3ZufliSI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OtTQ2ajB;
	spf=pass (imf19.hostedemail.com: domain of 3zkPxaQsKCHEPRZTgaTnicVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3zkPxaQsKCHEPRZTgaTnicVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777419215; a=rsa-sha256;
	cv=none;
	b=xhPABFyfiU7BTjZ0ovRouR9h8o1OY3VRXLZ6TrzEIQ0cYjJ6ofpSnNmW+Q9TddH87HtZoL
	lSWeafLOr4Z1WOoKPHK5T0imi+c5JiTb5l56P1xocYGtAwbKDoNS2c3YxmncvJ2Zlsnna4
	/5JhBOQfccRfddwzTFGqiaAxT0Fyozk=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c44bf176so14215085a91.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777419215; x=1778024015; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k0syyhb9YeGFgBqpqjZEPjnNFKpLHyAFVq8K7QF7sEE=;
        b=OtTQ2ajBJWni6rkVXwyn4nQfZQ6StF0aDR/DIA5eih4WmRdbC2owYXLkhHbJv0axGP
         O0543SACnUdxUdtCvUO9ZdIozFoV1V3Tzt698nOdfE6xChVDtMn0IlemymMco4oJCXCg
         81z97h8a/pPgTZjnG6MIYV9CLSW1Bb0CL8fY1gW2sSu3eEPQcvGph0uVz7z72NWBTfwn
         4wN/DazUHlQ4yw0ZCBJYfJoechxMGrkc9pfh8eF7HdE9sJ7ADSG7r91pXuqQHupDZUrq
         6eJAOchbtN4GJ5sbK25yYJp1q6t9dsBOGhdfRMkCN/NhR3xmqIEg9TQM0JVBRi13invq
         Josw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777419215; x=1778024015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k0syyhb9YeGFgBqpqjZEPjnNFKpLHyAFVq8K7QF7sEE=;
        b=WU3gx6Sxkz9Hb/UzeczP5B5C+jEwG36XPTi/Y0tZ+uL9PNZHOahr5eznspicELkTKc
         bGERtv4MgIF1JT+jQEFRDSA7kkpAV2d9A8RzZ0SWNEIMo8Tpxfo1n+vKNNhSE5oMw0lC
         nxXFj7BBGc9zEVD+qL5QIy6OzB9FRag/kkfOhTRbIcTOGN38Y82pIlfQtRVtTjIwbHoR
         qh2anz5TKyC0RAPPj5ZjY2a+wTfSPNjUNpwLNk1qhDf+C6dow8FCD9pxNLm5DPnzW+GI
         /P4DCogwsMMPNhcWqN5mqEVDiGvALEDCoaX/aAIMmpRQuU/i1u2aC75lfqBKULsMENh5
         Nonw==
X-Forwarded-Encrypted: i=1; AFNElJ/9Z2xrspgUSSar2sZAHHpPzODku3XML4Vo4TiIhR3WVXbJOLzu7gMmY9zUpZRJq6r/wvAsUgJsrQ==@kvack.org
X-Gm-Message-State: AOJu0YxHjRMf1Xm9a+Hwka75vlD1TByJzDti/l/gaZSsc+hZWqPTkdnK
	Kn/9bDn4Jv+QC0oqvuHGEm/GD8UPOS9T0cAiRI+CyFvLA6g4KzV1gngGb5Kt6zD5IttQXMotQlO
	MqCOjOdAcX0+/laSInjivm6Q4Nw==
X-Received: from plxd18.prod.google.com ([2002:a17:902:ef12:b0:2ae:c8e0:1f12])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:189:b0:2b7:8a56:7cda with SMTP id d9443c01a7336-2b97c3cb634mr50128145ad.4.1777419214303;
 Tue, 28 Apr 2026 16:33:34 -0700 (PDT)
Date: Tue, 28 Apr 2026 16:33:25 -0700
In-Reply-To: <cover.1777418884.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com> <cover.1777418884.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <d7a6c561a22a77f9e1dc4f9f8957b23089f8112b.1777418884.git.ackerleytng@google.com>
Subject: [POC PATCH 5/6] KVM: selftests: Test conversions for SNP
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD1421A000C
X-Rspam-User: 
X-Stat-Signature: c1pbi6f4cpboc3odmjro8tgk4maatr3t
X-HE-Tag: 1777419215-541108
X-HE-Meta: U2FsdGVkX1/n2fnbvQh7i1P1u7mBgpBwmEVlLAmGAv5L02GfOjZpBe8dJavCeW1kbvYyML6dBXAgzyktqG77v9e/2v39j5NvF5VK0ircCgi+sBUDt7JW1mJBlewAVdyhlYAXIO6UWPOUSPtisHYmM7YNoVCA4qQROW+NqvwP8yUboRwTnE3qyCD1Vx6PVvR+iYIHSQ45hb/GXO22QwjXVSaJFuh0sA8hKlmnjoeJMWnPifaL1sC5dz2WSWebsL7kcpbcskEYPvQN5OSY6w2GYLIWKVDA7qE6Fyd90MPSzqrXf3nUQv84j7BDfDKga2gqZcOISmbgZ6CFbkIRt7tTASlyqN8JaNOuQdlmjtN0SymRPQ4Re1A7Mt/UtudCC6RzjJqqDozUY92boIUjFgxfvmI29zqSgLEjf63T5JxjvaX95Ct5twAxnH9sqY7VFQXhP56KR7HRcFAv1zgF2Dks4aE+wP03HuilNSz1Zzemfti9+3PPHZrIA0AGBw1CEqsGR263tEUfLOciLEJU6myZT9ZfujbG9hZzuCby0jLik/qdxjE2ha/mz0JEaTfAth2UaXMY/YZl/EQWHOz+GbS624J9rDFhrlXvEHArkG0htYtaWHtTBmta9MVMLcKoS4I6eRI+B2ioX1ECtYfHUJxoF7s8CgxD//Dkgh1wg5QgMuIxrUowTMU7RUOYexS51Oou/miI9G5ehSmkKgGGl2QOQuGxkkOId3Y4394xnqrprMRUuCH0xr+RwJYq4wAHWdvUlKUIiwfJrFVKARWkXv301P8uq2fLv2YA1+qXI9c1OqzvAtYYuPy+93ICjg0Habj2wkL778/0dSM7ZH072iPpq7novsXBdKsFMFlgrd6RGn0cZEbvWlpHBV8HLNPkZnjxcXIQiV6MefeF0SsaPmG30YuZh6hZOXWaLTA0o4S1IDpV/+pF6ZiEJdqiaOAHv5x1BwZeTW6AOgDHhW7EDBh
 QwSIvQmz
 n1sk4eebKOC04w848Ey8SQ30/MBXBdvwdyjbUrXg16R9e9wOni2dJB/HslTt4D0aHDi1pkJPgPhyyTBVFPfWgX4kjbtD/NbbnfRcYqFGYltL1arlffYRykT9w6t2Nqb8FB1ZxumUx4ZvBCVBrVYBkTT8BCRG4EJkI9SVoUHzU9JwJbX1YiWUai9tD/DNp4ynxRl8EIAV8F+/EzCWVsBwL0fXl+fgtgwzZUwroRBrMm/pUy4hEHorNJ6J5rIBN7yRkeu02BC1XT3mP2yyFHe6o9RMLX4v3M/313nI1F9FewKkDPYnY/mu4LYK/ch/iD1aLBSYkqlZ7sgtphy7U63WMx3jrCu80Ce0HiPSDK0JWmLSwTmLwRa84QYkkxxc0xIjQEvXOs5H6TawHzX9Bmtifx4Bc0c9w+DNq9Jtg4HMo991/F5SnmJdFe0u+q7EzgcWfFjOA10zCvBHm1kq8l0ilHp6+w5hRJGtk4o4ecqKihsgAJTQwxm39NLrbzWneXaYfQ6K4d9ou5GDkKzULdJIFe0FUdM9GPaUWSoyoG3yQqv7NZkRFYqo8rzM/2iWmC5DO4s4VUKzcCORjsZoBU+XjE6o6btC3z0YMxf2HATP91qwWVT3DN76WIIet0nXKyzGxSPRiD9QM2YEVTJBP2rZIEt5AEPZBo76BVOyLDIQM3k+Bx5DSHBFhRX4ZPxyydbNdOocizTda9gps6ozCIUQrx9qAEU1olmoJemN+OQlSot0bqkVtIXmy/BmZvrd75y93/iwX/fSK6WgaUYM=
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
index 8b859adf4cf6f..86f17e59e9392 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -253,17 +253,197 @@ static void test_sev_smoke(void *guest, u32 type, u64 policy)
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
+static void test_conversion(u64 policy)
+{
+	gva_t test_private_gva;
+	gva_t test_shared_gva;
+	struct kvm_vcpu *vcpu;
+	gva_t ghcb_gva;
+	gpa_t test_gpa;
+	struct kvm_vm *vm;
+	void *ghcb_hva;
+	void *test_hva;
+
+	vm = vm_sev_create_with_one_vcpu(KVM_X86_SNP_VM, guest_code_conversion, &vcpu);
+
+	ghcb_gva = vm_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
+				   MEM_REGION_TEST_DATA);
+	ghcb_hva = addr_gva2hva(vm, ghcb_gva);
+	ghcb_gpa = addr_gva2gpa(vm, ghcb_gva);
+	sync_global_to_guest(vm, ghcb_gpa);
+
+	test_shared_gva = vm_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
+					  MEM_REGION_TEST_DATA);
+	test_hva = addr_gva2hva(vm, test_shared_gva);
+	test_gpa = addr_gva2gpa(vm, test_shared_gva);
+
+	test_private_gva = vm_unused_gva_gap(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR);
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
2.54.0.545.g6539524ca2-goog


