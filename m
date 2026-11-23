Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4DC606A33C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bNWDAJAr
Received: by kanga.kvack.org (Postfix)
	id CE0166B05B0; Mon, 23 Nov 2026 12:49:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8D26B05B1; Mon, 23 Nov 2026 12:49:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7936B05B8; Mon, 23 Nov 2026 12:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 963156B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14BC9C09DC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:49:10 +0000 (UTC)
X-FDA: 85467120060.17.26B5241
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36B0C180006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:49:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bNWDAJAr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795456148;
	b=WIo5X383mB+M4HNLUI5JKDhL9Q6pCESl8i5QNd3F3YP0bVeMkvwpx7ivxWR+H4nZrVyw47
	Iraxy/SD+8U9Cwd4DL4AwmcXLv2OfHe2409iUlncmsfi999SN+RqVn0M0mdhO+OfO+1UyU
	/nTYTWqr8K5HdgJsVfGtszyBNQA43i4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795456148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uy8AXENEvxp8VrMkoOr6XkIXIF2ZC5d2aIua+WZN33M=;
	b=FQbQKVyTmSh7VC24q4s/ODpEz5wZHZeYPIEtWnxE2SpsTjzm9ZmyXBcjAB4eLL6yX3DpPA
	efLRbbCLkvcwprbs3jcZKzavreP/V+DQwnPID9Csm8uYZp7QZAvHtkST+uLYQy7QXXBJo5
	Wv6YNHpXwmSmKXxPVBmFopzN7aMSFMg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bNWDAJAr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-483c607ccb4so1915834fac.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795456147; x=1796060947; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uy8AXENEvxp8VrMkoOr6XkIXIF2ZC5d2aIua+WZN33M=;
        b=bNWDAJArFYfBj1YGdZeVrSsLfyJM/+feF9oC2lb13P/vY9/f6eb+Kage3oJ8wR5iVs
         94puj2sxo43PwwTN9cUVnJeVbb49PeydJbzFeCZCRwOj5HQlxmfj0eo3CKEMx4wmJDS3
         eF7wECbjiGA6Mk4vye88jeTuq6Kr39DJ3S/doexzBbdJHzwaeyE/hyrfTPQa0gmP+ZKZ
         nK6sNviXPsZfb3J3H3QKxLXSsMwQC+759LLTOjYOnqbwxx5ooEfGqRtz/g1P9amCyv94
         RHNXBZM5BW4ykX827Cy9OrwzC6zaHycBapgUH5rrnzNoip6N0LXFQE9qxP2jZt6OCfwv
         sHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795456147; x=1796060947;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uy8AXENEvxp8VrMkoOr6XkIXIF2ZC5d2aIua+WZN33M=;
        b=B6nIwFv/qJxALRSS7x8FIiSHsRXPU6HtGbYlSfDBB4Mzu/7EmHGEwHjnal/LQhnXBA
         eRRYXlPNn0GJYLGipbZ2/VBwo1VQqsb4zkP2j0jy17qRThdS8GuDYpmP5HxQSI3+c1HP
         eFNLsYnAfJ/Jo1AGX626isQvqj6e7lpWJs5v8Ut+C/evGTJohDD8L0+wo3SYJhr3WFzO
         InGkmSsqDBHad9X4Oynp+j2GuvHIW18oALzt6C+Z+NN6ii1YFiuYiwh3s6UY6WG5CPXI
         x1xIYIiS9cuwofu+9M2/NFbhU1htbZJvql8Av3g8uoHhEwGoN7BHXRRtDoAYYmBOsgZs
         k+Vw==
X-Forwarded-Encrypted: i=1; AL+hErGrqCiu7J/YMR30f6kjCBE4i6pMAyB9nIM/tRbTmeGNFyLdk3hwkoHJCCojm6qvZ922EwTm3om8Ow==@kvack.org
X-Gm-Message-State: APuU4Z95HLLXmWc8+Mu/AKYEtDL2kWvdMQrL4USK/SyRVU0BOiXDbL2r
	S/HfpbB5XjAuiyfY/ATjK/GGxh3zNxSVhPDVPnUC7ZYj4Qgs5vFjRs02
