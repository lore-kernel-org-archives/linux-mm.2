Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1C9FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7697E6B0108; Tue, 28 Apr 2026 19:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71A2B6B010A; Tue, 28 Apr 2026 19:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608E86B010B; Tue, 28 Apr 2026 19:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 491006B0108
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:35:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF31E1C1241
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:43 +0000 (UTC)
X-FDA: 84709548966.17.443098D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C8CE940003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HcXbivY7;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418741;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEJ5aY8O09MpG7oLrzrjujBlbJBcdaeNzbyKlRHgc4o=;
	b=laqvSb5+pLV+9K13R8t8v9SVK2EHR1VhMbb1MEgfWlDoEczuwbZxxgS+7QRap6APxvXjmi
	aZDAQyhm5DaFBBSSDg0b5gBzzRZwRD6LwzTj2E9UYCdo4v7cfqt7uRfljynLdgEyrJzgJp
	UErp1qnKJaYn8VemG/TqvDaVx/Q81x0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HcXbivY7;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418741; a=rsa-sha256;
	cv=none;
	b=V1Dd1G3dNkPsZCRRp85/ZV8AIk417NWNnveMchhd6a768wqr/iedZv8Agrjfq6z1JaFwzv
	CGdd7xS1gZD2Ew0Zo5UtjMK88UIFLm2vdeMy0P6BE7o/aTzVbAq3qiPhH9UKjZkdt/VIM5
	/RhKaxgFYJFC622o1ApJcy7MV30RHN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1049F444EC;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDA05C2BCF5;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=Vgze5D+bN0AcyWszSG1YlA0S2f1gEtod7TQDybNpW/k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HcXbivY7zdv/RmF1UVmwhwUKKrjRdHI4Pitvra7t/6Sr8tS0A7tyunNzyMPwnwdRV
	 NZJmyGLoA1nSGDuCm6QPXSuHgfTrMv36avF+EcQe/UPPrfralU+t57Ny6qFLfUJXJV
	 7gq0aZ8pSdlm2k2tvfK34LKR5LzCkgxKmKGzU7LMxOTHJKZiHosi/JRdd8DI+fPpjK
	 q2zE2/eTZjQMkpg7v+55vBlah5Xqtua7lNusx2XZJ5trpGKEu1yc2bMMha1J0F6wm5
	 KC3OO4ja5fK8B+J7GV8W8GTjIoN5aRrcgcGLsNdBe8V03ZMpgInh1RPc4GckwbKFnI
	 lhUfIiTaYjfyw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4581FF8877;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:39 -0700
