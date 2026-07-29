Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A22E5C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA2D6B00B6; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C0A6B00B7; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980046B00B8; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A51B6B00B6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 072DF16059B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:23 +0000 (UTC)
X-FDA: 85039945326.01.C7AD7D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00182160007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g87sYffm;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285321;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hmcb02pkus5Dq4xN5sj+/oNFMKImpwFIiCXtSyDEUKw=;
	b=Y3FcUg0pYU391kdIvRlsxYHGJpYZqpc8zjv4HpSh7rTfzH089RfVZYS/sqYPb/o5guE3sm
	ipBHD9lOsRvmmZICki8bRX+83zXLTVn0ZPJFXfQ33Z9AhwOt7ivZFBBAeVJKUQOhMIKTt8
	VObYxn9jTJ9e5BRHBzq2kSubh/zRAps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285321;
	b=CCmu8mnLdwun+VjEdszLWxWtIP9tUrEEQYedVuytPxEzRpGnuQnkf1AWKJrvRkPkWcqMUM
	4RJgI0/mPjyczIMxlaZXuVXQPuEeznWBpWbxVkT3lmAb7u7Kr9RNsK7yRMwI2JIdxm1qWM
	B1eUGv+Mm89+nCOZmJmqFtxchW5jGfQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g87sYffm;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A630A452CB;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36698C4AF0F;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=1JQNdh4DTRcD0JOIKHjtjkpSS42mmFJgCVctRlKn/as=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=g87sYffm6OXh1KgFt4W0xGJ39S7iuVXQvNPAuoioMapAR76KGjjkxDqfIdG7pymDA
	 y3uejZCHw7c8644nRK0EaeNDrEsHShrKgd218eIck5k8s7TuCoXjA+dYZ6nEmt86T7
	 ycJA5RmX+sU8hhPYd26y/boyFbc7b30yStyolWW0QSTbN3gD/z4O+6FY1CPQJq5+2G
	 Tz5UGum6WIBx2Cigwt/V+R+F6aws8oVSr/Zaun4bjsUphc+QAUtk3Rqeck5BDrBfOb
	 yvWYOysSXUXvw/5DwByHFatRO5/3n92yTl74ZJBVsKqf4nxceeH5R1+JaY8LSmNzQY
	 EB2bn9KiZ9Iwg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18860C54F52;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:28 -0700
Subject: [PATCH v9 29/41] KVM: selftests: Test conversion precision in
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-29-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=4501;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=knW3oEUmnPUSo1gpuqMigsR+t1Q/MFkz7O8GozByUvU=;
 b=fUXw40FC3/ChFHnmqc3VbvieVKq/kEnvWrEo0D03rJCacRFc8ThJ7uLfQzZnHhE22ixPpJhQc
 O27XDvaqfvxBLbgtpjqXv7wxaeb8V+TWRBvfzxuPcZKtdRwums97nOV
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 00182160007
X-Stat-Signature: d7seka5er8guchz7b9n4y9mmt1dsmudk
X-Rspam-User: 
X-HE-Tag: 1785285320-819754
X-HE-Meta: U2FsdGVkX196Xxa7dVll3s+8QCWDOC0I/oa577l5IZpGoq7HxzaiChqclvUhZ389BlmqV+8Dk5yp58/LNoreHO6A/zzn0wg8NSapk4XvXxMydwjjlyRUqi/IIBaKBkGI0V4D6Qb7lI6ee9pxSQtyfe55TfpqxT7Y3pBjWzaPUQbCZNGPcxwabB/J7uoxJuElTUlLXwy6vpJbUoXvyXT7X8LmDBEx57JzG1WYxPuZ04F/d9xhbKAV1AHDXv1f9qEFytrF8p6AmztTp/yQcllGF6y+DZnQc2jiZfTRYTCVxsGwGla5ercsXPadb11DoaqdEx/qO0HVd6l4io+I9u4dfjzIVECffN39BMFwSp+Ux6c3UjJDpI1ddi2SPHUmYzCbMMK3xaOWCnH7KXpEUb7044QRj38KVTvKn7MntcSvl1vQFWukPZ9iCMUQHokIh5OjhOj6YJUW7KJzHaGWucIxwIxWs8XewkE6RTIimHZg3x+Lmyrf4njMVW45WIfBP39dy9jxC8SuMrYYg1WbnmrwLnPUkqfXCjkd5ovlsdsw2mF4zbF2Pb02sth584GSGABXlAQCVu0QfVhBW9z1IRs3bM+3B8UuoTikhKDOZEjXrdS6sZlZXNPjTbUPgGPBZHi3l9HkgUnliMuxTXsSHATrIhUd5i7v8VEG5VL5PVGuj0JW7lQoVf4ktS1HMWxwR0U/TuGta+OkyMCLnAgbq63Rat0dx0+/S37lh5TyTWVjwczVd0wvriZA5lSn/sKYG+aDJzqp4Qlfy75FzV8ycn87pF+v6SeXxibxUdlw7aFa7hyRn25YAr1oQOdON1bsSchHuIExSMubmOYoZDFnehM4Q6dpzaZ2naQKnRLdBgMBRtkzEo2AVTaQa9VRflmVdLKJQ8lbDHBjAddJ37edrPLriGXca8dHifryjEzZf0bd2636hBOcyMahAzqL37F04ZuZHupA1Bgk/jPfG9BjQcV
 9bhNoVqK
 F4NBQrf4mxfbN8N+5wVoTqrFU87rn9ALcm/Zx9cw02j8sV3knvWoD6TVzcX/kLE0Xy7VlRMqU5VPYMMRBJgCtVZOzy6ky3Rfdk4Ghe1++e+16coN+yHlM0E8HDGNnfywNBWBJx4MFMlSKDfFef5xbfDMUUD1NriXj0o8p6UD0PQvw2NrcPS07Yk/FGOAQatSdaMbV2G44kyqK5RpfPQe+rqPh8A1YSWefR8cVGIDEvplK9F/bDxypNOkEZFTe0EKrSnVxHmvuvqlLEAcNTASLA6WXFLaUqSs2xUIZFLhk34KGuSubLtRzZcQwhpd7eqIZwd4GuaFZE2TTc1q66veEywiCWS1bnHUZrQbqp4zgcwMbMVCWLXPAMfL6DGBRTJafDJchATFdis627qd3F/YYlg1gmM4mnjzHsI7Elx/tRGR2xseSHsYilZU2iQdb+NK2Uc6PP0kassha3uZb3PXJ/2of0Fd97muDCYZ0ubobhjGF0u9sKc2c5m0bqJl8Zmbli2u+v41C5MZTmSTvQ9244r83k220wRrqZSiZ2HqhwfwksKaFLN9/RarN70erPA7rKQK+
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
 .../kvm/x86/guest_memfd_conversions_test.c         | 66 ++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 5b070d3374eae..8e17d5c08aeb8 100644
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
@@ -101,6 +106,29 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
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
@@ -199,6 +227,44 @@ GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
 	test_convert_to_shared(t, 0, 'C', 'D', 'E');
 }
 
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
+{
+	int i;
+
+	/* Get a char that varies with both i and n. */
+#define combine(x, n) ((x << 4) + (n))
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
2.55.0.508.g3f0d502094-goog



