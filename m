Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746E2C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87A856B0096; Thu,  6 Aug 2026 10:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B556B0099; Thu,  6 Aug 2026 10:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7418E6B009D; Thu,  6 Aug 2026 10:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 526E46B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:16:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C164DC0740
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:16:26 +0000 (UTC)
X-FDA: 85071044772.24.5E36255
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3543E20009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:16:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpttzweg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786025785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyYaST7r1jnOM3k+MKVb9LOG4FPzienjqXCxOdXjJgU=;
	b=oTedx6j+WKcRkB45vSkhG8bXde4OGjdAyEGpf+JUWeJQNR9aq1ctQSNNnB5OhKddpmTnE9
	twMzxhe8/jHC/IM2qcvoYFdwJpvhf3t3MWyjkVsRm8Y/2MG54Gimd0QeaYreQKfzZld2Jw
	G/HCpUF0bAJD+jeTMKdTlqaPDMuvIQc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpttzweg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786025785;
	b=l1ZAE5vLsB15GUUFTS0hezqC51Xlm0gITwluZLIFDGbsnSFVvSO9yRxxXCLSFZC1HU+53y
	iojyOuCVqmno5rLmwRB6JRvTJou33I4Qby0phwX11wSTddFczTrgmg8Fc3CQPXTLi7xWxa
	UxwD6jdVGmSgyErf1GKn7zHesTQ0zvM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63F9443BA7;
	Thu,  6 Aug 2026 14:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BCF1F000E9;
	Thu,  6 Aug 2026 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786025784;
	bh=tyYaST7r1jnOM3k+MKVb9LOG4FPzienjqXCxOdXjJgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cpttzweg9qtPVh9Q8WfM00+sORYeV0+HAn1rFgQ/rETFLSunF1cXZ0ddYTmffUYCT
	 SEnOdYqGd0Fek2jQUQnVckLtjJZKtjFcvlErbKQ5nQY+Lp35mbPBD+B5XEt9IiVdM0
	 ti4WGmr9crql64KUn38hbacKyRMVffQ/NpO5pMeIG3EsKxFQ8p27TNAFTAUi6yT8/k
	 O3C6XATu9oPDRY9WUTledhv7+Vlp8fpHkCXKn6LpB8wYf94gS5QLbSLiyzl5Gr+huS
	 BW76nGCLM3xybUHnVEu1rmlD6w+3OCU07aVhAWWlolfjVkJdmW/jxJ0uaRDc0+6jEI
	 lVhHjtKJC7ecg==
Date: Thu, 6 Aug 2026 15:16:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	damon@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	sj@kernel.org, akpm@linux-foundation.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	vbabka@kernel.org, jannh@google.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH 4/4] mm/mempolicy: skip zone device folios when queueing
 folios
Message-ID: <anSXFHZZPUf1iFSm@lucifer>
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-5-gourry@gourry.net>
 <82f6afba-756c-4ffd-bd5d-c3432179af28@kernel.org>
 <anSNk7zgoGj62CWk@lucifer>
 <0c90b9ae-48ac-407f-9d73-4c501c82cf40@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c90b9ae-48ac-407f-9d73-4c501c82cf40@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3543E20009
X-Stat-Signature: dux9pe5s7ho9sgs3jj9cmuokc46xjaia
X-Rspam-User: 
X-HE-Tag: 1786025785-557618
X-HE-Meta: U2FsdGVkX18az8DlfvWABngHq6bo96kQTxmoFQHzO6lS4U1p929YHkvnZXBigUP61T4SG/4/J8PVBDUqYm5ZoisgLSGN8OJjfQBS9l6GsCosdj1Gc6Ymx+yO84Ec6hKZE6eLVAgN0jAUnnmRBgLuvZcH83IKWPOsrdRIg2YKlbOV27Fwc0xNY63u+V9fkiknglKsLDPIePr1ARcR9JudgaN8nHXSjPFVXFIWX0iffZxxuYmJNiGRONl/RK9wKd1zHBiT/wHYKCth+wa/DJuRrgTjqJLYryQ65+682twNGr98tAQel+KTBD3rrZX3pvD/MLWzAFZGApxgELwHpswoa+otnzZGlAMNgZeNe6bJo5utJtdoXPmDE88Xow3P4yTuZLLQ2bc1vQ5ZI5I5nREeM88muxHfMu4GOhIDjBLIJeJVbLsDtWSNsYwa8dKZTOGLqU8f1VCuJP9djlouZvXPBgdP876rtUn91uYqy4Sla90TfvVwxPdvDqnmG/ytoNQQH6p+5ctjLlRQ2R8QHpvTMH0x1917+cPoEeZtsm0ndjn9qtMcHAizwoM8QDFn3axW5HSRT/sHX+xXaJO0x9gXXm5FHeaYupksn8ONOIigS8XPfcOjhRJPgDQPuWsHpP9OiIeKRJHNNNgIa2kWHKM70ElQDOEGZKWkiQCYcyl4C+Vn+Ou5iq+H2sxrlId/yDZZOG15WtiP3nXhNH7C8oEYXxsMGE2uA36PxrS2/8PJ+cE1dnoyhwb1HPICWVkjBDfTvCv/Rb0FyhUo5HsnGcpabMXiiXGKOYdjzCbP7uapU8OpHMfSljRO/XRPHBW0spP71wI+0C7A+0A/ohgQuzK4ikYmFwNgSceZkml83w0Q81E357yIlzDHOpb2K0lT+ezY9PRoAw/zL5pg86zFAvXw88zP9IgjY/UlZLI+0bRBfSmyGg++KmVyNb2GARGp2fh20Xr3BWqh5SEb/VVT445
 su2pBecm
 Ky+QaOW4RkGbWegprCHz0f4H+zH6pBp0Ddt8TSwuTE0rqC0montpNJf5UrTIKoe7CzJt94YKm9mxKwUK2apBiIkufJj27Ff53X+yUzPVXg43bhtPd01r84ezoz1Nzm7cVQAshAFWTRNJ0gqxpiDWTbgooIDQsGLuymjLvgkIs6R4fo4hpWNgu08t2edldvkf494M89V10CHE/FT2y5Ue645K37vfoy9HKYlDREzww3s54xD1JPbktuRQY+mZlC0/Xqa71v45mNA2wIb7nQAS7FVZW+SBX68XVp8F/5z3M+ZSM8CkURjLEGDgdtRfjvZ2Ti9If8Txcfbpno0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 04:11:21PM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 15:36, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Aug 06, 2026 at 03:25:50PM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/28/26 21:47, Gregory Price wrote:
> >>>  mm/mempolicy.c | 4 ++++
> >>> @@ -797,6 +799,8 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
> >>>  	folio = pfn_folio(pte_pfn(ptep));
> >>>  	if (!queue_folio_required(folio, qp))
> >>>  		goto unlock;
> >>> +	if (folio_is_zone_device(folio))
> >>> +		goto unlock;
> >>
> >> Leave the hugetlb part alone. hugetlb folios will never be ZONE_DEVICE.
> >
> > <Insert leave Britney alone meme here> :P
> >
> > But dear God we have got to find ways to stop hugetlb being this big stupid
> > nightmare that every single path of mm has to put an asterix next to itself
> > about!
>
> Yeah, possibly unifying the code (possibly, because it's a mess) but not
> replicating checks that don't make any sense for hugetlb.

Yup agreed.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

