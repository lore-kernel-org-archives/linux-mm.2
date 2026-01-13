Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B3BAD2F359
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6446B0005; Tue, 13 Jan 2026 13:36:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64106B0089; Tue, 13 Jan 2026 13:36:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9625F6B008A; Tue, 13 Jan 2026 13:36:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 822906B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:36:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43F351A0229
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:36:09 +0000 (UTC)
X-FDA: 84327795258.07.988EC64
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C64640007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:36:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hFImr025;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=xqkqfQnW;
	spf=pass (imf12.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768329367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pipRsFX69esF5KPLH4c9+I4B/dXZBlcjVkgFMV18ALI=;
	b=k2JIgQiG4lL5vpJlkGdTs0deinDYBaIeNU7gijhVE+ZH84TE1Dvk4tOMU2tltLTKTN+KO/
	HxkH9XdnW5wCj+M9f7z7YrbrAZHVnnVkRoqRYDQ0dl34gWzKUlwgGj7u3LhNupo8oaAoh5
	Q0AZ2oZYHeBml2SsCAFvQnfLt2M3dwE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hFImr025;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=xqkqfQnW;
	spf=pass (imf12.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768329367; a=rsa-sha256;
	cv=none;
	b=XbbVJ9jW1BbsFBptBfkFyBkahLl3poJ3Kw2teZ/bZpoZGWAbSkFqEXEYUGR459aaFkox9h
	WlWLcXES8NJFaXBkc77X/EsFnVhwSqQESZY9uIZ749Qh+v368pg+HfgH6Yh7JvMIdKr0TL
	6yLngzJXb/Qa9h8KXK6UAiNRl9nPeDc=
Date: Tue, 13 Jan 2026 19:36:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768329365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pipRsFX69esF5KPLH4c9+I4B/dXZBlcjVkgFMV18ALI=;
	b=hFImr025oHU3L771wHk/hH+l4KUX+6lGspsuzw6PbnGGkZ+sQxro5UaFtiyINrXh796G4K
	00d1uB5mDQoevz9twPv15hzNWWdXn+XGhd+73I+SNexn4IkTU2nNSvy1PXxXwFdYjV7Gk9
	9t60Vv1kdj8AMcNFoFoTiAxaF5EtVm/czMWoktNQGYXLTDDEuDg013/R83Zb3x/tnImXLL
	nNyWEzk2QC/wXLH30bUnesKMvtrB5A+VpDJ48BLku+F+m3Qpe06OguRMBqDXM5CuEBiK8e
	GrFZ/Y30sTDtwgkpKZzcjPhkrmyXA+KxJVSXJobJG/bTu0hdd3ya8SXDXd5Vyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768329365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pipRsFX69esF5KPLH4c9+I4B/dXZBlcjVkgFMV18ALI=;
	b=xqkqfQnWaqaQfZqfL4aBVEtYUtp9diagEpNuEMaq04JbGoa7muCgQh8Bb8gxJUlcg5uYA/
	Wa0zRRjjiz3hY5AQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC v2 06/20] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Message-ID: <20260113183604.ykHFYvV2@linutronix.de>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-6-98225cfb50cf@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260112-sheaves-for-all-v2-6-98225cfb50cf@suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C64640007
X-Stat-Signature: 99736i8insokx3s1jr6f7mu7ffsnfgrz
X-HE-Tag: 1768329367-949212
X-HE-Meta: U2FsdGVkX19zFuqydgNCiE8sPbp7vYt/2nyGgMQyJnxTUh/8Ci2VPyl16B7eMLxus0h4cncvt/FCSunR4t4aIDFX5YBCjoxrbAeXNvFsfaVZmYNYsPpAA/NNoDWQMkjqIb4U4xkrxkoZwPT0vLP+1N9QvEuYjGQCkS0ttWudTslyekp9HNnBrOY5wbFnPf1Yj5Ny30AiflYDaxVh9pETYwQoQzbVR/wyRleTOLS4PrgEtvf9P4QIXYlDfaD5i+NnLynuI87SfO6031hVidvxmSKzyHOeBRt3RCSTdR9QvwIndeypcfXXw2LGjJCgvjPH3W8YbkgqWidr0eHOSWCR3n2b0DuNOtv8GUWINqngPWfzz5tZaeid4uQu+wurQBJx4F96e5CgaP+f2JD9MSFpjUQIiT5anjalIFWp0oa4Zw3nyhIuAQKe5hBGWp6eAEfNAWDWOOphj3JrXeC+KZxHwwFn9PgHdg5qayErOHX0s5ibQ9t/UBP7ak1c/21Y73jQpR0aKQiZ/WY8J5oaP4K7BzfLr2YObHAi/E2RQP/cuqXOQGKM441zu1IzXqG9a0nlhvzHG6GTFRegCiLizEyQoAuLbLt45XEaOWNRH2q+nBpMfskBA+JMoKyvlkP9CBKiKmH9ff5mmrjXMNjNcQVdw3r+8U/pYpUmQtzyXwLromhn9BgzEvBISw66CpLaLc48MJ2Rkl7VP53tZrmcjOc9to8zN1cFR6C+Q+/sfmaAAY4z2FZwCtl9r+n2lLP71pCplqxzOEQYIKjw4WWNAp4SNfmWZQiQdDmz1BxeP2VJDN9PNj99l9i3Z0AHZrz25U+BJFoBn5+9X4ui46hVlY7Nt2fZ24iQ3+MXMYqj1Yc57roqAYfqquLsXC36tv8VkDipRUJY/qLCF+RNbSkO3iJwIhjhNoRCSE9lQtTTwHE1t/2iqlaDDSUBSr/kqpHoexDeuLrNSL9IYDEyDUZWJ8V
 Dj0IkAKY
 BQwuNI7NiDYcvEEa5tgDF3i4kAW3ICRDxVJJuFhiS8zUNd5SYk9AQnD+iwIXw6H9stz/bqodszmbKr35b0NsAr93DuGMyQpLhe3l87HrdfiQBE2WO8dNJLsWR7dXZpM7kH6XFICxYcnToG+SI3MTegHx1cWPmNBrm8nZ3CoTTc6PE9MaZfScVA4AHAGDgFhT90PUV/bAj7Q/nPsaO6yX1fi+pKlEOTg3aK+q40ijX5xVj7ywsQee2+8vJ/4HndNpMNvPVezowTrXNoUqpqcGsjrxY0cUfg4aeLibY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-12 16:17:00 [+0100], Vlastimil Babka wrote:
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5727,6 +5742,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  		 */
>  		return NULL;
>  
> +	ret = alloc_from_pcs(s, alloc_gfp, node);
> +	if (ret)
> +		goto success;

I'm sorry if I am slow but this actually should actually allow
kmalloc_nolock() allocations on PREEMPT_RT from atomic context. I am
mentioning this because of the patch which removes the nmi+hardirq
condtion (https://lore.kernel.org/all/20260113150639.48407-1-swarajgaikwad1925@gmail.com)

> +
> +	ret = ERR_PTR(-EBUSY);
> +
>  	/*
>  	 * Do not call slab_alloc_node(), since trylock mode isn't
>  	 * compatible with slab_pre_alloc_hook/should_failslab and

Sebastian

