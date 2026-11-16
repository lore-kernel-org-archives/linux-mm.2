Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF88B606A88C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S2Ai7QQ0
Received: by kanga.kvack.org (Postfix)
	id 2C3CF6B05B0; Mon, 16 Nov 2026 18:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BBE6B05B2; Mon, 16 Nov 2026 18:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1156B05B4; Mon, 16 Nov 2026 18:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0B666B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:23:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D2BCA719A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:23:51 +0000 (UTC)
X-FDA: 85442561862.19.704806B
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8AD2620005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:23:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S2Ai7QQ0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794871429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=389tp1/miXi0Na+zQKVdQniiWFMCbw1dAreIa1rH3JY=;
	b=GUGnGBt1wiubLCigflz2pfCeWVpbjVzGlaZ/Csv7YKC5UBYlYDdOhjGD/VRskS7vqKcJYp
	mRERD8IjqMDaSERPRyU5T3ErryBX/XRPSKdtFmZdcpsYU0GByKp+820I/ZdpCpu892y/fl
	4oOeeto56n2ouwYXYZX5ZW40vNqAJvU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S2Ai7QQ0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794871429;
	b=C0DKcJB46LXcqsmyYWdxPJh6DQcrkjXpMZ08/TruE8yv/femfawKsqhmvPiKf3qqioJ/qo
	hwyrhUPLpT4bts//mByHJuei+fX6DPBq2am8/QMJk1EWr5tgmxootVtgQLCmQNbN9+iszc
	O0ROESNH3USVUTicIsm9kj+4iFR0F1A=
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-43bf9548df4so5366470fac.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794871428; x=1795476228; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=389tp1/miXi0Na+zQKVdQniiWFMCbw1dAreIa1rH3JY=;
        b=S2Ai7QQ08tOa1ATli31qAz45Gkza+mMiipPknP7Ip36yGpRVn+svLhYbWXFfKmxO0u
         4V6bUMkIYzJm/xNyN1t/BVNs5ezn/jJwv3xwbH97ORVciB6rQLLSgmKkGj49IvQXLtiA
         /SxQF7gy10Bsa5/b+z+cE+Rwka9usWnDD9Dv0ln8IY3APMvfz8weVCaFCySSJ3eQNvFw
         ZuwSMT+HQXdPWu/XnGBK41BjQm85fLmw8Rs9RuBRw/G9YbW3HFM1Uh+NauDBwckuXZDF
         TvPxsRLdI/rOuJ38WLYbtJB1XRs0boGSWhGCzoV6To20Iijp3fAgeoC3YwrlFEtXsDJp
         euwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794871428; x=1795476228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=389tp1/miXi0Na+zQKVdQniiWFMCbw1dAreIa1rH3JY=;
        b=Zk05h6ZRVaLQFx1Mfka4OOZyNMyQMCdxPawvIwtjL/jpedW2wUhd0szdj/7GOqlSXF
         wshx9PHzlRGRX7sZRVWRxA90OtkeoMgNMVGm5I51f4GbOAEiiJL3zUUtMmwyWaPV7AwE
         1jwhATplmP6Z6U7E5XJIEAmO36Hf3a9DnlSXZO2o4ZW1KXyN6P6ftc+Wodi5CCb4NnvX
         4h5HiYR8dqG58mR/5tb3gEKZ+hSmStPJR8mW2iZu2AA/tiO1xRr3KkBoFbTtSU0m4hwx
         aF1Wxx7/9jIclp5egx3IB1X1c3UQGQkutEvJ1ifaZMJJP8dWXe1ivqV4uUJuKXTOEuZV
         4/hA==
X-Forwarded-Encrypted: i=1; AL+hErGbxbLjC5sXqU/venz82mb5eHw4WQhbH2q/k7MJJDA+Kc5OYgQbh6FCSAbUCpx5ToNgGkYquoTUsA==@kvack.org
X-Gm-Message-State: APuU4Z+v0/gM3+Iy9jm5PQweqzGeySGybh3sJ1FLhvnXvbrMZj45zbP5
	cNb2zi5dYoC9zVFvVwu3a1xJbV64z/WeirhNmJAWPIIuGxlbBq7FQweX
