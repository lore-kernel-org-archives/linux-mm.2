Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B45ECD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F19A6B008C; Mon,  8 Jun 2026 04:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B5F6B0092; Mon,  8 Jun 2026 04:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 443776B0093; Mon,  8 Jun 2026 04:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DDB26B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:02:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA2C41C2B16
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:02:30 +0000 (UTC)
X-FDA: 84856003260.28.F7328E6
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id D082240004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:02:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VfraBNvA;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780905749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4D+rfriPl0lY9EHYm9kP066Cn47rD/uQ0mtQTBMxuw=;
	b=al8YVXa5FnZOdFURi9kj9nEZ6nj0OyIbCLAw1bZUW1kah88mD3sCM6xWPKxWi2SOMBXjL6
	38e8G8q1TrxWu22vs2MG3qOqijlaW6bKDmUphZAZfOCbCwCdTKJnpzSjjMpbtmv7zsEsee
	NZHbbBBoKvq9LgJcb/SET2Fd0+6uVtM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VfraBNvA;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780905749;
	b=fca44a0Wpfb32etAE7Ho/2+VTTWRXAbONQt0TcVuqGm2myXRf/QKiLyVNJ9vyrSCM71cxp
	cNEiwNVRqZtJhHDvMzvCb4CZRbZxe0Fk+sgK7bGZMtAg1NakKUGAoPluQTEWYuCixlJa5a
	sDK3bckVllKAaQwStYh849UzJN/tiR4=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490b64c8311so44822515e9.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780905747; x=1781510547; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4D+rfriPl0lY9EHYm9kP066Cn47rD/uQ0mtQTBMxuw=;
        b=VfraBNvAQ4lvB4P+5ob9mB8bLkA178oQ7GL1lIYweEwkPyo1DMtk2KNIwowsUGjAdt
         xJP4YCXLQtB9RGRHrmhi5Sef8MKQKziuESj+sE9mRLO1ACDDhxHo8bOCCSiR0beULdle
         XN/o6HXd8e5eyQGl7/5WDrtrKUDfsqeVuRM4jtp+qd8rBJNus1oPFcCcYUnl2PRkqU8Z
         /itkcGRG2KtxdrpWyb1URl5n96JBxuWYUAjH99BZ6Xc1garACgBB8a717V9LXMJZe9SH
         p3/PjpLdXwHBECjxhXINv7SUOOzjqbPbMsX8mkPteILP9wGF4mVAsbf5qs1wlPHcHWUx
         eFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780905747; x=1781510547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q4D+rfriPl0lY9EHYm9kP066Cn47rD/uQ0mtQTBMxuw=;
        b=l0xeS2qP2kF2PBhV6GeKiFQxYZrXvIdmM2cYRBTqwFml4wlIH77fHXMW9S14KVGecA
         2RlFQILd+zFYI2ij30u0a3v85gKxaVpilOESZ6PeySTWNRZtiXtPmKOuxYedu3Xo+Jd4
         1unGDZR8VCxjwYZHyc6yJDYPiXzlyG3nGWZydU7imAYVFF5mJHqBLdbR7b09NF0cwjlM
         Q+OvRmQPFf3hAQGqIcGPv9o2gT1QLICaJ7baFvvlCsOcc3/g2w6np0nmmVRYJgZ221wN
         HfQlyUWXlkosbym0xwm2QZdD3ERBVKG4Hdh9q1ZYNJu78ByoCeFN8DPj01cjB2scrm1p
         Gycg==
X-Forwarded-Encrypted: i=1; AFNElJ/Y+TYPw/oJOLP0q0hXYwfbdan57G++8PHLSWsfEFTTsU2WCLdO2LFquM6lg1SDft41RvD+WnPcRg==@kvack.org
X-Gm-Message-State: AOJu0YzYyTOywbjDr0Rk4s4yMWqc0zQpVdFMlUjRD0BFGDlLC5JDlmE7
	SCnZL6RdszhamYmZsNRLqGagTucblkuB9c4vVfIpnMKmjcK5qqx8Xak1KqYMs5NpqgQ=
X-Gm-Gg: Acq92OGwXfSkbbIapvx0cfIV54E3CWaCEjYLRokToQvgELx6RZ9ePUukTOWaF0+Kmnt
	lVCHX2Hpr9FaA4XjKV8+tGqNXHQJIumvrQOgA9V4yJaT14loK6y8R9w6CwVc+xw8prNFANfeoF3
	kaoJBZoEKnHV9iwSmR4YCVrVdTgjn/PqbAx8KKWkj1IaBqobb/C8Uf2P6HL8auFylapLHqhU3m/
	TtC29L6QP7EiXX5gUM+ni0ntmCFzZEplS/I1jyu/8ygxapS8aIXkqh6aTpW4C+UqjlkgkhT3q9q
	V4LRUS9RQyASE8CIuJ6+11zFkFcFTzet1Qk1KYc6zefRy9MV8gEqK75+5FOK4Mev2ripCN4I6PO
	CDX0gnIz4CGADjWQWMkeM4fzE5YNeIvfJVbUn6Cl99ZxQGOPF2W4hthilp4olIIZcNsbQoKvjRv
	CF0wvWKBxZaV7SVXUWFeF94/D7NpVrSLMkvp6eox+qhWSPhjk=
