Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1472C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 10:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4BD8E0006; Thu,  7 Aug 2025 06:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394FB8E0001; Thu,  7 Aug 2025 06:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CBA8E0006; Thu,  7 Aug 2025 06:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 121EA8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:25:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3A2F5C23D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:25:45 +0000 (UTC)
X-FDA: 83749580250.08.F1129B3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7973040002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:25:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YDc+KMLp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fr070QO1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YDc+KMLp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fr070QO1;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754562343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+3VvCsoxNp5my7hzH07+UXcTWds5y41HFvpaJwE24c=;
	b=lP2ZD30ChIxWyHxb03DqURyivFrSYENPSaBjWcHUDoxOxo81hnv7SEiQkglz2pyVzRrts6
	A9LE4OuoK7PJvuNwfageLbywMONolEiqZvO07PPLvjKh7IbMC5Ta6pAXVyf5uL6/TpdzJf
	vKuZqAwqNjZWHFUj/crAwtV3soFD7ng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754562343; a=rsa-sha256;
	cv=none;
	b=Gti7L2OhvGpVforc5IylamXsdwWzgFnmfVbQbCoqudVgchK0eGJ8Y/Nu/I8TxshACIAJwk
	8I9RMkFyeg/G4k7xHqBXJXNWUGOP65Oxt9CePMTJohG2LsjEgqyybqvIWnjGeYZEqmP+z4
	bkOVaATNkPsBJqbaML3zXqnHaXWZGHg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YDc+KMLp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fr070QO1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YDc+KMLp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fr070QO1;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8619633CD1;
	Thu,  7 Aug 2025 10:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754562341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y+3VvCsoxNp5my7hzH07+UXcTWds5y41HFvpaJwE24c=;
	b=YDc+KMLpPBukUqO/26f+re2k1QlkiUyoesR8sfdj3FWt0HVH8LY/6QN3TEVcSz5aRrPuPO
	cMyIjrQJTZCUqhZ6329yrhyKk8Hi/2nxsAHNJIU5xR02b4yU9YUJa1ob/ONroBFjzqOdx2
	Wvlf1gmObFO5Gj6jWhPzmXKHJWn+AJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754562341;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y+3VvCsoxNp5my7hzH07+UXcTWds5y41HFvpaJwE24c=;
	b=Fr070QO1dbYv5zCv6Ftd93YOCXKzUcpI1Ae6H7UBLS3c+3+bHUb00KR//Dud6TIF4BlMX6
	aYn1nNnEgYmLmLCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754562341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y+3VvCsoxNp5my7hzH07+UXcTWds5y41HFvpaJwE24c=;
	b=YDc+KMLpPBukUqO/26f+re2k1QlkiUyoesR8sfdj3FWt0HVH8LY/6QN3TEVcSz5aRrPuPO
	cMyIjrQJTZCUqhZ6329yrhyKk8Hi/2nxsAHNJIU5xR02b4yU9YUJa1ob/ONroBFjzqOdx2
	Wvlf1gmObFO5Gj6jWhPzmXKHJWn+AJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754562341;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y+3VvCsoxNp5my7hzH07+UXcTWds5y41HFvpaJwE24c=;
	b=Fr070QO1dbYv5zCv6Ftd93YOCXKzUcpI1Ae6H7UBLS3c+3+bHUb00KR//Dud6TIF4BlMX6
	aYn1nNnEgYmLmLCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C1A5136DC;
	Thu,  7 Aug 2025 10:25:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id paqRFSV/lGikTQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 07 Aug 2025 10:25:41 +0000
Message-ID: <0668d246-ccbb-4a74-96d8-c13bf180053f@suse.cz>
Date: Thu, 7 Aug 2025 12:25:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for
 performance
Content-Language: en-US
To: Li Qiang <liqiang01@kylinos.cn>, akpm@linux-foundation.org,
 david@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, Nadav Amit <nadav.amit@gmail.com>
References: <9d60bae4-a61b-4d4a-a0a8-19058df30b0f@lucifer.local>
 <20250806055111.1519608-1-liqiang01@kylinos.cn>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250806055111.1519608-1-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7973040002
X-Stat-Signature: 3dhoxgmudqq1d1u8oe43mhm5wrik3o9p
X-Rspam-User: 
X-HE-Tag: 1754562343-297603
X-HE-Meta: U2FsdGVkX1909q96AlEtMBekTfP2r9bHKPUmrB4CEMZjfQq1ypWy+ckTozNp69Rgj8/oaTfVrhzzYqgdPbKiJHbNPaev4XP549T6uqie9AKUki7OtUI4ndSjEdhG6eVSsYSviXL2hHB2Kqbi0SkmBu1gh6N7T+6KGuKO+wal/RD7uziKE08Hl6BcdWt3LrJm27eyNWixek9K9eD8iB6cfA1jtFh8krixv1Y/aNl3zIFd6k1gKX1c96rAItJ3mXYmgAYySHBzA0qAbeJPESovKhxxAjel8D0pteVxsQdo2MYFbrf5JDaHmLgyXFhMurIFaKeKxD5zdK5VGtckBVnd8Pp52KvOdbq1JtA7+2e2u7i8KVmOe2md1WMCdF8U3cLvp66lDmDvpVv3cboJhZ2fbZAAB+mHaZvxmSZZwiEJA4e/+64J7z1pK9cMbWA0bUMrE0vHl0bEfsE0VfAvlo7vVOMDVW0YdZBIhz7pCm96DglKlX3i/4hBeaI9TxJBdxmFIpGvKTnrq9z3v8GsWZ38WhF1Qk/hs4W1Q3nr4S6KnLjOkXvM6Gc8ZUh/bEjEimxg9IESPrTQkt8TfKvKxXpe/6P5e3RH1hAIipkadp27zCKkpsXTPfyxTJbjK1GPXZ3eicPrlbvzhb3oapYOlwsBNgrTGDLDrcChObbAnxdAb+XQVoEF9OAUiSBOOx8NgE7AHKYITKtPcmeRRSdj9dsiDEtkssPpSDNMKKA2WGcm+BT46T7alUzHjmnLgeZ+/BgnPvNEUch6b15ysXx4pMQXcrsliCecg0VYPKRj5tqeckrqRpw1ploMgFt/jMILbW+4s2T+18Xup4MQu+5UZUOFMQTv8mJX/XOnKn6XpJO9pPkeF18kV+IBCvckDGOUO16XYKMJsaQzfqx6Ls5t+uD3DM2OXiY8+d7K1F4yIjclVHj044BWioGTy8xSe40RpP3Ytk7Tcqm8lnyA7Ns041q
 0zESP9Mt
 y7g0FrmU8YxGYPimdR/ZC02r+SVIVC7HFjl24nGyX8NEEkFZXSrY6rKNdLE/2pk9bwl1EauWgJYLzmJThPmSxmsgKaAKYy2zExlPAeNwG3Y/wDIZ7eXZpBaMhgzLK03J3jmrUhLbotJq3BFlHGAtpKUXPaCbcrr54CNBJvIu4e7nq6V1MJHiXtgW6JnwhE3//auN4PNZqWx0BJ/vV13Q5XHASpmIhfoQ84SFSLzZvHLkQ8zmKyAGdUU/0Gi471rYv2NDX1vt7/grSU/JcNuYcnHaiAGBJPOsgztKPzEw9EKTwQXqMuDnmvFPTExaMKm8qvETASZQsp9dKP8R6kf3EueMKDvZVHRArgUH8JIBZ1m+DwDk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/25 07:51, Li Qiang wrote:
> Tue, 5 Aug 2025 14:35:22, Lorenzo Stoakes wrote:
>> I'm not sure, actual workloads would be best but presumably you don't have
>> one where you've noticed a demonstrable difference otherwise you'd have
>> mentioned...
>> 
>> At any rate I've come around on this series, and think this is probably
>> reasonable, but I would like to see what increasing max-inline-insns-single
>> does first?
> 
> Thank you for your suggestions. I'll pay closer attention 
> to email formatting in future communications.
> 
> Regarding the performance tests on x86_64 architecture:
> 
> Parameter Observation:
> When setting max-inline-insns-single=400 (matching arm64's 
> default value) without applying my patch, the compiler 
> automatically inlines the critical functions.
> 
> Benchmark Results:
> 
> Configuration			Baseline		With Patch			max-inline-insns-single=400
> UnixBench Score			1824			1835 (+0.6%)			1840 (+0.9%)
> vmlinux Size (bytes)	35,379,608		35,379,786 (+0.005%)	35,529,641 (+0.4%)
> 
> Key Findings:
> 
> The patch provides significant performance gain (0.6%) with 
> minimal size impact (0.005% increase). While 
> max-inline-insns-single=400 yields slightly better 
> performance (0.9%), it incurs a larger size penalty (0.4% increase).
> 
> Conclusion:
> The patch achieves a better performance/size trade-off 
> compared to globally adjusting the inline threshold. The targeted 
> approach (selective __always_inline) appears more efficient for 
> this specific optimization.

Another attempt at my opensuse tumbleweed system gcc 15.1.1:

add/remove: 1/0 grow/shrink: 4/7 up/down: 1069/-520 (549)
Function                                     old     new   delta
unmap_page_range                            6493    7424    +931
add_mm_counter                                 -     112    +112
finish_fault                                1101    1117     +16
do_swap_page                                6523    6531      +8
remap_pfn_range_internal                    1358    1360      +2
pte_to_swp_entry                             123     122      -1
pte_move_swp_offset                          219     218      -1
restore_exclusive_pte                        356     325     -31
__handle_mm_fault                           3988    3949     -39
do_wp_page                                  3926    3810    -116
copy_page_range                             8051    7930    -121
swap_pte_batch                               817     606    -211
Total: Before=66483, After=67032, chg +0.83%

The functions changed by your patch were already inlined, and yet this force
inlining apparently changed some heuristics to change also completely
unrelated functions.

So that just shows how fragile these kinds of attempts to hand-hold gcc for
a specific desired behavior is, and I'd be wary of it.

