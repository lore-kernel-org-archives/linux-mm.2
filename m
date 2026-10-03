Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10966CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED756B0093; Fri,  2 Oct 2026 20:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E616B0095; Fri,  2 Oct 2026 20:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C402C6B0096; Fri,  2 Oct 2026 20:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89A9D6B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:19:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F28028078C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:11 +0000 (UTC)
X-FDA: 85279405302.25.544CE25
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39B8740005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EcdIhFM7;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WN+hcxT2obu+Cvnf4TklNkJLPL9EbhZzUN79EAadJMk=;
	b=6WN4yo/M+WkTOrYHvzExPc6lnM6ULUvbFpUOu4NOKqKko+FbnPtPwHAvUcf62wUBO/z/Yz
	Of9AwITsoe9AlK9osTLPiLbpuMrDMXkSiISkjWu0hjmMUx5xvskyhrOnnB3pbb3oQu6IkG
	fIkbZN2W2AoDMZQwgT6OVpuCxDGwktM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EcdIhFM7;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986750;
	b=sv6/+/7GATOwj4TzSd3KV/jdi3u0XkQGgbGVVh2sscTUerTHgDNmFujucU7W9OQhu57AJT
	u/uUcoL2TI/WP5mf/0aoGsUbTZPwfpS0GpQpM8JabAUloXvcew5MH/zLY51vE3pgYzq/TS
	IEEoSvv2UBn9LSiNYw0JOIJrNk1Zda4=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-81eaf8e18bdso318307a34.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790986749; x=1791591549; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WN+hcxT2obu+Cvnf4TklNkJLPL9EbhZzUN79EAadJMk=;
        b=EcdIhFM74GBFZ2el38fJC/YI5wvDfeh9lBfL9igLp9B1OnflmvQcBnDRoozb1eQ2Hs
         Q4x+vhQDe86HFmr0xlZ3jYvOebZEAtAkW1TAOTRB+B3k4Sc4xUlfyxgKtLNDQSwL6KJ8
         /bhsN0AuM7Zvz5HgZfEsoFA69p/u3emQm4pgt+FzAHPuBEMXrUmdO271ywBNHn/GsPH/
         NrHwGLe/ZJpu9hduOmHmdV43AkbEbEqBC+9nMmj5Pc5/HoJ2TXoLPIuPgaQghRblna+k
         3djGBTZFOsgM+cxAu4YLu2DF2sB2g/aJfiZVGSIHaVTpUyXM4DDV9QGFzQ9ONvUxLkZo
         SRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986749; x=1791591549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WN+hcxT2obu+Cvnf4TklNkJLPL9EbhZzUN79EAadJMk=;
        b=e6iguoTmKgfpoFZvnWaWqmqnnijen4CjEDltIAuMQiW50O1tNZsJ+PI2IgwWohuN+D
         vNZQah8ywjrryke/KEPeuOO+v0mfbNzY66qogBsRHHIb1WUImtlM3j0JrIG2Jpxs7qL4
         xyDvxaui4LAaUQ0KBxMljFCC/SV3m3/exFWE9/6lfniUN5jviq5wwell3sRvcqxzgalh
         eGKDDqZIAMOz2M63VFJJ8kmxm3luJRt1ruqdAULR1wxNlpEt9gQTFIDIpSvGCdupZ9q/
         wtIT27fIPiYga8bLZ+fHkQNISU4oD9muKr1G+KgCi1m8j04US/1ZAS7QXRtlDd82OR1D
         ehyg==
X-Forwarded-Encrypted: i=1; AKwUvBxA21h83FnwNMND2bAarQQtZS2g3lRGicD7Tbe4sj7ZkPrk80kAB91g6+wmbOh1LKMUxUOptGgYIw==@kvack.org
X-Gm-Message-State: AFuF++maxRF7rIfvERCo9mo+0ENh1aFZLjSnJFc5D9fYB8mEKyebJbEA
	rzZD2Hy5HsIgl1aAjNJM8voqaFJqwsLdh6wAUtY+gkfjio9q3Vvqwm1Z
X-Gm-Gg: AYBFou28XlmHfU6yvgAiwi8vFVjHnm1BQux5/JPkzY8KNuHqjrJPIovidpoclSYshkA
	xTIojLYW/FrdsK7ifNOCswhTRTwq3r4g5qLWHSwd9VfWG7/hzWrl+td/UsJ3DSPSbVueLiBsJZL
	W9sLc35l8b72P8pgfmXEHnQ2h5ceWrA690LhM0rQ6P/7k6qgTVlvgGXh4kOkil7omLBANqrCvWA
	Nhg1Ww9wdYdKVkgJybkFINKOzNw+6dEnRqhj/SYia0dBw01UkewOXlYZCC+8XqMoBzVMQSZfOvd
	fwgfKTKAQhhTlhfLAXaiF+LSI5lwhOvx6sWFzbdHW05Mgzd+sFHx+osRTKR8kkmoFqsi903+3ec
	UHSSzXJwwH0URpCXCr/I7seZXiHUQsZPYypArBgFPuK158tjkh3hhhUBgpA4GAARTbPE2p0fPaf
	FseaZ4bb/U7IAdHYOQfIU8bHjL/GUspv9YnSSlXKdeerG2KoDAFOV4rTF14ZzM668o9xhp43EyA
	GMT2Z7+xMOKtviKY8poRCYz1F/qgFLAYwOx0PeLyzIECHzcak49myh49R7CXg==
X-Received: by 2002:a05:6830:44a6:b0:81f:acdd:bd0c with SMTP id 46e09a7af769-823fca26dbemr965968a34.12.1790986749202;
        Fri, 02 Oct 2026 17:19:09 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-82279e73822sm4601292a34.16.2026.10.02.17.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 17:19:07 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	willy@infradead.org,
	jack@suse.cz
Cc: mhocko@suse.com,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	riel@surriel.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 3/3] mm/readahead: avoid per-folio memcg reclaim
Date: Fri,  2 Oct 2026 17:15:55 -0700
Message-ID: <20261003001555.3498357-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261003001555.3498357-1-joannelkoong@gmail.com>
References: <20261003001555.3498357-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pbfu17zmzr9tip9xrikz83g5r3uo7oot
X-Rspamd-Queue-Id: 39B8740005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790986750-288755
X-HE-Meta: U2FsdGVkX19wa3b5XM8W7Y3olywNVIh62JqIo86DRiNPBpjMWIu2QcSEaH73XMAb0yCfHGe7nPmTl5lJJJ9aghHFZJFgh9veqRIyFDVs1xR3RTDYKZo/1Li+9SXbTOwBdA3w21ND3DKDusxvS4/z6roIulYxPKe3yt78YY4RZwjR/U+pqiwnbvoCiKnSpfDVnrqz+0NLErvZZbUk/Sil33qIy0JlgQO6ein/b5/6l6/UbwOy/KqfVcd9gLa7Xbm/cO6LFnNBr73eNEq4ARZqEJXo/+2C6mC9oy/gvgRfwgq6CVkSCxtK/HB/D6airEMxMkEZ/p00mMXIvIF1B9eh8Q/pmfcTE718mqn3puGL9SwIIOXYxhEqjavCdJ5U6qa8rkt5Vat9X4XcqsfByqztQg+8vhbQFRqQdOYcMqPCje6GGiYhtXB4PKQ7sINvRsWQcbsT8H/LnvMb6WWK+3Z+TjOQZbaQ3GDWkMBxNwAVOloxlKRW4wvPL1QMQG1/6sx+mBAj5hzc0YQ+No2+XpjuWEgYPndzKqd3UU9SBiKpWE5ZrrEXnGYrF612pWlj8lS+NOutaxq++U68cytayqZV2pmZ7IABC5ug+noMXzEo01yZBa7t+m6UgN0WavP9JqZHOW3IJPT61dmpJxpGaRT78+WWB8HaMGvEFVzCfGkRvfxKHbLNsTdA5mulQmD4gqKZL2d6zcQK98poI4H1byW4ZICBVAYYwDPpxK2O4pHsatlVThTzFeHoZHX/Yv6SWWXMp/Ov80cIhjxQ0gvNY6sdjmhRSUXdHTo/zpuWI4S143rDQBoWg6FlQfXkmq6aiKcBDj6fgo0qQ0bf/TNb++IWBUeF4RgwQ9SU6NMnOHv3OPIx3WuFjW4dMwKFSazfZtaa7R9bn7doWqmBaeZKZEnDfvuGazdMVypQGoIFh++/LM275FiZ1oj9dhB6PnKn+CNUhUZoIQrGcjUfx3ia/ZC
 4FgxsRzh
 +tckBTfZLA//bYMAoluIpgphk4KvC9aVKIRSi3U7jyAYHb8+J6Is5GjeggC5NCkpDSj+Qwxf76pcTmv6sHBuaGpMXg4VvA6mAxMVVLyxdDLGmeL04/ojyXsXLcsmnsJz8rG3kBzgGxQQgOV6i3EBWBmkffgxo80ZyMKVzpHv8JwawBPR1mMGJ2LkOu2zepvw8hTyRWSzszlaZE0nSe8SkCW039IcCV70/3Pnjib7gibqGV/RcuXS93tx335pToD4s2QKDgnkBAIs2ya7XwnKyM3XcrQ2nbRDKPNeZRspH4z01TSsvKRB3l2i0JXSBkp5f77GyO/F8Zpd40bq5tbwT0+YJ0vUeyLzyoG059YuhvpY8Euo8jQmDWAMgfXfW/pVZVyxb0aPZ3T6ri/qRCwry0e1AHNPGftFJnhHe573b0Sf1fWqLcXUcFHHWVYXdzWvLDM9EoEBb2e2bpZx1dLambjOfybxYPqFyo5RADz2YvHqc7eAMuZwrl3vOxvQQD4Zbt0tcpcgZ0m0I4Gjc5M2W2jR9lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Readahead adds the folios in its window to the page cache one at a time.
Each folio is charged separately. When the memcg is at its limit, each
one of those charges triggers reclaim (readahead's __GFP_NORETRY only
stops try_charge_memcg() after a reclaim pass). With many tasks faulting
in the same cgroup, the margin one reclaim pass frees gets consumed by
the others, so the faulting tasks keep reclaiming, all to make room for
speculative folios, and in the worst case, reclaim livelocks.

On Meta's fleet, this per-folio reclaim is a large cost. Page cache
insertion triggers around half of all memcg limit reclaim CPU, 93% of it
from mmap fault readahead, in services whose cgroups run at their limit
while many threads fault in mmapped files. Of the CPU time spent in
filemap_add_folio(), 83% is memcg reclaim while inserting the folio into
the page cache itself is 6%.

To avoid this, add readahead folios to the page cache without direct
reclaim, and when the memcg is at its limit, reclaim for the rest of the
window at once with mem_cgroup_reclaim_for_batch() instead of once per
folio. If the memcg hits its limit again before the whole window has
been added, try one more time, since other tasks charging the same memcg
may have used up the room the first attempt made. If there's still no
room, stop readahead early rather than reclaim harder, since readahead
folios are speculative. The count of reclaim attempts lives in
readahead_control so that it covers every path that adds folios for the
request.

This only affects speculative readahead folios. There's no change in
behavior for the folio a fault or read actually needs. If readahead
didn't bring that folio in, filemap_fault() and filemap_read() allocate
and charge it with the mapping's normal gfp mask, like before.

There are two other differences from the current behavior. The first is
that readahead charges that push a cgroup past memory.high leave the
high reclaim to the return to user space, as other non-blocking charges
do. The second is that under global memory pressure, readahead's page
cache xarray node allocations no longer enter direct reclaim (they still
wake kswapd). If one fails, readahead stops early, as it does when a
folio allocation fails.

Tested on a 26-core/52-thread machine with btrfs, running 26, 52 or 104
processes (one per core, one per thread, and 2x oversubscribed) that
each mmap their own file in one memcg with a 1G memory.max (before and
after measured in the same boot), reclaim passes per major fault drop by
94-96% for both random and sequential reads. With data compressing ~3:1
under compress-force=zstd:3, the runs that livelocked in reclaim without
the patch (4 of 18) no longer do. Throughput with incompressible data,
where the disk is the bottleneck, is within 5% of before in either
direction, and the drops are within run-to-run variation. With the
compressed data, it is 9% higher at 104 processes, where reclaim
contention is. Sequential readers get up to 18% fewer pages per major
fault, since readahead now stops early when there is still no room, but
their throughput and read bandwidth are unchanged or slightly higher.

