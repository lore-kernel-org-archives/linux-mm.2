Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A226606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 11:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MI3cXKzl
Received: by kanga.kvack.org (Postfix)
	id 583E96B05B1; Wed, 18 Nov 2026 06:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534BA6B05B2; Wed, 18 Nov 2026 06:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A9D6B05B3; Wed, 18 Nov 2026 06:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 241F26B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:48:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA5601C408C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:48:22 +0000 (UTC)
X-FDA: 85448066844.04.82EFB2D
Received: from mta0.migadu.com (out-121.mta0.migadu.com [91.218.175.121])
	by imf21.hostedemail.com (Postfix) with ESMTP id 987531C0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:48:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MI3cXKzl;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795002501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tO3TgKkDiEBpFDzUdbEPGhGOGJy6r4jFNQqVHNYhZcQ=;
	b=h4DRrUUfgIg+rNE2vDkldFjguZjQNmgf5JUpJxLuTR/wK6GVAmgPIU9qJCYZ3Xv8haIVyD
	jB+tGYJNOuHLtavykehAm7953/YXV88SgHP8kTb/QaztdH4byFBocQC4rNFRo1bR0Oe3Vc
	oy6JifLJmBaf0HTEr0/PvJIKT5MVNDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795002501;
	b=CLCdNhl9iOpDDIEbDVu/GgPUcFUoNn91YwqPCV5IY/DWm3YGz2ilGdFq4/2fz8xJdO02vD
	xWboAUsV/TeUBSGZA4w4o7hCbTJRuqXGro0Igg1xkLKafpNfanRe+MzCDompGu170rpgXU
	qte7XDvi64qCP+bRQaOY2LGzDQzzlNw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MI3cXKzl;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vauVE3U2RMCS1gurgi7wXZGlIMNdafXrioxA86yoBjw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795002499; v=1; x=1795607299;
 b=MI3cXKzlV7UIr/RZ0JX6zp4i0ZFe9LQp1SU4et4ivCh54T6Ja0pP9WZ9+k1/UZ+OIIv9MRlj
 IAFN8DwBWnaXQlL/Q75g862SuUeF8UnThX0fNToO6s6oeWNpqfXdxfAQmiTMPc5dh3uv8j3D5aH
 IC5m9wu5OEcUSbEJN2hAGIi4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 995b1b54c0241e97;
	Wed, 18 Nov 2026 11:48:19 +0000
X-Mizu-Trace-ID: 995b1b54c0241e97
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 1/2] mm/memfd: drop redundant hugetlb allocation mask
 narrowing
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261117-for-memfd-v1-1-fa68f433171e@kylinos.cn>
Date: Wed, 18 Nov 2026 19:47:21 +0800
Cc: Hugh Dickins <hughd@google.com>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <87A66860-C0E1-42CF-AFF7-671D19B82E16@linux.dev>
References: <20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn>
 <20261117-for-memfd-v1-1-fa68f433171e@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 987531C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wnwhfgkudffchbmxszgju1bdc53qccxt
