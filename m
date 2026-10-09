Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA95ECA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70A06B008A; Fri,  9 Oct 2026 10:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21BA6B008C; Fri,  9 Oct 2026 10:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910936B0092; Fri,  9 Oct 2026 10:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7080B6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:15:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 029941603B7
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:15:10 +0000 (UTC)
X-FDA: 85303284822.28.37AEE1A
Received: from mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF54B40011
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:15:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j8NTeppk;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.38 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791555309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5cuFqIfMY4J2ULv+vaz8/5FjRBSv9rJHt5s66GC9Lo=;
	b=ZH4Ca6B2OXSHnbsOQiVqSyYqKilvyN0iGMsaRF77h623fWlWlLvORCCQ+VLHGSWU2ApU93
	7z/rqDBvavCdvH0fnhO9RlLEZm+TOy/KNdukkb2pABge6iaZN5Xu22zI2bsTuCItJzBV23
	8wlapPjUzrSCMX3X0DS1a35R1Kl5Wzg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791555309;
	b=XoSHpRZBEfvbYnhJB0y2DmrfnAUPro2p7sPzpLaepgeByzO5y5F0oNhUdsY7KGAlTcXNip
	ypBxpO4Q9zKUkSe77yOw/EfD+a6qo66bwGCcX1dnVRFBzIw8CMda1QP4vV4xoUfcuX7WrW
	oy7gCN6jhwP8vTu4PSOvryBN7r8nM6w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j8NTeppk;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.38 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=D7hfrm3qIlI4+AhECxlB2fjvQpfx6eid9hhS+USFrjU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791555306; v=1; x=1792160106;
 b=j8NTeppkVXGfC8IhWAZ+0uNt2krpxfFy33/z/lBbjk4Iovqn5lLkJ69MNhmRam47hpDvVo4r
 ClMmjS19pVnfiXmbSCvpyMaDhp/psc5s8psLKxXq8Urx6grXRx/HF0dW+KrncM1RNDSzcrVJ6c2
 Keq9+GOQmKeQeNLLEldjIsEM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d5fd037bf9b86533;
	Fri, 09 Oct 2026 14:15:05 +0000
X-Mizu-Trace-ID: d5fd037bf9b86533
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 2/4] riscv/mm: fix hotplug page-table destructor handling
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <87jynrs8v8.fsf@all.your.base.are.belong.to.us>
Date: Fri, 9 Oct 2026 22:14:40 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 david@kernel.org,
 osalvador@suse.de,
 dave.hansen@linux.intel.com,
 luto@kernel.org,
 peterz@infradead.org,
 tglx@kernel.org,
 mingo@redhat.com,
 bp@alien8.de,
 x86@kernel.org,
 hpa@zytor.com,
 catalin.marinas@arm.com,
 will@kernel.org,
 mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org,
 pjw@kernel.org,
 palmer@dabbelt.com,
 aou@eecs.berkeley.edu,
 alex@ghiti.fr,
 linux-riscv@lists.infradead.org,
 agordeev@linux.ibm.com,
 kevin.brodsky@arm.com,
 bjorn@rivosinc.com,
 apopple@nvidia.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0E3A4E15-38DA-400D-95F2-01FFBB36304B@linux.dev>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-3-songmuchun@bytedance.com>
 <87jynrs8v8.fsf@all.your.base.are.belong.to.us>
