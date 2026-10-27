Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0B3606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y99aIv3d
Received: by kanga.kvack.org (Postfix)
	id 5CC916B0725; Tue, 27 Oct 2026 09:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4966B0728; Tue, 27 Oct 2026 09:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490FE6B0725; Tue, 27 Oct 2026 09:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5F96B0725
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BF14160A11
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:30 +0000 (UTC)
X-FDA: 85368425100.17.0E41C20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4E57100017
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y99aIv3d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOESXTHj7ZHJ0QSzwAvNg5THsJXn1CEoruRa5FHdNnM=;
	b=X4dk5fyoVLWN3hQ1FpXE0u8aH89TYJ7pswITAFeXuJfaIL8Pv96hZ3kmFJMRFXG5J8CpOC
	g5CxlnfpiPAqszldmF8zwjKLfXK/qxh1MjyjKeSnDXQ6mlXR7npxqOA3C5qsSsHpoAP/wZ
	bLcuDJLdOBs+oeHF0uhwK+rdS7Ehdhs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y99aIv3d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106268;
	b=rrAAQFoJTgvkhS16uYaP027pRpHXzfZTir5U3e1MJYdFpCpljarj/0xKB/aXeouLyi1kFW
	l9NlUWOFZN28NRGwwRCB1vulCHOm8CkMBLk0OsDurbqeBoe/0Z4cN4Ib0vc3DDUanjHNNi
	+/SHx+CKteFP+BJnpd/67oWVFoM9vgc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53BB4602C3;
	Tue, 27 Oct 2026 13:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77491F01825;
	Tue, 27 Oct 2026 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106268;
	bh=NOESXTHj7ZHJ0QSzwAvNg5THsJXn1CEoruRa5FHdNnM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y99aIv3dpJ5iCx+yDapSlDEzrTGUQU6aM5QKk9+CnMu9PBVS8s7zcUkvWvFNdbRww
	 e1hTCxxzpD0X1JpZc6hIkncozeWfy25BfWvcEQnvf/qG+Nu32EHm9/50Z5i9JoB76D
	 YLFdfbMkcTbTSNXvB3EvFpZhmBs10lAT3aeetcoliHAEln7qHXCK17cwYyTCvlDlle
	 oltykfwmn9+/1XIXl/kMUPK2DuhUN0cRYIbfJtXQdjFuruPRwLSIMfD2F4a45pLCJC
	 DtnjUkzQULHjKCDN8rJxCFP2fPJXDMUuF8KNHhir/Zx6ZpHnfyPrMryZfhmEIIo5R2
	 L1q+M7lOrgFpw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:13 +0100
Subject: [PATCH v2 08/14] mm/shmem: discard whole new large folios on
 fallocate rollback
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-8-86a00952acb9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1590; i=david@kernel.org;
 h=from:subject:message-id; bh=oPg88T3p1DTSdeYY5B0XA24Ulyfbj8Z+CfGvtqwsdVM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBQsadu8ylJBw3LrBCsxnovvDSaVHlw5wf24Zt6j3
 J1s7Uc0O0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZhIzS1Ghuec3AJcmd9DFnX+
 LNsU4aw5Y+lv9ulqLT63V/+dGeTYfoWRYWv33yV9E2vnfp12TWShXYT+CdlzIW37SlRPhu6KXcl
 gzQ0A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: B4E57100017
