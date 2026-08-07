Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58861C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7996B00AF; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F3B6B00AB; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F278A6B00B1; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB48B6B00AB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA8BBC0201
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:52 +0000 (UTC)
X-FDA: 85075823784.09.ECB535B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2E1A180008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tOJHYc5X;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139570;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShcPJf8jWqBc8UMjotbihlMHerTWOAlCrQs/xtPuiJE=;
	b=VaNVHxZjeSWcirhDYx8NaL1LPWwdOZLsgxGDZYVv9610YWDj0WIdpI3H9ZbQxC5NwsW9K1
	qoyVgH1JhA/FVx33P2KEbCG5PyR0xr0bpywulifV8dWDo60/sUxEMkvKUSJ0eQap/jbY6s
	lO8yyEGfcQx6r+TdbgCAAhttxeADdPY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139570;
	b=uXL6lXyc8u6z+8s0w5IvwVfhQcnEajNArHHp3B+bkcrRX5DCnKvXtSP3KWzSQ0rNS38hFp
	iTZFB6x6JeOPCPe+XhxIiUH/lBZuVlQef/vi8Nq3iOcwgoChFTlu6yJWWg8xNcdvPpxNdC
	8Ox/KMLo+I6wrITHtSXr0Lp4OdxkwNs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tOJHYc5X;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59E05600B0;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1230C2BD00;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=syEENkuW3iSW160gl7W1np8DdrGUT2InzYCZ2ecLpOM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tOJHYc5X4n/TSzHqCk60Fb7d1GfAxXCnqBGFYqazVZlKKEPJ9NuHMlhRUF5eXEfUV
	 t1IQZkf9LW0E/z0Z+m3xFsqdS9GtsZQPGvKFHJRFK9BJxd/bbV57W5qV1r3BNwRMoX
	 APD/dSQ8SBp097SKEiMM1A4mXXNter8ELlCHuQqBGOEUQRC0dTr9vsTMDeDNEtIr/Y
	 +jWYJ4hcxQqsYwgH82BOQCapzlCo5XxUG55m533B5Lf1CGSIM3w20JdxSkwe1sL+lU
	 FdOoFhxB52PK1H1iF39eMGPbfE+z5J2vvWqfy6kP+XuKEfOCxso0manlYNQhZZTfY5
	 Gy9fzZk3IMTEg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC981C5ACD3;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:01 -0700
