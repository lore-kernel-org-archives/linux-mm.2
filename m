Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B177A606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dC6x6mp0
Received: by kanga.kvack.org (Postfix)
	id D79686B05CE; Wed, 28 Oct 2026 05:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50826B05CF; Wed, 28 Oct 2026 05:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66B46B05D0; Wed, 28 Oct 2026 05:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BEFF6B05CE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:56:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D28AA8589
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:51 +0000 (UTC)
X-FDA: 85371581022.25.D0EC976
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 821F3100003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dC6x6mp0;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181409;
	b=KhuQHKT+joLJR2uC8U0rsod+3Mdh4vaM8ic+HCLd19K+4dfNBNvFEfvqFsibfzIlgY6ba8
	JOZmvCrHy/O4qKqaL2WCxLSs7C+YUZn3PmA9eVqSEQrFdXMteDFTV9MPgNtajMPzywtEmV
	69eF0dKaB6VOLiznS/U+bm1w1K5mllI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dC6x6mp0;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9K6LuntH9T4HIMxba+wTQAhrty/BEZYK/zZUmw09iQg=;
	b=1l3XnxmFqVRucbmmZEM5kKwCd6onMcTtsA+YsCPZ+ei+aMwRlYz7fubIJmRklrTriv1GRq
	XS/nb4dszBYgSjw6DwQ9TzhrqFxwt8dkyplu/OE8EZkXsqISyGcLMp0M34+pNCOVbfFAOa
	DabWGo8+o/lk2UZG7UOpjX6qDwQeITc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E1EA601FE;
	Wed, 28 Oct 2026 09:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98C91F01825;
	Wed, 28 Oct 2026 09:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181408;
	bh=9K6LuntH9T4HIMxba+wTQAhrty/BEZYK/zZUmw09iQg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dC6x6mp0CrCnPmvZRxEeyoOslOOH9vDbPicyPAx237mqoHjzDrh2nBB8VnKrGZbZS
	 RVoA8doKLR8SCFpYl6x5Civn1umJCktVgsaZ+0ScQ/mRCPZevSCw1YXe609a/wY8ai
	 1crQ/b9lXE0NENwwR1RR+4A6jU8TYGf35TKKhKogJrAeW0leTWEbgIwkBWvBXZJqpC
	 9x9vcwKJ3r84XTxC0sVpuTJcTIfZuE08brjSDjKW7qQIeZOtZaO7PHVRWbtuvHJccE
	 dAtEMpcu88OfE7WYR9+o3CvCWDhiZZ+6/eKozJcKOP5tXKhUZMCucKSoLgNVfbKQ3+
	 ZUlVVTfRXkMDQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:09 +0100
Subject: [PATCH v3 11/15] mm/shmem: fix truncate hang in large swap entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-11-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3891; i=david@kernel.org;
 h=from:subject:message-id; bh=8QPoeV9STiSx5Xa/ZaTy76exQxrTdIRl5s6LBctDShA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmvKOja9bm5b0N1XbK0vNl1b69Otc/6Kwax/J467P
 vgirS30qKOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJLL7O8E9TdEkR/728ohqB
 zYeLLuortPAKfZCfcn5dkPHdmperOoIYGXaIN7JrvFz+5K9KAU9QQKm8k+2umt7KJzHmf9wKneW
 YOAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 821F3100003
