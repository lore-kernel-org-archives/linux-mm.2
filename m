Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49722C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337C86B00A8; Wed,  1 Jul 2026 11:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8986B00A9; Wed,  1 Jul 2026 11:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7936B00AB; Wed,  1 Jul 2026 11:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA9756B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:49:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6930C8DC53
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:49:24 +0000 (UTC)
X-FDA: 84940642248.28.1C34EDD
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 43EDD140003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:49:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OiPM7TYS;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782920962;
	b=qrN5XDRnJ7u88mBupmgDqoaHs3d+PxNyEIzh4COYYV78hQm+aUW3WtDuot84yrN/xt7kBs
	mKuzKWCSY37gTFBUv9cXPcCdoT3gi4uoMsGbiyxzGOYQG2NUwnFpoOkfgk8csZd//bheW/
	FbJNj3dgZwmSmooZCJAjnWeUrEWIK2c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782920962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0eLlm391NF2bUHGbij/mFfmXYZrka70d1KGczHgghA=;
	b=sZRBy/DyWrkhrGgXGDckUtsu599Oo13rBPXGtF8XL7P0FLrwuSA/86LgkhHmMueuFSiiRs
	h+4+sdfzslWzQbxwKQ7B+BJv6V38sfJ6V9lwAYPQRJ5X0IZu3D/KymHs7VNBZCgxJX5u3i
	NdIEyZI9ENxIRDb4fHokpcIYawkn+IM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OiPM7TYS;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c29b46382so2637291cf.3
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782920961; x=1783525761; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i0eLlm391NF2bUHGbij/mFfmXYZrka70d1KGczHgghA=;
        b=OiPM7TYSwkU2n0Y6gqkOq35GVeWibJNAXYaAIN4W6XOqPfMPHm5vbJDNT2UiKJ4O5q
         /xEIwgLag1aGQ8fe344pso3JWYO6WnVgTFyNdQ74XG3RB/OGALn6rGQ+9Y0myf/tXNOf
         lQWHWmio/QrqZVEYSge4rvJBjRc0bb65onexhF4hJoFOdAs5uSzcOqr2iBdwtOR1nnpd
         H+7vbD0m9zg7kk42mOmBcQsDexZZfyZfVXW61ip71QSzYUinywEv9Q26BhUzvNyaU/M5
         7oMZnksBGRgnwSKnAyFc3O83O0mkbYMM6ze7N+PacPbtw9/tZx8gGt5bB084YPCagj1G
         Vdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920961; x=1783525761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0eLlm391NF2bUHGbij/mFfmXYZrka70d1KGczHgghA=;
        b=RyDrZJRJfpsVheo40AcF7zeqfl0qbWMpftiuxKZjA3HBLFRJPI6bUYIkPgpNmrCgaU
         OHYJQxRkPSq7pQhIidKURoRmhPX9tNpPo3oPFkfs/jH7/JdlXLNxzA9GZAJWeq6gGuuy
         dSNs/hohemuoUx65/TwljDlD2WNorD2XOyjMR4XRaiXKbJ/e0wd5Iw361gqWiVv/fqaq
         BJxCuuwwb6FKDkfE9OdJ/oe/WK2HMxdZo2AglKjRqz+LZKGLn4ZsfUEi3i4W5grk8kW/
         ciRnJEpei4xDpEYbKMfJOjMbPRhd6wqMKusOMed0CerCRsOUW7wn/4o5d0/obsw/P5JP
         JuPA==
X-Forwarded-Encrypted: i=1; AFNElJ//e54wlRkjHk00j518I2TZQ+SM35vTyI6M9ph/ftVlBWP4mpi39uqGTqATVh+lt76D2RlEOwInEQ==@kvack.org
X-Gm-Message-State: AOJu0YzrrOfWmqcoAvIGY9hALEvMaj/AfFBOuZt0UDmy5vH2nvb5QafT
	C4VVEUQ6ZuyN2l6WJygrexalX7hqGGH/z0U2NS6MHBEWlGUOlP7sdEtoeihVupoBaVY7zROYtLe
	pOt9/vpU=
