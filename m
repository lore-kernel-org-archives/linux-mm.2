Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EEA8606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 07:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ipFr4Whr
Received: by kanga.kvack.org (Postfix)
	id 91E2B6B05B0; Fri, 27 Nov 2026 02:24:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF216B05B1; Fri, 27 Nov 2026 02:24:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE9E6B05B2; Fri, 27 Nov 2026 02:24:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42B0E6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:24:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40964140141
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:24:15 +0000 (UTC)
X-FDA: 85480060470.04.D3809BD
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf18.hostedemail.com (Postfix) with ESMTP id B87F21C0004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:24:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ipFr4Whr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795764253;
	b=0eC6os2t3S6UGOFFSDTbjU1NBayPx2MgzqDNp19EBasuNsPVLMoqSCHKvBGPB8zg9TYn0o
	6nC33FmzYpStFELR2FIGx38qYTkqJb730rUFpDixhPpeyBaFAPLlnTiJ4n9ZvxQxtFd9iw
	jJ9U+HBzmAG5aWIUbmQ5VyO8hteRkLA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795764253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Q8n/+0yzOS8zRUOgySzo3szziagZeOEeZ2s5FzRuXA=;
	b=0NyqoMn5pl34MyX6PNiL4UvcVaNXQhhjvpwAfVNOCaOjMzbkkmHwvxj36w0bKy+od1sUzN
	ja3G+aWeX7zNFYQnyQttUj0pT7nEEVKxHnoFsL7Lbd1XLzpK8SJRe3svLfhNLMr3Hy1eTy
	9O/tOc7v/NXR0GP5mwjNp6v3opE+JAM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ipFr4Whr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795764242; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6Q8n/+0yzOS8zRUOgySzo3szziagZeOEeZ2s5FzRuXA=;
 b=ipFr4WhrIKSWDXWwamevVqpXU1lnOUkO6qAfltgOeDtDTRmyfzNj5kaoiy+Z85vCEi2d0V
 ohNrTMQqSr3KI4j4PLVMvJBuSenuJs3CTd+6l5ir1WYfOkxVXVDWSbFrvUbe5UeUvs6Tx/
 7anRgRtnfNGnNw7QcawIwLPjs3lSatnBU9PrJPs40oAzg3KPS1uzcehbi0+XCYTp6qH7az
 yHP9E+SeVSq4+7Er4+vZipLg+odSeRaMCehM1PAwUKlv1poyy8V8eJg6Ux3Y/+GRU6Gy2s
 SQfwASnnv4S+UTRcjbS90hYT4gnMcpcfSetxvVESGwDlmivLy39L3V8yoQnpmQ==
Subject: [PATCH] mm/readahead: read folio order limits under the invalidate lock
Date: Fri, 27 Nov 2026 15:23:40 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
To: "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, 
	"Andrew Morton" <akpm@linux-foundation.org>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Message-Id: <20261127072340.73758-1-zhaogongyi@bytedance.com>
