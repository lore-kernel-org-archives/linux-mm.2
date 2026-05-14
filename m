Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCF1CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364D96B008A; Thu, 14 May 2026 04:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33CD96B0093; Thu, 14 May 2026 04:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E486B0095; Thu, 14 May 2026 04:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11ECC6B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:20:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B650402A0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:20:48 +0000 (UTC)
X-FDA: 84765329376.19.B1019CF
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id DFBCD80002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:20:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KDwxvaKg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eF9zsW7xnXvYZrz7iQ2MKx+MqvnRKTtP5O8YBI2NE3c=;
	b=envB3OglLwy+VICk/wxJFupfXPx+ELP/oPh2njVW1AvysOFK3/dZ9su/s6RT3wZanIbTsR
	i68rlhJ5BolVuzlJGdkLCHK9q/UF1nrsiQpuh+g73NXLaiu2dCI1+I/+mK6wQcYjKDUhBn
	mVbcn2fEB9Yd5Bvim8uZg0NAqieGXMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746847; a=rsa-sha256;
	cv=none;
	b=bBv7GwjBxA7yZ4RQiCk03bO642kWNcMmKi1So61hd6t6wKoebMtA1IKobv/Q5oXJ9rAu4S
	d5/mkjbb7m/KqxZ778He6p+XBEf5cnTpJJfh9X5dhGzHH6ST+Hzwrq5bJ8UFlsiWnQptAy
	5EFoNBI5iajJbxsHVetQagw2pPaKct0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KDwxvaKg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778746844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eF9zsW7xnXvYZrz7iQ2MKx+MqvnRKTtP5O8YBI2NE3c=;
	b=KDwxvaKgh9l7mgpFBVZ+HTHG5TDMhl79lW7K3ZfMryQ5xm+gJinvCPr43E41bc7FSO4UAU
	xg27y1DxfnLCU6Y5XwSgd/HiNCx2W+k3aOiQfCwlb22XLvPX1xKbHpaPTswYw7yqpDHi4i
	Qy7K2XvZmO+OLALVUA8mkSffbYKzz3c=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 02/69] mm/hugetlb_vmemmap: Fix
 __hugetlb_vmemmap_optimize_folios()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <agWANe6i5gsfXFgP@localhost.localdomain>
Date: Thu, 14 May 2026 16:19:58 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Frank van der Linden <fvdl@google.com>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <76D9FAE1-7830-495F-A98D-B3F5FC26F9CC@linux.dev>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-3-songmuchun@bytedance.com>
 <agWANe6i5gsfXFgP@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFBCD80002
X-Stat-Signature: 9fjqxpdjpgr13ogk5aahqerqdk4r1137
X-Rspam-User: 
X-HE-Tag: 1778746846-119549
X-HE-Meta: U2FsdGVkX18K7jtVZAdlUyADcxRA/rqRIzTRZgQnUCNTbnaDkPnV5i5x3oGhyoweVSRXfutOmOxzDdW/2Bhbc4yJhcGz02dVmelbY6iTXJT0X5/WChATPmJADj2gG6odafQm08+zKPcx07JVpkApRca/q3iuKFV1rBigepuS3WGR6VhZfI2hELbS39RakVowr38EaBJR958LgPW0+5zkAv+byzjthf+p2F5Jh7bAEX42GYjYKP5Y/Vj8y7rCotFatOwXjMf23T6JaEp6snQunALgI+qICZvYwomU5euwPZdTQaBdTDF1PPxpXJCKpcAGGD5xSAAMgTBU0N6xwkTDkESCVEtFb1+PBnHv6zXF7WM/nMSeRcyf/jl4K2FctWvY7Z427psGuftkl3k1iMgia+FNQBOP7XtYk8PdxWvAwA8Gv1Got46CVsKIs03CowOo4SJMU/w1gtoGwLsWEIOhnHFkWrfnLcJPqS2aOE5yi0mg5s8Do22IKPYCPBISAhd9npDYHI3tww81FW2faYeNTjcf2NkPssCUTfO1SkHQ9mOsNxCOoyWP02Q0nlucRYv0xeFoKc5oXLTWaL6Gt8aA73HtT6iW9pC5OjQo8n+abSEyXPvNF/Jya78wz2S2UHt1RpdZFBpcW8PukKc8PN0UX/Igsm9f8NyBAmHyPt6ViNQE08wimz1o9C5tzlqHUt0Cliv7SRjIpYwlvd3LZrBKVqhHTVo/OuRccYnPMl3fKDc0vWqMgYxIwfdTyVWYobxd9eMx21fkVLd9ZR3F5hnAR0BV1p49K9U/C/WLltnY6aI9phTUqejCmxZVo0PUm93sjKZa+/vDTOerpt8rsxaCnnECcix0TtUmwpq3VmM3punQDhZmLmQFSzS08snySp/kIGj1gF4VPmxzQWoi7BdCAJSGDGbvgdA1AvVmEu//bRY+dzs+zz368qEEc8kaz+mdRGf2kqahwzjx3skGPzo
 xwdP+NPR
 CiB1jNctZCDLCey+/mfjxtwEAaUmABuXkijdPBVqK9VewSny3zkkjsx5YGzbXNC7UKY3/WvLBaSHFWYfbfSCtZQNFKJeqa9U47FRrWlUIaik3KNCVCCOFYRQjIIrr+2/Zw22aN2M3YQrFEXI2X3F+A4IZdfB1cZrXfVVipgEHXLetqPQNgSJpsoRwHacqFqWUOK1I33pgjjVroO0UpeZ8J1B29PkjwlsH8h/TDaguufCJB5PTlT4VdxENkxC4MZCn1eoRU5wFekwHMvYFfFQejYyLDpMoilPp/RGvjzkRDNpG1/cEonfKTVLtGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 14, 2026, at 15:56, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Wed, May 13, 2026 at 09:04:30PM +0800, Muchun Song wrote:
>> __hugetlb_vmemmap_optimize_folios() uses incorrect arguments when =
handling
>> bootmem HugeTLB folios.
>>=20
>> The section number passed to register_page_bootmem_memmap() is =
derived from
>> the vmemmap virtual address of folio->page instead of the folio PFN, =
so the
>> bootmem memmap metadata can be registered against the wrong section. =
The
>> helper is also given HUGETLB_VMEMMAP_RESERVE_SIZE even though it =
expects a
>> page count, not a size in bytes. In addition, the write-protect range =
is
>> based on pages_per_huge_page(h), which does not cover the full =
HugeTLB
>> vmemmap area and can leave part of the shared tail vmemmap mapping =
writable.
>>=20
>> Fix the section lookup to use folio_pfn(folio), use
>> HUGETLB_VMEMMAP_RESERVE_PAGES when registering the reserved memmap =
pages, and
>> use hugetlb_vmemmap_size(h) for the write-protect range.
>>=20
>> Fixes: 752fe17af693 ("mm/hugetlb: add pre-HVO framework")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> Acked-by: Oscar Salvador <osalvador@suse.de>

Thanks.

>=20
> did you observe any Ooops or malfunctioning or was just code =
reviewing?

Found by LLM (Gemini Pro).

When I touched the code here, LLM will report the bug as well, even it =
is
not introduced by me :)

Thanks,
Muchun

>=20
>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs



