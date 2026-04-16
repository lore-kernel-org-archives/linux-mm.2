Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E29F433D7
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 02:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C05E6B0005; Wed, 15 Apr 2026 22:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699A76B0088; Wed, 15 Apr 2026 22:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA1A6B008A; Wed, 15 Apr 2026 22:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE4C6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:23:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E13ADBA6B0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:23:57 +0000 (UTC)
X-FDA: 84662823714.13.BCD1C8E
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id F30FC20003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:23:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTCoxB0p;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776306236;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EZO+AlyFvDQ+L9T+ECdGiRnOG/Ep4JVC8TTiPB3/Ng=;
	b=Cn6H1G68c7r4eYuSwY7RuR9zs0+hdkjv6Kz0qk4IhJ6MCL/gHvHC83eea85KfxkIJk0vrF
	rUGRykig9YnPXeeLkrWuqMR85EIyzbkQ03yHFomAckHg/0xMqtEy3X7WN28G1vP0FqGNb+
	pNIFZpZ2B85O/GLPh9FelBbcSIxqjCg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTCoxB0p;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776306236; a=rsa-sha256;
	cv=none;
	b=2ZWJ2spk16K45MXusnArLwqHAvomV0/+m2QiP/gEwQxb0/ZOBIYfIMLvedkyBBLjn60Ppw
	ZH5BDH/2MculA4khPW3tlhPKbq5ojW7lVTQ3VRheaKCGypWwQo6oFK9a3F/X/XTeXrsqxL
	+dIqJwNs49EhqbeKsgwAsB4yLHPSa/U=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-671dad7cac8so4392164a12.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776306234; x=1776911034; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EZO+AlyFvDQ+L9T+ECdGiRnOG/Ep4JVC8TTiPB3/Ng=;
        b=mTCoxB0pv6gLECyGHZOjRWaj/NE7OX4qhPWTKJDHMz1Q/T3jCGzifS+Oqb+5cs2Crr
         DhoTaAjgQKfMDaKgZ96W7CKzfD7Ge/yLsKbGLYxDL27A1YrcJPB66fRSMPDo7kc6RG+J
         SEpd9oprc3Y6C7a62u7weVFo/pcTSVd77cc3k+eShvCOqK7QQsLFEcsc63D9+MfXb2Qr
         e5l+TBeU5P63wKZYzX+gJAOIw8Wq1U13SSwyUN9ZHZXdUzVKM9YfQZsGXClO8DHcFcxt
         VdOp2Ff04xb4bG6gky58GjFXPQx4jf18B4DVQDloj5qPTCypm/sNpLf6WXPUm5dz28Db
         uSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776306234; x=1776911034;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3EZO+AlyFvDQ+L9T+ECdGiRnOG/Ep4JVC8TTiPB3/Ng=;
        b=BNE6CJ3bCYNzAuda4p7lNhD6H1SuHu+E8/Tds/0Ybxg3B22rRakwPgUcqANNugLqow
         deHckyVPMIT5XecH9ZSMMnfMQwMYTtizRj2baE+yJkjjh1Sobkknc5aKPDaePbTexIs3
         9qwAFs5LAtHezIbYPqgEpEg19qUTAxlBoRrKSUUARDX8gnZI2pb7Gpxzd4D8TNxx/yHy
         C3sNodVLaN6qUDzOLiEIYVX6VtCI4RaIqC5cYJrk+dLemzHTkut8PbW2MuKscInmdrNI
         ljC9mfUFx0UTbvATr/2DLvcrwAKQKJRmYHYylhZkvJ+aRnwZQRtXd83FLcexRyLHxH7N
         5gHA==
X-Forwarded-Encrypted: i=1; AFNElJ87VP7RxG8dBWXj0qURhgxTg4CfVKUehcn237mvA2H+JqAZqqyzim/5GDjFAjFgLuwLbT2Pgfoxiw==@kvack.org
X-Gm-Message-State: AOJu0YyRnCcMBAepZinP6zLSRZ2Gd4tPzziZ+iY6tOgSjKGKJP1dDaBo
	w1F7NIRcXCnoYJIjGv3xwTHI1D1/5MUS23oUHvyVvNKShEBiSEaBwdp9
X-Gm-Gg: AeBDietO906VE5c93skry2FmRbp1GjhvwLmVUuXR8qmxe/75gP//mPxkT1V15oLwgrS
	WreEGmdn2khQWlS5TKzKDqN1vhE0EtPMxVS50MvuxbejgmADADtNbiEq2Uuzf9XhTrrT+CiTwjv
	8gyh4kVIHK445sG0gglOC0PAUBNVk7G5GbkVJvnn/DM3PYVcCW3n1aIgvF+CjYOcdpSphM0wVjC
	Rhw5DTTltXHbJbL2RLArjohNPrXbmLIW8AnYDNsCcdpg70j5vQ4ziDSVEtR56DOsbCJ64yBbAFL
	LggA0w1VLgOTxth29BqN7lpWYXXOXXGn/P7udfpOnUGfpi+dYcUEjTNhYgdYAwUTympSYCckS71
	At4ftWzejcRwwV9aXJ+DAP2YmPUYt5NcijB+E3HCP1oRgtiayhF/v+aBftXvkmaXjSqkgH4k0JE
	dFLwHPoZ8ClM8711ZbllK22PZSwvra/DHj
X-Received: by 2002:a17:907:d0d:b0:b9c:f69:598c with SMTP id a640c23a62f3a-b9d725ebe50mr1351344066b.22.1776306233925;
        Wed, 15 Apr 2026 19:23:53 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba17341bdf6sm110494366b.1.2026.04.15.19.23.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Apr 2026 19:23:52 -0700 (PDT)
