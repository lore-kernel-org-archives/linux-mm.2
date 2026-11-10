Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8F7606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0vFeiW/K
Received: by kanga.kvack.org (Postfix)
	id F3E7F6B05B4; Tue, 10 Nov 2026 10:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7CB6B05B9; Tue, 10 Nov 2026 10:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69AB6B05BA; Tue, 10 Nov 2026 10:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3A76B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:14:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1906340945
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:14:19 +0000 (UTC)
X-FDA: 85419555438.24.7A0061C
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 31DDF1A0011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:14:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="0vFeiW/K";
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323656;
	b=aXxsBz65I5ymRW0/Ure3rbFOc2jbPmTysLa6LrozxYAg5ntoclHt3vv261Aq2ipQ6L6cKc
	2fM6shHNBRAEVBlnqGJbI23n7RPMl9w9JC1f3hulWe398ErG0AMz3BZKWIWByRzHhngZX/
	7qnwSn8QR/UgT0Q4FF8wV7B8UJjQ4AA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="0vFeiW/K";
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7mcOM+n5OQpUfop9CP8BUGmScJoc5ssQWRuOnotN9Q=;
	b=m7oUvGgsm/Z6/jfeWrQHSG+nJ8G0G+Nz71um40EAS6ZvfYxrNbX8tuObQy1ZXngXlNKFQK
	KbDb9Yhy6r9GjLGE/YdI1+hPIT5mRwmKX25W5vMPue7Lyu1EX+nDPh2o/DKWOeWSmQSHTY
	DGmugi/B19VM4DowOaLjlFRlpwoOUxc=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-67c11318ad1so1304290d50.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323655; x=1794928455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C7mcOM+n5OQpUfop9CP8BUGmScJoc5ssQWRuOnotN9Q=;
        b=0vFeiW/Kq5NT4RrM4SB3KL9sKLt6yZqMWwgvfIMswEEQHvy8gT/Jv/hRON5Gg9gOAA
         doppMkMeC8FfuTHT1kfAvs2kJmur/yxJYd7X/QhvBysWhAZUvjxWjd/ralKLV14FS4GC
         CNdkol/4B11eajwJtE1u/5174JDLcMGyffU54WoFZVtG+87gWhLVIxNp54CSmEM/Et7a
         LaXiS5jxbRfUts+ChvYql9Je7rYYrJWascp8cPjKEhbLCO0250v0K7p+7mqzwLfSiTf/
         O1RMNiE/C04pZhHtzYwPpfsIo4iFXFaSWZuj8bqNu9TtbL9s20qok5rhWGJ0/i7G3z6M
         9y+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323655; x=1794928455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C7mcOM+n5OQpUfop9CP8BUGmScJoc5ssQWRuOnotN9Q=;
        b=mZnV5OJDjcSTwVfMijK+iekdI2/GAmFM0pf4icHP6FsRfcSbqaUuILx43IgXaB8Vcw
         H3GuVnJiBD+OwSQeFx/k0k272Qfxy1hyx3HmHmNU4Aj4jV0uwfmoxWcvtWx1l3oo1C/P
         UmtMyEtp2AywJxhIgYd/ncV7MoSakFdtwnrR5NZ4xxZOeUHRztyL702zx/LohZYqMBUv
         YrpTlMi7xCKmns2o092Q/qBofePQDsXBESnACu/MO5DbFLsKqvXgMXm4Y3hPl2jMnics
         6fDpf/odd0tdQr+pnguB76YAcYz0CPIYJRBGgR2MXM5BcLITxGwOC2usW9LPYQYyAdBu
         WxUg==
X-Gm-Message-State: APuU4Z+97ejRRw/kVQeUXrGj72eqFdan7sHjIUybTey/rPVhbkzsfgJt
	W36HcCuveEBmKJmmKxl02YHyI14cs9bpgZDPAuUNC3L/d2rYEn7855+qm8wqK/ym
