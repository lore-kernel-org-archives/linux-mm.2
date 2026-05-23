Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33230CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDCD26B00A8; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3EA66B00A9; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53496B00AB; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6AC26B00A8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CE051206A6
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:10 +0000 (UTC)
X-FDA: 84796772340.20.24BBA0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8DA5D100003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W+qf+88G;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3ShuBgLAY8k5tDq6o+yE860kJEco5yQY9MSHv0QVCc=;
	b=c+rmN2RZS5MuP7I+ZAat0fvzwJT/Fm0G2CUBc2DytNyuAuvUwaFs4mHU0d+2mFSDFy2+Pv
	pe3+LF4zp5+bG7KqzaaiKk1dniT0gTJ7IiRQ5o+BWiAztYztTWCZucDWfHNqzN/3hDpyLA
	OEMUDm3wVNR2fCASU3iPSUZ+0TUsFvQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W+qf+88G;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495488; a=rsa-sha256;
	cv=none;
	b=Cwomh+OM1S80Eplk1ldADKFcdIxQqriir79IxTjobVmonMUcDg3dXBotWq0eKMvFMpQgP1
	dz7YUdwtPVyqiEEAlc5rR1ljqCzZGZYTapgINMFScVhein9PXzhP7TmJj7N9a5EDFJH66k
	OKgLly85svXqRX3nx5W7AIFu1g/Ob6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B9A26053F;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FBB8C4AF14;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=fsJt5zAEw2eEDi6iToROryWEq/SVngxfhAH+Xo43G5I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=W+qf+88Gh3wR1N3femYKYrkk823LnAMllqkE2c1ZnjV4ZlRWcsyMiYYqTI7iBTz3M
	 FYCKWQhoqEF5YQ4RE/kAhV48Ryh0lb+UhEzcNIo0OfXi4FzpqHgBNzLW0XWdnXTWKp
	 jZ3GOnlu1JQD02qFgbAHq2T35LLLVCpx1V+n80FaG5KwISh2Rnd1dnkiS4c5UdLP5J
	 766UIltsYhqDoDbKE8YgO2Yob68GZMTtsKGirWLMceCIWTFO8hbCJQD9fVkJ1kXufG
	 184Tze/+3y03Ng1Yr3KI8wPsXmrJfzPiFSuR5fIcXFJcGEEbTJqCX7PE/ZJ91frZ9S
	 uE7p6WZt3ZyMw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E939CD5BC0;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:16 -0700
Subject: [PATCH v7 34/42] KVM: selftests: Test conversion with elevated
 page refcount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-34-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=3811;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6pnaylw85j3BLcIYgHosgn8wb/s9PyqYtCRO3fkeuNs=;
 b=9d7uSXIR13GMRPjh+TmDOOCdx6PPMo24uCms/AE1agpsQo1ZmzeyDkmoWu0wiTKIG7OEvcuAU
 d+WyOxQjRjuDb9W+mC59MnMQWqrkU0RST0hbicCxd9/HMQmEdy8QbX1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: uoogx7gkoiawopux77aqazo596u4igu4
X-Rspamd-Queue-Id: 8DA5D100003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779495488-534708
X-HE-Meta: U2FsdGVkX18rQ83pMpf46CMPCF0ue/XAmwegdLAJWxFJ76d+Pk7IgRFiEK/4zPRlo1HI4l8ufRHGfrFrzW9vWqLt4znkskjyrjUGi+fc6xWalPXMlL7TTL4aVbUkkAAApzSIJpSrfJDo3pZf8MR0+XCUjlfonDtUEAUz6DwtKloh3r+d3NYkF1kqN4LtvVdZP7r2irueGtlOerwo9ib6Xq9jJ3bIzGpqla5thl8dG/VEWLUifWMoM8MOobuS7f5fYwb+LMIn8cIidzQTwjRsyL0VxIRITszc9YIvRfVCfLxhnHVXE32ZpoUFylEiwbSEPeUZvcVi1VQsfzEYufNpUThRTXa8blk3J2jENoeSJVlxbomUuolbX8bT0XImVPTam2pkjF0pXECGMtEUGqz6S+XmEhU9xPLHjRk+ibZ7IafrRB7p4F9R3h43SuTQ6q4VPvuJftd4jESaEuzlxEDJQ2g/MsaOjgVCCx5++GS7s0dH0F5eYnqn/IzXtKZWzWGIkKdJiMegU/plL9th7Qo+C8woRU0U/GJMszjuOXQkw5RolTCYasJV/XYrErPEIoxcZhd3jucSLuUctv4mskzDgTpN3/IrXIiAvP3k/B15anjq/HpXbuAK+X3cBRAbXp67W3QPtx/D067PccC0tvC2oYZH2jrMxorAC99gj0RcjRF1YUZOUODsizPlx7Qn4o3z6mMPzVPGfWUpIk4ZAPVXNsGQNH+aMC9clR+xb7tkhd010Pfpr6Djhqd/IGlAX7q4AKpjfYNviG8xUWtnjyZZwbyB69ttri1D4vGBgjJg9mA6s36EtRKKB/FFHWKTcUbR5V8DFIzISrOr4oV2AzT7sqI3680sRcd4rIAC0xbC9vvm8lekyNL0ZJWCYYiDqBPv59PcZwnJ/toAWDmpOXjfBWofKo8wZ2SB3PI0SV6Bg1hzi8t51AHw8rPVxe16iEn+tVrk2pXHiVpStf3ubA2
 17LCAaSi
 /qdsGd1kS9VsAkmWImckLXJh0xEv1vnSXxYfE5vfUTKVln8Gn+acUnAfmG9D5NIEft10aGJJsl1lZe3yLu3FgDXn1yCZ2yDorBcEqWnjcvNqu9a7fuvBDExR/O++ZWroAoWVGKe7ffKekrUyQHR1tk5QGLscW1kCbGad8ON5xH6g4cBkIb3yme4RMvvUL9vNR8vg9WQZMAUb3lvI9DCXX/XnK+D0dAQSME8o8CDrkA4EymNr/70J4W7iU0Kl5XlC6MA4CueJzxLqDJkyme+dcgy5ELi5ckPwLYHTPXvdX8297Cxe3+Twm5+me47QwkZLHqorH3BuiVMzIeMeVSAL7PT7ngItf+fud3n49/D8DOyMTgqSsY+H4IgW5E4rk1k+JXhAlOlvqMuNRaapoatRXMyDlYmWWEbnfq3B1
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
 .../kvm/x86/guest_memfd_conversions_test.c         | 79 ++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 04e457409f75e..a4a9b4dd592dc 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -397,6 +397,85 @@ GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
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
2.54.0.794.g4f17f83d09-goog



