Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A02CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C80F6B0119; Mon, 19 Oct 2026 00:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378826B011A; Mon, 19 Oct 2026 00:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2909F6B011B; Mon, 19 Oct 2026 00:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F39466B0119
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:35:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85C40405D3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:35:23 +0000 (UTC)
X-FDA: 85338111726.12.87B49F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id EA9B1100003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:35:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzQGxFq7;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792384521;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yJfhlID4fPBOMkqV1WPDOqXgcDXux6NyWocqTjnn2g=;
	b=mTGQDtTVNiCjYTrgaYhgdXDm5LlHDXpMqQcdlrTkGIG6rJ2WKD0GQV4MZj72gqYZSckTlx
	LtCEvi2RAtoCWygs6aDJrSVIfyMCSVx4G3VX+SiyOcxX8sZEgkVmwYfysuvAH59OO8lfKU
	JKckHLf4OP0p7jOX5S3mJdJEwSJ3/yQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792384521;
	b=MOpqgZfS8IbbJVt6LXk14ybJ3XSV0K84abWT9DrgSjog5fMkUWxmp4gY73S0gdXDnFEQKh
	gxtB2klfqRSPQNkQF6X8FD+2gGT3qpU79hO9+DC9wrE8TLb04tR/+ZBaOcELkKr0rJhykx
	zew0qsMnLesNJLqvtswqbV9t4k3wrbY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzQGxFq7;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 665EB601DB;
	Mon, 19 Oct 2026 04:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404CC1F000C4;
	Mon, 19 Oct 2026 04:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792384521;
	bh=4yJfhlID4fPBOMkqV1WPDOqXgcDXux6NyWocqTjnn2g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OzQGxFq7LnoaH2sBKLf4N2VMO2ZNXiWKD2jjmIm7oya1wsXuWDnVXYYSdz1i7KPN9
	 PL2VCbQv09vKJb9fU6nZ2w0zli5D8OUDeOWUAFqIor5+PS0aXbPU81bUIfCXmnhKqv
	 Bb2E9f+YNIAKNBmxMUAvubAT9eWsla59+tHY91iu7JKjcwWJciQhsRnIsY84PZgSsR
	 G1CvKKxjmLaILM06FvWzPCz1E05w+Vqg3fjjKhaKJ4s3WLoGeRiIELwXLFBf9YvdPj
	 K+4gw6q0RHz2Zsxzq3uMbB4jJbLEvLKKgJPRLH+TQPUAS31EMEvaB3FRhjj2AgaVHJ
	 qXBNHllpoMrgA==
Message-ID: <sashiko-outbox-176636@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] kasan: fix runtime shadow page table synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Alexander
 Potapenko" <glider@google.com>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>, "Dan
 Williams" <djbw@kernel.org>, linux-mm@kvack.org, kasan-dev@googlegroups.com, muchun.song@linux.dev
