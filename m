Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52515606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WWsyFrU1
Received: by kanga.kvack.org (Postfix)
	id 85BF76B05BE; Thu, 12 Nov 2026 00:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8336F6B05BF; Thu, 12 Nov 2026 00:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74AB96B05C0; Thu, 12 Nov 2026 00:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38B076B05BE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 240A71A01EB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:19 +0000 (UTC)
X-FDA: 85425268278.23.1B46084
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 82F6B4000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWsyFrU1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459677;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YarLxh2JNnQKiqzae1rgF988rDkWk1PSH0nmVyIsDVE=;
	b=mqeqqfjxB0Rc/F0IxWX3YiYS1o0t0lLDDOOBeVTBY/rSIIvKEWSQLO+PiHlHUMw+vgIG8e
	sllXtEBxOqLSFK9U+jN0/KdXxnSXVhtMG8r7PC08Pni9FcqrbtLXfeXqka51xeHvurgu+2
	p6ns8klLQ17SraPvi0XVA5eXgkKwNTA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWsyFrU1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459677;
	b=625UXVanvdhwL6J1CKm/Dj1C4c0IoD+fnZiXdGb97KTtbkvAk8dwvrvPp3FDPuMPYde8wG
	NX6/J24KVpPFfKwPTjZBi8EzYVSUKMxgGB3lb+4NtrsL4GOuuu9hfnbyPvshiET0Yqxho/
	tynhiAiWBg+6wBt5oZzt34fEE1n5080=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7F9D46B2F;
	Thu, 12 Nov 2026 05:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8B11F00A07;
	Thu, 12 Nov 2026 05:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459676;
	bh=YarLxh2JNnQKiqzae1rgF988rDkWk1PSH0nmVyIsDVE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WWsyFrU1K9TKERzOybI3iXU9RYMst4VQTD4AAOTJQH/K6gjarRDO0VO1B0EcAnJrP
	 f89eYcaceob5qkcYWGvZOyTUB+J/51Sm3vG5CfdkRnNWwKhPRrnviX1sr8S08hWfKv
	 5WjEVnq9n0woye8+z+27/z3gek3VQM8BEI/9jmxD6RHATeVL46CTi/xyq1LDdb/Ibm
	 yRR6JBsXBByTtiFurYHzIg2O0+TMEvavZvUhb3bfIZ8LYdzJc30Led3y8essg7jIAe
	 mocNLtXw9PtnRQmAbbgz8DT/LUARFbTrInf1H50Ab3G/EW9sMdgeCHNIZkNI87Mhfn
	 htBp3l5t21mYA==
Message-ID: <sashiko-outbox-210424@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 16/16] mm/mglru: Avoid scan anon while swapcache is
 low for GFP_NOIO allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com, "Kunwu
 Chan" <chentao@kylinos.cn>
In-Reply-To: <20261111232603.9934-17-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-17-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:01:15 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 82F6B4000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bxo9y1wx67fpwg6wq1idzjqwioepj4ng
X-HE-Tag: 1794459677-831834
X-HE-Meta: U2FsdGVkX18PQSVhTWSjudMevZ2E3NesvVUtDIhR3QTC+o8f5GxVz0x6vns0B3WKBfJV/arn2gPuv3BgG2cx3vEXBnxs4zWHiz4fuPWr1nxRv8LKipxGNJ5N0Q6Pa9fEpXiKHGB+Ge0N8yiMHixVKOKBFyFc7ujAZKc9ocEYhPL1ChNdQIztWYsyWX3XVDzBrAYi8VN+/dm8qoLUEW28iKgZEsiVp7d2cbj/6r6bi2KjSUD37xG5ceWS+9ajPGJloupbzY1SlPhq3yxzEc4P3zwbNp/MqY+VAFx5+bbhRFLMbMk6RSbCGr5WQY4ZUaDdE7ptzNQs8cNrkTbtC/BM/5y4ZbaE3iWUaxKJBZulD0N7WvxgpXriY2kClwR4UyikEWN1nic6g2McJKIU9v+mvmWA2dGyDVtivBjUJMnezjJnvP5QM3RTQKxSN4x+Pj+SDXy1ETj2/dyrgiTIXre9LDTfGOq/rImQkyL75kW9Jzxb5GzQlkkjlVhO5vH+6Bcp+7nYzFs+Pq8rYZQhvhUXXzOl8NzhoK76kBzU4FQVterzDxHcAKAjckJxruEklg05Lq2jJ+0MZ9WhMp2qAOK0N5RVHFt2hPR/ZPQrbI9kQP7SNi69cJbXAeIg1GVroIea2+2C9b4/vlMCm7A0iO/Q4aj6Jr2ocS0hdGtQlf0KbY0Y0KFsQXapYyHqT6ylXZPzcJ6yowN61kdWHkWfxO0NyeFGRWZ5XfyRgg2TGDvL8iuncm0ntSQLERbeWXqSoh3F6fXx5+KebCR8CQGVKnBemFNL18srWXOxtommfDMJaXatIqnOJrtfwKXVoFmjngLcM/QlLoVBcb4tCftxOsCpRJfnRHfVsHkOQtxsOy9+5kuOb0E9IwoK3qRmTQgUudy4q663hwdzX5WtEidXag2HQazrOkPPMis9/L/dawha27tB8LlVB9QM5P57G4Dhc39VZBE2OHdHbiNsbCv/Mfa
 Foe6+Rqy
 XkoQ/j3tiqM1x7T7zhzpZOqalL398J+4+6bWdhINVWmMN6ZD8vHEc7AmC7C7sM0mzkMEZ/l95P02dTX3ftD4H0EOvVmnLyM6Q6sIhgdM++FUJvRHq2ehZmZSEnlPPHbdypXSEaQ9JsoC3Nzq0bCpqVPBeoey7BM2xQDah1/H19PtY4768Gg05xNWc9f06bppHxregxBCB+Wu5QpL0uA0kUWZDZwbbJMa5/crMBjPtza4aXCJKJ62BLoCK0vYARaQ/S1P36C6CPOyBzHD7aYWuAw7zdT+Mcm6JnzRH4jBGVdpiFyt3Lf6D5J37m18007onjQ/Epr/D13diT5qxPv6Pe3/XjrmP6+d140l6iOnhyStEs3S8TrTLGlJmP57xFtdqkARYC4FcgNxtb0gWPARHHj1jTYUm3cE4uwVPTdS4KbawybyMymPcwC169LBOFJHcPae8D6KBHKmBVygFHSAzmqK0cEM1hH/Qm7Z5SA2OIPv5rr6bwqVVjhsuR0n4vHJ8HtrLsdrZtxHsGC7a2Cd6wpYgBFuTF10Te4etJ3WE1mFV459EcM8kgtMUX+dNOplZl+hHc3+LtOnPTxsNE67KmhbFKpKtOJgGPYzJY1bswsoLlRRZkSj4Mv1Go4Fur7+B5cBwIRIY2Gwb1gfShbAusRaptejSnt5I0JIqzK8wlvG+Fp45I7wNT9EHOuIFUD1bmX3q/Wr9TnDielmPHqIVpnYkssTMJkDBRbz6imBbYkQ/F3vvG9bFrk0biKece0xbFDuG8mFlgXE266g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/mglru: stalled aging in try_to_shrink_lruvec() under
  GFP_NOIO
