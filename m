Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58801CA5FA6
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 13:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300E86B0088; Mon, 28 Sep 2026 09:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B23C6B008A; Mon, 28 Sep 2026 09:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9E16B008C; Mon, 28 Sep 2026 09:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0E0A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:50:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7638E1A01CE
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:50:25 +0000 (UTC)
X-FDA: 85263305610.11.9B5E0A3
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id ABF9E100005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:50:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q8XJ6CNb;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790603423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwGEFPYPtNOaPfcKsHGyvboh3/0JIjAHnUCjf3u1ZsI=;
	b=hOudEaHpbHE28pSKCNDdxlmyAeNTfUvzGADcE8MP7mQbmuk00VR8ShtNnagLiwZ7cPp0me
	6Wbt+fI09JK3n7ojVm2uLy6MgzrTSP/rYRwOwHov2zP/YUT8cxhZgqkNaoTkbxrmqmYZH/
	cH2eRPgnprXArVu5zJ8yQb/qF9N6MVI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790603423;
	b=6/Ek7m1Tbpn5ZIe0xWXF6Z2ZOij057DqG32UeryXQAwVqRXr/Hgc9jiyd0j9uU4vhsh4Vz
	EeezzOCC/WUtD1IzDG2Z6J+zdO6gK4DAKTC0PbnO2R1jefeOlNAszrKfz7hLB0GF6XDyvV
	E4IInaI7vfDAaq/9/cciFLbnuyIlT1o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q8XJ6CNb;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kwGEFPYPtNOaPfcKsHGyvboh3/0JIjAHnUCjf3u1ZsI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790603418; v=1; x=1791208218;
 b=Q8XJ6CNbCMFKzmL8RUg+vJppTHPo2X824pWFNsGGPnYSlEljzBMnGBSNi1/D5JHRuL9rCTYO
 1E6TqHMxyEvvovgL6kj3Cfdrurhwc2MVmMg97jTrXlF1NJ592MRYZemi775QBCAashwKLnYleQ3
 4DGLadlzvb6/1zZfB2qXGm5w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e0d00ebac706a868;
	Mon, 28 Sep 2026 13:50:14 +0000
X-Mizu-Trace-ID: e0d00ebac706a868
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v2 0/6] mm: Unify device DAX and HugeTLB vmemmap
 population paths
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <607759bf-59f2-4ad6-b95b-e780ed2acba3@kernel.org>
Date: Mon, 28 Sep 2026 21:49:55 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8385F749-0F72-494E-9CA2-2E433A066712@linux.dev>
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
 <607759bf-59f2-4ad6-b95b-e780ed2acba3@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspam-User: 
