Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C12EE10AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCD26B00C7; Thu, 26 Mar 2026 18:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847B16B00C9; Thu, 26 Mar 2026 18:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CD16B00CA; Thu, 26 Mar 2026 18:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63DDE6B00C7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FAB3160E38
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:23 +0000 (UTC)
X-FDA: 84589646526.13.CA44798
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5605740008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dlHzt00I;
	spf=pass (imf12.hostedemail.com: domain of 3T7LFaQsKCCA68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3T7LFaQsKCCA68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIzVYLR/FSUWm85vLUs87YDAHw4Wlol7nmVi6FxJ/b0=;
	b=mn/1njP2P5TZQrCK+aVn0fCCgv3LkdX3s/OWKyBHHLkmZKBJhl9JhZIqlmxATWSxGU6X+h
	gnZlg5n7Ub3lrVYu0ZFODCx8HQRCIhy6TD38sW+t+ZGcmbULSfNjiPqLHnTbvnhfztTXky
	CMbS5rQK5J75pKFZOznmgsuX1OvTjKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563921; a=rsa-sha256;
	cv=none;
	b=BdbXBFfqlYtrCie7UxrzOudL3XtruVfh6xGtCmaTrIjmelbEJ9WH1x857mANCY9Cnvm15p
	AqhNGGNtMsbK+gkO0JaZYFVo04g4xGLKcdFNN4pl/H35/AGc70SzXJ4TlpG4pEwvqcUlRY
	byZWt10F/aZCzaXsztkLe+/9VDeCxUI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dlHzt00I;
	spf=pass (imf12.hostedemail.com: domain of 3T7LFaQsKCCA68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3T7LFaQsKCCA68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c38b85c25so2734942b3a.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563920; x=1775168720; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sIzVYLR/FSUWm85vLUs87YDAHw4Wlol7nmVi6FxJ/b0=;
        b=dlHzt00IhdOZXtSOFP3jdm6TbYbkShEGEDnbHKczbo23/owEd5fH3XexF8wD49SAEB
         PYEhGR24vac70Q6pJvh4bdAyorOd2J882xuGwVhSfAIqEOLPZnJ1A6gPpfDP8lVf9Y9H
         tLrIOE8P/fVl1eHGpflXJIhlhB7md9ZL+CwpFekevmO74Y7rHWW/3DV+SeDZhZuwIj1A
         Z3bXOUGmekf9kbeHsViJ41j/EcVHc/OFA1BAA3pTtv7OP4qDj2M1AuvaM4xKrZ/XzfDc
         fABLA1lqAPUSA3PB/cCLM6DWQTz8OcrxI9b7exfs5cY4lnDg16wZ/m14Reps+lld6f9G
         nMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563920; x=1775168720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sIzVYLR/FSUWm85vLUs87YDAHw4Wlol7nmVi6FxJ/b0=;
        b=KKp+RISxUA5mZiPtgL5hVS8rw66RWzsiUSJ01P/lx8sI78HEPRCB5tnJYdLa12XPYw
         h57+AJu4Zb3xC3XuygIECFfs1us5bBqNXRTVmZ5Jkttr/Y04Hh5SUc7TcJUjhPffIWlu
         wPMWwn1nqgyxfkLs/DLVbmHtjzUX36z0ZPFvAkxWdujFAtYhItKAdP9ts+WHvkvVdgVY
         iocKRz8325CvOIDpkVxNgOGzhDDi/mk0rrP+vpBQBtdAaSphrIEhgeOtnDGJKX+ujkP5
         BAKYLmVdjVtUfMIP415kLr0YCwuKwVuQmK5O3akiO1Dh6ayxHVniGqPawCgIErvNGvoV
         aKzg==
X-Forwarded-Encrypted: i=1; AJvYcCV/gUOv8W+qXWhtwXTESnE4DxlLNhOh1xai6L+sUWQXmJ0Hbsrr6uRNcN3msP8IxYhQGtiJFKjesg==@kvack.org
X-Gm-Message-State: AOJu0YylIyfpJ/YCl2FpHCDuLWT6FLHGknABISfxYoZCbXNMnLR6Pxh/
	ktAwswXey3brfvlJxf2GACn75bjMujGjUV1BYfTpcIk0pMfxz+lvSGPGojYaSU+IX/chM3WO765
	WZdcOjXq8cFOFCu5MvQmT8dy/4g==
X-Received: from pfjt19.prod.google.com ([2002:a05:6a00:21d3:b0:82c:6ae6:e5b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:9a6:b0:82c:6d88:2a8e with SMTP id d2e1a72fcca58-82c95c1133emr168762b3a.20.1774563919656;
 Thu, 26 Mar 2026 15:25:19 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:36 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=4465;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wRfY1Jn+9IVOYoMa8jY758mvqEtTI8tV2HC+aaXp76s=; b=Iwk4pQNeckXclXoEM1Aas23TToytRGIPodJHXlnaUzRgEA3ZxoElFgD1mmgzcEoO9mzC7z3Sa
 MbCRq7O0sgoB82kC/gB6bsmiYm1TnEJqhIm2wTtU37WXhw2ymIQgiGS
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-27-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 27/44] KVM: selftests: Test conversion precision in guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 5605740008
X-Stat-Signature: am3a681i99xqzen66xibu8p4rw7a3yex
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774563921-662830
X-HE-Meta: U2FsdGVkX1/vtotMd+Wq5p3Z/uu4iRBgXekFM9J/b2FuOV1oeuVuzDZNq5MLk4oyGD5RsKIS0vldjO6vEYKwowKXm3HQ8cJz/a2hsi1tJd/UZLkP8SiSGnPNl3uizmbPyGyb1Cbm+KFkO3QWjDvPXww0SeTGY63zCQ5Wcff/AjpssOGONAQhHjkChX5XLVpx4ykKG3oGeipey0UGSCKedtpKW5eN11sHOoMXrKs51jSLplYBEj6Cyj8NBo6xlbprEeTFWoBMZq89X7f/ra5yv/VQ3mWYEnPXz73+a/KxcJcnv/gzCL75iv8jvZ3cdrB4G0o/7cUiqbOUXpLm/ws3zVjXHYpIaYTX1tWa6r9D48cLjbCM1COIsOelplES6/vWN56HEe3iKbKQiBO48fSPZ8lpyMxJDE/QJAAwrPWE0l25klPfSNATdL9yFMxVjS/vQ8WH1j+AB4xgi1wqLj+HApnLzZIGKKHwoC+Pj8DVVROdtFCHbAS+p7KKgMZaWf/+NHOHeZeP5k4L44dQ5Q2iY6kmpxH/L54uSVmrM/nfUGyPZxEmCIUPduyynktUI52crdgPFWise0RQR0q+hIxTJqWPVEP8ZdWMD7+o689rQ4H6AC4NGU4coG/3YqQ2c3JVkHRDPe7/+ptwFf/HxYkuB99cpADpjPCdpVvZ5wxVOJWoV204J6edV1HEKI3NnV03KiSf1sWZaQc/2ANB0gKi5U6G5g6UwPvqcXcWx0181R7t3Xtz7GvfZWVKsiDI6hwQ/h39mdsSl3kKR9uodwGmnyZEKvFJdbPE+8ZPV4G/gg2nVjdVqbPeASJrL1N/X/jdi0MCKPROXh9TEy0WZq8pBL/XQOeMKFzgIB6GXwel+fSteMyLWmCMmqY7bKCaf6wqT1JY5MTbqZgA1OyrYB7shOJpmUsTTdEcM3spNx4etlUcX9euU12flVS2PlwFGnOV+hg+QcBTn6lWNmfSFWG
 EvnSdaZp
 bOPLJaVVH96qx0wzEVpdpDxzs36FeFevbG63bJhpmKXUD+ln7lrx3xbLwShsWfsE0tUjl+uN0baO0kCw3FIaa5h3eyUNJFi+qRiLfyMbvIrhd9RfLU0wXQVLtLV40wIq3hvnyEp0yOcpYgLkAiWLiJ+N6oWdZ9iAfjP6qpPXLzZp9SH2lWeFBdhAo7pNWDa3wzAfXey+F1ZA7iBGuzBPK0BdV9GKjUM/saXedF3SAObKNNwqnXTcswQzJ9Pa4ns1jO7R9twj9kHSKRALMlr5NZ5mKHiKUAfukL/GOSzMCGxJDcgEPFPDpfH/gnzgIy2p338CtVSGsWLJhP1uYy47ddnsJp/yDROX0ocDzggIs7Kf/U7e6QuDJuBkwfXH2/g/15GhsAEYrAdVlHitVDd4MNIr5uRU3pptScmGf8GWoRTwYBc0mhYOxXGdrghRnQYVslUlRTVjCwm6eh5uauf3BD1GemDVQyRnwgciQf/G7AmsSxbhal0M4NDiz9ZrYfYjZywvlNW1g9UuGNx2NFdtutPHL/AjDDQvVqiqsffiTwxumxtkszHNNKbWSx/+yO+F9lk34gmKA6oddFEuIeB3Xozv0HuvET8czV73OOSIAnHDOhNfZQxaZs7tlQ1Z+hKCeWemU2By2jEubz2702wMLTo/WFbXSIe3mwOBv2vXAxs3NthF/L5GsCThEd+IvBzFWxgM5CA9P5qW0s/ke9UH8g/33kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 .../selftests/kvm/guest_memfd_conversions_test.c   | 70 ++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 81cbdb5def565..3388f06bc51db 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
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
+	const uint64_t flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED; \
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
2.53.0.1018.g2bb0e51243-goog


