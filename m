Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65166CC6B1C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 03:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384136B008C; Wed, 14 Oct 2026 23:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334836B0092; Wed, 14 Oct 2026 23:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2232A6B0095; Wed, 14 Oct 2026 23:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9DFC6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:46:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7D751A08EA
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:46:44 +0000 (UTC)
X-FDA: 85323473928.09.FF65F0F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC4FB180006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:46:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p1SyB46t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792036002;
	b=YoastCQUt0ZKurwnSOCYDTBg9Xn2eslaGeuZZVKkxF9DAfTCKIpB/Us/Dp+oORRRfwgUxk
	/Ga7Takz+E812dLgZoqb6vuWfeW/EzFocO3Q72iXfmgnPgY3giSKcB6rn/sbkUtl1pe7Kb
	mbhoSAlgrNxKcap3UYpFuTsvGRwSqvE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p1SyB46t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792036002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J47XPC5HC/CHotb9sS63tD8UTNkcaiKZyv19G97E6cM=;
	b=kRoryC1mQQZEMvWatTrCdp0nX4bCJQi/OfEJHuSHSQZq2mc8eISCK+W+hZR3qK697ti+Lv
	TbxPKWmszKarYnIspg4MNf6xxQt1KaKfN0bZ0OMFzbTn8803mSEHVNp5UT5F9R2avB89Cv
	pus9uc0EEnPnw9sZtvdUWzzlyzP1hjk=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e49fbf92aaso28426265ad.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792036001; x=1792640801; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J47XPC5HC/CHotb9sS63tD8UTNkcaiKZyv19G97E6cM=;
        b=p1SyB46tuAaVbOJ5eKj4nFTCy8w6+s6hpOSDp/PDcHxmSTHFN17w7fbZWPKPjzCxK0
         BPKlSF6EBuXe9IO1N2VE1KvkV3Zf7YapJ5o8ECPDm1yfhXOtRbH1AFTYezlUWWpRugML
         m3m1G1DsKSPV9j0uHmjpPs1mwLXXg7JSRui5kOR7zZOZrC6/vfiYCKbNAK7dYs96nDQd
         OKijFQ4XMWczMxdgeyOlnDfbEgmJEUZ0arG0A0sfE6dZX0keMcAxMTlb0oCsarz8UAz7
         /FNDsM0qXmNZsJJLgdyU74qA+gcgQxyq1feMd0ANcf+rk6Y/U6+abViNiY994EEt7Nry
         XIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792036002; x=1792640802;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=J47XPC5HC/CHotb9sS63tD8UTNkcaiKZyv19G97E6cM=;
        b=JgCRke9+ZQznNrYJQ37CsloX+yIpi2Rfk7dw22Zh1zfOs9ysqZTIAcoBq10dI1KNue
         ftdkLIsA7dhRD3z2j4W9RI3COqTwP8OJi9xFZwAl5sbXgwurg1dSjwrzEgi93AJ2BOVc
         bWhjjDNxgHLWmVepuAQ90CyJN1PpXxEa/f/b/cdrcCSPuaG226xxgsPsWSZrzsHwsasj
         2cWsDJa1azkpDP6NJDrT1e9uVsOgoaBfCM3rZbVh7/xbTvbXyx94Ak1wpsHees4W+wqg
         pASTkz/Fi1HVfQ/2T2OACfZAGiJqqlRFTYGgEAz771VrC2yt2trft851M5jqaA3jxZN8
         Q4/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxVmoBSNpDJ2fr1Pr+9xn4Ipg32g1VMDGs0G/dXUt/neiNMxypLQeNIU9MQjeGCoURWeYxFOWk82Q==@kvack.org
X-Gm-Message-State: AFq9FYKJ/wlWn/VcnVJg0Guw8gO2Ovh4HbIwlffEXxFNz+eq9A3PaVpI
	01oYGJfMO8G2rMs0zeSNVrI/2J3EkpJFfwIarqdkdomcH1M/xmAAcwOA
X-Gm-Gg: AYBFou3Y6Btw5b6oHi7ip1laAa2J0J+Pxn/ZDp3fVJsUcFJRHJ+E32eeOxzhswNdwoS
	M0XtpzB6l0So+GU9eAa5O84/SKcxrZOOAbGUdA97MPNynelY6cdA/2/myA6GvAH3Tog8kJ7nJvf
	kM5pollUdRp9RONpyIa2jjDjHXsKNR+hqLvwDKBd6THuKlkqQHWnAXGynL31ZdN+gUsMqET1gKw
	hYUrABFZnFQJs7x6wdLymyP1kDg7v4YPNWk3Xj975eg/6yMItxj2XPIdsmRLfN8LQZqUk91/Gcg
	9MEUiboSl9jeCqICxoADvQoHficqzhp5JbwwBl3kwzQ1Wv9br3A8Ut0MEbVqsSz30O3whF129Hi
	A0czC2HU2gj1c04mDshU4jjoymc9E/fhFOnXzMq2iIuN7JhpYv3uQL9c/uiycD+k+tkkb7fWnuE
	U0Is2vKJKy0/L2i8vVR9+f6WePbDiaD8zLrSuX5VQD+jfZEMQy2ykkwm5BM6XdK6u2nHscGYD7E
	yTpMsBY0j7cs9s6M30SqOyUQdaTU0fXZLxbHNLiHE9TJA==
X-Received: by 2002:a17:903:94c:b0:2e9:5c51:19dc with SMTP id d9443c01a7336-2e95c511e8fmr7973295ad.41.1792036001505;
        Wed, 14 Oct 2026 20:46:41 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8484c1641sm72934235ad.15.2026.10.14.20.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 20:46:39 -0700 (PDT)
Date: Thu, 15 Oct 2026 11:46:28 +0800
From: Kairui Song <ryncsn@gmail.com>
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SeongJae Park <sj@kernel.org>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC v3 13/17] mm/mglru: make folio_inc_lru_refs lruvec
 lockless
Message-ID: <atBL2inthrJH_ng4@KASONG-MC4>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
 <20261003-mglru-fg-v3-13-cbd4546a5bd9@tencent.com>
 <CAN_Opa-GVYVg1mUc=PJFfE8ZLCoAWjzDoWoxA8FEfsPAYGdijA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN_Opa-GVYVg1mUc=PJFfE8ZLCoAWjzDoWoxA8FEfsPAYGdijA@mail.gmail.com>
X-Stat-Signature: 3fid4idsd1mu1rydb6h44kmutpe3kmcq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DC4FB180006
X-HE-Tag: 1792036002-928164
X-HE-Meta: U2FsdGVkX1/GCG1jvpaw2frk3CBkoSsICWsuW7rA7Z7pidI/nsMcJtBlqkU+me4aAWAspIvLhszx1v9xfLXuUU5LGEYYLkvt1XmCj92n+4uP3GWZVKxhIsqEmyYMqPWzhzBQjBFMfQyINeKbnfumDbK842t9qpzgHwK+8b+yx8DsxalHWE1uEEZpUoA4gcoytu3an1Kj6R76ompkjvJS4ArkdU8f0UXuL7GWm9IKVm8KbT+ARqAZNt+L/BaNwdGGkca5Pt7WSENda6xIRYSDM1dZE2YGlGNhWnhx3FwsxYPq3LzUO6CLr3Bw7RI5/UkNlmBsTzOAyTI8DdWvnPp9OK05K8VpDC6Se+5uBelZVapQQMeBBAkxiZ4f71FHF7QTWtGgjvPqjs/+2RK24V7nHptW1ShOhmEMwwFJzxtpKoCAUmRgPb/g8Vad9aaljS9ljkQ5w5OlpCkRmdqjy2Y7NtKvSXJBRetgA4bTAJXIzmmpr5J/bQU8aqiHT4cC5QsbXBCHXLXCttEbPvOZSDELzWHGuRUmCfRrframJB7hBDK6v7C6qDMBja0CI2nItgoAvxXTRxbht8ccxJG1d3AMVohTzVbMO5rsKcqA4NLt/QryCW0unPb60m1MrQXyEleukadIxtEtVs4IajaLsjT1B0P33K+mmCHVNPfF7rBRx7JGdCckkdyd77+bDpCjF8FIW+toyhCK8B5/oS+ipbpCVd1ZNdCHclNr5zLk3as2x702cz5iVxR9TpmjUX2znNHXiFIWxrDlqkijcdqH9fhjdGscIE1wCbKIi5MR8oeQx6Bj+UIw/0NKmYR8R/3MIqXZBTuoALU+6pUwtJclIrbqfrb/vw0q2ZsTfRJz3VeQ00xssXTgTiufvwiIlCIkoFZEJ4X3Uslw+TGCzMWZZfqWjGOBbx0qe7Vm7Q3aOdRNVQx5t0kTXA5kORfEydKpV09LzCqkurGNrBzM4Wp/AKd
 BizLUr34
 IY9MN8UYlMg9HJDU8ks1+wqQTc/qgMgoeoJGAz16n3S1UQ+oz5V5i+LJEHUZKPpjAezQKcnV+pg0i5t/cz8PIPCaWWrdvZoK196GePTV6IsUgC7MWUt3fZgkmntYEzc7YB8/lQFwCrS5srcsqy8neYwPmuRJAtrJh5wNgzhgLlsms1FN+Md+iXtVJEdTaMR3wKREIYSwxDJon2+8piYUTYvvKQbSSjuLbSEHSTClyga6Zfp3XLA1NOJOJ0OLH7Dm+bxiNJU85PVfUTPMC+J+gFytFIj6/1Xn0RWTP9e96fMzzIBPQR/fvE8OME1Pw42s9ckqT+NJyP+fToCCXPbXNhGDq7zFGyXrU3Twg6KvwMiUWKXRJI5nDrvAhye3vv7c89hvX1EvCqafc1iff9Jr8vVXrljn059y/yUxeEtiix9oICachtf+Mt3eW3OaHpAzsLFQOKWt7NQY1fhCGpC4krzXNn6Q46MI69Z5YVCuhfsopMJtWj9r5Di++MuCKcYoCMC3R6VbFAvL1Fnok3TSv+0h2A7GUDBvncJh0eMZWvny5/Qu7uHMD6q3WaLkT2EHKjbg96TkAa5/Tja9E1+4ohd+bpuJLPlj0JGlpWnb/mLoXa+X3NRz+fsYhcAAcsgJ0ik9X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 01:29:00AM +0800, KunWu Chan wrote:
> On Sat, Oct 3, 2026 at 8:55 PM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > concurrent aging from corrupting the size counters.  This is no
> > longer needed: the per-generation counters are atomic, and the
> > active/inactive ABI counters are updated per folio and linearized by
> > the CAS on the folio flags, so concurrent aging can no longer corrupt
> > them.  The same argument already allowed folio_reset_lru_refs() to
> > drop the lock.
> >
> > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> > read lock around the lruvec lookup, and drop the spinlock entirely.
> >
> > Without the lock, aging can advance max_seq while a promotion is in
> > flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> > flags can return to the value read earlier and the cmpxchg succeeds
> > with a target gen computed from a stale max_seq.  Recheck max_seq after
> > a gen-changing cmpxchg: if it moved, account the committed update and
> > retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> > The retry may count the access twice, which is acceptable and avoids
> > folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> > orders the flags read, including the one returned by a failed
> > cmpxchg(), before the max_seq read.
> >
> > Also simplify the post-CAS accounting guards: gen is only assigned
> > non-negative values after the old_gen < 0 early exit, so gen != old_gen
> > implies gen >= 0, and lru_gen_update_size() needs no explicit guard.
> > The active/inactive ABI update keeps its gen >= 0 check because an
> > off-LRU folio has no lruvec to update.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 10 +++++-----
> >  include/linux/mmzone.h    |  3 ++-
> >  mm/vmscan.c               | 47 ++++++++++++++++++++++++++++-------------------
> >  3 files changed, 35 insertions(+), 25 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index ee7fcbe2366b..b68d68101248 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -293,10 +293,9 @@ static inline int folio_lru_gen(const struct folio *folio)
> >         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
> >  }
> >
> > -static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *folio,
> > -                                      int old_gen, int new_gen)
> > +static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
> > +               struct folio *folio, int old_gen, int new_gen)
> >  {
> > -       int type = folio_is_file_lru(folio);
> >         int zone = folio_zonenum(folio);
> >         int delta = folio_nr_pages(folio);
> >         struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > @@ -371,7 +370,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
> >         /* use the refs from the atomic snapshot to avoid raced update */
> >         refs = lru_get_refs_flags(flags);
> >
> > -       lru_gen_update_size(lruvec, folio, -1, gen);
> > +       lru_gen_update_size(lruvec, type, folio, -1, gen);
> >         if (lru_refs_is_active(refs))
> >                 lru += LRU_ACTIVE;
> >         __update_lru_size(lruvec, lru, zone, delta);
> > @@ -389,6 +388,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
> >  {
> >         unsigned long flags;
> >         int gen, refs;
> > +       int type = folio_is_file_lru(folio);
> >         int zone = folio_zonenum(folio);
> >         int delta = folio_nr_pages(folio);
> >         enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
> > @@ -411,7 +411,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
> >         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
> >                 folio_set_active(folio);
> >
> > -       lru_gen_update_size(lruvec, folio, gen, -1);
> > +       lru_gen_update_size(lruvec, type, folio, gen, -1);
> >         if (lru_refs_is_active(refs))
> >                 lru += LRU_ACTIVE;
> >         __update_lru_size(lruvec, lru, zone, -delta);
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index e096fd0a5047..d78e3f97423e 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -558,9 +558,10 @@ enum lruvec_flags {
> >  #define LRU_TIER_MIN           0U
> >  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
> >
> > -/* Access source flags for folio_inc_lru_refs() */
> > +/* Flags for folio_inc_lru_refs() */
> >  #define LRU_REF_MAPPED         0x1U
> >  #define LRU_REF_EXEC           0x2U
> > +#define LRU_REF_FORCE          0x4U
> >
> >  #define LRU_REFS_REFERENCED    0x1
> >  #define LRU_REFS_WORKINGSET    0x2
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index ae4a0522a8d5..9cc06a95d931 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -982,38 +982,33 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> >         long nr_pages = folio_nr_pages(folio);
> >         struct lru_gen_folio *lrugen;
> >         struct lruvec *lruvec = NULL;
> > +       bool aged = false;
> >
> > +retry:
> >         old_flags = READ_ONCE(*folio_flags(folio, 0));
> >         do {
> >                 new_flags = old_flags;
> >                 old_gen = lru_get_gen_flags(old_flags);
> >                 old_refs = lru_get_refs_flags(old_flags);
> > -               file = folio_flags_is_file_lru(&old_flags);
> >                 refs = old_refs + 1;
> >                 gen = old_gen;
> > +               file = folio_flags_is_file_lru(&old_flags);
> >                 if (old_gen < 0)
> >                         goto out;
> > -               /*
> > -                * Lock the lruvec if the folio is on-list. We are already
> > -                * doing lazy promotion so in theory we don't need this,
> > -                * but for now, concurrent aging would still corrupt the
> > -                * size counters.  This is a temporary limitation and
> > -                * will be lifted very soon, so the lock here is not a
> > -                * performance concern.
> > -                */
> >                 if (!lruvec) {
> > -                       lruvec = lruvec_live_lock_irq(folio_lruvec(folio));
> > +                       lruvec = folio_lruvec_live_get(folio);
> >                         lrugen = &lruvec->lrugen;
> >                 }
> > +               /* Failed cmpxchg() does not order old_flags before max_seq. */
> > +               smp_rmb();
> >                 max_seq = READ_ONCE(lrugen->max_seq);
> >                 max_gen = lru_gen_from_seq(max_seq);
> >                 min_gen = lru_gen_from_seq(READ_ONCE(lrugen->min_seq[file]));
> >                 if (old_gen == max_gen)
> >                         goto out;
> > -
> > -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> > -                       /* Promote second page table access or executable */
> > -                       if (refs > LRU_REFS_REFERENCED || flags & LRU_REF_EXEC)
> > +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FORCE)) {
> > +                       if (refs > LRU_REFS_REFERENCED ||
> > +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
> >                                 gen = max_gen;
> >                         /* First access only defers eviction from the oldest gen */
> >                         else if (old_gen == min_gen)
> > @@ -1037,9 +1032,19 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> >                         break;
> >         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> >
> > -       if (gen != old_gen)
> > -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> > -       if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && old_gen >= 0) {
> > +       if (gen != old_gen) {
> > +               /*
> > +                * Gen-index reuse can fool cmpxchg(). Retry locklessly, accepting
> > +                * an extra reference to avoid folio_activate() latency.
> > +                */
> > +               if (unlikely(READ_ONCE(lrugen->max_seq) != max_seq)) {
> > +                       flags = LRU_REF_FORCE;
> > +                       aged = true;
> > +               }
> > +               lru_gen_update_size(lruvec, file, folio, old_gen, gen);
> > +       }
> > +
> > +       if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && gen >= 0) {
> >                 enum lru_list lru = file * LRU_INACTIVE_FILE;
> >
> 
> Hi Kairui,
> 
> One question about the retry path.
> 
> When `max_seq` changes after a gen-changing cmpxchg, the retry uses
> `LRU_REF_FORCE` and promotes the folio directly to `max_gen`. In the
> normal first `LRU_REF_MAPPED` access path, the same folio is only moved
> to the next generation when it is in the oldest generation.
> 
> Is the stronger promotion on the retry intentional? In other words,
> does detecting that `max_seq` advanced during the update justify
> promoting the folio all the way to the newest generation, rather than
> re-evaluating the original promotion policy with the new `max_seq`?

I think we are fine, that window is very very rare already, and the
problem is we may cause hotness inversion if the gen number lapped
with each other. To making things easier, if the max_seq changed,
just force promote it so we won't lose any hotness info. It may
over protect but the chance is like once in a million so I think
it's fine.

