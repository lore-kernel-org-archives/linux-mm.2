Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C01B7606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GeMrxnvQ
Received: by kanga.kvack.org (Postfix)
	id CC1CB6B05C1; Tue,  3 Nov 2026 03:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C6D6B05C2; Tue,  3 Nov 2026 03:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16E56B05C3; Tue,  3 Nov 2026 03:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6546B05C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:49:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E94551A0339
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:49:29 +0000 (UTC)
X-FDA: 85393184058.15.9FF96BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 45254C0008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:49:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GeMrxnvQ;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695768;
	b=Ik/LNrPPB0Sjpb+eRPsf+mRen8JcgbQpIfhDTMgJKYmw3DjGbhax4zAWs1uFZsyoOsb+l/
	d4Tt0RU6fyw0LrsvfULpaVTNgRE5Fip5rWRnP0qBgc26ht8m2fOhZ7UQ+d55AuNDd02fRt
	LrjXwDy0ZBiNCU4zS9EnJzMDC91I6Uo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GeMrxnvQ;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695768;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKjb1wbG/EIzIWyCjCRnYVp4ON/5x4pkyYmDZcd6O6w=;
	b=C691qLf3lSFgDTVyA0m4A/otm66c+q5uhEJrxfTL7/JhoPca6o3/Qag02Ge3zdoka96hFG
	qgegL/S2UbBp+Rc7Oem6TlbHjPJVw85ECNRofJIbx2PFShY/Fa3RUhvysYjdzrjxfcNlJC
	vFVtH/whrfPJSetwqyZynm8aUoPBfaU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37D2042E94;
	Tue,  3 Nov 2026 08:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50731F000C1;
	Tue,  3 Nov 2026 08:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695767;
	bh=kKjb1wbG/EIzIWyCjCRnYVp4ON/5x4pkyYmDZcd6O6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GeMrxnvQGkybuXNxCBv0Hnl/0BBEzMYf4btC4ksy6vF/o6TGUw0bgsUR6h/CfdtAr
	 VrbpEPrR7Od3oFy0p8FYVdtu9l0DO49MISFMYk1hlI2WX6rphaqpeFkN5Aua89ea77
	 btAr3+HQt+iKHhcNtPe+YwsPcMyjcpAImxnelWhgoVCuQMMxWr7E+av/4ZPKNhc9JP
	 HOz/M4eFp5nKh3Uk32jqhecBuQe8aF8s0U0Z5GaGp/0FKm6ckvcmVs3Pf7qsbRLD5m
	 Txw75WkYgAWGvY5L+dluQiHWeVQCg1prg2hhmGVAqALTp83hNBqot9gfk0EXCizSkb
	 Bl3/rS5xkpOUg==
Message-ID: <sashiko-outbox-194883@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] mm/khugepaged: drop/reacquire mmap read lock if
 skipped enough VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>, "Will
 Deacon" <will@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Waiman Long" <longman@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Yonghong Song" <yonghong.song@linux.dev>, "Alexei
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Song
 Liu" <song@kernel.org>, "Jiri Olsa" <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>, "Ihor
 Solodrai" <ihor.solodrai@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org
