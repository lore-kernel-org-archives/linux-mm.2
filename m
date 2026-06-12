Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F0ECD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813AA6B0005; Fri, 12 Jun 2026 06:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C41E6B0088; Fri, 12 Jun 2026 06:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2D16B008C; Fri, 12 Jun 2026 06:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4676B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:05:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07F0B1203A1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:05:36 +0000 (UTC)
X-FDA: 84870828672.10.A118D3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4CE3E120005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:05:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nT8uaQMO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781258734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb+VaCQXF02BSPuZ+ctVy3j3cdU9RPguQO6IfgOy60Q=;
	b=k1iq6YQ4dpLEa1vLwFiKf504QaD2HMjpq9FkVUvyWsv4pmto7T96SB2mW8QqgVpoALVjSK
	skpGKxXGe5NuwTPriEi9k089lUS58So0AJH8f0sAq3u8czTf1PYsRLybPTNjB6/kKHmj6k
	8KTlMph5XKxfbfONZiKPxDylQWldz8M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nT8uaQMO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781258734;
	b=f/1iGdnBzlOFvWCgqpClXwh6D6C4EoYgQCXoxmsUZJQ2qYiPlQGODN1yiYQYD9vAgwH+Vq
	FRD3fr8qIMB1bNQauGsQ+Oylll/RfCUGxCrp+6tas8TYZLiMDRGdfJ8lApE0rnoe959nch
	jejKUy5xUBvTON/vG11ArHPKM9LIaGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55772419BD;
	Fri, 12 Jun 2026 10:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81541F000E9;
	Fri, 12 Jun 2026 10:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781258733;
	bh=yb+VaCQXF02BSPuZ+ctVy3j3cdU9RPguQO6IfgOy60Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nT8uaQMODLhBUxROHjXuRd0ltnQkV8xcMmqUgop177jA4Q+qzhzcb7muBVmGixoTP
	 8p5MM0H4e5+w0xuRc4XmqqID7AuqsXZfUSVh5EXViPm/AAGN08YTt4BXKo01vjLqap
	 y1VHj3PBkZgrrEqAX3vB5we/5Ky0EAj6c94Tly7tR4rCUT9TbNDw/P84YpJ0h7KysQ
	 sg2dDeozJRAbzXf50kjbC8Fp6Q/LuT3OyA+NFO118CfUAPNnbUNKIKON2Kv9Kh6DuN
	 Cow79yOO6yBznJkQotV4LDWWuVTuYqQIHy/HSG1+ag4iVFBOZ/RCPougGXdiQpdFm7
	 aGVyn4nbo9I+g==
Message-ID: <3f53fc18-838f-44ab-acad-4323daa0fbcc@kernel.org>
Date: Fri, 12 Jun 2026 12:05:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/16] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-11-7190909db118@kernel.org>
 <ait6ojueVi38-s85@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ait6ojueVi38-s85@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: r3p3jxtd9tjwfei96o1un145ixwxncog
X-Rspamd-Queue-Id: 4CE3E120005
X-HE-Tag: 1781258734-964755
X-HE-Meta: U2FsdGVkX1+iX8AqPIrVs0nYfRkxvfd+n7jxiywB7HMThjUrw4YvsZJ5bcatCIGu4f0L6cXFyL6KxPUizu2ByRELqDmLuIcTbDpB4l5hPBMI1HkeDGnOujV5nbl9dLyxES01P8eUhCPF0K+tKwWTU3geSvo5mPN0urvuTtOW//E7N10MY64qkoyrduQEjtdOxysW7v14YrLAl3TCY4cfAM9mJZWXiPShToCwZBKcn5UUuVNHKW66tVJUgT67eX9YW0oMYOFDiB0zojYGblY4ww3D5K7bBBxsNRVZndXCRsGvJnH8KK25yYxplgNYBX0+/D4hkJXCmsDt1EN4507IktB1mzWBXdkw1WbOL5B8jAluFesVNeCkmMDa9J22AZWhFrfVkshoQWinFi+cs/Bkd++vkCiGz0hYpsguNhnZWlWk0fEwr++ON1qVl0Cgs5wa20WGhQoRsSab0BIGianYXIVNTl3dyMBXrSeUsOuNrtQcaFUoiGnZGdo4qI8/tdaG01lI7FM9HRlPmVw9S0y2fKqafduBO09hrXWusFbUSSfogKfu0I0ybCk6DUZOfgdMoyJYRg81uuKIVcSzOy3ZRwQPNGP41uiJ4Nu4sLNT0n8gC73lL2n0ZukmPIZHXaPebw7ktjjeNX7/OLUlAMaOLSVwnf8Nzfqz+MkaJ8FzYODcy/Hl6OAlDB2v90pX7Yc6kf58YkXFwrZbhh4/ozTxzs2qAVprYpqwWcAXSsXtlYNJPKjP2Cd8KjzqZIPvCe10J4pMKrHzvAWZ3AL24GO3e7FwqQAXgz5ybpBShsOu+tYF1VSBzAdmB3rNILE5qiIFh4G89XXDqxsNlG3xx1XrJPBTgT5mKhKdVc0Kv+g5n/c4hcE8Lp6eHqeK44jgBNx9dJrjywoc3Jlg3OrGjbNJf6OuHHTW6D7fuPkpDMpYUcH4iDZsdy16Mt7WivxbH3UvQ5hbj8QQkm9G04sLuAy
 pL+tqHu0
 QPY5tderS9oYFTzgbHWcgRTNxp0P9DMqIAsOJhrQ882ybglsedRUgkCNX7hwv0CEjZ1EL9ZpPCqOYX9q9WtDLC94Ht6C4YiG9W/N3cxLJhuFO/Twd7kJYsbslv1+nWp5wCHVUL1o0/kQS14qZbr3odjZ85OFzHNP6Z4yyhKG1eJoHKb1gaU58YgmJPUhr41rJu8bSgHY47vnsY5PQbNxpIwXA5jRZyyV43zl1chmDwOLAJRUTiWhnJKjWK3F+c76QwN9Iifci+OWjlrbvmtnrNjYWzOvamQa4pKJI5hpCh7+xMC9CSCB9GYFYoXeW7JqCJqRKGqEA/PUvvnc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 05:21, Hao Li wrote:
> On Wed, Jun 10, 2026 at 05:40:13PM +0200, Vlastimil Babka (SUSE) wrote:
>> The last user of gfpflags_allow_spinning() in slab is
>> alloc_from_pcs_bulk(), which is only called from
>> kmem_cache_alloc_bulk().
>> 
>> It turns out that gfpflags_allow_spinning() is not necessary, because
>> kmem_cache_alloc_bulk() is only expected to be called from context that
>> does allow spinning, so simply replace it with 'true'.
>> 
>> With that, we can remove the "@flags must allow spinning" part of the
>> kernel doc, as there is no more connection to the gfp flags in the slab
>> implementation.
>> 
>> Also remove a comment in alloc_slab_obj_exts() because there should be
>> no more false positives possible due to gfp_allowed_mask during early
>> boot.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slub.c | 11 ++---------
>>  1 file changed, 2 insertions(+), 9 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 0b9974bfcb24..ef457e07db83 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2171,12 +2171,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>  
>>  	sz = obj_exts_alloc_size(s, slab, gfp);
>>  
>> -	/*
>> -	 * Note that allow_spin may be false during early boot and its
>> -	 * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
>> -	 * architectures with cmpxchg16b, early obj_exts will be missing for
>> -	 * very early allocations on those.
>> -	 */
>>  	if (unlikely(!allow_spin))
>>  		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
>>  				     slab_nid(slab));
>> @@ -4867,7 +4861,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
>>  		}
>>  
>>  		full = barn_replace_empty_sheaf(barn, pcs->main,
>> -						gfpflags_allow_spinning(gfp));
>> +						/* allow_spin = */ true);
> 
> we can remove the `gfp` arg as this function no longer use it.

True, done!


