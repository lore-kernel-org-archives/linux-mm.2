Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC15CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A669C8E0014; Mon, 18 Aug 2025 02:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E648E0013; Mon, 18 Aug 2025 02:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9545E8E0014; Mon, 18 Aug 2025 02:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 821AB8E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:57:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 326521185A3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:57:52 +0000 (UTC)
X-FDA: 83788973184.12.9ADD3FA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id DCB35A0009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:57:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="m2n5Pn/s";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZQBT1OMa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="m2n5Pn/s";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZQBT1OMa;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755500270; a=rsa-sha256;
	cv=none;
	b=KvQhR6B7NDoNhyYOefZr/E9cECpaejpl2w3dGooyH4rN+TRPy71vPFnUwMYVO/SH0PUeui
	zVqqIZvthZ4qTmgkYoWFg7ab4LacHYFrQ/VfAeiLSk9bfpZQs+ADPFTNhSiaZAl6mwkG86
	+gHOYTxl4dwt4lxtSpFvVFwKIIPPPlM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="m2n5Pn/s";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZQBT1OMa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="m2n5Pn/s";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZQBT1OMa;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755500270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5NJv+yFL+xt33TWRdS3ak5apbcoiIS+C6qqfQR5hMU=;
	b=HK96/nUnpeHFtDceWPworHA1HUwL0w0UnQXUhthVnCsIoacRzqjSk2XP875YMpOQxR5Ahz
	uXOUyYXkmLUVPJFPioHiVmu+GxMGizTARSqrXYpZhaYSIZ+pqKhNDtGfD/oM1dhKZcK/QT
	O6aDBoRbR66nYG75bFgZPBQLBC/7byc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 40F982122E;
	Mon, 18 Aug 2025 06:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755500268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5NJv+yFL+xt33TWRdS3ak5apbcoiIS+C6qqfQR5hMU=;
	b=m2n5Pn/swRjMcr/BL/mW3Rs9gdfHEjFiJUo43cfx+OPe7St/esbRFm66e8TgvfRnEKJ7AV
	4ti+7xbLf833OrS8+6KIXn2yb2Dvpi1jkrOg0JF7HWXN5qMKo1HML4A/Q9NKLNv7XeMymf
	V0H9V1V7Ayy6aaogQfT8XRfeLKZpd0U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755500268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5NJv+yFL+xt33TWRdS3ak5apbcoiIS+C6qqfQR5hMU=;
	b=ZQBT1OMaO/NhRqw9HziHqPbvJRKepl/M6W1RDhf2Lia5W0VeG00Zv3ap7PoxgXWa8+hrOQ
	yyKvhycPlpCD56AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755500268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5NJv+yFL+xt33TWRdS3ak5apbcoiIS+C6qqfQR5hMU=;
	b=m2n5Pn/swRjMcr/BL/mW3Rs9gdfHEjFiJUo43cfx+OPe7St/esbRFm66e8TgvfRnEKJ7AV
	4ti+7xbLf833OrS8+6KIXn2yb2Dvpi1jkrOg0JF7HWXN5qMKo1HML4A/Q9NKLNv7XeMymf
	V0H9V1V7Ayy6aaogQfT8XRfeLKZpd0U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755500268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5NJv+yFL+xt33TWRdS3ak5apbcoiIS+C6qqfQR5hMU=;
	b=ZQBT1OMaO/NhRqw9HziHqPbvJRKepl/M6W1RDhf2Lia5W0VeG00Zv3ap7PoxgXWa8+hrOQ
	yyKvhycPlpCD56AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBEB413686;
	Mon, 18 Aug 2025 06:57:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id awQEMOrOomiqCQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 06:57:46 +0000
Message-ID: <728b9bd5-f423-48cf-a9e0-31270d0b9506@suse.de>
Date: Mon, 18 Aug 2025 08:57:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
To: David Hildenbrand <david@redhat.com>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
 <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
 <b087814e-8bdf-4503-a6ba-213db4263083@lucifer.local>
 <lkwidnuk5qtb65qz5mjkjln7k3hhc6eiixpjmh3a522drfsquu@tizjis7y467s>
 <57bec266-97c4-4292-bd81-93baca737a3c@redhat.com>
 <osippshkfu7ip5tg42zc5nyxegrplm2kekskhitrapzjdyps3h@hodqaqh5r26o>
 <6afa5cab-2044-46fb-9afb-8be82fe8a39f@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <6afa5cab-2044-46fb-9afb-8be82fe8a39f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DCB35A0009
