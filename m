Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90458C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475336B0098; Sun, 30 Aug 2026 20:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CAE6B009D; Sun, 30 Aug 2026 20:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362016B0099; Sun, 30 Aug 2026 20:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08CD26B009E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74A7D803C1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
X-FDA: 85159670568.27.5FDA356
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90585A000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MEMuZDfO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135922;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zr7PlyQ86vRLcK3EC7YDU9CJZPUd9mLqES884YjNEhY=;
	b=8CCSB8Fk8AbV2h6CZ3eGcoNwkvjHk5gvpsVZqbESLgBLPPqnXBRXJ+s69mUFBhKAUbnr8S
	CgHVE59x2HEOVLXTPgaIJi0MFyLGXOO71Hxid8/tr8TT3b9WOaZqudHyF2ct2Tg+5qeJIf
	/f7nRvLyYMfZE5GVisWPH2dzzGyvAq0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MEMuZDfO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135922;
	b=s7awq1WdrD26LeSImrGDS90VP0SLDaUiI7fgPyel5YIdXbqPNk2NmL+hdlmmWEy3jJiNAx
	dWAy8To1jypC7X51/2kBgY4YPlTHX6RcJ7TWc3+/F2Kzj4easVQhCIzdi9n0oEZyjRmiz/
	5WxuWeRBMAMDT2qDP2sN70waJLgK+eA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66D186020D;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 121F9C2BD00;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135921;
	bh=VIYQB25xERtKM4Wa+e3NDcaOtZsYVNAG2ONdWBE3P8E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MEMuZDfOwTSWPnf+wlSRXFqB86Z9bjDf5zwyUkHOaHs/wrFONn/Y1eIvJY6ajtKhw
	 0+wj9O9fwSRkWoWR9WLr+mnXTjyxSd2tYvcm9HAG2Q1QOmaT+r7Yde5VoTkroW85e6
	 yDqO2auS0AIf8xOu7AKjU9xhA1UGbQoBzVFwAoXPeGkHFYvdU3QEGLPCgMm8Yu4j43
	 9R6jVCnscU1Sy0dPxsoadgC98a3nJh0Oc9Q0nRMf5DTF9yDxuemYs3Y/2/bPM4YkJ9
	 ud8X8Wio2L3E1VrUSojnZvaGOZ0cTEs9vuQLvo9kVvtqhMM4M/Hk3+1s6J1SrmVdFu
	 zovdwrI8y0bdA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66ECC624A4;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:16 -0700
