Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87F6606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 04:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=PhKWZl+l
Received: by kanga.kvack.org (Postfix)
	id B718C6B0298; Thu, 22 Oct 2026 00:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22D66B029F; Thu, 22 Oct 2026 00:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39EF6B02A5; Thu, 22 Oct 2026 00:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D00D6B0298
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:52:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9641080702
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:52:17 +0000 (UTC)
X-FDA: 85349040714.26.D7E5641
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9449B1C0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:52:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PhKWZl+l;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792644736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKmRIxZbD0nMDMPI/mEiihjsp8gY8MgQFkQF67TPGtQ=;
	b=euy4wCbaTX457/mGzofIxvlLNv+yXU7oAkHg+2P0YClUDRWSwYS+gzNW1WkZMjHdMiPDS4
	zIkSA37G1+hOuI1yTuvVYHJLaSpGw3GlSKOK16326+Ejuh/wqjOLEHprPfQnMUnU7CvLq0
	xREf1IQI/3ODa0Gral3ruTrIevYT3NU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PhKWZl+l;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792644736;
	b=2OdhmfUrfBXW2ynM2PZ20rsjo8z9pwF83cEOukLq+cRJmscsNTicFZcbuCEgOsNAl4BA3/
	H7K/iaxrRrpOHU+tCRMn9/sUQFaVrg4Dw5GXjDYTIL5fCjqQIFt/rWTimoSAQ7KtOhQT7d
	Eje3nTs5vDvqQ8OdDM6Gz9QxMg/+hWY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3669215A1;
	Wed, 21 Oct 2026 21:52:11 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8A763F673;
	Wed, 21 Oct 2026 21:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792644734; bh=44sAahlGBWki3CLzttdyPd9BArWJwv9oFthryRDKXxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PhKWZl+lITNgn2s18xxBwN4IQraWSJ3Cly36ez4WrldNA0izm/ZvQ/eT/q/NtTu2O
	 4PgjE7ydajX26F5KF1L4HW9UCok/SYdFTfGDRxwnyEZHfcRCJdbgY0fzXDcLsdWysU
	 B8KvEu2vSg01HkJZwbIe1Sxh4H0+haQQcOBzWu9A=
Date: Thu, 22 Oct 2026 10:22:10 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Down <chris@chrisdown.name>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/page_counter: use WRITE_ONCE() for emin/elow when
 parent is the root
