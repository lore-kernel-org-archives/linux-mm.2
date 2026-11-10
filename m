Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97038606A330
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vtufjA5c
Received: by kanga.kvack.org (Postfix)
	id 8249F6B05B2; Mon,  9 Nov 2026 20:53:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBD36B05B3; Mon,  9 Nov 2026 20:53:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FB76B05B4; Mon,  9 Nov 2026 20:53:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2F26B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:53:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE336120873
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:53:54 +0000 (UTC)
X-FDA: 85417538388.29.F49BFA2
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2738820005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:53:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vtufjA5c;
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794275633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GdLDSDC+vsdZUjVsXlUGs2pDDNs9Duz5UHyhjDf0AK8=;
	b=54ZsXPFPP8WYyZjKP1KZbFjsnnm15JsfGIccokR7omzLG6vyxC9bJ+hkvoyYAxQNxWRpkt
	x6CMYHeoNQc9OF9Br6vpFweuK7efodTF7Q4naZCW+kbaDa0ZK8YpVaW/UJKrXGSsVeXqax
	i0gCwG41RyCxLjWih8R0jq2H6ZpzAtM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vtufjA5c;
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794275633;
	b=AgcAfer9TdWPWVK6Sv6aCUW+T5ycSUWQtdJGPEME7/MCiDliVqbyHSatPRTnqAnQEu4+E2
	FUH7L66MjsjoEYMAsnARrnHv9HwMBTt3mgGeKby0Kn5JXaPTSl54mEpqxu+y9VcrXMs9Zj
	YT9de29xPlo4MDOwGacbTcssWBqvV1Q=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so890899a91.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 17:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275632; x=1794880432; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GdLDSDC+vsdZUjVsXlUGs2pDDNs9Duz5UHyhjDf0AK8=;
        b=vtufjA5c4aqNGsgO5fE0L36009+QbQkPkNIUjyytZTgH1we/etNStIDguscoLYY2iY
         WVl8D2B/QN/OI2bPm51sdOClwZMyhNzjyaxPx9KA0rONJEsrNnGb14dI9JYWNwEPU4W4
         2d93QGoQ5/CaKCO+4EdtjcaRd2FLKMw3mFKAabA/24v04JvFLNfpSlprqfy1+OsgYrJH
         An6ixA9+CWzry4VeD2L9oWI7aXwtvqpB56EZ25i7v0YArpHXaOrV4VVvGemjGEVCQIq2
         3UA6Hy7W12mvSmfR3pMd+BdN9f7q30pNV0sX6VtmvW9bc2RdOTRgzo+p8HBuxJLaLB0q
         U/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275632; x=1794880432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GdLDSDC+vsdZUjVsXlUGs2pDDNs9Duz5UHyhjDf0AK8=;
        b=kyt1sMNfa5C6hwf74xqwpodcwsgP/Ts4CmPKFMAJM/7ZUmfniqbpmHGFt4TQpzmLk9
         vx5whnKwSfI6UiWUL7VtNRtVoiNkZIc8pBbzhXPuHX9XP7wk5UZ3JV/q8beP2jk0v9fN
         PeNiSCkAbRZ0b40ucUw+aYWE8ZvqHITxaV+r3VFe11mvhka1qIgeiX1fW3UBBBnUTeDM
         onKUSI/YdPjVv7tN849g5jyK1l5mrZLaZOcLDCFtsEv1JVb2fSHNeJU+5InNUi1cjW4C
         i5rVec2My0r42fw49hLyXSp9j9pC2vCvcCeCDhigL7bSl/twus5fG0bssX8BahBQl5W0
         sXXg==
X-Forwarded-Encrypted: i=1; AL+hErGiVA0bYAb/LZowF/mU5B9+Fe+rb8tk9MWlYx3Lyocb23JZKpVvEDRCGcTLzZZG0YRXSgtyN4l1iw==@kvack.org
X-Gm-Message-State: APuU4Z+05yO6h8WR8ftys+xF+F8UkuXBC3SPJ1/e5LIrIenqSlly/vaW
	rk7q9bQVVqBmg5euaA2Iwsjz0a9wHImqY9rdf0Sn/nbvrxSPb9lHY7mz