Subject: [PATCH v12 15/45] KVM: guest_memfd: Ensure pages are not in use
 before conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-15-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=7741;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=IRpOCrAj0d7EfhfMDaQT+RCrQLlG814+PuqLTER1o3w=;
 b=GqaugOwXkdGbEDyigptaIR6ka07phQlgtzwZTeiexEsWbHhYiJ4yMDaJRkZNb3XXriqnCEa09
 kOig7tkrQXiC1pjyghpHfRjaObkpdbU5aRO/Gdwzh2aLnCXKD9rkezx
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f8husbuw4m7ejdgj4pfr1eoom9jic8e6
X-Rspamd-Queue-Id: 90585A000A
X-HE-Tag: 1788135922-392779
X-HE-Meta: U2FsdGVkX18BpXLVubJ0+8LSp8iiIDZ+l8jNnFwYvK/xL2cry3qHtydw0vlo0Cw/pHO3+ztBaX0A26uTBvyippJ7Ok+iDKaXez9M1LEp0tTc0sA3guZO37mvuEoN3DuGNoK3LhlKB90IgJENNOLmKwB9ccD0FkpbEnnqDWUgwW1DATYPFizYsbLOv9viboNVE/HelraLbKMTFDcs39dyMi++XT2PCsfhpmqetXSvuIsfcqday4dxP1feZ+6UlGtXeQddI3bJ4AB7Oz4zgTTcNPUlxmvULBaMwqJebibfTdqQFx2gqxUzW63Vo1KqOl1f3AwR3V/cXyzafWMn4NjNQVuZnjOZB6Ji7CiKTyq3uodLGoAsWt3w9cFBzQgtEeE8NnKVOwZRPfar2J9hw3z/NCk0J8UkgcBkQTpe7K3hyhhWWbf8QIYffL/4oCf+xmh+FMbylpyvyUFjXyc2mge45/e4uB9KXdYh9LFXW2g9CxrU3bZDD2CjrWW/+VEs2Vocn/z0XgQUT1CRPrVZ0Lkk4r54nALGsbzeZQy6189puh0DU45DcX6hLYD5VCrD2L8acIbnO4axiMCDQ/lZ+UF4AEDdOHxeU6/6EtKvx9UAp3Zoiyy8KaBfvshi8e5/UlUTrV6+Op0fqcKaP9PXqi7OjfhU/i4eaHqlCjGUxKb15qt6x46tDL3L/DI4mzh0svbPUVASbdwzLyH/D/NAUSNAGhMUSZEIcsFDGEs4FT1RoI34FmuKLvuCsk2Ty4p7uXunEvaYhUNsU03xBIqSgaS6wuXMRR4fHFzjmvT08q9hHk/cB9S0nro+OXZKdgyk3lnBtZ8tXK2j7pWwqIHxlfkULx49oSt448qNuvsSIEoE2gWkH/sxHt5/cUhh3G5MT0gYtkGV+vHJkYHss6btrhCflwGLbO6lLh2ynbc8/R7tFlXN2g0rn6/yj2HHiu66KHMcyeKnShbU3qTN3huhisW
 XEy9ythO
 5Zl6t+8a/NXkbdMuKK61wzLljgePGYNoJ53r210+HeLj6ks6nTkpicyt95lDm1NHDwwGDwHfIg40U6vZnqPYb1qooRY80PKGYmVLeh55S4NDCIOyZVIwyLt9oaUEIu0G/MWSEtwZlO2P7WCk0rzQQK9M6YZ/MMRX6UmRRDNA1/Y9ZGVx1PkCEyuT0mM2J1p8jkQBqgtjpKw9wlbs8PJYIAYHpWngbKWk4dmekKOSzAsmWu4CfavlYU9/wrgvnE+/BfMXk0Uz6rWCfQZGplvUZ178d7IYefVWVZKncYz9PIibOKpOVg5F1ZOisYlNp752lYywteg4OSC9G1eut21OczuGHZTum2XuLNFYD2N5GevV2uLpBwbdDq7lwKOTgyobQsY4hx3N4Agw1pqR7yTqYAieOFsuExMINVgmU2fl+9kzb6PmMZkl31c3QhKspnasrZ1Mi6bNjIs/t1bXitmYVICA+MfIgKehRqwovsf28pt5kQb6wLkdCKqyd9vNZyb0IG3iA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When converting memory to private in guest_memfd, it is necessary to ensure
that the pages are not currently being accessed by any other part of the
kernel or userspace to avoid any current user writing to guest private
memory.

guest_memfd checks for any outstanding references to determine whether a
page is still in use. The only expected references after unmapping the
range requested for conversion are those that are held by guest_memfd
itself.

Update the kvm_memory_attributes2 structure to include an error_offset
field. This allows KVM to report the exact offset where a conversion
failed. If the safety check fails, return -EAGAIN and copy the error_offset
back to userspace so that it can potentially retry the operation or handle
the failure gracefully.

Update documentation to document the error_offset field and the possible
-EAGAIN error.

Suggested-by: David Hildenbrand <david@kernel.org>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 19 +++++++++--
 include/uapi/linux/kvm.h       |  3 +-
 virt/kvm/guest_memfd.c         | 77 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4dbf452f6e809..25cb15970f1ae 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6613,7 +6613,7 @@ KVM_S390_KEYOP_SSKE
 :Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
 :Architectures: all
 :Type: guest_memfd ioctl
-:Parameters: struct kvm_memory_attributes2 (in)
+:Parameters: struct kvm_memory_attributes2 (in/out)
 :Returns: 0 on success, <0 on error
 
 Errors:
@@ -6622,6 +6622,8 @@ Errors:
   EINVAL     The specified `offset` or `size` was invalid (e.g. not
              page aligned, causes an overflow, or size is zero).
   EFAULT     The parameter address was invalid.
+  EAGAIN     Some page within requested range had unexpected refcounts. The
+             offset of the page will be returned in `error_offset`.
   ENOMEM     Ran out of memory trying to track private/shared state
   ========== ===============================================================
 
