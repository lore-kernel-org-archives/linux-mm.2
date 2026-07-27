Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98388C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 11:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822D76B009E; Mon, 27 Jul 2026 07:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB026B009F; Mon, 27 Jul 2026 07:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9EE6B00A0; Mon, 27 Jul 2026 07:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 306E96B009E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:37:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 849EB1C04EB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:37:40 +0000 (UTC)
X-FDA: 85034356680.23.2AD07A3
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9AE1D10000E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:37:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MgksZpy5;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785152258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifEMtdw2Y3LJzGTrNEzkInEIHCSbSBhJKHBE4Huj/fc=;
	b=HS55WQ5Q5aK+PG/ZzKW0VQ9/n9ONtr+OgIzcFQqUQDmzorQInmb4jnYEwAbqlGG/sknKFw
	99xYvHAVLF/1aC6VR2LT4dFxwsgLQVuHibE77Sk6lCtzD30D4fwKtjy+nxKinYqn6yznzL
	4ONyXvn9LGMMnTA005LMRPF0iwh3510=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MgksZpy5;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785152258;
	b=pt+RrQQAgkNXqys3GiYKJHufl0sd2wmMYS7iqQkobqEqbUFkzXOFBVfe0UFgOcIUKXp19A
	kHJ9gu4UFxvoCz0UJtbbPifFkAvNp1BMTZPjJZ5PqFS2I+x8+hz+H+3cKgAFcP9Hf7RUXG
	0n3KVfjwKlMs5XeVKrkxIcwxBXPeGD0=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4954a32cf1eso13131035e9.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785152257; x=1785757057; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ifEMtdw2Y3LJzGTrNEzkInEIHCSbSBhJKHBE4Huj/fc=;
        b=MgksZpy51yXgdMNwhZdcSKpMZOoc8zXlF0bUCb19O3QHrG3rUDvVu6D1Q/UJmrx7jY
         LfZSiXrTvqbjaVCnPRyICbTni1x+7JdBW+V0Vd2vAHWsjdjIRjIoRYBjvz+zJnhr3y20
         Dacy9BIcOMSQ7QYNMBP2x6KPGGN8qNx92cx8SH9XtJpNUpGJzNorMv1Q0RvIsWvod4rc
         ziS8woz6X5VaCN7fpO7jvQUWXJCBUTbve13wzSpevprcUi2a40hOVcg5OCXUh4/c1uud
         uIi3NhooxZIsMJ4HztdW/dCioIoxppTf62TzhhNk9ArtzcHclVpvprfr7viZIX00yEmm
         bMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785152257; x=1785757057;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ifEMtdw2Y3LJzGTrNEzkInEIHCSbSBhJKHBE4Huj/fc=;
        b=S/s5Qshtd7luu/Z9gsSiUEXxEY6d6ij6kNhUN//0YQn8DdSoSYMZF5RbNfznX6TQzB
         5Chm/6FFOCCzmBB7WdblDkq9sFr+7EajlGWvL5NkcdEwgHN9Pg9XYSGYfNUF0Q6XqA2n
         x8TkHyE+gYN4/sRsuF0/firH9l0lAt42GJtm6y2d5/vhMN7BbboFeKu/h9uwbFze8R3H
         6z3qz6XIn5+ZJEVAafCZnD+uOwLl86iR3OFTxqDDBS5OL3mcRS0ZbfxqSXSO4S0rTHE1
         QrHyme+CzEp80PEpUazrIEJg9hx0DCNmvH1soqDToQRwfE4I9rOWaHFdS9wZxIHv1pvf
         c2Yw==
X-Forwarded-Encrypted: i=1; AHgh+Rrh5RqcGtIc0lfh0MxrWwvxOMEXGPtPTvHU7cE9j+QrT/Zd0NREViyqF9HZYRo9U7c4zPzF3weMSA==@kvack.org
X-Gm-Message-State: AOJu0YyMkAR7LREHZrcG2ELsLFEUmOrO13aXBlItdJelNrwsac+Ov2RI
	4WwGv+7HiqoJx1AE3vZy+wibzStV2+vrpQC88aBAOSnjzW2G8KPv5Bj0x8fe5ehZMxw=
