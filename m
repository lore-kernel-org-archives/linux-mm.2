Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F35CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 09:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21E7C6B000A; Thu, 27 Nov 2025 04:05:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F86D6B0012; Thu, 27 Nov 2025 04:05:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112996B0026; Thu, 27 Nov 2025 04:05:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2D8A6B000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:05:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE1F98A85A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:05:43 +0000 (UTC)
X-FDA: 84155804166.03.7553DCF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6345B1C0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:05:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s6mmloy4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="7G170Z/J";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s6mmloy4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="7G170Z/J";
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764234341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yl/cxNfIBjDg7uVH4/Aa4Lz1n5tVfmmFAO+v44ws/Pc=;
	b=Fv9KJIibB4AEF/vXLgnY5vWksvDBquk+zvdWDoOqazYRxx8+QOMBlYz9g5uMJH7sU4MxPW
	DJEJN2ungwnAHqbD8YVMJTUOaXTJ256Dn52HIiGp9Fuq7CEday/p/O08xo3QW7xU4FmERW
	uVEUXZIHUunOyg+ZeKQPvhNEe25hV2c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764234341; a=rsa-sha256;
	cv=none;
	b=8PTLJ3FTtXHeJ2BbZD++uERL64sP5NWsqcc+U0PH5HQ95wgGOqDBcsfS9dzStbdxNRGbjW
	36CmAnva/aZyjjDaoqzUZIxi3qqX7U9GZl8Qcs1LpPY1BWXoYP64jjJ1t1C8qKnJA2LwCv
	MK9uvBwEabUUkPl/4Fh6zWd6czTxkRk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s6mmloy4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="7G170Z/J";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s6mmloy4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="7G170Z/J";
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6FFE622CDE;
	Thu, 27 Nov 2025 09:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764234339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yl/cxNfIBjDg7uVH4/Aa4Lz1n5tVfmmFAO+v44ws/Pc=;
	b=s6mmloy4NBa1x7fVeSCnTD9/PYr5STU6L9SCOfE7VwM1SX7DT6jlhS5YJdKNb6TUPnAiQb
	d7ps8iBVwAMt5khEbbQAmp9zJc3W+O39lNvRzDJ3CWiKg3cpZFpZs935Rxcec77fXUEc3r
	f2nC2xeigKt1SyYU51EzL6J6G74vuLs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764234339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yl/cxNfIBjDg7uVH4/Aa4Lz1n5tVfmmFAO+v44ws/Pc=;
	b=7G170Z/Jq3WGbXG2LPE1sjo1OxJYhtjWMKvKQ2v/psLigh9Q6XUYxCrx2Z8EoGt0Cbf6CV
	BEuyNlqD5c3pWcCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764234339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yl/cxNfIBjDg7uVH4/Aa4Lz1n5tVfmmFAO+v44ws/Pc=;
	b=s6mmloy4NBa1x7fVeSCnTD9/PYr5STU6L9SCOfE7VwM1SX7DT6jlhS5YJdKNb6TUPnAiQb
	d7ps8iBVwAMt5khEbbQAmp9zJc3W+O39lNvRzDJ3CWiKg3cpZFpZs935Rxcec77fXUEc3r
	f2nC2xeigKt1SyYU51EzL6J6G74vuLs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764234339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yl/cxNfIBjDg7uVH4/Aa4Lz1n5tVfmmFAO+v44ws/Pc=;
	b=7G170Z/Jq3WGbXG2LPE1sjo1OxJYhtjWMKvKQ2v/psLigh9Q6XUYxCrx2Z8EoGt0Cbf6CV
	BEuyNlqD5c3pWcCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 54AFF3EA63;
	Thu, 27 Nov 2025 09:05:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TiTwE2MUKGn5SwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 27 Nov 2025 09:05:39 +0000
Message-ID: <c8f79c5c-7354-4f6b-b9cb-3eb43381d03a@suse.cz>
Date: Thu, 27 Nov 2025 10:05:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
To: Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
 Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
 <d70b3309-348c-4aa9-9b62-33b8191955fe@lucifer.local>
 <aSdYkYYAuATwYqbD@casper.infradead.org>
 <d8c2a266-fb2c-4374-ab14-4ac910db7ad2@lucifer.local>
 <aSd6oH29iELxxU5o@casper.infradead.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aSd6oH29iELxxU5o@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6345B1C0012
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ty71176juy5uwyzq3rdymtgtgyyme9b8
X-HE-Tag: 1764234341-627735
X-HE-Meta: U2FsdGVkX19rQqP/eWhnsdoFiIQmoufLuLyyMCQwvKmYJPimDT55uziiRMzassiy4Lc6p2MwCbNJOhZnYuE2lnIonadg3yKVOcNRk9diG/SpnqQy6jv3tGuw7MoAq2MlieN3dheycFlJN9+frwy3V5xJRCYJODttUsfE4HWWvFDAZPwG0D9rftsziPFVIRFfi2Nawld0HHhmjJobrUxkNQZwJQcMjRSrRCI97beq7QlghpbXt6+fQUaZioMwxFUtOiq0zm+bi+R+7kDIHI5oNWbD+NaKDp4N2Ey1fui2/q+8dhrVD+ig14Na2pE37e1kg1zqlLljC+SxEqwFjgI4egTcEVeeIsxoUBiHY+3biSxPyhZ8PSwA5h+g4eTM2+hhEJ50K7cSkkU5nzHvWDp61OKa7a5sgb+6PvPpjpn4Pw1yqFV8VYHSVJ4PpeJpzt8v5YopLITXbL4qfgXgLeamJ7q9m1YbyaVPTgQe9qNIjPzKn2W2RGL/A07lmzTDzChYGd3T+3htQqpeDc4KSd0psZqbJyRYaeLlcnAwAH1r4fBD2Z+omxkhceIeIojtnLiy3lpFB9TWZncIpE0ZLGrcfWMXuayx/3Qqp6MtPiR7AOE9kNiqoI6eWt2KND2tqSjUubTf6aaf9wUbMjVleM6loksY7g+5vYt4NnYW3tnpr+TIH4EE7xFaF6EY5/BWOeS09Sp5bqaLT5ylORucNOxztTNZiGBWP4iXPmIoHNdFSZgr5mXvjDu1xmuHRZNU0MbGI3pXUtlhkavmQLoscve27DzOuxhZMkGM42cwuw4PX5p0Zwu653eNkBHGr1MuM2Y3iN9SOHMbYa/Crr2KmkdXpL3I8iv1ObbjvP18JwtIuw7jd1y4W2Osty31DeDCksfo3nwseVkRp5+MUBmPD2xqrddrqMpYxnpNv6f0lrcPy7Tnjo16FJehIpw9il86f5XUGJlYpU9S+OBaHuJ+1Be
 H4kI2diw
 vmnEb/NyC5T5UdrLlZ43SmWD3BUpMG+vmPFkc1QEbgGjXWNEuTPMQFvWTSJgKTxD27rwyuVMFhR84ZbMCTdwsaTK9e3Bge3Jp3HMILwu4G7dpfD1ZkzkzZK91Pl/m1X111orClpaU61opUrFHbA7Mgbn5im+f+W0H72MJF5cqQ9F2jWSHRAlStFcO55DxiMtWsF39vDTIzmwHwYj4AXI4FCD8DaJQop2K2apUOdR1xZjMGhkGn6RMGnsi7N3Z91JDz3uW7mjT2ysySZFj7/UJ6LOYE2gzc5nQdZIsH6UR7pvABEfZhOyV4CpEwrrLzNfipxg97OMO6aHqVzWZGS9h/HNzmvKEiN7TSeOR4++cJmzGiCSC1YfscjFCp73yLMiQQrswXHoLPZtIcE6ouDPcnCF0qfD1DIRUXHSeC81W7wMR38I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 23:09, Matthew Wilcox wrote:
> On Wed, Nov 26, 2025 at 08:33:47PM +0000, Lorenzo Stoakes wrote:
>> 	if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
>> 		/*
>> 		 * If the VMA is now detached which means we lost a race.
>> 		 * Let the caller know the VMA is detached.
>> 		 */
>> 		err = 0;
>> 	}
>> 
>> That gives a _lot_ more information, keeps it relatively top-level, doesn't
>> make undue assumptions etc.
> 
> Here's what I now have:
> 
>         if (err) {
>                 if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
>                         /*
>                          * The wait failed, but the last reader went away
>                          * as well.  Tell the caller the VMA is detached.
>                          */
>                         WARN_ON_ONCE(!detaching);
>                         err = 0;
>                 }

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Thanks.

> 
>> > Are you satisfied with the WARN_ON(!detaching)?
>> >
>> 
>> It'd be super weird to reach that code when not detaching so sure, think it
>> should be VM_WARN_ON() though since the code would be horribly broken if
>> that was not the case already no?
> 
> The other places in this file are WARN_ON_ONCE rather than VM_WARN*, so
> keep it consistent.


