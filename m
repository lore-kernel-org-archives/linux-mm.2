Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 041D1CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 14:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B9A8E0007; Wed,  5 Nov 2025 09:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B6A8E0003; Wed,  5 Nov 2025 09:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3948E0007; Wed,  5 Nov 2025 09:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D55E8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4529B8D26
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:05:01 +0000 (UTC)
X-FDA: 84076724802.08.AD3FBFF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 709EB100017
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:04:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mwaBfK9q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5x4wrmEQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gG9BppFp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="TxG2x/Ch";
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762351499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObIHwLo4q/sN8twtSW+vc2ZozvwJfT2HzNmnwS+Wygg=;
	b=LHTz8tFtYsOh1L5wnD/+N05nbUi8Lxy0QOw9Yek51tckKqF1gNYJeUqBuD1GyXJznvhBNt
	MN0KgNNMW/7HHtf+28A53ZMYDjbtOyBLZb9RoiOnLc8hDP/S91CSaEL20F7Vhtzj/xkDK4
	DgkiMQIenFObK87duA/NGpqRDGD+j4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762351499; a=rsa-sha256;
	cv=none;
	b=J8qBg/VvW/gbt47Eozd3+cDf5o+OYNYY2YM7ZUN8vFfSfHWvZjlxF6jrOLhO9Jclas9Xac
	DPfdErF7gRZFAGLboL/URggtZ2mqW43CUt3dEqOBsPUjYtdnyt4s77X5LUDyr02AWGLWHU
	UzfTub80hRK1wW7Eu4b3CmFNaZBQtPg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mwaBfK9q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5x4wrmEQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gG9BppFp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="TxG2x/Ch";
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E7785211A9;
	Wed,  5 Nov 2025 14:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762351498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ObIHwLo4q/sN8twtSW+vc2ZozvwJfT2HzNmnwS+Wygg=;
	b=mwaBfK9q4KJUD4+xDLEv/Avzvg11MlFEEDvU/3mW6Tp92xKfgpWimolm0IlBswwtG/ibal
	8XSav+g5ch/Uy9mjilQ+1zwAZhfZufpVZMSk1kEEbDAl6q1RQIVEUWBEtCNsj0YTXwpdlA
	iYAK3Oal6h1P2aFlmV3fou6lYefjKV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762351498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ObIHwLo4q/sN8twtSW+vc2ZozvwJfT2HzNmnwS+Wygg=;
	b=5x4wrmEQe1zTSCOrQOzR6jiwukiPGwefynkPcdbCCEMPiYLU+Pdm6eCEkttOSIIDrSqfzY
	LtbR2SI/wBLimMDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762351495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ObIHwLo4q/sN8twtSW+vc2ZozvwJfT2HzNmnwS+Wygg=;
	b=gG9BppFprhCEcEdSuJpBptD+oBRebryZPhCIRSYT/F+MwIKDaq3HfzW+zyw0Una0MMG9jw
	GjlaOkkPXUfbVGtZ6dKmHVcHDxA+xFSrAm2cWUkyUblk11WS1x6Zxq9KyobZbEBmOGez4W
	C91kToyS+GuF3wLB+t00W5TCdzCFIdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762351495;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ObIHwLo4q/sN8twtSW+vc2ZozvwJfT2HzNmnwS+Wygg=;
	b=TxG2x/ChMut6poH3bRkP28pjwq5XZS11dyO7ot9qLxrwIdJUVy6pDHL6gY1A8wPEuMR96g
	INEIcuKzLImnIRCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA8F813699;
	Wed,  5 Nov 2025 14:04:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5FWhL4dZC2mkNAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 14:04:55 +0000
