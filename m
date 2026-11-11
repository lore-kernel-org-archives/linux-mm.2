Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6B6606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nb9+nB6a
Received: by kanga.kvack.org (Postfix)
	id 4FB2B6B05BC; Tue, 10 Nov 2026 20:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC346B05BD; Tue, 10 Nov 2026 20:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BBB6B05BE; Tue, 10 Nov 2026 20:56:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4F66B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C7EF1C1ADC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:16 +0000 (UTC)
X-FDA: 85421173152.27.5C49407
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E5CE9C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nb9+nB6a;
	spf=pass (imf22.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FO9EVH1vboVesivdtHaC4oHP+QvByQsuc9tAfFRd1cs=;
	b=pIEcOFVRz69W020sF7qpsp5GpmW0bWS+5ywf96ZYeNay9w3Olg32qSr9KcYvr7YjupAMJK
	tsZO6uUUlvFrhJteGJariyjDaYSevkbhWAtlWMr5nGDINbSPG/g4fg74OtHu1/BxZMDX0H
	IhbdbZIIAl3wyNF0w/NWpkuU94g7Pec=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362175;
	b=iFhYPLHbH8RMZu1PPNfhbrg110SRU5mtuTQB+U0Ielo3v400t16r43eAw3Z9IDE0kYI3pg
	8G9nVzFMDYE2AT3mq3gfP+Q9mvB5/sLzDsaa3F/j3iCuh/Ky+hrbR005iGIrHp3ewxD6yC
	TzO2NwLKC1kp6Tyeh25g4BQvKkf8seU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nb9+nB6a;
	spf=pass (imf22.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38D9447082;
	Wed, 11 Nov 2026 01:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92AA1F0089F;
	Wed, 11 Nov 2026 01:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794362174;
	bh=FO9EVH1vboVesivdtHaC4oHP+QvByQsuc9tAfFRd1cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nb9+nB6aRZWS+S6IFgOz5cLkH9/xjbELLeESlrJs0i/rdpYbDCRNvcds+kdyGev8d
	 2BwgmTejaL5H3uVCYwd1vgkNqzIWxNHIAJgQp7wIwZpEveD5HV10UZ47btuxRVHx6P
	 zqP7kGmEBkPTQI/6sMUzOnYDBvgQnbU8zY90spr/gHyCNupyN5VWzofhBfsNH6h5yt
	 fcj+gbhHZr+e1aUNV1hcMfLqxIoH0I01JJyO3rUmaOYBc86TDIjh4nT6eRRshCNIp2
	 iy6N/rsb2YZ6F96qy42GBK+7aeb5StJQ+wKXcYZdsrOLRAy8yMM9/AyZQiVe97YpjQ
	 QsofTWMKIvfQA==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v11 4/7] mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
Date: Tue, 10 Nov 2026 20:56:04 -0500
Message-ID: <20261111015607.46338-5-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261111015607.46338-1-snitzer@kernel.org>
References: <20261111015607.46338-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: dcighxkmm95faaysou73x8474ksrnedr
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E5CE9C0005
X-Rspam-User: 
X-HE-Tag: 1794362174-849225
X-HE-Meta: U2FsdGVkX19TCOLFYXctAnoW0eiMfU9J0RtFWYhL6ArfyBumgeUKI2iOAWgPvAxipve49TDJCCfFDfBxqegUndgvi8qmoZoCWq5c2nZkUplmhyogGe6UshEbuc60OCZ/5AFC9WlAv1fn9VVmNxA3OdoG5hTnk9fOJMc6XzFy9uxlC1XiWhuZ9pVhh6gpcxbmn7mR/vT/Phc5/3vxHd45IPBNQ8teRbJUPvUb8Hr63u5k73Kiq33ameMCtYiIKV7zBe0rqXfcrV0HikW8CIckymy1mEXD83qWEJOLHnr9ub16XMeMlcxdgfjDYzEXrOtEkua9QeQZkRNf549Vh1EnCdZ7CVN3JN2eFdIz9kgQnXq0Oafl8yEn89sVs6k2pC2RcTtABnUGAYr7ypU7GenT6iK3NB4tkY4asdWEKc1E0y5j4BBRC+M7qmj1+bcMQrj5EDz7VdMrl5NWo2rcWgwPgZrMCazI3mWQQFhxr7mbtLap40f/SmBLDcqSYtuGMqoUKax6CfdrT7q4qiODBUMWdhxVPiPjYDayERjilJzRU6tYN5c6jl9529G4n9uWlRyq2zdJulNXniOhl7RG3WwhfdjKMxHQhHciRfP9Tp3K/KUpCAUvuJHnKGRu/0q5yVr6E+Y5h2p62Nx2fvD+h/0oFuEACusUL+fHQU/fClXJTzfnWplvw0jB1FtjSKuTSTv8D5I2TuW87lacBUj/A4ggeyTQ9wq5pm0kp/FsRmcQ8+xpRvM6rv2IZFwcJoHtdEUfd53zusxoE2YuhUMktUHT8Z1bW/PCeyaOrwLF276gPAiiYsy1tpO23Oty16fV6OHxnH/nu2QZTjYYAOHJTsusb+F1NCcuOyxNkDZGydP18TxkCHepXqzjjZGl80OK/rMZKvy/NdFNLYY31uq+JHMH9SjVsJy9t2aBxjtk/hF13a8txgDrF8cMfA57e2odNTi/qjLlKYEKmHsew1Rrq4j
 nwO0P6Me
 3XISU1wLjaiLK3PzfVSIo2/OZTI3fEyi31v1C4SUX7cJvaF5UOyhG1LFW1tj8YFWcNScdiAfhRDITg/FSa0hRfehsVpDZwU4x4/fdaqjlZCaF9J5/ohxgutg5FIzb6JQ/VrU/Esbaslt6ckVxUC7jQMARhBjnH7Zv0cxrsN7OWGAV0imDh0HJJ+xXjwUTuHEe6lXvvZ3RxHZ7QhvIyrPbC1xhD6hrTLNJr5qskzKG2nMIEvbvpaO7DMUxzk5MmmCcio71r94En2hlauMLYGB2+Oa7gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

WB_DONTCACHE_DIRTY counts the dirty folios that are marked dropbehind.
When a dropbehind folio is dirtied, folio_account_dirtied() adds it to
the counter.  When the folio is cleaned, folio_clear_dirty_for_io() or
folio_account_cleaned() subtracts it again.  This balances only if the
folio is marked before it is dirtied, as it is for the folios that an
RWF_DONTCACHE write creates.

To prepare for NFSD to mark a folio dropbehind once both writes that
share it have written their parts, handle a folio that is already dirty
when it is marked.  folio_set_dropbehind() only sets the flag.  With it,
the clean would subtract the folio from WB_DONTCACHE_DIRTY although it
was never added, and the counter would go negative.

Add folio_mark_dropbehind(), the inverse of filemap_clear_dropbehind().
With the folio locked, it sets PG_dropbehind.  Under the i_pages lock,
it adds the folio to WB_DONTCACHE_DIRTY if both PG_dirty and the dirty
tag are set.  A dirtier that has set PG_dirty but not yet counted the
folio finds the flag set and counts the folio itself.

The name follows folio_set_dirty() and folio_mark_dirty(): the set
variant only sets the flag, the mark variant also accounts for it.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a373670..3f5295d6fd73b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1306,6 +1306,7 @@ void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
+void folio_mark_dropbehind(struct folio *folio);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 98ce955404127..a54d0fbd37222 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1654,6 +1654,38 @@ void folio_end_dropbehind(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 
+/**
+ * folio_mark_dropbehind - mark an existing folio dropbehind
+ * @folio: the folio, locked by the caller
+ *
+ * Mark @folio so that the writeback that cleans it drops it.  If the folio
+ * is already counted as dirty, which with the i_pages lock held means both
+ * PG_dirty and the dirty tag are set, add it to WB_DONTCACHE_DIRTY so that
+ * the clean that subtracts it leaves the counter balanced.
+ */
+void folio_mark_dropbehind(struct folio *folio)
+{
+	struct address_space *mapping = folio->mapping;
+	unsigned long flags;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	if (folio_test_dropbehind(folio))
+		return;
+	if (!mapping || !mapping_can_writeback(mapping)) {
+		folio_set_dropbehind(folio);
+		return;
+	}
+	xa_lock_irqsave(&mapping->i_pages, flags);
+	folio_set_dropbehind(folio);
+	if (folio_test_dirty(folio) &&
+	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
+		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
+			    folio_nr_pages(folio));
+	xa_unlock_irqrestore(&mapping->i_pages, flags);
+}
+EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
-- 
2.52.0


