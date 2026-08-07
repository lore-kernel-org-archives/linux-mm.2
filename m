Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04735C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C7A6B00E3; Fri,  7 Aug 2026 17:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8956B00E5; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFCA6B00E6; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA3C86B00E3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36DAD1601DC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:05 +0000 (UTC)
X-FDA: 85075824330.25.A57A263
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 37B2F40003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C/uXXcJT";
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139583;
	b=rMm/PKgp0j4/L2cqPgSOVTEvqegtmgbP9QCxxN2yF5L8aAchkWIw3hDr9KKkdLxN7W1gGV
	vygRCaFcUOfRbpRK3GbNyu/XX78SwvAoPFXfJbMK/H6TZOgcvAIzkPrWuNTVcCABVJzPkC
	haMfijySfUok0htIemLCiNkpJti5Dfw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C/uXXcJT";
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139583;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPQlSPqj0b2U40ONQPE4BKKxCul0TCpfz1uWLrVTPYo=;
	b=xQX3ukcPAIQdRXtqvG+O9zvURuwgSqsscpMxoWpwMFHtskZkuj6plT4mHfhVwFR3Xx5U2h
	SgmI5eVN+kYo7s8p5Rymh95QqlK6JhCgf/e7V2Bxr6sOKk4fO7UVz/aeDCq61jGvxv+6dt
	eoHH57uZlU72kvPptk2GVLeDMm/EIm8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29D4644F71;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0BB9C2BCC7;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139571;
	bh=oiCZ15D+JnnSDHZXHJ5SlW01WMugZzVHBK5KAb/ZX6s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=C/uXXcJTcbnMACVfng5rwXU3HeoIRTD79pAMiPUuSq7lRPyEE6FFhjCpsV+YHGO8L
	 5PIJXUY3a5K26ztv6MdTjrGKXnLqBYbJB4FRFVKoA8g9CY+/yLtJm0sWtefn4yRQ64
	 VqCRGm7XjmvGK/NNk+Qih9MnitSbm0GpxDoT1g4UcUp88XAkG59p4J8uW77E19dMsq
	 kk9zy9DbmvyHneQw4nhR2he17K8oBs6dXtouaN4oHRSVkSiV8dBsEWGC9I5jr1Ietn
	 7VZAbnI65b26y1Oq3Kyu83XcsxhiYriSwzjdsWopjU4bIwz3Z6uKB8sOThCod8Ubqk
	 hbHdn5aB6M2vg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAB8C5ACD3;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:11 -0700
Subject: [PATCH v10 32/41] KVM: selftests: Test that truncation does not
 change shared/private status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-32-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=2066;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=XnrrGORPSG8J5b5Yy/zf/neukgQrtYTrJSAta0tG4eE=;
 b=dXcTGNf6P61ZUtYXmAhmz6sqd3ry79tRyeA1zpGJGdnTisGO6IFhUDrktN98U1VNcfEgBStuj
 Uy3aUtM/QxdAt5XSp/kGzwFm7+XJeSjDq9ym+JWPxai/LrpuBDi+HQ6
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37B2F40003
X-Stat-Signature: 459afcw14aw3k1eo79xwpgkjk1q5fi1k
X-Rspam-User: 
X-HE-Tag: 1786139583-105498
X-HE-Meta: U2FsdGVkX1+vEFo+aEMwI4xxE4G1BAVQAYdV3OYgaGU5GRFGGVCAzrPMEyb/Z0T0SJHFc7BC7Gqil+gwtoRsnp/R26VkHkAb2nesgUHgf5MXU90Klpq1iJWOqkrwu6wa7pUsDEkKY9KS1pqpPYEpyE0XxoCoRNSfoWT5dEzRgQJIeRqgua408SHmCLmmj80pfxVwHvVe0VNVZQVAI6Fo/lI6v01a2qhJH8gDM3jqnQ5LC2ce2udB1on4mj3/2t+PJr6wjnnMCF25ANQFovjwL31ajHoNzxULITBhsLnLK4nKC2Gm8wSlmPCdK9Vy2dz7G6GOFVDpJFc4x+YQVMFpGkBv6EBAacEZSj9cmXKfsUhSG4xzwxyMZhYPupjh5+rEKZ+PwOVNhfrg6CHCMCY+5BpNQ6NMpbT3ShZCYOlov21ZqmA3B2lCmARgeWdLXSDm5LsM5RASxQaPrcAuukCLQqXBB7sQ5tW7nxn3kAZSNpNGy+Bv8dVXXwM/F6vIac+xzKtVIif7lxin8wgbDs+rQ8pZ4K12fvYydtwFq7LiUt9Z8kiipBLNF/F8C9Q0PwxEjxJUrXTk35ys5XVFWo4TnZ6wP/7bWTjxUMXyO8zZhKAYz1tjBYZ/oB4vwrwsHd1DNkFDTULu1VccW26NbGPvO1WJYHp6GsA914pmm7z06hom7iqbO27uT5luiK0oepKzo8Df+rJU4trl4nKu4E3cOL/MJoubRFtn27ukr7AGFMBg2xT8q0UTMnIBmzVlcPtrsPJjDocJBPQYj73l2BpWYLPzi6tn0sO97qQIz5eBwq4tQQPqKuxACsFbz1BTp10TUi1DxHt8jA/JFNfZTxQt11wlhaeOpU0eeDPfMbnE01MdVfZNmo9wzrUlDMzbyILUqyMp5/fAwl3pX6OYs0LerW9Lum8abnoF4kcf4s7d9HIG1q+FZ4pTTFGeEOGK3VDy5qp5sopONHvJ7fZxhuD
 6oQBzY54
 3F6vRcnSa/8UaCnHZK0fz5gNXX/w61bREc/ypw26ifOWODDSwgeWtKT3FnYBzkhlypgW75I+RjGGBL4wP+VSBvDDx431p//qe52+8A678C4szfrdSndPQutaj7yisoL2zaa9aITGbZAH2emXEP0GewgpnTx4nEbNx69cMF532e7YYc8P3OutLBPtTDmVD+/Wrbdx8PqMEm4URNn4cZgIXlhIYFDDBtsnWZizj1JNLy2Xsl86H+OXtTh+oQj7SejOr5MAOxIUJXtvRCK2l9PZE8UTNVeI10eeU2NOtAPAeFupC4wcxScwCuQGt0xqQ+1gmsj7NL3cSbrsCdM7GUf9P4EwMafebtNWQTa+rgy5CEdh6cI/webFEyzIUMN4qsY7Gus3XQ5oPnh/Iv05n8RS1wdRC3aOggVceN0d1Ex0ptt00s4ZtSQmvEB/Y/TJ3LuLBOUj+RunYFhUlWmRRq9Mmhx9TpCQgJnl1sqzJxVdihIdJLz285/Hm8CvOKQlNLdPbSW/qrQyPVkBNPDg=
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
2.55.0.654.g21b8a5bc05-goog



