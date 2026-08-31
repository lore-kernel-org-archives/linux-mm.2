Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE82AC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04216B00AB; Sun, 30 Aug 2026 20:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5866B00AC; Sun, 30 Aug 2026 20:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C786B00AD; Sun, 30 Aug 2026 20:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 704186B00AB
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E4951A03C3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:31 +0000 (UTC)
X-FDA: 85159670862.20.F8AB81C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 073C7A0007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J7ixRXTW;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135929;
	b=8mAF18Ce+ixMOxQ8kA+LP71FDkvTiZ8yYsGaMU7mQnkTbOLtqBFR2lCPqFD5A1QuxXVA+W
	RW/aopXrLpnO9yJ9YVLJb8A7u3S8Mz9SD6wZsvs8Ui4GLStORn+Fhv+z+/MJwwKVL0v3h9
	qA6W28/d8jDAKGjKEMNg+mYiU4IkjTI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135929;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yoh3WuzrcEJJWcfzWiQW8FrqYn2BMbIMaohBWnxNBKo=;
	b=cC+miYt0+yaxsumyOG1U3gwzoNTPXIoxfrxXnT3PgmxpAKiEgLJWQIZY5fageY2Oa1FhHT
	j81oZ25KiLDuY8cQSTtVzvaY4cr8uWBMaE4H05BlBHhEX44sNZBY38LyMgyb8pC6cOLcTk
	mRbGVEGDHxubHaUBO2rDTfnPYLERuEA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J7ixRXTW;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9955544842;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C704C2BD04;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135921;
	bh=INfl/U4MD7DiNVtE20rEnCF+KqGWKq4XKxW9ss03gIs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=J7ixRXTWSc5y6i4hxgZ+vagyxK1c4T1Q5OxM7n49KwqCLSdHU+Q5P1825KMWSNCCl
	 6QzFq+JulXODd9QaYpj1JpQMbEE22BcGNDHQYBIRQX5CbCSKNoSn3V5xOjKiOcLHUp
	 6474IBrpI9oaHry4lMCko9TWcsafgUUhylnSP5nbH/kgvo0d3w8QwIvp9jbRpkZkVg
	 lZlMeE2m1WBompIa00FCrC1XZeLeO1Io9MQFNwts96/g7IDNevknCIHRf2RZaB+R1H
	 RA8MLBO7bcV4d+S1AUDPRg9bAbU37BgsXyZBO3ocN3AX4XQfLKe/Y8lWWZFV9i55PL
	 LV61OtRr3BBkw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E9BC61DFD;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:19 -0700
Subject: [PATCH v12 18/45] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-18-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=4735;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Ty5BgQhIGN1xkSlbhdIOV4bbPZLbusnibdr1eTvGdlc=;
 b=91swEloDGQUbfYBsHAl/7syD81mtjIP2F0V0Ab45bJ3IEkR1Q5bwBtEL76LfwbU26GezrPCHL
 XT0wJWHs3EeBheGTp9WnqG2e2q+vGU7johvpQZYqq79+7IhHv7ZWqRu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 073C7A0007
