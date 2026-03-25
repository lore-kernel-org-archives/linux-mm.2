Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFBE3109C032
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270256B0096; Wed, 25 Mar 2026 11:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246AC6B0098; Wed, 25 Mar 2026 11:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183AE6B0099; Wed, 25 Mar 2026 11:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4D66B0096
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:29:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2E21140951
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:29:04 +0000 (UTC)
X-FDA: 84584968608.14.7163311
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC615140011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:29:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CsU1vZ+n;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZoG/KtFMymaV5jHuhCZ7WF+MbGglZumYUi+g7zM6MI=;
	b=eFp7e1i24Q7qJ62t4zBpxq2cu0XF5L/whQSbAntuHlVBPjh64WDuM5GDHeqWfm3V74xwKn
	QssuZEqlxI4mqhWRfN2PnPbAl7Ng2j6MeWtNKXI2kOPJWjS3oXDE9oPn4enTgwc13Y4Hy4
	PQi8SLtkEQnkkKn/ubqKlyV9HwdE82M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774452543; a=rsa-sha256;
	cv=none;
	b=kENbJXFEX9qvuRTFrSy4y5wOY/stsz8OtY7Z+9wa1QIQzC2FlnYgXjGKY++Jwyi/F3xjh+
	aurc4DgeNYTj4FYt/Pit5eQqH22orUSmYaRIHuSwI5e4JwhO72eBdKSv9hDsHdx20TOE96
	KzspsG216kZ442wvY+we8eTQQBpX2U8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CsU1vZ+n;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F363A41ACA;
	Wed, 25 Mar 2026 15:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2560C4CEF7;
	Wed, 25 Mar 2026 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774452541;
	bh=S+gB9lXh3YOTsDeZFSd4g0zO49rKXLKXwGpvrhbPAu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CsU1vZ+neeDNy1FrFSsnvYWLJC+Y5AbizxD9JdhZhz5TLzWJXU8AeQ3/KAJVp9MJx
	 nOnwLgRcxQq9RfFkwfFk5uupxbbMwYYlGjMjdxWQpMAMjmrn9JmWZc0AQnNfWLu/Rf
	 4Shltt28OwDtEK6WwAPksJHzbrjfupQIkuYDawBFDDct8c8wSAwHLyF+ypUqBVmAji
	 hiATEKCQbMcNYZWKj0qzZWHrWjfnEN3hKeLKYbMauPawZHgMiqCm/oKaSc2WjpwFQo
	 spyzsqqnWDx97KRa0TK60JZpbHBH8qbORj5iWLnp/C95Fm9oYth+ZOZkLciVq8wk+w
	 He9oxW9vKHw9Q==
Date: Wed, 25 Mar 2026 15:28:53 +0000
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
Subject: Re: [PATCH v2 1/4] mm: memcontrol: correct the type of stats_updates
 to unsigned long
Message-ID: <fcd29ba1-e02a-4c91-80d1-2d1280e2ff99@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <158fa0b1296168047342f02050e9d2bda6888d27.1774447069.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158fa0b1296168047342f02050e9d2bda6888d27.1774447069.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: mmero3imaiud6q48go1gjhopa44denww
X-Rspamd-Queue-Id: EC615140011
X-Rspam-User: 
X-HE-Tag: 1774452542-852125
X-HE-Meta: U2FsdGVkX18ZwMwa42Szhlbry3vqa2YLdl7NzLchrpjMjsgL7fG+UOe6+es/UGZ8CF190MM6zsi5iHdigZMkT4jT1hwq7lOkMBNNrR1dwglNLtDharv8++jMgwkQfZGDcDVD9HctkebtjxwfsPr8hU+iqEUqvPsMkzCuQybCzfTJgTIw+uBwqF5VAQ9zqW27Ci0BTdcWIolDsZrAKwvgc+K5XXMyZ4iGvnaIVtUlkvzQD+eVdozQ0QDZIK50UQvhpzZh+g5LL/qN6e6CyQBbbWRkiwiW5vLtozK2kTfs9//fF4CrsIGA/oB3VF8w2/sgHUHDOaTuzEdciurrOkIopJa/PuS5prnqBFPgBCd6L5D3yHa8Z2H002qeHcauYNwDlksVGqLS18WwjIp/3OpXnU1LLaZ/vfZxvIS86hZ8vssAcXxN4OuPmZxmmM7/PSSIXBbTNFH+WtG3EeSNTiipMKUw1NYINKxwidHvNjExElXT1lhESSvAoYPgEMNW7aRKpJOhcmiICzqZVHxRBPlqnfUpptuzsyaE59VxZOPgBHTQFujquJ2oOqwdJclcISageGsjmV8c4zZfsBs3HuD0jyfDZHuclLxODrU56qYf+c7qbh8JxhqKGzsLveCtbWTfKpzAWMLuIG7CMOKpiq2PV2zzzjfbUY6kbCSEHo2cOEeKUJy0b1DizE+wK5tY6pmrVbc6SRQ16UYNTCWXMtyE6eyTOvAMRv5B7lyaLKqsVNlCgEyUSx0bBUYJ+IrWSVzPQRRHcsK/+IvbAQgRLUFSy9v/dg2ZXkXSWSDUqVPK4Y8z7ouLCoqeAcWd3hwgQ1KO4/vKJ16wxwlyr5dBAkSUOatTCzCyoZtfzNNIjmu0AyZE5slcJNLpCSK/ouKB/Xxk8ZFt7RwJ3JH8EJ5oT7enUBVkuiJJufkxGuH3DGG8p6+oLOqtTFiqgSQZFPD5DZyq0kkEMNVy/02iPgz79bv
 UPWWs2VY
 LqYEXLPDuezM8kBNFU3VTcbI23i+DqTLimNVJW/745z2OtiJwZDAUA7C+JYgWdlugK7taFVFXxeq0N8slD563lG6JYFsPMXQal1GeDvdqZv3/hYc6yXNmkC13kziMjuvJMWkUETpzKFHnVz81KEz9M8JDIjSNAYruddcqgSouuEuT0XYWNxrmeUhkSj7rIh0V/7lQnNR9rhCyLIKlMZFvEuYREMg7wPR8wdmSlPdoyC3Ea0PxFzHcHRiLX4ESIqongmddvaQ8KDVmU7VeDauoN0VQGC0iWJfIOxbpSiZzUrmdMsL+BVR+9uobBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:13:22PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> The memcg_rstat_updated() tracks updates for vmstats_percpu->state
