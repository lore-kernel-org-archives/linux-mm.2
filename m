Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CD3606A68C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=etsalapatis.com header.i=@etsalapatis.com header.a=rsa-sha256 header.s=google header.b=hah4XhlW
Received: by kanga.kvack.org (Postfix)
	id 57B426B081B; Tue, 24 Nov 2026 13:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C4F6B081D; Tue, 24 Nov 2026 13:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A3B6B081E; Tue, 24 Nov 2026 13:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 158DC6B081B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:07:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8E61120C29
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:07:51 +0000 (UTC)
X-FDA: 85470795942.10.F0414D2
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 907D4100016
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:07:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=etsalapatis.com header.s=google header.b=hah4XhlW;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=emil@etsalapatis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795543669;
	b=Rs14ozbPyOJPyrqKcrIa/VEAApuvzya7bmdOg7ybvYKjlzXMH3xG5Df4MnaHjKUKJCOIHU
	xSxTPsr9MWA6jah8a41GtGp7wJsegSqMpmtGbKfwEN7AmSyQpa3lGSEFy6OpJusbIWLhs6
	prloCa54hUBl40u/mAP0Vzi1XSxpzlE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795543669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsP8MXxfo3SZdbWSOQKBU/IrTFvBThmLY9Ku8DE2rr4=;
	b=ArWCpqNrR1PkiVsNoxFcjGyW0JWTPLK7SDXhCwDpOM243oSuxQMdGyZSbHNFs/Sp/2ro8K
	6go6pKq808iWmn2V4mWGEYmKkQ3ls2lI22UwPkLnQliVuHlvrTXhJHm3ZIVADPVjUpwTjo
	klnXBWjvUDuNx2WoMCRr+fKzNrBFSIQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=etsalapatis.com header.s=google header.b=hah4XhlW;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=emil@etsalapatis.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8b66d1a08ccso3399485b3a.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis.com; s=google; t=1795543668; x=1796148468; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VsP8MXxfo3SZdbWSOQKBU/IrTFvBThmLY9Ku8DE2rr4=;
        b=hah4XhlWH0FIL2G7ipNBDIOVs4sEVx9iZ9iN1sRfd3BnLBJou604RSPkZmodDM9bjb
         MgEqP0/7d3BmBuAx5sGj0RexZXOFnlqDzwD0ipg/VjPTgabuTSPGTVDwNiFUYwL4lpsr
         B2iBRSv2b9XbBjTtrdAJKJ4E0BE7zc4ppaoJ2D5EyBsk+xlfkQA54/UnRtKnUrt24vuc
         3LkgBvaQJ7IV54tdrjbM0dvsYPIW99hcMQVcbDvflN/Gh7fWW2f1j229PwNri4iwo3c7
         mVVppBztGVsGU7D7Y85flSkg86tcP8DAhXTvgRTPE3uUn5CiylMPXR5wcfp9lkhIFwWq
         /POw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795543668; x=1796148468;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VsP8MXxfo3SZdbWSOQKBU/IrTFvBThmLY9Ku8DE2rr4=;
        b=lXs17bpe6APg0sx+CpqqFDd961Wqe143mJ4Z9qSzkqzm60SlD48P0bvhMAIoq1GKe0
         ELhIdqBPphf4qJuCDemeZW6fBhkjC/a+G3zIyUGY0t5q1cig5dBfftPLGKgBRiKDlyIi
         2r1QS5lYeWTTFoRBFfM38zpJzydmmwC/heQowmUN1Y6/AwfBgf+yjzOVEF1Uvwau4nHu
         sZWbdLImwz7yn/3BKfUOPI7qAgnszr+Pm61dO2DP6D62dJ+HZuGDfpkUVSETDSgiwzhN
         ZfEnbu9PF8ZVoc4z9vKe+q+AEpHuEknEjvUmlGacf8eKx+tAhd+N45Np6xWqBcULFo49
         bADw==
X-Forwarded-Encrypted: i=1; AL+hErHOzB3vWS5AdUgELcLXQNw6f0q8pO4nsiy7VGDwHzUojxtL70gPTZ2KiuRWW76Gzvgke/6rQq6Rig==@kvack.org
X-Gm-Message-State: APuU4Z+SRy7AEFNKBxE1TH6dVNNlKTuAPHeYDtfR4gY3R/ZOUgMB8dVv
	XGYiulgaurFufhVXmcxcJDUT/Dqx2FcgpLE+8uR+lNI+Gt5a/f/vI8gSzALuhVTqdwep0bEjO+t
	sTRMgDu0=
X-Gm-Gg: AZFdTZdqhHnlms6a0aIrsosGZAw2gKUcyqhClcPTTBIklURWyzfJF84i6ITC7/Xbcjn
	HQhI1NV4c1iOj5+IEaO8Lv5j89qWK7AJ+btwI5ng3wLkezzXXBoOTAPtNPQmzWi6ODRZ03Z6gGg
	KlfOBXOVJ+Vt5OMBQmVQX5wApX2/MWd7JqzxHUv769OpOmY/UvDzZyES6GS3LDEBCy+QYpRNjUi
	Q2bwjGYAXjL7ExSnZX3hSmWRnon0CeyGuoyQqbJNiag+8IDUOcj/SUQwRHwbM92Lnsswinbz6rL
	7uswib//g0IvfsNUtYTsoh7icuZ/+PH+wDxFmeNAvO1BR8pOrzxMkGNFE8G0Bv4jB9ZXgAy5U+J
	D7Pd+s/5gYdOm0WPqbg6EuefoqX5rKTEK/NNAL4qGBOS/wikwbbjX9FUOJhfEEvur7ooHHA2AwR
	RwwHtHQ6xwn51WxUnosNzkzj+vhojoo5SRnYSXTltUOpHuxkMdBXo/MBeCczSQyPBwwAXeZsg18
	mlDugge2au6D/X8mh/Rc9idG6hlCwT0Vs5PEOBBn2Tt+H9+jpk9OcCZZvOH0gDFOiVZX91JtFnF
	9NZWFgY6ztcAGfG2iuy6+4u0bkcuIhUs3pkMgM3IEVJhzaM1zDmG+AQTNJfr2sQ7XZwFkqhZVJO
	kMR+7zX7drhrpsrre5MQXixaJZu4YOFg9HgRLgKM=
X-Received: by 2002:a05:6300:492:b0:3eb:a2d9:58f1 with SMTP id adf61e73a8af0-401493a61ecmr13003503637.9.1795543668120;
        Tue, 24 Nov 2026 10:07:48 -0800 (PST)
Received: from localhost (107-190-31-93.cpe.teksavvy.com. [107.190.31.93])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cff4c1asm7283156a12.15.2026.11.24.10.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 10:07:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2026 18:07:46 +0000
Message-Id: <DN3N3WXWFO3J.IQPVUAFZKE3B@etsalapatis.com>
Cc: "Emil Tsalapatis" <emil@etsalapatis.com>, <bpf@vger.kernel.org>,
 <andrii@kernel.org>, <eddyz87@gmail.com>, <memxor@gmail.com>,
 <daniel@iogearbox.net>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, <linux-rt-devel@lists.linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, <linux-mm@kvack.org>, "David Hildenbrand"
 <david@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar"
 <mingo@redhat.com>, "Will Deacon" <will@kernel.org>, "Boqun Feng"
 <boqun@kernel.org>, "Waiman Long" <longman@redhat.com>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Harry Yoo" <harry@kernel.org>, "Alexei Starovoitov"
 <alexei.starovoitov@gmail.com>
X-Mailer: aerc 0.21.0
References: <20261124060357.11700-1-emil@etsalapatis.com>
 <20261124060357.11700-2-emil@etsalapatis.com>
 <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com> <awWRZ9xCzWLnj_R6@thinkstation>
