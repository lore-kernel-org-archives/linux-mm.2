Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A549606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=W+S01ofy
Received: by kanga.kvack.org (Postfix)
	id AC4596B05B3; Wed, 11 Nov 2026 12:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D566B05B4; Wed, 11 Nov 2026 12:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2DD6B05B5; Wed, 11 Nov 2026 12:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70B066B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:47:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 052A912034A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:47:46 +0000 (UTC)
X-FDA: 85423570974.19.C6C94CE
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id E15C5C000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:47:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=W+S01ofy;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419265;
	b=K1DlkhBQzym7XAgSIOlrHknTJnAWlH0HIiXgm5yTaPe5U9EXmA70DLRaDc8Sgwy2udWzXl
	TdYq3/X33BEHWJNRCvfwEF8EgW4cEDk5gqEcVBS/S+lMK4VDW76kcIVMy51ZSFW8zO8nUy
	mn0iqB8Qa+8wC3U0Dq25P5PDFGmzxaY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=W+S01ofy;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cavo6rumtYx83DhhSgHjGqxw295JLU9mSeXiMoOdbTo=;
	b=vTqkSWYKI15vraWKrUVtbyuaxo83tHwFwhuONnD9xsEYEAjox6fRLczPQWSIwQnfV3f9e3
	3mYFsPoPhenDc0jzRuaWVmKkahCWW1oJ7iJE/qRZ6sLG0qnbr4MpdxDUiq1wdm7BJPkEL1
	MZT3MaHmAN5XDwlLYReAPQCufQ+w9Jc=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so34775605e9.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794419263; x=1795024063; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cavo6rumtYx83DhhSgHjGqxw295JLU9mSeXiMoOdbTo=;
        b=W+S01ofygv3nW2j1/BolJMiDAuft6jbpy/uPTRYmANN81zFkr20yOvmTbJvZcWcA4r
         2ELau+1mHwVmybnRqjwLPXSlHEfYD3G7t6/EJRiOYW7+DiXRiskJN+2IInidf9Mpa0/4
         0pqnfD6MkgFvRf+qBydqszz3h+VAMKefAVDJoQ0uGTbj6WDoCJft4NlaIiUmTG5XGkLA
         OHNEjDC5zg3jdK3FkIwe/hP0/JtFflIWnzg/v5v9wNuafrOtZJQ+XZcxFPEz2UbFF687
         KDcQR+BOWyiDdhu9J6CO4+IoQcaWX+dLuQ27WfnwKYHXjySLvzlTxZ/M+mYUVy3hIVeK
         wvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419263; x=1795024063;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Cavo6rumtYx83DhhSgHjGqxw295JLU9mSeXiMoOdbTo=;
        b=peAj8j5Nq1ua46sHDpWg76TxYpnthL71ybAUjqB7hDVBjS5ZY4ADRwGf9s5qIdzAtd
         iIvDwZy1KwuOy5L1J86W9Z9VU+6CxYFT4C+zcwIWb6PNrgHl2lYGCC0khKhp+vGhHRHu
         wnhpKvO/f/8szEjBXbOeYSpanYXuZzXxi2qDKyML/wxK2p9P2z5yw7sX6g+771uQP3hS
         /A4Mf6PNOLgKPOP4xvvERCMO5bo5m2XahTNm8SN6L1Y296gj8ADDFKvpmzT2zYh3W8d1
         1qejzROXaQzo2aGcqGY2GB//gVanTUBhLXZHqVkGG7Op3XOzf2JfPCpE7xbSc8vpe+AZ
         Bv5g==
X-Forwarded-Encrypted: i=1; AL+hErEZ5ZXARrtCWfUS1ab2JR4ZqPW/lA8kwCnYFwjWMZ+U5dbFPio8k1Q/Sn4cvcdOFLFibaDe5nmC4w==@kvack.org
X-Gm-Message-State: APuU4Z+25k1YAnd75CkdgDwU+I6FAYAPrZESwoHCjzvZ6HHgFKhT4aB6
	ahAeEpE3DZUjYD38ccG+zQ0L6si/gsuaac3ZjBBJsluj7DynnfvYzZ4MjlYUEnzxv7Q=
X-Gm-Gg: AYBFou2F36fz40t19X8iTzbgZva9RBqAetyVCM+V7fCQRUDXrqdPiniW4BlPiQ0Hxkf
	uRLP09L4D62qHpUj1LuUCWbiBb6qnl5XNpY2S7uBkm+6+zLMeKp7caPdZthbLchdt1sVsInbjwE
	6bcrS525Ku/L5MjrPl/H++/DrTkdC7w7pHygExXd0E2+BheK4TAZn+Cz83IsrA7h6Tk5AIob7Iz
	EGusPsJ6oOH/4LAG2tWEoqlmkBg2msoxys/qZt0M17dDkkRxzUFszoCvSm2hYue180902bNdcHf
	6F/66+GlF4+e0Jtqj+PcG9INdwwZnIV/6QSi+yWoFKukgGvkru1qkgFLUjTDc6y4Kn1QgNwltB8
	1CoJRzJLbmaHRLg4HlrqGqFBl7ZZCLXc1Pdck+CnwTOesExR5JliBYblgto8YQHvfkLGBf+bGE7
	W+oywRyxRNXMKmX8NKhwVFYe4NipXLR8XPt00nuk+/61QJQR93jK1GcWlx7991OuYHNYZLlmlKS
	o5sKfaEsVWNTNEDqR3ad+dEgWfOnbEb3Ju0h4/q777zYKwum5mW5Iv+7cVCDxeL2BmuYla+I9Ur
	Hi/RF3JOd/saBfJE79eB/BOuXXzLLTKMVxOq1YkgdjMhv45+PQNFaA==
X-Received: by 2002:a05:600c:3f07:b0:4a5:87a:50ba with SMTP id 5b1f17b1804b1-4ba0938a6a7mr55235815e9.33.1794419263442;
        Wed, 11 Nov 2026 09:47:43 -0800 (PST)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2593e4sm5375895e9.5.2026.11.11.09.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:47:43 -0800 (PST)
Date: Wed, 11 Nov 2026 18:47:41 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org, 
	yosry@kernel.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, ljs@kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, tj@kernel.org
Subject: Re: [PATCH v2 2/4] mm: memcg: read root lruvec stats from the node
 counters
Message-ID: <avSqMxGjwYPrQLlV@localhost.localdomain>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
 <20261110015321.611093-3-joannelkoong@gmail.com>
 <sashiko-outbox-206041@kernel.org>
 <CAJnrk1aQrRE78wqd2yZWS2Sk8MiCHd9x0dveZBh5LHE5w75nkg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1aQrRE78wqd2yZWS2Sk8MiCHd9x0dveZBh5LHE5w75nkg@mail.gmail.com>
X-Stat-Signature: g3jruqwr95it5edc6td97fu4h4thaw8y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E15C5C000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794419264-57526
X-HE-Meta: U2FsdGVkX18NevIiK8n10UAGx1dNOGJxD4SNWr8O3VBVZGji/ElGwvjf81yQJT30O067RJ5E8uuT9JW+Ym+qSKVUCi2xOtcu7pJutvBXAdKKbiq8IE1d4+RpxIWQHd6nI3Hzp7I+pRkD4RHV3sNTCBNXgJy6yPLyD0NmK2mHXuJVGcJUEEHejmp5FEaNwPXovXBXCBQQxOc1670z6xcf3nfsEeMBpjq5KSP28SP2vJmLFlBVDm8shvtw3M/bs1wPrmK8EcN1q0tNX+C8d9O+WhGRsO8ktascTr966nzE6RgaVN5uErXU5PUbDXjLIllakOPaoKeNDJOQsPHy6lGBaxHjLHpPXfzmC01Y290mX8i6v6cuAhay6auWadVoLurq+BDX8Lbq1f2+MCcNOirMxCqLE5SLtnZYh1ZPFZMO7nnY3TBSy7ItfV/cgaBnzYEKXFaPb1dzYUIOaIQjZC+Cg1VNMufBnz5S5dMopzzYAU0AbYEnJYTirOecN4htecvV8kWN/ygd+g4lYt8FlDsK8VRle8K5jYoDQbJ+wQdHVrC+VGRM0Nd9mg9uWZa5NWp3HbryuO9dGnmBSicK84hyixcsimjQmzsDRhaaAxOQerIE5aYRrjp4NzWmHfCkIqoIBTCDCka8Z63SWd+DzdeFxY9vrbnii9SRT1dSGXfbWqlGYUJFAKyamVa4l9BXU333wIBJ9wNcHMaYOMv/boPB4777iSGaWbxhg+deZDhtsyrD7txc/j75V/WdBIVRdYZglCKQrtDya1Ka1AQhuBWYJ9h/gbYCtRvmI60t/Yn6RUJ91lc1b8vVW5NjXX5oSWqhtadEQogIf5a0WiIcPk+zOJVnHy9xjlGZUQphMU/Aops5XQjmre9wjPLM4UJJgFC/2U6GcXO63YSzHmAoTjxxLXZeVTtyG/qmwQ7qi8R1xc5Ye6CdaRUyBibZkzMGSBjEBxEYvJaBuEOCo82HPKA
 VwtZorMb
 RbcHcp4IHxkf9V0P+46U+dqo+l3hNnaNYtIWiXyeTUwTPdahfOsL3iJ1y9cEJvk3f4RLeQtj4Io7XgdtdfzytXWm7u9niEFz+HhcXjpjbRLusbBRWy140/gQf6FPKupuZOxRZ0qHYsFth+T113/+8itt+Kobn+1gpJqwLCRiD0IA2byXmTFQt6voF8eCnPRNaDLsJTyYJrJy0TCaZWyV/jRTyN88VRcNLp78EF/cu6yGvJBgo2j4LSOgnxoNWUsjfHTK6hgpE6x4uv92hkdfrwoBysZNuYeOjOmYbgiwbAodMd/+UG5Adv9DKia+TACUN73iY6jWKSCzzccFwwoAByylK9frpbKxGghPyK3NDmljHkCWn8T83k6obLNP0kCsnFtXByz+BXh0eW/k6MX4HZn9En4RJrN0Xx1uZ37bJB8VcfQrmUfOk4nPvPc1JYi67epXrZx0BpE00KvHsrrAAsQOdBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 03:10:54PM -0800, Joanne Koong <joannelkoong@gmail.com> wrote:
> On Mon, Nov 9, 2026 at 6:23 PM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 1 potential
> > issue to consider:
> > - [Medium] mm: memcg: node_stat_includes_unaccounted() omits file and
> >   writeback stats
> > --
> >
> > commit d2ba314724a8ba015e3bf2a30f155f1beba25a8c
> > Author: Joanne Koong <joannelkoong@gmail.com>
> >
> > mm: memcg: read root lruvec stats from the node counters
> >
> > This commit changes lruvec_page_state() and lruvec_page_state_monotonic()
> > to read per-node vmstat counters instead of rstat values for the root
> > memcg when querying stats that only track memory charged to a memcg.
> >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 1ebc9330aeae5..2575bf2ba0ea6 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> >
> > [ ... ]
> >
> > > @@ -504,13 +511,52 @@ struct lruvec_stats {
> > >       long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
> > >  };
> > >
> > > +/*
> > > + * Whether the node counter for @idx can also count memory that isn't charged
> > > + * to a memcg (eg kernel memory that isn't accounted). For these stats, the
> > > + * node counter can be larger than the root memcg's value, so the root memcg
> > > + * has to read its rstat value instead.
> > > + */
> > > +static bool node_stat_includes_unaccounted(enum node_stat_item idx)
> > > +{
> > > +     switch (idx) {
> > > +     case NR_SLAB_RECLAIMABLE_B:
> > > +     case NR_SLAB_UNRECLAIMABLE_B:
> > > +     case WORKINGSET_NODERECLAIM:
> > > +     case NR_VMALLOC:
> > > +     case NR_KERNEL_STACK_KB:
> > > +     case NR_PAGETABLE:
> > > +     case NR_SECONDARY_PAGETABLE:
> > > +#ifdef CONFIG_HUGETLB_PAGE
> > > +     case NR_HUGETLB:
> > > +#endif
> > > +             return true;
> > > +     default:
> > > +             return false;
> > > +     }
> > > +}
> >
> > [Severity: Medium]
> > Should node_stat_includes_unaccounted() also include NR_FILE_PAGES,
> > NR_FILE_MAPPED, and NR_WRITEBACK?
> >
> > For NR_FILE_PAGES, swapcache operations such as __swap_cache_add_folio(),
> > __swap_cache_del_folio(), and __swap_cache_alloc() update NR_FILE_PAGES
> > only in the node counter while accounting swapcache in the lruvec under
> > NR_SWAPCACHE:
> >
> > mm/swap_state.c:__swap_cache_add_folio() {
> >         ...
> >         node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> >         lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> >         ...
> > }
> >
> > Reading node_page_state(pgdat, NR_FILE_PAGES) for the root lruvec
> > therefore includes all swapcache pages, which inflates the "file" counter
> > in the root cgroup's memory.numa_stat (double-counting swapcache alongside
> > "swapcached") and causes it to diverge from memory.stat even after a
> > flush.
> >
> > Similarly, __folio_mod_stat() -> lruvec_stat_mod_folio() updates the node
> > NR_FILE_MAPPED counter without updating memcg rstat whenever an uncharged
> > folio (folio_memcg(folio) == NULL, such as a driver mapping or a
> > root-cgroup __GFP_ACCOUNT kernel folio) is mapped into userspace, and
> > nfs_folio_mark_unstable() and nfs_folio_clear_commit() update
> > NR_WRITEBACK only in the node counter for unstable NFS pages awaiting
> > server COMMIT.
> >
> > --
> > Sashiko AI review · https://sashiko.dev/#/patchset/20261110015321.611093-1-joannelkoong@gmail.com?part=2
> 
> Thanks, this is a good point about the folio stats.
> 
> Hmm... I wonder if we should go with an allowlist instead of a
> denylist. The allowlist is longer (31 stats vs 11) but would be more
> resilient to failures (a stat missing from the allowlist just reads
> the rstat value whereas a stat missing from the denylist will silently
> report the wrong value) for any stats added in the future. Any
> thoughts?

I agree the opposite predicate would be more robust and potentially
easier to review (review only the _listed_ cases, not the "unknown"
complement).

Also, instead of

       if (something && !mem_cgroup_is_root(eviction_memcg))
                mem_cgroup_flush_stats_ratelimited(eviction_memcg);

I'd consider

       if (something)
                mem_cgroup_flush_stats_ratelimited_opt(eviction_memcg,
		1UL<<NR_ACTIVE_ANON|
		1UL<<NR_INACTIVE_ANON| ... );

and collect the exceptional handling in memcontrol.c:

        void mem_cgroup_flush_stats_ratelimited_opt(struct mem_cgroup *memcg, unsigned long needs)
        {
                if ((needs & ~node_stat_equivalent) == 0 &&
                        mem_cgroup_is_root(mem_cgroup))
                        return;
		...

This way in-kernel flushers will be expicitly annotated so that
potential mismatch is more obvious to spot (and it adds possibility of
future optimizations).

(This is all only a concept, it may turn out uglier when worked out to
details...)

HTH,
Michal

