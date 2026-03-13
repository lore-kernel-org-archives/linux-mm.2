Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0841F103E305
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E826B008A; Fri, 13 Mar 2026 11:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F766B008C; Fri, 13 Mar 2026 11:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332106B0092; Fri, 13 Mar 2026 11:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 210156B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:34:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8E7C1601E8
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:34:38 +0000 (UTC)
X-FDA: 84541437036.08.22E2DEB
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id F112410001B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:34:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e9wDM/7Y";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773416077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxJi/zSl5l+Hb0RVk/iR14eLBTshpKrTciXowhZG1gg=;
	b=5cMdf1IUrsEjgmf3CE12Ja+aRXlJ8HdjtQ6Xp9mUC4Jpow0Ix0kjsFbWgDhzvQlvFnAOjK
	omYCoK56tHjgUj/8l61uucRWxuhWpx91nceT+0VCVNi6qi+YeFq3qt9D15gx/svNYf0nOV
	EcpufdwSymJ60VwOXWoJUlOg1YqeYLs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e9wDM/7Y";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773416077; a=rsa-sha256;
	cv=none;
	b=nNbswwjmH25ml+BGnClLJxzgccuAqW+vJyuRbvKm5R2+4gtgVwf7y0jSuna3kqnQL/9TkW
	j5thfTqN9tJIYiY5rCXIE0ygcCpYUlK9zUqK2PwJ7fcXjHc24gEyYhQeEY1/EuqSJTP6hx
	dG/3k83/FQeA9KBAesbT7rIS1uQKPmI=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d75e74f5adso2335618a34.3
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773416076; x=1774020876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxJi/zSl5l+Hb0RVk/iR14eLBTshpKrTciXowhZG1gg=;
        b=e9wDM/7YAobmE2DOtw1CDXlShQifzgPhBm2mQ4KnXos3x3rn0WQellsEdaBuJhhGaf
         cVnRCNBrjFABYDa6CVFeQy49pnoCLV9OjE0/IqqGT5kJ2AFek8LVBGCPNZQyJifGUyOA
         T1dSATcsPFrJYy1RmEDgQfMEgg5arMXLiIpJvoY4Ihlsmzbfh0YR3E3xrQtAgRxryrgz
         NnrhyviPoAIhjeGibgOGLQsKifeLnXVXTi8ni2TkWUqkW/GNUsryVFp03+YFWUIA6sfT
         nAs5CwLwCT3306I4gm0030axp3JnWc1Vtvay3Cv5fYz7xmnWImfwBaBY1cQzZyo5MIiP
         bvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773416076; x=1774020876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qxJi/zSl5l+Hb0RVk/iR14eLBTshpKrTciXowhZG1gg=;
        b=BqSofZ65O0f8rost1wWvlN6g7QlOrST3BZ+0s7trP72XVmpOHpABwf3wte6SbrTS4H
         osZLwvyooxExlKtMAfQ+tpr2wqJ9iGi12Nl7x0F7mDNll8u9IFdslgi4FtmcM+UHTckn
         XJKi5n9Kv/Q0xO8LLJCgTZx3eRiNDwdj051M5g2eCdamDLv8nisbL3hS2hicCxBK2qeQ
         iu6lkEMizO42DQi1sYftQT/Hfld+G8rsAfDxWAjvtBONNvvTYW9DQGXw78u48j4zMAAE
         uhsvPITqq6MsW1KETx+PYjCuBITD9qzDP+cEOq6MS8to+XvHaqkZorHLwrDZpMjA2P3k
         Y0lg==
X-Forwarded-Encrypted: i=1; AJvYcCVI80fVDUKs0vnK70Mq5HLjxuJ8aQIg/FF0SGLtznS7GDJUCTfzM/vf2tOLBJde9GSuVXC2TnLaaQ==@kvack.org
X-Gm-Message-State: AOJu0YxWE+C90OSx/xsNxQI3Wjm0nNkGzqv5JoANiy+/DaA8RYgbOEj2
	A2OI8gpQB3HEj5a2aGoSrTZnW607XjX4Dipqa1ufxG9n7QEW7XoY7kTV
