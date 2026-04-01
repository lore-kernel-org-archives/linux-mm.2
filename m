Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C60A4D3515E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BAA86B0088; Wed,  1 Apr 2026 04:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A966B0089; Wed,  1 Apr 2026 04:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232AD6B008A; Wed,  1 Apr 2026 04:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DFCE6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:41:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 936881B8888
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:41:36 +0000 (UTC)
X-FDA: 84609343392.20.92A5CB1
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id CCAFE4000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:41:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NM+V15ad;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775032894; a=rsa-sha256;
	cv=none;
	b=c03v8+D1042a/H4sRNSG7LaMg7oNYrZ6mFfCzfC7anpTu9uUSC4wRKvbcGqhxiKBn0/wSM
	sndY6j19yrfrcBiM86xLn/bhZmHSQwmCFTbJbuvvUjbBBbzOFwXDquadEsuNH4XWFF9Rn8
	+Eg48PkUP1cAoqxWNk8SmOJXye2Fh6s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NM+V15ad;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775032894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=g1aqQ8mbDFeeQ3nynqxs5YAP/IEVa98qSTF28X6wFGM=;
	b=PoC4zOUKUB3q81gNwXEMMF6dH+LCE/k4qrhGyoG2AcxDTUDMvhfeDb4kOb28QyrqThnK0P
	KmYw7fGkOzhyupyI/Q+Xyod+IA/YOBx7R+QpJrzu2LyYuJ8r9jkCypdIIKVCsDj+3huS6R
	H5taVcGSxRcdX+xRT2bJ++FvH8OXIBw=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b2503753efso26110355ad.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 01:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775032893; x=1775637693; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g1aqQ8mbDFeeQ3nynqxs5YAP/IEVa98qSTF28X6wFGM=;
        b=NM+V15aduezFfu8hBKaD/sJaN7DjN7aXkvFuSsKIdnnZ9idcqHKelZRs5VDTeFIw/S
         rdyyhzHSWACFyP945kiu9XTh9OnsnWqnrkBxGhyEYLVS4ZZmp3kn8h6bj+FKUvrSeUFt
         CCgkjwfgNYTy/R38+woAbjbCjkALEBclUs4+Q04BXZusxHKcANV20EYMS6SJLOV6W7zO
         lyY7E9Q5R0KcT894jJUkMSva4t2bncauiZ6/qEr7xrQj5y8l8Irz/cHDPX8BgcUYwuwH
         PwFZU6wdsizFDjk+X4jXwiPjvMWhY031O3j38AXeewka94FHGiFrqvTCCkh3nMftMJkS
         qBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775032893; x=1775637693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1aqQ8mbDFeeQ3nynqxs5YAP/IEVa98qSTF28X6wFGM=;
        b=EBwupSNpTqrdV37QwV6QB0aZoaPZ5iDmoHmYuVCh4te9j8q5Tzd8FmU1brehQNpu2L
         TnorskS5vEF+UyRdZh46kjivxFKoD5q85XgPuMjvv6i8x+/a77RmJRhBYbi1N8R3bz8b
         wKVxDzfer8Pvx/eqCFDHZ/WxRet9wE/jNjXff0X3uJmX+5i14SJZcXAckRHELaLfOqTN
         sjCS6q+ERxmW/h6Cfoyox3pAIIpAL6JFgCXDDhJE08RE0pE+SKmSxVwOvv7T8yaEstZs
         s3iIpkDSx9hocn3XXMM4tw+IYq8uQxPaD5V++nC+trdHFwQ9D2b0vscbEXZoW2H70AVL
         EXwg==
X-Forwarded-Encrypted: i=1; AJvYcCXXHDcqzdW9npYOALqyZyBia4ILdDS6Q+RdW17nDH+S/D2o1Tveqj+ruVk3dgZCfGm9F1NdGar/Sg==@kvack.org
X-Gm-Message-State: AOJu0YyOHpA3m+M2zOJEDUg/7xWQCnSuYytdS0PsWQPtvq8CbzkdZgpL
	1Oe+nRtdWbrA3GKRw0LrulD5sh20da0zCI04lpwGdOGp++jw7YDN1A6Y
X-Gm-Gg: ATEYQzytZ3wa4iMsJZF7/tIlDV6WZqwdEx/swBe8+PvkR6ZJKpQKnhPuuqHsxgMsUdh
	4GZyvqPcOovo8m8ljIlFwCWE1KNZ2NUChT5bXHA089oDBzgLAIH7TgqhijldEw7yfqlrYqinEiV
	9F7id8NiK2Wie7h+MWFUqnF58Cjiqn55OdwhJGOawEMu0/RuyRI0kpEqh+tEPVvK3HnmCrhk9dE
	4/VsLdvzmtKlNqDQ+ii33NzDX2o7FY5tS1OxNBv0D7hq9FhmMa4r9o3MnsCtOomUNPF6n0JZagM
	a8Eq1Yt3N4nKOdARx/Xkm2Sx1ihSu/JDQGIUChtLZe36JUaY8byo1HBlC4C8qtm8e6mTqVYs6je
	fLqG+6d0qeZcEiy18WY1ZP1hp2cMhBn0nQifQvSsQ55lv6ODbcOEc9ydCKzqW4B7bXMCNuBNwCQ
	67xO8IUmPdmIX1oiyqnbzHrsNSAGndpzF1ojnCStMASH6PGjTeBGoqtKHjwCEqWZyC8LtT85ywx
	wnIkEM=
X-Received: by 2002:a17:902:ef06:b0:2b2:481b:de6c with SMTP id d9443c01a7336-2b269ade14dmr27741615ad.10.1775032893449;
        Wed, 01 Apr 2026 01:41:33 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:27b3:c33d:3338:bc86])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24264287csm134794435ad.3.2026.04.01.01.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 01:41:33 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Cc: usama.arif@linux.dev,
	richard.weiyang@gmail.com,
	sj@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
Subject: [PATCH] mm/migrate: fix stale partially_mapped arg to deferred_split_folio()
Date: Wed,  1 Apr 2026 14:11:16 +0530
Message-ID: <20260401084116.22219-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CCAFE4000A
X-Stat-Signature: thzi1g5c6ikn1da1x485z3thw853o93h
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775032894-431710
X-HE-Meta: U2FsdGVkX1/pGHCWGyz9UFa1LnDqeLRGmfuq5hrz5MoMLzieEGKO8QEPLwBeX5lgkrLzZj6fqlxzRKgRNNf22vBWuQlya65rMZlexroijGoZeiT0Pce1mI7aZc/jp2+VOSiLNq3ouze7LtUaj0nZwwo625CwTt/Gh4acxh7x9RxQc/gXJfWnIj94QGA8Bqx7VLOo83qlhv17lyR26V2BAVGskwQtmj813kbHqIZkKNHotp1nZUaEGaMqwgv0Suit7sLIEWiFBVuOG4sFQenT0G4lq4qHshNWe/d+lwuMGN3wFmtz3xKbuhUSGe27KC+QfHAWuIGfNOwdWD0vRUQrAwKME9lwPyWgv14hyYoJAsuovQvqhN9f8XNQVVUBMQQmQ4mWLyxhwFJ9c8tonzX+UzPFGYtjjbFbQIkE/rI2mtHwCHnpKtsK5g6v3i4si6s9lsI6z/bCdEbBnxD27V0ouu9KbUjF0WxPq81n9kHEPRUCVZ4/IE3BhqvlRYP+kg1RSRkgJG4aIEMqH5fVOvTaR03G1C4LJa///kpF3SledUmm9v8yEZ/o3S1GKFotxltMpdG6B3Iwf0q+SzFWv2VVfA3yizwQ8G0oiUycZQTevK6BmlZsY5fv10zRLRNM0Gq/yR9cSIfA031E3QXB4GJavGDb25hqPlHkw1XoHAX0ca7PtI8cNwXA6h2uE4KF9KZv7YtqeFS3EJ0JHJXMiSMomU5X+IEVyejLlPs20sR3d6HoNbmftvpGK9rnvYEA/zNd8ybjmsl64txxS6XE/Ema4xvUTC/ADdLx8gF1SsNxOiMUaDMvyedEXWpbLbMmpeZA2yD3srhE0HSNxDZHsHrfzs0ob9Zpodh2rwYaBOIl+TJkO0wc8CsxLr62p3YBAhCFcE9bjK6cbdYXMhiItmy6Ip2oyZaP1MIwds6XNR7z+O3Q1Z1g158CDjQP+9CjIfF79LjFuruPzzbc2tBsirX
 hIheTT3P
 a0XzFTE2gCqAfNjG+043X+m2yn+sM5AP7UVFI14D6IknxAxoOCyiBI+iSMarDljcUCX8kf8MRwZYYeUNwFKJcH6Ft9GYCp/P5ot4dIEnYogFrhs1YenmfHxaGnKL/+w+5WTotgiqutpc0lXQOH9D15B04/xQOD0DImUVZOjdGhLp+vTiBrGF46Z6EVNKBwIOQKHNqEhMdAPY9wvAnovkzkz0f90V6ptwxFveszln27DILIeT4rTF769xeg7xOIUWbd5qSj0wg5dDdp1+IcfpOd0LYqndnjhcSwO+gKSLZOcpTEosyVdXZFkL2Ovui/w5RP9/sNK2Xwv+k+9eQAKpxGGForgw4vaKtMPiuXjd/kr5R71CIYdnat03M61EbK6Kbvssr5IEb9Wu5V5ZF4/s7j5VLwcCp1e4qi6tknYDP5ORHvvff6BMgCP3mU7QxZR4h2xFSKbaZOmK2CEKjPdfD5MklGkmBm4Ef5ygeGyJJDmNHx+culhtHajNlgeoXzbbAwoWLmcIOATnEK8R2ncywVqTvVO++OEOAp7Ds6iPyPZHvG44sqXDyLIOcsgNqR4+EQY4H+DUpNDyIyU5zV6jH8hafxDYW/3C3S1JGQS/CZuBtDiZzWVw3lEv8qJbe+qgh7VKfinHnEEbrnPuwXlWD6/VXRi65KLtcFFIOhVtMTZ2vCG3scO2Qs+hyPi3mlD3Ok3qrc4t17Fwb3As=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In migrate_folio_move(), src_partially_mapped is sampled from the source
