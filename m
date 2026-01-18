Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71820C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 03:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9FCD6B008C; Sat, 17 Jan 2026 22:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4DC86B0092; Sat, 17 Jan 2026 22:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F186B0093; Sat, 17 Jan 2026 22:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 944066B008C
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 22:29:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24B371AEACC
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:29:26 +0000 (UTC)
X-FDA: 84343654332.23.D1881F6
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 59B54A0003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:29:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uWNLg7kl;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768706964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSt/eL8MOWMH16GBja7BlYK/m3mPkdcdzLf2DCLrKaI=;
	b=vBaN/+R+ROdLR20CGjVqzd79ykY8tQsDJlIplfxL9C+p+yTmcHiQOrVjcVKd22YSoSg/dY
	949QJaONRyqJoT+ApquumPEkuoe/qnChGAGUv2Mz4Ct5Qfb5Us/BrIxifZcNekijedNXW3
	1cYpOTZBGvy9mZfAaKd4gAUhbFwMIlQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uWNLg7kl;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768706964; a=rsa-sha256;
	cv=none;
	b=Si4MKFtJdu70yU2BU2wb5cYNCEo1rRNsDGzcvrX7HiGATM6iRDMtspeeuQMv5vL1LwqOsZ
	hlc+2orVPRUwENS/S0MLM3b1mmmdOfdbeSOhBDOwsJCiy00rrHqQgkOUPti2BblQytiptn
	dOM+QP1xxh8/u/Kfc/42yLxWgj72hT4=
Date: Sat, 17 Jan 2026 19:29:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768706962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WSt/eL8MOWMH16GBja7BlYK/m3mPkdcdzLf2DCLrKaI=;
	b=uWNLg7kl4TqVqq4BhyBKExegaGv6L+4p6xNVw9KEiE0wHXOu+GMmgHsf0Pqxo1HYJPa7Dt
	1xu6JGmewl0XPwdyEzFQ1vHBOOG2qQPe2tHSEWXhx5i/HsaM2WtK5bdz3OsIcjHVH7/0f1
	ZMOHtpd9e2XiEDFC4nW1ypeO22RR0ms=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 26/30] mm: vmscan: prepare for reparenting MGLRU folios
Message-ID: <mhxt3oheta2enk562jt25qdac2tkq6ulc3olxairfow6tb5qpl@n5dhssfcyhea>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dko55w1kmpctnw4h8j9hxu7iu3ncbd36
X-Rspam-User: 
X-Rspamd-Queue-Id: 59B54A0003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768706964-699046
X-HE-Meta: U2FsdGVkX1+uKpmAN9mQbNM6qmOWrnL/M/AFMfcjjUU94X+NsbfyuueqAXIzAJaDle7Auhgf6pnAQNmffqAoppmjsMX7A12jsIb36W/Dsk6FtpRqcu9Ogmg+iK/8d0NeBMUN6+5YHvJLzbWirXFEModnEAb5ot1cv79sn1oKqShlh7cPK70K9dDqwCLIDewsG9ERCBSfPU9hrWqpme1U3rKQ7WTVSCXz2wnMYTmHKgeVjXoDlKAFUEu/d5h1hlVSXCC5gfzZJBjeUToWGfBhaCdzvu3D2rOO/l1ToJZNAVviANvRpTIiY9TkpT+iiCyAHKHpcvjtZniG1PApqmmuBRIvGLtGM+S7dRuhyQU4/x3PAzp09BoYgaQ+WHf6W387IfWM7sT3T6Bjm5bxLAyWBQ7grfofbRMSl4SXSOgn6TNwYU6Z5tJn5u5VSTOuugpgnjrZsCXYOm87daCKQaqdTAT5SQry723a0OpDtqyo2q1XTdLs+q0WuD+UMdnGUA8pKrbOfJ6xImyBttt6wAYIXuoDWJd5AZzLb3Bbgnwh6e/x4XRWyesaCT30BFNBcpnBKMop/seA8qSgFS+yynzRy47srgxe97ck5uqH8Xg2sO+cadOW2bCaNyvJHQl5TsGzYbORvEURGPKcmOiM8TxqR3DQ1Gwc37CHgBHFFYgxtWkQuIKF96Yk+5qNBThaF3CR7k0sy+WP+8rcuSgqe18d3Jrh9M+6W9QFDERtszyrd3foPuE9l4k5kvsN4+6Tk0nZrZavtf5sf4Wvve2IuBDPcfUfY5WG305aMoh4jaHmPMoOk9v46iRvvt/hyiQ3MpTVF6UT6GqJZ7vSiURbNeIOsqG8GgoCj+ZooLdWwoKqhlvEEBFytCxbCnuxw0CPV+x9hL74nbg59zJCz2+xeM/YyksFdgVs0oFMQVs7+m1Tf4y2O7YhFI3eofPV5PG8L/vyx27WuhJfVXFzjmmZSSd
 iHcYklAT
 dPSvrz9XfoyeQT2Mq+33fGCSdB8GlGTHtb1hUuklBlABFrdO9GtNeLpFMC2WEYGVl96C05CxyHe7r6XfzbeoLM09qnwixeUVVbNj9g6/lC95BPTqDGaC4uRtVp3x/4yY8fzEvCbPS8lBjILyQ7Y7BYDpDp5dLvHnSt+DH0v391zKROJIfcUHmlTWlkKksjeUicTFMtJHjezMHfG6JokzkpOnorALq1uPFSj8962qyDF/MZNTNpG0LplWv2XEQnGNwV/At
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I asked AI to review this patch and it find following potential issues:

