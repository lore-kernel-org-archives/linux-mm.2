Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 929A2CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 02:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50606B0088; Mon, 11 May 2026 22:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00AE6B008A; Mon, 11 May 2026 22:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16B86B008C; Mon, 11 May 2026 22:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B082F6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:56:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BB4812033A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:56:09 +0000 (UTC)
X-FDA: 84757253658.30.7A31663
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B3B651A0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:56:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iqz23Sxx;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778554567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oc/ppd6Wx1QSLj+AmPKcsVuvMJhR0LV7bbogmvb3n6w=;
	b=axXEeg/1R4Hn21/c4WrjvhvW8y2kjoIGyYlSFPMXXo4ZZLdW0wQA0ZYQ0h2MfzFS/EXRiY
	AcNv9XhMjxU/XwdmP0fc4S+L9JbDgMs6+Sx0MunFJzpdCeYSNqt7zcs5zQwfVeFtyNdCzZ
	UcVUu2zA/2kA4/NtwH1MtARhWh9oYBg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iqz23Sxx;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778554567; a=rsa-sha256;
	cv=none;
	b=Ex0FwF+77pwxOAuOjnpVe53hMj6vWkQ9ydWX4LoaixdO/O46RCOr7/47TwhkyR022PRqCP
	hE3+H1D4ujYuNaQV1H6Z+rb4ioyqc8aoidRyNDXF0I2DMZsdNCjKaJS0Be+nRF5pthxy9w
	7oJmBkh2j8PbaG26EAO79T5dt58d2WA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 12AE260103;
	Tue, 12 May 2026 02:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBE0C2BCB0;
	Tue, 12 May 2026 02:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778554566;
	bh=gSfIMYuWa1WLGqgzppK29lht+g9O0r6UaX++YxcXTAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iqz23SxxhVwWjNxiWIv8tB0WYm851cYmvT9dLNatiRPe7YL6NGADwcxiFPKe9zCNw
	 k7fTM6okLxf+mfxEC21T3m/G5d9hKNPptjj2x8AkNBB01gps6pM/8vci0hBGt5SaJx
	 r4UcJ5isfvRyaE8XQNl7SHJqxCDlwHSf1j8iFNpo3tI+vdW6niUXlNosjUP2Gizwlk
	 woYFGh7aVHJbrkDgZsE/iw+fHdhKBFJ3UwZ7adktH/Bjaz3/A2HqLd3QR+OypOkcEV
	 C/Pu+Ta8tq8bYg2B+70M4Z1Zwbn6ivI0iuZg854z8EQfHhYC+D/rWBSN9qDiCdatLO
	 r6zupepHSH+iQ==
Date: Tue, 12 May 2026 11:56:04 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qing Wang <wangqing7171@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: hold cpus_read_lock around
 flush_rcu_sheaves_on_cache()
Message-ID: <dpowyf5xneyg36lp25flxyjfy6dhijje7qy6z4sa7q5jpwp23d@uht5ja2rmfng>
References: <20260508082149.182139-1-wangqing7171@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508082149.182139-1-wangqing7171@gmail.com>
X-Stat-Signature: tm5docf1mq5ycmczbudb6q1mp39e6z5d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B3B651A0007
X-Rspam-User: 
X-HE-Tag: 1778554567-409228
X-HE-Meta: U2FsdGVkX19UmWqjgrM8raI3e75belmVkO4x5utP9W77HtzuThqLb8hp7Uin2VayL4P4caL7WkDijtEhpjWBHK7/x6e6joGk2HCMPsDVPWbiQtjGYKWXdVRtNWjKdnM2TKLttxUgJgRRQ2mZ53lWY12/DaZwnzKKBMwxLDkpxvVU1oB30VOrS1yzGhyqqJfxJpF1IhAmjElIIBjlmoGnuklm1iUJxoDD772NXTKCqz9g+mTHUvVCm8hsG+zRR7d0am4ecs2TyqKxzv997Pg1CurWAGeYVZWFf+aGpGSOISmFj9WGN507gM7rHV9rbPIVEnC0nOLBhEPDn/mNnpV/H3IuaSO0l8Bdmsf4WJjLCthNrFXxSudLgV81jK87lLUlmxD0fWTF5riwlTZrSi9kk84Xr1fMfQdLzMYDIHqQWbfuurTkLYYaKgXsmMr2a16zqutBPw2d2n2wNz+2W2b/5pr3gh1mdDCmeC6W20lBTjaRJFxVPy+g7TVo233Ev/XBl/sHAKucVdixISFYh/wYvNCq1c4sZIjHKsISx9a5REQCrHhDwOLm1xw2x3GWAVxSPI4MdKjyhu6Z1m9YtXIjc3VX5RE998tikfFfjS0ORDHYk6ZWoxGIRoCsdytMSzt0uYDrSLh9WClVJdmZtN8WaX36jFn0TvdV0bQ1+Jk2qMOylXeGwoXVmtenrgGPXcY4lID/lFubGijnE9+N8EXIh+sGLtauYrIowKjOWuQev2N7gGlqnobWW4Dh3AZrtuNRyyhkBDZy43IwJA10ax8WDoWRqskERsprrCBIzZFIDAvt1VPTmy3VSgC3xzrPl++FC5qvePQzrhD0+J7QnBFlbc+XNS5A/oGAtxKc8dI7z8xXZJqKSueS24FC9qi7nrPAWaQIRaAUYSMBYY6ZYfe+FcNtuw+7gtwXTbu0wBdF7QEETIoPfxqY1PjGdfzkinEDrI0j2ZxzPonJQaGy/8s
 pTQSJZdn
 19grGHT5zcpcr7iCt4Dk7mpN6JNN/8OUkLc8yYPv+gsPn95VKFJ/lzEMrtedP8upsHSQiL68rwVY4eksNgGC/xNXP3mFs8h13RYaYifJ5vKCWinV9wqXhDC6orHPkYxFBvHChcx/CHvGwOKM0Ak56fY9uJQ/sX3sFx+yMTKCDGQLBH/+98oG+wkukE6G7aSnm8WXRid80+PgP7XGGjr55108vBhTHjJjY5ToZx0ouvXsXrlBJO4G+3xcHSOErWqPz6moavX1C9L6/AYEsyC3qh2dA79Ai/0doLi6EFbvmJ1rUQ/7VWmUcnf3rIQxoc8lamYyjlTCzm9EwYL6veuTFsahecQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:21:49PM +0800, Qing Wang wrote:
> flush_rcu_sheaves_on_cache() calls queue_work_on() in a
> for_each_online_cpu() loop, which requires the cpu to stay online.

Good catch, and also the set of "online cpus" is subject to
change if we don't hold the lock.

> But cpus_read_lock() is not held in kvfree_rcu_barrier_on_cache().
> 
> There are two paths that call flush_rcu_sheaves_on_cache():
> 
>   // has cpus_read_lock()
>   flush_all_rcu_sheaves()
>     -> flush_rcu_sheaves_on_cache()
> 
>   // no cpus_read_lock()
>   kvfree_rcu_barrier_on_cache()
>     -> flush_rcu_sheaves_on_cache()
> 
> Fix this by holding cpus_read_lock() in kvfree_rcu_barrier_on_cache().
> 
> Why not move cpus_read_lock() from flush_all_rcu_sheaves() into
> flush_rcu_sheaves_on_cache()? The reason is it would introduce a new l

I would not split the word "lock" to "l" and "ock" and instead
start newline before the word :)

> ock order (slab_mutex -> cpu_hotplug_lock). The reverse order
> (cpu_hotplug_lock -> slab_mutex) is established by
> 
> - cpuhp_setup_state_nocalls(..., slub_cpu_setup, ...)
> - kmem_cache_destroy()
> 
> The two orders together would form an AB-BA deadlock.
> 
> Finally, add lockdep_assert_cpus_held() in flush_rcu_sheaves_on_cache()
> to catch the same problem in the future.

Should add:

Cc: <stable@vger.kernel.org> 
Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction") 

?

> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> ---
>  mm/slab_common.c | 6 ++++++
>  mm/slub.c        | 1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d5a70a831a2a..0ee5a4189453 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2110,7 +2110,13 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  {
>  	if (cache_has_sheaves(s)) {
> +		/*
> +		 * flush_rcu_sheaves_on_cache() use queue_work_on() and queue_work_on()
> +		 * must be called with the CPU hotplug read lock.
> +		 */

nit: not sure this comment is really necessary, given that we can detect
it with the lockdep assert added by this patch.

Otherwise LGTM:
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

> +		cpus_read_lock();
>  		flush_rcu_sheaves_on_cache(s);
> +		cpus_read_unlock();
>  		rcu_barrier();
>  	}
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index 161079ac5ba1..2a005d1e3a74 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4024,6 +4024,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s)
>  	struct slub_flush_work *sfw;
>  	unsigned int cpu;
>  
> +	lockdep_assert_cpus_held();
>  	mutex_lock(&flush_lock);
>  
>  	for_each_online_cpu(cpu) {
> -- 
> 2.34.1

-- 
Cheers,
Harry / Hyeonggon

