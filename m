Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B79CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D59C8E00EA; Wed, 29 Oct 2025 16:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD758E00B2; Wed, 29 Oct 2025 16:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C3B8E00EA; Wed, 29 Oct 2025 16:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 068D98E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:06:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5EBFBA3AA
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:06:49 +0000 (UTC)
X-FDA: 84052234938.14.1AD32D1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 55715160008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:06:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r1GcIp4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NPTkSb3C;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r1GcIp4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NPTkSb3C;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761768407; a=rsa-sha256;
	cv=none;
	b=NJOaCQXcgzk86oHRba58nPQMNGl6Qq7pzy2kF5FaROB/ndKyUGhDwIy+THlVUjwrm1icoY
	c63BZ3zOpnzA4FmSUPRk96sHXd4e+bwUMCD8tp6AInoCKBPmmiRRRnGDX/IBw70alKkz6j
	/dygKsNzPQexId3Mz0zsECgu+Cf8P9M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r1GcIp4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NPTkSb3C;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r1GcIp4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NPTkSb3C;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761768407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3rh6Q8jxv14gwxuI/eCKLwRLYgtbNSRYJnHAM8bhJmk=;
	b=HYozRe/+tthHkr34qYZav1L/g2mvTnlY+ckd8R13ZeiDPcAmo86ryRoPa5JVCUk/x2X3wx
	cueJmGw3FcDA4+mgWmUd3+fZpGVUSSz/8IsHkysG5MIYXlgpnr/ePfXmud605aZ1j3x4Zv
	y89YbHuIv8k5yE7kwDxeTE69FmXGVIs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1222B3462A;
	Wed, 29 Oct 2025 20:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761768406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3rh6Q8jxv14gwxuI/eCKLwRLYgtbNSRYJnHAM8bhJmk=;
	b=r1GcIp4EfqzWgdRP4+oIS0Oge6Ly9rFUpR8SQlvisOyPGvchg6VpNvFZFV8lu5IqsYIJV3
	2M7OQjXrao3QlWWWJeuhofpTxsboM8Duf/ir2NX7kHktEWzXxkaSms/igqvACccTAv1nci
	ZgAOY17OWmtJrrKtvaoIaUL3DlWF7Vg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761768406;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3rh6Q8jxv14gwxuI/eCKLwRLYgtbNSRYJnHAM8bhJmk=;
	b=NPTkSb3CrRC6pTChYM0qRvp5Vgy0s/MaDwWuFJv2noW7ty/2UqG1CvTkZ0W6ScWrQoC7Ba
	JIIslf1wCROsurDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761768406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3rh6Q8jxv14gwxuI/eCKLwRLYgtbNSRYJnHAM8bhJmk=;
	b=r1GcIp4EfqzWgdRP4+oIS0Oge6Ly9rFUpR8SQlvisOyPGvchg6VpNvFZFV8lu5IqsYIJV3
	2M7OQjXrao3QlWWWJeuhofpTxsboM8Duf/ir2NX7kHktEWzXxkaSms/igqvACccTAv1nci
	ZgAOY17OWmtJrrKtvaoIaUL3DlWF7Vg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761768406;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3rh6Q8jxv14gwxuI/eCKLwRLYgtbNSRYJnHAM8bhJmk=;
	b=NPTkSb3CrRC6pTChYM0qRvp5Vgy0s/MaDwWuFJv2noW7ty/2UqG1CvTkZ0W6ScWrQoC7Ba
	JIIslf1wCROsurDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DFDD61349D;
	Wed, 29 Oct 2025 20:06:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i05ANtVzAmn6fQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 20:06:45 +0000
Message-ID: <3b6178b4-ee0b-46b1-b83e-15a0dadda97c@suse.cz>
Date: Wed, 29 Oct 2025 21:06:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 08/19] slab: handle kmalloc sheaves bootstrap
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-8-6ffa2c9941c0@suse.cz>
 <aP8NMX48FLn8FPZD@hyeyoo> <982967fc-5636-46dc-83a1-ed3f4d98c8ae@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <982967fc-5636-46dc-83a1-ed3f4d98c8ae@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xn9fptxiaiygqcjbucy9kann3dt7sch6
