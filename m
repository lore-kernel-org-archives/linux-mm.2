Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C5AE7BD87
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 10:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5546B0005; Mon, 16 Feb 2026 05:32:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7386B0088; Mon, 16 Feb 2026 05:32:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888AA6B0089; Mon, 16 Feb 2026 05:32:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7144B6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 05:32:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1124BD86E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:32:35 +0000 (UTC)
X-FDA: 84449955870.26.2FF5B5A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8010E140003
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:32:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zspg3pA0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ea5l7vLg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0kBFRR9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F44EHw5F;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771237953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3PpA0oF9S1G7sG1bCXz1zk+1D4bCWgjrlu1+Gv+8FM=;
	b=ILihIfsz+FIjbz0qNJaAesq6CATLXW8rI/UOr5d5HYvt5LX9lBhpRCrxV3TJyAQoXB5tnB
	91P5ZlYjFXXHgXANUUxMsHIhJ9c4q4DTn84IyVkvIZCl5D0qyxx7cKrYWYX58OUvHzKxI6
	wVJdWsD344OpP2Kcl692akX3+KtJOYQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zspg3pA0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ea5l7vLg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0kBFRR9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F44EHw5F;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771237953; a=rsa-sha256;
	cv=none;
	b=onMjjpWlekynMeNI13MbDja3d/HEFiX++9pz6L5p14GnrO/GPhvWK6eB4UUFNf996kCjmM
	r37Whb9PYqeLbs0BE09dAUrSjjGZZ0LQ33oeiBAOr5Z43QDQEE5ZR5YfFyOmJN3ujqazHq
	xn/t9zRLUz8NdPNmJZpRPHiUebAkP8U=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE00A5BCE3;
	Mon, 16 Feb 2026 10:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771237951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F3PpA0oF9S1G7sG1bCXz1zk+1D4bCWgjrlu1+Gv+8FM=;
	b=zspg3pA01Tm44EfpVjMr7nytFxCjxI2dsEr2lJPSDKcjgvwzZc6CUJlGJNc6exgD+H5z0Z
	LjDwTBqsja6rIDDI22DQyoxfYJb0r9GFeWg2ZffHssfZXJ+XFn78AKWql90stLQbMn5iEw
	wwbHL8fsHFfHkKPvk+pvVzhvWPO8rJI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771237951;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F3PpA0oF9S1G7sG1bCXz1zk+1D4bCWgjrlu1+Gv+8FM=;
	b=ea5l7vLgdW07n2kq/s/zLUHe02dOyIeqRXqAP1hGk7TnslV39PI+xQwZ/8ec1QqbsTbFr0
	+EIWf7TKDrkOGeAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771237950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F3PpA0oF9S1G7sG1bCXz1zk+1D4bCWgjrlu1+Gv+8FM=;
	b=T0kBFRR94a1y7KpGOH1on0ZbvDhVU+SsiLEUJdQjv3i0qhVjZeQilH/QMc/H2PxJ0RHxIg
	XhCK34LoobWSoNT3buySSZXPDM0UJO0+fYJyQisvv7kSPf/Cz+kL4CaGjCbH79kiuq1sQb
	62N9f2b9UxbHlfwRPjmBXGpEFQ0AY/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771237950;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F3PpA0oF9S1G7sG1bCXz1zk+1D4bCWgjrlu1+Gv+8FM=;
	b=F44EHw5FWqBetdHu7VKINkiqP8h/Uc/pHG/o2Pa9M8cvPsZCWINAfEmbaqB63e06daZcs2
	bxTHO06l7i5nJWAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 187A93EA66;
	Mon, 16 Feb 2026 10:32:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CbVxAD7ykmmyOwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 16 Feb 2026 10:32:29 +0000
Message-ID: <104b642d-483c-48a7-89da-209f3bcd2319@suse.cz>
Date: Mon, 16 Feb 2026 11:32:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] making nested spin_trylock() work on UP?
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, Waiman Long <longman@redhat.com>,
 Mel Gorman <mgorman@techsingularity.net>,
 Steven Rostedt <rostedt@goodmis.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz>
 <aZAWGwZP_Z75YHKt@casper.infradead.org>
 <CAHk-=wg9F6iW8wuH8bCDFRJyFCdtin5bXJW5v4WjNyynD7eoCA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAHk-=wg9F6iW8wuH8bCDFRJyFCdtin5bXJW5v4WjNyynD7eoCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Stat-Signature: g44iz8g4u1kfeha5kaypq5mizdwutks4
