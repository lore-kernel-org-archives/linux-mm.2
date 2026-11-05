Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181B5606A333
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bUDo1t7x
Received: by kanga.kvack.org (Postfix)
	id 27DBC6B05BC; Thu,  5 Nov 2026 05:00:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208886B05BE; Thu,  5 Nov 2026 05:00:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2CE6B05BF; Thu,  5 Nov 2026 05:00:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D96366B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:00:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F71912094E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:00:42 +0000 (UTC)
X-FDA: 85400621124.16.C0558C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id AA4D8100005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:00:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUDo1t7x;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGrCpm98nfFc36ckFB0Am9EO9qX6FTFJ6f1d4Ty4H3M=;
	b=WYqe+EqVj5rm8LE4KDyj1JRBnIdeno/avN7NPC9vCboWb7xwaKUpf7BhnQEeiATJRKmQi4
	OMvAi/1c5hRv61dH22YIVCaszXuKK3cc1XZGInqW4cNm0PWNg3hI1B8HFEhi/9LY7my+2a
	cvG8TzBj96tR+6CupTfXVjwL+aqP+5A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872840;
	b=dkhyMrDZhIaVvaAMLcay3ngzkeY+MqJ4ktkNJN/mRIETLbrGbwkEzoi/1LX1+6qcEaeKhq
	j8ffsZXYb3HI9pgeHCuyQtv/TNAKpuvCmJ6i9xy/e9Bsm9c4DjnMawG1DyGeWVkeVHX2eK
	VKCIl6uYT+6WujrBYzQXLJsYgdrgjSc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUDo1t7x;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D65A601DE;
	Thu,  5 Nov 2026 10:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1A81F000C1;
	Thu,  5 Nov 2026 10:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793872839;
	bh=RGrCpm98nfFc36ckFB0Am9EO9qX6FTFJ6f1d4Ty4H3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bUDo1t7xw8a83rTXWT21nRyRGLwNZUd8Dp4TB6RBQN7XdDXprEUGdVgLXDQONY/Cv
	 S2yeNKkiAmoO1aRdGAyozxT0tcGfC42be3IeZAEpFF3kyRiE6+VOaPAIGlunc2xmZ/
	 gJjQw+E8lxM/hDVylWGVUv2c+F7gSHqKGGozOjFeK5OaUF10QXUBSfNsSQh569z6+e
	 nvi6qn+NBzaUiY0ylV48nmC8XNr81hb6xLwtsCu4wdbbO+0t6ySGZFhPxjpQPvoG2s
	 +E5y3O+JNhI9o9nl8EvRmgMyn416AYrW9c2ChA0xCqlnr/kV9+16xM1q1vB49H5Ht6
	 5GS1Y3dpRgw7Q==
Date: Thu, 5 Nov 2026 11:00:34 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm: hugetlb: fix GFP mask propagation to CMA
Message-ID: <auxTwrKCeg7a3hfY@localhost.localdomain>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: 6zi91gouyh8f8jhnw9kdbgfphainrkis
X-Rspamd-Queue-Id: AA4D8100005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793872840-211846
X-HE-Meta: U2FsdGVkX1/67ov4eWMUSqY9qzZIuailHJTUF4/2NDhTieE1eQ/Znq45WvnfyUUspetlixTBZqOsVQs0qlctyeZxWf+V4yVUNwqlNM0SlZbn1+2S5im5e4YpyVbkOmNtw7Tmode8hDZHYgK4n6lwofWRbZqPjJ1esnyzF5032G2EXSLukCsA1zIPmDW9Sy2T8HJ8nsAxW2bDvql9qUYP2ZkSIOSwtNBVQUE/RM5sfWNxcpEtR6RYyuF4yCo96rHzzvcPUztbR9mor+DK+CfzHvJj/68DrEaJ5As/0+pzeOb2z5RvBmjEyNZll1x7GSsmsREicXzUpk67/KLBWasp6mOpr8bfZDKIY8VF52CCJn07szEJW6+yT3jvmLeOo6o1WHWcbOhqAh8GNiZ6wQ04aOm0KpsdbzdjhdQs/IdMJeo/EzAOoTR71+/BP5yW+zmcBg2WJ3a21J9acFnYRNpYJTgTrUTo6HqlaF6ORA93hezxGVmnuE05VJHkxfyzfBItCE5hEUotEGbCvzp+yDALidFOWGnSfBaDY7HkU1Kkdye+8y4ibcFazyuXTwGhnDjdZPzGEu2HaCGe7MJK3rPfTM0AvCkeZuJk2y29rfrVjYu7kqf1lYPytSusNBm/T/ranr4Y7lSH8QSwBD5itfRiaU8OIeQzKJmIKppRK8R/pDQQ+VCYGNfWPKHKRBC5BLaU3ZXNE5sLEclLu04JzmTFhoLwIkDJpwh+CsrOednnRDsRvvC+dRR48ucZ6MBvNNc0YFf7+KPi9l6vgJrEMfd2IeHymP2nH3hdVhAzNVNApmLqlxLW1JCqtV9Z8Bpl5PLAwA8gidV7PTS9jpnjWO27mZbVjCl4vKtPOoIOO9TfevaQ0ZJUnG6cy/HhzMvAd7iEfnfDllCbJkcljV5BOn9xUUB30r7Vnp+8aOEixX2nGdazYvzMZTQ1dBsdw/DtQrVWfVdjFHErY4L8ivMdkl7
 bzj7PK8S
 s+R+p7LdEUw6u4jWcCVhDeGBdqJSyJ9CoH7rWsGlbTg48qtXGMWrQ396iB9DZWTPfDMgnLge60O6SYZko21nw6YqsJkYwhJ2I47FEzai0lPgWcLpbhsR2D65U7NApCI9PlV0SoI5WKgxlBfJ+Aa9ORcjCVHrFDH+30lHG/GfMPC75z81DSayvTvRIFGd1aRObA76OkNw1pF9eZyEVqZdtpRajdl7Ka/WXzl9SZApvJb4ZaZbA8cIL6HMXy71QRSpuYKK8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 12:07:45PM +0800, Qi Zheng wrote:
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
...
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -933,9 +933,9 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>  	return __cma_alloc_frozen(cma, count, align, gfp);
>  }
>  
> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
>  {
> -	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
> +	gfp |= __GFP_COMP | __GFP_NOWARN;

Do we really need __GFP_COMP | __GFP_NOWARN here?
It is my understanding that all allocations coming from hugetlb are
handled with htlb_alloc_mask(), and that should already provide
__GFP_COMP | __GFP_NOWARN.
We might have needed it when cma_alloc_frozen_compound() constructed its
own mask, but not it gets it from the caller, and that should have been
done via htlb_alloc_mask() up the chain.

So, any reason to have it here now?

 

-- 
Oscar Salvador
SUSE Labs

