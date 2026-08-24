Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 219F7C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFD76B0092; Mon, 24 Aug 2026 10:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149696B0095; Mon, 24 Aug 2026 10:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0383F6B0099; Mon, 24 Aug 2026 10:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCC1C6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:26:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A2B9C0189
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:26:04 +0000 (UTC)
X-FDA: 85136387448.26.22CC994
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id A101E80002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:26:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QZk7tNTD;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787581562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsHaeoqxnMhy2GB3rUAu2bzr8hj8izpjrzp8bJJzBnk=;
	b=qrSY/WqavCftLdt2rQout6bZvGpY3SadtLO7RuBMWyZOu3wFVvGVMNBIYnOM+GTFHo+p0I
	aX+0lbs23ujZ3nz7x8q9vMvR1MjmBNwsGsAbQCixIYFZLU07lbchxlevVkS7LjhZkq2ATi
	WtMTgqfX7iKFjwFeQGqKvqoIrVvf2mY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787581562;
	b=nqScF7dXa3+9iZPRIglAefUCZvfRtJPbdX0apcb6hMA8UiFo6rqHBO3yYIUFnjiCQOfYUV
	FImmowrppZepF+bJcllbiiQN4wOLlkm3gjgFSv5lao/UgSfG8DffyAIbH0C/tve7NJgF+C
	o971+2//ZZmLMz2YGR+tdQI6I9HafmA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QZk7tNTD;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-81ecf499af9so48979187b3.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787581562; x=1788186362; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lsHaeoqxnMhy2GB3rUAu2bzr8hj8izpjrzp8bJJzBnk=;
        b=QZk7tNTDWgAlj9FAfC+xsb0q3qrDkny6Jy1xVPVS50qamy8ZLeO1pt0aXs8EwUayUv
         HLiR+NALywdHj457Muj3U85dEya5cinQGQmjPPt414bVnJ+zLuWiE6vZnPuw9jwFIXV+
         ue9/S2oGhvk61laS0kdnfdwCjy9lD+TIDP/xBd9sMtDobVtzy65lJhp3TJkIJiEQ1cbI
         Ok/kbFN43eIkRbhhnwpdExJQfKttpCjcw+EvZHdCCRxz1nOoh2I6R4HpoCAdJ6GDbJjn
         uIpJe7NVUX0C8FW550cdeWLzHYA3CUWsw31lJanw5sO0Fw0Bfm9l9ikNld1VjQkCoXvs
         1aOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581562; x=1788186362;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lsHaeoqxnMhy2GB3rUAu2bzr8hj8izpjrzp8bJJzBnk=;
        b=o6ZcSrrXPEFG6ngIpbUJrKcwxTBb0BfPfm1x3qrjLyB+K/LUBR3yRJyW/T9fy0OaHW
         EWKiASBsTLQXyQjQoWJ85d3+JenREXhJBNbhlgRLJMebOraIjI7/S+bx43dy/MjxMA4U
         MMdKRNmaV2Gg/o4e9HRFjyvtuNAkQsa1cnqiF9aXePsI+GJT4gEP+yRUCJJO7EjsQy7w
         lI49YnX0rt/E37IUuc6lBp8OimYQwmoHE1DsxvSQfwKNYor0d7Mz7KQRpjBMbwzlDT96
         NWRuQ7D1Jo7Wgpq7rhW+dkALFC51oxyIcpRdUdO2LoFxvt7lzw77JQwJazSWArD3jUbY
         d//A==
X-Forwarded-Encrypted: i=1; AHgh+RqYBF6mjw4wOfGLmrjrAcmX9ajyOh+XmxN3zsagw4CzfHCciD0QXmeLOgHdYi59cEUxVs9i+GXJmQ==@kvack.org
X-Gm-Message-State: AFuF++nDT4MUs6XZQIvXxerOCZMBG4tTaJ0IRt+OCGkUdW0Ni5Vlk5pV
	ybI/saM5LvUy63e4sxGe0E41DhaZgyLTkhXTzXfERBTIhhPSxWhBfuPjrsJ0Gp++VA==
X-Gm-Gg: AR+sD13mnem0F/d2bzTwwDW6JHZRsRlxHGENy7S8KnR3xdM2laREafIFG2iSyx6a0cx
	m3xmrXzn2RpWURmkP4SdDQCRzFsEK2ex/JLsYQI3pzh5IdUtNdKxSiKzyMMFYd/DM2UBzQqx6rd
	W6QmZxMMDhz+auLfx02emgI1XBl0Hr+c42ncbeb+YLUw6mFuwcG+meu8PIDAjADrs0fUM0cJoSW
	RT488WARKBq67WMJI5kMfOXUsba2E4m19CDa2Q4gP7Vfu2rd5Irtgpbci8kdIpk90oLLE5ndaA/
	UM1gW0A7D5io+9rhJtrk40lCTxp9A30l19bHrhEJCMyyqHykEnhx+5vvVVlL0u5mZk6EQoDbByy
	6jP7Gu1LMWkuRYLrrjcR8LY/BwEoAwzKw6p1M/pXS1RibBqtQhT8ShPrLWfIQTnzoefSjmS7WfI
	jeAKSwp0QhLHen4qCBJOV8I6tHF4nSMvbPQb7HTCyUH+iDKArORNv3WtQ9tg2nVGnpWEXtu2Sok
	awr+JRjyV5OFaSeEnh8+8ydOOWNQVTAz9cRhNhrOYNI31Wq
