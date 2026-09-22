Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E27C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00DC6B00AB; Tue, 22 Sep 2026 00:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1516B00AC; Tue, 22 Sep 2026 00:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EDE26B00AD; Tue, 22 Sep 2026 00:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6D36B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:15:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97B184037D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:15:16 +0000 (UTC)
X-FDA: 85240083432.09.35323DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id F0A2120002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:15:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8eoeLIG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050515;
	b=3IYHr/zcceggDw5QmRvmMXnAgJ2Bhe+T6zXW+O1dV6h2hYeplONkandgTb0h2l7gZ8fsPr
	5+exLiLk81qKdALM/0oQvxCSKMABFHbcMrxECS2ZrG7wT/gd6ZiFVwfzI13YAyzNfBKazT
	iN9cDRsvyw6fhaQy5BsJvPeyyX4+m0I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8eoeLIG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boh3TVrKyNvSdhPdrQfdvLGE6AQK3mRxCRvL6MrRYaw=;
	b=mgWpkJQOUYq4REbg4OF2G1x04/mP7Hik/tlg53dVT6BBIw0MtLTpOotu0mPHjQ4OJ2E+/y
	VkYTPmptTgpezba+GPoN8Fdlt1DmMZfkE+yFzaMQbGC7Q+sJQtD39KgxpxSWDvKMdHkx1B
	W4n3rKWX8YCUqRxPkxZhMFZLs0/JtMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A1DB41FBF;
	Tue, 22 Sep 2026 04:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F9E1F000FF;
	Tue, 22 Sep 2026 04:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050514;
	bh=boh3TVrKyNvSdhPdrQfdvLGE6AQK3mRxCRvL6MrRYaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i8eoeLIGAfbZtTuppPHSK/pR3V8fYKPII9qU9LQ73EHTxe+bJ3wsJiC7+pD826Fv7
	 KoXLXq2C2d9edwocjsW3Ao7IDHyA5M+hnYcP316WYhXo4J6k7lSiaUwoB+8w66GiJO
	 TgAW/JX+OS7V+t6z7XPbLPwMGMl4Zn1L6UO7+CNfK+hbliGUy0MvHLXHkZaTCi0jcy
	 JOlsXR7utH6TZySSNW6rlqdw5UYUJaww8GuVqHoYtK8rO5fnT4OItM4wnMOMvtZHU6
	 iEWyX+e0fDeadgCStA+8+yiHanUOn2ttxg1u/DpKp9VmtoqJ5IsQUNQc501Ow1EoEx
	 M1xQr6mz0ENig==
Date: Tue, 22 Sep 2026 06:15:07 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
Message-ID: <arIAyyjYcCKHFmyD@localhost.localdomain>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F0A2120002
X-Stat-Signature: p31uumaakah6cbp16339q61zre5qkcbn
X-HE-Tag: 1790050514-690158
X-HE-Meta: U2FsdGVkX18ym6XQFQ/+CJZi6aEKSczcrPtqh/U1sCeKfQYzVvoONZeydZ320tRlrp29ACZM/Iu3RIPs5NiOuTkX/eeJbwheU8672XEgo5uKaz6hImi5139ty01ARVp0udBc3gVt7Rpy7IfSSm+jTWnNTtkmTDOGCA8t2Dn1KOpz1wgcQBApjUcJYkloSqoPCtInE+y28/i5y2SDnabLxPgxfLBlFsr/SNw5XVvAna0eMkYbwrJdiNgGll/IvGLeoXEtWOaFjHZgKCNo99vd3AaYDwL4mL5HdrnIhpy8YRphubmRj+OrDp1llssIowAjyhJ6/Dr5/sMnwLyL6Lw10N/teJXEz42GgPfYbemd6O6cqO2m93VGeLtPM2pQFyW6wNdwvEidZgPvGqZ/wZTzyVx69rxruLxSKo+YkgmpuO32rDrYMEgWITYsHp0J81m+fxFm+Nj4Erpd1+Al+18S7x3Jb6/0k36i+0GUi3GTxmic7BbdJphAhZsjJwiXfoI3vs0BT5IYpwEEwHi0FqrkARSqU1x99ZH/lTRjdbgLvLtEpqgqvWj74vLm32HOegGkuy/yHS9yDpWUtDXBb8q2yCEZJTFZld3IcQF9//CKhPwGdstbhMXEZwm/jE5YzGx5GocSvVZzx54DUBaTA/wg++u65G7MZPnP3o4+QTqWrMIo2FobDJgLo8KeB/skaj+9xIGqyH8CuVINhIcnAJ/EWouDsXUj2t+MOlhx2CtvXSyvUBnNa92PfvvRExfvp29+dmNwTWC97MEF/bJSTQ5BM6Lz8BfzqfyM+BxpSNcMXKGA1ywds9wUptIjApx0UcE4lSbEje3sP0u17XBtMeSY3yWb7VJgFGekU2UtE3z6GtHUYcbUXL/nrWmIcLpXNUp/qwQflJ4xVcx1ycT3ehjc5VjOJpfoVRDI46z0t6duDm5VB0bhru7Q5HkATHUTHLAIsk8C4fQf+E+MVPF7X8A
 oNfschKC
 QH8z4dZn3gHNT0UAVX5mQmU7OeN9kKhxO9Mxd6n+Yvg05FW2VGCAVB/jA1clG57Xp5PmOeKc9vUFGFvTavJLig6BdhsB89v9InQY+e3TA6y8ZYLli26nMp07QiEW/LIUXu+PFwVLmRVK1iqWjScEfE13mK7H6ZonOfx0FD02d7wbQY8pqR94RCa/J4NCY6qUbeXbUn1SrfViV2b9tbQGZEAKpIzHjR3IvrEKLdUW4cvMSsg6oeZWeho+9b/xT0C7Mw9y7DlRIWLTcML2mYmCR7veJEYXuW18DwOwYHSg+Vq/gutlCiP6c4r2ysg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 05:12:35PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
> stats. These stats are accounted against folio_nid(): incremented on
> the folio's node when handed to a user, decremented when the folio is
> returned to the pool.
> 
> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> to the new folio and drops the memcg data of the old one, so the free
> of the old folio right after the migration skips the memcg per-node
> lruvec decrement. The hugetlb count stays attributed to the old node
> for the rest of the life of the charge, while the target folio gets no
> increment on the new node; its later free decrements a counter that
> was never incremented.
> 
> Migrate the per-node lruvec accounting alongside migration. Global
> memcg totals remain balanced because they track resource consumption,
> not node placement.
> 
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

For the fix itself:

Reviewed-by: Oscar Salvador <osalvador@suse.de>

question below:

> ---
>  mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1460cba53588..9c96ebd5436f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  	rcu_read_unlock();
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE
> +static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
> +				     struct folio *old, struct folio *new)
> +{
> +	long nr_pages = folio_nr_pages(old);
> +	struct mem_cgroup *memcg;
> +	int old_nid = folio_nid(old);
> +	int new_nid = folio_nid(new);
> +
> +	if (old_nid == new_nid)
> +		return;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
> +			       NR_HUGETLB, -nr_pages);
> +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
> +			       NR_HUGETLB, nr_pages);
> +	rcu_read_unlock();

Why do we need the whole thing to be embraced by rcu?

 

-- 
Oscar Salvador
SUSE Labs

