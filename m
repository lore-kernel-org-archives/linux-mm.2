Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CC4C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 05:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4336C6B0088; Wed, 30 Jul 2025 01:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4746B0089; Wed, 30 Jul 2025 01:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4FE6B008A; Wed, 30 Jul 2025 01:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19D686B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:50:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8992AB8061
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:50:02 +0000 (UTC)
X-FDA: 83719855044.06.2CEE2CA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2BBBC40002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:49:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gVjgEgG8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3+K0Rg38;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gVjgEgG8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3+K0Rg38;
	spf=pass (imf04.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753854600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yP69FByPBXhKkhsmmFgr+E2ZJ6RQumZOXnmg3P5mKM0=;
	b=vFhslGCXz+KExAqFiK1sE4aIDTGufhRSNUpJbp3U9w8p0rapGVAxOcT3GOdbZLorYHGjDm
	/S7PqiAVu0+Q+x6/ORn+kJcG9N6w5NmUMF6smts6NYNvPA9+kmKXu+JQlrzUQ5a+1ARVOf
	L83iRyhDxK5pi0IggC7dymrTuEM7N5k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gVjgEgG8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3+K0Rg38;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gVjgEgG8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3+K0Rg38;
	spf=pass (imf04.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753854600; a=rsa-sha256;
	cv=none;
	b=PZiAPAq9SZ4ljRo1Rl46LW3i80WPLS1W7LbfQebEPN47s70bKsabEtxJJTSRytImmubR8S
	uNvjdwtqpUJgfLggtBNzJ0pFBZH36lcbWJ5OBOn86aFNpGxJ+RzaW3258bBzVZH+M008r1
	OKsHKLNRSBChP31CPd7HNXGvymafOHU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3D7B121A95;
	Wed, 30 Jul 2025 05:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753854598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yP69FByPBXhKkhsmmFgr+E2ZJ6RQumZOXnmg3P5mKM0=;
	b=gVjgEgG82/18GgMfqbrX1KUIeL3hBAsGTslKh+CV5JhdgdbZ7DKUGYA7RZeziATWxOyf7E
	BpV6HC3cgOc5muyiEZqLcEDK/16KA07DVCXBBrBNm49e/0VTsMg26O0Xw1R+6mMkCZt9AK
	4Xx73+LNWFi4rm8Hqpr7mNkI1tjkCvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753854598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yP69FByPBXhKkhsmmFgr+E2ZJ6RQumZOXnmg3P5mKM0=;
	b=3+K0Rg38Wy1W1hYJJtDqq9Ea/QIqoBUQScJSrxfe4FT4yN6yeeghU5kkYQwhNculNMbcZY
	vJp4rPgqty7yo4Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753854598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yP69FByPBXhKkhsmmFgr+E2ZJ6RQumZOXnmg3P5mKM0=;
	b=gVjgEgG82/18GgMfqbrX1KUIeL3hBAsGTslKh+CV5JhdgdbZ7DKUGYA7RZeziATWxOyf7E
	BpV6HC3cgOc5muyiEZqLcEDK/16KA07DVCXBBrBNm49e/0VTsMg26O0Xw1R+6mMkCZt9AK
	4Xx73+LNWFi4rm8Hqpr7mNkI1tjkCvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753854598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yP69FByPBXhKkhsmmFgr+E2ZJ6RQumZOXnmg3P5mKM0=;
	b=3+K0Rg38Wy1W1hYJJtDqq9Ea/QIqoBUQScJSrxfe4FT4yN6yeeghU5kkYQwhNculNMbcZY
	vJp4rPgqty7yo4Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F19D613479;
	Wed, 30 Jul 2025 05:49:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y+1AOIWyiWhbKgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 30 Jul 2025 05:49:57 +0000
Message-ID: <907ee759-6051-4d47-bf09-cea362ac0cd9@suse.de>
Date: Wed, 30 Jul 2025 07:49:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 0/3] mm/memory_hotplug: fixup crash during uevent
 handling
To: Andrew Morton <akpm@linux-foundation.org>,
 Hannes Reinecke <hare@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org
References: <20250729064637.51662-1-hare@kernel.org>
 <20250729133806.979475704b1162d7aea99b2b@linux-foundation.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250729133806.979475704b1162d7aea99b2b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: 7asungicawkpbhwcy5ynpx1rn3ngt1jf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2BBBC40002
X-Rspam-User: 
X-HE-Tag: 1753854599-227376
X-HE-Meta: U2FsdGVkX1+3AqvIFOJ1OgNLBwD7v62fy2kDrqk4dKVu1Cmdz0lHHI9SLQnt6ZOLtZKmq8unPC2/0VTHgpDn+c1UAQSyKVXJdMFO00L64KHW4Vc0dke62JybF3PQw9ChrPM+Bzwi5SaG4Ac54jCeE17uxv7Ue21nc/Evf02hV2Vkb1iZ3iZuhBjIeG93rBUKaYnNiYr92o/lPADVtciBXtPV1Jp8AvB77vQmS2oANPbFtyC0OZkRukeqYdBq4uTH4b35h9kvzBfuzPd7vAW2uS9ImBiWNST1CG1wceyZVkiYsvvTpcwMVqTyruxPG9MlZW1p6MBcjEx3FB3JNChMo0JC9V0AZFH4uzCck6tbIuzloyhgRigBKrMbBtGjMFA0itPGDYYzFC094K8sCwU4OxP/7CvTqKHf05wIZuCQT8CusU5WUdP2uMypk00t1g36D+UG5NPX/Le+LLVtHhmNK552JQ30N3ZoLchi/ck6hkl2oGuvhqESYZnmpXq0/WbpWt+y/h4f2iQ4l+of5no2Lanb01OTrwKFfzEHSj8hEmxU+B5bN0PCfEY4fR0MJzBkSLbVosi1JFPh++MIrnAIdkq1lz2EK+NETka3hW6H/+8xRJEJOnQVMwo1VK3tAIqFOSv8HTFS5tfxtWbOgzVlZd0xyfLVmuL/tfcijfp9dHwZ4G0vMJjmM9ipIAbOwtv7H+0weqxjPbMTFrzLXHmDmmu2tbI8uSJRvb9OQnKNhrZv1/VmauXyNMEl9W1DuqlZco8mzNuURCzGpJ9RW0vuWFpyWiyQOEJE2ytY3FM+lI17QW9f53cJL/EYyLRfDPFT1ElxWK+rX5YnO7bLUQw9Prh2xAUBJwv+X29/pI4ucYfdCm22THM33FLxZaYpCzLfoPecs6Ykpe0xAi76t/YyIVKqfjNfYwZbO82U6A4lajI/VyKIRGcbv8SoApqZaCOWgP0s4QAnIyCwkeQHnnm
 haGOYtjR
 Ut0BPkeeU5lAMNcDpwT13UIK/aSkYR+3niYc6z2aOEkr4Zj24uocfHWRRO4qSWtBe8bQpSpy/eIyu9EO+rXoT1F8CKtmEUw/c6PYiGsdAdiX7sJhYzM9YYAxg4eGvri7A3GNpY/I/GO6owZjHGirrDiiGhqyqQJaKRiSMqgOoTpY6Kp6s10Pf7MglMLYP2aKufQ9mIMJjPgIgLyJ82cPbyCQD2T0WBRkBgu7h3I2WC9kgiluZurFkcrFK7o5JWM4Djiet9pelJxEAxPai/6KnCF4rMOD9h/iGhuZ53upzVgoHC/k5ViMJMQ1cdCNdmCOh+ZsN6NgyTMit5R2+A8uj3+bfpZR6a/TE0d4vPbFdGtuv5N78reMj3W5vbDfTqxR8FIa1l5G4GHKbCOBGuAmN4vyf2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/25 22:38, Andrew Morton wrote:
> On Tue, 29 Jul 2025 08:46:33 +0200 Hannes Reinecke <hare@kernel.org> wrote:
> 
>> we have some udev rules trying to read the sysfs attribute 'valid_zones' during
>> an memory 'add' event, causing a crash in zone_for_pfn_range(). Debugging found
>> that mem->nid was set to NUMA_NO_NODE, which crashed in NODE_DATA(nid).
>> Further analysis revealed that we're running into a race with udev event
>> processing: add_memory_resource() has this function calls:
>>
>> 1) __try_online_node()
>> 2) arch_add_memory()
>> 3) create_memory_block_devices()
>>    -> calls device_register() -> memory 'add' event
>> 4) node_set_online()/__register_one_node()
>>    -> calls device_register() -> node 'add' event
>> 5) register_memory_blocks_under_node()
>>    -> sets mem->nid
>>
>> Which, to the uninitated, is ... weird ...
>>
>> Why do we try to online the node in 1), but only register
>> the node in 4) _after_ we have created the memory blocks in 3) ?
>> And why do we set the 'nid' value in 5), when the uevent
>> (which might need to see the correct 'nid' value) is sent out
>> in 3) ?
>> There must be a reason, I'm sure ...
>>
>> So here's a small patchset to fixup uevent ordering.
> 
> You know what I'm going to say :)
> 
> Should we backport this into earlier kernels?  Seeing "crash" make me
> think yes.
> 
> But only one patch has a Fixes: target, and it's with the Fixes: tag
> that we tell -stable maintainers which kernel version(s) we want
> patched.
> 
> So, still assuming "yes": is it possible to redo all this as a simple
> minimal patch which is suitable for backporting?  And then a separate
> cleanup/refactoring series for future kernels?  [3/3] doesn't seem to
> be needed in earlier kernels?
> 
> IOW, if we wish to fix this crash in earlier kernels, I really cant use
> this series as presented.  For now I'll add it to mm-new to get it a bit
> of exposure while we decide what to do.
> 
> 
And here's me who thought we were doing upstream work precisely to
_not_ having to do backports :-)
Oh well.

I see if we can roll patch 1&2 into one; guess I'll need to do it
anyway for our kernel.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

