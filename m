Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 045BACA5FE1
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 01:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D4C6B0089; Sat, 17 Jan 2026 20:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB686B008A; Sat, 17 Jan 2026 20:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7236B008C; Sat, 17 Jan 2026 20:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BB846B0089
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 20:11:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBD4BC16C9
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 01:11:33 +0000 (UTC)
X-FDA: 84343306866.03.C73DC39
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id EAB6F20006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 01:11:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T6nSKZRg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768698692; a=rsa-sha256;
	cv=none;
	b=8L47LbkRrx3znqsAPu1d9QmdEigmuVhc1VFIxHVrfntmtQM5/CxmyGI5IxhA94BEdMukk6
	QaO5XEnk6bcUMH2iIzmxzEuT/wh7n/xdRah6i18Cp8hKhcsj4be6ipUsj9z1Go/clzK28r
	hW4z1aMMs540zi3J56o3jiSRMQT+dsU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T6nSKZRg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768698692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ATfR8YVfkNshr8Vx8DFRMyrKCT4h6769biGe+QbhD4=;
	b=Xr6WdCXoJ01NzLxDgS8cW4k7Zl7SDUQgE9EsRXGoC2hgKUQv4/01BA1vPKhaFW/hwMDbmc
	BxujsMcBAIaObBp6OL4tP0/m6x/PA58zDdmT/OgLlP1dBHdPWR8qYMRKFnwRPZQzO8UN/D
	OuHpJ6hyXQ3Ve+mnZxCg3QkmVFGrhTI=
Date: Sat, 17 Jan 2026 17:11:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768698689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ATfR8YVfkNshr8Vx8DFRMyrKCT4h6769biGe+QbhD4=;
	b=T6nSKZRgsQPtxFgBqXC5bItj4lyNJ6HaG8OAWffciX4Ho1toEGdb4pGd8lQ9qIAc18nVHY
	ki68L61BtU6+eidPp48tqIMZWerfeArj4OlgCw2swLxkcPE+EHexrF8DSg2dB9WoPnL2D0
	z7Jwu0CtzQ8wvuewBLyo0zl5htN14bY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 25/30] mm: vmscan: prepare for reparenting traditional
 LRU folios
Message-ID: <6hlbucao3tfp2bxyaekcrvhqclji4hyhq4wen4sccc2qcdr6x2@rtmqrfwfsy4s>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <3adb367000706f9ef681b34d0a2b0eb34c494c84.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3adb367000706f9ef681b34d0a2b0eb34c494c84.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EAB6F20006
X-Stat-Signature: 9inq1ie8iaacibji5eixx7667swgmz83
X-Rspam-User: 
X-HE-Tag: 1768698691-917228
X-HE-Meta: U2FsdGVkX18xkIPJizeBkD2uMGkXKEBY3+htOqsrFO/orFFFpevOnemdyi5n5PF6J8HU9RZmNcKJYqMAXaaJO6PTdiivPWkfhin+cBres+L8kCEB+SB2dIcok+IJ7GYkqfaE/cpsEu7Y0OQLU40DevSovfNfcAp6g6y7JoQMgA5sRpYXBO5bJGiVLrL6Gc1I5iLod+BI2AClhz/Rq/0s7RTOwqXU4RP7TgjN/PDK7l87d+qVS8ooq7QxlYiDGd/rBgJgb7tjGfjm/1YeemE/q/uH0vIHvIaK1ZFng/6IyuuAdftppFSnLKBzMbaQs5aEk48VXXmJoLVn8h2TITEhMXe8cLib4aBG7KaXRoYkKJUsoezRtHv7YUutbluKYZSCJX5iH1CBlSTvZLCJ9glML+SSh991dbuBJqP65/IcSDgrzkk77PSu4ApoO1Vz9FNjwLO4+gxY4DwF4yThlEujJaEe7V3gVnut0pIKaWCDyGEzVlUV+yoP7Po3KLXBqsIdh2bQCjdXTIIRGEzIgJwf4/K8aYtgT4LmTdCXtxBqdqNoYDg7vCMOvMKjLJdXzVUH2W7cmlL4rLY48N+TJRX8Vp2YeR9UK/OI8IPTLp0cm5RlriIydQeQfAVEBgf5pr6AoQhpCtKvqp0o+fFigsZ3WVZ5At2rG3/jkFnDn++IFraHjnAEKVutv9M33Fwbp8FEUPcmcA5UhMF9NIB8SyK+sNFsckQZstFkrNMLvviVFQCsYL0bCj+i/o67KO8IKga8YVqvoCIzxeIs7/tS3vLblvftoFMja1QQblJZJ6t67xbSGqghWiUQcqqgiimsyMY/SSJ1mV9kIbURvs0H5vHz1NiWHeKxQUQmFZr8fISdf68u4QSEBhydatGdwbda5TDmIZcLAiyb5uqk4pXSoV9jVLKjZDw7Q0PuAQqlq4Mq7HGs6rLVVf6QJOebZm/RDmEVXpfE03wxCRXuD7YXZvI
 2hYGd+MV
 /NUTNsQU/O020HjVEavgbvqe2TX0DjnxvszUp5uWtA5WDVttBGGyueXgF2jy5gx464W820+7moGcf8I8+L686UqHKDX23yyJlhRVbZNsuXJsLv1pHs33OKXJuVfOVSz8f9uLp2K9ZVLwudEp/ihDCHpDC42t6gynnRFAUZPRfD9UWi7vNj3+/AWE2jooB3O7H0JypYMaxMtnNMrwveFAkVqs9G8CugrpLIrDH5TzwjAmAVtI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:52PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
[...]
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -1090,6 +1090,43 @@ void folio_batch_remove_exceptionals(struct folio_batch *fbatch)
>  	fbatch->nr = j;
>  }
>  

Why not define the following two functions in memcontrol.c?

> +#ifdef CONFIG_MEMCG
> +static void lruvec_reparent_lru(struct lruvec *child_lruvec,
> +				struct lruvec *parent_lruvec,
> +				enum lru_list lru, int nid)
> +{
> +	int zid;
> +	struct zone *zone;
> +
> +	if (lru != LRU_UNEVICTABLE)
> +		list_splice_tail_init(&child_lruvec->lists[lru], &parent_lruvec->lists[lru]);
> +
> +	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
> +		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
> +
> +		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
> +	}
> +}
> +
> +void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> +{
> +	int nid;
> +
> +	for_each_node(nid) {
> +		enum lru_list lru;
> +		struct lruvec *child_lruvec, *parent_lruvec;
> +
> +		child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> +		parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> +		parent_lruvec->anon_cost += child_lruvec->anon_cost;
> +		parent_lruvec->file_cost += child_lruvec->file_cost;
> +
> +		for_each_lru(lru)
> +			lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
> +	}
> +}
> +#endif
> +



