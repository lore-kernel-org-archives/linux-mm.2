Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2770CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 09:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC168E0008; Wed, 17 Sep 2025 05:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6D008E0001; Wed, 17 Sep 2025 05:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B341C8E0008; Wed, 17 Sep 2025 05:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3A48E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:55:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08CB6B9A9A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:55:15 +0000 (UTC)
X-FDA: 83898284190.02.F5A486B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C386C0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:55:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SY14dfm7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CMxk7EMV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SY14dfm7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CMxk7EMV;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758102912; a=rsa-sha256;
	cv=none;
	b=F1EUn3udbqW7X8Vs056L5wXTIoUWnVVCwNx5/Hv3/WFb00eur4vBPIgd5eru1ZiA17RNnN
	spPUCVGAiE1rzUwV6kUquhTy6qzwpkd7wpsQQQ1B8Uw4E+RY0vPlE1foPQXsdGCwYBFFKH
	RQjTHOnM0hBn+CT2llGnr2pV5Hk+Chk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SY14dfm7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CMxk7EMV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SY14dfm7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CMxk7EMV;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758102912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDMDJ1YRYJ021yCvgShr7WT3fYONkSGJfo3wVVSz2Pk=;
	b=mmXlvt+1QNCbA//2ja9GyzrHUQUFrZFGpVOr+KohSsgJqrXXEXb6EamNZDxYb6DWUTxXV4
	Koi3adMruLIsjUjw+93xhtdvVbiHOuJZVVzczKmZLk1l7xyrweVKYJ3Vt5eRK3nmvbdHEw
	5OP+sgKJJrPuVyk5hBtUX1ZOjoeOlnc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A5AE220F2;
	Wed, 17 Sep 2025 09:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758102910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDMDJ1YRYJ021yCvgShr7WT3fYONkSGJfo3wVVSz2Pk=;
	b=SY14dfm7OHlvUPij+l2PSHFHiu1atOnGFXcD7b4612B7JbbgmC9tJ8TnYwJaCG75maIbGh
	Gz1JctR1j9E5RSq8bWoZY+fUrHml3gtirnZMn52Lskg7dFqIEx6FHHc6CPTncylMMhggM8
	nBiUujMOkb3F0hTI27HKjjD5kw8T1Gw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758102910;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDMDJ1YRYJ021yCvgShr7WT3fYONkSGJfo3wVVSz2Pk=;
	b=CMxk7EMVqabWgrnVYbfOUd5rFE1oMOjZ2PpM7CG5EY4YpFp4LVRCZ+ODTchVZYsJLkpJV0
	kXoQegng0ii/UaDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758102910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDMDJ1YRYJ021yCvgShr7WT3fYONkSGJfo3wVVSz2Pk=;
	b=SY14dfm7OHlvUPij+l2PSHFHiu1atOnGFXcD7b4612B7JbbgmC9tJ8TnYwJaCG75maIbGh
	Gz1JctR1j9E5RSq8bWoZY+fUrHml3gtirnZMn52Lskg7dFqIEx6FHHc6CPTncylMMhggM8
	nBiUujMOkb3F0hTI27HKjjD5kw8T1Gw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758102910;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDMDJ1YRYJ021yCvgShr7WT3fYONkSGJfo3wVVSz2Pk=;
	b=CMxk7EMVqabWgrnVYbfOUd5rFE1oMOjZ2PpM7CG5EY4YpFp4LVRCZ+ODTchVZYsJLkpJV0
	kXoQegng0ii/UaDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FB55137C3;
	Wed, 17 Sep 2025 09:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w3avGn6Fymj0KQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Sep 2025 09:55:10 +0000
