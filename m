Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41160C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 00:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31BEC6B0088; Wed,  8 Jul 2026 20:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4866B008A; Wed,  8 Jul 2026 20:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3B96B008C; Wed,  8 Jul 2026 20:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECED96B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:09:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7487E1C81D6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:09:02 +0000 (UTC)
X-FDA: 84967302924.22.34BDF90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8BA6820007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:09:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IU+2A/49";
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783555740;
	b=3/izlrsEBuutBnszvuvijwhW5yGm5auSZgmKwCUGcsc014bVoieaAM629lLJcHkiwcfeg5
	cTVuU2wHG7xO4DEYg3zEhEgHQyJ4QtOfPA+zGV2kU3bosaKXiVkzN5wegJnP3XAMpVot68
	yIHAs1A5VRw9T2N+MtUV/ZFYj0GrlX4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IU+2A/49";
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783555740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6qdNRIjX7aZ1jq4fjXvPgUILxl3rxiATj8zxnk9rak=;
	b=i4ZbgiXyJDEkZGHTcp1V3SiqO0tjEX/SjSTBr+vPy0CHA/+uxOa/0S8PptZ8wk5FCfqwGh
	/oSfxWIJD0WAcQbXGgJX/3Z6g6QKw4GVf/ryoaBiCoDRMuJHoUh3yKoPUCM7tpn7DFQXAy
	+XSXVXPNHbErw5t8l682NWJ1keaHbKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6ADB343E0D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466031F00ACF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783555739;
	bh=H6qdNRIjX7aZ1jq4fjXvPgUILxl3rxiATj8zxnk9rak=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IU+2A/49NfH3933rrgKscZxWQdnBIj5jdvgRiTM1sqt1IsT+JU+6FseeBQOqxB6qg
	 Uiooecb1c1XuD4ceVq7FvfDoqv31EouregbegxOOEwDIZXx59QeFTvSVDBLYT/ztA2
	 Meec1LNrcE62DqbWvyZjsyeXqd2MsS98B3sG+jBHIebmoZod6sITLyrML4nkanNuj6
	 JljGxR/E5bd2ivhj0LGmIxNKOJ0JNVFP9v0za+1e2cQuEjan0F/dvbyZuqgdYMrmGw
	 rSLEJMWWOOfXQWa5yHkAn4EP+aVDM/UPT8dab/ZYukfGB4LQPRZsGI7gBcmy8xNjzm
	 YkBa4NiBdsOOg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15c7d22070so39025966b.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 17:08:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrelC64PM/c4CI2DtBkU+Xb6AQEHcroRYmgWx+MwxTwVsoFawcTfz11wwXeEtzrzDcPKZykGZ7tIQ==@kvack.org
X-Gm-Message-State: AOJu0YyOQ2PJbLNY+DU8VcgVHjBfhMjuAkUDQiS0kd06MHLpsAyZGExx
	w8KBSWjJi1j0aVOYDBi6KPTisQo2zC6pp3XDkJ31/zT0CTE9oFnB0ChnVFpelkYbZH2yTJBPvVJ
	mN7BsIFqj31d1czqxw+1FXDjzFAuKD+A=
X-Received: by 2002:a17:906:6b0b:b0:c12:34ed:da0a with SMTP id
 a640c23a62f3a-c15ce150e9dmr180444966b.54.1783555738202; Wed, 08 Jul 2026
 17:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org> <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org> <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
 <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
