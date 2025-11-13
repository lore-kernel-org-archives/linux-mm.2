Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F8ECCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 04:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5888E0008; Wed, 12 Nov 2025 23:07:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785688E0003; Wed, 12 Nov 2025 23:07:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674C58E0008; Wed, 12 Nov 2025 23:07:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53AAF8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:07:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19E7A5AC77
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:07:16 +0000 (UTC)
X-FDA: 84104248872.20.272BF96
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf18.hostedemail.com (Postfix) with ESMTP id AE89D1C0004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:07:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763006834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yGd+5H8+uHqBgX72iYToj7SNBjhscrlDUQpapwjA5w8=;
	b=uReJWBYIWX3QiV373c75F2gfAGK8TsFYJcefbPB20cVNDaeFmUsf9yv+63crALaSz14XNh
	ltxgrvnmJgnSgi6zDdlwOqkiq9sYGNz0j4z7XukoKDN1zpp7FxdDkf0W2L9+0MNResLemm
	L4IJ+vhTo08cep8UaG8TUan1voQy6F0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763006834; a=rsa-sha256;
	cv=none;
	b=coURHdoenKQHyzP4NU3mcVqL7d/8EyIs0ahcbzLBC3pKpCQ8s52QmFNMwCBFqDATU2Qh1Z
	LmzPlF6dr9jtZiZiMDy3bW9JNu5MqeM52+XsBZTa7a1gt2fcK6m2CV4uD+YOSwbOXEbEbw
	KCM2hjnkrfwRAN/eeo7Cg7j2vSF5kKw=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Nov 2025 13:07:08 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 13 Nov 2025 13:07:08 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com
Subject: Re: [PATCH 3/3] mm/swap: integrate swap tier infrastructure into
 swap subsystem
Message-ID: <aRVZbMNgvDbZDnDK@yjaykim-PowerEdge-T330>
References: <20251109124947.1101520-1-youngjun.park@lge.com>
 <20251109124947.1101520-4-youngjun.park@lge.com>
 <CACePvbU+NviPmpXQAJUrY4rTqmY_rvYy2JvDBAfT290GmQmfZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbU+NviPmpXQAJUrY4rTqmY_rvYy2JvDBAfT290GmQmfZg@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AE89D1C0004
X-Stat-Signature: 5atrg9b86jtum99xiqi68fsqwsumqq5j
X-Rspam-User: 
X-HE-Tag: 1763006832-187976
X-HE-Meta: U2FsdGVkX1+rArresIFdOniZuxiTIYXdzAxqznx3fC0he+mGqZMrGQmjlGMg/2Sxwx6NA/dtERIH1v8H9oimdMr6ZMHyVSW30dgAAM189H+fV0JufrrnaRUWo+iW4ZfLwPmHZMpYoQ5VBDMSjKeSiyrGw/gDStH2C05qvPlxWBm706/srqseg9mAYYprF07yC/uyKfL7H3JB394fk8rB6/Rin2SuS93LOB6oJjUfsGqEpk+y/zdNXR5Zbz7YwXFDcQSQdh4Ozyqd/E+liMi9DaAr44MmFlsm1isbs+0H+U2GpyXOyw4bZMoRNpnnQls4/DFzRWONLMHoaACFV1V5fYbsU/WcubVselg2/fzP2qBVRO95T6bW0imW02ea8LDDv/Xs5CtqgqH34Xwfoe6h6pZZPRAdReJmvUeNl+ekYIBmcwsGcTUyCJNiODHYxdyF3nkhaG+iWY5bN4QSe7PPFZ34lsQCRZL4GOQr+4z8gSLLpLSR/G7mCb/nN2pYHcUk+/in5P74Bs3c0bDoVx1Gd0kjTrQBhB3BqpPVBGUfaXqnfmLIxcA2IU+2ErJMpv1eXDi3ApJE9bng2C+mifher/QrwOkitb9Ou3RfzqtR9lIdLtuMFjQ6zsu0/53QVTuKX8vEmEnFwBc0AE3clqSTJZCDsqO8SZZBbz9BNJgClINA9ewvY9TrvcyMI5XYiwuEgObJrK0Lj68Ywsg5maKHMQDjrb3FNeIRCiU9FeXMD3UzD3Qdj/6/+1EAsR5m10KprArZsnTlpsADjAfra912NCBYowf8U1ltTEF5Y0BzFlvy7MCEvekWdzhbF7dGH8vDY7/tezOwRFdSnI0EOS+U2LFVkwMazGTBh/hoZIeO2Bf1ykw0XSVOwNgY8VDsKIa7hJ/xnPN2ia2dUX1a/Um88JtGPLW6rqyRcOlGDiknVrSEOIp3YcprWk96CCn8GTt+taFZRZt3Ksxnm2t5hhp
 k4sL6MY8
 hTBqCMotRf04pdg8/Kz4Cgn3adchfy2gHnIkO5NZFRIac49j6t2rcb06DBbLBbKPy+bthS4oRTnZMvovYxHdb57sb4aHqjN5DU8vUhU+6EQhw9uFUWU6Cw44MMonYSti5bwqdkqxOgteKBntEFkc1usqkDejron8al1asl+wtkw794O2OP1+0x87tYwHbuBKApS6rxzbEJk34/WWmae1tHHeJghCdAVVdWB/fzhBBlK7OJ2LtO3ghv7QAptmv9eSSwftj3rrqxOd5q68=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 06:44:23AM -0800, Chris Li wrote:
> It seems you should introduce the tiers first. Allow users to define tiers.
> Then the follow up patches use tiers defined here.
> 
> The patch order seems reversed to me.
> 
> See some feedback below, to be continued.
> 
> Chris

Ack. As I already mentioned, I will change it properly :D

> On Sun, Nov 9, 2025 at 4:50 AM Youngjun Park &lt;youngjun.park@lge.com&gt; wrote:
> >
> > Integrate the swap tier infrastructure into the existing swap subsystem
> > to enable selective swap device usage based on tier configuration.
> >
> > Signed-off-by: Youngjun Park &lt;youngjun.park@lge.com&gt;
> > ---
> >  mm/memcontrol.c | 69 ++++++++++++++++++++++++++++++++++++
> >  mm/page_io.c    | 21 ++++++++++-
> >  mm/swap_state.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  mm/swapfile.c   | 15 ++++++--
> >  4 files changed, 194 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index bfc986da3289..33c7cc069754 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -68,6 +68,7 @@
> >  #include <net/ip.h>
> >  #include "slab.h"
> >  #include "memcontrol-v1.h"
> > +#include "swap_tier.h"
> >
> >  #include <linux/uaccess.h>
> >
> > @@ -3730,6 +3731,7 @@ static void mem_cgroup_free(struct mem_cgroup *memcg)
> >  {
> >         lru_gen_exit_memcg(memcg);
> >         memcg_wb_domain_exit(memcg);
> > +       swap_tiers_put_mask(memcg);
> >         __mem_cgroup_free(memcg);
> >  }
> >
> > @@ -3842,6 +3844,11 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
> >                 page_counter_init(&memcg->kmem, &parent->kmem, false);
> >                 page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
> >  #endif
> > +#ifdef CONFIG_SWAP_TIER
> > +               memcg->tiers_mask = 0;
> > +               memcg->tiers_onoff = 0;
> > +#endif
> > +
> >         } else {
> >                 init_memcg_stats();
> >                 init_memcg_events();
> > @@ -3850,6 +3857,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
> >  #ifdef CONFIG_MEMCG_V1
> >                 page_counter_init(&memcg->kmem, NULL, false);
> >                 page_counter_init(&memcg->tcpmem, NULL, false);
> > +#endif
> > +#ifdef CONFIG_SWAP_TIER
> Again, don't need this config.

Ack.

> > +               memcg->tiers_mask = DEFAULT_FULL_MASK;
>
> Is this memcg->tiers_mask a cached value after evaluating the
> swap.tiers onoff list by looking up the parent?

It is updated when configured through the memcg interface.
The tiers_onoff field represents which tiers are turned on or off,
and tiers_mask is the mask that includes both on and off bits for
those tiers. This mask is used in swap_tier_collect_mask logic to
avoid recalculating it every time.

> I was thinking of starting with always evaluating the tiers_mask. Then
> we don't need to store it here. How do you indicate the tiers_mask is
> out of date?

swap_tier_collect_mask does not cache it. The effective mask is
calculated at swap I/O time. It only changes through the user
interface.

From your mention of “evaluation,” I understand you are referring to
a dynamically computed mask that depends on the parent’s settings.
However, in my implementation, tiers_mask is simply the mask of the
selected tiers. tiers_onoff indicates on/off state, and tiers_mask
represents the full mask (both on and off bits) needed for
swap_tier_collect_mask calculation. Therefore, tiers_mask can be
derived from tiers_onoff and could potentially be removed.

> > +               memcg->tiers_onoff = DEFAULT_ON_MASK;
> >  #endif
> >                 root_mem_cgroup = memcg;
> >                 return &memcg->css;
> > @@ -5390,6 +5401,56 @@ static int swap_events_show(struct seq_file *m, void *v)
> >         return 0;
> >  }
> >
> > +#ifdef CONFIG_SWAP_TIER
> > +static int swap_tier_show(struct seq_file *m, void *v)
> > +{
> > +       struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
> > +
> > +       swap_tiers_show_memcg(m, memcg);
> > +       return 0;
> > +}
> > +
> > +static ssize_t swap_tier_write(struct kernfs_open_file *of,
> > +                               char *buf, size_t nbytes, loff_t off)
> > +{
> > +       struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> > +       struct tiers_desc desc[MAX_SWAPTIER] = {};
> > +       char *pos = buf, *token;
> > +       int nr = 0;
> > +       int ret;
> > +
> > +       while ((token = strsep(&pos, " \t\n")) != NULL) {
>
> Not allowing plain space " "? Compare pointer != NULL is redundant.

You mean just allow " "?

I will change it to:
while ((token = strsep(" "))) {

> > +               if (!*token)
> > +                       continue;
> > +
> > +               if (nr >= MAX_SWAPTIER)
> > +                       return -E2BIG;
> > +
> > +               if (token[0] != '+' && token[0] != '-')
> > +                       return -EINVAL;
> > +
> > +               desc[nr].ops = (token[0] == '+') ? TIER_ON_MASK : TIER_OFF_MASK;
> > +
> > +               if (strlen(token) <= 1) {
> > +                       strscpy(desc[nr].name, DEFAULT_TIER_NAME);
> > +                       nr++;
> > +                       continue;
> > +               }
> > +
> > +               if (strscpy(desc[nr].name, token + 1, MAX_TIERNAME) < 0)
> > +                       return -EINVAL;
> > +
> > +               nr++;
> I don't think you need this nr, you will reach to the end of the
> string any way. What if the user specifies the same tier more than
> once? It is not optimal but the kernel should take it.
>
> OK, I see what is going on now, this whole desc thing can be greatly
> simplified. You shouldn't need to maintain the desc[nr], that desc
> array is the onoff mask in my mind. You just need to keep the tier
> bits in order.
>
> Notice in the memory.swap.tiers. Except for the default tier pattern,
> which always the first one if exists. The rest of the tier + - order
> does not matter. You look up the tier name into the tier mask bit.
> Just set the onoff bits for that tier.

The desc array is currently used as an
intermediate structure before applying the bitmask in swap_tier.c.
but as you mentioned, it might be unnecessary. I will review this
part to see if it can be simplified.

Best Regards,
Youngjun Park

