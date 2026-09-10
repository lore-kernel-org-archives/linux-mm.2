Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B08B8C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6416B00CF; Thu, 10 Sep 2026 19:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3EEC6B00D1; Thu, 10 Sep 2026 19:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E1A6B00D2; Thu, 10 Sep 2026 19:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8186C6B00CF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E295612051A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:53 +0000 (UTC)
X-FDA: 85199512986.27.3DAD69C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DE51614000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VboHqZwc;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084552;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsWz8nZxxvDO5rWAvVVzts/t1q3N3+6NV/pPfXGcXwk=;
	b=ea9RXzs9tphIP5HJrtrcDdERJPLWB/u0tZeFYKsQT8HcvvYooltm94lYDwuCc2OpCc6Uo4
	xsoGKDP2CXjN5+GPj6VPTqu2wB5J1jmEpQrNihVQVEKB7I5MmwCZERLtG+aapP7jvmbdl6
	L81C42qgFQexPo9O2FG7Nxy6PoZ7/6U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VboHqZwc;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084552;
	b=6Xl56Gj8IyCNeUYhu+2G4gmU/Neq4fn+m45gAADDMLYjhh2+cZbRwuM/7Lqrar17Kdu5et
	YiXu4Mcy8+I7xXBSV0qCLkQBLi5LGIhS0bZFOcsZ6XzIMU0kexCghCHi0t0uiUO+dOC3ZW
	fmJyyWJ6XSY3TnEQiPjiVTarutd4En4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5545244969;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30407C2BCFD;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=Yz7iUg9XRAXZM972/G4cSghk6ltxCAFhgfYTOLvch18=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VboHqZwcv6d/maaY68WHAEOz/Kux2D0iDxPbIuhpXUYrivzcE8uJN2KBBnd7oqYF5
	 FDGNwrZ8yqIc7Zgd004/dxErDaC7LKl6+1yhOnTMYWyJAmpPa1lMqdsa++bsGYURPG
	 89Q27z5BfE2Clr/9VHRbFvG3Gn0ETFAC8y2bz+ykHzMKgGBzvcmTlcUU+vRPNw5RV9
	 pfm99/OwPK+hhJ66FDhpwl86qYcbIRWtTGIIQS9usJow8lcJSs+jBNzorRRYe1SCB1
	 iXnnzuMUGogCrfgomPF3WvDLLMga9CEwPic4Qd3oHzimSRlkoiZRcET3rWiTyADpxt
	 tWf2/teslRWaA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D8FC88E4D;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:00 -0700
Subject: [PATCH v13 34/44] KVM: selftests: Test that truncation does not
 change shared/private status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-34-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2067;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=d5eJ++IcGJazUQlXjFIkV06g9Z71l71yIBb6tdneXIQ=;
 b=CCElrqX7WC07ExlLLucnumRJXtfcIFU5A0IFsjwOodS95cWs8AaEL3dO9LwUCG0xZAVvPANHu
 nCEsakHy2uFDjJUuYbdZTTBOC2Q3vwdX0IF5ERAVZ6iqrBWmoYFqggf
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE51614000A
X-Stat-Signature: suuh3sgfin3gic81tegy6586yb13o1u6
X-Rspam-User: 
X-HE-Tag: 1789084551-643609
X-HE-Meta: U2FsdGVkX1+6gsr3yAhRm+kOKXt19sEJYQSo2C96h3se3UrmHItvDa8whklwKnEIifGvICf+NjkhPAR8CAsulvAloQwnETecOdeqPj/Ie5JlU8MAUxW0V21Ub4pPgynVUFU9kxMRH1KWknYFk/l26dTMzsaxC/4Q0JNjqMPA7mDgZomyX4A1jVZBfd1NdVFS+QBfC1PD2yzes/T4SpscuVw1Gtq4ir3oO0PKZy2h7N6u301qNm90YsE6j3vp4FSOF32joKGvFvSgl/c5/VabMlU5pZrOI08PvBSjVB4fwevLDDj9JaMyDJM5W/6w/Lw0RfTAdne6e7c6BMnEtmwPNCZknvHpRMlPtJaUIqmkK1uiSvG2oYt01Kf4M3LtbrU53+/ZVVtiecQSNyQVZzmmS9cPPrRn6RB7zJUEpy07za2L95ZMG5vkTRig9ERmAJxPJTbWM/geEu1w9HSdFZ6/hR2qsnWuJNCgut99vW2JsjFp3DZogwtCIllqPzkKhNXZcRYu/OwL5dzwFR9QKz7Z4h4Nj+Atsc9hN0SeuTZWD/v++3g5MX6kV33+Rfwy2UgCNRUklgdMvoG72G25/aQNCS4LSG6GGdtvTAoVMDRj86V6fM74FTpLwQw6D5VQwuQ5HA5Ug+fCfWTZK4rFMENC9woAV/KDLBrUOsnLFFgl0br2+nD+F49EaSQOaxQ2gn7tGVMnyIJuKeUMkXdV7Cf/6AYqvKF6ALT7KDcUJjyqekZ4IB+r7ap2OPq8UJX2aDYwqWZKBHHcZC+7rGd2NYyH+oJqz8D1OmVrXPSPl8qQraQ0+x1uSECGlcDW8I7RsgCMosZSLuIgeooxreMKHg8fpWEnOYQYLz4kpG1db3KA+PlVkfadnrO1nGAvfIs0hPBCKzpSrtgKo0TVI9Ul52qrr8/GCmw/hM37SOWrAFiemrsgPM2jWgLEgjd3SUtZUv24Ca9Ga/QodXJnQyRcUyg
 gMi8+34S
 s4X/KmxWWO3KP8FVFNibBpE+OYbP0uC7RoJErBEbyWLCpzQwusxxP4lms4xmTD1AotXTfifZdKWES3cKvbygeAO1QWxTwNcE81qr6pT20dh4H0aIOxUSRLLddxhrhck2BwLeON4LP+L5KSqOAeJ62bIPBgHHsl0xP5cTPqnL+JaRJG2kvk0P52gmKIGtifLzngWuy+GC1fT8rbW+m49PJiv/b+djVVnYl5wSBCaRdUnGs3IWChYqBumv1wAEjcJAfAXPYiJQAvN3FWmWOoKosDhkpaa9VeRP0+ZWoXe2oMRm/XYq8MHff75LDZ4XaNNuH/MjLs3FpubIgJzOB4YH5+T+Z9ua60CReXaLo4nEfmqchbrg4p3G5TQ3C0Me7pqx2XPrTZ3S1db6CBP6MJ9Cg/2cJLSwOi3tcUx/Ox7uWIoAE8mXyCrGmH0y463uEP2dnBx0WiMA9UB/RTczhKlEmjEmlUDI2YiUsnxrE
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



