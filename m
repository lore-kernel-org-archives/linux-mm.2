Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92FA606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z/uFEpdE
Received: by kanga.kvack.org (Postfix)
	id CDD586B0616; Thu, 12 Nov 2026 17:55:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5516B0618; Thu, 12 Nov 2026 17:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBB96B0619; Thu, 12 Nov 2026 17:55:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 802906B0616
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:55:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16F2F161F7E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:55:43 +0000 (UTC)
X-FDA: 85427975766.17.EFD5C99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 36E1E20002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:55:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z/uFEpdE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdFVWlgHbk5l/x1Pw82lSEvoK/V78BgFQoecwKNgz0w=;
	b=50poHRdR7f6RX3Q+NameVOEC5a+O5JotyonxJ3oSY6rW5zM7Zl+OGiAs/tCpqod47Ftjgn
	5o7jbuJoKDps+axMAJAm+AeDWazGdMnJn0W36EtwzJ7uLCmfJtw25FbjI4kwYhIzje3OTn
	UWncz3HL1mxLy5T1/A5mhVtAnxorrKg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z/uFEpdE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794524141;
	b=Kw0vk+Wn1YcwfxkcCFO7wOi7RJ4Sn2tGkkMZK7SA76c8v+5EKgJI1XBDRcO2t5YT6oMMKe
	rBdMXLDE8ang/iT0BDrJKt5xLNqZZQE9oP9DkIsrRxDGnkJNkxcivpiIfNfIlW1QhyHYyd
	WMF2pDkve+Voa06pvSEUJcXbCdBnmz4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 878BC4042E;
	Thu, 12 Nov 2026 22:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC82A1F000C4;
	Thu, 12 Nov 2026 22:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524140;
	bh=UdFVWlgHbk5l/x1Pw82lSEvoK/V78BgFQoecwKNgz0w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z/uFEpdEO0rIVY3WTFMr/D+S9rwYzMUI1B5YuFxAAs38CsATT3uSy0oyQMUEbc/GJ
	 xmmj6U25hlmcvA/jT0m/BE4ZiZk1xAnD2dKnTxeSADrLschmBQCHvnow7VneK7EAbo
	 jwBojbsiTvgnhiFrEikRzZfof4gpyoMbGJAd5iRTfzVLRISzJ7coGIrYmzAp9ojFmg
	 KBzkUzEGZX6SdGV44zqVDAz/SHXsG81Ag66CiB95bYhQZUeHcwogT4r4YLwdiDMzAH
	 mTr7FAksqNjM5atHqfA2nCIzLpGPqVxS2zBenxCGIqQ4fiLzuJXxSXv03ucmlUU0eK
	 DVUvJuekiS7FQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:53:26 +0100
Subject: [PATCH v4 7/9] net: limit folio refcount when rearranging skb
 frags
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-refcount_overflow_stable-v4-7-ad3deef0bd23@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5075; i=david@kernel.org;
 h=from:subject:message-id; bh=iaB52FMlmu0+VYWn1iELLkUK/yhgYJQLwhZnKBCgXsU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+OWdlq0wQUJk/h3On/UXvC58+Vh7ds+DYReu2u7bn2
 RtaVqzI6yhlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAily8yMixob90cMP+vEMOt
 92fMnfpsjhWfffU39zqribyE6df/J8IZGWaylqoGVjpY7So6uf2e23pVgf1B676dm7m5ZfvhfQ9
 4algB
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 36E1E20002
X-Stat-Signature: buhto9qxfrf3ipwhf9tdg34azyjrnr5r
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794524141-471425
X-HE-Meta: U2FsdGVkX1/qkJh9RKFk2LL5S3RKULbrn6uv9Fl/HSrNd2/H4yWjCeW9M1HnwuinRyqBwy5+bZUFVUgvp4HsEmoC+HTdV4too50qq0FFwDzjfC2YZOl1uebKJTRthsgolrg656fc4t9spJqefu3rCzIdfWsScNm7/jQoHvMXa32xqTW+ebTLabJZa24pZhvs8+boPz1IQMCc8x4rJA/1qC7mWyYQnx98MUsOpYX4QKVjGmvdtW/aAFixD3dCzQpezGyIDezdSgu6kxtjndurkqd86+P3FEr+HJaxzX1/8R8RqhSlbDdru4bNZ76KrO5xygiCUVqJayoFjfA7I4DgoY6+/WjjHXeyqvVKaRxJvacD5XtgtZdz8CtRtzJGa8rUmJdCKi8nV8EiKEJvh/mKMB7PR9huSKYVwlKxmxGlroChgOy2VFPukGd2ZMmhe0FXIItAFdE+ODTBGqs4ztAeFhm8SfapI8+HDDDS8xkH5ovh1O9Hw10azUXDZWkxqco1k+4JSd9Hx6t0Mq1WjFLh04CbGaC5H1498AXbH35VxxO2EvAj6uJlVcPGLCffBxJ8ZH0fXpirN8GO5iqlWNPm9KFmp0MlTOtnLGb/0iZUrw1eicL84qpoNdoaAOdO3P1tENEvJ/wA1rLlTROMQSGydnbikxgW5387UN1zqA87OaxU8963/gq90Q3uHrA06howH9Q1SV/V/z+r7lSReZc36VuQ85Ngojf0TmgF+5fX2lIUFh2EPqPkRtV5EdSi73L8SeR5GSS5ax+jofGRQ4sGPXGRGPmEAUJUk/dOM183KH6lmd3J1rMjo17nsvOtAzSrrD1jnJ5ftSoCxWS59L/DCv68rowHyXohNF3CDa/ulWn6jKDxzwXGSk6QV1IwZONzI+x4YTYNlrrjTgIzmA1Eq/494KcJvzVqXmogG5IqTPKjGRgB3Soa+N3JFJF9mitQKtXlRugENNGPDBvA86u
 nBUhp+c+
 J3Rwm51el7MJqUQAptQ7pFEJ0cY6Jub0qIVk7hHY4int+eN3KogUHz5jlWgVHMBlGczYkTrIl4xNgqW9O+20lp+cfYcJd4JO3RXv56m7foCZZquyv55oJXszLT5dllruNSlvDxfDOvHamPO3X/eiVoVsCUE09hLe9gaWQlayb0p2L1dO15Ezjk+hM46+GFDNTWouM7i1SZUmG9iaJvWSSDu65ECMQe7ZUI7jZ/VSv2G04tPe04KkDt17pHgTaTpV6fiyBokJI5QfL+7Btbc2GhvwCfYL2uqmcs7FS8I+BHcWJh5i0m4QNrMMBC0bWkWedBgY+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various networking features take additional references to frag pages
