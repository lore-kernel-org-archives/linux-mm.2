Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85818C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D948A6B0092; Fri,  1 Aug 2025 05:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B786B0093; Fri,  1 Aug 2025 05:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A166B0095; Fri,  1 Aug 2025 05:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B56B56B0092
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:48:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72D63115BEA
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:48:41 +0000 (UTC)
X-FDA: 83727714042.15.3D506B7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03AD720009
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:48:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TT4qrTq6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=74ZmZIke;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TT4qrTq6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=74ZmZIke;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754041719; a=rsa-sha256;
	cv=none;
	b=ZQcZWos+e0foAYPOgcy5HbKX1TyHXcDoP1EE3GCtpHm/ktfYdXfVX8KMS6xnJ6i8Sx3HT+
	FqqvQUFq9JSdAYUHyn7yADwclmLSLePdRRoaiebgnYp870B5mVW+2j9fEha2yg5G7cquUs
	tjezcVp2GOjFjsgzDHSbmrRS9RlToOk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TT4qrTq6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=74ZmZIke;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TT4qrTq6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=74ZmZIke;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754041719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7g/L2embix5szd2bD28Fydi4GWFiZoT0xmCtLeFCBM=;
	b=7sLfdFGH9OJvekfnp55s5VYDV/5mkZvZqofJozx63u9LDPPGkNq6qh90jvzTpcJFfXcGwH
	TIEP6MmtZAYTs4+PZhLBB6DVOXCtb7EBkjR4FFVM5DX1OvnO+XnWvpoAib1B4uqGEV7v/f
	CPuIXs4K4t4bT9PNeFekjRBBuHvWvcQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 771C921BD1;
	Fri,  1 Aug 2025 09:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754041717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m7g/L2embix5szd2bD28Fydi4GWFiZoT0xmCtLeFCBM=;
	b=TT4qrTq6NEatf4MrkKTQNawakgH0GRjmRI+4jSSX9oj0Lad8NfDrxUkvvHluq2urHntCyI
	Rtatba0H/mf9PYbGD9R0RzSd4b/YWhYSr7/8r+PkIWD+YZkGVc7RwmXW3HHixppxYi1yfa
	LPYj3Ila2ogGtit+wXlE0Bzpbt9fSP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754041717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m7g/L2embix5szd2bD28Fydi4GWFiZoT0xmCtLeFCBM=;
	b=74ZmZIkeTPxI1ZNhpfjH/QrHHGflAnGcLEPNuzwpJKP+BLz3QNUh/kyCaUeMoGdwo622i/
	TxwOy05OaY93/zAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754041717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m7g/L2embix5szd2bD28Fydi4GWFiZoT0xmCtLeFCBM=;
	b=TT4qrTq6NEatf4MrkKTQNawakgH0GRjmRI+4jSSX9oj0Lad8NfDrxUkvvHluq2urHntCyI
	Rtatba0H/mf9PYbGD9R0RzSd4b/YWhYSr7/8r+PkIWD+YZkGVc7RwmXW3HHixppxYi1yfa
	LPYj3Ila2ogGtit+wXlE0Bzpbt9fSP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754041717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m7g/L2embix5szd2bD28Fydi4GWFiZoT0xmCtLeFCBM=;
	b=74ZmZIkeTPxI1ZNhpfjH/QrHHGflAnGcLEPNuzwpJKP+BLz3QNUh/kyCaUeMoGdwo622i/
	TxwOy05OaY93/zAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5514E138A5;
	Fri,  1 Aug 2025 09:48:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wKY5EXWNjGixQAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 09:48:37 +0000
Message-ID: <545aca80-1ff6-475e-89b9-55121e844539@suse.cz>
Date: Fri, 1 Aug 2025 11:48:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/testing/vma: Fix function parameter declarations
 for GCC 8.3 compatibility
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 WangYuli <wangyuli@uniontech.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 niecheng1@uniontech.com, guanwentao@uniontech.com,
 Jun Zhan <zhanjun@uniontech.com>, linux-kbuild@vger.kernel.org
