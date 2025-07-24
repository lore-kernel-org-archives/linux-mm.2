Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E30FC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6620F8E0052; Thu, 24 Jul 2025 04:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639628E0051; Thu, 24 Jul 2025 04:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528098E0052; Thu, 24 Jul 2025 04:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF218E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:38:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B67DE160310
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:38:10 +0000 (UTC)
X-FDA: 83698505940.23.3EE2B3E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 52F9D80004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:38:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R3czpp4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n43rdEn7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R3czpp4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n43rdEn7;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753346288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mmXfBZbKuz6DSk7IgCct+jPca8O8SZ9U8NlBere08A=;
	b=ruO/4ElhlN70xb1NwivsWo6h7NBfUNLzHabyZBWTCd2HbUUWw4nLkL8gUae8ZDkGGQReh4
	kkpzmVI892Iu7AQvJWTikLpC3DILjJXTPI8PKYKR38RFa3G0hnI/7cjqeZA8XTIi1z3lqd
	/ic0STsXxQqqlsmKrEZogFr43kAcKA8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R3czpp4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n43rdEn7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R3czpp4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n43rdEn7;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753346288; a=rsa-sha256;
	cv=none;
	b=SeMrk6mhgY5l5XrglL9XXbDWu7d+wBVHNnePv8K8Bvr6J9v+i4xnb7nDpK/Wm9Mt+fPd56
	EfRbtAVC8MKfYEtcpGC1+pStFX4qn+6k2bwoTbbSttEc+NipB3BfTXi8DnWxdVcl6EIvA6
	7v7ElRGuNbyQHeUMi52v/4XYy5Fkvm4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 611DB1F7A7;
	Thu, 24 Jul 2025 08:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753346286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4mmXfBZbKuz6DSk7IgCct+jPca8O8SZ9U8NlBere08A=;
	b=R3czpp4EnguitU9JUmlBPwUuweU0IjyP3y0Jgx7XI50DyVVf/yG3/i9NQmAslD05q364lz
	THjxZoRJm1PpzzfLWDamTlVU2lvuXxihNSZJ/IQ6SpghH5suAiUJKTGoL6shwcReyGUrya
	Uabp0jFRQ6ylyG5R3EKgyR0l4lru3m8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753346286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4mmXfBZbKuz6DSk7IgCct+jPca8O8SZ9U8NlBere08A=;
	b=n43rdEn7Ki0HQjsKGeXEgL8eqwxS2eej8iX2hCpLCG+eg4hZ5ej3BNyKwQX1ZRyEmH6xmH
	vWY7hExVPMZmrpCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753346286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4mmXfBZbKuz6DSk7IgCct+jPca8O8SZ9U8NlBere08A=;
	b=R3czpp4EnguitU9JUmlBPwUuweU0IjyP3y0Jgx7XI50DyVVf/yG3/i9NQmAslD05q364lz
	THjxZoRJm1PpzzfLWDamTlVU2lvuXxihNSZJ/IQ6SpghH5suAiUJKTGoL6shwcReyGUrya
	Uabp0jFRQ6ylyG5R3EKgyR0l4lru3m8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753346286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4mmXfBZbKuz6DSk7IgCct+jPca8O8SZ9U8NlBere08A=;
	b=n43rdEn7Ki0HQjsKGeXEgL8eqwxS2eej8iX2hCpLCG+eg4hZ5ej3BNyKwQX1ZRyEmH6xmH
	vWY7hExVPMZmrpCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FE13136DC;
	Thu, 24 Jul 2025 08:38:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c3gTE+7wgWjURAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 24 Jul 2025 08:38:06 +0000
