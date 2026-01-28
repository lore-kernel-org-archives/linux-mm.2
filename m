Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19D1D35697
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231236B00A8; Wed, 28 Jan 2026 04:31:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185716B00AA; Wed, 28 Jan 2026 04:31:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054936B00AB; Wed, 28 Jan 2026 04:31:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E47396B00A8
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:31:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B661C1A051B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:31:18 +0000 (UTC)
X-FDA: 84380854236.08.EA2AB06
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id D59A518000D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:31:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mtF1J2jX;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaANuFojWwiJkS5m+OWCuKgIqQ4Dc/6b0DoNriahO70=;
	b=ONzTTAgZoFOcIGU9RZSSxJX1gptck3FIXJD7rLbfJJ7FKVus+wa5g28r8AtCD4Y5k1CROY
	t5xF8ATWpgxGy+sMXkJ+TM7hdmmNB8qjTJoEq1BmSYHpKxxbwmv/RYOVY88SkvrHVskjtQ
	a13bXrI9Ubz+X9vd9nbbhf4AZ0iVfJc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mtF1J2jX;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592676; a=rsa-sha256;
	cv=none;
	b=AHRyCFTMdm8YvWjNrars6dm7dZcRkMbaL5Or+dOqBdcuzqEhhiYCQa+Q89bh1ouqFMT9tJ
	RG542a0G0Y9qL3JOsDfaPpIxpbd7Ab+r5jpsdjk3tHwIBAtBWcec/3UpUZp33VKUQjT6rf
	Rys2oO7oGla5LC0tRy3k1vC+++5KPAw=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-81ed3e6b8e3so3171887b3a.2
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592676; x=1770197476; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CaANuFojWwiJkS5m+OWCuKgIqQ4Dc/6b0DoNriahO70=;
        b=mtF1J2jX8CWTtcYQ4f7xJPoIkwNby8I8UnKOQm8+rVI8JDTcbEHAfcC7+ZrLkQ/B5l
         a4fFcwHUji3wuolHdKM2TX6Vm+h32QwFyJqZgeuInPvvj6X6945KnXbbazjQR57n6eMM
         yGcvcne2M1s1t8FUm1fVWVjV7b+MUfImWbmpdeL2fn1nx/nlULPWWcTp4MevBu561fno
         iSRcknMxXRXHhDxwfULLEOYtgi/Ue7LGkKW5Lt+39ojV8Q8c16S7HXmJ2N3YSr3Xighy
         JutIliuu4uO5wIyzB/DjMwrJDcRABg9eeqU+kBf85XJfGaZWsTTUVAFoMCw2B/XHU+5d
         zTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592676; x=1770197476;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CaANuFojWwiJkS5m+OWCuKgIqQ4Dc/6b0DoNriahO70=;
        b=OR1EcaF9AM0BUhqZSQi2+/sxvkyBLO2lFaLiAgMNXXzAyaiMe5f2tpdL5lTQqx5f4d
         KOsAmlTNpJ1KrtbYMZBPuoM6K6RP3Xsong7qsQGVp0LQX5wvUIZ8XuaUnT+uNb5DzW7k
         940m9ynqK28AWzWh7p/2k2FP3Rr9EiYJ4FnYsWliH0MrUUlX/gbX/4vCFIyKuZWtE19N
         20COIHVUznpWvxldAdLMhNoowEz88eS0FWlh+DtSylQ/wZ7hGvlX5+VvY2XxXtM+jshx
         lpADFXqiIaNj4TxSOOvp4y6bP6hzUf0kIncM8gcXEKVho46IBiQGd6KWrf5E6lg5p4Eo
         glRA==
X-Gm-Message-State: AOJu0YwHiu8c1GTSFfMiOHU5j+F1I5ySXFU71P4zcIeGG7oy8iHGisrr
	5ph39kZuB/95Q3tZZ0UN6RIbndnj3Ck+9MwX1RYb9VR8eWBXQtiIGKbi
X-Gm-Gg: AZuq6aKLvWx9KR4r6ETH/bWS8mh+PrhT3a+gIL5rCirq0U2lPD0aWj0WIntpBZ4Pxzc
	RJEyLZfU7l91uy+bYa7DHQDaKMyWWNK2SWsYEJ1VoyPWx+KwXaMuZnUpOI64Lhr2IWA8H3pd7oT
	ycRMXzCzWYhy3S9yvm+Rk+cjuGmriIySJ1eHotqbPlzeK2lmpxtcSv8ik/MINySx79TGHsdua8q
	sM10z6h+XmMEESM+3mrq0CwkKXDRfYzYYjeKGsLSvmIGSU0fjjId+kZUVjGqXZaiM+HPyOBBbyV
	sBQCX83qjNIpQl5IYj3BnRgxNi+kPH31Q+TsI3B5KzPM2k8CsvK88xF+BKO4DkXOZiWatHtu4Du
	sKQFAUTCSUj++ASxKFL0l+mT+hWb4S6rg10wNjtBmn9MRC/tSaDQgs+0YCgbWPjQvSeBCarymx5
	b5Az+Bp/X5AP1cl2LgTAWrIqGasgrqmbg5JpfKOjPKaFquPoeYxPtJawY5FA==
X-Received: by 2002:a05:6a20:9c9b:b0:38d:ebdc:3555 with SMTP id adf61e73a8af0-38ec654e764mr3944319637.66.1769592675707;
        Wed, 28 Jan 2026 01:31:15 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:31:15 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:36 +0800
Subject: [PATCH v2 12/12] mm, swap: no need to clear the shadow explicitly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-12-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=3144;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=YZtJiA9aWsbTiyi4phkoPFbj1sojs0mkWm2jrsSQgE0=;
 b=TNp8hdi2S5UVTWhtAIwWtT+XrIsAbY3NGTmnWtYTe6EB0kGmkxeKGKsio4vdo10XAeo80SooH
 giH5KHUbLpyBJyCok7oCHwBjFQrvuDsP5UP1Z5/vuNZXNfi3DPbBpYo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D59A518000D
X-Stat-Signature: ooid9wk4h6tfnjbujhip8qi5rknuxoo8
X-Rspam-User: 
X-HE-Tag: 1769592676-481956
X-HE-Meta: U2FsdGVkX1/b/bNNwhq8bXEfaaNoprj6P28nVMpRE634zTVAYVr6SRaZw1azpi65ti1+tFmJrNCv9Hfj68AtKsMEkZh44UfJ9AptlDfcjZRiKbRyAKdk5AOkme0jzrMO7BjsSsxz8jIuWaEFv80+QBcTIJjPxgKUuDnGjhPyRJih8BnkLMd+Rqj6NFIq/r45lXn1avhYqgwqJ3xDspiOsSzxk1FvG6BhnlMSktQgo5+AS9g3czLbJ/6OMBLgFrZPcPSB77SXcf2S1Gg3sEcSBi+dmxMh8S1k5mnBxzf21kAZfznIowTXgZXCKBCLKyUR2nASzBrBEsejTy/ChAAp+W2zxCL+mgZ3oWmG0teLup5OpnhYewGfBz7jyYcwBdxupTxAKfFAV/SDQrIZWpqNs9XUaALqVEXb5j+g1OlCWM1wRE5BLvwPwL87yyRm2LXDwFaJvjkUR7I9ZT6S87BXCmXmEeCzGPGx/nxwrvzwqW3ERBEV5Gt8p4DeqMLmATPg617UhUCbG0obcy37SHi900Q58cm1Qnk9HjBQm8XXGqRErjmVeP6yXjihciJ8f4fAYP87jiiTTaLOdfkqGXyj8Ua1Vxr5PBPyuFOEpzDGcDCnF7e3mKDR8TNmIvODL27aL9fAm3xXn24SrcE8S0OlOatlkyRyZUABKwmTuxSu20ZDI6CTaI32KfwD1YdjbYWuRqvj+iy7nJFxg0nxMKCOfjFkFYpxyeTKBqjZQM0KySw6V/bf12OzgWya0Jfosx8d1ol6TlxNyunvom5LQvvtssgHrT0LFGF2eC0bpDiCb7J3+9iHs6CQzYAFOPqWN743+H/Eni/7rRvm+tuk0OX6pA9eqaeKcLLo1nIaFwLkqxWbrP3iTB3XYpYr7pPWIqbjv7rWHuYoTvCZKNK+Inpf+LesxRYWNA/tZ4tXh4r7R8Xin4kQ+JKGHh8I4/eDIaBirzuylRywoOGgim6hJBS
 NkmswUPs
 rPSJNH+OgcuV6DeyFWGTDXfpfdFSAKbq4+b/e6O/tU5Y1a0ri/w3ZJC9O1SgalMeQKHLCJPMQ27wyWgy2w8twPEBOZ4JuWrTF0Yeofp2tQXptAU6aVkwnTy8H9s7XiQpJrJus7Y4j6zrWg36wB0O989hgl5CXJ8vE1iE8t0I/mhElHF7cYUBbA+SOZsauwdi+N/elh+rjxXfkkH6DfOe687/AdUeMkmFQsHW5EkgkUZIu64TdsSKdJnoFZpa+mdj3k4UOHSeTPA4G1l+2oafYa1MsP6YndmSDTAEl84PDTephImKljFtqDoNyZXstWL1K6IuzsWZ0rfBnOGX4ArnU1GNpT7ereb+mScPj1//LfYw7Hy58q5GBDe5TRkNZieYfDMn636NBTTXqpvr5GS5H0m+uXMcSOW+lipW2kxkRx00Mp30=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Since we no longer bypass the swap cache, every swap-in will clear the
swap shadow by inserting the folio into the swap table. The only place
we may seem to need to free the swap shadow is when the swap slots are
freed directly without a folio (swap_put_entries_direct). But with the
swap table, that is not needed either. Freeing a slot in the swap table
will set the table entry to NULL, which erases the shadow just fine.

So just delete all explicit shadow clearing, it's no longer needed.
Also, rearrange the freeing.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  1 -
 mm/swap_state.c | 21 ---------------------
 mm/swapfile.c   |  2 --
 3 files changed, 24 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 3ee761ee8348..386a289ef8e7 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -290,7 +290,6 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
 
 void show_swap_cache_info(void);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c808f0948b10..20c4c2414db3 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -350,27 +350,6 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	}
 }
 
-/**
- * __swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
- * @entry: The starting index entry.
- * @nr_ents: How many slots need to be cleared.
- *
- * Context: Caller must ensure the range is valid, all in one single cluster,
- * not occupied by any folio, and lock the cluster.
- */
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
-{
-	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
-	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
-	unsigned long old;
-
-	ci_end = ci_off + nr_ents;
-	do {
-		old = __swap_table_xchg(ci, ci_off, null_to_swp_tb());
-		WARN_ON_ONCE(swp_tb_is_folio(old) || swp_tb_get_count(old));
-	} while (++ci_off < ci_end);
-}
-
 /*
  * If we are the only user, then try to free up the swap cache.
  *
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f5474ddbba36..d77c00c4b511 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1287,7 +1287,6 @@ static void swap_range_alloc(struct swap_info_struct *si,
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			    unsigned int nr_entries)
 {
-	unsigned long begin = offset;
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 	unsigned int i;
@@ -1312,7 +1311,6 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
-	__swap_cache_clear_shadow(swp_entry(si->type, begin), nr_entries);
 
 	/*
 	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0

-- 
2.52.0