> and lruvec_stats_percpu->state. Since these state values are of type long,
> change the val parameter passed to memcg_rstat_updated() to long as well.
>
> Correspondingly, change the type of stats_updates in struct
> memcg_vmstats_percpu and struct memcg_vmstats from unsigned int and
> atomic_t to unsigned long and atomic_long_t respectively to prevent
> potential overflow when handling large state updates during the
> reparenting of LRU folios.

Do we need a Fixes, possibly cc: stable for that? Apologies if already
asked + answered.

>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Anyway logic seems fine to me, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/memcontrol.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a47fb68dd65f1..7fb9cbc10dfbb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -608,7 +608,7 @@ static inline int memcg_events_index(enum vm_event_item idx)
>
>  struct memcg_vmstats_percpu {
>  	/* Stats updates since the last flush */
> -	unsigned int			stats_updates;
> +	unsigned long			stats_updates;
>
>  	/* Cached pointers for fast iteration in memcg_rstat_updated() */
>  	struct memcg_vmstats_percpu __percpu	*parent_pcpu;
> @@ -639,7 +639,7 @@ struct memcg_vmstats {
>  	unsigned long		events_pending[NR_MEMCG_EVENTS];
>
>  	/* Stats updates since the last flush */
> -	atomic_t		stats_updates;
> +	atomic_long_t		stats_updates;
>  };
>
>  /*
> @@ -665,16 +665,16 @@ static u64 flush_last_time;
>
>  static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
>  {
> -	return atomic_read(&vmstats->stats_updates) >
> +	return atomic_long_read(&vmstats->stats_updates) >
>  		MEMCG_CHARGE_BATCH * num_online_cpus();
>  }
>
> -static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
> +static inline void memcg_rstat_updated(struct mem_cgroup *memcg, long val,
>  				       int cpu)
>  {
>  	struct memcg_vmstats_percpu __percpu *statc_pcpu;
>  	struct memcg_vmstats_percpu *statc;
> -	unsigned int stats_updates;
> +	unsigned long stats_updates;
>
>  	if (!val)
>  		return;
> @@ -697,7 +697,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
>  			continue;
>
>  		stats_updates = this_cpu_xchg(statc_pcpu->stats_updates, 0);
> -		atomic_add(stats_updates, &statc->vmstats->stats_updates);
> +		atomic_long_add(stats_updates, &statc->vmstats->stats_updates);
>  	}
>  }
>
> @@ -705,7 +705,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
>  {
>  	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
>
> -	trace_memcg_flush_stats(memcg, atomic_read(&memcg->vmstats->stats_updates),
> +	trace_memcg_flush_stats(memcg, atomic_long_read(&memcg->vmstats->stats_updates),
>  		force, needs_flush);
>
>  	if (!force && !needs_flush)
> @@ -4406,8 +4406,8 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>  	}
>  	WRITE_ONCE(statc->stats_updates, 0);
>  	/* We are in a per-cpu loop here, only do the atomic write once */
> -	if (atomic_read(&memcg->vmstats->stats_updates))
> -		atomic_set(&memcg->vmstats->stats_updates, 0);
> +	if (atomic_long_read(&memcg->vmstats->stats_updates))
> +		atomic_long_set(&memcg->vmstats->stats_updates, 0);
>  }
>
>  static void mem_cgroup_fork(struct task_struct *task)
> --
> 2.20.1
>

