Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B538A606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mpg1UtT6
Received: by kanga.kvack.org (Postfix)
	id 9192A6B05B8; Tue, 10 Nov 2026 20:56:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDED6B05B9; Tue, 10 Nov 2026 20:56:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA8B6B05BA; Tue, 10 Nov 2026 20:56:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5B46B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C668B1C08A4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:12 +0000 (UTC)
X-FDA: 85421172984.05.503DF35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2751C180006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mpg1UtT6;
	spf=pass (imf16.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRT2/+R9YmYPDM76NCkeURQmSSsjMxRjRdu/RF1CsXY=;
	b=T+8suidkH1goEYTirAEdqiCt304Y0rVa3WDAVAOBegINs4YL4dvwV2hNOUelFg5DNFLkrF
	grNXfTHCqMxfi1F/i0MSK2e8Gu3dMCtnDlfq4Q4GpXN3sVIRCwfJRUoWxMT0jVefsCTVw4
	U3/0mwpuUbKSoSPDS4/6bbDcUNawyXU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362171;
	b=Q5OCyXTuPM8XZKe7L3R+OMTvGrvXhhKD2vhqRQMFUh3+rfq5I3otwGgbIekM+55UD8qB7W
	jZqKGppR9Bd/NdBy/n86GAXjzE7bvrZSH9Vj0C7PVGWO0qjB/PE1I490a8/6p9znh6OsZ9
	IIntnLiIuAAdRNdVdG2saeFZmkSdOWk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mpg1UtT6;
	spf=pass (imf16.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D40346B24;
	Wed, 11 Nov 2026 01:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3341F0089F;
	Wed, 11 Nov 2026 01:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794362170;
	bh=FRT2/+R9YmYPDM76NCkeURQmSSsjMxRjRdu/RF1CsXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpg1UtT6dT9eaqV2X2DduK6rF23aTMOHShI78LRfsnLuawPtMFs+v3lyxU2KCkAzv
	 Me791F2G6OqP0+tNofh5dIhQjU2I8x4j48StC/PnArlXUL/VzochcCJOCszw6Wm472
	 9AL0zDwr2YKGUCkdvckAvakA+O8RVVYaUHZYALq1+V5ypxDT84Q0VCSX374JY6a9n+
	 zAZBylSQOUTdTw6NMgTTdwWCVppy82x/DsFM0wZ10scUCzsQSpNJTNLBubLJaUycri
	 /XEz5ajHgnclAVzbO476rAjiQ+hzBjOcOBCgmKQKR8kpK9cx5wW7wJAgTC2voK6HXa
	 Z4De0bYYEVmdA==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v11 1/7] mm: move clearing the dropbehind flag of a found folio into a helper
Date: Tue, 10 Nov 2026 20:56:01 -0500
Message-ID: <20261111015607.46338-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261111015607.46338-1-snitzer@kernel.org>
References: <20261111015607.46338-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: x5euw4qaox3fkdd1rih1imdf5bndx64t
X-Rspamd-Queue-Id: 2751C180006
X-Rspam-User: 
X-HE-Tag: 1794362171-4502
X-HE-Meta: U2FsdGVkX18ID5XFrj0KqpH03jRAraC+NdVVSfrPfyF8w64/3z4i3zfoTmoCFcEdIcwPm65/qdMYa82AwpSRXdQDsEYsK4qr19ei7awE9DUgxllL3nIR+0JsuGDnnKyv2aMeWE7m/uZkOwUSLJQ7XZdhc0Sjm/fv39ARQ3lPOfsjkx1Pm44S+7EuaO/6PL5l3PBrdHDddD9ZR7k/CEptkZY6xk69q9aEPeaTlXiW97/ZxQQecwWfMcczjr1lUDrusuqEfJley23+idApGeFuo7NqUXWnFc1tca+Qq6joajgAWp2CYt3klfOwmij5MDLha4UdyW+wBfEsmVtMIFd3h1eYVZdNcEdR8JprEd9A2Fz+F41qnF8eDssdqlfOERy9LNDfDRwggKga5PlvVvo1JUQQJ0m72H7Vwqaj3Q/9xmt/HaPslzHaFMFCFAunoWIp9RwXTqfN/o9LlzY1cQS8uMn65rrt71dSIHo9PWHwGcOvP+CP6DmBb5GhqPJyZVufQHy0D8i1GbUQfYdGNz7LaWzRb50dq5gYLeMJlKn+YuuHVsSfKuK1J7MA5v0UPgne9EHPl/JJdiH4Ipz+x11wNPibQn92FEuzvfYf3xBnShzzOm4nfiYPiMOljcaABjQq/Kf+MFyMBsX+cXQrmXRmsk09l8gv9O/ZiDN70KdfS6ggtQ8L+ogkNkfO69yHTnikJsYdkeVtMegWUz4/9wNrqoD/dRRZjpIbF5ZzT5egpSfcqeJN2rszIzKNgxdoRbUVD+TZoFIl0OZZAEVcqyE2M79MTXQujWAsrrQvzP+a2ndJ353iex8LE40hF5EHfH6dARFEcCSZHZkAnLy3pqFnf2bulWNZDIVkU8oDo5CYcKHwyTg7d951NrSys3g7MZ2bkGMKDtz++ZV61ZOb87Tmf7Mix/qncSAXebV19xqGwmKK7bWccgHryuxd5qPB/TAvr4e0JYWdQU1fjCx5XMk
 /OS0pbV8
 Kqe1mUSWvpfpI1aQ4fXVyJXDB9HrbRepGkwxz77ip+DhnPEjLjGOT2pPszakL4dht3Kqml0CjjWxkMOZ0Txtok17UWXMoSeGziEAjNb7gCi0y+AbbH2j19DpwY3ESpbvHOa1JlO/cHUbebVXDkADK6rLTvSjGrRgCk/eC67TmJj1jHNY1/EO28qRZJLT0O/527APQlYLOKpLU83aLGg3pgX2nC47JEk/g0Ykdn4rjZPS33JhLUJWSMOBpFWoI+BRdc+6DBsSl1wO6jrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move the code in __filemap_get_folio_mpol() that clears PG_dropbehind
on a folio found by a cached lookup, and takes the folio off
WB_DONTCACHE_DIRTY, into filemap_clear_dropbehind().  No functional
change.  The next patch changes the helper.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 mm/filemap.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b04be64a5069f..437113addbddf 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1956,6 +1956,24 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 	return folio;
 }
 
