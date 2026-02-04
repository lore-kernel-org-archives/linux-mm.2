Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48BEBEA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F936B0005; Wed,  4 Feb 2026 16:34:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803FA6B0092; Wed,  4 Feb 2026 16:34:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE906B0093; Wed,  4 Feb 2026 16:34:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59EE06B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:34:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E46C1B1E31
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:34:16 +0000 (UTC)
X-FDA: 84408077712.17.80CB409
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0BB014000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:34:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rd1JcDki;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jV7dAsbm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rd1JcDki;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jV7dAsbm;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770240854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpECjgLDyQROSSuqqkM4/AP66DpIGAvnkeFoALvGbNg=;
	b=pn7b5JalAZDPYu7qqjpnf5y1Y0HpGi+i1l0FobeVKUDCEnsiY11tc7GwTNPvmvdTmrCRxm
	Eap1VGixXSd6pFjHCHkwwHsLjhaLuwu1t1e3MfO1x7LT4EKuSfRBXGTkkQLFMCokr8mH0o
	GeyJC7lZWYIlkWBLLobr3sZ+BAjYtF8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rd1JcDki;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jV7dAsbm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rd1JcDki;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jV7dAsbm;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770240854; a=rsa-sha256;
	cv=none;
	b=S7707agMu4Imibau0nRa1nYFqMy+KZ6GKzwTHBgJyyDfV+U1W/zzQjixH+r3W1qKt/BTt2
	FYviJ4KDn5cojmcjJ74IrpK3khwD83QoVhlw49Koip9m4apPPJJBFPit1Jr6Ugloo8TtKF
	VxExoscodn25cNpck03BcUN5mKdo0mw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C10725BD6A;
	Wed,  4 Feb 2026 21:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770240851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HpECjgLDyQROSSuqqkM4/AP66DpIGAvnkeFoALvGbNg=;
	b=rd1JcDkivGYAJX5jTLUdHvhNoNBnESnBxYOBd4TCFsPdlZSqPBrWPZCcXosVhjWTN64mpj
	N6esqOxI7L3PrwCKRtZLuCAblYVVC3CHa9zkvF51XNIKtDQZbCkR0yzkivr6SbuAaRfVdZ
	re9BK/79dzOXnj5H1MHtLliT3jrBxe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770240851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HpECjgLDyQROSSuqqkM4/AP66DpIGAvnkeFoALvGbNg=;
	b=jV7dAsbmHYoDnaCfHbUJkPDTF8BxybGNjMGYXEO73dgLx+kSjXddSLVJIlzMD0j30cYn5X
	E8krLh5HZwgB/ZCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770240851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HpECjgLDyQROSSuqqkM4/AP66DpIGAvnkeFoALvGbNg=;
	b=rd1JcDkivGYAJX5jTLUdHvhNoNBnESnBxYOBd4TCFsPdlZSqPBrWPZCcXosVhjWTN64mpj
	N6esqOxI7L3PrwCKRtZLuCAblYVVC3CHa9zkvF51XNIKtDQZbCkR0yzkivr6SbuAaRfVdZ
	re9BK/79dzOXnj5H1MHtLliT3jrBxe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770240851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HpECjgLDyQROSSuqqkM4/AP66DpIGAvnkeFoALvGbNg=;
	b=jV7dAsbmHYoDnaCfHbUJkPDTF8BxybGNjMGYXEO73dgLx+kSjXddSLVJIlzMD0j30cYn5X
	E8krLh5HZwgB/ZCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A2A143EA63;
	Wed,  4 Feb 2026 21:34:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FY1YJ1O7g2kqagAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 04 Feb 2026 21:34:11 +0000
Message-ID: <82dafb42-ca29-4ea7-9c1f-114c10443237@suse.cz>
Date: Wed, 4 Feb 2026 22:34:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: zero-initialize slab object extensions to fix
 KMSAN
