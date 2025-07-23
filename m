Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A35EC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 18:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200CF6B0104; Wed, 23 Jul 2025 14:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8B68E0002; Wed, 23 Jul 2025 14:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C76A6B0107; Wed, 23 Jul 2025 14:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F11396B0104
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:11:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81FF610F021
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:11:02 +0000 (UTC)
X-FDA: 83696320764.15.EE987F4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0E7334000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:10:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=teFkzH7U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0CE1zvU2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=teFkzH7U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0CE1zvU2;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753294260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aW2XOLqRffOO7syF8Mg61Wu13tf9WPN3VPXPxE2jrc0=;
	b=En7K1T4KqsvEIhiPJdMQZPddSzCIhCmQCkxn7RXR9Tjp41IkrSfk6TcOFppCAjSw/xwGHb
	iX1FSME2aeJB5ShhSG6t1TaRlOVNNudVd2aBLV2N+dPIQ5FPCdNfR/kBz+LWJkQr2yFJYk
	oXW10Em1oNe9oWnxeQsiA0Y6umZz5as=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=teFkzH7U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0CE1zvU2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=teFkzH7U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0CE1zvU2;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753294260; a=rsa-sha256;
	cv=none;
	b=kSHuIGN//DGXKqSBYyQ10UxiYbIal4IS3slTbRtssvTkzu15NoJlHceMKfRoIzDEXXYXUm
	FxkjzH+g59+gIBlOlftA4efJQ8FaP7BBYoPNmUYZE8eWn4cSPP9uQ0ppiRH3FyQccNFBFB
	LIm4Mkh2hshVJ1Akp31Vb+0UoOr8wsE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8645621753;
	Wed, 23 Jul 2025 18:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753294258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aW2XOLqRffOO7syF8Mg61Wu13tf9WPN3VPXPxE2jrc0=;
	b=teFkzH7UCP+g2UHDAOLapT4BSq3/nDDXUwZacEmQjatHjGhj/xtzESOVKdk6nqt9+ufwLY
	RkBYsQJT9oWJ1Ag8B2Nm6WXTnndkoMHJQK3iAqqzQe/65kKKyTcrINGuk3Cd0oy+2YvdnX
	rgPmvhR1cggWT3XxHMVaSz0/gMAvPHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753294258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aW2XOLqRffOO7syF8Mg61Wu13tf9WPN3VPXPxE2jrc0=;
	b=0CE1zvU2nI+k+WVbGSUPlw53L8RdHUMLA2GNMOWR+/QexiUm1mcUfF3h8fj0bG+xMpaUxB
	Gm2wUo8/0GZ3DfAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753294258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aW2XOLqRffOO7syF8Mg61Wu13tf9WPN3VPXPxE2jrc0=;
	b=teFkzH7UCP+g2UHDAOLapT4BSq3/nDDXUwZacEmQjatHjGhj/xtzESOVKdk6nqt9+ufwLY
	RkBYsQJT9oWJ1Ag8B2Nm6WXTnndkoMHJQK3iAqqzQe/65kKKyTcrINGuk3Cd0oy+2YvdnX
	rgPmvhR1cggWT3XxHMVaSz0/gMAvPHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753294258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aW2XOLqRffOO7syF8Mg61Wu13tf9WPN3VPXPxE2jrc0=;
	b=0CE1zvU2nI+k+WVbGSUPlw53L8RdHUMLA2GNMOWR+/QexiUm1mcUfF3h8fj0bG+xMpaUxB
	Gm2wUo8/0GZ3DfAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D65C13ABE;
	Wed, 23 Jul 2025 18:10:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w/PqGbIlgWgBcQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 18:10:58 +0000
Message-ID: <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz>
Date: Wed, 23 Jul 2025 20:10:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
Content-Language: en-US
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz>
 <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: btoxe4gjkt7bxr4jb6gz6crwzw6cz9jq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E7334000F
X-Rspam-User: 
X-HE-Tag: 1753294259-756875
X-HE-Meta: U2FsdGVkX19RCHUprgpBJtSEhmTyv7yCQ6bzBMZH/BDdGPL5FVeEd5hUJVzSm3Y8CrFM82sUBZzb8rxvlSQtENIkcfbNOBlw7/ICqe5jTbveriJ534W2rK0cpb6c1x1DQvqSQilZl+uKFrxTa6sb8FOfz+R8RdMqkg+FWD8cQqZsRv2fJauP8DvPRorZ91pi8/ZEr+wOq+BFOMIWWpxKEH5zLvSV5BUyugi7o6gqSMP/kQLn+Vfu/SuDMt6wGmJRq4EGZzqUPIRXM/HfjwPxam8nmuzRdc6ok8ECs0go7jm5Kqbtjtv8RUkVIKNqzd9RMujpI3Z9uaTQnXso8v1cw03nEtF8hg2OhMpZTn7PuT9G6jY5PSSgodDs0S0uRYXa/4Qg7w/v1NW8Aw6je7jPHt4xhfCq840qEpUGCbRRn+6Ypj4ODRZstGiFNLwPG3gaVzGMDb0pMxNmxKmofP7Jy/bPcviLP2lZgFEGJ8tqdEGM5OcvGWcmHZx3Ga95a59MIuQhe2JCMGNt4x/NaxaMohU9q9ZaMYF2PZAJlX4RIbj+WnuzVLKHwwRQcGMkxDqVy7iBmKlTSYQ048FhXjOGACZALabg75VRBqK/XeoEu3ZGtSgEFR4GhvmUDvkZ2Vropkq848CjXTclku3TGPItwfWoCbxeSVAIjSBRf9MX/qe/A5l45V5G3fGKvkeFQ2/MMLPOIK9lyFJ0jdJ5NMfnEz3CZ5gPjGh7ZOMu83jVyFqWpz8NKnyBU8CPT3yV493ueUYFhM+JtpIhGycbU/rQt5VGRKY+lT8+ifU4DvnuMXWwYCLyOTSlvmAtU66Rab9TFFAJV3nJsrvrd1DlDw6z7NmP2TNiAxVHTcuHF8+B/4r5n/LYE8kHyFfzzH6AkhqKpTjp3OB6272bCHwxoN32nvaROE/CPKrIKXdBN7zZrfsIPgNejmUWpHi4f+szFtjLbXiZapQLj6x1CypF+LB
 u5xEChEz
 NPDBlo346uPuWSoDniKIPe2JiM9IeSeUC1QfdQid3z3MfCPQWQGdZVHWoZSaI2bvC137NroATvnpb0GjSVafIvF76QVzr3WL1gFuY2Jzs1snXE9/5KZ9hWqXDGcXoXzm3rgMWH7AdNqcj4B9oLJKu2Me0s4V0QACgopwFQkoT1YflGIiCIdKUe4R5uaUSmK5aBW5rN4W+uBjZ+/GfP4kvZ2B7v2UaYuoCr5GO82jMuTksg2dNn9sLlSw/fYpxfTJcIG0gLX0QjCj7O1t3AfrSdbndt78D96tQ1Jguxeej/om1jkDTIpj8ptB74Rc8RSQghXv0JNoDlsPlQ+aRl/yOtKpB/a7RAiR5f0ne
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/25 19:49, Jann Horn wrote:
> On Wed, Jul 23, 2025 at 7:32 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>> On 7/23/25 18:26, Jann Horn wrote:
>> > There's a racy UAF in `vma_refcount_put()` when called on the
>> > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
>> > without sufficient protection against concurrent object reuse:
>>
>> Oof.
>>
>> > I'm not sure what the right fix is; I guess one approach would be to
>> > have a special version of vma_refcount_put() for cases where the VMA
>> > has been recycled by another MM that grabs an extra reference to the
>> > MM? But then dropping a reference to the MM afterwards might be a bit
>> > annoying and might require something like mmdrop_async()...
>>
>> Would we need mmdrop_async()? Isn't this the case for mmget_not_zero() and
>> mmput_async()?
> 
> Now I'm not sure anymore if either of those approaches would work,
> because they rely on the task that's removing the VMA to wait until we
> do __refcount_dec_and_test() before deleting the MM... but I don't
> think we have any such guarantee...

I think it would be waiting in exit_mmap->vma_mark_detached(), but then
AFAIU you're right and we'd really need to work with mmgrab/mmdrop because
at that point the  mmget_not_zero() would already be failing...

