Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85FBBC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF376B00BA; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155566B00BE; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E571D6B00BF; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3AFF6B00BB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C59CA06E9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:46 +0000 (UTC)
X-FDA: 85199512692.28.311CF18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0BB7440008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Swlk+eHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084544;
	b=Nm7RLJxQjwILBPi1xlpHyUUIOftmC7MPetNshma+cMWLz1AWOpi3esWHWjbU5m6L7Uh4XE
	WKBCAi1NnJSz36hkZfWP0SqD3srtyf+BBl93zgnJZ4V3Y2dIVNRRSxGDIXqRzJdgtRHipv
	af5OMEj8jB+70wl1CVytw7ZYNX+5Jtc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Swlk+eHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084544;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivQYCKx1XTEor6DIN43EZn4xiUHmiK5TxFME6euLq28=;
	b=wciXP6Sw8CwWFJgQOZzrOQVtZOe9cD/5EN/I8RdgL/sEjueov5ySS448Mah8XJbZPJ3sTF
	ra/M5AJn78mDHZh5dE7GBr56TH6tMhQhmZrwEYSnWWe1tAHNLOzX3IlgC604TLQRngP7Kb
	JQBl4G9NToX1CoqpgjvWskgLwcTNhew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5130344873;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21DD3C2BD00;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084538;
	bh=dzzHKnLaHtatS2247i19T9JMQUuRjUg24xPk1W6Kpn4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Swlk+eHzO4VJ2EXiikAIxZBXrLrmKlOlYUPNbvFs7EE/U4lIxwV/oBWKkpXyBeOOj
	 g7/F9s9LFgPNUF6ULGj29Qfae48kKPD4IPFMh9VAh46xBfHF699E0IpkPGd3Rk2jNQ
	 okHLiwHrjO32yTXMuITbWEDorZP879VmbDyCqC9sF6sQTBiqzl4+pGLbpo7sqJXCqw
	 hqDu9crfRUrJnkyW2W5EaVv5eRkizXjpgpZi+OXDLczSIGdN9UQv0MRl/5ufHXthdh
	 hnRH9Hx7wK2LuX5py9i7r/G4hwMWCD7+h5TZnL6MrmxeIZ5yldD8sH0Exl/snbQ/+F
	 uovfZdE8voukg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EFCC88E45;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:41 -0700
Subject: [PATCH v13 15/44] KVM: guest_memfd: Ensure pages are not in use
 before conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-15-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=8638;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=bSH0XLAck9JRuUcQsy3NOevga72VUfUd+daf8lXu/qs=;
 b=M2DwPEFrdMLQA52kG1SZOQ5yDt1mcDcBoE0ddXB9a6DJlhwiRUP/+Zgp16DVmCdBiG/YxtANG
 W7oNlD14eHsDPxh6/GNQyoNgbr7N4SwcBCltvEmikV87mDiAWyG3APU
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BB7440008
X-Stat-Signature: y6m4i8dd895xfkcn6huk8a17i5s99uq7
X-HE-Tag: 1789084543-322665
X-HE-Meta: U2FsdGVkX1/EpzzRZOzBoBgR/W+TrDNFVZTqGPWOPAIpOQPeNQz/1fs5nJesIVvOz51Hpsq0Dns2Zz9Wh0ivJvjU4HBgCY3KrUL1rvVXrvaIdEprGYwk5L+E4gEEAvygvBloFTlxXJNhZ5VM7g/cdJKfK1MWisXbglqz9ahMolSlekP1LKz3xv3V1ZKiDKx/CayQ9wrnzOFZu1CDMlHpTBEFHEUlAI9Gkv+8QBNLjmi4CakIw0yRoqjHkL7i9qmCIWaM38N7e9TLyWFhAqAB2hC1Pm7YHcOejuUGmSPcrwNTZMjrHrsRKC1cfolTdw+69sdxillMMwKx7wsIbwhld2aiubYonzK6sVuyBHfP5Gz3csCpCRjwb2Jr8Li9o2yvMBIYRflef4uH2pEMYsenH9dTaWbPt2hExUNFtYNokXj6zTrmokAAOdoH7OScNhoUgwHXLr9cfu90uJRO1L2vju/oqNY9wj14deodHvL6agd/bCmimfc3/+rdoia5ex6aL8wa7ltq0uY187Ugkv0C/imumXpjigv9KGwhyBU+0eG94MZpocBJe/zF2zoACbfNFlURUiCU66ed07RyAzsXrHyG3Za3M16SUik3dqshkQ2E/eD/uRJxPJuoI+PBhOHTkmY9Dr84xrt1funXQ2w9OznCYu+VNJhFjHdEwteqh4y85+mrHB6jmVTADcNFKDaWDFTyDeXrX0ANJGBvvhNxCjTPrmvoAH2bXkuezLLa6NZ63pnS4MtvH5b2WY6RZenWnAayGK1IILlpAgA/78ICnI0xvbQIYaTGOziTozpFsDKwsNhsHn4ZzDT98arNLyIHuw9SLNXnmMM0lajSsJ/YyjgET4mtwWDSL1b7h5FBZpVhkrByVOyjqad4BvyD0zKd2LYHwsb+bvvIphjuMhW9tP1orapOh+dkQ+8ITfCc3DHdLOVVZY05y5S7bwCaFCqXoGCisjs5+Weh1KMqikl
 zv4trhyL
 U0hvZuqdj2XyxWSgxAZqrMmnbc0SF7pA9evrMHbJOkrudgmqBMCTc82wSRLup4t7SMTbZX7A8aK4ifaGWkpP9lTxSePdOd8G2xx3cyR7fnRQE31F4ojPML/yWifwFPLwOCHZiD8kYZa+gdX7r7VK2bdtdl2a/bwiR7Fxs6b76ZzGGlNLNs1UK1l7ENots0NgdNBrVYQ1Bhwylc6FRc6zBdx4H44xNt/ICVljM8FH0ZABQyBFhQhtsx2ylUU0L3Lq+bgbgIJFndCh0tftM4dN4XvNa3iDZBG4ujaCgeVI3AwJNQkD0aGFFF+Sxzwcm6ugYvbigCsxDj+OdwZycAJYdzKGiXhzkpB8kHa1zOvoUNmByuXdIYseQ5ioJS0U1HQAFEEk2GOyvg8iyKIW/IChrf+ykA98CyCtnyGPw9VhB1aPw4BRvnndkXoBk4FvP7DHrvAw5/TghqT8+5YxdN8bi+TCLcQW9GLLff/sBrfNKCxrVyXq/NeKftmdn8++mkwuqvP5eT2wQSxMpj7AxthBBwUCDFfG3xOrPKdFo
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

