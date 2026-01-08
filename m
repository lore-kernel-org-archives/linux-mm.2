Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A6ED148B3
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 07:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F26D6B0098; Thu,  8 Jan 2026 02:21:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0556B0099; Thu,  8 Jan 2026 02:21:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474DD6B009B; Thu,  8 Jan 2026 02:21:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3164D6B0098
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:21:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C622B1A0140
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:21:57 +0000 (UTC)
X-FDA: 84307952274.23.00ACD0D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6930DC000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:21:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="k7sq2h/U";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YOJ2Gb22;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="k7sq2h/U";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YOJ2Gb22;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767856915; a=rsa-sha256;
	cv=none;
	b=WIhSpwgkGd+vvdqFyPoI6dh9iu+z5kO2U1neuZy3iOwFCttWHIEZ4oK0COz1DAHTXH6WFA
	JhR/7i1cgk99Sot2UCk0STrPswzOlKPjAKRotVytxBGV4uKJ1rTg31nkdIhCgtFaojpn04
	rMAollvNKRFaJ43lUwGpLDb3t1VUZb0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="k7sq2h/U";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YOJ2Gb22;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="k7sq2h/U";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YOJ2Gb22;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767856915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=6shEiqTXs13XT45v9m0P7y3BcVNuzmFRY3BdOc0HA2RDko1JMqW1M/NcH1KBhcY8UpjRgW
	u/z8IZEOYBxL1ODNTD+RrtXVGqwys+sLB373tpXWN3zp1VntfI9Ugw/La5U77DuSMu3zD/
	1gB/YZjlgfT0Q32qmSgq7dhwq8+gPwk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B0B15BD4B;
	Thu,  8 Jan 2026 07:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767856913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=k7sq2h/UYUEV+395NMvu+8QoM+uxG+8nkiywu1s4MIRrFciMVO136oRGxKroIDyT/pAi9b
	ziMpFviiU/K6Fwi7NbpfBNiEkYH82NZUkLKDf4hUZy9VMEgR+IiCqyq1ac5kmjHzPos6dY
	zRR2gneKqJnbx3Q6L6X9wWOgOOfhYkM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767856913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=YOJ2Gb22w66m5qNO2NFip+swTFNpyfFOy2FKAFmt/y6QVkaEfmNAR7jRd/e17lF9Q91/zc
	sY+fVriCCQsWGTAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767856913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=k7sq2h/UYUEV+395NMvu+8QoM+uxG+8nkiywu1s4MIRrFciMVO136oRGxKroIDyT/pAi9b
	ziMpFviiU/K6Fwi7NbpfBNiEkYH82NZUkLKDf4hUZy9VMEgR+IiCqyq1ac5kmjHzPos6dY
	zRR2gneKqJnbx3Q6L6X9wWOgOOfhYkM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767856913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hix/dMrgJrV/xdCA3OkWJsnhgRwjwab541MPc+utOIU=;
	b=YOJ2Gb22w66m5qNO2NFip+swTFNpyfFOy2FKAFmt/y6QVkaEfmNAR7jRd/e17lF9Q91/zc
	sY+fVriCCQsWGTAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E63E3EA63;
	Thu,  8 Jan 2026 07:21:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BRrKARFbX2kqIAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 08 Jan 2026 07:21:53 +0000
Message-ID: <b4ce3096-aa52-4cbb-8d5b-c787c1971147@suse.de>
Date: Thu, 8 Jan 2026 08:21:52 +0100
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
X-Rspamd-Queue-Id: 6930DC000C
X-Rspamd-Server: rspam03
X-Stat-Signature: yspy5dtikdp5a3bwqbb4nytfsaorm5th
X-Rspam-User: 
X-HE-Tag: 1767856915-798367
X-HE-Meta: U2FsdGVkX19RiFj8gFwc8xQcuZ46nZ+UmeRpsZG5fDGqWJDbczGXz5ahSnScjOl++3wn6nM8X+T4DC9k7C4ayBWiztl99uCayni8Ic7rdKAX5jHmTXE2lZvF3877zcxBU7jU1OVIrEoBH3qVt6H8pNUeE7Nj5xhuRBOGgEoe04k+3MFK+SRq2P4C20QnKUKQA8KHGarWNXqfvHX84GxqJjCi/qdPtOdhfQx5+hHD9DFaUXKsOgXsSxIS/J+at2weWiENG/CNrdlH6Yt7+lBWL3EfFPp1gqN0wGzECCiMrb6CuKSU8ilGfxOfdJFXx4830KhTvGwgFSns4HDhXrRbodjK0WM/Cqpa87oGMQL7sAY5o504kxPG+cgfTIyvg9f6D5umNmeWfncrJMntIspTf9I6ZHoJM7EeSojJwYQHuL24oP46GahpxNtjJN9RqDtVrvp2qC5YTKIYctpcpP/VLkB2yGEo5e4uH98KdPKVbK8fCiCOlsjaK+RfT+jf5k7xpERgfBJQ+8zNhYQymxiGP49C/wO3/yFNfGo34BBj84NfPZNzKDpfclSPXoJtlQRWXff6PJR8KiX1VbCSBnDSLhO/oWevwBEZRfHtUeJBltmlc823fhS+W6HgWbha9VKMQoEDi3/FNCKl+iEX9i4uOIKKgIZwxCCsASafSSP7DN+/wCjvbNLpHq+Y5FdkDn6F7mDDFEilUrk8YWxEbE4sN/sRETBoX70E6PFyDibOiT8fXUh/lItz26pGFuKrFboIJbKarZVV3O1dayhjgzJpP/N3Xejz0PllHuWx7FHv+dM/OpDO6sCCwZ3tpKFwW6DlDDblQlnGeYjFjL+4Afl+nW+84ayk8JJQWZh6h5Bd5OoFa7sRa2osy0SXN4eG9WBMAaVDnVfyj04Nh02Lrz8WKeoQw06dl6y/7Ql7I1XbL0H847uy8Z7uY8omT17ig83PAL6o576S+YtOG/K45x8
 vrBKxfYU
 3wuS9Yxq7NCdX9JLSzGN6iAXU2URCib0PnaO2r6a5fcjj9qsezH2bhQXpkRZ3OZC4Nn7fjJwSdM1nIY4vPehpCtTte+uCxg2cdMRefg2kS2Kxzp5apbSCVZkgEvXzGpQnQEccpD5t4DFNX1NP0rHJdy1GVtsL7kswor2yiW5FcJbOTPWffguQHJiMkhABuyEKcizwyJ+K/jaeEv2OO67Mxhw/eeaEJQXOzH1yv+upFj0PMe5Dya39oMxP6K+wrP1vdRL448X2vfq697HgTgeq9/rtIONNRhYMyfEjPIYoApUoi5e6z3+HOBxtdRn39D7Lfg4qfAvZTg/IqWzA/zxdpgNBckF7SwdL8Tbay0hHKMgwW8+Ufrjvj7zYoiGyfiLRfB/z
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