--

commit c2e07c75b5549aa295c630747e1cecd7625269f0
Author: Bo Zhang <zhangbo56@xiaomi.com>

mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation

This commit skips anonymous folio scanning in MGLRU when GFP_NOIO is set
and swapcache is low by checking can_reclaim_anon_pages() in
lruvec_evictable_size().

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f36e9a379b62a..4fdbf0c2dcde0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[ ... ]
> @@ -4213,6 +4206,8 @@ static void lruvec_evictable_size(struct lruvec *lr=
uvec, struct scan_control *sc
>  	int type;
>  	unsigned long seq;
>  	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +	struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> +	int nid =3D lruvec_pgdat(lruvec)->node_id;
>  	DEFINE_MAX_SEQ(lruvec);
>  	DEFINE_MIN_SEQ(lruvec);
> =20
> @@ -4220,6 +4215,8 @@ static void lruvec_evictable_size(struct lruvec *lr=
uvec, struct scan_control *sc
>  	nr[LRU_GEN_FILE] =3D 0;
> =20
>  	for_each_evictable_type(type, swappiness) {
> +		if (type =3D=3D LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc=
))
> +			continue;
>  		for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
>  			nr[type] +=3D lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
>  	}

[Severity: Medium]
Can zeroing nr[LRU_GEN_ANON] here while swappiness remains non-zero stall
MGLRU aging during GFP_NOIO reclaim?

When swap space is available and NUMA demotion is not, get_swappiness()
stays in 1..MAX_SWAPPINESS even when can_reclaim_anon_pages() returns
false. Because nr[LRU_GEN_ANON] is 0, evict_folio_lists() only scans file
generations, so min_seq[LRU_GEN_ANON] stays at max_seq - 3 and
try_to_inc_min_seq() clamps min_seq[LRU_GEN_FILE] to max_seq - MIN_NR_GENS:

mm/vmscan.c:try_to_inc_min_seq() {
	...
	if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
		unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;

		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
			min_seq[LRU_GEN_ANON] =3D seq;
		else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_ANON] < seq)
			min_seq[LRU_GEN_FILE] =3D seq;
	}
}

Once populatable file generations are drained, evict_folio_lists() returns
0 and try_to_shrink_lruvec() breaks out of the loop before setting
no_populatable, while should_run_aging() sees evictable_min_seq() at
min_seq[LRU_GEN_ANON] (max_seq - 3) and lru_gen_imbalanced() still counts
unreclaimable anon pages in old[LRU_GEN_ANON]. As a result, reclaim fails
to age from DEF_PRIORITY down to DEF_PRIORITY / 2 + 1 and then directly
evicts the youngest file generation (max_seq) without page-table aging or
tier protection.

Should get_swappiness() return 0 when !can_reclaim_anon_pages() instead, so
swappiness is 0 consistently across try_to_shrink_lruvec(),
try_to_inc_min_seq(), should_run_aging(), and lru_gen_imbalanced()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D16