X-HE-Tag: 1795002500-485214
X-HE-Meta: U2FsdGVkX19j6GvjFjVCWQY0EKykPaUakigJhrP5CIofgPd1oivY70cmX1NuXdJKcFRFjdX9xpVu/zI5nN979GAY8qSa+CEjTp/mv/rkwRS4hzSn4Gub3Z+v/W+ZoQrTInLFu46/Mn/EB9sM/jDoQJrE0ueC3JVk4YvvaDkjj7L7IywlbOVAXiAMuJJ9SuPjGfJUG9DY3NLeJ+bmR3iXwvkmvv8C7IXa1i3xXvtCGPIGYyJh56Vu4xJM4RstWmWsX/V6o3Civ2F4ckob60oA3D1MXJ4hEwiA2tuVdbdf2pORNnZXMgdTEqAC1drRYou9v268litcnooZBa4+2wb2wZJzGdqLsb1TUa5Jw4kWitloX4KxH4KPlUr0UX1gq66g2e3kSKD6yQpxY2rK4zOqZ+Yk4cPcZHZQG4dG+cw7VHwokHSM0/YdFqcaUTxKTZUa6Sqj2I0XlPRKasBVL8QP64vZGrBYqY9HLaNhkASehWwZ05liZzLxqS6+hhbsOXQt9skqLpPep4nv7z2ORwqSLkYrIsd04qrKYa7lKjinlR+NKtUX2MIexDr4cwsqWmQlrioKyhpWQTxoVeXmW9yF6JbaB+RXqWKpObECKCeDEo+pW46tANr/e7uMr7qvhJgNjONRIJd66Lxon7Zbw9fe/cYK7tWqAAEtilL6fxZklvzb/8hwYxAsFEf82/Hg1xF35c9JWnPKlrnGNqm8Di6IXXDjk6stVrBdp7mamiMkJ11/HCZ0ex20IIyV9x6RnN8dYCvvmexrFlmDOOaxuwECNmphtR9lvUpHLb8zdNIvwQ0CPePw1M8liQB0MvwHAisp2kB+Xfn7vsvuc9vDpwLXlhKCvAL3QQOtWn1HZh82IT49Rc5UnrnsG4UiKBg+qX36YZ3zdwkxELcN9e5jMea3bgv+GeI/b1uCg/+uRimBkVqKZe9xqr3KR1itcz+3UhVShXaE/ARxyhxkxk8fSMu
 pRPNESaw
 32yulXBACxSjPvIO1czBlYcuv/5/gs5ed6lDFTRO9TP7Rdam7F3l2n3ajkR3V/Rtq9D5B/NmVRFYnvAQg+rXfKa0/lFRx4YDfSJSWDcNMMwChmYKqyJchnbmQtlXsiAEY+54WenUpENJc8JG89bnRnMMzqa9XRH+S+wCc+xPhD3Bi3ZWvNX2/RuczOz36Sz+ew6YO9EtFYplbhgNw4fh4bUSp5lNYmE+O5wxJLrrgSZmJ5CpP+s7gnUpXnpu6iPR+lD7NLjlSlW+sInkHsoP6fEtkYpX+NUJKbK9Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 17, 2026, at 18:53, Hongfu Li <hongfu.li@linux.dev> wrote:
>=20
> From: Hongfu Li <lihongfu@kylinos.cn>
>=20
> memfd_alloc_folio() derives its allocation mask from htlb_alloc_mask()
> and then clears __GFP_HIGHMEM and __GFP_MOVABLE. This mask handling =
was
> introduced by commit 89c1905d9c14 ("mm/gup: introduce =
memfd_pin_folios()
> for pinning memfd folios"), when the fallback path in
> alloc_hugetlb_folio_nodemask() could still call
> alloc_migrate_hugetlb_folio() and reach the buddy allocator, so the =
mask
> decided the zone and migratetype of freshly allocated pages.
>=20
> Since commit 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios
> resv_huge_pages leak"), this call site uses =
alloc_hugetlb_folio_reserve(),
> which only dequeues folios from the existing hugetlb pool and never =
falls
> back to the buddy allocator. The mask therefore no longer decides =
where
> any page comes from.
>=20
> Long-term pinning safety no longer depends on the mask either:
> memfd_pin_folios() obtains its folios (dequeued from the pool, or =
freshly
> allocated) under memalloc_pin_save(), so PF_MEMALLOC_PIN makes
> dequeue_hugetlb_folio_node_exact() skip any folio that fails
> folio_is_longterm_pinnable(), and current_gfp_context() already clears
> __GFP_MOVABLE from any page allocator request made under =
PF_MEMALLOC_PIN.
>=20
> Drop the narrowing, which has had no effect since 26a8ea80929c.
>=20
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
> mm/memfd.c | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 0e3ff3eebfa8..8905e3e9efc8 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -85,7 +85,6 @@ struct folio *memfd_alloc_folio(struct file *memfd, =
pgoff_t idx)
> 	u32 hash;
>=20
> 	gfp_mask =3D htlb_alloc_mask(h);
> -	gfp_mask &=3D ~(__GFP_HIGHMEM | __GFP_MOVABLE);

You didn't mention why __GFP_HIGHMEM can be removed safely. I have to
investigate the reason myself.

During review, __GFP_HIGHMEM was cleared because "these pages might need
to be accessible by some DMA driver, so you have HIGHMEM constraints.",
refer to =
https://lore.kernel.org/all/ZmvNLSUgUgFETR0M@localhost.localdomain/

I think that restriction is unnecessary now: DMA and existing =
memfd_pin_folios()
users operate on pages or scatterlists and support highmem, while the
shmem path already permits highmem folios. The hugetlb path therefore
does not need a separate lowmem constraint.

Because you have removed the constrains, why you didn't remove the =
comment
along the way?

	/*
	 * The folio would most likely be accessed by a DMA driver,
	 * therefore, we have zone memory constraints where we can
	 * alloc from. Also, the folio will be pinned for an indefinite
	 * amount of time, so it is not expected to be migrated away.
	 */

Thanks,
Muchun

> 	idx >>=3D huge_page_order(h);
>=20
> /*
>=20
> --=20
> 2.54.0
>=20


