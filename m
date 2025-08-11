Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13718CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98F38E0018; Mon, 11 Aug 2025 04:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A707F8E000A; Mon, 11 Aug 2025 04:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986438E0018; Mon, 11 Aug 2025 04:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88E548E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:42:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F85A137C5E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:42:18 +0000 (UTC)
X-FDA: 83763834756.10.FFE0869
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8408440005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:42:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=rGm1QFmz;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf01.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754901736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hl5pR6KEXqqmRKm0XQhFRqtMBlaQMUsVvgjCapFINjk=;
	b=bD9HUK41LqE9SmQPnFGC7C5IV38SPNF46PNV2g7lLTXpjABBZUiDjIQR7UJBWb6sJjzTlC
	nYq/mBEjr42LI/Ln3TglxCrO+LiyPuAwDmgp7rAmOwRdziEypPw9a5uGXsT4KKdNVuWeIa
	OUis8bPOXab/SWFHGrUWrLTwSyNhnio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754901736; a=rsa-sha256;
	cv=none;
	b=sBro5je6ZQ8sBiqdPq9TR1cGRpta6Gj8C6ZJuHATblmPsWBeLydek6lg7SC4mcLvEyz3pk
	y+2SwIivdstJgDn7HBBFRj+vvx9g/8qxfDfxo3X0KyIVtgSeBHYH9N8YELx2Nk3t3CogWz
	cg1Xuuzqte9AHDc0pJ8cT5CbopiAOvA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=rGm1QFmz;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf01.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4c0p6F0pJfz9stX;
	Mon, 11 Aug 2025 10:42:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754901733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hl5pR6KEXqqmRKm0XQhFRqtMBlaQMUsVvgjCapFINjk=;
	b=rGm1QFmz51ShKNaeGL34QTmDDcDaTUPtXgDxX299EO84u8rhHXjtzpqUs8/3HQwAYYSULU
	qCRkrj9m7aIpWSquYSC0fDON72jTE4y6bFSEn7q/yw9Phr6z7w7v0lnAp2SooRC+qsgjiz
	fqgsO49XTmXAqE8lKgJN7lIY28fMc5kUT68++lKECB1z06gUhZevCMd4lnDW05FrPtaYyC
	VTk9gpio0Sl47tLZspolgNhZNKeNrk/8xSpMarUOjh7i48wT8+CZTjsMGvdC1WlwvfMU1V
	fA/uU/YJPVXL+tBbfJRi0yC54rqyc+ICu+I/tHg7P25mCPm6g73/CZl6OtkxIw==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v3 5/5] block: use largest_zero_folio in __blkdev_issue_zero_pages()
Date: Mon, 11 Aug 2025 10:41:13 +0200
Message-ID: <20250811084113.647267-6-kernel@pankajraghav.com>
In-Reply-To: <20250811084113.647267-1-kernel@pankajraghav.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8408440005
X-Stat-Signature: wczrqpqt7unr4dk5f6ws7m9q393nqkm4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754901736-629405
X-HE-Meta: U2FsdGVkX184s4SsnBx63v155/BnL5mXOsROm2ne7qjHBzjBNdXaInCupI+TxckDC2cAoHibzb+Ncl6sTbUvjhtzo/odjiuzYtH1czsh5W/356aEzGXUBuAyD4TeIC1OK4Qn97K6ZpcltX6ssK4eFuBu+i9GMCHG5+2mfhawZ7UN/5jF2uCoPmaQ4XOPPDAcbg6oRztEvtYm5jw9/UQ9Q5sm13faSSL174jkpACvjdZ7bs+CyaoLSvKBDGlSSL3ysyLUfJNOgsJBnmm2CrvFCogjnZomC0hodSlAnQLfVAhsisWyZY/wHXtQBBJmmhIvO9BuSidR5uJN4jPlCieKHSd2vfVXZ9NCOpD/j6aBt0ucjZgkg6eYFze6kfEZ9bqZHuCDVzVi08acwAYQrM5j4EZ+cLmfrXIOa9MVphSk5ViHykGOnMAwcWx1GL+h1wQeSUayTpr+Y7Wtld7TCnK3mVsnbWeqLM6rO+2TgZDCMU6CYt1ZN85Tmw15pj4xhiu5Wy0n8t8uj8Ts7U91AZNnkHgxJF8az7AXjfUhF9TDzOohgQYAhfZ4C2PQR2LwWPjNnCfWWz2yd57U/WG81ffyhjN1i9bpgYeR+mHMu+rb51sh7zw79d2wWhFb5qmuG7Cs+egYb6rBq4dbjEvzrD4rRLbrqgoVQFl6myOjAoXfYaGA/msKlCd56ggg1tU+sNDTrIH8GFG2f473Y6k5YdJY7856GIfvpVQCDoyZuox1U0a+xXRWR9RkORS587k8x1KiaAA2nMZRoKs0dDLD3zBUxSld+fHQDQKGVaRzuEw5DIrQ+NtDvrDa4AMdsfPZyDzwU4BDpXLDQIIqvMFp5F1xX0b0OT7BpR5q4OXdCTj+to6jxVYbAfPJU4OLtba1HPlQql7ZwBwEFc76e7fjEYYF6JfmxqGAPfYIpV+R6ghbCT+ucR5J/aW0Z9oPan/T39qNUigOQ0LCDnQ16r44CMO
 k+22hPot
 bVVi0ViEqRskvpDKbgUM8i4okz7i5DC1wKklD8OyYHcnZANpMr5y8gt8ZIbWCqGfpG2mG8MxxtT5QojSPHxlX+L/iW2m3yaxKyeWWwnlmUnJTMvq7J1GsC+7/t0eozZP3l1JeR3jMxwchX9qmf4Y+7u4HBARda4rCZSfi0R3VP+0kvlHlFwxXHb+svA+TLhz3ptcO5NYEW9+NLN9F54dVoxxFfvTR28eqvXqypaQ288cx+HpMS1NBbOLhYG/nb/WGP8+gn/9hTEijecP/APmhQK0kkwaWWYecwVxoiOSwM/t/Ny28S/IJxIMbxYaT7Gc7CgvzHJ9lv9PLj3jBSLqPP9aQ/AuSPB9V3YRrFfp8R4Q9I3ZWKgCDGpM91twGxg0nhkCTjOz0vmsV54vedURXn4XBfQYBkEPmDXAtM+dfdl5nGMpvQOitfP5rxdmUAxck60IFNBk6Ogq3xdE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

Use largest_zero_folio() in __blkdev_issue_zero_pages().
On systems with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO enabled, we will end up
sending larger bvecs instead of multiple small ones.

Noticed a 4% increase in performance on a commercial NVMe SSD which does
not support OP_WRITE_ZEROES. The device's MDTS was 128K. The performance
gains might be bigger if the device supports bigger MDTS.

Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-lib.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 4c9f20a689f7..3030a772d3aa 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -196,6 +196,8 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
 		struct bio **biop, unsigned int flags)
 {
+	struct folio *zero_folio = largest_zero_folio();
+
 	while (nr_sects) {
 		unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
 		struct bio *bio;
@@ -208,15 +210,14 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
 			break;
 
 		do {
-			unsigned int len, added;
+			unsigned int len;
 
-			len = min_t(sector_t,
-				PAGE_SIZE, nr_sects << SECTOR_SHIFT);
-			added = bio_add_page(bio, ZERO_PAGE(0), len, 0);
-			if (added < len)
+			len = min_t(sector_t, folio_size(zero_folio),
+				    nr_sects << SECTOR_SHIFT);
+			if (!bio_add_folio(bio, zero_folio, len, 0))
 				break;
-			nr_sects -= added >> SECTOR_SHIFT;
-			sector += added >> SECTOR_SHIFT;
+			nr_sects -= len >> SECTOR_SHIFT;
+			sector += len >> SECTOR_SHIFT;
 		} while (nr_sects);
 
 		*biop = bio_chain_and_submit(*biop, bio);
-- 
2.49.0