X-Gm-Gg: AYBFou1SLSilLNPL/TJ34fcyfUkyxyqCj7dMpWef6SpArH4eB8Gki4ZpUozruS6KkZv
	KUDBitzUXRktG622zTF9Z6WyMp/yU4N4yHnREBAauWhv2c6qYeuhYMKX4YCoS/oQ2+YWYasXLSR
	LHEfFqwfep0Z3n+17OOY+BxP+gmiusn7TqKX7eGjbFoOlRNIfH65VvhBkZCIep/WQQIfgNXkkjW
	Wr427/6QTpyKXL/Kzm2NrCCjAXyHpSo9X05usnPmFcAzlaed9F6GBzyz2Cpg7JKybUq9SZmjiqe
	b9SQbEX1/nKUrUjq4OLV8b/6kjM6rZxHsvJVivafuhoTGBCNrtWiAq53wSwJqVTn9qBIHy/cMGw
	FBrljtO0dOdp6Y7Y/cmoFBgHYFzzsth4nvPBdXxFFuIUzIPsDJXhDy9etiKahVErapWBFn+akBo
	dkgFGduetookLW36pyG6LbGZbj1EnAV1ttJDwK92oYTwAEHNHJQ4SdPk6hlMFRU4OVxYR9+BN1J
	WY9y6B0HLeaMQ9J+HK90k1n6YhS9hODqPtWkBAQlJGOiEZNqO/2fWWAeZ5SipdBpeuMCg/vWW+Z
	E/5M6wCU8e9xpjeqafwJcSB4O9lfd+CxVJpeyA3gUptbsIXzny5VbEqBH0zIh+KaPlJ1HzElKbC
	gyUzIUg==
X-Received: by 2002:a17:90a:ec83:b0:3a7:b260:9ced with SMTP id 98e67ed59e1d1-3b166cecc28mr1377225a91.58.1794275631979;
        Mon, 09 Nov 2026 17:53:51 -0800 (PST)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b167970669sm1564096a91.13.2026.11.09.17.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:51 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 1/4] mm: zswap: fix shrinker count for the root memcg
Date: Mon,  9 Nov 2026 17:53:18 -0800
Message-ID: <20261110015321.611093-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261110015321.611093-1-joannelkoong@gmail.com>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hdp8ihhokkn1dr73fynn55ybr6goattc
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2738820005
X-HE-Tag: 1794275632-978978
X-HE-Meta: U2FsdGVkX1/PaGwkU6qP5hiS+xdltj4U7HCRNPA0UYISF0yC8Ma2ljao0I3oaS/qKFD1R2KnbkymL/4IPnFX0ONi8NC5CYeHe0jnBSeC2IwzNLipDGcVJYVRY3ULsfT0YRcH2iBHoT4yHdvqmIS8aLuunw9qEyOfn1Eji301UHEW0jWqThbcOo96nRaU9OUf2igw58xyquf2E/YjVclufszpOHPAuEm9lxMhL22HfxB0zEl5KHaovqImMfbNgfQlMZaKQ77oTtmPK4lqM6zpaA5J3MVat33/c3CvJAgD798cJJd0PG6zI7Q1ICiSMXhOXT3YQuijv28hF2bmi5N4pIXQ/6WJoWjbdayEdeOfPNmiZSI2jD+rq0N1acQwEQBccmmxmxI0MRAdqQIaP7TGd0IdjAL9iuiXMWs8d7TvUXt9y2pzopxESERWV3j+mTl131sWqw593T5u8eXHbjz0zejJxYT+FCaaxWXQdFvvltU8IJtYbmrWeUeHOwbbNtbuINfTNRX1YY+j35pxYel1SsU3KWTHAjEUDiMUQq4jRC9QBmpobX9I7rUqRavPPDmV5h/7XGOqvZuSWO6vvSFxUcwdEqzL3YosdIepOvgh4BqLP0ZSkw8UlUdn6zGFzalmqbfisYAWvrole/jKDYrlvJfvUJeodapRA+tVrM8tws+9n0UEkykeoVsqcWHJowvie414DVQCDC580iaCo7wce3wtwqYSuYuk3w8mYrpb67usYHKhEES/9x9IOfZBEfEtZx0+QlYKm6EjGgO2eRiuJDhTrjyCzTBxxnZFptpsA6gOA+AgUZPXozj9xV3/ArlQNpJwL9ILkgBrPsB3PoD3eTXsYFtA02wwBWN6iEl1GgsKPm7wVeujBU2Vo/s2fdJm4DyJYKozHy0aYT+0n3slJGBUkrPZBjzBQRc6DhQK85RnTSwSUmg+RTKgPy8uEDjIJNxQU4bI8m4NrPaQhgu
 EalLn+C0
 gq5aXeC8zn2kwoz5YTtPfkhvouKf642aNleZN8EFo1P9vS408JYiEaczo6ReURRXb/cYbu/ojI2ow0eTS7wMd1eXLPD5vMWCGkbeN7z2Z9ZAOu1PxL+phcnhm+HlBhVc8kr9Ze9b9gqt/cxszIf6PneGqYevDdgr/BxKYrYR+EwSr8h/xlCASrqH3eQbEDDw6252vY1tQr86n16uylOhdy8fBvRL3qPkIwvjokFCOYLCcR2wkjyUJVCXEgUJUq7AKSky1rwYWCD8rQQcZmgPnOHOJRv9m1icF6ttTk64D5eXAM800CC1G4dYOtVQP8AiGmnV5WSylc3Pa8ygmO3wvL963E4qGMC/r0zXXo+NbSDhdKGkEFiuLgKKMYSDmS9EoYm2uNqs8a9PbBrkH6p13qS3CrQnk72ECdGFS9d3kZ9Cxr+IwXZ9OYvnEjcPjFc8vXlcZAWOmhy2020Om+IGont9qNHQX/Y9p8yWo2/r7/q3H7cEEUtqdCUfV1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zswap_shrinker_count() scales the number of freeable entries on a
memcg's zswap LRU by the memcg's compression ratio. That compression
ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
stats.

However, for the root memcg, the zswap entries owned by the root memcg
itself are never accounted for in the stats (obj_cgroup_charge_zswap()
skips the root objcg, and before the root memcg had an objcg, its
entries weren't charged at all). The stats only reflect the entries
owned by the root memcg's descendants. When the root memcg's descendants
have no zswap entries (eg when the whole workload runs in the root
cgroup), the shrinker reports nothing to reclaim for the root memcg, and
its zswap entries are never written back by the shrinker. When its
descendants do have entries, the root memcg's entries are scaled by the
descendants' compression ratio instead of a ratio that includes them.

Fix this by using the zswap pool-wide counters for the root memcg
instead. The zswap pool-wide counters cover every zswap entry, including
those owned by the root memcg.

This also gets rid of having to flush the root memcg's stats, which
flushes every cgroup in the system.

In a VM running a reclaim-heavy workload in the root cgroup with the
zswap shrinker enabled, the shrinker wrote back no pages before this
change (zswpwb stayed at 0) and 1016 pages with it.

Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/zswap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37d217860a6b..c11cd2a6e24e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1332,9 +1332,12 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	 * runtime-disabled: we can get sc->memcg == NULL, which is ok
 	 * for the lruvec, but not for memcg_page_state().
 	 *
-	 * Without memcg, use the zswap pool-wide metrics.
+	 * Without memcg, or for the root memcg, use the zswap pool-wide
+	 * metrics. The root memcg's stats don't count the entries it owns
+	 * itself (obj_cgroup_charge_zswap() skips the root objcg), whereas the
+	 * pool-wide metrics cover every entry and don't need a flush.
 	 */
-	if (!mem_cgroup_disabled()) {
+	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg)) {
 		mem_cgroup_flush_stats_ratelimited(memcg);
 		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
-- 
2.52.0


