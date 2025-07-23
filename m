Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA138C83F34
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552578E0002; Wed, 23 Jul 2025 05:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5298E6B00A2; Wed, 23 Jul 2025 05:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4183D8E0002; Wed, 23 Jul 2025 05:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 307906B00A1
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:24:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCA9C140622
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:24:41 +0000 (UTC)
X-FDA: 83694994362.15.0C1934F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82314C0004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:24:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ccom6Vwe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1MtR2nQ0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ccom6Vwe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1MtR2nQ0;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753262679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGxCt9KCgX092Wm21+x8qB83HQqiNVWcqGnh8WxE9j8=;
	b=JNLpKYl50U2hJkIAk3S+tXowtRLVLpsrkTrO2XqhtRPO0UX5mvbBCq4xD1gtJhBRHMXeK6
	DreNEWmIKiKOFxLQzY6OBOp1AhHudLQXuL/qI7xwLwco3RV3YRF3X0wDWmC6608JxwTY3d
	gkt194/yUUDGxcZwAlzsrLkgdZyWOfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753262679; a=rsa-sha256;
	cv=none;
	b=7gk9BnMccGG2vU+ofT1lEDtuuEzNI9zxDZnL95Uq2awoz0Obo+1YPs7tWAKXc4vumhXfNh
	3nQdnX8FqGweJWGz3cPxvjDdweKycNtCXIKBbKYAZYJBV09jWWoIL3KDMmeUMVuK1d3oG2
	PWEW325tzoTpFPDIIZOJ1hcitiOFMck=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ccom6Vwe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1MtR2nQ0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ccom6Vwe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1MtR2nQ0;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 234151F449;
	Wed, 23 Jul 2025 09:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753262678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HGxCt9KCgX092Wm21+x8qB83HQqiNVWcqGnh8WxE9j8=;
	b=ccom6Vweafzv6HgsvYFpattF2Eqs+zq+DWVHKrSlRr5b3aipFUf4zj5jQGIi2CGnUy8S1u
	f4eCuTXbmP16yzbzD0wfeBLpJGt2iyQ/Kug0SY1ydBxxcwp8MiAOsB2Ng8mchhp3Yee91Y
	6Q/3sb3cZhP6BT58Bo7IIGzoTN4z/FA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753262678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HGxCt9KCgX092Wm21+x8qB83HQqiNVWcqGnh8WxE9j8=;
	b=1MtR2nQ08XHF4Gm9droZzX/aXdy5fOsKuyTMkQOH+FCmVKZS7v0Au0C6AO5N02jQCokHNC
	xb3BDjXNw1syzIAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753262678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HGxCt9KCgX092Wm21+x8qB83HQqiNVWcqGnh8WxE9j8=;
	b=ccom6Vweafzv6HgsvYFpattF2Eqs+zq+DWVHKrSlRr5b3aipFUf4zj5jQGIi2CGnUy8S1u
	f4eCuTXbmP16yzbzD0wfeBLpJGt2iyQ/Kug0SY1ydBxxcwp8MiAOsB2Ng8mchhp3Yee91Y
	6Q/3sb3cZhP6BT58Bo7IIGzoTN4z/FA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753262678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HGxCt9KCgX092Wm21+x8qB83HQqiNVWcqGnh8WxE9j8=;
	b=1MtR2nQ08XHF4Gm9droZzX/aXdy5fOsKuyTMkQOH+FCmVKZS7v0Au0C6AO5N02jQCokHNC
	xb3BDjXNw1syzIAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC17613302;
	Wed, 23 Jul 2025 09:24:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yvxOOVWqgGgLVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 09:24:37 +0000
Message-ID: <d2bfd6ba-191d-4466-858c-bd1731605a87@suse.cz>
Date: Wed, 23 Jul 2025 11:24:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add missing files to page alloc section
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <20250722174143.147143-1-lorenzo.stoakes@oracle.com>
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
In-Reply-To: <20250722174143.147143-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6kppir6kgp5r95wfjp9pgeakfteufjqn
X-Rspamd-Queue-Id: 82314C0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753262679-928660
X-HE-Meta: U2FsdGVkX18Ao5dOIolULUPBo0w6f78DhYllxb9uEbyFSFyOm1YRNIgeKHIGegeV5vMGQcRKAqlZr2yWU76Dg1wwSS15oSoSziX+B+mMUl1PY+6jjWyXh4thoqrDMRG2uTEZfVK+qLV5cySMf3dv6QDolCYgjWTL+wMXV9Vgnj480dUB9NxhD/hHNDlK7E/JwPt2QT93t1aBUKo9rTricrFkbPcxF/mkWyGq+zK/q3qHMHJ0Ny9k9cIBAd5uqehGQwoWv1em8L+JwoDHJEJSLiXMqExTknB9eeOJhsSd8fFjOOAr19t+g8fz0YdKLlrFNN42Lk4KRIJoHmDodIu0n8acGPhhLgUFPUzRjiJLun6iPiSQhqDhGqr27QKWvhorG1M/WGEbpaVh1ccPZ/BoUAyQDzsljDuP+VDf0VmSKBypM+Z73wNp7I8k8Ry/xTQy69VJeKOruwy3tdDzVQzCB5pAYXKKdH7Dn72ZIuc9H1+4Ow908Ul/R0/AOVgg5wLWAHl9ZjudIKo4RYqJ1JurF3tGrTnTqrodkO5LktHjnb43frK3871j9QuGQBR1xbZixm/qARsiudnNiRvVikn3tKPOoda0PrLQLH/OCVK0mnvwO+LMKTRfh4+UdfQejbMH+BLGbqcqL2TBLDCkIaM5ZasewFNyyP3fbiicpsA5aAwJW5rXuHYqTwx6TWRK8WL9dQe1Sp46MudGsz0osoYs/rK3GFgt8mxICTtByMZoWOPYbG6JUsVHi7yrc81M5thIBGG4IL+DnEQ1vDpDdd5LIZUl1pEGyvWHFswDfM0qt3Vvd7LQUwy3Ouv9385ldC/5gElJN3BQLhazynHi69rFRBnHpJ6tTWoeApeaNvIFF8Ss7m4fIFM0uBKZ0FJycpL3+tnaLulZzFP1t6FjPVq8yDmYBt96tp0hZ8bdwompm3v433rHeggSBIr4/DZpX9+NchIzlgttsagfmrb/UCL
 ZDhBmk/n
 dqJgcWqMmXyCVIA2g4ClwKaBiphjJLp2cxLFL+G5dr6B5XdqeZk/ANKQLD3W0itQ4U/vuNFHRa0mlRVKZ8N7cNwjtjXgz6EbJpc7zUHreG7/cV9EIIPitxa1jOHHG84MlYcsSk/xGzbnRw2KoIxLl6V81gsC3yDHI+Fzqgz2MbA9mEYwYG+6pE59v4BMzkSeNwOLcM7Sc3L8YuFFFieZ96NgcHFCTE/eKr5x76ypk0nJs/RA/hKjDl77z4q5cFT2ieTODem+oeuOyT3ZOXkustOpnGDHqAlaeyUFReaPEtvpUTZU9BLDz/VX9hmue1LupWN1VWAOASDkmDQafiRIIpe3gDNHzF80BYWKGVQIg3rUkJ0kV0IDIxEb9FA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/25 19:41, Lorenzo Stoakes wrote:
> There are a couple of mm/-specific header files that were accidentally
> missed previously, and some page ref debug code also that ought to live
> here.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>


