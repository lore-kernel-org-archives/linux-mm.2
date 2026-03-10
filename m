Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E73FD2D9A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DEC86B00CC; Tue, 10 Mar 2026 10:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E186B00CE; Tue, 10 Mar 2026 10:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A7B6B00D1; Tue, 10 Mar 2026 10:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 043556B00CC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:04:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D969F569FF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:04:56 +0000 (UTC)
X-FDA: 84530324592.03.522C6F6
Received: from lankhorst.se (unknown [141.105.120.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4A4FE12001B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:04:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=TDCpneR7;
	spf=pass (imf29.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773151495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nw+2RI1UdZCQMNTBlqjHNx0WyDX4h7rXKbPOwoHtiCU=;
	b=I+4v3atuO6UtUJoIth61aec/KthrYoDJ61q7thq3m5z/O3rHCthS8dziEK9bcmHQh4/6M3
	g9MtR8OZF1lBnhIXQ2dYVihF+J9tmILX3nHu3TBC+MHHNa+HnLwS4MQ/Gi7U1lgr3Uncec
	WAzOrWJy6MF5CpinQLn8UePnF1rKRw8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=TDCpneR7;
	spf=pass (imf29.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773151495; a=rsa-sha256;
	cv=none;
	b=fVkXVCVR5aT90fR33vcmIc8fRegcbfO8xdQN2CwGbMx/Gpo+WTdX9ibCjzhya1dkKZTcQ6
	2t/LxbsEP26x4omuZP5M7GoA2hMeQPJgtm56EA0QJZ9TRMfRJMq6Bp0JG01UJrjtJ/wguY
	2Ik5cTpTs8bbjxwM0RbYnnsPvfJnI0I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1773151492;
	bh=AP771/2zE2q+ybEw63w0gq1+eWjICIZaqX8QtFkg6Y4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TDCpneR7rSc+QsWPXUAi5CDqj4FadL5YZY4sWe00jbEuKTQgONEFhoonbVt4hniNf
	 VhpLLLWQ70xI8zDfoxRffkEJD9Askb5DHQB5opl/sY3VBGIkoHubgm/16dTNV7Dv7l
	 65SQcXGQpw7u+HQJlObkfrVRGo/IsBev2GYqVhQx+ozIkqH3JwsNP+s8ClFNpzOjNV
	 WzGgMkJnt/V6yyGNPf5bP2kxLY8pyxtUOmlz/ilsBK/2qYZg/NUxLU0APnuZbSaOn5
	 iU2+iSnTJBC+Au5hP8hlzI+vmqOV8X0Q+GP4dTAGm2mZl8eiMr8A4P8V4dPjCi8aKE
	 /+yh/IvMyNaYw==
Message-ID: <250c4fe8-8f7a-4a0e-8439-53bb12987b3d@lankhorst.se>
Date: Tue, 10 Mar 2026 15:04:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Simona Vetter <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
 Alistair Popple <apopple@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
 <20260305093909.43623-2-thomas.hellstrom@linux.intel.com>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <20260305093909.43623-2-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A4FE12001B
X-Stat-Signature: o8hadaticy9tsq3s5yst6d1ujtkfn7jp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773151494-56660
X-HE-Meta: U2FsdGVkX1/ZMD53hTkCdujwdK7s5RVb3z1WbsNiPYznQGeyNcDpAfI0Q1rfuPZiqeoD0vNjkRh8hB6lusG61AnXyiYq6heKX6b1Z1NccuXgJHggCFiY/B3RMsL6O1GbU+FdfU4y8jFSXnrGmhl7lGjVaRxsbckd8iMtjslZHf4ZaQvOdVWCHuk9XpqvTEDQ8U2Acfi+uXjL526sGmS2C4qsL8Y8Q8A9oIv2WhjAr4AgWDX5IajVf5Wck7palE2c5mWP2jZUALjE//8NKnRP7HQJdhFovNcd+4A2cpwbn5nh6yd29Cfn/k99XJCOZAoHNSCRr6r5L8tIKIdgEednRXYtStrb6nVxp8n4baUSBbvcY+51MIMgyNRdfOYvMkiDhuTRlZeVFM6MktrVVslEy4zAEFnOclAKIJlmke3j7y2JouGH+nujjjGlYt0fy5krAhhs4fCZ3EjpaRQ4LBY/YMrLXxvynAmIwaZstTC4qz+HTiF+UTu7rtADgRtf6B28y0XVZY+aTQAeW3sOhGGfYyfKf0iPcFL8tb+5/ay3n7UeKifID6SuCHaKRU8IYz9YcYP04e2L/CEYUG0qlGYuy/mzfYpPVWtA2KnOx9iILDwwGj2sqOcobLhDA5CY+U5wcRyqO2UWC4UdI4UwlP127ZAfN1CbSWihAqS/3k4cBh9nCngqrpjN4yLq+rywtA7LpIxST4PQPuOdz+YIpL32TnNEnLZq2dNKTE1Ys8nl18pbCDTH4Uj9OcI6XlfeUwBSXxjDowA0TLpOMeCFaF++cu7d2pNbmI2Q4FVyPPkZB8WhYAZe46iXx4oooHeXSx8LL2f2f8mjXD8+zBUzTrcCpOxzrHb58HDPUML1/bn21pw7uZvWeveyQE+rKslS9HIgFgWO0OVJOTp4Bt3kplynlJcRsE0mSx9qqSjUHSihj11zNb4KoUblhNUkU6ehRs6u9sqclTmgNNI/97bFc16
 9X4m4uCA
 E5zkF5cGeL9QCxhYkdOZ9Lu6mhZW2u4BT79uq/zJLJvEzC+32xzuGJGcUeBlOnCwfJGwDttDY279yuyPQh7eruc1lWiJrycHlY2QRJye4khgIe6n6fDbjV+MOWeGgGryKYOPds++AkQwhwF0o0spr7RHda8bxDkZp3yEBdfjjl4dwv/YuNFCTT7cDmszXhhj6QiG/ScvO/yN7myo8wEkjsYmAVFzhY//H88eQ6bKe57FLNQeZDZ48gKH7qe2bmh9g0zzHAbe2pLLhSIU744tS6EPUAPaZF0zp97WDZ6hjs7pjzbFdk0yOKktbCF0+YxRqJD5r9TQgMwO0Kt9/iECib+r8pDTRhN333I+a+wK6pLuRlkpmQhT743oQe7OLBQmYfj5Xbm3uv3TGvFd1usqH2BMNlTzjDb2chqtRq28whlKyctr6pWWPTBD29zErxsAeeBmlBWI/2Hj1SeSLhHMz3OO4vEaJVJvWQQ+HYrIt7/88WZ4sDxynfbLF3nMVQmP0+GJGbR2bdXnOQus9rKbSXdM8/PALTjjbre938XoFn14K5vP/E99ntz8AFrWhR2I8IhKxtSLn7i0IYTC8g82Chs4JsiQGYS1P+q+5WVBQmwk9Tmioo113ev0VuPiZBZtMUcqr5M1jfebtIFXLXuNan9FPORDZSzgxTORASzVkCSBvfa08EKQeWr9lYHQ2wyYJZsM6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,


Den 2026-03-05 kl. 10:39, skrev Thomas Hellström:
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
> v4:
> - Addressed documentation review comments by David Hildenbrand.
>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
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
>  include/linux/mmu_notifier.h | 42 +++++++++++++++++++++++
>  mm/mmu_notifier.c            | 65 +++++++++++++++++++++++++++++++-----
>  2 files changed, 98 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 07a2bbaf86e9..dcdfdf1e0b39 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -233,16 +233,58 @@ struct mmu_notifier {
>  	unsigned int users;
>  };
>  
> +/**
> + * struct mmu_interval_notifier_finish - mmu_interval_notifier two-pass abstraction
> + * @link: Lockless list link for the notifiers pending pass list
> + * @notifier: The mmu_interval_notifier for which the finish pass is called.
> + *
> + * Allocate, typically using GFP_NOWAIT in the interval notifier's start pass.
> + * Note that with a large number of notifiers implementing two passes,
> + * allocation with GFP_NOWAIT will become increasingly likely to fail, so consider
> + * implementing a small pool instead of using kmalloc() allocations.
> + *
> + * If the implementation needs to pass data between the start and the finish passes,
> + * the recommended way is to embed struct mmu_interval_notifier_finish into a larger
> + * structure that also contains the data needed to be shared. Keep in mind that
> + * a notifier callback can be invoked in parallel, and each invocation needs its
> + * own struct mmu_interval_notifier_finish.
> + *
> + * If allocation fails, then the &mmu_interval_notifier_ops->invalidate_start op
> + * needs to implements the full notifier functionality. Please refer to its
> + * documentation.
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
> + *                    returned in the @finish parameter describes the finish pass.
> + *                    If *@finish is %NULL on return, then no final pass will be
> + *                    called, and @invalidate_start needs to implement the full
> + *                    notifier, behaving like @invalidate. The value of *@finish
> + *                    is guaranteed to be %NULL at function entry.
> + * @invalidate_finish: Called as the second pass for any notifier that returned
> + *                     a non-NULL *@finish from @invalidate_start. The @finish
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
>  
>  struct mmu_interval_notifier {
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index a6cdf3674bdc..4d8a64ce8eda 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -260,6 +260,15 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
>  }
>  EXPORT_SYMBOL_GPL(mmu_interval_read_begin);
>  
> +static void mn_itree_finish_pass(struct llist_head *finish_passes)
> +{
> +	struct llist_node *first = llist_reverse_order(__llist_del_all(finish_passes));
> +	struct mmu_interval_notifier_finish *f, *next;
> +
> +	llist_for_each_entry_safe(f, next, first, link)
> +		f->notifier->ops->invalidate_finish(f);
> +}
> +
>  static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
>  			     struct mm_struct *mm)
>  {
> @@ -271,6 +280,7 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
>  		.end = ULONG_MAX,
>  	};
>  	struct mmu_interval_notifier *interval_sub;
> +	LLIST_HEAD(finish_passes);
>  	unsigned long cur_seq;
>  	bool ret;
>  
> @@ -278,11 +288,27 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
>  		     mn_itree_inv_start_range(subscriptions, &range, &cur_seq);
>  	     interval_sub;
>  	     interval_sub = mn_itree_inv_next(interval_sub, &range)) {
> -		ret = interval_sub->ops->invalidate(interval_sub, &range,
> -						    cur_seq);
> +		if (interval_sub->ops->invalidate_start) {
> +			struct mmu_interval_notifier_finish *finish = NULL;
> +
> +			ret = interval_sub->ops->invalidate_start(interval_sub,
> +								  &range,
> +								  cur_seq,
> +								  &finish);
> +			if (ret && finish) {
> +				finish->notifier = interval_sub;
> +				__llist_add(&finish->link, &finish_passes);
> +			}
Should we warn if !ret && finish?

Anyway, looks good either way.

Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>


> +		} else {
> +			ret = interval_sub->ops->invalidate(interval_sub,
> +							    &range,
> +							    cur_seq);
> +		}
>  		WARN_ON(!ret);
>  	}
>  
> +	mn_itree_finish_pass(&finish_passes);
>  	mn_itree_inv_end(subscriptions);
>  }
>  
> @@ -430,7 +456,9 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
>  			       const struct mmu_notifier_range *range)
>  {
>  	struct mmu_interval_notifier *interval_sub;
> +	LLIST_HEAD(finish_passes);
>  	unsigned long cur_seq;
> +	int err = 0;
>  
>  	for (interval_sub =
>  		     mn_itree_inv_start_range(subscriptions, range, &cur_seq);
> @@ -438,23 +466,41 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
>  	     interval_sub = mn_itree_inv_next(interval_sub, range)) {
>  		bool ret;
>  
> -		ret = interval_sub->ops->invalidate(interval_sub, range,
> -						    cur_seq);
> +		if (interval_sub->ops->invalidate_start) {
> +			struct mmu_interval_notifier_finish *finish = NULL;
> +
> +			ret = interval_sub->ops->invalidate_start(interval_sub,
> +								  range,
> +								  cur_seq,
> +								  &finish);
> +			if (ret && finish) {
> +				finish->notifier = interval_sub;
> +				__llist_add(&finish->link, &finish_passes);
> +			}
> +
> +		} else {
> +			ret = interval_sub->ops->invalidate(interval_sub,
> +							    range,
> +							    cur_seq);
> +		}
>  		if (!ret) {
>  			if (WARN_ON(mmu_notifier_range_blockable(range)))
>  				continue;
> -			goto out_would_block;
> +			err = -EAGAIN;
> +			break;
>  		}
>  	}
> -	return 0;
>  
> -out_would_block:
> +	mn_itree_finish_pass(&finish_passes);
> +
>  	/*
>  	 * On -EAGAIN the non-blocking caller is not allowed to call
>  	 * invalidate_range_end()
>  	 */
> -	mn_itree_inv_end(subscriptions);
> -	return -EAGAIN;
> +	if (err)
> +		mn_itree_inv_end(subscriptions);
> +
> +	return err;
>  }
>  
>  static int mn_hlist_invalidate_range_start(
> @@ -976,6 +1022,7 @@ int mmu_interval_notifier_insert(struct mmu_interval_notifier *interval_sub,
>  	struct mmu_notifier_subscriptions *subscriptions;
>  	int ret;
>  
> +	WARN_ON_ONCE(ops->invalidate_start && !ops->invalidate_finish);
>  	might_lock(&mm->mmap_lock);
>  
>  	subscriptions = smp_load_acquire(&mm->notifier_subscriptions);


