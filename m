Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0610CD65559
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3C06B0005; Wed, 17 Dec 2025 08:19:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637456B0089; Wed, 17 Dec 2025 08:19:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519766B008A; Wed, 17 Dec 2025 08:19:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CEF86B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:19:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7441140AA0
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:19:52 +0000 (UTC)
X-FDA: 84229020624.30.2CC81A6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8AD208000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:19:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="d/r/mqlD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qVuvwgEa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MmUVfCuq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l55emC2w;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765977590; a=rsa-sha256;
	cv=none;
	b=qki1ylkOxe+ISjutht5bXbPIlDZlCcqb00qBuny09+giJ27NBVrjA7iVVrbDHrCjZiCzf+
	z77SGj7pCsOeATjqDjADoof+KPwaMdzS/mYA3NjGuW10zegz2R0JuiwT1A0Gb/r/psj0Sc
	eU9Qyhql/y5Cnj9EU5cE3NVAaLe94BI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="d/r/mqlD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qVuvwgEa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MmUVfCuq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l55emC2w;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765977590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wztWl+3aVrB9ZaSvZauY3Y92cOMYfXSxVG3uQ3w3yp8=;
	b=HccNYFYzfcs0SfDRvg3CbJ08aRZp6+y2TPgbVCcTGxq3aLbnpXsgbPY+LpukffsSz3LK6N
	u3U0LgYIvfAoWLlt1A1NmSj2NlyhTGD4GMzc5rvXcuoKbDAcqYzwaoDAdQlNX2QKRfqAg6
	mw2DLYoKmk2pas1It7OBgBEQ0rq+Vns=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C57205BCF8;
	Wed, 17 Dec 2025 13:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765977589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wztWl+3aVrB9ZaSvZauY3Y92cOMYfXSxVG3uQ3w3yp8=;
	b=d/r/mqlDcaigIbZYWJ/m59+Fi19MaCpW9kiSdUQv/4rr8dyc7s3exykUTYE1FFNXiKyP9l
	XUksB9+eBx7LKN8m6EJ6i4tptG4Jao24nO2JbIR4EN4kcwBFa3Ng3QJW5cORssiOxlEybu
	+wyVh5AzmcJdZAD7Q1HVPQTbSSfZrMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765977589;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wztWl+3aVrB9ZaSvZauY3Y92cOMYfXSxVG3uQ3w3yp8=;
	b=qVuvwgEaSTyWM8rwiKIMVl0i3HyOWwWZEapvNFK19Le38rn5xuO87en665Bsn99efSJy0G
	JAvh0//AAvY939CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765977587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wztWl+3aVrB9ZaSvZauY3Y92cOMYfXSxVG3uQ3w3yp8=;
	b=MmUVfCuqjeCDx3YbvqaNx0PCpFy4awPNLsRn5bkV51Yzjh9jt7/yUEt2BOZZP5Pst58+kG
	mpnAxlik+7TeRBi+VSCtyDhsJqTFGauEp+QJRusEzNLD8f/uKvk57wONGz7vC2czkOd8yF
	S9welZCF4QfG95rAGMoUUtYu6eUGGh8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765977587;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wztWl+3aVrB9ZaSvZauY3Y92cOMYfXSxVG3uQ3w3yp8=;
	b=l55emC2wodh8Y5v0NiRnqfhHfZceI8HYXOZY/mhTbQKS9e8Ud9CnsI46RjzI2nfBmnAi6R
	69HXePqmsAuaEPDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B9F83EA63;
	Wed, 17 Dec 2025 13:19:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LO4MJPOtQmmLSgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Dec 2025 13:19:47 +0000
Message-ID: <17c45b15-326d-4b4a-b3f3-745002b81d5f@suse.cz>
Date: Wed, 17 Dec 2025 14:19:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: restore 0-handling to
 zone_set_pageset_high_and_batch
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Daniel Palmer
 <daniel@0x0f.com>, Guenter Roeck <linux@roeck-us.net>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Matthew Wilcox <willy@infradead.org>
References: <20251217130322.3350377-1-joshua.hahnjy@gmail.com>
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
In-Reply-To: <20251217130322.3350377-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AD208000A
X-Stat-Signature: 1wg6hy3j68w7qng63mk4fq3hiyb64j4b
X-HE-Tag: 1765977590-841985
X-HE-Meta: U2FsdGVkX19YOA6CtdpjqMFG+oBnBxy4XHC62dyFQdBPqBu3hElvA8k0P3MeT51HeT9VNcfLiUjr5a4gWN98DYez6UIwpGiedPVMb/4oPkFZ7kWAVAc3hOUMzyD1dk1ATXJ/mN7l8wecWom+Ajtkm8KN8p/iN5CvmScvxsriAP3UpzouU2wMxFBL7X4bmxgMFGpD3/j/ytIKM+XqO9GU05q/2XLt/4eCITQQzpKfswjpJzHSZIRHIYdfRvVCchX71QXN9QSpZ8+9o+8J2E61LxPwRfPonhrokXV0kvzjctOfhLgi6rbqBKy+g0STq7wAgJ1g5V80LtKnB+4Yox5VRibvFRP2JAqkOYy8vsDfME5vHBXReX4SSX++eVPC6GNb8CRWzGmVnN82+PFOYXRmvQTleyX/10gBUSqrFqQEhAnChYPg3s61qy/w3Px9bTMmhvz4OzDOGH54sNgsMFca+YPrOjS4rWxVFxmCtPGceJZkV7oQ2dvMdvjUbHMA3A4Sj7V/udeb0HLWKU0z+SWM1Jdk0JHrHAF2RghZcyLFil/LVyXHuguxmyAn2AeOD+/jY61MuGtJQi0CmUmjfzQ7A6s+4NBH2tzHiW6BgdFobfdf7hkCnslAgEsJaXc16VdLxcPdellpJ+xQs8EthGz7otMBXrfHtrHmDIyC64iJzae+xHxl0h3RXv4Y1hKkCw7Kcpmw8gBTbbIanIXay4heHMf/QVZ3VN6JlrfsmruZayLgVIOqM8ZaClojTWM4vtybdicTdWwOdNBzTpdXZTv4qikGlR/Za+OHcrRAkqM1g2bNFx/Q2vEsihhs90u6mnezdki3o6/gr/zKmlqX8QbZudG5SAvZoWmwd/CdF4QhpVj/Hx84VnjwPwUEuJ4hn6HNUEGt79Akpwz+tm30vdMmM31sEiqgwm6I4FiK7h87YPKMH7tHEkXrHjeX0E2RVujcPF0m+dDScKLqvz1L92s
 HBqDkQT8
 hhDKTmagcbuu3H30Fz0bhjJAq0zhtls2Gzmx0/mP4g0h1K/aG+mk/cLrtMEk4v8bGV+eZAReEK/vU231wHTIFKe2/nInn6nFMT8pvvJDEH0vi0WkJFt396qzMU1qS8fOmlZ/rwJalZnIZi8cFyqt20tz3+6Po9M6OF2rYh1NtpAHeL4BfK3kaZW9C8XgKL7K2tabH+ddf2Y2AKkJ6wmNa0jY9Gjdj1iSmdI/8pRsJA+OlB2ZB90HOuU6uV87srR8MuUWibqTLrHTe5jgQyiLc4Zk9dsCpPPkhNNRJ1DoAY8IZ0+rvpkrWv9T0sli4Shgm4i9OMau/WJPZz/QUvLumv72Ye4ViUcSHDKnl1V0ARYLXWL5ZSyQW0Int/ULkg88vBkqS6l1thdCsy2W669hNfSN61CXFqN3IZy4bEUFSbbeXNfIFpvn3V6T4WcAWY0+coshBMwp5kyk1yxM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 14:02, Joshua Hahn wrote:
> On Wed, 17 Dec 2025 12:23:58 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> On 12/17/25 12:12, Vlastimil Babka wrote:
>> > On 12/17/25 07:05, Joshua Hahn wrote:
>> >> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
>> >> moved the error handling (0-handling) of zone_batchsize from its
>> >> callers to inside the function. However, the commit left out the error
>> >> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
>> >> 
>> >> Since in the NOMMU case the reported-to-user batchsize should still be 0,
>> > 
>> > Should it? The value is effectively set to 1 despite what zone_batchsize()
>> > returns, because of that adjustment this patch reinstates. Also does anyone
>> > care, really?
>> > 
>> >> we would only like the error handling to exist in the callsites that
>> >> set the internal value for the zone (i.e. zone_set_pageset_high_and_batch).
>> >> 
>> >> Restore max(1, zone_batchsize(zone)) to the callsite to prevent errors
>> >> on NOMMU systems.
>> > 
>> > I would rather make zone_batchsize() for !CONFIG_MMU return 1 instead of 0.
>> 
>> Ah looks like you considered it too, initially:
>> https://lore.kernel.org/all/20251211225947.822866-1-joshua.hahnjy@gmail.com/
>> 
>> It makes more sense to me than doing effectively two fixups in the MMU case.
> 
> Hi Vlastimil,
> 
> Thank you for your review as always.
> 
> Yes, I had also considered returning 1 for the !MMU case, since I think it
> would make it a lot simpler as well (It would also make my original patch
> function as intended).
> 
> However, I was unsure if changing this user-facing behavior for one line of
> simplification would be worth it. I am not a NOMMU user, so I have very
> little experience here, but I imagine that there is someone out there who
> looks at zone_batchsize() returning 0 for NOMMU and interpreting it as
> "there is no batching" as opposed to "there is batching, and it processes
> 1 page at a time" (which, actually isn't even true anyways because of the
> bitshift). Maybe an option is to just make batchsize not visible
> in the NOMMU case in addition to always returning 1 to avoid confusion.
> 
> Anyways, back to your original question of "does anyone care". . .
> 
> I am not sure : -)

It's a pr_debug(), it's not even being printed by default, nothing can
possibly break by changing 0 to 1 there. So I really wouldn't overthink this...

> For me, both solutions work, and in fact I prefer the original solution of
> always reurning 1 for !NOMMU. Maybe some NOMMU users like Daniel and Guenter
> can comment on whether this change really matters?

I would be surprised if they were aware of that pr_debug() in the first place :)

> Thank you again for your review and follow-up. I hope you have a great day!
> Joshua


