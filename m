Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1AD6CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372C76B008A; Thu, 28 May 2026 08:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4916B0093; Thu, 28 May 2026 08:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CC76B0096; Thu, 28 May 2026 08:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1E076B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:46:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5061407F6
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:15 +0000 (UTC)
X-FDA: 84816801510.13.513874C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 496B2160005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wxMfz6IW;
	spf=none (imf08.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCPt/W+XC11szOWtdus7mwxc6NcZEax6qcgjLuR4I9s=;
	b=x5g+6++Ttb5ERTzB2/8h5PuGHtY81AdfSZzbn+ywiLSmPNRP0LCs7++qUyjVvenmjxRYm5
	d9+AYPIlWMpQyd7yAxKDOVhRgyYQm/cywlAjwy0ykw/7zq7liHLkraiwv8D4tTsqhYCBF7
	DZVImhJt5MhxYWA0ufiedvpq4vWpnbE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wxMfz6IW;
	spf=none (imf08.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972374; a=rsa-sha256;
	cv=none;
	b=njuXqTopA62zB5uBPVHrOn0IpAsF5v2xeQKB8rOZfIPwH4kaKICbOZOthzJXqH7YIPcFze
	cLxkRkmnw/duWGvEPmfxiHixe0yo02qDva1ddhOK1AkyUmvR19WG1reKPYx33Cli2X/Wu3
	xpQORN8PGrsKdlpsm91FATkrTuItuYI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QCPt/W+XC11szOWtdus7mwxc6NcZEax6qcgjLuR4I9s=; b=wxMfz6IWX49IfhzRR4b3aeDNBg
	Fdgpg1sjuhACMPbW1MO+W2HPf9SXJeUlFA1OABG2fh9JKcVovFDZ0UMg3fuNuMQR3OwrqmA3hfbDb
	3cNX4+k+Pc8fUpbFfcmF0nYMmkI58D9k8n/eBEHWtdbOYfbOlKq4ufTK8vGemTorja9hYm4ClUqrd
	C2W1UZcsdSHXAMOcwbvt2oh+BaAN73KZ9b2YU94CaTJj9e6waKGUsqplR2xZyY/IvPDk7e6QuN4eL
	lGuVFipndzjxQl15YwFPu9zaHnHBuRPfug33FqZQAhS7x+rcutFzemUSjFP+cCoixSQHHfpOGJR79
	KdKuyYvA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa7k-00000005jdU-2AOf;
	Thu, 28 May 2026 12:46:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 01/10] mm/swap: don't merge folios for different memcgs into the same swap_iocb
Date: Thu, 28 May 2026 14:45:17 +0200
Message-ID: <20260528124559.2566481-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528124559.2566481-1-hch@lst.de>
References: <20260528124559.2566481-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Stat-Signature: 5rg4ipzn7iiw3kc8k9qjjdwe14hb5ozw
X-Rspam-User: 
X-Rspamd-Queue-Id: 496B2160005
X-HE-Tag: 1779972373-978033
X-HE-Meta: U2FsdGVkX18WBsuCgD7afBpFmXOT7FM8Dw8G4FHmsRqOWjJT1UMzEUfFDxp02FArVomriS9MBUItwHL9kFad/Nb9U+COyI4keWijyYOMVWxh8f5kZzs5R1Cm3eNkD37bLuTkdJco+KO6abVGdkQy4UXICowac1pzyP6F2IpZp6KwfZvz6aXpvlPmSMNlFoIkMBck8bM1XanF7aWCcZOM5GqyI83sF9TiPndceLknGF/NUZw+7JsCBO2lqg+uvncHRnz21hyXzIqC2c53ZV6p5GDueTLCVzqhV8heT6WchCgjvnVAk+Lc5QJRuxY2Z/NTTvrhLj97fjs2yzWBpRkdTlickiDk/snNvnz4bX5L8v+B7ru3mLm+z46bDAdq7yt9YFsPrRqYL2swSR0J0G3uiBp00Iu0B++CpNexAXw1ojhAdBzrxZbexzJMCXKHtcc/v5kwAu/CYQX2DmulpWwp/uhnFzAOILMYCyMVVkb/JHr8NFy7BPpCYKJXN2E3p7HfmXRxuA5ZKptBOy4j36M3xUaI3x25hmghmzSb1lM+po+e1KchNh9uxoR24ZWKgy/OC14tQQWx5spF/ezVzJamnszt+OdtSHYyqekh6cSe86t32NwUs4t/Tiw1wbaObl38J9wHA66/NYOErb1EyfmNK2u0qVRHb3JEgmU6h8/0Kq9ipwO47wQN62/MLKqmcRXA2LC01KxwJcgRHqexrcyb6yayFBlp9ZaoL2vHBtMqRLq/tXxz1u25LuvvWLpvUUmimyUY92RFlgxfsDZx8D2lTI/yxVI6t+yAKVcr78V/9igOyWo9q40kBXeY2hPNbOwBzLL0zfmMe/pCRFXEleNHQzTEpggsVb4W64cx1VwpMhgkLLLUBseQSov7aVGmnyLFGOyvXL7BrBNa/hoWz+qUWwaF9aicwUme95DmuUs1Ljn10nKZVR1LPD+AEiyUj2VVYe5RacHBBtQH7OGGRYp
 XgDydYtE
 TQZXIQvVpTIqzCqywUKZXO5eXFt+IGnwkxGLo3+4mBnVRNFZ6rGEwLFxxiqYKl3ffyhLnCR1TEIwCGKjA1zAquZd102Ki/+jLN13mccoq6gflVXirHAGCbveZ7NnIIojYlwO1XYQ8eLDsVeAU9KaTGmOGFIJCmvg38VA0GIiUQ/DxW05WdVmBzXfmaj+Sk7ZsakE22bV5YLWHiVcnyESFjdi3TZKokcalKasU8v/oPZH5JgHdB8wiHaZSUCqwGGTWZDlCWGSUwgeTzCozwnKdpbhK79GTHCgXSvHuprAL1r8ydXIIJ34n91CGMMkYtgM2j0gA4cTXpS7sx9geyG+CL8YTXzqrm4G/gBz1Bkbk4OkbaQ69eDoy0z5BVvnGrFE20vfcBKAdGuWR8nm/jvwFCYtthnha5dD6KyjBcWn20zIVLCxcD2IxGssr5GM6iyN1Hz6N0ghTqm9wsRkFehsEdQq//GAoCtAvmIxCUvTK59uM2eMSHwWn5JDsSCJHodAPqK8BrdcZpFnKERe8vPFDr/voXwTmqST021BJ0/QSVZqEGMbwt4xwialkFTt6mZITY8IaBptbQ2soYsdH/WIYkJ+IIhMzOwd0nk+6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mixing swap writeout for different memcgs can lead to priority inversions
and incorrectly accounted I/O.  For block-based swap this is prevented
by building a new bio for each folio, and associating the bio with the
blk cgroup based on the memcg, but for file system based swap nothing of
that actually happens.  Fix it by adding a new helper before merging
write side folios into the swap_iocb.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index f2d8fe7fd057..1aca1b0231b1 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -355,6 +355,23 @@ int sio_pool_init(void)
 	return 0;
 }
 
+static bool swap_can_merge_memcg(struct swap_iocb *sio, struct folio *folio)
+{
+	struct folio *prev_folio =
+		page_folio(sio->bvecs[sio->nr_bvecs - 1].bv_page);
+
+	if (folio_memcg_charged(folio)) {
+		rcu_read_lock();
+		if (folio_memcg_css(folio) != folio_memcg_css(prev_folio)) {
+			rcu_read_unlock();
+			return false;
+		}
+		rcu_read_unlock();
+	}
+
+	return true;
+}
+
 static void sio_write_complete(struct kiocb *iocb, long ret)
 {
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
@@ -397,7 +414,8 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 	folio_unlock(folio);
 	if (sio) {
 		if (sio->iocb.ki_filp != swap_file ||
-		    sio->iocb.ki_pos + sio->len != pos) {
+		    sio->iocb.ki_pos + sio->len != pos ||
+		    !swap_can_merge_memcg(sio, folio)) {
 			swap_write_unplug(sio);
 			sio = NULL;
 		}
-- 
2.53.0