X-Stat-Signature: b3xhhs714k88dsx6rhszr8jz98iu8bmj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793181409-547189
X-HE-Meta: U2FsdGVkX18CBlAklBzElnOMYR10I7FN2EiRKaDd1Fs2juz3D2ju3h4J6VaZv4LDcE8EAJqAzrZfqOgRpjoY1kAlPtmno5BioKjVov4L+u+lToQBm/C/rewLUjriCVFHtedZ5jVUfFXuMxdeejlmTfun9fbqslxc/kfyODq0mTP/xk5LwmySSDBKfJPsNYLLcCZuQYOMcgtYGLEvNB46NFNJzoaTL8dhRNuSxIVHusRxWtErhuaIdxyDhKtl2TYDZmbXiWFMtM0fwSAGURjl93kwrcJHzsvB9xU2sxyqIM8DggvekJsGNHC8ulZ0sVz9zxse1kZMvpaTgSUBhDDFmbhquRjTEKZr6xioblSd9EHphqSE7ut5gDHA6h1jf3/TUopgx3tpSBe4Xh38KusvEjtdLB8KQ7oP5EobHgKMf9H1o1F384LFsDtYlMTK2mb+waT/IpdTIk8XSB1VZre10GoEqmbsBLa3Dl96b9bN+khs6Ibu6CPwcVIZ0bcHxMUTJVWgXOnCr65ezpjKB+Uwz/lwSM3nQkjGPNvbYjND1CQRSXoxXFC2aC73peiyo0BO3bJqLnOipGMFDsKrP/GmjFTBPrkg46084QPFtoYxdjOdOjw73MBwoILuGjbWhqGuenDpregSXn+lyqlRHpBrch1Z5ZvdZzVMpL9Hr+AvFCTBLDovJ6hiUd1HBZjnrJiNbYTb+hKhfzS2AlLWszXFmxTkmwNmXk3Lkdu2EQ3PNMeUgCjK+gGXy3+Updb1RSoMGzOnCVnLGGxhqHcOCDMeqjCrbE0ka2dFfrZnWs3yurJIfPzMzjhvH7jYs3RB7nK5aH18Im9t181P+ieCE5a7ipmsd4uRj0Kg7DSPlTN2tqJ0ZvS+FFfMbPkN1dEPQDpJlZ6KA1EA2rdkJZFuZy28844GhGXLjVcJU9GSZ2mHRVeXyumTRi6bk/SEi0FRmIDMVKdlwwz4i6R6Txg1iHF
 0M6OR6fx
 zBHjZ/kRahCjCiQ7vZDW0mf8WsjPNzqhWmDu+Dot0PThprCFbV57nayApoRaUlii1xeF1T0JxPK5kWDMBwGkrgj7RcYIDK2UBZD/r1O4MTX/9WWP7GOZRNyd65UUEP0V2Fe6bgBq5oumoYzDSDaesK6lGXps5VN7DVXTrjh7y//7OWmaijM55z2fT/oEqYcHacK9wqIFGV+1d8CvzSvV/RUu2vFcLPOpmGFMErEGx331/AfUUg7C9jrMHpmivaSfFWafg1q7nC+T4+AautpN0uYg7J8QwBQiJjriomoouLlHMq21Fu78eMXEEA5j4LL2aiDaD7Zb67kzMnAoLFoR0/v2N3JhB9vRwp4OludS9JmaErIxgVpSdINEIDLJjZ/eXXA/bU+YKxm/X8T14U7hcsFvL+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Truncating a tmpfs file or memfd to a page-aligned size inside a large
swap entry can loop indefinitely in shmem_undo_range(). The task holds
the inode lock and cannot be killed.

A large swap entry represents a whole swapped-out folio. For example,
truncate a file whose pages 0-7 share one swap entry to four pages:

    [ 0  1  2  3 | 4  5  6  7 ]
         keep    |   discard
                 ^
            new EOF, start = 4

i_size has already been updated when boundary handling asks
shmem_get_partial_folio() for page 4. Since it is swapped out, the helper
calls shmem_get_folio() with SGP_READ. That rejects page 4 with -EINVAL
because its starting offset equals i_size. Nothing is read back.

The final scan cannot free the entry without losing pages 0-3. It skips
it, restarts from start = 4, and finds it again indefinitely. An unaligned
truncate avoids this particular failure because the requested page starts
below i_size. Folios already in the page-cache cannot trigger it as the
direct lookup will return them beyond EOF.

Fix it by letting shmem_get_partial_folio() call shmem_swapin_folio()
directly for swap entries. This bypasses the read path's i_size check,
allowing the existing boundary handling to zero and split the folio. If
swap-in returns a smaller folio, it also splits the swap entry so the
final scan can free the entries beyond EOF. Retry the lookup if the entry
changes during swap-in.

Handling swap-in allocation failures remains broken and is unchanged by
this commit. Even when shmem_swapin_folio() correctly returns -ENOMEM
instead of -EEXIST, shmem_get_partial_folio() returns NULL and
shmem_undo_range() skips boundary handling. If the large swap entry
remains intact, truncation can still loop in the final scan, while hole
punching can return without zeroing the boundary.

This may read an entire large folio back from swap while holding
i_rwsem, only to discard part of it. Avoiding that I/O would require
splitting both the swap entry and any large folio still in the swap
cache. That, however, is much bigger work.

Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 21983cce9fcb..59907556369f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1298,12 +1298,10 @@ void shmem_unlock_mapping(struct address_space *mapping)
 
 static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 {
+	const gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 	struct folio *folio;
 
-	/*
-	 * At first avoid shmem_get_folio(,,,SGP_READ): that fails
-	 * beyond i_size, and reports fallocated folios as holes.
-	 */
+retry:
 	folio = filemap_get_entry(inode->i_mapping, index);
 	if (!folio)
 		return folio;
@@ -1314,13 +1312,14 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 		/* The folio has been swapped out */
 		folio_unlock(folio);
 		folio_put(folio);
+		goto retry;
 	}
 	/*
-	 * But read a folio back from swap if any of it is within i_size
-	 * (although in some cases this is just a waste of time).
+	 * Truncation can look up a large swap entry at or beyond i_size.
+	 * Swap it in directly to bypass the size check in shmem_get_folio().
 	 */
-	folio = NULL;
-	shmem_get_folio(inode, index, 0, &folio, SGP_READ);
+	if (shmem_swapin_folio(inode, index, &folio, SGP_READ, gfp, NULL, NULL) == -EEXIST)
+		goto retry;
 	return folio;
 }
 

-- 
2.43.0


