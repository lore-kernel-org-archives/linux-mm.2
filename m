Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6489C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8975B6B0092; Mon, 24 Aug 2026 10:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA376B0099; Mon, 24 Aug 2026 10:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BC56B00A5; Mon, 24 Aug 2026 10:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F91A6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:04:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8ACA12016A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:04:02 +0000 (UTC)
X-FDA: 85136331924.06.037E501
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id DB53380013
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:04:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MQwn1pJE;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787580240;
	b=CHCV+Le37Aq9BUJ7fzQWspDGQaSO2EIGrXa9h+oP07WDS2+BWDEk4z1ScAYuAqcZL+fMZe
	HFfPb1PfIRIGeDdVp7qjsW415FOIkhXamxXwaSe51ah4jgdgpDR9VYOL0gkW9ATIgBUn7o
	jL397Eq4l2buFipYppWVO8e7L6IBgro=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MQwn1pJE;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787580240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLqnUltfGMwKBemLbA/06+FuqdHtLjtQ/H9OD8DkJLA=;
	b=6DmWqHH+C1uRz/NuSTcn1CawEEYuwVnPmDKIomFO8Cp5N1q6V4fL8rgBtsE8mQYTQi8LUk
	LoYhqv7XNlP0GtaIOYwtPIbLtFpqoLXa9NZl9lF7hdf2uM4ciagTm2Ku2//xVo8H7xo5ft
	J65IuB/D5SMVPLT2ww1/vNUiI7UYsI0=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8200b55dc47so54196837b3.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787580240; x=1788185040; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gLqnUltfGMwKBemLbA/06+FuqdHtLjtQ/H9OD8DkJLA=;
        b=MQwn1pJE1FJ9WmS3/0n7g9Abc1ZIpvWVpICwsXwlBl31L9rsgqw0oZJlU/hV5iy5Xp
         Od5Nf/2o5FDdTQEaTIayocvIKq+bu/Z5xSBHFjFwyijtnG4qULPojyowz9Pjke/uITaw
         hcYpIyP07AzzJTPd0pTAnuGh4Jz80Bhkxd8Wjn7pN/CB4ts/GHPbR5nRBzzv1mA+5c5Y
         AWALdpiqUs+kdB6tQ/Mw/qyi+zHs2gBz0YQSMBDSFfaN6+8L6V4KcNhDIRNrOiE2QvOv
         K+GPxRg9YzIUZgbeXIcXZxoDYvEYPhENIzdpEigbZ8uAInP8RZDjtX3grHTQTdORrLEj
         5XbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787580240; x=1788185040;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gLqnUltfGMwKBemLbA/06+FuqdHtLjtQ/H9OD8DkJLA=;
        b=VqwF8NEH1LyPN/bJg5ZwmiRgbRzrSLawVJ+6Nd+fHVWv+om0qc/CEyEuhXuRG3mfjt
         z/zzSeLXM3ips0wrV7TWi2zCFBhBNkQZaBlPSTvgXiiok5d7caIARNhF/VKZo2uHNU0C
         2/XiINcXbJseViqDVOoUsPEp9UpQ50MtmpE4NHlAjXUWUpnFcij6o1cZW3JzH/DHDqne
         WQzcBEBBjlHxVpAa97D8VsOtNFESI4dd48xrelT7H+0VUJcmZIDXGXUqHERw3BpQ6+qK
         XUyIMRjjLrNPl+2UKIPUz0jPBB8t8IqS4s7JkIutkUVkoc5gc3Q+2DtivLmCz3mOrFNB
         HB5g==
X-Forwarded-Encrypted: i=1; AHgh+RqyGe16h3hJp7tIMEMsI6TI3fqugMfg84fYSfCN24IIcm34Oi8Rsed+whpf9iAMQVhobHxRFLltkw==@kvack.org
X-Gm-Message-State: AFuF++n9yV/jRN4efwjtAu1FyhUzWRVwXEAYy56D/+xjw/KxtqKBt0NI
	+61vV/x88SRKJyo8B+lyXUY2z0bcmx1bpkZJevVQENypf+8hThYPkP1eTfoPPvolyg==
