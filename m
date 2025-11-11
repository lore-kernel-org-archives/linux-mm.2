Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D298CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFBC8E0011; Tue, 11 Nov 2025 14:10:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7598E0008; Tue, 11 Nov 2025 14:10:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6C98E0011; Tue, 11 Nov 2025 14:10:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE12A8E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:10:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69D5556B7B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:10:37 +0000 (UTC)
X-FDA: 84099267714.08.FAC95F6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C771F2000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:10:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hcRQtim5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762888235; a=rsa-sha256;
	cv=none;
	b=7iqE9V2ss/2AaFHAx4747TW2kflkaCy9cUxWBXngXjB20sCjtYeHOI866c+4gaDPTTHE7n
	nXvUk42mTHjaRtVGsRyIm60WLgpOXUg/3TwdG09x/u9WxQww83HCArCF0ZRXPc0tPqpIoo
	GGbDfp/p+8xopuR3BM3J1pTghXRglQA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hcRQtim5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762888235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPREi96HvVo+XQknT5Z9IHpnSaxHU5ijbJjsijiZbCE=;
	b=4VN0Zbxg2bz8EmG44wFDXxt7oGrOnPIjo7wSnDvt7TdxPyp1uJ2aQfplcnPysfLussPPWt
	sLfhhWtp/ogX8oDaG+WCNqavhEkOFnwOWDT7Wk0WDPZcj+jFXSNBqO7Z/OHHy16ApeA98B
	cFDxzDKC7qOjFLH98zn2H0TdO+ncyE0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762888234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPREi96HvVo+XQknT5Z9IHpnSaxHU5ijbJjsijiZbCE=;
	b=hcRQtim5n2lL7D2ks8nzYQwKq1ptpJmkjZGxsHPo0jZtqwbqRODLDmmPaeLnUU6n/jyEFO
	3ovkGp8RPlx3FEIE1YGuYvvQGpcX+08QIIwazZQEjDnK3Iv/Db/iBdPzW9rFr9iXp3KvnR
	5QnbvPpLRSPd8PbCcmlCLim02GtySNM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-mTaaFqh4NvKw0j5h4VYlTA-1; Tue, 11 Nov 2025 14:10:32 -0500
X-MC-Unique: mTaaFqh4NvKw0j5h4VYlTA-1
X-Mimecast-MFC-AGG-ID: mTaaFqh4NvKw0j5h4VYlTA_1762888231
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-880441e0f93so6018846d6.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:10:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762888231; x=1763493031;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bPREi96HvVo+XQknT5Z9IHpnSaxHU5ijbJjsijiZbCE=;
        b=R5n/ht1dSObrZKxTsMOyb2R0YiGkL0S45Oln0cwd3A9WcZz0z1M/bTUuu3Df5A7Ev3
         OluqPpaFpD3Kdg5aTG9Fpyvo7/SlYsvJejJRkg5hEQTp1QPCV+RlGmYCENTAEykm3bMc
         fDVbHLW7ssfcWXbHLxHwa8t04LyPAhIyxfGDU3yNoOPw8RRwO6WCgoqY58/QaD6Bs/uA
         /buRXZcz4V0XSui6/PCZqo688geMKHqfV7HXzHWIA/9MxEkPxhPiq13wKSr6lQW/Qo5S
         Ngme7JhzVyqD3U41z21wx9VURCcGhXuU7jB4M3/yvj1dqkPSq9hU9s8jLiEGZOC9jeNZ
         wZfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQCpRJMG/BNOFG/bohCZ0qKll69jSzbYkI+CF912XdRoeioE6vfCi8gXi8//cNkmqA3bMii0l8PA==@kvack.org
X-Gm-Message-State: AOJu0Yxp+trMei4gkFc98sZ5RSJ+zumV+iiqvnYrrOgTG3nD9jDg2Bmn
	kOACDnxTQXNlpUtKSs/frz/+5CrkwwmgDrFdBbpYMNuBnZuE3H0c71goWlIjllulCnEQB4n2Lzs
	kkJr8HlPT0KhA8F6GtCi50U0ThDKyOp2BOup6TUAFDvEqL+iwVqa0
X-Gm-Gg: ASbGnct8xLhT+TGSNsm94h+vynZM8NE4b+GHX9q0tn+L9PjlkbhstdviSvJeIW18yZM
	agEdXA0qktDo4UvOJRifa1ZKmsa6t64qHhuzMvCLVp1FOVrQMnVchzNsQALsInywjsZhr67ipjW
	O/J0wQYFlkuNzqkBKs8doU+qU8rQL9zhfWa12LG0++cpVmC6xIYQ8xJ7o1j9gJ6AHUyhBZ0M18i
	KJc16ccCJEmzKevCG4y9gVm8SaOy4RnZB4f57eMoTH/KWJT5GXrUkjxYAyufPlIbfvlO8qTYVIC
	4iciRanPX8UAhtQr4dsqS+kdnYAOVxSJ/F0T5J/lE5lkVKiMmFdtklq/eRqxoC47Nr6eyKBg5aJ
	xlShu0dOLJARkDcaBuL/l1NZySciiIUkcemB2Hy7qtN47cA==
