Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD3BC61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32CCC6B009D; Mon, 31 Aug 2026 22:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE036B009E; Mon, 31 Aug 2026 22:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD006B009F; Mon, 31 Aug 2026 22:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E09AB6B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:26:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56F211A0299
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:26:08 +0000 (UTC)
X-FDA: 85163603616.05.FF21357
Received: from mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	by imf31.hostedemail.com (Postfix) with ESMTP id 53C7720004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:26:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eK2bNcqD;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788229566;
	b=LBke2hNclEXJriqxfHL/TdyrB3ckx58hcrB9IKjmtjhjfQCLsKCzGx6RfJxCSodMtVIGW3
	VkTzHCQPYvGkE8kLo5IsLrX4pQd+rcGcjeu6eFZZPW7Cp7flVQikMIvFSEkIh9MlOUqdDB
	rWhemdFTJhROuq1oVdJOjCeakz95nT8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eK2bNcqD;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788229566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7MSp7C0Kbq8UTCVi1d+4KGHW/VjZMHEybIboyCuRfA=;
	b=thg4+eOgXVU+u0IYmxMcIsezkcLf2Mm81Y7t+idEj8Os8lSzD+Vk2fWuskV4H2vhwdwvgq
	QDVD7wAjo5lp7YoIh2MT2FZL+RLWHMURvSLaLggLbSyxwzdsrSL6o4SaIvctZtMdZIEiCj
	k4Z+k0xtBFRTNklvf5naJG7pGN+Ir3o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vM4ijJrAqrKJgp4ES8M9TJJbW0Vk7gw6kwz+ZDDvvJk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788229564; v=1; x=1788834364;
 b=eK2bNcqDHpvc1Nu+jZjxFLplZmuBMkyksPobxop+IfEAY5idHgRx/hvuJU+OgKsg544n+9cl
 ZM3winv0F9Xu2zejXJYR2T8U/C9kMvBOO9/riYsrUVl066XYxTXST3nKzQefsRw8c78g1IX+q94
 3ciZouNw5ce3aHpL5hodeIEY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ffc1d7bc8b38b6b0;
	Tue, 01 Sep 2026 02:26:04 +0000
X-Mizu-Trace-ID: ffc1d7bc8b38b6b0
X-Migadu-Flow: FLOW_OUT
Message-ID: <6aea8093-54ee-49f2-916c-09b2c6587f20@linux.dev>
Date: Tue, 1 Sep 2026 10:25:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] fs: fix missed removal of
 super_fs_objects_eligible()
To: Andrew Morton <akpm@linux-foundation.org>, usama.arif@linux.dev
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
 <3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com>
 <20260828114129.909edbfb7e42b36af2da6a98@linux-foundation.org>
 <eeae0d48-4d50-4dd4-9e16-b4f9902d84f4@linux.dev>
 <20260829162350.1ee9e17d71a297b06b171941@linux-foundation.org>
 <c1ad6e39-3b21-413c-ad02-f90cfc4102f9@linux.dev>
 <20260831192143.84da447c4fa2afb60757afa4@linux-foundation.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260831192143.84da447c4fa2afb60757afa4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ok3f9yi99wuo9odr4bxokf8n1xsx1rme
X-Rspamd-Queue-Id: 53C7720004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788229566-922161
X-HE-Meta: U2FsdGVkX1/dbpOvEcjdm+HR7UJjpUBbzkevejuFL1hZv4GWgFjthe3d5kzBbFQUGKaM1LcDXHQ7I/e4OLFqFSj9Cx1rJ28NYbO/+XyPVcHhy8MetYT72W5N6Iz5RhRavNYYeI6ZG45FlS13ou9EaUkwvLlCrzgmIHeQTmsTvrVqylUMN3bCt3IZZsYIBequqBDcxLdd3r4x6lkhTsJaEhE3X0KESnvwwOBtLzISdF/Pcm7Uxz5vMERDdLbl2Fi/WOc8fLHSG3SpaZI6vUfkbcNrzf6mMl0+MJZ/rdsi/k9OQYHAjbYltyExKl7tsPzf2ML6FYQkJWdvijYXRg+nwTQcJDXe6KMp3cO7g6R/mKehbnC3Hr3uUe5ZT4VI90s/xoGO08V60D0aDc42YtEovSHlgASnznnPRhuRVnuO2zBsAdPzqJGFXxmpCSViKAOP2rG93Os7yKZ0lDyCryp3YLEc0aYY7NvVtEoikwrYDmaGslOY3il4kP0+7pmuVi8zuLy332qomilJYCtFZex0fQc9umWXvu8v0AuTLZV8gYBBu315VamItleJ4XwTSCdD/T95F+l17mN0gJyy6bWVlLaOV12bp3oUKf0Rhpa+MzinRNlSZMrahmTQDkxhzqVFVEQKfKyCGXTTuP0uEprtCKk5yyhnWCPb4twM4L2Bs/uOqC1PAmPwc/pGHAhqqb+StgSE+Sa0IEoH6jyPduxdO+xh7/N99Tu3JBZw2E2FPmwAQ1PVUwEy1GlnrMHwxYQUEm7U0WdYnxKdvFeTmx/fGy5Xirlxz1vNi9qO04kczxK8siBkoyq2263ZxGpq5JxEpXnTnjyBHvL0GEYupTS+np3xdGUbQDeoTc6RUNBixS29sSj2/75yRbtiuggzpalOVl368qPTEDissZ8hTxW9eDDLZysjkgocQikbZ3muglWgWXxMnr5oW8Sg99V+jRXEmOZ10AZpIsSvWDSv+Vq
 Mtojl8po
 1agvP3bbwlU8LzgtB64K2xHvJNCLrupxyGwtCu9Qk7s4OdcllAoykuGsrwcNXRML4GpasKCswtkifmt+Wn7XJoeniqNCa320VNPh05cmwwJL3TIBLNVh5y3rXRwjo6Cf0hr7HF5XuK43ZTjr8AmRwGqL9uSX+wswx3ct7CyRB4//qEvgrmYmDQFTIu8jbRkv+CYGPG88DLXYM+Vd7uPyR7N6lNV0Wku//lHYIPa9cLbfgAZJmFA3fxS1RHHZbEKv0C7oOC4pBzPP1DR6PfRk+tPvq53bVNnLxca9Hr62myy1p641aXAWoj2qKrTnMyGX+jcVbuZWvNhAor0DR5gVhm4QLCM08u98zqcKEkGVveL9OKxPpkGZNMBSNK4CxlqOLcp8yn3KoqPif2ZIScIODJmpxK0z2E4ZaGwj35pvBviuFxaZhrQhQl7tV0jtGu25V1zBkNGH018qzL6M1S0suDzksnHrJyoSFraiVkopwF/QLyxecwM4Fqo9X+cHXPv+o7Hm83NOVyJcUe0QyXy/qIosVJD8/2stJ+XtbruX7LGWm+YikSIpOG7kzsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/1/26 10:21 AM, Andrew Morton wrote:
