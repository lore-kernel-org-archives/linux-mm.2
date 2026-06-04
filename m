Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAF73CD6E55
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60C06B0005; Wed,  3 Jun 2026 22:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11E86B0088; Wed,  3 Jun 2026 22:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D275D6B008A; Wed,  3 Jun 2026 22:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4FBF6B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:10:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 560A81C1E94
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:10:01 +0000 (UTC)
X-FDA: 84840599802.18.1E17608
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0EE8E180002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:09:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BVM+v5AS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780538999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYYlpuIZtVb2DJ6ddOz5+v3tiHxrY2b/L9P1iXO5xQw=;
	b=420zi7T/G0bgr6H/luthIb9NGEc58LlUSuGKHfj9CRsN1Ox1nc39VtGQ4PcKRyLLVwoXFw
	Nm/3L+SCNh/0TT24lZf5ddZ/xY0iTeFSRWNsgGS/WhEKclckXPen17vQCOr4lrWg6aKKWL
	rMzwql3VtjQR7ev4EKkug9NSsqlXwrQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BVM+v5AS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780538999;
	b=5sjA5G4WbON+vjNWl17s9z4L+0HcqZXi+ZeUVQQP+A45f3l0lkd91lkvK6NU1ExFnzKCAP
	wMdCn8+gMbDehkYYdeVOiYFROEgeaC8ZFzp+PfS7jO6dE4Mq1CuPQ0t8s6pGOYSA/e5OOW
	4OjiU5BLWgN40Di/qJcS8ibMmKwoYkY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780538996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SYYlpuIZtVb2DJ6ddOz5+v3tiHxrY2b/L9P1iXO5xQw=;
	b=BVM+v5ASLEaiZ4JQLzfJvFLqOPWTDAaGV3KSPFn4gTmSu1BmjE3O6M4yv4EtfiH47FXbD2
	cmbSuWpxrMaBHktf3GQUIFVP8zvy+XElWOSf4Sdq+OWHkKiqyLF/NSOOby8Y92bPZLZcGe
	WIdlju8y8/J0hbvxMAfo8q7jpk0gJzE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 03/19] powerpc/mm: Fix wrong addr_pfn tracking in
 compound vmemmap population
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <a4tbwv0s.ritesh.list@gmail.com>
Date: Thu, 4 Jun 2026 10:09:05 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org,
 Mike Kravetz <mike.kravetz@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4242FACE-1A30-4EE9-8679-A0B6284BB0B9@linux.dev>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-4-songmuchun@bytedance.com>
 <a4tbwv0s.ritesh.list@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0EE8E180002
