Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E821A60A261D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kR3rPu/a
Received: by kanga.kvack.org (Postfix)
	id D42B26B07D6; Wed, 21 Oct 2026 18:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20746B07D8; Wed, 21 Oct 2026 18:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56636B07D9; Wed, 21 Oct 2026 18:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A92A6B07D6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:55:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F123580305
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:20 +0000 (UTC)
X-FDA: 85348141200.13.50807FE
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3A999100002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="kR3rPu/a";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4E88v6TnIIh+ETRycvbXAskumAVYN69m/ippxnJhTg=;
	b=8GVe38nccXNg3PcUyRTvKIeTlDj7iy4dxsOPqVIG6fQjHKckjY70PI0sEw9GytgG0hyxBa
	1QDo2/3mL/Hk0OQbG4Xw4yuKlA+wTX4DUAeOvjElf/rWbgGzuMpyCtfbqI5lf2bPVP3h64
	q95mmv+YYekeG6l1P/qMP2tUcXXjKc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792623319;
	b=CrVOJRHr8+QYoBaI70hELHCGVWm0WbCSQiWWircw6xnObsWTKDCbKX6bhp3On6g8Q4Ol50
	HDCBxbe93bi/06DEOlp3ephZarLAYY9lWVa7nLsBH8mOkGiJVT6TygelFa/Pu5csLuKy7k
	wcmrevV5cEKqrkMPV7FSNQREWdWwXU0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="kR3rPu/a";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b0ca1ebc8bso11620777b3.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623318; x=1793228118; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O4E88v6TnIIh+ETRycvbXAskumAVYN69m/ippxnJhTg=;
        b=kR3rPu/ab0+fX21/i+BrP8BjQXb7lIwLT+9z4smJfdyoue0JdvBG64ljJTx+upFim4
         G7OSiG1DIhIs0snm6GMxlhm7B3cjU7TFCQsvcQMAN7bsr1GAmsY5kXjroZSvPfi9iFmb
         RsNxWoVUdduuB7giSvH33NQ50yi/2msjafpOBUBm6p1sl7YDGec5Vh8Cjz9P5Z10/Z8W
         4us5iGWSFkh45U81E5OnDEEwqVjhHSXW0WTF4pJn9mBpfcZklPLLB9f7PWIj35FgZDKh
         cIPi6zHvF+Vo2iBuuOz97wAA02N/exXi8jdhpZHAonf2Ybd9o3kwgmoTQBv7UH5SVp4Z
         euyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623318; x=1793228118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O4E88v6TnIIh+ETRycvbXAskumAVYN69m/ippxnJhTg=;
        b=s1LLd30Mmpoig2UnCBMPm2HNpdCLRldZt9x2yO5v1LaC5q9AYZnsFFySM9H/itxVds
         DkioxC9ysZeiNVF0NLbGuklri17IdBfYQtFfHDNQOGmmNOf3ymkpCVfaX2K2dQoTJAPR
         YSyOONrc36iJE4msQlUGtVgN+h8KqrprF4fzKTDgnYO5A1IezIMdVqjq1CDrwphHvSL3
         zaXqLDvSspXDeAke7NJIKJPi4S+XQNq8haKuagjY8C+9C9+TZUV4vZCmswWG9G+D2Ns/
         9q4NOrKmqoXD2UqqkJp2XzLYfgnRpqluEZOOPQYwhlSq46Hd6riZ0kDOqp3aOcawpGmL
         +CaA==
X-Forwarded-Encrypted: i=1; AKwUvBw4vXy2Yh7zRo5KBbna3qor3Qr9G4hYcD/U7Ios1giTTGCWTja6JO/JmCLHbMb85MbvBkFEF4GzIw==@kvack.org
X-Gm-Message-State: AFq9FYI+F+cQ157YpBdtqecbt4xZtNw7rn/zxtc3GhcKc1TzUzQB+rMS
	0x7xY/MsnJzYPRgu8OhslzYZ4yZZtlwDtIIUW3523XM9DYSBTnZXBCi3
X-Gm-Gg: AYBFou3IDXbtsd1TtpfKfrqSuMI32HUpOQ+kUQlj/7iO5U8Ylb+tz/9w/j4+b2ZgDqq
	fZ9BzCejePTg5Zh25dvUfZmEaZ7gHHtf3hJ73AmPVMOEtwluJ3drwgLzInDYQF6B3oasrk3A7mg
	geuizGx/UO9d980sHGPgU0K2UPBOtdv1lCw4x1acefsyDgwlTZOs6q4z/fbuMsTxsschHm9MV8h
	F4osMspr05YaeUrMaeJFetVa9pJOufEmxfKAfY8rsS05A9umjT/u6q0RQh4Qk3APQV5zxbg9EMY
	cNCdRuJr2dG1rv1XBVjQrpQzgJQnRQLWky0DkiavRE7Js1TMIByHKImtEq5P77epgiEkUNsEfbB
	e1O69Mj53A7iaOEFDtBStRYNbFXM5FfaBjzJMt1VaP/H5Kcbmptm60ZCvHbWnUau4RvjF4ae0TG
	gsQ97xLc4gqVk9xZ+3ZH9TMXB7Oi7yY/yuZE2T7PZo8nP/NYMu1G7LBVIdOnVFwQcFYIcQYY8+x
	zYaEp6Wx2UBpAUfW1jzhwIm4HhtwXfBdsSeEXif6RVTRBItxJO3nFe/SDft9dG7ypvotRfm1M88
	f5AR/ZoC63M=
