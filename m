Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D427C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8846B008C; Mon, 31 Aug 2026 05:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7900B6B0095; Mon, 31 Aug 2026 05:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5E86B009B; Mon, 31 Aug 2026 05:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B29B6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:54:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD762120457
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:54:28 +0000 (UTC)
X-FDA: 85161104616.08.0EC8BB5
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id F253416000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:54:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pu33dgZP;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788170067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loNoEotVshAkf6GbGqDOZPoaBhFH7ZZvecjTTBvFy18=;
	b=FOv69sTp8P2EFMkQTX6uwhF20jbF9xzeEtjYxmbpnqFmV1tdwzjsuhj2U8TUQW2RA93Mse
	q/M8fSq01inUjcz0uitUa1HFXAATDHJ5epg9OewMWH+bKEilcQe0OYGsbRrsTGrYjG4HFc
	s2Yo4OCxMhEgewqMOwxHzXtBC40ksgs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788170067;
	b=h8QSw6tr547n3oP0W6NGSKmWRVJmicXUv6/AoTTCUcE1PDovsCTGMyoYTO5gl8GJcs1IRf
	bqNj77RyfrzjbthvhlkYAhImhnQFlzZgN3UHTzsSN5j8odSrkwCGIoT+DBB9x5Mnjb7lr1
	nFaBCoyN7ovsSHR/Bu/utWJkZjQ1XG4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pu33dgZP;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a5e392b2b3so5114877a12.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788170065; x=1788774865; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=loNoEotVshAkf6GbGqDOZPoaBhFH7ZZvecjTTBvFy18=;
        b=pu33dgZPmXJnxMnlq3HNMNK9JwbUZMhyHq0B1eQgx4hNN/XYcfaFsiIicxZSxj5WBN
         qH6c0apPvr954g36nSiF/NkJpSyogCrwbOmOKkUwRJ0oAvPWAG2r8vXm01ML30SO3fbc
         Yas3CBqPHa0vofis1LgDcK/uj/aQkikV/Uy2y+radp9n1h0++lO/YH0PHEEOag4CkGNP
         eT7y6nHSyYNvq2BeJy/wD2jntwPGJ8w5SjrcRN+9zQImS3qxXYj2vxHLn0TT9HsIseel
         8csvZRdc+UeHCTXgXq/BMM6pX3tAVcsdpFlFEXGZ73hOLRcvTcxDnF25Yq1iLtbNIxuB
         d2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788170065; x=1788774865;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=loNoEotVshAkf6GbGqDOZPoaBhFH7ZZvecjTTBvFy18=;
        b=qP0F1kL01VeExC0B0TvlouSTNTvh3t2L964G5rPt1OT8+bB+Ye1pSVroIdURiXipBx
         CHbxvd1wkhQP1BX0ojIKE8BsOYpcSI7skFOXxci3IfNNWGJR/V8ll+cgqwiT3nHfmJgp
         VlFEQwDy/3hP3/1k3nBQGdOuMD9SRx+69EsaG8Z/Jfkl8fJoEax/JBR/Skf9JmiwpAVB
         xt/PsHSXVjfpZZLevzscJ/SvudvRdOo2hx32ndR5RAg5RWhmbQtRAyGKlP6asKFoRr4X
         DWkJ5qu/Rry9cQxbJAj8wOzCv44oi48srzMIrqOfgz+2QSpxfi+GxxSy3qP4IPKK9RGs
         HpwA==
X-Forwarded-Encrypted: i=1; AKwUvByYaX0DlZZQkip+nkUMM2CxCGOON3zT4wrxY1OTfkZZxJxUyBPOCgqfQqZCoOwetW2POKjnQ4clMw==@kvack.org
X-Gm-Message-State: AFuF++k9soxllmj/aERFPAR37wCil0vLx4H2eKYOvh9bx4NY93BifmgH
	Mso9dlXuSYHreTE8ZZfnbGpFm1fDIRC8tW5jgGq4/WdJN+VuhW5FZgxV
X-Gm-Gg: AYBFou10+Oocz8W8QHeuN1kg+UwIWCVi0+KwfpjSPH+hbhx7+/xgvKEW4TynrWmursp
	W35EFToIf3KRwJvJm73LqZPmqH5fZyeSUyrVO9CFPhmBWxxSPn4nT5iRsH443qKT3ubgyfQuezp
	g4hwUEMvlQ0/NjGcFKDVpnR7JqFAaWpX5jG+8SO4fMFGohxUIPMbyYJ1ewjU0XMs3sV3i0vEeyG
	KmQloDWkm/Jt14bQGYEgfsFYDS/EfUlsNKYR66lukqzem3jwEA4Ys4NbE78ESNbNxtc4ALQcj6w
	TzytKteApAaml3N7RLhnh4eAq6eKsxhuyGUgU16zE5a9mph+ZmZT3hQvqfWRNHnRQp+gbkS2FlF
	epX3SL8i8vl1Z1/H4N0Q+bKYLI5kvutZmNX+3Y6QyTEF4AbIbFLmBB8HQGc7lm/lf/33s8EY/98
	7EijuIs2NXe5l23pScLtL7bTYf/A==
X-Received: by 2002:a05:6402:501e:b0:6a6:15a1:6c38 with SMTP id 4fb4d7f45d1cf-6a615a16d92mr14366008a12.3.1788170065225;
        Mon, 31 Aug 2026 02:54:25 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a636c816bbsm1697500a12.17.2026.08.31.02.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:54:24 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 31 Aug 2026 11:54:22 +0200
To: Dev Jain <dev.jain@arm.com>, Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <ye.liu@linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>, Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under
 memory pressure
Message-ID: <apVPTt9Xw8kSgmTU@milan>
References: <20260828091753.299295-1-ye.liu@linux.dev>
 <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
 <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F253416000F
X-Stat-Signature: ze7t7c1amejqdafixjgbzenige5eqaas
X-HE-Tag: 1788170066-859671
X-HE-Meta: U2FsdGVkX1+rCj472ij2uxKHmi7EKvMSncCgRpE4w3OYOLTjmyfcHv2e5hJMRYpOGvjx9Dei2A4I0Z6WQsv/E7CxSma/F0Ugvr5kKcwPxQz716dth26ekP2fLH6cN+xeKXjuT2ZealyruMKHJHej3lTMB+iTP0bChp2dj5ZHEHS6CC8FExk7Wj6hD5FVPE9+I2OEFtCSFDdYkmFNn60tIr7ihGTNdRDEGL1Ryvbak270cpHWyGW3T91cxwO/HCaQusk1t+JVBbkiTbZPnDSjaKKnhwnIX285HbMtQ1Pyg0blmJhIm1uic4150O2RhdSn9w1OYY+h9umCJyDzkmIUl+fD8+ZjSvBvbvhyFIlvCa2QccU2CTgg/cg9aUFSSlCUeJRhx9mphAG3uRlIyZPplBtaPptlP1EJLCBgPtuLal+yYusxsGS84n3iJzp0RYruDTZWrnz+tT1LWNhbLrfo/vvlMl38dg1FBRPxfwtoJmdbII7+G+R/VTY/6YBIVRe6ueryzv63uVrZLM01qS8J+JZKuAblZPzJvl9AwSXumK6zsXEO0eDMqBEeswVaalgB7HXRcDlE0AiCftxfxDYNZa8mI7NpfBUMHdsWhSoQ7uLfKWxiNwmiWWkJVxdAFF8KaRTG2xZgQeAikAE2CRiicRzBi4t4c66rko1hdm0C32gsNDHVmLz3oHhOQKcb59QUb1o9jRzOXtlJ7zkIcyDmh6kE++6ZWliSO48mdmfJVquXPxLQ1BJw7h7Q1aSFkvAFKUp7+vSfS6ehhGeYWjz05ZUXLbOxnrHElQgdta7LeeTJOuFEOftmf8dKE7M8E0XzoDhMBIp8LIocp2dnUEbRfiDpXQ6lWjriYDBAtb/sGsRNZTNBgEuZqvO+FPgGJoDyMFiYAb6MEpZ57ZSKrR2MLPrlUsnO9dy5x4AhbS/2WklOG1oWK0SfgEjY8NLX9AWJxL1A//aPNucPhRec21d
 hOxQpJkH
 uFMQi/G11QFXn32ILfda1vqAW9m4s03ADLbUHx8eHWCzyqUZiMk8arPO9I2ORKfP5cv3HIrAwf7F7Jrcf9uHmsDKRPQICxwtrpmrZsFQ0mGisKe56SuZ61u/dvfVh1Z3J2ddT2jQjrhm97JQtb/lONLDq59HjTAeW42Wf5c28VCjcwMTdNmJkLLnf2QCfDcFA5eKCsOzutTQ1ScrSVa6/DXpXXufLTTtpRJzx+S9e30iEEYAIltdCVZgxrmx5+HILihpyCvVvqzAuMRDeF9EE85n2RMVfaAgSYN8B5bh0GeAAZntEIMglaP5VOcP7fehUjgujNcJP0eELgzVCg3wnQ6kqo5xIcnI8T7HDUOTdPp6wtbsuae2acoWIbWFQdP/g2wQycYM7XyYrpSvUHuRLKvK91jSd+y655/dHxyVLwPIlTApVRxezh27ykvbnnNDU+U1bSjW9YFARrH/FJS54TEkETaKiK/84MdvG5zrCxmKkn/gAoGv338x3fJ5aH1IlyrUbsujxZe0WqLxS6cX6Al35TPv+PYheQo04xpCpdyNv8cuXHgsjHYgRWXVCBHyM75nwxYZd4V/0njQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 11:39:14AM +0530, Dev Jain wrote:
> 
> 
> On 28/08/26 11:35 pm, Andrew Morton wrote:
> > On Fri, 28 Aug 2026 17:17:53 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> > 
> >> From: Ye Liu <liuye@kylinos.cn>
> >>
> >> The vmap_purge_lock mutex can be held for an extended period by
> >> __purge_vmap_area_lazy() which calls flush_work() to wait for
> >> purge_vmap_node workers while holding the lock.  Under memory
> >> pressure, those workers may themselves be blocked in direct
> >> reclaim trying to acquire the same lock via the
> >> vmap_node_shrink_scan() shrinker callback, creating a circular
> >> dependency that deadlocks the entire system.
> >>
> >> Two places acquire vmap_purge_lock from paths that can be reached
> >> during direct reclaim:
> >>
> >> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
> >>    mutex_trylock().  This is a shrinker that only decays the vmap
> >>    pool and returns SHRINK_STOP without freeing memory; skipping a
> >>    decay cycle when the lock is contended is harmless and prevents
> >>    tasks from piling up on the mutex in the direct reclaim path.
> >>
> >> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
> >>    mutex_trylock().  This is called from the vmalloc allocation
> >>    overflow path; if trylock fails, another thread is already
> >>    purging and the allocator's retry will find freed space.  The
> >>    notifier chain provides a fallback if the retry still fails.
> >>
> >> Both trylock failures break the circular dependency: the lock
> >> holder's flush_work() can complete because workers are no longer
> >> blocked on vmap_purge_lock in the direct reclaim path.
> > 
> > Thanks.  AI review expressed a couple of concerns:
> > 	https://sashiko.dev/#/patchset/20260828091753.299295-1-ye.liu@linux.dev
> 
> 
> Sounds legit to me. Now there is no guarantee of purge being successful, and we
> can get a spurious failure.
> 
> How about using a WQ_RECLAIM workqueue:
> 
> vmap_purge_wq = alloc_workqueue("vmap_purge",
> 				WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> 
> I see the same pattern in __lru_add_drain_all() and kmem_cache_init_late().
> 
WQ_MEM_RECLAIM makes sense but this is another patch.

I copied here AI comment:
>
> Does replacing this blocking lock with a trylock break synchronization for
> the callers?
>
No it does not. If someone is doing reclaim we do not wait and do not try
to do it again thus fail allocation.

> When vmalloc space is exhausted, alloc_vmap_area() calls
> reclaim_and_purge_vmap_areas() and relies on its blocking behavior to ensure
> that free space has actually been reclaimed before looping back to retry:
> mm/vmalloc.c:alloc_vmap_area() {
>    ...
> overflow:
>	if (!purged) {
>		reclaim_and_purge_vmap_areas();
>		purged = 1;
>		goto retry;
>	}
>    ...
>}
> With this patch, if another thread holds vmap_purge_lock, mutex_trylock()
> fails and the function returns immediately.
>
If reclaim is in progress and trylock fails a caller repeats only one
time to retry an allocation. There is no any infinite loop.

>
> The allocator then retries
> instantly without waiting for the concurrent purge to complete.
> Because the retry fails and purged is already 1, could this cause the
> allocation to abort and return a spurious vmalloc allocation failure
> (-EBUSY or -ENOMEM)?
>
vmap space can be fragmented and not avail for 32-bit systems. For
64-bit system it is likely impossible.

But, i think we can overt mutex_lock() into mutex_trylock() just only
in the:

static unsigned long
vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
{
	struct vmap_node *vn;

	guard(mutex)(&vmap_purge_lock);
	for_each_vmap_node(vn)
		decay_va_pool_node(vn, true);

	return SHRINK_STOP;
}

so the reclaim path is not blocked. It should also address an issue
reported by the Ye Liu <ye.liu@linux.dev>.

--
Uladzislau Rezki

