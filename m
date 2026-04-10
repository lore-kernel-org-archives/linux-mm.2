Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5641F459E5
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2FD6B0093; Fri, 10 Apr 2026 17:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726786B0095; Fri, 10 Apr 2026 17:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DA06B0096; Fri, 10 Apr 2026 17:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 467216B0093
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:07:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0360613ABE5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:51 +0000 (UTC)
X-FDA: 84643883184.18.5EC4C1D
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2183B1C0008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ogkVqrz9;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855270; a=rsa-sha256;
	cv=none;
	b=VtjO/PxpXV6k/wZow89G8SYSgbOtENbPc8JANtyETgvvXpHbU0epmKdDXHUjVE49qk8zAw
	IO4Quvww1rNUEkTP2lDgwpkG2OE7jLc8KZQWl419Wr6ObsOIUCyL3I/H3tg+B7ncjAmk5U
	qFnKmFrYqY4EgANx6n1WSTbIGlAUqKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqJC8Gmg2c8f/XCk9+e6dccXNeaFU07UyyA9/we+nYU=;
	b=SdZUxue9E3CtzdIe4omOujfaDu7x2CLF8t7fsG5aG4DcKDuCkoOGdAybynHsHFSGo4nPxB
	ghs+8NVeWkjxBe4mX82ehFMkxrs1QXWBw0x1ADyWIy60UwBL+L/dKrpqqheqV1xiA3QJGX
	FEim+UV5ueWol5clhDZT/zvDSsPUsOA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ogkVqrz9;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7dbcf927395so1536960a34.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775855269; x=1776460069; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZqJC8Gmg2c8f/XCk9+e6dccXNeaFU07UyyA9/we+nYU=;
        b=ogkVqrz9+XvyHGzrkufDX1Aj7laEBUkweMvBbmaCH+RCyPQtpEEiVJsCarADxglyms
         vfjJTtz1Qfj35xBWUQuIV/LBckPB0GUffSLva8CtUQD/bxKBIovqPtudQJXFNzqSDXg2
         sqjpPQjNTDljFLBR1D0HiFXAQaXp86p7HuFpx088imAAle094wx1dXhqJNWtYvnHLA/0
         pz/MF5rccKSdq0S7r9QHMFQTcvjLd9mXHoBxacT0h+LnA8HM5pUYUmXrXceJtaV0E46A
         cfnBk1rMGnM0X+JORbZ9zHSjQAhpsloEKqrnvokAZNi4fKUOZYKfWXqtIoKZDkZtmZGp
         mU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855269; x=1776460069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZqJC8Gmg2c8f/XCk9+e6dccXNeaFU07UyyA9/we+nYU=;
        b=A/PsXZB3bj9Bs0+DjypHcT1PZ+Oj5aqE8InI+VbsHVqq4hRVnp25byvKu555KnksgA
         6AJQqa8KPx2CDlesfywwA2Eh5tGPOJjPlj4kp7xulGvnU1VhGimTzCHytQCLEYpoWYhr
         amx9jSOoDQqDLYpnts7juyEWhSyoGlfCvxq0zjRhhib0ZIGTzoKWkj8uOM98frIEaJD8
         RYFu3X2vQUeHGMugicc3NIevNF9mBAeaYHBHKiddE8vs6czma1rbWgbL9fitvjTbw6/d
         ndIcM5GPZ+SpDpmgpt569/YzDwYVL0XSiA/2Irw5ApKaiMl08DGmSMMFzKcUTNtU+rIy
         mu1A==
X-Forwarded-Encrypted: i=1; AJvYcCXuuq8DCJjz7LnbMwEF28t7DbkdQzT97u2plCIJCbHjRasTufw23/dOyDpbwesKyi3JvYAuWXmN5g==@kvack.org
X-Gm-Message-State: AOJu0Yz6jmcoiRDTR+aD5kIzHjK39qops1JaTgDOE67tf4V5T0qo24C5
	5OmUN2Et/0JUEpvfiaKvYMIGNsHayNRuw2K6AKt0fEw4X+MkQVnD/+Dl
