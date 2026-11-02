Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8AD606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qxJ8HCof
Received: by kanga.kvack.org (Postfix)
	id DCFCF6B05B3; Mon,  2 Nov 2026 03:09:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6F86B05B4; Mon,  2 Nov 2026 03:09:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC376B05B5; Mon,  2 Nov 2026 03:09:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E41D6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:09:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A756A8439
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:09:18 +0000 (UTC)
X-FDA: 85389453996.01.E240E45
Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9DDB1180004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:09:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qxJ8HCof;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.53 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793606955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ua9j3chuGLeYY0btIyoz40p0xgL7yj+uIcM50lwlwKs=;
	b=Z+tGyi/Mznq84vp5j6FUys4lpX647KzlvUt60JBXZ56a78tNU2tIWqmF22DfybrVrS0rbe
	jXWY6X8hEl6Ev1/JWwVTLVhik/GXqVijPj4HPB9HnwlezjyGaHNL5e7yp+UWOdglVRwFML
	R/0iPOjCfDACJ5ZtTXZ7d2XvPqJNYU0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qxJ8HCof;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.53 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793606955;
	b=4M0hoFsdLH+dvum5f+c1Zqitf7dQnUCQ75nB+IJbOI6fwPwJQAy70pikfStzdgGJ6hufYd
	Wo9A0+MYqaV6HLjCYG4Hw+wfymetMBL7Jc1Y85+/5WAt+oBsvvl0UPRx3LehLzgydLTqRq
	uJzzLyUwsdOcAQuIrBpcP7kL409Zm+4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AJzTmqiEw66QyrrtTwvf2v4Wxl2wkr7mScJNfEWS5L4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793606949; v=1; x=1794211749;
 b=qxJ8HCofo4rfUF1gSK/co9lCPJ9MFuCXHgOd98rdkqmIUsARH9XzuI7qtTqUG7ftdjuPzgGL
 mbt2I/nICtNl8FYp0d98GdB5efQorqTfwGF/wOCWskxBI7uubraROUrtHI460R8K3W6nvL5cQJQ
 3+kR+7R3oUUa0soLBB4XPKDE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 54617e5f3eb6591b;
	Mon, 02 Nov 2026 08:09:09 +0000
X-Mizu-Trace-ID: 54617e5f3eb6591b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 12/15] mm/hugetlb: keep surplus folios that are reserved
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-12-a0a033db180f@kernel.org>
Date: Mon, 2 Nov 2026 16:08:46 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Arnd Bergmann <arnd@arndb.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>,
 linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-s390@vger.kernel.org,
 Chris Mason <mason@kernel.org>,
 stable@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C4D9D9B7-F875-4A05-B3A4-DBD0BD496EA5@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-12-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DDB1180004
X-Stat-Signature: xfuxii83y6cds4zcwza1wpad3g1yqn4s
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793606954-748352
X-HE-Meta: U2FsdGVkX18PwWtBB8BlQ1r98jlwECQ22wu7ymUyytoaeXGRIx7aEm4/Flh05d8xgFkhv7A2i/GaK8JWBucRrtaaO7maF3FP9mCMc+FMJyLkfy87k6DsYPwWLzUzTN5TMNN9LBMFrxGCXD7ngGN1RUwx3KGKEXjqySxN6tK2IdQgQ4d5Pbj9EBVNU353/xcqoWjMTWZB1KPQFNDV67wtaC4MrBsvX0x8dh2R60nW36h6rLu8cjPm5kGFRWbmglozbnpjMT4AY+Z5z+kRCdQRyQYvAdsylpKz0Dl8k81GJIDR3ch55EMomoYrzsFcO2iI13FL57vjSGxDMtV8xsvtgwoUfx6s4VTgiXGXVn+u4/sQdGZj8XOXqEb1EjuLrHJuki3I8yj6seC3nns0OsLRge0OyFIPm75Pg80Thv3PmkUqor86LmIwD0CebI/UMOjkI4fubucJI0GbRWoLTLvgdT78Pq1VHaveW5z9woSjs19NRM3UdVh+7A/a4DLTXJgxpYJCs9XS7kpNVvaBBO6EvnqMG1RJDRuBa9ZkRKzJcCJt6lGF/C5WYF/HyMyf64YBsSF7Cou/A6l3Ett7bh7chZXIn+/Ou1GmpTdI1Vq8oATiu5TpmLXI7lucoHr/DTYIwpdKKRd/2S7i2sPv8CdN7MomMu8po0XJ7i3H4sodhpo6Q/WMBKgpxFzlNxFGFdTqBwF9OOsd5RPBbornCBJxEI7FGUQm/Nqzaa58lJ+1RqFP78+fUv5++eCbB75axhwsOZFJEQBASIJ1RzobiiCmGusBIu1lXo4KQVujwHTmXCxGdn47s6dBMSqgZ8a1xoE8Hk7dQ6fG/X9803FVOUaCPVdmzP5KO3zV2vJ76yC8+d1V2BajRno5IrIMdWSz8ljm2bbq/F1oWH6WQCXLSaPP4qxvcsZh+COt8wf+IdZvZRrrHRe0SnXPcPyqkUGfP9MJmUpi11u3eA1Uc8zXNWf
 iT+IbL3/
 BzOeTWXVhHdEMNHxV1x7C+aVo1Q3nuZISP6ZGIh8a2KH4hPCp8xTZ9nKIgQBxYezpQuJVfk3V0XLyyMdt3uJ1qgho/w09Jw8Vbv4xpRGO3Ggl9gY0w/1r09DAJBTeTjf+Fe4qFju+ES4duNxYKQGvUS+51plpwhSelbefubV7e0Nk2IO+IcJvz4m8+5p6nP3vtPvFpIvTiiChMsx21fbSP3cu2HfEERcZamgrrDi9f52QggI0SDiTsJdpd4KtZxFKZiexQSFvtrCZTN1I4AQ8h/yWS/mAQbl8VSQfgcCPMPlg0EoHZiV1lDXQ607CwVRFmlOImvvDkCzbR7E0dEwwHthTd4/rI647gsBK00QIvClk/9/yPBMomK6KUu0Lc6A6JAonsBr5fXJ4nNZyvQA6yfdOmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 29, 2026, at 04:13, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Chris Mason <mason@kernel.org>
>=20
> free_huge_folio() may restore a reservation, but still returns the =
folio
> to the page allocator if its node has surplus huge pages.
>=20
> For example, start with no hugetlb folios and allow one surplus 2 MiB
> folio:
>=20
>  1. Mount hugetlbfs with pagesize=3D2M,min_size=3D2M. This allocates =
and
>     reserves one surplus folio: free=3D1, reserved=3D1.
>  2. Create a 2 MiB file and write to a shared mapping of it. The fault
>     consumes the folio and its reservation: free=3D0, reserved=3D0.
>  3. Unmap the file and truncate it to zero. The mount's reservation is
>     restored, but the surplus folio is freed: free=3D0, reserved=3D1.
>=20
> Besides losing a hugetlb folio that is required for a reservation, =
this
> can also make available_huge_pages() underflow and cause other issues.
>=20
> Keep the folio in the pool if it is needed to cover reservations,
> including any reservation we just restored.
>=20
> Fix generated by an LLM and sent by Chris Mason in private.
>=20
> Fixes: 07443a85ad90 ("mm, hugetlb: return a reserved page to a =
reserved pool if failed")
> Cc: stable@kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify comment and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


