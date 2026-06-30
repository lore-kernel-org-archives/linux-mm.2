Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 897ABC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79FF06B00AC; Mon, 29 Jun 2026 21:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777946B00AD; Mon, 29 Jun 2026 21:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1A76B00AE; Mon, 29 Jun 2026 21:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 261746B00AC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:54:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FB35140283
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:14 +0000 (UTC)
X-FDA: 84934908828.28.70837F7
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7DFF420007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FIgNd9DL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784452;
	b=gOaiPIm3krzGfH+mNZvVCE4VyceBELq8avQBT6/NhiSvssQ1Xxdb6y8s77IKKm4RU1sBgx
	oBWllbQ9b+U9WdaL3oB9K3uA43xbYegewl4QUesmQa0E42yhyEaMeG8LAsdRuF10SC+3K8
	CgwFCs+botTIas8dlrnWaPq5iA2GSaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AeQBR8Jr8+xBr3Mb/Jq7ZoDTM1Fuhu9AGQLRB/s3dg=;
	b=xkeya1d9+Bw7IIxHYBNoGRF7OZY2pRFckvEZW/9Tt43Dcl5PP+XaAGZ97BVXgMwxjmqx6j
	6yP3xfNrPz1WNy05aDu48bPV8EziLqORbONVNOXJC17Ck0Heg9WDF7g57mq7ObWIPn1Fcl
	uGYGljl8bESHJP1tItNTTJoG+qmQ+eM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FIgNd9DL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782784451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7AeQBR8Jr8+xBr3Mb/Jq7ZoDTM1Fuhu9AGQLRB/s3dg=;
	b=FIgNd9DLtRUgYfkfQeodyJ7Ogs7vkO0rfNnb1efxUo5DbKqfGgQ2pZUS8ALxdvlRt1gI4R
	537e5h7kk/d1gS+kJfQ27W8icu1dDwdVUJwkv1MLF0wXJQOrfErZ57oc+QiC6k8I/jZPAk
	3u3hY6NVgzBHkbxR+vKpxHHWL0HKok0=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/7] mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
Date: Tue, 30 Jun 2026 09:53:23 +0800
Message-ID: <20260630015331.147174-7-ye.liu@linux.dev>
In-Reply-To: <20260630015331.147174-1-ye.liu@linux.dev>
References: <20260630015331.147174-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DFF420007
X-Rspam-User: 
X-Stat-Signature: cr4d1bbeycffj58ix6qnhe9bdej1yrqz
X-HE-Tag: 1782784452-873564
X-HE-Meta: U2FsdGVkX1+n58B8K88Ht/oGeUkmbuv+yu3N3aIdNLawhrR/qH0lczZH64bSxom9MDxLhJfVri1R2akZTL/O4FxcOaEuqEuiMrTgKVr/aj6t8Iw1pNiQ4NF03rWOra+RxFbh4JlPZpE5jn1MWiYbCZhnQXCUr9dvpQB0PsgFYoX3utR2wzz67TSPTaLMerhJT4CpoqVbF4pi916+1KrfDV3BQQQogmyv7YpvIG9g6jpvM6LJFm0ECN6CghM0UlTuCSLwdgMQVRWvsJdi+tR3/XLGRalBMK2q4NtVb1ayweYbsi++1DlJ1wj23h0pQjscXLWmCJPimpLcN527igpcZuvPgDEvXESx+TF1+gJiNSBrIR72oVJUFcqvBfYxe820DM2KhubnJxlOTTdtpbo8ck07Im7eYFfEac5me9yDgZz2ZJW98eb5ffQFhBmgvgNrLZ5y3PWOmMYBZcCGbqkAUz0NFfFFlptgnYlIFjvc7CmcD9GoxjvLBxCMkq87ANA/+5ppSf0QYG+ul14Vvb5wsYmzHFS8bCPXmYA3BdknK7VdzexUCUYBep0JtQvuQYLKLydz07qpsXzy6qp2V31QgLq3skTaXOSMZS1FBDBmehUTBp+3uwoCLXwesO2CRlkV706MAuDwq+WY/7sEpLlyXcoetn1CvUG8A8cHdujKUUniEMzifKz7d0FQyOp1mZAPHF/L+pacSn8IE+5LtmfCp5dZtbaRANkWJMzJLqbBE5LIt7HuEwwvVASyhcxNYpahKs8Pr8zDAjWrReSy42JUTd0CYGnU1H/0a4AtyrJbF4bn8O9/jlO+0Yc6toxZviMMb2zoNz2dZTtlwXtnLWp7EY6z5HOU0Fl76W6na8UXer3ytO9NC7vmcvkzrn9YmA1G3HQGBJdr6Ubwrl2/fTYc6/dw2ViBLV7J3Tlwvlzka5l6IiF4lDwECOTWBUc+y+ccel1l7bxlVgQKCR0kpdr
 dKYCExzd
 gNHLMTc/1w+SR88hndmGSVxPEjRME5CN8hKYfajF28Ql+d0QZHIdk4j+PmQvwwlHgjdqF5gBdvjEuu8UB5gwk/Gp11FvuXpxcgeP7hCRhE6UeROtsRPEpO+aspC7hnCoSa9tecYHrrDImAzVLR4hRSf88XHH+nyF2sR6WSrRqR6r5ItiWbT3/wwW2doUsz//QeSn9AlYVo/Osgatg3O/EiLsvdL44LK2jqvbbp6trDoblqbJm9yyQiggXqZoz9q+YY00Ru6/ko6IRot2NbEokUwLyRG140Va34OTy7knSkyeaReE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The free_ts_nsec field is a free-event timestamp, but it was printed
in the allocation summary line alongside ts_nsec (allocation time).
Move it to the free section where it logically belongs, together with
free_pid and free_tgid.  This also makes __dump_page_owner() consistent
with print_page_owner(), which only prints ts_nsec in the allocation
summary.

The output now groups all free-related information (pid, tgid,
timestamp, stack trace) in one place.

No functional change except output formatting.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 7520718f63f1..84eb44459478 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -653,10 +653,10 @@ void __dump_page_owner(const struct page *page)
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
 		 page_owner->pid, page_owner->tgid, page_owner->comm,
-		 page_owner->ts_nsec, page_owner->free_ts_nsec);
+		 page_owner->ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
@@ -668,8 +668,9 @@ void __dump_page_owner(const struct page *page)
 	if (!handle) {
 		pr_alert("page_owner free stack trace missing\n");
 	} else {
-		pr_alert("page last free pid %d tgid %d stack trace:\n",
-			  page_owner->free_pid, page_owner->free_tgid);
+		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
+			  page_owner->free_pid, page_owner->free_tgid,
+			  page_owner->free_ts_nsec);
 		stack_depot_print(handle);
 	}
 
-- 
2.43.0


