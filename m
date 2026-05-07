Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD64CCD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815EE6B00B3; Thu,  7 May 2026 16:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB566B00B5; Thu,  7 May 2026 16:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578CE6B00B3; Thu,  7 May 2026 16:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3341E6B00B0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F28721C12F0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:05 +0000 (UTC)
X-FDA: 84741747930.11.B46FACF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id F38BF100004
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dino3EkS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185384;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hb6UkAK+dHz9YtD06oaoCEhb0FPn5eGx875eiuAIBw=;
	b=qwvqjVrGWyv7GeuFpROV6YA8v9KaVFxFpcXdNTu0pxLrdg87cnqCD4TT5Xvaw0S+OCLCzZ
	LdNZMaU6dZ9lwfMiRrf4+7fhbOEdGNhIbFnjkwJS6d+bSBRuw8gJMiieiozj2xWhVdn/2Y
	tMskrWu0dMoT00LwA5kkFAsMpRKfgGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185384; a=rsa-sha256;
	cv=none;
	b=scBd55LVkr/89CBdV+Ff2HLSKL4r0l0pGVqXOXXr8Moc1MuezP+BMHfCj6qIvi5CaTnDop
	YZeqiWeglSQTAnjYL+ZNE3Rwstv62ORpthvR1aoZ80Zf2jVSBzuomnPN80UAnZjFKO5eeS
	63GQaQZk5Ay3oMDmqDcc06PM5eBiyIo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dino3EkS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F23444575;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A872C2BCFF;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=4K6aZOY7/EVDTJVXXcnscYkIdcLTK85HCxIyjesWhHQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dino3EkS0xhI4vjGsVZiBOExZJhOKgqBmPtPljtQTl1tfjF+I0WpNmSBfp/Ok3p2i
	 kU2LVnPpgtE5SMr8iQfb/i656H4L30gbCf1Z22liapC4kogTLoJSjBj9jpYphdc/P5
	 xqw37541zeqxsrHE6DGQGfe/2pw3TG8ftGF1GB4nulUcPtm9jwCsey9ftDLX5wr9FX
	 bric174VF8PLtYCBSivCKm/Ip4POLm8AlqWV8TqCJqunUMaVQasg23+BmxFzLNNjZ6
	 m31sUqvHC5s+y2ZEl290SAvuJfXnK9iBOqjpugw7pcRdbH8zNfd5LqETefWDO83ciA
	 zhKJ9PDxWezwA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B449CD3446;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:49 -0700
Subject: [PATCH v6 30/43] KVM: selftests: Test conversion precision in
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-30-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=4413;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HtD6Anoj8D/p2ekwCJIfBrLYhnai4hlVElsBBbVhcEA=;
 b=9c0XzVR16C7mRUm5LO1qcVx3Sk/RJcP+TMxV0G3KTpIgd4xWtlCjhDacSPq2qNafTwRqq6ox0
 yJiaNnk16AeDd2zI1+7mBMOhaIQ3aiczgQmFxZC55xBy5hcsFUeJ+kP
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F38BF100004
X-Stat-Signature: aw48w53g1tcew6a9a8gwj91rm3cguxk9
X-Rspam-User: 
X-HE-Tag: 1778185383-428473
X-HE-Meta: U2FsdGVkX19cpQnq2C3gnLu2xulqbPgIi5uJdoa88d13NDM0LtgvS+sqIzHNRzosGN2d1UelU8zvqjtC67A7lsTPkIbKJ92DW6P3yyrUIwR5IkNYHZt63O5f3xwWTpWGUPJVOjsD2TPTHJ0865sN36r+zXzs3VQQuNEOI6fD7nGttCy2zjZbCMZD/GeR13m0QzEHVAnnYIOYKBkwd+28GhF0KYfM8aYABrp5NDwNuwXwcRvhzrcGMuTcMrSa5fV+rfUnKv+BFKc4YUzUdPWT/lhJy8dCCD5uO68kEmyfhDlhWFY99wAhfEj6FcZg00P2Y5jpq7/icyeg0nCFqcXA6PEthRyLgk1EDSdRQuXHMNb/bsm5COUBzIxtVHERG/m8042B8am/1Qh6K2tjOwfV7Cr4O1vqrggHtZlackTMSEEGIZxc2zdiGNGBgilXHab6y0nrz1RnIRmarW1MGymxL2OT3snveMORkUmICPUJm4MdVc8t+VPjIOUBljvB0OT9ekE+Aob6tG59WUu5I7tIUivGx4gPWQOLexL4C7UGaooihr/N8qifcB4U9maIBcYC5clOnpE7PeTA5q5k0sOUjm1geUESJ0x8rBbpexC+uV1TGNGF/QtCRWLMFduaXBVeEgGNSbMaRCoKMYLFGlDTz5zloITwHndEFD2DIcYRGneVFRydKov66TxHMQLpUgUb+Yqd+aOrJmZ69Qz5CNqSO7OFKeSxw4YBuEqdYGTZTEwXJThNNwhZoIVboLr7KrqCtVhLeGUxgAzJSHfeYNIgxMs6Ugn2X2YjKqJuHbs+vtKglOToLYduUSxpZrEoomGh6nA76bd7gSGvSAXcV4njHGDpqnUUT2M/CstbDqYjom3UHKqFJckf0MUNYZ8KYd51FRYbgYjbhKKGmQJWVh81s3WmMcdFWnx4nYGzdUf738DJCplUfK4OzGJ66JpV7bDm0k/i4gw6NzjCwYpYwIx
 yf7YregC
 DF8/dJ71uiwQfjsMQPndmxeNTIFMIfQ4/IRUj6K5CKK05KV2+TH+OB3jsvHPu7qbZbqRSm4dgi+45sqrDIRtuDKJ6+HCNypTJfB5CXxdGMK/UD2oG0oAPGd29rgrc/q0B2ncSPYV2vJZKKrAlCXQ+MwgI/Ew+prnxNQOtNtyIRbxewW+UvFqJKcaGG4xzgQ45kpbV0LIwpNOXIH9r7GX80ZHdqT3vaYzMOrs4FgRx83e4z+A2M1sS1w3dtKnWbG7sBAfrn4TF+nSJgoxGSt3OPkbrrA+vCNfqM2PbPAWZEhwBxNotAGuqESTDKhMJlBRmrXdyMssbPXSIc04fTxcHuSMKt84HBNpTyjP8Nki62fTkeGULOyD6Oq9MbM0gFVFNMvME8eESbYRtD1wodaSKZh8ijeBbTo4OGIzj5zVrw/n0gxFjspjuL/UyBYRrf/slz6HIXGLyHsKRLkQ7nqvGNbInxw==
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
index c524457148706..0cf1351e0e29d 100644
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
2.54.0.563.g4f69b47b94-goog



