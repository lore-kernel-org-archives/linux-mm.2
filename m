Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 452A6D7496F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF83D6B0089; Fri, 19 Dec 2025 04:32:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB206B008A; Fri, 19 Dec 2025 04:32:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D356B008C; Fri, 19 Dec 2025 04:32:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89C416B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:32:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2874A591AB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:32:03 +0000 (UTC)
X-FDA: 84235704126.28.3049671
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8D6364000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:32:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e3Q0SVqq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mGnuSty3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R0NH2Wgl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8QpkS4wP;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766136721; a=rsa-sha256;
	cv=none;
	b=n9W16BAD4bYPVoHjPH2LJSOxrMQ77xZjPGobjA64MEGLDpkMG5RJ6D7pI4V5cgFKFyNQ5F
	87wbphlfRBcRVGBKC2PBoHGlp2fvSgBCIO2U0dGYg0vRkxQ+EX6CPfEfi0KeE3fscQfec0
	NZyoZMtk4qCgJAXS0FH030TEGVhuNjU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e3Q0SVqq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mGnuSty3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R0NH2Wgl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8QpkS4wP;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766136721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSg74u9vYraMY0EFLIMqPHxfZGD94igWLSgi2kICEig=;
	b=VvGibfANIIAFuML9ZWEW3y1aumo6cZjjMhEe2EajrKv1XqECdiWA9vK+UEvl573mrpT6Ww
	oMlMiKAoZ8cTbmHWyv71CODock1YLJ0x4cJkptACDdKZWX2BI+ZnOvrbFRaB3K6xkMHOPT
	naANXPtT7IVDlEGY24XQgEkWS287piM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 33C7C5BD14;
	Fri, 19 Dec 2025 09:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766136717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NSg74u9vYraMY0EFLIMqPHxfZGD94igWLSgi2kICEig=;
	b=e3Q0SVqq3cnuGt0azn3HhAeAG5F6g/ECS4fBQOWz13bML5IFdy6IoAxN7QF0B/3nmdFEaM
	5724bvOANp9bekPtExzsNDFxqhFdrbOcZqcvPrh4JfVdcSAjh6RX4iX8AIswWfND/wPQ/O
	yoFR512EXnFz9XdUNrf8wNo1SDw62TY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766136717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NSg74u9vYraMY0EFLIMqPHxfZGD94igWLSgi2kICEig=;
	b=mGnuSty3PstXiV08orz002z463OWPe45oGOcyWKC21dCLbTPN02zlz5H3bK2rRcc9NWLfp
	L0LH0hKljmT3ZFBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766136716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NSg74u9vYraMY0EFLIMqPHxfZGD94igWLSgi2kICEig=;
	b=R0NH2Wgl8jGnCB5BumtT+DHnLruXG7Hc4eBy8ReAGrRf2drAUyqAiYfhT5t1jkE5z5qmPr
	mG9vfZsHcNjEaXKXTl1kHgXM/IHXqjAP7cRg5p4rZ0kyFfvOA8G09OiIBcCqO/QJc8Tvm5
	7A0fVnZxMguEs8boDNwnvT7QRklXJgM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766136716;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NSg74u9vYraMY0EFLIMqPHxfZGD94igWLSgi2kICEig=;
	b=8QpkS4wP3MLvVYO7tE6c7Ht4/k3tG/xm1APr6oJSuVkWc5OuD7ocsFcF9BXsOIPeBZY35+
	uztkwyssQNyKWVDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12F563EA63;
	Fri, 19 Dec 2025 09:31:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /l3GAowbRWm/AwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Dec 2025 09:31:56 +0000
Message-ID: <6fcfe0cc-3826-42c2-9c54-c127dc8379e1@suse.cz>
Date: Fri, 19 Dec 2025 10:31:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: fix kmalloc_nolock() context check for PREEMPT_RT
Content-Language: en-US
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>,
 "open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT"
 <linux-rt-devel@lists.linux.dev>
Cc: skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
 syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
