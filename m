Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79118C98309
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548BF6B0088; Wed, 23 Sep 2026 06:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA686B008A; Wed, 23 Sep 2026 06:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA856B008C; Wed, 23 Sep 2026 06:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17C0E6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:28:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0719160786
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:28:37 +0000 (UTC)
X-FDA: 85244653074.29.DD8B01E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E87F5C0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:28:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gfeKGD7Z;
	spf=pass (imf28.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790159316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tw+YzFR1Q3RDJ/ocFl7RH+C/kpA7xkpXpKPh0rT8+YE=;
	b=CPzuH+8UVSCLM3Zesr9M1sYWVU7+lUJA43J3WBcRVGb0oF2Q/orolKTWsYjzPsLbjnVZlS
	RbElZzS6uwM0an/rxABbUeSPZYxET22Xu0Cgc75/lRXEw0FZHBqkV1FcVqkycLfSQMSK9T
	/r3qlsF3OeYkg7MtUXV7VE+LxWMUniM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790159316;
	b=guvCGWkqX9IVKo+NoJq/m0NM69vMRV6HcCFusxZhvp7iboSXf+/CSi7qztpkTqXw8pSgC0
	+RQ5oLj5yyxP1wdFn5IbKiYFNoleVvNBZ8v91pwzjrfjd3uNzBb16sdEkXwvnFnkh7T9/A
	vk42XGAKRxWlti+LiklDUHdcsrc3pEA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gfeKGD7Z;
	spf=pass (imf28.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72B3E4048E;
	Wed, 23 Sep 2026 10:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7196B1F000FF;
	Wed, 23 Sep 2026 10:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790159314;
	bh=Tw+YzFR1Q3RDJ/ocFl7RH+C/kpA7xkpXpKPh0rT8+YE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gfeKGD7Zx1t68oVKPD3pJdIls6095LdyIYbLzcbi2lWu0uZc4Ag6czwUu/3rMOVvu
	 5DkKG7QVnUdoUJyu1nzlZlhO5qsE27dTDKv4KVUeUxS/0fGMmnV48ACdIVTacKhMLM
	 Kp2Etb2iursi6SlXAk2q9a0Y6ZYslY12NqaBGyj2gFaxqHvu92+46mMlc5J8MMsSdD
	 HGiK3yV1AdehOFvWHLjpPcT/57yOMwlxfev62t4C+oD/yqe8IWaG9c7HzZhanNfFx0
	 V7SG8BRuoVDTolq0VsrAo7+8om8W5vw2V1IN/4OrxXJcM2FyWTn+Eqh0SDfkr9xU/H
	 iMGeRqREn7XNA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
In-Reply-To: <arOfD6syXOgQhZYA@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com> <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
Date: Wed, 23 Sep 2026 15:58:25 +0530
Message-ID: <yq5a5wzw2ree.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E87F5C0005
X-Stat-Signature: cg73yrupbm65i41htg5f3jkskkdx836d
X-HE-Tag: 1790159315-256130
X-HE-Meta: U2FsdGVkX19bC97g0ndMlaMbrAHUhcm2RTv1xzQ0sGmr3OPf0iGiHYcFb44W2Os2u8SVNI5vEkow0v6jcEYHgGEazF5B+jrQbt0K7jtA2vRzKLhupQTgwLRlv7dFtoXXDU1YoSFDJpmctlScHZYMQgZtyD9MV+J+Io6lZJy0g3xvZmEj1r9KKPreUtAwwHF+pAGWEhYepA8/4jHamnLNoShomFPa23q7iRuVCQgd6u03xCCunyi3LvU6PicxEi7QfQcXh28RpZUul2pVpdrTRwQvZGq4KqG7aotbw4fAJHBtnMlPxGIrtJIgP/gUJOvcezzry0ZhTi5b5lziZdeYun3GzRB6UgLfnXJnssD191ZNCyULzlLnhgEu46M1sGw58rHbt1HnKw/hj0y4ja2lXB5UCZxmztkQQ1+2Pr8FDrrsY2gyaNWp6cM0IsaLRKaZYtPPPoijcne761kopMoZg+sfen44iller1IKwhWBi27uytMxXd3UM7BciX9C3di+Ihd/jIkiFnDkW7XP6s8kHTk/HsGsPwmOOCGu4m9+XYRHAbaET9rN6yClTVAZklerUJQAesVk1MMu7KAi5cBhi9cq+CxzOT1/VkZ8gQOxocSrLyPq64WwOGp3shZpOEAIxdPxzdTM18FES6LHEinn9pHK5YyAZGqNLVZoRFM7Hvcykb6Rj6Xm+h3mPcJQ4ShSRfF975XAunKBq7KUR4FQGvfYaCY2vgAkmDH9Wzix77DGpP4I9hhl/P2t735FmVoXSRJr+TOHgC/eVqfZQolOn/j1zzUYCt9HTnvAATmtC8cnw9JJPNYIn1HQwkVtPiD384ErfxxI+z6jvEw2I1ZYpKWO34mlOUq7+rq0Xfo00e+XLgmcGfHbwgJqcAMa4NTsjqxQmR8pSfxYpft+MsUHJ7y9HBB6NuDq2WCpb4n/5ZSQM2SVTu7mglZ04qxXljLDxPFzF4Frvj48s2NbvAP
 VtnRZCb0
 pKSOmZsBhXOO3LdHQW+gR0Vyw5jsm9PRu0PVCFrrlH1EdFSBuAv4P8nFExOMK5kz7UvtCgKjn6sCPRWi+pMzEWKl0VFDqimOUtiRIYmiP730hRLpzeb1jkUMeB13FmGKBZP6C1u+8qolG6qGi/mhT+E7RwWoh0AggOm/HllECyJpJAWBtQuR2phmwrk2bbjW58QAM4YZaqLfrnpzDZs42zVvFgpEQWcJm47Ok/4vdnUfjtn1GzD5wUOYeu47H0ls0FB1t4RUEs9Xsbis3EVT/l/BVow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Sep 23, 2026 at 11:23:27AM +0530, Aneesh Kumar K.V wrote:
>> Catalin Marinas <catalin.marinas@arm.com> writes:
>> > On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> >> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
>> >> +		size_t requested, struct cc_shared_pages *mem)
>> >> +{
>> >> +	struct cc_shared_layout layout;
>> >> +	struct page *page;
>> >> +	unsigned int order;
>> >> +	bool zero = gfp & __GFP_ZERO;
>> >> +	int ret;
>> >> +
>> >> +	if (!mem)
>> >> +		return -EINVAL;
>> >> +
>> >> +	ret = cc_shared_calc_layout(requested, &layout);
>> >> +	if (ret)
>> >> +		return ret;
>> >> +
>> >> +	order = get_order(layout.shared_size);
>> >> +	if (order > MAX_PAGE_ORDER)
>> >> +		return -EINVAL;
>> >> +
>> >> +	/*
>> >> +	 * State transitions require a linear-map address and may modify memory.
>> >> +	 * Allocate from low memory and defer requested zeroing until afterwards.
>> >> +	 */
>> >> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
>> >> +	if (nid == NUMA_NO_NODE)
>> >> +		page = alloc_pages(gfp, order);
>> >> +	else
>> >> +		page = alloc_pages_node(nid, gfp, order);
>> >> +	if (!page)
>> >> +		return -ENOMEM;
>> >> +
>> >> +	ret = cc_make_shared(page_address(page), layout.shared_size);
>> >> +	if (ret) {
>> >> +		if (!cc_make_private(page_address(page), layout.shared_size))
>> >> +			__free_pages(page, order);
>> >> +		else
>> >> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
>> >> +					    layout.shared_size);
>> >> +		return ret;
>> >> +	}
>> >> +
>> >> +	if (zero)
>> >> +		memset(page_address(page), 0, layout.shared_size);
>> >
>> > Does the memset() post sharing logic work for pKVM as well? If nothing
>> > clears it, we have a small window where guest data is leaked to the
>> > host.
>> >
>> > Is there a case where we *do not* need the memory cleared? If not, maybe
>> > we can move the logic in the arch set_memory_decrypted().
>> >
>> 
>> I don't think every architecture or platform can unconditionally zero
>> memory in set_memory_decrypted(). Some callers may need to share valid
>> contents with the host.
>
> Is there any? That would be a bad assumptions in the caller. Most
> set_memory_* backends don't preserve the content as they change the
> encryption key. So properly written code shouldn't rely on this unless
> it knows specifically it's only running on pKVM for example. The only
> use-case I see to avoid explicit zeroing is when the caller doesn't care
> about the page initialisation and wants to save some cycles. The
> encryption key change would take care of the security aspect.
>

I checked this, and you are right. We cannot expect the contents to
remain valid across sharing; set_memory_decrypted() is destructive in
that sense. Since pKVM does not rely on memory encryption, it needs to
zero the memory unconditionally in set_memory_decrypted() to avoid
exposing existing guest data. Other CoCo implementations may omit the
memset(0). We still need to zero the memory when the caller requests
__GFP_ZERO, where the memory location is expected to be zero.

We could either zero the memory unconditionally or pass a flag to allow
this micro-optimization. We would also need to audit all call paths to
avoid redundant zeroing after set_memory_decrypted(). Let me know if you
have a preference for either approach.

-aneesh

