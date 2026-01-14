Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37652D37E2E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720266B00A1; Wed, 14 Jan 2026 08:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD126B00A2; Wed, 14 Jan 2026 08:14:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC276B00A4; Wed, 14 Jan 2026 08:14:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 46E3E6B00A1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:14:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F18E7B9B61
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:14:33 +0000 (UTC)
X-FDA: 84330613626.12.A5A9C3A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 46C25100010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:14:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0hhvUfpL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kg0VZ14t;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0hhvUfpL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kg0VZ14t;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768396471; a=rsa-sha256;
	cv=none;
	b=xr1Yvsb80uFa1CHY0VyNrbxwdtYFf7/q0vcQClwgXjHLypaxaTmCE8qaEMVSnJ0AQUJZIO
	CFxv96f7uTRtFSzlIf51SvJ4fDDtz5BR0rpzT41xzZqQuIrFw9DWLBRv1yr984DKWHvP8A
	DAdBwS2JS50jIE2pS00jsSsCAs/cDck=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0hhvUfpL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kg0VZ14t;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0hhvUfpL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kg0VZ14t;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768396471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FsTG5iVeM/SDmd5f2bL2EZ5iVc5vb5sMbUUarUjEyRY=;
	b=sCf1kF19huLEHy8eb8CeMtdKXDh48qg4a5mLDa0aTyE0EmiBV9YyvysCtubjvbRVcP0E8z
	Md8s3InJqVG4UGmwokXrTeE8hdLmJWtSBKGTSyhdX73mazEhARlJ/IWseDduH8tzRMQ3fo
	2gVSOsktLtWUTc0UkJ8oEIwz1ofSlBE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 55BD03402B;
	Wed, 14 Jan 2026 13:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768396469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FsTG5iVeM/SDmd5f2bL2EZ5iVc5vb5sMbUUarUjEyRY=;
	b=0hhvUfpLf9D05/9CTU6aSEENOoKkyCOCKWSVL6wFyaZe4cYREGkq6JaI7olAj3VUDtFhNV
	u4iksMIyM5bnn8ovN+sTZTifvJaaFmbBdefqlv6rGPghGeuFhj1nOahwF+IVQajNk16lmS
	p5guWt8XbwZwVBmYSaNxb7H0khjEylQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768396469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FsTG5iVeM/SDmd5f2bL2EZ5iVc5vb5sMbUUarUjEyRY=;
	b=kg0VZ14tKCBNG9hn1SQQ/+S1iZXh2JmVMyFUz1fTYA29aKuEPwJOkVm/vFhkBycmACbC3T
	qhR8Oz/QGjnfHcBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768396469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FsTG5iVeM/SDmd5f2bL2EZ5iVc5vb5sMbUUarUjEyRY=;
	b=0hhvUfpLf9D05/9CTU6aSEENOoKkyCOCKWSVL6wFyaZe4cYREGkq6JaI7olAj3VUDtFhNV
	u4iksMIyM5bnn8ovN+sTZTifvJaaFmbBdefqlv6rGPghGeuFhj1nOahwF+IVQajNk16lmS
	p5guWt8XbwZwVBmYSaNxb7H0khjEylQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768396469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FsTG5iVeM/SDmd5f2bL2EZ5iVc5vb5sMbUUarUjEyRY=;
	b=kg0VZ14tKCBNG9hn1SQQ/+S1iZXh2JmVMyFUz1fTYA29aKuEPwJOkVm/vFhkBycmACbC3T
	qhR8Oz/QGjnfHcBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27FCA3EA63;
	Wed, 14 Jan 2026 13:14:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8+l2CbWWZ2kDfQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 14 Jan 2026 13:14:29 +0000
Message-ID: <f5cc5a84-57fc-4fd4-aa74-fc89fdcbb042@suse.cz>
Date: Wed, 14 Jan 2026 14:14:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slab: fix kmalloc_nolock() context check for
 PREEMPT_RT
Content-Language: en-US
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>,
 "open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT"
 <linux-rt-devel@lists.linux.dev>, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com,
 syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
References: <20260113150639.48407-1-swarajgaikwad1925@gmail.com>
 <20260113180036.Zl8j3vIY@linutronix.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260113180036.Zl8j3vIY@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 9k4aezaw8ywn55bjo5aph6kheakjhkd1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46C25100010
