Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC20BCCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 15:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0321D8005D; Mon, 27 Oct 2025 11:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAFD68000A; Mon, 27 Oct 2025 11:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D506B8005D; Mon, 27 Oct 2025 11:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE08F8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:06:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5ACF414013A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:06:26 +0000 (UTC)
X-FDA: 84044220372.19.16FE66C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id CFB93180003
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:06:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dG2FKDgs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7OwKB45p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IJKX7heM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=STuVJP52;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761577584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEd2vkU9lJ1iwHOEerVGkav9/GgHW3c9Y+PfOJGrPx4=;
	b=DJqRYkawwo08hxVLIuLsuBcklxs1ARNy/JfdccDaCjg1tgwg5WzZLTYQvuz48rXKKdTxzX
	/UDjF6AyQHhAj0zeW7oVauZfzoiSzdC6b/NBUNzB1vaBQB9diC8jp/YOi6FWDqZXWEls0I
	vd0bi73vcyaSXkI28jvxzLe1RlDEAQo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dG2FKDgs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7OwKB45p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IJKX7heM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=STuVJP52;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761577584; a=rsa-sha256;
	cv=none;
	b=fhzQ7oBIGB9yyJKdT9oqe3r6D9IgF6SU/bgFlucCrUFttNbJJsspUVFRlDX8/wCptsMdCM
	k+77vVhABwITOB5aAnSd5cgOTOJWwLTx2tLnnzioX49TYK7XN2NZTR4Qn9naapTDBSwMqJ
	GtiojnvkXNIQ5DmEOIbqz73y6OA6Jgc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D089221A38;
	Mon, 27 Oct 2025 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761577582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PEd2vkU9lJ1iwHOEerVGkav9/GgHW3c9Y+PfOJGrPx4=;
	b=dG2FKDgsK0aybthHfuS7MNsob/GdOGCUtTyfYt8dFeiOqen1/cBoQ76LQVTgsI575Y3DLn
	MSU/lThvGjLHCt7Ib5oMgZE1U+qIl6STPTclkYRtZC3YaE/BGIjIPCb++AALjT5RYfG/cH
	luOKq8BLVfWxrkUkQcx2H1jHnLoMY74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761577582;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PEd2vkU9lJ1iwHOEerVGkav9/GgHW3c9Y+PfOJGrPx4=;
	b=7OwKB45pVYMrxSEao0+oaJg8K9xGbO6Iu2ejunPo6jWKIZ6fF5mzXIdPIFsi+d7ojjv5fS
	epaBDjsVAnjenMCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761577581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PEd2vkU9lJ1iwHOEerVGkav9/GgHW3c9Y+PfOJGrPx4=;
	b=IJKX7heMGw1wrMKQvu390jGu1gZqaaseXAR60D69kf+Vrv2fwfkfCGG7Xj/oUuDd1cJC83
	wkMJpWvrzHwDmAKCdNgB66YdH8vmt5q/uajA9YAWxQ0CfJwHnhII1On9X/4quOdpubHzen
	Ula+CqQM9ifzDAZzAFbLGAtxPx9aN0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761577581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PEd2vkU9lJ1iwHOEerVGkav9/GgHW3c9Y+PfOJGrPx4=;
	b=STuVJP52vuBkYweF+Vft+Ygo4W7Va8oDJIMEKtAwlj98fPOgdfkrD7onwWzqXyD2CBa7p+
	j3RXR7T1zoleGwDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF96A136CF;
	Mon, 27 Oct 2025 15:06:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2eRyLm2K/2jnNQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 15:06:21 +0000
