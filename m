Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6EEFEE6B43
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354B56B0098; Fri,  6 Feb 2026 13:10:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE626B0099; Fri,  6 Feb 2026 13:10:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2011C6B009B; Fri,  6 Feb 2026 13:10:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 102B86B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:10:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7E7BD5862
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:10:50 +0000 (UTC)
X-FDA: 84414822660.18.1C3A895
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 08E8FA0014
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:10:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dQR78MUI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MUB08aK4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dQR78MUI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MUB08aK4;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770401448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HZRJRC66IWmHOORPxa6bQkcCHGqYhrHoSI1sU4DNEU=;
	b=MkF7tg3CsdVmvteaSGltT4OQwOSnpvk+i92ZDag3DomYW1RbQ+wA8DO8OBD0m/wuhUd0fE
	+CMxblLFEZZ5r2JejiN7kIQQ+2g5eLxcz8Z/4eeodfr6KXtvABt5hZ60tjphwEQlg3dI70
	ZFXbo3w6Z22hfy7gf7oHrDfMa84Oa9k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dQR78MUI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MUB08aK4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dQR78MUI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MUB08aK4;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770401448; a=rsa-sha256;
	cv=none;
	b=sMzx+KeeB0lwBm5BgUuQWTjPqRjqUQqrEK81LxzAX9kYQ1ZQUw60AO1zGbgEJtm5yd7Nut
	moDo3UaBYiOy1LbXRhRgCNszSffqVyjHXdyOAqTfjWwohqbhjZAoSXesbdOMC8gR3/BMav
	PcIvF65N4+ESfQTvfrTQF7MJDp3Rhuw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 373AE5BCF8;
	Fri,  6 Feb 2026 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770401446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/HZRJRC66IWmHOORPxa6bQkcCHGqYhrHoSI1sU4DNEU=;
	b=dQR78MUI55Hr6sofCLq5cbGPiddAghs1SLbohtg6alhlWIhGnkzSD0JhUalhxyN5A4H2I5
	QbX8pTN5cQHmp7x+PY1B/cDNkjtp6B5zazsyAsDPYabXJTUxMNPYdT2oi1KJXXesBm9GZJ
	qugU4Al3yRmq8rvWAaLQhibKMB0pQHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770401446;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/HZRJRC66IWmHOORPxa6bQkcCHGqYhrHoSI1sU4DNEU=;
	b=MUB08aK4l4yrOqI+AbpH3DMQZa1SPSGsXs7wDmxa2NP7NjzDUtx2XZuVQblK15j1tH75/u
	bwMjzzN2W9hf4TDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770401446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/HZRJRC66IWmHOORPxa6bQkcCHGqYhrHoSI1sU4DNEU=;
	b=dQR78MUI55Hr6sofCLq5cbGPiddAghs1SLbohtg6alhlWIhGnkzSD0JhUalhxyN5A4H2I5
	QbX8pTN5cQHmp7x+PY1B/cDNkjtp6B5zazsyAsDPYabXJTUxMNPYdT2oi1KJXXesBm9GZJ
	qugU4Al3yRmq8rvWAaLQhibKMB0pQHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770401446;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/HZRJRC66IWmHOORPxa6bQkcCHGqYhrHoSI1sU4DNEU=;
	b=MUB08aK4l4yrOqI+AbpH3DMQZa1SPSGsXs7wDmxa2NP7NjzDUtx2XZuVQblK15j1tH75/u
	bwMjzzN2W9hf4TDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 134B03EA63;
	Fri,  6 Feb 2026 18:10:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 72ouAqYuhmn/NwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 06 Feb 2026 18:10:46 +0000
Message-ID: <2ce1eac3-98fd-448f-8a73-01bb3cb5a7d5@suse.cz>
Date: Fri, 6 Feb 2026 19:10:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/slab: skip get_from_any_partial() if !allow_spin
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260206171348.35886-1-harry.yoo@oracle.com>
 <20260206171348.35886-2-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260206171348.35886-2-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 08E8FA0014
