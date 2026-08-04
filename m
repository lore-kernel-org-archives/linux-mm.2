Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B4DC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173DF6B0088; Mon,  3 Aug 2026 20:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151446B0092; Mon,  3 Aug 2026 20:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0885F6B0093; Mon,  3 Aug 2026 20:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DABE26B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:48:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62EBC40798
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:48:22 +0000 (UTC)
X-FDA: 85061750844.12.5E5A6CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 46F7A80008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:48:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0ul8hbrq;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785804500;
	b=Jno9ypmpd0TAcZyNE2K6Cwtj0VvLw0VwIoDWm6kJ64ZLYS458sFZD1e7hkgyR/hCDPP1CV
	RxE775t6jteK8j6HOXqy4CKAP36O3tAeRCqI4HNVIDyOUOZyAaCZ2kdc7bgRG8tPRJzpye
	AvDZeV+sZzRXLRE1QQJb95hHXGAUtVU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0ul8hbrq;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785804500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4oN01pKxXleD62/K3oM93oB2liXo28WHpZIpaHzpd0=;
	b=2eIhSwvcLyyycJW6dQfiifeKbHcasD3yq8mF/QUn9ofHw2BpK0bbZNGtt0AHT+8SkJ7i+W
	FYYqntctge6kQSn1XGvVX7HST2y2Yy99pNqm3emcO+rGolxPD3R0aXldU1lPNw58iK7KZe
	+I4wsXecnmrbL5rZUrT7dIE7bfjV6ag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D16C60A6B;
	Tue,  4 Aug 2026 00:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855DB1F000E9;
	Tue,  4 Aug 2026 00:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785804498;
	bh=O4oN01pKxXleD62/K3oM93oB2liXo28WHpZIpaHzpd0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0ul8hbrqIKeDIJj9barxvxfqz6Ous+6nX1Dg7PAeNaYGmXf9ojrUfuE6gfaFMJMH5
	 +aQXGg4Se7W4LkDwINcyz5zhbFC3O80CX7bh3dj5Iif9qiHc/owJbYIfUKiuhSoeJ6
	 QomfVXit1dnk3Wlw0nlBKveNOnMrwoOuTyx1/Biw=
Date: Mon, 3 Aug 2026 17:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianlin Shi <shijianlin11@foxmail.com>
Cc: linux-mm@kvack.org, vbabka@kernel.org, hannes@cmpxchg.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Message-Id: <20260803174817.faeebcc4fc67a053a47548b4@linux-foundation.org>
In-Reply-To: <tencent_B9556590D4B65ACF74C06897689A6E39F206@qq.com>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
	<tencent_B9556590D4B65ACF74C06897689A6E39F206@qq.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wpgxbsat7carwuidat4a3r5uhyxe5nxb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46F7A80008
X-HE-Tag: 1785804500-884244
X-HE-Meta: U2FsdGVkX18KR239dLkkkhZSU1Uzb19+Jm9CrJpvMaQ2YhWssgTdFJ+VAvywGv2avRHtfENAZ+z4B6gSSJ5ErK8Ivq4oNqXv8sLxzXBPCJYso5QEWYEGJU+tlfrtPgjBofc4Vf/zyTG7dquVgfxvjhO7rfFifozB6EKtsUiPbg0YCT45hPzc6h549DZawcWwOwcAUuZnN2NoXXtWnOUQjenyMG/tWtYQ+DXi0OcPDgYzQJ+bnfwAf/rzNu0lIKQhRmIW/oTjCDdrYUrf31fQl1GpkgPWm9EOC+lrUe5yzfIq8wrLmNbqsuoasIJb48g1VTjDCvYJX1oJhCkn5d8oCYRZCKZDLo1OTJKz48aPdVX5cdor2znT5S2mkovufa3AryJv0BVs55RMqb1MOhl3rp/7DhuBnbSyLZ5Fx8HetAZYlWo9oMfAI/sQnZCeUycxuP+zRrSnvg4u2ZK3U90kMtG4K08lHw57WTqfWhvA0gR+C0g2U0ViXioVUWDlmfjUwsyCrReAyGkLhFZXngEO5LHiVdnJxaTbU1SA6GUXwFA6C1djZOe2a4GYXFM05qNp0V+2NiKRR4QqWVyeF4OI70iYqyr/56yIs9OFDP3K7Bx+PVS4SWobv3UdOHfevgJ1FPEVkw1eoiXwlVJNQi35MRB1LJjSq1pTIMn+cUOOJsRd4UuZcb36gX7QLbCMcF2jamVTsMU050YtFvvK3nKX6v2KstmXHjB86TQ+A/OVpYe1VmG2+DVdbFfBXVtUfq4daVgMIHgAgp1dCyfU08dX6FN1fOIdUxYBlPcwoKyviGxX0p//SbvY6UQjyCLYuq+v9JVZGI8QLj1wV5+EHnTT7pE8/3wjSZAFX/Pf7yTuIfuukzju6uUq7WTbDZtRWxZ2+lB5w9jsd9vf1jx667VJHSLne6gQx0NP8zDOHFiGTTCLaHj5ZOpD1beDX0fA6aqs9aqXcS4fqM+/mSQoPTH
 yU0qPEzj
 SrI71HA7tMcXr+LUZpNGhNA13Ofz7XkYFF/pENIEC3nG8ZhEN/SpOnl00qhmKGQQ+P93PJL0fPeLFy9a5CBbUm20hGcUY9Qf5h8m+gJjaKz4XgzXUTXjZ7FuNnxfA1sZ287L6yELp06O+r9u5XYPGL9eBHr8dMLqEDmgEMTO8q+MoG4g9XZK5156udz1drVMARX1u3zMph47sKQFN6LmSSY3YgpXsMlmJhgZO0hy33IJXtydHWTqrFzmWM62Kjdz03yFMc37EIAeswrNSLNxC20dkUxFFZR9Li5S8+HR7QgqkRSqAwQa9Q+LSeFBnSbNUPvq+sTdeCkeomT3mpc34/tqu3tvqeM+JlQC4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  2 Aug 2026 22:57:07 +0800 Jianlin Shi <shijianlin11@foxmail.com> wrote:

> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
> even for read operations.
> 
> Fix three issues:
> 
> 1. Propagate errors from proc_dointvec_minmax() instead of always
>    returning success.  For example, writing non-integer garbage to the
>    sysctl now returns an error instead of silently succeeding with
>    unchanged values.
> 
> 2. Only call setup_per_zone_lowmem_reserve() when the sysctl is
>    actually written, matching the write-only refresh pattern of
>    min_free_kbytes and watermark_scale_factor handlers.
> 
> 3. On write, parse into a temporary ratio[] array and only copy into
>    sysctl_lowmem_reserve_ratio[] and refresh derived state after the
>    full vector is validated.  This avoids leaving the ratio array
>    partially updated while skipping setup when proc_dointvec_minmax()
>    returns an error on a later element (suggested by Andrew Morton).
> 
> Drop the manual "< 1 -> 0" sanitization loop and set .extra1 =
> SYSCTL_ZERO on the ctl_table entry so proc_dointvec_minmax() enforces
> the minimum on write; negative values now return -EINVAL instead of
> being silently coerced to 0 (suggested by Vlastimil Babka).
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6673,8 +6673,8 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
>  
>  /*
>   * lowmem_reserve_ratio_sysctl_handler - just a wrapper around
> - *	proc_dointvec() so that we can call setup_per_zone_lowmem_reserve()
> - *	whenever sysctl_lowmem_reserve_ratio changes.
> + *	proc_dointvec_minmax() so that we can call
> + *	setup_per_zone_lowmem_reserve() when the sysctl is written.
>   *
>   * The reserve ratio obviously has absolutely no relation with the
>   * minimum watermarks. The lowmem reserve ratio can only make sense
> @@ -6683,16 +6683,23 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
>  static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
>  		int write, void *buffer, size_t *length, loff_t *ppos)
>  {
> -	int i;
> +	struct ctl_table tmp = *table;
> +	int ratio[MAX_NR_ZONES];
> +	int rc;
>  
> -	proc_dointvec_minmax(table, write, buffer, length, ppos);
> +	if (!write)
> +		return proc_dointvec_minmax(table, write, buffer, length, ppos);
>  
> -	for (i = 0; i < MAX_NR_ZONES; i++) {
> -		if (sysctl_lowmem_reserve_ratio[i] < 1)
> -			sysctl_lowmem_reserve_ratio[i] = 0;
> -	}
> +	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
> +	tmp.data = ratio;
>  
> +	rc = proc_dointvec_minmax(&tmp, write, buffer, length, ppos);
> +	if (rc)
> +		return rc;
> +
> +	memcpy(sysctl_lowmem_reserve_ratio, ratio, sizeof(ratio));
>  	setup_per_zone_lowmem_reserve();
> +
>  	return 0;
>  }
>  
> @@ -6791,6 +6798,7 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
>  		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
>  		.mode		= 0644,
>  		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
> +		.extra1		= SYSCTL_ZERO,
>  	},
>  #ifdef CONFIG_NUMA

lgtm, thanks.

I find this a little tidier:

--- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
+++ a/mm/page_alloc.c
@@ -6926,7 +6926,7 @@ static int lowmem_reserve_ratio_sysctl_h
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
 	struct ctl_table tmp = *table;
-	int ratio[MAX_NR_ZONES];
+	int ratio[ARRAY_SIZE(sysctl_lowmem_reserve_ratio)];
 	int rc;
 
 	if (!write)

A bit more self-documenting and future-proof.  What do you think?

