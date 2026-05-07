Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A59ECD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37EF36B00B9; Thu,  7 May 2026 16:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356A96B00BA; Thu,  7 May 2026 16:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D7E6B00BB; Thu,  7 May 2026 16:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 170D36B00B9
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C19311A0615
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:08 +0000 (UTC)
X-FDA: 84741748056.23.92E3ED7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B33754000C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWD8PkVI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185385;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3h2cd71FbD85en/gIoliHNj8HEuZURF87Fc3ICWxAOg=;
	b=2yUdBcBUKm9wfaQl4lwl+S31COgU/hfZ+UnNepBAsOH3knjdBfKQgQe+9PDocef2J+LctJ
	WKvOHLKQbKjTHM1hvCdp62kFntXxiuFUmcx6utZEV6Auutn6h9dBVfcjX/uZejUy5l1R8S
	1OFUroWoc1l516q/WdTV9x0HtgfnTwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185385; a=rsa-sha256;
	cv=none;
	b=sfFC3o6HxN8JuLrynkH0JdPp78xjQqA67/QGrPUiV8N+5+WxW2Ekhd5BEpoDmKlHkUkka/
	1W8/56DMn3DiN6k9ceOXb990Sb10Ox9zyzm2mIGGou9N1OwcUQjU479bMagc4sGETBiA2v
	LEcV0IJGs5rkTutoKzKDPvpRXTmQg4c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWD8PkVI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6AFF4451D;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7204AC2BCB2;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=UO+BPNm5ytbZhecl+JRZhxEc9ujA+wzmQmLRWOcDnic=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MWD8PkVIVUksMEPnm1dsRjJC4wFq2gjDV24oU45FA6LClEk9VYf8D1tQ2UqPaF0AW
	 gHO9/YmK7j551zMv8XCmynofwxHmPLcXQftpb82Qy/BTzUGTsyQz2YRxWWzESH3zrY
	 qHI/cSC0vF+gq7u+60hS2bW6wEFBciZ3OMsYd5u5LiwxpoKs1OGKLHoexTQ1iUZUzP
	 YomRshI8GNhm0Rd2Iaqlms1eNXyCSLt6I0pFBM7MydVvNUwaY306FkWLDSLCqaLQQu
	 1ts8pJufksYhNTGxgQC+E4PUx0XVxm9VnwCp4ZysjgDhGs3Aw78EJZUX8VjBrJ+g6x
	 M1tuBIfF5Oxjg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E0CCD3447;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:52 -0700
Subject: [PATCH v6 33/43] KVM: selftests: Test that truncation does not
 change shared/private status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-33-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1978;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=QNfw7b73J7vj15/th5fWC7j7jqgWwkpDG4rP+UWwHUU=;
 b=hAKgjuZBHqtxWzkPWa8rgewxusBILrhFp1kYpa3PMkHdahjFtlh4RKgr1BvxX4yNiWMKdlGJ8
 89V/iDxeKTiB/V7JuEAGdqTjYmoNU/JCZmPnz/+yWuvyAbxZGoFCQnm
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: B33754000C
X-Rspamd-Server: rspam04
X-Stat-Signature: 8aswkff783u93aekn7815m6d3tdxyj9o
X-HE-Tag: 1778185385-844960
X-HE-Meta: U2FsdGVkX19Keyj6PUGuHL7bp6xAH0+XeXRKpUZXaXeVWeyg5OMqXNwD6tQ8oI1tBjFFiTb0uSjOQF6I6gD6g9Xxprg0H1a/mYG0pC9QGqvKly3jxfDRm/vBYkjlSC9psKyHX+Yhz93Ux2A0sTj1ec4vdYV0d04v5NW9V88n6czyw3TZGBZ4z3SfknYT38eYx3p8tHKGsIFyDexv2Kkg/7pFeQ4az50HS5IQpA1I58jtDMHnyQevjyXi66BaV+CR9HnxcTcxHxygDLsti+qyO7/K+6Xb4YOzFHyyVhJQ3snAAXyGyTGfebLzmNrqukbg5PR66A0l6D9FmyrufPOev3EtKvpcf5yKq6VP4GAAoATy7ExEIrx29Ng3eur7pUgcz14kr0RKlpPYDfYPmzyUDJaOVYrn04x4TQmEx1F8RTRlIY4wQGf+e9xDdoZz66xvLtBljmlfTsZF+OtQ7/DPvQjkuAiD/QJ0nLy1ybTBulyl7nRxCv4NvLLrTzNZ1R9y/xvfPa3M01U81aVfidphxFnx2eSpzsDbrwPD2yTWndoZOJAG8lgywtpqG1WLk2gxtqgespWDNL2LEKA1kvKqth1c11D34sIXjLDHri5rLPHMQOg6q4hTcp0Hpfh1f8zzkWSxFRADt1YU/ntQFHnmAWj0UdK9DRbl1Xrj4Fz6CiZybzsNhAD9JYT9+aN+VtrY6IEFKQIZi1itZAilki/gjyjkKw5KEDGWGOXiINdX/gbqrouAYdx3sx3wA0A7Tqga7yuEIXvAAvc15DE3747XTUCTAAhd20xVamLqQpDSY0f1xnhd6Z2YEBZiocOGBRtrWLV+JG0M0X9/WN5g0OAcFPKeaz2TrT7cN6jFcy6eCBHRae6JgDrVXqNLzHla2tWxXM4bo7+hILnioPP9/yrvMYwYC2NC9oSBGAspEqPzKpmDGnIiqT8xap40tWgb3GPW/UUevWEioRCG3ODUsGP
 1hLucYM7
 cfAix/IcYIDD5N8250bUpXJ+hL0QWTX0UrDmVjXjPpygcOv2k3EAukFUwWjvkhWzxT1oBf/v5F+/8b29kbQKRN4a57sZJcBgEymTr8zxZRg+9w9BjEswd9phNYKjKRuUSmaMHbgmMHRYd3601cyKlAHORWKz2+JWNOZ0cAx29MjmDJrCL8VtCpk2PLoCDf7piBENgvI3CauFOVXjg347PFQaeAHeTDAe/SBf1oNXmYjH1Jo34+XDVVgquaN/snsqEpQDGiz5Hd7jlGsU81U3KJf39QZhVAOtpr/RahJKYt3p4Ty4xkhu+cAjT+I0DbamEDqrGALTcTm3p2x7JGC66CMykUneIwY0FbMfWs9D2JzHxlLUveYbL/Gd9xhGEr/R+Zqtj/UMD/XhBnizFw0kO+b1Kj/u0ABc3FNDZtvO/FW3LTgckXZFGyyO9T6EyG5vNDCxGequld/6bp4Y=
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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c       | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 21d33e2814f9e..960b2da8dd16d 100644
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
2.54.0.563.g4f69b47b94-goog



