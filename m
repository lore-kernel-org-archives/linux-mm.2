Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2296CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87F66B0093; Tue, 29 Sep 2026 04:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E602A6B0095; Tue, 29 Sep 2026 04:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D754A6B0096; Tue, 29 Sep 2026 04:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A83386B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:43:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E60E880438
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:43:09 +0000 (UTC)
X-FDA: 85266160098.20.95676F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0FCB54000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:43:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGwxpnBE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790671388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5o5nxIGaf1ad5zEI4GVn6mSMEnb1Lm3br5oDnecbdc=;
	b=PzhoaTBassCYVDh5jqGRSyQVtPW+j8XYcrmWNCqhQGjvu9vpALm3cK/Fc6U5pnzf8J4Dxf
	L9Ki7ihpxBiomvIDkC1x6lbMtKA9XQB/IVsIltZGugZT26jxJSDpMVzrdShpFPzEerSxTT
	sG8YTDEkJ+dsMbaAKMSJKjJv6zxdnO0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGwxpnBE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790671388;
	b=QKSfzzHdkTZWDNt7tErU8y86BaV1Ti3nSCN1HMkAwTvMtlkulesMRK+YsDQ5KuTDVObJgz
	lLz4nHOm3IgXubGEkZZid0jogBE6KE7B35eNmg+VDUVc54tbXYB+QGJz9P2XNd2BVz9EYj
	8YNOZibNW0eO6ATcZgg5ZEylX2GHsJo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BBCB41425;
	Tue, 29 Sep 2026 08:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF371F00893;
	Tue, 29 Sep 2026 08:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790671387;
	bh=L5o5nxIGaf1ad5zEI4GVn6mSMEnb1Lm3br5oDnecbdc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CGwxpnBELT2SBdYqTWoImYAwOQE6VH3Z/GK/BjARDqL1OwqOg0mgW0LKYZbEz6KG/
	 SAEdW0C3XoQlNf/Suzav0R/znaJUw+Zx9A2mbHr2oOXegJenEJuYHoxqO8iDkDY1Z9
	 1biQcQdcVJCtdUNP3yYInn6yCqUpVeK7z7C2EAovrzfdZBjcL/JFpIALGaFmJaradQ
	 K2j9jnOfTmkKmmk84SVrHosCBrgboNIbijZzR8QL5Fqh44ddhSMmY5yz0y1urmxGHS
	 6q7CoSukBqGFsgY4TVNW9UMehwhIHeIFxPbMVn2h2JoaMn82yQAVpHyoBvs8ilNbAC
	 LQ/yguM0me+uQ==
Message-ID: <73625017-b944-446b-95b6-6c586c304f35@kernel.org>
Date: Tue, 29 Sep 2026 10:43:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/12] mm/sparse-vmemmap: introduce
 CONFIG_VMEMMAP_OPTIMIZATION
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-4-songmuchun@bytedance.com>
 <d7a75c99-3021-495f-ae34-883d047370f3@kernel.org>
 <D0B0A406-100C-437D-8AA8-D276E8DA8278@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <D0B0A406-100C-437D-8AA8-D276E8DA8278@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0FCB54000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ojxxjg6nc3rzw38wyqabb5prwaxc46wu
X-HE-Tag: 1790671387-610022
X-HE-Meta: U2FsdGVkX196E+BJJNOPCoK6Hfq4uhNKY2hYBdJ0JSQTkzKv9kNl+Fb1JvchQyw8Dih8h51UO31bJds9K19kucEtBCguyVzWLCV4sHk76wQMjOEre6dQSda/Xc5XCSE1Zf9EaFiQuUD0hKV9R884PEr7Gnqsvn9A1IZB/OWBlIbTH9BMkpB54Z7m0374QMdIQ8saXgK7O/0LoBER01jQeeSOmeaTs2uXH6Rqn+jepw03NcfUATYb/CVQ7kgKZExItLYxKuCysmK2JOq5cHzUtLm+ikT/1IKWnF7jCAF0i3Qk6vcL4IAAmshjIZSJD+O3RXN2dT2toxpfeSE+DBFP2QDavQGjY24WKbaWax8LLTvDNOuMub4VYy4pFdUqzyhJf+5P9XkQzXHgEb3XBvjjwYbVz2xFm4w/mrOKMfvKlz7xlZpj9KpMElhOCx+hrDs2u7yJPK3MQlOZFvZ0HMP8+EMdRyHaT012Kd7nR6L+0/gOWXp/iVKWYSceklsmYwe5CExGA52J6HtkVrHmtT3LtM6h4jyoCOSCNsxpuYtLhjjn8Ls4YS1BKpKAr8vB/dzBZstsiu+SbY+cGefmgDHNBMs5kjsDyZ3yJ5z4CRabWWBn4Ep7W2oALzRhqKjfTvfoW+6/MxOcI/5oeMyNQRjtbQhAik333VuLVMODonpH1L4iI8O6MVJr8mftv1m8vNEmLExJHWbVfa9aNRiA+Nyv0vywf/b/lJZiCKUUB3Wk+eF+AurH0pghLI0O6TW7KfDA+IhxrSMh13lwx8CqZoBDomBeVsWkY+FICE43pXWJLR7MR3L+AJj6IhDV5j2btuooCoPRRHSRzRqzHYrWC1a0PPjd5WxX/oxt402xXp8qIZEJsszc6h49f4duvnlp1259vNttFbGC1kXsTYptxYqnt7lhTt/4dpC3ffNiK4jftSX853V1L/NE3WK53LEmK8VCtzShDqkfYzLi+12K1Dj
 k4gruKFS
 TX46Kk63YtCp36vqkgzEskj/I7Yt+4/Lqcbb0d0FrNtgyKSSrNOyv0n44Zl3f07O+JEhf7cpszQZsr0hNR+5KbkakAQ9nwaOjSevOlWBG6WTvQ0b7OXq50/MtCm9NsqKymeRRzBye8FzKislkWlyRU253l0BaletBdkAUjJI0WP0exAO5JxJ/pbAlfryM4TMYj56UiklattiBKK9k9yc146MgMQyNMW4u5xZKoHpC3P1KB42WX1BI11bMt+vlbQqHNdHL5qirvCGQAlBT1UGHGQMtZelAm7CKoitHOHlCmQedHnCkhEJE7Gl+PosBjjAK2V70+IB/Tkjxg54HcXLp1MnGXdyRgjYqhtVF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 09:53, Muchun Song wrote:
