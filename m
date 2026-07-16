Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71990C44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 01:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4C76B0088; Wed, 15 Jul 2026 21:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C946B008A; Wed, 15 Jul 2026 21:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD7C6B008C; Wed, 15 Jul 2026 21:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 887296B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A5B7A035F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:20:11 +0000 (UTC)
X-FDA: 84992883822.28.D4DED43
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id B6C991C0002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:20:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fevypTON;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784164809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ef5fK1C/u5JKytDn0JDImp821HrmWjkSDu/2fR1IAU=;
	b=nCNicHjCijvG/dzJPyConC2RvcfH934MUyP+gYS3Fpc8OenPxZGBB3qL3rQSQUomlhDtIZ
	HvQdfoMac6h6o9Lqkemv3MFS78Q3P3TDeFoL5xHs1RAOjN+q/tmKgfzGMGuS+71XqaYpy4
	hr9WLFKbYztlf4kkYC7TOQdnHejysro=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fevypTON;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784164809;
	b=pHuiwLwTRzVebayaE+3SAW5YD89USlJjaL2d+rYCSPSuAAw1ErTL9DAOFnVhfl4Al6bEcp
	BxI2r+RZxMkO1L8xZnKUpxNYI2vWtjGwKq6+bsrAsi43CnLyzN8pyQgLFkEJ/E5w5LIabb
	u8KuS6bK2YAdalyCo+zK+cKxrwefqxk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784164805; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/ef5fK1C/u5JKytDn0JDImp821HrmWjkSDu/2fR1IAU=;
	b=fevypTONIV9LwOZJ/VK5N0hWUCwQY5bMw+aWTqBd+i6T37KD3a/ehszGfM6QnTmCQDA6RoJQYC+uD6Y/WmK2ph8VFDLqNcsR15UT+EppBZcpjFkV4bwlyUSc0IzH1qAxapVjosfNcBYD9AXkzduOSV/Ztp080GCmlL8odsa1jNg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0X7AlBuV_1784164802;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7AlBuV_1784164802 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 09:20:03 +0800
Message-ID: <09771ca6-2869-4028-98a8-5d6614b48301@linux.alibaba.com>
Date: Thu, 16 Jul 2026 09:20:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into
 individual filesystems
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
 dgc@kernel.org, qi.zheng@linux.dev, brauner@kernel.org,
 cgroups@vger.kernel.org, clm@fb.com, dsterba@suse.com, hannes@cmpxchg.org,
 hughd@google.com, jack@suse.cz, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 Al Viro <viro@zeniv.linux.org.uk>, kernel-team@meta.com
