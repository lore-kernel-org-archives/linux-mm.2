Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B20B8D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 06:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C496B0006; Mon, 15 Dec 2025 01:46:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD4F6B0007; Mon, 15 Dec 2025 01:46:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC7D6B0008; Mon, 15 Dec 2025 01:46:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56DEF6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:46:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E99BA597AC
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:46:54 +0000 (UTC)
X-FDA: 84220772748.06.6A1D83B
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id C11024000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:46:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JfULLpti;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765781212; a=rsa-sha256;
	cv=none;
	b=vYrnFbso5S8KBeBpRHbB/JFHAdcQBJekCwMqHUVlSgm2Um+PfWK3+JZzCFulZXYwJKf7ES
	VecnUdX6omVJ1iO4Fd2pZXiJPRWO6RUmFTKP4swAvvHdOnV2zIO9nT+o2DbeuksH4+w2Cz
	B+TwQDEpW3YfZ6BISPfED3nlKxO+Ku0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JfULLpti;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765781212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RdoHM3mJ1jSMiyUaXuH436UztU0Bj9UASxNBl93ugYk=;
	b=S7p1WX1Uk+ethkAOaosSU7Tssj8sMHXWpUYGOqc06pDv11VSm1vBRaSzYs5b6b+DLdA/5F
	PI1MP3sbTZq/U0WtB9V6JVg5j6ODZf8TX4BZXxGzwjvQ/lT104ixADHBCBAJMbHxWLw3NC
	PMfAlHD71uqZwMnAvc2BjHXev81th5U=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-34c213f7690so1548924a91.2
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 22:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765781211; x=1766386011; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RdoHM3mJ1jSMiyUaXuH436UztU0Bj9UASxNBl93ugYk=;
        b=JfULLptiEyy5vRQak0ZHNke+wA0s6rOy9N23wTmULFc8hRXgL70s/vYm6zz9hOLt2C
         bDdcfxlYIx5om8dS6klAqeyj0KOZ5+9l3K3BAL9/F9V+YIScQcAwsLtGrmr45btcvUaF
         x5TIbCh9S0mNtK3wiRmMFUL8hYFQFNME8u4a6NMIsOVxI43A6OMGdUDAKKBW1xPROHVl
         EAirs/VP22jWehuJ6R0CXZooHiST1i362aIXCv+5y1grnl1kdU5BY3qoqCi2H1OTFKJs
         dONekDA0wcPrrcLXvlgEgt0gnHSsnR1BCtb2tz8D2u0d8QtcFrwgNiv7uAi4NWH5WkLc
         FSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765781211; x=1766386011;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RdoHM3mJ1jSMiyUaXuH436UztU0Bj9UASxNBl93ugYk=;
        b=OGYqiEF3EuApjMqjRSDWBuIqWm7IjunkVLwoft1xcqPI/VcK8s0qME8onrkZqO4V/V
         pIwCXt3y8CJebkPAydNlxbqkLPWs+Of/FdktOs/X074zSBQYhfYWWT3mmwO1pgjSWKc3
         JCcJnKsNFlbitZM5F4XU7qpVM5QycrwQv/v9SfNiBW9x+GZ8das02dbpM+pbbww3s6Ut
         u3ruiXp5G62jtgAPD1EkyLmJm7dTjc+GtvFg9BB/UOhp4070Fsy+X4gr0WPzDVzOdL5J
         8n4AJcpaP7erT72fOyCJeRN4spBLIX0/YWVYkA/IRhHGbr311jKmlrhqwRomG7tUeR44
         cnQA==
X-Gm-Message-State: AOJu0YwGDXyQ+CY701PUjNZmoYvDdW1tlQs8CNcLamnp1K9oeQiXiW5v
	jdH53dL2hrwcOuvJ7HpDWQ56iLpIvo03AXLWF151PQ+LB8/GP/YsEIIJ
