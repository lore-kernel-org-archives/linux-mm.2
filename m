Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 504BECD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76AD76B00A0; Fri, 22 May 2026 20:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7806B00A1; Fri, 22 May 2026 20:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3D66B009B; Fri, 22 May 2026 20:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00B1D6B009E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD7A01A07B1
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:07 +0000 (UTC)
X-FDA: 84796772214.10.7EB2FDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C920412000C
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WYQptY6N;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495485;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nt4SndszAafhp5uBpwuch5G5XV/w7LCA3WqOwFDFQVg=;
	b=Zr9QIxQGmdzDYTQmWDnQGlnSHs5R9Du4Lntt6EoqbqRbvCa6BsUNYNtKNGO/aoFdgcIhPu
	bzNm2z4dShsF/07WnKVizIgBM34USUtlG5mAFOccmziJ4a6hi851GSB/EiTiWqhjd9gfnI
	QfS2yNdvdd8dk1N8D2Uvou8rSLbuSog=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WYQptY6N;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495485; a=rsa-sha256;
	cv=none;
	b=GN2Gx1RL9ICwZd5qARBUxjiGcyzn67wq7+qweZzeV8NspVCrHLAHFooKZjPPebKpOXMM97
	lTZCKmARjNpz2g7A8msimAgNFWSn3ZbVNV+1wxIU/e51kq9SzQyCd+eAWFNELxtU5IOW45
	FW+qZfwMbsAd2wk0Jcr4Bo9U19v9RG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B801660230;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40DFEC2BCF4;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495484;
	bh=OOpQUmjOGW+A6G2F7LFI7XPcKPq3QcIaFAbjUiONH1Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WYQptY6Nd5rIRoePIS5G2yRDy+Muv7T+uF2oQM0s/aj7oFIygGa8d+6yQlzBwV/q+
	 itEL/UK2t5GU+GLcX8Rxd9XuirCOv5jedffuFgf8EE3kbDy/QMmCnT9mKro4cKaP0A
	 +AOzTSZxFnIHgqkV0JG4xR0pVwGsqofuIwFVrZIxkLIzL9QLMmo7Xrl9Mm99lk/Akg
	 hsIxyAOBBNkQn1OYV2sBbxCw5T5QF2gnIvuEhO5Ox3Hpr4JnqrjoGUm+9dH/qoGnEm
	 I/PqAx1Ji1xKa0VInQ8iJJDzMibrtjK7+oiX7prnk2WpJxqRo9MMQEI7hID8jtlZm9
	 KuN3XfmtDtyfw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AEACD4F3D;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:54 -0700
Subject: [PATCH v7 12/42] KVM: guest_memfd: Return early if range already
 has requested attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-12-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2602;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=R4WZ+o+WdEBDAk7/n7jmXkf0CoBYN2q7KUKZekzzJ7A=;
 b=pVYkdvwbpCdTvtSX7Qmuzxp7g9xI8EkCBZ99waBSS4PMz3lgB5MjKFI8kUP7v3VIFzqXwichj
 HA4bzVNqcxzDx2mbBnBRwxkoLs00Z51mHtT++JBfHdVskrak+sRLoA/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: jw48c5s6cxepk8pks4y9amkaywaqfsnc
