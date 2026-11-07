Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179F0606A330
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E/+7iNKI
Received: by kanga.kvack.org (Postfix)
	id 2B1F16B05B3; Sat,  7 Nov 2026 12:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262AD6B05B8; Sat,  7 Nov 2026 12:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178436B05B9; Sat,  7 Nov 2026 12:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC13B6B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:03:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81A971A03DA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:03:01 +0000 (UTC)
X-FDA: 85408942962.30.0F624CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id EFC5940003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:02:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/+7iNKI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794070980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mX/y4k2TVn6iq3BNEMGtb9KP33DM0c49ZsBCKXcWRg=;
	b=s99B6PLO7d34b/t2Y3rYIDqx4kYSY99llO9WYcKORK1uPNS/6AbHsY9yKrRudxdvjUhA2S
	JCPISWJGi9qOAqTQW5ry/KtN8xgMHHu8uaSVTnXbjpF+/TpGFiYbxz0RB3C3fX/dvYCDzN
	pjGmkbdfe1WxhsRKiwTDqtIPzdrK69U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794070980;
	b=izhjWPDl6G4jN8MhKq5X8e9BOcY0hhblN46vyUFQkWtwCcMR5sYRms1C1VropfXnR7qUcH
	+82lfFJiQhXuDjKq3KHi/gY/t7X2ocACd4zhuUEUA8k7m6XyXgFLTsA95io75S8XR+Z1zQ
	p5AAlKtFxBweWqVgTpue687VJQEOZhs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/+7iNKI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2843041E55;
	Sat,  7 Nov 2026 17:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F67C1F0089F;
	Sat,  7 Nov 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794070979;
	bh=0mX/y4k2TVn6iq3BNEMGtb9KP33DM0c49ZsBCKXcWRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E/+7iNKIdaG5gbWEYpyg2UfFr94ke15gdduH9urZWVzhEh582YL5KB6iGOai6sqe3
	 cZ2PdRf+mJF2g6ww9THusLf2cZDLNNRMGTFPBpci2J/c4LCshj8YzluBSYUG6KsVNu
	 c8kuxuccSBJmLZgvibKE8ERHoZzsyHD5R1LR3gDpJ+Ea1x7KWsqIr7MJmfqby3tBMP
	 2WWa3dKF3mYKz+GOgThScHb95M63t0DMrasydXIByoxJSxcVIlIa1TVhPNKU/OyacN
	 9F6/wup/1n0l1Sy8gR1UVt5JOOiSZYBtsVgVliJPq7wQSJkbwxYZ3fVeBTrCfS8Mrb
	 XKGBtAWP2BOGQ==
Date: Sat, 7 Nov 2026 18:02:53 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: hugetlb: fix GFP mask propagation to CMA
Message-ID: <au9ZvQObSY3y2s2c@localhost.localdomain>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <61ee04513d6cac32347ebec9b295025b8a1f07ca.1794046188.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61ee04513d6cac32347ebec9b295025b8a1f07ca.1794046188.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: fai7oky1qzmifpam4q4qtxeh83pezh7n
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EFC5940003
X-HE-Tag: 1794070979-439062
X-HE-Meta: U2FsdGVkX18rVt3DrpbsU8f8FsBCZx918Dy/2wVTkOEzIWWHd7KwRokNepyy0p+hJcW/VYscoIspCtPT2tbkRs1oIAeveC4PlrHkzhaU+xgPc9j670DNUi04SoJQmzbmdQRPqmj2/BtRYPCbS3HsGtSj3Ah8k8+aeYf1BP1jR+KLfHrtZ9jL2vkIXyazPWWynzSkXL4GWyx55ALA4a9qlApwdpY17jciH01WK6pzDLxOl05sZUHtTBrNUHnLG3X1ZYAUyJ6ACxiznMyMjAqllqAjQI9//rmWhZJIr8HcdUA5oOS3b4NgzfmszOguVIkd3KwTwyyO8eIUU/+p8SYcKNoMpDGIlvCe50iI2z9DfFOdd+Cc3LG9MP/B7RL7kWbIHOMPhozGZr1pGbS3F94tnC0WT7ECp7NfZOvuJQ4UqJ44RKatPAmut23TfY8BJlFPYxiO+Wx+/Ea048Olfw+yXNfSYHvCSl0Iob9nnFW5kyKGGQrF3mJvOdymCnk4ZwTOz97Yx3RFcy1uSi+XHu/I2tRWgghKS7yVsq5o5BK9fQyLdYCLAP0xJ5uApJToYyGKA8stWvLNp4j4QRzGQ644MeOPfzAZMWtjfJhseYYuGN/l2XJgS1pmzpa6MQcdtPaJ2maKe/WDiSX9e1F4Gzh8bnzXIp8/2wDPtHBqt8NgRv4EsP+Ll7CIRNo9waBjNZk0N24FfH1rHr+9xsaTIPR2/18xZpCI+68foUytxOc+rRmvL4ZVNUmJlCgzneq8YqimtJ1mbHub8dZ9MycuPWbY/wnv6xKzpeL45T5pVK6h4TaoeNmZduliEyrX+G8iNJ/60m3LPgLYiNPqbBcQTIaoo5bwwQV54zH+q4glGegZzOM3vZlHJlK+twZb64Gd0WBwYWGFBlBQxLnpDeIipFFaV7Kxh6hLOQ8GfOYH0eh0FF6qwXFXDqTp1SIKzzF2OajCmREm9gcOYlWScZgd1ih
 R7BfRw2K
 dkTWMHZ4HgCPUp1RZBiNHC2kt09RIS8KP89z8Jp/gdPpaMi/RyJxehXSaUn93LCcaz9Sbgq3FkSrJamGc3ZMNHl5PE6XfwXc40SLmks/JCzukuxZAyp+eIZmqC7/iCbdbeEzEyCLAjCkO/Skhh1K1vnE/udQITWeUKAAGxzR9yVxdfem94xzNe5NCEzjiW4l+/TKN/bNo9SpQmCAIsMxlrxWTiupfhNTs/uxk8USqD1JYgumpv2BrXyZMKjSTBd5LOEE1aA3IvhUoa4CxVOuWwmmq5CbaiUOJQlkM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 06:30:47PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
> during the first MPOL_PREFERRED_MANY allocation attempt even though
> the caller clears __GFP_DIRECT_RECLAIM.
> 
> Pass the caller's GFP mask through the helper so CMA respects its
> reclaim constraints when trying the preferred nodes.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

A comment below:

> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -933,9 +933,10 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>  	return __cma_alloc_frozen(cma, count, align, gfp);
>  }
>  
> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
>  {
> -	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
> +	if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
> +		return NULL;

I think this needs a comment explaining why we are checking for __GFP_COMP,
because it might not be obvious to the casual reader.
Something like:

 "The only caller of cma_alloc_frozen_compound() is hugetlb, and hugetlb
  constructs its gfp mask via htlb_alloc_mask(), which already sets
  __GFP_COMP. Check here for usecases bypassing htlb_alloc_mask()."


Maybe in the future we do have some other users of this function which are outside
of the hugetlb realm, but if we are propagating the gfp mask down the chain to this
point, we do have to check that those users are also setting __GFP_COMP.
  
 

-- 
Oscar Salvador
SUSE Labs

