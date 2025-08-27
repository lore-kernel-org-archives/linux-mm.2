Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DFAAC8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64076B0179; Wed, 27 Aug 2025 04:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13C96B017D; Wed, 27 Aug 2025 04:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DCF06B017E; Wed, 27 Aug 2025 04:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1956B0179
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:44:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C1281DDEDD
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:44:43 +0000 (UTC)
X-FDA: 83821901646.26.62E9989
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9FEFA0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:44:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M2Dca+lI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GSHRmIkt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Peh39Cic;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k81fOD2T;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756284281; a=rsa-sha256;
	cv=none;
	b=ThkQXif27OZC/r6h2eEF4F9Qcrmuf+BsxubOwmVMRQnuxD2XO2MmOEBQwAsxpxKRIvX3UY
	rk17s0YuewBwyBSQtX7oQFYe6P5gAdse26L7Xjtq+IqWmVWuRCUz87awpcQegfNbLwxo9J
	pSEMLWpVF0NFJWcK4nFTpccxj8H6CFQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M2Dca+lI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GSHRmIkt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Peh39Cic;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k81fOD2T;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756284281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Q5j6AFZWwARZOOy7imtF/EMPTLJgAHTabuEfxuZBF4=;
	b=3Yti+R4JOVib+oQ1/ht5jtqDxtT4Qyba8BiobppDkvQ/wFm6lzYPbw4BPZLoIATcapAPgW
	kP24XLm1pHerlV2Q9h+5R1dG4SlgeqywZcAlyrtAO/5VX7OOB3zwx7eruVBSgZ77I99YeL
	ll5ZR0Gkb6XyGyKSqRAIkDlxwaK1+lQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D6314211FC;
	Wed, 27 Aug 2025 08:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756284279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Q5j6AFZWwARZOOy7imtF/EMPTLJgAHTabuEfxuZBF4=;
	b=M2Dca+lIFpaA5vdMz31OOHP5+5bH8OGG1n9LHvL2RR3fkF8A0egpx/jIdZW4C2I3cESNBf
	Ec3con+kb3833UEJRQ5GwIBiNQJaF9pRWIa0Kk5Ocl/zTTpXSeJeu2rRxaAAi+AH58dlrU
	A7I1mTlJy9DuTC4gKqGRzTohljij+qw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756284279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Q5j6AFZWwARZOOy7imtF/EMPTLJgAHTabuEfxuZBF4=;
	b=GSHRmIktm+0ftq72iTBDRT6IzC96wVzlEdGBPu/9JwhlZo+9MVZ7SESm9Cxm8WYmQZIrhF
	LovwM338pWlFhtDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756284277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Q5j6AFZWwARZOOy7imtF/EMPTLJgAHTabuEfxuZBF4=;
	b=Peh39Cicf1p5DJAbWBAiW86eZ8F2XgsO0vbGGVjKvAmm34QsyBvolaxoqWg8QemSls3RoY
	nlFzGj7hufot33cnS5yzAewfC3EkxgPbRlO0ooXd9NhZVrjHpHHes1y1+HWTQ/X12/l/1w
	t0HI2t97ZXDwwqQqo6c6TVTdSfzlUWc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756284277;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Q5j6AFZWwARZOOy7imtF/EMPTLJgAHTabuEfxuZBF4=;
	b=k81fOD2TPkU+KwpeGW/PladSs/ljaH86/DiftibgJnr1tLUcRaohHIoqa+baaxsiDRZ2U7
	EQBVLEdpYQZNUyBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD66A13310;
	Wed, 27 Aug 2025 08:44:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9rvsLXXFrmjHBQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:44:37 +0000
Message-ID: <36584aaa-7f9b-407b-ad10-64a6ae619235@suse.cz>
Date: Wed, 27 Aug 2025 10:44:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: slub: avoid wake up kswapd in set_track_prepare
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, yangshiguang1011@163.com,
 akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, glittao@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yangshiguang <yangshiguang@xiaomi.com>,
 stable@vger.kernel.org
References: <20250825121737.2535732-1-yangshiguang1011@163.com>
 <aKxZp_GgYVzp8Uvt@casper.infradead.org>
 <54d9e5ac-5a51-4901-9b13-4c248aada2d7@suse.cz> <aK6U61xNpJS0qs15@hyeyoo>
 <6be0c134-b5b0-4ff9-9d2a-4b68f22c3762@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <6be0c134-b5b0-4ff9-9d2a-4b68f22c3762@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9FEFA0006
