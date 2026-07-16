Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A10C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63ED56B00D4; Thu, 16 Jul 2026 11:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C86F6B00E0; Thu, 16 Jul 2026 11:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505FB6B0145; Thu, 16 Jul 2026 11:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 210546B00D4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:54:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B30BC0139
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:24:58 +0000 (UTC)
X-FDA: 84994710276.01.043B572
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0033E20009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:24:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VjcQz7HV;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784208297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a91UqFOrJkNtKkfZIBS7Wu0Dr1ZR+NGPxSwxh4ZZj9w=;
	b=Gfr+YtUtTLQr8x6E7vZoVmW/O92mYzjrXCvc6LoP/ucEJhx65NalGXHR7OT7kvZyjyOYgN
	BqLrcOH2MlBMWyarn4MVxKKeA5rv23UHzFbtQ5Tkt+MC92K1CuZhifWZeyser/gEBHbQK6
	Y26obvh4osg3cuCvi3Xygv3DmDalUiw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VjcQz7HV;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784208297;
	b=cfFmAmg0gTxvMGWarhI5Q5MCRmm2QbhBmuV+/ZwybjCYW6r2Xz/XAp4E8ZvC2T8P8JJGBP
	TYls9V8CxTep7FHYDdCx8CrWv73S4kXvwY/0c9Cni6xQ1MkGBO1HPV390Ige+55aRJ4YqK
	jhUnAb/oVURdvSHZ78UUYWnhTWIfDIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6678860054;
	Thu, 16 Jul 2026 13:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3191F000E9;
	Thu, 16 Jul 2026 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784208296;
	bh=a91UqFOrJkNtKkfZIBS7Wu0Dr1ZR+NGPxSwxh4ZZj9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VjcQz7HVRDr2rTsmFnvhua47DsM5+SJx6W9ZZ9NdzxwyOo8IIUTPezCEnhhaqEgiz
	 SL5xHr3Y71AMfFgGCupo0Mlq6OIdJiR5d+acbKQoTd0c7nxQMKKfEt/W5x+eh510zI
	 Yy0BsLlCNcCztJ9NMOOftnqjtpK2DXXebW9kaS1fMvGnIfRfIPwn5hldoCVuiUX1Wc
	 z5FQUC+skSeKdsxqfU6bYe/ApHrdR0HrA7nm8sv7Im6s0AX+uI5dYQPHct2ZtFHKFz
	 QkExgSNyk/I5ZZoFi+E7kqS4W/uMaV91g/E/q2LMv5qNu4Fmg6cWSkXcoQB2XXci5x
	 sGfNTE6Oe1JfQ==
Date: Thu, 16 Jul 2026 14:24:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: deepakroag <gaikwad.dcg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] feat: scale vmpressure window with machine size
Message-ID: <aljYxLusTzZkTfnH@lucifer>
References: <20260716115734.80909-1-gaikwad.dcg@gmail.com>
 <20260716115734.80909-2-gaikwad.dcg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716115734.80909-2-gaikwad.dcg@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0033E20009
