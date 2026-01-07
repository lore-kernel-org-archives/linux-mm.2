Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B104CF6C00
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 08:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0EF76B0095; Wed,  7 Jan 2026 03:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBCEE6B0096; Wed,  7 Jan 2026 03:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B946F6B0098; Wed,  7 Jan 2026 03:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A81706B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:43:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40E5E1601FF
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:43:11 +0000 (UTC)
X-FDA: 84304528182.22.A9BF9DC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB183160002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:43:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K6YvbDoE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+2iJ2/nL";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K6YvbDoE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+2iJ2/nL";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767775389; a=rsa-sha256;
	cv=none;
	b=NEWNE81ucsjn+L6MJ9e/r95MngAa6Li2pS9IhgnldcGns+s0GZv2VZ6vTZuI2L5GIZSUDI
	XsRpky3RMZ9reAqTV/Kb3HSmlNxQ/o2NT6k2iUyzOXY8Rd9tgzrSCiUy0c+E/esPsXSK4G
	CdjbI/IMrPTSlVNXwRviRBjYkq7D4cw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K6YvbDoE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+2iJ2/nL";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K6YvbDoE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+2iJ2/nL";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767775389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9yR84pon6xd0ytNH6eCurT+/iim4Z3gcEGH7Lb+dsE=;
	b=WDbH4nfEu82jMLj4RbVFB489F2aa18fgk+i/jjwcezMvwlNM/mI1EmY4LRucdb0iCcdXVl
	11zy/XiplUYKmvNuEqwg83X1lC9JG/G7Otl1vweTuEPLrn6m/1W0FtlhcPzU3Q4hYS//IH
	7v2pf57oJTH6sdvhdpQX4oe/uPSat5E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F18B65BCF4;
	Wed,  7 Jan 2026 08:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767775387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h9yR84pon6xd0ytNH6eCurT+/iim4Z3gcEGH7Lb+dsE=;
	b=K6YvbDoErLCDbj/3/KiTvSURXuhIM6E47WqkG6T/8FORn2koNmjBi4uBvXt081OGmVTQCv
	c+RR8ZrPf1JiFAoWodjqdIz2MCRoa6lPWId7xIYLRomE3wcbqNyZk87s7J+GbpLR3iT9vV
	xGpcN9eR29BaUWNgufV9LMHaOP5VYoU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767775387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h9yR84pon6xd0ytNH6eCurT+/iim4Z3gcEGH7Lb+dsE=;
	b=+2iJ2/nL9sJPOEhlCVn6Yi99gDGpgwHU0inFKOYhBIb1X07xl7fzg6i2PKAjGRTRrSyKA1
	JWmwXmpme4W19aAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767775387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h9yR84pon6xd0ytNH6eCurT+/iim4Z3gcEGH7Lb+dsE=;
	b=K6YvbDoErLCDbj/3/KiTvSURXuhIM6E47WqkG6T/8FORn2koNmjBi4uBvXt081OGmVTQCv
	c+RR8ZrPf1JiFAoWodjqdIz2MCRoa6lPWId7xIYLRomE3wcbqNyZk87s7J+GbpLR3iT9vV
	xGpcN9eR29BaUWNgufV9LMHaOP5VYoU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767775387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h9yR84pon6xd0ytNH6eCurT+/iim4Z3gcEGH7Lb+dsE=;
	b=+2iJ2/nL9sJPOEhlCVn6Yi99gDGpgwHU0inFKOYhBIb1X07xl7fzg6i2PKAjGRTRrSyKA1
	JWmwXmpme4W19aAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9FAC3EA63;
	Wed,  7 Jan 2026 08:43:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dgvdNJocXmn6bAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 07 Jan 2026 08:43:06 +0000
Message-ID: <a0ffc797-0e65-492c-bee0-c906b0392a6f@suse.cz>
Date: Wed, 7 Jan 2026 09:43:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
Content-Language: en-US
To: Mikulas Patocka <mpatocka@redhat.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
 <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7>
 <e60858c9-12a6-2b04-35ae-9d676f14db2a@redhat.com>
 <j3dy3g5mchtdzxldtnqu5nwaalbr6ec4ceim3nuu6nwcddmqjc@7dgzr4m7pli2>
 <6633f8ed-f432-f4c4-3fe2-8c14248cadab@redhat.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <6633f8ed-f432-f4c4-3fe2-8c14248cadab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DB183160002
