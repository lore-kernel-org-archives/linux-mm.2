Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD30FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 03:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6045F6B0092; Mon, 27 Apr 2026 23:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6016B0093; Mon, 27 Apr 2026 23:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D656B0095; Mon, 27 Apr 2026 23:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 373E96B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:07:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3AAF14038C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:07:22 +0000 (UTC)
X-FDA: 84706478724.04.0AB6D83
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32C55A0008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:07:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B7KlNsfk;
	spf=pass (imf15.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777345641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWpmesrib8YdfGGI0hDM8gVfRzPJHHWK0tDw7HDbtCM=;
	b=OxJBktobLaFDT5zWT9VM0aiOyXGARlehHz9n3RK2MbPCd1l0vdn5prP/iUsy6WcGhQzOs5
	eGW+CvfopeATkitJo90ofkH1un0hT9wCbnW+1J0tyjxKCMwliEeIGygN7DvBlYawa+Cjzs
	b8R5Sr4dBJ1or5gJAmjyJKIJciiSnhs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B7KlNsfk;
	spf=pass (imf15.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777345641; a=rsa-sha256;
	cv=none;
	b=XcnajVpENi66FIrUry/F1kU0r9Ux7PBRAfgaa8+nRFGbqef00frOEwi3e3GF+5Mc0aiXnA
	U6vKHF8VLfQJlejUCYCI+Og6y6/f5tdLk9ZIZU01kIFPot4gB1KXhi6MuguXgbvrAruDDz
	c5gAQdba5V7PLX3UiTSS4mLJtHqKeKE=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b24fede2acso71654775ad.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777345640; x=1777950440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UWpmesrib8YdfGGI0hDM8gVfRzPJHHWK0tDw7HDbtCM=;
        b=B7KlNsfk7AJBcZrOBRIaqqyXluHLdmKudNW6wF70ihg4a4wzBpJiXgUc7g7AJDjh8q
         oY0qH+tYqA2pSSBySyCOZuNG3/kaczTxoazEf67td+h9tpsEfpfLrUGaFlCsfFV2xAHX
         XTGSgGeC6q+vPg+ALq7eBuo0Vieqhz+2Qf0Okp7CrihR6EkW+XEhfjb0mX7b1oZnx87f
         6N0wpOu1DkyFXTs5J/YNQg4Jef3TywBMGRE0+/HbVph6pXeHyQkf9O/yixx/rtVCSUyp
         gjJcEbgUWDLo6ux4ikU5qkhbkDumTBWm6DcWH0N7kGHiRkMvez3ZLP+Bd5BgNvV2gQrR
         RoYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777345640; x=1777950440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UWpmesrib8YdfGGI0hDM8gVfRzPJHHWK0tDw7HDbtCM=;
        b=PwLA4VkGzse6Mcf7uFQ3VEK1sIINAonV/UbLODyfLv2zeuo6mu4GAmBIPtISkKXJdL
         ADPwqULA/K8FAB3qTicvkH2GS8Bi/fItQIFg+57gL6tNKysTJrPWMIAge8KXNNvBYyx9
         NS9PlB0Z+80XmU6riJE+XtLHg/yuuwwu2/WLSOD6Byf2PM5A9CvvWLUgL0KjjM/+GAjB
         YI0iPGmAZwc0QBuf2IH9JsjlZ/dnGUWfOYL0izEWIfaqwoghItlTUGaO0xzGJkddGg8O
         dx9hQU4/wbNBrn/gVYeLa+yYn0aEeYA0HZKgFKbZnt6jpw2qkUv67Cnl6dpPF5tQJl1s
         ZiwA==
X-Forwarded-Encrypted: i=1; AFNElJ9/j/miQPFKdJFaFfW7VRkQO3X9zueqxyhX+IoKRFh/jECUSY6vE/8zQmSBlqPXUZbtJX0tiL+uLA==@kvack.org
X-Gm-Message-State: AOJu0YzL6ieGRLJZSyFIGkb5MO8ByoD+KU1hWGL58IbK3rML2/3XkbZG
	LjSwLdStDmESDrsl2WyBoCf7IPFyjUxrqZCSF6MyZNVORRPoydnbyUpX
X-Gm-Gg: AeBDietqcOzx1DIhAvS6qC/QctNopI1ypjyVMpRb13HRwkbZHJp9WcuyJrccT9DHFMs
	uhw8O2o9sfYTS1+ubGO7PNFzkxD5+LaOJWmXVsTSsD0liQQJY1GtHjV0xCMNZyrJ8XIrvSRnCFA
	CUmZPp1hPFwEocIJw2jiWu9ZEU1kWvZ5FT5Dx7kadhTRxoPzUZ846HnsO0U4U4SeJY1ANSuFU9W
	aO8+dz5/oJPAWdu93D/WftNhl5ZItzO32zrFsrrHzCG5czCH2+ASuOHbyoZY+bJ/KSnqw//76xA
	8RbTCLRCQ+wvoDu+VZadS0r1kmJAH0QID7BR4Ekhwx7/chMzS8IjEUUrwnC6HE+n4Tr6ZWP6vAn
	aw0CJ3Oeg81foAYlYbuxTKK4DUFC6rhTA9XxinVIbXqwqFheBCH8nx2d3Js4wAT91klpOU2kaPc
	01tj9WRRHvPYRyahtkj8RQgNBObuPpmihyZaINgOy/wSW6/FRHmOuAbHuGMubFWD6PFw==
X-Received: by 2002:a17:903:1585:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2b97c0198ddmr11959685ad.0.1777345639920;
        Mon, 27 Apr 2026 20:07:19 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97aca83e1sm8897915ad.78.2026.04.27.20.07.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Apr 2026 20:07:19 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/hugetlb: fix subpool accounting after cgroup charge failure
Date: Tue, 28 Apr 2026 11:07:13 +0800
Message-ID: <20260428030712.66256-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260427145247.84157-2-enderaoelyther@gmail.com>
References: <20260427145247.84157-2-enderaoelyther@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 32C55A0008
X-Rspamd-Server: rspam06
X-Stat-Signature: bw1gdew5pap1tx9j99gyq1soimc5ahgh
X-HE-Tag: 1777345640-623449
X-HE-Meta: U2FsdGVkX1+GmHsvAdirnfw2BAZwGnbCENWsVUM0O/5U4xwZlhWKx3+qnvsM2HAAa6rkZI0Oh8E0NZj0eTQjUyYff2WE+QXlpDKqkbpvRjDpnvsUWGGry7Uh8HmZ6nJ5kfKCrG3bAYI8kN+RzjQzpE/KXzRrJaHyffHZooWz4lUzBtaEYSQL9OcEVtJ4jv71LScDcL4ebaaCaShsJjhKGsd63DSybPZgriLCiiOZeUwQyUryhjU+knlzXKd1juJo8msHzYGYp2jFDm1pDnKiDV5lWPeo6yNf0957I6iAxfAtXO31FaVqqvXQt7rmzAookv6b3YhGAcRAMNhu64odtRjDBfykCqLTIIVN+udagULdqYiRhlWR4nnmpBTFY7+SIBU9M7hl/HHI9yBypJFpJ/5M3sm1vSc+RF498ECM/FbXFiwh3zrveSUlq+yUdobev+pqwSo5R7XAiRBag6P71rlNbqMWA9TaKry0/Zgw+NuzNE8AF1Zl0CJe1FyggXs1Kci19ROU1MopmWRwP7cVGS3dkb0gcEmiwn3icgojyXbFwFOcH6En/o5jX7DrwXf6Xoc3RO5jD0ndooIyA1bbl50oB4kVU4Nw8VpBV8Wq32zmlXNP1PSqd+R6lHbLnV00WkDyecSnEBzxOSry3GAZ1NhYYP9nW05336Ws1rR8h4FqH5sDNeAORn7mmRuzgHXt6DtP4ZDZTP6aEQfUU2iQn8q8eK8Q7soAAktCU8vfrP6M3liyMHl4bDFCzqGDJ5ucyqpFAHFbEnVzC372sTH1rbTRUGsu+Q6cwUrocPkWHR25N4QIwwaX55kvungE19zHtZJnJXRzLNnYUAFz2McyE6IEBdcbtkLyVRQt1UzPHAQCS5LH0JbM3G+b8XKgEdJJFV/kxlufHEQQVPCrodcGUd84tTG+L+t9x/IkFzpfpCnpsGM5Ou2+q9HBvIRSwmVATJZjvbRcDO5sziM4XoT
 YwHJyaxn
 3Dm0Rb5HgLa7Iy2DTadR+l+rneNNCV5/KwmvbsQQi4F07e2n5ENFrP87CMNbIfdHpgXeJ+SfbPVzLm5lcn0FoduqJUZs5tLYsZE/iL574c6OBqTKHpzUYJ4b57BAFZOl/kuSIvOBmQqOxK9nQdYbIqKWls5mzxROToExGEOcrhO79KcTGrLq0t6IwQ2Pst6t7sWrHtebIT2+Hptt28WZanj0BQzdKyzd4ZR9G8ewC7b5YfZ4KNVZgsO7Sv6ons0WqSu1MqxIk17vj9hoqujAYHBokHfXUhlQmvxVeNo7fCAInVoprJ01CoaX4Zs3qmyYMpizYbNjuZr08WeAuzyeLeuu78cRq8lQftHNbfPUF2Ss0tb1/fJm4jNhAeG3r3GDF+iFo8IlriyKoRZEPCxpid/IAiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
is set.  For subpools with max_hpages, that increments used_hpages.
If the later hugetlb cgroup charge fails, the unwind must undo that
charge even when gbl_chg > 0.

hugepage_subpool_put_pages() can also restore rsv_hpages if concurrent
frees move used_hpages below min_hpages between the get and put.  When
that happens on the gbl_chg > 0 path, restore the matching global
reservation as well.

Skip the gbl_chg > 0 put when max_hpages is unset.  For a min_size-only
subpool, get_pages() did not change subpool state and put_pages() would
create a false reservation.

Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v2:
- Handle rsv_hpages restoration when racing frees cross min_hpages.
- Skip gbl_chg > 0 put_pages() when max_hpages is unset.

 mm/hugetlb.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be047e..4065d66fdcb5c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3026,12 +3026,23 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 						    h_cg);
 out_subpool_put:
 	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
+	 * map_chg means hugepage_subpool_get_pages() succeeded above.
+	 * If max_hpages accounting was touched, undo it.  If racing frees
+	 * moved the subpool below min_hpages, the put path may restore a
+	 * subpool reservation.  Restore the matching global reservation too.
 	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		if (!gbl_chg) {
+			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+			hugetlb_acct_memory(h, -gbl_reserve);
+		} else if (spool && spool->max_hpages != -1) {
+			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+			if (!gbl_reserve) {
+				spin_lock_irq(&hugetlb_lock);
+				h->resv_huge_pages++;
+				spin_unlock_irq(&hugetlb_lock);
+			}
+		}
 	}


--
2.50.1 (Apple Git-155)

