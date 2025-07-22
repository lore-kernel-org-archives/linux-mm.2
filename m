Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55038C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 09:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB536B00AC; Tue, 22 Jul 2025 05:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB226B00AD; Tue, 22 Jul 2025 05:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A5C6B00AE; Tue, 22 Jul 2025 05:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B357E6B00AC
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:43:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 842E41A0348
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:43:12 +0000 (UTC)
X-FDA: 83691412224.13.E008058
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id EEAD51C0008
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:43:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Efis9zG2;
	spf=pass (imf21.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753177391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUm65lZP53PD6UFdCNM0FQrwo2MXNsuP3026Ad+nKaE=;
	b=my9MNCxSs+VmQBwgF6WcHHtPydlHLLZoJSe3l6U6nMbcI2MvGqmo4QhGwWrGTbtlc8cF98
	2pJuagq3q+cclRGsijhd2nnXsuW0agIvlZVfgm2QojSnLijaAA1oSBT719xvxEVL/xiUp4
	vA6Sl1QwMCM7dA0PjzhIlLzIEOAnlIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753177391; a=rsa-sha256;
	cv=none;
	b=aB4xwUaEgaDfDH+Srac0sqP8KR4qet0a359iamCEhTEyyAoAYI939FXaHG9cIhVJEHeb1d
	2IAjDE1EsxtF4rsxWqE0vFYjYqIGcTZGGgAIAX1L8gk1K7Q81dvVbyQ/A3I3BKuTnF8W7I
	5adCrpaUJZOYmcQ3PQRorsS7vM3w13E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Efis9zG2;
	spf=pass (imf21.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4bmXPl4jqbz9tVG;
	Tue, 22 Jul 2025 11:43:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1753177387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUm65lZP53PD6UFdCNM0FQrwo2MXNsuP3026Ad+nKaE=;
	b=Efis9zG2AFhnDaKHNu6VLJAZa0s+JO7PCW+HAmskd6sYfgHM8uOGelqq4Dmm859tfEBNnI
	7yiHwQA8BCj42OzKWdsvsIUJWjHw7hKsaSr/7YntG04NsVUXJtdgLqEE7/ht1jBTi3oRnP
	gyv/lAtAEzBsIfkpvABsXRqTtdkI9IHzeDPvXlZtsIZMzxUBVxbS0R4hoKn3UhSs01s+ui
	lso0abjlhe8Uaek8g8R3/u/umP82veCbh1j60PXUD5QIiEf+i/6zX3BHQwmvl+TGPNi8BA
	MtoxgdNCFH4NcyrKPOj+vxyjAG09+SlEbAT7NfxFQu8xpNyGmLdfHppSn7eT4Q==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC 4/4] block: use largest_zero_folio in __blkdev_issue_zero_pages()
Date: Tue, 22 Jul 2025 11:42:15 +0200
Message-ID: <20250722094215.448132-5-kernel@pankajraghav.com>
In-Reply-To: <20250722094215.448132-1-kernel@pankajraghav.com>
References: <20250722094215.448132-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EEAD51C0008
X-Stat-Signature: q91gphbm6o45f1ya8neerr6m9m9b5qr8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753177390-202083
X-HE-Meta: U2FsdGVkX19yNrEUeRN+DZqBXjs5v5tj07bOyrOQ1ZWZVQ8+bO3EKI49XbxYxWgkMtTlM4wHFEmUKI1MvHZ3k7ShvCDZGIo0XTTM5p+J2QJM2ghbogdoUWc3siY75QZEMSPDhyC1XxC+6dlv1eBa3iShuTENk3JBrQoGaTKyVZOyTjA1nKU6CWJ7JRHSCa40QfB2HGpABRnrDroQfu4OWnNHYnrYHQ8mdVVs4HTUWqlCNI2qNOmam2AiRPfccDQ83LekTiQC3Al/muCS7smf8hBf6mJHRQQ3d/3q8gQiSTOYmHX8aEuLyIk729vxbESJlOqNYNe1BaZbB09voDm5qBeRApeGrc5Vp2Suxz8uAv3FRZd7sXO/Q+ZbWMZoIawC68aVLLi023TYEPw3DLzay9+D01uaUn4g3EriAYunJB0ZskUlFZAclMj2yQCqXcYvlXf+FresBZGJh00B6fmylwyQBpPrY0gaoGyFdYzkxkPm5UeGk6lwmb66jxDe1G9EcXGzVYDR8rJixt5b6gFIpM5yFXg6HcCyFFEBU4BPsmomIBNMSpYFUbRbZsG4ArnNq8Ad3N5xlRnj6mTsZLqoO8j7N0wp5yGmDxfHFPpfH0krT2G96ms7llNPgo1iNgh2BfKeES7iF6+VVoHU0P04rrGkgqomRvqTj/iX70XpqeceQEa23y6ACeOvMhTHTMDPvCuU0QddZT57WnFoAOoaiXu4om7JY56Pn8t0fgJPvVuTNapdNQ3UsI6q7rxp80dqSfHVKjQWJxW0kLX2spVv3G74Jk6pTPyD+XojzaRRJvd69VVIZB04dp2xFjenbX1LfuAE/1TdC9NuPeKK5a8sBkwwnr9oIKv1G0D4+wI9ADRrkSqTyq3gWxJMzWQ2XK0tsd9aFLoazioAgcAb8e7X0gjCrv2oQA65TeBEyWxEBBT8JZpT0DsWCabNMA3knaIsYEPJFwfXFSBT3fWaHyY
 NcSCF4vW
 0D1ic2oXGaplLbRHhXZoDgcpyWQ==
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


