Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9664ACD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9725C6B00BA; Thu,  7 May 2026 16:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9497A6B00BB; Thu,  7 May 2026 16:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85FE86B00BC; Thu,  7 May 2026 16:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72FD46B00BA
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 371B0140573
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:11 +0000 (UTC)
X-FDA: 84741748182.22.6C80002
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C3E22000C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UNlqFKOg;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185389;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFQzWbeZTauTnHX/HSgaHOHTLHmGeGo/TRR/TIYst1c=;
	b=GHYA0mOE9K/o/FA2XGRVKicpkGAJXjqfAm3uAsdve4wB05LjuaqY0GDUcU0Zjk1zZRh/lv
	bDyn6B+k/VEj1WfleCw8nuFen2ExPU6y3382JcgiGAT9eVhooJwYSUorwUgH3x2ZkIlG1Z
	wcbcV+haTlrJDzlHcuakf3/SfG/04x8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UNlqFKOg;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185389; a=rsa-sha256;
	cv=none;
	b=2AAnx108pHo/ahAnT4EFhCtWVLxIwah+78oFtwo+W05/g5f0hNsdtYa+P58lK1HG7SWeI/
	UVy1ED+Cx5pR7pMEipKNVFZknWUf7cVxeH8DKkaK6Qefhn63qKcocHa+p9phbQQtRz8FT3
	ZYrqfAMaYIhKit6Kqg3t3fEab7LHUVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C3FA448A6;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA4FCC2BCB2;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185373;
	bh=zfDV4nZkXWnXZy8e7YdOI6gWyOMZ4XLCe/7kCqmTNLU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UNlqFKOgvJV0y3X9+wsqOoGrvfln0sIfFIS6rp+dDMs3x7PohNpxJF+SviCTjXsIZ
	 Gek0eHI+5ybcmUrNTmfznaDR+PNgpyeNOWfO+kDsXnOcpqMJ1k4AGECOr+vN2fhACk
	 FDHkpXY7j+x7L2T5vnQuFmXQt3mmuuPBAFgL0NWujdZ7F7sQ1bQUupIqk/+y3QEXmL
	 hLX3mICZI+9mBdf7S8EQyZ73UFXZN+pTXs+TZ0NFSc+JlZAVNZa4/TNraT/Z8TRXki
	 1YbBvCAh0v0ZYw68ZVLsuA2EHgSIg1YBkNb99afZZ+4woVVetkgQySJFo7R1aLy6vi
	 LKHsE6xgR1rqg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBF6CD3447;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:55 -0700