X-Rspamd-Queue-Id: C920412000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779495485-40887
X-HE-Meta: U2FsdGVkX1+U4u4qQs3xl5reCYDz3CICnpfmxTSRUGymzSulI887sPn9mVq4apS8hMV9rK4Wh+nw5xKb/vHBZq4hr+71wCrZta+6anq99zUG1R9XZdwKlXyNL/tnUARZfmCqobP2QNENr1f/Z6t1ieXek0mO7l+lVzJZYqoV4pZxFbscCR2WMWdbECixbVnUbkpMzGDbLxQtF0ilifX4gWnM1Hqn5+GeTUJOvROez9m8jGdApeq2HM7rCjDJBaafeRTx0n8Q5Ka6wTEVRf7lyhbRkJQ66Krvr35F+3hDhR0vxFvoDHO5aWoJI52wsq0We2ABbibbHdZBQE1IjSUmhWvnNZcVEWAjFa4nY7e/0dzHf+l/0FfZmMAGqg7MY+1pvUfi7QFrar1ZTOwEdJPW5o240M3K+iD4OSwXM3v7oWmYMtJibKe9qluAX88ExvU6URrhrDJk8oYYB17E/05qT+2SU9Md//tUKKfkIjExN+fRDbrQR3MRurk/nvrI8WxOPeG5ybP8VFiaxRx1/cj2D3XZbAALknsfdadPfrlq3h2ub/3aNym5IbpQw7dZlVqd+6Ww7bvqSKC3oIXQNZIGO6U7dbygEFhGyIVPTydRO6GD3oRRPe3XqYftgnEfHjNro9faPIC1eQME63eZDUnaS+G3NC5nWZTqU5CzNPc9NJRnxp07ZgoOGUPQYiTiMVEgk651cVmxc+cFdGSHgtDLKXk9+Isy7CFdyeyM3jL3EoqxkvKHE4RTPxM/Mb1x2ZuEglsKscsL7qr5wNi1Tkb/5DMADtuqGR3rzGxr81aoUEtbmNbQQss/h0R62Ti4r9lAomiSX/cKcrcsXfFyoY4/eHTLQca7xP7zC9v2RTRpjKJWz/RmCEZ4UHWALC0Jvxho4KafVGTeVg/0ZhSGvRZS9abkqm8OAn8bZR/x4aAHSaXVUVv8IJ9FifwzB1lC1PMlUeRghOLQekL7IjkuQoF
 m1te9pxs
 BGmSfPgntUHVOMu1VT1iAvc83vKmWYMYhq8r9ev8Qjj7wyDsc9FvTp7uWYr1cGa+x/WQOGg4z5pkkGvSkRvk13ZBaM8tpg0KWIjB3tS1JrocZhJie49WHwwir9EASR9cpBrkXpH5LxijhhRXSGTHXUpfHJbiNpmzTBC7D/Trzd4fmYlBmF1fIlYaGZktILlfpnsrcv4QOgUfpXBmEoBq91X6EwcCPiFYZ1Paw3Flt9HLHGR16VAcWb3EyU24SMbidpd41gGGY1OPHGVhPqxj/57bg/RX7sFzlhQz64ssIEGJrDaVH6wm09Sl2NK9s2agDd+km4SSouR4VyhHNWdDo93hMp7SZlkci/tyBw642QplPkD0Clr25u3d75tz0gl6GdNGsrHuTHhhXrE0EELaz23ayIkg+IArQLIhhI5nhwqhUnSfSarcQYW0ulKs4qKyNhexCXqYzLlXdtgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Extract a helper out of kvm_gmem_range_is_private() that checks that a
range has given attributes.

Optimize setting memory attributes by returning early if all pages in the
requested range already has the requested attributes.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c9c5b9f074baf..4e1028843953d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -86,6 +86,23 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
 	return !kvm_gmem_is_private_mem(inode, index);
 }
 
+static bool kvm_gmem_range_has_attributes(struct maple_tree *mt,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(mt));
+
+	mt_for_each(mt, entry, index, end) {
+		if (xa_to_value(entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -652,12 +669,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	pgoff_t end = start + nr_pages;
 	struct maple_tree *mt;
 	struct ma_state mas;
-	int r;
+	int r = 0;
 
 	mt = &gi->attributes;
 
 	filemap_invalidate_lock(mapping);
 
+	if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs))
+		goto out;
+
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
 	if (r) {
@@ -1149,20 +1169,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
 				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
 {
-	pgoff_t end = index + nr_pages - 1;
-	void *entry;
-
 	if (vm_memory_attributes)
 		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
 
-	mt_for_each(&gi->attributes, entry, index, end) {
-		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
-			return false;
-	}
-
-	return true;
+	return kvm_gmem_range_has_attributes(&gi->attributes, index, nr_pages,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,

-- 
2.54.0.794.g4f17f83d09-goog



