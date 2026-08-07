Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A275CC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1976B00C5; Fri,  7 Aug 2026 17:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0528D6B00C8; Fri,  7 Aug 2026 17:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14246B00C5; Fri,  7 Aug 2026 17:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CABA6B00C5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D2701C0169
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:57 +0000 (UTC)
X-FDA: 85075823994.27.F425E60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3B9ABA000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FLjD6LF7;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139575;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nv8Gn0Dbbvp5YSY1snQEMuaj8Xoj78bGAh3lFaC4z+8=;
	b=dfiJG1vkw/U1U6AsvBDbKD6avH/OAKJhEVf42SoEqvfspGZ54+Z53vABVD/wmhCYyn3ETE
	/WLMBFGLZm+3KY2XLs69kYYZO+kJAVNpv9hf5Z5D/fpPgpAhCioheBpVlf4QBUA28eKndM
	Od0Xv0uRNKd7CCwLbkEkxR0gUvzE7wM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FLjD6LF7;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139575;
	b=oFGs8y4cQXPy37u3/aI9qLvtKefOahj6NmgJNP+StS84Bqy23Ks99WLS5EtzyEiItZ9I3f
	L3WEsPUbvefvwlgzJkMeRE36bw5cdaF0GFMoZN4zHbMfUSyXAel1XghBAlIYLgyYIX7kh5
	AfTtKXUzBczSLEJzk047joRiYq/1HzA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EDF045160;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27989C4AF4D;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139569;
	bh=TkzoIndNGWAz7eMJZIeS00Akw8QP2H+V8GKbGu+OhPY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FLjD6LF7CmdK9sSRhsqRFy72cX5AQdbHg9Gl/7NkFIrl/CCSM9yBJgZHB/WqJXmIg
	 9zVspnWnCfoGkk9XU4xt4dv0ojCKW2JaHsKzaptjrgUQ9te1ucdBwxfyTRVYHotQXb
	 hsXbkbKpM6OdbeVbTroe2kT7zk6zfRXrF9rgf8dlqgldxhr8amZ+U46LWAS6PfxdYp
	 TgT8EX+wurZzkD+hy53R22CVQk+i4N+abVS/WFAOU+Zigh8aVrhjwLPJj/32h1fHnD
	 ETYPcSyurHVqU0vD8202HRqss3gQDOpppFFdrAs7pDyH1iAfpPJat33TU40+k7O2lz
	 qqxcdLg8RcZag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065F0C5ACD4;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:54 -0700
Subject: [PATCH v10 15/41] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-15-2fc18ee6d3ba@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=3762;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=vRHAPnsy/a831M2QO9lXaFqyTG6Mc0Skqo/1hc4/61s=;
 b=9TIb+ZXbdQMmrXLDC7072TqBL/mub/d5Ks6MUbovt3WcKeDpnixAU2yGfF0KPtDV9N+i5+ZFg
 hfk34FX6oJiCGmv+DpvAaRMkwVZbxV9kE6Xqd6nBrhbp7s0dXmGD85o
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B9ABA000A
X-Stat-Signature: 7ugh14i6aiykt9an94eqqox46ypsegs6
X-HE-Tag: 1786139575-87714
X-HE-Meta: U2FsdGVkX1/1SA4nRAmR/6UQJvMbHHE2MDAERUcyfZcsW/jq3bpjbjIlvhRq/4LwYI7expiJGrxTnDI+gGRzS8XjWPt+JPlTjVbDk+YiU5O5VFIGrWTrkJauvDL+fufcr5KbIr/MS8XDMMCjaSQUv3cp/VeW/S4P7Zz/mpeD21KXUSp4NvNVbW3cq6Zm9j00/n1eHet2XtWKQf04Lqp+kyti1y0cpPTJSQTtcVNnDuFyj7E1C34IEmu6by5OB7dXuAXOoxL0HrUNkG084W/Vj+3sIu1O3VHU83pWCwpinT9xXrUpzNdNl3ZnmgnWbYq48T2ICQoOWuT9lIUU48v4ysymfPpwOCGZ8BaCgN5iSy921KcVWgCpz4BJPQfW3BLkTwE22OPrJCu44RxDiVIm0xa1z2IYQi3FlH6U+zi4/Yw/Bcq7+C6Z4kklhLmwTEM0w5rsF1hORZZj1QJX3M31a+Rdp/GN3AnbADOX9Vyi2vdytScYK0xL2UbopuLbv4gAdmr95qXaRoij8Gf6RBQosTT8/DAAA9vXo15X/jGFtwM8aGzxe37fKsY8+NguYL2VzFxAyLrP0p0i7LdLu0/bX5VX5I3ek3VZfnupbZ8jbaf2dZjnpTKeiAf7Av8/Of5ar04BPFOWkZjgqZV0Rm11U0QoqOlt2jMc8U8+k2M4f2xbzd5RwGRI0m0mHoFW/fcxR/lEq0x4jAgnUCEVBfMvRk2CqrmTiU4IWRXAL8xivc+3FzbMYJxXTigUHsK8fODqRmcniqn3EHoC7J+bBJytrtG4pJAysDVQjq6TmCNi9O6yeGyW8G4ZrHdxg5vxfDJP2h1Ggi4l78JBZt1dfH1AeIHc+i0H4emWSPx/AeyaI8IAQPb5kVpH3F7nCv88xHo7gh6eBrttb1k23i6IXKFYATVHHx5E/3be3R60rlRU8fkM4Jbr8JmL0yCYn3/Py5bUoMhC5aKLNA9D2MKjXRJ
 LyLhDOzi
 NgUnsn6adPz9vG9xxoWwtznmIA3vI0shWZqSynH/Zt+atGJNeaKTBsZfTLMkRnT/GK1m2xZ0149wIp9HBLS92cXOPZwre52qN06K4LvhppXWnzDmscV2sXOHrISn7+9fRpzuSHTxZZNInAlIwgIHP0Ol1Grn2wGGTtoyvfCP25nFiNX6N+rKpCfViGVU1cvORzwU/K2QB48/EMKxmT+fnuJD0pwylV0WG0aQEhDcGUg71AElF/SYI0nFA60ifdAXC18dinakqvXmY6PxJaXFnFiD9PrIrmNZ/J0/Q4AZwGVlS35D1HtPNnQXzCOmPPy3a0SaTl1zfQ79ez4VwaGD/oBS105STomGpYL7/Xjly1I5un5ePuP7Zdh92TJOnLB5CyIwlyRvS4iFz9gl6d1z9Q1BMoNKVZBt1aRi8hn8y9zVjO1WTIKsKZ3NJLcB9qH1yMF/99o41jPo6O/SRMR8XZvU0FL9CkmJdE62mTyc09Aix+0UjfLPahgBF56KLT6HRhENIqduRCu7x7tWuVCEabkIB/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

