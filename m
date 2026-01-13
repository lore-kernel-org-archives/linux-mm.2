Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB74AD2F353
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226C56B0089; Tue, 13 Jan 2026 13:00:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1706B008A; Tue, 13 Jan 2026 13:00:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA3C6B008C; Tue, 13 Jan 2026 13:00:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00F596B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:00:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6659314021E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:00:42 +0000 (UTC)
X-FDA: 84327705924.27.144B75F
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id 74720100012
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:00:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=pI3ZQqtN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=dDnO6eOL;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768327240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFFoJkjOAyFFmecghCApByGzs6pGushJZ1nfzPMOzgE=;
	b=JuuzSMrC6gOpgi25PVrubB6nqK2hChETaP5ZfxTC+XYOc/52/xL4qnMxIz8X56IyAtoOul
	5pk0U12gnLh9p6I9ohwk1fyq467Wx9Lv42uXqOxvzp+/xL5CfR4OIy6hN2uwmLfmWW2R1F
	4oEI0KOWuBndJUWG8Ss1KSl9JaBbA7A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=pI3ZQqtN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=dDnO6eOL;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768327240; a=rsa-sha256;
	cv=none;
	b=ithSlBWlZO6ZhyJjBibFYnk896mQ426UAE1mEw6TlHIxtmLpT9Qwsgf/QWjRMtu+WPuNii
	+pjxTQoZOSRTHl0jlJqSVTA8VE3mT2CD/O5sezj/Cz2s1VogJhQbtzg9c/+XrDCEANXX07
	n3w6Siymdl5Z9wSscyaahbTwrB2AM20=
Date: Tue, 13 Jan 2026 19:00:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768327238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IFFoJkjOAyFFmecghCApByGzs6pGushJZ1nfzPMOzgE=;
	b=pI3ZQqtNwhGVlf484c5AkD7qTRkHi/TUYAHB8Vh4Qt151WknNm4aoW36v9i4Mr30+TH8Ts
	v0EBmEP6gTwmVotqcEhNDBUAgK+8Lsj1JdlQnD+ndX9awpvu7sm4ljtKJJqHf7JgmD9zeF
	TdrKlt6OmpNCDI4nUrzVdvWEFn04Z9Dn6VH3O5SKgVDFbuiS8C9NVnEj5ACuxcjbGfUKXK
	yYjIQxUOPycO4s2pLf++uFohdMfyZgYx9EqtGi+c4h2Gcr17cwv3kRrRe6POVsXXCfujPK
	KUHtnB4iYRkcKEyxeJ0BEehxEY07pY/uHMxrQsKno10A8BIHAQ1tTmORywv6zw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768327238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IFFoJkjOAyFFmecghCApByGzs6pGushJZ1nfzPMOzgE=;
	b=dDnO6eOLuM0mK7DEU/yMAO+gD3P7qBwfrsWnBTOjaeSTV4mK8Ud5llvfE2uSaKoTAycLpf
	LmU3sS8Q2aF2rfCw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT" <linux-rt-devel@lists.linux.dev>,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] slab: fix kmalloc_nolock() context check for
 PREEMPT_RT
