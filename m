Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51BC0107BCCD
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 16:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375116B0088; Fri, 13 Mar 2026 12:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C576B0089; Fri, 13 Mar 2026 12:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282A06B008A; Fri, 13 Mar 2026 12:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1408D6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:49:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2C771C1B1
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:49:21 +0000 (UTC)
X-FDA: 84541625322.27.963F830
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9F2C12000B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:49:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W6GX0R80;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773420559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OoZ6jFB25D0x8NU02gRfdPPo1/nMY4T6UovZLQVRg8=;
	b=YOKlFCmR60y4vnJbJkiVlOiQQTGoJl0PveEiJSs1w3hap/1x/YoMSvh+ZnKcWaaBXfWlfZ
	lXxd2A8JBWvsKpfIxOdlco1gdNQseS8/ZSDzFYhElYUwOitPK6EtckOcdX0ZpNiRCNppF9
	gH6lsCo8z/4CJXfnSJi8+vNw0IqVADw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773420560; a=rsa-sha256;
	cv=none;
	b=AqHB0AOSe6EfgO9/mMKHJJrbthCixx3PRZIdpqd2esRJGoa6fugPBkJKZ4DrNDPR7onl8A
	0vBrjBmLRiUCJzgGgFSiJKvyQSqps4YCW1KZg/wvHAt+UR84bFCmYZ4wFYMKDlUf/nQeol
	HBlTumEg4b1FL0U81hvcquyTrL8ffmE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W6GX0R80;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-89a133cdd4aso31048946d6.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773420558; x=1774025358; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5OoZ6jFB25D0x8NU02gRfdPPo1/nMY4T6UovZLQVRg8=;
        b=W6GX0R80TbxA5kWua8i6SYU8QuwoHkUF1w7DAkN/P8aCQpmYm27IEuAu594wY5Ygy3
         cg3KPxPms5GFvsSA+1hty4QG69RCgdkDbqc5gUmm3h/tW8yptQz+UDRQ040cILH2hhAy
         fNxlBCY1JQZuiG5bGdYAF6OvKsGUsugV2Rxe8kxhLC4+wVpVd0M6qg2tqe5dmBJZx8qX
         DufXlL+C/6xArJB/LMOAg+/rvVO3hmKITRPpsi/CEqJMa8WVRSnOtfgvcxfHhLQvd+/i
         Nhc9XmcyAON3QFzd+ZiH8Wopepadw+y06TgezFB93bc68Cl6vBk+h/h45dxaql3qPUpV
         Pe+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773420558; x=1774025358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5OoZ6jFB25D0x8NU02gRfdPPo1/nMY4T6UovZLQVRg8=;
        b=a5kY1YcQmZ1uFaLsYFqSmOYVrzH8pWqOgSPrWIABmpUSmeeYndXGgEre7x+HNFOCWW
         t+5dSQsrOOtiqQwBdm4MX6M3h6wkC/EEblbLQdlL0zHKpUGL2GTny2CtFOmcOZwNmYjJ
         tcknzkFvK1MaCKi+Ga5UCBe5MOB1r164/Py4NFzTjxAr2yIwXkObbePbDPrHD0KgqZbu
         XdDsv2MS8zEC3uBXqhLDU4GS5Zoo8qdrEahf+pCL/2q8GF5HidFF8Inck0n/z38lnWBf
         mYtiv+uHN+nJ7d1TofKTT0BVeZ45KdMtCDq93c/flaPEdkLa0aZ6QlnjXQRoSfREuuK9
         HZlw==
X-Forwarded-Encrypted: i=1; AJvYcCUqrHmgBcUKvGbOwSFuuwH24ZaIDgA7aCEu6tx5tF4NQi5hFunCRGOjBWJ8uExy8Y6i0IF9ZyBJ7g==@kvack.org
X-Gm-Message-State: AOJu0YzD4bBAzCEzr+fDHrVBSGinh0z2LwmQBEAqAqsXAv08vmLNG0Ze
	0IEGSx9YxyX6DPhqTnAmA/fHlSeOLMPp3r2adG8dizIOwSFQYGnKuT5S2OlwVpzoGS8=
X-Gm-Gg: ATEYQzyL8rG4cDorSbDQm6Dspv/OB2QwbGxsCKu87xYNmIv5DWRnW0yv7Z82Akm6rGW
	lFphcEU3zfq+VoGuNV1yzoYfHa8F2MzrV6gxujussyPB02UOYQLm6IW0YFrMZ/mJpYkevf6WEWJ
	hdRw+exRNomhXCna28bqVOHpU558sJ4Kw04LZbMPg/OG6fbqGJBYaVDi9RpxCzjZJ9zsWV/o+Bz
	sjmIN6WM2vHakq70KmmD9Lve6dgLPQStrxP14eBqUIkMIrnRtwOJbxP3lmNp8s7+nwfpKLjiSHG
	edZBsjUszWZ81hM0AlrJYx36OLXJIZUWxw5m71XcDfF9dlsnJeGxyhJOBUTF9zTYVvRL5+jKDRM
	z/7ZdiOQq/1zqV9n17RJk3worO1l8PPPefSvqnnDhpO5UYY3e9UDty0BmNsLZxuOQfR2gfAShph
	ClOQtrRlivJTqpLyrQFOI0XA==
