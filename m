Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE00C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B876B047B; Tue,  2 Jun 2026 00:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC3F6B047E; Tue,  2 Jun 2026 00:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1EA6B0481; Tue,  2 Jun 2026 00:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80ACB6B047B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:35:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E77C162AD4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:35:09 +0000 (UTC)
X-FDA: 84833707938.29.128ED2A
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf16.hostedemail.com (Postfix) with ESMTP id 60CB3180006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:35:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HZ+Ve0Mr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780374907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NgwzeQZYBkXu7U3Vz6FCT3bGFgzALNC0m/GPi7PoAp4=;
	b=SvYHov0cf6MFrop7RUkjylwekOC+0lTYJ9gu1L6DatvvGLjotwNPiox1ioc8KwsHGWtEV/
	1FQgWQjeYsymtmQYp1VHIpmE9U3EjKh4hOS9xx0HkJDVx9um6Yl8gpg5KvBW7Oi2oFtpzl
	DsIVxRLQ4Ng1iFj1dpn6qfUwr22RDB8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HZ+Ve0Mr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780374907;
	b=hhmPgUsWSfSnzyvvgrPRzEjoqb4ZfKbVtM18RTq8aYqg0UYtenglBj9aPJk8doLbVi1+T3
	hLuWPvlkn0uQGWAJV1sfC3ZIhItWOAdOyZ3Cu+TFjVnlWXQybLslYXCWSIp91fMvYUveBv
	F2IqZ4RA+Rr7IQ4K/BmP1v9yaHNUiPc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780374904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NgwzeQZYBkXu7U3Vz6FCT3bGFgzALNC0m/GPi7PoAp4=;
	b=HZ+Ve0MrPDFwnU/cx5DmPS2k6/sGmTO0W/b3GRkYbj77VOarf2rpNjDKEg8UAOg9dAH/Gu
	JD5P6kAiy0GMeCbgqbwCi5CiPopgiF3Um7JCF70Iz9FPRueWQ/DrMKyCfFX4U16fFsY0KV
	nohz4Rxi1ky2NiAvslzJpJjlWtgCEjA=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	qi.zheng@linux.dev,
	yosry.ahmed@linux.dev,
	ziy@nvidia.com,
	liam@infradead.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	ryncsn@gmail.com,
	zaslonko@linux.ibm.com,
	gor@linux.ibm.com,
	wangkefeng.wang@huawei.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when queues drain
Date: Tue,  2 Jun 2026 12:34:53 +0800
Message-ID: <20260602043453.67597-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ywxt8m3hmg84onmiutynpmuxiyjrs7ad
X-Rspamd-Queue-Id: 60CB3180006
X-HE-Tag: 1780374907-185748
X-HE-Meta: U2FsdGVkX1+RCG+OvcEeZykL7SCzURow8/bYAiEtiQXsRNEAt5QQrzUPT8NTD3U1qU8aN2cTroTPnDto6IVLayQpuR6cnAOnU9NJ4FeFSsvZyUeuOebSManYRXi+UtnF8IPn7ZpUk2JQEHXhm4APzqYyyplGQ7poILgLFiqnh73725xePz9rnQoodWlUppkFM6BvVo/fRYRi80qKdJ+m76KBA4hDJbQkyssxz+cSnmy5ErqHiss5HDe5ZfwHd4/p26xnPYRoGaxspqUW2KA/h38Lt/2u56EenuVneocoAg3EIvdd9dwRU3rQKbYpOoHx8T3z+hddrwwk172S3euN6ID9DvoO8JpOSeOsvCT3dUuOuCRjPf2Hr2zRjnbkl0nSHrMbUkRSdEN2PN2tHo7XXAN+Fs1yYX2S/DwB6yhDAVYK83Tlf6GVuZoHsiKuF9gKEmandFY/w0FBLADqArV2t2jV7z9oCm0oHTinfBZjS7ioJUeA6fCqbM9wuTI8RhWFXOaEWqXC2WvX38i8BJyiRLXYTlpTlKCCgf+WgtD7arTLTezaP0SRjOGSKP+25D8KUfY6REd5umw4J9FgNTwqzeKtzf9B3LZcizkAaanXMkoqFElTsYeesc9WFrQk452d3wHcDeg6S4QCVkby1nfAMsfGkDdI4Aq27Zev9xAHtagqRTyi8cYo2pMKi2zKem7A1wgROwrN4U1BEakvNCXAR2D56pNMTQLdo4nnjh45PEbxJorLe2mI8QtvNnCDYBJRIqx1NE80MtIaFqrt2JUJ/Z7sEfZ34p9Jsil+myUyoAg5K/nDuNmro1F8KtJzamzR5XLm7DmeBc/xdvG9G229c0LgmoA0/onylIbLPaf4upGxq7fMwlwy22Ik5GXh2bSBgCa5PkE+nF0QxTJWkgv3U6tnfJdoM4BfCGjqAkrTr8m5z6KvI/hw3paxl1cJSxkfK95qpllwRA0qK0P+tY8
 AUQ0BISq
 CkW6zVbiVCRlh7GhaN2X1cXm9miEChSD4bz0hJePK1ssajTl9+yvhg01YQaWfdl2mlmm9T2uD3Aqy/HgEojsYFGCEBLEMJ+yJL6acaQeVIB4HTDWXlaLRaqju7N2NGQZGYPVvR17stBIskPiNoMftY3fOZR/BvVn/ueLpRv5FMxkiSn1wFdr/pNdnZKmWMAAW+NWq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

deferred_split_count() returns the raw list_lru count. When the per-memcg,
per-node list is empty, that count is 0.

That skips scanning, but it does not tell memcg reclaim that the shrinker
is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
count callback reports SHRINK_EMPTY.

Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
cleared once the queue has drained.

Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/huge_memory.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 72f6caf0fec6..62d598290c3b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 static unsigned long deferred_split_count(struct shrinker *shrink,
 		struct shrink_control *sc)
 {
-	return list_lru_shrink_count(&deferred_split_lru, sc);
+	unsigned long count;
+
+	count = list_lru_shrink_count(&deferred_split_lru, sc);
+	return count ?: SHRINK_EMPTY;
 }
 
 static bool thp_underused(struct folio *folio)
-- 
2.49.0


