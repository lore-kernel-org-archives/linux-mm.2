Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C1E2C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F97D6B0095; Fri, 11 Sep 2026 13:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AABD6B009F; Fri, 11 Sep 2026 13:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82EE16B00A0; Fri, 11 Sep 2026 13:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FECC6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:02:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78E971202E2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:02:46 +0000 (UTC)
X-FDA: 85202100732.07.6A9649B
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8AB6818000F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:02:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Tn9oqyW/";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789146164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OECv2yjkS4C1/vp1OMprOqRH2B2H12xO1mA6lcxkPXk=;
	b=TXh+GqLbDSYMWqLAeMvqCItjy7N6+mMsY5tJ6Q05gJDS2IH4nYaEf2ORSqvBc6gJUudL+M
	MLtpkNGr83dTMdff9dv8Q/zkSpHu3JzqflTYcCBFi1Mo+nr9XiyaDMY1X2nZKXAOquYfmG
	l1n0ZBSSNVqNKj0c7yuymvXtKmD1F4A=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Tn9oqyW/";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789146164;
	b=UqNn2ZSScwOn/p42JX+U1zrHE8GX6sT2XA3tn2xZRWbUzzPFQddf3uDX4SZC0omL4yMica
	xJ3bPE4lliENV8Hb5TjRXsw+RNAvMTrOtzke9zBCRKj6FynRR6SgucQge/oKC0dfyyrp28
	L+tgWzKACGd4LJCCJ+pt11cyhF5T7kY=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2946aa0d5aso237042466b.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:02:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789146163; cv=none;
        d=google.com; s=arc-20260327;
        b=jEgBqMdNslA5BMRqJT5/J5KndTGzCk3OBHP69Ghe+ILpK5S6aPRhIDozXJwgwrbBAc
         AjNS8Yx/QUlTkcYdxVO9xbA12BXO0GdwzvFKFzP07euO3zu5X8XfYjfYFmcXRjUruZev
         wp0eShJ9KlOnuyIgN2EYKZ1GwsxL01Ili5Ryzr72x/ULq4WVurmWQsK+qI/7RPVe0kD4
         ESxJaJZGEi5jntRs+4fWR5DFDvD4FmWUr4+qtDh3PXtLUyL0QgwFAiHhK+iAGCxMAYPC
         mpR7hJpjLJyDkPIxVN8WHmImhwUvUM3yFnHz4CyILW9goTVfwtkueFYS8UUlCiBrPCpI
         FcAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OECv2yjkS4C1/vp1OMprOqRH2B2H12xO1mA6lcxkPXk=;
        fh=x/nkZnIIzPnM8y/GquJSlv7BVvY7stzTlNBwTvyR/0I=;
        b=DG6pdidM1osOv1nU8Q8bxA/5sobbeSsc7ERv5pEwzIQ70qUe2P/ZhOUFuJPLiNgU4+
         sYiU5I4O3ht4ghGO20r9sBViQ8HbcIqhNLv88DO9tp5OdM77LGlP0p77omOX3LSepdtY
         RXEvGADmbfgZm2QteU5RC+lFE58wS9WqmneQhnfEGVDOmxgbKL0xismTHGbQjaYow7FP
         XbXUM0RG7ALIw4KZEQgshm10+3MEdDDec3ketbAlQIyitMpUfaA9gOc0/Ema9EAHbNT0
         szOvZrGYZmUsIorEZtoRLbxMG5i6ju8o+rTHfwaTO42GgWNkt0aEBH+4RJ0Sti9uuwxz
         JnMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789146163; x=1789750963; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OECv2yjkS4C1/vp1OMprOqRH2B2H12xO1mA6lcxkPXk=;
        b=Tn9oqyW/VFhPHOekQoHOlQrYwqJWSBzS/3ZaiezHdwsRHuVEzwrq3CRGvxUctw5Dt0
         4ALv2e6D9T07ARQay8kVJBohn4RQ6VhpBDWeJpfgNPD5n0rFv0guNFasIz1979nl9MAB
         xSfnL/5I7cAwtbFXTHZVWUzayw2eMGrrpbp3GunyB7lTvXiCLJx6PXPk8D8Vv/6L+u3d
         AIEl0r1f3XaIjHnPOLpMkSVIicb9iqEYCsHc0Yk5VvNWKpu+jLN01tPeZBbdx+g1FV8Q
         FcXgVX1Ftf8lNqdbYMeuLoVEjEdTFlJ5zvi2UKuvx0JpXhHpS097X1IEK9t+TDvqa9Ea
         ZdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789146163; x=1789750963;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OECv2yjkS4C1/vp1OMprOqRH2B2H12xO1mA6lcxkPXk=;
        b=C3Kvf3yapIhs+w2kdtFc1T2VRQVtKjfLU4oOFhRnjgg28rr8qykubljHzjziNqd+kq
         /qMIYnsp4isH8Zt/23nxGFHIdazW1q5eHDNiRv9GnJUFegNffjqVxQMunK+rG0iKknJi
         bwtz26A46YIpxNqsvS2rZ/OKSIo+QHGKtD62jV0WqPqtv+H2vG9SORkdZvRJtB6QX+9W
         XIIms0aqeA56D3Odn+cVZLEpMTY2FZhKWfRup3JanNSvXO1nSFwRChTxCJ5DmLUIAxH4
         dLJaNifk97+hgccW8dMcvUwJgGgD32+hkxXknD08QyBdZHVMYnk7GKEY+fx/92oh1Q5O
         /fBA==
