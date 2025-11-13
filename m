Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF103CD8C8F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 15:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC53A8E0005; Thu, 13 Nov 2025 10:21:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9CB58E0002; Thu, 13 Nov 2025 10:21:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8F98E0005; Thu, 13 Nov 2025 10:21:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE4BD8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:21:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7644CC0A57
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:21:50 +0000 (UTC)
X-FDA: 84105948780.21.61BC94A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9AD19C000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:21:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uaXIN16e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763047308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIAMjwImOBRNCPZKc9ifwEuKpxWO9qKA3942dhlI43E=;
	b=GfT4HsfWGfCj6rjdKJgC0o5HxxiNGbG2ZEm1qRVv6C+/VzkKxUiB9bpNgozj8SBp/8++Zd
	axxlKCFqFxYhwH6DccMq9Di7hHcRDzgwNj2CibPa7Lqukw5QBM+rvzfnXiIWLZC0dpTPG3
	rzH2nLjQSwjh0ZuAoGWsbzLj6+otG3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763047308; a=rsa-sha256;
	cv=none;
	b=sjS4pkoQFqt/rnz5Eh/+tA5YsJYy/QZldce4iV3jjWnlv1EIafeSkgTTk5Wk6CpC0LoZ0T
	tDZ1ebjqqmenkT7y3Y77Rf3pm+tVlU+llT20uRy8cdqTF9+5WWcz/EBvDPBwWMXCNcUPJm
	2jLElq3qSZny8oKmfd9udpEgm1Y68ZU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uaXIN16e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 591C042E17;
	Thu, 13 Nov 2025 15:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A83C4CEF7;
	Thu, 13 Nov 2025 15:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763047307;
	bh=DDR6lwZeYHTpioGw+6ohDncoc3q5Cexlww6K4aupOIs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uaXIN16ewn7hEVzRKZDArZ+eJgUCAKSHAt/OloF5MCrMEAN4+PDujpsLttqSSWqVZ
	 mltOkv0VUkTgYtrxwZWW0VuLZG1LR0wC//pusw96qsO51UtUAKmHJP1jkyv+e8zWif
	 oDRaOtAan3PpeL2lp3wJ4mb38iNmLKQEyDAuve9pMq3iIPnjpUH90GV6oMjnaPFzF3
	 5SgxbgErxNpY8LQHDvZme/zp584w4IxmkAR1ibY/hy+lZ9OYnfKhGKJOCBeyRVwGQ2
	 HU14ow4FJeWd7gy6H+MywTHvJzy0KdvvyKRVnAAl3kdlmUJfNnGPKkgFF+fSyBwphb
	 lNQNoU+rFSXGQ==
