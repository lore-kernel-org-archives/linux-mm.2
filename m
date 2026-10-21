Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCD6606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KP8uE2X/
Received: by kanga.kvack.org (Postfix)
	id 846A96B073D; Wed, 21 Oct 2026 12:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EAC6B073E; Wed, 21 Oct 2026 12:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D9D6B073F; Wed, 21 Oct 2026 12:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7286B073D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:11:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF2A51C3DC4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:11:26 +0000 (UTC)
X-FDA: 85347123372.05.1083E90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 287CF18000D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:11:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KP8uE2X/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792599085;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2ZCu6NwHs09mDefN9txWy7FuQyr4dGTj++ZockRsfU=;
	b=S8xSOBIAn96CPGbXVupDKJHswOstpbjEZxm3LyY0s3iBjUZFTC1GbwgoCpj3aPSUR5xy0n
	PgIBTmLsaTSjx0sk7+Tr23PQ3SeZj9oYazTKX4oa1i0qO+UO4ycjA3WD1pI31HXnizK7Sh
	+kQokTPSk40wU+sefTMfBiRpRUw8Ndo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KP8uE2X/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792599085;
	b=Ij3xIhr5ge4JEDO+P9ezvGsyeOgj5fja0akEGiy0PXVsE9g1HU0TzdIo9VL568MxEalqrR
	dyhsK8Bb8nuv31g/ExiztMFbDZXqKD2zee5E8wKTuElHy2lKiPhSGMIoeY/4p3UFStMQ6h
	fasTBiYogQlZLsTky6Hx13/2jviD6zY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E2496020C;
	Wed, 21 Oct 2026 16:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12201F000C1;
	Wed, 21 Oct 2026 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792599084;
	bh=g2ZCu6NwHs09mDefN9txWy7FuQyr4dGTj++ZockRsfU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KP8uE2X/b0TrrayohdZ7OMWlDWru2ha2D2MpN8YYs6wqx+bALaCGvijd050HnOzkR
	 CDmg09nDajxyfyks3IDcikn89UzIJ9l/ltvbhJj8I9ivXic1+fh9TUTuieVR3aoCZH
	 q00tqdQUi1ZaSJZRurW64T8+dA6tWDNM4JSz0vBRQchhVfiJeyyVWzKUvcpRje9qDG
	 axOLki4WZH6ULGPxI6IrXF6XoINxOYVDetNUzBl8P9kZLh2nPOJkEmUnE4TLPJTq4M
	 TiAKVQZGvY4gJfn6vzUadnlM7yox237u6zU0BgvKVo7uLSGwAiWipi+TIkSzwEpYr0
	 1FP/CJwkOxrkQ==
Message-ID: <sashiko-outbox-180460@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/page_alloc: clear page tag refs when onlining
 hotplugged memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zenghui Yu" <zenghui.yu@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com
In-Reply-To: <20261020161053.59879-1-zenghui.yu@linux.dev>
References: <20261020161053.59879-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 16:11:23 +0000
X-Rspamd-Queue-Id: 287CF18000D
X-Rspam-User: 
X-Stat-Signature: 7ez9y3xwopyzw7fkjm7xi18i18mtsixy
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792599084-808457
X-HE-Meta: U2FsdGVkX1+fj08l+MzsJcDTEuoii5hUJBub6kewquuBbMvHI66nVis2fo0fH1Q2Ks7XlEOHaUi9Mxy9JBTt7GzS+cm3axXg/j7YIfdt1Nb6whj0paCsWWi+uZ1t3xWYaIdA/dSOaMrOd22KhVo3oChyeEPDtlt/dB9VhJX+tQDM+rAOqCK0pQSHuQQXMiKmZUSkGL3KkkSVUc3TjFl6bZy6yHztYFRmlt+y0YNipH48tGc5D4FFlAU+nfcK99L4XAqzURk9eBU9viIW2alS9NmZAwvqcG+sW/NP105LtvFE0Kz/bfuAC4Cu+dG71/lk8EdOnKA/MKt+mVmdm1czvn5NhTC7Ey7e47FJ6UFjblG3sDN5BSdYlTs5OLVyYkU9rRbq+hNh89XVdmvc/vDNGPOq9CrCL4cBGo7ehcS4CojwMLz+VdcEOyrTO8VCV12MQuKQo/t58fVC/uzCzFT0OrKL6oHfoOJqxR0W15GZ8DGl2AraB+T8T5fgJ+nyxeV8aYvOvKeVgFUiHWEs5Si/NW8QSCMEqrFx9gC1DPszGUoroMXCXbhfqNHSwv7aim4tgLB67Y/dwX1QfQlVmwBGMz2dUqcHmDbtx1pll2s4L4rQYsg2LZZET9XW9xjr5Ge9LXYDmeGjTJD4yS15IQdbpv3eB5qF3Cy64EbC/XSOb+5mpw7ZYH8M0eKWQHi6s1S6vKlQcyGPaLSwJxMap1J9UncQwK7jllP+KKtMFnt9GluYfW0V52llSWEd4lRtvdrBcBjMXSJOez8OEj1AYQQqjK/QS/ziHLLNayhuIPZeH2wFxW8qYuBMZF7h+gOZn192Wat57W1zHakjPe9EZZLBgiCzVycPc/P+fYbHnqAX5QVwlyYkMfU46DDkduqze9Xn2QXh1xFK/ZgCcKGj9qK/G1O7TDXletauZBVpVqKnyE43Nf/0o5sAgXR7j1yBIjiG05lqrLBIagNBTEegXF+
 p5P/WIPt
 zFKeW/0Ohs0Q2voBpMBlD/DZt2fGYptgw1JxzpdRspY6T2L3EmoiohoYS6aVeueki96dVJqvLFPvVKDWqYVNrrVvxH4RYntcPHVYhfqdzwxCuKkOpCiu25psWRCAuImZngC9H3E7ZPfSfH4oP1xeDakhaRDBVZvm82euhP9i/ItcsNC3tjO7MMBdhJ1v6jZzNDoh3kDRlLcsPUAjfFnXGc9uVo7MKoTE+cr4F2I5SAN1CiErcZ8dwg2Sx9H4PV2ciw4r6+Ex1e23WZnWzwOyY28sYAWQID5xJkDQBl4zJ6v53xE0ic2Mo/m1ykKlniApk2MJzPexFBMPWBJXycoy3J7YN30B7dMzsk7lUuZ8odhoYFlbkGTkrvJOVXbRY7H96wEtE/9e98HtvD5wI+Eoqc0aI4I4e/Cc4sznFY0nD4rcF1tkLvx3NDTU1678J9MGpyRjyVKp4H6yHPvzgPLMwuSh9MmVUSFdQDvMMKA9JH0PjOPxCyr4jEHIpxKOhKM436h0fvBCMTt80oKRHQTxT+dQpbNsCNlqVZmB/80ZWBJZV9PzoNPhAyaeFviMSi0CNZ36gdFj+4zPuE6IhbjdsSAsg3lupAGfcXXTiqliG/OQ0ujw=
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
- [Medium] mm/page_alloc: clear_page_tag_ref() called on tail pages in __fr=
ee_pages_core()
--

