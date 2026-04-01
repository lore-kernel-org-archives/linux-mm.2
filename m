Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA4410F931B
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 03:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9A56B0089; Tue, 31 Mar 2026 23:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192276B008A; Tue, 31 Mar 2026 23:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE976B0092; Tue, 31 Mar 2026 23:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFCD96B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:00:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85A901405E7
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:00:30 +0000 (UTC)
X-FDA: 84608483820.02.77E6B0E
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9E55340008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:00:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IlR4RNz5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775012428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaF0PbbHuT6q9CCC8Jn3YcYEjjRK4C/ES9CKlMh+1jI=;
	b=YIc0FPGU3HkhnvzrNf064WjYTvirwas8DRdo1dSaWZfo4uhlucmIyfmdemjCwfDWhDj0PG
	mTKNmVVINdpp9iGziFNNXfULIFUsp61pnbK+ntLZscWEoyg6CbvURnRfMw7tcK4jgdB9uA
	r9KZsgNUOIW9R4pkdr/oTn5uslXCMJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775012428; a=rsa-sha256;
	cv=none;
	b=FqYORWUtF9HI6F+uSaxP+MOFIon3sLUzRPwokNBPp+WZP98C7fLut4ekdDSFzL+lbc4mCv
	iqlzL72o590YVcb74RqavtvJMmeAkSVMeNFhR5EeyvmVdrztgKOEC1FgrUCacLIaqPkmzD
	NqwIpcF9vBkUpPJ4XYngk+6avwO85e8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IlR4RNz5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775012426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZaF0PbbHuT6q9CCC8Jn3YcYEjjRK4C/ES9CKlMh+1jI=;
	b=IlR4RNz5fTK0AjVMPjhRn7IWz9zSQRR0v9ge8WsB7ihcLTL0PKgUdNjREQYnCBqGU116F2
	xQIk98cQbp/RiRy+uwZkY1nbecEdNxKLVyX4O2MViTsSBiCWIB5K55Ai234gH8rr3Bn0JF
	HC+APMu7+aYTJv6xbPhGEZ+qUSbsT5g=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
Date: Wed, 1 Apr 2026 10:59:46 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <76E85D67-FE97-4D36-80F8-BB0B3DCF70A6@linux.dev>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
 <7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9E55340008
X-Stat-Signature: aijtsf394eupd5had3uh9x7qudihykp1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775012428-133925
X-HE-Meta: U2FsdGVkX1/BBAL+2JnQxEquY6YJDFlrBK5qik8rW+kVvFYenJjiTdPjIsvAqOtfQPb2tBE6dG6OEVS/ILlCoJww8SDKuiD3N7096fIOB7L9keFaIuF1ydanTZ+5WOqDqYnfh2DECjmq3zjq5KRJKVWAjpGau3WXxnvWQlVqzi/8uIx8uBAGoQ9Cx7hqqyFJ9Y+PiKk+ieBsBGddqV6nBxDAtmZW5Yzi+oyBLjDfPlW+24V3kucN+k4z1KY/B8aogD29yjuigghEhPepEHt9dLX4/5CMxq+ZNIRqTvQr+fyXjKN4Ikve7zxpLJP9Ky/ll3Uy5QQSgbfHg6WM3VeO6l540JRW8CGYSchoJ8GwQify9ErRuj1imI4WRPF5KXG08kWHev2PI/tHfycaD9kbIJbu8dJQhFm1S5KgNn1gwot9gV3BbV5x455b4eSVisaoEtLRqZ6vx1JJ2UhSRweckoKW7QZlYxB6Ruf9nmwYKIeKldMxxeJ8sEfH22yJsOTLiNzogqImPjv8yPsiMDAp7pTn/r7P8dwlVbnzdh3w1xWoGPYflKBWF7TGRrfj7y1lU/ek/uQdZIRrm0fFp3bHrGK0v8LFreVhgX3bM0IWEf/72Jak7mkrmDg+nhMmn2nwHDBFycfFKtZcwn8bmxty3VF5wBD6WSJzoQIqzOs81fLI86mWCq9sNJI6omNCGQmkDS9oEb113H3yrFLbveUOSPP9nQ/N6Gcf+5HxRrWGHITrXWSVf5YtId6vuBTl7GO3GKp+6pnwM/W7VovPhM0WyohDRfjjiBWPuRdFtSG/tP4jYKvwpvlNNsiq0cSBGKzf16/bOqrjDVbojyfDf4QHiYbTFC6wbl6gZUUfVZY3+Ul0iCfNoHG8M1O1USX4kJB1vXsWvMbkAdyA3SWYr+MYtCxF/MimSN7L3Ab36AEFubltCZVkyWaHXAsesFpssBIQaMW+UHxoe7N9slt8sAe
 YqAgXxcS
 Ml2N+JMlhWaFYPhzzPMzkWd4I0a7EDqU6T2sOOZ93cNDpH/dT1MRI2gPftri+AShzVvjMQc32rw1dv35IKfJFU2bxkNntqxFMG44em5wSGFp3+j0twzMsnyBKmbF/RyXx8KC76Z1EcZU0XGjW3sSXjBwFsn2niGkza/h9jWArADgS/0tT85Fplr0C8DAKWXazRGNp+zr9rPRNtNOhClg9M2SBbGlHtpEmUg3ngaPsAqm4EHN7HsESM1AZex8eH1AzdTiHb9LPxGY5kx6LtuOfomf9sRpChVu65tPTocOzN7XEz4D/7XTkU/a1Q8Nko/XSg3XQhjd7dKK/ifQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 10:57, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On Apr 1, 2026, at 04:29, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>>=20
