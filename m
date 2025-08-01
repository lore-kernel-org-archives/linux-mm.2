Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27DAC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A4A6B007B; Fri,  1 Aug 2025 05:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5716B0088; Fri,  1 Aug 2025 05:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ACBF6B008A; Fri,  1 Aug 2025 05:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC89E6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:22:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48D4D81BA1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:22:19 +0000 (UTC)
X-FDA: 83727647598.29.FF368AC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id D87D440003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:22:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uUf/6dcX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFV0lfmc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uUf/6dcX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFV0lfmc;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754040137; a=rsa-sha256;
	cv=none;
	b=7zttQpM+35ABba3v719Hjpr79gaUg6+mHpvLSAwQjld+d0toWn/YFqaHzfJuS1qdnHFWRF
	Ur2Fk5Qtr89bcn5uBD7d2VRk6J2i7IagGY/ubsGhj5NOQ8v5NLtENbm8h7Pwe2KqxIoygf
	F7+AI/ovvqvbG9uUM9fVt7HrB7tkanQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uUf/6dcX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFV0lfmc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uUf/6dcX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFV0lfmc;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754040137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9awpCXb1LKtJUXfqyXMkzip6Tg7ORwMk1sJ+IoJaYGg=;
	b=H5Znm2dgjbCrljSbGDxfsaaAh3N4iXgnBK2OwEVbPOYeYiHEZrWiFSlY6yruu/tuR7oNTU
	u4etbVPp8FVs7xWg8SUBNHG21aPIfMFh/KBwlE2kU13Shkp+z5JQ4CpNnuDRtJm0h66W7t
	ysRLR7P5IlSP1TkoMvraPG/v8Pk943c=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3360C21AB1;
	Fri,  1 Aug 2025 09:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754040135; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9awpCXb1LKtJUXfqyXMkzip6Tg7ORwMk1sJ+IoJaYGg=;
	b=uUf/6dcXKDZUw7tRDlDBk7SMNyye61EgucXaOHBrt/TRCIhDh8AbwNtyZirA8a081b6Zu7
	qulAwsBG78Bum+FFCSMmjrBwBvDokxWj+eUnSglrMd1/LPwdUmkWh+jwVhpo8hHyiWNK+v
	cq2vvNvQ+4PBLQad2eEnmDa5MPwtknA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754040135;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9awpCXb1LKtJUXfqyXMkzip6Tg7ORwMk1sJ+IoJaYGg=;
	b=CFV0lfmcpYkpVlwWUZpndvnUqHc6X0QErhmPO6RkUtb5tb0DjdXMuypObUhHieWswptZXK
	psZcBnwCP+rTdqAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754040135; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9awpCXb1LKtJUXfqyXMkzip6Tg7ORwMk1sJ+IoJaYGg=;
	b=uUf/6dcXKDZUw7tRDlDBk7SMNyye61EgucXaOHBrt/TRCIhDh8AbwNtyZirA8a081b6Zu7
	qulAwsBG78Bum+FFCSMmjrBwBvDokxWj+eUnSglrMd1/LPwdUmkWh+jwVhpo8hHyiWNK+v
	cq2vvNvQ+4PBLQad2eEnmDa5MPwtknA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754040135;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9awpCXb1LKtJUXfqyXMkzip6Tg7ORwMk1sJ+IoJaYGg=;
	b=CFV0lfmcpYkpVlwWUZpndvnUqHc6X0QErhmPO6RkUtb5tb0DjdXMuypObUhHieWswptZXK
	psZcBnwCP+rTdqAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D1C913876;
	Fri,  1 Aug 2025 09:22:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o1w0AkeHjGiHOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 09:22:15 +0000
Message-ID: <6c81ed5c-32a6-4b4d-8468-770e0d375b00@suse.cz>
Date: Fri, 1 Aug 2025 11:22:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/testing/vma: Fix function parameter declarations
 for GCC 8.3 compatibility
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: WangYuli <wangyuli@uniontech.com>, akpm@linux-foundation.org,
 Liam.Howlett@oracle.com, jannh@google.com, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, niecheng1@uniontech.com,
 guanwentao@uniontech.com, Jun Zhan <zhanjun@uniontech.com>,
 linux-kbuild@vger.kernel.org
References: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
 <e7554f93-03e8-4315-acb7-a55312354485@lucifer.local>
 <CB890ABC56C2FA67+56b95783-ed70-4744-9fc5-f2d93ddf2c12@uniontech.com>
 <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
 <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
 <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>
 <671CE9DD76801AE4+34f3e3b7-4684-4fe2-80a9-93de1dde9c31@uniontech.com>
 <20baf9ac-9328-4110-97f1-91e9e76b8914@suse.cz>
 <27488afa-1d53-43eb-bc68-8e950d804000@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <27488afa-1d53-43eb-bc68-8e950d804000@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D87D440003
X-Stat-Signature: wee4dn1hdo41gezdijh6ippit9xibrz1
X-Rspam-User: 
X-HE-Tag: 1754040136-508687
X-HE-Meta: U2FsdGVkX1+pdcPdHfzglgTPkTHQd4SQnSth/Kbjkxfjwu2N2kI6WxRSLq+8VwZrDSxTKArBnsWLkiWxLCzSFBpX3K8lE7RZmpWNGMQ4qNZozc58kKt5PptMbWe4FKpFeiZIboG8CrDl7jm2hcNPOL6jhMdIMwVrPY1CD+OpSbtnaGu3+nRFuIEASSlxEQCSNQpZ5bWk0ahVqo87NT2dqoInsrHsG+QaEVVgJHzrG58gZWeXCMU3GIfO0TtY7Jw8jZwQZxJsaXgUG22q1JhUXrKqAtf82sXFa3HAkhjvCmgQCoOTRwLk8RvEQXCvcVCSKf9ZSDWx4s11o2NdV7T+6BUVtSBt5IpHXPs4lu01kTH1etSu1DuJV+v/MPWnEhPmRfX9vWBQItteR9uwFVsrwZejbW2TGQXCMCIGdnMwo+7gxgfT4Az+Nx8FX/Kc+cVqw2cLOkKgK54k6PQcuts6bcnKb6FsjYv/0dYvLt0pdBuCNJvDvotlGOKE6JOamUC0yUyN1uZMtJ+MsW9o6hAaV9q58c0buge6nDhvD5mx1q5/ON+0bReSE9gO+OyMKJsEP+8AY6ln2ld2LXoMhJuLxVt99zAbqoh1MhGiEgwOaNHo9x7WUuexL3oKAtihcQmr0kqWSO5+csEMZQiyZOsHqMwtOkMIgbWC3NUr5CXefQuZ/DtwiwAIISx70/gVPr88l2Ge7jfj75UukDYwS/gwIdIr4kL+qTvPsUYOZCkT/Cdvwg3qEqbRD4c2mW9mXx4lRrV7W73775zm3HQLm+2bT9wItnE3+cxb9UJvDS0ToZycNe4AqEFqKW6L2zptpnjfVoj3Kv+rDBJrvDZRYUeXkuXQNJj0S0iDtZOUwQUTgAmkNnyhCqaVnjxd4YrtW4CQpFQe48q/fi03uT2ZOwRzDHzAMwzo33plrrU2TjDlyBtfxX6ClFb63mLgM8xcu8g8Y/+XwTDJdp8Htle5p5g
 RtCKQbpq
 uY522PIugl7CPCwUUQrKJWJ0yLEZp+awlsjFp1Y91F2qwcFSGk45al8NRTkS6dciWMv0qoxVnKFkTelaWWkZGswHgmsnqxXn0LzpyQxfzLcMQiap8YM4Q1Mk//ZaSQDcaqz65Tal03UOnTp+uYUz5pKxL6lZf5oi+peaxZjTELVN2LboBPL598nRmSqtIazwojJ2EnxLvy7DsRrtHM6t+3B+YaHeGgAAobF0d+pa+Q7EEyxzfls8HfCQAjEwiK/SBvfC49ZAhqLp4MkysAcNdmTpLJzhNpzdZV+z5LMwHcAs6A7AJq+QaGm0wNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 10:50, Lorenzo Stoakes wrote:
> On Fri, Aug 01, 2025 at 10:04:11AM +0200, Vlastimil Babka wrote:
>>
>> Seems like newer gcc versions got more lenient. Haven't found why, but seems
>> they want it to stay like this:
>> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113825
>>
>> But I don't know if there's a way to make older gcc's lenient too.
>>
>> > I'll take another look.
>> >
>> > Thanks,
>> >
>>
> 
> WangYuli - apologies - this is my fault entirely, I misunderstood things
> here.
> 
> I was wrong to dismiss this out of hand, I guess not many headers are doing
> stubs like this, and I mistook this as being a general thing.
> 
> Could you please do a v2 where you add back in parameter names (and add
> this compiler flag - I think we still should),

It would be safer to add the compiler flag indeed, as we are including files
from mm/ in vma.c here, so if some change in mm/ files makes them rely on
syntax permitted only gnu11, we'd break the compilation of the test.

Also please update the commit log to talk about function definitions and not
function declarations, as that turned out to be the important detail. Thanks!


