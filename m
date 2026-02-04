Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B13CE9D41E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84D56B0096; Wed,  4 Feb 2026 13:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28226B0098; Wed,  4 Feb 2026 13:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C310A6B0099; Wed,  4 Feb 2026 13:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B248E6B0096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:02:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5392B14027D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:02:31 +0000 (UTC)
X-FDA: 84407544102.24.203A756
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 01363140012
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:02:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1TOJkMnQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pdmdVX0a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1TOJkMnQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pdmdVX0a;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770228149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZ3f5XE99Y5O1R9K1/1yZEnq3LWfNqveoQu7G+G/Vj4=;
	b=nzHJ179+hPPvTqFRlTgZ84Qq+iqdp3D0S2M5Jm0RPvWrOc8phppP+pb2ip1wbwkLX79Vly
	GJGQjuJR4iuOeO7N+DOxuySyvzJzXz+Qfd/em9e0WEaIJdNtQNqPLBSNev3LTZh5Ex3FRt
	aSes9d8ndyVPbe82ai4z+0zhVHwhG+w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1TOJkMnQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pdmdVX0a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1TOJkMnQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pdmdVX0a;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770228149; a=rsa-sha256;
	cv=none;
	b=579usHG4P1lrV1TsKbklzsOx3OYKdNgop37ek17Po4MEtQ53dVe1vwfPU/7MPefcqslhnk
	75x+nV+SGjw8JJLbbQT35e8TP41rKQFT8pNBIFod2HHwPMa0dm7LKaKLMn1xIHYa4dy/EH
	MEP1QxvZba5oxpKGdOctzwfFIotNyT0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B8075BCED;
	Wed,  4 Feb 2026 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770228147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZZ3f5XE99Y5O1R9K1/1yZEnq3LWfNqveoQu7G+G/Vj4=;
	b=1TOJkMnQdm+gR/OTMy99ZGY4dWUEusuGPRPUYalCIcjFN/YViOWXyAt+FDPtQJCtaXs08J
	eDEEIf9kORimJnMIGPn2l1L+MhwNBFnuDdqSXUuvtaDTJdOnLOP4bYY1oEM2I0nFoZtTc9
	D0mzUXddqvqHZOGhlNnATuIAayiVRzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770228147;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZZ3f5XE99Y5O1R9K1/1yZEnq3LWfNqveoQu7G+G/Vj4=;
	b=pdmdVX0a+D79NVmFuAFty9E40CPwl6Bt8vW9Fon7sE3O4PgvM+91LW4TNkU3ja8x9MdqJ1
	rw0+R20hWqk421DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770228147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZZ3f5XE99Y5O1R9K1/1yZEnq3LWfNqveoQu7G+G/Vj4=;
	b=1TOJkMnQdm+gR/OTMy99ZGY4dWUEusuGPRPUYalCIcjFN/YViOWXyAt+FDPtQJCtaXs08J
	eDEEIf9kORimJnMIGPn2l1L+MhwNBFnuDdqSXUuvtaDTJdOnLOP4bYY1oEM2I0nFoZtTc9
	D0mzUXddqvqHZOGhlNnATuIAayiVRzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770228147;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZZ3f5XE99Y5O1R9K1/1yZEnq3LWfNqveoQu7G+G/Vj4=;
	b=pdmdVX0a+D79NVmFuAFty9E40CPwl6Bt8vW9Fon7sE3O4PgvM+91LW4TNkU3ja8x9MdqJ1
	rw0+R20hWqk421DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29B803EA63;
	Wed,  4 Feb 2026 18:02:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RZfcCbOJg2nwKQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 04 Feb 2026 18:02:27 +0000
Message-ID: <665ff739-73d8-4996-95e0-f09c3e5b6552@suse.cz>
Date: Wed, 4 Feb 2026 19:02:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/22] slab: replace cpu (partial) slabs with sheaves
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb>
 <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz>
 <pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: tssuc9podw77ky5kb1wbtpum6ddqgf9x