Message-ID: <20260113180036.Zl8j3vIY@linutronix.de>
References: <20260113150639.48407-1-swarajgaikwad1925@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260113150639.48407-1-swarajgaikwad1925@gmail.com>
X-Rspamd-Queue-Id: 74720100012
X-Stat-Signature: 4b3e35gduqh1pz7jat3cj1e159ef59du
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768327240-62412
X-HE-Meta: U2FsdGVkX1+RK2JThZeq2cEgFr3H9YisQgstST8Wtr2Xat6XOQv1xvrT6kBmb5HLMRvEmIe95k883yBPQG7gvIKeukWiTU2cYOeZAvNIgkKKWMw8GFYr3xwXh/ORC0um8bFN9/quEcJ+8ZvzZVu4F1I6JYvbTSwvDzc0uLaReoSe6ByJRk97FyBenlQBTgc0cM2IihMOz3oir5CdC5FjBjSz5V4DHLmW6x8UwfVAuzNyAloEdPK3NHpHZZWYvqEV2OMxecrqI8+xN1YKXLD3EJv7ctUEwGHVrg/BIzdf25EIiE3tvxqlXsjzKbDA0ucdIVRrLpXNljTGW5zGwiZvQE4qzL7MYdqR4AttvaBbNFvdwR1F+DeZtHd+ZrqeNYjAkQlMKB6saJYy6p3bJCpIvk1Kax0/dsRlwMFpxW23pDEx0c4pwpJlT6rqd0q7mcnFNqZExRjTKeRFqUSc8Dx843NLrVPEjvejXxG0tu/44dyDB4ICkzlLA5MYwM56LcvfWHzRw/fO3OlEO47mnw/03hLEO/mC2Edam+2Hmwqtb3dSpnfWdo4mrFfPne5IwBtGMzZ6LeYfWLudzrG4M/FCDckcKby2qiOR08akyzmMaBvJZu5wNSDgftYRCjp8ZIrN+Cz7TT+IClc/VawuhmoptR73hs4XuDP8buBOONb+p1BuUX9OnoX2wPcgzbGyQlA9eZdk2sKpF3tLxB+kvMwhlxuCbGwP5iD5x9bmR2Vjx5J3X0E2131cDBsT5WY4XcLG/V7+R2pCjvsDDPD0Vxqf1gDhMFh1IRcQoVeV34yks8z6LrkKoFc6C1ryBrEozO6qPT+T81KSWBjtHJKQ3fTPusXtl3Tet/PbmqKjIx2VqW/Z8cRGJ2q+kN5wLBZRAhkLF/gOQrgj+9FkV7kMFp7a3hC30xnSQwLbScQCs4mz6MnHbQ7kp7+anJivlHa2NvKFuapoE88VnGV2LovJOSt
 tZ37QPoJ
 3N9JmbunS/il+2RyeSPzSgxAyw7kMRDtzazZ6y3apXzqJ0TKibM+JmhZD6+7EOd7RPXs/drUYOe9ED0hHxPKTLNjz80hg2Y+wmQ7Tugyr2+6tEs8POKbhN1t2RBbrJ6IWxBHvbc/ysBLqn7oJprFMByK4b1d93OaEEL+LcFpP3L0uDxemz/NqcTBn+l4ypjP+aWt6Kp5lCEwfgzvoOkmSoCnGT7a+wSw3U5zbcirMx1wBub60yE6cBEuww0iB6DX0krSIE+1G29Zm6HGkSPSb5XhYw+nBV/KWxvjq0P2+ekhGZ1R414J7OCYPxg8O9SCCZ5MT2cvtfpu+vQYI1jHfLG1LbluoV/TK5p4+LxhHsGe9Csmtx+I/w4tfaZILLgjc6I+24xiBA305uc96d++H2Sv1j6RH0n9d6mylo61ZiVqhRYk8FDvl+2wbqyOXfHDeYSO+43oF5V5s33jhInorHrPrZiNMzwKdaLtw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 20:36:39 [+0530], Swaraj Gaikwad wrote:
> On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
> check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
> context, but misses the case where preemption is disabled.

The reasoning was different back then.

> When a BPF program runs from a tracepoint with preemption disabled
> (preempt_count > 0), kmalloc_nolock() proceeds to call
> local_lock_irqsave() which attempts to acquire a sleeping lock,
> triggering:
> 
>   BUG: sleeping function called from invalid context
>   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
>   preempt_count: 2, expected: 0
> 
> Fix this by checking !preemptible() on PREEMPT_RT, which directly
> expresses the constraint that we cannot take a sleeping lock when
> preemption is disabled. This encompasses the previous checks for NMI
> and hard IRQ contexts while also catching cases where preemption is
> disabled.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> ---

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

for now.

> Changes in v2:
> - Simplified condition from (in_nmi() || in_hardirq() || preempt_count())
>   to !preemptible() as suggested by Luis Claudio R. Goncalves and agreed
>   by Vlastimil Babka
> - Updated comment to reflect the more descriptive check
> 
> Tested by building with syz config and running the syzbot
> reproducer - kernel no longer crashes.
> 
>  mm/slub.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 2acce22590f8..642f4744d5c6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  	if (unlikely(!size))
>  		return ZERO_SIZE_PTR;
> 
> -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> -		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
> +		/*
> +		 * kmalloc_nolock() in PREEMPT_RT is not supported from
> +		 * non-preemptible context because local_lock becomes a
> +		 * sleeping lock on RT.

I would say that despite the _nolock() suffix a local_lock() is still
acquired. The !PREEMPT_RT does a trylock.

As I noticed this myself today while looking at other patches, was the
trylock removed on RT by accident, was it there only in an earlier
version which was never merged and will it ever come back so we can go
back to !nmi || !hardirq?

> +		 */
>  		return NULL;
>  retry:
>  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> 

Sebastian

