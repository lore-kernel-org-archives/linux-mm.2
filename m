Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7683CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A6D8E0014; Mon,  1 Sep 2025 04:04:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA988E0002; Mon,  1 Sep 2025 04:04:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C0D8E0014; Mon,  1 Sep 2025 04:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E24C58E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:04:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB8B0C0707
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:04:50 +0000 (UTC)
X-FDA: 83839945140.30.9921586
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id E68F6C0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:04:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rV07EeO+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F2rOiFf9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KZT7Lp4S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r5OyUEQO;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iZQBCEvkqNhfR7+tg1Golqh8qIukiggVHmycsiCiLQ=;
	b=CF3ZuT+1boi/RruFhARMHz3dZAbD4iMN6izzIR9GasKKkBtSRtGD65eDdl4rDJ0tElmzxl
	fE/Lnevf9u4j7bXXhVPnbEYek3MohN2fywW6OeVizFG/LAZDVRcyxNPku2DPowfJRoA1Lo
	wJHIYfuvqV037vFKhz1Z02zgZ+DKij0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rV07EeO+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F2rOiFf9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KZT7Lp4S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r5OyUEQO;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713888; a=rsa-sha256;
	cv=none;
	b=IbnfwWCP14VI6UkyqfUIsd8+jAG9nuug4gKOgYDyxNLZF+x4i4d/7N/FEXpoLljbb7EtoF
	tg5KGC0OrGYSQjj+tXmVp+g2s8Dggw8rcGwXvIW0qfZ0aHyvyY0UV84XxjQA06X9DG0fkH
	g1KXCARCUFOMXTIVUlzYeyTiLvFouLc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 16722336AF;
	Mon,  1 Sep 2025 08:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756713886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3iZQBCEvkqNhfR7+tg1Golqh8qIukiggVHmycsiCiLQ=;
	b=rV07EeO+Nx7iUKjpXJn88SGeJhf0Os8LEf2qa7D7LM4jZjjli+aqUQlIToi/nPFQMkHYrY
	QoM3btlqnDQQC045cCLlMAZEuVZnQsGjOz2umW9MJuuZI82UfgHbS/et/PxkEZX2orsF24
	IKJ0whNXqtcBk/L0ROckGr8+RxPUSLc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756713886;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3iZQBCEvkqNhfR7+tg1Golqh8qIukiggVHmycsiCiLQ=;
	b=F2rOiFf9I7O9F3TU6aK4Sl1EDgpWOYUGSeTcP6HY85mjC5op6G5TJizvixSobvMqJ2+/WP
	I6YOulUcGUS/LwCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756713885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3iZQBCEvkqNhfR7+tg1Golqh8qIukiggVHmycsiCiLQ=;
	b=KZT7Lp4SkHYZ5VviwZLYg9iwDjlmbldmwJacivN/6dT7e6JKhvLoBwsCd5EjB0nAEluPJY
	C6/it3oJ0AeRQvtcVIaIkrksC/3iCklNRxBhUCjLyHHIfUxqiZe6qH6bNcn9AvbdeAGiDl
	fXQp2yWTqOjP00r4CTizSXCuJIcZDZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756713885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3iZQBCEvkqNhfR7+tg1Golqh8qIukiggVHmycsiCiLQ=;
	b=r5OyUEQO8cMHcZTUPvyIEbMd39poRY5Wl5CME0DlPq+2w9w0qsAIjR368aIhLYvdkfZ4yz
	bDqE5CHggak/mEBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4E4B1378C;
	Mon,  1 Sep 2025 08:04:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /QHzKpxTtWgXUwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 08:04:44 +0000
