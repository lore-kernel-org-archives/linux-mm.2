Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD891093163
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE1B6B042E; Thu, 19 Mar 2026 22:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67F416B042F; Thu, 19 Mar 2026 22:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BBF76B0431; Thu, 19 Mar 2026 22:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3606B042E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:06:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9496B8C441
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:06:34 +0000 (UTC)
X-FDA: 84564802308.09.E757404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2719320007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:06:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kbq23YgW;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773972393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LpXXtD9pyhyFJOQQsJXD4VrzLtI1hX6L7hFWvwwl+g=;
	b=Pai3WGi0b82OMewEmIfdgST8aRUVDZHnskWlSZdRVHwHbX52NszW9ff1/I63eEINpFPnP+
	bhBwxaRlso1ScULPd3PJlNFDMfr141+veCjIj79L9fMOhX+gJAkhHWeWzCgSWxES9MzmZd
	nvVHPsv9qDP9rvXWHW2kuIU10Joqz7I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kbq23YgW;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773972393; a=rsa-sha256;
	cv=none;
	b=TXf6oMCZiZ42r5grfLLLcNNYQdf2Z/tJJzKcKJ+eKp4YuHDlK7oXDzznKuy7TjbS1mQX5l
	Q2fyTc7YwJd32Qw16/i9F6coKA93fEJyxaZaOKrqZYeI59HqQk/XYqVwLdL1UOoHCm1LJy
	YfHCOAUPN+gg3mVwtrtKdQzd47CH5PQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BBDC60130;
	Fri, 20 Mar 2026 02:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D077C19425;
	Fri, 20 Mar 2026 02:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773972392;
	bh=EA46jYNSfw3VoMwUyxiACyfTCl7m3PbZup4E7Q2qYW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kbq23YgW9TsCQrnz8w6bBfpkjJGurn7tOLEEsI6+dYdUKWNkAkH4pF/7ArNqaH+6A
	 NiWu0Vg6OEHtBAoiz9EfpsaTc5aXCsAI1ugnwXOSYCoKNNX8USeHgsaBz3cRIMiAls
	 zRCEeKfrCFWcKqskHBQiuBaDrQU2DioD01VUPyhk9URS7QOJ/s4CikRr6o/jywONcs
	 vxMvfCKD2e8siakXW9VD+CACbeRVd+NOwqU3sykmjKPFYijBO8FVbxze+UIP/kd3fo
	 k/TmgeC6jez/1tHKuTjJw9WX6R1fyFXwNPSR/VhahmTi7Xu5dqmDCjQbaFpYTs0cLR
	 yKjWI33NCqQ8g==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Thu, 19 Mar 2026 19:06:29 -0700
Message-ID: <20260320020630.962-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319155742.186627-5-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2719320007
X-Rspamd-Server: rspam08
X-Stat-Signature: dua3h55cu7f894csmegga9xenye1tof1
X-HE-Tag: 1773972393-936253
X-HE-Meta: U2FsdGVkX1/8dt7bye20lS9NlHxHr+Et0ffL4g+aofcPYLAb7vY76uE4yDrjOj8urQ4TSNgicTynmVAyQ/woAo8Oj7XkSwSZaq3bm4nvy3cM9WBcGbsz9lqvBlO4EKDXFh26S8iB8km77g1yEj/TDiRgFK+d8zujpJqP/SOpZox6oKFIHPimvb1Lg89Uv6CuBdaVvqvzVN5SribBeRLfAY7q71qTSLK+pH4fXb2CvhW83q69XAr6YlJidvtKpxpHy2dLN29D4G4QeIpopdreY9q517rVvKCT6OLZZihp8hU2dlFLcp7Da50Wu546NQ93Wdy7RUMqi1tAeeC4HnDreO5dMgj7q5G8LGxKN3mV7VV27X3VQL8DecswN4xskfIGqVlZpQKK23lb3DIuoMDbbvL7lYyk/WK3VqniCjA8qUmcn3hciu7zo/87KL1321waiUAqcPyyIw9RXKGyaVDL/9dO3zFGZX+ca7wTY0PFB0JKpgK+8FY/cacHCyEyqorQ/Qy/VtUc6yFWBXFnHJva075IDeKp0dRhwS1vfzxStegFVKXij35TJ4kvnvOLZvo+8eMPLXN1fnFkhx3yz5Ojp1DFpOPwQMN1PMObKRpSmO4541kUONdbP4l49fH3xAbkU1OhBIAk4iDr+tKlOSpQ4a2p9tPMxFQeKi6oZzfRdbWiAuhCqvIYCTptG9iJ23S/dEYr4FohQzeqC0nLU/O2GaRPY7VM+X0DT5+FMFBjRCO5dGDGG+DBf5LB28Gl6ygZWM45tjMhNFoocUiNRgw8HOn4z0etoLDORHWr2jnLalKnYiHFld7Prqd/9Hy+0rzhRAhRqr7QSLR30yjey00IshybtPXJHDp/7Oilqm9/LORlUCN/jFK9SD5zxj8/w2NT+zTKuCadXyitHLgLE4LYxS0sQOwaW1PspBDFXj99n/dWe+uJVu+hlhw0kQJW1nTV4XgGgIEkSw8rG4C91+M
 Xxa2W1eb
 9Dr+R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 15:57:42 +0000 Josh Law <objecting@objecting.org> wrote:

> damon_sysfs_repeat_call_fn() accesses contexts_arr[0] in
> upd_tuned_intervals, upd_schemes_stats, and upd_schemes_effective_quotas
> without checking nr_contexts. A user can set nr_contexts to 0 via sysfs
> while DAMON is running, causing a NULL pointer dereference in the
> repeat callback. Add a guard under the lock.

Good catch!

Priveleged users can trigger this.

    # damo start --refresh_stat 1s
    # echo 0 > /sys/kernel/mm/damon/admin/kdamonds/0/contexts/nr_contexts
    # dmesg
    [...]
    [  277.616182] BUG: kernel NULL pointer dereference, address: 0000000000000000
    [...]

So, I think this deserves Fixes: and Cc: stable.

Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Cc: <stable@vger.kernel.org> # 6.17.x

> 
> Signed-off-by: Josh Law <objecting@objecting.org>

Reviewed-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/sysfs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index ddcdc4e35b27..d982f2dc7a2b 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1620,9 +1620,12 @@ static int damon_sysfs_repeat_call_fn(void *data)
>  
>  	if (!mutex_trylock(&damon_sysfs_lock))
>  		return 0;
> +	if (sysfs_kdamond->contexts->nr != 1)
> +		goto out;
>  	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
>  	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
>  	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
> +out:
>  	mutex_unlock(&damon_sysfs_lock);
>  	return 0;
>  }
> -- 
> 2.34.1

Sashiko comment.  TL; DR: Good points, but orthogonal to this patch.  I will
work for those.

: Does this check fully prevent the NULL pointer dereference? A user can still
: manually trigger these callbacks by writing commands like
: update_tuned_intervals or update_schemes_stats to the state sysfs file.
: 
: Those commands execute through damon_sysfs_handle_cmd() and
: damon_sysfs_damon_call(), which add the callback to the running DAMON thread
: without checking if contexts->nr != 1. When the kdamond thread executes the
: manual command, it seems it would unconditionally dereference
: contexts_arr[0], which could be NULL.
: 
: Would it be safer to place the contexts->nr != 1 check directly inside the
: callback functions (damon_sysfs_upd_tuned_intervals, etc.) to cover all
: entry points?

Good point, but this is orthogonal to this patch.

And the second and the third patches of this series is actually making fixes
for parts of the problems Sashiko mentioned.  I also have an opinion to fix
similar issues in one place.  Let's discuss that on the second patch.

: 
: >  	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
: >  	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
: >  	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
: > +out:
: >  	mutex_unlock(&damon_sysfs_lock);
: >  	return 0;
: >  }
: 
: Looking at the context just above this diff in damon_sysfs_repeat_call_fn(),
: is it intentional that damon_sysfs_next_update_jiffies is a static global
: variable?
: 
: static int damon_sysfs_repeat_call_fn(void *data)
: {
:         struct damon_sysfs_kdamond *sysfs_kdamond = data;
: 
:         if (!sysfs_kdamond->refresh_ms)
:                 return 0;
:         if (time_before(jiffies, damon_sysfs_next_update_jiffies))
:                 return 0;
:         damon_sysfs_next_update_jiffies = jiffies +
:                 msecs_to_jiffies(sysfs_kdamond->refresh_ms);
: 
: Since users can create multiple independent kdamond instances via sysfs,
: each running its own thread with a unique refresh_ms interval, multiple
: threads running this function could concurrently read and overwrite the exact
: same timer.
: 
: This seems like it would cause independent kdamond instances to clobber each
: other's refresh cycles, resulting in delayed or skipped interval updates.
: Could this be moved to a per-kdamond field?

Makes sense, but orthogonal to this patch.  I will work on this.

: 
: Also, looking at damon_sysfs_turn_damon_on() which sets up this repeat
: call function:
: 
: static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
: {
:         ...
:         repeat_call_control = kmalloc_obj(*repeat_call_control);
:         ...
:         err = damon_start(&ctx, 1, false);
:         ...
:         damon_call(ctx, repeat_call_control);
:         return err;
: }
: 
: Could this leak the repeat_call_control allocation?
: 
: If the kdamond thread exits prematurely right after damon_start(), the
: context becomes inactive. When damon_call() executes, it checks
: damon_is_running(). Since it is false, damon_call_handle_inactive_ctx()
: unlinks the control block and returns -EINVAL without freeing the control
: block or evaluating dealloc_on_cancel.
: 
: Because damon_sysfs_turn_damon_on() ignores the return value of damon_call(),
: returning the success code from damon_start() instead, it appears the memory
: allocated for repeat_call_control is lost.

Makes sense, but orthogonal to this patch.  I will work on this.

# review url: https://sashiko.dev/#/patchset/20260319155742.186627-5-objecting@objecting.org


Thanks,
SJ

