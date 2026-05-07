Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DCFACD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41FA46B00B5; Thu,  7 May 2026 16:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330776B00B8; Thu,  7 May 2026 16:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D05C6B00B5; Thu,  7 May 2026 16:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01F046B00B6
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7899A0611
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:08 +0000 (UTC)
X-FDA: 84741748056.22.87E04BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A90594000D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrJASMqH;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185386;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxTaJWATa04fzo1RejhHLoB2C80Py2+Nd4z24jzIrAg=;
	b=jfpc4sQgvzp2N/9C/LQXoGRox9oHhXQzGfmjQVnflnQAW5awLA0wXUmGR8Gt3if+QFvKLu
	d65Ah8DUZy7GvgDYL2i6ewUmK4jw8W5pWnhAmqazt09UhGpbzsxiemhs1Fa3r9FaXLj12/
	+l+1qzMMPUyyHfnyQOGhvnyrxxFGf+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185386; a=rsa-sha256;
	cv=none;
	b=Gx2bzbM5ehtNcaqae/Siv5jbmjfAgUvLldO4Gq2LMtE9QTDQXAMm3XcVdcHC/VUnIqX2Mf
	CakdqRaGJiM9Lzxsv9DEBSC0OACFegNw+tF88zIDsaKWTwo5lrJfCeqBMFUb1tG6DqeqGj
	OgnENq3cAKRFUk8jH2XnW+eOqthR2xw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrJASMqH;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02BEC4488A;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF9B0C2BCC9;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=i2DCByv5z1LmCb6d+0u3idii4v+I6xyhhA6Oey6vU1Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QrJASMqHiGB9kfyj44SZeKYIcKnp+Vc/bbiqM13IlvQc2M6WHqhq8gZEpMxUT8TsI
	 341nP1Ur81sVnLaPT08PkZmNjD0sDfDMxpOJN1z6ju7OZOI/Sb7ZlzEt1ycoBXvPa1
	 DtQONtq2eH/R485v9AoOhoge0CKR1xSEfBjOfcqLcfo3kX8obHo/HfAV1nuvza0qvO
	 2DGN6bZnmhWK1nl6Meqi2zv94KDJE4wOI2cjH2dQ6llznEzjUSPr2RqxOKxGn1/BTt
	 N+5oTriVV17wIV8sjP00ypkK7x6oUQ6YyLIFzfy6j8+pJ6gm/QJJCrO4rBPcX/0Eg2
	 273wihSV7SrkQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B150DCD37AA;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:54 -0700
Subject: [PATCH v6 35/43] KVM: selftests: Test conversion with elevated
 page refcount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-35-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=3740;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ShebxFNR8cyYKJhqdsAuEPs4lv0Wp74neBFpE5OoHfk=;
 b=oGY6oGbsKFd03bkt91zRl6V9nz0Z0kJq6BalAUuo0PhX7ynYcZMAdcRPTk00X1HA2FWG22is5
 Tb8i91J3ExLCt/zmSi/FFUcbyFlEyOIi8Y2aDRbzCTeE+/A3r3m3/hZ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A90594000D
X-Stat-Signature: rwjatd8w7naqkxyrxycgmkef57qsmhhw
X-Rspam-User: 
X-HE-Tag: 1778185386-569455
X-HE-Meta: U2FsdGVkX19QfXc9rSHpk3Q7LOzPuAOlw09QnyQrovPjrBEj5foc8c4zGmlm1cQB9QzhFTFpPpI/zghpJ0gFpgnxTbD7KKedDzx41C2vBwdn1Nv07DgFo1rQ3k7T2HWsItabTzZWnnftgmloZdedUeAm9us0BUCE5SX/Lt1fWTBPhRlZyzybIsLjz/evtP13xinMi+ommgXyZKeJ9STtkOP+UJpc45iAv9/BzqbNfx7jkUfPB3WRDKsJSJCb12IZQqVqMSoClJFNr3hXx71ZFaaarb4Mqrpc18L5LljRKrjyzpsw2vCpI1yYH36qjZ6bocXC/IlHylH5QslD+q6zEHWFHhaThLn78U3uzbXGQ/CS6BW+xD97espChe4zxLh7iGc/vj2xm7Hr+EhTV4JxK614/qhn9VIXvgcMzBWWO6it0dE+gXzq2rfUDNhq5hY8Z311oKMyfYCzA8CosLYZw8zRic8Go5tw3VQoOEoVGw0N7eoHx9JDziXjvSqLVPBpVfiSPES2pQGijP7lFm2WTZr1AiQMs+8e9AxwgsjWwrzeSdN+t0etJIaObZhbVvgUtN7Z7JrGL+IjpgsTjR2P5fe5BvE1A9taaTB0R3OjsPB/NA2HvNdkNiT6G9FxO+stM4xbmTMV1PtSoVXgPjsg4M3tPkrC3pxl6VWPNW96GtNMOTJKczIukfP5YRY2geadLUK9+j+1wAwXH08FxxA4+u3TngXlfbcu2y9SHizmrjXFSuyTYVu2shcM/S3xrRP/4YqGv27AnVlNzVqGY/f/XAHgCGUmm96FG49YeHxabX0NqNr/TwjooqsIeptfiFXfRPUZgG1x9zV0vu5g7JD2Stw5nkUyB4i33m5B9UP2mfv7o0NjYq6dNeqULfiD1IEbCJn+I7CFEwlxOwNvwFemdIYAx3KpmFkyIC9DX4BAiyLrmUOjX7H4O8vMXKHwcj7Wo471egRJsjOid6iwqou
 eZASCn/G
 5FLXf0/xOiqVukhPdp9/BLXdr4G4M0sZ2krMsI+ihUuRkKyAdunQ1YRjODbb0gSw49GSYcL2orLbVo3wp3lRohz16YEpAfHwYQhVga7nJM1FC9ISc0V8aJul2TIj/w4XX4e2w2SuPIqBEksuSaB7ym98KYuAf72L7c04r8gOuVTiWDgZJYqWuatF3MN5RW879glmIW98/78EgDTE5tWbZ5ypiAwu1DkxYzbPdjiGc1f4TwdVFcyqX5gvDz8rVYWkThkxs57xlB913ueVtZgIILtqlFPKhdzRLWl5LIrSrB8TTIUFjhl2k8SAeTutmc2/BQlVxuM6+x5+7jPUUq1sDJo7gT8AaiosUjL1GfQTCTZ8mYfo0gxgSoEsmNpRDRMiJQy8PaGDs9DqPJEqwIvd6fssXrwcGSHulsXNJ
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
 .../kvm/x86/guest_memfd_conversions_test.c         | 78 ++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 4c33e21f04972..00a200a3019ef 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -397,6 +397,84 @@ GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
 	kvm_munmap(test_state, sizeof(*test_state));
 }
 
+static int pin_pipe[2] = { -1, -1 };
+
+static void pin_pages(void *vaddr, size_t size)
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
+	loff_t error_offset = 0;
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
2.54.0.563.g4f69b47b94-goog