Message-ID: <3fa6d496-b9de-4b66-a7db-247eebec92ca@kernel.org>
Date: Thu, 13 Nov 2025 16:21:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <eaf2e733-f967-43bb-88e6-7876a28a370c@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: god5pdtioo3diqj8884y8p4dxskefzu1
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AD19C000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763047308-588156
X-HE-Meta: U2FsdGVkX19PC2Elouao/OD5KIdrydy22Z86NG+xH7ALHuff6pHENDZKuuIw5uLlxA440C7LTESi7p/fstQPnKtCFRizEJI7ovd+OPHyo6xTnkKBLPuMVy8mkk35aB/707t97oDcv+VCLJ2cdLEfNbllmG0YP8anlc+DWW2ky6zZteFZy97q2NZx0wuKlJ4jJXmExepml/d3Vtj3EY1o+W0Klf+lY8TE6co1kzK9Ku0a8gy15Q7qztTBq5dV8vjbEmBVJEx3g901iJVX4R5wVm1ZMUNRJpZMqk4GiB36ZNu9fhTGpToGGdidm1G7SilH5W2hsDq9Y+qimMGlH1x3bdBAvrAG9KBnTTtDAXul6xk52S4qPw97urZ1UrJB5iFaWY/lDw32OO1jN4mkamFmoizvm3EZr+kipnganSrxqKg8zgwmWEQ91Eo7NmqoGjn/Rpc5kIAZ47uzaKQINuSo2nB2Nscg6D6nwP9NN9mDjQM/lEWz3Kb8PTJc2PH5YOgJ34ZE06rsbxm89Z62JgWQKkAb8oFGQsqGYJHSsWl11L4IcxTcGDp82sV6SRLr961b0GX/ggrzNTFU5jLTS3CUo4l6BAmVxU4IrGH5qzYvzKD5BdmaEeSf1tAYrWGEyyCNyd9PlRa62ivG+6JRi8ZtOMX6PWL+pV/epiEGBClyj0BT5nX4KKA2/t+yBjVQ2PU2SgcbMEcE5NzH+xQ3Qw/Pm0/cTOG+h2VQoAeuhGX56oy82gzK6ylC4ik5kFJHLglbZlT0rET5V0RQhfVQgfxm5o3AKdrS4MfQImBrLI5OrMGpzWYVVSVcDL4jI8KW1BJSW34DUTH9/TT7n4ki/aK9jZ563PVWb7UdpbOBIC8qy/Q1rCqBDzTKsf/KcyaTiBQJzTKoJIo3dDuJtjoX8nwyZYLlj2w0hlNlXTpby560oJlk6AAl36gseAdcBKTMR87vjoNU2DeQy+SYZnnlXs+
 BFn3inKO
 wxaVpO45wiA/wupgkZrBH3a43Hcbr6lgWQe8mUXJXfFtJMbIjeMPhyM4ymRg9vQBmbTflMVq2wNbgwrCqn2A5hZXIN3n9rNAXrp36zOgLYkpFZERUxJNXH8rE2ux7zNt9GqVbETXfklXc9Vxv+QZIUn/4VLpuDKyH6ecLHGpfEaIXHIWYCtU1y2rOUxQUpDmvaelUoI9TQuKDj7DL1MaM7GJhSolOpErjXNWP1oQSZb8nPG01Hmp+lH/UhCYbPwmOsyze7OGi8T8b0ebIptP/dLqgu80+/kQ5Zz7lAxoJrdDntouer9/LY5R8D4NLsWm9LGKm7z9KII4fpsCkk1SrknrfW1MLAtSUwOgaJA96e9OOkp4jctXrV+evc9V4Z86D8cjG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 14:01, Lorenzo Stoakes wrote:
> FYI, trivial to fix but a conflict on mm/Kconfig for mm-new:

Thanks for the review!

Yeah, this fix will have to obviously go in sooner. And it's easy to
resolve.

That's why this patch is already in  mm/mm-hotfixes-unstable.

[...]

> 
> On Wed, Nov 12, 2025 at 03:56:32PM +0100, David Hildenbrand (Red Hat) wrote:
>> In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
>> runtime allocation of gigantic hugetlb folios. In the meantime it evolved
>> into a generic way for the architecture to state that it supports
>> gigantic hugetlb folios.
>>
>> In commit fae7d834c43c ("mm: add __dump_folio()") we started using
>> CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
> 
> Hm strange commit to introduce this :)

The first commit to be confused about what CONFIG_ARCH_HAS_GIGANTIC_PAGE 
actually means (obviously hugetlb, ... :) ), and which sizes are possible...

[...]

>>
>> To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
>> hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
>> GiB (possible on arm64 and powerpc). Note that on some powerpc
> 
> I guess this is due to 64 KiB base page possibilities. Fun :)
> 
> Will this cause powerpc to now support gigantic hugetlb pages when it didn't
> before?

It's not really related to 64K IIRC, just the way 
CONFIG_ARCH_FORCE_MAX_ORDER and other things interact with powerpcs ways 
of mapping cont-pmd-like things for hugetlb.

This patch here doesn't change any of that, it just makes us now 
correctly detect that gigantic folios are indeed possible.

> 
>> configurations, whether we actually have gigantic pages
>> depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
>> nothing really problematic about setting it unconditionally: we just try to
>> keep the value small so we can better detect problems in __dump_folio()
>> and inconsistencies around the expected largest folio in the system.
>>
>> Ideally, we'd have a better way to obtain the maximum hugetlb folio size
>> and detect ourselves whether we really end up with gigantic folios. Let's
>> defer bigger changes and fix the warnings first.
> 
> Right.
> 
>>
>> While at it, handle gigantic DAX folios more clearly: DAX can only
>> end up creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.
> 
> Yes, this is... quite something. Config implying gigantic THP possible but
> actually only relevant to DAX...
> 
>>
>> Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases
>> clearer. In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with
>> HUGETLB_PAGE.
> 
> Hm, I see:
> 
> config HUGETLB_PAGE
> 	def_bool HUGETLBFS
> 	select XARRAY_MULTI
> 
> 
> Which means (unless I misunderstand Kconfig, very possible :) that this is
> always set if HUGETLBFS is specified.

