Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7118C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF376B0088; Thu, 27 Aug 2026 20:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF566B008A; Thu, 27 Aug 2026 20:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC476B008C; Thu, 27 Aug 2026 20:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 842F36B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:14:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 836A040227
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:14:00 +0000 (UTC)
X-FDA: 85148755440.23.AB006D6
Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4EB09120006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:13:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HcJr3mDH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787876038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xzq1GAEDfPVS/kFOgeTTbebNqf0DKrh7jnqFMWym6A=;
	b=vZJ1LczFoQx6ffHrm65QkLUf0jTFCRmj0Y403GT/GikRC300whCYrQTe8LQbGMv4yqE36u
	5ZD0komHZyLbaAZ5KkAckr3a5QecsHbcVqZUPfIB2srcentBsoAb20ss5jE0WF3ZXTHt72
	mqFdiDTSB8tMC2kHwzMIbMx5sA+kGXI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787876038;
	b=JMPVgEXRi9BYSyUmCEukLeXlzvvjbjvBveocUtTW0a19QZrc35j3gUpMZmJRr0oR10ornt
	vGuC/QvViy3ooBvC8RSxjTRGlEoX8uLjxKiKzINMVcz6tlcPv7A3OWX3vwRaEHDklpxTN2
	d451ZFQxvIyqW+bWeSj/Aubl3X2Ww7A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HcJr3mDH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fsmsExbs5nEKnsojLuf0l39j1UTtxo6K5C9nm891QB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787876036; v=1; x=1788480836;
 b=HcJr3mDHQNMfTpxf9qN2PWYt5rVNj8obn2InI3h2sePCM6es2pHJZIo26KaepRyKEbi2brwN
 LWr8VMFNDAOe3ztNYc3y9ohNc+PK9qhcPm9ckx3uYbvt+8uesqhtc4fymxNNiUMsSPvJh5sLJJY
 t9fQVIAt6JLUeM3xAgm/UN/g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a46212a26a1c49f4;
	Fri, 28 Aug 2026 00:13:46 +0000
X-Mizu-Trace-ID: a46212a26a1c49f4
X-Migadu-Flow: FLOW_OUT
Date: Thu, 27 Aug 2026 17:13:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joe Damato <joe@dama.to>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: raise MEMCG_MAX for charges that fail
 without reclaiming
