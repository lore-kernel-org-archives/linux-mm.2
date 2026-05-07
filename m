Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB4BCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D25B6B00B6; Thu,  7 May 2026 16:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1103A6B00B8; Thu,  7 May 2026 16:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6566B00B7; Thu,  7 May 2026 16:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2D476B00B5
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E41048D0EB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:06 +0000 (UTC)
X-FDA: 84741747972.12.C994F31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A6A364000A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PH/MgN8i";
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185384;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOFWFjiK1LDThqeVeMS6wdMXiyRni83X85WS4Q1dWY4=;
	b=K/7o3ZDjSETWvQF04aQVKtEQI6kH5ohjujfNSeg7s1LQuk//uLrIeSCaLItecH1nv15+N2
	houbesKKvgmytR3L8iWDF/cYPS0ay3jUj8YQcFxN9LzSEklGstlGGPXLGZhy6pp3XXrURK
	hPXrg7y+rQYpoR1SaoVdruGCyDdTavU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185384; a=rsa-sha256;
	cv=none;
	b=GuPjRkvVSKzNHRLJNHxWncY+l7Az2rEQv2c9dcx/sFCue5lCsrHPJRgkFPnOriwRi5Nv84
	5wMGcw5JzPoDxTcY3JiZYfyzK/bnq562Jsu2DUyHcNvEI72mw/z/srkAZdzfwq9PmW7Q1W
	UwQ8RDBTx4lgWrgnedavaOj46Y9Au9I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PH/MgN8i";
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 908384485D;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57586C2BCF7;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=AmPa8Nrk9/uaZS6bTN8KV7O2c7qCf9WDXgOFJqYbDRM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PH/MgN8isbmNI6Q5RUGCcUl7BW5qOBgR6VCR5WBL5uIrFoutntIL8RUiOvdBgLpeN
	 lBpUqEx1lvQTrGr0J8SxRMiPwnYA8sU0SIsarfEVBhTOQo1ZsZWluhwt7ZZ0f0a+2g
	 ZxRJ2bSIvUh8Fhl4JkvQJRBQrCYZI3EjRXSBC3H5FPXlfd20uc1a1UsJQKFgy4JNPj
	 zxv3w1Gj5TiKzHJDCHu/fkiM6nGZurltb7KmZzSBXIw5DpW/2XhimrYu7OS2YWoaeO
	 osFZF8EsWVUXDMnZ2bRx9Mj0WB1zkTjA+B4BNTThg1RCB/ZbO25JeTr6flw0Lc2sbS
	 lVHk781SUBfWg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48925CD37AA;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:51 -0700
Subject: [PATCH v6 32/43] KVM: selftests: Convert with allocated folios in
 different layouts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-32-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2229;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=U30PWRoxZvatgnkzApDxPz3Lg0PKiMA0GRESREL3UkM=;
 b=Q6e5fgJZGwk6neGM6FdQTWpy/mqAzMM7liViagZX8mzm3WCJq8vXVDwDOeYL2FHyqtHd6x+Db
 qqSjXzmFkaSDH4eKTyyItrbccxTn5KPJx+MTW4otAZGxvyYKhfLKYWu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A6A364000A
X-Stat-Signature: eeiqjw3eke54bxbyfo9swmwmd5f3dozd
X-Rspam-User: 
X-HE-Tag: 1778185384-366634
X-HE-Meta: U2FsdGVkX1/Y0sOYEjVZXHtkMNEsJRwDK+ly6ddh/dsOBhQzGCva/Kkt3hs2No8ie6pcWVDisV5aLbIN8V7miIuugFMNOVleTkZZ0j5sWbIuObVYpkq2vcsp1W658MLN98B0tPHZw/jfYe9dl1RA7ZkH67TXXaV/V55XHiYe9ls2iDd9PTBwNpMwxSK/LuT5e01toJIgC4qpZXDWZcUDU4yaviAnS6Izv2fXonOYfBcSxXuVKObZiIJDThXl0XJqfMSFA9oxTJRVAYagQa8+Fh5rvRYn0bycb/cTQNW22MtmWXi+zopgkZU/SqVESCHVlTEJHCYpdJPVScPHZacatBPDkLTrnd/mfHbN+YDJ1enMnBMM/vYQHvuLex0Undccn8LzhycxdicATxSWYJFlwqDTKyxvY/Cwc6eWsS2j9TjrVVFomy/ab2Nbyxc/izuNo81TFWQRQF3rb0pALQBkA4TBfv+3fdvaCFKeebd8ie4+vhz4HW6BIZL1QBOs23a6Jc6XoJbKHcPusP+2neg18T5m6Cmp8gRbQMOC/7CDGFsXZ3nO12n/aoeo2XiFOAXNaMDzZ9MPvHQlaASJfTfDg3xM1k7hQ50Awfs6+6ZMuJkGhW0olTRR3CHE1z3yHb6sHivBCRA77I1rf/K4gYTgogfEu9/rgYMOMZHi8KZM4ZQUze/wZH9YSHgMVC62Bltqsfc6JsQFCC5KL26UYJPEt2zatzgNRZYnN2tpuy/IT4POroz0ktewxD+TCF4920zzzJgPOegxcEkqCTu5KcunNwGym346NDLEQ2++MeqJdcBfYUy8EYkdgyXbC11hePmdUbQ+Ci90eOcc6Pb2blMcE1Ep7O6hooeat0OYi0CHAsnKL0H7KtzTqr7H8aUg0tfu7GfjWq0oIOSEgDC5sglnQFXhVAHsUaXmyppZinKE+xDPl5JrJs837ex3UkzVQv7B4J96xWmkUnZbHfSC0qt
 h8iioj7q
 ML1jHxu5izQKhp4hXFJyHmp1TG9iaUZPaWvlF4OMhUg5l7BhWKrCmqUXDuu72oeOF9Yl4hC0BEq3HWNOKIW7FyFyhEFKDKZevviINCdtnz0v1dXAVCxhZiltddPYthJMP/9jU9w9cWVRYcN6Fk0k0jzCuzYPdXJQ5z8aDAV7Aw7SV43vtZ8cxJhhR/txU6pgu3yXQqlSiA4MzdF8wwrPfbxHvGofzUM8MO3Rjuq2CVzKn728Pbengj8W+Oj+FUKF2J/G8V2pHxiZ0si0tuJHME6JIx7GvT9+x1tfrZidbMKpT1/ujKT/DEDP2X6xsCc26pTbm7Z9agr3x2oDp3c4MonzRp0XuRSI2auTTk+eICWQe2jD2ri1Xou35JSoUclvky/pj8lHlD8mNVaMaib6tp8h69Gr2Peth/rQX
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
index 20abfdca1e030..21d33e2814f9e 100644
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
2.54.0.563.g4f69b47b94-goog



