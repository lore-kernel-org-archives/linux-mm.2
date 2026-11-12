Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8F6606A334
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jN/JIfZ7
Received: by kanga.kvack.org (Postfix)
	id E323A6B05B6; Thu, 12 Nov 2026 09:07:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09916B05B7; Thu, 12 Nov 2026 09:07:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46916B05B8; Thu, 12 Nov 2026 09:07:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B10816B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:07:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48574C05E9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:07:46 +0000 (UTC)
X-FDA: 85426645332.04.E73225E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 96C632000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:07:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jN/JIfZ7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794492464;
	b=cmK0eNzi8XhbIZ+xwMDfVFCnn+hAgJ+4yuM9EqzONV2Rs4HUyyujqZIC3puKVsV66e+O3l
	2nhqoCSdfjhPqvZWtoW/ZXk4cTjTOViOO1JS0TRUAc47I/d5tFBZsU4WwlwMeK6UKuYEbw
	dto/pjmj8vJiVkIBtly7JCYGaWt4wzg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794492464;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xz9PU9PMLrFr8ET01Qwe+PL/JTwp79ZzBWS/1CEhXCY=;
	b=7AjIsm8khF4cfEmO4wdaH8l4RDUHPkZRgRhRyvSPrGJmdbI3OGWBS38UwsYbRVmPi/wBrJ
	egjzl9izbfRiYuM7ZUI9dJhAHRk5MIRXBJywGiVtkxndBOQ1oqK85OPRdcE1GytdF7r3Ef
	e3QCgL0CrGxMILLAg7t2dxlI6RXq87g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jN/JIfZ7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5E4140695;
	Thu, 12 Nov 2026 14:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989661F00A05;
	Thu, 12 Nov 2026 14:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794492463;
	bh=xz9PU9PMLrFr8ET01Qwe+PL/JTwp79ZzBWS/1CEhXCY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jN/JIfZ7BRxEbHAO5f3tY3RgyXYn3oLhDS4jgBPgU+cqETIiYwKTcZLZhn2YwcF3V
	 jaxcyJxALghtDVeJrZKzQnOGhbVUzxteGX5z4a0pbFGZNX1BBsjBj6s0JR+6fhgZ1m
	 amp/vNfJWF7dZuva/Fna8okYE8KXsRabftIMtLoRjs4usWyaz/Ef2/C3vMjUvg6hdj
	 gaibqQVrooLke3N7OfjFZ/Xgzax6vn2Qf34xqXOaIX7iHFnqzjRSBtaP8u/4r/g9wK
	 hQx06SH6btKPVYBXnX1Arxk0zyDo6uGz0d6Hhmkh9/jJP/1nC3jn9OvadSPA1EQPWF
	 Cg2NzElu+2SBQ==
Message-ID: <sashiko-outbox-211264@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] mm: don't report OOM when a huge PMD race blocks a
 pfn insert
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eliav Farber" <farbere@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "William Kucharski" <william.kucharski@linux.dev>, "Vishal
 Moola" <vishal.moola@gmail.com>, "Alex Williamson" <alex@shazbot.org>, "Peter
 Xu" <peterx@redhat.com>, linux-mm@kvack.org
In-Reply-To: <20261111140655.34281-3-farbere@amazon.com>
References: <20261111140655.34281-1-farbere@amazon.com>
 <20261111140655.34281-3-farbere@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 14:07:42 +0000
