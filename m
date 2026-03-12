Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D704FED2D1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 05:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66A56B0088; Thu, 12 Mar 2026 01:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14076B0089; Thu, 12 Mar 2026 01:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20336B008A; Thu, 12 Mar 2026 01:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D35E6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 01:28:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31DDF1A07B0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:28:46 +0000 (UTC)
X-FDA: 84536281452.05.F61ED13
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf14.hostedemail.com (Postfix) with ESMTP id 860D810000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:28:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773293324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wW4Dlo+uDvxWdKeJyGde7usgOtJ3nRWppDtf6GLQMmQ=;
	b=I4u6iHkSBPZIi1qiBbXTmLwQiIoCdvkmwkMb3g57SQIR14enblR/cclJJ6ZpX6BWANCc5r
	FbmLSGp4shNJoLz2EdcqczowGBLsFIyjChcmP7xd0GQQcd/i5FXwbQF0fy17yLYYc8s3Xy
	zUAXd1WO1YXoKu5uXPjnQQ8RClcmj7E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773293324; a=rsa-sha256;
	cv=none;
	b=6nySa5ztTkr/DQU1/PSySOCpF/0Tb8bmt3Zm4EQ3z5a1Q/rWOxw4Oz5JYSjZrY+6VCnnfN
	u+fEAwnrEi18fmP7gQQiv7YOFTNS4zdkHKW9yCOmG9fUDpKAm80kqqaFQSJmsuG6x/b+cV
	jbIJr1E38203W38tqpPOanKeeZcdSXM=
X-AuditID: a67dfc5b-c2dff70000001609-31-69b24f04dd43
Date: Thu, 12 Mar 2026 14:28:31 +0900
From: Byungchul Park <byungchul@sk.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, alexghiti@kernel.org, kernel-team@meta.com,
	akinobu.mita@gmail.com, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, gourry@gourry.net,
	apopple@nvidia.com, joshua.hahnjy@gmail.com,
	matthew.brost@intel.com, rakie.kim@sk.com,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com
Subject: Re: [PATCH 2/4] mm: Rename node_get_allowed_targets() to make it
 more explicit
