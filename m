Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D82FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA0E6B00A7; Tue, 28 Apr 2026 19:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781C56B00A9; Tue, 28 Apr 2026 19:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FAA86B00AB; Tue, 28 Apr 2026 19:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C95B6B00A7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:25:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E58C28DA29
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:23 +0000 (UTC)
X-FDA: 84709548126.12.F76ED5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7399E100014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pl7ZRH0G;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418721;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ik5xJqRt2Jk8FL8gxNC4NDzBPgiR/COu3QeXicwU7OU=;
	b=pWzsjSoDYWWOvUlO70aN2v4rTV1gSJkDol3HrzJuiJy5P4xqtR7keE1ae1P8jES1jyeYA9
	HsXflrADAD17Wcynxz0Q2t41TeI9cNKsQNZVxJnBQrS7aWpsIqWuwRYAaVDpW3oIsGH3+M
	X6MTzdpHxQjLnGWoMlDY4aMCiyJd+R0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pl7ZRH0G;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418721; a=rsa-sha256;
	cv=none;
	b=VtCz12MbQAwTj7Q87NodlO2ASs9rBjNTBhIAsg0jgy/j+jjew4wVh3KC10fkLI+vSEHoxH
	hVUmPGXYe6l9bfvK8rTdbBluFOOCRjnn3bKi6i/CIEeg4L76Un8Z6oZSNLlcQRIRaarWje
	DXp8YpIyuzrr57nN2Z0LAZEam9VuALQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D231644534;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 742F0C4AF19;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418717;
	bh=HgpSi9ZTgfE586MD3phUUfSsFvJtrJhDKnFAWPz7lSY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pl7ZRH0GoG08ArewO7p9PkFpV6g17REgFEIux90fYKvK0tjaViRJPijJXYlb0iwyG
	 VTmDmiu0WrCcp5hn2Kx+O+qgGmCkdDeUkKZb9q0uXwyghG0U2RZ/+TLYLDfUQwOXVy
	 FiXmmCErnKNSOOWqzogbO2BIkKlt5laJvU0KaPaXtu9ELdcze3rLGbgSo36U1x3X/n
	 JZPyT1JAvVAU4D6m7mme+kKcy7UqgEzdu6vX5VCGrsucfXLERioT7aGR2y34K6dwGQ
	 kCHuHNxOAIIuiIjK7Jqnv/VVv7pFdd6FR/F1zoIrWhMyzHYRzGqOnyaLX0rhRc/ynz
	 vgtpRp50FxKQg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631A5FF8875;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:00 -0700
Subject: [PATCH RFC v5 05/53] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-5-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=3888;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=EYm5H+HZKG4huNzVvIwI6VbVarVyCkhtRQI1zH0BvXc=;
 b=l8oQnEGJFxSn4EiTXE9P6FteSO5rSVnbUWVF00usM5p6WOsYdDAKlFUyKJoLPK+1ALTEHeZey
 13tyngurIdlAeB99TrW25+XBk4+2F65hxFbWt3QsxqTVrvWAtbflm0S
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 7399E100014
X-Rspamd-Server: rspam06
X-Stat-Signature: ydsgun57a6stft3rd5ghqrq8nwoebzox
X-HE-Tag: 1777418721-738747
X-HE-Meta: U2FsdGVkX184HAIeaXW9YaTr6Qnz6H5xv5N1xq0UrGHH+amNrwUQHepx0r3bdWZVUC869fszimAu1IN8rcRUEMXKX+l+YgvtWtgEka9mi4TXydeE998v/Y1O1b+PwAUg6ODo8c3Ae+xFrnhfQ8OaI/2pZQft3OBTpPvRD54oOAmvV9GvBNHaqYdXZydjkHsNRPkbRG85I5JI7fBUgIVtn2qs+ty/sUg1om/6rbRtJWCx8coLavrNOGs9yihL3uTVO9Bw/ja66MWVFvPOHddzz4xncdl6Z/p9YJD6k+Jhhocj5joVWx4CmsFUg+/Nn3sO55fOs8Q+CeuiXoWUWVnA7PbKPr7uERc1Oiigtdgdw6W8C7CRPjX9Pwl81PH0E8znIqJqLjb7BvMMiSWtP1vP0+2mctRrYQp6gSgZn1WOVG23HnyEo9GfW9K9hjqBDo4pCQeCGM7mTjz09zTc8zEUuLGAegvJmEbiy9S2oGYfQu4tYOzkPu1Aots+Dn68YwXpbBXDNbp9YJBKvSSqcMpALzca0omNpGptij5vWv5uz0mtg7ohCztTpAnmp3dzncw9bMQMYXgoWroZk/Qrp3lvNmppS7zTjNURxO/ub1O1KFNyD7Jsof78y6QPtVDRgdlqkEo3oNv5sYShVgoXcBEJWrcSnOJ+OajYC0l9l1LbTvXZ/JmCGWlZwhXMiSsWkCvvihIdMpshXpl2t/JDo19MiMGNeDwMPr71lTkjKlKqAjK0I2Bj6gTrQZ88ebwy8Y3MZEApRgenK3tnGmxJfKFF88qL0zQZiB+XKOtkaO9zXUH+pBZxdB+bu4/HxKFTYjLaDLebJ9+uw33RX2+XNTXyd48AOyfAz5Mtc4eUcMZ79zKJJzrxI7KkHKqNSajHegj85HvjyLfSFX91kDgaQPZvdPeu3yxVziezTR1K8ecF6OQo1ZorM8G5ZeQ02BmT+VW9T6wXB/yp7im9ZarvbPp
 I6AbTrlR
 +q+beuDGGSYFq4C2znjNAAI0DlC7z9/+NatOjMeDTosjQZfJtIZ86de/DwcJNR4q60osDSVRsUOIdM7KLOsZOzkJ3V23jXc9csk9cKiw5TQNiuxOViO+1tSav73h863sVMubztWQs4gqOWsDYHoJDjlqbQ54LyfQqtp9atinqIHd5Dy7X0uVCm9XQe4akyD2TKMf6UwFFH89l2l7WpjmSO+ZkQLDLewrC3hyk3DCUr+MN3UgkbMuEmM6E05+zdiqUpNWRsUYl10zadQKemjwlOuDdFwWkZtAveg7s6SAjfj2Vm8g5sLcEF6o9PGZvEqlknARYDHjjUlU+Eia64olhXUd2+RF2H4R46My12vg/nDyBxQfmNkHChVD45EUbR1Sfx936+fnVdrkTdLRvd5NmoNlgyu/fRRvDJqBJXG5xccJFl6W8/qH02qPR06OO4CnoESvDVhfLat6hR25Q+Rus+Ne1IMKNCUwT499V34oNqlRHHKD+raAt0bILWQ==
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
 virt/kvm/guest_memfd.c   | 37 +++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  3 +++
 3 files changed, 42 insertions(+)

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
index 17e5a23fec0a1..e56f89640d050 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -515,6 +515,43 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct inode *inode;
+	unsigned long attrs;
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
+	 * Acquire the filemap lock to ensure the mtree lookup gets a
+	 * stable result.  The caller _must_ still protect consumption
+	 * of private vs. shared by checking
+	 * mmu_invalidate_retry_gfn() under mmu_lock to serialize
+	 * against ongoing attribute updates.  Acquiring the filemap
+	 * lock only ensures a stable _lookup_, the result can become
+	 * stale as soon as the lock is dropped.
+	 */
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	attrs = kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+
+	return attrs;
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
2.54.0.545.g6539524ca2-goog



