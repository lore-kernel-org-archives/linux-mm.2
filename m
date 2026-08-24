Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 049A1C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02AD16B008C; Mon, 24 Aug 2026 10:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002BB6B009F; Mon, 24 Aug 2026 10:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A4E6B00A0; Mon, 24 Aug 2026 10:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B72506B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:18:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F70C1A0108
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:18:32 +0000 (UTC)
X-FDA: 85136368464.05.1A22806
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8E8BBC0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:18:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XbbuKZlO;
	spf=pass (imf28.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787581110;
	b=ZjndxRlI+6MxyBW0oAibt3ki9mOVirpbgCEss6spPPbKnbfT8K796DyLGhWEXNfh24JRTs
	MuuGATw4MvX2ZbvO6Fe8PLhU7GqtZz+Ys0cE25iBnOcurrIH5KAFVTcTf7CTaLBBYABRzS
	cM7NAlxnbYDC6gBGhdfEmtJOLAgAHFc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XbbuKZlO;
	spf=pass (imf28.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787581110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1RKlgv7gfcdgd0R95YOF5t38k1glOotR90LR4kTqgc=;
	b=4E6R9D5qrM+Jbc4FojFaVwbJ/9npLbgxBxLDVfgYlV9Gbqf3WGkmau/ykubLanDBq8vwio
	ZYUpi/gktoYoKe1FIwCZITcmj+Ah3RknoX4Q2FdeyRa4p3yaifJjg2Wm1SyIcGnAD94tta
	OgCw960KrbJ/hZp1+P/o2hII2NLVw4w=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-7ff05e5d009so48156547b3.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787581110; x=1788185910; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p1RKlgv7gfcdgd0R95YOF5t38k1glOotR90LR4kTqgc=;
        b=XbbuKZlOj02zYperj9Cpylqgfw9TtbGI4XNc5L101JL/VDzXiOvIJE0hhO/PK7u/Qj
         GCTyy0JKQE3O6PMR1dKZw0qIQksuHNZ3/voVKaB5bW7MlBBMGiFa0+k2QsYBmqZiEasj
         TWHdnscPtDKbO8F9kDiWK2Dsb2hIpyg6wbv+o9SuqPjuh/aqPicoCSmS8O7xNvoHdorJ
         EsZaEEfPw5NMuMsaawQb5LwKFf/JijjlXtcKk4/6M1o/LalS3izVn97dMNkGNuzwncCS
         GujrjNyub5JSf8Foz/iJkeFLvt8gr9NMtGX4N93z/EYIFRklUE8LrEXCEBknxj6nnDtS
         S4kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581110; x=1788185910;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p1RKlgv7gfcdgd0R95YOF5t38k1glOotR90LR4kTqgc=;
        b=XRLfYNt83/epdIoc8uDdfV0bbAp6eNa86u+VutG4ckyeL0w/z6NU4Mf1RvyKnJAnYe
         wGqidNSHoZFDDFTaVMAlL5sBvDtFYlcNLYaDVXZNtAhcTJDvoPc0FpbXJzOj0H45bYLG
         wMYdMRpwTqLfloh60cDQnXup7k1idep6AaaN/kBJ9wyabtwAMILdDNhl4hAFPNwBWuc3
         K/cUlM9Aa6EW2HRjebgA+WCklcaqCNapko8dhXY0nTOe9z+fRpWJCFyB+fk5sSia6lNY
         ScLYrJ5K7Umn8xxnTPCRuGPyYgPDHvHKXZF0sTNb3d8ciTMOtiw468YkXy1V1zB0qc0z
         6Esg==
X-Forwarded-Encrypted: i=1; AHgh+RpxD+jEDuLukTimWLzogVsGGLqgtZZAXTSVyjv4v7kltmIyR5Nu1rdmHcXRqPhE/DdvQq3ibUo50g==@kvack.org
X-Gm-Message-State: AFuF++klkCFJvP5i2ob+bHQgDOHO/v6QdhdyYafObcYFSgT1KPK8S3Mf
	lsTSJEaGFptJYlDEeLlwKwWfCQ3fyv+qV/uKfIN5c9I+JzUk5BBjeblaUukSCZJZLQ==
X-Gm-Gg: AR+sD12UVxL5WA8hroCxddW0vszHReIn7G+rfuD7EV1IBiYyL8rAAvfJNhGnAMSSG0F
	Sa9P0LOzx3f/TU/kVIelwQrgfWTlO2NpfaaLRw3+WfcxYRvR8kXkP7kDOQm0HuySmALZ+kaeGoU
	arBGqlnGw2fr993AMYxCL/7syw7IQWPktSvQR6NFi7LTEPsjkkxxyhH/jG5wnakcgwfVn6J+kCB
	8lyjX/MmtAkrhCcQUPZPOYdBDqvQVTd6+JAxm0m/So6ITSTs2Wrru0dI9NOamczjQ6PKW2H2esg
	ssXMY7gfeQKC4cOwAV5wxkCr+H5ohbAlc4YfafwdMaXqA5yM5nWmc11TJCRT/j3opmAjcshHF0h
	llphXs6VuEouW+663JpJjT+1MZ/bRNce0St0GJqF6Q/nW44z0mqsWSheQXyeyubks0h05nfiGDz
	T1IDd0mnMwoKrtes/pEIlpAfHGptr5ynSlWryAgAcGa9Nsq+HWaZizukePy6obKDMhZZIO8jTqR
	QbhsDJRNB7SompkM1/riphmn+BWOZMlOOt7l8w6LXpmduoT
X-Received: by 2002:a05:690c:e0d5:10b0:821:1013:b420 with SMTP id 00721157ae682-849f090e309mr91327927b3.2.1787581108999;
        Mon, 24 Aug 2026 07:18:28 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8542a633964sm1660667b3.37.2026.08.24.07.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:18:28 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:18:24 -0700 (PDT)
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
Subject: [PATCH 11/25] mm/fbatch: remove migration's PAGE_WAS_MLOCKED
 lru_add_drain()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <6b1ccb51-be6d-5f1b-147c-771e6adaf55c@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E8BBC0008
X-Stat-Signature: 9kxxkyz7aj3kcy1wupp7cn3hs43bqas1
X-HE-Tag: 1787581110-513580
X-HE-Meta: U2FsdGVkX1/ySVgsiAIlvvQcpzBKEHtVusbr4F/AEiGP3KRzpsbHmEGoXRM7kVMZDR9EBZog/AAoXwVX1/3u4Lf8Q6+LonW+wR9+nE0uma8R4ZjlXOUBpUY4TrCkCUbEmsNPP4dhQ+cERO63dTr/K6nWVy+Xmsvgv/TUkAXtq3X4DMN7umHaO4XbOca8KVDYGpTaG6aWxVr6DHms3wRZpLjCWeQaMYx0hsPQ2bFa4w+Fpb55ROxriRihoKNRj3QLPtmqvWmLpLsr1J7fqoqM8QWIrnYayt3xhUks9bWIrIVIHWbD+9vjYH4HeIlGzqqboYL0s+RnpD7wImRE1ZXHAyXR4zXHqNKNskkl6IL2Mf6gWDznkPtW9YcIfx0t0F4jHoh0Z8MDqcPaWclUvR/V/qANabor52o4Zc6b5WGUw4osfd/sGzOPdWZoIgSLwOXnjianxrPIXZwBTasV7JdByB374cAwDN+rsveqYi1bJzJNuN0TFcYdiaC8GvzyvIn2gvR9ipjxuBhHibpN9o0fsN8XNeBxmMfk/uMSo1zFnFEbbyqNDDXKuRFyKhyiiKWQlue5avehZGjxN0MQqLHcGZiSInXBXVtYYXu0O2pM9dQ0m/SXy6krVTwPlnocMBEvnAlzHlCCf4rrQTfLqLcGeCg90+6kRQzyHpKBcm8zK1ShYXhqH7L4Euzmb+MmrdIArrvm3SdgvgrWdC2xNAWKaLDI2xW2hHC3u9BM0pjR7tOLY2YbYsgLT/9DdrJzVIm4N1DoGl4rX3iHYqO6Kr028HeJW3wZ5bJA0Stv40ySExjeUKR14uMITeAuRlW1PwJZMhZAU8qMXJyMhuhT+APO8KdBWpECc+ZOhPkIeTf5+XTG4HwZK2HYlRfuVMl42wez/R7nQShYxEV5SypPCSQ4wxDNHxMaa3sf+Ai8Ok4ya2xqm5mABsJ9FrOJvwof6hzuJgM3sfAXAxZAjPvBCWP
 cGhryxRN
 AYQb02Lzeb5cfWCOAWqBzDAmpvs2kYODzAnZNUjFxKPdu7MTcJJYBmy8ojROHg6C6MzWOuKMD/kD3FGrm8a5xVt+KghsZZNLTm0Xia3xkYH0RK549/xP5bCYX3M72toRVx/NsOgBXp6jjtrgk3TWtKE97jhumIm6F6rKxP4tgOLs5MF0gjxzR4NksJPoaupIUMY4HO8ojOf9jzNvxVI4Az7WOznZK3l61NJQnjBfoqlfP/AaenZLdykppvYBJIR2kL8wrf9QCxqSdxaf0qwC3IPUAUXXfVQNlnovfxcrajCktHY2MNHpT+HAxDnXWNtl9aS5Scw5kUrJhd1VE9LCK/Z60zKqzglv2QdwjgCg63XlrIvh8uXWb5S+lhABQ75ss1OvTq5kLqhoTJkekzc3mgazWHSetL1fu6gn3XzCWYYVwif8E3pL48gbggkIvp9PEXP7vdRxfANHU1CquCiIGxBDRewTVPrsavXif
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A welcome side-effect of mm/mlock.c's mod_mlock_count() succeeding on
folios on the per-cpu lru_add fbatch, is that migrate_folio_move() no
longer has to lru_add_drain() before remove_migration_ptes() restores
a PAGE_WAS_MLOCKED mlock_count: so remove PAGE_WAS_MLOCKED altogether.

Re the "We would like to do something similar for the old page, when
unsuccessful" comment above it: that may be easier now, but involve
some rearrangement: not researched, so just leave the comment as is.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/migrate.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 6b71b2415d00..534908a0839a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1148,8 +1148,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
  */
 enum {
 	FOLIO_WAS_MAPPED = BIT(0),
-	FOLIO_WAS_MLOCKED = BIT(1),
-	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
+	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
@@ -1259,8 +1258,6 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		folio_lock(src);
 	}
 	locked = true;
-	if (folio_test_mlocked(src))
-		old_folio_state |= FOLIO_WAS_MLOCKED;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1411,9 +1408,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	folio_add_lru(dst);
-	if (old_folio_state & FOLIO_WAS_MLOCKED)
-		lru_add_drain();
-
 	if (old_folio_state & FOLIO_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
-- 
2.51.0


