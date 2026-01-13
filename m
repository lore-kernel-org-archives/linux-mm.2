Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79C2FD2D101
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 13:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCFE86B008A; Tue, 13 Jan 2026 08:45:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84126B008C; Tue, 13 Jan 2026 08:45:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0406B0092; Tue, 13 Jan 2026 08:45:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8EEC6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:45:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84DF71ACA2D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:45:16 +0000 (UTC)
X-FDA: 84327062232.17.8B3CDB6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A845160013
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:45:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uAvFxvgs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="SJ7zE/WJ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uAvFxvgs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="SJ7zE/WJ";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768311914; a=rsa-sha256;
	cv=none;
	b=n3TNLNp/drRP71yfToRBw1AlNtbQ7BeRbzZiuh9bbtPhWuCztWX9BPAhgkzok5BY+Khq2Z
	8tVQgpU0UJ5ccSagFeWsyKV8TLxQ2fk64rpIH3ZcV9ZHVfjmV1UBiHJzPZ6ztl61Egg9tJ
	WjnxJJLFofNZvKTNkOIK3M4xbg/9Lkg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uAvFxvgs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="SJ7zE/WJ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uAvFxvgs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="SJ7zE/WJ";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768311914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2moOxEzMFuu+KRWMPMMWRhe7dQoy5+0s8Uh3fikrpPE=;
	b=yzZenzBSz/q/2i60uvYFLoPZkYlHSY0azBUflRF0dS79kxe1KNuDLr5W6abu/Ms0rtajiC
	PWN2CZ4NChUWkLskUhZIiuRQHy5MJNTBJLLLwGfxF4X/5zhg2/nDXMJM40ywzVitJCbwOi
	SYAhEUwoH3A4hVGgo8TYXHDG7tgTg6w=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 48A5C33681;
	Tue, 13 Jan 2026 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768311912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2moOxEzMFuu+KRWMPMMWRhe7dQoy5+0s8Uh3fikrpPE=;
	b=uAvFxvgs2uxtphOPUupeAOP2zAzthTFZ3bhDPqYoXPkRCo3ssunlOclzEXYQP6RYCuH0pK
	+YRHVE22wH2Pt8KqdMoaAQaMs937hNe0TxKcpG4IFcfN52Eh9jlwLnz1/ejYnBm7DQE/zA
	xoyKnj03/g4CqpJkEpgmTaU02fs+wXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768311912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2moOxEzMFuu+KRWMPMMWRhe7dQoy5+0s8Uh3fikrpPE=;
	b=SJ7zE/WJfcRQAyYaDpUYOQ9dLqr3QPhIMxAAJEVQz8oIsOdF7gegY+fIl7d4wVCx768FqD
	rpzJ7iaPLtYlR2Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768311912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2moOxEzMFuu+KRWMPMMWRhe7dQoy5+0s8Uh3fikrpPE=;
	b=uAvFxvgs2uxtphOPUupeAOP2zAzthTFZ3bhDPqYoXPkRCo3ssunlOclzEXYQP6RYCuH0pK
	+YRHVE22wH2Pt8KqdMoaAQaMs937hNe0TxKcpG4IFcfN52Eh9jlwLnz1/ejYnBm7DQE/zA
	xoyKnj03/g4CqpJkEpgmTaU02fs+wXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768311912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2moOxEzMFuu+KRWMPMMWRhe7dQoy5+0s8Uh3fikrpPE=;
	b=SJ7zE/WJfcRQAyYaDpUYOQ9dLqr3QPhIMxAAJEVQz8oIsOdF7gegY+fIl7d4wVCx768FqD
	rpzJ7iaPLtYlR2Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 241023EA63;
	Tue, 13 Jan 2026 13:45:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mOeSCGhMZmm0IgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jan 2026 13:45:12 +0000
Message-ID: <26d09b99-98fd-461e-bbdd-138fb37948e4@suse.cz>
Date: Tue, 13 Jan 2026 14:45:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 8/9] mm/slab: move [__]ksize and slab_ksize() to
 mm/slub.c
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, cl@gentwo.org,
 dvyukov@google.com, glider@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
 rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, vincenzo.frascino@arm.com,
 yeoreum.yun@arm.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, hao.li@linux.dev
References: <20260113061845.159790-1-harry.yoo@oracle.com>
 <20260113061845.159790-9-harry.yoo@oracle.com>
 <2cdff2ed-a45d-47e9-94ef-f8ecd178bbae@suse.cz> <aWZDDfq72XP3Uuef@hyeyoo>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <aWZDDfq72XP3Uuef@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A845160013
