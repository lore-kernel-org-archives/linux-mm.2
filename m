Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25EB3C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA4E6B009B; Mon,  7 Sep 2026 07:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB16E6B009D; Mon,  7 Sep 2026 07:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7686B009E; Mon,  7 Sep 2026 07:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B54F96B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:18:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA6A88011E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:18:53 +0000 (UTC)
X-FDA: 85186718946.24.336D6FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EE51540002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:18:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F8m423Lh;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788779932;
	b=In/nWJGOFDHJ4MnF/BmGL3RyjQflftHX1ELOtmzgzpLA6wRb/r8r2PWbtVyBClHJiHdHDH
	u1MSLNWnA+yuNpyiNU/5FM2fjAdTkSJnKmYW96POHsIlAbc/GAtaExoV+TahFr+N+bKqqo
	H0yWssy/fPeQ5dXK5j4AnHoUKiUaMjY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788779932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Z/SgvhpSWZZrEnPffWXml8Hd3wiK1YMY4/p+rNNK8Y=;
	b=k+M5R/UuSpAoHvKUvuPkjuK+4jDJ7mJ5UF6F5UtoZggPM091/0EwtdztuNYytXgHm/gzo8
	0fdm3b0MZn5eerp/B3lNCS+bmmvzcsFreJ0C9gcjyonCbDd9d8UJBQ3rpJ2U3dzG44LuvQ
	hscLbeuKAlZ9bycBJS717qRZE/9UfQ4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F8m423Lh;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D692440B87;
	Mon,  7 Sep 2026 11:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D51B1F00A3A;
	Mon,  7 Sep 2026 11:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788779930;
	bh=6Z/SgvhpSWZZrEnPffWXml8Hd3wiK1YMY4/p+rNNK8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F8m423LhiG/t/9Wa6UuLgMPisSPSaM0ws6sLzcdYwfW2FEYdK/K+Z5A9zDpAI0e7z
	 7zcW1KROfscWEZhgA/J8JMfiW9sSjf23XIOE1DtFpqV6RhSBlXktdEsVQQTJgaOMM4
	 U+NDNAEYwpedUUzpWNcWoZO3jLmIdBS4eK85R8SBGtCl4vMw4N9c0Nuc0u/AMBroJV
	 oRiUG+v7J4tZ82zGGs47AX3GVu31zIt3DwoR5PgXBUt3YEZASX0JDS1IsnET4tQ56d
	 O1HMQB9Is+Yp9B8WSFxR5SaTnXfE7G6ZgJ+Now4boANlh1gpw9obeOJHtK/TEdEkGs
	 kj3KDL5gjdRFA==
Message-ID: <69db9546-d14d-4107-96b7-30963292c2bd@kernel.org>
Date: Mon, 7 Sep 2026 13:18:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: Mike Rapoport <rppt@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
 <apk8ZRr6do_YAlzf@kernel.org>
 <CA+qSx6wqd5VSR=9yarFFmyN1SyvLJqEHpA7BwmzuxNQTHbS=Xg@mail.gmail.com>
 <ap05ue1pq3TgHOS6@kernel.org>
 <CA+qSx6y=OaMsvTKUbPP2DOan3Ym6c8L5z60512-tCYeUjLZz3w@mail.gmail.com>
 <ap5Tqu5yswJrj5UM@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ap5Tqu5yswJrj5UM@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EE51540002
