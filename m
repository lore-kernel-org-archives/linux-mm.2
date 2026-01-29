Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9310CD358F7
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 10:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B6F6B0088; Thu, 29 Jan 2026 05:39:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033096B0089; Thu, 29 Jan 2026 05:39:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81176B008A; Thu, 29 Jan 2026 05:39:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D42256B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 05:39:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 568F95BD56
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:39:09 +0000 (UTC)
X-FDA: 84384654018.02.4111004
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id D99461C000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:39:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3IbYcPNx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nU3Ocmfa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3IbYcPNx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nU3Ocmfa;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769683147; a=rsa-sha256;
	cv=none;
	b=s6aDsar2cY57Pg+3gw24a36xD22+flqP8gckM4qF5LjbhreM85yWl28Rl2JZwgSZwlTNDB
	qwb8AUCaPadGXLhUU7sxRG72MG+ga07WeGjOaS7LW4NasUrLYX8CMCoW3OeC5UiYoA9l0m
	8cOfBAKi0zfFAT/xN254sUKa0gFoq4I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3IbYcPNx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nU3Ocmfa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3IbYcPNx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nU3Ocmfa;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769683147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYnsIXZ5zxZJH8iYP+5LzKA2WENDjPHg4mNO2xeQQz4=;
	b=1i1LXEqn4Sh3bDM4lw5RzgewvqTGg5KbAfmhY0D/dr5dBdpgiOJbQcmGE3rfFg1f9kXRWK
	lSAXlyiUExrIaTIG8L/K2IR9t+PtRQuDUsiwDE2PAnUNzdLxbgSSqVBPf6/i8HeNdQHu0W
	F9fRDLGJTlAop2gL8bzxZ2RcKW56SE8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3439334124;
	Thu, 29 Jan 2026 10:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769683145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kYnsIXZ5zxZJH8iYP+5LzKA2WENDjPHg4mNO2xeQQz4=;
	b=3IbYcPNx+GISmxEddQ52E9CdI175py8uGvDDmhsZlUYEW1leaDWPsA1tLItcN9wO3mUYbl
	Vqdh00xlfOJcp2wOefGmm/vF0X8XZOew5Om0EhOM3L0ffBKy4NBovTumoZ6fYW3Xq0X+d+
	uK3Xc7tJ6BO8GDX89kaSvz4S2ulVuZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769683145;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kYnsIXZ5zxZJH8iYP+5LzKA2WENDjPHg4mNO2xeQQz4=;
	b=nU3Ocmfav0Fi6R72Tz1fYtu6anX1C8aY43Q1wyfURcMBPAwSkX+1GZYh4rdRZd9VLlUamw
	fj5MO7imU2VU2cBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769683145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kYnsIXZ5zxZJH8iYP+5LzKA2WENDjPHg4mNO2xeQQz4=;
	b=3IbYcPNx+GISmxEddQ52E9CdI175py8uGvDDmhsZlUYEW1leaDWPsA1tLItcN9wO3mUYbl
	Vqdh00xlfOJcp2wOefGmm/vF0X8XZOew5Om0EhOM3L0ffBKy4NBovTumoZ6fYW3Xq0X+d+
	uK3Xc7tJ6BO8GDX89kaSvz4S2ulVuZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769683145;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kYnsIXZ5zxZJH8iYP+5LzKA2WENDjPHg4mNO2xeQQz4=;
	b=nU3Ocmfav0Fi6R72Tz1fYtu6anX1C8aY43Q1wyfURcMBPAwSkX+1GZYh4rdRZd9VLlUamw
	fj5MO7imU2VU2cBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0903D3EA61;
	Thu, 29 Jan 2026 10:39:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2t7NAck4e2lNcQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 29 Jan 2026 10:39:05 +0000
Message-ID: <00e257f0-d80d-408e-963c-7962a1cef9d8@suse.cz>
Date: Thu, 29 Jan 2026 11:39:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: avoid list_lock contention from
 __refill_objects_any()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
References: <20260129-b4-refill_any_trylock-v1-1-de7420b25840@suse.cz>
 <r4sorjw4p62mk2pvnjfrfx2w3zmwcz5yuflmcewll3jsmpju42@dniauu6pkm6j>
 <aXsoxRXloFrvmOEL@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXsoxRXloFrvmOEL@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D99461C000C
X-Stat-Signature: siyr31z8g767t9otk93cigxmyeite75f
X-HE-Tag: 1769683146-68017
X-HE-Meta: U2FsdGVkX181AuYh0BfoCZSWnnNJ9WClcm9GTUJxi9riq5lSn+KN6FTa0N8eKa2eXPVzzTu6G2Lv1ZkURH3EZO+oOIcYFf8bjqdJxmgOcMftz/FC0uMAFKCyi1QgpqsBKnrl0hnI7fADStzgpdrfZDO9xtf+sq7RufMk/E8bQRpmXxmRSGzX3c3UmrRqp+DTIVJG5U9eXcMc0GxYAovfxWvqq1McdhKSw6ULH9rs0v6gqssxGuOlT2VmgyuwINfA7A6f3LiEcNkcGSMx/GEfRfLRu20ONpYnWo2Jk3Ov5YP9usiExZ5wm6ZQND/2wG2NUtHcQ1tAwkpJ2RHypWmNsKGzZsPqwcUA6FIJDtirXPEd7CoJjQlrfQrVTnr6mTpYoJjZwzxCX+bf286jybfYjitoO/n0KDfOqQAb9TosX8H7cfdUJCtDdKeihkqVqHRHOw4kjSRKPNlawgEJjlzsD2INPbTyUOwZXRfTUb5YxgX/inDCVWaCpm6VQietHDpjdSFnWQ6yW1UHwTkeHLC2bnNawhLr31XnM6QMxaCpY3QRXqE45lYJHZgJBVM3dNOCJ1PKSAFYzQ62rWHerDfok2rUrSIT8CMFXsAAMK0hsw+5rhZKuJr/+g2gKXPjSsNWAHQMbDR/er5MyemGxGAzdG5HE3xa10pQz30mHRsKHR52sdYbHAqJU5ww2yTBycF4YhrmvX6QmlpQUWwCh/VLmMqgnZu2OTV4/IGdQlldXj5mIiLOargW85Z0+b1vUvxD9oWEcPOCJrbQzHoKT+lQB37YuZQ3EHioiqX3bIRbP5OarvAWbfkyY7JebsXywp0Pd0anYSqYb/Ir4Cd4E2A0oeArgsMjokzKOW7w/AmezONt9sysK394K1YGznqQL8DLxA/3Vbh/JfP8dCQiM4p3/Fdpoe6iEv+f0crsiuUQCVKowOlg6Sj5wort2UCqFHfEZVw+cwiX9QCnPCxnLpi
 UIN4RJYW
 05qDcV9Djdx4OBVIWUf4SZHDHEb+TIUmiIjOca4HNZxsHV66xGjAz5I22NkzSRB1t6oqz6sX6M7dUDk0En7tk6rXjROOEokBHgxDtX6B48fb/IXdKAHGl9C7G6XiBkM9B2uF+/vLXil1vxE60KvKi1b6fHEYwRZS5f+74umxzGgm/oCYQBAYua6d1D9xntWVfCeBAdkBMQdMUoYD49P3MlWCOQXt0VHwYATPX8bSMjtikFvLJDXYqf8cNDxcS3IhSPukjOTiRBpAEYbG5wJZzJltOLSPaybvgzHWcUFrKNAvbHb96aPv+viXvcJK3e9Bs4FWwoKgZs4gvexmi6xYJKkMhSh8dpqzVWE09Mh6aNjRQ2YAat5nYxPkFlee6BJbmPRZI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/26 10:30, Harry Yoo wrote:
> On Thu, Jan 29, 2026 at 05:21:21PM +0800, Hao Li wrote:
>> On Thu, Jan 29, 2026 at 10:07:57AM +0100, Vlastimil Babka wrote:
>> > Kernel test robot has reported a regression in the patch "slab: refill
>> > sheaves from all nodes". When taken in isolation like this, there is
>> > indeed a tradeoff - we prefer to use remote objects prior to allocating
>> > new local slabs. It is replicating a behavior that existed before
>> > sheaves for replenishing cpu (partial) slabs - now called
>> > get_from_any_partial() to allocate a single object.
>> > 
>> > So the possibility of allocating remote objects is intended even if
>> > remote accesses are then slower. But the profiles in the report also
>> > suggested a contention on the list_lock spinlock. And that's something
>> > we can try to avoid without much tradeoff - if someone else has the
>> > spin_lock, it's more likely they are allocating from the node than
>> > freeing to it, so we can skip it even if it means allocating a new local
>> > slab - contributing to that lock's contention isn't worth it. It should
>> > not result in partial slabs accumulating on the remote node.
>> > 
>> > Thus add an allow_spin parameter to __refill_objects_node() and
>> > get_partial_node_bulk() to make the attempts from __refill_objects_any()
>> > use only a trylock.
>> > 
>> > Reported-by: kernel test robot <oliver.sang@intel.com>
>> > Link: https://lore.kernel.org/oe-lkp/202601132136.77efd6d7-lkp@intel.com
>> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> 
>> In my testing, this patch improved performance by:
>> 
>> will-it-scale.64.processes +14.2%
>> will-it-scale.128.processes +9.6%
>> will-it-scale.192.processes +10.8%
>> will-it-scale.per_process_ops +11.6%
>>
>> Tested-by: Hao Li <hao.li@linux.dev>
> 
> I wonder if using spin_is_contended() or spin_is_locked()
> would be better than trylock by avoiding an atomic operation?

I checked and found that spin_trylock() itself implements a non-atomic check
before the atomic. So adding a spin_is_locked() would only help the caller
bail out a bit faster, but this is not a fastpath. It wouldn't help the
cache coherency traffic, AFAIU.

