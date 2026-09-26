Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A363C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8976B00A0; Sat, 26 Sep 2026 06:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290536B00A1; Sat, 26 Sep 2026 06:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CDD36B00A2; Sat, 26 Sep 2026 06:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01B6C6B00A0
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:44:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81678140628
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:44:14 +0000 (UTC)
X-FDA: 85255578828.19.A0A1A48
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47E6340005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:44:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GDW48iZa;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKcJVLyowqvGriiTBDZv6d3K/ixp7iuD3BjKXhPvX1A=;
	b=DkdOXCqN3MSVrwEs66C0YFC0Dan4qFaVseph/Jj9r7XUtj9GXMnrpoF4Cuv6GU0KnogdXD
	6RFFnNAHIRuI2JI4DCkvVLE1jXb/Hpx4acgmiLF9nDpNrI8g2mpt+ofGCKnH10KVavKQ+K
	cXqTgDw7o346hnKuRxdMLuaFweFAIsg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419452;
	b=qXSjnKqnV55DknanTmprZdVW9xYfFrnMp/YmGlA5M20iUGNix2EsMkbE+lqKRz0LZlflDc
	QHoB1mVUW1G9LsjnKEERZ87ebFQMSS4sfY25HfT/CglX2fCB40IdufhanmqxM1rWvXogxt
	z9j0RueYIu0OepqcWag/jMkiwhrDT8o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GDW48iZa;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4CE31596;
	Sat, 26 Sep 2026 03:44:07 -0700 (PDT)
Received: from [10.164.11.10] (unknown [10.164.11.10])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9193C3F632;
	Sat, 26 Sep 2026 03:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790419451; bh=tdcDb7EMI5MXWG2z6HDtUpPG9NMnbPPbqLSL0Wmwbus=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GDW48iZarz1IDGWNkaFpOCVJkeWVdPlytnKkrMZ96NZl5ztLfc7ze3i6YbNCQ01l2
	 EzJc5uaLXjC9xSpXDLmu/HhUNq5Xrx6tPgBvWNVl4ijNYCiABuSQ6svYKBFKxRG5/E
	 iQaixhGKnBdce6wkr0My14Gj6yYbZK6pT3Muy+TE=
Message-ID: <14e54610-ab62-472a-801f-d929171cde01@arm.com>
Date: Sat, 26 Sep 2026 16:14:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: do not warn on -ENOMEM from va_clip() in
 pcpu_get_vm_areas()
To: Palla Raghunath <raghunathpalla.0209@gmail.com>,
 linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, Brigham Campbell <me@brighamcampbell.com>,
 linux-kernel-mentees@lists.linux.dev,
 syzbot+442828bb356b10813a47@syzkaller.appspotmail.com,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 linux-mm@kvack.org
