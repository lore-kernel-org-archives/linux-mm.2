Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 752E7C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 04:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AADB6B0088; Thu,  9 Jul 2026 00:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482576B008A; Thu,  9 Jul 2026 00:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDFC6B008C; Thu,  9 Jul 2026 00:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 174676B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:29:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91CFF1C3849
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:29:25 +0000 (UTC)
X-FDA: 84967959090.08.CBDB776
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1F830140002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:29:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mCflFV4x;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783571364;
	b=Nghag3SwpNmQep9mw5QQZ+5Eqp46GtcGKRiHgm0Er6OzUkE8TBOV2JXSFQRYFtv1eQknUL
	b5Zf5FGoaBqEZ7jFAZGXCaUW6uRFu9SeKZ5ov8+kbTZc8DEnEDUHfuudiNiEe6Ip9wReYC
	7QWy4osN/T8BoaVEDglNc/RBZ3l75JE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mCflFV4x;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783571364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERKaoA5wnk6n6gGHWnQOiOQ4MZO14KJEaRX6W6rDBxA=;
	b=kJ/RCcp9C97dnBEmyKTl8anLwsJJAHy8Ji4+eP2dOxcQw30A9BEr7SaDePcruiqb+iq2dA
	Y/1+FkGks1bRuoRs3F+5Vf/MEcWMhnCVzXqr1pwpNlJhhdRcGUSNX9zgnq1LjeWDCj/OZN
	syJcIIRZU6zFf0Yz2VCPPsKASs8bBis=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783571360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ERKaoA5wnk6n6gGHWnQOiOQ4MZO14KJEaRX6W6rDBxA=;
	b=mCflFV4xyj4cu2NwR8t4TVIr0krNxA0YaUS+5Ketxq8UXwyF8DbsynMal5Zos/6zLhKmZH
	myXFcDCrK84O1y85+fil24h4NvPKt4DpWIzisXE8MGjLLFKwpSPbpGY8UcYeatNHIXiunM
	YJebN/Su6vflGOOw3xljF9LZRKLq9/c=
Date: Thu, 09 Jul 2026 04:29:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <220399d6c91aa81704eca2f1485fed2b11bbaf1f@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v11] mm: fix ASSERT_EXCLUSIVE_BITS by passing
 memdesc_flags_t by pointer
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Hui  Zhu"
 <zhuhui@kylinos.cn>
In-Reply-To: <20260708204853.8542f27d6554c1ff3ce7162e@linux-foundation.org>
References: <20260708083308.747930-1-hui.zhu@linux.dev>
 <20260708204853.8542f27d6554c1ff3ce7162e@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F830140002
X-Stat-Signature: jk71wcieq1hjdwyjgq9uanuqnztiay8x
X-HE-Tag: 1783571362-274912
X-HE-Meta: U2FsdGVkX19BO01zmbIDUcfl6S0ciEOX9g0mlepYHCRW2NjFuAvodtb6ZX9sKtxop3Mf/jCkfXFkSS7ZHEdkjeM+ATwfbXhYPlG4RvHJhonnGjkLah1Qgf9VH11TlfdbAbdOwLhonaKA0GyEBxCc8CyUI7EuD2FibfYK/wS2zGGqG6H94WcEX6BUZLWZYfufnbTz4wTrYoHKaxef7vpCyG+BpkOhO3DsGxEUwO7a3Cdx9aPRLhwy1vKa7jRqwLpPjPJe2gXiZ4hlJIUOQtf5yj9/0byyET67bUKLVR21oTutB/dy0qd2djGJqhheW29tSkturAUVffNHshkjvpO7QLWJr+6y86YQNS5OBOa69UQ9pSanDPhAiPPaJMWdrcswL6n/sVMogag2QLX9WwNoVuWOyfWIkaIO4n3VRPgrpE6Y4hkiiE6b2Qi+6V8QOmMN/UDKeuacduiqmEXiKkSwqjJGc4ljJKxG5npuh2WH70xABAWcDi+P7dGbAFxlqCcl9cIUvydKmRl6prXfNVwf8B/LhNBy9QyD9yveL9aL6u7QfUF8EO0Z6xD1TcB6YRV9i47SEz7i3/1jjIeB7GDwBTPEHKpZhFT/cFbafyVUdLTQXtBC8MudnupGE/h+2sDtqPPXQ3Q9gLGQFXRh6vY7jVJAUSDhCR8juwe6eOL+ru4wZD8ozkrkk5tbTqmShJ4XLsCe1aquF+AscYXwqhFDZ+bvgERNFpobohXirYfv17keLzn9I5dq1AG/JkMK0l0CP9HZfQv+623O9FqLq2XGSkNjoIGLSv1ldAb6XJ75tbr4cw+RIJLDQDwUb4qYScGSwOm6oBt09z+UXtmO6sVEciN3nbzkjL0tIeJ4WjpcSeQ7eNZPFv+TnqH1v0m4muJnAQJytzhwHl8Us0C4x39YZuIaea6ybdETobR2w1BgV8TQlYwrYJH9JV1HbCw/LZi5aBqYFbYpztl/W0cGd3X
 R43ojife
 UVfcCJHiIzIqWTvRIqOqKmtGCJMm+VFf032xeK4Rwe1sNesvdZZodARrN/U1V4Vqu7V4k4Yt+EURNV4Tkgrv88LEkZ8jCcp4+RzHy5Avq80oHtOXkFFvPXh5uhyFkuFf5FoPwgP9mF/Mmhjkce9Un5zPYiX/dnRGcRf9Rc7V5YG3A+jffYFswxMn7hpTjDr7UXJz2nsI2qmyMzSaRpdYnCl6OrlxR6wfBWbCcHgEQU0qcDNwN5+sxWwFEYDV42G2RNm/AxWgkkw+2hhCtIAMBogdm/52zfNAceKHO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Wed, 8 Jul 2026 16:33:08 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >=20=20
>=20>  KCSAN reports a data race between page_to_nid()/folio_pgdat() read=
ing
> >  page->flags and folio_trylock()/folio_lock() concurrently doing
> >  test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> >=20=20
>=20>  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio=
_gfp
> >=20=20
>=20>  The race is benign: nid/zone bits are set once at page init and ne=
ver
> >  overlap with PG_locked. However, ASSERT_EXCLUSIVE_BITS() inside
> >  memdesc_nid/zonenum() was checking a by-value copy of the flags word=
,
> >  not the live page->flags, so it failed to annotate the real access.
> >=20=20
>=20>  Change memdesc_nid(), memdesc_zonenum(), memdesc_section(), and
> >  memdesc_is_zone_device() to take a const memdesc_flags_t * and updat=
e
> >  all callers to pass &page->flags / &folio->flags, so
> >  ASSERT_EXCLUSIVE_BITS() operates on the actual shared word.
> >=20=20
>=20>  Guard the ASSERT_EXCLUSIVE_BITS() call in memdesc_zonenum() under
> >  ZONES_WIDTH !=3D 0 to avoid a zero-mask check on configs where the z=
one
> >  field is absent. memdesc_section() needs no such guard, since
> >  SECTIONS_WIDTH is never 0 wherever SECTION_IN_PAGE_FLAGS is defined.
> >  Under CONFIG_NUMA=3Dn, memdesc_nid() itself is stubbed to "return 0"
> >  instead of reading page->flags, since NODES_MASK is 0 and the check
> >  can never fire; page_to_nid()/folio_nid() now just call memdesc_nid(=
)
> >  unconditionally and rely on that stub, instead of duplicating the
> >  CONFIG_NUMA split at each call site.
> >=20
>=20Thanks.
>=20
>=20>=20
>=20> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> >  Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >  Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >  Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >  ---
> >  Changelog:
> >  v11:
> >  According to the comments of David, simplify page_to_nid() to pass
> >  &(PF_POISONED_CHECK(page)->flags) directly.
> >  v10:
> >  According to the comments of David, drop the redundant CONFIG_NUMA s=
plit
> >  in page_to_nid()/folio_nid() and remove the SECTIONS_WIDTH !=3D 0 gu=
ard
> >  around ASSERT_EXCLUSIVE_BITS() in memdesc_section().
> >=20
>=20I'm having trouble comparing this changelogging with the actual v9->v=
11
> diff? "drop the redundant CONFIG_NUMA split"?

Because memdesc_nid already handles the non-config_NUMa case, the code
for page_to_nid and folio_nid handling the non-config_NUMa case is remove=
d.

Sorry for the trouble, I will write more details in the changelog
next time.

Best,
Hui

>=20
>=20--- a/include/linux/mm.h~mm-fix-assert_exclusive_bits-by-passing-memd=
esc_flags_t-by-pointer-fix
> +++ a/include/linux/mm.h
> @@ -2303,29 +2303,15 @@ static inline int memdesc_nid(const memd
>  #endif
>  #endif
>=20=20
>=20-#ifdef CONFIG_NUMA
>  static inline int page_to_nid(const struct page *page)
>  {
> - const struct page *p =3D PF_POISONED_CHECK(page);
> -
> - return memdesc_nid(&p->flags);
> + return memdesc_nid(&(PF_POISONED_CHECK(page)->flags));
>  }
>=20=20
>=20 static inline int folio_nid(const struct folio *folio)
>  {
>  return memdesc_nid(&folio->flags);
>  }
> -#else
> -static inline int page_to_nid(const struct page *page)
> -{
> - return 0;
> -}
> -
> -static inline int folio_nid(const struct folio *folio)
> -{
> - return 0;
> -}
> -#endif
>=20=20
>=20 #ifdef CONFIG_NUMA_BALANCING
>  /* page access time bits needs to hold at least 4 seconds */
> @@ -2566,9 +2552,7 @@ static inline void set_page_section(stru
>=20=20
>=20 static inline unsigned long memdesc_section(const memdesc_flags_t *m=
df)
>  {
> -#if SECTIONS_WIDTH !=3D 0
>  ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
> -#endif
>  return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>  }
>  #else /* !SECTION_IN_PAGE_FLAGS */
> _
>

