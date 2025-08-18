Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9404ACA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C888E0016; Mon, 18 Aug 2025 02:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3149E8E0013; Mon, 18 Aug 2025 02:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251DF8E0016; Mon, 18 Aug 2025 02:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106DE8E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:58:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 852E65B6C0
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:58:50 +0000 (UTC)
X-FDA: 83788975620.02.1E6E38C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id F001D140009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:58:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QPg55rm0;
	spf=none (imf23.hostedemail.com: domain of BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755500329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4J1/06gJDoy116dfpIOWW0QWPaS1Pkc+RGvAfs19vE4=;
	b=ZwJZ6hsMP0YUL2BpmN1PcBCap2P5YvHsM1djLkovCq3DICxogAdecuRXKK8uaakhuA2a+4
	5oJsoee33M82wE8RUTbr81aLUKBi8jfl+Mnx8fK/1KBAktneDs4kca7+/DwGILtSG9O6mw
	U9dNsWNrE5GbHiJxvgkT4VleQgr/pAM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QPg55rm0;
	spf=none (imf23.hostedemail.com: domain of BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755500329; a=rsa-sha256;
	cv=none;
	b=rvuaOpqG0kZ9G+zhU2w7bHkjJkgXPf8PFo9X0JIUtJu939IIb+tTGhmu1ICubJncX3KIOw
	t2qg0DYzMc/fvwvvT2L+VGsU3U9fzJRmy5bxPYCi0Zh1U0okGxuXZd0JS5FJOfeHG5eBa7
	NTRutl8lFVbleBEgIoLKD6brvGGkBj0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4J1/06gJDoy116dfpIOWW0QWPaS1Pkc+RGvAfs19vE4=; b=QPg55rm0rQfK16zrN/EzN/1j5A
	SzTVgY45blodBybCI5xGxFia2fC8Mcrgq0cJklfNWtRK9LP/dJuBDyJ9CIi16ChCjAr9oA+6X81xI
	irIOtJq4HbEyh5O3hdxFdlGzk57fpJKfVVzz0WD1V2q2t6JdP61P+DKanTrU3annX5br8NYt7Mmba
	4DseCVrBmxO5WbduUFYrbKKOfiZBy5ny2kqMwbqZu+ph8th9rZcmRtFq6wvB7KTZ7TT0EICzVDhfn
	tDXdXK8Nc4HAxT7P68c+2fUT95EZXywef3KHdkpycwAzJr/OOWJ/FKBM6mJQOHQPVhajAVCwv8wBA
	NQBX7NhA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unt4d-00000006bmt-1Vjk;
	Mon, 18 Aug 2025 06:10:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	linux-bcachefs@vger.kernel.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm: remove write_cache_pages
Date: Mon, 18 Aug 2025 08:10:10 +0200
Message-ID: <20250818061017.1526853-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250818061017.1526853-1-hch@lst.de>
References: <20250818061017.1526853-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: n9cofqhsxuyydsf8ukjcus394m8jeuau
X-Rspam-User: 
X-Rspamd-Queue-Id: F001D140009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755500328-67450
X-HE-Meta: U2FsdGVkX19grQ/lKcqYMWZWQMrhFfpvnmPMnPHcrUfhTL0b73xp7Uftww3aFauktozu9eP8TvR1ULkHs9ljKDNsCny28o7224/nBaCkMLzagU7U0eHsS8qFIX85ftjQJYQdNEExO1OCRvSnmk9bN31fhXAQ4giL822Q9GHf8+tOzHInOYKvGtf644+SsWS/nwlz4a0LhG751Bz2PcNraj7qhzgBi62MSIcJzOm2gDhRGXTOqI+W1nlZx/8CT7PPc3LoMC1G1R1wl2VdT0xqvynuXRbh6NlG3xH+AUUcTdg+Eg2w4MIuofetP8Ru/UMMAvHJ3bGPhbCghNQ2zdaV6xLAg8ABKu2dv20Lumq01pYDw4tEOLxKwMlNwORdly+/FB+glQ4d4h1XaXpSYzxfovDa1jSJm2AYs5+XHiQtXykbzf38jJw3+YTQQTSYxrV/A7PeOKGLvbnpO8nqsoA6geTUIRiaNPdU904VuJZ+L7XK3x4n48/+Sft7ZMxUV7vQalzISjwqwbrRY65ElfmPT4c9n4r2H402Vo+UaRcrOxA4UL3IIjPQrogwkNfhcfvzvnX7AE/sTtANw4gnnzT9TQXxLqZhgCy4cWQUYNJ/PW6NO4BWejVO6MuMXvywQUeAz87h80z2DXzv3k3+sdHmrxPLRYGpeAa8XdTg34/4gziRS99T6Ti0vmNN17hJP5DSCJbCV6FeyMXP/LOL/JwkqN9hdwGQI8ydU1Tu2gFbySmIVCF5gqQ4S6gKKw8vtClLFdsJsicUmmkKNvSMiEecL1bcngz+9cwipsQJtxlfrsH/9pGiQuFQzcP9FFtiggJOT5C68GTaygt5VL5nvd/J8TyTco8RTjucPXmtZ7SSrZYGKcwp/x0CRZIGBlaL5zbaUIgwjZb0nKOmxPfCTWwv+IIADHd/TIbU7h98bn/kcpVeN/174guE1OrAJp2Kr3b543QGhXW/Z/AUxf56+D1
 SlmZxuRw
 GS50PrJXzPH8ZB0oKQwFLYBK4vVjKA/Ds+9/Jz5Ep+pzHCcl4xhT20HAbf99B25CBeCDeK8DQTE4NxLom9vIMbqCKYpbW83uJqU0Aj+5YV+jghgx4b/aMrJ+Xybp928PwxqXmtfXDgXLxA4BAJp8rPReXtu9gIhc2SozUKcUWCqsnFgxhjroqRY8o8X8qeatPv6Gx+EzDMQFNw9uJ6ayjfjMXNHI44vX5w8dMKG8OZCa5pkfzsAfgSesOxzF3EKKU9Rz4GQowCLjmaVzADYwcSkmrTsAdaDpP/fhsLhRlBVAqvEoOJNqzK+ns4ECpuOnqKH1X70AogyF2DHL9zAHfud5gKbTfKFnO56etQ1mT2MT72rGYaDHUjjobJ8N3D+5HZcNc4PHj1QTRRTjC1bTHKAiKFaTP3MTyEI5BKmCpnj5aK6oCWcrWGkHTI1W6E4LTLjkgArVMiRRI2eRRDEtgswXVnQau9qORi+07JiHOTE9UoN6bzJF8P1hnmuRkq1xSb5LIeZVcHGaw+5gLT5nwvm/LzQAD2jtzvHUdFqx+eRPPZTxaZPKw6TCRelzk2LTgoW1SlpmQRcsNqGN8nAWm7SK5hfX5jKfImJOx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No users left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/writeback.h |  6 ------
 mm/page-writeback.c       | 30 ------------------------------
 2 files changed, 36 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a2848d731a46..2a7e134d03ee 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -360,12 +360,6 @@ bool wb_over_bg_thresh(struct bdi_writeback *wb);
 struct folio *writeback_iter(struct address_space *mapping,
 		struct writeback_control *wbc, struct folio *folio, int *error);
 
-typedef int (*writepage_t)(struct folio *folio, struct writeback_control *wbc,
-				void *data);
-
-int write_cache_pages(struct address_space *mapping,
-		      struct writeback_control *wbc, writepage_t writepage,
-		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3e248d1c3969..7e1e798e7213 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2590,36 +2590,6 @@ struct folio *writeback_iter(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(writeback_iter);
 
-/**
- * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
- * @mapping: address space structure to write
- * @wbc: subtract the number of written pages from *@wbc->nr_to_write
- * @writepage: function called for each page
- * @data: data passed to writepage function
- *
- * Return: %0 on success, negative error code otherwise
- *
- * Note: please use writeback_iter() instead.
- */
-int write_cache_pages(struct address_space *mapping,
-		      struct writeback_control *wbc, writepage_t writepage,
-		      void *data)
-{
-	struct folio *folio = NULL;
-	int error;
-
-	while ((folio = writeback_iter(mapping, wbc, folio, &error))) {
-		error = writepage(folio, wbc, data);
-		if (error == AOP_WRITEPAGE_ACTIVATE) {
-			folio_unlock(folio);
-			error = 0;
-		}
-	}
-
-	return error;
-}
-EXPORT_SYMBOL(write_cache_pages);
-
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
-- 
2.47.2


