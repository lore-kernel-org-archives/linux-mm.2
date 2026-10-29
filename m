Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BED606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=no0Efm+O
Received: by kanga.kvack.org (Postfix)
	id B25F26B00EF; Wed, 28 Oct 2026 23:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5A86B05B1; Wed, 28 Oct 2026 23:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4D46B05B2; Wed, 28 Oct 2026 23:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DAD66B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:58:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0755CA7B96
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:58:38 +0000 (UTC)
X-FDA: 85374307116.19.2FF5F87
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6F4CB100005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:58:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=no0Efm+O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793246316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=DH/fKpO0BoTPGL2h5tiHaOMY8UyYNemLu3Miwyi1WAU=;
	b=eV6QgFL5NvfX5X0kGFDZK/KWpHUtsUnv3C8NJ/UaJLzf/wRrWI5NZpvuD4m0ywlN28/0ow
	OV7VHsbpZ8tfJy7FXnaqPj/5fMT23g+vkgFZx8wEnnHgCiq82Z+HpWYW5E9Ur+gEKOvbbp
	H33lKL3SwfA+n4h0obrT4D6nUhMWsZk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=no0Efm+O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793246316;
	b=frMGK9/P0Y2/Z3g4/H+MwXG7Or2pci1zDwdQDS73zhFfTroOPReY3tXnsumeIOrmzIV9iz
	N8no9kjKdpRhT6J+NqC0pUzLEgGvfwMWpVhtgh2+uqc8wA/MY1wdg+qUSb4IjpmpAeZYrH
	AWYqiYPFG9szk3iT35DCmJN9cwJSQzk=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso3105840eec.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793246315; x=1793851115; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DH/fKpO0BoTPGL2h5tiHaOMY8UyYNemLu3Miwyi1WAU=;
        b=no0Efm+Oq+m1lLsDdAvOzhp27l6qoSNMBThCoNLeXfm1DaoM2GaXjJ0zRLJVty2PxV
         KM+KPpZTmTv6Rjh+Ou8E85BSRi/Q8qQnh+e+GP+pHjrUJ0cy8oIxV/amg9h+5DD1KF6k
         XsT/pgIFz1sU6i6/+61I7u3id/1OiLDLEozY+icJfTLgQPEPF+/uQuegQvapU0D3tgG+
         wzXro0q4bMn91QBgiKjjSQm5HgK0Uty1nSj29wnIFmKgLI3gemOkKtQz0izqQ164N3Bl
         W/1MKdTFfoM9Dl18MW/64Us/owhBpiQsN0ewcqldPv/vEYXzpn7HORrM8C4U7KY8iWPm
         9HPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793246315; x=1793851115;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DH/fKpO0BoTPGL2h5tiHaOMY8UyYNemLu3Miwyi1WAU=;
        b=V0AREXNpbmurMKyPFa/5ahFGDrWoXORMa9MV0PNsMqNxPVetNxtJ/4yCnF6wkuAmky
         nvyNORxcWceXEyuDwqWeI5wQa2SzBf3G96GOFffO8qJcb64v24/VmuThuvvXST9z0a+i
         rAFdaBmY7kZtWGnQEwrCP7JH/I7PbjHW2Bk3kNOMhyUH3dAFUbGwceC+v79DOdWxkS0u
         pfOWDkY4uxCjPpcQ3cghVddbv7jVQwBw+nsuL2jqi3o/UY8f9EWaBlP7GJ5yyOcFpM/0
         RomZc/Qd9FoeAv4P91YqBWxBXcVsLM2SeluJRX1InRoqTgYW6WC3qjV3S+15+CMTohP0
         yiXA==
X-Gm-Message-State: AFq9FYLpk4g2wPQuF2tMY/A+mp2mngXF4SVF1PjMrU5GwFY5ef3w/l3Z
	HXUtDIezBeKEQmc9Rr1t2CO8+PSmx7aFMA6J+btT3lsEmBrSoUlMXcbE
