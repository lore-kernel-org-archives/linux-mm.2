Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6D6CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C188E0058; Fri, 24 Oct 2025 04:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ECD78E0042; Fri, 24 Oct 2025 04:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5B88E0058; Fri, 24 Oct 2025 04:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA5968E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:22:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BF6EBE0C8
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:22:52 +0000 (UTC)
X-FDA: 84032316984.19.2B3A18A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0FFAE1C000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:22:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gdNScslG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fzjjD7te;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kfNciiu9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rd5kt/8R";
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761294170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkPeB87lRPuVgU88ssRCwTFV0ZQxOBkAH/ocPelyYHs=;
	b=kOalD4D/aUqv+Zu9g1wLqwbbJy0xCi1vpwlKdHr15xodokvpcH4o9wym3TX0bMymDL3gXF
	ae6x0GNi2N3HDrllqSsaaubIP9qNNEqPeeyx7WzsnPi5ZQPACSYLlpni9WP67dUPDF7n7l
	J1LuGqWzzQ1EuJwTIqGeu9JjD0q2CjA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gdNScslG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fzjjD7te;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kfNciiu9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rd5kt/8R";
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761294170; a=rsa-sha256;
	cv=none;
	b=G0127R+5nHGlyPpfL60rMGD03yYzGURMz05MLF0UOv89PnsRXZ3NUwxPf9fLmDKBg1GPHa
	cyjBgElY/sxQgEJo7zmdi0tk+wvhA98JMJuo+pk+c1J977QYWz2PZ6VkVzz2j/iDoVnxzr
	98X53rL87XCjfkFttpQfmgY431cKdcY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A88D1F388;
	Fri, 24 Oct 2025 08:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761294164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lkPeB87lRPuVgU88ssRCwTFV0ZQxOBkAH/ocPelyYHs=;
	b=gdNScslGMYx6d0F/XjWUGVFRAzzgtopbS3Q9C6Z/U+J63dTcRP27iMSzKNJV1h2S5/FCe1
	Q6/d5/o9GlpERrDgjX2lsGgnmYQsFrqGr0oSuVUaW/mQuDkBXeCdjyHe695DEHxVnCqjqF
	PukNOuXtjpojJ58YtZG5zzJH3IG+49I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761294164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lkPeB87lRPuVgU88ssRCwTFV0ZQxOBkAH/ocPelyYHs=;
	b=fzjjD7tenbWMco5xNw1fXXdBadnPsMbbTzEMl4ZKIyBdRCn+Qi7JHGpuzHOiRzD9EJh43t
	ZijqHX5G4DpYvuCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761294160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lkPeB87lRPuVgU88ssRCwTFV0ZQxOBkAH/ocPelyYHs=;
	b=kfNciiu9S/rsXe6xzc0xgd+NSQSZrYj2gFKlcq626+OpYP81lSyw68rFHVApqLttAOQkuT
	Wvxw1DSMYMYN2/bQU3Xr5OUWax3Hp7hG8+t/s9dlAQoCE52U6XskdNe1z2ONgwvFJp0cgv
	C1JoMstHipG7M6M9V44091/wCf3teW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761294160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lkPeB87lRPuVgU88ssRCwTFV0ZQxOBkAH/ocPelyYHs=;
	b=rd5kt/8RLA0h7cz8/MW+qqI/H2o1k1P1bvcYanH4CZQDdcniX13qp6y9keSv0OyEATdZ3A
	M76ORLw3fl26DFBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2637A13A38;
	Fri, 24 Oct 2025 08:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FtbdCFA3+2gQTgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 24 Oct 2025 08:22:40 +0000
Message-ID: <d1d729d1-2330-4710-801f-f007979abbcd@suse.cz>
Date: Fri, 24 Oct 2025 10:22:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: add flags in cache_show
To: Kassey Li <kassey.li@oss.qualcomm.com>, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
References: <20251017064839.585204-1-kassey.li@oss.qualcomm.com>
 <910a1d39-ca72-4e79-9f6d-66415794d9a9@suse.cz>
 <b7f44bb8-b12e-43e7-b870-f6499ae13e58@oss.qualcomm.com>
