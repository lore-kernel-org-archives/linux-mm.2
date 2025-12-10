Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0716D3C546
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 12:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0776B0006; Wed, 10 Dec 2025 07:58:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039AF6B0007; Wed, 10 Dec 2025 07:58:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C516B0008; Wed, 10 Dec 2025 07:58:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC6326B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:58:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1B9613497B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:58:06 +0000 (UTC)
X-FDA: 84203564172.29.E800015
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B403160015
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:58:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eMcTYzlX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fPgis3gp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eMcTYzlX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fPgis3gp;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765371484; a=rsa-sha256;
	cv=none;
	b=KT20t3W+KQFgf14Vuk4mlOkP9fj0gUT2wAUIXQv5q6He2BJFSNiqzg2sza7mxvn/MWf9dg
	9fCFXF1CxovEI/6+cvIN5vHgCMy2zx/vrAA0Q6JA6AtSFf9YEESCinYvAtQMz1DO6iq3Hl
	U0jx5C7BFU2Lesd0RsZk943pcezcQgk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eMcTYzlX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fPgis3gp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eMcTYzlX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fPgis3gp;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765371484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eetQyXD/sOvNibezct7Tv5ZQAuEm4ZVFaMv9Mjbh4E=;
	b=XPH2HmHYYOS08irVs5p+ee2rWqPPeCRKkm9R6sWrP0niRP0bkkaHxGJsqdXb8iOEh6MZIt
	ah/HRP4x8t0zjBakcNdCYrAY15TtyTsVZK9wNDJAiAi6IpSj0iES8qtKBBCGcwXVLeIZR7
	TvLkxR2jlLlTg403UhMGhjhjn03WCgY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9B7E3388E;
	Wed, 10 Dec 2025 12:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765371482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0eetQyXD/sOvNibezct7Tv5ZQAuEm4ZVFaMv9Mjbh4E=;
	b=eMcTYzlXpYLmLxRRqBffyjzH+cQV+HaQB10LMie7tRnMKZHe26vXpwRvUeSjZ5UBn0JNuU
	8DgYNfljrx27Jy1r6/dX15zQuierbimxLnWSh1RfHgDFMg4t5uRYEzAJN/WRSD9OzX8b8J
	Yuw78+YifDTeGhMBfZL7lU0C4x2tL2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765371482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0eetQyXD/sOvNibezct7Tv5ZQAuEm4ZVFaMv9Mjbh4E=;
	b=fPgis3gprjFz7y6ob7fRcQ6zytoWvTnbIgZExBO6KmvgJ6mr9HtowMfVegHxogPoxJmDjU
	mDIn1tcxsximINBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765371482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0eetQyXD/sOvNibezct7Tv5ZQAuEm4ZVFaMv9Mjbh4E=;
	b=eMcTYzlXpYLmLxRRqBffyjzH+cQV+HaQB10LMie7tRnMKZHe26vXpwRvUeSjZ5UBn0JNuU
	8DgYNfljrx27Jy1r6/dX15zQuierbimxLnWSh1RfHgDFMg4t5uRYEzAJN/WRSD9OzX8b8J
	Yuw78+YifDTeGhMBfZL7lU0C4x2tL2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765371482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0eetQyXD/sOvNibezct7Tv5ZQAuEm4ZVFaMv9Mjbh4E=;
	b=fPgis3gprjFz7y6ob7fRcQ6zytoWvTnbIgZExBO6KmvgJ6mr9HtowMfVegHxogPoxJmDjU
	mDIn1tcxsximINBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A33433EA63;
	Wed, 10 Dec 2025 12:58:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IlKBJ1puOWkbEwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Dec 2025 12:58:02 +0000
Message-ID: <aaf80bb6-ad8a-4d11-b8bf-a91168ae6a08@suse.cz>
Date: Wed, 10 Dec 2025 13:58:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: reset KASAN tag in defer_free() before accessing
 freed memory
