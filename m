Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D605BFD4606
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300426B0088; Wed, 25 Feb 2026 20:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADD96B008C; Wed, 25 Feb 2026 20:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185DC6B0092; Wed, 25 Feb 2026 20:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0247C6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:42:03 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABAF71A021E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:42:03 +0000 (UTC)
X-FDA: 84484906926.30.90227A1
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf07.hostedemail.com (Postfix) with ESMTP id D3EE24000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:42:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DBpR2vEH;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772070122; a=rsa-sha256;
	cv=none;
	b=q4XjRlMmtCXOCq0Yc6Oc8B/9YB/VZ7GvfUV0xaduvWeFQWTCy6vKl04dStEDuJ0rW++zpb
	9NQrvL/Ez1aG4at2qouRZruhdt8GL/J0ItONRVBUtjqt5IV5uphnQ03Nph9nBk32RMYCld
	Uu5Wjmf7+K8Sbp1vInUldi1+a5aCKmM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DBpR2vEH;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772070122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCvGmCmilt3Iav7ktXIbGgvFCADiAsVJLuTgICHbbvU=;
	b=kYBHnVI+VZU9J1uk6JcPOl1sfMT6CjF2pzH5HGDiO8jqgoTOzLpkA2VsrbfxuOXnijkg65
	oOEIicrU0m8oYSbdLJtV7wHrQh7A3BlX+dZdHYZVwwtSTsOb/cZyddkPckZYPocrLHlGPh
	EJukUdSQEFtnBKQt73RT2RnxGATMyws=
Date: Wed, 25 Feb 2026 17:41:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772070116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FCvGmCmilt3Iav7ktXIbGgvFCADiAsVJLuTgICHbbvU=;
	b=DBpR2vEHIC7mO2TzWh+tPoXu1M0seTK3lc9QNrkr4WCCR0KRQGf/X0U8dUG6eoOfO/W5Eo
	QoZ6Lz1NfN4dRNNpPK000BXyGzhaRdY9c2l3lawHKeoxcAk42kCxcc5L15Bmf2X39OjXIS
	Ufk8H2HzfJmRbO1VmozjxmiaJ7e4so4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <aZ-kefGBeT-RzGcG@linux.dev>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D3EE24000A
X-Stat-Signature: rabq8wrewzgpsducxuyhox97k1kpwd1n
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772070121-654007
X-HE-Meta: U2FsdGVkX18zZDO0pCwaARqccCPys6MQO9n6IFDCtDTvfT/OB4XkC9jALqEn9r3Z6kTRA8PdvbtlHiUAV7MsSBxi6nWkUvgFy+hyqQQgzFOlZGutcbPqA3BQcEtpc2M3WeECeyBa/3k+d3GJlyyc7ynHJUaNHTviNE8ZFHFWnBYCUQAfXKpAO9no7NomNWd3wgjBE9r4Z7iUPyaAtE5jAE6HGa5dG5NzFYD4TokhENtshRmFtkczOtuntv4thfHLWn9EjEukQRTWORFNJUBPokk61VoVZpBHpvCZWm+LQ4ucqhxxkDIQkrvHBirby6TN80DZeAWcLnY+hMzVGY3fgWEVDe7KUO8a2yQymOW0DKoPx1pqLhWxgQA3RceUGZvvqJppfmP5KIqkQFzVf7x4Xa6FhFLld6oOLL96fQMAUAqq8PHS2MAhdPwEDtz6vqacbwf/Rp/pDH8xB6PW5IUMoLCzNk/RwY91ps2F7wH+1Wm2CQ/HqQHx0o4T+SlgI6/NLqYAnke7r2uYxF50FVDpZdn729NNUB1kFoItMhGfQz6JVleLH5ERhER92zlpJcqq57GWIgEuCFaqpNXiUU5/0pWwP8AatTUryeDvXSsZpOBb1Tf7zIF7XHHcbNrEBJBKmubIiqj7FnWECz2e3Jv2VM4PlvbZavzBhLcbqBCLh8sbWDQd0MysIrJ4W4vC2aO/Q8UmYCki3diMs2XkZnlBtFN+1d/AhwvggVn/buulz9G1+iTCW/YO5NIFgCjO/OWr3jWxNLAdPx8qcF5Q374dIer5sYX853qUpBfTfwwgVmIJB52skWBaDINXjxj6gSFgvWC/cYPGZwWYN2Jk/hhDnWsNukCBA44IUytI/eSZ6tiF23Ak4yIjAr6CnSBX+kf/9Hwn38nSSIcxBasqtosYQ3fXtqzky81yzT16MPTsB26W0N3Xz5AQwT2r8unveyiN0rKDP8vQGt3grjtt52G
 BvHKVUzC
 fy0YIKQcn2wK2ph7OsTzLxPUCv8luDN40O+9kXR/otefdvF7UzNDwHBrYVez3h5fExIK1BSOvLfFzpt6nfJu+RNIeqcpRXRgdBZ3wUei5HnV2hvC1Zj/CErb3dih0VXM7hFTy2Bojvy0h4iTT4+KcEzz+w32qBcbDpiXt375YuO7PtBFT23poBCY1o1RNuyhJwuMxoCvOADZRs1KNQDI9XGPtTjM2bscV33sIGnXO/P8awIz7QWalJjm1fBwd+EHg7vv4aMp8LvfRmkw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:53:12PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> To resolve the dying memcg issue, we need to reparent LRU folios of child
> memcg to its parent memcg. This could cause problems for non-hierarchical
> stats.
> 
> As Yosry Ahmed pointed out:
> 
> ```
> In short, if memory is charged to a dying cgroup at the time of
> reparenting, when the memory gets uncharged the stats updates will occur
> at the parent. This will update both hierarchical and non-hierarchical
> stats of the parent, which would corrupt the parent's non-hierarchical
> stats (because those counters were never incremented when the memory was
> charged).
> ```
> 
> Now we have the following two types of non-hierarchical stats, and they
> are only used in CONFIG_MEMCG_V1:
> 
> a. memcg->vmstats->state_local[i]
> b. pn->lruvec_stats->state_local[i]
> 
> To ensure that these non-hierarchical stats work properly, we need to
> reparent these non-hierarchical stats after reparenting LRU folios. To
> this end, this commit makes the following preparations:
> 
> 1. implement reparent_state_local() to reparent non-hierarchical stats
> 2. make css_killed_work_fn() to be called in rcu work, and implement
>    get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
>    between mod_memcg_state()/mod_memcg_lruvec_state()
>    and reparent_state_local()
> 3. change these non-hierarchical stats to atomic_long_t type to avoid race
>    between mem_cgroup_stat_aggregate() and reparent_state_local()
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

[...]

> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -45,6 +45,7 @@ static inline bool do_memsw_account(void)
>  
>  unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
>  unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
> +void mod_memcg_page_state_local(struct mem_cgroup *memcg, int idx, unsigned long val);

The above seems like addition by mistake.

After fixing this, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


