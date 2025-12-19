Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAB7D711D6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C883F6B0089; Fri, 19 Dec 2025 03:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55B86B008A; Fri, 19 Dec 2025 03:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B593D6B008C; Fri, 19 Dec 2025 03:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A43DB6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:58:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4686B13B17D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:58:20 +0000 (UTC)
X-FDA: 84235619160.27.CD496B2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id C899A1C0003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:58:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xoL25HZr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="l7M/4HwT";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=24nDX0Cn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3O3PHp2U;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766134698; a=rsa-sha256;
	cv=none;
	b=j3+JCkTsqzEeeRz6Mmnc+b+kDzJOvn/EwGnekHl8EZoXguUNdr4eV/la8k1kF/cs0B34yo
	jumRnFDQpP9zvOUqU5HicSB8D2swLRgYbCO9qWjSOvRINmlpxn0QO1Tx6ZUeEq3b0Ngg24
	KTE2qUuF57ra0Ne2hDap+2zqogMHVQY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xoL25HZr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="l7M/4HwT";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=24nDX0Cn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3O3PHp2U;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766134698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDBgqGfKca3ogg0v+6j+xGsrvIXy52LogEFPEcyr+o0=;
	b=OqNPGlmjNqZzMmRifCCWqUMaXNK1yJzIPB7O1lM/cen1MUFWqGgC/nLovdik5XG36aqvJY
	rBUR+guzzDUq3MUpvUU4ZpMMEq7kRD6FyTxs3Lw949B0yDAXyQea+ai2E+1+ONVpoSGTpH
	3tpcBkhqdyzGojJJ+uAiETKtPjKeIxs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B1A245BD23;
	Fri, 19 Dec 2025 08:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766134695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VDBgqGfKca3ogg0v+6j+xGsrvIXy52LogEFPEcyr+o0=;
	b=xoL25HZrH4gu0dbZB4/ZQFksXT7QEILYnlUsYMzLTX/g8rYSjDAHu7AiUDIEDLIQd+8TL9
	KaysNbAXBRf6l/RTqqrJ6amW/zMop/98ZRsSU+5oDv6JbP9UDTbwUyNJg/rwTMTewxnIVM
	ThlYRw5C34Y+n5thDDd7cjE+350VXZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766134695;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VDBgqGfKca3ogg0v+6j+xGsrvIXy52LogEFPEcyr+o0=;
	b=l7M/4HwTMo7+CJ1sq1oMCnWy2lWHS4HTa8+EgLzPJO+PcUN/hdu7jTsybiCQHcoNJ4Ttas
	mj3Rdr18KO1jiZBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766134694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VDBgqGfKca3ogg0v+6j+xGsrvIXy52LogEFPEcyr+o0=;
	b=24nDX0CnfXiIJjyfF1cRHwOZWzeCM4IYWmEL6T838n9YqxB5F50WH0pcPZ9YwL8dHHNzHj
	bX+UppxQuMybY1aJw1l1F0rRFwkA70gJ7yubEvpj1jDu5o71qdEg4LtCCpIOmS7FKa5T2S
	88x+MDM6frZoC9pBD1L3E6RnkB8uc1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766134694;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VDBgqGfKca3ogg0v+6j+xGsrvIXy52LogEFPEcyr+o0=;
	b=3O3PHp2Udx9xN13roMhq4mlJtxXTujnsxIHYSVdRAr8Q5uZXfBpCFG9zeDRaBy0wZnD1A7
	O/j1uz/Rf/7fePAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 959123EA63;
	Fri, 19 Dec 2025 08:58:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P6UmJKYTRWmLfAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Dec 2025 08:58:14 +0000
Message-ID: <03ccf64a-55ab-40b6-b9cd-74565df4bf34@suse.cz>
Date: Fri, 19 Dec 2025 09:58:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_owner: fix memory leak in
 page_owner_stack_fops->release()
