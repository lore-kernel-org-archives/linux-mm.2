Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933B1D64095
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19FA6B0005; Wed, 17 Dec 2025 04:08:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7636B0089; Wed, 17 Dec 2025 04:08:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C836B008A; Wed, 17 Dec 2025 04:08:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B80B06B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:08:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57A8D136D16
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:08:48 +0000 (UTC)
X-FDA: 84228387936.02.66E2A7D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id E877080007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:08:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vNtMBhb8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RLEi5ltn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ouloy7it;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yruZhnva;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765962526; a=rsa-sha256;
	cv=none;
	b=fsP6WioQJXHXG2LjdKrPuukTAs8J1g/ufNryPxHuBPDCGZRZqbEOTV4sPyA3h7oP4bQT38
	ae9TMEF1h68uOHCP7Hg/kdtZXJw4Y/PcWBVaoJmWIQTlbdCTMNt4d8YNbc36RUGj4It/Ij
	k3dbLKDqao7Ieq6JeCNKO0FESallrUc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vNtMBhb8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RLEi5ltn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ouloy7it;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yruZhnva;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765962526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xUSD3NVSUMMY86ve39obxcZQZV68mWQy0htU5+nkkA=;
	b=Nr5B74IlgXZQ+Cwez33z+aY4avqef8oC7gxuQTcFaKV+0z0tLkWcwgtUUFPaxkxUTREME7
	DlOuG9bDEb2hG1SoIa+k1zuv0MQOLc5stL/MRI0XyBk0zO5vXEDtJVswizK1RvQbWluz9A
	QvdSkdcxayulmC8sN2ipfveHpZP54pA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0E10E336C7;
	Wed, 17 Dec 2025 09:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765962524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7xUSD3NVSUMMY86ve39obxcZQZV68mWQy0htU5+nkkA=;
	b=vNtMBhb8JakSzLAl4z2d65neHE1Q6fzdAEZCLFZqAuNIj4PlOdo48+KmW8zgV88aEglP9z
	rasI4L78ImWUk07uRx1+gN8+vuQ78n4ZYdDhkpi2nv3ZfBmg+HluIfphmD3YTRYVdKu4oK
	rh6a2R9ld2c7vsnFJcNbKjPvboyLK+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765962524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7xUSD3NVSUMMY86ve39obxcZQZV68mWQy0htU5+nkkA=;
	b=RLEi5ltnjPu3N/A6Jm8i9JNLcBBkZoY3C7oA/k/wCxvd90boWk6hc2zLyLwroQCc2RkGO9
	4mqqQKMSJgG9/fBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765962523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7xUSD3NVSUMMY86ve39obxcZQZV68mWQy0htU5+nkkA=;
	b=ouloy7itfLqbeTSPCDeY/VXjBvp3x+rjq8HaAzQsxpMyNI+qsuyPWYF0c5j19xOe5WyA7d
	iRZz8woLt1hEm2Rt0Tm67+pZh4I3msEtWf550MC96LQFd9NCIPUCZPN2w1em1FPlRXR1Rw
	WMbLX4j6R8MRZsTTnU4928BiwH5LiU4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765962523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7xUSD3NVSUMMY86ve39obxcZQZV68mWQy0htU5+nkkA=;
	b=yruZhnvayZ9WYcztQ9wyXlW5aPlm/W5nOQ77mZ1IAnTAy39hLqiDCwpX6PyU8JQtu0jhRm
	1AsoRIs8rwrDMWAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C3663EA65;
	Wed, 17 Dec 2025 09:08:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J4qtJRpzQmmtUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Dec 2025 09:08:42 +0000
Message-ID: <a3676b26-feca-474a-b09e-33986f53c998@suse.cz>
Date: Wed, 17 Dec 2025 10:08:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcg: fix unit conversion for K() macro in OOM log
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Meta kernel team
 <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>
