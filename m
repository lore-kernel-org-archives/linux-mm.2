Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F58C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676556B0092; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CA46B009F; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0EA6B0092; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2F576B0092
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BFABA196F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
X-FDA: 85039944864.18.99DB0A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8501D4000E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qDxtVZSZ;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSiV3LaCZWE+MrR5BCBlhlun8WzbbZ2b5pJ94KBR6Pc=;
	b=pVt7j7ITqTkDbDuu71EZIvzltpKmcwpQezX4IoIjsZlRLronlroOBD+4SsoSMO0PuKw9DW
	mA/gD6OFRytIPFP8R/T8fAy7tyr82kGbTaF/hYZBzgBdeexpRF+AMq9bHwcxwEr9HABTo3
	Gw4OV7e9GMcB8z+sS/zDrMPrfTqN91k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qDxtVZSZ;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285310;
	b=m2hQJAth1yNBaA9xHCecB5H6cpg8q4VSCRH36VEGSfvGsdNaEjP7mdxxVOuxhWJ6lWeINm
	24h4yT756djAfqWhr80gXFks8BAcPp+F9CoLPwT6vf7L7Cb/NhBsONF7UembGw4iNK3FWv
	qBqAFAmvFzcWVRtiYi+LN0SpxYGx2/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B2A34514D;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0697AC4AF0D;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285308;
	bh=6aM2ssaYqN42jru008dQMv0DvAC3ygeFS/sYOj9rJRc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qDxtVZSZNyod0D2S8x9b53St2cXGFrSpYstdBKy0VB1Ge97lAO58+5BrajUTxUYr+
	 V2K9Z7tgBqYaBL8iVEnbpeWK4iND92pNRTR9QzI11dGKTWFRSSOrYRxhmfMAvRrnBL
	 rMISw9vPu/XVkeiAngUbaoLoKMRAiMNg8BfXhPIljitpgUuoyUlCQvA06UJ/FmZGDa
	 hMlfBuxl+bT1mUqh8x0LKtd2byAT4/0im+TSRlypsh9ud5QzVnhwm6Hz7n66Crb0D0
	 ShhalPrNA5U3oBEBGYbRUSwBQvCoj1UVMi7DZjHM56drJr/dOEULKzbMyBoJS3B+yt
	 2IJYPe3U0MYwQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36F4C54F52;
	Wed, 29 Jul 2026 00:35:07 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:02 -0700
Subject: [PATCH v9 03/41] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=1931;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=O7sxLpn2R0quc46LYFMUDbXF8+uTQ8KrVzojQDeT1HA=;
 b=DEnJly7jd1lfYKOrGzxeTHui0t87YpwfLT3ObP2JeuDTi+GFwbNee//TP89KNdFUt4ooSk15D
 SDFtlyD0SfXDiyPVNMHvt/yrw6tHTDxC6Y9DXI0oJcoE6erVJWktz2n
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 8501D4000E
X-Rspam-User: 
X-Stat-Signature: fbxnhqxy19a8ujrfts39fwrdqd948xy4
X-Rspamd-Server: rspam04
X-HE-Tag: 1785285310-202295
X-HE-Meta: U2FsdGVkX1/5ZxCB+q+ysiUCn/lhBZIyOwWmJjCR4wBcUdVUP8OsEcw+lqKCBaTqOOb/3j/MXhH6aSGZvPREnbiUWSDNFtbrS/qdT/81T0ls4xAXKgshAmWbO5f3yfbPWncSnI3cYEnPaYmUVJBMKpy+quh2G+G3TOf8ezjJIBmla2WtM5FaC7OphpP+q1jRcGVDFE04tJVB2kSWiJ52aY3xk+mCjNmjeIeWNB8w7CdKQn43GoaCW+JBEOkrXnXWeCZ1pXvcMWOgRHPn7B64mc1qTMTCCrAgj0vcAffFKFWI8a5ys2HQNwwwVOsTykzjnunGiUqkQwAEnbcDxvMArYgoQwe3H90NH+WEyvhlq32g8Lm0dcrCTe8huGJETimobvyfGGkRfKlX8NFmKb0Yo03oVOrx2MK28NSylYKjEC5xcwdyUf6ntN7OF9cygM/vMlHiwYo2GssRQ6AW9wFvK8/5UMKwDeMv/dH2PaqdDDKTkrzqQ8EBASxzzVG13t/HR+WB8dsQwaBD+JTPguDPIbxCqBJdzYxIEm4vUjpqE90TQDnQQo4A2tpx8MgisIUj5lpkr39J3X1XOf69maIijk2VEU2eZh6Gh1+riPZ+dyrjyA3ExpGd5QDZm+SSQe8taMaNox5bhpH6fY35hxD/cjiCy59zY9u582kTHRrLzt3dhuzqpbv5FrVvSdK7olInWkxXWmBLXugtPO4hTNeng+qP8/zDgaFoPVh2QrEqn4Kz2Trle2PLpwynRiq8cmOoPViEPO9HlwbR0bv45aV5akrDvc0S9p/MywTbU5zTcujGo+kTdWlG8IC6In24Wy1pDPc9rka7+BVLl4lYOpWkkBvghU5b8fvhgI/gm4uCK25elbENeMXy1Nc5aavnhV0zxfl3I6jrXE05xTacY+oNZigzFpT3ls/8Ryvr1nhcPI+cwux6eCyXB5rPhNPLqWOr+7j7yPP7B3sj3XBg+G7
 TwJSQVzE
 C110bSJTcCWyrIYgz2cEKZ0o3e7n3ZJI61xA8haOQcc7VP0uHHzPhZW+t9GnDvjfV+/MKMAszvOW3HOE8LQ1QxfxhNKx/4TZnACbqpnamo5onZO8Rn3SQUl0IBYZ1uLF+qwcPVEG0OZn6e4DxOZteJitRpLBV7IAV0sy13ueBTkNnroVHqO9YBLklMV9nZN9X0wiUfH692vOGztMTr5vOgryOhguYNI5W0tClhq8JDcQuSRxkb190X5HgcKMNgfnTXmbgEn9prOg6IoAM6jorn3v8t8SJWtN9YT0q0zKRSswDNpbERxRr522oj3eOVOVMA2QCmX3/WPpoKEVIzGOf++ATW7NIAgwCLwccMalZ8D8rFRa4g1Lofx/Xfegc/X7F2q/pa5hd9f0iQpqkSxh3q1sOy6kXgrlYuaDoIT5ULSdyG5I+OqGy5y2rsjToIdTwBQyc3boRvWcL08Tggo7Cf5+OoyAcPmrrq8nQX207Sqrr7FbR3bn8MPQuriBLo3OtNf0dLRlCyR11+S0B5lc8EvScgGB4xAdiIJxfI1t1SZaLKk4Wc54YkEOy5kp5l9tk11Wou1cfHpRzew0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of decoupling
kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
guest_memfd support for memory attributes will be unconditional to avoid
yet more macros (all architectures that support guest_memfd are expected to
use per-gmem attributes at some point), at which point enumerating support
KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
supported _somewhere_ would result in KVM over-reporting support on arm64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9f78a466c6f3e..c125d2e8155a7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifndef kvm_arch_has_private_mem
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 902aa166c9c0c..9501dd8d015d1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2421,8 +2421,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
+#ifdef kvm_arch_has_private_mem
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
 
 	return 0;
 }

-- 
2.55.0.508.g3f0d502094-goog