Subject: [PATCH RFC v5 44/53] KVM: selftests: Test that not specifying a
 conversion flag scrambles memory contents
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-44-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2091;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Avy1yjuj5TLXjW+gFYQvsB+PRbonfW+tVbhN8u3NZik=;
 b=fb9rZViAfwmrwJD9SGoXVoob6TT9WaSRJ4Wrr/TWhXnHc57g7FFxpcP7viuqXx3r+qwjvVnmr
 KXKhGbWj4CZCYiavrYR0ULbUfm3YqEoUTcfGzy/jE7G4hkJglBe7CP0
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: uhztq3qscee3djuoaberjakjhc7onnma
X-Rspamd-Queue-Id: C8CE940003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418741-66920
X-HE-Meta: U2FsdGVkX19JenIuKWpcsFDKBp6Qt+NnU4w7SWNBJb5olV5CayjgK970nVF1T+QFiOQj4NVEG1siSlHuknCOD0y4oBoYEjJmwaqEVjM1LYRYkp3vCUaqIAem/v6Q0pP7XhPcIJiyfZ5pNacmcLXIi/ORA5/2325lnFuO9qSCRBtxu8TEznBnC+N4/gNGGYagYkWqd0rFFKPdm2hHdvRX5wqVyncXS6yzDCvb34t1IxOZgtiPdocwnSP93KYLuO0grhGXY3LSDyC7v4VR+sHQ8Ws04KdrMxLCjGJ/sPi42iBBxnU1drrnJZt7Nzn9bk24QLAmkU7xxriLGBMc9SnqH0Ux0kClnTxCwv16E/otiRQMcXCWiaQyXEGZgq9M5tkUQqMCRIDTJEEmlh/ltvUIeem0VlLaUmEFNdxcTKyqufapt0LF1ayqFdnIaDKAnxqvQEoQnrC0NFRTYLym7rBgoVcUzUeVH+7EV1ICWof+Xbp4OmLCcITPgAEDPJwYGu2DeKe7srt4mQF4+tdg0xHyZ/LSFlqMtDuxKE6l2H0SjB0zXGoDkikUVXgM5QRphJ/fsNroouxeJg60vBz45dOnOsetVZxqUq//IiXEyY+Us8rngIjYxswXo1q7w74Wvk7zQWJDTQitO/W4ShxfMoPlaXrwPT8ZiqzTib87P/ddGLJS6706ua93Kp9vyjRNISLzTDhxa5puqPIFSyOkBJlcQ7FJsHhEJtA2KXo7uvS0rW6mTw8rWwWVqNXoPD/6FewQgycf0Y9afIeOvkC2FVSaUrW25yMDLsI3kKj9EzkkqyBUhVcOSf8D0zSw+UwM/+iKu9T5ZY6RIs3j/dQAb+ZvlwDD9CuSJ4wpZA20TqLGvoA8oKh0FKity2ZCWgooUGb1whylGuRD0Au4YGrfoz4TbHL7wN2+V0GcpVJx8RI1Ac9a+Gn6tXZuRy1Su9u6wc5Cbpxg9LYTQLM8mUgQI1d
 SeTwqnpA
 g7/ZOVufpY+nfN6EdvTv9Mr8s4PUjsjFBznD6YCJ9TGwGYaCydat1uAadGOeV0L6ZAas2N2SR+sksixo5Q3xjSjpbR4WKVOV2SKRuIjwte9k6xCQpO5hq2wZLR53S/v7Rc6O/1iNbM7IB/5wyH1pD4QazBR37l+zHvTEAs992mRcDdWmo2mtsmFnMulePPcD4Z94/t4/xfQXcphAsoe7/vy86dHaOQXE5pNbPzZWgGX3CMiaoLYGN3z6qnegATPQyOL0Kxc31KXJb3zs+4/qv6Rr+aSyummd13UdhjljzzbaQycnL4fwyMA7rY8587QMa5Kv8N8zi5f0WqOOqRvMKO509bmWtu33TydAZJLEuUL+zf04ikmPmWJZMG0qqGqxfvWAlOEpVkP1rnWJK7FYoQMP6ZHICIqdi3W/s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When using KVM_SET_MEMORY_ATTRIBUTES2, not specifying flags for the ioctl
implies no guarantees on memory contents.

For KVM_X86_SW_PROTECTED_VM, this mode is implemented by scrambling
contents of converted memory ranges. Add a test to check that the
unspecified conversion mode was handled in KVM by checking the expected
behavior, that existing memory contents are scrambled.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 57adb6d84a053..f4705dc700879 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -512,6 +512,34 @@ GMEM_CONVERSION_TEST_INIT_SHARED(convert_to_private_does_not_support_zero)
 	TEST_ASSERT_EQ(error_offset, start_offset);
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(convert_mode_unspecified_scrambles)
+{
+	loff_t error_offset = 0;
+	int ret;
+
+	test_shared(t, 0, 0, 'A', 'B');
+	ret = __gmem_set_private(t->gmem_fd, 0, nr_pages * page_size,
+				 &error_offset, 0);
+	TEST_ASSERT_EQ(ret, 0);
+	TEST_ASSERT_EQ(error_offset, 0);
+
+	/*
+	 * Since the content mode 0 scrambles data in memory, there is
+	 * a small chance that this test will falsely fail when the
+	 * scrambled value matches the initial value.
+	 */
+	run_guest_do_rmw(t->vcpu, 0, 'B', 'C', true);
+
+	ret = __gmem_set_shared(t->gmem_fd, 0, nr_pages * page_size,
+				&error_offset, 0);
+	TEST_ASSERT_EQ(ret, 0);
+	TEST_ASSERT_EQ(error_offset, 0);
+
+	/* Same small chance of falsely failing test applies here. */
+	TEST_ASSERT(READ_ONCE(t->mem[0]) != 'C',
+		    "Conversion without specifying mode should scramble memory.");
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.54.0.545.g6539524ca2-goog



