Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FA5606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 08:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A0VZj5yY
Received: by kanga.kvack.org (Postfix)
	id C36936B00EF; Sat, 14 Nov 2026 03:49:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7AB6B05B0; Sat, 14 Nov 2026 03:49:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE276B05B1; Sat, 14 Nov 2026 03:49:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED326B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:49:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C5021A036E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:49:14 +0000 (UTC)
X-FDA: 85433100228.27.CF64C6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C775CC0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:49:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0VZj5yY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794646153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnvuXYTCU2NSamuN8vfT1YpmTCCtvj2XwFt5sGDZPi4=;
	b=YSfcVEtE6bHzVIG8Rh/W5dBN/9ua1wML6k6FTmC1jXg4Ha85uYO9tkM/owqHkytZrzMdKN
	L40iAn9eJcunjzIzhQyOS+rn9dxOj4tlUr3bm/86IHr+UFLjhp1dOBrcdvs3ByF025F5aV
	toWbo/wyGlOaT8YPfazRAwSxZXumFhc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0VZj5yY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794646153;
	b=sVfx/RzOk9l/LN0r7T9pV7aVybPZtsxOi7mSB9i/DSbTvrrRprfSdV6w/4hL+lJh4ITYbJ
	5ehODcAam1WIAzbHdoOECPy1Sjn6EB/LIKK5qQYBqSKtkq9NYFsVIRaideDXaDsRWtXBqy
	ychghJMYtD0fFvz8v/NC2+ZCXejXQHo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF5A740048;
	Sat, 14 Nov 2026 08:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32A41F000C4;
	Sat, 14 Nov 2026 08:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794646151;
	bh=xnvuXYTCU2NSamuN8vfT1YpmTCCtvj2XwFt5sGDZPi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0VZj5yYxTFWw+Q7Wmda6GrvPfZukqolGsmpDAwOQO1cq9wTU1d1BFAW34QFrlui9
	 A4znHw6mVAJskszTCfosSZDoUKuWEcLfXLhU2QT9G3fHZ0M95EEegh+jKqnAttna0Y
	 K76qdHnbfCqdiMYacbNZk32aaDpzqideXIOxsqcQtztPrP3k4pvyXhsqzs9dJDzJWb
	 XzgvigWhl+e+t2/xkeB5EG0jR4a6wptj4j27lkOQslmWUYynVDRBwnUqWngc5tou4e
	 rB5gC3JpJifxRXn5/Svi6Kxi3jfWhU9LagMCJsxZd1pZVv4BjceYBjQnt/AwIUB2zu
	 kuSpN0luH7nxQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: sashiko-bot@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	sashiko-reviews@lists.linux.dev,
	shakeel.butt@linux.dev,
	sidchintamaneni@gmail.com,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn
Subject: Re: [PATCH v8 11/16] mm/mglru: Run aging when one type has no populatable folios
Date: Sat, 14 Nov 2026 16:49:03 +0800
Message-Id: <20261114084904.91735-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <sashiko-outbox-214030@kernel.org>
References: <sashiko-outbox-214030@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C775CC0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: orctnn71e3oxd3t85h3nw5d34gjrrwnx
X-HE-Tag: 1794646152-441882
X-HE-Meta: U2FsdGVkX1/fjq+3CuUe0u6TCL9zxIgRVQFuiQAlqaR/1jPAIP/S3huOYCGKJhSqeH1BwVe3eETcWx87bkS/TIL1gFbvfe7iWeR2JulHLZBcfaH5ZIGsOQ6uH4HKFMeh66oSPknjsh31Udlc17NC7GsQdS3HrZcbP/ISQC75eDpInDxAx0FnvRWtWn5ZqHkGIXFs0Amo4sknTStSuH0ijF2WyQR7KU0rfqTgOCHfQY1qtUVnqjJAkc5bduaGZK0qLnte1t+Rc6lqQBxd6Ijw0Q5cZswfpyfC+TDV+/eX8tlLs2CuEOFSwiMmicd/gYuu3BgTDEA2CWaj705Axrkjv2+6QQht21/IU4KnphuoLBdPG/GTY1DaMd3iTnA9paUHNhTbYlPI4xlwKWLZpDA6i0Pna1i6tB7AmpbjdBRFBABe5WxbudTdMeUJRV38p+Xr9zEfs+zk9EsOm2qPp3PZU4F+PZcw2VaWEocNICDy/qY6R24Y3yvzT+zmkFhdFdppGPKUuZXLxZXtmsD+x/vzeknzUSGvW6QKNEvgysYL1zL1Y35lZFQZsCJwljZ5fBSNUv4RPxXpiFOr5tcEkfc8WrLiQArrrDRu3YDShWUKyhYF0d03jGpfJOZxo+yI0In+U+ebqYpGYvIo+JVBC9efXKrQ49lsREK8+hFIy/4PEhrsTkZ2n8BsiB7cnSUc7P6FeeiKzdcq7IUuxDN2bBGZPddts9GfTn7vBJxjlLSWuRNshIThq7wTqK1XQ/Ok+P8Q6ES+aqqOgB6UDemyKGaru0pXSm6YQ8caJ96w3ZOEjcDWjt+l/sDWPH+hSVZIseOad+uEo6qUno9wDFEo36sx/LWTBVsdf8DFlPEOk6Asj3Mac1yZUV+udsToUcVJ8G4DW3m6/NzezK/BDY9ju7hYXA4upAxsntyE4ram6QKfRiB9CMVNvTSL6nJ4aEfvQPbO8M6mE6ZZpka9BE7aSb9
 YGV2h/a4
 LzCcYqQNXIpjZnfPWxroUqAhfyquROhVheYtowbDEd0uMccWmMcgi8LALbBWBnPz/rOtzrdwUhSKCEq4yhyeqHZDZ2l0766RK6LwmQGFG5yE5zQ0dp17Sqpgv6AK6C3qmebJevd/pkaWDJypbtbG3SCbGUDxjoH6UoP8UmD1nCMs/byX0De1mdblynQhwqwNefX9swsYMuvt91FtjPdYevXaSBBApr6tboOZnkJM2kXfDa56Ue8Aq9zS0lyYkbDh+jpqWIhSslRaqMEhFMVu1iK7HCLJ9YG609A2kPzsUbTzAECroik+HkUWWCAdeh4hqtcuEwnK27Vrcu/hE2VG7AviRl88+obtKB/Y4/UVj+7ALGxLwd3D3gbbvRzpSyU9BhEy5uPGPH/5zgZ/mLQ0LjCDzLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 10:02 AM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [High] mm/mglru: premature loop exit after aging in
