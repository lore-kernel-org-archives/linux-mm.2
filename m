Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A740CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 23:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236136B0096; Sat,  3 Oct 2026 19:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7686B0098; Sat,  3 Oct 2026 19:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE886B0099; Sat,  3 Oct 2026 19:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCBE06B0096
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 19:13:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64996A0A48
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:30 +0000 (UTC)
X-FDA: 85282868580.23.7DAF5CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id CCB2220005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aSkUnWZ1;
	spf=pass (imf31.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791069208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmC3HEgkDX9MlcGsgiuH35IWs/E9FDG/g8OR9C7T9KA=;
	b=c4ZwgaHiKxk3uyBc/VjZglut6aICyc0F7NWhRQNjndF/Dldn3dsFtI+iiyY6NjdSWSgYdE
	2OrU8jkEOwvfZkhBRzE6S3cANbW+uv1mNP04ygPWf+BTzVLBUQPJzD3k+GT8zQCzuoeoNs
	hPcQJqVhIJhXF2ZPhB76BgQIo27A22U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791069208;
	b=M721YUluEt958zfCYenDnFUb71MutM5ZhNXFNSXFfEhGFMGobj9oxFSdCc1rOnrdiCTybY
	AOaJt65MuXXfmzPfDJHzAMJPZtd44sh7K1laf+L+N3XlepQi3YEKGDMG6v3Jb1HOXKt12R
	TVW01oGcRngRkVrZV0fewtwgY8yMogg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aSkUnWZ1;
	spf=pass (imf31.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6965B60052;
	Sat,  3 Oct 2026 23:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D24F1F0089C;
	Sat,  3 Oct 2026 23:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069208;
	bh=MmC3HEgkDX9MlcGsgiuH35IWs/E9FDG/g8OR9C7T9KA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aSkUnWZ1SNAbpwLsB3KU5uD7pViDv+bcq49TV6pIyPiLmShD03VIblVl9lx44Y1Kz
	 TUaKFJMhqCQ9mF+4//XPjxe//UmrlXVRJDbvu1UZyaxQk9HpoB64cdM/3dHj+F+Pak
	 Igbw2AzRYzdGg+9bnkzaEZtNLWRBhRyCo+cnrkGAdnn22cE5dGLUwaaRr4Gliz7b4R
	 Bu0m9tqvCl06mTKVdEgZu3ayBWZRW/9gK/L/dLb0Vof+YltrBSuheo3oBO0etQ2Lep
	 NDSdqd/UTcJ4w/qz0IyCU2Y/qHss7Teu5kcW+TiduXXDrVjxgkqTiSPmkCtVO9TNsl
	 XXEYTNpj1ZCAg==
Subject: Re: [PATCH net-next v5 7/7] net: skb: isolate skb data area
 allocations into a separate bucket
From: netdev-bot+sashiko@kernel.org
To: kees@kernel.org
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org,
 hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, pfalcato@suse.de,
 kuniyu@google.com, linux-hardening@vger.kernel.org, davem@davemloft.net,
 hannes@cmpxchg.org, mhocko@kernel.org, shakeel.butt@linux.dev,
 muchun.song@linux.dev, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, kerneljasonxing@gmail.com,
 willemb@google.com, almasrymina@google.com, bjorn@kernel.org,
 jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 netdev@vger.kernel.org
Date: Sat, 03 Oct 2026 23:13:26 +0000
Message-ID: <179106920612.434549.10910954892692956019@kernel.org>
In-Reply-To: <20261002231132.1646573-7-kees@kernel.org>
References: <20261002231132.1646573-7-kees@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CCB2220005
X-Stat-Signature: ttbf45ayghzmnj55np9zgfope9fybhfy
X-HE-Tag: 1791069208-636290
X-HE-Meta: U2FsdGVkX1+BcxkQ29cSayzeacyL2dA0jo7OvqIpLHGqTUt+NRDTgKhmO1WViMrhgxeKNHGuK1wmgDA1ux1RVJ7BQiP5PZ4P0Mtl3kgSOdf90HRfNjLlvl5MA1B+WG+0PzHPX1HDS2AhtkZuNeJrV+hhxDxM/MxCYByqEDhEkFNtiQDNBsatblDCnnyfWTjStsS6W84jPpuVMPk089EwOVbsL3fcZ/LuHij8LuJBBB/k+lMmjWwrkwZb21WXR8a6HTPT7v881n9UZDSirMCtklJiPqJ0q0T+s/sv3hm6bV8mrgew22t0b5Vxej/1hpZR9pZ8pHnkHFSZ/y5FmUV63NsJ8c/GO3sgCg/CopwTrEvrQ0OnHxwvtWKK1SUHt684KdbIvjwi4uW2i7XwG2pgzjsk3XQnKINJU/0P6jZeI0Mi/IKIAecdB2DFLXawGabzJth8RAdykludxmv6TrL1rLwQ2m3Uw8ZtPcGo5rlxIUA4JeApfmGZ4ac23uAWj8XDOwQAuBAr2kMjyRT98d9AbfypXiwHbv1c+uE9teke9UmxlMzCNpuJgWjWMZCFi6RrW9zOzcPO4MN/Vi/ArLgieT4nb2zgHDrrUlQI2Ssgt+krTHXk2lDDbeKWdyzDXA5CcG5Dyc8d3ODwexSjJ3MCmG70YUEhDh+gludhTbGwPyepn2SBrpiGTFN65eMwbHByK+iOOltFGfV7ckm0FKdP4WyVQlRbicBgGFn4N4vQZSMp0WKawOd71Uw/oFJLvVtZHNm3h4MNU9p5AZyBiNgAYp6/SGjr96FaEWkGI/hII5n8+gF9ee6wUYBkzgo6SUGt6mey27vwF9z+vJe7o5OkOUxuFHB7lN9ULrFawHfWMcDu9DTPY+ZKxLAhMs8soXp9UtO49OcthisYtwunlLW8u4wiKvGrH5XodisEfEXnx2XeIWxY+a88AUSiNp5QdaEr0JX/Mte5qrxrfGMXmMu
 omZ7R8OT
 uHSstBCT2LB4qQIVgQH3tb0ChkEvApzOCsvdf26mV9+SBKVm8aozOn9/Bo7jSipJy6VHZ/zZNjsZz1WJ/w0Y/Ot4aLu/dRxEQPhhQuqBxOVEyWDrmSJPv8y51rgHVv27S/LVnoYOoGcojqyvIyrFR1dvgHdy9mKGvxrQjOfIBc8kL+Oiw4+uZcHftL3EhzCqXqeTYusB/hUsDJT5602ym6XHDL9xLGqhD8FPuqrJbr5GcOSCqpMy18KWcIQNz/9wTKMA0lBM7eWKn2Sd1oo9/duLY6fpQEv+RDlKT+8h0/TV2POt7TlkXbtLyYWgJJfZq+FOBZd0tZHbYHVN8Ld9pvouoc9T9zz9w6u7VZyHpSfYApHQatJptu7JF+y1LtJjgePbeQkmBRuKINoEKaCZ4fBAtrhmbYdqz3BQnlvrhVT/NJ7pp56QveY9al795FRIhZO7q4tQ0rx21qEPdtPXgqaQcpez7Z7cgSKE30wTJy3f/n+Vgo+BM4K6X2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The block comment above kmalloc_reserve() in net/core/skbuff.c
  (line 603) still says "kmalloc_reserve is a wrapper around…

--

net: skb: isolate skb data area allocations into a separate bucket

This patch moves skb data area allocations in kmalloc_reserve() and
kmalloc_pfmemalloc() off the general kmalloc caches and onto a dedicated
kmem_buckets set named "skb_data". The set is created in skb_init() with
both the normal and the accounted kmalloc types, so GFP_KERNEL_ACCOUNT
users such as AF_UNIX are isolated as well.

Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4aea06d5167d1..a83689661fc28 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c

[ ... ]

> @@ -593,7 +595,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
>  	if (!obj_size)
>  		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
>  					     flags, node);
> -	return kmalloc_node_track_caller(obj_size, flags, node);
> +	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
> +						    flags, node);
>  }
>  
>  /*

[Severity: Low]
This isn't a bug, but the block comment that follows here, above
kmalloc_reserve() in net/core/skbuff.c, still says:

 * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tells
 * the caller if emergency pfmemalloc reserves are being used. ...

After this patch, neither kmalloc_reserve() nor kmalloc_pfmemalloc() calls
kmalloc_node_track_caller(). Both now use
kmem_buckets_alloc_node_track_caller(skb_data_buckets, ...).

Should the comment be updated to name the bucket allocator? As it stands,
it points readers at the general kmalloc caches instead of the skb_data
caches.

> @@ -634,7 +637,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
>  	 * Try a regular allocation, when that fails and we're not entitled
>  	 * to the reserves, fail.
>  	 */
> -	obj = kmalloc_node_track_caller(obj_size,
> +	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
>  					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
>  					node);
>  	if (likely(obj))

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org

