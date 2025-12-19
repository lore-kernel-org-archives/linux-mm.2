Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71FF5D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971C56B0005; Fri, 19 Dec 2025 14:21:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FDC6B0088; Fri, 19 Dec 2025 14:21:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D166B0089; Fri, 19 Dec 2025 14:21:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF8B6B0005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:21:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BA861347DA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:21:27 +0000 (UTC)
X-FDA: 84237189414.11.634D3AA
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4AD868000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:21:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ou5elB1H;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766172085; a=rsa-sha256;
	cv=none;
	b=tKpCVXsD719CSfxtf3a0cB98HViBX/L9QFtne1lkH7gVst5vqKrXdyQJebQEf9g3uSQwOO
	EkEwWFPemGO0dfr40vGvW9AJOnsyVNqvEzlqrw2fIN8mLP4hVSwCx3SL80hyMgILMwY7Cm
	y5UqKleaX+1LpJGQ/Re6/7OL+XazLEo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ou5elB1H;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766172085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6poixgvi7k4a3p7V5U4B1NEES+vakqB1VmJNV82K1dE=;
	b=dWCsbHG3JWz8TuvoKFkI/sk2EA7cmwPZwAkuPFh+BWAQrdlxCBVmDGSxu10mEzFXOYF4TR
	l3xCLaFWar2e9LfWoXjqNWM9H4qrpMmWOgFYSJixtNgZkFUeGSQF+fBdsKcvNltIzAnIis
	eAM1AfbuDoCNqdgQRMdkKCjOg4SUcSI=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-88888d80590so27987716d6.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766172084; x=1766776884; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6poixgvi7k4a3p7V5U4B1NEES+vakqB1VmJNV82K1dE=;
        b=Ou5elB1HfO7KA5IgVMDBdoGgSMfZ02k/yYdh3m4Qy/34iw66isUuR/Wcv+rNAehHp0
         GjORMeQAmOaStyaLM8CLc8ms5L8MG9KXhU4MQW4R/9dQmZ4cS/qNLgmgscpT3FxOklXK
         HOKSwWJazTEDBOnNGppjvOZP8gET8PU43vM4d7GK/KVyGDZqyCCLhwZPoLbxM+ZMFAGe
         8DJa4lj+AtgPAmGxu1YNQgUxjQ7v4tWpc6U9hk60N/uhucTphNF4YA2o7LIn/5iqq3hL
         nwTF3gLpVJFUWeO3M1wgWK/j9oXFD7H8TuvSMjG5i8OqSZO5gN9j3xIo8blXw/boTMZT
         JGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766172084; x=1766776884;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6poixgvi7k4a3p7V5U4B1NEES+vakqB1VmJNV82K1dE=;
        b=doYmFk+sfQDyHUSO0epy4MpFAtIDFTQf8z51gVQ9Usoi2XLJAO4Xi8UhN+V0zEcxz7
         PjhzIv7X4KSKk68WqbS/Jeg9WVmPJg0dTCMyceblooU+HPON4OBvel+pm984aTadDjNP
         YoWv8ua5ZzSuxYEPA9zTzCtWagvk5c18TIQfGLlUPYPw/TjFDmXhyZkGFHIeOXb4esHm
         xPRCVPhDt89FzlvH0SeVzPQ1RY6Lmh3CtcZv8xY81w4mUnoX6XjbFq9LmHDrbHR6oGhv
         Hy0Ra3HTF00lLRtrcGY0riJoD+PfP1LDsPOv+rntrwSaxn0ov0bdJAl6UVwE66EafdAQ
         2IRg==
X-Forwarded-Encrypted: i=1; AJvYcCW1xwLfyPiMFRKsUe5dleDrEkDDHvxFvCQwZrgB498cf1igyqCztcZ5CFzyPahBs98VAbO9mVU2hQ==@kvack.org
X-Gm-Message-State: AOJu0YyUmQaZJsowaAgoECC29WVigflPkTTTVxoF743ygDtRbukIcUJ3
	kUPZPZNFBoL28EC/SHhRAB+T3yh55fKC+i3cRoW+ZjohtOsTXM+MPetjYwmQE82gVfw=
X-Gm-Gg: AY/fxX7b70J+/d2yjJuChvdygHnnvwSb4uRWrv8LnYXqWZWCn3ReqS8lf6IgyKMFYhB
	kB0u3fEFypsCQbheaispQXeXrDTIRR5DWtgDt2V50tyeQYdQ7hoBurjceovCf2/v7WgbwdYufVj
	E/VyxoKy1M8OD3wgR25YXyioGPxjJZu6XWTCzqfUwZD3fVJcWszz8I/n87zWEVqM280U1U6N5AT
	qTXvr6q07iHnk3oQabp9iwi67kulgMd+bpwZLoM0nSLWawNuFb5BmUVUmkWMmo8HDQZEK/UbKOU
	v/pM1OAK3bSkhkWDxzKRcReSuGqflYwq7v3uBzoUpjcwc+R8/nvyuGl8vA9muL0l5CzqNusirOp
	/t85oKkckZfA976fVHeegPWazmdHTqrJUC6XfgrdwfRcXPuNiy5jII5zY3JCmoOjxlOohqvFYpX
	BhMx/kRc8c4pEDAW9fnrmJfQvjVsdKszuSTaobZA7051jLQv0m81loGLHyreAFq/C+euO/Aw==
X-Google-Smtp-Source: AGHT+IFqRGvWFm3utZUlSnuDh/JRc0gj4X3rL44G56tJX9MhDsuqVHRYM6ukl5D5buvXmOYPelsPbg==
X-Received: by 2002:a05:6214:2b8e:b0:87c:2900:1f97 with SMTP id 6a1803df08f44-88d87605cf6mr55761116d6.44.1766172084201;
        Fri, 19 Dec 2025 11:21:24 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d96240314sm25602416d6.7.2025.12.19.11.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:21:23 -0800 (PST)
Date: Fri, 19 Dec 2025 14:20:46 -0500
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, david@kernel.org, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	mgorman@suse.de, linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
Message-ID: <aUWljnUzmeofr7Oe@gourry-fedora-PF4VCD3F>
References: <20251213082911.1509735-1-tujinjiang@huawei.com>
 <20251214160459.1c9d9cfdec4088097ff6d713@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214160459.1c9d9cfdec4088097ff6d713@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4AD868000D
X-Stat-Signature: zu7ge1fwihnk84jejekkzbh3kjtgm6xk
X-Rspam-User: 
X-HE-Tag: 1766172085-196894
X-HE-Meta: U2FsdGVkX1/wEGd9sJtlPyzV/5qts27uTpQi1E1UebseX3rr2ngjx0UOCB/8KJKE3J0AAfH0m1HzyPtny9jcma9f9khSJvKUK6H2Za8nsPQp3e7rSa6BJyXkZuPR1PhrbbaSODM9QFptzAzRw8UXWNkSaZfHRAvn2EvHb8b3iShwRlEaZQO2oGRZiuJCw85lPQOntxoTmlNAttMgRqopo/MkLTgewiXUeeRGnMQTJ5l2buahvoAtwRxbomqw/QcUtH3CJVlcja+t9H555b7nIrsFs462yd0sEpxW2yGX+4PcOIy/KIf0kHBlUy//Wxa0wnrXP/eTgCA3SVLT0Gl03LNLAeBzhfXGtUVhhZG0itxeIgm9SkPiuZl5nDDWpg+iLtel4vxFaf7qb/c35jqyWEqslwTpn8IyVf7JF5n6t6OHeSK0OoZAzEhMv8z8YZwFbLYwxUTrrd8AUGxVGP1zBV2ThiLlH2Pu/gFXa/yj2qfCqfFfQzin3DXW9dyMP3UMbY+5CZYrbhaLHs1OBPy96lbTFU8LuGMsMNsI0Lf+XyzHY8fCafYa9K9O+RngYj6UZLCn7zFu5GlxqvSBgJKUUzaHPbkIscyvCvJ4B4KzYiTBRVlaG/qeA6xNMkLeoiDRKOa0a5bKJcEMQWpUyYAWem/A/FXf7sqtHWPW7QR3w3+XVKUQ1r6LjX00sAQLW1moi/G8lXujdBdiJCbeVV29f1MIwIhzyfQbwBIb4qwNwjAd/04cPCKX0ZdJf+YXD8jpR0IeCfM480J2O40j7S/Ge2BTMP1SX8oGt3OphYS4fIITtwf/y6p6UIS6K59s9yH7bzhmyxReMr1R6R+W0Ne8GyqknbJyqKwUtxneKWhZMyDLXYXMxdZktymMd0lSWiiJC5JK+EDojpbNyRsIabS/TUp2yHNryPMFxF8u2OzC4iO3SaQTTflaSjkSgwAhbRHkCyv0sHUyF6bVW4IUPIV
 6c/29UV4
 tZRgHE2DozsXyOghwy0ryA8M5MRNT2259yECAKr8aBLH7I2yPMKGetVMve752BHoYv8FMNiLjFvAfTwrosOuyDU6MpKhdUu9RaGaeJB/E3YyoMRQpSjssLKgZ58YXEcbz9I5RrBg+jqhjx3qZyTO40xqEebSg3CoqC8itwEZYHHKw98r6I50eRHo8Zqg3cxqfSinlAwrNJK7Gp2mmhXa2xUHKzyj/TUChxKX/P++C+ke1cjGxPKGvbOU0gQOXHpvoYwK7toKcMkfFz9YYy7ehzRd7JyS0pmrPe8PZj9E+zMhPp0thdpodGAtvROZq9f+Lhcfs5nzvRFCVVjU0KL9jbWe4jUtl+R7aNv4hcunG0aVlh0gxAylPc/BIeRQ4fgzYWtTlEOuxMJqXlLBUUGBLuexXB+NYdPik63/yJDRgIaSqF/8Hj6MgR/DFqj7p4MgqJxNC6D1QR7QHpzYofgYyCisaYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 14, 2025 at 04:04:59PM -0800, Andrew Morton wrote:
> On Sat, 13 Dec 2025 16:29:11 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
...
> The intended behavior was for the rebinding logic to remain the same as
> the default `MPOL_BIND` behavior.  However, the function
> `mpol_store_user_nodemask()` was incorrectly returning `true` for
> policies containing `MPOL_F_NUMA_BALANCING`.
> 
> This led to a bug where:
> 
> 1.  `mempolicy.w.cpuset_mems_allowed` stored the **user's passed
>     nodemask** instead of the actual nodemask allowed by the current
>     cpuset context (`cpuset_current_mems_allowed`).
>

Hm... these things are a union.  

It's probably simpler to state the following

----

Setting MPOL_F_NUMA_BALANCING causes pol->w.cpuset_mems_allowed to be
erroneously overwritten, causing mpol_rebind_nodemask to rebind the
policy based on the wrong nodemask.

1. The intended rebind behavior of MPOL_F_NUMA_BALANCING when neither
   MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES flags are present is
   to remap nodes based on mempolicy.w.cpuset_mems_allowed.

2. `mempolicy.w.cpuset_mems_allowed` is overwritten by mpol_set_nodemask
   setting `mempolicy.w.user_nodemask` (these are unioned) when
   MPOL_F_NUMA_BALANCING is set because it mpol_store_user_nodemask()
   check for any mode flag.

   union {
       nodemask_t cpuset_mems_allowed; /* relative to these nodes */
       nodemask_t user_nodemask;       /* nodemask passed by user */
   } w;

   static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
   {               
        return pol->flags & MPOL_MODE_FLAGS;
   }

   static int mpol_set_nodemask(...)
   {
        if (mpol_store_user_nodemask(pol))
                pol->w.user_nodemask = *nodes;
        else    
                pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
   }


3. `mpol_rebind_nodemask()` consequently ends up rebinding based on the
   user-passed nodemask rather than the cpuset_mems_allowed nodemask
   as intended.

   static void mpol_rebind_nodemask()
   {
        if (pol->flags & MPOL_F_STATIC_NODES)
                nodes_and(tmp, pol->w.user_nodemask, *nodes);
        else if (pol->flags & MPOL_F_RELATIVE_NODES)
                mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
        else
                nodes_remap(tmp, pol->nodes, pol->w.cpuset_mems_allowed,
                                                                *nodes);
       ...
   }

To fix this, only store the user nodemask if MPOL_F_STATIC_NODES or
MPOL_F_RELATIVE_NODES are present.

-----------

On another note... what's even the reason for this union to exist if you
need to know the flag state to determine which one to access????

and they're both nodemask_t!

May as well call it `pol->w.rebind_mask` or something and let the flags do
the talking.

Otherwise the fix looks good, I will respond to the original with a
review tag.

~Gregory

