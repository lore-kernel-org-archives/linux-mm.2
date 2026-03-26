Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F5210AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B95E6B00D2; Thu, 26 Mar 2026 18:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64ADB6B00D3; Thu, 26 Mar 2026 18:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EBBD6B00D4; Thu, 26 Mar 2026 18:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 375E86B00D2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F356FC461E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:32 +0000 (UTC)
X-FDA: 84589646946.07.976D8C1
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1CF81A0017
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r2T1EZdU;
	spf=pass (imf15.hostedemail.com: domain of 3WbLFaQsKCCoGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3WbLFaQsKCCoGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FDVrh5pBAWxA/8NukVOzbt4j2jYZyIOrjhQG/FDGfA=;
	b=v/suprifCLSj+bcP2W6svk5ghkn/mH07jWZ5UjA1rMhGOAKAVRlM2IszBkNjhUBUJnElgq
	Ko2gMYmPqBUrbMlA7/oSlXxUwz1DMi8wCO043WkAeQAsVnUZyAS+N1/Ip49BG5+KXa3ta3
	BoCNHIcwVFf/H0Ym4kpndN7Jm9MhywQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563931; a=rsa-sha256;
	cv=none;
	b=0Hvr/NwfBua/4u69Yn3eKr59FUl6lYApfo/NbP9l1M0MnqSc3ep66nXALa7ZmbabIACWdN
	RqLLOk5V9+7UMO/uCsezllD+VsyL18fNtvsxxZPJJZsx/9NeBiwN59RrdS67Zubs8dRZUV
	KakbMF2ixKsCGEKHzD5TQrwvmF2g8l4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r2T1EZdU;
	spf=pass (imf15.hostedemail.com: domain of 3WbLFaQsKCCoGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3WbLFaQsKCCoGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c1e1a6cfbso1208396b3a.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563930; x=1775168730; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4FDVrh5pBAWxA/8NukVOzbt4j2jYZyIOrjhQG/FDGfA=;
        b=r2T1EZdUTorQw8vg2kE4ZGMhiK4T6tFU8FLB5O+6YSnaO2hnybWMoMa0SmsbD+S+MP
         NZyRFs+jZsB150kBDl/ppimKOFoFwtDWCE+QAuA86juJvHfOBQceCrw4EF5xomqXW93T
         lP/JyIpfDyplvBHxRUgnVP25uoc5E5tlnMEIcan/HuJnrnv0A3ST8A8UTOU2rs+WWqNQ
         /++2VeGuZhsc31/sTKTFf0+tb/ojvd0VyykIZ2Jr6qDsheEZursSV04ZMP8Omt833dhs
         Wp6dV9GUWBcpM4JbW+Bh03zPKrg9h3EYHI45RwCNAtcAxjkEE5/TRuNtlKbOXFyji3zS
         Ypiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563930; x=1775168730;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FDVrh5pBAWxA/8NukVOzbt4j2jYZyIOrjhQG/FDGfA=;
        b=rShcsWCIy4DgR1INozb0k99VQktMMNH1HMfbX1thzpmqKJpCKiN1u+s6/qiH3eA+Oa
         6/Ir8ygwMecug5/0h/dvULU5GcsiiIraqYc+Zsjo7kwHGbF+0yK2Ux8Ql6jpZNrLY8gh
         AcOriNPodKOjKvd40Oma1VSnAm+tuAx30PxYEHAbr3FPkjjoOTP8k8Aoxy7Y3bXG7ZNu
         ThHP9v3yLoeE4d5Wzj4KuSrqekhDUSmAj25jPHFVLV9zjW3ZLJPwsPQTi22f4ABvUEaU
         POZBgBiLIkyz+ZBaLNIhCRg6IkUDje2y4EbJ3G7kYq+HVKVkiSoHstNxZ+CZe2HjmIfe
         vwsA==
X-Forwarded-Encrypted: i=1; AJvYcCUdL3VqiG7VS5P1SduIMTeoOlLyLydVFSxe+8Epkm4ZPvlODJfX3N1W9n9ujU/Go6xjcuiW/FFWDw==@kvack.org
X-Gm-Message-State: AOJu0Ywsp0tzrC/38TWwFUKn+i7+olv56Iu3ssTbon7vsPFNXd0f1KBU
	4p2fiVVJ6ZDSFpu+ZXCZf1kLLxtowgS0HAKdF4KRYZnZY1YXutsmOXDOgq+jo9RDNg8ht+vyJFB
	/tpLJRprlCb4sYg+wkc8U4zwFPA==
X-Received: from pfbmy24-n1.prod.google.com ([2002:a05:6a00:6d58:10b0:82c:85db:66f1])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a118:b0:824:188b:c173 with SMTP id d2e1a72fcca58-82c95d35fa3mr154180b3a.5.1774563929625;
 Thu, 26 Mar 2026 15:25:29 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:41 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=3818;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=49y6ENDTk+sGjQthlPC0PI5YjXBfXeC7oiHabUVd5+c=; b=65aFdTZaaBhbx01UOD21wSDI5gmFYvI5UY4Oon4kj35EozZ/PT0v5jtWiriWeTssIZ8LZ5iDi
 nW+/95/cI0ZBsoUfv6UZ6e3zDpiwjAXZks4pArcDWAYh9DVJGtT36bz
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-32-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 32/44] KVM: selftests: Test conversion with elevated
 page refcount
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
X-Rspamd-Server: rspam12
X-Stat-Signature: k5ygt7cuamjaa7eibokwku537zh98gxq
X-Rspamd-Queue-Id: 1CF81A0017
X-Rspam-User: 
X-HE-Tag: 1774563930-677768
X-HE-Meta: U2FsdGVkX1/p+YwROnpoawSYcY8aVe4Om7El0iKu8QlCWtmL/6byzNEzmfSLkpe8V+E+ljds4xUBe2HdElXw3HIqcXhDkXdyg9eWtzXXT4onSRCJR/5fugg4NurNVpXQjXqIJOlG39yVDWbpq/Fn0KmBeBjlThC+sb87nzCn+nIsCMmxSQXerteCCpdCdbmKqTrZKlMIKwnHR7IPwcCtOy1wtTc//yz2zS+tR1VoLfaHFkxlJYTuudGPFNwpbIXFR+NUzRZlpKtOcpPU1EZq8u8y12pqyKp9xEbHoVIYp1nOjG7nq/RW7rcK+pSKvn4ih2xxOoD2DlW6WCJzuW/ujmks0qX4p4+RYUyuaFMZriv1Gf6De60g3YYZcx85V9knlCphYNZ9vRRjMHEGQW/LeXJlPZe/UFvi8C9/doqxRCypFcwutJhBV1BkfMZR9DtUQjpuWEf08rz7XtOW6KFU0skJMzLkm4ll6kSUX0lOGmmRE+j6ca28KasVwds1qdcuGclmDTb2Oy3BbEnKokzMpaZvaxZyZAtI57LIODJ5YxDRge26wgfYvQc8EC/R5l1wy3xf+hzELQd/W4mpiQ/8dE8oWjTIJPHwjjCg+4VMh5STVZrOjv+6mchgR9tpoXSUCxBLurGVz1da3ipJ/dxfWK/dw/Hpm1gKzlAhNGBctZ+hv9QmDIIoe8NC6XkzSLW8NFDZ3bfJyz40Vxwe+RKT5cQTZVFSykq2wjIwCPi1TeNPBlHf9aKlqAZC4lOBJ++Oa+Ez2fLDOinfc47VPG6LnpRwVe/q9s7u/CkaEEpRpZk7nGXVRIAHoVtSFrcwTsddPEuiC01mOcWHsPtAWdHeBpcHFpb2j4sQnhPSktbWkidnA/1XygOQoLa+pay9I5Xjp9Q/Y+95VYe1v2l42E/s5ArGSdLgtkytGhRCkG+KEzSARy1tNCuCXsS01gl9HGVBz9f5/cs0YTLYDiuEifj
 8Li9wO/d
 32sr4qWO1WSvLh3jwEKXoy4UxqUhkNnFjtoU9cemTlHIbaC2pV7mcdcjddLNSrp/qB8YxFbkhOWZk+yqhRGR6QcpBwc71fxFlqmP4TcTZgTT05V3SJWOfvo14JXyADssmG3UYDNzz8l0JpApVsX8f/bnV1x3sYxa6h5PnfAyf8YB7HsW3DZ4vit4C8ZTs/q+fE25dwRVzoObCLldD/jdmrzZzMd7JOrQ+cZy7wo1KvpMrfhs8l4CENzCYr36HDB3r1IlUKHY5bK1VPJ5d+IiJDYCc8m0Tc9ugNWJLCPXtR3g4hy2ciQ2SDad4wSzNd1me7q6jr98zuIEdFan3cAXiT0aqOd+PuG+7XVqwnArJCglvWbLEiDqZGw/QnWnOEeuq7o9OicUKa/7DXGJcGWNOFY2oUCA8GcRXGrRxa/fK1caHO9KTpPChkESK9hVWhnOxsN6mqH3Jw8SWGh60Bsgzj3dIpxSs7z1L8XqGARK+zFuThCPaZ7pMbLWkfba1eDROlIIhK+LyY7bYOzh2Rf9FIwIQn1va2KiluBfXfHDhRobEnd2vN/zNJXpaThnWVwhQBVcSVonbY+0de2gX7TqZue6xVXTB5BzjQRcF+kviqC877JEJAJGoU3QzEnW1xOr2NWTUnOJWn7gCSub8EkhMwvwuQezjNBzO9tsz33s6SULrPQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest to verify that converting a shared guest_memfd page to a
private page fails if the page has an elevated reference count.

When KVM converts a shared page to a private one, it expects the page to
have a reference count equal to the reference counts taken by the
filemap. If another kernel subsystem holds a reference to the page, for
example via pin_user_pages(), the conversion must be aborted.

This test uses vmsplice to increment the refcount of a specific page. The
reference is kept on the page by not reading data out from vmsplice's
destination pipe. It then attempts to convert a range of pages, including
the page with elevated refcount, from shared to private.

The test asserts that both bulk and single-page conversion attempts
correctly fail with EAGAIN for the pinned page. After the page is unpinned,
the test verifies that subsequent conversions succeed.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c   | 80 ++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index ed310f26d88a1..4ccd3d515bb26 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -408,6 +408,86 @@ GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
 	kvm_munmap(test_state, sizeof(*test_state));
 }
 
