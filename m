Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB236CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 13:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8246B0088; Fri,  2 Oct 2026 09:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998EA6B008A; Fri,  2 Oct 2026 09:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887856B008C; Fri,  2 Oct 2026 09:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 603D76B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:58:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C21F614070B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 13:58:45 +0000 (UTC)
X-FDA: 85277841810.23.7B83F98
Received: from mail-yx2-f38.google.com (mail-yx2-f38.google.com [74.125.224.166])
	by imf16.hostedemail.com (Postfix) with ESMTP id C8877180002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 13:58:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Banc+ofi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.166 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790949523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65emBn6+gzyy/qLUsef1SnU8ScB/L39aQLr0XT7Souk=;
	b=ZZIW0jK8/j70xv4I4wVaOtURYXzCIHmX05woks4r0sb5WZ+5EJ0Z7D5NL6TcOqCm28ZurY
	/yFS1ze7c17kpPHvUNStW7de3Jcbs9zxZZUezM1k6QyOaGLZcmyQ22YRGfRlC2Lw1s8Eag
	0LfW3LDG2YnEd38bzRSUpiYk71yqdB0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Banc+ofi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.166 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790949523;
	b=gNSHwyU/wZiKyTmMb6JRrW+kTBn5gNHFH3l1ppNe+Yi9zOGt0EvQLC5ivXzrDI/kUctlOS
	Mnp8D5HoEZKMCqI4yoMHp+aaSMu2sUJ76cuwTFDM861XI8H0WReDREm50eVTgIb3JS/LMZ
	dcqFWi3kAuS/1m4JVwi0dY4UsNoh2F8=
Received: by mail-yx2-f38.google.com with SMTP id 956f58d0204a3-67561cbafd0so3576319d50.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 06:58:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790949523; cv=none;
        d=google.com; s=arc-20260327;
        b=UXtr3h0llW2ItEpP/oOh4/eRnvab4c97y9icND80BozOq20vA60HJ+fOTnHyBtymGY
         uIHVhow+xxTSeuqm+iu/0eJVkeihapujSBszlxTALd2IyiAnzhUGuWUiPvbDXtcoaCwG
         j24UXETk8foStj9b5YKwGjs5fefcLchKPvKbL+9Mwk9+x/CjLPNkSwPax/Z34c1Als4C
         A9QZYo3GlFD9topb2Rk02o0mauycO/YvGc6Ycdx/5+bfJQtiMsUC+cxQOlhhd/OT4+gd
         ESs0sdyaZQ1TmhYtSYESDUCOHHCgqsYrrcIUlilQZPWRHhMGSfKYkoTtJyKyC4oTPFZs
         rEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=65emBn6+gzyy/qLUsef1SnU8ScB/L39aQLr0XT7Souk=;
        fh=8ogNNY3EXW++/tQHnWIKJJ4T5TIVcJpP3XrSxg8HA2Q=;
        b=NZJrtdc+SBiTLJaACwU3GvlRAVjF32tAjlLby9kphI05MDPJe6xUUSNp99YZ2TvSi6
         LKFbCoeETGIPM39Y5fsIMl5BRkqn03+JXGBVsF/2dQXuAd08hlZchJI9H+UmmyX9GhKJ
         I5RGBgqp8qs3PTQ8wD8mJyKHBpjNaSjl08K3FyHqhkDdRrgrYWUcUB5qs+QpIsPVzhFU
         +eSgfIaDNKqQh+mn7xcv0uFFsNm24lKDD/MkAXajAcbyxkWlu82Gxr2HQ0odG94LqYLI
         i5T7e2zxOYTdrvC1eNjqvg4mSvbDzXMDRtqBkDZfuxbPlDT0O/xxnoOSksTFWIIF7wgR
         ynqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790949523; x=1791554323; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=65emBn6+gzyy/qLUsef1SnU8ScB/L39aQLr0XT7Souk=;
        b=Banc+ofiPM2Kw+kmHYe7NVA5N7sH3aUCvUsAlKAIiJpQaNBSIEi2sCFrPLTdF3Vn11
         wrvsSVoAveFkK+crC5QPG3Ukw3K2Zm99XzGlv3hbdcUrI8VM1Rpq/0nj6m9+A1l6o356
         0rTLRoVNdimoBuSRGAhVLX2orjeBwg3BYwizBaCKCYEmiyq2NhC3d6Ul8DGnQKefv7sR
         WQG8/WBB+j/HxCfPSBEICqUl7JoEShA7vsK5iqVSRqqgi+QzFzoa4wq/bZJnbnY/+XJK
         zJ5xwZu02f3fqV9pZb1k92lTfZa2tRB2IOnqnTy8eup0S9Qw/A7GXo6kAmktR9Yj8ff7
         QrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790949523; x=1791554323;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=65emBn6+gzyy/qLUsef1SnU8ScB/L39aQLr0XT7Souk=;
        b=tB2wGunZy0mUDhqLMFYr9f7czdyHjpyiZAwJUDeA7oIoNkNzxbrntK2AJ44xwTdhdu
         306TPCbMJrE+Qz4jVZ7ojkMYefckSDKnfQXsN0x8PEjSzRtMwkw+E42lWbs8KwTO0Fvk
         MMO3PEHz4oI36lvb1p0JdqjEOb/aJf6+uhQUdJJ4v4We1Edl78F9+1sRSBSAflN96K4D
         NP0Cxm6trbceszxNcY60ahepNwzBnuR5CCqAkoUb3na5nI4xLWs7bd2rqYfZYcXQU5KR
         4oa3scbcC5ijyTwfrqLWdy4jVHsFX4krZev7iixfzOAFEIZWH14kGOAzjzEgbsPuRFQ1
         hz4A==