X-Stat-Signature: dmwpqe4wsoxkdfidknpz7cg3faojmim4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767775388-827166
X-HE-Meta: U2FsdGVkX1+tpe88d2mGpRIdI0X3W3UZmkooJZsKV2qa2cukhy6q+YZIDMHLxnXQswRulH3ooo9l/9dzCAjomjbUmZzFJmeNi0Knlm4r615DVSP1FzHYkjnnf0maZjPXF0EB/eeuVbWcPjUAKVCqWailBg3G0nh6rNB0oc4lOiS46zXMa0JeZ59WodlmCNxPr6Qq9GP9Z1pzWPiyyswo36pFFp2AGz3UW7p3uHfuaYR7lxbiI/fjuQe/++mgX8kUPNB7Zc1oL9KVMOooc/erT2T/zZMISWpVDOClIDH/mTlJHsRiI+8woHKgNWrTZhbAkFDKYyHZnpsGTqonxFxZTgYAZlZXg8nfhKFhe1Gh2aYxxIVFYo9DUO3nEO4IH7ZY5WaCvb9y8jTeT8jGG9ouWDQmLGQoToFkrsz1zLMDAngN+fQkcKYnOIF69Ev9fW/1aU5YTnIGlxxnkLr6B5DPEbjF03+9bxXqu4cHuaw/istWqjxQ8PnXomSSxHhJgYO9IqlvSRHGbfF6Enno1YRqFuwS15ar1jK/4ibbEeYVuoqnq/afAqKqNaozZJaRK40Hy5qRHztl2suH4fVtgE3rOAKjaYhKCKe3JfHQvwj7wX3L3kMdmyP7qE9pzGanJiDJ1mq92G49arMyUx1N3y23YqkfItus1ktmmLgIYiyoJgTFANFOcuCATMXxSnk3Glm8WAaEILCogo1d35tgYBsP/qwQmUHUMnZNNePJVbmmuHC1i21FFP7vVFXD1z/9OF+GKVuopbFomPUDtxFmXYce6hDnoDcIcCxf/akAOHOkYzF3EqNNkNxygRyM1V/tDBZRN2zmzAsDw1OgvOHHONQOxEdO54qv5IHj+tIHc6yf+k40lSOrCH4wUKGy2FAd+I+KX/twVdpzEx3Uj/7DCKI1ys3PGlLlstqSb06r4qW3tFwccKNxG3TGg00HPYUcbLorttlbJVC9zVQcFwEb4Rt
 DS+NykGq
 WYF79lgXnW1EOqksd7tC4r1jgqPDM+XA+NYadq5Y3bozhSQuNENKvMrZRRjxkRCGiJC1GLnlv+yIMkpH3xdqKwK3mpCBis97zp97B9wHxInJapg69jyZqGWzT+1W8G97FuD3NNdNQVoJhTYCJ4/sbOI1qbGjJOsRV+0s8fR5qbeQhPXGVUcES3BPuceuJ94ELrZK6lGjJp+Q5t6+Ue338lIXI2KQyFJfrVMl1hZzaXPVT7bj12HiPs+fztSjgWgkv03emsHzDYXHKwd5wAAHWOCcfPpFCxDPUzOUA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 21:19, Mikulas Patocka wrote:
> 
> OK, so I'll try to rewrite the commit message and submit version 4 of the 
> patch.

I'd suggest (yes, it's the opposite of what Lorenzo asked for earlier,
sorry) to make the necessary tools/testing/vma/vma_internal.h modification
part of this patch again and not separate patch. It will remove the need to
indicate it's stable dep of the fix, as it will be all self-contained.

Yes, backporting to a kernel that doesn't yet have
tools/testing/vma/vma_internal.h will make the patch not apply, but dropping
a non-applicable hunk is trivial for stable maintainers. There will be more
involved conflicts anyway due to mm_take_all_locks() moving between files.

Thanks,
Vlastimil

> Mikulas
> 


