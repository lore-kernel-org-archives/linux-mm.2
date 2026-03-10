Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114CAF3C27D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700C06B0096; Tue, 10 Mar 2026 06:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE336B0099; Tue, 10 Mar 2026 06:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5901D6B009B; Tue, 10 Mar 2026 06:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4941D6B0096
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:06:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 02D5A1C654
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:06:50 +0000 (UTC)
X-FDA: 84529724622.28.D6F9D51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F531140018
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:06:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mffQwmEU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773137209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3ZUu7FBA7qSwWNNBlklUbAHrHkKS4yARxLagPs3Ehw=;
	b=xn7zW1E+Ncc5IsrN0GRqFyqP64Lwsk+kW0L1Ti2hINLqz195I+kDusgFHVFQVfHrp+jvRD
	/r4cDnxnJSpMgXXrZyg+jcPhSuXf+3dvfYcD9d3JoPi94ATXhNpecdxNsOSoDTM7pxT9kK
	bzc6iKyCELLULLi9aqobTTR57MrVyxE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mffQwmEU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773137209; a=rsa-sha256;
	cv=none;
	b=w3W8IkhLIJjftyjIS7jTnTf2cklnULOjRbHTuQWcT29DqNFncXlmdMLwiV4QDlSIGzQmEw
	xZDoL/tnMiHt01DejjaGrLirK5nY3DUPavIweVYRYZbvaP2xt68rymFcDk48bO6ViQVeEI
	d0CQh6BORigDN2Edz9+GfDjt2gxPFGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23D61402A9;
	Tue, 10 Mar 2026 10:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EF4C19423;
	Tue, 10 Mar 2026 10:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773137208;
	bh=W4CTub0Sa88sKKNCsV7akuk2L56fgLFSCEVuVsLi5N4=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=mffQwmEUr06v4k/y5Wr5pQqSjZjrr3p5wQsKp12EJx7cBlr2cCr+KXTspy1x0Rdhk
	 6TOCiBL89tbh/AEp9qlvqto4iIivLN/Dg6/zA9QZx9tP6EzutiQUE6WWV1Wzl9WUqQ
	 cfoJ986b8ifQjBR+0WqZa3y18URtV4iST9OLW6arc8PTOwTc8jMLb804uaJlz9e/8r
	 gmmCxhRShwL9bEFoUqqlEurRfx8/uugM52V2h20qIkYK55n/RD+iuWGC4cp6jdgIUp
	 CF6QrzDR/92ko7b/TcgATw438hSMtsHagIVeDTuUDj3VtP0qxaFtGHesoiuyxgwwki
	 c0tSgtW0pF2GA==
Message-ID: <a61a876d-6377-4e7a-9651-e0fc05819a72@kernel.org>
Date: Tue, 10 Mar 2026 11:06:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: vbabka@kernel.org
Subject: Re: [PATCH] mm/slab: fix an incorrect check in obj_exts_alloc_size()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: adilger.kernel@dilger.ca, akpm@linux-foundation.org,
 cgroups@vger.kernel.org, hannes@cmpxchg.org, hao.li@linux.dev,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, shicenci@gmail.com,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 viro@zeniv.linux.org.uk, surenb@google.com, stable@vger.kernel.org
References: <aa5NmA25QsFDMhof@hyeyoo>
 <20260309072219.22653-1-harry.yoo@oracle.com>
 <0a25d83b-c6ea-4230-a89d-1f496b91764c@kernel.org> <aa-PQBn5d0-U-sKg@hyeyoo>
In-Reply-To: <aa-PQBn5d0-U-sKg@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F531140018
X-Stat-Signature: 9xmj5f7kmebu3sispu8qd9jnpw9hjxsz
X-Rspam-User: 
X-HE-Tag: 1773137208-696548
X-HE-Meta: U2FsdGVkX186ZfobDjTJx8+IUZIFC+1qt/ZjywJvKKLV4nHPOTkD6o4XoLXWYZqkOjRJGlmoB4CQic1UNaYPzbcddMP55dT8TrAsOFAXk3ixAhVuMT9P70UXm0e7TCjHthTW1EUw3szYHVOia9H6XKewm5WDgSfPkQ/qWOBq2at9NlKmmaTR30cavJNwUdiSAlNCUpRfcvy0LrhbFeY+4RCUWzIpfkOD/29vJuVcRExN5/a8tUUdrtZB9BdSgCZiWycXxHFxEypORF8lnrngc6HC3JIq9ZGeILsiN+3X6XRuoS0sQStxgy3ftyNnDcuNpEPYr8yBOBXPzeGrKUNu3++9TsI/aKKdpvtjjailX9nBCkwzjXahpC/2YB+WoU/KWjhzWf34hI/eq7te01QXEwIagIxfA3QgtenuhQ6HbOEHBr/S8/s0gVRLn5Ql6kmNYfTYVzKLv5iwZfeGDcY2E6WfX4bpd+lhk87v49A55XpMvKcTsLgrMXDcfehrASBQC3fjtWxxMgvDQC5U0dcCfPPJKCygdyJFEyP47ePVj8Ig9WQ0e0hzKOmp1HmeUoOmEqDK4StOhDxlOGNH3bIZgrVW+w5A3QosMJ2o3a2JwzUhE0DpRB9ZcsRmi0q2Oq8rjDehhVzj2c3BiZG64u2vQXtgAzcnc7tJIglW7jpE2HsMSiPLnIQzKPI8Ue1ftEjMmI2dG5V88+hdnPH/pSLIy9oZ9zrghqQ7NhA23ejOGCW66rYrTSXkzBTzds/xuS4PGiIDSlmNwlhPRmSg8bYd9Xwa8qd+v3z0xBKuCzduFhpCh5cNVoT7o7bmZFM8/7Ns185M1o0wKZmtp+QOXE85ZBQgXtcYP1uIRQGDB8/KKoF8+/DJzdK1pRx7i+tldKNnxkvfLpAgqBCVjNYGEyKglp00RF0BitXZbUeSwNQSnCM2PnbZHl//fijjMZFhB3QOxTcSe7EL//YQ6dUvQ3F
 P70O0ksT
 JpQRsCB7wJgxxX+YPfNWOi9QpnTy7vvVGIfhPhqTmEu1n4YOEkwrAI4Q9FsICYXZbVdgGwTnApZBgUaQ4l6Dy1KH918gGoJhytfwS3H8aTKCuR5JxTJmC/0progPIBA+sknB0AuKwcRaBaUO5Ll4L8Dsd66wjoxU1t7cNdsCoG0O3P0tCN753F0TA24qK/1QfSX1WiSEeIVPOl5nw10QX26JNtHOrCI3Z8bk2HHLVWgkVipxbABzbddpQhDPYd49bBBxqNVPDNxIJEVOERbzpTMwQC7ynMfApA3hqAmS/eQqtY2CNzNohOvk9C3e/3xuxz4/Nk/UgqQ5AbSWFVVicmMnGggGkRvA5h6fNR8l0KzSc7x6E/hIDFBZ4ixtqDA1YT1Rg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 04:25, Harry Yoo wrote:
> On Mon, Mar 09, 2026 at 03:00:17PM +0100, vbabka@kernel.org wrote:
>> On 3/9/26 08:22, Harry Yoo wrote:
>> > obj_exts_alloc_size() prevents recursive allocation of slabobj_ext
>> > array from the same cache, to avoid creating slabs that are never freed.
>> > 
>> > There is one mistake that returns the original size when memory
>> > allocation profiling is disabled. The assumption was that
>> > memcg-triggered slabobj_ext allocation is always served from
>> > KMALLOC_CGROUP type. But this is wrong [1]: when the caller specifies
>> > both __GFP_RECLAIMABLE and __GFP_ACCOUNT with SLUB_TINY enabled, the
>> > allocation is served from normal kmalloc. This is because kmalloc_type()
>> > prioritizes __GFP_RECLAIMABLE over __GFP_ACCOUNT, and SLUB_TINY aliases
>> > KMALLOC_RECLAIM with KMALLOC_NORMAL.
>> 
>> Hm that's suboptimal (leads to sparsely used obj_exts in normal kmalloc
>> slabs) and maybe separately from this hotfix we could make sure that with
>> SLUB_TINY, __GFP_ACCOUNT is preferred going forward?
> 
> To be honest, I don't a have strong opinion on that.
> 
> Is grouping by mobility (for anti-fragmentation less) important on
> SLUB_TINY systems?

Yeah, that's why "KMALLOC_RECLAIM = KMALLOC_NORMAL" there. So prioritizing
__GFP_RECLAIMABLE does nothing there, it goes to the same kmalloc_normal
cache. It only results in ignoring KMALLOC_CGROUP.
(I think in practice SLUB_TINY systems wouldn't enabled CONFIG_MEMCG either,
so it's a low priority, but still logical imho).

>> > As a result, the recursion guard is bypassed and the problematic slabs
>> > can be created. Fix this by removing the mem_alloc_profiling_enabled()
>> > check entirely. The remaining is_kmalloc_normal() check is still
>> > sufficient to detect whether the cache is of KMALLOC_NORMAL type and
>> > avoid bumping the size if it's not.
>> > 
>> > Without SLUB_TINY, no functional change intended.
>> > With SLUB_TINY, allocations with __GFP_ACCOUNT|__GFP_RECLAIMABLE
>> > now allocate a larger array if the sizes equal.
>> > 
>> > Reported-by: Zw Tang <shicenci@gmail.com>
>> > Fixes: 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from its own slab")
>> > Closes: https://lore.kernel.org/linux-mm/CAPHJ_VKuMKSke8b11AZQw1PTSFN4n2C0gFxC6xGOG0ZLHgPmnA@mail.gmail.com
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>> 
>> Added to slab/for-next-fixes, thanks!
> 
> Thanks!
> 


