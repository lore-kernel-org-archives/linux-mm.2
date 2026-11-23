Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7541D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=elypIc2L
Received: by kanga.kvack.org (Postfix)
	id 6F1486B05B2; Mon, 23 Nov 2026 05:49:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2236B05B3; Mon, 23 Nov 2026 05:49:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5905D6B05B6; Mon, 23 Nov 2026 05:49:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC1B6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:49:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A452C16082E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:49:19 +0000 (UTC)
X-FDA: 85466062038.07.B06764D
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id CC34540006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:49:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=elypIc2L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795430957;
	b=3CRgZUje5/SMJ/OBdvsdsjuQ64uRtV2hwosImZpHNrk+REWk7euYh0rSFXt+FIXau7aKva
	0eMdYV1FpEAjwgE49jzCGgdAdrM2Ud03AeCbYGE1S2KBv+JwVR2k9zhsux5dSDrxrSczLj
	9rU91dY/TS4wXcPb6x30TM1aXyllP0o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795430957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ggRC6iWaNAZz8PBBX98LO0tMriK9ErQOsDnRJRUWcI=;
	b=zNfMTcvEIE7JwY8YVcaWflWn7f1kZ+xScdG7mFf264eLwSznRU4GVqj9iDSOyKBOhCWw08
	/qXXJY+07fc7F+Mhq5KeqKA+muNnHx/cC9C0owWaNSfrzd0lX9rEu1KkWcTaDeqhSPgeCW
	VTNFbGTT9MDuUSuPOYN5Xw3mH1xej/E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=elypIc2L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cde7e8abf9cso715321a12.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795430956; x=1796035756; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/ggRC6iWaNAZz8PBBX98LO0tMriK9ErQOsDnRJRUWcI=;
        b=elypIc2Lw1Vi2MUkw4fJYWZ7djVh68H3c5cZ61xC9YBQ/b2EJ+07szHtC9QtC8UK6d
         jtqxBdx+uzJdZXOIzJloPuycakdKs1AzwfuRxeZJ2FpxNUMAJRYRZXEdv6DPIh9YBE9a
         FMsd2yGS0BK0/S3VEtl1m9kN1Ag9LhhaNm0PaAn7mkq50Pch0LtoGQECoD1IDjrNg8ou
         inWnik2QNZBwJ1qpLwAGeud9RigvSZFFUky4ENKQvBbkBCjg2yxttITWHy0WSatS0hqJ
         T4NjfIJEcZ+DjNjrrju8G0uFwVGIzyY5KZRPy1Rsu3Go9BO3WMyzOqNSyE4FjqPCuMLw
         qAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795430956; x=1796035756;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/ggRC6iWaNAZz8PBBX98LO0tMriK9ErQOsDnRJRUWcI=;
        b=AfuOhwLOJsnh2QVG6bkuoS2dnplj79V8yyHuqLXA7+GoYL9wrkw2v0ZBYwlJwPI0uD
         LY0AVz8Ks6Q6ceo661EAkyyz/DxNMf9TucFlmhV+Y3X2JRjGsfpVpNN7Iiomt0EZp42M
         fEoA4ssIV89KJsa3stAn7qI0LFibSd5iQ/CVM8I6DW3LoHwufRUgUauuiuGQbuhtNHj8
         XzRg93lCEV1PSDlkjCr4T0cNl7K9xSdIFY28FE+7GvCkW48Mnw+7A6KXC3soGOrsl7Lq
         keDZCOK2sotncywVar8fP9LJI8kmAQcEeNqxnixjGM3LMPdarODQPXs4kZKJzF6uMGx4
         3GkQ==
X-Gm-Message-State: APuU4Z+m+Gm3xuHL+qb/Y/vzVHGJoDmD3XWl3a5r0VRaTuLJ92Gsxpzh
	RjJGRXaht8DDGZnsT/MluZQICwb83Mrpij5IqlpD+5X7ehX8LCC6Vijs
