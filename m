Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF154CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3949B6B00A5; Thu,  2 Apr 2026 00:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B7A6B00A7; Thu,  2 Apr 2026 00:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7E06B00A8; Thu,  2 Apr 2026 00:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D00D6B00A5
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:13:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8E8D13AB1A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:23 +0000 (UTC)
X-FDA: 84612296286.27.E8307BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1E889120008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Bt28/m2f";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9y2awS9LuRlealZ4Gy7NH1RFxFMmoDwRiQnqQfCsJA=;
	b=mb7LvHFHy/f1Iy0dmgl8zbau+ba0yqfYNCwlWxjCHxCZjkwGXZYFR5KmgsU6utXqZGZO6v
	zn8rSHz0tieGIjcANMO87M7ChUfrQ/UpzVZ0DpT2FUcUiq07y4+YNBEMc2J/aJgB67lRF4
	T9CmGuA7/7CwM8jPTPFCyMarjaEkdFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103202; a=rsa-sha256;
	cv=none;
	b=Trfr6r+V4VY4NQ2bKqSTCt5Dvf9CLY53rzYLpLRzYUHbamuMMoSJTDIA7KkSVr7JB/wrpl
	ZoRd/UbaN4ycVKaL6wOIbehAUqqwwebMjeOTJ083FozHgUmQKXGenO1R6MtPGufZqKAuOt
	8acZNFhLuIDr1m1PkRDfSreiW7LYj3k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Bt28/m2f";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A152A61861;
	Thu,  2 Apr 2026 04:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178EFC19423;
	Thu,  2 Apr 2026 04:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103201;
	bh=5vaQGQBc3neyldkli11Rg6Y+SDtyLj7BMfixF4/GPSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bt28/m2fkum5A4fexrkHIDiwLmCZisqPq7kYstTpZa4gEYge6jHYkI04dMh8zD8uw
	 Z2KjPZ2GxXl1j5Y/ahMEY7rHgurRo+c/83O8XQj65p1XtNHEOfoXNVei3oY41GnY9m
	 oe9q7EwPbyUpcMLozGy5HkrGB9QGlPUdhRlmbNNV0HKXR21y6jtVRSwKLdU6N7+JVA
	 MPKbfI253YnvrF296FFA/9AFxYH9o3fuqQ5JBlzyuGE9+4s4UaZjnp8X40iLlR/eEz
	 jCsqbSNE7alCszlRzkgCMtGJHHUovkALONmzswZrWCLGdDC1uQLrSJMrXY2RCvwpCh
	 a/Lfg2MwHGhPQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 11/15] userfaultfd: mfill_atomic(): remove retry logic