Date: Thu, 16 Apr 2026 02:23:51 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Message-ID: <20260416022351.llek76h5cik3nese@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408031615.1831922-1-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 76tuy1uhzrn871hnzqchuiw1fn7c6byu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F30FC20003
X-HE-Tag: 1776306235-660136
X-HE-Meta: U2FsdGVkX1+je5NmIYvNKp/W7j9Ddy5mj7jsZ1CiEJ/IRFbwnnw+D6uivV90+Pgrl+Jvfb3jR6PL5K7K107/MLU+5+uH+PFWR4J8z5E6S5vxH5X+0SO8jnPOOlO5c8MxitM7AvtOyF9ZJ259ZLRgZnOjp3MCCIfdBNlin0XRFNmxs/rNLDJxJd2skopb/MEeLPpSOq0ZWTmFHZIUAKCnFgxVZrnICfM3KwIvb6La9fWUq1EZ/04Imu2p61GiBOr7QnrfMPl8gT+PKZMU5rOwL5WzRGxXsBXSVqS7WnQoiuGtmPutN9cv4QweneDEFP/OKDfbd4J1kbiR9gaoSta0h/WLeR0auQUwrBDGo49VF4U0y/RxFBWCDdktOn8GzqTLZc+/kiwtU1NygQgAYhN9dKfboIkzC+vyCgoMUlPKvwsJpYbQGoOpNSTYR8ZwulThXzBq1GhQNe/3PH4wBttDzZyw2zOF7kx9pAkxKlHvVHYGowDh0sL8spLiq7CprXQlb+UwSHA3n5jqF5H96w52fjWZTiOc9bUrFW+Kt5NKxlSoo66sI1XP4+7GoN/VYNmmuMnTNvBTo571YBtrTi97Boz0N+6/Lff2H56nWypdvqJJ+iI2Y+juX6LXQCpGazvmcskW2k9fAai5jTltW9jAuDqd+BvtsrpbDNSrLiq7llefrKrVIquGJCiDet8iICKC+FMTPfy240iKqkildvQoZJTriRrtk9/U3TxewvzX1lmnY9/vYrTthO3trdhsqnZJZF5DMHd8W7/wu5I9oRG4yhs2kBHb7zhYW50+OPsOEMggiUR5EjfkBe9XdBCcK9mnNnq/9dfu1owWdBitW9dH0nvKWmj0xShHocCZAGVmLtV+ipWVtGCFf5He95BspyG3+R7v4+/MDPmjj3R0SlQ+hQa3Pfcwbd2qwA9dawRPGkqelJt7b1CDQD3byxYW0YsE64O/nVYV9zC+iSRPZzI
 3CQbE5v2
 a4k6zWjJ36mFAGhVc3f7ZwsHrb5IWmGkXXwkxu+mFrIAU0niWI/44VXjOi/hTulccOej9s8c/PX2ULn5D6+z7Itmqvr0HSVoc0LEbcdxzvWXFITdkjtEitB9byV3CPGoyHcUtIgDRiLEo664b9ZElpnUHUwbALPDHMKBNwHaaUn8HYB1E+EYp7RLqGR1arYuiulGM4ev4i7F7kdr37BwulfE1rlf0W1T8wW8wTd0wWyvt7/1mis7oLpcj3NSNi7myOBOlgHngMEARfnor2YsXSH0Tju0u0JLpa+9Dd4KEAcaf/Aod7RbRzBF4pMpYExFAmpU3zGz7z5ABJPujnsIf47uOPPGqj91DoKRO2orcc9XObGkpY7IhMCcC1MZ1SPSFHIsm8P/3kue51xadTKNnZsRIau4dUNGE9lTkab4xfVGkw4MaW0Lls2G33leIxE3QxrZjLlrioldgrweb7TnpCEojflLEDWWuAGmx86umqgksXwvFMUCxQCSML+XjFKGoBuYVMndaRWGsJWEHn0aPqYFZpWETajg5ULLCg6UGYwGOIZy2iJslp2MHNu4PHAqWurYU2ij54qWCyDQVsYV5FWQeGdaK5VbGn/7JzjkbVU8a3JMgqZrxZmG2Sz4ZRcs5elA1VSW6cQtijt90BjOS44oJvUc7QobKGrlHPtSeFDpKOn3mE9Uwx2C8+6cpGN+8+MDVUuRxtR8zKB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 11:16:15PM -0400, Yuan Liu wrote:
[...]
> 
> /*
>@@ -956,9 +957,22 @@ static void __init memmap_init_zone_range(struct zone *zone,
> 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
> 			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
> 			  false);
>+	zone->pages_with_online_memmap += end_pfn - start_pfn;
> 
>-	if (*hole_pfn < start_pfn)
>-		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
>+	if (*hole_pfn < start_pfn) {
>+		unsigned long pgcnt;
>+
>+		if (*hole_pfn < zone_start_pfn) {
>+			init_unavailable_range(*hole_pfn, zone_start_pfn,
>+					       zone_id, nid);

One question here:

init_unavailable_range(zone_id)
  __init_single_page(zone_id)
    set_page_links(zone_id)
      set_page_zone(page, zone_id)

[hole_pfn, zone_start_pfn) doesn't belong to this zone. Would this be
a problem?

But it seems we have already done this for a long time.
  
>+			pgcnt = init_unavailable_range(zone_start_pfn,
>+					start_pfn, zone_id, nid);
>+		} else {
>+			pgcnt = init_unavailable_range(*hole_pfn, start_pfn,
>+					zone_id, nid);
>+		}
>+		zone->pages_with_online_memmap += pgcnt;
>+	}
> 
> 	*hole_pfn = end_pfn;
> }

-- 
Wei Yang
Help you, Help me

