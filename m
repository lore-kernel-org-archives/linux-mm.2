Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763F3D148A3
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 07:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDBE36B0099; Thu,  8 Jan 2026 02:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB69C6B009B; Thu,  8 Jan 2026 02:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93F46B009D; Thu,  8 Jan 2026 02:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA1AE6B0099
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:22:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 620EA1405E2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:22:15 +0000 (UTC)
X-FDA: 84307953030.26.BE8E06B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0CD45C0003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:22:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bYJLhjlP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NxuYnSqq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=a5NGxaQL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oeAAJ2iR;
	spf=pass (imf22.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767856933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=7ix/10TDcZMd3tA9tsE2gqbvyIG/zE8jmod8PrE1TFJT0MMrP+UU9VJFyvK/vx5pMXe3eE
	NugOTyyfzxSvA/LvM52bKFXj3P1ee2Rpyr+EQtvMwjVdD5fnQUv+RwcgxGFP4u2ho1Chmj
	j7DK8rHP2MOguu7jqDLXCSYXYno801I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bYJLhjlP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NxuYnSqq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=a5NGxaQL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oeAAJ2iR;
	spf=pass (imf22.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767856933; a=rsa-sha256;
	cv=none;
	b=swJOl0JX64v990MmLAKXF5lXGfEZ11Trc/DQYQNiLwxudM5SgnTR1j7XGcKcW2uToIr68A
	nejRs2k2yENQH5Ad5n9yLOh7Gtizz9J3xpKL/vF6TzKPnxfMUWYvXLEdeO1IdkG/5HCG/J
	S4SCFkTFrjbwglndREjPNR0PbYReT6k=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7A2165BD49;
	Thu,  8 Jan 2026 07:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767856931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=bYJLhjlPNve1PywKtd98NxYNI+91QWQ0P8Ka2C+1NGgtuVtbovebu2/bflOgJn2SGfINtA
	flyLtILhSMTY2+h1zu2Z7ke6yPlQpdobXCAhuNn0WMDss/ayAX/2bF/4rASMgZFELIPmwH
	NxcJ9IfJq4lGc61ZhgtstUDQ6iGRAjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767856931;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=NxuYnSqqAybBeauf8DGpVEGKA4EfUFprxcklypRpPYHn+wXIlEbLAIinTompVCfke6cBWn
	072b8DY5H+s/1cBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767856930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=a5NGxaQLHR3iMA89x+BYxK2z2utTGOGQZtPgTdbvuCJzUqbGamHcP4y9gFyvmemlPlP4D6
	r0Bk2c9rBqde43NZY3Mt9aamti0ZUCV3gdfGJUpmUKNFf2pmQ82EYsi/lT9Pvq0JqxB9PR
	y9VBqUasT/DkeWXW4TkaV1XMV2+2Dls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767856930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=oeAAJ2iRRDRE2nvq0Tf7JOOh1vIjud4fBzp7E6iKKOAcVC52SYPS6N2gIKJgGn+6I0gJH1
	n9AlLo7Od6p5W0DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 001933EA63;
	Thu,  8 Jan 2026 07:22:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pxEGOiFbX2k8IAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 08 Jan 2026 07:22:09 +0000
Message-ID: <f2322eb0-e21b-41c9-9063-2ed95c800a65@suse.de>
Date: Thu, 8 Jan 2026 08:22:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: Gregory Price <gourry@gourry.net>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
 <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
 <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
 <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CD45C0003
X-Stat-Signature: nbazrk118qjo45waojyzatreokeocpm3
X-HE-Tag: 1767856932-815430
X-HE-Meta: U2FsdGVkX19dDFdyx8sC6cnDBJyE90pucmdzBIyfQ/ETcDk4XEcjxCpJ70CDApQiYbhLoOXmVx8d6qcqANfKX/w1dEhhUjgZxtTigbCQnL2s17QvLU91Lrr0vmDuZd4DjTdkY3vVgF7eSbmNAQHi3UHyDGFzgjhWqemBJoazI0ZkracvZl03N6kqkl1xd5cd40HDw7pVm17Tfc/1jcUGMtdV4UF5/yCA5I+kcvy6r4eJ0h1S6PzUsz9LxphffKIlqfSi9eSMcerN9UvuEqrVij6/h9S5R96TjtyxWdSCsYU/WCJySsmRrf7B+Gya4LY1yIuqTIuy9/7NHwKlZwzyNqg3AONVyYPgqBraZzLFV7tXclIMeIQv2BrFSiW10x8luyPIKZua+ueE3kkTbIQZwCLTal0mut/Hzre898POMm6DNGWzBPqyGolDSkylPPMqTYWjXTzG3/LQYlMcd5RmQ/dfLn4yS4PvdKC/K1ZnC1shoyUkBNkPZRDFmI3NMO78otNiXGu0EGRKJAfXGdXURrWnfhUhRWKa3VX/Gj89/zMp5eYn5taqHcVad0iZQCqA/zUxPymmvy9OtcwpgKMzvHjzyCtj9z4unwBnA3Hx0e7gKdz5Nk9S/DFBWOhbNfjMLM3HEgr7nVGvn8+jcr3ANyO2ly6aVLMwTyZjcO5yIWARJ0Zz4e+0By6mMBoi5TWFqBso3m5XVa4uLjfjalKRp/ek8kv7/++LODEpvlWhC3xbGuse/QsoQZ26KO79rPRThf5K2EQoh80ot2wIxe6Mr5yLxMWzRjOAzm6WeGZm2gCGjht1GR/f0Zm8qJze5r0O0xzF3NYF0FqKQS/VNaSml2LXmtyHLYxni+OQE4AASR6SYOwKS5vJUT8QlxEVqKwqmz2nQVLvC0OgzX1GAipvAsXK6ah4lpv11iVAViK22SSQeZS1U2IMAyZzo/MfAGRaqyG6usU9AI+Q+WyoRWg
 +PtJ/g1X
 4VshNKZPG19o1OmhvfFFjS19w4ohWFF/be0176dCr8C48vD4OP5djao65SPTCw/2WRb5Rn0ZQX+B6hp7pj/GUiHr0lfxOsTwGJtdm3b7Nnx7GcZd4d/r8+cZR22YMzhsoYOJNrXVDK8BSLywMPnus2ElG9SYAzdmAIzdbbLnaUMi5KK8jlZm4x8wNfu09QEEtfDa0yV6B8qxE+tXEYceM5wmKvoQcREYoe3XbXx3ZdEZDE3C7bHdvKuQJN7jzeCfWgHVBunJRonHnyvBMJVMxfAikzqwQXJff4NpV6Px/NsOuwylD6fiXWQwZQ1pUApQA8EW/T9pSvoVV3zC6ayV1rkrdaO8Y451e3ZtVnuUXcBvtmqu4ZVFCbviOX6WuiSd5FNGA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 19:06, Gregory Price wrote:
> On Tue, Jan 06, 2026 at 06:52:11PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/6/26 17:58, Gregory Price wrote:
>>> On Tue, Jan 06, 2026 at 04:24:21PM +0100, David Hildenbrand (Red Hat) wrote:
>>>
>>> I'm not against this idea, but it also makes the sysfs a little more
>>> confusing (`echo online` now does different things based on prior
>>> state).
>>
>> Right, but only for the contig-zones policy.
>>
>> But maybe you really want the default for such memory to be "movable" even
>> when not onlined beforehand? So I am not sure if the description of the
>> problem here is accurate.
>>
>> Isn't one problem also udev racing with ndctl?
>>
> 
> Yeah there's a bunch of races, the specific ones mentioned by Hannes i
> need to go back and re-listen to the talk.
> 
udev racing with ndctl is a general problem, and not specific to
zone movable. We definitely should be looking into that.

>>> I preferred just failing if the block wasn't compatible with
>>> the zone (maybe making it more clear with a dmesg print?)
>>
>> The thing is that this block is compatible with the zone, no?
>>
>> In a system where you would never want to offline that memory, why should we
>> stop someone from onlining it to a kernel zone? I'm sure someone with a
>> weird use case will show up later that will complain about this.
>>
> 
> Presumably you wouldn't be setting the MHP flag that prevents the blocks
> from being onlined in a kernel zone then - in which case this all just
> works as intended today.
> 

This is _not_ about never wanting to offline memory.
Quite the contrary, actually: we assume that CXL memory is
hotpluggable, and as such online and offline will happen.
What we need to ensure, though, is that all memory on CXL
always lands in zone movable.

>> But the patch is missing details on who would actually set MHP_MOVABLE_ONLY.
>> A user should be posted alongside the core change.
>>
> 
> This is fair and probably the obvious immediate user would be a dax
> device with some kind of `dax0.0/protect_unplug` feature set.
> (With a better name obviuosly).
> 
> I will defer to Hannes on his specific use case, but I could see the
> CXL-DCD (Dynamic Capacity) set wanting something like this.
> 
The specific use-case is CXL: all memory on CXL should be onlined
to zone movable. The mechanism invoking that (be it udev or ndctl)
is secondary.

>>>
>>> Anyway, let me know what your preference is, happy to pivot however.
>>
>> Restricting memory to be movable-only to handle a user-space problem as
>> described here sounds like the wrong approach to me. You really want the
>> default of such memory to be "movable".
>>
>> Almost like an optimized "auto-movable" policy :)
>>
>> Or a new policy that will respect a provided default (MHP_DEFAULT_MOVABLE).
>>
> 
> Fair, I'll revist this once Hannes gets a chance to chime in.
> 
> This was effective at getting the discussion started though :P
> 
Oh, definitely :-)
Thanks for getting started on this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