To: ranxiaokai627@163.com, akpm@linux-foundation.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 elver@google.com, andreyknvl@gmail.com, =osalvador@suse.de
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ran.xiaokai@zte.com.cn
References: <20251219074232.136482-1-ranxiaokai627@163.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251219074232.136482-1-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C899A1C0003
X-Rspamd-Server: rspam10
X-Stat-Signature: tttxpznd949jdiq1h98ydxg6mp34q9an
X-HE-Tag: 1766134697-87775
X-HE-Meta: U2FsdGVkX1/YlBc8vA8om3yMQ5sj9bnaTKKCZGJeaSf3st2alDie9pF2ggWK9a2oVp6CsQ6Y1+AVg6OrwlbO3VBp/YhAJUJ5ZzH0g1iBmty3bBiYa+MiZKNlDUQqqkd303wNV1mTLIGAXH+PHKv8Doa7FcAiCBd83a2q6j9iTDgh+phnnPiTYH7XB8WFEwUH3urZFatd5FyijCjw0hGqGE1TsJehGEpQmMsGxNlpEngnz/dCm956V70kyDcyx+PmCIerwpbRfEiJfn93x8wtY8bBZLZIlgrDOsTc9/3BjHA+r6EDQw5FLnXQCdJbWKyuvePrOlLpxN6UBEmFrYQWt637ugNfKRtBPU/TmCaLwYzH2iS0gOSqD33JJcCUvO1nbJc2YJi5109Hei2Xq2P5TTRWjh50elxqd0LELjQlAJJRQTfQxezwli3Wba4Y/79tvnTJHd2P+QWgRjKb41pgt3l5zWJqzMfO9XIFn+SvlF/9FVqCIFFH6lNVVAIp9CnvaazpzMajBaUxwmld7JpZX/AcAg41YLwmkRT7YtlBBkhiSuQD/2n08/PzrAXhFYUaVqEjaZ53+729NLmF4NHMhOVzJh3+LSHrpLRHt0ZTDXwjkcwr6hQngBlPF1MuhiyHpEhSfMtSnD1UQNm/jCmDVcPQ31A2XS0lXG9bHRyz28pGHWYUTc0o0jbUj0U+m7gzQM7BhyjQyCkOWHbeoQ4FPg4eSXeoGtUhUdxzv6MM6vRHYNse/KG++7cq2/0QTypINlyVEuL/T/2Xs1B1Avb83GamsA+a3MF5Fekqap68XvYQvs2oyxRr6KDTJervSojUhAqp/P7Aa6/YZ7dEVZn7lpaZbQ3SweUnqV+vkOh9554y4HCg74sQBw34Dnd8SkdgjL+AFNnthU+1M/jyqi7MeicaLhNnyYJKiZ5UYA6Em+pHOdWOBjvX+R3s0PsqBGMUpBygw8ZSV3VAqil2/Um
 b9dF38eM
 l/6H6eg7+5U8ME3IKnRmB+1iKp92FhuhnDh1hRBDkqLrFcAF9QEDVDUXczRLbXx+5EZMf4feKGtwdA5xKJgTYiuPORzOrJp9rZwp0ydNlfYWTobPQxmZ70C7+NMu6uZkb9FPv/1X+oW8yLYtgVFg5Fwb++1L5+9B2VdX4pRULVgpvqwbfQdkgKg+4Rk448kdsNijPLmkt8AUX/Zi4yH7dSnCKVOIk+TZu4ueV3Dm9ErsIjTMVLu4wa6d9sQlTTCdmM6J4c/ZBeG+0abAHPHHrkeA/iPl+HhRBn7oZ5vPkaflW/YFG6SG2ehdBfGzNCzsf6QoGY+2alf2AGpJyMBuxuk9I7Pw8FUDzzD1tbj27E9rhfIXrDyGtXIlVB+3pbiPkF3xYK+zeiti+ktgRcJJzMGqdXS5FqS+3hTwC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 08:42, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> The page_owner_stack_fops->open() callback invokes seq_open_private(),
> therefore its corresponding ->release() callback must call seq_release_private().
> Otherwise it will cause a memory leak of struct stack_print_ctx.
> 
> Fixes: 765973a098037 ("mm,page_owner: display all stacks and their count")

I think cc: stable is warranted, Andrew can add it if he agrees.

> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

> ---
>  mm/page_owner.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 27d19f01009c..b6a394a130ec 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -952,7 +952,7 @@ static const struct file_operations page_owner_stack_fops = {
>  	.open		= page_owner_stack_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
> -	.release	= seq_release,
> +	.release	= seq_release_private,
>  };
>  
>  static int page_owner_threshold_get(void *data, u64 *val)