>> On 3/31/26 13:30, Muchun Song wrote:
>>> The comment in mmzone.h states that the alignment requirement
>>> is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
>>> pointer arithmetic (mem_map - section_nr_to_pfn()) results in
>>> a byte offset scaled by sizeof(struct page). Thus, the actual
>>> alignment provided by the second term is PFN_SECTION_SHIFT +
>>> __ffs(sizeof(struct page)).
>>>=20
>>> Update the compile-time check and the mmzone.h comment to
>>> accurately reflect this mathematically guaranteed alignment by
>>> taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
>>> __ffs(sizeof(struct page)). This avoids the issue of the check
>>> being overly restrictive on architectures like powerpc where
>>> PFN_SECTION_SHIFT alone is very small (e.g., 6).
>>>=20
>>> Also, remove the exhaustive per-architecture bit-width list from the
>>> comment; such details risk falling out of date over time and may
>>> inadvertently be left un-updated, while the existing BUILD_BUG_ON
>>> provides sufficient compile-time verification of the constraint.
>>>=20
>>> No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
>>> the smaller limit on all existing architectures.
>>>=20
>>> Fixes: def9b71ee651 ("include/linux/mmzone.h: fix explanation of =
lower bits in the SPARSEMEM mem_map pointer")
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>> include/linux/mmzone.h | 24 +++++++++---------------
>>> mm/sparse.c            |  3 ++-
>>> 2 files changed, 11 insertions(+), 16 deletions(-)
>>>=20
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 7bd0134c241c..584fa598ad75 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -2073,21 +2073,15 @@ static inline struct mem_section =
*__nr_to_section(unsigned long nr)
>>> extern size_t mem_section_usage_size(void);
>>>=20
>>> /*
>>> - * We use the lower bits of the mem_map pointer to store
>>> - * a little bit of information.  The pointer is calculated
>>> - * as mem_map - section_nr_to_pfn(pnum).  The result is
>>> - * aligned to the minimum alignment of the two values:
>>> - *   1. All mem_map arrays are page-aligned.
>>> - *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
>>> - *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
>>> - *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
>>> - *      worst combination is powerpc with 256k pages,
>>> - *      which results in PFN_SECTION_SHIFT equal 6.
>>> - * To sum it up, at least 6 bits are available on all =
architectures.
>>> - * However, we can exceed 6 bits on some other architectures except
>>> - * powerpc (e.g. 15 bits are available on x86_64, 13 bits are =
available
>>> - * with the worst case of 64K pages on arm64) if we make sure the
>>> - * exceeded bit is not applicable to powerpc.
>>> + * We use the lower bits of the mem_map pointer to store a little =
bit of
>>> + * information. The pointer is calculated as mem_map - =
section_nr_to_pfn().
>>> + * The result is aligned to the minimum alignment of the two =
values:
>>> + *
>>> + * 1. All mem_map arrays are page-aligned.
>>> + * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest =
bits. Because
>>> + *    it is subtracted from a struct page pointer, the offset is =
scaled by
>>> + *    sizeof(struct page). This provides an alignment of =
PFN_SECTION_SHIFT +
>>> + *    __ffs(sizeof(struct page)).
>>> */
>>> enum {
>>> SECTION_MARKED_PRESENT_BIT,
>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>> index dfabe554adf8..c2eb36bfb86d 100644
>>> --- a/mm/sparse.c
>>> +++ b/mm/sparse.c
>>> @@ -269,7 +269,8 @@ static unsigned long =
sparse_encode_mem_map(struct page *mem_map, unsigned long p
>>> {
>>> unsigned long coded_mem_map =3D
>>> (unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
>>> -  BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
>>> +  BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + =
__ffs(sizeof(struct page)),
>>> +  PAGE_SHIFT));
>>=20
>> If that would trigger, wouldn't the memmap of a memory section be
>> smaller than a single page?
>=20
> I don't think a memory section can be smaller than a page, because
> PFN_SECTION_SHIFT is defined as follows:
>=20
> #define PFN_SECTION_SHIFT (SECTION_SIZE_BITS - PAGE_SHIFT)
>=20
> Therefore, PFN_SECTION_SHIFT must be greater than PAGE_SHIFT. On =
powerpc,

Sorry, I want to say memory section must be greater than page.

> PFN_SECTION_SHIFT is 6, PAGE_SHIFT is 18 (the worst combination).
>=20
> Sorry, but I didn't understand what your concern is. Could you =
elaborate
> a bit more?
>=20
>>=20
>> Is this really something we should be concerned about? :)
>>=20
>=20
> When we continuously increase SECTION_MAP_LAST_BIT, it may trigger =
issues,
> because I expect to catch problems as early as possible at compile =
time. That
> was the motivation behind my change.
>=20
> Thanks.
>=20
>> --=20
>> Cheers,
>>=20
>> David



