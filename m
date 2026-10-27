Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C62606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I1Xnx4sq
Received: by kanga.kvack.org (Postfix)
	id 272476B0721; Tue, 27 Oct 2026 09:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21AA36B0723; Tue, 27 Oct 2026 09:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110DC6B0724; Tue, 27 Oct 2026 09:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFE1A6B0721
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81827409FC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:22 +0000 (UTC)
X-FDA: 85368424764.16.4C0BB98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C1021140009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I1Xnx4sq;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106260;
	b=a1rvs1Pi71lfXcogFU6roOWDUD3EXZVH5llWm6zlD8FpH5hgcykkyKyc09PZ7sIq7QTCXN
	XT9ydMbCsN9q+zUTtfYdJQLuIVUBFBZgbHZUcBMnj4XX7TdUGLRzTQttq35ihrb4Ug/2OU
	YryVDytc8wM5VXbtJGrXkHi28BFCtrM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I1Xnx4sq;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZQnjGr+7zqAkUOcYsYc+HBCm7IFXBoUv+E4NCOAhu4=;
	b=uBuQOF+Q04COXBRBnlt53Rw6zGTkW/heE6PDDHG10nfpGewZfXMQvb92nNTaEHxHq9t7dI
	ygXM7P0wAlhEdfSouPclaTyMuJiFNLbbt/kX368zkNpXzv7Ae3FRuV+Jvb+faPnk4Ynx2T
	xOnJT5V+TaAHo5JL3v+3Cxd5dZrUZmA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52D4760211;
	Tue, 27 Oct 2026 13:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDBF1F01825;
	Tue, 27 Oct 2026 13:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106260;
	bh=lZQnjGr+7zqAkUOcYsYc+HBCm7IFXBoUv+E4NCOAhu4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I1Xnx4sqE9jldE4r0IuDBNkjaKVACPM/Y5b9c6/UmLWn5lMRQmxPgq67uXu8V8V+F
	 AmKwsgAKsyPxyb6d5isPOOH+N+X+yOm2ibKX6jN1Ph0YSBvYmS50t9ckWri7MQNEWk
	 nIMK+bm+ZgR0NZqfcgO6D/4NF9H0IVMdXT+I+/2AbCxu3WxUS5IpP/q4ldK8KBlBnk
	 TrE+9CyCj/G2hYiJ5lzZL21yrZF7v4b2agW5xTmAiWUB8asHxACtTAy05ZQXGPGnhw
	 DYzK7NxUE98gHJyBcDBpzQpe5YzVcI6uZbbbgO/BCMtXgPKqsliqhYc1WF7CsIN7Wk
	 iIyKC04Mge4jg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:12 +0100
Subject: [PATCH v2 07/14] mm/shmem: preserve data in clean folios when
 splitting fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261027-fixes_shmem-v2-7-86a00952acb9@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3641; i=david@kernel.org;
 h=from:subject:message-id; bh=odgGbKts8VBN1JHhKCe+8QzRLyJJiUf0Jtw5O8U8cvw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBR8eKzItSjQYqGyX7Dm53vPCqY+lU98vTpm6p05r
 R72TknFHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkmz8jw9NJ9w/yaWvquTza
 2Wtw/zZn50qjW7Yfl5wIK+lZuctnChsjw0aubeLlIWpMyoHhXnlZpd6ygYHLduya8GvytQ7TWRP
 OMgEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: 4rn4kyrk7a1crznhzduw7rrsu3yypdpt
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C1021140009
X-Rspam-User: 
X-HE-Tag: 1793106260-305144
X-HE-Meta: U2FsdGVkX1/oxu9lOd7rKmL8e0j8OIc1TtHD25+7jSDC5SzXNQtYEQ+rSR4IY1QV34/voFFpNV8wEvXCSva2jA0LH+Ni4Is0dgDLwGYXHtNsdIEmmQ8TO+ODp9mLRHw/cC4PS4qoZZJ6GfOOSv2Wh7cHkSfAWOHII0mw8+cxQRVLwrreAw6a3TwC4ugkBlmyZDv/RnY/ZdH3zn3TigA++sUp8CM72Ks7dJsWBQym/rBOQ8Z/YZrDA61toW3QjveCGqNgR9RND1uymDwytpCjd1aA+C8UNOgTrnGVzD+wyGgc9mgYKv6IlYN0P532dfbX3tpjyhkbXAVgq+COW7ocWtVuccswtk0Z1RpoJLlu8Cp4SYYHga/Eb+jCwfdYOrjWoLBizZMG8cETyfGDlCE6Z4nZollkiJoWtxMciRmM2KXYTVRzAWQlgUnHMx+HRptO3Vo7fxklyjAQHINQhGAiJvHUQQDGyywRS2yC52A2qL+Vtj1V1usKpRaD1r4WlV/4mdNnoW/WoufJDvVHAB/nusMpwjNGOSCSLArWsZVWfTPyHQoUTIBsawXjVWLzX8eZgdN/q5AAh3Lenb5nCwWscrrH41po8A1ROGWCwQCMlCTwW63VYdZg3hknKBESQ1OhmycH+eLlhRfHoEDRhroJzutITnH+8p469K2Du7XW3PxQQz2URX4JndbIhYvXKB0N6syszpWXFIbWNSvetcghKQNrkAsi0r4KKYYRNKPB8WIlviyV7/sWUTJoqw9/0ssJJUAb9nxQGDPLJVFvhNnvUTena4RQ9hfkq3V2eTKCJfppSNpb5U2K6/XEHz26uLGy+QaA60JEfvPc/YGv/2U+SdyHzx/95tGF+MCpLKcrY3/8ptQ41Yj5ejc4uMszGZegaM04ULuz7/Vqtb4rZPOwTBBXGEpS2WGH/QT0c4QcQbBblT2BEl2RBFLRMfTGFYInubxxcFlEV6Frt2Bxd3/
 ALvQv2x4
 5J5o5nC+CifSVNHNHprO5r6+gCRjtYDGkUdR+5AzrqgRGGFDzW7rvefc2k57CO+2AGNwYkTdlagA4Qtivnh13cBJZsWRFl7QqIPhbDS84TesD6oG7RvKyKJVW93guZWqfFMKfh1Nows/vVebmYKtMCqX4YxNH7xDLb0sLLS5lliJC5hEqIo1oScPOuce5u8d4Ac6XgJ25ZGYkLPMMfMklOFzFeCkemxchk5A6xXkFdhm4D1NPke9QjjMpKOiERaUuXQDz57QO1uRN5zbftFSMkZTcW7BgCPOPvk+l/VjHbAwPzoP0xNZdeH0r9BKfiaSqUTzOYSmCYM6cTMSM6S4um0AWUsFEQcGl9qP0zjrtmcFUIDdk4wtnQ1jFMpmsR6WI6yTsy2AJigAEhNnVqOv7emYCV9Ci3hWfg2KS29d0wcFBSXknUjRGR6r+axHW3Je2Krjm
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
index 5d21cdf5fb0a5..b615301a311e0 100644
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


