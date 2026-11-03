Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FDE9606D803
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R6xv9O18
Received: by kanga.kvack.org (Postfix)
	id 894786B05B5; Tue,  3 Nov 2026 16:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F606B05BF; Tue,  3 Nov 2026 16:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761CC6B05B5; Tue,  3 Nov 2026 16:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4996A6B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29B451C3D89
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:17:59 +0000 (UTC)
X-FDA: 85395070278.27.D58B303
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A44C8000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:17:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6xv9O18;
	spf=pass (imf02.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HFvT67o+TI6VMILL8krBuuNC43u0v42N0ht6ClypRA=;
	b=x+ueRBXI53ZFLfJEL3Tpi/DSsRFOvmmOMHVjY4zj8LjLrunIAdohwxyAE4tzWLkg1FoUcH
	Mu9nARMqjBTfdMlZqJqsRdL55lEYNPVrepsbMy8zKceHXU3G0LhES+JjiCsYoGlm4tEwdP
	iFt00HK3SgOZdcpirAUVYArXkRhDpys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740677;
	b=J33LwlhP8sCOYG1SUcmbxKTt32R6d87PmWBbkV3HfrlOPJCfd3RfN3n7Zg5PzRa0n5ETfc
	dhlehBXK0Y8QgSXxldK3DukHpAFISADtfet2zpWnh4VUujVflXh2uRhusDDXfuOaoB55aT
	uf9dx2ONOCLlA1aAfA3nuyjyTpQXLcM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6xv9O18;
	spf=pass (imf02.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3AB342E36;
	Tue,  3 Nov 2026 21:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C361F000C1;
	Tue,  3 Nov 2026 21:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793740676;
	bh=6HFvT67o+TI6VMILL8krBuuNC43u0v42N0ht6ClypRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6xv9O189toZnNtMOFLE7eGtRnp6nZKcRayCIILy1wQl8VBsjFzP1XLms8CplwP2l
	 MLC1vq4UQ0Ls+BesRL7C6QcIuzlM3tSnJz6TSdc0xHnRT+d0LFrfv9hnbSXlET2MGv
	 Mp8Fbzt9jGqeDWOYVuD5a9gZsDzoTpT1ZKPN1kn31e9M0KaBFMi6Z5UhsbCOK9kyp8
	 uwKJHuJkzNoWtqUt1d4Dq+2NwJD8vK/yJub2UDLLqbDlblS1jajahTlMVj82lO/nvz
	 A9M1McdlB56pXOUMRltRAppTRIc1sEuhw6hbd8vqk3tSpLxv0fxAm4PlXikeTPVhFf
	 rAXX7h22u8yTg==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v10 1/7] mm: move clearing the uncached flag of a found folio into a helper
Date: Tue,  3 Nov 2026 16:17:48 -0500
Message-ID: <20261103211754.35352-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103211754.35352-1-snitzer@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: g4jnp5xr6egfaia4i6ioj7w8xptjxakd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8A44C8000B
X-Rspam-User: 
X-HE-Tag: 1793740677-11526
X-HE-Meta: U2FsdGVkX18bwT6+HyDtcYbAH9DBrW9/Gk7QXordFNIR93vSVf5nSwNox3IYWdgWCfeiTOSysAIEL0T4+CAFluL/egx23IKe3AQ2+7Sow2JNxOus2fhE44K+wcYbFrgJtAnLgRMoPLiOi/Bf437OUUBxvzg1MdV0Lb734tb6Mms4iUJ5golRNhnVtfKIpbUBpLLUiaPv7U3VAhLikbXI1r2xWw5I8720aKA8N5ZTBz5Q8cjDV3ETN0J0BQH+jKYSMiThUesbHXMJt+KEyqZ7BwwPD2Y3e8uc9Lw7PAPOi6yAdxukGUHCNH252xPoc2Alr7+agKJFTE28skmoMKRY88GtsbUDDl3NcJzWTZyc0mu5j7VYFpNFMp1w13X1uzfruYncMYo1mdU4y9vbPrVPgz81TDJLswvJrMyrqYksTJby3whwCpscMHeHIMjvOfwJCKFauZuFQRVcD0gWI7QtuBdE1XLhgyz7NAk8gZyu5d+Ie/chCQuf0TK0LfQHRz3DywrJCuKIbkPlatmLFctJb/RAomeaIwNI1Po5m0W/ts4Srx/yGNCJ7AwxwoJTqimf3/oTEkVCdEOR068XhtSpubkhcAvyUUh/wP1h9UNRZmSho7wa7q0Q3mbV0VN6N7x6t2nIrMHhQVO0X7/q15d3fxitLUm7PK3yvmxs9IN7bCbBAEbcqjd1B6jFPMSCJ1k0kAW2dA8wjNo/KepUdy9lTPrS6hQMknczlnJKR80gElBaNBbmaUsQIY6Uk8sL8fUT+1XLrKqG7FZw9rU84KiRkNuqSyF5v4T9GQdTWnMO395ufXwvMb1aO2Z3ktkEctokp4QfDr61NLzeoT5vw3l7XrGVIz6WFA4xiCpZA0AsiXjBrlzA38nwn2MEZW0CR+TVcAa1X0Qxs4idCgoTcP1QShSIKmXq1ZCRHlQu7XRIae7t9qOCNl6iYQrGV542RmGuVmF59bBU6RsZVwbpH3S
 zmRHwwLo
 I0G4EJm0BgmxFj+9zcgAFe0i/Q0BItNlnRFrtxmo6GehvzsswlumXkWApmOIdwNM0T4rCSphXAsXMOKJv1lNUKPOQPxNzQ2m//dVlm0Mk8uYlqOXB4aTlwwWcEpc92rclG3/L605GNPdhdtRl/nYXkuFQrXApREN3oASkhvGsHCkJsHHd/w9FhKCShRfaNf0H3n6MBU1linglIXGf9SpEq7cLBKc0zFIXx6wO02W9QDUXjDtZeqLfg7mTEfG5alhpIlVHNaHtCbQaTxXqRw/kFtEVkI6jHR4/18bknCX04IUuv+gHSyNjK0bHw455Xo6PSjQFg2wayE+InsIGyR4PekD8bA==
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

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 mm/filemap.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c6..c75f49563b74b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1945,6 +1945,24 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 	return folio;
 }
 
+/* Clear the uncached flag of a folio that a cached lookup found. */
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
@@ -2076,19 +2094,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
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


