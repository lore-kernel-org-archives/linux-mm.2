Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE676CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 19:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B006B008C; Thu, 15 Oct 2026 15:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02366B0092; Thu, 15 Oct 2026 15:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45286B0098; Thu, 15 Oct 2026 15:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70C516B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:11:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E254E14013D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:11:25 +0000 (UTC)
X-FDA: 85325804130.02.C612A78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4B61B4000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:11:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cOi0wl0w;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792091484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAUwP8uv+umPvOo9Qj4Nscuwt4gS+Jp3uOlXS5VCJX8=;
	b=XnVF/D0J3wrv/HDwqYDdgQTD/rcS/oYilQFbCK91dyJ/pyl7Yi/FRpLyONLBVX9Gw+Z86d
	yJ6dJCNIrWvJUdatyCNMRtLvQXm90DuoPHaSSdM+mLI2wzd8HUFIVJSYZg53N0dOLiK3Ld
	cfxGz2FyrNeh9npZG3ltuvuv4JdNQAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792091484;
	b=VoE9tCX4ghzjbGzw68s9lmm4dM+UD+sOxramay4k1T2aEW7plnLa/u2JAVhX2dFLLmimmJ
	R/au0W4XQsBZ0k9dMc/0CTivRm5rSQvZEmlw5+2ozBnaFYVYcgM0jM6c84Y4glilWvQhv1
	DYRb5YodcN0oGJOoSceZIMHuXGxm7aA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cOi0wl0w;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 793D660A7A;
	Thu, 15 Oct 2026 19:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8A11F000C4;
	Thu, 15 Oct 2026 19:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792091483;
	bh=SAUwP8uv+umPvOo9Qj4Nscuwt4gS+Jp3uOlXS5VCJX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cOi0wl0wIMf7h6fRzBGzvmfNVak4QfBXmz5UnHGQQ//LoBbqmk8ISLwwLjlNRe5Zs
	 GA+DIVBtyk2epQQzkS5TNPlbIs+JwXJKrmqRcEsBJSWfZtwEwp6uOhULQfYLjtyqt4
	 5KFgSQL9Dhu9YzqkojCN/j3wcVZQRzcNzEZZCuKeaA4OZVyM6vtQtE5Sek2XP1xDQo
	 mkYJ0zv8NUdXBgNONVQzRTD6VJVLkWBPUdxhdnHztVjO68F4vBJaRJUizOkps3jn4S
	 0PY3ZMjpwDIuyI2Bc9jmPKHvakp8HRDb918uC+aEDjli9MTrM19VmYHLO5mSfkiozk
	 53TZ4XwXpuMYg==
