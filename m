Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D5F60A380D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MOGUErbv
Received: by kanga.kvack.org (Postfix)
	id 370D76B05B5; Tue, 10 Nov 2026 15:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348686B05BA; Tue, 10 Nov 2026 15:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2378A6B05BC; Tue, 10 Nov 2026 15:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 018E96B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:39:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7710EC0651
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:39:06 +0000 (UTC)
X-FDA: 85420373892.12.DB8F365
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A9D20180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:39:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MOGUErbv;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGQPfOg6ypaB3MwmOwwiljkRXcAJPxgwK/FqKLjVxlQ=;
	b=MAFfK5DUUTLjz+y/KRzZJojrcTdt47Yxo16zhhkXGcJOLiQql1KsXgUpA6MgCHt1Y7ok9W
	NLYukp3iivW88kqWWh0CovK5651Fct4j2IYbTv25TVKh3lF1EwqNljrEVxmjCoH9jZt3tX
	Wpby0+fna0GAY+ers14t/we9gd7c92E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343144;
	b=nz+gAVS1oapsoBHWPArkT7mYjZ/7F7oDGq9oAmhubjR5/xkfUZwNWAkHF1NzPawSkGzmQQ
	cJiFC1CY/lTTvNhN0MFCZktZaUJNSebrJC39oUCmWIhAIyReS9fVeCY7uEu8yaP9zchgnx
	mGpbHIXC47XeYhUDYqv6P26nSW57J7w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MOGUErbv;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E61AE4135C;
	Tue, 10 Nov 2026 20:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B9D1F0089F;
	Tue, 10 Nov 2026 20:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343143;
	bh=oGQPfOg6ypaB3MwmOwwiljkRXcAJPxgwK/FqKLjVxlQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MOGUErbvI0NvPlBiP+xxxwfFj1wVMhgr7y5RxYFEXlyXRLoxvIaIKVHnkiUdo9RvK
	 WzwmDenCUmqGgqM7XHmXxRoFjMXIuObHesj9LHJI30honJ+APfTMx9mXKt9hjvRfWc
	 wJ4Za7u1jgx07/Wl48rTasHVieQlc01YlGyCYUl+nvfPEijD16kvSpCx9Vse5CK0xp
	 cADxT6tpzyDgJ3sA3+wvz06Sm96tHhOhehudH7CPhHJ5kyQXb06ggzEpMAzCeYqViI
	 e31TkInsQIDQjuNExVGsUDwSnI322VWg+tdHiU1nsrwNaRHBndgceyCoeDSHdnpvxG
	 aHHxSSUgpweGg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 10 Nov 2026 21:35:48 +0100
Subject: [PATCH v3 8/9] RFC: net: limit folio refcount when splicing pages
 into skbs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refcount_overflow_stable-v3-8-318625d63a98@kernel.org>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
In-Reply-To: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2393; i=david@kernel.org;
 h=from:subject:message-id; bh=ZTvUAfCXgF6VHkCx5yhusApI2I6MRRFPDQZm7ACvtSg=;
 b=owGbwMvMwCF2QOXvyb15Z08znlZLYsj63BARr2C5gT/TOFGtNsFcr8dkU0J8T/CVv7b3BARqy
 0K3M/7uKGVhEONgkBVTZLm2Lic1eE2rY1mUoRvMHFYmkCEMXJwCMJGjSgz/C2sz11hNsZiv+jX6
 puFJ90nRQTn1qR+czHUk/cs4Qn6wMjLcsW3Z+EH4X/zKc6xr01da3/bvq5e6efGt/DS2V9eYK55
 xAwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: drayzjzxnxkmx115azb6ragk1ttfzdju
