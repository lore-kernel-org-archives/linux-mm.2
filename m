Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C36AD711D3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8306F6B0089; Thu, 18 Dec 2025 21:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECC96B008A; Thu, 18 Dec 2025 21:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700126B008C; Thu, 18 Dec 2025 21:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0E06B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:30:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF47913AD1E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:30:33 +0000 (UTC)
X-FDA: 84234641946.27.77F3ECC
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82252C000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:30:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oXLgjGWS;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766111430; a=rsa-sha256;
	cv=none;
	b=39mboozMZijGIamXCWAaXmhJJBT1f8HFeRxHbRRQL1v2aO3pRgH78XNcgon0rrgQF1gJyi
	ktZaHJx614U4PaoBeAdkdu0jq0e0Kbu70GyXF+OSrgKplwG/PIzpxgQF63SQhFOVi3TqIw
	Lp89fNA2jvTd9aguNiUCrMn0OttDYm8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oXLgjGWS;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766111430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkCvPZ82H60vrdm1+8FcykuYy724Kwg4Ti1zfuNLOq4=;
	b=MEnuU9AyNF9m/3N+hgos2dkOwI4dBCWzuATalxhwfzToCC2wA0eCBVilHJknGB4hN/IHK4
	1u/DMjOiQm3p3mE/3RIaZ4S/Oq+7ASGBqF8tMrKL2YT49jbvStkhNM0d/RsXjLTRBfYagF
	vDqp82jvAz5HuYgfkNeplriUVB0dH48=
Date: Thu, 18 Dec 2025 18:30:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766111423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkCvPZ82H60vrdm1+8FcykuYy724Kwg4Ti1zfuNLOq4=;
	b=oXLgjGWS0J6lAiQm1PnCBtu8DyNQVQ4Dxf5Iej/sGjV64gVaBVuVet/j6ZvnO8SeytflJ/
	C5tj6NWhJDOTyC9Je7ErR5bXdqGeoZKP9WCiHRCYRjpfCDvuPwC2txtz1OvWC+NMbcI+YS
	lTRKhj8C5SLqEPGbtokCHJlsbjnohEI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 10/28] writeback: prevent memory cgroup release in
 writeback module
Message-ID: <5e2l35gcurnfclqtyqycylpcferjsitwjoa6ixbp5u6fng4b52@gfdmi4elp75m>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <d2863fabba49a16572a84163e42cbce64aee27c9.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2863fabba49a16572a84163e42cbce64aee27c9.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 82252C000B
X-Rspamd-Server: rspam04
X-Stat-Signature: hwca6gsbz38pp63ppf16buptq5wz1ize
X-HE-Tag: 1766111430-507344
X-HE-Meta: U2FsdGVkX18h9taMllv+Ie4g3X+TumnZtAB10SYQRQRQwCAHmvLwKdcnQhK3RMp2QqyemB+RhyZMjO1A5JSxj+s0bfdhaipb0KwsTe9LRtvJvnSXx/RCesTzL7oLIpPUXqqZa6aQNYwn1PyX1MwmWy4EkRUOTTmLbDdsMbhKiQxbl/iMZE2gsf8m9Y6xL8ec0GtpY/DZPETOHrw1L3zphYsEgBLAUlLZPHogTZJ8FBnsd5/buIJsgljb9Z+U95u6Hw61S8OYCJqOE/Z6ggIVCsiu+B+hmfINeFgDOjj5p2Sfp7kJlsZ8/3l7RIYRu/Dt+b6dSxYJ3YzO5spyZo2NoRt5vRaY+mPX1a6qU33GAcYqFE7VPVMLA+oRMehq5itS0JT2r6xFSNbytgI/xCz0pzND3dN479yPU1HTzk1HHoN0AJ5CU2kfxcZKOJwEryWm2C6iHTxW9evmoELzDA6loCSMLP1syeCcFo1txSGYbbjFw4hfclo1Ckq1TprixccXzbGhxszDHHqh+szUq038x8+NpRyULWbG3e9Ds7y8FUK470Q/jlxa5Lj0AjwS9YESzIH1LcYZ67krKjwfG+d22ARE+MU3VtOXDT2ej2G/t6GkUxKxVJsaUU0TktneJNAPQoM4D7S7u8kRqjPxmpp2fHQ2WHEktJ7t+RQ1qY903BpHlLqEmQG3I2hbSKV0P7YIIzFPSNsIgut0XkSUV4XdUUheUN5hKDDrl0IOSByHo5VafcgspZmaRAUUbxBBG+t/Wx69zZ+ppTD8GiIuFN50DTXcxKEBHOwhzxFjM37W2WtFmVv2n2JAGPHX0p250IFbi39FrQQFEcPkfd0r2QktDjRqmsnGOkRBpYkBPOdGFpPJFDqwBR7ELpJHa+V7XZhOIdZ/7Tub7KTPt96Lf3rCbF08QocnIcuB5BwF5h7EAUyrjvfDvER4p693O6muPiLllTSGvWn7y+tUd8xsYVM
 LW0j8UHA
 7Hjs7re3bXjffWgu6zN2gFw/ugvwV1KvodNyFzoGgGcDQyb0v7EDaIs4f55PtTD9I67y/jknziJ8jm1uZ8gVsfNobkJggI9J0fYz+NGODVKj+tbdC9fdwvJXyUhkpKBx93873qN0z4VyhtTYKqllt17iQZB06MkYBviwxlHGRzemoNgETkfZB8j7fuUtcgdS7BTcyk5gR5JQERBcyH/pb4EpPtIWBZ8pJX6zm1H2A7SCrR797dzMQHN7IpWIvKGDgkjlO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:34PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the function get_mem_cgroup_css_from_folio()
> and the rcu read lock are employed to safeguard against the release
> of the memory cgroup.
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---

[...]

> @@ -1549,9 +1549,14 @@ static inline void mem_cgroup_track_foreign_dirty(struct folio *folio,
>  	if (mem_cgroup_disabled())
>  		return;
>  
> +	if (!folio_memcg_charged(folio))
> +		return;
> +
> +	rcu_read_lock();
>  	memcg = folio_memcg(folio);
> -	if (unlikely(memcg && &memcg->css != wb->memcg_css))
> +	if (unlikely(&memcg->css != wb->memcg_css))
>  		mem_cgroup_track_foreign_dirty_slowpath(folio, wb);

The slowpath in the name gave me a pause but it seems like it is safe to
be called within rcu lock.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

