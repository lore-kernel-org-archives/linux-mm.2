Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 642A8C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 23:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EAB36B007B; Thu, 23 Jul 2026 19:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B4C6B0088; Thu, 23 Jul 2026 19:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2336B008A; Thu, 23 Jul 2026 19:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD1836B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:58:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 494DE160226
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:58:09 +0000 (UTC)
X-FDA: 85021707498.03.96C8672
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4D900140008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:58:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ijx0TLq7;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784851087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avvPm+MSiYqhBmDj/gEoTUbsHIPoE2kqbnWnOuNf/hU=;
	b=uOxcIicoIfvlTAArNOppeE1rQDJb5GHx6Rs8CFJQXLCUaRe+dqqAfV57U2UNFT/12p/I5N
	LVjH0v7+ux4S6uowQFXvj7HRFRnY6i5zvdK9quA55upc/ySIaUJcAYsrFKx6+f/Nt5NGb3
	y4+psYuevslUzRrd5sP34kvBCJZDfi8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784851087;
	b=A0F8LRqUb6aiseteNL+ibJ4qvPOLf0J8NgFhuUVO7FpzPDm53LnUGo+ZfS3K0Ntw+wkD9S
	9Jt+4YZHpSDqh4U4+EaP+U1gLaT/sdkATaY5cEQMxMZp+gWEu1aSruOfDkTdHPjQY/ej6t
	HF7/rBG/jKY1EfJzLH9pEjf8mLTOwew=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ijx0TLq7;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53127600AA;
	Thu, 23 Jul 2026 23:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF321F000E9;
	Thu, 23 Jul 2026 23:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784851085;
	bh=avvPm+MSiYqhBmDj/gEoTUbsHIPoE2kqbnWnOuNf/hU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ijx0TLq7arHCpHcGPuERlv98vZmIlAej1Bt/vkO6kJd/dZ0YlYelLSXztDWM92Lcs
	 xnaUOnm5J4mha3vCaQwyLXPYREQQZy0pTX9r7Jwm0IERkJfmyvodXXcgokUttZRuER
	 7VxUIas/CSdoeTgt3LTIKdPuRV5BybBVhRfV4UDk=
Date: Thu, 23 Jul 2026 16:58:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Yu Zhao
 <yuzhao@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] mm/mglru: fix memcg protection for global proactive
 reclaim
Message-Id: <20260723165804.f4899595c0523bb16af292fd@linux-foundation.org>
In-Reply-To: <20260723130559.2343690-1-ridong.chen@linux.dev>
References: <20260723130559.2343690-1-ridong.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4D900140008
X-Stat-Signature: t4u8owu65bdb5cz8nnx4utidpz9c6qgp
X-Rspam-User: 
X-HE-Tag: 1784851087-526635
X-HE-Meta: U2FsdGVkX19aKq8oEgixg2PK0sGaoCi6aERDiHxqzcY5afPQSsoy5okjK42I6IaDoY+4kjKd+e3v/maOGbg9sKV0tlp+riDLeXW2lcLl9H5s+oeZ2qwYsy07tYhT7YtphH4AROhAr+fEAfLHZGD2a3+a1xCJNh85J9JrwnVYuST9GP04Cx4RghoJaOjOo+cIPJGDXzGerCGbG3Kk61vZS3df9nyVpFXQppHpLcCYILwiAlgL8u4sMOWkgDdLL6SMxVUd6LK03SEIYTgKCuYMtPsnhei9ikFR1OuT/nDnzo1/QgmDSH2gmvDphmX4NZkFeYulykodAaLFeaXQ3dpBMTMRG+e9MweWpMVTYscqg3We6L4tLmSZFgIXZc17A/F8ox8tvXovgU19QyJt29yNFg71L9Vn8Llvmj0b5v3YVvZsOMQNaPpkM4V9c8Vi/FSf15WvqROCcmbZsG8zNg5y2yj3meKAidX+WzEqpe2EchFXmzUqKy5h5DiXqif1FOO3zpIkDufEZwuUcp16CM6W+uWasnBGYEEJf8usrBjrcmPMHB7pws7dYlxHfVEEiqALF0zNRA/78YKUWjHSdAAblt9jbopgREprN2TjXyoey+2eeL/u5ztJKYcL15wIKpKV/sYYA3vwsgVUqaTduV7tcp5jdj9WX2zFF2VynPz/pHeChXsn3SpB3WBWCywYs+NN77u2iu2xGYr5kfmY7yAImT6aOy7mE/XaKHsmV4wFfYyNUDDwTUZ3ZTn9hBvHExAEBRHuX28mo1L5ACfkIbcmVslsfpIiHUObIwqGG5vcjwTcEztS+LWO1mgZOdxbzOnOfsM538hk2mndUT0LxLcROTmAgLmTnLjRoFbQLqGenr/xRb50Fg8o496kpjKsAYLXQhgxHRCDClLC/9n5vpEkgK7b+SvrmusCMmvH0FFiQs4BRrUoPC2if7hYQJRjeMjTsXvi+tq3mFbyE/g+p/e
 9HEofc41
 1G5fhLmA7gptVPtqSm92D3Ozx/cXIqwb6vopceC8rtTFWXY1ON+BGthS9m77Agl5UJcDRGLmHNhlStXtOOdDnZGLn1mbbzIKYsBrQdF8KQ9ORilztQ/BNXvGZerv++675JwTzCNhb+xhHaA5RZpc4DRQs38GU/+kttoAgO1fvH0auXzYUBJ3DeJ1uV4texA+F0hG56H1R2ffR5RqwMg0h/g+BMq6Uw6MUgR/WGATD7E+hk0aQZIvkPNEoCaIvtrGnk3d0GvRCSiZi/MGUIL9tIflgYuSBIT9K5LPqOhS4Aasd8NAOdC6fqTmQ5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 21:05:59 +0800 Ridong <ridong.chen@linux.dev> wrote:

> memory.min/low is silently bypassed for MGLRU during global proactive
> reclaim (writing to the root memory.reclaim). It can be reproduced as
> follows:
> 
> ...
> 
> Factor the tree traversal out into update_memcg_protection() and call
> it from lru_gen_shrink_node() for the non-kswapd path, so the protection
> is computed before shrinking. kswapd keeps computing it in
> lru_gen_age_node(), which also needs it for the min_ttl OOM check.
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")

Do we want cc:stable on this fix?

Sashiko said a couple of things - the memcg ref leak looks real:
	https://sashiko.dev/#/patchset/20260723130559.2343690-1-ridong.chen@linux.dev