In-Reply-To: <20261018043501.3257632-1-songmuchun@bytedance.com>
References: <20261018043501.3257632-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 04:35:19 +0000
X-Stat-Signature: a8w3k86n9j6k997iapd1txwxjtjz6t48
X-Rspam-User: 
X-Rspamd-Queue-Id: EA9B1100003
X-Rspamd-Server: rspam10
X-HE-Tag: 1792384521-456206
X-HE-Meta: U2FsdGVkX18eFOjtLu6FBxF5fZwKizJaWU0vQpmjpu0yaT1E36PqSCqIFPhBPstG+9lQVqwg3J4eq1Ar5+mT6y37/7Um5ctADD25xQmXBxV3Rwmg8HTRHbXk68lp3qKXDIbbQ4wYsZjI8GddGw8ZEQRbItv3AwSjFwYg5A56G+N6IcDy8fthiOl4n/Tm15RB/MdRoxqwTUd8HGDvSbyg/oz9ON6uq4bQGyOYoENzbl14ncudPTUCOMq8n7MZsjXf2mz22Wg7yIVms4Q65yeSKpegyJXLa3zeiAVtyD9nnTiSKFF3RDVATIEPWNFhisMjzs1xhK0cp545HKA9wF2Z0+YM2MltbeYbgXdCRGh+KuWrjXZqQqq4MP3KJJaKiolKsVZ7nPG8c22AS5MbsvMHY0Gwvro+vfhCHtExl7tIXNllibV2Munt4JatlwiigeHn8OGEXwV1HOsOvdcBFlZBuwj7nBeWKhlVZmepCxfADvxRmkJTiXoXWOu+mLI89s80UqMXZBJqmI7i65BzP7QXRfUzGxMnIahYYcpDSQj7JjBjxtyL0IIG17cJz0FfKMUPxuBQMmr5i9X1X0VdFq/cSMyhkJdbro1xbb7Pl33eN8kM1bdOXRMCmuUPaC/CbghoYG8jkrgREvCbcH1z+bXWUx276Ip2N/j86J762asMU6onetNKgkWtkg7Y6VwwOG/yks+sYMRcVJo6NTByuUBDzK6iX7j7S4buG6Jjm09cIk23vuFGj5m89dS1sYnvNZ4AzkFo6fY3mitAJmnFw1XZtKvfqYlGrBQfXGaH6yjq37EY7hJAFROy+8ZIjNqK8xaoRKDBEUJioJ+KDPSi31Y//7ppktr0XdwgXjgxtjTojfSRlndIiwh+R5Os6daBlC8YxCS5Zp/MrCQKorObFawjyxPO4v9Ry+SM0RdIvg+GIlCG8r9MFGhO5TCsFZmPpzgb9ILTBKEdjkIYwOOZJOs
 7Sd0ruZ7
 8b1+YlPGPJeTFYlCKfjAI6g8fkawN2dRAm3a3uvYkJauAN5jyoNx/E7LPBASMNi71xOl4AL83cD/AeRAMkMtCT2kIYvbM283HlB3Pi7wvygOVMik4Qo21zPP4+5aESAdV4w3LoZMEsIkXcJdCMlbp1KigXcBrjdIcUXznz8LycUDxCiqZaoVrty8AIXo2BsTcNzvOAJJOF1xCIHMDiS/g8sN+2ph8AuuKua3H3g+HuLqzfxwI8fUX1jFZ5vUesthiv/qIpOA6VkYfb4sC5d0igdxtdknCBmTOvPFhr2Fi5IuHD0ZHXAK4u6SlwIS1sAWbJyAazGe7kGFUqDl2GBnS5WmoX5mFMp0VS4V5vJmhKhFWPRcRjJeI9XK8QfNizB1h0saVrjuj0NlRUnqBom5duOySE7MVncq9pMF+F+hDz/Bo6yhQTo7WjZaoWDfQTTj97EXnDnmEMWMKEG3aEQkhWo+ae5kpY5ya2fWIwbk/rPkkT86toKZzDzKrqV02zgsCcJJGhYLDOvSgtQGTPda/9UaBPgP/fVR0qAIewr1YweEYm5AUPszOINYmMTCrmwE9z/mCFUoK8+6BSbno/MkTpm3oSqXQdyyFVNwub458icn1+xdAxJlFibPOY2+6X5SruCWqjUikUg1V9lkiIjH/j44Fxa/gYXQy2wgN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] kasan: syncing static early shadow tables breaks kasan_remove_zero=
_shadow()
- [High] kasan: missing kasan_p*d_table() checks in kasan_populate_early_sh=
adow()
--

commit 84e267a96cb1eab3b9fd041e188f62b5f7899dd0
Author: Muchun Song <muchun.song@linux.dev>

kasan: fix runtime shadow page table synchronization

This commit tracks page table modifications during KASAN zero-shadow
population and calls arch_sync_kernel_mappings() once after the walk. It al=
so
avoids replacing already-populated page table entries during aligned shadow
population and retains page tables referenced by synchronized entries during
teardown.

