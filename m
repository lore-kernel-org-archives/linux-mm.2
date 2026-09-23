Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D2AFC9830E
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100256B0088; Wed, 23 Sep 2026 10:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1A26B008A; Wed, 23 Sep 2026 10:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2D06B008C; Wed, 23 Sep 2026 10:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA7B96B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:59:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62301140839
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:59:10 +0000 (UTC)
X-FDA: 85245334860.29.355B500
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id BA9C6A0007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:59:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxODoNb7;
	spf=pass (imf25.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790175548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gswDY1mG66Lwu8tE7+G4+W7L5mN7cWkxPfHU3SkDVKo=;
	b=aoPul1jLGiH357cHzmnX4/f60DB0PpUIApp/5pw4pmabNYGlbVOBU0iDt99LOwucxwkFdf
	Vbo2AEltVzXXhTfF9Ibd3zE0/5JC0zPfQCS196EwubY8kdoGxPOXGF2iR5e2fjgFwbDgeQ
	CKQokd2eFL790B6qVLNBVHsA8RIwcKc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxODoNb7;
	spf=pass (imf25.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790175548;
	b=S6WfAiE9g3zY5Q2HuY+yafIFowX6uIuxqaJMBFvYbFVMA4ObR+G3O/MvbBMTvGqbc1y9DY
	mei4UtL30xkq7gJl7qlHmg0VRK+XHid+HUUdUTepuqTv7doxzgp2TKrWItrtuVb/CD2JAF
	HQ3ZSzmsMkBEPlEQ9ga1riF4zSYhuC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B53F41848;
	Wed, 23 Sep 2026 14:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AFD1F000FF;
	Wed, 23 Sep 2026 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790175547;
	bh=gswDY1mG66Lwu8tE7+G4+W7L5mN7cWkxPfHU3SkDVKo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gxODoNb72NWn9YPpDe8KLIfANsjCxo5gtqjTs0tVjyVQLSUt7VjxY4odyO7h2T0nC
	 o4xeysn4SqbjBbrzO/k8BC6P1zv9vl39VCVI9ZQ7IOhYkLNyT6sllXj5fSpyE5qyVe
	 kAe4GlZ84iDl0ZDLt9081Bf44hBYpqnANogB3sSSAe4bYi6Nt71WpYEqApRXHNHQFV
	 lsW/OSUjSOhCaTupqB/rAoBRuvGlM5KaAA6S7fHWuC1YeKSSi9S9ZLdoFOi0P4jEFP
	 SY9nq/2ZAJRRqMiLkoe+vZrhbLNj0eg7oSntaVwEl+MhSA8FXaTng/Ah83KmnM661J
	 SANvHw/6tOcAA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
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
In-Reply-To: <20260923130611.GF1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com> <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com> <yq5a5wzw2ree.fsf@kernel.org>
 <arOspFxWZ1DjgcAr@arm.com> <20260923130611.GF1540250@ziepe.ca>
Date: Wed, 23 Sep 2026 20:28:57 +0530
Message-ID: <yq5atsng10b2.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA9C6A0007
X-Stat-Signature: bz1uoejnk1otorurq4qdz93b33y5bkjh
X-HE-Tag: 1790175548-470665
X-HE-Meta: U2FsdGVkX19HroduJ0K27bfEHi6hR00wEuKpfhlsdSyjpA19gfgJzfiigbuX7b+zicAIhq88T7IKWudUoKqz0CpZm0AxS/V1Wv/AFTNf6lnTv2/aqxPqcDB15HAIJBtnmiDAvgJiDsAKrngTXR/RvJzlDlVU/GqIdQVRQco/oZo0WW5dpvBYiKduf4Z6sYlg7++p138WIg4W8tYKOx+VDWycCh8gq1dV8T77pQwKyr7MuDw3q2hANNX9rBHlLZbkocWrFBKU0S8krY2NSwlUlDHyDqSTEsVuLydjOx6wW4Z6pDvjM9ZP9oIh20JUjDiPxiNgq8cT+2tTJ0v0+4KJNNaoEZ/dEGt8bIwp4isUGdxcb2uT1hl9hUuTFghiM5q/rZOp9bunf+WPJw2DnXz3xW0PDYZC4ojQpIHYOlLLBatvDLEgBPzARKnT5ihf9TdETCjpEIJ+Y6gfmjduzo1P3yTDR2GfVB1skHmchbCzN4mjEGxt2InSPM9THD7enOdbEF+Fd0/4Mep0weyBXTCsvCFH6UPdP16PQzLQmNBU+R6sR9WnwefIRgu9em9Khq82r7ZEcWOx2djjz3nhhSsZmqHkcjpfrCxvP9GyenYBMDHW0MbNfCuhcb6PsXGX6yh6hIbIo3FLHhAP0iPUwfCNihwC57gLTTeylfCRbkRQt4j7qDIUCi5hPflBkzHqmsn4W0GDCBa6C3l/1zQqf5yTFjakPPadz592N4op5w3MjSAGbWjjEXOupPNVyAovlSYkHt4ea0xQTnkIEI/0bYJPjqddaCftSaWLG5waOIZm2wp9MmRC3Ok0n6SFkY+w19WP7OJ3VA74VarsIU5IgpN3BY3lweGK3W07sFfbNUmkd2CNRS2/8LVr9fNHWfmKh5OEJd3ek8UlhsxqoVtz2HfhAuvTgrwrHR905enDWJTNIGlv56eMpan3Ojw9+BpWX4nTCECOLGtZEVuveiWWDIh
 iLMAndyT
 tTeOK4xpsLSUw2/D+5UqH5b6pvE7eRDJsfUWBPrS+KZiDm/hrk/IMhrEuwLC/msws9+KN+5MC2xXQ8VmcwLOwgW7rMLo7OOI0SVwSaZ3OOgV5ODLAOKP84CGPJgOabS+P6WG6Q2HZGv7YYb+vhsJxdBKqY+Y9EJ/tpt4ogwYfSTl73T79NEhOV/2empcGxUB8Jn8c8iZdQczP9iocnvXgl6B2u9G4ySr29wCvyL5eGiV/3mXO3jiboZ812ProIZqsDgVoeE2glb8xLWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Wed, Sep 23, 2026 at 11:40:36AM +0100, Catalin Marinas wrote:
>
>> The simplest is probably to always zero in the backend and ignore
>> __GFP_ZERO to the allocator. But it's probably only marginally smaller
>> than passing a CC_SHARED_ZERO flag down. Get codex to try this as well
>> and compare the diffstat.
>
> For patch ordering I would convert to use the allocator first
>
> The semantics of the new API should be clear
>
> If you pass GFP_ZERO then the resulting allocated memory is zero
>
> Otherwise the allocator does Whatever The Arch Needs to not leak
> private data out.
>

ok

>
> Once places are converted to the allocator lets go see what is left
> and ask why it is left and what API it actually needs.
>

I'm also considering requiring the address passed to cc_make_shared() to
be in the linear map. This is currently required by both TDX and CCA,
while AMD SNP appears to support vmalloc addresses. The only user of
that vmalloc support is Hyper-V VMBus GPADL setup
(vmbus_establish_gpadl()). How should the generic CoCo shared-memory
allocator handle this?

-aneesh

