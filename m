Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5071DF3C264
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8DBA6B00A1; Mon,  9 Mar 2026 09:44:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57D86B00A3; Mon,  9 Mar 2026 09:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84F76B00A4; Mon,  9 Mar 2026 09:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97A3F6B00A1
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:44:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 602BF136C9F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:44:34 +0000 (UTC)
X-FDA: 84526644468.14.8F2E302
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id ADFFC4000C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:44:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ktkuMurA;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uff3YTCVgqsL1iOsrMf8mkfHZ5TV2mh1epm2NrmtkBo=;
	b=Sbcqjkg1NPP05YMJ+NrdmAXNrwj7dqPzet82KogRoakZ201UELdbzmeayCSjlbE20GBFTV
	qksRHtcon4Y9WdhTIordEzjRCygMuza1nZRlNkZ2tPVtyBsn9htiocufC7+yjNUlmiVR2Q
	4ST7LnSVLBqgzphjSZqollOz66swG5c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ktkuMurA;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063872; a=rsa-sha256;
	cv=none;
	b=mC0rVoRX88kNm2abmilD3GNtfWRc3bt/wpsg1N79zTJF6+HRmIVY0ajnUAoy3NV4JIJNz/
	HGEMYtdyMz/ulwvDffMI3CmIJVAMrTiWBoCkwyddFQvKaPijy7q9GPbdvaSSCmrHS/5fCL
	ety7ijejXnI3rXfonQNbnrAbpc/S224=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B6E7943AA0;
	Mon,  9 Mar 2026 13:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0E8C4CEF7;
	Mon,  9 Mar 2026 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063871;
	bh=uff3YTCVgqsL1iOsrMf8mkfHZ5TV2mh1epm2NrmtkBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ktkuMurADMf50LRwnbfN1+AJYnRdWEKFnD0sMhwDV9Qk044EpO1RsQJsCoizrusOH
	 29xj82RiF2RGwBmdLo0pT1VS7qJ3vVYUADrzug3p/vxCwbDuYsVlwT/lBGSbDErk6i
	 jQQ7gSkUXIIKvzOHZvXIfbiAnGOw0RzQuf5WfliG+/4nCwo0/ZTHFwAxYz7AVV9zfS
	 cytQdTnyw2vmLaFn52/q2fbpgQx2Xo/cj564DX6jwd7rYX7iewz6O+qlDY4gqp3XCw
	 y+PT9/CRU6M4iy9jhNd7YbUOjYayHZY8BYlakH7GFo0MVgJRM/PgAPyZ4xzCMcAdOE
	 WqUuFknTpY37Q==
Date: Mon, 9 Mar 2026 13:44:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 1/4] mm: move vma_kernel_pagesize() from hugetlb to
 mm.h
Message-ID: <27d52c59-e68f-4369-b133-4db71e1de0c6@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-2-david@kernel.org>
 <833950ef-e01d-4914-b5f9-bc1f6261b184@lucifer.local>
 <729e14d4-6949-4d46-9380-12331b5ad363@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <729e14d4-6949-4d46-9380-12331b5ad363@kernel.org>