X-Received: by 2002:a05:690c:c604:b0:821:1288:f820 with SMTP id 00721157ae682-84c95591347mr57984377b3.4.1787581561128;
        Mon, 24 Aug 2026 07:26:01 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84ca68c1b14sm34720667b3.21.2026.08.24.07.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:26:00 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:25:56 -0700 (PDT)
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
Subject: [PATCH 14/25] mm/fbatch: no lru_add_drain() nor _all() for
 memfd_wait_for_pins()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <4bad9833-60f5-30fd-098f-3a306722833d@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: or1tye9n19xmt8y5ap7xupjybgzma7kk
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A101E80002
X-HE-Tag: 1787581562-140324
X-HE-Meta: U2FsdGVkX1+VxKSS8E4JaTWHAXT3v+EKx6Itla3nF+vOjWXMN+SyIYKregRNsIRP3EBbzJfQUxu6AIuHJGm/Ko3etmbd2bwW31QkE/yk1n0sZAvcVc0XL+HH2LZsHSPsmVMF5p7QhBdC82MrRR49aHdJ66G58nboTSvPDhnC1E0+pvuf9Tg2epD7Tw7ry0fHKv3TaKiHtIajPUbFC3SJzQSwpuEO73Qv3BsMxhj1bSOAc9jHWbK9Lb8qCLDjB2+cm9hpGGicJvxupk5XCbcgueEqESnwWkwVVygq3ZGDsBHWfymt1nNJcrfB/cI0MSpNIBXrZ1onvWAAoQkTMquX8fV9Ibjqh0GefE9tBGoZoLxmRlyE3lEYt38+bxn6Q+KmZb5DnXheRhwphuv0gPMoP3A2jpe2udqPV6/wk9BkLOWNgifL1PnfyXrMvuGV15GksMho+U+RjgfcTpB+VWlunugeLHy4jxSxcBYmdqo/1hH7DSbXIljD91wgxSQ1qWQnK5glcziOA+vsjoTfUMmYTYQSHMHLMsTfW8Zggor4Nl9CNOaGtAMXRpzM4XxZjLkqTGiFqK+Bj5kfPaK8v5+0Tgfdt69+ZIxJPD9pvhDZcmsiJvhH7OYjpDJXx/1/89mmvXOxWOIYfTbfiPAck6x9TllZGklaqHqBTkkUm3czpuOiXQnLkRmYKrqSaJh4YlM+md65vNu7YSv28PbNeaNjFrhYI3nH+DO/M/owR5bUNXmqcFOku7xks0DW9XEA5xYNd+juwNtnD+dSIbyW0JgqyAqCukJW2lsbv6r44rhh13Yu3jIQF+tcRspG3b8h2wq9Rx06Jum0TCVPE0VLU9ia5iS523BmwzOSYVwPtd3mH9SO704U9kd1beAlBWUksQ47dj0OuNzQeJv6YJ87yxpslw2ZFw5GPQDsEGlAkDjrvAgC+OKyxj1/rgO5cF45De9H20YAHuJT4hhoMi9k6IF
 we0I12xB
 L03Z9aC5d1GUiWc+0AUD85WOhw2OXBL4mMWrP1COM7/gPQG3NnW00T3xy27CHyuGkhHGqlDpcewamm05Sjy2xKCJuXiVpUiGvhm4xsqmSZaU+i6ckaXyFHg6TQDfUP9s2JtIHkALDk+MciuVGeoP1/w/0Z4Lg4TrCK27EBdvX+s+8tCsGZZMFqNuS+pl+C4RqqEkg99kWu0tG2Hf2uIf9ynJu7sa73SxYgUU9iz/vuX77zfHUnJYk/0+AJcJ2KILVgBiX0764tKVjAD9bpAupvmVs1C14+mIXiobKgWyKw0vRDAMaWo7g5QoXP6q0lzTjWl20JQAyzNLz8colmjSgzmnH/k1gfkGrh1/tH5fKfGpUQGQy7bKr2OPyHRmjjQuwBYbOU8AmAgUYf5nXwip1C9I49IldvkN7NfNjOhar+lukmqd36RYNH5TJQ5JmuZ7P5a3Vkw8RvpW7dJ5MDd0V4bzHe0FcvT9aAohS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_tag_pins() used lru_add_drain(), memfd_wait_for_pins() then used
lru_add_drain_all(): remove those calls, no longer useful now that the
per-cpu fbatch references are gone.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/memfd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index c708d92533f4..064f24dcddaa 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -40,8 +40,6 @@ static void memfd_tag_pins(struct xa_state *xas)
 	struct folio *folio;
 	int latency = 0;
 
-	lru_add_drain();
-
 	xas_lock_irq(xas);
 	xas_for_each(xas, folio, ULONG_MAX) {
 		if (!xa_is_value(folio) && memfd_folio_has_extra_refs(folio))
@@ -168,9 +166,7 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 		if (!xas_marked(&xas, MEMFD_TAG_PINNED))
 			break;
 
-		if (!scan)
-			lru_add_drain_all();
-		else if (schedule_timeout_killable((HZ << scan) / 200))
+		if (scan && schedule_timeout_killable((HZ << scan) / 200))
 			scan = LAST_SCAN;
 
 		xas_set(&xas, 0);
-- 
2.51.0