X-Stat-Signature: wksboqzno3dftgwbqzjmq1cjodm1k5ph
X-HE-Tag: 1788779931-963969
X-HE-Meta: U2FsdGVkX19CfdhMxmtnHcgOy35UPkhxcFKhm23wFwh3gP290uDovrZoPat3/qowgqWGJd/2/BMviMB/Gr8O2Ij1yC0mAOjvKmSLRwPx7cCHTHrftKM9ZKDE8ZTnPvw5u56NQaUmZCH2B0wWF/qY6ylaxB5CkNMxFk4xuJZ5O7BfxDFkYmg/W0jbkZv8wiWNya8S3CK+QRd5pyufrkxBByQMa1jdVo00p6rMCK1Vvldfi5jMFOLii9jdky797DnF1HrQkB15Z2CvNi3zi567TGWdHCbOjukNrr8ZwMXABUSRoIVryHm4rbVhmx/p8KdjgqPk9+6P1ygBe+3QKWvNH5ImT2ogkhzlV85vmxf6v7imEvExHNv4CyY+Y5DfG7vdi/GgXNSlnYwCuvhEc6842qglHB2MtYk2XN76l3dT4dWm8FQuXKjaBVovqXcUNxLd48HAxZzZyHBN47zIk9iAM+EOVGmvlZTIvzXD3hazuNsyU1QQiRLC/nCR1loI4J/KD6r1pfs1q/aWE+OipPcWKn0bPQc1GbxeXAk/BFaaCsSCija5s+0vqVXv6hSNbCfFhe+oIUnoIV8+vPnbmTVkubmEVP2+n9yh5vnjMnyHKmCkDYglRXGub7wpkj2Vw40Gj4vpFlUScERlEr/fPF9SrlZBdr4N/1evDML7az015RGMf8M/yKAfq2xtf2jUDN4tQIpRkIZzD6mn1ZraujWz+/NEHtLX8z3ESpX68OB7Svhvc1pW3J7kp7xsbh1teAYmBs/zuR8xzrYynSAkBjJHlbhaN1DOvBCq9LxwDFpPiOsGlyXQOJOr4N1syBsPvEl1g66TGaC8koTn5VFv4kPw17WFr5Wg+T7rTpE/Qs6vvlpGozUSiEaKcxbhp8Zq6pLMiJurGOlzTj9LdOjpLu+yomdTocVLru+BpcQBn6G+eOb44VWZOt8CPdQXNqc+1VkEXril8pSpOt3BLbi+JPN
 AoLN9vnF
 Yi8SatuUiweCP9/Qjq+uWgx1CVgg/jinTCflKcjbIynoTqL9NE3ZZytvXlYuri6zkDZYp2rNRhWJIYkHHFbbHHkBrYoI8K5D0DAit79vST2mLA72Mmz9n1Jmq813maI4BnfEFb/nuJ0gTt5AmhEkGdxlfyKx4nEeUk11J+ZayBzBGWE6IhnLWPmeTGSpptIGpYzW2sYexsI7zR1SpJxt8W4WXMUAl5KakRll0nQFYzAL2gBrfJBKc7A6Zr9ZM3K5uog44KIYYditrPrv/h9/ZuKnUQI32msACrnEHJcmecFYgEwM+YxMeINV2UV0Dj4Ldwg5XccLVVujL1qFPO0kREL11NyhPcQ9WfOUYRjTwOcn6iFmKj7u0EcLBMmXQ1+j71dWZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 08:03, Mike Rapoport wrote:
> Hi Xueyuan,
> 
> On Mon, Sep 07, 2026 at 09:11:14AM +0800, Xueyuan Chen wrote:
>> On Sun, Sep 6, 2026 at 6:00 PM Mike Rapoport <rppt@kernel.org> wrote:
>>>
>>>
>>> I believe this is an historical artifact. change_memory_common() already
>>> updates the linear map when a vmalloc mapping switches to RO and the system
>>> supports it.
>>
>> On x86, set_memory_ro() does work on direct-map addresses.
>>
>>>
>>> I believe arm64::set_memory_ro() can change the linear map in the general
>>> case as well as long as can_set_direct_map() is true.
>>>
>>
>> On arm64, I'm reading arch/arm64/mm/pageattr.c, and the linear-map
>> update in change_memory_common() is only reachable for vmalloc
>> addresses:
>>
>>   set_memory_ro
>>     change_memory_common
>>        area = find_vm_area((void *)addr);
>>        if (!area || ...)
>>           return -EINVAL;
>>
>> So set_memory_ro() on a linear-map address returns -EINVAL on arm64.
> 
> And I believe this is an historical artifact rather than necessity. For
> configurations that allow set_direct_map on arm64, change_memory_common can
> update direct map too, it just need to be implemented there.
> 

Are we sure the other architectures do what we want in their set_memory_ro?
Having a dedicated set_direct_map_ro() with clear (documented ;)) semantics does
not sound too crazy to me.

-- 
Cheers,

David

