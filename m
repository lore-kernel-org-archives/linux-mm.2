Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA55C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D799B6B011A; Thu, 22 Jan 2026 03:42:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51C36B011B; Thu, 22 Jan 2026 03:42:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53DB6B011C; Thu, 22 Jan 2026 03:42:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B13D86B011A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:42:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5AD9E56B54
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:42:36 +0000 (UTC)
X-FDA: 84358958712.20.E0BFC7D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id ED65E140007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:42:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uhvEYvyl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5K56Hgh3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BN1aHwYw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=beOCQ+fX;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769071354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtkavSVJht+G/RwkNgcjxFWYFwzxqjQgltbZ6uHMgU4=;
	b=BTrPESMyOWVgGX7zk+K/hK7uhJFsBU+U+YUSQ7VAMJKdRnQVm9II/W22RHSxQuPMkolBQ7
	HpN12mEJPCtboAQ4yw9H0OX5TLca+zGXtHgUhuq3uNkLLyfaG7v2fmr8OlJEJnkXEG/0UG
	UF8jVSvg3PML9e49k6WKFU01YM4hZPo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uhvEYvyl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5K56Hgh3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BN1aHwYw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=beOCQ+fX;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769071354; a=rsa-sha256;
	cv=none;
	b=m5xXogXOP/mbf9fb75kzsyImMlwffKKEoBIUpIR+tzEKFb6+5fdp8UDMl6uBcekGhQFrZ5
	3SwZHlhTE57zVoEq2EOydYh4mgnILLp9V8msxT5d4nlBWkCU+BT+TI4QoJMLav4+QgKbD0
	SoQUY7osWJcsEIAS+sty6NDV1FdS8F8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F021333697;
	Thu, 22 Jan 2026 08:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769071352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wtkavSVJht+G/RwkNgcjxFWYFwzxqjQgltbZ6uHMgU4=;
	b=uhvEYvyldlgqEPhfp+7mSHTVYe4MkEDyB1xZjxJqhP4t7kbUHpF7+BqkBxWfARNMFa9HZK
	hSYruhIPe9coBOBMqGqlaqBXkvZKqPonLq8FPvIjXzWr9tiKlmJo1IXBy5/Wc2QRTD5eDD
	U4hjM1cnLEvahtfMFywDC8RGvQ0p+Qk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769071352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wtkavSVJht+G/RwkNgcjxFWYFwzxqjQgltbZ6uHMgU4=;
	b=5K56Hgh3PXtWSBnnFQ2fBBj7tnbSkFDB6wrPugus4lE4qmWEziBFuQO1cMntQeynJp/eMz
	A47Jno53PH2EPuBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769071351; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wtkavSVJht+G/RwkNgcjxFWYFwzxqjQgltbZ6uHMgU4=;
	b=BN1aHwYwgAip7IHXrl4+wW64W5kUzJkg7s4i2Nx1QeOh1D7BYrxsTtBt6j82xlLRkjfXGR
	gx0TPKCXrsjmil6UetSlGjaCGJpAeS46xXLnjcuguTFp4A8dxtajYJpNxCJKJHmlHZEGB+
	PZjuCpBNnKBKERbR6vEs2wnQ6BL59F8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769071351;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wtkavSVJht+G/RwkNgcjxFWYFwzxqjQgltbZ6uHMgU4=;
	b=beOCQ+fXGIpQg0Q+0Ue81cHQEZxt+Mg2Pe63z63BbDVbStxBVK5swApeL3XTehwNZcXASv
	uGS+V7//BmhPyMBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C64373EA63;
	Thu, 22 Jan 2026 08:42:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QsbALvficWkRdwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 08:42:31 +0000
Message-ID: <e341d9ef-9ec3-47c6-b5f0-3749c930f477@suse.cz>
Date: Thu, 22 Jan 2026 09:42:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/21] slab: refill sheaves from all nodes
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
 <aXHLhF2kJxgy4M00@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXHLhF2kJxgy4M00@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6cpbj7y6mya9msp6j3bjxu6fhe38rta3