X-Rspamd-Queue-Id: 96C632000C
X-Rspamd-Server: rspam12
X-Stat-Signature: f8tpqzyku1fu71jjej3hjh1fi6341soz
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794492464-220599
X-HE-Meta: U2FsdGVkX1+KrYEmqWshVHOlhgG/JL99C6BzJ4bklxqFbx7pWX7TnMeVu1JaJVnHKQBD7Z7J4I71kGF07qlwUy19509eHvdEiO8AJe816v6y40U6WMknM4xwqM3T0TZztMXFNxCm4n35tJ0M2+NlgIK4q7ZtOqbg9/0R64YJY3QW2EYAbTjTQCvB0BvZDBSwdCWhdeLFxSf+oA4RqI/r6N/olDPEPblp4JJxF83wLAAaWB1gmPpUWwd7wXPiNwuonosCzxKG+AaDe92gmPu20c0WHWRK3qIESMDaduFgwevrKVSQTsGeqZop+PBFLinZt0ixCjUiupyxARhFiw7JxGCvp4XTXVd2N2GW8gK/azFs+SoS7IVHo4ek+rphPOZzyQ0ymLqAsLWXWjuD9XvnNY6QLappFY89Pih9uTR9T4vDtCDpp2eEKsbRy+5slVtD3Vo8ZaztVJawS4EXu2cZ/tHT7bHW8Bz12cDfUoERDFR7UG/Jq0Aq6ugc6PG6KpIFY7oMxpx1q0j0WVRSd5yOxjhfMiS+PIDs2dulMWNS5uFu8Gi/LHLHYtkR9aY1FaPnYjlZpVCsjiIsAcc3gUYrpfBA1v3lGg+qaGaD9ewi4bq/lTZOZvTUuVal0sWtZAl7lHzdAnE+IQ3xIJSqy6zJkTiXKa8Rh9N6VhtMwqgUBQOBLlOStNxqYQFOpAgMjvHBk9X/igSwJI6w9Zt5LCx1PNfxgPqKWHqbVnwh+JBqU5NwKYG1Z9TxUISMgZ+4K7semvVtAM71QpBKLeDq8GGFJ6YLCCYv4NxIMpK2RvbkolNnOx9qY/hp6BQoqTLSSgjjQ22rvBDySSrGmC92wXUZTLAIFjgboPYne4s5/ryBf1Q20BokuUBpW2c7nVtOD2PP/pHHfgnAMR1j7I4tpW/UQQ4TQI6NP8snj7LmmVFx09thSW/wfXMsVL4/TZ3DLdNdjXGfpYDMqGa3bgSX8eM
 vajr6EcW
 YpgRfsWZG4/4QdxWEqh6kuS0Jm3E1IcquLldVnwekT3exl7n7PVikciIHUyrShLGJayuESCDrmCULXQQUnosEWYnMDsjz933MEFE8i+u7YWRWvpXh6J1MrggmWp+TZIa3JIdO+OBj81m6EejRJh9TZrQc0E0RU4ZIPinPXhtfTpB+Z1c/HG/V+JQJezN3FpG33Jvy+GFBAlXmf0lEV1eqV0n1ZKyh8nkHbikCNhPtGqR5P/luRvVGSsWAdfhoBnEKbPaKaRmDCIqeopoIlZhuEoGBt/fuoto5dzEWj5TAyutYd9IbgS371IE/+fwLcbC+PSTjTs0OvYHHr/EdgEyWB4jRYRBW8ukXVjrfAUYLP6XfREzlVsiZhONA9C8OF9SuGqoK6Bebz3YRn3euTkL4CY2fmXm0rcM1P8aNQNv2olvXy4yZCYDRuywgBXU4+kddK8YIhhcNOB2Tm+mqRlwRIvEL0Mic4CLEzSRv01hp9TjcaY+nphgk6tV5YDLVQ4EsUOB374nA/ZkITNyS6eLx6kM9FHpe2dh+2uD7UXg4u8fVlR6OLf0CErT5l/BUlLF5iwgMRyTTbmjJxM4xzLnKmdA9JXZY0v+s+4T7Nnw3m9eOlefUJhooXlnMIDnPfXUdcyUsinoF8FZySkqXQ0vfZ3olDb3JbvsWDfTWnQoRTH6GPw5yJVHk3yl0fVtULjOjwC9p6kwoA+pKiB8KQx/9datj9EK7w+ciql/1CeMVHlAcp562cGupLVKAvpkLVgD8B/gTy2SL1J30PDdXdN9znUfbBGHH1p+EVrxXqlzgxBx/OliZ8PwlaKeUsWBQZz5RNkcK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: spurious VM_FAULT_OOM in insert_pfn() on concurrent PMD
  zap or split
--

commit 0ac526524e0ffcc35b96005d118a4d79edeae689
Author: Eliav Farber <farbere@amazon.com>

mm: don't report OOM when a huge PMD race blocks a pfn insert

This commit updates insert_pfn() to walk to the PMD and check for a
concurrently installed huge PMD leaf when pte_alloc_map_lock() returns NULL,
returning VM_FAULT_NOPAGE instead of VM_FAULT_OOM.

> diff --git a/mm/memory.c b/mm/memory.c
> index 09ae7e21ff0f5..509a984f17f8f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2803,10 +2803,25 @@ static vm_fault_t insert_pfn(struct vm_area_struc=
t *vma, unsigned long addr,
>  	struct mm_struct *mm =3D vma->vm_mm;
>  	pte_t *pte, entry;
>  	spinlock_t *ptl;
> +	pmd_t *pmd;
> =20
> -	pte =3D get_locked_pte(mm, addr, &ptl);
> -	if (!pte)
> +	pmd =3D walk_to_pmd(mm, addr);
> +	if (!pmd)
> +		return VM_FAULT_OOM;
> +
> +	pte =3D pte_alloc_map_lock(mm, pmd, addr, &ptl);
> +	if (!pte) {
> +		/*
> +		 * A concurrent ->huge_fault may have installed a PMD leaf over
> +		 * addr, which pte_offset_map_lock() refuses to walk. The
> +		 * mapping is fine, so let the access refault instead of
> +		 * reporting a failed allocation.
> +		 */
> +		if (pmd_trans_huge(pmdp_get_lockless(pmd)))
> +			return VM_FAULT_NOPAGE;
>  		return VM_FAULT_OOM;
> +	}

[Severity: Medium]
Can this still return a spurious VM_FAULT_OOM if the huge PMD leaf is split
or zapped before pmdp_get_lockless() re-reads it?

CPU0                              CPU1
insert_pfn()
  pte_alloc_map_lock()
    pte_alloc() -> 0
                                  unmap_mapping_range()
                                    ...
                                      zap_huge_pmd()
                                        pmdp_huge_get_and_clear_full()
    pte_offset_map_lock() -> NULL
  pmd_trans_huge(pmdp_get_lockless(pmd)) -> false
  return VM_FAULT_OOM;            <-- spurious OOM

pte_alloc_map_lock() expands to pte_alloc() followed by
pte_offset_map_lock().  Only pte_alloc() allocates memory and can fail with
OOM; pte_offset_map_lock() never allocates and returns NULL whenever the PMD
is a leaf or pmd_none().  If a concurrent huge PMD is cleared back to
pmd_none() (for example by unmap_mapping_range() or __split_huge_pmd())
after pte_alloc() sees !pmd_none() and before pmdp_get_lockless(pmd) runs,
pmd_trans_huge() is false and insert_pfn() triggers the OOM killer even
though no allocation failed.

Calling pte_alloc(mm, pmd) first (returning VM_FAULT_OOM on failure) and
then pte_offset_map_lock(mm, pmd, addr, &ptl) (returning VM_FAULT_NOPAGE
when NULL), as do_anonymous_page() and finish_fault() do, avoids re-reading
*pmd.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111140655.3428=
1-1-farbere@amazon.com?part=3D2

