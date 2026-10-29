Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83586606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O+9sPb3f
Received: by kanga.kvack.org (Postfix)
	id A33876B05B2; Thu, 29 Oct 2026 16:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B3C6B05B3; Thu, 29 Oct 2026 16:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9249C6B05B4; Thu, 29 Oct 2026 16:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 630C16B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:16:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F23A01C3AD1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:16:41 +0000 (UTC)
X-FDA: 85376771802.27.2CAA6BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 495F6A000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:16:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+9sPb3f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793305000;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KH5tlWQ/a/2Qjgu8uulzrQfDKvIAF8TNZYluLjZyVHQ=;
	b=FZNmIJxcnjKQiYR8IsatUC73gQkTf7WpXAhWotzQhSNEe72DOVnxc5GI648naH+wXvEuM/
	5limiF73CWLjPFe59MFzJp6PZ+roYQyu+r35wvgUJrKi3NP6GvqE7o+q9b741TTEyv1F3j
	UIXdJT0mtspS//bYHaAtghSk0ljPAKg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+9sPb3f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793305000;
	b=Wu7sqofv5NhMRDie5q5uDhMQf8e0RZHsdrf2Z8vobCs3BVUTXzhy8p+5DofAkADATPMWu5
	k7LZY3TPbTXwlI7QltGUYf/42fDVPb+SiF2octrNmiwX3ezEqniJp2I/hU+seARahoIgLK
	O1nYE73CJCNBW+1l5bHT7wFdqtRyn18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50B8641622;
	Thu, 29 Oct 2026 20:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EA31F01824;
	Thu, 29 Oct 2026 20:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793304999;
	bh=KH5tlWQ/a/2Qjgu8uulzrQfDKvIAF8TNZYluLjZyVHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O+9sPb3f7yAtRAyhhCNGswCMWiCYDVQL4n8UUKxe1WRm/wsE5VtYsSBFghyAadl8m
	 d+5FxKOS+U6sSVWx7EMPqSqLor99ZnqzQU6HU0s7e0nk2xFBgdv16Li+jUVZKyZitf
	 Tx3+QgDMuHHJ5q3rGwjVVfV24ACUwm2+XfTUu9xG2X2ZCmdq2Xyak42LYjat2y192n
	 tUuaCAlodVI2XdQbDMW+ekmLf8IguGSsh6il0wWHhyYwH0hPqqGfxQzZrGvQRKRL5T
	 5CoWb/6xfta/g48few6SxzPuPWD43jJfxh2berx/ezg/MAR9z5eeuwZh2y678lcqWz
	 6DELTiWg7tatA==
Message-ID: <sashiko-outbox-189914@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/15] RFC: mm/hugetlb: account restored reservations
 before freeing folios
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Mel
 Gorman" <mgorman@suse.de>, "Andy Whitcroft" <apw@canonical.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Michal Hocko" <mhocko@suse.com>, "Rik van
 Riel" <riel@surriel.com>, "Hugh Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Vivek
 Kasireddy" <vivek.kasireddy@intel.com>, "Dave Airlie" <airlied@redhat.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Peter Xu" <peterx@redhat.com>, "Breno
 Leitao" <leitao@debian.org>, "Will Deacon" <will@kernel.org>, "Aneesh Kumar
 K.V" <aneesh.kumar@kernel.org>, "Nick Piggin" <npiggin@gmail.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Arnd
 Bergmann" <arnd@arndb.de>
Cc: linux-mm@kvack.org, "Gerd Hoffmann" <kraxel@redhat.com>, linux-s390@vger.kernel.org, "Josef
 Bacik" <josef@toxicpanda.com>