A guest_memfd folio is safe for conversion if guest_memfd holds the last
references on it. Any other references on the folio may indicate another
user, and guest_memfd cannot convert it to private if there may be an
existing host user.

A folio will have extra refcounts if it is present in a per-CPU lru_add
fbatch. guest_memfd does not actually participate in LRU, but
freshly-allocated folios are still added to the lru_add fbatch for batch
LRU statistics processing.

This one known "usage" of the folio is handled by draining the lru_add
fbatch. After draining, if the refcount is still elevated, then there's
truly some other user of this page, and the page is not safe for
conversion.

If the page may be dma pinned, DMA is obviously using it and hence not safe
for conversions. If the page is still mapped after guest_memfd tried to
unmap it earlier in the conversion process, it is also obviously not safe
for conversion. Exit early to avoid unnecessary draining in these 2 cases.

Provide a drain status to only drain once ever while processing a batch of
folios.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/swap.c              |  2 ++
 virt/kvm/guest_memfd.c | 23 +++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 8e965c8ce9aa9..9f511b97ab110 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -37,6 +37,7 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/kvm_types.h>
 
 #include "internal.h"
 
@@ -995,6 +996,7 @@ void lru_cache_drain_for_folio(const struct folio *folio,
 			*drained = LRU_CACHE_DRAINED_ALL;
 	}
 }
+EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
 
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 896699afcad9d..030af0855f8b0 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 
 #include "kvm_mm.h"
 #include "guest_memfd.h"
@@ -542,11 +543,26 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
 	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
 }
 
+static bool __folio_safe_for_conversion(struct folio *folio,
+					enum lru_cache_drained *drained)
+{
+	const int filemap_get_folios_refcount = 1;
+
+	if (folio_maybe_dma_pinned(folio) || folio_mapped(folio))
+		return false;
+
+	lru_cache_drain_for_folio(folio, filemap_get_folios_refcount,
+				  drained);
+
+	return folio_ref_count(folio) ==
+	       folio_nr_pages(folio) + filemap_get_folios_refcount;
+}
+
 static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 					    size_t nr_pages, pgoff_t *err_index)
 {
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	struct address_space *mapping = inode->i_mapping;
-	const int filemap_get_folios_refcount = 1;
 	pgoff_t last = start + nr_pages - 1;
 	struct folio_batch fbatch;
 	bool safe = true;
@@ -560,9 +576,8 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
 			struct folio *folio = fbatch.folios[i];
 
-			if (folio_ref_count(folio) !=
-			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
-				safe = false;
+			safe = __folio_safe_for_conversion(folio, &drained);
+			if (!safe) {
 				*err_index = max(start, folio->index);
 				break;
 			}

-- 
2.55.0.654.g21b8a5bc05-goog



