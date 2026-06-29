Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC74C43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AF596B0110; Mon, 29 Jun 2026 12:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287126B0119; Mon, 29 Jun 2026 12:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177206B012D; Mon, 29 Jun 2026 12:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E83FC6B0110
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:46:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 870461401FE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:46:53 +0000 (UTC)
X-FDA: 84933529506.17.182DDC1
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5459A180018
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:46:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=mcfsGcaZ;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751611;
	b=VmeTex4XBAw/WTf6XSGxAooN+Ihvt+de+z9BxpKwg+qR2ZJ+94thv8vwM4xvRvefqoJd+M
	caDm++aPhXIw+6WWktwRCdZ3PtDh8RMHc1nkmC1/pDooNs5rEZe3DXtrSk6tAUezMhrIpC
	cruKDQM2Aub/04aBLUIpUvBjRvZ2pq0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLTKwJp3RBteUfuxO7WvjdZmuJysuHNgbxLJdR4kETU=;
	b=z2pdmJkGuKNoXwIVWBFzHb0LGHI204gjglOYWqSLPMjxgpZELJG07oMuzeDoSfUTbCligZ
	Wkj+Gq/oZX2wn0zJR7+pfw2PfolCuCrH9b8oQBK+bBdAJWm1dbnu0tnwwzixhfG/H3Rx2J
	8bZdK+/9sgp8FEv2CUctX1k1rmCUVyE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=mcfsGcaZ;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8efcef23d21so15738816d6.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782751610; x=1783356410; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QLTKwJp3RBteUfuxO7WvjdZmuJysuHNgbxLJdR4kETU=;
        b=mcfsGcaZmLg+vg7PkYZ/746CEo8IZKZhjiIOfAbm01mGRjT3p7818CD0gdi5Pn74lI
         sZ5zpVrq7MTH93159rMIZKJjEUHtfrlXZWSW+ifiS61aGwct9fruP2UgVXBgJAUK6y+8
         dIhZbibBklz77sJ4Ozf0BlJKnjj90GoEreqmgdP6F3QoeQd2S7va3CdjmsrSav8spwrS
         aQ4VeFdKrhA+XM+lK73CFS7AmAVGxYHocl2pPJ7+ZVO2/5amh1mOLvdyIzsivmotLoLA
         ntW//AnX6Xc+96RsYtSQq59ud/tVkYBb9J0uxEiGPqKjThdUZO/Dw4w6Umc/NWK9si0L
         q6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751610; x=1783356410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLTKwJp3RBteUfuxO7WvjdZmuJysuHNgbxLJdR4kETU=;
        b=gDPuJ7Bsaicbd0Jh4dXz8CMbvofv70sdQ67CrVRom3hsSmoFRobMjvFKgW+/S2Ib/l
         FW+VC5563kAi5/y9n9T1f4/IC3Y4z9PvBzDaVLrWtjY4VMF0q5tekpFqvx2KcJc6vbds
         l4sBDUebcF69YkbeAHFJTXktZG+F8jd7wsSY+Yf2e0shG2fGXXg8WHuu5gdXkLPNd09X
         LuC9svyXIouo7tkHt4v22pKSgcmqpwZdB1kFJPeQNmAjKXtbXmyTi8rYvyh6zyo1HMCp
         WowfSyf+7k0BYwT6EbLZD54Wd9e/jwWgKsqK1zOOeIHinEvIrsl9Q8EQWKQUECZ4fa6u
         LOYQ==
X-Forwarded-Encrypted: i=1; AHgh+RotwrWnZjHc7ntm0YGdeZ5nyTKBcvomKC8hu5rxKkA8uqoXSj7Au9nEDO4nFXz2tsxYA9koFGXBxw==@kvack.org
X-Gm-Message-State: AOJu0YxWqDVrNzXBF25u9+NeLlWY41PWahkAmyENA8qXv2nRViq9uHP0
	mfGa9UwHLjdcnLrB1ZVImLhCJSq1xQYdQwqHa49de4LYiS5Z1TYviC16TZnvZurhVbg=
X-Gm-Gg: AfdE7cm7jbNmbyMqiw+xz9zlRSZ0fQLvXPX27jLK2Gn84V95/z57gMKxbzpx+n4AuEm
	Wh/7U4KEbn434bwbEsM+5UfnCyBa3rU2tmqwItKrXQ+WxmjmEpyXKf5hWO3J+/Sv+TYfNqfdkWe
	ZzR9/OABMDE6c1AQxLMYShcYa+qD5SnITobyA7XfLRa6g2HpnDgryc6jBdQ3TFdKWzVx5cxm4M7
	Dp4A16UMrSGHfU8Qd/THtYZSvETE+c7rly5ILev6WSDKyx+ENtTIjDACrRdZrGzDHy1uwPE55CC
	3YsnqnrMVKDu0GXbVd7wL68bzJQr3D4RRwkVwygMfYbJxEeDJunuDPveyxK1I0zrGCsDLW8bzNf
	UyZlbwTGVxdtdx8Tc5f2vCar+SGRS5PzvdKDJxnq7aFRNe7h+wj/QpwGexARW2kuSNGHEBQd1dp
	yr7gHRnJ23b8qBMEiGMacHtg==
X-Received: by 2002:a05:6214:2f0c:b0:8ea:fb8c:2e0a with SMTP id 6a1803df08f44-8f1bb32d8camr916936d6.28.1782751610148;
        Mon, 29 Jun 2026 09:46:50 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a3580949sm2835136d6.21.2026.06.29.09.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:46:49 -0700 (PDT)
Date: Mon, 29 Jun 2026 12:46:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com,
	shakeel.butt@linux.dev, roman.gushchin@linux.dev,
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
	mhocko@suse.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/vmpressure: skip tree=true accounting on
 cgroup v2
