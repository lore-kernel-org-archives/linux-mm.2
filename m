Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64124CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 18:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8CA8E0014; Thu, 23 Oct 2025 14:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9FFE8E0007; Thu, 23 Oct 2025 14:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD908E0014; Thu, 23 Oct 2025 14:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7798E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:01:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60FD3140BFE
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:01:52 +0000 (UTC)
X-FDA: 84030147264.15.E86D1D9
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 785411C0017
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:01:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Eru3QYN1;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761242510; a=rsa-sha256;
	cv=none;
	b=GcBU5dcGJm9sYIF51rSvxYM47ki5yS2Ilh/JJzIq6IHQ3QTZzI2bJH2ljdpa1pUfQ9cYWl
	ORQDbJTOSZwtUy/v0ouyp+U2MzPhVXSd/ccWteRkiJU0YlY846rwzkPKRPl7b9hKWRJ9Q/
	9+bn9dtkjZ1T1dovUXn3BY22iFWvcN8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Eru3QYN1;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761242510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rli7uhqVcojZxMXbHTMs9kk/hCHNAWNyDYe99kJqQ4g=;
	b=mnWo+Vb9pfiehz6u9CYMa7sDzjOkCiDR+9+Z/zOQ1fLvcMgSF10ImNdcaUqDQNqje5Ejcd
	x7dv6mXz3+Q+RdMgRPaicgI1yAXbv2KaG2iYyem0PeaZMBgPU6FruIYcZuV7MWqWFpDu4n
	ycd87enpHZt5hkFPEpo2o0YUMJHmmGQ=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77f5d497692so1445299b3a.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761242509; x=1761847309; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rli7uhqVcojZxMXbHTMs9kk/hCHNAWNyDYe99kJqQ4g=;
        b=Eru3QYN1idL7ClHuPwP6Ooh8tWfzQXmXdi8nE2V2wbjdAQlBuTdqF9XdVlVnM77Ywl
         e/UkZqZ/xfmZKNpfvePuFNZfHXDrLAZJcbrv4q92AD4B+5XjI8/+V93BZw4e4KKLKMYf
         fDZiIB5KJ9hY7EjQ+npDHlu4NoOq+OqPeuhlt/Ot1gAnmUvxfvDjjc85dng5smYAemnD
         nrqelQA+SOOPrHEvkqlNF5Wl+KgNrw7S39QGgAPNyWq8KbyqDNcyNqgH3hEbGmv+Fg3f
         m+ER6q1qKFHgWZoLXuJrPVA/VCrkyPgmNsH8SXRh7PeO9QxHjPnjpIJ3ypGhcWHDr2Uh
         yOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761242509; x=1761847309;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rli7uhqVcojZxMXbHTMs9kk/hCHNAWNyDYe99kJqQ4g=;
        b=tqRxqqJO5goo7nr2DQO4p2j3SrGlXWHP30mbpGpYG1JiCxtb/PL0KqGkbO7etDVzRu
         XSGARmVNjRuxVbxlCnTloeohb+xhHuS/lKv/InjlwLbNk5UowkeMWrQ5vZkRIIxRB0Th
         zKXS6iTMH9QpekviEwSYNksph09MKKouqYpDI6W/ZYU7Hr21MNPp1mfg/WXfkF2GCCOz
         ROJOX8O8W1IHxEoclSde6ld2GOUhpTuZog70F/zD7egD/f1zZQ2W3UWZsuD3VgoxbIwd
         jrpHgXHgqVJ4BR7mw5OinfC/NoFMUYAl0Nlqsnec4ILfgZJ7wjl491yIEfjbMk8d/4vN
         3oYg==
X-Gm-Message-State: AOJu0YxXEh+w2Wy/w37ElD155+N1WS15ApuZUmc6Z/F8qJcuUNMp/200
	mZn7h3unNGn5UU4wDrXB0QNqjTSzYvJ3mWBIjScB9uHr5I3FbKEoY8cD
