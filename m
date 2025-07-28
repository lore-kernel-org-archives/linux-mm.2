Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B7DC87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 09:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E346B008C; Mon, 28 Jul 2025 05:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEA56B0092; Mon, 28 Jul 2025 05:37:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD616B0093; Mon, 28 Jul 2025 05:37:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 589E66B008C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:37:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A8F41103C0
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:37:51 +0000 (UTC)
X-FDA: 83713171542.02.FB91AF6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9E685140004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:37:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MV3XvI68;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EOCcelY1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Uy2a9FaF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3qE+6ezY;
	spf=pass (imf26.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753695469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IE9U6OMxCGjM6BaaeVh2n1CZTcMjCiAKBAY0TDI91Y=;
	b=Lx43NwRNW5LddqIJ4aSwORtysxs1ye6f7bzj4BBsj8OKAx+ndE+PUnE5MUJFoyVdZ3IP8N
	8D2hzWJwgG8q26pwr+fmO9SH6K0hEfH9GREJ1pjhUjNIFvn89UC063VIX9Jn4SJyyaJiRg
	/ghzE1Wu5yF7pw5VWCxG26ScExBya80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753695469; a=rsa-sha256;
	cv=none;
	b=iVUy8iT6+2cDcDcBsATtZKUwC6jbBpHfZ/XBBAzhsCSWUMUM1l3TYqnlABLbDuYkTpqyKb
	PsMLaO1Fns+KJG5mFnYGQ2IZxrLj+MDRD18H9hRxuVc5GJwj5qJ4iI0BR4yU/c6cvlAuDj
	rNS9G1kS/QTSV0ubKurACmZRLPvzpvE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MV3XvI68;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EOCcelY1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Uy2a9FaF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3qE+6ezY;
	spf=pass (imf26.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D57651F46E;
	Mon, 28 Jul 2025 09:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753695467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8IE9U6OMxCGjM6BaaeVh2n1CZTcMjCiAKBAY0TDI91Y=;
	b=MV3XvI68EaAhDVxo0SZpjxp/6+QieP/lRCdrWRKZWAMej5hc6P4zIfWpOx79wULT+OGIEW
	aGpl623uhF7n0xsjjSz4+881P7cDIv2r3cC1oazCPP+03yYgeeLCWBBOT70PqWnBdV1soJ
	IQAyzoHRwyicmdJyHT0iu4MLtiXK5lA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753695467;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8IE9U6OMxCGjM6BaaeVh2n1CZTcMjCiAKBAY0TDI91Y=;
	b=EOCcelY1PknPkxy+zT3zymPiusp/dZaPQL+COkF+RX0VbjVEP6p2cYFdadD4t7rq8RPbko
	MAag9Sxia71ViIDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753695466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8IE9U6OMxCGjM6BaaeVh2n1CZTcMjCiAKBAY0TDI91Y=;
	b=Uy2a9FaFYIDG3OYqn39VLGXtjI/s8QZ5CGKpXmC2k5OnmIT8c/6d2AxcxqZDyx2zaTT/59
	6JFf3kt4YUdYC+b2WO842Nyvp5NJyw1fyfvLkQIY5ZWby4F/XGsUGdVmfGXgJgQAa49Lqs
	IAPihb/JepChPq4DjVpq97c00MOhkIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753695466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8IE9U6OMxCGjM6BaaeVh2n1CZTcMjCiAKBAY0TDI91Y=;
	b=3qE+6ezYP763Q8OH6fEKmjdCrsQfo1PxQVfXs6yD3tiQaRvWTKOdceZM4bCkNMd0aj821d
	QI7sDSOdgyTVuyCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE8D01368A;
	Mon, 28 Jul 2025 09:37:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gZvDLepEh2jjMAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 28 Jul 2025 09:37:46 +0000
Message-ID: <f859e5c3-7c96-4d97-a447-75070813450c@suse.de>
Date: Mon, 28 Jul 2025 11:37:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E685140004
X-Stat-Signature: c5rkjr1mu73e7woqsyzefy435rf5iy1e
X-Rspam-User: 
X-HE-Tag: 1753695468-654806
X-HE-Meta: U2FsdGVkX1+IunVrPKYwZhpCdKtX1BMHAHF0wXhv+zcn85GHUzmGw6IFB2lMx9BMyje/nGnQ3xsM/PIayTLW+6FgYD1budIrIiMqXiRY7yu+6bwAfpRot4yfYlPW5Z4Z3N2RPghh3Ii69P3g7z5ugt51RD7W5lm1z8ZZxmgawdbFIKh2103ScM7xnNIVQooD4GOWw/QHxoQ/trML8Wb+tOIoxaSIO3yZRo0ogpxTzjelU0vt1RMcoJtF3Sn6srI1OnXR280Y4myGzTfUFVSrvKatd7Cx9O4WZqzCHTD242WsEG3gVSGgmy9YGT+BWIymF4qv4Bd0tG73F+uQQychbM3TNGqodnrpfsufhD+B8xqE6h5IWmb1HCIDCimQJpQJsu3MkqCybAfyWQFpdz28JPizpN8OI4/YjD8dxNocfrvDLGMpSC1yjbVCuOlGy3g/F6Q/rY6/Yynt7pUsudYJII3agJOUargNsLzhXHDRWCR2AE9IRIiryJEuy1+useu8lJg29sc1bD4bz8Pv07q8oBiIVjnOngxI2HCal94pD8tpkolvK3TIZx73Kg8z9wiD2M8N486G2IPM2SNqTfBJkG9wXdnt1Y2XJAcJQcjwhnau/Q8ckolSjuuSvLVkXvv9+pyJqcpWUSHYmTll+e3OB00C4D0SqBCEQZosFU1xhYFPEThpKYOtlpoCwbz27onDUE+5CLsAq1a4MJM9+bMdIwQZzloffZ3NKQTNP9nz9k/2UbXtSkFXbyW9tBEnFjZqSr9zNRQg5YEmPl5B+JSzSS3YPhpFLXHbJ7MBzS23g5FrM488QgDZSbThdr420IrQjzsJSGUvDyGiUqG9PuG0QDBt7HdPGRj+7vXDxB+sNVP7LBUX6iSLd2VHdHuWDVGRsKzjIo2Tcjv3dC7wXAZ/LvBeSK3uNtkDxWmFPTR5FgRgqCT5skpqkqXOYLWLTedL9SJH1YjtCKKYC5Zrh3g
 6HcxAI3/
 RasnBLLZ4uSWGvnYAomfBJVuOb916QkIzFm4ILMhprEJe7DTVCsM5K1K289+FmnOWhMY3GmYm4z2cCfkStij4TildOHV4GxtLpaaChdUe4mqvX7auSkmeXCHscrgiWjHx7BI7Qa3VNC/DENXwCcR51YbFiC5SGvgqM51fA8rPY9ovRPC+jcYpSAtEy2NVNxxo/P4LfsIVASbKvzSxSfbzbGWz2rcho/BBEC6ukEbrY3JDpq7C6VPqU5lVbaMNXE1dWd6wLhpHL0wA/0WsEZxo8xm+hnd3Xr76MJqycpL3idl9fll3yjvQzivlh/PbCDk9+WqKAwfEPsSzhmFHelkTfXQ9M6gEtR7EEwO6dB+z20pS1p5scCdOQ/dHpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/25 11:10, David Hildenbrand wrote:
> On 28.07.25 11:04, Michal Hocko wrote:
>> On Mon 28-07-25 10:53:08, David Hildenbrand wrote:
>>> On 28.07.25 10:48, Michal Hocko wrote:
>>>> On Mon 28-07-25 10:15:47, Oscar Salvador wrote:
>>>>> Hi,
>>>>>
>>>>> Currently, we have several mechanisms to pick a zone for the new 
>>>>> memory we are
>>>>> onlining.
>>>>> Eventually, we will land on zone_for_pfn_range() which will pick 
>>>>> the zone.
>>>>>
>>>>> Two of these mechanisms are 'movable_node' and 'auto-movable' policy.
>>>>> The former will put every single hotpluggled memory in ZONE_MOVABLE
>>>>> (unless we can keep zones contiguous by not doing so), while the 
>>>>> latter
>>>>> will put it in ZONA_MOVABLE IFF we are within the established ratio
>>>>> MOVABLE:KERNEL.
>>>>>
>>>>> It seems, the later doesn't play well with CXL memory where CXL 
>>>>> cards hold really
>>>>> large amounts of memory, making the ratio fail, and since CXL cards 
>>>>> must be removed
>>>>> as a unit, it can't be done if any memory block fell within
>>>>> !ZONE_MOVABLE zone.
>>>>
>>>> I suspect this is just an example of how our existing memory hotplug
>>>> interface based on memory blocks is just suoptimal and it doesn't fit
>>>> new usecases. We should start thinking about how a new v2 api should
>>>> look like. I am not sure how that should look like but I believe we
>>>> should be able to express a "device" as whole rather than having a very
>>>> loosely bound generic memblocks. Anyway this is likely for a longer
>>>> discussion and a long term plan rather than addressing this particular
>>>> issue.
>>>
>>> We have that concept with memory groups in the kernel already.
>>
>> I must have missed that. I will have a look, thanks! Do we have any
>> documentation for that? Memory group is an overloaded term in the
>> kernel.
> 
> It's an internal concept so far, the grouping is not exposed to user space.
> 
> We have kerneldoc for e.g., "struct memory_group". E.g., from there
> 
> "A memory group logically groups memory blocks; each memory block 
> belongs to at most one memory group. A memory group corresponds to a 
> memory device, such as a DIMM or a NUMA node, which spans multiple 
> memory blocks and might even span multiple non-contiguous physical 
> memory ranges."
> 
>>
>>> In dax/kmem we register a static memory group. It will be considered one
>>> union.
>>
>> But we still do export those memory blocks and let udev or whoever act
>> on those right? If that is the case then ....
> 
> Yes.
> 
>>
>> [...]
>>
>>> daxctl wants to online memory itself. We want to keep that memory 
>>> offline
>>> from a kernel perspective and let daxctl handle it in this case.
>>>
>>> We have that problem in RHEL where we currently require user space to
>>> disable udev rules so daxctl "can win".
>>
>> ... this is the result. Those shouldn't really race. If udev is suppose
>> to see the device then only in its entirity so regular memory block
>> based onlining rules shouldn't even see that memory. Or am I completely
>> missing the picture?
> 
> We can't break user space, which relies on individual memory blocks.
> 
> So udev or $whatever will right now see individual memory blocks. We 
> could export the group id to user space if that is of any help, but at 
> least for daxctl purposes, it will be sufficient to identify "oh, this 
> was added by dax/kmem" (which we can obtain from /proc/iomem) and say 
> "okay, I'll let user-space deal with it."
> 
> Having the whole thing exposed as a unit is not really solving any 
> problems unless I am missing something important.
> 
Basically it boils down to:
Who should be responsible for onlining the memory?

As it stands we have two methods:
- user-space as per sysfs attributes
- kernel policy

And to make matters worse, we have two competing user-space programs:
- udev
- daxctl
neither of which is (or can be made) aware of each other.
This leads to races and/or inconsistencies.

As we've seen the current kernel policy (cf the 'ratio' discussion)
doesn't really fit how users expect CXL to work, so one is tempted to
not having the kernel to do the onlining. But then the user is caught
in the udev vs daxctl race, requiring awkward cludges on either side.

Can't we make daxctl aware of udev? IE updating daxctl call out to
udev and just wait for udev to complete its thing?
At worst we're running into a timeout if some udev rules are garbage,
but daxctl will be able to see the final state and we would avoid
the need for modifying and/or moving udev rules.
(Which, incidentally, is required on SLES, too :-)

Discussion point for LPC?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

