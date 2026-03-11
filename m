Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF37103E2E8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 22:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C686B0005; Wed, 11 Mar 2026 18:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A286B0089; Wed, 11 Mar 2026 18:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D264D6B008A; Wed, 11 Mar 2026 18:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C31596B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:14:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 535DF160448
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:14:34 +0000 (UTC)
X-FDA: 84535187268.10.799D595
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C146A20003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:14:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ttVI0Ffm;
	spf=pass (imf13.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773267272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1diyUXtofsL9Kv4UTes8svJlVam6hmtTVTZIlcFE+zw=;
	b=YI7Ew7Wp9ei/p39ZPUQiHTGAXIVdmRgzb9TBOx1LjMdw7g6uAvS8aGv2qJGfFP2Arv+VmF
	rcWgWlAk07miMzazGbMOrrEqFanHsjByvmpLpkd0hBnnfYNiaqob6k5yfI8TzrEMmJMMSR
	DWXTjWa6lxWwtFJebGblEaBkzLNdCv8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ttVI0Ffm;
	spf=pass (imf13.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773267272; a=rsa-sha256;
	cv=none;
	b=MN2UDWLRR9mTMsa06mrkrftLmsfQsRu+XTCxLQ0OwkW6wBu05GrGAalSF0k24bFf0O+s2j
	39H7TRRxZVMQToihO2bep63rYQcc4FGXKJzvauHJnzR5fzOy8TElFa8FN5zPu/p+/j9noc
	o5hBU3udpehcN0lU66Z8qK6D5XeI3m8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D29C6012B;
	Wed, 11 Mar 2026 22:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D563C4CEF7;
	Wed, 11 Mar 2026 22:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773267271;
	bh=SMRLE93kEGoA+0MBMPBBavmrc0muc9ghbk1j6trheEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ttVI0Ffm1g/2TdOemBet/emqBxMQgWvHKTRuu4ukXnctx1IqMRKPHmOGA3Zx7aTSv
	 TsJjas2SDs+WHHSdglXv7I1Yccw6DC121au7ytFzFieWlanmw3Wz7qOFSWVkYaO7ed
	 bMhVg8vwkuSsVjP0ZdGO2Qf/6HJL/EVKVWYNWXgtnSFh3Q/ph67nGq6DdHpFLqpzfq
	 6i7ZX1fNdfPSHX26KBunLUjwIO/22JwFDLYOZLzoNoszw8YQwDbABTqaCrN+OnmJJz
	 comK+ItGCJvbbsETmKfcw/vtUnJ66UO1SrjfX2Zgvyay4/V/AlQ3ZaV+/46kPpHszI
	 oBt4Jhb0xtcSA==
Date: Thu, 12 Mar 2026 09:14:20 +1100
From: Dave Chinner <dgc@kernel.org>
To: Haifeng Xu <haifeng.xu@shopee.com>
Cc: akpm@linux-foundation.org, david@fromorbit.com,
	roman.gushchin@linux.dev, zhengqi.arch@bytedance.com,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/4] mm: shrinker: optimize the allocation of
 shrinker_info when setting cgroup_memory_nokmem
Message-ID: <abHpPC8tWwU93C1D@dread>
References: <20260310031250.289851-1-haifeng.xu@shopee.com>
 <20260310031250.289851-4-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310031250.289851-4-haifeng.xu@shopee.com>
X-Rspamd-Queue-Id: C146A20003
X-Rspamd-Server: rspam07
X-Stat-Signature: 65e6jhigdbikhhbicu51n44ax3ejo6hc
X-Rspam-User: 
X-HE-Tag: 1773267272-569630
X-HE-Meta: U2FsdGVkX1/liji6NwUZi60fKUTnwAHTLcXAzFy8q26LSwYmgOyPssV3xnLu3yO+Z9EV4MXReP/tkuFqx8VrK4mBjddtg+9giKsdGSh+3eXIvQZCmKAEAfHxRVmc2NqXkrD5RRQTTx83IaAzkejoC5LpvLORsSU/tyKKhrOAEb6I+kVPpkYgZMpWFaB/A+97ybQQPQBJMaaWXtfmWaD1hh4xL3AFMjX56gYZMsqNYSGxhTx4ceFxahrgWchRFCcvkWjiXdfkKyQ7+Di8BbPUwz6lgWEePHBWl6x8a4Sg3N1wbsJD/y0QbMnhKo93Y+Nt4iP2i7sSrUT57+mxQmXMXQcPhOBVuQLBCv2fbFyB96rm4y3Fsv9bd2fEPPkeE2tFr6E6s6KQuAzlC0CLmJoB+T7ObbTfLkkjShuo2/1tyyZ0Sc0XhDg5XQ+tAYbOOQqSsSltbzuZ20MnPYn69r/sR2Ae6XvomQUHyP/t7EMqtcASFZSM6yVCAT3W9b21MGrFFdfJKZCKIAejmexJQNXcqEnbPbxn3LjZuEBeaA/KaNKb+4eRVV5jJy9ASlGhqT+GDJp8MC1uTcTl8OQ2QAw18JHY2Na7fOHsCEPFrhT2wnNQ6+o4pxCLALGSQqgbX9CcNICbrT5v4C/1/WImRhAfGfR6mtHn72NCB0VoaCNRGc4gcGs6FaJEcPHNxnk5tQOOxg3P5hvJaIcpfHP41Q0sAXz+xtor00cBKSj98xvVVB5IhrR5SLMXPdEv2xPZ3A1AmxHSdGwbFhb1WaEvZorsgOb95bnUJIkG7l4hYwkuICvbkbvr6qLMDPXlApEPijKE2IxwweoSxICSq4+gua+nb0PKfjbfVQI5yB26wcooJBpmuA6bDgBmV9ZbF0R7I61v0ztI9WHxd7mN4sNYvhZ1/9H+4G4OBoowJMqe344U0Gq2NsPB63tNAv1p9vMCylbIb85fml2K2rZqqHZcf1t
 9B0u1Cdk
 hCULgfDJIv1prgcOGGICtbDqxs0hUP6g+LI4ituVEkou7K3DH6T5UIjypoWOtv8w6ILuJGL9I00E8anBA5o1qPZctEXgx9bSur8vOTcSpHTCzOzd/zKKu1xfj5sJR0MkWumZvEvFJpKuDHLjxOusMAwUdiUoo8ao/rpXXEOU2RM3tzg2tB1wyVTaumDbazwjAe8yn4lECq7FZhPv+1Iku4A3LwquugJuVDD6NCkfX7IZnc3YFXX04Oq4aVS/kuyhaKUEpkISHlaDeAUqI3cTBJLGYqRBi3jzViTW0R9l8kWYlK9d6sYbCeXQQdmUl+wZnjv3AgQQ2nLakOeewvRzr8dXsgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 11:12:49AM +0800, Haifeng Xu wrote:
> When kmem is disabled, memcg slab shrink only call non-slab shrinkers,
> so just allocates shrinker info for non-slab shrinkers to non-root memcgs.
> 
> Therefore, if memcg_kmem_online is true, all things keep same as before.
> Otherwise, root memcg allocates id from shrinker_idr to identify each
> shrinker and non-root memcgs use nonslab_id to identify non-slab shrinkers.
> The size of shrinkers_info in non-root memcgs can be very low because the
> number of shrinkers marked as SHRINKER_NONSLAB | SHRINKER_MEMCG_AWARE is
> few. Also, the time spending in expand_shrinker_info() can reduce a lot.
> 
> When setting shrinker bit or updating nr_deferred, use nonslab_id for
> non-root memcgs if the shrinker is marked as SHRINKER_NONSLAB.
> 
> Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
> ---
>  include/linux/memcontrol.h |   8 ++-
>  include/linux/shrinker.h   |   3 +
>  mm/shrinker.c              | 116 +++++++++++++++++++++++++++++++++----
>  3 files changed, 114 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ce7b5101bc02..3edd6211aed2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1804,7 +1804,13 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg);
>  
>  static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
>  {
> -	return shrinker->id;
> +	int id = shrinker->id;
> +
> +	if (!memcg_kmem_online() && (shrinker->flags & SHRINKER_NONSLAB) &&
> +	    memcg != root_mem_cgroup)
> +		id = shrinker->nonslab_id;
> +
> +	return id;
>  }
>  #else
>  #define mem_cgroup_sockets_enabled 0
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 1a00be90d93a..df53008ed8b5 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -107,6 +107,9 @@ struct shrinker {
>  #ifdef CONFIG_MEMCG
>  	/* ID in shrinker_idr */
>  	int id;
> +
> +	/* ID in shrinker_nonslab_idr */
> +	int nonslab_id;
>  #endif
>  #ifdef CONFIG_SHRINKER_DEBUG
>  	int debugfs_id;
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 61dbb6afae52..68ea2d49495c 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -12,6 +12,7 @@ DEFINE_MUTEX(shrinker_mutex);
>  
>  #ifdef CONFIG_MEMCG
>  static int shrinker_nr_max;
> +static int shrinker_nonslab_nr_max;
>  
>  static inline int shrinker_unit_size(int nr_items)
>  {
> @@ -78,15 +79,25 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
>  {
>  	int nid, ret = 0;
>  	int array_size = 0;
> +	int alloc_nr_max;
> +
> +	if (memcg_kmem_online()) {
> +		alloc_nr_max = shrinker_nr_max;
> +	} else {
> +		if (memcg == root_mem_cgroup)
> +			alloc_nr_max = shrinker_nr_max;
> +		else
> +			alloc_nr_max = shrinker_nonslab_nr_max;
> +	}

What does this do and why does it exist? Why do we need two
different indexes and tracking structures when memcg is disabled?

If I look at this code outside of this commit context, I have -zero-
idea of what all this ... complexity does or is needed for.

AFAICT, the code is trying to reduce memcg-aware shrinker
registration overhead, yes?

If so, please explain where all the overhead is in the first place -
if there's a time saving of hundreds of seconds in your workload,
then whatever is causing the overhead is going to show up in CPU
profiles. What, exactly, is causing all the registration overhead?

i.e. there are lots of workloads that create large numbers of
containers when memcg is actually enabled, so if registration is
costly then the right thing to do here is fix the registration
overhead problem.

Hacking custom logic into the code to avoid the overhead in your
specific special case so you can ignore the problem is not the way
we solve problems. We need to solve problems like this in a way that
benefits -everyone- regardless of whether they are using memcgs or
not.

So, please identify where all the overhead in memcg shrinker
registration is, and then we can take steps to improve the
registration code -for everyone-.

-Dave.
-- 
Dave Chinner
dgc@kernel.org

