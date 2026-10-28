Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE439606A325
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvhTdMYe
Received: by kanga.kvack.org (Postfix)
	id 192276B05D1; Wed, 28 Oct 2026 05:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169B36B05D2; Wed, 28 Oct 2026 05:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6F06B05D3; Wed, 28 Oct 2026 05:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6D6D6B05D1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:57:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70EC3140BAF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:57:06 +0000 (UTC)
X-FDA: 85371581652.16.5B94E2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4B1E120005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:57:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mvhTdMYe;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/I7kmqBQ5Rj+UdU9RkgYygl6ZVbcADLceo09ZpBcid8=;
	b=drNlZWkwyxDpm6QKvibrYDFIR5GFlnyPFKk1V3gPzIGsdJMA4Rokkdt5a+M85vIGExc/pC
	3QGZnnndFd4CDcI209xb6DHqzeaeAlglvyR/KKlYljcfaSFydtbAahFVeS7crvE8Q/bi2O
	pl9rKwsQe4xIgj7QhpUrRNtWaqSNeII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181424;
	b=GLqYik4JKx/5j3FVbPIS7+ugw/eBt3GXM9WnvqmxeJ4u6aGhJqaRxGeOurNdjGenpb0U9P
	/4aNNFyRsHcgFjTfncmHbXlGBLKWd+b6fotCfMe5kXb/CaO+w92Fn/WKG63LXo8l8nwOTi
	RpB2d3moCFv86RtzCnld63HF+RRYvI0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mvhTdMYe;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12C1743A24;
	Wed, 28 Oct 2026 09:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97261F01825;
	Wed, 28 Oct 2026 09:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181424;
	bh=/I7kmqBQ5Rj+UdU9RkgYygl6ZVbcADLceo09ZpBcid8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mvhTdMYeQE1SZlZGRbDzPEePCKXGHcOqwQU4FxxGTa8ULa2BI+M1yI6MGKCnlfYZU
	 gfsLbkzye3qlsB8yllb4Qp5PYhA4/kVpCDhlO2QgyJGoODoPa8JY90XgUzAc+6e6ZV
	 KrweLv8zYRfx/C86rLEsU7ShEZ6i0eQMoZ+R7ZQephWinoxt4X/pQk34mVzeHeY2CQ
	 Ds+vTdSb6NiwE+5l5cCGbtz8RRunI3BgxzvF8u+eMgKfSM0uAzMAorobIkdI8g99Qq
	 2IR5KmO3fDQ7tDV2W7YapgHXXORcvAqNvRnmnRzrYQiTgp8JmQ1u6/PQZGSLjZH0t/
	 b6aC+z6a8paOw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:11 +0100
Subject: [PATCH v3 13/15] mm/shmem: fix truncate loop after boundary swapin
 failure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-13-4ce3baf2db4b@kernel.org>
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
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1913; i=david@kernel.org;
 h=from:subject:message-id; bh=28Zzh0mRi1ZJZ32G5y3wlP8eTabvStSa92BGfBa1RpA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmvyvrB3QckS5hwVvVP28Zw5HmGMl3KZeISffVr5T
 eioxqzEjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbCwcTwT+VfT3LoU8vyCYqH
 3+t0+d6tm2st1Fi1JmNysvTfoHsz7jP8ZlWbKNc478+zP7dUVv4Q2ctcekuJ+Q2v4N3Ah9ulf9a
 c5gYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4B1E120005