Yeah, def_bool enforces that both are set.

> Would it be clearer to just check for
> CONFIG_HUGETLBFS?

IMHO, MM code should focus on CONFIG_HUGETLB_PAGE (especially when 
dealing with the page/folio aspects), not the FS part of it.

$ git grep CONFIG_HUGETLB_PAGE | wc -l
45
$ git grep CONFIG_HUGETLBFS | wc -l
7

Unsurprisingly, we are not being completely consistent :)

> 
>>
>> Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
>> also allow for runtime allocations of folios in some more powerpc configs.
> 
> Ah OK you're answering the above. I mean I don't think it'll be a problem
> either.
> 
>> I don't think this is a problem, but if it is we could handle it through
>> __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.
>>
>> While __dump_page()/__dump_folio was also problematic (not handling dumping
>> of tail pages of such gigantic folios correctly), it doesn't relevant
>> critical enough to mark it as a fix.
> 
> Small typo 'it doesn't relevant critical enough' -> 'it doesn't seem
> critical enough' perhaps? Doesn't really matter, only fixup if respin or
> easy for Andrew to fix.

Ah yes, thanks.

> 
> Are you planning to do follow ups then I guess?

As time permits, I think this all needs to be reworked :(

[...]

>> @@ -137,6 +137,7 @@ config PPC
>>   	select ARCH_HAS_DMA_OPS			if PPC64
>>   	select ARCH_HAS_FORTIFY_SOURCE
>>   	select ARCH_HAS_GCOV_PROFILE_ALL
>> +	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
> 
> Given we know the architecture can support it (presumably all powerpc
> arches or all that can support hugetlbfs anyway?), this seems reasonable.

powerpc allows for quite some different configs, so I assume there are 
some configs that don't allow ARCH_SUPPORTS_HUGETLBFS.

[...]

>>   /*
>>    * There is no real limit on the folio size. We limit them to the maximum we
>> - * currently expect (e.g., hugetlb, dax).
>> + * currently expect: with hugetlb, we expect no folios larger than 16 GiB.
> 
> Maybe worth saying 'see CONFIG_HAVE_GIGANTIC_FOLIOS definition' or something?

To me that's implied from the initial ifdef. But not strong opinion 
about spelling that out.

> 
>> + */
>> +#define MAX_FOLIO_ORDER		get_order(SZ_16G)
> 
> Hmm, is the base page size somehow runtime adjustable on powerpc? Why isn't
> PUD_ORDER good enough here?

We tried P4D_ORDER but even that doesn't work. I think we effectively 
end up with cont-pmd/cont-PUD mappings (or even cont-p4d, I am not 100% 
sure because the folding code complicates that).

See powerpcs variant of huge_pte_alloc() where we have stuff like

p4d = p4d_offset(pgd_offset(mm, addr), addr);
if (!mm_pud_folded(mm) && sz >= P4D_SIZE)
	return (pte_t *)p4d;

As soon as we go to things like P4D_ORDER we're suddenly in the range of 
512 GiB on x86 etc, so that's also not what we want as an easy fix. (and 
it didn't work)

> 
> Or does powerpc have some way of getting 16 GiB gigantic pages even with 4
> KiB base page size?

IIUC, yes.

Take a look at MMU_PAGE_16G.

There is MMU_PAGE_64G already defined, but it's essentially unused for now.

> 
>> +#else
>> +/*
>> + * Without hugetlb, gigantic folios that are bigger than a single PUD are
>> + * currently impossible.
>>    */
>>   #define MAX_FOLIO_ORDER		PUD_ORDER
>>   #endif
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 0e26f4fc8717b..ca3f146bc7053 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -908,6 +908,13 @@ config PAGE_MAPCOUNT
>>   config PGTABLE_HAS_HUGE_LEAVES
>>   	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
>>
>> +#
>> +# We can end up creating gigantic folio.
>> +#
>> +config HAVE_GIGANTIC_FOLIOS
>> +	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
>> +		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> 
> Maybe worth spelling out in a comment these two cases?

Not sure if the comments wouldn't just explain what we are reading?

"gigantic folios with hugetlb, PUD-sized folios with ZONE_DEVICE"?

-- 
Cheers

David

