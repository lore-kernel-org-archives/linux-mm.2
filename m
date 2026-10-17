Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B40ECCCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 04:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF446B0088; Sat, 17 Oct 2026 00:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978BA6B008A; Sat, 17 Oct 2026 00:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866D76B008C; Sat, 17 Oct 2026 00:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53A7E6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:42:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF58A160231
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:42:24 +0000 (UTC)
X-FDA: 85330871808.04.6A7291A
Received: from mta0.migadu.com (out-103.mta0.migadu.com [91.218.175.103])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66746C0003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:42:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KATrE0wE;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792212142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZq6Wme4vJw+YvTgF6m2fAwbs2JqLEqIv1I3XZ7DRuQ=;
	b=oodwP3LX4oajAOGM92e8TGPaSH1LMcl1d3gqxsO/9KTtoFjZkzAPedtGlygA8AEgt7Gagc
	O2RsjRqAmTjS/LrLg4Ojjml7yCuLm5/nHbS6XZoNl1KeJ4tKouUgJJXF0NMh6Ob6u2cwrA
	HR77svEC/f4/Q16veMEIJOQuRVrNs2w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KATrE0wE;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792212142;
	b=6jtn4cbcq1Ph0Q0sPamfn50+QNfNkDrCLonN3ZXwwi+07KCVa9D6mmfmRwfQWLr9k5aevs
	Z9UXdWvSY9yLrUYz3MrM7KAI1hIHNbtyJLXZDDCiJ3exlC+9DaXqoxL2FJ+sIgeexL77Ym
	KH9b5++Z8yFzhkbK06Xrjol9VnVG4V8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hbPfAQGWEfQs7pTwzSdEMJk1CnPG93z6WBrj/B9idLI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792212140; v=1; x=1792816940;
 b=KATrE0wEM2N8ldFcmMsozFuZu/nBwHUg+oumzN8EZ3ft78WZxV26J6NoVOVq/CsgNLCFCQKi
 e/DUSADC46mRhcuYcfIdRQNkF30uohI2CGZ++tOhh0ymaPq+UhXjo30o7zuV2t419I2Li3PUNk5
 GFyn243ODh/YDDaJQQ2JvSJY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 0ece839246d54cac;
	Sat, 17 Oct 2026 04:42:20 +0000
X-Mizu-Trace-ID: 0ece839246d54cac
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] kasan: fix runtime shadow page table synchronization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CAPAsAGyDqG0_JPB3c-4bY9jwdQ7eTxGJT0Ce-NowKiJ44T3LsA@mail.gmail.com>
Date: Sat, 17 Oct 2026 12:42:02 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Dan Williams <djbw@kernel.org>,
 linux-mm@kvack.org,
 kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <81DDAE34-7514-4C63-97A6-47DF441BFCBE@linux.dev>
References: <20261010133751.46807-1-songmuchun@bytedance.com>
 <CAPAsAGyDqG0_JPB3c-4bY9jwdQ7eTxGJT0Ce-NowKiJ44T3LsA@mail.gmail.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: staoaypf6b176aiu4skyg4gsxkzszmea