Subject: [PATCH v6 36/43] KVM: selftests: Reset shared memory after
 hole-punching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-36-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2491;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6YboUEoN1FNkEuAz1Rbt6iWG3XFdNoXIyLA0OoRsryU=;
 b=FW5T5m19X+5M58CPrsoz+TiCvWD5Py/54qi2D8+8h1xevW5f1j0FBXPooGL7Us4kf6PffON2s
 a2nCl2Ie6lJCh9XCzGp+BfN12eCmUVthquwJ4grscnaKAcUjS7yVGH8
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C3E22000C
X-Rspamd-Server: rspam06
X-Stat-Signature: xpngx6yhmn77qxubfijjnkt7tjfk9gys
X-HE-Tag: 1778185388-89650
X-HE-Meta: U2FsdGVkX19/P4LoF4SynHkKuCCx13jFjyUeaPOT2qCeq5RZucNI22DUOgC7cfsNL/uFdJQOgGcPWsCHzDg9oFeFN2Yw01sIPYZlx1tQflTO0eadSoQnB1xWMX6xLVw4P/K2MOv3RMkQiw1BVt6VCKYrhnvQfe8xhhIb1HKxTPBe/fbgBQymTHJKCzQKMRzIXTseKemKHoaxEZCwR2kS7HzeqVE77qQMxGz4b01s1bhV1PMZvKcV64RfdyDo0i0QawohNJLzXzDwpVgU2VlQxklqqMbYaFCXxtIJIbzbA3eOYO7H2CJjwvytR55DVSJPtpoowgt4SBtmBNVx55nVm3PQXlMg5q9TxT7odPkQIsV1odp6h8T/QrYCm1aMdPn6CQvxX1B9WnYWrZ/vfxUs/RxSrKpYhgfAzSQdhxVewdlwqaSUVDGtF/RODQ2yeN529HfJ+R3n0XJlNdxI2T3oS/ZkO6fjMN/7R+Oue3XjoAykLdGJcWoyHrsD3NcuzXh0jDRUgthmqfgj7hddseTtTacDOBu3r2YKYC0uoWOEgOOj/oZbVoCsIADjEo0PeW5tXrEV1GxqmXKtH8wsBo56ovqzMNx4A1qXL6f6ZXR3dW9gcO1DPImz7Mv2YYrSAYODHJeJY3kEuCgwUM2U3tiactQzNWUClkYwlm/LxS3aGaoWbafqQDf3yYxAGLkOvjdIlDwcXluOJJoY1tp0SzFyL71hNvG6k0qqpfzMVly1iJbXczaTiY5p/vmfxjDclLKkZjn1nmxv/+z5NiOzEFrznDOLET84XTO/H0jU0cA5ZHscXJvh0xAS749aZkkaalmmG9eWa3IjlBSF54su4vctrKhkE6ZIcirtqoxKEWYEuCiWg7FPNAVQS+HclE5Yj3vilXquk3pZ+WRfE/hJ5WKtvXM5R7KxG3ZE0QqYLBfRAYIxNtXpZJ6wbY1j0CT4WJxGMhiK+KX2rqYJ/8yAdY8
 9ruHeRhR
 P43Q8I++zuYSzBs60ih+Ho6FgAa1LOc4tUh6ATbbT24R3eVXiRjELNFDVDpBSJwU/BUU6Q36Grfuva6bm19Z9BjGsEDXYCykAlZ7FiB+qtueLtcnjIBbrDlZi76JQnfFPfY0UBUWqQlRMK7vAzB0JpzQJcP1FuzDKlH4HYAkVErwvkExfPo4QEg8p1CG9K0KihVS9BnPMEyX72zK3peZtCkWmX1G16lCLM+uoEOPJyTIL9vZFb1WD4MfHImy/pjXFKkMsf3U8VYz8JTsQUJzNFAFEARozelFJpJZRSPlYMWjTEE3qMGyuOuW0AbAeaK89w7C+moFBa9ocoIdV60p73pZAPlej/PaQzzmxJBiDviN6ai+9MGGRh5X8k78GlNcZh97ykbHi1xR9IHNETh5Y79x4aJLskzdckB7r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

private_mem_conversions_test used to reset the shared memory that was used
for the test to an initial pattern at the end of each test iteration. Then,
it would punch out the pages, which would zero memory.

Without in-place conversion, the resetting would write shared memory, and
hole-punching will zero private memory, hence resetting the test to the
state at the beginning of the for loop.

With in-place conversion, resetting writes memory as shared, and
hole-punching zeroes the same physical memory, hence undoing the reset
done before the hole punch.

Move the resetting after the hole-punching, and reset the entire
PER_CPU_DATA_SIZE instead of just the tested range.

With in-place conversion, this zeroes and then resets the same physical
memory. Without in-place conversion, the private memory is zeroed, and the
shared memory is reset to init_p.

This is sufficient since at each test stage, the memory is assumed to start
as shared, and private memory is always assumed to start zeroed. Conversion
zeroes memory, so the future test stages will work as expected.

Fixes: 43f623f350ce1 ("KVM: selftests: Add x86-only selftest for private memory conversions")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/x86/private_mem_conversions_test.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 861baff201e78..289ad10063fca 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -202,15 +202,18 @@ static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
 		guest_sync_shared(gpa, size, p3, p4);
 		memcmp_g(gpa, p4, size);
 
-		/* Reset the shared memory back to the initial pattern. */
-		memset((void *)gpa, init_p, size);
-
 		/*
 		 * Free (via PUNCH_HOLE) *all* private memory so that the next
 		 * iteration starts from a clean slate, e.g. with respect to
 		 * whether or not there are pages/folios in guest_mem.
 		 */
 		guest_map_shared(base_gpa, PER_CPU_DATA_SIZE, true);
+
+		/*
+		 * Hole-punching above zeroed private memory. Reset shared
+		 * memory in preparation for the next GUEST_STAGE.
+		 */
+		memset((void *)base_gpa, init_p, PER_CPU_DATA_SIZE);
 	}
 }
 

-- 
2.54.0.563.g4f69b47b94-goog



