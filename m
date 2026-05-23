Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CA8CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D706B00BB; Fri, 22 May 2026 20:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF366B00BC; Fri, 22 May 2026 20:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47BB6B00BD; Fri, 22 May 2026 20:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 904A16B00BB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D92B1C070B
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:19 +0000 (UTC)
X-FDA: 84796772718.24.0FE56D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5CAB320009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4VZMuD7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495497;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgSMKIGSduXSa5wsgcd2Y7iM//LWUVs+nrPv4snEEWA=;
	b=MRxWZJNynUm2e+T9Vg5LD1TcfEO4Oz1UC4LCJVaqCgFc8gy1mW9lmxHtQFDb+P2mA+y3Q8
	pwL3dsHY94J4OxvXaqzv89OqN6DQzfgbHq0ZwabmkYeNWCIId3Q0LScHodXLZikjhRGAEL
	dZY8G2seNmXVA8oycukNTOnU00aMLMQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4VZMuD7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495497; a=rsa-sha256;
	cv=none;
	b=fhSXPP4pzXSFM7UuEO8tOQdZ++VZzPdJdFTU68Bvr5puwubk7eVtDiiiSrZnGJN17SSrJb
	cI0tB5Ehoq+FwrZsYQhhEkFeWxGzEPyKqRv5U+pJ7MU2Ogcj24DauOUCwIk/7g+6D2Y9N9
	XryavAUbgoUyvFIJr2ToHNAr8k/xNhw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A460444D8F;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D3B0C4FE83;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=E0i/Ob4PUht8m/+FvYsQmtkYc36JgnYgiL4WTdoKOdE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=i4VZMuD7IbHxYn0vTEc3UBRTF8kslFd0PNTdjnFfKWHZydxN7uhWiKXRlx/WWc7cQ
	 7xKEwfSZ0vHrUiYPmzHjY5ijfXNtu1V+aDxzafhXqZhXUO51WW2W3qYo6R3OYi50OQ
	 c+D1KTw/3eI4uxfJsmgcYogb4Qh3aTxgLpf0bNZqd5D6aNKDHt54znNDPzB5TzXa/s
	 96f/M4G74TEPDPXrAu087xEXR06uaap4Ju4kWNtAU4BB1OzDbilqliqV5m4wf2aDnd
	 12HYFPn9c272ihIMeclCMntXu5digyI7OnizLMH1FcFlL4gt3Yr+nEEm6GFIp2MdqT
	 rAPGG3caM8Dlw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5412CD5BC0;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:13 -0700
