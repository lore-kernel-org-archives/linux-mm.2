Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF15ACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 06:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47A16B0005; Tue, 19 May 2026 02:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF85E6B0088; Tue, 19 May 2026 02:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E306B008C; Tue, 19 May 2026 02:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90D4C6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:16:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EBD41201AB
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:16:30 +0000 (UTC)
X-FDA: 84783160140.05.1616108
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 15A3E8000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:16:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JNdTU86E;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779171388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0Ldfqr2ngs4tUVmrZGR8IuA8f+j0qWTUw7Wa6Derco=;
	b=piwuXpIKNfqBGQisrx7/ZwUBTDMWmyGfOkckY6rqlsm6TKntCLuxWpaiuUYZPeUbbiVkbG
	q5J+sL4imXgREkJNfG28t+iMEql7b2cBNdzXKVYRZqV19wCZO7Cj9hev1XIhaHQ2wBQvE+
	WFtQbHbaf7ihIAJxC1XvI1SbY4KVK0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779171388; a=rsa-sha256;
	cv=none;
	b=xsmhyapVI9zRl1VNJSG23GuWuv/5UC1rZHH4tczOJQkcFP97weTZdWJhiBYCPPyCksAsSM
	SA2M3IDtYA4FRC5+03ERcjHxCaf1Z20IrHIxhgpyLutA0gJQQbRVYldjjvTsjTRS4J7Mi6
	fbxnOodkpUYjVh1uCTy/oGGnQ9IPsmc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JNdTU86E;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779171385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B0Ldfqr2ngs4tUVmrZGR8IuA8f+j0qWTUw7Wa6Derco=;
	b=JNdTU86E7+9dgnEn/PyWB0Xi+hyY1F6UY7TXyMSJfQLBsJ5pgSSpGBUQt+sRbSeRDxbN0g
	YOmNImEkcvjwgHrhmUbS7A3//04gNtd84ukEHxFJLWq3/3HR0azT407rB2InuAWofz5Vie
	Ap+q313Af6Hx0+KVWHon9fPAtTjoykw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 2/5] arm64/mm: drop vmemmap_pmd helpers and use generic
 code
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <agsHINLR-D-tRiGd@willie-the-truck>
Date: Tue, 19 May 2026 14:15:32 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-mm@kvack.org,
 akpm@linux-foundation.org,
 Ryan Roberts <ryan.roberts@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <93852370-3D0E-4C0F-8F63-B3EF57977E59@linux.dev>
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
 <20260404122105.3989557-3-songmuchun@bytedance.com>
 <agsHINLR-D-tRiGd@willie-the-truck>
To: Will Deacon <will@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 15A3E8000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 5mjadorpsprg6p7apaqu9fsxpz6kt9ni
X-HE-Tag: 1779171387-339748
X-HE-Meta: U2FsdGVkX18nMIAZekJHBuduY9SycOeR2AEYRz/91e/sIrUVm9fRwAwo7VAL7YZaZnZnT3nq1wM+OwYmCD5nSZNhcri3oyZCi6m47UAe5VUjtSgvAbyTMXBSfp9HnmbiluiBtaxfTDMM+mZCCHFLYSVZ/euBTRyopPNaCHd4VAF89uTJD0+Iofa957a350EwOHx04wIg21/204Q1+BbKYdEo6RZOyTZfLTD0BRuJEnwpHSrbL/rKw2iaY7BUsdi8fj9/UN0bL5xpO3YvLhKUyHxD6y8aam9lEPr2lC0xrSNzrtjYJOm9cPHrMgdzsWDBun4+VzYBYcI/LI3cmOxQ8/eD/PswxFIcfLzoPIv4N4m3XW+rARZHBeHX+jv5zS1t8r7SNLoFmyK8g+NyvwvdEu5tk/QyKL2FMP0SWqLG23iJy4iAGphBTmXRVzaHP+UTjnCYbmgbgJVID48Kq8AsOwe2HgUc6t0KjIYJF8uSIH3xi5SD29GzUvaWHIN5l57wVvoT+FJUbu1sHnAGqCeAD5IvGMTL+c9lsSTk2uHk3dQ8xz3ZGzrXvtctwGM6zMLJWUejOMzw8vJ1DuysO1tVC0pnAH88a2MkMpYPpPZVfSaMtR23NqQgCREtAUq6BB40zmWkSeuyZUE5j7oru/Jnm2k28f4Cp3goAf210uFkDZQUsE5oaH4h5LX0M4fhcMn5EOHC3xCQKDFRWb6xR0rhdIWcLzs0AEKXNjyvRUXeAhHwHEI7Hmhm+alBs04v11+dxpHycnqi/dPI0Rfqtdn0PStogXYbHwkCaGygLgxuuUT9BxqZAlYyRSia28JlkKQEOE04jpkgqnXhedkooa3euVfqnqDx9Sd2J8o1NQ0L4c4kmGh1YjA++Cqe7CbvsnZQpk1WgzFVOQjAjf8x+Z1bXGrJyqUZICK8hfYkE8Vz2l9ku9ENbagfl++7tsO0jVEDLfK4RSRFEdk+dLAYtOj
 kPHht0WP
 r8XDjEvjsR//CdUV97B2VFb+IFQqTv3E8lhhN/jXdw6/N1RdZZ0nF/8hH7criaLxpSuapIA/TXjkKhTHmrJWDkhET/W2OOg6XB0HNoiJYW5el71EA+EjNU/jOAY1otX4UR+K0qRpP6sNcvoHKNXgQPINIDvT5KoESrMjzRoogvP2m9t3F4Y48fnd/StdJ0xOeWl04VGRnIjEBXZ7jcigduC/9MT73ye5OUUpyMPu5UQD69ewLDu+2JVB4Pm6uP+tPry8N6CJPzCAeCL3ZWzl2tbkoNumxgBUAkUHi2II0u4OesiFPRei8JxOU5XgzTqc4SIMEIkWDMNqCjVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 18, 2026, at 20:33, Will Deacon <will@kernel.org> wrote:
>=20
> On Sat, Apr 04, 2026 at 08:20:55PM +0800, Muchun Song wrote:
>> The generic implementations now suffice; remove the arm64 copies.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> arch/arm64/mm/mmu.c | 14 --------------
>> 1 file changed, 14 deletions(-)
>>=20
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index ec1c6971a561..b87053452641 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -1745,20 +1745,6 @@ static void free_empty_tables(unsigned long =
addr, unsigned long end,
>> }
>> #endif
>>=20
>> -void __meminit vmemmap_set_pmd(pmd_t *pmdp, void *p, int node,
>> -       unsigned long addr, unsigned long next)
>> -{
>> - 	pmd_set_huge(pmdp, __pa(p), __pgprot(PROT_SECT_NORMAL));
>> -}
>> -
>> -int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>> - unsigned long addr, unsigned long next)
>> -{
>> - 	vmemmap_verify((pte_t *)pmdp, node, addr, next);
>> -
>> - 	return pmd_sect(READ_ONCE(*pmdp));
>> -}
>=20
> I think this is fine:
>=20
> Acked-by: Will Deacon <will@kernel.org>

Thanks.

>=20
> but note that, since c25c4aa3f79a ("arm64: mm: Add PTE_DIRTY back to
> PAGE_KERNEL* to fix kexec/hibernation"), I think that using =
PAGE_KERNEL
> (like the generic code does in the first patch of this series) means
> that this change isn't a no-op -- it means that the huge entries will
> now be marked as dirty. That's possibly a bug fix (?)

I think you are right. We should mark kernel mapping as dirty.

Thanks,
Muchun

>=20
> Will


