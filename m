Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E72606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 08:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AJoVAlvT
Received: by kanga.kvack.org (Postfix)
	id 4ECE96B05B0; Sat, 21 Nov 2026 03:59:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4866B05B1; Sat, 21 Nov 2026 03:59:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2CA6B05B3; Sat, 21 Nov 2026 03:59:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 082826B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 03:59:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 811C5A7E4B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:59:07 +0000 (UTC)
X-FDA: 85458526734.05.8067FB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E783C40006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:59:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJoVAlvT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795251546;
	b=4tJPCzAmgKAzpZMJ8rJ6Eoecq5hXnIDPsk4OkBISUzZxoL7BDh9ENq1g0W7h/CqZ9PPLRz
	vyYrcR9Wdw1x8u5H+bBZljmquCrvLDjPtfYdCanO/M9PG2J2zn5MyEMXBpxnxGkSb+bFon
	zYWoDHrQfesC4YgQPkSqrYqaqeZHuAU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795251546;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VgRKjLcd5GVmjXCRxYj/EylGAWkqUH1XmlELtVJm6M=;
	b=Y9fJg7ra8wUcUqVoGLZXp84iUxvztoDtQZJgz1UZfT5ZAFTxt9eFX486L+rK1T0QL0WJ+/
	P5+RcEBoSsi2+uI4/RCA0ptRu7lWygIloDPu4OntKbIjaFSwA7Kf8MVNpCU0KnjsAX3BES
	ELEhrTtGp4UbOCIYTYMK+F5CNF0YNsc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJoVAlvT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E63160E07;
	Sat, 21 Nov 2026 08:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FFA1F000C0;
	Sat, 21 Nov 2026 08:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795251544;
	bh=5VgRKjLcd5GVmjXCRxYj/EylGAWkqUH1XmlELtVJm6M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AJoVAlvTfQ4Hq3MYZMpy7l3OgLmfmEQz8Tgz3w9KM9xR0nx3voCGiCBWtX+QeIB/n
	 ydXEiN4fZ+LYdiCXgphCunwZ2WZhjCZud7Qap/PKXqkVXBB/qkxLIfXY7q8ApkzWeq
	 45o13vSXjZF4UXEfyGkMDLGhn+DWtqxl7xbtaU/edc++F8NsgZfw1IIPS7eomG4yV2
	 DNTgnAU1aUgDoks3JvWO90TLyAuvA9UyckQ2/+iKsk/fJ8s1khWACWtIqjKtZPbicY
	 6ekWVVlIKKMCxzXs56qkk7bZ2uJfz0no8q7S/ssNAJnjsgD5ywKBapV7+xyXRUq9cH
	 pRo46KMwz5MCA==
Message-ID: <sashiko-outbox-226850@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] mm/mglru: skip cold PUD subtrees during aging
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baolin.wang@linux.alibaba.com, "Baoquan
 He" <hebaoquan@kylinos.cn>, "Kairui Song" <ryncsn@gmail.com>
In-Reply-To: <20261120085806.781225-4-baoquan.he@linux.dev>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
 <20261120085806.781225-4-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 08:59:03 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E783C40006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: fhumzajggedrctxbdef68ne5b6ncerit
X-Rspam-User:
X-HE-Tag: 1795251545-247962
X-HE-Meta: U2FsdGVkX199svX4CQK+w+OvvzdBzZo6rK8zIHi1v3MXSsvRxyHuC/k/BlZVNcdss1QUY6PiV1AoIfEHX86/D17lLmVrJgnkvCl4b79E+sswrGpFLprPbLo5rq2gIB3/4DV0uWLmrfZHBdfoYDB/g/5d1TcvtUPvoKfdM9pKmPKHT+USm7svYefDwQ26aX94KibYzyRAwZiMqidO4If2ZyvKiEXE4aRL3lb7psWtaqFXssgH9Yu5RZCkiv/kOsC+h5LJKwJAh5ZOliWC5ufF3sSzSQJm2dP/lkroo+hNPCffjnWliTin/nN5n9yKH5LIAC8u5F/CgqHburePeX3aCmz/Jc+mYix4pUJHysQfO8KlqDoWHwfbW0iX9Xud1iqIlE6X5+J88br6gs1sKQoRpDRQU1LcXh8C9/Kw8nxA18kyIwZa6WNq3Av3VcHLmttSUcksovT36eNBRLvUFsA1k19pmLJ1ut8ny5rz6ahT/hkomzq8i8Ipg04JiKcMLylk+WFIYUrVNcAd/GwZmE6xWnckaI3eBPoOYcn4hcjGKMgJXRoACEdQs3v4kOzFFeUgFfkKeThmAuQyN5MeeTxg9+e7moNCH7ullnm0dusALh+lVPAv1SvuIiWtmHQvW9mXeu3LKteVofK96IGVYrqEIOZNK0+kSuLu2yCBprZYzdhifxF+/PjAkQIEw0HnTnflAswhXkjYDGndP8XFR1aCjqSbxLoc0J9LE11lXjkHQ9J5spMQfEZdvF1f1e/6Va82OLXSf8OqeNStQmksnPbD4YPVAbc/wDFb5vEKd/X2aYM2K+VSA0Fqphpqq3p3UILYt/KvXjUo5+6KhULnhECFd9sAqqAE4z6kv0mn4Vz4HLsGFkRXe1aXx9LPM42teuVzTEdps4adM1unRC2qaY3LOI4VRMroWHGNrOOADXgs421M3Xwzn6qAJa73CQ1tcgOSVV63q9GnUrlc8x6bOIy
 rEXDS6/V
 ii5epdz8vQr24aImUUmFhnp+hqn1IGQN6LvhhA5/LNxhkdrVkUQzTcjhWS09YIJ6Q9oK6fHfRdalGOKPxp9Y2SZ+SvdYTQ8K25vX3kJFrMOpCfmOGQ9PaERs0qQCH+ysPxZPn9KsGuq15IIcvHtIgsHhrTAXyor4xNToph5C4GrhjEsg4piI8RGsbY4WDbp94UK+cWtHlRn0jNInYJstnNGRTWnGdNXHFhQxOmqymXW8sYipcQ41H4ZWmwnsiuW2PXgRhOWbXP7a3AkTuQQQIhM2NV4O4YPDtilurw5wxLZOnCNkAQsCG3VMn5zkIpQhaguAqi6+iYjNcbqSrumHSWeHOJMxsSEbjc4C4p/B2v7YvUDUdcXITIaLmGPYOE7VAKD8kPu1Rmjo/qSDt9akIyP/qmS50uTwe3PiHsXixGBDrtYl5cIrmqVOq1ktzhdCrv+v1JTg/M1J+Sf0cPDFHm6oeZ3aGeyZoO4YJlxQO6DTcW/qM+DTsOTzdaIrFdY3x1dUAoXUjKv2gkihF+926P/1k5QPmoyMYJC8DOfG6reyj8SEpH1Klx7MGL017vojReesOkDMS5jLAgsyQmY3YGXATG696aNrSKQn1gsW19mvcKLuq+wWX8Z0mQWeJtguEXNq1fp6YdPRD7hy4s+LGpFFTEwfFcHAK5a6URsGJunMdL6ziKNAvmh9Rqrz1xqArSADCxHZ3BNxDxzWKFGk6XhPz9/LiE5mlGItUy71QeVbGtdZ0SohK4olekKdysSsGHDHnv/o12fBHbN8RYaCXwvEPJHgPgmw2GE6U
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
- [Medium] mm/mglru: walk_pmd_range() drops young status of THPs flushed
  at non-leaf PMD