+/* Clear the dropbehind flag of a folio that a cached lookup found. */
+static void filemap_clear_dropbehind(struct address_space *mapping,
+				     struct folio *folio)
+{
+	if (!folio_test_clear_dropbehind(folio))
+		return;
+	if (folio_test_dirty(folio) && mapping_can_writeback(mapping)) {
+		struct inode *inode = mapping->host;
+		struct bdi_writeback *wb;
+		struct wb_lock_cookie cookie = {};
+		long nr = folio_nr_pages(folio);
+
+		wb = unlocked_inode_to_wb_begin(inode, &cookie);
+		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
+		unlocked_inode_to_wb_end(inode, &cookie);
+	}
+}
+
 /**
  * __filemap_get_folio_mpol - Find and get a reference to a folio.
  * @mapping: The address_space to search.
@@ -2087,19 +2105,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
-		if (folio_test_dirty(folio) &&
-		    mapping_can_writeback(mapping)) {
-			struct inode *inode = mapping->host;
-			struct bdi_writeback *wb;
-			struct wb_lock_cookie cookie = {};
-			long nr = folio_nr_pages(folio);
-
-			wb = unlocked_inode_to_wb_begin(inode, &cookie);
-			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
-			unlocked_inode_to_wb_end(inode, &cookie);
-		}
-	}
+	if (!(fgp_flags & FGP_DONTCACHE))
+		filemap_clear_dropbehind(mapping, folio);
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
-- 
2.52.0


