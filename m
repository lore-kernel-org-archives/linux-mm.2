Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D1560A260C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gqqCWDCH
Received: by kanga.kvack.org (Postfix)
	id CC1E36B05C4; Thu, 29 Oct 2026 06:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A286B05C5; Thu, 29 Oct 2026 06:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF876B05C6; Thu, 29 Oct 2026 06:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 767DE6B05C4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C44DA7D42
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:04 +0000 (UTC)
X-FDA: 85375331328.11.59D09DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4E5814000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqqCWDCH;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270702;
	b=frdMV6kQJTsD6SJDUejGboHQIYmaM0qhDiwjRFpaf7ZS6Wz9YHwPsPJPACrDy6IXrscdZU
	c0eeyBMxrxyI/eU+l0tcjHsSwnPNSeqkNo5HnREIbRDgj7ai8PZNnsRIkV1uhxAybuYENs
	Dgte73uZCdl9y/BWGKfe85Ji+rS8Y9M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqqCWDCH;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jklh+C8k6+z2h8BQBf1LZgJVYEa4PBy+2sbpk3zqCZM=;
	b=J+C4SRzxeJhIsMnyavidolIS0UkLvhcSyGLFKjeZc/DlMIsIPQPwoL9gy2KnCvVBvI8/JB
	rSp0lTBrUyy4l/AOTYQ8JhUrHfxOJuG72xpj5deK0srt4oRrws8zXxdj6cDAjEK0liimA/
	6p3vU1tnX/aGjXj1/N/TyvvuEgSD7oY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9B48601F8;
	Thu, 29 Oct 2026 10:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B17B1F01825;
	Thu, 29 Oct 2026 10:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270701;
	bh=Jklh+C8k6+z2h8BQBf1LZgJVYEa4PBy+2sbpk3zqCZM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gqqCWDCHluvI/2m+PHmQwGqLQA70GogB+v7g1lQaBi0fWAEGof1xIZEe96KTIzueX
	 Fi3YmUKj4YMLoJmiL2RHrLrkDfiAFAPhYlgsamX5T87CLLb7COxN+K+1GGg4qXs9uh
	 hiXCNSM27GmH6n3equC4Qbm4zcMnAGIWDE0equkJEqaPLMQNkNbrQhL6a8M7HL0lH1
	 7hinojnZRSe97D+F0FDRmw4ENnZG87pgg4VN90B6ns6Fj18bjIJ44FIWS5uC3WEDxy
	 NeFkEeLoC8mKvjP91LeYl+of3mcY92SljhW2cJGlA7g0apkZ4Ded1A/KOw3pv5Y35u
	 yLCqA46yvCMcg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:29 +0100
Subject: [PATCH v4 08/15] mm/shmem: preserve data in clean folios when
 splitting fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261029-fixes_shmem-v4-8-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3639; i=david@kernel.org;
 h=from:subject:message-id; bh=y+fkP3XRhSdYc9v7R6EE8urjEHODsYBOBASodiKGd7U=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4c/+Fn0dUn1XsE/mqYrVhsZ1datPZ1y+tOTGTyvz
 5+qO6nwuaOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJHLrB8Ifr1MRnSbP/hEfO
 ecL76WXbMonU2K8+blMffhY1YvtyYwM/I8PRL2yS+sJbDqYYGWu7/J2q+vmzTKyKHT/r3wxjdz+
 JXewA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E5814000C
