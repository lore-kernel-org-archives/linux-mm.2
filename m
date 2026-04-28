Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B203FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79F96B00C7; Tue, 28 Apr 2026 19:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51E46B00C9; Tue, 28 Apr 2026 19:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68056B00CC; Tue, 28 Apr 2026 19:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B46F86B00C7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:28:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC1E5A0F62
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:22 +0000 (UTC)
X-FDA: 84709548084.26.8FF9F26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1CF2120012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uIjiu9AO;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418720;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAJncJ/ek1OINP9igi/F9Wto1/fAu2gR9ekEQOlj2uw=;
	b=yFL2HPm3Db9GOIaFCu7qTchrErKgBMAwihvhcx8ssClUuHPlGi88MyXS9hUVTJ7m5BSIBi
	S8jzfIhO9EYZlPiXCGWxYJ5J/qFAIdcKUqBW20EbBDaHt8ADv07F5/U/LlPEDR5kGovGw2
	xd655CNgVkJ8JGRl6pB1fsei7YSB750=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418720; a=rsa-sha256;
	cv=none;
	b=CsSLPXGrf+eDaH7UjdRxYr5x1KGo0KFjW2dfbvnrAV6jP422XNVNt23E9vlMCG+/HjyUue
	xBgEZ+T6CFIOatoq3o9npXuzPJ7Hnd80BebARTITHstD/K6UnxM2JqDUAZnTVdpiC4OG46
	PMNNj/uTI54/DV23tHunA4C9i3nnJn4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uIjiu9AO;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16A2460133;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A97A0C4AF0B;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=h0E8/6sqDBUjmrJANiVtGnaPjc3NqIh4YoXQcBBDZCs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uIjiu9AO2n+mlQXWf2gw8OqrACXNjfOEaBEpNgzz2AfJY/Ri/0V5QqIKx5Sm0HIHx
	 2rH+cAXJYjtxFT3VJFWkYdnePPg4U/sbXO0O/YI8xkfiCSYRzCDR+txOf27iOTZxlL
	 kRFx73QCeQd8frJF/qhIKV+yLHMTD9+wqiX97Frp3hNJ28Rixfjsl4N6VAARpHtf1q
	 Mxdb2eM7aHAWc+9oomi2DHOAYpiqRUM1OgO3DZRdc7XJpYRkkhvnNhr4eIXimfAzTR
	 SVSJ56X+ixQm0S7s+QCDdmNRkjfBTu4paI9tTQlwwLub5YUawwsKsmCvnhw0aVRIL8
	 k1lp/kTtuUSCQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAF7CCF9E3;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:24 -0700
Subject: [PATCH RFC v5 29/53] KVM: selftests: Create gmem fd before
 "regular" fd when adding memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-29-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2823;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xIGL1xcJD27ice4aJgoH91ewbUcnazqU1ilqG8uRRXI=;
 b=KLdpylxs7EMDFFjrINTIXIZrFpXw4Ph7VX2ZjGBd63YJibo+NhqXvS32V8elMg2pLudMsgawf
 qO+LRqj10LJAlOQU6/3WvHtyA6qVnGYE4bNRtRE7lGHCjeSiqhsT5zA
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1CF2120012
X-Rspam-User: 
X-Stat-Signature: 3qrarkh1iutbxy9hi3dg1s17ss8z49jj
X-HE-Tag: 1777418720-391378
X-HE-Meta: U2FsdGVkX1/cZKf57UzcASCi+J7QFUg4OocG70eDoZukbI14v7yNRg/G7hEotk42FHJYSnS5LIqet0uRbkLaqP3qZNNncKp9uzXlPxIClPEXF/bl6iASyzp7iAq6hMtwkrQMt3UNYxDN1ty+0xZEMnEEQP41bH9Zm2nJVtiyzMvGp65Unwl/D9mJPxiYrGMxDgt74+KXPa40MD67x7/u6MjbsLeoj3351OCE8i48cPj68YaJatC1wmVJfUp4sVAyV9WjdgRHuia/sVjNFf4FuKN+LYVb0JJWG0WyZGz1JjfknZKZK35/J6KuGayNA5Y5qmBBTUirIQPWZ+KEmQKjrfpVkqa2642SpCaCvAYu84Mwu7XzjENlys+YweV2wNyubt7R0ywANCAQDh/ew4fRdfUysW5obvghzzbsg+DTbK50g0FewrT3fj4L9ZvriFUY9kzALSfBPvC4ffAxb0wB6uVXpnjLbwx3c7d73bttArjJmStCoQW3ZJ0uSPMsMzvxr9EcK4Y0qPi+VkKHA0PP/eto/dbG1S0RvvqQeUkq6sECsuu00sb1bkAHD2nPy4kLWe49AASM8EnNeCDBbRVbZcTaxW6nwphgjc6wm4r5jg/in4DTXrlevQyJ68Hx9KSKt8EvPwUtmfyJ6uNCQCt0aJCohOWp+nn/gFDMO2yTp6xTqSQFsYy3VLC/3Rumh2rIhUUDXsfgEzxkmpS5wI2CikBAV9VGuDHw9HPt+pDZVBDLbHjp4FSSlYE9vGk/ADDUNwMsySz6aPPt+nu9OPlYvOi5Dn39WyAjTy2WT48UWeRdUYktXsJ5+wo+kM1tVu41RLBbA44TKpCQ5Pu9kMegCM1MpvAzeVlEXwqZZjZuaUoz9HdlB91JgSmE6KBC2fSpqOZI16iPZbNqWf7KM67Bx6RA5JuXAUtJ9FOgjLQMBwn2IS00s5OOzFU89ZeuQViJiiXylx89lYzDINkMbl7
 3XrhqeBf
 ZiTN1mkDUtCHk/jcTSDgcxdKFRlFibze66S6Ppq3WPud3SQ29H8vSmrgYnuBulOKUtPPCKpCaD0Gc4WW/dIqhVB2hTV5GlADJPoAaP8b8VTYDppjKxNaotkUTW4I/+EeTJlMg1Gl2Hug4d8PFbiL4CcnHb7/ROL8PZebLHx+aTsZZ7Gl6IMEY+bd8kxf19JUfLOg7huhRqOcApbATEQAH7PMqk3VbbjfWltgfqX04VlRZ2xrOHfyYDENjiLiQf4ICq2jOgNo34LHk7aKraadeT0YJAZvrG31Y/qhUUdYHXfBnUWWAWIkd3z/LLzXoVsnjmTYlKazC+/zMPOQU4SnuLkyU5OU1WImMtlQ6T/oTcMRc3dX4Do0TLAFlON9lO71gPGBN8Sn4XMth6KUUhezQWIosTMnEXAdp9M9r
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2a76eca7029d3..df73b23a4c66a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1054,6 +1054,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1083,28 +1106,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
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
2.54.0.545.g6539524ca2-goog