X-Rspamd-Queue-Id: ADFFC4000C
X-Stat-Signature: z5pnn9nsuegdmewxtxwfkb9boar99oq5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773063872-828091
X-HE-Meta: U2FsdGVkX19n5AaZbtPckudcgoAXHrEOCPlJk18eEPd9gCt2jprnzCEtwwuNtn1oep+dlc/TIEMgqsevfEP5Vo615alN8V8/Z6w24270mC5M3/IM+Yh+1FBP2M8W/ElSCjTBwPFWx/vbO44wUyZFOiMd5vKkDroGpL3WHv+CfwwG7eYP7idXoIzD6BUD/wiuNlHKf2gAG6Rd3bHRr+mxkq/Gs8SXNz74q5sT1MuGo+nV6tmNCdJIqS0fIPbPg8TrBwj1k+CRcFeh9WSzP1nZR+XaxvbY9m6xnu1iH5CWuXa8cO20IBkQ3FzXxwiuxolEkL3zfOLN6Caf9mzOgrDN+G7L68trXBLftxp+91+0ViJjhSVhrYY7HKYNbOKhUvdTwAMcmbMo8ldXcFKaI8xLYdVAhGKYoCFveoQq+EvK7lkUEaF3b2hUYfuWGeqFp5HZpeB/aMLX9tjQFgsF1Ud/vM8tAZB2GwyNRgSEaAOkBRH/ePxjZbxpBb+f/q64ZjWJFzv3cw6j02d9Oyp4QX/Ca9cXAhn+6Qe3ECYjnvcvk4TJgeheaA4wQpzsDddXpearyr8DrJUXq6QezGHrByd2gPees2Q7UBxrQ6JRAYfGARwKgpLFOIAvU19jub8vIDwY8BDsxVXT0gjJgeUhxXCyPvMO2Gwf33NQKESSRo7e4z9CoI3gf/v7Ui0DFD/WPfDebrvBB3brKFQYv/HQhMQk8INi9aighBpVaXYOOchELScCTtrMQ1N0PDVZaIK/ksa+CbGyS6DSdfOYRZfZzBsvijYPHF4coO8HOXMybbNIu5j2GMbFnNf/EdFoY6dUIdDa6Rd6UPSWtOVvj+Z61rAS8lsQ9LZeb2M0th0I/dBLc5ElKPqUzcm5dEzvSgk7+eYldvmpC0e6R7hjtOfl68+r94/N2LBBJ00p5k3DJOOT4WNcAG3SuW5jgmh5Qe0j7Dz2YfBGgdta7DIX7wFi/jW
 Xf0iOpBG
 sqZgWr4cXBGAz2NFAFQn6M8wHlGARpJ3SBJpRJu3xvCK2tFAs3MVWDDDugAbS4221wCSx55yCYCGDERJKvNUs09UlxJnmUpqHsG8tVKe5iQR+Br20n0bTx67c2dSYX9Kk8mCZ2mhIbB7L6aYSD4nEiXjnXGAxkGZMGR6cUxGQ6d4rdUWZ/qKONJOYzvS/HS0J2cdT4ya73ikhHRfs9OrzHcQa6c98iYtYt9csctkRs/nsTKuSNtxqmdrrZMyZCFcCAm7D3nRkW7pVJdX4KUSJy4fLLFJWKZCsLnsDXJ06elmEd14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 02:25:51PM +0100, David Hildenbrand (Arm) wrote:
> On 3/6/26 12:07, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 06, 2026 at 11:15:57AM +0100, David Hildenbrand (Arm) wrote:
> >> In the past, only hugetlb had special "vma_kernel_pagesize()"
> >> requirements, so it provided its own implementation.
> >>
> >> In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
> >> vm_operations_struct") we generalized that approach by providing a
> >> vm_ops->pagesize() callback to be used by device-dax.
> >>
> >> Once device-dax started using that callback in commit c1d53b92b95c
> >> ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
> >> it was missed that CONFIG_DEV_DAX does not depend on hugetlb support.
> >>
> >> So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
> >> would not pick up that value.
> >>
> >> Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
> >> implementation. While at it, improve the kerneldoc a bit.
> >>
> >> Ideally, we'd move vma_mmu_pagesize() as well to the header. However,
> >> its __weak symbol might be overwritten by a PPC variant in hugetlb code.
> >> So let's leave it in there for now, as it really only matters for some
> >> hugetlb oddities.
> >>
> >> This was found by code inspection.
> >>
> >> Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > LGTM, but you need to fix up VMA tests, I attach a patch below to do this. Will
> > this resolved:
>
> Thanks!
>
> I assume that should go into patch #2 instead?

(Sorry missed this on first reply)

It doesn't matter too much from compilation point of view but thought it made
more sense as this is where you pull vma_kernel_pagesize() in? But I'm fine with
either!

Cheers, Lorenzo