X-Gm-Gg: AR+sD13lWGW/fZeUwwWkGVjAi+tLEhQrddI1cP/061v5EmzH1HRx1Q02HL0FncfSAQA
	TXxjqpkfm1I7VzYRFMtYlO2chx9O1FpqQ4mYGOamLMDsNhIIkujdRlmH2ratfNx6Jllg0E8dFKo
	AGMBKrkDsiJAfrsUc08Fr22Hs2qviiJbPdxLFto0XZ5t7tIrYHOKn8XET2DpCLGunxrvDHqFyoy
	hb0wA5yy4Q0zntyhPPvIzorZfAiSilFFZObX3OUcQVFXT/hPjCsCkBaL3nCYV1l6URdni5obLZC
	7nXAaXEmw/zSybxyR7K0D/eLn22dSPoZ+clmZJdhnf5zqlzLBH2Xsy+LLGyiHUEb3wWOB5pTAhJ
	OFmVGRVnhE15iMri67qB6caurBR5u5/xiiBpMl+6Ia3Y2BJFlPq2kwWoAoXFZQg56JKrfpyG0FI
	at3pV8MgYdpp8QoilUNRSneyrD1qQ67gzhM6fW0ks+zxa/Zp6laJ+YbewprWibYfhExTExqSpDQ
	D1y2TjioACDkrRzINM3yxgMrcWy5M9C4S/KsUxnrSZCD5lM
X-Received: by 2002:a05:690c:6004:b0:822:854d:4563 with SMTP id 00721157ae682-84c9682009cmr74201097b3.8.1787580237568;
        Mon, 24 Aug 2026 07:03:57 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cab851290sm33478997b3.35.2026.08.24.07.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:03:56 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:03:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 05/25] mm/fbatch: lru_add_del_folio()+folio_add_lru() after
 clear_lru()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <9c538ff2-7150-1021-df1e-fbc10f0bb92a@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: DB53380013
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: eso149rocbncy4kjoturmrpc8j1d4a34
X-HE-Tag: 1787580240-651270
X-HE-Meta: U2FsdGVkX19H8F6hdF7M9dp8fv9uoD9tS6NyeuiFgtO6sGwkYtiZ+XPMCHMYIQC5Bwh01lxtj65e9yodre70AhFRenlgc6/Gvw4U06B2HNHusuQHWymTmpPEGXCTkGWK6Yr7A9BRUHGLj3m3EwA6BrU5YZTJsaZsiBe6CDY9FH0rT8G+PATx1SKD+M9jkMcNO1O1mCGGpKYAb5NWGIO7AcdOyemwciVTk84zVhh2av8IlQU3C9MXyagfWb6vc1d7AC2nOGPXJe8eTa3FpXz5P3Qzl/nTJ9qiFmAZHLQInd4p/UPg/zBeYm4mwxukpuSGAOqBb5tRKU3bLOlDfjo/HwpdV9X2JZiXGXrC8VHql8t+FlSX8K/puz8wKCWGzbx0y5504kVcyalEHkxXmE0pYmOd+KtktUA35VPKSMuE0tCJ2SHdt93IQk5xI4B5NqFRt2HKoEYbAZDMPEkF42q6C+7i/HmWzcXx4Vz8j/gZBNrs58k5ExbAobl//lo/QVaa3NcDE71EpfCryXSc96O5EzkDCgp9kKl1F6i2JsRoP7qzhU76n0c3p00TSbBRLP6Us3SCb0HeDjgMJYhmHmcs9nKAZ9iO99r/5zY0M8HiXudoxDtRZbk0rEbK+Orl7rolMiCHSNFpInzQXq87eW5waoiFEH7X/AsEdQxAbVj+YuLJJyTbY8wEM4rj9Qs/MO4cvbEOeGjKRg1LuH44QA4zDf9Oxy16qeJoCaoJ1b/Hkh2ZJg1LPI4Hy++yJl/LUQijjeahR7hZNpnoSRA01eqIPQuKyWN+Zcbrj3Azxs3Dok5qxcaa0qkrMd3UwHYakbHSiPztL//+7mPpO3QZqiVve9aHXjYkL9rJYWkGRaxnIIUUZAUziyzTFVDebF+iHLJllTF9qgZ2/ZrQPJ4zFRaIu5u60Cfqqpaz4lVOpLzmDYv6Z125VJlrbMU2dRowdw8kzKw3BAs+ug76zeYcWkJ
 LPyPhpoz
 GqlcorvgGjtPOUK6oeMLPo+SyRNpFJA02BKbPXMWJ9trT9RRn/00ArHVLkzfX5YIH2C/9PhfHI4TaBrpilGyK0bq9Bxul/mBQIdWTwiUCDNe+HuuAp1YkaZLUEIA9Uiu3TadYewZMKyf6JoWvQ4iTRSmEoP57O5ZUQpoXfq1v32EKEZhf9vQnyuLyvaV0eeJDBFBmvLwG+9TY4jLTCy7wcheLSSGHt7N+siOTZYhxifIklMEejGQXMOtO+Xdvz8HV0dIzHz+Jh2zffo9pjYmb39LIwY0AuhfgnKYsanDebHRDK4yWfFjn4eg81p8SSFU3d6ryyLb3eUaQezdXRtTcOUf8JEYCp7k6v8nW/aPZUOS6iVVdC7OD3sgpYXH2qfOrE63xcF4+xyfoiw+SpedY0WdQHThEzNnFMlK4cg3kY1rhSNXYLt073j77/4L/WVeRvbNsjf91V00Q/E+AiYypNPRerZJ7EdY7HmhM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Most callers of folio_test_clear_lru() then proceed to remove the folio
