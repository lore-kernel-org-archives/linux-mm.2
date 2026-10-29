Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04858606A325
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2BwoQyu
Received: by kanga.kvack.org (Postfix)
	id 2B1846B05C7; Thu, 29 Oct 2026 06:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287EB6B05C8; Thu, 29 Oct 2026 06:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DFE6B05C9; Thu, 29 Oct 2026 06:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF6826B05C7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E353316036F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:21 +0000 (UTC)
X-FDA: 85375332042.04.9163CC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1A72B4000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2BwoQyu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrlUP/ZvlGc5IBrSE/vc/ZS/JIkQTUYQoM3NoqrkTR8=;
	b=zxRROKEIiGES9UK8Rtu4yb+o+yThBtVVjWfC3wynl1yaEb+qNUJ9prjjUNLyegXKjFHRwb
	5n4ydwpVYKtdf1SzBKD+Y52fkaEC8bADXdNfeo6Kxxc27CNyBfY1oOxl0EKjtO4TcJXfTZ
	UgWDGa25BaxiIpS0cAcrjtRKmhO29i0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2BwoQyu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270720;
	b=qShHQ96/LunSxH2dxujqdVTSeGUbZhQUvs23TqBmDu4Cq+61oGLJSYWRzNWDXI7+JpDRDm
	Z7UAgTnXSya7Bhml3Niq6LSUq3DYEjtu6sz/mymBm31iPLedc+vfgOizWAhv3Zy9NZvOhi
	8iLcJ0xuJ8q7B3F5ceD7yd8nflRTZlI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 522D9437FE;
	Thu, 29 Oct 2026 10:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139701F01825;
	Thu, 29 Oct 2026 10:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270719;
	bh=KrlUP/ZvlGc5IBrSE/vc/ZS/JIkQTUYQoM3NoqrkTR8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l2BwoQyuZ+oF9QNPeaUtnWV5JSntj0e1vnoMQBz9wns/uANzpXw7Tr/H7GxNGJAou
	 EJ3yltUb69l70g1tRQaxq23O/UcPEO596qNbfLf9EtT/maRPt+XEefSoLxyJzd3EDz
	 tz9Euv9VyogvCcpFTqGzxM2EgF8YKi+kO3QjzcLbhUHPSjfdzu3rAugJ/RP39Ej3dt
	 7ljQogqUNosOjXEdOGU4/KKtkqmCm7VWkJLZb50V8v40RgMsSve4ZKwBzpP0D4nJuj
	 5wzv4DlbP3V7trXTjfTCRbbArmokLuCQ1w8fYoo8KTXOR1SiJE1IAEMRzPJGTJtwCy
	 0JvIVHnHkAWdA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:31 +0100
Subject: [PATCH v4 10/15] mm/shmem: rescan after nonuniform folio splitting
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-10-392fc715d8f6@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2061; i=david@kernel.org;
 h=from:subject:message-id; bh=tP6Y9HYT3IriJ53/PLcZLnjGjErO+gkjaV3Q3Q6DoUk=;
 b=kA0DAAgWx+nLGEVVu3kByyZiAGrjI1fINc1XMBrtRJM6n2JK8MFsom5e+rrEFGq+ePjrl0nN2
 oh1BAAWCAAdFiEEUlPfMOnprn17Rg4Dx+nLGEVVu3kFAmrjI1cACgkQx+nLGEVVu3nGMQEA90Qz
 nbS+Naf5R8v1aGtwlsVKdAZnBenkSGX3FleX0DsBAOYu6EUj3/6SkGv8L1zOlZi620h/DEwmOqK
 90KOkVQYD
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 1A72B4000A
X-Stat-Signature: uskn7mstn1q93jrespk1isbp54b9zruq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793270719-794677
X-HE-Meta: U2FsdGVkX1/AQNgNiMbROQUpTbmgZI4dFvbSNhDEQhMVpyUmx5GmEyJzg0ubIGEVqZutZvTXnmm6N1BnFHMmFt79Jt+ap5kOOK8NBJ9QmiFt0KkGSADn2wFBpdFJeGNcnpLstK0zoVrQbLMVEwjbtgNcwmugHPduE1MxIhRlqmSAcJjeQtvsgUByfmbJhKAywE9TY4eDLPPfVmYT3LsUg/kgvTAYUSG5MMI/KarOaWQJJxbL2pU+t5cHxGZnSX48zHXP8bDsGfgYmL19TKeidRYiRMjiRq4xxFzJ5o1dsV1ZZNsPMwgNIDkdjlQLvY1kjHDD1dm6zxUjdgEp4E84QxpNJ5Wg5nVf9slPh8dIlWw8QJF+QMF17y2Lo125189yRZI91PLyuRYL3IUUNDXQSArhKCeH7TOdRPDxU1GXaPgFQNp2inPTfoIQf2lX9zT0Ki7WtsRgKpc1Mm03B+c4XZFoOH5h8sBGQmtK7DgapkTBARGFLqCzXsycNkdZOpgOKSKD/NjN0ZxyxT2rhKBXBYXOd0UNZgJl9QSbOxymFlY7KEBuxT9UlUcwSDYLwr8rc6YSmMP0xfNTltsNgFR/es8ze0XdTVx6bi/gvfjKAyaKlt/uBYhWvXhGxtvI16XrrGtVy7/Xz8JgFTLMl3HKywWUgI7cc0xqQDTmibWNhYmZ1EH5vuwC24Z35vWYX4g84pnAcY5ZMRQ0MCW/UPMtF0tO13Z6YocXvh0Dd7jEYkJCccAmllKqA6Qpl1Yz66ZJKbRX3zaQuCxZCW5Estq416ZhFIpVmz25DiMPBtJ3mW5LhtVxRu29csak+mmMWO39GAb/STqtpash6rmBThTeeczPj0GghsTrBXvsf6JZcX8eCvVAXseORUxEqK8qphl96xToMXVExa4RD8hWublOeVnQJhz8elgq9intZbSs9Eojf7tJmtxBVlkCG1TKcym7sJs5OfPh7+KvMP1OoRL
 y6pF+hbu
 5bwu3XmY0s6Mqb4JO/65NhsAuQvM80c90omWahBzObHPiLqLxDJguv8HC+OxUeLZ1pQr+28nhvjVjpX20A4h+gPRB7KYK/i12aS1cCFJTOvT19VOi+rMrInLlB5nyBQkzZIbnznmJUoraFWHiZRpR7y8gUJy6j12maZMwi04XfAJnEBAFLSO7LlXJnwmm7yk9RKYez5owngt7pQywGv/2lOBqy4vYvhVqgRo8WSIteg88dsT6c2NjStrKT8rewz8WYjEZE0zIH9TLDgKOAR35vw/CG3nQ5JlYHGdT/EgCriFsV4eUjtUX/RkvZLejUdzWe3Rrsv0+cKaev/ZT63KGbPqrQPQH4QsM5CrjxxUbwEa0VyrkiGTVylZjAOE3NYAtJUe8faKhD0HJo+l4QA9cN+iqQj37UmD6PWBzU4loEJSZHRs=
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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 151704b2091d..e96dc3beac95 100644
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


