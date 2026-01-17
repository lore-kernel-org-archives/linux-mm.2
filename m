Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E4CC9830C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444866B0088; Fri, 16 Jan 2026 21:40:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF626B0089; Fri, 16 Jan 2026 21:40:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE9F6B008A; Fri, 16 Jan 2026 21:40:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 20FDD6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:40:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B719F13A772
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:40:10 +0000 (UTC)
X-FDA: 84339901380.30.EFA572F
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9415E8000D
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:40:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xp9iGWhD;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768617609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRAUHQ48YUycgqnfPxdOpy3lIq4LIKBXjAPLlYalbN8=;
	b=ShY2pW0oQoZ2Dx1DOsDbRHoLUXfHUIDUGsYcV6nRuUG58nftzi+aYn+1LyTfFniElptIqH
	fVnUYtGp6kf3sCsbuX1EUYmgyi8wqQBpbwPUtzOmk3kUAVEFvwx8ZlKFR0IxzsOwx8Ykni
	wrCtv0C+hASuFqTk/8orsmTSe1WLdic=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xp9iGWhD;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768617609; a=rsa-sha256;
	cv=none;
	b=MLA1NNcIlGDjOXXhTsMZ/s2JBHWVCVmkmTnSvmZiYO62HoEzBQa3vWBO9t925coOfFlHFz
	6I39YWX7gjdSRANdkb7j+fIT55RhTN3DIZpPIU15FS+LaNWgJxRLaK5whiYlODJyH/uW1N
	i/tYQKv52JsEspk9fG5XKQYomvd2STg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768617603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DRAUHQ48YUycgqnfPxdOpy3lIq4LIKBXjAPLlYalbN8=;
	b=xp9iGWhDcwt8mumGizWnyqjk+/ogh4k68oKpm1+E/iynSSYg1xwrWXba/vqeKNVNRBLryK
	VyKizZ7ifbQnWKD05zPhDyOxZqQIB4a1DeDyfS02iI8QFUW0G6aPnHq58rSvgFgYuxBLx6
	v5Xw4HdSkgdo5VqDVNQZR2AVyB7Qt+0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aWpTopypeRTOIVGR@thinkstation>
Date: Sat, 17 Jan 2026 10:38:48 +0800
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0F1C93F3-9A1A-4929-9157-589CF8C0588D@linux.dev>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-11-kas@kernel.org>
 <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
 <aWkhbWR-3fWjeTaE@thinkstation>
 <53980726-C7F0-4648-99E9-89E10645F2E7@linux.dev>
 <aWpTopypeRTOIVGR@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fg9dj3mxnzpyw9xdof1tz4qrp4twaw5r
X-Rspam-User: 
X-Rspamd-Queue-Id: 9415E8000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1768617608-333291
X-HE-Meta: U2FsdGVkX18Ll8/5Ec0AG+okDmHB0PC50mP+Cwnxe6d1yi6JTmw7erXMonCNlqtqBUcavOcf/fYpjr31AuTylYodZzqltksvqoa1YNezufbkrbYvZuMcn82fM/HQ+3gaYxso1THizDIoqi9O6Mn9ex/5t8O3YHB4tYCtyMSVIzQjEFzKm1gp2yx+jtXQyDOCY096TXVyYPHCgLzjHMeEwSizIxsLOmYsOB0CWtxmmaPAgsZTH90uLRnSrZ4PxmNGPb/sHfQU1MPCmE/i5QqTAfMajGjZnZ84nSrXq5Lz39Z8/ZdYTeMpa5zOdPKxEW2ihL3eNH5V2nU/1hQ+u8SLsOKJKpDEm7LAEMnipc8r16Pyv7xuukfxYXsQjVmuiLoxjBn25bwqvWtV15829ri+hYTgutQJyTxzaNhuMk8trE947pfndTpHFA/nPqA5kGP2MbO2JBxExcDfBaW/DiZQNGCu99TTrXi69OqkuTZ3mFKNKH5CMha4pqKsvsCsfaisfG1Y6ZWRXXvSqEe3KyYyMFjoCKxKvCW2OMFMgMa7CSfcLh1N1pafkc2A52GhLuZH4xs2ibd+sFBqQ1m1OUHS+1rjPeblAg/AT6EzjSaHcN5wxoF8wzHhOKkgSYdICC3xYSyUvWJ9n7LJPzLURmlFi+9prSKFKKT2NbPYxJChEtC2OPJce6m3Utl7uRVyMm4OxXI7p8oqLHeQHdt/P9DQL0aEuNHHBV0GqenTIJGhAopkGpDv6Cxwvq0xDG1tK1pAHG1HJ1eR9Qi3YGwfjN5LAT0qInEp6pYiy/kQhvdaBL5dAS1Szja4uzD5c2VtmiK6H/5EPSQcatPBj9PZyTxJsRBDZ8lHdqeUE8w5VngnNFrvwTnxeSvXB9nrvRvG4jqQ9nvpdxijuKN3kPjvRVMG/tawVWa0msj+m/Wxgw2ZazIIl46ObLvLj2ZRLVDXhE278oee4dQmqwT40KMHyb6
 r1T7P/5X
 N3YSXL4j5+SiNM4EElsiQYOtDbkACPGm2w7Wj10G/maoUInGEqp44+7sPBkWB42eahxrQ0H3pojiLU+q0Adgup3E/XSwp+JVsy9aVAodlGwSdOEyEcyOBVNdmO3bJ4o9NSJ0qvqJ4BeEPE+oQGHe8cnIUQyaoVU+XUsP7f5AP9DRs/oNTswij7tIPie8XwrunfvtQGTlm3ffty1BseF33hBJciaZeNaD2s0saI/kmhpfwT3iaqgppPveXvg438JsOavHM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 16, 2026, at 23:52, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Fri, Jan 16, 2026 at 10:38:02AM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Jan 16, 2026, at 01:23, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>=20
