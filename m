Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D31CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 07:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513BB6B008C; Thu, 15 Oct 2026 03:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EAF46B0092; Thu, 15 Oct 2026 03:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4006D6B0095; Thu, 15 Oct 2026 03:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18DDB6B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:21:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F68CC0937
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:21:50 +0000 (UTC)
X-FDA: 85324015980.28.B9D9979
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7AC9680009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:21:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n9Wt/TIv";
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792048908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6E0yMU0F/dYcS/pM3/JIocnZEqhByRAwCMM1dXa2r9g=;
	b=mAEjRPjzNHcE4GjX81rZsWrlFCovwvSQkiuShVGEmAM11K++afzIci23ajCm7K0H3yJYqm
	2TppCDvF/zRcCJ7JJAfGn7SHSCQ9pmW/D6xqO1ePfHZGj3jhwtxZ4eW+BqUER1XcrX+f5T
	86ZUX2PbmFNduFTBeh21ZyGuU6KsEJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792048908;
	b=rYQWTd5xFGsYv6QVsFpRkEI1azWENELrigwFrNVicV8TP4ZLiFgEBQjTAS1PqzZhwQpWW1
	ttUL+XZtUQjYuN3JmflZvx2YtR9Jvsl7Od5mXvou0dEclaocO0tafu908fAYUvISOEabob
	GIKyc7QxpnNfzD9IYYuBK8a9KBOFTk8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n9Wt/TIv";
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2F066053A;
	Thu, 15 Oct 2026 07:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E31C1F000C4;
	Thu, 15 Oct 2026 07:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792048907;
	bh=6E0yMU0F/dYcS/pM3/JIocnZEqhByRAwCMM1dXa2r9g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n9Wt/TIvaRqHvS58flbPJxcq8b+Y2rkw6Q4rbfF1L5MOhrDcvfjR2OnjmSoRE/mjd
	 AF/gbjk8wZzFSYtxtCkWt48IHWnxipI6scVmXdr3cNu9KAirHMjpgXgrICSBwTbuQp
	 R1yKIJWNUWMW9+0Ia6IgTclEQa+Xi4bvVAqIGRSN/xfpTrNEIkvW7bcdEXU5oqTjzt
	 HQCcfjLO2TFQR6qLvxtg6lcaG3guwKkknqMsx8focT1p7yxPEAgrm1Uq3G5f0jiSgG
	 9RPskU4ONuZ5SGgxaGhD3RlVcdT6XthFZudyedwIPg6jkYGdgcw+XMCDZGZdw1a7RI
	 zrvwCsz45Y3NA==
Message-ID: <d966f16a-a2be-48c7-b31a-a2c7d3ef6d5c@kernel.org>
Date: Thu, 15 Oct 2026 09:21:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slab: sample slab_state once in
 kmem_cache_destroy()
Content-Language: en-US
To: Imre Kaloz <kaloz@kernel.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "Jose A . Perez de Azpillaga" <azpijr@gmail.com>
References: <20261014150844.8536-1-kaloz@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261014150844.8536-1-kaloz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7AC9680009
X-Rspam-User: 
X-Stat-Signature: ea1zhbdbukpjs6axd3yfy5pzk8b8z7ru
X-HE-Tag: 1792048908-641920
X-HE-Meta: U2FsdGVkX18m+KKB4FGTurnNJ0kBWVbZSnXENm0GxioHnvlDYKg81WBWna4Irm9bhRiVQd76o1j7QEb4ZVilvMN8qw6UvqSWw3wRZkj9M7DFZCdfQQTmJdC4ViwlT5iGS11MHw7Z5+u/wgMwq9qDvM9MtdzNYT0KLRIrH9LrDWZqzFJrXxh92q7Hw5TEbdrNLkCvrrdsuxlBf6hLUMnoABmzfsaMjF0vLr5z3xGrESkSHx8P9bevVl0aFsVTL4o7TSLNvG9YhB1R718AnCjA7CqtC5jI31fyO34T2UKDJSjJZP+bRFlP1lKsDMLjcfAdv/TDcrF1VbEicjmYwYNGqWwUQxbS+D+SNw3fENtiuhxz2diLFw1rojCl4ij43Q4Tj/ezgkq6lY/hZNuNIZUTuBbi73J1l+KqyXzRA58KK0q25ECR2xebpiZTTc6aUutqevZAAN9OUoGzw4dz+n9OaJxZlQVp4Re3fUAjmkGZHDuQ02+KQbr2CMV0E9QxDTQ3KZgDlzZb0MQi4RIOXUKWDzIuhPSEtddMfuxAMv6NP0TjOT4b24SlhxotUULNqftargZAM2T1ak1D0B8tPO9SyR7Qftww3rh9MZADFb5k7W8QrRUKl37G1OrWTG6KNfr+kzz+yUJvRSw6ONA+Xp/otxCP+oMA2kbbk0u8WSKC8WOlZQJqLFt8Ejnw/30wrAGaZKFt5FGg66n9j08uvV01nsUdAda2OLLee0j9SAf3MGYpEwmIYBEg8T1StLCa2aAvxuurqcleBtLginOjIUUO0lw587WvPq84OEquIcF/g1/iBU1hS4FjjRdRV5o36Mso6yyMibjsqEVft0RVW9+ounMU2snE5rsKyZt2L16VeU/yf/lqsaSS4mBB4DQ6umqtdpYRqO7qKJDwffvAdEjYyH7MJR9Y+nDSwBuH0XdXiGtL3QBXq3UkqIvE/xIVpDDaGR6jMiCeTbrhf5NUKdZ
 Qtx/bMCc
 sBJRt29CJNy5xsLspzWt5XBFOqdQu8/UOxjZNAEM6zO/Unh8LJ46tF6joollHLSzHHcIgPVMDfcf/E963WLf4izEPeeKu8v0iC93AQ9KiFXFHS/LXks+IwS1dAMWDElHOpYWRsUqgQMYvV6oIn6XmdutTLuPWGswyL6WAeGSUaV01DreNoMOoxR5V+VvCb6ECZRt0LGQxHZFiu+i+wG4za+/XJt6Yg9lFy3eJ1LxRnYhXbsmMAj3CVyjrin3eZgFg5MdlFffRnIW5cQAJhYx3KiCvhyaCR/YYXSWgeNYEtDqpnsI/HsIZ/rD8XDFibjyPxtto4Juv4cpfBrB6rU91KPy6YJ3gmoIYPhe2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 17:08, Imre Kaloz wrote:
> kmem_cache_release() tests slab_state >= FULL after kmem_cache_destroy()
> has dropped slab_mutex and unlinked the cache, and for a
> SLAB_TYPESAFE_BY_RCU cache after rcu_barrier(). If slab_late_init() runs
> before that test it sets slab_state to FULL but skips the unlinked cache,
> which never got a sysfs entry, so sysfs_slab_release() calls kobject_put()
> on a kobject that was never initialized:
> 
>   WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
>   kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
>   refcount_t: underflow; use-after-free.
>   kobject_put+0x64/0x2c0
>   sysfs_slab_release+0xc/0x20
>   kmem_cache_destroy+0x104/0x1e0
>   bioset_exit+0x13c/0x1e0
>   disk_release+0x54/0x140
>   put_disk+0x18/0x40
>   floppy_async_init+0xbec/0xd10
> 
> The release-time test has run outside slab_mutex since at least v4.4 for
> SLAB_TYPESAFE_BY_RCU caches, and since v6.0 for the others. Since v6.12
> the unlink-time test in kmem_cache_destroy() is a separate read of its
> own, also after mutex_unlock(), so the two can disagree. Both tests ask

It would be useful to mention the commits here along with the versions. Also
this suggests 3 commits but there's only 2 in Fixes. I would guess the 6.0
change is not a crucial one?

> whether the cache has a kobject, which cache creation skips while
> slab_state <= UP. UP is the state just below FULL, so a false sample
> cannot skip a kobject_put() that was owed.
> 
> Seen on sparc64 at boot, where the asynchronous floppy init tears down
> its bio slab while the late initcalls are running.
> 
> Sample slab_state once, under slab_mutex which slab_late_init() holds
> when it sets FULL, and use the result for both the unlink and the
> release.
> 
> Fixes: d50d82faa0c9 ("slub: fix failure when we delete and create a slab cache")
> Fixes: 4ec10268ed98 ("mm, slab: unlink slabinfo, sysfs and debugfs immediately")
> Cc: stable@vger.kernel.org
> Signed-off-by: Imre Kaloz <kaloz@kernel.org>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> ---
> v2:
>  - Changelog reworked around the release-time read outside slab_mutex,
>    with the separate unlink-time test as the second read; Fixes:
>    d50d82faa0c9 added, as discussed with Harry.
>  - Correction to what I wrote in the v1 thread: the release-time read is
>    older than d50d82faa0c9 (the RCU work function had it from v4.11
>    until v6.12); d50d82faa0c9 added the unlink-time test under
>    slab_mutex.
>  - Added the explanation Jose asked for; his Reviewed-by from v1 is
>    kept. The code is unchanged.
> 
> v1: https://lore.kernel.org/r/20260930195110.13296-1-kaloz@kernel.org
> 
>  mm/slab_common.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 7223a7596dab..de11edfd1a0b 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -515,10 +515,10 @@ EXPORT_SYMBOL(kmem_buckets_create);
>   * and release of the kobject does not need slab_mutex or cpu_hotplug_lock
>   * protection. So they are now done without holding those locks.
>   */
> -static void kmem_cache_release(struct kmem_cache *s)
> +static void kmem_cache_release(struct kmem_cache *s, bool sysfs_ready)
>  {
>  	kfence_shutdown_cache(s);
> -	if (__is_defined(SLAB_SUPPORTS_SYSFS) && slab_state >= FULL)
> +	if (__is_defined(SLAB_SUPPORTS_SYSFS) && sysfs_ready)
>  		sysfs_slab_release(s);
>  	else
>  		slab_kmem_cache_release(s);
> @@ -533,6 +533,7 @@ void slab_kmem_cache_release(struct kmem_cache *s)
>  
>  void kmem_cache_destroy(struct kmem_cache *s)
>  {
> +	bool sysfs_ready;
>  	int err;
>  
>  	if (unlikely(!s) || !kasan_check_byte(s))
> @@ -580,10 +581,18 @@ void kmem_cache_destroy(struct kmem_cache *s)
>  
>  	list_del(&s->list);
>  
> +	/*
> +	 * slab_late_init() sets slab_state to FULL under slab_mutex and adds
> +	 * sysfs entries only for caches still on the list. Sample the state
> +	 * here, so that a cache unlinked before that point is not handed to
> +	 * sysfs_slab_release() with an uninitialized kobject.
> +	 */
> +	sysfs_ready = slab_state >= FULL;
> +
>  	mutex_unlock(&slab_mutex);
>  	cpus_read_unlock();
>  
> -	if (slab_state >= FULL)
> +	if (sysfs_ready)
>  		sysfs_slab_unlink(s);
>  	debugfs_slab_release(s);
>  
> @@ -593,7 +602,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
>  	if (s->flags & SLAB_TYPESAFE_BY_RCU)
>  		rcu_barrier();
>  
> -	kmem_cache_release(s);
> +	kmem_cache_release(s, sysfs_ready);
>  }
>  EXPORT_SYMBOL(kmem_cache_destroy);
>  
> 
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907


