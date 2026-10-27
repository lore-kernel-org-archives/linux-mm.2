Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68B1606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MAJUnKJp
Received: by kanga.kvack.org (Postfix)
	id D47A66B071F; Tue, 27 Oct 2026 09:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F126B0721; Tue, 27 Oct 2026 09:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34DA6B0722; Tue, 27 Oct 2026 09:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8D66B071F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CF87160A3B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:14 +0000 (UTC)
X-FDA: 85368424428.08.B7DD5FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 57EEB14000F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MAJUnKJp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhxjLl01JE8HuMTeAuZe7yEExHhcmywGMiR+Ut1EZeI=;
	b=FSSGr99y+KjWnt4CczTm7DKWIgyC6Na7rXPIOeEe0qa2veNQx9OrqVz5v2WObMpDcfW24L
	3ddl+zpTv2G3YVmfpF8+vYVgY3R8dS4/KpKGHmPiLsQLl0Tu5Op3AriF4y8r58pc1tYZ0X
	uvx/mcx3EmK8LSdxbobZJcUjWvQK1HM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MAJUnKJp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106252;
	b=O+s/tTLXDl4tVe0yLoooBF5xdYQ4bAqrkJ0rxTA61XiTEJXYxYN24HuLFxKlYefV05y1Rv
	oI7iSku4gM63bsD5lnGNOQV/CFSNV+E9NDIBqUPx8TNIjVIuCM9jxebOvcrdu+kiTxdcSF
	1K+ifVyF/yJw/HQLHzxFnfoJLsikG8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84F9440F89;
	Tue, 27 Oct 2026 13:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383461F031E1;
	Tue, 27 Oct 2026 13:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106251;
	bh=HhxjLl01JE8HuMTeAuZe7yEExHhcmywGMiR+Ut1EZeI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MAJUnKJpssMeeloEVpIfvQ1vuVL6RVQCj8iscz0RR7jWPKYwoYelvRV2efgyDGJPS
	 i6IXr2sM4vUIqO3py3xMMXOUqfLQdfbZu6iGKnCLK1GZNkuY9nTQv6GBwcfLx2Pds7
	 wedoPfGuYfPik3pVvcW8lTOVewcH3UReqL8V1wIF63pbHYqmjpP5W9k5yaZ2aDF4Fj
	 UB36IK9XwB8C71NcVT4u1CwKci1ilb3z4cu0dWm0Ykcw7iCO3shJCGQjewI+d+2cCx
	 PbFGvbeNSOtvF/FVp+a1AT9mJuodT9Z9RpTnUbOr1bHC41FDEj4eVqqX+FjqjbMYjp
	 96eD9lTCKseqQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:11 +0100
Subject: [PATCH v2 06/14] mm/shmem: stop retrying folios that cannot be
 split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-6-86a00952acb9@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
In-Reply-To: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755; i=david@kernel.org;
 h=from:subject:message-id; bh=xU6NxeFuouXddfE5ExETEgUGwjovPx64LRkyocig7Ck=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBSsPj3973PG+Y92+ax+ZcYkd62Y55LXvdXTmNSbT
 dZWT2i81lHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEGp8xMryYtkFw1UzvUE37
 +p/TV2ZoZnha3Dq18VbXxzLj6r8CW/oY/vDdqMv74VEmlz+3ft3iLB7hfVdtuTJzNvT3TPn54U3
 1NX4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 57EEB14000F
