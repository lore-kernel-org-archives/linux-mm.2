Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52FA1CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2C56B0088; Fri, 16 Oct 2026 03:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CC46B008A; Fri, 16 Oct 2026 03:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C1B6B008C; Fri, 16 Oct 2026 03:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E142E6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:39:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67EE81202CD
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:39:36 +0000 (UTC)
X-FDA: 85327689552.08.243BD6E
Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	by imf22.hostedemail.com (Postfix) with ESMTP id 436A1C0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:39:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSGTb73o;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.246 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792136374;
	b=HJ+QKXsE+cCsava7VGR0S/ED2e7bZvoxih61VTw0PkO36AXHOYgSmBH3ahD0DMufTK3OYI
	WWC7Lxu5g1BpXyWEIWuIlF04+uC/zbEYfQXG7LcSD5AdvfV9ppee+Jj7GL6xc5KIuQdDzO
	+yz8dkvc6ueVM/vAvHkRmrar+MiDU8Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSGTb73o;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.246 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792136374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6GS4Z9Z5Z1kS6m+OCGL9h1Lo6WhvRtrwrExk3Py+Ho=;
	b=TPaDJqx2bItCPrEaSeH7ewO53ceAtRTMn7xL8qHTS33u4fq6wa73lM8qsxAZcxgPxn7N5j
	SKkQONA+dhL8cWb0DRL2+n6GauyPcdRVttKQbaB3v0szgd7M1YNEyL8vzgncUj3yqAtOSA
	Ecppl+87MSPpSeWN/EdnQMYI5TsKHO8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6YVTjiJF+OeTm2+YCUwsxkxG2HWYadWFd9Pc3CWTYq8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792136372; v=1; x=1792741172;
 b=jSGTb73oetQri8JOkIebpjoy6nsj9iVQG5WapSxcttLbUaOmx29ItV78dATFdKpm17by0V9t
 lA1sDsh3lTLnRIVuzo5y+EROwrk334ZJQBwKuzkXiWwTjxbRzrsFuluYhqtKB+V1f0m3k5WoW67
 wByTTch0OxmTbtB6IaP40We8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 139e1e22f2624819;
	Fri, 16 Oct 2026 07:39:32 +0000
X-Mizu-Trace-ID: 139e1e22f2624819
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
Date: Fri, 16 Oct 2026 15:39:10 +0800
Cc: linux-mm@kvack.org,
 "Liam R. Howlett" <liam@infradead.org>,
 SJ Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>,
 David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>,
 Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>,
 Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>,
 Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 damon@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <342E57E7-9B7F-4193-805E-D1EBB41299FF@linux.dev>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
