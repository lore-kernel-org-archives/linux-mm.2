Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BF9CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 08:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6191F8E000D; Tue,  7 Oct 2025 04:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F41D8E0005; Tue,  7 Oct 2025 04:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7968E000D; Tue,  7 Oct 2025 04:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8A658E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:03:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61CCF14083C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:03:08 +0000 (UTC)
X-FDA: 83970577656.21.0C286A8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9A3B1C0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:03:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0v4Uq8qV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="aM7fIy/N";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0v4Uq8qV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="aM7fIy/N";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759824186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmu0jNa2/LllNseazk+8f4BK8o7kNGrbiuBCDc9lhw8=;
	b=ptL/vz9B3dnBVHj2jXjjghYZi9tN4osEzjyue6JrZlfzRnBsjmSAdv1JlKWPRJiMvBjx2M
	gfeGFQN/lwSDgYmBiIhPgFfAOOAfRggBaxZu17rvRax/twDrhZGvkAGgC7RzMZTz1Br3wW
	QHXUhhfLoyhStfD8o+lQmc80bAcNsro=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0v4Uq8qV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="aM7fIy/N";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0v4Uq8qV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="aM7fIy/N";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759824186; a=rsa-sha256;
	cv=none;
	b=D9UowJUHskwTFLHlYUloZ3ypy7AfUuhEcBstokjTTJI7EuSIgZ/OYW6Hx+bu2bHdM0H8ym
	9Uy6AfhtOTDIApZCTv9Z0AlRkrvfFNH0N2+fShQazbElO+uOQqENooLCvO5Z47PCg4kzU9
	mxceSvZEnXQRWV9QXEF2f+AhxztXF0A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B031336EA;
	Tue,  7 Oct 2025 08:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759824184; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wmu0jNa2/LllNseazk+8f4BK8o7kNGrbiuBCDc9lhw8=;
	b=0v4Uq8qVqdpyIQTXWZMhi0xiuOHfNdqD2KhHikwNTITCGtnw3/FAXugEkhTAy5I98g7mqv
	cii9qW8TMpCeS9mGner0atKe35oFbS3+TP1cD8g1T427rWUzh3OeBynhg6UbAZTWj0zIqj
	vRxGjG8cpMLnzv/DXWBkN8tX3w7xBRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759824184;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wmu0jNa2/LllNseazk+8f4BK8o7kNGrbiuBCDc9lhw8=;
	b=aM7fIy/NK/MQR3O1zzSWlghajImgM+GAw8VkUdZsltf6m06mOctZK8IY9BqtYPYKWpGUT2
	WKFGNdGfMI3lxjAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759824184; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wmu0jNa2/LllNseazk+8f4BK8o7kNGrbiuBCDc9lhw8=;
	b=0v4Uq8qVqdpyIQTXWZMhi0xiuOHfNdqD2KhHikwNTITCGtnw3/FAXugEkhTAy5I98g7mqv
	cii9qW8TMpCeS9mGner0atKe35oFbS3+TP1cD8g1T427rWUzh3OeBynhg6UbAZTWj0zIqj
	vRxGjG8cpMLnzv/DXWBkN8tX3w7xBRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759824184;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wmu0jNa2/LllNseazk+8f4BK8o7kNGrbiuBCDc9lhw8=;
	b=aM7fIy/NK/MQR3O1zzSWlghajImgM+GAw8VkUdZsltf6m06mOctZK8IY9BqtYPYKWpGUT2
	WKFGNdGfMI3lxjAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DEF813AAC;
	Tue,  7 Oct 2025 08:03:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z8NYEjjJ5GiCMwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 07 Oct 2025 08:03:04 +0000
Message-ID: <c750ab62-a3d4-422e-ac5b-c531dfcc749d@suse.cz>
Date: Tue, 7 Oct 2025 10:03:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/23] SLUB percpu sheaves
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Qianfeng Rong <rongqianfeng@vivo.com>, Wei Yang <richard.weiyang@gmail.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 WangYuli <wangyuli@uniontech.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <aOS0Z5N4HaBNeb_J@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aOS0Z5N4HaBNeb_J@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E9A3B1C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: ttqjya9itufdxpichgj7ertziu81o5ap
X-HE-Tag: 1759824185-367233
X-HE-Meta: U2FsdGVkX18K4WPYJQ+orOuu4TPEu3Azd1kzexd2YAPxBSGP3Y0EhOJLAAEkWUkQ6a92Uls0PeoXdZ09DXZKm6pW0XLGGqrTfoyJruimP3FZVKc8nFaVjDNpiRin5Pk2VDNPi7iuyhG4GE6ZaPsiG+cFEvdpGpXh8BEcnyTeV3PdS+UZ7PTaEwYc8SoNqE2cAAgvHbx5EQ/gYLRjUWOCaugfWv+h6b4JHI+pTE5g9gzO+ZQfkZKjEWFtNk9ZZDokNjpxQX6WscYos3GxJHv0CPESinvpwxjduUku5hetMFSzB0AlSq2BJlAFPZduTujW42WPe3hEFjXE3e1vmbjDum7tUV7BPrsCqh+nP4Ec6EOqAqBs7B7/2lGIQeEfKm4RnaTNbfy07kTAuFuwpCrvJa1c5+KuYQk+v4P7+H3keKOYXtzYIN+3YLqAU6nMUmW3RhF5k/airgOqb7rS7UBlyPw9PCeA/Wf1Nleam3mZN84tyLJmAhFZuxOfxxfl/0pl3bMoCd2CwaAdD1fjSD1Uj1RkF+jT8HU5uNMgC6Dx1puhMu0h4aV2QnkgXGhiC8ZXqUB7p6CfUQk0NafOiE0x7sPK4SuL4MCy7u19Znzj2fafSvHYOXbA+z7ocVdnrP5GXQc0ZLLSkguYscFhGQUEHza46sdn9jmKWCnz7eQXqY1ZztIlcqVXM7x/ZaFGD9FDBQkXhR5snnILrfKSEFBs7mPHQo0sc6OD6kfi9+lWaypdSWj2mCZpNtPtl1YOHAGORy2Dp4JnipU2Iig/aHTW+lWKEw5Y80Vt/dGC723j50GYZJ30Fl8YQrktQx9iPwJGa1plaX6nuZRzNG5rtGDiRLWIIZP7pPBg6dT3zgA69qj9yGndJMHc7rK3Udn3Sw/paejljdsUmVB0cGFpsVy5fpKslzrvKCc6XmYUCtzuthlmaxms5gZYJMNbEnREm1h2S5igjyK812wmQn0nWFo
 C3zmT+YM
 +3XSKscsbyE+8YI7BZmcBznW534OfpsylTHwyNBfk2JBLsBKpUhRLHuy1R6tfG4SSheXeI6iF3cY0mWjfyMgybCznpGYgaq+VLf5jzdh1x+Sg0Xjl/Vzh56UOkRDacp+dbQIeTSnlTBfUqRFDtI40xdignYyry0mHOWQv6e/FO6JcvRtzLXFb3UaetvMN5YX2nUbmH/RXLZ6Nj5VxWGjjRFri1xzG9uEVgiob3+gLfUwZvpvEaJ7XcDKUckaXNjMCEEg0JLN/3pBA22cxzUJxY84zo27m8SQScHJEI7rBgQL+BAMTGD9qAK0jgwfwi5SENJa9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/7/25 08:34, Christoph Hellwig wrote:
> On Wed, Sep 10, 2025 at 10:01:02AM +0200, Vlastimil Babka wrote:
>> Hi,
>> 
>> I'm sending full v8 due to more changes in the middle of the series that
>> resulted in later patches being fixed up due to conflicts (details in
>> the changelog below).
>> The v8 will replace+extend the v7 in slab/for-next.
> 
> So I've been reading through this and wonder how the preallocation
> using shaves is to be used.  Do you have example code for that
> somewhere?

Maple tree uses this but through its internal layers it's not super clear.

Basically it's for situations where you have an upper bound on the objects
you might need to allocate in some restricted context where you can't fail
but also can't reclaim etc. The steps are:

- kmem_cache_create() with kmem_cache_args.sheaf_capacity to be enough for
any reasonable upper bounds you might need (but also at least e.g. 32 to get
the performance effect of sheaves in general - this will be autotuned in the
followup work). If there's a possibility you might need more than this
capacity in some rare cases, it's fine, just will be slower when it happens.

- kmem_cache_prefill_sheaf() with size being your upper bound for the
following critical section operation, you might get more but not less if
that succeeds

(enter critical section)

- kmem_cache_alloc_from_sheaf(gfp, sheaf) - this is guaranteed to succeed as
many times as the size you requested in your prefill. gfp is there only for
__GFP_ZERO or __GFP_ACCOUNT, where the latter will breach the memcg limit
instead of failing

- kmem_cache_sheaf_size() tells you how much is left in the prefilled sheaf

(exit critical section)

- kmem_cache_return_sheaf() will return the sheaf with unused objects

later freeing the objects allocated via prefilled sheaf is done normally

- alternatively kmem_cache_refill_sheaf() for another round

The whole point compared to preallocation via bulk alloc/bulk free is if you
have a large upper bound for some corner case but only need few objects
typically, this way will be more effective on average.

If you preallocate and know you will use everything, you can keep using
kmem_cache_alloc_bulk() and this won't give you extra benefits.