Content-Language: en-US
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
In-Reply-To: <b7f44bb8-b12e-43e7-b870-f6499ae13e58@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0FFAE1C000F
X-Stat-Signature: xtdgej7r7w6zsqqyf97ukowe654ddbfw
X-Rspam-User: 
X-HE-Tag: 1761294169-269888
X-HE-Meta: U2FsdGVkX19GpRw00eYkq+D8JIDi2cTFVBgkF7E6bZbKaKEaKGqActN00vSNaxuxIkwdCBUl7B9TJtCcMIFXS9UthtRA07CmdAkBqBt4o77f+BnCLwdG3R+CVYSwT54io+s1lJJEfo5VABG30uyFjyfNs3SA468F+ZlQCXeSI9KH05VZbnD3P5SeYNxRYdklpPJztyAHXBY3ZiPXmNv3JXBgv8QkdxR2OdX7wS7IgSVEvIw9+CZyaEjjsWbM3qcrxcxVK6j/puolTwq/R4oZEHe8L/hj9Rz1U+dAu/wiCwezP97Del41kGTEh2NVc/OuryboGDA7y/FD3ue3CFQP/uyLoOkp4cP6T8v6E6YhT0ILkShzyCSl34/xx0BgbrkTnAJxrnuLYEBA+2DwCtRoYTAK+O9MjoeCg3tZfNNrzVWT0ZC1rgcTgKmGC5IpzoEL3Wg6E6xxXFUhOUvkhoC4RmUJVx7hOl8faXCgnkDbc509+0SIolljv69KO/QBNGFGc/BPdRT6A0q4RUrlN6QnxuAP70zOyHVdeOVAaT2maItdN/UuqgkGWCMD6603EM3b5rvDaEha5UKc7YimXWn8r2sXP6vzibx6GGJoCORfX6QRWrCEMZTO2uFrf5/cO0fHehFwiwqwMJgpFsll8TZH15wY/b9CRI63jtDQumu6xo+yKJTNSFTH1ofJLl2bqekb8bJGsOx28Fvr72WP5ndoeGjNdVDAIg7+rq2VqIDXvy0d7T0BEPlNOFFCxFeKqXTfBA3fpPSzr9QikJkcZVbReC70sm0v+VBSnLyih0O88qB+cyXosjo8mtHKBpd742iKkb6rwYSY5My2ixC2DqVYcapTfrsNhOk5l+0iO+/s0eXlhy7Lr4Tbn846Je2I0vzSJImMZNKyfFJXfKkcIZ1UOMEitUmalawmhRVCJ50laZ2HNdUoNK0WAskuge9SQ6X2jZNMdwck/bRkYXZwYU8
 44fjnAow
 paotS4JwaeC4jS8IDrTrW2O3bNtf7Y5sWoZuouvp0qnwt0JOVqJ4Q5oJ2J+C2A/Suz8fJOJTat7pFb0AFjONRJXGVv7JRoZF/We5R4kQ/Y1r/hq2hglt9Scnx78jJ040jGRmlyAibP4sYhxfNB6OOuOncW0LeoLdAbHVa1GhYygyPXQyYEaW6c4ricmFEb42IEvDQaiR9hgN/RVJ39smSLGhH2eFZCNX3lVGxIBv6icEdxiaRy/0rsMz7PugpEdOjV1xpAQwVNCRrXCrRkCqCAqAloLXm9OBS/ooryHAWrfTAGmSTZak2onul3JN4UKsKDg2/48TwzxJHGUncmy82ul230snpQC2lYeBcYeCS5CpUOv/q2ODryYFXbQ9AMD0N3tUebsl0Px0Kc81qZWK+qODru3ep8ilnTs/0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 05:06, Kassey Li wrote:
> 
> 在 10/17/2025 6:50 PM, Vlastimil Babka 写道:
>> On 10/17/25 08:48, Kassey Li wrote:
>>> Flags info is useful to check the slab type.
>>>
>>> for example, _SLAB_RECLAIM_ACCOUNT:
>>>
>>>      0x50100 _SLAB_PANIC _SLAB_RECLAIM_ACCOUNT _SLAB_CMPXCHG_DOUBLE
>>>
>>> Signed-off-by: Kassey Li <kassey.li@oss.qualcomm.com>
>> Many of the flags are represented by files in /sys/kernel/slab/<cache>/
>> If you miss some, we could add it there. Changing slabinfo output could
>> break some users and the raw hex value is not a stable representation of the
>> flags anyway.
> 
> may you review this draft change according your suggest  ? if ok, i will 
> share v2 change.

What I meant is that that are files for some specific flags, e.g. the
SLAB_RECLAIM_ACCOUNT you mentioned has a file "reclaim_account".
Other files could be added for other flags when it's useful. Printing a raw
number dumping the implementation details isn't great.

> diff --git a/mm/slub.c b/mm/slub.c
> index b1f15598fbfd..619f446d2251 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -9033,6 +9033,12 @@ static ssize_t slab_size_show(struct kmem_cache 
> *s, char *buf)
>   }
>   SLAB_ATTR_RO(slab_size);
> 
> +static ssize_t slab_flags_show(struct kmem_cache *s, char *buf)
> +{
> +       return sysfs_emit(buf, "%u\n", s->flags);
> +}
> +SLAB_ATTR_RO(slab_flags);
> +
>   static ssize_t align_show(struct kmem_cache *s, char *buf)
>   {
>          return sysfs_emit(buf, "%u\n", s->align);
> @@ -9480,6 +9486,7 @@ SLAB_ATTR(skip_kfence);
> 
>   static struct attribute *slab_attrs[] = {
>          &slab_size_attr.attr,
> +       &slab_flags_attr.attr,
>          &object_size_attr.attr,
>          &objs_per_slab_attr.attr,
>          &order_attr.attr,
> 
>>
>>> ---
>>>   mm/slab_common.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>>> index 932d13ada36c..f43239211e69 100644
>>> --- a/mm/slab_common.c
>>> +++ b/mm/slab_common.c
>>> @@ -1083,7 +1083,7 @@ static void print_slabinfo_header(struct seq_file *m)
>>>   	 * without _too_ many complaints.
>>>   	 */
>>>   	seq_puts(m, "slabinfo - version: 2.1\n");
>>> -	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>");
>>> +	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> <flags>");
>>>   	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
>>>   	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
>>>   	seq_putc(m, '\n');
>>> @@ -1112,9 +1112,9 @@ static void cache_show(struct kmem_cache *s, struct seq_file *m)
>>>   	memset(&sinfo, 0, sizeof(sinfo));
>>>   	get_slabinfo(s, &sinfo);
>>>   
>>> -	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
>>> +	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d 0x%-8x",
>>>   		   s->name, sinfo.active_objs, sinfo.num_objs, s->size,
>>> -		   sinfo.objects_per_slab, (1 << sinfo.cache_order));
>>> +		   sinfo.objects_per_slab, (1 << sinfo.cache_order), s->flags);
>>>   
>>>   	seq_printf(m, " : tunables %4u %4u %4u",
>>>   		   sinfo.limit, sinfo.batchcount, sinfo.shared);


