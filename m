Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC0FC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B565A6B00B9; Tue, 28 Jul 2026 20:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EB36B00BA; Tue, 28 Jul 2026 20:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1CAA6B00BB; Tue, 28 Jul 2026 20:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77F2D6B00BA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16B64C040D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:24 +0000 (UTC)
X-FDA: 85039945368.05.2E1E7C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E28740005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iheZNw7F;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285322;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8J1kpHooJ4vUPNSZuIv6n3WufdmCitGudaPHCuw3D9M=;
	b=YHK2EzhqlbA34A4sqqvlAvvBcTfwDIZmhjMmxIslNkastKWST9Tpfvkxp4NAM2A7jQd6Dt
	+42ySXZ/0Q/wStjIaWDocE6soUjmZGxfy4Hcte6gTMUthfFOSjAkztJqyDw4BV+GVAZH4Z
	otf23OkEst5xcSqfFiib5i1mvuESEVQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iheZNw7F;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285322;
	b=69lBL41sDQkCCqHOsPPGFdoMnLz8BehF6T20TG+oa2YFGp6ErsJtDB2rZ+kLQ/114NolTg
	WMbaSOHn6B5uwguvat8ypFuM1vJTtIEnILMivTr/QY13mOGLuToJl0ek1PUWildjeUjuMb
	HhhUUDV059HixnfG8NdEtNxfusrdlow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2AF8452E6;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71964C2BCFF;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=0lLMZ3l4ONPeH/mKx7eyUWm+z+05c4Fp5tdDO/KS1c4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iheZNw7FBcgaVAEtIKqx838Lb9cIsu+GY6a92i4nlfYWDjmDRjclVc7hRMW0EFxM/
	 6xwMzfXL8d88R1c5jDbkQON5Ns46Ug47OOgwbwkss6KGWTzbFuL1G1/v4nEHrgcdq7
	 H++VkmBf3XLIUn/F7/mHYxZVmNfGDVbiwmYnxtPNaVrCWJ71whqmaEcgUGB+gKDAw0
	 893N9APLiUFsWhf0CYq4FSsiLkRGSCpsDcwyZqDFAGw8sfDJO8ssqCZzVAMC8sLky3
	 atiQ4KigjeC2k9diAmajLIWXEK9xxyBQtZxldN7TfyhY/Uq3dqfiqxB434/IzsOwTr
	 0eFRjHJ73qrXw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E19C53219;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:31 -0700
