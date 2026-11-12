Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5DC606A8BC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lpa/UJ09
Received: by kanga.kvack.org (Postfix)
	id 90E5F6B061D; Thu, 12 Nov 2026 17:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE5B6B061E; Thu, 12 Nov 2026 17:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5766B061F; Thu, 12 Nov 2026 17:56:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC946B061D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:56:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AF7214207B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:56:16 +0000 (UTC)
X-FDA: 85427977152.29.886A4A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C3E7B1A000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:56:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lpa/UJ09";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KXZct2Nh4QdUFm8d2XuDz0d/faDhoWyH6HWizHXA2E=;
	b=JYWhlbOj05BAQuWImIzyw1NY0aWBabmfadH98Gyo6ktmPsJD1PK3clzgF3CqM+iRZ57ab3
	4VcesfmdkLuIYMTLeKtEbCO+6NScagUJGgb+B2BwY1J9nxhriiPNsZPYtD+inuAbgSmfSb
	AQqKvQFyLkpYvhYkiJvMxpfY+eu4RZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794524174;
	b=gxrzc8yz04WeabljQvAq5VXe1jQLLnUFKaDS1J1owFNqqyXIVgnEWtSCQlbQiM+xZqFwZd
	LCub1nSJnkobyz8j2pLabHAJMYaQfotF8HqbJlpZoJ+mmhwlAhs+FXmXN6mtSlb9vwgbH5
	msEF802Thh9pGMdZsHH/2Y3etIxsWk0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lpa/UJ09";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A2B4624BC;
	Thu, 12 Nov 2026 22:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17F61F000C9;
	Thu, 12 Nov 2026 22:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524173;
	bh=7KXZct2Nh4QdUFm8d2XuDz0d/faDhoWyH6HWizHXA2E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lpa/UJ09XlXh3NXrGdzLl3Y0yzxu/o2Bzw5r3haCfnWuH7X8CHkF8yj3NsQz0KkSj
	 vONam95AbPdOBj9C6SkI6dRw7H9KgGH6g6wEXqWeftz8Nk2pZJmw1Jk12PbpEiImdc
	 2B6PIpgLL3gF5jGr/Gxw8yPAyb+TIkLNV5lE3JggBkwitvGWL2MMQQR+flkvvzRiRU
	 rMu2dX7Wq6wtwpn2mK6E9ZBK0ZUH4JI2fHrxZhPneJVYInZniV34L+vIM3a41tZcsa
	 P+jT5nwYN8FQ41gjR9R1A427bI9HACxtMDz4ugRU9nN4n5Yd+pem/niRiHkliLrF65
	 /7WwZU/xEuh6g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:53:28 +0100
Subject: [PATCH v4 9/9] net: limit folio refcount when splicing from
 sockets
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-refcount_overflow_stable-v4-9-ad3deef0bd23@kernel.org>
References: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
In-Reply-To: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
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
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7665; i=david@kernel.org;
 h=from:subject:message-id; bh=YprwJxPujKbTqAJR7+MEgkU1slwl4fvrcUXKr6083QM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+OWdZhIuraRTZhSu/umUgt+rJTueTAgtSJm4s/rjwj
 O+luT6mHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEyEJZ3hn/lfbe1bRUyliy9c
 uL1I+nC+bFJz4fp76hO89m+oK5yxbCMjw8oYEdvXjHOUMgT4Y5sW1N467Bi75R2f1eEXcVeX3Gr
 35QEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam06
