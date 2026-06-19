Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A4FACD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1746D6B00BC; Thu, 18 Jun 2026 20:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151476B00BE; Thu, 18 Jun 2026 20:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBAC66B00BF; Thu, 18 Jun 2026 20:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A979D6B00BC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 263F01202E8
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:08 +0000 (UTC)
X-FDA: 84894785136.21.469E58F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1D08F180008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QwH+ZSGH;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829126;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqQbf0iSMh5Alf2i15IWNvG5n/djp/WMXNZ/M+z1WN4=;
	b=4bwRujXmSUDEszr8MP2Fmo/ww8EPSjtWKG905L9CbC9LYdhl9h5kQeEvC/LFhP6UXLpZvB
	6Jr+41a46xNdF4m7j3wS2kE+v2FHzazBZEORPgvj2cTCleFB66QM52keMTUP42k26EzXJE
	mNSoOCUb7uINuUyJdf+ZW2Q/Rcz9eUQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QwH+ZSGH;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829126;
	b=wX7E06eXCbwHjTw1G4ja+HzTvA6bFKagrtla7D9GgEKIaOaDxZ/tvHo/ssZpZzaaRqKSUj
	d1CEh7bYoLCZbfQzTUDpcJv1GmjXcu4zkP+zBJcRQpKROl0raaBlBhI7Oa52OUZKKd6N2q
	3OvpWuTiS1ft8U264y+XW/xo+3xvaxE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3D5044DCE;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98903C4AF14;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829110;
	bh=hyRNuyMsZLQMyGFEZO2UzBVqQLGI9aeo5Ma5oEPpswo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QwH+ZSGHcRW4vRVG5BWfOTNaCaR7ySc06CpY2UCCm+MEO+Tlhapp6cpeZGUpg0ATA
	 tdufvYoDE1sM0uRAveikpighu5xeJO+qkSyOGDDKT/OHr6L3pwGO5cCbVBrcmcZ3rx
	 eFAUJNa20g6HJMVccZ//7BJEXnxcnc4RmWohE56dLijAMRNnVG0mz30onypZRPr9UZ
	 KIWfTf0+NCrzxXpdRKJNXGj97fIFBdVkL1XGEmFeV2Ct0sG0ZYhPhY/gN+6CkEo2k6
	 QHH0yqI74fw7JnaxHl78zikGSXGK0WjRLMEFyztf9G30PmOAjojOB2wroCpuJIp5ME
	 dyl3Lwxl32LHg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EA2CDB466;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:13 -0700
Subject: [PATCH v8 36/46] KVM: selftests: Test that truncation does not
 change shared/private status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-36-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1982;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HMIFzbIFC35IUHp+KURT8sUQy854Vqh4EBVRk/UpE8U=;
 b=0Scu2kbW0+O6h0vB1oGGoErRGaOirsqFNMOhSzBWOvhX+9s1Xeg0wzDZy04U061P/8imz4JRU
 FNzLvN7FPZvC/qUN5xAfm39r/FD7id5kWbZHgFmtacfnB5HiZwb2gUP
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1D08F180008
X-Stat-Signature: dzm6zz46qocpz8wwnm9kxadrsprrbjia
X-Rspam-User: 
X-HE-Tag: 1781829126-139859
X-HE-Meta: U2FsdGVkX19yirrvOte+0e62F/CCW105vl7rpXWNw6Gw89zEiw03/qqxtvodSEvWDSElxji8VUSwnKX4h8mm7AnFdpRAfc91QUqf+WLM7bcGyG6YtohMZnBY6Y2I+vWfC6zlE2x1b57Ln7U41WtAnttscGjFu+mt4gInzF4BoTDH4VUGmynbH6e8dba4e5GAYWGTOpr+ETbUobYeK8Cwl3uSndha3Ee/PJOE6qXfKVGmNPyRx1/qU7n0Xijo3CLvnCMZgS3ViBcCww+Y+uP/8fEu797vwDOyPkstheFJrc/nLW/DPh8FoUu+0EqIpPx9ArHJbU/dzzZen+tLuR95udb9yulokhN8uRVrJQRbOTCMWwpbSIKjo5qNOg9rP71U/XMbv/s5tMlMdDjTii0OoMcZ+PPutcaxdOzgKMbi4fb8QkL0iR/2EOLi4wHeLNuP8AII3Lmc1c1Z+NVqlumNelTCp9xLPt07MxcoIAGCPeQvDWxgpx0V8ZoBlb3J/nbVnaZ6HAaGpm/J0CFhQmiGVAWCqy52C4Lg6MCOL2cxwuwx/vn1Y5qaKjG+IbI31z+ge58w31SDTEB2JijNlTLXza38PdVzIjxg3+c/twnrwBKAb7OcL8L/AkrQri38TjRiwGLNRMpE+k+ctkCWo6CbZ1UdK6cDH0zHB79JweU8McIc+NdXQ8oU9LAG5ot0d8cDLlZy3c02OsVA3jwnizaI23Q6CpAuPr9/D+H6GomLc6MEr0FNRgkCU53PlugaayYIhFsNGqyuHvbJSLhULRu26hOGJGbxJTPM2VIX5wgw4IFgkwuzKyXB/ajEfVM8p9++wyIduXjapFjr/QD1OdVtaKjqDoAye6OdYwkAOUmhEykGNgXdt9Iu5HOQT/APNDA51QIxHULhGrVpQuK8hLK12Ko4uAsuRdcDwTJZfkkiQbjlCOJvLW8pAIRdfWo9MKWSUiusQazY5WpaT6hNHrU
 Qaq5hfQC
 fpQ4mSAMf7OjeMilWSVEHa3QoQmPT01GFLJusK2tElB+WyRMOBO9pd3fpPosjLfY8xSgNBzIoytUC+L4SyxdbKKvdLL5dd4tqNVIJxR8tIqHsDbjLSejhAmv25VqcYK6Z+y9neXLd8hIfzHbE5f1rkDILGsoXrW8EoXhIYqrKxLBuUETkbeyqdGFBdjOqwuw4W9CalOiE9tTFOKIJsVtPe9/KLDb9f/kfXO5u+JGKIBA8zUdzNcB/fIsiTBH4SK9OL2rbNWY9enPcWFshUEh1Beg7ErB+FX3i8L7LD/R5kcVKjOIPbZMn57uyzKZ313iJ5m02K75905u//uPoyCjalgnGC1a4pXTxe+3CevA5unjD+LxP9S3ovKIt+KI7rKVLU2SnYNb3lWqxeYY3Y2595lwo7jgA+rexSIKGlLrTbAgSw4ENiqgySneGqVtaw6DCUugxY186g/yAusf+qMBw9Tx6Kn8MKIv7sJZQximR79boYvU=
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