X-Gm-Gg: AR+sD1081Oyi0w2ehgPeZbuIVgLHZtrD9MVQHVcvJZprjNtQJ6PZyu4b8wLbKCZLAsl
	K4MCwGgyfB21fGUrmkmasM7676qClMyxF3gK6sMv6sypy2SNK2mZ75Jq4yj5YPAIuxaQ9b4P820
	51KwiAa1INwnG5NXzZGq+SyWLNMBjIiihAjc+6DSb+ZX33W9G3mNHUZ4iQQTrEnowLkPFpDSbpa
	sCuV10Q0aiSX75ppwlvgb4/FLQXUQBf3Kh/q5/3JGj/WeDOfnTmrr7oNN4+MQxkMiA6YkR9ag5Z
	spyvJtYrKxtBAtvMaEbXRKoeQm1mYODLccLp8DmruDrtQZmtpyt2MuTkkovjuayoJcSEzBuOuFl
	oxannijYOvkxYkPraVa+3F4e5H9E1Eq+yBC07ZS9ZVcgMhdTNsZ1FqX02ly1iy8i4EX2QeR3qtl
	UeCeJl4cJzpYltLNyE/DGM
X-Received: by 2002:a05:600c:4583:b0:495:7426:c392 with SMTP id 5b1f17b1804b1-496b57108dcmr105591585e9.1.1785152257042;
        Mon, 27 Jul 2026 04:37:37 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f30126sm217525435e9.13.2026.07.27.04.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 04:37:36 -0700 (PDT)
Date: Mon, 27 Jul 2026 13:37:35 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ridong <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
Message-ID: <amdC_-OvG1ZUjmot@tiehlicka>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724033435.2573323-2-ridong.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AE1D10000E
X-Rspamd-Server: rspam01
X-Stat-Signature: ai3h7rah3bqods1nz8p8rbuc6f4opo5d
X-HE-Tag: 1785152258-491408
X-HE-Meta: U2FsdGVkX19KwGCpbk7wU2JYYC7QJ16+HaooP0JulKIutoMiTEtl8aM2dErs/XpNT/pjeR7WFxq6Ys5/cuo11cFkFFIRaj/4Xg/jUf0NkxIblxW/nQJ0vM0bGfc6+HUr6vdihPVf2XVXsr8FjMMbuRj+xKhHnFCJQPuJQF9lJ2DUEuiv8NSoWOXcMKtEiokPlwG13azOrh0pf4tIxx/U36MbYwTltqj9o/TXGuI0e4vseq5nm4HVaPEkemELlHeqAlvLLtzhLWRBq5V6bDMPKOB/C9O9bpoFDuJWTRju0mEEgahBQ5UyLX2fVr9w6bnqT15kh1Aft8iKzo/7if0MGuvTETiwE9GHB1ykOWu3cLOvmiY46pdwD2Bh9vN5fWlQK6YsepZQ0ZhS2hPdfbRY5UJmXO+Pr5IbmGEwVag89i3MwRG+Wu/94Mkf6I/YtSexMzdg3uEPFyciN3wvOPP1K2I5iSyGTtRDV3L15KeuMCWA8JJCvqx+5dqbJcQg1Lg9EEucT8tO7B3uvbb5OgNoxDFJxNizXgUmFHuzvbQCUx8/yl1NpfvWWbkb04gbJqCM23qnLGHijoByS590UFEP0SPloQscxFT1w3jGJqcsvg2BIgBU0I/CBRymNgu1uyjkpCjTvV0rNDdtPLe6oIYl3dK1fqfb1VnczHPl0lwsfMzhuqoqfTET5KMcNAod0+meLwmetbNGIraUaEXoiSzodicT73FyT9kVKPzmKDt9nP7wgBuLitB72onhNIvb/DrZfH0CaahEdBnA5W3xgvm91mJKpoHXGWVADd24rz8GtGNT7VslJMfPpqkat5oe95JOdg2oWsvMbkWn5W8QyYm+ngkJm9cD6Lf+qjB1ppuZca9BqqUB7bjyH2aN2egi50Df+Z6rfvUQ8nDsMPtqEFr1BZfzXoAzQtOnSrMB78BUYq6PRreIAJAktE40SlBTOQoQURupy/rr/NZX6q/fjQ5
 oJxsCxsz
 r6Q6fqSe9TW8kqmerpkImG/+GUnfYy8cQ9onCajKa8VKDS2bI1iW9NxuID4gGRCavzcCPgmsQPbbGDGNbmqCw69yEUDVTVeX5j3XOYEUNBe1Ae4fpqXJQIJRaw/cqxxdvy1/TT+EcQOz1KCRw44rX9AM3XK338ixQCenj8z687QpZLlYI80msEKp4PBcfRY3CTZV4TZYwb+fEBb4Nd6cMpusGy4F0TGHD6hwz7RC+VezQ4h/9c6FRN41zc9jc2lKkoIP7+svli/2yxZludX/qeoOzqgks5Z895cPm6zlog3UxutiZfpCJI53dEubfdChcVpnnmTn7eHGNF2BQJ5lipxMLs43lhGmv52kDsZgIUg4qKjCxY7mlwV/EPwwr4Ju4MNHl0D5dGTrF3QCoeZOi5XjtBuFkPLy7tibPmr0Qt/NqoYhzX3n4tG/gA7rv/R1zlIu3Is+SfC/zD6g1oBbnhooBkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 24-07-26 11:34:32, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