References: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
 <e7554f93-03e8-4315-acb7-a55312354485@lucifer.local>
 <CB890ABC56C2FA67+56b95783-ed70-4744-9fc5-f2d93ddf2c12@uniontech.com>
 <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
 <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
 <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>
 <671CE9DD76801AE4+34f3e3b7-4684-4fe2-80a9-93de1dde9c31@uniontech.com>
 <20baf9ac-9328-4110-97f1-91e9e76b8914@suse.cz>
 <27488afa-1d53-43eb-bc68-8e950d804000@lucifer.local>
 <E6DF1F491EEF7B1E+9ce0f7cf-7463-48cd-b80f-1fe0cb1ea70d@uniontech.com>
 <d8143801-0d4c-467d-a181-eb411ea8bb07@lucifer.local>
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
In-Reply-To: <d8143801-0d4c-467d-a181-eb411ea8bb07@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: cwwjn1xo56rza4o53gn6enxs6sim8eye
X-Rspam-User: 
X-Rspamd-Queue-Id: 03AD720009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754041718-797010
X-HE-Meta: U2FsdGVkX18QZLiGar8bwqL3579soMSjO2e3zqWRHKVGynu/sRwKzPhwHIiVlC6s8S7hxR0BsjYNNFmIXU/5gnfwcA6kTrbN5An9EMtz38dK51vFvHvfDYgIjJbkWwc1cYTu9ACzdXP45yW0RbL1i42+v0+V925rzGsLz0C0l8GSrdwVD/6lyTmgj72o0zviJba67qCWZ0OG8G2SS3ugrgMhKkQ82VyPQ3MpvaJi4CxqDKekeaPky2CiMiFRPqaYGqq4HzQLxxHgNCiUx/5topy7UEHNjkowHVYpRgRVyg1iXj0JDn7QZ+fGqD/ERaGGWCI1kYGQFJMQtoDkuZQyuuLmoJekVI/Hg+BTTMvuz4KMuhD74BiwPdX/v7WZsIWoZyEfzkOv0ZbZu2wLx3OZ5rIyj0ZaO8bwbksu1AwfjxKj08dLmkwcbaj2WXHYpCWPek/T/3+FcYoitHDf0BQ2foL8AsJszQfl7IvKjTvPPs7eQJNAzzqUd8isIcrCsdhvZt50ia9CGCAIyEsn8AWmiP2g0gTqKrMcddBBtQJHVN4yRvPJPTtveDw87woNrVAQIqeiGuApZPh5yMkmLaOWYOedLfA6XCsJIUANyeQMlHV45e9MgIbv2IRyoDcLJSdpz+6a84uxC4aQCC3C4Cp5pvGqM8ig32F65w6R1uptuDiXQ3SETGZjJ8hIr4KTB4OPaYeXZPGixG4lX2SAEF+1i+8B+1HUnOJF6mXMwPwBMbK2jBw1DTtIXrd1GxhtmqjXKZpFNBk029BrBEctzKjcojzQAAatfN+Egf3mHZDTVuQxQ242XUceCMibg2MdgCEh1EEcZkPA/vgPtGGegPe1McPSxhvmm0oPGzEWRSNR1s28SGnz0uxqltqEnU+aMBBCNCLgyt0JH1vyi+UZU6oDQf/s/3yuArC0aMDeUXw+N3eyuVz3Gb4Urwhosv7g0+Vb6xrA3o9vxWOn/oqhvi2
 W+fsaz2z
 w/EhMj/EebutGerGu22o4Q+Xt4pux5us4G23FTNTf5FT6gVGCocvLqg+c8kwQgVnqRn0/vrrlRBHD+dm5b3f1wYkkGzak9y+Q/KXAFdEsSq10O74HFTiC6sDzY7ri9IBEPC6S1cGjO2vcmlgaVillfXRUQ6Bf/hyHPe7NMFB7COHdh+cpuLmfaCHXs8DyHP09ailFNWnT5GRjtngjG7oxqExCpSRVYJYKKtUlYa6uvMWb6VK6yjk/pGCseKKFmsdgB+H4mfG5Bke7f+bTikBA+nlKyJu0A8kONiwK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 11:33, Lorenzo Stoakes wrote:
> On Fri, Aug 01, 2025 at 05:26:50PM +0800, WangYuli wrote:
>> Hi Lorenzo,
>>
>> Should I split this into two commits?
>>
>> As Vlastimil Babka suggested, perhaps it would be better to add both the
>> |-std=gnu11| and |-Wno-unused-parameter| flags to
>> |tools/testing/shared/shared.mk|.

I did suggest -std=gnu11, but -Wno-unused-parameter shouldn't be necessary
as there's nothing enabling the warning that we need to override.

> Sure, perhaps 2 patches is best, 1 for changes to shared.mk and 1 for the
> fixups to vma_internal.h.

You could even do 3 patches - separate your original addition of parameters
from the removal of "(void)foo;". Somebody might care enough to backport the
compilation fix alone to older versions.
> Also note Vlasta's reply here, he suggested some other stuff.
> 
> Thanks very much for doing this, you're saving me some work by fixing up
> the silly (void) stuff and I appreciate you fixing this for older gcc! :>)
> 
> I will make sure to review this once submitted.
> 
> Cheers, Lorenzo


