Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C545606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PJZJZtCF
Received: by kanga.kvack.org (Postfix)
	id 44A956B0A69; Wed, 25 Nov 2026 11:09:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423086B0A6B; Wed, 25 Nov 2026 11:09:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3188F6B0A6C; Wed, 25 Nov 2026 11:09:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1222D6B0A69
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:09:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FE33A0F6B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:09:58 +0000 (UTC)
X-FDA: 85474127676.27.CFA339D
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C6D1100013
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:09:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PJZJZtCF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795622996;
	b=F5vc7QEclRYuHrQPiC/E0U1ihtA/fEhANj2hxXQXXo+tEE55mfcgk8FtG5MN9Fp4itcZUU
	0MiCWQ5PGWRpPQif3+5MeOLAtOoNXGmW5tmRHZnplT4czB/HeZ+a0zPhASBSX9CaL4F4E6
	DNCkYKLjxOcaIOhT5pfrL+mnP/ZC2gg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795622996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SH3WD86btuINr/uxcoF6S242mnrN0umh75GOIi7csNw=;
	b=QjqXnznOwLpatUIKB5In7M2boQlBjJa8P+ww9TMvi6JjxeV1T9KmJacld6fAt++8SVR2BR
	YGCwfoJyvSiWpLz2mvNzQLpwZLgG+vMavlkV+ogUPUO0DkDU5F2eIkgeMvcLeKnzOiz5xf
	zjluNe96mA1qAfcLv/32yqy7PMrTkbM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PJZJZtCF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d581da0aaso833579766b.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:09:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795622995; cv=none;
        d=google.com; s=arc-20260327;
        b=mHCMgXjNrV4CYSgE/t0yIz14GznxjWyUX/7Y56vpnNLisiDM9mh0z3xBwCndeXIsht
         2MgiTGZ3qfsDl8WriSDrlvMcpTBy+l3s1eqwdBGLgWQs8D2Ly3UUFl9v2caoFiYDisfV
         3iH9aVFRywLRW3+OqJQ96lJssXvSX3BBVTrVyps93bql8dNW6iF3HWS0RR7L0jcg/5nN
         WhBhvRwc9jjj2QD5YmFDAS+yGgkfbqHdvYiZ8/mbdo3i8kccvF7tVSI7zU6eBkuIl/1K
         EUCYSRMZiEpI7hLKvqXVniohaZf64Ho4WmK6ba1FyEFZhDhQLrUd7x9SHDYQF3rYJ7HV
         tP2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SH3WD86btuINr/uxcoF6S242mnrN0umh75GOIi7csNw=;
        fh=3MwbwQkLX62GmYYPuHAEvyS94wHlKhIFbiscVFjHcp8=;
        b=TWYrjPVrHjm71wyB65Q7dInZmR9YCw+glFyrLBhb1ViB/xv1PVyfp4egHGVX/Q/gC5
         LlIBCHeDbkzlkBXmasjKNQQKqMnDEyE7ZkPCMSYsrq4ygWBJ0QB5wXsji1afvQQjDTml
         /JfCFR32DFRnODMcESV1DPnIKyZXteERuushRFpLJkchT3F8zejrHVGBRjASPTsRIHHk
         g+vAnWLTxZQv9J2CWS4SJrFZbcJEemG9s8U30pLH5Vl/9vYpFkDqh3Ufe7IEUwA2uQ5R
         6uu1oldg3Upu8Acu8GJA8Hcgzp6CQq84Rj31ztFLkk2S4iGbIxnQIu6rY0WiR0EDu5nS
         qPdA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795622995; x=1796227795; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SH3WD86btuINr/uxcoF6S242mnrN0umh75GOIi7csNw=;
        b=PJZJZtCF96u1NtXOlicNOJg/pt+J1RkmMSiDb2c4PO9a2fs7axu7/aKjva7feFmyZO
         buK5oUt50XbsitVYuw03s1tHHKvASF2WEs/IHc47w4hNSQpVmg1eUYH7RV7Ui+coJQjd
         dtWDmaaAJaK5hP8n6VWi8qKiMYbL5z51zwXqnju3ipHDb3vfxgrrpqIPPV8nML94utME
         yql8VnadoRnw7wMFJVz837h6Ovh/96yUHmAYnpyHE708hJ8kOI7UQw06o9avVoT00vW7
         XuYHUB1hyJkpK3goWr9/q/f78Lgoi6ta5q2j7UTMoaCV2egQx+v0aa/z+qL4/d/+2NQE
         5Q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795622995; x=1796227795;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SH3WD86btuINr/uxcoF6S242mnrN0umh75GOIi7csNw=;
        b=mUOhghpCj7uiH/lVlADCdBu0sIyxyyU3s1VAtNVcfP07Dgy8BZH+wIvEiEfoaxq2+J
         X/CBpcmE16Gwu4W49m1pmBSbWx/tmJX75eAg6ri8wgBghjNIq+iKeSnXLli/VZDyJ7c8
         6CGRLWEbqxf7Nj4jZUInmgGnzQCU4QUjuIkEgZZY7Bx39TZWk6Lf4SnMim9zoBuy48WB
         pyCkT5dxOpZ4GQG8UgvOpTc92o6NmKcAilWdhL8zcZOnFScdcoTPgKZm6JxWqiHJtQF/
         cQopEk4G0i68rZZtFzo63uQ0bXUasm1+rCPjdc77jkGaSO0CDhBnI112VHZnR/ObUwDc
         y0hA==
X-Forwarded-Encrypted: i=1; AL+hErGKdghI/iu/UDtdv3Li+5Zr6ipOSXXShwI4EGNbfIqkvKGHtUwLUGaq2M++ldwV02XV3ig9awDPPQ==@kvack.org
X-Gm-Message-State: APuU4Z87NpLLSexHhabjGQWcEqZGclhSMYqBa8CjVImGW5lSmv/MytiL
	CPc0WcYGeJcrO9YvSGzEMkdKx6a2aBOXBKeZvXu7mPr1zMgGE0otxsTUIHDoqeqB6eoAXz06S5k
	0MCT487+RQ81CzcAQTQJbDc11JbQjKZA4vuXXoDBw
X-Gm-Gg: AZFdTZd60cKjDfrQ9z1oJSoNhCbFtlWQ1o2WKwAFQ8NGR4trTOZrEGIrd8BnaZqmV0/
	f625VEExq4RP8FCwAasPCGVHwmhjoYaQ7vB06X8WB/+0gC9Q4kYTQiY+gps0BgqPUG3de0Ew9sK
	NUyasj6nXQHN43QVzm9Uh9zCXc6XovLV5esHnUv7C55IYrWzMoeKHRB5SArBNcBaTtE+PvpEVhP
	PKfo8BTcXR5OdlQGr+xRHhgwEARsEKnRqt6W7rYC7ZcRKl8T/jslLq28n49OarDe17DGn0FeXHC
	dzTNCbJAzQaRrD6BrmF87UoW7aTpwF3WxvrKIQV6uWlFZhfjYVGETMLbbeZjdnvTaicS6PbQSBi
	bfRZDO5ZBiymAenVi7lEbiWZI9Fhp3IFYJ1sAfhL1GCPCYV7j8bC95Ls8vGb7P7KwNA/Yc7uvEj
	sf7hMJ3zlxNpDeCJCUP0sQnNdSdjTx0bhnXiUGDU2HBsRv7o0jmBk=
X-Received: by 2002:a17:907:608c:b0:c2e:6a4f:a88b with SMTP id
 a640c23a62f3a-c513a1f5c8cmr1559863766b.0.1795622994038; Wed, 25 Nov 2026
 08:09:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-7-jthoughton@google.com> <CF94E7D7-87D2-4523-9343-512EE00094FA@linux.dev>
 <CADrL8HW8+eFt5f1VBQ0zt-ioiU3X150W4ROaKf2Nzw4j9+0i_Q@mail.gmail.com> <09A53080-61DE-472D-9A37-38B524C76FF9@linux.dev>
