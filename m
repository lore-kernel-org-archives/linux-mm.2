Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2672E109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5A66B054E; Thu, 19 Mar 2026 12:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F176B0550; Thu, 19 Mar 2026 12:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E266B0551; Thu, 19 Mar 2026 12:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8236B054E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:34:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C27611DC66
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:34:11 +0000 (UTC)
X-FDA: 84563359902.11.29391A3
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id DAF4010000D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:34:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="klw7/tbL";
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773938049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MgDUr28BswEKjkiFZqRWKfXqvNYWCmZwzQMS8MvJjQ=;
	b=oaTVendEsd2sCehskaYeFZ0rJBdfhTWU2a9qEMT1PcPTPN5Inat5B7XreyFRnD3zf+Ttmt
	n0oJYb7k6E3YHbOxVx2pfY+MxbhFyTBQor9/59snRTADwF6dQmFjmgPXaVx4PzmcxkAyrh
	Cmb1k7x8aMivnnQ84j+xPFt1SJ0lyc0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="klw7/tbL";
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773938049; a=rsa-sha256;
	cv=none;
	b=XO25M/qq6VWp5WCyCaIdoymKF8J8uHBr+mnrm0Zvle6pCzDsUfNfoGSoOo+3Gxh2toCtb5
	lCKihU12ubpEzB+EmoiMi6SOACESsltCcm/uhlA6HZEH8pmnQ7sz4mDym7u+OR+o/X/yx1
	eZOrsb67IO+aH10ZPQn/0L2ezBl9ldM=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c70f91776fcso510568a12.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773938048; x=1774542848; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5MgDUr28BswEKjkiFZqRWKfXqvNYWCmZwzQMS8MvJjQ=;
        b=klw7/tbLn6w8V1M/eSDI+VnOqfto1EOWoUdLkXfrbp4a/+7a1sCxNG5XOr0O8BDQGA
         5BCT2XiZTifJ2GOsGLU8augYfZ/G9jg82duGkQsAJcDUUgSYjEW/5VnmTXD0TFyz59CQ
         KTIWdj0j+cBvnIBuJZL2pZ5pPaRWahHbRzZHZb0fm5a8ePA83Qmhxi+mwDcdB7TInc5w
         A6Qt03dmWp+sh3vNI4bZlHuOfNNbRphg7YGM7kBQMWeW2FgHXVFGPt9cwypZ+GGL9szU
         V78l8KcUk1VoNrLDMNkywlPW4i0uehi5pzTjOsPF4RVTBVYUKVkR0JiWq4nm9J1MiUuz
         FnLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773938048; x=1774542848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MgDUr28BswEKjkiFZqRWKfXqvNYWCmZwzQMS8MvJjQ=;
        b=QgHVAvBxQ5y0YDcbf9D1sBg9UssZlR8QJbjmYBAnYG08Ok3YAlePG7QtZUKfhyglmR
         59r995YCFxy8+C4L4JzZTMzfrQjIAsrt3A5vaTjiMFgmWuExo+EhQJdq/ACMpIgA8Se4
         6tHFnO4bb1HZAo6kkS5EtXZa4tNzAs2vJNHNvC2JNphz8Njc3+kIGFUXSD5UdLlixP5o
         G38z2g+7gYVa83ftKENBc6CO4e+Qbh222pR0e2Jy0x6ekaLBBkTfWmWn8UIVblwaO3lY
         E4rRN9x468I6EN5QRKw/ub/z2uLwBVdJ/y9n11K/7eeADwIcWJ7J4BMMOBcIJmzo74qo
         KmdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgOlcEKBQI1ymY9ybznCiUKYjk2/yCQILdQcSB9Z4X9xJskccBygUXIeQGfrbvRTPXnDlx3pjEMA==@kvack.org
X-Gm-Message-State: AOJu0Yw5dADja+FQS5+DzSVsfRztWJyIqQnv2zvYknq0NGzhL3mmiP4b
	fWTvhobnyDDiR86VlVzeUXLyCQ3NttLj5WXAigoTe87l+Lp373GRjbs8
