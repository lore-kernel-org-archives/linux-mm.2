Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A27FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6AE6B00FA; Tue, 28 Apr 2026 19:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A64A6B00FC; Tue, 28 Apr 2026 19:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370A96B00FD; Tue, 28 Apr 2026 19:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F10C6B00FA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:33:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 260BE1A05C2
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:40 +0000 (UTC)
X-FDA: 84709548840.09.3E733FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0E2A310000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVOYp38t;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418738;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsEUA4XhZAQSMjIqhNHdmznB/ktQmpZ3oDn6XqRR1o0=;
	b=sMRmiQ8cdq1Im4Fbsa/RTyWYTp/sBVKoA7SICDSzZiYwd5kAKmaQLQlJfEm0V5kKxP725Z
	YlwB/Yr/TxgXMpVIdkxGCFGoONjG68gy4SS+xbV8+zUPLgchE9XVWPZBnPejt5mP9XwXzp
	jJxX0QQM8emuShOKDo6AxNZbcEzRcLk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVOYp38t;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418738; a=rsa-sha256;
	cv=none;
	b=C3iw2AqFY6a/sZ3UPMazPqpynXCENAlHZ0n5KP/jZ57kJqCzFziZ/F2SQMzWAU2xMHSGNR
	h5amyM42pR8wWZ9zKb+VIUpIhtSd+sGWFSGsASIs2MBRrvFD3ToO4LvGAHxTV/yoGhVsnM
	/XZ7TOSje2uvgU0NGv4Tvvtv7fW9u54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A241344AF6;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D419C2BCF4;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=wdLoj8HH8Ns1xI8zoSpP1xSUU4YJ7JLqU9N7Wg1Hrz0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VVOYp38tDjUKY+lrdJC7aR7qz8kMFuqNZpBLzDkfG6IRhjfGsPWMpGGOHl4z77Rk6
	 J3sdvSPB7VUnU3vCX73wAaYDp8rsUodfc5LsB5r3/xVF35wBkBwJcdV/6FQupgtdBG
	 9Dn2XHEnTEfFJwAhaB20qXDXWUib5ZRhAtXzht1S8HQQj30ZPQ/K4MpmejzrX631UB
	 e4zHW2BxJtZii/IbBildVt5eTcQYlE1nc+mchzY3WalFToQBLRkP/W8Y3S9eP+ToWv
	 F5tQ9t/R1HNRc7sW2MSpPYUGLV787DrXs0Phn0kbDwl+pyRiUZzDhVf81fSZbuAebl
	 ifs0Ft1NbLapg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7229AFF8875;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:34 -0700
Subject: [PATCH RFC v5 39/53] KVM: selftests: Test that truncation does not
 change shared/private status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-39-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1978;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Bf9VYURnTgb4TwvCJyU5mwma0raoYBRglUIu1BddfsA=;
 b=Sy3fBvTvGT1l7P1754XNGwhnHr5V9qJNv9e3LC5taI2eQg7S9WzmF2LhNSMc6bbYXC5UjP7XV
 g61CrfU/Av3A6d5LctiXFLDMlkZ9ifHKNPN3O6xFeLM86WNKXhjnss1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E2A310000E
X-Rspamd-Server: rspam06
X-Stat-Signature: e5z35igdsac9ntued45ftngydqx8c3q9
X-HE-Tag: 1777418737-581683
X-HE-Meta: U2FsdGVkX1/yZJIGSA2y0JU9EJlReBGPnhE5Ati14IvhSAzAWRFGYqFVdOc1pTNvbOQee4wMu3/CrJFp6bXd1xK0FLZPdH3tzoTs4yH4JKDXT1cKIEO98nR9+tRxXjC4C6Zjp6iYyzhqY14Ek6GrTgFjOL4FZ8CMgXjjTMfWCF6z+21F/NkrhAiLGmXBRvsZFrJOyNNEG82LlDcyWGl6khDWG6ycK3S+MtmnZ2Rg1LMa0Axy0BITrcyv/XVRFSTkaRMDQm3A2MD59h8A+J6lRIwO9wn4oDqY+7UG9hvuQjG2mvehOw1gHnpcjQ93gSrXFUFvLfz+LJraSKWmGKCa+pZzJOh8cPoZqTZQXg9vYwgqz0RjIYAxlLUo7xLGebA0w4g4hhizSNq5GGVL3n6fXFCHZV8FbIgwCPlievMZineq5kJlNpZH795wxu3TqY5N/GKxdZWjbwzXFTjcNcuGYSD81QhPhbIJtvl+/14rNJnEqKWqR0xyN0Dbpm02AY+1SaO7wsgwfdM0aDH7hBnzF4H8dJpU2v5/VwrAd1oE7YDJruoLfUiUSGvB9p517iG+c9oo/70iC/AbgE9+NHLapap9EMHzkH9OZ0G5/4tUSYDCNKyCE29SAvIbKSwauDigpXvhpFBfpEshLri2s6w2eZYvu7/SfNONyC0YLr2lj558x3586Fnhb0kVLkVMDTU/6gamQP0ie/7ulJGon1RP8OkPlnO289C0jIJ5wB33fL89EMZT83/P3msriHFw2ujra4joiPugviA0I653RjEG3c5pf3Af7EuS55o1z9OydRA5VjH9fDyZ3vz5MvH+LEbDcj5WCzQXBzLeHymac0PzuMl93FyTbRiN97Gy76ZQ87RhuP9QgGW+CYqa4GCI+owSzGcRSaYELmRt9uPLTayZ2AVezCY2yYiEbheenL89ufyvCZXDiFKu6e7sWm74N3aTQbeiyf6kHnkq/lYAOmg
 jFVXEJZ0
 7tklI+ws2ZgrxFoUTmKpP4ofE4jb4O79UxSjA5qCrOB1kxtc6M9R/B6eIgl/wQTabbjtR7jFULrt4pbrFZWRQ/gZKxOmBFXyviVOVqkkQ6Z/yVHHA6nzynD/yLV7DMBTqVrHRdGYvKGbTFHZNWV+s+xUf04WwvRBVGaR2vLnlDP8KlDrgKI7NcIO13wImXrbOrZvZco0OHgzhu1HqBk4WjpGvGoinvkAkMvu4ld9Eo9XToW3jdDZAum+sOnyo70a/SwwTj54IR+bKMcj8pXQ4ohbLLL5dVQC9lLG0PiQypDHTZEETVqw07GsVh4RdwzEv3Ct21f4MJKpkzXHZdy743W1bwE293rSsCdqfozaqoBrC2JPax0vp4YjKgRB8ComlapsgdwTJ7oz2+SQUBnrIsFqisnv773aiekqh5i4SQuf6JohhgfQezhtmUOWPpkQI+KRnMeYXVQS7mL0=
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
index 2312592c4076b..8dfbf3630cec2 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -10,6 +10,7 @@
 #include <linux/sizes.h>
 
 #include "kvm_util.h"
+#include "kvm_syscalls.h"
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
@@ -320,6 +321,19 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
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
2.54.0.545.g6539524ca2-goog