Message-ID: <702ab3bb-db4c-49cb-bb77-4e864cae610e@suse.cz>
Date: Thu, 24 Jul 2025 10:38:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>,
 kernel list <linux-kernel@vger.kernel.org>
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz>
 <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz>
 <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
 <CAJuCfpHk_k5eVhAZTK=jJvES9311Hyo_YXxY-S56EAYSBuRVRQ@mail.gmail.com>
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
In-Reply-To: <CAJuCfpHk_k5eVhAZTK=jJvES9311Hyo_YXxY-S56EAYSBuRVRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: sria16dns77zh9haoshzne389axdwqwj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 52F9D80004
X-Rspam-User: 
X-HE-Tag: 1753346288-604967
X-HE-Meta: U2FsdGVkX1+a79wnwd8qYsEMt3anuD6SGYvDZUEHo2xnwxGJBaO03uwGTXKVlciRQ7QVIdShUHe2+YY+iluX4kaHR8LztkN+nNv/OMgR6MYl5EJ47vdJOcX7F0ozbzC7pXVPapLNMbtu6Kz+ImTryEv77X7JBEGCffx2M//a90OzponnhdyD61bhBZd3AWHlk9SSQxG8D/mpVEHcI7aEkQ2B0veCiTu46VSCWSViouZZtHtKamgkat2ve/GGWzPuNwEV0Q0+9bbvsCEqfobbRXGc+WveR+zyKQZ2Dhfiry2LUQgGXe0bxlR3Hm07bUudq9vPKDZPkQvgOwb8eh1isncuwwcKC51em9x9ZO1E49O4URqeyU/K63gtheC7+IGgB+n/ssjDaCPkL4IO8BFmsvJzyz0hHUreWKYKQbImkP56ZM1yeWNGPrB1EczQZmQEAsLA01LKJs3LqhCMac0elh8OGxfuf56Pw2vZOhlfOy9FjAQafxRooX0c5jqV2ppYTx6pAWys6VgoUAKXkbkfnYEmXZZmYZWz7O2AMd3RFdRQK/nIngKrONXUzJZbjDm165fPQsyQujAR5YgzUhuR5muZJCZOm+xDQnmMX9JU2JL3JRgVz9S4GfGkcbrVxVr2C0fbkKmw7jqMZDecUwH5EXUYiNh/LNF8sQ4lRpLTynJaCfW0tR1KREVgJTYlXDz00ayDroX2A/WqPQRL0tnundPmkrWnsC6xRfKXaO5TMo7OHD/L65PwsEbfbTNwzlBniG26xCBqYO8QTAlgaK7MzhoCeVPvmdviMalNWW+c2iekzYelUAOvB6EpYTr68bfD1Esgj3es6vZQJP40D80X1IqbjprZB81mfW/GmvUrsk4QzqvHrz97llyUHkW2JZjFlPaLsN5Xi5g1AjX0sfnSqUcm5F538ho7X6mEUZNNBGHt+u3B3+Gta5OQspxNat9mOlgWOX060ugXPhQfesc
 p2CSOPxd
 aFpNKzE9E8BojS7fzVOxMh02N7MbCY/WDqa63TaVhw9zY6+c4f8Aeab6piuxdYJndEcGY0s8W98VVkvFUqc/qdUxMtnBpWFTnKzBdWiKWnQqViNNIPCWtk1E+GXigcSOg6KshYCqDv5NRi22E8lqTHXtgjl/uC2rTsUO0RGV+1N6EbHNGURmyx1+pumg1QSr10kYy4xyCSKV/UUlPrqX7cvMneO4sFuf/PZFniUmg07QmpF1eGb/8WDKJ2TXc1NSHi8wS3kzjaux8Rzzc1ViOm80T1MpaVv1OZVeCNEhQk3Do/5m06yCrQrJ8EgNHdzYK7Sgq5POf85gpxoU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/25 04:30, Suren Baghdasaryan wrote:
> So, I think vma_refcount_put() can mmgrab(vma->mm) before calling
> __refcount_dec_and_test(), to stabilize that mm and then mmdrop()
> after it calls rcuwait_wake_up(). What do you think about this
> approach, folks?

Yeah except it would be wasteful to do for all vma_refcount_put(). Should be
enough to have this version (as Jann suggested) for inval_end_read: part of
lock_vma_under_rcu. I think we need it also for the vma_refcount_put() done
in vma_start_read() when we fail the seqcount check? I think in that case
the same thing can be happening too, just with different race windows?

Also as Jann suggested, maybe it's not great (or even safe) to perform
__mmdrop() under rcu? And maybe some vma_start_read() users are even more
restricted? Maybe then we'd need to make __mmdrop_delayed() not RT-only, and
use that.

>>
>> Vlastimil is right that if A1 was able to successfully elevate vma's
>> refcount then:
>> 1. vma must be attached to some valid mm. This is true because if the
>> vma is detached, vma_start_read() would not be able to elevate its
>> refcount. Once vma_start_read() elevates the refcount, vma will not
>> detach from under us because vma_mark_detached() will block until no
>> readers are using the vma.
>> 2. vma->mm can't be destroyed from under us because of that
>> exit_mmap()->vma_mark_detached() which again will ensure no readers
>> are holding a reference to the vmas of that mm.
>>
>> So, a special version of vma_refcount_put() that takes mm as a
>> parameter and does mmgrab/mmdrop before using that mm might work. I'll
>> do some more digging and maybe test this solution with your reproducer
>> to see if that works as I would expect.
>> Thanks,
>> Suren.


