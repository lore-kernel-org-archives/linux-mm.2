Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC3CD358CF
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 07:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737406B0088; Thu, 29 Jan 2026 02:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5096B0089; Thu, 29 Jan 2026 02:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7326B008A; Thu, 29 Jan 2026 02:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5B76B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:04:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08D38D41FD
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:04:13 +0000 (UTC)
X-FDA: 84384112386.11.1B32DE8
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 48FE816000F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:04:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Iob+/9N6";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769670251; a=rsa-sha256;
	cv=none;
	b=Yjgiluz2+lS+xJO/5517N3426C2OQjiZDQP8A96N+TTZ0c4a7zLEpnUtctl8725g4YSUkI
	NMVA+7wutgrImexe6ad8Syizu2by82jzzniIAuw7M5mt9ZbDjGUx8YS4dN1pbVkL6spAUz
	BI3LHJ0joewXha9316sWsvnn0/V+f98=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Iob+/9N6";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769670251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vg92+QaCjCV3/Bar3U+6CnYR1oFAyAXYUL9A8jeWm8=;
	b=oBKuOQn8h+Osl4DGqUf90kGFmPl7FDYpxxd3IodOcYTNB3fAVDhSjMlzzwAtcZvPcrbc/v
	pWQFiCU/UaOXtWunSXfALpGcR2ypdnIJLlXzCBmG3+Fimw9vtXwQgyIRqq9XglHxq+P8aT
	HDQd6Rm+Sw404GgWgpqzpmKSzCLXZ9E=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769670247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vg92+QaCjCV3/Bar3U+6CnYR1oFAyAXYUL9A8jeWm8=;
	b=Iob+/9N6mglmQ5CwLaS9ocAUEvMwsKem7aRvOHuqJ5HnZvpj1vwXZDUrnsWiKKeNk39mkq
	UFbqDvLd2nu/cRKHcmggetWBLn3vX8rXwHqI8Rpjn1DgVQV7NLjb4HAmSLVSB61+LJXKgu
	aJVVdIpvm/M8OWL50qQK1YgMS9HnhjY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv5 09/17] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <5AFAE2FC-7274-4A23-AE92-797D5B69AA8B@nvidia.com>
Date: Thu, 29 Jan 2026 15:03:21 +0800
Cc: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Message-Id: <8CDE3AB8-EF51-4D53-A1D2-6084A7613E9A@linux.dev>
References: <20260128135500.22121-1-kas@kernel.org>
 <20260128135500.22121-10-kas@kernel.org>
 <B4674CF0-7534-462B-A761-D9124234BFE4@linux.dev>
 <3DA11168-5E37-4CE9-9934-CD1CAF3085D6@nvidia.com>
 <1A08D224-E1AC-4FE5-B1D0-1BAE2D5FF31E@linux.dev>
 <5AFAE2FC-7274-4A23-AE92-797D5B69AA8B@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 48FE816000F
X-Stat-Signature: fu7mdosqek8jpcuby71b3pdmugkrpbnp
X-HE-Tag: 1769670251-520475
X-HE-Meta: U2FsdGVkX1+1fMafHB3VLykR7bCU4D8VPQdc1F9BU16+9QqwNbTR0WAjCNlMdto7tL0xIIyAihDT5EjViKGvHuIIN/g+fevXl8NTCzB03rcEkVKEVntPRSs7bHCMD7+6k0fRpCJaEuGEdAZPkHeBTDYhvu56v5J4tToW6WqSoJYOC/JB5P37cUPOpHVhti3uRCLoizz+AOPzk6QW4bWTg8gM4Hpnc4vElRHZwUs22iiIlAuW9jPCZ/YM2a/ZTRA8SN84+FmM3H5WSFCDEQzGV52QTDAhf9dI9Rv3XFIHpam9ixIB6mYUS2FC7KL4GJQV6Q2y8kibHl4XSMHXlxkmofC+KY42+lFihOFAjfi+oF5I/g4jQueluuQchUx5rGeDwzmHxN82m4ESJtp4oArkJQf+qUilYLIEU8nd8QvIAteF8l81axsFzipluCb1ZgpI+Jh26lC4Wld4p9+00IIOj35NBlAaUiFfuM2ZYfznsxm/oAGSj1qQngxK6j7IzT50RqQUHF1WMq7ZlEZVDomgrwIrCjv1jIblmMxJj4X9Ub3Wq5TcmaoPCoFJAn8VoLdcsZnwY2Hj+fi2k8FdUgourVjepBUiCiDJ6Hx8JHMCSsciEWqhZs4tGeH6d8vwcQ409jKog4QtY8d74ssSGZNNOPC/6DZjXSBy9WcCp6k/VJ/yl+zd2oXJZWytSc4NvhIOCHuVYX0fu32Clet5AHoj+ui5l798IkHVkkK3gil7gyqi0ZGOg/yFOnLgjR1A/xO6oHEMvGCCbCzLcSbQzNw82kXmmSI0qyPuFJVi7nGFSK4YvE0Xnka+M67oSre4XSIQPPQ8nxVmgKpasQ17EUNIRUrfZjsMHV6Bx85eHWaFxkdc7SMqNWi0HbSBZcOyEg6YTjXOWMwGNuW7Y7KUXuiDVyLQZyXy92qmreObQCNRpPljYcnTyR29wKRmUokjbyNvgP/0OodFPQ4nAhov6FN
 YuaEErhi
 Fy/vZDJHODKDrpWdpzCQNyYexJf6xSm7532yz9KaPbqV5ABisAa1Y0cHKii8QuhiytWOvt7QwYG1whO5lhfxshmHe4DTA9qJzM80/pZ/v2vG1xHUZjBpagg8xiTXPKvnLJ7zeySa0l12bcGNJjF4Qy42upMZnuaxhnDYuyP96N0q2cgCJj1h9uRZFAL+Nt5ZPl9prawlY5vEqZ16YEg95uGDTt5zAP2UXVGy0FWB7s+Oai0Pjk1s4SL7TOZpXIkQpMresePdrMAPr8QMkLddM1YqVRrjJU2Sfq05hSaxiww6qWXaZYCRkN7dM3hlqRY+BBAn0SMvJgoLoGFw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 29, 2026, at 11:29, Zi Yan <ziy@nvidia.com> wrote:
>=20
> On 28 Jan 2026, at 22:23, Muchun Song wrote:
>=20
>>> On Jan 29, 2026, at 11:10, Zi Yan <ziy@nvidia.com> wrote:
>>>=20
>>> On 28 Jan 2026, at 22:00, Muchun Song wrote:
>>>=20
>>>>> On Jan 28, 2026, at 21:54, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>>>=20
>>>>> If page->compound_info encodes a mask, it is expected that vmemmap =
to be
>>>>> naturally aligned to the maximum folio size.
>>>>>=20
>>>>> Trigger a BUG() for CONFIG_DEBUG_VM=3Dy or WARN() otherwise.
>>>>>=20
>>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>>>> ---
>>>>> mm/sparse.c | 13 +++++++++++++
>>>>> 1 file changed, 13 insertions(+)
>>>>>=20
>>>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>>>> index b5b2b6f7041b..9c0f4015778c 100644
>>>>> --- a/mm/sparse.c
>>>>> +++ b/mm/sparse.c
>>>>> @@ -600,6 +600,19 @@ void __init sparse_init(void)
>>>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>>>>> memblocks_present();
>>>>>=20
>>>>> +  if (compound_info_has_mask()) {
>>>>> +   unsigned long alignment;
>>>>> +   bool aligned;
>>>>> +
>>>>> +   alignment =3D MAX_FOLIO_NR_PAGES * sizeof(struct page);
>>>>> +   aligned =3D IS_ALIGNED((unsigned long) pfn_to_page(0), =
alignment);
>>>>> +
>>>>> +   if (IS_ENABLED(CONFIG_DEBUG_VM))
>>>>> +   BUG_ON(!aligned);
>>>>> +   else
>>>>> +   WARN_ON(!aligned);
>>>>=20
>>>> Since you=E2=80=99ve fixed all the problematic architectures, I =
don=E2=80=99t believe
>>>> we=E2=80=99ll ever hit the WARN or BUG here anymore.
>>>>=20
>>>> I think we can now simplify the code further and just use =
VM_BUG_ON:
>>>> if any architecture changes in the future, the misalignment will be
>>>> caught during testing, so we won=E2=80=99t need to worry about it =
at run-time.
>>>>=20
>>>=20
>>> VM_WARN_ON should be sufficient, since bots should report warnings
>>> from any patch/change.
>>=20
>> I=E2=80=99m not sure a WARN will get developers=E2=80=99 attention, =
since the message
>> is unlikely to have any visible consequences and only fires on
>> allocations with a special order.
>=20
> If a developer misses the WARN and the patch gets into linux-mm or =
linux-next,
> kernel test robot runs selftests on the kernel and reports any =
warnings
> to the mailing list. Do we have any related test in selftests/mm? That =
should
> help us catch anything if a developer does not catch it.

I looked at the selftest and it doesn=E2=80=99t seem to have a test that
allocates at MAX_FOLIO_ORDER and checks that it works correctly.

>=20
> Best Regards,
> Yan, Zi



