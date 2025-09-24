Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC3ECAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5B78E001E; Wed, 24 Sep 2025 16:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DA88E0001; Wed, 24 Sep 2025 16:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A923A8E001E; Wed, 24 Sep 2025 16:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 961268E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:44:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AFCF56F4C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:15 +0000 (UTC)
X-FDA: 83925321270.16.B11BF2E
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 90067140009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zu792+eT;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRPftj4LaqpBRfvv5a/Vndy5zTyggHCJw7J9EdAecUc=;
	b=IsIyZDiytnaL63Qp4yAq+cnxNvKBBlnQ1iFHNZh9KY+vl1Ooaxc7PSS5RLu9n7bqmSqCaA
	xCFfh4Vyxme3GL9vtuXQIc8+SKaAHBx3yyPM2q538tXjfKo06DvCyDi6E/9f/we5jOVCGn
	MFZTcLorePalYfodRKoaVgAhCzfPf40=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zu792+eT;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746653; a=rsa-sha256;
	cv=none;
	b=kvt+5lbn4qFhQkQ5c7jX+2UQ7DbRAjw7AhfgfuLM5tlhD097I4TGTabSCrybbKQmhK1HZK
	tMvFWhFLQsdKCoIuO9exhcqfAhnTzPHNrR1vrpLqEcpHT10J2/oyj9tQvupQeHcYU06Ydq
	t4o2dH9ge0pYXymx4cGU/6nnt7ZcTU8=
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-eaf8e473ddcso1460139276.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758746653; x=1759351453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRPftj4LaqpBRfvv5a/Vndy5zTyggHCJw7J9EdAecUc=;
        b=Zu792+eTf4QLMeC31b53+bC6PtFUD1J2WhsnOND5UCeNtA3HiOWFclbeba6XS4VTCN
         S2nhfWhF+7lhdqTjRxcOKJxG1UBZhGwHFNoLc5ePrm7sb3o0mlrDYsH0pVljHumtqoPO
         uCIjnTtG9QNxfbmDP4/4pcp8+OnrCu375V7e9MKG42TO/7HEUv0CDb3LrUhObzXKJnnP
         HAfTg9k7BTBQ1x2mVNFKBMet7RnA8d+Of9vouN4n/ipXfmJIY8qxhI4kWXh3rS/q4fgP
         3hqf+ZZHerDldyZphtqRmde/HPMGwDk06D6djayuXLwE8ieH6y7Eanf3rw/f2EINmEiP
         yJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758746653; x=1759351453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRPftj4LaqpBRfvv5a/Vndy5zTyggHCJw7J9EdAecUc=;
        b=Ld84K8TcE8jbkbsNLOHsg5pkfQoanhPDoOvg6+qrRYRC7Ktczqw5G8GQSRXSyuhFS7
         5wUYLXfO585p05qb/nSOrfUIt5i24/T4aMN5ZrqZTP0ryk79RAz8oEH9Jlv8UpfyAMrN
         fsJawwaOMlFDiF8F33E19H+rZ7wIH1dCmlSW8R8/gQ4B45sele2+S6GvhVN+qaODM9Tw
         M9B7RJf0T8FxmXqT6O/0EospDa37hL7sZ9w5g2sE96JTVDY3WKnL7gR0FhFQwyZ45K35
         XtguMOtI7Soketxit4bftathF1n4IxnPhCqeAKYokab3ubH/LUqMjXl9dkhemA1fw76v
         sBOg==
X-Forwarded-Encrypted: i=1; AJvYcCUru6TabIHfZkhJ988HhGKFpWNWQ9OcnxLerXHq/r1LKqhGSqW2/iriABgEY/PTZTLPJCcot34OAg==@kvack.org
X-Gm-Message-State: AOJu0YwqBnjpchjkU/2JOP1fKSJjAKSJu3xP6/j1rcRF6vRTiW1Lu/98
	K40ryArvFsLQ/rJOMC1ar00dibUMMcXPbmOFZRnNUAFTP0T5omqlOebW
X-Gm-Gg: ASbGncvx9Oq8YcOC0Xy9aLIKQ1tcjUrt22Fl4W/3W8QmVSUAyn2GcFU/sA8ptpqOOAn
	R1gE90orgeDQqn5R89V+JtO74YGnqKjdhWRM1gqOAXr75PARe/5R+CzPukHOWfn3us92iHZBCVd
	06R2SkxsDtY2a9/zBZjHlxyGjoU+0Jw+1WmKP1PWoY0M98+Nd2RFA+DwKRnUwVjtQgihvhQ7qWH
	3LvxVJWnjc9oWiv+kTY05q3R0wvC6XBA8aRxDDaRt7h8gHnCaYo5c0122l6JT0KsgjjGEWl3oix
	U8JBz5kgAuzL7ZOg7eWfOUr87BpObLh9RVga5U8e9ifcmAd16dUU5m+40TIzJjMnFuZ0IPNVBuG
	I6fFgsJ2mL23rBPz0KiNexLoBRQiO83pKYR7srJQxzg7+jR9MgHCfzzgK4VhPMaBIOaJ4HTAX
X-Google-Smtp-Source: AGHT+IHfhhzK64JkchKmyZ4OxX6jC8GQ8iup5LOuPMS1FSzRPwBkHev63GwoqUvBPaPAxK8OGtVKzw==
X-Received: by 2002:a53:d5c6:0:b0:635:4ecf:f0cd with SMTP id 956f58d0204a3-6361d701cb5mr118609d50.25.1758746652609;
        Wed, 24 Sep 2025 13:44:12 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6361e8c25dasm6544d50.4.2025.09.24.13.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 13:44:12 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Wed, 24 Sep 2025 13:44:06 -0700
