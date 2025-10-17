Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 651D2CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 03:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4B2D8E0032; Thu, 16 Oct 2025 23:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD45B8E0002; Thu, 16 Oct 2025 23:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEAED8E0032; Thu, 16 Oct 2025 23:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3C78E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:46:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2986347644
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:46:29 +0000 (UTC)
X-FDA: 84006218898.27.8E1C1A4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id B5A0E1A000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:46:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0RtBUzLx;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf19.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760672787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJfEq/VEpkF6FLI8QH2hSLbs5ZovUQs0qM/ADHpSGWI=;
	b=7vHc0zm+L4I2N2KCSPB5WxgcdJWdtNR/sK8skXz9lvrQC8UeWNy+sGj1UL3K9mi/ZBMVlI
	IObg/Aed4NGd+bTH4aIFtlgF6srPJPy7kI+AEbcBaLbyoOp6D6NAvRnW0Mki2/hfB/jxXV
	2vmMur4S6ZfUkfHnnObT2PbuxyI/sZs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0RtBUzLx;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf19.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760672787; a=rsa-sha256;
	cv=none;
	b=PgrtmlBZsh4oUN7PPohqbstPD+c9qSXTRtFQ9C3uZgSFU5B+u3QqfsdmYm9nkQO+aE2gU2
	GJFbpg0UrkWaMcRKQ60N0zYYSEqN2XHq+D1sCaMgqATcERgwGyFBjoUie6cw/9I6d5bzRg
	N/ujQVK81ZFxcgPesn5ZYUfAnjGgbsY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yJfEq/VEpkF6FLI8QH2hSLbs5ZovUQs0qM/ADHpSGWI=; b=0RtBUzLxdnI3gtpLUeBQxq2cU/
	BxgViSRS3igmIOobOZyMaAWvLEUVoK0js2nMlKWPqi+QJSzXG0PaHV2aaMhDmazemlJt7mSU5aKPh
	uUi3go0oIQYazH2g9FDcMElIwKw4IWkP60Q9ypAmls9sGk7lDmUOWDtXHoyBzObS2hRACsJ9mBUnE
	l4pxOzVUKltvvtKhUqAszLP47nBWulQSPMUqCNK0npeH2ix8v/6i9sG+qK3cEX0Tsi+EERcccB77K
	FIyPRBYKkuHAqskYlvRkjA9ei2QNsbeFPigy+NSaDRuHHqHYLEp5IDBi+kj/1GgEIJfailMowV0zT
	9fZc1wmA==;
Received: from 5-226-109-134.static.ip.netia.com.pl ([5.226.109.134] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bQ9-00000006TyS-01c2;
	Fri, 17 Oct 2025 03:46:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	willy@infradead.org,
	dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 1/3] writeback: cleanup writeback_chunk_size
Date: Fri, 17 Oct 2025 05:45:47 +0200
Message-ID: <20251017034611.651385-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017034611.651385-1-hch@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: B5A0E1A000A
X-Rspamd-Server: rspam03
X-Stat-Signature: t4pq4nwao86rtisqwhorxh8fwdps9pr3
X-HE-Tag: 1760672787-409092
X-HE-Meta: U2FsdGVkX199OiUy9Zw9YiTcQF0mDWDe4oNxjiP9Vv8tJ+NDlSTff7WeGLRyIaOWqe3hfhbbUAuku5qMBusd7uoLpVfotKsIDGOEeIEXS4XGrCYtUGRzBnjRI+GxqWB8KL5/9xHS3EQIyq7taQPyh3V/tGy3bpOGkeN/iqjLj7z6HrRp+IIf0CkrfsF/IGhiBSiZVAVI0QOseV+9xvrXrNxo15Yw7aVv++TM+QiYRbjtBa/iUQx9+3ShCDnf281VFQvgiK5uQ+ARLydQsbAbxopQ32V9AVskQO5eSWKz+WoSVgMFki8Cr7fLQT0Ytg5f16j16W3IQoGvsORqmArH2Xyu97gneajbgpNMVbLfRiMvJ2cGZs4aIe22RJ/yLbO+bkc8EAKVwHRjhfiFdBHnqC6lmtqmgM2tof83toMMqkqe//ynJvcMb33idLyteHYUQL91ZdNQ/VHKUVVpqhkF7sPTU5WBBvSatEKFqaV0L+k/R7fEVjCyW+FyopzXU0TtRGlzAWwkcVSjEgloRUttfNtnkOlLRpQK3A3a4hXNzzFbi7JOJzJWCqb37xiv5E74kcuPKNJ7XdsdwRZMVuM9R4RFB1K8gF62ZWSZqIXdvLZU7BtY240v0YvYu8efTUuop30A/IQpn13ZeJMb95scSqaJOp2w8fQFdoo1FyiD0WaQh/sFVKRR9mpE3mRe9eZkaCGHwL2PjiCwwahT1h1kNW0YPER1BSkmNvVWFMHg+2fiFr9eTJlSx7OkRjprGvHfx+MD9MAQOyhYqiMyDbymmd4uyMZN9+AGlaEVlVpbHcrYgoTlQKf2PAi0SnMK/KYtfwCyv4Kcr1YxhvS189/Ka0tiDV4J2n1t/B5YC5C9J4Pl54DnAgRHWr8pERKPvwLo7W+bZjewbs9+W14LN+1U7WE9E0I9vFYP7X3PC+K1xh8DsGKDq9PN8hEodDAwFqb5arj81vdNLYT7uPWQCeX
 qbHKRN/w
 8SY0a7k5zMRyoRFoZD9GVJPjwU1saYEBRebM9ZjxPmQ9vzBwdZ3V9LmGoIWRONPGWwYiTxeoJKW7gbDEAyMlzY30TuO6i8QAPMZnmNOfAIC2WobinWKq/pLIJaztBBMkGWWlMZ+/RURMhl23oLN6LnlfaItVC/9amrSlZwC736MUrO0Sd07M9gWq3A6SYs6arCECUpz+ZaiKvQK6A1V0DNux+xcHXz6tn6CeLUFI9ryQUaTmCb7BuX72gM7wrcoA/ct77oH7C2svtY82eudY5JhNfo+ox8Bt+dnGD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Return the pages directly when calculated instead of first assigning
them back to a variable, and directly return for the data integrity /
tagged case instead of going through an else clause.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/fs-writeback.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fe..11fd08a0efb8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1893,16 +1893,12 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
 	 *                   (maybe slowly) sync all tagged pages
 	 */
 	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
-		pages = LONG_MAX;
-	else {
-		pages = min(wb->avg_write_bandwidth / 2,
-			    global_wb_domain.dirty_limit / DIRTY_SCOPE);
-		pages = min(pages, work->nr_pages);
-		pages = round_down(pages + MIN_WRITEBACK_PAGES,
-				   MIN_WRITEBACK_PAGES);
-	}
+		return LONG_MAX;
 
-	return pages;
+	pages = min(wb->avg_write_bandwidth / 2,
+		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
+	pages = min(pages, work->nr_pages);
+	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
 }
 
 /*
-- 
2.47.3


