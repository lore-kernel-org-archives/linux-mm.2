Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415A860A260C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EBr7lbGd
Received: by kanga.kvack.org (Postfix)
	id 5F8DE6B05BD; Wed, 18 Nov 2026 11:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D01B6B05BE; Wed, 18 Nov 2026 11:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6B66B05BF; Wed, 18 Nov 2026 11:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 292D66B05BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:19:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FD5C140775
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:19:46 +0000 (UTC)
X-FDA: 85448750772.06.F3C4227
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB832A0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:19:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBr7lbGd;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018784;
	b=oPsCYXzkzpX/HgmYZ6aV4TDdi59Sqz9dKK/zSZSAOhTQQg9/n1jTx/FYiljU85Yc5B72VE
	O6Xta2Jz3ubvBDOBkOsu7Ep28+kgPrsagTd4WNT+eS3fepAJEgQaQzH3ECh1Vv9Bbx89zZ
	1pmgL7jg0KgMMSSL389VlADOxMoZGjg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBr7lbGd;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIZqapb8xoPPZmibFU/FsBHC1hySFY51gzuyNap1WSU=;
	b=JrnhVHqSVcwFWfS/U+j1Aj+XKiHPsWIsBG3VOjMESQZYdAWciI68WvcXJP1gkQrD/pBWLz
	1wS7qer9cvR6EgvexE9yccOCKZUF0Vq1M7Dw8rrf4iqFrR359bQ/VikQNNX4At61Ap5Crg
	229X3lQmAhcB1tUgGdm4M7x/SwW+MNY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C2716285F;
	Wed, 18 Nov 2026 16:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FDF1F000C7;
	Wed, 18 Nov 2026 16:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018784;
	bh=FIZqapb8xoPPZmibFU/FsBHC1hySFY51gzuyNap1WSU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EBr7lbGdd3m9eZRuIT7kCU/l44o97EDmO41nPGVVjZtTrTV8X5jmEe5lRuagtVaPn
	 x5iLBuyBDUg1DvW5o4jNVWCOCGOYSYreSTcSuae+Z6952ruwHTPsIexa8euXHrXJq8
	 1yE0itI4dEfNJE+7Hj8H2+7iVM4hKZupA5eRoZ3igNGSj3FoWy4WgYIQ1gcw3+JX3I
	 6gtxmZma0+C7xe5mkPTDqBnSUZJ6gQqTouSJWxd7EaFd3HDKgua7n+0M63q86DZpUF
	 uewccdi3tVo5JARYvUY7tU0X+uclXfHIG+LrvkcY1UgkBHXFYNz+BWI1l0vH5KfilG
	 0KRGK1ACpTvvQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 18 Nov 2026 17:18:19 +0100
Subject: [PATCH v22 3/6] mm/page_alloc: make alloc_frozen_pages() available
 outside of mm
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-page-ownable-v22-3-d63ff73f4075@kernel.org>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
In-Reply-To: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
 David Hildenbrand <david@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Wilcox <willy@infradead.org>, Danilo Krummrich <dakr@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>
