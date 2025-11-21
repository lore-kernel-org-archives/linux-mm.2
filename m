Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF25CCFA759
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5AA6B0032; Fri, 21 Nov 2025 04:08:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC5A6B007B; Fri, 21 Nov 2025 04:08:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BDB6B0088; Fri, 21 Nov 2025 04:08:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2D676B0032
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:08:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1409216055B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:08:25 +0000 (UTC)
X-FDA: 84134038170.28.9884AA4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7394140007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:08:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OtvIACLX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oDoLwJr6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OtvIACLX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oDoLwJr6;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763716103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aui9l7AgpNh+vCcDY9SRw7llzOsh+jqboWLjXhXxfO4=;
	b=32oZSaTBvSFtU6iawiF9hmlMMGXRkUju2jKScJr8rzQnVVaLHkFo0zH8BSjXTQ64XVr1KY
	0Z10LL7vXqG0wRJj9/nCZufVBDSRSjiVy8DexBxSHl5AxWK3GqFRopBmjC2ejnJh+zFJgU
	XN+AC+n0dYMAN7/CIgEVXtKX2Ovp5ls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763716103; a=rsa-sha256;
	cv=none;
	b=mcJCwshgGqs30mcEDYrZlo6FP57S3FSWf21dxElyTTjyyyHYoN4hh54RxHa+0vrlwfrNC4
	YK3CePUwCzjskkxk9E0Rv/a/X88EszmWlpe6xXPnXuxvqbBNq7QSsbG5U5pwTKRNVpZcFF
	lNhW/6TyikokB1Qia651+Tk/oe6e6U0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OtvIACLX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oDoLwJr6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OtvIACLX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oDoLwJr6;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47F2E20F11;
	Fri, 21 Nov 2025 09:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763716100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aui9l7AgpNh+vCcDY9SRw7llzOsh+jqboWLjXhXxfO4=;
	b=OtvIACLXgtdbS8YoKbF6+sVqsKnkEmY7oTxuELuDiFPTIyaNZBWaZ1Qp/ieCd1Ubi9epsp
	jw8pDdzt7N0oQtGqUTGY+LfwfUMgD0n9g9LM4UqBsHffwOv+PQoptPHLGI4bvTxloTI9DK
	rMPoIyyZIToZoxyiIEsNQWF+5aBB6p0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763716100;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aui9l7AgpNh+vCcDY9SRw7llzOsh+jqboWLjXhXxfO4=;
	b=oDoLwJr6URXKC+fm3LWfjBq+79HSjVrlrtdX3ZtS8ERo7FwOlBnjYssE1qX9ZFTsN/HGU1
	vlXZgQQIDrtfXZDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763716100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aui9l7AgpNh+vCcDY9SRw7llzOsh+jqboWLjXhXxfO4=;
	b=OtvIACLXgtdbS8YoKbF6+sVqsKnkEmY7oTxuELuDiFPTIyaNZBWaZ1Qp/ieCd1Ubi9epsp
	jw8pDdzt7N0oQtGqUTGY+LfwfUMgD0n9g9LM4UqBsHffwOv+PQoptPHLGI4bvTxloTI9DK
	rMPoIyyZIToZoxyiIEsNQWF+5aBB6p0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763716100;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aui9l7AgpNh+vCcDY9SRw7llzOsh+jqboWLjXhXxfO4=;
	b=oDoLwJr6URXKC+fm3LWfjBq+79HSjVrlrtdX3ZtS8ERo7FwOlBnjYssE1qX9ZFTsN/HGU1
	vlXZgQQIDrtfXZDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E6D93EA61;
	Fri, 21 Nov 2025 09:08:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nvLuCgQsIGlkXgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Nov 2025 09:08:20 +0000
Message-ID: <18ae4b82-b18a-4ed8-8b72-4a9697a4dc8f@suse.cz>
Date: Fri, 21 Nov 2025 10:08:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Paul E. McKenney" <paulmck@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 stable@vger.kernel.org, syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
 <2d93af49-fd76-4b05-aee7-0b4a32b1048e@lucifer.local>
 <aRUggwAQJsnQV_07@casper.infradead.org>
 <d9e181fe-e3d8-427a-8323-ea979f5a02ad@paulmck-laptop>
 <f7abdb4c-b7e2-4fe4-9198-f313d0cacacb@lucifer.local>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <f7abdb4c-b7e2-4fe4-9198-f313d0cacacb@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 7c58h98hqiag5j31ocy8z8enx6arp6j3
