Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27766E66895
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619BB6B0095; Fri, 19 Dec 2025 16:38:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFB36B0096; Fri, 19 Dec 2025 16:38:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB796B0099; Fri, 19 Dec 2025 16:38:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3F36B0095
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:38:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8EE0C0369
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:38:08 +0000 (UTC)
X-FDA: 84237533856.02.4B9427B
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id DB3F4120011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:38:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aYtC+86Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766180287; a=rsa-sha256;
	cv=none;
	b=QBZKjFlKWNJ2HdNVCRKSHfx5b0ejOEgXr7rHAH1iPPMQPqAh45+f3B7ACHf3gr2iygRdru
	UqC0mAVvyhsQpSrgcviCnWLKNJKdZj8DGGm3HYfPZV7HP2h13jYdame+V9nrGz8HISWeQO
	F/ho3+Mquw0ye3xOtWZ60elkRIL4urY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aYtC+86Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766180287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qwBOZjXZNgWuokEpvkuCyDN4qULKX2eOsVZKGx+BRc=;
	b=Sp/lpSRnIgFPtOpvgVANZ7kKWtwGBcBEiHS3dtFbMESVAH7sczYaZ8oVf5LEpdqVnXAFqc
	3TmKHiJzaNTcRJkHNcZqPBUhWvBW+Q7TEpPgcVaZDVw5woiXfK2/YDFu0vnvG0lTEElUyr
	MJj8V6ySrcCFb+o8Xyj+elVezhxYDks=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42b3c5defb2so1257805f8f.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766180285; x=1766785085; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qwBOZjXZNgWuokEpvkuCyDN4qULKX2eOsVZKGx+BRc=;
        b=aYtC+86Yv2GBG2u4PrbRkijsyokz6iWx1GK9lniWRK90BDHnbVGiIrSrzuDfwdRdZP
         nv6c9t0ZP/hS0lzUl4jmxd4MkLjEwbUMOtklz8UokaxSHMjPQDByMSClLLnsBLTLNsch
         +z00nsjuzC5ub6zhW5BB6fSM9tchmLpPPeQ+vY99QYaeVCPedMS65G0hJxQ63df8YKAq
         ALEL8s4YfH0a5hDHLp3bXj42vxgRRvVePisarkZ+32bIsPCcYyLrAute9h3Y+Tt+5Wlp
         0wubDoXZq75QB3Fma3hpvvVwjWTLfe3g42mCVS4lAvuj/kxfvNRdEcig1EkrD+7tENoO
         yBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180285; x=1766785085;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7qwBOZjXZNgWuokEpvkuCyDN4qULKX2eOsVZKGx+BRc=;
        b=HWU7PcvXfwExspjUvKh2W9mR9OFZfyZetS5wrQEYe16koT/oWggwQX+CRM8J6BHm8j
         FRvPwcdVFzVnMiZL13R275iBw9S5H6F3HzIzTb7G2Xmz5fBuBD977TcF4SyKZ7s16ckq
         3RBzIMDvI6KN59qux8C2eLORd8EB/7EG1CinBu7dvOEY4ywp0D3GtBkPJ8SQLmMAvkJ1
         62v+7lISzjaPDm7SzTz2LmiksT2/svUEuV77G1VjiIuoMh6bUm8xeo/5mQxem/WGEAz9
         dvT/rtDVjMZcvAMoPqJYoQ7avMtPW+/F2S3/DkhZrSrNC+/Pn8cP6rTM3PiNbwECihyv
         e/Jg==
X-Forwarded-Encrypted: i=1; AJvYcCVl+KEwjww0SZeBYs7f8vwHpl3DJiK3l9e3B9qg7PIe11PBpyXFiDLgm80vMZ7Y7TNiy1cnsM3mpw==@kvack.org
X-Gm-Message-State: AOJu0YxN64vJk0MHFb8afTUelLfLy4FfHs2Ky7nyp6mC0hw9XjBZvhhq
	VEv/GjQNhD4jga15DSBgCqyAdiEfZXb/liOVeRjd4kSMI2M3nXwjcIDv
X-Gm-Gg: AY/fxX5V32acSsevOOZ2wsSMDJV5ObM06wSHeJxOlcHz9l8P7qLJsQybZHbxeqOiRZu
	VIF5fAEKHUHw8O6vfc1845o7HlkHjL8Pl5GECiV6EacuTmr/i0w/Ekh7Ow6UhnoWV4Ko8/nib7f
	fGhpSfw2330J7f4xYzPZgbz1bZz7CRi4Q5eoCclBO7D/Xm1iCVybIGb7d04+bwW1LJkuIl+98Gc
	V6DVTid9WpUn+58Zdec/6xcQzOLo7Z2dIM98AaMYfEgHAu4X5/0QpkChKu0i9PK+6OhMvCZe5yi
	9mbkgTl5dNNhvHm3Qt2lA2+d5nAthUprwTF/G0xqsbZX7gxICtDfg0Jv8euP+dVsgGDx8W3t3So
	fmZUJezrYTJmRhey2+9e8fI2QK5EcAvHe1Cfecb9Gl7t23yvsuJdHrA4v2AopuiSmAh+taHgkpW
	oDL6UzKbzUpef1B77TNZ9kdOY0J4YxT0s=
X-Google-Smtp-Source: AGHT+IGyru8SGJqlxv8zJOxc9PglQsmvyTXqM/wZEemUdJ3eOipdnMijVxzSqXLtGy838wDBtvYe1A==
X-Received: by 2002:a05:6000:178c:b0:431:918:501d with SMTP id ffacd0b85a97d-4324e702853mr4655672f8f.60.1766180285071;
        Fri, 19 Dec 2025 13:38:05 -0800 (PST)
Received: from smtpclient.apple ([212.59.64.34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1b1b1sm6922431f8f.3.2025.12.19.13.38.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Dec 2025 13:38:04 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v2 2/4] mm/hugetlb: fix two comments related to
 huge_pmd_unshare()
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <2bbe1e49-95ba-42ea-b6af-5eeb61d68c4c@kernel.org>
Date: Fri, 19 Dec 2025 23:37:50 +0200
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-arch@vger.kernel.org,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>,
 Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Liu Shixin <liushixin2@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3D7F0E85-2509-4925-BDD5-149E9E8D5C1F@gmail.com>
References: <20251212071019.471146-1-david@kernel.org>
 <20251212071019.471146-3-david@kernel.org> <aUTYE9fHf5Fq3eHa@hyeyoo>
 <506fef86-5c3b-490e-94f9-2eb6c9c47834@kernel.org> <aUU1DY4206FibsLf@hyeyoo>
 <2bbe1e49-95ba-42ea-b6af-5eeb61d68c4c@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DB3F4120011
X-Stat-Signature: zu3ecea49k5appec83a7uqow3hmw3d8s
X-HE-Tag: 1766180286-267593
X-HE-Meta: U2FsdGVkX1/SGzGvm13SoRJZqxWXp3A68eKHQYNw/SAzIzbYBdiNyyK/IqMbIitSrM6apgOIetNh/De1IP1qexG5+XeQ9t/7fwsAczNdz85iDf4j8gw4qNK1XTfPC1a7UXSHu3OcT9TcxfHLRO4yLuvgI+LuPf4fsiEIQI/EoTuw+vggQvRpUWPmcZ+vIAwwufo4RLqdBztiR6wJ+nZNIKiyqPwiW5TQTwb2TO5IMobV/6xyYJyIp7qTtfKLWkzr0vMotbYSZQMutCRQRydhO2kokUxoi6QYmMqpAr6XTxO0vWJ0Rns2DEpOupZEzOw5X5DqpMl0YM37juYfCNyOahoWf67WCfyrxe1dEdMPloHpROr0P9FD3xiEIOK4GtHfprZkycuJaPIzOxyeWcWTKBfnV63sgucdNALOsFyOHgRAx56/kq3tnRloUONgZ4UHJqDZZdgkGPJ63+mrrPSKuaWdrCYI7h4qeUtCRUrHr0GWl+Avb2MUaoCYoANfj7YteTV8Rqpv8ZG9NWqB75Lc+UqDega1HKAK+oRJ1C3zhft6xUVQ660eLTjLy5sfDlzW07hynNgYX2JdQd4g6+qm3cduDwsxQdQ/EBZ7OD1ZgAwjwPLz5rF1MaojH0AO2kyfvYfUIY0LPl1nZagmpZJZ0/oELXgn8ZujBxQXkZOWgxbSqnAwgmg1Wvk4INDV+tA2NRMbB4RgdXxZJ2CrvoU2UVvaZBIuW3CGQ1NKuerDTUMpdhWfJPra3xjaGMGZ52G+PSMob6CMqQVmSV9El31CERPq/mBcr+ue7Ykw9vXK5zcSfm8PAcpb/LY6q86NXOfRs4pBhJ0aMsBt5Ms348eAcI7WY3x7IGBQOFVnKfVy36mUeJvtxhFNMzIyoZmA5a8nSZ2KrtbGjzYGOxBF7ct5mbNDC3QUN6JwO4GFUHl+7ntEpTrxvCm3UxV8+nivJK/DC4g+AgRWnxXQ9dPJ1yD
 GbMFVhx+
 hG48RUmYgeKDKwmM5viG5hXkcwNgksQkqRBwixKYZUiTC5lXWmAqLeeEu+/U9zXSQ5kbAHOrIpxxjcQvqwHK0fVGHvWROQmTfx6uhCQ7hqeSkEunfJIJAQNXMx/sDnKE2nEwKt9pOhTCVjuwsveygBjlMwpwM9VM9+ra7R/DBMYmKdkZ31foD3nMc7I1yvZed8vyCPdvo7AdnkuktlsEIBAgZGzUuBhiEJ726ndQSBIrO4amI6Sa5h9FiQwj3ZNjvBZO/v3fbidtPZKYple2Ff8rxaMZHmNZ/4FJUFOniJQPYrucy90NvC9nQEasynV20MC9EGup2LW6H6wcjPq8mF2FWUHNxICQO5itsBd4j/ARNDI4JvOB82ohHrEvYZXYxYUq6jxb3wUIF87aH6xFqiHV++e6joIZfe0/68MBQLWCQlPlbSg3xEdkJndQrNoX2fgC5SZ2smrrswQ2YTHO+GC0SympARlUu/Z0SBUqmoWPg2NabFWVmISU6DmZ1SSNWQ+ZDKiGR9P/vfMaFu220viAKQnzY2n17Ug2vqdj0V54SN+mZKGC66Qt0P06LpfbTp8uuiQ9l5afzdMA9QfRDj/f4suofv7uoTjuh6xhCXp9iOOtxdwbEyxrWZH8aztdW2yTF0/pcyzQL67wjPnOF2P01vw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 19 Dec 2025, at 16:13, David Hildenbrand (Red Hat) =
<david@kernel.org> wrote:
>=20
> On 12/19/25 12:20, Harry Yoo wrote:
>> On Fri, Dec 19, 2025 at 07:11:00AM +0100, David Hildenbrand (Red Hat) =
wrote:
>>> On 12/19/25 05:44, Harry Yoo wrote:
>>>> On Fri, Dec 12, 2025 at 08:10:17AM +0100, David Hildenbrand (Red =
Hat) wrote:
>>>>> Ever since we stopped using the page count to detect shared PMD
>>>>> page tables, these comments are outdated.
>>>>>=20
>>>>> The only reason we have to flush the TLB early is because once we =
drop
>>>>> the i_mmap_rwsem, the previously shared page table could get freed =
(to
>>>>> then get reallocated and used for other purpose). So we really =
have to
>>>>> flush the TLB before that could happen.
>>>>>=20
>>>>> So let's simplify the comments a bit.
>>>>>=20
>>>>> The "If we unshared PMDs, the TLB flush was not recorded in =
mmu_gather."
>>>>> part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
>>>>> correctly after huge_pmd_unshare") was confusing: sure it is =
recorded
>>>>> in the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do
>>>>> anything. So let's drop that comment while at it as well.
>>>>>=20
>>>>> We'll centralize these comments in a single helper as we rework =
the code
>>>>> next.
>>>>>=20
>>>>> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table =
shared count")
>>>>> Reviewed-by: Rik van Riel <riel@surriel.com>
>>>>> Tested-by: Laurence Oberman <loberman@redhat.com>
>>>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> Acked-by: Oscar Salvador <osalvador@suse.de>
>>>>> Cc: Liu Shixin <liushixin2@huawei.com>
>>>>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>>> ---
>>>>=20
>>>> Looks good to me,
>>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>>=20
>>>> with a question below.
>>>=20
>>> Hi Harry,
>>>=20
>>> thanks for the review!
>> No problem!
>> I would love to review more, as long as my time & ability allows ;)
>>>>>   mm/hugetlb.c | 24 ++++++++----------------
>>>>>   1 file changed, 8 insertions(+), 16 deletions(-)
>>>>>=20
>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>> index 51273baec9e5d..3c77cdef12a32 100644
>>>>> --- a/mm/hugetlb.c
>>>>> +++ b/mm/hugetlb.c
>>>>> @@ -5304,17 +5304,10 @@ void __unmap_hugepage_range(struct =
mmu_gather *tlb, struct vm_area_struct *vma,
>>>>>    tlb_end_vma(tlb, vma);
>>>>>    /*
>>>>> -  * If we unshared PMDs, the TLB flush was not recorded in =
mmu_gather. We
>>>>> -  * could defer the flush until now, since by holding =
i_mmap_rwsem we
>>>>> -  * guaranteed that the last reference would not be dropped. But =
we must
>>>>> -  * do the flushing before we return, as otherwise i_mmap_rwsem =
will be
>>>>> -  * dropped and the last reference to the shared PMDs page might =
be
>>>>> -  * dropped as well.
>>>>> -  *
>>>>> -  * In theory we could defer the freeing of the PMD pages as =
well, but
>>>>> -  * huge_pmd_unshare() relies on the exact page_count for the PMD =
page to
>>>>> -  * detect sharing, so we cannot defer the release of the page =
either.
>>>>> -  * Instead, do flush now.
>>>>=20
>>>> Does this mean we can now try defer-freeing of these page tables,
>>>> and if so, would it be worth it?
>>>=20
>>> There is one very tricky thing:
>>>=20
>>> Whoever is the last owner of a (previously) shared page table must =
unmap any
>>> contained pages (adjust mapcount/ref, sync a/d bit, ...).
>> Right.
>>> So it's not just a matter of deferring the freeing, because these =
page tables
>>> will still contain content.
>> I was (and maybe still) bit confused while reading the old comment as
>> it implied (or maybe I just misread) that by deferring freeing of =
page tables
>> we don't have to flush TLB in __unmap_hugepage_range() and can flush =
later
>> instead.
>=20
> Yeah, I am also confused by the old comment. I think the idea there =
was to drop the reference only later and thereby deferred-free the page.

My bad. I looked again, and the comment indeed doesn=E2=80=99t make much =
sense. Thanks for fixing it.




