Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABDFC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E2E6B00A2; Tue, 29 Jul 2025 05:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B259A6B00A3; Tue, 29 Jul 2025 05:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B476B00A4; Tue, 29 Jul 2025 05:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 940176B00A2
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 235F21D985F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:34:03 +0000 (UTC)
X-FDA: 83716790766.22.4BAB819
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id C84A240009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:34:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nCPWu8FI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LvD8E65l;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nCPWu8FI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LvD8E65l;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753781641; a=rsa-sha256;
	cv=none;
	b=XE9BRzcVhdMHKUh8f2YkCImYeoJWg1nNEnZKwv7tJPiy779isI8d2BWm1MouncAzlmKd2q
	Qcv9tQyKHstbAIWy/MlJiDCX8lS7r3FbDET6dETlLe4N5BvDG6xkdzOa3p79B2vVeg1BeB
	tUhcVo/+R/qSNFYxq/ISTPwpXsEVgH8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nCPWu8FI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LvD8E65l;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nCPWu8FI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LvD8E65l;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753781641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1Ol3IOwokV2gFS2XNvt3TlezxClZn1L3WQLcEZeGBs=;
	b=0FnETGfFGRTMSkzJ5rRGwGivzGDhONUXudcdhIeT0n3y493zgNHiDuUKxbgoqAFbQ3q2l5
	lzBNOBvoC9ySEaWsvk5zGCs10itsw1sHkZshmlbTWoEXBI89nq4BeRH1qi4yHmvGuaQ00G
	DmkXJzBu2XfIBCsqBEsE4mhmWysVTL4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 22EFB219EE;
	Tue, 29 Jul 2025 09:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753781639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b1Ol3IOwokV2gFS2XNvt3TlezxClZn1L3WQLcEZeGBs=;
	b=nCPWu8FIoK/1/ulsLh86lMUXeFjGShnQcs45DiGutK5briCI1SSWpthEy+NSaCxUNQsgXY
	bPc99kzVGYtkKkB/K92ZA5cb8xFukx8KBMZiC70nyVNw0dxKTGtq+V0xk6907fea04KGGR
	Pm07rSAuuyhV053I4AKaTzzA6ZUVNlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753781639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b1Ol3IOwokV2gFS2XNvt3TlezxClZn1L3WQLcEZeGBs=;
	b=LvD8E65lVyOAqmbwPDDWWKDL6hqYBrTDC2eio/p8MMfPSoDFu9DSatiUIKmXCG53nzVhr/
	/KyzMOHSXfUlnnAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753781639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b1Ol3IOwokV2gFS2XNvt3TlezxClZn1L3WQLcEZeGBs=;
	b=nCPWu8FIoK/1/ulsLh86lMUXeFjGShnQcs45DiGutK5briCI1SSWpthEy+NSaCxUNQsgXY
	bPc99kzVGYtkKkB/K92ZA5cb8xFukx8KBMZiC70nyVNw0dxKTGtq+V0xk6907fea04KGGR
	Pm07rSAuuyhV053I4AKaTzzA6ZUVNlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753781639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b1Ol3IOwokV2gFS2XNvt3TlezxClZn1L3WQLcEZeGBs=;
	b=LvD8E65lVyOAqmbwPDDWWKDL6hqYBrTDC2eio/p8MMfPSoDFu9DSatiUIKmXCG53nzVhr/
	/KyzMOHSXfUlnnAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C41E13876;
	Tue, 29 Jul 2025 09:33:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NYCLAoeViGizUQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 29 Jul 2025 09:33:59 +0000
Message-ID: <41526d97-b3bc-423b-87f4-7e0ec6cd8292@suse.de>
Date: Tue, 29 Jul 2025 11:33:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <f859e5c3-7c96-4d97-a447-75070813450c@suse.de> <aId16W4EaqjANtKR@tiehlicka>
 <3e88642f-3914-42b0-b864-4ad374b659b5@redhat.com>
 <ac7add36-808d-4883-a09e-ef1bf6fd6834@suse.de> <aIiSEpQhWqPsvaST@tiehlicka>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aIiSEpQhWqPsvaST@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C84A240009
