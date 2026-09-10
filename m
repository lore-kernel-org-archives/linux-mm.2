Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E620C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2FB6B00CD; Thu, 10 Sep 2026 19:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354796B00CE; Thu, 10 Sep 2026 19:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 269F36B00CF; Thu, 10 Sep 2026 19:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4F0F6B00CE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C6F71405CE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:52 +0000 (UTC)
X-FDA: 85199512944.26.F33D8BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 711EB100004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qc8GXUA6;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084550;
	b=LDDhZ90XBeoXwtKFg3Z9MGC6Of3R/fHMC9lCIDFX3Hc/GPmpBd3D85Eq6S10h+AQKeVQmG
	BfyFC4GGQaADPEHmVeYjOGcC7rin+unxbvnW8Ql0kL3O5SoRrjI9GaHCshXbQe7lSQWQLh
	k2jJa7IyjPhq3F1AIMqVQBHx690dnYs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qc8GXUA6;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084550;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zcsj2aqW17+oe0oJwlMaz98nMMExX2M7/4tW37103Zk=;
	b=AKYX2BS90ByivJ0tl3hre4wACHXFcObwx1dN8ZmMhi6H1kaPMrmaHvyrCupEQ8rQ9zq20N
	5KSuyJ8XeYBiCUfv+IQNPUyk/QuZT3bYnsvFS/hIki68g6/nio757ytKlRdoPSn6DMoOvi
	0nEis2Nnw1oAx/cHvBqrHt1Ihg6qloU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 130EA4480F;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E18E4C4AF0D;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=3Y2CPj6syFXUCXsnWczmhacigtbmfu4GzSGO7yNHv7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qc8GXUA6j7z9+hMgVPqSdL/xxRbXvBB9qGnZw6rakvfAEHoAcCIpggirEKZwh+Tx6
	 OB6idAmhY/biECsNrx5JhHccK0/zPHmVdIXFHtc23Lih1PRNfhHSJ9R90241aL6APY
	 ynnHz4vNWGFBE99oIcpCsZKFKH8Rdubnj6nA+pOiSWRRvpR3LNZH72ddE8NjPa3Olw
	 av5l4Q5rA+Gn5SssccXhakbl2nkLSIZ66pdHw6k4lw0UBymSgxzdV6rOybxdtUOieQ
	 Hhmfnc2ccEdHOFxD9zJAPVrVK+zizF0UvnuCQ6EREQfhdqp8uznzI6TYnpFJUXcQJ+
	 Ma5W3JedYtMDA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4C5C88E41;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:57 -0700
Subject: [PATCH v13 31/44] KVM: selftests: Test conversion precision in
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-31-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=4526;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1VCwavICD2B0YCid8saapaaUD4KFi9lWE5miIWXTaDo=;
 b=SdHNaPyh3NbyisCPqN3shnRhVEEEfUvLeNYdcO1TzqeB8vG0HhAvF3LjbseOLzxLt0X419OX3
 Q9qjgkUDtWHAeLfA8xuTuDf7hsr9wQjb0t/B/VF0ZGVoBbrt86Dyr2i
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 711EB100004
X-Stat-Signature: 5ukfn44gqfj5w4b6muhej1k7xraeusee
X-HE-Tag: 1789084550-513400
X-HE-Meta: U2FsdGVkX1+Ik/6tf6ELHgprwbzJXswjLNVltCuCfHBq5rzce2dUxU0QUanQmFFGHdwMhkf5q626GSr2CviNg9JC1p7sDlf1bKBx92wAByaosIEIUQVA+3SgwRJfhoXZcalwx/Phk+5o32RZ4DAyFrHVSfzKdDHYGRuFOeXRbTQEaSIfR5wx1DuI9NujLkg7iWopU0EyZhzuKIIbk/1u0UaoOYuKh3BaFBpjn7Xn/uHL09162KWWXGPe/C28GgmdNhU9MmMj0KkQahf2dXOl4bHdvCpnI9S/jYsYJ0/xObDMRrY5+2T2RvRPNzDfx3bQ3CU3PWQ9R3fIPx1Zpo0oX7S2tTIwGpccdwxp/rhRqucntn+STsylF0VO1W5z+7oI2dV0Mk4YdPD1kX3xWhxIdN5Btg2gfxV/k47+ipHvuFsRlgPbxgGe1nshO4FBCgImZvGvpBmmSym8UQKdD0OA1IYUv+L4Ep7HuZb47WJ33sw+e4opy/Od16YsWNhMtSjd6aw8JsX/sGu4vX4Iw9mzkY8F30BIfAqL3o7HILct/lAUQanS3bzU5Mc9/sRUI/PAhHeThiXq9n1y9McxddPgsZEpbXG4V1yndd7xF3WDKKkH054WIo16a6rmkBRGVIvyllily8dZyOyVGffJcT0j3Jz5/viFekZ0QPSo9LJi8uxZu9BHhLhy7slGR4Snb5+yZGSNlMn8k+umDoRYLF0x17rSSZGrFs37qJe9eZ+FDhVxhTHK2J/vGVvOxLsGoxU24Xxy+CTAAaHsg0oo988eN1YSrS0+zZ10bJrNqjTSDtNc60YZl+wrx3ZccdFxqjphXl/rqrqdiZk8rivSdVLT1d+GFu2HbFtO/0PBXW+1SSyAhjOkT0pDTeuVhJwPkaRv7onUbkeX2Q2JStX8l5oGwnSqN3TEMmYzr7gPHr+cq26qME8DqV8AVpTsZk2oCLWKIhcAJo72CeHr3z+x+Kx
 VJOLXOQu
 mnqCvJlSHfxsG7GytTZHZwDmCR1TMdDEElNuAsmNRAQmxWTKnJSd+i0ocJ66FKkd1nRAmQMr1DHD+1hR6pi6MJ/0NFeLhXXtMcjmaF7J2IZ5SGWT9Xbl7uEWe4dbwjR6rpqcXgMUx1Lhs9FJpDdqYBmtL1vjwI6WtyTXVpyBBMxcKyEAe+oqM3Fzj9zupfjmftbJRlo23xI/oJzjSBVfubTGXK9nMn+GuBnWIVWaa5RwAh01HYrkAJmMk90ziw/VEEHpM5w2NjWjFtFW1QSLaZdzqMfOlpgSGtaokDKDi0OL2L521CJyJBr5HgDZYCAGAAFHDEW3h8tA0MHMBILvIkk9V4dxG/BHzTgA2HbQs85F6pQSJfOuAlZBjX2iaB5g9RIX/XS7Ljztpv+26spk+c5Injd/cj7KclgmhXtNqpZictYekk25rWiQVe6y7a/RqthbXbPpyFvA0vqIb1d/7z8O7fDK3bFYbWsa6rjfxCKpYVDD7v3c44BKS2/10SdicjAPrKpCGyISx9+Id53+3uqmWMw==
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