that are still referenced elsewhere when rearranging skb frags, for
example software GSO segmentation, TCP receive coalescing of clones, SACK
shifting and MTU probing. This is an effective way for multiplying folio
references held by an skb, allowing for exceeding folio refcount limits.

This is not specific to large pagecache folios, but with them it is a
lot easier to reach the refcount limit, as page table mappings can cheaply
create many references.

Let's use skb_frag_try_ref() and skb_frags_try_ref() in skb_segment(),
skb_try_coalesce(), skb_shift() and tcp_clone_payload(). All of these can
already fail, and their callers handle that.

skb_split() can still add one reference when splitting a frag. But each
split also allocates a new skb that is charged to the socket, reaching
the refcount limit that way would require a lot of socket memory, and the
references go away once the data was acked, so it's not that relevant in
practice. Making skb_split() fail is more involved, so let's leave it alone
for now.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 net/core/skbuff.c     | 32 +++++++++++++++++++++-----------
 net/ipv4/tcp_output.c |  8 +++++---
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d44e9a4152e5..f473c74956b8b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4326,7 +4326,8 @@ static int skb_prepare_for_shift(struct sk_buff *skb)
  * the length of the skb, from skb to tgt. Returns number bytes shifted.
  * It's up to caller to free skb if everything was shifted.
  *
- * If @tgt runs out of frags, the whole operation is aborted.
+ * If @tgt runs out of frags, or we cannot take an additional frag reference,
+ * the whole operation is aborted.
  *
  * Skb cannot include anything else but paged data while tgt is allowed
  * to have non-paged data as well.
@@ -4409,7 +4410,9 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 		} else {
 			skb_frag_page_copy(fragto, fragfrom);
-			skb_frag_ref(tgt, to);
+			/* Nothing has been committed yet. */
+			if (!skb_frag_try_ref(tgt, to))
+				return 0;
 			skb_frag_off_copy(fragto, fragfrom);
 			skb_frag_size_set(fragto, todo);
 
@@ -5148,7 +5151,10 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			if (!skb_shinfo(nskb)->nr_frags)
 				nskb->pp_recycle = frag_skb->pp_recycle;
 			*nskb_frag = (i < 0) ? skb_head_frag_to_page_desc(frag_skb) : *frag;
-			skb_frag_ref(nskb, skb_shinfo(nskb)->nr_frags);
+			if (!skb_frag_try_ref(nskb, skb_shinfo(nskb)->nr_frags)) {
+				err = -ENOMEM;
+				goto err;
+			}
 			size = skb_frag_size(nskb_frag);
 
 			if (pos < offset) {
@@ -6289,7 +6295,8 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 		      bool *fragstolen, int *delta_truesize)
 {
 	struct skb_shared_info *to_shinfo, *from_shinfo;
-	int i, delta, len = from->len;
+	int delta, len = from->len;
+	bool cloned;
 
 	*fragstolen = false;
 
@@ -6362,6 +6369,15 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 
 	WARN_ON_ONCE(delta < len);
 
+	/*
+	 * A clone keeps referencing its frags, so we need our own references.
+	 * Nothing was added to @to yet: we only steal the head of @from above
+	 * if it is not locked, and the head of a clone is always locked.
+	 */
+	cloned = skb_cloned(from);
+	if (cloned && !skb_frags_try_ref(from))
+		return false;
+
 	memcpy(to_shinfo->frags + to_shinfo->nr_frags,
 	       from_shinfo->frags,
 	       from_shinfo->nr_frags * sizeof(skb_frag_t));
@@ -6369,15 +6385,9 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (from_shinfo->nr_frags)
 		to_shinfo->flags |= from_shinfo->flags & SKBFL_SHARED_FRAG;
 
-	if (!skb_cloned(from))
+	if (!cloned)
 		from_shinfo->nr_frags = 0;
 
-	/* if the skb is not cloned this does nothing
-	 * since we set nr_frags to 0.
-	 */
-	for (i = 0; i < from_shinfo->nr_frags; i++)
-		skb_frag_ref(from, i);
-
 	to->truesize += delta;
 	to->len += len;
 	to->data_len += len;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cf3ddc055d48d..043838d996404 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2710,10 +2710,12 @@ static int tcp_clone_payload(struct sock *sk, struct sk_buff *to,
 	}
 commit:
 	WARN_ON_ONCE(len != probe_size);
-	for (i = 0; i < nr_frags; i++)
-		skb_frag_ref(to, i);
-
 	skb_shinfo(to)->nr_frags = nr_frags;
+	if (!skb_frags_try_ref(to)) {
+		skb_shinfo(to)->nr_frags = 0;
+		return -ENOMEM;
+	}
+
 	to->truesize += probe_size;
 	to->len += probe_size;
 	to->data_len += probe_size;

-- 
2.56.0


