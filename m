Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B866010ED658
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E736B009E; Fri, 27 Mar 2026 06:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046556B009F; Fri, 27 Mar 2026 06:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5936B00A0; Fri, 27 Mar 2026 06:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB5866B009E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:22:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85E4D1A081F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:22:39 +0000 (UTC)
X-FDA: 84591454038.07.C1FCA02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C47B4140002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:22:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzR3ABml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774606957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/ikqX779t7plkWSLQzUT0uIDwmFYDA0G9LeoAGCDBk=;
	b=MVSMF2XF6D6CwTTJjtZX+JeOwoR7KLNff/L8agco49IP3m6uXRcSFKmcTDToxdNIb2/G8K
	ozW6Fy/+3koruGsrrgthn6c9IFY3zokSGJMpMhzr8HV4RWaowdnAiY1Q4vPLigX+okpvBh
	+meoT1k8DeTRnR1soFfusU+FHlh/YR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774606958; a=rsa-sha256;
	cv=none;
	b=uw2phvQSraVECtOYb8sWbmNnuRCsblG84i+9HrinFJUvcNaQu3Ov3HXwjd13dW9zgi6sRi
	N0PYm/pscJ/3/gfsmlIBUtzElQJB9zSkXNTITNJZmNh+cSGUcI+zDJTHRgLU+kSlBQyp2w
	kvB+Z327p8+0CU4V1WwtSQTtShn6gbQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzR3ABml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B084A43944;
	Fri, 27 Mar 2026 10:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270BFC19423;
	Fri, 27 Mar 2026 10:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774606956;
	bh=XOsalRPj7R8evcTexfL+00DfcAeDw/TD2xn65dA8ig4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bzR3ABmlBuJ9PnUkTtA2I/PeJb1FPUQMMSsqSH6om/ucJIC8zaDvc6LUUNWqGOz95
	 ePcL7v/VG7sEoFAKUP3g3bbwGXEIXluAKJ/vZftsz+AXVstj3baUD/dortY2V1RWj0
	 O2Kh2UEOxiGdQm9Ob3xkcjCr0YurrTy8M7vuAUW1Ay+kGYlL9IF9XMass0ITs23DGE
	 bGHXvacLxixZkg7hwu9kLpT3chHtDrdYlgnM7NA/mFGyhHsnzW6IgeENuTeX/p++5j
	 KhkgboWZj23Gop7Z7XuUNHQBb1zlofvaF0mR/hHHuyE2HqgcSXRvEJS2zm9Eu+J9wU
	 UYHX6znfvX4Lw==
Date: Fri, 27 Mar 2026 10:22:28 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 3/3] mm: memcontrol: correct the nr_pages parameter
 type of mem_cgroup_update_lru_size()
Message-ID: <96fd04d0-f8f5-4ca9-b095-ad737f0339f5@lucifer.local>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
 <fd4140de44fa0a3978e4e2426731187fe8625f0b.1774604356.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd4140de44fa0a3978e4e2426731187fe8625f0b.1774604356.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: C47B4140002
X-Stat-Signature: 7jhxhd98oucdha69jdswtqehk1uxuh64
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774606957-174258
X-HE-Meta: U2FsdGVkX1+wU/jJASD0H7YOJFxytaGBiLTDKcy448JN7id8wQUPGpJlZ01WKVH4tCxEBINoWlWxssKE8EUj2iE4lc58xouaoIHlXx+3P76LcQq0fDafHSnFubvRr5dYkR5sdpfT1a43JBpdvqI0oOfK1z6lgxrTzAWGEZZnJqO0gyb3yDVF8cg8m7pd40L7MQKXclo6CEjs1JITRPAF/TdPQ4Ud8KdHMYRBDhU8gafklkOMk9JhknULWPHIqrrHQZahrj+FmjxjMs8w+uBnliuSP2olCOpsb0LvIV5BCs/Yg7GLlNnZJqwcBHS+xhaZx8/ISYWNEycHah6s6NUYIcbjjdRer9bMo32SEnQTCtWdXTh435Skwz5tR+c2MX5A5bbi3S5wKym4rC4rhv4hV4ARhP5VGqTINpeJLhuTQJ1KRHEtaoasbG2z2LuoAaGLp1PiCJuHw/phJMPylZi993x3t3ao611g2X23j0Um8s/AxX7q6Meist2Zsy07ry7ncQ7/SJ94XBu+XK9YgaYSgKiXI921Xv9pR+H1m1FmvwktOw9H1656UhtH6d9sWzE95YHQk+kCG1EAfrbxa9EYaN9614NyveBRsHZItj6+r/Y32XoCTs9GmydS6w5n7QihP1X6WVY6BWslTn8pyTVc8OZeChyqmMO02QRsVACpItbC9cE/q0Ux4BinPmChdlWDBWqCm1d0LnmAlf2dlA9Vv8brapIn41tXKYcqEp5b2d6eAQTZ02XfrkN99j/Gv9b2hmFlaifDJZoYmmbIIAufTg/S0fCyKTc4u8Ax9urD879qRUaiImqTlZgXMC/yHniqgxyc9iqf6ciI4fL9yNCJ4fAUPuWVyPFphSpNykZMoKTnJQ7zA/OF5Ey45Fe45ViWalniOU+J3A5j7qdmgdC0+zTnEW1Ws/SaRaQ7J60rXUS9H3cjoExui6bsriNvUt4/SkkB9Y3XCEMVAWBo1gg
 X1HY4bHA
 KsNAp53XSLH6S4y+UAWT6K+XT1eWced3vCFU3V5TmgGhFkgghTAHTOR4FcDpIwSd3XsXozZF36evp2g8udgnkmxeKdTuBG+ou2qQx311/DCzYaLdLOvXB1ZRHrKuAEuZUZEL9Zqq2NFJNK1SkeoZ/NZv4xpIAX3gW5k7pnwD9wZYcBH4GsorMcibYNi+TD/JZdFDjR8hug51JvEdo2YqFub4v2cS0E+039cNSCUdhe1/Dq18FHrL4XY6rfkZVPEgBkD7+ODhcre9+hGw9aDzYIGQiyh8bLJeESUgkz30TNVXHI4GrjKT7865/5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 06:16:30PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> The nr_pages parameter of mem_cgroup_update_lru_size() represents a page
> count. During the reparenting of LRU folios, the value passed to it can
> potentially exceed the maximum value of a 32-bit integer. It should be
> declared as long instead of int to match the types used in lruvec size
> accounting and to prevent possible overflow.
>
> Update the parameter type to long to ensure correctness.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/memcontrol.h | 2 +-
>  mm/memcontrol.c            | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0782c72a1997b..4a7d8c4f55b48 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -874,7 +874,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
>  }
>
>  void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
> -		int zid, int nr_pages);
> +		int zid, long nr_pages);
>
>  static inline
>  unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 51d72ddf08119..bf74167d77c5b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1472,7 +1472,7 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
>   * to or just after a page is removed from an lru list.
>   */
>  void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
> -				int zid, int nr_pages)
> +				int zid, long nr_pages)
>  {
>  	struct mem_cgroup_per_node *mz;
>  	unsigned long *lru_size;
> @@ -1489,7 +1489,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
>
>  	size = *lru_size;
>  	if (WARN_ONCE(size < 0,
> -		"%s(%p, %d, %d): lru_size %ld\n",
> +		"%s(%p, %d, %ld): lru_size %ld\n",
>  		__func__, lruvec, lru, nr_pages, size)) {
>  		VM_BUG_ON(1);
>  		*lru_size = 0;
> --
> 2.20.1
>

