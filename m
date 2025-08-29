Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5886ECA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 13:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E78C6B0007; Fri, 29 Aug 2025 09:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF316B0088; Fri, 29 Aug 2025 09:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686FE6B0089; Fri, 29 Aug 2025 09:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5475F6B0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:09:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E43D085613
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:09:03 +0000 (UTC)
X-FDA: 83829825366.01.0615649
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1BDFE40009
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:09:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dUPCVKSy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PmKTkB2U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dUPCVKSy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PmKTkB2U;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756472941; a=rsa-sha256;
	cv=none;
	b=VUjfd2OWbfe9NZOAGj2tomT42LaTqunwO2UnCBr+9sBmwUJ27+p8yV2F6J/aOCHQs49EX6
	cP7OsAw6lpU+CUAd248YpPoPa+Yw7G31kEsj/eoBZKfLkEt8CMqkKtHLyKDDAMGptdghdF
	DUFIgbDtO7rh2nVZyq2iDkfQHdON1jw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dUPCVKSy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PmKTkB2U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dUPCVKSy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PmKTkB2U;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756472941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=791NkJ4GQDv4mRfrc+N3Wc0IZX7qUnzbVa1JWAT9NdA=;
	b=cX3ie+zlvrAmURmvvyuaSOG/GWhCm2JMS5P2auR47c5qWs0Lq6noYLt3DZjg3oz5EG+VyN
	7YsyWVWcCOsGQZLC66glJnqNvfT0oCBE5yLgjFtj3o+HFQ+qFsgvPvyvcdlFIwBhS5snNj
	G3WttuCLSsnL8jobCiZnmGbcKerCymo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A7805C168;
	Fri, 29 Aug 2025 13:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756472939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=791NkJ4GQDv4mRfrc+N3Wc0IZX7qUnzbVa1JWAT9NdA=;
	b=dUPCVKSyuHl5iCk0KVUt9VwJRBL7S0tcv5JjPuiE1AD+OE1I4nrXiUVngyx2LjJfX0PZEU
	80RfKupU53P6wWmp9EkrM7vXqJ+qGl9+Rq79pamqLqNHDiWHqzaKFYhutO8LcZmKrjmzpF
	lcLxdI/r/UUe/+Va4N7WgmvqbuhN4b0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756472939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=791NkJ4GQDv4mRfrc+N3Wc0IZX7qUnzbVa1JWAT9NdA=;
	b=PmKTkB2UEsLZRa78gTpbp8+liHHmcOmf9Y9ZLHkdCq7hEt4j1cEMZ2+CtVGVRq0H1+iD2y
	wZVj6TxUj+UBL6BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756472939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=791NkJ4GQDv4mRfrc+N3Wc0IZX7qUnzbVa1JWAT9NdA=;
	b=dUPCVKSyuHl5iCk0KVUt9VwJRBL7S0tcv5JjPuiE1AD+OE1I4nrXiUVngyx2LjJfX0PZEU
	80RfKupU53P6wWmp9EkrM7vXqJ+qGl9+Rq79pamqLqNHDiWHqzaKFYhutO8LcZmKrjmzpF
	lcLxdI/r/UUe/+Va4N7WgmvqbuhN4b0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756472939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=791NkJ4GQDv4mRfrc+N3Wc0IZX7qUnzbVa1JWAT9NdA=;
	b=PmKTkB2UEsLZRa78gTpbp8+liHHmcOmf9Y9ZLHkdCq7hEt4j1cEMZ2+CtVGVRq0H1+iD2y
	wZVj6TxUj+UBL6BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32E5B13326;
	Fri, 29 Aug 2025 13:08:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ozVSC2umsWj7eAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 29 Aug 2025 13:08:59 +0000
Message-ID: <9dbd300c-240b-477f-ba03-8a17c7c2b84b@suse.cz>
Date: Fri, 29 Aug 2025 15:08:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: slub: avoid wake up kswapd in set_track_prepare
To: yangshiguang <yangshiguang1011@163.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Matthew Wilcox <willy@infradead.org>,
 akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, glittao@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yangshiguang <yangshiguang@xiaomi.com>,
 stable@vger.kernel.org
References: <20250825121737.2535732-1-yangshiguang1011@163.com>
 <aKxZp_GgYVzp8Uvt@casper.infradead.org>
 <54d9e5ac-5a51-4901-9b13-4c248aada2d7@suse.cz> <aK6U61xNpJS0qs15@hyeyoo>
 <6e1ab9d8.6595.198ea7d7a78.Coremail.yangshiguang1011@163.com>
 <fc6f7372-efb4-48e3-b217-c8bec0065b97@suse.cz>
 <4d271e7e.6bea.198f596bd15.Coremail.yangshiguang1011@163.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <4d271e7e.6bea.198f596bd15.Coremail.yangshiguang1011@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1BDFE40009
X-Stat-Signature: y9jkjx788xqd8ptcfmiswoc6czpt5u3t
X-Rspam-User: 
X-HE-Tag: 1756472940-532232
X-HE-Meta: U2FsdGVkX19Usq8PzbWg/KeKHvbpUa8cZmMxNCZBmBMswiOCgW+6kPlJkQDnSV2Vpi/Y2YuPttl9JU4sbh/Eni0HiUB9OUHYQm18D40XxkjkuD0ybwrQ0PySg/0im8XFLIBoIGLrncLirmt/uNNMrSNYzYHxcCCxIkAP1HOojbj3OaBlrgGGNMFY9js9QxDXOJsB8E1NEYhkgNgyErwDkn03oiy0nQTgAVtmkf/g3pLREGfmK05snZJ4IhcT8PrScg0bc+eOCvkFU+8EQCi2EHbSFmYDfu5R/p9jYJiqz+Vh5kQxZRxlsDQS0BtXFm6g6zMX5HN0nmv7DX61thxkYotP3GeqpUzqwUt+c12dQ6NHdFTvXSMBXK68aNeAAq+xAM1xxTkzkXsw4iVRHdH33ZtUNC9quVwW+CVOfEkLTGQQdgLBUg20rjeJ1zKeiZJsvO28A/NESVsbYVI0jcGUsv463V1Ys4ZfKEWAgLAaZVU3n/8w0t2/RPnSKMiWzzz7Dj99wUpZRaI2Bit/gujRGyTqJ2Hc7VZ/p24qiwT/cpTyMBlAfepKUoj5979hBzhCA9uOufxwkmpOhqIEnwD324ioaSh3dovJXmjqKhAD/VNCd5YuPGDtNI6Ot2/3c6OccUTx/+JZx2E5PC12IRvIrMrjxJHSrgHFbzTcQpAZgVuFt4FsifTvovHGHjvkMmZiOruJZGM5H0IW/m/R+Dy5OPN+mBVE4cUXHLWUwxoQrc1qmj6MSg2C+rF08K4ndcMSPkCnkzasxRtHZCzDBmXTHnbw/NeUrkf0QU0d1va5kW7hw9w5oqOQN4AMSg/SEMoXKiySNUQ3QJL6M0TjhHKyvUjBEUV09emnkD+YNfDXRsH3jLDhZ7uE+3Xj3BiQ5O0SYv5Xb0jdoK+Hiq/A8KopiCWJwD8USWrcA4nve0g5TmuqlUNbXBKzweWH/PYgFXusZfvQVNZ6A1xodUkWjiV
 pBJxCE3N
 keO/p3upFX7Dy25LA9AnWGc9zYviteVGI5oCYapnp2UYkEpu9eknDFGJQ6JUiRfB2njggLMV40AO85gC9i/co0V6Ux99gKNmqnNxNw0pjYCOC7GTSbsLTGGd/vAVoJDe3sJfUvyXcRHADDNR+6pqS2hvjr5uYGwkjHSNTa/ghP302qmODt34rp4qycnufdZ31RGpfa6d0RFq++BOJ0ppVrTKRctiEJ0ssbNcIwfNB1J+ghZmMftPfMTI0hCs3ByamRn7lMUq/+wYHSy1h7xgoFTZ4mVuGVAerxT94uVA7yDEZ+FjoUg3rBaHpjml482cxpCF+or8VdbRFKCE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/25 13:29, yangshiguang wrote:
> At 2025-08-27 16:40:21, "Vlastimil Babka" <vbabka@suse.cz> wrote:
> 
>>> 
>>>>
>>> 
>>> How about this? 
>>> 
>>>         /* Preemption is disabled in ___slab_alloc() */
>>> -       gfp_flags &= ~(__GFP_DIRECT_RECLAIM);
>>> +       gfp_flags = (gfp_flags & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL)) |
>>> +                                       __GFP_NOWARN;
>>
>>I'd suggest using gfp_nested_flags() and & ~(__GFP_DIRECT_RECLAIM);
>>
> 
> However, gfp has been processed by gfp_nested_mask() in
> stack_depot_save_flags().

Aha, didn't notice. Good to know!

> Still need to call here?

No then we can indeed just mask out __GFP_DIRECT_RECLAIM.

Maybe the comment could say something like:

/*
 * Preemption is disabled in ___slab_alloc() so we need to disallow
 * blocking. The flags are further adjusted by gfp_nested_mask() in
 * stack_depot itself.
 */
> set_track_prepare()
> ->stack_depot_save_flags()
> 
>>>  >-- 
>>>>Cheers,
>>>>Harry / Hyeonggon