X-Received: by 2002:ad4:5c49:0:b0:89a:ff2:b8d3 with SMTP id 6a1803df08f44-89a81f8c6c3mr64520096d6.43.1773420558533;
        Fri, 13 Mar 2026 09:49:18 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65bd318fsm58816146d6.8.2026.03.13.09.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 09:49:17 -0700 (PDT)
Date: Fri, 13 Mar 2026 12:49:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 07/11] mm/zsmalloc, zswap: Handle objcg charging and
 lifetime in zsmalloc
Message-ID: <abRADNpx8vhTMP-d@cmpxchg.org>
References: <abMzKa27khxDLO_D@cmpxchg.org>
 <20260313153434.4074128-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313153434.4074128-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F2C12000B
X-Stat-Signature: ha1wh98pt4w54g7g9f3upwwtf8d7m9ym
X-HE-Tag: 1773420559-904399
X-HE-Meta: U2FsdGVkX1/vrPlU0a75CF2Mwf9/+ecesviQdXIXDGTcOtRHnk1GooCj3JFEKp2Y0bp+0FqWjTvt3sxTVklL5XofoyqdB3Y+zTTcSm56iKVwlAsqUiTvbqmCOEMyUIIC4fB6JPt3epXxXy/6B96m9Dew5X8yx4LWNYKHWntcqq8qQFtMlosDODPCOWeOb2S1ktHNkVJZP0/EqZFFujbmzsSeMhpnZbuhLaH/berPFKrc3lD8IaUTCQuSgNDae8RdMlxayqlV8usWWgwkZstkR8GhgYWwWrL4dbVdzd2pQCl5YuN1gUtG7QSlLLzAMhc913t3ysH527J9+GUMNQDW0045fixJH6lfkX728ozt+jVl1kB3kyHWzcIDUanrWjbi5h6Ph4v00/GBWL2B6eBTI8h4gvLFNgCJAUnAyV3BSjmTPKl1VAeWHMsdgjV7deyz+jNvTm1R2Aj3UyqZOZFxRoGCp/0RO6AoenuihejJeIzEGoCQY1capvBFFmEG8jiFk5AnOaHUOSJktkjcsDVOwGFKqLbZ6pFkx1Cy9+XzDEICrQT9j7fEyJjp2CNHmp23RlpPJmTq9QPLME4gZoqc0uswOjQooijqI3+lm8XnF8N4bDGyuXUF3O7pCgl4FhbJKVMk5/bihN8yux/ih69kUO6zUsxFeicUbs105FL4LICQbPJhw/36AJSfZHMUGzjVWOUBcVj/fTDrUYqRZLgi4+pQ68Y32umjmKkXtgCa+tSez1BU7K9B+Fe4NBVkLK5+n2VfmRTCKnAEyhDDWwswppCMct8g9nV4Lj6lQ4wXF5Wx4APU3k2dhUB8T6AzwzVDLCtQY9z4sCnVSMY7A65sIoxYe7pBX9DmdwJWqcP0L5flaXKeOmav6lBkMSfrbYHQT6izguzRhYenoYjrP5mIA9YDFC9Mb3mLUGgyeTsdCaopAyV6W2ta5vXB/LWpPL6wJaH15jHNgdM38UpfjMT
 q1bm4zHz
 nMKkapq2ID1XdLFOFwTO6DY9wKkmKgkL3flKMS6iDrHFSmZIMJd08KAfYL7IKoIR0sjgXu9GyYidsI5/2C5qbTdTBfQDWsshH0pADkcXvwsH6HowZUGQSYVDbTy78fSAASubfdODNaHLv039OIaLXDLVUJf0FPvv3F9CAUdao5G/zPHzdI7ZR/sX30djdoKVT2WkS/kAAvuYw3oNihgo9dimQCYw4JN9vM/190UH4AewUSMxRUL9UT5ptxIuKA3vTANXQm/0vvUzEqGjVn1XuQBpoE+uXZbZna2czFyEwrYoBhJ2bNtQl62jqJzC89R2fOaP+OyIGECTL1mWtRSLkS6PkYDGQ27cbbKdFEIQX/IOi6XK4hPWPPf7fpbWXt7JabzvqG702FgrJpT93PVp4q76PNIQaSNrzGfKoiZXnZB3oLn97L07xVioRz4ry0liO65HujIzSFyJU803c52KBaOiUH4+QUbf0QObU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 08:34:33AM -0700, Joshua Hahn wrote:
> > IOW, it's better move that obj_cgroup_get() when you add and store
> > zspage->objcgs[]. If zswap stil has a reference at that point in the
> > series, then it's fine for there to be two separate obj_cgroup_get()
> > as well, with later patches deleting the zswap one when its
> > entry->objcg pointer disappears.
> 
> Sounds good with me. Maybe for the code block above I just move it one
> line up so that it happens before the zspage->objcgs set and
> make it more obvious that it's associated with setting the objcg
> pointer and not with the charge?
> 
> And for the freeing section, putting after we set the pointer to
> NULL could be more obvious?

That makes sense to me!

Thanks

