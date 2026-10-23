Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1475606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pJPHiHcR
Received: by kanga.kvack.org (Postfix)
	id 11E8B6B0C02; Fri, 23 Oct 2026 19:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0996B0C03; Fri, 23 Oct 2026 19:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F005C6B0C04; Fri, 23 Oct 2026 19:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C667F6B0C02
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:01:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E87D1202DB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:01:29 +0000 (UTC)
X-FDA: 85355414298.10.4F2DE22
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 767AE80004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:01:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pJPHiHcR;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792796487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8ZSh14dGLOreqW+nQCMXUqGDN+9AG0Y4+BVPG+//OI=;
	b=ellwIbtZ4s+sQkxhU7cYsT1ttrL+Cj5BcUvZY30eeFDqM3MvVWQ641NcXfqSaE0CUbdvLo
	isPEdLjpczvcZTUAMoYhIZwZVQcUj9PN2TEuoGZwqSBTM/zSNGvtCfd7vtfivcVe2BTMoM
	FtVbXyjxGf67ZMuHTBX+VFMWeWTiCiE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pJPHiHcR;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792796487;
	b=8N3hjlDzXyJVxmIAwV8sXdHC2dYZs50CReKg2iWWE3jTJQ/vxtfylA4OwZJRyJiM5ClhKk
	h0o9Haw8++GJfsDOMBg60QuWD0BGaXXeWUneAo4njFm/C2XE5qeE4OUkmfOK4Tso/qLMrA
	bxjKDRcF6+ZWZLnE/owL3bXvDKJxOMw=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8ab395abf79so13405477b3.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796486; x=1793401286; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m8ZSh14dGLOreqW+nQCMXUqGDN+9AG0Y4+BVPG+//OI=;
        b=pJPHiHcRgsPdVPZnxxMnEuUVyLV+/tbo+kP7NIV1gJd96YGe9EFElG5Fc3LMzi6QKt
         29bUiMDo169i8Wj7d0bMOtSSedlhe0SY8l8b29se/y7rAECuYDxIRvR1vjlfFLadg6Z/
         VoP61DAn8tTEmQqprLZi8Z5RozDLwVvMWFMIlrmuVOcXbTKtkdETY9ohYbx/B/pFo1XB
         EOfTGbwRJG3qrlghZI6A4c600DA9zp6R/2hhCaLsUcdwq5ChkwVltxtCNCGNtGLkBkK8
         i4WryNPvQ0SQx0wGn/FMNEzjcXG1ZSHfyXXlR35vFpIlAtNMPIjZ/kvN91AcDM0+T9yX
         23LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796486; x=1793401286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m8ZSh14dGLOreqW+nQCMXUqGDN+9AG0Y4+BVPG+//OI=;
        b=hax+1tRobnzib28PnV0ttVzPqZHVAwsK8qy5F00w8WU2AaJ1PxLJIFiGlFBLAD9d/F
         Wbe/gAV5XbRwIUtk+OPAiu0ZpsrovTzLxHUf79OIZEAXLuLjisHPDqRd0GucXLM5ZRwY
         GJJOMO+Bgdr2npY9iSQVGneYdPUJoVmTv5RGtOwyUMFShQld9ueOZpOmb+l8vxAnUTXX
         9Pvx33q6wYrumd7ywYfbnYiglj+v6KPlj/6E1PlH4uh/HwjbJ6Ce9AuntLK0eDJ5kEbx
         NFYYyo8B48xjiAgOBIZZcKa2J7SDSI+rc+DuhgnEStw5zYsxuuzWy8/voNdg/vGZgry/
         9KLQ==
X-Forwarded-Encrypted: i=1; AKwUvBxvf1168jFTjIzsnHeYxMpsTj/uWkoWubuVfGpE5MvorlQTq1zT788EPXIHKxnDOWjysFTKi6U6ug==@kvack.org
X-Gm-Message-State: AFq9FYL55/VsrEnDqcxoMk4GmXZWYtN3YPr/I4RWWmcOJcq+rsKDT+Tb
	1iePtSU1U7UgEPkMXSXMxHxqo2rasM+RneLaozMqRcPPEVjB5W4Qw4/f
