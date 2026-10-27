Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D66606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BlsEmssp
Received: by kanga.kvack.org (Postfix)
	id 447366B0729; Tue, 27 Oct 2026 09:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41E516B072B; Tue, 27 Oct 2026 09:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E576B072C; Tue, 27 Oct 2026 09:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF4476B0729
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DA35160A30
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:46 +0000 (UTC)
X-FDA: 85368425772.20.444A79F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A8EEE14000F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BlsEmssp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nb6ulKqUTsolCYtjvAlQUATxpl411nI8E+8qSyC/Ov8=;
	b=ai9VHs/P65jYH4p6/XAisc4FiEqzatq67ruKcJ5gkr9NXA21Rb0PcNme6lvmGuDXK9HVhv
	uWrcygW5QfNOvwwVaqwkHp2ZHN+SgpYVcTOGKlZIyI43f2ZnfJioVp9NufjyysLEgcFXAd
	JCfSwWJChhR/JHYAIa7DbH0B/mlFJhQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BlsEmssp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106284;
	b=3kMUkdnzkbfge7XD2HzR5hcKntka+Y2jUb4ncs8MLKe2xb5GG7pEmBIhRxzraP6raqpCU2
	EPxk28fZ35SyzBLg2ln0OKZdrqaA8WHT1lmWIFD6QPeBf9nNKqYC7zKr5ndqVQV9cKBp34
	qlNp/gk2KgQd/jQXJCxrnmmSdQ0XCYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFDC843EB7;
	Tue, 27 Oct 2026 13:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9211A1F01825;
	Tue, 27 Oct 2026 13:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106283;
	bh=Nb6ulKqUTsolCYtjvAlQUATxpl411nI8E+8qSyC/Ov8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BlsEmsspTFSBsFErbdKXC9JvpvFEKjCcH9BZLFMRRF3mvn/GSgD9HCaxeKzjM9qBv
	 0BZgZuo+lUkJxyU8XGpDYcvv25jWae/iTq64VaorcVYWIxSdgZqOH95rO8UwlQp8Pj
	 MoY7xpWTwuxbYRelLf6EvLYRH3mQzVZ/qyNRyMBB2W3AYXmyA7rcMmOWcNFhtcagMV
	 FrWJ1CxPRc2TWrea0MSz4275A6pS2Wt2sIsFyjvjtHvK3PBBV+5DCPlkR0na2puGkw
	 WSq3xKt1lwC1fhnocAFKiEk/j+r6qW/YYT6ItHtQF0hZo978mixQ1wLzPyOar94uvo
	 XPzvVSLawy2Mw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:15 +0100
Subject: [PATCH v2 10/14] mm/shmem: fix truncate hang in large swap entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-10-86a00952acb9@kernel.org>
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
 Chris Mason <mason@kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3893; i=david@kernel.org;
 h=from:subject:message-id; bh=IxGpYqkpOrH6z71YnOhyt90hjS7NavWmximCNN3fY0U=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBRk0fqg9XiWtcSlbQ3W/Z6cy0LzkwLtVqy/ZMrPt
 ItbI3BnRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABOZ4MLwT6Vt45szuzV/N0n7
 xR3od4uSL9S6tzdBfkf0o3/ZsU/fVTD8D/gVl/R0V7Nj1h5NwQc3Xi+NEZ/yVyBG0WjxZ0XhbU+
 leAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8EEE14000F
X-Stat-Signature: x7osih89r85aasx19j8zd3ktc7px3gyo
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793106284-558632
X-HE-Meta: U2FsdGVkX18IqJdxtcxDK/QIHLZNXP50xYCM6LZiUwDaWHhcO1jQx7gEo5rkp4UmAXQPlIOjogw7quqyWLtZvzuZaKGemiP6JSZ7Ih15Ai5eD0CjpfyfE7m/3Y5u1ChN3C/lT9Qwqb451AnC0n28NUu8HRzxtrDJSUGrV1x3DdZEamDEp1RPU8xTSSmO9+2j4ffbcfI+tTVCeMplqix2k0dsnqwAers11Cl2UKIjFI6tXiYAtqQfIJaCtrhT6f/qzKcw9IZOnlFmJgDXryqZugeXHnEIE2fPrJagxbt7ERXiAO83yv+/llEexlIFoB2jC4tDFEfm8E2UahxzzNtG7mXUBGXpHsDqh87i4JU6Ka9WtBeoo1cgP9QFNVg601lj00xxUWfRmYMMqZLolaqGuS0XsOtT+k7dKcKztua6CPDyG0YbcdAGrQzPn59djnIbIjt55c5ta1SQrJKVvuNghdwx6dv0/nsTO5SOHjDtF0NJmGK78FId/zR06vlPFdapD3Q1hMIX6TNXX3jonr3dZLdJ2MQPCiwjNQqQt/rrtEefSKfau4tRRiaMJaiGm+t2m/JeRYdjueOSDTr+WoVIcP8WyoKAennJQzymFGDry84CMrlTvf/r+RCDjMr1P27K4WozWSKVwdwT4ZADYG1TH4Sy7ketmd89Z2NRQkkEs3vOQnsmdoF/+W7USRNxKdkNIFezgOw848M9SIUfhCHIaLUAkF9aMcmPt12+BIa5joCcZQX4D1w79iPxgC1EbyiRHKajUsFpsB9ubPkAUBkwTY3fwuX5UnIqxPJI9Q6yi3on3oq6OZPS+B1ShFmyW3on9GmGzhn6vZ3n7H2DA1JPa28ZsSid447I5LUXxosg8V5EqBZUDZmafR1u5i3+B7WwKANx9jp8UJbNslKiAvuruNDzoV1KKrU3Ya0ptUFRBeFijdGvQ5r63tc7dzjHxf89rc1NeUQLU+Cr1d0ElQv
 BbSchBgP
 MlwLPeK+/am0/XkJhVkFJXkYwAwGgf6RQAUZZ48EHpR90cx43BC3WfoO5de2RZVTnhy8OjpAy7Zo7lqKmayb8jCRYlzpl0QJdlDtlXegmPNxafLOfeQHKjqSj/kB/MRn63KKlUa2rk29VS01wsSsBw/22jAjOdZwwCSm9tk3sTrEtMc3eO+J2wmtETKiHFtwdnfcbWv0a1SQt23H8toR2cOP+IlwYlvvMw2Awo19koVMr1az8Hg2WzTbqqbcz7DOW8/LKvOhOgDb3QfEPWjTAJ2ILY5lM1wT6bwzkxOgLfli4Y6cUTPWLrJL7wIGSK/Y5vYDyYngSAVcf54NW8bMAfTL/yoiIjGHgeqF7bMLKYHLvB1aRJNsZZd+YC79xJeQvExVu+BnDpkDAufC64lUUi+/Gkw==
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
index d7cc45d7077a5..a538b37fe739b 100644
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


