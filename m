Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63914CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5DE8E0016; Thu, 28 Aug 2025 04:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86F98E0003; Thu, 28 Aug 2025 04:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FAA8E0016; Thu, 28 Aug 2025 04:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80C9C8E0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:53:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B87511983A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:53:06 +0000 (UTC)
X-FDA: 83825551572.03.0EC967D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id B58C3140004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:53:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OxhqL49r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2HgcNsaP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OxhqL49r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2HgcNsaP;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756371184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/oxsdX5V9AkY31SlzlrE/m6SVdNwkRnU4poEzU31XKc=;
	b=NKw7nbRlYPNYUnhjdmG89tWx1hWkCJF0Ht96qNIjqwvr0VLH/ltH3KCuDLCvje/OHK8Bq0
	TB296kCzIo+7nYGzm+IQfWgyR/o/5fZIB5K5yrfo0e1su0VrLkpIxe49/7Uz74V0l/Igpw
	l/zI/8s88yk1/PEnFjx9pCCHo39Ncdo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OxhqL49r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2HgcNsaP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OxhqL49r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2HgcNsaP;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756371184; a=rsa-sha256;
	cv=none;
	b=cqN1FLjxLxgXg8HX59BQ6cV6YuGL99Lu6TzGgy7SeWTqn1USHmVpL76L8WAjliB7I3TWn3
	qEEPa3Siwt/IES+i9r1Ve9UUvVL58nRfs57wovm6FCJR8aa6B/i4hcRA1JmW/fkYuy1XNm
	Bo5Who2uj0Ws4W5gYa189+v5xIM1I9Q=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3A32121D38;
	Thu, 28 Aug 2025 08:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756371182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/oxsdX5V9AkY31SlzlrE/m6SVdNwkRnU4poEzU31XKc=;
	b=OxhqL49rLgmA8RDpEpHHr2vyYbqvDW2zEIqBLstKJ73qrcI05nTiKpKy2EDMNAgaUjaprl
	Cmc7QJfPSrN1JYCupofFxe8wGk7tieqALDn113HrUs+ijiFk3L2SmG/ON9q4Cyo7BdkxdO
	qf+hZoB6l0dZ/VVOdEvnFBi3lIbQ/U8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756371182;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/oxsdX5V9AkY31SlzlrE/m6SVdNwkRnU4poEzU31XKc=;
	b=2HgcNsaPw8QNO11I+W5Ta/5UMp8+DU2/+lJ+nXJnVYOyS8zF3Ua1ENCR9DQh2XVhYd/FsM
	kdGBc03NA8J8jaDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756371182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/oxsdX5V9AkY31SlzlrE/m6SVdNwkRnU4poEzU31XKc=;
	b=OxhqL49rLgmA8RDpEpHHr2vyYbqvDW2zEIqBLstKJ73qrcI05nTiKpKy2EDMNAgaUjaprl
	Cmc7QJfPSrN1JYCupofFxe8wGk7tieqALDn113HrUs+ijiFk3L2SmG/ON9q4Cyo7BdkxdO
	qf+hZoB6l0dZ/VVOdEvnFBi3lIbQ/U8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756371182;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/oxsdX5V9AkY31SlzlrE/m6SVdNwkRnU4poEzU31XKc=;
	b=2HgcNsaPw8QNO11I+W5Ta/5UMp8+DU2/+lJ+nXJnVYOyS8zF3Ua1ENCR9DQh2XVhYd/FsM
	kdGBc03NA8J8jaDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EA631368B;
	Thu, 28 Aug 2025 08:53:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dKHvBu4YsGjeMwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 08:53:02 +0000
Message-ID: <2182c715-aaf1-46d1-809e-e4142bc083af@suse.cz>
Date: Thu, 28 Aug 2025 10:53:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Content-Language: en-US
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Usama Arif <usamaarif642@gmail.com>,
 linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
 <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
 <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
 <aLAXsptN4cw05IoZ@devbig569.cln6.facebook.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aLAXsptN4cw05IoZ@devbig569.cln6.facebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: o3md4y75ch4jsigxce8onp7tpdkbnd8s
