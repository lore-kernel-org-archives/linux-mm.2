Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175C8606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLE2cbyM
Received: by kanga.kvack.org (Postfix)
	id 2A1A06B05BF; Sun, 22 Nov 2026 07:42:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22AD96B05C0; Sun, 22 Nov 2026 07:42:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2FA6B05C1; Sun, 22 Nov 2026 07:42:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD4456B05BF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:42:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 507821C3FFE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:42:51 +0000 (UTC)
X-FDA: 85462719342.17.C813BBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8BFB740004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:42:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLE2cbyM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351369;
	b=Omf5p7kB1JvKinhrX8OiG3VdpI29JxRI6gsexeCTJ64aspwPlgcRel8/P4UKYAzoHP7VlW
	+7IQdB/ZbCXTWOfyS9CSz/nD4yso+rHv3du3itHgrc1LXPVU1JuyIAl1c/oYFCDH2+YlJ7
	bBK5OSdhwHyq8SHK0S2ca36w6ca3LPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ppxr18V13ksnrm9EzUd2RjXo/8ry52+v8MzRoDOJVzs=;
	b=KDvBZ2me8ntJ3c0eqc43NnPdLzReVNB+5Z+y5+icJaETvvOIdXKhom/kiFFNQwFJEE3org
	Y1ErA5LlWGhaesxnpCfUlnIQ7TBeXqwtri3FN+q3YjQqWk5YryQNgtMv/R6ZVoRVc4Hro+
	gYkwwV3oNLUchDdOSp1Xx6AYEABcc1E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLE2cbyM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07BDF60F4E;
	Sun, 22 Nov 2026 12:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7437C1F000C6;
	Sun, 22 Nov 2026 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795351368;
	bh=Ppxr18V13ksnrm9EzUd2RjXo/8ry52+v8MzRoDOJVzs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OLE2cbyMVO4gaFeDzqvX1rjr+CwWSlQzdzRcoUhJ9UbdgSPvZax08+Xvn3jz78zV7
	 R9sOAJqcGH8oycehCMl8I687bz5EppKCoHeKGT1Wblio5u5HW1uBmvYPlMoeZ7sOm9
	 ca0vwXQgPqdPoiTyvxPvQvAiURYhgYROc1SfgjNiacb8s/AGE9yVL+D5OvMdABKyna
	 7ykiswr7+k5AJiwAbIkpbIrA3CssPlAJtGcGaUpGiWQUf9ilvOEX81DwO2TJWjkVTD
	 oxV1cKAdhZWUaVAVv+ivw0bQ/Ff3NX+6gO0zA6OlQ8pKne8l42rk9bR+B03JfIxFhk
	 WaEWXzJpElNmw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 22 Nov 2026 13:42:17 +0100