> On Mon, 31 Aug 2026 10:28:00 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>>> OK, please add this info to this patch's changelog.  Please also decide
>>> whether a cc:stable should be added and if so, ensure the changelog
>>> makes clear why we're recommending a backport.
>>>
>>> As part of this, let's expand on "XFS will also run into issues".
>>
>> How about this instead:
>>
>> ---
>> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
>> individual filesystems") was meant to drop the blanket memcg gate in
>> fs/super.c and let each ->nr_cached_objects() implementation decide
>> for itself whether it is meaningful in per-memcg reclaim. However,
>> when that patch was applied the removal of super_fs_objects_eligible()
>> and its two call sites in super_cache_scan() / super_cache_count() was
>> lost, so the helper is still gating every ->nr_cached_objects() hook
>> and 0ef8faff490be is effectively a no-op.
>>
>> Consequences of the leftover gate:
>>
>>     - XFS's inode-reclaim hook, which is intentionally driven from
>>       per-memcg contexts to free memcg-charged slab, is still
>>       short-circuited in fs/super.c — exactly the regression from
>>       commit 0baad6f9b997 ("fs/super: skip non-memcg-aware
>>       nr_cached_objects in memcg slab shrink") that 0ef8faff490be was
>>       written to undo. Memcg-charged XFS inode slab therefore keeps
>>       piling up under per-memcg pressure until global reclaim kicks in.
>>
>>     - Any future ->nr_cached_objects()/->free_cached_objects() that
>>       grows memcg awareness is likewise blocked before it can run, so
>>       filesystems cannot opt in to per-memcg reclaim on their own —
>>       defeating the whole point of pushing the gating decision down
>>       into the callbacks.
>>
>> Drop the leftover helper and its call sites so the intent of
>> 0ef8faff490be actually takes effect.
>>
>> Fixes: 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
>> individual filesystems")
>> Cc: stable@vger.kernel.org
>> ---
>>
>> Can you fix up the commit message directly on your end? Let me know if
>> you prefer me to spin a v5 instead.
> 
> Thanks.  I pasted this in and turned your [1/4] into a standalone patch
> for mm-hotfixes, with a cc:stable.

Thanks!

> 
> The remaining three patches I turned into a separate series for the
> next merge window.

OK.

> 
> This particular patch has no evidence of reviewer input yet?

Hi Usama, could you please help review this patch?

Thanks,
Qi

> 
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> Subject: fs: fix missed removal of super_fs_objects_eligible()
> Date: Mon, 17 Aug 2026 17:03:25 +0800
> 
> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
> individual filesystems") was meant to drop the blanket memcg gate in
> fs/super.c and let each ->nr_cached_objects() implementation decide for
> itself whether it is meaningful in per-memcg reclaim.  However, when
> that patch was applied the removal of super_fs_objects_eligible() and
> its two call sites in super_cache_scan() / super_cache_count() was
> lost, so the helper is still gating every ->nr_cached_objects() hook
> and 0ef8faff490be is effectively a no-op.
> 
> Consequences of the leftover gate:
> 
>     - XFS's inode-reclaim hook, which is intentionally driven from
>       per-memcg contexts to free memcg-charged slab, is still
>       short-circuited in fs/super.c  exactly the regression from
>       commit 0baad6f9b997 ("fs/super: skip non-memcg-aware
>       nr_cached_objects in memcg slab shrink") that 0ef8faff490be was
>       written to undo. Memcg-charged XFS inode slab therefore keeps
>       piling up under per-memcg pressure until global reclaim kicks in.
> 
>     - Any future ->nr_cached_objects()/->free_cached_objects() that
>       grows memcg awareness is likewise blocked before it can run, so
>       filesystems cannot opt in to per-memcg reclaim on their own
>       defeating the whole point of pushing the gating decision down
>       into the callbacks.
> 
> Drop the leftover helper and its call sites so the intent of
> 0ef8faff490be actually takes effect.
> 
> Link: https://lore.kernel.org/cover.1786955972.git.zhengqi.arch@bytedance.com
> Link: https://lore.kernel.org/3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com
> Link: https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/ [0]
> Fixes: 0ef8faff490b ("fs: push nr_cached_objects memcg gating into individual filesystems")
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   fs/super.c |   18 ++----------------
>   1 file changed, 2 insertions(+), 16 deletions(-)
> 
> --- a/fs/super.c~fs-fix-missed-removal-of-super_fs_objects_eligible
> +++ a/fs/super.c
> @@ -172,19 +172,6 @@ static void super_wake(struct super_bloc
>   }
>   
>   /*
> - * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
> - * operate on filesystem-global state and ignore sc->memcg. Driving them
> - * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
> - * per-cpu counters and queueing duplicate work: the actual reclaim happens on
> - * the global path (kswapd or root direct reclaim) regardless. Restrict them
> - * to that path.
> - */
> -static inline bool super_fs_objects_eligible(struct shrink_control *sc)
> -{
> -	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
> -}
> -
> -/*
>    * One thing we have to be careful of with a per-sb shrinker is that we don't
>    * drop the last active reference to the superblock from within the shrinker.
>    * If that happens we could trigger unregistering the shrinker from within the
> @@ -213,7 +200,7 @@ static unsigned long super_cache_scan(st
>   	if (!super_trylock_shared(sb))
>   		return SHRINK_STOP;
>   
> -	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
> +	if (sb->s_op->nr_cached_objects)
>   		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>   
>   	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
> @@ -274,8 +261,7 @@ static unsigned long super_cache_count(s
>   		return 0;
>   	smp_rmb();
>   
> -	if (sb->s_op && sb->s_op->nr_cached_objects &&
> -	    super_fs_objects_eligible(sc))
> +	if (sb->s_op && sb->s_op->nr_cached_objects)
>   		total_objects = sb->s_op->nr_cached_objects(sb, sc);
>   
>   	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
> _
> 