commit e2abce3265909945612b858336381b3dbe9dca76
Author: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

mm/page_alloc: clear page tag refs when onlining hotplugged memory

This commit calls clear_page_tag_ref() on hotplugged pages in
__free_pages_core() so that freeing never-allocated pages into the buddy
allocator does not trigger a warning under CONFIG_MEM_ALLOC_PROFILING_DEBUG.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2daf358269ae7..9cef0e9294abb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1603,6 +1603,7 @@ void __meminit __free_pages_core(struct page *page,=
 unsigned int order,
>  			VM_WARN_ON_ONCE(PageReserved(p));
>  			__ClearPageOffline(p);
>  			set_page_count(p, 0);
> +			clear_page_tag_ref(p);
>  		}
> =20
>  		adjust_managed_page_count(page, nr_pages);

[Severity: Medium]
Should clear_page_tag_ref() be called once on page outside the per-page
loop (and for both MEMINIT_HOTPLUG and MEMINIT_EARLY contexts) rather than
on every p inside the MEMINIT_HOTPLUG loop?

Under CONFIG_MEM_ALLOC_PROFILING_DEBUG, clear_page_tag_ref(p) sets the
page's tag reference to CODETAG_EMPTY (or CODETAG_ID_EMPTY when compressed
profiling is enabled) rather than NULL. When __free_pages_core() calls
__free_pages_ok() -> __free_pages_prepare(), only the first page's marker
is consumed and reset back to NULL:

mm/page_alloc.c:__free_pages_prepare()
    pgalloc_tag_sub(page, 1 << order);
        alloc_tag_sub(ref, bytes)
            if (is_codetag_empty(ref)) {
                ref->ct =3D NULL;
                return;
            }

Calling clear_page_tag_ref(p) on all nr_pages leaves CODETAG_EMPTY set on
the remaining (1 << order) - 1 tail pages in the buddy allocator. If one of
those pages is later allocated without a tag (for example via an _noprof
allocation where current->alloc_tag is NULL) and subsequently freed, the
leftover CODETAG_EMPTY marker prevents alloc_tag_sub_check() from warning.
Other callers such as init_cma_reserved_pageblock() and
memblock_free_pages() only call clear_page_tag_ref(page) on the head page:

mm/mm_init.c:init_cma_reserved_pageblock() {
    do {
        __ClearPageReserved(p);
        set_page_count(p, 0);
    } while (++p, --i);
    ...
    /* pages were reserved and not allocated */
    clear_page_tag_ref(page);
    __free_pages(page, pageblock_order);
}

In addition, placing clear_page_tag_ref() only in the MEMINIT_HOTPLUG
branch misses MEMINIT_EARLY callers of __free_pages_core() that run after
allocation tag references are initialized and do not call
clear_page_tag_ref() themselves, such as deferred_free_pages() in
mm/mm_init.c (when compressed profiling is enabled) and do_collection() in
mm/kmsan/init.c (where KMSAN intercepts pages in memblock_free_pages()
before clear_page_tag_ref(page) and releases them later via
__free_pages_core(..., MEMINIT_EARLY)).

=E0=B9=80=E0=B8=84=E0=B8=A3=E0=B8=94=E0=B8=B4=E0=B8=95

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020161053.5987=
9-1-zenghui.yu@linux.dev?part=3D1

