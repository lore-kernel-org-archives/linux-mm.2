Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F16A3CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA256B0005; Fri, 29 May 2026 05:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AE16B0088; Fri, 29 May 2026 05:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A356B008A; Fri, 29 May 2026 05:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 051CF6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:35:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9315D40AF0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:35:01 +0000 (UTC)
X-FDA: 84819948402.08.CFC7CFE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7300614000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:34:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tp66M1ej;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sC9PUTFM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tp66M1ej;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sC9PUTFM;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780047299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiXphdER9KPjAvZvInQHVfSv8bEELBky6G1eMTBRIPE=;
	b=w+adLPddkl40S8WwLb4tNdP1HBemgkhxpX7zmvJf+xY+Y1rry/VSkG1fFXsfOmrg53JWOq
	tlZD5XpFN/fL88mWvExIGeOTzb4ZZKd+t0i4bVIsNLNFIhKQ4JPZXtBJDqiHjpHLDX8vS9
	7EhSl5IgepY/Fooiaea76yTuWtmfrA4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tp66M1ej;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sC9PUTFM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tp66M1ej;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sC9PUTFM;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780047299; a=rsa-sha256;
	cv=none;
	b=x6yTYykYGqMooV2y1gMSgiC7XFlEU31hWYe0irAhVJsYGsCtORDqqBFymYGZWVfZjqGFpr
	K/M6S53o5XnCgOaaSaAWk29dxTJ/LRGKsSl141hs348ZYT9etEKvKTGtngsioDV9e0T8JP
	sYXLXioexyiHJ/L7rik8rVleKcea9H4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A5856AEC4;
	Fri, 29 May 2026 09:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780047298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiXphdER9KPjAvZvInQHVfSv8bEELBky6G1eMTBRIPE=;
	b=tp66M1ejfBahNYohlZSRIIZSkHilMajtUUE6NTETbZX/GCNgRZub+nI8bE7a+DgWv9y89J
	/9itPxBNWyUcE14e1w4fXdov8fdHgx51vfOIahubFB87UQ/AzNXJ5K67cOW6HYk04wMaOW
	an+4y5qnDBb5Fx8wSfvpei4QtBTc/XQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780047298;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiXphdER9KPjAvZvInQHVfSv8bEELBky6G1eMTBRIPE=;
	b=sC9PUTFMhjZWjrmDObD57Iz6YBKPuGz6KVXxDZbotPdJ7rAuLbzXs0F0cs/lTHCH9085iy
	utmV7d/YCcOysaDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780047298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiXphdER9KPjAvZvInQHVfSv8bEELBky6G1eMTBRIPE=;
	b=tp66M1ejfBahNYohlZSRIIZSkHilMajtUUE6NTETbZX/GCNgRZub+nI8bE7a+DgWv9y89J
	/9itPxBNWyUcE14e1w4fXdov8fdHgx51vfOIahubFB87UQ/AzNXJ5K67cOW6HYk04wMaOW
	an+4y5qnDBb5Fx8wSfvpei4QtBTc/XQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780047298;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiXphdER9KPjAvZvInQHVfSv8bEELBky6G1eMTBRIPE=;
	b=sC9PUTFMhjZWjrmDObD57Iz6YBKPuGz6KVXxDZbotPdJ7rAuLbzXs0F0cs/lTHCH9085iy
	utmV7d/YCcOysaDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41005779A7;
	Fri, 29 May 2026 09:34:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KeR0DMFdGWq/WQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 29 May 2026 09:34:57 +0000
Date: Fri, 29 May 2026 10:34:55 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, 
	akpm@linux-foundation.org, mhocko@suse.com, vbabka@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, muchun.song@linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 2/2] mm/percpu: Avoid pcpu_alloc_mutex recursion from
 reclaim
