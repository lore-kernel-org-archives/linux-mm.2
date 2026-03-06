Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911AFFCC062
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0856B0089; Fri,  6 Mar 2026 15:29:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EADDF6B008A; Fri,  6 Mar 2026 15:29:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C756B008C; Fri,  6 Mar 2026 15:29:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C9B1E6B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79F17BA695
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:29:42 +0000 (UTC)
X-FDA: 84516779004.24.1E7FC7F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 99B594000A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:29:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iupAZja8;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772828981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xu4FOpsB3tis67Vr0ogStH5duKlNRv21WglBri7UTcs=;
	b=VGCCifHp1wESB5pUlXMNpyeGeFT4rXwe7jMzu6Qw3RZxk6U3SI3Bsze00wRtMZX9xuSf9J
	GcxSsudfFh/Pr2zToaJkmvyFMDFVj3Z5x3yF4yz/pJfGXE9O/AKTFv7ABI5KbmhnK0pmRe
	uT6sD4e97mzlzh+VfnRYPD269aobLYI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iupAZja8;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772828981; a=rsa-sha256;
	cv=none;
	b=NvTynLL+4hB/bmGuw63h4A2boDT1QVgpYpgLKpjE9F64aiWkaRvOsJjoKfW61DyOtCbzN8
	ZOnH8JyDkTkyE2Rwla8Cz8LYBekkYN4aLCJudZDeZtFcO3j7SLoh8Ta397W+4FPxIWkRTB
	v4EFV5E4h+T2ss5gZRMLP2c1dC7mpAk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772828978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xu4FOpsB3tis67Vr0ogStH5duKlNRv21WglBri7UTcs=;
	b=iupAZja8wy6lFb/pwYfc8nhuO+aJSry5Kzt+7aHHLHQlaMXK2PAsZMFNNd66go/2W6Kkwe
	vdSCNOLTyQowEMIgGXwIyWRJErAzaAgNXx4GOqe/oeRcXdJ66tdgH5XHnVRTlmSidJ3kyS
	lzPKFMCdB6Vy+1HRz3vUG4R4h/6qZ20=
From: Usama Arif <usama.arif@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v6 31/33] mm: memcontrol: convert objcg to be per-memcg per-node type
Date: Fri,  6 Mar 2026 12:29:28 -0800
Message-ID: <20260306202931.3878822-1-usama.arif@linux.dev>
In-Reply-To: <56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 99B594000A
X-Stat-Signature: g1bt1mq7ixfur3swn5ku4ojon7tasrkq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772828980-573121
X-HE-Meta: U2FsdGVkX1+NNkyqYlWlF8uLpSufU7DivP6XAIDuzNGJY0zA8Ji6+2f91BGe2p4SjDm0N9nQyoWtCBoE/y9kcd4DdLLNnTVQib7F3ygNdAo1fbjR7qmfZig9X/26uatlcoRMID1FAe7JFiDlRm/qfW5Z4enmKCdEfsZqGG0ivpXscrcro1OyjOmnY9VDkWIQevplTs4ZtqeVlsSmazu8oQAaWrU2IiaagC4JKlhx/7g3dD+ZEW4YsW5+tX5I9Bnxz58OKdwXhEiiSygZWS0Bgs1XbqM3jizesnuvajQZdJmgQYo9i1vzmeCirvvzZB/2CdaHliCOSFRnUhmAjuWY2JAnL2EiioYx0Z3E0Hw8EpwA4OjjzXwXdlaaPqO4GJRA8VJVYKZshBmQHd3h66AEBU8NiIhA5njWe2jvlbsge/aLQnx6WUz9hLfA/MMNGfEGdRxjlkTgCqwnDRxJ5oPCf0k7/4yBtN5sAKO8+QOvFGe3S25FW2Jr330wUymdKyQV10O8py0PGxPkIjuDO9Y+k2CdvPYei6THBhF3Z3l49qoeJ5b4S+p1i+Aa6JgFwDIVxcw74jVj9uDr0mQy9y5gOM2VdzTFhJQUZbSgdQIAP/VRGdT1NqyOq619uz32jfaWguBLpyO7EE2r7oRm1E1Po3QQEamSt3/DE13BAa1eDobKQ7a2XfMx4XRRVf0HvLAbX24RrB/6dTKSynSHSm+3dqfzfO8Xo89JT0rFRGd7A4OCUt4YCzV44a1xCrECuR8CtjeaB4UP7FQLz6z4/sAV1RIHk/v3rpHwIr+43bsobikZx8cnb993ZxXHXP40vkZnuOMqMr5UzRbRwezELMYwzg+l011KplgAHcZBk8WF6zSPcgadQXgV2UxZspxt5+QfwtJx1R0g8Uf66wJYIktoXHIdBHq6CAF8YnB39e3T5VthgubR/8fuHzEhrq0E65QvEe0ZuoIJ3BMT3X28XGD
 tY/1haFg
 C+GvPqv5GPLFd/Np54oPW2az9xDc2LNbpdEOUdXRHAAYLsSxIVv5bMQQkn28NzvGtWBTZtfU4Ttq26pRrBnOB31crkVovFENUsJjvkr7O3kqfalvFJW4SKkmFXFdV3ynfOC2DDKDSfAGSGhkiMbFx6AO4U6QSmr8GEoZ+5lEBlhaIDFKUBRl6SJq+lIsxhNtZfxE8K3jf0mTIdBqohy3ogVI2WasCHc13kn06jNLaFHghWEWA6d4kz+PZ3DXIVvpnAWmk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  5 Mar 2026 19:52:49 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Convert objcg to be per-memcg per-node type, so that when reparent LRU
> folios later, we can hold the lru lock at the node level, thus avoiding
> holding too many lru locks at once.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  include/linux/memcontrol.h | 23 +++++------
>  include/linux/sched.h      |  2 +-
>  mm/memcontrol.c            | 79 +++++++++++++++++++++++---------------
>  3 files changed, 62 insertions(+), 42 deletions(-)
> 

[...]

> @@ -4087,7 +4100,13 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
>  
>  	return 0;
> -free_shrinker:
> +free_objcg:
> +	for_each_node(nid) {
> +		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
> +
> +		if (pn && pn->orig_objcg)
> +			obj_cgroup_put(pn->orig_objcg);

Is it possible that you might call obj_cgroup_put twice on the same cgroup?

If css_create fails, css_free_rwork_fn is queued, which ends up calling
mem_cgroup_css_free which calls obj_cgroup_put again?

Maybe adding pn->orig_objcg = NULL overhere after obj_cgroup_put
is enough to prevent the double put from causing issues?

> +	}
>  	free_shrinker_info(memcg);
>  offline_kmem:
>  	memcg_offline_kmem(memcg);
> -- 
> 2.20.1
> 
> 