X-HE-Tag: 1768396471-610848
X-HE-Meta: U2FsdGVkX19BjlEl4x8BS4za/6Wj4LkPSH/9w1brpe3xM1M2IRNn7A61cXUgnarT1tRRxf//0YqCb/CEHmTxmGDkzAmu5drrxR5qQvUvu2qIW57JgVN6b6kXgGn+t4ChNOBcC1mPCeoV7sSUApwgnUzdo53KD6yMRlx96yaXLsmJmMkXyHkgt48GdqfEI1wVv4w80NERApNqD/YwqHP2Ul4mcjiliBX3f6KbYbkye2aus9myNdEZAU7lmqvJYnrNHdBHVcrz2UOAKvslecg4bgGM6qsNqoigW6kudC18pgbo6jKJKhgXcDHXKEoKm7U+oj9T90rMscTzzFzf3AZiH9BIeBTOyVLdTkNtaonuDxvCHvGsr2p9wF0VKLgzccda71/h+9+AT/vtto9qy2g1sHJ3MMFR9bgZNXTn+9fSKnUzp3df1QyaRIRj78MlX3brNqO5QNKbIi+TA5vx5DoqVMToW0kSyauNNqTDbLEr911zMe2gHQzw4+pi3n8pjTexvsxo7XSWNiWoo3+I/cq9kY/jMVKxxcGECYOFKtB+pkXAp5fbe7JQhw2TEsknkGlSsPJe1rkiEkKAZmWUbwAwGV83smIwdmjoBfqchOJ7M7HG6OAB33bducq3URfOeUZoert49c471DRi5XRPYIFTmeNHjOeo9wDlIhFUaHL+eyqF6NNz3rImOgktSDG9wIfaYGX7DeNGBp2YLxyMgb7s/v0gcwLSOkTcKXT2Kj3JkQpGW3pIyzYPsR9HbgAu24vMJ9OUDP5QQ2qmUqKARSAZpK9c5nYX0VurBJwCX0i0dbQ7V0IeM/bfQ9NKl5uD6DUntUYCPZFJU8x65lllBX6dLFvwI47P0PsV21O27o1lrXtwehiFK//V5wmBRGGqbfHz2gGn7GK56zGM8JWsuxi3ptcw6Sq3nOnkxvmJ96kWimA/gBQAwP0x9t87lB6Ze4Xp3l5V1/xp38zT7Hf1xQs
 YJfe8ini
 XrB+ga6ucPm/xmMeJvcHcp0JQ2HISwkj2JxZxBRXSmFbkJ64gFa2PEqi/swLud7j7OJ0DES5M4ApanTWTIhVUjrK1+lyI3NilqBwdIF3OobwJE4p+C4vjii97uYKBPXZpVYI31HC6ymdfoO7tVLuiHJ2rxJqDYeUlc2RC+Y+/+tInD6xjWMpsrhv1O/kEZU/aVWXZU7j+DLtq4eQH2HQ+h5CeGkDndzjHywpMKnb0wWTBg/8RJWZr1Pp6ysoOsfCIKiwKQb24WTTDWc/NriD2LzD2qfUnu6+gxayoFiKNkKZZeU32KIDKJ8mb1zXhDGNctCu3v57sJsHwiLlmXAWjiNZrMSO9/3jZOV2+ocRA/B+IBb62t8rgo0ppfmSApj9b/BP8fq9CrlG6D6Us/fc4FEECPz5ntV6AxI9enr5ft0476d6aCMpQQzDhdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 19:00, Sebastian Andrzej Siewior wrote:
> 
> I would say that despite the _nolock() suffix a local_lock() is still
> acquired. The !PREEMPT_RT does a trylock.
> 
> As I noticed this myself today while looking at other patches, was the
> trylock removed on RT by accident, was it there only in an earlier
> version which was never merged and will it ever come back so we can go
> back to !nmi || !hardirq?

IIRC there was no version that would do always a trylock on RT (or maybe
there was some early one but run into trouble quickly?). The problem was
converting the slub code to deal with situations where initially trylock
suceeds in the given context, but then it's dropped and later needed again,
and failing that later trylock would be too complex to unwind. So instead we
do the local_lock_is_locked() check upfront and then trust that all nested
local_lock_cpu_slab()'s can't fail. And unfortunately this doesn't very play
well with RT semantics.

> 
>> +		 */
>>  		return NULL;
>>  retry:
>>  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
>> 
> 
> Sebastian


