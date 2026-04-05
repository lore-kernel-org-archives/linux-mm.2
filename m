Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BACF55123
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 14:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55056B00B3; Sun,  5 Apr 2026 10:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05E96B00B5; Sun,  5 Apr 2026 10:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4AA6B00B7; Sun,  5 Apr 2026 10:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB1BF6B00B3
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 10:09:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 058FEC33CD
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 14:09:06 +0000 (UTC)
X-FDA: 84624683892.11.133BB78
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B4794000F
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 14:09:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ti/UUdIM";
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775398144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ru/lOWBi/C2PKEU6XsdVIKohFqyMme0d0YkWPc7ryWU=;
	b=Z+qArOHkw/D0WuzfqUq9xLXapEeUSfXRpZ0p7JWDf80cGPEbPSmzQiL/dmRtvpbtUzooGT
	G1454nUf1YLdoeb1bKoUd+nKp8Hh7LeWvOCbzDqz5krIfpTq9v1J/lY84AIHQC1nFa4Z5U
	WnfNDULcEWtfRS8V9pUjqVXyY430CRg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ti/UUdIM";
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775398144; a=rsa-sha256;
	cv=none;
	b=zq4X01x7+G9b6yfQnLWraem7K5Wu0wV0/BE0xkOqsdtjHScuhcCoMmbLhav0TKlH8DzGZ4
	PN6vMeyZAoKLkWaRm66aHtMtUSPE7iH+9KSiZtm4gsF/bGWSpZsMr2zBUk/sMOyxY5WfpZ
	Wp2LoiZBINFHZgiHVvh+HUKoHZiGT1A=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775398141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ru/lOWBi/C2PKEU6XsdVIKohFqyMme0d0YkWPc7ryWU=;
	b=ti/UUdIMVJ/L77ns1IFATic5sd67VGirPPwFVeh2ChB1vvU6+0LX549PWQjIUa0s5MSvUX
	4wfN/TOFjh7RnYlMHjYQtScz6lPIMXl5Jk+JzO/cVnEonVr2zW2A/EncPAYvx9shQCKk/E
	oZ9v3G4ckYdg0ZOQgCmk1b3ivUj+Q8Y=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 1/5] mm/sparse-vmemmap: provide generic
 vmemmap_set_pmd() and vmemmap_check_pmd()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <adIKIhRL6q2NIgnj@kernel.org>
Date: Sun, 5 Apr 2026 22:07:36 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D0D4B0DA-56F3-4ECD-8855-96C21A6DE1F0@linux.dev>
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
 <20260404122105.3989557-2-songmuchun@bytedance.com>
 <adIKIhRL6q2NIgnj@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1B4794000F
