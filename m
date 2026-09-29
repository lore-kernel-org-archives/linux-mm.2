Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEDF2CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6696B0099; Tue, 29 Sep 2026 03:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87C26B009B; Tue, 29 Sep 2026 03:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E776B009D; Tue, 29 Sep 2026 03:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79BED6B0099
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:55:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 119DBA0429
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:55:51 +0000 (UTC)
X-FDA: 85266040902.07.D640D86
Received: from mta0.migadu.com (out-166.mta0.migadu.com [91.218.175.166])
	by imf28.hostedemail.com (Postfix) with ESMTP id DBE17C000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:55:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NDrUg/Ro";
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMi3M1iULFUfuMEEhHz4Tqsh151CRH++Ayaby/JxpbM=;
	b=R6M9INa0j8LkfBsULYAMySRSYw6dFVz9sylmgi3K9p+BE4OGeNiEmdn0O33L4wCZ5RAihe
	RRqOAAqkzGDBbyc7aM9CJX4AwT7x6uIIatkCjF/7UbBg32dxXcyFFYA3dxVhKI9fyNZ92J
	pg5ebFv4GErcn1cKc/3LStBC2C802GQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NDrUg/Ro";
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668549;
	b=GgV/KSAuPZlx3ErTCcEWPDlMpb4F6sGEEQd05sDWTtt14RIoqZL1CO3cmKpRbeUMF5D9W/
	xt7qYEmoP4T4XlYWqQS1vW6xqaZjnXectL6yuJaUFlUCgHYh991XGjOMSB4GY7gbWEdd1J
	2wNhZm4HmTv/8bvdOXHIoqHgIPHjyqk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nj3wtQVl7vcnhMbNppV9t0dGEHcungOiAb7gmBQ9b+o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790668547; v=1; x=1791273347;
 b=NDrUg/RoF1bPvVighGofc9LgFh5CsV8P86ekZ3WhxBT7oEPsv2EaiQEbUnovbXjLyRji/zXp
 zu1s05qQAaWgnEjHbV11T2RK/fszFU/20H8cgPwE/HMRnaKxGC/qzDC7+I+Z6jOgfFoZRyMwaa0
 RyucxV3hUsLBqVNRW5VdkRs0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 06442dbddb022582;
	Tue, 29 Sep 2026 07:55:38 +0000
X-Mizu-Trace-ID: 06442dbddb022582
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 01/12] mm/sparse-vmemmap: factor out shared vmemmap
 tail page allocation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <5c73e3b9-4eca-4b84-ba3d-85bb7d6f77dc@kernel.org>
Date: Tue, 29 Sep 2026 15:55:21 +0800
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
Message-Id: <6BA39A32-5851-42B2-8822-F427D08577D8@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-2-songmuchun@bytedance.com>
 <5c73e3b9-4eca-4b84-ba3d-85bb7d6f77dc@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Stat-Signature: xoo3ahco8fumnkmxppkfa3h46bzuo4n7
X-Rspamd-Queue-Id: DBE17C000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790668548-889688
X-HE-Meta: U2FsdGVkX1/g2DtaqZowpOnAvuPBUrMxIIS1KbDOeIgfOx9am1LyaDMPFUWxtS+j58jIgzN3YyHvJn4P0sFOJsDyCdgS4wSqHOf50CMdMFw71O7KgSU1s8o1CoGHj2BHgf4xg15Vf9gfTGOz07HZSoxfvPysrDd118hvkKBMH7V66EgxCtcSNq3pHBbkunvE+y3MybKs6B3Qi0MPCYuWre8KvNZRu8yIof41ZrWGGikPm3VYwyE2W6Y98KOL6oarVOvzYEoLw3bOzYvLAUXaUNaOOsbD3umd0DZ1K01DSqt1sUjpcwgXqABuQTVyH3T8OSRNQogQKBrIhJEMa7rFy88ZebR5TcwolgHYiSEX8V+tS2sRg0Lzo+wT+skOvB4eHMLJyJnMh6M/pZ764mfTDMVBiRIIejGKGvaXNkP0CWTUHnMIANw9sIGMAnKidhxsaYHyvQr88+N0q4CvwcgWaXkT3692Xfi17Iqi1PD+/aCSXpxA9aTqO80/aFfT8Tkn97ZlIzR4YvbOlADDdIk+pOlWnilGb6CQC/F/Gtr2s5jKfI56hd/PzLLHYCv49DuzrrLEwaAHO86qKObt2QrRvo/RYHpw20YSgtyIMIPqp4KxlvWIFIJY6XLuVkZoPQmsn7K+cpqdnQ01uELfsatDLjW0fPVfgsrCQdFUMTA7zoiLJxU2+JKWvsfUUwm8DLoEUx9lS3OopncFeP1Lsh7jj9zcvKpDVnOMR2wa/Djnpx+4Pa9KdA7Ckhiy2lUX1X6wMTmxu5npiaK+aSfrs97r205Hckpbl2mifx8mfmAK/IhFRtshB5Ren5oOay2Q6B4VArX/GRPLVeRrDaWWLDRObDOAhTpTxHxbuVXXDbCQBElPmfxhhIc1itlYOXcuhQP6HafVNVDdk3RJlw2IPa2Lk19ThytS9ACqei9VaqXUvCEccP2JlbqV4aCkRki5ym8DGM6aowK2JeIpzzanZJw
 esiHc2fk
 y5grJxL8mEz14F93d3yhqfk9N4ekag7xRqyqPohsUYmAbqmPR1dPZy9UC6+Htc/1UupWbvQ/s+SNLEFqbOmEWhTVC1iBLE8gvctxsRKwm6CefwQKm09e+E4lFvD/DstLGGol+d3AtTV3e54XJdOOHzCC+xFpWRfIEpSCaHB4ytpoWuUo+4Q9kzA9LxP2Ad0U7EYPHeA2FLGFrXl73jZwDPTvql/ka+C/Up2K1GisHjAs8g3hpo1aZNZl7rH66HeBpuvA8qQrK0hoyreY3vGX7XJIJFHde037SKCREw8x9RdOfp2/5BGygUGl1PyPMMCnd5g1a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 15:16, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/27/26 04:54, Muchun Song wrote:
>> HugeTLB and sparse-vmemmap each have their own helper to allocate the
>> shared vmemmap tail page used by vmemmap optimization.
>>=20
>> Factor that logic into a common vmemmap_shared_tail_page() helper. It
>> allocates the page through vmemmap_alloc_block(), initializes the =
tail
>> struct pages, and uses cmpxchg() to install the per-zone shared page.
>>=20
>> This removes duplicate allocation logic while handling both early =
boot
>> and runtime allocation through the same helper.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>> v5:
>> - Move this patch before CONFIG_VMEMMAP_OPTIMIZATION is introduced
>>=20
>> v4:
>> - Update the commit message for the renamed VMEMMAP_OPTIMIZATION =
config
>> - Collect Acked-by from Mike Rapoport
>>=20
>> v2:
>> - Collect Acked-by from Qi Zheng
>> ---
>=20
> [...]
>=20
>>=20
>> #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> -static __meminit struct page *vmemmap_get_tail(unsigned int order, =
struct zone *zone)
>> +struct page __ref *vmemmap_shared_tail_page(unsigned int order, =
struct zone *zone)
>> {
>> - 	struct page *p, *tail;
>> - 	unsigned int idx;
>> - 	int node =3D zone_to_nid(zone);
>> + 	void *addr;
>> + 	struct page *page;
>> + 	const unsigned int idx =3D order - =
VMEMMAP_OPTIMIZATION_MIN_ORDER;
>=20
> Nit: constants read much nicer all the way at the top.

I can update to this next version.

>=20
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

>=20
> --=20
> Cheers,
>=20
> David



