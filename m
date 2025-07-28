Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0D0C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186CC6B0098; Mon, 28 Jul 2025 04:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F316B0099; Mon, 28 Jul 2025 04:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D586B009A; Mon, 28 Jul 2025 04:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E42D26B0098
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:52:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96CAE160182
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:52:27 +0000 (UTC)
X-FDA: 83713057134.17.350CBF7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 351D6140009
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:52:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FXXNB5F0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hxxRV9Ku;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BJrDuZmf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/m5qpbx";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753692745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIY0azEbVgAAttF0kCKqxJbSfz2yFJuIv+U+aN+jZuw=;
	b=IyH01X3xfxIQlL8T9Um0t1v/Zcb1yUhNko1AiLxknlcG+H9/gfszpUdAU4ewwfFeDHmPO9
	+xDoBeR1hBBZOpWMJJ6GT5nsZ/20OGVkEZGi05ElErM/0ZFjg+OHogoyK4C5y0+FFpCpQs
	VJvsTcJ5MgXaNqq4alInG/usy6levQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753692745; a=rsa-sha256;
	cv=none;
	b=4KDlk9WhcbGxNnX5JjTFyAO+NA0wwjj+TFL/sB6B/yvdTyGLJgFMMMVyW7nSd9cmG169bO
	nEMS0xd7iG6jQi0iDKUpamgqJs7uY37Jo1iSsZ3gSc/+VQ3rrR84qkk8CWvp0W9+mmsdhU
	VaAWOKeNtJpqeU/rscByQ1TuuzPXG+c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FXXNB5F0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hxxRV9Ku;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BJrDuZmf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/m5qpbx";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E10C81F444;
	Mon, 28 Jul 2025 08:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753692743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BIY0azEbVgAAttF0kCKqxJbSfz2yFJuIv+U+aN+jZuw=;
	b=FXXNB5F0raH1n/DP3V0pgMKfrI8lxFpwYyEUmmr3tY4hI75d1gYG1vWpLB8v1zK3R4Zwo6
	vsCJBVsBaa0WgZM8vZkOHf6bcuymEz8RtM/h/9rcNrofxo4rCnPEfdmnbSNFdV6/cqzfqq
	831y4VL8rN64vNvhtOCCAH1fc228/DE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753692743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BIY0azEbVgAAttF0kCKqxJbSfz2yFJuIv+U+aN+jZuw=;
	b=hxxRV9Ku7/1/nVw57xI0kYGLrYT26eOePl0wRUzF1zGFbBDlqHFCo8Mr1Oew2StelmzMj2
	C61NpOH1tnv/9PBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753692742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BIY0azEbVgAAttF0kCKqxJbSfz2yFJuIv+U+aN+jZuw=;
	b=BJrDuZmfqf0uY5yKotHqnjtFefN7nlRMd5ydTqdFn02R42QWTz9n7+AIUwdn5PN8J4d7UP
	aKMuzEJoRcWMFJK67xw+1J/rWN4k8T7qz40Z09axcDzGRy6dL0xTDUKDUSYVFEf4AKoc6o
	xxnVW/1BWEUiYJ2BZeO+vfOz7GuKu1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753692742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BIY0azEbVgAAttF0kCKqxJbSfz2yFJuIv+U+aN+jZuw=;
	b=V/m5qpbx2umoA783kDyLRV3q3oGzpNGE8AW9e+sk2xaQuP5UjTA5NWgF1Oc4wv8Zoo/UD6
	dMXnLAmADLoS2WDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC7D9138A5;
	Mon, 28 Jul 2025 08:52:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fE6bMUY6h2i8IgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 28 Jul 2025 08:52:22 +0000
Message-ID: <431bf109-2bc7-4284-9b3a-7b36c329f25b@suse.cz>
Date: Mon, 28 Jul 2025 10:52:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: slub: avoid deref of free pointer in sanity checks
 if object is invalid
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Li Qiong <liqiong@nfschina.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250725064919.1785537-1-liqiong@nfschina.com>
 <996a7622-219f-4e05-96ce-96bbc70068b0@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <996a7622-219f-4e05-96ce-96bbc70068b0@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 351D6140009