X-Stat-Signature: rig7ofgdpecxbfu4idqxctthqbqjdofy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775398143-538680
X-HE-Meta: U2FsdGVkX18nucRkdtt8uSN3NX8DrgZL1mtXzGj8+iQpbs2TRUCLxSLVQwU/b1eCu7o6h/jWxWGNOySd2rD2CZr2Te55n8TK/6+EyZRYgZ+w68WDbQGi/bn9y2dJjSRF3nJEyI7G0r3GYKEEFv4wta3zDEVuRWZDMGHujIMsMiwo+S6b9cd9xU0TgYrpVlMmuR1SUAoD2sMXkm2aT72DSc0DhoqBsj1JfcV5AAA9JmQs0Pasz347g4ti/NoHvyH5v9xmoeI8qeofD9niNuH00ZxwmmhJ+4TSgy7SazG+UklS8V8zMLVWM5kLWcC1bf17RObQ94/aOInPLyKHj2sGpax9zKV+umusfxA9N325EeqDpS268/b2ReuCNBdJcgkJU5A1/LFUHj63DZPotz7/SAw2fk215LFQNxPNrDIktl9CBdxpCnF9k+U/jJpwd2CdSmt7Wt84ccUNyIfAepSp0KDPxpKGByh932jQqOylj7CFogZkxMQfYpgs9FareiCHi2k1SnAM+q3l+UotO5LSgyOmfxiRakN0jmRXh3WOe4mwOwE8YbhOm48qrYaw/u9kQfFjwtkPWJT4wLlCJqyqWkZZZ+6deDy1y7s3CSZsazLodUW9/bJXAWItv2v/0e+tHSYkwoTlvjoZr0NLzLMZxWzuFFuBllotYCgnrM/6Xixa+r4TEOB+8TnSsyVqvXTbpesLGvP1gKVXpeSfefNzeYXTqpp6L8R2m2E8qKaFPziBY9Um06u3oRxVvpqmFsEw6GvjczsgbY/WGy3jmmnmvS/5ROawU5L4/o5svrCM8phNQZIVjOMgGJMZhkz92Wowd/1dtyKjr3a0mcK66Y3izDQCgUH4MlObPXhfUQ20fkqhje9tnQM41PIYV3MOfuE99MuGFksmJ05Ug2uZwySTGTPLNJQcDRlJbnW8ANg1Od9LyEFIUgM37T0mJLyyZdUd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 5, 2026, at 15:07, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi,
>=20
> On Sat, Apr 04, 2026 at 08:20:54PM +0800, Muchun Song wrote:
>> The two weak functions are currently no-ops on every architecture,
>> forcing each platform that needs them to duplicate the same handful
>> of lines.  Provide a generic implementation:
>>=20
>> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL =
protection.
>>=20
>> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
>>  then calls the existing vmemmap_verify() helper.
>>=20
>> Architectures that need special handling can continue to override the
>> weak symbols; everyone else gets the standard version for free.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/sparse-vmemmap.c | 7 ++++++-
>> 1 file changed, 6 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 6eadb9d116e4..1eb990610d50 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -391,12 +391,17 @@ int __meminit vmemmap_populate_hvo(unsigned =
long addr, unsigned long end,
>> void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>>       unsigned long addr, unsigned long next)
>> {
>> + 	BUG_ON(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));
>=20
> Do we have to crash the kernel here?
> Wouldn't be better to make vmemmap_set_pmd() return error and make
> vmemmap_populate_hugepages() fall back to base pages in case
> vmemmap_set_pmd() errored?

Hi Mike,

Thanks for the review. Let me explain my original thought process here.

My assumption was that pmd_set_huge() for the kernel virtual address =
space
should rarely, if ever, fail in this context. Furthermore, if we look at =
the
architectures this patch replaces (e.g., arm64 and riscv), they are =
either
ignoring the return value of pmd_set_huge() entirely or lacking any =
graceful
fallback mechanism anyway.

So, to keep the initial generic implementation as simple as possible, I =
used
BUG_ON() as a strict assertion.

Do you think we really need to introduce a more flexible, =
fallback-capable
solution at this stage? Based on the current architecture =
implementations, it
might not be strictly necessary right now. We could keep it simple and =
add the
error handling/fallback logic in the future if more architectures start =
using
this generic code and actually require error handling.

However, I am completely open to your suggestion. If you feel it's =
better to be
proactive and make the generic vmemmap_set_pmd() return an error code, =
allowing
vmemmap_populate_hugepages() to gracefully fall back to base pages right =
from
the start, I totally agree and will be happy to update it in v3.

Please let me know your thoughts.

Thanks,
Muchun

>=20
>> }
>>=20
>> int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
>>        unsigned long addr, unsigned long next)
>> {
>> - 	return 0;
>> + 	if (!pmd_leaf(pmdp_get(pmd)))
>> + 		return 0;
>> + 	vmemmap_verify((pte_t *)pmd, node, addr, next);
>> +
>> + 	return 1;
>> }
>>=20
>> int __meminit vmemmap_populate_hugepages(unsigned long start, =
unsigned long end,
>> --=20
>> 2.20.1
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