Message-ID: <apDPJzlJ4gS9YUDX@linux.dev>
References: <20260827233119.411152-1-joe@dama.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827233119.411152-1-joe@dama.to>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4EB09120006
X-Stat-Signature: 4fq59oijgmw7moib9e64n3is1jri4agp
X-Rspam-User: 
X-HE-Tag: 1787876038-903994
X-HE-Meta: U2FsdGVkX1/FeGeMxDtTF3A+ohz0IKcSA/YtyZ/SZnCBET8+WHzjAk0GOAE/9Du9qgtZ4rbaFBoffdCdR2VbpBY/uhRorNlIQ5t0sbVWiNv8+Y3SGqo+AbgSY8Ag4xG7cRMUALUeEk1BMVmO6ZhoQc2ia0wbE0U0OQwiewVa8Sad2lmzwZWF48zh/qB5bs67JhMcMV4Jc6q0wj+ubWV2oo52SXvWBhD8ymemNovwE2dDQEhAiF4HeirYm5BsCb2hfl2M9e36jyBHmD4FG81FCzmIZdjKI7/JjWGREjNriKGR8qDreHs+bwlVGKPVR/kxRAx5IEAOENQowhJ42N1Enc3tkIWzcOxTGnV9QwkWXhN03rw4NdXiHWNqJr/QCqhy/xJP2uTFlXQdHr4hGmmcJp6qiYZ1OYa0Yv/uo4m4/Y5536x8LZWWuOGWBZvtglSMPunclK7HQekQQw1RBYcaJyKr82OSJ6qLDguP7fumbtoLxA5VhuHJKfq+vylTPUg8XJRlka6P+vyiMQPEXzTWbAxAisMGcIt2MYxWHRtt/brJ+CbMRXREnDiGY7jg6J6nfL9fX+CvyyBqg+XwD4pROmVbS9ELnhrbjVmnmh/nu1vPybIUwA5k2hcSYaxTYNpBaB6ileRy0A9dl/AMOqCESWTcylLeofqyrQSfrH05HktZmFhIYw5XmduLnfhvOZDnNp8l8FlA+lrfWkVHxRiDl2SuhP4DYOvzd/btqwUdev/nh9sokf95ldIrwhMvkYQ9S2KJ2KmSGKnIiIqv7Ah3CYl6aQ1IpG3XynmNMZrPHRdKBkp7WKZn+NFv2Vmr72jtPVF0lQY9JBJOXae+ENYTvX5NhEggUze4z8xscFkblo+U8fzDc888MU7I79P5sGrH8pOQWy4WxAChYmaCjpJKuvrodFYXROnW/iwBFySXCGEXXYNvhkIux6jq6QP7bzOxiQl2/5pXeusgkEDPTPM
 0A9Z0THD
 qiEFuOS0xe+qxMSX/Zn7nCZSUuGNQmuBFbu9CIMbWF49L9NNN0rPBNZi8JXYh+WXjk88A4O5GLVYUk1WIJ+ZlRv6qWWFvxvKqKZJ4vJpDtYkzw0TE0s8Tc6fqDIgslucQBrdL75a6EUfb9fV4WtjeaSfluVsLz/ACDf2/gl3jRzDmq1NNw4L+X1pmWZtaAMgy0eDevy7pPK8HLXuHlhxPLKxsOGd/C2/NR5lLmkAnTxGeyTsX4otPBhNJghPL36LFlXVgkEPiAWLK2S5zcwBkWLaUAqzXaVHfERi/3vja1kiENrZHXUbfYVcET+IhlgE4Dqmj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:31:18PM -0700, Joe Damato wrote:
> Charges that exceed memory.max and return through the nomem label can
> raise no event and simply return -ENOMEM.
> 
> A non-blocking charge can hit the limit, get rejected, but is not
> visible in memory.events.
> 
> This was noticed in a production setting where bpf_mem_alloc() attempted
> to refill its per-cpu freelists, which triggered a non-blocking charge
> while at the limit.
> 
> Move the event so that it is raised as soon as the charge is known not
> to fit.
> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joe Damato <joe@dama.to>
> ---
>  mm/memcontrol.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..3904fe9a7b2e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2683,6 +2683,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto retry;
>  	}
>  
> +	if (!raised_max_event) {
> +		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> +		raised_max_event = true;
> +	}
> +
>  	/*
>  	 * Prevent unbounded recursion when reclaim operations need to
>  	 * allocate memory. This might exceed the limits temporarily,
> @@ -2711,9 +2716,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
>  		goto nomem;
>  
> -	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -	raised_max_event = true;

I just noticed that this will change the current behavior where we keep
increasing MAX counter while charge request loops through reclaim and retry.
Though we have not documented that behavior, so not sure if it is worth
preserving. It does help identify cases where a request keep looping in the
charge/reclaim/retry path.

Let's see what others say. Keeping the behavior should not be that hard if we
decide to keep it. Something like below (untested):


diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..6bfa4ad30b24 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2656,10 +2656,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	int ret = 0;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
-		return 0;
+		return ret;
 
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
@@ -2770,16 +2771,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * put the burden of reclaim on regular allocation requests
 	 * and let these go through as privileged allocations.
 	 */
-	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
-		return -ENOMEM;
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
+		ret = -ENOMEM;
+		goto out;
+	}
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
@@ -2789,7 +2785,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
-	return 0;
+out:
+	/*
+	 * Don't forget to raise a MEMCG_MAX event for forced or rejected requests.
+	 */
+	if (!raised_max_event)
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+
+	return ret;
 
 done_restock:
 	if (batch > nr_pages)
@@ -2848,7 +2852,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
 		__mem_cgroup_handle_over_high(gfp_mask);
-	return 0;
+	return ret;
 }
 
 static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 