Subject: [PATCH v9 32/41] KVM: selftests: Test that truncation does not
 change shared/private status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-32-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2066;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=eiFVWqnVQojfvRcVrcUK4b646kY0rLDrJ8WTD6NqgBE=;
 b=jktsq23A0PhJBuERFdfXmG/kKbsDpg4E6aQyM/ahLawz08jc8lNzCYOK5R+CRVucip2wVlrjt
 YObEWFdvfjyChLp2x12qNA0p3YU56NP5PiYQ5DkwxYoTwLqXy4C/o5I
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2E28740005
X-Stat-Signature: 9yjtyoe7od7doed6gd8s4hti86he33hj
X-HE-Tag: 1785285322-839360
X-HE-Meta: U2FsdGVkX1+y03FEvJQO9gPkhFHn3RG+xjoNxwmMG5nVkc3pviVu4X53rIjJ1ip1i6ZyZnAemPnAt6Qe7GqMFxk3MVctGd/lHsiznMDL9a3H3BZJR6/ARxsQ4IGBfN7C3psrlJKMNlGwNlnemyWzUL+VaObq2uGwc3vtiJj5cK/t0HMxAu1kS+DkOQjiVSZnDCkbktZowADqIliA6qiwAE9JbLYDAPWdeFi2RSi8HkwwveqrFB5q0ZbIRQg2CazdTrcRvm/9qYAvcndHD3BNd7p5i972An/CAqFrG/zTbjcoBIVZ/dVOBAWDbqu6VbhqAshwcs6RJQ10liVFlwSUk9UfJTd3WmhwV4k1gY616ybaQPTW7O0wKTnPCXxU/7pB+cAoFpySL5z5ieZ4c7iGUQ05fBZTleH9tNEq8qB3pIkZwb2jlZ7WsxOA35UtmPNwQrYaPU89YXTF+/7yO2OrrkX3yvtTiyAto0OK0Nl2s5dfedDexPqVIqEU4u+g6NcdnW2405kq9n2sdZOA2eHDIgpZKnYEevWlbqMvP8bFX/Z9hdU6/kTLV87mnUsuEJl900uOET9GuC96qMzperUnST+c9FB5M4/deKpvR6RkDPrIRePSv0AVXCcTQNb81mJotfL5JGm7MPvepMJWyf2Rr+r+xsxgwJ4PQUTODM+jP9xvmb1nAycw0AQn0Z9m/SC3SGAJJrWBEHOK20d9rsSBp7HQfy5ke+UyqtDEXCQ0LMXP/WVfMm37vIxuXeWazLv0YMK6H2wcvntcaazz9toQN6xRkNVsQotddmp1LyuQixlwGE0xTtQUJPzZx/bwnuv7XfXvX9qkFuvl0QCUiRpGMUbZwwm3QBGDGGmvLJrIZps5q0wg9tNM9JxeyqShWslos1Eat2L2pUfxv6aYqaBkCHuXco9CxxKrQR8Rv04mt+W82+p1PQDc1RqX1+hmGVxaHP1EO2XOwBbXSMz/zR8
 zDTw2PUr
 YKIZaU9pXxIgCqghTyS5pMZRjMKYLuKjL4Y8xdpmi3BBoXufK7n8CK2knIQ+yh7shDMaYfuuKBn7udafJ9MIonLF/ynu88YhBITehvqDB3qKXT5Z1u7BlYqam/PPVq1mtYv9OU5YfzX+zQsiHiVRedN0BDSnsCVDGQhoEfQWPQuaJ/vMQKXGIbe87vT2uIMmGs5ZpJBAmz7TG0H0IHyEqO9bwalguAc7TemAbVgoErC2tPKOUIzznMCX5xpbcbFeHlU97bVFOjn+gWrqTcw1M6kjs4xiUbbfpcU4xsiwQES88iZ4SY8KwtHZnbAI7lpIV+h3hCThNp6DnkImlzUb81tAVe0jeLvHtLoV0g19pFc23449VZyDl2G4nhCpizaA1Fenc6D8lqK6vE7bLeTQH+Kd9h6F3SrNisLbNqmwJrqKBQUuqV8v3EESSveS4JxU3zc2hmfvLAC7xBq0ynPjjZJxlg831La7xMpfWxijZA0X+4xJOFSdNnvUmGQVAdjCL/XUlzP6Wf878mq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a test to verify that deallocating a page in a guest memfd region via
fallocate() with FALLOC_FL_PUNCH_HOLE does not alter the shared or private
status of the corresponding memory range.

When a page backing a guest memfd mapping is deallocated, e.g., by punching
a hole or truncating the file, and then subsequently faulted back in, the
new page must inherit the correct shared/private status tracked by
guest_memfd.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c       | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 0b024fb7227f0..f03af2c46426f 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -10,6 +10,7 @@
 #include <linux/sizes.h>
 
 #include "kvm_util.h"
+#include "kvm_syscalls.h"
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
@@ -309,6 +310,19 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
 		test_convert_to_shared(t, i, 'B', 'C', 'D');
 }
 
+/* Truncation should not affect shared/private status. */
+GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
+{
+	host_do_rmw(t->mem, 0, 0, 'A');
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	host_do_rmw(t->mem, 0, 0, 'A');
+
+	test_convert_to_private(t, 0, 'A', 'B');
+
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	test_private(t, 0, 0, 'A');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.508.g3f0d502094-goog