X-Gm-Gg: AfdE7cmLvyOmfCAXPnrIiSRPs+rxMA/3SWaZ/SbkWQflv5kDcaAvdctxP6hhuXqlC06
	JULOAwLNW29sOYBAo3zBUtYlhxgt7IzHTmg7bLisuOYuqRz0pPYOa9bujSVBkVaX9s1IjXGpqjB
	c7KLXuL6F3c4g+6pbcKzD1dh1W4HmiYHBFU6exmAp9AsOf8+h/KopcIyGPboohk9J4G6lE4oSwO
	DMD6Dsxhb7CpUSnhdtC8wDaoKZrk/pbLv3VaIXki+OZQgQ5rdWH5gzEsoblfQCHDnuik0CgEjr0
	ifxgWI5I2yrylY9N0/5VR64lqD5W2+jY9RSzHQAtpWB/pFgGziiShRJ3W/OFSxleiPRo/hGr3r1
	ZGBZXn5HY1aK404UAE/gGlebnaPvMLvgTLVqIXhcFX31uMxszPFsecH24/AAeYFzvvfIGXu9Shq
	JJmT1ViFPqcEw=
X-Received: by 2002:a05:622a:4d:b0:51c:7f8:2a9e with SMTP id d75a77b69052e-51c26b3d86dmr27574701cf.61.1782920960665;
        Wed, 01 Jul 2026 08:49:20 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f4718141e6sm179246d6.24.2026.07.01.08.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:49:19 -0700 (PDT)
Date: Wed, 1 Jul 2026 11:49:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <akU2_Mt_JDCxmnc7@cmpxchg.org>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
 <87h5mkz33h.fsf@DESKTOP-5N7EMDA>
 <akPg4ANRetbjSP_b@gourry-fedora-PF4VCD3F>
 <877bnfynsr.fsf@DESKTOP-5N7EMDA>
 <akUzUqQG185XHqgL@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akUzUqQG185XHqgL@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 43EDD140003
X-Stat-Signature: 3y1ydrnziyay1m13yfxshuj8ortc6q8i
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782920962-820429
X-HE-Meta: U2FsdGVkX19YFkdBkSv0bUrA4FnCXT8JL0+6yNLTgblWuyRs/aizY2/F9d2A44kl+VfvKp27MkkX5gUrTWBH+r6iKb/lDTrJ7zjV1r4cy3iOXTgXll8y7r7qTGBznxjZjWlnNBECrD8ekKCW+qhaYh1cZCEm8HxljL6pvQ/pTurKGO2YTg7/oFbBH17FmDkcgqIzPCpSjvYwivxwCp7vkNbAbnVonvqzCWSpdFpngEP8HBL3IQldYMNwmB1edtAVK8IucRZakEDNRVCtbMGd6OmzODHrzo06iM60RDRIEDgLjqDRnAXtljOYHr9YAOuS6GHc5SveVMTso38aAIxcCH//0L5MzVYVch4uOf1Ufk8LxgxA74UCi8ZmB83+8uscYnQiMRxb2wsLWzEalYTEMfYSO8tNswUoaLJvupitFKU+JJp2IUctZ+5GUekaz7yFT3iEVfy9XiKwzWzg0ow8lRMFtINHvGSIOkHLAYk+DAFxU9jjvR5J2y/A0Hgk3y0PxzSDYGfYlp8Ypy8x/rOeo5iz1OrD5TnW5O6vHqGb9KHbvmbUdzCklMHvxcCJsJURDWMMOYz/IE5Wg7GpF9VTPQqdFJgO7lawyaQn3LiqNIfAemnu2QNvV2Pyu951r9yX7b/aTL+FcX1t/nhIyO9PHFZPQu9y/1QkvHGSGQbdU6TBPPwxwz49tEV5sLSFc4bbGKYMwo1HpAWsyz1i+uhWR5QjPEKYQT5hUfj7Q/K4mvlfhyYsH8M4N18ieT2P2PB6QOF19Ra/2rR54v/I9pi8EfVI9pOSq2tQBpbWzU8s8TANFvR4/blr8BR8OBfEWSxfcM3gqB8SBHMK+Iw+Y4AP5okmvqxG1fzbxyCfZO8ZW/r+LXrwSv7zdTn93pY2KNMYVh6KW5PWLs6EGVZql9Ff65lR9bN7B3/eqqCKr3qL2sqxixJcVaoZ/2mh5mXlQDNzrJFFoLQI0y1gtRW/ZfZ
 XvQNoEQc
 WUjO0R0OOmUu9sn1yWF1DZhbP/B75ZV6fecoT242whTBWwfKrLAvGM+QYjz6qXuRXG0jl6khSpdc0W7Y69whP8PgGbXPqOZTO+RW+mkcWY6lP2DuOjU+xuBtR1RE7fAElcqUcKmc55uJJOvZDNwDTsDkSlSRQkCq+A80bkfuFmBjsObuDgJ+PmMdR09Uce6YiPpBd6u/55cqJqGgghVKWsR+Ov+Ze9bxD7WOqjkEnOGw4m8P8UPWacKp/BltXbO+DCW8BIr7lbN6rbTHAq5DXWODVJ42x5Qpg7oGiwbm0eInM1HJTNKYqfpaThZpGXRGd6xUQxbbdfCrzYW1WPy7Ye9l/LAGGlYbzNnBif5w1wIYYk8w3g2onD5tx0m/ga1ZjgLUBBwBtQTmWwRGLZt4Weuw7HTXnGsy3EfXhYyYSFhxtld4GderiwCw2y/L/xmaMc6ZHzxiqcS8UNg33Pui3jSyszO/LDDWSvIgcga415ZrXy/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 11:33:38AM -0400, Gregory Price wrote:
