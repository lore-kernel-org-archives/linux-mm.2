Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4925CCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16DE8E0016; Wed, 15 Oct 2025 02:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF768E0003; Wed, 15 Oct 2025 02:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD9E8E0016; Wed, 15 Oct 2025 02:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79F7E8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:27:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 479681A0B23
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:27:40 +0000 (UTC)
X-FDA: 83999367480.24.6417EC3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id B3B4E80015
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:27:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VLVl2tc9;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf30.hostedemail.com: domain of BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760509658; a=rsa-sha256;
	cv=none;
	b=M6/HiZW54gFY5btc8rjBwFX0BF+Ag6Z6ZIHQp1BGgHG0M8dKgm+wQkZKFUW72gVX/wpxzb
	VAjLBjyufXDOxs9fP1mDTgbTik098DNvVIOMru1UD1h3VwDQ/9X3zoGMlSzE2eLCDJNc6i
	3hYNw5fYmwbxOUVDr/f2hm6bCJJqw2k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VLVl2tc9;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf30.hostedemail.com: domain of BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760509658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekZhIfM5C/lWrCsA+6fzUl+4ua+pMgg/ooJWvANRBeM=;
	b=fqFqSLI22lcwMTMumzAWTNTTqFUX8O3Rw9hpql26wcN6tbRHng0WP9/nT1jqW6lPoA8FGA
	fmQ770tC0UUfH9IY7jqVCUtRJjeqTdQNxsBNiHzpRrfAEh8xkf9BZ3lqR5U+jLAf1Uy8kL
	VpcxXVbpbkjbZkUWAOIA2Ujzp9ehx+M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ekZhIfM5C/lWrCsA+6fzUl+4ua+pMgg/ooJWvANRBeM=; b=VLVl2tc9wlmvFwkZnVpSIOjJMh
	BTQAuCdxXuz2adRqEZaUoKBgcZga8MQHx3T/L4OJ1UA+Np4AWxA3SZR85bCwSHnRcB5M4uh+2aG/F
	xezJMZwgQlnMxE58pL0kOxVDXadZfHonEeCNvwGUZrXGl8i6AJklQifzLGtlfitQ39H0MG6kw8YF0
	QKe4STFy7qLJB3LdtZcMrvBhUqonycHKle+Q4DJKFfk8zoLiFVt7b6vtra+gJbkeY440vtFqGFIME
	zp1KZmDMPsYNfqS5FWJQ3ZaO9LH366qOct13oYgcujpfayNuIiuDp4o1vMBQGy9pUANjVkCVDQiHK
	GBn+oGpw==;
Received: from [38.87.93.141] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8uz2-00000000bCz-1TPX;
	Wed, 15 Oct 2025 06:27:36 +0000
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
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] writeback: cleanup writeback_chunk_size
Date: Wed, 15 Oct 2025 15:27:14 +0900
Message-ID: <20251015062728.60104-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015062728.60104-1-hch@lst.de>
References: <20251015062728.60104-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B3B4E80015
X-Stat-Signature: 49zu6ru98b9t4dkzrsmpj8yzwxkh6611
X-HE-Tag: 1760509658-262534
X-HE-Meta: U2FsdGVkX1+kvD78Abqy2LAwQ2UI2m+c7g43Fg0xIrCzRTVcflVFQUOnRywB9jgiVDY17FixcLGo8cH//SGvH3bWaMFsGiwpULGnduNKlfroA8tU6puK8oH8JsAwBSaEsJxzE5+dqqJhQLz8FAfhaZJ9ioNLqscu5VrqcDo+wvde4SKzrripj4FbPM/aCfcA0zj1ZTZXM8dbtWmU6XIiQXVsxHC7QmK7ey8PK5G6xFQQLQdDKqxQ24Dm6SzYtXbE7nzZZ052Fk1jOXH9igjJHFhgoateLMAx9XY6UX3k+gNIgANzXwZrUJbhLlPUzxHTChKNH84gFy160gnFBuYGdknpUN1FySyDDbDiqe0bBfMahmo8XHGT6AaaGcF6DVXQjxcRca3QPoc9yGKDmrmnHz1yxnhpx2Pr2uZm5G0zoVc0bdi6XwjecFvsCMSEBrfnpkmZWjy4PgPRnDbQOQxwTCXoSRRRvBKT4QZskLrPD+jVRmqhNQDqCncgpVIppw+M1YpuDiotNcgyTInmIidqQqkSvv8Nl9LoaOheWNWsPphcRbG+oeS5U85paglk89p+Udpcp4GV+qIyVQ06WYofIugBBaIWDwB1pyH27KvH1hGgT1QlV7Clq/ynGD/K4NLi8aT5it8k1ZWAdNClzZgdYvB8EqNdud6+NmBcZB2OVNI9APRJWHobgji4/9tmk6H1yQ0UShH6O7DVbW0EgHKZJkm5eFJEDJ0ko9GAezXnVzrwF55htFBy/W6NUiWIIuxAb3wDSY5XN0zV+0UNs1ynqU8pRgyZSd9OaQFHmI1oFDJSNOJMFt20S3hkQcB14XlRuVnhQ8dydBZTAHkOOh3jGKUaH0zu67Y/Uejw7HLQoHA8AgDwghQeqdS8ITtrLz/WHohgqbBHkB1jrFsg5qB9r64CUy3AZc7vLmNi7v2xB9+8YuWKOXjtv9Gfm9JRAC0WB32SNbtN4cE23ajz5Kv
 OPSKMgMy
 N+unnshgPCTCl9IHSzRBki7ed+8eNcbmNZ1jssh8EwCNTlZugcnna2IHCAOiyTnK7MPi8bq1KHk+2ZBSLt5dd/k9A9TTl8yRFYskzgQyIOYEiiKgkZMvzYCMAhYOKIuQkg91rxRpN5ivANVFhQPpfYt7VOVGj8w6BwPMVh/PXpOuSLQQ6xFidA/rtvtIWKG6lDAR/u9EroEdjxHHv4e+V0PP3K7cE2tcFMfbn1AX1vO4PvSD4QsOU5jJmhmKHonQ3+TmcYlzhtWi5wx/gF46cubXxqtDaeCvZNRD2dDTenXOA4tbEuQygGOSNgQPemLcY23TGsuJoUYXyleQLuNV8etSuQflQi4bZymVTEstCS2owpYJEqptWoS5RwRUBhKHY43Ef7PloCJk2L1XyiFb/XnH4KADv9gCidpZBGyRLltOhhBCXZYfQET+N2I/ZNNO4wEn+JMCaKGlk+rAuai/O1p2EfWQKVF3W4arpiJ35Nl6ktG2ZYQpx8qjl+S1oPvYB9miVxna0ZfthQB9/oO/DxhYijgapRhvT/UsV
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


