Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D06CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 11:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C7A8E001A; Mon, 10 Nov 2025 06:28:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D308E0002; Mon, 10 Nov 2025 06:28:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4430F8E001A; Mon, 10 Nov 2025 06:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 349278E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:28:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D775D160D1C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:28:35 +0000 (UTC)
X-FDA: 84094474590.15.3E8FFEA
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF3FB4000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:28:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=W3rfcjHh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762774114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csQWI5jqus0ZWRL/iU5hav/pk5IdN2xcgvPAVhT7DnE=;
	b=TJnZWPVrMveQwevGndPvBICJSsl1/Pm0ClIJWO3T+0yn5kZvuYORn7TNCnESwEceYcu5I+
	WB40S2FNrcgizFAi9GQQDd3OHY2NCSdEwOqzcDFkFghGKsxRmQoq2LqkVw8tmWwalZ+CmC
	3s1AsSOYQ06+95RdGlsIzNDmsjh1V8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762774114; a=rsa-sha256;
	cv=none;
	b=46FQTGA8dMvis5Xc3489xaF2cR1kgRsB8uPqS6sagng6LD8MJdsMdeMt6GouSMvLTX9MN+
	Ap923j2us+CqkXhC3SYdQazuvVY8pkUhliIFJI1LEfTiyxzTKPvVzcz6+sBWN8Ou63gFAc
	KIetCkmvJQzhL4dyBaCpNo8yZXHZ0xk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=W3rfcjHh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso5293888a12.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762774112; x=1763378912; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=csQWI5jqus0ZWRL/iU5hav/pk5IdN2xcgvPAVhT7DnE=;
        b=W3rfcjHhg8a3wzWhiiozrkGtF/ZH6h58KcStlILZiSZpcfgv0aE/6u6lsalDWZQ8KC
         cVXouSEZcMUmI+mUwSiKYJmr3UN6tiGjzDHPFGdC/SGEou1t0LUqMnjoWnadUlzZIHde
         y8W3eEyaiosCKHoGtcyXNVlnpcGAggV0/CKyWZ79n7Z7sPKDMPSmcC5/TPGeAu7ASXR0
         TIZKADNNkZ5ERrWIjC5uMN4uykYaEfiEzUMAxKoUvLBcCKt+nhEtJoc6bo94RqHaLoZ9
         CJfA0M1odcMgAFrjpIDpzGfMX7Wmos+zXG3bZydoqAFeFTiT9028f8r9o1ZQ6C573thn
         ZPug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762774112; x=1763378912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csQWI5jqus0ZWRL/iU5hav/pk5IdN2xcgvPAVhT7DnE=;
        b=LojVFh7zaEVeH7bKHhdH93J0KUcmNpjZNmJHdSeoXKPeKKCxtcl4wQW2D7bxoufgQa
         DewHpb8/ndWBdQvIft5k1A3DG5vEG63pxC77l3wTtJoRrybfcoJ6JNJMZ7kAyYdk5u5d
         wUAgZ/NCuhgFgWXm/SPJRIyhIbmhm4wD/wb7E/Ci9fjEJ8t/u6br2uOuSkNyH8xHNe3G
         xFDjriSQKoe0a5FpUnNxHJasrf/cVp5MeMQ18RyJ08sj3bf8tFXW0b1XqGEBNDQMe7jV
         AZ/SbvqUU6RWvtQZI5iUjqwnCt8HP4N3BFP0eplfQKwFSYgypey1/kn4UMTkQ4eWBCP1
         N5Gg==
X-Gm-Message-State: AOJu0YxPWLfWQ0KGTBa4qEcesiGn3pAVSZxEQmpr2jlCLrhrdFLPBY7l
	DaN/Y93vx5RhKfawfxIGH3IQeDO3So40SCbvSm2RhW4fPsvgPX4Ha0UNUQLPONFrbeQ=
X-Gm-Gg: ASbGncvAFvPiory+gNnJI7bSf0vpa0JZmnPMYQhF4n1wk+l4fctt0JqQDWbQLU7zwIw
	VOOpGfJodhATxsRWfs21tnOAYOj1HTmxX3iZsH4/lD6mdKS4H/V8eUzI+2PsTJZCA1KjpzBBwyI
	W0B9EqQfvJmf/9MC7ZD0eV/f18bkmAOSEn9XUfneTcmAZHp/FMeLuFmMv9YPt015ugHGjYG2o6P
	V729MFAgXKrQIwDLXUxjhWw4BrVLR7lWYIBGQHDViUUATqyX8BwtWtf7ENVP449mDE3w6UAzsq/
	mVLpYue3jEsZRxYfrTuV/xqLas4+DXXGazG3rQdD+Wys9fVUrCSSacwxPMsH+u8qEiZmqhzBIVG
	GePj7XMzJP0uyml+cDRvRJumNImy2FyOxMiJxVD/9IZgG85K+E8f0Hh0Td+I5Crx2OJeXIVbVay
	jz/hlXiKnPEh+1fcf8YAZpBpi5
X-Google-Smtp-Source: AGHT+IGAJqQ0Kq7UeRNfTo+kG/hya+4ozhhHWlZnaOOqZGzl+HnP2llew3IXX1GgpwGtU4vmKHgoXw==
X-Received: by 2002:a17:907:2d8d:b0:b40:b54d:e687 with SMTP id a640c23a62f3a-b72e055e508mr784475766b.47.1762774111807;
        Mon, 10 Nov 2025 03:28:31 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf40768fsm1062473966b.23.2025.11.10.03.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 03:28:31 -0800 (PST)
Date: Mon, 10 Nov 2025 12:28:25 +0100
From: Michal Hocko <mhocko@suse.com>
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	joel.granados@kernel.org, jack@suse.cz, laoar.shao@gmail.com,
	mclapinski@google.com, kyle.meyer@hpe.com, corbet@lwn.net,
	lance.yang@linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <aRHMWewcW41Vdzed@tiehlicka>
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110101948.19277-1-leon.huangfu@shopee.com>
X-Stat-Signature: 7wbmmtqxf799w8khz8snzdu7s7owsrrh
X-Rspam-User: 
X-Rspamd-Queue-Id: AF3FB4000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762774113-724724
X-HE-Meta: U2FsdGVkX19OySbFnbUsvInCqusivFRxMjp7yA5Jlo41qio3wOyG+4XN+mLFx9QAQciQ0NVY7ZbObvyN/Jo+9oV+ny+c3biwLeMApiBKdwb+4D8DnclozZnvcTuaAs2U9JkWUXff/eUqm+ODkn+IZlSB1GntE2W8Ulb2CxjHEAeBWCz7ntZ8W+XkupakY97N/5fLr98HD1CZcyxUYY6rZ1WsqmoUjAU+7STUVg4hhuyZmOcDHY4JpAiX+26JbgHcjUMXYKMpjz2QpgdZHu3/KX7BEWDuL1lEFdD4d+uLt1dgkSKUulQbrf4rPFZFE4U9GWdr4OGBYmUhyMcAAPQoCtjMSAc+OGvLiIkBzv7ZPYEFfondJH1J+f+bNtlTR5tmw0gBLVp/c7s4rWJVIVi7t/ZKVmXnE9Zb0Omq4haxMPATUaFZ/H1neTasUrs79EO3gWq2lsMwOQpgayrpiWVvQu3KL67dyI72u7LONSBFmKh8Bhyw95pkueAFteyBefV3Tgrc1M3H/COEtAR39FKpTSCWCWn/mz4ArVnsGInJWlmKGGeL1X2H9JQM92ERTij5Vyz/nkE/IwUTmQ+Lp5DJ4rfrZcII90MKh5AoKAbZ31HjBdJ7ez3Oa/a4MMzt505+ySDSBrEq5csMvn9u+FFPd/Heg304OA4LVDr/2CD3bEzP3dA5zdU0s8AMfRgk9Pa8QedAClS+33JWvc93sSvIVW7Rv2TL4d1Ex/B2y4V+yo7iLAFzhxgFPGuEXVirMHtHnvVjucAhQnJv/IMjeEBQH/fb0iSyHx2EkIRcDFO5sVzT7S+0tvFpWDZYQiQjBKO6RgqaRUWkTVSrY3IWf9TCY8CImSKR/B2sbu6ACbUqVh0mwbLMpec7J0DhSq7zbBZtI3GaUq7Czs7e1td9I7cPc4TTNzjKIztI6fXjDBbFGol/Z3BVkCZexBeytR+doKCSPrYkxit5l34+flWdns2
 nMjb55JG
 oQXJZWRQoOgkTuPl9fJ/A7cfDIgBFti5RX2PapwjaUvRBouGn20nxR62XjOL42z/8Brp3HFJ9RluGEVQbeiDeos+NsG/mqd77Cf9AD1C/2g4z+OfrpLldjovaIAzdDinKkv8OgGc/nYZetthXOtDMTSSErYk4FSolbZktUo+WkohYJUsaKlZRkMbHOh9l9lF+ikNrt7AO/g09xXY1/A7FwV5mp8AEWL8Wro9qsp5whl0bRPj7fuObRfKSoI80NN3C0egaG6HahT0jxGVOLS5R1lzq96q5bmX82ppYQLGXtlEWrJmc4QA7320ej5zHOWNGAxzU1snEhVF98kWck0VLpuNAvj1NDnC2d7SKjSB/Z4FR7bbupTfzAkcqKH1yirtmQBPfc/mLvxyV2Kl0OjcWTdI+F1SsyUHjd9WcSNw1czs13MkRyjIQfQlUrSXqA5gCM/SX1T+lYyTm/gVlhTI+FJbF+lMq//vTHWc6qSS7lwq3YRyGc5390Jucv0DAWtPOksmiISA4Qw9PbyFQG2Xwl6S/rXZmQ5D2QktptmaUZk4Ncq3UgpqmWn/kqXCoydfwjOvXyt/Px4nkhVUpB14NfKh9scHL4s+9YvLOkXr2tbQSSTY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 10-11-25 18:19:48, Leon Huang Fu wrote:
