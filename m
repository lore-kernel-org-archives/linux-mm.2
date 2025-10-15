Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A93E0CCD196
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E76A8E0014; Wed, 15 Oct 2025 04:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097BE8E0002; Wed, 15 Oct 2025 04:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3448E0014; Wed, 15 Oct 2025 04:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFBED8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AC5811B32B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:24 +0000 (UTC)
X-FDA: 83999671728.01.08C4975
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id E36FC40008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pjlFy6pX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hK0+5+uH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pjlFy6pX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hK0+5+uH;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqzB9JK9+uCij0k20PiNt2gVw+L4NpHiOSzfoVgzyLg=;
	b=l2EOoLYsUiFnRqXeOKzuUCFB3FyQJsDZIgsoduhefWrKRkF5SU7hBwj6BxmSQCc6k0kpPe
	LKilajcBQFCabOpKdukZjVm+RR8m+oq0qY5FDRwvKOhX0dZRvNLL0ofLRet+73TIwqVgVu
	/QOK7Zyz2TC+AiwkXosZHgQQaoO3oMQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pjlFy6pX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hK0+5+uH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pjlFy6pX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hK0+5+uH;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516902; a=rsa-sha256;
	cv=none;
	b=hJCPGmqPLyMSxexbXkoayCL0RoeRJgP5YZJUbuqFkZf0oDpWniNTbokGwq3iBJ4mT0GcMj
	95oqvJOMGI8juxi/9h3KUkcq1fneMBmkiPvKtyq+Zk2sAXU39lVgmKHj6uBz2Ohz9zGFov
	tAXGKBDvc+y9ee8b/V0KPWZx/FmzsLc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EF38033853;
	Wed, 15 Oct 2025 08:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760516900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qqzB9JK9+uCij0k20PiNt2gVw+L4NpHiOSzfoVgzyLg=;
	b=pjlFy6pXzOkp3UeHPyDVqKWq9KsbuPMvTIb3bv7vOlOqeLyuV/sXYenidAZvrR4OSD8x+b
	EPnXyqq9UM2enEebsWDHZYLdU4VHA/dKVqiUuLxuZ59xoyueaUPfiGV3h7yRvmPEhFWnWc
	VKaGl9/NZUpyNgkUyYdEBnywiugsjH4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760516900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qqzB9JK9+uCij0k20PiNt2gVw+L4NpHiOSzfoVgzyLg=;
	b=hK0+5+uHgMQWFZQ68x2XXGlC6RvBH5phfiJzz4rdXIv4uOxA1NRVSPSUG9bDcnj5YhJrXs
	AuipeVS4RGN/izAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760516900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qqzB9JK9+uCij0k20PiNt2gVw+L4NpHiOSzfoVgzyLg=;
	b=pjlFy6pXzOkp3UeHPyDVqKWq9KsbuPMvTIb3bv7vOlOqeLyuV/sXYenidAZvrR4OSD8x+b
	EPnXyqq9UM2enEebsWDHZYLdU4VHA/dKVqiUuLxuZ59xoyueaUPfiGV3h7yRvmPEhFWnWc
	VKaGl9/NZUpyNgkUyYdEBnywiugsjH4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760516900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qqzB9JK9+uCij0k20PiNt2gVw+L4NpHiOSzfoVgzyLg=;
	b=hK0+5+uHgMQWFZQ68x2XXGlC6RvBH5phfiJzz4rdXIv4uOxA1NRVSPSUG9bDcnj5YhJrXs
	AuipeVS4RGN/izAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D135D13A29;
	Wed, 15 Oct 2025 08:28:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eSL4LiNb72j4cwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 15 Oct 2025 08:28:19 +0000