X-Rspamd-Queue-Id: 66746C0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792212142-630547
X-HE-Meta: U2FsdGVkX19ZLwlnL8ygrkSVyMq6jm0L8q0pPqIgMbEVxYnRb/bDUJhn6oJL6ozj14UEvWEQ4lUqP/4rjrMTgVyPxjXcIF/d8PlTXl/jC2ZWuLzqOTmLQSUXNbp4DCQIQxH6n/ZYMUApvH3689EDvT1kkNJvdm1rniE8Ptcsm+emNvh8XdMe6lG8bNxrJNs9sKhPdEvLfveROgUzeO17M+m3nEDLqzH1Sxn9jWz8UTf6affU82lhyeYIZa76WiHO4r6Ik9P7HfjTgak/xhj33HoRuXNrTuadGhBf3dngQV3NL0fCEhPODgK8CmETYB0IeL0Eyq9QuRcjJ4fSOp+334NxGHkBWXNcWwzdmePiU2NOqq4l1B54yvzzc/L5k4WNZ1CvHMoaIQ8RGsBnHOfpWwUveYZiY576z9GNJnXmcbv/9CUlEqon0EKI0ytsKQh1e4EoZNOIlfGPGO1JrRUtIIcCMkII7V6kU7nHcu8O0LqV+hEh6jHsna4eF8nEfofHmOMHrcvlf34hbTSKPGtJZf7lOLyQ/NO7QuCHP3Lm7RF6CR+Asq9a+m3wFFgq4OPgUd/vZHbNFsIuD+m5/EU4piOEw7kULMr8HMZL3HlXvMZs+Ot8WYoOQ9oIII3XL9jtGBbZEC7kAH3YzlWLKQtHNDg2hWTf6Pvt1tbTecneB4dbuQX9ayHJ2obZJJTFuZ4xLoxpnilnM992SyVKMV6x38+UREYfToQYoE9bpVLMRdw9+XBNtO9zPVBVE+n1oEntrNRkq+tW6NWmAytIt+LvA57GRniVHm085uLij32TxPwMYLtKsK0Cj9A/+J0sfLjwjdFkmD4A3oUX6ntRzoH+giwiWccoHRx0K00UqySocin0NiRdvjnhILVX+pNGgg2CV8zvI1VOevZJh7We4e16VOCKTwrZ/ru2rx3OJH1LzXgn3TjJSkulHE2e40fmDkVzsZtPhQPNyw3bRwsPFYU
 25Y/ogu2
 bRSvg5N/FxJLV7GpZujIH7EFMLK3NUmw8LQN5r+Fy+n9KxCD1WT0RNfrwwWJzAJ6/VovVYbKRujd29IoV1oBwnAJZ03zwuAMpKVKnaRnjgN2dIbtUMfrSdvRcQ5RtpxeYny4TVAV607+NoKRURWlvlAL7D33++RHv1FIROCvP7itTUC1gjNMFRKnIXDk9YUsvbtizfGEuf9gi+3SDPuJrOtbBNUxiOvSnE7Z64iEoDrT0Q60XKKKZoAzGd++yH57xaDi7SWTEhKITSDyegEoLQIEEitgMzarKkcKEHMQtj0iRBG4D81Fmgh/e+djHdcOEEDbD5GIcZptiRVuEdjPbbNLXY4HfZQWejbGo3at69RRsUNEeTQJk9MTY7P0vVS0S+VIa9tlBTi2Fw1SG0yOBy5iHq/yy5SpEq5Io
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 22:42, Andrey Ryabinin <ryabinin.a.a@gmail.com> =
wrote:
>=20
> Muchun Song <songmuchun@bytedance.com> writes:
>=20
>> kasan_populate_early_shadow() is also used after slab becomes =
available
>> to install shadow mappings for hot-added memory. When this path
>> allocates a new P4D or PUD table, p4d_alloc() and pud_alloc() publish =
it
>> only in init_mm.
>>=20
>> On x86-64, runtime kernel mappings that add a top-level entry must =
call
>> arch_sync_kernel_mappings() so existing process page tables can see =
it.
>> Without this synchronization, the KASAN shadow mapping can remain
>> unreachable and fault when the hot-added memory is accessed.
>>=20
>=20
> Did you actually hit this crash or it's just LLM's/code inspection =
finding?

Just code inspection finding.

Because my recent work is converting the vmemmap population path to use =
the
generic pxd_alloc() for page table allocation. I ran into a similar =
problem,
so I wanted to refer to how KASAN solved it, and then I found the bug.