X-Stat-Signature: ekhncpsifwoieuxzr7tn66iqnuhc6mmt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793181424-964428
X-HE-Meta: U2FsdGVkX1974dhl58cUxcpNOetMr+Ft0//i1NNvqn1TT9b8xzYQ8HzgdYskb2Eof5owTD0BfMICGfLSS1xBTPhb/fw2ELzOPjsH4QOXneGMjurJrX6nT/tSwOIdk51s+5N4owk+FaBrkUQp26gJYG9FQmH3fM95n8CeZtOGi1xYJBWdqeltTxrJn5Yoz37barVL7aGHVQOCI93xIZb7lyUwSMwPa/E/5mLDnXykr34kuvvu2t/pKCVY+nYsS/hxRS9g3PyBrD1bbGh0puoViKHbr/n7ABVnP8vggO9v6fkfp0YGLzdHELVCXJybV/u9Cr1zPU0Vd80fzJtQC5YAEBKxb/2JOpOFykX3o4INBwM817x8E6Pe0dnvBVQce6zBmD3f9nujYxHXKvmnyr57pqDX/N+OxkpcIWn6FBNoL5B8fYRCDsgMGLimFriC/TG0kYrZIAhAwFbO4negS7HYqW7OmJcNK0vlw/T75u4OWnGneGosb8DGtn0cBiZFwnLa0pY3rmKR5KWV7FY337YpJkd3Qcxuq6zuqrJdtWvms7X7txsgH19fhdndHtQ4ip8DK2UjUqHj3T8wrZzUGhIWBZRxy3ESoHOiC8YGW4q5AngVlOaAsa7fKB1F/0AYfY9zJ7tWKAkJUQf/X2RDbKgFbv2CI/ukLZ6LOkqO3KACU7LIdYIGCNln3M9TZPvxwXCnB0RJo7WkjAIZw3eqpedu0VJh/tSPD87x8BEh7nn+vprghoeXbb8+2GSlNYJ7WHUg4Zlf8myGDIqa7YYiJmNaHFGEBY/TREJIby0SkpwlcD1L1YAunZfTCuKcz/CicqbZmqE5qS8cRFlXnCjFwT1VVOSJdrMDbuOl6f8tIpBXAJa5ZErvD7MOQdh+ryfVLIlh4dgXBprbQOqqPmUS9Ht7XXJcVTqi5EjHzlE7ImKVJE3vb69Vpfkn5RSq4HtXoxQKPDZCVR3PJAain3Zk48J
 0+vMeNhO
 tfKUFH0X+WY6X/47G4WBNEBdP7dZyzET6ZCfiK+j3Ca6zN5f23/wE3F8EO00cZXNUSO0gSFC3t8oJ1lbWTyMmZ/4Pi2bDicKbG6gY1u2PVSIcQ7nCvEkGpOe+d9MJ3n01jwtimuZh+4oqcLTU1jIe/1fS+ocFLkY8vhJ5Lg40BT6yYz53zPcqXYSkZtJFgMMVUaL18j5KDRFRzompU0+c3OHio3XPRx8/o1ykNDh5Iyf4pmrOmI8QsjHIFshNGF5yx819ocXoSOG4zG0LVFpwUCC9aQYVO8SazTvfBekIZuWopo2jBUW5poh6bP97+r3oPrj1ojmZE4INVx/fgkfzbdR2bXpe+L8R8vVjj7sBZCr4rJlvhH6fPWO1mBV9Ei46WrgQYJSNgbqiMv5aGn8qMsdXDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If swapping in a large entry at the new EOF fails, shmem_undo_range()
leaves the entry in place. Its final scan skips the entry, then restarts
from the same start index and finds it again. Truncation can loop forever
while holding i_rwsem.

Advance start past the skipped entry so that a restarted scan can finish,
as we already do for folios that cannot be split.

Note that this does not fix the missing zeroing when boundary swapin fails,
it merely prevents the endless loop.

Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Cc: stable@vger.kernel.org
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index da2f5cd37eee..63f7fccf2ff5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1434,14 +1434,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 					order = shmem_confirm_swap(mapping, indices[i],
 								   radix_to_swp_entry(folio));
 					/*
-					 * If found a large swap entry cross the end or start
-					 * border, skip it as the truncate_inode_partial_folio
-					 * above should have at least zerod its content once.
+					 * Skip boundary entries when restarting
+					 * the scan to avoid endless loops after
+					 * swapin failure.
 					 */
 					if (order > 0) {
 						base = round_down(base, 1 << order);
-						if (base < start || base + (1 << order) > end)
+						if (base < start || base + (1 << order) > end) {
+							start = max(start, base + (1 << order));
 							continue;
+						}
 					}
 					/* Swap was replaced by page or extended, retry */
 					index = base;

-- 
2.43.0


