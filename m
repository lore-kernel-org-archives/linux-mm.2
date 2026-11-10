Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1674606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoNQqoKr
Received: by kanga.kvack.org (Postfix)
	id EE4226B05B1; Tue, 10 Nov 2026 15:38:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9AA6B05BA; Tue, 10 Nov 2026 15:38:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD14B6B05BC; Tue, 10 Nov 2026 15:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A61F46B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:38:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DED580A8F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:38:51 +0000 (UTC)
X-FDA: 85420373262.14.B75B2E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5C5AC180003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:38:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aoNQqoKr;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343129;
	b=TVHYXTnufjO8NkU8eiqMg+qd/CCHuszE/scwHi9UlTkvodp5FaIKWVor1fqXhrV+vE+vJz
	y35fajumO0X4HeZmx0TBc0A5kPSDfjucfay2JQ5L2OqyGO1w1ebugkOvCUkcYxkB2MwwYm
	PLL9ybsi/8A6+Ut33RKlnGuCmSnHlEs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aoNQqoKr;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4I3GmTnbTJ+C/rO4Q1xjwO8KlhKDQBrwvfrY+E5Y8ZI=;
	b=PkytqJffKr/5tsJTnNASrz6d1fQVfR1hBoKym8IWJFVxQGOM1KAcONW7AHRYXP0FOZmjeu
	gnFZl8Emri9ZpUXSBfnTEGao5LxzxDsNxg+8Aif94V1895Y0AEXXI49rv0LYEo3kJ/dHKU
	6+oc7YJfA4ukgAw0dnCrYY6+KsIppOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7920F4063D;
	Tue, 10 Nov 2026 20:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372351F008A1;
	Tue, 10 Nov 2026 20:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343128;
	bh=4I3GmTnbTJ+C/rO4Q1xjwO8KlhKDQBrwvfrY+E5Y8ZI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aoNQqoKr3Z6Jnx5nX2JhE1cCS211UWveUhHYAD4hLFQwm/1JQNmUAt6V+yPAwkf5z
	 vN9ZIYHWhP8Hpd5/fDaitNXThHErVlsOFI9CuJL6VnXNgYaJFu1LTbvFXbjnVZ8cui
	 WoSilzZ9PEX7YkVJGvRI3Abfj0xQGky0E0GVRLf73dDfjGQU9LZZ8Lvq8L8CifigiX
	 M71WRdl5+jlfNKemDMBCpfDRDbS2lM9NGzRwUSfloiOAbffMd+2RLyDOkmA60HRgIM
	 adk4B0KcRda2tHSroj8DdmHbdA2R4KjoCrpU4aTxX32GbbLMhy4SLAAK4G4UTW85Wr
	 9n3fhYtN0LeHA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 10 Nov 2026 21:35:47 +0100
Subject: [PATCH v3 7/9] RFC: net: limit folio refcount when rearranging skb
 frags
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refcount_overflow_stable-v3-7-318625d63a98@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5031; i=david@kernel.org;
 h=from:subject:message-id; bh=wbwCYm57JirFvO1jEPagtVrKyKCbDM8zxgcYTSE+rvo=;
 b=owGbwMvMwCF2QOXvyb15Z08znlZLYsj63BDx9439hIQZPvu3nf67muWokK7svON5d8+dZwzTD
 s8+6BBi0VHKwiDGwSArpshybV1OavCaVseyKEM3mDmsTCBDGLg4BWAiRyYz/NM3VVycXuvAsLZP
 3kxO9c6GuuQV9T4zGn+bVLunaPPwzmL4nxfcW54cODP7sHXsdeFJBxWqeY/1dr6/xuNuXLLrPZc
 0PwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C5AC180003
X-Stat-Signature: d714twj6uwrcskeoae55rfsh7kgyknwr
X-Rspam-User: 
X-HE-Tag: 1794343129-891596
X-HE-Meta: U2FsdGVkX1+0626MIOUwWYO66AGENK+5L5cvYZ9ImWfqBaWQ+ZbWRyQHn7EsbVH63uwCFT9JDvmQlFjhtYnR7yjB6LX4znr6r/5+1Fp4MtzG7diLDG0nxTAENe8CDppwjy9jfv7hglT7m7+EEMNQtJxxRkYVMdPNFcYnuamA2fIVabPzj6YTulwXaYuO0+5UKL5yT6eFtWBXrK/87kmWttTWiE7kmrbLJvMSSFYFStfo19Ytey4/hJX2W8WOk5FV1Guexb8CyInSA1hG+xrScaWBVZEDF1gbDbomABqthVVPev4/vpl5MwTEbTtxjx3ZCgNJfG05CNXrDwOMgB4PGyDbQtcSeUXuM1Ok60RRSBsBdRY8z//RzyTMO77l8SysmgWgX2A9htl6GsUZNsUWaY1RV8nP1mMHzo16BYL0X+zbdkdUD231ctgJAwnrhhLAsTxWi4aM4aEzwe/NgUkPzJ6sqotqCAFEk/U60M67AVSGVnHPh5kQxNKvCwWozs9JZWC+Zb/QqArXEc3wt04Nqa1EHD7QICMgB+Xltb+RvZUGgn58mAX4U0Rj4PyZVryLKSojzQtqVjp1XPqIN97YuRC18NItz4OEu42OpEKvkM5W+YHmLmNNUKO4lfGAeRXa5wYhyO1K02yY7XZcfGHdCZ517EW6E+EieT3DF3mUxy6SjwuU5ukELTcR00hU8kZ1XHiQW2064cr6TmD+MoA4aEt4ywrXl0z0fueSXQBCuywD8cd7zI6ZORZ4r/jCojdCLVIc2lxdkpiJ14x0YbYshiAKLLyU11LXvf0aWCfj4SzbXHlOGGgEAxCmYchHHEEC0NfdcJuz8N4y65p+CSjrEeEDzM1/Ux9arfqxlAQJyQ7JoNo/iylqlOaS/fQpOj7okQWwS8Ob/5ceKJvPC3udJ8u1wT+ebEzgPdQWfC9yeRZ3UdyLBCdVbqpHawGNNo/T08aQNKSN3qfNCHdLx+y
 OQojJrWU
 /MW2BsmWZ9z9/Ufe5RHU307HTNA6MzBaUeiepCLegt8rhA9dPxVZ54TCgyyeaEEfpEs7+eiUdzkUWivCUq4qdjybzt+DWQ1uUaM49Ujd0D3ftu4MgqFNuMa3YN8D2CSbvXQ0SBSwvSFQANFQLEcYQ2wl4hTJIA8Z76N8TULmtNrgABbYtE2nrkYXG/JtrSQDDGhv55cKA+zg7+CYorr0sk+jdtkng+x7WtFEj1Fk5FagPWEK/8O6rtb0oR5J+BUN+YO3dV4XoqPRgDnCOFJszZFzfFKbWY+oEgkgEpAuK9JFK1COz4WF0ztzbzwyKuUTMB/Ti
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


