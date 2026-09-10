Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052CCC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922C96B00D3; Thu, 10 Sep 2026 19:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8B76B00D5; Thu, 10 Sep 2026 19:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796E26B00D3; Thu, 10 Sep 2026 19:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F05E6B00D3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F1B41C28BD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:55 +0000 (UTC)
X-FDA: 85199513070.14.81D0355
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F5A8100006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qY2F3Brc;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084553;
	b=5FlsYOW4Ow943BrbVjGAMcFOJ4Tih4HV2LvWDOHCVlR0RPB1ZQ4zDreBLkjsMNKk8hWCaV
	XGuDUSZO7Gi/qWzNX0EvhOgITuNagMRhz/4/v3D1IKDEyKXTkr1eK91CjSLAlzosK8q1OR
	Qq4E3KGWUvy8aR4QFPp6apj5LqkWzUI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qY2F3Brc;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084553;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dT2qy2jFpIzhgHYtOWAlaosUmjZJ4xWXaxwzQ1xVoCw=;
	b=v3MTmcONtKB4uPFPNSs0KQkVZbmLRTOa75Gif8cqgXDze2gtiLqt1+Yi2Wt8s94PMEfFKX
	5Y7aOKu3JbcZ2lbfp4rSfRzibkBoV7X1k2g1/fYUf9Kg12bCxN1nzkIKJ1HsqqrKwPbu0j
	MteleCfFs6IelRTJI8OHg8JL/qRkcXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A593744994;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 723C3C4AF51;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=G8N4ShrkYGN5GBTB755cDv3HxqeV741x6ACmQkhLBp0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qY2F3BrcEAlD9+DUuhU1Ag9LdFgkB1u4J6mSq8WG5HY6wxdUHaxQe7dsCkH7dywU0
	 EwNmPAnTZ9np7xSpJsD/KSG9pCC7Vy9tVnG+8OWlnrwaUBgsTNJt7wUxuSruG4UTFg
	 F7zvhRo2eSq+Pqk5IQWIZEP07bynY7se3WMJgUP0ujPWLGS4JADL6haeS06bzxQ4aI
	 jyjE2B13z/hMIYrvNYpGO0/mlrRfP7bkY7nGvrr/6P57VZf2cEkuaLwwZ54kVjWtF6
	 7J5Twe7/XRRruvQaAVlgTSKHLp1QTw80MAVwSe2vj2QF9JLVxmr0DMRuX5RMso0pA0
	 R8U0M7gcHqZQw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AACBC88E4D;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:03 -0700
Subject: [PATCH v13 37/44] KVM: selftests: Test conversion with elevated
 page refcount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-37-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=3126;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=PmSTG3Mn3VeRBRB+Sk4c+WCKivO001+yahByLRYiXQc=;
 b=RpykbcULhzk4ajqe3DS/wC8n7+NFwOF0ACIKr+g2KTH4KaYSGPwwQkK/DSqTHRM2PdjRrrgAu
 Q3Hqr1m2V5LBan2oI5vKX8wYPbB8YSk5b4E/+D8Y4Rnch7JyaXKpDli
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F5A8100006
X-Stat-Signature: bk14y9oqnpiyro8yksmccq1rfmpwb16f
X-HE-Tag: 1789084553-94527
X-HE-Meta: U2FsdGVkX19+oEmPyTHuK+Xqf9sP8e4dI3T63aBwJl+HKx4YaC0KaT93XTGlZjP6qC3WgayTw/E79tPoy6oAgG7ryyGpGw49/z71Wk/XZsZn0aGYxxNsyk2IJjYrrAdHLj90tFRbLfTGsgkVG+92R5LUC8oOnEeYdDrUikVn/iOWYcm3x6MwK/oNp13PSuK/hjo8etjiAcqYIWvMDbCYl35YolyYvON/BsodJ/vu4n8nh/oYe6EvGB/PNyl0Vh37wj+rWwH0sW5dPrTqrPJg3NDLW73N2mBZA9TxDjRr0HvBxfQhefej12X4wo+1gqfrfCcSb288OvV/16/7RFc+JZIIfTX5sjoI011lTZWWxNUo24S/vDPbzwmtAGhjKtyQhum4QswkoKqp+ZZSk10a8l9tf9YdkHEUXD9R3QG1UAZFRHKp3JXa/cNqUzRTQhe1Hwvu2q/mFQkSObOri9gFm8Y6f6T++5RgEbKJyI7EztmAN7WSldYnOwdJXep7dtnbVHqmOuWsaBuPUtu7P4dGRwubpBWynSJIPq45PBnBHG5QRz8asn3Vwn+Ia94Tqy4uXTB//LRHQBlyo1Dp7yk+2tXGWUuec0l3vsZp6xHZYUOmZeCyXK2mNv1itIecCkApSQ1G9PyJ5EvxYVYKRGCjkhhTCiZhd0M0pdQVkAlUMIq/hvK8+jouFsJee0rW861Bo2ci6Rt8hmnhgqAWbEtfI+fkxp34Hw74QjSVhHs6DUa7yzjSpUf5kw47F2y7FDftM7Jg2IFvvYUolE0Pr9GaeOqtUcNXtp1WIPIWpjsaGbet+WVaak4foRm9YVzw1HBY44lxlzv5gpYan/d3tJG/f+WT3Z+NvCtsJfWyDRrzr0Z0UsRgACBhXWWOd8Q32Bfd7RMtorwkmv8YFAQvLt/auW20E9b0Ma+g+TfwFXFSV+STkJQ4njHJM9jd0SCtQYfA51w9TwgxYpYvaWsWSLe
 0iwxOToy
 PBrdPpJXAKPz876Z30kbAeK1yFJcmN39PYx2eAcL3LAE0bAUiNdsyhQfP8dIgvGI/BwANRNEORXzXdGec0fWY6u/yroZ4i4qcAtdV+fuOp/sS90LHuwVRpyiiDL8m2Y5Yv3V1svqjJatEkxg+D1wL4os13pSleOU4TnNIh6vH/lM2qujzJXAbZWZQFUQlh0u4dLNxTjl/4Ct2XXPxyVORUdnHUwyk6I5qDLUt2GyzVqBpePbke/poVRLp59wDk3J+x2Ar+qZzzKfPdVMrCfTIOuegZuN4jaUiHT7qY3Rdh/n6mTEPtHQxTjIiDKv2Tchf/E+jj3oO5QAugdqN4Nv0gr8BOFqjgU4l/5Kc+4lRR/HHaGIj8isRUD4XP8ur/ArQhqYvAsxcnhayGi/BRCqZlTbt5HRby1VfFRr52zJED3nkh4MqIwVWKUwzR42DH3CjIrKCI10uUxP7hkeNsBN/MjnkRiokloqN5U43
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