X-Gm-Gg: AYBFou2We3eWq7HDwpsT9W/euUbvQXYKcM38Kq7VlKZzDl7/zso0Q4FfQpiyGKAKqyt
	VlHX/YVjwutziXKxP/HobZEz6NQLYDBv84iwmyh2DtMH3Lk85MES1MVINz/ZyDDL8Asyu+oyIhe
	PHH3V0fSgD/FWTl5m0974fKrDCxtk1n0tXxuhewfYBzubVXGsC9x/3IovLOmUz58HKBJlm60HID
	9fD/h+Hr7DVtM9xjmburaXJD5TwTlXV+f1hu4sdtPhXZAfAgeyqQ06a5lkklekBfOWVeydWJqa0
	PapxdU8yUS7LNNv3m4I6DF74l11TDMZd7olxtzDGT9L+g+4z+rxNnHvzLBuEtDR8vfaWe7JsoUn
	T+/5fnpZFYYUT2x1yE4A6dRIORXJ91XHmpWfa2bWXdyS3j7gIxRMgJIrC+cROZsVbBFbjvbeWr5
	pK4KgdyVUNTOeXZ4yY7c4dXYSCXAXbPRr1GOuDp5Vuizy9Src5RiS9ZrkJ7lI7SEF7QShfJTn1r
	oOPf32ZaZgSrcYVd23SZs5LvnQ5nLOWv5h073y6QikDpd1W9nIdSkAQYRxZqB+DP002xUKX8Xx7
	9MmdRE5yk9DBHsnFnw2lPllVus0=
X-Received: by 2002:a05:701b:260d:b0:14d:c53a:f6a0 with SMTP id a92af1059eb24-1a6cd499523mr4859697c88.13.1793246314816;
        Wed, 28 Oct 2026 20:58:34 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75fdc1031sm11012363c88.19.2026.10.28.20.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 20:58:34 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Christophe Leroy <chleroy@kernel.org>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, David Hildenbrand <david@kernel.org>, Pavithra <pavrampu@linux.ibm.com>
Subject: Re: [PATCH 1/2] powerpc/64s/radix: don't dedup vmemmap covered by an existing PMD leaf
In-Reply-To: <2C88EF3C-1E7D-4395-99C5-711FFB01469A@linux.dev>
Date: Thu, 29 Oct 2026 09:20:11 +0530
Message-ID: <ik2lw4gc.ritesh.list@gmail.com>
References: <97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com> <2C88EF3C-1E7D-4395-99C5-711FFB01469A@linux.dev>
X-Rspamd-Queue-Id: 6F4CB100005
X-Stat-Signature: 5zrp4ssaxtai9hwnifh4htnyk686857f
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793246316-357666
X-HE-Meta: U2FsdGVkX19reB1JlG4YGACQ3NkEgfoRfY2PHdMjJuJDFTE/zFL8x6C2Z2othY+t3jPJoJmCPkyYkMXWcAcpKpn046BUnANDk2MGi83//NYpsZL9zLfBOXk41WO6eKBDHSQUwNPkcFFjAN3a54fL0n6QnBi6AC5cDg7BZzh353RFfWAdRiu5Id6Luam1E6w6KkOyCGYeINdYgeSJNZAr0qkwqsOI7pwIOeAzHzAwyfIh0hOeAhk4iLtEegCSbsFywlLw2WTNKrjXMVCRWGTBV58FnRLbt1+g4/wuisInxRgn+vTqgl1kBMX1pjXLBj7y19Q0+CEpP0ugrqSeWba3b9SzdFsUrcjSiu6pWRySZCcJoq5AzgwR5h5Vq0pLSmH+vQXiC5ssLpdVjVaJRUmmyqW4lxGxcoAnIi8SM7QDtdiLMhrNRdLIsa7lxNDczDgL1m67z7FPnbpRvLwlw1a3qzIyEtqSMkDwfFuAMBRacdCfqa9H6lapuS2a0YaKTm8KoJ59mxebpa8Lj2BxnxDlZCmuqlKTMUsKEGmqk1O2wJsjnp5pKUPo0NoI+siQApHesPlJXqeq1MhA+kl7MrhbyYZoHCoHtzvoFo+Mrkvz2b0J5YN3mDBjCLFJZXdOT5pbMZmjfZcv6nFhdaa7QCcS8eGVT8VwSyhF1ztQV5WHIhg0RsqSd6sgsSApPGQyvVn4XxUh6XJHhwku2dzw6mBNmObKZIkDBp8gdb2WWx6oaTut7yirjncCrCTEHbKBcObKS0RmDTC6bmIDRkrBeHmTi3BC65BU030cl9f21rM/4zvNpYc/1Q+ybYz+heSQwfFtAj1gCCrew3Tzq95E0mkL1qsth09VoOx1Im7a3mRCTqrCujh7gyG3fb5dgeqZjITUTCj5K/vtZ/2GgSbbllB3onV19D2Pc/nK/JGGjkXLB3JY7+0ktVVq1VjsVXGR63n8OAhQNwwWgI07bPBTWdu
 P7H/dfkq
 U+CD84RsKoMrMjpGBhDhyaYw1aNsgavvWz7A56qYS2A37TwKHGlU7ieaEvoLAahpsRoNMHid1lzQgDqNjT5UWoSsk/avS0lIUkkehjfzAbZRSwvOTSgo4I039VQ0ZtWAXweOFlM+3Ai8HlwONtMMwtKF2aloTj/6X6m3gwkz1PAmiceToFjfDvUQZX0hZW2BQuaGtTqbCUdTlSWM6cqV6U3NsS+eO5I7djP2tlnSLbq3zi739PBmvYBRAd6ndjgylrJTpCCJ6cjSZvX8yj25VMgDBKMX5lcqR+FTY5uxs8+J1QHiZejXHD30QKoi3PMp7u+RVEW+ctusXl4eyAaO4KKdDZjDfDztOFy7Lnf0dAnreOQYxf+atG+mI0pGnSfbwFiH0gssyp3wBKX4JjUslU0C1v7jTruVWcpXORzB2LmPqJNK3gIed8KWmh7Av4xfpGoO/x9g0yQosefyjIwQ+z3TVxUx/3BUujtia9TDjl/qg2yjXRbNc1xDshSYv2aODx4ENdTdiJLtUXaeu9jLVJZWqZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Muchun Song <muchun.song@linux.dev> writes:

> Hi Ritesh,
>
>> On Oct 27, 2026, at 11:22, Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:
>> 
>> radix__vmemmap_populate() is asked for one 16MB section, which is 16KB of
>> struct pages. With no altmap it rounds the request down to a PMD leaf.
>> That leaf describes 2GB of PFNs with 64KB pages (128MB with 4KB pages),
>> so it also covers sections that are not present yet. It cannot be freed
>> while any of those sections are still in use.
>> 
>> A devdax namespace that lands in the same window is marked for vmemmap dedup.
>> vmemmap_populate_compound_pages() treated the leaf as an existing huge mapping
>> and skipped it. The core then initializes only the head vmemmap page and assumes
>> the rest is the shared tail. Those remaining tail slots are real struct pages
>> still holding the page_init_poison() pattern and are not the shared tail pages.
>
> Right.
>
>> __init_single_page() warns on the zone mismatch and the following pageblock init
>> faults in __set_pfnblock_flags_mask().
>
> Yeah, the new adding warning is useful.
>
>> 
>> If the section's vmemmap is already a PMD leaf, clear its compound order
>
> I think it's enough to fix this issue.
>

Oh yes, right! since the page init is done later and the optimizable
order can be read from mem_section.

>> and reuse the leaf, so every struct page in the section is initialized.
>> The shared-tail layout needs base-page PTEs, so it cannot be built on top of
>> this leaf and dropping the leaf is not an option while the neighbouring range
>> is still using it. So, fail the compound populate if a leaf is still seen there.
>> 
>> <Call Trace>
>> ============
>> [    3.467060][    T1] WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4, CPU#0: swapper/0/1
>> <...>
>> [    3.477419][    T1] NIP [c000000000576b30] __init_single_page+0xd0/0xf4
>> [    3.477827][    T1] LR [c0000000005778b0] __init_zone_device_page+0x30/0xb8
>> [    3.478444][    T1] Call Trace:
>> [    3.478764][    T1]  0x10000 (unreliable)
>> [    3.479874][    T1]  memmap_init_zone_device+0x164/0x430
>> [    3.480392][    T1]  memremap_pages+0x43c/0x93c
>> [    3.480836][    T1]  devm_memremap_pages+0x3c/0xa4
>> [    3.481328][    T1]  dev_dax_probe+0x264/0x3d0
>> [    3.481817][    T1]  dax_bus_probe+0x140/0x1c8
>> [    3.482237][    T1]  really_probe+0x108/0x580
>> [    3.482681][    T1]  __driver_probe_device+0xcc/0x284
>> [    3.483186][    T1]  driver_probe_device+0x5c/0x108
>> [    3.483656][    T1]  __device_attach_driver+0x10c/0x1e8
>> [    3.484134][    T1]  bus_for_each_drv+0xc0/0x13c
>> <...>
>> [    3.499972][    T1] BUG: Kernel NULL pointer dereference on read at 0x00001400
>> [    3.500417][    T1] Faulting instruction address: 0xc0000000005f4ecc
>> [    3.500417][    T1] Faulting instruction address: 0xc0000000005f4ecc
>> cpu 0x0: Vector: 300 (Data Access) at [c000000006756b50]
>>    pc: c0000000005f4ecc: __set_pfnblock_flags_mask.constprop.0+0x34/0x160
>>    lr: c000000000577f38: memmap_init_zone_device+0x358/0x430
>>    pid   = 1, comm = swapper/0
>> enter ? for help
>>  memmap_init_zone_device+0x358/0x430
>>  memmap_init_zone_device+0x220/0x430 (unreliable)
>>  memremap_pages+0x43c/0x93c
>>  devm_memremap_pages+0x3c/0xa4
>>  dev_dax_probe+0x264/0x3d0
>>  dax_bus_probe+0x140/0x1c8
>>  really_probe+0x108/0x580
>> <...>
>> 
>> Fixes: bd0862382adb ("mm/sparse-vmemmap: drop Device DAX-specific population path")
>
> Actually, the right Fixes is:
>
> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
>
> On older kernels, these errors are silent. They trigger a kernel panic when the user
> actually uses Device DAX, rather than during the initialization phase. 
>
> So, for older kernels, we should guide them to backport the patch.
>
>> Reported-by: Pavithra <pavrampu@linux.ibm.com>
>> Assisted-by: LLM
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>> Fixes tag here is added since the fix is dependent upon the change mentioned in
>> "Fixes" tag. The Fixes commit-id is from mm-new branch. Although this could be
>> an older pre-existing issue, but got exposed after this patch series.
>
> I knew this issue, so I have a local commit to fix it as well. I'd like to share
> it with you, because it looks a little simple, does it work for you?
>
> powerpc/mm: fix uninitialized ZONE_DEVICE struct pages with PMDs
>
> PowerPC radix vmemmap population can reuse an existing PMD mapping while
> populating a device DAX range whose section is marked as HVO-enabled. The
> reused mapping is an ordinary vmemmap mapping: the redundant tail struct
> pages are not remapped to the shared tail page.
>
> Leaving the section marked as HVO-enabled makes later ZONE_DEVICE
> initialization treat the range as optimized and initialize only the struct
> pages that would be backed by a real HVO mapping. The remaining tail struct
> pages can then be left uninitialized even though they are still used as
> metadata for the device DAX compound page.
>