X-Stat-Signature: iu7rukgexoep7dod57j7x4gt3qcrda7q
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793106252-109002
X-HE-Meta: U2FsdGVkX1+GiAnWBQoXz6f5PO2Q2iP0o6t8Hf1kIGipZbxLqaLBhQHCuxd9H3qy8H1NnyyBI84EyF4/oD6/P3OZJYpMaFg+J/rF8rP1810Ee7BGPzKlwdD0bHYymQubAyjmLzV4mKof2cBC2hTcMZO4L57TKzZYrTcFgaLD/VYz6EuX6kqe+R+VA9txkxjFb/eaIksSIK4tHEd8P8MkNU1n5jeEz9x12ubuxWUnydf8uLnH7EipS/HU3LYkMmiYI6RxcLFg/P9K29Ted/LDy5RAheUBVrIY8rwF1wezTTwzd8TTglTnyuNLdD/MJVgZ/yamTJEJRh84qIZKPJagpRkOaNM4UtmDbub3Zh1pxnr1W38bqJn7xH1LslybsOS6cKbr9fXlQMc1wfNSTWi9qWMmgX/DMzQvbfd7rkNqZRSaC/MLoGjOz4Dja5Qmb/UPZW/37LrfwCoEpAgAAQhtObqEmMr7I0bl120wENXNg4WRrAXzymCOrFBQzOJNcoF7l1ikUToGSOJASIvDaMzopo2PXUZW9trk1MqQa4qnxLe3dIhoypOolHsYM03x9y7jOq6n7MIr0Ci2oyoPiTIYH7XaFc8+K1m1Uu8mcU4jnSJlK6oyhM5H7PSbrPGVBHDCRoNWTzr5rf7etuOJ9Ihy8H5TfNOxMswVw9hIW4RvKwUEyetQLUANl0Gk8cQNVpjDhUa55B3U8B2UpX+sdk4s/GxXQYSYEFhicQxeb6X5uUKYpyt0cfmSM1pGWellSQEk6SQNveLcwa+9RqMCsiHXyuVvsG7rDQFSKGQmYUZUqBkO11BFNWumBL3Oo0PNpELHzajY6uNddVTHcDl/SGXMqXXktkx1aRh/Vi/N6kmHZNIQPjhABMKAmxZbG2Fpnn9Jk/jptxtLGLgCPqvpEKc/mqiDPfUEQjy5+S5xHUv62Vf3E97fKzJlgSNSSQcYqMB1MdM0B6KXFdW74XHMLG7
 rZ91qVu7
 o0K+SDbdOBm0deQzO+zJhEwJVJzAGNOZy0cEbSY8BiKnOySpNkpXQjleNax+1HIchX0WoO6KZjV7Xb10NtnYRysGZY4hLs+Pt6RN4v56UrrPwbhvdbB1V2ZQIaH+7xpbnfbjzYbfSUDvXQdantNigyM7hvruCk0oEIMcO84UNBCEh9M7R79fynIehNfqQiw1gaPWmaPfkFSjDOZ/0vXxnoSLduzhXkLdXT/Qvf8j0jQpkE6GAjXKG7r4WhiL0t1Rltl5sBJLQMUseS0oPSGbj64SWue23h0Td/FJ15WryLK79Cekw6ztBdS1QwDLQiaj6bGNaqGnvuCBo9YRwiaeLm5wlnbJPBOdTnbTs2/7sgytnAAKKB/cByI5us5bCxPKZKU1U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A fault or collapse can insert a large folio crossing EOF after
shmem_undo_range() has handled the boundary folios. If splitting that
folio fails, truncate_inode_partial_folio() retains it when it is dirty.
The final scan then repeatedly finds it because it restarts from an
unchanged start.

Truncation keeps the inode lock and ignores fatal signals while looping.
A concurrent unlink() can then block other directory operations while
holding the directory lock and waiting for the file's lock.

Advance start past the retained folio, whose truncated part has already
been zeroed. Do not move start backwards if the failed split has shrunk
the folio.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: split fixes, simplify descriptions, adjust comments ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ad644a268c0d2..5d21cdf5fb0a5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1481,6 +1481,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 						index = start;
 						break;
 					}
+				} else if (folio->mapping) {
+					/*
+					 * Splitting failed, but the part in the
+					 * range is already zeroed. The folio
+					 * was not dropped, so skip it when
+					 * restarting the scan to avoid retrying
+					 * it forever.
+					 */
+					start = max(start, folio_next_index(folio));
 				}
 			}
 			folio_unlock(folio);

-- 
2.43.0