References: <20251216212054.484079-1-shakeel.butt@linux.dev>
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
In-Reply-To: <20251216212054.484079-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E877080007
X-Rspamd-Server: rspam10
X-Stat-Signature: sp9bnhkk8fgyu6u9ic64xzhf8jm9ocqt
X-HE-Tag: 1765962525-537508
X-HE-Meta: U2FsdGVkX18mzCIwBMznhHcUswaiTyZBr1P7P5nrpJ0dNaKmb5XkSXAK7gb+mXmAmSb4PUU+5Rryq5ARV86SmsV0JfbSTcI7rpOvmuL/MJVrfX42AyUFGdUHjdMsFrEAgeOLeMLexEixorKovtajFr/PcVZJF18gXPtkLIWsuikgPJLA4mpkfcFPGVtedMTnX5o02TarHpwzPun0bNyMJyLvpem8TvL8KZ9s1fZOzW9SGQf9N4Xj6F+SAnWRZK7ORjVSF7t6m+G6KyT+sm/LZwMCKgr/MCumlKvPfU+i/IgUZnxlSRjawmx732LiQAo49l+ANdGcpdXF9legpbehA09lbceNcBptOjORyxROfU94IPQe5FwwuTBUtBYjfEWgoFijXWFTDmvG9BVegdZmyr740L4/n2ow4ZB/hejuA1wdmUW/HRSkwCRywqgWhaDryAwM+Nd7KDc1VmFj8s3XkT0vGpleC2to+t5jrEEh0teguiUHee8sILKir+dSTZfCMVhMUctGY55QI5Ia0qm+tQwtIR/LGPAsUel/hhOh62b09KxHzvSM1Eo3yzy8VU1jEf0c1qgJnnHrHAu4V3IWXRwEGyrq0Jgn1sbAch9nAneLDOD7yA4lv0p81b45UU0cLFfAIQlW/QKg4qaH4NiGHEHYgvwISmsf/I6Mb16VZJS8VvAhL9VUEJfr8rJ5nxp52WjHilfTVYufVWvde3Q/D+E93jqwePCVEJ++GhYWkLaoRdbpaDiawU4Uw6xJNnUoz6cMP/nTZcs6Tj70qMnvQWQiYANA/IHfFllmTSB5jDYJKlR0X5NDgPcyeRyp5lTNecyweg8sz3lF+gCPpQUFM52AURu/gVFIwVbWDBgO6pwGh6BmQSkOoFYGMJl7KhEqNnxPk+rVModbjUgNBVtUoMkB3jZcKAO+6OHTqV30/0X/62rzL+bWra//xSQR4HoayDOAJ8VgBWP0BQ7fclg
 nB8Zm9JZ
 679IgEye3ABCiJh60Ekxd0qOMz6BOQThmjgCiYuRg27CzRTiUbrC+oveVhGI+CJKymH1YfxebYZhNgDpgLswSbrntqsETS4hIBefgiE5LFBfIL961itzig2ytifEb01TDDuZNspr0gDcUmMG8HUXjifpJSAvoLdsPsyFnP4FICii/R9ohYEmlUI99FyBKo7ZdiOhvGTOsYz8PFzaHLWU4PGgU0FWA5WupJa7mP5620aJPmjvHAPgvUPwFKb/XysFEmoW5sgKoaobhqccY/fqehwQpxPAua7EYFdioYqHCYJUIbPSuXZlPFpu3bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 22:20, Shakeel Butt wrote:
> The commit bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom
> or alloc failures") added functionality to dump memcg protections on OOM
> or allocation failures. It uses K() macro to dump the information and
> passes bytes to the macro. However the macro take number of pages
> instead of bytes. It is defined as:
> 
>  #define K(x) ((x) << (PAGE_SHIFT-10))
> 
> Let's fix this.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: Chris Mason <clm@fb.com>
> Fixes: bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom or alloc failures")

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2e49f4ec9e0..6f000f0e76d2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5638,6 +5638,6 @@ void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
>  		memcg = root_mem_cgroup;
>  
>  	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
> -		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
> -		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
> +		K(atomic_long_read(&memcg->memory.children_min_usage)),
> +		K(atomic_long_read(&memcg->memory.children_low_usage)));
>  }


