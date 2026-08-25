Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D32C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B91D6B009B; Tue, 25 Aug 2026 11:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069BC6B009D; Tue, 25 Aug 2026 11:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73B36B009F; Tue, 25 Aug 2026 11:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBCA16B009B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:32:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8580C047C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:52 +0000 (UTC)
X-FDA: 85140184584.27.54B2520
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 02DAB40005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WJ9S7a6x;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787671971;
	b=J1bNJ+kJYKkEU3M+5jW+Qfw7rWSy70HWT99K7pLnX1yoJci486UzFPh31/FKP107OSy89k
	LnISFbu+HeyaK8/tBcGCw6GKFtY95VijqwEnCQy5jXr8uF1GbWp1jyAdoT8SCgscIH3xim
	UCC/UU7IIRZPhUPQ4m+nEZ3DCTF73R0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WJ9S7a6x;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787671971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efoGnqCiYbC3GQtG+3aDF+oz3AA7LAoLSzZXQ/arlkM=;
	b=uwHIxRtKMukiOwnjs+1DTivqioWDi94fKEucxA5RXl8RLYW4cD47XP0QpQ87a0k3jRPfm8
	UgH7TLb2OkI99IzcRstRoL8R+153fVNVglcmw3bnxBqTrOktE2oxOiS+bP2eYRpQZubMTL
	pr2oly4XMm3wJSJ5Yv9EJi3MVvjezcc=
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-44cedfaab6bso2499276fac.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671970; x=1788276770; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=efoGnqCiYbC3GQtG+3aDF+oz3AA7LAoLSzZXQ/arlkM=;
        b=WJ9S7a6xB136ohS4Fuo+Z3B2TliDsJ+ObyRuox8z9F8QhVP5wHKNPp8DxOI+T9Nbyj
         xHDM8O9MwumW1aJHdvR1wX2lApyxY32wnqbixH5WPSeB2jjtpLkHI6mYk0La4L1WCj5s
         uzhj1apOce0d2inNVJdeNwJXN2YFpRQSTgVfVtQkWyz0DtjvyF5kTkK9OUlDWTKx+Upd
         nhAysWtWw6c5QY0AbrnxV0HwmFt4ON61wapfK9jhZisgsBiuHOxx4NXgN0UM9mmJsPFD
         aIzOuJ4+sRALqaATot6G7SBYvlzn3H2KD2gCtvkn68RIa/5xbVDyWqiAHSh2XsaH16Mv
         8RSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671970; x=1788276770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=efoGnqCiYbC3GQtG+3aDF+oz3AA7LAoLSzZXQ/arlkM=;
        b=qpm+JfcpIxW5PzfXgygyBwtcJiZKfzqOZGWbrY+BfepXyx9P8m8brSGongkNJo6IIf
         piw3VW04kI3xWFiK354JURJF5qe8NGi58iD3a7uUnBjhJbWQFUB7gxK4MAbDlmDto3Ef
         HJxkUnEO7iKklh9rely6GaeIYBTrkTDzMQpZiXg2IZWonSxHKlwLxssXopjZqD7k6L44
         KlPLyj10tt3wKnccR6KO/PkflyvEun7EyCEww30DqUk7TR8Hv2by3KLvSyRiC5KOSLzV
         Jtzjjw6Xu5r6SDRCfHe3f+CnIbUADScPaGptnjKLxhZUeqJKcWso2W0KVuuKkB3X3btI
         vdIQ==
X-Forwarded-Encrypted: i=1; AHgh+RpS2tfU0Y2RpICkKgXlfbqBpxe1d3/PEAqs+qQpYe4rf8ViEWvOA6YcjoNfHg6ufLOv0cdI/bif7A==@kvack.org
X-Gm-Message-State: AFuF++mKrIAJXoI5ZfXhUeaHw6Dvb+UuDeP1x8gCnrEoK8f/kdkmQnzw
	nWESjwhPeD2xFnQ3fNwsUADM4rxxyQuqzg10Hk16mN4Kc4jG2LMMwGJ7
X-Gm-Gg: AR+sD11mvwgFoc92kF6GjAJfXgHzIJVJ2HXpzYe28Q8ESzr7bi7R1te2/k1D7qIa8JO
	68e9D99yOdRWiswUxNfVkxJdEQlAecIrW6JQML1i5RjZn+smYvI0SEPg6gBJ2brJ5v/O2EZXaGT
	aFNPOw4rSz8tMC0ewZxerGft6gHsTCKUB4yrLGVP5ejOtLNw9Ky8etiQ/kZfc81d05iBor6NRpO
	BliHecTa46i/hu2GqB57DubUHY3zgiSaBRzg9SJsPUoX+GMWaATyBH5+JwLjnyHWxlnxbkwPdM+
	HWDRcv95/+7VGwjZHRVLYl67XRUXDMcLt6pvRQDstMvfWJmqzjqFGk7T+Vqtfv+tboOOwHVJD4H
	MNLZBbIcR0HIsWqmZKxeIds52V/kcfkn7IlW2LDOZv9EngdKEh2O1NSMa7iWcJTBPH4i045kO9Y
	NMG/Dewa3nY9kiXYkKEmFT/1HGg9VjQc8ll+ZLALM8N8PMUNNlyVfEaeA+DtSbC4XbBp37mOn2r
	YlvPlGEhateg7xHuBk3Qg==
X-Received: by 2002:a4a:dd18:0:b0:6aa:de9e:e223 with SMTP id 006d021491bc7-6b16b209b13mr18223935eaf.9.1787671969879;
        Tue, 25 Aug 2026 08:32:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5e::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463831d1e61sm7536265fac.8.2026.08.25.08.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:49 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 05/11] mm, swap: enable THP swapin for vswap entries
Date: Tue, 25 Aug 2026 08:32:31 -0700
Message-ID: <20260825153238.2695446-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 02DAB40005
X-Stat-Signature: kghtbpyp9rhqdp4t3eacr9ea1zwzrrfz
X-Rspam-User: 
X-HE-Tag: 1787671970-895857
X-HE-Meta: U2FsdGVkX19lxhxxoFOzrFIYwrpUjT4Z2buzqQty6gZlt+PZYXJ543cnwymNk2Wn0MZbGCnTTAWye57/A+xq/g9TKN28Z6I0J5Hb69Kb4n/bgkXvwNmiTClrzQ0KM+zj9hGeGXDe7ZpZHRmO3KLwE+N8wcDq1dOtvl3IwHNLVPrljM8JSurp9jVQdMG0HxAfz14wvUh+u8SBJaMGMT+RSCVn772Ac59OLu2BXNilEz+mc2c0xbiJ5ynbP4QssWcJnYUa5z0vOdSMjOoRiK4+TdL5WWA8M/SL3+gv5jj8T1ay8DGHM0/S8Pe75fG4xrUIRN7eNAI14rXInO8AjLxStlwDqL1FtJKPkaq1DAneoXibloaUeaozWC6+LX7efJlcog+01ewV5GLhJo/HqRjV7p4NDXJGIfLpIUG4cpBoFA/Od2Gx8otAwSpKLtC72si3oVkYDC7r/6Fe0zwJL+NpPaBaRYbo6W7UuMqAmXKnBzFALAyEnWZy1kpNE6654E6oSHWGkhYJDTBb30rcb/1PCuqiHPq/SlBnOTGTSu4Iamnjwe9XkueatOuVCQUpNtjExjT+12v83+vGczpgBAhvBJ8fiH6jma1KsBUQKzzf6zCKUaeDjo9ncMqL5n8W8nhWCYNkJE7ZTAYFMaja9C9+2UET8TS16W7rfttXT/9iJn4N7usUOPC8/JzRVVloemzmQwsfrZvSsZpnnqKi5FB9LYcDw63sC01HhydJ7rYtrNxdWAbw42A0uzTIlKv/XOg/CEsNlLI/o8ISpHnw2vU3biTiC8zI2pauCkCJE4YoNBmqnm5Dcb2JIYpY5GlbABXoODIneXAjXQIkAgK9WXeG0CddN2N/SiA8sS2S1GEPRzoCvRs5yc3xXcJ2LNekiYMht4pifvqtFW6o/MkQ53iLCbC9ZTCqhFcFL+wT9pHIcUSOiWnsM+1T+gIfCkMMox2kQihfA9rFEOGdFRjoT/z
 O7yh5hhh
 uob/N8HQUr5U/Mqp6+ES/hKudYIU2lHwSzuWCf1hQTOU8jl/oBH1hGiI13NmPOJjFcRICDMoln8WJw9ZfgcvKIN+VIjckf2a1BZPw8NdU+J7xXZAz4W7i/Ji/fGqHGFVH1URa9xC+mowKTXu+zdrI/YeV9T0syYcQqHAkPMu/FRhpy/VWzq3wmtNh+tPlZxKum1xEJxFS3qBBUgz1xrduMfdCrqSC0izmDJLjloCrwB6HX7NfErgRrFbRYaCnCWhkBdRhLE7oEAbnQJvgMc3VPdnT+yXnlEiF32/fLmW0eskI+keoiB32y0a6setQbIAWfAudXfz52z59aK37eiDj6BA2NzzY87r2N+wgXlpIVGaUR3owWC7MbcWHPYp/WXJN0qD37sqUno2D0e65T0hFALgLyj4wudUFSUigqzvaNgddOVvmgKQQl1xHDAR5HnTO8TTI/1lBixIYSNgmleU9gPTX1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap a large anon folio back in as a unit when its vswap entries share a
contiguous run of physical swap slots on a synchronous IO device,
instead of always falling back to order-0 faults.

A zswap-backed or mixed-backing batch is still refused, and the fault
retries at a smaller order.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     |  5 +++--
 mm/swap_state.c | 17 +++++++++++++----
 mm/zswap.c      | 19 +++++++++++++------
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index dc4dd72ce73b..62f7b82427e2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4823,9 +4823,10 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	 * lack handling for such cases, so fallback to swapping in order-0
 	 * folio.
 	 *
-	 * THP swapin for vswap is not supported yet either.
+	 * Vswap entries are checked later, under the cluster lock in
+	 * __swap_cache_add_check().
 	 */
-	if (is_vswap_entry(entry) || !zswap_never_enabled())
+	if (!is_vswap_entry(entry) && !zswap_never_enabled())
 		return 0;
 
 	/*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c0441783b8e7..5cfddec8633b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -174,6 +174,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 	bool is_zero;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	enum vswap_backing_type type;
+	int ret;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -202,11 +205,17 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return 0;
 
 	/*
-	 * Reject a vswap batch so swap_cache_alloc_folio falls back to
-	 * order 0.
+	 * For a vswap entry batch, reject if the backing is not THP-amenable
+	 * (e.g. uniformly ZSWAP, or mixed). The order-fallback loop in
+	 * swap_cache_alloc_folio will retry with a smaller order on -EBUSY.
 	 */
-	if (is_vswap_entry(targ_entry))
-		return -EBUSY;
+	if (is_vswap_entry(targ_entry)) {
+		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+		ret = __vswap_check_backing(ci_dyn, round_down(ci_off, nr),
+					    nr, &type);
+		if (ret != nr || type == VSWAP_ZSWAP)
+			return -EBUSY;
+	}
 
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
diff --git a/mm/zswap.c b/mm/zswap.c
index 9a00ee049cf4..f16c0b44b5d5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1629,9 +1629,9 @@ bool zswap_store(struct folio *folio)
  *  will SIGBUS).
  *
  *  -EINVAL: if the swapped out content was in zswap, but the page belongs
- *  to a large folio, which is not supported by zswap. The folio is unlocked,
- *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
- *  do_swap_page() will SIGBUS).
+ *  to a large non-vswap folio, which is not supported by zswap. The folio
+ *  is unlocked, but NOT marked up-to-date, so that an IO error is emitted
+ *  (e.g. do_swap_page() will SIGBUS).
  *
  *  -ENOENT: if the swapped out content was not in zswap. The folio remains
  *  locked on return.
@@ -1652,10 +1652,17 @@ int zswap_load(struct folio *folio)
 	 * Large folios should not be swapped in while zswap is being used, as
 	 * they are not properly handled. Zswap does not properly load large
 	 * folios, and a large folio may only be partially in zswap.
+	 *
+	 * A large vswap folio cannot reach here ZSWAP-backed, since
+	 * __swap_cache_add_check() refuses such a batch, so hand it to the
+	 * phys path without warning.
 	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		folio_unlock(folio);
-		return -EINVAL;
+	if (folio_test_large(folio)) {
+		if (WARN_ON_ONCE(!swap_is_vswap(si))) {
+			folio_unlock(folio);
+			return -EINVAL;
+		}
+		return -ENOENT;
 	}
 
 	entry = zswap_entry_load(swp);
-- 
2.53.0-Meta


