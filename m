Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A65C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158216B016D; Mon,  5 Jan 2026 10:58:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102FC6B0171; Mon,  5 Jan 2026 10:58:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D0A6B0172; Mon,  5 Jan 2026 10:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFB6A6B016D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:58:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91FCE1601F8
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:58:41 +0000 (UTC)
X-FDA: 84298368042.10.032CAC2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 151DDA0007
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:58:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LgZ6e2hl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iAau1mh5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LgZ6e2hl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iAau1mh5;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767628719; a=rsa-sha256;
	cv=none;
	b=YH2PnRXxX5rO3S6TidkiQykiH9dCAeNLe+1+rtEmg7z+uGL7k8kCuUIFlVI0Lu7nQ9Wnb4
	rCoSumPQrN/s52KhC+rBwgyGly8MXs+ZmzPoffqHzdHV0wccAo9L6odaWY7SiYTQRJg5Yt
	bHhzOTGCIsEKYL9CIDt9oiiYzmmDUaU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LgZ6e2hl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iAau1mh5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LgZ6e2hl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iAau1mh5;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767628719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKCnzYCkRSd/wQxoWf6j0u4wFsROQNz12BE88utIccA=;
	b=qbrTkgtEsOVaICrrCqqAo21SBeZViO1eWEDHAbjFmhMiyFtLdUjm8m5fII05FfeWEZPxqE
	ccbq5q2H12BU3VuSrYM+ikLKFlH6SSjiqfDQAXztLUDOlTNC/1v7u3zVCN862dFJcHtdov
	YsipUR7dowksqt+szMbLIEOHivUmrxI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 41722336EA;
	Mon,  5 Jan 2026 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767628717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yKCnzYCkRSd/wQxoWf6j0u4wFsROQNz12BE88utIccA=;
	b=LgZ6e2hl8N3lriKG0HXAkbqEFWDQZTzqyt0O+7QQ6v9A2XKq1KxRAvwqVPp4Ci5AWiDFw1
	USEoRGBCWbN0R47KzmPaVrIoqAF/u6GiuUkKXVK4ioQdWt/q2mlE9WHbEJ9u7osswJlQJB
	SHlo11LZ6/EQis2Ce+HXR6cmqMB7sNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767628717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yKCnzYCkRSd/wQxoWf6j0u4wFsROQNz12BE88utIccA=;
	b=iAau1mh5UeNJIRS6kLDdEkEnW4JpXL1kIiLUeQUwKlH311JAZqRrA/935GsKcD8pBWcdVC
	09yEvgV7RTGXRyAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767628717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yKCnzYCkRSd/wQxoWf6j0u4wFsROQNz12BE88utIccA=;
	b=LgZ6e2hl8N3lriKG0HXAkbqEFWDQZTzqyt0O+7QQ6v9A2XKq1KxRAvwqVPp4Ci5AWiDFw1
	USEoRGBCWbN0R47KzmPaVrIoqAF/u6GiuUkKXVK4ioQdWt/q2mlE9WHbEJ9u7osswJlQJB
	SHlo11LZ6/EQis2Ce+HXR6cmqMB7sNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767628717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yKCnzYCkRSd/wQxoWf6j0u4wFsROQNz12BE88utIccA=;
	b=iAau1mh5UeNJIRS6kLDdEkEnW4JpXL1kIiLUeQUwKlH311JAZqRrA/935GsKcD8pBWcdVC
	09yEvgV7RTGXRyAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F7133EA63;
	Mon,  5 Jan 2026 15:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vLlEC63fW2kWGgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 05 Jan 2026 15:58:37 +0000
