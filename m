Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D21C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687C26B00AE; Thu,  6 Aug 2026 16:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638CF6B00AF; Thu,  6 Aug 2026 16:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5519D6B00B1; Thu,  6 Aug 2026 16:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB156B00AE
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:51:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B77EE12019A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:51:29 +0000 (UTC)
X-FDA: 85072040298.08.9866172
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F36D11A0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:51:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C+YcwY3+;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786049488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/m0Pt9rEkujk538tJlotLFHiaCNx9L5OrF4ncWFhCo=;
	b=qcZRzJioLovItetPAzmei9WRYCi82VLIv9TyBXvjtaQ7S2qCP6fd3wXNNlBT9ZrqDnfLlu
	fbSjrW10JPRz2vCgqLLdlJ+f6MT31m67Fgia0TnS2m2UzD4ROqy8s+1h6ISHK23e5wbl/p
	PR5tDmwoyqnMjs09TP4ASrj5fzmQNT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786049488;
	b=nHDWPHVd0cmR/cbsbaNSnNaHfNLqscyHby3nXQUnHEMxE8naC6BCT8iADhpK0s5UqsVle/
	czU/6TEW2rtt/SbmC0kKEBIQuOOLn1U2H008LDYGWkZ0bZ1FxjQwzmCmYo3x9HZGNH3q5u
	a0hjvqiVFO0TUwTbwgewRz+zJxP3hYw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C+YcwY3+;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E77042DDC;
	Thu,  6 Aug 2026 20:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD571F000E9;
	Thu,  6 Aug 2026 20:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786049486;
	bh=f/m0Pt9rEkujk538tJlotLFHiaCNx9L5OrF4ncWFhCo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C+YcwY3+ewj4f0V7oB5VXGbSj1kdSurp7xQ3JeQvZ0e76GRfp7ZziDK4QxiiVT99/
	 23yekx32zhI9sbpbAFuD1/Z0M0DiEBP8Ky7FVjN80qD/VnKfv0ougEsrUMQ3vUk/AY
	 9VgYvGOuST1VvOVERpEdQpJd42M2s/3mUv0bm/Hw=
Date: Thu, 6 Aug 2026 13:51:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Su <sh_def@163.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko
 <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov
 <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Zqiang
 <qiang1.zhang@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] kasan: fix cache shrink race with CPU hotplug
Message-Id: <20260806135125.a444f867993cb3cd3122551e@linux-foundation.org>
In-Reply-To: <20260806121006.1642946-1-sh_def@163.com>
References: <20260806121006.1642946-1-sh_def@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F36D11A0002
X-Rspam-User: 
X-Stat-Signature: hyhgf61yrcibbm8k9urmcq1fcwfwbg7d
X-HE-Tag: 1786049487-157546
X-HE-Meta: U2FsdGVkX19LW0H14mD+n0FD9kmOBO0IamV8PgbJXtGOPxvG5dBJ6WMtXTRAPPSFgbt+bEsnunmx/tOpsTyNfp3b88wdaqX2MKPnBawpSMY5JLKLhFjElTaw0HGpbYZYRHvciP2szn2ha3M0hEOq20T9ybtOEc8Ko+0B3Cqs3th97zZGFBSRQ9/9A0yZ4oG8v9XcNNe6uzRBSIpYLp2pdcuzAjS9Z2BhGMDlSOl54qaCUOHU9yBX8c6vl0tSfakPeUXlh85pHT3kRCmCTkfWI0gxIdaQ/Tilfc/hEeQN4RrIMeqSpyOBesEahrbUP5mWPCh6crRyA0vvGMzzhipq33GbkO+NZD2Hto1vOsbkqFaL6X2+iiMRupUAXxZOgJskcjjlUZq+/SD/ArWZ6/Gzg3NgkaACoG3ybn0sEY06nw4jbsVIoRCuAx8YzNHRixBEJrIYr3vEBRntczbZvhgC9QaUpuwFs/Sg6rSgXqx92m5VXIMXv1alVaoPlq7aMKKmrsLz/DxG66F9KWzi6qcgMqd4tki+nhHOenQnzGm5N1Q9AqpdfQxAXL8d2qU/GfKQvfegaMpRhYgyMyUVByoF7uIUt/k/x9OXjK2eHt2UbikNYig+cXy+9mbqjSuZTTC9VgoM7RVkfa+oJpyYEKXbiwnJhd/YQKJY+TBE+LHTGgKWYvJDTowtqo0G6s4D+nuzBSvrdhC6cuwmim76afdTiUrlG/6HUXWpb8pVuSa/yPadzKYuK3jydYa51hR9P5Juv7o6YzzQKCOnEWZhwvWjk2EwGmkh+RaE34RcGaJnrQVEJKhpviYzKRu3b0eez2LdC+ElBzzVan3KKao77fG35/Q3CY5fRhZ0HYHmUloBrU6Gydz7tnzW9Vl+rsp/aEEJEHyhVnAv5ZG6I8O+aNnqLzWFWcLmNMAABrbXDpdfeOopPLvq9WyjqLTfsl4nLMWeVQRbC6U5nxfB03bV3Oj
 zIky/QjL
 TVkQvS7Gaw+b6I2UfacCf2l6VKqBzLa/+BggJCFy100Vz3hFDoHtb66X+CkravSjqwx6xYfH469jvWuLEgpqjyy3zw3MSV+cUP1iNguXWrGzhd8b3VZgmEY8F0U8/tWPDb9DEV/SNmcZxyWLtHsTMM7m6RWeB846e6BzxR1W4Nl58rFUaSQqRXB+tcF2/NFO1sQmeTQ30jee+zuZEkqlzvUNFe7ni5vnAofhQ/bLykQc5IlurvLpBSS9uRGWllMFHNmdScT7wUTgjt0K4O6XrhcpWv1tgYDOzumWHEfxh2LL6/aSTe3kPG1WkCHknRRlwxTOmUNV1XMyXLllZCiX9oIuaofrwXz6OW2nFtoQEx8lVkdGHMfBMgd6waA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Aug 2026 20:10:06 +0800 Hui Su <sh_def@163.com> wrote:

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
> Per-CPU shrink_qlist storage exists for every possible CPU, and each
> list is protected by its own raw spinlock. Iterate over possible CPUs
> so that a list populated before its CPU went offline is drained as well.

Thanks.

Please always describe the userspace-visible runtime effects of a bug
when proposing a fix.

> Fixes: 07d067e4f2ce ("kasan: fix sleeping function called from invalid context on RT kernel")
> Cc: stable@vger.kernel.org

Especially when proposing a backport.  At present we've provided our
-stable recipients no reason to accept the patch.

Documentation/process/stable-kernel-rules.rst says "it must fix a real
bug that bothers people".


> --- a/mm/kasan/quarantine.c
> +++ b/mm/kasan/quarantine.c
> @@ -355,7 +355,12 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
>  	 */
>  	on_each_cpu(per_cpu_remove_cache, cache, 1);
>  
> -	for_each_online_cpu(cpu) {
> +	/*
> +	 * A CPU can go offline after on_each_cpu() returns, leaving cache
> +	 * objects on that CPU's shrink list. Scan all possible CPUs to
> +	 * drain those lists.
> +	 */
> +	for_each_possible_cpu(cpu) {

In some configurations, for_each_possible_cpu() can do a lot more work
than for_each_online_cpu().  What are the worst-case userspace-visible
runtime effects of this additional work?



