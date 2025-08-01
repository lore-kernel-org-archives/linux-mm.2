Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698CEC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 12:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4676B007B; Fri,  1 Aug 2025 08:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0954C6B0088; Fri,  1 Aug 2025 08:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F2D6B0092; Fri,  1 Aug 2025 08:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D88116B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:57:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A85821DCA71
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:57:12 +0000 (UTC)
X-FDA: 83728189104.10.5276DA8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 50DDA40002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:57:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="l6Fil9/c";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8tYGTVVJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="l6Fil9/c";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8tYGTVVJ;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754053030; a=rsa-sha256;
	cv=none;
	b=qbBUo84HJ7CWSp8hv9yN0Ns2rB7/KlJcjoWvNZWAGQuVTqWeqTlM+9kFxeWDiQVF+nOs8Y
	3XiXErcIoqD/egLC+haue/dpsWNCmkOe72I4GRtH0vL8yzprndhBQhpQe0N4eB1HEEKnNZ
	qncTmLU6SIeGcAuZvATRjoujHyDJCmA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="l6Fil9/c";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8tYGTVVJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="l6Fil9/c";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8tYGTVVJ;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754053030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+he1+kKKz0LSF03sq2WnJU/BlUAAvBXA99h2cauoms=;
	b=J+PFg83F2MP8Yy27vpgNAX/0FT5T/9YimJljTKgwlPRlQ1HyxCIHuhZaLOY0vn8esQlJvX
	Z8xdD0hM7j9h0lUwbgT7qNjfzhMAz2km8qkaA4eoRXbS0xT54XiqEU9pua47UQunCvBMEP
	TNo8KkwrtRh/q8z8PIQ6AWGULkpTeEU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A2A691F7ED;
	Fri,  1 Aug 2025 12:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754053028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e+he1+kKKz0LSF03sq2WnJU/BlUAAvBXA99h2cauoms=;
	b=l6Fil9/cfa3HAzy9Tx+CAe2iI2+rzq2l+0oFEu5702nfbxmQtieUrXcFe2HKzkmGf8YAHj
	wbddiJvcORR1FmkABEE5DG7KdRzJjwht5fvd5xQimZ4xNHHhIFQ02ktTkzbh8AulM1cY/X
	9SJLbsIgXbL9SjngUCgGdKTDJgmvkMA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754053028;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e+he1+kKKz0LSF03sq2WnJU/BlUAAvBXA99h2cauoms=;
	b=8tYGTVVJQcEmnE9I9h+raiZy5/IcgpXbhI1n72DRiOcASnlkPGW1Om8w7KSxxPrAk3LUhb
	ss5TfJBA8tbBGhDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754053028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e+he1+kKKz0LSF03sq2WnJU/BlUAAvBXA99h2cauoms=;
	b=l6Fil9/cfa3HAzy9Tx+CAe2iI2+rzq2l+0oFEu5702nfbxmQtieUrXcFe2HKzkmGf8YAHj
	wbddiJvcORR1FmkABEE5DG7KdRzJjwht5fvd5xQimZ4xNHHhIFQ02ktTkzbh8AulM1cY/X
	9SJLbsIgXbL9SjngUCgGdKTDJgmvkMA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754053028;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e+he1+kKKz0LSF03sq2WnJU/BlUAAvBXA99h2cauoms=;
	b=8tYGTVVJQcEmnE9I9h+raiZy5/IcgpXbhI1n72DRiOcASnlkPGW1Om8w7KSxxPrAk3LUhb
	ss5TfJBA8tbBGhDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9164713876;
	Fri,  1 Aug 2025 12:57:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IXO0IaS5jGiKfQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 12:57:08 +0000
Message-ID: <c48f2877-4d37-4310-995e-fc5c2ae9a366@suse.cz>
Date: Fri, 1 Aug 2025 14:57:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Realtime threads delayed due to kcompactd0
Content-Language: en-US
To: Alexander Krabler <Alexander.Krabler@kuka.com>,
 Mike Galbraith <efault@gmx.de>, Frank van der Linden <fvdl@google.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Dennis Schimmel <Dennis.Schimmel@kuka.com>,
 Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
