Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DA0C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F0D6B00B9; Sun, 30 Aug 2026 20:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40206B00BA; Sun, 30 Aug 2026 20:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A256B00BB; Sun, 30 Aug 2026 20:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6884A6B00B9
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED439803BB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:39 +0000 (UTC)
X-FDA: 85159671198.25.A7CEDFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D9E1414000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tU7qgQve;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135938;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bdm4bp01RPPXfRY3P1g/knVmqs4g/aX13IjIpcfauk8=;
	b=gyMS54omMMhq2stw2L9UIQfuevPxawDKd9LYqyZ3D/8G/+aQB/9R3txTKSU/nV0iHNcr8M
	1QMQO5K5dKLsPteUUWnkhK3RFtG7EkRSg15+NC735ZVYoyPTA0Ak1I7DJk71A8+vuKa62E
	U1rNS4dXaLBOCJl7GwZYiQoG8d2jHi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135938;
	b=IelYiLIRpvDNDVWMasxNiYvldVJl/dA8VCiXkQ4LLRV5rbHBHzgqPSCjawY6GrvUuyqUfT
	HAOTmHlQCAaNixqh/0XJNaphkRhvM77kYlgIr15ad1ZrUAY8X/kClL+d6DWdr5vHF+9q3F
	7xQOYA279BG2G8GYEJ2hBTn5tqqy3EI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tU7qgQve;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FC1A4493F;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0D54C4AF0F;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135922;
	bh=we+RUoIj4s6zn8J2yaxtxIVwUnD24bYSVQYPl3eVvFU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tU7qgQve50FJJ2Q+r5lcw2n48KTibdcbTz2w1ad715l1gYNDO7LNZ7oZNImd4nhCV
	 5d7F5tYXrvcSXCaBCR/Hs185H8TMEOXY93WP9EivXDTZl8CwCBFo2ex8+6HCRXQklA
	 X4QmnXwqUBe2NTC1i95JWGrnA4CKYG3LG6f8X3fCnDcqM1wX6VZbmXvoTrDVCxCI+O
	 wbergiQ+FVnBgV0zLXsdu2L/IUBQXBuO6F7g/HOSG6IpmPEH6FEr4Ya3GLA1Y0qhFp
	 wbhiOEv7pFF+Vvt6PCawKwNid4y5ZEFs7UGExh2vJJXYoYtCd/xxRrdoV73P/ndIOn
	 z6CAfGCyOsypg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B872DC61DFF;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:33 -0700
Subject: [PATCH v12 32/45] KVM: selftests: Test conversion precision in
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-32-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
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
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=4642;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jtZjcg6wGzKgK/2cSXFW0G1Fk1Ysj4xXn5RYOoutiT8=;
 b=BWwpnaO/ppzNsjzvl6ryVPzJ03QyAOXNIIsUPy/1AXg1xCUTlEBaIbIDj9LIeAA4ek7JCR54N
 F39XwjjeJTHAq4pMBh/eM4Vin5uAcNuNCNrcmko4haKka/WT/Xm2OKA
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: yjis4m1w8xcetkhnm8fyf34q8hom8994
X-Rspamd-Queue-Id: D9E1414000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135937-238093
X-HE-Meta: U2FsdGVkX19AudwGdMRHYe7oYqdDR1343uvalUi3h0wfaWVf3gtrGr7nXZbB6C1X2wXrB0frhoHyBQpd0N/+iysyyF/hs8n/ou0EjLD0rUX4BSRNyANftFnU+A6EoOcsoLQQ8NtK/guZLtxNfEhpB8fcy7ODNAM29V+uMK88Yu5O6f7pRLS1dmuHNLrWZpIhSaSaL5vybbH40uiEt1zIobZR279gPz7cy91w01z8clKjot2V4cNtf2yPp5YMVy5a8qxekPJfRPvuiJl7mI6nUCeWpLEUuhR9bfOH5+/if8t+9hjjwe0QHBdU6Cgfb8BN1Q++BN1GaCzpngvcKUtvCH1FIB/1zq0OIZKgPwXxYVBIimX+py9NmTypJymUQuSHOiN9ue0UEXSSfV0eg6w8kHWK2r930aLXpp2Yt+uMm70dq+N2zGuSZNNWOYuOb9OFKEXCjNGT1CaTLDUA+di0rUc4ggw0LutICplxSJ8TcjmK+Ku7jXW24G3d/WvQNGJYdi6WTCLBOQnCVTFexWMTac1nDvSrNmYNiZDrtyYzAeKf1nGNeZZ5Pssxpjf3NxwrTPYahexa5G6WTOZy/yzc3zZLk5QWH1ToL5Z8ej8S5Dg8sFStJ90aRHvjUJxEmNETn82jmXQsqDB1dpgynjgZcbnt/qEKLgJdZ5xblFkKjwb1FRFMWwy9w9oXxCqzK+Q8mvaxJvge6bIEIWwc1wKLGV146WSM+xVp3hqLxBl0LNL1ozlSOtEummv4l4baKFpimhdAygXliC6J2wzRhMeZ0M3pMZ+9SG5jdhk/4t2H5JWyNnfAVI3e+bm1qg395ceJR7JbRzm9Pi+UnpNAYJLZyCXEqu3SVQjMsbMuE14HX/NObEZnrhxDyd+QZrrxDtZFjIj2ne2r9tJFkkfS84/VawbHVjW4NWUDt/axyq698i6wE9U4Dp1eSf3F1auk081+TMbeJDK9IwxNHGTnD2d
 g3JthIdR
 BvBso7fHzxQvnnYFLtV29UmKCuvl3+ceYt+c0PeK6SdcCeFruDW7gwnM0F3OBJ4PnCunEsvZTggM498NZH77sXCTmVDPFpVSQcVbjsKhM+/uPhJI2Md5TjR7CE7zFNDb/6Iovt3tC7EascWYOSh3N6AgdLN1v2bB+hlvz99IKP/qAO0Uc8X9wkiyy+2mCUNN98r580oAo2QJKG2M5FPz/6szkOMRnD2ra3yMw0gDD55WdcuNA3ZdbAiK7Y0ZCL+ZKFhf87Zz8EZImiKvChyWtEzUd95lE/FVf5BT6yINRzO23UC/LadyVWCJBH1PWV7ubR6MUQ5Smiy4MZoa/uOpsuEKme4KbcrHfwIepNwTpvYSi2Y0irOnn7m5nCuGWY8Y2286FENI+qI1tYuP3/bQD92iI6YHLvZWH7T7Qt+YNiXHdssmykPhxN0jcauT3cOvUWrI1lr1+k8nVXpGS8fVaQn0kC1jzoAjl0Ub9/q6DXhN8FQ0cnB0I7rBuKPK3lhoVFbSZlIqNkK6/F7bY90wvgtQDZg==
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
single page and then iterating through all other pages to ensure they
remain in their original state.

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
2.55.0.897.gb25b4bd76c-goog