>>> On Thu, Jan 15, 2026 at 05:49:43PM +0100, David Hildenbrand (Red =
Hat) wrote:
>>>> On 1/15/26 15:45, Kiryl Shutsemau wrote:
>>>>> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing =
most
>>>>> vmemmap pages for huge pages and remapping the freed range to a =
single
>>>>> page containing the struct page metadata.
>>>>>=20
>>>>> With the new mask-based compound_info encoding (for power-of-2 =
struct
>>>>> page sizes), all tail pages of the same order are now identical
>>>>> regardless of which compound page they belong to. This means the =
tail
>>>>> pages can be truly shared without fake heads.
>>>>>=20
>>>>> Allocate a single page of initialized tail struct pages per NUMA =
node
>>>>> per order in the vmemmap_tails[] array in pglist_data. All huge =
pages
>>>>> of that order on the node share this tail page, mapped read-only =
into
>>>>> their vmemmap. The head page remains unique per huge page.
>>>>>=20
>>>>> This eliminates fake heads while maintaining the same memory =
savings,
>>>>> and simplifies compound_head() by removing fake head detection.
>>>>>=20
>>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>>>> ---
>>>>> include/linux/mmzone.h | 16 ++++++++++++++-
>>>>> mm/hugetlb_vmemmap.c   | 44 =
++++++++++++++++++++++++++++++++++++++++--
>>>>> mm/sparse-vmemmap.c    | 44 =
++++++++++++++++++++++++++++++++++--------
>>>>> 3 files changed, 93 insertions(+), 11 deletions(-)
>>>>>=20
>>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>>>> index 322ed4c42cfc..2ee3eb610291 100644
>>>>> --- a/include/linux/mmzone.h
>>>>> +++ b/include/linux/mmzone.h
>>>>> @@ -82,7 +82,11 @@
>>>>>  * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with =
hugetlb, we expect
>>>>>  * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
>>>>>  */
>>>>> -#define MAX_FOLIO_ORDER get_order(IS_ENABLED(CONFIG_64BIT) ? =
SZ_16G : SZ_1G)
>>>>> +#ifdef CONFIG_64BIT
>>>>> +#define MAX_FOLIO_ORDER (34 - PAGE_SHIFT)
>>>>> +#else
>>>>> +#define MAX_FOLIO_ORDER (30 - PAGE_SHIFT)
>>>>> +#endif
>>>>=20
>>>> Where do these magic values stem from, and how do they related to =
the
>>>> comment above that clearly spells out 16G vs. 1G ?
>>>=20
>>> This doesn't change the resulting value: 1UL << 34 is 16GiB, 1UL << =
30
>>> is 1G. Subtract PAGE_SHIFT to get the order.
>>>=20
>>> The change allows the value to be used to define NR_VMEMMAP_TAILS =
which
>>> is used specify size of vmemmap_tails array.
>>=20
>> How about allocate ->vmemmap_tails array dynamically? If sizeof of =
struct
>> page is not power of two, then we could optimize away this array. =
Besides,
>> the original MAX_FOLIO_ORDER could work as well.
>=20
> This is tricky.
>=20
> We need vmemmap_tails array to be around early, in
> hugetlb_vmemmap_init_early(). By the time, we don't have slab
> functional yet.

I mean zero-size array at the end of pg_data_t, no slab is needed.

>=20
> I think getting the array compile-time is the best shot.
>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov



