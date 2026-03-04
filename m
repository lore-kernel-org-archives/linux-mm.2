Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A9EEFCE45
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 19:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC5F6B0005; Wed,  4 Mar 2026 14:46:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C4E6B0088; Wed,  4 Mar 2026 14:46:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BA86B0089; Wed,  4 Mar 2026 14:46:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2573E6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:46:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2A0B160644
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:46:07 +0000 (UTC)
X-FDA: 84509411574.16.6447AEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EFECF100007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:46:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HyFXFNLP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772653566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WcUGO6PyUSdPZQ+NzxNu6Un9ri+BhQX+1Li/diaY494=;
	b=d3p7qDkIGfhrAmDFq7Zmm8G6VhtDPoi+p02jR+6Q7gsaQfUUBRu3piansQA2DCDJDxlszl
	wz4tZc7MrOTA7MEYSWNWQeX0CCCpDK+c9KC7MdwzReABEz3kmq/57f6ey2DX1KdaNaUxP2
	JSs2YA7nr3WJRMOxyVe5LpQEMTKWrb8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HyFXFNLP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772653566; a=rsa-sha256;
	cv=none;
	b=lQmeAp15JajvruUIGVnBRd1RcqnDm7lvDBfUgFdnoj7neMKmoc8pXf64HUNr+nQnMncx4q
	+RSTZdG37B9hshJpPSM4raC50B6Xe25fc6XmJlHq2Fj+iAmLjUEQbbfq89hkjEOV+xA7oj
	ZCYSqe/L9hY01+DcDOEI3/JDoy5Nfps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 339E560053;
	Wed,  4 Mar 2026 19:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95066C4CEF7;
	Wed,  4 Mar 2026 19:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772653564;
	bh=7tnJd6lBFpQA5EoX0mIycpr6qSPclxEDJ6mtM22ZvXs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HyFXFNLPc8UHIpPKKe40mzfhZcUEZYYAZlT9hQfBAn3176Y6W+mJ/kbmhHk1I4ceO
	 Hq4nB64EW61Rh6B/JE38IuaDVez0Dg6hgS3W80l1kjKuDW9OPW0hmJe4DNXCAtN8sx
	 PwjeLLH1os0WVHkUHWwOk1PP1woMGv1UijUyTcYWA3HDvf1fflkniZQso5XPkI5pDt
	 /Sq0Ee2Brz/Ou7o8QgJvzjzjhZcNN4lst4p3w7LaLUJ+bKioBsN6+JYYA16aL1zIhN
	 Fmys5NA8tdfpx2h1pwNflkNqwHWH1x/9VISWvWoosUIp8R7n6ov1DYA5e6MrOxj7X6
	 zJW6gr0uspOMQ==
Message-ID: <f8ff2118-73b9-4f2e-ad36-b6de6164ef45@kernel.org>
Date: Wed, 4 Mar 2026 20:45:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton
 <akpm@linux-foundation.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 Dave Airlie <airlied@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
 <20260303133409.11609-2-thomas.hellstrom@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260303133409.11609-2-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EFECF100007