In-Reply-To: <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 8 Jul 2026 17:08:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
X-Gm-Features: AVVi8CfY1wrdcTB_0TNW0MyU_zzXY8duBA3ybUloUzm-ecxeFI60iNweEwK80g4
Message-ID: <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Yunzhao Li <yunzhao@cloudflare.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8BA6820007
X-Stat-Signature: nm8om6cd61z7gjebbqap3bhkthpa35jq
X-HE-Tag: 1783555740-845074
X-HE-Meta: U2FsdGVkX1+VJiH/zWOBUKDdNs7VRykkoiD0J8XTDJViY7q+GDHoIzn80+qFQkkvagZMs0tBvcNxdTVctL68AimKTpDpV4p1cK3HM1piEFajMUNVS5dXtWzhyzQ2eJwSgoklbk/9FL3Fyq8R56RYcxjB73YryAyYbkpGxfp86F+Dxzif8UvPqZPnxJQhZwlvYOkvaxYHFFqVk71HCqc/HdluBqL1XlZt3lowcc9UECwNwvad53wmulq4r6iFDEGyXRU/nq3K+FfU9xpmnVfwkpJqELhwVX756PFYv57GDs0/9XirfqrWHUxm9IdJvVlYjGMGqJZSlF4ddY4BB/2AtKd5J5KrYO+ZNiorInxNPIexfOJs3aZaTjOoSBIllkmEE+GSf8kp86u6Ge480JaBIMiOysVqHYGnTnsabj+v8emb3icf2rL8+6F+XUhGAbuRJ3wAz8uMcBZxazJSCeFoQFQORxYTyLNk5eXDwm6ivqwIak9XPMTzSXRuj4YbjEsZler9EZIhC/xMVZ1OrP0hyxvXhYy2n5RvUMAU4j20tUl8j5APg3ezdiZzCH7n/9R3ImL5WHNNFTDSh32apRrD2CEH/9mo69Fd3UVcTMQkf62rqDijEZHnJpVBOpPNzH3Ai5OaLzQKkB/PEMAuFzA6CpEiSgI9ysYb21VI0KDUAq+Z/7lpOHrzvEo1varnL30R8FE8JoyzmdGZzVxNyBq/K7VcThtardt8uNlY28+PrFP7hnu4FFUtfGt8CRQWKqIGf6VcA6hmihSUYXQG1Mk8JmAsHyQF4IzNSi1MdllxSqf8gcNgf2aSnD6di5JacHl5dMrrLMv6kahpvd5CgjjbjEnXamx/QKOZj98SbLJD5NTtQOBoaHLHpxJqJ07bMfBozFHg6TEcS+pCaeYBfRrYAty+oIcEOrr9UuXc7HFsuk6PEJwCwXi9I+sqWh0wVPcF0VtMGj4fM7wVFYIgZy7
 cwSHPhY4
 7MjZpajDm6dqzhgvI2trrymV8PKGd76uc/PgaDwJxJw47dQ0WZJ3oLNohqikXIWyt507hXH1/YPw/5XoO8LJcB6sdP3m1S3p5c2jiDzkEmzXk8Y+fZrtKckY30cztFn+uJULfugan+j4JI3WZ4ur7+P0cMwvgYsZKW/QL4Q5soPWtyGx/+a3iGu6onFGB7KuX98ybQ6qCRx+vfarc/69jvq/VuF2Ezwrsibz5Ul7ZfshwlUF0mFe2JtiA4+WB6LEMLx/zkERnABHjqzreZXbiwjerN8nvVe8DcFpvr1wD3gQFow+018kNNCagOIQwuL7rHf0E6pR7ews3Fgoeou+fX/WYT2Y2/baWmreNXXaSXCjuGkPii/fk9x+2hWp6jA3OMOff
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 3:16=E2=80=AFPM Yunzhao Li <yunzhao@cloudflare.com> =
wrote:
>
> > What disadvantages are you running into with disabling the shrinker?
>
> We lose about 16 GiB of MemAvailable per machine. We A/B'd this on
> the same hardware (EPYC 9684X, 96c/12 NUMA, 384 GiB), same workload:
>
>   shrinker=3DY: MemAvailable ~75 GiB
>   shrinker=3DN: MemAvailable ~59 GiB
>
> Based on my reading of the code, the zswap pool's zsmalloc pages
> aren't on any LRU list, so kswapd can only reach them through the
> shrinker. With shrinker=3DN the pool just grows until store-time
> rejection or swapin frees entries.

Thanks for sharing the data, it's actually good to know that the
shrinker is resulting in significant savings. Are you observing any
performance impact when enabling it (e.g. higher fault latencies)?

