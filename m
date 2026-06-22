Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9489ECDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 02:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5786B0088; Sun, 21 Jun 2026 22:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4757D6B008A; Sun, 21 Jun 2026 22:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33FA66B008C; Sun, 21 Jun 2026 22:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08A976B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 22:37:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E465165BB3
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 02:37:51 +0000 (UTC)
X-FDA: 84905988342.06.97D88D2
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id B4AE21C0002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 02:37:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TvQpDImR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782095869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=3aBWFOQIWzQcebQpmQwfzu4nP5Zuxd9NagHRXZa8pr4=;
	b=knNgp7VcpUMkqRh4noVBxuEAYce7L2snyl3zYvgYwoVoqZs0xj+K5eALK+JvPcbpjDePCI
	enC2xoPy2/ebtA+FfbPOFGKwhlZFoxdxCTUpRy41ONQI6qAE4WbU1GcfFnHtPqMoFxRffK
	wvJA6VL83kbwUMIPDJ5kpDwvhOQpc64=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TvQpDImR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782095869;
	b=h22tzTWhvzpaArBq9hy85EoNIWeN/cQNP4CKx2f4g1fKrIDi/FMq5PeTA2XQnZVKNlhfPv
	M05n5zsqGO6pmy+iJ50zk057JwgsBJPHLqNZi4Z9uo40MNI2MRjocBVj9IoOS56ZlRqvs1
	h6Euc0lIaxwnmM2Mk4bEkoyPj1gtnO8=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c0c15bd6b8fso203181466b.0
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 19:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782095868; x=1782700668; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aBWFOQIWzQcebQpmQwfzu4nP5Zuxd9NagHRXZa8pr4=;
        b=TvQpDImRCWHTebGcZ3XPzriXEmTEZFGOuufS2Bbdc7akz7rf5Ps0z+/RKojUhXpArl
         gyxE7/azGrhjT+Ti6rVvgDUA+Roc967/A5m6VFh7m8oQJrpUGwUQQeOc/16QE+MD8M+w
         kwUlCoWtX7Qw7NEOfBifsIEkVIwAvBqtgEvoq4OsjLlrl11t/j/q8XvSzvAuksrmXeBK
         H/IPwHWo/vCc/viI2UfbORy6jz3E3l6b7xIbgMhYTzuX0rjc5X+DuS/DzEbqPvHD+Y5U
         Zvpcl/Dj4TChxPbQYbhmsb/te59GE5tJqErxYml7vsuzlqA2z4Ym02zEYZ+IWJByOzbZ
         i+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782095868; x=1782700668;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3aBWFOQIWzQcebQpmQwfzu4nP5Zuxd9NagHRXZa8pr4=;
        b=TpmCXpzWx8WksJpm5g7pGwMwF7nCrahDa+oqeHEokoG0lfN+OeLPTQs442PYNhg1Dw
         rG+WrIem/8D+T5ZzzkIDweX93MUZmjPIU10ZcQjfWQQxYBGSiKTvvlbgiKSvvwks1eWY
         w0TuMEMu+cZ4iZGftoTbASQ7KgP8GvVI9uAP28J0Pw/xAPUfrcolnEFtrfN5nDxxS2VX
         DDvzXMG8KeMgsKnKlATdQMCDFCL6Xp7nuFz5uZyMqMOwMvZ1PaZXjxfXDLBILHPDX9do
         gvZB5K3JPzrF9xf3dQ1TkxfA7i9a+fVO3/OlAo09pvzDDSjKx4ds8yT77UfxL/wRPZ2L
         vsng==
X-Gm-Message-State: AOJu0Yz5rjItTNA+XNpVwxfkP5ATK39vC3G4wuCetBmLgtnSnuTT8FOA
	neJ+o0CCTdK3BGMtOJ7XBLWU0adrhwQJKW9kxFEaCtJEnmG2DSmsDQTq
