Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C9BC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801F06B0098; Sat, 11 Jul 2026 00:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1766B009B; Sat, 11 Jul 2026 00:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0476B009E; Sat, 11 Jul 2026 00:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2F36B0098
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:46:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD1404063E
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:46:04 +0000 (UTC)
X-FDA: 84975258648.04.BE7E6B6
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 197C840002
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:46:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fA1rAf4B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783745163;
	b=TKUrb8PujefON2R8o9zLacZvAhix2wkX4R1ZyxUqcgg9dRMv7fXJlFWjjFJ5qCyNFVb0jB
	GjWqlDPl0xTofev0w5ajcYkeSa/QcsfrZRpyvzUVvXYS5+517yNNtnhnSMiwWOhbmnqm/8
	bzOb4+e/Weu950JvGbR8ZfgmKnUnjRU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fA1rAf4B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783745163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rwiqhuS1dgr/o//ceIUYjpzsCv14pH4erOSkAkROOoo=;
	b=4QAtwAR54dEOE+70f1B2k7j127bFYzavxFaJTMYJs7i8ZUB/0s7xGof6e/hK3/yY5TTFgf
	PLeuycZFYTGIr/brzt7sK4zE2uyBWaL8MQiZqqx4exQTcUrZisIr2IGYgX1SkNHrOmrbR1
	oA22RC/vfKNgj7ASv53RqRVuu+6rvAY=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-80c5cb9a888so18363047b3.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783745162; x=1784349962; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rwiqhuS1dgr/o//ceIUYjpzsCv14pH4erOSkAkROOoo=;
        b=fA1rAf4BZxLkdFAL7khytrvPdrdFlp+k76DLjFZUR6FmsoHrg1hCWg5TBhAoTztdI4
         C43qmSjOtuRcBzqt7rl3rpG8yT3OamIJe5WuOYw1xiAXWVOm1IdCdMqtDQwbdViEq40+
         JktkzNd2w9lKi+1HWdbujS0SK89OacnoENQUNv+R7OWGVX9jVlHeHWKZ7xJxjr4j4sdX
         grjbv2i3Jd0dNN8NBuqSgagTCzQewrb/bxyZrnMq2HDDf4DaihHqecFhcpBo6pLE3xMx
         3pnsvNy+a2GTYbPf340oX2An6GzM6EFJQCZ72V4GyWyT1QjPnlMWFElg7Qb1EpXYWJLg
         bdvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783745162; x=1784349962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rwiqhuS1dgr/o//ceIUYjpzsCv14pH4erOSkAkROOoo=;
        b=tKb3MP3KFL4ldxtzOa7vkSEQyuAsS07oiIDIrQy3FsTH0C6hxpx2IDEaulm5OygmOu
         1brnPIYSBAR5+pQibiKdnleP8FBJ0FoFalRzdncIHLsbZnECaCkfvkoOEoW5PJx8/FWf
         Pt3Sygx0wNigRTARj6V2w+M3DT+Dnh+Xr4jjq6eo6cAKvUTZ6RI/gYICnOccONGYjj7m
         WNvyfqv6AU/h3Bu8EfwtiEt70m1Elc0Ju45NfFim6j8Mk3otZwiCp/zX7Ml06bl9B1pZ
         ndqLEUMShTzQm1X5ETQiAp8Osk9pU3SvI310/TQ8Mpa5gn+4EZSyW2r4O1727BIvP/x3
         0ibw==
X-Forwarded-Encrypted: i=1; AHgh+RrQY5BgnMq0aAVvHPqE2CVDjg0Px/tYjj2mHoRxKszOfinDp/IciH2/QEJhTutf9YuytB58M6awCQ==@kvack.org
X-Gm-Message-State: AOJu0YzPnlT+BR3pE9Fa3QE+oAG1Pb4mEqrYGapkPkNz4CNRMTAkqYJV
	2w9v2zF0g029373pL2aXbnAuVPF/cZPwJSp0Q5zh8ZpPIvsdEIFYEqW8
