Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB091C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056B36B00B1; Sun, 30 Aug 2026 20:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E7C6B00B2; Sun, 30 Aug 2026 20:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85AB6B00B3; Sun, 30 Aug 2026 20:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D40C6B00B1
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C88F1A03C6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:35 +0000 (UTC)
X-FDA: 85159671030.21.B3CB64D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 43B1020003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gyYzRbzX;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135933;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBYOAv2EFNrtWFHQT1ylsUvnwUropJ8IN6Xn9oiH0cM=;
	b=zDkP0M1xNa1BClR6kjQAmetCok3OfcxQZ+PiVTUwSHWgxWJAPSvMoa/mdcafvoY6z1BmYS
	Lka+H9l7/kvf5yrvgilxWcx0P0Wctkcj7D8SuFgiv9qzwf9slnqhGHncjHfAi17YTjrQRm
	4kkcaeEQLoo6d8MX7dR9JRqOi2CsVu4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135933;
	b=IMcCWmvQipX5WxSKi/0o07qshKCcVwzjhUPgYbkuSNqEis94SHwsbITMhKiUAitruI0xB8
	tap02z96jZo0ZfhdSo8VKlkeYtDZZCQ6jdpm+M8N8jQlDvnzOl38y0GifNBUyVJ9SuTPVX
	eSimY3hswAA4lbknZpzMifjvlTQrkuE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gyYzRbzX;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 35C91448A1;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 096CCC2BCFB;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135922;
	bh=9EkpEqxMLjQNDYpL+7i928KW0BKp0BAiSqRXLiWPp6s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gyYzRbzXGlkG/aUpiIys2LbQmRsW7tP50wUDEsyt9RjxvJ64sTjxOT3hh/k8Hdy4w
	 /fwFxfHMH7fRxj90PD7xEba/JSh55g2ZM4d14gJ/TSaGDaT0pImU/S/v7Xv/qJo/Xb
	 tu/MCelKnAxVZlN0r7KRn54+V+a0/6fi2RFkmt4av+ChvYzGOJKjvHcWe8xsdI9h+Q
	 XDMxxlXdtvgro814Qmu1PWjZ5th3gM/KubMPWZ/mXTJzFDLXnNAGALHc7jQoRPJb35
	 Hk1JTxKCTvRb0/erM0C1KWQGBKeUbtdQgAdTGiIDqdW3guhLOitVVrEZUwIBOaWrxo
	 d37knLUInc+IQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8926C61DF1;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:25 -0700
Subject: [PATCH v12 24/45] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-24-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=1693;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=3+Z8h6K2ZEH0/i+xD8ty2YuUR3PhzVzKd8N9HPdoh4c=;
 b=kFzzNs3iUa2auFaXzj1DJYK15zRovrlFdOgPxqF+B0zfKR4KcuuLFX1O1DbwmGlWyFFcc13bR
 c62upXEB2l4AoL7J7gxH3T2810e7NU8NfEcZrGUtWkWt3/4kWC/EnPJ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: xrkxhs8iyqmomcbbodjs3oo78m77tjmm
X-Rspamd-Queue-Id: 43B1020003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135933-59575
X-HE-Meta: U2FsdGVkX1/v4hpHF3uAwtrGuVx7hzw9C5epc8sSFyH5+mX2NJAxxtbBugJdEDL971SPhKMja8Er12MnP1wDjq57VHlyyB5wr+b7rQSM0CVZvGD9AWi8XSbSpJBa1IMTaRz+K6pmFfMhxbJ9fm8Q5jTZRONdVKXhsXthv41NCAUQdm4y+E9cPkzkYv3MjUzuYNCXIXY71a1birl6H+nBUhpxV2wvaQO2RJ64Xgrnai+snTenBclenUkBr3y3T8lZp4+DTYq5zxFFqShNAZJnfei7nIuLHyyDbJqAbvAcXURk8jwM9hbbKrDtEQqCTXzfb+ZG1+WhM32zK4CgoQ5klVhvKC2vG4zil3vc/DeyzPx1sYPey0W/ExoH5wA5SeoDf0aeio8c/xkySaOJztdGYeLyVS3tbFn6lEqJnNEkr0IDXSqW0gRxKNpnFpcaszKVK1eeY9G8iSW9N5QmX+VeW7+C5EXWnsfjZyOpDIAZVrGEHuxtTr58J3aVwy29HxtZozifYxxCTLAXCmpxBD6rjJVjW3FWqK9yhq8f616utSvgWqgAn+0hGEt7JORVzl+WMmg0ZyOPusqmwqUZ9pk9U9fL/BG+AEPxPq7EIzcCqRLeer7ivH3k4CdYjd091hS+S5G6/3lwbJW7xUgHGiwIGHCgNUNeKWjFDlzlxzBBe3fmw1PPKftJAq0d96+gS+QKpH7mbCoZe082uwQ67F5MhnRcgmRjIMII/tsxhBPmYIrb6THdOL8kWAuyOU4P4sQr5M2VvmYGqkUqL383C8LShdpI0PvFc5RvFhmPU69w0bY2q5egjcBjkvPgWQGIc0msj0xre4EafIocZhQL2kueUH7g7K+B/Wx5ZSrt0v3TClT6EoYEC+DKbA1LxmqyObYaFFad04da1JuY3q5/DAD6rnJfCajd5ujPz0A23DpDosLo8Tyl1OXIZWfniWcEqv/RBqTnFc0+C9aaqH/uCmE
 6kjdH8ht
 mMhisR/5+Um2Gyq/frG23Tz8okjWOMlMpsMGdgTJ5gbw0M3yOiNZzPOSeKS8AxXy3Z1zgfNmgW38lRU8Iw2ChsllzVpxYFZk8R0j5LUTFn4v1pML69hyezhB4jHx0FrNIaBajtOJbN53su6xTKTSjVNV29MJtzDmugiYYEnsciMWiXR/I46cw/bpHgVw+Tl7gJYIob8mBW+WvbTVUNE8bzSj8PT3dw5vQ5l/n3OHTIhFAhRWldOGm5qfzIB6zZJWdQZAgBGZcBedCB90MRhsyjYLFzMCaFQXkVOFGYBGtmfnZs4QiNXqX6VSh7H8U/UXO1g+bWaDK+AU9V066Ed7O+OiqxVeefoNeeOKabR1dyVGoW7Ai6wf308t8s8Owmu6S0OaXEPg/l/2eIqtRrdRI5xi8tzvDyY2K243VmS2HKpEqXOR0joaEubG/3tgCnzVdwO6GE8OubNrl8xdfhytyFfQ3HHOqqxVhkUq82zZcgWHyqdyVxsFL3mX8Elhg7nl3/TadFHk+5GebAW6SuqZc+SA7Od2yMLjX6Piv+YLFVtBGs/0=
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 75e03a2f79db2..c081e4b9b25de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10637,14 +10637,15 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
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
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT

-- 
2.55.0.897.gb25b4bd76c-goog