X-Stat-Signature: k59d9581fkun3kh3bymspit4c48sfgij
X-Rspam-User: 
X-HE-Tag: 1780538998-568781
X-HE-Meta: U2FsdGVkX19wBIzHeJBmnVrNhTgqWTl9nvvF5DAWwchVuQpYlSOMzg0552q2JurXpqFXYsGip8AmLi6GmAJj119ybGn01HWYBBWWN/aF2nmfNC6ewY6r3rzJJy+VM2KT/W4BQ+I83zGhqf9y107ym3i+xObw5BVsCnEmre8MPEQ6t2cQgKkaiEv2zukfuj0DxpmeOEq6BtQ2OflXHt8PkZRkAtkngqHSTEaiKEDEBn9mP9T4dLVAIaNOw5PoEHjxWeNZlbEGndEJusco+bUIGPGCaDtLpd4yDbCUNjavqFnNRAd6ScOSiHfa2mGF183PNpJi6ixY4/R8+r5wURyfixbi7ZiHKp100L3XINJG6qNAGqhLJXmTtH0UU3uhdCGa/qenJx+dRGyyx5Hh4/9L8r3oQKEOc9pgBGPnagUgfnuFQG9AEkwN3oqnGj4VFAykNSYNMvk+tTrA+AQDQuPSShbUgfkXAcwnUmhNasid2u93l6KEsqr6DfgPz2XIGGmNOYfcovYPH9ZO8N6dWpflWQp4gigbq1ptyQ5Hmu2UO6x/nC0PM6YTOzH9tP6AG7RhVIw1Cfbj8hhb9s8e5cLwAOfxj+tlqk8Ln1HevRaqNOY4CElGZY3ll6lBz/vgo9Dz+oz0FZNPFWUZEaiGZ+CxOO32xVP2Qs3N9/Dg70U3Zck95HReLdt+JuOuvqBAW0qJiDWvRuQeup2lYYDi9dbD5rD5eAMnd5AdbRdl25hbDbevhByHNEuJw2iiUy1Y3TkTDlYh7FrD0zYulOTIWDvQwaopw30u9sVF0Dxa2HQhf+QHJqcC++StvhLwQotsRnXUW+rK4B9gHoH4pbHuaApKGbT9Bg31WtiwcWUOuVivhIpFsHFbGRXvrAvrPSbcNKhrcgMIMBE+noj8XeecOaNpOM+ACK+OLWAycnO3fhLe/9bss5UiJ7k2VVkpSNYrDQLMgXanBEUG5dN+TCTfc97
 X+PzR+pR
 Q+h5yH6+LUXmCgj3xEvNL5Z54DhQ+W/O0hlQlyNCO6LkfwjeoLi7k1S8Fyo0Faf6OqcwByJIGTEmZEsHIp8XiF2697lLh0/2pLbn5L0pmUcVclmE4fvTq1/72P36jMG4CGIXkuVEsNlXb4EVzngEAXTjvR7+m8u3eez/fybZOWSUlYJ7ZeO6qy4Moq8tFW/dl1oukgiTOjxiHVMlpSF//k1XrFs1DlBBmqG7JsND4EVzR8k9RuE6wtiJyhYljkOVxEZU99pFGN4wkTOTHvGdxY4zUbbn2OFDxyGf3+drjC7t4+7+4rAQrJspHIClQaErYuwikAXTzV2gFSTLVlrrXKP7wRQf8TQ1rlcaK2TcU5i3VjKMMm5WsPIoDnC6vxLHx0ZkZVE7Rel1IwIp2bizENiCDmOXdpvxkj70b/2KlXI2/khw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 3, 2026, at 22:36, Ritesh Harjani (IBM) <ritesh.list@gmail.com> =
wrote:
>=20
> Muchun Song <songmuchun@bytedance.com> writes:
>=20
>> vmemmap_populate_compound_pages() uses addr_pfn to determine the PFN
>> offset within a compound page and to decide whether the current
>> vmemmap slot should be populated as a head page mapping or should =
reuse
>> a tail page mapping.
>>=20
>> However, addr_pfn is advanced manually in parallel with addr.  The =
loop
>> itself progresses in vmemmap address space, so each PAGE_SIZE step in
>> addr covers PAGE_SIZE / sizeof(struct page) struct page slots.  Since
>> addr_pfn is compared against nr_pages in data-PFN units, it should
>> advance by the same number of PFNs.  The existing manual increments =
do
>> not match that and therefore do not reliably track the PFN
>> corresponding to the current addr.
>>=20
>> As a result, pfn_offset can be computed from the wrong PFN and the =
code
>> can make the head/tail decision for the wrong compound-page position.
>>=20
>> Fix this by deriving addr_pfn directly from the current vmemmap =
address
>> instead of carrying it as loop state.
>>=20
>> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap =
optimization for radix")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Oscar Salvador <osalvador@suse.de>
>=20
> Thanks for fixing it. I guess this was not caught because section size
> on powerpc is 16MB and with 64K pagesize we have 256 pfns to map. The
> vmemmap size required for this is 256*sizeof(struct page) =3D 16KB =
which
> is < 64K (pagesize). So basically we never loop in
> vmemmap_populate_compound_page(), because
> next =3D addr+PAGE_SIZE will be > end after the 1st iteration itself.
>=20
> But I agree this is a bug which needs fixing and it can be easily =
caught
> with 4K pagesize, where we have 4096 pfns to map within a 16MB =
section.
>=20
>=20
> The change looks good to me. Can we please add stable tag too?
> Cc: stable@kernel.org

Yes. I'll add it next version.

>=20
> Also, feel free to add:
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks.