X-Gm-Gg: ATEYQzzjg64lnq8cx5uu7LglRr6y6JqTMaRrGd9iDX1xoSGSxpgwkR2hOFDhEbZy4Vp
	zEm5kjjjEn8DHIG4Q06dq4XrHIybQbTU2uGAWCFQSIZdJFQ+jbUdsARHT0nzS6vcLfRD0Y60bhS
	5bHTfByTclAushHuXk0FJj+bDoyYGhcBQEGWhX2v5Ylce/q6SP8XqPqil8ooi8EfGi7FIVK2VEM
	lPmebeQofOQhKUbt66xHLsIlS5WMpsoyvZwy2p6FB3qpYKjBiESz4j5WqUtKRLHL56lFdj7T+na
	08vDiauMB5dQqsjoMwGBJNWb+ZxOVSm7yd+COsG8TC4MCDFaQ00fCZuM9iLrKMfRZTlXc4GdDQM
	s3KtUyuOa0RsnMezDfFqAPRPWzt9klP1p1/CYtfniunJaFGJM+FBzkSWS1aw8V1U3ZP0VKHJ5Vn
	nH0l/0x/9GtUM+RfVLQc8qY7MJup2+rkqsSAxEJ460TDl7i/gialPageH3mgw=
X-Received: by 2002:a17:903:41d2:b0:2ae:57e6:616c with SMTP id d9443c01a7336-2b06e2d6ef1mr78490245ad.3.1773938048301;
        Thu, 19 Mar 2026 09:34:08 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e43074esm63732945ad.19.2026.03.19.09.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 09:34:07 -0700 (PDT)
Date: Fri, 20 Mar 2026 00:34:02 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] mm/swap, PM: hibernate: fix swapoff race in
 uswsusp by getting swap reference
Message-ID: <abp7aDgYLrxF3Me8@KASONG-MC4>
References: <20260317181318.2517015-1-youngjun.park@lge.com>
 <20260317181318.2517015-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317181318.2517015-2-youngjun.park@lge.com>
X-Stat-Signature: io59cjjuonxsxc6z8633zt3nwyabubkw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DAF4010000D
X-HE-Tag: 1773938049-813132
X-HE-Meta: U2FsdGVkX1/9Lui6c/y+qj4oJxOrQH/G3N8jlEN2JbAKWMSUMaOlx4L8wsuCQTvzqEW5CJGSELJv535rpoKBcL+OuHToVqo9n9+HgFCLTBiziuBbI3edAfCLgvwhMzG9MCdDHJaHPR2F+iJPpTtJ6Vh4oUuV5bOIUb7TWQpLvHS/N7iDFmXwBzOGqv5Gx43gxsRQcoIbUiB2E+Zu+0SFa6ipTyUCTb4somyf/r7bVrNhWjpPKy23BvE7P5DyVWPKIYf7uRw1xLDkfJzPCUbngtT5fnD+MnPAAvuyed0vrsNy81kg3P0BizF7sIlSH8rOj/qa/zSFZgrb++yp5/s+D9I74gVsaFjSSxGZZvhLirNLMIogtgB8LyNp6Nh5ey+jBuC/V3I0joMvcZ8DeVOXTFps0ot3q22LV+vbf5wvvY0ahjK5mS7Xwa5UNy2lNpiyloHggHRtgt8mLDue3LNTUszP5uVRQuODoFc3Xe3bH8qgO8Z/1L1pt+1MJe9VE76yU99gVq30hVC90ah6U3n+491fnv7O6nCbjUwio3TjNkAbpWHYtCYPTHjoCejr2Ea/llNSIvH4K7USX1ahR5m4KnAG0AdF+x/Pjk1okTG7yxXQI7UV5hvnFXKMVNNybGZI8oiaVNlzXtRVETI9lsInpopHzlCWDTul4BOPyN6DVvBfAfOAMITGTGn4gr68Re8lnKNL2/lkf2u2hTWqgrkCTOu8XqsctsVInrYDbfevmvkx61FWjBuSeFFqJv05c/NsVLOgoSVJOKkwXvDGumcWG6AMQNwQnXJXsOOOYQ/5b2tlJywi+MrJtGb31qKQWI+vohdG7psR/SKV9W3O2l4M6xjMpW0oFUFKBi+KsKIBlFRPRzklmw3676ANdVEJTcE+YMKOrY/1yNXoNuHuQPMJt8/X2rsfqfGUBv88eawJGKbwEWt9bYnttuSSCYdvi2CfLU9dcRfO/3kL/9C0qBx
 n6yQLKDt
 GQOFgcEpf4FtLeFJjNkZ3Kuruh2rO4zgPDVTAB3aQxQcFVk8qpmFXa/w7Jl7uf0wj0IcByhPncuEFxi0E261tQnVphOt2eZBDoOHz80aypyj+ztIF9UqixtAjguBOZy6jJv+gW0Ij+sYEjo3jBsFzVPZOAa9WcUEmPHUqbnAWIDI4/nNzdnG7aTyJH77cX2errf8F1xS3CLdlV02Rq9wnnJltl4t9BXbvUw8IConEI6HNBPBd/6GLJb197BtVL+AKLTzJKec4s3vAXsAgEbkzC/4MGfP3zKVl3r/uUqt9hasxnPlZU2/jhzPxwpSVvFF29CPF4xdkrMdnaHO4z0RIGKcuoVUfj23UK+4+C/ePhIuf1ra/tg9edo1N3U8Yym3p9kx/QzH3k46mSLM++hdGpKavN6AwSIdlajniL8Xf/YDk8JHYS5ttfukX29tGsv0LcdgetXRghXVyOYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:13:16AM +0800, Youngjun Park wrote:
> Hibernation via uswsusp (/dev/snapshot ioctls) has a race: between
> setting the resume swap area and allocating a swap slot, user-space is
> not yet frozen, so swapoff can run and cause an incorrect slot allocation.
> 
> Fix this by keeping swap_type_of() as a static helper that requires
> swap_lock to be held, and introducing new interfaces that wrap it with
> proper locking and reference management:
> 
> - get_hibernation_swap_type(): Lookup under swap_lock + acquire a swap
>   device reference to block swapoff (used by uswsusp).
> - find_hibernation_swap_type(): Lookup under swap_lock only, no
>   reference. Used by the sysfs path where user-space is already frozen,
>   making swapoff impossible.
> - put_hibernation_swap_type(): Release the reference.
> 
> Because the reference is held via get_swap_device(), swapoff will block
> at wait_for_completion_interruptible() until put_hibernation_swap_type()
> releases it. The wait is interruptible, so swapoff can be cancelled by
> a signal.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  include/linux/swap.h |  4 +-
>  kernel/power/swap.c  |  2 +-
>  kernel/power/user.c  | 15 ++++++--
>  mm/swapfile.c        | 92 ++++++++++++++++++++++++++++++++++++--------
>  4 files changed, 92 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7a09df6977a5..cf8cfdaf34a7 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -433,7 +433,9 @@ static inline long get_nr_swap_pages(void)
>  }
>  
>  extern void si_swapinfo(struct sysinfo *);
> -int swap_type_of(dev_t device, sector_t offset);
> +int get_hibernation_swap_type(dev_t device, sector_t offset);
> +int find_hibernation_swap_type(dev_t device, sector_t offset);
> +void put_hibernation_swap_type(int type);

Hi Youngjun,

Thanks! This set of API looks better that before.

>  
> -/*
> - * Find the swap type that corresponds to given device (if any).
> - *
> - * @offset - number of the PAGE_SIZE-sized block of the device, starting
> - * from 0, in which the swap header is expected to be located.
> - *
> - * This is needed for the suspend to disk (aka swsusp).
> - */
> -int swap_type_of(dev_t device, sector_t offset)
> +static int swap_type_of(dev_t device, sector_t offset)

Maybe rename it while at it, it's a internal helper now and
no one is using it.

>  {
>  	int type;
>  
> +	lockdep_assert_held(&swap_lock);
> +
>  	if (!device)
>  		return -1;
>  
> -	spin_lock(&swap_lock);
>  	for (type = 0; type < nr_swapfiles; type++) {
>  		struct swap_info_struct *sis = swap_info[type];
>  
> @@ -2164,16 +2157,70 @@ int swap_type_of(dev_t device, sector_t offset)
>  		if (device == sis->bdev->bd_dev) {
>  			struct swap_extent *se = first_se(sis);
>  
> -			if (se->start_block == offset) {
> -				spin_unlock(&swap_lock);
> +			if (se->start_block == offset)
>  				return type;
> -			}
>  		}
>  	}
> -	spin_unlock(&swap_lock);
>  	return -ENODEV;
>  }
>  
> +/*
> + * Finds the swap type and safely acquires a reference to the swap device
> + * to prevent race conditions with swapoff.
> + *
> + * This should be used in environments like uswsusp where a race condition
> + * exists between configuring the resume device and allocating a swap slot.
> + * For sysfs hibernation where user-space is frozen (making swapoff
> + * impossible), use find_hibernation_swap_type() instead.
> + *
> + * The caller must drop the reference using put_hibernation_swap_type().
> + */

