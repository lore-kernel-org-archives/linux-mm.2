Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A37606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uNDxbkGD
Received: by kanga.kvack.org (Postfix)
	id 437846B05B1; Mon,  2 Nov 2026 17:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F036B05B5; Mon,  2 Nov 2026 17:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AFF16B05B6; Mon,  2 Nov 2026 17:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBF3C6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:51:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C030A0223
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:02 +0000 (UTC)
X-FDA: 85391675964.10.1C59851
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 898C11C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uNDxbkGD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793659860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EN7S1V6hsPYuJ8/hHPqk/DKDGgJqqDJKvPrCgDVd4b8=;
	b=hpPr65/3M586j2P9Nz9VrIJgIiVPxXKfgFmYYJvTifkMqknTh0iOadkd5nie7uety9+kaO
	h+WE3r9h8C9GzLpXcAM1yWdMZpruRNI2vgODTO//jvonUvmJgBLG08RPYObptOiraZhNkO
	wnehNVkA/MuGjQf16yrGUpD0BOEbk6s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uNDxbkGD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793659860;
	b=IEREDsxPzv6XwKqYuqdg4/EdT/612LKlxeJymVJE/kae9FgcQwDx3dt2uSVjlygAGK/UoP
	+T+Vrl+i/7FkwzgQ54p6ctSncH0N8j/wZyKmeIFkQ+IA/5g9kWrkrVIWA4phaQEhFl9v12
	3+VdJjOYBB2Mbm+AC8BCi/aBNO+zD1E=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8ad98c3fb15so30277407b3.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793659860; x=1794264660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EN7S1V6hsPYuJ8/hHPqk/DKDGgJqqDJKvPrCgDVd4b8=;
        b=uNDxbkGDTkeZZEkJ1F99FyAi9AZi7GFmRZVbMF160iIPTnx+jirLAUCB6OZJdzk2Sb
         P09XfyDJbce29WACEPWINUW5RESqK7mcvXkKCG8/W02gOxG0DIeWFH9bHSq+rziwDP1S
         WZIaN1OGLl9BJZrJvdUXogC+fa1/l2p4fql7IQCmoLiLcchSz4XC7HtZ3K8WBgbZt9la
         ZGOlbh5VDZSFKGTDHb700I8rzy/I2aS+BRCy4jW9k4yqXDdEjGFvJoaHkeOZos1ZR7Vr
         W2IXVzGTNtPVSd2ZsGOknbvl+3rKBwkPhIoW/wrB927Q0VZl95UyEdC5rV/wnFjLVCBf
         Mpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793659860; x=1794264660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EN7S1V6hsPYuJ8/hHPqk/DKDGgJqqDJKvPrCgDVd4b8=;
        b=fOYJhh40su2Uj/IihL2v9pw21IdJQLseoT2ucpzrVHR2neWlwghbf4/lWpZ6eF8HkB
         fQRN1BhntrwlRGaUDcH4Xx6sCMAICDqRRcUWkNANiEjaezHqxEQO5EQu+bOh8tHbLPb4
         f4z1YOt8kbWC97WVubxH81Gx5eRpWQaQRnkwwiFJw2qG2obV1k4xK4TCfua5Zx6Evbvo
         wnwE1FJfCt6fpzppfwdRJF0tKng6v1m5qAwVUvzPVjuhN6lYdnZeo0wnQDn7JzmorBPn
         8GT7YXglMrQrM9Bsbv0LkhoPvwUqBCJfIrdgZP39cBl6Dcrg/zIFvcSQwaIBg08+/kU3
         JuZg==
X-Forwarded-Encrypted: i=1; AKwUvBzg66cBPKFglUgFJwWL0Jx6Q29PNsE6pqg9XiQpdVuVqVx61iMLWOUX20l8cbkdiUFhw+01Sj7j3g==@kvack.org
X-Gm-Message-State: APuU4Z9FGFn/eILMoqm5iBAk7RjV8Vo+BaFz3yIUPpSw/l+bFuU/yeQA
	RuaOEoHz/gDrB0nJS5MrmjbdO0YeJWSRbCqH4t3BHszXctakkn//+qXR
X-Gm-Gg: AYBFou1xKP5YPELZNdzuvSn3+qsbOITaK2tbQ9N1ZAUOCS6Ody16K++RNIDLVtPf8yk
	lCykQWaZaTISdTZL4Pac9Sn/ScVb7FM7vZNPgDDo8DiNeWzXQymtpFWqRkGZx6LSLyI4mng4eIN
	8g8PAyhzv4xQ6SnzXr7lTWXbKhnzRGmOEy5jkV0Nb46d20EFfyEAZ7bugzuPfBIy2chtetxdEhE
	qm3ObWy8Fm+iOwvBzJrhCH3OHHJt6J+zbttPsPg/6sdFGFdyv8dZL4Cbd76LOeFEHyC9HesbFzf
	YifIzEfSL8t8af1JdR8u6AecKF/0fUeH4nUsDsYwiIKEFZfnpgy7oA3JyCocKT5tsCk7GGikic8
	ESMkrCqW7kETrHPp1UuhXmwjfI6xgvoGsVO5dwmZi7mifpvtPd7ImFqSqXh5t444TawawLMnXFT
	qWDUkxiciDjfGyRAHgFoibqb07yi5+dYbVwHEvsPwQU0kndF0KhdwRg4sbVLO8ExzHdnA+cxqIe
	FVVY99oI3RKSDebuXi3l0ET9GcTr4qlJghOxVGg6kHzWsetD+pSLkC5xTktrdtVyw6RrW2ILrIH
	pASn0bCNNsBUCBWx/GRvnFnFQcxGIzdWuSq8n6Vi6+Zj0RDYpFhlDPrQqjiobOo/Tex9EpM0PDS
	GYqDLTA==
X-Received: by 2002:a05:690c:dd5:b0:8b1:7072:a61b with SMTP id 00721157ae682-8b2b67323c3mr92119087b3.22.1793659859510;
        Mon, 02 Nov 2026 14:50:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b714bdafsm61225847b3.19.2026.11.02.14.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:50:58 -0800 (PST)
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
Subject: [PATCH v1 1/3] mm: zswap: fix shrinker count for the root memcg
Date: Mon,  2 Nov 2026 14:50:28 -0800
Message-ID: <20261102225030.2743129-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102225030.2743129-1-joannelkoong@gmail.com>
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 898C11C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: oo7yix36bdxn4r1izpnyq4w3p5974byk
X-HE-Tag: 1793659860-864431
X-HE-Meta: U2FsdGVkX1/82RRA6c24Dk/atnvmdJnk0pK6hOSrZovyTZJf1vDjEQfrbAFLn0I2u2QkfVW8GaTFnw9RSAjEMPlp7z7aQjTK/mtVatohGWQbW1fDjJEY8quJc1szD7r3wZQuDoA0bKBRyKdMpn5HWu5YA9Li9yQxW1oXe1kty4mN5VTadM+dKHsdcJ/relgaMgLGvY5H1dHuwR3gEo/PyWWBNdMvaz8MpaEE6B7zKTBVImycwMmX+eGiI8Z+5POceOKYPNWHS7r096YU86WwRybDH+z+9LAvfO0gHfx9q+ccg2BA/Xy5AQsDqzP/fCHtOa6f5Hxg/DaWSIR5hTf/tt88RaCeasn+sc11X5C5MiJ3l4AWDhX1TAIR1KPip19nft5AUZlodIIJ/UInZeCLF7YkwSTPOg5lvbsO3TlEVvcmDmUTuKEP1VizXn6WgA2pbztiDkTXCNe1GuQTK99+dymzQMcWojvDKeeaLZW3bjAOqh1GZhN4xErMWy3e7EQXryEudRBFujnKQe5LFMSFJ9MJVi6kWtwGeQFyGCbLcs/q8Qn/H6tRQyCrv9LEOTcbqQnt2Kh11Z8tyMrrtQnqrVI8doOjKwY0rxpuxBHy5uyqakU6QrJnkOZnOFY1kn08vb0O/jsGjCZRwWAsQjJNhURKxp+8Ft80G3AvqjYC+GMPECuZeaLGYIp3f1JIzgjiKsm09qqQM3ZGFxBTZj7uK2TerMPOTcpkjgmeDN50ISV2kSAA536ZyL9Oe8o1ssbJLkUC540F/FcVM6vuFwKyaakmuc+85cQBNLqjDrx1g0pQVII5ZLVAQTwP3os60PadrZTsIqkhY813DJvvhxFKGuQb3/3TunFYL7y/ZMf66YkV/VcBaf25EkRODYY7OIv/BwmSFgfgyfoU6WLYQLfvZsgbMC8DKTHVR+OhTNjZDsC87KiS5lRCHAZaEf34F+HtUJrJBKsNfCLMuod33dV
 B4I5C+h+
 ZCTJhRp4hgWn+X7wJ0Vqd07SrqGgE3ZmM2FABlndF5bC8QZChxSJb7ograWhaOmU2i8hcGedFDZFJBhHcbmrsHoMAJvqSu0GWoTV5dPL6W+Ps6X1MtG5lLDUXwNifCxQRwpXfYF3gJ2WU3+KrZqXy5FiDTXXvA3zNog8lrQ+Xlo7Yt0lFl6HyXwGPSV2VAQaGWJrcvkMCoC7L0tcflXAZEF2AjI6/Z8Y+xCYtyCYhJkToW1P+7+fezovCaMmxj7zKJxYQ2fJqS1VobtiQ03/ur6iPaud2AyTmLrUjPSN212R6ieGcc0YZS1el5ZGSFFkeqheZL1rzPcvxkqUmkt2tXA+SUOYQ79OhZny/cb0d7mf6jhSD1suNJv0Pq1K2ZG4yDYCWZ66uTvHh4PbvNgXbRYicvtMCpekQ0XyZYlYc4Y4EpKGg5DqZ2GQ1+B9cqadyfETiv2WSAn5bpzyulHkb9Os6dA==
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


