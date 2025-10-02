Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9000DCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 10:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18478E0008; Thu,  2 Oct 2025 06:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFC68E0003; Thu,  2 Oct 2025 06:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CEC8E0008; Thu,  2 Oct 2025 06:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC6828E0003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 06:50:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57A37119EF8
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 10:50:08 +0000 (UTC)
X-FDA: 83952854496.12.A49C6D1
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 74E8F4000F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 10:50:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4wR2nI/A";
	spf=pass (imf27.hostedemail.com: domain of 33FjeaAgKCFU6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=33FjeaAgKCFU6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759402206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWh2ETCCMHfxl02tP/Gv5EZmDDMUXPwjZALfSasBKUg=;
	b=3NzPrBNGI+Xo84cvvQOSQtkwisW77oVfFC1Zu8/3RTzSVEBOw7C9yxcc5F0R84NbLEZqC8
	PTvVf1xjcFMSXg1Df4+pnM5vjTuSirWF6EZM2FSmwGAIHSuzw6fJQ4aW1vcw1YrMihLMSG
	/gRRW6dgHhAVeZEv0riBoMl/TbT0tlY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4wR2nI/A";
	spf=pass (imf27.hostedemail.com: domain of 33FjeaAgKCFU6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=33FjeaAgKCFU6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759402206; a=rsa-sha256;
	cv=none;
	b=qXRnYcGh/8AjMI3NFXpIY7YsyZ5AiwLeuGS16ZptwdWCgLlTp5UFnsU7N2GwBsR+4xS5Dy
	hXgXArUzFFZOAGbibJiyIOuN8fjpOemasLyPdKrd23P9uXIr5hF7Q2TeQeaQLMXjFIQPjp
	A0Gv/cK4K7b8ufNcDGipejfBDHGlHe0=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e2c11b94cso4175825e9.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 03:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759402205; x=1760007005; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IWh2ETCCMHfxl02tP/Gv5EZmDDMUXPwjZALfSasBKUg=;
        b=4wR2nI/ApvuhRFetUFk9pAhiNw7qZXkmPbHffKeIOVjx2R+7K9vlwMziWTeZx8DgYj
         EZ+q7WpbZnZfBgH4c1WcvyzFZMQYGYUB7ypwbjRzCsZQD8ssm+1hPdvVbSlBw1TxdjE2
         TwsGYCQGi/Pmskzoj5v4m4pwCn6rx7J3mMtL+Xl+erNjoO1Pp63GxE4ReVzEe/v/ATS7
         t0kgeyDOcVePHfaPi758L3sSCe8FCs2rXetfyXQvdGX1PotlhhQtqlLx24UjMB7eE7p+
         VZ4lqf+TI5QUYd1c1t9aqALcF9KhzpoSkemokqEq7+qONs58stgJK5uEYm1w6gwBeNWn
         VDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759402205; x=1760007005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IWh2ETCCMHfxl02tP/Gv5EZmDDMUXPwjZALfSasBKUg=;
        b=Y6a4MULweugwag1Sl/V3Zl8kroiMvIhNsAwYhGOB48XIOgqcjY0cLwuVzL+RFfqFci
         Xjquj/qkxVOQcCr8TfilQmLHYues8XwGUox6Md8PtjEh/KvNNQg115oHs2D1VrIluw5O
         5bwhdXt/FotD4NScuJhckliOc/L3iLe1GUSPmq778osWYlQq2kC6Txckr64PVGfH/DPT
         3A+2iJ7uJjlTRFugTgl/+AwGL0JTTnOV8F+yuhAR3JYUmMXZHG6B7p891UyqNsnzXN/d
         MnNpDTB2AUwNaTEOEQ0y5aNt0a4SnkJQUER8ktpEAxX8CNKFaczMuOpTEj+6w7nUWeqS
         /0gA==
X-Forwarded-Encrypted: i=1; AJvYcCWwJMhup9u/XWG/D/SKbol+nvvOWurZgheT38r6FKN9t95OKIT/OVyLr75sdYlQzkTbOIct9jOVcw==@kvack.org
X-Gm-Message-State: AOJu0Yz+vBUtb1l5ESX8dA9PZ0J1Kdak3BU8//+c8mjylsqWacOpxoLr
	dCp0TRXJueFYeVjPRTEZxdRUwmiCw+MbOkevkwfagu56nyXFq1ggsKgCC3HbOHMmpRdZYhIbX4I
	Vae7mYeq38LoSEw==
X-Google-Smtp-Source: AGHT+IGWR9j/Xit9lLgINB4l5JFF1so1I0kGHQeQSHLJdJxwnyVap0eWcLny3Gx9GUUNMzDySaN/LGmTl4dg0g==
X-Received: from wmbz25.prod.google.com ([2002:a05:600c:c099:b0:46d:712:e422])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:458f:b0:46e:39ef:be77 with SMTP id 5b1f17b1804b1-46e6127e030mr54678365e9.14.1759402204756;
 Thu, 02 Oct 2025 03:50:04 -0700 (PDT)
Date: Thu, 02 Oct 2025 10:50:03 +0000
In-Reply-To: <44082771-a35b-4e8d-b08a-bd8cd340c9f2@redhat.com>
Mime-Version: 1.0
References: <20250812173109.295750-1-jackmanb@google.com> <44082771-a35b-4e8d-b08a-bd8cd340c9f2@redhat.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD7S12CF1V9G.3KGT3KYBLZ7F2@google.com>
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
From: Brendan Jackman <jackmanb@google.com>
To: David Hildenbrand <david@redhat.com>, Brendan Jackman <jackmanb@google.com>, <peterz@infradead.org>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <mingo@redhat.com>, 
	<tglx@linutronix.de>
Cc: <akpm@linux-foundation.org>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	<yosry.ahmed@linux.dev>, Patrick Roy <roypat@amazon.co.uk>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 74E8F4000F
X-Stat-Signature: nxw34itow37sk4dqdy5f54bg86ft69ax
X-HE-Tag: 1759402206-30934
X-HE-Meta: U2FsdGVkX18A/BqdmnglLM1audSgApbZ2YmIkOFoFMDtrmkl0RiX5K4YNnQAkacuMuoMLWYIz8VQWVXBRnwXz4jrrBGpbXdr7ZSf0FlY6oN9kthsCCAgeGz3UAA9BhtlDmDvD5Xl0gj6OOtUPfQPYCUZWstg6oShYqa3rtEhVyxmP5EXh1d3G+NuQSq0kuPFjNtZS2BUrhv56g32cA0/rzCf4cj82fPY/vcHVXkJ9497xQN/mAfh5SoWWnf51Yo6u2fGnng1GCorZO1366i5KZmfaykBh5vnmEeYE1uUvX+0ElCwpKMUln6iQPvnZNyBri1su+trs17rVSVAo2j01LV8vQpcZ/ZwAheFYTpMq/6z8TTdmQXbr8RxcBzFzjn9raWjbjCjktGXQMqSSLZ0H9e/tRg9W35rDJnNcaC3Ixr0W+5JDP529DezcEcrTIn69YTvRqbidJQtnuauN4PB4hBgakqsWY67Ysj58nVhHxliV/YWGKySwqr/Wf/KPyg5+m5VHa2P1MMqughgvZPuVREIqoPFw1LzBsQ7hJGUReqIFzY8cBt6CPv33VTVOGkuV4EKPTX6HeJNBt4zg/6MOUQolufjBxYtLLivL3QPwFIIckIi1v2m9tp+3ZC8yZseWv0YwIAeH74vYDIbni5L06kv5RHwl4a54O5nMXjoazScf5KN1L58lMCNWbQeVLNZyLHUhqDfrd40XlT+boI6IT5gCDQFalcgInvaDCnIocMYrLcMvm0jjGtjQmjWZX+QwHzXmakozqIMiGonV2Kz7oK+S2hdJob6qn1raHXSnrzbBQXP6ynTFuwlc8hjVRrZj39b0RQsEgixWdwShj5ngdzc3RxVMg57h++qniqySHNqa14gHT2CRmO0WC5vKc02+x74JucdYvMzldaEpVOP3nVD7A7aj1yhgHey86WGvx0itVx1ZhIpNCzOXvqvAFBDNzK6RYGuSINT+3HlqfO
 1wff0Mxy
 J7+QXLOHmi4HxWkUIV+b0OKjB43C7k4flsFxniP0Z9X3987Ny7QtzVT5UQLGghKCb4/zaezqEombELGuYgWC+pwB+B9uzUKBE3z2y+08aH2tuj743Y2yZKUFP5eLSVLxpvu5z1xnICtXjj93T7M9O5R1tBOowgDO6Z2B+Hi4R3i8fGBPn5LTdYjSMtqkz+yiwbTFuH4PneG5PqvbgE9CwaoY8fcq4BMeLaiMP50u0t6cN16g2kdsDo3/GjoNMhv+fBKl8z69EdfkYlUm9/KjRzSo9wTU3AuMXkuHRkGYGRc1eQWbWi4G9IlddN1O8cDV7R5n68aPICz9iTG7X1cPZzNsGqHlI0xUFenHoEkudaWHuxVJamh+o/eXA+culUL5sGV4aVwVjuZgY14KG+FeYPw3S88dKRkxtjrJXW1zcLNkQEPIhAq8cDBjXuoEhR6Bx/6VU55hN6SToEZeT22ZCZKDfyjZpNSxnq9uxe5F95yiTKKC1uO9JJ3KhK5G7a1rMr7uZhKMj2VdlXvWVRPRnIZAcS63sdAK1XvLefvhkcOPfaDTcP+ziWmAV/0Su1WZpKsiz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Oct 2, 2025 at 7:45 AM UTC, David Hildenbrand wrote:
>> I won't re-hash the details of the problem here (see [1]) but in short: file
>> pages aren't mapped into the physmap as seen from ASI's restricted address space.
>> This causes a major overhead when e.g. read()ing files. The solution we've
>> always envisaged (and which I very hastily tried to describe at LSF/MM/BPF this
>> year) was to simply stop read() etc from touching the physmap.
>> 
>> This is achieved in this prototype by a mechanism that I've called the "ephmap".
>> The ephmap is a special region of the kernel address space that is local to the
>> mm (much like the "proclocal" idea from 2019 [2]). Users of the ephmap API can
>> allocate a subregion of this, and provide pages that get mapped into their
>> subregion. These subregions are CPU-local. This means that it's cheap to tear
>> these mappings down, so they can be removed immediately after use (eph =
>> "ephemeral"), eliminating the need for complex/costly tracking data structures.
>> 
>> (You might notice the ephmap is extremely similar to kmap_local_page() - see the
>> commit that introduces it ("x86: mm: Introduce the ephmap") for discussion).
>> 
>> The ephmap can then be used for accessing file pages. It's also a generic
>> mechanism for accessing sensitive data, for example it could be used for
>> zeroing sensitive pages, or if necessary for copy-on-write of user pages.
>> 
>
> At some point we discussed on how to make secretmem pages movable so we 
> end up having less unmovable pages in the system.
>
> Secretmem pages have their directmap removed once allocated, and 
> restored once free (truncated from the page cache).
>
> In order to migrate them we would have to temporarily map them, and we 
> obviously don't want to temporarily map them into the directmap.
>
> Maybe the ephmap could be user for that use case, too.

The way I've implemented it here, you can only use the ephmap while
preemption is disabled. (A lot about the implementation I posted here is
just stupid prototype stuff, but the preemption-off thing is
deliberate). Does that still work here? I guess it's only needed for the
brief moment while we are actually copying the data, right? In that case
then yeah this seems like a good use case.

> Another, similar use case, would be guest_memfd with a similar approach 
> that secretmem took: removing the direct map. While guest_memfd does not 
> support page migration yet, there are some prototypes that allow 
> migrating pages for non-CoCo (IOW: ordinary) VMs.
>
> Maybe using the ephmap could be used here too.

Yeah, I think overall, the pattern of "I have tried to remove stuff from
my address space, but actuonally I need to exceptionally access it anyway,
we are not actually a microkernel" is gonna be a pretty common one. So
if we can find a way to solve it generically that seems worthwhile. I'm
not confident that this design is a generic solution but it seems like
it might be a reasonable starting point.

> I guess an interesting question would be: which MM to use when we are 
> migrating a page out of random context: memory offlining, page 
> compaction, memory-failure, alloc_contig_pages, ...
>
> [...]
>
>> 
>> Despite my title these numbers are kinda disappointing to be honest, it's not
>> where I wanted to be by now,
>
> "ASI is faster again" :)
>
>> but it's still an order-of-magnitude better than
>> where we were for native FIO a few months ago. I believe almost all of this
>> remaining slowdown is due to unnecessary ASI exits, the key areas being:
>> 
>> - On every context_switch(). Google's internal implementation has fixed this (we
>>    only really need it when switching mms).
>> 
>> - Whenever zeroing sensitive pages from the allocator. This could potentially be
>>    solved with the ephmap but requires a bit of care to avoid opening CPU attack
>>    windows.
>> 
>> - In copy-on-write for user pages. The ephmap could also help here but the
>>    current implementation doesn't support it (it only allows one allocation at a
>>    time per context).
>> 
>
> But only the first point would actually be relevant for the FIO 
> benchmark I assume, right?

