Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7324CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AE6D6B009D; Thu,  7 May 2026 16:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9236B009E; Thu,  7 May 2026 16:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726816B009F; Thu,  7 May 2026 16:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 615FB6B009D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D05C1C12F0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:56 +0000 (UTC)
X-FDA: 84741747552.14.3AA1F5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1298840006
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WDym27k8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185374;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNi3p/96Oasi6HbwQKZEB3s0vqGLoOI+ca4ksaUWB5w=;
	b=zx2Oux/SShrQOyqu0r/sTYN6Miub0YbD6Ykd4S99DM+7itma6KImSEIbcdzfijP1I0rfYJ
	0bdSyhRIm/cgPVHdUL8HaoIrmgtO4PGQROQnWi1aOYVolTrvqxidzbA2xECYllWQ3LkpXK
	pJLicb91Dzach+/7mg4kmaZ0mgFr7a4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185374; a=rsa-sha256;
	cv=none;
	b=0g2LP8lt0Eejm9/6HjbFVwKpXkIxMIyHCR8o65j+4eKlc9rF89b/6RnjIoEu2Mp5AC7YaD
	U59QBoLJ3K5Nz5+Y9/+jXAeV324J7wcGofLXTOzU9426yczwucxRdTZiAIzArsTOFgE6VA
	F6IfFVqirSnhJV5d4E5EVxe4KC1joYo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WDym27k8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A78484471B;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84966C2BCC7;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185369;
	bh=7/iZOc9brXGA8FsdrttcBxTMx7H7bwCNR6oDaXUYPLk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WDym27k8yH8Wf44xK4rCdDadbWGNI4sMuAD323n4RWUdhcTEnDiDYoAixYeHczjGX
	 aUjXS1B8pZZ5zMimuM47705y4OCuJTo+PmlUFm5VhbMCXlxetI5yrpsHRPK4k0aKVK
	 idwX8rgGq4a0IiDKNRGAhBXsjVXhnSNVp4yB1ShlfOLNKf1MGuD18j0Q5EEHG/D4s/
	 HnAb8WJ+qwzNTTc2PygPLFlnJy++7gN5ICRD2ttxixgt/hsGnau2uhebKVlyiV2FJD
	 eEubKNRwVS5GOdbBTRXXs/R+nUR6Ths3YMJn+8l3bsdAJygMAW2R3eqrmr9p/L6pXN
	 KZPb6NpKaQXKg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748EDCD343F;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:28 -0700