References: <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
 <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
 <DU0PR01MB103857873A56FD121984568148226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
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
In-Reply-To: <DU0PR01MB103857873A56FD121984568148226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 50DDA40002
X-Stat-Signature: 3gfr9yetfk99cfrqowesof7fog93dmpy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754053030-804488
X-HE-Meta: U2FsdGVkX19u6WzZZucWN9WEnSL9GnJa48dz7p/ndQw1SiXPC5rVhdd49Teu1N5FilC+l6TP3UhgtIKvSg+X167i+v3m/ZIhig2aBHoN95UPdrIOrYwiG/N0HkCkBI5MmTwrrb6xxw4yeHn3+dyTr6T0SRhaPvmrTtWJSp9hZTm99XjFW27xXb+v0rh0VhQlG0reMvSH6Clr0Xg8QBKPrFOqp8iDVcV9R7X6scWpdlXE2lxkEh04gToIpsawJ9Ur/X3/b0t1ndDtq/C3Pl8RgHtiOWIkp5j6XaRbpPF6VDSMVavtGLW9vJLo69ZKPqnYEofINEStzsefhvL/SZMmxCHipi8LBc60z8fJMdcWJ2BxKLzRU1jRh7LqAOm4DObDf3orqT0UWiUQvf3cVqLnrmhaNh/QHSDmhs6F0hINS8r0rjhfoIg+nLiEkcSmpR5IF58M/cWXSmJHkiZukn/rMQspKJD0seFctjZIE+1SDoNg6R3E9TWt52GGwAB8OD6C7XB1UGuhWj6vd9WKm9MijCHzl/RdbU4i9AI5ZW5/HT80QsCeS0GHv2nsxggCsMuPkqclVf2ZfKqniyhJuJUv++OsBULAce2zkMFpaEWlbXVyqS2XhUoCPQaVQGCLJD77y+uimmu1I7ds+TdW7g0lLoSMsLEG5BCOAVFEWIj59ft/5Kygp6kDOx3hIghu1N1zYYrAHUJHlC0yxHUhKZx/QzPg/DGuK3ZEZMe+rO8IGmPYKN+Vh6wbB+URP3m5y+ZpNdRAtAi42JZV5TAQYfBLWamV4KABMNiTb93BPKim/ppBArOBrRFzC49AQn6FO0D4/YPneWi92tBUnnMwnLqjqpxRY77dRghd3zVNgpeWeN6oK2oB/PwqVSQyyS9bWfr2c+tpA3MMZV7lVNS99KpngFCraIOnDx9liIqETzas8kciF0NPnHfn6g/XrlkS1IG+B+eQfiNsnhUr33E+6MD
 KOoeV3nu
 bdfAHIIH1EGjEpHNhub+Z1X+jcTKoxX2jgIPqpc53UHrarinvurpOg/zT5p0gDo/ecvzMYHETfbo7rTp/VeEFhM84XRcx4PyzGd/S6y9WRgv2vrQhKSzLd8FQjjJ0vIlhqm5hLApw7+oLAPbRD0gVEVbugymAUe5WsI6N6hOuE32urbcI0iL5MhAlJ1NL88r4E4/t7jeuQtxj8tdZlzcSYktFiOIzu7TkQyfd4Ds8iUolJOgSNvbKw4N8daiwOXdtIeUr8TF2vVBRagTuzDBPNaRKA4rpMhj19v7hLHyKBnkRLAx1/WEBT4N77jM42PfYPg8EO8o8N4gTJ5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 13:23, Alexander Krabler wrote:
> On 7/31/25 20:35, Frank van der Linden wrote:
>> Not sure what the right thing to do would be. Either explicitly boost
>> the priority of a thread temporarily during migrate_pages_batch, or
>> mitigate the issue by dealing with 'busy' pages more quickly in
>> migrate_pages_batch.
>>
>> - Frank
> 
> I think it would help if priority inheritance would kick in as soon as
> another thread is waiting due to the migration PTE.
> 
> 
> On 8/1/25 11:58, Vlastimil Babka wrote:
>> On 8/1/25 04:46, Mike Galbraith wrote:
>> > On Thu, 2025-07-31 at 20:41 +0200, Vlastimil Babka wrote:
>> >> On 7/31/25 20:34, Frank van der Linden wrote:
>> >> > Not sure what the right thing to do would be. Either explicitly boost
>> >> > the priority of a thread temporarily during migrate_pages_batch, or
>> >> > mitigate the issue by dealing with 'busy' pages more quickly in
>> >> > migrate_pages_batch.
>> >>
>> >> There's a workaround for realtime tasks. If you mlock[all]() their memory,
>> >> setting sysctl vm.compact_unevictable_allowed to 0 should exclude these
>> >> pages from migration by compaction.
>> >
>> > Hm, per documentation that's done automatically for PREEMPT_RT...
>>
>> Oh I see.
> 
> Yes, vm.compact_unevictable_allowed is set to 0 in our setup
> (default as we have CONFIG_PREEMPT_RT).
> 
>> > On CONFIG_PREEMPT_RT the default value is 0 in order to avoid a page fault, due
>> > to compaction, which would block the task from becoming active until the fault
>> > is resolved.
>>
>> So it's probably the mlock() part missing since that should otherwise apply
>> to kcompactd.
> 
> We use mlockall() and I verified the pages have the lo flag set.
> Which means, that we have exactly the issue this sysctl flag should prevent us from.

Hm that means something isn't working as intended. Do the pages have also
the unevictable flag?
>>
>> > ...but rummaging, seems other stuff can step on it (contiguous alloc?).
>>
>> Yeah, there was time CMA was just something for mobile phone hardware. As
>> usage increases beyond that maybe we'll have to tackle it. Ideally by not
>> having mlock'd pages in CMA areas at all. And if contiguous alloc is
>> attempted outside of CMA areas, respect the sysctl there too.
> 
> Yeah, we already thought CMA might somehow influcence our issue.
> We have 256 MiB of CMA, which our hardware probably uses.

If the problem is kcompactd, it should not be CMA related.
> Is there a way to tell a process to not allocate pages inside CMA area?

I think not at the moment.


