Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FD9CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2A26B037D; Wed, 27 Aug 2025 04:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9839B6B037E; Wed, 27 Aug 2025 04:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84AF66B037F; Wed, 27 Aug 2025 04:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC946B037D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:40:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15C3B59449
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:40:26 +0000 (UTC)
X-FDA: 83821890852.05.AF63728
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6159140015
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:40:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2DtpxI1t;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gJKtCpQW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2DtpxI1t;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gJKtCpQW;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756284023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/tOzaXU/v30nyaJclkRa9DTMfAcxqf3+f7uGHrzdOY=;
	b=4EWhR8Q7gj/P4Uh7N9/QfxcR9fBo8EONfYB6hYG5SjDrWDOd2V+XZOmvjd/7IzgNuQiIGu
	ycsUGSty29gOWnnLlpUOlOEhQ1i8mDdnVa66m5FrdwMeWbKrxePD/afCz1OMMl/wGjVrvC
	fCoqCSCp/+bIOas4NoazlPJwGEPWDXQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2DtpxI1t;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gJKtCpQW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2DtpxI1t;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gJKtCpQW;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756284023; a=rsa-sha256;
	cv=none;
	b=25zLplKfeAxZw+/EJPNij8CZnfWCA484pLrBI9wA6Flghx07cnkLwshokh++f88GA4BhJp
	9N6s1VgWwV5wj/uVkmEuXbzg0qL6C4M96LfbipSSpqUzYR1RXjZqb8dZiNfmKZQlyxSNMl
	u/W4Iwz/5VXqEh+2/8YcFd9NC6DjfuU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A809834241;
	Wed, 27 Aug 2025 08:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756284021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M/tOzaXU/v30nyaJclkRa9DTMfAcxqf3+f7uGHrzdOY=;
	b=2DtpxI1tNUP1aErxnD1LtBf1D+4YFDJD788uwNaFkQfNuuljvMGyzRZjJxgXj9YpuRsoxI
	9BZu/xdj6ou9K4r7yv3PHFaI1olIewBRhTK+oumwCNl0eomGbxfyfaeuZFs01PBoI82/pn
	cD3UK5yYxrOmk8sZ9oKkwaVd+PDDuZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756284021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M/tOzaXU/v30nyaJclkRa9DTMfAcxqf3+f7uGHrzdOY=;
	b=gJKtCpQWW9IlsSW0Cl8FuQd56yskrl1nGy2WyOdSjwPIWlZ1QrXJVrLjPYXMDefs7G5cNb
	C1NL7e75Y0/9PdCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756284021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M/tOzaXU/v30nyaJclkRa9DTMfAcxqf3+f7uGHrzdOY=;
	b=2DtpxI1tNUP1aErxnD1LtBf1D+4YFDJD788uwNaFkQfNuuljvMGyzRZjJxgXj9YpuRsoxI
	9BZu/xdj6ou9K4r7yv3PHFaI1olIewBRhTK+oumwCNl0eomGbxfyfaeuZFs01PBoI82/pn
	cD3UK5yYxrOmk8sZ9oKkwaVd+PDDuZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756284021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M/tOzaXU/v30nyaJclkRa9DTMfAcxqf3+f7uGHrzdOY=;
	b=gJKtCpQWW9IlsSW0Cl8FuQd56yskrl1nGy2WyOdSjwPIWlZ1QrXJVrLjPYXMDefs7G5cNb
	C1NL7e75Y0/9PdCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EBF713310;
	Wed, 27 Aug 2025 08:40:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Krt8InXErmhgBAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:40:21 +0000
Message-ID: <fc6f7372-efb4-48e3-b217-c8bec0065b97@suse.cz>
Date: Wed, 27 Aug 2025 10:40:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: slub: avoid wake up kswapd in set_track_prepare
Content-Language: en-US
To: yangshiguang <yangshiguang1011@163.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 glittao@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 yangshiguang <yangshiguang@xiaomi.com>, stable@vger.kernel.org
References: <20250825121737.2535732-1-yangshiguang1011@163.com>
 <aKxZp_GgYVzp8Uvt@casper.infradead.org>
 <54d9e5ac-5a51-4901-9b13-4c248aada2d7@suse.cz> <aK6U61xNpJS0qs15@hyeyoo>
 <6e1ab9d8.6595.198ea7d7a78.Coremail.yangshiguang1011@163.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <6e1ab9d8.6595.198ea7d7a78.Coremail.yangshiguang1011@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6159140015
