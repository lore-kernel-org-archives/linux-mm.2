Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D07C5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD936B00E1; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E1E6B00E3; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693C36B00E4; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0F56B00E1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE5AA801E3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:04 +0000 (UTC)
X-FDA: 85075824288.21.C0CB956
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE59D4000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/SJK8e8";
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139582;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grhi/jt3L82JwFBEt8hkD+uqd7CfBn5jN+ggRqn3qh0=;
	b=2fDPdfLcgm3Fp77eVfbcZpJOyy8tgNCd607jKGLXlZaYDKJ8GBU3HWUuzdwTAZieW2yvV0
	swDjX8Wc3G/cBzwZKESLZq6goM2l57LXRfZIUKiZLsSesMENJX+ATSSontBd/aUzlxOX/A
	EnFek7oex3IhHlUcA3O4WtELwjBssgY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139582;
	b=o3qlRSZ72ZU0Af3Ffwb9J0JdZSO9zvkh7i4+dPXgL/0bTfk6JMP5gAymH3nnTLZOQBNpGD
	zCl2LAetcgYKLvS5gDj3sJ56bJ4HzIOwzNrGLhLg4iS4hSP6ek78GijnveIvGOhs5T+1gy
	L2Q8sNkuB5W7t+0sjcrJMEngvazIcUY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/SJK8e8";
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF9AC45234;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9C93C2BCB8;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=AG/91FYLM0DO9+cck1NIO9nDiHcOnSroQ4LfdHp3ioE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N/SJK8e8lD6KSkxkcOVSrDGMbjIkLh6zoxSiB8vFWdp66hTw3RJuSr8WUOPOPMzvN
	 yRydKoy+VpRZVhPv9TNjQudy4N5Dyb1qNK9IqVo7rvtg9ToIVb7sZ4wdxX3vEcRk7N
	 t6A7bLSsgNr5lV+9XPyBTjNJhQsRqKx4eFqOcXDBXm493vhran5oFhDpLPRSzQ5J2V
	 pVF805v07ZvRww24J0tWtAlyubzUlTxdp4qzkJUJus8o59rA9umKGpSb3VG1bm9a1s
	 /oq/J9XwJycsxhJR2qjMMpyJVqGjHq+vJDhfWF1VcLKDLCYC/FIN09Vb+ZbNjSPVLo
	 9ZycNMyvDvewg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5935C5AD2C;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:10 -0700
Subject: [PATCH v10 31/41] KVM: selftests: Convert with allocated folios in
 different layouts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-31-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=2317;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pR1j4y2LoLWaLX8jxwPGv1VVAKk8ThG0YqF8F3XUFHo=;
 b=J9+DQkUjkGb4HelYEvW/SqnQ8uNjodN1J6oB6YRe/dxweMyOlALGBr4BZIy70J1AfpWjzSKhk
 hhXUnozOh3OCYsp/HNPNkKktNV3dEdDQqPSHZtq0SH9crOUZoBUjeTE
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE59D4000F
X-Rspam-User: 
X-Stat-Signature: qjwww6rfqarfu931w6unwczexa1giiap
X-HE-Tag: 1786139582-837155
X-HE-Meta: U2FsdGVkX1/wsFkvAlwNKjU6JUXss/lwXLnUIq07dSWOInXiUPGbZ5DE7kpAfNYJyuLnmtEAqn80Vd94YHtCYpypWTk3+aLQKyN/XBrPEZkIbyARfR+WhGUk8WerBrI7npOYhgjyrJLsh6QGPnwJRL2AgBPWj1CLNudfqjbLcp2KlZTFyFg8g12dOqq1yqG4WdUBEeow690FdGxrJI5MdSl4dWr0ZqeJsj0OOseNEevKbD9hj3sAol6pto0GNkmvA3FxtL9ztG71B0NBm962QrxKYjkZ2pNlmyCnosB8pUTFAssPhTSkFYZpaThkA9gAGok3MXvatD8xvC/+Fjy9YGynJf1b8xirXAilcTCl/xU9WcyyTfbbNFPCFXpt9RSEewUfFRXKA0PaWRJuMzTNYkzR2cDErvDW+yVSwEuH7oqzZIcmzTxxi56uiGt2oDkBeCjpqZsWfUDW+F1rgXnEZnp4AbQI7gN6Vr7uNHTT/b1h1hc26ugpohpkxtxkb8UhuHNPTci3UevbvRQZcgnWprGnopPpjf8qdMa5syGZGOE+6DKnT0kjghMnCR2nBF3p8jtzNj1jzcEsM+uKGMStt0p+KDYDvzVpKOcjyNbMGPfUHnozwu3mlRqqj4c3cyaP9MEQvsmVbOb/z+7b4L7/V5Rig9ZdZaEjZVD3lPJRfpujoYh21+TnOGU0UmmZGZoiZO+FHImQPwQMOTxLnf5BUMN9WX1oBRYYdmBPruyvx2EOVx4l1kWUBVMZDU9E1yhYCY8guy26GYwoiOFfrLflByNFb6T7taJ6QO10D0P24E8DVYqYNiuemFZ2q/T4XsYtoJzsMJTUD+hdiYEeOykghpKSuQRziD6u9TFrPVk0JAhwewJ+Vqd6w9uYjcfp3F6akTo/Ws9fY0g334dgdRougxz/LIhfZjhgO15glbs1nQfTC42NBn78ESb4S/fLMkOVx5nx4w+4X0YYyrt6dMv
 TVErA+zB
 RwZ1BH0EZD4qwuQHzJ5AYg40h+/vHmIwDzRlmHL8zEmSIRdmt9aTsWepcD9vSGurB1iVFe3iYmwndkujN8i9STDFeHk2mPBEz/mZq7ykH8zyWmnJxkxOAQDTHam1j1RtHrsNI4H3GL23E8hkf9wkOnmAt7OGQrjjoOb7ZSBgYIHQ5+QIGSlIoOZ9RUdYdL6dykFkouGKXNPt7IZtE1bl1ID8ndB/Ie5iV/ZmYcl1gr5Fa6vm14TNe1MCedQMV1v0wrjXY7FKQrOpcNtfx6gDnHXDKzo8UWFuk+m+aI3oBQkfKYxB5+zXIeaNAgSGSWWeFtz89kTyi6WgTdMVS+BOcYxTAUfkUQSDnkijbFulp9SxKrmpkY2EVBMdshM0QuYW7YuIqDTWVl7w8ZpHgatX7ShHvRKv2CTbJe6gSq44RKE5t3xe88aWtduyK9BRWPeHHj+Uzv95MuU/9KBNI91xgGrpAPfFvs0D5teBN+LyCWCPmx4y15owvT+dIJXmnBkBDnXbQUuQuoAa2xT8=
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

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index f46f1530a94b9..acdff2d154046 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -282,6 +282,36 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
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
2.55.0.654.g21b8a5bc05-goog



