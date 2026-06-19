Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67DD1CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657026B008A; Thu, 18 Jun 2026 20:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E0F6B00C0; Thu, 18 Jun 2026 20:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6BB6B00C1; Thu, 18 Jun 2026 20:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 147766B00C0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4B5C1402D2
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:09 +0000 (UTC)
X-FDA: 84894785178.06.BB13A6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CF86D4000C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A4+I4jyl;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829127;
	b=aQYJc2gg4ijLeohu0si9bmOd0cMDD6kBvu8NDNXH9UJbTyBTVmH2iFj9JpJV397FUWAcr3
	c1kbm5uekeiOxc4ikyDB0aSl/Bvvg3l9Atjw3UcfASiN9drwuBmxdgQvPXHbWyYmYGhEqs
	dEWuQMx+6Tg4mTyYeRKzEFMuxTa8K4U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A4+I4jyl;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829127;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/9YT3mVkCWJhntG557U4x0rOIcIOWZPC+F9SBZ9+10=;
	b=6MzGTRnyHFvVTSlBmIQEkbsMnRXVbthLAh0PRPR9mgq8G9gxPA+SyH7BMz36smjNQ8T9h4
	clje1I2CfYhVz1vq992w8g9gOLIKhpX04P9DhbHsRM1Qp/3MRwCZcwciDfnxxDe//aYz76
	SnoW8gqjTWA4rxsKjoTzKkOHi/6ss6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2591544E04;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D84F2C2BD04;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829111;
	bh=CelGdSIrcwF9eC8V3OzxEMp5LBaqPY/SgXdA3HXcPS8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=A4+I4jylhQyFpWgT98LqKbEjV6b21Afw1+q0htWEGBbNjyX/nB6v7Hbhpfa857bdu
	 7aGNbOjRQfkCt1Oocdgd6dviD84yJ5440rHVP0JNWOyrjJWa7KZK8guGkGxuVh2gpS
	 E2cde8vhcbsfdk+LCk7e3egTxJc0pmjre3GRw9dN8PXSSa6BXObO4+TMAHbSCuShVb
	 NIifmHJUK4sVwtKcOzuXxvwVG/ADQI1GHgftVXU+Y0SH8uBb3b5SY6YRs03MI57oBp
	 LcNDGij5GKDtQGXXO9WCr34sQfXD1zSWz6uqMmpl+BJWWEqSeak129GVpwA7KuaOio
	 X+pImexjeU5YA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5898CDB464;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:16 -0700
Subject: [PATCH v8 39/46] KVM: selftests: Test conversion with elevated
 page refcount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-39-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=3041;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=RcEpvRGUyrZ9oNGCavid+DRt+Nqf2g3joo3oK0JU+QI=;
 b=1WdvTXOXFGcn5XmhM4B4XGBW7iYWn2QcIPuPJK0o7bdLfsq5Wl0T7yXsUwYOTD+Wa49SefCno
 Ipl+1eP+/o5CHbj6wvDYl5+H8w8x8p9faLnFJC67HSVIHhlPSA+0T6o
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: bwwz61o893do8oyf5q6wa3e9p98pgc6a
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF86D4000C
X-HE-Tag: 1781829127-4725
X-HE-Meta: U2FsdGVkX18UqVGi+NtK0u3wm703Dg2JelS1mDFFu4Ns9D++3enKhYs4lqUPnf0V9wm1PAInLZp642s2cL0mSFJn6jiwp5wPPsN0xtA+CpMFL4CYqHZb49YWfLGtuHZaBs9pvGK06eIK17TggN+19BAGtuXyP3dc6YCkBGA8NcxUqZuC7jJ8NDEngcKdpOVRvCB8VBpUvfmivxKn/9bpxPSE+Cl9vb5LUMnVjIj25fse0vNgjuTPD5C3/2KIAZ31b4PNb0MoQiTE96as6CGHQ1pdpAhWeq1L5jccz4mJD5fgdKerAI4YSHg60gXYP5dLSGAgK3DwMp4lJtkPQUI00BQ0OyPUmOhmdsp6L2PMRFr6k0g7Do9UDdu7Zbd9IvG2GrAtp6g1t+r8e9aCxTI7DI24I5iGhVYNJq8bhbuWQiiwVeD7u3OrsIOl08mvRegnlHQCLssMRdwVYAvVp2m4pyktN/2PX8k7qIME2I17Tr1D2aN4Xwed5isN6jK1pjf+fU71cbNrwMYttt7xI0rl+s/BSoOdxbrX1wpHZD6mR/a9OWq20LdRMYkRcB1uSScebFp14KhWCzotkYAAfoYIyYBF6Xf50+qOUdRzaDwlxfnajijR37b2w0VxaomfjaUmFuL/K9gib5EHPe1fo1GyHpOFlG3nyAbxei6eFmAcNInE66PCeudPdlPx+GKO+lZoIcAgIaJjObJox65K/lDr35NFmC6h+JbErQQG5lQMgrUSwvbqyU153IypSXO8vLNb7RdwXt0celCXbKwzK4BCM1KzxzaWj3qhAtzUiLbaahmFXV9KopoH+/tj1EYaJI59pYLt73cDkKxB6xgR3GPtceEdsKhQaCIloDkj4F6hYMJUK7y/kgU93DSWRLOYm0I44MOe/DPzy6FoY9r1IUht7hYP8ZJk5TIArkyvXH2/jfd37bcr8ZwiJLaVcABtun1o5E4IhABCq0jbtQ+cXLf
 iM2ckGD9
 J7eAtpw4xaGeg7u5lm/qFXZUdPLwZnJRBycqm+MGTANf9MFx4fDQ8i76Jxc7Hb21zuiqtJ8bGSt/N+aACm5+oSTDKkyBqG0cVC4nIsoM7BFM1scSy3uP60ptdemjV4TM447Nq9zYR+s2GCD15W8yyahYFwXtdNSeOAmjqZhPXNid/Wle7iV1ffzHIrl43gz7RKa2HpWyoDp2JTMuq+B9BtL+AbtgPO+YS8a1gHxAM/kJaa8gw0JxTpaivmxGnz/x5u+2HAr5fnbQnPwYo7ADy0vUIxB+i07lOmlyrJAoEveuDTEV8BRcyy40qHkJxQAqiF7MuNv51Dx+tGUxqQEsLKNGuruoCWlz1WxBqLfTdwTvs5d0WQeLKAtfqSc0TEOEJ5llOyCvkFBtXh0rNL7siZ084CJCTtuSogxLrWIurpyLV8GaYOCGe9RNbP+lfPqWWbn/N8s7ilasO7xA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a selftest to verify that converting a shared guest_memfd page to a
private page fails if the page has an elevated reference count.

When KVM converts a shared page to a private one, it expects the page to
have a reference count equal to the reference counts taken by the
filemap. If another kernel subsystem holds a reference to the page, the
conversion must be aborted.

The test asserts that both bulk and single-page conversion attempts
correctly fail with EAGAIN for the pinned page. After the page is unpinned,
the test verifies that subsequent conversions succeed.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 99b0023609670..4ebbd29029526 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -441,6 +441,62 @@ GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



