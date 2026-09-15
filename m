Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F156FC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 05:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823546B008C; Tue, 15 Sep 2026 01:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBD16B0092; Tue, 15 Sep 2026 01:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739546B0093; Tue, 15 Sep 2026 01:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 585B26B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:22:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBC291A031B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:22:49 +0000 (UTC)
X-FDA: 85214852058.16.15512AB
Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	by imf29.hostedemail.com (Postfix) with ESMTP id D23CF120006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:22:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J1byXJmy;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789449768;
	b=SmTLkt3QosgGipE2vPemLJQtV3aTMI/8eP2nIU4MYpFkqVapT3zRpTPLc4wRHvazJ4RDG7
	u01Lk+o/u7zJi7SLbomM5b1QLU0SK+42YgR6H430cuNJPyj9qZg8ijjq2cNYy5bLBZkT5O
	AzoJZN/Jf63cfaXKhe/+v6cw0HwnZYE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J1byXJmy;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789449768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQapacxwvAbpmnzRVDitncq4y+knzi/1opoZ2svGblw=;
	b=4V4ER6GGoLdx3bjE7ax42HV1ZT2bl9asct8y+BhtJoFVmV+W0FBXWuLIw/nNtbih4IxpOH
	awapbc9H9RG1j9hhtMRlDCG1Satdj2k7IIGW/UUdTrRgtEvnmOwS7cGguj8PE/AX+027fb
	kIswKM4PZcuxFw0iL04Gy98k7GZDhgc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=njbyAGe9sVIfrxx3rQdN/BfT/8E/nBGlOZNoa510jIU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789449766; v=1; x=1790054566;
 b=J1byXJmyxc3m0w76zlTnWiX7Vh6LO64eYWnSoEznnBuKJpvuQvH4eRjMuZC8C91CUVfD4WLJ
 JW+HE3H1PcdldgTW3tyCkEaueTKK4SKMAy4fvjFW0+v9UPWuICqawBefw3WZWuAOkUYANnaZiyf
 xlEwrWN+Y5BOpngi2sXEDnAM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 5c2feea308c47c3f;
	Tue, 15 Sep 2026 05:22:36 +0000
X-Mizu-Trace-ID: 5c2feea308c47c3f
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 13:22:26 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com, chrisl@kernel.org
Subject: Re: [PATCH] mm: zswap: return -ENOENT when the swap device is gone
Message-ID: <aqjWElGYfZWUZmV3@fedora>
References: <20260913063031.1689420-1-hebaoquan@kylinos.cn>
 <20260913005149.a28c21aaca165fa0255f8475@linux-foundation.org>
 <aqeUyxJmzC397G7j@fedora>
 <20260914211658.644e5b9b61405f4a9460b8df@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914211658.644e5b9b61405f4a9460b8df@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D23CF120006
X-Stat-Signature: zqsyhbhtu7f6nt5ae8yscwqfkw4hxguz
X-HE-Tag: 1789449767-985467
X-HE-Meta: U2FsdGVkX183Fix5+bEwATEgkXmGXJGAdlGyVC85qK3HizZV4NPeKZ0p55HyHr2ynaymEXS9NrqWSuCtV8RYmoyvEYTFZm1XvKWJkrxDrhtWeXTbtUeaq9EqsMYyO+Es8z+CWc+ROn3adRUN/VX3cBgKE+/w9j1yoWCB5ruxtwDzv/rNgPXYqNHI6C0jWoL8mteq3G3f0KzlR/q/Jx+ieciXXk4DaIk3beJBKL3DVrMjMGY3sqtLXZAMaVGUKJ9zMaJcjiCzqaaStm/KktTbvqfeFDxcxaL7LI7aoVDajp/vDt3GAedI7l/SArw33WnXg8YoxOgHEulr6uj0/OFJm9UHbWIC5Q1UPtx3+t09GPQvHZm6wgCmFPvFFwcGQ7VPCett8CCDtKjceuBr+5HvS5w7Ipgu7hpNAUsjSwQBQuHjGErvzzwZnOdjhboPxYedyZE3ZLKUvKmO2IKYkyT1pUsFET6wmhI1IMRbYxLqPmpB5pxDcSHTTleRCdQ2iX0+d3tmxffaH7LgYv5omD/YMWxxlc0AoSJRdeyVYcB6EWmLD2LDP0KN6TU6vexHQ036AwvRMBsGVqjgsf8S/F53NeXeG0bIPdGXsHz5GdexqkjYDzfjhaUGX1KgzgAZIq/8UmDK9qWYGEME258EcS+QKYc83duTXbWSdI2gSarRQFptPPp2OSnwHb7YHnr9i+YNfTdjhEDCLHzz5rkhaE3m38inAJiuJ29vLZ2lbPiin/xb8rYvfr7nv9dKAw7hCqwZ2yUMmCs+eAWjT0LnElwrhQyNEr2xEk1buVIc5PEbhbyUqnANeW0xaHDJQ3t342vxgvTv+jz5rddJ2FuOfW/mHiYPjNlFJ+7382byqb8Cwd4HsfelAHGWGx+7gOG/aw1pW5uv314SBYXlOqjtwEpGBTrHPljmVL0ClEhOJQp/fD2MMkgk/kCWsF0e6xT1V1JbuqqwEq8SB70rA+97NVv
 G8p8U5fc
 RmpM3no+9Wghn39EqhPb2BDR+0xmX+tfV7iVXwa8ZtJd2ZQgVOug51/Bt2Gp73Csht3ADBavXIof+Rd2s2N7YdGMHl0cc+J2kxR2Lv5d/2oO7cE+at5k8BUkCAbXE9SmAlVdMcexjH52rzNES6SqnYH4T88Txps2EvtJBQgzD59rWXBjZTUd0ZaD/LSrKPrLmjB9PtAcZU7LjI9s9rRmDO6Z2wMTkL8QcVIKJ/zsy8hCNMNa5Nq6x+UsplQMCVqbBJQl+4VQ4S8NBgSGPIqyQTYvHBS0plrFMN1kWbtTDCTQwEQk2zRp+fWgEd57gN6pu5lxXHjiaH2AwhX/a+zEilUdqvMzzxE8fktWPObmukW3jnOFo+de4wHwHLFaCujvPpMwY8CFHGnDeAbjbgrzGTZUa5NLgmUl9kIdT4KneZpYmOn9xRUpheMQq0AoRE5bsvbGpmub2d4yvj3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/14/26 at 09:16pm, Andrew Morton wrote:
