Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4648CFD316
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 21:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512336B0007; Sun, 23 Nov 2025 16:22:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C23F6B0008; Sun, 23 Nov 2025 16:22:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38ADD6B000C; Sun, 23 Nov 2025 16:22:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 228DA6B0007
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 16:22:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 800FA1601A5
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 21:22:52 +0000 (UTC)
X-FDA: 84143146584.22.91B4B0B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 03420180012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 21:22:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RNP3aJtW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0h2S1bYj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0F8Q9px4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JQPjinlT;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763932970; a=rsa-sha256;
	cv=none;
	b=T6oDBw0wKJv61CUsI7mLP2jmN3v0ZL+oM/g64Qau9MGrqhhSdEmu54QaUSA/ylqCX4Rrzi
	JkxB1haK7q9b8l/uEPh5uuRCgJlU7UTx67K7N5uUCAXdMpWJ1XfpK1o3KHtCOYSveaonN/
	8TBYRs7MqmjwMy8YWpSOXexnU82egdA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RNP3aJtW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0h2S1bYj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0F8Q9px4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JQPjinlT;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763932970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOmS342llcEy3+p8t1kki+y8kc0JEBIGjFMmoV6NoAQ=;
	b=lMfwrJBUM54VxAvldaPzaYl23sYoMzS0Y5OgTL1YN6KJz965L6sjPcqGHyvfY9o9xfoXao
	emvsKsWS7JSbp1gAsG1ihHrLq4G4/EWpeuzerXFqoFzECcdP7Li077FZc9+k0gjjiwXEpm
	K5VrVPqCEGQsufCjlGX66BgR5ivnHWM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E43F25BCF3;
	Sun, 23 Nov 2025 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763932968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AOmS342llcEy3+p8t1kki+y8kc0JEBIGjFMmoV6NoAQ=;
	b=RNP3aJtWYC4oREHr9XiUg//yaXZniWbmwvUGJT0v7LI9E4qGWQ+kP6f7OiAC6CWptDrhRe
	eO4irrrVBh3pf2gWJvK/6gkKHus4yEeY3SGzKWHePTATLYwDNDZ5fxEi+0cPTawkdjvEGr
	0TI+D7yKzULYVRkKuBvJr9nXE906Txo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763932968;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AOmS342llcEy3+p8t1kki+y8kc0JEBIGjFMmoV6NoAQ=;
	b=0h2S1bYjTaDDa2LB7t4b5vBzZ7NV2yli0M1xaPGn6hNDm2RtCiEXz6SGIZONB0NMC6IKsA
	K6nzBLcSRcZoSfAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763932967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AOmS342llcEy3+p8t1kki+y8kc0JEBIGjFMmoV6NoAQ=;
	b=0F8Q9px42zeo8mZnMEQw0DZTRhsx4krYP/VW7n+grDAsqCrTGf2RVjn6ng5SBnkESnbqNJ
	7kR4ypeWjQXgNW4TCABpEampN+65KunLfYtCpX69kZM54nQKTQK55dEiDryTTY+oEZp/aM
	55QzCv3kIW0Q9ostViVN57LAm146STs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763932967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AOmS342llcEy3+p8t1kki+y8kc0JEBIGjFMmoV6NoAQ=;
	b=JQPjinlTZ2Hdsxdih3gKE+aUqq27zFsbv0LPY+kTR+9zme3CYBRsn2sMNEJevunrIzgRCC
	YrSaEGS6R4Ji4iBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B19013EA61;
	Sun, 23 Nov 2025 21:22:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /4X/KSd7I2npUAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sun, 23 Nov 2025 21:22:47 +0000
Message-ID: <23fac529-7b4d-4095-8c64-0d4a9d08c9b1@suse.cz>
Date: Sun, 23 Nov 2025 22:22:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251113084022.1255121-1-hch@lst.de>
 <20251113084022.1255121-7-hch@lst.de>
 <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com>
 <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz>
 <566ce586-4d53-f2d8-50b6-1f884f44d2c9@google.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <566ce586-4d53-f2d8-50b6-1f884f44d2c9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 03420180012