In-Reply-To: <09A53080-61DE-472D-9A37-38B524C76FF9@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Wed, 25 Nov 2026 11:09:16 -0500
X-Gm-Features: Aa3M54o_hFax3FlT4U3L1WrxJk7av4zfqy7DgK21ApX3Y58oo7HyZderBGv4ryc
Message-ID: <CADrL8HV2m6DO=r-mezNONV_w0BtrN1_7Wph+mHUsAsYBf5FR2g@mail.gmail.com>
Subject: Re: [PATCH v3 06/19] hugetlb: Optimize bootmem folios that were not pre-HVOed
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C6D1100013
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: ppmhkwcz3xh9tchkj56wbep4n9gt6b1d
X-HE-Tag: 1795622996-521910
X-HE-Meta: U2FsdGVkX18YVOZc0RdMiL+SSLuzOhwytpvWXHr0LYNgmzzCK2R7Y/dYhJmhqyN7k6kuguukhPGJ2SgD+Tz7xgJ0W4XaZCgpC+PSrKiMBlJYbuga91g8fcHVkuAClgG2e/ttKUAsACUjDpACc3aK2yI816bpxJJ4Li/8YWmixmpzVyUFO/g/Q/TN0h0bgcnkuuUbaGlcC++wv0m+s+ltb/UtNjHEYi9NoQT3jjhbxbu+XpSzWXVH3MbhDYQI49dNzwaEtTqyx0GsSqd+J+7LHqFmK79fioaAqqrpW3mtawnjyJMCXBowRIFWeI+3BAUSSeSYmSy+wLumUg3rECCCzEFmIvksL+Ao8BxtXxN64yYhdNYPZAxX6shAVMb9w/m2HdoLWm+/Rf4TWVvhT9HUkxgUSo14toxlCJBN5lU3vK0d7zJwFmCwHfHwP3UWkFfzKxyrU0CPmfkIUVuY9ozQwaHz62D03bbBT7fQOJX8e4whkgym5+lw0wtxqTa10OqDoau1Fz6sMR9M2AmBKWYDWLnX0nAWAOfrYv3pnB9ZXpdL05xwROmkFScOQdUCgxeCujZgtVebPreiZAD5uxRVbdbBx6J/qKvaQ7uB3u2MOw1LeBMl/R57iD73jVwNSWVbyJQ8VOBfCMspzzvFOjsoi6b8ePxuxGoQI2Tau2kB/FA2A0VB3Fw0M4J6dYpwEqSqtNIQh6E3sap26vIeSOLF+FumnmZraj/5unOscio4b3RgD2q9xDvjlDkuukehOMmDY4M26VqbDZeCpbtUdwOd73U0V4tK/beFoSMITwxX8HVi+DAb1gdnIR8am5G0BQ+QqGIsNTZ2op8OktJkFDZVVUBI5EQ1ueuUE57D+YGPiffd3aIQZFo6qzprTpfGHBEYh/MxQ7+KodtiKvWNLVW3d2Zj7LG9eJrjC0ERo6UsWtuHU3XKZT4n6E8vufENJ9rLZfsC1koRkaoNl64qT+M
 200bJNXR
 5vtasLf/bTPIi6midCNiOaCOBXLGtgpLQIYrazkBRqVnPYr8t0qw7ep0g+epOCgRUTD72p0qXInJ68CPuIpiImNIDyvTn5L5MvLRXERQQ0cGdyYpWMerMy3e04kBQTt4NnsVPyk2SEmWy2rkVLHFSUwcL/VK9HSpgxZTeTrqo8TgXC6LcYhuw3Ur0y8wnZxZo/vyuX4535V2mGSkLgFEIUHhrWcIjknx8wrAfR09CoNo//CQq99Z13Ak3JZJgk32X7AlQ6lCELGJ3B2mwQbivOIbGNNZxm52plqGvPmERZg7Cf4BgFbUi93SvF80/cbFt6QiQzLjY3Q5au59A/ZetBkYxcanf3IGKpAT51fBzLO7tzms6a5JklCikBY3Hqr0pUMv21yw3Hxo4RuEn8faXD/UtCvPow4WulT92hJIr7Dwdoddh/GSl7cX3kxwUnNAiBz6ulBmK/Tfp5qnFA3/hJ3pQ9uFitfBxJMxeub9Ac0x/QysIMXuNWF/viwuzkGg66JoctAXVR9WPH/70U8LBAG06Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 4:37=E2=80=AFAM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Nov 25, 2026, at 00:58, James Houghton <jthoughton@google.com> wrote=