Cc: Igor B <igor.b@beldev.am>, Vitaly Wool <vitaly.wool@konsulko.se>, 
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4705; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=CSZp8YNPv6y1CiJdShh/fjzWy72Ib/hXzZVsa31Sgvw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq/c/wX1nvR1gv9B/rOkt3izg0E8fkXINMM5O8F
 2+9y+ysrTeJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCav3P8AAKCRD6UCkIqsW9
 0GOED/9Vh/5INvgk9P8DwMR2aeS3JnDyMMF9WA2Bjl84hKZIl7oOBVjfTgOoskAxASTMJCthWjk
 Op2BleD2sKiUr/PpAV2x4cwQJVRYFJkhFPfXJrKXUCkV6MwDkFlXJTRxd1rklOfNaFvkUjKlvcr
 BAZPI2fUuxQNidBN/lbX2BhoyXcS2KuBi8WslDeJ8ngOR3X9WDl70uQ8oRRQsSKxBhHIFGhtWW9
 6zX9SGimznWfr+bcJlLmw0ZSaxjqSixBucu5YewsJbMUVb7tvIemuKLMZTa1Zzyh2TEWRo9BbFB
 kt8ncx6AUinI8kEDkGVxNGxoZ0QWLoJ3s7tYfFXKcTudftgTKMiN6YfPcJdDG4BXtXnqk09Gt0D
 oEqe20F73wFLY1Oc6REy0aoZqJefNBkAJuMuPuzyZxS7aTMjYjuPe3QGWn6QhXNQ5hGhSDHfAqb
 0x7+nHWyNB6E2fR9w97K9raJmPHk1zfsTAFhoN4QCP2tALLJ4ABJFrj2utsPjjyr2JI9LO4w1Ve
 85ejPhZJ9EYWK3l2/Nd94WOP+kBuMiiwvbx3Zi9+HGE+WWF6A6p7wWe5p9CQ6rvdcknmpwY0sy3
 tyZ95LoKOkGcooGZOzOaxROhYBM04IKH9LDWRiDQWUK390O+5y85e4+VUpziCGCI3qwE2uFfwe9
 LiDjaD5a0RPiWkg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AB832A0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c9zu6n4yzb8nfk5n3siecg45h1376eh5
X-Rspam-User: 
X-HE-Tag: 1795018784-981347
X-HE-Meta: U2FsdGVkX195IVUtKZXIXq7/4Ogx2mNLKBnyMOHX/czKaeJk5Y2x5n5kZx9NrNzi56riChFOiaNEiDk/yihMplZ5i2Fbd9SFNbQHe9TxHaV9YE3QCOP7MuaviicljiHSg1EoDYxFIaw7HTAnIeSUUIkps6Aps2lKX8lt3QMjB42/1/uIgKjm3VAPuRwkb4WCtUgfjfl+laTTzBWCue7C08s94wqQhH4LvZa0T6GuljpUBhB+c6UzcqQyc+PC4iYLQb5MpzjsmAt+NCPka455bQzEZOnhstElGnx8QJFvL2q+8EyuBvLWTz9JVsVPqhSVyDAesZvul6VjNbL/f7UBh6uUNte6oG3BXhqc13dNGNc4wvrxrxTcJPuua9nv85W3fzDzHc2mDrt+qZD9M+7etfVAW7K31Cg+doilfN71BQhTQywT7PU03OvA/IG8y3v8ew3hPwLsidmWCb+WWqRZL8zqcHo3ahNNi1PM/i6Z5oFs830AFk8bYUcmHSPhjJDkNX+S0cnBRx8vuTwT4T60X+F9UEd4qk9Otlb+9syTDe7UU2lFBGUrZ+Yb4RgKYW0eq97xNX34vm8fBjwBPniamBRlHbZDXqgWkkRxYKYUplmSNiMFHgJ1nqsgTlSwo6iQbh1OJ8wAMeOF3TUjYrcPedxo4rAdFuiHB0LC+7oFKgVvB2e7iw4qJNe0aY35gp1DmM20f0C7TJBKdro6V5Ay8+THWuGlPfH3YwU6sgIY+plVwpKUv9zYnWMKO0wHaOQdqRRwlJcOOV0FdZhV9uelfUpc4pHxneHn+81qXZaiCHx1hUM+KW78UpcEPqDnHewwH8EXjl0xhvpzzARMBRz4ynaxlNMir96Xn0LgHDMGRmFdpNJTpNj9qIzSszkofOXcTOav3Doqpn35YoQHslT6+T0Z4hIhjHB3DPlWhK5dXcrsMKbZnK0Q4/q/73T5LCFhIvd3sE4C5ibuF51wuls
 mhskRdfi
 k7KhqVbd9alrrxD4n3gEcWP2VOpSNrVx5Hb7GDKcR1TViKo0sPJYevBhZfS7tlKFkoaxfP68xVpyVAgz7zASXq+K6f1OdCcX+tzJ5KXv/Y5rKKIkkzic3tEahaZBjb/tvQhM1XHeapy6tWvDrJpggz/AgQexVWy2taGXZUXvU+zNXbfLH57cXkL2jN0DSc8qJXbN2Daw/fblplzgJTH5Fd/C0Vh2fGaH5W3af8VZXQGYL7oBYWGVGk1fFWy7C1oRayDxyPWgzb3OimmeK84C/fvqptIsuacGXHBTyPocOlxhXv++JONhaG4NTp9HUKRZexOsUpGPaoxRr82X0bhr9uioqm1KWWh1kfzcIWoj1g3m0LHCs9Rc+ZXT5rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