X-Gm-Gg: AeBDiethtfA2OUZjc1QqLIz3WVJnMVNyslvRV27ia+R9DccmaLEv2+/uy+CeZ1O1fBQ
	MY3/fH9B1d4LdwuKFhnD0L5l3LIxvfdlXh6l/VsabkhAaApt4f73OhP67+Ipthf2hCQ2RchXnJk
	ATckM6NTys+a3L73NlxhPf80AzmFL+gP9QeR7rJx7vgPrrNvkWYGO/YMx6jAb504zpR1Rcc42IQ
	nkHzIwMrjoJQ5kuuF2NbBNtCv1eT9pd+BGL4tvfGm8yfwbo4NhczS30jg5wv5miqYHV+EUDEpu9
	qQLnAPZh7Wyd1eeNGcJKpPZ17/RgBzbURaNPZIzcDDt3SSFKzG6OUc449dpXkpnTITfEIyD/FqW
	3wVgv/TUaCnl5rYrWLWrG8T7wX4849sNpfyZzJZPCi+qoF9E+dsGl3cmzjEFMBFUJWSt37IjxIu
	BT/Z6wXDkZ+22/xZM2Zc1z3g==
X-Received: by 2002:a05:6830:3747:b0:7dc:18e:b5b2 with SMTP id 46e09a7af769-7dc27cb91acmr3191143a34.9.1775855269238;
        Fri, 10 Apr 2026 14:07:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc269402b9sm2561044a34.20.2026.04.10.14.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:07:48 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 3/8 RFC] mm/page_counter: use page_counter_stock in page_counter_uncharge
Date: Fri, 10 Apr 2026 14:06:57 -0700
Message-ID: <20260410210742.550489-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
References: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2183B1C0008
X-Stat-Signature: 1xwkm85gey4gxuskpnojqh6znesb5bmg
X-HE-Tag: 1775855269-781123
X-HE-Meta: U2FsdGVkX1+xpvYT0x0FowzQfK/JM3dcfbts5tGbcAK0dhKh81jg+DSfMkDt93yiGmj+JoPhkKuUhCkTXXYZvaQrbdZ6bkviQPNDxqNkuek8YpUqc1KtVu9/ErP8T2WTspAfVOQ+6FGUMC4LsiqilzD+p8QG4cPfvYPuA2Ch+kuI7YW3M80nXQT7Xb2K2nUeEa+VHsmxkgLiNTaDOeevki6WWDwPwG2g7YZtLb8FF07ePA9cB290Hqj8D5+ZoY71k1yaJ7jFbwJKWOzTz+GluopDCWFH42+c9H+IPqTJF4fG7/quYTG7AbkLV34r6ieJH4ptI/WE9MdCtGtyZ0xdWLhBIyu84CJYswZ0h3MsvYIXFlNBg9ARi3HqaH8OJfBCEQ/yIINs658ACR7KrMmJ1uAsWTnIDOUF+6gGmP4vIrbpVrtQtYtPwtNdU8sG4+qxwnfaFUD1AN8eVZuex4y37zhLU/gCzK6bxdGc2ItPYfLchOqe4D+7JzAPenwEVoBzheM1opu30ZkLwWGXZkaZXgy/GWXQ2sMMK9h+JgaZrUbJjYq0uMKHSE8WNmGtb8FQ/iga0o6PSdVMSZ27n18FMwB/UufNgxLYjkq9xoXDh5NFeihdZOzbjBpClyOh6qMIpteb3GEx/Y6QHQ9+gYd51gy0Ft4mk6XzwMXnlteoYZs6ePGe3bfdyx35/G7iq+QghMflA+U0uCKoGuTvhos3cLe/JVsfs2oKTKFvXd9jgYziJCgtX576WmoZpmfezJlpmsl5zNnEzagt7Lid15EPoObC1Ij8P07vRFWq17cyLBT57EkSUB4ELB377nylneYx29fimEN2qGBpmP8PEZdDK+a6spVulVmMd3hcCfVSEitwUksyLcMzTEUA7BGM49VxoEU8KJrrlvWDCWUxr2jsN/S9l9veJXPhv2gzFAWVO4Fd0qmg/aJfPcIwN+4X129DKP/Rq1/RsakB/QGS9aG
 Ra2Yck51
 /AS7JoUE4Y19fMW/36ZY7XeNjQOVu6REEoIH8+RSnOGKub9ckW4NDZ6G6o9JMqyZRJ5EZl9H5sEhUzQ9b7dWOJBinesyQqnorx8zeT1d44oEzC9EpiHrjlWqXcay3hwxyTnA02mlG43k5Zqof/4VURoRSEjlx61R75NbBfO0WTULVp0S5qBxbIP6t490r2o1z3bfbepkUbgrRph2BZxiROEkP9/1l6mrToJ6zgApkWFGK5qhCPGi96D5dhUe/v9NhpDgMS5GgcqZFwjW4qDR9t7jXGAd5D0NG3QaGcQeiJETvdQp5s/LMl39xVTR/7DyocMGSuuBAhx4HHUe6m1xt823DGVrwA95g5eTooVO3qlyWwIqtrqOy6VZl+tydJPy/Zqmyz9U9FQW/p+YuFd6CNAS2O0EB9ERx1w53t0cVsAkgnf8m8cdvZdWQKOB8wdodkBkUPVsUpeftRwDtox1p7Q9+llJqYWL8xZFh72YYwIYV5lieFbTlJAgdz1hGm1/uUVJQAJlyid3RaBY5FeLOQkZhB1gwuQxyh0jZ25s2MlDb10+w0lk8w3qkRHe3kfsnPrQmcr690krq6rjarMHA77vDct8CNybqi8wN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make page_counter_uncharge() stock-aware. We preserve the same semantics
