Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE69CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5FE6B00E8; Thu,  7 May 2026 16:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C4B6B00EA; Thu,  7 May 2026 16:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144DD6B00EB; Thu,  7 May 2026 16:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3BAC6B00E8
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:34:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9557F1405FE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:42 +0000 (UTC)
X-FDA: 84741777204.30.EFAFEAA
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E577100012
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ActUMzgX;
	spf=pass (imf14.hostedemail.com: domain of 3Xvf8aQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Xvf8aQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778186080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dvz8VPqH3W+uwpeYUY0LX4HhcQuQ485hz2JT5vwb8Uc=;
	b=hmWDhK9EnC7A1dNSvzzpzNAqKKz7TdyU4V5puV6iLT13DyvNrdRibCAqksayGkoFS2Xqxb
	juFFpNPI/bc2uYXilDZPWwIwXmDD7lyY8IlNTl5eYTD/3timsI9Gpce2grR8Tj8/RoX1FO
	PiFR/p3kg2RDeVNOYwQpqLfx1jHX+0I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ActUMzgX;
	spf=pass (imf14.hostedemail.com: domain of 3Xvf8aQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Xvf8aQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778186080; a=rsa-sha256;
	cv=none;
	b=szMRhKrbyrAp0UNI+Z6IHqntfNrbMcAwPzS2hl5JBq+MsqRE8haRRhZ4XtiS4SC9l9jTU2
	RMyfXyLyVgN6LzHgacUwUIFdgK39V4GLCID4fofOtKuRbFf1hjsXXen3z27I/DuUZjMT15
	H66wWUAtZQsvR2T6h/VRWyK1cAIpi2Y=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e24ee93a6so1394628a12.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 13:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778186079; x=1778790879; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dvz8VPqH3W+uwpeYUY0LX4HhcQuQ485hz2JT5vwb8Uc=;
        b=ActUMzgXLXgc1QcgnFS0yH4iqs6y02nbsXmH5yvi2rPffEFCMNWv3zUS0+6iju0rCs
         WC5akkZgXIVtZ5eT8d35PMOdVYfAD6l/d3tMhLtYF5WTGBMiq9tkkQq3B8LJ4lgEtsxe
         h4lb6LPA5IB6JcgpwRl3logebH949GK5Y4iYMTmDLWAnCVv42+vIyxwyd6ZJZeBnIcIv
         tuB8oNX1QOJQ/elFYLwQYggJD5S/Nm5IdyapDVLeto1AcRhMSQIQIBXS5BIqUnVofEOF
         bbd2rUIj054lUPe4RFFXdaQ0gnyPpOGQ894OvoDsXOQp9C/mqUTWRe7dVcTremja8bX8
         Uezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778186079; x=1778790879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dvz8VPqH3W+uwpeYUY0LX4HhcQuQ485hz2JT5vwb8Uc=;
        b=Q/rBkCwJnnQL6/8WRztE5Z43IVDEcoJ5w50cW6Dwq/zZHklg4LmF9JluurzUuMhzTF
         jgI1Sk6fR3wiiEG7na10nOh7+qWNDWAWmHLaErfT3m/HffHAI+l7OVXmw/dtk68yehBr
         GRFPoqgfizP6oEPU3tX9Aqp6rc48DMlk1CQiZYpYAyxN5ciQNJhaNb1SPL+UvyD0QWnE
         DSClbrT41hVXG3P1J1PygXw2bzQ5m15+gLT6t7iZMjZy7j+DXaAu8G3FjHCS31GqPoem
         91LA6nHKlAfsgB+6RxLnJ478dxWab8cLjq/nkf6xD0/E2vCiMChxAQ8SovDYpxZ91JHj
         nIoQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Xv3adBCirNFhK3NP+vVD93pKSZftPJoWouXBl9ytQaUcsEn2Ckfo+indHuI2ahyiBnqqkkHAnWw==@kvack.org
X-Gm-Message-State: AOJu0YyvA0DBHptCEDrHb/CDNpJQVOqBm1TR0+9FHyFQcYwOFWiDWaJf
	v9sm9bj7IkfZgsRKCqoNYhm3Hjc2CXZX1KVq4hbLkLKGj0WpdZBu6wICH6JN3Ui92GoaaG0MlXt
	Eqb07CY1We4p6IsBaPaVHGPcNRg==
X-Received: from pgam24.prod.google.com ([2002:a05:6a02:2b58:b0:c74:42:8984])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a08:b0:3a0:9052:c005 with SMTP id adf61e73a8af0-3aa8be1f13cmr3709197637.3.1778186078908;
 Thu, 07 May 2026 13:34:38 -0700 (PDT)
Date: Thu,  7 May 2026 13:34:26 -0700
In-Reply-To: <cover.1778185936.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <cover.1778185936.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <1edc2c94bf776c8ceee3b92208e6280ef5a50a23.1778185936.git.ackerleytng@google.com>
Subject: [POC PATCH 5/5] KVM: selftests: Test conversions for SNP
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E577100012
X-Stat-Signature: gbmhh5dt6uf49hbrmhruprk8aodstm54
X-HE-Tag: 1778186080-876037
X-HE-Meta: U2FsdGVkX1/GueRInBQpct8KFXxGrIOD8eq7oOWe06GeIOFHwsLWDJIVTOSVhgWpVv/mKnNN9KPZ9GV077KgiWEsdkrqcXtO3zhESg1JGtyKpWy8GKoSLDj8UvmmgruXWOnnjvBJ3TkyGgzwOfK8I3Ok53AQO93/Kh3+YITprSzxXgBXG407H1+9tHfAQgSW7jGaR35bOMlwZ41bSTeVVIM02fXVxiCjx8u2djsGsaRRKHFFqe8y85SDl8PTLLnKWCro6Z0xr+x2b+R/3tt6Znc1lEySIzgbNALJcNG8mMuHADvCgP0VFgwqTbsNO8aMuSdrQ0J571j3SNw6uOqOPkt1KdvBH8tAkkjWCuY7KD7DrjX9JQIetnq/a5XplTEfCE32aI3BI01s5A5Nspl0B+n1w5Iq0tTJPHQZ1suEqThVq2P+BKK8cuioomXtNlYLmf1zkzihZoX75dIyRTjwJq1gShwL7sVQ5vrH0T2EF/kefyategG53lvpmZaS9HVvjymuichjFERP8QaV4EXOJt4BTb1Is224v238FLcIvxh6vU9OxpDR68Sq5ti9IM5cEwpkFZpcDwz7vPEpCK9qiuTpMjFv44ue6xvHXdaxNARtp7ehiMs45aS/W7N9ljGD5YJYnSQDOTmbGIGom+FLhtkSN320IRldoX/gr8C6eHNeMroVYF6HtdY4eZRFvyc+M0OujnkD3OJpibX0FEGW5yLlEdd/IvTU6YOiKuFa0P+6ftVswF40QhN6Xf2ETIuNWYW9EI1TOcqK2I5/dorW/x3M6exfprFTFnJ1pkTJao7lr9s/IO/t4hAbKiiVuHia8ifCJZIs9/Wyb/ZtayDjAjsBY4nj2GpLUvzXyIDPtn9u4hYaqiiO+YmrxreBhUNBBvZgZrMguz4jPjVZk6K/GREguPNTVGR6j3T1C7FyRiupZi40gPBhETqT2QxRRp+LWJZWdKVsh2PWPDTuwTq
 YudVnj1Q
 CQRLK9NbNWZ6hrGDHUn83HuooErrxHI0Lqb513ZH/m0JkaLd/f9m+/uf3cN9Ux9eGx3w81aSRn2Ajk15kfNqfd6mFfvuLrzKLUHaoQt66o5un2bLJI08yFqOmU1abcHnDunfLm2Es+okGmrahWbPJxlrPfJYefVivZT1MqkIDlyfbfYRo1PbfaPrAahVhcrYfbj42v9ZGRrd6ZfOOJxBo48lCVSDMqeY0xCX8LW5cz9FYHxxFY40OMuy742y3r8kUT2rvEtqGNq5S6t4eyhqyHAXMOuuflB+iILwFXnhhYItDiOK028M4JgDq5pxCAeYVozJwlFWdFIm3t+l0UXKnQrLccOW+UJZ7cNjCMldDtbJwhip9Ou1eqdy3QNj6scx4BZ8iC/3uHF98CLOdGIfE93foupa1jYwQQuzkZeCYeqldl/2Hnab/TZSLE9r07kFLnY5mWVRxmXVNnDqzOmovCPzIeRpxZfYVpG76EEmhqPvrnqSkzlisIl347yDDwUg8KlQswv99qrWCodpAgkuHxe9tgGYhlsv9a0zxF53Mz57DqyytkserM8kyQAr5zsCyN8x45sk/tZqdWT39xBuZ+WXxdVkxIR76SI5lG8De2lSg2eY9jlzzJGeMuIZdOW7tDvjY6pWcx1V+1RQtcgbW5jJjJ5tyJY63USCTHxIyBcBuL9pl1Z6PdrFeN0AkLI6dJOZz7P3DOLEUNmr6eUwkTPt/Rsx+/X9/nGjlSsJxov6Pwf14PcnH2L39ocnrjK56x17MLY4yF6ii7So=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/sev_smoke_test.c        | 198 +++++++++++++++++-
 1 file changed, 193 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 8b859adf4cf6f..8869cca748879 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -253,17 +253,205 @@ static void test_sev_smoke(void *guest, u32 type, u64 policy)
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
+#define CONVERSION_TEST_VALUE_SHARED_4 0xde
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
+	GUEST_ASSERT_EQ(READ_ONCE(*test_shared_gva), CONVERSION_TEST_VALUE_SHARED_3);
+	WRITE_ONCE(*test_shared_gva, CONVERSION_TEST_VALUE_SHARED_4);
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
+	vm_mem_set_private(vm, test_gpa, PAGE_SIZE);
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_HYPERCALL);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.nr, KVM_HC_MAP_GPA_RANGE);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.args[0], test_gpa);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.args[1], 1);
+	TEST_ASSERT_EQ(vcpu->run->hypercall.args[2], KVM_MAP_GPA_RANGE_DECRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
+
+	vm_mem_set_shared(vm, test_gpa, PAGE_SIZE);
+
+	fprintf(stderr, "test_hva contents = %x\n", READ_ONCE(*(u8 *)test_hva));
+
+	WRITE_ONCE(*(u8 *)test_hva, CONVERSION_TEST_VALUE_SHARED_3);
+	TEST_ASSERT_EQ(*(u8 *)test_hva, CONVERSION_TEST_VALUE_SHARED_3);
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SYSTEM_EVENT);
+	TEST_ASSERT_EQ(vcpu->run->system_event.type, KVM_SYSTEM_EVENT_SEV_TERM);
+	TEST_ASSERT_EQ(vcpu->run->system_event.ndata, 1);
+	TEST_ASSERT_EQ(vcpu->run->system_event.data[0], GHCB_MSR_TERM_REQ);
+
+	TEST_ASSERT_EQ(*(u8 *)test_hva, CONVERSION_TEST_VALUE_SHARED_4);
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
 
-	test_sev_smoke(guest_sev_code, KVM_X86_SEV_VM, 0);
+	// test_sev_smoke(guest_sev_code, KVM_X86_SEV_VM, 0);
+
+	// if (kvm_cpu_has(X86_FEATURE_SEV_ES))
+	// 	test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
-		test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
+	if (kvm_cpu_has(X86_FEATURE_SEV_SNP)) {
+		test_conversion(snp_default_policy());
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
-		test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
+		// test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
+	}
 
 	return 0;
 }
-- 
2.54.0.563.g4f69b47b94-goog