In-Reply-To: <20261028-fixes_hugetlb-v1-14-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-14-a0a033db180f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 20:16:37 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 495F6A000C
X-Stat-Signature: m8srqzrjk4uqroxw9j6bwre1j855xx6j
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793305000-682136
X-HE-Meta: U2FsdGVkX199kyBHG5TYwltb5ZJ/19Obsdv5LBKZazru0SpxU4EB0wR0Vqjwlxx2svv8W5CPzlZz/EO1lZlE1dIu3+zG9syn5l18WYbDaKNAdeZrglaF7Z05+e471k4yey6gK7EDXENsMwC0XKN1FvHIMLeOCZ2J4dHoMXKs4B6FqYFKaHaL2BV1uU69SxHGhc7XmHzfmUhbh8zGuniTgzYJjD10gMk2J+mWgcdpJgFTfRvMFv/Xr7yG0hz0YAO3KLionbSWY1HZ4ktaRVLCLmvAjDHCQh8VUnpNZZaAJUq0QtEeiK/4vJZ+PouFFl6wxAwkyUX143y40OALf7CloIU80Bawk4zlPRfSqrACgd95hKgG0lC4qvZk9LB7TjC1Y/J/CDWz7yWyxeivXiBJTHTiynvQEoiljJ7qVp3dmGE7S/JuGU02J8TfllKj7a8M3EZF03I/VUR0tJ0i4/GSDnngFmisvo9E8WSevlQbqXpCAsbP62pY3BuTFP8c5lz8o7aM6t7yy2R3QnwdxCQ+PsBCDO7sTGjgIH8cMOIl3+5fvlLcnkU0FPPaTEs572QSomCISsV0IR0wOiJ1whcjHUXhQgQPXaFamRs63Gx68W+6zeBXHG1rW0cMt1Yhrt3FTki4vMIJQrlYUv51PevmOOnDgRefcxfUWA64QBKB6uZ9lmGLGmCZ/DHcFqdXt+kbplNQaWChluWoBLGG1lC/g7dlCVxmyGyqbrj4pKOUgM7o56OAbwiVJtyuK//f4otk3vvssR+VgiFlxVCGpp3Jn17xC6x6iOL9dYDAT3t4LLwxuYiaXudiHxONZi/8LHFd6Z2h5tisAS7bNI+lKXuFPr32fttxOqpJDNzs4Ta2N0lyOb7SL7njqcLTinH2nMqIqnRVm03/qZERkQE4qZ4IMhMVgvJMhioxGO5tiX7KFflqw0WbrPQn86kMUmYKRbLOlqie12JPNsxePpIEQuu
 vqQxoxng
 IQsfAG0dxOOChDYC2F6v8SK8w+rO7XsbyHHEmE45132LP3fmsvGBgS6cxO0zSVjO8zSvGcDuPuF7IjPpErN59R/y6cciq43FmU+xDSdQPeJfnDNHxwgH/bPlp6YBRLHGAzgTShJk/nHB1uET5MwEvhvsklr816aECPR9ber2wtXNVOfH/s147rnmkf9JxVNgmM1LlhuQDguJeqIGBqfmT2v2z0FfMPzhlTlGLmssLPchDICAiU3X79VTjOpFyYEdWyXgVeyOSdY6h71Mfrc87H8fyeIW+xw0DUA7EY13BWPAS7nPlC9RJP86l7vdGqL2NQaesSiQIxfwIGuuWUwDaRp9PHFGYfIkeGhZYwsL8XRWOUCcHN+v5K5D0n8+OMePJDahS7PFW51AmIcYE938sPQ/iRgtL+S1NTcRpsy7UrD3zb7lenYohu7w9ncVqjYHowlTcSiPECEgT7tucdH0pIEkWPkSF6V8YhrLJmatGlfTko109QywLvjJuBXZeIyCdkqzqaFRIJFhMFt99LP77Vw8UFLxVe3gdstMPEu5gMqzaF/vrGfAv8vc/z0o2tMz62yTnLVEBm7iqAMhAyk/oqVPNTemnB9madcd3UHYjbfbyps0q5EZxo1kBoovg6zgFEKgMfEa0IUG8PhLP6A0KMugd8MVP6cLbdPSLOTSB+OQnaHVddYUzibaSG0kNlGPd/tYb4XCe1uPnhO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm/hugetlb: gather_surplus_pages() over-allocates and retains surp=
lus folios
--

commit d5256483029a06972dd519de19de57831de33af4
Author: David Hildenbrand (Arm) <david@kernel.org>

RFC: mm/hugetlb: account restored reservations before freeing folios

