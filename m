Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86ED8F9B61A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 10:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5C06B00A9; Wed, 22 Apr 2026 06:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56606B00AA; Wed, 22 Apr 2026 06:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945AE6B00AB; Wed, 22 Apr 2026 06:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 815326B00A9
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:56:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15CF8C9B90
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:56:42 +0000 (UTC)
X-FDA: 84685888644.02.4C50C3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id EC61A40007
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:56:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+DnPxEV;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776855400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqtHA6LFA6rw2FvnKh0K56VSoGaGiLgECwYXAMyp/88=;
	b=HGxalieAi2Rsi6WrcjOAulxE9+EwoI5hhqUY1tDaKejEJEum0v2W9HukF2qpJb5FCv3itY
	D4ADaGKR4dDr8Vv7X7ANMG1tG754UtGGx6AUNWm4YnJ7/AD9c4NHQ0B5wvGgoVuEQWX8jZ
	H8k8tRUx4qvU/aI/0oJSujwy1iIJoxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776855400; a=rsa-sha256;
	cv=none;
	b=W4S+ncyCrtIeB3MfK8iDP4+TbCHiM/NSF4xGpwtO8Hn57PyKogYrho077kfa9/Ph6+qv3N
	AI2kT5id2Hz3akKOh8Endz+nAMzdeE5h4YsDbfEb2KXEmV6X8IdECkJ7hYlimEPMVY77Co
	vzt2ZhYDXSE6Hvq6aprKEjHWs/Oqw3w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+DnPxEV;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAFFC4445E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABF7C2BCB7
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776855398;
	bh=MHp/nhmLiBdSxcK8jMNigGfvq7GIk0s2K0C+h8fEN58=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=U+DnPxEVvk8M16OWTUMhqWvMY7tpoLSCG1Mg3h/u/LdexYBrnDvJbdGSHbn4nxubx
	 XhAsw0tDs5u9lIHmp4JncKA/wULxZkRy2XWIEThyYdpGEN8po+nYXjxpqMG5bZoTzr
	 NSnfbx+6M0pBM1YI9jP/eUdHTGKWWMJA3qASXBKc3X/eW6IzB9q1XHs5ywzjihHNBA
	 UPjknkKTcVNxHP5aBWlqcc9DnFnYHrHLXGXeuyFfaGFcSp/XtWmR/k0Rjdq3EsZrwq
	 eNB8C2UN9TNDVN/IYEr9HK2mdxzGh6awuXYJL4fwsHRuxbHq1j04pYL+U4AMwRu45Q
	 hRSExRdPWPHaQ==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8acb3dab8dfso34353266d6.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:56:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8bktkE+hOqskZp928oVbBsmxY0jHYy7c9UknrHtYvRo0gAz3xF3u8R0FszmZTqd4UGUbU/pn2nUg==@kvack.org
X-Gm-Message-State: AOJu0Yx6XFadERoHVm3YrhkyFe920C84OPSffMWM/OcDnVk1t83usZim
	3TA4vDoVqsu8qrFPAByyXU5w92fNKE48q8Hi1ihaDDSDLAUgwbLAM/YaPOXAiGE5gCK1lUE8y5w
	ylzkIR9+5sRXJHVmhtMopFqsajKojfxY=
X-Received: by 2002:a05:6214:29e9:b0:89f:4a69:4498 with SMTP id
 6a1803df08f44-8b0280ed969mr349913266d6.25.1776855398074; Wed, 22 Apr 2026
 03:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260422021842.78495-1-baohua@kernel.org> <8d4df864-2954-4eb6-b8d7-ae6595646e6e@linux.alibaba.com>
