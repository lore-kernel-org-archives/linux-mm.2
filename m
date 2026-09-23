Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE8FC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E88B6B0092; Wed, 23 Sep 2026 07:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFFC6B0095; Wed, 23 Sep 2026 07:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF946B0096; Wed, 23 Sep 2026 07:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD9436B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:50:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72B67A07CB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:50:04 +0000 (UTC)
X-FDA: 85244858328.05.27D748F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD2644000D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:50:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j3QZjKt2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jI0vAlJKhDmiOEB6Q23h3G6CLXMXdX46480mhO3rjOk=;
	b=wWqLJJx53sNrAnDn9f6otDmdl/tWF5DlrYVk1/GGRl8rIorNIARA7FyJj1Eu/WgIJz6BX3
	MTmRyXHmV3h3wcDPfuTRTc+jtMqNmvVkQKrsrEwsaHvoUAEqTLgByF/gjZkxwetsCQ6fq9
	rG7ijDWF18fywiSoXPfT1Kip1D6JfjM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j3QZjKt2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164202;
	b=lN0NnDy0iWIqfcNP6Ib9EqHHtgJO3wN7DBAdB2pNc4c8HTFKrt1CMHdElLx8Mcr0oOuHNS
	dCN1MLKxuzNAROhg+hUUeyWR7SCy+TvACZee2mqT1CX7GSZ5PR7Ksk88pCJN4VmgBKTQPM
	+OdbhYyq6ufoNRujYhE0fXFRbbnxNWg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05F5940A5F;
	Wed, 23 Sep 2026 11:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D332E1F000FF;
	Wed, 23 Sep 2026 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790164201;
	bh=jI0vAlJKhDmiOEB6Q23h3G6CLXMXdX46480mhO3rjOk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=j3QZjKt2RDG++7vwN6aJe3RA7jXlLMR25KRKluo6b+e2fpyRs/pTz6vg3MeMVgz3Y
	 H/uFrc3+3pyN38Avf0YeUAxm/S/O+UYkxoG1yg2hevAJ7xtnMPU4ruJWSG/bl4vDRu
	 a2+E5u83/YxSpGaDgPepX4M+KVq5eQWV3LxaqaNvqgJ0xF/Xh37LMhSBpaanlugiGi
	 a6+IqmVFl9eTuZSg2ZqPukR9Tb5u+HfSSew9/Q5ZdNFqsJuWTV56233K9JINsg6JB4
	 SaDj00V23Bhf5UDAvsQeyU1kxlfysMR0sLQ47c99jCokiOgVXxgydYh+6zjRxefc3x
	 m/QmnRG8vSOaA==
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
Subject: Re: [RFC PATCH v7 06/13] dma-contiguous: Accept an explicit minimum
 alignment
In-Reply-To: <arOrgRfi1k12clT7@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-7-aneesh.kumar@kernel.org>
 <arOrgRfi1k12clT7@arm.com>
