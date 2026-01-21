Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0222C44503
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 10:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6529C6B0088; Wed, 21 Jan 2026 05:54:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC7E6B0089; Wed, 21 Jan 2026 05:54:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1596B008A; Wed, 21 Jan 2026 05:54:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFDE6B0088
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:54:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC1671A0B15
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:54:24 +0000 (UTC)
X-FDA: 84355662048.19.B0B09A8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7AA8540006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:54:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oCs9L39d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L9l+ViOu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oCs9L39d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L9l+ViOu;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768992862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lL5k0cEGVYqwhOMRXHItIyxfFAmPKDrcwpZ8VQ9GNw=;
	b=OnrlOtvph6/jyrkOSB3B/0sdOMDHv7uxIg/g++XgRxgjBOdfYdTFgt/U+d2fcn+ZgD9U/R
	Kph1UmqvHPGFnDlggFSgU2VNdwZ1vf0idlWTS71TayFnlmLHHlgEA/i3s9i7JgMypuid7y
	sYo1wzRP7vncP5/HEEKkT0oG9ZoBIfQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oCs9L39d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L9l+ViOu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oCs9L39d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L9l+ViOu;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768992862; a=rsa-sha256;
	cv=none;
	b=aIfiQuXKjZ2uOdmaIeZvH7YwM7USoATOP/We/F5TBOxKi3QagCRx1rE8SMoQdI0lnJGvSr
	NbJFz2Y+jQt6YjdCDvacnIBLa/Ehx38pXL0D/oW6X86yAYvMw9093i6hrVe8HK86aksUry
	pu7T0+cnL2Lgqt/LZBp9OR+Doc3gYjQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C7EE3368B;
	Wed, 21 Jan 2026 10:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768992861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7lL5k0cEGVYqwhOMRXHItIyxfFAmPKDrcwpZ8VQ9GNw=;
	b=oCs9L39dsGYnQyyexypRLA0+wqAaV30/WneXrn2mDXxuJ5zhDCigqkGW8ymJjM2pNyhYSW
	LsAaLsa/f32ttaT4JaBYIWPwi6UDefdTa1I5FkXKCQ6R7s4asazOpXA19to+CWl2y1g1wG
	nq9tFh7JtCRiYL8AsERmFZsIgMrkcFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768992861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7lL5k0cEGVYqwhOMRXHItIyxfFAmPKDrcwpZ8VQ9GNw=;
	b=L9l+ViOuRsVosZqE0MgwCDb430QK6FYkeRSTcw8UYNTSc73YdY0MCDXr5VW/+W6tmIf4Hr
	gVpq6qPkWXpfDiAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768992861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7lL5k0cEGVYqwhOMRXHItIyxfFAmPKDrcwpZ8VQ9GNw=;
	b=oCs9L39dsGYnQyyexypRLA0+wqAaV30/WneXrn2mDXxuJ5zhDCigqkGW8ymJjM2pNyhYSW
	LsAaLsa/f32ttaT4JaBYIWPwi6UDefdTa1I5FkXKCQ6R7s4asazOpXA19to+CWl2y1g1wG
	nq9tFh7JtCRiYL8AsERmFZsIgMrkcFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768992861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7lL5k0cEGVYqwhOMRXHItIyxfFAmPKDrcwpZ8VQ9GNw=;
	b=L9l+ViOuRsVosZqE0MgwCDb430QK6FYkeRSTcw8UYNTSc73YdY0MCDXr5VW/+W6tmIf4Hr
	gVpq6qPkWXpfDiAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D05143EA63;
	Wed, 21 Jan 2026 10:54:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id idjLMVywcGn4EwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 10:54:20 +0000
Message-ID: <83f2ee6e-f767-40da-8cf4-08c6c185b92b@suse.cz>
Date: Wed, 21 Jan 2026 11:54:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/21] slab: introduce percpu sheaves bootstrap
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-6-5595cb000772@suse.cz>
 <7rzlxxqawgasthkhlk2fccync42blr3mehtfbylcsihy7kr5m5@m2bzma4qifo7>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <7rzlxxqawgasthkhlk2fccync42blr3mehtfbylcsihy7kr5m5@m2bzma4qifo7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7AA8540006
