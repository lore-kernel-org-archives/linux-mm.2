Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C836606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KVlCpRC4
Received: by kanga.kvack.org (Postfix)
	id 821536B05CC; Wed, 28 Oct 2026 05:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F83C6B05CD; Wed, 28 Oct 2026 05:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E466B05CE; Wed, 28 Oct 2026 05:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 514AB6B05CC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:56:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D362C160C4A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:36 +0000 (UTC)
X-FDA: 85371580392.25.415B6B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E7A7B1C0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KVlCpRC4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpQKMIScdwv99hbScpBFpPKjgrSYaRWIk51glHAK3ic=;
	b=pifYgIMCSo4cruhpUqoQ7vumCEpcgzhAaU2J9TKGYu6DYa7xnQnjaRFOJrDnU5+DljrpRd
	xZUVXQMIqPLGikEk0Ggec3Il5/93nbtex+RLBv15JfRiwkdoxKaGo291M3zA4sbl2RBnXT
	iP4W6HsIldRw6Nq2O8H5FdnT00HMzoc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KVlCpRC4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181395;
	b=8HDe3mA/hgfFS7x3JGlZHO7qevo0lgUxa6WcOEy6EozwyGvTocTlG7m730bpHg/OQsnWn9
	wfiAxjFxKFekrCurr98CTCpLkQxsn8E5hNruaCLF7elmCjF4Akdin1zRsWFa2c8e25dSXY
	jCwLg0LF4Y4FZMFCEeG9f5p4O14Pa40=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 157A0417AD;
	Wed, 28 Oct 2026 09:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1A61F01828;
	Wed, 28 Oct 2026 09:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181394;
	bh=UpQKMIScdwv99hbScpBFpPKjgrSYaRWIk51glHAK3ic=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KVlCpRC4pPDvzt14w/q6r/wu9YQhxmtTRLuznofuu9N7qNzGA5TxdJcmnH8nwXvtK
	 fvGF5EyTTGaExBLitX0GYu4GX/XLiU+rMW7gHDLzHuopK1s3KY2pDv9pomoYMBOtI+
	 aYbeK9XDQ8u5YH2B1SM4cwcSuad9n7vf9wlbe1AnzqqDuTETfoYengg6AHA8mkMdFF
	 bODJ8yxc9iWsF0LnLU/t/v6WSC9KMVj05yRKFTUcIqACpsc6PQUDBxk6U087yJQwke
	 Dn3bxFrRcgTsp8jGc/rIJYpWxKPDPDVwW+lBFhs1wpn1K1Mrdv69QxWv2ymW5AiUBx
	 EI6000wh4vNqg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:07 +0100
Subject: [PATCH v3 09/15] mm/shmem: discard whole new large folios on
 fallocate rollback
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-9-4ce3baf2db4b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1588; i=david@kernel.org;
 h=from:subject:message-id; bh=Sh5xSudJ+Tjy3Mzo9v0zjd5/Sixygz0g7QawU3O4JKM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmtibV+VuPlJ+QE1TZlEC37mB6m8+nEzmjxTXuxQq
 /p1KtW5o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIlITWBkOHZiTtJavfYdfIZc
 y9c0Clavvfpa1v6xc6Rc/efw6XeCpBkZHrJeYPgbn2a56ln/lQOFk49b3vsf+nOqb0p4RKPyIe4
 2XgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: E7A7B1C0002
X-Stat-Signature: arocx4k1ay7tu5oa4t75h8qf4d46ys7w
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793181394-261799
X-HE-Meta: U2FsdGVkX1+4NdSYL6+jwrcjdzdyA1cJU+AKxKwnMp9whxhNwmyrJn5XF35JKcuLhSVfedD3pZI3k0jn95xg/4WFBM+hizUbRzsx6+lc5H4QsikxwMlo+gHjoTjGA5VQZr/1YCqCa4ozZgTzDO9HU/qahj0YU7hQsyVNldShkHHiAmonlIT86t6hQ2NqmD//Zv6moJnZ0eVFF8Hvv9qmlYS/GWZY5joCNeZAZtH3d6d0bOwiJ1nCvrHbfLV3W+8N0W+yOo6VFf1Zo533jX9ds5K4D25JQMP0W4iMb7I6oQHhzY9UguPpc+7abUpB477cFSAtiNu0iC7HJdDMX6nBdZUIIMtlLgKzv5yYkv9ILn2ik6iawpv0HWVRiWgvnERMACRBwKT7aQJcIlM9UG9dTXxmCshH6dpUw8QGoqHtg0Ak/HlTn568H7asNJejjI8Z11q6tAAGREEzx8hBXCgA8CSMG6upM36kT7W10E6cX/os162B2Jsto7VWk3+DVBcukqD89ijpe1Yau/iHr9MXl1J8x9iEKGUjoti2qbzDuLTO+cb3YhCb4PzG0diKfjhP4q44eYJoqpBeH3LY9lbjfK+vnQYU30xi46zzB2Iu/J8IpoW5ergC4/A0kVCOh0MyPgijfu2ZL9ccbiS2kgJvBn9W8Qm/UlT6R4ep+8H2GUFxmynG2ux8yablO0pl+7mW28kztzKaSFrSKC+IpMgyW9+c8JTPJLJ3izeYMTRwbPxYQ65B49tAhwiZdm7kGgKwhOu42iDiiKiIS/99TtOrjGaiSsahyOQ5YTo4c4xM8jtu6USNbxN76yE2lj2RzXmvWTmKWI+AxnraPAtfyEcMXlUJ1pZxGOr7bqboszD6Jy8w4hfP831M/Y72i9+R0Rdtk5mT6ggpG8rMJOBH683W2S4F6wgBPjnSSSu0XGUMYOlilmTTzupL7vuXtAT0qKeRAi0/msPTHqO8570Z7dr
 /5Sqg6Zy
 vhtlofdYVFLTOaCh3hHgC8jGKXsG/+Q+tnKBM2jqv8bc2iLl0k9ulPq30+HC388S3m7Vku+8W8VmxlQEx4/JPMmhT6ExR04h4UnfCzsaw5kfsKgkTCJMieHh3e4HdSE2bUODcsDbNSMqzXkPLRofvMOG6Sjg8s70Si7crmNq3egQT1p9J6orN69FXQ+uilYVlTS1/kQSqAy/lX7R1FxPPI1HJPGeA45ROtyvEWn2vN9G4HwLdfzA9mZMn0gdQFQqiXWNiXmoyV8/GkQWNM0GwgHI1lnaZp/F05ueE74IglmoT2MWNjdxGTGZaL5kdPyTJ3/EnZNeVtEbKubMMlRRCZuhFiOEl20Dnr3ZJo74/wrZGT0ZlkqVItoNmNWCPLWUlxTZYnVZ6yYT2u5oDzojrvFnCpe6eF54zAT7HCrzqMoaSA68=
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
index f52bab8176d7..a686b3d77647 100644
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


