Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CB3606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LZ4TBU4E
Received: by kanga.kvack.org (Postfix)
	id DE9846B05B0; Mon, 23 Nov 2026 07:49:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1A36B05B1; Mon, 23 Nov 2026 07:49:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE9D6B05B2; Mon, 23 Nov 2026 07:49:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADA536B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:49:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45D60A08DC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:02 +0000 (UTC)
X-FDA: 85466363724.18.6429915
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9FEFF40008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZ4TBU4E;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795438140;
	b=yUKu73a8oQPVPSrkUwk+oZQBkP3e1I5tVt7GqZGoqfGHqIkvT/B2ULLDVinKhLv96mBymR
	Qk15N2HoDvlk5K3GA8yRd+8qS/2glJyxmHSkp6RckX8pY3TGKHaZVUbclBzxDpNq4Afc4u
	XdAemIa73/afOkRFjreP24VrAxJbc9A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795438140;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3P0QFWOXFf1JVcoZWmNHfhcB6UAmWhbNDIJa62Al99A=;
	b=oYgX8UswgcpJJms99iNgnJw5Et2gJ9Wvbkb+byiBNI4BOODlNjmDjbMWpumPaF6/Iek5P9
	HroTv77IaQgQFHv4tCvob3MmmR/N//v3TEQgs4/HGx3NUQ8bGEQdEz/1i2968QvzFdU+Gx
	K0qaOXoji/x4Lqt+BCZl5pYV6xJ1GD4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZ4TBU4E;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D821F620FD;
	Mon, 23 Nov 2026 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2D11F000D2;
	Mon, 23 Nov 2026 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795438139;
	bh=3P0QFWOXFf1JVcoZWmNHfhcB6UAmWhbNDIJa62Al99A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LZ4TBU4EVchSX1M179OKUSRcJfdJiRyTjp2gAzmj1NF639MGAp3GsU8Kl3yfI8240
	 DjDy4BT0M5vd/omRg019ByrMQjglepX3JonDOWbDoR8Jplj0zRLCo1MsAZgXXQEhrw
	 oso/ckKBNUIEQIkEiRqeqWPW7qnb/uIqBHWkHqkesKFYt4O88UaMvSMBDYF5mzrv5q
	 A1KiTRST4WDoU5ZIYCvy9Bu6lI64du+gN+T1ZFPA7tsSYAGuNOAmaT/4v2CqXOEOT8
	 j9q0trk0VFsm/yrWLwLU1m3t9v8c356Et1cKdKRnShP1cPdzayc/gnfxqXj9/xJ3un
	 QKwsPYHVgjNJA==
Message-ID: <sashiko-outbox-229251@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 01/14] mm/vmalloc: support vmalloc-backed VM_SPARSE
 areas
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, shikemeng@huaweicloud.com, hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, corbet@lwn.net, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261122123918.3486916-2-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
 <20261122123918.3486916-2-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 12:48:58 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: 9FEFF40008
