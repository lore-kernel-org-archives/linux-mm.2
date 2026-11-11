Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D51606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=itp0oXEf
Received: by kanga.kvack.org (Postfix)
	id 485A56B05B9; Tue, 10 Nov 2026 20:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40FF06B05BB; Tue, 10 Nov 2026 20:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34ED26B05B9; Tue, 10 Nov 2026 20:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8156B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7145340167
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:14 +0000 (UTC)
X-FDA: 85421173068.10.5BF2E8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C07C4100004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itp0oXEf;
	spf=pass (imf14.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnDCs+7uPBjV4AWzwRSdGW/2w1/1J5xqMVOU9/AJamg=;
	b=byb75KtpgzmwesE2GJ+7/35HpIINDDgwiNC6XdJvHBjJVIcqCBtiA19hLmv7erZ0U2786d
	X6jqsfanuSGaRpM7COCh8v0dc0WlmfKQKZGy9TTkSxXPWvBUUS828FqugjnZyOM2IXZArr
	GoMlxQPwF3uRG1HjCLeLQS+fFnpwk9M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362172;
	b=BrnIdVHzo5U4aLK7y38Wt3t0mmbfpAlfttwvHTq24XE6UNd0GyhwugLkbToMtOcv87Rb9X
	MC0fqFASLTDIsdVGLlEC768h50OGBPYeIN8JaC8jN0UCY6Gu4mtH6AHeBK70HRNM1Z6GMb
	EYArY0qmwThDdVJOU+Dg3ruZTz/VWFc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itp0oXEf;
	spf=pass (imf14.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2F4C47312;
	Wed, 11 Nov 2026 01:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6292C1F0089F;
	Wed, 11 Nov 2026 01:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794362171;
	bh=tnDCs+7uPBjV4AWzwRSdGW/2w1/1J5xqMVOU9/AJamg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itp0oXEfchQuxyVTQgHfLH3S90MLaAoZA5X2/d0kX5lDDas4YJK5T4vozbrzLNfpz
	 tryNN9EzJz3tpWsQvXrF9fS6ABhvRXaOtkVSMJEpZjPjBkl9nIkc3PB4gPu4oC1dWP
	 VZKBE/2Sq2SvOBrATM26VzSwJccjHwdrPFFroKHIRhtqetdb0iEpviFLPStr+igjSj
	 sJugrMg6zAR37DnLZl84Fr5ZoEpHw3CFNvaoy6HraT6UBLjb6aTYtimpg/X5GN4MV1
	 jZf199wif6A2IuLSjkZ765v6SEgidSQsnW2tuB4Kp2dhbsQNB0/8gJgO19zSyNYeyX
	 DKQtW64TwMUCw==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v11 2/7] mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
Date: Tue, 10 Nov 2026 20:56:02 -0500
Message-ID: <20261111015607.46338-3-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261111015607.46338-1-snitzer@kernel.org>
References: <20261111015607.46338-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C07C4100004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kty4t5cr6qn1sdu3btak7b6b4has8ze5
X-Rspam-User: 
X-HE-Tag: 1794362172-542817
X-HE-Meta: U2FsdGVkX1/uiVnj9evCSxl1XiVn030QVufUsuZUu+5exTfjeMGrjph9EXm46wuVTNUHBNkEndBhFdQbyqvB5UcBavcFBcelsca9Fjz/j2OzOnW/xPkGBmFiO6dwqumg9LCqWwKzcUlfEMJXhyHsYyTE+EticDek+qWy6qM+KCDidVsXjildHk5OGhvBEmOqM+0pnAKz6G7ZpVa6XGfCqbx0vmJklGnfNZWTvzkG71qBegsbD72/DEPvvnE7wSkJ84uiskAL3v3B+l+3EvJn4TzAlbo4WJYACfeqP9MtTK29tJKRKUsRZaamlGcIsXNFYDWyjpcRFwFCPsgOuCuTe9pJN9cELGeiWqv7DugGJDafmD31HWO4GJjUUSPs5yHayZ7EB32+Bel/FcjMPk7lY+mrPg1L2gRjs7REruQlk4sr9bBtOIgyP+pEpH6JuEmfVqadhks/ECNaeynTpz3r4igfT1lGV8qzh0MAQ35OOB1A2PaHiyrbSsEpy9uIN8QmoXLHiq3xJbGWL58W4fZ6sn5/WMXzEWUnQ9gbKMev2AqYvnnxczXq1Ijb/UUdXfEcNZhOtq3FtWgSkWQT+VtoTVuMCf1VFa6Pk1i66aHEHlAuEI5YOlNL81d2nLVfDDToTHdP/kZpjxJTQiTShQMCCFk8yHUOlDOyVII5xGrPBh90eZdgc/IwZMXEbIkoQGbHBQYjSD77mPOm8WIZDY2cdFHDmqhZbtKuFSIjB8Xw5qP1QJQa8gkSQRNZKk5xa/0dgz/QHQZOOSFNa3CrSLZcnKmP3aMIY99xAztYGQL8PrmDZJr1p4WHFXSF6Jkps/p730eHqH0U/LfpQle6ufpgSVhtKxMLbd6gwiwM9ktbckZImUYDYgLGiVkajH7PbT9P1q5wb9XWZLiwHpGXLpF8CJ6O2RjhzjFBoA8W0AAx8wa122j3AjMBw/zHZuNqivL6CoDOW4fc7MmgXrIxhhR
 D3c13Cow
 FjufPo33c5uFAPhtbudU/XvNOsCQzS5Tly5e+8d3hnAEtxeaAW+IpGyYMgCg18NRcrbBzesipHRGAo617kUTnnh/56R//ovATqhEka7fNhbOldwS8d3NTfuq9paTN/NSKdThuNmBj7QWJ85tw+JvmW7BZ5Mvtmk/8afrCGs19F4RXjm2ue5iaLjdh7TT5p1AoqnMuErhWdX8QC0HsUwb6AeuQ/UYwp1K2RChGca+QCABKrHD+IlgHRcoj1eDk0tH1MEXQI0ck49WZoy5NQUKW/pHwNqsyKnsGaJrFj6RuRmNLVbKZmKn4Vcm4XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A cached lookup that finds a dropbehind folio clears the flag and
subtracts the folio from WB_DONTCACHE_DIRTY if PG_dirty is set.  That
test races with the dirtying of the folio.  filemap_dirty_folio() sets
PG_dirty before folio_account_dirtied() counts the folio, so a lookup in
between subtracts a folio that was never added.  The lookup also does
not hold the folio lock.  Every other path that subtracts a dirty folio
from the counter holds it, so the lookup can subtract the folio a second
time.  Either way the counter drifts, and once it is negative the
DONTCACHE writeback kick writes nothing.

Fix this by having filemap_clear_dropbehind() clear the dropbehind flag
of a folio that a cached lookup found, and take the folio off
WB_DONTCACHE_DIRTY if it is counted there.  With the folio locked and
the i_pages lock held, the folio is counted if both PG_dirty and the
dirty tag are set.  A folio that another task has locked keeps the
flag.

Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 mm/filemap.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 437113addbddf..98ce955404127 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1956,22 +1956,36 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 	return folio;
 }
 
-/* Clear the dropbehind flag of a folio that a cached lookup found. */
+/*
+ * Clear the dropbehind flag of a folio that a cached lookup found, and take
+ * the folio off WB_DONTCACHE_DIRTY if it is counted there.  With the folio
+ * locked and the i_pages lock held, the folio is counted if both PG_dirty and
+ * the dirty tag are set.  A folio that another task has locked keeps the flag.
+ */
 static void filemap_clear_dropbehind(struct address_space *mapping,
-				     struct folio *folio)
+				     struct folio *folio, bool locked)
 {
-	if (!folio_test_clear_dropbehind(folio))
-		return;
-	if (folio_test_dirty(folio) && mapping_can_writeback(mapping)) {
-		struct inode *inode = mapping->host;
-		struct bdi_writeback *wb;
-		struct wb_lock_cookie cookie = {};
-		long nr = folio_nr_pages(folio);
+	unsigned long flags;
 
-		wb = unlocked_inode_to_wb_begin(inode, &cookie);
-		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
-		unlocked_inode_to_wb_end(inode, &cookie);
+	if (!locked) {
+		if (!folio_trylock(folio))
+			return;
+		if (unlikely(folio->mapping != mapping))
+			goto out;
 	}
+	if (!mapping_can_writeback(mapping)) {
+		folio_clear_dropbehind(folio);
+		goto out;
+	}
+	xa_lock_irqsave(&mapping->i_pages, flags);
+	if (folio_test_clear_dropbehind(folio) && folio_test_dirty(folio) &&
+	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
+		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
+			    -folio_nr_pages(folio));
+	xa_unlock_irqrestore(&mapping->i_pages, flags);
+out:
+	if (!locked)
+		folio_unlock(folio);
 }
 
 /**
@@ -2105,8 +2119,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (!(fgp_flags & FGP_DONTCACHE))
-		filemap_clear_dropbehind(mapping, folio);
+	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_dropbehind(folio))
+		filemap_clear_dropbehind(mapping, folio, fgp_flags & FGP_LOCK);
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
-- 
2.52.0


