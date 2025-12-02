Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 061BCD116F1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 01:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84AF16B0030; Mon,  1 Dec 2025 20:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8876B002D; Mon,  1 Dec 2025 20:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677F96B0030; Mon,  1 Dec 2025 20:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 599896B002D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:32:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E438F13AF16
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:32:20 +0000 (UTC)
X-FDA: 84172805640.23.6AC347B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FD028000B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:32:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TfesHhul;
	spf=pass (imf30.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764639139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8E4pp1IsjSSPKJuplYD2tkMc9UabvLY5N6Rx9zkfNQ=;
	b=G5q+KCtAPjKjNMBEH5YJAhNFi1/aeMbQemHNlxup9fBHSFIEDYfyMHDz+ZOEBn4t1OwaCA
	JTiKbGyGyY672fZ34RcWyVBuLHBMc9DWZeF/fKcnKasuts5fzXW0z36ntHPZoY0j4/omDP
	jvBvMnw3V6J3abVQSpvZ9BtaSRxtbyI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TfesHhul;
	spf=pass (imf30.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764639139; a=rsa-sha256;
	cv=none;
	b=z5rj58RpepFaYNsj0qqK3xtv/lw94jbyfiZQFm1AD0+/6oyISSdgSpeLPRJoMZrygJiq5K
	4xZOp7JLy/eOTzZ6ies6sLGkxfMD3ZdcXBiXO4Ygo3OXwWGg+r6qEs+qXMO0ogr326v4SZ
	axpJltqy/oJx44awkcNX5UTy7wGSvh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EED546018E;
	Tue,  2 Dec 2025 01:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EA2C19421;
	Tue,  2 Dec 2025 01:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764639138;
	bh=maaJ53Q77+6gbWSVaFF16EdbEzSFEsMDPs9d8wMR348=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfesHhulAARCaWEEvqR2qBeDi+/eGQMLEd12rY/IidihHRipCxAdGhr43Es2/8WMw
	 IdLD3ArmUQUi/qIeiGFEphbbmsunT7Y0hyTuZ7i66G0BcXblNmbXrZcPMAPot5l8YM
	 bN0cKs9rturzc9J48Tw3LU+vlHpbMe1EAEKnQBYdqripsG7b/4Q0qEqkRJakIG9X5V
	 T0NbjEFNCj50PGkZAa+vYW6AUiaANPkyAA5+d2l53doAEUrhW4DtNHoWpDQN7fo3LI
	 Gtgid7jx7APSgCErY9GZto9uE0epdw+zOOQVHPnggR6ECI2xvM6yxhrOGKhVeEKFj+
	 F4H3rf91kwZbA==
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/3] mm/readahead: try to allocate high order pages for FADVISE_FAV_WILLNEED
Date: Tue,  2 Dec 2025 01:30:13 +0000
Message-ID: <20251202013212.964298-4-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
In-Reply-To: <20251202013212.964298-1-jaegeuk@kernel.org>
References: <20251202013212.964298-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7FD028000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9zrhd88eyshi7d1pjxnuanoi4uzbwfjr
X-HE-Tag: 1764639139-570151
X-HE-Meta: U2FsdGVkX1+U0e7tuhOvh9Z1qAutkVUgP+Cp3jvG84ZxK0EL0MNmqX09qL7irlpiVNp97yL/lOGt+eSmEGn6nRrbvhEANswhtTYyBm3ChK8flS2gb52t5Rt0sECImVkElLf6cohh/rzcOV1JOAjs2tDRsQpEYoJAPubuLmI5ormqBrNSTk2DqS95NcLiALpVzrz0EelHzovtL/oeN7lM1Ma4yvtWZEFj5InaZGOxS4PS1Zs06qbTu0DGmW8GYI+ONXmfUiB6+SkqEKSw9D00XbY/EvWyeCzSiyUgaax3OVAkKIPOvHa7DYpj8OrsZwYjO6Pemx+T+o5oDCPv4KDYtyLQvQcxbQArMc5OZinZcLJmD1pITzZxpsNIvM1Bm2daBnNiR1l/s3B44dhqpNP3eDKnn9WLVba0BmM27E4ed/3dx9EFq6y1aLuxxILCy2LcnH4GUaHxiClNtELq2x72lsArjAN+kr2sBrjyAe/+NofI++vwbvMjbp31y7t4AThAPmIvTvQy6TIdgtVlh2jrokZRNBn+0S3ho6nG0+rHF+3id30EnrQTO1NSEChuTSN47RMNVPk33Hddzd2B7hbmraXjul3ea/vtmRfe9nUW79AIuLDVNGsZulciWADgW+lYHvCu+yhUlp2C50RAOfTkQuIuxK4YnyxTfzIW/K5U2BzpTAGvwoYdinJfOxSJ4GCoYzGeBkYbvcj/5mlzZzwHaEPYRH9XYhcvfkxMUKMp4cyDNPHLyfeGIv5EDjb6WR2wGiJfU7+3oftoRxOyeJWTUdIElRh2kBpMzt3pPjBXUxBsb8LAvN+jtayri4jZ+qD5Yk6eXPAKIipDqR9A0+7HnjTY2jx4r2nFqYfBYwKTrcj1CoHkX8WfF+z2Uugt3FiqUQijtRTL7IYv29gRKAvkZtwdyEUEx6HKvhSHQfkyvfHADvwhcobs/Qss7unEMyywEoooVJ0/FOq7DcAmEc2
 5vq086Ss
 6BY/a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch assigns the max folio order for readahead. After applying this patch,
it starts with high-order page allocation successfully as shown in the below
traces.

Before:
 f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:536870912, advise:3
 page_cache_sync_ra: dev=252:16 ino=e index=0 req_count=2048 order=0 size=0 async_size=0 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=0 order=0 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=2048 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=2048 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=4096 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=4096 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=6144 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=6144 nr_to_read=2048 lookahead_size=0
...
 page_cache_sync_ra: dev=252:16 ino=e index=129024 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=129024 nr_to_read=2048 lookahead_size=0

After:
 f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:536870912, advise:3
 page_cache_sync_ra: dev=252:16 ino=e index=0 req_count=2048 order=0 size=0 async_size=0 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=0 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=2048 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=2048 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=4096 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=4096 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=6144 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=6144 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=8192 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
...
 page_cache_sync_ra: dev=252:16 ino=e index=129024 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=129024 order=9 size=2048 async_size=1024 ra_pages=2048

Cc: linux-mm@kvack.org
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 mm/readahead.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 54c78f8276fe..cfc63f7d5e81 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -593,7 +593,8 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 	 * trivial case: (index - prev_index) == 1
 	 * unaligned reads: (index - prev_index) == 0
 	 */
-	if (!index || req_count > max_pages || index - prev_index <= 1UL) {
+	if (!index || req_count > max_pages || index - prev_index <= 1UL ||
+	    mapping_large_folio_support(ractl->mapping)) {
 		ra->start = index;
 		ra->size = get_init_ra_size(req_count, max_pages);
 		ra->async_size = ra->size > req_count ? ra->size - req_count :
@@ -627,7 +628,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 	ra->size = min(contig_count + req_count, max_pages);
 	ra->async_size = 1;
 readit:
-	ra->order = 0;
+	ra->order = mapping_max_folio_order(ractl->mapping);
 	ractl->_index = ra->start;
 	page_cache_ra_order(ractl, ra);
 }
-- 
2.52.0.107.ga0afd4fd5b-goog


