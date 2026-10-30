Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1F0606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 11:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cmSt9/t2
Received: by kanga.kvack.org (Postfix)
	id C1B836B00EF; Fri, 30 Oct 2026 07:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2216B05B3; Fri, 30 Oct 2026 07:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE21A6B05B4; Fri, 30 Oct 2026 07:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 873D26B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:14:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 142CEC0646
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:14:21 +0000 (UTC)
X-FDA: 85379033922.17.EAC8309
Received: from mta1.migadu.com (out-84.mta1.migadu.com [95.215.58.84])
	by imf01.hostedemail.com (Postfix) with ESMTP id A840F4000A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:14:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cmSt9/t2";
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.84 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793358859;
	b=Bveio4xmM37yHTwWPGD58EmRDoTYILareLjuKlGtprXcSHMkcpiuTpY7L2FqKypgoRwmWp
	bqbSGvrvV9+bGEGjDcwDqb1vit9BqOMaC9tvYQz7avsgjB9INhbOV1gl3Lw+Eohu+kTDlP
	5gzfJFcE/B2CQ792INKv6m35yktfVL8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cmSt9/t2";
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.84 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793358859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j0Dpk8F16jUjSTTEQzXZMl1K/eyyCO+RqBTSF8+llHA=;
	b=ybSvM1EWFf9n/bzhZt9sVB6eR+Mhf/za9+AUgL4kK5PWqly/X0v1f0SYilTVM/d0HiH36n
	C+3i+i18/uJF80Z2jWmeCmYZLp7LAbDBg/gXEBaX2rNdYciOxKyshyyylykVbD6DEXfpg3
	de+SclsUacxt0F1c008pNWeem/4+mvE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/hkUgSZjp6AaXOgYubi6gjf4bGt54M8qSHBq7xoR5Gg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793358854; v=1; x=1793963654;
 b=cmSt9/t2ekgeN+2H/AK/CaONcMFVjcHbkmbY5R6QVwNwIafaZIRdVdxfLYha7wkaiigOJK5t
 1qvsdzatIi3O/HdgnSUa/XDORt/kanQgoaQgaO10saR7IA2e39I/vUA5wuMoDszngd5t2rPswa6
 FEZeNrh52rNvZCIqLEpd68/o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 419879ff3a6aaf8f;
	Fri, 30 Oct 2026 11:14:14 +0000
X-Mizu-Trace-ID: 419879ff3a6aaf8f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] powerpc/mm: fix uninitialized ZONE_DEVICE struct pages
 with PMDs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <bj8bwkuf.ritesh.list@gmail.com>
