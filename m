Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F7E7C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8566B0092; Wed, 16 Sep 2026 08:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899EE6B0093; Wed, 16 Sep 2026 08:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF876B0095; Wed, 16 Sep 2026 08:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BBE76B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:51:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05ED01A06D7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:51:43 +0000 (UTC)
X-FDA: 85219612086.11.6DBCF06
Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04B1E140007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:51:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qLfThpJn;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+qAu95NlLgiI5sYTT8Qr8gOpJeUvt0eaVuwkSzqyWgg=;
	b=KSnX+a+poziOdmvezbGpgEhXCBmnv7f5e8be9TjdWCJl/xN/9cpx45ltCvnfYbvXIeoXnN
	/pBwIOBstcJWVchrHicN6dQqBmBi1EPr3HhBc1A4Ud3iEjwRTNL2z7RvFR5okqpnZTTL+r
	Mx7s9KSnvWGz/F+yjQrCIKGsRUsPhfw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563101;
	b=aKwmOln6lbARSodGiuVINZeV8Pi2u8qpjNIKN1peNBl3ovAFSYg21Ddw3bCg2Z3h6ayZJa
	BjpwN7Afv2ZX7h3Us6WCsOfbtyGxKS46ma7T76VteaLhyzO0QcCGVh6F5T1L0dLttTybtB
	TT+jsMvG78HmejIUQJpP05/QQscKiyM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qLfThpJn;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/GTEXjAO8G07aQ62TimyMku3VnOjLh/C2zIWvY7maY0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789563099; v=1; x=1790167899;
 b=qLfThpJnuV2qzRJzau+BUNAKZxTbQM+pZ2bPZOLeVdrT0Tj1iAyNvR1J7z7DaYC6vJoSLkbV
 ViHJ7KnN9aka+1FrYZcFJaaSAU86jfcPdfuOEkYVqPDCTE/d6gSw8FxLPoBPIyRBDdtBy2Ohn7L
 3nu48xdYKNXCBxiNmmQYI81w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 13cff38a12b166cd;
	Wed, 16 Sep 2026 12:51:29 +0000
X-Mizu-Trace-ID: 13cff38a12b166cd
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	david@kernel.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] mm: filemap: move lruvec accounting outside the xarray lock
Date: Wed, 16 Sep 2026 05:51:22 -0700
Message-ID: <20260916125122.2696271-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ph799hi4u7hoh9goyjj8w6q6z89nhpco
X-Rspam-User: 
X-Rspamd-Queue-Id: 04B1E140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789563100-598472
X-HE-Meta: U2FsdGVkX19iRTvEZtZZlqCb6BfQnRIcJf69cOGBZedeBQanG+8ctqz6I4UlJHzQ7+vN+TTJa6UGzHwRJxWQDmzMxKcjYinIW86F0fZPoirGoErutbtEyVtjefYvmeJi6BSY28BVrD1MufDb9rMHiDEfzGQL2Qk6qJnRglNdmGmG7a2OYR0XrfgcG+VjGMuM04M4s7zaDbMUo6MuBuc51mGPDPlwopyy02uYGmvrSXw58zwcYF0G+vi16D57/lgfUp4wv5n20pAvgcQCqd13TYESr5UyouXNKEr33JAgl9hQNFLKoB2ZSpoNKGnllu3gh8kkvN5Wh22CrRv0HUf7YCMUmsUnZDeKdgsqHiHGxT1ito1yUfxmcYzk5ifZOQTv3PkjsiqWDHDeqMiVmPOum6kyLJg74jAjX0d0F7BZZho7du4oIG9477o1gKZXvhQY6A5rsT6L0ieEulQvjfKr8BP7TOOIPhoRTAm4/sJ2G6okvEGVwt/XG+2/CSheXVfmUqeNyV8WIbVbphpv+EplATCOiFxpPzvISHn6a1mq5at+lGhJCGCZZRiPYFgeLd8vitH1gd7U/J9tTPVT1GbMxSCycF1RxiEB/6AOSsALYRt9PIsR4gc9NN4soCfx3Tz2VTXTi3+lcUavSfFO//LzWVAjKtwl6yBfoDn9/ko+nb+btfjCXm0LycZO0fl1SVCRoDou5xccfMHVsMGRKj4YBbeYgS6n1Aw6sN1kZ5guuSmxR2J6Z72hL1evOx6+E4YQPpG3/D/t7qMLRW+P7q19KQ3ZjKPahjvHbYXF2Qkqi12lms2s/itCZXSh9i0rQ+mcXY+QS8unrxyAG5tUdyfj6WINBRJbi4Z0HIBKlnPKxsU84O/5KIlawJE2jIfJ2DWIDiV371CAlBQsLEWVIL70bSTK3121qTa97+D/3fVwExuIqvc9iDTtjmsZhjpm/dyOKuZhqbNtXo3EgCP9Dga
 a80AZtrm
 mrVa5FBiFbpO1tAF/Uq/YB7lgwYkUBTCOnXnPBZV+hu8DJbUFovbod/LYwTeNWBYrsbKaIlQCQr0ug2lPYoTmXNRRzKoIzj7e58Q+QELIEdsRdIb6usmw4i8MgjM/LWrsgJ8xuhVhjoCskwOjka3kR+7P4j03MdxV3PtCeFNCUI+IiozhvBNnirUL0r9MM/d+MhIpYX+02PuqGii6vPp3wG/Pf+8coSYF4L0n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__filemap_add_folio() inserts a folio and updates mapping->nrpages
while holding mapping->i_pages.xa_lock with interrupts disabled. The
XArray insertion and nrpages update require the lock, but the lruvec
statistic updates do not. With CONFIG_MEMCG, those calls also update
per-CPU memcg and lruvec counters and notify cgroup rstat, extending the
critical section.

Move the lruvec accounting after a successful XArray insertion and
after xas_unlock_irq(). The page-cache references pin the folio, while
the folio lock keeps folio->mapping stable and prevents removal until
accounting is complete. This moves one lruvec update for ordinary folios
and a second for PMD-mappable folios out of the serialized section.

In a 30-second system-wide perf lock contention -ab capture on a
production host, the hottest caller-stack record attributed to
__filemap_add_folio() had 20,867 contentions and 557.930 ms total wait.
That was 14% of the 3.998 seconds of aggregate lock wait in the
capture. Moving lruvec accuting outside of critical section should
help optimize it.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/filemap.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f550..4720bbfc1a663 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -918,14 +918,6 @@ noinline int __filemap_add_folio(struct address_space *mapping,
 
 		mapping->nrpages += nr;
 
-		/* hugetlb pages do not participate in page cache accounting */
-		if (!huge) {
-			lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
-			if (folio_test_pmd_mappable(folio))
-				lruvec_stat_mod_folio(folio,
-						NR_FILE_THPS, nr);
-		}
-
 unlock:
 		xas_unlock_irq(&xas);
 
@@ -942,6 +934,13 @@ noinline int __filemap_add_folio(struct address_space *mapping,
 	if (xas_error(&xas))
 		goto error;
 
+	/* hugetlb pages do not participate in page cache accounting */
+	if (!huge) {
+		lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+		if (folio_test_pmd_mappable(folio))
+			lruvec_stat_mod_folio(folio, NR_FILE_THPS, nr);
+	}
+
 	trace_mm_filemap_add_to_page_cache(folio);
 	return 0;
 error:
-- 
2.53.0-Meta