> Memory cgroup statistics are updated asynchronously with periodic
> flushing to reduce overhead. The current implementation uses a flush
> threshold calculated as MEMCG_CHARGE_BATCH * num_online_cpus() for
> determining when to aggregate per-CPU memory cgroup statistics. On
> systems with high core counts, this threshold can become very large
> (e.g., 64 * 256 = 16,384 on a 256-core system), leading to stale
> statistics when userspace reads memory.stat files.
> 
> This is particularly problematic for monitoring and management tools
> that rely on reasonably fresh statistics, as they may observe data
> that is thousands of updates out of date.
> 
> Introduce a new write-only file, memory.stat_refresh, that allows
> userspace to explicitly trigger an immediate flush of memory statistics.
> Writing any value to this file forces a synchronous flush via
> __mem_cgroup_flush_stats(memcg, true) for the cgroup and all its
> descendants, ensuring that subsequent reads of memory.stat and
> memory.numa_stat reflect current data.
> 
> This approach follows the pattern established by /proc/sys/vm/stat_refresh
> and memory.peak, where the written value is ignored, keeping the
> interface simple and consistent with existing kernel APIs.
> 
> Usage example:
>   echo 1 > /sys/fs/cgroup/mygroup/memory.stat_refresh
>   cat /sys/fs/cgroup/mygroup/memory.stat
> 
> The feature is available in both cgroup v1 and v2 for consistency.
> 
> Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> v2 -> v3:
>   - Flush stats by memory.stat_refresh (per Michal)
>   - https://lore.kernel.org/linux-mm/20251105074917.94531-1-leon.huangfu@shopee.com/
> 
> v1 -> v2:
>   - Flush stats when write the file (per Michal).
>   - https://lore.kernel.org/linux-mm/20251104031908.77313-1-leon.huangfu@shopee.com/
> 
>  Documentation/admin-guide/cgroup-v2.rst | 21 +++++++++++++++++--
>  mm/memcontrol-v1.c                      |  4 ++++
>  mm/memcontrol-v1.h                      |  2 ++
>  mm/memcontrol.c                         | 27 ++++++++++++++++++-------
>  4 files changed, 45 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 3345961c30ac..ca079932f957 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1337,7 +1337,7 @@ PAGE_SIZE multiple when read back.
>  	cgroup is within its effective low boundary, the cgroup's
>  	memory won't be reclaimed unless there is no reclaimable
>  	memory available in unprotected cgroups.
> -	Above the effective low	boundary (or
> +	Above the effective low	boundary (or
>  	effective min boundary if it is higher), pages are reclaimed
>  	proportionally to the overage, reducing reclaim pressure for
>  	smaller overages.
> @@ -1785,6 +1785,23 @@ The following nested keys are defined.
>  		up if hugetlb usage is accounted for in memory.current (i.e.
>  		cgroup is mounted with the memory_hugetlb_accounting option).
> 
> +  memory.stat_refresh
> +	A write-only file which exists on non-root cgroups.
> +
> +	Writing any value to this file forces an immediate flush of
> +	memory statistics for this cgroup and its descendants. This
> +	ensures subsequent reads of memory.stat and memory.numa_stat
> +	reflect the most current data.
> +
> +	This is useful on high-core count systems where per-CPU caching
> +	can lead to stale statistics, or when precise memory usage
> +	information is needed for monitoring or debugging purposes.
> +
> +	Example::
> +
> +	  echo 1 > memory.stat_refresh
> +	  cat memory.stat
> +
>    memory.numa_stat
>  	A read-only nested-keyed file which exists on non-root cgroups.
> 
> @@ -2173,7 +2190,7 @@ of the two is enforced.
> 
>  cgroup writeback requires explicit support from the underlying
>  filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
> -btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
> +btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
>  attributed to the root cgroup.
> 
>  There are inherent differences in memory and writeback management
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 6eed14bff742..c3eac9b1f1be 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -2041,6 +2041,10 @@ struct cftype mem_cgroup_legacy_files[] = {
>  		.name = "stat",
>  		.seq_show = memory_stat_show,
>  	},
> +	{
> +		.name = "stat_refresh",
> +		.write = memory_stat_refresh_write,
> +	},
>  	{
>  		.name = "force_empty",
>  		.write = mem_cgroup_force_empty_write,
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 6358464bb416..a14d4d74c9aa 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -29,6 +29,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg);
>  unsigned long memcg_events(struct mem_cgroup *memcg, int event);
>  unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
>  int memory_stat_show(struct seq_file *m, void *v);
> +ssize_t memory_stat_refresh_write(struct kernfs_open_file *of, char *buf,
> +				  size_t nbytes, loff_t off);
> 
>  void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
>  struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bfc986da3289..19ef4b971d8d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -610,6 +610,15 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
>  	css_rstat_flush(&memcg->css);
>  }
> 
> +static void memcg_flush_stats(struct mem_cgroup *memcg, bool force)
> +{
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	memcg = memcg ?: root_mem_cgroup;
> +	__mem_cgroup_flush_stats(memcg, force);
> +}
> +
>  /*
>   * mem_cgroup_flush_stats - flush the stats of a memory cgroup subtree
>   * @memcg: root of the subtree to flush
> @@ -621,13 +630,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
>   */
>  void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  {
> -	if (mem_cgroup_disabled())
> -		return;
> -
> -	if (!memcg)
> -		memcg = root_mem_cgroup;
> -
> -	__mem_cgroup_flush_stats(memcg, false);
> +	memcg_flush_stats(memcg, false);
>  }
> 
>  void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
> @@ -4530,6 +4533,12 @@ int memory_stat_show(struct seq_file *m, void *v)
>  	return 0;
>  }
> 
> +ssize_t memory_stat_refresh_write(struct kernfs_open_file *of, char *buf, size_t nbytes, loff_t off)
> +{
> +	memcg_flush_stats(mem_cgroup_from_css(of_css(of)), true);
> +	return nbytes;
> +}
> +
>  #ifdef CONFIG_NUMA
>  static inline unsigned long lruvec_page_state_output(struct lruvec *lruvec,
>  						     int item)
> @@ -4666,6 +4675,10 @@ static struct cftype memory_files[] = {
>  		.name = "stat",
>  		.seq_show = memory_stat_show,
>  	},
> +	{
> +		.name = "stat_refresh",
> +		.write = memory_stat_refresh_write,
> +	},
>  #ifdef CONFIG_NUMA
>  	{
>  		.name = "numa_stat",
> --
> 2.51.2

-- 
Michal Hocko
SUSE Labs