Date: Thu, 15 Oct 2026 20:11:21 +0100
From: Harry Yoo <harry@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
Message-ID: <atEkfmRFgXJCbJuK@thinkstation>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B61B4000C
X-Stat-Signature: jncnwr7ginx48485sjutoje4x6jshq9y
X-HE-Tag: 1792091484-137196
X-HE-Meta: U2FsdGVkX1/1w8etMZ1814XckJD/xNbx62R6hDIZoP06RhFSFu32fu4iI4DpovsaTaYfZuFpFDKRUvNp1CjWjE6gd/7tkQOXzP4PbexJIeA3ujnvIHEUG20A6YPRl9dkdP5Yg739nKFiRztcAvz3Iw6h2ztt5xgQUJws5N0uHu7B/6To4mTB5CSKHBm2qDqB4Olr9WNc84+Uz4P2zq1267pzrhS1oVg1JcXc0DqgtMJk9VMoC3MkR3aasxiOJwHvPNzOXWpiYunshfBc2JDvwANl8bIEefDwu6/fpkP1PL0GfAa7Va4+HVGTPU3dzSg5tiuHRKL55F6BUSM0gJLo5IoJ96OOmfeEaC4uGayjGfwD1h6hrF3UMU28+mTAdVcOlh+CVp03LXBNwxMqUrn7h9+yBHZ5eQ1zd1fFo+3HdajNRinD8jMY39WPSfqdnROepqkju9xrBSQmwo3iQHW4NhI8TdKoSrsh2xfJfsOgX6iRUf15OoPzojrmqMmdnImddIPBL2QatV9sT+QSXc0zMqlK1v7favHt2tF5ew+fd2OXvu3iyijDchaJQTEXOdukW8hhm93uhiEiHYzrSpCM2jf1wa/IyEtH7A2qGrtUeN1JqbI40bhtY6FjE7XIQS0Gd227/LJ/AonbZLbqtCci5X+rZbNj8ASp9oyXIAbxA7Jj8cWoSBJqR6wng/jgun+192FHZfJyQJ4M9OJfTq4cYoQbnwhanuONdvgLclkGBZG3fDpSnzbCnn0SWEg3k3RGCADYwX51m3l5AeKGaNnFY8wxQJDv43z79o5LgC2+05icS/ELNnZze0Oa0D99vXy05T2nfl4aU4OuUxyPZHZhBt+AqwiSWFviIU+vi0E8qb8j+jVIvClTxlnPZzVPYPXZ8Lkvu0q6Ctlv90P/LqxUN0OaY9e8ydX9K/0enmHCMmdKJMOyJpWgdwmb7lPj+bKJQZX2vuFjx4BiYciNWTj
 SYFzGgXq
 eN6hDtg0QU/nmeEF5opgGd1pHDIsknQb9xKzqWFBLVh3y81v4jAKSIMWJNSXiHS33ro8O1Rv7s9Kd1NKPiSKBcIPadQc/QFi4E9pez8oRYzNeiBHaOohZeooVtt59K6Zm1ITESs0RjklgWXL0meB/gKYUEIxp6Dx3itHlmeYK6YLw5kwtprma6Zp/sYgzduRlPtnAN9ch3nNbk504H3u7gsz0PGnyyadH4te5aVrLHqhhdGpQzLvdAMdZrsySzucQr+5sd/zMypT3wfW5wb5gXzcsh0J484LwmuDiryil39xGATRyFQw0rDopkgp6JVEWJRZEoWDVmfBKcGYQkDgX4Eh9YVTTWt6n4Zmd858/lLg6H9gg71ZQa+skTwnXdh2nzWaA+WhhboOvZM7ltPBHN3fezcwq7sxlBWS8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 02:15:52AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Add a helper that resolves a stable lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.
> 
> No functional change.
> 
> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

This new helper is doing the the same thing as what
get_non_dying_memcg_start/end() do.

>  include/linux/memcontrol.h | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 74110a324f9e..829ab776ab44 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
>  	spin_lock_irq(&lruvec->lru_lock);
>  }
>  
> +/**
> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> + * @folio: the folio
> + *
> + * Computes @folio's lruvec and walks up to the nearest live ancestor
> + * if the folio's memcg is dying.  Paired with folio_lruvec_live_put().
> + * The result may be stale: RCU keeps it alive but does not pin @folio
> + * to it.  That is fine as the counters are fixed up on reparenting.
> + *
> + * Return: the live lruvec, with rcu_read_lock held.
> + */
> +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
> +{
> +#ifdef CONFIG_MEMCG
> +	struct lruvec *lruvec;
> +	struct pglist_data *pgdat;
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	lruvec = folio_lruvec(folio);
> +	pgdat = lruvec_pgdat(lruvec);
> +	memcg = lruvec_memcg(lruvec);
> +	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> +		memcg = parent_mem_cgroup(memcg);
> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +	}
> +	return lruvec;
> +#else
> +	return folio_lruvec(folio);
> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_unlock();
> +#endif
> +}
> +
>  static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
>  {
>  #ifdef CONFIG_MEMCG
> 
> -- 
> 2.56.0

-- 
Cheers,
Harry / Hyeonggon

