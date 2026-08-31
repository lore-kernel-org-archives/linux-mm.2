Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB73C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B636B00BA; Sun, 30 Aug 2026 20:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2039B6B00BB; Sun, 30 Aug 2026 20:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118C56B00BC; Sun, 30 Aug 2026 20:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9CBD6B00BA
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77DD9A0349
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:40 +0000 (UTC)
X-FDA: 85159671240.20.6038F1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9425020002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IicruLaT;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135938;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WS2fl4M/NuVOYuSnBe0+TNtkq/Cb2z8s08exKVfWxlY=;
	b=cs9O74AEAhWG9U10FOddhyMDgvYGKsgUEmtTH5iHZgVWoOv/0DnJ86m0FLGw8ENQG1/wSc
	D7IcDcAgVSOdzt6EgKC4iwz6ya/0Xc1ajsFPN70hBc5OyInyMV5+M1vVMOuSHJFasKXMlE
	Cxmyo/9LFgH8Zw9YNChgIuk9+ANeV+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135938;
	b=mZtoGoDTcB7BNlhxNM+i1png9brQ150LRQ5d1RjODgTAvOfJ287P92eJ6czK633VW9coNi
	K0iAiorLg2P+1n9K6NgGpAmm/uHEEqNSuZYhZc9ZAtWHxERgs5cEKtYkVg8lpyHClp4zTS
	S8WaFg4VYsiCmaL6DXeMquuoDnXqKpA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IicruLaT;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5330E4495B;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FEB3C4AF14;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135923;
	bh=OvAkVPkagVMy5Xn4F+rMZ//usPS9bakNam/vvgs9Y5E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IicruLaTlmeS+wCZzY/WJRg1JvHKeWI8OmKsHGYsfw9mA4DTlbfJb8mE9o9fF07VZ
	 S0oVpvVhIy9ckEBjapEMf3HuxdmsOUSTgyAdGdrF+o4rE/C8MozNrzZLVwA5NpiuoJ
	 bmrfAo3JQ6E6uIipPiUYdl2KRNB9tvUSKQxpzm8f+FizNIZNrNVzdl6i9nc9GE0PfG
	 3+umJfL7+ah/R3tTDIdPFsdZOxNwZxCCcfQqT28gPEVeCRcg40N5irIOgiTWfR+khh
	 kROiepQaOz6L/g+7TWbsb2SuTOIuXA8v+gl98baVGSE7V4Pk3J0efrM9KOYurdCkTx
	 jDaXMIPIXx6YA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB532C61DFD;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:35 -0700
Subject: [PATCH v12 34/45] KVM: selftests: Convert with allocated folios in
 different layouts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-34-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=2317;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+hxkHJeDQpRciSqIWpnQc1pHp7KNzfkACeixqLSu/Gs=;
 b=MM8eGbO3rz6hZnoKnOSzc+DYeMRhE+qHY4HlBE7BG1z1ck2Nf9cx3lLleHcoZ6ZRBd4kAO3jW
 Ew8OekNZZ5uAkR8MQ03Leo2tjTLDL8mcbW1k60Q8Q6aAWTP84uCGjZ0
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: xo3iu9nmike8p7mt7e19iqwncihcd54i
X-Rspamd-Queue-Id: 9425020002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135938-750741
X-HE-Meta: U2FsdGVkX19TDO+1cc61j9QYN0Pg/gqAqpRNKSo5Ioczz+1sthxJvia9KPqGJzrhEFFqpzw+8LI1I2zvbZQ5vZV4V+/vvtpJ/CM9nkIGsiFhCU1wo1EsftFKb8/UlnSdANDpIvKymOfoMH5ES/RAaiu2Ju1ytEcAujfIhwAMjPBagRRrLVrLq+NEYnoIx6K7rfZopdUjjLuc5CBpNC8CK7BkipAurXnGgZ1KZuVJfiLxMbbEGHNPC053hRsVX1gplIq3qyLmkzBEGJAbnObBbrDPLRbTn4kdXid25QbOZ+d3NLtqXlev85SBoTpuf3VDtdG1v1DHDbh+/Ooc9AW5YV1FyPKjwHt3j4J6pMOVYfCmJUwQ+1qIJfNPAwNVdE6ylfJxCKM/JlFPpYF6T1iBTY3yHWtKLRBfDpIRDzrtC8HkVeV8m9rAR6VuZsDjAbF9E/HuzSzNMJi3MmBuaWMPjJLbFwb/K9ddOR4NtKB1VqV6uDGYnAuwuEW9IdIc2ye9c2iBdVNlruQmDOUiXfzy8NDcSbNL9Hl2JNFmBU4S0Z/rb1HlXmDDyjsbOfrjvS7/sMndZiQsAQNIClDxCYgVpL0CUkj0UgvrXmMQLD3gZ7kjoeFubgzawXafrgyVF7BKMjrAt9XFlHQXM85vSzN6WZAC3jw9gaFqFMlOek4h0xypH0KFpXz0/RZpwHUjU59n6+jfuZMnBYBwItFt1Zb2MA5sJbT/4ALOVnqfSePD1zIqbXuOK6A6lmkMbvKX8inJFW/QBZNS1zpIJNEDqJaNT7EqP42bTwY+P/Xw9b0bo6XMBDvsVsTkP5ygLi8KDliA8I7fJkIW0/RyZthicUbltER+9o/eHDH5lDC6VCqXa/TQUOuKHX9pvPvGW+xXmJv2jlBGeXlMgawM/Ud17dP0J3dajDnAMkZ4zv8FwP8x+nZXbhduLwkVV9u8zhDSQSDApXEgauNoz+CjX2tUiAV
 AwgWorJK
 ZF3b0cUT24iJqqkwF7nobBTHT5IsqbpCko/CkV5+GnrVdtUGmccg2WHgjZRIaFsH2PB+iuyX3FOYk5EFgFSWGeBI05cc/uzpGA4BP2asfG2X9cRYsCzTiR8V/F8mo5/95YKjEdJyVBaaUNtPrzzXPRA+Se0/gg+apvXelzNlqQQE0jZb2k/7RI44gan969UzQXU8/z7BX5IAn5pE4N4wWC0iDbAWyWb1C/eRS8PF246tXpDGIvydbnEDfldDxneDzA8MioVokjrxCUJm7qGc/ONfoV0Puiw+XRPIFyIOrIhfCJQ3KEkh2/XEfs6Q3OVPUer3K9V9bIW21+i6bia8C4Hr4FxmPQKaLFm4rg7j0lV0LIhJv17xBfC8/gOtCUvETYd0VPcf1Exuf14PC9LVjR+rbF2Omg3G4VXlhrG4tNvQmNIAnUF9yHkp8OWOJe0opREAgukbhNsJEMN4HuwESbBBE0+1rvlgtdhgU
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
2.55.0.897.gb25b4bd76c-goog



