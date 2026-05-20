Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53432CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC1D6B0088; Wed, 20 May 2026 01:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C9E6B008A; Wed, 20 May 2026 01:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B7E6B008C; Wed, 20 May 2026 01:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9691C6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:29:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EF261C007E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:29:39 +0000 (UTC)
X-FDA: 84786670878.04.0EC0146
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6330D18000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:29:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X23CFmgU;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779254977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1OH3NSONJWgCB3wuyeoHrGpJVk6tT9/Xvts09nG7/k=;
	b=M4YlOrqKOP8SuSUbXgzU0Ml3s77OQXKj9evDatmBur7MPSGkBwhHbYHbDXJH/MPNJANfa7
	DveJOBTNF4JCUmKd5I5wrfT/ANjtnA1v3yvb52Z6PhuaxZEzQkCn33HtPyIGRC8GQATUUr
	lbfaV6Eh3hsnLeTKphKj0R7B6DSXpm0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X23CFmgU;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779254977; a=rsa-sha256;
	cv=none;
	b=UP9icqcMOZMgbsVzIXyqBYt+4rdYizXxv89GkjF3lvNFycb0hxaWSxfj4ImevzLr7VX9fQ
	JJ2jNm0pT9WX0XQfa3f8MgRouL4SjItyaQD0o4wTr2wx39Kjrm3K9RM4mj2csEDvTWRYoA
	rQ8uvvWFNC+bT2WuemE+KAUMVOFxlbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 685A2418DD;
	Wed, 20 May 2026 05:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999261F000E9;
	Wed, 20 May 2026 05:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779254976;
	bh=s1OH3NSONJWgCB3wuyeoHrGpJVk6tT9/Xvts09nG7/k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X23CFmgUunn3L1x56i5oNwRmrRUKPDfvcLKR7jdt/D+IB+9PInh45UButGXtkrgtP
	 wJZVFY1SVKpWYGBni/Je4htaBNuXgdrTT9B2JN/YsOfHvcxocvNgknq1YuZtpTdYtF
	 +fYuNXeeTJA4GVedpjy6utOdSf+HmjHUDWqEPCtNiftCYWav7oyBtf0jbXJpNDIRjn
	 +yjO5P5qidI6yioyg949eQlO6Ssn8XqK2WVi610Gu6IIIT418uG3D2I0aiaaKq5InA
	 /Q7cs/KjByvIx9zvVzXmEyH4Ns9UJoetLUhVVtujN3K2YLIV9d7b7D0EhC6xoHd+FJ
	 gn4kT+EccM9HA==
Message-ID: <21286ae3-d8ee-442d-bb8c-fc741b9c465d@kernel.org>
Date: Wed, 20 May 2026 07:29:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
To: Andrew Morton <akpm@linux-foundation.org>,
 Balbir Singh <balbirs@nvidia.com>
Cc: Sunny Patel <nueralspacetech@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260501115122.23288-1-nueralspacetech@gmail.com>
 <20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
 <5b25ef69-ffd1-49f3-a340-db70dcc96b29@nvidia.com>
 <4c3eb1b4-1ea6-46ea-b04d-b218ef266c7f@nvidia.com>
 <20260519150010.a1cb46f2c8478414117d6932@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260519150010.a1cb46f2c8478414117d6932@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6330D18000B