:
> >
> > On Sun, Nov 22, 2026 at 10:11=E2=80=AFPM Muchun Song <muchun.song@linux=
.dev> wrote:
> >>
> >>
> >>
> >>> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> wro=
te:
> >>>
> >>> Boot-time gigantic folios are expected to be pre-HVOed through the
> >>> section-based vmemmap optimization, so the bulk optimization pass for
> >>> bootmem folios was dropped.
> >>>
> >>> However, arch_support_vmemmap_remap() may not yet
> >>> return true when bootmem folios are allocated (e.g. on arm64, where
> >>> support depends on a system-wide CPU capability), while it does retur=
n
> >>> true by the time the bootmem folios are gathered. Such architectures
> >>> disable the section-based vmemmap optimization in their vmemmap
> >>> population path (see section_vmemmap_optimization_disable()), so the
> >>> folios are not pre-HVOed and would never be optimized.
> >>
> >> Yeah, when I removed support for this part of the code, I figured you
> >> might add a new patch in the future to add support back. It is fine.
> >>
> >>>
> >>> Optimize such folios when gathering bootmem folios. Their tail struct
> >>> pages have all been initialized by memmap_init_compound_page(),
> >>> as they were not pre-HVOed. Pre-HVOed folios are skipped by
> >>> vmemmap_should_optimize_folio().
> >>>
> >>> Signed-off-by: James Houghton <jthoughton@google.com>
> >>> ---
> >>> mm/hugetlb.c | 11 +++++++++++
> >>> 1 file changed, 11 insertions(+)
> >>>
> >>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> >>> index 72839e98f998..8756c0206922 100644
> >>> --- a/mm/hugetlb.c
> >>> +++ b/mm/hugetlb.c
> >>> @@ -3325,6 +3325,17 @@ static void __init prep_and_add_bootmem_folios=
(struct hstate *h,
> >>>      unsigned long flags;
> >>>      struct folio *folio, *tmp_f;
> >>>
> >>> +     /*
> >>> +      * Bootmem folios are normally pre-HVOed through the section-ba=
sed
> >>> +      * vmemmap optimization. However, an architecture that can only
> >>> +      * determine whether it supports HVO after bootmem allocation d=
isables
> >>> +      * the section-based optimization (see
> >>> +      * section_vmemmap_optimization_disable()), in which case the f=
olios
> >>> +      * were not pre-HVOed and must be optimized now. Pre-HVOed foli=
os are
> >>> +      * skipped.
> >>> +      */
> >>
> >> I'd like to condense these comments to something like:
> >>
> >> /*
> >> * Some architectures do not support section-based vmemmap optimization=
,
> >> * so their bootmem folios should be optimized here with folio-based
> >> * optimization.
> >> */
> >
> > Applied in v4, thanks!
> >
> > Also just so you don't miss it, would appreciate your thoughts on my
> > reply to Sashiko's comments on this patch[1]. Let me know if you would
> > like me to do something different.
>
> I think the diff below might be a bit simpler. You might think that when
> HVO is turned off, it could still cause some unnecessary TLB flushes. You
> don't need to worry about that, because I've added a global guard to make
> sure it doesn't happen. Take a look here [1].
>
> [1] https://lore.kernel.org/all/20261124110530.3004071-3-songmuchun@byted=
ance.com/
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index b2c14f4f99b7..69a7d4ca8b1b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3345,6 +3345,7 @@ static void __init gather_bootmem_prealloc_node(uns=
igned long nid)
>         LIST_HEAD(folio_list);
>         struct huge_bootmem_page *m, *tm;
>         struct hstate *h =3D NULL, *prev_h =3D NULL;
> +       unsigned long vmemmap_unoptimized =3D 0;
>
>         list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
>                 struct page *page =3D virt_to_page(m);
> @@ -3368,6 +3369,8 @@ static void __init gather_bootmem_prealloc_node(uns=
igned long nid)
>
>                 if (vmemmap_optimizable_order(pfn_to_section_compound_ord=
er(pfn)))
>                         folio_set_hugetlb_vmemmap_optimized(folio);
> +               else
> +                       vmemmap_unoptimized++;
>                 section_set_compound_order_range(pfn, nr_pages, 0);
>
>                 list_add(&folio->lru, &folio_list);
> @@ -3387,6 +3390,8 @@ static void __init gather_bootmem_prealloc_node(uns=
igned long nid)
>                 cond_resched();
>         }
>
> +       if (vmemmap_unoptimized)
> +               hugetlb_vmemmap_optimize_folios(h, &folio_list);

This hunk needs to also be added to the `h !=3D prev_h` piece inside of
the loop, otherwise we could miss optimizing folios for some hstates.

I prefer the early return that I've re-applied. It's a lot more
straightforward for me. Let me know if you really want me to switch it
with your suggestion.

Thanks for all the feedback, Muchun! I really appreciate it.

>         prep_and_add_bootmem_folios(h, &folio_list);
>  }
>
>
>

