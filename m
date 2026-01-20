Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E07D2ED00
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 02:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9406B034E; Mon, 19 Jan 2026 21:50:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1A16B0350; Mon, 19 Jan 2026 21:50:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16306B0351; Mon, 19 Jan 2026 21:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC1796B034E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:50:51 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 794A48B677
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:50:51 +0000 (UTC)
X-FDA: 84350814702.12.8481B07
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8D92C40003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:50:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tQOwTb9/";
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768877449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXiYX4KamXJdrCUq7b0aguR0/Zq+QSB8PNxFvwlaWr4=;
	b=kf2YiUwdsHEFya4PHvuTdy1K/OYaGy9v3se8VrNHfUT3Db66lBCJko1KJ4ZN44dcqcBTn7
	PRTnTYYVBJcdlpOKNuOsI9tgiazPlLe7QKsr2yZ+wurxtqgf87uqyYQ8JcTn1T3s/SXq0d
	ksZZNQkoXczPIKmAiX5d3jcCkN2lYTQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tQOwTb9/";
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768877449; a=rsa-sha256;
	cv=none;
	b=TRiBxWU4by8M3coo2THtIP2MaCbqEfmzs195wa2PbAjGZMRJ2muLa7Kayw6n9XQd1ra0zm
	84w6mipzfWIKQ/L+BFd7MTYzuqfiHbhA/23LvobuiKwMjJepjGpZdnxZzPgIjvd/WpO1IG
	8hkv2p8OaIAWlWdoieDx6Rc1fXjRsFQ=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768877447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aXiYX4KamXJdrCUq7b0aguR0/Zq+QSB8PNxFvwlaWr4=;
	b=tQOwTb9/2aXdO3zPJRLpLp5A18+l5o5AmBPtdS5XKQLRREj8EYCvEXqUhem24ohyoA55N3
	HU/RZBDkmA1EhaUgt3z4J+gkypkiwczEcv/Z4g4p9+pfzqkwzG1bqkcYArpGotFIhZ2lNt
	Fa/In/t5d/GjD0GoM4ZGVCdzCgN93UY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aW5JqibNe4CVBa07@thinkstation>
Date: Tue, 20 Jan 2026 10:50:03 +0800
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
Message-Id: <9C029C3B-E140-4FC2-A680-8580AC753B69@linux.dev>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-11-kas@kernel.org>
 <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
 <aWkhbWR-3fWjeTaE@thinkstation>
 <53980726-C7F0-4648-99E9-89E10645F2E7@linux.dev>
 <aWpTopypeRTOIVGR@thinkstation>
 <0F1C93F3-9A1A-4929-9157-589CF8C0588D@linux.dev>
 <aW5JqibNe4CVBa07@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8D92C40003
X-Stat-Signature: aap4wigy38rw7s73f5jzb5tf8d47xg5u
X-HE-Tag: 1768877449-605275
X-HE-Meta: U2FsdGVkX1+p4JlMz+j3SzRKF1PK5t20K2ZssuX/1OGCwD4o7u4PhABjJUaXi0V/Okt4MUKjn3WiOycEUbnp8yihpy0lIgygFqGlM0ct4zCI1woSunXDvbzFrfVfdd4Pu1draLRCIzv475nH8Z7Cq6ql925wF2jn8JA4OiO55W0dRbecDCQ51HB6LZzZJrMSiQtmJ3ZdvsljiikTzPxyHNBxV0DVWlQyMuYKw52KlgjjROn9H6MoZzPqF5U2wwsS+uSmqYmoKH/ORbqlBLXPvCJzZ6Dc16zBHqg1sWpg6Bu7VDw0Z8hBfdXZlrsv0YISbKs70C6wfd51Cmjn9Ujr23uPtURVMZYbjKQ7tYz/cEZHKO+7AKr/gRqzRzOPuuQw3zoFk5GfjIUCL5hvD7z2eflroPZEFlQ6NKRYV35oXtuFpJ/Ro5Y1V6VVKOFaRZHXk9wM6u2Zmw9vyZW4yHBnfuzVs6uVNheInNTLsiqz/fMHRx/kz4vhRb9Og4Hn6DfagpzAheJ5axYTnw3tiSpKX01OduUSLJBhVx+mb+6Ym7X5ztLLEiNQ7Yvh6oGUtukpkJAMRA9vt2oNWEeeGf0vJeWgjray06/SsWcFYCbAXOmvVm932/IiUo6XbyIjROftDmnyQpWx8Podwt//4fnBqq1aHCyj07Bv65VfMXOCDBwEuCUYMlXa4qV/ucoL1CTHIShc4Fxn//57lkrbIsngf7Nt5xO/s65b78wgBFHr7aURi3sT826POTGCEVIAb9RBzGZEhSRVyYXCwTNxjlLSKe8HHLAS0jT8X/sN34JP9PIyiuwFzdah3PW9+H25WbteUq5V1E3R6I1IVT5pWqkXFXyWR0vWPIYrDNidiayncJDXbpH+U83Hzy1czxqv5GuZEBm5kPN7Z4PVBee5a5TOxa8xkfSksI9JxNUkASVKM6Tt1fbUTZ5NeHazH8xOg+BYmfnbZIta3j+AQiXnKJ7
 4vhuLMac
 R2NXBZ73rOX7d6cmhgpy3k9uijU1X+StF2SDMX9KpJNanXz+9JhxOiHQdXzCZ8B4heR3KtVBmPntB95hJkd9xyL7Q0Hf3t4mJEbzkpz6P2v6tHRuSgoyYG/8INGtEFfbAETjQV1+YxjFEdgnQnYn0gh66lDIIh/37vBdhSs5uF9DV21+NxGxU9cgaWtMlsQVqtCkc30jSvBggfYuwEAeOdsYB2Nn0sPhsVBN7tbtVn5ryCXLHZ2Vi1NQpFFD6bPP08t0C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 19, 2026, at 23:15, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Sat, Jan 17, 2026 at 10:38:48AM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Jan 16, 2026, at 23:52, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>=20
>>> On Fri, Jan 16, 2026 at 10:38:02AM +0800, Muchun Song wrote:
>>>>=20
>>>>=20
>>>>> On Jan 16, 2026, at 01:23, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>>>=20
>>>>> On Thu, Jan 15, 2026 at 05:49:43PM +0100, David Hildenbrand (Red =
Hat) wrote:
>>>>>> On 1/15/26 15:45, Kiryl Shutsemau wrote:
>>>>>>> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by =
freeing most
>>>>>>> vmemmap pages for huge pages and remapping the freed range to a =
single
>>>>>>> page containing the struct page metadata.
>>>>>>>=20
>>>>>>> With the new mask-based compound_info encoding (for power-of-2 =
struct
>>>>>>> page sizes), all tail pages of the same order are now identical
>>>>>>> regardless of which compound page they belong to. This means the =
tail
>>>>>>> pages can be truly shared without fake heads.
>>>>>>>=20
>>>>>>> Allocate a single page of initialized tail struct pages per NUMA =
node
>>>>>>> per order in the vmemmap_tails[] array in pglist_data. All huge =
pages
>>>>>>> of that order on the node share this tail page, mapped read-only =
into
>>>>>>> their vmemmap. The head page remains unique per huge page.
>>>>>>>=20
>>>>>>> This eliminates fake heads while maintaining the same memory =
savings,
>>>>>>> and simplifies compound_head() by removing fake head detection.
>>>>>>>=20
>>>>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>>>>>> ---
>>>>>>> include/linux/mmzone.h | 16 ++++++++++++++-
>>>>>>> mm/hugetlb_vmemmap.c   | 44 =
++++++++++++++++++++++++++++++++++++++++--
>>>>>>> mm/sparse-vmemmap.c    | 44 =
++++++++++++++++++++++++++++++++++--------
>>>>>>> 3 files changed, 93 insertions(+), 11 deletions(-)
>>>>>>>=20
>>>>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>>>>>> index 322ed4c42cfc..2ee3eb610291 100644
>>>>>>> --- a/include/linux/mmzone.h
>>>>>>> +++ b/include/linux/mmzone.h
>>>>>>> @@ -82,7 +82,11 @@
>>>>>>> * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with =
hugetlb, we expect
>>>>>>> * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
>>>>>>> */
>>>>>>> -#define MAX_FOLIO_ORDER get_order(IS_ENABLED(CONFIG_64BIT) ? =
SZ_16G : SZ_1G)
>>>>>>> +#ifdef CONFIG_64BIT
>>>>>>> +#define MAX_FOLIO_ORDER (34 - PAGE_SHIFT)
>>>>>>> +#else
>>>>>>> +#define MAX_FOLIO_ORDER (30 - PAGE_SHIFT)
>>>>>>> +#endif
>>>>>>=20
>>>>>> Where do these magic values stem from, and how do they related to =
the
>>>>>> comment above that clearly spells out 16G vs. 1G ?
>>>>>=20
>>>>> This doesn't change the resulting value: 1UL << 34 is 16GiB, 1UL =
<< 30
>>>>> is 1G. Subtract PAGE_SHIFT to get the order.
>>>>>=20
>>>>> The change allows the value to be used to define NR_VMEMMAP_TAILS =
which
>>>>> is used specify size of vmemmap_tails array.
>>>>=20
>>>> How about allocate ->vmemmap_tails array dynamically? If sizeof of =
struct
>>>> page is not power of two, then we could optimize away this array. =
Besides,
>>>> the original MAX_FOLIO_ORDER could work as well.
>>>=20
>>> This is tricky.
>>>=20
>>> We need vmemmap_tails array to be around early, in
>>> hugetlb_vmemmap_init_early(). By the time, we don't have slab
>>> functional yet.
>>=20
>> I mean zero-size array at the end of pg_data_t, no slab is needed.
>=20
> For !NUMA, the struct is in BSS. See contig_page_data.

Right. I missed that.

>=20
> Dynamic array won't fly there.
>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov



