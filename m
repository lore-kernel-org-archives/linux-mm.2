Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23790CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986996B00AA; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE306B00A8; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA036B00A7; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 363B06B00A6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F26381C0709
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:09 +0000 (UTC)
X-FDA: 84796772298.19.A197200
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06DDCC0004
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kxi66ujW;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUdXnYjaCSqek5EEDdhKKKY+KwNxWUVCDWepeLS8ui4=;
	b=16kvIzAv46zklF5D+iB4DZwub9V9olr0/4Z/H1ESFFDcQreptjelN1iOfUeykzZG5+v5Sz
	wEKi3UtDM+ivTYS5HJUjThnoS0tVv0maoBgYCk3M2miZbD+4W/wg5l8go6H6Xe67j3lL/I
	5l6NVnZS8ghfDKfxbsqHftmqbGVsUq8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kxi66ujW;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495488; a=rsa-sha256;
	cv=none;
	b=u+3gokUcqZg1mkwf8KqwJK2hpiONNkwiYwvbP3cQSNWcwgbqmaWccMmLB7r6vGL3gwJpnj
	5TGChJND5p/3j5zs55slWqX30hlJs+d0x/lnXL8IzGf0PRJesQc0j4msIKEAPUE++3xhmh
	Ock7PGRfIhKfsbihBaAoRAYkbgh+z+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D76C960514;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2098AC2BCB3;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=crDRVHQ3NuTmHMnr4j9stjQP4V8d/t6F5lEXauI4gZE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Kxi66ujWf084q+zbKopuMWkp32EBEllWV9e+zByWiK0qTQMcCnzMIxQghbuQitRQ5
	 0WcvVTsX/NcxERBzLOgZ+nMRKW3oZd5luCKNe4H51gSu+GmxytsETNkRVu0zQuPVUg
	 rhLGFG7oGIfFGu1zfzoXesv23VBS8ePitYaaBVCMOiCfgJ0rQcpaDAk0d6GaAfTQUb
	 9GJ5BISSuQJIuGlhpE4FzB89faK1gcprOADXk0e4x1pqsTp61UqdvS6kESzRHfQukI
	 k4Tdf9vvaetlqlAxs6pXfOhil4RMTZsSBd4ntbu8fmzkxL91GjJybk/Q0Z4q8GQSzo
	 CNUYwz/Au5kqw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEEACD5BB0;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:14 -0700
Subject: [PATCH v7 32/42] KVM: selftests: Test that truncation does not
 change shared/private status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-32-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=1978;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=A0YqugQfWPs0cOb11Bo7pPkLbTJzlslWehe07ov/pus=;
 b=UNxP24AJ1RXTn6uTmRSP6gbZsxB/QRdwgEcS+Aru87hawxU92UxaxUVqesNNFUrEU88+aZuVm
 CEG/atzrgvPCRHtqeIUYAQlyH07b7Sz4z/7jIPri7linmtNAeNlXc1n
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06DDCC0004
X-Stat-Signature: gqkgf959ru9mytwy1yz8rx7hadinhr5w
X-HE-Tag: 1779495487-823559
X-HE-Meta: U2FsdGVkX1+3h7yy2f9oDAGghKBGJfk3uLbKMnaPxhOgjexvzij4e1KdKsI6nfRnRFDvFigF+7nRu6fI1AeBi/sbkgJVIePUsb47jQLsOvM76w+fVa+uDFn/7JBOC3iKzmvzKCdPfPQTH68CjkQ3S4OkYenax1S6NE08PnTZhaeOYe0sqtysubaO0fZ0rZvG0UE3hh6IwB0OMS1/Wc9mNJLg4vCpC8Ti/3+FXNXgBuDTOkyJvUfXgSUyfWEktrRSAJCrIvefFXe+RlXlvMV2MaLASAyAR6bRQ/hBOb6zd9taI10ZJIW3zylz/53G+dI8Ny8cFgt+rJ4sR8CtnCP0gx0Uv/eMM43QHsDlnFPVCm8ORuRQlT6hkVAp9aQFW8c29WalhneejUFLPHjZZViSzUxxu8CkxBX0MDH9edIzPjYtEnuXwQq6WDfOdbKM7fmCgCO2OVuS6R8qjtuvaEb7LRgaGEGdxg1hXhll8THqZcbSOEtf14P2AHnowBrueHfjJD6Yny55Vb3Q3VOeXIevhqbLxAzaIpwE7EiUloycHIgqsS0BzQrR9E031XnZ0ypLd8TaC+K0uaFZq1LTLjITLPtJGS4Z5r8Tq5D3Z6EoWbGCDhyWHQlMVhnUdBfaiqK7hG36o0+dfSAjfCJ8XRSRAAvSNTExQeAg/5FjHExKDoMHMMJgSuPXHP7hEvopnWf523Ar7xZVVacTW0OldnG4jPG8Q8dTX3cqFoZ8YSu8VXOVK2i0k7aLC+jPZMIFtu9+0smYfFB3ef/tDYI4uTjsoyLdYa3nQCBZNUFj1M8lGfsksNbDCwB1tRSCmW8tS7pfytq3gGl/TGHR3p/iIp2hBJc0lvGaAkL9Sxn5nHGiadqPVRYJ99IruFh54pNNBWm8wl0unULy85HIDfKqWRvd+IZPNnBl7a7frxeexG7wdNOwsj3twJlUAM/pIwRg8D5ufeO/WldXFneyVp+3/jn
 DtMoCijf
 64pDT6iDJRQsVMvQgxfT2r2dhSLYGQRHJXEHePRkzJ/HFWc85bGvDq8FDGSyRK/nLnvlyAHQcnn43ztpaHKc7kyJQhn7i90YDMij5+LYO8VDOoOOmuAH5sXGV1Y/Kh8uEnkV2mawRmZ2Ovz1TAZOOuzN2z6yWM5TUWTXd2iInNHiuGL+fxmRHSOSq/1y5KlRjQo/4zoRj2WIUhjc2J65jWwui6bZdC0A59B8AtDckHICwdE+60yj0DIaSSQV8HVFrqEuDSbip5pHgAxJYxHUoVAixpi/1Z8jQxzms+sqqEGmrcBGmpYkmgyLVFVYCLP8f1fyEhk+7KCzCZKvqkQbDIfHYKlfB5Q+DBvjkSN3hptQC2r+IabSIM4O74+GhPZwf+CZowhfOU3dkFz0h/ZOQYGgEFD1Bty/XrnGTC/hUQqa02ADrB2Igk3qaUOLtnxfvjL71LlmN+q0mhfM=
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
2.54.0.794.g4f17f83d09-goog