Content-Language: en-US
To: Osama Abdelkader <osama.abdelkader@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: syzbot+6e04171f00f33c0d62fb@syzkaller.appspotmail.com
References: <20260204195751.188219-1-osama.abdelkader@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260204195751.188219-1-osama.abdelkader@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xe8fyx6sra4piqd7twzrz4npxhywfhcj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A0BB014000D
X-HE-Tag: 1770240853-368
X-HE-Meta: U2FsdGVkX1+h1SZ69ro7VouJ5aayoXWVg2UWnT/fvsSuy3EyyLKq09XZs3F2jxo/r49u76wmpiGea1B50zFvhIYYnzkbDE9Px13DZ4YMO+eqQA4Tfat6j/vI0VPAkqR1RUEnI6S6U7c1ancWX/iRO6saTYsLLuS5+ywAGl5WVip4adGeIwFNi5dvzqkIEl73Hx/pA0rkc4Hk19xjiByGPB2dbVkkEEdWEm7AvlYyAaL7oSo6JF4ny+MCvf5w3+4mIwUZnG4lun3F4tuRnYIuM41+SRPtr9Dk74Qc4hZRp0tZb6aOgt887tZjs8+5ayrSDUfSXtY9/bDAzejB4Mgey74fHWnl/DQ4in8K3S+Y6IWFMkJ7wJYgw/CRf2dDqQ/SPCpXjeqzsKE9PYSTO61DTD1vO+mqgCzra6gp+lBC4JjVOhG1jkJHXUnIPiur3khxQczKljfdv+E383KbTlPUaWWM90yJooHL2KQFXdO21ycwRjC0k1UDC/1BHNkhFzTQGKtIVKyt36jkGy86rbk07rM+6TsC544WmqIFjg6AiN2sf4CHx6fVtg3c0lSk5dqFcBkTq7n0C30sLDyZPAGS4JL1pL3uo0Ko25gKDeJkGJPO7jFsygI1GLnFrBzxP6Y+dp8I5qQRLER+I6Q7IIsaBufSjS6gIJ2sbe5S3JR52caB8J7RVmMSZY4RqacYHsVC3bH8RzUAZ6NLFgFJkZW0NI4OVqTsFnaKeUMdah81qVwqXBq6l3sxoHjRZIZQ0ftVVjVUr0BslS0x/juEaf4Wy20HOS98VnaDCALIuIEYnYqGtOoIfWF+WAoX78kFOGWfTVzaKmLtV7z+37LZOLPtCfOyvYi/+K3T1iNVviiIqgEvQmncuXCBZK6WZCtQcpfutMHYquKuq8fjXQRhTcIbCTq0+FWIrBk7CsMsvjwyJoNLpBMjQl0kRk+NA/SEoIFoH3OLaGmbIs62RC1i+Rw
 buArG7Us
 8G70H8hwTilv8aBcKk5vysU0bCPvmJz2wPi7BdkGGp64E4GBBGHdB4nFzkbq4gznE1hLuI+o9Lbi0TZPcY7B0+Xzv5DUU1oZVivoqkWsnPjtiEZISYbwsB4k/aHuGf+52JTGhdbk5PpoDFfNL6bpRNSxJAjl11in77GDe4/UtoAF8BamuICcK2IjtE6m84839zLgS9euYkOGYIAnB2d0FUHws9OpV5PEHTKj9sAQ3S8W4VWJw8VzSU0xY7B7TiHP5/xa523ZeHYpfh+8Fo5fenzF03wMUH8qAMTiTODPqoX8RHnqx6ZPY3Xmb6W33t0XRfat6jRBmTeKsArqiNMcBfzF5RzaIqJ5N0nF1VLQfRnqQK6/9w+xLfEY8XMs1/hiKVBHZ981RikMnPqIAwPvUxMigwaZ6BMxMoziwjYd3uP+V55FkpVYOYqMY6ObMK77TCkjb1x/zz7kxk80Ukm9cLiFa7+nCFTpARtTNljt7BO4Z7tOlXQfz3DNxR0xK1droeYYJG2EcjKEC5s0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 20:57, Osama Abdelkader wrote:
> KMSAN reports uninitialized reads in __memcg_slab_free_hook
> when freeing sigqueue objects. Although kmalloc_nolock(__GFP_ZERO)
> and kcalloc_node normally zero memory, some allocation paths
> (fallbacks, early boot, reused slabs, or races) may leave objcg undefined.
> 
> Explicitly memset the obj_exts array after allocation to guarantee no
> uninitialized reads in __memcg_slab_free_hook and preserve correct memcg
> accounting.
> 
> Reported-by: syzbot+6e04171f00f33c0d62fb@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6e04171f00f33c0d62fb
> Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
> ---
>  mm/slub.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f77b7407c51b..e66d17ee7fa8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2123,7 +2123,17 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  		vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
>  				   slab_nid(slab));
>  	}
> -	if (!vec) {
> +	/*
> +	 * Explicitly zero the obj_exts array to ensure KMSAN recognizes it
> +	 * as initialized. Although kmalloc_nolock and kcalloc_node normally
> +	 * zero memory, KMSAN may not track this initialization in all cases,
> +	 * especially during early boot or with certain allocation paths.
> +	 * This explicit memset ensures KMSAN sees the initialization and
> +	 * prevents uninitialized value warnings when accessing objcg fields.
> +	 */

This explanation makes no sense to me. The kcalloc or kmalloc with
__GFP_ZERO above has just cleared the object, and this is just clearing it
again. It didn't happen sometimes in the past where KMSAN wouldn't track this.

The bug must have a different explanation, such as getting an invalid
pointer to kmem_cache_free(). Too bad it doesn't report any details about
the address.

> +	if (vec)
> +		memset(vec, 0, objects * sizeof(*vec));
> +	else {
>  		/*
>  		 * Try to mark vectors which failed to allocate.
>  		 * If this operation fails, there may be a racing process