X-Stat-Signature: bmugtj4id97fosrmi189qhw73quxzy49
X-Rspam-User: 
X-HE-Tag: 1756284023-935097
X-HE-Meta: U2FsdGVkX1+nVrcdlomucuSsMWeb7N9TcQODNakT2g9TC2acL+Tb1Tey+3GRx8v0vCoELUT8MfcvQuVYngcNYWEF73v8r+SEHvL7svv5pMdGkOjnVXNYXK3vQb9lKr/uxgONquSKEJcSKRGl40vKeRqL8aitqY6mK8MwX05QS/ZlHVyp1L53wD5jmd1gWa3uRMt5qRuKxxB2GKtYKWZUfvCv4mkZhfI4Ek3oLgew2o4L9WbChxKdrr5cKyFhg+naWEJfsb+x9QR/TnjUWFEqlwaHDnAS7adHlagpacnszjdVLfQSSGEmdAO2wRMu9ER+ANGKA1OCobQETUXmZgPyXZBO08/Hof57XRZyAT4ykoUe12ESE713yg5zRmq3VhYvSOpgDOjkr1tMfeMXoV/cNhl2jJT4KVjOWDhuUJ7OZCruicT70ELtSxrj1WXecPDnA2LSv+z2lkMJPbtwXM9UrVemcgKi4bgMYPHWrEk5CWFeHfanB4482LlhsOcjzFvp+YFSJnH9vEhPYmwy7j81xI65PpAKdOWaJBJwSAcaY+18xW6KdzoZJkLMnZo1AiKaXMLDNIgbkDl9ZbBhwqD0PZR62v/qVhviemcQJAdOrNgHwANv+4ikk57aRF2ggVzVORItpR9YnbR5ilz/1wvQJABLzeqpLhNdyuProJR/9nA/qo1uiWyVQ0yAMOlvKwlYSMb7hQt7wkY93WYmXGlEeIjqjp7I1Xc84dmp9qWvI8DA5jekvG8JQPwQhWXKYpPDjYoKWhY4nbW911mezJc54r/lOnFXZ85NjeoTPT4w80sVGqPcwBXbPL/4TA/C84MGVXaKpjsdQ+9VdqRk08Gv501dw0F2veWRc7qdxvI6POw5prynkmmMON69Jzk+LdHFiUKEKIduOWvPacFhsM6zRYTLD0x78qApvlVo9y3z8BicSJIcv8aQVZ47DfFSaG1kr5w+vtNpnmnhfI0lIIR
 RmDKmuHt
 V1ehnHkBqpoxq/mZHmo10zmozzqCND3tq+EFVU6FopvXv3gajvq8nDXz3lO0wcwK/+YAoaWmquzMPRewHQfeR4T0HYdq5Ug5IkJB1Ew2Rm6XzH8MYDqIeenSxDntbkw1mxAn0AJ0AMaBEPHmZ0Sp+xFJ5VuuDYi7n7CdT3VHNL5GEYuyfk8Dm/sr+1PF/5d0MY/SPREk23zFQ1Xc7XWxC4ffTw27+RglA7duXm1j8WagyBFlOWefmQrygixe560rY3V4bufgSr5uCvnKs3CreG5y+7jazbz+FbzgT6BCHQAamR7aHGERM75I9/ekJCH8fRLR2dPcNwItLg687eChc8OKVvDSthv0nogjZLMn9jPqMHBO9kVSZaljL7QffBb+B3betMbaDvOcFvLGDzhsCtra5UA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/25 09:45, yangshiguang wrote:
> 
> 
> 
> 
> At 2025-08-27 13:17:31, "Harry Yoo" <harry.yoo@oracle.com> wrote:
>>On Mon, Aug 25, 2025 at 05:42:52PM +0200, Vlastimil Babka wrote:
>>> On 8/25/25 14:40, Matthew Wilcox wrote:
>>> > On Mon, Aug 25, 2025 at 08:17:37PM +0800, yangshiguang1011@163.com wrote:
>>> >> Avoid deadlock caused by implicitly waking up kswapd by
>>> >> passing in allocation flags.
>>> > [...]
>>> >> +	/* Preemption is disabled in ___slab_alloc() */
>>> >> +	gfp_flags &= ~(__GFP_DIRECT_RECLAIM);
>>> > 
>>> > If you don't mean __GFP_KSWAPD_RECLAIM here, the explanation needs to
>>> > be better.
>>> 
>>> It was suggested by Harry here:
>>> https://lore.kernel.org/all/aKKhUoUkRNDkFYYb@harry
>>> 
>>> I think the comment is enough? Disabling preemption means we can't direct
>>> reclaim, but we can wake up kswapd. If the slab caller context is such that
>>> we can't, __GFP_KSWAPD_RECLAIM already won't be in the gfp_flags.
>>
>>To make it a little bit more verbose, this ^^ explanation can be added to the
> 
>>changelog?
> 
> 
> ok, will be easier to understand.
> 
>>
>>> But I think we should mask our also __GFP_NOFAIL and add __GFP_NOWARN?
>>
> 
>>That sounds good.>
>>> (we should get some common helpers for these kinds of gfp flag manipulations
>>> already)
>>
>>Any ideas for its name?
>>
>>gfp_dont_try_too_hard(),
>>gfp_adjust_lightweight(),
>>gfp_adjust_mayfail(),
>>...
>>
>>I'm not good at naming :/
> 
>>
> 
> How about this? 
> 
>         /* Preemption is disabled in ___slab_alloc() */
> -       gfp_flags &= ~(__GFP_DIRECT_RECLAIM);
> +       gfp_flags = (gfp_flags & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL)) |
> +                                       __GFP_NOWARN;

I'd suggest using gfp_nested_flags() and & ~(__GFP_DIRECT_RECLAIM);

>  >-- 
>>Cheers,
>>Harry / Hyeonggon


