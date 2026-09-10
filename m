Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6154CC88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242FB6B00D0; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4FC6B00D1; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048016B00D2; Thu, 10 Sep 2026 19:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A88A06B00D0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 695CB1205FB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:53 +0000 (UTC)
X-FDA: 85199512986.16.CA67B57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5D57A40007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFAbnsQg;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084551;
	b=QHCu8Ned/juWiXh3FLO7628XcZ5mS9fdemmXmweS/kM6rUZeQ8VeBU+p6T8cfNqqOU45P0
	gxAyUrhRlrpeQBVyn/EcQNyEg3a0VzzkHYQEfLeUv3NUpaCPmqnXC6kByAdGXfzkz17PvR
	fmOHf5vaMPBo3A/TU4NXQcXN99awU3g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFAbnsQg;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084551;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlvvggDRZGmtf1VfabDHUI5FVRUkED7yy9SIaxiy5Gs=;
	b=qBWE+DOaW/QFCFEPNZxz3DPHHqRGFnqhEPJ70iklDmkvk8CkMSe92N8t3ZHGd9MRHe/bWb
	vwQFsNq0X500NBPcgOsNf1Uj0X20N6mMgqbvFKrElIlSi53qLlcCi36ZeNHbhb5LG077Yl
	imfjf6XNSQVeeyiczKkVSgwdm3yulW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4619A44810;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BFD7C2BCFC;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=KQzuPdV1gWiuydTuD7xSiqB1zTFyM8IyKkBCWN/jlTY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IFAbnsQgAsVFUA0W6qddZlOeTAQOrgc5bt6IiYbQS1x65mOXfTGOb1Cs28C0KytSR
	 yCxdoaoDNMKuBnalFI3f0s290Xsn7ccHjaVDWgUW5n+M7ARTHkk/nNAoDXXCeKs07W
	 MfT2b5/vTKJzZbzmscR+sqEL5qFJWKUbdckCrUeSRreWHw3EKrdpX/Y/J0FMn6MCgf
	 CwiUdU/t+NoAjQOLbelURt/Ry8lmY0s/RdLKVjGZDLQfCmSZjh1Awo4GKL/157E4Mo
	 Uem3+22+MsrSK2OsgIJZXIyRL+CjO4fvzB6FT2w3iMt9HOrLG5x+IWd8jYqcve3ryv
	 SFrEh1jvYxMCg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038E5C88E45;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:59 -0700
Subject: [PATCH v13 33/44] KVM: selftests: Convert with allocated folios in
 different layouts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-33-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2318;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=i4zR9cZX+AbRAkXfOcfeA5ccOiga6jFKGQu/7pejXYI=;
 b=SxFA5hyVQ67SAlo6+V3QXivJzESo+7dwV1dHjgvb91bD0tOOJnwaykK7t5Zp+elcO2NesofCF
 Cjo4KZQuec3AjiLwaF29Vuy2o1GDav1yY2iJQAXIcHsvpbAEdkynekL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5D57A40007
X-Stat-Signature: j69iip7z3mwjob19zsezgpxhrhfi11y6
X-HE-Tag: 1789084551-948572
X-HE-Meta: U2FsdGVkX19OVwRpyr6vV1/8J5Icl5j3T1rRpr7ZDyoq65qAp/tQmQD1K2JVCIC/dCKaNUktCHf6oUgk+JZMPjcyBCnsVPlAirXWEwUlNK9f+CA4dXtxrpvQ8MBZaVOo9P6UURw8qoYQsLwylgkYLvp6kjFDYr0kD4VJHywYEhrol36hYgk5whwTNGdWzd0wMxKCwI/yDCmtk2gEI3opP+Y+bSO1xJX8316ul893SAL36+8qSeiuRLQ6VkGIu80MoK8hy1/cI1JPh52coNsNTwwdHojcdBcjWVVAze7PXzKJAwqzUvIxJVp6OfV5Q2f9LmlWWfckOONIWngGZJTI7uSsnc2XAnIYfjWnIG30YWjEC4cSBQohntcNmwjUS65hUp1zY0oabZ3fN0IaZxAQOFBpv4Cw5FFlUb7JzOmU4h3dG/1chWsHzVhVdr2gFyVEdT37Th2EFkaujZrVmRFQmG70y8wvOjE9iHNWxT71+WK5V2e9UtbwCnR4DChIfi7YzN+Ltn639TxTrdCty1R+BDP33hMyPk1reZsJe+7v9xUlLG+8Gob8mfuOmEC+VA5g+mqdsjwW78tr27VR4heOzuU3P8XN4/nvL4DPCPJFxxQucDv0oLrIa2tx7BpAVytK1Eyk7dLQoZYQYX4Lb9+ACCwUAWivLZQNrpxn0lIfCffOumzdaPWxXGebgHnRrqsHg4YASX0zhEZSviaR6kZ6EYhVP8DDaV+7xZKH0tX4Jj9OnqYJ9G+r0qqSoNJPEKzSj4sniR07kkJTrOL20uk46QM7AD8i7a1PHpptYl8rHtPxPuabU677HVp9ILaB13LtAJFvZkZtGW02OCXMIHRzL+M6kIFwdHhDXQLi0RmG9q4eFb5AhvDOb+bKWpYsxvxH5+7HohYbO++GEGi5BqoJHo4qJZSi25b3L2o/En9ESCrlrURNbVsovtz3tfcZrEpixeLFGziq0OMjadEeC/x
 nmxC0MlJ
 piUMmlZ7MsM9w9QA6wNt7j7RYVX6RShKDJOUStEWfDraT4WRqxZO3ot1oOg5mrClrSlsAUe1g1n3WN/VX4WDxIafZ91jZds9e4iIkcYjg6lp9q9pw1ntxpR12BOYAo0ZtT9Ka3UYg1BpdkvQP4hOqfsnXcBy49WH+/Ubp/AA4yLxhhVfSCQ42aPR7Rp910gYyI9ZbcJa6S+P29wAblNwjByeS9WRWlKSixcIgVIbEHpLZL8AIdZx0+CcySBi8dEGh4zoZXOKMCQnHxqu5rmboMBC7XFpViaAzF2fnN7V91lMHnIdRrfKztwmAwM9Vi3fROoFZbUVJpiU+gkKPoy3H7JdYb1i70GmwprXC4ESWlvWcRuSYwuELfGFs2V+7w8v9uf8ZsmfsggcFiaAg1cKoO3n49KQG5sBt9p7v3Px76rkQ1b1Wfxa+8AuoWPrKTLmAZEx7ui9KDfcnDxJguJW2wwTEI+CVnPWTJjBH
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