Author: Qi Zheng <zhengqi.arch@bytedance.com>

mm: vmscan: prepare for reparenting MGLRU folios

This commit adds infrastructure for reparenting MGLRU folios from dying
memcg to parent memcg, including functions to ensure parent has MAX_NR_GENS
generations before reparenting.

Link: https://lkml.kernel.org/r/92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f1a45c94c2fc..284292653d14 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> +static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
> +				      struct lruvec *lruvec)
> +{
> +	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
> +	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
> +	int swappiness = mem_cgroup_swappiness(memcg);
> +	DEFINE_MAX_SEQ(lruvec);
> +	bool success = false;
> +
> +	/*
> +	 * We are not iterating the mm_list here, updating mm_state->seq is just
> +	 * to make mm walkers work properly.
> +	 */
> +	if (mm_state) {
> +		spin_lock(&mm_list->lock);
> +		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
> +		if (max_seq > mm_state->seq) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When mm_state->seq equals max_seq (which can happen when mm walkers have
completed their iteration), this condition is false, success remains false,
and inc_max_seq() is never called.

The caller max_lru_gen_memcg() loops with:

    while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
        try_to_inc_max_seq_nowalk(memcg, lruvec);
        cond_resched();
    }

If try_to_inc_max_seq_nowalk() fails to increment max_seq, get_nr_gens()
returns the same value, and the while loop continues indefinitely.

Can this cause an infinite loop during memcg offline when mm_state->seq has
caught up to max_seq?

Suggested fix: Remove the success variable and always call inc_max_seq().
The mm_state->seq update is only for coordination with mm walkers - it should
not gate whether we increment the generation. inc_max_seq() has its own
staleness check (seq < READ_ONCE(lrugen->max_seq)) so calling it unconditionally
is safe:

    if (mm_state) {
        spin_lock(&mm_list->lock);
        VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
        if (max_seq > mm_state->seq)
            WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
        spin_unlock(&mm_list->lock);
    }

    inc_max_seq(lruvec, max_seq, swappiness);

> +			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
> +			success = true;
> +		}
> +		spin_unlock(&mm_list->lock);
> +	} else {
> +		success = true;
> +	}
> +
> +	if (success)
> +		inc_max_seq(lruvec, max_seq, swappiness);
> +}

[ ... ]

> +static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
> +				     int zone, int type)
> +{
> +	struct lru_gen_folio *child_lrugen, *parent_lrugen;
> +	enum lru_list lru = type * LRU_INACTIVE_FILE;
> +	int i;

[ ... ]

> +		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> +		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> +			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
> +
> +		update_lru_size(parent_lruvec, lru + dst_lru_active, zone, nr_pages);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This update_lru_size() call updates both __update_lru_size() counters and
mem_cgroup_update_lru_size(). However, lru_gen_reparent_memcg() also calls
mem_cgroup_update_lru_size() for LRU_UNEVICTABLE. The combination appears
to cause incorrect accounting.

Note: This issue was fixed in later commit ("mm: mglru: do not call
update_lru_size() during reparenting").

> +	}
> +}