A folio will have outstanding references if it is present in a per-CPU
lru_add fbatch. guest_memfd does not actually participate in LRU, but
freshly-allocated folios are still added to the lru_add fbatch for batch
LRU statistics processing.

A folio may also have extra refcounts if it is on the mlock fbatch.

These two known usages of the folio are handled by draining both the
lru_add and mlock fbatches for the folio. After draining, if the refcount
is still elevated, then there are truly outstanding references.

If the page may be DMA-pinned, DMA is using it and hence there are
outstanding references. Checking if the page may be DMA-pinned can have
false positives, but that is only with a significant number of refcounts,
at which point draining LRU is not going to move the needle - it can still
be concluded that the folio has outstanding references.

If the page is still mapped after guest_memfd tried to unmap it earlier in
the conversion process, it also has outstanding references.

Exit early to avoid unnecessary draining in these two cases. If an
outstanding reference is detected, stop scanning, record the failing
offset, and return immediately.

Track the drain status to avoid repeatedly draining LRU caches across
multiple folios while scanning the requested range.

Update the kvm_memory_attributes2 structure to include an error_offset
field. This allows KVM to report the exact offset where a conversion
failed. If the safety check fails, return -EAGAIN and copy the error_offset
back to userspace so that it can potentially retry the operation or handle
the failure gracefully.

Report error_offset if preallocating memory to track attributes fails with
-ENOMEM as well, in which case the start offset of the range is returned.

Update documentation to document the error_offset field and the possible
-EAGAIN error.

Suggested-by: David Hildenbrand <david@kernel.org>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 Documentation/virt/kvm/api.rst | 10 +++++
 include/uapi/linux/kvm.h       |  3 +-
 virt/kvm/guest_memfd.c         | 90 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 97 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 027156508d04b..67f0f290797ab 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6741,6 +6741,16 @@ which includes operations such as unmapping pages from the host or
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
 
 .. _kvm_run:
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
index 803c7cdbbe0f6..2de39ce8aec13 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 
 #include "kvm_mm.h"
 #include "guest_memfd.h"
@@ -538,8 +539,58 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
 	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
 }
 
+static bool __folio_has_outstanding_references(struct folio *folio,
+					       enum lru_cache_drained *drained)
+{
+	if (folio_maybe_dma_pinned(folio) || folio_mapped(folio))
+		return true;
+
+	/* 1 reference held by filemap_get_folios() in the folio batch. */
+	lru_cache_drain_for_folio(folio, 1, drained);
+
+	/*
+	 * Outstanding references are anything other than those from the page
+	 * cache, plus 1 temporary reference held by filemap_get_folios() in the
+	 * folio batch.
+	 */
+	return folio_ref_count(folio) != folio_nr_pages(folio) + 1;
+}
+
+static bool kvm_gmem_has_outstanding_references(struct inode *inode,
+						pgoff_t start, size_t nr_pages,
+						pgoff_t *err_index)
+{
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t last = start + nr_pages - 1;
+	struct folio_batch fbatch;
+	pgoff_t next;
+	int i;
+
+	folio_batch_init(&fbatch);
+
+	next = start;
+	while (filemap_get_folios(mapping, &next, last, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			if (__folio_has_outstanding_references(folio, &drained)) {
+				*err_index = max(start, folio->index);
+				folio_batch_release(&fbatch);
+				return true;
+			}
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return false;
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
-				     size_t nr_pages, uint64_t attrs)
+				     size_t nr_pages, uint64_t attrs,
+				     pgoff_t *err_index)
 {
 	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 	struct address_space *mapping = inode->i_mapping;
@@ -556,8 +607,28 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
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
@@ -578,9 +649,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
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
@@ -606,8 +678,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 
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
2.55.0.1007.g17ff1f9808-goog