In-Reply-To: <awWRZ9xCzWLnj_R6@thinkstation>
X-Stat-Signature: s7uqmkahcqhznu6ah9occpni94phpbx9
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 907D4100016
X-Rspamd-Server: rspam03
X-HE-Tag: 1795543669-308558
X-HE-Meta: U2FsdGVkX1/pxtCIv7Ld4ONH+AzT3APD7vkacs6EBUuXHlRbW720Lgfv9iinhWfR1mpvHBW3WJAa5XOkYTVF5zDGf/j6UOe4fNSDLb2odLLCCu65H6EdwFGIPfVh2w5dWQHOmMRs+66dSgZwbg7zMfmZhv5muvJBTdN2srg2NG97MugaYNyxx8JNh2YM7I69KJyf698nwPQODhxT5TIpCvjeq+tVNf6u39d87ZUIAZAjY/J8OJWgWjSx5pDkTZumfAj/tJr+8OKJxwWvDwczf935npxDz2KSPXSpxk2kMtgSaMGnymD9ST1waKe8yCc/792hxstubt0yQzbSKxjQccdH7SyAiVHSArS2XzrR5UftP3FOeP3kdlKU8WogAHuINbY2apZPPcv9aFZyP7L9Lc/pY2obTHUDi4RVLXzPc7HLhiCDtJbTCufxhitPxsOiytSEkpLZA14r9icxm+Tb7Pj7iwYbLyKRU+KmPWtUBT5ETULIjFaxx62vvvY/gGSwpWMnSWGpTBvEyAA+qShMhat5yWASbxVURJnArSjey7wn+DCXa2oqAEsDBEHGnmXHxVhs5tApEG9HIQhWwbo657jxrfccQAbDt4vx80YktxEFOJTNSaaOId5frpH17NypmQN9kogNbQLbq/X/hwHvH4JCvxnltVOtHX5yZKFWEhfPtM5WHA8tGQC9L/f4CwCJDuZpKbUwJwfYkbLRJMAaQYiEoeRhQ2WgO3MJFRjqfVZtM++2VbF6tRZPGqGifwHwgYrqBw42Y5SkfoxUSNVxUK1P9f9fQI8X03/oeJPG8ebsAlD6n/D/eEK1bzf54UcRaF0PMDA+vk6gDdO6xwdGR/SW3gndLLK8KSU67M/Pl+rQk1SzW4+NqhbR6vO9owomoi7xJqC7b3t1OTnkPr/l+j6B4wXaoHdD8/qLPMLij4XownyRyGJkARvZ6dOjVvcj8drPiOkBKFYSH88dknI
 AJeQhHQR
 8pbJK6gefBdn/A3SlXtTidbLny8fm0ZW36yfu+XiRtKzpRtv36FmdNfY0Mfq8jxwOnqJGozytRu51GQ3BN6QUn/Z8NWLEhQ9K2ATzhh1KSDjEVy5BJ+VNgSEcVcqA1IvKo+9mI5XvaYb9pobb0e2jDQThYCJsMWvR6OGZj7S0Akafd3pkk/g3mkEkDFtYxGwitpMnB7iTK7KTN3bfGloNLBfGhAjolehrR/0F4fFFn02zyjbjChB1yAvImV4yrxdtlt/MkSD1qh9x0Uw3/WeoZBBp36Op9YV77gPa2X8Gxo++hiDNcfdZWyUh4giUMFnMyvRXx6ofpgHpu3KRgw18/xuppd4tbUCMNu7dki1V7vDKWlOVEUaZkQJvPObIPrh0SkTxM3JkdntqkqffVdEmstiuFb9VIuipSfevMHppCF0c/M03RPYAE2DdGg1n3Wo8nA04YIEQwwyFY7f5SZzZ5qkT4UnQeqlRqkNDfZvVWNTx8iQtkPNhO7YQC1rJ4d4DhhUVl24GBCcf5v6SxoTB0fmsU9eJBLxWWCJnYNfj0VHSL9UE3+WNXL9T13yTS5/NWBI6Laee/+M4HJDTvRv8GtA0C452VEX4oT1rfs9LBzYk9pU9ZhU/1xgGlAFL6dxZy6Xija4M4C0pGzKR8IZ+RAs95vYjQTtqTTNXtSM5ELIPbwb8EOoTf5oYGgXlPRrJXb2Mu8IDcyrw7rKV3grx/coPmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 24, 2026 at 1:59 PM UTC, Harry Yoo wrote:
> [+Cc Relevant folks]
>
> And a bit of context on the underlying problem.
>
> kmalloc_nolock() could fail when there is a contention on locks
> shared across CPUs (e.g., n->list_lock in slab, zone->lock in buddy),
> or there is a decent amount of memory pressure. It's more restrictive
> than GFP_ATOMIC.
>
> Unconditionally using kmalloc_nolock() in BPF local storage is
> unnecessarily restrictive when the program can sleep or spin, and
> Emil's patchset teaches the local storage whether the BPF program
> accessing the local storage could sleep or spin on a lock.
>
> Answering the question "Does this context allow sleeping, or spinning
> on a lock" is extremely tricky in the Linux kernel as BPF programs
> could run and call kfuncs almost at any point in the kernel code and
> the "context" is usually encoded in the GFP flags or the process flags.
>
> Tracking whether certain locks are taken by current context is not
> ideal either as it adds unnecessary overhead for everybody.

Yes, we considered the page_alloc approach with Harry offlist and I think w=
hat
it comes down to is that one approach is the most turnkey for users while
the other has the clearest semantics. I went with the latter because
making the selection straight in the BPF code makes the behavior of the
top-level local storage alloc call ends up easier to understand and
explicit in the BPF subsystem.

>
> On Tue, Nov 24, 2026 at 06:40:11AM +0000, Alexei Starovoitov wrote:
>> On Mon, Nov 23, 2026 at 10:03 PM Emil Tsalapatis <emil@etsalapatis.com> =
wrote:
>> > +	/* Only try the spinning allocation when preemption disables are tra=
cked. */
>> > +	if (IS_ENABLED(CONFIG_PREEMPT_COUNT) && can_spin_in_alloc() &&
>> > +	    size <=3D KMALLOC_MAX_CACHE_SIZE && !(flags & ~nolock_flags))
>> > +		ptr =3D kmalloc(size, flags | GFP_NOWAIT | __GFP_NOMEMALLOC);
>>=20
>> It works, but I after a bit of brainstorming the following
>> might be a better fix, since it will address the root cause:
>> Pls run it by Vlastimil, Harry, Sebastian.
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 2fef409..4368ab5 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -2536,6 +2536,24 @@ __rmqueue(struct zone *zone, unsigned int order, =
int migratetype,
>>  	return NULL;
>>  }
>> =20
>> +static DEFINE_WAIT_OVERRIDE_MAP(zone_nolock_map, LD_WAIT_CONFIG);
>> +
>> +/*
>> + * zone->lock is always held with IRQs disabled. A caller that runs wit=
h IRQs
>> + * enabled is not nested inside of it, so it can wait for the owner.
>> + */
>> +static bool zone_lock_nolock(struct zone *zone, unsigned long *flags)
>> +{
>> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) || irqs_disabled() || in_nmi())
>> +		return spin_trylock_irqsave(&zone->lock, *flags);
>> +
>> +	/* The caller may hold a raw_spinlock_t. */
>> +	lock_map_acquire_try(&zone_nolock_map);
>> +	spin_lock_irqsave(&zone->lock, *flags);
>> +	lock_map_release(&zone_nolock_map);
>> +	return true;
>> +}
>
> I'm not sure this is a better solution unless this could be generalized
> or abstracted further.
>
>>  /*
>>   * Obtain a specified number of elements from the buddy allocator, all =
under
>>   * a single hold of the lock, for efficiency.  Add them to the supplied=
 list.
>> @@ -2550,7 +2568,7 @@ static int rmqueue_bulk(struct zone *zone, unsigne=
d int order,
>>  	int i;
>> =20
>>  	if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
>> -		if (!spin_trylock_irqsave(&zone->lock, flags))
>> +		if (!zone_lock_nolock(zone, &flags))
>>  			return 0;
>>  	} else {
>>  		spin_lock_irqsave(&zone->lock, flags);
>> @@ -3237,7 +3255,7 @@ struct page *rmqueue_buddy(struct zone *preferred_=
zone, struct zone *zone,
>>  	do {
>>  		page =3D NULL;
>>  		if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
>> -			if (!spin_trylock_irqsave(&zone->lock, flags))
>> +			if (!zone_lock_nolock(zone, &flags))
>>  				return NULL;
>>  		} else {
>>  			spin_lock_irqsave(&zone->lock, flags);
>>=20
>> pw-bot: cr


