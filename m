Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB87C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 05:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A836B0093; Wed, 23 Sep 2026 01:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F36E6B0095; Wed, 23 Sep 2026 01:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808546B0096; Wed, 23 Sep 2026 01:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7746B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:53:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 311EF403B2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:53:41 +0000 (UTC)
X-FDA: 85243960242.01.BC49114
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9F51F180002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:53:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfiMSTdw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790142819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLg7eC5tmmPMhZrdk3Y2A4+KtVVGLpx4Z4IOl6QmxuU=;
	b=PrhAgk6wX+s0jPZ/OXe/iRez/JwAWaVBa1joXXIVCJM+Qi00tDKH9g3JowbzQEmHsstEkB
	KmWkTh0xZx69EncxO2MQpHpo6Rq6e2Sk9k3twC3biZC7BvSI96sJ+HsnViDMrMyizb7LuS
	oZXqCPpA49rJFRT9/TXf1SelsWK7dCo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfiMSTdw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790142819;
	b=PzDnRtFrkLM7liYlQ91ZuA2zyceKi2Gfijwk26XEF5znpHxADzoMDtQB9EbiXt9N8JQqoL
	Xdd3DfRSim9vb/I4wZDbNFDgGiuhwxuXVL6eEgua9vdkVpHSvEG1lGFHCzPaCe2aPLX2KA
	h2WQBBYZ/8rnadEHa4W+6ii4m1geIKw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D71D46020A;
	Wed, 23 Sep 2026 05:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B328E1F000FF;
	Wed, 23 Sep 2026 05:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790142817;
	bh=NLg7eC5tmmPMhZrdk3Y2A4+KtVVGLpx4Z4IOl6QmxuU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dfiMSTdwFtu0GCkhWemNFDgm+eZPZTNwX9NfJANQl2p7VUL12gPuLOT5GFrp9s1/W
	 gYHsfaLK7hikvujYiuXBUn8tMKa90RN/oaYf2S0NAbKARN3nHId0g1n9dBJrUeJeqm
	 1Q44Iafx85llSabeXDEcOdxXWocXCUP5y+CfG+SLeH3LQKK2DCfDxkDMtcFBDaOqJv
	 3HMHpRbUUmlsMii5otr4W/LYqrG4eJChKhKMXRP42VluhoUFMzhKQPjXcnsbxGFGAB
	 eSZq2hnozQ8Ha+TQTKHYQZsH+7U8XaqMquyRiYdYscnEhoNd02LZ7qoYGMlm0AwCPg
	 wXpHkFmSzOfPQ==
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
In-Reply-To: <arKsFofudnTYpXj1@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
Date: Wed, 23 Sep 2026 11:23:27 +0530
Message-ID: <yq5aik3w344o.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 9F51F180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bpcux5rk6efypeqyzs4ew48hh7jaf9kn
X-HE-Tag: 1790142819-914408
X-HE-Meta: U2FsdGVkX19UfnxaKKX/HNPXj1OVu3nkghLYcUjAvMT5LXJdLO2YEJ2IH2lcZceuguALVsoAJ5nicMZJX8V7nk7sgOkl2VZuEYZnJk0focxa2BzWFKd/Icg84msL5gY+AgM/8no1uknrSSsCH48GBUh5CcczE007mtBQAc79yGBicL/wD+MoKurhkLCKMECIiSSqhQe1djgUsjRFuadheq2yyisiVHxD1CS8dF2B36ReUV1/UEU9JU3Fcce4hMSMzS+KuIUmjeAWK4CG997yXzcyAN1thgu3DtaUPD+Res4ggUk228/QsQbFlo+1uXrtzx5mzzF1GCNrJRV8Gaq1Z/WF5Rv0bQN8GgnNUACq21/E9kSbMWD/M2Tp164LHG/AMJGv730bz3jfRjofcH4W0PX8rkMaZ8pO23vGdriiPIhx9kOmuBvR/oBBu+Ll2DcH6FZJa8RHAoyavT6GwamFy1Yybo01BEnkM8HIyvMQ7nYyklWQg3jkZZE9QbvpaDB8tP2uXaSACffQcf4m+f3cfwLC7jiMpzH0UrB0hwFFVe6I+KNErcb+ZUk/6TWRSEjxHLI5/EuW+0+2PSG7zQ4M6KlWV8/HoQz9vzy4a+YN9wRWIIJuMDDMiZOBSfDjv6lV7kz86TjynshnBl1Jc2Q0N1yuFI9ADSz99ScsZlVFhpcx2Vs0vsUyx/CRsfZp9u1RLa94HGgwaTgKlMTp90B0PlxREWfgpz+PcN0rGVSxfsXvgXPl4/Dt3r1OWvGqzydNuUXNSa2CKyuuNIeejVjHLg3J/IsjFyDX0p1XN9IABu86DjPcJMu7KXdoK8QVjCV+n+Femv9kK/Zx0LjTtNQwR8iVmxPGuIW1Xy8HYtU6a0A/RFalJf5jVfckRTZ2G6CFiAstm0Jksssaqvp0rp4ZS7Phx+0M7LK0VbbCB7skbuZKBy/P/7/1NQwKOc0fFXoXzQefW6px98uN3rKiWCw
 JtfojP85
 U4jabJWvStoW1G4w5dEECG88AKH3EuiWL8/ETrzES2sLh2PkMCVRzZ0EKVNJIx07k7PSRyu6c6TSoLPrrmyhrtdYDRGLvnwtWuRwZEQivTMhcnOSD/fV3SwceIeIw10GQZF6r+Pn+1X8kGw8se+8CpWywvcZubrYADhWd6TBJF8cVyB/iwuXXoApAg7XFDNUo6CHkRHJ76wWUOV6iGCJ1ZUnKgpy2o1CBTvPT5ugGlZmYWrSH339veXRLegvY1vyjNEsEcy1oIaqWLFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
>> +		size_t requested, struct cc_shared_pages *mem)
>> +{
>> +	struct cc_shared_layout layout;
>> +	struct page *page;
>> +	unsigned int order;
>> +	bool zero = gfp & __GFP_ZERO;
>> +	int ret;
>> +
>> +	if (!mem)
>> +		return -EINVAL;
>> +
>> +	ret = cc_shared_calc_layout(requested, &layout);
>> +	if (ret)
>> +		return ret;
>> +
>> +	order = get_order(layout.shared_size);
>> +	if (order > MAX_PAGE_ORDER)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * State transitions require a linear-map address and may modify memory.
>> +	 * Allocate from low memory and defer requested zeroing until afterwards.
>> +	 */
>> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
>> +	if (nid == NUMA_NO_NODE)
>> +		page = alloc_pages(gfp, order);
>> +	else
>> +		page = alloc_pages_node(nid, gfp, order);
>> +	if (!page)
>> +		return -ENOMEM;
>> +
>> +	ret = cc_make_shared(page_address(page), layout.shared_size);
>> +	if (ret) {
>> +		if (!cc_make_private(page_address(page), layout.shared_size))
>> +			__free_pages(page, order);
>> +		else
>> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
>> +					    layout.shared_size);
>> +		return ret;
>> +	}
>> +
>> +	if (zero)
>> +		memset(page_address(page), 0, layout.shared_size);
>
> Does the memset() post sharing logic work for pKVM as well? If nothing
> clears it, we have a small window where guest data is leaked to the
> host.
>
> Is there a case where we *do not* need the memory cleared? If not, maybe
> we can move the logic in the arch set_memory_decrypted().
>

I don't think every architecture or platform can unconditionally zero
memory in set_memory_decrypted(). Some callers may need to share valid
contents with the host.

Also, if zeroing is added only to the CCA implementation, the allocator
must retain __GFP_ZERO for platforms such as pKVM. This would cause the
memory to be zeroed twice on CCA.

How about extending cc_make_shared() with a flag indicating that the
memory must be zeroed, and passing that requirement down to the
architecture-specific implementation? The implementation could then zero
the memory at the appropriate point: before sharing for pKVM and after
the destructive transition for CCA.

The allocator could derive this flag from __GFP_ZERO, remove __GFP_ZERO
before calling alloc_pages(), and let the sharing operation perform the
requested zeroing with the correct ordering.

-aneesh