X-Stat-Signature: 5k6pgendrcxz33zxyi51mhee5wcryfms
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ABF9E100005
X-HE-Tag: 1790603421-624414
X-HE-Meta: U2FsdGVkX19T51bsJ8oT9MjFNZumAjpjNuc/z+W8IoX3DEoH7ZjUrygc//KfyLOCpu2PEnm1o/J2lOjgaIIfs2nrE0UzLv75FrR7n8+E1BWa4ss8fwfURiIMTZp40cLGX8ATbDIsr4Xw5w/jNbXDG300vKntROzIQdOkOmeOOIV7IPbTYs1ucUrReUFDZVXWH8SbzyIXrKcBK3o3KqoPEEttJ6mRR3mGafFRtBzEuPQBoaqgGv2kSW+yeQXg3aBhy3+eviG3HZHrUIPfSipUF9j94RP2Owj0YNbdco1af5QLHf3S+KpBHGG6UO9P/0MeMSc1fKTmbm0tPexQT3owi1MewtyrMw1gDKTpZWQkeMwpcnxiyJ5BS9n27/+y3QJuNxqp5GSAdvjYf1LElwhnedFtEXySQoDrzQ1lrbn1dwxkMnxAUTGO+a5zrvZuQLa8aI9mgLhfp2UgCy69brwRAgb9jwQ5pBSCNOrXAzu8XofElGUrENHQDMIe2OF2SufCyL86UIcuivYJ9NNaZnSIqmRM4NNbVCCpJWx1j3y9x4g43iHAIh+7sryvwBvk+CmGLhCwtc64pNlZDMEu6oAnKBiFrAXHZBHV1LZwQlk65b9FL0/eabPb7QYyvMp6Tt+UEDzGQZ03psDHq534BEi5sZT+lPyMb3P6zDSjzHKE3xH9W3ZPlGkulnpRjJ28FcPUqU53Jlz+hB9fgGNyaLTQESKRVq0a2Ixc41c8kvLSLdAsn/kgP1+w/zcWMU+Cy5g32kZ/ZJU5jBwv3X0b+Q55vI37FboljIIDe1Bxd4VEyC8Uxf0Y/y9ENnytRDo/XV1JnxumWY5F9myhzdlT84X0U1yTbRDrMkT9CjpQ0R/LeK3b3O96MjgVby+cKO0ss+G4rzZjYherQIXfriG0tsDaShOoKWfU1Z++Ya1f+eTu5yi0ZEYFnt8GE8eDL6Nt1sqei+Ea6QxkYCy6hly4BM1
 5ORYTT7y
 4qQYfVZn0ToXy/0qvOW6TnctR75nTRlMpEubfvHqbTb0Xm/ENekBH1Uu3MliQZ4VNJpPwN3SP12GklfJtrNLmrkLd0Py+QYMRqcTX++CEDzXp9cgfMMQtD81ay9kgArrn5AWAXn4cQiYebAS3ouAoRLQeH4LyojR/2NV5K50Mnnr6TlL9yQJoOsyV1LodDxu1JUk8CX8U00i1EGnjIZ/yb2WciUtV0VEmJ9qX2D9/8F+/U88hQbDrGBpNd9i7LN7SI/j8wl7QivHMmoE27y8LY2kJ03TsFQCxiC8MlSvhP6f0p8BxQ8uGMkGXlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 28, 2026, at 20:44, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/24/26 09:52, Muchun Song wrote:
>> This series is split out from the earlier, larger series "mm: =
Generalize
>> HVO for HugeTLB and device DAX" [1]. While the parent series =
generalizes
>> vmemmap optimization across HugeTLB and device DAX, this subset =
addresses
>> a single, self-contained step: unifying their vmemmap population =
paths.
>>=20
>> After the preceding Device DAX conversion, both HugeTLB and Device =
DAX
>> describe optimized vmemmap mappings through memory-section metadata =
and
>> use per-zone shared tail vmemmap pages. The generic code, however, =
still
>> carries a Device DAX-specific population flag and compound-page =
population
>> path, along with arguments and helpers needed only by that path.
>>=20
>> This series first removes VMEMMAP_POPULATE_DAX and moves selection =
and
>> reference handling for the shared tail page into the common vmemmap
>> population path. It then removes the generic Device DAX-specific
>> compound-page population path and routes section vmemmap population
>> through vmemmap_populate(). The powerpc radix path continues to use =
its
>> architecture-specific compound-page population implementation for
>> optimizable sections.
>>=20
>> The remaining patches remove the unused ptpfn argument, open-code
>> vmemmap_populate_address() now that no caller needs its returned PTE, =
and
>> add a warning for inconsistent zone initialization of shared tail =
vmemmap
>> pages.
>>=20
>> This is the fourth smaller step toward the broader HVO =
generalization.
>> After this series, HugeTLB and Device DAX use the same population =
model
>> instead of parallel generic paths, while powerpc keeps its
>> architecture-specific implementation.
>>=20
>> [1] =
https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.co=
m/
>=20
> How does this series relate to
>=20
> =
https://lore.kernel.org/r/20260927025441.741633-1-songmuchun@bytedance.com=


This series is based on the v4 version [1] of the series you pointed =
out. When
I was sending the current series, the v4 version of that series had =
already
been in mm-new for some time, so I sent the v2 version of the current =
series.

However, a couple of days ago the kernel test bot reported an issue, and =
this
issue cannot be easily fixed with a simple fixup. So I updated that =
series to
a v5 version.

Therefore, the current series needs to be rebased on top of the v5 =
version of
the series you pointed out, and then sent as a new v3 version before it =
can be
properly applied or reviewed.

If you're planning to review this series, I'd suggest waiting for my =
rebased
version.

[1] =
https://lore.kernel.org/all/20260916064341.1825793-1-songmuchun@bytedance.=
com/

Thanks,
Muchun

>=20
> ?
>=20
> --=20
> Cheers,
>=20
> David