X-Received: by 2002:a05:6214:dcc:b0:880:4f25:588f with SMTP id 6a1803df08f44-8825e77bb91mr57855196d6.2.1762888231338;
        Tue, 11 Nov 2025 11:10:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IERrfZKlHqSH+9nPVlyhu9zwA9R8Rh1ZQplboV+7tsbpDRXGv41OROdDsYHxXClbz2KGfbjZA==
X-Received: by 2002:a05:6214:dcc:b0:880:4f25:588f with SMTP id 6a1803df08f44-8825e77bb91mr57854706d6.2.1762888230834;
        Tue, 11 Nov 2025 11:10:30 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88238b7528csm76619596d6.46.2025.11.11.11.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 11:10:30 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <9a9a2ede-af6e-413a-97a0-800993072b22@redhat.com>
Date: Tue, 11 Nov 2025 14:10:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
To: Leon Huang Fu <leon.huangfu@shopee.com>, linux-mm@kvack.org
Cc: tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, joel.granados@kernel.org, jack@suse.cz,
 laoar.shao@gmail.com, mclapinski@google.com, kyle.meyer@hpe.com,
 corbet@lwn.net, lance.yang@linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
In-Reply-To: <20251110101948.19277-1-leon.huangfu@shopee.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PbzjhsnuFOUIAJoZYjFiuoBLT2im6fT750r1Pos6mmE_1762888231
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C771F2000B
X-Stat-Signature: h1pgw4dz9xnz1cctarr1dg7ut6zte9hy
X-HE-Tag: 1762888234-214957
X-HE-Meta: U2FsdGVkX1/lsXrSfHpXImKIfNi2+PQIH4PfC/V2HPH1Tuu8QeHpjOWGYHlba439XmIQpR0m1sG5IfeWLTy0925S3jYdw8vTVlYM7ykNLNNqBhZC1ILBtja+OXVmoMtRmqDw8B3X/ZaFohpXEYOoiXV12RHF7rgJBLKQHxJfXFoV1kUbeDZhFiM8OIsML9noTSqt9o1O3EZE7CweeNWknMankdb9NsARq2l8zq1goDX7055Y6tGlB94zsYZKKotuKEPhBoMB4PbjgnIgrKRtwEhceFx/3cC1aihVpQ8xci/C8zWLVbsiX83M+zNjTw3L+ykuaz754HGE1c3J/bJMqyrLpJpfO++i5Ap1cQ+aqwiN80gAPStMThGt3iOCbL1PVPaemrc/9sat2hQJ99u4f3AJWMYqz0+fwAQH8C4nsAALdCDwNdyEIey5PhMvE3PXMuz3y+IAOhd86+O19UHuaAM5tbGQKWMv2Ykn1LMxAH7HgQO3K3n6vi3R1wS9g63Uh6eAq019QT+sQFiRvI4J1yyQU/mbUYII1b+4P1RbiU1sazI9+cHxti5U5J5m7+jx2nl9m7rGA6DRl2avLKvrkcWnGAsHnwp+tg7P46cyFwtyPaYsr7oqyRNPUDVIs0HqbqpwNaiHNxooYFnhg1qAHlRoa5zyLi20mtIaNV30PyJarQUrUuxlz8oAcyDnH84PWWQu33JZ7WVLQ0j+vLIra1JMior/S9de3CHJCjFHIy7+ERnw237j+8NBqvPg4scGRNJ0FQ2FIORHRYAe+ItGHGXNfPoZEHgBIsHBQNzz8vBJYeDFbkZvOxO9+p2c+l5K9fBHBcAbF2MC5tuSODDQURkTuXYauI3ck21sRfyvXjyvsVTqWbyNjTOz9h9lyqAgps3ABsiTBWpkkRLKuABmR+CcVEPO3VyHjxgCwadFin8rNRnr9Nx3S7XQX7zFAG/RXmc86vog2KFJI03VP1X
 XAWIEEwY
 Qb80b4YgVDooKwXM0HVUsZ0JmOBHWbYcPZQBvTF7Q70CSaEwyVuebUj3CBpjV8FflCc81FuyWYK9B0wqMtT+unsAtTMV7SB0l4HTUTi1qldCbjXjXftbLDtHFodytXwE35K8haNBuivPSwSPXJhftPbxuetzAFu4HK2B50QAwzR7Os9tZ72ffom//kZP+qWNdq599Hut29cDIx+vxGvFCr6NHkZ+dseYDhWwLJYcCOSw2YWQ4bulfyfdMD/2dfuejL/PCxxN9Odleax9bxW0u6RordPEL8j/seqclP8r7jfLHPbkbqUWnR6mwaFMWBMRZ1UpgUBz7axlWEA/MLStTxN5gVIl9cNN789Ba2V59LWnLSDHdXKJ7kurrTx9pmvka4qT2bIyx3IZ7dhuQLFZaUQzo7JmgotZZmqpXvHVQfiYafT03gbAL00bO3kf2md5dr0G5bgb32c9m9FnN1H325uxg1AQtkmis+tYhSEKUVbqrcSOBa1Zoz/ZZI1QXnh5SQPD7/FhB+CtqO8qJ1qpvFaB5ickLNOY8Jk37Laz4XTLbgvAarAwnm4CTmy0VQcp+sJadu5smvvxT1gu0fSbsMLnSODFUGbX8//vRHQusTHFRSQNsCLVF3d1m30FyN63Q3GpcjJi9xyO3BuH4OZlKKNdQC151XuBcpjTdhwxB5e1uGt8F0yuoZIqBpL2tdaHhQBFAAU+LWevvvR/RGYmD1BGVaaRaB4DN9oDAJr1V5+CgkG0umdvnIQwBWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 5:19 AM, Leon Huang Fu wrote:
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
>    echo 1 > /sys/fs/cgroup/mygroup/memory.stat_refresh
>    cat /sys/fs/cgroup/mygroup/memory.stat
>
> The feature is available in both cgroup v1 and v2 for consistency.
>
> Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
> ---
> v2 -> v3:
>    - Flush stats by memory.stat_refresh (per Michal)
>    - https://lore.kernel.org/linux-mm/20251105074917.94531-1-leon.huangfu@shopee.com/
>
> v1 -> v2:
>    - Flush stats when write the file (per Michal).
>    - https://lore.kernel.org/linux-mm/20251104031908.77313-1-leon.huangfu@shopee.com/
>
>   Documentation/admin-guide/cgroup-v2.rst | 21 +++++++++++++++++--
>   mm/memcontrol-v1.c                      |  4 ++++
>   mm/memcontrol-v1.h                      |  2 ++
>   mm/memcontrol.c                         | 27 ++++++++++++++++++-------
>   4 files changed, 45 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 3345961c30ac..ca079932f957 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1337,7 +1337,7 @@ PAGE_SIZE multiple when read back.
>   	cgroup is within its effective low boundary, the cgroup's
>   	memory won't be reclaimed unless there is no reclaimable
>   	memory available in unprotected cgroups.
> -	Above the effective low	boundary (or
> +	Above the effective low	boundary (or
>   	effective min boundary if it is higher), pages are reclaimed
>   	proportionally to the overage, reducing reclaim pressure for
>   	smaller overages.
> @@ -1785,6 +1785,23 @@ The following nested keys are defined.
>   		up if hugetlb usage is accounted for in memory.current (i.e.
>   		cgroup is mounted with the memory_hugetlb_accounting option).
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
>     memory.numa_stat
>   	A read-only nested-keyed file which exists on non-root cgroups.
>
> @@ -2173,7 +2190,7 @@ of the two is enforced.
>
>   cgroup writeback requires explicit support from the underlying
>   filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
> -btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
> +btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
>   attributed to the root cgroup.
>
>   There are inherent differences in memory and writeback management
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 6eed14bff742..c3eac9b1f1be 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -2041,6 +2041,10 @@ struct cftype mem_cgroup_legacy_files[] = {
>   		.name = "stat",
>   		.seq_show = memory_stat_show,
>   	},
> +	{
> +		.name = "stat_refresh",
> +		.write = memory_stat_refresh_write,
> +	},
>   	{
>   		.name = "force_empty",
>   		.write = mem_cgroup_force_empty_write,
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 6358464bb416..a14d4d74c9aa 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -29,6 +29,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg);
>   unsigned long memcg_events(struct mem_cgroup *memcg, int event);
>   unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
>   int memory_stat_show(struct seq_file *m, void *v);
> +ssize_t memory_stat_refresh_write(struct kernfs_open_file *of, char *buf,
> +				  size_t nbytes, loff_t off);
>
>   void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
>   struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bfc986da3289..19ef4b971d8d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -610,6 +610,15 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
>   	css_rstat_flush(&memcg->css);
>   }
>
> +static void memcg_flush_stats(struct mem_cgroup *memcg, bool force)
> +{
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	memcg = memcg ?: root_mem_cgroup;
> +	__mem_cgroup_flush_stats(memcg, force);
> +}

Shouldn't we impose a limit in term of how frequently this 
memcg_flush_stats() function can be called like at most a few times per 
second to prevent abuse from user space as stat flushing is expensive? 
We should prevent some kind of user space DoS attack by using this new 
API if we decide to implement it.

Cheers,
Longman