X-Gm-Gg: AYBFou1GdZriUa3YK9neuumZaZTa2+Erk/sVXX2cyv3fLI9RskyFoj1XnpAjN9rzs1R
	l4b9PN038K+yevTXXTtEf4w5p/gQe7LotR39nKugCwR9JALXdBRqsVTFGToHmxTdIe5c+mleVQO
	MPeoqJ9MOxyrvYq1pBEjTPd6x0yYoQx7d88SCvxmmGNlgFptf+W5Tm0ZAiRzX1IVorB9qv4ioJZ
	6IKL1S9b1mHoZfYLQluaZ7pB94dA8PxKGUhw8oiqOKZKTnebgQLpGSn7z0n3wgMZ4AqLxusByrv
	nCsNZSohKAk4u89UijzDRht8qLeS5aBpjFuP3/Z/aIGPn7kb4wFbfvtLtgxAOLmENp8SvnIuwns
	RlDq73EXQi5bFCRSbjiEi8vMvypz2AempcOP8Sbiucd7OrX7Jjpc1hhi8K3LaUKhxvfmwJFvAVw
	g4/c7LZQLaM7AUqnm9QLTMUzH6TPuuCzJ2dJPjvE6a3qUVn1UaX3j0DjUfjqv+O8E6I0U9QqNTQ
	xmVeCvCJOs6y9lKY64v5Lap2yp0c83BnG1B0GGCb7S+Ytp+NzQJGujiZ8Wre/InYfniMM2oFL+Q
	KVqU2/GZHKZiQ3CfAUcfbeklexKsihcYpyScAgkHwZszsSUVX09tSkF1
X-Received: by 2002:a05:6870:328a:b0:459:fe2:ef54 with SMTP id 586e51a60fabf-4afdf0c3b63mr9465970fac.1.1794871428595;
        Mon, 16 Nov 2026 15:23:48 -0800 (PST)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4afe200ffc6sm7539556fac.1.2026.11.16.15.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 15:23:48 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 1/3] mm/page_alloc: drop unused gfp_mask from zone_watermark_fast()