X-Gm-Gg: AfdE7cmmRXKxPxm3MOIcwXhIDKsHSOTyTrW1qLO91TmTw1RnTfCBrYIZtqrKXv1rWmp
	9Len2ZkQ4ITGAJlCm1xiT0PShLG43RuPPxGs98z2TPXaH8bcmHfiRnMAG0pB1PLzll/QSC4Scks
	S4rUApVKqOr4UW4knHHR3K59TJCxjszBba3yXD7NJfS7h5Zo2dzMflH7dK/S6iHV8TBwnX5esEX
	sW/836y4iMYNca6R18rCWjjVH/2FA09Mf77D33lvIBlGAdP7oCm3xgrlIYKsUKByY3WgBtMhm6X
	qUrb8ZDvJUhu94BQxouL2+qwKEMd7eS4MD6+hrDBr55LCLbVD24IZd9vvCnwQrY2ndkb9zyF9JD
	tzLk9/5NLFgEmt8A0V23K12aIjFQVdnSc9C3bNEJRUeBh9nnmEgNui47ooQRvPY1pd7GI8G0Chp
	wPVsY1RBJ/lceQD15g
X-Received: by 2002:a05:690c:688e:b0:81e:79f0:4898 with SMTP id 00721157ae682-81e9000683dmr11835697b3.15.1783745161966;
        Fri, 10 Jul 2026 21:46:01 -0700 (PDT)
Received: from host.arpa ([2600:1700:7c:96e0:d1e9:c04d:a97e:9636])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e950567eesm2640477b3.13.2026.07.10.21.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 21:46:00 -0700 (PDT)
From: Altan Hacigumus <ahacigu.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/vmscan: clear hopeless kswapd when global direct reclaim makes progress
Date: Fri, 10 Jul 2026 21:39:46 -0700
Message-ID: <20260711043946.68421-1-ahacigu.linux@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 197C840002
X-Rspam-User: 
X-Stat-Signature: s6z4gfmq6rdgxedmzr9t73f5c1b4x8j1
X-Rspamd-Server: rspam03
X-HE-Tag: 1783745162-879177
X-HE-Meta: U2FsdGVkX19TQfzZWY4G90+57qn/nSjrWbSEJyaOgTdAc/Dpf8iMhdXEPVN5DSoyb3rxzUgWIMBkmt2LrYNXME+XEC6Sz9Ccjm1XTAGGQxspiKkoWPOZWq5saTZzfSIIyTzjBpBYuN86bMMctgM6NDwVF26wcbQ3fsdobSctySwhYRviK2WgyV/BDQW5Cy5f3TZ9mM4h/jxLV46CX54oXVyqDxgOct4klajsbxLCoulP/llJzbbFdMiuP84rZNZUFD04vyJTXLrAk36BOdnXr3vQutPHFlru47WPSnh23HAtBK9K0ozm7pcgi5oWu0IgnlOUYlch9DrfHgaAMvjs+aE+q3Wn9zslhA0EQs70tyMkL5HppPgaxhA85v5ds9rfMp30bD9Ta32tcooGn9TTUNfYbpOVoTTfRRgn7Bv/IICAsM/zcZ8griE3yCRniMzY1Rv4Yei2gbO2j+q+28tbvXJa8omodlzsoP2kePoC+HpOz7PqrOgzEb9m8GoGoZIj5o8i3D0L4IEKlEvW9zE5wdes3jSDzwKZyhFgsDrJf6hMmwsYhaaeBPqG2U6/+Hj6vEN1k4OsQoUpX0Jk5eXRT+rZtLXwNvUgxhGdNqJiRWY+bWvwQd6kEL9llCTJ/heZdO3xbt/kUaBM+ntkDiFcEA/4MPupUPmkWKD6rnvyaYVRTSoqCUl150k4txWZxOxEIrJVyGZCyMVLGQLhymlALXsDeHgPO6Msqp8o89PgmREpBIZjO7CB0R7vLIWnGng11ZoX2uKzo3oszT5pjRw0EOC+gqk+rzVN9GQUL17Hw1P92oRyXtBcfGDnWUsrIbneJJkwg7brtlNH/xSHLWj9Rh+5wLY3zNJqZqv01uC8iBqu9020E6kWj/Mj3DBum5wMtNk/uvntQOAuElQxJdyEVUOWacp9gA7gsSf0UiEvd6Zn4yKTQgx//WUH3fwej2yMvxQhyAFbYQQL+ojq3Y4
 TiFKeW+e
 fOcq5ySl9kq780t5hza0mdZnj9hOf4CqEMj9O0jMq9CbYmnv38MvJYnyZTzmnM0rXv4V264lV19MCQjo+lSWuGuqTeKbST2NZsC3NnVxzd6jmIZnHNAcgNjxXGooQHIKXO/jtzba4excY8rTPSDMPt5rl2DuMVyY38Yzq0qJofbhJzoRq4PUOso8QSP/PbLC9ijnHJq0MhFdmE6xm0ovXbJXNg/TKWD3HOKnaqzzZuwODdNAlAIoA23A+sBa4v9dQs+VRSSfuDz+RweLStyniAKUH4TUbjjm8IpnAKBaugxy6tcM+MdoXDB382+333V9cpAU+Q142iDLvj5WJm4QOq+K6Q+yFKms6uCYFTob/wak2HkJlVFj0uYxpN1MrywMRHzgX5N4RGET0dN+HktjODHCQny3i43GU4apF7xBbGlIFBgU1weSq7OrJjyFjm07jIe1hicSZIt8GkdjSp1PkZAJDPcPBe6kLlRefWauR3wDL5cE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Direct reclaim clears the hopeless kswapd state only once the node