X-Gm-Gg: AZFdTZe1pI/6OCwKS+Ordz4w3jGb1L0ZU2/eR86NA6iFZ9tG5gnVSBSRLggzOuOtaJw
	YWaDiggTB89EW6JR10qRHydDBL5iTXXOqFR9Y4EN2OY5oWx4cKk4ttTcKyZfWT1C+2PClK2u3gL
	E5LmwaBbtpJN/Te6LwPWtn1NJK7HovGdLD+CRhvb6XD6pdzptUAL7FE4iweZB0yA9D78tto0N7o
	JMElyk9NUGJ7ov88416Xm32XcKOhRWRMaOJSpw82IPIN6ObQUZ0tkK7CCDuHwfoqRmQ5gdIXYux
	wREgja1FSjfy8q2kJaX8tA53CD9wFPwUmaipB/HTumzZFW2KdSeF/Jgv6D/FwcQHbqzAPZfT3T2
	M0DWyQ7NVMTCRRx1Vy3zz+8BSaEToOgDmZy7siLMCmgq5KrZ/9SN0XpYIckfDjJm7Gsa2f1Fj9l
	VqpCIh3kRg5U2oEhhdNp1Gsq62aMJSy7tLRFX3TviZMoGoP8QVJ7NC6SGfI3lb1bKZgP7ZhxBq7
	PvLc7dp3Q072+5nkbweGmHJVR3hcij85CSQ09A10dNnkvvICLweAwbgOhGKFhQh4IFFY1MNRGhG
	uCXF7xa/M9tsE2JE/8OJhAOIP0rhoME1HajapmAY1+vpOsQ/9zONXpCL7S8=
X-Received: by 2002:a05:6871:295:b0:4a7:4b64:3818 with SMTP id 586e51a60fabf-4bc85eefab2mr10911425fac.39.1795456147071;
        Mon, 23 Nov 2026 09:49:07 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:e::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4bcf0794755sm10740921fac.10.2026.11.23.09.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:49:06 -0800 (PST)
Date: Mon, 23 Nov 2026 09:49:05 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/vmscan: consolidate promo vs. high watermark
 checks
Message-ID: <awR8ZuldFtf93uNF@devbig011.atn3.facebook.com>
Mail-Followup-To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261118230539.3789231-1-joshua.hahnjy@gmail.com>
 <20261118230539.3789231-3-joshua.hahnjy@gmail.com>
 <84ba8739-1f1c-4838-b607-e6181fe55002@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84ba8739-1f1c-4838-b607-e6181fe55002@kernel.org>