folio before move_to_new_folio() is called:

  if (folio_order(src) > 1 &&
      !data_race(list_empty(&src->_deferred_list))) {
          src_deferred_split = true;
          src_partially_mapped = folio_test_partially_mapped(src);
  }

A concurrent thread can unmap pages from the source folio between this
read and the actual migration, making the sampled value stale.

After move_to_new_folio() succeeds, __folio_migrate_mapping() has already
copied all folio flags including PG_partially_mapped from src to dst.
Passing the stale src_partially_mapped=false to deferred_split_folio(dst)
while dst already has PG_partially_mapped=true triggers the invariant
check in deferred_split_folio():

  VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio)

at mm/huge_memory.c:4371, because the argument contradicts the flag
already set on the folio.

Fix this by removing the src_partially_mapped variable entirely and
reading PG_partially_mapped directly from dst after move_to_new_folio()
completes, where it is authoritative and race-free.

Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
Tested-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 mm/migrate.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 05cb408846f2..11236779e910 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1361,7 +1361,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool src_deferred_split = false;
-	bool src_partially_mapped = false;
 	struct list_head *prev;
 
 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
@@ -1378,7 +1377,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	if (folio_order(src) > 1 &&
 	    !data_race(list_empty(&src->_deferred_list))) {
 		src_deferred_split = true;
-		src_partially_mapped = folio_test_partially_mapped(src);
 	}
 
 	rc = move_to_new_folio(dst, src, mode);
@@ -1404,11 +1402,13 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	/*
 	 * Requeue the destination folio on the deferred split queue if
 	 * the source was on the queue.  The source is unqueued in
-	 * __folio_migrate_mapping(), so we recorded the state from
-	 * before move_to_new_folio().
+	 * __folio_migrate_mapping(). Read PG_partially_mapped directly from
+	 * dst: move_to_new_folio() copies all flags from src to dst, so dst
+	 * now holds the correct authoritative state. The pre-migration value
+	 * sampled from src is racy and must not be used.
 	 */
 	if (src_deferred_split)
-		deferred_split_folio(dst, src_partially_mapped);
+		deferred_split_folio(dst, folio_test_partially_mapped(dst));
 
 out_unlock_both:
 	folio_unlock(dst);
-- 
2.43.0