Message-ID: <86eb8759-426f-4460-8bde-1d88e70e266f@suse.cz>
Date: Wed, 15 Oct 2025 10:28:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mempool: clarify behavior of mempool_alloc_preallocated()
Content-Language: en-US
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de>
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
In-Reply-To: <20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E36FC40008
X-Stat-Signature: 7fxhceosjn5wx87rn9qh13w6amufumn7
X-Rspam-User: 
X-HE-Tag: 1760516901-813485
X-HE-Meta: U2FsdGVkX19Nt4P7N/N42Rb5lLqFgoDuOnockl6nKu0utgUbua5UmFkRHz1ydM/RHpz42+qynuxcRawLcZRbPPXEcwR3dwwC4zt+2EpL6VJe1HqB78YqlP3opTrIEFdTO5XXiG6GFp3mhfE6oohBRRK1QcltUfeJQ+d8Mb9L2TpLaFy77lpblczU1KqMLJ3WXArao107Wjaezqc4M3OreJkiwyGVyMZKLhEXHOjvBKpbC6EWYAR2jVdHEAoE85ttNfDBbDGPUw8/wXHEMX78Do7P0tw9M6dXVMuRjCTwJxPhPSLAQJ+sNQMtTyOOg7gm//kjeHXMFg042DN0HCwnLUcwXI5+lHzzwvm36oZYlFGmQSZuf4eerPinRUHiX0ZA04xByALT1NS8P86cPpcCbDfhoDFXVTBS5zCxlut2w7mFzsucfuuyncDiPhzAqmL6K62N4+fFvGcpnRJsUPGE5Geu2XQeQ24JriyIhpLGpp3sm5AdO0VbtjXSeozVDQvZBGMNyGh908AekUvK6n/9Cid11QOlfVaFhzHjOkuDHGleV/ddN9dl/0zbz0/o7ZmgWCRKWTJmLFUF1fGm3JKHzinaXWK0Wkt6pEneDSY9Fbs6+wPK0aQ/wqAcR2TupY8CQNBW9sYPvdjRENPBc48pSwqdW0QM0kCf8J/7zpp/pjPP8BFeYiPqc0xFxnl5SXoa/KYYOKSsgI9rsJ/FBPVI8KE0OXBh/tE6MFSnJ7BYND6myxmmCfnCuV+vnzr5H0809qbKZisYSLNzot7XsYFOwdesXGrDVIyMcU2Q3H9zwp4QUKM0xS5TOrPnNhSN1kpRdC/+aIogXUjczTnZ2awCsURiFHwI3njFAljDAAK2LR8PxlqvSrkQGug6/KVyOsTEOJcfkqWiNOj4DgCSfd0D5u0TlCSn8c/R3obqV7Rx8y3bVJMQUnOXyMYZJm/pqoWnJzldtnANrt2Bwiq1aSs
 EpL36HtQ
 InXvqBWqDgqz9gQbBZ/UA5PvlpKvJFCCMh7Oljnl3CQy288sOqAsoV4t/dlToSOlSDyF7OQrXbjRIBaLkvlu91TGzoKtUGLB7VGG4YzPB3mUNc4aqRbBlZjt+6/C/nJIj6Uhyo0LCgbxlcoI9JOY3zcj5/98QPKIPk4gZAoH3bEcjsEcBwtHYK86JiMgJOrDxs6AJ/ZwRgLwjeKXig2hJenAEpoO1VBmCzQC3/qM6FNMZJ2WRiDG52OdAaclmvqQmIGVoD7Cb4UEQ+5LhAfkbhduRL01IlCZFFjmJL8TsVRaFRNNe7f3mIgIPj/D1PJEoytPEjsPKw6Th7uW3nqlwzcWLgExTZuyIbe4I0D8tlD/p6l8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 14:17, Thomas Weißschuh wrote:
> The documentation of that function promises to never sleep.
> However on PREEMPT_RT a spinlock_t might in fact sleep.
> 
> Reword the documentation so users can predict its behavior better.
> 
> mempool could also replace spinlock_t with raw_spinlock_t which doesn't
> sleep even on PREEMPT_RT but that would take away the improved
> preemptibility of sleeping locks.
> 
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/mempool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 1c38e873e546fadcc594f041874eb42774e3df16..cceb09b75ebe35f263a5fb95ff6d400221ecbdd5 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -461,8 +461,8 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
>   *             mempool_create().
>   *
>   * This function is similar to mempool_alloc, but it only attempts allocating
> - * an element from the preallocated elements. It does not sleep and immediately
> - * returns if no preallocated elements are available.
> + * an element from the preallocated elements. It only takes a single spinlock_t
> + * and immediately returns if no preallocated elements are available.
>   *
>   * Return: pointer to the allocated element or %NULL if no elements are
>   * available.
> 
> ---
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> change-id: 20251014-mempool-doc-625dd4996110
> 
> Best regards,