X-Rspam-User: 
X-Rspamd-Queue-Id: 7394140007
X-Rspamd-Server: rspam01
X-HE-Tag: 1763716102-605328
X-HE-Meta: U2FsdGVkX1++GF+a+LFZKcH0OpcIKASXuOA9mKno2s9fNHiXhccr5qvpyvTdHuMNXhZzh9IHVh6Y0nbbG1wW9dRi7BFxQUJDRQKLNcEv3AaBzQnLlNiT3QPmbfr37AIDZTlWON4eWg7FlXrMh5a/Abpk+eEDwuEGCDSBxt8Y64grCspxcPcDLk07UMkwtU0yyp+jdzqJfMS3k2JD2GXrNfB3QoArdXl2lgZ5IcdlZbEjaQ4B/Uc5cJf005bO5dhB1FG1MpGiNqt5sVrRR7bN5oy4CqdHdkm+RLDvRLBYJ75aj2at98Kh1qaOOPIOYzThWAZ69/FgTakI8PqaXT9OOz02cN6gCbx9gnxnhRkl7qS5OJXR3W7nWRfQpGOo04fgXOUjWEcOKNkKcZOGVKkJ6JDQAASbMNEBFJNaWAQUdffZo+17LHrNXeaCxpKQhbvspzTGhaKQZql5RPYQsNeDGfGM0JX5NO6Am0akzGwmbeTKf1/kRaE2XOlmg2PWo5yy22aIzs2Z+Dsf/2BQSLvvMPchLjIFRD99AVrtvE4BTp0NXA0fk6W4HSqTGWy35AK98Qham67bjZjb7HSPNjhidiXyRM78Lb+jgnE9p5mcPLppD57qwzoWL6r2jgyHktQMbnwphq/m0iot5e5S9DTRE9XDvDGQZYiejYfzYqVMmTCpAijwg2vpStgo6Hy/vcHqUPn+aQo0ai+Rcd6WI94WbmgRT/IwCmc6oodQbbwnrHeSOPOQWAaD147t9k4vV0ETO31hPmEPSy6PuYFzSJTCCGFk2kPBtDUFvFfecgmguA4r77B96LjeZnQfBg0qiLx/vSKc1VgKC4NHo3UG0LcneULz4xRveHPnID0DxnTJEEXSVmanxk3PbAEU6o/I5NM8L5oIION5zGsNyeEjj6owT6CE97zLGyr2IwFNrgrvVHQUcVVwasl5jZkaUAAWxjVhS253fgTZvWLPJofyzsa
 MM6Ns3Mp
 wPlrMq6wJAgKHtB2a8yzUBRC5Tp6WNiFPV4apl99TrxB1We4TEO23XwphMuCqr2U16jvwK+fdPQ6JT1o4lozqgXrDtFLS6T42LvWlO783g8vjw+GwpaCYwCTs3uP9lfY7rqop4PDt2Gm4pDcwvnxJmVILyfZC2bZQo38MGi/XbRVbQ0yRelLqNUCoLxfqoWsAVUG1vkeYEtfQsuo936pQ/WUi/JXCt+jxll6OCxA8XUWrCMeU2MwXCtGKeAAiZfVtj8u2w3irbgy6Jyx+bEa3aYllCxVyN347yHXy5kNVxpre9T60CZlk1mr4Fj/iP8PP427VS4Qum95V3sAFxEYbRfxflAHOowduxlHmGwTFE3dwuw+QAwt3d061a3/wsJJBswJ7uCSEYjiWa8Xqt5yjxQBUWf3Ey36cTkBGob7DNln2Uh7snRxqq0VAPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(sorry for the late reply)

On 11/13/25 12:05, Lorenzo Stoakes wrote:
>> > > I think one source of confusion for me with maple tree operations is - what
>> > > to do if we are in a position where some kind of reset is needed?
>> > >
>> > > So even if I'd realised 'aha we need to reset this' it wouldn't be obvious
>> > > to me that we ought to set to the address.
>> >
>> > I think that's a separate problem.
>> >
>> > > > +++ b/mm/mmap_lock.c
>> > > > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>> > > >  		if (PTR_ERR(vma) == -EAGAIN) {
>> > > >  			count_vm_vma_lock_event(VMA_LOCK_MISS);
>> > > >  			/* The area was replaced with another one */
>> > > > +			mas_set(&mas, address);
>> > >
>> > > I wonder if we could detect that the RCU lock was released (+ reacquired) in
>> > > mas_walk() in a debug mode, like CONFIG_VM_DEBUG_MAPLE_TREE?
>> >
>> > Dropping and reacquiring the RCU read lock should have been a big red
>> > flag.  I didn't have time to review the patches, but if I had, I would
>> > have suggested passing the mas down to the routine that drops the rcu
>> > read lock so it can be invalidated before dropping the readlock.
>>
>> There has been some academic efforts to check for RCU-protected pointers
>> leaking from one RCU read-side critical section to another, but nothing
>> useful has come from this.  :-/
> 
> Ugh a pity. I was hoping we could do (in debug mode only obv) something
> absolutely roughly like:
> 
> On init:
> 
> mas->rcu_critical_section = rcu_get_critical_section_blah();

AFAICT, get_state_synchronize_rcu()?

> ...
> 
> On walk:
> 
> 	VM_WARN_ON(rcu_critical_section_blah() != mas->rcu_critical_section);

And here, poll_state_synchronize_rcu()?

It wouldn't detect directly that we dropped and reacquired the rcu read
lock, but with enough testing, that would at some point translate to a new
grace period between the first and second read lock, and we'd catch it then?

> But sounds like that isn't feasible.
I don't think what Paul says means your suggestion is not feasible. I think
he says there are no known ways to do this checking automagicallt. But your
suggestion is doing it manually for a specific case. I guess it depends on
how many maple tree functions we'd have to change and how ugly it would be.

> I always like the idea of us having debug stuff that helps highlight dumb
> mistakes very quickly, no matter how silly they might be :)
> 
>>
>> But rcu_pointer_handoff() and unrcu_pointer() are intended not only for
>> documentation, but also to suppress the inevitable false positives should
>> anyone figure out how to detect leaking of RCU-protected pointers.
>>
>> 							Thanx, Paul
> 
> Cheers, Lorenzo