Message-ID: <ahldBnDclhfNMyzu@pedro-suse.lan>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-3-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528132917.81123-3-kaitao.cheng@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7300614000A
X-Stat-Signature: c5179kxzbqn3st5kfypi7be64up66hms
X-HE-Tag: 1780047299-134772
X-HE-Meta: U2FsdGVkX1+Qjy/ufWGrTVe0pQfxeVzLO+Fo80nycMxBAWUzYlgWcdfobkOTLkGk6aJMx6t74PlCPtUMBxppeVTRmNyCX+NH4JosMG8Zy8D2ObWmV2glZHJLRATE5BFwGWfW0saFJk7YQAqmu90gHLsb2c7Aa5AnGdpyoDRU7KDcIuyfqUggROsBZycHbFkF3xnsQXcvXV3p/TYM9xXvMshFvVxRAMUt3dVT+E4Bf4a/ZH6HQn6G5BGBSo8vczFl57mmwj8jXm2wj4EYqG9hvDORAQVpmMuIyiaifbkIVK8BN5fJzuHlDRsFHAJQps+SsDrfFBmvxxKDgKqQ9FkBCmoYWnmeNak4BuM9240oZrwJtFWPr1AgOc+nb5EknX7fjNTmEkR/OHLaiKc9vSRhcdd0WxFn95ikwrBMK+dUn9Y8TLTj6gPj60SVfoAaNyL9vxc9A+/PAaeYSuaIlhDV0jKQ5Lfas1gm+l9P8vMVdtMj5RAjIjwCFQCN7e968KQ/yyLTByGTdKliRf4Eq1s1F2XiMXQiTO/JBhTaTyGXPDwuggn2zaajK3m2QZAxv9gOBcEFX5VmDpwUyEhtA0AeCyHERaYQNz/BZev4jj6soVPD0d8qO+8hMdEeFepnTcRERX3KUtbKa6Ez5EBh5pNEvuM8kktTrIeZ9kPdEK+1JmTplWzH/rnWaVrXIOFlEpc70lgLgJcaizw6j+V2BeTumn/SYQI6NNjR0FZ7XD9fFf1Trjqn9tYVIW23t1Vnm5BfIxsuzBlroYX3aC3fVFjLZ+3xzPnmOkIcMYdKLI//CoGL9YbWgzJOYpUvIW1O2Nx0psnszQMFRT1C/IK9J8HGIsO+pcSoaXhyVD6Ols/9Xt7JeR9AS7eB8HT4i46NdgGt9IeL4hwN1tfutzGol46REtYZ+4gLHzB7XWdIC1JbhAe1YUIY6aan+WGeEO44TAV2OE2GFl0mzHW4kvbB7GM
 UPNPIBXB
 oFsByLcmh3GBZEXJ5wHgiCpIJ0SbnVBz5u/5Z5chiAScllYD+AWYCsw/RRYYYe3UjgVLRNf5Z5fvhMjXJOOhAIg82Z+oFdZtzL4ru9SOtDATm6HIUbq2ge6s4P4rvSDqv1i+qgklTzXlhY3lVOSzA3NHbLExbb+x7YSzaGGL5d92qJ322rVHk8gc/zfpaZNMPteR7FxmLSPY9PqqSM/ScPqDKIQIT6veY+E/UeFz5OYVt4qRdv/xn4cYSaVPmcIl0hEPyFEJVYWDktPpOs+utvjWJFschpcR4rYtT+9gmEH/FIy+wXi46Zd7N3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:29:17PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> pcpu_alloc_noprof() takes pcpu_alloc_mutex for sleepable allocations
> so that it can create chunks and populate backing pages. If reclaim is
> entered while that mutex is already held, and reclaim reaches a path
> which allocates percpu memory, the nested allocation can try to take
> pcpu_alloc_mutex again.
> 
> That creates a reclaim recursion dependency:
> 
>   pcpu_alloc_noprof(GFP_KERNEL)
>     mutex_lock(&pcpu_alloc_mutex)
>     reclaim
>       pcpu_alloc_noprof(GFP_NOIO/GFP_NOFS)
>         mutex_lock(&pcpu_alloc_mutex)
> 
> Avoid this by treating percpu allocations from reclaim context as atomic.
> Such allocations may still be served from already available and populated
> areas, but they must not enter the mutex-protected slow path or create new
> chunks. If no space is available, fail the allocation and let the normal
> balance work handle replenishment outside reclaim.
> 
> Update the function comment to describe that reclaim context allocations
> are atomic regardless of whether the supplied GFP mask would otherwise
> allow blocking.
> 
> This patch is a preventive fix. There may not currently be any path that
> calls pcpu_alloc_noprof(GFP_NOIO/GFP_NOFS) from direct reclaim context.

I don't like this. The proper way of fixing this would probably be to release
pcpu_alloc_mutex (or not have it in the first place!) while you're allocating
memory.

> 
> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/percpu.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 1bb38467390b..9c30e5897813 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1803,9 +1803,9 @@ static void pcpu_memalloc_scope_restore(gfp_t gfp, unsigned int flags)
>   * @gfp: allocation flags
>   *
>   * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
> - * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
> - * then no warning will be triggered on invalid or failed allocation
> - * requests.
> + * allow blocking, or if allocation is requested from reclaim context, the
> + * allocation is atomic. If @gfp has __GFP_NOWARN then no warning will be
> + * triggered on invalid or failed allocation requests.
>   *
>   * RETURNS:
>   * Percpu pointer to the allocated area on success, NULL on failure.
> @@ -1828,7 +1828,12 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>  	gfp = current_gfp_context(gfp);
>  	/* whitelisted flags that can be passed to the backing allocators */
>  	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
> -	is_atomic = !gfpflags_allow_blocking(gfp);
> +	/*
> +	 * Reclaim can be entered while pcpu_alloc_mutex is already held by
> +	 * another percpu allocation. Avoid recursing back into the mutex from
> +	 * reclaim; best-effort allocations from already populated areas are OK.
> +	 */

since this is an entirely theoretical issue:

	/* Reclaim paths should not be hitting the percpu allocator, for now */
	if (WARN_ON_ONCE(current->reclaim_state))
		return NULL;

But that's just my 2c.

> +	is_atomic = !gfpflags_allow_blocking(gfp) || current->reclaim_state;
>  	do_warn = !(gfp & __GFP_NOWARN);
>  
>  	/*
> -- 
> 2.50.1 (Apple Git-155)
> 

-- 
Pedro

