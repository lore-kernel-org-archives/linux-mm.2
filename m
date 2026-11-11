Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE95606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BCk4wntb
Received: by kanga.kvack.org (Postfix)
	id 721476B05C8; Wed, 11 Nov 2026 06:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1746B05C9; Wed, 11 Nov 2026 06:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7326B05CA; Wed, 11 Nov 2026 06:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7B36B05C8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:37:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCF921A025F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:37:20 +0000 (UTC)
X-FDA: 85422637440.16.10399A8
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf11.hostedemail.com (Postfix) with ESMTP id B93AB40006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:37:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BCk4wntb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397039;
	b=6usNdZczOJyX/7IBe7Gk9SaDKJ4PskeC0ASS1Yxu4f9S7cO4/bHFPAiaqKWmgxutMWHHi3
	fKT9egmk9CYhW3Clbhfs3O2vjL5DHq160t47iPAtyq/yM01m55GGhQqRvB8eAyZN05gkGj
	v5Fg85u+B+Lhh6EsBdVirCtLckVsUck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHjHPYzYFGNoBcBOrXZtd+e39D6l/yEcTx52k80YRjg=;
	b=1hICpMbU0/tAki6ghgaTpzy0dLIc5fqEg0wV9sHBTipcC8KjtT7orrQcEkgpTPRytlGEiy
	tLuNYiQT83wE0n3Ov/usiFfss62bYqVokG14mKyAPb0YmOITxAZx0uWeOwR5RtPpKSaYkb
	2cvBOJWrGdrltDQcHHM0cpG+SCLGc1I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BCk4wntb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gP+bjxnK3W7GTVCgRjyqyfMbhuLKSiiRqPVwb9GN29c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794397037; v=1; x=1795001837;
 b=BCk4wntbKqQ1VxpnfJrGukgQdXpxqo04mrTAMB75yxxGpJDz86lf6aZCpMZkUwZ1U+zWR+Dh
 Kwq30CdrKELyWPk1Yrk9jujFHLuix5bqAALuOUP4CClpTfaCNEAcWB45f9cpPcrAuynZsV19/UN
 Xi9HNPFF3PW9JuBxAlpvLCMU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e4099ae768a2b555;
	Wed, 11 Nov 2026 11:37:17 +0000
X-Mizu-Trace-ID: e4099ae768a2b555
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 0/2] mm: optimize HugeTLB bootmem hugepage init
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <016ed325-2b5c-4170-b545-47b766d7f8e8@bytedance.com>
Date: Wed, 11 Nov 2026 19:37:02 +0800
Cc: Mike Rapoport <rppt@kernel.org>,
 akpm@linux-foundation.org,
 apopple@nvidia.com,
 balbirs@nvidia.com,
 David Hildenbrand <david@kernel.org>,
 osalvador@suse.de,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <60D78CBE-E9AC-4032-A1F9-AA0B2264494D@linux.dev>
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
 <avQjbt-QUp-W3_9v@kernel.org>
 <016ed325-2b5c-4170-b545-47b766d7f8e8@bytedance.com>
To: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: B93AB40006
X-Rspamd-Server: rspam12
X-Stat-Signature: frp46hwdh41tpb6n53d3fnbzf5wiozq8
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794397038-743442
X-HE-Meta: U2FsdGVkX1/XEECsiwHc8qlQeluUS1bfA0ffFQf2CCW8B9zbjmsujarzTmjWVXZ/9UAcbBb6Y2E64TtPeS7l9gYIzN6RzyydnMNEXDNyqtywMbfvZ3F6Xp+Yw5DcUwsIoFp+ChTz/FC4LpF0ZzeGfn4Obiou5QsgSe0ArtsrN+j+eBYegPR5vo75c27GGSQem8uDgJ2XCavMVXkUXKJgkYbMavz9wByyuBWj8k8oK1qZ3lrZZoIaMClUh0ZJIKJDV5K2lmHGej6pI1NbGnlMjNpOcU3V6rH5Aohr4taSyKE0tYd9WUZGAAfc18vSyzb1HtqOP1heX40q+pLlt//pF9vqLCx42mhFjX6HVVkL2aA5Muhyvm98BCba8GVRGaFj4CVa7EhEZMkoLo3l2vYKcbHHqlE6/uhKMqEgee06MWAJRhHyEFF95bg4p4Bb3l+JrxOO2GUpgqTy819cK1tqfXN7ErXc/p+l8Vf4Bi226xgO09M+GFiRjqaOm+fH5rLctN3nRwk1TlqB/eHCdOeMEgv87lJeqkQMAABsRCZA8mxe/dTSUEcNQJ6idl9GzJ3tkCAMj1v6LgzDRDoTEjpoHjajoY6FEgvcgFDihR1T77I8S7tvFD7YKLyud0vf54o+2pfNLkjBaFOliKI4SBGebGXqA4b5Cmg7K3mv96VkjrprLs5ThxbWYM1TOMR/PXLg7mXauIFQv+615FHN2Mmjze727BHqf02drTvvH0VCEJFWCk4sstkPRRyI8iH90tTmmwAGUuJblik92QNdlTBp4U22wne3vCZMasUL/vbCrr8Bs2vyyGDMuoyJ/TpCGRi45uyYnO47tmQrGrtwO0RvFjx2jFoEicUJH/aXSVIzG4OwpAsNkB9xgDBmw06gwnv8ZuhZOaZ+KPXaqMaTxRbvi28UJE+CEg/790KsAr/VCSkuNCk5FaWPIqitQ9BHevigXJ1mHgehSdBYxMaega+
 DJW58aXY
 IhRSD+bh59LBLP5oblO27wId7V9YAFb907x+Og8jAgtUNOZWCEjjEjuRTiZaGMajqzFwDcanRx4ilSnXJUDaRBW201We33pGk8H4M0nY1LiOtcjCGSIbpETb557v4ir4hGysxlrMBZWaW2JPb9Bo3EefNLan7UfB/j+o1MNxzV7TlMmQmPpZ2GtXPaxsmJ/+iup6/D+HFYUtvrYq70CngLpmMoyFNF4/cY0CAhUzrEE3L1SZSbbz7rH32SzttTh5CFtq9/21tBr9byDz+2V9gHYCPNPJuZ4sTax3VNyd09dGBCBQSnF2KnkXnGdirlq6+q48vop95vy9sYaBDnlj8ziEc6k6VgpVdMNxWEXF2E6LDEFg9IOf6HpPs7b9XAAgYrYM+TfLcWy+B7miRUApz3WDiyq/9jrW+P7vxMiBn46Zd6k5YEa5o9F5Qc0eauHaj6uPvN7e6kfba+PyakH/hiBbIRGz1JBkQxuaRNLDPPCfVg5EhK+j3/boXPNjagTDiAmC9cBssoJv9UM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 11, 2026, at 19:24, Li Zhe <lizhe.67@bytedance.com> wrote:
>=20
> On 11/11/26 4:12 PM, Mike Rapoport wrote:
>> Hi,
>>=20
>> On Tue, Nov 10, 2026 at 07:48:57PM +0800, Li Zhe wrote:
>>> This series speeds up the fallback initialization path for HugeTLB =
tail
>>> struct pages during boot-time hugepage allocation, when HugeTLB =
vmemmap
>>> optimization (HVO) is unavailable or fails.
>>>=20
>>> Patch 1 factors the existing ZONE_DEVICE template-copy operation =
into
>>> memmap_init_page_from_template().
>>>=20
>>> Patch 2 reuses that helper in hugetlb_folio_init_tail_vmemmap():
>>> initialize the first tail page normally, copy it into a local =
template,
>>> then initialize the remaining tail pages by refreshing only =
PFN-dependent
>>> fields before copying the template.
>>>=20
>>> In the earlier discussion, Mike asked whether the same kind of
>>> template-based initialization also helps the ordinary struct page
>>> initialization path:
>>>=20
>>> https://lore.kernel.org/all/akfB6Qe-jKDEMUxz@kernel.org/
>>>=20
>>> I tested that direction as well, but did not see a measurable =
benefit
>>> for ordinary struct page initialization. The measurable improvement =
I
>>> could find is in the HugeTLB bootmem hugepage tail path, where =
gigantic
>>> pages can require initializing a large number of tail struct pages =
when
>>> HVO does not cover the allocation.
>>>=20
>>> Tested on an arm64 QEMU/KVM guest with 4K base pages and 64 =
boot-time 1G
>>> hugepages. HVO is unavailable on arm64 in v7.4-rc1, so the fallback =
tail
>>> initialization path is exercised.
>>>=20
>>> Results averaged over five boots, measured with a temporary
>>> jiffies-based printk:
>>>=20
>>>   base (v7.4-rc1):  318.4 ms
>>>   with this patch:  202.4 ms
>> Are there numbers for x86 without HVO as well?
>> We need to be sure this does not regress that use case.
>=20
>=20
> Thanks for the feedback.
>=20
> I did some additional x86 testing today, but the result was different
> from the similar x86 test I did earlier on linux-7.2-rc1. After
> replacing memcpy_nontemporal() with regular memcpy(), the result =
looked
> better. I need to re-check the old test code, since I may have mixed =
up
> which copy primitive was used there.
>=20
> Muchun, could you please hold off folding this series into your =
patchset
> until I send v3?

Sure.

Thanks.

>=20
> Thanks,
> Zhe
>=20
>>=20
>>> This is a 36.43% reduction in the measured fallback tail =
initialization
>>> time. The temporary measurement instrumentation is not part of this
>>> series.
>>>=20
>>> Li Zhe (2):
>>>   mm/mm_init: factor out memmap_init_page_from_template()
>>>   mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>>>=20
>>>  mm/hugetlb.c | 20 +++++++++++++++-----
>>>  mm/mm_init.c | 34 ++++++++++++++++++++--------------
>>>  mm/mm_init.h |  2 ++
>>>  3 files changed, 37 insertions(+), 19 deletions(-)
>>>=20
>>> ---
>>> v1: =
https://lore.kernel.org/all/20261105120615.16817-1-lizhe.67@bytedance.com/=
#t
>>>=20
>>> Changes in v2:
>>> - Add a comment for the template-before-copy ordering, as suggested =
by
>>>   Muchun Song.
>>> - Drop the empty-range guard in hugetlb_folio_init_tail_vmemmap()
>>>   as suggested by Balbir Singh and Mike Rapoport; current callers =
are
>>>   expected to pass a non-empty range.
>>>=20
>>> --=20
>>> 2.20.1



