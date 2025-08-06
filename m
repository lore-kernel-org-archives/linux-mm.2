Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC6EC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F2A8E000A; Wed,  6 Aug 2025 12:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC01B8E0003; Wed,  6 Aug 2025 12:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAEBA8E000A; Wed,  6 Aug 2025 12:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B63428E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:18:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65C11140653
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:18:48 +0000 (UTC)
X-FDA: 83746841136.06.3D690B2
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8EC1D140010
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:18:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E8x/ScCE";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754497126;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xTP21K+jB6LayI4lbO9257BksRaVlqE7Ti1iQOs5KI=;
	b=zhPH2xBO4QcryHlTPMuitH5vCsmSj2XE+fISWMVn/vrqSCjqO2xjqdrGfhV8MnFWo0ekN/
	mbgQpliJfCinBj7ikIZFmP77Bs5/IC/xrodNUmVtRyJ1/ipjYvyOzArlmYtaoq2ad0JYx4
	k4GdJqbU6pUq9AM6FVHfgR5v+Nszt8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754497126; a=rsa-sha256;
	cv=none;
	b=hVXjR1d554bMx0vuysb2GNH2/YS9cywoUX7OReLehbtLb0VVjSGcLq66J8ug8jPQGxpbg4
	3/4fCP21LYyAdlxbGGwQUaLAOA9opOZY4jD18pdsU++MbsPqzunzX6socXnRhROf7JgrRg
	mJa0Rzh0FCAgh+QGyGBfUhwpt1TrrTY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E8x/ScCE";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7e34493ecb4so6125485a.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754497125; x=1755101925; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7xTP21K+jB6LayI4lbO9257BksRaVlqE7Ti1iQOs5KI=;
        b=E8x/ScCEvnJClo4kB2tLWIv1/cEF/DhSksOftzKRXN+FsyTqqcILkuyPnic/q7HLMN
         SIiTgsfnXSVho9SbyKi6tKTxoPxH9q66QLoKB5/zH6TpFFB9CoZ2B2j/DLAYk0N9x+L7
         mvc7BCZNkz9VpzeBvOmoK1Vcw1zVb/3zsT5gxdMTyYwGfXReHF6X2xMX2x7r4bTevkma
         TyldnCIlP9w1wvmlXVqSRv5Se9Sc3fuoGjb6aKFUl01eVrgBZ58B7FKPXzrribBQCsnc
         YiY9rt8RqCicFzVSkE8bIviIhLpTAmtD1jNhR00aKEFdJVAOIsU+4bF+bfGMmACefGMr
         x+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754497125; x=1755101925;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7xTP21K+jB6LayI4lbO9257BksRaVlqE7Ti1iQOs5KI=;
        b=jkfD4w9V4vKp6LBxpjqCa5jRvKK23jkC87DjYUQocaCLgace58OZM2ngfCXSLKb7ik
         8x3e1K0DluBHzzZDkP7R3S+66zNZw7/8jsOaOKWQd73cf1Sw4JpIht//cI1uWNVoP2xS
         8qPg0PG72rSEdB3rJF9VbktanTxefTaXzbKTufm4GbCJB3ZIIHh+4Rm6AjYoVvYn+26P
         7BS8TjV4NdyoKZ3v2GHD8bP4hZ/gCWYpj8DMG1MYizJEYbWo/pnJ8ErNV08PX/cDckKi
         DscMWCEKQJFwUI+wFXnd4IIhZd5f0h6OLVoynRJO8SCKY8IT0m+Yyu8pTLwPGQpP8v8r
         uqNw==
X-Gm-Message-State: AOJu0YwbWF7/S1BKbbVnQYGEUf3oiwOPqPF+PGyxySbO92uIGcQX3pkk
	UWQLbxv8pMPNWvxbz7MBEKHPgbnZm60Z2rHCc0LBu4xrqFfj/RmqOB9oo7+T6cGMgnM=
X-Gm-Gg: ASbGnctLUynvzOGlfLrr1PvYDCL6VE4WH6dsNfKRnTnImj1jsiLhUwyctOgHjyTrja1
	6kolwE43JV46C9XEyeqdyvWN/2HoFZVgsCkw3BRAjEug2DJ7zA+js2CEOy4R1clKsmDAiuXV0Rx
	tsXaGKdxBS0ytTYgZDHzU13Lq8uFfsy5dMzanrrrsqyOOLlp9xOHZO6wJwvY1H0aayZyHE5uf0A
	8IU0igvQZRK3X/b4OElx5dlWtQFmE5OzuphaAUcg0SLQ4XmID8O0Z394wBgnkdUF6YPLePnAZR1
	QAUCOviCe+IkPMMLq0pF1zM2kRJGdxpCzFBIHyNKmbwL9Mcaxxd2iksRbLGp9Q9bEja6YcEq6vQ
	WntGcKBwO8qpX+b8mGni5tr4S4BQ=