Subject: [PATCH v10 22/41] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-22-2fc18ee6d3ba@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=2911;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=isrJvdvrZ/oXl43dBOcqzIaHXdNt/p+tOPS/6/JN0AQ=;
 b=EgmC8r1wDG2Mg1pWS7R67+sXU4hwHxL7nwb0aPuNPQXugJEXydz3W4gv1xyzzQ9Wz3WFfCLnE
 RslWm69T9YDDAiOKHi7jBRek2eO2gtL/UQvO3WEr4mMgsCcw/dAnEkT
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C2E1A180008
X-Stat-Signature: k9weoxaockgrhmoopiaon6ssdeftdr4z
X-HE-Tag: 1786139570-714055
X-HE-Meta: U2FsdGVkX19KoNqiIDUO+AZKcfe8a2j4c5y/LMjKuqny9g1v+0aHcAnlzmw+BUAhRn0ToVPYWkPYcpVJV2iJ8A8BtXPHiuUkQ6nNL/IOuNB/Op4aA5Sfgd+Jvg3NkqakTcDoeyra3nYN2t14FHZBUsSN1hJhtWB0bI4MWMZlQxJeZRQc4yx4wbFuLbB7fKW6bbFISjShQxNqV9rg1CuzK+BNYaNTH5BU5BVvbDruJBMg82YvJ6qUJi5itWApM/qMZOO8ta7tSsBfeN0BvOp95ju6XcDpuNTJpHx9XVot9TPprwryHfp6y7rdX8CYScukVZ5l8C7ISErG2cAFq7UF4EOWSFRgSA1lXDXZNJ+jOdia9tv2/eBNtExJXE9XeA2dP1LiBc9Fymnqb1B86BOkRt+yAZd4CsGfdvyhhKbVEVPub4JhJ/SzvwYQhm/9AI4GUP/pcZWJ7crq5yzNdsaPk9NSOaM80NvtDy2/t8qCh/rV1AHyN7Wwk9yzjWegakjcl69B8GbBl2F0CO9AoLlJ5iVDtADWBpycYR7MGhBTnOhzVmQa9Yyq5ckR0zv7cns8diXS12FC5o/t2eLiE1qlGUCb7Kezy76vec2k3rk+bEMIDntlOwbHu/w3JyBzlevlIjsXFbEKoRJUAxqylaVKRvNdqZtJe3S+YDkpN1jB8RDVlV/632tNLx+tR1EyN/SpKoj7hKNuLrJaRLUdrdyya5G+lLjYri2OnkYe1vwLk6wyMXbQUTVQTpKKSbD6OwJYHeg8NK0ZQSUpuzGBMBwO/7yvg01sbDdaplvKf4bd/sLiS4MYn8QprVSu2l0W8/D4GwzbDAMf4o4IIVcS5w6v1r89KV2966KlEMWX/5JqwacpdLY/cfZLgAeTDGFodOGMTm2cTuazZuSRahTDEAFmcg4DiIXq5kaYPQeeOO/tuqYTiVFPiw/LBWZR/TGYRAo+ccHnTm15pbDNhtkzcRp
 PcK8a502
 81MDqLT0X18F/gFL1XIXozPm0ALIV9nKprjzMDs764PrEMyS1QgkcP6Ua7t5XURwtpq88ryPoicgtN9MIIhP88+nRiF7MvA1P2KO1+La2Z6dqtXcBdicYrxuqAwr2mitEgyiglkkYOY38Jy0RSZetCQF1C1pZZYCd8q1VlTnko6Pr6O+sNO/lYBVT8mIuYEfMh2R78uV0POVxczB6oi1Na8sRlMsSJAXzj3RRQnhn9gV0q0Ok40zRXuaX4hCoVFJNbyHp1q37YgnQ9s7TctQIV5iOdrkQRrT0++Kt7/G3O/CIcQqGf8N6nU3rYNooL9OzBQQBjqvMdKvjBBu3JuUnwDvMPpqg+b2j5Vq9xNPthod+5qT8WoLqBlwBSCBY4POL3bck7w22jiL9Zs4o9ffgMZLoPtgzFO0EXRpzAaTDSnAUCAvheiBj5Qdm8Qqw349QWas6+N98cfcX27fwQcdNbqXWQjTJV8BkSob2vGmjmCFP3sS6ELKWpEYkY2rWNBdlsWmWTvhW626+yIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

When adding a memslot associated a guest_memfd instance, create/dup the
guest_memfd before creating the "normal" backing file.  This will allow
dup'ing the gmem fd as the normal fd when guest_memfd supports mmap(),
i.e. to make guest_memfd the _only_ backing source for the memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9ddc047d5c275..3413d45e34faf 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1077,6 +1077,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	if (alignment > 1)
 		region->mmap_size += alignment;
 
+	if (flags & KVM_MEM_GUEST_MEMFD) {
+		if (guest_memfd < 0) {
+			u32 guest_memfd_flags = 0;
+
+			TEST_ASSERT(!guest_memfd_offset,
+				    "Offset must be zero when creating new guest_memfd");
+			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
+		} else {
+			/*
+			 * Install a unique fd for each memslot so that the fd
+			 * can be closed when the region is deleted without
+			 * needing to track if the fd is owned by the framework
+			 * or by the caller.
+			 */
+			guest_memfd = kvm_dup(guest_memfd);
+		}
+
+		region->region.guest_memfd = guest_memfd;
+		region->region.guest_memfd_offset = guest_memfd_offset;
+	} else {
+		region->region.guest_memfd = -1;
+	}
+
 	region->fd = -1;
 	if (backing_src_is_shared(src_type))
 		region->fd = kvm_memfd_alloc(region->mmap_size,
@@ -1106,28 +1129,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	region->backing_src_type = src_type;
 
-	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			u32 guest_memfd_flags = 0;
-			TEST_ASSERT(!guest_memfd_offset,
-				    "Offset must be zero when creating new guest_memfd");
-			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
-		} else {
-			/*
-			 * Install a unique fd for each memslot so that the fd
-			 * can be closed when the region is deleted without
-			 * needing to track if the fd is owned by the framework
-			 * or by the caller.
-			 */
-			guest_memfd = kvm_dup(guest_memfd);
-		}
-
-		region->region.guest_memfd = guest_memfd;
-		region->region.guest_memfd_offset = guest_memfd_offset;
-	} else {
-		region->region.guest_memfd = -1;
-	}
-
 	region->unused_phy_pages = sparsebit_alloc();
 	if (vm_arch_has_protected_memory(vm))
 		region->protected_phy_pages = sparsebit_alloc();

-- 
2.55.0.654.g21b8a5bc05-goog