In-Reply-To: <20261103-khugepaged-latency-fix-v1-5-a07ab16ac860@kernel.org>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-5-a07ab16ac860@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:49:25 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 45254C0008
X-Stat-Signature: witwsxanjcdfyzpcqc8e1k9c54uiessj
X-Rspam-User: 
X-HE-Tag: 1793695768-128731
X-HE-Meta: U2FsdGVkX1/VBtjSXKkFOosxV3jRWzXlmIkfCX9otR7nbJf3ya4k3y0eIItCGy4ZzS6hqlXB9PNeQo58bUwogLGGoAAEe9olKW+ejWIxm2dgSlW5JjrzH/7Mb1w/lZISpao0lb6nLoRFDNtGGyeAsSgQQ0tApcx0jVZBssSzf3dpkD13QOrsbsNjlB5hu022dOpDfjFK7p7s2Qjut+vNmJSDWcxHZPN2nLY5gaOCWxVbggEbGNqQs0xIZUcVsupZgNxjaLCAHArIc179FnlxHGRmFu/Jw7mL8mdRxd5mJi0Hpux2BjIW10JkpAcyU5/8KDZj883Ip/UsknDrq7C9u69rSmaV5sOccxbSSA5D1UtY4cecBfgNc9bXODSnSxPGl26bsGBy7KOEkbXKnbM+lpbajQRzxPeoNQkDWGW0Dzblyn92FzINihfT6aEKfHpMucEZ7bxzcuzOh7F4O77ufoKPI+481WTTLCePIksZsjOVYCDYJqEx8g9DFjDU6wSwXfCwJGyKHGuu2Q6PvQB4A/NcxjfSlc/hYK40NZPWjAWiDU8SgVrYrB4/1An7mFcjdhzse/cfEatc5j0zweKBbpj75I++pEO/fPkz4ZGKu1BlzaQE4HJb/dWkxa7KTSkjDXAmFECut5/mYO2FvQeoc84Nou0l5ipSPAoMAu+N/pPjwI9AZ9IQZn+Y6TKffe0dRwGLEmHM31RUGFVJDEFi8Dx7qitx/DBEp5vTMQRlD23HwJYw27RuuGVkeMqfWUr2SCEyVU2S6zX4iQmRI+uGvE6oTxr9JwHawddkEIXDYh/3pUm+6jjpynEAUs0OfXer0SbO7SnMkWxXEIPs2c4w5pwTStNgRvhu4OOmNs77ud3PkQvxpwJdVhxt2Qsf8f+FgnFo2gObAWS3WC2wnPgRT799/sRAZLXUXUVK3IWdDBVJ2OApwoX+jFMzSNHxrpaqseSkGSWLp4pBxPtXEGH
 qT0RMxEc
 be8GofdWBFf1iyWU3a0EwyK3nnPU81OS/tze7LbCrnil4IiycIrT4JznnGNbEkP1akHPwGpEG9VZ+hXdX6pp30v29+nzfo9iGfBRqinwnU24i1L7HAHB4sEWXUmKvGUHyQaTD38j+ouOGcV0iEIjLaTymKU97gfAcCiITOsaAik5TERgFpVHd1k1dCkPlwU3EdOpTRRBEkn2olTHkrGKmDQiztoc3ywBwpi2d6Ofn3ajfOGlnx1f1yc20J1AlAVsu6FBpdrTb1/YFAdBJO5KhEtgtGwdudi6C81oImzSbfbYNkIzY3rBDbOJu5ES2pX24yhuANd9Br+xhGn7YLYuQJxs1lTe9J15D7m1r2sGLLZE1WAtjP/GERC0NCxW1mswScDiew9BT8B3tC6ucVPAzCQG/dnHu4Uhw+Wf+hOnHXPo2Pam7e/CQmjl88uZpD+NKqty+aYiLZ0jQ3MOqLuY+14w3LCVCj/9lYQPXqViIZ8R0mCtlUGfsWiOZJzwtLI77G3H2mTpjl+YCPI7k2h19Buj5zzavX4R38dxD27ga3E76mI4sdKowrt7RiFwT7RbqNij8NC+PBpJajnsf5wHZzvzBGc/UDQ7v3qDTMbAqs4kJbGu/4nRZfVLeFpjjCkSJa43O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm/khugepaged: vm_end ALIGN() overflow rewinds vmi in collapse_sca=
n_mm_slot()
- [Medium] mm/khugepaged: sub-PMD VMAs bypass skip batching in collapse_sca=
n_mm_slot()
--

commit 0a737288374fc8ce4ac1b20ac082b7190ad6db37
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/khugepaged: drop/reacquire mmap read lock if skipped enough VMAs

This commit drops and reacquires the mmap read lock using
mmap_read_lock_nosteal() in collapse_scan_mm_slot() after skipping
KHUGEPAGED_MAX_SKIP_BATCH ineligible VMAs to reduce mmap_lock hold times and
relieve writer contention.

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 216c4b8d28c40..b9c72ee8b4211 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c

[ ... ]