Subject: [PATCH v6 09/43] KVM: Move kvm_supported_mem_attributes() to
 kvm_host.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-9-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1904;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=H4KenV13dLeEqjvdyE3y5jRrxlJdQyrngi+fJmKc/3M=;
 b=RI14MMkYeomt+WbAOHuBgg1ipOXRaDDHI21XNVAJPh2YQQwbvdvhCfGFJ1+t3mohkUod3jgSE
 fkJgCBIWStfA2NuMm46M2fR+ccsXJzBqsgPFmYmUiI/IgKu6LsfGM3J
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 1298840006
X-Rspamd-Server: rspam04
X-Stat-Signature: m87qka6z584wahszjhg4h4t8dwss8myk
X-HE-Tag: 1778185373-793349
X-HE-Meta: U2FsdGVkX18RrgG9Y0V1Dgk4VGvMMKV193VBIPGWfq6qD8viZ8WdDzCTNEdDBMki3E4bWL96/b2Yb/i05jaEbXsa1FrX9NdDsCm7sE/Si2fNWg9bkQTbWLok6K8Z0kZducmPuc1zsBuEW+VSdIa0nw3X6lOFKZU+xPeJhYy5JY8Ixo/iCIikZsXpL9gDhj0b4lUiweVsXdr+oPLmoU/qX7ZJPmjkTXwKojqoVCb8dRBOwowJtMNe+sqygNMY6DjU6b9LkxDXI6ji0UmCakqxGc2iLvLLAMzJO6VNH8I8qAk0dHTuZlRksNDR0VohQ+Bt0KrVrJhtgD+TMwWzQGjjy7FEmXgpcX7NxxKXsTKvJ4fVsGPb6vNJSBWRtvlEfoVloKynY2JU19FGFwB+HB3zEoNaWd1jcU7RFj1SoXcE5xir4qGN0hqzzjp15aMZgvWHcZEr4A39TTiZyV9rROoag21/BDnnTbj77uz8vbcRXkuaJdIqGuc4Jh8glskT6BSEs9BfyCBNjIt/M+yJZR5xLp0EXvjpxLGKiEPjOKmuxYNZtl0HQdf3hmGI1QWNdtn5Dz9ANJgkAnorVpV1avoMO75s097DfvYiGM1AbYcBxrm5EK/2Ajnz9rtJ8/bp23MPr3WnmntBfe0NkfFfjy6laaABABRX5WjMURP0bHpkn7vEroAGM04UEO3eRPD4qhBTSBGMuBWfWTB/1j1Y+g7k5w6vVrK4mrqzWKt15WD59yxAR9z/3yd5XhqmfqzPsrmFJ/wf4F4pb9OYcxBc5opWApOPPPBgCJIkoiyoAGTd9HdsqgF3AA9h+BJpmV0YnRm8gcA/N6Zlq8W4s+vI72W6idyJ+DVq331vAYTbPmcPB6Ovq48EVTUQYmnr+mqXCh0T4w1Dh44KZ2ghy5yLNhci8nj8iotEfyS9ONcF+t7YPfm4FrKfLEvGjNLsQrbJ0xXoURKxOoFnFBOa+Zaqa+G
 75/guZ76
 q12qtU7rSNgFDy2QDOam83h7BB16Fez97YPWqcOfDDj31a8q1F3VR00wcinS4v0q3zohH8C7HxGFJIec2PP7Ri58l2XcPSXWNkW3xJo/qE52o5yDniPEKAu5ttfgaaNU+X+34Y/RNRohUY1YIEMOr+jngDB5hLMQCoU1jpzgXV239WEt/mxJB+3Fo8gMMA2MhUsOY1/QOVIWH6BHZxrtSJe6b65rs9mj6EOugk9F5woQrHy5gaknf3tJOlfBb2/7BHOeMxPLozSjskbQ6A14ER23+KubAEPPP62YETwiijyFNaFTqZuLwv/EOEIE2qdDmhqzAPQu9bk8VAOg9/fpXApnbbSNak35e4xpjI/W6z+dNlewpi3BeUhrQPIS42233grdT6FLVXl1WwRuNEZ16PGdK+vFkKT6hUXLcZ9g8HA9MvxqOtByZ+IpKWRqO1G3FkMUJfYRl+HnA6V5ctxRaZLP+ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move kvm_supported_mem_attributes() from kvm_main.c to kvm_host.h and
make it a static inline function. This allows the helper to be used in
other parts of the KVM subsystem outside of kvm_main.c. This helper will be
used later by guest_memfd.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 10 ++++++++++
 virt/kvm/kvm_main.c      | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1deab76dc0a2c..f9ea95e33d050 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2529,6 +2529,16 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 }
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+static inline u64 kvm_supported_mem_attributes(struct kvm *kvm)
+{
+#ifdef kvm_arch_has_private_mem
+	if (!kvm || kvm_arch_has_private_mem(kvm))
+		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
+
+	return 0;
+}
+
 typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0a4024948711a..ff20e63143642 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2428,16 +2428,6 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
-static u64 kvm_supported_mem_attributes(struct kvm *kvm)
-{
-#ifdef kvm_arch_has_private_mem
-	if (!kvm || kvm_arch_has_private_mem(kvm))
-		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
-#endif
-
-	return 0;
-}
-
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {

-- 
2.54.0.563.g4f69b47b94-goog