To: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF54B40011
X-Rspam-User: 
X-Stat-Signature: rrjz7ih4jzxrccm77fxsckknxrkciqfk
X-HE-Tag: 1791555308-48597
X-HE-Meta: U2FsdGVkX1+csMCmzOWSbmS7+KfepZ8mtRu2DfWsGJJPrunJxtASo5a0NxlPdiq5yuU7l1BJqJ3DO7zO2MDb6qB5gbpJFW2/Kq2wlAaHTGN41laPtpQr5sATJ9KmfY6fpv5tgtKMKxJkruEPhIt0XmufgmHVyXvuab/sjzkAOzcC5DUYWTAth6MG1ByuqMVChi8SnLqPDZ1BdawgkRhFvXeE6BWr+QoWjByp/laECg0jAgeffCop0zc0BGLn3mVJPKbB4/slAEmTJ3DzhGjqbwgJVqiD2laQtxcANx4qTWrSLuO3xwRL5GMIKrAWDBLZ2C3jj2OitWtYAOy3TpsiDu1wvebmz6A4shloQLg5CVqdkkwsLx//9+sdzcIrFwjOc4FK7nHYUi70miziOHUnuMxDgx40yfbuWysb2lTjRrcKjcuGQ3Oc9QvO6zizMDWUz5fVJpyNc26BuNUYpzpORrCTmhEEoA1uqZCoDpbAjXTjIPh9noENVd+Zv6/MgWDLES47RgW8ahmIoN3HYhZKWcmymJA45iWBK+fhNi2unDmAE9ec2xsSxBRbyKHkOfXWGO1Bc0SdEB9oIN/oshyLs6o/py+vVqxi5dAGuhL43qS3sVsZuPIBYdGxk9BQZP/CrtAzL9iAl9unklScIK9PiJQ7z3r3dt4egJwBSfifV5D4umBfgOElnCG3o/FwSzCxBVtEarHhBPo/3RVG5Gri+HTm4mGu8gYYyDhIDrHNVRMI7P1aC1s9VMBj1btr+GNmDjPXwsLvmqeSj78jwu0mCEHOnebxbGW5BtkJiWurXfGC9F1ZGFvFLZAV/5yxLG3QKbsXEELUltqEQtUreZ2zxa0E11FwRgqJ1UAqlCjo4R16ynFEnTlPsDA2gWopW9PE+XVOrzk9BIKDmXc0ruu4awYBmNeieKtmZTl2IhGDXqMzKNkjkj0JKk9r5pCMs0MBTM+Nw0/c53qmjhHWMAk
 3vcv1GMM
 rdnNdXXbOuw3Y8zLmiF30IbIOz2XNcQjJ+f4FivzexHeKZt8w9oAHKWSbuvqHi6VngjBjng35HR7mJGQxjSCgygJPKk6daKD1WExR3dIVDEvs1DyKJfas4Nvz7Qnj9ZBk1f8Rf8ixqmVep+AeksTMGniNPBXke8+DKz87PM6afYB6Z7OYIAxcarNXFKHdLzY/iMjdx3KCLeeS4yn7tQnuPT7MSc0BCZnoiLO2/lAMBiBG+kaFeQsU5JXf+GfNicd1TMhL+QYLc75/s2VXvpeUkP7Il5CENCGP4V9dCLjaHUxYX9Ic+MFhkB3QEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 9, 2026, at 14:09, Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> =
wrote:
>=20
> Muchun Song <songmuchun@bytedance.com> writes:
>=20
>> RISC-V uses the same memory-hotplug teardown code for the linear map =
and
>> vmemmap, although their page-table pages are not always allocated in =
the
>> same way. Late linear-map allocations run page-table constructors, =
while
>> vmemmap and early allocations may provide constructor-free pages.
>>=20
>> The PTE path unconditionally runs the destructor, which is wrong for
>> constructor-free vmemmap tables. The PMD path avoids that problem by
>> using is_vmemmap as a proxy for constructor state, but that =
assumption
>> will no longer hold once runtime vmemmap allocations use the normal
>> pgalloc helpers.
>>=20
>> Page-table constructors record their state in PG_table. Centralize
>> page-table freeing and use PageTable() to decide whether the =
destructor
>> is required. Keep reserved and constructor-free pages on their =
existing
>> freeing paths.
>>=20
>> Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> arch/riscv/mm/init.c | 29 ++++++++++++++---------------
>> 1 file changed, 14 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
>> index 857f9a55039c..429a0b015ec1 100644
>> --- a/arch/riscv/mm/init.c
>> +++ b/arch/riscv/mm/init.c
>> @@ -1486,10 +1486,19 @@ struct execmem_info __init =
*execmem_arch_setup(void)
>> #endif /* CONFIG_EXECMEM */
>>=20
>> #ifdef CONFIG_MEMORY_HOTPLUG
>> +static void __meminit free_pagetable(struct page *page)
>> +{
>> + 	if (PageReserved(page))
>> + 		free_reserved_page(page);
>> + 	else if (PageTable(page))
>> + 		pagetable_dtor_free(page_ptdesc(page));
>> + 	else
>> + 		pagetable_free(page_ptdesc(page));
>> +}
>=20
> Is PageReserved() enought to determine if there's no dtor to run? On

Yes.

> rv64 your code is correct, but maybe for robustness?
>=20
>  | if (PageTable(page))
>  |         pagetable_dtor(page_ptdesc(page));
>  |=20
>  | if (PageReserved(page))
>  |         free_reserved_page(page);
>  | else
>  |         pagetable_free(page_ptdesc(page));

his looks good to me as well. I'll change it in the next version. =
Thanks!

Muchun

>=20
>=20
> Bj=C3=B6rn


