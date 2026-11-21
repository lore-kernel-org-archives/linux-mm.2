Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F69F606A33D
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iS5n6k7R
Received: by kanga.kvack.org (Postfix)
	id 961226B05B6; Fri, 20 Nov 2026 20:09:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911AB6B05B7; Fri, 20 Nov 2026 20:09:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8003F6B05B8; Fri, 20 Nov 2026 20:09:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5478F6B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3C62A02A5
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:19 +0000 (UTC)
X-FDA: 85457342838.12.B256961
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1ECF2120003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iS5n6k7R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223358;
	b=x7p6B9QHYSW34DATVqdUWqKrff00G4dXlhNdckrytZ254t/zAcyU3az/wuUfBtaFlADxLa
	cZG2MGZywr2s7y2P6xmfBKkVxGnxBmxoy9o+c7tRSYN/UaIsfm/seMU6lICnZ9mu8TFnnp
	jtEJVz+uFijM5NZoUeKwHrVArvojdpI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223358;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUQvwLmTlji/bJ0Fu6NxTY+CyxNdQLCUrKCBR4Qtz8g=;
	b=0Dd2wYeWhplzIzzwvbwb/xik2WUaOxMU6mZAjfpV6BSt11rx9PE1OGEMLYJ0vlGUyc/zDK
	gOZ6fOOtM5nIObA79cnlT9jAxvlOgBoVAKqWDfSVEIOyqllhby6AnxUg23Yrs3bDjZjSYv
	SS5fML2YB/qg+OoFS/SXImKDADPOTk4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iS5n6k7R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43D09612FF;
	Sat, 21 Nov 2026 01:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10D21F000CA;
	Sat, 21 Nov 2026 01:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223356;
	bh=ZUQvwLmTlji/bJ0Fu6NxTY+CyxNdQLCUrKCBR4Qtz8g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iS5n6k7RgsLK3C+3X//Rnclg2fGxJ+m4s4+WvjH08tvjB3e6IKKI0QG/dNfUu5Y5L
	 gGy4rVLMArWJbfdocdDDmgZ646AvUwwwlx3uXAj5xDsIzM076+xy546eg+kG7u0u/K
	 AhhLqZDFtsNXgXQpqcono3nQcDBiBjBl/B3rC8Bw2OpMTh4u1Dc2LeevIE8NpSKHJh
	 ch7Cmmcva0wgFbKjfSaZ3JzJExgMhzBaT7T7d8qhR+dQ3APm6ROFJNomXxkee/uZJb
	 VZ/35DL4NXAMUHJRrv8WHt6bmQHSuArS/Mkz77ez9D903jrgVMzYQ0ae6zdPmVUXLe
	 yKfIbdEUqEJ/g==