X-Stat-Signature: yhmohy847hef4ymmemohjz11hqo9kmdr
X-HE-Tag: 1784208296-909148
X-HE-Meta: U2FsdGVkX1+MdxWJJpjJFpZN1DD+5D9QfFZYiEV/CwBYBKgsxpfUnkF61M+EXrrCaczDNceSIMH2N6QByqfc7KCXioFYgD7dS2JGfoLVymDWybFM8bnvqEjblgjgs89mAMwJKKlQd9HXcQcGkNLPFhBH8fssVYBLkA0J7IaNY4rfapoclk/kwGZQ+dgH4uXut0zlZCwGG/KeEXfbwKc5Irsh6G+AI+x4EaP8m/DwPjKBALZMIicjb5HRgDjGYb1mDkSS5pmyXdj/pcsXSke2s7O3Xs99F7uEUd1UW/5W9DM4lC1yTBNdC86dSRaTigFyib/yfd2DuqwFrxojI4VCyNXLhD34w1E5ZGkaG51TzRKIhb/bqc7WwOaV1CKy46JdsyMZ0TnxYg0NGZSnfJSy3V/jsJZW/U3FpW+jzArYPSqehkyq4TlyHZs6YRoYIcgiymuf5dR12DRKqRVMgXX+SyO4V6u+dUjb8caPfgv6CBwBGFiS9goRWDZF+SGbw2C5o2Mec9H7rTn0KtUvvGK+Nodu/HchGTdY6LnYj1vgd3Iy5H5zIGcXW3ggqx/DU8qzMfoCNnsWEdnRnYAdLT+D52dBflLHyjzJLAxMU3eS0iikbpoLb3vw3+tGyM0jTSU6RXQX/jvzwMj8LXzHmeLX88GKlYLO+1wN3oz5K+EEJoEYBTu8P9ylyclIC7/d87dwW7BUCPu17pSEwkkFcmtjMVdsgEnnZRCodfYyHSxt+lFwl/8vGar+uLeQXa9girxVbi5AZxmXwbWwKWjFv0CEuQbSY8ktZ496pOTiY/F2TVAvVDFjsVIU3Jkb9j4/Wf4q4YldjTH2WxRcISkgoMJHf8qLM+yujzGBnQ5Ou8ypk8LSL5zomMm6fsSXaFV+Xfc0pA5a/cddDSIhwYkAdow+jxiP+IXX1tloZvj1bUdbxAupMOpDe+MuGhKlLnPBsVlpSBQKbMZA3WXvK7SOBjA
 d9t3iZqW
 iXblxAp8maR0I/sT5XX6mfYsT2GXXTSK7lbSNH9hL2HO2PbMuqFDvOjyH8Zh6ZGHRtDCey+XuEjuY0pd986Mm9YB+L/Xmw8iJhBQuOX8LGmOsSMt49tx2yhmakMG+2ceHmRLREg7x/X8tP7ZHZcNrj8ZaHibK/nqK4ThYpEKrFR4xaozbTlA4ubtUjxFFiGb6TrVSNvNzscr3C2nbe7x8vGrmJOUaxJqYw7rx6qqfNRleT80DM9HRUxpBI5mMm3kG2QvTWfIEj+6B/UajxHfWsKyNow7uRkv1erXCqJBk3vtrRfI76o1y/Qr5BggagMyGc5axMl57x/ApAjafP1LMg9uYHwOFo8B5Ff7IVvorseURx/tBMn/Ww7eb/r+oZtREFsRJN7nrnsa9CWPYaZ0hRNQIc9HcaamII30es17maFIpaKkFUf9ohc5YEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

I'm not sure what you're doing here but this looks suspiciously like you're
taking somebody else's (previously rejected) work and putting your name to it?

And you're sending a v2 without having sent a v1? What?

You're also getting basic process wrong here. We don't prefix with 'feat'. You
only cc'd key people on 1/3 patches.

There doesn't appear to be a cover letter. You are sending random vmalloc
changes along with this too?

On Thu, Jul 16, 2026 at 05:27:30PM +0530, deepakroag wrote:
> Replace the fixed 512-page vmpressure window with a boot-time value
> derived from total memory and CPU count, clamped between 128 and 2048 pages.

So you're just making stuff up here? Clamp between 128 and 2048 because why not
I guess? And no mention about the rest of the logic?

>
> Signed-off-by: deepakroag <gaikwad.dcg@gmail.com>
> ---

There was already a patch for this in [0] which looks suspiciously close to what
you're doing here (modulo clamping without using a clamp macro),
unacknowledged.

I hope you understand plagiarism is completely unacceptable?

In any case it was rejected then for various reasons, you re-sending the same
idea without crediting that changes nothing.

Cheers, Lorenzo

[0]:https://lore.kernel.org/all/20260227221555.29969-1-mcq@disroot.org/

>  mm/vmpressure.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index f053554e5..8925d4ad3 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -33,9 +33,29 @@
>   * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
>   *
>   * TODO: Make the window size depend on machine size, as we do for vmstat
> - * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
> + * thresholds. Scales with CPU count and total memory at boot.
>   */
> -static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
> +static unsigned long vmpressure_win;
> +
> +static unsigned long __init vmpressure_window_size(void)
> +{
> +	unsigned long win;
> +	int mem;
> +
> +	mem = totalram_pages() >> (27 - PAGE_SHIFT);
> +	win = SWAP_CLUSTER_MAX * (unsigned long)fls(num_online_cpus()) *
> +	      (1 + fls(mem));
> +	win = max(win, SWAP_CLUSTER_MAX * 4UL);
> +	win = min(win, SWAP_CLUSTER_MAX * 64UL);
> +	return win;
> +}
> +
> +static int __init vmpressure_win_init(void)
> +{
> +	vmpressure_win = vmpressure_window_size();
> +	return 0;
> +}
> +core_initcall(vmpressure_win_init);
>
>  /*
>   * These thresholds are used when we account memory pressure through
> --
> Deepak Rao Gaikwad
>

