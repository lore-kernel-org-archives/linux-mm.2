Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC20CD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 01:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F316B008C; Wed, 10 Jun 2026 21:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F816B0092; Wed, 10 Jun 2026 21:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13DF96B0093; Wed, 10 Jun 2026 21:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0079C6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:39:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C1521201CE
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:39:17 +0000 (UTC)
X-FDA: 84865923954.12.D63B1D4
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5DF2440002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:39:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EJ3tXgci;
	spf=pass (imf01.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781141955;
	b=o2Q7y20oAIzEB8QYfqGdwK7+frh8A+g0QXvcO8tJRDpfoUKie+P/ydVrCewqWMoJBqSdQ3
	QzyoGX2Osl9OkgrQJ4im3kP7/luBCuZg9sorqhprQusBXh7w28CM2q3fMgX4ocF7JLZ6/Y
	TWuE7mw5wTOinGDWRjY+K0WaRCLw14U=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EJ3tXgci;
	spf=pass (imf01.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781141955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRt+3gVTS+aO29hVg9vlY9eBck5THStRMuRUxXvk9fU=;
	b=0doGkyHu4kSFao4u3dt9aCWzCOvpHhrQBSGlODGELQFtWca54U25MHMy0+PkK1U/qxjwIu
	JksbVZGHZFoO6aRQw2ffnt7Ysm9EACSIDHwdhckKxKfuYKkBA3t3LjsI4/S22rCwRVpSNl
	R//ovN7fZD+T+iNJgwhpR6pPap9ry3w=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aa63adcb01so434329e87.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:39:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781141954; cv=none;
        d=google.com; s=arc-20240605;
        b=iUHU8f+RY+JE/8/WQs5qB/5vGwqIU5ISpSFf/a3vE7vMZbLoDkpOD3NunDkdXIUrYF
         q72jeRc3zTMBdCWNyTYev28EGn7pP1oy6Q+FT0t2oCUCTHTjAJ5O8jp8pjwCvQC2NdYq
         0l2CJrPyHz+yfnEMvjkbL82jdjShKfho4vxY8CaEoE5WBm16w2yPc2D3veln3cnmczeq
         yjQRg/YZoVPiATHPC881xAU8J1DdAGYH1pxaKvuAfWK0B8OHCNQBFnutmBpLOn6o1w0r
         gVazeLHklT+ho5+ViVNlbx+l7/1klM9tMG/slr9F/CBsoIiJv8NbnZgRmNTqiOdJn4wg
         wdbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FRt+3gVTS+aO29hVg9vlY9eBck5THStRMuRUxXvk9fU=;
        fh=Dhthc7ME10ReK1j7RXCLvo6NLdZcB5JEhZP+VMq7Zd8=;
        b=iqjDt78z3zzbCSsrV5f5qy40IDR4bj0x7WBzDkYrnti/+Qjjvmh0WhtXh36DJqkGxP
         5X9TQgbVAbSkMYAD38Lr+1qOXFdemjwUcqguPuAhi4gyVHKYR+VVdLY4Mn28cNf4SOgU
         hloT8DUG7aZ5lnMrXVyFyZkX07ledgU5AgHUSIDjIunWwJnr82ezJNQ1AX20kbStFGZC
         mlT11Ikr0wGURf5SDtHOTs3suKg0h+WB2UmZO8yh54L4s1TBYqmRhREI+4L6bmi3uzPP
         rw5+Y9kNsvCNfy6ePrLUk/2UFD5mRRa1TjyeqzB0WHH4kY79C3dNflV6t3ZigYT8SOEy
         dHSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781141954; x=1781746754; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FRt+3gVTS+aO29hVg9vlY9eBck5THStRMuRUxXvk9fU=;
        b=EJ3tXgcioMrd7IBKE4EJqQqC4oWAvTapPQVmZgo4Fp7ejl/5mVlqlH1DHnHyvs4s4U
         uSlWWqaHST/vKy/h6K4SfiRb4PwMUupndTqibfCWlmL6tsEMQ5wcz3q254eYLvbVUT5A
         AfTdtjGpfZIrA24nxC2mjrVOL6jriqXOy4mNMaw+/25nz8VwyzXlC0n+3slSyU/iYVSe
         8sAZ/rcStpwH0GhY4TYuGpExcNCUebk4jyFFGuMDlAHNYdpX/PSIst+Ih6bS14ChxLBS
         lTRJeOAIUMso668+30ymtBPGR0P1drIbQTdOtIIAnoiR3GxgPQwX2KVJ835RmvfcEwhG
         Q2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781141954; x=1781746754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FRt+3gVTS+aO29hVg9vlY9eBck5THStRMuRUxXvk9fU=;
        b=YMA9yWVM1v1mwjhZM2KZCkrOR34+s0aP51+jFytw2NP36y4NJMrBie56DrLZJ954kC
         rKogOK2L9Z+3bI/R7PGv4FVqxNMIJ9SzhjEuBErMRgWNA3qC9J+ozbAoAEAzPdMij4t0
         ZQLPi0MJ9iJ9f9IiGclbD88kLWWVaNJ72phTNGHlMbIlBc6vkLbscEpvO7dvyBeOqrVl
         ImWa3eR/6kfxIwU2KpthHmiX/UiV83h5C1M46mNaWWGLZ45KxOllHm4GIMNty+Sn7uoS
         R0QZaMKh7u7iw6A5++B4bui9kd6JqQFhlDfI6GZdxQ2SjtB5+pR10Jk1hL+jCRjqL2EY
         I5zw==
X-Forwarded-Encrypted: i=1; AFNElJ+06VeRDmW0bylZgkisudm+xmz3qhFPX+M9muwJNFC1UhM7/jsh6ehdwZrI4mpdVJuPj5B2cZXklQ==@kvack.org
X-Gm-Message-State: AOJu0Yxs7U9/TYpOyttTtluZ6+QjIV8G+m+RQEtUZDqAEugkMM4tJmgD
	6EClzMhxgsBpdc6Fj3xVVxa+8OwZZsdSzotsi696/kYaUhWtLjBmqInq2GiUf0S7VWqbIo2sduY
	4WunEV13ZW3wpDL09jtnqLzlSiL3w/NQ=
X-Gm-Gg: Acq92OEB4DLWPb2G1Yo0jDz5AJywI+vOKH+sUAKwBGkW2zw5XG9t0+JDTI4WKWtZeE3
	HAzhF5T9FPSwZYdu8/8J3781JTbJSGwvavDuETTlFu5cgxwEW6GV4La7Qc46Xc07Yp2xAXGQB2K
	Mr13EdpWZoNBzzbW86/xcRoWdzz4okl81xa3ZWs5tClXMNYWFWrvLwHRCuXELBZ/Si4PgS1v0vX
	2uYx7Yy/JPBUMXS/Dzq/qRj9PJncn1nNAqK8h3JDD2s7tn1cUnk00uawvhlvS38KjbZayHaC5sP
	XAxQirSTQ3OmY4coU7I=
X-Received: by 2002:a05:6512:230f:b0:5aa:7129:f2c2 with SMTP id
 2adb3069b0e04-5ad27fb9d03mr106346e87.4.1781141953238; Wed, 10 Jun 2026
 18:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org> <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
In-Reply-To: <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 11 Jun 2026 09:39:01 +0800
X-Gm-Features: AVVi8Ccsb1Cq78EwhyOLPrgzuEcYDO0Qcb9AgOY_gJ10YKz3_Mwt_awWSzlUN8c
Message-ID: <CAGWkznFQH65gJO=xvxZLoDGWLu7YTCnSyfoy7JdLKV5eY8qLzg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com, 
	"xiuhong.wang@unisoc.com" <xiuhong.wang@unisoc.com>, hao_hao.wang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5DF2440002
X-Stat-Signature: xs1yiqwhtph84mwrgkktcjmkh9gwm3id
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781141955-587445
X-HE-Meta: U2FsdGVkX18H7J0Owl5ioswYuxH37i6b5WZXAqCmd9lazNeCXwvRHrqHgMRxYxK8rko2WdS4jlVGQ4pYs2LY/QIchtXj9RD3uzRpM7Psu67Ko1+lnQ+poQWksWOCZ/bXchydUxoSlDrWT44OzYjRORaBduTiL5g0oH+hzNKuq5o4v37l9Hee2KLSuvrAwRWkRHEgeWkTGSTK7Mtxjmqb4vWvnolA4F+y/GZL6Z72sQW2Stuvibb1VeOxLygjkK3NjX5rVlb6GpOksKqi8EMwxTzUa5Fwo3V7mZsqS1MXNtgZ6UzKtCviMEoYvOov+HfjvIBeEGQZOSRWfn6XWFtFlHnT36jhPIX+CcM4crnyVWSJP0LSVi8PFvNaXmYYR4Loh0DUW+xWnNi230tgmpAjQ+qBO4W+ehvMDvStMTkQvq5JhLXHv6WTqJGHhXiHYzi1wAOngGGhsT2KJjb/GV7isnmXVYQP8tKc+MAXP8mnt++Ww7YKUW0Q7Q4ht+VKdJ+fMN1MdfywXbZmDhFt0TpcgeRAtgo9ym2q4+JF92giQb4Geh4/kPgyKAtntSRounFZ73DQe+UqJufso3GbtMQs7wjiPyzAZo3+TA2C2w48U66vqMNu7vFcI3IPQvO3lqIt1rAayR6zK4cVn2mJMvZ1kTDMaqtdLRQJfQRsC6uiBWhx6mWquNv+b042bJWkQR3YPyeD1DWchFLfW1zNBEZsPqO3Jg1k9axRcYdFRgcKktNs7Q1Y/yOs6kKeJO0/8lrq/dzQ1D3kodJ9U4cVfxbpte6UHQUEIgadgxhbte8mpeIek+1PDm8HFAj5KCmuTOEB1pCJTzUgVYaESpLdDU7Sn4+x1lRN60UxLG8RED8cg/3MSSbO5T4a46ASOAxvWnv2J49hpCM8LwKRpr5D0IWRG0PlGEtfdU70QsmGAiX+Awr0H243yPB3scuZfdvBvCJb9C/hyHWZ06xayZ2tKRv
 Nony3XX1
 jIP82JPJTLkhwBPHEejKdRJ0jrO/vJWm0dBw07L43sGiGeWFLqq1BTX6bvzarf6AHaO2lofKYZs1ib8ACw/Apj2CdetKFil7NjiefGYhpDZONkgP1kuyJ+d5XK+Aq6iTulppVWJHw8qPj9OjViaU0BNBs5tLi56ohcp+CBltkl0NxwHMUFaHV7qgiyX9b5/QDRp6i5AzTVOAQ4aWGjiSJ65aIbsGc0udBMeLyijcMzdMJYezUEXN2Ex1Ql9nwk/+MGWeJr2e2jpsBJxJ6AISDNkXm1YmPgksbjrUtzg8v4pnwqJFAhgMx232imGUhC/mJ3R+ESE1glpVB1iNjXA2+8gM7labGQgJKH6FD4uHUHsYkDojUrFnLn+A5K//lc5BcP0wNVSvRx7xV0ot7gtefjj1AreI4xadBOyIT8Z5+4HIXJ1OyNYta74W0OrmvnDuWgct0lBfxu9QgnBu74MbaN16PdKaQ2uejNqXt59/vwr0MQhpLm8384cxhmBodIVbqR+CtfwihaGct5YKAZQ2mvQTSJeaPaZR2lFXM9pSNYUmwu/nfirQ1MQ9YctL+vMJj5czP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 10:38=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:
>
> > On 6/10/26 14:05, zhaoyang.huang wrote:
> >> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>
> >> The kernel panics are keeping to be reported especially when the f2fs
> >> partition get almost full. By investigation, we find that the reason i=
s
> >> one f2fs page got freed to buddy without being deleted from LRU and th=
e
> >> root cause is the race happened in [2] which is enrolled by this commi=
t.
> >> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: re=
move
> >> non-uptodate folio from the page cache in move_data_block").
> >
> > But I assume, that other FSes can trigger this as well? Any insights?

Yes, I think all FSes support big folio could suffer from this defect.

> >
> >>
> >> There are 3 race processes in this scenario, please find below for the=
ir
> >> main activities. However, by further investigation over the code, I
> >> think there is a common race window for the truncated folios between
> >> split_folio_to_order and folio_isolate_lru, where the folios lost the
> >> refcount on page cache and remains the transient one of the split
> >> caller, under which the folio could enter free path and compete with t=
he
> >> isolation process. This commit would like to suggest to have the folio=
s
> >> beyond EOF stay out of LRU.
> >>
> >> Truncate:
> >> The changed code in move_data_block() lets the GC path evict the tail-=
end
> >> folio from the page cache through folio_end_dropbehind().  Once
> >> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
> >> page-cache references for all pages in the folio are dropped.  The fol=
io
> >> is then kept alive only by temporary external references, which allows=
 a
> >> later split to operate on a folio whose subpages are no longer protect=
ed
> >> by page-cache references.
> >>
> >> Split:
> >> After the page-cache references are gone, split_folio_to_order() can
> >> split the big folio into individual pages and put the resulting subpag=
es
> >> back on the LRU.  For tail pages beyond EOF, split removes them from t=
he
> >> page cache and drops their page-cache references.  A tail page can the=
n
> >> remain on the LRU with PG_lru set while holding only the split caller'=
s
> >> temporary reference.  When free_folio_and_swap_cache() drops that fina=
l
> >> reference, the page enters the final folio_put() release path.
> >>
> >> Isolate:
> >> In parallel, folio_isolate_lru() can observe the same tail page with a
> >> non-zero refcount and PG_lru set.  It clears PG_lru before taking its =
own
> >> reference.  If this races with the final folio_put() from the split pa=
th,
> >> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio()=
.
> >> The page is then freed back to the allocator while its lru links are
> >> still present in the LRU list.  A later LRU operation on a neighboring
> >> page detects the stale link and reports list corruption.
> >
> > Complicated mess :(
> >
> > So, folio_isolate_lru() really only requires the caller to hold a folio
> > reference, which can happen given that we did the folio_ref_unfreeze().=
 It can,
> > for example, be triggered by memory offlining or page migration.
> >
> > So we really want to not allow folio_isolate_lru() while we are still p=
rocessing
> > the folio.
>
> Or we should defer adding split folios to LRU after unfreeze.
>
> >
> > What your patch does is, simply not add folios that we will drop from t=
he page
> > cache to the LRU?
> >
> >
> > You should describe here how you are fixing it: "Let's fix it by..."
Yes. This commit would like to suggest to fix it by having the folio
skip the lru_add_split_folio
> >
> >>
> >> [1]
> >> [   22.486082] list_del corruption. next->prev should be fffffffec10e0=
ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
> >> [   22.486130] ------------[ cut here ]------------
> >> [   22.486134] kernel BUG at lib/list_debug.c:67!
> >> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> >> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
> >> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> >> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS B=
TYPE=3D--)
> >> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> >> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> >> [   22.488539] sp : ffffffc08006b830
> >> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 000000=
0000000000
> >> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: ffffff=
fec10e0ac0
> >> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead00=
0000000122
> >> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffff=
c080061060
> >> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 000000=
0000000058
> >> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 000000=
0000000003
> >> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe857=
21f0e25f00
> >> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c6564=
5f7473696c
> >> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 000000=
0000000010
> >> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 000000=
000000006d
> >> [   22.488647] Call trace:
> >> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> >> [   22.488661]  __folio_put+0x2bc/0x434
> >> [   22.488670]  folio_put+0x28/0x58
> >> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> >> [   22.488689]  f2fs_gc+0x230/0x9b4
> >> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> >> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> >> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> >> [   22.488725]  invoke_syscall+0x58/0xe4
> >> [   22.488732]  do_el0_svc+0x48/0xdc
> >> [   22.488739]  el0_svc+0x3c/0x98
> >> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> >> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
> >>
> >> [2]
> >> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 =
(folio_isolate_lru)
> >>
> >> F: pagecache refs =3D n
> >> F: extra refs =3D GC + split
> >> F: PG_lru set
> >> move_data_block()
> >> folio =3D f2fs_grab_cache_folio(F)
> >> ...
> >> __folio_set_dropbehind(F)
> >> folio_unlock(F)
> >> folio_end_dropbehind(F)
> >>   folio_unmap_invalidate(F)
> >>     __filemap_remove_folio(F)
> >>     folio_put_refs(F, n)
> >> folio_put(F)
> >>                             split_folio_to_order(F)
> >>                               folio_ref_freeze(F, 1)
> >>                               ...
> >>                               lru_add_split_folio(T)
> >>                                 list_add_tail(&T->lru, &F->lru)
> >>                                 folio_set_lru(T)
> >>                               __filemap_remove_folio(T)
> >>                               folio_put_refs(T, 1)
> >>                               /* T refcount =3D=3D 1, PageLRU set */
> >>                             free_folio_and_swap_cache(T)
> >>                               folio_put(T)
> >>                                 /* refcount: 1 -> 0 */
> >>                                                                   foli=
o_isolate_lru(T)
>
> If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(folio), =
folio) in
> folio_isolate_lru() would be triggered. Maybe we could just return false =
in that case.
No, isolate caller will grab one refcount.
>
> >>                                                                     fo=
lio_test_clear_lru(T)
> >>                                 __folio_put(T)
> >>                                   __page_cache_release(T)
> >>                                     folio_test_lru(T) =3D=3D false
> >>                                     /* skip lruvec_del_folio(T) */
> >>                                   free_frozen_pages(T)
> >>                                                                   foli=
o_get(T)
> >>                                                                   lruv=
ec_del_folio(T)
>
> But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T from=
 LRU list.
>
> >> later:
> >>   list_del(adjacent->lru)
> >>     next =3D=3D &T->lru
> >>     next->prev =3D=3D LIST_POISON / PCP freelist
> >>     BUG
> >>
>
> Why does CPU0 still see the stale link from adjacent?
The staled link should be from LRU since the folio never be deleted from lr=
u.
>
> >> Assisted-by: Cursor:claude-opus-4-8
> >> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > I'm wondering if this has been broken the whole time, or if some rework=
 allowed
> > this to trigger.
This issue is from AOSP with v6.18 which just supports big folio in
f2fs. Besides, it is triggered by the timing of f2fs's partition get
almost full during the test case of filling f2fs's partition(should be
the trigger factor of f2fs's gc which enroll truncate thing)
> >
> > I assume the issue can be triggered for other FSes, and we want Fixes: =
+ CC: stable?
> >
> > Looking into the history, I think we always unconditionally did the
> > lru_add_split_folio()/lru_add_page_tail().
> >
> >> ---
> >>  mm/huge_memory.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 970e077019b7..7465525a94a8 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(str=
uct folio *folio, unsigned int n
> >>                      folio_ref_unfreeze(new_folio,
> >>                                         folio_cache_ref_count(new_foli=
o) + 1);
> >>
> >> -                    if (do_lru)
> >> +                    if (do_lru && !(mapping && new_folio->index >=3D =
end))
> >
> > It might be clearer to write this as
> >
> >       do_lru && (!mapping || new_folio->index < end)
> >
> > To match the page-cache check further below
> >
> >       if (!mapping)
> >               continue
> >
> >       ...
> >       if (new_folio->index < end)
> >               ...
> >
> >>                              lru_add_split_folio(folio, new_folio, lru=
vec, list);
> >>
> >>                      /*
> >
> > folio_check_splittable() makes sure that we have a mapping for non-anon=
 folios.
> > (no truncation). end is then only set for non-anon folios.
> >
> > @Zi, any thoughts?
>
> The fix works but I feel that it is masking the race between folio_isolat=
e_lru() and
> folio_put(). I worry that the same issue might be triggered in other ways=
 or
> in new code if we do not fix the race.
>
> To summarize my thoughts above:
> 1. adding frozen folios in LRU might be problematic, since folio_isolate_=
lru()
> has a VM_BUG_ON_FOLIO() for it but still chooses to proceed the isolation=
.
>
> 2. the race analysis is not clear, since both folio_isolate_lru() and fol=
io_put()
> do lruvec_del_folio() if folio is on LRU. When list_del(adjacent->lru) se=
es
> the stale link, the folio is already in buddy and page->lru is modified f=
or
> PageBuddy use? So even without CPU0, folio_isolate_lru()'s lruvec_del_fol=
io()
> can do the wrong thing on pages on buddy?
>
>
> --
> Best Regards,
> Yan, Zi

