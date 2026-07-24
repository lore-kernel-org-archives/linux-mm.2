Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B8CC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 05:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8A16B007B; Fri, 24 Jul 2026 01:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469576B0088; Fri, 24 Jul 2026 01:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F166B008A; Fri, 24 Jul 2026 01:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F30326B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:37:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B1FC1C0417
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:37:10 +0000 (UTC)
X-FDA: 85022561820.04.7C92878
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E7D5814000B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:37:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MnLxdN9h;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784871428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJtbvJ1YpwlbmNpCTYOzLU+4UtJm/ekub34SmAtyOvA=;
	b=AyQ/BRXDU5dITtirNSo/qbiXpURI3eYNOyHsT32hlABehqh44ANBlEZXaSh1+Y3SC+ktsO
	nXen8dT3H+zKhBlfW/w53gc2Lr2480955CYDlS9c5KzWjm5lnxQv+fDOXH+fH6uOiE5/Ay
	HLeGFo0o/0rnuKrKlQUML6VSXPDMYnM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784871428;
	b=NpE/Fr3cICCEtbXpDx2UmbF5M8mYlgE/wtQ58UsdBmeceUf2jEwj9wI+QEpayPAgiIXrJb
	6NUJKunPfFB303zUPce9Yz8yndedOZ0wt7m/NP4ibScFzjYJJz2gRJO3uNm58Hldmg0AM9
	tho0YDhECNQaZjMR/5FXLRrY5b57JyU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MnLxdN9h;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D10043572;
	Fri, 24 Jul 2026 05:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598E81F000E9;
	Fri, 24 Jul 2026 05:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784871426;
	bh=wJtbvJ1YpwlbmNpCTYOzLU+4UtJm/ekub34SmAtyOvA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MnLxdN9hGGlqIFi8VE0gKP3pUPuVEzC6vNzl8hLsC6T/fK7yLqycMOyGXYaVGypVo
	 JEc3mJxsVwxN7qQG+homPj5qs+4cVW26R++IKAID02jk4nzYNX+n0vIPo+kLqOWomL
	 wpvvSFwgBWKlcHbCTtEC1zTDHvnMnYUeZab1okvI=
Date: Thu, 23 Jul 2026 22:37:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Zhongkun He
 <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>,
 Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 0/4] mm/vmscan: fix swappiness=max and clean up
 per-node proactive reclaim