Message-ID: <akKhdeU-TXioe6mB@cmpxchg.org>
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629130042.2649505-2-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5459A180018
X-Stat-Signature: b98qqow4bm4ky5jd89f7f6e5qkuuatzf
X-HE-Tag: 1782751611-733026
X-HE-Meta: U2FsdGVkX1/E3fk4AYh6z1eM5xzrYQZ14NSl3cxDVAfZoKrRkQ6uE9MhorE6CFgYZeo+HJEocYibIhvePSw4qxyhLXklzK62dA8Le0Bc4NhravqbnCBwCAV+pOQuxcYtGjvPybvPOEsefC0bEGiCZbcOj2mhccQVgi0e2oaDrOdN68I4QXpp6QBYJKVG1jH3WzPi97Us5cjPI9L1pBxCIeleewIfBDBNq5vx8AUr466aIoDQSBCiw71sGEKdKvPueuheILzAPerFQb5KwQRkX8cKZjtAH+gtpP4APODCrtPJbV42MiSlT4vZyzQGfhri+hqjhOcavymgdefSuy2e0UmtZ7DFSDrmHWK8drv6IXX2QDZab2RFyBulMjNN6y0vR+5Ya/MZYHKe7x8z7gBXaWxX33fRKzh7Bo68NdRogl8o20sSzv6aLLiKnxE/nBpw4yQdPrk5DtHVCglf014dvr8PqXzK7T/jn6KjYh7sviGyu2AE6cMrlTEY/RksVBqaTqa9/hoS6Yu/0iebjhzQjPu2Lxl775ePSnf+7+ltqeStLNq3fVF9bHkGYJ3p07A5yhv3CaBtoRqQ+hzK32aUkWioGyuz+4q7qjuHOspZEwJ19OTUJAhKsgkhj5Kf+nKEiqQkkW/MhU8p5cLz2rJTB2g9VEj1RkbDFaUXIfDleM7St/Y3dzzgbo5Jh1xwOyKcuwbaUeCnDlPmI1kyZxN1YlcBH398NLvLGBQ39RBUO9ynJd7szj7W/dkHZhgh60Rvnsa/GBMmie31P9JGzTmgScw+d5mLCJWP0w2KI/v/nCIPBK98pbU7iNFVWdh0yWoxOMsM8qy7P59aLjeyh9licJ62bdH1d9S2gGak/nYW3gaWOvSUDB5mkRLPFWRf3/2f1pvn3uCTkUw63tZmnebOeT6whN43R6hVseDXhfPYljrNeua8fLJzmcletFExZrw+SKGANe37j6PcYFK4kUj
 +owDIz+3
 ssbLcQGzxMdMs7QJ/oduhLvloEA3pkvf4sjIRcKVsng+yzGgS47nNPwC5UD1QXvxi0vwhmq+mAIyxePusMEnCitK/QD1uCJsYN2CeWe9yiJV9DplJwhdV7HNp8yU0vKhhsT9JhxhDcJLEbw+g21BYC8lK5KhrJrVKXyt9LAFXjAdLop88Mh97VAZ+EvuxgXRkTihqPVul6Wgd2ZX55iV77yMCBEhw257n0ieWllP8+vmde/iNllmcks3x3v6H+wsDfoKOhOnLohyMKCXe1okJAamcdbJj41pGSnOn8FqmaJVSEPTz7F6QwWfb1HGfCy5BwmUuIL5zuBE0vRXJ+WejckUKpHoCIoqNEYOrExfq57UIw+GcIWD1/9nd+bUXeX9PGYBfL5mTN/I9CTIhMoDDp18yb4fpnaEuo0X6mLZU7XHqocg5Rn8kj3oeCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 05:59:36AM -0700, Usama Arif wrote:
> vmpressure() has two outputs gated by the @tree argument:
> 
>   @tree=false drives in-kernel socket pressure (mem_cgroup_set_
>               socket_pressure), consumed by TCP/SCTP. This only
>               applies on cgroup v2; on v1 socket memory is charged
>               separately via tcpmem and the consumer reads
>               memcg->tcpmem_pressure instead.
> 
>   @tree=true  drives userspace eventfd notifications via the v1
>               memory.pressure_level / cgroup.event_control interface.
>               v2 has no equivalent: userspace gets reclaim signals
>               through memory.pressure (PSI), which does not touch
>               vmpressure.
> 
> The existing early return covered v1 + @tree=false. The symmetric
> v2 + @tree=true case was falling through and doing the full lock /
> accumulate / schedule_work / parent-walk dance for an events list
> that can never be populated. bpftrace on a 176-core production host
> (cgroup v2, CONFIG_MEMCG_V1=n, 285 memcgs, sustained reclaim) showed
> ~16,200 @tree=true vmpressure() calls per minute. Add an early return
> that skips cgroup v2 + tree = true which avoids us doing all this work.
> On a v2-only host this also eliminates a lock contention path that can
> serialise reclaimers on a single global sr_lock.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
>  mm/vmpressure.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index f053554e5826..c82cee1ab43b 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -246,11 +246,13 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
>  		return;
>  
>  	/*
> -	 * The in-kernel users only care about the reclaim efficiency
> -	 * for this @memcg rather than the whole subtree, and there
> -	 * isn't and won't be any in-kernel user in a legacy cgroup.
> +	 * Only two combinations have a consumer:
> +	 *   cgroup v2 + tree=false -> in-kernel socket pressure
> +	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
> +	 * Skip the other two: nothing consumes the result.
>  	 */
> -	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree)
> +	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
> +	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
>  		return;

	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) == tree)
		return;

