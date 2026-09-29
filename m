Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FA9CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A8E6B0099; Tue, 29 Sep 2026 04:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4415C6B009B; Tue, 29 Sep 2026 04:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3583C6B009D; Tue, 29 Sep 2026 04:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A73D6B0099
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:36:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69051C03B3
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:36:34 +0000 (UTC)
X-FDA: 85266143508.06.1177A90
Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6001340007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:36:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WMXbedJM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gl7Dbkf6zYEyNTSd0tfJx7Wb2qDhRetsdKvP0HB4MA=;
	b=Gei8eWfmAYMaCKb5OM0zUHblhbWQuLxgYxQzuh+af0VmrXi41bD871D4LUKgThcoZfSCdX
	2YEW9Bu9P9hKN6ZJLx93wBKxi9qutECC70DkFjXNwsdzw9VyzVA117Oj39MC0hHDNPwkhJ
	O+Oax6A5nwKGZBXQwtewOxV4JlX4cWg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WMXbedJM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670992;
	b=TgO2N2Yz45Zj7ZXu0jNiJqRmrd5qcCkS1qK2dtNnIuL/BXGMjBywLnv6mJmALkgMS6eOCL
	NZrLcOX22VKaDgSNxmv8sSFp6jIuPYbV7vD8UIwxRZxCVygj4D3Xpo6d1aTFckam4vrye7
	FE5bVHOEqg2dOa8x8+QozgqOJLt2+rE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8vfz9yom+ls/aQov6CVfDaBZr7Ko9IZV3QMRLqEpVmM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790670991; v=1; x=1791275791;
 b=WMXbedJMmbqaftd1IpCIhlKKzGIzCRayG9NJsx7HkivNiVYX7SV3JIweXkHE+jmSxSGZGFY8
 cOpVlP8jKib3bYDO45TF0mzuc9vNN19kzoQfIv0Dl7DmxdKGdmnTYmyYPURpDDWxQSCsyxwG715
 JozrFQ1Ypj7BSyJi0O8Z7r2w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7b4496e5929f9e79;
	Tue, 29 Sep 2026 08:36:29 +0000
X-Mizu-Trace-ID: 7b4496e5929f9e79
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 07/12] mm/sparse-vmemmap: switch device DAX to shared
 tail vmemmap pages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <1b542015-8e5a-41af-9e98-9810333e6725@kernel.org>
Date: Tue, 29 Sep 2026 16:36:07 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <53A73178-93E5-414D-8ECE-96B3082384C4@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-8-songmuchun@bytedance.com>
 <1b542015-8e5a-41af-9e98-9810333e6725@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Stat-Signature: o5iycbjiox95cqkroebnyr35gsk9i5kw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6001340007
X-HE-Tag: 1790670992-894189
X-HE-Meta: U2FsdGVkX1+fIE0jKkwFPVoKdU8njgX8R1gRhdS/fdo2REVZF4Ca1PHP/iE6of/okUHWL5bz9PITsM3xIASgyYiYL+fCV72oLIlhkIbALojI8EKHUY+hv2AecxYrBzkmxyWznFHa5v78RvJrzEU0GDjTE6gbfuhgzFLpX8qNPO6vioT/6l8E+KrFgtWqg+s51TKFLQGoTdvp1CNYM4370DAo8U9kjJpdDq0ygpBfBlZYuxKUlt17h2G+PAnJp4SdAXAEywthUkPUWpUstsAOK3npyfLK1mYJN0o7Gi4ejC2+oaS9s1mYy6d4lPy+eWlIDCVUNxf9nEQoBoH6jZTPUba7EeSZuT7HmPEcz5fGuFXBWbBVbdW4ZSAuszU4OnyU0Z6ieiWYwF16NDE0HuE6Q6xzNs5HkvxWCt4Cbfm5rBCRUweDp93Z2S0enFIdCv4TAEK6sghoOm6QbEsznSStnrF1taAhXN5xcl9P1Kw6KoM5XK9Sj5DYizWmTcf9Lv2GJL2FgjV7jAr5L9zPU1DmGelnydfLdOvEcrnZYXZ12txLaAnWXsMTVBKrZE2BBJfNPYr8r762o6oRJKCFfhjwEIgDatdUgNomVmQm8wTOH+zQX543jttiMrKeNRwFJ0C5usVE0WGRk8LdsBDR8g7zwaRk6reopo7pfhGnuRmvdKs4m8ncghqa+FeSybgU/EiQQfrM4kUp1A7TRfnQClDewSKyYClYzoqT9TUOP1iIdmsvo3C7hzM8fp0I/LB/V3mg4qNuFYmaUV35P+5mCmOO+ZGm4VMYPZyaudFh+XL6mcd6GfZPMFYGMSIW6XbOBIiB4Whhe+eH1xL/nxph56x3dUefhE1ZJTKCuWLV+rUM/xJAUO+jRY5U8gaVGV0K3NtSYJ6HRwPAhVSXhMdmuM0HDIJDhsFhp/AbeY2iCGkXV2VE5MWNR4hM9zHU8/LZ293Mh6MeGH8oSTkxJz0qwxG
 wZjx6FoV
 VB+y1yLA2lGrLpaS0P3NS3tQyYfMDVvbnw/2WzlSxcETtdW7R2cdby5JzGbqzEDee50JEmMSlnFe5uKso+yh1N7htOEfBY0xEhudthQaEqaEREgYBaWYvqSR9fOpndNMeHj2TH+dJWiV1Zv2Gq82MmfBnQ10IEXAZFIBhgsK52gPfIwhGg2mVPH8qzBu557bJMgECCwAev3Fdo89RWi+XcV5xncZPhkPYaAlWFKYbCSgRKi6A8gIdEG7wwKVhAFco6gw85VTlLojUWvroCO0NnqupcRtygR8wbFsZbLMuOwN3PegT1+4SrxSwMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 15:36, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/27/26 04:54, Muchun Song wrote:
>> HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap =
pages.
>> Device DAX has not been switched to that mechanism yet.
>>=20
>> Switch device DAX to vmemmap_shared_tail_page() as well. This aligns =
DAX
>> with HugeTLB by using the common per-zone shared tail vmemmap page.
>>=20
>> The optimization is enabled only for DEV-DAX through =
pgmap->vmemmap_shift,
>> which supplies the compound page order recorded in section metadata =
before
>> vmemmap population. Unlike FS-DAX, DEV-DAX does not modify tail =
struct
>> pages, so sharing them is safe.
>>=20
>> Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
>> initialize its entries with PG_reserved for device zones. Also skip
>> poisoning vmemmap-optimizable sections while their struct pages may =
be
>> shared.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>> ---
>> v3:
>> - Move device_zone() after the definition of NODE_DATA() to fix
>>  non-NUMA builds.
>> - Update the commit message to describe the compound page order =
stored
>>  in section metadata
>> - Collect Acked-by from Qi Zheng
>>=20
>> v2:
>> - Explain why sharing tail vmemmap pages is safe for DEV-DAX
>>  (suggested by Qi Zheng)
>> ---
>=20
> [...]
>=20
>> -
>> static int __meminit vmemmap_populate_compound_pages(unsigned long =
start_pfn,
>>      unsigned long start,
>>      unsigned long end, int node,
>> @@ -551,21 +536,18 @@ static int __meminit =
vmemmap_populate_compound_pages(unsigned long start_pfn,
>> pte_t *pte;
>> int rc;
>> 	unsigned long flags =3D VMEMMAP_POPULATE_DAX;
>> + 	struct page *page;
>> + 	unsigned int order =3D pfn_to_section_compound_order(start_pfn);
>=20
> const and all the way to the top.

OK.

>=20
>=20
> I did wonder about the poisoning change ... because the memmap usually =
gets
> initialized once the memory section gets moved to a zone.
>=20
> SO now I'm a bit confused about the ordering of events :)

Yes, the normal memmap entries are initialized later when the range is
moved into the zone. The shared tail entries are the exception, though.

The ordering for device DAX is:

1. sparse_add_section() sets the section compound order and populates
   the vmemmap.
2. During vmemmap population, optimizable tail entries are mapped to
   the per-zone shared tail page, which is initialized by
   vmemmap_shared_tail_page().
3. page_init_poison() is reached after that population.
4. Later, move_pfn_range_to_zone() calls memmap_init_range(), but the
   latter deliberately skips vmemmap_optimizable_pfn() because those
   entries have already been initialized.

Therefore, an unconditional poison here would overwrite the initialized
shared tail page, and the later zone initialization would not restore =
it.
The non-shared entries are still initialized later as usual.

I agree that this ordering is not obvious. I will update the comment to
make it clearer, for example:

  /*
   * Poison uninitialized struct pages to catch invalid flag =
combinations.
   *
   * Tail struct pages in a vmemmap-optimized section are initialized =
and
   * shared during vmemmap population, so they must not be overwritten =
here.
   */

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David



