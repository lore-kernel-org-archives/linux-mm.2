Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A772C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E501B6B0095; Thu, 30 Jul 2026 02:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01886B0096; Thu, 30 Jul 2026 02:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0BB6B0098; Thu, 30 Jul 2026 02:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3A6E6B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:41:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37CB71408E4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:41:34 +0000 (UTC)
X-FDA: 85044496908.30.12F1EFB
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7232A40006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:41:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WMm2/wll";
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785393692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tykFrDMkx1MM1VG4l80NgytbO4sYhJ8jcy8WA1wreI0=;
	b=7m61+fEb5xe3oqeLE6jS04tO9NgF3ioYFWr5lgEfq4W1SfDMhJWKMyMW1mZ/FNQXYYKYn0
	cpCvTd6TN1HPlgILpnalMB3wNjn679IX/PaohBUcchc5a9/2vF4Oh7gPrhb6lYsZN7E2tS
	M5CSq1xG4bKyzH2n7Roh16YFsBzP0MQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785393692;
	b=0IoINsQaqyW/SGPDt9YPm+5oApGlrCzbXeK02k5iK3DLQO86B42T1CPfFdZ7q74x6HN+qr
	t76kdHLYGbnBbRpnjeKhNpXfhbHOyGbNtGN67cUMA+U9eAUclSGx8avStVPy+8vB4bE7l3
	VHoPg2srAiF6kG4rUDO9x9hRnlijGQA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WMm2/wll";
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so1476512a12.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785393691; x=1785998491; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tykFrDMkx1MM1VG4l80NgytbO4sYhJ8jcy8WA1wreI0=;
        b=WMm2/wllg1Y6vIm6lVKuBSiEIcQJF6LUkRlJHq4QN8yLk1/20CJKHcMLlQS5NW9QPB
         UGDmuiB3z/AblnPMp4lYuafPLhOV6m1hDMOlGTapIy7thN5+sc4sIJFTjVni6AGlilYR
         8R/+W8OS/TZ78VklIxY8OHzMLpxuKAfgGY7uLOOfS/ZgOjGtW9Ss2ahYY7Elqwp8HJHd
         4k2sw6aoAsGtiKsygz9+V/M+5gVjFr5AxH2M6AmR+mSo4M/fxEvyPj2MYDSKN9HpNstp
         rXjecfjPijUYxgDGH8NLRyBzS4aKB5vWq8sCDta4lCMHxcYG0tUD+l0aUgrWITxgu4hk
         uC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785393691; x=1785998491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tykFrDMkx1MM1VG4l80NgytbO4sYhJ8jcy8WA1wreI0=;
        b=g2RGji8aZVTzHFEhku90t9oQrmPMiENHYlfKWygyT8KPGBtrvgCF16nK5d4XL8G6Yj
         NhwTmWOTf33ns9Zla3LAU6ZpEeDrQazUiug8YLtpf+VseLFket+xJksX+a+H/QZ4Lc8q
         s2XgzEmOAlYMyo7tqbmX2AKUpfcqradtirpep0Sd/NmCOD3MQXCxjzb2/4wfg79kCN3t
         I0M8eGnbdFWIkrtlWy3eyNNYwz78wCfAbV2Lr0NXbvA5KOxvd1K3kab35CaF2Nm1sk++
         CNg5O7fZbPJapph8qZY3SfbFpJeMfZxPdCVFHXT2KQt/27ETopBjuznd+kfYglVopfOO
         xI0g==
X-Forwarded-Encrypted: i=1; AHgh+RrTP0fPJ5a20lbUutAz1TRqJ8we2Gf4ICN7+V+pP9X5xfzpq/VRSFvmpnzjH7oR9hA8+ONKxiqsEg==@kvack.org
X-Gm-Message-State: AOJu0YxbJTgv9BIRSKIHK8XuNauHOthwvQv2V8rbgfCfriHCUMuKjy/4
	bAA97KX0gIxOdiLHt6w7vUyUTSBlKGuVrpW5egmDslyZahbAoI+zHEwc
X-Gm-Gg: AR+sD10OzoOCehH+PNGcB7jyWzV1sfLXDUIaZSYq+5CpkC9VV2hVGfMnSVP99p+0URw
	OOeKN8bR7f6b5EZ8WBvRHfuCBX7RwYjCEUCU01yyLOpCmSDSf1COpR7VZOhc2Aks3UJrdK7KQ0F
	dQOXxJO83gaHznKJT5mN12JFdxWy5rENOxVQljo3lHc5gVcJl22Q+JzxQB69sNvaTCs1nlQ3xdk
	U9vvWWh6zJskTFp0BD+qI2oLqYo/AE5IYcrtm8Jw6SR26LfQdc2Z2571sGudUCgcY4WVD896cqd
	UuVDppR7zHst99rCsI4gtL7b1Cjisonry/frYbhHIdl3fu/ltmb8jB9pgxYiZ4XSTXkpffeLpus
	rY+TmCuCQBCLVIGhYHyMdya+yxL6Wfw/uwNn6YR7YogG40ozBHdboOWFLXb4k12X9jdiGGxNGLi
	uBdHTxYwlFdHpaBaLMrJTqrXE2fj4M41f9fOrmNwLI9Nk56rIJ2L4tlRdNcKIpO3hKgo3HQMkki
	NIKk2JXqtSLFg==
X-Received: by 2002:a05:6a20:d612:b0:3c0:e6c3:224a with SMTP id adf61e73a8af0-3c900671988mr1409473637.37.1785393691247;
        Wed, 29 Jul 2026 23:41:31 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdb79a3796sm1739829a12.3.2026.07.29.23.41.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 23:41:30 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: Lian Wang <lianux.mm@gmail.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org
Subject: Re: [RFC PATCH v2 1/5] mm: mglru: avoid scanning empty generations in scan_folios()
Date: Thu, 30 Jul 2026 14:41:22 +0800
Message-ID: <20260730064122.11785-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAGsJ_4w=gpjgwkndm3PAmZXxRm+E8ASG=6XFpprWwr3AxnpvSg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8w6kn49ehfb91bjpce4u75ibq84itz9k
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7232A40006
X-HE-Tag: 1785393692-688332
X-HE-Meta: U2FsdGVkX19AIr5G/bq2u1xMoKz+6Zlu6H5hI4sfw9tho9a+51bXZNwIhQuZL/y8yxmi4SvtC9w1A7yEBQ7TNVZn1opPLDKxbPO8T8bIaF0H0v0x0DZBQ+Zm5HUzmWhHwGgEsxQJGPVVTpPHj3daEfmiOLwSevKYQ4rQAabmQAgvvcO2waAWItrDfRk2jlPjcz08pgsL7Vahz0+zJSKT+2mp+iIcp/vHYBDZSUBh3rv30oIPskNCRCphUlVPL+KBGSRrcV3/hqIIA5y2Pt2+4A8wqSfQR4b8I35IXl4HexI+zZzWPWK1ecR5BfyUn5Oo44MVI0mZVNLmzaLD3z3UGZOrnh0J2ad0C64x41zWqFvYX+2JYPTvuj7t0tLoBkWfpsNTvfuY1SmjtDZIcV6bANNzuE7stHxSRwHtN3FJ8zQMadDZ/T1/AyogxrXWpbFLW2Q1kOAScgb1dAgXE/ZoY6NJEk5hCxUKZPocFFvjtny+g1ofPdh7ZrT5slzZdA4zbm9kgKXj0Ao+oBBeiYYYpboDZyJ8DZtcva4tcN2fwbrKeAEtjCvJbN6UUfoN58mr+Ob/NdgaGpjS9owSk3eo1Xi1L6inmgSyDi/oMSRdEGstpzfYgqJYr/bupITZaWfYcbzd5s8oe4GGp6IJnahJWCj0jYF+POhvBXEC3jv3keapqpP+ZeeottIxUjb7282WmvQoDfp1QbUI+O0HZEpnFhRZWWBNOGmdLl6e4HVGlteg0aSuuH/gbSI+h88wQw6z/eqJkpMENTZC2MlMpey6BLTaU/T1u3PzU47tNrM7BsL9ORn06BaAZvbdolbTN7rBlpmKGw3XLgHiHq+AHQtKOZ5yBybUr6Oq1hGTpGKh8NREn0rtO5WDC+voNhhbGtx1vWJo6g5DO3bn8gS9I2ydNkV4TxALylVN/tMGtap1fGzpgdCYgMm0WsCcyPqFqUJJnd6UzKJcG6jloMqF8Mw
 ZXsB1J+B
 ZU64BadQvAMY6JDWlhqGDjUByf/youpGhFJvHGRUaqGDQmBcFvX8mlmDXBlL2oBpEaqCrM55hdpUOh6uJCf9FHdUAnKSGGMbFt6rnZBjsXYo5tcbmDkEJuUuDfhc9iqdDW7WwexaXWhPwxLjsy3HinVgYdfbFw0mOu3D8sEDhW2p6cugfhhMu7KGYNsadVVPvbCaYM1UO5qGgrh04iOlXOc0MkmN3vyrg1Wd/X9WqxKni55ptUO8nKwcYpm8tKJo181STadM+IDDyz4AH4QNSyV0juMbbCOrjg0HA3dbVLcznEd1X5iMKf4cT1+1bxk2CzELHQoFuyWr1GAL0YK59IirLMIupALeDiyPIT2/VWrfJDkrBUlKYOKyDq11jMwJKshTKqFnEx8RA0qEXyDDuaO1pzy9C4qnN/GMJHKgmDUzpN9NyYH+AekABap1JAwYcI2pV82NKEKcMg5+iPumSaqdu7fUbCYT4x7UXfsYnN9qt4jJOSM0k5YtFUQw7DiLkewq3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

