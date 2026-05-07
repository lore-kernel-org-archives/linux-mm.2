Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D4C6CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CE76B0093; Thu,  7 May 2026 16:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E976B0096; Thu,  7 May 2026 16:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEB76B0099; Thu,  7 May 2026 16:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE3F46B0093
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6B1314056A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:53 +0000 (UTC)
X-FDA: 84741747426.17.07639E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B4D991C000B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5qcSEN2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185371;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rxeh5MWBSP8NGW/qiXARRfVWKClPZYf4I09NQ+HL8M=;
	b=Wih/BPbrHUxp8ujTEfcPx7jejL7PEw40HKBp7b2CdSjmcS/ShtawQtkckWsaZkHlyR0GJ2
	syWUUcaAiJz+KbNuhlEqqlPJpeNviBQV11IJ3bwBVYg0c1z4VDaFc9VMfcbX/8LcVjx/Y+
	PNE1NnWQvTkIWqmou7ngnB9ywlS7qD0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185371; a=rsa-sha256;
	cv=none;
	b=zIXtb30cJFNRiN5EIMoX9F9u5VfdHkgkqMRGuNL9xA19nlIZ9wxBgWdOrkEl3YWKZpGX6m
	+iLr86DJnYInX56NS/cNYeryKikJyJyC0qRlmaP8LCZwdSf3+vixO32YykM4qnE9Pb3EMO
	IOrcDBouDEVHYAqgUaKVE7YefmqzQ1w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5qcSEN2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4505F44594;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0805FC32781;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185369;
	bh=YE4+ijc8B8unJZoU03cWf+XDgeMGIXIfYTYsYzkgKKI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U5qcSEN25hu0itcMhQEUyIibpLTh1cu5LmIQedC3YmljYonhff2+WqHhH5FxqVoIJ
	 aga0UtwUNkDKhVui23WTxNyg4CceiLV+sB7HtxN5Cc50OBr7t/P2A0EkmCMIzcRUl+
	 bySYlwclD/AcfpjVz2Fum9Z5ozjwABgAw9jj8yE4WUMg+GLXzrkGEjWdPka1E8dwEj
	 ZqzccdKJ0I9AttSjjMbEqDyGneMU2dS+lDyXyRqFGZWC6DSeownSQ1vPo+9XB+n2pf
	 sUcwmC3wTINVnI/402cBn0kF/PYLxOZ/E71mQh4Zc9/cFWgFP519FYLEC32flm6DcW
	 WBUmvxaaNWMJA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA472CD3447;
	Thu,  7 May 2026 20:22:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:24 -0700
Subject: [PATCH v6 05/43] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=3662;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=RaMQqb1Z3D/y4hZGPqiuTqpIzc23thZTbu/49XtlXbw=;
 b=1zykl/Xo6MJwvW7UdzwGuXat4SRBXAcuvjLNENFmIVlxHo6bIlePihDwmkqGB8eeWuaq+1N86
 yxx0tAIpyWvA3KJHxf0UsKu9BcawQ4ofUU0sJNyjb8XLcAhExPvxCVW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: B4D991C000B
X-Rspamd-Server: rspam04
X-Stat-Signature: te9z6xg687wmbg51dyfpfu9js3n9fy4i
X-HE-Tag: 1778185371-852472
X-HE-Meta: U2FsdGVkX18rQ5RvqEGRdMcylm7g53pnGQCCHtx7mpfeALAnOTt7b5GwH3exDAiLBhMeHVvIjoeQq5OBN7SLTaYTh/ahGPIcBq/fD30hGCpfCo+VrLtgV7erxPGByzKh7dHA6P2SXR9SOH4ypUw4Go5bs7bGx096mLdFdWYsB9M26Pore56e7S8tQI28cNQkDP/hctmByEfvNfzI4QzHrWzCLfT6uIfAzm5dgH5M1iJqjyj5CwMx9+9Kl6EmouF/0y5hNTNPYy+nrGhlKmEcSF1E363GbfaEQO+Jox7+CR6MU7hOABVjMi1A/a8PkbGSZr++bBMGE33ZZoSqCUMWw42ey0wb2eLh82tyjLVdB0CoP1cGgwulVK3hx1lndwIICl6HlBTyKIZL5Vucm7ygRb7JQzoru9OmxBAuR4eMnNZNEtnOGiW4VfpbqBg4FBQE0NLHaoac8wAHYxAhqLRV0zB9fu89/oLSUQ6QrSJekCHzOQ6NQcRaV3K+ZD7wMToXtJRdAUFvbE/SmOtkxL2IRqo1KiVdAvPwRiiojfVOrsi3wHpRMNesoKbhTnRcPfkpnM6/hrjU2+fZDuwzWNBYWhSJKuv9Kn+dLvWQRfQVnKBiY2HuxFvwHm+3KntvcSDtREHowX56l+o5FL/tKRNZqxUat3bYA1ldz8dtAlrjdIa1gje/K7G9cJFShMMEyqJ2Ie0eN8lcGV9WOLvjYmfZbuYePcJYa6z7DdyWK6MaS+fPLugQmnROQwqVcfbk06xwQFfVyBcLWwuHdw7Lbi7hWvFFzBX1sx6VmsQTBMEgzrj6I5y7DFJvts9jjCFdQjOpC7o4Fz8d+9OsegnF8a38wN/G2Oi16vFon1Z7AcxDWaqNpMgW6f654OTJJuCpx05U/wIi13NpxbYXGvbcLJCUdJcZe7bexmTGqmpaatLrOuYuzcMyK5RN0hZO/7GqPe2Xw0wGP50NOypcepdXnkY
 jlosh6GI
 0DFBjz/F4/Uf08GZf0vj8wdrVl1Lsx0AjCirT9T5B9iaryzSajER6MG35a0LlGjZYPdGaksWRb8ovb3nInuyGwJQDOYTfHZ6i2/+VqzWPRzkOOqUenRS1p+sZKoNOL2lKwzpr5kW4kx//cCcc4XJ2UOKwWp1ZNl2Xtd9fDHr4krktafuNsDRo3SJRL4WnN1Wzi7BmBz44gwLAVDnjDwrNtxotO13fHCRSUVG+4/15bmFejhmbHGjdQgpJ9gE9xWbR7pAxRQLGvZVBv/+PrqE++EqsLb9XHI7H8C+t1H5/cjuvaQS7tXDiJ33PoedWqozTVFfoEWtJDI0J5HFvvIwF5iNJsbeIt8TeUzTpZNzCcPti3ukRZgAYuBu1d5F+/xsll+dzS/LaiZ8cqXaINlRDJfKHqdNqsaqlLjXgO4dNnq0Mdd4/v+0ywSPEeQmQ78uN3PhFLjpaoEgfvBjGPXpNwSwnKnXa7lSrUyI/S7k41aLE1CC7NsdUIKJczQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Implement kvm_gmem_get_memory_attributes() for guest_memfd to allow the KVM
core and architecture code to query per-GFN memory attributes.

kvm_gmem_get_memory_attributes() finds the memory slot for a given GFN and
queries the guest_memfd file's to determine if the page is marked as
private.

If vm_memory_attributes is not enabled, there is no shared/private tracking
at the VM level. Install the guest_memfd implementation as long as
guest_memfd is enabled to give guest_memfd a chance to respond on
attributes.

guest_memfd should look up attributes regardless of whether this memslot is
gmem-only since attributes are now tracked by gmem regardless of whether
mmap() is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/guest_memfd.c   | 31 +++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  3 +++
 3 files changed, 36 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c5ba2cb34e45c..28a54298d27db 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2557,6 +2557,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
+unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
+
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5011d38820d0d..f055e058a3f28 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -509,6 +509,37 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
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
+	return kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_memory_attributes);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ee26f1d9b5fda..4139e903f756a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2653,6 +2653,9 @@ static void kvm_init_memory_attributes(void)
 	if (vm_memory_attributes)
 		static_call_update(__kvm_get_memory_attributes,
 				   kvm_get_vm_memory_attributes);
+	else if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		static_call_update(__kvm_get_memory_attributes,
+				   kvm_gmem_get_memory_attributes);
 	else
 		static_call_update(__kvm_get_memory_attributes,
 				   (void *)__static_call_return0);

-- 
2.54.0.563.g4f69b47b94-goog



