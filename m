Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461CDCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9CA38E0015; Mon, 18 Aug 2025 02:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D668E0013; Mon, 18 Aug 2025 02:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C4C8E0015; Mon, 18 Aug 2025 02:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AED3B8E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:58:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35CF4138FC6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:58:33 +0000 (UTC)
X-FDA: 83788974906.18.356309E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7800080004
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:58:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="N/UFkEmL";
	spf=none (imf30.hostedemail.com: domain of BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755500311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Am3rhvkj1HDRHYITqQ4Yl4Zll62VZGAnL3MYltPMarQ=;
	b=ou1yA1WjhpomwnvDUPw8cUsL2ANeo93sfrlWzkPW9vY/gkVyXVsbJvJl6DjSqvNO0rbDfA
	vcKI8rxeFsBHraNSc+aRGeiH0dzsfOPrJcsx1sqzEBTfM2Mf/2cfmdl9HAK7PvKSuaPUxr
	sEEBCx2Q9Lm+haIVXllC5fM0LwpPnf0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="N/UFkEmL";
	spf=none (imf30.hostedemail.com: domain of BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755500311; a=rsa-sha256;
	cv=none;
	b=XfMkWKO8zKhFg5vu57zpyFJ+fwSDsPjdgmpaWqQqzmnwwZ8wOGltAHulO+LPYuRtx6u/0n
	wvjtRoLUKY3RK8JSVfLPozF+vZV9ckABw8cWfacPqifwOUUqjhgbWVNRwrhz/90EU1oycE
	OKrEAQlOxSpQnafrjX1FtTK5oc6qmrc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Am3rhvkj1HDRHYITqQ4Yl4Zll62VZGAnL3MYltPMarQ=; b=N/UFkEmLQcsNQvpe6Ho+xfC6EE
	pWoPB1MlrFGGQbWL+wXmCroFBraPb7xm2tbxerHxgZmIcdiNUWpt9O+zqLGbCrX1crz4wMB9amlLW
	z4gjt9KocV/EwpEdpl+eq+b+yCdCjfphG3qgayvm2eU5NhtuPsHTrqs9EtO8xwQF+iIcP/txGmIw8
	bx3cVzLka9UbbuGGGvvM1Fxr7QWERlue81n5TsTfHYFhBAqIUD+nwLWLVGuI89Q/y2eeMCfJUW2ZL
	AcSDUjnWgbXAPuuzUOYeKmeNoZD9y1e3AUfYO8q3VX/hUJ13jQDrI8UXl3WZ2lwiHjmG/Z5kMP0Ta
	Pvkf8d1w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unt4b-00000006bmd-0KlO;
	Mon, 18 Aug 2025 06:10:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	linux-bcachefs@vger.kernel.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] bcachefs: stop using write_cache_pages
Date: Mon, 18 Aug 2025 08:10:09 +0200
Message-ID: <20250818061017.1526853-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250818061017.1526853-1-hch@lst.de>
References: <20250818061017.1526853-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7800080004
X-Stat-Signature: 71f4f7c5fg1cr8qfij84k34mnqxyk9uz
X-Rspam-User: 
X-HE-Tag: 1755500311-87569
X-HE-Meta: U2FsdGVkX19x0nAEu+TdJhmiVu3RW/A2qTyTLNhd2f1K2Z+fDgLmIN0ad09D34l/SiQK3yzudG8c0MKm12UDxlmWtbGuw39mffxnjh2zmpVSiTsv+ey08aHfg36mvZ4cBlN2HiPq0AgrumskGF8EV88KZYTSgC/UfKlWOC48F9vd+/mfgxGHcUPpPeC0isPQhJTlCOR+Ql94SxjPY0bkZN3pL3QeuUsrDhotWP/e7XsesaCMQKCfVtfl97LBr1RtTlrsBPL3pdNPY/4uWkUsQYDp3hymVQ7p1WdETkLwobp8WZB2Y+/swlC/nw/5H0t8Sdo/RoI00GWe4X/jieJ8mF2pGn5W03qKBPcKEetJHeqgExRnwN7uGvntK9+SIgjMOfoA9gSdoBVL8BCrALB5Ato8O5LTd2p/UJXSO94e1IplbFKbwvKd9EUvTEyZ1lVAxOXbZsQnPXKthvNKK7GATPbA3rnY+demxdlVTot2R87RbbG1xfy+mUwrFzdJEc7aeRvPGV3MfMsozxFnZhLpuxlMww4352zNi8/wPbTzzpamfFKmRiCEtoonU/sJj1GmKx+hrOZPUjESTHDQggVSnFo5GeDuRUpEJQgYoiV8H4ndB8cA9Blz5sU1IjevuAgXkZbEPbC30v32OipmK8lahzY/oemt9JQFpBICxnXYMY4GGSp5RHf89JLeqeG8JS+O6snuQ3FXQ5DmDfBaef/jNopfbnwZgHOLGnNgHBzIz7D9AzNIyC4KeE6aWd1DnrszLyXs/y/2yEL2uwp7Sd17ACfVrhjerW7xDkOwwaYM8hranA2nUHRzzs6lafII3F4lTdZqETHDDbnd5WM+jO6rP++tc2UViC4cjIgSG70UUZLSytS6cN90Xg3Vur8/d1130qG4DSU8n0oiqFg3vFtAbzHDK4XKQpyWN07fzlnEBzPfTbALmB85n9S0MMDJHchrx+w3XXvckinoWL/paWS
 FiZkm1bA
 +0U8uTw9Jt0kuLX0O87cALcx83h93Jc4PVPcs9FRtS47qpHLBDL4c5J5UeIh/+3ZLITnTyU8fiC9DLwVZo7VLL657zm+Oe+TeU7nYOCvFgI18kiWvokkgAxjgvRSRe+Ph9rG0R/0Va6MJQo/5LMNzWmhh8yHVxNCrbK362i0dj9HRls1E/4FyfOpoyZa14yyRQmEiWyDOL/QU7w30AvUF+U11qawwHth8U5Jn2IUrJ1ULBfCPILJhrl0By9S34wmLh/OrlTf0pPpjtB1p1n8rWAeT+rhUd8/Uj9WBSlzCezs3RWISqku0F4UgC0FAMJhW8MZGhYfSFO/R30KGIUb/met08rJCIQyehDMi73AaxwaxkIfhDl455FiTL4p3/8oFN+Iy8JWrR6dfb44Ln4qM2uDzaTNyOj2KLwDv9VJ9OXmBGQVZFQ5NwB9wAG4lQdRA3UbViFUxvSC5X9B9Kg8BA03sDfS3fSDC5OsNp11yyE3Z4fUf+36dbc342gTVH6LO4SCfVviUwWgr6pp22uEfOSL5lSwOfK4sGu9/VuV4gHHLd8P+qD5nul1aKiUr3+0Nt/nckhp0FfxDtB8S713UI2NiXeCOVtTpzrKD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using the obsolete write_cache_pages and use writeback_iter
directly.  This basically just open codes write_cache_pages
without the indirect call, but there's probably ways to structure
the code even nicer as a follow on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/bcachefs/fs-io-buffered.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 1c54b9b5bd69..fdeaa25189f2 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -655,6 +655,17 @@ static int __bch2_writepage(struct folio *folio,
 	return 0;
 }
 
+static int bch2_write_cache_pages(struct address_space *mapping,
+		      struct writeback_control *wbc, void *data)
+{
+	struct folio *folio = NULL;
+	int error;
+
+	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
+		error = __bch2_writepage(folio, wbc, data);
+	return error;
+}
+
 int bch2_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct bch_fs *c = mapping->host->i_sb->s_fs_info;
@@ -663,7 +674,7 @@ int bch2_writepages(struct address_space *mapping, struct writeback_control *wbc
 	bch2_inode_opts_get(&w->opts, c, &to_bch_ei(mapping->host)->ei_inode);
 
 	blk_start_plug(&w->plug);
-	int ret = write_cache_pages(mapping, wbc, __bch2_writepage, w);
+	int ret = bch2_write_cache_pages(mapping, wbc, w);
 	if (w->io)
 		bch2_writepage_do_io(w);
 	blk_finish_plug(&w->plug);
-- 
2.47.2


