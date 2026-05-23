Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FC7CD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284A26B00B9; Fri, 22 May 2026 20:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258CA6B00BA; Fri, 22 May 2026 20:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F856B00BB; Fri, 22 May 2026 20:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEAD16B00B9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C08CD1C0097
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:17 +0000 (UTC)
X-FDA: 84796772634.29.018DDCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CCF4510000A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xu291Wxe;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495495;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRj4NW2cMIhvd92SraRE4PtVEv6ogrdqGHDFsfmR8hI=;
	b=KT+ZwWcX/Ee26tNHVoXzGZujPfR44weUOK3PTfxLbxNjOmfYc/T4YcwRoUE9WaWmGRbxEx
	BysUnCG92aYWCU1R78bR0i8l1TfojFzVyTvXNPyShVU78HotJm9FINict2BZHtRc5uoLvg
	ukJ1xN5j+bjqipsj8wtR+IGFCymhrVI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xu291Wxe;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495495; a=rsa-sha256;
	cv=none;
	b=dbyCszbcnv6arpiBFuLWOwUkdjnI6qYVIy+y52n2y8ArlHdFbH8AEA5U+QLa1XE3ViWZEJ
	MvsmtuFZLtPZ0uuw+O2XMJ2LSqoG5VD4zDrDB1xWXNP5Kpd/PCJ9vBI5isR+dlZox2vOG8
	lAneq7ArFIAaH9HQGv2srGRuK7DEN2k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A07244D46;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CACCEC4AF18;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=kF5KSrRoQQfFU6dByzz5/A0lxfcJ11ithHdr+vvIX5c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Xu291WxeBAobaoW15uyyHeXooaRPYGCerStN4ofEH5DMsdkM0uEMk6lD6nyWNpH5N
	 8zcdJNawQ2bQnFIh3dMAB3GuY0unZqVi/PQgyxN/uZKdj1zm4CY4u/DVoiJBr9QGIo
	 uHjdwqjYS++7LyD4yJ2aLF9xJSW3r4l9v89Qwilr0bD40DrFSSw7PVxS0AcPOnP3aq
	 Nl3wv6E3i10D2O+lx56f+WKGLIG56wER5ZbTLZHxo9SLkXMNtt59NLmfWXcJcVLyYP
	 OhPgxIbgpOg8JiRSXW0YX4dYh3g+GJfUz6F0rAhlGcfjNdn1+dBegb3T7qFCfE4ZIs
	 Q0BpmStp9lw1A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B416CCD5BBF;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:11 -0700
Subject: [PATCH v7 29/42] KVM: selftests: Test conversion precision in
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-29-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=4413;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ChN/3DeA5NkiucoJKIo/TrWbitDosN1l7xTrXSByaMI=;
 b=5cMvD/ULAU3A31X88XQMextcRocvh/APa0qU6XUCRMk0iWc/VB5a1rtBIafEIePSlhLoH6NCa
 4PiW40espZYCcZ/j+JKwbRawA8BDZIYMjDzXOQtJfReIdms1+s6F3QM
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CCF4510000A
X-Stat-Signature: b6t44f4tkeoyg41xwz9zxch6jmep1qdc
X-HE-Tag: 1779495495-750229
X-HE-Meta: U2FsdGVkX1/fOHvXULpJDrOyJTjfmaBnhl4YZSxXKzlZe94YizCjgdnKqy7qpkKzrP3v14X7Dx+STvGi7+1IrSiNIgVE8C/QNKfGYmGq3h+u2f8HRqYHTuMxa394cJpq7ivdkPmuhk+2f6VMuzQen5OE+qMoRW7wbvUms1aOtLnsjpWuI3EJdSf6U7rGt5qDm5wuertN9HLg+/6qyC48+ZxF29F3TCXofCF3JjCD/hC09n7ZdNkalCOnYdR2nVItRROBsgkdxhOQX2SPLCO2qO0GWt7g2yna57DPA0txOl03uWN7BtEQhUV7xGmWICufNOq4yJtcH7HQYBYfhOjQZV6nPnLnEmclUkT7xi0FHAMwmVaSwiRBdJE80OYWra1iXBJmLSnzjcbm22STiRJuNks7wb4ydW4IQ+eCErD8oP3VNiV87/I+QyKMN2Z2Xl5J8n63sEZxjOquDTDKatuOALM32wUXqLYYgnZu7+P7XuHGsSEyDXweSolynY9Y7Q7ul1JqJcMxDbvw1F3NwTKKzdqHYHCztww3AcYQPg8Lb0aA1QytoZDxNW5wKQsgB9UYiGvcO3nyM2LL47T2f4A573g4JeFswAzenTguzIxOKpFZvp5VCxef9+zmZ8qbFLVeOKGhogKwIXU2H1HJHEf+y9tX3B6o+nTkzTqyEt8g3FI9pdzQDj3J2Fc92aIgVXRi9g+T7E0QPwOxPsE5ITZOj4rGxsw0YS7RrXL6Enj0+K8U/t7W1/Q7wzwTlOnNTua4Wo7ic+WQolZOAL7tJoPpXqUQpFbpCDGhWxQHRYJ2No0J1JN5wHxt2Td0ObYV+O2731A2Irs0hWFKWPdMMPik+a9oiND8tUoAOTrceHbZOpXmtP0vhL3QibrcW9MpoOMxkt6Tjaqs7SSIv0c9hPepNzKoUN2s+Jx9ssEmPZUyViffFGTRFBfs5XluMGtqUlRxyKql8aCDDQ1+a1vJf87
 Sll9btlW
 oTXBfA0TnZxWJS8oc1iUHIvEUgeqdagqYtraP82HHK4bySl6VBD/3sXeue3vnG3CICFXwF6gds8/jIAldhH2vEY+KZsgl97UugzwUqZdVUSx4ybBBxsjXayLVJDHg+ENCGzmfbJvBNUIIoDpbjmHebWp7vXTv6+HptJygArlyizQDGwFx8qWB/yiudmuI6yehpr+1DrkPXPXWk6Es9nSCpdC77kC+E+n+f2tx5r0+xjqgx542W6qalyQtsSOIqj4guz33thQXS1S8xB+Gf1kVDdXw//xxC5pZoqWGHPFepfBIXzTjaoWIwKeQlHeKIQ+HaqaMU38T+Zl5lNvRK9fcvTDhFxmrLIYTqdg5DbovRvCngyVxYasCeNcPc/z2NJVMwxIBihS+vfe1aDEzTposkpJU3eZruiMXfdrB8c2Scw2jS4VqkKmNF13HsorNfOgAki3XuWN0AYWl6D9sS/MCBlm/nQ==
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
2.54.0.794.g4f17f83d09-goog