References: <20251219085755.139846-1-swarajgaikwad1925@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251219085755.139846-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8D6364000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 39czjwsua9jg85r9zubg3ec3hgj9mmr8
X-Rspam-User: 
X-HE-Tag: 1766136720-812582
X-HE-Meta: U2FsdGVkX18Kd+U2FXKDakD2M3BICOukyuQmYWSggzb7rbNtINCk13VUlG1tJYBqNjmx7iSSDoMTd9cMfA8pSnLykRuxTJW2LkzebvMXVJclmHpcjbJ+xJ4B9Nz27PgAE+jj5bYgaRtq35nUk1mzNHxEU3cu2rTmhFRNA2ti7b1saDcLXWTFn+gSgnTKmHE4LfXWnNfjsXWT+mthanvT5UK7Kgb0SU46XD1aRX8+NiKH0s79ujx+T5GAYIVKZA/NQ5UmsH+x9aZmPP5x8uRJWyi9rDGhiE9CffvkL4m0kTR8LJlWgsIDcUuFn2dGWyMLIhXgJ1YfQLTUyRhmGf6vqNw5DWVpn4QlQaQ77x9fKcJLB5zl9y2vbsQ9R+dM/6zrwOk347392jwuUrYgMEuKnrEuVYCZe0wkyZT+InGb0xlbHNIB5aGB3SUzYUDGfpn+TaMM4uM5TnqYVSN0AxUzjwD9ZuC7N1xPZ8T7cgOXNduEezim4PzT8QUpZQLu/YgxTFP1ROdWTXFXmAanuZWdrqLjW+KRgdYqf/mSevI9/VUmqCJEKGU3Y6gUkguuXtB8LLgIdXbrrMprfFnO0ln5qv0PdwvAD9y6HE+uS7osR0B17WgpJ8uGr3hg5/wrm1Lr5ZRP6zzSW/rI2HaHy//nYtPPqHBLsaJx7fupU1DZkXI88NgCzZdVcTugTx3QUmIp3vn2SPONelVu5UCzlExqT+Go4mR7ltVR118K8UPzaifMIVD/+KjFMFvVoWkjrYFCFkXPqMKwddGaNdPRAfAUzKzfetUcEgjJfVIZnx6INAot+iPXi/Z9/VwmnICvAarVCmUXyi17J3Duh4guPSRR2GNOSfLNLbeJEVw4cX9LdfScnVqHp5s3DN3AUUrYA2wVuxmiQLAYHu0Fx+7/MMYU4OFI1dPb/Hg24b8TWlf9aXPMMp7EMb0HJNog00J6PrbLD/zbbIwiA9qpdQfhVAw
 zpXCl4a0
 HzfGAcdUqjEqTmi4sYeYHepiuEfqXYVd28piuSi6EkY3gnagXpEY/piZ8mc2Sm61NCOPL/5Wwntn3MohooNIZbaaW32oQBB3Kees9zARM9Bk4YMvTRkixp1iQLo9odCEk7rWdxIkbfLmcN43yKYb6AqWhb36zXImGsbkRZfljRti5HlllNHEvGxv6+aXjg7LSks40Rox4vEJrrNZsYCJ2fxNPkfZUZh8CuIYZ1HqWYGfds2yDDHWpgM0upi9GULvFTESCbIcR+ajz8FJUqDuqhy9635nGrLV/6xQ116GIyl+MAkDWiZp6+U8N6YJh3aQbfma7uAVQABKXu2cQ3NoEN8xnn4aArBgiWYT9rCs2py/OqTICOTMpuEJ91peZZb6ulHuSldFz2C/5Gf8bMK6GHbdnJHkUE0/1bhEoTBHFHiq4VRDRxDuJ+3vVCgJgzD2dS+H2Lv8NLmQavEF3L2fa2pteyX3rz5HjRRCWA7NzVarcqK7093Pn4V/ENU6qAJgC0Dv/z9uUuTrYs8mkw5Dq0+CmBz53aKnggfNufNZz+ELi3/fCHwM5+M4zEqk5Kw7sUZsD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 09:57, Swaraj Gaikwad wrote:
> On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
> check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
> context, but misses the case where preemption is disabled.
> 
> When a BPF program runs from a tracepoint with preemption disabled
> (preempt_count > 0), kmalloc_nolock() proceeds to call
> local_lock_irqsave() which attempts to acquire a sleeping lock,
> triggering:
> 
>   BUG: sleeping function called from invalid context
>   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
>   preempt_count: 2, expected: 0
> 
> Fix this by also checking preempt_count() on PREEMPT_RT, ensuring
> kmalloc_nolock() returns NULL early when called from any
> non-preemptible context.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> ---
> Tested by building with syz config and running the syzbot
> reproducer - kernel no longer crashes.
> 
>  mm/slub.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 2acce22590f8..1dd8a25664c5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  	if (unlikely(!size))
>  		return ZERO_SIZE_PTR;
> 
> -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> -		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq() || preempt_count() ))

AFAICS we can just simplify that to preempt_count() then, since in_nmi() and
in_hardirq() both are a special cases of that.

Any comment from RT folks please?

> +		/*
> +		 * kmalloc_nolock() in PREEMPT_RT is not supported from
> +		 * non-preemptible context because local_lock becomes a
> +		 * sleeping lock on RT.
> +		 */
>  		return NULL;
>  retry:
>  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> 
> base-commit: 559e608c46553c107dbba19dae0854af7b219400
> --
> 2.52.0
> 


