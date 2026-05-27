Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E976CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC296B0005; Wed, 27 May 2026 03:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACD76B008A; Wed, 27 May 2026 03:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B8B6B008C; Wed, 27 May 2026 03:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4479C6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:46:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEC49C1E43
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:46:16 +0000 (UTC)
X-FDA: 84812416752.30.B07A483
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1FF9A40006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:46:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g8bhvN/A";
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779867975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LymoYiSJKyOhOnWL+FiPi0qmRpCHWn/xxgUD36lM0Ik=;
	b=sbJjDbjY7Ob+p2/YpkBldGCpwlMlm2BddmeumW4r0v8TYdDYUAAP21nzT1kdUTjldLGx6E
	59vU8B0+CKC5vhXYRjGQAryibZdht7+O7ACFMGFuCtyK/EvH9lrL7NkMyog3bW/HWkYXkY
	VCASUE9f9aU0n8g4rXuh/EHqrKa983w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g8bhvN/A";
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779867975; a=rsa-sha256;
	cv=none;
	b=5l9HAtVIVtXlrieVH+FmI86aJKXyofK2wN5nSoqwN867+OTjM3fvXhZ07x34YfUYUYde8W
	OrWlIvbw0aE2IeEeYs7wgTd39aB+5cRvWL1eHSdAXmLRaBKLLKTgwUXrMRkO5Hplnyc7FC
	BbhBRFXIZ/Cvvb9T4IQ6zU+r2CxeE3o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B6FC600AB;
	Wed, 27 May 2026 07:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52F01F000E9;
	Wed, 27 May 2026 07:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779867974;
	bh=LymoYiSJKyOhOnWL+FiPi0qmRpCHWn/xxgUD36lM0Ik=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g8bhvN/AguMcQyVhhYGPm9LsBweTjDaFpCBckGfdJ5NGz1j+dZCXv/ou2jpQl/sk4
	 kF3IhhtgvNCOXgl2EYV1Nvss6xiTnlbrq8syhFQivbQesmU5ZcBKGiEcloQnKBTaYy
	 11aXpEqNDWfUSHH+q5QUg9B0s1Z4G3EiOBvs+quVnoiw+t8gEPYfpoiAZ7xfvVxRi0
	 +TgqXAVX8T9GKREE8IANyDtI1TnQyepfYDDJPqmJBA6KNTtDdX2ZcB5GDV4TaH4foe
	 t6S5iWV1fmTXGxmw2p+mlXLjS0ohZ5vXlnYWe9LER0G++02apjevPR9kjugTdZJXCg
	 YdTfqaQ8XIwng==
Message-ID: <f4a6fb8b-53b9-471f-a80d-7175515504fe@kernel.org>
Date: Wed, 27 May 2026 09:46:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: fix typo in sheaves comment
Content-Language: en-US
To: Wilson Zeng <cheng20011202@gmail.com>, harry@kernel.org
Cc: akpm@linux-foundation.org, hao.li@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260516164033.1566208-1-cheng20011202@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260516164033.1566208-1-cheng20011202@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1FF9A40006
X-Stat-Signature: b8bg9gm1xh8717ugr37uknxwf3amrskx
X-HE-Tag: 1779867974-183772
X-HE-Meta: U2FsdGVkX1+8H6O3EEpvqLZhUh+gmmyi5WNpeZbq+6YafjBxLPCTmPL+aWpdviIzi09oAopuY9oLyXRKb8pwx1gHpiX77iedccfavGKNVOA1OzrR+RpuK/oOHQxhrC8XNp1glG8NgKqjKKLKkf96PBJxlgxEv2wa8HCKKqe6vDdO598lso51TNqF9d5SpV7gKrcs3tYkuLZAUX7uy1EtzZTs4bzIhV+Qlz3SnUAGNiFX0+FOqmuKZ6oavhzQ0HI+e/WBmKjVE93qAPCXSd8i1qrindJzB59njfqvggotHo+MA5Lnpw2etkrQb4uq0xACzOqopdBUb9NcBQUPrJc8AliXhZKHfJeSPwW6oyEFWtazZ1JFxMNs5KqVZgirhfjt58HMFyMxQBo1YFt8cFFf/fZ/NPRA65KPzWWfY2hv4wtw6RFuefcMni3/sFhqSSfb7gpbmtRSkOUV4CkvOLacbsobp0zjr26DkMeruBC60faRCC4PD3nsNrB0KDIEOugqZBGUKirY7RP+zKb3o4yIKcOxkoWlu76j/ZYRDFOimO0KftSjn1NE82E1+lsC1Y4t+hd6kacguE+CXMW5rAmZFD4pQGOHl1ZXcMRzN9K244Oypj77wikdvU0EUPjVjyvE7myk04yLtQLxtbtvmZ5gPQg7NhH3qCpJUry+WJc0O59Wf+WqSqLZp4Yxa6x8X1M+IZvgkK+8FcDacahkMCXbFD82PEIJMadGmrJeIumZvnDC/QWXJFDrI+oePItYNY5nwoWD3a4sCo+qsunffAD9LkWNu800v2lLMeWNJzxII7eemwnmgpKQO/M2aE27e9iFMVwQbJpmVoklPDs8+36z/dcv1N1utyQTRFI7EBMAEmXdDt5lbjSdcyinTcPx3+vH/BNE9SQt6/sk37AyzTzFYInJG7YCSY75w36CFjIedFF51osgVbebpm62r4RgaY7qt7jrs1ICfog08Vhs4bL
 JVgVDwXh
 ziDkX//Lmp4rGRBYdPVHTWOvpj4zGzs2SsBc7X/N4wlvwMoq8/E2NhYdBv1DaAZupIFOrd/n5Sv8zdpl8G5HFPV6bUBYQZttUvdFKYKj9f07qjXcS8NZqH2NI1Nly8GPphh2T7RbCJ1+kd3Vg6JcCyhuVAyoweeTbs2gimxY2EtFCfgWj8A4HXeWEcZQEYrPHZweL90unGkg/Y9Nor2sQfe61SLOLZiuL8271l7Dlyv5i//BQrgNxKlFR22y8WoqBjXVLuaFjxmWzbVEm1XkHQ56aSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/16/26 18:40, Wilson Zeng wrote:
> Fix a typo in the comment describing oversize sheaves handling:
> "area" should be "are".
> 
> Signed-off-by: Wilson Zeng <cheng20011202@gmail.com>

Applied to slab/for-next, thanks!

> ---
>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 8f9004536729..686559479273 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5011,7 +5011,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
>  
>  		/*
>  		 * we do not need to care about pfmemalloc here because oversize
> -		 * sheaves area always flushed and freed when returned
> +		 * sheaves are always flushed and freed when returned
>  		 */
>  		if (!__kmem_cache_alloc_bulk(s, gfp, size,
>  					     &sheaf->objects[0])) {


