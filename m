Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB15FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A8D36B00FE; Tue, 28 Apr 2026 19:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348696B0100; Tue, 28 Apr 2026 19:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173276B0101; Tue, 28 Apr 2026 19:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E75636B00FE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:34:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 082388C5BD
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:38 +0000 (UTC)
X-FDA: 84709548756.14.7FDF10E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DB34240009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BNsITGgp;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418736;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtGY4D1s0pR7EvB+iMyyhOcblTZmwS8xXDVzE8cNlnk=;
	b=O7ZqWgVFJE7gcHKpldbYgkIg4xGie+9oAAIS56ocvq29bfNBvFVDfjE89VNHZ7MoK5exns
	MClCHTDJmnFnRR5yH/ttw3P11cTukQxOHAK5dNX+Iu3OKZQWuspjgoYkDLY3zP41AOfFU3
	ByMeLeN7qywkM4z4uQ8RjHFKTFDj+J0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BNsITGgp;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418736; a=rsa-sha256;
	cv=none;
	b=3T6J8QGv3EPglTvPJFJfBORVIYDaR8vVczgEMT5kEUFUhudwDd+myEkZl0lf6IBYM0/wGu
	nzWOBchMjeyJVxxBAhHy7kkW3/5ySvR/qD+ATsnpV69YbiGWz+4m5o+vLNwUC9vKxAFCV/
	0fNOTPllikDmYF2y+U/CyyNPAGVywX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72B0944AD1;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 460C2C2BCC9;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=sBN0h+hAvY4kNZLEDPJgJDjLNnhtjXYYJqN0Dnxr2Po=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BNsITGgpdEa/FLWM7c1vj4FHAz3KBfI7YZfj38qSTyRWKqYISJe269cfKs8+v1ayt
	 n7uOHUB39QmkC8YPp1P+q2Cr9PRG71C4oGiQdMwVSdvShr9egNxp44HVjjd75fCtI/
	 JPFVIG3YsD+U+jaHvRakxZTjamyRYXVdzyvrj2ot0L2BNpyahQzEiaZX6kqwxqLYRd
	 +4ogPkIl0fURXuWFteMM9m5sqU8wI9H5ni0L6sZcE/4m2UL6oj49S7CsyeG+ygGMeT
	 6QogDt1wZvgz8cGoP2QwxedfIGHxKUWfCYCLWAkLYxZx/cYUT+XFL5l1xgzPil2/xC
	 dw+DnkEp7yAQQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C72FF8877;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:31 -0700
Subject: [PATCH RFC v5 36/53] KVM: selftests: Test conversion precision in
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-36-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=4475;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YNDxiD1D/UeS0bOub6DUeHdSR87Xs3I++ttjrV0QqyU=;
 b=NLYnFgBo2Gpr5x06ieUdK+BOSHCCOAcVrCvIuE55RGZ4yINojPIaxgBdsaBoKXBUI2/o/be7D
 NkKZmV5UnN5BWuR0cPm/qbBDbjA8VVWYDhM0cxkjfA1Wu3umAvB4gWo
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: hx8q1uu85bhoxbdxrpxsruebby1af6pf
X-Rspamd-Queue-Id: DB34240009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418735-193597
X-HE-Meta: U2FsdGVkX18UsugP3PDtzl6x+ug8wlHf2X6pLWshlepRgzQFemjUzEl2GHLihShU3b05Dukk1Ns190pEFZnweidf2jM4Hcz7GJ9TqPzo27HqhUOzFmevdM1nUi+CNOgq4XSw0y5E33oeykoYEnXFBbDS5R3aZZ0IYdDdyWfY4CSASiBqQ9zY3NVQ9pXltmbAB5gYvR49cAxUtXWWKYidgzBMO9M2VNSwEkIldjuyEEFFufJRHPry5b/0Jl+H/kSf1fYYMIa4JIbjw4uF2Z0NHiNzr9bg4vMSQRBEWDlFGckNUzAhuNTQAta0RNaIZjINXJvHJwvRQgRZb6CubGa4+71RRUpZD4khd5TiTATmq3mAUhtloJ1utF8j2Jim4q5RxACw5Cj7/DyBKd8a1TmJzWhSXJMSL6hzdrLQbrvDL+HHEzGCaXrNRUJXJ5TiZgOQrmjuga5b9EqYMoFe/mumW1RyMATbWGN9ekhrGAqn6pfhfE9EUb9ZwSdeD+JhTwcBxdKq13EBHzU5LQuGywpWpeTLDNXrLtLIIYsykUxwWV8kfVMX6slc7I6ZpparkNhlN7UJr3WOaEuVJ+nj5Up4jj9DAwxHOBNcYPEQCq8ynW/4pKZyBaKZogVyDiUpjl8tHg6OwAWEHuDJFgOHglpEyHxXvqeJ/Vet/Vsx5PbfZdfYw1bG6K8JDZ4nc8tb1G5TEFO7odiBIUp5iD9QgNtxbns10NP1iteAux2Jf40cAuE6YcfppR0pKz44EPBWYAclPGeO+SOnakpAVMWQ4AB7DnRKJIIZqqGOjCxSCH2wynQwuVzrvN1m7bbeXiXbQg1wPVWi+nq7cjPGZahDVzKNxpTUMaixsz8/r4PhzF+nQzO7jtZA+XBBoFzhRT//ERgHAAG4bMz1tjin3I5NOCOMruOKqOLk/YNyTWKq68u8e6+j+QzpT/A5VQOPFSXvNAYUZIZbTkP47cVR/k/9CAw
 zMFs/HxE
 xELa+Xh4pURMeL80FFlIwkSB2dDFZeJJ7MFxRFaGEJXLucYdo2qd26QHphQeFKaf3MpnNZ6rPRMTmHNNbxmmhiIAmye5TzDhpFTeVViSZIItxpYYfup3AE+8/6Z3yZi6abQfRqGmddGx0EWSQFSgGC9xlLgLj8F63z2eJhN0tekkodB6JQkNrSBNZS33Hgg14XniDjNWu8yTzZhwrXqahErmcPr1MXE12Tm9FTtuI7fB0fu+42jxpL8xwxWWAnYPv9Jfp8Ck2YSnIFPPN0pSz0s/K/q8VVMwNJpf17YYRh1DlTPktSOlBytjQ+5koA68728tPxsNP0/CRFIwrn5fJGBccTQkd6JWr21Dosuz5bGGaRMbIpMxUGmygyrIl4hp18w8wf1PX8yp5H/emM1rpmQmKPXJf1IK6vth9JHLPXl9i2Dq0PutLpYw6ycBF0XwyqjgWNGuA/1xhqW2+JaP+A8DUXQ==
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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 70 ++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 40ac1b3769af1..25f463bc9da52 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -65,8 +65,13 @@ static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
 
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
@@ -105,6 +110,29 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
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
+	int i;									\
+										\
+	for (i = 0; i < __nr_pages; ++i) {					\
+		gmem_conversions_do_setup(self, __nr_pages, flags);		\
+		__gmem_conversions_multipage_##test(self, __nr_pages, i);	\
+		gmem_conversions_do_teardown(self);				\
+	}									\
+}										\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -205,6 +233,48 @@ GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
 	test_convert_to_shared(t, 0, 'C', 'D', 'E');
 }
 
+/*
+ * Test indexing of pages within guest_memfd, using test data that is a multiple
+ * of page index.
+ */
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
+{
+	int i;
+
+	/* Get a char that varies with both i and v. */
+#define f(x, v) ((x << 4) + (v))
+#define r(v) (f(i, v))
+#define c(v) (f(test_page, v))
+
+	/*
+	 * Start with the highest index, to catch any errors when, perhaps, the
+	 * first page is returned even for the last index.
+	 */
+	for (i = nr_pages - 1; i >= 0; --i)
+		test_shared(t, i, 0, r(0), r(2));
+
+	test_convert_to_private(t, test_page, c(2), c(3));
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_private(t, i, r(3), r(4));
+		else
+			test_shared(t, i, r(2), r(3), r(4));
+	}
+
+	test_convert_to_shared(t, test_page, c(4), c(5), c(6));
+
+	for (i = 0; i < nr_pages; ++i) {
+		char expected = i == test_page ? r(6) : r(4);
+
+		test_shared(t, i, expected, r(7), r(8));
+	}
+
+#undef c
+#undef r
+#undef f
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.54.0.545.g6539524ca2-goog