>   try_to_shrink_lruvec()
> - [Medium] mm/mglru: late max_seq read in try_to_shrink_lruvec() causes
>   redundant aging
> --

We can add a bounded retry for this case, along with a concurrency
check to avoid concurrent aging mentioned above. Then I made the
patch as below:


Subject: [PATCH 11/16] mm/mglru: Run aging when one type has no populatable
 folios

We may have scan budget remaining for anon or file but no
folios in populatable generations to scan. In this case,
`scan_folios()` may waste time scanning that type while
the other type still has populatable folios.

Run aging in this case to make more folios populatable.
This also helps respect the scan budget distribution
determined by swappiness.

Move aging after eviction to detect a lack of scan progress
and avoid unnecessary aging when reclaim can already make progress.

To avoid excessive aging, allow no-populatable aging only once per
`try_to_shrink_lruvec()` invocation.

With extreme swappiness values such as 1 and 200, reclaim initially
focuses exclusively on the preferred type. Defer aging the lagging
type until sc->priority reaches DEF_PRIORITY / 2, where imbalanced
aging is allowed. This avoids unnecessary aging at extreme
swappiness values and has shown better performance in testing.

If evict_folio_lists() returns 0, retry once if aging has
successfully advanced the generation.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cb806ce0a8e6..d68fc456ca7b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5198,9 +5198,15 @@ static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[ANON_AND_FILE];
-	bool need_rotate = false, should_age = false;
+	bool need_rotate = false, should_age = false, retried = false;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	/*
+	 * Avoid aging the lagging, unpreferred type at extreme swappiness;
+	 * rely on imbalanced aging once priority reaches DEF_PRIORITY / 2
+	 */
+	bool allow_no_populatable_age = (sc->priority < DEF_PRIORITY) &&
+		(swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS);
 
 	/*
 	 * Proactive reclaim initiated by userspace for anonymous memory only.
@@ -5218,22 +5224,19 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
 
 	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
+		unsigned long orig_file, orig_anon, new_seq;
 		DEFINE_MAX_SEQ(lruvec);
+		bool no_populatable;
+		long scanned;
 
 		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
 			need_rotate = true;
 			break;
 		}
 
-		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
-			trace_mm_mglru_aging(lruvec, sc, swappiness);
-			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
-				need_rotate = true;
-			should_age = true;
-		}
-
-		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
-			break;
+		orig_anon = nr[LRU_GEN_ANON];
+		orig_file = nr[LRU_GEN_FILE];
+		scanned = evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH);
 
 		if (should_abort_scan(lruvec, sc))
 			break;
@@ -5245,6 +5248,26 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (root_reclaim(sc) && should_age)
 			break;
 
+		/* Limit no_populatable aging to once per try_to_shrink_lruvec() */
+		new_seq = READ_ONCE(lruvec->lrugen.max_seq);
+		no_populatable = allow_no_populatable_age && max_seq == new_seq &&
+			((nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] == orig_anon) ||
+			(nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] == orig_file));
+		allow_no_populatable_age &= !no_populatable;
+		if (no_populatable || should_run_aging(lruvec, new_seq, sc, swappiness)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
+			if (try_to_inc_max_seq(lruvec, new_seq, swappiness, false))
+				need_rotate = true;
+			should_age = true;
+		}
+
+		if (!scanned) {
+			/* Retry once if aging advanced max_seq */
+			if (retried || new_seq == READ_ONCE(lruvec->lrugen.max_seq))
+				break;
+			retried = true;
+		}
+
 		cond_resched();
 	}
 
-- 
2.34.1


> In addition, calling evict_folio_lists() and should_abort_scan() before
> should_run_aging() causes scan_folios() at sc->priority <=
> DEF_PRIORITY / 2 to evict directly from max_seq before
> lru_gen_imbalanced() can age page tables to separate hot folios from cold
> ones, and skips aging altogether when the first batch satisfies
> should_abort_scan().

I think this is fine. We only reclaim a small batch of folios
(MIN_LRU_BATCH) before checking should_run_aging(). If reclaim
satisfies the request, we can avoid an unnecessary aging pass.

>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261113185541.70203-1-baohua@kernel.org?part=11


