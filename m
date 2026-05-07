Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14DCCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468FE6B00A5; Thu,  7 May 2026 16:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4401B6B00A7; Thu,  7 May 2026 16:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32FC46B00A6; Thu,  7 May 2026 16:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21D106B00A4
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE6B51C0D9A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:58 +0000 (UTC)
X-FDA: 84741747636.14.43868C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A428940006
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mvaP+oVt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185376;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zn4+HRAkTHj1gvzISVkdprQVMb5UBv9mj6PCSCdRk4=;
	b=3081oRfAXezNQnqdLfcgEa23EpR0D4uVxHPv4TnaGTD/01e1jWdbh9Jd+p6xnDN3Fq/61/
	sjPCFYrj+/anqdcuaYzQNm+6aC1+W5HKCXJdRRxiCqU9+plVZfgBvsPB9lPbpNxKWJYsQr
	JZs2UawAa5MmcJwfncQoa3cmOGQlrvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185376; a=rsa-sha256;
	cv=none;
	b=CDPAIH90ckCTvqUr6wgBGzzstO4a4ITlkkCwnpwXxgzbKZZsa/D8yaW0wCHZvfshfw7lU9
	gn5rc2dWA63V/qWEGXsO4IYuagg8AUlkgnzTiJDj4JXBUCtC5WqZZFDehlvAdmw25Jt9bd
	YfV61zjCrgRtaBAeeeu2JMjHBqw6IHc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mvaP+oVt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A933C4443A;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 824F1C2BCC7;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185370;
	bh=fFtmWEB2rVwOQInVf+/O+AAAmMZe98X9Uk/1RyXVqxs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mvaP+oVtXNE1T3F7BFnHbkR0Do5+V2YtbUZCI/B0LSJ2RoHZfunSBYn/JQRQSA276
	 u7KLzCm9oYvABACug7hPzVufNH+iIOPLpjsYxO7ytwcfU/u4L3H1KXwGZ6JTPA5UiE
	 v/NkmacUD+HyBiyP+/neQWt5EO5fm91bxwPYWFm404KVJwyolzAIgsv07DJS3J5Pkm
	 DAndgl+NjPQ6GclpKe9HAvyP9pnRJ+AAaDm3j5YC+FNyUj/yvDQDtv3zknIVkWefn+
	 pLqC8Iu1mqXAsOizt5TA2nHfpLr51doOQrkf2tiKqZuPo7yAZOkWYSj3X8slp/QdiA
	 BV7v8RDD8Z1gg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7347FCD343F;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:35 -0700