X-Rspamd-Queue-Id: 36B0C180006
X-Stat-Signature: cywnz54b61sgu5orknk9m375xjnx7zz5
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795456148-367368
X-HE-Meta: U2FsdGVkX1/rPpPC0NMf54viM0+sHRVTj7ZLvGMLIv3FQjc2E4Gbn2xmbE9STBKIiItE0J7ViABtgPElSlnzIgCm/BKsRydlCLu1lIggEpNveG8xnXfZxMKbuU0EpaclHVvjKAAYadU4td4YLv21zcsGq/zDhhyuXCPQQFj0v7s6tJBSUZBtZ+hkflmvlTrwbYk7lesl/WwcGGgGBMfrmQZijwqHWDixEtvzI8Xl+hcuHxQOwOCS63hwb4F5u97N+5mNokujkuHbhF6k9mg5QNXrmrog1FCXmx9ZxXXGy6eG9nXwLZ8ip/zT4P1H/dr9KKqZFBhhwGkcl2XmklB4L0LmUWoMpd4i6gyRHfBjR76H83ZAz6zAKNmNKZWeDJlkvMRfgLo1BYoxuCcUea6D+ZhrwnVHMYA2mCBH2jjcNgGhXL3kV3/fRXwheoNan8vjCoYOInALultTSog+iWcVJrX+CFpyGVAwIWCP3hU99+naRszRnNahMZNj5qYzt5TgGm6IkndMRvwbcR89qySaD3awd+EejXqEcLe8gYidYjaFCTFlu7YTUIQ6p1CXPQEY+XmiS5rtEHO6WTTKB/yN2Titj2BULnZ+UZ+PM0q/rCKcGtroydr8u4dNbrh8C6zR5XYc7BM2lDTK2BdJneWixwyccsYEvvpcmApon6qFLq96jihyuwQ14P57cpSCQvdfoUlUgj1P+2FSCzmbzBPLhtSR9fP+ic4zzQrzI4fgMEt0vmPO0LTi+HPW1cKz6M1ZkgNj8FhrGdz2+HypjN16g/C4xnxvmT1N85z5DXwlJyHMj4Ramgt4WyUMsCYNIiJHql3LAujNqbZuP6xOv6Y/7EmWvzeJsje2Y+P8Xm94RK/MgVCHlz5jFbreG8OKV0W3h4ZVLLK0Hl4Gq8mU1dFUQeEBOL927Byi/pQkRBr35jCvRLxBxqc/KLPUPFICqc3Kib0Rpl2OxBvEvnzLWyS
 cqOPBcrF
 YTGcA9MtimTrJUsFFooPVzQPrcSSP2Hg/XhChlR9qydsypzHh6vk3HargwdTl90mlJuQ77UCmefxxXTtM7RgBehsfoAQiKgo/aAFfHuHhL5GTONbcjOOi/z6mAZm7VEy06Yp0Lu69mO+nsIAbnnKyWpOHVc+n0LxmZj/LIfZx31TuMMygI0mFU06/NcdIxkxRdRBHd3q++J3jhYSS2jAodf1a1PEnhUvRSViN2zaNcAHvZ/al6tbU0qhP7EqXHQlkPky8TIxjrgMDxWs6LSOMv6CMnCVtzAuLIXc4+OXSQNYUDKuQQ5Qh78tX2nEHkGp/z+x0am7kBhFtcUPaVH/39clnSWSa58oWLHLeO0NM/E1Mw7Zy2nok1lJitl/lMIKp+DzqMJS6H8TBKMozos/jsH4dvEmTouprepaIGXAW73MB7hcg2/jjP+bWg+2htliXsgYBRWIEhQjvg//ZHCJL5tVXb7+N2If9CJnrM72Va+xuVwE9+6Fp9nTKC66lAE8cgNPNDyPqUlNv8j8OFcbNHXGHR7e1IG+vc1v3WvaM1JRpoSvTf0/b4KgvqUmZOer8F377hOGce71rXaTJe/JJnlCc1ROgpJnuI7lxdT/UApmC4PErF3/FTYb77Pd5PL9TZu5clX/lHchvqgM7Jc3QJTyqG6GNgFngt+qaviy/U38HY85azVaQ549isq2zd43N3NoAEeqQClAKQWK4jAn+H7G+LDd3s0gtqlnaYfzXAmO7aA38YyYX4hUEXGK3L/0k9tWXqwoGsAivLSAKuvLcrPC7jsxXIu1MAUJvgnOG9XyZv4yj3+6ouM+MYnY40f8A/Ixn2zgkq3Wl3uedUTfihgKqL8Qil80AluST/G9763/vho3kKe6jdjGvHWm4c7M4UlTMjSzYWg7k1fgf2V0NwXNXT7yhVZG71OsnR4GSncMjL88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 02:44:31PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/19/26 00:05, Joshua Hahn wrote:
> > There are three sites which all check the watermark that kswapd reclaims
> > zones up to, which is the promo watermark when NUMA balancing memory
> > tiering is enabled, and the high watermark otherwise.
> > 
> > Consolidate the pattern into a helper function. While at it, remove the
> > include for <linux/sched/sysctl.h> in mm/page_alloc.c now that the
> > dependency on sysctl_numa_balancing_mode has been abstracted into
> > vmscan code.
> > 
> > No functional changes intended.
> > 
> > Reviewed-by: SJ Park <sj@kernel.org>
> > Reviewed-by: Chris Down <chris@chrisdown.name>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Gregory Price <gourry@gourry.net>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > Tested-by: Chris Down <chris@chrisdown.name>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/internal.h   |  1 +
> >  mm/page_alloc.c |  6 +-----
> >  mm/vmscan.c     | 22 +++++++++++++---------
> >  3 files changed, 15 insertions(+), 14 deletions(-)
> > 
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 566cbd2dce485..8beb5b263ca1f 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -68,6 +68,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> >  				gfp_t gfp_mask, const nodemask_t *mask);
> >  unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
> >  			      int zone_idx);
> > +unsigned long kswapd_wmark_pages(const struct zone *zone);
> 
> Can we inline it? Seems wasteful to make the allocation fastpath call to
> vmscan.o just for this.

Hi Vlastimil, thanks for taking a look! Yeah, sounds reasonable to me.

> I'd probably put it in mm/page_alloc.h as we're trying to split out the
> monolithing mm/internal.h
> It shouldn't be a problem to include include/linux/sched/sysctl.h there for
> sysctl_numa_balancing_mode, hopefully.

Doesn't seem like it will be an issue. Let me send out a new version for
this with both changes then. Have a great day!
Joshua
 
> Thanks.
> 
> >  
> >  #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
> >  #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index e7a7863e381ab..31a670eb4832c 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -45,7 +45,6 @@
> >  #include <linux/mmu_notifier.h>
> >  #include <linux/migrate.h>
> >  #include <linux/sched/mm.h>
> > -#include <linux/sched/sysctl.h>
> >  #include <linux/page_owner.h>
> >  #include <linux/page_table_check.h>
> >  #include <linux/memcontrol.h>
> > @@ -3805,10 +3804,7 @@ should_skip_kswapd_zone(struct zone *zone, unsigned int order,
> >  	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
> >  		return false;
> >  
> > -	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> > -		mark = promo_wmark_pages(zone);
> > -	else
> > -		mark = high_wmark_pages(zone);
> > +	mark = kswapd_wmark_pages(zone);
> >  	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx,
> >  				    0, gfp_mask);
> >  }
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9959ca158ce83..9af50783fc824 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -478,6 +478,17 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone
> >  	return size;
> >  }
> >  
> > +/*
> > + * The watermark kswapd reclaims zones up to. With NUMA balancing memory
> > + * tiering, kswapd keeps room above the high watermark for promotions.
> > + */
> > +unsigned long kswapd_wmark_pages(const struct zone *zone)
> > +{
> > +	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> > +		return promo_wmark_pages(zone);
> > +	return high_wmark_pages(zone);
> > +}
> > +
> >  static unsigned long drop_slab_node(int nid)
> >  {
> >  	unsigned long freed = 0;
> > @@ -5212,7 +5223,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
> >  static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
> >  {
> >  	int i;
> > -	enum zone_watermarks mark;
> >  
> >  	if (unlikely(sc->proactive && signal_pending(current)))
> >  		return true;
> > @@ -5224,12 +5234,9 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
> >  	if (!current_is_kswapd() || sc->order)
> >  		return false;
> >  
> > -	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
> > -	       WMARK_PROMO : WMARK_HIGH;
> > -
> >  	for (i = 0; i <= sc->reclaim_idx; i++) {
> >  		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
> > -		unsigned long size = wmark_pages(zone, mark) + MIN_LRU_BATCH;
> > +		unsigned long size = kswapd_wmark_pages(zone) + MIN_LRU_BATCH;
> >  
> >  		if (managed_zone(zone) && !zone_watermark_ok(zone, 0, size, sc->reclaim_idx, 0))
> >  			return false;
> > @@ -7131,10 +7138,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
> >  		enum zone_stat_item item;
> >  		unsigned long free_pages;
> >  
> > -		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> > -			mark = promo_wmark_pages(zone);
> > -		else
> > -			mark = high_wmark_pages(zone);
> > +		mark = kswapd_wmark_pages(zone);
> >  
> >  		/*
> >  		 * In defrag_mode, watermarks must be met in whole
> 

