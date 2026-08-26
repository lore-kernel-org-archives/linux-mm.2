Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE4CC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD476B00AD; Wed, 26 Aug 2026 05:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B7E6B00AE; Wed, 26 Aug 2026 05:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4470F6B00AF; Wed, 26 Aug 2026 05:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5696B00AD
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9508AA02D2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:41 +0000 (UTC)
X-FDA: 85142870442.05.7E9018F
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf30.hostedemail.com (Postfix) with ESMTP id C817380007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fvKz+4k5;
	spf=pass (imf30.hostedemail.com: domain of 3bq-OagsKCGMBDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3bq-OagsKCGMBDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735919;
	b=V1kO16HIMAsl6mUOQJt1UHea6pBE6M/jIBFDpYpNAjccuVD8m9NpmNHUsgcLnlM0RbwBBG
	8u7RjSlOZKVUbPptoMC7rvpSJJ2dceghQyu9pglBAC1AYgp/ZBtzL86baLmu0hgEZXi2G3
	H3Ryfh0OaaR+idz8qUpeugub5TYk5rs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fvKz+4k5;
	spf=pass (imf30.hostedemail.com: domain of 3bq-OagsKCGMBDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3bq-OagsKCGMBDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/nf3e4536rn08VcIwbRdla3FrzM9D86FJQTH62XB18=;
	b=K6UDa3OVU0Ho7OgfeEYa10mIiehhSlYMMy3/NFJ2qub6oleiIjG44tvXebnVyDeb8CnPx/
	BS3eFfAtpta4ma4Y6Xl2Gytlv26bWOsOc3E7XEQe3lGJxb03G1oSfggV/S583szNeu6/7o
	as0sMc7QSOXY3/RFQqxctOaA0izyh+I=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbb467e56aaso608916a12.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735919; x=1788340719; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S/nf3e4536rn08VcIwbRdla3FrzM9D86FJQTH62XB18=;
        b=fvKz+4k5yhQHjmkkYxn3j8rIybWDb/0gG1JLDGFXwBhq90zfKY6RW9hfAlQbfg6a15
         ckZlqXPnaylQiSMrWIkRtqmCTEUNp+3BkwAOULBCS2YUt8StnAynedMiD3k5SKe1GM4T
         H67YNylpeDkQNQ9SKOHII0+BUnYLuAe+YI0dWP38kxDzCc+Di65DxhsR6GP9Uh55Obcw
         Bouh08g0jpDsE1ZEGNp0xNhknV02mh9dJdh19pkIskzYzRvwkhOxV8g7mN7ibwd4jSis
         dlvG5V4td7icY2nkig1SSH/AwM1ZAU5y9WL+HY29w/ExieqC1MhwYF1LmZ9DA1x/5HiR
         Cbdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735919; x=1788340719;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S/nf3e4536rn08VcIwbRdla3FrzM9D86FJQTH62XB18=;
        b=R2nGQjuB4NbKq30RglW6rEYv++m0T7wTIgBzWYFaThFl6qKBkxUmhMYx57HyPLgdzf
         p4G2XRLfwzIUKoy8CFQbMgnTuhfPurCmAeDjsIFLEgXcRmgvw0Z55CcdpLjl6Qgi3GdL
         KKMFVSJhqegoz28oKT2y7+1twC7Kgf9DDalrsgA6PiFw0Kfo0vTvGXT5Qsl8Y2iP9sIB
         hN+tZASNmXDGw+YM2nv9F41T32WJWe5dYJboV42ymfDbt4/K9AOsuujFihRXta0B4+Dx
         C/NNRX1QxJo8UNBUSRztCGY+VN9DEAn8A7EY+CSKmBlkbQ3KveR88dpZABWm8Y5BKZLZ
         Nf1A==
X-Forwarded-Encrypted: i=1; AHgh+RovHCejJxtoZQpX0VFWw8SEBYuzgHvq3+xnvEHCpmM8oxxlhOkoa1Izv0ywT/icNAnDqIELE0lxwA==@kvack.org
X-Gm-Message-State: AFuF++nc/PuGNkMfK0DID5lswg5RnRf+CWIje25NIkfSMb1Pt9NOTRgT
	VzqOiz/gvpQ97GuuyAyp0Gr8N9HdhX9QoaZnsKwbyVPuSIuIzDcJUni/Oxs3uReK/tv6N1z0lsR
	3AEgj68rVov10tEQ8KrubJMcs5A==
X-Received: from pgig7.prod.google.com ([2002:a63:f407:0:b0:cc1:c7d3:7c7b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:a383:b0:3cd:8d15:895e with SMTP id adf61e73a8af0-3cf84b53689mr11572460637.12.1787735918168;
 Wed, 26 Aug 2026 02:18:38 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:16 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=4708;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ZTwn4UyMShrGZfEU90otJVup2JEojFMgiToKCnnSVVE=; b=dDBRMblwUg6UwX2I1hz2Tpxt+EI3WovENt6hqBknKpraB0X285GZYRtS86E6IMk5svSgepv73
 EfxqI68rjF/CyC9ce+QdXDFmPsPxg8E1UYpFu6gAUyL8f5QVEBtho9j
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-18-0a15d8a799aa@google.com>
Subject: [PATCH v11 18/46] KVM: guest_memfd: Handle lru_add fbatch refcounts
 during conversion safety check
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: 8og9uhd1cgfeg9mhjezbebayz9cjfjo6
X-Rspamd-Queue-Id: C817380007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787735919-494142
X-HE-Meta: U2FsdGVkX19WsnmpPEYuT0B5n4YHQ0wN5Ek797VUiUMG/sIKj7FyMhsIm9jT5FgZs7nBvW7CvakV1fXl03DAgoRfRiOKnDCIksuz/d/9bPJnalkFPLpgKNddXGh5R68RXPs9ki0mm1jgFh28hIK0XoCo767ct+P2BaAMa1jLGM0au/EXcAPvl99UK+5J+w+E+fcYqGH1I0Dmks46tUw1GNrarxQ5MmIKAaH0p6Ynj06kp3RsXCn0W9405d2nTAefaAS32TA8Oba5brk22sLyd1qEp7fZq7568RXSPDuavvRLXbugrnpz9I9JQ9qGpRRKh/njr68fRsT71NARerebyOLdhAWz80ay30LPd+zltM5iy4JZiCTVEAhnJ/R8xy74ra1ooMpp+6O8sj+Hg+jt+7q8cDEoIusrinStqFZscdRU9J26uaT7nu7svhp9zZFZII3+7LqbH/edYu4YrW4jLoQDPJQMd+1401sD+Rkp+Qt2JaljN5Z9+Zz3Fx8sSyvxYcOERYF0ki5nhvYuALWqSov8KPRm3qyWX87DN+xGPKlVbAOEtjytB9le7XGrHUZy4fFy6mY5R7JCker5zMlEhZ/+mvMOtzWXGB8hCtUs3QuXXfxaRjxbuRMcn2yeGTO86x83ftLgXKiNU9jjL56L+coKiecOf52SRTkvg6rHkh7BPw8pUgU05vh1OiJc41SprbjMdRa7mU4OIb7o9NERXp2OpZtgBYTLhTC0eFcllCfS3nHyj5F6Y5ngEM2/h0eMgtba5vdH6q4smjNWTd3oCOq1GCAt9tVx0eMnYfI95D0tuzDCc0iha1Up8t46NgNfvmNBy6AJQvs/EvfIiSXN3GncCXHvPB1eq2+dar8GBx74zu05h3WG1ei9imAbmt/u4tSTTMny4nh/T6wu1vdN2NuT7eVCibcfaIbIWQMfWshB9Ro7ggLLdX9IKt9GMZbYwUnTQt3C6ozDYVLEC8U
 LVCkbmZW
 XszrDl6zFBaQPblxVGRu1hD36j5WMAsW8BZfAIofcqgKOm9PuW8eNIFTmbJC0oOaZps4zbgJ7A17O0W6t9+5mRFU1dgrCvP+oC6Kk+1myM7WiK4nLb3ZKNi4xHlkDTBgWFeTqhVFifQvpGKTTsZV8Q5v+9hl6boCVbAj/+OmXsZpNfqYZyek6mTFfpVQqZn3oA6S6pVZJofMric/wmSVNmmPPfrv0LEKFsm4xx7b4C/Xz5VbCpZSDPtadMNN1/HjHXCka5whKHkfUoXnklsQahqquhu+O/AGz/4a7pTkc52SoIeyVQocVtX3yw7DHaSkjFNSLYNgsyFG5WQHcC963fBQzyf0Bg9pHON4SdvqnbC9Tdmc1lq9lbujmhShXnZLmWgCMuWgth9+dIj0TxtOrAhRewjuir8CNukaxF8+Bscc95v0d2GUvHgPstktMb5vLVeJ4opWFd0SgzX3jcD9dZpWg1oqWVu5X9G4DiM/Nfm1swAKAt1xpNoXUHY5g7pXRWLS3VS4USbFRuj+gB42ty8veEATlye0w3jiivp82q0OLdaK6jda4S2K37pNNXRjXocmAlS2oKGyM36bPbzncm/DWeBBf+uI4Hl35WhI3sne/R7upwTwRuohMDeOxArYbzKP5RVeqKrJbUK7SLxTPIyqMIQiiZjFp3n2kekf9ZhZLPiOuuzBWQOemA2XavCcX6sr6KzyA6TbKEOzuSzcCzPDb6bZmW47qwp4IjjWrtfy5d0fGrQVhxvZsf8xoyTNFsZed
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 mm/swap.c              |  2 ++
 virt/kvm/guest_memfd.c | 30 ++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

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
index 6dc199be0eb87..4912f90567fe8 100644
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
2.55.0.887.g758fc8c411-goog