Message-ID: <20250924204409.1706524-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
References: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 90067140009
X-Stat-Signature: dgokdshpi4diwcxjr5z94r3ako6oodrx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758746653-2729
X-HE-Meta: U2FsdGVkX1+zQoU9kNaRVUPYK0yKHMzl2zLfknc2kWQaxPPUqRXpRYW7/VHFTj5gBCr0cXebuoJuqaPqs98scJ5yjs5u4SyMSXo+2er3i7xdOyLjPvTUCq3f8shxTWeRACT9tNeEx0ipmgKNExIaNYDYGo8yJ/2IxCwUdw9YRUJY58mBnDqDwCnS4r5TE/kK9R7cbnopCwiQ6s1ok/M6gEHZ+zJebMMgJajhb0YqdMnE0/vgWNhN0C2iASLFtZ89KtsTgjm5rhBaxAszBK1IHbGpX/SJW0LzrvR23nicg7fSKjO0pDaTWSaQ248gZzx0GqcBI9j4uoNXpvr0DSNMNuUGvnt58NE+ksGfsExSdVcDbZ4vSW7GDfrb1pGdLjgzFrB6jeiyHVxkSlcSysWoUyv/Fa0CYpsr+b2TCOZq8ZkoMP++wz57jQnP6kqNvKsuGHXt00BD2uttGvbSELp8+gnBvN5Ef+RrFPBYdc4H+K00f1T5rrBbzI7EueI//uVG8Kgs0OzAZysMlLgBxj0AbCvJqmoiPDguT/52s2b2a8SNHnArtX1EuZhA1BHOBAddt+AXGDmYn4I96JCMt0DP5YxtZj+9HcdGIIGiJ87TMC5adzN0t6LxXYTZrSY8KK2/OkMV9KtxtuXOr/q7lKzIUyk5C8AgIPLY3OnQbIiOd3t51CSiSWuYGZd7IFzzebeh4Z+jQ+Le8iaI6qSHZQpl1rKUODKpAo863dpBSwXGZf68HG3VJIDiCaZrPk2fn7XuD6sURfs7AboQ1ymwA/SNxt51uuL/Y6MUOMB0dmPR4dl7s1OtB3PaBTeqVQiFeSZxeEOVCWYAvuEfXtl3ewfJxPEhfLEEY7bwpduoWg+gTwTnc3Gux5NUA8ga3PaU2dfVnHluMMzDa6y9G1YqYLAwTfOQI0n+lH+J3tF4Z1hm5ArJVO1wI7LtAvz0m/fHkC2lr59HaWANIP6d+yE4j5l
 w7+BmCrJ
 AZIW1m/grhQXGHK2feTr/nTg7T1E9WcGv8yUD5ULe/aNf7D89LM4/iL2BvChxwvHCAQrCDCcjxqFMe7H4UCfO8Ur3xok2NMs2KTcsAcFX4g4ScDrwnIsRy2HaAYe07U9AyQBoAiIVSnWp6Brm9zmVkizsX4DwY36i7sG9Qms/m5askcRflwxG3IGsidRrw3jeJwpseAqsLB0tRxG3ogw1Zx3fx6u5PpLlpNx5/SI1GwyigEM/JtatA4BDHPBd2Z2SJWhmMTEPJpl1S8GqMo/EjogoHJWT73xNeyJb6sUQHeommtzdiwDMwRcELDp2w6lCWffmJzifKsbFipLIF8EqvrTORr4qqHzXNzmPm68zS1UBiW5jhr+ogz+31BtjYZot8tE+cpbb71JGaVt4bXluSCY8Us9rR46fqkmBYlVUr+xpG0yBvk0OpjCwlSTVYiE/8m/8NXrkOD1fhs3kfrRTiEE84TUoNHjtwr9eXfI2BZayGacMclrO6AqGwyFSZcDTcmpcY5XWbRyBGWFUVXqXldNG6HALh8VpFmkuCLjRxLB0ECg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drain_pages_zone completely drains a zone of its pcp free pages by
repeatedly calling free_pcppages_bulk until pcp->count reaches 0.
In this loop, it already performs batched calls to ensure that
free_pcppages_bulk isn't called to free too many pages at once, and
relinquishes & reacquires the lock between each call to prevent
lock starvation from other processes.

However, the current batching does not prevent lock starvation. The
current implementation creates batches of
pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX, which has been seen in
Meta workloads to be up to 64 << 5 == 2048 pages.

While it is true that CONFIG_PCP_BATCH_SCALE_MAX is a config and
indeed can be adjusted by the system admin to be any number from
0 to 6, it's default value of 5 is still too high to be reasonable for
any system.

Instead, let's create batches of pcp->batch pages, which gives a more
reasonable 64 pages per call to free_pcppages_bulk. This gives other
processes a chance to grab the lock and prevents starvation. Each
individual call to drain_pages_zone may take longer, but we avoid the
worst case scenario of completely starving out other system-critical
threads from acquiring the pcp lock while 2048 pages are freed
one-by-one.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 77e7d9a5f149..b861b647f184 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2623,8 +2623,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 		spin_lock(&pcp->lock);
 		count = pcp->count;
 		if (count) {
-			int to_drain = min(count,
-				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
+			int to_drain = min(count, pcp->batch);
 
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
-- 
2.47.3

