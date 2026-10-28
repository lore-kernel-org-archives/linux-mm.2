Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF389606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WmBtg+SB
Received: by kanga.kvack.org (Postfix)
	id DF6E86B05B6; Wed, 28 Oct 2026 07:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8106B05BB; Wed, 28 Oct 2026 07:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96996B05BD; Wed, 28 Oct 2026 07:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFE226B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:43:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EC7D80C42
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:43:29 +0000 (UTC)
X-FDA: 85371849738.25.88D07A5
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	by imf21.hostedemail.com (Postfix) with ESMTP id BC2C21C0004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:43:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WmBtg+SB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfCH5siTslprbVWbzonh++7TcYX9RLbSGXWmsSgr/V8=;
	b=p/5O9ohaDOaYuib4eBTQ0c0bqBseAYZeC5Jz1dBK6yMbypxCLxvIaz6iGDvNiqX03EGYFn
	YdvatoY1ajVKAdKyyPza3h+TYozcH8IxKPDeTQL+jtYPOuM1K+aBd30nyyaaCgjxEFbmWs
	AipqHS2CYaBvlwWsRMKDn8fL5UpYgJ0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WmBtg+SB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187806;
	b=eKIsyDNrgtTPcN9zWOVOjdD2ZyCUU6uvECdBqS7XCSuIfp5laXDVYf+cFX1goGRd5vLlJu
	bjuWOxrDaawRnYpSMPd4mkj+pSfBTMeEv1zkeT4eeUrtRd3q3a/hk4/AZJmlVElwCngp1l
	i/XtjfpndBmcMMe/4uCF82cGrGy4LU0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tonu0mtS36f03NgUUNtAYyjNYq0EXBIuxH78yC50xRg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793187801; v=1; x=1793792601;
 b=WmBtg+SBjjk8MGu00t8CZ+tPsnjEYM+ILnAEpn4VKpWG8GHU/Mj5NavKSaZo+Ul6G3P27fEn
 dfBIOV4hDK8NOCU5hZPJt4n01l3SUp/Usn3cBHPeH2QMzArmyU4I44sohrfjVyuSjcChhEnRzxl
 x1Q3kJ++k9r56JTS6qEtmq7Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ad9f9173b3de5ee0;
	Wed, 28 Oct 2026 11:43:21 +0000
X-Mizu-Trace-ID: ad9f9173b3de5ee0
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 19:43:14 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/8] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
Message-ID: <auHcj2G78VkXy-Vz@fedora>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
 <20261024-slub_tiny_rework-v2-3-bf1419ab5ffd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261024-slub_tiny_rework-v2-3-bf1419ab5ffd@kernel.org>
X-Rspamd-Queue-Id: BC2C21C0004
X-Rspam-User: 
X-Stat-Signature: i4jemu96qxffzfxrnanq7ba3k3fbko8f
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793187805-86773
X-HE-Meta: U2FsdGVkX1++dpEzkUNhvua7vP/XpRbkuVQrLF6qNA2+9PqTlVESwPyUPLjUE1aE/eRYIv0ebkhwP2Edq0PHtXbQHeuJRlLJjllJhwvUOaHIeQq00K0CBnds8CVCh47RtFf1XCcFDGUDJJRErksl9EjNM19bkuhcHVYOENMd1HaRaWWVwFdEgLJva7tVTGwsi0lofBjJSiqBVivhXiqLtR+5z/OcSiquV3F4finGekE/xC4hrB2vZ/rN7H+SvhX5rH9SP0/BHATpNKs5KJkUCuBO4mOWCpGDMNUAM+sXw4HTBJprNc85cerx6pTTXiQjVCjrx3S4bWrwhXUCwrzzjYdsI1frfGRKKCtOJ4F8d135Qo4q9joLkZofdu1Kk8fw1ZpmtXN74syKwCsilLgNbHA12fG4WLKCRkf9l2/ciCOMjRLKU4GdjNb1chTW9L+AgmEThARsebAB2bbfltXA5Gdgawe7AYGNJEOwx7l3xZ/wuffKIinC+2aDlchfRNmVdcOQ3XpH7V20VcWYHaokv/xgrc8/1Ga9ZaOcxaYOEa0mn0jNP2iYhaXJpL05HVm//FftLhUKfxlgeper8TN1aHf2h4CzOVAv+w6CM5s6RRDOltWBBYzmB4m5DuOkyHlEJXtLd+COVd0F9F6FieuqDxQoKUcHGdG+EZwmYQhSQ/YCXHMEmyrQdelWvluKrspE84Wf0RWj5RskRFaG4VdGZxi1sTlMgh/9VYdkd6cCtSB0lVo31ys6MEzNtSBvkDyAghf4GFFprJIkM15+YWHllt7RSZiCLFpnaRWbHzEJJAT1BQacvSWXC6HcZV4qmu72pj0anl/p4bIi5eIcIe5Ty7n/MTfY95G6uIVVx0NpArORcncKrIbEcMIChUkRbLAGsEunqguOmGj5joeNQruKmyJdGDdmigpNYWVIeTFvNnWqNEpCLMZDVqUVD9I1Tdxo6KRLWIm30VRXmKk9RCP
 Pwoj8Yt6
 Wyo0dMb2BxFGt2gLp7hEuyfOFrHGJAWTV755Fid+G5CpHUBYsnxLTyvielLh+vavApy0paCWyPQNuBWQWoltzGoS+viDRHChZzuV33qghz04BWUo4D8mYUaJVy0tItR71Ebi0mE6IZs1ZkkkoNuD7nUHFkd0WDgWcmAG/L3s/D53Mb5hCNnwn2kDH8d6ZBVqdKyGJ6uHbeuLvnsuWQ/aKdrOSB2I0FciU5EUcNXjHLQYbSNX+P2RC0u875SvQqXkLQLZtMJsSpxGUAbRxc5tc8Jlkzj7z6TXGfm/VFda3PQFmiszEsQkEFToj0x/PiF41ZdecQmhGvOjqw+VMVq/0/qiCgc16CYhNehzoJqSUHtfju2niNsxly3jfPdrpcu3/op8/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 09:07:25PM +0200, Vlastimil Babka (SUSE) wrote:
