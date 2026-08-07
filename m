Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A652AC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F2C6B00A4; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FBA6B00A5; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646C96B00A7; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8FC6B00A4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 942D2801F3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:52 +0000 (UTC)
X-FDA: 85075823784.06.81319A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 91A148000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r96v3Ova;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139570;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGHRJjOGwFwjdIciOnL0kW8pGIKZfAXHQxpr0tp+DKg=;
	b=OgyuU30wjifa4RaZBxEvBeLz8lUt9oa7Y6/1X6DVdta0VWMZ6WS1S9cpXj8PrnLqxiVFoa
	x7sIoNc69lbQupgmox1929uKP1FJoA3nze4SRHziGDrNkWzNHNBmz4oTitl4uTDKD7B4pX
	mLvZcqRJ+dv/2y3Weq/otRP0guIAlco=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139570;
	b=fw9q4G1GaOtEcFsd5nXhidrc3e5KzgSQHf5TW/6CCAWBFmJcQ8LJ/JPtjUOGqpKeYLlM0A
	guAIqMfeKkvTlrkx95YvNeQyjZkBhDwjb1FjEsid5wmRiWrCOsAw1S+IOms42p/bGhVoaM
	+oaJtL6qjCqEeuoFnT20mOgqoBw3o9s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r96v3Ova;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 851D244E5F;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16E32C4AF0D;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=CYny0H8G1T1w5+2Vn0HiiBpDYPh6AX3u7WawyvebPVg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=r96v3OvaH5RV5b/doFdmZHVxUc/gBza7+Wmv5pnL2TBpb06WKD/0aDNy/lqOIR/qX
	 DWQhLiBz2yPL/ZXIZPLxq7jIa+aK2S3ofc3h8NZ8GrzTL4apjmluT/UqTnd90PWF2w
	 MZX0uZi0dg7OCVL9WgUoA4oSsahPYO9sdU5kycw6MHvqXOybA4rYWrI0GSAqMyslvo
	 KW8SX38Mm6VqvNOo62sEeuUVlH17XZxd15gqecCjbt6yw2KeVmgElDVYTWmcXJQikq
	 1E6zZPyVDrcvBpKWcCStpmwnFTYsU00e+oMUln1bgSXlXdEJEAjMLqh5Ic6Pkr3mDQ
	 DpPHWgbysJjJA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F1BC5ACD4;
	Fri,  7 Aug 2026 21:52:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:43 -0700
Subject: [PATCH v10 04/41] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-4-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139564; l=2340;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lFRsujEsk43JmAvWcgvkvnyu0Lj39PjjRyBwxKpEywk=;
 b=grHE6Tsfr/GTzaFa3DypnMYU/6GjDXIIps37lx53+eCQ/JceF11Nx9OhYJqWN6hiC1v6rBqMQ
 p9UTgoF5KrMDwHPxXStn+EGP6DjqH7cyGTEklh93j3gHn0yv4HEbEPu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 91A148000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ednr377bh1yqbs6ozx9d8gamrku41ru3
X-HE-Tag: 1786139570-406319
X-HE-Meta: U2FsdGVkX1+FWsA2BriBJFL7aqdFX2p8F6jr3QtEZZJc+yJ75rTH3X8HZdg0z6GZGhOdFlxqN9vI1DcMfGczssFN+UqRXGUHXxELVYE4IWeC2EDCVUbRyCVWon7mYjpQp34ZPxbAkMeQjuD3fSn3zT9NYSwHAaXjELCuJoWtkB7DpEVh1KFb2JS1/nnAWu6yQn7aPD8Jy/9hTqAZhDRHjr+RJcryophCgpYR+obsjzjNZ82++Pbr0rSx0+bfgU48hMHgDMqEBfNn8TK+JtkIB5HKEKKH1O5r8/NrDr4dvUzBQAZXCpwtfotMi03Qlj3Bc96jiv4fZuaOAdHiMx6w2jr8rzGQqY4QKH6CTF5zTc7jLMdsM5pkt4ub4sgZu3+QbyKIs2/EbGAfRD6EfIQlu1k8QD8iUn6GyagMckcRX42xyIk5RcLzZT8asTaG72P0MqpHhw2d9Y7DpbOpMWH5zNIjKunFm2mub/0zaWbUnkUD0kbQ27stNErKQyxKWQzX8BvUeLv8/jSYgePXk6+3JLEK3AAoJN80H1ANeF2CnCoi4jy6srCZ0SsKuYxuEQutalCUvBCxEZW5XPW8BAJiS6wL6x8AZp3hJhz9oWVinuZa8PJ/X6XXvMc+fBOFKZVW0HITuhuTRTXZaky0CMWP/PguW5iYVPAvEHdyigG1ykqY4HYHKDscBHmcmMxY43TIGLgIF/8sI9VHWCjh7pQfZpfuoNDw5fb6sk7nxMhDA+rk0VDOtQEwKVqr8Iesmx4xZ9yTh6b9P2GvMkkjC7fCXlYeBRtx/KLjIonXVCll/Uf8vcIa92C3YwSVxV/znrdcoQldRsXJ4wzhTKLLERl3/Jvhvb/YDQa6IyoqH1HStlvEGziD72Y+K3i+CA1jOw1pv7OGEoX3XTqvXPb+I2M6GhHFZ/XTZzvflA3EypKWwI1xpZuKu7Ol+G5DTa+9AU4krLK1cxnGbFJ/si3L9iz
 R/9RIjbF
 aKAm3MQtlR51dqdrOMNcEW3y3jjIOp3Rm0uZM2SNsAYAY19jC1ToSBMau7YJN4hT/JEGh0/cAttZ7RHbjur51cd4oDytiOcrWzXAXNkcIA5FiEKip1Zd08YjposkzU98ugZCCY6IRp37Y+a+Unjj12e/LARi0Ctl1KDlNukfo90qiOoVfSwPyauXeLM6OPBURaSmFr6K95tuxEXC+Uwb0Xv4L+UyPLPXjzUwTTwMtgc0LK8TD3E9xoIoS/rYcESgORb6WwXljLc3P3fBV6BqMDwrqxvr+nqo0VGSZl+lTWyb+ut4AYLGD1Mn7KrMG1EY04dYgzLfTFVI9vH8N3ZWBvZj0k5OwwtTSBTFe35yNVqT2YoO1aZtDLXq5OjXUpa+64FwFHG2ydf9VCnvLQGMOeLk8zFkKLRyP7XEnRg8Yr0lcjODKax+PQn413zYQ2qUXPajTaNLdvH+lyvb4CIE1MicBdpA/Co2BgdtN54MHjMnLY7GjCn+4C7LLdJBclk5xWArCQlk7n4OqvIVg2FKhSY2jp1AU79MlguVKm3hr8hLeHJPVCyS1neDVsjXUM1CZ6LvEVTWcitYz57g=
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3e86cdd00e59b..e3666d0b40b74 100644
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
index e3a77d1e6d8ae..560ff05e95959 100644
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
2.55.0.654.g21b8a5bc05-goog