X-Gm-Gg: AZFdTZdpldSQEOVJfWLq369kbVwmVfik8ina2QaTFDO7YQSlZYVMWpFUhG/Tt9mC29L
	a6bmknZJIkzkd44pGpIi3awv72n6PB40z3uNyAATTC8Z7KXIoXgOOZGI2cbVPvyeO9WTH+GuTOO
	urQsgudqWzf4iLjyHuBQOS4BDGp6py8WX46qYsvQsCGAObjL6yFb/OJzDpgo7dijHFAq25mBB/+
	tUCNX7yaROGSBkLczOUvYfBLFVBlw50UtDi9EIOiIcwC5DSbBThb8AICPruymA6vXVRkWRuj1p9
	1QgTX7uQHWojB34yi3jfTghl6vvIBQ/lIjFEdDV2jsEEwVHlmHh+OgIzATQeFWuBpcTI3gRlw2n
	IksahUo5gFeFPtCVi1iCUV6QtTW/mSNBFz+yQR9Uxo4XAB2QY861SIrQq9Oepf0wCzKI+AaNUDx
	5ZQUZoNyQB+SYVWTD6vJT14+BIlnMOTj8we1koZBgBtuSXzf/IHVfuPpnMcTw6qKLDiZlvWCSe/
	dpumeYxwCX2ZN9UPzxoS/kes8pq3MV/TivQo1Pv6u0GQRgkeZe8XuILxjfKWbMQrYSIBZhgkB7n
	IKkNmtVXYXDB+QPWuGj4WMGbGMCo6ZeIZkUIoCgwROZr/ZNytsVwb+vvOLE32ZxRaK4J
X-Received: by 2002:a17:90b:3148:b0:3b3:cab4:5060 with SMTP id 98e67ed59e1d1-3b41c8ffa9fmr10353009a91.17.1795430956275;
        Mon, 23 Nov 2026 02:49:16 -0800 (PST)
Received: from KASONG-MC4 ([114.254.2.55])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad48786sm17613203a91.9.2026.11.23.02.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 02:49:15 -0800 (PST)
Date: Mon, 23 Nov 2026 18:48:54 +0800
From: Kairui Song <ryncsn@gmail.com>
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 16/17] mm/mglru: make folio_inc_lru_refs lruvec
 lockless
Message-ID: <awQTdkOPG_bKkY1a@KASONG-MC4>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-16-9eee2fe97a2d@tencent.com>
 <CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com>
 <CAMgjq7CEdWvv8m9GtWMG=8OFy+1Sehx3HBJt2D=9hntwvfbf6w@mail.gmail.com>
 <CAN_Opa8L3Ygfu5o7Y8ZD9GTmiEygCXpq2TzAJtwgQChdyb2dSQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN_Opa8L3Ygfu5o7Y8ZD9GTmiEygCXpq2TzAJtwgQChdyb2dSQ@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CC34540006
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dq4a5s19ezfb76i9samo59yg3oeucqpd
X-Rspam-User:
X-HE-Tag: 1795430957-740302
X-HE-Meta: U2FsdGVkX19LTqMxACgLFpsBSiC7GYIogsOB3phGr/xrM+/pUfCbSsGS6DoG7Q73UoZas+AkC+J/21bUqf0uTeiCi6fDPmpmAMu6jYrDlaNzRl/0fIjhXU+95zce7soes1of99U5zvauGhYgxzLyKbX6OEA7rKeUwkqRA7yQe7gFtqXfU5HbQ+FeoUOiMKI2ldNU69OrNi6TcY3/ZLlK9rPCKOUSMI5WsEXWKvlPXHPQpnGz1YnHnwZDg7vDip7ANpajLcQKSOEiOrnRdQR8KR+HUniF0V7BQD/pCf0ZTerS9hlsydJztOAGzzW3hqdO/inzm7Mgtupbb/6EOJlDLRf2GeRjAGRdXQ+HeFavl+c+gHA/pB4K5+hLtcKsyHuBeefPgs5cja18TjIY4l1i98GD70iR17NZ/Zk5WPbBpJgU4ib46wHNJipgVnbnNxgXmzQETONJnVIaMt+WME1ogN1A8OAVIYR7012Qqiim2eFlHz2RNxCSL/WuZYKNDSXZ0LbozhNizkzy3QDVkOrLy1gHpDLfys7AkLtX869o7xwdd1bS+2+2AwUCeV2yUVwjoIOmkr+6qf8zv61KAwxIRadpqvd0ggcPKuYhoXyxFU0B1OtGZz+kJATsOMbq3DUL3JJlYvwdxjW2mDMYaiB8bIeeLqjVung1grtvBFgX3/61rGrdhqEX9kWluaOXsVN45UlWHP/rQA0anueDaiaQQ+oSj5QQVgQyJLtZq/569wUfzsfD3cqni8/IHOvqPHwpNdt3UyzVSL4IiZNaPCDIo7ADBlowL+sa+QszxXJvsAMDLfUsboGXGW/1qU3ROYfhG6V3418G6fEtHd9U2mFJLNQjV/k3uIx9LTiuiJUildCD1NvYmBdMjeM7NpJTulnYr5QB3JPY6ANi1L9/dZL269ggxben8Xs/zSuXNB+H4Pyacob9rxCZEO2QjZ+OjTBFKkLB1fRd7MXHNhfuvtt
 oS2wZ1Lk
 ZM307yLq+IG/Dwodj2iSxrQZB/PbE1yM+3pd9Z6q2ZjamOH20K8m5dylc5oExGIJQDG8BJfRPMsXESY7cylM59ukzPH76T9EgfUOfIqhgXu65LdfC8ucQgjB4162J9RwtuNs0uCykxS5SN988n3pHNJ+fsKnuz8SbS8uSDW3qRTY8DHzbvKPqZQS22x2d206TaRZaz8Wb2lLXt/FmGeSi0N1oFdgEeyQficCtovunFnIhytNcB2SsngHzf/DefhTPt440BIPjSFGcmmc/v99YwKB4Xna90yvjqGeOsXgsPwBkhngs6XDCEhS56K32uaRQnBQJYLw5F7+W13ZkD0VechXSNLDggMtT2nVHsI/bjllw0TqR8bSL42oZxExXdMU0V9EPS278/FvjjWJzjslV6lUeAHUdP9x3+eErivoafzCbXFr+KW+8AIbLx39p+xplIInMTo8qMhEmqS7YYwoIHkxYzUc2EKAC8jteyKZLuxriT1HUuAGA2p1G9k/PipEN4d5ALnTugyUYHclvnfRJJ/GgFGYZMlGrI/7hT/kCEsqU5hIAEKlaAIS3hJjcbTWDVllqk/peLvLcVCv7mhY4fg2U6zdF+yszavQIorfNkZO3tg7kYkryv7C7x72mEfILwjznPz3/FfwjA9pbWsnkP5/doU/TePs17Vx11CIEbujExcQGcKSbjLCDa4oQaJiteSt/jrqUXcbwQBSitzZuJOrC87536xt4w9YmBBBaJnqT9GUF7YpoZxWytDV9EdUTjUY8XfEj+dYgc4ZzFmiMVzsv0PjiyAPmr8IXCzqwAaLALqFU+cLz7QS/q8WRoI7NzzTzkf2q2opuE2YNHZJ/o4sqC9bAZufWH7ImYc+ago6ShzHuG3dg0egfxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 09:43:12AM +0800, KunWu Chan wrote:
> On Sun, Nov 22, 2026 at 11:33 PM Kairui Song <ryncsn@gmail.com> wrote:
> >
> > On Fri, Nov 20, 2026 at 5:42 PM KunWu Chan <kunwu.chan@gmail.com> wrote:
> > >
> > > On Thu, Nov 19, 2026 at 5:04 AM Kairui Song via B4 Relay
> > > <devnull+kasong.tencent.com@kernel.org> wrote:
> > > >
> > > > From: Kairui Song <kasong@tencent.com>
> > > >
> > > > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > > > concurrent aging from corrupting the size counters.  This is no
> > > > longer needed: the per-generation counters are atomic, and the
> > > > active/inactive ABI counters are updated per folio and linearized by
> > > > the CAS on the folio flags, so concurrent aging can no longer corrupt
> > > > them.  The same argument is what lets folio_reset_lru_refs() update
> > > > the counters without the lruvec lock.
> > > >
> > > > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> > > > read lock around the lruvec lookup, and drop the spinlock entirely.
> > > >
> > > > Without the lock, aging can advance max_seq while a promotion is in
> > > > flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> > > > flags can return to the value read earlier and the cmpxchg succeeds
> > > > with a target gen computed from a stale max_seq.  Recheck max_seq after
> > > > a gen-changing cmpxchg: if it moved, account the committed update and
> > > > retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> > > > The retry may count the access twice, which is acceptable and avoids
> > > > folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> > > > orders the flags read, including the one returned by a failed
> > > > cmpxchg(), before the max_seq read.
> > > >
> > > > Also simplify the post-CAS accounting guards: gen is only assigned
> > > > non-negative values after the old_gen < 0 early exit, so gen != old_gen
> > > > implies gen >= 0, and lru_gen_update_size() needs no explicit guard.
> > > > The active/inactive ABI update keeps its gen >= 0 check because an
> > > > off-LRU folio has no lruvec to update.
> > > >
> > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > ---
> > > >  include/linux/mm_inline.h | 10 +++++-----
> > > >  include/linux/mmzone.h    |  3 ++-
> > > >  mm/vmscan.c               | 51 +++++++++++++++++++++++++++++------------------
> > > >  3 files changed, 39 insertions(+), 25 deletions(-)
> > > >
> > > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > > > index 77f514143266..2c6cbd0df686 100644
> > > > --- a/include/linux/mm_inline.h
> > > > +++ b/include/linux/mm_inline.h
> > > > @@ -317,10 +317,9 @@ static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
> > > >                gen == lru_gen_from_seq(min_seq + 1);
> > > >  }
> > > >
> > > > -static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *folio,
> > > > -                                      int old_gen, int new_gen)
> > > > +static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
> > > > +                                      struct folio *folio, int old_gen, int new_gen)
> > > >  {
> > > > -       int type = folio_is_file_lru(folio);
> > > >         int zone = folio_zonenum(folio);
> > > >         int delta = folio_nr_pages(folio);
> > > >         struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > > > @@ -399,7 +398,7 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
> > > >         /* use the refs from the atomic snapshot to avoid raced update */
> > > >         refs = lru_get_refs_flags(flags);
> > > >
> > > > -       lru_gen_update_size(lruvec, folio, -1, gen);
> > > > +       lru_gen_update_size(lruvec, type, folio, -1, gen);
> > > >         if (lru_refs_is_active(refs))
> > > >                 lru += LRU_ACTIVE;
> > > >         __update_lru_size(lruvec, lru, zone, delta);
> > > > @@ -429,6 +428,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
> > > >         unsigned long flags;
> > > >         unsigned int refs;
> > > >         int gen;
> > > > +       int type = folio_is_file_lru(folio);
> > > >         int zone = folio_zonenum(folio);
> > > >         int delta = folio_nr_pages(folio);
> > > >         enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
> > > > @@ -452,7 +452,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
> > > >         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
> > > >                 folio_set_active(folio);
> > > >
> > > > -       lru_gen_update_size(lruvec, folio, gen, -1);
> > > > +       lru_gen_update_size(lruvec, type, folio, gen, -1);
> > > >         if (lru_refs_is_active(refs))
> > > >                 lru += LRU_ACTIVE;
> > > >         __update_lru_size(lruvec, lru, zone, -delta);
> > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > index 2680e15b6de9..235fb04f8d78 100644
> > > > --- a/include/linux/mmzone.h
> > > > +++ b/include/linux/mmzone.h
> > > > @@ -540,9 +540,10 @@ enum lruvec_flags {
> > > >  #define LRU_TIER_MIN           0U
> > > >  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
> > > >
> > > > -/* Access source flags for folio_inc_lru_refs() */
> > > > +/* Flags for folio_inc_lru_refs() */
> > > >  #define LRU_REF_MAPPED         0x1U
> > > >  #define LRU_REF_EXEC           0x2U
> > > > +#define LRU_REF_FORCE          0x4U
> > > >
> > > >  #define LRU_REFS_REFERENCED    0x1
> > > >  #define LRU_REFS_WORKINGSET    0x2
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 78a1b4de7076..4576a7a369e3 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -876,37 +876,35 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> > > >         long nr_pages = folio_nr_pages(folio);
> > > >         struct lru_gen_folio *lrugen;
> > > >         struct lruvec *lruvec = NULL;
> > > > +       bool aged = false;
> > > >
> > > > +retry:
> > > >         old_flags = READ_ONCE(*folio_flags(folio, 0));
> > > >         do {
> > > >                 new_flags = old_flags;
> > > >                 old_gen = lru_get_gen_flags(old_flags);
> > > >                 old_refs = lru_get_refs_flags(old_flags);
> > > > -               file = folio_flags_is_file_lru(&old_flags);
> > > >                 refs = old_refs + 1;
> > > >                 gen = old_gen;
> > > > +               file = folio_flags_is_file_lru(&old_flags);
> > > >                 if (old_gen < 0)
> > > >                         goto out;
> > > > -               /*
> > > > -                * Lock the lruvec if the folio is on-list. We are already
> > > > -                * doing lazy promotion so in theory we don't need this,
> > > > -                * but for now, concurrent aging would still corrupt the
> > > > -                * size counters.  This is a temporary limitation and
> > > > -                * will be lifted very soon, so the lock here is not a
> > > > -                * performance concern.
> > > > -                */
> > > >                 if (!lruvec) {
> > > > -                       lruvec = lruvec_live_lock_irq(folio_lruvec(folio));
> > > > +                       lruvec = folio_lruvec_live_get(folio);
> > > >                         lrugen = &lruvec->lrugen;
> > > >                 }
> > > > +               /*
> > > > +                * Read the flags before max_seq, paired with the store of a
> > > > +                * gen, which samples max_seq first.
> > > > +                */
> > > > +               smp_rmb();
> > > >                 max_seq = READ_ONCE(lrugen->max_seq);
> > > >                 max_gen = lru_gen_from_seq(max_seq);
> > > >                 if (old_gen == max_gen)
> > > >                         goto out;
> > > > -
> > > > -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> > > > -                       /* Promote second page table access or executable */
> > > > -                       if (refs > LRU_REFS_REFERENCED || flags & LRU_REF_EXEC)
> > > > +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FORCE)) {
> > > > +                       if (lru_refs_is_workingset(refs) ||
> > > > +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
> > > >                                 gen = max_gen;
> > > >                         /* First access only defers eviction of an old generation */
> > > >                         else if (lru_gen_is_old(lruvec, file, old_gen))
> > > > @@ -931,9 +929,19 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> > > >                         break;
> > > >         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> > > >
> > > > -       if (gen != old_gen)
> > > > -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> > > > -       if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && old_gen >= 0) {
> > > > +       if (gen != old_gen) {
> > > > +               /*
> > > > +                * Gen-index reuse can fool cmpxchg(). Retry locklessly, accepting
> > > > +                * an extra reference to avoid folio_activate() latency.
> > > > +                */
> > > > +               if (unlikely(READ_ONCE(lrugen->max_seq) != max_seq)) {
> > > > +                       flags = LRU_REF_FORCE;
> > > > +                       aged = true;
> > > > +               }
> > > > +               lru_gen_update_size(lruvec, file, folio, old_gen, gen);
> > > > +       }
> > > > +
> > > > +       if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && gen >= 0) {
> > > >                 enum lru_list lru = file * LRU_INACTIVE_FILE;
> > > >
> > > >                 __update_lru_size(lruvec, lru + lru_refs_is_active(old_refs),
> > > > @@ -941,8 +949,12 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> > > >                 __update_lru_size(lruvec, lru + lru_refs_is_active(refs),
> > > >                                   folio_zonenum(folio), nr_pages);
> > >
> > > Could this leave the parent's local active count too high?
> > > Isolation can debit the child's active count after the refs
> > > 2 -> 3 CAS. If CSS_DYING is set before the stats update, the credit
> > > can go to the parent. On SMP, reparenting can clamp the child's
> > > negative local count to zero.
> >
> > Thanks again for the careful review.
> >
> > But hmm, I'm not sure what you mean by "too high". Maybe there is a
> > temporary skew of counter due to various races, but we are fine with
> > that, it will be consistent soon.
> >
> > The key here is update is gated on gen >= 0, and the gen is part of
> > the CAS: only a folio that is actually on an MGLRU list has its
> > refs-based active/inactive credit already accounted will be recredit
> > the counter update here. An isolated folio has no lruvec to attribute
> > it to, so nothing will be changed.
> >
> > And for reparenting, we are also following the ordering in the
> > document: the updater holds rcu_read_lock() over the lruvec lookup and
> > the counter update, and reparenting waits for a grace period, so
> > either the memcg is already dying and we credit the parent, or the
> > update lands on the child and is part of what reparenting moves
> > afterwards.
> >
> > So the credit and the reparent move always cover the same folios and
> > land on the same side: there is no path where the parent is credited
> > for a folio it does not end up owning, and no debit that lands where
> > the credit did not. I don't see anything to fix here.
> 
> Thanks for explaining, Kairui. I had isolation after the CAS in
> mind, before the stats path rechecks CSS_DYING. I'm happy to leave
> that for a follow-up.

Hi Kunwu, thanks for review!

I thought again about this, and, there seems to be a corner case I didn't
notice, sorry I missed that. The reparenting used the clamped value, so
if the child's counter goes nagative due to temporary race, we will
indeed lost that part, and this should fix that, I'll include this as
a stand alone patch with your reported by:

(Usually we won't hit this unless the memcg have only a few folios left
 and raced with repanrting, and I think using clamped value for
 reparenting is correct on its own)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..3f551e2e3206 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -562,11 +562,10 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
 }
 
-unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
+static long __lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
 	const struct mem_cgroup_per_node *pn;
-	long x;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -577,7 +576,14 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 		return 0;
 
 	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
+	return READ_ONCE(pn->lruvec_stats->state_local[i]);
+}
+
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	long x = __lruvec_page_state_local(lruvec, idx);
+
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -595,7 +601,8 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 
 	for_each_node(nid) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-		unsigned long value = lruvec_page_state_local(lruvec, idx);
+		/* Reparent the raw value: the clamp drops the child's debit. */
+		long value = __lruvec_page_state_local(lruvec, idx);
 
 		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
 		__mod_memcg_lruvec_state(parent, nid, idx, value);

> 
> Here's my tag for 16/17, also sent in the 15/17 thread.
> 
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks, will be glad if you can help look at the updated v6 later too :D