Date: Thu,  2 Apr 2026 07:11:52 +0300
Message-ID: <20260402041156.1377214-12-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E889120008
X-Stat-Signature: kwqhzzxqjy41nhrbnq34sfokuqtdosmh
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775103201-649630
X-HE-Meta: U2FsdGVkX18Wn5Da6ShG3TH3L/cLrWDnRGu/RpH0VAhN86qKIRV0PprT3r1CkY6xqMRODX7qPulesMraYk9+C2V3QnwEVW9TaE9n2fJLmd52iQB4+Pd+N01mw3BeWdNmedYBdeBppy56/66i+ojEVvNXB5kxY4gLLp/8QiQISyEaZoMxEiB/Ff4x+pnKki6hfg7Zc2MgBicSBC/iCjdgoK/62oSs1josvWSUHFqUr+FH6yXoDL8K4D/F8RRy0x2qhvDD4fIenYGcAu7NcA8QFk6kZN9/GNJh7Mo9FbGiQmEu9dnxiFngCYdpK+ySaDjR4A67w0ksBGg4gseRuFxJaITISupif0NMV9ccSGoU2NjWoOvPs6WWKlbCNRPFpJlQOI+sFvXRsxZbsHtmotCjK+wUlmbcqXBibbw3fo7NB6WYhxXSZLy1oNMVsPJXBf38OwGLjoAtvPmCFj9NLMR6Btq3CFDB1ON8jsNeGl5EenPBTCW6qjAtIqlWh61QnTLAZpJks5vYG3q3drjbLBB/H7J5W2rDu6Hf8uHOOZXhkxFBCbFvWIKvdWja6aib4xu5da6YvEC77+D7rlTBaesVUlm9Bc8QB+v6tzrWSAyjxOM7bf0JxDLEJOjHVtlJASfDvni67QIbdGmteIsGJihEUpOKBSGyn+WAuuCuECIxZxga+7/+2L6j9OaiK4Scmrh2cMAlrdqS9Eck3BksdOrZRZqPoVKZDcUnPkIYxb7M1kqIwG3zNMI8B2xVBD3PVqItobcaET1J/GmuSku6Kg+uW5NxieeIS+bNP6dD48nZpPXYmHGZeQgLizLtWl145cRY5bP21wQh9mj2qBYVt2D1yyO2jahF+zAOc6CMGrIBG/r0acO0cAYXtDNMXkdaEQTlRYHyeM++nBKQqD4o3nR7tkdadunMTf/WoTzds1XH85NdGu18lR6HevzXURYEDR2+GinyfRNuxlVjLjkiZv3
 bycvx6jq
 0w67l+Ad6DBamXLIyDdAO5jedFq7YqdkYwIkOd2g9vBEkcu5coGbUhCtaqiArHi4SqKMyr9iEhckk+BwzhwgXiQ8Dhv9gl0xARiRNq2GmN7xKaP/EkXj5Bt8UFAypBRm18Xdq7jE0qKXp4WXtAmQw7gr7TXuNMlM8KdDgKeqO3FdihGtPeQaPc0ImvI6WnnEB0bnVaFfSM9XQnvdx26lk9dq90hBcnBz6JRQBWJIaoY1lUietVOpS00xnb2MYz1uQu8TxK8BcZoIKSFoRDH3Y83k5jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Since __mfill_atomic_pte() handles the retry for both anonymous and shmem,
there is no need to retry copying the date from the userspace in the loop
in mfill_atomic().

Drop the retry logic from mfill_atomic().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e672a9e45d0c..935a3f6ebeed 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -29,7 +29,6 @@ struct mfill_state {
 	struct vm_area_struct *vma;
 	unsigned long src_addr;
 	unsigned long dst_addr;
-	struct folio *folio;
 	pmd_t *pmd;
 };
 
@@ -899,7 +898,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	VM_WARN_ON_ONCE(src_start + len <= src_start);
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
-retry:
 	err = mfill_get_vma(&state);
 	if (err)
 		goto out;
@@ -926,26 +924,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
-		if (unlikely(err == -ENOENT)) {
-			void *kaddr;
-
-			mfill_put_vma(&state);
-			VM_WARN_ON_ONCE(!state.folio);
-
-			kaddr = kmap_local_folio(state.folio, 0);
-			err = copy_from_user(kaddr,
-					     (const void __user *)state.src_addr,
-					     PAGE_SIZE);
-			kunmap_local(kaddr);
-			if (unlikely(err)) {
-				err = -EFAULT;
-				goto out;
-			}
-			flush_dcache_folio(state.folio);
-			goto retry;
-		} else
-			VM_WARN_ON_ONCE(state.folio);
-
 		if (!err) {
 			state.dst_addr += PAGE_SIZE;
 			state.src_addr += PAGE_SIZE;
@@ -960,8 +938,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 
 	mfill_put_vma(&state);
 out:
-	if (state.folio)
-		folio_put(state.folio);
 	VM_WARN_ON_ONCE(copied < 0);
 	VM_WARN_ON_ONCE(err > 0);
 	VM_WARN_ON_ONCE(!copied && !err);
-- 
2.53.0


