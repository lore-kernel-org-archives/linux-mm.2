Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A5E8D148A3
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 07:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50AD36B0005; Thu,  8 Jan 2026 02:31:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E726B0088; Thu,  8 Jan 2026 02:31:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F656B0093; Thu,  8 Jan 2026 02:31:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2634E6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:31:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6F791603A3
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:31:22 +0000 (UTC)
X-FDA: 84307976004.17.60BCB09
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 82184100011
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:31:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aG1hwWgk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SUxHWWwd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aG1hwWgk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SUxHWWwd;
	spf=pass (imf14.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767857479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWL6JyaCk8ySJrUMJVEuBTQ9IddRkD6tfWdzwFJQ0C0=;
	b=J0LV9/V71+HFWjxiIgyWIg1wBoZXaq35mRzvARfw4R38KsdaDO+SnFFt+7if3sk1zpkVlY
	7H61K6phOgTWqlGVL1jePTBbdFMPkcRgApzLU+tlfg8HaNaRWWuMMfXtnJx7TURMRegC/o
	jMPDHdHuCsWxsnCxyG8+NpXtip7rJWc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aG1hwWgk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SUxHWWwd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aG1hwWgk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SUxHWWwd;
	spf=pass (imf14.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767857479; a=rsa-sha256;
	cv=none;
	b=M6zKN2+OIe+p4Vu3hWkVlu88r9JiVSiNWPiTLhr80vIiwKNxczjpvXOYBV7Gt3bVb328ng
	7ajdu8xM8uUYyn+Odw4msMVUoigrDpV0PXhCtloZ8E2hm2S44f+xZHM8CxToCg6QJuGvIm
	Cb9sxlW2WLzstaqtcRBPyqjZU+X7fsc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D48733379E;
	Thu,  8 Jan 2026 07:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767857477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vWL6JyaCk8ySJrUMJVEuBTQ9IddRkD6tfWdzwFJQ0C0=;
	b=aG1hwWgk1fqb8Fz8V1d9uQGqJuCZemXKEySSlJbIGsERbUYjp0R1KbsJa4SPy9WbvKl+RI
	/6nyvI9HR/4uIFWE/akhM4IBYJtm0MEzqtWsDZ/nEoXDHuOz04z+PzU0VtOgmAxEJuulDc
	uKsw0ydVAfexGRCOnK72mxZtAM8Bci8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767857477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vWL6JyaCk8ySJrUMJVEuBTQ9IddRkD6tfWdzwFJQ0C0=;
	b=SUxHWWwd81XOdH8wjDreTVSH6K687PLkg2U6WzWa3N/Q6jj96c9dPLcvImVuEZ0lI0HSX1
	18vdfgSgCYquHdDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767857477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vWL6JyaCk8ySJrUMJVEuBTQ9IddRkD6tfWdzwFJQ0C0=;
	b=aG1hwWgk1fqb8Fz8V1d9uQGqJuCZemXKEySSlJbIGsERbUYjp0R1KbsJa4SPy9WbvKl+RI
	/6nyvI9HR/4uIFWE/akhM4IBYJtm0MEzqtWsDZ/nEoXDHuOz04z+PzU0VtOgmAxEJuulDc
	uKsw0ydVAfexGRCOnK72mxZtAM8Bci8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767857477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vWL6JyaCk8ySJrUMJVEuBTQ9IddRkD6tfWdzwFJQ0C0=;
	b=SUxHWWwd81XOdH8wjDreTVSH6K687PLkg2U6WzWa3N/Q6jj96c9dPLcvImVuEZ0lI0HSX1
	18vdfgSgCYquHdDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 605753EA63;
	Thu,  8 Jan 2026 07:31:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vB27FUVdX2k2KQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 08 Jan 2026 07:31:17 +0000
Message-ID: <20baab84-c8b0-4c46-a550-21b26b975d07@suse.de>
Date: Thu, 8 Jan 2026 08:31:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Gregory Price <gourry@gourry.net>
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
 <616f97b7-24e0-4134-a08d-5abaf07a8b09@kernel.org>
 <aV1pmeXP2pZ55g5i@gourry-fedora-PF4VCD3F>
 <fd21ebf7-d016-4729-8d23-a7c0f2a3d8c6@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <fd21ebf7-d016-4729-8d23-a7c0f2a3d8c6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Stat-Signature: q45nerhp5ygjdbp4c9p6uneudooedd16
X-Rspam-User: 
X-Rspamd-Queue-Id: 82184100011
X-HE-Tag: 1767857479-846236
X-HE-Meta: U2FsdGVkX19dhWa1HUBA/1Z16FvqCd6PzC7Bxho+UAMhxAjIhqyhfwwNoDNNqPq0heDY046FFLYEga2iPcRVutKCQ0rizSRBwSKQ1ZtjRiJ18h7uE1L9TwL3j8vtQdkWKpOB+QGJmtIB6SQ7HY6WPWLmt4q7yYAZTpGZMX8cIl8l5yAKX6Uk5LYaJAlWZMH1MLD0f+h5bsu3TFhbKcb1xbGqi7hENCzxZxnh5zFrFLsazXbrE3RUM4EKXyG6WHYdnvS6bdfqNMdf1H3vHDp9C29cTI3m0z5X5B4vJ1Cg/mcdmkDXaICfMM3zobGqMjpMvOHMPS8I5VeL2U7ewNWok49bT82h3fAK0WOc5jXrBwlnD72rrUGTTLam5yyUfo7AQ4qxaBwA2nAyZ057gLdQ74RfmyGftW4c38gajcke/kM870WuckhhkVon34CKe5fMMoyWHKQAmfsq27GPmJE3m26di9DUvZZD6+BQakdyCRtaHz969I3rC7A4R5Se5b2qH4KwLoJ7iZLnyT0ZpPFFWgUI72nPtyelCY1ixSwF3obcatzHiDKAbE35IGuQLVN5wpOU+ZnBdU9QAm+v5zAR+h2b9e7IxqANy4DKYphz+xHNnJKvRZJy20qeao5NEHw+MzVVtup+OyBiXRuJezjUVFgAfsQ6cscbwpI86fh/rhimbHdDwrhGCBN7EWNCaoRIlQ0F6dNxh88ORg6rdySVJNSvl72lQ1ZvEZP9cAjcazZkzuqoPdEXJpp4y9aaSZZkSWZcaVxw54Yh5N8/zBb9tguE/1uFHXhQQHw25tMnTlzZvyz8MD+xu0dLEnIUQKphW/QRny+JO84T/oHuGdBUHRqXQRqWbGu+I01duWRlT89dIFC5VKD7s6x4oz+Hjfzxf/8MKUQSECVrc9xD2jH5Peess5qOl8VrKNbYDDYyWJhIQZnGAB0LzukUOaEINxqFwdWJBE528RUcXuPsif9
 jVhjn++M
 Stnkbf1FHTWPtiGOtvY+7b0Nt5KFyshih7kOuG943EFRUfv3wJsJskX1oQBHPDIuAq980cO+PWwnlNAwp62e1HNOkcFh8S4tSZYL1u7pYYBHA0wx+3WTK3dTnNNx4HYHu/JCKjmOaitnyBtoHKsdKlpinZtcPMqR+DWUrjJia5MBYPgZRYEjqXy45GNr/RNDVgzQyLsLEN43lFLpHCpibNojA6Ep2pcJ16qOVMaLCoD3pRehwrZhZIfhUg7HKZAGmQEnhlwKAYdDmcakEflkzUKVn4xWuAPa14ewvRF8jIcAPLIHnPx4XQJxzqn0tl6Lbznfji+B2sytnTrrAOiR5quP1kKmDBM9GjdR2nyWctMZaEvxl6SpsuxuNHuomIXCBiTtP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 21:22, David Hildenbrand (Red Hat) wrote:
> On 1/6/26 20:59, Gregory Price wrote:
>> On Tue, Jan 06, 2026 at 07:38:54PM +0100, David Hildenbrand (Red Hat) 
>> wrote:
>>> On 1/6/26 19:06, Gregory Price wrote:
>>>> On Tue, Jan 06, 2026 at 06:52:11PM +0100, David Hildenbrand (Red 
>>>> Hat) wrote:
>>>>> On 1/6/26 17:58, Gregory Price wrote:
>>>>
>>>> Fair, I'll revist this once Hannes gets a chance to chime in.
>>>>
>>>> This was effective at getting the discussion started though :P
>>>
>>> Hehe, yes.
>>>
>>> Another thing to look into would be to provide a way for ndctl to just
>>> add+online the memory in one shot, without having to go back to walking
>>> memory blocks to online them etc.
>>>
>>
>> I think it's the opposite: offline+remove needing to be done in one step
>> while holding the hotplug lock.  Right now, I think you have to do
>> something like
> 
> That's what I note below, yes.
> 
> For the udev vs. ndctl race to be handled in a
> good way you need add+online be done in one operation.
> 
>>
>> daxctl offline-memory ...
>> daxctl destroy ...
>>
>> You can't destroy and have it offline the memory for you in one go IIRC.
> 
> As noted below, we have offline_and_remove_memory().
> 
> I added the comment:
> 
> /*
>   * Try to offline and remove memory. Might take a long time to finish 
> in case
>   * memory is still in use. Primarily useful for memory devices that 
> logically
>   * unplugged all memory (so it's no longer in use) and want to offline 
> + remove
>   * that memory.
>   */
> 
> Nothing speaks against letting dax use that, but the tricky part is that
> offlining might take forever, so one has to be prepared to handle that
> (and letting user space cancel the operation).
> 
> And for dax devices that consist of multiple ranges, it can be "fun" having
> some regions removed and others not.
> 
> Something to think about :)
> 
We had this discussion at LPC. The current interface of having to 
individually offline every single memory block is not very 
user-friendly. While it provides the best possible granularity, it
really only makes sense for virtual environments where you _can_
hotplug individual blocks.
For hardware-based scenarios memory will always be removed in
larger entities (eg the CXL device), and it's always an 'all-or-nothing'
scenario; you cannot remove individual memory blocks on a CXL device.
So there the memory block abstraction makes less sense, and it
would be good to have a single 'knob' to remove the entire CXL
device and all memory blocks on it.
Sure, it might take some time, but one doesn't need to worry about
restoring the original state if the operation on one block fails.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