Date: Fri, 30 Oct 2026 19:13:53 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Pavithra <pavrampu@linux.ibm.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <96A93324-9979-45B6-A288-4BCF9E6970BF@linux.dev>
References: <20261029063601.1961415-1-songmuchun@bytedance.com>
 <h5i4wlx5.ritesh.list@gmail.com>
 <20FE1232-A48B-4F72-8F18-89EFF70EE0FE@linux.dev>
 <bj8bwkuf.ritesh.list@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: wbiw4bxo4795yryzskb9pkg9dufkrgq1
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A840F4000A
X-Rspam-User: 
X-HE-Tag: 1793358855-526896
X-HE-Meta: U2FsdGVkX19w3g6MoGHHp2HZA3E3iO/TrKtfnzUySopACkwkH+1ghqG3/PaUOK7BXZWBan4JzPFFd2FQq5iPDiAhOioQcRRjBB/ya9Ikc8zcxD22qR/ZCiHg3i6J+ce9GOhDW5MYKm2QNasw/FdCCQ+vd8nbEaqil7Bi+i+/dcdKkLO/2rC6e6WnX3T0OPP7CMt/PRJTJNe8wi6frNKI+fsZMYplpBQsaUkvvHwhYbogWzwW/nPxKRvILxPFOTkd+enMIxYyeOzUUL4ULJcRoexNV03oRNAHGYulwhyw/0nROrhvGu4QHUeYwZlMlWF2jtejuGRidODu+JjkPcES6JH/+yYvXeDqV961uXsbAYJgq08Zd60iLhBdOwiHwd7oJL/Kqd4bYIv48F0So0Qahpl3hyVc9q1KlsnAUOR1VkFVM+K0EndCBYXlb0/Eqe2xNNfDASkKEG3dZG887SzA+cu2nC8BsX3wAipxXTGDMeJ+Czi9C97iZkGvQdNfpNnvsSaW9F0Q8Y+K2Ttv+KS479RQd+5e8jO+RRGaVo88lqoR74oD9DIfjTBnxOrkZdtFoKbrhhIBVB0r0bYpu6utfT0iC+xuT0yVkKpbe5MBmWZJa7fuRCm3+3F9jer5Lg7u6Q+pu/kDyXVgxlI72MbqP2ub3EadADcCRTA1YmQXFGdPjpC4qPjYRFF6T7ZtHc4qYlZVDmpv7dC/n3HfgKFUJL/DVRzPmYWwTSQjYFfqdU3qBOxsSp4Hiq65O2KM/h/CxklxCSF67ptGpSDDdaxtuWOPa2TkVB0+sHituYHxIWVIaRBLJ9K7kt3ZNhp5/WukMWm7lboOCrNy30c+8k1boWcCNWbG4KpJez1tkqEt2e3sCvusZqc6JGobmrNthg724ghdbQdxktDUPYeWJ0x7daKwNavOV7NSbsWHysC+XG8Svwh222s090VWqXVGf1/zLApcgFTk1aThPH8eZex
 +2fcO7Tk
 HNAkKRWEbxnPJFAAiLM45VK63klPBJ0bQdBno///Iiiiq/E8quk0HI/FAnkocc8cJtym0z1CqY4+TJAOtroKGvD4h5YqsuoHZVu88un9iv1CKGMazFyB1vL6MRFdw8RR6KAjO5kNnpc99ddTWuk/iG4RKVUA9BxaTd3W+h928YhkIBxMxdVJ22qtDfOUf9EvAp9PiTj9sfQvXQXKPPNoUc4Ir9/GvQRFTksXMny5c9UU+WTm/WY5owXc7ZYf7qIoIQ3I3eOQQo9z0QT98HSfwZcGxGo+RAnpTrsUnLqdNudqoy6wx0E/F5he2+UoNGu/FEUEZBQskReotbIBHFsHXIDVr3EA/bBO3bzi2Zkpa8Z2YSGJMqGmm/+WVMpV4GCNYBKyrCowPf53ZGybIPSc4wRh8Q6J6j50JUCZZXA3YJIrV73C0i0+73+Ete0ZVRnL7h0X1RytIEMxQPPRdmNnoq3OHBvAduBSzF5Vv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 30, 2026, at 18:20, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>=20
> Muchun Song <muchun.song@linux.dev> writes:
>=20
>>> On Oct 29, 2026, at 23:45, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>>>=20
>>> Muchun Song <songmuchun@bytedance.com> writes:
>>>=20
>>> Thanks Muchun,
>>>=20
>>>> PowerPC radix vmemmap population can reuse an existing PMD mapping =
while
>>>> populating a device DAX range whose section is marked as =
HVO-enabled. The
>>>> reused mapping is an ordinary vmemmap mapping: the redundant tail =
struct
>>>> pages are not remapped to the shared tail page.
>>>>=20
>>>> Leaving the section marked as HVO-enabled makes later ZONE_DEVICE
>>>> initialization treat the range as optimized and initialize only the =
struct
>>>> pages that would be backed by a real HVO mapping. The remaining =
tail struct
>>>> pages can then be left uninitialized even though they are still =
used as
>>>> metadata for the device DAX compound page.
>>>>=20
>>>> This first triggers a zone mismatch warning in =
__init_single_page(), then
>>>> faults while initializing the pageblock flags:
>>>>=20
>>>> WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4
>>>> Call Trace:
>>>>   memmap_init_zone_device+0x164/0x430
>>>>   memremap_pages+0x43c/0x93c
>>>>   devm_memremap_pages+0x3c/0xa4
>>>>   dev_dax_probe+0x264/0x3d0
>>>>   dax_bus_probe+0x140/0x1c8
>>>>=20
>>>> BUG: Kernel NULL pointer dereference on read at 0x00001400
>>>>   __set_pfnblock_flags_mask.constprop.0+0x34/0x160
>>>>   memmap_init_zone_device+0x358/0x430
>>>>=20
>>>> On kernels without these initialization-time diagnostics, the
>>>> uninitialized metadata remains latent. When userspace later maps =
and
>>>> accesses the affected device DAX range, the kernel operates on =
those struct
>>>> pages and panics at that point instead of during device =
initialization.
>>>>=20
>>>> The Fixes target predates the section-based vmemmap optimization
>>>> infrastructure, so older kernels do not have section state that can =
be
>>>> marked non-HVO. Backports to such kernels need to handle the =
PMD-reuse case
>>>> in powerpc radix code directly, for example by initializing the =
tail struct
>>>> pages that core ZONE_DEVICE initialization would otherwise skip.
>>>>=20
>>>=20
>>> Actually that would be totally new code right? It won't be a =
straight
>>> forward backport, correct? ...=20
>>=20
>> Right. Because it's impossible to backport the whole section-based =
vmemmap
>> optimization infrastructure (48 commits).
>>=20
>>>=20
>>>> Mark the section as non-HVO when reusing an existing PMD mapping, =
so the
>>>> section's HVO state matches the actual vmemmap layout and all =
required
>>>> struct pages are initialized.
>>>>=20
>>>> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for =
vmemmap optimization for radix")
>>>> Cc: stable@vger.kernel.org
>>>=20
>>> ... then should we mark Cc: stable here with the above mentioned =
fixes
>>> tag? Because this patch cannot be backported as is to older kernels =
-
>>> for the reasons you mentioned above.
>>=20
>> The comment following the trailer is used to guide stable maintainers =
to
>> backport proper prerequisite commits. It's hard to do that. So I =
choose to
>> mention the alternative in the commit message. But with the help of =
LLM,
>> I found the alternative is also not the right solution. The reason is =
as below.
>>=20
>> That pmd_leaf() path only creates or reuses the vmemmap mapping. =
After it
>> returns, sparse_add_section() calls page_init_poison() on the whole =
memmap,
>> which overwrites any page state initialized there.
>>=20
>> Therefore, older kernels must pass the PMD-leaf information to
>> memmap_init_zone_device() and let it initialize all real tail struct
>> page entries. Initializing them immediately in the PowerPC pmd_leaf()
>> branch would be too early.
>>=20
>> Another solution is making vmemmap_can_optimize() range-aware by =
passing
>> the vmemmap start and end addresses.
>>=20
>> On PowerPC, reject the optimization when any part of the range is =
already
>> covered by a PMD leaf. This ensures that an existing PMD mapping is =
reused
>> normally and that all real tail struct page entries are initialized =
later
>> by the core code.
>>=20
>> Maybe it should be a separate patch for old kernels? Thoughts?
>>=20
>=20
> yes, I think we can do a separate patch later for older kernels. I
> will look at your suggestions to see what can be done in that case.

Thanks.

>=20
>=20
>>>=20
>>>> Reported-by: Pavithra <pavrampu@linux.ibm.com>
>>>> Closes: =
https://lore.kernel.org/r/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070=
429.git.ritesh.list@gmail.com
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>>>> ---
>>>> arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
>>>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>>>=20
>>>=20
>>> I think, this patch should go via mm tree, due to all the =
dependencies
>>> coming from there, right?
>>=20
>> Better. I hope Andrew will pick it up once I send a v2 version with =
more
>> proper commit message changed.
>>=20
>=20
> I think we can add an explicit comment like this then?
>=20
> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap =
optimization for radix")
> Cc: <stable@vger.kernel.org> # see patch description, needs a =
different fix for <=3D 7.3

Oh, yeah, I'll add this in v2. Thanks for your suggestion.

Thanks.

>=20
> -ritesh



