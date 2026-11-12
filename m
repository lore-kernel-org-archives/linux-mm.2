Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED4E606A8A2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R8hk5Dwv
Received: by kanga.kvack.org (Postfix)
	id F01456B05BA; Thu, 12 Nov 2026 14:09:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9096B05C0; Thu, 12 Nov 2026 14:09:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A956B05C2; Thu, 12 Nov 2026 14:09:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1B116B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9EC8A89DA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:19 +0000 (UTC)
X-FDA: 85427405238.15.652AED7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 30D592000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R8hk5Dwv;
	spf=pass (imf31.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510558;
	b=vELuWAs7rWG21ONT51wrRSdlr5d8yWflpLJ0Gi1YvJ2jTc67i4Wk7FGvKfaw67pEfya0wv
	jrj0Cra6b6ZiLiA/CzvnuE8WkeTnz5fyFP9lsMhyXTEB7I03vUoH1TZsWJ28AAzHPCg7zx
	NuEDVQDePrTMuvxpIrLkJ6z+MpO5fyU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R8hk5Dwv;
	spf=pass (imf31.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRT2/+R9YmYPDM76NCkeURQmSSsjMxRjRdu/RF1CsXY=;
	b=0kjlnxAl4Dt69gLVzXz+bJnlKGw+qDKY73cf/HNdZSShc/KwLJUudrydae4UyOHiADKp2w
	cETbPgpvCcuyQshQKlMSuliwdUFIKsVCKJvNTIBwO+FKmOL54da66nwGAjRMxR48CSlAIw
	FYGZrTFnGQ4MtdQJ8heClB++uBUbTgY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B171660E04;
	Thu, 12 Nov 2026 19:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EDE1F000C8;
	Thu, 12 Nov 2026 19:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510557;
	bh=FRT2/+R9YmYPDM76NCkeURQmSSsjMxRjRdu/RF1CsXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8hk5Dwv9vAwELb2ZJKK7TvMFh4spMzUdEtBRAfSLVwWI/st5fWdQZo/N2LJEdCdA
	 hKyPNrDt8bff1GXsVM37dh6jqyKzp6nd45paYHdsJxDGdmk7I23AabomXADvcP34e1
	 HIjqnxLbu6n2/vIjpn9rbIJ7ZUNze2NaYRiLvZk74KLZZDNzx9eX2GqkfoAyKVwlfO
	 vUSRv57dQiUwMr5xwh4UZJWUcd0r9Vg9QUelmaesJNPoQVEc/eA+6ihplO7DpSeEb5
	 kM6Wt9D4f7Kjs0+cOuCF/n9OrOCIBHtdIj63g+qDA35uBc3g4X9VTbI9RE5nilt0d1
	 1J6ILoemZz8aw==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v12 1/7] mm: move clearing the dropbehind flag of a found folio into a helper
Date: Thu, 12 Nov 2026 14:09:04 -0500
Message-ID: <20261112190911.84702-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261112190911.84702-1-snitzer@kernel.org>
References: <20261112190911.84702-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sgcsac7uzyhfhqzafas6agcdqzy3oo95
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 30D592000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794510557-150177
X-HE-Meta: U2FsdGVkX18IasA+WyiT1KIBmKjq3fgnyNBLepbDXO0NP0+KBjYlw8WvQ0rXV5QuaGx7EsVZCT3ABVgj+tgn0cJMNf6CoyOx7B39ZesN/ZE0ZWLK0XZ2xzKLk8qfO2UhPfXL8MuwHJKaoHjP9hbMVjucRlPhcxRYrmaJoBFMfrkB11l6BcP22HZpAi37VsB2CCPSTvK7m05fnagiJCLdoR1/NhEiItw5Ufrqzx4EIhfGiEIEv5NG7MjfA+dUo7JdSMZQqYvA+XfRr203WKin+LwF20BZ6oc1Y0x7f6UQxenwLvg0P5CrhDAd3aECTE3jKHMN52vzZlvJHlVFPspbIAnQvlb92LtbP8jUqGTZTkWNWSsKc6LC144XQPfgbd319jbfAozGJjYKqMhq8gQVqCZyDzjs2cYDiH9UEgtX7NWRWzHrQyib6EMquWJXZEPp0RgVSap44pQxfkNfez6OkysmrkdL5q3STP+qyOOYnbGbaRVIBqK8gluApEsaMXPtnn9es1B9lDLXriQ2nWzI9OHgemxtE20/39i41nq/gj3TOMPfvuWEuOtvLF2PoSyV9aVMYw/8ZF04xGflhGG1s8A0an/3eFSHb8YnxHLko+x4Bs3OT0IZ0VRFFybyOOuDIGeAGvgEMD2Pamyd/6w3mmfQqj7e6HJenbMGJb7KJmQd+ESq9bPv5JvxKFWuhPQjXFz7oMNmH47BhyXCz/zZzSOk4qABN9O8OFesb7V19uV1d7lfDfHv7Lc49RX9MxpXWAern077H8W9KZ9IVLNodV9SDJVPCvfdWNVjF8pAkbKlDzRTI2MGaEv2e5d0zWbRRr2FBp6urMSfZmHCbWoy/TcSFFmaJE+Vup0s2mGskHC2V1u3qLYIR2Ft9JO+gD2yuRLpci7jpXkpf2efIF704glUqZhszUkJX/hTY3p+JtAz83CJtVs0cvFeec0sezX2LJvhQgFr9CSj/A6bsSM
 HeZSut6K
 fSgHcF7SSq4ZULG6IKhBmptANd1a/kFwrYgJOhRLaRsuBXipP6PRTYyl1HTw9F/QI+BCy2sR1DzUGbuU0a3Wp/pjxBlf69FVBBmMsN2P/Ouvc/8HiimEGtbpmaYzriRGO29MOb8hQptKWGhut6FHNxikJeu2jgdiOwMJp2loy5qNh7eLYFPLEk2fWomd5baY5YRNcnOpA107FNDeDCokjI1migef7ASsFaI7T39w0aNbQqtf6q1N1TBetVG4sjnH7cjgs3jqUBP8h+M8=
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