X-Stat-Signature: enmk8rn7wcno8oirn4xo4nqpo7mgbfy3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753692744-94252
X-HE-Meta: U2FsdGVkX1+yaK6jZdqaf/T0JKoQxXq87NwW7pZ2UkB+jAVP4Dq5BC7uyuR5ToAqhieqK1MVuFB8AzbiULKZeGgYW+iQQyj5065FuPUUttxWnjeT0DV1XiXkoPNMisu8V5hfvuoaeIkt5vykAuNPfZqkDr9UmNtK8SE+Hj5SqqDt4mlWTr5DwFzM05hmRT7OUy0JNvf6VUjx16p0LQ/dQRClamQAlKQD0xUOKyODAkulShV3tG0bPt3YRY2sK6Cjc3aoVkyIk1APbuOqVTVuIwpQx2iA2qBHNrDXQQU/3fezQDKHoxdD1OAT1hWuYCQbki7L+1EHexDBk8f38lI071PUrHuAmKakN3HFoi3aWQ01RzwGAaTaLrbE3tZ171GxNz3CLLhNlhV08NemEx18BPq2ZZODLry63gdTPTEw5Oqc52Kb9XQIfwo/VJYZylnFvSq6lGeWFjsfAuhDoR322dx5+UM1jWf1rAIodBnBgwU/MkqneuS5yVOmIAuWBm5kTZ0yrFJvl12G2T6uoQ9CnM0jdnromPkcGkCRrT7tIm1aq080A6hkn4TKWJSV0bPT8ZCqB0tHaYswmD+VP8iIus8+58PAH06wrAS0qV29bGRFIWTJuaHU11GSXf70L5faeA7ykzgmaQYDFa0m+FP1c3HqQY5gloXV+QpgqipslRMRhw3HRudN7wAQ9zeVkmh2SynTGNtAefVZxql/ZDsPRa00+p4Ep8g3CwiUrZwyi9m6qXQ2usTPsD9gPuFvSCDhAomMS8OFBjnoM8ASQgP+5EmzrzGgitMBbAQCCl7zxrZRWW2f7/ZhucT4ZtyYjDmpihsrBVLCOcGBlorWKG8+pvM4bccHyR6g6QQDxljufuHHfxFlW9qwNxJqA/HYLyDJXF2e9yrM4gVbInfq24lQbYxErPZFXhD9av7+noSX4CssW1IPrkDlV5H6NoTN9HTQb+HpQuCJw+Ca6qvEWLN
 qJjs7z3c
 DybD0avA+8xu0En/D4BmMAY2zBJQjSIhmXvFJDO1JKKqOaWBLIFWwvk8QC5YztKIKl7eFe+l/Ifgka3CLunnXNbb22GDomDvHE+5d7VtIy5aX/26haQdscY+UkFtbCJXmlMsIpLBxVbjnpmtaEz3GxOVdoNw5Gvkxo2TaVkLkjDqlRQ2mSUGj8Oa6vv4vXyJa088jUzVYi6EcmeSDoe551qbWhSD2kcoMtqHCH2g2sASebWopl3J0MmUQ2dFJrfM9Xk7fGNjHCjVJ+5lVRvNgWBmfbwDaet5z13egLrHQtv/eB/6N4ZFKen+UmEvrAiCGKBZjqg7kYJGBwcY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/25 18:47, Vlastimil Babka wrote:
> On 7/25/25 08:49, Li Qiong wrote:
>> For debugging, object_err() prints free pointer of the object.
>> However, if check_valid_pointer() returns false for a object,
>> dereferncing `object + s->offset` can lead to a crash. Therefore,
>> print the object's address in such cases.
>> 
>> Fixes: bb192ed9aa71 ("mm/slub: Convert most struct page to struct slab by spatch")
> 
> That was the last commit to change the line, but the problem existed before,
> AFAICS all the time, so I did:
> 
>     Fixes: 7656c72b5a63 ("SLUB: add macros for scanning objects in a slab")
>     Cc: <stable@vger.kernel.org>
> 
>> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> 
> Added to slab/for-next, thanks!

Dropped based on Matthew's review

>> ---
>> v2:
>> - rephrase the commit message, add comment for object_err().
>> ---
>>  mm/slub.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 31e11ef256f9..8b24f1cf3079 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -1097,6 +1097,10 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
>>  			      size_from_object(s) - off);
>>  }
>>  
>> +/*
>> + * object - should be a valid object.
>> + * check_valid_pointer(s, slab, object) should be true.
>> + */
>>  static void object_err(struct kmem_cache *s, struct slab *slab,
>>  			u8 *object, const char *reason)
>>  {
>> @@ -1587,7 +1591,7 @@ static inline int alloc_consistency_checks(struct kmem_cache *s,
>>  		return 0;
>>  
>>  	if (!check_valid_pointer(s, slab, object)) {
>> -		object_err(s, slab, object, "Freelist Pointer check fails");
>> +		slab_err(s, slab, "Invalid object pointer 0x%p", object);
>>  		return 0;
>>  	}
>>  
> 