--

commit 807f1bc14298f872f3bf880156eb7f9c34a7f570
Author: Baoquan He <hebaoquan@kylinos.cn>

mm/mglru: skip cold PUD subtrees during aging

This commit introduces a PUD-level Bloom filter to MGLRU page table aging
to skip 1 GiB PUD subtrees that had no young pages in the previous
generation, while updating the filter from the page table walk and rmap
feedback paths.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a4c64a1903912..2cd3f28f74288 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[ ... ]
> @@ -3626,11 +3637,12 @@ static bool walk_pte_range(pmd_t *pmd, unsigned l=
ong start, unsigned long end,
>  	return suitable_to_scan(total, young);
>  }
> =20
> -static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct=
 vm_area_struct *vma,
> +static bool walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct=
 vm_area_struct *vma,
>  				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
>  {
>  	int i;
>  	bool dirty;
> +	bool young =3D false;
>  	pmd_t *pmd;
>  	spinlock_t *ptl;
>  	struct folio *last =3D NULL;
> @@ -3644,13 +3656,13 @@ static void walk_pmd_range_locked(pud_t *pud, uns=
igned long addr, struct vm_area
>  	if (*first =3D=3D -1) {
>  		*first =3D addr;
>  		bitmap_zero(bitmap, MIN_LRU_BATCH);
> -		return;
> +		return false;
>  	}
> =20
>  	i =3D addr =3D=3D -1 ? 0 : pmd_index(addr) - pmd_index(*first);
>  	if (i && i <=3D MIN_LRU_BATCH) {
>  		__set_bit(i - 1, bitmap);
> -		return;
> +		return false;
>  	}
[ ... ]
> @@ -3755,7 +3771,8 @@ static void walk_pmd_range(pud_t *pud, unsigned lon=
g start, unsigned long end,
>  			walk->mm_stats[MM_LEAF_TOTAL]++;
> =20
>  			if (pfn !=3D -1)
> -				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> +				young |=3D walk_pmd_range_locked(pud, addr, vma, args,
> +							       bitmap, &first);
>  			continue;
>  		}
> =20
> @@ -3777,15 +3794,18 @@ static void walk_pmd_range(pud_t *pud, unsigned l=
ong start, unsigned long end,
>  			continue;
> =20
>  		walk->mm_stats[MM_NONLEAF_ADDED]++;
> +		young =3D true;
> =20
>  		/* carry over to the next generation */
>  		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i=
);
>  	}
> =20
> -	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
> +	young |=3D walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);

[Severity: Medium]
Can walk_pmd_range() drop the young return value when batched transparent
huge pages are flushed at a non-leaf PMD?

mm/vmscan.c:walk_pmd_range() {
    ...
		if (!walk->force_scan && should_clear_pmd_young() &&
		    !mm_has_notifiers(args->mm)) {
			if (!pmd_young(val))
				continue;

			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
		}
    ...
}

walk_pmd_range_locked() buffers up to 1 + MIN_LRU_BATCH entries in first
and bitmap across loop iterations, returning false while buffering.  If
earlier iterations queued PMD-mapped THPs and this non-leaf PMD call lies
more than MIN_LRU_BATCH entries past first, it flushes those THPs and
resets first to -1, but its return value is ignored.  If no later PMD in
the PUD sets young, walk_pmd_range() returns false and walk_pud_range()
leaves the PUD out of BLOOM_FILTER_PUD, skipping the 1 GiB subtree on the
next aging pass.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120085806.7812=
25-1-baoquan.he@linux.dev?part=3D3

