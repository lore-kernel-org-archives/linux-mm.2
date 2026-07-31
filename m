Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3318C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09CB6B00C0; Fri, 31 Jul 2026 04:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93896B00C1; Fri, 31 Jul 2026 04:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AAD6B00C2; Fri, 31 Jul 2026 04:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FAB66B00C0
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:39:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E60D5A0348
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:03 +0000 (UTC)
X-FDA: 85048421766.25.BA56D5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 76DD840008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QyO6dISV;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785487142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1rnLid9Gk4gz87YPzn7Yuv3VMf7sSMoO6a7K32KAL6A=;
	b=Eh3p107R35ED8Uxq5n16aQJbDON0oVNfCQhlEBFC8LrQD6vvyLtQSHaTj/teqvqtMuuSOZ
	TEKaQpTSBLOza2ZhiX9vDlYLYIc/MHTrVZERZjv0BriQ6z8mu3HFjPodd7YSk5Mfra+RWX
	WLu0VC9tFOnhv9PsgwjiQK6r1uikRFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785487142;
	b=rnburIUWLLuZygLq8MSqB7ZPDY9R99iD9QYQKJmxw4yBSoenHf17OcwSVhDXfKqA2LKkfZ
	P0+3wdsmlrpJ1OGdut6wMnX4JNITgnKbAC8D0nbZGiX8AGu1yYTPRiJEATuyC6qY07ePYV
	tTLoIB925Q3SndLRlhIiLqChzBdw6bc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QyO6dISV;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9FEA600AD;
	Fri, 31 Jul 2026 08:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5E11F000E9;
	Fri, 31 Jul 2026 08:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487141;
	bh=1rnLid9Gk4gz87YPzn7Yuv3VMf7sSMoO6a7K32KAL6A=;
	h=From:To:Cc:Subject:Date;
	b=QyO6dISVOMXLgpuo4gnPGqmPB+luAsl+zm00IV6x4PkXDPemoHgUJPuwZnkr3SUll
	 FijdQrgqa9ucSgiy5ue7d0cH6icMg30LURkqO+LEoKRmeLfP8H0mmlMF/nM3lY3t1q
	 f4jk6MT+hslKYL++sBDrhLe9N1qZjiVM2sZQpl7xc9onpDLrJZwbk83L3KDeZd7M3w
	 JRqWv3vTRmYYeF38QU+jYo/8hS+lHiK15N0KPayKIpecPnjuQrTz0IL6PuqpdiEj1G
	 WZGQszjQ9kcSVujkelMhDP2V45fqSM+jIjYUF9s5X5KOx6mCn7bEEgVcy6Sley5zfh
	 xi6Q3SgLqTMGg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	weixugc@google.com,
	yuanchu@google.com,
	chenridong@xiaomi.com,
	zhangbo56@xiaomi.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 0/6] mm: mglru: fix swappiness behavior
Date: Fri, 31 Jul 2026 16:38:37 +0800
Message-Id: <20260731083843.37811-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hgho5wqrwg1ez4gudd9m7dinok7wm3au
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76DD840008
X-HE-Tag: 1785487142-60331
X-HE-Meta: U2FsdGVkX1+yknG0vE22eoFhWILRdxHiY/inKYzToepoAnAzwPQvrlsVDt4/9Br7B6DXX2yhLWX3rUv2fjA3poBrs8u5Be3JdDpqgerhZV4iIA1bntS3uiRq+UIrqQIbDIzD7uhH8UU16kybp+n0PmS+T8JRdU9QxNWDQYbXzvuA86siB9qMHQv094Nu5sPvcHDglrojNbTgF2tyZy8DYee8vYh3SNbqlBEXfs8pIlfF8/p1kwUDYj/9hI6KEVYnLnXbVX+mKfVbdBqHVbGxLBPaE8p/EUXdikyoeNTrxbpDQaDaY3hTrmrbk61rjZ404/lzIC/cTwvvb+m+qN8f2/Muiaf46yIjRiIHrVf681n5Xo4WOTmnBnGIxM7jCssfW7n7+c8abQcNv772A9VGEedNdTGhW/L0xbpsEogTg9zB5PQYKnBrPpitsXUD+xPvP+4OtwLOuXo4q5Vd5nUCiL2BjGyr3qbwW4k8Y6Ve9YvyqhIeLvpM7XDkAveXdqkxTQNttOrbsX46Tx+ZeTGJunHemJIEedzHytSB33VOlk3ZBDjB0D4IOJlHPw8pMJsaQJiaVEIG+Jpr/5qry/+P6DFXLdlUTpaOy1vWgSkiKBIhd31ZOtdXnk5WgJO626aLRDfxhaCVtMjpaBYfQAn3ruhPh0AZxAI4mEKXC33rz3ZbLXEYpcixFCiTEnMRPCVAetwrg2b0/xVotVERlQhmMCV+EtGjTPSXPiCaT6mteLJsFMFsvIvOv01MnQs4gthfanuQLOHkBhvFIdn5a6+GPTMqr00h2U3NyhfdrD8ZVTeLACv0AQvDvoAvBRdVH4Km0FQnaw39LHmIpMBNSOXPkyW9VkSbUXRiY0NG5NkXiFWjSv+1vPlNPzIB9SEkP2Yhga7Evr7/wwfUUkrf5gnfT12pMwX6/pCPpJJiwgiFEhR69DHU+CmCQsExLcLudAgkP9AudwDRTKCESZKlHA6
 zhlgeVN6
 eYptcMyDcD0HRJz88Lcvxr29sfXN7m3t52BaW0m0L2mk3Y41pFtdoRbCFmM/cddc7yZ5kfANrlJG6I6rrC1rnpfLUdjY4ApeaeON3Q3L0ANV0fh1rLHRsuX9Cns5XEXc+FO5NSXvb4B2vA4oPSifIzEidOZNvoX84jSYaXjRpIpKSVvnhzw4SnG8KcVbWkexhVoJOFg/BaJAqmkwdK4J3ENEbz3SE+KqTVw2pNXSkLmY+UE9CMPGTGx81+ZzaO98gtm2XBpp5qfDwz7wEbE26F4O0EbfwxQsczECCzZqxaR6amv19pi8JSeqIWGuPDgckCc9Mb262OkvQJ81if7eyrL9zgrJQRCCZO8MNOS6t+GBgLHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RFC v3:
 - Added Ridong's patch of improving isolate_folios() readability;
 - for lru_gen_imbalanced(), apply some suggestions from Zicheng
   and Kairui, considering lruvec size and use macro;
 - drop "mm: mglru: only fall back when reclaim is running at high
   priority"
 - mitigate aging for balanced swappiess value(near middle 100)
   as swappiness bias is less a concern for them; but slightly
   increased aging overhead might not be good.
 *  RFC v2 link:
   https://lore.kernel.org/linux-mm/20260726122123.7614-1-baohua@kernel.org/

