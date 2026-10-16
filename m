Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D57CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0166B0088; Fri, 16 Oct 2026 08:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97C06B008A; Fri, 16 Oct 2026 08:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACAD6B008C; Fri, 16 Oct 2026 08:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B03FF6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:35:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 432B7160466
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:35:18 +0000 (UTC)
X-FDA: 85328434716.18.8FA2D77
Received: from mail-pz2-f8.google.com (mail-pz2-f8.google.com [74.125.228.8])
	by imf19.hostedemail.com (Postfix) with ESMTP id 47E0E1A0009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:35:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UYKNZUpo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792154116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVfYgQsMCF8Qw1/e6sPegSr7q8k8sKUP9Wx/2uIXt/8=;
	b=QblI0d324lJcAHBfPF2vKqbw9dAN3doPpfX67mrw3cMmilVhCJHZKTgeIw+BrF/oZUniD8
	EssFUEDpKHACBHd//IqS5uQixAKJMjQvX8mALUdHgHxsaD/4/et5X/wHsK0s1gu6D+NyOn
	t6BP8XHfesLWnUACyJ+z7+0zwnlFrnU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UYKNZUpo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792154116;
	b=mxgG1cD6d5WKWaXtzqQIdx5xbR7cKlURAJtGDcA6ws37hq50pvN3q+pQAFQO5zNiGXOvjZ
	ctN26SISJPmrFqYkjrEeMHh92xBiq5MvmLXt15EejEqi/tC7/XK9G6bsU0KCYzZGjHi3W7
	lFVbQME63ecK9EaECgb7pxl6T3Lpb0w=
Received: by mail-pz2-f8.google.com with SMTP id 41be03b00d2f7-cd1da63bff6so229441a12.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792154115; x=1792758915; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HVfYgQsMCF8Qw1/e6sPegSr7q8k8sKUP9Wx/2uIXt/8=;
        b=UYKNZUpor0bbMF1e5sf0Ysxq+VHehx2bmtsHqHbYheHKB/1U5vXo9/HEUOOP36hmsN
         Njs6bI2wWMIJ8+jgTk4djesUSq//XlkGoZoOGtNjT+ASbmVFQpNQJWRskzy61PXIHkTW
         saR0vqWhfydDWfabJ0P0oeVhlTZ0lQi3prLuk/pZjzwENOkZsqfSj/CI1iTrD4W/XAgl
         w3LuCo35tr90tdn5vXW6OArPHDEVYFwzQZHrYbch8Pil3qfvIXbJb9QBf2/WMBF3A89M
         ZIGFDF7PHXYcPbb4v1vwE2BEjhSi6/D57vGNujcl5fE/RpnXphxne/NR35gX4n1rUy3W
         dqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792154115; x=1792758915;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HVfYgQsMCF8Qw1/e6sPegSr7q8k8sKUP9Wx/2uIXt/8=;
        b=Ffdp3vv4g4tFoqwaaogYbO9GUNk7BZkXNUc4k4zjMyQRwP8yxSNYwHPQch59sySPLq
         y38pjkJTNsaBoAD8OyHl59rqSPfTyPeDvRRsNegTYt7wYntSWF1kbtjinFnO9hUdp5uE
         D9VghTM6KuArncXdgNivMLZYcwBpcArEc+iNrrZom69f5BxcF3OLU+U7FFYAQe1ugdI6
         /wLR8omjwHLYa404U39B5fEUJbiqnAmSf6ced5Ruf0H6SmdnIIlQB0RSzJi7GIMiSqDe
         NVnBtC+xYFTKP7O81DKMkFWcp09GGhOqUSa6VDXaMVx1QXksRPsLQ9tEyVIz5NQ2Hr0l
         YF/Q==
X-Forwarded-Encrypted: i=1; AKwUvByPX44o85RqxO2WAstFKWdk4cxVWGx2gsH4gXqId85Si7iRB1g+OdJc7vtAk3USjl7MZhZydJ20kg==@kvack.org
X-Gm-Message-State: AFq9FYLx1A9byFl7fcbNDszWM7JbyanUNPJVSUnwqiHVUzpdylgFSTeu
	eTRrK6JjnU+y0KOyyy8B2woBpWzDRkBqDPD3S5Z5/yBUMCBudeKjrgOk
X-Gm-Gg: AYBFou1+y7fTwe2wNX+Z1HxrEMCEVYSI86uCnbDeimllYsdkeJdC8Q8dMip77pCcF1Z
	Us3kwkjYibxcytfgxLSgXzVUhyrLKA0GIxttnCUWr4KkUzS2Io3dLuj5lK6A6mxz/rcT9U8WDwY
	GNUvEzEfC2ZEAS+pWeVPBaqCmX2DLon0hgvviJoljj9r7syQduDrCetAY6OF7UzvEgg/7w7MRei
	0OCxUx1kFScK9HQghtYk46/mcldLN3Pacz6PUeVo7dz5c3zDazWdlP2QXN9aRr9jT+AZs3b/dLs
	oLxTZgsSEUVQ0QoCn9cTbdAOMu1M4jwHGdUkMw+LOy27Kgub+EcOpz2svyxc1paESgM+RmSmdEO
	so+SmcdOGdue36sbxLKbn8h3u2Pr+CNicAFoe4kSzT6EH8w2hAVi2XRgIfyOlXTKdxGOAUgaYKo
	aya5/DIR0s54m/fm6y1+GXP/tN9iOU0dZrdCRPn0HunD3eK5EvcYhfhIXKEVFHAATWMn6D9nEAi
	UD4EjlDd3vw7fb1iXjiITU2bN1kR9CfE/AurDCCgotSL5nOR5pNY0mhqZqFtyVNWsnAOuX/LWDi
	5g==
X-Received: by 2002:a17:90b:4d8e:b0:3a8:786a:cfed with SMTP id 98e67ed59e1d1-3acbb8bf8cfmr2230412a91.37.1792154114934;
        Fri, 16 Oct 2026 05:35:14 -0700 (PDT)
Received: from [172.20.10.4] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc4972fe6sm4162850a91.15.2026.10.16.05.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:35:14 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/damon/reclaim: improve grammar and style
From: Aveline Noir <jm5905938@gmail.com>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261015080623.808458-2-manuelebnerli@mailbox.org>
References: <20261015080623.808458-2-manuelebnerli@mailbox.org>
Date: Fri, 16 Oct 2026 20:34:51 +0800
Message-Id: <179215409165.864368.11903228864381211337.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1792154097; l=2627;
 i=jm5905938@gmail.com; h=from:subject:message-id;
 bh=cXn/JAAY5QHO7gSOwDgZG/1D2SkKrfxhPsylIeP28zI=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgboJ0y2WZIrQV0H4HJI1WEQ5sxS6pM
 Nc/XEYGLW8ee6wAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLmlhrl3kquPOrFE+xeC/g7LLIxZBSwDp24vLbGOb7+M1Qt1DRDethJgmuvu9LttDVtPsNydeRW
 aZIKr2ijYEAE=
X-Developer-Key: i=jm5905938@gmail.com; a=openssh;
 fpr=SHA256:oSxqik6Pl1M8EjQW1QXKHoylm1jy0sguOWFFJlA9zf0
X-Rspamd-Queue-Id: 47E0E1A0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: o99cm7rm6ekzk48dwdfxq6xbecimpukd
X-HE-Tag: 1792154116-704986
X-HE-Meta: U2FsdGVkX1/9QOK4ECwhlUn0aflL8QgQvSY21NWu/1RvWEw6tcBNe9yjbIbaRvoCd0ZMrlfV14MySKN9pwG2kKEzOfnya4pcjm0Q4nfoVpzbzyhIStqcDfLLRKpCkqTLGvFWHI4Fh5304SU/LZ8Mb3ik8Rz+ULbskde1YF1OqGySQVOTSOifr3BLaMtnaeRcY7gqff1i3wm22zz0YKDe4g47WHy/K5RuptBHcYUkyEsEElH03bK3sS3jqWA7oZ6IDqcqROv7+SJgOhBb9kKbhz2LI3d4+1YvN6mcqe9Pt5gh3ZAhgbOTNN8aTh4fDexZvU51dMPeO9tNILOD3a5b5OkoAZyGWyhGXXM23RkD3fgSkQOHeOxEbwQj+yPRGfcOEl1eFpN3yUmHxr8uKcCJbKmAATE3us8sEh5/ZTQhcF8NSTVGiOi76e++mJl7Kl838tzgP31MunCTM0vBdBWfuzQ+Geral0kCl4BFDn5DC5g5/KQvsndLNEUQ0SfBYEPaKvLuttBTdWOoWk3OqODvRGfkr7lAyoQHU9d5YIrCYrOG+DAfeGV9opl8ZrjtEMQcxteMg8yOUDWLRZ6pcKjAIXvMwlD7MrsbnSnK5lb0DqPkvJdFn5T8RdpEMgrebKWKoljyjgLdGbVtH8qL/7JHiBpiex3c7c8y2MjI+Up9sSvrTrxiuYr3mDt2yRod1wVu6u/GOGJwVqk5+ylSCl/JD+vhhCIe+6A+AkWB0MgsKeoAhR7pau7w0AVXNqWi7hEd9n48Sw6cTVZMIXiXJoOk4XRR4ssEHOmtxleQ0yYH7krQknII8/2j/Di2KWmgHaBYMcLucIS9QXXiJp136JUQHbLW7wVK4zMvNYgcVgyc7D7ZvNu92AsBbuIJaSq5gI/zamp67DidM0Pamin4GahaMGOEXKYBCy2AWBaZuxxujSsCQOSMGXSSewluZy3xT5RSrnabP1m0CXLgj/w5rMy
 LyfF7MYR
 3EtNqjihqA+x3p9NeJB1aMLoTKAq0UORl1+gktHVnmlxdclcGVh+C4JWVhR92VGgdB/2JJnz+ZUnIb/pREBMIe7xTYSWcMloYB17NAb6GWn3qUvyWpHH5IgUMMGrAYe4qjYaAgqNClZYrrlIzNmbsYzvXNYNKbJwEgbCtyzfxl8WFTR7JneK51gXsutZfYi9yPH7bi+pybW7NKjpjkX0qjskj3T2+gl6uASgMeG0vXMqcBC1dnHoD51n/ynWYz2PC5GA3zMyy6MXa6qZhePg+EMxq74E3aWGh1D2Gv+e+Ztiserh+xQX0cpAeVrpHutOSt8kjhKuW7P/vq3COmsWBhtoQUyBHTJ7fAJiZ8hVraPzrUXwWdnpr9cdXJd9Dfvw9bRAZt6T+gxc69tPXCO+QPtQthA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Manuel,

A few suggestions from my view for you here :)

On Thu, 15 Oct 2026 10:06:23 +0200, Manuel Ebner wrote:

> @@ -30,12 +30,12 @@ guests could mitigate this problem.
> -DAMON_RECLAIM finds memory regions that didn't accessed for specific time
> +DAMON_RECLAIM finds memory regions that weren't accessed for specific time
>  duration and page out. To avoid it consuming too much CPU for the paging out

"weren't accessed" fixes the grammar, but "page out" still doesn't
agree with the subject. How about "DAMON_RECLAIM identifies memory
regions that have not been accessed for a specified period and
attempts to reclaim their pages.".

>  operation, a speed limit can be configured. Under the speed limit, it pages
> -out memory regions that didn't accessed longer time first. System
> +out memory regions that weren't accessed longer time first. System
>  administrators can also configure under what situation this scheme should

"weren't accessed longer time first" sounds a little strange to me.
Maybe "Within the configured speed limit, it prioritizes regions
that have been idle longer for reclamation." would read better?

> @@ -88,11 +88,11 @@ identifies the region as cold, and reclaims it.
>  sampling and aggregation intervals. The auto-tuning aims to capture meaningful
>  amount of access events in each DAMON-snapshot, while keeping the sampling
> -interval 5 milliseconds in minimum, and 10 seconds in maximum. Setting this as
> -``N`` disables the auto-tuning.
> +interval to 5 milliseconds in minimum, and to 10 seconds in maximum. Setting this
> +to ``N`` disables the auto-tuning.

Maybe "between 5 milliseconds and 10 seconds" would read more
naturally here.

> @@ -113,8 +113,8 @@ quota_sz
>  Limit of size of memory for the reclamation in bytes.
>
> -DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
> -window (quota_reset_interval_ms) and makes no more than this limit is tried.
> +DAMON_RECLAIM recordes the amount of memory which it tried to reclaim within a time
> +window (quota_reset_interval_ms) and stops when this memory limit is reached.

Agree with SJ that "charges" fits better here, since this is quota
accounting. 

> -While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
> +While keeping the caps set by other quotas, DAMON_RECLAIM automatically
>  increases and decreases the effective level of the quota aiming this level of
>  memory pressure is incurred.

Maybe "While respecting the limits imposed by other quotas," would
be another option I think.

Thanks,
Aveline