X-Rspam-User: 
X-Stat-Signature: d959b9pr7wyzy7czzwcpmkza5d5yfo6m
X-Rspamd-Server: rspam08
X-HE-Tag: 1768992862-26490
X-HE-Meta: U2FsdGVkX1+q1ueXmorooOLvvKMNXj4WZxsNk5KEv5yMytU4Kr4WvG4D6PiG9AeLAO/3CXr4qW5PG6TBF7uf99jOo4Hur4bQ9D3IridFnele6bDODvXgqKEsN/Lb6mz/hgYRKscWzJKmMuuYnTQJOMD9XecQYXqt/MMrnxc4nly4NVvBhU8iXbnEK9Z6HGkQhFM1T5+STajsMBkiJmlDg37JUfeGyxsjz4oaZtSLLtcvLwTj14NiO99GUk52Os+2IOejwJde8ozMWKwe7aeB1kOWWzyw43KIDr/BmOMVbWw5oP8ouA28QYYwSCTJ8q2uamFpQ8VFil0TBDZYlFpm7bzKpskS2Kj2Mq4Wh00/mcxdBLW8cXHVde+YDiPpu3b/KH7OhR6pP2sNiQ0tSuc8xFaAQA15w1Ft4iHbnYpe0oDRdFZ0Ng9CpZzRI/AGIUSTS4wtq6/RFt+l/yuxZ3cuSq8o0rxubGRcX9DfMdGZDL9jS2ubnUB8zULxVVx+0Me9jXVVEQZhffduOFJ/SMZ0dybF6ytUFB4wNvTKYL99vMVGSAJXiOZq/xbze26JIFlYNFf9se7Ci7tOHBhMic12goTdTu8V1/waZ7QJFMZWpp9Kp7Zw+ZuaNMPSKSHfa7riRaaPbzVXYaVP5+jcTBT/ay9CfjEA3pyy3nMZhTIQxhEWAKLml6jF30aOrVGQ9BHtd8hpSaCb/Q8aHJIN3SxfFfuDf3aBflVuS9AtGKu43L/4cSSl5UzCqdsRA9aaVGXH7eVPmc42J//tIG1tFPW2oHh/EzbMkulXeIcWRSfVSuehFRoSf0Phq2/nnwyGyt7raqqSHW2XfbuXu3KkclS0WWcsCJ8Le8CnkEn3KXQmjpYBdknb84UzeKMnorkmQKWzkVoscMhhD3XyRaje1V89T6vrxNNyG1V/Df/kjF5ePDXimKcx1MEKpIhS6XC4/Tzvt2aSF0bw5LFy+ICTBVP
 nDW7/lV6
 W9VP72k6DUkCZrInVREUf9igW9EZSUuafu4ANVjZ2iA0z57zYqcWwQTLuLFYJbH1tGBhXJWCwnvBr4kXyfl4MJRSthlRluMuIazplZq8KyAYO3fzF5IkMfePrMnN0DyU/qQ+rfSsaJ6uYsbLvFZeQaQrRPGAgc3zH5Iec8RpTXItM7RlO17U/7aPcl6knr7jpg3iNkSct01+jU5LAECRP9zNBC9KbBfl+kG9Ro9zbDcr/34fnuGIkSB0U3YaKc5NQXcx0/d8tsIJQOudTDZXR4Rff9EGHdEFPPAk3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 12:32, Hao Li wrote:
> On Fri, Jan 16, 2026 at 03:40:26PM +0100, Vlastimil Babka wrote:
>> Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
>> sheaves enabled. Since we want to enable them for almost all caches,
>> it's suboptimal to test the pointer in the fast paths, so instead
>> allocate it for all caches in do_kmem_cache_create(). Instead of testing
>> the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
>> kmem_cache->sheaf_capacity for being 0, where needed, using a new
>> cache_has_sheaves() helper.
>> 
>> However, for the fast paths sake we also assume that the main sheaf
>> always exists (pcs->main is !NULL), and during bootstrap we cannot
>> allocate sheaves yet.
>> 
>> Solve this by introducing a single static bootstrap_sheaf that's
>> assigned as pcs->main during bootstrap. It has a size of 0, so during
>> allocations, the fast path will find it's empty. Since the size of 0
>> matches sheaf_capacity of 0, the freeing fast paths will find it's
>> "full". In the slow path handlers, we use cache_has_sheaves() to
>> recognize that the cache doesn't (yet) have real sheaves, and fall back.
>> Thus sharing the single bootstrap sheaf like this for multiple caches
>> and cpus is safe.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slub.c | 119 ++++++++++++++++++++++++++++++++++++++++++--------------------
>>  1 file changed, 81 insertions(+), 38 deletions(-)
>> 
> 
> Nit: would it make sense to also update "if (s->cpu_sheaves)" to
> cache_has_sheaves() in kvfree_rcu_barrier_on_cache(), for consistency?

Ack, will do. Thanks.



