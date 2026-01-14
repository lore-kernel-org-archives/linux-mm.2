Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6ECD31A03
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629236B008A; Tue, 13 Jan 2026 21:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7226B008C; Tue, 13 Jan 2026 21:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E476B0092; Tue, 13 Jan 2026 21:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8FA6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:01:20 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C13B55864D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:01:19 +0000 (UTC)
X-FDA: 84328917078.16.5CB79EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0589A140006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:01:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=as4AuNJP;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768356078; a=rsa-sha256;
	cv=none;
	b=oE1YucpjYIAVVyetq2QKZfMWumtmd7kat/voSz7b0xnhTnFF3Xzyyur3jY/kGZRighSw7H
	H+yfcKBSB2UD0EGFukDg4qWzMvEbw5WzWuTAnatmLYzvVp9bzEtL6wvoYiAYhhK+RdlktE
	3ZsHshK5LLnLkEs+SDJOStbCajKAxGA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=as4AuNJP;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768356078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtvPr39Xp5F15eLHV2ykZl6y9Jff8mgV+CJzOrmgOvk=;
	b=Y7OmKk9J1DyOAmaIgMmeB+SlvZshEtfW5PqSMZEK3nCwY9wkhS8Y6KlWjaXE0ZV+DDtZYX
	kadP2mox1Bl3l2YrvYwQHeW/JdzdjiL0RekOzBFWRi+panRl+GC68l930RBk6wwCCOS0KD
	yYJwAMiPkEs1vZ2pFl+ZY2zmQ5A1UnU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8281444BB;
	Wed, 14 Jan 2026 02:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7AEC19424;
	Wed, 14 Jan 2026 02:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768356076;
	bh=+CRDZiGmHP4avaMzn+PHhzpnNd6T9cSGRR99FsnCPMY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=as4AuNJPQpyHYQ9OBrfLzATA3dcGT2ZOQyZSzfKBGRlx7ocUXiLipH6wmEkyHPoaM
	 rfkOq/31UZlZ86qhj2qxbuocdyaLEEvdpOicwUxHp2zNVE+S2+ym0Tqq2eucqJMWYr
	 9gZ4MfUsDtLLnABjXzWSjlNyQvgnMj0shMrTl58g=
Date: Tue, 13 Jan 2026 18:01:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Tejun Heo
 <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Frederic
 Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 3/3] mm: add WQ_PERCPU to alloc_workqueue users
Message-Id: <20260113180115.bdb0cce3b99c72e247424095@linux-foundation.org>
In-Reply-To: <20260113114630.152942-4-marco.crivellari@suse.com>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
	<20260113114630.152942-4-marco.crivellari@suse.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0589A140006
X-Rspamd-Server: rspam06
X-Stat-Signature: ggo36rtg8qepjz9dsaj3adymzf6gf8dn
X-Rspam-User: 
X-HE-Tag: 1768356077-66199
X-HE-Meta: U2FsdGVkX1/Oxt20hLCvNGOOhFQ1rwfULmgHlXCTpNSOfc4ykjgdvZQ3QnpUx+Wvj/outSzufRVHgHecqtKsfRWsJ+WpHN7/hWjDwYeUwInz5r55vvkFEm8X+aN0rYBkA2e4S+2u9WLqNmz6incERxDIhrZW2RaSqWFn17/yq2GRLUjnylgvsrpWWrjaE+vI/KTTHHcDEumiSRmc1TU3j1h8woz06Opjj4UmHpRjzGiY6gxxQ+4xFSsftYMi4HMZbhCVQ2UeerzhUkfLZIq8H64uiVdGPBoaPkkyyjjGdbLi4RfKcm27Z3YnNT5z0D12a9SeGyNVBQOixlEveKauXW3InpdA2ONwksKl3PIYPo1J8aFAYvJ6Lm9MO5j301FEVPZi8f4dW5HsHh9UIQKnUAbQTrxGhFihOW1E6zLbr5uxqLPyfjJeS1oX0wEOow4ZprnFdvRkEtwNJ15aQ/okj5mBmoByjryDGLn/dFiz/nH3DVIbJygAtnDIZbG0YiGB1rLp3R4XfkPsddlWqT/AaWuSycRg2ci/nIDWt7SRbnEbgkyTfndJCPTYAEfgAWrl3eF3rd0xgVy81ZxzeyvXdenmnFiEQGWPqrqOGFhSu7zrfPv0U3DUDUb1JGqX1FzlDR8OX+jtE1wDOzbyf69HwiHqZ3KMtK38UXYqyUgLXG/K0g5NbSiT5ve+9UizxyMi4ifIVr5yhExojHH/bUlXv/w6A5eJXKCX8h5cutXj8tV5CnU52RY5BeZ5Zht5p+5g3L7/rOt6dq1OmiMm9A8Wvh1wazJL/SUxunwGRLreJ7jGM2HLsaAHC4Z8qMwACdxIFpK8zeL9ETtA+FPcQO8DE0/TTCn0iht259ipuu8zAaiNh26C4HEAgF0HwyJnuszaJM3vpTvfvorrufyCw4HOS03ZcZ3JzLBHhVO5ChPyVpGyyN5LNw3zsVf3zb9+UxolGvSLe8ObnCqaRasXz+I
 79dHsvRj
 ZYoUx09cjp1p+ajTBT+oMf5jpx8T7aCtKIXifJ8YyZYaklsZ0pOqi4vo6t2lihz6NTcOgg1NYdyK9Abwy7CTiUWcJT84aY/zeRTM1b0WKwDylyBvR+mqa4XREKG+m46DevPBKkfASTU/+b3S2JJfEYlmBpIHj/GbO/RVZnB8dOktHjsehEeV1ahz1KsWiNxZanlH78fm9ussUR0PIgJyCM9Ho3xWT0Fru9je0uV95/tFKDJL/pRD0bIe95jNIlzPMDVh4UDY7qXzI/Rf3UGFWK5L4NxGhj+WORG0dFJ20EHuhikFS8wxE5bhRclUdDFboFVcmcUupVAAXQKd56DUGx62yucfgmhtTovNf3YmYDiF7XJ2hYbYP2/SFgvf7OmcBcd5N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 12:46:30 +0100 Marco Crivellari <marco.crivellari@suse.com> wrote:

> This continues the effort to refactor workqueue APIs, which began with
> the introduction of new workqueues and a new alloc_workqueue flag in:
> 
>    commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
>    commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> 
> The refactoring is going to alter the default behavior of
> alloc_workqueue() to be unbound by default.
> 
> With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
> any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
> must now use WQ_PERCPU. For more details see the Link tag below.
> 
> In order to keep alloc_workqueue() behavior identical, explicitly request
> WQ_PERCPU.
> 
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -8542,7 +8542,9 @@ void __init kmem_cache_init(void)
>  
>  void __init kmem_cache_init_late(void)
>  {
> -	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
> +#ifndef CONFIG_SLUB_TINY
> +	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
> +				  0);
>  	WARN_ON(!flushwq);
>  }
>  

oops.  I did this:

--- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users-fix
+++ a/mm/slub.c
@@ -8546,6 +8546,7 @@ void __init kmem_cache_init_late(void)
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
 				  0);
 	WARN_ON(!flushwq);
+#endif
 }
 
 struct kmem_cache *
_