> On Mon, 14 Sep 2026 14:31:39 +0800 Baoquan He <baoquan.he@linux.dev> wrote:
> 
> > > 
> > > >  	si = get_swap_device(swpentry);
> > > >  	if (!si)
> > > > -		return -EEXIST;
> > > > +		return -ENOENT;
> > > 
> > > mm-new has changed.  I made this
> > 
> > Thanks. Does it need a v2? or just use ther version you tuned.
> 
> I fixed it up while fixing the rejects, I hope.  Below.

Thanks. The last paragraph of patch log need be adjusted as shown at bottom.

> 
> > By the way, which mm branch is suggested to take as a base for mm
> > patches posting? I usually take mm-unstable branch, seems it's changed
> > to mm-new now?
> 
> mm-new is a front-end to mm-unstable.  The only difference is that
> mm-new isn't included in linux-next.  New material goes into mm-new and
> if it hasn't caused any disasters for a few days I'll move it into
> mm-unstable and hence linux-next.
> 
> Ordinarily there isn't much material in mm-new.  At this moment
> mm-unstable has 405 patches and mm-new has another 96.  That 96 is
> unusually large because people have been sending huge patchsets today.
> 
> So mm-new is the best target for my merging pleasure but it is surely a
> pain for ongoing development - it's changing at a great rate.  Those
> 500 patches landed in 15 days.
> 
> I suggest a reasonable process is, approximately, to develop against
> mainline (or mm-stable if there's anything in it) until you think the
> code is ready for mm.git.  Then rebase/retest against mm-new and send
> it out.  But keep an eye on what's happening in mm.git so that the
> rebasing doesn't cause nasty surprises.

It's very clear to me now, thanks a lot for the detailed explanation.

> 
> 
> 
> From: Baoquan He <hebaoquan@kylinos.cn>
> Subject: mm: zswap: return -ENOENT when the swap device is gone
> Date: Sun, 13 Sep 2026 14:30:31 +0800
> 
> zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
> device.  -EEXIST is the shrinker's "page already in swap cache" signal,
> which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
> get_swap_device() instead means the device is being swapped off, so the
> entry is simply stale.
> 
> Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
> Independent of xswap; affects all swap devices.
                ~~~~~
The term xswap sneaks into log while it's an ongoing feature. The last
paragraph should be:

===
Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
It affects all swap devices.
===

> 
> Link: https://lore.kernel.org/20260913063031.1689420-1-hebaoquan@kylinos.cn
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> ---
> 
>  mm/zswap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/zswap.c~mm-zswap-return-enoent-when-the-swap-device-is-gone
> +++ a/mm/zswap.c
> @@ -1016,7 +1016,7 @@ static int zswap_writeback_entry(struct
>  	/* try to allocate swap cache folio */
>  	si = get_swap_device(swpentry);
>  	if (IS_ERR_OR_NULL(si))
> -		return -EEXIST;
> +		return -ENOENT;
>  
>  	mpol = get_task_policy(current);
>  	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
> _
> 

