Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F67D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 03:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B24D6B0092; Fri,  9 Jan 2026 22:57:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F9E6B0093; Fri,  9 Jan 2026 22:57:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292CC6B0095; Fri,  9 Jan 2026 22:57:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18A646B0092
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 22:57:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC8A9D03AB
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:57:02 +0000 (UTC)
X-FDA: 84314693484.04.87EF16B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id D65B2C0003
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:57:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=MaRoKkOl;
	dkim=pass header.d=suse.com header.s=susede1 header.b="krBU9/Yc";
	spf=pass (imf28.hostedemail.com: domain of wqu@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wbutnzV9eZIALfLzM0C1Q8Sqw2lOekYO9LFPItKA0g=;
	b=cOjdniNMxS8zSqg+yzzC6Y++JDCh2rGV2oKNwuq7Xkfsm3TOxB6aaGEJjR5c52ylRWHrLN
	PdrRkwzy3XbPcHahB6z+jBMN1bltHTbil+yex7EaVQRCAKUCWcY3U0UaBmk30upwWGza7b
	57TDPKCXD40MkCbFte0kIgRe6nzEw4k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=MaRoKkOl;
	dkim=pass header.d=suse.com header.s=susede1 header.b="krBU9/Yc";
	spf=pass (imf28.hostedemail.com: domain of wqu@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017421; a=rsa-sha256;
	cv=none;
	b=FvKWymBdjvu1AzeifhCt3Nn9g3t3LHygfgu5j+LVwe1R/zs7rzUSp3Ds/sEoZUgCjRSofE
	uHi68yiMk6eEz7O2U4lyTBwblulLBcVn+gDJt0dPGELnfjWy67s/v/GdE+vtc9Fc5GmN+2
	lfl/snPwbSu4BGC2Fa2EtZOp7fTCyDQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E43CF5BD4F;
	Sat, 10 Jan 2026 03:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768017407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3wbutnzV9eZIALfLzM0C1Q8Sqw2lOekYO9LFPItKA0g=;
	b=MaRoKkOlRpkozbBPWLyRJ58D5/51rfTsbZt/sCizdLV9dWxyQdb/bYiyAIrP2BIL15BjJc
	uTdRS2aOINCDuy8PZiO2NE2PVxJacq7aiYZ/aIGXVYFeIVsYoccMl4PUGbGO6tYkb9D3AL
	/WJoH3ixK1yd8d9ATkIIWSDNOV8KJi0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768017406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3wbutnzV9eZIALfLzM0C1Q8Sqw2lOekYO9LFPItKA0g=;
	b=krBU9/YcDtm7j9qKxigqapchgqEM+OhyRZ3gsd1HeuVxQgIPVeZZiRVsjiiSAXPxzzKrMO
	//ZLVpBOn9Sw4wQYfMNlna9s7l+C17Dcj2yv4dxeOqYVVasQ6bgyu1Jp1yXvtGEj4kURd3
	E7XpWGI+ibwGiFjPkb6VhPonPEfuO30=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E2323EA63;
	Sat, 10 Jan 2026 03:56:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IM9eDP3NYWlqLgAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 10 Jan 2026 03:56:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] mm/filemap: remove read_cache_page_gfp()
Date: Sat, 10 Jan 2026 14:26:21 +1030
Message-ID: <a5ffadf18dca846d6f8086b29366288e794a24b6.1768017091.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768017091.git.wqu@suse.com>
References: <cover.1768017091.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D65B2C0003
X-Stat-Signature: ob7kdpwa91gcais1u48i76tuts6sobcb
X-HE-Tag: 1768017420-322843
X-HE-Meta: U2FsdGVkX1/yH65/KugSxPTcoFC66OJO+Fk4EvW9WAT4MjpKtFVO1u9VXjflQdrY8LHT9E6uA+OCOCg4AvoMvlM063tdfEKaF8pDtNIkEjwHc3cpZmh26uQbv5pxCU+QnFSiVRu1YoJdVQXQFGjmjvUxwobEpfRdsj6+mpeA2C5Bc5idCehGXppZqUfaqfMZeS0/VROGSOWuAEd9wBc6zkLnMzi+Lr7w2Ix4Bl+HcBxV2oqDdWdsNEwzDxvvAf++5VNbCpZuHwV2UbB8LErULfoRB7Vz9XDNhVe8TDVpDOkE0xi4zWFmxKbbhjlG7LdvpAxfoPwITlpDUJzXj1CtVRqT+dPSyu2o4DqyaTsKtteycN0G3SilEVP+bpDdLRbWv2dzBOLSx/Oyq3gqWbOZDryGvh/aWNjyPR006dfV8NLENyyBv9dQf5/SINdDKz5+socXeDQaNEi3tImUNjQjmHOeJFEJ2Pdg1MkJWwSLtjf+Ujmzd0amhVlM8n13M4C55K2Ku7fVxeu6fJwBfoomQJFcN8G+se21CX5KF90CTHk6pytrxZKHo9xQ2URaC2EgO50Yq/izaWJyXDXKgJOAwqzkG12lStE7PQIuVesuPvqdAr7VQtEZT9w2K03HA+by8VQKGRHwqExzcvcHIE8OGVZ3wvSC0F/GsGDFgL583gTA9WtAJnJD5hph+uJUDgvhlx0D6wN74eO5RHxgaH7WRp+7uOVC/j5MTaWb63kBDHnGfPWFtYgwHdcsPiDrUlHXrtG80Xxu3N1WOMAE4A4dCmn7/HuQ0x6Uon934fyc6O97gbUNWQHLZGpTJPt4k6juriUZj6xxyVxY+26zD+A3gIhvLqIRMcrvEjT2gBZsnNwRPfI3SMyqei85lDGDWVlszXJVH/UzrTCkbyed77VtOfEPqZd3eB/HIUOohl4RcbEhCI4EXZMVqbeXc/S/BWtSeBRaBufonXMPH/qJKk3
 I6ztV8R2
 FiPq7EY58mYBxRYUuWNl7derOR2xYbsrbKSPDe+QdHxEK8IDJioMOHTEB2tBFIr4CekyIk+ndOjCADJK5ZurBB4JPQ09m/jVUqz6MQffswpWnZG9CpILASFu7wheCUikFEi3cEF7he0z4wQ3CGtzWIXHANECWI7GbZBR9Xm++WPBsajgfzfLwQZWhTCgeYQDQwqkbUeivq0N8Cu2HoylQRJdDI4yYfO5A4/FkoGRtJ8WxbFCCV91r3LQx+TWjn77otO2OOKsw1kHvck5tX2m6a+KaKRSSSvO8eLn+7jAIMQDEd/zOTW5TUv5HnXJ+s2FTvzbBaZ4Jev6GWI8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last user of this function is btrfs, which has migrated to use
bdev_rw_virt().

So there is no need to keep that function.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 include/linux/pagemap.h |  2 --
 mm/filemap.c            | 23 -----------------------
 2 files changed, 25 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..2efbf6c55a96 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1002,8 +1002,6 @@ struct folio *mapping_read_folio_gfp(struct address_space *, pgoff_t index,
 		gfp_t flags);
 struct page *read_cache_page(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
-extern struct page * read_cache_page_gfp(struct address_space *mapping,
-				pgoff_t index, gfp_t gfp_mask);
 
 static inline struct page *read_mapping_page(struct address_space *mapping,
 				pgoff_t index, struct file *file)
diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a..cd167aa45934 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4173,29 +4173,6 @@ struct page *read_cache_page(struct address_space *mapping,
 }
 EXPORT_SYMBOL(read_cache_page);
 
-/**
- * read_cache_page_gfp - read into page cache, using specified page allocation flags.
- * @mapping:	the page's address_space
- * @index:	the page index
- * @gfp:	the page allocator flags to use if allocating
- *
- * This is the same as "read_mapping_page(mapping, index, NULL)", but with
- * any new page allocations done using the specified allocation flags.
- *
- * If the page does not get brought uptodate, return -EIO.
- *
- * The function expects mapping->invalidate_lock to be already held.
- *
- * Return: up to date page on success, ERR_PTR() on failure.
- */
-struct page *read_cache_page_gfp(struct address_space *mapping,
-				pgoff_t index,
-				gfp_t gfp)
-{
-	return do_read_cache_page(mapping, index, NULL, NULL, gfp);
-}
-EXPORT_SYMBOL(read_cache_page_gfp);
-
 /*
  * Warn about a page cache invalidation failure during a direct I/O write.
  */
-- 
2.52.0