X-Stat-Signature: ifbw3r991imsh9g956quidtkabdwu6jb
X-HE-Tag: 1763932969-142937
X-HE-Meta: U2FsdGVkX18+RYEJzq72drPnN8QfWjLmaYU2rjYbDB6qUPhvQ4/TE0Kl/DEjrBipDe8oHrALe+HiWLiaK9kuEdD8XG58NNQqJVNTLDA3vur44XHcVIw1CHTN/pVVqCA2acnFtTTzarsEeUzHtnnK7D2Tr0wq1SWnAzlrOPQH9HpVaA5/UyIfn6gtPwnVnCuuyxnSWfZy0E21bXCORKkl5AxERrPJp4FGAnFsg4rkbUFpO7VZZcwx7nkDq48mVTDvg9gkofod/ri6n1gMlDuLzgKXe5kpnNFdPWURVhMo9iqnF4g/+wQPSuiW1M8pI/zcw1Nh1R8eAwtxhUV26rHHMHaNIbnbXqLNXZy0r3kvjxFEz3OUBlpb6h+GlOtyZ+0Y7xH2/2XqKoRC+2QbXj3Vvgyqtd6TTR8tKEtB4PxKdVv7NtazOI7lwQ9Gr6yff4a+xCR8lkP7cJ76dok/KtD/XTpsmG18TDMqWkbh2Y0JWVizJ95V0KfDqoI7scdhY1v6LFUDJ/lnspIs1RXshxNZ68MNDrUMhF1rm+TSdkIhsg+YSmu1CfMk+e9VP1otpCrFZwU0ex3lWp/zoZDGs8zU6xS7v5/Zz6J3rmGi3IfJb6weYfW9jNg3VD09U75/AnADlyHR7qc9QHNl58lvSwd8rrPNCr0cWxZtqX+XcC+0PDK5D1cYuwS3qxQx/Jidm+4L6szZUfhtGJdSqtAe+gr4shX3Vc3pg8PlMXMdje8X4HDHClhKnyHt6axGHnS+53DWOlQpwEPDbM73FTyoMZpH0bZP13R/Yza4kSovRsUq/bBdj25I/so7tcoeLKJb5Oa7HsNxrjAAygLTTW+slb/FnUiBUGcNzVYHZIRobBx4sxgTd2wrW00jsGqNKN13zf/WKCiOh8Di8La0v4+it9Qm6taMo5lv2nPBgBxa6q+crCOZfAChgiuptyiSuerRUekemWvgEXiNyE9sJb4H3FC
 +2t5iOu6
 HlPe2v5RN0sYZizkWKDpZeDdJfeJtfgrNPpt+n0+M+/q9lLtQrGa00ngqJcpB3BZr/aHMnW72VOAZ2a5fadrdWG4ZQUzsMQDHqSlapUYEeSOVteMBwQtpt7I8DZSFw/PwLDK+4giXFGuSOI3Yp59GK49sHO8CRFEyfkjJdYtUs2amNPOapz6DIZESnxDMNc0oaqDVf4gd4AYYWH1YYSuEsAxzDRiWdO+pjinn0OUrSRDsHCT3n+g4/obc+scoz+wv5YlBrjtIl74zqsIhPgQVinC3VrS1ChaIGFI6AyKmBat6yr2/O9ANjm3QdyRPUvccVQxAPlBf3pury0w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 18:49, Hugh Dickins wrote:
> On Sun, 23 Nov 2025, Vlastimil Babka wrote:
>> On 11/23/25 04:42, Hugh Dickins wrote:
>> > On Thu, 13 Nov 2025, Christoph Hellwig wrote:
>> > 
>> > 
>> > No, that is wrong, it breaks the mempool promise: linux-next oopses
>> > in swap_writepage_bdev_async(), which relies on bio_alloc(,,,GFP_NOIO)
>> > to return a good bio.
>> > 
>> > The refactoring makes it hard to see, but the old version always used
>> > to go back to repeat_alloc at the end, if __GFP_DIRECT_RECLAIM,
>> > whereas here it only does so the first time, when gfp_temp != gfp_mask.
>> > 
>> > After bisecting to here, I changed that "gfp_temp != gfp_mask" to
>> > "(gfp & __GFP_DIRECT_RECLAIM)", and it worked again.  But other patches
>> > have come in on top, so below is a patch to the final mm/mempool.c...
>> 
>> Thanks a lot Hugh and sorry for the trouble.
>> 
>> Looking closer I noticed we're also not doing as the comment says about
>> passing the limited flags to mempool_alloc_from_pool() on the first attempt.
>> 
>> I would also rather keep distinguishing the "retry with full flags" and
>> "retry because we can sleep" for now, in case there are callers that can't
>> sleep, but can benefit from memalloc context. It's hypothetical and I haven't
>> made an audit, but we can clean that up deliberately later and not as part
>> of a refactor patch.
>> 
>> So I'd amend this patch with:
>> 
>> diff --git a/mm/mempool.c b/mm/mempool.c
>> index c28087a3b8a9..224a4dead239 100644
>> --- a/mm/mempool.c
>> +++ b/mm/mempool.c
>> @@ -478,10 +478,15 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
>>                  * sleep in mempool_alloc_from_pool.  Retry the allocation
>>                  * with all flags set in that case.
>>                  */
>> -               element = mempool_alloc_from_pool(pool, gfp_mask);
>> -               if (!element && gfp_temp != gfp_mask) {
>> -                       gfp_temp = gfp_mask;
>> -                       goto repeat_alloc;
>> +               element = mempool_alloc_from_pool(pool, gfp_temp);
> 
> Haha, no.
> 
> I had got excited when I too thought that should be gfp_temp not gfp_mask,
> but (a) it didn't fix the bug and (b) I then came to see that gfp_mask
> there is correct.
> 
> It's looking ahead to what will be tried next: mempool_alloc_from_pool()
> is trying to alloc from mempool, and then, if it will be allowed to wait,
> waiting a suitable length of time, before letting the caller try again.
> If you substitute gfp_temp there, then it just does the same pool->alloc,
> alloc from mempool sequence twice in a row with no delay between (because
> gfp_temp does not at first allow waiting).

But it's not exactly the same sequence, because in the second pass the
pool->alloc() has the original gfp flags restored (by gfp_temp = gfp_mask)
so it can now e.g. reclaim there. It's preferred to try that first before
waiting on a mempool refill. AFAIU the idea is to try succeeding quickly if
objects to allocate are either cheaply available to alloc() or in the pool,
and if that fails, go for the more expensive allocations or waiting for refill.

AFAICS both the code before Christoph's changes, and after the changes with
my fixup do this:

1. pool->alloc(limited gfp)
2. allocate from pool, but don't wait if there's nothing
3. pool->alloc(full gfp)
4. allocate from pool, wait if there's nothing
5. goto 3

Am I missing something?

> I agree it's confusing, and calls into question whether that was a good
> refactoring.  Maybe there's a form of words for the comment above which

I'd say it was intended to be good, apart from the bugs.

> will make it clearer.  Perhaps mempool_alloc_from_pool() is better split
> into two functions.  Maybe gfp_temp could be named better.  Etc etc: I
> preferred not to mess around further with how Christoph did it, not now.
> 
> (I also wondered if it's right to pool->alloc before alloc from mempool
> after the wait was for a mempool element to be freed: but that's how it
> was before, and I expect it's been proved in the past that a strict
> pool->alloc before alloc from mempool is the best strategy.)

I'd think we better do it that way, otherwise se might be recovering more
slowly from a temporary memory shortage that cause a number of tasks to wait
in the mempool, which would then have to wait for mempool refills even
though new objects might be available to allocate thanks to the shortage
resolved.

>> +               if (!element) {
>> +                       if (gfp_temp != gfp_mask) {
>> +                               gfp_temp = gfp_mask;
>> +                               goto repeat_alloc;
>> +                       }
>> +                       if (gfp_mask & __GFP_DIRECT_RECLAIM) {
>> +                               goto repeat_alloc;
>> +                       }
> 
> I still prefer what I posted.
> 
> Hugh
> 
>>                 }
>>         }
>> 
>> 
>> With the followup commit fixed up during rebase, the diff of the whole
>> branch before/after is:
>> 
>> diff --git a/mm/mempool.c b/mm/mempool.c
>> index 5953fe801395..bb596cac57ff 100644
>> --- a/mm/mempool.c
>> +++ b/mm/mempool.c
>> @@ -555,10 +555,14 @@ void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask)
>>                  * sleep in mempool_alloc_from_pool.  Retry the allocation
>>                  * with all flags set in that case.
>>                  */
>> -               if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_mask) &&
>> -                   gfp_temp != gfp_mask) {
>> -                       gfp_temp = gfp_mask;
>> -                       goto repeat_alloc;
>> +               if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_temp)) {
>> +                       if (gfp_temp != gfp_mask) {
>> +                               gfp_temp = gfp_mask;
>> +                               goto repeat_alloc;
>> +                       }
>> +                       if (gfp_mask & __GFP_DIRECT_RECLAIM) {
>> +                               goto repeat_alloc;
>> +                       }
>>                 }
>>         }
>> 


