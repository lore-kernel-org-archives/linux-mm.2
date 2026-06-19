Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 332E7CDB466
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432F66B00A3; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393596B00A5; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285ED6B00A6; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF9D26B00A3
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E828C18C4
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:54 +0000 (UTC)
X-FDA: 84894784548.21.3FE9A4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 72443100002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dRjHWI0c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829112;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfSFP9i288VmSddSVFENHfYy06XlKKSmS56FYw5+J1I=;
	b=Zfp+HfyLc8wD4wAl+CUqENFLLxzvNUcxMBNiovWHh4f4rLTFNqA79oPRItYqJpQ6xBwYmk
	4ckR7k1L5YfXBUSlfVSPCac4OdlkAgcY1mfCBsDAZ0p5gV2Pp9TEZwkvcutgDe6Ulvlnam
	uPZc1WjBpj8btn6IbSksyklvD+UDd10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829112;
	b=svdI8bKNUy/To6wiKcE/vuhkZjYAjoixaUuDbNhfGw4/xY4IXmUB1jUyyUxPs3wsiKsCbu
	t7saqhogthJ2avTZ7OxV17LCcAzZcWp2Zo5DmJs/nyM6Segi4GNknmaIdfsouh2CfzTtsi
	WW0pakUlwApXCw8ogJr8JETkrQfCB/8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dRjHWI0c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 146034462F;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96F83C2BCF5;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829107;
	bh=F7MrvmITOdbLitSsD7SdDf+3pf3iBq6uFTTR3SgUTnw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dRjHWI0cgUh4zBIv24YHAAf3UxH8apiobd4AzA+LBBper99l03UY53GtvuevljR0a
	 XmrWiBV9DdOgIyDY5A+MW8QndWZBFOWwcar7nkefXfL0aC2pkru735SygcUOzbCE3H
	 dSCt+Yo6npkHYbZz5rvsITkMbuQb7YjGI9z/z+0auPnjzmqRZzzi3JBC4LLz5YlKto
	 lFftnOELD93ZndD4Qjgk1fG96ZBy/JcxZsL3+NxepDaLeRhqZ/N/bIDwn8xOL0VmYV
	 86kZ+qYaHon7AR6OOE3sIKoD3U0pkmIvokdygtOZYvsI8+SGt8txCYEvLoEXxkq16/
	 4wMrHWqmdUfLA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B331CD98FC;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:46 -0700
Subject: [PATCH v8 09/46] KVM: guest_memfd: Introduce function to check GFN
 private/shared status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2428;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=OL8w0aV3ST1INN6O2LCRWZBxL/u1i0f+zitK0g2HaXw=;
 b=U39LZVAAEnLif9QW9hvBFksHFO3tKpvUSafWIpsAGBhftPn37vTE7MrJjUfNOgAUHGvpRiPbd
 dOWKEd717yMAVsSyc2k5PtncYd6bP63i0hlg1jmvSvL6Wn8Rq0oh7TC
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 72443100002
X-Stat-Signature: sf35mjtowg5fhhqpqki535j4op9q4pqi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781829112-117070
X-HE-Meta: U2FsdGVkX18YIz2W7el9XXsry92K4Mii5FFf3DJhATByGBsYnBolZSBgwppwQWr/sLrEqORmhs6WYMgL12DrFYDfLj5N5l367q8MZV1NkX3sV2ZEdhzk/RBXvPr10aqetXFFmCg0pDJTQbCq9pdNjHhZ1XlinpEaQ5V4cg2DyjcKht+jhpYlcDVfT1srTw95oPDWg+ria24/KGNPEM6OicHm50Ao3Wbl/vSgeRbdU5mNEfUiCmHNGTEo5SH1Ru4esuOmbyU5Ry4HHqcxm02F50rva8ogkK7528bWCDBUuF705xdXz2+VMJb6HO57fHigCMyF8Fw5YCxJMOvukhm1M6f7z4VnR9OKUyF46UUnbj+P0AZQ7YNpvFcCzqHqkb+a4L00cFYEAM4zP6mTCYAIzDaZ5m9F+UFWv03YudiPt4LUIMv2QHoNH0VRzFg/V/6YY/TiIaC9pE44K8nYsWaxKnrxz4DThtra2LwI0beo0ho4HAspcqAYI88H6MezjQEq74SqD0rHP3jq6jLhEIvgCGjqjtMk4OX4GRBk/AMWrgwvOzRdIwx9rITbeRZcNcxv0eybg811RVuiMtOudotKojTcKw4mm8RU0sfs6h6j2xLpA3zxSyYD3fhI9VJAXE9uSiF4de477OMF4jflWwSZ6KyyHD6MUw6n3YjViyVCJIWo9feCcZ0VL+7C5gPeocddb1JLAJQ5SJ93bdnmpJyS6VtOs/pFVDJhXag97wM2KgP8iRodJg5AHARPPyUeaZOsreONDd2wa5tanx/KdfmnA6MhqkNAGLbTu2aIYborU8t024mp2tlMqLjebbM4WkHRgWSux8Fbwq8ZV+YXArsjRrsCSVOQ9XL4bwG1kMaI7X4mZplDwcaEC4LrVIFzsxkMqrsCHr/MTyK4o2NevWo4Xh4EdSuDcL1/SYU4Xgy8bCcuuyo6t0NgEBOhmobXQc+lh4VB+cLpmP+mqgJuDL4
 IRQWElnM
 +dQmULugNg/qcHvuh6bBetaw9FVJK+Fw7bY2Xj4X63QCyl67XRKObRiWqr/4fLiCqDwDnMeKS9f34mTEVzKnXuYH+4J3cwwNLKS72e0lboDr0Pl7VvLuOE03DOBapZYruVHV2iGGKeLKPa5IxgD8IbCgxsAptLh4Jku19oQxNqJv8dCnOVVkWMwtWAzycluEJ3RarhoZbXTHYmiocolOKgQBRcwrYUG6gVCQ8DUAtv8XyIZdsNEo9mDdLoDkwyDDzrRqwwABQhygYxTMqRgiODY5N2m1O7a+LfbJeduRKTZ/9vZXSyFI4wsXbE38kQw8c4gZqQ6xxU0Bw8KUmahTDtN07sP6RMOyPdkz9qOKZRM5VYoGEOCwchv7gJJj7Iu+ttCq/lonHK02vlFGfKq9jAxzQt/2j6gYBf+ifTc4+71msM60JA+XFbjOaR0k3ZGXVLqFUOTFpFIR/9VUW9UwwMcddQobwbSaPbHNqoD1YwglrNiyAdXUCO12tsgvRYuA5Mzkebu68dyTu9UqUzGUr3XwMsIR234zt7ujA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Introduce function for KVM to check the private/shared status of guest
memory at a given GFN.

This will be used in a later patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/guest_memfd.c   | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3915da2a61778..27687fb9d5201 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2575,6 +2575,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
+
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8101f64e0366f..bca912db5be6e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -510,6 +510,37 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct inode *inode;
+
+	/*
+	 * If this gfn has no associated memslot, there's no chance of the gfn
+	 * being backed by private memory, since guest_memfd must be used for
+	 * private memory, and guest_memfd must be associated with some memslot.
+	 */
+	if (!slot)
+		return 0;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return 0;
+
+	inode = file_inode(file);
+
+	/*
+	 * Rely on the maple tree's internal RCU lock to ensure a
+	 * stable result. This result can become stale as soon as the
+	 * lock is dropped, so the caller _must_ still protect
+	 * consumption of private vs. shared by checking
+	 * mmu_invalidate_retry_gfn() under mmu_lock to serialize
+	 * against ongoing attribute updates.
+	 */
+	return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



