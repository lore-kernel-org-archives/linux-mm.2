Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FBFC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759F26B00A6; Mon, 27 Jul 2026 14:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6146B00A7; Mon, 27 Jul 2026 14:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB996B00A9; Mon, 27 Jul 2026 14:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 389BF6B00A6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D62D140173
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:37 +0000 (UTC)
X-FDA: 85035354474.09.6F79E29
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id F2CD4120007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dhHNFX1F;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHllHAYD+554jhDmr6CAyg40twiId7LXCrXkJDYooJQ=;
	b=uQlcVGhjr/uX9kQmlt9mgi/lKbwkkapWPYRKDdajVe87fMerK3o1pV1p4n9clndkSGOmaS
	whnVOWN4YFZ+5dW1WBIKrmtxqiRG6Ek9z7KUAzIeEqiIA6KuOOLYXluognj5VhV7jQkrQE
	h1YyedVtE55DC6ftlekvY89Q5AMGsC0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176016;
	b=3iENJXy0e4GxuQtC8K1KPqhcYm6kSkZH3ipEN1IJP42t9bwWLD1qwd+LaZBmzwOjzKp5vq
	Et19l20l6x5hECKe5GBK4Kv3A3JLGdJpZs82B1tC2jW/2GS6H3fCq7lvynTcEucSPp604h
	0m+BQDTy/b0CEjK8l9emawJ4r7ULyLc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dhHNFX1F;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=VHllHAYD+554jhDmr6CAyg40twiId7LXCrXkJDYooJQ=; b=dhHNFX1FHnBFsaHwsJcodHjGRf
	YhtbqSXUGYiJgDO78bOy/MC8mO5sU1yZGVlNbuPtR83P5t6qEi9kIa8Ydea7g/4/5K/1QcWKPc6Tz
	rey9R5mBOCjVGXv8FGrSF6jjiMjbElO22NWGZtwU8fS6ML3G01d4CBmqaOo1uRiHW03am+wvHmaU9
	x/WArFCOA8TOvT95/SpgcWc2waBMUqjfOqZe3ZD7epa9ezmGTd7WHNs11qq/QJ4ldOTy3h3O1YrYr
	JbremtoeF7TSc4XN2ze/QluntAgjkG5D60+jMpI8BW6tkmg3DUL+bENi5BrcYObSr9dSBGC+IMJ9i
	qgIIvmCw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPpB-0000000BD7i-025w;
	Mon, 27 Jul 2026 18:13:13 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v6 11/12] filemap: Add support for authoritative mappings