X-Rspamd-Queue-Id: ED65E140007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769071353-504448
X-HE-Meta: U2FsdGVkX1/xs1gf+DZtg4qfJDYgfnvif5LxnK+uRAdl/2VsOEHrUa4+y8qThmFgSEEzm8DXYacZpHZCQ9K0Izr41CQ0kBEnwgle3Oiy3O3LXKqvoascdlW4AjyYllZfXRg3bnBjq2SlRipkU7qK8BEJFz5Spc8xNje+F4jQg4ug8hikCWllVnllO/xzKuAB3pn7h3KoaaHjurCfobGEmqBztEcpS7IWSt0lINnEw9Qg+EuBb2jKdKGIBAu9RprkWRqIRqDDOzkG0FshTTArxCXvemBf+lrZRG76B6buKApo82/szStFPvwkVzcEVC+G+fltlFinxiECQWidyMzafvSPuiGYn1mxR0IhC52r8spgWhjL12LyGaGUH9qZVmQ3MlP0H1SFV2eBqTfNysNkp51IOyQ2zhZtZ86tRlSrlO7mNoaa3/4S9IIOCQr21QDT/IZ9pp4/GKE6Bj/DN3XTAZdRfs+8sK9CDidpK22CIuc7PQxDjLLblbpKq4BjT8VFV0MtkRSsF0RekKmiXoOwV+WlQmvznZNThn34UwhUzA2d6uaADcEaq/3J3/kb26pymerEDmOIL0Ua6gLPbiD98Ugwbeq78hsXx8CVWW0AJmFwNOK3y//KDhmIw22fJ81UYJjNK5zDaQrRZVsgzo4vjXZeVoUTpZNFxjQcqaqoQUBjvk07h/goLd6B++l+AqRJy2lbKdBe2+X1HrzutmP52Tq6/VJqMw6RvMf+Fw21b6fnU97gSe4aKT+0pOkAUXDlQ54pWTvdg7P1YhlEe7CObMHHdJ0SGuVZhs6yKUK7hxo21UmlDQk7luH8LyT3RAc9OL0yxc20ksWDUgjZCCZQiU9b43KdgafsfaDYX0RtgLnk0Tip+ReQgk4cwzFpLXJRdIhz7+tMqK+Dz/vTv6TVPQ6dEtg/nzYfqkR59SWn8rFXEPmrbEVjQLOHUfqrutymzs0jzAvxZ/9bTjzg66C
 ZrGklFr+
 1hc+pwSzSnkOwQwNrg0O9YxmlyJsEet1A/sUXN37cB0ZT/OF+7Q8tW4sonktNDjrsQHkPY8DtZxsln6d8n+q8sfbnaj3HfFgbW42qlhNsiGLE+SD1G9Ahfy8nKiEXPMgNMy68zN79s/uywKKj3h/coU0DTEpQne6r7Lyy8Uwq3OC870XWL3JQ6Lhap4Ob/7MZrd72gjbbxAWUKBi+7Yb37l6vzteSPqFIyRRjHMlc9o+ahy2a6nHVc+Lep0jsIm7yuNL3/+NYu8PPfifMivmKDRxxdDbIC5lxzc4gIRymLkyl+gyY7vWHg0QpjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 08:02, Harry Yoo wrote:
> On Fri, Jan 16, 2026 at 03:40:37PM +0100, Vlastimil Babka wrote:
>> __refill_objects() currently only attempts to get partial slabs from the
>> local node and then allocates new slab(s). Expand it to trying also
>> other nodes while observing the remote node defrag ratio, similarly to
>> get_any_partial().
>> 
>> This will prevent allocating new slabs on a node while other nodes have
>> many free slabs. It does mean sheaves will contain non-local objects in
>> that case. Allocations that care about specific node will still be
>> served appropriately, but might get a slowpath allocation.
> 
> Hmm one more question.
> 
> Given frees to remote nodes bypass sheaves layer anyway, isn't it
> more reasonable to let refill_objects() fail sometimes instead of
> allocating new local slabs and fall back to slowpath (based on defrag_ratio)?

You mean if we can't refill from local partial list, we give up and perhaps
fail alloc_from_pcs()? Then the __slab_alloc_node() fallback would do
allocate local slab or try remote nodes?

Wouldn't that mean __slab_alloc_node() does all that work for a single
object, and slow everything down? Only in case of a new slab it would
somehow amortize because the next attempt would refill from it.

>> Like get_any_partial() we do observe cpuset_zone_allowed(), although we
>> might be refilling a sheaf that will be then used from a different
>> allocation context.
>> 
>> We can also use the resulting refill_objects() in
>> __kmem_cache_alloc_bulk() for non-debug caches. This means
>> kmem_cache_alloc_bulk() will get better performance when sheaves are
>> exhausted. kmem_cache_alloc_bulk() cannot indicate a preferred node so
>> it's compatible with sheaves refill in preferring the local node.
>> Its users also have gfp flags that allow spinning, so document that
>> as a requirement.
>> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> 