alloc_frozen_pages() and free_frozen_pages() are declared in the private
header mm/page_alloc.h, and free_frozen_pages() is not exported. Thus,
frozen pages cannot be allocated outside of mm, and not from modules.

The Rust page abstractions need frozen pages. The reference count of a
frozen page is zero and references to it cannot be taken, so the caller
that allocates a frozen page is guaranteed by mm to be its only owner.
The Rust abstractions rely on this to hand out the data of a page as a
Rust reference.

Move the declarations of alloc_frozen_pages(),
alloc_frozen_pages_noprof() and free_frozen_pages() to
include/linux/gfp.h, and export alloc_frozen_pages_noprof() and
free_frozen_pages() with EXPORT_SYMBOL_GPL().

For !CONFIG_NUMA, alloc_frozen_pages_noprof() is a static inline function
that passes ALLOC_DEFAULT to __alloc_frozen_pages_noprof(). ALLOC_DEFAULT
is private to mm, so the function cannot move to the public header as it
is. Move it out of line to mm/page_alloc.c instead. This adds a function
call to the existing callers in mm/slub.c on !CONFIG_NUMA kernels.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/gfp.h |  9 +++++++++
 mm/mempolicy.c      |  1 +
 mm/page_alloc.c     | 10 ++++++++++
 mm/page_alloc.h     | 14 --------------
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 63a7654c725f..7e1f24658f9e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -302,6 +302,15 @@ static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 
+/*
+ * Allocate frozen pages. The reference count of a frozen page is zero, and
+ * references to it cannot be taken. The caller owns the pages and frees them
+ * with free_frozen_pages().
+ */
+struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order);
+#define alloc_frozen_pages(...)			alloc_hooks(alloc_frozen_pages_noprof(__VA_ARGS__))
+void free_frozen_pages(struct page *page, unsigned int order);
+
 static inline struct page *alloc_page_vma_noprof(gfp_t gfp,
 		struct vm_area_struct *vma, unsigned long addr)
 {
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0cb6da1c47a4..6d872db9fc6a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2582,6 +2582,7 @@ struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
 				       numa_node_id());
 }
+EXPORT_SYMBOL_GPL(alloc_frozen_pages_noprof);
 
 /**
  * alloc_pages - Allocate pages.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eb4f02617f53..d6284cf965cf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2993,6 +2993,7 @@ void free_frozen_pages(struct page *page, unsigned int order)
 {
 	__free_frozen_pages(page, order, FPI_NONE);
 }
+EXPORT_SYMBOL_GPL(free_frozen_pages);
 
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
@@ -5491,6 +5492,15 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 }
 EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
 
+#ifndef CONFIG_NUMA
+struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
+{
+	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL,
+					   ALLOC_DEFAULT);
+}
+EXPORT_SYMBOL_GPL(alloc_frozen_pages_noprof);
+#endif
+
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
 {
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 7097ea1805f6..541fa8b3f532 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -237,22 +237,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
 		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
-void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
-#ifdef CONFIG_NUMA
-struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
-#else
-static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
-{
-	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL,
-					   ALLOC_DEFAULT);
-}
-#endif
-
-#define alloc_frozen_pages(...) \
-	alloc_hooks(alloc_frozen_pages_noprof(__VA_ARGS__))
-
 struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order);
 #define alloc_frozen_pages_nolock(...) \
 	alloc_hooks(alloc_frozen_pages_nolock_noprof(__VA_ARGS__))

-- 
2.54.0



