Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CE0C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 10:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32EBB6B007B; Fri,  1 Aug 2025 06:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8906B0088; Fri,  1 Aug 2025 06:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1593D6B008A; Fri,  1 Aug 2025 06:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01BC26B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:55:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EFF8BC1B4
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:55:03 +0000 (UTC)
X-FDA: 83727881286.02.E5CFF06
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DBE8C0006
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:55:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pg2tI85C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="HJ6U1st/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pg2tI85C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="HJ6U1st/";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754045701; a=rsa-sha256;
	cv=none;
	b=thNmwVPBus4STx7/G4+M+/eBv9T5I4t/FL4WeZEG0ZfMvfRBCZphcvobH3BjbYp6Qsb+gF
	WKXLgntTm/SOlDm5E1xHbcfbzKPv8wvjGpCYb1P7r9CbK+DPPSKffUBOp8oVV7WJ6yDDZt
	NkZS8xxUJNKw7gD7nsBok+/qCADWvSg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pg2tI85C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="HJ6U1st/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pg2tI85C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="HJ6U1st/";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754045701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUelM/m2ojYS6BCoujA87YICyrlEhvbcyegFbCoU5gE=;
	b=XHlNlYdMR2e8eNS3b50VGds4CJ+7Mr8JAmWHWHqFXJ4wCiLPe7sf6SBI38WLCFM6j/W2ug
	KUoHVZALKpBozakxnTv89QuwJxvtZhsR6NAbCHwX2S6htqFlnBYGHdDAqSa/pgfZkIxeAd
	dKZu34TUs85HULRMB+K20MK4IPZfCN4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE26421BC8;
	Fri,  1 Aug 2025 10:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754045699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kUelM/m2ojYS6BCoujA87YICyrlEhvbcyegFbCoU5gE=;
	b=Pg2tI85CPQGxtJhIsi2Wu2Xkqx7+aFxexxAY5eyAagLO1J7c3AfNo51A5UrQ2GS4B710v5
	bgvc9aXwPwOEsNKCnAiFUDu3zqQHQizXqsrhh+3s6eWP1cnsh4orB325rFDP6Mexk8nN9n
	E/lhCUwHiPGOJthjN5HPm/tPh+rqzHQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754045699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kUelM/m2ojYS6BCoujA87YICyrlEhvbcyegFbCoU5gE=;
	b=HJ6U1st/+peiDVDV4RHr5Y8Z9dn6Tw66H6aK4gNdtoA1YqVghHXFYBqiMKwOfTt0KUUYAU
	k50/IxSwrWubGWAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754045699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kUelM/m2ojYS6BCoujA87YICyrlEhvbcyegFbCoU5gE=;
	b=Pg2tI85CPQGxtJhIsi2Wu2Xkqx7+aFxexxAY5eyAagLO1J7c3AfNo51A5UrQ2GS4B710v5
	bgvc9aXwPwOEsNKCnAiFUDu3zqQHQizXqsrhh+3s6eWP1cnsh4orB325rFDP6Mexk8nN9n
	E/lhCUwHiPGOJthjN5HPm/tPh+rqzHQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754045699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kUelM/m2ojYS6BCoujA87YICyrlEhvbcyegFbCoU5gE=;
	b=HJ6U1st/+peiDVDV4RHr5Y8Z9dn6Tw66H6aK4gNdtoA1YqVghHXFYBqiMKwOfTt0KUUYAU
	k50/IxSwrWubGWAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7034713876;
	Fri,  1 Aug 2025 10:54:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pcwCGgOdjGiDVQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 10:54:59 +0000
Message-ID: <7821b672-eae7-4730-afe4-b72b80ac6ea2@suse.cz>
Date: Fri, 1 Aug 2025 12:54:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] fs/proc/task_mmu: factor out proc_maps_private fields
 used by PROCMAP_QUERY
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com,
 peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org,
 paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com,
 brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com,
 linux@weissschuh.net, willy@infradead.org, osalvador@suse.de,
 andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu,
 tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250731220024.702621-1-surenb@google.com>
 <20250731220024.702621-3-surenb@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250731220024.702621-3-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5DBE8C0006
X-Stat-Signature: kt9k1jifj3xhfhu5x3qn1ssxpm4i8jt1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754045701-313060
X-HE-Meta: U2FsdGVkX19JT21ASny/g8UaXOxskj0OsGfPpjF1AN66DjSKTPJQuIZsRg3ApYIu6eKxr6Z7h5WZU1qe2dpmRYZxV4zi+j0QWIM/CDyQacsUCUvpRShBJV0LFQr75UEX/JebExi34BTBDspmK1qSKTIBR34LE7j4Unyk3NW1fWtnLnNYbh7t5J//vakqq0YCVEFZJ9hZhoR4E1HriPLZy9xAJuZ+N6/+76Wl3hkeRhwPJHDpYCwZx+EO0IKB+xTZ1avK6i5NdxAccV77V4BzAX+IJ/pjWCAC9khuoWVJ/JqPhLGzhMWACi7t3M7LfPgoMTzw/HQtSthp9F8Gq8nihnRLdY5cQC9PXeyx6iZUl65kQKC+eRjT93FGcU6tJW/vcXpkTsyD+p5o4apetOwJHOG/Nun3HGLRStjLfl9ukMdpEjz4Pw0BR3Ei/IAjzzrJQhQXkya2EfpA1XxaOcJdaJWDOPYcbhR4EQu/IKyXuyFmN6vNAomEmQGz5pf+/gTYEmvcPZjwGVfY6R3tp3GZFxTW6EtagxBh+aOzkkLmCsIIX1bZ2UG00w6nWIDOlBptGifcmI9lQu8/+jyDIh7+sUfnXS5hdNQijHHlHS4sNAbMbBCkUhmdemL0MLplhYPB8xsoAcZqXcre8DPNXHCHwWjgC8qXzHF4Wo0FNfv8TGg49O5X6JctGIyIYczFsOMg3FQ2mwkYbf7lRxVH1+fDz21xAgrRCSdLc1avp6iyf/D6Bds2WMAa3rt8FSDtOhvQ7xWozcHO/5JkinuzYx7y6JJajX+Q1cquxWZrbAjJl37rsghxNfzFsEHDRUB6xxidfNbQvQ4Rx/86WAh6hoRDDm0VueUqMyT6U2M1RH1z6OUVA78BaxirQK6bLRbaYo6SNlv/mi5fmlHJZrwLPFDap+xROg9wTdeRusAG8HZO9bT9uSNxp0G6xilOaNwgHwejXNwRcqSZswwvI2UTypi
 7bvxMhHP
 kcBjxfMSgfKu6Wzs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 00:00, Suren Baghdasaryan wrote:
> Refactor struct proc_maps_private so that the fields used by PROCMAP_QUERY
> ioctl are moved into a separate structure. In the next patch this allows
> ioctl to reuse some of the functions used for reading /proc/pid/maps
> without using file->private_data. This prevents concurrent modification
> of file->private_data members by ioctl and /proc/pid/maps readers.
> 
> The change is pure code refactoring and has no functional changes.

I think you'll need to adjust task_nommu.c as well, minimally I see it also
has m_start() acceding priv->mm directly so it won't compile now?

Also not sure about the naming, struct is named "proc_maps_query_data" and
priv field named "query" but the read() implementation uses it too, via
priv->query, although it does no PROCMAP_QUERY.

Seems to me it's actually something like a mm+vma locking context? Which can
be either stored in proc_maps_private for read() operations, or local
on-stack for ioctl().

