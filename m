Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB78CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 07:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857A48E0006; Thu,  6 Nov 2025 02:34:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82ECF8E0002; Thu,  6 Nov 2025 02:34:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7238E0006; Thu,  6 Nov 2025 02:34:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A85F8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:34:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFBF68913B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:34:17 +0000 (UTC)
X-FDA: 84079368954.18.B418806
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 783261C0007
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:34:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="m/l+Gbcu";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=byERnwAU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="m/l+Gbcu";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=byERnwAU;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762414455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDBJRtTvoCnnOc0aiPTPEM1lLCwtVnhfL4wKNZCuctQ=;
	b=Bvnzd/+XFrTQPabbWZXgM9L5noh1V3y67o1pSj6D34gHnHznAW5egcEwTBmCc9n+0KvdIf
	ncwqH3CbofuhtX+p2rV3woDR2xpjJO1ewz5WNXByKl8XreOm57ZagT+P0ThYIs/KfhSRaR
	BgDf5yQ5On30dkQhCrE4Ijameu5SnTI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762414455; a=rsa-sha256;
	cv=none;
	b=kRvpYn4CBoNxyHClJw4+ln1jqtKIlp6FWJK4/TPY0S5P+AkOz81Ly1T0k9IPUI1CIYQWAk
	lTEM6qM5z3X7X9B4J11cTmYii7nj+lDjZ9/bsk/phiLBgy3clB/7pv8A1a8DXkA3l+JoCq
	ytRz9s0I9LdZJSUQMqqydocfLsXLwRk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="m/l+Gbcu";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=byERnwAU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="m/l+Gbcu";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=byERnwAU;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 99BD71F393;
	Thu,  6 Nov 2025 07:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762414453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VDBJRtTvoCnnOc0aiPTPEM1lLCwtVnhfL4wKNZCuctQ=;
	b=m/l+Gbcu99dJ1KN2hEmwymQtbmXYX6lN4C6ipStWtJkRQwTSS7/dS0fhwI7Ft1cnCaK2JF
	Tz5hPEpQj+FPpBSKqruZvPGf+AtVo0XqyfV0SGLPQZpRz0GxVhWWkVB/Yleqmcgz5uCrC3
	gA2bTfKoVK4Ixtoi5TKKSSQE3WXnOHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762414453;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VDBJRtTvoCnnOc0aiPTPEM1lLCwtVnhfL4wKNZCuctQ=;
	b=byERnwAUdy0WQaNPyPB6BUOm4kMKhlAKOQYUCBFfWWZPQ7yqz8SPAXTkWOhBAIxqGjvBqx
	qGvvBQPdWO3oNlAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762414453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VDBJRtTvoCnnOc0aiPTPEM1lLCwtVnhfL4wKNZCuctQ=;
	b=m/l+Gbcu99dJ1KN2hEmwymQtbmXYX6lN4C6ipStWtJkRQwTSS7/dS0fhwI7Ft1cnCaK2JF
	Tz5hPEpQj+FPpBSKqruZvPGf+AtVo0XqyfV0SGLPQZpRz0GxVhWWkVB/Yleqmcgz5uCrC3
	gA2bTfKoVK4Ixtoi5TKKSSQE3WXnOHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762414453;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VDBJRtTvoCnnOc0aiPTPEM1lLCwtVnhfL4wKNZCuctQ=;
	b=byERnwAUdy0WQaNPyPB6BUOm4kMKhlAKOQYUCBFfWWZPQ7yqz8SPAXTkWOhBAIxqGjvBqx
	qGvvBQPdWO3oNlAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 69122139A9;
	Thu,  6 Nov 2025 07:34:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6P2pGHVPDGmHIgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 06 Nov 2025 07:34:13 +0000
Message-ID: <62fd6161-ea8f-4608-a536-b5b1baa19b7f@suse.cz>
Date: Thu, 6 Nov 2025 08:34:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: introduce VM_MAYBE_GUARD and make visible for
 guard regions
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>,
 Barry Song <21cnbao@gmail.com>
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
 <xnsn5rfqigbm5ryjtbf2rtfotneiwygzesvyfdxiqrzlyzljdr@tmbht4ggnjcv>
 <61ae955e-310d-488e-b350-59bb809f06e1@lucifer.local>
 <c736tssdw3z57kamh6eqc23gr575q375n2o2nnszih64afnaf7@zwbqremsbhwf>
 <053f3a04-9195-4f8d-8959-42e0c3ba077b@lucifer.local>
 <72ee2324-d599-44b6-92ce-ed0afafed78f@suse.cz>
 <3ae457cd-6c18-4870-a617-7f937b107cb4@suse.cz>
 <29c388b0-df71-4905-b434-ad7c3d5030ce@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <29c388b0-df71-4905-b434-ad7c3d5030ce@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n64q9cc7jr9gtdrmks1szej4rgq4odq3