Message-Id: <20260723223704.b030220f6ca120c53c2f68d7@linux-foundation.org>
In-Reply-To: <20260724033435.2573323-1-ridong.chen@linux.dev>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oswic9qamqck5jdpphpy8wmei1d8kacd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7D5814000B
X-HE-Tag: 1784871427-49230
X-HE-Meta: U2FsdGVkX18DiDnkWdchj+7MfkjkxEy2IQV9uWLrkFWxz5LDc5i9lFaj08eW5d6UihiTe5a4lmVf09AaST3PhubFfXI3HCH/3CrALkXFWPsJgoeGUBSILhSf3TBIfmjIuD6YOZbNJYviHjdlwwyImWjnzhNwe6w1pzRZ1Ph//sAyVP+fio8D8sKgw0ggMuDpYXTz5kBO8j3thVGHUMvYlosfwmn/sRUNb0MY6t/nzcAeUuTasxA0RcEaHr4nzAmnTva5vafGv6iRGv78pcRbGm7zd3gmJ7kHPLczqFS2uXmemYSzwMRYqtQEG5gcNCILBTbfWV/U7RGK5pl6RAx2fWAFiUgBnpVE/jNScUnS53E6MW/nIoVwrHZOe2Vove1ch40UXhbUfGhWWuCPOcTVphM4O+apwYOoZzbeIEWvnsVhqFsMSzNSR9ZEJvlvV8dQfFWuX2B5Mpde7fyLJWqUvf+GlCl1BQMlFMvb/gEpc6VnHFPJrfynqqe3YI8zCiFoPv62X4HyhPjL/pt7kNcY0N9+hlf+n0/ykyin2u7NvFz7S3QIq9SrrnsBW8cRGJ9ldjNeYmSXjHLhsHvA0EnuREjNCiEoR9pbjlfQ/3sBJx2ZpHAtMRkUxbr9ilv/ouw8QKfHNwLckOOaY9H2Lc6tCLnIB8ydfNFY4JhcjgUnAyreoA32EE4jqcpRDQTVgfrIPk5mBPbkD4ySx5wUyjSNUP6DKpdD1v6bpLE1RDL2yx3HrzHlrraOG6bhQ7tVeZZ0Jckf1whqy9FaRex4P2xYI8NugRM239l4auZNeIYjdMEbYisq8v3bZwwqqTSS4D3tpArSf6MaopDZcG7PNCt/1mlP3Er93HqgumzYwJOtv9cjuBC00BD8cFiyrnnx/vO50LhtDrZiNTT2u2dn08F+0wpEUGZx2Wl9ZJ1qoeoJ2uokAzCh84mmbpShnoa4cGrdTDFkpQ+NbV1cEIBZwXs
 mC/Xr3sG
 zNhljNBvX50K3lE1YV3+4jwwJnbjk6t2WAz2jjqOdk3sQKoG8H3N1KgkrDi81KHI5VV5vCsKZ+q6SMYk1AR12vc3MENW6MXhoSA9/qGcivksZx03OqkjXUZftuYlr0Q+FUYG0d0cBcDkeWwlfMfYnc/BMne+c5OrK3l6pxPyYpXbMl4JUJ6SXKZx9pAf7ay2v514FxkL85ahsQ8He6dXOFRbty5CpAFZqlO9KfG1T0OQgR/wQX/z0u59ACpmPVRP+S0oekTapBQQPs0kVQckgJXvA0KUqKGoaQWNv9rwIlYIUswmyTiiYPblPcOooOcQuyuxZIhLBU+Etc2raFtJdEaSMtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Jul 2026 11:34:31 +0800 Ridong <ridong.chen@linux.dev> wrote:

> Fixes and one cleanup.
> 
> Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
> sat after the "cannot reclaim anon" check, so when no anon was
> reclaimable the request fell back to SCAN_FILE and evicted page cache
> instead.
> 
> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
> callers can no longer tell an invalid argument from a busy interface;
> propagate the real error code, matching the memcg path.
> 
> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().
> 
> Patch 4 fixes the same "swappiness=max" issue for MGLRU.

Thanks, I've updated mm.git's mm-unstable branch to this version.

Sashiko said one thing, but you've examined this before.  Hopefully
MGLRU maintainers will consider your suggestion in
https://lore.kernel.org/8336e48a-ab3a-4db9-a7f9-5bb6af2b22c3@linux.dev

	https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev

> v3 -> v4:
>  - Patch 4: Update comments and commit message.
>  - Patch 4: Adopted Sashiko's suggestion to use WARN_ON_ONCE.

Here's how v4 altered mm.git:


 mm/vmscan.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~b
+++ a/mm/vmscan.c
@@ -2492,7 +2492,13 @@ static void get_scan_count(struct lruvec
 	enum scan_balance scan_balance;
 	enum lru_list lru;
 
-	/* Proactive reclaim initiated by userspace for anonymous memory only */
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), bail out instead of falling back to evicting file pages,
+	 * which would violate the anon-only semantics.
+	 */
 	if (swappiness == SWAPPINESS_ANON_ONLY) {
 		WARN_ON_ONCE(!sc->proactive);
 		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
@@ -2693,6 +2699,10 @@ static int get_swappiness(struct lruvec
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int swappiness = sc_swappiness(sc, memcg);
+
+	if (swappiness == SWAPPINESS_ANON_ONLY)
+		return swappiness;
 
 	if (!sc->may_swap)
 		return 0;
@@ -2701,7 +2711,7 @@ static int get_swappiness(struct lruvec
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
 		return 0;
 
-	return sc_swappiness(sc, memcg);
+	return swappiness;
 }
 
 static int get_nr_gens(struct lruvec *lruvec, int type)
@@ -4903,6 +4913,20 @@ static long get_nr_to_scan(struct lruvec
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
+	 * work when there is nothing eligible to reclaim.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
+			return 0;
+	}
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
 
_