Date: Wed, 23 Sep 2026 17:19:52 +0530
Message-ID: <yq5a33v02nmn.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: AD2644000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: e51f9b1w9ufjcqkusbnhtcja6cyxwd54
X-HE-Tag: 1790164202-797288
X-HE-Meta: U2FsdGVkX186+8PwhvGVlnODUUlYOCWycVivza60rxQWnK6ldvbn2IDlSjKlN2M4AdeEBG5v7srSl5D4AHbwvKT/OfBvGsjhuquqb5Kt/oiWKDMaEJH+bFkDH0N7x5M3dVbwh+BuwZU28vTpdKz68t7ubxho7iP0FRC0KlDv6mGm6SJ4SueY22a0FCZa2ecqknuW4KebqnYazq+o56zzRwh07SHJK4TL64umQFFhJqtUJurdVYD+t07mRjOEHAL63hY9fNLIolrLal8ULRjIy8kRuYitTDhaF08tdHePHXeShuk7Y5YunfFlV6scsBuKlM0V5vT/fQhASFtydd6PZ05jStqOJzaQ12jzrKeY/6Hvyr0KgJeCXdOaS5f9rdJSn4PNa1rmH/3F8p46OwGpJwymDrZ61nVRbfHu2gVJ5Kl4SlNiOZ17Cu2wuOH63DNF75pjmldD7mEIGcqyCna0ufaZylOk9xzKKzqnm5nK0O+KQ2aoD3ky4KxT21CfE9AtsdLbae0mvwEUVmuFBo44jSCbVDiErE9lpZEmBsAyxLSLDM7p4RPe2oDmGUfr651bLo9sZ/Ud78cetLif5OXwae53ow4i40BfRbVFZXeFCQhazdK/nfpYDeBTzdK3gFGcH+o8ck2jJZGq8IFr10SAksXGWxuoBU7p0gVBI7dgxAg5U4oU1WiglrAWR549Px7bDM29Gp8XRkJ4Hh0q82MxG/wv0fvIYV6Uhfb5nDxaXCDztuonuUJaWpj+Fn9eubmYLcNWoTp9+3Fhhb30xEvKYc+SRReJbC58dfcPlMhVry2aENgfjXGqZdtqTYsRBwLYyIj5Uj6/XAnEBJ52W2pn+0lLaEel7ypkNVMY3un3OhuTvzbP/la9Rzfa4bJZ2mPglkHZvqhr6r8dp2Ov71Ok9Qhi660b2c+CY+62yKf/nKn8x8ZJBTPphGXjnYB0a9QD7vbQ5AIBGxLIdoow9rs
 1Nm66pgK
 amc1GSCB5o8FA1IIQH1tLrgTGdWIsxYvSw/yyvwEdkMGPAckCD4cl6ekLRAKm7396xV1yg0EdNO1S793lwGYAisK3U/WQ9RqmWg0gtxGIOo/+yzFWvpWhzkdNKkRiiXX5fhf2MasfpX82TsK1aqi/VeoFW07USj20sywbOya1pjLccAhnOBjTQJUWvKe6FXHjNM6ZQE7Y+fWjLb9+I1IH+sV70g+SiLBaUnPylZy4ZxgiYP8jcbBImKlaWwKpNUQ2ci4Hx+UcTHONeeLpLb0RXbM84w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, Sep 21, 2026 at 08:18:40PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> @@ -125,7 +126,8 @@ static inline int dma_contiguous_reserve_area(phys_addr_t size,
>>  	return -ENOSYS;
>>  }
>>  static inline struct page *dma_alloc_from_contiguous(struct device *dev,
>> -		size_t count, unsigned int order, bool no_warn)
>> +		size_t count, unsigned int order, unsigned int required_order,
>> +		bool no_warn)
>>  {
>>  	return NULL;
>>  }
>> @@ -136,7 +138,7 @@ static inline bool dma_release_from_contiguous(struct device *dev,
>>  }
>>  /* Use fallback alloc() and free() when CONFIG_DMA_CMA=n */
>>  static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
>> -		gfp_t gfp)
>> +		gfp_t gfp, unsigned int align_order)
>
> Can we not just bake the alignment further down in these functions
> rather than getting the callers to pass the {required,align}_order?
>

But, we need this to be conditional on CoCo shared allocations. We could
derive that from attrs and pass attrs instead of align_order, i.e.
something like:


 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
-		unsigned int align, unsigned int required_align, bool no_warn)
+		unsigned int align, unsigned long attrs, bool no_warn)
 {
-	if (required_align > CONFIG_CMA_ALIGNMENT)
+	if (!dma_contiguous_resolve_alignment(attrs, &align))
 		return NULL;
-	align = min(max(align, required_align), CONFIG_CMA_ALIGNMENT);
 
 	return cma_alloc(dev_get_cma_area(dev), count, align, no_warn);
 }


with

+static bool dma_contiguous_resolve_alignment(unsigned long attrs,
+					     unsigned int *align)
+{
+	unsigned int required_align = 0;
+
+	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED)
+		required_align = get_order(cc_shared_granule_size());
+	if (required_align > CONFIG_CMA_ALIGNMENT)
+		return false;
+
+	*align = min(max(*align, required_align), CONFIG_CMA_ALIGNMENT);
+	return true;
+}
+

-aneesh

