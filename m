Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05237FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6096B008A; Wed, 29 Apr 2026 08:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F926B008C; Wed, 29 Apr 2026 08:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D576B0092; Wed, 29 Apr 2026 08:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFEC86B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:26:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 640BC88E7D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:26:12 +0000 (UTC)
X-FDA: 84711515784.23.F54ADB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 976D5180007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:26:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="X+H1I/qj";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777465570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugiIID9hUUulZs9g+1Af5VB92t9ln4vandehR4h7luI=;
	b=l+wOSzwS/1w+OVKifqM78+ZxEo1CaGbVRjlQdi9MW74yhTdIKlQE/BECRUYy/03suSUjct
	UNc64zW/8Osa0zE6L7JjUYUUyFQewDkEe/ZW3L4MSztEF8UPMeadeRaVaqF16SxvfvID1Y
	kegxyp3qsXNxhnEV6wRPkUHWv0UniIM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="X+H1I/qj";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777465570; a=rsa-sha256;
	cv=none;
	b=FJ0hxSbMlFG6DuQ7NeY/Bb16Y6YzoTsRYm+axYdTcJRP9FBorxSvItlz0o+slK5zCzxlSS
	hsnW0R5VFV20thV7z6sF9gmUOXeLPXPL4eE1zMpkXsuQ1o42gIYyLWACf8C+NVh6/VBfR2
	XUnujiNJ9J092f6+fKhLAwhUfiLhEyU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96B4A40633;
	Wed, 29 Apr 2026 12:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A87C19425;
	Wed, 29 Apr 2026 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777465569;
	bh=XZdLG7NrTLr1gkaO2uQpheM8UanKy4xE7H3oI6Nz0L4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=X+H1I/qj8goOLZtdjEVIxjRbAfxP0QCXilX+8kzOu/cnPJPFV/my/xCymwQHxhXlJ
	 CkDLkdcssxPd70q/xWhX+8Vl9ijCfqVav6swEqy72PMZ6WcuEKd0f0qT63TDr7cZdC
	 Yk74rfl80yWYBRWsPAfvA4ZBW2T+/caQmH8gE1Bg=
Date: Wed, 29 Apr 2026 05:26:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: hoist pstatc_pcpu assignment out of CPU
 loop
Message-Id: <20260429052608.b4787b75f11889919ff631ad@linux-foundation.org>
In-Reply-To: <20260429084216.186238-1-hui.zhu@linux.dev>
References: <20260429084216.186238-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 976D5180007
X-Stat-Signature: b4t3yjk4jn6ws7k7rz7a5ju9xxp388tx
X-HE-Tag: 1777465570-90451
X-HE-Meta: U2FsdGVkX1+n/IXdd8xGvoSlCm23ziCrUSDFy1qBumSKtdgWpBvsJBwrAkJwwApCsBxwGkGEunW5b5t4ATWnplxiC1q/rgs5D2D4GJpN+JkIEYngrLwzpPA2YwLJLJsVTxi8Aqdv5YrsX/wElAIgTlGDBDtDqeNK36AEWoXm1qrDT4r6p6ThEQgH3IWv+ev0KFIzAB6nloS+a5aMQyjpkqh1YBDmaoNywOxWLJKALd9/reBlfvipoKDtvXyLe9yL3kkBxfZOYOOlrrKZJom0UoeLAp3ykUpubAaqg264z69sdrIaRrBdD2lw4m16velyrteJzIKJLDjriQKFlPZ7wfkU1trpvkL2HvcDTW1h+4JwsCxXP+YxQ+45MNpX30wc6G5FmEJ53+FUAFcvON4VwME0PDWCxrCJ5DkMayfQ51kp9GyPR7kjiHXANPCXlyoBKftZkEGruOv0yJ0siVXEB/Mv1P6/7dwag4ay3tSPH5ZaxEz7nGwnqThDN2IHPJlcwZ7WXfMGmLk8xgA5DJ0q62aZUtJucLha2CZRmcQ/nJSlJv16z99VJHwGvyHeuxzwMuOcML2uXe7anWCi2dUUcrNc3RSeYA9Rr1dMnIDe8BgivEy8srGnAGUf3wp0NUwpXzp5c/CrWT5qbnHSjUsmQR2EetCbgyTHi1+vzX+BDUD1t/4qdnMwzeYmXx8HgTEx48wKt1VD7we/0AWX0AXlUjzoTN/6rtGkchPwXXZTbxcr9ZPHBFQKDARwJd7+OvmsYOkdM7JFv0kRWt5Gkg5elK7Rw76OW81Vnt3RbCFSW2hCXBwLY4Fu8uDrvS6aU//a8yaF7bO3Ow2AHdSL9shp86wgQIKrIngcwhjiHnPDtQKRu8j2F9W385kFg6m0qLaqPZNB9bE4Bf70WdyVoS+lN98KgJ1Nq7dctMqgYlakBaZnEcGPngRGBYLBt8GaYPFxzlLuU4a9oIll1Fr5hdO
 gHF7fKI5
 L/NW0EebDdqu84wMUS6YBOLZtAZOGnTid0A9VSGvMc9CT7wANie6oeFl2NqlEXqVHijhbbMKW1WNWGMlfGVoEsKliUUjP+i74VKshHCDOOvVKcVMDiAHQLYofpCPlz3QzOrMUvPmnIG6K5wiuA7fr3jAFIw15GwlrI/hGMSsBv/gCqxNNQJd31FTeJhFQOSlxCxhpuUBAntNxHC1N6axw99v4i+6s6VAPYhr6du/wcioscKK+d5jIVFBZy8GfOc2mxPSaoU3oH0Fd2/evBd9Fe/6wXksCu6UeJFbkJ0uBA5kmBXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 16:42:16 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> In mem_cgroup_alloc(), the assignment of pstatc_pcpu is invariant
> with respect to the for_each_possible_cpu() loop: both the 'parent'
> pointer and 'parent->vmstats_percpu' remain constant throughout all
> iterations.
> 
> The original code redundantly re-evaluated the 'if (parent)'
> condition and reassigned pstatc_pcpu on every CPU iteration, then
> repeated the same ternary check 'parent ? pstatc_pcpu : NULL' when
> storing into statc->parent_pcpu.
> 
> Move the single conditional assignment of pstatc_pcpu to before the
> loop, resolving both the loop-invariant placement issue and the
> duplicated null check. On systems with a large number of possible
> CPUs, this eliminates repeated branch evaluation with no functional
> change.
> 
> No functional change intended.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3993,11 +3993,10 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>  	if (!memcg1_alloc_events(memcg))
>  		goto fail;
>  
> +	pstatc_pcpu = parent ? parent->vmstats_percpu : NULL;
>  	for_each_possible_cpu(cpu) {
> -		if (parent)
> -			pstatc_pcpu = parent->vmstats_percpu;
>  		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
> -		statc->parent_pcpu = parent ? pstatc_pcpu : NULL;
> +		statc->parent_pcpu = pstatc_pcpu;
>  		statc->vmstats = memcg->vmstats;
>  	}

lgtm.

I expected this to make no change to generated code but it actually
reduces memcontrol.o text by nearly 300 bytes (x86_64 allmodconfig).

