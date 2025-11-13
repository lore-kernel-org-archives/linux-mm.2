Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7FCCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6578E000C; Thu, 13 Nov 2025 13:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CADB38E0002; Thu, 13 Nov 2025 13:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB5F8E000C; Thu, 13 Nov 2025 13:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACF548E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:44:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 480CA13B94D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:44:42 +0000 (UTC)
X-FDA: 84106460004.29.683AA8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 71A544000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:44:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pC0cZpHv;
	spf=pass (imf04.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763059480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIbcxtUs2WANG22zdr2IA7CVjhetoWXTZzjAD8xbfKU=;
	b=3GaX7k0I+8ZQyEuLd8m9hX3/tfb1DoeflyBZr4IiuQm5dnoghbUrBMOgXlTmcmXIunLZZt
	R+RGIakDcFG8YGCBgIXqiTlEqmwpzS+/0QMWdxBRsbOVl7Nibdigx6UPIhRhf9zPcqHSO2
	4wmWy/Pphd6YH3NufRyHPm/vEu806T8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pC0cZpHv;
	spf=pass (imf04.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763059480; a=rsa-sha256;
	cv=none;
	b=EfaCbvGDu0IS2E4yn6RcmN43eN/DCs7Qap7BqeoiN+FC2Tx591nv1MXV+uJWQhcvYpSU6E
	+HyAc1rqh+wB7AFaGZ50hVv8QRRAxmkVJAMQTu5HmBWuGRiYppOincVgUbLR4o4zcS0XZ8
	EDSCeaaptTrfApUMiP5ca81QUQjorJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94237439BA;
	Thu, 13 Nov 2025 18:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9161C19421;
	Thu, 13 Nov 2025 18:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763059479;
	bh=RE5P0X9RyxwuZjuBP8m4q0k+WYSIyGbR3hJ44uf4r7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pC0cZpHvF6d0hLbVgoHS87+c6/lwBz35mdlUvl+etMUkoQnyYhzYKdq2Y6LU9nGsL
	 TyIbKCToQbXil/j7Hqc2snvjgEbSuvrBmloVgxHooOPwgNH+R0THEcYG4brJgOo6M8
	 bqZp04im0C6eLsy+xT+Mro2rnnIa+sLi32Njq6GAliFD2kKvOJkNmUSsSp6CSqWxjD
	 gXUyK8iE4eLp8CE7dWr+FSbvrhhoxms/LwucBVOTfQjAdZGyUEuJe5ycL/jzDB7B5G
	 c+urL7KgfK111uclHjIboI/TfOcSAS6d252bJxTcdqfHzq3R+2MwtEVtqZJeohqgxr
	 eCxQROZG94TZg==
Message-ID: <027b6ac9-836d-4f89-a819-e24d487f9c8e@kernel.org>
Date: Thu, 13 Nov 2025 19:44:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
 Sourabh Jain <sourabhjain@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Donet Tom
 <donettom@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20251112145632.508687-1-david@kernel.org>
 <eaf2e733-f967-43bb-88e6-7876a28a370c@lucifer.local>
 <3fa6d496-b9de-4b66-a7db-247eebec92ca@kernel.org>
From: Christophe Leroy <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <3fa6d496-b9de-4b66-a7db-247eebec92ca@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 71A544000A
X-Stat-Signature: hd39nauxp9r6ucffr8xo4m1ea8mgsyty
X-Rspam-User: 
X-HE-Tag: 1763059480-776436
X-HE-Meta: U2FsdGVkX1+21QAeRX2F+gW+yA8QFNPH56PDDA5Bn55p06qpYh9fxXodfwFsW0kq/KS7mh9G2twOUQpdGl0H9v/J2ubekG2SKDQl7j37vBbWByKMfKFB3tyb4SSdCznSDBkevSX/aqSeJrMTVQ1OnQ635NlWhahxf1vOywLXDcJkTZdJy4jlgOraXdVMccEyazayBf1JzvN5M9shEtz2Q04lRJ8ZmigFWWUVzSx+g2wMker1j0VqgK4nmXOJ7v67JTlQoEZZA5dzxam3T0yL9wBUsmwyD1HSi5AA9X+5KGUaE54Y/ZvZvbcDrh4nVICFUqYjaraBiYMGl9Fg9iDK0u+nlgn7ud0QyKZGE0xE0Okp27lKILa18KRB5RlIEjxnTXNk+ShVQHDVlEzGvP3iigrFCD7auEgIbd1LgIc+qb0JogZXffxUruGnJc0RMc2e323BnPrlwdBQZ/Monnfi1aMN04SfIlkG4tdf2N7BJOyVF7C8rdRuSigv5AoOwsJP3Uv+mXAiDDvgjZ5O9nF3SXyourEl0tDJU45Tfu7y9swAt9wr58V9P2NjdMkzCDHSf8QZu3zV4Pw69cVivvhMYwjuwHmNLonV5C9fDUptrG3qaW/bF7ZU9biMv3OWsJKiRSz4uvggCvciKtsD6pft6wpCnr/so3x9yj1W9w7DoZhw1yWdLGmwdcGEHwNRAfBOrWRyQYnCI5nBoJibDD7qfbDqQD/ccaWK9JUdmX9QSw4+6djYw6d2Y4+LL6h+tWmvjYG7+9Psj9+1FZkY17hbR0eKMra9ZqpF/tJTHcfl/r9Pru0UFP05c+3IwyNpEbi71FSmAPzx6tInaoGAGkWGa+DEirhBKzieIXpzb2XrkLn/6nP8zrSooZGDrb/V0C051KuZeyoEx/HvD2Zhwbdm7URq0+3UBQrdBho/HuY7zl7+I0F2CLVTs5jeUCdpfjEcTDDa4JsM5SeS+C90h7M
 dLjzVSwm
 dtueWHvjGTEnwks3Nbn6dKCE6xGco8NIr7GNvLQeAMkXu2XyShkkGWKJiudFs+sPxM70kQLZ6Dn89zc74lm0pHlD44UPHn5X8KEBgQ7Yh3plKSFDRqR3Q0fSgaTaP6ThALIi/Tq03B//KjufSOuvQff+w8Ept7GRMAsXk7YmL0lPZF+qpUUq76UrscvLwWUdu9eT+IXKP7f1jX1uD9yhHNl3NhmNFjga4LOqlb0djZ1en/7BW0Y93rg/A+FKKbBX3XxMOnqQX//8pakJ7lHWqJtXpsyUu2xyV9sWAplr7O0tQzerWpFpxL0Jv3/w1Xt7o08/FwD7EBfI0HWHpkVe1vkMGXENnb5xziQ54ebUXLmU7Mpe3wWBciZqhcqje3Dz+aDXv1E8FjaMNWsgKqNA9n8sZUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 13/11/2025 à 16:21, David Hildenbrand (Red Hat) a écrit :
> On 13.11.25 14:01, Lorenzo Stoakes wrote:
> 
> [...]
> 
>>> @@ -137,6 +137,7 @@ config PPC
>>>       select ARCH_HAS_DMA_OPS            if PPC64
>>>       select ARCH_HAS_FORTIFY_SOURCE
>>>       select ARCH_HAS_GCOV_PROFILE_ALL
>>> +    select ARCH_HAS_GIGANTIC_PAGE        if ARCH_SUPPORTS_HUGETLBFS
>>
>> Given we know the architecture can support it (presumably all powerpc
>> arches or all that can support hugetlbfs anyway?), this seems reasonable.
> 
> powerpc allows for quite some different configs, so I assume there are 
> some configs that don't allow ARCH_SUPPORTS_HUGETLBFS.

Yes indeed. For instance the powerpc 603 and 604 have no huge pages.

> 
> [...]
> 
>>>   /*
>>>    * There is no real limit on the folio size. We limit them to the 
>>> maximum we
>>> - * currently expect (e.g., hugetlb, dax).
>>> + * currently expect: with hugetlb, we expect no folios larger than 
>>> 16 GiB.
>>
>> Maybe worth saying 'see CONFIG_HAVE_GIGANTIC_FOLIOS definition' or 
>> something?
> 
> To me that's implied from the initial ifdef. But not strong opinion 
> about spelling that out.
> 
>>
>>> + */
>>> +#define MAX_FOLIO_ORDER        get_order(SZ_16G)
>>
>> Hmm, is the base page size somehow runtime adjustable on powerpc? Why 
>> isn't
>> PUD_ORDER good enough here?
> 
> We tried P4D_ORDER but even that doesn't work. I think we effectively 
> end up with cont-pmd/cont-PUD mappings (or even cont-p4d, I am not 100% 
> sure because the folding code complicates that).
> 
> See powerpcs variant of huge_pte_alloc() where we have stuff like
> 
> p4d = p4d_offset(pgd_offset(mm, addr), addr);
> if (!mm_pud_folded(mm) && sz >= P4D_SIZE)
>      return (pte_t *)p4d;
> 
> As soon as we go to things like P4D_ORDER we're suddenly in the range of 
> 512 GiB on x86 etc, so that's also not what we want as an easy fix. (and 
> it didn't work)
> 

On 32 bits there are only PGDIR et Page Table,

PGDIR_SHIFT = P4D_SHIFT = PUD_SHIFT = PMD_SHIFT

For instance on powerpc 8xx,
PGDIR_SIZE is 4M
Largest hugepage is 8M.

So even PGDIR_ORDER isn't enough.

Christophe