Message-ID: <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
Date: Wed, 17 Sep 2025 11:55:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo>
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
In-Reply-To: <aMpxnACqmsQl-lp0@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C386C0004
X-Stat-Signature: nay166r3ccsfkwms99wad3s4zfq8ecfk
X-Rspam-User: 
X-HE-Tag: 1758102912-859425
X-HE-Meta: U2FsdGVkX19l9YdG7N64kqp5uL+tK5wp7CQtATuEqV7yOioDE40Yhg13bkjO11QpACmsuhfugXsOHBGM96TaBtuwMDfTDaYPZfa2xfGB31rUzAh2fTc0P2RQKrGGUk8bVv8Mr0ps49rHXE7eOxUWDiZ7YPCfdgOYlvPRUniznIWu4cDC4KACmsaZjQ/YpluqvjEh053bAhv9nzI3i01Ud9Dh27lu5iJISqPLlEpV+tTXVghu84u79NP1mdjmMV1uVfqqTDgZVH63lKPjOa0b/G9eVV2UhhHEIfgRdOnOf+yALT5OfOFGrC79mMNryafsM4INMPy2Vz+gnd+QXP6JS7WNjMnFaN1Alh3f4Vx3SIXxSyRGsOEldDVLCXQz2claxbPWb1+B6CvtcJeU+Y6PrMwPUZ+wP0MzzEmT/eyYKyI9ksC1f1Hve2EuoipjKmpZWnMM2XCBLF+fmdlZJekyWbLOwVONQvyDuJa17nAf3VmQVCaL7nV+20mRNH3mv4azEHiIHz3hC8tuGFd3DzwGEsUB3eGdA7PBIv2vhmHW03WgoCL2IS7lKQsU5ACUAfgJDj9XxZK6Gny5jydbNzZTzsUX6IAoxODK68/h2MrGZsoVwUMaPY2mBm54kwIf2Zihiq8OKj7/HmSG1HXRk5UopL91ard/ePBnVUDDE0hcNDYb5kOl4R7IrvBdPwvTIIhRQQ84yllSg3Jpbv7DYJKzu23S2Lwc0tgIUte7P7oPTe5/REjbMxQ1Ef06vMLKDD65ijun/vUFPEQ98zqVJL/kO+2YhBQpxkRZtR8YNRjINR/cIIUheDhc2sAteO99Z3zHqyK5RviXv4vcUe/EOPG6x6/UiAK+cOfjTgA7UmTDOmuRdM9gfXR9UckfYhtTtoETvCWqdJwiZ3uR60wDoOMxf3OHZQkjYQfZAPNNNg+QzSgZRtmLpo5SUfQFuKpF//gcOXB+UWcXIKU16VyWmS+
 6csAbIyA
 N+LUdtbVDEGUS4N82dE5sqP6ws3aGflDzDwafYkTvIFFA3xRqeTqUssB4gAqgpkcIT/u0Hpj4FeyIRb9H0VZv3X73LjrXT2FWpQ6ftOEKWDoGYdgbk8+0ZrfDLspwYi7WN02WU2qgwAKT4A6dOu5Yd4+jXC6oejqw7b76mNd4U+c/0gS89m3ZeKZDg5xeie/QB7uR4n6mL7DhWKVmFGFmxoeQhFMhmZc+hGJ/qr1NMGL4DNsvDHDCptS8pDctVW50BKhfXuQhOo40NW58y3TSCg5WW8+k6nYkLdClJu8gQPMIGz/wPkBBBoYqtSQur6hvdK2E3Zdri6dXZCI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 10:30, Harry Yoo wrote:
> On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
>> +/* needed for kvfree_rcu_barrier() */
>> +void flush_all_rcu_sheaves()
>> +{
>> +	struct slub_percpu_sheaves *pcs;
>> +	struct slub_flush_work *sfw;
>> +	struct kmem_cache *s;
>> +	bool flushed = false;
>> +	unsigned int cpu;
>> +
>> +	cpus_read_lock();
>> +	mutex_lock(&slab_mutex);
>> +
>> +	list_for_each_entry(s, &slab_caches, list) {
>> +		if (!s->cpu_sheaves)
>> +			continue;
>> +
>> +		mutex_lock(&flush_lock);
>> +
>> +		for_each_online_cpu(cpu) {
>> +			sfw = &per_cpu(slub_flush, cpu);
>> +			pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
>> +
>> +			if (!pcs->rcu_free || !pcs->rcu_free->size) {
> 
> Is the compiler allowed to compile this to read pcs->rcu_free twice?
> Something like:
> 
> flush_all_rcu_sheaves()			__kfree_rcu_sheaf()
> 
> pcs->rcu_free != NULL
> 					pcs->rcu_free = NULL
> pcs->rcu_free == NULL
> /* NULL-pointer-deref */
> pcs->rcu_free->size

Good point, I'll remove the size check and simply pcs->rcu_free non-null
means we flush.

>> +				sfw->skip = true;
>> +				continue;
>> +			}
>>
>> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
>> +			sfw->skip = false;
>> +			sfw->s = s;
>> +			queue_work_on(cpu, flushwq, &sfw->work);
>> +			flushed = true;
>> +		}
>> +
>> +		for_each_online_cpu(cpu) {
>> +			sfw = &per_cpu(slub_flush, cpu);
>> +			if (sfw->skip)
>> +				continue;
>> +			flush_work(&sfw->work);
>> +		}
>> +
>> +		mutex_unlock(&flush_lock);
>> +	}
>> +
>> +	mutex_unlock(&slab_mutex);
>> +	cpus_read_unlock();
>> +
>> +	if (flushed)
>> +		rcu_barrier();
> 
> I think we need to call rcu_barrier() even if flushed == false?
> 
> Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
> be processed before flush_all_rcu_sheaves() is called, and
> in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
> so flushed == false but the rcu callback isn't processed yet
> by the end of the function?
> 
> That sounds like a very unlikely to happen in a realistic scenario,
> but still possible...

Yes also good point, will flush unconditionally.

Maybe in __kfree_rcu_sheaf() I should also move the call_rcu(...) before
local_unlock(). So we don't end up seeing a NULL pcs->rcu_free in
flush_all_rcu_sheaves() because __kfree_rcu_sheaf() already set it to NULL,
but didn't yet do the call_rcu() as it got preempted after local_unlock().

But then rcu_barrier() itself probably won't mean we make sure such cpus
finished the local_locked section, if we didn't queue work on them. So maybe
we need synchronize_rcu()?