References: <20260715103516.2410175-1-usama.arif@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B6C991C0002
X-Stat-Signature: 7cffskyfbobtmthnsgykghajndst11g1
X-HE-Tag: 1784164807-989325
X-HE-Meta: U2FsdGVkX19T+0UxZmzTCmfOoHtXSd1KDeL1o6liKb0rlthARcfIe2CL0JGh7r+fZ5aqkqJuW1lJqF8udYdZg8dsCMA/PEv8NWrkmJd6IVL1JDT6CtkKB2xF6+ILW1Ta1pFuuaNLp7+nQYBZFxGSiguZzu/HZsPf/qZbbzvO6n39VTGcsgtbx9+Xl6nTjyzC0WWMvADWXo0aHq18Lr9AQaAcLHMaBA/c+Du5s2OCdrTCSLDWHK9XI2HVM2mwhD754QgVayVTaqhziavfW/rKDl1b1/Tf6cg2qtrLp9fzseEC3H81Msbd1i+flVVpODxpdj/VEVyiXdsDktg31QsRigL0MlCB1crwO2bKGgBPSt/BLxrQ24KrDiTC3aYkEfI3aGqXey/C+eN/9GuUE4/MeWhqulqQwmROGPCF6m8m2St5ie6bL02pOAgGW61dOnVJJG80MJiSoHO/MorlrUDaYoTIsW9UjoEQE2XY20ahLvYG2r7xWa9thfr9lsSHFtc91WoVfVvFXMffj6ezvVo/R4Q/uL6ICpFKHViYp6Ic9o9jBETWrRz8RFcooVQVMJQHRR/H3GcD7sLpkdc1I+ckBsxzsEIv845Kkon2vjpARHxnjKt7AVhkq7tuVEjyaLL7VYQaMrmhAi8yDwg44LaK1hqsre4tdJgoJc43frFUtFe20NxWIK8phDJN4zfZxJn341wyasOLerjgyw2rc7i52bVDzrPxlamhXsXHl5H1C7GX4NoQ23J0HKg3Z5rzFBUlOdPB8JWE2NuSKDFUUTmh3qj8FPToslAXnS9ijsN0lcZ4Gdug5iDXYBQEd9HtTSZasp+LccRQmCEFOmWw56Rdal8eD8EK4XdlYipsbElo4pV87heqK8N/exVmXOS09sMvZ9ENetfNw0Ef6Ts9n0XtBYKKqzMqOQTCJ9nqjgM0nPNlZRygiSzKRfTuCNFnTsOu04jMS+5PEQsVKc3hths
 tn3tvDrG
 kcxvCr9hxmb7AAcc0AR9wa47uFAOPIk0bpuxhIvnR/Vy3+kjOgPZzAe5NsN5mKnXDx61Ugg2Oc2cxftqCRkVv4TsujkJo/O728vJy3kTghGNrFym/S3a64B53RZjUFNUJq241oGb7HxNK8mhUaVEM0Ls8wrltY38x3fAdPARpLLy1ywblhDgujPQutxwizxDABZWFyrvP8VHeqWk3dl26Y63AeDM6XTtBFCuEyu1h2Wo1FfC+N8+2nV1uS+jAdsHsdhg/v/SSpVOu0hDSFAeoFlJGuKyEJ9+zebLqdCJL8MhSO7CqwT86b6EC9qIWsIE4dsch0Oin2gUlrsXrks6IrsqfgOFeRgsNVtwq3js1tYd2X+5jDc4D6iePI6F/Rxnr+BYp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/15/26 6:35 PM, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skipped every
> ->nr_cached_objects() hook whenever the shrinker was invoked for a
> non-root memcg, on the assumption that none of them honour sc->memcg.
> 
> That assumption is wrong for XFS, whose inode-reclaim hook is
> intentionally driven from per-memcg contexts to free memcg-charged
> slab. Encoding a blanket "never memcg-aware" policy in fs/super.c
> short-circuits that path.
> 
> Push the check down into the callbacks whose counters really are
> irrelevant to per-memcg reclaim - btrfs_nr_cached_objects() and
> shmem_unused_huge_count() - and drop the fs/super.c gate. Each
> filesystem can now lift the restriction independently if its counter
> later grows memcg awareness, without touching fs/super.c.
> 
> Introduce mem_cgroup_shrink_is_root() in <linux/memcontrol.h> so the
> callbacks don't open-code "sc->memcg is NULL or root".
> 
> Fixes: 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink")
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

[snip]

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e1f46a0016fc..5407e4200460 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -520,6 +520,22 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>   	return (memcg == root_mem_cgroup);
>   }
>   
> +/**
> + * mem_cgroup_shrink_is_root - is this a global or root-memcg shrink invocation?
> + * @sc: shrink_control describing the current shrinker call
> + *
> + * Returns true when @sc represents a global reclaim shrink (sc->memcg == NULL)
> + * or a root-memcg shrink, i.e. not a per-memcg iteration of
> + * shrink_slab_memcg(). Filesystems whose ->nr_cached_objects()/
> + * ->free_cached_objects() implementations operate on filesystem-global state
> + * and do not honour sc->memcg can use this to early-return 0 in per-memcg
> + * contexts.
> + */
> +static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
> +{
> +	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
> +}
> +
>   static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>   {
>   	return objcg->is_root;
> @@ -1071,6 +1087,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>   	return true;
>   }
>   
> +static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
> +{
> +	return true;
> +}
> +
>   static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>   {
>   	return true;
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5789a0f5a346..dc8cd4f563f4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -846,6 +846,16 @@ static long shmem_unused_huge_count(struct super_block *sb,
>   		struct shrink_control *sc)
>   {
>   	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
> +
> +	/*
> +	 * The per-superblock shrinklist is filesystem-global and does not
> +	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
> +	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work.
> +	 */
> +	if (!mem_cgroup_shrink_is_root(sc))
> +		return 0;
> +
>   	return READ_ONCE(sbinfo->shrinklist_len);
>   }
>   #else /* !CONFIG_TRANSPARENT_HUGEPAGE */

For shmem part, LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