Message-ID: <ckukoxkv5cgvk5yywqe7fzxyo43cu7jh7ys5d6qs4rbasxutev@ixfqdcpsppmm>
References: <20261021204818.3431099-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021204818.3431099-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: 9449B1C0003
X-Stat-Signature: rd74iethfxcct5stkwxgey4yt1imamt8
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792644735-238708
X-HE-Meta: U2FsdGVkX1+qHJe+tfhvfBZJQOQzJOipYuNEoj2szDrilba9CePTMt2C7hoD1cB4E5GdeTU6ACWq9LQQd9frF2RtHvVPhtZqwOW4EfQkA1zX76iwX2M2dHPSKrARd7aoYtx91YCnKKrPGOO8Wg9yWNGDN1xsc1Er5C06GjuH25NbA8IIzbQk3ic/h3ZBUd3q7aROsB3ElWWNCM7VKmcafHcP0UheN8+ZrLauNsyM0C56ygn1W3EDgCVgdBZ/wUDk7lds58gcTKc8vAqdJZ4t2R8XttLf7KV8B59gjbUs5+HE4FJT1030NTKR8Q8pOEsdHrz1c8KLvwElNMdjguJXufmqGX0+rCZGEmhtGV0SxnMGATbOLJ9mpTkv4UrCwdQdOofreJcxqLV/6a2gK59Bo4f9P569MNXZe5XDhertCSq9w1+rpDEQS+9BEf9tBSO/9IAVueI10EN1kP+axyKoGtrF1BD4umphbxYXrA/Tox6tf2wIBDz7qHJOG8oSxvPz8lpoq6NLTvOI/vI3RkAuFLYlU8TU+O2Xvg0e9bLbfDfVIjwrj7Fxiwx63oack1CB3PcI/rIrDdERq25Fdc1+FDX45Xl28m9T3pPiChzxM3eBHwYFKkDsmXHrGXNfdoz5/84wxJbpIwgiKWRQ/BIq2BaEob7T3z46A6uOoNyfUjBicM2nynrP3OVRhincunrTYCNvrbTdN0Opcvp48sT15hcR5Ql5L5aHL2UEgP/MMuSCq6obhGIDVmNHXnkj/ESNAlAkthi06heYdMrqu3ZSQhBWbty7asGUmHUQMGLXbkyZoVmJoVirBlt8f3cledbakT0hd0v8Nw9FRne1mNoXFV+HyLteHyZXI1YzYVbQCQN1H3VDkWSzVJmIGGwAj/twaGpkV2ZKzmGM+KaLR1u0t3Op8FO8k7LNLFesnLNNfC1tggMjwBg05pa0INkMHtFT943eprw2pd1h3G9UX3i
 /iQTmEHg
 IgzHMSSb/qD2zO6i+ZgRqIWlrevYPJbdUgjT0a6rMblaiTSbp2AtJm4S4oR+TezlyR06pSvRzZ7sfVdCW9QFACyR9wUx+UOSj4kBDq9UXaj93Lqqft47dfvk574fOZVOlDrQztTkwc/VDqFLJPjT0qttzYQuCjvAkNBFBUGWq5HQ+xens4w+Jch6MNZFCf+if0CPAsZyocBgyAAdqYbPra7vFpX+vyLJ+UzNiBMHyvJhBTM6m5H90h2Y6iuT/ZpLRPmF31YKrAkryLQPtYIaO4jKm1+2IVW1+yzHc57EpAoiMu+DccGiDxjEZRGffihpuK0Noq2dzJtcTwbjJTWOAFTwZqGRUTW3bECWdIvgHqTbe58Crqko4sk1dMTKJixVbWCW4c97CIp1cwirRUZKg/G7ImA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 01:48:18PM -0700, Shakeel Butt wrote:
> page_counter_calculate_protection() runs without locks. Several
> reclaimers can update the same counter's emin and elow at the same
> time, and readers such as mem_cgroup_below_min(), mem_cgroup_protection()
> and the dmem eviction code load them with READ_ONCE().
> 
> Commit b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store
> tearing") made the main path store emin and elow with WRITE_ONCE(), but
> it missed the early return for a counter whose parent is the reclaim
> root. Those two stores are the only plain accesses to emin and elow
> left.
> 
> With CONFIG_KCSAN_STRICT=y, a few tasks writing to the same cgroup's
> memory.reclaim trigger reports like this within seconds:
> 
>   BUG: KCSAN: data-race in page_counter_calculate_protection / shrink_node
> 
>   read (marked) to 0xff1f91b146d40e40 of 8 bytes by task 163 on cpu 4:
>    shrink_node+0x57a/0x1210
>    do_try_to_free_pages+0x194/0x930
>    try_to_free_mem_cgroup_pages+0x204/0x3f0
>    user_proactive_reclaim+0x28a/0x4d0
>    memory_reclaim+0x35/0x50
>    ...
> 
>   write to 0xff1f91b146d40e40 of 8 bytes by task 167 on cpu 6:
>    page_counter_calculate_protection+0x1fa/0x360
>    mem_cgroup_calculate_protection+0x4e/0x70
>    shrink_node+0x53e/0x1210
>    ...
> 
> The default KCSAN config does not report it, because it treats aligned
> word-sized plain writes as atomic.
> 
> Use WRITE_ONCE() for these two stores as well.
> 
> There is no functional change. Readers already accept stale values, and
> compilers emit a single word-sized store either way: with GCC 14 the
> x86-64 object code is the same before and after this change.
> 
> Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store tearing")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/page_counter.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 9167ffd1380c..5293460831f8 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -472,8 +472,8 @@ void page_counter_calculate_protection(struct page_counter *root,
>  		return;
>  
>  	if (parent == root) {
> -		counter->emin = READ_ONCE(counter->min);
> -		counter->elow = READ_ONCE(counter->low);
> +		WRITE_ONCE(counter->emin, READ_ONCE(counter->min));
> +		WRITE_ONCE(counter->elow, READ_ONCE(counter->low));
>  		return;
>  	}
>  
> -- 
> 2.53.0-Meta
> 

