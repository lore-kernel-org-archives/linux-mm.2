Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3CEC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 13:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76CF6B009B; Tue, 29 Jul 2025 09:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E226B009C; Tue, 29 Jul 2025 09:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963EB6B009D; Tue, 29 Jul 2025 09:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 856D06B009B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:52:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3561313429D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:52:43 +0000 (UTC)
X-FDA: 83717442606.16.8A986B5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id D505420016
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:52:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=09CbSNjb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Y30teTyJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=09CbSNjb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Y30teTyJ;
	spf=pass (imf03.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753797161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5UptxTlc7NV15QNmaQUOhxOZX0UPYQKqfHL7gIMJik=;
	b=mjgm5C88rtKtmt0kQO9NAPirN4Dckh2+VsJSyitFE9dnWEhxl9mPC/lscz4Op2lhsd5NKX
	xuQ9M6vJ7Gkn11/juZQDVc7Xx1KXPE8fxD7jULnjwGmyXd83muvvyLUfKMVo0wC12kdNQQ
	S7MySZ8LWGlPvJrlzvHD83NKLAeIs50=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753797161; a=rsa-sha256;
	cv=none;
	b=aQvNA3cQddgQJGzuTSA/gfAAyoO/YGOUG9TVMZvHmP1jg7LKMWTCQJg/d2ckBccjNsg+mN
	RwzEhBaCNqhDBy+WWRtXzYaWyi1HI0f+dBzs5EC2xRTOlFGEBmP09do8Rbq+K6vFisCLCO
	QbuDOmzjDe1rL19vMTJSFfOwGzu9SgU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=09CbSNjb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Y30teTyJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=09CbSNjb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Y30teTyJ;
	spf=pass (imf03.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 358F01F385;
	Tue, 29 Jul 2025 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753797159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T5UptxTlc7NV15QNmaQUOhxOZX0UPYQKqfHL7gIMJik=;
	b=09CbSNjbuqrVikMD+7H4izSIWfIEYIC6+yBgvwka+tVU3JZ+6DYqAWCdh01Mo0gdkqVABk
	z69i16Fsu0B05b/9evPTjsrPXac2fL0TY5TZUGJJK15uA6Zp4uZZzVXok86n/1oKHolTY1
	UrkmncEXO4OkxEiiau2fbZwxW0q/Yqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753797159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T5UptxTlc7NV15QNmaQUOhxOZX0UPYQKqfHL7gIMJik=;
	b=Y30teTyJHv1aRlrlTEZR0cVmdygViEie19/02UqXtJnHS2j4H6GezefvOkvFdGDLLQlq4D
	dMNEnOuzQ/9F8eDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753797159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T5UptxTlc7NV15QNmaQUOhxOZX0UPYQKqfHL7gIMJik=;
	b=09CbSNjbuqrVikMD+7H4izSIWfIEYIC6+yBgvwka+tVU3JZ+6DYqAWCdh01Mo0gdkqVABk
	z69i16Fsu0B05b/9evPTjsrPXac2fL0TY5TZUGJJK15uA6Zp4uZZzVXok86n/1oKHolTY1
	UrkmncEXO4OkxEiiau2fbZwxW0q/Yqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753797159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T5UptxTlc7NV15QNmaQUOhxOZX0UPYQKqfHL7gIMJik=;
	b=Y30teTyJHv1aRlrlTEZR0cVmdygViEie19/02UqXtJnHS2j4H6GezefvOkvFdGDLLQlq4D
	dMNEnOuzQ/9F8eDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EF6013A73;
	Tue, 29 Jul 2025 13:52:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9+xVBifSiGiJJwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 29 Jul 2025 13:52:39 +0000
Message-ID: <568fbe41-e73e-41b9-b147-a5ef419a2251@suse.de>
Date: Tue, 29 Jul 2025 15:52:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hannes Reinecke <hare@kernel.org>
References: <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <f859e5c3-7c96-4d97-a447-75070813450c@suse.de> <aId16W4EaqjANtKR@tiehlicka>
 <3e88642f-3914-42b0-b864-4ad374b659b5@redhat.com>
 <ac7add36-808d-4883-a09e-ef1bf6fd6834@suse.de> <aIiSEpQhWqPsvaST@tiehlicka>
 <41526d97-b3bc-423b-87f4-7e0ec6cd8292@suse.de> <aIi3ao2PV8GrYtRA@tiehlicka>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aIi3ao2PV8GrYtRA@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D505420016
X-Stat-Signature: tjcdxmgkhirbo3bcp5ipanzi1h8cxsq9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753797160-270306
X-HE-Meta: U2FsdGVkX1+Lrbej/tM8VWkefXfqdJ1Hzmp+Yv1BPiNgDJd41Zu2nkEr6W+rS180WzBs72qg9OU1s6mPSiMxNEW00S8ofa0nNJeWF276XHTunwhtrmLFNrr8ZrjNY5j18ujhFcEprZIdmVqXyJwzNAKDWphpD0GwMveN/qzf2BF+NukZUsAEEEeQu3HDbyP6UABvd0MBfjYyAqS1xvK7W38P2NYXeBqqtxUzM0oy/FLzXTul5HXDm+HKiFwFFYgzTutE7Hk6nE9sF3hgUMroHKBmd2YdREW33Om9LLJ/c7TfTtlK823SYlyZJJwWevfdRnaRkZGadrrDIN/TAU7Nn9HFwg3G0yAQf9ljrDlNGy5amjx6yMebnz4wZIFjxwbnzEZm3jcsbNa4NRG7kaGkWCDqgTV7QkxCvttrXNk8DCVYLdRd6wsIBNORkjE39rq3ONHF82s+KQpm4NopSANvFuB9qtN/VeDn8iuJc0qHjXnxQuf3PoQbMAjpgpgFg54Fnp+LhYqnIHaUmYoNIqKcoDxpmUNXnngi7ILfWt65484BdDVY/7U+LUYgV43yAfQiojc1U7AcQPXLnrkH9XAKS391fPcB6pr50n9vcXTGYz7HOQ967wsnKL7UBjwmvtuhBdjIfmDxAon91l48VMTaoUStnSC3RP0tPBQOH2NXSfmDVyOs6T/THSLh5eirprThAn5ubol6QK43frUjCY0tQ7i+X5sqX7uu4Neqa1T0XaqPq5CxjaJokzOaGD3qUlMWX+DLZh1IcwSAnVznwWMuH7GMlVCeUbGRLdSp5fjdHRKyWOYI4FMDSRyhI41+peXZNArnixz5z+CP9wTGfA/m9bSIisyixMwe3YfeTqVdezGrz7I314i86IlO+tOurSyA2DLF+NuYSh5dZztjjppRUmTlGdLzrfgAonmMVe5lnTJgDo6VJG+x2949wllAuHUmWrQygzRI0yfshPU89Gl
 tEIzZ+lr
 b1b2wDZcNkkNEjZ4399r3zApCGHFeEQfZMIkW7Rn4APZgV0ZCTRyWs2+iRHKQr2Pt6exHZM/rRtKlwwv5HPCzMxdR8qduZPe/J7PvNWuPidjqzyk3UW+CzGFa86HvQpGsPM9Sypm14eCTkUGr1FFCR/LFTqSaKi1xUl2UyTjs3jIk4r8Gnm6HuHhxtxC6bgzyf3ZugALo2jFoFB2cpd15jtHQ3P5jFzcQ6NqBcJ3DBom5Am01r9Icyc2uVo8lM6+kAYn35HcYCoxckVbXzO/BKNb176ZccqRF5PM7mLTeT0Rvt0/Hide4QkRTsmkv/yvYC/+iu9zH8UWQ8CSd2LqnGPRG6E2Luq3XiRFby0wfkqCcshQTij1y2+HlBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/25 13:58, Michal Hocko wrote:
> On Tue 29-07-25 11:33:58, Hannes Reinecke wrote:
>> On 7/29/25 11:19, Michal Hocko wrote:
>>> On Tue 29-07-25 09:24:37, Hannes Reinecke wrote:
>>>> On 7/28/25 15:08, David Hildenbrand wrote:
>>>>> On 28.07.25 15:06, Michal Hocko wrote:
>>>>>> On Mon 28-07-25 11:37:46, Hannes Reinecke wrote:
>>>>>>> On 7/28/25 11:10, David Hildenbrand wrote:
>>>>>>> And to make matters worse, we have two competing user-space programs:
>>>>>>> - udev
>>>>>>> - daxctl
>>>>>>> neither of which is (or can be made) aware of each other.
>>>>>>> This leads to races and/or inconsistencies.
>>>>>>
>>>>>> Would it help if generic udev memory hotplug rule exclude anything that
>>>>>> is dax backed? Is there a way to check for that? Sorry if this is a
>>>>>> stupid question.
>>>>> Parsing /proc/iomem, it's indicated as "System RAM (kmem)".
>>>>>
>>>> I would rather do it the other way round, and make daxctl aware of
>>>> udev. In the end, even 'daxctl' uses the sysfs interface to online
>>>> memory, which really is the territory of udev and can easily be
>>>> done via udev rules (for static configuration).
>>>
>>> udev doesn't really have any context what user space wants to do with
>>> the memory and therefore how to online it. Therefore we have (arguably)
>>> ugly hacks like auto onlining and movable_ration etc. daxctl can take
>>> information from the admin directly and therfore it can do what is
>>> needed without further hacks.
>>>
>> Huh?
>> I thought udev was _all_ about userspace preferences...
>> We can easily have udev rules onlining memory with whatever policy
>> the user want; the whole point of udev rules is that they are dynamic
>> and can include policy decisions.
> 
> My experience with memory hotplug and udev doesn't match that. Udev
> sees memory blocks showing up rather than understanding any concept of
> what is the memory behind that. So any actual policy is rather hard to
> define. You would need to backtrack what kind of memory blocks you are
> seeing and what the initiator could have intended with them.
> 
> While this could work reasonably for regular RAM appearing to your
> system asynchronously (e.g. physical memory plugged in or virtual system
> getting more memory) when you always want to online it in a certain way
> I suspect this falls short for synchronous daxctl like usecase where you
> know what to do with that memory and you can operate on sysfs directly.
> Udev just makes the life much more complicated for the later IMO.

Not disagreeing with that.
Problem is that memory hotplug is tied to sysfs (and, with that, to
udev) such that currently there is no way of _not_ sending uevents
(and, consequently, udev interfering).

We could (for any of the 'auto' modes) disable uevent generation
via the dev_set_uevent_suppress() thingie.
Or we could teach daxctl to wait for uevents after an action has
been triggered.

But the current situation is really daft, requiring the user to move
away udev rules in specific situations.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