X-Stat-Signature: rkdzynhdb6w4iuqb87escox47e9o66b1
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795438140-732364
X-HE-Meta: U2FsdGVkX1/Pxh09ps/MtO2bJ29ReT4fubD4dRtqU3EirPwIqwXiN2JL8BuL5JJnBI+18flVYXD47iVryzV+QoN4XuBmV1jhWk+eewOFppax0z9ICwGSvvUWpLV+FrxqmhNUuXyBlZ+i4MQ7TW8kOnniTAaib6NFvgxQxd4o/btJ3OclTdVreB+tFTzWEoczny9ZrEpcvdSp8gIXCBjWTNg7+R7S2Q7mcr0YpInWvlqCLupTFREfLMkoVeNjKDmLgRBDzpUGOg8wjLS/CgygVB504F2l7oH2JpmH2s+pOOMiU1sAKAOsjrm9kkaydz2w4vkyJMb6el215DvN91Bs64sZ1X8NLtuJwZOPIBQwS63xkDZTmnYeEWUEisITHVA2VyAJP0fsNxTlM7rPZsmc6AQjWVeC8c3pL5tZlC0Idk8GbuGvR0O5SSW1DxxJnIC8MxgveSb6bQBMpz8Tig3CABySlhb57UCqVxwzI3NsC+clAmT365g54JIAVVAoV9n+qOHZsyx76g5HALyehcksuJrpRkY61tKwEnW8NcEmg2qRuF0Z/6jwPiTlCnLmlRW5ZGHg6OPEh33CKZO1QeITpzKubjEAG0a0vVYcPQM+7jUY2sMHssLBRAPhyZz3lp4NAZZAx89sh+3D09tzsVCsdUqKYiq2zwpoHIKm7h2K4n8tIw+CoRUkZHNex/q2gbPh5e581Lcbpsp78WyfSlboVWdQilH9cYfwB9UKuW4NjZ1PF/kBS7b4iwOtdc21cM57zxX8QhRAA446AadCSxLX44Sy2knxM6TcEeHdBOpY+meQ6XOeFg7lb53pUsHoWXt1g5EvpgNIx/C7VCd7eIR4TEsRSkczvbrFTnUpGYuQ8JeiZZFkNs0D2c0ZMjfLjVsdZ/KMUmt1d/x9dKeNN663ARx2ASy1HJzRQqWI9BXKQCQMA7cRLM6dlutkLVFoTpyuT2gP0YUmyKBRtgITDIK
 1FTLWEkI
 hxYDMoqXzF/yQh8d/QgnnwUd6X6qfEAyFlQ2zaC0lnnncGUoIpjDumyMmkU8UxvtJ3ZMdDcDNctHjgynSCxiJrPbmCuVouihdBjAPiC66/lGSk3AE7sGUtvfBV8Uzz7DXoBHCROuGlK8Ka1pr8uO+7iL2pWWynQSkNZ6mDVVCcsP1fFxSzcV62VEka7NJ4+0iyv1TkfkW1mrWEZYePBC4vBejdLPCSugtNPtk0gZG0rfrDuSTwG6wWU9dkWm/6n3ah432P5PPjdrDZedStBwvNqRxzqpvqXaFXymzjg3IzL5rM8rZ3TTr0tBgkaOI53HKW3xLpxPaZVaXgnYE9CeCGKeqhtFBy6gkhnMxaibF/RKjwMnssLzHf4REqOCzcYT4mE3ZswpD6zoIo909W6rGLm4Xn8Rr2+rLSps6sML00a5bgKuBwIkaM4t9NfKzdNSVIkhQWT6ZmIMqc0B6g2eXbsiNCYv4tFEHXGgydxEbDhjALkmM4EOE6rMfa+r4lWeDRUhyRfLs5wzeW1xrmLi+S6C9JJTIA6z8Pb7JOgOVlVTTjT2hA56OAkTUBxqJicAqAiLnBHN8jaWFJVitjPxBp/GX9tqdOGVXnTKQfH1+bc0pap/VrUcPvSNZ/Fj6nJRNvJc9aoLixyqvfdoLpBC3Igy/5hXQUw4hkr7ri/mZNzwt2okX865FC+TDvY6nbvTI5XsprDNIJCMsVuRSSxdsCZGn2RTcltDNqy12s2Ub56ALIxJqOHl9dgr9OmVwTYOlQAzPzIq3DFbRk+o1D6ZD9oKsB0f3ANYNsSh/vqdR9HWwe/butpa3guonFIOA9zHsXs78XuFs5UwcoshbJVDmUg3Zkhgy/Pe7TSmbjBEtjpRtTU771DZXOVlPV29eGpA6T5ZJ4//koeyp7pXFvOWqgjDnL82YbpjWmkoN
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
- [Medium] mm/vmalloc: vread_iter() ignores nr_pages =3D=3D 0 on VM_SPARSE |
  VM_ALLOC areas
--

commit 06f2dfa4d38fcaa037aa36eab4a7c644b49409c4
Author: Baoquan He <hebaoquan@kylinos.cn>