+static int pin_pipe[2] = { -1, -1 };
+
+static void pin_pages(void *vaddr, uint64_t size)
+{
+	struct iovec iov = {
+		.iov_base = vaddr,
+		.iov_len = size,
+	};
+
+	if (pin_pipe[1] < 0)
+		TEST_ASSERT_EQ(pipe(pin_pipe), 0);
+
+	TEST_ASSERT_EQ(vmsplice(pin_pipe[1], &iov, 1, 0), size);
+}
+
+static void unpin_pages(void)
+{
+	close(pin_pipe[1]);
+	pin_pipe[1] = -1;
+	close(pin_pipe[0]);
+	pin_pipe[0] = -1;
+}
+
+static void test_convert_to_private_fails(test_data_t *t, loff_t pgoff,
+					  size_t nr_pages,
+					  loff_t expected_error_offset)
+{
+	loff_t offset = pgoff * page_size;
+	loff_t error_offset = -1ul;
+	int ret;
+
+	do {
+		ret = __gmem_set_private(t->gmem_fd, offset,
+					 nr_pages * page_size, &error_offset,
+					 KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
+	} while (ret == -1 && errno == EINTR);
+	TEST_ASSERT(ret == -1 && errno == EAGAIN,
+		    "Wanted EAGAIN on page %lu, got %d (ret = %d)", pgoff,
+		    errno, ret);
+	TEST_ASSERT_EQ(error_offset, expected_error_offset);
+}
+
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(elevated_refcount, 4)
+{
+	int i;
+
+	pin_pages(t->mem + test_page * page_size, page_size);
+
+	for (i = 0; i < nr_pages; i++)
+		test_shared(t, i, 0, 'A', 'B');
+
+	/*
+	 * Converting in bulk should fail as long any page in the range has
+	 * unexpected refcounts.
+	 */
+	test_convert_to_private_fails(t, 0, nr_pages, test_page * page_size);
+
+	for (i = 0; i < nr_pages; i++) {
+		/*
+		 * Converting page-wise should also fail as long any page in the
+		 * range has unexpected refcounts.
+		 */
+		if (i == test_page)
+			test_convert_to_private_fails(t, i, 1, test_page * page_size);
+		else
+			test_convert_to_private(t, i, 'B', 'C');
+	}
+
+	unpin_pages();
+
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size,
+			 KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
+
+	for (i = 0; i < nr_pages; i++) {
+		char expected = i == test_page ? 'B' : 'C';
+
+		test_private(t, i, expected, 'D');
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.53.0.1018.g2bb0e51243-goog