> 
> 
>> On Sep 29, 2026, at 15:11, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 9/27/26 04:54, Muchun Song wrote:
>>> The section-based vmemmap optimization infrastructure is guarded by
>>> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it can also be used by
>>> ZONE_DEVICE users that set dev_pagemap::vmemmap_shift. Introduce
>>> CONFIG_VMEMMAP_OPTIMIZATION as a common config for the shared
>>> infrastructure.
>>>
>>> Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
>>> ZONE_DEVICE when the architecture opts in to DAX vmemmap optimization,
>>> and use it to guard the generic sparse-vmemmap state and helpers.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>> v5:
>>> - Move this patch after the shared tail-page factoring.
>>> - Select VMEMMAP_OPTIMIZATION from ZONE_DEVICE instead of DEV_DAX,
>>>  covering all users of dev_pagemap::vmemmap_shift, reported by
>>>  Sashiko.
>>>
>>> v4:
>>> - Rename SPARSEMEM_VMEMMAP_OPTIMIZATION to VMEMMAP_OPTIMIZATION
>>>  (suggested by Mike Rapoport)
>>> - Collect Acked-by from Mike Rapoport
>>>
>>> v2:
>>> - Fix SPARSEMEM_VMEMMAP_OPTIMIZATION being selected without SPARSEMEM_VMEMMAP
>>>  reported by Sashiko.
>>> - Add an explicit DEV_DAX dependency on ZONE_DEVICE
>>> - Collect Acked-by from Qi Zheng
>>> ---
>>> arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  2 +-
>>> fs/Kconfig                                    |  1 +
>>> include/linux/mm.h                            |  3 +++
>>> include/linux/mmzone.h                        | 10 +++++-----
>>> include/linux/page-flags.h                    |  5 ++---
>>> mm/Kconfig                                    |  5 +++++
>>> mm/sparse-vmemmap.c                           |  2 +-
>>> mm/sparse.h                                   |  6 +++---
>>> 8 files changed, 21 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
>>> index bc3e549795c3..72a92cb9b53d 100644
>>> --- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
>>> +++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
>>> @@ -11,7 +11,7 @@
>>> #undef CONFIG_PGTABLE_LEVELS
>>> #undef CONFIG_ILLEGAL_POINTER_VALUE
>>> #undef CONFIG_SPARSEMEM_VMEMMAP
>>> -#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>>> +#undef CONFIG_VMEMMAP_OPTIMIZATION
>>> #undef CONFIG_NR_CPUS
>>> #undef CONFIG_PARAVIRT_XXL
>>>
>>> diff --git a/fs/Kconfig b/fs/Kconfig
>>> index d1c210c6508f..1454b7fe9641 100644
>>> --- a/fs/Kconfig
>>> +++ b/fs/Kconfig
>>> @@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>>> def_bool HUGETLB_PAGE
>>> 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
>>> 	depends on SPARSEMEM_VMEMMAP
>>> + 	select VMEMMAP_OPTIMIZATION
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Thanks.
> 
>>
>> Is there a path to remove HUGETLB_PAGE_OPTIMIZE_VMEMMAP, and to merge
>> ARCH_WANT_OPTIMIZE_DAX_VMEMMAP+ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP into a
>> ARCH_SUPPORTS_VMEMMAP_OPTIMIZATION?
> 
> These are actually two completely different capabilities.
> 
> ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP requires the architecture
> to support dynamic updates to vmemmap page tables, meaning a
> PTE entry can be changed from one valid entry to another
> valid entry. This does not meet the requirements on arm64,
> because arm64 requires page table operations to satisfy BBM
> (there is, of course, a series [1] attempting to do this).
> 
> However, for ARCH_WANT_OPTIMIZE_DAX_VMEMMAP, the vmemmap page
> tables do not involve dynamic updates, so the BBM requirement
> can be satisfied. Therefore, arm64 can enable
> ARCH_WANT_OPTIMIZE_DAX_VMEMMAP, but cannot enable
> ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP. To make the naming clearer,
> I have another patch [2] that renames it for greater clarity.

Ah, perfect. Too many patches floating around :)

I thought there is a patch set to avoid the BBM requirement on arm64 from James,
though. So not sure if both things will always stay separate.

> 
> As for ARCH_WANT_OPTIMIZE_DAX_VMEMMAP, I plan to remove it
> entirely in the future, because architectures that do not support
> it can simply choose to disable it, as can be seen in patch [3].
> 
> So in my plan, ultimately only one config will remain:
> ARCH_SUPPORTS_VMEMMAP_REMAP.
> 
> I hope this clarifies the plan. Let me know what you think.

Yes, thanks.

-- 
Cheers,

David

