Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6917CCD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB66A6B0099; Fri, 22 May 2026 20:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8E66B00A2; Fri, 22 May 2026 20:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C776B00A3; Fri, 22 May 2026 20:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 780EF6B0099
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C1D31208A8
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:08 +0000 (UTC)
X-FDA: 84796772256.27.528673B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4610C2000F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iNW3ONMI;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495486;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3HvEf5/PLL9yBwrCzh/hKQViG6fnGPRQyMbunggirQ=;
	b=s7tle+WzKS5CjKjRa212iAtd5nL8QEVKmDGHA3/nb8+Kh+621PHNe7eL/8BThr0tGKpygM
	ldSWvPlSitXCbx47GRlexTwOkQ9HHYlwQee0/1vyfN0SUWUcxVUZuzEf0OXiabWzkHzxke
	mCZYGBq53ny7KJaAC26x6ncB6Xo2+38=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iNW3ONMI;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495486; a=rsa-sha256;
	cv=none;
	b=ACnjBYtMNtnej9dVZ/ErG6yjpin4B4rHFN0y8qPlwLl4TGmq+baRx90oX49kVF7qrWdQk6
	FwZsVy+0ObJ930GM9DwxnTilBYaIUGK+ISr5cUZcJ08nQLEQKN7FLTNvbxxiv9+R+u1Xq8
	51HNTASNZa6lvRFnkSRYtpYGqQpK94Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11D8044628;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88062C4AF18;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495483;
	bh=y3UInR9UUXj1QvhOJx1ThwJEEaF909///rvCuhskB+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iNW3ONMIXTQT67b4u1PLfiQKfvp+YXFq85oNehedYy8YU4vL0rjwV6FYXOv9AG6Db
	 4W33LNH5BO2RWiqjk0/BA40vTmCAoSblCBF72aBYvz22nk27uzkIfDvGHxJOX3HOAb
	 xTPKppP6SVReE/p1O1AXwq87rOnjzAKD33m9GbXJigSJn3dzcTf1/ENDXjy3V7j7Tw
	 FZJIpsKlhy6p1d8K9Bgq93OAN3Vq6VF1tlZ1rOoF9L2B+KLKErQ1YVT3wDPG5965Ym
	 z//axnRst0+n6FIWJU0mjvSSUClmDR+P7iDP6kEB4V5DWsvnBpsiVUts236LgRTmHD
	 udSZbh6RZS8HQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78526CD5BB0;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:47 -0700
Subject: [PATCH v7 05/42] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-5-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=3662;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=OouColGXY1rz+TqhbKdalwaFwpqqCIpTBsSizuwNECM=;
 b=m9CYG0+92BUQHFPoJVWx5CaK0A66GGKjWj3gHwo+8ZsuTZcxAjT5j+rnJrQgEMXHpGsJv8kQe
 pcw6COMTdRhCORBOl30dALQ5P5jQqIyzSygFNmAO3A6IGl0MLvkFelX
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4610C2000F
X-Stat-Signature: rob4fmcauysk5seotr6fqr53zd7djqy5
X-HE-Tag: 1779495486-127462
X-HE-Meta: U2FsdGVkX19CqWsqxypnF75FXm91S06IQXt/iLMqc5nPGDztEIb9KO3zAWdXDJIhdgj5wo8bRvmqB1/Mzgu9hWl70xRX2m4OCyqfURnNjeRYkMCaygBhs12b/404fbvyfUbcN4uiJuw+y9etGF6jZ3pxuKPQd3jjvxiDnRqaRJxMAkYtTYTbByw2aJ3Uc+9JYzhTiYnv/RR/mNMiOAKGYgP0VynteTGNv+lED1ihSQ5eVRTs8lnylx4Ev7aJcw1OWizRKqYSPc60FkfM7idwD6bITqG+RacZQeGtW5aAEsmoSrLq3+zjoWMerjZIbMM8MOav7Zoqnn95L7qKUsOTMzhdnFxI2KVKA55c/ugfCWDJbb6K8MHp2A8BFtjXNVfmjDU26dTyKt7q0G/B1cNPqjMZbxKRCgx4134tNwKc1GUU/cXM+B0xwIMVgclr09fnELUGaJ8vTdN2u2Naco4IeITOPlZo52nA3TB1LpN7vRpercBjwmjD/2h4TOegaUNr2UAfty3yP3ab+SK+ltYRCtT+faXu/3ODlOKD7BWio/ELD8K3cVlrX2n84QBJKkob5HcATOrYpcu0KassQOksqZ7NBLvnOXzUxyeDbeRN67UhMgAzueVTcO2dCDoVINq2DFtxwXczxHHZmugilsnyuZRUAVJjJmI0G1ppI9eJ64sUULustaP/xv6BAWFk7yUhnoJHzm4qDq4DnbBZ5/Zln2kCoSwkaxxvtsmpA+NoosoxsUXlLn0B48KaxAK8SXNO+y1g64A8XKZ6QEY+d25mbuShW0hq3EaIoi0Q0bGzwMWFYSOWBLCCcyuKraQ3EPZCO5q6q6sXG+b1tiIcksJqLPnmzbAshgEpcK8CHz985Amz86N9qkr21z+iXY2taHVEMJocv29ZRM3FSqaLQOXU3khvDsZXKE6QmudVz3J21UKLgHrru2RyktsoNgqv7V7dcDMhj2vMdZ2kVC8YP/e
 RFVHoLcH
 xAK/oqqC/QnU3OtjQH7+Ji4XOan0I1InzmHmLRQ7wRmBudFsUz0t7SnyRKubBi5Y6vx/hxMsK+3ktYMS6VdiS07cAHEOl0NU4W/UkPY25bLbINZRMOzUl58QrPH9/V445uAw98oY0sCiBr3VvLugfpfjWfbhYo85GCMehKswOT/q4g1xlFV4+2o3ej7bsndrRGximR/mEmmYPbrMUp40KnYYn6QTBvgY8ciMRmhGZLTnv4xSWxKruO2IpLJko+vjdKAo0RGe27HNwUZ4UgBKtENvXAXepD+dAsxuUDO22svzPeSY4OoUpK9tJN7po/IWbddTK0UEoD4/nsufcbfSyFZjcDsNkUqpQgFRpuR1aXgKdydzVwFJEqQLvWLA+V2FD2lgreJYclK83kMsvGroAnQkic8mXO1JpJa3qjzJ11zfr9+wDy/IGHLgwAduZNNxKFv1If0YyV0TcGC5Y+cW77X+CFqBd+izOU4I+Xj+kBgZleJaju0Lu7T3kYQ==
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
index 29694b348df40..7de85474c75bd 100644
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
index 117b726f670e8..c55879e033d96 100644
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
2.54.0.794.g4f17f83d09-goog