Message-ID: <40fa99da-d34b-425e-9258-c493f35007d2@suse.cz>
Date: Mon, 5 Jan 2026 16:58:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <haolee.swjtu@gmail.com>, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz> <aUkbg1FMG3g8zZ8V@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aUkbg1FMG3g8zZ8V@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 151DDA0007
X-Stat-Signature: o66uokxwbkc5u1u7ag8usb6f5s48xgki
X-HE-Tag: 1767628718-931048
X-HE-Meta: U2FsdGVkX1+fLnlClxJKphq5QozODVz3MGiXVd3X/COYcqY0xPCjvCxYUKTisdTbEkMHGa40IfnSITBHdJAtXCA6j6Tf2gTSmcMa7PqVAMnQL5ymX5supj1hb+SRBW8qyjRq5uf3v5BTb6cfgn7tnObVpOSVYjb5KasEFx7lTalOmTg1FyrcJXf72xY/AYWH/m7dhZ3ETzdZDUF8xYwyj2B06SPjiioyvtUlF8W5UT826oGY5fWmC6ffV1ioi7O9r+2yNUOOwWqO6R6HpoXHwSVB0+C/YBziBCkeEWUhtO8d2ZW3+xSkN+nK7iocAEEpjB/LuHl1rJLfxyY6+c67vdjl2x/iohXmhAGNgE2hYGNc34U/sRVM/0lFlKtuqKYxitFBUnHAbKdr47ggf93BmdQ+o9IBiFtWaV39o25tPTWb8GCbvCIWvkhnZwwaFJ7pz46niadg+mzK2xmC1h9PQRggQZeAye8sBbws5HqB1/CSFch6Eso2ItspAbiHHzY9JWScngG0jS7iqUfH9ZnyU3rH6yzTXk5whphdoRslLeo/NLyr8bZyOVoYmsacOFGGHOZ5tS213h4C5ITs53mXxNd0RFcBjegr1D3k77r+Pv/IhN/B+u7lpo7Z8Hkc5KcGGfgu0zMobI8RRkTsv8Wppz/M7zJy4lQB6iQIfjUxipzy85hb0leUZmhlza5H7Uo/XV4teeJIsCGRPQv1+C5GLlKCCbLQPutTnMAzzwzsgd2n7SS6T9kWUWmtEwSgWUBw2juQPhwRRagtlLbhCZ3ZTEFe+t+5QpMzdMJKYNReZO5uPNXv35R1gxZcpR+ubt9DfMTWyU5N/KMHG4GVP4w6qtvYbaRwtS2cerqFW0uqc7/1UJVmWU4ZrutqxK8mRLBGresUeD7609cfe1ogJCTDIL1r9kNqk2e0uxYfEKS+rrqt2g+22tdqnzRCE5s3cjH+9JNAfBKuXFbxsgUcGCS
 cWyF8QSm
 oJnezgxgutVEmPhIKHqq+4JlQy2oBJ62uPRNJG1vVU8qhBwSIuAXBfRvoRPFP59rG01C60ZKCwjDAErgANuiNi5chvB9FZrF5GVVmgyP8FR0IZytm86f9a/b/guGNvPTgbqCzlfMcD6O+H1QVNwagmgeaL5fIEuIulEar+ZYijej66oov75TnJW5aGCuOhVxD8ej0c71aGKF0HGnkFaGlbt2TacB/Ul7JBc7S+beCmmZkYUMNN9txcFOIsaFgqHEd4uERLxR7GqOvZc2OgDnyjv0C5CgD+m19q3ZrzvIuLRJEDn0+Q+Qb1VYiDVcsHTzdg9tDLyh0V5/DgugZcIpfH7pROw9ZEIrysp6tlbwFd9CTuRS6jYhuRRgkY+zLOTkzxtM5gjSYEhJRtS8gCHWcPHBgryAf2oDkaL9VUrIrkaV14wM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 11:20, Harry Yoo wrote:
> On Mon, Dec 15, 2025 at 03:30:48PM +0100, Vlastimil Babka wrote:

>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5052,7 +5052,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>>          */
>>  
>>         if (pcs->main->size == 0) {
>> -               barn_put_empty_sheaf(barn, pcs->main);
>> +               if (!pcs->spare) {
>> +                       pcs->spare = pcs->main;
>> +               } else {
>> +                       barn_put_empty_sheaf(barn, pcs->main);
>> +               }
> 
> nit: no braces for single statement?

Right, fixed up.

>>                 pcs->main = full;
>>                 return pcs;
>>         }
> 
> Otherwise LGTM, so:
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks!



