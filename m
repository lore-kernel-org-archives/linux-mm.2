Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0720BC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969028E0090; Thu, 24 Jul 2025 10:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1488E007C; Thu, 24 Jul 2025 10:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1118E0090; Thu, 24 Jul 2025 10:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 692958E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:50:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C4ECC01B1
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:50:50 +0000 (UTC)
X-FDA: 83699445060.29.EC2CA0E
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6EA0F18000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:50:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=x76vEytQ;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf16.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753368648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUm65lZP53PD6UFdCNM0FQrwo2MXNsuP3026Ad+nKaE=;
	b=KQqxSaZL84bc4KMAqbwNpBEi00LH85lKjV5PqVzXvLMRBazszmn54e/yBITKzz4rlaDVRM
	QEG4/Ef6+VgOXEaJ6D0cKTY8l8GrkT5V4NENe0RlWBdTemS8KOMVzbRV0FgdJvD1qjECHF
	mAQd6TFxINjLFrVJoGXMjrk5OEtos3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753368648; a=rsa-sha256;
	cv=none;
	b=FO3fe1qP39QEQbiV9C1vmiLApH7DyZEsEAeCOBVIV0jrMHssgYuI4Chj5KS0TPp0Pe19Ot
	JstUH78BZXWOZlWL7K0hvMTpBmzythd6Y7QJvI2aY7vG8Ro+uB4vEdffr9u8msrwu4W9AO
	W7VB4DNSAzyx1idlsHEkludWqEqV2po=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=x76vEytQ;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf16.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4bnv7n1wFlz9t5m;
	Thu, 24 Jul 2025 16:50:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1753368645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUm65lZP53PD6UFdCNM0FQrwo2MXNsuP3026Ad+nKaE=;
	b=x76vEytQYOiiVL0uyLac3ejDCr+U69TsJRegMRGlNKbpDMYYg4GpZMLFlbbQ03qKsHkyGT
	3/he+Tjf5ia6zlRTkkeVh4HHNZfWPxH9XuB4olqTnZU33wEJLQ8Zqzs5TDhsLqpw/kpshB
	kgQACvOmj7yTzNqKfD4d/vQO30NUw1ysp57qkBzVeUA8V7H189iNVqBzwIwABxFkzTmqox
	m2BtWlsv9PfGbJIsZCwN/mHrKUJK+tazSBRReLrAQO308vnl0RQfQlRSpEgIDTXEowkh5U
	cxhDKCzlU88kiEbrA9wTAWTntaXCqvfUaabmIGGhFTAM7GNB75fIRFxIHBzqkA==
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
	willy@infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC v2 4/4] block: use largest_zero_folio in __blkdev_issue_zero_pages()
Date: Thu, 24 Jul 2025 16:50:01 +0200
Message-ID: <20250724145001.487878-5-kernel@pankajraghav.com>
In-Reply-To: <20250724145001.487878-1-kernel@pankajraghav.com>
References: <20250724145001.487878-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k16m56oxanw1xmj5o5f9a33kptpf8ns5
X-Rspamd-Queue-Id: 6EA0F18000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753368648-548614
X-HE-Meta: U2FsdGVkX1/kSHddhFkiy6IK6M+Fz6vnntd/9YeseWsvUQcrM9Y1WFWDmwmBbv0OtmtDapOnhLeH612K1RuBVSsjorkBNrkvcqv9B0vO40MJkCOFIymhRS6eb+Klvg5I8XhxLjp1WH4CfDIeKU+nxhthiHnrPc/lkQwDF4oeRMVOSjjv9ATNgo3sRZWKMHxu7z+93l6OKUicm6zYYFp2fErD4u+tlmdLO+MWlVp79HvYB62YeqOhvcDMhJnh3zRjyH4VZqogHVrxKYRDrVCu/6RwnZNwIvW++ntL1TSFGZEon8gUxCoRLq6eVzcjs2sRZDWFQlGghJSFujhQ6091bFl74tZDlUBkN5Ettu4yFJtJZ638CRhd9snM1cJ6/3vlA2YQn6E4jbN7Cxz+ii2IWpKFGbQLNeGDCukwTPAsri58YhNoL1C01TS33Ey8g+5bieY9Zb23hlpQTfUOS0/rmdcCn6Mx2jwOCnbCjSGzi1ykCRB5ETLprwjyRmC0b+/WHT9KI5qYo466+NiiTV8RDx7R1bJEhew8cLxTPGcLXu5JRiRdD2A0AkCKVY9ElxjuT4mhsgjxXVODgt03qegBqxm0dLiORZipGLf/zukhJ+WoYLfkmE4X6q7Eo/TwIYn5l01ZrkastBxKe39bu6lSBK+RM/lwntI47isIwVP3bL3S0Rx3l1o+tpth9DTN4Q6IAT2mYvCcwWdzWE76mUxaXqYCU8Hvv8v3rF1uidgcsTnl5KHgXc48a31HUrhDJQPv342s8l3PFLuQJ6j1lt0ptpJTG+opjkMVwhaOby54rutZLDCNjHxfcV9jujD+qLC2xT781ES71B6nMoPyr6gc8mnYz0j+2eGz+EGjfAl0CmKBk8whtpPDPv9jXMgZvyNxXo1in10FLBFL6c9VwhC0KDEajLB2ktk1J6GchJuhh+pkVwcbcySuRnRM3hUe0QFUQC8lAAvulc6tNOMKpQM
 IXvkFoer
 Vk3zcxu/wxSNWPeu5xvl7to7Isw==
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