X-Google-Smtp-Source: AGHT+IEiDj+VysZpnFBYXYgnr7uq4D1H/+DepEQer1BDI3uxqce/V9Sjo60cv+6UqW8BMCTnSCbvyg==
X-Received: by 2002:a05:620a:4513:b0:7e8:848:64c1 with SMTP id af79cd13be357-7e8165f603dmr442638985a.12.1754497125020;
        Wed, 06 Aug 2025 09:18:45 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e7fa35144esm464081885a.48.2025.08.06.09.18.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 06 Aug 2025 09:18:44 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2 3/3] mm, swap: prefer nonfull over free clusters
Date: Thu,  7 Aug 2025 00:17:48 +0800
Message-ID: <20250806161748.76651-4-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250806161748.76651-1-ryncsn@gmail.com>
References: <20250806161748.76651-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EC1D140010
X-Stat-Signature: whxef14xjwzdam1coxmpf55swi4s1k1z
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754497126-129450
X-HE-Meta: U2FsdGVkX1/kXW5CHkaIhZ9I5SXvS2x9gwaQh+4+LVn1b1NyqNNff9HlsMSci+u76hRBaACi47p+FIIdB6gM9fbPZuQheQS4FYufi+QXae+GZ+blY9Ub6PU9LtZ/Q8yA+vGHaypvljwX8ZPMNO0Tgeomo7vVOs5K2WDFI6YjgmKubcajpNFJS4cPOBuXQUzl7DYSwF2pL0RdiJ81PJBIqdFoiiyWhyfjp3W+d5HXew7NtnOfjFBpaCmtY+iRRcaORTS7apMiIEcW1mS2plv6vEU/QbGCkdRvRXi/awAphehxam1b7TjO7UvFzLJumUuNn7ZoRSi2ha1fXcd8K6EVC+rnJwS38aGfcLjKFcx7nm8t1wesBcSCarJJo9oMFeOuPfJQYR0Jq6EwCKckgZLSJjZsqnjH3gtXmOifcY9sBDtBLuwb3paCPrEONFuf/1bcT4pFowcjLofrR+AMF4ReOFwQkSUa+ySF+sYdBvDfzSIdkogHh1vnBCC/MKwF6/angk0L1SOLdvye7zV7H1laNgzw+xV58WZd6G2F0zOkKAY42N6bdYjJlGDc8gV7Meo7KQS4vbOYKaxCDJImEH8hOO66Bp/wBcbDcizMgvu4fqtfPmi40lVh0Zqzo//Dmzvw4N+zi7VZZFWsc3aDgR7dBOQrBZq00Do6pFkJR0FPW84+e6YwJf/ODlaYRCzwLCO73kSrcLjuWdYnJgxAmnm+Ft8vBI58EA+UmdPF4Xtb0mOarzGlCFm3eEJniUhfTu/b3XL30WolXMclT6WGbFPwu1Zqek1FH4ltlghouL9xZfi9cFo60eQUxN7R749qMixrhJfMYsc9aXba9UFeMFl8ulOPl6RFOWNH2TevnymIZ/PWJ2qR4y1cEJoYEncxw1O73xX6TZn9EbYMDLJ4nXIJRVJ56mp8NFWgyODRkTjJxbJY+8nNpJv3aN2VKnDaJKJQdd0U/iygMoNMYB1N8Nn
 B4Za2VCe
 lVWGxUfwqbcVqrBrkWHSZ9F6IvqAbhFKhyMlZeuHY3aMDUeObTBr+od+OQEhN2OhSHFlKNZE8PgZTc0SJNbrWCno4YmAMySVypNqIl1bD0PsCXjwtQnrJPFl+t1kPxll3oa8E5v1QVoh71Vnl9w0+yuLkTprj+LDtW+98Rnp0kjDqQ1AAqJ2lGj2C5h2p3dRD3X4XtAD8Qf8Okbw6LoO4QmUF1KU7bF5zicb9ERvw22JynmlskxE5aVdQLFX3ge3UaqcpHlMUwJXOatJmagr6FxT+lXLcFbV/OOguic5rFZmX7VUNt3bvybxm2yvrYr/Ce8kDeaEDZcFDho2A+KNiL1drFvxMOfyyK8pz4z03VJP6VP9qXGZRXc2vncJ3xvvP6MqQ6FsXf/+Ir8ofWTetYQ8OC2yJXgwqIm92cxa3bXPnjDRp3X2XI3hTDeoIfzfgnbmP/hwAadi/pOmEGZQ0kSPAOPm+c/u/f9tXZso1AQS2gdK2m/0raJMf38k9JLy/iaPQonpCjesnJ4pGqLeZXqv3vW+ZjZw59AXmgZV8J66vhAdq96dbrByEhZjVOSVj5OMPywIC95SM+fBTS78JPXwTlQXV99k0wBVaEWNXjqlyBhwv5tdu/jQnGveAD47jvLLEWzh//17snZ3sIhz7A/5Q59hY0W/ikqEAA7iA79ZVVbU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