X-Stat-Signature: gxhst5j676n87tobzgj4hfiewx3b5h7r
X-Rspam-User: 
X-HE-Tag: 1772653565-65298
X-HE-Meta: U2FsdGVkX18xBssNW9xe8T0s1lU3DpENLicNAXSDJPNw3laGRuVDP/NsuYlBLEtXkwCCGv3nfKPhA6QXYnotqLG0rMpRTkJywUsF9/kJNnbyxiWQtNq8oBd+ReGKTpskQkdkWm9cVCbU7KvqEWWbsp9Kc1cOLqg2cHb8WsCCp98Vi/n7ZoH8rT31B3rm2igND13gse9yg3GYlypzrZcRRz2aWvFjN0n/QbqZ0tdy16HBM6aNlgapbOKoZyvW3ZIh1ABUOC5Q4foG0Ls04612+o+I7CI7Of6SpGDrizA30UzD4AQmM1jVpuuwG6JEHjmK+t9FWy+509mhMBUEiVpogwnAo94Bk3He/Cj7OigGB/RPK1en2EmwacWF1s3rBy861NknXAA2tjh1TVq4fXkKjJa+Qv/BVjdUXalfC8EYWUpPA8cANdsvNhJGqJUwBQ5jUXcpVNaSsi16OjZ1Yowz6flIeuIlNS5Bsrr5ozwEN5iUQLFVyOJ1Aqj8KPXZ3aBVtFW4NEOqBeqDPdDgr2JWfKtDfVhbl8ISYfM0Ni2hVJgtMyQtOOW/fOE7KWUmt7hlmoCYvbvpfBW1fRMxlBqvZLseg0dDBk0/UMOUguploJKE6raseBXmKwYGev38cea+BHqGV8/Kuwij9ELD0Wu4ES8gYgAzyhYSFWdmBNigMMxapP12CfW0kklSxHAk5M7X8+0ECuRXqXPsflct0ZifIN7hwTIbm/hz29XVPdSjY8xjHXJGd7qoV4lkYTCvXlwfzOXSdZs6i/D0hrQwPOegqBS3L2eMFpKhxJ8eHp9CjWXpnAnRUySxpATPBhmU6W7w8G2Coa9eVLoo9nXO3NGXWx2EEXo6SaGsVZXYcmGYFTpuX4EDLHsyx99yEFmyUxt+QdlsXMPhwhZxqPPhEsIp4rRTFg56rUc0C7aAVCjkaSFzHbkTxMGeqoVd+jxLW9y8RshMPyFg7YPcdz+p3nT
 WaeD4qIf
 l/PuRzGmJUtRRqsGtcwYCbWOpIWyQoO8KwPjjionyg374aXZ5OrQSKor8esJD2kEe9KmbjVeG0Oj1GpxNXqgC8SkUdZQDhIf0d5V35rANtpJ+kjyoAB1ZUsEJYV/CiUOTYVg9MOHSdfltcMbZT4CVH3nCid9KKF3nxBbZvEqZ4Eib/RT944Q3gMjkKgoomC+Z6ssgU+4iJ4TUfOg9/RlbsChsF+fqAuRNiJ6KxjrZeLTG5SPKhIG2pCQKMzjEOVpRmOh0OXlqj1vztDksjaGnZqjUyCmj+ABEXKAW9PXT+3KAUj8W95mgCHIGE1dF097y6CMZaW+DarxBPj/7ehibXaqjvGwEWMtkFH3WqREFnKfMqNQgPMzlL6RZKqqJvwSYF/WLhSMY4l9e5nsI/g+WFe+WIGbw7DLqxGoLIkFLxMyit0hogeX6K4AtVVoNo+efNlGInr4JdBPF4KYKtoiSzOE9K/qVKS3g7hSjeZxL/drPIefr5q3qnplTsAzvYlrbVi99l9YyL5DR1cix75uOIm21c/QdLrouD5Dnsrb5Tst0T+kOro+dDdKUB7a5D17jZ9BT4pMbCzxkQRQVxggCnFcx/12QIpvwf22zBmu4WmtyW//3tOcNMW81eZH4p0ibMkCpzitCPjqnPnSM8Yifv1WVRzGUDLQLexiB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 14:34, Thomas Hellström wrote:
> GPU use-cases for mmu_interval_notifiers with hmm often involve
> starting a gpu operation and then waiting for it to complete.
> These operations are typically context preemption or TLB flushing.
> 
> With single-pass notifiers per GPU this doesn't scale in
> multi-gpu scenarios. In those scenarios we'd want to first start
> preemption- or TLB flushing on all GPUs and as a second pass wait
> for them to complete.
> 
> One can do this on per-driver basis multiplexing per-driver
> notifiers but that would mean sharing the notifier "user" lock
> across all GPUs and that doesn't scale well either, so adding support
> for multi-pass in the core appears to be the right choice.
> 
> Implement two-pass capability in the mmu_interval_notifier. Use a
> linked list for the final passes to minimize the impact for
> use-cases that don't need the multi-pass functionality by avoiding
> a second interval tree walk, and to be able to easily pass data
> between the two passes.
> 
> v1:
> - Restrict to two passes (Jason Gunthorpe)
> - Improve on documentation (Jason Gunthorpe)
> - Improve on function naming (Alistair Popple)
> v2:
> - Include the invalidate_finish() callback in the
>   struct mmu_interval_notifier_ops.
> - Update documentation (GitHub Copilot:claude-sonnet-4.6)
> - Use lockless list for list management.
> v3:
> - Update kerneldoc for the struct mmu_interval_notifier_finish::list member
>   (Matthew Brost)
> - Add a WARN_ON_ONCE() checking for NULL invalidate_finish() op if
>   if invalidate_start() is non-NULL. (Matthew Brost)
> 
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Simona Vetter <simona.vetter@ffwll.ch>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: <dri-devel@lists.freedesktop.org>
> Cc: <linux-mm@kvack.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> Assisted-by: GitHub Copilot:claude-sonnet-4.6 # Documentation only.
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> ---
>  include/linux/mmu_notifier.h | 38 +++++++++++++++++++++
>  mm/mmu_notifier.c            | 65 +++++++++++++++++++++++++++++++-----
>  2 files changed, 94 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 07a2bbaf86e9..37b683163235 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -233,16 +233,54 @@ struct mmu_notifier {
>  	unsigned int users;
>  };
>  
> +/**
> + * struct mmu_interval_notifier_finish - mmu_interval_notifier two-pass abstraction
> + * @link: Lockless list link for the notifiers pending pass list
> + * @notifier: The mmu_interval_notifier for which the finish pass is called.
> + *
> + * Allocate, typically using GFP_NOWAIT in the interval notifier's first pass.

Might want to make it clear that the fist pass is "start" and the second
pass is "finish".

Two-pass makes it sound like we'd be calling the same operation (e.g.,
invalidate() ) twice.

> + * If allocation fails (which is not unlikely under memory pressure), fall back
> + * to single-pass operation. 

Do you mean that the core will fallback (calling invalidate() ) or that
it's the responsibility of the notifier to behave as if invalidate()
would be called to then return finish=NULL? I assume the latter.

Maybe this should be documented for @invalidate_start instead. (behave
like invalidate() if @finish is %NULL on return etc)

> Note that with a large number of notifiers
> + * implementing two passes, allocation with GFP_NOWAIT will become increasingly
> + * likely to fail, so consider implementing a small pool instead of using
> + * kmalloc() allocations.
> + *
> + * If the implementation needs to pass data between the two passes,
> + * the recommended way is to embed struct mmu_interval_notifier_finish into a larger
> + * structure that also contains the data needed to be shared. Keep in mind that
> + * a notifier callback can be invoked in parallel, and each invocation needs its
> + * own struct mmu_interval_notifier_finish.
> + */
> +struct mmu_interval_notifier_finish {
> +	struct llist_node link;
> +	struct mmu_interval_notifier *notifier;
> +};
> +
>  /**
>   * struct mmu_interval_notifier_ops
>   * @invalidate: Upon return the caller must stop using any SPTEs within this
>   *              range. This function can sleep. Return false only if sleeping
>   *              was required but mmu_notifier_range_blockable(range) is false.
> + * @invalidate_start: Similar to @invalidate, but intended for two-pass notifier
> + *                    callbacks where the call to @invalidate_start is the first
> + *                    pass and any struct mmu_interval_notifier_finish pointer
> + *                    returned in the @finish parameter describes the final pass.
> + *                    If @finish is %NULL on return, then no final pass will be
> + *                    called.

Is @finish guaranteed to be set to %NULL before the call? The existing
code does it, but is it something notifiers can rely on?

> + * @invalidate_finish: Called as the second pass for any notifier that returned
> + *                     a non-NULL @finish from @invalidate_start. The @finish
> + *                     pointer passed here is the same one returned by
> + *                     @invalidate_start.
>   */
>  struct mmu_interval_notifier_ops {
>  	bool (*invalidate)(struct mmu_interval_notifier *interval_sub,
>  			   const struct mmu_notifier_range *range,
>  			   unsigned long cur_seq);
> +	bool (*invalidate_start)(struct mmu_interval_notifier *interval_sub,
> +				 const struct mmu_notifier_range *range,
> +				 unsigned long cur_seq,
> +				 struct mmu_interval_notifier_finish **finish);
> +	void (*invalidate_finish)(struct mmu_interval_notifier_finish *finish);
>  };


Nothing else jumped at me, and the idea makes sense.

-- 
Cheers,

David