> the reclaim logic is expected to reclaim anonymous pages exclusively.
> However, due to the current ordering of checks in get_scan_count(),
> file pages may still be evicted if can_reclaim_anon_pages() returns
> false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
> 
> Reproducer in a cgroup holding 64M of file cache, with no swap configured:
> 
>   Before (file cache is wrongly evicted):
>     # cat memory.stat
>     anon 196608
>     file 67178496
>     pgscan_proactive 0
>     # echo "64M swappiness=max" > memory.reclaim
>     # cat memory.stat
>     anon 208896
>     file 4096                 <- page cache evicted
>     pgsteal_proactive 16400
>     pgscan_proactive 16400
> 
>   After (file cache is left intact):
>     # cat memory.stat
>     anon 200704
>     file 67178496
>     pgscan_proactive 0
>     # echo "64M swappiness=max" > memory.reclaim
>     -bash: echo: write error: Resource temporarily unavailable
>     # cat memory.stat
>     anon 208896
>     file 67178496             <- page cache untouched
>     pgsteal_proactive 0
>     pgscan_proactive 0
> 
> Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
> anonymous pages are reclaimable, before falling back to file reclaim.
> 
> [1] https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/
> 
> Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/vmscan.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..2c689682b952 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2501,6 +2501,23 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  	enum scan_balance scan_balance;
>  	enum lru_list lru;
>  
> +	/*
> +	 * Proactive reclaim initiated by userspace for anonymous memory only.
> +	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
> +	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
> +	 * no swap), bail out instead of falling back to evicting file pages,
> +	 * which would violate the anon-only semantics.
> +	 */
> +	if (swappiness == SWAPPINESS_ANON_ONLY) {
> +		WARN_ON_ONCE(!sc->proactive);
> +		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
> +			memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
> +			return;
> +		}
> +		scan_balance = SCAN_ANON;
> +		goto out;

Rather than warning the code would be easier to understand
(SWAPPINESS_ANON_ONLY implying sc->proactive is very subtle assumption
that might change in the future) I would go with and explicit check.

Looking at how the code is structured currently doesn't the following
express the intention slightly better?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..4fd38e3f1b05 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2503,6 +2503,10 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 
 	/* If we have no swap space, do not bother scanning anon folios. */
 	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+		if (swappiness == SWAPPINESS_ANON_ONLY && sc->proactive) {
+			memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
+			return;
+		}
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2521,7 +2525,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 
 	/* Proactive reclaim initiated by userspace for anonymous memory only */
 	if (swappiness == SWAPPINESS_ANON_ONLY) {
-		WARN_ON_ONCE(!sc->proactive);
 		scan_balance = SCAN_ANON;
 		goto out;
 	}
-- 
Michal Hocko
SUSE Labs

