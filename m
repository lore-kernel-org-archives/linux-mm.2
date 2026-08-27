Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3335C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEDC46B009B; Thu, 27 Aug 2026 19:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E156B009D; Thu, 27 Aug 2026 19:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDAC86B009F; Thu, 27 Aug 2026 19:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0D16B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:47:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2910512021C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:26 +0000 (UTC)
X-FDA: 85148688492.30.B5F9948
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 971C91A0005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iR+edBfU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787874444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7I7JY1zLaktW057z/Fnc7oBx6JyoNkQhe3RQzTBptJo=;
	b=UInyEOu3EVdHkmTlCJlyrhloM18Ac2TNbURydwBUirjBH0E8ztXLkFXCgQ0h/UZVc+ZzPJ
	o9wfZidMhyXHFcL4R8BhE7u9z/XmcJ9qRmkK1+KmSN98mz5NQGJLLU5LlRuhCWRpyoI2qQ
	NhN/I8VrhdCXeuqLZVRqZShL6CMIyc4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iR+edBfU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787874444;
	b=wqTE0m/++irwFsFNrjGcWpU+M7IAwq2SsZuYq1jO5LuYMh82nNj3ou2JfLz7k+KsGeSjbn
	eWcm8CaouO5lpcX6JgnOgYUyEn/mqrrT/Ny9gfdQ6IGvshPA3ngadQPEHrNSEj1AHbQt8C
	zRjoMoGQ6OyIwBD5B0gTM/uD7AQt2Nk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCADF4401F;
	Thu, 27 Aug 2026 23:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029261F00A3A;
	Thu, 27 Aug 2026 23:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787874443;
	bh=7I7JY1zLaktW057z/Fnc7oBx6JyoNkQhe3RQzTBptJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iR+edBfUOenZjti8VZvvvWuIvpP/92rNVd4C6HyLhRCj88IVyA7OyH+hpUms1EV64
	 VS87H5+jUuRKZ4sV0kClRiHjOI8dWihw+Gx7T9ahwu+BrGyo5mtj5OIGlQPr7NMn/b
	 eqdkuOIK7cAoXWkut1uGIa5LpVgtoTotp0W/e3FyHCPw+HvGPnbTg0LkaEulNE7Hg1
	 sf/BsT6+Q46Q1oZcRN7PB/5oidPcbDHbLX6BxTwBn7X6eRCO2B6z2kyVA0EsP14Ksm
	 zVVmw6o/xJHgVE5p9A3sdlNgBHeaLQT+F2rw5yVh6Iq2TYAlAPoHgbUoj7+FNEifqh
	 4nl0jkmQwZDCw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	lianux.mm@gmail.com
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 3/7] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
Date: Fri, 28 Aug 2026 07:47:00 +0800
Message-Id: <20260827234704.63163-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260827234704.63163-1-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a3neux9y9citzb3fj1hde3dhohobhgdn
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 971C91A0005
X-Rspam-User: 
X-HE-Tag: 1787874444-664863
X-HE-Meta: U2FsdGVkX1+7SRH7omNj72YyanFoHnPjj0WclaYi2t0x7Q2KZUHagujsjVaYg6obkSnmMYPZ31N65W/vTFoFBjWjCJFvrM576Mqgdeuk9yATQTehk2ZLGo8SYD8pFJPeOCf48uPpyEg1By5UEVOT/LC961TM6LNL91joXDnTMkQBFMDuWZG5SxxDOSufd+S0OAp/zO/EC0Zgi32IeKMXK2d130YyK3f6WFKPOUXcQZS6fKr4AmvnHgoODX1rR+20gunQ8eiIbxJ/DxN8QQZ+TvLai5v/GGyYEeTLUb55OIw/PPD0DUFEyjPbrgeQTtnBAy9lhJQznx0acIdW36cT7hFeBr3F179o9L1cIcVy4UfWzZDF+PZBaz5WZVWmmbW0Iqkla/uOzYhD5U5W9YLzl8uWDO2lCMafhj53STK3ZJQVAjo3Reb4CtN48bjxWdIzPM0jMyRiYtkyk6Ur35oajot48MQxYei2SnaCndMcPNAP/7+n950pPruVRMmyfROvrfbS3uIiQ5X/HR1FfAZGrrr2+TaooDPI0lPDig2e4eEt1HmITD1D6CnOJikvpS53l2rL2h/mgspmdHAVOJYLOHiWCO+/A5kmh/wd9qP6mlcGIcxtQcYkAz7+MsK4G8B0qzW99Yj7zCWw5L7DTrXBK6M8D3//EQO2OOT80PTvr/n67tBu9yeVw4H49OpPplYQ+Oq7yTSewdvwKWMnn0srx0bfVy/d9vZjhU12krp9pZhDAWQNBz5YH8HODWNre8OkbdKAOGQFKxaiFE7vzNyglTmAX3BShsqaklPOcNsM7YSlyo0Ims7sxA8NSAbvhdQuh7as3VpPMbG++NMV29kqall+teLQzoey29c359BlD/QzaFntePzxK20x5GCWFeCx+W816AeRR/GWZvA8h1frPpsaSpJ0XLyQMN3pB1hrNMRXUCNPj5RUBq5TVIXGULG7IjshUcGKFPwuq6CB6LR
 nDuT6fRB
 I8/UX+1QzTtcxF4gd/PN85araAsQejx1A+DCER+U2ScrEHvT+cO87DqAMx/dPB0JAdl++/xGGkLIMJM6ghYJdY1S46J8fUgNjeW2qX8FbL/2bVtygP2YhQfls0MDRZ+nzxLeaEW8/ClDyLGFACufvjK36wJ51FSf2xTOc4BmVH7woE8BeVisBf5vmBojmSv1ljp37sDSa/Od9bGYvfxSy/2JtMMfUBfyLqSR36UxAMaZVBWK8Gzuk2fXEFKGiYdUs9cvi1pWMBYM4W4sTDdsu1/ghiIZkgnBk3xyqDXfn8FPRuEssjG/2VKVXEm79RDSscfJq4EHMLm2ITCEdKPgS+vDZUaXVq3P5FL7qUEvTmQGK4iXIUyu385Iy9vizNyxGrbs0/htu5gxkN/rRGP9ZH0IpEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During aging, a folio's generation may already have been updated by
folio_update_gen(), even though it has not yet been moved to the
corresponding generation list. Such folios are hotter than those
already in that generation.

It makes sense for inc_min_seq() to increment the generation of
folios that were never promoted during aging and move them to the
tail of the new oldest generation. However, folios that were already
promoted should instead be moved to the head of their updated
generation, just as sort_folio() does in scan_folios().

Otherwise, promoted folios could end up behind folios that were
never promoted, effectively inverting their hot/cold ordering.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 07c22d51debd..b10d1703d907 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3949,9 +3949,12 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
-			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
-			if (gen_increased)
+			if (gen_increased) {
 				delta += nr_pages;
+				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+			} else {
+				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+			}
 			/* don't count the workingset being lazily promoted */
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
-- 
2.34.1