X-Gm-Message-State: AFuF++msv2q0quw865QqxMk5wT17zVh9pTVflU3BKL166d37nnum9xXA
	rUTBIi5MYM1yGXLvlpWpWmRgfw1JvpnQVkGwzoDG6BGZL8ZNt0U4rPi7iXGoyyvQZDkXLXKjZjT
	KG1HXFwjplbN30DEExvDsrYWEbwaQkfo=
X-Gm-Gg: AYBFou0tDmF8d8CWxdEZUsghMMBJkF/29Aq+uv8hv0GFOyeyZklpsjoeVQ5B04LXXSJ
	cDO1Kv4VMXj48SyDJIpIflGOvu/WXQhTBk9KXI/pBJDJWi5SB1sq+1Sd8LQGXc2/wnZcSG1tT+j
	llbc5uC2X1k5aQXX77riOmk8ebub1GMiy3pkU7cCPWxM1fprq6iiEqpBBlo9RJfEdpMiv4zu1DB
	5Vx5KlaT/jhMZ073JYi4s9Cogp6tXfeYmNQ83/jyinvSOFYH85K/k1uWn0vx0c9sbmX295dvkh2
	ARM7xFBM3fMdsGQL/Mk/Yg0MMHP+ozffs9gTb7JNadkpYJn9qcFp3BVswFdpk33NHL1bjz8W2ml
	4qyzFUV/DnSwo
X-Received: by 2002:a17:907:6ea3:b0:c26:1cfd:4244 with SMTP id
 a640c23a62f3a-c2945df0046mr549681566b.11.1789146162827; Fri, 11 Sep 2026
 10:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com> <20260911-mglru-fg-v2-2-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-2-f26e5cb26da7@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 01:02:06 +0800