X-Gm-Gg: AfdE7clT84Y0ryfok0Wg62E8olTunsk2Xc0RCl/z/sDWOBGns/LZ1zGdMU2w1AvGLnf
	NLG6mZDyx26647uNO4MThrkunm+/81Yh6HDhTMDBmKL098OuKadVdkDaMvjMZektK3y+KwOo2Fk
	BmAwTNFA14SVJbgGaUoGXXYqsDzv39ww50p1iRmJnevyFjEpVztgwR6+HUyxEJuTqGPIY+/mCZV
	g7GujuMFvWnsmTQuecTCer1JoFSUAofSUlCjm73KfXZC5ZzrJoGrKb4OylXP8eqt9+sq/WCtcul
	vnKuwvBO8mQZbO/TXh6CcBtemc5qG0MuQtfil66Nbs3Wdbo6KjC6votr0pVyAe4gIeojYCQsIbZ
	DiM7rOQSyVh/BXI1zVGycdRpltc64MtCoMRMVMkgHR6SgM9Da63OnSOtppU35ySslUTBg5/tc/h
	LmJSZw6sOKx9U=
X-Received: by 2002:a17:907:971e:b0:c08:713e:d8b2 with SMTP id a640c23a62f3a-c097c4b516emr635623666b.25.1782095867778;
        Sun, 21 Jun 2026 19:37:47 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e998ebfsm275902366b.16.2026.06.21.19.37.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 21 Jun 2026 19:37:46 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	izumi.taku@jp.fujitsu.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>
Subject: [PATCH] mm/mm_init: fix incorrect node_spanned_pages
Date: Mon, 22 Jun 2026 02:24:03 +0000
Message-Id: <20260622022403.16375-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Stat-Signature: 7h8nb64qkwzgfc1ctyxwgcgw5xofbbw1
X-Rspamd-Queue-Id: B4AE21C0002
X-Rspamd-Server: rspam11
X-HE-Tag: 1782095869-948177
X-HE-Meta: U2FsdGVkX19UY2bbUD8yM369C1KiEw6halC6eqwJoShjbEOWlGcSzS1niLJy1zpfNlHVRF8DmDYohi54shdTGbQm0hH7594Bm5bx9wVtSQQJie2jslC0WzcOflwP6P08A0GslrBw5N9MhIpOm6Kf0LEvu36ZS1sb6/xtlmTCeNrkQWrpZ1BhWX43GVd9jXvc5XztkiY60/OE5eVXLt7AP91k0tEUOsAippXkzEDGFAwgES3jCd6KCe+7U+hhe2UyDhwYJLNrcZsjScLE30fAz67t+Hidyo8eWcup5ZBeJZpVyefRFUV+xVEDfK/82D1lTXHEUQuZhTkk8SJq2sLgm23EUQsyv4h6hHfOBr6gmdCoarlDRNg1cFo89jIw4IPZ6eK3SeZGstQUZpQMqUMhnbTyMCyPz53ozjLP7o6IAiRh2B35EyRXx4Eb/45KC5LLoUloSU5RP1eyMl/AujCk9Cy2akHX2slOm6VQS9Q1VC7BaCLNL7eeRbir0Kw1cLdvdOHhJqilDsxlFknvA35hAhyqdJIqyCtDClLz0114JqdWNX40KIU7IRqs2VyzprKnpo79628r4Bg2BljAFie+gHTESPVRgeiylbNdtRHwY1dGseiXjshmNwUuDmqRbSaNTpDFvbH9wrjQW/lZekU/KCBoM3y+g3aTfHVKtsKmE7aCEugsU7RTEuXh8ClRzrVgbbkHSIFt/5rovVw4FxutxO453c8fDLdLUAcQlxfaTiC18JNE+jJya4bXUz/EWB2P9zRMMZN0da2CHW1wy0h19CMHOfg2yOlbT75n9rfxigeuSokZZvrMiX0P68IZK4EkBZv3kdU++jsDl8rHEFTzOm2eGavfPcgM9sgyVZK+GJQMIIl3wWb5olu1/pfjUmfSUvqI340DD+D0sStWSuSyYM9IkWG7lQ0zWErSkomEGPHGmqETXC/vNICU56RK59hCCmUuusfl7SPOEw0cXaH
 lwDHqr3X
 UoGjbcmaWM50pvZYJ3y1802CK848KkrBPjXMbvrpFvDFJjHrjRGviOfUZtp1aww0PLthu2inI8wJsPpt0Z2BtOU46vLhvAx8Y1gMfCwI9pYh4m4EAex/2+oEv00CWRb+MLdtZbf4BVKU5dt6gWLDqhBeU8gpVzhA00jNCpTJn2xMKLX/2Yfl93i6qhjYNrxbDT2BC4ABhjYGYB3rWo1rdUE4n6Xd7qJgYaOXpb1q6GHAfYIFDrWeQc7rMVt/ecMloBTcBFPwXeXsIiulUrN70sdamKwxcwf2CVzhqOpLO6WSmvVOvZqLyc631U6ASonMDcA1YhIs5xfUqCSBtx4dvBixy9GEtBCsMd0d9Dv+9H940uT8+qp/s5oy0ePoUE9xdi2QgFHpF+J5SV86PZ+RXEYn1jNzuK54j5yt/MfM6pnp1xA+nW4WRyBQtrfmNkL2HkKS7ZU4OKAtx1WP03rtUiAd2EgyjAiWOCpG79KcWas3qgVoZBcgKqfekHD4mEDoG0nb8bGxEZRPfM4g4ErLddd7mp9H4Peq1B3bGhZicJW++xLlCyVbdd1bAiNxkYlb5pvFzkF4maK+xiROlMLg11DvjtUNgSR/Pdfe7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current node_spanned_pages is got as a summation of all zone's spanned page
