Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD1C103D926
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49DAC6B015A; Wed, 18 Mar 2026 06:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474C16B015C; Wed, 18 Mar 2026 06:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C376B015D; Wed, 18 Mar 2026 06:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26ECB6B015A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:01:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1A5B13B590
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:01:38 +0000 (UTC)
X-FDA: 84558741876.05.D15B083
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id D76104000E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:01:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eIdZvx5n;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773828097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30lcLe83ZfeeJjPOw57FdUnRLS2QbPrl5sgOSEvO6uE=;
	b=5Xr5vpKJtIzBIN86ORfCr2KYe7+lg4lIkSBa2jcM6Wq5mOrtUc+l+u4bilNQb4OXTBKayg
	mwBsDoklPkNe7T+7FnN5WDmfoRVGD7gRP8qmWIM+CUOZd+OtLJNMbdpHS9fMowMmKF87iT
	1/+pZhSy8bbaokPf4kK5x3Y62sRuGJg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eIdZvx5n;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773828097; a=rsa-sha256;
	cv=none;
	b=JvJBwMkXAI9d2OiK92/aEl94D/9QLVBFzfX0OdCeHtKHA++43MqxbWzTLQfaD6eoPltAiu
	1lEmoCEp7MDVDDgN/JMkiXWxK59VvLWEtuOHaR/lyUxn48Gbwd+VP+aUIQghgSJJPKtqNZ
	JuuFxHuOeGHAfBNzrZZXyyouOjYJIEs=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4852afd42ceso56774885e9.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773828095; x=1774432895; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=30lcLe83ZfeeJjPOw57FdUnRLS2QbPrl5sgOSEvO6uE=;
        b=eIdZvx5n4xeqnapU8uLPDTOVb/xM0jyz19OrpxKPI4Sv8ZNwEW+H7sGUZ1DyerBpEs
         YWoFiOgbXaJQwgh/4zYzdlPbGJXJZmBBeAegujR2dQ7yYGuQ4f5W/IytIYNSN0XL0zF1
         we/rpJpYWpi7PscHT1/NsysHXO6xKg9oo+93hncO8OLWrm0iH8a7/RB8G0APigv0/oQv
         zgrNOoR5j14eaNuVpxq0aJdCBFUQeI7sOJvKGIIZNA2tuLLvFTD6lZBNczII3D9mngI5
         fGTLxlzAh81RqczReY0q1pJNxnK0HLqMkyPTOzh0ACIzPNl6TdfigPuvKqtvL3SDzmHH
         Q6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773828095; x=1774432895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30lcLe83ZfeeJjPOw57FdUnRLS2QbPrl5sgOSEvO6uE=;
        b=FkEQZ+OdP7+gYlgF8ivtvoCkuxG4u7pbh+yArEGQb+arZt44oc+Rj3MIIv/i08e8mD
         ZBp3l3Nsz5RvSyl8IvWz+vNq84Mgp9JdwiR3HIAl8l5cauy4Ja3CijeO/ywY1umlGNXS
         UUuqn5RkdDxaLflHWnmuRAhov43757qqwIGG3KkJLz7MxPxS0Nq2a6J6ErKOswQSF9ih
         1Tr9fnTi8TQLwX5d/Y/6cIVD5L4pRxlarpgWwuwM+91hd0P3maBZ+qrEOADtJ/craNLT
         etKn6aWsRrITGbu92KVocnZlNDVjHQishZ0ODKII3ropdzHpuAbA0hLCN64jZGTulMCa
         ANWA==
X-Forwarded-Encrypted: i=1; AJvYcCVnEHY+sE3kzopOUVBxJzpKlNA+VAAnYjd5bsLOAebQSADMJo2OD/gu0tV8IMXtED0WLuERySWvkg==@kvack.org
X-Gm-Message-State: AOJu0YxMhxdkzp/6tRjM8yEUWESAuW02vDqBOXXb6V5uoygvQGdvnkp/
	Lu5NqKAKK2omygrHrk32wsvrNCXz2K4lx0aX4uNqR4vC0mAOZYY33Biml9vlFJ4yd2s=
X-Gm-Gg: ATEYQzx3686J+8jD3H5gnUIs7bycwATTOZMO3VqD3TnamzJgUx//oWx1mMA1h3KKJsp
	utb/S+7WjvIql1TDBb5DeLQPRht7d0Yn04T7HdSEO1015zeU6eAPgiRSDQ6a9i0u0tba7coHyvT
	brpm3xOHtYGL/LGcccTLp5HUtkIWYiaxyJzUrlOLFmCHs9Ptfd4bQ0dBlJ0LhsIjfymrOpLT9PC
	4gf12WadxirvT2n8HjZD4B7DdxpC8yGHfc9Fj45xFguJH1rGT62+3zSQDydlI1gHd4uVcK69ggY
	QIWNaT7ZmkZati/O7azg7ye7/KZezmS9w3UlzmOr8Xsye5kUlUSmL+XxO+4HB0h7RreSZj/kxdO
	uEdE/lPHC7Hp0+6Yy6eSXeSXXM0pYIpADfxOtNg25n3K6e/RjogJ2PHJMijp7nmhmy0uy32tXLo
	UV9OMiqkxD7Lh/DJrtic+BUsmfM5RgL3u9s7Es