> One (relatively minor) aspect of CONFIG_SLUB_TINY is the assumption that
> letting reclaimable and non-reclaimable caches merge will save more
> memory, which is more important on small systems than the page allocator
> level fragmentation (where distinguishing reclaimable slabs should
> help).
> 
> For now that has been achieved by #ifdefs that result in making the
> SLAB_RECLAIM_ACCOUNT no-op and aliasing KMALLOC_RECLAIM to
> KMALLOC_NORMAL on the enum values level.
> 
> With the goal of converting CONFIG_SLUB_TINY to a boot-time decision,
> rework this so that SLAB_RECLAIM_ACCOUNT and KMALLOC_RECLAIM are
> distinctly defined always. Now, creation of kmalloc-rcl caches is
> avoided by assigning a pointer to the normal kmalloc cache on the
> kmalloc_caches array level.
> 
> To prepare disconnecting of this boot-time decision (and the evaluation
> of the need for kmalloc_no_objext) from CONFIG_SLUB_TINY, introduce a
> slub_tiny_enabled variable that's initialized to the CONFIG_SLUB_TINY
> state.
> 
> There is one minor functional change for CONFIG_SLUB_TINY=y. Since
> SLAB_RECLAIM_ACCOUNT is not 0 anymore, caches that differ only in that
> flag will stop being mergeable. If that turns out to have a noticeable
> impact on memory footprint, we can adjust the merging decisions to
> ignore SLAB_RECLAIM_ACCOUNT when slub_tiny_enabled is true.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  include/linux/slab.h | 10 ----------
>  mm/slab.h            |  5 +++--
>  mm/slab_common.c     | 12 ++++++------
>  mm/slub.c            |  2 ++

[...]

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 02dfe4351e8b..33e76a0c3084 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -835,11 +835,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
>  #define KMALLOC_CGROUP_NAME(sz)
>  #endif
>  
> -#ifndef CONFIG_SLUB_TINY
>  #define KMALLOC_RCL_NAME(sz)	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #sz,
> -#else
> -#define KMALLOC_RCL_NAME(sz)
> -#endif
>  
>  #ifdef CONFIG_KMALLOC_PARTITION_CACHES
>  #define __KMALLOC_PARTITION_CONCAT(a, b) a ## b
> @@ -976,7 +972,11 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
>  	unsigned int aligned_size = kmalloc_info[idx].size;
>  	int aligned_idx = idx;
>  
> -	if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {
> +	if (type == KMALLOC_RECLAIM) {
> +		if (slab_tiny_enabled) {
> +			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
> +			return;
> +		}
>  		flags |= SLAB_RECLAIM_ACCOUNT;
>  	} else if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_CGROUP)) {
>  		if (mem_cgroup_kmem_disabled()) {
> @@ -1009,7 +1009,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
>  	 * KMALLOC_NO_OBJ_EXT cache.
>  	 */
>  	if (!mem_cgroup_kmem_disabled()) {
> -		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
> +		if (type == KMALLOC_NORMAL && !slab_tiny_enabled)

(While reviewing Harry's patch [1], I happened to notice a small inconsistency
in the current code. Since these lines are being touched in this series, I
figured I'd bring it up here, even though I haven't properly started reviewing
this series yet :D)

IIUC, for both KMALLOC_NORMAL and KMALLOC_PARTITION_START + n, if gfp has
__GFP_ACCOUNT set (and without __GFP_DMA/__GFP_RECLAIMABLE), the allocation is
redirected to KMALLOC_CGROUP. This seems to mean that neither KMALLOC_NORMAL
nor KMALLOC_PARTITION_START + n actually needs an objcg slot in obj_exts.

Right now, KMALLOC_NORMAL already doesn't carry SLAB_MAY_ACCOUNT, but
KMALLOC_PARTITION_START + n still does. Given that, would it make sense to
change this line to something like:

if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END &&
	!slab_tiny_enabled)

[1] https://lore.kernel.org/linux-mm/20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org/

>  			flags |= SLAB_NO_MERGE;
>  		else if (!(flags & SLAB_NO_OBJ_EXT))
>  			flags |= SLAB_MAY_ACCOUNT;
> diff --git a/mm/slub.c b/mm/slub.c
> index 51daf361c601..a3ee1bdf0eb3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -219,6 +219,8 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
>  			slab_obj_ext_has_codetag_key);
>  #endif
>  
> +bool slab_tiny_enabled __read_mostly = IS_ENABLED(CONFIG_SLUB_TINY);
> +
>  /* Structure holding extra parameters for slab allocations */
>  struct slab_alloc_context {
>  	unsigned long caller_addr;
> 
> -- 
> 2.56.0
> 

