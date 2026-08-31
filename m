Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3AF4C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0006B00BB; Sun, 30 Aug 2026 20:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782576B00BC; Sun, 30 Aug 2026 20:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622C46B00BD; Sun, 30 Aug 2026 20:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E76756B00BB
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 756C2C0395
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:41 +0000 (UTC)
X-FDA: 85159671282.17.4F9B616
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C84220009
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LKiRnc4Q;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135939;
	b=mR13J6G6d3qvtf/WbR0Em51X4OllffejqFd9CoJQjQn49BZIFjZ3U8g7Ua70DR8+f2Op3K
	/iXUmcn6ssq/43QhA7UaK9dRwSWBx9IgChYK3SoE++qaX0hON3KMWbrjoT/+XYY+qdCWkP
	QabJjI7AZ+NvHkA7I7k+2AKjmCgPzcY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LKiRnc4Q;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135939;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMBSoknUEFfWJky66CwC2egYxZ5g2CkY/JS35xKmC8E=;
	b=x/J37vI6RgZiEpwzWOJ94W5bpEafdYTyOI8TMaDOJ/SyIjXV+1iMpyUUiX5ZAC6yQhTwaX
	+8mrkd99ua8m9NWM0GjwvkUNW61Fh4gdDCui5WNsSFaMDnmpSNV8TZWvMHazKnYRT4JahR
	lt31yV4YpSB+Vnlr+9VEJzm29JOaHGU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F05C44983;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F032C4AF63;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135923;
	bh=xJxv/ExQUAEvw7T0RAQG38FUrG9mFWRgWPRG7f5xFX4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LKiRnc4QKxQ40mY/5ieaFKg89gjw3u53hXQZzCyfxjPIGCU5oxrVSGCRG8U08s1iy
	 UsXe4Vx1/kVtYyvmeIefrLfAilisshQpKP9/EZbKS6Gsk+uaj4qkn6aThd0p5XVbuK
	 V1inqUA4xGFHFXV6u5MsRI+oUi5c81lwc8MisQEBqnohsc6QMeMTCpkO861mDhXLfW
	 RwqY4PFBtuZv95/JfDUov/ws382t9f2h1mjHFLix7Bnqx7M7HuTMs9+Uz3p+52OhVB
	 HIkdPkOsPo+wvKw+fxpLNXfMSxnm+wfsn7BMSQqjlURInckNXFEJs3rxvHQcvXRc6f
	 /hsd9fIjXRo/g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECADC61DE4;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:36 -0700
Subject: [PATCH v12 35/45] KVM: selftests: Test that truncation does not
 change shared/private status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-35-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=2066;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tNExLNWLFDn50j0RlKFtcHpdRLOf4T07FWqRSpyOYNY=;
 b=YUToXWIB44Po+fdLbmu0EdGYzg3DMaTns2uQZw0fL0Iq2D4zUBQHSEZYILSpCQ07agH3oEiZH
 gxvtPHsPUXzBhBletXy8wcGKYoBB0+IOFC/BYas0faHs9bAX/B1Cgz4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C84220009
X-Stat-Signature: 1exk6ycwh1kd5r5pzpkuunk68tg4q7kw
X-HE-Tag: 1788135939-19259
X-HE-Meta: U2FsdGVkX196w7AtCt14tUCO/QX3VMprZgdCTRjfxkyGzgUciEHDeXUct16mhws9t/0nkgsDTsgGjilTKB5lUaF/5HkZEfuvGDArFiWOMGAukrALqWAF5xU143BNGTBTFbtfc67d+fYqJSe2PO+EYQmAOOZgSTt81zMZUGEBxY3kauBZrjJO2I68lDnh1QwxjHuZyBzMulpR9LSerK8kRAQ+ifGJO5bNhkUchp8MrmML3RswtuHeHEWsYcfDiXTwhWE62dFHbWFcXGtDWl2QWqw70/sJpMwTejojuv/zgYowTctf3zK7tfa4YmPnjc+yT8a/fnGLfYi9w1s0CYDdZzkrF1kN95GBQAlwdP1YJo9VnfAgS9S2ht9q05nC/HFhsKove99GLZMg7blcsSvv+miyz5w+hS1Wl2NslhJVmrGMbD5NTF/i3bsi9/y2DGUV2DevxWzP/llv9NgkXJuW5dttA3qUpJ+J6e7Zv5/Y5qQTVipnw5C7XCiFBGlQGncz7Bi/h9rPvptm4FjJ5Yy+qGyq0K6I/tOm1LJN2Slf68tRYgHhBfqEsnuHeRGW4Od9JlcZod282+p17kDHhfawwlKFQk1UTJwvuN94wnJIJ9ScxRqSK3Z0V9HYEkFBY2TWNTfR5r/GVHUwllKHLrUOkbqVqihBja4tlm825apOPfuAJ8bnJGJLLY1Rb1rupCSMDKLAHOo+7dGaB5JyyrecrhGnCK/cJIprtiG1wFftpwt7G9lRgB0Weq0xUB3Omt7hVeVBUbH9XnMoZvGI8xfSCaP/HTud/Kj94EaB5DxNiPZ8G6tWPCtjf4eHY8viCdvckTsKVkvD7LyrBTtSnvlpRyGLjiNClPz5nq0gikS4ldizu+azyB1N7OVvVddLfIcLUg3wWqhJD2mFP4kOZY3bHgmHafGdrHynZaniyaepNiK404Eqa0mnizZU/JVtAGw554EATns26jje6W/2UzS
 AWklke/7
 GgXePSQmp0F193SDQDVU+BZDHvGs+AMqBXkxD8Yu5/2SzLGVTV/GcL0OwT3fzDPsIf+4OMt5COrEsSPgADfqm5tOVdtBg/dVeMKKwKTHSwiv24EbqLi9snPWFB3N0ib+lQnIJ0m2JMfjGTD6Vd3gyhh4zZcbexdduLSGd8JsifvR/O8wb1kf1qHoXoqPtoVJ6qmKvduGseU7/enrUBC0qpKvHiBu6T9VSA0iVul7tMWSUvjmXmq/yzp2yXkuQ/GFJ9qx8bDkWEtfQgDge1XCMnpyA7FXs2t7vVd47PZBq7iK0iem6BsHrVqpf83dlcGJP7pW+/55dDsDm0UwWUHQnke+abB+fWV0HXxrTCCMDR3wcZHCq/hrIehJI3lT580tbVz6YL+GJzfG8vIYm2qgF9G9OalbudNKRJOicktnHvzFWV8TSqZISAtRyv4LDwiwPZu2Al7OzpEgYO8heOABQJ+3g5mmVXLUkt0il
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
index acdff2d154046..b7a54d2a90928 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -10,6 +10,7 @@
 #include <linux/sizes.h>
 
 #include "kvm_util.h"
+#include "kvm_syscalls.h"
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
@@ -312,6 +313,19 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
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
2.55.0.897.gb25b4bd76c-goog



