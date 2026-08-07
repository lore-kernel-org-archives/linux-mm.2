Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 377CFC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7E56B00DD; Fri,  7 Aug 2026 17:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730216B00DF; Fri,  7 Aug 2026 17:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6209D6B00E0; Fri,  7 Aug 2026 17:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1403E6B00DD
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8690E1A0156
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:03 +0000 (UTC)
X-FDA: 85075824246.26.2804DBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 93C211C0003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k+E8MSzT;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139581;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VxR1QPJUMFnA7AVYndiTBvyTL9JBLx3A/MCyh3JwCw=;
	b=zOhczKaXa1Z9OkdVIB3ZfIPBblQhhy6uNPqMHKQgLhx4I8tNH1hvsYqmpzUGZSDBwALCpq
	vXzsZiDnauyixFs4UHQLDST6x8B3gm+v6Oq/C/FVckl07H5vH/aDzKydiCb8AsGH79fCwm
	DvHWxwQfvDjXrh4ieR61H+ZN6r6tcZY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139581;
	b=gf0Sd619pijzD2GWHYuTXsvlhzOiMBL6Zj2rQxzEFeAa0Gb1VaKemGgsFXOXDwLiv1Pjb4
	/BosZz1CX6wv2qtm8mpe725XdvhVEUjJavN6Asly2S1sRi7wFJteJFaqYJ/xeEMhoF60I/
	A7xt/IGjkfQwwlUIXfoIZANtp7VdCZE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k+E8MSzT;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB01345216;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A31E8C19425;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=vGnWVzShNxGcZYSlN1XQqWFKqysFHKcZqPAawHxJEHI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=k+E8MSzT2UJz+CoV1YzWNwOaOmYmc4xLFaAiFY5A5oj7rEtUSzaeXpfLCTlz6D2ZH
	 MlKmHlG73ueo+qzWJ2zQQr4xADO7qFXGuOU7UvxsxGCNPTiU/E95PYE7HhS4ujxvJ2
	 /R9bGORHVF66SZ5HztutQ4pUpkUzD7JU8dxERq+HUffxNZgu/MrBqroFzTD8GQp+/u
	 fK7qTIYpFtjPAm4Wxe37ieCHpYFFYzM+oVPxgrBbfDf7glZwlNF65T+CdYPWaZXTGc
	 j5ZxnFSA0UyYpROV9gLgDXeUUbo+UobquN6JGSZg116DhAxrSbBO/wIdvRIktK6zeh
	 X7M+lByAl+Ulg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE03C5AD2B;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:08 -0700
Subject: [PATCH v10 29/41] KVM: selftests: Test conversion precision in
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-29-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=4638;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=kKiOh2nP6kXCIDYZiiw9BDuPZquf+YlONNvXtpCpTSk=;
 b=j6UiPvLckjIyGe3ldPwpSSVB5A4OrtpmuLr+SrVGh5brvFGaQcnAv90XUtG5FQCSfgORi8OiX
 cLHvsRgcgMdB9OKPfYrYSlf1/CWG/ac8GN4Px6JgS5wN/qoxjL1InA1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93C211C0003
X-Rspam-User: 
X-Stat-Signature: iij19eoypybti5e13d654688yim7z9py
X-HE-Tag: 1786139581-763922
X-HE-Meta: U2FsdGVkX1/wThgKlt3+bIqR6/YE3AyE8+bZ8j566/eSgfU6skhlmmjC0Fh/wizfSy6h7ZsygbuA0wFPJsW4sbidL9lAJ7+SO25drRDfp4A/AyYbpThIA3prMeAEFre4XVFUZ+CkLCtxwUXf6Dq5ckoZQ8HnF3cbt3FmYtuKvnNrih8vP4PE6lZ/P971erND+diWD6YIC7rZlvtCxKMgU1/PFWyY/hE6AT98qbBwOKtuh3qcjNuPGAASUnJN0UvkX+8yxXCrTcwYcrIF/8EVKKySEIY5DUUYmnOC7pUeVk4VK1t51qaCcOadnwBIHd0yGvKEESP8GASNrZT9/aG6ETxlTfEtXbTQIYWf2bZK2WTR0N2bPCKLHDdfdAUiXF9IWXXsaRDIAtEBV0aZaiEE0v+TUJVFCBOINQfqoIA+s9UttJ7StnP9CQjoew9Ld5qg/QoKhH6Fgc8uTZOrFDYaYvEpS/mCglTk1gnY4+hVqDKOio+4worYu8oSBz72bm6bRABf9AXQfDNq2VmwFhNaa9zxndHU3BcK2PzqaHnFxfmq6g3exavjyYKiQr6ha7Nyz3gKgs+4YBJT5vgi+zMVcy8WSUPG3N+jBBY2rr9txdjYqsdmVitdvyfHfCwIpTq0Okkl4glVhh19I8ABBsUDE4e8wLKfIWB0HxBVWZMx1VwWK3qDwi4O9CDsO6ch7wJQA5mEVTr0tP/mNx2dXvRjzIrZO6/AKnV+Sm2a/nIJjvcY60ynvhXiIhTnnI05tJIT1RQhK55hrf8SjHk6mFwMaJHxud5iBtSkZh1IwvwH/MQGL19Cl7kZjpkEd5rlHam2iLgV6FIgxF4x8IkSjrfW/v60WpWH8cXdwLhL3xCqCqSmMj/zhzZRpj4ldxTguxKT48QkAB/hvrr+cCqI+uo1zasqK16z5bHLyPCth0NgDGEthnMg6h9FbcrblKyX5VxLxOiDCnnWuoWhj1g+d8Q
 tgTFVdy6
 zVoIIF0ocvC4lVLUyK/a3Hl5lrEWHgWldnMaWGOAUJbUdrNA02KplXPDcnznoEXiI0+mpqSMA+WXkBU5NTRd/a5YG+BrUWbTc+S6Eg85XSkDDNrSO2CQURnFz3vUGt9U2lmvjt36qTIdEBw66FfrukonqbiPn/TsKXSxAKCaVuLEm7NTo8jwaUATp99ZGyaf0cMM0UeNtoJE0bnY0GlDfmCrloR2qkgXvmHiHxBo4ol65prRSJv+MZcxLqd69PgvK2jewjp0FG46wWjSl955GwlwbOPbI5vAfQ3DTFeaiH4ZK9Um9EUNI2h87CZAULFDkLFOZw7R9WChOJwfXY04wxUeQC3Elu+Qc5+I1CzTtD/gUg63JbtNaEScPB579RfrCY0/7BFC/5+HK6re4/ELSoPYdnpSOhPGFNjf8IPWoETRSleiw8FdFqoR9SvtSnI/OAlL7HKqKOFK2/sMTCUhCqWXZeF1xhinkgTgA7tn7YTG8UhG3pc2BH1Q1qxILLDSEvFmne/3oCPFSfEaBtaekhpwF3Nle1+AceivB30ByqQI6e1xw7AkF5FB5/a6azqMR4K0W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