> diff --git a/mm/kasan/init.c b/mm/kasan/init.c
> index 66a8838879876..f94f461d864ca 100644
> --- a/mm/kasan/init.c
> +++ b/mm/kasan/init.c

[ ... ]

> @@ -115,25 +116,26 @@ static int __ref zero_pmd_populate(pud_t *pud, unsi=
gned long addr,
>  	do {
>  		next =3D pmd_addr_end(addr, end);
> =20
> -		if (IS_ALIGNED(addr, PMD_SIZE) && end - addr >=3D PMD_SIZE) {
> +		if (IS_ALIGNED(addr, PMD_SIZE) && end - addr >=3D PMD_SIZE &&
> +		    pmd_none(*pmd)) {
>  			pmd_populate_kernel(&init_mm, pmd,
>  					lm_alias(kasan_early_shadow_pte));
> +			*mask |=3D PGTBL_PMD_MODIFIED;
>  			continue;
>  		}

[Severity: High]
What happens in zero_pmd_populate(), zero_pud_populate(), zero_p4d_populate=
(),
and kasan_populate_early_shadow() when the page table entry is not none
because it already points to the shared static early shadow table
(kasan_pte_table(*pmd), kasan_pmd_table(*pud), kasan_pud_table(*p4d), or
kasan_p4d_table(*pgd))?

For example, in arch/loongarch/mm/kasan_init.c, kasan_init() pre-populates
swapper_pg_dir across the entire shadow range with kasan_early_shadow_* bef=
ore
calling kasan_populate_early_shadow():

arch/loongarch/mm/kasan_init.c:kasan_init() {
	/* Maps everything to a single page of zeroes */
	kasan_pgd_populate(KASAN_SHADOW_START, KASAN_SHADOW_END, NUMA_NO_NODE, tru=
e);

	kasan_populate_early_shadow(mem_to_shadow((void *)VMALLOC_START),
					mem_to_shadow((void *)KFENCE_AREA_END));
}

Because *p4d, *pud, and *pmd point to kasan_early_shadow_pud,
kasan_early_shadow_pmd, and kasan_early_shadow_pte rather than
invalid_pud_table, invalid_pmd_table, and invalid_pte_table, p4d_none(*p4d),
pud_none(*pud), and pmd_none(*pmd) all evaluate to false.

Instead of skipping aligned PGDIR_SIZE, P4D_SIZE, PUD_SIZE, and PMD_SIZE
blocks, kasan_populate_early_shadow() descends into zero_pte_populate() for
every single PMD across the multi-terabyte VMALLOC_START..KFENCE_AREA_END
shadow range, executing billions of redundant set_pte_at() calls on the same
shared kasan_early_shadow_pte array (and on 16KB-page LoongArch configs whe=
re
mem_to_shadow(VMALLOC_START) is not PMD-aligned, prematurely write-protecti=
ng
kasan_early_shadow_pte entries while kasan_pg_dir is still active).

The same descent into the shared static kasan_early_shadow_* tables happens=
 at
runtime if kasan_add_zero_shadow() -> kasan_populate_early_shadow() is call=
ed
again on a range where kasan_remove_zero_shadow() previously retained a
synchronized kasan_early_shadow_* entry.

Should these aligned fast paths also check whether the entry already points=
 to
kasan_early_shadow_{p4d,pud,pmd,pte} (and skip descending without needing to
re-populate or set the modified mask)?

[ ... ]

> @@ -377,6 +420,9 @@ static void kasan_remove_pmd_table(pmd_t *pmd, unsign=
ed long addr,
>  			continue;
> =20
>  		if (kasan_pte_table(*pmd)) {
> +			if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PMD_MODIFIED)
> +				continue;
> +
>  			if (IS_ALIGNED(addr, PMD_SIZE) &&
>  			    IS_ALIGNED(next, PMD_SIZE)) {
>  				pmd_clear(pmd);
> @@ -403,6 +449,9 @@ static void kasan_remove_pud_table(pud_t *pud, unsign=
ed long addr,
>  			continue;
> =20
>  		if (kasan_pmd_table(*pud)) {
> +			if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PUD_MODIFIED)
> +				continue;
> +
>  			if (IS_ALIGNED(addr, PUD_SIZE) &&
>  			    IS_ALIGNED(next, PUD_SIZE)) {
>  				pud_clear(pud);
> @@ -430,6 +479,9 @@ static void kasan_remove_p4d_table(p4d_t *p4d, unsign=
ed long addr,
>  			continue;
> =20
>  		if (kasan_pud_table(*p4d)) {
> +			if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
> +				continue;
> +
>  			if (IS_ALIGNED(addr, P4D_SIZE) &&
>  			    IS_ALIGNED(next, P4D_SIZE)) {
>  				p4d_clear(p4d);
> @@ -464,6 +516,9 @@ void kasan_remove_zero_shadow(void *start, unsigned l=
ong size)
>  			continue;
> =20
>  		if (kasan_p4d_table(*pgd)) {
> +			if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
> +				continue;
> +
>  			if (IS_ALIGNED(addr, PGDIR_SIZE) &&
>  			    IS_ALIGNED(next, PGDIR_SIZE)) {
>  				pgd_clear(pgd);

[Severity: High]
Can skipping synchronized kasan_early_shadow_{p4d,pud,pmd,pte} entries here
prevent kasan_remove_zero_shadow() from unmapping the zero shadow at all?

When kasan_add_zero_shadow() -> kasan_populate_early_shadow() runs at runti=
me
(with slab_is_available() =3D=3D true) for a range covering an aligned PGDI=
R_SIZE,
P4D_SIZE, PUD_SIZE, or PMD_SIZE boundary at a level included in
ARCH_PAGE_TABLE_SYNC_MASK (for example, PGTBL_P4D_MODIFIED on 4-level x86_6=
4,
PGTBL_PGD_MODIFIED on 5-level x86_64, or PGTBL_PMD_MODIFIED on 32-bit x86/A=
RM),
it installs the shared static kasan_early_shadow_{p4d,pud,pmd,pte} table
directly into the synchronized entry.

When kasan_remove_zero_shadow() is later called to remove that shadow mappi=
ng,
hitting this continue leaves the entry pointing to kasan_early_shadow_*.
Unlike a dynamically allocated page table (where kasan_remove_*_table()
descends and clears all child entries before kasan_free_*() retains only the
empty top-level table), kasan_early_shadow_* is a shared static table whose
entries cannot be cleared and remain permanently mapped to the read-only
kasan_early_shadow_page.

If normal System RAM is subsequently hot-added and onlined in that address
range, kasan_mem_notifier() in mm/kasan/shadow.c checks shadow_mapped():

mm/kasan/shadow.c:kasan_mem_notifier() {
	...
	case MEM_GOING_ONLINE: {
		...
		if (shadow_mapped(shadow_start))
			return NOTIFY_OK;
}

Because the read-only kasan_early_shadow_page PTE is still present,
shadow_mapped() returns true and kasan_mem_notifier() skips allocating
writable shadow memory, causing subsequent KASAN shadow writes to fault on =
the
read-only zero shadow page. In addition, if a smaller or unaligned range
within that region is later passed to kasan_add_zero_shadow(),
kasan_populate_early_shadow() sees !p*d_none(*p*d) and descends into and
modifies the shared global kasan_early_shadow_* tables.

Should kasan_populate_early_shadow() avoid installing the static
kasan_early_shadow_{p4d,pud,pmd,pte} tables at page table levels that are in
ARCH_PAGE_TABLE_SYNC_MASK when slab_is_available() is true, and instead
allocate a normal page table at that synchronized level so its entries can =
be
cleared during kasan_remove_zero_shadow()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261018043501.3257=
632-1-songmuchun@bytedance.com?part=3D1