X-Rspamd-Queue-Id: A9D20180002
X-Rspam-User: 
X-HE-Tag: 1794343144-207483
X-HE-Meta: U2FsdGVkX1/tXNeO2bT1RZ3OYlsz+YhPiXQA5IuTdoX/qAZwnPSmv7TCureGToGERxkpgTh/U6u4DT9uVI+ZRT5dEhbm3AmpLWJFF9nTDcTOYZP145N8JxUXthEQ9AscX0TpsOB1QNhCN3k4hrMNh0ueonZ0ERBrDd2AqSTbIBePS54H+9/2M1L3OeGoCGvd8PluKJniKm2ZZIwdxrt9yBNl3zl13PUU0JCum3aeoZhP6+1eO0ptjlcRFimiT1GQd5bFThMi1R7ersC1FqJyGZj5SHBeESfcTA8RYHbqw7i3lstVeseeeU6XvFS+Sc3aUo9zYZg2jq66mhcQoxTonpdTD0FPNL1XjaJuvDmHlzmUBgyZ3nI8orFuIl1j+6zIkAy5U/JWtqgxyJ+hPQOE349XedgPiFIvqrEQ6ZLuC2cOP0kegBlHDJQ6YKtA4LfHwaqZL64RnKNKENqOBOEO5EwuA6OwazU5qkjJV62RAbb/AOBxkXKJk8BNQ6Gw2TB2cVG8wP5qkz+dTG+HKJ9ViRQytvGxDqULYsRc+jGfRnvLlwOMyxCTiJeqx6dH0chbjOaxGUPzv+SeeN6FK2FS7nA9ynxUfFLPV0T2wvRQvhHpJa28JQ8NHsWNO6zENOH4oS+RoZXel+PgbOWWrhyZr7IK2QroEKMEJkMkNcLsiDKFeG82MX55XEMoF48Mue/VuYDP/F0HGf12Nb6s9gYnN/NNsPMAoOczO11GFKSKEwoi+8s3CnfRm2QfqdJXy/15qOk6oh1RrZum/7GezcLvcuIZfbWSeidNQc4jKcGyN6WBseEq0rvSgq1b1p0QjS23rUpVnHe6bbX7t09UTDoexcw/G3SQVviwTainvAs9lho4gPtXZY4sWdoPu17v3uJGInKh9REKH98R8H4QKIBUSJt5qw/YJ5YERlhsPRO0BWJvmtpV85RuUI6Gdbqm/Hwv3rJJOGD930z8NELiKAj
 WvkLi2UF
 OHkwVDG/I2+oDXYENbVb1R5kSrDxLonm7wNNpYjLWZv5OoIMr9odS25E+pefjZOu0nSbMRmmqC/fssZpVa48qX2v6ACBlUQ3kCbRobsQE1JuCux7XkqIW7m66OitluMh6J7OSU7CNJuGFfj5hWDdZ9PyhGPWV04SBRU3xS7nTehLXHZKYJy/C15e43x7cMBaf7kB1exPUQSBm1P4YX1lplPfoMQmHzC3QS+VSLxw51CsVBy8N3Ntk6nB0sL/4KUFpRR+/JPBQbHbjaCZdndZ76imhNg1Mr/ze57X7eTZbpnk5BYMtwN2WEzDF8rleqyNZPvbU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various networking features use MSG_SPLICE_PAGES to add pages to skbs,
whereby skb_append_pagefrags() takes a page reference for each fragment it
adds. Pages spliced from pipes were already checked when entering the
pipe, but in-kernel users like sunrpc pass pagecache pages directly. This
allows for exceeding folio refcount limits.

This is not specific to large pagecache folios, but with them it is a
lot easier to reach the refcount limit, as page table mappings can cheaply
create many references.

Let's use try_get_page() in skb_append_pagefrags() and fail with -EFAULT.
Don't use -EMSGSIZE, as TCP would just retry with a new skb. The only
caller, skb_splice_from_iter(), handles that.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 net/core/skbuff.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f473c74956b8b..5e3f910eeea0b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4702,8 +4702,13 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	if (skb_can_coalesce(skb, i, page, offset)) {
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < max_frags) {
+		/*
+		 * Don't use -EMSGSIZE, as callers would just retry with a new
+		 * skb.
+		 */
+		if (!try_get_page(page))
+			return -EFAULT;
 		skb_zcopy_downgrade_managed(skb);
-		get_page(page);
 		skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	} else {
 		return -EMSGSIZE;
@@ -7575,8 +7580,9 @@ static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
  * possible, copying them to fragments if not possible (such as if they're slab
  * pages).
  *
- * Returns the amount of data spliced/copied or -EMSGSIZE if there's
- * insufficient space in the buffer to transfer anything.
+ * Returns the amount of data spliced/copied, -EMSGSIZE if there's
+ * insufficient space in the buffer to transfer anything, or -EFAULT if we
+ * could not take a page reference.
  */
 ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			     ssize_t maxsize)

-- 
2.56.0


