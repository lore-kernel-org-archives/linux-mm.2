Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B676FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C7E6B010A; Tue, 28 Apr 2026 19:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD856B010C; Tue, 28 Apr 2026 19:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC6F6B010D; Tue, 28 Apr 2026 19:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5777F6B010A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:35:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E46311C16B7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:42 +0000 (UTC)
X-FDA: 84709548924.22.DEB774D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F1B610000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L4evB6Kh;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418740;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kE+ggsdMpczVbWl9MwZki+R+Yc2IjdnWHD2HmRzraWM=;
	b=n1PwdmOFg6nmhZRnx6Pzu3y/Nu/RxQosL9PMezZdQ1OR2fUyTijSVkvu1v5Gu4TfqVpji9
	yi1zJ/SpwyDp7SFMHIK0LBR5/21sbBfMClXpDzCDwvCHdE9lW7tfJMIj6oaPGUGO7+3BbU
	GuWT6t1nfoQIaII+fVTrOBdWFFrMzGQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L4evB6Kh;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418740; a=rsa-sha256;
	cv=none;
	b=Xhi+eFssUEL5+rMFbpo10VlZXXyfMcRfMcQzlOuDGGU1kupg/yy9boob+wRtMovfkShXlP
	V+W6WpTopZxmkjUJP1bLdkWbfvD+vqZEwmG0TBkbjglTumeQ3xsFNLv4shOfY7IAu1c3ZV
	belBq34BwjRBi6uIL60QHDMbsjL2hzQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F118544B2C;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB638C2BCB7;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=fi5qoarFijE2lWp5XxDoESzLwDXl1eAEmD22R/fPyIs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=L4evB6Khg1O5ByRuDGL14styXW8AJIiKNKNXoWZY9e310k/C1vn/SFuMfURWGVPFa
	 gmcf5CnqjWieP74atQhouofZc1jF9je/jvHIb2aj1JJzmii3hehhvgLLnm5sj0brlu
	 dbs1VTzi6/6YkWGIV7yKlsstePw0fGeyRcvtCTvXNaPoq9KPmTdISzS7P1goc8gLUS
	 G8OhlMs7Y38okfdUbOYcZt5aQ31hutAwW3ekCzM/0Z+Xak0kDlDBY1XWhlNWJQqq7t
	 gMFsCtoXPdhd8zTHv/g8h6xFzjf1B4Oex42GzYC+1o16QTkAzhBve/XweR6s1j956U
	 AuOFKb5gEIM6A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1014FF8875;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:38 -0700
Subject: [PATCH RFC v5 43/53] KVM: selftests: Support checking that data
 not equal expected
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-43-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2851;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=7gz8kf/n4ixOaF8MVfsAM6UcG2xye98XFNb81uX9/Q0=;
 b=K0nhoHtw+bHDcFt0NTXB9H8IY5KufQrx9yXWXRDB44IJvZWG6vgqoP88UFkyWNZSvMMA4sjKx
 IeEHazMTIeLBYKybYfkuwhPvhexJMT5hxbaymArE73yb7zsZfD59Xn1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F1B610000F