X-Stat-Signature: 3ji8o8i6da3ew5btx5cpkn6ow4iuedb7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793270702-628691
X-HE-Meta: U2FsdGVkX1/Ddj2HweGBSknt8+puG6A70LBI5ECS456QpApZHbUq4k7Nxr6c8N+Lwj36zuM/4a4WPC+LLi4j+5UTTIrZ9tNPMj8Ja0pWUJOXfMy4KoAYWIi47t1wzQBI3+u3Jv0F1stYU5Hr1PqJXy1hlJz7OcwjJ1jd9hZp6q+SyiJTo4gda5tLCm6sm5NwpDJhy33Du8h35mIk9g1GKuGbibV9LpeW+kKPHhQhPG3wMfhlifUrH+Ig4QZ1zqwXcgJXEPlW4cEkfnwF2rPse6oxW5VGA4WmZqVr388sr/cDBgwgpOfN8s0AUA6MNzkLvqmMjlYWpED8nMZdHj4lK3xUkMKdBuWTMkekQj4mcIaFoe8KSUdv9GqA6BM4cTknwmqfKLc6WToht/qH7VVmOmBVIgfMiHWkEFOJEZnnMvWXCTqgfC47/yIfHCTEUrID/AnsVj5VMGOKlBlHCLgjqO4JiSJ1zqii9QsUWb4ZQ5QyG26PJWx3N77Ilhs3NDFzumr4DFTAgfPMpmHYbMf3jBl06zyyzt6XgIbdQo0efe5Ugj3Inmp7Z9nkycURGcFAJnaEhH99Ka9zR8Nx2G3efG93yHV32QJfX3CzYFRik9oNNWmAGOLch14dECAGOd/yLscGzEZf/QBp7kAoZNYeuJlojwqAfzjDExmrbyre3UIFnCwjJUSyMcp/8TCPsxNG1+QSFMHeHFlAOJK9RHiv5hbE7Mb+KljM5fuXjriiGkkWlFcuhFTE6iCDEtGByMp/bytbZeCKytwN18Nw5fiXmiPrtnTV7enPiJ2aSdLl28oogv6ot4tTOur0EULUJD6b7le8jPP7F4PHFgFvggQAGgwRYvxawJtDmYflVKcHFfiEnmJfyqm8WGW9LPXGViVUA2iyBRmwy5QvWXM+vsVlOyj3GHpMMUmaFY5Je8ZmRcCXBkt7karQVC5VHuKbs0cAQVuSRSAM18Uj9ZlGDJk
 hn9x996o
 Rt0Xr+YAKEoFPsSCs0lQDHEh9dRxSyV6HWHHnqL1TxDnZYL+3Ea7iZiMvvRAUCyjTp3uC1y6xT+113AO8UvvF57tcORLd4lrMTLdWOOl8yUKggeXD9F7YFZtHbc/dUQWVkXfe8PuR1fCpOVJg+JAG/8eWmLEU4l0tn6+9aM23VjByMPqCnKl8MnwogYDHpS2R0UsfkyZXuvBEy//xUMkWhM7pTl7t6FrAqsJ0eX6dYJAAKJMaJkyUSEaJpdnzYKfDPb0oMOr6YVfy/CFhNxfR1xaHz1z7E45hRMeGvO+RWWglGNemK2J0F1//6F0qlRvmQi2kUZiwiRiHBoOJ2vZ2Kw+OLDknp6p9dcu3mUAxUfM0Nb9kmALbe2KG+Pwe5a48aGuqZgZBVwR7OzKLO6kj+Zz+SDdsMWkpuIlt3tcPW5bZR02ZFlwVva9HOct8Lr0n5zh1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A shared writable mapping can have dirty PTEs while its shmem folio is
still clean. A read fault can install a writable PTE, and a later store
sets the PTE's dirty bit without marking the folio dirty.

After shmem_undo_range() has handled the boundary folios, a concurrent
read fault into a hole below the new EOF can allocate a large folio.
For example, on a tmpfs mount with huge=always, the fault's offset must
be within the file, but the allocated folio can extend beyond i_size.
The final scan then finds this folio and calls
truncate_inode_partial_folio() without marking it dirty.

Splitting normally collects the PTE dirty bits when unmapping the
folio. An extra reference, for example from vmsplice(), can make it
fail before that step. The fallback unmapping on split failure excludes
shmem, so the helper still sees a clean folio and drops it, losing data
outside the range.

CPU0: ftruncate(fd, 3M)                CPU1: MAP_SHARED, tmpfs huge=always
─────────────────────────────────────  ──────────────────────────────────
i_size = 3M
shmem_undo_range(3M, -1)
  first pass: hole, nothing to do
  boundary folio at 3M: hole, none
                                       read fault at 2M+x (below EOF)
                                         PMD folio [2M,4M), crosses EOF
                                         writable PTE, folio clean
                                       store to 2M+x
                                         PTE dirty, folio still clean
                                       vmsplice(2M+x)
                                         extra folio reference
  whole_folios: finds [2M,4M) folio
  truncate_inode_partial_folio()
    zero [3M,4M)
    folio_split()
      unmap_folio(): extra ref
        → -EAGAIN, PTE dirty bit
          never reaches the folio
    folio clean
      → truncate_inode_folio(whole)
        [2M,3M) dropped
                                       read 2M+x → refault → zeroes

Mark large folios dirty before partial truncation in the final scan,
as the boundary handling already does. Exclude failed-fallocate
rollback, which must discard the folios it added.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: simplify descriptions, adjust comments ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index af49d6bf6382..11c3e6b1aa76 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1464,6 +1464,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
 
+				/*
+				 * A shared mapping can have dirty PTEs while
+				 * the folio is still clean. Mark the folio
+				 * dirty so a failed split cannot discard data
+				 * outside the range.
+				 */
+				if (!unfalloc && folio_test_large(folio))
+					folio_mark_dirty(folio);
+
 				if (!folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio,

-- 
2.43.0