Date: Mon, 27 Jul 2026 19:13:07 +0100
Message-ID: <20260727181310.2671972-12-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ebt5azemd8rrocjfxquhuk6wi4eonfbn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2CD4120007
X-HE-Tag: 1785176015-301588
X-HE-Meta: U2FsdGVkX19pBzukSiqVxzrQKKvwfrn2Gca17bzKriCSKxbeUS0dzbnEGA//hJlr8crZ50VDEGbW+v4XoUWt1S/sNWyw81dA/vX69YVq//a4vKy63z36CEwDddxvB75bpvZ9xrBs4pMLipfQQEv4UPjrnUg+x78wI90WWMev8Pv3yKNmYQEY4qjUUe3/bvcjviZ77YApgcqNF15L1ZnEm2hbdjulICrFTSt8yjFxdarHQTLZB70p0jz644s49gpNDD4PWMe46lweuu3TU6H+0ehAQ/Cl8p4PaeJ5pRe1Nv20j0gEkOpGGhGD58qB6swp/MQNCiwv77BqbqZtjS2Pd+rR5Gd6wznHWFzjF5FOQlFkaBsv3lZdrRVS/bp9SRa3+ZMJcGS68EAtz5yPmd6n2gfed9gPgcYxTGnbLMCy0RGrkqIi9tlVSBcIkuuH2G5ivqQ4hKd55brONS76RdkYB3WYiRaG4fX9N0yer+G7+JWnZpnUD3huxP/iPkPFLYeRUy9VKP9iYR+mlXh4bR0X2ohE83kelwO2Lw1STcy0Qzw1oJMZQIgZSA8Zad6vVpdLRbH/4Qbj9bzAgG/CBpIhnB+naP8azJjRR7MrGnU1VNzFy1w1VK4tshW3i3FgsIsNyRkYEoSayzi3FXWdIkxEIAgGEZQmbupTs9iz7Y6JqFSGN5u2sklF7C4Kodf+WXIf5cRwS8vhynkS0HRUiG5fRnx/pOAL67HNNIORa2QpITTerAYPFmFWBuK0Wl4OZd/N6wfOdJhY8dzETjtaCwW1xXM5ePlh1g1gv36ga73qNZxPtOkbo4JY+lmEdv2MqPv2/AfoeSHvGN1WDYqMb3a7QQSE+0sKzo0W2ezQAbFDEK3Ua/RougxDz88yi9D7GEKxqhgLnMgeNFErRo26DzLe2E0dAZvXkYg7Bqb3iSQVFyEFLeBEPEYnMDNHQc3PAhZQU1zSiWPLDvgy3srFe+N
 TjETUUwo
 9UiXg0JJU4GLpj2OJ/BlEpByJTD57Dnm915mXisziRCgkDoumhQ93d6VoImJ5VDsVvSXJaN82qp3Jwp1aKVCo6yyJUD4ZDzRAP5KkseU+i8Ymxsh0Ahdzs5Nr+mv36xfknzck7a7ThEulkBh5UThHMkwbM7Ch8ltZv1Q9K4gFOrb3njkS5vSxfOo3KD3rIxhBRGBM1YHZG/EGukifXx7x/VXJ1Hntt8JO8JK6fyBFkIzvgGz5oTVxC79T8w6a/URn8l/5f3+TYsAfBAKdVS93tLf/nzGvjH0DFa5+P74utrFp92/OH6z0I6A7PgOyGj3jgQFgJtcaCbIQnmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An authoritative mapping knows about all the folios in the mapping.
If read() finds a missing folio, there's no reason to allocate one and
try to read it because we know it's a zero region of the file.  We can
just call iov_iter_zero() instead.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 11 +++++++++++
 mm/filemap.c            | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 968b791cfd14..22d48935ffda 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_AUTHORITATIVE = 11,	/* If we miss in the page cache, it's a hole */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline void mapping_set_authoritative(struct address_space *mapping)
+{
+	set_bit(AS_AUTHORITATIVE, &mapping->flags);
+}
+
+static inline bool mapping_is_authoritative(const struct address_space *mapping)
+{
+	return test_bit(AS_AUTHORITATIVE, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
diff --git a/mm/filemap.c b/mm/filemap.c
index 26a5f18121f9..5a8cc20e624e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2697,6 +2697,8 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 	if (!folio_batch_count(fbatch)) {
 		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
 
+		if (mapping_is_authoritative(mapping))
+			return 0;
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		if (iocb->ki_flags & IOCB_NOWAIT)
@@ -2853,6 +2855,22 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			goto put_folios;
 		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
 
+		if (!folio_batch_count(&fbatch)) {
+			size_t fsize = mapping_min_folio_nrbytes(mapping);
+			size_t offset = iocb->ki_pos & (fsize - 1);
+			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
+					     fsize - offset);
+			size_t copied = iov_iter_zero(bytes, iter);
+
+			already_read += copied;
+			iocb->ki_pos += copied;
+			last_pos = iocb->ki_pos;
+
+			if (copied < bytes)
+				error = -EFAULT;
+			continue;
+		}
+
 		/*
 		 * Once we start copying data, we don't want to be touching any
 		 * cachelines that might be contended:
-- 
2.47.3