Subject: [PATCH 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3379; i=david@kernel.org;
 h=from:subject:message-id; bh=dIRn4KbtPfU2Ckte5ZbEP8iOqeN2wNX4jIBv2nXxLTI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKZHpvOMGjcYrCkWGTW1eSItc4TPISVq6SOPDkr8po59
 cGCn3F9HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEwkvZORoX+BeADTCftzi9me
 luy8rnjkz/3Q+LsVD/0fN3P0ClfFSzL8DzFj4Pp+NrW/9TL39u/KfU+vndFWT+2f5D/j0pQVh1J
 vcgEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: ywrr3hjhfw4n664ty6w49jcjjdn4eqnd
X-Rspamd-Queue-Id: 8BFB740004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795351369-8921
X-HE-Meta: U2FsdGVkX1/i+ixKZ516TiRaeRFQu37exPIoqrAW4EuGOuwS8Q3KdLmgMo7/hE2gxPGrQ0NBj8MiL8YNNmBpdesz7MF/JA37d3GL0kiqQ10cSyuf1vhkdFYX84E5ewCHOvQ3lIDAnzHiSH7Lte9y9u7UQedBGu1RbHOomeDlMqSbiLYG4lJdk0Fwf8S0CJymeJ+lvYIM4hKjA2Z8NJ/GuxjSgsVtwAC1ZuXWfZNJcKHwVM8n+zceRaaZ1lw/o4k1NhpiYX++8Brwvo6YLqhUzLRyluJY0uj7RBqvs6VBwM0Mwogsy6NjdAa9h97HKS9eK8QXF4IQDw5V8KopNhcPLVACzsR6ZTMGMejID0sZPsLHWSI/2K8SfquakHGDBVRorTyWs28ZPaaBMDupxGH5S7rvXjny/+/DZsh0T8HDerrkxloS79UtXIgMPDnluylV9yigrpGo1vrKRArOcR09TA+2g4b7AWbnI7g+U1YvqStXf5+vTqb6Xvt6/V93VAGPAcYZ5Bgm9VJ1Jk3JnB71UNBKCXTMm4eBDF8lWRy7cEUUIpU+Yy1H9fnfDbLhI3Lsknwi9vSzOiblphqqZnP1DwdtaPh6ONRZtntCCGweG5BBP7K5BF7WSGVhHh3KRSR2uH4uHAo7CaomPJDnmi0I3OlMZ0JFw4293bVrMtlkzbwXOUGirfzmciJbFRQvoWRqcO68tJdxT2U0E9TJD/wZD8GtAxF3ImgZeVSJIhjgsJ7LVzvwl1KcG5KLhfW5qa7ITZbHirCU6PijMGNtyeQ5y5lCeBGdu7sfj5JsM4JLxYZhtFjZzROebIQfOoagck/AzRolQq2kaorW18hS/iA3tqGFQyv6tQnjmUh3jFy7BdigQQAEwjP+fDUQx2pwagFIdTHIylf9VzppXyw8mqrOa/taf6G15EG4Gxte33KQWy8i4b2ZIZJ39NOJEp2Us0xCT9zQ0E3uEUSLKNekpg7
 fEw7Ubw/
 DvcItU0YxyVO6T62QPjOqLhZvPQFyYpDJrIC+hhbrevNAdgbRaTgCMlldzwKv5wD2qfwARV0WIKq61a/Nt+98F5ATahi32LS2fqy7uALr7WZREeomeJLNEcOQ36u0dUrn4lFYP9IeEkWm2kZRKfl1NoNCT4LtCeaelI51zpMAflQPxRDJ9gDXNJL+F6ttDFgZT39OgW4F7yABUSGUfs1LgI38UsgsHlFDNw7Aj3RhtcbpEAx2s5Kbb1OQDHeQ4lCD30rW2TPoTbmiJKlyYWfnTsfpOqL0H9vlCm0yMpozkWY5zSvmtplf8/snl2LXfy3ZrnMHQT9tQ176tikQpHVWmGf6dxMTqyTmV0PPhBLhjU6GdktuCo6GDwzCKCSJmaKiIs4mEB6c8CDOfaa9H17PC724+rVilZxwMjaskYH8UobFklxnkhGTs9GRR7ZmGG+Eka+l2BY2bUw1Y4CHqkl8+ljDKcY4VZgRbydWDLekb3v1KVovW2rWJnXn37PlNZ0AMKOc77YQApN90TAVFStyAlCfOZ/gzkKisbOkH9Y7YzYakrsUfY1hVFWsJuFVC9Bifi9oB8WZYw7Gy0hDzLKr7vTuyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various callers (migration, memory-failure, s390_wiggle_split_folio) split
locked folios without holding a reference on the folio's inode.

Splitting a file folio might allocate memory for the xarray and call
filemap_release_folio(). If either ends up in direct reclaim with
__GFP_FS, reclaim can evict the inode through the dcache shrinker, and
wait in truncate_inode_pages_final() for the folio that we hold locked:

    try_split_folio()
      folio_lock(A)
      split_folio_to_list(A)
        xas_split_alloc()
          try_to_free_pages()
            super_cache_scan()
              prune_dcache_sb()
                iput_final()
                  evict()
                    truncate_inode_pages_final()
                      folio_lock(A)

This requires that nothing else holds a reference on the inode, and can
be triggered most easily with FUSE, which evicts inodes on the last
reference.

Further, xas_split_alloc() charges the XArray nodes to the memcg, and on
cgroup v1, memcg reclaim waits for file folios under writeback if
__GFP_FS is set. That can deadlock if writeback waits for a folio lock
that we hold, for example with ext4.

Let's fix it by splitting folios in a NOFS scope, so callers don't have
to care. A NOFS scope also covers allocations that filesystems make with
their own gfp flags, for example in filemap_release_folio().

On NFS, splitting folios with pending writes or ongoing writes to
fscache might now fail slightly more often, until these writes have
completed. On netfs, only folios that are being written to fscache are
affected. All fairly irrelevant.

This has medium urgency.

Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()")
Fixes: 789763523fb4 ("xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e22daf846dbe3..c4f6c642c2620 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4425,11 +4425,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
+	unsigned int nofs_flags;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
+	/*
+	 * We might not hold a reference on a locked folio's inode, but we might
+	 * allocate memory under the folio lock. Direct reclaim could try
+	 * evicting the inode, or wait for writeback on cgroup v1, to then
+	 * deadlock on folio locks.
+	 */
+	nofs_flags = memalloc_nofs_save();
+
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
 		ret = -EINVAL;
 		goto out;
@@ -4478,6 +4487,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
+	memalloc_nofs_restore(nofs_flags);
 	return ret;
 }
 

-- 
2.56.1