Message-ID: <sashiko-outbox-226465@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 01/25] mm: Introduce CONFIG_PISA and metadata
 table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-2-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-2-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:14 +0000
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1ECF2120003
X-Stat-Signature: tw1n3hm6epzzopdx8hfqajww693yt31z
X-HE-Tag: 1795223357-906504
X-HE-Meta: U2FsdGVkX186X/LB6rAV1Ec+NaGdzgO+ET8z7gvrk5oYdPGfF8+ssNTmFyh69WKcTqCnaiuTpTooPeeMlM2+FhnIww6csIghnYk2fJf1x3D6J0gCsq4hmwasl3SfaMneed1oYZs8vjiibWpRaRUAyF8eOXNnLzP3+qu6R9hccz8pzLr6dJRuZxpPKGgduDDLgNmxd25XtU/YX6sLTqu8UtHSMBX6QoiRTcwluhASVDpId5zfNPnGGCXWCBH/+j7Z1eXAiZM2PJcIqeRgOxk60k14YE263u3pMihFUBFCK9uA5yMOpljZ7wFz8aryU9PtxbRdpMdih5EGDFTGF/YuS9sWkA4oMRbnRmahdjLSFF9UFr98K2cxt2FAyON3fPWm2Q0+Q3VXebE3CDj6rcQgqUlFqXbzPNy/BFb4jJtMjzqxPa9pSCfuxQbmPu7sS3uV6pqi1vATxkimfcx6BylBbZvjLZag7NaNjhZuaO+8VUNjUt8+aIT8Kc4tZcht0Wh117xvMqfaM5wADnZAqLVUOJc720Q7V+TwcursILc5+BtSNqRIesadtSdgjbIoSAunJYc0QMIH0gP9CmGGP9OfDUp5WTbdbCUJGzdX23OI4kkgyFhdT14tyCJJq4U9ccap3HhcJlGfq9ds9OCUxFh6FlarbWGltuXGtRg6ez9PiQH7i6Fluzh/lqpuI5KsvTfg0CxCe+KPKjq/s6CxgKSbKUUFBZ2v76zM2YaA3v5yelpFLdQsNSeU2CUf6Bt4B0o6t6/awqLDhh7T/ZyQMmiEpOxSootT+J4wALBc1wFN4dP3Za+hsbFJfSHmT2Pbjt6N/p1hs3Y7ywFUPLaUSWlNGVnQIEfHsF93JpgbDTMCPYYBOBKKX1tw99ZVnKjELqgcWgRi4ZrRoSVhDOS06wT4dEi7n8BBjEQGesdgYB+WXRpLCvz1ujHYekTaMI5Dq4Eqkibc7beRl4goq1OfS2T
 bAi8TlFM
 wGkNJND6D1eU57JuJ+rbxtbOKw3arQXBSkZttvFIBdo/JVhBY1D51Xe/734QoKASRSTaxf0dBSNsYVJ8Vqtb8WmOy2kFK4iRKvLLHvvJ6wwD+N7EvW9kX1P4Dpy41BKZgL8iqhxgHg7C6ax7MFr1iYVfASiWsHjQ8wmVlDdxE4A5tNratUk5WijfgyJpw8X8+N1w5rY7J+1jwYM+5S6rXT/vVx8ChegBI1BPE0ixuvXakoHqYlTN9CrAxkoF915o/RiTTo7l6Hy+B35DJZgjbirTcME/ZvK8VjuIJ/2hQKoHC7KjeSqODBtx835PiNQy1CtuB1dGIHWwJorLzNHet5F6LoP9TTexfotSSVmEzKuDjxiErcS6sO25zYdStkRWAIJ5jarrWDZwZi+fGaWjkqua4KsSW4/2TRIqIKFZLdxxl2jS7mVW0/D5ABWwuJD5aiUtnLU1ENlGk9Fi+QXa2V/end2zWvHijXPN6CFxOYXwPd7pAdsdVIHBwHZiX18ARYtOPfOjfydnLnhpUYGwKChl5gOINc0vCNLbEO+3kNwF4kotxdXuVYxytuXy/TN4O6A/9TDuCWIL23aJ1F1Pn/VOFRgN3lYGDleOJd8gPlbTRjnObUeotFxcU0F8OsTjEe5j15AYrTqdLJCg/MfPbmjHFIe+U7kQrQvK1XVgWk5HqETzSxMW+fCIMu2GmfQdO2otaWp6hKIElrzeR3c2ywccT1RckMGap2oARk4zNuKP6kOBsro0vcT8j3hUwx7LY5nK88yIzmE1jJ2rLPXFbxqEv+Hj0HpGTdARq+v3Yn6wEUay/K8ZdmDrySBPssHKBI7F4rEbXt56t+nMo/NkvFX45K/APH7V5xOWvUudnxS7b/okZ7Q+UqcLt6ofgiDHHq6jmAHzRgJ8Yae8QvrN20kI72fNzl5G7co6P926rzHah5AjJhcqTlH1uRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm: unmapped KMSAN vmalloc shadow in pisa_pfn2slot and
  pisa_meta_array
- [Medium] mm: freeing init_mm page tables in pisa_meta_init() without
  init_mm.mmap_lock
- [Low] mm: early pisa_enabled() return in pisa_meta_init() during
  jump_label_update()
--

commit e2c1da1898da520bb5d1c1e05212fb580b78c49f
Author: Luigi Rizzo <lrizzo@google.com>

mm: Introduce CONFIG_PISA and metadata table

This commit adds CONFIG_PISA, the two-level metadata tables
(pisa_pfn2slot and pisa_meta_array) with on-demand page table management
and memory hotplug support, and a built-in KUnit test suite.

> diff --git a/mm/pisa-meta.c b/mm/pisa-meta.c
> new file mode 100644
> index 0000000000000..734f49320047a
> --- /dev/null
> +++ b/mm/pisa-meta.c
> @@ -0,0 +1,603 @@

[ ... ]

> +static int pisa_pfn2slot_init_zero(unsigned long start)
> +{
> +	unsigned long end =3D start + PISA_PFN2SLOT_SIZE, addr;
> +	int ret =3D -ENOMEM;
> +
> +	for (addr =3D start; addr < end; addr +=3D PUD_SIZE) {
> +		pgd_t *pgd =3D pgd_offset_k(addr);
> +		p4d_t *p4d =3D p4d_alloc(&init_mm, pgd, addr);
> +		pud_t *pud =3D p4d ? pud_alloc(&init_mm, p4d, addr) : NULL;
> +
> +		if (!pud)
> +			goto undo;
> +		/* An earlier user of this vmalloc range may have left page tables. */
> +		if (!pud_none(pudp_get(pud)) && !pud_free_pmd_page(pud, addr)) {
> +			ret =3D -EBUSY;
> +			goto undo;
> +		}
> +		pud_populate(&init_mm, pud, pisa_zero_pmds);
> +	}
> +	return 0;

[ ... ]

> +static void pisa_pfn2slot_free(struct vm_struct *vm)
> +{
> +	unsigned long start =3D ALIGN((unsigned long)vm->addr, PUD_SIZE);
> +	unsigned long end =3D start + PISA_PFN2SLOT_SIZE;
> +
> +	for (unsigned long addr =3D start; addr < end; addr +=3D PUD_SIZE) {
> +		pgd_t *pgd =3D pgd_offset_k(addr);
> +		p4d_t *p4d =3D pgd_none(pgdp_get(pgd)) ? NULL : p4d_offset(pgd, addr);
> +		pud_t *pud =3D (!p4d || p4d_none(p4dp_get(p4d))) ? NULL : pud_offset(p=
4d, addr);
> +		pmd_t *pmds;
> +
> +		if (!pud || pud_none(pudp_get(pud)))
> +			continue;
> +		pmds =3D pud_pgtable(pudp_get(pud));
> +		pud_clear(pud);
> +		if (pmds =3D=3D pisa_zero_pmds)
> +			continue;
> +
> +		for (unsigned int i =3D 0; i < PTRS_PER_PMD; i++) {
> +			pte_t *ptes =3D (pte_t *)pmd_page_vaddr(pmdp_get(&pmds[i]));
> +
> +			if (ptes =3D=3D pisa_zero_ptes)
> +				continue;
> +			for (unsigned int j =3D 0; j < PTRS_PER_PTE; j++) {
> +				pte_t pte =3D ptep_get(&ptes[j]);
> +
> +				if (pte_write(pte))
> +					__free_page(pte_page(pte));
> +			}
> +			pte_free_kernel(&init_mm, ptes);
> +		}
> +		pmd_free(&init_mm, pmds);
> +	}
> +	free_vm_area(vm);
> +}

[Severity: Medium]
Can freeing lower-level init_mm page tables in pisa_pfn2slot_init_zero()
and pisa_pfn2slot_free() without holding init_mm.mmap_lock cause a
use-after-free during a concurrent ptdump walk?

ptdump_walk_pgd() walks init_mm page tables under
mmap_write_lock(&init_mm), and vmalloc paths such as vmap_try_huge_pud()
take mmap_read_lock(&init_mm) around pud_free_pmd_page().  Because
pisa_meta_init() runs at runtime without init_mm.mmap_lock, a concurrent
/sys/kernel/debug/page_tables/kernel read can race with table teardown:

CPU0                                  CPU1
ptdump_walk_pgd(&init_mm)             pisa_meta_init()
  mmap_write_lock(&init_mm)             pisa_pfn2slot_init_zero()
  walk_pud_level()                        pud_free_pmd_page(pud, addr)
    walk_pmd_level()                        pud_clear(pud)
                                            free_pte_table()
                                            pmd_free(&init_mm, pmd_table)
      walk_pte_level()  <-- use-after-free

The same race applies if pisa_meta_init() fails and pisa_pfn2slot_free()
frees private PMD and PTE tables via pte_free_kernel() and pmd_free().

[ ... ]

> +	/* Lazily back the PTE page covering this 16-slot chunk of @pisa_meta_a=
rray. */
> +	meta =3D &pisa_meta_array[slot];
> +	ptep =3D pisa_meta_pte((unsigned long)meta);
> +	if (pte_none(ptep_get(ptep))) {
> +		unsigned long addr =3D (unsigned long)meta & PAGE_MASK;
> +
> +		if (!new_page) {
> +			/* Allocate outside the lock, this opens a race so retry. */
> +			spin_unlock_irqrestore(&pisa_slot_lock, flags);
> +			new_page =3D alloc_pages_node(pfn_to_nid(pfn), gfp, 0);
> +			if (new_page)
> +				goto retry;
> +			return -ENOMEM;
> +		}
> +		set_pte_at(&init_mm, addr, ptep, pfn_pte(page_to_pfn(new_page), PAGE_K=
ERNEL));
> +		flush_cache_vmap(addr, addr + PAGE_SIZE);
> +		new_page =3D NULL;
> +	}
> +
> +	memset(meta, 0, sizeof(*meta));

[Severity: Medium]
Does accessing pisa_meta_array or pisa_pfn2slot fault on unmapped KMSAN
vmalloc shadow memory when CONFIG_KMSAN=3Dy?

pisa_meta_init() reserves pfn2slot_vm and meta_vm from the vmalloc range
via get_vm_area(), and pisa_pfn2slot_init_zero(),
pisa_pfn2slot_populate(), and pisa_meta_ensure_pfn() install page table
entries directly with pud_populate() and set_pte_at() instead of going
through vmap_pages_range_noflush() -> kmsan_vmap_pages_range_noflush().
Because CONFIG_PISA is enabled by default on x86_64 without depending on
!KMSAN, KMSAN-instrumented accesses such as memset(meta, 0, sizeof(*meta))
or reads from pisa_pfn2slot translate the vmalloc address into
KMSAN_VMALLOC_SHADOW_START / KMSAN_VMALLOC_ORIGIN_START, where no shadow
or origin pages are mapped, causing an unhandled page fault during the
built-in KUnit test at boot.

[ ... ]

> +/* Reserve @pisa_pfn2slot and @pisa_meta_array and populate page tables.=
 */
> +int pisa_meta_init(void)
> +{
> +	struct vm_struct *pfn2slot_vm, *meta_vm;
> +	unsigned long meta_size;
> +	unsigned long *bitmap;
> +	struct pisa_meta *meta;
> +	u32 *pfn2slot;
> +	static int pisa_init_err;
> +	int ret =3D 0;
> +
> +	if (pisa_enabled())
> +		return 0;
> +
> +	mutex_lock(&pisa_meta_mutex);
> +	if (pisa_init_err) {
> +		/* A previous init attempt failed. */
> +		mutex_unlock(&pisa_meta_mutex);
> +		return pisa_init_err;
> +	}
> +	if (pisa_pfn2slot) {
> +		/* The previous caller completed init while we waited on the mutex. */
> +		mutex_unlock(&pisa_meta_mutex);
> +		goto out_enable;
> +	}

[ ... ]

> +	pr_info("pisa: %lu GB pfn2slot KVA, %u slots (%lu KB meta KVA)\n",
> +		PISA_PFN2SLOT_SIZE >> 30, pisa_nr_slots, meta_size >> 10);
> +	mutex_unlock(&pisa_meta_mutex);
> +out_enable:
> +	static_branch_enable(&pisa_key);
> +	return 0;

[Severity: Low]
Can a concurrent caller of pisa_meta_init() return 0 from the early
pisa_enabled() check while static_branch_enable(&pisa_key) is still
patching other jump sites?

jump_label_update() patches jump entries one by one before setting
key->enabled to 1:

CPU0                                  CPU1
pisa_meta_init()
  ...
  mutex_unlock(&pisa_meta_mutex)
  static_branch_enable(&pisa_key)
    jump_label_update()
      /* patches pisa_meta_init() site */
                                      pisa_meta_init()
                                        if (pisa_enabled())
                                          return 0;
                                      pisa_meta_ensure_pfn()
                                        if (!pisa_enabled())
                                          return -ERANGE;  <-- unpatched si=
te
      /* patches pisa_meta_ensure_pfn() site */

Testing static_key_enabled(&pisa_key) for the fast path in
pisa_meta_init() would wait until jump_label_update() finishes patching
all call sites before returning early.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D1