Message-ID: <20260312052831.GA60352@system.software.com>
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-3-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311110314.237315-3-alex@ghiti.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02ReUiTcRjH++09HVu9TqXXGUGTKKy8MvhVpvbfD0oq85+sqNFe9MWTeeSi
	QijMvBJLq2WpKHk0HM1b8lozNbHyqOZ9K4YHSirL1DYt8r8Pz/F5vvDQmGQcl9J8WBSnDJOH
	yEghLpwV5R4hzul4V9NHEfzRkABgllZDwsn+JQLmlQTCGqM/rOteJeBU+S8ATQPNFHyj84XN
	5a8oWNdhnqyMG6ZgV00WCQc1GwRsVRfhcDnVAQ6l+kCDtlIAp9QvBfBxZw4JE6aHcDj/bcGs
	0ATBelMhgIvdDRR80TRI+UjReouGRO9n5jE02JJJoGr1AIVydNEoKb6LQnnvpgVIV/yQRLrF
	dAq1PFvFUfXIcZQbl4GhTx2xKOXeHIkWJnpxpC37ip+3DhB6KrgQPoZTunhdFwalV8zjEWvS
	2ISlZTIOFNklAiuaZTzY3LZM8I+zNvoIC+PMfnYjKYO0MMkcYI1GE5YIaNqWcWSrDY6JQEhj
	zCLOzo1WbO7aMJfYz6Nb82IGsvlPaikLS5ir7OTTVMFW3ZptfT6OWxhjnFjj+rTA4sQYB7Zg
	nbaUrcwRUpp7NyPYmU81VDQLLLdYxkSx2dmGvznt2cZCI54GGPU2rXqbVv1fmwOwYiDhw2JC
	5XyIh3OQKoyPdb4RHqoD5t+/vvP7chVY/HJRDxgayERi1zNveQkhj4lUheoBS2MyW7Gkr4SX
	iBVy1S1OGX5NGR3CReqBA43Ldovdl28qJEygPIoL5rgITvmvK6CtpHHgBNUv+J6va+M0LgGl
	I2eTh/cp3A0iYNOTt1Md7BffqMFXio666YlHhgdKrNbvwk+HtdvcDJjYVeB1zHVv7ciYyfew
	Z6c0g1R80Ow53e6vqtKecmxKPTg2ouZ73LJR8aSofrbM+4r3oVLVQHJ7mkv/faP9yUFNjWpH
	i1fvyl0ZHhkkd3PClJHyP7GMTT33AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsXC5WfdrMvivynT4PgnU4tXBzoYLeasX8Nm
	8ezOV1aLxevSLXbdCLHYd+U3q8Xzrb8YLX7ePc5usXqTr8XxrfPYLfZdBKo8PPckq8X2hgfs
	Fpd3zWGzuLfmP6vFyVkrWSy+9Ulb3O9zsDh07TmrxZH125ksns+ay2Qx+dICNouOl/dZLN5f
	+wg0bE2Gxf6fKxgtPl05wG4x++g9dgcZj38n1rB5HH7zntnj3olprB47Z91l91iwqdSju+0y
	u8fiPS+ZPDat6mTz2PRpErvHiRm/WTx2PrT0WNgwldnj3MUKj97md2weH5/eYvH4dtsjQDiK
	yyYlNSezLLVI3y6BK2PStvcsBX+lKjq+fmNrYFwp2sXIySEhYCIx5/9tVhCbRUBV4n/3VDYQ
	m01AXeLGjZ/MXYwcHCICyhI7jyh3MXJxMAt8YpF492gbI0iNsECkxPlHEPW8AhYSS6bsZQex
	hQRiJZ5N72OCiAtKnJz5hAXEZhbQkrjx7yUTyExmAWmJ5f84QMKcQCf0Hr8FdoIo0KoD244z
	TWDknYWkexaS7lkI3QsYmVcximTmleUmZuaY6hVnZ1TmZVboJefnbmIExvCy2j8TdzB+uex+
	iFGAg1GJh9fAe2OmEGtiWXFl7iFGCQ5mJRFeodvrMoV4UxIrq1KL8uOLSnNSiw8xSnOwKInz
	eoWnJggJpCeWpGanphakFsFkmTg4pRoYBXq/c84o1XovrBQyTVuvdzOfe3VR6GZ15WN6kRHF
	RY7nwkOkYkstowwtyv4qK24VeMQn4XkpUrSv3tBKM+RGyY49ldlLv5ptaDITUNb1C7Caaxey
	KHCLcgTfLJMbaxUm6QY9VHfZJHtGR0hiQV9HpkHw/fmn3EqvrzR8fFM2/MKXKS0b7JVYijMS
	DbWYi4oTARCuD0fdAgAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 860D810000F
