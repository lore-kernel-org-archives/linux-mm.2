Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBC3CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C586B00AA; Thu,  7 May 2026 16:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6216B00AB; Thu,  7 May 2026 16:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D396B00AC; Thu,  7 May 2026 16:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC46A6B00AA
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B870B8D0EB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:01 +0000 (UTC)
X-FDA: 84741747762.12.06B6461
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8C7AD4000D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nwxkxRY4;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185379;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09sVHK3aR4pQtzQYKpovnz+p3bwUZ2XHVRuMf4Gt62I=;
	b=d1nmzTIUIqn4yIRdQT3uoHe3GtI/85RzBp76d/Y5nEFMG6Ebx3xONJh0LSRW55DxCA16AI
	5XmViJZoOnAjkeQvD5eu0YrAgleTfh/N7GTmp3np/3rr3FCh2Fi+pvap6waUJZlovpTRBm
	XYgplqv+q6UBVZR0IJPFf6bs95/KFBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185379; a=rsa-sha256;
	cv=none;
	b=sxGZeMI5J197DzGG3QDpwLqduvuJzaztzw1HDwqhAjQKlJO7kCDmjyTiO2gPSIIKPiLMQU
	uDWhxaUAY6PipckjBO6K7BeJVC1ZAXZ77bxufgz1cwJ2HyKPQ0KXXdMrvrtEyXdY4N/AmQ
	w8FJ3WkNgFsc6X3QTVeSx8oM9qL52Rw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nwxkxRY4;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DA1643BA0;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6281CC2BCF5;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185371;
	bh=C+xELju6R3fIL3f1dr1rvRrp+aANV5vu2X8OfPWrq7c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nwxkxRY4yvIRlWs93JdnGLyo3Ka/r1xrTaO4Gq5F8+Qh9/V51yAEToatZ2xMpgrgw
	 0GyUZGxZp1GOwjdltRWmTI6M+22bblb8lT/sFAPcIHwkhz89G6EpEznDCSCUYULsZf
	 LspsYQEnFTgKourNPyEbV5LILIFhd1L+21ZFk/WsYEzD/fppM8yeOZlVi+fEZ4wjLa
	 ZTroTi47cpwXyhJVXt1UbW+FIg/wt6VOWPHHcz0D2DA3E0EwMhSjk/f8Ovdxtcn8Y4
	 bn3/MUOTJ4D7hVcSl8Qfut1NDJo4tFNSfzHbJK+yKbBH6CPMon86VbaCSNe9CnTUWY
	 uMGU4hkhqadoQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566AACD3446;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:42 -0700
Subject: [PATCH v6 23/43] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-23-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2823;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=osz8BG4F8/rIRywpp/gLibMgBsT8VmvgL1G5ovKf39I=;
 b=XTN/MJVZn4LBVZKcc3bhKE48c5ryNJO1/4FV0ZkfiqtAahVwPSXK1HhLYE3U8J7+MK3K7DmDR
 1wRHNpZAb/ZC0bYyZPGEZRJWsoQ6mUhi63Db0zukdHtmm9KgIiDCXKb
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8C7AD4000D
X-Stat-Signature: t8yphn1a6xkqbmxk3jdjppjr9w4bjxnb
X-Rspam-User: 
X-HE-Tag: 1778185379-417357
X-HE-Meta: U2FsdGVkX18CTwmu9eiw9jVQ3vRGS6haDc7qQfE/oT52YDsbt6XuOnLAPBKDKP98NegbrNCf3ySbvIm70WJua6nnjH3Bfv1y24cFqpAE4ezxqFgof8gV6LHdG8MteIdlITFS7XcSnptrcubbCkGMFZWg6gzskhUjI3HJj3u0h56SNAJsxt4sXhJVcf4H/MQhfFVVgjofUiJZsb6mjF6UYJSFU39/eJxNp4w5A9ln4IE6cWbpqbHktOxzvxrLxsbWxRZCIKd4DY/EWmGdIiXzPstwNoNsYlQsLm7dssWJkxmbVL7gxyRB0f0GF2K0QwHVn02W0GgVCL7x1l+IxzDOw49dkCM4Eo+7diNu0VWmc6ti+xTU3XKRr5Xr+np6syowknuIVdc8yHzvzgvGFRtmNxoBxoNM04+6+HCUft6ahPwJfVXXWdTtTsk/wQIrlZ9Xg2zDrbmON5kVIeRsPQXXpZB+kDEIeekcIw653hbc2os9P/+TujiYWBc/jDrmR99PHul1GUoY2NGWmB6AtUTxCcwZ2JbKEtOq3ppNn5Um2Cn406lkzRbUNmb5tO1vztS8LEPqksjDABSn8dTVRb4GfGk8AMosOLI1oubJM+4PkU9fK092heatR+aRibMTlDz3wD1QImYRlkB4cnvkTYBQPC+EADR7haGZB0w2GstwHahdVb0F7rMm28ngdbUR0qcIOGxV3ArExFn2LkZDH4NEIQPDhr60XeFbJyoW56yiI8OCzFV9UrMn6plZIksrnhVp7D4D3w1izpsCvBTRufEMHnMFdI8/2SgDSTDOks7Rbc5CiqxR6FeBHxu7ofCzIanLgZG4F1tSuBbrP8r5Nd+0X6qa1ZHJQu4leXlfBg+Ap+q3jZj0Yh8dOtG4dPfYgKY6YZudRZU/vjqkMKT3NfgAFdHS8EyqbkFmpKpZWmfLCbbHeOAtA7PwuxGADXH/P8QAOYqzjooPAq6zQVVzkbJ
 5ljnaKtv
 Wk5/L2jhMfDTKx6voQ/qMIXERihR5Y6wZDdBo639byDLlm//qDrba3XLRQR4ZxZ/VaSUMEmVfPcWoIU6h9Un+6IIJJcgWNv9+GqYybOMB6LQL1Y0UiomLByaCtOrtyifyWdu5JF1LJJzhnWuUeMu/RbzXJmKoAXzPYXpydo2GfDDYXpi2yRMqYG0Xm01+yjk88Ny/RfalcsrCbCEVvjBOs5+5n03kvIgx5oeo8cDToBUpSd0wz+lAbUGhh2ndYVigQY27tBSjYZnLMzeDfduqP5fij4yIaEN/HijBVgfKt+bRO/LtOsq3FJj1IgHqDqtWGjow7N9kh4zNJrfDEM37bWK5e5ghAHBt5KMsdk7qhhCGVa/n5hnhMYkDCXoCgzgovyZkBXjDXr/zRKpAgwQPBHB1b45mDL9848YV
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
2.54.0.563.g4f69b47b94-goog



