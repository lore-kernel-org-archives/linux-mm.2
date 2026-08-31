Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9838C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA076B0096; Sun, 30 Aug 2026 20:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C3F6B0099; Sun, 30 Aug 2026 20:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAEE86B0098; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C17086B0096
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4ADDA403B2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
X-FDA: 85159670568.15.BEA575B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 492A9160003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sIapqrWK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135922;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1tPEaKjhDpFSlrXza6aL/Mbxqjg4+rmKNs3c1xuqug=;
	b=kOM15zmWbwLXNRJCM9Oihe36jqGIZOvnZRaIzJfrrYm2sac0M7HW4c+dZ2ko75DSZhfuRi
	yrAJ7NCc3evHFGEp5GgVA7FfbrA7pRPSTyuGWvJeJm3G08Xk1icx8HWb4uppK+UHI08MkJ
	2niF68EzxlrweLsiccE0jEC0Z5bDEr8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sIapqrWK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135922;
	b=TQz5VlBPswwjB1MBD/ZIrv0hA2cL/mjBthKsrjmwdYTQahtMTZEIS2Vd1MTEEATQzPX91/
	dEKG2hbmGA2QtEUTsCtksRMd3Y4HqxpEAyavofxACV8YxcuvnEdK3WVDGvyC1pv2J7ZBVz
	LozCKwBYLGzBtF+g7iUMvMcOGKnqcuI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D0FD444E8;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB26FC4AF1B;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135920;
	bh=JofTZBDWcojn6WUeVdQV9Y+aeDYMG83KVX4oKmgX9pQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sIapqrWK8NZxJH1HWgqX3hV9HnvBMlzwJNaSEcGDFZL3S1oa48uCXrhAVvMnAf3C7
	 rYYWKQ3swEFgW+rexkGgUsNF7Ctdj05Z6Wyza4FsMw8yi6jA5PECRcmrNTghFiC1Hq
	 gO10D4S2dMvXVTYiWC2u27ZxbZct5K3ktddLN691Cp4qGFTb5XMLNfamUCPm7320Hz
	 LIer4734/wS9RrlJJLF649fKrWeJBXeR7AME0HPW/pnPL2gX5wHn9TTc+7QeaJvArj
	 3+/RTWkvOpBkAPLdZty8pgN0zzAF5T01cR4gXXpqUiRcHesk8ghuVCq6PNsO26uyer
	 ufMmZO+qp2P7w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD993C61DFF;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:06 -0700
Subject: [PATCH v12 05/45] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-5-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=2388;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Npw45RhiuLmUU1MwINVjbSZRhJ+VqvMGA2O5ckbiMOE=;
 b=hcW6l//v6f2eUwZw8P7Qz727FIbcXf31OIfmzbJ/LOZhc5nkpROp8zwh5hMXWqpp7ERrejoqB
 F7AAbMsg+GBDHdwp37rBq/IND3M1JNVanBPieJM9VYyO2L3kDVkp0n3
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 8shbcg7yaauq9fmhd355hqu66fo4zunj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 492A9160003
X-Rspam-User: 
X-HE-Tag: 1788135922-733864
X-HE-Meta: U2FsdGVkX1+lkyos+YeqJTUPjEh3WLAEGSmEF2Ir8lv/xnSsXn7FYBO3/aT0PpSM/gJRKTdFrRBqdjooj0/70D63nB6bofATcX7uAIGG8Mlilb8QsZ+LD9/tGdYC2kT2kHhJF7FDh1x+tRjoMClWFYpd+3HqT8czy8WYGwq6orv6hMOfmR58MGFoDd0Q/Sf5rmF8ywuxOb5lmtItztADiK7/Bb/HTZsUqnJ5dAhia5U6Jc92u5k8c7g+cVLUPwZzSIQtTpvN1SZ1ekXPyG4ZtdonSJeQ1CJg4LmYsqrQTPoTsVquKgm/8mCnOgMq9pPrYD5+hYIi/D1LVusxeNtJ6ixAfKZGYoj4s00d47/YxjKVMHyIPwU34Qd2Uy9rocJxaGgiQwXXVzIJwp2TBJWIoo6dwqVCYSr1Kp8rn8pjsJKNKNMA69ECRTOmML0gYBQ7n5SMUv3MnYO305d6HvIAz4CCaCQPw2aTTWtK3JCROhgvJ3eMhujuqkY46bAXIRsQr/hlEW2lh5m1769Lz1n6LJUXJ6LEa8+Ji6RKYYyH90wFEatu1bjoM3GRTvN61c0w0j1OqmcOMoXVxgMlx77UMNNiwOG/ze4YkU6Hjjrpn1Row5KIJ4VXOctllyGQ708ICfSyQZCkI/jIOc0ptN8wPm/89Ninf8BreMxOqkqf50agQQyP/zd47ksLlM3IWLDzL8A4XkT4tCbK7Ia2S5vPUjgUQQAy9d3mfnUr8rnEDltr6E7fvaVwvc2XufyoAeyv/hHUuWvGhBsVovtjYdveyuh7+d1NYq9/mHWrKAIz5UXHT4ia73cqIUGih6OJZV1RuGcfXNPqPQmA0HF4D/Wk6mSso0s6QazTEvMt7hXpv2/G/dBEWrk+vV2ZyFNphAUi0wRfyuyRE3Azn27/PDm2FaXD+Wm9jDVrUN/0S+aOUDXkrW2b/6B/lJdWa1waNk0HbLb46TQOrmINgC5barK
 CLZQnXYQ
 S6O55eqKSj01godGwgoFQe9l6ZHg4dNWqjpJKGp+QqXI4YUBNaEREFRbYY93ttih4MAMFOtRM6CLHFDHDQqU6p0Zd8SnUoFOanGGFPFIs3japFfUEAYHRQbIGbCkfIclX7LKOlYceGm+LpyQ551YoH6svZwlraC1MXcIjLO08pEcWBQemvfTolfE3bdHBPMlXV9upH/d8qIZs/RkhyeKsd7jnizYiMghEGkw4+Deop+ACQV/F+8tUeFMXiocV2AZ9eXiwmcAeqsLxoIJ7Fhd9zjtKTpC7DvSexUloHVKtR/sU2/PkhA3gQC/+845Hi6Pi4hhodHQDd2XdVtU5hwjaBtuHE8Sf/1M5Kvlbl625byvF+PPbhmzE59ATe8geZblazMy4cCI+awYVVdgOHaPvps+vZZTTeWk5RF7ubnyK9bB0zHZAtwo14CU9KOFT31k0fzaYESpi91OBKmWZoYD/tUcx3D/V5gObgkaUQUyIrf9Yx5YWmoYiVAJFox6SD6lQCLIA6Lh/p7/Vo36YQtFMeyjNPZLqZo63bSb0zTWgce71WcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of tracking
PRIVATE vs. SHARED state per-guest_memfd, not per-VM (to allow in-place
conversion).

guest_memfd support for memory attributes is expected to be unconditional
to avoid yet more macros (all architectures that support guest_memfd are
expected to use per-gmem attributes at some point), at which point
enumerating support KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory
attributes being supported by KVM at-large would result in a system-scope
check (NULL @kvm) over-reporting support on arm64.

Give architectures full control over overriding the default definition of
kvm_arch_has_private_mem() by removing the coupling with
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

In a later patch, kvm_arch_has_private_mem() will be defined based on
whether architectural features are compiled in, and made orthogonal to
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cffa16647f2ab..b45fb80b0aca0 100644
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
index 7d5325e3cb44b..050757544a1cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2422,8 +2422,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
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
2.55.0.897.gb25b4bd76c-goog