Subject: [PATCH v7 31/42] KVM: selftests: Convert with allocated folios in
 different layouts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-31-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2229;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=7qaC2ZARmSx5/GbZ2zCm8aFOw0W5K8P2rPxoe2X7dWE=;
 b=CNl+zq9vG8Y4XPhfpSNG4v1Da9a3yZKQ9V88Ne+bDfM5kK27U46YxFrxvdWdRC7UHnqCqDrgl
 viyxPND3xCfBIl8+e9KmN/69chiqwkjdrE0bglgWI8EKW0YdCdJeAB9
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 5p9su3a51njzbf4h1btnb7ikhytojc8r
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CAB320009
X-Rspam-User: 
X-HE-Tag: 1779495497-738488
X-HE-Meta: U2FsdGVkX19z369juKox2aKtfwO464vHehS0ORBXXCpDewR4YQS20/S5fZJXaNwD1lcjCBeLTKvAzZ7jU1oW1vnNMIWY0p6b0yp2iKG7Shq7atrfggucSTwimmLPaOgVbvTxaceXpcQDmYsWJkoXjvft94w7/D4Yp7I1i1Unk9KbPhduJ7JhL3aJamHOdPoab0sajd1is05mtxKd+vHFpcASOFpkFOoaCD9/oACL4cZf3PnSSOgY0Gotaphkrt4mZEMJ2gJvtwKgDEdCYGy1ol8kQTyCRBauavko7wZM4XSa35oXNTCYgOhAMZG1y9Pc/vJb4iW9lvr1fj6hW3zaeJobV7zuMoS2jIFEcLHQPSwwLNNezsFIYYeymdHYEzgF2HPJEwmpwhA1w9npl9PQ0PaihiirI3TcJWFkTgeG+2nlY2VdOMwYkCMF165l5c+nR+zUSemlfqBER+2r+FjVCww88AaMTXip77bH7+2Q+O9IuM3EJNbHHwnxz6Ij90spAriSCwvsNvXSdE8KxVBeC8O7UbglZm25H8CVdZwIhdtOeMTnDdH2Le14gjni9/tJ8iLRYAIx5zJnnYnVCOip/iKBH7okA9VS4cJp0alfp9nyV1yauOWQdsS8ZkfKgntyZjvuMhnfAGJ/tIc366IJQmqadlplJWvoiN5FALceD23MbxNpsQMVpwAgPZohhOLuD06abEbXY8ia4SgxCWtPFzzDXMsn77GFNnZc2i4S0A9WNCfbAU9TdwWsuj5eKJ8ouYWNGrr6otsokpCbQnwxOsMfBUW6x4PABKZAupp2ZQe8+2vYtKzy++aCJ3wjKmSalKd4ohFINkhOItED39M0Mt2Iz4x1P6oxPheolMJmsix8/LGV47DrZShE5Z6EWwlcf4rqQmhLGoWD+62oXbpq1uPOU+4p8Dz7/3GF/Wnyl3XEVdDW8AdhsJY4XtvrNT9p4mezVnj4k6VqJn6GH6+
 oa9RVwtW
 XsGjAU+JNhR8OIvD3hpJZlzKIPvQ02OX3lKP/OtCj5g4kfQrqz3v+diBPawjCCHIq335c/Sp3b5uHmjmT5VN9GX4aq2OEPWCfx6qWXsv8pHKTiHWj3oU8FJs7AEqDl2AtlfCxq4BF3iTdTV97VJgFGxBE06iPHj+X7yuFp+pO6ue+x/yYwA37ca4Nq5XkGPOs67822UhnNyMTkQ/bpdCkbl4HnLSBUiXrkZ/wew0KuLUEtYXRtwio7ea8zkzLIKoz5eQFO3uEnMkQQO7nppLEJpz0aa2SbPkFX5jr8VgT353ZC7XzBkaSeHtZ8Y+tzh60FcVXLRluCS6CBiL/apWuvJS2v4yXFuSGV4WYi+vaRa7vJgu274//j1rVnoNWYPcZl7FYDw9uufOx5eNHLr2pEgTbqBfkCAxyCeMD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a guest_memfd selftest to verify that memory conversions work
correctly with allocated folios in different layouts.

By iterating through which pages are initially faulted, the test covers
various layouts of contiguous allocated and unallocated regions, exercising
conversion with different range layouts.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index b43ac196330f1..0b024fb7227f0 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -279,6 +279,36 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
 	test_convert_to_shared(t, 0, 0, 'A', 'B');
 }
 
+/*
+ * Test that when some of the folios in the conversion range are allocated,
+ * conversion requests are handled correctly in guest_memfd.  Vary the ranges
+ * allocated before conversion, using test_page, to cover various layouts of
+ * contiguous allocated and unallocated regions.
+ */
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
+{
+	const int second_page_to_fault = 4;
+	int i;
+
+	/*
+	 * Fault 2 of the pages to test filemap range operations except when
+	 * test_page == second_page_to_fault.
+	 */
+	host_do_rmw(t->mem, test_page, 0, 'A');
+	if (test_page != second_page_to_fault)
+		host_do_rmw(t->mem, second_page_to_fault, 0, 'A');
+
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
+	for (i = 0; i < nr_pages; ++i) {
+		char expected = (i == test_page || i == second_page_to_fault) ? 'A' : 0;
+
+		test_private(t, i, expected, 'B');
+	}
+
+	for (i = 0; i < nr_pages; ++i)
+		test_convert_to_shared(t, i, 'B', 'C', 'D');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.54.0.794.g4f17f83d09-goog