X-Gm-Gg: AYBFou1tHy889F/i52GDIQQAoouFteGfnPoNbNNIPACGONGRxF51Qb+Desm5X+1Mtp/
	AvOQBjkw6bwYokQT6mJd49iggrkviPX4U28lp9sfgtRUSdshpLtnDR/4OYk6LbpwlweN8BTtJbg
	lnKaYGyyPzEYipObYYjwpEbRduahjFZztTKrIiwmzaDcCC8f6g/Uqb/IiEUSuKcHHxLZwQcR+1d
	KEcSJ3XiD3nYxMpfhjw6x4OpPJ2fu8F6uhJEhwQCo+MzrQ/mXDENDMOhnvvh+LVnKQMuOCDV+WG
	v4Vd8GDAqjtLzfoCYvIosm7XkHJisYrEW18s+IgAhl4pY2VipUX8sIrDTC4XQpKPN62xX1NKGtH
	sk2KLlleDw/eRgvNettEzZcauDPPCmkHpZya9HPplqYx9E7+wIMsiGJG/b+Z2bmZylcW6FePlYC
	y535CurJXEmfQNqIDPdr4qfF4RDijHs9jmSJDaYARWqtDmjJo6mZu28ERsy3yAXd9xwr83D8Zv+
	98ofqYla3fdHhD5jsV1OAv++WKDKHysBVZo4iPY8Ysi/SShe+vYtnKqI3UBfhzIKXxnST/vAbxw
	GP4rXutrb/cA7bou3OHUIFMksESF
X-Received: by 2002:a05:690e:d51:b0:679:c12b:ec09 with SMTP id 956f58d0204a3-67a453d5e1amr478999d50.51.1792796486452;
        Fri, 23 Oct 2026 16:01:26 -0700 (PDT)