X-Forwarded-Encrypted: i=1; AKwUvBzDTcJe8HQtPF00UBwxw7ZhyZg8/Gvdwu3Af6uhbthNnUjFGCf5AirBtxZKpllNnHj0NtvKNwQVcw==@kvack.org
X-Gm-Message-State: AFq9FYIANylFKxqsLjvDL0Qh0q2jmvcjmB0G1nIdgWaFMEqHCymnIsqq
	QfQVa3ooK2vTgvkTU1jfetXsYS2NB8O/fz6GCip50+1uvI/HMDblbrvm0TdulVYc3H9/pUFlRYb
	XD8bAB0/3SU849vDJ33f6pDBKCfebxZM=
X-Gm-Gg: AYBFou2clWb8xjg073s9RQzhmO38Sz4mGVr1Byb81gwxheZO4PMHVKMGfNDcoPnnnOx
	XPOsOIanCqMr7EkjYfpIFdynp8w+WQUdlxKm2sCBJcR8aQObqXPbgCqC3vPIhwxi4DUZgPVb+z7
	CP8AavmmKJSdWHkVJEoh3CE31stHd5+qM45cnZPIsUL8Dxuw9wHV0H323e2NQQb6FkjT/Ee5kpx
	xXi2SNMuiD4TNtQCPog9NfzopxFdUpeQmTXfB+AQXyMiyOvbfQ9ad3WIuTYO4cqz7PBtGC6GXV8
	wRdU9OtLvx+ausmTXjqnzKuU38YtMsXpDhtO7jXotBCUjPNri/59KG6JSS2eFrI=
X-Received: by 2002:a05:690e:4401:b0:676:8939:3b64 with SMTP id
 956f58d0204a3-677ac0bbea0mr799816d50.48.1790949522514; Fri, 02 Oct 2026
 06:58:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260929143707.450805-1-ekffu200098@gmail.com> <nwwd35ikeinmyl5eug3eoon6h34eo7danw4pdq7htikzbgpmd5@4encqsdqicxd>
