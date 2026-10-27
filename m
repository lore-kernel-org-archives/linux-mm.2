Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4942F606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AkarBh22
Received: by kanga.kvack.org (Postfix)
	id B4C1D6B0728; Tue, 27 Oct 2026 09:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23476B0729; Tue, 27 Oct 2026 09:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39D16B072A; Tue, 27 Oct 2026 09:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0656B0728
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BED97120A4E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:38 +0000 (UTC)
X-FDA: 85368425436.23.9E2F0E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D38F6140010
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkarBh22;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106276;
	b=IbrlQJXBmvSHy8kAdy9+dpcBB+sSOvGE5l+9KLf/HM/aA7ca/UUCWGwuMDuR41Gc6IIpUf
	ynw37iYd13N+rtz18u/5skhXXRkM4TwaLHz0iQ6EC4Mdk5sOeTHwqsXI9t+l3UDygXdZ9p
	DrxWwoMGVOKJ+HZpE9giEBGyuG4shB4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkarBh22;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5v5cRepOrsBtlr314Avjpusrkb5y4iwoU07gbK7WHQ=;
	b=uMyQcxCA1lSQVGXgUIrMKvMWxunCPCHaptk/8HsQYLPFp3yR5+1URR08tY7NVKXegxvAwE
	sASzNFuYwDTO/szrv+UcjEA4OV7TLm3hl3a/krBTtExpRrLGuACWycr6Tsj1uUkCYgQuVw
	sShst2MNeD4Us9zxrVodosg8SwlFyzQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A0E460136;
	Tue, 27 Oct 2026 13:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB94F1F01828;
	Tue, 27 Oct 2026 13:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106276;
	bh=T5v5cRepOrsBtlr314Avjpusrkb5y4iwoU07gbK7WHQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AkarBh22x4+jVEY7agkIPV8RfXkGZDIb0Y4ylixEHIv+R/GiP56wB1jYdxsk//gnc
	 47FfnMlhIP6wFqaCi8HXhlesPeiFi4W9n5Lm2pb/Z0vIwgauFCD7hEANoPvdTCSKOO
	 UYAAN9u4/CzepyWqdA49RZI8xwO3FKyn6eYI13mQE+9yfwHIwmtIYC2YyFmQBmYlIx
	 a8mh7nOL3b1NI4HnYM4u6tp0unx2t7ef85Tg/O2g+5V4GKclkz+O7xG6HXjvoSoFw4
	 0hGI5IJ8nqgH6eN+GbEUkYJLbhWcQxFFbivAgMppibCqMIcr5xhDn3+grwlKAtMAck
	 v/APXrY4m2oqQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:14 +0100