This commit updates anonymous hugetlb folio unmapping to increment
resv_huge_pages immediately when restoring the VMA reservation rather than
waiting for the folio to be freed. Because resv_huge_pages can now
temporarily exceed free_huge_pages while unmapped folios still have
elevated reference counts, available_huge_pages() is updated to clamp at
zero.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 69a5d2c73ee1d..06ef8ba41df7c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
[ ... ]
> @@ -5313,6 +5309,45 @@ int move_hugetlb_page_tables(struct vm_area_struct=
 *vma,
>  	return len + old_addr - old_end;
>  }
> =20
> +/* Must be called after rmap removal. */
> +static void hugetlb_folio_restore_rsv_on_unmap(struct vm_area_struct *vm=
a,
> +		struct folio *folio)
> +{
> +	struct hstate *h =3D hstate_vma(vma);
> +	unsigned long address;
> +	long rc;
> +
> +	/*
> +	 * Restore only on the last unmap, otherwise the owner could reuse
> +	 * the reservation while the folio is still mapped by a child.
> +	 *
> +	 * TODO: Handle migration temporarily dropping the mapcount to zero.
> +	 * TODO: Prevent reservation reuse before the folio is freed.
> +	 */
> +	if (!folio_test_anon(folio) || !__vma_private_lock(vma) ||
> +	    folio_mapped(folio))
> +		return;
> +
> +	address =3D vma_anon_address(vma, folio->index, 1);
> +	rc =3D vma_needs_reservation(h, vma, address);
> +	if (!rc)
> +		vma_end_reservation(h, vma, address);
> +	if (rc <=3D 0)
> +		return;
> +
> +	rc =3D vma_add_reservation(h, vma, address);
> +	if (rc < 0)
> +		return;
> +
> +	/* The restored reservation owns the subpool charge. */
> +	hugetlb_set_folio_subpool(folio, NULL);
> +
> +	/* Account before the VMA can close or fault again. */
> +	spin_lock_irq(&hugetlb_lock);
> +	h->resv_huge_pages++;
> +	spin_unlock_irq(&hugetlb_lock);
> +}

[Severity: High]
With h->resv_huge_pages now able to exceed h->free_huge_pages while an
unmapped folio is still referenced (for example, via vmsplice() or GUP),
can a concurrent hugetlb_acct_memory() -> gather_surplus_pages() over-alloc=
ate
surplus folios and retain them in the pool?

In surplus_pages_needed():

	static long surplus_pages_needed(struct hstate *h, long delta, long alloca=
ted)
	{
		long global_free =3D (long)h->free_huge_pages + allocated;
		long allowed_free =3D (long)allowed_mems_nr(h) + allocated;

		return max((long)h->resv_huge_pages + delta - global_free,
			   delta - allowed_free);
	}

When h->resv_huge_pages > h->free_huge_pages, (long)h->resv_huge_pages +
delta - global_free includes the deficit from the in-flight unmapped
folios on top of delta.

If gather_surplus_pages() succeeds, needed +=3D allocated equals delta +
(h->resv_huge_pages - h->free_huge_pages), so it allocates and enqueues
extra surplus folios beyond delta (or fails with -ENOMEM if
nr_overcommit_huge_pages only had room for delta).

Furthermore, when gather_surplus_pages() cleans up unused or aborted
folios at the free label:

	free:
		spin_unlock_irq(&hugetlb_lock);

		/*
		 * Free unnecessary surplus pages to the buddy allocator.
		 * Pages have no ref count, call free_huge_folio directly.
		 */
		list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
			free_huge_folio(folio);

free_huge_folio() checks:

	} else if (h->surplus_huge_pages_node[nid] &&
		   h->free_huge_pages >=3D h->resv_huge_pages) {
		/* Free this surplus folio that is not required globally. */
		remove_hugetlb_folio(h, folio, true);
		spin_unlock_irqrestore(&hugetlb_lock, flags);
		update_and_free_hugetlb_folio(h, folio, true);
	} else {
		arch_clear_hugetlb_flags(folio);
		enqueue_hugetlb_folio(h, folio);
		spin_unlock_irqrestore(&hugetlb_lock, flags);
	}

While h->free_huge_pages < h->resv_huge_pages, free_huge_folio() will
enqueue the aborted surplus folios into the hugetlb pool instead of
returning them to the buddy allocator. If the in-flight unmapped folio is
a persistent folio on node A (where surplus_huge_pages_node[nid_A] =3D=3D 0)
and the surplus folio was allocated on node B, dropping the last reference
to the persistent folio on node A will not free the surplus folio on
node B either, leaving the surplus folio stranded in the pool.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028-fixes_huge=
tlb-v1-0-a0a033db180f@kernel.org?part=3D14