In-Reply-To: <nwwd35ikeinmyl5eug3eoon6h34eo7danw4pdq7htikzbgpmd5@4encqsdqicxd>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 2 Oct 2026 22:58:31 +0900
X-Gm-Features: AclHuK99PAjbPVOUVOnY-m9VdWF-KSfAYJ0dIQ4rDK8eHlf5zrIorPOdkVd96R0
Message-ID: <CABFDxMGuCPNjDTKNBdtZkf8a9rh2D_tdwwNMVLqZYq43vMuK0g@mail.gmail.com>
Subject: Re: [PATCH] mm/memory: remove unused vmf_insert_mixed_mkwrite()
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8877180002
X-Stat-Signature: ew7xid4cohkxgmjkxdoqeacecjdunzng
X-HE-Tag: 1790949523-792444
X-HE-Meta: U2FsdGVkX1/OpKhTAY6Rf/wgXzII/Vtxn+9NnHOO8Iy5kVhD6Ytl0r+lSCYwQIYw0ByC5QyMYjytdPKZWI7H9KA05r5tGhLpcT5XwZ1ALW1wKBd41kRgUwIftImycKCca+0AjWIpEWRTjBXe/88ikuCOgSqKjZvq8fcTJGWelCSGP9vZ/gS7bDwgxC+od++J2GhEel7RKTbYlvwLKuA+oSX5tbNsKbS9ErbQIyuy8eG73FmeBATc30k50O1Vsv9TswyUBwST9H5It0osicSUg2HsoTD0OPOjcyB2j2cS6k25FcBQOvIgg7Ai0O0wLU86PnfHyM+8L/PePaA1ZRqPDzYQZM8HVZY+1jtmQDYz+NGe3bwGmQnA42WUmELjuNDeqPifh0qrymUP+pskgCCnt0j4S6CTzfjFsUIZMtDKDXd3umflROBuQPLznAPItnQT8sMIp7cIBd9kCjAP+OvTb9PtcMmhzqTXrNobgHdTbUdhtKytYK4xgKC2j4rDaTiYhrPmxn07wBQKnuBVgMUrNlmGpHSo7kWh2xSRvOhy8+58XE3CLeyok1kaICYyghBRDyd376Nm79qAauE1l3V1+pJKK9LBhoEH1xrxKMKWMlHf+asDSsIDDmEYRg4ouY4CyaMqlVyA/eIOOAfa0fjaX2f24+tMoVrjzbAduk1X4CbgRL/BvV/Cxrfw28T6GOm9DmhZqDafkdd4CEQbxKvUTFnedjtWY/Rv0mD5YOeVzBTJQqrCfaow+oWTks7LKvE1KGo8mJF2tUE8bEjnIKB+MF63F0oQUtqE1eeSI/OBVRq1qdeBdyNX1AY8GzG/uo2YGACIpxXDBnl9bW8vdwQbU5eJwcsvdWb1QK3zApnBx0XdqF5XwsprPTpMV5MU40PqHLLsI9wwey8quZ/UEwSd4RpcdqUX0mI3q8+FccD3iyY8HlovAtznIZi7K4qDqMo8SsxGYdHmAEmHRpSQgje
 lFGNpH4x
 R5tVLUEIwroEJa2s4qS849bRt8e5jWhviZElOysUL0H1Q9JI0Ht9TdrXMCXIwUgshwEM9JqGwZoEwF+i/pow37T00+3AgaJVKt/cAyuX06oEn1vhhwZjUJbn8FzC+qknq8EQz7aVhAuImXyMp9SwBU7mhQuiQuornuVyVf17KfKYXVmw4C7oKuAwfoxeZJ52MN52VcksZapELMKNmN4LTfpYTuy4+GTCm5gBrAdpyQGQ/zLFdLWSDCeevF3d15WF1W1sFyWDl7SnMod4vbCsAm6w5TB7/FV6+ukgkzn8IE9VpDDQhWbcrL3c9rnWBafPYFIXGPy+hs1wgeya5MhrrfQgOE5uVBI71VgagaUUQnDNF6SZdT78pjPnBW5gU9UHEhaddIjyRZxrc+asGooLWijsq4BVPJkmnsBgRFmWzhRh26W3EIK60vJeZmJReZaDITG62hLlBkWzslAh5Y7WvN6DLDcxu7XwNLOzZB2jwYa7Rax0Koy3+5atg1Z6iQElPFbr5LhPEzwLiXB1pL7TgBDhqYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Anshuman

2026=EB=85=84 10=EC=9B=94 1=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 2:19, A=
nshuman Khandual <anshuman.khandual@arm.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> On Tue, Sep 29, 2026 at 11:37:06PM +0900, Sang-Heon Jeon wrote:
> > Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> > vmf_insert_mixed_mkwrite() has no callers, so the mkwrite argument of
> > __vm_insert_mixed() and insert_pfn() is always false.
> >
> > So remove the function, the mkwrite argument and the unreachable
> > mkwrite branches. Also merge __vm_insert_mixed() into vmf_insert_mixed(=
).
> >
> > No functional change.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>
> This patch is doing multiple independent changes and should be split IMHO

