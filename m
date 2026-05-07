Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02FA2CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52BBF6B008C; Thu,  7 May 2026 16:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503196B0093; Thu,  7 May 2026 16:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4CA6B0099; Thu,  7 May 2026 16:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0EF6B0093
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF1F3A05FA
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:52 +0000 (UTC)
X-FDA: 84741747384.20.64A18EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C857640006
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CucW7z2M;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185370;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUiCNOO5as+t9SpOTNYyEpnb6+6980DZWxiJEZ+eTkc=;
	b=Nlma+9aIFvQOz2NbtsSp1s/g/geZbvYqUpSeuHiYBm/cGj2kt27XxNwSvHFWd4C9GxlqG5
	OUAQpOszJYuI/TXRJmS1axecZV0vYQUye44hCMjLJMpBbWIF5+dnMiisgQM8AEh7zkBBOv
	/x/8poolLddNk7m45PigS7KuE21ZmNw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CucW7z2M;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185371; a=rsa-sha256;
	cv=none;
	b=YZzv+WfhoG826OUjUtqVsu79wJAIuLrhD1W7bAt7YdrZr+Ew/whLVjdFE52GpOH5ijJgJ9
	soI/zisEz8PBHMu/6bDtfDq9o5PCOZ+gIPTgen2OCjIpw7+fhqbHpY9kDgJ1PCAGZzpEGw
	qY+oTM4x3ZfscTdXH4ZaQerLidiw8ds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08B084456D;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B368EC2BCF6;
	Thu,  7 May 2026 20:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185368;
	bh=B8WV1z5ZBpcb7KU1z1aPRcNtS1AkzqSq4lZ07UZU+UU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CucW7z2MRzVdcyGqDEhW32BplGGeRN6bIAAke/H7FWl0xRC/JmqwVmj35e8odYKOV
	 1c6HMYd+i9xtOE9OhXthGBVjwsjFIrWLUFssJJSHjJ+u7lcGmBWLSsPLilfqcxumvi
	 WPMidrqyBPmIX76X+hQyPGz21Y75p509WSqHgptGmM+p6MfaYAhbVBIgW7HYp+3Cq3
	 1deQl6FHedox2uO0fug2ezz9vElBr5IHVDW/Efi9DrMsHl/9ZoLy9V6VI7qoWdzafJ
	 bi/2Yt80Emz6VFSvxjTLcnilwxnfe3pC6MzfxAQVBlYlOF4VoJ4Lnccl+rKbpEgHYP
	 rmJPEhYoimkhw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0417CD379F;
	Thu,  7 May 2026 20:22:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:22 -0700
Subject: [PATCH v6 03/43] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-3-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1791;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=C7P/mxhz9DAqQzB6CxgEM8gcled6eZv2sqolJ/KKivU=;
 b=wcaEBQ3B5MQoFrzAYR19BhunOB2ZM5f9MFDFbzdWLENdn3X2Ol7qimhW1yhar7XbK7ngBzCyU
 JNRpOB+MkstAkaoxRAcGVZDb7Skc4II5pSOQ/pMcs2oHEeEEipmwlIW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C857640006
X-Stat-Signature: jth45djfi97eisd9rzoexb8wb4mipm8i
X-HE-Tag: 1778185370-543401
X-HE-Meta: U2FsdGVkX19SPW3m4uKi1k+TVLHQFFGmX5COUCRnNHYZwoaFqowtBra4bJQBU7zxd5YYan66g88sIRc089r4Q0Z0QJOVNhIdZgoR55glxqtsgM8f82IQmZHISuGaMDnsF/D0nbsZQJx13WE8hlLkkUBjrUOJDByWITg0VcuBu1luZoWtOTM/DRLKyY+GCFOksGVRmU4LsOga29/rRpsQOxiYGSpYnMb0MSm0QGTq2fjAwZOsgqlt23xIU27kngRaAzV4X9EmuBW1xE5t4e8Vz6UzdBiHb3T85sD+JPqCDYvF2ljonLwxfl56IgvuO2EZTi1LkhLMZGikFohCiuMkQRAXb2IZN38P760uZcu7vGHR06O1wmKWNGH/mAH7BUPVRqn7ILM1ojsuusCBH1nReodgE2IXMyHNU/4vWT6zFFr04COs0joM9zmJVn3vV7rr7tbAp4+7a0jMTeTcAG7Z0FMgqxulcC8fQh069OD+Wr9FCdxu4yPvcJav37X2zYdQk4xBd2BzGV9LYH/BMlBc8JC+GYoNqaj4RBhMZNvfY+qNs8s7zWY2fKK92zU0wSi8bS9AlMd+m9lNV1hrwMau8nrcbxAjtB1X8NNFMsKgaMVL5albFZwsEEDsvcnos2y/61arrOFpxmoTuowJ9CqipJ0wBQ2EBzHGuq2w8Tscc7d51eHlBfaC+ecs0XBSMBF0y5vkXVBLAezvSty5GjW0Tew9XZnMc79BymwkcOIACUjzIw2iuc5awoFA0udBD0k2UFfhq1SC7FsjqU6INJg90Eb9pRM47CHhYgWmDv/KomLKtdnKkH2iFABZqIl+POBFqWPiJ2hSLpK/D45IIdBx6O4McF+k+7WfSQDhqQ9jmEtjtIzYO3L9VdooX/ZloJVtLzJ7iImsWAHr0V3T0MxmNmllSNvsiEqbv3P2sZUcCPYgFT0kHKrqqzd6UBQ7koQrJtlYyVqEsvojyGiqF9N
 9DQDooBT
 pEm2RvteDzZuErrSsWxsk2pCkFBiH3HRSwgl583nAM0nXSkn08eKAEFsYCV2pjL8n6EWI3xSO5FqNPZTlud0/H/F8yon4AvP4anvuRTFfAFccODdYf16zOC3wTRqZ4joCRzCrz1lBpRiybw70eEyKGNG7ndSs5CirrwqPHs3vefC9NHkbZFR+ySxQ55uyVqY5tEGem9GaxEqGKcdm+eWonwO2E6azl5CWmhtnHRUNa+076FvripxqfFbzWFFfHzNrFppDpvrx11a5hahkXdkvV9Yd6TcpRFBv2wFfdiBvHt6PD3PUazkvSKERyDK+TsdfG4+L+IBuB3EyH4VW2mkttFCQeaUWWtwnAlgnW4seWINCzVJxQ1zvaTK9Gm9fDa/hSa+WIO1Hd4bgoMpx42852VxkMijCq7wOUv/3dk/likVrhSc=
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7b9faa3545300..7d079f9701346 100644
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
index 306153abbafa5..abb9cfa3eb04d 100644
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
2.54.0.563.g4f69b47b94-goog



