Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8A0CD98F6
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 03:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E227D6B008A; Sun, 21 Jun 2026 23:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD38C6B0092; Sun, 21 Jun 2026 23:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4046B0093; Sun, 21 Jun 2026 23:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97D696B008A
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 23:36:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03635404FF
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:36:17 +0000 (UTC)
X-FDA: 84906135636.14.B5A763E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1021A20004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:36:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9Y5YTrg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782099376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07nQkqpBtDTLYno84Uq6wbRgR3YwoaOxYC/GqPDb5X8=;
	b=3k6XKb3XSXIecAI1gJ8srTB8Fo5DDVCPO1NuwfvWpbxkNph9fbW52lTbq7f/PVNmo2JCPT
	nqKHhKQ5utCqzCTXuFhRKz4LysyQgL0N9txreRvmimyNd0/o3g48IdjO6hzW9M9T3JkyeU
	Y0dknAVzVlvSxVBRfR15vhikpdKNXRU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9Y5YTrg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782099376;
	b=qwyz/Z0Ij4FM412uJPo7Jxl+VtCnGe7TBfxkwrLyUL+twHo9S/SXM/9Jf9Am0U2v7/jYFQ
	KSPHoaCgnBtjalfKsa3ZlHWLFMFBKuqLLFa3wVtBJKVFZJbkArr1YwVSeRWWEqZ+UFvyIL
	r0l4Sm4gs04tp19xdEY2Ger3gw40XBw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA92A444AE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCE11F00ACF
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782099374;
	bh=07nQkqpBtDTLYno84Uq6wbRgR3YwoaOxYC/GqPDb5X8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G9Y5YTrgRYhnpS5NQO/2YIWIgnq7czbrsHBTxePpuwEYREyU0jwGo/kfkw4KmEU/W
	 1duaFIlQVpWoARDVAYljRj4GWQL1Fkb30fAimVItrbv3eZxQzX6JjSTxGPHErZTmIS
	 KBbZUSA8YjImY85+pBGhsXHlB+yfIZJqROaCUPTvdwOPD2HvYc8xA1Y9ShNHqjbzA1
	 AOkEla1RDpO+6aAxtASPH0wAK/uOVL1QKfdqZ8z6tlai+7S56K4aGWQLrNUhLmIHeU
	 OskzNF6tFF8K0CXZGeDFNXjkUsDP8g/v+1Dk27yN1bDf63GleB6BKJBClQSv7GmEhR
	 cw5AmzG2oRkzQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9158643e538so352054785a.1
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 20:36:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ85WJC3YOppSz331vJUHDEhKtaCDdUaUzCSioHKg34rH/+9ZshwHYIXpBk92OUxadNk1rkZijL4eQ==@kvack.org
X-Gm-Message-State: AOJu0YwkOytev3z6WkUuqRN76LwuzsF1GvM5+QoIsNjn31Y/VXb/E95q
	oqq6WUUWgG7CUTCKrp2AA3c+Fpm1+Woc/vFASXXKKiYy/tjwLHSyaUGUYNw0DEr0Ehq3XESBTsS
	oAXzx1sSR78Fabyo66GxL0/Fztd5AVvw=
X-Received: by 2002:a05:620a:298d:b0:915:92bf:560f with SMTP id
 af79cd13be357-920d3379d9cmr1846790885a.36.1782099374017; Sun, 21 Jun 2026
 20:36:14 -0700 (PDT)
MIME-Version: 1.0
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org> <6e89f868-ca7a-484f-aeea-5d8d029714f2@linux.alibaba.com>
In-Reply-To: <6e89f868-ca7a-484f-aeea-5d8d029714f2@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 22 Jun 2026 11:36:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w=nyJGn1uuwbMjG1JXG8TmiENBtzE0bXQN1Nd34ONdBQ@mail.gmail.com>
X-Gm-Features: AVVi8CcIXqnC9P3rfAwFsBPHoY8IFpSmCdjLlRyd7eYchlLPB78bAQAhdNj-cQ8
Message-ID: <CAGsJ_4w=nyJGn1uuwbMjG1JXG8TmiENBtzE0bXQN1Nd34ONdBQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: david@kernel.org, akpm@linux-foundation.org, axelrasmussen@google.com, 
	dev.jain@arm.com, kasong@tencent.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, npache@redhat.com, qi.zheng@linux.dev, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	zhaonanzhe@xiaomi.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1021A20004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: qwtofrmk1mefzrihpofdgej9qtf4mzor
X-HE-Tag: 1782099375-970750
X-HE-Meta: U2FsdGVkX19t8bMBY2ReygMTeSbCAzWvPFsSSjM5HSMuZGbbxAb5G3tmVYFDASzTwOu6/Wuquu2y0TyLJGWS3CHQ6SFL8iOZHnfg+gWrGpl+CZ6iE1QNI6PRmX37hY71G/C1cjp5a2HT1jL2WDibWO9a67KI0Pzwj5u7vGKcsqW5EV7kL7DZ5KrOuAMcB1nJDar7qWU7//zguMjSwMkYfnO2aVI3dtE7l/bDPQfRODZIbOYSVtX6j0rYLNvu8EGGorUCTg6igZTLpKqUIrTcvXEGvyXZ5Sgngc7Ifbg+nAAThWpbwgoD7N0bWYV5B9KQAdglLHdULe8M5K2kSx/rMiwjVxmbfb5oqhipY1OKMbWF4IYxfNB2ajz5BsSj2/XXnsO28KtuJedbYvy7MJHqoU9iFISBhbbUPYdfUzD3hCn10nEEvd+Fj9QsUgz9M224cz5xIa20tnQlSNt5DtbmyKKKMMQjZUrNwowIgg23wF428C2IXIHl1cMSsLo4ZI+GdyfBgu5Pc4Uj/yxMpoMgKXyD1nFTddGEk4auDtequNTEjdXOcsqAFL1Au6hz9LFB71COaPXEcjCCt+nKuie2dEPvjP/oXiwd1Y93RLlge8ylHopbEbPvHRPG3yBJewEtf1zztYIDiQx1r0O35ouP8ud1pkesXAdcJ3qtdlkaGcA6nMHAcvd51wH4HJikmXWDKR3m9HKdxsWNpFBLlj/JT9S+Hk0zS6wU28yblEF4Hg2ayFZa8B44k8sJGGHjc/8f+E1Meeo3u00LD8VSb6F2Ih36iNW4DrpnEpuGMftoU7qnrgg2WAoNGpF2J/njIrliqpP0bQyfHxzIrNMVyxm6zoq+zo+qX23UgBQ1L1jT0kWM3aWjPfTy0zFz5AXaZjJQdRUlYGwuUGNNjaM9irzo9pma3QIVsUVXpWtLJRffSje+0IYzTCL1qApeTpLHyas8qWa3aUlzVbZ99BY4FHq
 fcF3H5Ee
 4nc3O0IFcS4fNp8CfRTENrJNAZ996IBUtWZwNAkIs9SDgtsdqkBgK/fvIDZgzC3u6L76/tBDnU0kwG4SSoSQkAkcATLzuOrhmVNIwf3GBjbtbWeZKGiKv70CTANVrK5BzMSPnzQ7/WAg4Z8ygNjjpTd3frCRLWr30gT/WL/Rj5W1OF/yFGLrmPcn7GGlTd0KYeba5uxH0s8ClbYiT5RQhdq4bVIlHM6mYkBYmpjFaLsLFv5oZRgO6SlMNWu977lObM57XiOigIAvzqqP3KsjuRfoft/cWpo2dV5qUHwcuNJgvtqNkume/dffP3YY7K8kHVY0g+pigbWvZuaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 11:04=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 6/20/26 4:10 PM, Barry Song (Xiaomi) wrote:
> > On Fri, Jun 19, 2026 at 10:04=E2=80=AFPM David Hildenbrand (Arm) <david=
@kernel.org> wrote:
> > [...]
> >>>        /*
> >>>         * The page can not be swapped.
> >>>         *
> >>> @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct li=
st_head *folio_list,
> >>>
> >>>                                if (!folio_test_large(folio))
> >>>                                        goto activate_locked_split;
> >>> +                             if (!__can_reclaim_anon_pages(memcg, sc=
))
> >>> +                                     goto activate_locked_split;
> >>
> >> Why are we even trying to allocate swap space if we cannot reclaim suc=
h pages?
> >> Makes we wonder whether we would want to have that check earlier, befo=
re the
> >> folio_alloc_swap().
> >>
> >> Any downsides?
> >
> > I don't think there are any obvious downsides there. One issue is that
> > the memcg may not be passed from reclaim_pages(), so memcg would
> > always be NULL. However, the folio could still belong to a memcg
> > whose swap quota has been exhausted. In that case, my
> > __can_reclaim_anon_pages() will fail when checking whether we can
> > swap out. But switching to folio_memcg() also seems awkward.
> >
> > So I feel Kairui=E2=80=99s suggestion [1] might be the best approach. I=
n
> > folio_alloc_swap(), we return -EAGAIN to tell vmscan.c that
> > we can split the folio and retry the swap-out.
> > only when there are sufficient swap slots and sufficient memcg swap
> > quota do we return -EAGAIN, allowing vmscan to perform a split.
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 78b49b0658ad..62e2c506ccae 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1755,6 +1755,9 @@ int folio_alloc_swap(struct folio *folio)
> >                       VM_WARN_ON_ONCE(1);
> >                       return -EINVAL;
> >               }
> > +
> > +             if (get_nr_swap_pages() < (1 << order))
> > +                     return -ENOMEM;
>
> Shouldn't this return -EAGAIN? Suppose we try to swap out an order-9
> large folio but get_nr_swap_pages() returns 256, then we'd still need to
> split the order-9 large folio to reclaim some memory.

I guess Kairui has the opposite view. Quoting Kairui:

"- 1. the mem_cgroup_try_charge_swap in it failed
- 2. allocation failed but nr_swap_pages > folio size
- 3. allocation failed because all devices are full or unusable
(roughly nr_swap_pages < folio size)

Only case 2 requires splitting. __can_reclaim_anon_pages also checks
demote which is not related to swap."

For example, if get_nr_swap_pages() returns 1, we can only
swap out a single page after splitting. Is that really worth
it? On the other hand, if it returns 256, we could at least
swap out half of an order-9 large folio. Isn't that worthwhile?

>
> >       }
> >
> >   again:
> > @@ -1769,11 +1772,13 @@ int folio_alloc_swap(struct folio *folio)
> >       }
> >
> >       /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
> > -     if (unlikely(mem_cgroup_try_charge_swap(folio)))
> > +     if (unlikely(mem_cgroup_try_charge_swap(folio))) {
> >               swap_cache_del_folio(folio);
> > +             return -ENOMEM;
> > +     }
> >
> >       if (unlikely(!folio_test_swapcache(folio)))
> > -             return -ENOMEM;
> > +             return -EAGAIN;
> >
> >       return 0;
> >   }
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 299b5d9e8836..63e8578454ea 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1257,6 +1257,8 @@ static unsigned int shrink_folio_list(struct list=
_head *folio_list,
> >                */
> >               if (folio_test_anon(folio) && folio_test_swapbacked(folio=
) &&
> >                               !folio_test_swapcache(folio)) {
> > +                     int ret;
> > +
> >                       if (!(sc->gfp_mask & __GFP_IO))
> >                               goto keep_locked;
> >                       if (folio_maybe_dma_pinned(folio))
> > @@ -1275,10 +1277,10 @@ static unsigned int shrink_folio_list(struct li=
st_head *folio_list,
> >                                   split_folio_to_list(folio, folio_list=
))
> >                                       goto activate_locked;
> >                       }
> > -                     if (folio_alloc_swap(folio)) {
> > +                     if ((ret =3D folio_alloc_swap(folio))) {
>
> Also, please give shmem some love (shmem also calls folio_alloc_swap()
> when swapping out) :)

Sure. I'm pretty sure I love shmem. :-)

Best Regards
Barry