X-Rspam-User: 
X-Rspamd-Queue-Id: 783261C0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1762414455-579174
X-HE-Meta: U2FsdGVkX1+0kHDN3VPLXazyzgNFGVEjv4ulu2zruyZSBeyFXojuJxCm4QQ4Osl3hKk+l3T8SVfZqYnkd+56vTWMcyfvUYtNv2s3Vw+GDc7lmjViPl4psYJjVm/4JBOluI+pR8JURxwu0PWEfIweyBZ5v5kY+gd+OXv39jJ4hFt9xS4PT6amxvENGAhLf5PyGXqWhvo8jYLBY+AA+S44IGzAbW7G5CJo3WI0eUZOOrqqs4FLUUqwRFFHEr007ex9YclylwjMeAdrSGBbkLSBnCBdhrsGEyianfgD0+a9CbD6EYg00sjHYPYHZI0qExKHSVjRajLeto9xE3IwGImRnm01x/26ixDihYNa5j9UD+f/W/wjjwAQrTGlcynUg2jhdp9/dkMbKmcOz+hGC8FQTTPKIl+LCaK0RtMdy+W3SLPicOO+dYFMyGzZ4QS5otSrpS+6KGJO/dq5+I7Lz5C196JH/pn3M9mPmSLCXsfZMFNU8afVYDqeCzTFVXUMuU9UTA5vKw77anQzkDxumYpxv6uXLdPLWgWyu1owF/ee1om+/S4XXI9iEMXMZ+QQ/uljzNUmIsVw88B3w8rZTeAJiObYj/2rKHNSF+uY8LWYxHlFW58/PdgvwXCwJk0LUXUex4SuozvQ4R0VR9vbT6a8thNypg0ag9hwYaPKBOUUB+rjRUzbdoqiuDjI5mWBfWf5msqJuf3LaA8cjxzI9qs73oXxpcz/mGJN8L7rSCoIb+zFmQrpCWhM3FR47cyZiFwYpriZLTqJn8H5CKbL5iyrX36+9baOkx7/DHvht4t01Oi27QSKuVWEwaD4p/Gp9jX2BCucOa/cH4UsQOGXEn8lWdHb2b7afYfjDmbJy4NFaCBsc8OE6jY7MO+uf/Ma1HHWLPI22WM5XR+9vsoS+Q8UnxxZ0VnnhI67wV6URCCHGrV6Bsw5q4+rdJ2mqDhP97XoyQ9noFFMrRSDlnz+nLl
 iSazqm/I
 WWGsM/pqwv1aPgbFXRpYB8NVstLda3oadlG4QUDfhREpldf/tpi57NlmyaZhpYUQLQX/J/bqo9Ya2gGco6ssFn2bay4sYDKsakY/T1hnA5anAKx8MGFY649Hrciq9XlrAdv90wSZH+WpEgklyFMJjS+QIM5u/T2MMQtjELSl14F9ijGWYtyifNQjD7QKrrgjXgEQBH3ulE8mihlB1Vy2C0x6AwRARSAZMDmVzXRJMutJ7/aLcxjqh2ggiI5mnZb3RisrLorC5Aa01bVrZWgHnY7BZt8yK4rlKJCNavLK6DjoXLckBJ7dCY8koXZqH36uqy8Uft87tFI2VUNw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/5/25 20:48, Lorenzo Stoakes wrote:
> On Thu, Oct 30, 2025 at 07:47:34PM +0100, Vlastimil Babka wrote:
>> On 10/30/25 19:31, Vlastimil Babka wrote:
>> > On 10/30/25 17:43, Lorenzo Stoakes wrote:
>> >
>> > Could we use MADVISE_VMA_READ_LOCK mode (would be actually an improvement
>> > over the current MADVISE_MMAP_READ_LOCK), together with the atomic flag
>> > setting? I think the places that could race with us to cause RMW use vma
>> > write lock so that would be excluded. Fork AFAICS unfortunately doesn't (for
>> > the oldmm) and it probably would't make sense to start doing it. Maybe we
>> > could think of something to deal with this special case...
>>
>> During discussion with Pedro off-list I realized fork takes mmap lock for
>> write on the old mm, so if we kept taking mmap sem for read, then vma lock
>> for read in addition (which should be cheap enough, also we'd only need it
>> in case VM_MAYBE_GUARD is not yet set), and set the flag atomicaly, perhaps
>> that would cover all non-bening races?
>>
>>
> 
> So thinking about this again, taking mmap read lock will exclude any VMA write
> locks (which must hold mmap write lock), so no need to additionally take VMA
> read lock.

Right. Of course it would be nice if we could later also replace the mmap
read lock with vma read lock. Hopefully should be feasible because
MADV_DONTNEED can do it and guard ranges perform similar kind of operations
(with more complex page table handling necessary, IIRC but that should
hopefully be still fine with vma read lock).

It's obviously not in scope of the series here, maybe just to keep in mind
if that next step will be compatible with anything done here.
> Also as mentioned later in thread, the invocation of vma_needs_copy() is
> performed under VMA write lock (and this mmap write lock) so no need to read
> atomically there either.
> 
> As per Pedro, we can treat other races as benign.
> 
> Merge/Split etc. are done under VMA write lock so there's no race that matters
> there.
> 
> The only other place we even care about this flag in is for /proc/$pid/smaps,
> but there it'd be benign as you'd happen not to observe the flag being set up at
> the point at which a concurrent guard region install is happening - something
> that you could race with _anyway_.

Right.

> As Pedro says, remaining cases where you read flags would be benign, as the
> readers should never observe a meaningful torn read being a bitmap and given
> this flag only matters on fork and smaps.
> 
> So I think just having something that sets atomically with an allow list is
> fine, but making that very strict so literally just this flag is allowed
> (currently).
Ack.

