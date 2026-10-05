Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71000CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052416B0098; Mon,  5 Oct 2026 04:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029266B0099; Mon,  5 Oct 2026 04:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A8B6B009B; Mon,  5 Oct 2026 04:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C564A6B0098
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:47:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B3EB12018D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:04 +0000 (UTC)
X-FDA: 85287942768.06.097C048
Received: from mail-yx2-f2.google.com (mail-yx2-f2.google.com [74.125.224.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 61C4A140003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aZzsAT77;
	spf=pass (imf26.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.130 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791190022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eK57rzngoR9p64gbd7b8c0TtXsJytTuhMQ1jUtQZOy8=;
	b=iZcd4eRJ1kaE00RniNE2gG05MicF/8rkFhfo8ZLf3qnDABbmw2NRzUbQrwi7zwA60RePbq
	0MLGN7gWapyt0KbqqcUs7fou7itdt9YNGLOU+3vCclSDinzzgstC/KYNpNtOi1YWlhYUy5
	SU8Iqr9m+cN2uyAcr+TatLWi2jMaeaI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791190022;
	b=TDX4zoVyzFSJJ5HcGpn6L7tV7JRPWzMYU005/ce8gXY1ze51F/JqvtiuM7ZnzpX5vyg1nr
	FuAFU2iavBzk2ENW63EQEUoWYAid1pohufqGOIxGM7BUXYarih+XaRy6N2W682bJ0OVmmR
	HRPekN5uDq6O0ehr8mNEjB+NBlOdg0Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aZzsAT77;
	spf=pass (imf26.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.130 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f2.google.com with SMTP id 956f58d0204a3-67569b8cbf8so297255d50.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 01:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791190021; x=1791794821; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eK57rzngoR9p64gbd7b8c0TtXsJytTuhMQ1jUtQZOy8=;
        b=aZzsAT77bkbcRKjIElmRSiw/mx7PlJFMP1nrGROUgqBN6WUN5dngH8dqfEGJiawjw7
         iFnrnLirl3fp6CFPwLnGK1I4HtxuqvRVOUjj3iZF+uthXv34vtVQgy2EBv2EB3/HXjTA
         7BrRgdvcAGkRnDN4BDTpjpJZbp98adjS0FkExmFT7NYTjx54bZBspvQGwvuE3+GrhOuq
         VFmMAROJBEeEuQWKMHqYRdFIBzKO9rlHrgYbamOa0stTfQTx54gf3QlZVZcpZNXRQcpK
         yg4xjIFHEZFISCS5E917cZ44BuNRg5hxMV+/jvS7A2e5ljBbAzKnv35ixnGN57e8qz4e
         LuHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791190021; x=1791794821;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eK57rzngoR9p64gbd7b8c0TtXsJytTuhMQ1jUtQZOy8=;
        b=eJ81VxqSEjqNpmcXzZq8RIVIuXeOdmmhJ4kXLmf0066FRQxlnu4toxa8Ggl4s942Hj
         NvmiP2KImKAlncJ0QP4kPRGPOJVHmzib8i9nI17rfjvd23ZN2mkLDONoV2TSgKL/ilEw
         DhfkHvGdLmoaW0as486QYDy4LG2onLRExe55eZVuSRTxg65ZL35iwbYiwFhOqLR1fUEc
         y34gbX4FO7+miZLxg62jsi0LsIP9o71T19/uz3UhOBKovph/96ya7cHv9eEBwBmMn3PD
         VqlKbV/ixBOlhxjVJ1C6+D7hxGldS1VyTfefp+FLuojHEDOpKGnQeYp5gq0Kwp6dL+RD
         BOSg==
X-Forwarded-Encrypted: i=1; AKwUvBxfl/g51Wdh+GsgOjI+6/M3Ab8ztq6Mv+HcVdSal0rgFJh7qy3udi0gtDCnu16r8Z2uveutOVHsEA==@kvack.org
X-Gm-Message-State: AFq9FYIegVvC5xmi1yI7pGhZ42nsPzbXpymjzwgCpwjVnNbxWJH6EQpR
	XZPJCAuOpWOg2+ws1ucKudgNcebVAllZETIeNTmquH1RAD/OIJLscoU=
X-Gm-Gg: AYBFou1NrwhCbt0p1qPFJpjhDoVWaQThGb/Y8RVqIgud7ay/9Ehi/Q4HBL7qDKvpLbI
	Q2EQ2Wr9qVhvItlQW5tMlXdWkHmAFBvraiYoMYOT4ckEXUdlPPJMZP4myqOoRz5yPZql378iXRW
	6jWTNLzg+Vs7yqhDmCtC1N4v/NziXYdD3mGNbHYvaN7QWNUiH0sF+bLjHKDVTHT1/5KT+Jxuwrn
	9iON9xWcgIJHzw/FP7HODQZTMZvT8QpbnXF8gH/zHYdVJl9r9xV49HV4O0fDf4BpANSIltepznQ
	VowTtDF/ml14uzkgFv5dqeWJXU356uQBoXk7aLFU+/enTrMzJGSh3RLR9+L2KABrXKA3bAGEvnC
	8w8DlWlhHWe1vGfVwa058SrhJNc5gKJZSHYZ9a6WSQQz3E5TGVrmEi2JyshzmKTMyukDA5DfuJV
	bQPKwKXXqQwTX6/FS186dvQkmN4ATbio1lJKDiKKqh0WRy0tHkXzEpcQyqQWaUWHu3FW0VMVYWQ
	TOc2rVXo7h4KcNn2x5JaqTUboHvNOZVz8i7rj8gEQm1O6wDDqSgREIsRjBqib/2CCI9hQ5RYolT
	/9+0bpWXxgd9emIe6164Psie6LQW2c3EFLOFcqVUojBtng==
X-Received: by 2002:a05:690e:dc6:b0:677:d455:5198 with SMTP id 956f58d0204a3-677d4555829mr984847d50.40.1791190021565;
        Mon, 05 Oct 2026 01:47:01 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:1149:2fcd:c86b:8747])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b9c895sm2346306d50.13.2026.10.05.01.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 01:47:00 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 05 Oct 2026 01:46:48 -0700
Subject: [RFC PATCH v4 4/9] mm/damon/ops-common: use probe-weighted score
 when probe weights are set
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-4-b03452e137f3@gmail.com>
References: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
In-Reply-To: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61C4A140003
X-Stat-Signature: foymep6i17rqwsg81bz14g4jk4qdxb6w
X-HE-Tag: 1791190022-998538
X-HE-Meta: U2FsdGVkX18B+l0jXvLKyVi+R9Y6mWi/g/tgrxdPTBX4DD3ECuZxzMeyMOoYUUCZq9s7zknnjJ1yxwcqUMr9OmIocTSz++6m4eiuuCkuzJjm2CLfactjXH2mGJ6V8cdDKDoaHCyGvlYzUD5a1zWO48ss8Nq69eGeIl6S24el4dHE78ezxAbKic/ViJ11zgBfXhYOnUKpsfbH4i0bJlShCRm5Q9DmZcAoGSOwDGjVraxdYt+G9A9YK0TtjzPuaC4t2DtNj3TUogt30LaKsyFVexVmfWUp/+s/RAWjVkamzVWy7X/UzckNL1q2N0VikgCuhw2AXmdH88LZMOjgIeVH+YtCiiN1n966+b7qcRJIiDgzNdsU5EOFGdZYqcgQKRiwFEY5Or9yMwFUehfq8MhWhqorzg7l9yLh9/5Vu/cRtcBHvhClc5nTZqlqD0z3ZV7xNeAp+C89EFA8Aai+ZTq+IILDisjHWyDlG+hWFoFAqMAYhrJDKByrdWiINFDQcDt0604i1ZzsabWaJ2n/qCNgrstcBZj+UBUNfbiBD7Y9Yxk2ugrxiOryHyFCrhwP2eWY/lgs3dq2pKjWVmv7nhj+32jE47rlgSdhGRhhjzp5O2+WmljlX9pQnlxmp2uBo66Q3W7z/WDGxjElFtj0OmR07x7YAXAF7oQBAf9xv7VXNAK/Ia+FLH4WUdTqFyjd+ZqusdMeKcqL6C6BCQ+lO3vGQSmhi4wo6R4MRtUgdF9JPrjwuZioGdR6XdZcXo6YnZ/aypybvqPQHk++k30zJBhV7sQyfZluh6WjOieHOoTJ7OxN9v1t6vv/UZ3r8of9ybDhgE9Mr7QZsIxel5LSRb/kUwiH0CE358fz2boFODkBOyo7+6BFLz41l9mPoeofStpe4/xzE6IH1iZyR4fMIbUj76p39g/fMDBPO2olMKv/Nm9i01yFN6xxuw1ow1ZyCj/NLrwOIFqFB9kZmAKC7Qd
 M0+YiODP
 Rqo9j7Km7wHDARAws4XY4x3QKyXzy4XOYQejHkcIl7fyINcEHcgpYf8w93I5I6lDwnAGLZx3ZTFG2yULUNhkS3cLjMCxpXQ5V85+PV2cB1VskAerRUl+eksimMoNQGYla3BeziXXecjqz86Ydyi5szlq+stEh9AGqKPg1lnai7UzkMOxxmC9ggBF8im2kb5XzNrqqxHFliipBYREcDzlUptsvlSIPpyNzBoOE+ocd0NhXcVa510wBNd3Yrvgun7eqbXtKtNAezgrzqds5WH4lDoOaCW68+6DsVOs6CpRNef10fCTa20cODl//Hh1HdNB15z75BG2SQLAkKWMv8U4co3mWNXjR7dAdPocSMz3VBg0bKn2tqC6GvmDZh3fOGyL09g3WD9V9CSokMJJs5vaOT9D8M9iU4k0tJiztpapGm/vW1vORaggCEjGsZBG+vqkl2ZRqL/T1n9Xp3z+N9zkFqNC60m2SaMPw+RyGQ2d+qSq2sJ0YQD/LzmR7+rYUbvpcOxlP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are configured (damon_has_probe_weights()), use
damon_probe_hits_wsum() for the frequency subscore in damon_hot_score()
instead of damon_nr_accesses_mvsum().  This routes the probe hits of a
perf-event probe into the DAMOS priority score.

Make damon_has_probe_weights() non-static and declare it in damon.h so
ops-common.c can call it.

Scale the weighted-hit sum in 64 bits and clamp the result to
DAMON_MAX_SUBSCORE, so a large sum cannot overflow the subscore range.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       |  2 +-
 mm/damon/ops-common.c | 19 ++++++++++++++++---
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 7c5a416e1eff..b0895ef477ed 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1306,6 +1306,7 @@ unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx);
+bool damon_has_probe_weights(struct damon_ctx *c);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index a15dc7e9125a..9fc536238c2f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -331,7 +331,7 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 	return NULL;
 }
 