Content-Language: en-US
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, ast@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
References: <20251210022024.3255826-1-kartikey406@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251210022024.3255826-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B403160015
X-Rspamd-Server: rspam10
X-Stat-Signature: 3wb9ueabt387sp1x5idff4xi7pjw196k
X-HE-Tag: 1765371484-232250
X-HE-Meta: U2FsdGVkX1+IShNAiJLzrGBwNqNU6KdDIEmikuuoGVztG1FrQQ4POE7SOgsg9Cxbdj8msEScZYu2cdYEL/tiUaUKt1yPM95rxE8oTQL1bjFsRmK8xCvgL1kmwGoM31UJ6a0Q3uiHGi+lKUAR/gWvGOZnuI1LGrBJB8y74eHd6vF11VORXeOC3LmcQUUvEqcsqscjGwcMb7eF8ZPlWB9zg/TRQZSydmI5Gm4d1bF6RC3BpZGyWgI+Slm85o3pM88jQl/ld7GgLkFMgsQl6BmoD+Xpz7+7JDo1dd826jRiiMb/v6OwSi7iTLP+UgY+AFkpwvoNdBW+r+gzgXl48h002EpvHUBlIVBSV2Xq8jGw4KHay3ZRaDypKT6W7ev027q0CCM36BqWBYMMf8jQJo22RPiylvrFEwZyWETAb5tniRTNShNis6S/ZHB8LG5nvKSzm7dgMMawdPdkX9zeyN4cmrVph0s+UQSpjSvgmJksdMeezJqi3WtT6WNXCziOKDQayN9UyLL7FxXa8kMGq4dpYQogASVg6kTCXR4cLZ/qERk4xNCLqk0mL7O5Os7ICkMlpXcyzwG0T8SRQPCGRFK2qEWosTCNWYvt7f0UtKPlzOiMxZZ2fxKRDSZPU8kdptM/UoxNTr3jbtZzYkvvbSTvsqBCNtllD/4H1WB6nZ6txENYQR0ehdxC5p4fVdofCSPBzpzmihAU+8Ty0ixuS9jSO0VnE65G+Cco96ebZYkPVOhVf7wh5XE/bDbOisIjGyQotjvYyM1SKv1vXaZeEFT90FoqqBqdpsUjwCW8hF3tkAYfBmZ0K6BfAMLLCpq4hFqnUh72OyyEqAfwD3oMYCt3e2KfzqgBLp42nv2fVWb/IMEH0z9pZ+8iji7O1zxBfx/q9TqoS59zQiEONfelVUcFlXB6BhTuA0yrD/uYUpU0bKnOrbUrALJ2RkO5OuaSLcDhbL3y2Rt1fKurZzCcgbj
 PPEC9BRM
 58I3faehQXQhO0CRPXGw6/y8rNYgcd+0Kc9QMMkdGNDyO77F/+nrmt9CbSCEx7ZIMjkbzVVbSgsNHbIjDq9ouBJ9mf9JmSCfyoYg8ZjFxQ4W/ljCHEE3IVsAKeyUA69lWrg5B7MiKyF72mvtbEkeA/NeMmkXkuRS130tyW6rcH1iC9/v6Kj6zKIfMWPDDjJTH38lgtgAc1r5RJOB1wwSDp3ONwuwwL6BVWY+K3Jqm5ZdlMLSofGDGHzqczs5JzKF319daOlLM2REY9FKZhhgIslENBcJEQPAVg9k+h2x7+KF1IZTybNc5SAov6vjXsF3poqGQlRTWRAxT0/jLA2auFujBdyx2jSjOLbJtPOtZd7Pb3N/tzubLK4hjbCHFfUug3Yf646AlfxSlCU3ABysfF506UzP+jotkD1Vjujk7FTenTWJHhDfZ882sQdF2B2d3rYQIgPFC6mIY0lseuZ+iUrpt60ijRmhbSKWrUMRoIwG0W8VW8kvb7BVJCwpIe+PqfZBT+fpT2rk1M68WvL1aTbJQlDZkayn7cylTqNV+F1qzZKeyxphLFFYC3EoLshL7b3zD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/10/25 03:20, Deepanshu Kartikey wrote:
> When CONFIG_SLUB_TINY is enabled, kfree_nolock() calls kasan_slab_free()
> before defer_free(). On ARM64 with MTE (Memory Tagging Extension),
> kasan_slab_free() poisons the memory and changes the tag from the
> original (e.g., 0xf3) to a poison tag (0xfe).
> 
> When defer_free() then tries to write to the freed object to build the
> deferred free list via llist_add(), the pointer still has the old tag,
> causing a tag mismatch and triggering a KASAN use-after-free report:
> 
>   BUG: KASAN: slab-use-after-free in defer_free+0x3c/0xbc mm/slub.c:6537
>   Write at addr f3f000000854f020 by task kworker/u8:6/983
>   Pointer tag: [f3], memory tag: [fe]
> 
> Fix this by calling kasan_reset_tag() before accessing the freed memory.
> This is safe because defer_free() is part of the allocator itself and is
> expected to manipulate freed memory for bookkeeping purposes.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Reported-by: syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7a25305a76d872abcfa1
> Tested-by: syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Thanks, added cc: stable and pushed to slab/for-next-fixes

> ---
>  mm/slub.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index e6a330e24145..46959c6da2cf 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6534,6 +6534,8 @@ static void defer_free(struct kmem_cache *s, void *head)
>  
>  	guard(preempt)();
>  
> +	head = kasan_reset_tag(head);
> +
>  	df = this_cpu_ptr(&defer_free_objects);
>  	if (llist_add(head + s->offset, &df->objects))
>  		irq_work_queue(&df->work);