> @@ -2910,6 +2916,7 @@ static void collapse_scan_mm_slot(unsigned int prog=
ress_max,
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
>  	unsigned int progress_prev =3D cc->progress;
> +	unsigned int skipped =3D 0;
> =20
>  	lockdep_assert_held(&khugepaged_mm_lock);
>  	*result =3D SCAN_FAIL;
> @@ -2951,6 +2958,14 @@ static void collapse_scan_mm_slot(unsigned int pro=
gress_max,
>  			/* Unable to collapse, skip to the next candidate. */
>  			mm_slot->address =3D ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
>  			cc->progress++;
> +			if (++skipped >=3D KHUGEPAGED_MAX_SKIP_BATCH) {
> +				/* Skipped a lot of VMAs, so wait for writers. */
> +				mmap_read_unlock(mm);
> +				cond_resched();
> +				mmap_read_lock_nosteal(mm);
> +				vma_iter_set(&vmi, mm_slot->address);
> +				skipped =3D 0;
> +			}

[Severity: High]
Can mm_slot->address overflow to 0 here and cause vma_iter_set() to rewind
vmi back to the start of the address space?

On architectures where TASK_SIZE extends into the final PMD range of the
unsigned long address space, such as 64-bit s390 in
arch/s390/include/asm/processor.h:

#define TASK_SIZE		(TASK_SIZE_MAX)
#define TASK_UNMAPPED_BASE	(_REGION2_SIZE >> 1)
#define TASK_SIZE_MAX		(-PAGE_SIZE)

a user process can map VMAs with vma->vm_end > (ULONG_MAX & HPAGE_PMD_MASK).
When collapse_scan_mm_slot() skips such a VMA,
ALIGN(vma->vm_end, HPAGE_PMD_SIZE) wraps around to 0.

If ++skipped >=3D KHUGEPAGED_MAX_SKIP_BATCH triggers on that VMA,
vma_iter_set(&vmi, mm_slot->address) resets the VMA iterator to address 0.
Because the !collapse_possible_orders() path does not check
cc->progress >=3D progress_max, if the mm contains no eligible PMD-spanning
VMAs (for example, 1024 ineligible VMAs ending in the top PMD range),
wouldn't for_each_vma(vmi, vma) restart from address 0 and loop
indefinitely inside collapse_scan_mm_slot() until the process exits or THP
is disabled?

>  			continue;
>  		}
>  		hstart =3D ALIGN(vma->vm_start, HPAGE_PMD_SIZE);

[Severity: Medium]
Should the skip batching and progress accounting also cover VMAs that pass
collapse_possible_orders() under sub-PMD mTHP but do not span a full PMD?

In mm/khugepaged.c, collapse_possible_orders() checks all enabled anonymous
mTHP orders when called with TVA_KHUGEPAGED:

static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
		vm_flags_t vm_flags, enum tva_type tva_flags)
{
	unsigned long orders;

	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
	if ((tva_flags =3D=3D TVA_KHUGEPAGED) && vma_is_anonymous(vma))
		orders =3D THP_ORDERS_ALL_ANON;
	else
		orders =3D BIT(HPAGE_PMD_ORDER);

	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
}

When a sub-PMD anonymous mTHP order is enabled, a faulted anonymous VMA
smaller than HPAGE_PMD_SIZE passes collapse_possible_orders(), bypassing
the !collapse_possible_orders() block in collapse_scan_mm_slot() and
falling through to:

		hstart =3D ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
		hend =3D ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE);
		if (mm_slot->address > hend) {
			cc->progress++;
			continue;
		}
		if (mm_slot->address < hstart)
			mm_slot->address =3D hstart;
		VM_WARN_ON_ONCE(mm_slot->address & ~HPAGE_PMD_MASK);

		while (mm_slot->address < hend) {

For these sub-PMD VMAs, hstart >=3D hend:
- When mm_slot->address > hend, it increments cc->progress and continues
  without incrementing skipped or dropping mmap_lock.
- When mm_slot->address <=3D hend (for instance, when a sub-PMD VMA starts =
on
  a PMD boundary so hstart =3D=3D hend =3D=3D mm_slot->address, or on the f=
irst
  unaligned sub-PMD VMA in a PMD range where mm_slot->address =3D=3D hend <
  hstart), both mm_slot->address > hend and mm_slot->address < hend are
  false, so neither skipped nor cc->progress is incremented.

As a result, if an mm has a large number of small faulted anonymous VMAs
while sub-PMD mTHP is enabled, wouldn't collapse_scan_mm_slot() still walk
all of them without ever reaching KHUGEPAGED_MAX_SKIP_BATCH and dropping
mmap_lock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-khugepaged=
-latency-fix-v1-0-a07ab16ac860@kernel.org?part=3D5

