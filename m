Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25FE3CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6992F6B0005; Wed, 13 May 2026 08:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB8C6B008A; Wed, 13 May 2026 08:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3386B008C; Wed, 13 May 2026 08:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37F3D6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:47:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4E5440694
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:47:48 +0000 (UTC)
X-FDA: 84762373416.15.EAD9636
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C35018000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:47:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CnxzSyFG;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778676467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SoX8HrZgG3zuuSTZ16Qog1KVMM0PxB5QZZVwYcLIDGY=;
	b=FHc/BPFfxh7MnslHES/Ae+LodJzUtqeD8x8Yj91/7LX8YBIHJR5eYivYqqTW3geyvs6nme
	MBwzr7eyqp9Fpd7377vd7TrRE8Ifzn7au3cgRDqP6BY8jWAOECgEP3AhmwJmQH8JTZet9R
	9UdWBfo2mVtknBysFKav+XkM0j1Hxrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778676467; a=rsa-sha256;
	cv=none;
	b=vGYlZfNjvp9qQuidCj8WNjkMTxM4UCqjWym54Kz8YoTD6fUYlSOd8BNB89CTEiXm4SlbFB
	f8qxrRLUw6UU+nnSgx+uuS/guhG8VvZ5c41JdYVC4lgHd20MXZLPAe9SD9g58EmF9yqkJl
	Fbfah0ayKqE0z8jG6yc/4IJMrs6AQV0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CnxzSyFG;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SoX8HrZgG3zuuSTZ16Qog1KVMM0PxB5QZZVwYcLIDGY=; b=CnxzSyFGF5KjTYXDn/b6pOxcTG
	BfzmflF8/NWcXCph16qyZh9DZ5vIMyhnXAVEuKrMhbb8cvUTRQHs30Tf5/GGtDSSWKBDvYxrnYjg8
	/z6xrlroBjF9MYgvAxUveNZXLWUtc02LkfFXnvAdrp26hglwnsB86KyhoDbS8pa0ANxMoIsqMikIx
	ohTjHzt20drYxAGhMux+AfyW9YMpsziPE8rNd0KAs8P3KBui3UgBACzCkVBLTE8WFuTD1bdY4a1vp
	KcLNfWHjFiUhbiJSfRZGxHwko0VcljZaXLoUiO/wOjFiYquoulzy86dJS/WiFc83rTs1yhYCDipTC
	t6Mma23g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wN900-003AZx-0N;
	Wed, 13 May 2026 12:47:40 +0000
Date: Wed, 13 May 2026 05:47:34 -0700
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Ben Segall <bsegall@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] memblock: don't touch memblock arrays when
 memblock_free() is called late
Message-ID: <agRyMXYfoww-7Z4X@gmail.com>
References: <20260513105122.502506-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513105122.502506-1-rppt@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1C35018000C
X-Stat-Signature: kuktagfhs78zhorx8nd9ity6b6oxgy7n
X-Rspam-User: 
X-HE-Tag: 1778676466-609443
X-HE-Meta: U2FsdGVkX19W6X8GgWRL81S6l+eWKu575O6ymDya339ihds/WA+40hOQ3qGgpQZ2Bp5HMIWH+q+MkcybVD/bIiLfo07zWvm1197Fba5iEFfBTMi4y7fPj7kjIXom9+2SChrU9o3cB8eEeF0ErY9e1bWS46V1hEZeVAkE2hB1gggzgtVNkvfvdzz8gcpxynSjXXLAxlsSp8hp48Sn4B95gpmN+Tg4vS2TBP+E7LZPGmZw0LBoZQ+T8mWyYJJG6CTK81UJSqEYBy2ir14uv6EdSZVEJfWLBZnrveoH9D9hh1zh5YLZ+o4VMFMjP8AFIRAjoFXCvXq//lZ6A9xWRTgvRtlW67u6N4fmmM4avvYDWDzPCfVOVJNuun7tq6yiD44kf4+2A6SBiBTS9FswwJFM2W5YeHohn/ew9c6ES4XLd8sJAWMIIHgDYacr1GRPbEGP2IAv+NX2wAKsIj0EH00Op6ALZQmC6wuKUoqUacuxa+zdKm6NqtF+Zu3yhrgVhPTkoGWLceuq6tpq8kRwri/yiJ2u0fKa6zvR7/Irnfdvh1JYJztnpZT4pC1BWDg8tz4Dwi6ROFiLrccGwywdodVVFWyXNKJbGtfhILTsKtShJsMoiSUC9j5v7Bxy/lwwWz1y839y9PhCtVeA+V9R8lVX3ZIb7sosWESb/uAp9U/KXBtwfXCedj9Uuy/pZeaQyRJGhFldg1NLnVT02pzt9H0sZVn3HUh49reSdd7w3xEF69OwvTI07V7RXXfRT6V2XCa16miAKrAGSgvOSbsXus9PBR7qqm27fSXhImvFLaE2otYe4UOmBYRSE4LDr6xJcc7aA+auZ1HdK87BpLS3fAGIU1feEUnnNm0EsvwO75kgrGCoX0YD0jkZjblC7BjxVOnfFOF4XoShzCvptiOUdeOzlYOCQZMIaLk1oSHZ/o4750N2X0ib0g5Eay7kkG3zv9olazwH0V138d+GxIvY/rN
 9y62oenN
 3/vjoCJaHow2uNMYdJFr4eiXcbCoMyPCND+COgDG9G1J8OQFLnNO2N7GVKlEDJUanYuRufSfah83WlRjRbDiUmFAtS9wfA2zAEonL2smKPZdFprBGNj+PipWPRuA2q1Ud6+0blY9IPi7jxDNCxshPrXkcntFRqoNv++sLfTGE/E/qwQziSDdA9DCju3jpjUTcD9TmSC3MwbNkMS3HfgWWG9jD9iZAje2LeFDBZxACMLdlxg2NfjBq90aNmotVzXPI+qeeEaanGecsT/eO1Rrm1KP2NFfYR46ovHN39MK5Q0OOdL1j+rSHnmW95w5SmJQzBgrIBRh5zbfknDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 01:51:22PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When memblock_free() is called after memblock_discard() on architectures
> that don't select ARCH_KEEP_MEMBLOCK, it tries to update memblock.reserved
> that was already discarded and it causes use-after-free, for example
> 
> [    8.514775] BUG: KASAN: use-after-free in memblock_isolate_range+0x4ac/0x650
> [    8.514775] Read of size 8 at addr ffff88a07fe6a000 by task swapper/0/1
> [    8.514775] Call Trace:
> [    8.514775]  <TASK>
> [    8.514775]  kasan_report+0xb2/0x1b0
> [    8.514775]  memblock_isolate_range+0x4ac/0x650
> [    8.514775]  memblock_phys_free+0xc4/0x190
> [    8.514775]  housekeeping_late_init+0x257/0x280
> [    8.514775]  do_one_initcall+0xaa/0x470
> [    8.514775]  do_initcalls+0x1b4/0x1f0
> [    8.514775]  kernel_init_freeable+0x4b5/0x550
> [    8.514775]  kernel_init+0x1c/0x150
> [    8.514775]  ret_from_fork+0x5dc/0x8e0
> [    8.514775]  ret_from_fork_asm+0x1a/0x30
> [    8.514775]  </TASK>
> 
> Make sure memblock_free() updates memblock.reserved only when called early
> enough or when ARCH_KEEP_MEMBLOCK is enabled.
> 
> Reported-by: Waiman Long <longman@redhat.com>
> Reported-by: Breno Leitao <leitao@debian.org>
> Closes: https://lore.kernel.org/all/20260505051821.1107133-1-longman@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Waiman Long <longman@redhat.com>

Tested-by: Breno Leitao <leitao@debian.org>

Don't you want a Fixes: tag?

> @@ -989,13 +989,15 @@ void __init_memblock memblock_free(void *ptr, size_t size)
>  int __init_memblock memblock_phys_free(phys_addr_t base, phys_addr_t size)
>  {
>  	phys_addr_t end = base + size - 1;
> -	int ret;
> +	int ret = 0;
>  
>  	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
>  		     &base, &end, (void *)_RET_IP_);
>  
>  	kmemleak_free_part_phys(base, size);
> -	ret = memblock_remove_range(&memblock.reserved, base, size);
> +
> +	if (!slab_is_available() || IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
> +		ret = memblock_remove_range(&memblock.reserved, base, size);
>  
>  	if (slab_is_available())
>  		__free_reserved_area(base, base + size, -1);

given slab_is_available() is a cheap function, it is fine to call it
switch in here.

Thanks for the fix!
--breno


