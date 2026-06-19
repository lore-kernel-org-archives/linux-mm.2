Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E700CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09016B00B2; Thu, 18 Jun 2026 20:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0C86B00B4; Thu, 18 Jun 2026 20:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCCF6B00B3; Thu, 18 Jun 2026 20:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C58E6B00B1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 174EE1C4800
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:00 +0000 (UTC)
X-FDA: 84894784800.13.864550C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1FBCB140007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBHKb5w7;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829118;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+OrxaSVdx+Uu3k4hdrDouuDfTFbJbgvF1fM0Wu0jPY=;
	b=DL520EKHWbg7SoxSjUKeXO1ZH+QBUO3IHhN+QB03Pbxm6mgiThiqvF1j9Vvpmq6asgV3sb
	h4Em6Z4lKikXM2Pdijbv0QFBmPy42SX5tM929KD8JMvozl0CssbrKJIIcM2I8bDbXOO4co
	wMJ3hRzpccUn7H6cRgy5xB1CPMa9IE4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829118;
	b=tFf6THlHAN7k0acsSkiRx32J5r5CKyNeyNAgoNslEysNGuosm3yTrNeWV/UeizXUTmrrGM
	2fHGh+wR4Yxu7EmDiCP6Gk64QhnrMPD3Q2/9eO1uiAntOITZjwgWEuD3ZwkDoXrm/4BtOd
	TP+7ZrB/QpU17Z8VfkdqQu10OYwhZI0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBHKb5w7;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AE68445EA;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63610C2BCF5;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=06Cmm6ZSLGzEQ2JoFTbuetSxgKF6eUVAuIaVVaESzyY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DBHKb5w7mAb6WxW4rdHhJJopk9XYnPIsm7bvyJ/MocVumyEj+R0XblO9jzhP4+Czn
	 G+tXrezlavb9AeFH2TGtdk0mrdX4aIgoJIKzwYqIVBBwx5pc2jnUwR22YyCRLmZdb0
	 5cFSZrmh109Ih/tp+IbLP9s7/spJ/f7CKrLdiMZbctNsz2SSk822U0fwVhXDest0lj
	 9nf6QWlXBCSh/qhf5Npp+T7849kiEFMg7PZqryRs259ZIf9+LH1O+DvvqlmOscN479
	 LuK5Rfslxpi7/GTDVZbxBJcs+vBR+4fH8EDUaVpaT4Bvm3kQLZSn9rW8ggldnCAbKh
	 uo74MKjEK/6MQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C49CD98FA;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:02 -0700
Subject: [PATCH v8 25/46] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-25-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1553;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jzuj9zrl4qNuPFG8VNS4kO3hGida658cbqNcxlJaaaI=;
 b=pZ4fcSOhZu72mBX5CyHFKeu02FSiqennFh2LxM3kmpKV0MfpFcGGE0hZqpIFXdLwsMB3qy+P5
 IMDWN8ve9rUBaMz64S0aMs25PfZyWw3I5wDY3CCgG+CuQGOPU5+pPjE
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FBCB140007
X-Stat-Signature: p9bkamd35ojww1kqwcinkkmu3nz1cbjg
X-HE-Tag: 1781829118-148749
X-HE-Meta: U2FsdGVkX1+TwGaxeDdgEvuo+ePffuAFSYDyhAXcnnlXoNULbFu20+eCVH0lC0qs1lcEkm2iLYl99+RxUd95e9W6Fmbrq2NzO0goDkSIelQ/7cQFLbAs9kNRtY+u594TL91HWAqW9auf0yWqi2yEHeTHLh6R+o9IHZjca6eH2Zv+tX2XX7RLnuSCY6st/xMQD0AQ4cd7/AaLUX+lfCZcQVU03V2DYLiVADHzpiu32KSYc3chvJo1Jp3zMna2nZ7UQqo0o0909w5qDLQUR7Rlz61ISXM8R57NEFPbv7bf+8hRc2nrX4T64UGoM+MBCMDOnOY8bIAFvdzWWGBajCxx4ln4y3LScFmDEVAY/T0NtqKozRGq19mxo3z38QYuxB1fjEtheHq5/k3GHmH2CeJEaIssgHr/xgYQkY0//u7lHBlsxlZvx1f1FnyIqyz5zN5kOLb7n3D5Dpxx/fbiHTBt2Ic9SyDATv9LutuBkmhuATRXcYkTTH17sESG7S3TAWqUVzhSrSgBKCWjog1JQ7ZpBciXcx/MLW6SS/ksOOqdQYLmJW34wtyUcEDCu5Oof8Zazo6by00a4t8sEsBx/d6EZ4/PuvPnE4LptTria7maElctjy/ZSMfoebK9SV+VbJospH5QKXeE7xjG0wab8RTs5nCV2uPZhxOx+YX+rr7Xhj06rqYz3pEFOsXnRU9j3d6JMZjY9eFVeiP2IH+54N2/lzVhNYJbrT+79a3FkZpB0dSs/G1o5/wx6O4EXJJ7Jzerljo/wkJQsudtBwvuxrcOd/ODXoqkVf8h5QsoDmzIHUg/RI1WA5CzeSwlG3697KYCyWEiB+UO1sjU5b9zKmUqQ0pkrj2ZsWBAahNippB0Y1/PmwRJzKmWKKMDvr00NBMzROk0Zmbkq6nsLct/piIDMy0lWlv7+b37BrkyFGNgjLIvOXUCOo/DIgJ5Nei9MkljbJAJTf8l4dBbe5OQUcL
 24Oupol9
 M7IsrTU+WTTG7YgNBpxB/w/E3reC7VdWFaOVNKj4Dh0QsdLx/w2x3vzMq1lSZNHdSQXGUSyE0QuVM3HEk5ShLjQfh13PRJRtn/wcZRVe7GniCRASVnnJ4KM8RqT9XyW9QkK1l+sBsd2LF7k1GRhWRnI0obCPUl9dqTHeNm8SWXbx2f3pqj1e/heU3WL03XbTjD5q350luhq1h5zr3y/x8ZKjQ50DxTqie6mY3FZE9gJ0M9i6jcKHzUds7ZEY5JKFBBm92iKHfzx5ZoFgPxlHqE6HeyLY3C3M/lIqbKrxoNMCXhNguHtq4NB5nOz4lRaATjC7aS3KZ05WmkgXrJZA5dLBsBqAu4fjm5BFTRc02P8f0yUH88WsTrps1BhGyeqZqIF9t49F7VQaV67VXt2Qt3Vn9g3/iL8s5rulfQ518Wk04NNnUSFEooWoJVs1jIbFdWJxp3UplyWjJIXgZXhVWAUpz8x3f2PG6S1RgeaNbfXsmJRBkKKJFIFlu0mviaMLvca3FjDuhs5o01ETxrRCgXyASv6xYiO4T/hRe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Now that guest_memfd supports tracking private vs. shared within gmem
itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
for x86 Confidential Computing (CoCo) VMs, so long as in-place conversion
is enabled, i.e. when it's actually possible for a guest_memfd instance to
contain shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2fde594e86d72..57a543dadb851 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14116,14 +14116,15 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-/*
- * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
- * with private memory (the private vs. shared tracking needs to be moved into
- * guest_memfd).
- */
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
-	return !kvm_arch_has_private_mem(kvm);
+	/*
+	 * INIT_SHARED is supported if in-place conversion is enabled, or if
+	 * the VM doesn't support private memory.  If the VM has private memory
+	 * and in-place conversion is disabled, then guest_memfd can _only_ be
+	 * used for private memory.
+	 */
+	return gmem_in_place_conversion || !kvm_arch_has_private_mem(kvm);
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