X-Stat-Signature: ybkueb7wmm3jic4x4hpu4bs7ebtxmme1
X-Rspam-User: 
X-HE-Tag: 1756284280-251358
X-HE-Meta: U2FsdGVkX19IkXSbTx8Dng5zj9NUTCPOt2+LZ0ns02z9m+slcpzpMbloh2CfsyC71os9pAVAiHRG3/6/ZFJhozBqrrarLQcaYg0fM7D45gFC6ysE7Ly8wQf+2ygsm0lrxQNCxvitaV/pTq4kwAIB5iFUMjLdJrpH568UCjb0h4XK7ZmHpt+bzCdACBzXdFdNZQGu9xNygB1QyOmgWQ6DWUf8urh6rB+ltBG4OEexVzTjvS5KU6yrNBjTR7lKBRiEy+6ek7oQDZ6LU/OFKJm8w6shXgt4z+0SR7ifnfRp14aPr8YJzOeRes3/jX9xZWTvZr/iujaga0GQ1VV78j2wl1DvQwpOrf9nJ826tDVeSfnSw5PNV7ae04ghTMAaruXdwV5X7e6qjY0rFUMMegYEhEdh/q7GyE/a8te7rWtvp5t1MZA75DJIBjuQ16wI13NlXALZYbPcGvP77DFaPfvwoOG4eevzYwA92HG5VAQg38PzMMisb+zn7lISlyAYqTot0af/Kr6Yzjy6F9AKTJqCF0MYM3jR5vos1j+1yTxmVdre9B9CQ9DW5rvry4DJi171ljMaC9Yp9zpk8hfDPy9e9zp4eJtaVkjs9XVTIS+TPTjL+0Ap6u3YDvn31zGTuhSM9e7SVVmuJWrSukiVT6NN/cEy634yPWAJZSvsTEDqLxeeCF+QNpCpLpfx9yXO6ovl+Ugb3JFgI0aQ6MqPfQNYn250xfC1XJ/6NKpdWWwe9I0NdDF3s3fXXUgR6QljjjelWt9vYjlhyYFD/4On9BOIpmY/w7Av9W0DBvPuiZf1gzupycDtxVnYuzP3iwjegrQdvLTs4xImQ5bsx52iZS1vVdkzJ36BWsQq5efvIVfnHtl78BMOR2aoDXBaheKyqh8+2rva78OPNLHKeVNFLaDAmOJxMDIkUnxfMdG8kFvgM1pF55DKkGj6ImeaG3LuBprS95aLg23ZT1PyuUDWQas
 pvqC23Cp
 XjeUHBhemsHSoTHRLqLa05WB35BGWSWzXO/Y/mF69WBWJiXc26m9sZZyX5afEViG071NP2izMOXndkUB/Wwx1JEaTBt3byy9x8muN0cfh+KMW6UhFcLUxeyJg0IIdhR83k7RqUfHG4Vt/5KbhjPrZNlIGDqzj8PKDq3lZ4XTEhOi1pkWZw0LnYPyfkHC7KcIbHtDu7n4hRDMPYOD5NroERPaTEOKLKAGVloEQZkM89+3PdeLyAoLH58LPfcBAib3VyiJ8feR5BZzvr9O6zw3dV6qcC7GZIsTUbUVMbGQujse+1lTamPkh4KumFr3yXoJYW3GDEVfGceg+Fv/fj1Cx4uYb97pSWwl5ky18fuyfawxO1iFu0fzQMDg1eNsiFTV64HFa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/25 10:00, Vlastimil Babka wrote:
> On 8/27/25 07:17, Harry Yoo wrote:
>> On Mon, Aug 25, 2025 at 05:42:52PM +0200, Vlastimil Babka wrote:
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
>> To make it a little bit more verbose, this ^^ explanation can be added to the
>> changelog?
>> 
>>> But I think we should mask our also __GFP_NOFAIL and add __GFP_NOWARN?
>> 
>> That sounds good.
>> 
>>> (we should get some common helpers for these kinds of gfp flag manipulations
>>> already)
>> 
>> Any ideas for its name?
>> 
>> gfp_dont_try_too_hard(),
>> gfp_adjust_lightweight(),
>> gfp_adjust_mayfail(),
>> ...
>> 
>> I'm not good at naming :/
> 
> Looks like there's already gfp_nested_mask() for these purposes. I'm not
> sure if it should be allowing GFP_ATOMIC (thus __GFP_HIGH) as it does
> though. Seems to contradict the comment about not exhausing reserves. Wonder
> if that was raised during review...

Looks like I mentioned it but inconclusively.

https://lore.kernel.org/linux-xfs/1fb5b8f3-d8c7-4350-888a-ad8f4d54bc66@suse.cz/

Anyway that's orthogonal to using the helper here right now.

> The masking out of __GFP_DIRECT_RECLAIM is specific to the slab case so we
> don't need a helper for that (unless we find other users). It could be then
> e.g. gfp_nested_mask_noblock() ?
> 