X-Gm-Gg: AY/fxX4Gx9dNjaDZyd2Vshayu04ICmDFaQcAu2ClIR+4a67KSo46kR/CJGzTAof5gRD
	nm/bX6Mn8OMBL4g15CA+wXlUQg/WF4NmA/nqcq6xXq24YJhI2gxb/GbpudT53A789M63WDsW7YY
	IUwpq9LtZ7Wenbj4PjFQVgeLOktWWtMDugAAYvX5LgruxMpDuz3hMV8IkIzK2/eFS/1Zmeae+wU
	o+GMmgT8LctdM1o9UHbaxtf5YKJwILrILCVnX73ymVWXZ7Mai7HEdkZ4okcHfP7RaI7FUFMkO/4
	5ngmqdn/+aiinN2tFwKdLMlssxKfqxJ6uculHjp3qrnp84UtnaJR+1/JooQv+EMOAPcCQziYSoM
	wUwgPKEq8QjH+oE1nlpvV/3U/W3ZODW6xAv/qT/jfORIFAFcsNgp3gpkkPrYGV07hEveZuFZBAl
	gWOv/hpbWBSd+/SrKKr4zKkTtyQ2nS/gjV7UqV/jtTh2K68gZDQdTasKe7ig==
X-Google-Smtp-Source: AGHT+IEWi9rpszfpsJIcG2AJbfKEy0KXwGK5j/XRhgO6Nbp+mDcp1SVnXoHwY8h/edXRSMxd9U9F6w==
X-Received: by 2002:a17:90b:3f0e:b0:340:be44:dd11 with SMTP id 98e67ed59e1d1-34abd77b410mr8852050a91.27.1765781211469;
        Sun, 14 Dec 2025 22:46:51 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe3a2623sm7958018a91.2.2025.12.14.22.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 22:46:50 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 15 Dec 2025 14:45:43 +0800
Subject: [PATCH RFC] mm/memcontrol: make lru_zone_size atomic and simplify
 sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251215-mz-lru-size-cleanup-v1-1-95deb4d5e90f@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MwQpAQBCA4VfRnE2ZLZGr8gCuctDsYIql3Ujk3
 W2O3+H/HwjiVQJUyQNeTg26uQhKE+B5cJOg2mgwmcnJEOF64+IPDHoL8iKDO3bkkqwwjza3BcR
 y9zLq9V87aJsa+vf9AD31WalqAAAA
X-Change-ID: 20251211-mz-lru-size-cleanup-c81deccfd5d7
To: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765781208; l=3839;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=5Z8c+a+3jENgLhaYOexfVai00HxxbKrt0eKrdFBvjVY=;
 b=hybdzQeGCdI8OPofHO1fIoNFOLIcMOPPjiP4OyRefxmYv7dtly8Ya5ok83UtN0DMuYhqmm5eD
 9BG1NGYsq7BAePb9TvwgkZAICg5q8vYAqJ7baR+K1tc/4wQ03QkPbVL
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: C11024000C
X-Stat-Signature: hh4ycoqanxd3b4ja7gbd6adaqxqz1kha
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765781212-970507
X-HE-Meta: U2FsdGVkX1/W5SKhe4dtRCtp527qA1fXOSde2HPnlxuR88bdYRtlooKCyukATPWDHjoJAF+iDmANoQAyYZfRsoqkc7tQvrHkSOPvJYzdbOumsoMhI9v7GbbuHVUVSjgx8PvD3bQiHk/pWKpCdkhUtuiJzeK05fk+kMPDvkV5i/vV+aCtH3nGdddSXrD9JtOs9sdHzsJTWgO5CpSJDKTQ+tPAeWsmjoosJqI+/4hMSmLcStu4IVldD8snGvRb58h8r5E1u6H3Ul+v+t0bBcGc0Q5B0J6F8r7W8qzJO9RqWctitUKsJaJufuWOXCcqdI4JJdh8EX6A4JhCPRt5xlJ3IUJKIge58uYBqo2FUjgsypskMDvtjhnnrKMduJb5pOgrNQAVuIL5jkL+DTdjxAw707UmAl3x4L27fYJjKMC4RFN4sw3Lefzuggspk3WGgR+8QDUatiyWLUdH6fF2iNrRxVd9mist2BXLD0xXqFv0lWUrhFdZdC1yH49RthW+w+Caclo2J7PVRS+YugdqwbKAHxsEtat8iCVUBV5IU9JYGaRJ1AoPg21xxzV3RwdZ4Mi2V4KNEkgJdH7sqRaUWzqxVWi0BSdGcSmFUOBwe8V+H0WW53G4x3y+UJpLZwTwjE53fJGyUF8WzztgSfKEixjU3XImPSE4bgaJpKsJ5DKQkfXMTsxCTo/hnIGrLRwmYjozozHI9ROWsSB4u0HtI5SnHjv8EIfjXVuxerHCDGcX5IwC2EawyLS87Bqyk7OhV/uY1Bbu76NdZAt1raT6kMLYfXqdY4cg30NXvcjcgxCYK0zjjyroHdESCro9rxx0p2S8L4WD5ENOl1kCleysXQxI5n1lrb6r+7c7TuZwQc55L8qPECo54t2ULJVDjLVjEudDPiU949VH7ltIfy4zq1X8n7CTkCtRKKTHrbCYYwiB5uw6gYg2Z8Tw9aihssi5Vadjnh20BuJPS7K6CyG73+y
 VgZK0Kd2
 bM4DJ3PJ2xXPp82dh3sdB4bUWA2OvogmWaCUyvAoYJFbUw5ZPj5Yc6IjzYpP+tpDlm+1PhBMxF4mZsPQZTsw/acYehzbMeEP8uH9Pcjaa6iuPwprWUaA6Spd+VwuqniBca1ptFlemZvQFE9CoCM9BYt8Cvc17uv3Pib5IuSdAHNmoc+AUR/f4ygj7+Q65M5etIIWctqH70+TUQrUmbVsbMJV1V9Y96OsW5+Y5jxukdd9MXXMACZl2Mn5AlLCdZMXqqCvxqbDeEIa26NYb3xuZi95wKxJiug3aQqWEOT6Niz8OCWsHja0pi/TsOwrwpch6FzMlkX5h4lkk5TbXbbR6HF4y7Uvj8jcJ0nx8wSIRzB5JYf8lDAYMjl9ESXkc8tIS7XVle7mC7Kj2nBrZlgo3A6nZh2xx7viKipEwoDn6nH/wpxIREZXq0SYTMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