Received: from localhost ([2a03:2880:ff::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a45ff70a1sm240489d50.3.2026.10.23.16.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 16:01:24 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: baohua@kernel.org,
	usama.arif@linux.dev,
	hannes@cmpxchg.org,
	kas@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/3] mm/huge_memory: don't queue folios when underused splitting is inactive
Date: Fri, 23 Oct 2026 16:00:05 -0700
Message-ID: <20261023230006.3759543-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261023230006.3759543-1-joannelkoong@gmail.com>
References: <20261023230006.3759543-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 767AE80004
X-Stat-Signature: 97rjkozfhzgx8w4frrpjnium314xtm38
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792796487-663663
X-HE-Meta: U2FsdGVkX1/YxoSIFdpZUQzCTMP1xBdhSXc9Q/j8V/g5WRfMVdYIerXEahv2WMwBMFFKkaOBuTMXOBo0g4S98wYB6qg7j7GioW/g9iwj3onVkl0+uZIS/SZs/NR9s9OpU9VfpzUFvsU46rykXQoTI9JKwziFrR81V5UlGunpw1lG5NEJb2WtwiuTHXcgf7CwH590Q+VUJejqFMfmGy1cfDjZDXLTbAQworVz2AjsbmpLE69OEv03gkUidJKGTlnasug0jf4NTrXobRlpN1Mh2XpzRnM2bCS5N25UypiQqwrQJi+/lJKsIM5AFTRjLvPRFckPrCOm9+T2okNsM7DqDb0pHJFQI6K5Jh3tgBI+GFBbEJYClsmRbmvOvJ9RCl16kZT/oh0Z8PwkFcig7fZN5M3Yq8q55bM8uULTAwGzQoko3yr/jkQ9usJoA3V/FS6MKWqr4zIXCPJ4tVuPpnUggWbpRpUTuL4nRMCc/c7m0SIsWeO6Ar4+/fYYrrtlNwtaTqKrP8j2VLhM//Z88JJlSjCIiSQfVxJiG8rrY40/Vbj7k5jZLNL7cvsh0dmgCpdhxtH0iTgCptT4d9ZTOCW88CsVqKCh4H9C635rmcGUERnBxzKNefW+B/4oHF8B7/RHvdw3rMnlUbRtKU5nkLMSVwk1KTIsDqhWl+PHffVX6ohukiQzK6gP6OjnP0rkj/Ai8UQS2X/hwV30WIznHceHHXO4RnDxwKA4JZoIehpxke3jtyblMvKTXGwgUkbX/9JkRrSUo1F2xwt8+Ez76NYw8IYhkspzVOqQsOSWo2a9gQ0HKVNuXPYxfn6LtTq781zksDQD6+uqDK3yvJ1lgiH6gMKGXd72ZOl1GBJA9Z2nF5ynpqEQiE5Dy4smJPqJldmVboCgDLnirLDyTwhA30XC2HKZeQtERRkuxmlIZ3EDLMemTf6b2e4226Xhw7C7YrUggDyWBvO/cj5C0BAYPca
 rIn1vIwS
 OFQiBS2pDanYGZ6G7HMTKvABz42bZ5j1bGnv4awzWGiPvUeGR45DFkIuKm2FJHFZi/4yYmf6LKDKoBVP7Wm1SZRDY+zfAViz+i8buD82xMg7Phf0poLcyyn9/glNa2lW1DhmhWhGeu7cMHJOvzx6AYGsg26NxnbV3Qv6PUDbxkQPrN9qM89FshI6+XwyNxRyltLJFqYlqckHHtOePOlYHFGI87KFnD+h/yGuLgLBP6LVBpx4LlQEiKWaboMW4nuwzsOPkNWcOgblSKGerJhIoAY7X6xTXgtkPCfFMa00CZlrv73D2SB0OgaD/IFpnipe8jED3EJBoRB8BtDmHylxn9ClcKt7ffeu1TPlvZd5bYWM/QU73sbh1Ae2hZuJGsMA8F/kKxbA1atokipLxFXJLxkheEm5QawValwmqZww9YtC7gRVpPkvQVNnJjEzF6ualSZFLsFb6Dbh1ECP27cNmgPFdvn7yHtILQ+HW1JKKbM+64fW18I1T3aJA53jM4oXQb6pG2olmdi2YRSTKotcoYxuo1LWd5DwJNCYssg+GmSZKh+CpcNB3IoatefAd/Y1ZQle+JgYWsIpnDQq7mwQ1McCiS680jlMw68ww
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every anonymous PMD-sized folio is put on the deferred split queue when
it is first mapped, so that the shrinker can find it under memory
pressure and split it if it turns out to be mostly zero-filled.

With the default khugepaged/max_ptes_none this is wasted work. The
default is HPAGE_PMD_NR - 1, which tells thp_underused() that any number
of zero-filled pages is tolerable, which means the shrinker will never
split any of these folios for being underused. They take the list_lru
lock at fault time, inflate the object count the shrinker reports, and
are then walked and dropped when they're first scanned.

Skip the queueing when khugepaged/max_ptes_none is at its maximum, and
factor that check out into thp_underused_never() so that
deferred_split_folio() and thp_underused() share it. Since the default
is the maximum, out of the box no folio is queued for underused
splitting at all, PMD-sized ones included. Partially mapped folios are
still queued as before.

This also matters for a subsequent patch that adds anonymous mTHP folios
to the deferred split list, as it keeps systems running the default from
paying for that on every anonymous fault.

Please note that the queue has always been best-effort. A folio that was
queued before khugepaged/max_ptes_none is lowered gets dropped from the
queue by the first scan that finds it's not underused, so changing the
sysctl has never retroactively applied to folios that were already
scanned. Requeueing eligible folios when the sysctl changes will be
addressed in a separate patch.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/huge_memory.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 218259940f24..f758cc1e34fb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4552,6 +4552,15 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	return unqueued;	/* useful for debug warnings */
 }
 
+/*
+ * At the sysctl maximum the user tolerates any number of zero-filled pages,
+ * so no folio is ever underused.
+ */
+static bool thp_underused_never(unsigned long max_ptes_none)
+{
+	return max_ptes_none == HPAGE_PMD_NR - 1;
+}
+
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
@@ -4567,8 +4576,17 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_order(folio) <= 1)
 		return;
 
-	if (!partially_mapped && !split_underused_thp)
-		return;
+	if (!partially_mapped) {
+		if (!split_underused_thp)
+			return;
+		/*
+		 * Nothing will ever split this folio for being underused, so
+		 * keep it off the queue entirely rather than paying for the
+		 * list_lru lock here and a shrinker scan later.
+		 */
+		if (thp_underused_never(khugepaged_max_ptes_none))
+			return;
+	}
 
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
@@ -4618,7 +4636,7 @@ static bool thp_underused(struct folio *folio)
 	unsigned long max_ptes_none = khugepaged_max_ptes_none;
 	unsigned long i;
 
-	if (max_ptes_none == HPAGE_PMD_NR - 1)
+	if (thp_underused_never(max_ptes_none))
 		return false;
 
 	if (folio_contain_hwpoisoned_page(folio))
-- 
2.52.0


