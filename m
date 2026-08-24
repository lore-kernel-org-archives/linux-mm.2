Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8FC1C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCAD66B0092; Mon, 24 Aug 2026 10:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA13D6B0096; Mon, 24 Aug 2026 10:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7846B009B; Mon, 24 Aug 2026 10:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94CCF6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:32:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13DC4C018B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:32:47 +0000 (UTC)
X-FDA: 85136404374.18.FC4F04B
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3F3BBC000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:32:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IbbChgkA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787581965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DObH//Sc3+e2cOll9IRNEEzq8JrLC+/wx5igp55m6yw=;
	b=Z1cKQkNtwzXN9DC5thW/L2VMWS0dtmKR1nRcMUw7XUUzuB2+uFf60GqMHKS/PajkOBnxwz
	iKQCXbvbI/4ov3idHm/5Ht8KZT/gQwjZcd2rDj32ZKD9Qjml5PeMBz+m3IWDIaADTsWZeh
	43I4Hk9nUpPF58V1Wyjo9PWwSymfk2Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IbbChgkA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787581965;
	b=OAO7EOF55t7rqoGt3P3de9qvq4nUsAOHo4Jr0/eQcXdZtdoM3dRqQWXHqYUYJV4AimnErX
	hAdo43/okTknnOW8WUkG+tL9ccAFN2mpuTM+dgECKOAdcOxpYRPW2nZmMb15r4cWww6HW9
	5/Xw8KfFhQ14nm4N9m0iv2ZVRqblmuI=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-80cebd41372so53715167b3.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787581964; x=1788186764; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DObH//Sc3+e2cOll9IRNEEzq8JrLC+/wx5igp55m6yw=;
        b=IbbChgkAiaX2flPDIOexI4dAO2wxjgEk3rkSlnI8ad4UZpJM8QzmIv0WfF89I3UgD9
         16yO3JREJ8Rz7jsND+IA72bgM9MMCLcBjE02jVQADq/iTqlgtT1kwzh1LIeuLTwi0KWc
         rq2Fdel4XG3+W6HE/XLvi/emRWDCkRQAxuLG18rsFVaAzDHZA5dQ0kMeh0TtJ1YSfaiN
         GOq8FQKZYF7bHf9bPXHG22eZoA1EEivxtHQ2qZ5IRXiSYbJEs6/JH9cPVvITmuKlJDJy
         8jdyNDfczd3nYmL76pXuiuz6iAtypRSHkZujO3H9I9tvpQq/cwTYew5iOw6lwNCRrrRW
         VfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581964; x=1788186764;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DObH//Sc3+e2cOll9IRNEEzq8JrLC+/wx5igp55m6yw=;
        b=iYrn42MaiOL+sqMajZhRc8w2ScRS1JFdPPhep6xUjOHFXnnCHXpN1QUunzU7HqF4sv
         gqhdF3RojZahycuswIw/q+DTn0TapOcdRYyyxraMD/Mhe5nwoFdjBeAg8hdpMOm5eM8H
         /vf9HIq0FDrQ7HydGoThGpykMNdSBt++tOmERkkQsESLPrXcjIRpiR716fPdQpWq922K
         G/zmpHBiiOYzd0BL1wdh4PUqBVYK7rTvx4gpLeNFrPmjp671ykJkswNpKUVF6sMQlFda
         gTU4VSq732u+qQ1nnddIpNuPgHNyLOnQKVuyBEV3lQ/UhYvYqk0ufTuPjqdG3IY/fXR0
         lOvw==
X-Forwarded-Encrypted: i=1; AHgh+Ro495KvKV7VTZpniXZzOVfIvJQerKSKhrebPOU8lThs/WtO1HhTsiGlLKsDT7VpyneiW8REwmEn3w==@kvack.org
X-Gm-Message-State: AFuF++nDUQcJdMzYAikOOy91Qz2QQUmrw4Zesev+y7cCb5sLkA5Ci6DZ
	zzhQjdhuYpreL1t/PT7WF4lm6EuGQFH0IHBcPyzO7qXtzBSOrQeP47lAqhPGrHG58w==
X-Gm-Gg: AR+sD11Kfih/Cti7cYdBvS3FZdB2BmyPc+mJABeCeqVWND4coSk6bNuhga53lyg+pzy
	sis5QVPivdCVpbr63ERPyKQFjnyyvWS7Uc3L5aHHdSB7hpgOjyObKVFxV0ER/vkDGqJziPKXcke
	lebbQ4sQiRIcLRbzFmRjvrmUrV7j38V5ZweOvBN1Tvw4dGDkc5fstETTNTNMl7RHx9mDwdHoVn9
	dxNrWMAjdeBURcnmJYC2rNc5y0xJ8H138MtUg4OhGHNhKKRg2H04yjkpfICJ1SeDYrMuFzzEqzk
	IT7hJEZY4X1SXzSp5M14pc2Bltkgxe0wrmlxKcceuerFRA4GznArx/sBjaoqTU+IZd5zZ1ZkLRd
	KzZ3y0G4nW2ACqJC3CTM/B20UN/G15EBe0iyixafu99eY2lcv8KYMTFhRP9XGuuXxiaCdtS0Azi
	hyorpGM5wY2Mo3FGLkKQJ5RLibS8XOCCeZRuwvg5Ydc9JQohqcceGNsGaveZdZ7XSXkXYoZeb72
	fxMf5/WyUW9yOTD3yRLKRSxUt2gr3SU1Tx73l+oKtGIbn6b