References: <20260925205450.21262-1-raghunathpalla.0209@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260925205450.21262-1-raghunathpalla.0209@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5a8b65om76h1tes1amxuf7j1q8jb1o1p
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 47E6340005
X-HE-Tag: 1790419452-682142
X-HE-Meta: U2FsdGVkX18v6MDZ8rv321zU+1uYOIGR9nLHdjHv57gfmfSirLwDtXDr3nmtSy8oJmrl6hygeXl9gvmw4yOQreT2jaG5czKGvQWsUtyXz4RNe1LaSOihfMZCI/TTwTXKW4OyHI2/j8XOFtrn4+DmemMySHWbYQZDkJ+Wy+QXGIljTWuUcfoZKXJ7lDxJjHG74wzPknpQqJ+44UD+f9KedREKOcDMgmlJcYc197xV5APUR2JSY/RQNhMwlVW9EYr+lfvw/47EhfqjPMQCIw6wgRR6GIx5GYynEtKLeLQwhT3c3lS2Go5m4CkaEcZuSjBPbSNDuFqH/fgA+uVAtF3cQ4uChD/BIUKHW98zDYI9YKWzrfTeEYzMVVinUNcB8YeBAXzQsZF0rAZVRyIvWqFKUvz29x0MquTgKioRxgkv8qEx3OxdIVqBLMmse/l0LWIDzNjfNDAnem8slcSUkI3PfS9N6GymD66PTy4u2Jh493wjfE9Y4RORgKiSktR/Luvgu/r+jvbwSEB3YH/MfQpklQ+ElXUA5WKsvC8lI8gjRlGeAw0hxXcuCm4E20+8zS4jXX45eBNBjCrbNfsA/w4X5+8vK9oQ2Ax8CoE/jGkzETZDiEG5cAQvIIsYRXZGfloeLMXERdTcjakum7DKSmotQDsBkvK9Oewm7lMCWKeadP0pIOlyYzd9vgH0n4zkd1WwL62M3eQ1pyV/W5OqIXOutFSW3TWV14+LtfeajDKJXzUs16aKixbdY00351p7yNX6ZXqagB/z54moVU5ldtnjFqlb0eSCGmNrSbxLVS9l2ovOWCBrR0+fcr2sdv0vttt/C4oyQv2C+MBj8orapGJvZ1wQ3awhF09DrPGT4skWvKlkzfJPIJ8TeVCqTjSZ44YUW+3th40Fq6chSCbNPPHM8n4oQYEFwVP4AHo1W+AzfZl/Wa9K2pBhalYGLLjUW1hX07wUH6qSpnv2E86L5LS
 70Ssc+Zz
 KGjx+eML6jfZV9UcVgzJKW9wH4HH0pCrDd/tdqNpp7LXOhdpovlf7nfqVpv5s3E4/32nBzqQHTIqQKCRa2qderxysspKYJtGUJBS/UuWVKLrCF2C+OQYr2rJ0+BfCAesACZKNgqJee0YdY6hdRApF5YAxgxF15c28bR6z+/CxzeUh9Zva/xP4t6XcSAZFpH0U09KyK4EKpiJTRTQGz3Jh73nudz5bw+jLUd3zqI64C2NED16uWbc37qe1j9CvFygN8rt+yZEtVYy5UVjoRkR4XZpqCMLvpuLIgAcZmNg5lqdsfDLQK9C9zFyBNxW0XNtAOAX+CVrG2GFWmIqnAvw3GS/yH3dQI/91z+R4aNSptoQ04NzgReOEliIncM0cZgU1iW795AhUxTadE+nC4wcSHizBBUHh1iYj5lVQxEm3bwHmWp1VLrXvYvpriGk5MstI5sMqoQqMDkRCSkDR5nITzznpWqRmgWR1tuCgmy6VkVICl+PxX0KpC3tw+FoY1jJdqiD0Kf+djpCzmsBnU4JMX8HKhfKmWZbDA5rJDg6gFbuVyZG3u/J61QLcOl2EcmRKoG4ExV0/ln51xyvFZh0EDiU6nAVaE6+enFiSq36WPm8o5Fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/09/26 2:24 am, Palla Raghunath wrote:
> When pcpu_get_vm_areas() has to split a free vmap_area in the middle
> (NE_FIT_TYPE), va_clip() needs an extra vmap_area object. It takes the
> per-cpu ne_fit_preload_node if one is there, and otherwise falls back
> to kmem_cache_alloc(GFP_NOWAIT), which may fail and return -ENOMEM.
> pcpu_get_vm_areas() never preloads, and a single call can do more than
> one such split: on a NUMA system it places one area per node group, so
> the first split consumes the preloaded object and the next one depends
> on the GFP_NOWAIT allocation.
> 
> That failure is expected and already handled: the recovery path returns
> the areas clipped so far to the free tree, purges lazily freed areas and
> retries. But the error is checked with WARN_ON_ONCE(), so a transient
> allocation failure under memory pressure or fault injection triggers a
> kernel warning, and a panic with panic_on_warn. syzbot hit this on a
> two-node VM while creating a per-cpu BPF array map.
> 
> Keep the WARN_ON_ONCE() for errors other than -ENOMEM, which do indicate
> a bug, and take the recovery path either way. This matches what commit
> b9183788a2de ("mm/vmalloc: do not warn on -ENOMEM from va_alloc()") did
> for the other va_clip() caller.
> 
> Fixes: 1b23ff80b399 ("mm/vmalloc: invoke classify_va_fit_type() in adjust_va_to_fit_type()")
> Reported-by: syzbot+442828bb356b10813a47@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=442828bb356b10813a47
> Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
> ---

Makes sense:

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  mm/vmalloc.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e7..24c7d0a5472e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5107,9 +5107,14 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  
>  		ret = va_clip(&free_vmap_area_root,
>  			&free_vmap_area_list, va, start, size);
> -		if (WARN_ON_ONCE(unlikely(ret)))
> -			/* It is a BUG(), but trigger recovery instead. */
> +		if (unlikely(ret)) {
> +			/*
> +			 * -ENOMEM from the GFP_NOWAIT fallback is expected.
> +			 * Anything else is a BUG(), but trigger recovery instead.
> +			 */
> +			WARN_ON_ONCE(ret != -ENOMEM);
>  			goto recovery;
> +		}
>  
>  		/* Allocated area. */
>  		va = vas[area];


