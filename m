Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7914CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10C56B0098; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1B46B009B; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8B76B0099; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 611B56B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D25038D038
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
X-FDA: 84894784380.02.34DDBF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E0349140004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nM1G3la4;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829108;
	b=ygLJaHOS6ptJhRSEH4C1IeP8dMMjjbe2dn9IJ7IDUIKxKnNY/pCWHFqs4+ziNaUpU1zRHb
	ZwVn4J9Cf2Q79HQI83n9Jj/Xn5M7V/CSJh+/hmwhJW6g8NY6mmYduB++yllUyfA+otYUkW
	/ze0h/bSwiUCsDCFb1djKWff94yGlb0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nM1G3la4;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829108;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFWM+jZ/aYdhbWv+oe19cvk524J6Sn0G01q6aP37c2w=;
	b=lpiH25r0zOM4VXdTp7P9RwxtHsvqbpo9QgOHr0bxrt7fGKfGwz9jnSdZcdaRp4oSnYZokK
	Fqd57q0A43FdqG82pPt3k9aFboURJ/sFL9oZZ7pGAlaw/v8CkN/MvFfUGhNJlmWt6nFtr7
	v+Yj3A4kNgOEcG50m9ToilbxIG2qE/0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D6DF860204;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 428A5C2BCC6;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829107;
	bh=p+vf1GdYaw06rsC6TMPpIRLPdjCPTGBRF9dsl2QD3U0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nM1G3la4k0QXa+y3q0GlZ8ct6mEolBZss4IHPuHtGIc94Cnf+aSVVvLBLsVpelvWI
	 NieYEz5LO7kJ7tXHb9jXrMOaXtmdHDqP3s8fshKxMO1z8wHm1vtsW1hF3XW91EO7bW
	 KsZ+N2KRsGDB744+wyGKWXHyIriLS36S3hKGIOX9SABYf2P3qkwjyzZ8pQNIiJuVQM
	 O/vLnhRpKb7j9nk3vIqDx5gWEto47V/kbdmkqsih1j4dt3wVdF2gS0cqx6CH6BsKC/
	 PJK4sTDb8BkNnT04vwZB9XW2Gxod5ql0Pe5kLbpeuHVxV83N4KS8mnhzCut/hPCXeQ
	 fxTVwj7W5bAOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3932FCD98FF;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:43 -0700
Subject: [PATCH v8 06/46] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-6-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1346;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NlhDvu6s2LsU5LP3fL2aGUwPEeFEOfoSWubQJ7t+Epw=;
 b=g8yrBpgl+kkcyR4bRSSfBZ/OwtgNvrVufi9s2nDmNOBH5Bt+PnBXSNIoAngZGkVva9SLPyKFf
 Np8MD2NXB5EAyHSfAB1GyfXFd9sAcL1OihNjg60+lW0zTPRqnFW8rs+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 46axw1pkhm6h3hbjpjmzftcbhcsia46z
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E0349140004
X-HE-Tag: 1781829108-574939
X-HE-Meta: U2FsdGVkX19otx6QQSVx3anaIMzgk4gUlgyCFE7SXWzB471WsjWGjbBs92GaTptco/UP3C9JpaFevsqO/eg4ePCbeZWA4DA4W8Prrhu+fn3vbBm4Donh7ppWBGZQu5nP/3OWmNGTp18Y8kSWjY6myBK7WA6pSFvKyjqLQeWowCRSm0J9AeDWDY8Boxjw/dzy7YBGn/UANYcZGqt7ye4EUcm44JNfu9m9o5lfUBw9ET53KyQJNXP6VGFSe3467G2EiQHSea+/BTPuizPj2AmY5uDQBJvKUK6cU5gV63wFT+yYqmXQ06apadN1brBfDDAaTA0HBpkLnOgkCHrgRkXKm1sqJegjy62PJ4r8GikVNqRGsxUNLC5Vfn/YIKwWqa4o1h6sSZlSKVmHflchcvwt5w3tWJ+Qer3RjIIEKoXGFjKbOOLUyjIKx5SP2SkC+TiU2dclSj2WC40xhPhnnKXR2ftwtEah3SMJmzxHKr77CAiqkymQ93tUBx+dIX53V3UsqFWpYQCadngSiAggO4fcjX3l8ligPqKi7QmsQaMlA5rgdAq2oXFF/EIq8bMkgsm0+MhazkOnetYt2lOH16k0PbBBDOVVpOF5n7SnkNLtIL21+QDau4M9+uxFNdvAha2qsRrXGbDTSK/djJN7QdkRfFNGnyTd31oRx4xxt3laA6X4b+0dty4xS6FxYYen1ZrEBMafPQ4EdawdqI7QYv1KGnXES5NmlfgYaF4/TmayWSk/Wx409wGlnQ+tqDGdBT+MPgoFAflGkLWg1WCTp+e2Ig1klJM7Ii3IXoYjoPwETla+gmSS2NWX0YHg31HmkKYwZA2MDNwpDhRB31ojnUvVdt3nDZtJDCLsNRw520FXZ11e8nH5tJsMDOVM3pT4Lte2WlFG97+AcMK6lNVM+AkMdwoXYDgiaoD1ubtdHeH8T91rXHH/9vRTzq7NYDOsEnRDmvQ83i1z/E0jBaxYfFN
 Mplz9Zau
 FeQ39ZGeZ1nMjBnTRBMWO6CKQwAg22B4w8T0bBULmZqrA4EqmnREX+5NQQNRPGb7lNKLE6lNcc9DhVntScKmb+ZnufNqmWp8LTjLsWAx1itF4Yoae9iBOyikbHa26fcNr5QVPRY0TAwHIBKO7FG0rl3opjZY9K6LH5H8A4KBVeN3enNS+A0jrR5XCsiVE50/NCni6ZgwxPybbq3OBFjFpecx7V+di5VkJ3/ARX91xjiY0GL6Tpp35aFYxbjA84RB6aGllVOasw+twIkF9128C8aFZ94TxiovhEY4Q20h2JFNCsC79m2NGR+ityQbMnfsZ/KXRMjNYf4t4FPheQ57CpCNEH+1SOZoTz7lpIgoKY6PJyidU9wLEgunJ+R1saEnW8mvTknOdcFDjeCZzASbj2eiBwDKwYiUVzvaH34g5Uf1FnQXSIvveC5PkTMfxIrm5gGT3THT2nKuPUqltVjJ5I9Gqeygc35ZZAlO+NPNjU/u8H+e35Yim2OrQquL4Nb+8qZ3I6N0b2rMR4l5uwyJi3JU0/suzVZNWNWWj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ccc4895a4c26..7b989b659cf82 100644
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