X-Stat-Signature: 8xytg47kcseb6d9xmctjys4dd1u3jcam
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C3E7B1A000A
X-Rspam-User: 
X-HE-Tag: 1794524174-450848
X-HE-Meta: U2FsdGVkX1+0FnWEN+FbsstNIKPAeTBO2PHHqucpgfQymz7IiIkVVnq1gCRZW6QANSW/yoJcom7eqrefEk+kbXqzfbgltKJpXHm2LwfczN2VZuLHDuH/kuNxbvwGc22EXIYXo4c5TYXTdPMnAuPDnvj0cKXb7Abge1rA/cWA2KQxwC9VS6E7ViTkQkzcIyuLzbh2mnr8thdh0nDxKo7fbOZK2hfGD95TNw/U9GkItYRffVzUv61PMWqTFGfD0+SUAw7blWWpeeY5yrdOPjAXVGruGG4+jz1j0lSWq1YNvOskd0BGFgl4Ji41UKgwGplh1E8ET4+mZDCZ4V/LTNYrgqntSIO6Rld1yzY8h3vEhHcc0URpKnw2rbGYECCa4WvQ5fOBkjMdGj18J104SLWS+vtNuogRHNu3jZPFMoq0wB4ZIpTjxWx2N/KHd4NbXcr00xkV7Y7XEACzp9C4Zz/6VT2pqX46vVD6rXER0pz55j82Ftw46GYFtP3wrHQ9sjxJ1H92Ig5JKJT6gFgVUxmj2IJyHVIoILQcJQ/CPosAuwNdgV4FpXlH/M5tYftdGbP5RBqd57owOHTdZ/mEiUYVqCrgxM76s81jbwtI4zPG7yoSvGUcZ06S6V7TQzHH94e/qkNg3H0al+fMrxk9evPxFAZt+4f1H7V4ytn5jHQ/2+vIcOX+IzlmKhIQnA7+v+HbCpACf6c/c0cDFHXpz01mK1nqK/qI8O+Oo35KS2AQEd5Ow1NGY08TeeO6Ip39muA/9HmKcAWZzkzP2+D7B1DKZqGqi7wYWo8ODhOV32tlfAwCZleLv/0aSFicp/fWcKRI+ohUJKaJBOL9bQ7PLQDPTkI6fKpHO23fwNdk78oz70YHuaHcHW+9zk6Phm+VXMeXneIa4wVxzj6jk37lNP8vK0xckXgRd6ZNQTAmofZQ8OPhjFJ3R3Oig+K7ZKtJP7mu4RpeZAsnZzXy+GMoVqP
 cfIFqySm
 OKDgM9DiBZoiDNRe0e+nqrJS6uDnSXQBCu2tF4CD5sMag6eToZMFy9eKqWcWePDwjgujd+qHDops9xshKPnDYaW65U9/eI5VfU955rO0Ex5ZoihKzXu9JfGQbgFL/rYB3WkGl1j/OVScmuIdz886Ta4iiXkuUxWqDqICXa81UbVpXKiCIOxSRWW+Kjyyp7/H9O4g5D9rmE+OXmvNM0hTCez38+am2C3cMcMOOMrPRoJosjFkDtDTbxyS2z6WCIqBL4D5E4GUpfkXj2xI+jIsAIWoDzp7xRYPkdoNTRRBAljf8GbwjUSnEuwl5O+l+Rb/3gONc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various networking features support splicing data from sockets into
pipes (TCP, AF_UNIX, KCM, kTLS), whereby spd_fill_page() takes an
additional page reference for each fragment, while the skb keeps its own
reference until it was fully consumed. This allows for exceeding folio
refcount limits.

This is not specific to large pagecache folios, but with them it is a
lot easier to reach the refcount limit, as page table mappings can cheaply
create many references.

Let's use try_get_page() in spd_fill_page() and stop splicing with
-EFAULT if that fails. To propagate the error, let spd_fill_page(),
__splice_segment() and __skb_splice_bits() return an int instead of a
bool. Keep returning true/false instead of 1/0 to reduce the churn in
this fix.

If we could not splice anything, return the error from skb_splice_bits():
returning 0 would make the callers (TCP, AF_UNIX, KCM, kTLS) report EOF,
although data is still queued. The callers already handle errors.

Use -EFAULT, consistent with splice_folio_into_pipe().

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 net/core/skbuff.c | 90 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 51 insertions(+), 39 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5e3f910eeea0b..a5965f8fa1b00 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3150,11 +3150,13 @@ static bool spd_can_coalesce(const struct splice_pipe_desc *spd,
 }
 
 /*
- * Fill page/offset/length into spd, if it can hold more pages.
+ * Fill page/offset/length into spd, if it can hold more pages and we can
+ * take a page reference. Returns non-zero to stop, or a negative error
+ * if we cannot take a page reference.
  */
-static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
-			  unsigned int *len, unsigned int offset, bool linear,
-			  struct sock *sk)
+static int spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
+			 unsigned int *len, unsigned int offset, bool linear,
+			 struct sock *sk)
 {
 	if (unlikely(spd->nr_pages == MAX_SKB_FRAGS))
 		return true;
@@ -3168,7 +3170,8 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 		spd->partial[spd->nr_pages - 1].len += *len;
 		return false;
 	}
-	get_page(page);
+	if (!try_get_page(page))
+		return -EFAULT;
 	spd->pages[spd->nr_pages] = page;
 	spd->partial[spd->nr_pages].len = *len;
 	spd->partial[spd->nr_pages].offset = offset;
@@ -3177,12 +3180,14 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 	return false;
 }
 