X-Stat-Signature: o816co9kbsm7c9sygqnafnnfzkbqamts
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753781640-986139
X-HE-Meta: U2FsdGVkX19MN1IQBdKAilBa6+ubxmT7llx5l7HcDTlBh+Vi3K63AhCtikPYuKrPgJF9XqR5PB87Px/bj4oKcV+yeDhyshPnV3w3gGmLGNmHnRlsn/VI3jmakfhWGYiNrLaz/tAWT9D0tSkuj0qxtvN2d2B4ffqjAvOBLyQ6dxTTjq9IfOj6fWtHOb3EorJDGyZNuYHx/cSU63OfPbvckv+tQsjWHsoez8VLXSKDC1QgtSgWsaJF7HjYc7/0X8UFsUlWoyzV5hwQ81a8Z089sbnyPmUZ/ERmMuxVfSImyp4usVRmkAJBO3VuzPd4grPzAIFgwc41alSad4Wkz9FAtX0osZIauc9ZiXcUdnHMbc6YPo8EfhB50X2F9zo+EXTX7g/uaCl5CzKtRuOcY9cCTzt6gpNqr/A9NQRYARxdVe9vjLXoroMsiCKox/ndJouxqlNuK5FAuAsKGAZ8hQRw8FOLJ3df0rqdplduo6NFKUGe7UaXi11UtUtRrPEAK2NqobjdkmrZFV0DTLMo92GkjCk5Lekj2qBONtcibu8khxfNLB+82VTBK7UaxbhXbPgPWLkXx/DaFG+9r8wE9rXh1CDr1jzw1IWLqkVi/zkHRAiB6d9xu8e/3HAkiE4BtNXMXoF/cXxQHDr/Igfi2S8CKpEG7y5dKrl0wCcm+QmTzYINN6UQKjZLyjSW5sljOguZSLi2P1nA9S6jur78PZo7rFWIR36T5uydT41AgZu7rPwiZf2kic0KIxdokYNZ/1wYUt2eAe6slJKrrwvTbDsJLOI8/WF/b9uEV6V0/qHTa4MdlYVwAS32+2xIM5fIDDuYo4W/fpFLvcxjeZqsSb05auRMykEQR70XFSq19H73nk2M9Ba2hG6o2qBbpjCQOVVKj5Ku/rZC7TrVKGqgu6inDleXdgQkJvL+OuBd8i62R0VFrohdRcMzlCA0+oRXie20Uo9dLS4d/QPxvXdrSwe
 zybcAwM1
 WqsKhu0RixEVkE0Zrrg5hwmMW0z9FXKza/Rjgm+gTBAwnEuzaYT86gHjCwvw96wXIKcynzqcNt6Qa0Vu7ftgqzIiDahe3fNJSenE/A+N8gCN4/2yCmeLxdKLBaXP1EVlLzar9LOhctDZSqkxVLkXgv0LsSXyHlPNjLSE0lfAIiWlo1V4cr0ZUDUvhPvTMNhzQBO3U5TkZpvr6i63Jm23YEFAI6I9qIUUNtafcbj1UkafVZuKNr76BAgeKcDmyMT67eTLblc3z1DQgiLzyk/XHQ8TYSQ5FeVtJY4W5VfeGl99n9WrOXY2vJw9Mzgdsds4h2GwVPZtr+3SfeIZoY10HUafHraDrO+7Fk6xfPFZwB/vfRrxL809ViZkdrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/25 11:19, Michal Hocko wrote:
> On Tue 29-07-25 09:24:37, Hannes Reinecke wrote:
>> On 7/28/25 15:08, David Hildenbrand wrote:
>>> On 28.07.25 15:06, Michal Hocko wrote:
>>>> On Mon 28-07-25 11:37:46, Hannes Reinecke wrote:
>>>>> On 7/28/25 11:10, David Hildenbrand wrote:
>>>>> And to make matters worse, we have two competing user-space programs:
>>>>> - udev
>>>>> - daxctl
>>>>> neither of which is (or can be made) aware of each other.
>>>>> This leads to races and/or inconsistencies.
>>>>
>>>> Would it help if generic udev memory hotplug rule exclude anything that
>>>> is dax backed? Is there a way to check for that? Sorry if this is a
>>>> stupid question.
>>> Parsing /proc/iomem, it's indicated as "System RAM (kmem)".
>>>
>> I would rather do it the other way round, and make daxctl aware of
>> udev. In the end, even 'daxctl' uses the sysfs interface to online
>> memory, which really is the territory of udev and can easily be
>> done via udev rules (for static configuration).
> 
> udev doesn't really have any context what user space wants to do with
> the memory and therefore how to online it. Therefore we have (arguably)
> ugly hacks like auto onlining and movable_ration etc. daxctl can take
> information from the admin directly and therfore it can do what is
> needed without further hacks.
> 
Huh?
I thought udev was _all_ about userspace preferences...
We can easily have udev rules onlining memory with whatever policy
the user want; the whole point of udev rules is that they are dynamic
and can include policy decisions.

>> Note, we do a similar thing on s/390; the configuration tool there
>> just spits out udev rules.
> 
> Those were easy times when you just need to online memory without any
> more requirements where it should land.

Sorry, I don't get that.
udev rules can easily parse any user-space policy, and you can have a
policy as detailed as you want.
And each installation can have its own udev rules.
Why wouldn't that work?

(Excluding main memory, obviously. We need memory to execute userspace
processes after all).

I do think we're talking past each other...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