Sure, I'll address it in v2 as well.

> 1. mm: Drop vmf_insert_mixed_mkwrite()
>         - No users after 38607c62b34b ("fs/dax: properly refcount fs dax =
pages")
>         - Unreachable function and should be dropped
>
> 3. mm: Drop mkwrite argument from __vm_insert_mixed()
>         - With vmf_insert_mixed_mkwrite() dropped
>                 - mkwrite is always false in __vm_insert_mixed()
>                         - mkwrite is always false in insert_pfn()
>                         + mkwrite is always false in vm_mixed_ok()
>         - Drop mkwrite from __vm_insert_mixed(), insert_pfn() and vm_mixe=
d_ok()
>         - Drop mkwrite based conditional handling
>         - Rename __vm_insert_mixed() as vm_insert_mixed()
>
> The above improves the clarity/readability making it easier to review.
>
> > ---
> >  include/linux/mm.h |  2 --
> >  mm/memory.c        | 76 ++++++++++++----------------------------------
> >  2 files changed, 19 insertions(+), 59 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index c038d06825c3..2ac734efd4ec 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -5008,8 +5008,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_str=
uct *vma, unsigned long addr,
> >                       unsigned long pfn, pgprot_t pgprot);
> >  vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long =
addr,
> >                       unsigned long pfn);
> > -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> > -             unsigned long addr, unsigned long pfn);
> >  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, uns=
igned long len);
> >
> >  static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 330cde31bf8b..1f83a26f8733 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2453,7 +2453,14 @@ static int insert_page_into_pte_locked(struct vm=
_area_struct *vma, pte_t *pte,
> >               if (!mkwrite)
> >                       return -EBUSY;
> >
> > -             /* see insert_pfn(). */
> > +             /*
> > +              * For read faults on private mappings the PFN passed in =
may
> > +              * not match the PFN we have mapped if the mapped PFN is =
a
> > +              * writeable COW page.  In the mkwrite case we are creati=
ng a
> > +              * writable PTE for a shared mapping and we expect the PF=
Ns to
> > +              * match. If they don't match, we are likely racing with =
block
> > +              * allocation and mapping invalidation.
> > +              */
> >               if (pte_pfn(pteval) !=3D page_to_pfn(page)) {
> >                       WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
> >                       return -EFAULT;
> > @@ -2858,7 +2865,7 @@ int vm_map_pages_zero(struct vm_area_struct *vma,=
 struct page **pages,
> >  EXPORT_SYMBOL(vm_map_pages_zero);
> >
> >  static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long=
 addr,
> > -                     unsigned long pfn, pgprot_t prot, bool mkwrite)
> > +                     unsigned long pfn, pgprot_t prot)
> >  {
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       pte_t *pte, entry;
> > @@ -2868,38 +2875,12 @@ static vm_fault_t insert_pfn(struct vm_area_str=
uct *vma, unsigned long addr,
> >       if (!pte)
> >               return VM_FAULT_OOM;
> >       entry =3D ptep_get(pte);
> > -     if (!pte_none(entry)) {
> > -             if (mkwrite) {
> > -                     /*
> > -                      * For read faults on private mappings the PFN pa=
ssed
> > -                      * in may not match the PFN we have mapped if the
> > -                      * mapped PFN is a writeable COW page.  In the mk=
write
> > -                      * case we are creating a writable PTE for a shar=
ed
> > -                      * mapping and we expect the PFNs to match. If th=
ey
> > -                      * don't match, we are likely racing with block
> > -                      * allocation and mapping invalidation so just sk=
ip the
> > -                      * update.
> > -                      */
> > -                     if (pte_pfn(entry) !=3D pfn) {
> > -                             WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry))=
);
> > -                             goto out_unlock;
> > -                     }
> > -                     entry =3D pte_mkyoung(entry);
> > -                     entry =3D maybe_mkwrite(pte_mkdirty(entry), vma);
> > -                     if (ptep_set_access_flags(vma, addr, pte, entry, =
1))
> > -                             update_mmu_cache(vma, addr, pte);
> > -             }
> > +     if (!pte_none(entry))
> >               goto out_unlock;
> > -     }
> >
> >       /* Ok, finally just insert the thing.. */
> >       entry =3D pte_mkspecial(pfn_pte(pfn, prot));
> >
> > -     if (mkwrite) {
> > -             entry =3D pte_mkyoung(entry);
> > -             entry =3D maybe_mkwrite(pte_mkdirty(entry), vma);
> > -     }
> > -
> >       set_pte_at(mm, addr, pte, entry);
> >       update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page=
? */
> >
> > @@ -2967,7 +2948,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_str=
uct *vma, unsigned long addr,
> >
> >       pfnmap_setup_cachemode_pfn(pfn, &pgprot);
> >
> > -     return insert_pfn(vma, addr, pfn, pgprot, false);
> > +     return insert_pfn(vma, addr, pfn, pgprot);
> >  }
> >  EXPORT_SYMBOL(vmf_insert_pfn_prot);
> >
> > @@ -2998,11 +2979,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct =
*vma, unsigned long addr,
> >  }
> >  EXPORT_SYMBOL(vmf_insert_pfn);
> >
> > -static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
> > -                     bool mkwrite)
> > +static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
> >  {
> > -     if (unlikely(is_zero_pfn(pfn)) &&
> > -         (mkwrite || !vm_mixed_zeropage_allowed(vma)))
> > +     if (unlikely(is_zero_pfn(pfn)) && !vm_mixed_zeropage_allowed(vma)=
)
> >               return false;
> >       /* these checks mirror the abort conditions in vm_normal_page */
> >       if (vma->vm_flags & VM_MIXEDMAP)
> > @@ -3012,13 +2991,13 @@ static bool vm_mixed_ok(struct vm_area_struct *=
vma, unsigned long pfn,
> >       return false;
> >  }
> >
> > -static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
> > -             unsigned long addr, unsigned long pfn, bool mkwrite)
> > +vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long =
addr,
> > +             unsigned long pfn)
> >  {
> >       pgprot_t pgprot =3D vma->vm_page_prot;
> >       int err;
> >
> > -     if (!vm_mixed_ok(vma, pfn, mkwrite))
> > +     if (!vm_mixed_ok(vma, pfn))
> >               return VM_FAULT_SIGBUS;
> >
> >       if (addr < vma->vm_start || addr >=3D vma->vm_end)
> > @@ -3045,9 +3024,9 @@ static vm_fault_t __vm_insert_mixed(struct vm_are=
a_struct *vma,
> >                * result in pfn_t_has_page() =3D=3D false.
> >                */
> >               page =3D pfn_to_page(pfn);
> > -             err =3D insert_page(vma, addr, page, pgprot, mkwrite);
> > +             err =3D insert_page(vma, addr, page, pgprot, false);
> >       } else {
> > -             return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
> > +             return insert_pfn(vma, addr, pfn, pgprot);
> >       }
> >
> >       if (err =3D=3D -ENOMEM)
> > @@ -3057,6 +3036,7 @@ static vm_fault_t __vm_insert_mixed(struct vm_are=
a_struct *vma,
> >
> >       return VM_FAULT_NOPAGE;
> >  }
> > +EXPORT_SYMBOL(vmf_insert_mixed);
> >
> >  vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *=
page,
> >                       bool write)
> > @@ -3078,24 +3058,6 @@ vm_fault_t vmf_insert_page_mkwrite(struct vm_fau=
lt *vmf, struct page *page,
> >  }
> >  EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
> >
> > -vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long =
addr,
> > -             unsigned long pfn)
> > -{
> > -     return __vm_insert_mixed(vma, addr, pfn, false);
> > -}
> > -EXPORT_SYMBOL(vmf_insert_mixed);
> > -
> > -/*
> > - *  If the insertion of PTE failed because someone else already added =
a
> > - *  different entry in the mean time, we treat that as success as we a=
ssume
> > - *  the same entry was actually inserted.
> > - */
> > -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> > -             unsigned long addr, unsigned long pfn)
> > -{
> > -     return __vm_insert_mixed(vma, addr, pfn, true);
> > -}
> > -
> >  /*
> >   * maps a range of physical memory into the requested pages. the old
> >   * mappings are removed. any references to nonexistent pages results
> >
> > base-commit: 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65
> > --
> > 2.43.0
> >
> >

Best regards,
Sang-Heon Jeon