X-Stat-Signature: zaedgtrxuq7gkbtjtjeo75q5789pcx7b
X-Rspam-User: 
X-HE-Tag: 1770401447-376641
X-HE-Meta: U2FsdGVkX1+NEdbHsA544l7qsTQHqoDEgLIYLaqS4eXRWd9Wq3LWITFhQv3TnfOjyqQlLpxJNLdZxwD8HogpxmYbFqTi5Z2uEi4e9MuFL2vFjrPmako0b6Ew4hJjimHzN/ZByiF6Yc3UYTnxaVrX7CBoWEL4LCoJQaLWEN7sF78d5o8QpxJkE4XJUiodwFz7rdppu230F7TxxX5x6odgnG8KOwX4p9X2Zooaieg8aAA7yXmkx4M0/LESwiBLIx/u9FJCBJaOi79tSmoDII/ivryZXUeAT034PNbaCPobWYQwBmcNMx8hAXK7s225qtN4x17uW9U6STzk4iCM/pXn+mCZPqJyzbeDGNyuuliL6K0wtPuiqjEu1lhZVkAB1OimNafyNJ60JXryAjF5Fj8UK7Gp97MPzx7+PW/F6tVGE0GNB0yAQw7P5dV1YgSifV04y0wVY+Lu7v/ADBNEPr0cq4HRVmOv7nrif+FWPPcpeaX8HYGuJjgUndrnQpeUn0wTVwcFovFujyb3zH5a7ov1o6jTcmu6fYz9KKSdjrlhlQ0HQn33xV9q4LnZUops/Ewp4G3nOfGP7IniWGe0zBLFeu2YgbET2/bq1Z5Mc0ixutvztv7j0iohk1r2jaZPE29J5jVSeUeXtrMhHLLQmuf4v2HGCfW0CXar7eeeqHuuY5H/ycCgzFQN8+FiX/EW4OBThLhpQMZPayeUa0OE7KNZycXmIc3ZGmbaUEtszaEcdctRMNio6dBeVqs0P/PxOVFkLqk7Tvks2dLb+cIrwLRHGOs8BmdF83Ed9UrUe7g7xWkqBIDyrzISi+CWzx7cNuvXKHURPeAKqJnBThqhSwiL8TI8d9pTfKRUD8FVhp8G7erNJnOmGchqko3WX88uaxMcMgTA+KVI8XiGahvtkmVKuOZ+GVJLSkd7IyZpeiYjVXWuRmvDStUSAROl8Yhgpsk12bdPF5WQZGkOjh92lVS
 cs0yV8Sq
 NvdNhourA8idBSZ/LHHc3kW7w3z3fGVQ3k1UYipBvxu/mK4dW7NRQ94X36QIClNwWqy9cDnxVfRXU3zVJr1OpnlK7xYLjDIaXIGaJR0UIciKtc6e8mYgnlyuFIoSRpld5i3cYbIrlsqtrJ9I+/uATJ/MurRhfzjOnlbLyIiJP7WrIETova84m6TfXVKoN9Tk2XmlptFV/6Y+7psf1J6aGCjr2cGfJktFPTZazC6VXur6oVXh0MHQ7o/37np/NDR93+dy9LhHind2UTBGQIcpG3cHFEZ/btd/2GyDEb2bLy/i9YMDmA657I20109ThviN3pdF2Lmhwy7irjRORWmd9FB+BPv8RMbfxtAJb47Nd0jTHhDZFWgqkmMtpBy0YWDjlqtC3zdFugj24BzLz4hSOi8X90EwGq+B/+tr8cIO/m147/sA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 18:13, Harry Yoo wrote:
> Lockdep complains when get_from_any_partial() is called in an NMI
> context, because current->mems_allowed_seq is seqcount_spinlock_t and
> not NMI-safe:
> 
>   ================================
>   WARNING: inconsistent lock state
>   6.19.0-rc5-kfree-rcu+ #315 Tainted: G                 N
>   --------------------------------
>   inconsistent {INITIAL USE} -> {IN-NMI} usage.
>   kunit_try_catch/9989 [HC1[1]:SC0[0]:HE0:SE1] takes:
>   ffff889085799820 (&____s->seqcount#3){.-.-}-{0:0}, at: ___slab_alloc+0x58f/0xc00
>   {INITIAL USE} state was registered at:
>     lock_acquire+0x185/0x320
>     kernel_init_freeable+0x391/0x1150
>     kernel_init+0x1f/0x220
>     ret_from_fork+0x736/0x8f0
>     ret_from_fork_asm+0x1a/0x30
>   irq event stamp: 56
>   hardirqs last  enabled at (55): [<ffffffff850a68d7>] _raw_spin_unlock_irq+0x27/0x70
>   hardirqs last disabled at (56): [<ffffffff850858ca>] __schedule+0x2a8a/0x6630
>   softirqs last  enabled at (0): [<ffffffff81536711>] copy_process+0x1dc1/0x6a10
>   softirqs last disabled at (0): [<0000000000000000>] 0x0
> 
>   other info that might help us debug this:
>    Possible unsafe locking scenario:
> 
>          CPU0
>          ----
>     lock(&____s->seqcount#3);
>     <Interrupt>
>       lock(&____s->seqcount#3);
> 
>    *** DEADLOCK ***
> 
> According to Documentation/locking/seqlock.rst, seqcount_t is not
> NMI-safe and seqcount_latch_t should be used when read path can interrupt
> the write-side critical section. In this case, return NULL and fall back
> to slab allocation if !allow_spin.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slub.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 102fb47ae013..d46464654c15 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3789,6 +3789,14 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
>  	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
>  	unsigned int cpuset_mems_cookie;
>  
> +	/*
> +	 * read_mems_allow_begin() accesses current->mems_allowed_seq,
> +	 * a seqcount_spinlock_t that is not NMI-safe. Skip allocation
> +	 * when GFP flags indicate spinning is not allowed.
> +	 */
> +	if (!gfpflags_allow_spinning(pc->flags))
> +		return NULL;

I think it would be less restrictive to just continue, but skip the
read_mems_allowed_retry() part in the do-while loop, so just make it one
iteration for !allow_spin. If lockdep doesn't like even the
read_mems_allowed_begin() (not clear to me), skip it too?

> +
>  	/*
>  	 * The defrag ratio allows a configuration of the tradeoffs between
>  	 * inter node defragmentation and node local allocations. A lower