Here, feel free to use the call trace from my commit msg to show what goes
wrong w/o this fix.

> The Fixes target predates the section-based vmemmap optimization
> infrastructure, so older kernels do not have section state that can be
> marked non-HVO. Backports to such kernels need to handle the PMD-reuse
> case in powerpc radix code directly, for example by initializing the tail
> struct pages that core ZONE_DEVICE initialization would otherwise skip.
>
> Mark the section as non-HVO when reusing an existing PMD mapping, so the
> section's HVO state matches the actual vmemmap layout and all required
> struct pages are initialized.
>
> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

yes, love this approach. Thanks for sharing the fix.

>
> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
> index 72793ace1fb6..fc3a2d4b422d 100644
> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> @@ -1200,7 +1200,16 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>  			return -ENOMEM;
>
>  		if (pmd_leaf(READ_ONCE(*pmd))) {
> -			/* existing huge mapping. Skip the range */
> +			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
> +			struct mem_section *ms = __pfn_to_section(addr_pfn);
> +
> +			/*
> +			 * Existing PMD mappings can cover the edges of a valid
> +			 * HVO populate range.  They are ordinary vmemmap mappings,
> +			 * so the current section must not be treated as HVO-backed
> +			 * when its struct pages are initialized later.
> +			 */
> +			section_set_order(ms, 0);

I think you meant "section_set_compound_order(ms, 0);"

yes, otherwise the patch looks good to me. Can you please post this
patch separately then? Feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

I have validated the fix with my custom reproducer and I see the issue
is fixed with this. Meanwhile, Pavithra (cc'd) is testing this and few
other patches of your series. Once her testing is finished, she can help
provide her Tested-by/feedback if any.

>  			next = pmd_addr_end(addr, end);
>  			continue;
>  		}

-ritesh