from its lru, and add it back at the end when they're done (if still in
use). But isolate_migratepages_block() and check_move_unevictable_pages()
sometimes decide against, and release immediately with a folio_set_lru().

Which usually works fine: but there's now a small chance that while they
held the folio with lru bit cleared, an lru_add fbatch drain came along,
and had to skip that folio because its lru bit was transiently cleared
(previously, the lru_add fbatch drain relied on finding lru bit never yet
set). This risks leaving that folio off lru, unreclaimable until freed.

Fix such cases by trying lru_add_del_folio() (which only takes action and
returns true if the folio was on an lru_add fbatch), then folio_add_lru()
if it succeeded: invalidating the old fbatch slot, appending in a new one.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/compaction.c | 13 +++++++++++--
 mm/vmscan.c     | 16 +++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..9e045a90ba21 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1204,7 +1204,13 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				     !cc->alloc_contig)) {
 				low_pfn += folio_nr_pages(folio) - 1;
 				nr_scanned += folio_nr_pages(folio) - 1;
-				folio_set_lru(folio);
+				if (lru_add_del_folio(folio)) {
+					lruvec_unlock_irqrestore(locked, flags);
+					folio_add_lru(folio);
+					locked = NULL;
+				} else {
+					folio_set_lru(folio);
+				}
 				goto isolate_fail_put;
 			}
 		}
@@ -1293,7 +1299,10 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	if (locked)
 		lruvec_unlock_irqrestore(locked, flags);
 	if (folio) {
-		folio_set_lru(folio);
+		if (lru_add_del_folio(folio))
+			folio_add_lru(folio);
+		else
+			folio_set_lru(folio);
 		folio_put(folio);
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4ca9775ceee8..7da12ffbd3bd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -8021,17 +8021,19 @@ void check_move_unevictable_folios(struct folio_batch *fbatch)
 			folio_clear_unevictable(folio);
 			lruvec_add_folio(lruvec, folio);
 			pgrescued += nr_pages;
+		} else if (lru_add_del_folio(folio)) {
+			lruvec_unlock_irq(lruvec);
+			folio_add_lru(folio);
+			lruvec = NULL;
 		}
-		folio_set_lru(folio);
+		if (lruvec)
+			folio_set_lru(folio);
 	}
 
-	if (lruvec) {
-		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
-		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
+	if (lruvec)
 		lruvec_unlock_irq(lruvec);
-	} else if (pgscanned) {
-		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
-	}
+	count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
+	count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 }
 EXPORT_SYMBOL_GPL(check_move_unevictable_folios);
 
-- 
2.51.0