X-Rspam-User: 
X-Rspamd-Queue-Id: 01363140012
X-HE-Tag: 1770228148-721874
X-HE-Meta: U2FsdGVkX18tfd/WWjaxiWATXyrs3+444wu67zJZ4nz1elrLxbVmm5B5cPywZEG6jRSqPt+1ZVcruh/u+IbNS1GYzLvz6JYCauBnqk7mWcMhX8i9cJvxvujj7663U8JTS1O4AnqkFkoYn0KjLM/nUwbtj2TWJqdAPNRDtcsizh28UBfUgM9ygl9MNx9wZgpXz3otadqS3iSB5PnPo1xMYZO0PHge6D6FrSNpVTUzNbtuPZiZdJRKqoD6/uTPPBv3TVnIXhiDJXEAqCG3LIiq1oiAV46oQhe26hKfJmKzl41+a1AAeFcgNYW2wd1heoQK2aftSLqgPkzrAqgWdd24w7lFL8MGJm5eMy9reWJ0InZlUhJWmt6H61NrT/8837w3QZ4nuPmDNs1GMSpVrlV9f8GL5Yhk5tIiZl5UJBHnHNRYJR6+ZS5FPXskjdYzB7eQksc3pGW2d4bjawNTXTAXnmGV68as1bzDlP4+Mg8F45D6QP0fGuXNVxEMQUDe4G1wzOvA8SYAx6G/cXxbMzMJeWXfmHeBTT0/GFktdh2rokeS1fv4LDafGmR3q6EUrRwe29eggQ1uFJPtsi/5G7BS+j4bGEsWE5XzKqo4Blq9EHzYGzSCbKxhhkySD4Jjb9DHWRHyntQusOuf16Xg+pHAgiZETTkD+E6QAzHSiSujZO0dMOrwFZA1F/MeJsyPu/l6ZJELLSiGgzdfNHZmg6IPSuS7BTNAY3p82Yb9xiwMY+4EQX8aJxAq6Mcp6e+CC3pQiQc6WYfDJv6wYkj/TZkExylPYKTK74YvJsIP/w+5UMqjDNIYNkC7OzA4aUVpiroVRM0XBDiAmiDI0AWdqhbMEySOq8rZze7Lc+bEafUyTfphPD3UAdLgi/W55v5noy2Lj1BAp5zdemM8k+UosRIvt2TjT2zTmKmQP03dKmAdrA7h7R16I+IeBNE3wHVT4DJOMcZ8lalVjJTwStkS2kC
 MY6+3BmV
 i+6YFd37Fevx/EVruUwTu539f7scKd70dkhbNVXL+NgDJwlPFjt5xF6kRWpA1W8OSC62DmnJS8iE3IzGEQdgkgJpWyGNwnhNhBfN45nJUDsruEPWC7mgamhFUR7WvtXZsyy6mWz5h1zPuGAt7kao6Z6w33lBYViThgpR+YOby2YB/O8hXmizHSkXu47vXbum0bBGCb0Lr1H6TSYjrCj26+96UkNatzOd1qlb9GNcoaSQ/3r+8FK+l8XF6EqCY7cOUx9K4v3cbFfuhuiFiivY87udvs4fjOkYlkhrG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/26 05:50, Hao Li wrote:
> On Thu, Jan 29, 2026 at 04:28:01PM +0100, Vlastimil Babka wrote:
>> 
>> So previously those would become kind of double
>> cached by both sheaves and cpu (partial) slabs (and thus hopefully benefited
>> more than they should) since sheaves introduction in 6.18, and now they are
>> not double cached anymore?
>> 
> 
> I've conducted new tests, and here are the details of three scenarios:
> 
>   1. Checked out commit 9d4e6ab865c4, which represents the state before the
>      introduction of the sheaves mechanism.
>   2. Tested with 6.19-rc5, which includes sheaves but does not yet apply the
>      "sheaves for all" patchset.
>   3. Applied the "sheaves for all" patchset and also included the "avoid
>      list_lock contention" patch.
> 
> 
> Results:
> 
> For scenario 2 (with sheaves but without "sheaves for all"), there is a
> noticeable performance improvement compared to scenario 1:
> 
> will-it-scale.128.processes +34.3%
> will-it-scale.192.processes +35.4%
> will-it-scale.64.processes +31.5%
> will-it-scale.per_process_ops +33.7%
> 
> For scenario 3 (after applying "sheaves for all"), performance slightly
> regressed compared to scenario 1:
> 
> will-it-scale.128.processes -1.3%
> will-it-scale.192.processes -4.2%
> will-it-scale.64.processes -1.2%
> will-it-scale.per_process_ops -2.1%
> 
> Analysis:
> 
> So when the sheaf size for maple nodes is set to 32 by default, the performance
> of fully adopting the sheaves mechanism roughly matches the performance of the
> previous approach that relied solely on the percpu slab partial list.
> 
> The performance regression observed with the "sheaves for all" patchset can
> actually be explained as follows: moving from scenario 1 to scenario 2
> introduces an additional cache layer, which boosts performance temporarily.
> When moving from scenario 2 to scenario 3, this additional cache layer is
> removed, then performance reverted to its original level.
> 
> So I think the performance of the percpu partial list and the sheaves mechanism
> is roughly the same, which is consistent with our expectations.

Thanks!