becomes balanced - added by commit dc9fe9b7056a ("mm/vmscan: mitigate
spurious kswapd_failures reset from direct reclaim") so that cgroup
memory.high reclaim cannot repeatedly revive a kswapd that is unable to
balance the node. Before it, any reclaim progress revived kswapd.

However, this restriction also prevents global direct reclaim from
reviving kswapd. Under sustained memory pressure, global direct reclaim
may continue making progress without the node ever reaching the high
watermark, leaving reclaim to allocating tasks.

The effect is visible on systems where a database workload mlocks most
of memory and the remainder is under continuous pressure: allocations
stall long enough that ordinary tasks (e.g. ssh) become slow or
unresponsive, while kswapd sits idle.

Unlike memcg reclaim, global direct reclaim follows the same node-wide
reclaim path as kswapd. Clear the hopeless state when global direct
reclaim makes progress, while continuing to require a balanced node for
memcg reclaim. kswapd_try_clear_hopeless() becomes static since struct
scan_control is private to vmscan.c.

On a workload with most memory mlocked and the remainder under sustained
churn, with swap enabled, comparing the same 60s window:
                              base       patched
  allocstall (all zones)    413441          6532
  pgsteal_direct          15889552        255619
  pgsteal_kswapd                 0      26079382
  PSI memory full avg60     13.10%         9.37%

Direct reclaim was already reclaiming many pages in the baseline;
this change lets kswapd resume doing that work asynchronously.

Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
---
v2: fold the impact and the origin commit into the changelog
v1: https://lore.kernel.org/all/20260710024429.70923-1-ahacigu.linux@gmail.com/
---
 include/linux/mmzone.h |  2 --
 mm/vmscan.c            | 23 ++++++++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..1db6f8dac927 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1630,8 +1630,6 @@ enum kswapd_clear_hopeless_reason {
 
 void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
 		   enum zone_type highest_zoneidx);
-void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
-			       unsigned int order, int highest_zoneidx);
 void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason reason);
 bool kswapd_test_hopeless(pg_data_t *pgdat);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..78fd35a11eee 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -198,6 +198,9 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
+static void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+				      struct scan_control *sc);
+
 #ifdef CONFIG_MEMCG
 
 /* Returns true for reclaim through cgroup limits or cgroup interfaces. */
@@ -5172,7 +5175,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
+		kswapd_try_clear_hopeless(pgdat, sc);
 }
 
 /******************************************************************************
@@ -6251,7 +6254,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
+		kswapd_try_clear_hopeless(pgdat, sc);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
@@ -7530,15 +7533,17 @@ void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason r
 }
 
 /*
- * Reset kswapd_failures only when the node is balanced. Without this
- * check, successful direct reclaim (e.g., from cgroup memory.high
- * throttling) can keep resetting kswapd_failures even when the node
- * cannot be balanced, causing kswapd to run endlessly.
+ * Reset kswapd_failures when the node is balanced, or when global
+ * direct reclaim makes progress - then kswapd can make progress too.
+ * Memcg reclaim can succeed where kswapd cannot (memcg protection is
+ * not enforced against the reclaim target), so its progress resets
+ * kswapd_failures only when the node is balanced.
  */
-void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
-			       unsigned int order, int highest_zoneidx)
+static void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+				      struct scan_control *sc)
 {
-	if (pgdat_balanced(pgdat, order, highest_zoneidx))
+	if ((!current_is_kswapd() && !cgroup_reclaim(sc)) ||
+	    pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
 		kswapd_clear_hopeless(pgdat, current_is_kswapd() ?
 			KSWAPD_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPELESS_DIRECT);
 }
-- 
2.55.0