-static bool damon_has_probe_weights(struct damon_ctx *c)
+bool damon_has_probe_weights(struct damon_ctx *c)
 {
 	struct damon_probe *p;
 
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 2f3bf86a221b..3c5cd745f4ba 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -172,9 +172,22 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
-			DAMON_MAX_SUBSCORE,
-			damon_nr_samples_per_aggr(&c->attrs));
+	if (damon_has_probe_weights(c)) {
+		unsigned int wsum = damon_probe_hits_wsum(r, false, true, c);
+		u64 subscore = div_u64((u64)wsum * DAMON_MAX_SUBSCORE,
+				       damon_nr_samples_per_aggr(&c->attrs));
+
+		/*
+		 * Score by the weighted probe hits.  Clamp to
+		 * DAMON_MAX_SUBSCORE so a large weighted-hit sum cannot
+		 * overflow the subscore range.
+		 */
+		freq_subscore = min_t(u64, subscore, DAMON_MAX_SUBSCORE);
+	} else {
+		freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
+				DAMON_MAX_SUBSCORE,
+				damon_nr_samples_per_aggr(&c->attrs));
+	}
 
 	age_in_sec = div_u64((u64)r->age * c->attrs.aggr_interval,
 			     USEC_PER_SEC);

-- 
Git-157)