X-Gm-Gg: ATEYQzzHMr31UHcu8jCdoZCv9Pf1DAFIgPYAQ+K5BmdhxxtZFuQPxrU4HX33E41/r3Y
	oIDp2lHSI+eexgkkvyEQBY435uj6ZZhsRLkP0VnJf6xeE12Udhl4F5tpWCmS1+1iyFS5DPelJKT
	PhsvyNXd7Mb8gnq6EWlN2ufPZzDRV+cKelgVeJJJQwx88rn8PdKXOBIYhIIJtZJq5Hlq8l/cEMj
	EuVC9thMaaH4Z/ItRF+51VdADugt8i5RCjG0Q1wyknOZl0kURBO2r41YkuHGynFx1aYpM3hUxtc
	V4H9MobOvDDGTSyhlariPt5PaoyZZ8OAvOV3OaNtepWHGbdhEMPn/UtWRRd0NRN2rOurVlmxFRb
	O7H/2kt/dWoeuXHt8v7SKNysPJOsl2OXh/AO2Z2n3SP3bPRY39g+sM6BPJ0q3bBzcxPLoWdYwge
	tNVKqEXvc8vbTBjuYddmg6jA==
X-Received: by 2002:a05:6830:6a11:b0:7d7:5d69:819d with SMTP id 46e09a7af769-7d782619ed7mr2747874a34.34.1773416075930;
        Fri, 13 Mar 2026 08:34:35 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5a::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae90586sm7005201a34.22.2026.03.13.08.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 08:34:35 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 07/11] mm/zsmalloc, zswap: Handle objcg charging and lifetime in zsmalloc
Date: Fri, 13 Mar 2026 08:34:33 -0700
Message-ID: <20260313153434.4074128-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <abMzKa27khxDLO_D@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F112410001B
X-Rspamd-Server: rspam07
X-Stat-Signature: chf8e73jdoukmjnwo8faq1u8zdn1ozaa
X-Rspam-User: 
X-HE-Tag: 1773416076-874416
X-HE-Meta: U2FsdGVkX19LnJ8iqJcJRHk1Ro6QCiLsglJqtZxHu3qy8/Uh1mLppgsAQ1CK8W2gWba5WIdDjBMoY7yuY0Rrm/4YqD/8m8LFkeVwzuozYMkj9jTPxXePIhru8Xu+Rrj+t8lrfnQzidfRpZyEJ9iet94ARSXjkKXg0DNQeclFwfojRlN+wzUIDp0x8dymflBlQeXYU5T2JXg9Sm0ZToLaHvO+U2bmptjfx7WvU+hE0MAvc/bdggG0uwOetf8vnPshJHOzWbzdDJcK2yKVSE9b7M72BAzQXg1FLjJMdoDm8Nv4bVoGgrraYn8+Rqn2SiPGMC9/fHnSHm27Gku4YmvpAiaObF0idwaFqMyBbAcLsdHP65trwOxiVcGcVWjhghFcMKppC4MQmpxmjJLGTydSY2ynQ4+yW2HmIj1usyCfUZHSAgNp3DWfEW++CynZsPYfdIw8uNGd54oJpx2Q87/2gj4IKKqrYQCfIjd/d22PduOTTOvnDK89UUbsMgwn1hbN6fImzpbJrw3Yx2zrv8ALFKES2+DctfG3Nbf6fWnUnVEIRXFV+hAR8LbzdO71su0GK46L+scS4KWz0JlK+KVqdV/rymdzbPz8SD22Lq++0C7CKS8PiGB+Bf7NLh+p/OYl11V+bosfwuFhixQe9NseE8OZZQ16ukE36VdlPtPAYFPuiBmIlJndRlWeUYrs2f2GdUnT3zYw0YQ/sClt3lk8VIqgyMXrHaUUVpvreWu2UulfGYS6YOX7HHZIjKVi6Nky8PBpP+zYyNPR4Pef/EMdXJXFjg4cOeM0RbQfpUc4oGJA8kfT8d1BZyhPyfuzrEiToF7Kg1YKlAo6gOKHnFi7oQW36Hq8rOHiMRB2AXqPwGPPq+vtvUVpFFM23vD5q/ftPDLNYmxIZKEqeyGo2OALrHp6i0YfihcfcdghrTSCENoSFdU+BeFffbZuFCcQbqK09M8ljFpgIKlHbwDMkvZ
 3PQZcmCY
 MWJFtyTs05jsQx+UR4cSXx43FrQzS2jBR6QhOa1ClJhapoQf2OOVxMcJwq+quCYLXCM3V6K+NklFzxuTo2dV5TLCQVZnlH2JtX9vzz50BlwdACtc7j0LX6QexC9HWVBW6QzDvk1SbTyVnuMS54PklyofrEfB+tTX3J5mfczSCKnP/khN2+AIGekZEYNVU449VE78tEHXyWzcOc4h+DRxQAYIw5P7YybIycYrd1HdT3xUm+4KD9zJBmihZQF8VswGkdwsrf9Omoyuvo65OiP2grFKjMg9bM2DxIadptxTNjrB3i4fTsxvvyERDVEYuenruEdZ3Ds7N/cmkNBNxCxw9l/75jR8CnmXZ/1qqttHWgRn7z0ozpoHRZkimlU3BvbeRXtLoX7sz1cfH+a1XvAXkMyv+HM9h2mzU6x9AOvGApb0rLaiURzWnEzHLSSq19+QKaj85CQQJI+RBrElEsQL3wGGCYL+czDQZnsx2KsCUTATOvU7rdF6wn6T7WSVvDG1ZiKVqixMmceyKMMbhqNTwaMdklPKdrCkdzqDCwST9/rAxZxdVucghZAq+hKMMAz49ahtO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 17:42:01 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Wed, Mar 11, 2026 at 12:51:44PM -0700, Joshua Hahn wrote:
> > @@ -1244,6 +1297,8 @@ void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> >  	if (objcg) {
> >  		WARN_ON_ONCE(!pool->memcg_aware);
> >  		zspage->objcgs[obj_idx] = objcg;
> > +		obj_cgroup_get(objcg);
> > +		zs_charge_objcg(pool, objcg, class->size);
> >  	}
> >  
> >  	if (!ZsHugePage(zspage))

Hello Johannes, thank you for your review!

> Note that the obj_cgroup_get() reference is for the pointer, not the
> charge. I think it all comes out right in the end, but it's a bit
> confusing to follow and verify through the series.

Thank you for pointing that out. I'll try to make it more explicit via
the placement.

> IOW, it's better move that obj_cgroup_get() when you add and store
> zspage->objcgs[]. If zswap stil has a reference at that point in the
> series, then it's fine for there to be two separate obj_cgroup_get()
> as well, with later patches deleting the zswap one when its
> entry->objcg pointer disappears.

Sounds good with me. Maybe for the code block above I just move it one
line up so that it happens before the zspage->objcgs set and
make it more obvious that it's associated with setting the objcg
pointer and not with the charge?

And for the freeing section, putting after we set the pointer to
NULL could be more obvious?

> > @@ -711,10 +711,6 @@ static void zswap_entry_free(struct zswap_entry *entry)
> >  	zswap_lru_del(&zswap_list_lru, entry, objcg);
> >  	zs_free(entry->pool->zs_pool, entry->handle);
> >  	zswap_pool_put(entry->pool);
> > -	if (objcg) {
> > -		obj_cgroup_uncharge_zswap(objcg, entry->length);
> > -		obj_cgroup_put(objcg);
> > -	}
> >  	if (entry->length == PAGE_SIZE)
> >  		atomic_long_dec(&zswap_stored_incompressible_pages);
> >  	zswap_entry_cache_free(entry);
> 
> [ I can see that this was misleading. It was really getting a
>   reference for the entry->objcg = objcg a few lines down, hitching a
>   ride on that existing `if (objcg)`. ]

Thank you for the clarification! I hope you have a great day : -)
Joshua