Message-ID: <59626bf3-033b-4b2f-99ea-7056ab1e4d74@suse.cz>
Date: Wed, 5 Nov 2025 15:04:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] mempool: add error injection support
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Eric Biggers <ebiggers@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-mm@kvack.org
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-3-hch@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <20251031093517.1603379-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: bdsd1ri31ysaymjp95n4eaz1ss8ym55u
X-Rspam-User: 
X-Rspamd-Queue-Id: 709EB100017
X-Rspamd-Server: rspam01
X-HE-Tag: 1762351499-442101
X-HE-Meta: U2FsdGVkX18lZSYzyfqDHgRLm+aZVs90KaGyOgmw92GXWDSCRPeX1mmT9t55AzuKmJJUxth4RiRKlT/DFN56SoHSM/IGCCqM0NK1+HBJMe+FWnt6T26/rGdefgM8IryshUwr6cAGU5nl+LOQ1TS8X6MqLgUldEtp4kZk/YhosXYUI5iPfysnxQORvsvDaUALTdGE+IKV5JxPYD4nWzEJYoqgVjALeK+QsolgKIU+zFLqfGDEF6mSRLTgEGiy3ucDxrLNWeQAcRIFsfwrJJ3aUlwjrV3UBfNTEcTech+F3QZzOoD5DOSXdpov6kDO9Qzs9BZ5q+avlRSfNXXR5kg/CqcbkmUooshVvEjwdwXy3Q8Hwa9ogYkocNaKxBfkuOPZabYKjWlGgkccydiCn6Z9cAkju+dXRP+Fraf/Q31xMCNHqfz6m8aBr4J8Y/JDskJzK+51osSsOk/jbM9rGPm4shRb4j3GXRjdZ5ZuzpDa7TmG8rMSm/EFaxvoBlSOmJLWQuoo0Rg8VZvlYW50hHEfIzjN2XG1ix7A8Z+NnhXhP+mEYCTXkzmpcZleL/lkP5VGyPQtPTOwsIJdTtQ9jJpY+Vl0t0ZqzkBt91PZOO6W4ZRRR4jrsvTDkMua//lLwI/s1P9/BKuVyiN5yJgDOazn8lxgSClEK0risRIHUkHsdEWBR+OOsWZPqWb43UCOyl2dMfZfbmgIuPwuuXRtUaIwbjVr0rAKGVEQg81Lo4QmF1xCm6owiFyiv3ayaF1BTTksBs1W29owhrCYrzK0e0KAVb+cMHkaGFddUYRbY7LXXyYX4sCsX84GjfAGttmkSWghDUJjBS91aBSf5qT+4Bc9pIcaWmJiV9LGsW2awtv1ppOeZ+yiO4Q3TAHWMG4ERUtFp9n84xastUIup4GmcG1pCXKIH3aCz7qdI/0YstXuStR6/NhY8zc07pyybdFzbaW8dpKHaS3whvk2+u2j82q
 P5z8VI4S
 JGdEqvFfS2+e8+1cL0ZSDTRuxZ5Qz21S0ZYbqFT5HrKtD6kRANd0BbUtETidvClfOlGdtyESnKhslMFDDZBROJeGViwLvv3B0H5/meosAkDYCIf0bhk0lkI88ZvNhHhN4l77UYsRWiX2HsknaZYpegxFiCNAoD1I884mLIr3Z5k2MfEDkecgDId5f32wQr1bm3AsQysdL6OO0SzbW8/GZEUquy/EI6/S5SVrnGDanx90bBpOpgCP2mcg33iEBNvGvjvMi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/31/25 10:34, Christoph Hellwig wrote:
> Add a call to should_fail_ex that forces mempool to actually allocate
> from the pool to stress the mempool implementation when enabled through
> debugfs.  By default should_fail{,_ex} prints a very verbose stack trace
> that clutters the kernel log, slows down execution and triggers the
> kernel bug detection in xfstests.  Pass FAULT_NOWARN and print a
> single-line message notating the caller instead so that full tests
> can be run with fault injection.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/mempool.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index d7c55a98c2be..15581179c8b9 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -9,7 +9,7 @@
>   *  started by Ingo Molnar, Copyright (C) 2001
>   *  debugging by David Rientjes, Copyright (C) 2015
>   */
> -
> +#include <linux/fault-inject.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/highmem.h>
> @@ -20,6 +20,15 @@
>  #include <linux/writeback.h>
>  #include "slab.h"
>  
> +static DECLARE_FAULT_ATTR(fail_mempool_alloc);
> +
> +static int __init mempool_faul_inject_init(void)
> +{
> +	return PTR_ERR_OR_ZERO(fault_create_debugfs_attr("fail_mempool_alloc",
> +			NULL, &fail_mempool_alloc));
> +}
> +late_initcall(mempool_faul_inject_init);
> +
>  #ifdef CONFIG_SLUB_DEBUG_ON
>  static void poison_error(mempool_t *pool, void *element, size_t size,
>  			 size_t byte)
> @@ -399,10 +408,15 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
>  	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
>  
>  repeat_alloc:
> -
> -	element = pool->alloc(gfp_temp, pool->pool_data);
> -	if (likely(element != NULL))
> -		return element;
> +	if (should_fail_ex(&fail_mempool_alloc, 1, FAULT_NOWARN)) {
> +		pr_info("forcing mempool usage for pool %pS\n",
> +				(void *)_RET_IP_);
> +		element = NULL;
> +	} else {
> +		element = pool->alloc(gfp_temp, pool->pool_data);
> +		if (likely(element != NULL))
> +			return element;
> +	}
>  
>  	spin_lock_irqsave(&pool->lock, flags);
>  	if (likely(pool->curr_nr)) {