-static bool __splice_segment(struct page *page, unsigned int poff,
-			     unsigned int plen, unsigned int *off,
-			     unsigned int *len,
-			     struct splice_pipe_desc *spd, bool linear,
-			     struct sock *sk)
+static int __splice_segment(struct page *page, unsigned int poff,
+			    unsigned int plen, unsigned int *off,
+			    unsigned int *len,
+			    struct splice_pipe_desc *spd, bool linear,
+			    struct sock *sk)
 {
+	int ret;
+
 	if (!*len)
 		return true;
 
@@ -3200,8 +3205,9 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 	do {
 		unsigned int flen = min(*len, plen);
 
-		if (spd_fill_page(spd, page, &flen, poff, linear, sk))
-			return true;
+		ret = spd_fill_page(spd, page, &flen, poff, linear, sk);
+		if (ret)
+			return ret;
 		poff += flen;
 		plen -= flen;
 		*len -= flen;
@@ -3213,28 +3219,30 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 }
 
 /*
- * Map linear and fragment data from the skb to spd. It reports true if the
- * pipe is full or if we already spliced the requested length.
+ * Map linear and fragment data from the skb to spd. It returns non-zero to
+ * stop: true if the pipe is full or if we already spliced the requested
+ * length, or a negative error if we cannot take a page reference.
  */
-static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
-			      unsigned int *offset, unsigned int *len,
-			      struct splice_pipe_desc *spd, struct sock *sk)
+static int __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
+			     unsigned int *offset, unsigned int *len,
+			     struct splice_pipe_desc *spd, struct sock *sk)
 {
 	struct sk_buff *iter;
-	int seg;
+	int seg, ret;
 
 	/* map the linear part :
 	 * If skb->head_frag is set, this 'linear' part is backed by a
 	 * fragment, and if the head is not shared with any clones then
 	 * we can avoid a copy since we own the head portion of this page.
 	 */
-	if (__splice_segment(virt_to_page(skb->data),
-			     (unsigned long) skb->data & (PAGE_SIZE - 1),
-			     skb_headlen(skb),
-			     offset, len, spd,
-			     skb_head_is_locked(skb),
-			     sk))
-		return true;
+	ret = __splice_segment(virt_to_page(skb->data),
+			       (unsigned long)skb->data & (PAGE_SIZE - 1),
+			       skb_headlen(skb),
+			       offset, len, spd,
+			       skb_head_is_locked(skb),
+			       sk);
+	if (ret)
+		return ret;
 
 	/*
 	 * then map the fragments
@@ -3248,10 +3256,11 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 		if (WARN_ON_ONCE(!skb_frag_page(f)))
 			return false;
 
-		if (__splice_segment(skb_frag_page(f),
-				     skb_frag_off(f), skb_frag_size(f),
-				     offset, len, spd, false, sk))
-			return true;
+		ret = __splice_segment(skb_frag_page(f),
+				       skb_frag_off(f), skb_frag_size(f),
+				       offset, len, spd, false, sk);
+		if (ret)
+			return ret;
 	}
 
 	skb_walk_frags(skb, iter) {
@@ -3260,11 +3269,12 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 			continue;
 		}
 		/* __skb_splice_bits() only fails if the output has no room
-		 * left, so no point in going over the frag_list for the error
-		 * case.
+		 * left or on error, so no point in going over the frag_list
+		 * for the error case.
 		 */
-		if (__skb_splice_bits(iter, pipe, offset, len, spd, sk))
-			return true;
+		ret = __skb_splice_bits(iter, pipe, offset, len, spd, sk);
+		if (ret)
+			return ret;
 	}
 
 	return false;
@@ -3272,7 +3282,9 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 
 /*
  * Map data from the skb to a pipe. Should handle both the linear part,
- * the fragments, and the frag list.
+ * the fragments, and the frag list. Returns the number of bytes spliced,
+ * or an error if we could not splice anything because we could not take
+ * a page reference.
  */
 int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		    struct pipe_inode_info *pipe, unsigned int tlen,
@@ -3287,14 +3299,14 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		.ops = &nosteal_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
-	int ret = 0;
+	int ret;
 
-	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
+	ret = __skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
 
 	if (spd.nr_pages)
-		ret = splice_to_pipe(pipe, &spd);
-
-	return ret;
+		return splice_to_pipe(pipe, &spd);
+	/* Returning 0 would make callers report EOF. */
+	return ret < 0 ? ret : 0;
 }
 EXPORT_SYMBOL_GPL(skb_splice_bits);
 

-- 
2.56.0