in calculate_node_totalpages(). Generally this is good, but if we use
kernelcore=mirror, it is would be wrong.

Without kernelcore=mirror:

    The test machine has below memory layout:

      memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
      memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x0
      memory[0x2]     [0x0000000100000000-0x00000001bfffffff], 0x00000000c0000000 bytes on node 0 flags: 0x0

    And the Zone range is:

      DMA      [mem 0x0000000000001000-0x0000000000ffffff]
      DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
      Normal   [mem 0x0000000100000000-0x00000001bfffffff]

    Then we see, with spanned_pages printed:

      On node 0 spanned_pages: 1835007 totalpages: 1572733

With kernelcore=mirror:

    The test machine has below memory layout:

      memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x2
      memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x2
      memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 0 flags: 0x2
      memory[0x3]     [0x0000000140000000-0x00000001bfffffff], 0x0000000080000000 bytes on node 0 flags: 0x0

    And the Zone range is:

      DMA      [mem 0x0000000000001000-0x0000000000ffffff]
      DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
      Normal   [mem 0x0000000100000000-0x00000001bfffffff]
      Device   empty
    Movable zone start for each node
      Node 0: 0x0000000140000000

    Then we see, with spanned_pages printed:

      On node 0 spanned_pages: 2359295 totalpages: 1572733

The total range of memory on node 0 doesn't change, but the spanned_pages
becomes much larger.

The reason is when kernelcore=mirror is specified, the range of Zone Normal
and Zone Movable would overlap. So the overlapped range would be calculated
twice.

A wrong node_spanned_pages would effect defer_init(), since each
zone_end_pfn is less than pgdat_end_pfn().

As we already passed in node_start_pfn and node_end_pfn, fix this by get it
from (node_start_pfn - node_end_pfn) directly.

Fixes: 342332e6a925 ("mm/page_alloc.c: introduce kernelcore=mirror option")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Yuan Liu <yuan1.liu@intel.com>
---
 mm/mm_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index a0e6a91283fb..7ad01eeddda9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1304,7 +1304,7 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						unsigned long node_start_pfn,
 						unsigned long node_end_pfn)
 {
-	unsigned long realtotalpages = 0, totalpages = 0;
+	unsigned long realtotalpages = 0;
 	enum zone_type i;
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
@@ -1334,11 +1334,10 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 		zone->present_early_pages = real_size;
 #endif
 
-		totalpages += spanned;
 		realtotalpages += real_size;
 	}
 
-	pgdat->node_spanned_pages = totalpages;
+	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 	pgdat->node_present_pages = realtotalpages;
 	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
 }
-- 
2.34.1