Message-ID: <c4779bc4-eac3-4468-8e5a-d0d20fcdde16@suse.cz>
Date: Mon, 1 Sep 2025 10:04:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting
To: Ruan Shiyang <ruansy.fnst@fujitsu.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, lkp@intel.com,
 ying.huang@linux.alibaba.com, akpm@linux-foundation.org, y-goto@fujitsu.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 mgorman@suse.de, vschneid@redhat.com, Li Zhijian <lizhijian@fujitsu.com>,
 Ben Segall <bsegall@google.com>, stable@vger.kernel.org
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
 <20250901020538.3960468-1-ruansy.fnst@fujitsu.com>
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
In-Reply-To: <20250901020538.3960468-1-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E68F6C0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d6gswaw5wwpx7ew717mf3igpx673ii83
X-HE-Tag: 1756713887-974162
X-HE-Meta: U2FsdGVkX19Hx5HStBU6TVeBNp9tCx2dCe1h87UpokvRNkbXw3g7csjA1ahR8X8LgoZp8jS39ka/G4DWkqn/aALOe2BfT7982l643CBJfr703OquEdl4gHR03kVQKA4N1r0tebIsNxLkTLU1ti/y+oyUTpHon3nRGbJJIrcagP4MrlTUv1MgAnndbFK5IqQ1e17Bzlbf+vL5cjnhBjVcBuL6UuF2opHrRY2CJFvjk7bokHgdbIVbQUG1Vh57gemA81oKnkzDF8bPiXu06s8HIiXXT8MQBekjsriGqz6wIyxUdGkNRG8GezrEbHm4FdSFnonJ0hBdWm2s0R8Ga3xA9Qk85Hb6ErNnA5b8n7w48nDUYpJ1MbNuSOuVoijPaxeKIgSE/5AIx31ZjoqkoAMjaF3d0x3AwK/omJJh6H78ByGdK7S9/Mmxgs1tGL1bqsIzCU/mIMUZP/ce9CxE4m4f8r0wa8/1cp+6IwoM3KM/Rq5a+ZvuUUf/ReUITLZYiykgYdcl3PiLD7vRAHwQip7ptzQPviVy124u2aILgcKLmOLf/guQbtvEaFATWxJ+CLpfwzfrS0ecYDNBjCU+zU/yGh+Wc8hsOhJTFS8OgHBMS67OQbZAJd16WuXijQfotFsaQOHeoTVuGtjoR63NQHwMspYsMkCY293nkN+xuCXntzDEQ4lbo9gib8Z3ddeFAdCb0VwuGm/3CbgQ+0N9s/SVCTPz7CMKkGzt6DozzGrofD0W+3sCf1dt1ig4JKVd2AeLIFx3eO1mk/uW1nf0yyuJZhUA2gwKaJC/hKEbWCXNoqPBDSSOwjPUTpZUSr8SvD7JArdnIeXo+9YpQzBh4G3Utotl+WNBWx96tFMQ5NjaSZxy6te81ZI2w6+YeXV/IsgTtCTTAM63ddbh6iH2AQXA9gJIAVX1kkdislhJAVPgEfDTUS8admxf1Qw8De02xSuvwunCwguBUReIVMIVV9/
 3wtFPcf9
 TX+8SyDyL26z3vYw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/25 04:05, Ruan Shiyang wrote:
> Goto-san reported confusing pgpromote statistics where the
> pgpromote_success count significantly exceeded pgpromote_candidate.
> 
> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
>  # Enable demotion only
>  echo 1 > /sys/kernel/mm/numa/demotion_enabled
>  numactl -m 0-1 memhog -r200 3500M >/dev/null &
>  pid=$!
>  sleep 2
>  numactl memhog -r100 2500M >/dev/null &
>  sleep 10
>  kill -9 $pid # terminate the 1st memhog
>  # Enable promotion
>  echo 2 > /proc/sys/kernel/numa_balancing
> 
> After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
> $ grep -e pgpromote /proc/vmstat
> pgpromote_success 2579
> pgpromote_candidate 0
> 
> In this scenario, after terminating the first memhog, the conditions for
> pgdat_free_space_enough() are quickly met, and triggers promotion.
> However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
> not in PGPROMOTE_CANDIDATE.
> 
> To solve these confusing statistics, introduce PGPROMOTE_CANDIDATE_NRL to
> count the missed promotion pages.  And also, not counting these pages into
> PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
> performance of the promotion rate limit.
> 
> Link: https://lkml.kernel.org/r/20250729035101.1601407-1-ruansy.fnst@fujitsu.com
> Co-developed-by: Li Zhijian <lizhijian@fujitsu.com>
> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
> Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> Changes since v1:
>   1. change Li Zhijian from 'Signed-off-by' to 'Co-developed-by' per Vlastimil.

Note according to the docs it should be both, Co-developed-by followed by
Signed-off-by.