X-Stat-Signature: 4chmmh6t5jrawmaca9cxctgq67egou3h
X-Rspam-User: 
X-HE-Tag: 1768311913-749643
X-HE-Meta: U2FsdGVkX19CRN2CxY5jIvFyNvpr2vQS1B5WX6kzbYQ9ZQn4Me0Usuo46F4xopUaUKHWlF4f0GRqZTkGY3bG3c20IozyM6dOfa/qWdBIDb4keiRYXZC+gisIP9myQRdn5z2xzlOaLKSz7y9jYVAVSV5IfB4TKdHiXPMhM7IlgqXXv9jqxdw2YM2oGv7WqqzYJ/6WeFfwYaQgkyQJtNYg0OcM3tTArOHhhTBRcd31GjSOBeblndWeJrvjVWvEvzgmef1j00QtVOCrCKo4Zg8N1QEt47rmrOsUqWBBb8KDL1F4aHPUOxY7nTivdRjbOvVqrMV17jr5UAydus76SSkXTIPocJbiy3FE5qGyLdE76CmTBB2KvccOJep1r9VmakNI9p0ET56RNAHUHXWnNRm82YhKhuTAHio3b6wMfw5PmN7RRLiOQ0mBpM/gHvGHhuDYWb38Apn+AOfdS48cnGVKq6z5nqFv9jvyB7nQTXKiH1BtTiao2Md/sYZCE8gmK0uqDf1ks3JENrOGVYesqINAB7Lr2XX0nU5+U1oqgMGT2NYM4FDqGZQ7uj4h86SGKhcrPcXnYuFCu6QrdYaNQC5pv0RkhmsKFEAcdkFUa07rN8WLyHImEmfFahpBoDmIKYILOWxHQmUq/f6ZYK97te5+Kgt9g+Tp1fOFFTso8E/bWXxiPT4PmWe49q68nfI/Du5AW0UWSnpFE9f7khx+UYcGcSfySvza0ldFzlKk2q39gCAfr6F/bMuO159BDFl6HiqyTSRV1VRRVKGkZEFbj45rWb1m1rsas+lqRve4i4YsBguevt6Idi1oV2nZROezMMyc9/mT3VFR4Op2MHZDyvq4lPal4aePq+fCeiatMnwWP1vegbLlCIBZlwDFN+d2Aom9q9JU+mS8yxzS1aBU+dClRM5cKulfhJYz/88c0Vi16AfGmVHZUfncCGgzw5NyIBpG43TYr/7suKJIu6NdbXj
 J9EVX2Vo
 xdkgGR024amxJ9XuA6gxJJNDvq+donYe0Mlwn4vMrH9W+n80BzNmAx1/ejjOQdiHFj25ARaK+gc34y0MrgIAjZbrARCV9dd6Vp+GtP0Vtnf/A/st07ALgz+SLONXxOuwTlf24hq/MKLZ0Zm7gpGlHrsh6qsFm4JLtCH3vuf6Lke0n0d0l3reyXTlmDHleHwkn1QIfvoM5+JnwlpD5dcm4QwEU4QvDePNLIPWL7AOPkHzsNdXlMJOJFelN5sR9Q3BbzWPkvaeVPM0TLYQnUL56Nnwo3aVjrOQPqgjdMAKimUbMUoQB1DE9IYyGt1edPRBACA74d9bvueUMd1wEDmNE2GMywTajeKogUWXnnZUUVxgbPyXuViqUqqS6MQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 2:05 PM, Harry Yoo wrote:
> On Tue, Jan 13, 2026 at 01:44:45PM +0100, Vlastimil Babka wrote:
>>>  
>>> -/**
>>> - * __ksize -- Report full size of underlying allocation
>>> - * @object: pointer to the object
>>> - *
>>> - * This should only be used internally to query the true size of allocations.
>>> - * It is not meant to be a way to discover the usable size of an allocation
>>> - * after the fact. Instead, use kmalloc_size_roundup(). Using memory beyond
>>> - * the originally requested allocation size may trigger KASAN, UBSAN_BOUNDS,
>>> - * and/or FORTIFY_SOURCE.
>>> - *
>>> - * Return: size of the actual memory used by @object in bytes
>>> - */
>>> -size_t __ksize(const void *object)
>>
>> Think it could be also static and not in slab.h? I'll make that change
>> locally.
> 
> Uh, great. Thanks!
> 
> By the way `size_t __ksize(const void *objp);` is in both
> include/linux/slab.h and mm/slab.h.

Ack. Also moving the kerneldoc to ksize() as it should have been there
anyway.