X-Stat-Signature: zymsp16gkumpcnwmhekhge9ouyfwbik3
X-Rspam-User: 
X-HE-Tag: 1773293321-77808
X-HE-Meta: U2FsdGVkX19xNDZ/5VlvTBWkal6x9r1Uct7WRf7vPpnHqZ5douJasecBFiL91XcAKLfTUacZJKGHbkQG49tg5EqBOWXGrUwKehvhCyiLIKXFAamExObHB4IcsLLg35GzyMx4F3gFEOsgGhv/ec39GQ24yOA2RAl3mnTeghmMO5O0LVjv1ZCcOFHbljFRngVwwB+VqxT6LGBGz84E4nqYH9xV9VnSVdypzJP8bZvsHevUlCftj3wmS5oD2Gsv5t43Yu+yGdoevEBlWjDrS7BKZYahgz2MfJCQF9yuJeoDWyrZjxeh6cPWYgBWiYqwlWnvzGDh9IUt/iDYQXwdkffXotYN44izddX6KaiBkWE4V4cwrMzRiWxGls81lMpHuNvXRRNqiPc2oqKH3pClV9RExjneQ04+3C4V4ymUi3DkZZ0UqeoXM8sFc7W/RjjYInZ9jo565m4BPqTwr0xMGALByqBmt850LzAC1EqM9hw6SeR4eihWgml/GvyR1LAWaEzhbyKIANw7QgLT6ydT7bO+j7qWCFokZNYgJt7sVMi88v6ZBN9q+srSVwXO/pfRMqO/ZV0QnmVGd3ygQvph/ImICj0WUWq+T7dWIr722m/fJR4wMjJWrDLm1nrB6ckvW2dbasZbebmJeS4dcmfYNyngoT2V2/cQrDeRFBYvK3AIH/V4Ce/3IPoQdRehZbLm/9OkmBrJBM/nzcl7OOfPuUzdXKnoLFdBarmvAv7TaGH/irgOnGSVFyPB0ySGgbmteOHsbgErfCHcNXkpc4cEAaZE+lnp4NEKZY4Fl5b8XvVMzDcZnaiObmk0NbzaIGLrX2P443gPZx/YcNQGmNIo5w9wbl20163ReV4IEZVvtGRrJp3oL9wgalNpoBPTbVJT9FdwI9lZtNroSBdPCK4Y8M+k2Svb2S0acYY/63sEVGZFF24yc1FKj7D85gktastlw1ZN1IxNvC2Q6uV8GV4vP1I
 ErSIN4UJ
 zUfQrpyfsTv/VBPj8vbNGFWj2kNQw9Vl8JzbH8g7AW5IX8l+RybySSKqg5kCeSKeViw/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:02:41PM +0100, Alexandre Ghiti wrote:
> This function actually returns the tier nodes that are targeted during a
> demotion, so rename it to be more explicit.
> 
> No functional change intended.
> 
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  include/linux/memory-tiers.h | 6 +++---
>  mm/memory-tiers.c            | 4 ++--
>  mm/vmscan.c                  | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
> index 0bf0d002939e..ec39dc3c39e6 100644
> --- a/include/linux/memory-tiers.h
> +++ b/include/linux/memory-tiers.h
> @@ -54,7 +54,7 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
>  void mt_put_memory_types(struct list_head *memory_types);
>  #ifdef CONFIG_MIGRATION
>  int next_demotion_node(int node, const nodemask_t *allowed_mask);
> -void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
> +void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets);

Look better than before to me.

What about just node_get_demotion_targets()?

	Byungchul

>  bool node_is_toptier(int node);
>  unsigned int mt_demote_folios(struct list_head *demote_folios,
>                               struct pglist_data *pgdat,
> @@ -65,7 +65,7 @@ static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
>         return NUMA_NO_NODE;
>  }
> 
> -static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> +static inline void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets)
>  {
>         *targets = NODE_MASK_NONE;
>  }
> @@ -117,7 +117,7 @@ static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
>         return NUMA_NO_NODE;
>  }
> 
> -static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> +static inline void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets)
>  {
>         *targets = NODE_MASK_NONE;
>  }
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index afdf21738a54..19ecc9b6bbda 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -300,7 +300,7 @@ bool node_is_toptier(int node)
>         return toptier;
>  }
> 
> -void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> +void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets)
>  {
>         struct memory_tier *memtier;
> 
> @@ -428,7 +428,7 @@ unsigned int mt_demote_folios(struct list_head *demote_folios,
>         if (list_empty(demote_folios))
>                 return 0;
> 
> -       node_get_allowed_targets(pgdat, &allowed_mask);
> +       node_get_allowed_demotion_targets(pgdat, &allowed_mask);
>         mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
>         if (nodes_empty(allowed_mask))
>                 return 0;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5e0138b94480..11a97ee8f583 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -351,7 +351,7 @@ static bool can_demote(int nid, struct scan_control *sc,
>         if (sc && sc->no_demotion)
>                 return false;
> 
> -       node_get_allowed_targets(pgdat, &allowed_mask);
> +       node_get_allowed_demotion_targets(pgdat, &allowed_mask);
>         if (nodes_empty(allowed_mask))
>                 return false;
> 
> --
> 2.53.0