Yeah that's a good point, I was thinking more of kernel compile when I
wrote this, I don't remember having a specific theory about the FIO
degradation. The other thing I didn't mention here that might be hitting
FIO is filesystem metadata. For example if you run this on ext4 you
would need to get the superblock into the restricted addres space to
make it fast.  I'm not sure if there would be anything like that in
shmem though...

> So how confident are you that this is really going to be solvable. 

I feel pretty good about solvability right now - the numbers we see now
are kinda where we were at internally 2 or 3 years ago, and then it was
a few optimisation steps from there to GCE prod (IIRC the
context_swith() one was a pretty big one for that usecase, I can't
remember if any of the TLB flushing optimisations made a big
difference). 

I can't deny the risk that these few steps might be much harder for
native workloads than VM ones but it  just seems like a game of
whack-a-mole now, not a "I'm not sure this thing is ever gonna work".
The only question is how many moles there are to whack...

> Or to 
> ask from another angle: long-term how much slowdown do you expect and 
> target?

In the vast majority of cases, we've been able to keep degradations from
ASI below 1% of whatever anyone's measuring. When things go above that
we need to grovel a bit, if anything gets to 5% we don't even bother
asking.

But also, note in lots of these cases we're switching ASI on while
leaving other mitigations in place too. If we had a complete "denylist"
(i.e. the holes in the restricted address space) that we were confident
covered everything, we'd be able to make a lot of these degradataions
negative. So we might just be making life unnecessarily hard for
ourselves by not doing that in the first place. The idea is to retrace
our steps later and start switching off old mitigations and bragging
triumphantly about our perf wins once we are totally certain there's no
security regression.

So yeah I can't be 100% confident for the reasons I mentioned above but
the target, which I think is realistic, is for ASI to be faster than the
existing mitigations in all the interesting cases ("interesting" meaning
we have to do kernel work instead of just flipping a bit in the CPU ).

