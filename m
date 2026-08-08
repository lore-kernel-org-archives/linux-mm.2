Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 908FFC55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 07:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125836B0095; Sat,  8 Aug 2026 03:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D75C6B0096; Sat,  8 Aug 2026 03:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F446B0098; Sat,  8 Aug 2026 03:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C48756B0095
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 03:39:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A0BC1C0B47
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 07:39:27 +0000 (UTC)
X-FDA: 85077301974.14.343DFD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4A656160003
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 07:39:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pzi2XBnq;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786174765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTqmss+78C12rcL4AP/UtiB7LfHQKq113VHbYFFrqcE=;
	b=tbUZ+KtDdSxLMB7Iaz3SVgomFASsyJbakt0fG/ZMeROhk/7HwK3WrHiGsY9kiCbsuf3dmo
	1riiq9hJfTTpvp9qpVC3GHg3Ax3y+Ws2rbwXAe5aWEv7D1lsKEKjUpq4l6bwtTHs8TpDPl
	Ia/+/DZkTE6znWDL7bWwOzE4p2jL6/8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pzi2XBnq;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786174765;
	b=mXWwkPlRBAAbbrSquapZI+2EZ5yaau40jZMHtZcLSweQqxQhzRH7PCn5D36PPyVrVqK4Qa
	ivYuTM2yYKmxaBWnmULwL5EogDARZJLJtq98wncWYrjpWTfnUVMoLlrzukjF6CwM+7X4WF
	JI7v3GdMGk5tk1Fvf5ELE4hLQgEUWUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEEF2406EA;
	Sat,  8 Aug 2026 07:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C32A1F000E9;
	Sat,  8 Aug 2026 07:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786174762;
	bh=fTqmss+78C12rcL4AP/UtiB7LfHQKq113VHbYFFrqcE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pzi2XBnqjj3cs7kAMZAN+DoWvhbfRQqAvRkg1oPN0Q8iVowtqU6yJ3pCnbMBdycGT
	 h5aykI8H+JU7shpXU7Pg6MrEMK7Hj86T2nrGYMpY26CVqSPc9KIWD8mtE2mEApQRJI
	 QlOtPZBeaT4c5tTNcAw41Qvr0b9ZrJ+bhPC+QLHE=
Date: Sat, 8 Aug 2026 00:39:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Su <sh_def@163.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko
 <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov
 <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Zqiang
 <qiang1.zhang@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] kasan: fix cache shrink race with CPU hotplug