To: kasong@tencent.com
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 436A1C0003
X-Rspam-User: 
X-Stat-Signature: fwykae3yb9ficy46ux7c1bpdpce33b8u
X-HE-Tag: 1792136374-418755
X-HE-Meta: U2FsdGVkX1+Rnl/3eoOpwAW9yqreVmMAj+sWPzzxt3arJba1zadlf2ade6WWyZjfu0eP7BBHoeyUKzgCr0olBq6yj5DNdMCOnNsq2zYlyqTDFvDcL7gnH/jmDqOLwr38CeEssbXoPsSNJDK3NRljvaRNeXg+QxwLflXm9WONWeXq3z15NPbhmnIXaBV3RiDpyoR4WcOsqnwoRJ5Q1jSTFH2elLlxfHjQi9Oxhl6MbG+8J7U6SuU6z+M2BwElOfpVX3d8h38TWHudaBieV+V8WaTT4S6uc6jKLoRuUQyBBFdWlMZ2bfH/vdAfIe379HP668bxj0owX8ohCYR9kHVjZEldaPn1rd1s7VV9OijgbyHd4yvBToEPoI7qi/oUWVskosgduPhnGZ4zHozg07nFAXVTImSeTxKy77PYoux7QxnGXQyd+L8h1lfTEf3ZSMATT/AbjP8tQHurCeoRS/WyksOjOlqn0MD+m/l2Lks314r7xkHCdKXKu6G5Fhg3wJV33pDfMtlLqzQUOVtzbfanQSmG1h33EANJobhTaPzh+jOnhEFibNxZN8aG+BlzAg2tk+SYzGM6eRp0tqQEWdy52pl3kHkeKCCS0yeGnX/wFH/jtarly00a9pDfOEokXyfMcEG9MFuhMEAx+bruqNjQoR0ZCR1gOHgx1/GTahY067DdczU6lcKtPMQhrAt/iXhqEknvDCBE0B2w41sNIbEKFYDgknUVF0v9wXRmoVwZET06Rb+IUpTke202Wt5GZvKqMloXUzpBXqWkPNTL9eT++moZMdl6DmA5BjnSH/4jtLLyGUCszDsOGVODz8K55/+RO0RxX1Et1BruCka+Et6+9lXK9ZbBmcAOdYfqRGKjLl3x0amdkNuFcpRB1eHWBiw5ylUTOLMGX/PX6xdnuHKMCrquQEk+5C8K23QCUBcDFJzs6xwsT+2hv3Vza0msDSb5bCe04+TcpBfDqwRCVjn
 ezlOO8Ra
 P4kBcFtfwvxTTGOerDSeW7ytnc66FwDapS9jASp33amP5oEQr0cSH19bIAvcr3P/LMKOkwCGni+O2Wwoh9LReJG0UVlN7TJ47TZ41P+nknoY++JJ5QOax9HR85ZWuxreMVK4htbOnJyEAeYoKUZX6Lzp5egnbzQNptUJtn64M2QufuBnlgzTZu38qQCS9Hb7RhkE/nx4zTXBCguz6sNHsjXqLhabNNJ9p1g53Mlnimufc4kuXcOssVSR+XFuS3uv2nZxzOztUoRaEj5AjwE7tD+sS/rpqgB/H7yDXCrRBVfZBHeuz8bea2izfyTu50jNiioUsxy/tTe9xMlo7AkxRqKWEeWl+VUXWDWZuQ+wG3zd8SJEgxPs4DjDTeT6+az4TyKaWAx10pJi2k+sxdLgg6uTUT3AklGIApP82thNa1gz6tLHRbZ5skDgE9PjWeIeZpBCc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 02:15, Kairui Song via B4 Relay =
<devnull+kasong.tencent.com@kernel.org> wrote:
>=20
> From: Kairui Song <kasong@tencent.com>
>=20
> Add a helper that resolves a stable lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.
>=20
> No functional change.
>=20
> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> include/linux/memcontrol.h | 39 =
+++++++++++++++++++++++++++++++++++++++
> 1 file changed, 39 insertions(+)
>=20
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 74110a324f9e..829ab776ab44 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct =
lruvec *lruvec)
> spin_lock_irq(&lruvec->lru_lock);
> }
>=20
> +/**
> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> + * @folio: the folio
> + *
> + * Computes @folio's lruvec and walks up to the nearest live ancestor
> + * if the folio's memcg is dying.  Paired with =
folio_lruvec_live_put().
> + * The result may be stale: RCU keeps it alive but does not pin =
@folio
> + * to it.  That is fine as the counters are fixed up on reparenting.
> + *
> + * Return: the live lruvec, with rcu_read_lock held.
> + */
> +static inline struct lruvec *folio_lruvec_live_get(struct folio =
*folio)
> +{
> +#ifdef CONFIG_MEMCG
> + 	struct lruvec *lruvec;
> + 	struct pglist_data *pgdat;
> + 	struct mem_cgroup *memcg;
> +
> + 	rcu_read_lock();
> + 	lruvec =3D folio_lruvec(folio);
> + 	pgdat =3D lruvec_pgdat(lruvec);
> + 	memcg =3D lruvec_memcg(lruvec);
> + 	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> + 		memcg =3D parent_mem_cgroup(memcg);
> + 		lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
> + 	}
> + 	return lruvec;

Hi Kairui,

Actually, we don't have any means to guarantee that the memcg
to which the returned lruvec belongs will not become dying
after the return, right?

> +#else
> + 	return folio_lruvec(folio);

Then, I'm wondering why folio_lruvec() doesn't apply to the
memcg scenario.

Internally, folio_lruvec() obtains the memcg through
obj_cgroup_memcg(). So when the memcg becomes dying, it should
be reparented to the parent memcg within a short time.

Likewise, folio_lruvec() may also return an lruvec whose memcg
may also be in a short-lived dying state.

Since the results of the two are similar, why not just use
folio_lruvec() directly? Or is there something I misunderstood?

Thanks,
Muchun


> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> + 	rcu_read_unlock();
> +#endif
> +}
> +
> static inline struct lruvec *lruvec_live_lock_irq(struct lruvec =
*lruvec)
> {
> #ifdef CONFIG_MEMCG
>=20
> --=20
> 2.56.0
>=20
>=20