X-Received: by 2002:a05:600c:4fc4:b0:485:3b00:f92e with SMTP id 5b1f17b1804b1-486f441bc46mr42711335e9.2.1773828095163;
        Wed, 18 Mar 2026 03:01:35 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f5e162d7sm10843415e9.33.2026.03.18.03.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 03:01:34 -0700 (PDT)
Date: Wed, 18 Mar 2026 11:01:30 +0100
From: Michal Hocko <mhocko@suse.com>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] mm: add memory.compact_unevictable_allowed cgroup
 attribute
Message-ID: <abp3-iJbazCpygIm@tiehlicka>
References: <20260317100058.2316997-1-d-tatianin@yandex-team.ru>
 <20260317121736.f73a828de2a989d1a07efea1@linux-foundation.org>
 <3db237d0-1ee8-44b7-a356-f3015173f7c2@yandex-team.ru>
 <abphjNOYaNslTA90@tiehlicka>
 <7ca9876c-f3fa-441c-9a21-ae0ee5523318@yandex-team.ru>
 <abpue_k_9mjQAP6X@tiehlicka>
 <73322279-c6f8-4319-827b-938c20c96b9b@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73322279-c6f8-4319-827b-938c20c96b9b@yandex-team.ru>
X-Rspamd-Queue-Id: D76104000E
X-Rspamd-Server: rspam07
X-Stat-Signature: mam7zofzjummk7qbqqnr5igjadabwqns
X-Rspam-User: 
X-HE-Tag: 1773828096-6264
X-HE-Meta: U2FsdGVkX19pO7uPfQuLWUVUsCbycBrFxRTyP38M9S92DpD4TAAW8/qeW7ZX5U52DTDftXbiluP/4lbgRttfYXKVhPxsybHaOhmSyFg/zv6+J0YsaCnlvwHGY1r32XilXnFbTHD6W6SfVrKc6BDaCZqNXkUgjqbb0SKvoik+Fnq+mG3hWoRhDTxMMOLiDATPBxLplVJrsbe3XhoCHlaP1aVSUSMqmcuUR8TQ9S8ipuJCwQdLXP3ffgtqIuTqYHdM0Zuvg0rVu9PdeqORWcFnIa4cNyJg0SnxEXSp2W761jMz1qLj4QeJb68K7vVKBzqw2licIJKeOBvN9qMtMHDly1ucuBSJaLcthtZJEwO/NviTiyOc0KZOu7UKC45C+Qod0g18GJrnPK23GAl0fQHq63gffKC5TOG1oG6vtUDbZEyxLhab8oEDS3HyhB+gTXtiAAsJpky0Ysu8nDABLfho/6Qn7iUk5ZW68wp4KogN50UKPx7fRZb4xPoKnDRVXn0Xq5eXYW9ZGYheB22Rjc7xrCgQUomoGvAu68ujlZxDK3JcFePKZLsg5QM5IP748HUJao8l9dVd4nvz95nnUuuzOMYkhp7T2ZbtlgY5A9ShI6NQ2nGHpAnIBqmmVH9/aSKvICfAAaaFlIm24kG3ywou6yt4Vd89hyXMZ6OQxAREwr/w6zDR+td5cr03a5haNrUjXkafBSC955vXOnROQWv9chU0sQ+HI4T0ktShc4Uijsyra2adDizsTNQwIOdeZF+2LPXTw1wtzT4QVmGGIpQJT2y2d6ixjjPtlVKfDIVU0jMQbYCtYHXyrF46HG3po8dk/Xi44R4qHnBnhPnhoeK5sDdVwVpicUF6BzmJwWpAk8kTmNq7KligNP589D/eqAmNb421I5Rmu/zv0NDZXIJwK3u8GqfHhxVL7L78Zw70MwDVehoAjaKMmLQQ7qIDLNDeBWEz4+kCp+9EiWnOw9X
 nN65ABTD
 KEN39kT8dglHm2gEK3lwejLqWtWkrDaKguvCMHGHS8vBu5nnJC7dfXjsChjHlKdQ3TdSEdxE1Ibfyo0azRN8GayTCLC47lxqPiYvZsvl6TjtD01+gIGEhb7g/HYaS5N/tB/N8OEtuOY33w51pv16KkeA7KaWg2bk5Hvv6FxzlowlcdmVlp/WW8z5Wwczog3tNKjq9WOEYZb9zzc4hZljREabYl93UFDXIMAEEXvzi7LkdldEZOEFXHvN834CpowB04BY0/O1+8LXKSbuuWVvLhl7jUvPyLB85k2H39T4p9y0gDL2RGkhrsW4y1FGltaY7SPVE9T0l8+qiZ9RrY5+bKTEU3dJYZWqG+MxWeIEYQbOBA+5upvHgCxNbZpykqFRz/EKQti2b2861nYfAjsRyjvuHAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 18-03-26 12:25:17, Daniil Tatianin wrote:
> 
> On 3/18/26 12:20 PM, Michal Hocko wrote:
[...]
> > Shouldn't those use mlock?
> 
> Absolutely, mlock is required to mark a folio as unevictable. Note that
> unevictable folios are still
> perfectly eligible for compaction. This new property makes it so a cgroup
> can say whether its
> unevictable pages should be compacted (same as the global
> compact_unevictable_allowed sysctl).

If the mlock is already used then why do we need a per memcg control as
well? Do we have different classes of mlocked pages some with acceptable
compaction while others without?

-- 
Michal Hocko
SUSE Labs