Reported-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/pagemap.h |  1 +
 mm/readahead.c          | 51 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a37367..973a836076bd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1409,6 +1409,7 @@ struct readahead_control {
 	pgoff_t _index;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
+	unsigned int _nr_memcg_reclaims;
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290287..e06375559e9b 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -204,6 +204,41 @@ static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
 	return folio;
 }
 
+/*
+ * Max number of memcg reclaim attempts per readahead request. The first
+ * makes room for the rest of the readahead window. If the window runs out
+ * of room again, try one more time since other readers in the same memcg
+ * might have used that room up.
+ */
+#define READAHEAD_MAX_MEMCG_RECLAIMS	2
+
+/*
+ * Add a readahead folio to the page cache without direct reclaim. This prevents
+ * a memcg at its limit from running reclaim for every folio in the readahead
+ * window (folios in the window are charged one at a time). If adding the folio
+ * to the page cache returns -ENOMEM, reclaim enough room for the rest of the
+ * window and retry adding it.
+ */
+static int readahead_add_folio(struct readahead_control *ractl,
+			       struct folio *folio, pgoff_t index,
+			       unsigned long nr_pages_left, gfp_t gfp)
+{
+	struct address_space *mapping = ractl->mapping;
+	int ret;
+
+	ret = filemap_add_folio(mapping, folio, index,
+				gfp & ~__GFP_DIRECT_RECLAIM);
+	if (ret == -ENOMEM &&
+	    ractl->_nr_memcg_reclaims < READAHEAD_MAX_MEMCG_RECLAIMS) {
+		ractl->_nr_memcg_reclaims++;
+		nr_pages_left = max(nr_pages_left, folio_nr_pages(folio));
+		if (mem_cgroup_reclaim_for_batch(nr_pages_left, gfp))
+			ret = filemap_add_folio(mapping, folio, index,
+						gfp & ~__GFP_DIRECT_RECLAIM);
+	}
+	return ret;
+}
+
 /**
  * page_cache_ra_unbounded - Start unchecked readahead.
  * @ractl: Readahead control.
@@ -290,7 +325,8 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 		if (!folio)
 			break;
 
-		ret = filemap_add_folio(mapping, folio, index + i, gfp_mask);
+		ret = readahead_add_folio(ractl, folio, index + i,
+					  nr_to_read - i, gfp_mask);
 		if (ret < 0) {
 			folio_put(folio);
 			if (ret == -ENOMEM)
@@ -457,7 +493,7 @@ static unsigned long get_next_ra_size(struct file_ra_state *ra,
  */
 
 static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
-		pgoff_t mark, unsigned int order, gfp_t gfp)
+		pgoff_t mark, pgoff_t limit, unsigned int order, gfp_t gfp)
 {
 	int err;
 	struct folio *folio = ractl_alloc_folio(ractl, gfp, order);
@@ -467,7 +503,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 	mark = round_down(mark, 1UL << order);
 	if (index == mark)
 		folio_set_readahead(folio);
-	err = filemap_add_folio(ractl->mapping, folio, index, gfp);
+	err = readahead_add_folio(ractl, folio, index, limit - index + 1, gfp);
 	if (err) {
 		folio_put(folio);
 		return err;
@@ -532,7 +568,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		/* Don't allocate pages past EOF */
 		while (order > min_order && index + (1UL << order) - 1 > limit)
 			order--;
-		err = ra_alloc_folio(ractl, index, mark, order, gfp);
+		err = ra_alloc_folio(ractl, index, mark, limit, order, gfp);
 		if (err)
 			break;
 		index += 1UL << order;
@@ -813,7 +849,8 @@ void readahead_expand(struct readahead_control *ractl,
 			return;
 
 		index = mapping_align_index(mapping, index);
-		if (filemap_add_folio(mapping, folio, index, gfp_mask) < 0) {
+		if (readahead_add_folio(ractl, folio, index,
+					ractl->_index - new_index, gfp_mask) < 0) {
 			folio_put(folio);
 			return;
 		}
@@ -842,7 +879,9 @@ void readahead_expand(struct readahead_control *ractl,
 			return;
 
 		index = mapping_align_index(mapping, index);
-		if (filemap_add_folio(mapping, folio, index, gfp_mask) < 0) {
+		if (readahead_add_folio(ractl, folio, index,
+					new_nr_pages - ractl->_nr_pages,
+					gfp_mask) < 0) {
 			folio_put(folio);
 			return;
 		}
-- 
2.52.0


