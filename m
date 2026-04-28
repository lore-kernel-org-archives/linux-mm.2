Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1CABFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B0A6B00B6; Tue, 28 Apr 2026 19:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622EC6B00B8; Tue, 28 Apr 2026 19:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538CC6B00B9; Tue, 28 Apr 2026 19:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 435C56B00B6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:26:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C08B1C0DB3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:39 +0000 (UTC)
X-FDA: 84709548798.20.1113F77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 51DC2140002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nk0SOiwP;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418737;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/KJygqFPZ7mXkp4Hy5b2gs5vjmWQthFtrw4gXC7p10=;
	b=l4ZT9c1ArDb73dXiMk4LfJ7dAPo5A/AARBUduetlsOXfucUZcDF64ggcprLamTniwB3lXt
	yYmrl2UmGh0pSIbnX8x1LQLjriX/Nb0xVdKqxWcAJzRS9QJ4SySf7BETq6VHGyHU2WgSFa
	EPwz1UVZNmUzoJOj3xPSJNUfLPx74Ys=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nk0SOiwP;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418737; a=rsa-sha256;
	cv=none;
	b=NE5cm0ha/FWArVYnRawlCI4hBYo8q3KBQH/+/iqhBR7mZLx8mUntfX8aQvn27i7+zWlSgn
	C2XzsrQARc5sWdjTy7VdZ81hFNWRz5YiYCNZRxy3EAQFZueUYzjtVCkUTf9Y8odC+Yrkve
	N9Z9LzxOGP9CDLPocwA5zEv1kcezf90=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F21B44704;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 688D0C2BCB9;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=9d08KMUaeq0JwnPQVzadWhlNCrfVvqp26fVJSl//L24=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Nk0SOiwP8dVt93Vx7geCUuDFtG/Ot6FF9mRvq15Ufcm+AqdkyfXe8VaXQmYrILxZe
	 npvr2Vml3+8rLlo0+v+FT6JTeti31hB53c/EeixK13kXfFXDJPgUhtbjbcNrqvItWs
	 xr8eCkmTs+qjUt71lxfULBhR0qotU0zklUgaXORvG8GpAp8vh3O7qGM0WLpyMozmDR
	 cdmS5DFr+Fts/vvPTVWgplRy1hJcAn2DWsu4uHq40I/jPCMiiwZ4d9RnbyZ37xV6Ja
	 Nu9xsUAI/pA9v4oxlPLgaupIxvq//TLB4oc7LJRwtE2JUX1uU0RUGleq489OjsfIX6
	 +npw8SHJRrP1Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D8B9FF887E;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:33 -0700
Subject: [PATCH RFC v5 38/53] KVM: selftests: Convert with allocated folios
 in different layouts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-38-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2272;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pf9NAC8k9OqEq5nwWVMZcJrfB1uS9zn83YJxtzZTu78=;
 b=CUCvrnQOlfUsZcPml9jjAvIchu4UtLbbdCH6GMthqWb/FfPeIaOgkJQhZfmyUQk33deZAT0/w
 ka64QhgQOAtB8HaovxxkYYVEWHifg8tBH6pTrCJoZ7rhmY1o7fesM4Y
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 51DC2140002
X-Stat-Signature: 3c9p5iatknrtzkexammzc63roszqxdhh
X-HE-Tag: 1777418737-197790
X-HE-Meta: U2FsdGVkX18cajFnV8lKg/aullVK7yBkMTiBaXGWaaHAN+mj9yZ8TfnAUh4GR5ItUhrb8dCyikNI3zDSxUK8QTD0hOCzUUOdmY2mCCgWl5AvOUL/LwZqOpc5IweK0gGx5o+RW370ePB8h9DCRC63XxFhpy8hXnY+ILnrL9pMWwHIElwj0qsXWItd0iQZI1xTO8RLjrrjlRX3jgZTgM2EMSD4Mke8QShtdfGFkDFOJY/oR5pnW9zReSv9A0u9XiVelvKaopkPqGQAgNdNsECcgUJv0dZzt5mFfiUjN0kIT3zCR76tCcMPj20VOdGsD6tMR1i+xD3BvQHHcvIbPuuhwQydKOnhqoal++tBY7u/iKERqHzg5pcsvSSTYGWVFgDvdpxPr6BqQU2a9BYYNdpjJiWbAjnoO4ZQ3kE5lqIufNdxdcl/47YizHXFGP7vkp/fd/p3Jc+ijvOCTj/51qBXNJAqKp65OiRHm2dmVjgqy7GsaKimxt7Oh+Qe6nbCIn5JZF/lM6x/Clh6B/ndnVbUqBxso9zPxXRtWz1IwII+H7myA3mQZKdtVQQtPQOC2RyXxSDJBjz5V2NBFxysXbpOPM9Y+ingyIGTO5iQ6q0dNMjW/3KB2p4zMn3sHhEiUCn1F5H6Ko9DSZmY3eMhxz3jY/REO6sLR6OOQCbIyxRw+f9wbg6EtBUwP9F2hzVZNb0ZBbvbCXEcafg+rUFXk4gOeanbg2hjDB2ewlsbcV3IuFjC9TKJz8NDOR0DwtNaE2jbxZHXiYTHSA7J+sexnKAy8eVJzGj38UnVKUW2GcjGGXqhFG4CBHpi0uHGdGvKK8DIN3ZqKpDTVNuuVDq7Hs7KSFIcgJkwLhtnaZbG+EpnNtaE1wQ7n12v9Vh7JiU8F+lalqwyRFlw/bmFJyl9AihpK6lKOVcY7sknKZPsalikzZEQFtS/u3DDWxy9Dkmw4ZdOK0yes1Mq/0jx83yMa9s
 /uiU0ZNX
 gimbVNlPB2N8gT8icv93WDXIuXgXo+b7Xdfol8aR+t1nnwUuXWa7onYFYbAsJNeSBJ9uDFmCSHzyg9ZdIe+w/DM8al09fmMy8ylHWn+nkb6q/M2zAMCk6Czm0sL6AoxeY3lRvMpxGTw+C1YtOlyRkb3kl2Z2mB2MpVutSAV7eX/rOrHUkw7LxXxK2/SXHaIwrtPzm9n7AI6EIQ2JXBpWEUKkRal+kCK1G+np9HXpWEUkWue6PI4AUFD6QbnmcNCZWUQA6wYuS7GW8uiYzg1cWvi1Y3rPDxkzCY+lNcMgwbcNrdMB4DbWX4PY/FHwIFbyHzpBrE2VN3f5HWOrGnA5PVvBmP40bqDizSKT4GkQGnB7mF0i6gdA/R9FSfE/vWOfH2EomYPwswHfTzZZ02/Vti/jDI1BxEeWQbrGf
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
 .../kvm/x86/guest_memfd_conversions_test.c         | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 92b18373a17f1..2312592c4076b 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -289,6 +289,37 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
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
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size,
+			 KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
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
2.54.0.545.g6539524ca2-goog