Date: Mon, 16 Nov 2026 15:23:43 -0800
Message-ID: <20261116232346.788145-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8AD2620005
X-Rspam-User: 
X-Stat-Signature: pt6kt68g3p3suchxb5aw6okpn5emqjba
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794871429-21258
X-HE-Meta: U2FsdGVkX19JbA/pVqUqr8SmhygSkMSesbypP4AWVhBWM7iaMzCdlXosiz0Ic6YuBffrj3O7F5yteI7YFr/Z8S7NCjxsjmNvfD5LQKUsxjgCcUPUBq1oQdbtnxxfwzZWdWsyS0qTPMKQOEmp8rMop2v76TByP1GNgNFEPmcJ/IjRc25nyU3vKW8kn9+2l/8T1yXSA6L4hmT5vIggWAlfE1CuUsgii5O93ehdSgXi3JLxm8JlJKyeLjkifQyP2T0fyWL8V3uEnqq1fQI3AEVzJMukRCeRDg+ZaxGfof5zZc0o5MbIkp5Q6k6x2UjKsNBgLyf0PJM5ajVIdEo9lr2Yb/gRpwI0fZCyKWDgB/bkEIV+nq97govnTGZhsEX2luZ0jWE+SSh05RbeIEJA6UmztNQcgcLkjRN4VQjfAV02dX7wbx2uROUIj/jXdbB6ymgGQ8xZm6o5HMGcnWj2cMGIeemn3YJy+Ixbss3nujBsuxM1nv28RLAKlGwqEXndQdP721SMEIfpGhHvlfvzUzlWnPRMJS66Et/tKEKrKvtObZmQH2snorUgATRgF8JaNuLZpl00RNgkcDJJI1o+IxGZUoPJPCAdPacoBfkPNtXi9yMQ4Adn1zKGyf/lOl6t2NzkkNGYlslyRPq4jbsASaZxJm8hMF7Rmzf9iGpo8bRyPQiJ+L5VVITMRJmvS2EmoKUIjq70ijBO3A7aD+9FzcSqXOAyp+NqU1P2+Lj+0VhrmKJ9KRQkkMOF+sxIK4a2Td3kzwPdkGOHltsFyOvC8Wg95beONoAywbo8ZXJ5wpzgDf5lDlaPejY7gHIAdGovbF1eEVqTXapgPmb9Fp3HrGGhfLb3XonPuCN4+zye0CrmPh2ur/Yz12uQgxrYKXpVux9IzqgTGB6V7WrYzJxR/sLGqkIABjDnqtP8DBjJbkKxjAAS7ZJG4uO2QO2qdpXsSKEoYvmPeuXr3RW06/6Yn4G
 cUZhWVEZ
 sbNVnkdiUSBFOPmqMqRUQ0tbnKw2eT5KMnWseRJQvfQ/w5JmMHisgwobJsDlVF548UybgD4gUntOsFRQSKSUdS0Ls0d32jQ5l00txtTP/HiBBOwFaiFhZ+IBQmemdFfAJHLK+4JKB6jJkcI63b5uDLw1betQf1saWGz9VJys6fos2wjd4j1FO+XRGdQaCa2J0ylOLUoeyu4cltGmhgvbbmQiGxeAUD/sHWeMb0aDpLvfR7OdJtpmWDLyBTH38EJ82/6W1kJ2TRHw32zK71xEmc8jIh3Gk4gN5EaIFY2X+/LcsNGjOZ3WDwYNhpdDXcS1f/cZlQVYIkrqSfbof8nPPFZ7H4/qkewW8qDltLSW0RzS9JaMdgS+ZQBKnNJstJpo1Dlgi/ubt+/SJSfpVvGEE9l+90hq3Mc5JLPLcag5hN+/oTmtAohp1YbtauZYYsXRhfWt/W9PzZ61Bnn4VV/prh8kospvWq6CGneQSTTFcdFfFWbA0ult0xYkrmC4Qp9J/VOf8m4Wg2OI/xUyBV+91Ivl/riJbhvyspgdhej53nZ930hKvD28ZJrpf8TDbvxYYIDmcWMCcvzbahOLbiWlhM61YGiu2bmWZ4Mpe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zone_watermark_fast() has not used its gfp_mask argument since commit
2973d8229b78 ("mm: discard __GFP_ATOMIC") switched the watermark boost
check from __GFP_ATOMIC to ALLOC_MIN_RESERVE.

Remove the argument, no functional changes intended.

Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9e1261521b6a3..4d829e5eac49d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3675,7 +3675,7 @@ bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 
 static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 				unsigned long mark, int highest_zoneidx,
-				unsigned int alloc_flags, gfp_t gfp_mask)
+				unsigned int alloc_flags)
 {
 	long free_pages;
 
@@ -3877,7 +3877,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
 			mark = wmark_pages(zone, kswapd_watermark);
 			if (!zone_watermark_fast(zone, order, mark,
-					ac->highest_zoneidx, 0, gfp_mask)) {
+					ac->highest_zoneidx, 0)) {
 				skipped_kswapd_nodes = true;
 				continue;
 			}
@@ -3897,8 +3897,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 		mark = high_wmark_pages(zone);
 		if (zone_watermark_fast(zone, order, mark,
-					ac->highest_zoneidx, alloc_flags,
-					gfp_mask))
+					ac->highest_zoneidx, alloc_flags))
 			goto try_this_zone;
 		else
 			set_bit(ZONE_BELOW_HIGH, &zone->flags);
@@ -3906,8 +3905,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 check_alloc_wmark:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (!zone_watermark_fast(zone, order, mark,
-				       ac->highest_zoneidx, alloc_flags,
-				       gfp_mask)) {
+				       ac->highest_zoneidx, alloc_flags)) {
 			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
@@ -5245,7 +5243,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
-				alloc_flags, gfp)) {
+				alloc_flags)) {
 			break;
 		}
 
-- 
2.53.1-Meta