I tested a list-based exhaustion check on top of the v2 series.

Using remaining > 0 still misses the case where remaining reaches zero
exactly when the last folio leaves the oldest generation. Since
scan_folios() still holds the lruvec lock, checking the generation's zone
lists directly avoids both this boundary and the scanned/nr_to_scan
page-versus-folio mismatch.

The change below only replaces the exhaustion check. It keeps the
priority-gated fallback unchanged, and reports the MIN_NR_GENS early
return as exhausted to preserve the current v2 behavior.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a73be7590cd..59b8725a0650 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4635,7 +4635,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list, int *isolatedp)
+		       struct list_head *list, int *isolatedp,
+		       bool *scan_exhausted)
 {
 	int i;
 	int gen;
@@ -4650,8 +4651,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
-	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
+	if (get_nr_gens(lruvec, type) == MIN_NR_GENS) {
+		*scan_exhausted = true;
 		return 0;
+	}
 
 	gen = lru_gen_from_seq(lrugen->min_seq[type]);
 
@@ -4704,6 +4707,14 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	*scan_exhausted = true;
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		if (!list_empty(&lrugen->folios[gen][type][i])) {
+			*scan_exhausted = false;
+			break;
+		}
+	}
+
 	*isolatedp = isolated;
 	return scanned;
 }
@@ -4757,11 +4768,13 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int type = get_type_to_scan(lruvec, swappiness);
 
 	for_each_evictable_type(i, swappiness) {
+		bool scan_exhausted;
 		int scanned;
 		int tier = get_tier_idx(lruvec, type);
 
 		scanned = scan_folios(nr_to_scan, lruvec, sc,
-				      type, tier, list, isolated);
+				      type, tier, list, isolated,
+				      &scan_exhausted);
 
 		total_scanned += scanned;
 		if (*isolated) {
@@ -4770,15 +4783,12 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			break;
 		}
 		/*
-		 * If scanned >= nr_to_scan or isolated >= MIN_LRU_BATCH,
-		 * avoid falling back to the other type. The preferred
-		 * type is still reclaimable; otherwise, it would have
-		 * already run out of reclaimable generations. Falling
-		 * back too readily can disrupt the positive_ctrl_err()
-		 * bias. Also, only fall back when reclaim is running at
-		 * a high priority.
+		 * The preferred type is still reclaimable unless this scan
+		 * target is exhausted. Preserve the existing priority-gated
+		 * fallback without inferring exhaustion from scanned, which
+		 * counts base pages rather than iterations.
 		 */
-		if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH) {
+		if (scan_exhausted) {
 			if (sc->priority > 2)
 				break;
 			type = !type;

I built and booted this on an arm64 VM with MGLRU enabled. A fresh
swappiness=200 pressure smoke with a 2 GiB file-cache setup and about
7 GiB of touched anonymous memory completed without a
WARN/Oops/BUG/panic.

Would this be worth considering for the next revision? If I misunderstood
the intended semantics, please ignore this.

Thanks,
Lian

