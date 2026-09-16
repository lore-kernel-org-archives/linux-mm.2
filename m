Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4A3FC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFA36B009B; Wed, 16 Sep 2026 09:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB74A6B009D; Wed, 16 Sep 2026 09:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEE36B009E; Wed, 16 Sep 2026 09:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA3076B009B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:34:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E06481C2C94
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:34:25 +0000 (UTC)
X-FDA: 85219719690.17.A04D60D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2DF04160003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:34:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZCYZZfUe;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Z0tDRbfIu14gBiwBTHTnXsfRNC4/vvPKIDDl1Wr1Wg=;
	b=fQKShoy2UMt9oNqLvuaIBanmS6XGnfqoxUX5aWatkjHLObAoa8fYwrcsSkVeWcg2qqtVtb
	PddJNGlDZgSa+RAi/EvTnPIJ/CxwGO2dHj1mZH7JvtzHy03Yzv46Q7YLOG9TQTXbqh2vIP
	HCKJKdr+vRtv6ENetEjlW04FeKgYinY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565664;
	b=s2Y0o8plnlOFlj4eA2VYE6ePO6O5H2Y/R8drVpzTZWsLeI+dz+dhUhB4biRoHDr+ywzUDN
	2IanIaQsYbXsik0OunwRKLmfJcuurvIot0X1PhaElNowbeef/QWxXHG4OphXL4Rap39+bi
	K9d+pylrtn9QmKxwvaqC8/WB0mgFwG4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZCYZZfUe;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57F7443345;
	Wed, 16 Sep 2026 13:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6A61F000FF;
	Wed, 16 Sep 2026 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565663;
	bh=2Z0tDRbfIu14gBiwBTHTnXsfRNC4/vvPKIDDl1Wr1Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZCYZZfUe2VXwIRg14QoroYNTZXywKr3OsnaMGA0X6vHMZkznCnqFoTZ7cASnmjWSx
	 e+fqG574aLUN7JUyYqpTQcX4mxopFrxfwvp/lSs0HEx6Cl8HhU6nVuCpee7pYtW0zy
	 WrITWsGDQIO2/fiYGSDqdPVzl2VKbP8HFYpChZfuVx71SH7zcS/nRl9IN65Dm1/bvs
	 sGV4hYi1OybacI5MHgLfD74wysS1nA81WUQR6cyV9MzUa0Ykeca2a3BNRLnIUjIird
	 qxy6NMoMyF95YrJHvhXzfsA3w/yhOS5VY0BwwuEVZv7gt0xHYJwQXrrLsWW03ABtVS
	 4bsRK7es+cY4Q==
Date: Wed, 16 Sep 2026 14:34:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/11] mm: memcontrol: constify the read side of the
 memcg API
Message-ID: <aqqaaDqTDahlZ7bR@gremlin>
References: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2DF04160003
X-Stat-Signature: q5mp3e898y361edg6m7fbuf4ip98qj9r
X-Rspam-User: 
X-HE-Tag: 1789565664-864408
X-HE-Meta: U2FsdGVkX18FhlEgyINK7JZWzdCwvYNdxdAMq9gAmgbd4za02xcdswXzP1DMgKuGbpplxbvtl59I+0j+FGoKOd//sZ0qKeiOrzmwd8LTrp4oTjXVquPj6O7sJD4a5rUqtW3rTU9GQLs60JU3XfBu6RaWkl9b6Pi4H3w0NMl5Yml0VZgRNVU8nsipX//j/VisFm5Cf+d+N1jEigHRUptS5tO1wwsAx5P2J1HuohFuj2x/NgxETdbgvBhfgc8QQtl4EXIUbda3oVWTKULDxQ7TADKiLtWYTRPo15isElMHGQrfz5ggH5/mekeSwOkQypx9y9Payk1Fpad6ReV0jj6xleARKd7UrqtZHZqTG9cHKtYIOv0ddrxbQrx7Aae+lOGVXPJUy/lnjCT6E19+6XIGdaL1ReEWEua1FpWeTvhJwHTKB3AqGQ7uY8nulvmdFM3z5r+/1n0oXpB2pSBmpxUMn4yKZRhlvjhlake7ZUUDlw1QHVnqQjfEZSzkL0Xeb34u3VBFuBlzD/C6NYBuqkahuwab6evYy4KN2P1AZQ9alax9EMIDdoQagvUScZLdUdUPGjSMOUdVEfctqKTUfTrNzwFnWf+3t+3Gbng7KO/XaClKxFvkg4t8/qhodUW2FGpzk76LU+9p0zOQCI3vWfTRiqL7X+pV8BLNxCEVl14PIPi6qG65UmLKUjR/ULU8zZi2Wz14KO7znqggRXrThizlPemQW8vjeiFudBDN+AeLee2jIia1McbA1tGakVHBpPFxEtBaFrp6FTkrgmT58y1HP/5fjGSwl86LFWivPGS30piv5X/TTEV3fP6g7k02xNEioYjF6qHsmSRUZIOS6zuz/X2ADf9/w/3QDFDVdJ445RF8sZ3t1OkTQ0136joTiwzSSJcovbep+962XS0mHL6FdHXRkZjGlcZnV8SdpvanoFM/8NHW36qUkFOnRvcvBBBsW5ESBIr4043M5k+sG4V
 GvNoc/6O
 pkaDIL5Sm1Je1Mv0Vv0Jr3edouYIiwg5Eg4Syy5eWtpfqewmT1TrqA9lPJeWJOInaOTg5UhbQRJO3q4i+9Bkg92lLzAQT2JkdNUH8fO+GJmhnhQ2BJtyaZ8tp2LFQfgNW9C1JsKO90055EnoPhVu9uWnBA6xzxj8ej3wgK+XQdBVRC+/ehj/piXyAuSO/UBoXtpGd95Q/qgYdgLGWyGAPHi0lHMYkGroCkptPNE21gs0tHZfZdXZZyWMpKXD/AQ5VGsny7mzqpv/tvGoSTjwu8wW9Dtu93vlZ+KbFtPzKl9aeIy+WbRXLrE64fcMH7kD/BGAxk4XbisSY/uvy4+meolfgiLA5T4SR8L5xUJVVkwyFs9lrR9VGrUMYNbbpQW3GMceEYsuTQ1g6mZ0gSb5YiEhxmFSUAlAVubKYJKkj7A+utM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 11:57:36AM -0400, Tal Zussman wrote:
> The memcg accessors, lruvec helpers, and stat readers only read from
> the memcg, folio, or lruvec they are given, but take non-const
> pointers. Constify them, along with a couple other helper functions in
> mm/page_counter.c along the way.
>
> This started as a follow-up to [1] that quickly grew in proportions :)
>
> [1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

:)

I looked through it, all looks sensible, and it compiles locally and
const-ifies things so it's all good AFAIC! So:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

For the whole series :)

>
> ---
> Changes in v2:
> - Patch 3: Constify the folio argument of folio_lruvec_relock_irq() and
>   folio_lruvec_relock_irqsave() as well, per Sashiko
> - Patch 3: Note that mem_cgroup_lruvec() updates lruvec->pgdat in the
>   per-node structure, not the memcg, per Sashiko
> - Patches 3 and 8: Use container_of_const() in lruvec_memcg() and the
>   lruvec_page_state() family, per Sashiko
> - Link to v1: https://patch.msgid.link/20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu
>
> ---
> Tal Zussman (11):
>       mm: memcontrol: take a const folio in folio_memcg() and friends
>       mm: memcontrol: constify obj_cgroup_memcg() and friends
>       mm: memcontrol: constify the lruvec helpers
>       mm/page_io: take a const folio in bio_associate_blkg_from_folio()
>       mm: memcontrol: constify the mem_cgroup accessors
>       mm: page_counter: constify page_counter_read() and page_counter_margin()
>       mm: memcontrol: constify the reclaim protection helpers
>       mm: memcontrol: constify the memcg and lruvec stat readers
>       mm: memcontrol: constify the swap accounting helpers
>       mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
>       mm: memcontrol: constify the zswap and socket pressure helpers
>
>  include/linux/memcontrol.h   | 204 ++++++++++++++++++++++---------------------
>  include/linux/mmzone.h       |   2 +-
>  include/linux/page_counter.h |   4 +-
>  include/linux/swap.h         |  12 +--
>  mm/memcontrol.c              |  49 ++++++-----
>  mm/page_counter.c            |   2 +-
>  mm/page_io.c                 |  14 +--
>  mm/swap.h                    |   2 +-
>  8 files changed, 148 insertions(+), 141 deletions(-)
> ---
> base-commit: 9d3243fc689fef444f87e0a703b4c99653137e1b
> change-id: 20260807-folio_memcg-const-4a67e40d485b
>
> Best regards,
> --
> Tal Zussman <tz2294@columbia.edu>
>

--
Cheers, Lorenzo

