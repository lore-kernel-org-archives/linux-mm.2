Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D75CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 15:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6858E0002; Thu, 11 Sep 2025 11:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6FE8E0001; Thu, 11 Sep 2025 11:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86EB78E0002; Thu, 11 Sep 2025 11:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 749288E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:29:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31BF11A04F8
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:29:39 +0000 (UTC)
X-FDA: 83877354078.01.68A9D96
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 124781A000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:29:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kPO/4uJR";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PL6gjcrh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KGzoxmC7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vwvKgUGG;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757604577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNaB9jWC9XQ+LBt/PpSjOna9nTCIGjNcFdPCPXm51+s=;
	b=qjYdCdfiZNuoPWcBhHzI43yJAaZnIWP8JCEbAwqSpnkcMy8yNuReVsH1UMe4WB3qrn1d4D
	0wKrIkC3ZlJug0XvZ7rdfwJ/vcUMdrmaEypjrRrWVbo7S+L5KqpTM4H/7HAS4npN4T7AuR
	i7QBfnqD5sGXC5TznK1CpQMQAa/jHCs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757604577; a=rsa-sha256;
	cv=none;
	b=dS028NQp0JvneHFk3z0+502WLzQrvrSCKeHWeulhgN34iaH3PqbNJThrXLnE17juydgjPM
	951wWGwJHJtdjspQldZdOYG9NQ7GmT12WYFbWJQIIgxTx2yu+BYUnntf362KH9cbyxXw9m
	SQr2YjWqSrahcJtSjNv6r+oj26/IObs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kPO/4uJR";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PL6gjcrh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KGzoxmC7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vwvKgUGG;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D625440103;
	Thu, 11 Sep 2025 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757604575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gNaB9jWC9XQ+LBt/PpSjOna9nTCIGjNcFdPCPXm51+s=;
	b=kPO/4uJRwEmGDVvZ6ycPgy+wszPTYndrPypHrZ17qflwsINhuRrrcK11BQ79Z30MaqFXPK
	C+NmrlCqAwdkOdXi4rdLynzXZvjJMlx0t7pLVyZokUVNCkKJr/jBgU155BCDhSNHEMgFSz
	vSRh/dYwHI5vsuoSq8n5zIoaCw5i5Fo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757604575;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gNaB9jWC9XQ+LBt/PpSjOna9nTCIGjNcFdPCPXm51+s=;
	b=PL6gjcrhk3El8+Uu1jjFvLdC67mar07+eXYqVyW986Vi8QF22VVPCBUM+p2b/sif8M9itW
	M4NjmUa/cn3CXbCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757604574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gNaB9jWC9XQ+LBt/PpSjOna9nTCIGjNcFdPCPXm51+s=;
	b=KGzoxmC72esBiaBau2RShPbsQAAYxBr/wiyZ+n8lBV2OoZspFQxby5VtMKrI5Z11W70n38
	B+kx2bS8Q707VN8QFnUkIhuvdSMYodfisk5uvJjuwN9i34ONPeUlIdd0LJV/FECx75vRwz
	RasUyur5ewPwz/ElAMsL3gczof+Qwu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757604574;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gNaB9jWC9XQ+LBt/PpSjOna9nTCIGjNcFdPCPXm51+s=;
	b=vwvKgUGGYBQU25xq5E/VIpW/m+j6XO1kYTkLrMKIc73OJ6YELgy7z50C7JT51+Botjtxp/
	iKYJyE3XUvJy2dAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB90F13301;
	Thu, 11 Sep 2025 15:29:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7V2UKd7qwmjmBQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 15:29:34 +0000
Message-ID: <21321a30-4a4c-4d7e-a21b-089ae38eec35@suse.cz>
Date: Thu, 11 Sep 2025 17:29:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/22] slab: Remove dead code in
 free_consistency_checks()
Content-Language: en-US
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20250910115507.1991829-1-willy@infradead.org>
 <20250910115507.1991829-5-willy@infradead.org>
 <4109cf0b-bd09-115f-5c84-58a8b9fe19de@gentwo.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <4109cf0b-bd09-115f-5c84-58a8b9fe19de@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 124781A000A
X-Stat-Signature: ja6xg6m5r1zimzbio3nhx8rrw55a17iw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757604576-383853
X-HE-Meta: U2FsdGVkX1+VsxgckAnXuCccwnIbuDQmP4b1VXN0uaogwS6TswBSAwkjCaJ8A50BUu3UD3TeJTbnyowwECN9aitEsiXltF00t92ma9aFowb83Z4XV/YYusuB82Vrz/0mvoig1SEEO0+PAUB0rG/vyS+R0Z7O34VzOqGjrSP1+8wHQg9rpqWarhZG5K5lS4zZ5OO8QVHA7V/WKN/+6R6Kr47yA0zX0jJrBS3CdFthzSG1a/cxPTufGF9UuvkQZi/nJuuxTTDX2EHBn4XTRNmCWLA6jl1Cj21mBybVYciwUmo/7HzFDGeAF2k5K8p5tVppuhAllyY41Gx/DxGmkad1Apelz/KROf6xKpi4lkS6x0BkAwYWhQ8l3cPKWIBF3BBecfZAYsgM+qYB8PZd7LGGqIEHT4ZqlMaUwMO5DyEYJi/jnfX1G3myw3hxcfzYA7V60VAzlP4qcJ0+cb6YuP4OEZAvyY1CvydIJpVBssBvN/Mer/xkGOQQaMB0+UKSueE7qCm+HkggWhb9SCrAlsDL6I62qoOUHeGizo6gX2x/Q7KIFLM+yvGPH/Jr8o9gpz4Uopc5Ifj7SMqJ6zVN0gejq6pY956Rcc2CiOZxvFWkkgGgjpEfdbs/rHnUrl1zgDm3TMp5797ncEvFOqgwQuEJz0NyNy7dj1of2eRUjsD2A2hRNK5EMXoedeCC3APCu/rwLaNoMNKih4/59PObqm9qzgI6CW72TqbDm2QJ6gIlmtjK8r0zC6lj835LBWRAE2zWklakCI/DOUJclsUkzBZPpb+44YWvvad1dCjB6LYPVenu7UaXhPurYm7pp7jZ9e5vxK/omCd3mprcRo6dFLpuUUfcMEzDPlGYU+pQlVkzOV2RkPlK9TiazK3ByoyNH1eNfkpyrcaaCm7WJ1yiXJW90WN2U4BOJRhB416OCfAPFtW0Lp9ae8pqKFX1sdoIPpvZOpirZtlz+770eJEZEFI
 MLEldHfR
 YLokzJE/JqZUm6l0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/25 00:30, Christoph Lameter (Ampere) wrote:
> On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:
> 
>> We already know that slab is a valid slab as that's checked by the
>> caller.  In the future, we won't be able to get to a slab pointer
>> from a non-slab page.
> 
> No we dont. This is another case where there is a metadata mismatch and
> where we already know that something is wrong.

It's been already checked by free_debug_processing() doing check_slab().

> s should be equal to slab->slab_cache and it is not.

It's possible even this check is dead code because we got s from
slab->slab_cache somewhere before coming here.

It makes little sense to recheck everything over and over.

> Therefore we should diagnose if this is an actual slab before
> doing further diagnostics.


