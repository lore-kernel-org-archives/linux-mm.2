Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC1DC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002816B00C6; Wed, 26 Aug 2026 05:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE876B00C7; Wed, 26 Aug 2026 05:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6ECC6B00C8; Wed, 26 Aug 2026 05:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A64B36B00C6
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E3A8A33BF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:16 +0000 (UTC)
X-FDA: 85142871912.16.CE683F8
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id 653AD1C0006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f8CME4Zm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3kK-OagsKCIUjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3kK-OagsKCIUjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jk/fFiPly+8t/f3A0x8GyZ4oVakKVeks0566IWo6DSM=;
	b=nTWU+SgU/pPSW/rNWbYXX3TJp9fWdaZBdJrYknM9KpBU7GdVQhIkONNhQZBEhTSuS4O87N
	m83ZY8Sqy+t6Rk8joLUs0W7IG2atgOEVQiZ8eg2Cr06uHgBcLRyyzk4snk4TaudGavjqLd
	5avy+q14mQW957pMtT2wNX45oqClXkI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f8CME4Zm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3kK-OagsKCIUjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3kK-OagsKCIUjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735954;
	b=urD/p+r/kyHukznWJRr0dtfy3rITA5G8Hkgxu4CIHEfgP9H9w54Y8qpe3LxR/8GyGPZTVJ
	8eAUi3iZ2KYPCtFKQ1adojbIHET3BLPfy1n15PHehk2V3RbjMRE0yi9hq/nkOfComDl2WL
	c9/So97xdUfm5wk9cOj6Z8cz4LDWCzY=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-853d0d87123so393359b3a.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735953; x=1788340753; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jk/fFiPly+8t/f3A0x8GyZ4oVakKVeks0566IWo6DSM=;
        b=f8CME4ZmW0Qd+DnnW7/pV8SsbW4Jhoh+rXLQbcBNNb2eIR3Pr7Rp1YeVBkWKkaBMho
         E9R1FQ7vBhUWQglfUSG1g3NVGm/WsQmW1wyhH6/A5gdqwC9G3bC5HtYQYwhtWvSKBlz2
         7r8bb1682/16CoU1SpTG3Wcz6b3U0o/0REQ48os0+oLDYD6B2qQCSRqz9CU6DlBgS9Br
         Yl5HdtvXDzl7mr7GKbUdi5cD3HMsBXO2QnZn6XrErnvSlJVBNp39wiaqvGjSI8eqngw+
         a7x+9hISoMgMkr1FjCwg+LfjwPxzanMGkEBHLkrlNdcghKXX8LqB76vecg9zNQli0Bum
         sE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735953; x=1788340753;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jk/fFiPly+8t/f3A0x8GyZ4oVakKVeks0566IWo6DSM=;
        b=m8/49mcQvM3MDsE/yh8BrBrNCxN2uR2jkTcPAG4ddETUAlZkhfS7lyshBuf5NnH5W1
         iVS3caw8yNcTgw6Z6Jdf4EheivHqR4j9qzSd8ke2f/yceWeIpv8mMjsGeGPlOwIR9qZI
         Cc4VthV0YBdw7ADIMUwjbCFQS/fmrVkaQ/Ew7X2RAakKIBMXm2Sa5jUmNeatoySO6crd
         nwYBebCG5TgHYczeHmjorA/98xwv8McaCWpHpdaNmiU1q28DvzY+hNXQj2eeZ8ysPMgW
         Num5kCZIMIUor3HOuhHFcrIFcsPWW5Hje+EvC9NCUO3ryx2Xl+4hQsbCNK41JENpbl/u
         FHhQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq/C0WWBJUTb1g5NF6d3KGLjtjTE5N9hZE/UQato/yBmZQkTyTEMZyVlXUhraxbQnOgNYM6eaTc7Q==@kvack.org
X-Gm-Message-State: AFuF++lwRwaOpPzGVwGzhyvJq/SicwMOSkL7Na9b4rGxmyrG+U11Ndl2
	3X6QABVYqlWURtcYvZxObSkWyL6IWGzE3GGvfjfAiQqhekyCDpKEoFJ+qYWIu0PktcA8PQEI3Te
	TcZstRwAR9plIp1C4yQXdfN68Sg==
X-Received: from pgcn16.prod.google.com ([2002:a63:7210:0:b0:cc1:c6f9:542e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4289:b0:84e:2382:f4f0 with SMTP id d2e1a72fcca58-85372ea2586mr10262808b3a.4.1787735952477;
 Wed, 26 Aug 2026 02:19:12 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:36 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=3125;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=D4kSZoQjn2evbYJeBPXvMiB6VpABDixLKIO9Wkc0q2Y=; b=0Xl+Ft2JNeFgHc72cKdPUmlWIaaUKrTcWNaCuE5l4p0QjHUf+PDqPvln09IV5z3p6JgNwwSEQ
 MgPrgGhkueuDsaZhj/coMGB3BJHJjWnz0bwzPjys8Q0r27VmXRxCpWH
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-38-0a15d8a799aa@google.com>
Subject: [PATCH v11 38/46] KVM: selftests: Test conversion with elevated page refcount
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 653AD1C0006
X-Stat-Signature: rky8gp51syjpbz95o9u6cirrzqqdm3p4
X-Rspam-User: 
X-HE-Tag: 1787735954-945038
X-HE-Meta: U2FsdGVkX18c81FeFhzEuqfluGJtP0t8bbeEjdmIbykWuR5Jt3vzMGNA+PdVeX7AF7GGAibKuxH5V7PBMWJ4sus3wz3KIyrWZv9Tu+A4olxwjNSwmrmTSKtyue0961HHaQu7KRe8jLQElTVFDZqxyPNqWTdruxvRkHixXsOsgQ9rFdjqj8Gj2L9kaiamPAXuBliuZGO6SbT7Izrf2L5Tk12yRjaHaxjec59GH5T/WE9BPGqUQBKEHhcCK23HBLvurwrCOaLy82SjbWRtRK8AlgOfx3ySukRylbyOeCFka2C0ip+V/CtSif02YrwDAzu6UelijJnCmlDxBnaxfsUiOjPEocGzr38mGlWAU751+htCEPZWTCEHEsWrj7GmMg7xjSIDfFtbzdfTrBZNnMCIweKTrsx4pWA7GKG/zgqix8MKeWAPnwKOk4R1KoI+wsVzTxLxuAZFc+FQnjbQYV5lPHOCHSPCNkjM0Trh8DczBIX0xm0dBM7nKWamtWiKyQfhFsNsJdHX0lfkN8MqKcGPMkdX8teQEgIhXSV6AMjQ33sUVKxqYj+VJrMDQ1rccyXr4mX7LuxVk+YHmd7c9sH4yvvdyj9VwmZVG/Tp+THwDYYun1Lr1vykJVbBCuT1R7uzs/gHuInS/kLBHaY9cjXaZQqkkk0Mz8fjIbyr3hmy3Ya2Msd5QoRMzlJ/nb+CtIBVQelWuUrCpfIkU+5uoGLKY8ZlFQ/BR21h69Vgbvmh8OjnozHAqF/PrU/RUJvIyNeovIbWBJ9WN6W7w4MjV3fohTPneGspIfH/8VLhrA++GbkAvjPh2EoqIPE2FWPzRshuTjEL92kXcTe66i/HF/z9nOOPi/tcOBumbTztRS63cz+Zq9oW1hnYuJDC4VL8dHnx7YFA8TVhv4TmtT2pSVZWayUn6mZXwmzBhnCqlrLYmEHgI8a6M6MwZYwdtLPvvIQ3CCao6m0BR2OiIyN8kHG
 vQh852xa
 zf2f15yLP/6Tq8YNFnvsY8ShPQBJMiYUGGsysuIzeVa1rwmBZodDaelm/UmN1OemBWFIkF2yGrTHpyUX3p+qmL20dXyVauByiLP0XwVRrjbpGjzJvND25nFU+lKdcfkvapdXuowgxfXUIbsS/a/gTA5WOjTHFzFnqka8a8PobkIVg9825LEhDIpj7+xQETCYgEf6Yq33ZiVzuz+YJXuid0nZauO6LbQwu5G0n6T9mbTjYvaMDGFpJQrAgMOPbvVIIrrXqmqzGbAGfqyQfpGAT7QlQovMnbIs02WmnjMKkZjk9FHGZZAWeBURqxPz4iTBQp5tikT9sss3BnRyY5XdyLCHx5yGFAp78xv76O0HxMYoWJ4VMwHzbi2hPTOR4rvadgLNnvYd4k9he9GD8VjE5o1FA4HE6cJBPtnCbPnYuhQZOH9UqO7NfTiKIB2KCMH0p1RMxndXZ3eE0+BDivoxndzyNErTC36RCWoyrc+yq/aObmy26zFGPyMWvVOwZPf1L8VwhzR+WSTBUjvE4CR/QPEM7KuXQlw2Nr0+Bva+fwDwKNpMg9yrQUqQaM2O8H+cXS6Q/7HpZY97BAwNaH5Fj1KXFSZZdivOyo2A1Xm1YFjyQVRLFcrYoyj1pzLHvdVmHhYFz7mnQyD/uuuQ=
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
filemap. If another kernel subsystem holds a reference to the page, the
conversion must be aborted.

The test asserts that both bulk and single-page conversion attempts
correctly fail with EAGAIN for the pinned page. After the page is unpinned,
the test verifies that subsequent conversions succeed.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index a972a09c5c6e5..e1c84df0f0596 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -444,6 +444,62 @@ GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
 #undef TEST_STATE_AWAIT
 }
 
+static void test_convert_to_private_fails(test_data_t *t, u64 pgoff,
+					  size_t nr_pages,
+					  u64 expected_error_offset)
+{
+	/* +1 to make it anything but expected_error_offset. */
+	u64 error_offset = expected_error_offset + 1;
+	u64 offset = pgoff * page_size;
+	int ret;
+
+	do {
+		ret = __gmem_set_private(t->gmem_fd, offset,
+					 nr_pages * page_size, &error_offset);
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
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
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
2.55.0.887.g758fc8c411-goog


