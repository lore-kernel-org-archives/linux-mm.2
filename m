Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF03E8538E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 18:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC206B0005; Fri,  3 Apr 2026 14:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD0D6B0088; Fri,  3 Apr 2026 14:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2D26B008A; Fri,  3 Apr 2026 14:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2D25A6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:29:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6C8B13B8D5
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:29:33 +0000 (UTC)
X-FDA: 84618082626.27.867F9EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 156844000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:29:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JFfoe+Od;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775240972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R454VoLw6DJXh4n5wKZhGkeuayF8+zdiVAOeU7+29qM=;
	b=6GFu6NMmIpMie+hC59YCbLr1hTPjTYAItSJxeLcnLJwnfvXS5oiAUNZB6Xdh0nEBzlkGcF
	TdpXJIrayuZEFOLWcJ9gxgzm6os7pttSwU0hdUVLyzsdKhUbK4QdQAS0WItD2ITf3Cfu3n
	c6kDMuihkvzwFFeJeJfUW/bUYdCp8V8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JFfoe+Od;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775240972; a=rsa-sha256;
	cv=none;
	b=cCsDaz7hcOfj8jDzNp2zN5gJHPy2rPZ5f43B9bCDQLByPBGByLLfA84Tk1hoDS2lqMobZf
	Kp9zcdB+zlq3Q/kkdX5yqFEcPDbDUlVbnlJGo6FzSoNIfpVQ8In8SV1ARSJQxT69VwWkZD
	tqP1RAb+4bvrG9/RhuXCsbGnSH0D658=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E35160008;
	Fri,  3 Apr 2026 18:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7854CC4CEF7;
	Fri,  3 Apr 2026 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775240971;
	bh=2LaCesgEqKearbmEy0CIdH1OxXGy3hFRgnwk7wdkISs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JFfoe+OdYtwOwBNifEpqm7IRcYHNx8GK/H/UXt4zENrJ40+pbi/suVM7tB5nwYUoz
	 43CneCDysSjvSJwT+97osxUozGqQ+k5rrR2f4w2qfF4s2/ynhOqo4sYElxPb4UicWQ
	 Cxamq9EAHCCoyEZydeL5mxRYYT6UjLxLmnLPyHwfsKR1qDviIVBuTYbLnjyXeef3pv
	 eOVagQAWx/m+AoA6Y8ONDtRjXtl8nMq62cTqwkYwaJAFUYDxK/FKCjy+W25DGNIwUH
	 s+We36PVVj6YWendwlyyYb0TQpiVfCOj+MvYwC5WWcCxerl2j/g3bwHB3jnNoFPC/W
	 fYMAxj+aKPE2A==
Message-ID: <d0fe363c-2e8f-44a4-9b64-3fa3ba9a5773@kernel.org>
Date: Fri, 3 Apr 2026 20:29:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>, Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 Andrey Konovalov <andreyknvl@gmail.com>, Florent Revest <revest@google.com>,
 GONG Ruiqi <gongruiqi@huaweicloud.com>, Jann Horn <jannh@google.com>,
 KP Singh <kpsingh@kernel.org>, Matteo Rizzo <matteorizzo@google.com>
References: <20260331111240.153913-1-elver@google.com>
 <ac9d5O5XehnXRc5A@hyeyoo>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ac9d5O5XehnXRc5A@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 156844000A
X-Stat-Signature: u8q89frcyazpodf4mrt39m8ssoyg8bsh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775240971-156151
X-HE-Meta: U2FsdGVkX1+hGrLQOnFHz4df+Lxkd/vaPMBHOpx+eh3Tx+LfCuMnSRWgjuG6ftejzvrX8gxz7mU4SYM1BcYkpRJe7K2aoS24qe6hA4InzwNdRqvngx5U9VZ/XUR1hAsl7c0s3Kdx3bVAYvX/KJOw0jyUg1+q6AlupWx6JjTnPZ6mdkh9O1j0qYwrVYQ/QNQ6oNfBQAV0hzH4N9Y6Bk6HAaFZXvQYUxECdqVAB9rvFzK1ub2rgeScEJ4/C7swG9k8WAIHOdHhxd5ssIL2jQH+0gVBDMOY9qhu6XkHmF0UjSag8ZeFRILLYr9Q5pRk2jAusIzBd/MxIBsugwss7H4GF+2nhm79TrJkNiO76sx42RJkKKKWnfFqnjR1ptNirOKF8Jb3fM28hvxSt2Y1RhC9fcqR3k9P8NjMqbikWzfTLEMLSc7YDG8Slwhap1pxCIX3s2QEZY+lGvCzgFKgtOL7jzrMFDzmd4IaE1EiTG6fKC4vM2CC+1ysqecjk/unjAAy9pqsWZnpdoB9posfxaoNryxMW+QUEm9iDLaf0+mZOaFc3pJYoIcDH7J196Bfo7fPHKrQeB7nijNZpJGaLzRqFB6jza1SAMiwm4Uv/8MHSU2ozVtIAiY/V3LeeOU7ICK0xYMGVDxKjzXADeiUzIBdAGZrjkyiDBpSf4dkAEAvFR7U1CS7cw9YS8puyk0hneKtmDgqtAoL+YXQEQrcdru+KSZZGzzvoGf9TiGWLmajoHRmopfnvuBs1i0FTObLHyWT1tVFhVaEGNZCiOBEqjVE5X6815MON86mFXy3Q5zZNPnrNrz8y5E5kNjxJap4T+jJQDWD3nW3oUBVVdfO31MDhbn1pd5N+rRlKMsavjLKgZLrNX2YHXNjWT8x4dl00TQPrfoZ8PCD6A4xve5dVCMx/3V9bYcbqJd+mC587osIoTem5OiodJ08EkGtl+SsnBWUNDeMqTiUvEnNVRnx6K5
 H0NHK9u6
 e0dpe84bKb/FdJ2DlJpCRYpggv3PjNCv3X4dFeilODf+Rr5+uWC0HYfm/Ewbhq3knpGSFzZxbUIwm2mgAyI2c9vGrCHOssBLs8QkCKvFeUs6VXG4xhwyyiHco2gb32g+HUAptzl2AzNuKCVAtIFfyWrG4pzcJy3easDjggheobtwrwE5s+JgBtJw2yp9eWjOR4Wmvjq0irq+PrnLPlL+Quend817Ym6NUppDy1pNaltcKLoY7AztOVvyOdHBXtQkU35zt/qp1r1h4NDWWppSBbFF8q+s9LGo1o+ICSfVJ+lwJ8Io=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/3/26 08:27, Harry Yoo (Oracle) wrote:
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 15a60b501b95..c0bf00ee6025 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -864,10 +877,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
>>   * with the exception of kunit tests
>>   */
>>  
>> -void *__kmalloc_noprof(size_t size, gfp_t flags)
>> +void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
>>  				__assume_kmalloc_alignment __alloc_size(1);
>>  
>> -void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
>> +void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
>>  				__assume_kmalloc_alignment __alloc_size(1);
> 
> So the @token parameter is unused when CONFIG_PARTITION_KMALLOC_CACHES is
> disabled but still increases the kernel size by a few kilobytes...
> but yeah I'm not sure if we can get avoid it without hurting readability.
> 
> Just saying. (does anybody care?)

Well we did care enough with CONFIG_SLAB_BUCKETS to hide the unused param
using DECL_BUCKET_PARAMS(), so maybe extend that idea?
I think it's not just kernel size, but increased register pressure etc.