X-Rspamd-Server: rspam06
X-Stat-Signature: resapg8dkc9bzo9inx4a8ybexzrap3ha
X-HE-Tag: 1777418740-751120
X-HE-Meta: U2FsdGVkX19MIEHom+PELM0Uep4M9tqn4DWRFlHRB55MLmo7NukZQSREzxzjWQZS3Uy5Bf0HKmUWGEph6AhESShNZQ0CepvMkoQvGg+Pab9mN4Zs5isXFbvLTZ5+w0LeVHx64+mIQl9sR38o+7XX7lFdXaraenSzHkqV9K3x/pBtHr064ypqBTsnMVtRkpcI8jjUsZD8wjM22RhaM+k/Qu+GcJnVh2CH6lbWoiNvzB/hY5UAsWHovs8huUV+ab0GXvQj4oQUgrfQjUYXLzFkkxietvQETeBNwmNToIUEMlW/aI/Sc2xDdBU88AVgVhT2tcyK07W5xhjefmD9fWvrn4SA+W8PJwMWQfiDDBJPLzytXPBTxXjIrcoih895YuhJzmxxvvhf1CPl/svm6nC5sCTRSZcyqRWUsW+OH3sS1FoyJobBJ0Tnhe97AoFH8z3ruGKLhr0VllDjmiJz0UD21dfQAWUYegRmUz9ePGdbA/XOYi+Lwcf/qSPCnwvRbka284vU+IWgYvbfuA9VDTjBmbUUNRWpctdyGgQleTSYMHqWUehB92SOOxXUeHypyq7TE2UXJh7QN0UcpZRd6cRXorDs6xOYq5ddkptao1gIFmP60BrcfjnrY5/0NlfzrDB/E6m7SsHpz5W6vMB5jjgQp+pd87saKTlqbE6AbrGRF83WuAGWUDVKWk6Pc6MivEWtRHZ1pU7imKU9zNqTCJDG6xmjNqnk3CsgvaPc4Ow8BZ1lkATfwnH6wqNwaLjP/5jSDOz0skIxCYBwzE1JmjiORyYZL9ODOkCA14B8NATFjXQzr6a+1RAoONVc0xjDUWI0Snm2+npV31z0bRq9dn4fm6MNabR91Gez3iPPSjvTDJh0IeSi0wcZxO3uda17MVLMuwC8mIgoFUxDLQKXUjSxzavNTNnl8CXo3AV5LhAx5KXyj8xCE3KOTmzRP5M+N5Xhn1alNKdOKivLrIeWBLT
 e7lFVehj
 hgOODi9sPmiq9786yAV6/nWRVWdxMRMrUNl+0oR+52fTN7bhjjwmgmQSu3MCPgDBt0lRZTwFSeqGsBDrrOrDYUysEnAMJlwtmH+yU0GsxQPRvuAWSzbdEYhssSorm0oas9iGMahT2hVPOS4BvfPZnqCKFEuVexUWhPoP7NX5tmPjSePvut1/4+f7vNRHPrUty8Ncj7OcZZcAw+L1PvWypr7Pl1yqIPHf58Eyr9NnnmqSyehO7w4l6yY8Reu86FWlzhcQ+Gi2qvGc/pOC8KFnVNA5tFbah2WOqQl0IEN8ciHLrdaVIP9rr+qltdShJ/dJIr/ftZM53EShCO9Kip7QFn7V9ghYN9N7xka+fc3CbJctOMkrx3JJtNKny/iwEYAzH5pRf0PBEJqQjzW95WcxlPSt/q9Hin9SqpYzU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Expand run_guest_do_rmw() to support checking that data at given pgoff is
not equal to expected_val. This will be used in a later patch that tests
that memory contents are scrambled.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c    | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 922261ebaff96..57adb6d84a053 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -137,6 +137,7 @@ static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
 struct guest_check_data {
 	void *mem;
 	char expected_val;
+	bool assert_not_equal;
 	char write_val;
 };
 static struct guest_check_data guest_data;
@@ -146,7 +147,13 @@ static void guest_do_rmw(void)
 	for (;;) {
 		char *mem = READ_ONCE(guest_data.mem);
 
-		GUEST_ASSERT_EQ(READ_ONCE(*mem), READ_ONCE(guest_data.expected_val));
+		if (READ_ONCE(guest_data.assert_not_equal)) {
+			GUEST_ASSERT_NE(READ_ONCE(*mem),
+					READ_ONCE(guest_data.expected_val));
+		} else {
+			GUEST_ASSERT_EQ(READ_ONCE(*mem),
+					READ_ONCE(guest_data.expected_val));
+		}
 		WRITE_ONCE(*mem, READ_ONCE(guest_data.write_val));
 
 		GUEST_SYNC(0);
@@ -154,13 +161,15 @@ static void guest_do_rmw(void)
 }
 
 static void run_guest_do_rmw(struct kvm_vcpu *vcpu, loff_t pgoff,
-			     char expected_val, char write_val)
+			     char expected_val, char write_val,
+			     bool assert_not_equal)
 {
 	struct ucall uc;
 	int r;
 
 	guest_data.mem = (void *)GUEST_MEMFD_SHARING_TEST_GVA + pgoff * page_size;
 	guest_data.expected_val = expected_val;
+	guest_data.assert_not_equal = assert_not_equal;
 	guest_data.write_val = write_val;
 	sync_global_to_guest(vcpu->vm, guest_data);
 
@@ -191,7 +200,7 @@ static void test_private(test_data_t *t, loff_t pgoff, char starting_val,
 			 char write_val)
 {
 	TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[pgoff * page_size], write_val));
-	run_guest_do_rmw(t->vcpu, pgoff, starting_val, write_val);
+	run_guest_do_rmw(t->vcpu, pgoff, starting_val, write_val, false);
 	TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[pgoff * page_size]));
 }
 
@@ -207,7 +216,7 @@ static void test_shared(test_data_t *t, loff_t pgoff, char starting_val,
 			char host_write_val, char write_val)
 {
 	host_do_rmw(t->mem, pgoff, starting_val, host_write_val);
-	run_guest_do_rmw(t->vcpu, pgoff, host_write_val, write_val);
+	run_guest_do_rmw(t->vcpu, pgoff, host_write_val, write_val, false);
 	TEST_ASSERT_EQ(READ_ONCE(t->mem[pgoff * page_size]), write_val);
 }
 

-- 
2.54.0.545.g6539524ca2-goog