as the existing stock handling logic in try_charge_memcg:

1. Instead of immediately walking the page_counter hierarchy, see if
   depositing the charge to the stock puts it over the batch limit.
   If not, deposit the charge and return immediately.
2. If we put the stock over the batch limit, walk up the page_counter
   hierarchy and uncharge the excess.

Extract the repeated work of hierarchically cancelling page_counter
charges into a helper function as well.

As of this patch, the page_counter_stock is unused, as it has not been
enabled on any memcg yet. No functional changes intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_counter.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 7a921872079b8..7be214034bfad 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -207,6 +207,15 @@ bool page_counter_try_charge(struct page_counter *counter,
 	return false;
 }
 
+static void page_counter_cancel_hierarchy(struct page_counter *counter,
+					  unsigned long nr_pages)
+{
+	struct page_counter *c;
+
+	for (c = counter; c; c = c->parent)
+		page_counter_cancel(c, nr_pages);
+}
+
 /**
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
@@ -214,10 +223,23 @@ bool page_counter_try_charge(struct page_counter *counter,
  */
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
 {
-	struct page_counter *c;
+	unsigned long charge = nr_pages;
 
-	for (c = counter; c; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+	if (counter->stock && local_trylock(&counter->stock->lock)) {
+		struct page_counter_stock *stock = this_cpu_ptr(counter->stock);
+
+		stock->nr_pages += nr_pages;
+		if (stock->nr_pages > counter->batch) {
+			charge = stock->nr_pages - counter->batch;
+			stock->nr_pages = counter->batch;
+			local_unlock(&counter->stock->lock);
+		} else {
+			local_unlock(&counter->stock->lock);
+			return;
+		}
+	}
+
+	page_counter_cancel_hierarchy(counter, charge);
 }
 
 /**
@@ -364,12 +386,8 @@ void page_counter_disable_stock(struct page_counter *counter)
 		stock_to_drain += stock->nr_pages;
 	}
 
-	if (stock_to_drain) {
-		struct page_counter *c;
-
-		for (c = counter; c; c = c->parent)
-			page_counter_cancel(c, stock_to_drain);
-	}
+	if (stock_to_drain)
+		page_counter_cancel_hierarchy(counter, stock_to_drain);
 
 	/* This prevents future charges from trying to deposit pages */
 	counter->batch = 0;
-- 
2.52.0


