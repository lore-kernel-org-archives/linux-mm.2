Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86E1CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37238E001E; Wed, 27 Aug 2025 18:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DD98E0001; Wed, 27 Aug 2025 18:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4AEC8E001E; Wed, 27 Aug 2025 18:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C39838E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:28:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D4F9BBE15
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:28:54 +0000 (UTC)
X-FDA: 83823978588.28.A122146
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3584440010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:28:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vr0a0HgC;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756333732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRq+gbpGkmW/G/n6vBoPnBK6eieMpjXC5ktdU2MfsEI=;
	b=KpzgvZ2wZKQ6HGF2NnqhkTrZw9MkP9zhxBfdXUL3ASGLxYc5/bRgSUMzaYnEdA6ya1L134
	yByK8D76rXTpJhoVeMs0HeENM7x+Yoj+r5B5QpOIsOhpujGTi88fjz4GEF80hDYURRdfs2
	P4ObIo/txMlkKhBNxHljjkDLyvQaJP4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vr0a0HgC;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756333732; a=rsa-sha256;
	cv=none;
	b=CugcVHRKlmyy6n623y1j4cp2bsTg8g/YtfFNCSSUoWETbJzPLBGQShfCDSbX26etgIS94Y
	arBbLuJy7CFl1lWhwwmQWnHp112B2YKG0kHZKTcQBvKqngvU1DX3BFT8JaRBVEkm2mcsi0
	B8NwxVdEXpZxF6RD9gGbfKZbgkhvhIY=
Date: Wed, 27 Aug 2025 15:28:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756333729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TRq+gbpGkmW/G/n6vBoPnBK6eieMpjXC5ktdU2MfsEI=;
	b=Vr0a0HgCcBfciF92/PnFlQZt4IMQfE/HIXcAjf5pACT23rNjPUxEZQ7Hs958KzalpcKMp+
	lN07CxWfsKLiBKciYvbvibpJZKloFj+q7PozrBB5SkiH/QbGiHQwyJ/b4ArcwNl9Z26y64
	hvY3KWLj2aMa/nJ+LzONEfEe0r70igo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yueyang Pan <pyyjason@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <aouiudhvbuwegvkdqwtkp7bk6gvrsxkqe7us5uj6ylg3pivjin@nl4ri6fbh2zd>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3584440010
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xy8n367so1tskcwgw5qi6zqh35x5esty
X-HE-Tag: 1756333731-668815
X-HE-Meta: U2FsdGVkX1/ZFKSH/Ww3KbJy8DQvJLENRLXpRtzfWjRcPClCdjxgSbTuI33dY+8lwzgIdTroaKosdHjbWS4E+DaV29epEbnSOHgaxKgPi4Pmrn4slAYEf3OndPjViaCPy90qKOrRRFRtRxLkLAFFesW6vZhj54wbKJhL/ilurtSqRMuhhKkW4bmmOSRrfOmstxPQkj9E1x2dRQWVh8jJeh7wdd8fQbaE4lhlsJrzp/xagPR5oS+q8/FNp1PRzIqa37LUxfbKD5Kf4LsCRcF7aHgSMcy/hD4n58kiMsqX5R67ie2VS2C9hZrGyayTY/biRp8LREW9qCxWKqP1sHoLk0NIC4AxOpYZEvkbUoGKpHvVZRpwifN4Cz52L0DLuM2T9RSGe65qR0CsbkFZWX2ZymyrDWhWfYLmSjg/NKx1d/YLNcpiiB7JLWRfQ8Bt3oZqCX21Xzi81Tr7x8r7AI7Etb6TU1arNcpirOWLeR9X2bXu7RRHZnyKtRQ5VJqVlFsDAuvCjaMGcuh2jxMKkOUMEtHCvHXK8xFcDd1z/XN75eFLm77gbY2NWuajC6JDrGBpgev5/9Kbo/dD50mydRIFHHF8DljGbDgAbxLwlriArg7eLVuLfTXhtUNVs1rMfyvuJu9J5BzXPcJertjILop4c/D1qn1dzhTYFwrzIOA6WkvUh9CG5O+Vm2OVuT2keLgr3IVOuaVfVoKu2yGf0udnKSSpcP+gBOjGuoJ3KGqCBSLkjTroh2D3ddWvO+WhcyB6EyWEMNeQGL5Ri0mIsXvDgA2f+haWfmg/zxG2uX4dXV2vKOOCrvIOw6gec+7LiBeCViq7QT4zy6ATc8kPiiyOZS+u7xraPo224ttW+5ssR7Famt4pTmyEnr0qs+RX0XPIn3/6S7fZ90O6cBclCN3M4yH+ZvEm5t6eXS3NNQ4jhQplViXHwHgkThpBVnC/iHymN/f406XwDheH7ZksrXe
 aG/+EnXI
 G/Xal9jpB855lxARIo2E7Ok2+CCE+7Zd1vfb1ihvK6OR170gTrQiHhKE5zKaRWtbkZLr+I4jblztVOkf1Yf41IkGUMRCbB3Uc1Knux2YH8bpc4wxSaiTOG/II/gK43YrrreX5SAWHhlzQUO3dqRY6yqNDj7GNB+otI/M6s7GYOZyUJCObRk/G1imtKuDw1kvKvnyYm0OqCzlUG1noJp8wL/aopv878Bgntb3DY/j79IyvW3Er2atc+JFkVLBmoGFzyJgrfoDel172gsuVq63tNfKIEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 03:06:19PM -0700, Andrew Morton wrote:
> On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> 
> > In production, show_mem() can be called concurrently from two
> > different entities, for example one from oom_kill_process()
> > another from __alloc_pages_slowpath from another kthread. This
> > patch adds a mutex and invokes trylock before printing out the
> > kernel alloc info in show_mem(). This way two alloc info won't
> > interleave with each other, which then makes parsing easier.
> > 
> 
> Fair enough, I guess.
> 
> > --- a/mm/show_mem.c
> > +++ b/mm/show_mem.c
> > @@ -23,6 +23,8 @@ EXPORT_SYMBOL(_totalram_pages);
> >  unsigned long totalreserve_pages __read_mostly;
> >  unsigned long totalcma_pages __read_mostly;
> >  
> > +static DEFINE_MUTEX(mem_alloc_profiling_mutex);
> 
> It would be a bit neater to make this local to __show_mem() - it didn't
> need file scope.

+1, something static to __show_mem().

> 
> Also, mutex_unlock() isn't to be used from interrupt context, so
> problem.
> 
> Something like atomic cmpxchg or test_and_set_bit could be used and
> wouldn't involve mutex_unlock()'s wakeup logic, which isn't needed
> here.

+1

> 
> >  static inline void show_node(struct zone *zone)
> >  {
> >  	if (IS_ENABLED(CONFIG_NUMA))
> > @@ -419,7 +421,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> >  	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
> >  #endif
> >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> > -	if (mem_alloc_profiling_enabled()) {
> > +	if (mem_alloc_profiling_enabled() && mutex_trylock(&mem_alloc_profiling_mutex)) {
> >  		struct codetag_bytes tags[10];
> >  		size_t i, nr;
> >  
> > @@ -445,6 +447,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> >  						  ct->lineno, ct->function);
> >  			}
> >  		}
> > +		mutex_unlock(&mem_alloc_profiling_mutex);
> >  	}
> 
> If we're going to suppress the usual output then how about we let
> people know this happened, rather than silently dropping it?
> 
> pr_notice("memory allocation output suppressed due to show_mem() contention\n")
> 
> or something like that?

Personally I think this is not needed as this patch is suppressing only
the memory allocation profiling output which is global, will be same
for all the consumers and context does not matter. All consumers will
get the memory allocation profiling data eventually.