X-Gm-Gg: AYBFou3X9drbG6KUNVXLO72I9Mvs5uDWjlIUpWZ/DPQs5au+tMLrx9DdSERqKejJisq
	hyvdYMDJFt5/RTFQl4f+Am03T4BcxCsNGS30CF4ewh8TNmpo+YQ+EotPqyoypoBBgafrdTK1sTX
	prAejITeIm4trJJExBvZzcQf0N7IWAUIOyo7lelFPRr4ubhVqvowS7McVYtdOfrKQsS350zi5P3
	+yS6tudsxTJ1J0JIhxvPr1qJK884Z4LCjWazUgE2x1vLP/WZhKuEI9EQz2MeUr1psevpS7WBN4C
	DM3F7QqmGzde4CHl27yHS747RdfIOllVgWPkRxJv8DKAZKZ/YCwAQ72cm2fd5Xl70+LZ/fSKPKl
	q3uIVQrgtfs3EDOS32hNupOa72miJ6PRmJCz2Ly2OWPp9o61eqR+z8i6rhuVXEd2e2VcQIC/80E
	Mh46CMNyo+cCyU/VwWot7nNS/nBoREcuuPqyZLxF6aX8XEeuhHrn6UMYgy5zAazgbYdgB6NBuCk
	PL2U4CMox1qQnEgbyX79Zc5JEtmVzm1PFRlj3hNUTOq4i67YMUd5W2P5KsRBMPFHw0nsipOzozw
	ulhKUg09WsYkR7ehhto6PVAtzshZPuZG/8Pwbhdx/jHAAfuuZfbU5PZzKG3HefKvq0W48SuHWKB
	G9qJQOlBJM04zBLRUzhi2cPfTlyAKabsGcToR
X-Received: by 2002:a05:690e:480f:b0:679:b86d:6977 with SMTP id 956f58d0204a3-67c568b644emr1317770d50.73.1794323655270;
        Tue, 10 Nov 2026 07:14:15 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c58a1f11esm2086933d50.20.2026.11.10.07.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:14:14 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	sashiko-bot@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] mm/swap: skip relocation of tableless clusters
Date: Tue, 10 Nov 2026 07:14:07 -0800
Message-ID: <20261110151407.789960-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110151407.789960-1-nphamcs@gmail.com>
References: <20261110151407.789960-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 31DDF1A0011
X-Stat-Signature: s9tffe5rtid8h5j98oy4tregzs84x9fk
X-Rspam-User: 
X-HE-Tag: 1794323656-468796
X-HE-Meta: U2FsdGVkX1/uWcATCg76YDhpHd3TJIU7TEz5Nz2IKfP5zJynTwrTRAFCnF0JwXEMeUzx9mf60DFikdEN8uMuk/l7Woks8+6l7gC9NOIivpNpNATMD+cswgAawD5aj1yF1ujYRJlcVLw7lEgh2TI0yONPO7bHp9rLRA9OJWbR1HC534YEdOxMH4CwVSfac20lNF1HMVYEBpcRRoIMKMLGbZ5e8e1JCBegDUi6jNTz2ZYRTUrU/6ZcTgrpXZRZruLUnUP/ib5c8BZvBydcn0P7uBXOmxKHxpKavp/5roaS0lKjmGJhDpSxF2nOTQhBBf8Z5vGh5Edh/euGAjmM1KTng9H5ZMevAtTM3esZ7cAdpXjCVfDl7wInwdVdsbJ4Lsf2TQZo6iCdaSGGznre0XVCWKVngWYRRbG9E/CuTkBl79h4SVAUSzWlpFkRr2iguz4tSYi0POsfo04+fGitLLtwCVaj4vsFFShPVpuokd5mvKrcsJIyneXt6Da3k2Y9w4SKeb2Wp7GBZNHcjbTeNYyqdd3Qw1WgzQErYSoMcZrEU7ziRcHgAtXNcfAbrug7ajKuQaUcImfyw9S+ospnTWysB8i+lPRA1ra1gIt1o8bfyRHOPsiF+vwWxIckuWthJZra/2vJ7k3XOnolhOnweAyCUBiEt5J0gHBOOBwpilSbXIireMKszsPG35MaaKAjzqQOdHBMNnBSPPQFXdjFnuZjPut2WiBQhb9ID9wmVBzmh7GQ+SBqYs3I3dJV5tA6F8+u62FfXHBRAQxDVeq4JT9u5YULHwA7mbx5z2W/OLCd+DVDmue6djtLVxWrJhm0gTwgdnqygLOVDH59UW4BNmk2CELQiEESvX2nbEX8n2XGtFv5vgfLUsLG/FAhTHoomVBkNhfOEeKKcd/qH6S+FGjYMLUcsNQnBgh9klzibKiqOr/1FYnXkm9zuAbyJFKH3OLgfUkX9MvHJ4iJX7+1ADD
 yNj3IkI2
 AJ3qbj9Vsjk0huy4m3v2hMCrS52D3DHfUOO8UkutU9Zljjj8GXF07T5st5i4e9yXst5vXVkDHHUS94Flzn8XtKFb4nHJpbz3yJAjwFivufrUIfadbsp/be9ROGakwFzLOhn9HhGh2qeZKxs7Jz5EsBHipYTVske5PWMWoSmea6Vc7fJ9uWmvhETH7l0zRqoIPSvnr8trQgg7yxkO8S0XlA0RR2qWMI+tJyWeViuebiG5qqvlncUDLfnI/w7OCeBs+1qz5m4CWIOcliGCqNbljL1HY9tusHHwE8rnJq/RqY+m3X8nWKjmyyVRqQLY2HAzoJivYT3vabYkcH92XORqrhaTGpjUwlhkSL+GLbhBwqudGCIqNayCLuyrDr1eRkBnmSRY0hc/4zGhWG2Fy99kdqiglIv1i+J5uTiiYPTZo4hLnO/S4EcGixbl0dkL2mkjdw+UqIYsAmI1S16XR053w9admCK3rbcqFHlDQ3MuEHr58B3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A stale reclaimer can reach relocate_cluster() after another allocator
re-isolates an emptied cluster and drops its locks to populate the table.
The cluster has zero count, CLUSTER_FLAG_NONE and no table, so relocation
can free it again and dereference NULL in the DEBUG_VM empty check.

    CPU0                                    CPU1
    Reclaimer                               Allocator
    alloc_swap_scan_cluster()
      cluster_reclaim_range()
        spin_unlock(&ci->lock)
        __try_to_reclaim_swap()
          swap_cache_del_folio()
            __swap_cache_del_folio()
              __swap_cache_do_del_folio()
                __swap_cluster_free_entries()
                  free_cluster()
                    __free_cluster()
                      swap_cluster_free_table()
            swap_cluster_unlock(ci)
                                            isolate_lock_cluster()
                                              swap_cluster_populate()
                                                drop ci and outer locks
                                                swap_cluster_alloc_table()
        spin_lock(&ci->lock)
      relocate_cluster()
        free_cluster()
          __free_cluster()
            swap_cluster_assert_empty()
              __swap_table_get()  /* NULL table */

Leave tableless clusters to the allocator under ci->lock. This also stops
a stale reclaimer from returning a cluster to the free list while table
population is pending, avoiding the resulting FREE-to-NONE state cycle.
The existing cluster lock serializes the table check and relocation with
population.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/sashiko-outbox-203018@kernel.org/
Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
Cc: stable@vger.kernel.org
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 32639f65f13c..9fd62e4ca7a0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -815,6 +815,13 @@ static void relocate_cluster(struct swap_info_struct *si,
 	if (cluster_is_discard(ci))
 		return;
 
+	/*
+	 * An allocator may still be preparing the table.
+	 * Leave the cluster to it.
+	 */
+	if (!cluster_table_is_alloced(ci))
+		return;
+
 	if (!ci->count) {
 		if (ci->flags != CLUSTER_FLAG_FREE)
 			free_cluster(si, ci);
-- 
2.53.0-Meta