X-Gm-Features: AcwNN1WZxmLzBpJpg1QE0SBA47yQSwx0Rtahq0z7WbiXeya29doeRNeqKHQTWO4
Message-ID: <CAMgjq7AAxBGFN05ZQQsqhWhKi8XNyxCfCbH8-G1sZfqDKEYvCQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 02/15] mm/mglru: make generation page counters atomic
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8AB6818000F
X-Stat-Signature: 7qsakjpzp4t7ukfo8gc9mnuwunjgypak
X-Rspam-User: 
X-HE-Tag: 1789146164-953426
X-HE-Meta: U2FsdGVkX190Fa6BfUg3bYMHP9e9PblnbDHbABX3VJf3L/RhQjh2c46d+PPA6m7J7RIjv5cBZShNrgPuqlTvqITgeZI3O/V6qnBM5GhffbTGpjVhi8WtB3SVR/DKdroirbIGBH8gGfJnTHAiShwfvECBmpRZlQT1Qyr8dTL9HYfJTYmrMc/L3KBPb4II5aln8wvaNgmDhzEIQl3bQHdQ556XGx/xrZWVWflykLuq7QN+Nrx2mAQ96T8VT7/M1s4a/ayWq0C9ZIHrYLVBNwlOFQ1St3qjlR/fTv7KD0s8A05VYSLTUH1tyqZYixvmE8QCtRJMv6TjjTT/kBekTsxJjLM09sMExh0mpdqdrcGW2+VaHO5DqO9LNwhqDihUHIHcaAEKMLM/glLtppJv84KpUTCS+z+2w+l/tNL6G0409HpmCQuykfgRBsQDIBT0FYuKWQRLYPhvXrBdouGxSJXcaKxHB70egnUnv/F2A4yhTh7UBHK0WcKi7f7uoiPk0Y9xuKrDA6qg0Ocd1T4EKEnNySWMoeXGJgxOXdad6RFhov4MnBLG0aXAcnVSq2DwgtrwtRu95WPGbjgQK2xIvxPHi1Iehh3hy7qMpo34KehvDzo4bMhKDn888xyWiGQM0Z68SOchc/QuMoa1o0Txo7tRNahxE8y3C6Ys/9uuKE3SzNSs+aPdqpxqEKpDLCAPXM5YNC5YxLa+kpgPqBSTDfD58actDm51u13KKhXbCzzhhGqsZ2qsFL9aikudaXz9u5FEh7ZDcNcfmxaf2GfyHYpGANaeQmx/34Tmn2CneCFJWqKhSPvlPUbe6mYhmkUM6LIJIqgFt+TrKifpx3pV/Mp9FfHuluh2nRimRgNQrx5zppQRq0H5H/WbbefHaJytsuLZGk2Vfj6VADZLlM26lS7YCO2WsjFwX3DyxtErRPuH8Wlw8rPZgAkPuRlBRTMJ1qj+sBVb0fuQjM9TlgI/bNk
 Oj87IibC
 4Lfu68y3lyQ90x1TAQXKkqhPVtbnHZG0oQnNO2cohr0y/NXhXvxRWzW4qhr+YaoW+LECwtS6DRKlg8TvotNQZkmC8Y4c7RFTcISRJ/TyvTIQHC7OeuV6yXTUstO958M/mzDaQK7c63lIP6dvoS4Wx7z2JudBMXjvil5XLSz3U2UHrOjTZ3O8SZ1IFmqucFwj3AJ0wTyaXTNIP0GFSSlRLWrAkTuNq7jDL0t57OsD8moSpjoe1SWWhJ4Gu3lvNGzzPfnZLQbsKOo7BA38gpGEDM2I6mpl5q3hOuZCwNrnSBTaJUpBIJNWqRKLB5ZVshj92GmWnjZnYbDy3ZG+bKyPRGyudR7Nq2oEpTGAe0e3pag2/gvoLOQymHFw3dsAnH9L3/SeWR1CArI7/MZznAoCTovPIuAylSgeipdniOyLCBbbnAk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko reviewed this, I think it's just false positives, see "===" below.

commit 5d43c1cf23cfcb5744723aabee21da2f8bffb50a
Author: Kairui Song <kasong@tencent.com>

mm/mglru: make generation page counters atomic

This commit converts the MGLRU generation page counters to atomic_long_t.
This enables lockless updates to the counters without holding the LRU lock
while ensuring final consistency.

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 597f013c8e046..f52f02e8e5be1 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
[ ... ]

This is a pre-existing issue, but looking at lru_gen_add_folio() in
include/linux/mm_inline.h, it updates the folio's MGLRU generation but
fails to clear its tier bits:

include/linux/mm_inline.h:lru_gen_add_folio() {
    ...
    set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
    ...
}

Does this leave stale tier bits intact? The MM Reclaim documentation states
that all paths modifying LRU_GEN_MASK must also clear LRU_REFS_FLAGS,
otherwise stale tier bits inflate access counts and distort MGLRU eviction
decisions. Could we add a fix for this to the series?

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index aaceed4759eeb..32890e628240f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[ ... ]
> @@ -4720,7 +4717,7 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>
>   for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
>   int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
> - long nr_pages = child_lrugen->nr_pages[gen][type][zone];
> + long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
>   int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
>   int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
>
> @@ -4728,9 +4725,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>   list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
>        &parent_lrugen->folios[gen][type][zone]);
>
> - WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> - WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> -   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
> + atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
> + atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);

Is there a TOCTOU race in __lru_gen_reparent_memcg() overwriting concurrent
lockless updates to nr_pages?

This patch explicitly converts nr_pages to atomic_long_t to allow lockless
updates without the LRU lock. However, the code reads the counter at the top
of the loop:

    long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);

and then later clears it using atomic_long_set() as shown above. If a
concurrent lockless update happens between the read and the zeroing, wouldn't
the update be permanently lost?

Could this cause permanent divergence between actual LRU list sizes and
recorded nr_pages, corrupting eviction statistics and causing over/under
reclaim logic errors? Should this safely clear the counter against concurrent
writers by using atomic_long_xchg() instead?

===

The first lru_gen_add_folio part is false positive, we want to retain
the refs info, not clean it, at least in this series. For existing
cases, maybe it's actually not a good idea to always clear the refs
info as well. But anyway it's not a bug introduced here.

The second reparent issue, __lru_gen_reparent_memcg only occurs for
dead lruvec, and all users only do this for alive ones. Maybe I can
add some VM_WARN_ON_ONCE and a Context: kdoc here in next version,
it's not a bug but good to be cleaner indeed.