X-Rspamd-Queue-Id: 55715160008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761768407-757577
X-HE-Meta: U2FsdGVkX19b6q24zFxUHRrJsXChse7RVS9sFGlldQfGQhoNEgsEK0bMb/Zj4oJ/jj8HKannbutspQsCXS+ft/8YNbi3obu+EO9u4KuLEP//9W42xHvbIQ4khBA32V/cHd/3SOVeNauoFj7qNskv8LPDc2cfwugxWR83L0J5+k7qOTGfd0h3sbQenAyBBQb2USWas880wOJzWEoAVYCaGLROGgKiBg41TONBhHG8R52usIM+EW/+HEWrboWfxj9WkYphXRtuAZIC9wZ4/USRQlEZR/wXNpBz7UCi1a9AapOBU7YyDY+jlCUUQK6BBv+49Ec82hu0iG/GfpUuM4xoDX+doGePMNbybBn5MRemC1yQauSose/GGQVu//05/62ZZurHIlYt4GGdoX9KOsuS8k+d1NQeIFCQPYome708tUD4pQzQPwL4Y4XPH0h97GVBGP/1w15k3eSJmx9azLdIdHaIk5at6RDfbBBZsL/JOU3WVo48tCSdK0V4eCjB5D+cAJlbnSr0kFOPwtDGg9PDGjbamAua9FfBoFJss9C2eyeC0YDTqjhU02LWdZIMGJUVTo0hH9hPuFA5SurE8wwEHDHH+ktaoxKDTOc6vdUej9H+eKaptuP08twaR9gKzc38QmTr506avux2YcQiOg2mYuWWE59hrkxmKw8YMVlehp4C75gZHAJzI0+z2WwRqSjGF00MIdRt65ceH2yGFadaGmtF1JRNUD+BSmwzy9R2/MzHihC81vqYGQ/IpbTgZ6VCFccoz4SCJk8742vamPd/J5NRsqvZEGXF4MZYWj86Idd1K89YFeTqP0MrrWAXqgmgHQbt24x29sGW13nP0sbqs1ZR2BW5mvuSHhVtwj3ir0DEAkqxjZ9la6lRsx9l1oOhGNr6PgoASntMerXhfYce+/cLKvGc1FDJTOpTeQ+U73rlnd3pn+iOhEC6GvDHwF7qEiwzXenHDGAfK4Vy5Tr
 +wb03U5H
 w7/oqqrmqEklYpNsm7kgTSH/P2M8laIPX4ZPIm7fF5In6YyZACFqz7HYTYIZWeRfeJ5BVXQVUbBrDH9fJQwSlYKHMx3NooxRZVu/xi9ATE+p1dnYTOWwRomGFMhOwad1Qo49wB8e8U88ep8qebMRkWzXCILSnDpf3SCTk/f5fYMD4BHFByEIt/vTqn5nh4D561M7j7Y7yv/Pbp7ryTAodXoHrbzKqpOZiAOReyY12cxRqR/fUvFbQelgrKnyEV17VOGurCJxNLGt2mW+wCNLzMuW4DXFlr/GVul8C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/29/25 21:06, Vlastimil Babka wrote:
> On 10/27/25 07:12, Harry Yoo wrote:
>>> @@ -8549,6 +8559,74 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
>>>  	return s;
>>>  }
>>>  
>>> +/*
>>> + * Finish the sheaves initialization done normally by init_percpu_sheaves() and
>>> + * init_kmem_cache_nodes(). For normal kmalloc caches we have to bootstrap it
>>> + * since sheaves and barns are allocated by kmalloc.
>>> + */
>>> +static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
>>> +{
>>> +	struct kmem_cache_args empty_args = {};
>>> +	unsigned int capacity;
>>> +	bool failed = false;
>>> +	int node, cpu;
>>> +
>>> +	capacity = calculate_sheaf_capacity(s, &empty_args);
>>> +
>>> +	/* capacity can be 0 due to debugging or SLUB_TINY */
>>> +	if (!capacity)
>>> +		return;
>> 
>> I think pcs->main should still be !NULL in this case?
> 
> It will remain to be set to bootstrap_sheaf, and with s->sheaf_capacity

... s->sheaf_capacity remaining 0

> things will continue to work.