Subject: [PATCH v2 09/14] mm/shmem: rescan after nonuniform folio splitting
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-9-86a00952acb9@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2025; i=david@kernel.org;
 h=from:subject:message-id; bh=JlceDwOL/xhFvttSFqMpneZSe3wIGnOX8j/++/Na1FI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBTcmJntoTir8Vu6yep283/MMWavN1qorLMRfTr9y
 s6PzpwsHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkdgbDH46tZVpFNvtOM4dz
 idqXsYuZ/ftZ7HpKu8z7N5vQek8fEYY/fLpMDT8PdNo9ufF+VuyOPnOXojKu+6xRexmqPYzKpRe
 yAwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: 5sb8szjw7w5ac4ampetdfcqq8wmghuwq
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D38F6140010
X-Rspam-User: 
X-HE-Tag: 1793106276-883915
X-HE-Meta: U2FsdGVkX1/mjAFfWOdbnATG2WZGI7c+isBSao05Y1Q2AbwXHgq709TKD4tlIJwpCjTCLueZNIypvDmbNwBgxRzkAAHNp+knM04SV70jrVeNP58En/AkM2gx3ps8/u/Lu7gEUkoebaqeBUU2wICIHyNarikuKP4OzslcHAQV9zJjnfyCGyyzCa1BT95CeWBM4RGTfbEEsjAKZ8Fm6GyOf2sOCnFqXYY2FJwfPRI9ZqPBjVvQ06JT12ov+Vah+oaUfFVB8CreR3pJJBLbC4e5o8WfEobn8zCBCpek9MedganBMoezp/+Y3lphNoF7giS8IpkGmcAn14lj3UDXLNYL1mhZtnC35B5vigkFMARTXnJCb59wFCBllIkpojIdvW7vdhqlv+QnIx1tGjdWmg1NA8D0FsYuyuIJ/87xEO2b9ywgmajosh0HEOJYcxgQXpxzqb2yV0eKtmzSedAFTSXMYYFwcC25Qm4E75i2OUaw9rRjwA2odOHXrv1+4B3KqvH/c4lxf8pwMWOF1UXzLjqZinbPtJNUVsjbhBUzxtkKsl2vVysBYayjQPNyZhx4c4YHauIcvDy+7gZnCwGodDUfUYg9IKjtPz6mH0s3xHDtNBk+BhozeYrf5S7rfGXzBac1V5hUXnSGL/DOlToCQufB9N5Y5xJtq7cYsNy9v58WVEFJ4zKvDgoRP0c9lifRJrwEhigf7z+CFJ73XpHxrrprxIg35WN8rD4kXdNDjXxupvtdU+zqPAM8cBHnIM/CWcrZKJeUh+h3r5Onk0YkKIwUqI0nnPhAINVPyS3g4fC4dWFC9ce5/+Esbvnf1azGcAv+rHdly6RosMQv0AyuNKlH+Ks4P7Hf1qMKxrR8JfCkrG/vChLyQli/on7YqKehWO3uBcWI3WzST6VVYqv/6Ne6LMurzflGiwwiF6wdKJFANZtb+efiO5bWCQrUI1X8sOBuuB6vc19bYpWLGuLAnr6
 zcoKWN2a
 p3C/7OIgveg1blvC8jvhR16cWXecBDSd/YLWTERx3VKw/ypyXf6+tFyGP9tEvPZ+DMybuuxVRD9ImZb5NtZZOyYA4j6ZRkU9ABUxF5aosZFYt1eR1NiXYUAeiBV30F5ZhsEpchew49Qc4IpRwt++TbG3xTyucW/HCiUqe1oXq2REbbqVc48BhDT0olTzT38wHAX7nS/AgcaCl56xRQGLwkVCnS+nuGtKrlv0nSwSB2xv8J+t8KTrLyQTs/E2pwttQPz5nvbk4aHA5ZrsdMB1krNox6G70xhHGo0AEGC/HHQq8sS+lfzj0JpqG1lHvUNgZDJhvZm+moEQIZqBRSM1R3tJdaFkPg6ulHmZYlvev4Lx9xv1VTjgDIqFXKkp+B7B/pv0g4kQia3OdIPdr6vkkklVPqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The final scan in shmem_undo_range() restarts after a successful split
only if the original folio is no longer large. A nonuniform split can
leave that folio large, so the scan skips the newly created folios.
Hole punching then leaves pages within the hole allocated even though
they could be discarded.

For example, a fault below the hole can allocate a 2 MiB folio after
boundary handling. Punching a 1 MiB hole at offset 64 KiB splits the
folio successfully but leaves the original folio at order 4. The scan
continues past all 512 pages, leaving 2 MiB allocated instead of 1 MiB.
The hole reads as zero, but the pages and their block charges remain.

Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e6532c9b0cbdf..d7cc45d7077a5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1478,18 +1478,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				} else if (truncate_inode_partial_folio(folio,
 						lstart, lend, NULL, NULL)) {
 					/*
-					 * If we split a page, reset the loop so
-					 * that we pick up the new sub pages.
-					 * Otherwise the THP was entirely
-					 * dropped or the target range was
-					 * zeroed, so just continue the loop as
-					 * is.
+					 * The folio was split. Retry the scan
+					 * to find the split folios.
 					 */
-					if (!folio_test_large(folio)) {
-						folio_unlock(folio);
-						index = start;
-						break;
-					}
+					folio_unlock(folio);
+					index = start;
+					break;
 				} else if (folio->mapping) {
 					/*
 					 * Splitting failed, but the part in the

-- 
2.43.0


