Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB948FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A966B0005; Tue, 28 Apr 2026 19:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4027A6B008A; Tue, 28 Apr 2026 19:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318506B008C; Tue, 28 Apr 2026 19:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 216746B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:27:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FE45140515
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:41 +0000 (UTC)
X-FDA: 84709548882.08.5B90863
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 10DD720009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lp/+cg/W";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ti1J1lReRR1qb4Ajtytgojv49TKLe9MGXkd57eU3KMw=;
	b=kbKJA2992muJ2Ue3qO5vCxGtA9AL08pxdA823pFGr6xnsEWFMT0BjuA6+iEmqLzXf2hN8Z
	Y5cA7LmP7jNMBQXVO6pYtjcbuva51TDFUEpWW+bcXkHDoEWGUA9BAAdUwZ8huUFXq3nZVc
	TOTHhxWkTuXInlOFr0bibhGGOYr2CEg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lp/+cg/W";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418739; a=rsa-sha256;
	cv=none;
	b=6QrqD9yzjKu8Y3A1diz7Sd++lMbcU6JT2sOEuRPlWNnyNnBjgg/cReI1fcDO/Xbhd63xWX
	rVGhdb1qT7NJWlC1pbsi99M2rm7bbrg0CTlwUFYnZ95RgkU5mMg/tdSbQhPsA873btGe8F
	LTV7pL3PjXRvyx0BAd74LHuphP20mZY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBC9944B10;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A46DDC2BCC7;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=ss+F6HkF7cTK/9DopAjbmtDjE1NKfuiz72DZgsQjSIg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lp/+cg/Wy+tb64EDULPzJO6K1JR9dDvh3pBnCpW8Jrt3gO3LUt9CqgP99lbhVKzea
	 LK5EEFcFEp4HEuobUYBOGhc4+sujDTSy0D/kivPtSfIRVam3fG40BG9/whNLdNbcjO
	 nL1hbvhqPklXteycKpud7RPAvXwKErf4Wz7VO750HNlAxTAidS8H2au1n79+nrnVte
	 Drd/dPETRdFerWJgZdUD8hp0+e83ZWYh3QRVI0IIpPDAqqsIFqGHUJohEgLqhvmlEt
	 gf31cm2hv6aNoincOMEVcrfMR4fHLoEP6Ii0XGQoN2T2MC9NfPwS7onsbHCICq3KZo
	 /j5E69Q8xGEQQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE35CCF9E3;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:36 -0700
Subject: [PATCH RFC v5 41/53] KVM: selftests: Test conversion with elevated
 page refcount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-41-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=3828;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/d2k8NxefQGN/ufZ9LnHGnYMKu34ADHcjvHKBhIXD7M=;
 b=1ULjpSvvqj0ZTKtSpsiMXgqtnYm7Snt35jmtyNxH17oWl3wy/V4Zf+IcNqc9/2lh+FZYBo3Rq
 O2h2lMIWdAOD1Tm3Ek0K9e45/q64b7b1AAg3Q7GDSAgbTfaw74Lzcqm
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 10DD720009
X-Rspamd-Server: rspam06
X-Stat-Signature: bbjdcp3xe6dtfdxuxiy9uaaphp164ozg
X-HE-Tag: 1777418738-846806
X-HE-Meta: U2FsdGVkX18VcdLqg957qPl3FXdHmKX7CIhAxTiLxCefGOOlkwU3c+i97VOL76AaiRjtNRTc9GSuSDDJZDJQkGKrogrLwJ+YxZ5r2g7ehQNJk57oAudeiAXKnB1cvIp/u69kVdsnK7oRllfOU1ExJAMAe+iGXqGyb/cclzQKb96d2HacMZw5bi/WEK2FL/t6IrmmBAw+gumDZ6udYgm3ewv3wUNtNTx1tV5fjP8PHtKTv5SrBJocaZSDPFT9bT5AidM5+naXA4FEjApBbXt5fo2QtH2AlkWUFJCJSgN/1CAr5oSMUfvlpwKOQcxAB0LmYEGupVfix2ubzvDlRi6EfdmdpUemcsBJpVp+P/3GaLQmtWwfjjoeAJlLYz4rZrq5UGcp6/ei7gGBJo2cQL6ojjrXchSHPTcE88OVbjK9fSIGpxuJDCizNuG+0Y95PE0j0kQ47NKQBjKbF/LZWbxnw9sOrGtPLbs0bB7mB949f3gNzQUW/Dz5xSQQVMhP06Wclcvar0MFraJOUYufMRC2b2llEaUeEaBY4gNIVWmoKwmJpI3wlwfTABXbmFmM8VyhuRyEBArO4wsHy77oNE2O7WZRScUt949sWeXa3xmabvhkYUCcU67kpF9JWGap4vudOvCYNuWXh5N6Me1MvTXXPhjBXkb6bpldVsUE3cJnzYJxYVQ2gh3yYN2FpxU1uqQiqXu5BB/58OqgPKTpH0AfODEwXXM6LQiKer+iHDboI/3JyfHZh3MG+0QAt1YvwtYUC0qF4Db52n/oDdVvJRcypCrFFFTEykE9nrvR3RbUMkWAZxJ6IZB2Wij5TLoPZeFvBu3BWoFymUnRRWBlXYiTbHoa/i8PWmWNyk9HVYQ2uKRzdFmhfZOc9IUrphxG3q6kVX8SuCYOiHWTlYsqXQVPSscAxoVopVDHijB3LWW6iNvcIqoYb6AsXWwatxmDUrTHBc+n0i4XcO7cC03pjbh
 QggL3f5c
 eoKhF/yZcB4HLkk8WMvmTXTXaX9vEF5cAWAb7DCw3Nz1wXeKey1rhOTr7Sexhls15d5tbSN+eDN59Qu212GyZ+gTMEhvFrKUA/h6ZX0F5iEGjGIhcfw8Qgyy22rc9XyT5Kgu8Jv0AdBl34llfbfmmmyETPczfxqMeFIGyr587JYbvV/ntW8xB3JYZSZxstycK2xCt8UR4Ge4L7RUi2W6Z8KUO6Xr52c4SAlD8KQwnCd359VWE8Qz5Y04Axcm6F1SQ+gyKrsyaYxkqZY/AkRR6QdF42M7BP0jHnAgZ/Apvm9urVgnzfzTTHKpjD4Sw1lQkKtixov2m/HOpxk0EsEWCtEwr3oqNedBpEsdVRQi8FlyZybi+/Ypk6AosAkSChSVXxiaSHk2jvy6N0GKPtFXrU5tjZgdO5kJjLVVl
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
 .../kvm/x86/guest_memfd_conversions_test.c         | 80 ++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 21918b83d3792..13bbc361eaeda 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -408,6 +408,86 @@ GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
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
+					 nr_pages * page_size, &error_offset,
+					 KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
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
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size,
+			 KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
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
2.54.0.545.g6539524ca2-goog