In-Reply-To: <8d4df864-2954-4eb6-b8d7-ae6595646e6e@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 22 Apr 2026 18:56:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wyDqnoBXcBQL932pkg8QY79EWrbmKaVqNvm_s5RQrNFw@mail.gmail.com>
X-Gm-Features: AQROBzCSjb-uUrLTQdGdiRZHmqUfD3PXMmH0gLJzw2I_xhVDiQJcfKvwFje-5I4
Message-ID: <CAGsJ_4wyDqnoBXcBQL932pkg8QY79EWrbmKaVqNvm_s5RQrNFw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm: Improve pgdat_balanced() to avoid
 over-reclamation for higher-order allocation
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Wang Lian <wanglian@kylinos.cn>, 
	Kunwu Chan <chentao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: djkne83fc7r64atfds4wwq8fhurz16bi
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EC61A40007
X-Rspam-User: 
X-HE-Tag: 1776855399-78767
X-HE-Meta: U2FsdGVkX19tHPIPV6wDYnZkkEBhUlu2DZeTyywMLky5Vk8Z6hQDvRksu1NVfFLkGsEL8BQqKX0uPk25GoqnP7jvFbYr5t5EhP1QEHJ08ODfU/bTScE+Y+64tAU9zD7ORj3UOs+g1hBBZNycawtQFttJoYA/wlewdCeUaTRwRHQawtzR4GacF2IdlEogazieKZoKcXBpIMBohGSrguWyhKlCu4Z45CK/WK49+8XmUNQQU7188JGDCNRm+4pW1ntb5eyufaZnD0oC/ZTTfKQDgKUhZeek4x/hJsOfzlAIRUOsiyunboaLKz6vJVNwZ6xWMPFmoXSvFZzC5SF4juAmjgkaKh+/cRAtCuvad7eoQWxmR2pbsdUi305kd04+futjnvnUtqJJ6opR4QlyNIt4o6kEGT6w2H8S3rAXUaqefUBgN83Ah1ytSXuN35Zgrtyexrt4J9u50UcKfrwdX1lmncJJM9QPlHdlNe3DyH8iKuM7wXVysAqk16E94eOfCpeBhLxG+MvhMTjphCbkJS+NEUhER2zfLpKQo3pI8X4qFtHyOAlwS/tCjpc5/ib9E6im/7q+Q7SBTMfGOe1WDpR9yVh31lK4RVc0u1VBOJgaxgcyRhoAuKoO85CIcKWqHLSnrmjhMIkO92AxfzdpFovtcWoxDtlu/t9cUG2FhrGdjdJm3R6+YHjAyPJmF0cmPKIYpWlImAaIm4Zn/D2Q/rtyC5nZdp8xaL4YPKl+aWEe7uBrxodooBn+rXuPEcVMtcYg+eYin1VdlstO3a/ff3WsC3F0lGVrhqbZ0bDhlU46otGf7eChAgBl7EeM9oqLHk4aqbjbKvsjaAYXcsCZ3EQfbebzIwNWOX13mDxoIPIcxAYVAHxgIa0uA93amrwglNNAEula9uKaxm/FMoA7/9AtnEp7reZYfaIAl2lZfcKxfpDyX76RPjsVpqGtnnDsJsUTMaUBxnxmCSqacuuJpnU
 viaH3SFa
 q8zrBb9bBAWkemQbtBojyJoiGZGtXAMdmIpvcpMUVxLpkj3C9DLI/LBxqJGRxNdJngzu9rUJoLIMiqHs4ATv5BTR9gspTd1XWlYLhY0d6RTPL65AVZoA7YsS1D2/ElnQedW1Xg+riGCdcVo7wl2s/1zqaIAVZYPHzkyl+/xNZrkkZJH8KrKIL8llyv1jFqHxisf35riRdE9R2CAYcieuxwaR1x2ooVeoqQO6zxq+55wtAHTSVGguG4XbJzm+UB+XRmIBZXaXqsX7kUPzK7IRK76PWN7yjsCqwssTNWJAS31ha5JOaywUvYPzCt+sjytewK3EX+ExrLD8n5zDP+qQNhsVUX0mYG5sSSCpnnG1DApaSNNEtPT4k6fnXktnRdz7KXkJjZc4o7DzSOdYNgTcr6nIF5oKVb70iNmOqhnSWYcpf2c8onXNqJ7xOtLH7bNw82TL0HfPgv/F1EiVRZb8QZ7YoOjU/iuPLbxgNjA2WpEYBCEmzwqG1e9HJ7X1Y++GwJ2bu7rpda+h7ApSMmBWWLHc1oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 2:59=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 4/22/26 10:18 AM, Barry Song (Xiaomi) wrote:
> > We may encounter cases where the system still has plenty of free
> > memory, but cannot satisfy higher-order allocations. On phones, we
> > have observed that bursty network transfers can cause devices to
> > heat up. Baolin and Kairui have seen similar behavior on servers.
> >
> > Currently, kswapd behaves as follows: when a higher-order allocation
> > is issued with __GFP_KSWAPD_RECLAIM, pgdat_balanced() returns false
> > because __zone_watermark_ok() fails if no suitable higher-order
> > pages exist, even when free memory is well above the high watermark.
> > As a result, kswapd_shrink_node() sets an excessively large
> > sc->nr_to_reclaim and attempts aggressive reclamation:
> >
> >   for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
> >       sc->nr_to_reclaim +=3D max(high_wmark_pages(zone), SWAP_CLUSTER_M=
AX);
> >   }
> >
> > We have an opportunity to re-evaluate the balance by resetting
> > sc->order to 0 after shrink_node() with the following code
> > in kswapd_shrink_node():
> >   /*
> >    * Fragmentation may mean that the system cannot be rebalanced for
> >    * high-order allocations. If twice the allocation size has been
> >    * reclaimed then recheck watermarks only at order-0 to prevent
> >    * excessive reclaim.
> >    */
> >   if (sc->order && sc->nr_reclaimed >=3D compact_gap(sc->order))
> >       sc->order =3D 0;
> >
> > But we have actually scanned and over-reclaimed far more than
> > compact_gap(sc->order). If higher-order allocations continue, we may
> > see persistently high kswapd CPU utilization coexisting with plenty of
> > free memory in the system.
> >
> > We may want to evaluate the situation earlier at the beginning.
> > If there is plenty of free memory, we could avoid triggering
> > reclamation with an excessively large sc->nr_to_reclaim value
> > and instead prefer compaction.
> >
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Kairui Song <kasong@tencent.com>
> > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > Cc: Yuanchu Xie <yuanchu@google.com>
> > Cc: Wei Xu <weixugc@google.com>
> > Co-developed-by: Wang Lian <wanglian@kylinos.cn>
> > Co-developed-by: Kunwu Chan <chentao@kylinos.cn>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
>
> Thanks Barry for sending out the RFC patch for discussion.
>
> Yes, we have indeed seen reports from our customers' scenarios where
> fragmentation caused kswapd to be woken up and reclaim too many file
> folios (even when free memory was sufficient), leading to severe I/O
> contention that impacted some applications.
>
> However, I'm concerned that this patch might also have side effects,
> such as affecting system defragmentation. In some scenarios, directly
> reclaiming clean pagecache to free up space might be a faster way to

balance_pgdat() can still reclaim clean page cache even when
pgdat_balanced() returns true, provided that nr_boost_reclaim is
non-zero.

                /*
                 * If boosting is not active then only reclaim if there are=
 no
                 * eligible zones. Note that sc.reclaim_idx is not used as
                 * buffer_heads_over_limit may have adjusted it.
                 */
                if (!nr_boost_reclaim && balanced)
                        goto out;

                /* Limit the priority of boosting to avoid reclaim writebac=
k */
                if (nr_boost_reclaim && sc.priority =3D=3D DEF_PRIORITY - 2=
)
                        raise_priority =3D false;

                /*
                 * Do not writeback or swap pages for boosted reclaim. The
                 * intent is to relieve pressure not issue sub-optimal IO
                 * from reclaim context. If no pages are reclaimed, the
                 * reclaim will be aborted.
                 */
                sc.may_writepage =3D !nr_boost_reclaim;
                sc.may_swap =3D !nr_boost_reclaim;

I find that nr_boost_reclaim is almost always non-zero in bursty
network scenarios. So I guess clean page cache is still reclaimed,
but with much lower kswapd pressure.

> defragment. At the very least, I think under defrag_mode, we should be
> more aggressive about defragmentation (including reclaiming some memory
> by kswapd).

I guess we can keep the current behavior if defrag_mode prefers
over-reclaiming to form contiguous pages. Is it simply an
if (defrag_mode) check?

>
> >   -RFC v1 was "mm: net: disable kswapd for high-order network
> >    buffer allocation":
> >   https://lore.kernel.org/linux-mm/20251013101636.69220-1-21cnbao@gmail=
.com/
> >
> >   mm/vmscan.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index bd1b1aa12581..4f9668aa8eef 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -6964,6 +6964,13 @@ static bool pgdat_balanced(pg_data_t *pgdat, int=
 order, int highest_zoneidx)
> >               if (__zone_watermark_ok(zone, order, mark, highest_zoneid=
x,
> >                                       0, free_pages))
> >                       return true;
> > +             /*
> > +              * Free pages may be well above the watermark, but if
> > +              * higher-order pages are unavailable, kswapd may still
> > +              * trigger excessive reclamation.
> > +              */
> > +             if (order && compaction_suitable(zone, order, mark, highe=
st_zoneidx))
> > +                     return true;
> >       }
> >
> >       /*
>

Thanks
Barry