> Something i found while seeing if i could make ZONE_NORMAL nodes more
> reliably hotpluggable:
> 
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index dd2717ff94bf..9ceeb56574ef 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -682,7 +682,15 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
>  	 * we won't be able to do that under the lock.
>  	 */
>  	if (unlikely(can_alloc && !READ_ONCE(new_pool))) {
> -		page = alloc_pages(gfp_nested_mask(alloc_flags),
> +		/*
> +		 * The stack depot pool is a global, never-freed allocation.
> +		 * Use alloc_pages_node() on the CPU-local node instead of
> +		 * alloc_pages() so the pool does not inherit a transient task's
> +		 * NUMA mempolicy (e.g. MPOL_BIND to a CPU-less/bound node), which
> +		 * would strand this long-lived page on that node forever.
> +		 */
> +		page = alloc_pages_node(numa_node_id(),
> +				   gfp_nested_mask(alloc_flags),
>  				   DEPOT_POOL_ORDER);
>  		if (page)
>  			prealloc = page_address(page);
> 
> This is a global, permanently allocated, resource that inherits a task
> mempolicy's placement because that task *happened* to be the first one
> to touch it.
> 
> There are many alloc_pages() calls (155 instances kernel-wide) that
> inherit a task mempolicy when that's probably not what we want.
> 
> alloc_pages() is called in: net/, lib/, kexec_core/, drivers/, arch/
> 
> you can imagine a task setting `set_mempolicy(INTERLEAVE, ALL)` and the
> result is a bunch of random driver memory gets spread all over the place
> along with the task's heap.  Is that really what the caller wanted, or
> did they just want userland data spread about?
> 
> But at this point it's a 20 year old interface, not much we can do about
> it without making *someone* sad :[
> 
> I considered proposing MPOL_F_MOVABLE_ONLY to mean (roughly) "userland
> memory only" - and then slowly trying to migrate numactl to make this
> the default.

Hm. Kernel allocations that are totally incidental like the stackdepot
example above should not follow task policy. But there are kernel
allocations (kernel stack, inodes, pipes) that are directly allocated
on behalf of a process, and so probably SHOULD follow task policy.

That's an annotation problem that I think we have solved already,
because cgroups need the same distinction for what allocations to
charge to the current task's cgroup context.

We could rename __GFP_ACCOUNT / SLAB_ACCOUNT to __GFP_TASKPOLICY /
SLAB_TASKPOLICY or something, and have mempolicy follow it too.

There is still the whole "changing 20 year old behavior" aspect, but I
think the polarity works in our favor: big important allocations have
already been following the policy correctly. The behavior changes
primarily for smaller, random allocations.