X-Gm-Gg: ASbGncsScgc9FSuI/ToOYN1ZBPGy8Xi+1zZ+D4cqb12eavj54aKCe9tSc5MCouWRaZI
	ZHCx7UAZJL0qxdOVliV2hFBQ0YCjKIDMfHnPnyj4LQ5P7jOodK5jzQirMXF1CPCofpbOq9OdR07
	XyI2KDL4C2RtVbO8TsCepWt3A1xRQ+/Coa5fmGEsAAsfhv4R2v5laEqBIg+K9Kg5w5OHWQIWgKY
	b967O67S9eSy9ayPSpCDKRO/c0teZFPwzgdUuqzXFboM+5wrIITlR+P19t6oUiwMvlATrdVRnhI
	gAJtFNlrxoiW4YSiCZs+vLi9cwjjiJtKYKE21XfMq4SoSIYwROrMJKQ/o661vjX69qSV7S4Z148
	1b3y0hAKFsWb8mP4FktYg4hEBVcRedlsapqBwUu7n0DBfe7vLl3WSIrhfSXV17Jl/gdZCz6lAp1
	s88EKG2g==
X-Google-Smtp-Source: AGHT+IG6uTG9VHUgkfPXj2XEVa9LczRPQpiJM9vHmjW5NJQW2nrH3Se7qga1hxc30sJPG3cs6umW5A==
X-Received: by 2002:a05:6a20:1588:b0:334:a710:14a with SMTP id adf61e73a8af0-334a8630420mr36491423637.42.1761242508512;
        Thu, 23 Oct 2025 11:01:48 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4c4d83dsm2734532a12.18.2025.10.23.11.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:01:47 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Oct 2025 02:00:40 +0800
Subject: [PATCH v2 2/5] mm, swap: rename helper for setup bad slots
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251024-swap-clean-after-swap-table-p1-v2-2-a709469052e7@tencent.com>
References: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
In-Reply-To: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 YoungJun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Stat-Signature: 8qc997cjpo1webs4m11w5r6db69tixbw
X-Rspamd-Queue-Id: 785411C0017
X-Rspamd-Server: rspam09
X-HE-Tag: 1761242510-911139
X-HE-Meta: U2FsdGVkX18MkvWnJj9sIbBje1rwNQfZoI3cA4RRHgxm2XAqdfdexK2USg5JtuKAawEYk56fIpdWwt0x7uWurgCjLWlbqZIiufrA2mtUi9j9J9Tqi7fWBDZsYp3J11pHvXo6HpllAeYzmrLh0YPAqPZEL72rxj+ibKBP19t4HHB+iI6t8EDxdKFeZrN7hyjnV+Nud9c9hCK0iHP81oHXJ4s4y25j5IGtDxGvBvdyY/mNBz0P59zh5Sr141d5kvjHG+nISvUxmtbern3yLUuX+sTnbC0IrXXHKFoRL9B/5bmjoeJJE60E3EwvrpSisQow2Yp0TEWMZkSQwjRiRuQcQ0bJXGfVdQXqELjMPnOhWTbauWqCotl0zuJH9PRw46PA/Qsn7ww/bdhzfPFiyqo4NDZpTSDBhUAbtweAuwfxwg5nFdw/xW8oP3kidfKAp4aS0fCQCi4Y6qL0lq1A4nf3/GMivdDtBNFF11WOZNwHx96NjWIChxBWl5jJgcR3njAu9x5DXefu7KZQHXAszun36hOXe3vIoA+TDuxsm52n5z0DcIVS8YSmJHvT6K7XQLy0g6ekxgDn0Y3HgPYnDKpOZsfKQUqmRQiD342/ypyoiWd7IToX3WJzhP+/BRum2aD6Q65ER9ipvjJOVzvlikvIDk7GmhsnlOS/aqu0W4clt/KXkJrWzirph7KdID7atpS9aDxfqXRSjt/FpgkuqfN0+6lozCZgAd9983wJh7eLgKRwbvyNjJhwFpmbE8/D7LHX64lyTGqXj+EGwcQwkX0g0mXG/CFyCq1y5RqQj6xdVKmmIhXlKF4+qJ/t7fG5v/xdZPP01BNKDnsSi+HjFlKGfhh45ejYVqvnTZxH3WTlJCKX5mBAHgvYkb95D5kMZhwwOhIlgMKn3dBy11y7ZSeUgohx+kxdxWWiHA+uieLxRw4ulq3NwwSsol6yR2iVrxMwn09Bw6y+0uUtdsmkarI
 7TCWPJ05
 /NMs9q+doq231/YDonQA9Ghikd0Uir5kU9X3h3b1en3H9UdFrr36ikffdZwsH86+cyQRaLiR0NZwaX9wV6Cn82IJdB1ujDkDBF5NMJgYkAjS697cFRt95UBZuAc2pF5Wb7beculpwWTbQAXIRAgvyJ5aQY2q3VJHzQgikXlw/DEhuVJZRE9eyRR3N0uYZPN8oL5k+KxbA1ga0p9Du5CpPnupDBAD8AEGO0etylRWhZSHrkoXPwmD6eXVr3l80ZPdg8O5RirO7/DCmC/JRsd/oCOhfwl3GMBS29LW12A8taNg7lpupwaAQHwGT8CQ11QL0kryevxUdtHv2tMLSJsd7zCdk9dsvbg6R/DPMPMpVh7Ot0uNlx/H0LFIya9nEIB79EjwNtFvgJUp81V4VKm47Q7ME8gkLkQOarHmAqlHDqAC5bA/6hfn2yjDjhzgvc0xL+MNcQ8lWNZMVwrmvaXo/vnP5keYxzXJpMwmFAY76eZT+wRJh7IrIiiq9bQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The name inc_cluster_info_page is very confusing, as this helper is only