X-Stat-Signature: aundiom91gkmruw7wsqfrhu7fjqgnogn
X-HE-Tag: 1755500269-778408
X-HE-Meta: U2FsdGVkX19S8Vju7BOWI23P2/VllVsPYucHRgFpxKKyHSqcW5kSOqOSeOCd19wA1M56dr57KEPzWXHdGn0EISiQNLcupcNXr1KKLSOOu2L9SwNuWfk5C6KD8ttYQXtJhP+X5+4P1YMdlK263WEaNalahtnyGSfUUh8ZDQo+noIEE9mBmSA6su/LdHIf3524oY9GytPcI7K0T1kTt6jM28sq/Tos+mziU5prxgW9hjlHH+ufV7W6CrUQXFvn4pM4Br8x7Ep5rqkID9KgK/z3/JNG6FvPVJtZvBTzSMR+DOhxRqEjIVy2Mb+zXGiBgMH4YPcrVmu4HWJS2UB1XyMx3AS7sqK5yUdSMXdCr4PtdPp3a6g1scsz66FYAbpiPB8iL2EXDeoa+k9fRuz0KdNxolHBou20RcdoZZYmOE/T3UIuwDas7fVzfIRGJ7A74bwSJv0VRF8ZM9CjmgqcVvGIkA4ZO4W7+q4sVNoVoM6+NQOXoCGq0vL6yssn50wYBGLHy1qGTxAA6M0sVBJ1hHy1NIm7BphqPOcXBKGeIhT+sZdYa/0jWqPMRxJYAGdyMajetxxrt4fJcgWjM8dMfCPdwa3/4a8tKw1sRFrCAQ7cVJjZocenuo8kUKSqKnADGu/5rRZigi2m3Lw2/gLa9Hk37pZolARc5PJQkQVWGldxN6B5lWWV/HZAd7RIcf2UBafdsgUeFvxNonIOW381bHFp5L7BAnvwoFdnPy0DJZRe0Qsz34hOamievKP1iWi0tiedLyo46y6l9vVTJ8oHk+sjE71YdPQ2HkaNH81eUfB9mO5eAAXMfXjU1gq9/xiuqQys9i6rdBhAvM5HpQtTyNY5Ds8Z7BW8k6E0jkAe4PbRLfYPg9EakVIA9enXsm9LBuwIscaiuNUcUZw9LO+HpCKLEKvmELQ671rCIfnb1YWKxjzoCrBE65PfcMt1+l/Cj5gpCQYMOkNbiehyflCaseS
 G/+/AQ1e
 ZGqPTtAaEHB1vvDQ8hs3lzfgMlZzeRRbTCBwt6ohazB12CaW0/iDOgbi3jp8+XQVOqkf1LHwMshioRd3Z0tVr/ouDgThP2KV/sCFUtBKhANNqRjTdN6yULvK10bd9ylVW+UwWar9SLNruP4hVnNq2n6GSaMTqaYwcp3S5lwzZEnFkXp6Zy12T+t9cxD4rdMGbzLu9sNsvU/CX01yz3yQTBeeiroUqX2kPspaUk7VVNpWAdyZAY1m71NjUtCWjkcIfPTJLD8cyQ11hEypTHUeMAZMX7xVy8s/jhKG0aOB9zS2s9n02mdXnDUgKYimrYDvdXulEMFHeIrbGcv//Pa8wWBQxZdGgr0foaNnaWv5HV8kAKRk+ciszsib+3VumHUyypGa3slGJodgNNn0xoB4E/JSSmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/25 12:43, David Hildenbrand wrote:
> On 11.08.25 12:36, Kiryl Shutsemau wrote:
>> On Mon, Aug 11, 2025 at 12:21:23PM +0200, David Hildenbrand wrote:
>>> On 11.08.25 12:17, Kiryl Shutsemau wrote:
>>>> On Mon, Aug 11, 2025 at 11:09:24AM +0100, Lorenzo Stoakes wrote:
>>>>> On Mon, Aug 11, 2025 at 11:07:48AM +0100, Kiryl Shutsemau wrote:
>>>>>>
>>>>>> Well, my worry is that 2M can be a high tax for smaller machines.
>>>>>> Compile-time might be cleaner, but it has downsides.
>>>>>>
>>>>>> It is also not clear if these users actually need physical HZP or 
>>>>>> virtual
>>>>>> is enough. Virtual is cheap.
>>>>>
>>>>> The kernel config flag (default =N) literally says don't use unless 
>>>>> you
>>>>> have plenty of memory :)
>>>>>
>>>>> So this isn't an issue.
>>>>
>>>> Distros use one-config-fits-all approach. Default N doesn't help
>>>> anything.
>>>
>>> You'd probably want a way to say "use the persistent huge zero folio 
>>> if you
>>> machine has more than X Gigs". That's all reasonable stuff that can 
>>> be had
>>> on top of this series.
>>
>> We have 'totalram_pages() < (512 << (20 - PAGE_SHIFT))' check in
>> hugepage_init(). It can [be abstracted out and] re-used.
> 
> I'll note that e.g., RHEL 10 already has a minimum RAM requirement of 2 
> GiB. I think for Fedora it's 1 GiB, with the recommendation of having at 
> least 2 GiB.
> 
> What might be reasonable is having a kconfig option where one (distro) 
> can define the minimum RAM size for the persistent huge zero folio, and 
> then checking against totalram_pages() during boot.
> 
> But again, I think this is something that goes on top of this series. 
> (it might also be interesting to allow for disabling the persistent huge 
> zero folio through a cmdline option)
> 
Please make this a kernel config option and don't rely on heuristics.
They have the nasty habit of doing exactly the wrong thing at places
where you really don't expect them to.
(Consider SoCs with a large CMA area for video grabbing or similar stuff
and very little main memory ...)
A kernel option will give distros and/or admins the flexibility they
need without having to rebuild the kernel and also not having to
worry about heuristics going wrong.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