X-Rspam-User: 
X-Rspamd-Queue-Id: 8010E140003
X-HE-Tag: 1771237953-580949
X-HE-Meta: U2FsdGVkX19cevquKKBn2uNHhiWZSRhWUzXzPpTHd+7qxahCj0qrz2LgyK8Gv1q62X+PcLa6LK6H5ROmRImXe3jG9UdeAVDXhRBWPqqbs6qyIqWREsd9r+b0ojhE9Wh9Dup+Giw6MHUYEt59b7fUzvkmiZLx0bHgGdJ6mSZzOZ7SPmQpXwoUpuovwE0odQhW0jjsQvGTFKmY8a0hScI3CziUD2pQ+2e03TsH1BWOlBsjRqvzfYgiORiXGA4zvoEcJxMvCJ3lbjkAA9uoNoZB7tPcRGgWfgzrS5wtqp3rbk+BB/5UJFd8Zim8OZU4KVkLu34aLik0loCxWvVz0oSbuTAxkMirHI1Od2S/xoglJ6/VhNN+j4ucGk04cBdyh3Yphe8YDWtKkjcMFLw4tMGf0NgSimEZheGQA5u8xQevZ0URjiH4j2/5irgnyfH8K8flpRQaDDrcjj4YhmUGchj4tSeqtUt5ilC/K/QvttfztWzXzLygtHMZDCKSh+m7R4lJl85OlFXiRBElj/d6+0O7XY2MMm6diqjy/G64zFgWpAcIl41OHLDzqfexqlNsIW2+03GzcWcp+lm0uI3WLBlT6sYv8mgGQ+nhJN8CynlWyq5uHgddMlknr2OXF4NbjR3WxStkNnca3Dm6hBrV52UyRcoiKx/v5X0MHg4ct+OYTwpmdccgpa3yXhLbcfQhupk+5bEqFyOIyQtzzsZSlm7vvLSvv9Un1N2DcoZDkqw7W1lrFoY3fDFgRgIKR4G5vZPWNaB8ItFkA1bqEjOIXl80QUmSSYwKFld/gsgYVzdggaWFw6iJZ3mrAW4aqj+CXlp3/GJ7G2PNAKLfx7xKJr1sX+ZlX5wgOc7x/yUCYwpDNn4L5NEfpDfFOGU3ivoA3l/AYVwK4Pk/ON0Hdorxn0Q73cbdW7nxwtnxZE2WEFHC5zF4iba0zDLhcqEHwrxP2ziI/Lts00FiNukpqc0F5TV
 oYH4wYIN
 smE0t4gs4h2qft6VazPDvXJjX4nBnafP6G/DSbaC4r9Dh5LUrjT37c6GGTnc8rIXQ2qdThJo/O819naSnrWOP0OMcuPrc9EPWRBly
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/14/26 17:32, Linus Torvalds wrote:
> On Fri, 13 Feb 2026 at 22:29, Matthew Wilcox <willy@infradead.org> wrote:
>>
>> What if we use an atomic_t on UP to simulate there being a spinlock,
>> but only for pcp?
> 
> Yes. Please just wrap this - very unusual - use case with a special
> wrapper that can then be entirely different for UP and SMP, and use
> something like the suggested "pcp_lock" that becomes a spinlock on
> smp, and just a tracking variable on UP.
> 
> And I don't think it needs to even be marked as 'atomic_t' on UP - the
> value is going to be idempotent even when modified from interrupts
> (because it will just be modified back), so no need for any special
> logic, I think. The generic 'atomic_t' ops on UP disable interrupts,
> which is horrendous.

I think we could be using local_trylock_t, which does exactly this without
atomic_t.

However David had an even better suggestion (in a chat) that the pcp cache
is unnecessary on UP for scalability anyway, so we can just have the trylock
wrapper do nothing and fail unconditionally with SMP=n, and then all the
cleanups I wanted are immediately possible and we'll even save some memory
that would be cached unnecessarily on those small systems (and some code
will be eliminated as dead). So I'll be going with that.

> Changing spinlocks globally on UP to be something they haven't been
> before does not sound like a good idea, particularly since no actual
> developer uses UP any more (and  honestly, UP is dead outside of very
> low-end platforms or legacy like 68k).

Ack, thanks.

>             Linus