X-Stat-Signature: bg1j6hpc8wp7gkqumiuyhgjgue741qii
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793106268-7234
X-HE-Meta: U2FsdGVkX1/PS0BC/6ofZEMH+IBfeiJRpXsJZdCxwYelz8geLhBst/JIFh/m2U3QMgVcCbxzqYjmj+LQS9RtqA3IPBUutMR59/oYZLgaNxLcDuEz8Q97fev72fnWr9CEcz3NBaRBNYVEAwaADqYMMU3O9InnU4Geai2qgsQ+cAFlVCDFRx4243/rvBHxt7fhYyFvR+CqCSqyZ3eSXotdecVjD2YO247DR2zE4I7jnQ+ZpqRCGgkWMkT3GYNdUewrPicizYpGzNYJOGctfUDpSMnSvXfJHh7kGJGMgcGBfrLHsaQkTlzQ8BSJPtsHY8XxWqvSvBhoWa1chcFlClNBXVbCfOSqL3+gp2NuQnC5DOSE7YGSySm7rtO3wQJe5MXM/UhiBCVAzym+qZOIDBZv72lXwPEUsQvJ+8/WpNjh9XD4bvdJ3k1wROqrDrxdsjYdRkyBc2XyJK2JquHOa6sWkoLpPDMd+vZwykHo5ZdX6dY+vA8hN3RNBQ3A16n0s1kE4Vl8182beAd0V0JgYAAewSgNGwqMPdaXp2c8Y1OSjKNl0WIP+9SlU5UVUlUl0lUWuuSF61wI+BpcDa6SGiSyldGDHAoXFlJxaTEYcflqPaLqfl8aVcW+5h00gyvgEXWPVDaAf3hxvu+Q7BZOh52o9mX8HrPY0cEUgBvYKW1fuT8fK7QhjmM4eECy0bkzSAhq5d1VsUXc8Zc+MSdlmnmai9bIalkuawxRj7yTCqw2a3rTPahKsGnLNofLKjJVRhPD+Kn+s/ZPxEyf5x8ZawnFX5VSnnn/IR95wPBScsjNh1aGFDKMzrCB4mvCFdFl39+UVwz+xH0lF05U3lcdXlxBSK05YE3lwA2CXIABXNumQU4ftX2WCmj3Vhuj+6J7TGEB6Pgf258ZA5cdifuCH9KD7hRVvKzKYeYW1c3mGhpiv9xJG+o+EG9JlvsP9THbuKPrtn5tYBmhQ5UasIPvytu
 +oyeYeYO
 Q2mXmNEUII6sd5ghaGgiSVVKtZt0vOWLcesDOZ/Wxy798KjWD+swzL98eK7wV7sCAd5GfRNb35Tvqep5tIs9gTFpeHGBfHWwC06onRX25TS5BJX6xcbbon1QBBHVedO2D9lhgqEbU/7MjMtbsFKApF9DddEX85ymmEn36flKP1Sd188w5tvz0xHE5cDpDc7QLltrjWLR/YC9z3mNwa0fbgffqKZQQiKCwssA9IMoGOYZGpXEy6HmoKofdPB+ptyYahUDbYG7KpI6qvecxCWAdmryE/WcHP2rWFHZHKb//sGa+hgJmhZFd7gUFp7SXeYYUcy3ci3mrPHRkp7jW7jgNTyWjOz5NqN01+OMA2yhwjphHPzqXv6jeR0khwXoPyD7wsli1ZjLRY/Lb7+cLDhCQNCAnWT5lncNOuabqGGqxf2iFRpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When undoing a failed fallocate(), shmem_undo_range() must discard each
newly allocated folio. Its second scan instead passes large
folios to truncate_inode_partial_folio(), which does not necessarily
discard the entire large folio, but instead tries splitting it to
discard only the requested range.

For example, with huge=always, a failed allocation starting at offset
4 KiB can leave page 0 allocated in an otherwise empty file.

Discard the whole folio when unfalloc is set. Note that we enter this
path only for folios that are not uptodate, and can consequently be
dropped without losing any data.

Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b615301a311e0..e6532c9b0cbdf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1473,7 +1473,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				if (!unfalloc && folio_test_large(folio))
 					folio_mark_dirty(folio);
 
-				if (!folio_test_large(folio)) {
+				if (unfalloc || !folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio,
 						lstart, lend, NULL, NULL)) {

-- 
2.43.0


