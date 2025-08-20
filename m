Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0339CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 12:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556136B0005; Wed, 20 Aug 2025 08:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C606B0008; Wed, 20 Aug 2025 08:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442066B0007; Wed, 20 Aug 2025 08:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 311C58E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:42:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C28DB1388D6
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:42:19 +0000 (UTC)
X-FDA: 83797098798.07.742DDEE
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id E32361C000E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:42:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JdFQa8PZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755693738;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIg9W/3Kh0nknE9bg10iXxQ5gJtP6ZAIJOJFszr9STA=;
	b=0Myat8C7pPnZ1PoekLA35EWSuCRl58NaUq1Alo45iB5rLiL7Uq/wQmH1eh1BnFmnx0nve5
	n2ImRDKkirKYtw9T70wt3RlY7wzpktaP8sLSOpUmh44i6ZO2qW2wqZJgYJlebEp35yTna1
	L2IB38SCOJzZosTE2APJ/M6r90YQRfQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JdFQa8PZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755693738; a=rsa-sha256;
	cv=none;
	b=G+nHw1kviUmpobCZYNnSapIXAMmva/z8ou0CEE2ObZ5ZSlTH6FKcve/DyVHmqpXVJEzX7q
	C2k8STD8BK7nyjO6PoyIXPu3aLEH3IjpR1SqTf+4WKkvxZ24J8qBM2xymmZvpRaFVhPbkl
	KfdCBGawjLulCHd93oByrnYg6y3fnYg=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6188b5b7c72so8674444a12.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755693736; x=1756298536; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIg9W/3Kh0nknE9bg10iXxQ5gJtP6ZAIJOJFszr9STA=;
        b=JdFQa8PZOPnI6PtOfPVwWNag8Bjjow12PqR7SbWzZhle06mo+dM6HgiHQPlA1Qpw5E
         A84XdJE4Axoy4MN59wVLu/2/j3xNY87qYqELASwBZ3g8caR+1zqNuW3k9nWKiJBohPng
         1O7vad6SRrR629FpYgBrgtcUONKTeHHW+ZYN8ECrVNREyja46WGCTwe79LV9hKJ6xytD
         ynohHCWedbF3oeGeJ3K/r8Zhtee8wZcFsEj5xw7vbXVhcs2ecbqp2+xsqVPQos8YYXF7
         dvdRLGgRhW6Vd4vSEEUeRo4XY++C5fRnSi00ZAH8ol6xCKyqmk/DmxgZwQ8XWGjJCtfG
         imEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755693736; x=1756298536;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BIg9W/3Kh0nknE9bg10iXxQ5gJtP6ZAIJOJFszr9STA=;
        b=oZyBQwpzu+ddWYZXozCyRxTynBjgbboDjQD0oL6IvoPgU5nw/h5IRbg9AHs9fI7Xc6
         pZ5D+EGYswW6LwVdV//huKX1IjX0sBwT+MydL2Lpf+Nan9aG4LsJakbREJ6DEVzo6N5q
         WyRNWm0rswnmqx8rsXVoGWussj98xyMh3NRS/pYXVETKjMeycRX8K9kp9ZGBmTvFVKOu
         G027YJruYshDF9W5Ed5Xn/CEJwRHdzMqZKTsKzWum8qoG4uNiiquIwhghgTFHNw72FA6
         eUmEq90RNgmxCHyhZ5Yb59TLkDALXU7cmOhAdLCrn+6vh/mBuEsH60kWSLCx0dJ22KIs
         Ex4w==
X-Forwarded-Encrypted: i=1; AJvYcCUqCbE4CGjgAx1UW3iaezWk2vaXe50utwaWj/8+sTO0qyV1HRL1LaLCSP7JIttL8P7HNnsVcJOo5g==@kvack.org
X-Gm-Message-State: AOJu0Yz9SmAx0WFBmk1maPiPvdO7e34KxIa3T0l9FUTR5HxMXspf/TlI
	CGVVqNNjcBZOu3LyLvpdnD5JhKQafePYDTSTMDNCwJGxmyxR+C+rR8mK
