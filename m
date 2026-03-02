Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 766F9D58E49
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 03:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFAE6B0092; Sun,  1 Mar 2026 22:11:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CED6B0093; Sun,  1 Mar 2026 22:11:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B496B0095; Sun,  1 Mar 2026 22:11:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5491B6B0092
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 22:11:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8812459E83
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:11:44 +0000 (UTC)
X-FDA: 84499648128.11.9B67622
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id D31A120002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:11:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWQnUevh;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772421103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c80IjFmwrSTyfEdA2osb6JnCGS7RM2etVw9Vzge3vcA=;
	b=L/sz8oWkwjX7SCWufRTtFcBiGCbusQ8sbvbzcO/9ozxeZekRHo9TO0SiMmvcugf4FaiCKC
	7hoU8Z0a2l1EpFKMdY6uyFRVspauc5HpaIm0G/3tGu82EaV65wTdWhSypAYCH7kBiuox2X
	dWs1CbTN7e2dBYnxs3d19Th4RAEpx5k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWQnUevh;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772421103; a=rsa-sha256;
	cv=none;
	b=qNByQpMtgPPEG8A8igFboTFG+l58/luOowsq3BkC8BpBMF9QnaRUyTOlzkS1eucd3AY+Lj
	0EKU0DaoYG5dwOzbXpNRnecOf1gyMoRernPQoTtb6S7w5Rc0EJVD19eCx43fOoQLM38mrO
	3CF+SOEeWPQtKUZjd5GHI8dexuD7TWk=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772421100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c80IjFmwrSTyfEdA2osb6JnCGS7RM2etVw9Vzge3vcA=;
	b=XWQnUevhvW3qqt0n4MlcEcWHSZ9PyYGSKnaoUT9LD7wZytjhOoL4nZQVilpTsPHWq03g7t
	cWdDmURaQq8W53Sfoqq1cwyqVh/BY7X9Q3O30L3PFDo0vomLWjqiuHGs12JSmtR86BFf6N
	6SN+deifYZIQ7qmRKRLZh9ibPTEC1/Q=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCHv7 17/18] hugetlb: Update vmemmap_dedup.rst
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260227194302.274384-18-kas@kernel.org>
Date: Mon, 2 Mar 2026 11:10:54 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
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
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A2A3453A-DA4B-43E1-B970-F704B140A4D3@linux.dev>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-18-kas@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1x4oj4rtziji5zz68ic6m59fwczqtebt
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D31A120002
X-HE-Tag: 1772421102-739336
X-HE-Meta: U2FsdGVkX19RDwES9vLFoSjHjqF24nWtHLTZ5unaV5fWLA6QwyA3Kur/10kMgWTZMMfJKIfoNjBz5LAWwG6RdvmOsevOyXcM2A1+1FB5U05kk47UbZXrCqeoD0qG2kO8W5gM3Gy8rk321tm5jslEmCb+yaorAE0ajbx3XXd98d0dSNhz6GCibSlCD5gGLCeWi4jsnhgbOmfaUPeaM0MshqYVtnwV8xyLXSUoGfT54Kh58yQzS3nuATRDChXh9iVOQoQtXrkPlLonAqxK8RMXcF0QBPUFLn2+VddBWRghuDnu7VLX/yXjhyz87EYuRvjxo12ZqOhsTT1cuTO3SNfonR6zuduqrajB/h+w/IeYbmOdOpKHtdVR00YUwSZBipnPjoJ+OGAPh7WI2fCj2tY3CPfFhCNnzGDnzneewvjN2smag2oSKn1zVOcwC3ZK33EpHn4dWjN8M0fGT1xFEO+tv/p3Wud73dEZGpVRbvNE2/2SXrImrd3AwT91shFwvi+JwZYJi0addTPno7gRQe/n0zF78bhtrPKZA8XKPrc4szn2WxsOvekY3GJkGoKeJUgUbeNJZIe+ecixxuGORvKz46iH9RkEIcLQ+uH+0aMr5X5m/P2Rg2FW5m2zr5D8kn4OgIKUv3hiU7DaRViRP+pFxTXcVI4npsT1wSa9yNJlc+aJ1tOJ2ZfvFCo48UuDlG9mb25zy1caRWZdEcBX1SZBykMuh+maNrjWPwmXV9D3RYmfigRKt+vGQqCnpKuG6YhGyoXZuIMDzJ1k8V2j/fGPAZjV0OIQpH+xnKrxGw58IQN7UVTOKAAmRGxFzAfx6hIbzBx0DZ5eW+fX7eHBPRhM2rb3cIYGIiN8x+yINXZgQf+BGt48SYsqLw/7+VCaFl47fBanuzgj1Pj04XLey/FFLgWqXcBxdfH5PVzj8DAmSBPRRUTD4uYOli1rUMKeNns/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 28, 2026, at 03:42, Kiryl Shutsemau (Meta) <kas@kernel.org> =
wrote:
>=20
> From: Kiryl Shutsemau <kas@kernel.org>
>=20
> Update the documentation regarding vmemmap optimization for hugetlb to
> reflect the changes in how the kernel maps the tail pages.
>=20
> Fake heads no longer exist. Remove their description.
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Documentation/mm/vmemmap_dedup.rst | 60 +++++++++++++-----------------
> 1 file changed, 26 insertions(+), 34 deletions(-)
>=20
> diff --git a/Documentation/mm/vmemmap_dedup.rst =
b/Documentation/mm/vmemmap_dedup.rst
> index 1863d88d2dcb..4aaef36d8971 100644
> --- a/Documentation/mm/vmemmap_dedup.rst
> +++ b/Documentation/mm/vmemmap_dedup.rst
> @@ -124,33 +124,35 @@ Here is how things look before optimization::
>  |           |
>  +-----------+
>=20
> -The value of page->compound_info is the same for all tail pages. The =
first
> -page of ``struct page`` (page 0) associated with the HugeTLB page =
contains the 4
> -``struct page`` necessary to describe the HugeTLB. The only use of =
the remaining
> -pages of ``struct page`` (page 1 to page 7) is to point to =
page->compound_info.
> -Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of =
``struct page``
> -will be used for each HugeTLB page. This will allow us to free the =
remaining
> -7 pages to the buddy allocator.
> +The first page of ``struct page`` (page 0) associated with the =
HugeTLB page
> +contains the 4 ``struct page`` necessary to describe the HugeTLB. The =
remaining
> +pages of ``struct page`` (page 1 to page 7) are tail pages.
> +
> +The optimization is only applied when the size of the struct page is =
a power-of-2
> +In this case, all tail pages of the same order are identical. See
> +compound_head(). This allows us to remap the tail pages of the =
vmemmap to a
> +shared, read-only page. The head page is also remapped to a new page. =
This
> +allows the original vmemmap pages to be freed.
>=20
> Here is how things look after remapping::
>=20
> -    HugeTLB                  struct pages(8 pages)         page =
frame(8 pages)
> - +-----------+ ---virt_to_page---> +-----------+   mapping to   =
+-----------+
> - |           |                     |     0     | -------------> |     =
0     |
> - |           |                     +-----------+                =
+-----------+
> - |           |                     |     1     | ---------------^ ^ ^ =
^ ^ ^ ^
> - |           |                     +-----------+                  | | =
| | | |
> - |           |                     |     2     | -----------------+ | =
| | | |
> - |           |                     +-----------+                    | =
| | | |
> - |           |                     |     3     | -------------------+ =
| | | |
> - |           |                     +-----------+                      =
| | | |
> - |           |                     |     4     | =
---------------------+ | | |
> - |    PMD    |                     +-----------+                      =
  | | |
