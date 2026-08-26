Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52250C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A141E6B00C1; Wed, 26 Aug 2026 05:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4B06B00C2; Wed, 26 Aug 2026 05:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865676B00C3; Wed, 26 Aug 2026 05:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 515F66B00C1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 210E81C1845
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:09 +0000 (UTC)
X-FDA: 85142871618.10.42D096B
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5C18D180004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nrihtOCX;
	spf=pass (imf06.hostedemail.com: domain of 3ia-OagsKCH4cemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3ia-OagsKCH4cemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QanNPXruSQXVrF67aaQcoGfZbE9UbCtKaKkFHYTWC+U=;
	b=g7tgyL+cTOdm8sR8aGnOE39I3uCixzuZUBg2mujJtb8AWMF4gSQ53CdEnn3SgUYiIg/Fco
	q0cgTSo1gWexg21T6V7T5IMH3oPl39MoJmivrzIpyBpRlxBPbmvGGHHw/dBYZZrThqoDgN
	EhgNvzVHpVFLtdThZVerjmcf5MV96hg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nrihtOCX;
	spf=pass (imf06.hostedemail.com: domain of 3ia-OagsKCH4cemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3ia-OagsKCH4cemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735947;
	b=ZUVIBxDiDsORb8t4KX6SG8c+Wxge+Fg2hdpSh/GtPA2vniY4Q9TZMtFAZDptOEEVhFZ2B7
	pCMfs63gZSRpn/G4F2kcvW8TriDT65Bm+vqlVxdjWJ+nUlY0JFdqgs2q6WAj38fWrl8yAg
	VorTCWMECKfjH2C+bZGRDel9shAN8Eo=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce7dfd33ffso6578065ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735946; x=1788340746; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QanNPXruSQXVrF67aaQcoGfZbE9UbCtKaKkFHYTWC+U=;
        b=nrihtOCXgYv2bISbcHyUgxrrC1mJN4fi62BsPzR70MN3fdcKLrZ9SEIenRazA08Bai
         4Ax2eqUEtEEYXauvz7iNPJkVatjeMwbzSFJkFa0OT+NR4wLAyGxM9CnfnLiFM5uuEZ2k
         b+ZVtJhYMpwzFwAflFmYQJECrEkvp1NNNueD2Bv3KybA6Srb5EBm/dHTyfwN3oTNuJsb
         2zC30XwyMDm5rvu9shrNwPeDanGIK5TEPfMT2xI+oBAtRwI/Systt3+nDwLXYhJ64swU
         7D0MJTmcSWCa+NJ+iABKUF4QIOFd4HQ1cg1D6odjsvEWKt48ofoKtPTTCsxLxBlmuNG0
         +QAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735946; x=1788340746;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QanNPXruSQXVrF67aaQcoGfZbE9UbCtKaKkFHYTWC+U=;
        b=bUMsBOqur/pnyq7vm3MVwbaM/2H1x/F0trD9+fmhiABs9nxaLvUybpk93i+cNDVA8R
         RRNAuC12KdNI+7jdlJdCP4gvJzLEAfzFfMCyLSUQTc/TMBtepCY/KjsmcZi+Urc2G/31
         DirLWh+Vhrt6g+Idb8rtcwsee6aKNqu4Kw52lbSnjFuAJQTuDsZ1aCsIx+l4Zf30rnxw
         9W4My5Xe1A6G1WvTLPIvkdgtPrNEK/PSMedz9gLb/omUF95EeQtUGkDUpenK1pReW9o+
         phIlmK0yq47VsZr8iXsmVjnun502SsGhhxcYjemN74phsqWKgydHrEo14izN2e+wz0Gf
         lmmg==
X-Forwarded-Encrypted: i=1; AHgh+RoYl4ISmlXnBxHjDfULUPKZSmouMSN3CrzCsfo8mImK2JYHL43Z4AErlw/SaQ9QbVHv5pFt0nGxNQ==@kvack.org
X-Gm-Message-State: AFuF++mxVjBSUeHqRrhYoLRWgV4eUkT8qcsgbY/LnQQj76G3H0EFM8ir
	XWu26BcZKbUcg4L5sqvqTEGqIjHhNo+M5bNqKg634Llw5Pq3q8wiq3BFnrOiSiGBWl4yPHDyy7N
	Eo3iDf0osQSVI7f1ZgWYg7dMz2A==
X-Received: from plyw15.prod.google.com ([2002:a17:902:d70f:b0:2cc:6206:58ad])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f541:b0:2d3:716e:e2ae with SMTP id d9443c01a7336-2d707ab1407mr81866255ad.6.1787735945585;
 Wed, 26 Aug 2026 02:19:05 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:32 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2317;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=7hWrOiBCNLWR4WmaZsIQ/WiJTqMaoqs3GPpOPxdsIrA=; b=H4rkK1YLN75/OUClRsyrNGZ+v8Y0cZ9iPfybDQNGwCS1Lp8udQXVRcUWRxH/i7jKh5B1xjwbI
 /6yH7SDOMn/C3e0QrzREPxPxypHEsDepGeNaD2wcV8oKFQzOKNmrTyz
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-34-0a15d8a799aa@google.com>
Subject: [PATCH v11 34/46] KVM: selftests: Convert with allocated folios in
 different layouts
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 9fsiqwgtyd1wo57tzr63c8o76drossxh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5C18D180004
X-Rspam-User: 
X-HE-Tag: 1787735947-853856
X-HE-Meta: U2FsdGVkX18M3KySAm+a2Y3JJffYGV5eUEgfI6syeJkU67j/cz/5ePSSHnrVfI+U4spz7OSrAqB2YLPhtmVHJCiJ6yuWu+2fONGqKMxvGoPvV1aH+IuJ+z5PMzXmUWfD8YFGdAQMzluzc0FZbpl/xVYTIb2ECbavZcpgQ5q/v6kO0VzSlArARnhbCYJilHmymIrI+y9H3y4h1eVFvfeRHhh4O2cCTa5uxMZ0QnoChvXaaYyV+hjpAIxUCXBsPrzVr7HETrK9TtwxKOswRaO40JXKLptk/UjqW2GRugn5sW4nrw5G3rWJjHvLexqeY0Te6u4qrbjAuYvaSnTf4Jl6hxJdtMcZcgzSgJV40xp/aTK1ki6c3+8/qaj2i+jpIo//Bh2lr1Osa8/9pdiifHEFtVB3arjGSRbXNI44VPC0KLbDG5JER06PiZLXf1/cEnAFWTRD8o0lsmpHCmRZnWGtyRP3SY88y3LXdx29Wf0qi/kBlJ2y3TQxLa9schgu6QhvToF1SShg/3g7yO1mne3G+Aoh51QYoj/VB9A71+5N0xWL/modr4x764YNcsmMNUr+6sBsD9nfAaIx1V1HqkjwIEnfFm/U0MJGwVKtrs2oisfMXfgccEFf/hpjhnf/NMGosa+Cte4BNgzDKmuYgFFoY4FLkUEuPQLCyQlZ/rUlz7p6GS65QA4ol2BHSxMSmYeIrWyMeUFUMImvX9dErEEFujLJ1PH4jTiYvgJWCqNI+fC4g6b1VL9zFLHslBMgvTdQywosN9r3C2iy4P+doh2fDlv3T+mfDicZshheJtruacc4GGAR2KwGdHgXlH3EIiT2ay1FfZfflMfMEmZMtP0UPlmMYxCwMih5X8cHKOTIUreUMzxfQjTpru7L0ybdZrdSJdWCnwie3XDelLGR0AnkvylTitF4rStuQ7zS2w6GpNLBZCYpKtdIsnoXVfnjowvYuE6wkAuNakZ/eOdC0Nc
 l2mO/gEB
 OxV9oXqRtm81N/BvNwC6wecO2JB3UiA1fGsJJz0xrnPXQaUhrWYCsRT9AeZNIEZU8o/G8xookEEoIKSQgd24nfzbpCJO2DY3bSbZSbvaiadfhYlDdZEf262+Qu521AYch4uaYFWF5rm2n4oMeixr+bogKlHpJGsBy3C9l17Z9mMb+73axAns2sMys41VIuLsPZ7azhIB7sdq03P/QLptcIKdwquvnQDGCCc4m0LLWtv34seyCRzYVfnOSBo/k+aVbCWttPMDp5CgXXzJi1bbiH4BmLGtiRu2L0tnDhwVjQoH/WbB2SXJfOKrxrTj1dFIBGxwBAlpCyHO1OB7ZG0J+q5QdsJblwQQ12Trter8JKu5C66G0TElk0ZIFm32iEqQvWFC89EsWiG+DxifXwwz43eDT6XrLzYX5R2WCU4mbwJBrMRU25NC0BEYiG7o56QUBL/sjX5TqPgwYdxBPy0v9nCxua88viQcrYtcovjcwW7J+O07L3CXo2gmgt3b45/1DgKmopKkrQVk1Pw+0mkuTlN9IuendFxKxpsm3YGMn3/VKGpebfyJ63yqq6zqLSI1KfxBG4enoDEJMIPP0yccMCaxDuDDrPDw0+UMbUhLhoMTN9CybuTFqiBSl3ERcBA9mo7coROL80AHc90s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a guest_memfd selftest to verify that memory conversions work
correctly with allocated folios in different layouts.

By iterating through which pages are initially faulted, the test covers
various layouts of contiguous allocated and unallocated regions, exercising
conversion with different range layouts.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index f46f1530a94b9..acdff2d154046 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -282,6 +282,36 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
 	test_convert_to_shared(t, 0, 0, 'A', 'B');
 }
 
+/*
+ * Test that when some of the folios in the conversion range are allocated,
+ * conversion requests are handled correctly in guest_memfd.  Vary the ranges
+ * allocated before conversion, using test_page, to cover various layouts of
+ * contiguous allocated and unallocated regions.
+ */
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
+{
+	const int second_page_to_fault = 4;
+	int i;
+
+	/*
+	 * Fault 2 of the pages to test filemap range operations except when
+	 * test_page == second_page_to_fault.
+	 */
+	host_do_rmw(t->mem, test_page, 0, 'A');
+	if (test_page != second_page_to_fault)
+		host_do_rmw(t->mem, second_page_to_fault, 0, 'A');
+
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
+	for (i = 0; i < nr_pages; ++i) {
+		char expected = (i == test_page || i == second_page_to_fault) ? 'A' : 0;
+
+		test_private(t, i, expected, 'B');
+	}
+
+	for (i = 0; i < nr_pages; ++i)
+		test_convert_to_shared(t, i, 'B', 'C', 'D');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.887.g758fc8c411-goog


