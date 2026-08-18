Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E564C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB656B08EF; Tue, 18 Aug 2026 03:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C166B08F2; Tue, 18 Aug 2026 03:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD0E6B08F3; Tue, 18 Aug 2026 03:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D09C66B08EF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:41:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FC8DA0B57
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:41:38 +0000 (UTC)
X-FDA: 85113595476.15.C20E32C
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7DB68140005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:41:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TYsiERAh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787038896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VahNcEYmw+mGcn7LtyCZe2us9vTkZlTxAEikuZwKYxg=;
	b=CZ7Uy67wdI3suZ6V0oDQDHFXl4ljf7mCA+bZ3Cn8KuprIiHrEIIoUY/kCZPft9V92Sy+51
	BkV4RR6izzCRzYEeBrN4gH3hfqUZLR4IdVwzavLt9H57m9IiSYpkOECNPR0IbSOBLP6sF/
	52JnTyw7r7b3+GZSgG5OSwbqkXHuGlE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TYsiERAh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787038896;
	b=gf8/kJzMMSC0oJcbVHBgSnHqYPpY5SRC7iLoUDHZAtFj49HaJFCDvOSiSrBWxNGecME77b
	yu7meZMuqkGZ4zuiSw8ozB//JRb7b2NtIsWAd5QOajWOzdmujLsvAWKzmCQ9r0G++LOtbE
	B9rqYmnz3l/2kh+JXwzYDPJ8LuRzABg=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a0794669a6so7161591a12.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:41:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787038895; cv=none;
        d=google.com; s=arc-20260327;
        b=rugb9U7cAKqeczXb5PvIYZSfCC//KdqQd7IwHj9FxvtWxjv6i38oCPQlJ9C7yKQKEh
         xWT8PfA7rQdmsBoQi/xotAZlzg9ibvoQsh2C06VN2IQNlPF0o6rLOt/Pqk7uMwNKY4ol
         C+yTOPHII6AZpoe0hsO1CBx8SA7I4W3wSaMeYrZn8WIv2OY9iatVQ7p5qF4JBXQiOPww
         OdiRseIDFWK2qRG9uV8V/YCDp02MQorUdqbPANfSbeIUhGLiQwnzjTSu0qPG33sW8Eth
         saCNncv23z3CBFTLRlN9Q+gCb5biJjUHRQH/g75RLiNBTkc+V+3yxI5CbHH3E7kGjEMg
         srKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VahNcEYmw+mGcn7LtyCZe2us9vTkZlTxAEikuZwKYxg=;
        fh=Ig90bcx6qOexKJCJoXpsNu2qlrCnTN35tWkrCKDUqE0=;
        b=noJT4dfL/SNvTGrp5FUC2I99XhTg0fNnpwAYAn5NesjqPZiFYCp01te2jb0PVcRNW0
         +LcPM2cl5bKnbzxEFHr8Iwf6qigibNHZrvJ2FSy9N13GGDzYltAjvfnj0CfXtuXoMAZm
         U6d+MXonZKxtvIUcawS0AA2YnwEaAIALR6qC4rTyC1CG6b805Qg4LGo9m5Om9RmWTZSj
         noKmdfmNWtAVt5Qsn8TkAqi5IdNd/Q8PuxgLHkR6micCULHwQMM2bE3zhk/Ceqost7PD
         PBu3oj8m21vK3+SRQIXmXXn0tVRQ6E7YT1XllOI2G86FVoopN/q13YVLse7Z1Uz40qdL
         Sw9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787038895; x=1787643695; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VahNcEYmw+mGcn7LtyCZe2us9vTkZlTxAEikuZwKYxg=;
        b=TYsiERAhWZ+K33sMtcBmrTOkyxFQq+TKjEdp9/k/neqmQdITWe7jqJ6w9y0zt1EG4s
         6DEFZg0TZ70y6MXj/qs5nQuyYE0XO4sAVeQSDRIkgJYCl03Kr0wlw2WUAhEsqS4SVbn0
         8ydgVRJWwXQyBzW6Qqbyhg5dhMoKgMsm2RTyc7j1KrndfinU/xUcdfXl+d1zbiebuWy3
         BKaI5hjI77rLm4V3n6ZJxganqVAlzdURMLA8kVquAIqQXu1KCSUcagt9MsyX3LLlnlR6
         oaqd/1Ci+2xlSZdG9JiwGfemXZLIk5Uwc7h3CGKPRfWo+7ye45hmD8y2mnNUJetsws5C
         5j8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787038895; x=1787643695;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VahNcEYmw+mGcn7LtyCZe2us9vTkZlTxAEikuZwKYxg=;
        b=WONliH8OKLMNkdXd8EsTCS/x4YqEqPFGfEGCf8ydWgo0qdSa96T8roLfIztI2sbqrT
         CJ9qemhJ8trCO3aCJXEhZu2WvNPF5SY5BWALWMxkrjqpWBUSt1a4SV/VwojopC2YApZg
         TNzkO/FAXBmzcSi7Qwnv2nV7jXPhz3HA056EVxBHmoSi2Ba7P4HO5ApoYu1bQm2INEro
         mq9xVXHFekZqlGlbtb89Kmc/QPr6580+GLRH3cRkbtVIWPh6M4GlwcKNqVV0PZQr2HLA
         XaMk19q+8ugThhqkqT433Ye241f1FZeTKQuoQUJhCRbl/uHKZFUXrrhcISQVSStHk+4Q
         0i4Q==
X-Gm-Message-State: AOJu0YwxR2dkvSS2mk9esk82d5Krlk4wd1tKpMESfEuPJDEOYNGMn8rj
	ngOCn2wT2/9HRfeIgch0bU0SXkHEVz4oM17MWT4SFtw7KRzROCPCErKF8WzxWZJzIgrVeHWGbQZ
	lATTuCzbCaHQ075ar5U9N1GwPtQUE0FY=
X-Gm-Gg: AR+sD13o4H3xTNoYWVOgRc3APUw3NtYk3rQNVQyjT0465lzxGEndefGK3PGs/eFLuCX
	d5ybvDlGr9XUA4HEqmsqg3Zs7/1lDpyL2gV1k27Wpq/1/PhIHD0MgOC7m0psG42bkvop7Z2Wrfe
	76t0yWOZZRgRlGi0SXdz3FydTxzvOW3aB2WZFvCSJ2WGMnHgBUv1WyklMgaG2P6yHU6pdrFz3bM
	32mY712eUtEjcfIDANbEwzhPy+pl3lGerCLZzCZWvvDQIEhDYqF+bZEOCg898r5bn6HB0/oylL8
	+fE1sGD7gU67N+tloHjV1XRR7LpNPZNeDTcxJ804iv0JjnjaU4lRjnjW6fQGVvjYALRBVd5xlwH
	Cjg==
X-Received: by 2002:a05:6402:3250:b0:6a1:df2c:cfa3 with SMTP id
 4fb4d7f45d1cf-6a38a8d884cmr12171377a12.4.1787038894697; Tue, 18 Aug 2026
 00:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com> <aoQFw_SWJBAdO8w-@MiWiFi-R3L-srv>
In-Reply-To: <aoQFw_SWJBAdO8w-@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 18 Aug 2026 15:40:57 +0800
X-Gm-Features: AcwNN1VRYTzbtiXYoU92qfjSmVzpQzxLtJTMmiPxSS8NOzR75LT-X-q805MIN_s
Message-ID: <CAMgjq7C1nFb92FGE+uSapZZS+14R95OG9w8ji+ZBkF=fOQ2Eag@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
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
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zbn8xq8oxtuxprujgddw5ok3f65xp1gp
X-Rspamd-Queue-Id: 7DB68140005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787038896-53668
X-HE-Meta: U2FsdGVkX1+Ryj7EO0z1hpD62aKgB33YaBpLoeZeP1Xc1hiqQVooH9wy3R7q6CdyKDoTuETIo8C1QSC57KrAsZnQtLp1tUY3BrTwZJ+Y+r8bBmRPQdr7tE9sxbcMVTnHSQdYiafJnxzz54ugpUBuXKR2QdDucW7WLMo+RXkH5acj5vyNzaoO7kdZB75IJBF34pCVemRavgYIvMKDMXzqmVFogc0Ajpg9io7p+Exh2yeSdsIva1d9huVmkEzPZVnir0G5f8HDb8NXf7ts8lAUmfNvw0RX66IO/mjY/zneiffl2FOkSDXkNhdR11icKklRs+fdJoeT4YaWjM0J+x6S6CnopT7sWgO13G7MYKZ2KB1mCFRl+7IZ7/oSVlOYimRg63TxHQzuf/j5ltKHlWrLsENY1LXrr32DiCl3kEWC6WLVeTMXlHdgbjTovI0ow/9EnYM7zVlKm20ue50DSRYW4KPTnia1lMvt992EblJ1X5KGwbPam5YZg5NkMVmkMiHe3Grw4FMd/0jc9BObOiKeVjEzChiR83cGFJcJroPOtD4mPpRjXk66UKOlwVz8xzS4+h0gzJFNy8IxPwqWmNcJ3rGxHIzNPrfaQWMk2Wi8kQ93pfOSrGRaolkAkyDsFY8HIfJTyDbK5RXWQBTk+cpPbqCqupOEVliPon4ifbtMM9D97PYpBraPRDTScz6HnU93KGPMOKjqDPifIHIMCaJUqfHm5EO1FuD8vkjFl5d9TJ0oWUOfzV5kv2X9TQ+qWnbcHmOIXNNtctYnLAb6a+3kI0aIX669ZWgw+G4ps5Ki+zJp4OV4ahE8ddcuBXJU0pWlyTAAG8dvegJ7uGNSaVBAqlrtUf/t8yLAwGG3FDC7RbKoS2fh7O2pR/lY5caWiF2/SXW+4PIZG7u0dG08XwFcJUN1CxgO2UnIyZ4Fz7guZ7TqgZ8T98xxyYv/7cXhCX8pexdNqc5cCqU0rOBBOl2
 UrItRJnU
 6DYeGomCPW8FDQSxhs3+HGx5f4EiarKkYJ5DL9kasK6cSKJ29jjeFmfCbEHk6WI9svLC8TC+peNRLsSaLkHCcTEmvhtuJQ8m0Z3PB9mI6n+ldZD2w3gtNJe3rxXl70nMHcyUpEJRnYFXdzU/cwnfg+h+dtXv1vF63GNJurT+7CCKoGW4U6W76hHf4uIOmXQNJBMdxGzdCnps3XjiLZjJzPNRN/fGAk21p3ZwL4y1f8p/NvmiZfjDyu5ShIVEHS7S9LSBACOWcyq5sVGMT85olGTlFmDpGojEcc6ynPa5EjZFa5mrXMr/Skcs2XJxzcwaJ+0C4m1oA/5S/MGUDwaTkFyKmX4RDwsvCl7yF0/wHKJOOfYshg6x/KbEeiApSdDfskrm8DuBhI9OXOXjimUSiOqxp4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 3:12=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> ...snip...
> > +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exe=
c)
> > +{
> > +     int max_gen, min_gen;
> > +     int type, refs, gen, new_gen;
> > +     unsigned long new_flags, old_flags, max_seq;
> > +     struct lru_gen_folio *lrugen;
> > +     struct lruvec *lruvec;
> > +
> > +     type =3D folio_is_file_lru(folio);
> > +     lruvec =3D folio_lruvec_live_get(folio);
> > +     lrugen =3D &lruvec->lrugen;
> > +
> > +     old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > +     do {
> > +             new_flags =3D old_flags;
> > +             gen =3D lru_gen_from_flags(old_flags);
> > +             refs =3D lru_refs_from_flags(old_flags) + 1;
> > +             new_gen =3D gen;
> > +             if (!(old_flags & BIT(PG_lru)) || gen < 0)
> > +                     goto out;
> > +
> > +             max_seq =3D READ_ONCE(lrugen->max_seq);
> > +             max_gen =3D lru_gen_from_seq(max_seq);
> > +             min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_seq[ty=
pe]));
> > +             if (gen =3D=3D max_gen)
> > +                     goto out;
> > +
>
> I am a little confused about the new mechanism. In the current mglru, it
> does have the issue both mm walk and fd read set PG_referenced at the
> 1st access, this is a obvious drawback. Now with the change, the ref
> count is clearer, while the mm walk and fd read accessing is still mixed.
> Imagine the cases below:
>  - one fd read; then mm walk; directly move to max_gen;
>  - one mm walk; then several times fd read; promote to next gen;
>
> Can I understand the final effect as:
> 1) explicti ref count;
> 2) more drastically promote mm walk based on the mixing ref counting;
>    - compared with the old behaviour: move to next gen when 2nd mm walk

Hi Baoquan, Thanks a lot for the review!

The old behavior is move to max_gen on walk access (unless it's the
first access of a folio), and only protect non-mapped folios with PID
refaults. Now, the non-mapped folios are also promoted after multiple
accesses.

The promotion is more proactive but not that drastic; it still
requires 8 accesses (2^3, which overflows tier 4) to force promote one
folio.

For anonymous pages, this also provides a more consistent and explicit
reference count mechanism, and you will see folios distributed fairly
among tiers now, as repeated page table access will increase the refs
above LRU_REFS_PROTECTED. Previously, all anon folios were stuck at
tiers 0, 1, and mostly 3, skipping tier 2 completely.

Also we reduced the bit usage by 1.

This new mechanism is supposed to work as a whole, This new mechanism
is supposed to work as a whole; it is documented and described in the
chunk of comments in mmzone.h (maybe not the best place but old
MGLRU's comments are there so I just updated it inplace). I tried to
split it into smaller parts, which doesn't seem doable.

And I think the three folio_inc_lru_refs* helper are also kind of self
explaining on this.

> I can only see one benefit and one significant change. Do I understand
> it correctly, and is it worth?

I think it's definitely worth it, if you look at the results in the
cover letter :), especially the zipf access test (1.2, 1.1, 0.9, 0.8
have similar results, zipf is commonly used standard to simulate
realworld access patterns) and a few other cases; 90% of the
performance gain comes from this design. I tweaked the refs &
promotion rule many times to double check and ensure it fits well for
different workloads.

And note that this is not an anon/file reclaim balance tradeoff issue,
both anon refaults, file refaults, and pgpgins are reduced, meaning
MGLRU is doing better at protecting both hotter anon and hotter files.

It's widely complaines that MGLRU was actually performing poor on
unmapped folio protection, worse than classical LRU in many workloads
(Not the LRU overhead, MGLRU had lower overhead, but the actual
ability to protect the hotter cache is not good, provable with the
zipf test in the cover letter). After this change, its performance is
obviously better than that of classical LRU.

Attachment: a typical tier layout of a workload before this change:
 node     0
         35       3910      37524           0x
                     0        238r      15596e          0p          0x
         0x          0x
                     1        409r       6429e       6211p          0x
         0x          0x
                     2          0r          0e          0p          0x
         0x          0x
                     3        895r      39182e       8588p          0x
         0x          0x
                                0x          0x          0x          0x
         36       3244      84684           0
                     0          0x          0x          0x       2882r
      6059e          0p
                     1          0x          0x          0x        448r
       964e          0p
                     2          0x          0x          0x        298r
       439e          0p
                     3          0x          0x          0x        416r
       721e          0p
                                0x          0x          0x          0x
         37       2858     221580        4269
                     0          0x          0x          0x          0x
         0x          0x
                     1          0x          0x          0x          0x
         0x          0x
                     2          0x          0x          0x          0x
         0x          0x
                     3          0x          0x          0x          0x
         0x          0x
                                0x          0x          0x          0x
         38       2183      29167         242
                     0         12R       2499T          0x       2496R
      4101T          0x
                     1        322R      29241T          0x         92R
       156T          0x
                     2          0R          0T          0x        100R
       144T          0x
                     3        150R      75764T          0x        741R
      1161T          0x
                         20903930T    5439295Y      48822F      19595A

And after:
 node     0
         47       3227     197247           0x
                     0        967r      35231e          0p          0x
         0x          0x
                     1        412r       6871e       1051p          0x
         0x          0x
                     2         12r        639e       2319p          0x
         0x          0x
                     3          0r          0e         49p          0x
         0x          0x
                                0x          0x          0x          0x
         48       1623      49290           0
                     0          0x          0x          0x       2065r
      3586e          0p
                     1          0x          0x          0x        338r
       836e          0p
                     2          0x          0x          0x        352r
       817e          0p
                     3          0x          0x          0x        107r
       139e          0p
                                0x          0x          0x          0x
         49       1491      91927        4865
                     0          0x          0x          0x          0x
         0x          0x
                     1          0x          0x          0x          0x
         0x          0x
                     2          0x          0x          0x          0x
         0x          0x
                     3          0x          0x          0x          0x
         0x          0x
                                0x          0x          0x          0x
         50       1305      10444         674
                     0         69R       6630T          0x       1082R
      2586T          0x
                     1         21R       2509T          0x         55R
       168T          0x
                     2         71R       2322T          0x        111R
       288T          0x
                     3          0R          6T          0x        114R
       619T          0x
                         31126090T    7780753Y      72142F      27409A

For file heavy workloads, the file folios are also now fairly
distributed amon gens instead of being stuck at tail gen. And it's not
just looks prettier, the performance is indeed better.