> - |   level   |                     |     5     | =
-----------------------+ | |
> - |  mapping  |                     +-----------+                      =
    | |
> - |           |                     |     6     | =
-------------------------+ |
> - |           |                     +-----------+                      =
      |
> - |           |                     |     7     | =
---------------------------+
> +    HugeTLB                  struct pages(8 pages)                 =
page frame (new)
> + +-----------+ ---virt_to_page---> +-----------+   mapping to   =
+----------------+
> + |           |                     |     0     | -------------> |     =
  0        |
> + |           |                     +-----------+                =
+----------------+
> + |           |                     |     1     | ------=E2=94=90
> + |           |                     +-----------+       |
> + |           |                     |     2     | ------=E2=94=BC      =
  +----------------------------+
> + |           |                     +-----------+       |        | A =
single, per-node page    |

You've changed it to per-node-per-zone. Need update.

> + |           |                     |     3     | ------=E2=94=BC------>=
 | frame shared among all     |
> + |           |                     +-----------+       |        | =
hugepages of the same size |
> + |           |                     |     4     | ------=E2=94=BC      =
  +----------------------------+
> + |           |                     +-----------+       |
> + |           |                     |     5     | ------=E2=94=BC
> + |    PMD    |                     +-----------+       |
> + |   level   |                     |     6     | ------=E2=94=BC
> + |  mapping  |                     +-----------+       |
> + |           |                     |     7     | ------=E2=94=98
>  |           |                     +-----------+
>  |           |
>  |           |
> @@ -172,16 +174,6 @@ The contiguous bit is used to increase the =
mapping size at the pmd and pte
> (last) level. So this type of HugeTLB page can be optimized only when =
its
> size of the ``struct page`` structs is greater than **1** page.
>=20
> -Notice: The head vmemmap page is not freed to the buddy allocator and =
all
> -tail vmemmap pages are mapped to the head vmemmap page frame. So we =
can see
> -more than one ``struct page`` struct with ``PG_head`` (e.g. 8 per 2 =
MB HugeTLB
> -page) associated with each HugeTLB page. The ``compound_head()`` can =
handle
> -this correctly. There is only **one** head ``struct page``, the tail
> -``struct page`` with ``PG_head`` are fake head ``struct page``.  We =
need an
> -approach to distinguish between those two different types of ``struct =
page`` so
> -that ``compound_head()`` can return the real head ``struct page`` =
when the
> -parameter is the tail ``struct page`` but with ``PG_head``.
> -
> Device DAX
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> --=20
> 2.51.2
>=20