X-Rspam-User: 
X-Rspamd-Queue-Id: B58C3140004
X-Rspamd-Server: rspam05
X-HE-Tag: 1756371183-103154
X-HE-Meta: U2FsdGVkX18tmjTTGJ+g4ighD0zx/uEcljEwHQ7CtvroeEL4q6MqR5X5o27ILooqT24Ui4fetl8H4b7xkhNjA2vmo8i+OspdjsbWqxIv+tpZzmpJEsWwXwCdTTXVTYdFKuK6s66+5/ycowyNEr8LZbKpfsLV0jfbBwSmUSbRGlf9yXz4zJWuJ4aqHlga8NFxLI5pW0sCDBAvGo7qgJQJ9MkEd6G1lOXoIXyLT2jVdH5MvGHDCQiWVu7QSWC+dzPRdHxq0pbDu/rL7UyyDeiNzEVEOnHjQehaGN2XLV5K13Y6xGiW9fWSyc7joi80i0kOg5tpUeudjBIAV3GlnghZfFcfOsXpwzfoU62L5WusP7eTEAlg4Ra0T40DPIWwFTf5rvk5kLfN1PXUi0h/F6f8AHNqYR1lW1Wkw2dv8U2uPTozjVFsnlrW+RRSrrVisQPmeU2iZwu6cWTVgflv/5Jova3FxkKYm19EmHLgB/LOTqdkW86jUNJ7nrP7YHesXfU/zB4M0tzI32z6C2WiCMbkarOIB546JeUJnRp2AFNQIhkgj78JViHYYpgQEThXPVRw1ZKzIfEOCQiJcn5mtL35a/nKwg7QsU0/16umJeKmdIxhL84mfs30pM++EG3qRGOLr/5ypAycZONGEqwFz8VtVbl9RixLVmhNOQ6XQt28ufKtiqzm6ZQgJK/KURXmwsL/HGmVoCyLLH1a+WkBrrwdN7zUFqanYmgWxJTS6/FJewot1TJttD83lp0oSz+7PDJTkm3zkz2kSBUkLRaigmcGJW6ATPmoB6USG2vGiLEcOMvqyh/3vrkjuZ8R0YUTbOds3Nn7k+0QpeS0YqJ21DrNzW3nsbupFjd/gTnyIF28fPv6kasVL2CV/Z+cykiGQXP1gJNkCA3CqLXWWFrxCwJrAojjBBXYr3NZk/TOTM0DjChXLXSDFQ16vJMhVFKNQO0Xhm4A8vRmUvE68gcKeb8
 I3f8gNNN
 +lKUjR9A/7pV41poEEFijKg+QK+AxNu7QTPbP54+vayWSg47xlot7GBfqf3qpSx7D00d5xbe3wvvuWClic344zox63gAoTUl8buZd8J69x1cHxPB2CshT4e3hwexJ7YxLdLSo2HWzZo6QFiujlJncsF9y7nIQdxe1lAAqJeLPdm+7C+s6NrqOz1fiM7xScn1WmruBc3Ojq8Ma3Np2hE5IxTjfMXgYSgty2MIJALoe6DwOnggPKqmANKrcxwVftDfCZ66Q6mUQYDC0skJSyRkGPzrQIEgSs2X5f516JZffxius74fnVqT7Rn1xlTODfYj3NgpC6l3vfS8tERGmdQiVpU+3W8CsQH4DARRg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 10:47, Yueyang Pan wrote:
> On Thu, Aug 28, 2025 at 10:41:23AM +0200, Vlastimil Babka wrote:
>> On 8/28/25 10:34, Yueyang Pan wrote:
>> > On Wed, Aug 27, 2025 at 03:06:19PM -0700, Andrew Morton wrote:
>> >> On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
>> >> 
>> >> > In production, show_mem() can be called concurrently from two
>> >> > different entities, for example one from oom_kill_process()
>> >> > another from __alloc_pages_slowpath from another kthread. This
>> >> > patch adds a mutex and invokes trylock before printing out the
>> >> > kernel alloc info in show_mem(). This way two alloc info won't
>> >> > interleave with each other, which then makes parsing easier.
>> 
>> What about the rest of the information printed by show_mem() being interleaved?
> 
> Thanks for your feedback, Vlastimil. We cannot use trylock for the rest 
> part as node filter can be different.

Right.

> Do you think we need a lock to prevent the whole show_mem() from being 
> interleaved and to acquire it at the very beginning? Will it be too 
> heavy?

It might be risky so perhaps let's not. Guess we can disentangle by dmesg
showing the thread id prefix.

