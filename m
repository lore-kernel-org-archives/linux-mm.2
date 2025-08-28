Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 061CCCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5BA8E0012; Thu, 28 Aug 2025 05:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375B18E0001; Thu, 28 Aug 2025 05:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E988E0012; Thu, 28 Aug 2025 05:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10B1F8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:55:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8AFCBCC25
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:55:03 +0000 (UTC)
X-FDA: 83825707686.03.BDCE08D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1965AA000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:55:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Jb41QwZ/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=orCY7bnw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Jb41QwZ/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=orCY7bnw;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756374901; a=rsa-sha256;
	cv=none;
	b=SFbzbN2SGgIXdBade0v74BTQGHz6XqIZO5ERScy3ff8i+daym8Wa/gGIXuO89E8ptI3AmI
	6IS3vVJ9uPl+b+YDR0bnB6SepUXwnm23VPhVL/MqwaT8udqz//YsCS4mIPybmhfFkB0tL1
	EwLbzGRkRAnw+KAlfLVYF/1Zh5CiY8Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Jb41QwZ/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=orCY7bnw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Jb41QwZ/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=orCY7bnw;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756374901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lk0Nf9EN90VgXQI8MjwdipymixkdJK6gPIPXgcSSBg=;
	b=uJTkDiwoC7hNwjzBiqM3V20kYAhQtm0FX29BN4RRCij0LN6egqmhcdVoXDf1W2di5xJnpx
	eMW3RgLGA+w4qJ9XPpNmQrdyoUi+d+brpws2mJxi4EXTB521etPOXnmSBOeXcKMarT3uxA
	pekdOvZGh5I96jFRc8LEBT8rfsQgGvQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D6C61F769;
	Thu, 28 Aug 2025 09:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756374899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5lk0Nf9EN90VgXQI8MjwdipymixkdJK6gPIPXgcSSBg=;
	b=Jb41QwZ/i8j4Nfjs/t/ExfUdyRRCP4uogAyYhaHOudS5XgdFWVS7vdEW5R+lmJhkLnm2A7
	SQ8qZd1X4CpMcdG/LgxAa2bNqOcj81lG7O9FwszMlEMey/rh/2sWmTovxgbIg8aisDhXI6
	XbGbmD+V95brT4EvgeQSzzVjtQsJzFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756374899;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5lk0Nf9EN90VgXQI8MjwdipymixkdJK6gPIPXgcSSBg=;
	b=orCY7bnwWWnYhqsIJ6QvfPwB9M+fVH/cmsoRl24luZHrUJiHgZVe3UitW4c9QuwQs3Oi8E
	KjjstDGd0BXKVlBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756374899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5lk0Nf9EN90VgXQI8MjwdipymixkdJK6gPIPXgcSSBg=;
	b=Jb41QwZ/i8j4Nfjs/t/ExfUdyRRCP4uogAyYhaHOudS5XgdFWVS7vdEW5R+lmJhkLnm2A7
	SQ8qZd1X4CpMcdG/LgxAa2bNqOcj81lG7O9FwszMlEMey/rh/2sWmTovxgbIg8aisDhXI6
	XbGbmD+V95brT4EvgeQSzzVjtQsJzFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756374899;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5lk0Nf9EN90VgXQI8MjwdipymixkdJK6gPIPXgcSSBg=;
	b=orCY7bnwWWnYhqsIJ6QvfPwB9M+fVH/cmsoRl24luZHrUJiHgZVe3UitW4c9QuwQs3Oi8E
	KjjstDGd0BXKVlBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C53013326;
	Thu, 28 Aug 2025 09:54:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y3liDHMnsGjMSAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 09:54:59 +0000
Message-ID: <92a3320e-2433-4ee8-8ed5-d5db6098b43e@suse.cz>
Date: Thu, 28 Aug 2025 11:54:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Content-Language: en-US
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Usama Arif <usamaarif642@gmail.com>,
 linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
 <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
 <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
 <aLAXsptN4cw05IoZ@devbig569.cln6.facebook.com>
 <2182c715-aaf1-46d1-809e-e4142bc083af@suse.cz>
 <aLAmp4oayTfkPJ3o@devbig569.cln6.facebook.com>
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
In-Reply-To: <aLAmp4oayTfkPJ3o@devbig569.cln6.facebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1965AA000F
X-Stat-Signature: wap3mo76khe8uiagotjuzgm78mmnn185
X-HE-Tag: 1756374900-615183
X-HE-Meta: U2FsdGVkX1+TY5pLbchosHAukH9YIa1YBEYhVw35+AtwSwGxPIa3guXKyY6thGlDijdJiZVzXA0B0kKU/7H7HQYyF5o0SEvMMcmgA4AIlgDbfPGIXIgFL5dRmwjdiHnB3Tg5xPGsMsdwESgUlz5KY31AQkPfoXGaO/RJ1xozezrxIyveGKTBX7k2RsOpWaiIligxWNwaehKynJayB4zNdgZ8vczpcXPjeOJoHEJIG/AId+EHR8Xio/GX+c1k3HouwE9gZ1M8yK+4wdo8ocEKpntOmLZeKmoXmTTgQ12fryUphhFK5guw94s8l2OYwQ4cKdSmxTXaz0rQLDrQyQYmy38gr/Rj3uxtAoucCTrN005ngkAsk3wGbfZ3OsmNe+rD3OcCyEnSFx2Q4ZtM07KJj7r1ZQrcDrK0ljslj1IP8TkZ+r+FEDp31h52jctRjILTUFNumxW5DA83SLmaX4WgfQ+9iHOJSO08zSAnRpHvdewtDd2nuJHG9WfTk8UIKl3o9wzt9cZOwjU4ml532IrnzvXWo6qqV4NSIiIXEQ3hrojw216g0Bn92DnCjmtHtGgTModQOg7CRkxSHHiK+KqxgcpLGaKIT54J1Z4WowBIj9DITmiOw0rwepotpX4waSijgcDs6n91DkzJ4jPLROXgf7oQHDcLbTatu9ECVZdnycYlYff9W5k1hoPCQIEI2xyZ50e+ICUVdeXUbVXX6ep4yZqkZWAgDcd8cCplCKC7X0CHVBRJwQXKTSmyJJpTJIM/x9mmie3ZEyarLJozQ4cQtWSVoztUiZ5zi5IteaeQ28Jt2NP+tXFLlTtxrIhYz5uE3AizTHb4FB30nwFRtu+POEmRlJ+qMFUDIjE6iEBrFFrpLZjNTo+lBMj67LqZs9qWn0xdiMZT/YCvNb56Lm8oXjXGT4JJf6NVVpMI5/wQmVNKVu9nXoLNxSnyQ9GiJWsiqbCIWmdv+RnXn8bnvR5
 5Gvf68LO
 g9Wc56ZLWVfdVwaNHDaZapCAENGgkiGNNPlhYqe+XSAPjQwUMAHFkQa0MDGX450FlkANn7ojatMG8HhP1lFdK+ewOhtBSL8n5UcsVXe2qQkMi2CRkCIpUmK2MGWgSHIgebUHAZVZ6FXJgR5/ahIqoiTGBGyHFX0Uon6F/NdMKJOiQZ82HOwrQyHxNCxzEhcI9DKsB4dvO9I33qlGRoprB8IXf5e0aAhwa150FENw35NbH1QEXftW5mO+3yCXxhLy1rW8k6hRto6SHUnI4RKv/aRu5dvaQK9DqVFFlEwkoGyfJaAWGmpHVTuA7tjebn/j+hCKfnLO6OWOu+065IsJu+K7LztYr9iCRdURQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 11:51, Yueyang Pan wrote:
> On Thu, Aug 28, 2025 at 10:53:01AM +0200, Vlastimil Babka wrote:
>> On 8/28/25 10:47, Yueyang Pan wrote:
>> > On Thu, Aug 28, 2025 at 10:41:23AM +0200, Vlastimil Babka wrote:
>> >> On 8/28/25 10:34, Yueyang Pan wrote:
>> >> > On Wed, Aug 27, 2025 at 03:06:19PM -0700, Andrew Morton wrote:
>> >> >> On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
>> >> >> 
>> >> >> > In production, show_mem() can be called concurrently from two
>> >> >> > different entities, for example one from oom_kill_process()
>> >> >> > another from __alloc_pages_slowpath from another kthread. This
>> >> >> > patch adds a mutex and invokes trylock before printing out the
>> >> >> > kernel alloc info in show_mem(). This way two alloc info won't
>> >> >> > interleave with each other, which then makes parsing easier.
>> >> 
>> >> What about the rest of the information printed by show_mem() being interleaved?
>> > 
>> > Thanks for your feedback, Vlastimil. We cannot use trylock for the rest 
>> > part as node filter can be different.
>> 
>> Right.
>> 
>> > Do you think we need a lock to prevent the whole show_mem() from being 
>> > interleaved and to acquire it at the very beginning? Will it be too 
>> > heavy?
>> 
>> It might be risky so perhaps let's not. Guess we can disentangle by dmesg
>> showing the thread id prefix.
> 
> I have thought about this. Since each line can interleave with another, we 
> would end up adding tid to each line. Not sure if this is acceptable.

I meant that printk/dmesg already does that so it's fine.

> Thanks
> Pan


