Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B538CCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1946B00A6; Thu, 18 Jun 2026 04:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9126B00A8; Thu, 18 Jun 2026 04:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F686B00A9; Thu, 18 Jun 2026 04:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 515956B00A6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:23:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A06D812068F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:05:06 +0000 (UTC)
X-FDA: 84892297812.24.2614197
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CC4C914000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:05:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S69TZUJ2;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781769904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YqDSQnwQZ5jAJB3+SwA3fEKLb3ZSgJjnQVSZUsmR2k=;
	b=avHLImsiMJlxXWMKsCxBKoSX0XZIMb30eq2YUCaFLKCcEdMCVB6qPhfnixU/yXo9BboPxW
	vEsfpFZNtZnlecUsUL5CxYlfGf+HyKT5AmTMo/cXEeQwoO/loa4izYPRSpj/eTN1Ce2fP9
	XEiB01jJpc9OKArb4pWZv0SJzk3LiuQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781769904;
	b=WGmwcyhSVjMAYJuX9qzbFJuckTlsJbxnx/Em+XaAil0+woHP/Tgq9Rg+qXO2hBpNeO0EJq
	ScQiBjfMswBlGDaquwNaxpd5tgoTDSXJk2fZ+6LP/48omJKwjEkCftzSBCBIJpwL2pJSQW
	6V64fNulNGDwmfhUR1I+Ld5LiscExg0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S69TZUJ2;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9187943458;
	Thu, 18 Jun 2026 08:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C391F000E9;
	Thu, 18 Jun 2026 08:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781769903;
	bh=6YqDSQnwQZ5jAJB3+SwA3fEKLb3ZSgJjnQVSZUsmR2k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S69TZUJ2PfIhtzsTptZxj+G0cxSmrbG5Bevxw8t8/9uFuuW7bZJjhSMD251s/9TkJ
	 J7aeCpLCsQ/iEpQPMbDWS0KM3gaNsSoNM5rgdFxSPSYengSnQAneBwc5wpKbE4xvN4
	 HyvQvQeF1cnRFpdzcpkYaQn9hhx80e4pInshFNSAPEbLh+W8dKouzbZpn2/FTSA+w7
	 EejfDKmwpJYCOztPf3nFVzzsmCPail15hicm/7GxzFDf1RuDkjxH/G4R4QaC2/diWe
	 8fdvG8nAXaEeILt4e4xwVGDxGGIoGSOKvllpBP+9M4pgcfU0drzh6LjDJi+5tzpsUw
	 obJYhTp6SXKAw==
Message-ID: <fd4e11e9-21a8-445d-88a0-041123bb1ce3@kernel.org>
Date: Thu, 18 Jun 2026 10:05:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove mentions of PageWriteback
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20260526195650.353196-1-willy@infradead.org>
 <849ad1f8-973f-4742-b56b-7d31570d93fc@kernel.org>
 <ajKj71cXOZMf6mK9@casper.infradead.org>
 <53111e55-0e9d-45f1-b19e-554b0b17e746@kernel.org>
 <20260617-nyala-of-noble-refinement-ac7df7@meerkat>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260617-nyala-of-noble-refinement-ac7df7@meerkat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CC4C914000B
X-Rspam-User: 
X-Stat-Signature: tmy8se38seqjr1bp984657sn9qudsr3f
X-Rspamd-Server: rspam08
X-HE-Tag: 1781769904-167427
X-HE-Meta: U2FsdGVkX1+fCYgPY7ExbhnTWWOIC60DT8LmZBrG3QuaZX1tm6ZhfEa7UbYTMCT02SpFJzsiw149/Et6MUqFLfwfKH4d3/zRxHuxrA00SqHSlFnAVW+DYDIlTLIDM9vpas2smWCh1e20bXwFZdqbXKTsn0k9jSSAtkZn3qqYSbtn3zc5J1p+TnJ/aXFgxOTfyHiOUM/e1GX6kwwHS2MSDkd8pvKFaHMGZz5jMcpN5BwHk7wSEJOKN6OKw9zZOhH02RWrfT/9T7HP9aezdeEDbQuJRwx8i47LObc5vwziuC7DBKnzFK56wa1P2M4Jr9nJnA0TtUbbNuHL4tsibx8NhdJL2RpcnhNtppt/Vo+DyNuZECyAYiGGDnkhmSg4+/YTizbGKDblz7lF6OTEs2kJYP+6P2SE7ydjChmLwsHNxPkW8c0p4f5PlLB/9xad6o7C0mWUY8yTFl1qSoO6Rd1mIF9LDneoRciSC3eWuF2TO/2OoUUBNVhiqTkonmmkDWPVIm/oMppa3/5jPN9HpW/Dt5xmanEKFPUZRIiQlEMEUv1pg9EnPiPhkBDI3gXRFWTbqfqghSTcYDH6KNevUCf5HESw4fiFBtTx6NAKc08pQGtpYXiqiWFExyGDIMTEDcCliPcWjg7dfsVjuPwuUdHGpmfBD96f8g2JdX/Je3LhVQYWLUXtrFUYgDNlWb9hT4+qfcxCWJxIWAeL+u0HZIXfGp4oWjLrFXumYDW/5an9VeaQpdqWw1z2MIilNGTAw6cE1MIaSteytr5KWvd9pPxKHU074+CA0QUhxfzPSlPfPVgiGowH/k+XqWpPWL0LI+pxA9tUnXzSHL9MMPuPAhXIlv6TuOJpYNciEFzX7jPttTRKBrx7oeKg+w70ja1SCJ++YrRTl9agEjQjxleySGJgdws5s7Nbv1iJwTDO9Ldu7+W6K/sSGsS46161zee8hFQBWkORgCR0uy1OzgATlqv
 +pOh84Yy
 XukkhyId0CjEjOfYIAde1vHONvXEtWTcjk2jCL7eTYRtvoru9rhpER59ja0ela161QcnWm6Qf0UnajkupTS4C0AEFkMTCzEs7EUVeRlvDjIzdUFo0DvcMtj73uL+SM5b4s1CGsLFn5fp6n3pJuygcelVS9XIVdHvZnbwVdCN8UQUY5/pC8Vz9C47caCoocyv0y7ZzYpDIHIBqkPFZm9akaFK3RPBAN1Js9ScFgx2eZ+FBsG3HadjAXJMeusllSMjPHqlf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 23:12, Konstantin Ryabitsev wrote:
> On Wed, Jun 17, 2026 at 04:17:51PM +0200, David Hildenbrand (Arm) wrote:
>>> pain to copy-and-paste from.  Particularly when it wants me to cc Ted Ts'o
>>> (shell quoting rules are bothersome).
>>
>> b4 does a pretty good job for me with "b4 prep --auto-to-cc". I barely ever
>> have to remove people (rather add some people I want to CC explicitly).
>>
>> It manages the CC list within the kernel tree (in the cover-letter commit),
>> and respects CCs on individual commits.
>>
>> "b4 send" would send them out, but ...
>>
>>>
>>> There's git send-email --cc-cmd, but that doesn't work for my workflow
>>> where I generate the patches on machine A then scp them to machine
>>> B where I run git send-email, but don't have a current kernel tree.
>>> git format-patch doesn't have a --cc-cmd option.
>>
>> ... for your workflow that doesn't work.
> 
> Since b4 works on special "prep" branches, you can simplify your workflow to
> make it work. Get the branch how you like it on machineA, then pull it on
> machineB over ssh, and then run "b4 send".

I think Willy was avoiding having a git tree on the other machine.

I assume it's not sufficient to just PULL on machineB where you send it, after
sending you also have to mirror back to machineA (PULL from machine A) so it
would see the automatic reroll, right?

> 
>> There is "b4 send -o tmp-mail/" that doesn't send the mail but stores them in a director.
>>
>> I just tried with one of my b4 series:
>>
>> $ b4 send --no-sign -o tmp-mail/
>>
>> Which gives me:
>>
>> $ ls tmp-mail/
>> 0000-mm-remove-config_have_bootmem_info_node-part-1.eml
>> 0001-sparc-mm-remove-register_page_bootmem_info.eml
>> 0002-mm-bootmem_info-drop-initialization-of-page-lru.eml
>> 0003-mm-bootmem_info-stop-using-pg_private.eml
>> 0004-mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.eml
>> 0005-mm-bootmem_info-stop-marking-the-pgdat-as-node_info.eml
>> 0006-mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.eml
>> 0007-s390-mm-use-free_reserved_page-in-vmem_free_pages.eml
>> 0008-powerpc-mm-remove-config_have_bootmem_info_node.eml
>>
>> Which should contain all information, even including Message-Id:, In-Reply-To:  and everything.
>>
>> I guess you could just SCP that to the other machine and send it from there.
>>
>>
>> What "b4 send --no-sign -o tmp-mail/" doesn't do is update the version information + create
>> tags etc (like b4 send would ordinarily do). "-o" currently implies "--dry-run".
>>
>> That makes it a bit harder to use, because one has to manually, after sending, use
>> "b4 --manual-reroll COVER_MSGID".
>>
>> I guess we could extend b4 to just do the reroll even though the patches
>> were not sent yet (to not imply a --dry-run). CCing Konstantin.
> 
> I think running manual-reroll is a better approach here, otherwise this would
> be a significant reversal in how "-o" currently operates and can catch others
> by surprise.

Right, the behavior would have to be adjusted by specifying another flag.


-- 
Cheers,

David