X-Received: by 2002:a05:690c:d89:b0:8ae:a0c0:463e with SMTP id 00721157ae682-8b133d7d1a7mr24871677b3.53.1792623318346;
        Wed, 21 Oct 2026 15:55:18 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300735f3sm18293307b3.8.2026.10.21.15.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:18 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v7 1/5] mm/memcontrol: flatten try_charge_memcg control flow
Date: Wed, 21 Oct 2026 15:55:10 -0700
Message-ID: <20261021225516.1620680-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
References: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A999100002
X-Stat-Signature: fw7zwcr6hk67p7pzoe9jcc6op4bg6mxc
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792623319-599163
X-HE-Meta: U2FsdGVkX18pHYvjOQ+4GSrqAgIT5RIFmp1AbEchG0IE+HZyTuYNxHk2tVCIlC3BEH3l/bZ2DLuj4TkDWk+Dh1Av6y9/Xv1KM/lhLMO4VKhbKU3kfVw2pDpn/iTmwvQo6z63Ozc0IQv1KfXVJ9G+dl9O0R3O1m5Swj2iUBYCt/8EslqLUXf3SU0X71ygkppcX8VZ3QrvxY9yDoANoGQUdRZwueSf9ZkQ/up3Z1+tKZwvF11augwy6pfOOpBqPHs/SofJvQ6E/KfU25fDZ0XdFoUJbabtSlmYPubEcDws0Kjbabf/HjQUUNZZLoFG4xbM56kfF3H6kWSr9t9HXkMLDRQ+MTL2cavG2eJJbg1FIODYIpY6P30kCiMfcDpoL9z5JoVsnOMwG152RmOxSfyTYqhPXY7I3sR3Z6DCzRdV78l/Ahu8c9U/KL7T/gLjPG9aYdDXgsMIFHIJ00FTGiI5Ahxhxs6bTGuRWHKXIAO6lBUKqZxtzFt+4CBcOSLoy+K1LeZA/FxOmJdIg73xHCJKC2Vy/wJtvz9vPldp/WdiPLIK7QFOOG+kguK4ui4dhmYXIfOiWWth3UviD7pu1mJyhxJU+qAwjZ3EtdXfLbtTWM1Wy+KSPlMFKtjezaPy291kglwrb3EVkUEXpMK5KmarvDS7vYNlb52ZzD1Lioei/QC6ExVB8ttFc2pjJmUJqVbYuiwP3a4uYvgXcvqWvabtmhWMg5VkwYCgxPWWZMkexat0RW5tgH1deJncC4Zl6JxPmUeov+CHZU1NCDqN1NZss70rWjBDeuizMu+l51VdRy26nuMIqfmL06kkfPAjaVlxZVSiXe8nNiCDmc1wAFUEDuRlKd2ehTNESvgQDifLOUWo25BsIeNSXpONCNN1tQv4kXlufUOZIAihgiGytiNBsu+e0kofFfwUvz6zGDOEd8aSYdUweEJhpH6X+w5mp8QlJUDEHrZY1rWzNle63Na
 BixYpFkF
 CMM0R9A7Eh79qrwPL4UTPUu219q/0BQWTmEjsqp1tM2OhZ+NeLL+oAy3hEjrysksGjuG4YxWVRTCe09O10HV0K2nQTFiq3yjRLPJ/3lfo8dPl8inXQ4RUV2J5WoIhjMMPlhjoWXWUTdD408x4ewErAeQjSuSVBcdZWYnSMlwLsm/wm7YiqkvtM5LA3vVlRzJqwBIBlzCPCJSeZ7liNrs7Tut/fprXAWl9TXRbTHW55rs3Zj0EvJEQZkC68cLRR/NONzxUOuaL8nIhy6Itjr+ymhzBD8M7OBK7dgE2jXku6//rZeCzz2Bvdu8lGvsPFO94sZUcx4lRyCzsUHRTw3D8+r/26Hxi1g4VuigJX9rEzGyberdIN4QtfzFojP0arbYjl+hVKXwM1y4967JdOKWqHiqeddEXmY6Lsre0AW7MvzHtVM04FNlG+PB79f8SrABLuzWiAM8D8zq6dHDrv1nkDhmA1Dm7RfKf6/DbuCJGlreOb4s96oTjq5XHdPTGvQAC9uZlx75gOaW3+3rFSjgWKe6F/FEZy5EG90HI4Oi1zoi4YA0HD3hTqxfyj5EWq/1woH7N1FsL8DwfCTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b6..cdd6aba91e444 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2721,18 +2721,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.0-Meta