@@ -6635,6 +6637,7 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
 ::
 
   struct kvm_memory_attributes2 {
+	/* in */
 	union {
 		__u64 address;
 		__u64 offset;
@@ -6642,7 +6645,9 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	/* out */
+	__u64 error_offset;
+	__u64 reserved[11];
   };
 
   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
@@ -6664,6 +6669,16 @@ which includes operations such as unmapping pages from the host or
 stage-2 page tables, may result in side effects on memory contents
 that vary across different trusted firmware implementations.
 
+If this ioctl returns -EAGAIN, the offset of the page with unexpected
+refcounts will be returned in ``error_offset``. This can occur if
+there are transient refcounts on the pages, taken by other parts of
+the kernel.
+
+Userspace is expected to figure out how to remove all known refcounts
+on the shared pages, such as refcounts taken by get_user_pages(), and
+try the ioctl again. A possible source of these long term refcounts is
+if the guest_memfd memory was pinned in IOMMU page tables.
+
 See also: :ref:`KVM_SET_MEMORY_ATTRIBUTES`.
 
 4.145 KVM_PPC_GET_COMPAT_CAPS
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac371a50041c9..8dff2fc1972e9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1665,7 +1665,8 @@ struct kvm_memory_attributes2 {
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	__u64 error_offset;
+	__u64 reserved[11];
 };
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 803c7cdbbe0f6..fe02c47c85fb5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -538,8 +538,46 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
 	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
 }
 
+static bool kvm_gmem_has_outstanding_references(struct inode *inode,
+						pgoff_t start, size_t nr_pages,
+						pgoff_t *err_index)
+{
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t last = start + nr_pages - 1;
+	bool has_outstanding = false;
+	struct folio_batch fbatch;
+	pgoff_t next;
+	int i;
+
+	folio_batch_init(&fbatch);
+
+	next = start;
+	while (has_outstanding && filemap_get_folios(mapping, &next, last, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			/*
+			 * Outstanding references are anything other than those
+			 * from the page cache, plus 1 temporary reference held
+			 * by filemap_get_folios() in the folio batch.
+			 */
+			if (folio_ref_count(folio) != folio_nr_pages(folio) + 1) {
+				has_outstanding = true;
+				*err_index = max(start, folio->index);
+				break;
+			}
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return has_outstanding;
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
-				     size_t nr_pages, uint64_t attrs)
+				     size_t nr_pages, uint64_t attrs,
+				     pgoff_t *err_index)
 {
 	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 	struct address_space *mapping = inode->i_mapping;
@@ -556,8 +594,28 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
-	if (r)
+	if (r) {
+		*err_index = start;
 		goto out;
+	}
+
+	if (to_private) {
+		/*
+		 * Forcefully unmap the pages from all userspace page tables,
+		 * and then verify there are no outstanding references, e.g.
+		 * acquired via GUP or similar.  Tell userspace to try again if
+		 * there are outstanding references and hope that whatever has
+		 * pinned the page will put its reference "soon".
+		 */
+		unmap_mapping_pages(mapping, start, nr_pages, false);
+
+		if (kvm_gmem_has_outstanding_references(inode, start, nr_pages,
+							err_index)) {
+			mas_destroy(&mas);
+			r = -EAGAIN;
+			goto out;
+		}
+	}
 
 	/*
 	 * From this point on guest_memfd has performed necessary
@@ -578,9 +636,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 	struct gmem_file *f = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct kvm_memory_attributes2 attrs;
+	pgoff_t err_index;
 	size_t nr_pages;
 	pgoff_t index;
-	int i;
+	int i, r;
 
 	if (copy_from_user(&attrs, argp, sizeof(attrs)))
 		return -EFAULT;
@@ -606,8 +665,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 
 	nr_pages = attrs.size >> PAGE_SHIFT;
 	index = attrs.offset >> PAGE_SHIFT;
-	return __kvm_gmem_set_attributes(inode, index, nr_pages,
-					 attrs.attributes);
+	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
+				      &err_index);
+	if (r) {
+		attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
+
+		if (copy_to_user(argp, &attrs, sizeof(attrs)))
+			return -EFAULT;
+	}
+
+	return r;
 }
 
 static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,

-- 
2.55.0.897.gb25b4bd76c-goog