Message-Id: <20260808003921.fdb0df9ee4417b38f15e8c68@linux-foundation.org>
In-Reply-To: <20260808031459.3032812-1-sh_def@163.com>
References: <20260808031459.3032812-1-sh_def@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: as9nr4rjw8ta1fhzphknysmjq9xd9am1
X-Rspamd-Queue-Id: 4A656160003
X-HE-Tag: 1786174765-107799
X-HE-Meta: U2FsdGVkX1+rEQ2cnkF14bGu53yq8+D+ESFzbhp3fT/F47z8EItXLKDK9ZTZLPxddKZQZ0yZjaxzgSncs4QOkWHHuhNEKepNJpmA76D/ktmjoOVJDzuT1MsJ7bJlt/aDXlGxZURgU2bRWgVhhXBccgeZZK5QagxdoSHSDPzZeAfTgjC8rHdWzCHWHdvOrGhC3V4LfoRZZcGfCUWUWgnst5dlNii+56wMy76uVjvYfWo994tZjkP7dYWMFebLnhPqK/PXzmDXE3+3hIwpMRrCOqDgweB+vj1EgBnWEaVL9oaF0EvHTJb6EYmyFdWggQREJs0mma5xkIop+YAqF4wM0lGJJiKPcKEpH70StAeTzIoFpIferKAKP9OaZeJJkrhWWk0z0Z49lAlMtdhHNtE/8+EZ7rFPYstb4CmIJaXR9Kz4Z2Q0czqPc17VzxvZu1XJreBXUkP71uUVuqcE2nQnJo2d/aR6gxeHAGo/5F/ifdH3LjEdmBX5ClwQLNymJ04pHbvq0Uqab2hMGug4DSS4PDvpX68DE+9lMV6rxE3fZE0o3vT/tq9g7v/VYwGs33yrwFyZcTYKaVqzEe+91OTByyEKn/IbYsYwYgbm7/mwTbfAnyaq3eEMXku3c479VcAVBf+6lG/D6VQ9WaxouuiyR4WqIAE+RknQ70gmQ8GZl21cQPkWXAYrDWg8uGCiwGsP2qWTkFreUpFxLYTx6gbP8rny+YDwOPd3jbXteuMNmW2c5aCTRkTl7C67/BPU+lMryIsU6rvjjtRHyxUM24kNLBqRRYAwrmkjsiolyR+K+lrD/mB3TkVCJGsYMviEyUQnX48ZIvsL57fmfndBSLQ36Re3pSNakLcgvzOLeIrvExlvLaItqTU1GKqlbXQRGD7S8CaMyKZh1pMAwYrJp6E2eDRuFJFUJTkTI55qalH3bjw6LcsVRuWQN1j9mlCHk3bDT0I0bhXc/M2Yf2DEJYi
 zXTkyVMC
 G9hHwTr5bK81NHUTZStuKJyHpqkMEhPXgAWzDbyIX+gSg+bsTY/dnQHwprtzKX/D/PxHt7RXCt3YKzaCwwc/JoXBvpEu7Qd1crlYX1kBNLDBv/yoHVbTqrnpe/A3nwoTacY9Rxnc+5XhnXjdXb8q86aQivYl5/OHiW9Er00kv25c0PXNNJigedoFWbtBY3on17eAprqG/He85xpsABBZeduz5pEYv2c9jIuzWgfhitbpUGBRcEOgeWACuRt88IvchqRi0eb2T7d7Vc9933HZvD0hlhJQWLf9sXAtS8my/dR68dV6GxQm865+p/YkiTjkO4hU3R6lQxebTomlBH98uan6nN1VK6CISeZ/sr06vYmROCUkjfh+plbc7i09UxkQoEUFcAgjMsR8rsk9p3O0HatPqmjI+evOqf5bz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  8 Aug 2026 11:14:59 +0800 Hui Su <sh_def@163.com> wrote:

> kasan_quarantine_remove_cache() first invokes per_cpu_remove_cache() on
> all online CPUs. Each callback moves objects belonging to the cache from
> cpu_quarantine to the CPU's shrink_qlist, where they can later be freed
> from task context.
> 
> kmem_cache_destroy() invokes the quarantine removal path while holding
> cpus_read_lock(), but kmem_cache_shrink() does not. The latter can
> therefore race with CPU offlining as follows:
> 
>   kmem_cache_shrink()             CPU hotplug
>   -------------------             -----------
>   on_each_cpu()
>     CPU1 moves objects to
>     CPU1's shrink_qlist
>   on_each_cpu() returns
>                                   CPU1 goes offline
>                                   kasan_cpu_offline()
>                                     drains cpu_quarantine
>                                     leaves shrink_qlist untouched
>   for_each_online_cpu()
>     skips CPU1
> 
> The objects left on CPU1's shrink_qlist are not returned to the slab
> allocator. This may prevent kmem_cache_shrink() from releasing slabs
> that would otherwise become empty. If CPU1 remains offline, a later
> kmem_cache_destroy() also skips the list and can report that the cache
> still contains objects.
> 
> An intermittent occurrence was observed with a virtio-9p filesystem.
> The mount and umount commands both returned 0, but the kernel logged
> the following during the userspace-triggered teardown:
>
> ...
>

Thanks, I'll queue this for testing while we await maintainer review.

AI review suggests that there's a pre-existing quarantine_size
accounting flaw later in this function:

	https://sashiko.dev/#/patchset/20260808031459.3032812-1-sh_def@163.com

If true, I'm surprised this hasn't yet been reported.


Also, I'd like to see a need_resched() wrapping that expensive

		/* Scanning whole quarantine can take a while. */
		raw_spin_unlock_irqrestore(&quarantine_lock, flags);
		cond_resched();
		raw_spin_lock_irqsave(&quarantine_lock, flags);