We prefer a free cluster over a nonfull cluster whenever a CPU local
cluster is drained to respect the SSD discard behavior [1]. It's not
a best practice for non-discarding devices. And this is causing a
higher fragmentation rate.

So for a non-discarding device, prefer nonfull over free clusters. This
reduces the fragmentation issue by a lot.

Testing with make -j96, defconfig, using 64k mTHP, 8G ZRAM:

Before: sys time: 6176.34s  64kB/swpout: 1659757  64kB/swpout_fallback: 139503
After:  sys time: 6194.11s  64kB/swpout: 1689470  64kB/swpout_fallback: 56147

Testing with make -j96, defconfig, using 64k mTHP, 10G ZRAM:

After:  sys time: 5531.49s  64kB/swpout: 1791142  64kB/swpout_fallback: 17676
After:  sys time: 5587.53s  64kB/swpout: 1811598  64kB/swpout_fallback: 0

Performance is basically unchanged, and the large allocation failure rate
is lower. Enabling all mTHP sizes showed a more significant result.

Using the same test setup with 10G ZRAM and enabling all mTHP sizes:

128kB swap failure rate:
Before: swpout:451599 swpout_fallback:54525
After:  swpout:502710 swpout_fallback:870

256kB swap failure rate:
Before: swpout:63652  swpout_fallback:2708
After:  swpout:65913  swpout_fallback:20

512kB swap failure rate:
Before: swpout:11663  swpout_fallback:1767
After:  swpout:14480  swpout_fallback:6

2M swap failure rate:
Before: swpout:24     swpout_fallback:1442
After:  swpout:1329   swpout_fallback:7

The success rate of large allocations is much higher.

Link: https://lore.kernel.org/linux-mm/87v8242vng.fsf@yhuang6-desk2.ccr.corp.intel.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5fdb3cb2b8b7..4a0cf4fb348d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -908,18 +908,20 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 	}
 
 new_cluster:
-	ci = isolate_lock_cluster(si, &si->free_clusters);
-	if (ci) {
-		found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-						order, usage);
-		if (found)
-			goto done;
+	/*
+	 * If the device need discard, prefer new cluster over nonfull
+	 * to spread out the writes.
+	 */
+	if (si->flags & SWP_PAGE_DISCARD) {
+		ci = isolate_lock_cluster(si, &si->free_clusters);
+		if (ci) {
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							order, usage);
+			if (found)
+				goto done;
+		}
 	}
 
-	/* Try reclaim from full clusters if free clusters list is drained */
-	if (vm_swap_full())
-		swap_reclaim_full_clusters(si, false);
-
 	if (order < PMD_ORDER) {
 		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[order]))) {
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
@@ -927,7 +929,23 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 			if (found)
 				goto done;
 		}
+	}
 
+	if (!(si->flags & SWP_PAGE_DISCARD)) {
+		ci = isolate_lock_cluster(si, &si->free_clusters);
+		if (ci) {
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							order, usage);
+			if (found)
+				goto done;
+		}
+	}
+
+	/* Try reclaim full clusters if free and nonfull lists are drained */
+	if (vm_swap_full())
+		swap_reclaim_full_clusters(si, false);
+
+	if (order < PMD_ORDER) {
 		/*
 		 * Scan only one fragment cluster is good enough. Order 0
 		 * allocation will surely success, and large allocation
-- 
2.50.1


