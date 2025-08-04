Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772C6C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8D26B009C; Mon,  4 Aug 2025 08:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190756B009D; Mon,  4 Aug 2025 08:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6776B009E; Mon,  4 Aug 2025 08:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED3286B009C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:14:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C312576F9
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:52 +0000 (UTC)
X-FDA: 83738968824.26.3F859D9
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf09.hostedemail.com (Postfix) with ESMTP id EAAEC140008
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=y4Rv0tCm;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754309691; a=rsa-sha256;
	cv=none;
	b=eP7RMh+UcGbSX8KqyyGd9HJpDpMB6vn7+5EDs3l8pxawFvss0xDsu3//iDXhzguexr7YRo
	v3cfVwax72shY1zHtVePuvt7ztUkcls/sZUrKhOnvbXd42Tda4AULoGJqnyT6evLd7LMr/
	2f74MTyEt9BV15pbBKLJwhcsmDlwdwY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=y4Rv0tCm;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754309691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUm65lZP53PD6UFdCNM0FQrwo2MXNsuP3026Ad+nKaE=;
	b=dP7/CGG16PF6stESgKOTGJu68ZiJ8Qs9MBJpObx/AT3bdyWXG6bSQW9+kHbFkbrLCeZRnY
	G/WcGeK3pG5zbSablAaDbDOC3KX6eD2Yets+nmqUUKhBULXDvY/gVcT2gYptX0YLfxGOc2
	B0ep4pdOBrqJRgYOfTOvE8llwDenpmk=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4bwb8l4PMTz9shb;
	Mon,  4 Aug 2025 14:14:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754309687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUm65lZP53PD6UFdCNM0FQrwo2MXNsuP3026Ad+nKaE=;
	b=y4Rv0tCmaVgD31H5miqrX3K20uYG9fm+wdi+/Sy2amT1kSzTYClOtvSxRGbWkTh7kFtx0g
	HHt8oVU3das9R/nUe4juc6tSW/A/5Tyg/Vyhd8pMoPLi4fWGep6y2mdWg4ywbdETFHVqg9
	eEeU3Ir4814EluMrwjX9DdiMn5Ts3LaS58zGSQ5/OEvLKgZvlm+jqdCANukxTaEsK3vYJ3
	z/gam7TBBVKILGDRxrO2D3XuJoQIGggS9XlZArNyWQwqwCEz69FZagUgzrkIbqSBzZ5cd7
	Klh+d92S00osdmGx6fJ4NMhLIKrjKEe4+/GEXYY1UMII3FMMP4qCuF2mc2goBg==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
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
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 5/5] block: use largest_zero_folio in __blkdev_issue_zero_pages()
Date: Mon,  4 Aug 2025 14:13:56 +0200
Message-ID: <20250804121356.572917-6-kernel@pankajraghav.com>
In-Reply-To: <20250804121356.572917-1-kernel@pankajraghav.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EAAEC140008
X-Stat-Signature: 1cyaw385t9n9j7eu61yewdszcx3ryyg9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754309690-895987
X-HE-Meta: U2FsdGVkX18oxB1v0ShzWxWxWnD/F4uPsQPzNGuHQbFupUmFbz41xzoU6BbADsESRAFlnN/gJo5F6D0pjceoJpbOu9OCeu8MxQebj92C1jnvE9lOJnB+MpZ0NCWruogK8qexerBKGvV1Zrua1fTM8X2cyJsiZ3lsbjBBo6H7+H0htDbTmPsn/Cw8wOPE6NIDTiTa0LaevB/DFcp10m2XQGo1tk49BRKOF0yQ7LG4kIC8hfJGOlTZ2zGZDTNMJR+XpHHKA5FpTbS4rqL4va870uLU77FJqo/taMyycD0l2LhowJOBS1fjEg2K/3PV1q44VA8swZoFg0lrDQPidCyluZMI5bIp/oAVtVhtO8KGT8e+2gFHjEBsDol3NZESA/IRv6iUOyxl/nm42PAm9Nn8kiR55JEsjA5IR9oobgbCJx36MQGcLAxekkiSlvgNmD3AW3ePpYEai7052F0m0UlN9S4o2m6TaYUeGb/y9sT3/RiUH0AC9Rl6U/gCLocg35btAjpoIjt2F4KygfGThpHekfGAfrrV2jmnDcoWcJRDKg6k5oihXKhcq61gIdLnxgtK1wdwnJMzFrKyNSJnYMCDOyRXeds2gud19bOB7Dekcqd5v+vW4/0n/juclUOv3ljuGfy60ue2tSe0PbFAGjgYaAsmw+x8+rVcUk/tCGnRK2o1jufMvl+PbdG+10XujP0AJA4xo149Gvge2u8fRQwH6+ZroISYjwwloa0ckxzLXGsI/HKaww2KLdaHq6Udgmt1BOP1G+rzB2djVDApeTeUrlSAM42RpHmLdFaaSEER5RTwLFiSx3PDrP8kJW6y92F6d4hlWBqNoNI6BPG9w14ErAK+v4qJxo7dWmBsL0h16mIe5H0teCt1G01c2iSdl5UY2KmDjgvO8pHHjZaRBrBhGCIDI1IYUjYOi015hbJq0YrRuZ1gGm7m1zSdHcupEPKR9PmOym4dNLv2o1SbJlV
 2ZWG8LwW
 rzQ550oyKl2AiNW3Rur/f644/xlxm3qjcNTx8ULHsj57Vh8oyrvyp2GH28/WnbT/NPpWzrqmNBKzHQmSB7EM/eZvVyuImdnyyOwHO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

Use largest_zero_folio() in __blkdev_issue_zero_pages().
On systems with CONFIG_STATIC_HUGE_ZERO_FOLIO enabled, we will end up
sending larger bvecs instead of multiple small ones.

Noticed a 4% increase in performance on a commercial NVMe SSD which does
not support OP_WRITE_ZEROES. The device's MDTS was 128K. The performance
gains might be bigger if the device supports bigger MDTS.

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