RFC v2:
 - Quickly address a few issues raised in the Sashiko comments so
   reviewers can ignore v1 and review a cleaner version instead.
   https://sashiko.dev/#/patchset/20260726012946.18684-1-baohua@kernel.org
   Thanks, Sashiko!

The active/inactive LRU respects swappiness well. Anonymous page
scanning and reclamation increase roughly linearly with
swappiness, while file page scanning and reclamation decrease
accordingly.
For example, when swappiness reaches 200, both pgsteal_file and
pgscan_file drop to zero while building the kernel in a 1 GB
memcg. In contrast, MGLRU shows almost no change across different
swappiness values.

                   pgsteal_file

Swappiness    LRU         MGLRU
--------------------------------
1             10567455      763612
36              990706      480205
71              688170      415848
106             446294      386164
141             286307      359196
176             201733      351686
200                  0      330093


                   pgsteal_anon

Swappiness    LRU         MGLRU
--------------------------------
1              4410548     2726362
36             2465268     2762859
71             2677908     2885124
106            2737227     2841796
141            2984276     3035015
176            3381338     2938302
200           13116359     3113499


                   pgscan_file

Swappiness    LRU         MGLRU
--------------------------------
1             17997223      923094
36             1325674      539571
71              852345      464222
106             538207      464477
141             357253      412277
176             217536      399446
200                  0      375902


                   pgscan_anon

Swappiness    LRU         MGLRU
--------------------------------
1             31639423     5987136
36            23441521     5753224
71            26067110     6101780
106           25619448     5782919
141           26842088     6234264
176           29200021     5980292
200           62193924     6413125

This patchset respects the type selected by positive_ctrl_err(),
which uses swappiness as its gain. It does so by running aging when
the preferred type has few or no reclaimable folios, allowing more
folios of that type to become reclaimable.

For balanced swappiness values near the middle (for example,
60~140), the swappiness bias is less of a concern. We still avoid
aggressive aging and allow fallback to reduce any potential aging
overhead.

In other words, this patch strengthens reclaim type preference
for extreme swappiness values while preserving the existing
MGLRU behavior for balanced swappiness values.

With this patchset, swappiness starts to behave similarly to the
active/inactive LRU.

                         pgsteal_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             10567455      763612        1938714
36              990706      480205         427934
71              688170      415848         373450
106             446294      386164         368160
141             286307      359196         334467
176             201733      351686         293716
200                  0      330093             25


                         pgsteal_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1              4410548     2726362        3284272
36             2465268     2762859        3315112
71             2677908     2885124        2942357
106            2737227     2841796        2941288
141            2984276     3035015        3345933
176            3381338     2938302        3409531
200           13116359     3113499       14414151


                         pgscan_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             17997223      923094        2612649
36             1325674      539571         514506
71              852345      464222         423155
106             538207      464477         436573
141             357253      412277         389644
176             217536      399446         333973
200                  0      375902             25


                         pgscan_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             31639423     5987136        6191482
36            23441521     5753224        6097925
71            26067110     6101780        6157755
106           25619448     5782919        6203221
141           26842088     6234264        6599502
176           29200021     5980292        6783074
200           62193924     6413125       22814377

Barry Song (Xiaomi) (4):
  mm: mglru: prevent min_seq[type] from pointing to an empty generation
  mm: mglru: let scan_folios() scan both reclaimable generations
  mm: mglru: improve scan_folios() exhaustion detection
  mm: mglru: run aging if the preferred type has no folios in
    reclaimable gens

Ridong Chen (1):
  mm/mglru: improve readability of isolate_folios()

lyugaofei (1):
  mm: mglru: run aging when pages are severely imbalanced across gens

 include/linux/mmzone.h |   6 +-
 mm/vmscan.c            | 145 +++++++++++++++++++++++++++++++----------
 2 files changed, 112 insertions(+), 39 deletions(-)

-- 
2.34.1


