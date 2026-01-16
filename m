Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A60FD4A5E2
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65156B0005; Thu, 15 Jan 2026 21:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08FC6B0089; Thu, 15 Jan 2026 21:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0AFA6B008A; Thu, 15 Jan 2026 21:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A08226B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:38:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EF7FB9E6A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:38:49 +0000 (UTC)
X-FDA: 84336269178.26.FAAA697
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6E3DF20006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:38:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J8ied54h;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768531127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cri5zZeu4l/sHLTLn9DRdlp9oa54DmyMUfS8ASAgrDA=;
	b=yzpLR3F8YOeDpICJi4HmAjdlQ/rqjU7RQ2C+DdOKC0dFR2d4oCu3ZHGw80okdDDMPnMIRh
	QCbL+uhpoSZtVTbTcCFJ+0GH7Qqaa23+7wem/IwwFqUz6R17bLDwWGpDD7vuNF0eae5W0R
	A9m8PzpdMyWvVsYRiITkE2xxfCq2Qh4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J8ied54h;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768531127; a=rsa-sha256;
	cv=none;
	b=wAIYip/kQ/q441TpxGUfWb5f/IRp5OcAF2WxKdtoeKx+8f4yUHGolYl4zcBdm9+Iq4+Mme
	0GyrdXo50fjkgDwcfZpp6nTNabDwW1ZQboe3HQMjtZHJ2+LPTotMqaqMoH7HtkDy5TYP7S
	d04dC0ZwNk3FD2E7s9JYjPJL/9kX6Jg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768531124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cri5zZeu4l/sHLTLn9DRdlp9oa54DmyMUfS8ASAgrDA=;
	b=J8ied54hRAfiXmZcd/vJyhN9dJE7hJs1aNeSfCEuIbfJPIgWG1kr94x4EqA139RWuzrkEX
	YALxrBbcH/av5nhsPkuvrA/7F+Z4Dv8MJ0EuzmF4mxXlQDQEifADJG1c4WkESctGO8glsn
	dSwO4Jq4+ofcmb9qpgrPRPkQYAaeRiw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aWkhbWR-3fWjeTaE@thinkstation>
Date: Fri, 16 Jan 2026 10:38:02 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-Id: <53980726-C7F0-4648-99E9-89E10645F2E7@linux.dev>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-11-kas@kernel.org>
 <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
 <aWkhbWR-3fWjeTaE@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: h1q57eabfwy5r4xegx14n6n5jthd7956
X-Rspamd-Queue-Id: 6E3DF20006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768531127-877425
X-HE-Meta: U2FsdGVkX19WhJKj/Id0EiK66PyTUuA3bc52xOS+E6cKGi1hmH1djrkDCTfTXZV3MeCTxAbF/NpkZtppd8i4C0GAg4m0Uw9f5kzhODcSuLTbedhj6RzJm70nxk+vIjk0tuaoksLlXH3LliXeqhVscRKCPXVPpC9pxUt143eICeVTuzEWIkUEn0EzBOY/rXjnPaG3fjYX4A5ZQjHkAxVI7O80mHHT6d49GwS+cgBm1xOBPnqMAeqL8i2FEtY4GWdoDiZIr+Bu16tC6AZhRaN+3pfW9OWQLH6pXAz5WodVfF27YXl9r9RmszH/jSKT7OzHRhP4GOudcdwLnuJ9IFipYGpLVBqkJCrNs6dt6Jg96kBrURr1itkHw+gwKTSy1R8DMJyDLo7iX0uiFxwVcnswokUNrwydamCEGy7F9VsadnfWt/rLE0CS/SX7Am8m4YagJhEuuElzlIy/Bhxg4WjuPlWCMgSPM9aE8nQwx97BAQFBaTLaW/lxr5WDD8WspX6t/iOjZmEBnm2OHFjnMAlsdtvMbLH1k27E/HQSvCCZFVzP4Pgm96Rnbs3a3AD4yzLgh5Hob8btMjRi49DdXTu8xjf5QY0fUBut0nHqrgAv1fXSO3UGybtk2x/wgQGfQ5IXSR1BNs/HpqvKZbs7JC996QkJpdeXpj7VP9wxqBlH/N/8b2EZVy3xzsGYRHsLaRYJwi6giiPNorBe+KduCzMkx2kEGe6EcZ7obpFf7h1MmFlk4+yfWXf/fdgRY4c86EQ2YiMdxmFLAJaxsFKWMjmUMmW5+rViHTTgHwW4Eld5VcMFJMPaSEcDWF2X0Wd3uxrKm4kim1R6Ipn5Q3d07EtsZTNtETf9pAPgAPwUJOOqfwBElmp7vRcLeXPI6BEpFTSMsFQQ3sQj3MZDNC8gwPmQzN9FILrblyTSF4tI8fER5VwzLU1+S8iGaXszZHW15xCVZ9OhdR+4W0NJ3wS/+sN
 1b5yOsxa
 0iwvmjPEbrP+7c7nFaVxy6v1IpblLicSqKU2d5alB9Bqxd2umabsuSmyrTYWV1fa5zRnuTPw1qsFPIPW5Z8YJawh+CC7ABfk/d27f2MK7Yd1g9/Nikf8AdeQsWJ8T0jFvtSwshCk7GX2CW2p4Mu3hf1aDdQ3W0qmIVEtXZssdWNlfONRPSPsI51WcIhGoi+xJTcCfESBLqEU5nrWaSrG1+OrvG99zsvypocwo/AEsLW8XgCK2CjNol64vzKDuirLSiVGz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 16, 2026, at 01:23, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Thu, Jan 15, 2026 at 05:49:43PM +0100, David Hildenbrand (Red Hat) =
wrote:
>> On 1/15/26 15:45, Kiryl Shutsemau wrote:
>>> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing =
most
>>> vmemmap pages for huge pages and remapping the freed range to a =
single
>>> page containing the struct page metadata.
>>>=20
>>> With the new mask-based compound_info encoding (for power-of-2 =
struct
>>> page sizes), all tail pages of the same order are now identical
>>> regardless of which compound page they belong to. This means the =
tail
>>> pages can be truly shared without fake heads.
>>>=20
>>> Allocate a single page of initialized tail struct pages per NUMA =
node
>>> per order in the vmemmap_tails[] array in pglist_data. All huge =
pages
>>> of that order on the node share this tail page, mapped read-only =
into
>>> their vmemmap. The head page remains unique per huge page.
>>>=20
>>> This eliminates fake heads while maintaining the same memory =
savings,
>>> and simplifies compound_head() by removing fake head detection.
>>>=20
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> ---
>>>  include/linux/mmzone.h | 16 ++++++++++++++-
>>>  mm/hugetlb_vmemmap.c   | 44 =
++++++++++++++++++++++++++++++++++++++++--
>>>  mm/sparse-vmemmap.c    | 44 =
++++++++++++++++++++++++++++++++++--------
>>>  3 files changed, 93 insertions(+), 11 deletions(-)
>>>=20
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 322ed4c42cfc..2ee3eb610291 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -82,7 +82,11 @@
>>>   * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with =
hugetlb, we expect
>>>   * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
>>>   */
>>> -#define MAX_FOLIO_ORDER get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G =
: SZ_1G)
>>> +#ifdef CONFIG_64BIT
>>> +#define MAX_FOLIO_ORDER (34 - PAGE_SHIFT)
>>> +#else
>>> +#define MAX_FOLIO_ORDER (30 - PAGE_SHIFT)
>>> +#endif
>>=20
>> Where do these magic values stem from, and how do they related to the
>> comment above that clearly spells out 16G vs. 1G ?
>=20
> This doesn't change the resulting value: 1UL << 34 is 16GiB, 1UL << 30
> is 1G. Subtract PAGE_SHIFT to get the order.
>=20
> The change allows the value to be used to define NR_VMEMMAP_TAILS =
which
> is used specify size of vmemmap_tails array.

How about allocate ->vmemmap_tails array dynamically? If sizeof of =
struct
page is not power of two, then we could optimize away this array. =
Besides,
the original MAX_FOLIO_ORDER could work as well.

>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov



