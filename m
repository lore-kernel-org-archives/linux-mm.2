Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFCB7D12692
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 03:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F566B0345; Fri,  5 Dec 2025 22:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA5F6B0347; Fri,  5 Dec 2025 22:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8AA6B0348; Fri,  5 Dec 2025 22:09:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2363A6B0345
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:09:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0A5E1A038B
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:09:16 +0000 (UTC)
X-FDA: 84187565112.06.8CF0FA0
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26481A0008
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:09:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=samsung.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764990555; a=rsa-sha256;
	cv=none;
	b=zvo2+J3NW5jinn5bHp3+bTdva88GRLQBlwdlHhU/doMjL9CshIvCy+azK+JtESRpqifH3t
	zLhSh5KxiFlWA3Cf+Ach8/BTMSqr7DYyRFIuEjL6m9NUr/8K1YYubsiP+gFaEZ3Y839ac0
	IFKGBgMrEi1IFRDzjRmCXPOW8TGxuBc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=samsung.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764990555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eBUzztVeoZWHnWCfnCvjYKFoIzhnkIayGx47QEAvlKM=;
	b=otG/rWCG54k3Bae6AOyzIB4kbHhpqWo6dc7m9ygQ0uRzMdvi8qgrhf20O/sntuZsKj7zcj
	I7oZqT9aArpchJmxo/lWm/bX58A7ywWaaH/zP7kpQI0SpqbztCK2OeAmvz911VpxZEYem2
	0CwPdVIOfHkwFw8Ts7b2luJyTyl+gpw=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4dNY9z2JYNz9tv1;
	Sat,  6 Dec 2025 04:09:11 +0100 (CET)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Michal Hocko <mhocko@suse.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	tytso@mit.edu,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC v2 1/3] filemap: set max order to be min order if THP is disabled
Date: Sat,  6 Dec 2025 04:08:56 +0100
Message-ID: <20251206030858.1418814-2-p.raghav@samsung.com>
In-Reply-To: <20251206030858.1418814-1-p.raghav@samsung.com>
References: <20251206030858.1418814-1-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 26481A0008
X-Rspamd-Server: rspam10
X-Stat-Signature: qi9cmt9g7975t46ihs4h3889t8onod74
X-HE-Tag: 1764990554-884940
X-HE-Meta: U2FsdGVkX18mo+3uH+adSLtV+PwNnfLs4B/9dzOKuQGko/zlyPipArMC3d+feEPDDBtv4ZYkpIT6NShxbeDAA0M/3C5pRiR/qavBpd8ZfHftzJYd4UzFBd6K2orMWUaIXVX1hQaUg84V2qP7TqM9/NkjqgIrB4TxuxDpA4mW921BL//fT6I7wE/n3GS+tEUcpysRHx05ZEps0f/4oRTCuNa7OGwC5AqSzji0nrky6Nam0yyaP//b/AiSPhd4tKHe8T1A63Qeih+Yq5scMcaRgQ08rjzcDAetfPubqRyxF98CynOx5Rf3en0MHD0HIKdbbPutBL/6aGj/0UTlgv9MAog4FhKdkjfcUm9vUVM+40xOjA+yZvb2rRasdba2fZt+K5kLbr1S5MxB03jBLb0oAGC+41OTBwFmxCcsuG6RjPwI4NDVwB3RAGFLLYPw8LCSwclJ56D8c+mbrmUj56pO+1kyG4YSKaN61uosFfsZLLtWXYYCh37ZUGIN2HfisKW4TQjQN+Bsx3fnUY5lBAneeJR4MDHdONNRVeXdx84rlscPfwR/MmdgSFhx/tVD5io7+tpuoGZTH0dgckSAc7wnrHbLwwTEc/3n/Sw946mowtzWpws1XyGnCpHGZwYNBawLLp+KDdfwJQMrbZurgwJCG7Nb9zAapVUbWkhHcFTFZ3/hO17WIMZ4gNa+jGRZor0ktfxvV+8LF5TtAtGq+fee3EGbl+zTmlarMCow7IiYxI4gTDmJks6SpSKQuHyr4Lt0M9zWreoNatsGGGGxFb1OHLm6CGS82JyHSsQ8+4Vz4eiFjL9l3Sk/LrSYZ0qz7sHXb/gnqDSYTp9KrHmLSoaBUj26nh13X5YOSjouWzfg/s63UKZj19QmPiHq3TdEX3jtmIU91j9mgvy8dPHrWCY5GjfqbRqky9LJIRaEYiOq9gm7amRTyT7Sk0DdGJ/OCT5tCQfK0jbuJHLqwt61wmQ
 rO1S4b3K
 v6OXvj9UKGpNLBcxK/Jm6k/Cf6R+s8lzVU8H9fQAIazyyyDivL0bxl4i6xwpWqnj7sLFlUPzT6RaBqubKzYfvHpItoef30DNMPLR+jMTyWfcPejL5gOyZ61H3A8WFhpSvumwWtBJG3h/GdvYwWRZCh9FFcGnslRhmOtpQEbKrg2fL6tcWLJdgB9PIaf8DQ3yT0dhGlkzVxGRqnQb0KiuYbso3QsSjGCfCgcBeYYnX+7qi085MVsOrote1+99Esd/e7XduDosgWBQQgMEeWHwU7APheCGaMoSOzLAQQ8TH9zRwOkzf0I+2RMS3QdXXLEaRwbVAjs1meofY+GE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large folios in the page cache depend on the splitting infrastructure from
THP. To remove the dependency between large folios and
CONFIG_TRANSPARENT_HUGEPAGE, set the min order == max order if THP is
disabled. This will make sure the splitting code will not be required
when THP is disabled, therefore, removing the dependency between large
folios and THP.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/pagemap.h | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878..1bb0d4432d4b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -397,9 +397,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  */
 static inline size_t mapping_max_folio_size_supported(void)
 {
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-		return 1U << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
-	return PAGE_SIZE;
+	return 1U << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
 }
 
 /*
@@ -422,16 +420,17 @@ static inline void mapping_set_folio_order_range(struct address_space *mapping,
 						 unsigned int min,
 						 unsigned int max)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-		return;
-
 	if (min > MAX_PAGECACHE_ORDER)
 		min = MAX_PAGECACHE_ORDER;
 
 	if (max > MAX_PAGECACHE_ORDER)
 		max = MAX_PAGECACHE_ORDER;
 
-	if (max < min)
+	/* Large folios depend on THP infrastructure for splitting.
+	 * If THP is disabled, we cap the max order to min order to avoid
+	 * splitting the folios.
+	 */
+	if ((max < min) || !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		max = min;
 
 	mapping->flags = (mapping->flags & ~AS_FOLIO_ORDER_MASK) |
@@ -463,16 +462,12 @@ static inline void mapping_set_large_folios(struct address_space *mapping)
 static inline unsigned int
 mapping_max_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MAX_MASK) >> AS_FOLIO_ORDER_MAX;
 }
 
 static inline unsigned int
 mapping_min_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
 }
 
-- 
2.50.1


