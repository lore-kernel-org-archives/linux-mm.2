Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89779C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737266B00BC; Tue, 28 Jul 2026 20:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70FDF6B00BD; Tue, 28 Jul 2026 20:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D82D6B00BE; Tue, 28 Jul 2026 20:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5406B00BC
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D79B2A1900
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:25 +0000 (UTC)
X-FDA: 85039945410.08.65B6140
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7736160003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Um6E/rXp";
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285324;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yg3xHX39wkFpuW97hlwZzd9M/6RwsbcG4jFSL9klVt0=;
	b=6HJ1CLhtaZdx2T6NPRDm0Nmi1vvdMfflXWmtEM8O4BwZDiLDePQe7rhB4JOby9ytWUGuWw
	Mp6mHzUKeehC1aMxgpv7ZC7loA4WpQa4TE1C5ZwtSz3InCAiR5wAplYq1Ako9WnxhzEsqZ
	aSygy6VCotr4qdBwKp7hktbJ/gCV0js=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285324;
	b=UY613rEQmRCPDoG9CLjD0ccnqxMDEuAhDmY4HnaXxkL+Y7Oh/uvUbNClzPrYpITQTITAen
	MgZWLrc5gxhA/XhJT6wTHWdJ85LREK5hDMITVni9gfBm4COoREBpDnYRKwYRK0eJy9zu+/
	iVICbZlTOQNnteIJ+PPYrvnqYIIpzWA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Um6E/rXp";
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08DFA45143;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7AADC2BCC9;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=QOyzct6+MMNqlbbOwiVZ3oLl44NMHbZI7A2j5TEn6ro=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Um6E/rXpG4iQ+5HVHCaA9qtkyNutJPzhLHVqle5xjIUzJ8a30u68DD8LeC2yTFauF
	 /MW0xA91pPd+tGQP4pU9EyHC3CHhmg2Tr2gZ9suX8hJz/iUE6P0svlY3tbQBXgXuEF
	 fBnvt8Cl7lvyeIcj2OypQxAIGhZRw8q7wxC/3drfeqNhrBJRkXkRKmloLQsrdfUpUd
	 q0r3BkENOTKLw/146lebObZsrlTM7VjbDuypJW0ubS6cuKVml1ufKGfMmQwzAvhcEO
	 BVz58H0gZGnNQihfqXIgLcPre2SbY5K4hYC/Fha+q4b7y3X4PaBEAdWXvj59q3XgZ/
	 X3VDoujXDrqpA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE973C54F57;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:34 -0700
Subject: [PATCH v9 35/41] KVM: selftests: Test conversion with elevated
 page refcount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-35-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=3125;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/+MrvNRpQu5COt5inN/8TacRB7jr9OL5AumNjH8TwCk=;
 b=dbkQYrMNoL8Hs/ray5j0vNAK3uuPf96I/14N5mJZLLuP5Kqu7L1DDputwih2NojwFdHi5DoIR
 5NE7GD/cAwTAEfnHiD9s/sVWYBKLScebJSI1sIyhlvCA/8T3ZUcXJo+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7736160003
X-Stat-Signature: dx5tq6ofdamyi67m45776dp1dne1bh3f
X-Rspam-User: 
X-HE-Tag: 1785285323-238522
X-HE-Meta: U2FsdGVkX1/Tef6RvmMPV9i+bfHPreKaKCoOlyYHIb7Ap+h3LqfT/LiqZZCQSf8K2aisH3Szpj+HD5vNHJOgy56cY8rvvyWQi+UskiFfrry3SQ11AKRb9CcW76yIkJENsZF5rB2l8Y63S5FiX7ZaVfPJGh4fw++1qUs/oSUBkjtsWJBuTXyCewzn+vfcN9chXVYNoyWn/uvd+3Z/scogiTjdLe72BOMbjenXfgH4h4xpd4RS8T1CGbhDsWUyGZ5y+pbLSm5nvmgPyaPZMOIfgsGNvhL0TzdEPb9riv4k8E0DKb4G4QEMpQmqOsFlUUHhyyMVjc8hjPeR+1Dyo4KsbClKJcuuGLoAVjICjEVLDMLWz0MllkQVv4hiPD+SgUu67JFrJMEBzvKUJOo6egbiXrL/4JI+ZXUnNlk/0rtMrvhO/Cz8/ZQsaokk35VQqkx97kpf8iTfEP4Q8fnJJaTCJDkKV9Cys96tyqJ4EPFKDlGe22Nj8EfJA8HAJ1mvqAGre+OSlyYw9UyIpwTT1OsPmQBxHGnW3cuvYLVpvT5IrM0Bdy7wnrDzLCgzd4cCf1ayeEUOow3rNvf7UIBBxTYmqhGiNG2ij4zws7Xrg4wjgeBuXGl1Hw39lIXuDdfJLJnRG4PIEz+uTVkMqQJ+4SBFOzLbXdgfTVKtFt7MTVa0z1nEd5UWUJBt/4ckTq6f3eqeWEPnkS+zIluNLi7yubfmf845ZVNyJ1cfyqwliqqdWmz7JUn3ybbXXvKn8oByvFK3XP6erpjBFKU+yvPyPiEigNUO8drtlZk8VOgKFzh1GvEX/T/wISzWWtkQiHZLI7CtBiPjCMpnp4VogWUKOgtkriDIVSv3wPDt3lZNcgHelI7KkgaJ/3maVOmR/3YZUqxB2mrtOaBYaBmQbCfR1X+W5DdBgjoOnbPB3u8fOZ+OE47/8t8Z31lEaXtiYmYPt5sR1J5s8+jc/Iz2X+4SIaA
 8XSejRPK
 2XEGAagRO4fpWxvrQU6u1Lnz6EJWIPyqj3YaaSODrh8jEehRGAZB20LbhcuyLK30lVR7zo1IbvzNQDv8989BE/ArR93GyRJ7D1O/wJO4xIPvNojmHadmPDKOvtQgHI2rZoIwiul6FtZHMwWRtPAoNTyXKDZEJLfY4fO6fe1PhNiLeNRs2HCdVSi+KmfwHKpmJZc47KdRnCfUUqw6vv02EVzJKSxAQ/akeO7TXD5V+3PzhbEdMtVUFkNjhVK0NK9m8axw+86yftsGmzorJQx4U03ADGhvcPI6kmPu8hkt2ESSmf2GTssMLNVjIbGemMuuQ5YU5D++zt3wmcFOxrPO/n0/i77i59Wu2KFOjKgEf34ONp0Gey/hJirL2S4WMAHFsVYwxvNBKt+7YV4I+fkQgVJKWRXLJpVcHV5HqNwhT4OwFhhP5andapyf+S64sZ2zbAR6IxP6bk/Nyxe+bYaVTFU6fmtDy0ysmDM1pdhZBwQMc4qw7/01TXUbwTXieOSUmZxwTgsDTm0RlnPI=
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

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index e681dac14e865..50a478f9cb596 100644
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
2.55.0.508.g3f0d502094-goog



