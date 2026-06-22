Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D3CCDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB646B0088; Mon, 22 Jun 2026 19:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1AC6B008A; Mon, 22 Jun 2026 19:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174926B008C; Mon, 22 Jun 2026 19:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8D786B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:42:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6249BC1966
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:42:09 +0000 (UTC)
X-FDA: 84909174378.19.37F1702
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5E3C100003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:42:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2n4DGO2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782171727;
	b=Wp0gmMlJSdx2cYY2lND3Z3dwe63hPXPCyPlwVDG3SE1oQlOMtcdxrOG3TxN2pRf280x+dt
	oeUpxuqoSEqhy6ksPzwiZtm90IngDbiqAJQJDmAygvWoGbxoBl4xnHZ6YP8blLfny/jZE/
	6FT0gmBvFOq6M7TcYlhmju1a5227kfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782171727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYgQzRWkWxLUnGWAoYxurtQBuGAOfxttp+K+/45YvTo=;
	b=22VSXP3R9ODIlz5Cygakpk/TQ+Tefzz5oQ7d5QaLJ22gotZen5nfv/PWDZ4HmKVD0gCQCq
	5Sb9coR7sm2PAGlM8tPdrsdYuo963sTN82E1/VHnarBZDG/Ri2l+JCog3hBHtGYWRTA80n
	a99VTUcs3O/UcpNHofBjUqV020wTigc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2n4DGO2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B1916001D;
	Mon, 22 Jun 2026 23:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8281F000E9;
	Mon, 22 Jun 2026 23:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782171727;
	bh=zYgQzRWkWxLUnGWAoYxurtQBuGAOfxttp+K+/45YvTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l2n4DGO2w+knegYqXIXC3R4qWmsAIF47NbNgAmYwSeSwSk1Z/Pa0FYBuKsqUYcxRV
	 fsLjEOQ+i8YLPSuntJem/r5qr3w8aMXczCY6HhxfMGBI3bSinU6lEOMUcH0+T1gnxM
	 Vz+ctxaPh0+6Jkx3YrLmTRRp/hN7oKjjdpSiwldr75WoSNFFmmw8AKmhhXHYeDljzQ
	 xggeN3xL+LpikVft5upWTiHd1KBfaqTgsQixPyBZQhCd2s2mgO0QxEZrwaWnx8UARr
	 izbR+mbPdRU3V+XaF93ByPUtrqjbo03sZx2DRy1l9fNYhiM9yexlhk7RGv1M4OoOag
	 83B0bg8Rx6ACQ==
Date: Mon, 22 Jun 2026 23:42:05 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v4 4/5] mm/zswap: Add per-memcg stat for proactive
 writeback
Message-ID: <ajnIC0My51MW4sc_@google.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-5-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618044857.69439-5-jiahao.kernel@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5E3C100003
X-Rspam-User: 
X-Stat-Signature: z8s3x3fpi5sbmbesr3m9dsc4qtakakpc
X-HE-Tag: 1782171727-632797
X-HE-Meta: U2FsdGVkX19t/Wupy3ThcuK8LtsrKwnxD2PqCayZIq+yq56akpWJr/HGbTF0tIeRSmnhhNIzRUsMXYk++Sfel+lXBEyxeyMsCnbEp8opgmxIhbttRQowKTTsO0fEZPg5fqQ28ffJe91Glhumna1AKriO2inf8Irh14WuCRQvkEX/8s1BMBZeuksRhAm26OqLpAG/I4P3UXvAMxvD8Mih7Y71b1GwFXC2Uf8DpWP5N8db+FqdThVMG9nzWc0zP7Cg4mslkJujX1MOBuxVlmbP+IpyzOW4mx6P1EnhbltAIbjHGr/OxS4pHkndAFDTEWXJsKS1pPyapdmfC3aBS29Wei5NY+zrUfsraFFQ8t+R/xcIQYm6CYOAboPzrFcW+SEEiqrMLWwPiM/VbZQ6pf301aNJ+mJWWoq9lwVKZaBdLf4YHiPGah0m4wSTIeUGWaesZ+sackXSYOdhfS0S6DoKLhCYksYDoAZmz0jvXI/Ng+tEPgIgf6dyAbMUIMXHWqWKmB9kYuVjncdxJvgg1MRTQbLyrqLxMxyAw3j1b28j1C6Mhoa11p3guarfAQH3G7pCc4EJ5b623Qqzua+eA+2H9B6CSatR9VwbC/jPVljY4Zg9KPz9LCEb31NF5WABEp+hetWX2v8NEyhMoUj7CZiEC74tG+klnxJFxWQ01XhypbCq+Gt1A0beW8WisdVHLaL4bIt2hJq68JnFuWKuxNx3Gw+bJmLjtTJhFV8uECRp6YNOmI2qqgNv7bwIXsb0Ie4tMuwtDk2HTrPNCgghbh+hi/S0P/Ea0mp9Ne1ccgH5/UKFJDwZtTFZpoq/occh/gBIIjgW/q3oC6xGRZ2Sa9NS/KLQzSmOqLd/Wlzij8sTlvPYQB9ZZYpGM7WMiyo+Wr8fb4qo4Fb9XHXTaHdXTkbP6ozp5M9oKxyDjEmQuvH50SUhJPz0szvEvosKD2HPEHhzfQ5qHLRlRMfHBv7F8dL
 cd2BZw38
 746AlOPDgGu+kKvVa911ZbMtSQG/539K6RrK/yZ+qJFR6CR39F+trldeiHMRB/n80lw5gtBLxcBjWc2Ip2PQ8FgroFYvNzgxVl7WG76x5wqc7iRue8wDR/QLnCBpzmrI4tSop5UxKxT6DMbhQlJlFF71hzrae3i+Lvf8l9jFtotiNGnJKY7WdluP/fFocZ7zfDXNn1PDAdTUgXpW5zOSabwn+lhMMkrtbFFgyliITrpJFXvlfYAskZR9E9J3mcIzVqNpURw0pSSdHoxIjHBy63FBlQnI+xmf/TMKiVUcaQ4c5Zpia1nyjFZTv9DIqxEPG34+QzK9bYAtOb4dr8FPadUC1FMDOo6a6tiLsvNPQ9GF4mts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[..]
>  static int zswap_writeback_entry(struct zswap_entry *entry,
> -				 swp_entry_t swpentry)
> +				 swp_entry_t swpentry,
> +				 bool proactive)

IIUC, if we refactor the code as I suggested in previous changes, we
don't really need to add an argument here..

>  {
>  	struct xarray *tree;
>  	pgoff_t offset = swp_offset(swpentry);
> @@ -1045,6 +1047,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	if (entry->objcg)
>  		count_objcg_events(entry->objcg, ZSWPWB, 1);
>  
> +	if (proactive && entry->objcg) {
> +		struct mem_cgroup *memcg;
> +
> +		rcu_read_lock();
> +		memcg = obj_cgroup_memcg(entry->objcg);
> +		mod_memcg_state(memcg, MEMCG_ZSWPWB_PROACTIVE_B, entry->length);
> +		rcu_read_unlock();
> +	}

..and this chunk of code would end up in zswap_proactive_writeback().