You can follow the kernel doc format.

> +int get_hibernation_swap_type(dev_t device, sector_t offset)
> +{
> +	int type;
> +	struct swap_info_struct *sis;
> +
> +	spin_lock(&swap_lock);
> +	type = swap_type_of(device, offset);
> +	sis = swap_type_to_info(type);
> +	if (!sis || !get_swap_device_info(sis))
> +		type = -1;
> +
> +	spin_unlock(&swap_lock);
> +	return type;
> +}
> +
> +/*
> + * Drops the reference to the swap device previously acquired by
> + * get_hibernation_swap_type().
> + */
> +void put_hibernation_swap_type(int type)
> +{
> +	struct swap_info_struct *sis;
> +
> +	sis = swap_type_to_info(type);
> +	if (!sis)
> +		return;

I think it should never see sis == NULL here?

> +
> +	put_swap_device(sis);
> +}
> +
> +/*
> + * Simple lookup without acquiring a reference. Used by the sysfs
> + * hibernation path where user-space is already frozen, making
> + * swapoff impossible.
> + */
> +int find_hibernation_swap_type(dev_t device, sector_t offset)
> +{
> +	int type;
> +
> +	spin_lock(&swap_lock);
> +	type = swap_type_of(device, offset);
> +	spin_unlock(&swap_lock);
> +
> +	return type;
> +}
> +
>  int find_first_swap(dev_t *device)
>  {
>  	int type;
> @@ -2971,10 +3018,23 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	 * spinlock) will be waited too.  This makes it easy to
>  	 * prevent folio_test_swapcache() and the following swap cache
>  	 * operations from racing with swapoff.
> +	 *
> +	 * Note: if a hibernation session is actively holding a swap
> +	 * device reference, swapoff will block here until the reference
> +	 * is released via put_hibernation_swap_type() or the wait is
> +	 * interrupted by a signal.

This looks really bad... It means swapoff will hung unless user send a
signal to stop it? How does that happen?

If hibernate may hold a reference without allocating any slot for a
long time, then maybe we better introduce a new si->flags bit to
indicate a device is used by hibernate, so swapoff can abort early
with a -EBUSY.

If hibernate only holds the swap device reference after it allocated
any slot, then we can avoid use a flag but use a hibernate type in
swap table instead:

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 8415ffbe2b9c..025e004fc2e7 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -25,6 +25,7 @@ struct swap_table {
  * PFN:      | SWAP_COUNT |------ PFN -------|10| - Cached slot
  * Pointer:  |----------- Pointer ----------|100| - (Unused)
  * Bad:      |------------- 1 -------------|1000| - Bad slot
+ * Exclusive:|---- 0  ----| ------ 1 -----|10000| - Exclusive usage
  *
  * SWAP_COUNT is `SWP_TB_COUNT_BITS` long, each entry is an atomic long.
  *
@@ -46,6 +47,8 @@ struct swap_table {
  *   because only the lower three bits can be used as a marker for 8 bytes
  *   aligned pointers.
  *
+ * - Exclusive usage: e.g. for hibernation.
+ *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
  */

Both readahead and swapoff (unuse scan) will abort upon seeing such slot,
we solve both readahead and swapoff issue together.

How do you think? We can use the flag idea first.

>  	 */
>  	percpu_ref_kill(&p->users);
>  	synchronize_rcu();
> -	wait_for_completion(&p->comp);
> +	err = wait_for_completion_interruptible(&p->comp);
> +	if (err) {
> +		percpu_ref_resurrect(&p->users);
> +		synchronize_rcu();

Do we need a synchronize_rcu here? It's required above because we are
releasing the resources so all RCU readers must exit from grace
period. But here we are aborting and not releasing anything so
there is no such need?

> +		reinit_completion(&p->comp);
> +		reinsert_swap_info(p);
> +		goto out_dput;
> +	}
> +
>  
>  	flush_work(&p->discard_work);
>  	flush_work(&p->reclaim_work);
> -- 
> 2.34.1