X-Received: by 2002:a05:600c:1907:b0:490:b99c:9337 with SMTP id 5b1f17b1804b1-490c25a0800mr227077665e9.10.1780905747263;
        Mon, 08 Jun 2026 01:02:27 -0700 (PDT)
Received: from localhost (109-81-90-161.rct.o2.cz. [109.81.90.161])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cc140sm447585645e9.9.2026.06.08.01.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:02:26 -0700 (PDT)
Date: Mon, 8 Jun 2026 10:02:25 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol-v1: use nofail allocations for soft limit
 trees
Message-ID: <aiZ3EZZV6LqsTxQM@tiehlicka>
References: <20260608063644.39-1-ruoyuw560@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608063644.39-1-ruoyuw560@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D082240004
X-Stat-Signature: 985w55jnr4ftw9fq1xg4ydwsmoi9bojz
X-Rspam-User: 
X-HE-Tag: 1780905748-595045
X-HE-Meta: U2FsdGVkX18j6Yk558fnulA55P282sL7Aqc5ZkJX4b9btaM3Nd8Q53rSB0fW/2/ZL0Lmd92rdb7YxXhV8JTW/zheu4/U73UgMuf30YyKf+Og3oNkHmT9G+zc64Rhm/gG3/vp0k66WI/O9qWwERL1y9c0IAbOwNHiQb2nZbBGx67l+7E1EEtz4ClwMEU/zg0MAPYI1bHcmvARYhkBDEfRJfm693KnC7ICybCVWb9SbYJLfXowAmB7pQR7NQ0by/mvqcR3bUxiJqUeJvUG8yyrNTdYmZzGrFTr1+btGLGJQMD3XFVG7jxv+AzP3sLOX4gcmDPCJeJ1Ozcdyt4JaecdcSB6GdjYcWA6oMzYTEfmt9A1Of4csYEor6pS9t2aO8lTUQWZCyO6D0F+XzIDTedQZdEiRBOEpSyNwdhLPNDNL5hSd15C2+xpdds6XVYXVglqWo/1sq2FhW0ex1H/rjwtHZT+L3Jpm6XKIMSK0DgxKNoRREqqEiPnIoyj9hRLbZokFI9rg5J6FgENu5BYaDC4/YuzdpVTuUPE+noCGnnFGL5mNAsjClN7PTK3kw7tFi6azthxaWVZIZz98BqDMHbicZpB20ErQZQdVuH0vbfYjv1WtlYvm8SbusMcyvjMJocs4a5ipITWhTds9tiyOIu4sA19PSmhha4sbck8bDm2alHz01a7WbF1ZTWstlqmWDJ+agn2bd4hjnY6WjD5KxhkeDsQU/UUCdBds+obRQ/RLKxF0MMAqkVAElyX3TYe9midb6tL4Zhyj+hLTh6SZYDweIwPQchZF//jUOhTomLh8oTWDg8QP5A5AN+Zi1IhTbZQwgaeGS8WmQub4eAkZuQeTUxHwDoVooAZgzLPrq9O3hr3lSE6K2vL1dQjO7nlOj50H/3JH+0nGuTKcadAhIPTmqUh9NZlcPb5HD8Sp8Fd59v9Mh7XdydYSvHnrPn4Pb/Sw9cs45qmQOx3X5oMcBe
 5cDpOb3B
 +K33KOt7usivTud5HAAk9/xwcYZIvMs16o9P7/ZuAjI7cbvUO1oPhurhoKuHZqDBlc1ST36pGCKbM2l6S8Bv3yGcVt6BgBzNz7V/exOphALwhk/Wn/4CYYH/X/sm07WlscC+XwrI5DHsY7msT361gS3PYoFLoghJRnxBj8J9g76DEMBDSja1ktOYUHnrevIpfb7OZMHu5N+EhQu0n2DXD9pGE6/ltIcvb1w6/Eek/BBwqFqUuRWHJkwRUc4fmspn9PN+Cf2KA8u1O2PQ3iUJBzTbj5QXyKwJ15P9FPZOrfiVDNBDKGnqMYP8TKWGw+Jp6KXf8/8wbX59e7Gu+jACRjpLoIw8hkBUboo2I1Bthioyj6Cj18CJu+yNRXHero0r4zrwS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 08-06-26 14:36:44, Ruoyu Wang wrote:
> memcg1_init() allocates one soft-limit tree node per NUMA node and
> then initializes the returned object. If kzalloc_node() fails, the rb_root
> and lock initialization dereference NULL.
> 
> The per-node soft-limit tree is required by memcg v1. Use nofail
> GFP_KERNEL allocations for these init-time objects so the init path does
> not continue without the required tree nodes.

This is an early init code executing in during boot. Have you really
seen this allocation failing?

> Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
> ---
>  mm/memcontrol-v1.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 433bba9dfe715..3f41a15d8a8cf 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -2246,7 +2246,8 @@ static int __init memcg1_init(void)
>  	for_each_node(node) {
>  		struct mem_cgroup_tree_per_node *rtpn;
>  
> -		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> +		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL | __GFP_NOFAIL,
> +				    node);
>  
>  		rtpn->rb_root = RB_ROOT;
>  		rtpn->rb_rightmost = NULL;
> -- 
> 2.51.0

-- 
Michal Hocko
SUSE Labs

