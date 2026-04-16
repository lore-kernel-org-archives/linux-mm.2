Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF30F433E2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D41F6B0005; Thu, 16 Apr 2026 01:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982566B0089; Thu, 16 Apr 2026 01:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870DD6B008A; Thu, 16 Apr 2026 01:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 718436B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:28:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC8948C39B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:28:00 +0000 (UTC)
X-FDA: 84663287520.13.CE047A0
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id F2BC640004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:27:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UKVBvJdm;
	spf=pass (imf12.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776317279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p72YAJlXun4KRmB4NWfj7l+RbQybeUrM/jVB+1XMQZI=;
	b=OsJK26dyyMy+gJSTWTev8vcUzkiOyxlq4p1LSWYZwojtppU4bcYbAv/PVE2CeBj+2JnZMm
	iGUs8NiPV0hTg5qPgm+A03OogIC/PEG74DY66jQxFcB2OxSKk38MPHkY1M/Y9lB5RppSpA
	F063TXR5hbepTsEUL7ebssvQbzGug1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776317279; a=rsa-sha256;
	cv=none;
	b=qG8PXzYyzUKLH0flDgG7JyS3i1Ef3UeE010xBcCpDtriJ7Vg6Cv9yHH6cxPaxi8RSwm4DV
	hzixsYeRWS3w8n1WpBtNFvUO61hVIAmeEUWgvAHE+zuFI39kOL4+OhoszqKT9gxshW1sV3
	F6uQIxtdxcN/UN4gEuYDsBM3w5D9cPo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UKVBvJdm;
	spf=pass (imf12.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a8fba3f769so34585285ad.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776317278; x=1776922078; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p72YAJlXun4KRmB4NWfj7l+RbQybeUrM/jVB+1XMQZI=;
        b=UKVBvJdmzHFKClppC9QX6NZgfxFK4PX7CnY5SjYyv1aYd9zdJ90bi4ZZB+b0HzCNLV
         +g1Cb622oGVAiYRTMNiYX3HHhMPmRm5kw7x0HLVyQgJF2GVNRvVohrWwEnNEDpn5SHer
         EajqlQzP4P8Ar4cR2TvwcGWRxA2gMIldUeVgQ4PekNg7989dC4sxpDOarShQWrrA1RNw
         XoW52Ydm/sdg9g9NI23SArifMrCOyrJodFdCHGM2zF31VPt7x+OGaaaiww5WchMXG1AC
         vuPAdL79gPfoiQj6f6Wrg6Bv2AGxKnC6fFeRZoWzESLTWGlUh4wG2jYTT1R9xpqKnb5t
         wp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776317278; x=1776922078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p72YAJlXun4KRmB4NWfj7l+RbQybeUrM/jVB+1XMQZI=;
        b=kkKy46HZK8drgu+Plf4524Ho1TxQ2GxMb7JH2TU+oSqPoSck2uKPR8MgB7Xrq7YJVG
         ieTzI7ROXqg6TsOpo/nActUQAGms7fBxoZhKgaKKf7DEqB48GGJgoctcusTlI3mPPlow
         R9iPj1/HJ+AozWxJR5ASFUl9/TDTWEfrfeYqI3tE2tyEN+pUjwYXA1LuyEDDd6qc18qE
         nmvic48As04Lb8fYCd4usrQ00OloCLrczFRm4EFzld2dsr+3OMBz0Vg3Aysv0eIeiT7W
         VZJUYY4RqqtRcQRcELzPVZnwhXQegP0mx4Q+s172zeuanCQ6fK/OdFUJrfJwaaIkVQIb
         Cg8w==
X-Gm-Message-State: AOJu0Yx6++3Feoknr6+KUBfg1SoX9SeGj4vqt8UcZv1cABdkwpPjd/cg
	Tgsur3WAKGPOmsyYjWFm8rzs0vklJoDplejoYWimktBUpTUzGkCdOgyn
X-Gm-Gg: AeBDiesOgpqgRoB+vRvuYBimbPr8HNkfr8YUmNqpZ/4bjq1dsyy5WNM0eszThKkZNn+
	YhyCnnwYyyO2iiZx1S9P2+eqjvdKN40ZzhKeTxFSSBB9VNG8Fv7WEQTpxQJiLu4YtN0c9fDNKc6
	Dzek9y2pDuA+v2Q61j1qxWYNdexJy2EeAHcBzWfiUQNb+BE6DjLzwmesXo0mtDf3OC78Km17LpV
	NoaA4oJ8H/KI7j4ibeIn6EqwBgIZRQfDvh7KIwvpuxycJ7htDktOIimJWJB/joBxDJGVczpzdfo
	VuCnWBq9wwouAPKoBSH9O51/R/NzatHhLPthtqfmU5AFtmtthFLkYM4R+KTzHXCvnCuEzjN+FgY
	PB4Z4bjKDnBPlBo6TqPvG79RDk7nvrV7+l9+E5H5JgrQVzaL89m2QgqZprJNHHx9Ym4uVr/8ZbA
	fol0KEubPJYqj+1/0/90mqM2A7uKBUkURx
X-Received: by 2002:a17:903:3c4b:b0:2ae:ac0c:5a2a with SMTP id d9443c01a7336-2b2d59433c5mr255006405ad.6.1776317277602;
        Wed, 15 Apr 2026 22:27:57 -0700 (PDT)
Received: from xiao.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4780efa5bsm42811275ad.10.2026.04.15.22.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 22:27:56 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donet.tom@gmail.com,
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: [PATCH v2] mm/page_alloc: fix spaces used for indentation instead of tabs
Date: Thu, 16 Apr 2026 13:27:52 +0800
Message-Id: <20260416052752.713821-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260416021945.682234-1-gxxa03070307@gmail.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 179y63xn1m6wfc3tqc6pkgcrdsgtwb1e
X-Rspam-User: 
X-Rspamd-Queue-Id: F2BC640004
X-Rspamd-Server: rspam05
X-HE-Tag: 1776317278-888498
X-HE-Meta: U2FsdGVkX1/Xtk649PwHgR7uMzVbx0Y5/3h7kv51neRusy1PjVczSv5htnL3N5mpjTcj/OuugrVzOn752UndpkVVk9Kq7jISdJ13hwr70UtLCr4DujWa7apP9x3r9E5WqbCse3VAb4qJWAW6Zw74kr11tZ+66ghlDwzakPdRUDtPnqG2q6FoPLzP14VNS/H6ZZ6Qgox1gHfhnAld/HPIf7OcFMXOlRBHcyyV0nUzhndWoR0Hz5ETObiTRe9DKm+3EVP5ujQz0OXGdl8nlVCgFqShF++D2DSiO9Ik/zSw+vIlZkqrxJcsDXh9JMYDIjdAsv5yVLkpcJtN84LEloXIPYbrvzStc28rcmtrfnonJRF4/Q8Cwx6/D5UvRN2Dhtr2dRCwZZslTjQNyZzxurIw5TPnTwveFSog6J7tQ0DMfvP5KFS+K69xwQMREI3dI7jN4PPuyWFANZYpRc4bpa8b2MXl7krkykftPWbs4fd1NW2g7CeHKEiFAQvZecQZsIJa5zNwQuLzi/EDD6rWZH6twnPy4UZnX4l70nxZtYAQf5wpKzsIdaled9Ol19I3RylSMON+moxDG3dJ4Vd4+ktQ7qVsqhKXL7vJMY0teJiRtUrdtwAA2Q1p+olmvhjKfuBoUHjznmCzkBqNlLzNu5egBMtfd0lkHHUnVccCkOItptnJR9t2xkeKJlVSf/VgR94z2MVY3rgBZ8uCE2t+tLxIOplDbvNf5UHP/yh+tT96+XUg3sL4c9vs3QTwji9bL+l/Ss4hshl/EGIMdaNECZIbSodyBJdBo3Ae5fPI/6XRUI77+y7EZ+sQQaq4LiTxCnlGbvrW8hhYfYDid6C1H5OYYiyeG6clZpSl9Z3bjhaEWVaW1GNC8g/pb7hGjS0nR/RcnWgaMdkC7UG+hwPpQ0HoC05Q0E4EPbeOzyOdzKJUKHb1qtDqP/gjcfNpcAaMYF7uBstWZjdQd8wZxLmC3mt
 b1/J6YKH
 MkoVtxjHZsB3GcFhLBV2MZRCH6czM3UtKvR3gLPngTGb6fRlsc0CPPjcT6SbgfJkpRFecZL3jmUtMaf0LzA8te6Nyp998yw+WhzTtKpoC4mOXQGDE4bGcACC5yqXvas/2QJl8+2mSP28tahKQVkrPQOsDBy0bkt9EFnf266O7wSi3aRDZHBf8GQpEBWB20oCjp0Rggct6He4zFJ/Apmby0t5QxdAMmbMW9EaKlcifQBVI9KrOr26q1mrA8sP11jumSzkoihtZ0uryh+37DRPVgE80Hg/K7TQg1kEe8QuPsvLjsgMcgioz+jRFTb3AE/ZQ1g0XG0hx15wJNV6l9HI8G9GgHNNZtzavPSDsQNdXZKSbHZHZg/bY+RYPnBBuNF71yHBT+GMYFKLIB+fizsJ1dLll7vKqTmVW25SrI+rKrzKb0KXD1oPkwEUdHyNWvk5gOWmqu4+Vwbpclos43xb56hoc46pqgXgJCafDjKzn8mQOgzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xiang Gao <gaoxiang17@xiaomi.com>

checkpatch.pl reports two indentation errors in page_alloc.c where
spaces are used instead of tabs:

  ERROR: code indent should use tabs where possible
  #887: FILE: mm/page_alloc.c:887:
  +        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,$

  ERROR: code indent should use tabs where possible
  #6626: FILE: mm/page_alloc.c:6626:
  +						         sysctl_min_unmapped_ratio) / 100;$

In __del_page_from_free_list(), the VM_WARN_ONCE at line 887 uses 8
spaces for indentation instead of a tab. The identical VM_WARN_ONCE
calls in __add_to_free_list() and move_to_free_list() both correctly
use a tab.

In setup_min_unmapped_ratio(), the continuation line at 6626 uses 6
tabs + 9 spaces for alignment. Replace the excess spaces with 6 tabs
+ 1 space to correctly align with the opening parenthesis on the
previous line.

Signed-off-by: Xiang Gao <gaoxiang17@xiaomi.com>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..752673a9b43c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -884,7 +884,7 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 {
 	int nr_pages = 1 << order;
 
-        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
@@ -6623,7 +6623,7 @@ static void setup_min_unmapped_ratio(void)
 
 	for_each_zone(zone)
 		zone->zone_pgdat->min_unmapped_pages += (zone_managed_pages(zone) *
-						         sysctl_min_unmapped_ratio) / 100;
+						 sysctl_min_unmapped_ratio) / 100;
 }
 
 
-- 
2.34.1