X-Rspam-User: 
X-Stat-Signature: yn6apmfoxzk6be57rxptmnfz6rb69axx
X-HE-Tag: 1779254977-60897
X-HE-Meta: U2FsdGVkX1+6pWV0aiQ1d9++sZcVgm4bZR3gfTYvCANnO6aeys3wOQ79Ogz9gngouiid5qyu77B3Qo1Fkyr/Jqtty4M7Y/TSlU7pGskzXD1umQKakts7L+IY/RhuNGdCYym77sU4oM1Wey1qmUrvUhfJIii7wIHJshdLbVYMipevPj2BNR6dx77oCl0qFRB3JPaztuS2FSKq9bRR9nVMo9vYywqip6pAs8B0XxMMm478ZxDLMvXv+uHtmdnmxjUkFiIb5h+/gnS+43djJ67pcda6GvhZmXSllrEuke8YN8uAktimRZ2xWIGp7ErPSbRIX8Ijb0p2rBIS4gyqESvGkwjXomuiQJFP2ppdj9Ts8cERzLDDKOCXr/3rxo5MTK2aVQB++d0/Xj5HBMpg4iDSKiAsoWUdVmjx2QczJfiFrNxFDD5C65DkkQ2dPN1aE5+Fek7dP35AJkxtZyaxbQXtLVaHdR5RGbO4PY6voHHgvMp3/hUQzjXUwYzFzePGR8+oTCD1Sn2yGItyFz/fmxux2zs7iT2d+5Y70197FAa1pL/OMDjTpqJPoP3nHffLE6MxvOvmE3nR1fi6ed1lvlgLMgneewaGQLdU8Od6ycHtqOWpVaIIdq9t8M1846OHqmCvbJB2tqz98Dtj2gyI/MMH/rCuTuqg4OyS8i7S7UeIl+tWJ/alene9GfoZYS5zbrYCWubUC8uhTeAkMZBDFKionuQfMms1JL9bjb7WSP9ueCTmetOKwl+QNnElmm7Ej0LIVtptWvGgl61GuADzAomMVeAbr4o44NWKLdGsC+FySVccN7v6k1jyxQM449kuSZvT+NCdeJD/17kU7wszCbDaOZsaI3goEMS45r+/FZVmZWPD+QeO0g7Qgsv1LaCU8qb/89bqA4Fjj4gbakrhBrAbF83eMvvau7BdP7jPcejQSuZE0IDFA21Cd3PXJX1+Y/R8K26sf9kHWUsfM4fRaSf
 hzVkw6nZ
 KKHMeS05ibzAd5g+fKd8CBm1PVe/hLwiI3uE4yZoc6rcGazp7H8na5qNlgNyJU/fAinTlwoYasSf1MVFOfYZlaCGsb13khfELx2DzwjpBbdKjeL4wF5Nu8En9sTTa6y24gMhFBsAd88s4AVZMqSArOmw7zZ911gRZhgP1CvbP87MU3EqpVz9BJvPTcmVJAvqrA2hJ3na6SqVAdJaS0/pVSepGTW6M2pa67WF88+MWXghHskyuzPydTwBSdIg4CDY8Bu4ejULBwdNXMH0vdwtFMppYHo6XD0KkL9Hs1avRdQK+VFFO2bjoLuVP+OcIWmZwlMtMoaS68bqyWnQS/Lrv1PhawvLS72DSGU/Lgmx6L2ceOQtmK6JgtJSL1NgFzqbgt9AC0PrGEmsSpfej4ijfp+PvwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 00:00, Andrew Morton wrote:
> On Sat, 2 May 2026 10:59:33 +1000 Balbir Singh <balbirs@nvidia.com> wrote:
> 
>>>
>>> The issue can be reached if we try to migrate a non private/coherent folio (I assume DAX/P2PDMA)
>>> pages. Even migrate_vma_insert_page() has a similar pattern. Creating the pud/pmd/pte structure
>>> there is unnecessary (but not allocations occur, depends on pmd_none() for example), do we want
>>> to clean up all of it (need to think through)?
>>>
>>> I'll re-review and send fixes as needed. Looks like David sent some fixes out, will review
>>> those as well.
>>>
>>
>> I checked migrate_vma_insert_page() is no affected.
>>
> 
> Thanks.
> 
> What to do here.  We have a cc:stable hotfix which is adequately tested and
> seems to have passed review.  And a cleanup patch from David.
> 
> I'm inclined to upstream this patch as-is and leave the cleanup on
> David's TODO list (one more can't make any difference ;))

No strong opinion from my side.

-- 
Cheers,

David