X-Gm-Gg: ASbGncsLoBQ8CoVsXmms1avcebL9ld6SwULPUux4yxM0aUzTo+Z9OG1t4mQvJFv7/9O
	Mq3Oowv904sw06ibeB44kvRGvYVl9NH0fZEHeMoYKZPYNGof150DUwPk9ZBuGhKb2J9QDDBe3NO
	A8T1O/6bHGSYoSO0LZMqK3I80JKFala3EQuxQ+vXy/lTDYsk/ayaBeGuRzfMulyALGvD2PWO1rK
	NKpfZOtLazgr2TCv0oRnIyKNZqz2nHsvDnKT1PWH+R4GVKnamRjggoFb1s31kjdvEkNZLYY8NEi
	2tYfZAaGrLFEltuliIsRI6wWp+mwC0qHX8htMkTBrJc66X1eu3TlDd7OzThleiwa1yzkd1hqVIu
	S6hilncN0josfZTaFnd5qbHSreAi6QW9oMaJL
X-Google-Smtp-Source: AGHT+IHHRa/Wjm92m9kTtxGRWzJ7agHg8ZuSbyEGNlj7C81CaI3UVA8ffbMZiBB1+byaZJtVfu6Ixw==
X-Received: by 2002:a05:6402:4306:b0:618:aed3:38a with SMTP id 4fb4d7f45d1cf-61a9782d02cmr2281770a12.31.1755693735970;
        Wed, 20 Aug 2025 05:42:15 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61a758bff1csm3633444a12.56.2025.08.20.05.42.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Aug 2025 05:42:15 -0700 (PDT)
Date: Wed, 20 Aug 2025 12:42:15 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 1/4] mm/mm_init: use deferred_init_memmap_chunk() in
 deferred_grow_zone()
Message-ID: <20250820124215.igq7ug4juiomjyng@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-2-rppt@kernel.org>
 <20250819095223.ckjdsii4gc6u4nec@master>
 <aKRX9iIe8h9fFi9v@kernel.org>
 <20250819235158.mgei7l4yraheech4@master>
 <aKWTSq-JcTviuGlU@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKWTSq-JcTviuGlU@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E32361C000E
X-Stat-Signature: 9j1mgedkr6cikpuskoudsx8u8ezo6snx
X-Rspam-User: 
X-HE-Tag: 1755693737-694701
X-HE-Meta: U2FsdGVkX18ecaJ3KFrxRpo2AsMLnzYG0v1UluAp3mZFaG8HDqTBy7pgc88z90QjxOcYCkPWSE4gBHG8OXxHQ9t7PRxAKmnz+Uf6jihSxoMBmrxqwd0cSgFnO4B6y9C+ylhBdkhvOArAuGHf31XeZVxdxAidqM2g51Kp29b9QyDkevztW3/wz0l3hxvSUAhOHpesojX8oIjoFUci3eiGMGoCTA6nRkam65rZ6BzK9dp8l27Jrk7p1RelQ592ne1QAm429jY+BAIz1OpC5f2YnFTA62HKgUqpqpbwUYgS1UJXoaG6lL5EEGotMY6TDSDAFzy6q3ezLCYw9Qi9UG57NSJGFwAfjdmGjbZuXsPc1PVwNULqFQdoU2TKiDIq45m3MAbyfdyBO5TrCEEmcy0pgIVRZWh6i2IX6eD4s9JvgcRVJ3dUgR6k9QuOHXVYtXhixYWoqIBzrJSADHi9KFbI4X0XtLuB1QA1GQYOprXC9sNEsqTIl8tju2scqMlD4ihJ+thHsFgJCoeyoqDZoRvPhO4fQHY7o0u49eDhDLEeU4CWZAV+S9tyM25DJuEso+SJo9On00J+U8NjhLyYdgEULbTL4lATVt9PfypvQNC0KhmzdYtKlDzX1oPfmElyV+y8s5pWvho+agXkhGd8SUMPgXb6GsKoW0cuFFFESN/pf/Q/HC3Xka3nTxxiaMN40pihoPpqgFaU0qBBFMZXun2dUF715j8T/Tmeyup6m7swnRq5FHNNkXaL+tDVP7MKbeFaUlY6J7VKK52x1rEkuRrtMW21JsvBxdRIknSenJls6Ejt1sNBENyBXzX+gNYOWw6ekw3SaGktkeGSzzn33aWMjUiJumHu07LtzOTNEPVYwWgMIX8DvpHEs7NVTmFK+hr24HSl+IhynGUomvXkc013wL9XfeDCm4Vub1OpSGMee4ZhPmKd7IvWGIq8rRjqGwlvATVu0Mtolk1WE6o9Bgb
 SK5a1bWb
 YR4cb2TG9nWwTDpX1qx6u/QR+jgFNQhKQCrMaC96c0+ha36T/2DueJeiEIPzyf4dmj9hyCdNUJaHQjekfKp3I06KZDBLTwmkP5r3sfjpx29kinH6KdpG/KmoRLywK2naB8etuNSFmEoCUpP27mDwN7I5HTW08W5S8ydT+Sougq4v4W/CtJ8CUIAcqy8WtsbFbzm8JPU6ZkeVqYwCCqRqhWn4tKHP7/b9rWxtwQVN8FK6BKKWFLsENnofX1x6OkmBlk6teQU1qKwdWwY6NV8iC0JhOY91A12rydELF6Q/jeUtpjfmrEEH16rbxiBvrXtaD29yN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 12:20:10PM +0300, Mike Rapoport wrote:
>On Tue, Aug 19, 2025 at 11:51:58PM +0000, Wei Yang wrote:
>> On Tue, Aug 19, 2025 at 01:54:46PM +0300, Mike Rapoport wrote:
>> >On Tue, Aug 19, 2025 at 09:52:23AM +0000, Wei Yang wrote:
>> >> Hi, Mike
>> >> 
>> >> After going through the code again, I have some trivial thoughts to discuss
>> >> with you. If not right, please let me know.
>> >> 
>> >> On Mon, Aug 18, 2025 at 09:46:12AM +0300, Mike Rapoport wrote:
>> >> 
>> >> In the file above this line, there is a compare between first_deferred_pfn and
>> >> its original value after grab pgdat_resize_lock.
>> >
>> >Do you mean this one:
>> >
>> >	if (first_deferred_pfn != pgdat->first_deferred_pfn) {
>> >		pgdat_resize_unlock(pgdat, &flags);
>> >		return true;
>> >	}
>> > 
>> 
>> Yes.
>> 
>> I am thinking something like this:
>> 
>>  	if (first_deferred_pfn != pgdat->first_deferred_pfn || 
>> 	    first_deferred_pfn == ULONG_MAX)
>> 
>> This means
>> 
>>   * someone else has grow zone before we grab the lock
>>   * or the whole zone has already been initialized
>
>deferred_grow_zone() can be called only before deferred_init_memmap(), so
>it's very unlikely that a zone will be completely initialized here. We
>start with at least one section with each deferred zone and every call to
>deferred_grow_zone() adds a section.
>
>And even if that was a case and first_deferred_pfn is ULONG_MAX, the loop
>below will end immediately, so I don't think additional condition here
>would be helpful.
> 

I think you are right.

>> >> I am thinking to compare first_deferred_pfn with ULONG_MAX, as it compared in
>> >> deferred_init_memmap(). This indicate this zone has already been initialized
>> >> totally.
>> >
>> >It may be another CPU ran deferred_grow_zone() and won the race for resize
>> >lock. Then pgdat->first_deferred_pfn will be larger than
>> >first_deferred_pfn, but still not entire zone would be initialized.
>> > 
>> >> Current code guard this by spfn < zone_end_pfn(zone). Maybe a check ahead
>> >> would be more clear?
>> >
>> >Not sure I follow you here. The check that we don't pass zone_end_pfn is
>> >inside the loop for every section we initialize.
>> > 
>> 
>> In case the zone has been initialized totally, first_deferred_pfn = ULONG_MAX.
>> 
>> Then we come to the loop with initial state:
>> 
>>     spfn = ULONG_MAX
>>     epfn = 0 (which is wrap around)
>> 
>> And loop condition check (spfn < zone_end_pfn(zone)) is false, so the loop is
>> skipped. This is how we handle a fully initialized zone now.
>> 
>> Would this be a little un-common?
>
>Why? The important thing is (spfn < zone_end_pfn(zone)) is false, and I
>think that's good enough.
> 

Well, no more else.

>> >> > 
>> >> >-	/* If the zone is empty somebody else may have cleared out the zone */
>> >> >-	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
>> >> >-						 first_deferred_pfn)) {
>> >> >-		pgdat->first_deferred_pfn = ULONG_MAX;
>> >> >-		pgdat_resize_unlock(pgdat, &flags);
>> >> >-		/* Retry only once. */
>> >> >-		return first_deferred_pfn != ULONG_MAX;
>> >> >+	/*
>> >> >+	 * Initialize at least nr_pages_needed in section chunks.
>> >> >+	 * If a section has less free memory than nr_pages_needed, the next
>> >> >+	 * section will be also initalized.
>> 
>> Nit, one typo here. s/initalized/initialized/
>
>Thanks, will fix.
> 
>-- 
>Sincerely yours,
>Mike.

-- 
Wei Yang
Help you, Help me