X-Lms-Return-Path: <lba+26b093010+a2d974+kvack.org+zhaogongyi@bytedance.com>
Cc: "Jens Axboe" <axboe@kernel.dk>, 
	"Jinchao Wang" <wangjinchao600@gmail.com>, <linux-mm@kvack.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Content-Transfer-Encoding: 7bit
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B87F21C0004
X-Stat-Signature: jdcoahi5xp4u6kp1hubogaqcmu55mts1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795764251-576578
X-HE-Meta: U2FsdGVkX1/p1AcmeDJQG0XjUosuJsmMwzK6k4HEQCfIFtrTsmE6llunTlARB0bQZ9AjmMuuNwWnouF1vosFva2UxP/RX+VdXxGTQZsDJ7GA7sNOZVRnNqNVfo3jGIcBNbKs3sV0V17XzJJu2iLgmMhGRIG62h9NRK0Xp/UOybns9gkRP0onp2BLaJK8XI6wy81wLW9DBoKwqauod8siw5XkU+9q6jJ+xLePSTEZ2tcNuZ5VsjjmlYhe11SgaOvJMM++YawbWYEwDg91qO5DLJwqJ/eEUZIsudkwfPPHoDfzMqXmojNYMCh4lONNBO0b0oKeQDK7zXE6Ag0HHJ8bqMvead9h1MfGXtTv85PlHaKHgEMn5WAKajuDwDzeAI3Q8RZ6AYwewJK+dwgNps/EhTk80e5Uwv/thxQ5JqrTTxWpVw/Ci4Ds3cOAXv8HQkezzZ58mHE5WX74PsCLU27F7XzxHeLqm2Lw/74YZsXKuc1VO2bCK6rhNDcXLqJMn+Jhtgp7qHSJRpQMJGjIx8rN21tYipMIu4m5QP4aMQD6kitKaax0kF7a76FsX8FGJ/55uJXFVEK7AnsJSIXFq7RVummOrHhvFtpcweIG4t+WJH77UNKVnWTPYEglzMjFX3P32pb1gj1mhQv8i+svDrM2q8o/ol+F2m2FzabR8r0+ZbIqmPx69nhtCGEn/Bc+UDHS62/gt2iMQxfi+jrVxzBzvBAApXpjiN2VNz0/9k1gwj7yNavJ6MW0T53087R+8e2i6tJIfWfabE1FnaRpEsnjGcoKbvyM6dz86zbByNkSjRxK6rIVPjkkWy8PFskcxZCELiblkENzhvIjL8ZpPBSpmN4IEXntp+4S5/Z0VnDU4gZQt3xrjj93leEEBwXWI2ElNQmt+uCjf7SE8FkBQGj0yaEZVZZCevhj4Brbb8SkhoR8FyLOHcrpDBGgfirU8GEd6IDdOOJ+S9UG3THlw3t
 gmqtmSmK
 HRhyw7U6Gi2I5sJjhtpdFQPJ0s0b1ARzuSChnRccKH3xdv2E90EYQA0eoz+6Uw2mml69scFeCwJ/KeAL/sYqsO1FFOcASqzOFphKj3rK14T/FPhyT+4RkkimSiTtXFwqYtpMJ6fvhFtdKZGcp9YwmD5wgJemSPWLa18rgbukDJOH3D3Rrp00sLWfN8SnqvZGLL9xS/9TbqAfpAwPeli2uyaAf4EtSVnV9inzNaIdO8dFlG9kd4gIisvmSJOloegGeTjrbG2UOJpgM1SszBsam4FfrgJZ4Y7vj+//8N7lg180Dv1I9IjrmhDwAFrLkTHrTSATzSbthUT/POKlvv0sMczIBs+YlyD8pMzU7UYYNt/obq+qqg8BG6M5TxSmcqZyxJaGHSXYotZrLl52ISmNJlFaSbzRwl/dsFVKUXhLanJ3n5QOyGABsTthS0v3qWH6j6V+k97xa4Fw1yDoZ8o5zwYveOgIgHGzQC1iKnfao7nCRovo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Block device mmap readahead can race with set_blocksize(), which updates
the block size and minimum folio order under the exclusive invalidate
lock. page_cache_ra_order() reads the minimum before taking the shared
lock and can allocate a folio smaller than the new block size. On the
buffer-head path this can cause a NULL dereference in guard_bio_eod().

Take the existing shared invalidate lock before computing the folio order
limits so they stay valid through allocation and I/O submission.

Fixes: 47dd67532303 ("block/bdev: lift block size restrictions to 64k")
Cc: stable@vger.kernel.org # 7.3+
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
---
Earlier proposals:
  https://lkml.iu.edu/hypermail/linux/kernel/2511.3/04090.html
  https://lore.kernel.org/r/aUN9BFdxHQj8ThMS@ndev

The earlier syzbot retest hit a bug in the fallback path. Since
b244c89a70b3, the caller holds invalidate_lock before the fallback reads
min_nrpages. This patch covers the remaining mmap readahead path.

A/B testing on arm64/QEMU at the declared base commit gave 10/10
baseline hits via madvise and 6/10 via MAP_POPULATE. Both paths had
0/10 hits with this patch. The 20 patched serial logs showed no kernel
warnings or crashes.

 mm/readahead.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290..80f3e141d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -484,7 +484,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	struct address_space *mapping = ractl->mapping;
 	pgoff_t start = readahead_index(ractl);
 	pgoff_t index = start;
-	unsigned int min_order = mapping_min_folio_order(mapping);
+	unsigned int min_order;
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark;
 	unsigned int nofs;
@@ -506,15 +506,17 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		mark = ULONG_MAX;
 	}
 
+	/* See comment in page_cache_ra_unbounded() */
+	nofs = memalloc_nofs_save();
+	filemap_invalidate_lock_shared(mapping);
+
+	/* Serialize with set_blocksize() updating the minimum folio order. */
+	min_order = mapping_min_folio_order(mapping);
 	new_order = min(mapping_max_folio_order(mapping), new_order);
 	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
 	new_order = max(new_order, min_order);
-
 	ra->order = new_order;
 
-	/* See comment in page_cache_ra_unbounded() */
-	nofs = memalloc_nofs_save();
-	filemap_invalidate_lock_shared(mapping);
 	/*
 	 * If the new_order is greater than min_order and index is
 	 * already aligned to new_order, then this will be noop as index

base-commit: 29378f5cd79a27718ead9717fe7b094b651a8e1e
-- 
2.39.5 (Apple Git-154)

