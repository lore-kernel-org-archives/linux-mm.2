Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91452CD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4076B00B3; Fri, 22 May 2026 20:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453B86B00B5; Fri, 22 May 2026 20:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C29E6B00B3; Fri, 22 May 2026 20:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D757E6B00B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7257CA0A1B
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:14 +0000 (UTC)
X-FDA: 84796772508.10.25FF935
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6919A40013
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DVdW0uTm;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FenFzBfxteNmPAfBX1ez/F13lUFEtZFDRnex780DdRI=;
	b=sKntAlbyEsp7RRsnGdNskzK2+3e5KsKfubhj26y/E4owk/OTVyJJc39FxLZYrq9V7GyACd
	xoH/uHXHfJy9eX+NdKXhSL9cmCyP3imeNSRWOJRsKKM5hmrrHanmDFRCcf3IclR97Sc3Fo
	FCKHQXJozAczv0lVoUM15OxA9jZXYms=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DVdW0uTm;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495492; a=rsa-sha256;
	cv=none;
	b=BNIxv25qYY056L4V5sy8NBJZJe7/WOuxnnvOGCGwj+EPTHXaJ/hL+gjKwct16JFwY/Vgjw
	tMNo1qjsbPgPJTXqjHUD/3N9gTktZeAgjLMIqSTcsxC2implcAqB/ELEJg15vVC6dhyiCz
	lbJpOewbV/tPmEUkyAEYJXVMvW6BI0A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F913446EA;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DEE0BC4DE04;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=QVZpcgTulF4j5gS9QxO5iZFGbvYV/y4Lb5gUEMxhu7M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DVdW0uTme1FAuV9lVIV8erBHPhh+n5+VdHyrh1s73tsUqrhKNDzeiHPUk3vXHaHs9
	 4g5WlM7R0OrmMUK3yGT8cgFCwKty1Qy8hWEYc5OpHCbQyut8Ka2cCVyYc9l7MmKcx+
	 4y4Lr9xrX8xvVbu2h97U+CKr0vzh3TQU6QozdDDlLTFH6gt0yj6uNZPODGfWLBwQEv
	 mUuJ70Yno363hoK/V35BA3h1zrHZcyfg6W0Xu4+DLvNqSCAAjx3Taga4zBwztBN5jV
	 veaMyikKypM0NuE7D1dqD/u7XDOERuCLyNx28w2stWNsL45buy1mcT3UinYbJzAQUf
	 hy0Ji9mwWZAJw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB5BCD5BB0;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:01 -0700
Subject: [PATCH v7 19/42] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-19-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=1434;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=q/txV9fzE/Qz/zXX6ODj/OwiruNNlAeYA0AW0TGz21w=;
 b=RVau5dDenmQbkbvkhJGu2PY5MoFj8qo4yqi1kMyAThDpWex3xIWcd/A6roBnVqFzgo/+LSH2L
 U+C67sZmdLJBMJYDFpE1Cm6LZuk4e1wBiSHZ1mSUsV4jwEkJxKcvoWz
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6919A40013
X-Stat-Signature: 4r5rg9ur8ia4qjsbamrfhpxrr4p7js3a
X-HE-Tag: 1779495492-56596
X-HE-Meta: U2FsdGVkX182FLf7HoSZGm1n1C1RU58ngYiNuEuvE8dsdK4X5fDek+9rsrdJlyM6afHCw/rgigF0x/8GXH2+BTBXywHzHLQGjfqD1MZplpTWc3GwJDjCxi3zSx/EsMwkEtZq907NL2b2GyUSApnekyXIjb3oz3MHkyNt8mUxY2+pQjzDm51bEr0mY4TyJ3dkpLbcDE5AQUU8B/eCW0MBpMMQeOEsavCLhcqW5iRpKDllVG/o3Mp/lNiFI+WHKXswjhQC6BFdkWg9LxVaY0coSszggBwgRGvQnpm75o9evlYELVdUA0tPBLEvzv5at7w9jx+MAODqlYYmxkTALE2+ZFft3uhwiiI4YZyWGEqbebqxzJ4mF/vEcNcyBjPlGwHDLtmy9zj9l//GDkn2s7MbhTOojHaNGtzIbt2FR0lqcj/EAp36c6AXVJjiBduGA0xvhiONtVQb1c52gPK8WjzM5crvcbG4YLVDspaOP1WF6KKwgsd7XwjQzRCKOa5EGDra8EGeviKDRsmFTYhj8dRvtEwoJEV5ECEVLE8YEc9NjUAFmn9Gbx+whzxLIOqONH3EvmYrjP9Sn6cBOLATYXhkAVMekimSv2toribNYdUFl578UL8bZYhQafIGh3DUJnQvpsnCb3J4RUR39uBNuCTUuKtyqqvdZVfru94/YFTMH+d3Ha5q8ZxSHm05Tq3IOKvmHuYIBdej2d7FmbEVdDw66HXW58XjLNJ0Hif51MN2GeUFNhdBIn1Z6qPPmrp52EpAe9xP+VYQJaEWwy5zyB5fE8fkVOmvZtXHpYPqHG3MUHXMVzyv/c/DEICTkI7YvsIK1afrYSLeoxkoYqmeGXZ4hMHcIwwK8fgMCTnVy2Y/S4+cevOHdQ7pc8y9YaqnF1HRSJtAhxEpxO5XyiWUvQhibM+8Fh2eOGu2g4yUZzn3B7fGeuOAj0EBUKbcrQNqxco9uqUvF+M0RLLdRU8X39g
 cL90RERp
 nMfkhqg1eqFlfMdX0Q9jN9EZDZKfBJLbUTEheOT4Xu+a0ybXotO1toGJ6UGAI2HI3iS8VSxev80ADR/TCdFp28qXOqBxxitx4h3VDOzfrBrMqQpNUGCJ2UEaD1vCth7lKQAAcecsqkhQBXl4lgeeIzHWSLLPO8rlTvufWkNUz/Iq48B9S62ry1P9cw2oXdGlgHKx6V13E73JdB8LNE4VRP60pLrSXcfp2rNlYr+TEd8HUz3Z3bjTY0orqL5YlIRsWM60forjnrirHLAOfqtxwT8PdpmmJgGMsa7ETh1fCY2bJbih40eVRZyubglGAsH+RUagHohmrdcR2tAgW+NZ409Ov3zFyzL3pC4lpActgp/yWSwE+Ex4WYISfOKRRj9Mn1cOfMAApkArnANjg+G0qtHwgdYbkS7Y66BYaiwcSd3sHqI/cN1Z2fgrWKEePrn19JhHlxooUkqg9Wj4CubX4WGuDEyfJuX02+mV38YJcblqOfv+gFuuM0mki7g==
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cb4f7432a073d..e898ffd21b608 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14158,14 +14158,13 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
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
2.54.0.794.g4f17f83d09-goog