X-Stat-Signature: cjpfiizg5jjg3zeifrk9syxon8ni8zqe
X-HE-Tag: 1788135928-297067
X-HE-Meta: U2FsdGVkX189MRjo7YSRthavVaNDJH5yeKzZ8vnsiFTw2fVz+Mr8KQJBrVbqKfYb7/6PRQQqxlDZAIaiUrgo/zjbEKkdn21rJNUJA5SylqtH4i2l/M3ORVbeDYDVHUyzrd0t7F/O6TFGSgLl6dgg8omFoXGrk2gBUGqWr3+YITKKAjpIwoD2/ddZCQNGx5wu8iF8EAWC9kEvlPnm08cbsmaRejuHyfX6MBMQngYISPyV/Sd69fOwJgQw7vJcD3JLeamlsZFos/ZGysaVYIXB3i6MqLeGLOqOTZYuh3RtkNSkod38/kMyguB8SY6rkNi1eVB3LxpRwtzZEP3CtOeb2m48ymTJ5sVk+dNO+ux/ta1Q6qZlJPSRh1uaU0gQYHOQIMUbUqR+cyikUc8atT1HMMVvsjKAHU9Dgi+dHn/vQCh+8DQaj5t6XVsGJpAgQ3m40nheJxYU/bL5q7NuLVecQ6PnZUBt7NYYDb/8fmo9ESUmoxEK+7DeTdDgl4hyQVMJM3qublYTDUPuac5HjQjk9W48aCjkGMOh8SY7GPJMr8naOTkaU//zblRWJoB16RobBCh4QB4D94nxwxVGqrenM5uaWnR58N+eAvCH3lBbChGfia8Ze1xN5kJfWGx5GK186HVQ3RPyMXHsR4EuQI9+1RfzLZoTsuT92VUsW8ADcVd0ZsaH5s62XiR27Q9L2hxbyNTsl5rSaGqsU5Jqn+wh/J5WOfiKZppDrZabpIXgAb+GKmWQBobRY8lNtCek+q1cQVFlGF/Vl/IUnaz8vymE3Lldx06ZqNjMYcrtOPZnObd6v2WlB2FsGqB04Jy4NIB9H1mZpIh9oMlO6UHZqtiM31p8M2cwHyHUBRIbOX5SEQi7tAKjD0ZV+1l89qPTfWfZdhyq63wGUinIGH6XWCUqFhYStOjJlxCauDUCh+lnD1GYChWWYosTeuzvqn92cHKbrwjIBh9KLcdmIKUBwPd
 SAdNe7lJ
 HElq5cVIKHXym60ZyS+Xlt3WX5B4iR4NRFNugGkmd1KGPCMCnWbYqcUlvQm6B4BEE0Hg+CGVVe8ebJt/dB+3QEowqDIqxetZl5MANw/N60f+EhhxkrFs/RDRURCFTMp3gD6rRnDgQEMsPcdR1LiE1sCB4ncSg4JQIdSMesIM+N/cbWqnBS2nXY744MyWZD5D/BONqh9oRxmIhbJT14XHeap9yliPyyXXmLZukmQGJKVnP6MVrr2+goYjDxoOW+GgmxXomsqjOTc5t46B03IhO6g+81FDCuqbT0AN53jYucpHEzOb14iDk4PxN6ys2M4o4AnxeuAafrwIL5aienmcO+Vi8VfqdWuE/P7B9mqJRI6trBnTsq1T0TjgHD4YkJAonCxOayTIsk/M3itDH+KeaFpy+gAj8IJn2clidas/bNq567HPw5Hc3xeoUQJAEUUPK52YrFLntVHPQDl9Kz4nxLB6jNzu1Q+9AJHYYoNlpTxmXCVhfNl/lDCMkzeJv8kWI6ib1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

A guest_memfd folio has no outstanding references if guest_memfd holds the
only references on it. Any other references on the folio may indicate
another user, and guest_memfd cannot convert it to private if there may be
an existing host user.

A folio will have outstanding references if it is present in a per-CPU
lru_add fbatch. guest_memfd does not actually participate in LRU, but
freshly-allocated folios are still added to the lru_add fbatch for batch
LRU statistics processing.

A folio may also have extra refcounts if it is on the mlock fbatch.

These two known "usages" of the folio are handled by calling
lru_cache_drain_for_folio, which drains both the lru_add and mlock
fbatches. After draining, if the refcount is still elevated, then there are
truly outstanding references.

If the page may be dma pinned, DMA is using it and hence there are
outstanding references. folio_maybe_dma_pinned() can have false positives,
but that's only with a significant number of refcounts, at which point
draining LRU is not going to move the needle - it can still be concluded
that the folio has outstanding references.

If the page is still mapped after guest_memfd tried to unmap it earlier in
the conversion process, it also has outstanding references.

Return true and exit early to avoid unnecessary draining in these 2 cases.

Provide a drain status to only drain once ever while processing a batch of
folios.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/folio.c             |  2 ++
 virt/kvm/guest_memfd.c | 30 ++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index c02dcea9c03c2..50a6dbe55998e 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -33,6 +33,7 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/kvm_types.h>
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -926,6 +927,7 @@ void lru_cache_drain_for_folio(const struct folio *folio,
 			*drained = LRU_CACHE_DRAINED_ALL;
 	}
 }
+EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
 
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ac8e0c6d6e942..1fe935aaef36f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 
 #include "kvm_mm.h"
 #include "guest_memfd.h"
@@ -556,10 +557,28 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
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
 static bool kvm_gmem_has_outstanding_references(struct inode *inode,
 						pgoff_t start, size_t nr_pages,
 						pgoff_t *err_index)
 {
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	struct address_space *mapping = inode->i_mapping;
 	pgoff_t last = start + nr_pages - 1;
 	bool has_outstanding = false;
@@ -570,17 +589,12 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
 	folio_batch_init(&fbatch);
 
 	next = start;
-	while (has_outstanding && filemap_get_folios(mapping, &next, last, &fbatch)) {
+	while (!has_outstanding && filemap_get_folios(mapping, &next, last, &fbatch)) {
 		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
 			struct folio *folio = fbatch.folios[i];
 
-			/*
-			 * Outstanding references are anything other than those
-			 * from the page cache, plus 1 temporary reference held
-			 * by filemap_get_folios() in the folio batch.
-			 */
-			if (folio_ref_count(folio) != folio_nr_pages(folio) + 1) {
-				has_outstanding = true;
+			has_outstanding = __folio_has_outstanding_references(folio, &drained);
+			if (has_outstanding) {
 				*err_index = max(start, folio->index);
 				break;
 			}

-- 
2.55.0.897.gb25b4bd76c-goog



