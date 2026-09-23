Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A68DC98309
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7FA6B008A; Wed, 23 Sep 2026 06:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1903A6B008C; Wed, 23 Sep 2026 06:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07DE36B0092; Wed, 23 Sep 2026 06:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D10666B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:40:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 510D640744
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:40:45 +0000 (UTC)
X-FDA: 85244683650.26.FCC18B6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9F8CD180002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:40:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hd5V7b2l;
	spf=pass (imf06.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790160043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQ5JYntVPCplUTY3sEfB1TwWkLv13hCX8Prz1WJTkWY=;
	b=3oYXc0bHgfOXtPFhrbdRj1lXgYwK6RJ3apuDGxu7QTQSiBcO6oXvSsIGkZumour95cZPSw
	rQiI7d96Qt95Kk062SeXkGy+xpVTsoLec0PlWGSPCv5lGpPuXt6FddkPauInvxNSYKdrva
	9Ds4fZJvOecfuLx2EgsHrMu0tsjHUDs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hd5V7b2l;
	spf=pass (imf06.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790160043;
	b=6aE+qkJ3chZ3T5rPbRrI/9G39Ts0DRCnU/47pJ9cmdTb6L6Ayy8l0rIhb7OJoO80KTv9jE
	4MQMP5kXmuelGkcdUqNYdtgzMjegzWVqIuYY/3RgWqwSMZ4374EgatPJpX/Tk1KYS+2ddX
	Hc84KVq6fgASn581hHFnNBt4jzpbjS0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 074E7143D;
	Wed, 23 Sep 2026 03:40:39 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 789533F86C;
	Wed, 23 Sep 2026 03:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790160042; bh=M87HFnkQVfHN19+6QwqoNSTVdvNLwPr786eNk6QJp9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hd5V7b2lJCRJq/Ms8s/d8tR11f/qhMBk7Oe4j58RXcp6qt6aQwikHkHXDqQsG6y9I
	 WrsMl87aoacM9e9KjV+HavYIIvBZEd/CGC6r/SsKz0KRi08xCTqHV7X/fKTG0AIXAW
	 zPWUJE30Iut++MHgK+DBrex+Gg1pDcKlkP4p7uMQ=
Date: Wed, 23 Sep 2026 11:40:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <arOspFxWZ1DjgcAr@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a5wzw2ree.fsf@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F8CD180002
X-Rspam-User: 
X-Stat-Signature: m9hzmygyapph64yhp1oiyemt1a8nt45j
X-HE-Tag: 1790160043-322699
X-HE-Meta: U2FsdGVkX18Pr37d1jP8lEWBMemEp+dKou5QRvYUmIlQG9aO63AhORgGiB5aUuPnKe43hWhV9fx/UDkEoUx9tZmilqCPqX94I5P+Yh5HMnrbBbrcL7UR9jM1ODwTMab4jfsm0HQ6l6E8+6lC0Thd7Dulp2WrlNPTX5TaGV5fvnHrbVXhska27H3iv/dCSJvYGAzizo60+N5I892HBnmK2xja5etxRtEuzvZOkgfcZaMPDTh4yWf7g0tWqYvcuc7ePnzRfHq0J5VoP9451QCMZSY434Xpp+QnNSeen60iVKlawKEXt0uEH86hiLYRgYILFyjzPFKOdMpd7D5W6eY5n0v8w9k31NJulHFlxqCOH/Wugza2GerGZ/gV9ITXMPX8VKJSaNVa6aQIIB7mvorCNKe3tys/Hoeb6HhvMf6d0BlCCHxARCPIuohwiQcAXVE6399mM/FTnoNwa5rtWmfoXj4xUdl3sIb6QuxOn1vsMsTmrKMJaH1RQO8cY+subsU4XU2FsJ1CnPnsUEP3wsc8ecKyyQQAxGhLNnIrJc5u+qIqOJlBWFLUzOd3UZ3bOdrk0V6PEXG4f4IA1GI1QjAQBTFF9IJzma1vzorsBF/Jg+B9xeIVlv+BBPQvy+VHXT2WguKxszOO+PBOd/djMOuMVIpPc8ta8l1oVSTzRfCVvWrsHbLTR4EXwazKFaR05bX4S2O46HCkd/AO82wTksN8E457CSNJXewfiSKoBmNYnBopUSqemeUbOLPK2pNbPM7OFIaIkyyfUPwhrY+tO5cxoC5Tn9wwDLQfPIVeMZyeqOsqueoN14dlamDR549MAXdeGT7JCeCN8aVI2rIkwHX7Vw1Ef8NH9141fOzESAOg3WOgADgsCi5O1nUhSQtkLplAZe5fNQKRPq0i+P0W3pO17blXbyZTYZ7Xy2dOQ+IHJ75IJbWcM7C2yVXKJN7li7VBu8k3qyl9q1OaWsTPDz6
 w/EFkPsi
 ZM/lyRNYUSM+7O7WZGZCmRN0iORbn/feWTH0afgYB+F7rlmllS+yhJZYGuwZM2j65EKzXq1vWKOAfbTD9aIIvPPd/pIrpPoUwa1MdL96RmAtoZTOLM9JSWoVxWmdUJtBTMmmB0PXVNOKTEFI18w0AIrCoc+9TVKfxOxI2tKWmwGo1vzRdeBqHW7ok3XONS6QrAA+fTBadIQ/yVqjtC9ytkjMWBc3R18v4NZBo+ghcf/O6R1f4A1JhYNiN2XNuNw89KRZCZffMNzztFOerqyKt9K+PI7cbIw4RWEX9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 03:58:25PM +0530, Aneesh Kumar K.V wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Wed, Sep 23, 2026 at 11:23:27AM +0530, Aneesh Kumar K.V wrote:
> >> Catalin Marinas <catalin.marinas@arm.com> writes:
> >> > On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> >> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
> >> >> +		size_t requested, struct cc_shared_pages *mem)
> >> >> +{
> >> >> +	struct cc_shared_layout layout;
> >> >> +	struct page *page;
> >> >> +	unsigned int order;
> >> >> +	bool zero = gfp & __GFP_ZERO;
> >> >> +	int ret;
> >> >> +
> >> >> +	if (!mem)
> >> >> +		return -EINVAL;
> >> >> +
> >> >> +	ret = cc_shared_calc_layout(requested, &layout);
> >> >> +	if (ret)
> >> >> +		return ret;
> >> >> +
> >> >> +	order = get_order(layout.shared_size);
> >> >> +	if (order > MAX_PAGE_ORDER)
> >> >> +		return -EINVAL;
> >> >> +
> >> >> +	/*
> >> >> +	 * State transitions require a linear-map address and may modify memory.
> >> >> +	 * Allocate from low memory and defer requested zeroing until afterwards.
> >> >> +	 */
> >> >> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
> >> >> +	if (nid == NUMA_NO_NODE)
> >> >> +		page = alloc_pages(gfp, order);
> >> >> +	else
> >> >> +		page = alloc_pages_node(nid, gfp, order);
> >> >> +	if (!page)
> >> >> +		return -ENOMEM;
> >> >> +
> >> >> +	ret = cc_make_shared(page_address(page), layout.shared_size);
> >> >> +	if (ret) {
> >> >> +		if (!cc_make_private(page_address(page), layout.shared_size))
> >> >> +			__free_pages(page, order);
> >> >> +		else
> >> >> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
> >> >> +					    layout.shared_size);
> >> >> +		return ret;
> >> >> +	}
> >> >> +
> >> >> +	if (zero)
> >> >> +		memset(page_address(page), 0, layout.shared_size);
> >> >
> >> > Does the memset() post sharing logic work for pKVM as well? If nothing
> >> > clears it, we have a small window where guest data is leaked to the
> >> > host.
> >> >
> >> > Is there a case where we *do not* need the memory cleared? If not, maybe
> >> > we can move the logic in the arch set_memory_decrypted().
> >> >
> >> 
> >> I don't think every architecture or platform can unconditionally zero
> >> memory in set_memory_decrypted(). Some callers may need to share valid
> >> contents with the host.
> >
> > Is there any? That would be a bad assumptions in the caller. Most
> > set_memory_* backends don't preserve the content as they change the
> > encryption key. So properly written code shouldn't rely on this unless
> > it knows specifically it's only running on pKVM for example. The only
> > use-case I see to avoid explicit zeroing is when the caller doesn't care
> > about the page initialisation and wants to save some cycles. The
> > encryption key change would take care of the security aspect.
> >
> 
> I checked this, and you are right. We cannot expect the contents to
> remain valid across sharing; set_memory_decrypted() is destructive in
> that sense. Since pKVM does not rely on memory encryption, it needs to
> zero the memory unconditionally in set_memory_decrypted() to avoid
> exposing existing guest data. Other CoCo implementations may omit the
> memset(0). We still need to zero the memory when the caller requests
> __GFP_ZERO, where the memory location is expected to be zero.
> 
> We could either zero the memory unconditionally or pass a flag to allow
> this micro-optimization. We would also need to audit all call paths to
> avoid redundant zeroing after set_memory_decrypted(). Let me know if you
> have a preference for either approach.

The simplest is probably to always zero in the backend and ignore
__GFP_ZERO to the allocator. But it's probably only marginally smaller
than passing a CC_SHARED_ZERO flag down. Get codex to try this as well
and compare the diffstat.

There's an argument for the flag approach from a performance perspective
(avoid zeroing unnecessarily) but not sure how much it matters in
practice.

-- 
Catalin