mm/vmalloc: support vmalloc-backed VM_SPARSE areas

This commit adds vm_area_grow_pages() and vm_area_shrink_pages() to allow
VM_SPARSE | VM_ALLOC areas to be dynamically backed by pages from the page
allocator and freed with vfree().

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 320e981188c98..0fe2f1c39b96e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c

[ ... ]

> @@ -4983,12 +5114,18 @@ long vread_iter(struct iov_iter *iter, const char=
 *addr, size_t count)
>  		if (n > remains)
>  			n =3D remains;
> =20
> -		if (flags & VMAP_RAM)
> +		if (flags & VMAP_RAM) {
>  			copied =3D vmap_ram_vread_iter(iter, addr, n, flags);
> -		else if (!(vm && (vm->flags & (VM_IOREMAP | VM_SPARSE))))
> -			copied =3D aligned_vread_iter(iter, addr, n);
> -		else /* IOREMAP | SPARSE area is treated as memory hole */
> +		} else if (vm && (vm->flags & VM_IOREMAP)) {
> +			/* Not backed by struct pages. */
> +			copied =3D zero_iter(iter, n);
> +		} else if (vm && (vm->flags & VM_SPARSE) &&
> +			   !(vm->flags & VM_ALLOC)) {
> +			/* Populated by the caller; treat as a memory hole. */
>  			copied =3D zero_iter(iter, n);
> +		} else {
> +			copied =3D aligned_vread_iter(iter, addr, n);
> +		}
> =20
>  		addr +=3D copied;
>  		remains -=3D copied;

[Severity: Medium]
Can vread_iter() read pages that are being freed when a VM_SPARSE | VM_ALLOC
area has nr_pages =3D=3D 0?

Earlier in vread_iter(), the backed size is computed as:

mm/vmalloc.c:vread_iter() {
	...
		if (vm)
			size =3D (vm->flags & VM_ALLOC && vm->nr_pages) ?
				       (vm->nr_pages << PAGE_SHIFT) :
				       get_vm_area_size(vm);
	...
}

Unlike regular vmalloc() allocations, a VM_SPARSE | VM_ALLOC area does not
set VM_UNINITIALIZED and legitimately has nr_pages =3D=3D 0 before the first
vm_area_grow_pages() call and after vm_area_shrink_pages(area, 0).  When
nr_pages is 0, the ternary expression falls back to get_vm_area_size(vm)
instead of 0, so vread_iter() calls aligned_vread_iter() across the entire
virtual range while holding vn->busy.lock.

When vm_area_shrink_pages(area, 0) runs concurrently with /proc/kcore reads,
setting nr_pages to 0 under vn->busy.lock no longer prevents vread_iter()
from entering aligned_vread_iter():

CPU0                                  CPU1
vm_area_shrink_pages(area, 0)
  spin_lock(&vn->busy.lock)
  WRITE_ONCE(area->nr_pages, 0)
  spin_unlock(&vn->busy.lock)
                                      vread_iter()
                                        find_vmap_area_exceed_addr_lock()
                                        /* vm->nr_pages =3D=3D 0 */
                                        size =3D get_vm_area_size(vm)
                                        aligned_vread_iter()
                                          page =3D vmalloc_to_page(addr)
  vunmap_range(...)
  vm_area_free_pages(...)
                                          copy_page_to_iter_nofault(page, .=
..)
                                            <-- use-after-free page read

The same race occurs on the error cleanup path of an initial
vm_area_grow_pages() call while nr_pages is still 0.  Even without a
concurrent grow or shrink, vread_iter() walks the page tables across the
entire unbacked area under vn->busy.lock instead of skipping it.

Checking (vm->flags & (VM_ALLOC | VM_SPARSE)) =3D=3D (VM_ALLOC | VM_SPARSE)=
 when
computing size so that nr_pages =3D=3D 0 yields size =3D 0 (or skipping to =
next_va)
would avoid this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122123918.3486=
916-1-baoquan.he@linux.dev?part=3D1