X-Received: by 2002:a05:690c:ec7:b0:81d:5155:213b with SMTP id 00721157ae682-84c9587c096mr75848627b3.14.1787581963521;
        Mon, 24 Aug 2026 07:32:43 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cac201719sm34583487b3.43.2026.08.24.07.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:32:42 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:32:38 -0700 (PDT)
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
Subject: [PATCH 17/25] mm/fbatch: no lru_cache_disable() in
 __alloc_contig_migrate_range()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <614c4116-8326-641e-d7bc-534fde0422b9@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: hfprb9jeqp1g8uss8fds8iq49ysx36qq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F3BBC000C
X-HE-Tag: 1787581965-331301
X-HE-Meta: U2FsdGVkX18491cNwszsQtpOeC4HQAa7XKLKGeNAF7yFRnoCRvvQXtbDKsM3yTFaKDyk+i3PC5QXiIaCH+wBrQ/dijRoh8tBSz1/iAPfJ59EXjw3NfpQKm/5aXbYzCiVdYzzyhBE39ZxX4D9iarTgnLZ2q8vbIV8lGarAuWuwuW6h6WLc/kWrhmsGnwul7YFOsmwXhv/HjWlST5L0LjrChQWodBaKN2aSk7yO2LzVNufMdYinlGdJ/zl8ULbZhc1hXbn9J8o87pb/qbsWsk4ir0pbvA/G9qlb+Ik5JbLHBdUqaUY7xHv7jYv34GLUti7GaOBSZrO+ldhUrIXZ1XIdOySKaRxYsX5oBrxyKSWO+BqC+5PboeDVnZHDz7gjXaEXB20nhddPHL/MI8cvJnmKZWipdJb5UVjxddl50rmfGx8UNWAdvnXhZMnV/+5SNWPHH6t/clNgaQnni4K1yUjWeUru44WdLoYFlXtXM0g2LWmq+flWKOj+t/hUDdGrVphRZTgX7dpm+cIsFaZtF6O4cBk6AzH4pme73CMhzXkqmC27ZLIW3zGeQc9ahueUF9/C5JLz8F8BYxF7wlBjmHyP1JeL1Qcdga1nHYLXlqagABifrRXSVhFJFgy8XrC5jaDAKCeniCvqTjVMHrbiCzeQlsBux0HraWPcf3sdKMuhYrJ2cnopJI+AckTgLQc0KIZjAN4zE6uuzzSU27xzR5sU+FD03b7ssjBtIGiJT3Lxk2ghbZzZgwP4J3IY4myaA4XYgLzVh8txN2hfvyUpLKh85DjsEYWgm81pmC0M0j1eNqT8gVPAlIk+b033GjP4iKrEm1bqEDF9EYGp+6183kW+5hdnK0Y5eWbZL819C7Q93gIJ4DgBDCb8+T/zWblFNpg0zaqiz1jrBJlpneNQ8CoqERjWVf6ZB+Ga9Os2H+GxqxShdbeM8Auope9RLB6pz1tc/hSt5td8RNZArXzvod
 o9uFGVHR
 vEgG7UQdto4xz2MZ3v2w9TwlEn5koafLMh3v4tecLFaDVYSWTy0d+bDqA/SDgHpOsmevk5s/JCem+nrxIU7L+BzWlJB3WQI9Zg1iD7F158FQUuN97XtESpvGI/2DSGGjCMpTzV4i/zOqE0ab2CdXsCeGvG0UUwX0FvIyquyzwBLp+XHiuozz3i0aDsoqxoxmsMp5kQfbWAnyOZRE1AKJ8ASqytdzvtU4woAC1RopARhZpFs+gpawSTR/z+Zh+vQS74wTNIpFW7XA+Y9eXGRaRbHn5AqyyidBXHK/TUgQ4gPHzwT7hunvvAnQPvzg52UJ9xMeFAlQCQND+ebnB4Ua9wvsZL9ACutVIC/LMb+4Dl9nbwXXMM9FLFdmrAIu/uM2c6F4KS0LDvQq7qzoriJ/ZlqeOEkrj6z9t8lJ+w/Mmny56qp2geIi8Dv3EQlo0+9CtdD74QdWmVrHrL0Ysd5C9sdjUhU++zds8fPdO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove lru_cache_disable() from __alloc_contig_migrate_range(). It does
not now benefit from lru_add_drain_all() first; and gains little benefit
from invalidating buffer head LRUs first, since 5.0 commit 80409c65e2c6
("mm: migrate: make buffer_migrate_page_norefs() actually succeed").

This will be more controversial. lru_cache_disable()+lru_cache_enable()
were brought in for CMA page migration, see 5.13 commit d479960e44f2
("mm: disable LRU pagevec during the migration temporarily") through
8cc621d2f45d ("mm: fs: invalidate BH LRU during page migration") - I
guess the testing there must have been on a 4.19-based Android kernel,
without 5.0's buffer_migrate_page_norefs().

It's possible that invalidating BH LRUs perhaps 0 times, perhaps N
times, will average out worse than invalidating 1 time and stopping
everyone else; or that folio_test_clear_lru() failures manifest more
than before (note how folio migration has retries on raised refcount,
but isolate_migratepages_block() no retry on failed test_clear_lru).
But let's give this a try and look out for regressions.

Don't delete lru_cache_disable() yet: leaving stale folio pointers in
the per-cpu fbatches, with folio_try_get() yet to come on them, would be
bad for memory hotremoval: the lru_cache_disable() in offline_pages()
protects from that.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/page_alloc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 083cbcb5bdde..96ab51b78a5f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7135,8 +7135,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 		.reason = MR_CONTIG_RANGE,
 	};
 
-	lru_cache_disable();
-
 	while (pfn < end || !list_empty(&cc->migratepages)) {
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
@@ -7170,7 +7168,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 			break;
 	}
 
-	lru_cache_enable();
 	if (ret < 0) {
 		if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
 			alloc_contig_dump_pages(&cc->migratepages);
-- 
2.51.0