Message-ID: <2236fdb6-4616-4b9f-82c9-eba3ce5d371f@suse.cz>
Date: Mon, 27 Oct 2025 16:06:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] slab: switch away from the legacy param parser
Content-Language: en-US
To: Petr Tesarik <ptesarik@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1761324765.git.ptesarik@suse.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <cover.1761324765.git.ptesarik@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: b738odb1j6r3n6hijzd5cx5oazujfdms
X-Rspamd-Queue-Id: CFB93180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761577583-733278
X-HE-Meta: U2FsdGVkX1/trIrAEclFiZ3Y0Ms+/STm1aVslPFKqXh5lwlj0AWZiWFnulUXY69Qej5EiDoSNNL5+tcsWuPy0HfOQKffafMg6IWSzpTJBjcp/PmM6SC3QJGcDlJ+LmC0gJqKufxdaBEBIj5oVJLZCZFONr5kP/e1I6IhRUwNFpkmTQjTE2DZhohEIai6Jerewqm9bdMcndFIpfviVEW0qr71xO5dm4p3CuvUuJBo7Jx4yPVj5YWf+Al99fqdnYXGODt6V406ubUKtXoCTn1BcCS2t7MssDtupJ03wriuiVQA5wQA2rCQDH1dpGRXAJBNTW+3Hday/VVgJ17ul5YFJ2et0cy+xu4C7XalwUHtLpmmSC/vkV04CyxloiFt8n6kNUFM6flEQAYSIOZHiw35IqSOBeodYzKp2G7w5MiLlyfT48rIHl6W3idqRiuWrrsxrD5ldrW/fKr2rksuyfQoh1tiLgakQsufWHLrI2heNktQPK5hTvnFSpzgi01GGJLANEfbjjlRltbKTUXN8FuK+OMLBlXhbihB4bMCjeaDjdYH3VKOjwcr4aZJHDGNRWDKcY2K9DZkgIDgIgtEzg41L46kh5sFE0ZR+gwaR2Hgvgmc0KWdvuDZvz+/3mQksbb1H5floBPMg3HzdIK0b2Vlm5PdQ5f/99xrOStUsgBGEm8DQ9mRK9U/G4Y5lLBqZenEOMoDnelkXD6pXQB/S6jWhVU8s2BKkkutMHg9cDHTsCWnK7EavK6mpkiRvlIn9JRHRkjASdHKZHXWqtuwvPYkmGYiZHUuYneHAvYx58UWKR/stxt7anIMqXSWMnsgdw/SOjZNHy0sSXe8PGhlSSIGYxNtc8ATrlhCHB8nlgYemRvQJ5bd7myCco2fL0nR0l/hkjBVc5O54JbD4Qz0eDRu/efYxmGRhRonUCWjmyQiljuAL9oY3iRfy3WNwv9sKnnJ3PkI1kqMVZ9YMGS2ZgS
 aSPIaOha
 8ov20wDBeVSvcsQ+xULF3NkAHTadE6Dz7TEsQ7YPdIal4HzEgeeF04+olNBBab2LjddOJHxeJ0877uVD2LLuwKcrT6T363f6uAlRfWn6zjlwMPChNmumWuzl8O5dPv1lY2UYiJqedJnx96WfwcGXOLrBt3DGB+x8em8qWvpwQMVG/YT1LJmCJ5jjj44pV250AbN93VIReEv+dAAnUUirfnHFe85sSTjMT8vl1lva8NSyAR9H/du54MBVCzxD0V+7GJZXSer1Cq64oxlhGaXUZg7xMbcmfA3NyTWMH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 19:06, Petr Tesarik wrote:
> The handling of legacy __setup() parameters has some confusing quirks.
> Instead of fixing them, convert the code to struct kerenel_param, which
> is a saner API.
> 
> Note that parameters defined with core_param() and __core_param_cb() are
> parsed early in start_kernel(). Do not confuse them with core_param_cb(),
> which are processed at a later stage.

Thanks! Added to slab/for-next

> Petr Tesarik (3):
>   slab: constify slab debug strings
>   slab: convert setup_slub_debug() to use __core_param_cb()
>   slab: use core_param for remaining command line parameters
> 
>  mm/slub.c | 87 ++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 51 insertions(+), 36 deletions(-)
> 