Subject: [PATCH v6 16/43] KVM: guest_memfd: Use actual size for
 invalidation in kvm_gmem_release()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-16-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1535;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=LSFEUZnHaOopcxqUEi0sDjR1Doime7tSJ4O6yqxwRt0=;
 b=/vOP4AdpdOPvG0vm/pWq6fbnDjc3tTn7sEYOQboWhIq67Ao5ApttT2OLD+kQoR9LNtnsKf+tf
 6p0lDRmkhG6BqVgy195ik79HDXsZwZRhvx0PXefOX24yR8AcenlQKt0
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: A428940006
X-Rspamd-Server: rspam04
X-Stat-Signature: 5at1775ppbheqzx38rbgycb9ttmbft3y
X-HE-Tag: 1778185376-49062
X-HE-Meta: U2FsdGVkX1/6TGHCLVe4jcZ59Xg9PT56xl3ea0kCrxRZr+3k0i4Z2BPExnMw1+wGTT863Ji2nXMWu7XAxBEJz8byIaaECQ6axl57JE/h8/lwGJKlAhkID+RyvHQ6Q8kdY27LbMycJP657K/zMILODe0OdDAZ8jF83k3zJoR4gdNbTKu/iG3q2q9a3sjMPpi4fSGa7HQ800/vTBrrnkWxk9WdaEYGbrSesF/Ec5uQ5Au8emqk+Y2wDL0Sp8eARp9P77Wjx7hUP5IV0ktt02ReW9Jxl+eg4mR8M0AnvD1pd8Q6cPhe5mxwu3jtAb3GyY2UPR8ctQk1+NGYxnKiGEoK9389nCbJ+7louUx0LP9p1ymQALwoyCeJlVebgyjJ9shOR314qWEKBT5l0YGFpAyWfyHp+xHd0ApPlbqr2GSZJ1gsgCQFD5DVO858dS2bji1wfV8oWdUorczhy8b/wXOTZjPcPLI3EVo8rS8jnXayJiFcAAtNdak+iyI9iuQGuQi2SwMemoKlIW0+KkIwfkoxT7PCR/r1FKyCR2tWQ4iy1W9dpEuxvacvxhbDJ/+mWH2CPOm3Vs3mb3E8WTz5/FKtjZ9mML4d4H3whlgydkR+PkCW3dGjePAdncBTPAMrTMDSHzduvvcA+1wzJlFgfCfDPkKL1gMynDgAJ6KOHvXP607hzTmkPVcziHCPdLhcYvBcXhM/pvMNUVCJLf4UUDpKKmzSesMy52gAni5h16RjDZWUR06AlIpMIjy0is7EBIfckHdW4Nz8MslRIaMxd4mRz2IlHTHTI0Q+DnVGHTGpdwZFUR9BJQ5v+KkldUdhltrx0y3U8YLJyEJm3ezCHhkVwLHaDUI9dQlLB2Fvy75gOScbTsvpsCathgSraIKMR7NnYqC8Xqv6bKD4q4T1imtZeNRQiBHK+gnpT5yNojF8axzNparSV3OI4F6Y58Oi41MXcb9Gz2453DRANWSaNh2
 k2bVch1+
 FPBSIFY9+UVGMviuaI6WycA/Z8lH1YwHTHzKoTwA0mhT3w5Qg0u8fvtSaJYZz8sGOXnKIchcTV87J7WCWObND/6YWFQ6NQ2tjheUv9+Y7nos/KKJyVMxnJV3lpPmqkHRJ+RBujnB1fEr3IBiV3SZP0zyatUPbFw9EoXTlvrHX2BjXJZnVjqB2SWV9IvnCBefLD0MOgzbSLK4NAC2NeXLCuZYHgCGKLaragtE/UNJejs3h7AZjbFG7Jwdx8L54BGHwqDmfFUNqJ4GfxO+QmKU4H/IOCL01Shb+Qo1eJhFcrn4+oWGsxa91KbaZfHJROm5r+Gv9iH6sz9wOpgoAgRnOurP1nG5r+gRE0xZsPI2Neh3vNxk9vhBRcVBYadX1z8TSGGHqbt/JQfDdwDyq3aZp48GhND6g9SsUbe8VJJISndxhFvIvN6EBv2avJ+jXz7nBfqbFsP3JOcSwCg+WIpy+cW5PGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

__kvm_gmem_invalidate_begin() and __kvm_gmem_invalidate_end() actually do
not specially handle -1ul. -1ul is used as a huge number, which legal
indices do not exceed, and hence the invalidation works as expected.

Since a later patch is going to make use of the exact range, calculate the
size of the guest_memfd inode and use it as the end range for invalidating
SPTEs.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 050a8c092b1a3..9f6eebfb68f6b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -370,6 +370,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
+	pgoff_t end;
 
 	/*
 	 * Prevent concurrent attempts to *unbind* a memslot.  This is the last
@@ -396,9 +397,10 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_begin(f, 0, -1ul,
+	end = i_size_read(inode) >> PAGE_SHIFT;
+	__kvm_gmem_invalidate_begin(f, 0, end,
 				    kvm_gmem_get_invalidate_filter(inode));
-	__kvm_gmem_invalidate_end(f, 0, -1ul);
+	__kvm_gmem_invalidate_end(f, 0, end);
 
 	list_del(&f->entry);
 

-- 
2.54.0.563.g4f69b47b94-goog