used during swapon to mark bad slots. Rename it properly and turn the
VM_BUG_ON in it into WARN_ON to expose more potential issues. Swapon is
a cold path, so adding more checks should be a good idea.

No feature change except new WARN_ON.

Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 35038a0871e1..781a70dfcff1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -751,14 +751,14 @@ static void relocate_cluster(struct swap_info_struct *si,
 }
 
 /*
- * The cluster corresponding to page_nr will be used. The cluster will not be
- * added to free cluster list and its usage counter will be increased by 1.
- * Only used for initialization.
+ * The cluster corresponding to @offset will be accounted as having one bad
+ * slot. The cluster will not be added to the free cluster list, and its
+ * usage counter will be increased by 1. Only used for initialization.
  */
-static int inc_cluster_info_page(struct swap_info_struct *si,
-	struct swap_cluster_info *cluster_info, unsigned long page_nr)
+static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
+				       unsigned long offset)
 {
-	unsigned long idx = page_nr / SWAPFILE_CLUSTER;
+	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
@@ -772,8 +772,8 @@ static int inc_cluster_info_page(struct swap_info_struct *si,
 
 	ci->count++;
 
-	VM_BUG_ON(ci->count > SWAPFILE_CLUSTER);
-	VM_BUG_ON(ci->flags);
+	WARN_ON(ci->count > SWAPFILE_CLUSTER);
+	WARN_ON(ci->flags);
 
 	return 0;
 }
@@ -3396,7 +3396,7 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	 * See setup_swap_map(): header page, bad pages,
 	 * and the EOF part of the last cluster.
 	 */
-	err = inc_cluster_info_page(si, cluster_info, 0);
+	err = swap_cluster_setup_bad_slot(cluster_info, 0);
 	if (err)
 		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -3404,12 +3404,12 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 
 		if (page_nr >= maxpages)
 			continue;
-		err = inc_cluster_info_page(si, cluster_info, page_nr);
+		err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
 		if (err)
 			goto err;
 	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
-		err = inc_cluster_info_page(si, cluster_info, i);
+		err = swap_cluster_setup_bad_slot(cluster_info, i);
 		if (err)
 			goto err;
 	}

-- 
2.51.0