The existing guest_memfd conversion tests only use single-page memory
regions. This provides no coverage for multi-page guest_memfd objects,
specifically whether KVM correctly handles the page index for conversion
operations. An incorrect implementation could, for example, always operate
on the first page regardless of the index provided.

Add a new test case to verify that conversions between private and shared
memory correctly target the specified page within a multi-page guest_memfd.

This test also verifies the precision of memory conversions by converting a
single page an then iterating through all other pages ensure they remain in
their original state.

To support this test, add a new GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED
macro that handles setting up and tearing down the VM for each page
iteration. The teardown logic is adjusted to prevent a double-free in this
new scenario.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>

---

v10: Update macro GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED to avoid
     potential macro argument reuse
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 67 ++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 4c20d3d8e9349..a8d89df53e46d 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -61,8 +61,13 @@ static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
 
 static void gmem_conversions_do_teardown(test_data_t *t)
 {
+	/* Use NULL to avoid second free in FIXTURE_TEARDOWN (multipage tests). */
+	if (!t->vcpu)
+		return;
+
 	/* No need to close gmem_fd, it's owned by the VM structure. */
 	kvm_vm_free(t->vcpu->vm);
+	t->vcpu = NULL;
 }
 
 FIXTURE_TEARDOWN(gmem_conversions)
@@ -103,6 +108,30 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
 	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
 
+/*
+ * Repeats test over nr_pages in a guest_memfd of size nr_pages, providing each
+ * test iteration with test_page, the index of the page under test in
+ * guest_memfd. test_page takes values 0..(nr_pages - 1) inclusive.
+ */
+#define GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(test, __nr_pages)		\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page);		\
+										\
+TEST_F(gmem_conversions, test)							\
+{										\
+	const u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED; \
+	const int nr = (__nr_pages);						\
+	int i;									\
+										\
+	for (i = 0; i < nr; ++i) {						\
+		gmem_conversions_do_setup(self, nr, flags);			\
+		__gmem_conversions_multipage_##test(self, nr, i);		\
+		gmem_conversions_do_teardown(self);				\
+	}									\
+}										\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -201,6 +230,44 @@ GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
 	test_convert_to_shared(t, 0, 'C', 'D', 'E');
 }
 
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
+{
+	int i;
+
+	/* Get a char that varies with both i and n. */
+#define combine(x, n) (((x) << 4) + (n))
+#define i_(n) (combine(i, n))
+#define t_(n) (combine(test_page, n))
+
+	/*
+	 * Start with the highest index, to catch any errors when, perhaps, the
+	 * first page is returned even for the last index.
+	 */
+	for (i = nr_pages - 1; i >= 0; --i)
+		test_shared(t, i, 0, i_(0), i_(2));
+
+	test_convert_to_private(t, test_page, t_(2), t_(3));
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_private(t, test_page, t_(3), t_(4));
+		else
+			test_shared(t, i, i_(2), i_(3), i_(4));
+	}
+
+	test_convert_to_shared(t, test_page, t_(4), t_(5), t_(6));
+
+	for (i = 0; i < nr_pages; ++i) {
+		char expected = i == test_page ? t_(6) : i_(4);
+
+		test_shared(t, i, expected, i_(7), i_(8));
+	}
+
+#undef t_
+#undef i_
+#undef combine
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.654.g21b8a5bc05-goog



