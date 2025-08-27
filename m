Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE9ACA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85FA28E0010; Wed, 27 Aug 2025 18:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8365A8E0001; Wed, 27 Aug 2025 18:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774438E0010; Wed, 27 Aug 2025 18:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63A6E8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:06:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AC2011954F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:23 +0000 (UTC)
X-FDA: 83823921846.13.F207FB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A83E5140004
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cJQ/ThAi";
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/QVbMlOVzQZDOQn1d2bRvCwftcA4hFeaZoH38uIzLQ=;
	b=Nugwt7FrA7Spn7YKpE0gXbtvG5ocKPg9b/Wz/zndlEmBGxzeg+lR0QGkY4WUQgY9xwdqz9
	PuX8s/P7raCVNjlYYynyYWcugHR8ZQ4pU75cfx2tGVJnQe1wTlGtp58I3okW7UeR+DHxVZ
	X9OqeQjwRmcTb7K2SvOVuWIy4qLnBOQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cJQ/ThAi";
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332381; a=rsa-sha256;
	cv=none;
	b=UxCiejBZ5/lojCcNLBQYnrOX+ea2XWON6v3dR5b7jyMd+mKoJJ3NaYqDTQXEWMWMJBsqRX
	Jk1ZbCRCk2RAMaPUklAF2dkjzrJZEXKtoZ1WoVk0AdEF0U+SmszfHpgtb0jgpyDYd2CdcK
	4h9nWnuAush2tDg0Pi8NfTY3I1GCWhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A563E43F19;
	Wed, 27 Aug 2025 22:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A622C4CEEB;
	Wed, 27 Aug 2025 22:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756332380;
	bh=QtZo2wLiVrvIDs2z9ZU576b2zdkNZlOfu/w0v8RzTyg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cJQ/ThAi5yoG32jd5YVCjvLgkJikRs+8dIWYeDUSIQWJlAVUHVCDFk+DbZjXzo5pu
	 D4flKoikmxH5XOGDCcJXUsdft4DTEqTNgOexDp4nd0Sedd3EeJ+GNTHkUvNmvk7/ow
	 KhBUBGsDfq6f2HuNoA2o3P7VbewK4UZHYq7mW5/g=
Date: Wed, 27 Aug 2025 15:06:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
 kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc
 info
Message-Id: <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
In-Reply-To: <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
	<7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A83E5140004
X-Stat-Signature: gobk4stmi1mokamih8obd3rskrtmkksu
X-Rspam-User: 
X-HE-Tag: 1756332381-958497
X-HE-Meta: U2FsdGVkX19VsFPIVv7hCUbAFSRNA0NoUWi0ESpxMw40NSd+mCPRLJu2TByCdJ6oI+iv5EIsnIWbLJFNteDhS2C2OqIaszvUW9nO6f1jdnAJUFw2FiGEC1GzEQvq4J6O4EObBuf8v0U//nbfCOBQycpcl8WpkyC54EJ+hBSIr4FzlFbL39vhFsO2mIUVEetRnqOd11FlSn1jEb+IHzXXTnLvzt6mSzWR+H/GY44v9879bIWe6PbrK8UgxPSEsQHTb1Q+Ets5A60HjKjeeOFGMqf/9aLfPoF+i/2E8CXmiSuF1yxmBo8NRx6KqyrBlsOiSqh6r9J65lxv+ffFKwELxyg/xXPUzlqRWvw3jY1ExOC2lgR6iCzq/PBWIlR7cRzy5U3VGFs2ulHQdDIM9nYFVGdfNwfBN+Bh69EOj+J9+zJrzQokXvNEEzgVpUBRygAnoXY+5lOcGy/KcSwwnGCMyy8azkyGKlwgLOSmBxKhqhy7ohhyipQytnWpqLzOfqYcJLESHdbOn5wXSYtGtpAOFRAAzEim61bNLWsdd7y0EpwkWcDpxCPJEmxn0RbhVD9NBbRnkD+gstSrVCbcVturpUMwmkwTuK5mWnpy8DvSEeknvRQeziUJrQcqo7MyEAsnjM7o7RbbcoQ/RJmJC8IzwZHbb7ZXpNnCtUCD/YiTbuNTQ/ZJji+Zd7KuvnXguE0HSU/pUgJwcoiZZLLPu2GCj0yKYnh0dAyquUpzyJjkatq/N8H+Zn2GRDFoDRiUrIgzE4dPZfAEId7+MUmj+gM2mbKg8UBoAAszOhg57TRyQpo1teWgDO1o42Bo9n6MsLStuKtjPnChsYXyId/5p6988bCZAS/aLXicIsIavvaMTSTr/iuswBw36bgu01qEmlQQeY9SilsD8TK/Ai3f7n08DEYXVE6ezNlBCI3VvKQfgP6Ytne0E+H6CUA+iK7uRoatOwz67+RNlXHu5dxadj3
 w7EYEEvv
 hlKWZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:

> In production, show_mem() can be called concurrently from two
> different entities, for example one from oom_kill_process()
> another from __alloc_pages_slowpath from another kthread. This
> patch adds a mutex and invokes trylock before printing out the
> kernel alloc info in show_mem(). This way two alloc info won't
> interleave with each other, which then makes parsing easier.
> 

Fair enough, I guess.

> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -23,6 +23,8 @@ EXPORT_SYMBOL(_totalram_pages);
>  unsigned long totalreserve_pages __read_mostly;
>  unsigned long totalcma_pages __read_mostly;
>  
> +static DEFINE_MUTEX(mem_alloc_profiling_mutex);

It would be a bit neater to make this local to __show_mem() - it didn't
need file scope.

Also, mutex_unlock() isn't to be used from interrupt context, so
problem.

Something like atomic cmpxchg or test_and_set_bit could be used and
wouldn't involve mutex_unlock()'s wakeup logic, which isn't needed
here.

>  static inline void show_node(struct zone *zone)
>  {
>  	if (IS_ENABLED(CONFIG_NUMA))
> @@ -419,7 +421,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -	if (mem_alloc_profiling_enabled()) {
> +	if (mem_alloc_profiling_enabled() && mutex_trylock(&mem_alloc_profiling_mutex)) {
>  		struct codetag_bytes tags[10];
>  		size_t i, nr;
>  
> @@ -445,6 +447,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  						  ct->lineno, ct->function);
>  			}
>  		}
> +		mutex_unlock(&mem_alloc_profiling_mutex);
>  	}

If we're going to suppress the usual output then how about we let
people know this happened, rather than silently dropping it?

pr_notice("memory allocation output suppressed due to show_mem() contention\n")

or something like that?