introduced a sanity check to catch memcg counter underflow, which is
more like a workaround for another bug: lru_zone_size is unsigned, so
underflow will wrap it around and return an enormously large number,
then the memcg shrinker will loop almost forever as the calculated
number of folios to shrink is huge. That commit also checks if a zero
value matches the empty LRU list, so we have to hold the LRU lock, and
do the counter adding differently depending on whether the nr_pages is
negative.

But later commit b4536f0c829c ("mm, memcg: fix the active list aging for
lowmem requests when memcg is enabled") already removed the LRU
emptiness check, doing the adding differently is meaningless now. And if
we just turn it into an atomic long, underflow isn't a big issue either,
and can be checked at the reader side. The reader size is much less
frequently called than the updater.

So let's turn the counter into an atomic long and check at the
reader side instead, which has a smaller overhead. Use atomic to avoid
potential locking issue. The underflow correction is removed, which
should be fine as if there is a mass leaking of the LRU size counter,
something else may also have gone very wrong, and one should fix that
leaking site instead.

For now still keep the LRU lock context, in thoery that can be removed
too since the update is atomic, if we can tolerate a temporary
inaccurate reading, but currently there is no benefit doing so yet.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  9 +++++++--
 mm/memcontrol.c            | 18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..197f48faa8ba 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -112,7 +112,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
@@ -903,10 +903,15 @@ static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
+	long val;
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
+	if (WARN_ON_ONCE(val < 0))
+		return 0;
+
+	return val;
 }
 
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9b07db2cb232..d5da09fbe43e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1273,28 +1273,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int zid, int nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
-	unsigned long *lru_size;
-	long size;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	lru_size = &mz->lru_zone_size[zid][lru];
-
-	if (nr_pages < 0)
-		*lru_size += nr_pages;
-
-	size = *lru_size;
-	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %d): lru_size %ld\n",
-		__func__, lruvec, lru, nr_pages, size)) {
-		VM_BUG_ON(1);
-		*lru_size = 0;
-	}
-
-	if (nr_pages > 0)
-		*lru_size += nr_pages;
+	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
 }
 
 /**

---
base-commit: 1ef4e3be45a85a103a667cc39fd68c3826e6acb9
change-id: 20251211-mz-lru-size-cleanup-c81deccfd5d7

Best regards,
-- 
Kairui Song <kasong@tencent.com>