>=20
>> Add p4d_alloc_kernel() and pud_alloc_kernel() to perform the required
>> synchronization, and use them for runtime KASAN shadow population.
>>=20
>> Once copied, a top-level entry remains in other process page tables.
>> Clearing only init_mm and freeing its target table during teardown =
would
>> leave stale pointers behind. Retain these shared levels instead. On =
x86,
>> this keeps PUD tables with four-level paging and P4D tables with
>> five-level paging, while lower-level tables can still be freed.
>>=20
>> Fixes: 0207df4fa1a8 ("kernel/memremap, kasan: make ZONE_DEVICE with =
work with KASAN")
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> include/linux/mm.h | 24 ++++++++++++++++++++++++
>> mm/kasan/init.c    | 10 ++++++++--
>> 2 files changed, 32 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 5cca90fc1df6..5453d3e42780 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3855,6 +3855,18 @@ static inline p4d_t *p4d_alloc(struct =
mm_struct *mm, pgd_t *pgd,
>> 		NULL : p4d_offset(pgd, address);
>> }
>>=20
>> +static inline p4d_t *p4d_alloc_kernel(pgd_t *pgd, unsigned long =
address)
>> +{
>> + 	if (unlikely(pgd_none(*pgd))) {
>> + 		if (__p4d_alloc(&init_mm, pgd, address))
>> + 			return NULL;
>> + 		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
>> + 			arch_sync_kernel_mappings(address, address);
>> + 	}
>> +
>> + 	return p4d_offset(pgd, address);
>> +}
>> +
>> static inline pud_t *pud_alloc(struct mm_struct *mm, p4d_t *p4d,
>> 		unsigned long address)
>> {
>> @@ -3862,6 +3874,18 @@ static inline pud_t *pud_alloc(struct =
mm_struct *mm, p4d_t *p4d,
>> 		NULL : pud_offset(p4d, address);
>> }
>>=20
>> +static inline pud_t *pud_alloc_kernel(p4d_t *p4d, unsigned long =
address)
>> +{
>> + 	if (unlikely(p4d_none(*p4d))) {
>> + 		if (__pud_alloc(&init_mm, p4d, address))
>> + 			return NULL;
>> + 		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
>> + 			arch_sync_kernel_mappings(address, address);
>> + 	}
>> +
>> + 	return pud_offset(p4d, address);
>> +}
>> +
>> static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, =
unsigned long address)
>> {
>> 	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, =
address))?
>> diff --git a/mm/kasan/init.c b/mm/kasan/init.c
>> index 66a883887987..93a74a1fcdec 100644
>> --- a/mm/kasan/init.c
>> +++ b/mm/kasan/init.c
>> @@ -206,7 +206,7 @@ static int __ref zero_p4d_populate(pgd_t *pgd, =
unsigned long addr,
>> 			pud_t *p;
>>=20
>> 			if (slab_is_available()) {
>> - 				p =3D pud_alloc(&init_mm, p4d, addr);
>> + 				p =3D pud_alloc_kernel(p4d, addr);
>=20
> I think it would be better to reuse pud_alloc_track() here.
> Pass a pgtbl_mod_mask through zero_p4d/pud/pmd_populate(), and call
> arch_sync_kernel_mappings()
> only once at the end of kasan_populate_early_shadow()

OK. No problem.

>> 				if (!p)
>> 					return -ENOMEM;
>> 			} else {
>> @@ -268,7 +268,7 @@ int __ref kasan_populate_early_shadow(const void =
*shadow_start,
>> 		if (pgd_none(*pgd)) {
>>=20
>> 			if (slab_is_available()) {
>> - 				if (!p4d_alloc(&init_mm, pgd, addr))
>> + 				if (!p4d_alloc_kernel(pgd, addr))
>=20
> Ditto

Yeah.

>=20
>> 					return -ENOMEM;
>> 			} else {
>> 				pgd_populate_kernel(addr, pgd,
>> @@ -322,6 +322,9 @@ static void kasan_free_pud(pud_t *pud_start, =
p4d_t *p4d)
>> 			return;
>> 	}
>>=20
>> + 	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
>> + 		return;
>> +
>=20
> With 4-level paging the PUD table is now kept here after it has been
> synced to every pgd. A later kasan_add_zero_shadow() call can =
overwrite
> it in init_mm only. This might cause a problem, because the aligned

Good catch.

> shortcuts in kasan_populate_early_shadow() and zero_p4d_populate()
> don't check whether the entry is already populated:
>=20
> mm/kasan/init.c:kasan_populate_early_shadow() {
>    ...
>                if (IS_ALIGNED(addr, PGDIR_SIZE) && end - addr >=3D =
PGDIR_SIZE) {
>            ...
>                        p4d_populate_kernel(addr, p4d,
>                                        =
lm_alias(kasan_early_shadow_pud));
>    ...
> }
>=20
> So sequence of kasan_add_zero_shadow(), kasan_remove_zero_shadow(),
> kasan_add_zero_shadow(), arch_sync_kernel_mappings()
> might trigger the BUG_ON() in sync_global_pgds_l4():
>=20
> arch/x86/mm/init_64.c:sync_global_pgds_l4() {
>    ...
>                        if (!p4d_none(*p4d_ref) && !p4d_none(*p4d))
>                                BUG_ON(p4d_pgtable(*p4d)
>                                       !=3D p4d_pgtable(*p4d_ref));
>    ...
> }
>=20
> Perhaps the aligned populate paths should skip an entry that is
> already populated.

I think so.

I'll update a new version to fix this.

Thanks,
Muchun

>=20
>> 	pud_free(&init_mm, pud_start);
>> 	p4d_clear(p4d);
>> }



