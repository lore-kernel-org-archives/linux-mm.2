Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D19CCD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD866B00A7; Thu,  7 May 2026 16:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD496B00A9; Thu,  7 May 2026 16:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4536B00AA; Thu,  7 May 2026 16:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5E86B00A7
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38E498D0DB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:00 +0000 (UTC)
X-FDA: 84741747720.08.C83C868
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 208144000D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BkIORK8q;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185378;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1qMDnLLmYY2U39gxRDOeShjQj+YiH7Q+uDz84OnFDU=;
	b=Euv0HRtSMqXQodSRHMMxR7Wy6s8hYEmKy1An7fYS+C+bQAWymyfTOuFqN0Wc2otC++mFAH
	c2RcRZwSpoepCU2t2S829SjCQtyzSUT9DnmFPwi5vrEmAOAc4V9xIZGtL3FF+MYfgZkjh2
	/VJeEfeRICQcpycElWTN8IlUq1B30vs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185378; a=rsa-sha256;
	cv=none;
	b=EOhbjaGspDmuGGRT1AIEFn9uR8lP7ajfftWtQA9odueCle6/NogTpLn7nGZYewI7I8hVbW
	bQHbg2Ra03xzuhPdwcyqYnGxfQ9mAuw86GKAqFpTFTht2xzRY9KNVaFiyAeqyDHJGBJrOX
	JixdFyA/B0ELC0R6sGJh5/4dpz5bFBM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BkIORK8q;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 285DA44163;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03BACC2BCF7;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185371;
	bh=kuvf1QytKNmWpbqV5ZSDGpv2N4AjU4Sqs1rvh9b2g7c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BkIORK8qYTAnm2VU49jRDbUko2CyK3uAgcNeRl3TBK3CJItP1Wal7F3Om8ev1LPtu
	 LFnDs9CXAMhNpzNf+Cb+MZvOwaiw9HaxX5drka5j2mxB/++qR0qFqZvWIvt9kU52ms
	 D3Xqi9gun6bs2xpaP7BiWKyyLoNytTf9LNvO0GnA6CMITzxH7OFm+ik8VSqDXMs5OP
	 qChzXN8wh6Q26uyagCLQj5kLfC3bNparYD+OZ/ZQIijFoexWoPMzk7KPPQfxnGPOgV
	 ZIjtlHlZ4uyqi6/lacJQaLNv27aDQpPnE+jsx9/2OZ0+KErzrmfPYj0AkGC8VTpLBw
	 TfScj/eu/6JDg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9092CD343F;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:39 -0700
Subject: [PATCH v6 20/43] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-20-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1390;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=4th485qJtPy9D3mUoIORJhfE2BOpFshMa4hW0RxvNaU=;
 b=cfh6kq6WIGvAJNv/sMpeHDw0eVPS4Kih4J+DT/ModMbPkUjKWNfXuj744TOQCrKVG9CIv9CXu
 hv921YxLxRMCed3DoJV+8+z5iUMWDyJVfeMN7gBq7oFrmBi0MmYhNO2
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 208144000D
X-Stat-Signature: 15moxxfkwikswc5uz41bwjd675hqpig8
X-Rspam-User: 
X-HE-Tag: 1778185377-581801
X-HE-Meta: U2FsdGVkX18Bh3EZZePP5mBOrQGCF0Oc+xZ09jifZFAUEVUbWpkEotyqshsoKXnwv600CPi/2JAvev4GhcIlKGLhTukNy0BPzqbgR7AAKFnd5xbWtvXOBJ/Fl4XhbDtTZsougpKO2Q6itmiu57rtwcxs18rJS+OGG/L52dSS84SBDxkvCJnXc8X0KPn/8CUU2owJQrHs1Ly05V1bzQrFOvvbnWtvML89+uwww5gktinSgdHDXu0GQ8YT8kxvbj8QF6uZ7YI7KhrbamexyyX6HIZks54F8rS/t6tLgrEWgv0onVL1069HQ36lvLNeU00PXoSbeu5BxcPtvpnV59o9Z1ctMBe/tkMq3EjoOy+YwzaH4nw9A1ry8+r9TW82ltWFvI4R7vpjRnbMjwv6Pnqj445m4RqEn/hmLFE1sNQhANBA5uv7hWKxmjfFKXFHgp3UKXwIIBiooIxW1ycyg8yLM1QVmapUE1NDPipP3II/CfHqziRIHRBgqsm6X6wmnO5WVWsoCMDqGJofGRwmFRd684ys5bhtPNVMscfvI9Tg7JYldARtjpFXnSzYhAGe5T9UqqSN5z84eksVaUI3tQR7VcH+U2q9S9cQiVd2VLSP2k7yKldvqk2GT3w1H84PR30SfcuGHyZfygWfU/w7m/GtAUWPtk20mp+6y7cYwfunYlvDG1KoMdmw4oUVxH0LSs7hABES/EDyjiSLym073LzxRbC9Sjv0Wwt6PBacTMlJa2Cb0wF+ld70RZh8wCZkGLGMBi/89Pk5wX2rX54DRfRN6jFP+oxQjiAlfQXIBZQ0qrR5Il5YT1UaNcVzj4PUcS6teJxbQ3vKMtdsQhBU9bB9cECKjw5rlqXWuf2x3AxBgSOOhqAwInLO4l0igfcz1QeiVHSLQRZdpTDbS6Oh9qcafdh+kt7EpWU6eaJ0jZB5QZVZGXZPEwq7BhfMHPhrO987Y2Sd19HeLh1AxsSRL7Y
 hBGiURY8
 N+xux7fmeN6zDJpHFWydItyM3azLMePrIqCYyW3mjwIJozbmIQw7VxgS2jw8sXcnzuztPvyJAZfDFz+8szs6Vw91AegNln4pIPdeB40kLEv40u+L0tPYLf184RQ+kju5jlL62bK29T2HGvvE+6m7qSnzRKxVj1UzY9o4LIR7iyPnjdU+0GRFWigBP5pgdpgcGkdQI+HM6x7SqQGqipbTjhh9OsXWe2NE+xnE/eaCqJDgLiPWztE5VivvHqZ7laR1Wmu9xqzD/AbGGHs6I25IRZLHPa77txce03IRhYGZi6Fk33u/EYb5PK9xII7fQKcc0SouG9YR6LH7HTKXk16x7serFjjprKX9JCB43iFP1MCTyI5zAcSYlxBSzT8D6mbCuVjjADQSbNWfFtl9xw7iqU2+al/zuuNM/7kSCcLGD/FIWw9WEAiQmwzbTuc6DNiEH/EVpaXERiGBTDhjEQp7r5p7rXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Now that guest_memfd supports tracking private vs. shared within gmem
itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
for x86 Confidential Computing (CoCo) VMs, so long as per-VM attributes
are disabled, i.e. when it's actually possible for a guest_memfd instance
to contain shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1560de1e95be0..6609957ecfea3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14172,14 +14172,13 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
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
+	 * INIT_SHARED isn't supported if the memory attributes are per-VM,
+	 * in which case guest_memfd can _only_ be used for private memory.
+	 */
+	return !vm_memory_attributes || !kvm_arch_has_private_mem(kvm);
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE

-- 
2.54.0.563.g4f69b47b94-goog



