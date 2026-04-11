Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 620B4F45A17
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 00:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A764F6B0089; Fri, 10 Apr 2026 20:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27046B008A; Fri, 10 Apr 2026 20:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C9F6B0092; Fri, 10 Apr 2026 20:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 848B26B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:31:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25ADD8C19C
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:31:59 +0000 (UTC)
X-FDA: 84644397558.04.40D49D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 50F63120006
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:31:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CHhAgAch;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775867517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXAVl5MTo9lPXoBvLOlzZLugWo5iQzGSHAXMUvRQ3Kc=;
	b=lHPBs78quwR36GTx/ZV0XLhIy7DDYiW5bzASQK/Ln4r8T1A8+Av77rtNZKKODOc306XrhZ
	y+CrwiRgxw6IwULrabuqqJT7ung5TdxHyl66jXKlYlZ/z5RzwUtwoj4gKSUllbnqFkG5Ib
	i5Ui1tneH3NLnckBYXBobD4IVlbGqp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775867517; a=rsa-sha256;
	cv=none;
	b=BeC2tYOAjhH71E7oyWotr9NhFfUWdGMHG70e8yU3U8QH4Go5r6cPkLt8mpvmGsCEsnHzQT
	VuObJZA3SDMdEKXAg4Hg87H7LiJKpO1+wjgoYPWNWuDT5P7kkClZ2WPHrxV2mTJIKZYBId
	5zL6R9nC0dLLCX8DCEyDgdFAq7YGdr8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CHhAgAch;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B1E646132F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10034C2BC9E
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775867516;
	bh=TlV1YI2kkqGUc5qx18YgOfk0OU4P0PHK3zJ/COqHi/0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CHhAgAchsaANbyxBUKzn4kPlwY5xzRomnXIeKPQnUzrGXNjlieKkWUCZDQngl15rx
	 e2iscTwkSwh9h+oXKxZPIGMsQYUoL54NpkVS8hpDmTPO7IBzLB29Xmh/jOOVcgPBs4
	 6iTwBEkZV+Gk03zC7g1k0t9hnoUv6oMSmb8G4Ah18EF42wIpLHaZL5SmlxRXFfPdkc
	 rn3LE9JO+guL27SCeCbSqapcC9xYxLiErRU3011u6/c6+w/S+FsZNDKVCY/BMHZFLL
	 Mkb1MhP5BkfMNBQsoq1gWsuVE3OthyX4+gwYfwOa8m4LM39yJIkL+Mubc/holdoBFX
	 kLAhLAm0G4n2Q==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899a5db525cso20286676d6.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:31:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV6SBN5N6yRvXaLfY0e5+MvnH6CHVXffqW34mhuk4BGIjD68odo6XF9n/lANQfcOqh/5RJhwHoUXg==@kvack.org
X-Gm-Message-State: AOJu0Yw4Qijhib1REy7Rl776XTtz6VqkgP2w7Zhtcim0k6W+S2/E8zLZ
	pUlGXhJfR+oRs9tSKd8chQsVaVXslVugO7zz09pVsZUxAq57YLtLj7R/qyn1uq68cW5c+amB1m2
	g2aDYqM2yzQMms933HDNeM5gBhSi25zA=
X-Received: by 2002:a0c:e004:0:b0:89f:97cc:b8d2 with SMTP id
 6a1803df08f44-8ac860fe59dmr68537586d6.17.1775867515155; Fri, 10 Apr 2026
 17:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com> <20260410-batch-tlb-flush-v3-4-ff0b9d3a351a@icloud.com>
In-Reply-To: <20260410-batch-tlb-flush-v3-4-ff0b9d3a351a@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 08:31:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yy5ZNA5PMw5ciUFoL55aboz2FfRf0=FN+yCuZ6eKXR+g@mail.gmail.com>
X-Gm-Features: AQROBzCfqPmip0o8WKRW1lgy6bnUNhnKUB_tAv6yoMPYWffisyzOIHQqVLCeBos
Message-ID: <CAGsJ_4yy5ZNA5PMw5ciUFoL55aboz2FfRf0=FN+yCuZ6eKXR+g@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] mm/vmscan: extract folio unmap logic into folio_try_unmap()
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 50F63120006
X-Stat-Signature: cfipmjq59jj39r14tfrzo9da9edgejiu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775867517-377998
X-HE-Meta: U2FsdGVkX18JOiar6jDGEjCZ6p7hXyKQ+ytddGTlFCBP76WZONyiLKGhGqjs46qi8SxvU1o+nQVvvpgODg91api8egufdjrf6ccvUjdlizYIhxvcw4N0uQFEUCQB1W+LjGLdPvEQVdy8KRc+xbXEoXp3H/TeoEy5M1LSy3gWC6p640IhmWDj99HINgltniOeUztB/h1k287vGpMwthC8x5nX0Pf5P0qsEB5JYS6LQbFDpA5l/1V9maENhQ0BgMkmne3r0GKYrTWfn8kQp6SDTAYtgVZrx85Hhld4Gce0DavAlkCVNwLbBYL9FgJRm6eRuAiDuxw7WxLauGjCoqxslLFr3YiVGKABaa5m3IFSPS6E6YrczxInNTpKCMDRlxb9wvSFDXqDlGBzqx6pDj6Gz8VpLfhtLEvB7JuIv0YqFEL9Z6LimFkfTcxqr0KCtreiWCkMGDeJ9qBfBfcw1k9oLBhFyNoizZknwy5ZCTu3U4TVVkmWbBKcAadh0blOQBLXrWkghumsaDHu1Sl/4GGD7wmEUHCxKL2FdqA8isLF/VuX6EMfu2cH1ccgceU6giE5eX16JDJsKzw+qqIUY738iYIpc64narQgVxCSC69ZTeFjeX5y5dMcjhTEt1NwomXoHmeDlDCLEESUzTQr+s9OolSY8f0wL4f5RnGblj3mjD55iamKtsOX082LTG5mR8ZwqJnzlPmNErZ2KhIAD7g6PgCRPH8a+n89c78ckpxphqtzentRxcbu6alrrdrbS3QH0i/47/Rc5p5tpKpLLf5xwfbDabVaqJoRWhecXxikBRQzmNOntxqJjD2WRQEtMwMbov3KrWhS5UA416BQ5eQ8bXuZRUgMp4RObiHXhbGuBiuMtjySTI/nd7jv4VSvjBbunm54+QFHOOcRwK2/YzMVY1+oItE0KWC/ZP84WfDVCnIkIRwcSxSugFsmyRFosQ6UXOlHtJ0lkz3TdlumKE+
 rL1MhSys
 Uks2grt6pobpNoqP95AWrYD1LyR+TOHpCnEGIsNvoEN8w2AReQnKJhevvWrlJXl28wmwdEeP6RExBvSjkthAAbpzveXF43nJ0eWHrcQKV2NNSMRXHxMyUFn8F/2UdlMwd8dyFxbsHG8bUG07lRD+pt0+RbGf/Lu9LTtsY+Fk5Ic++gYlPV22oT68YTDWkVa7h3lyZZMt5POQtR4gIzXyx7CUj8QXIX29lh7FJE6hqsu2Ja39Nz4Wthj0qqCrTrKqMnDqVm5BK9dZzt1XAhizVvlTl5Ca2aOA0XJoT94TgdewmoRDmmPNxYSPuw9+DmypLiUG+A4cywVEL1Z/J83Jf9/zLRF7kjOmFAw6TMf5f4QtFUhf18zWAobzlUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 8:47=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> From: Zhang Peng <bruzzhang@tencent.com>
>
> shrink_folio_list() contains a self-contained block that sets up
> TTU flags and calls try_to_unmap(), accounting for failures via
> reclaim_stat. Extract it into folio_try_unmap() to reduce the size
> of shrink_folio_list() and make the unmap step independently readable.
>
> No functional change.
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 70 +++++++++++++++++++++++++++++++++++--------------------=
------
>  1 file changed, 40 insertions(+), 30 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c8ff742ed891..63cc88c875e8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1217,6 +1217,44 @@ static void pageout_one(struct folio *folio, struc=
t list_head *ret_folios,
>                         folio_test_unevictable(folio), folio);
>  }
>
> +static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *st=
at,
> +                           unsigned int nr_pages)
> +{
> +       enum ttu_flags flags =3D TTU_BATCH_FLUSH;
> +       bool was_swapbacked;
> +
> +       if (!folio_mapped(folio))
> +               return true;

This is quite odd: the function unmaps, and then if the folio is
not mapped it returns true as =E2=80=9Csuccess.=E2=80=9D I can=E2=80=99t re=
ally
connect that with =E2=80=9Csuccess=E2=80=9D at all.

Can we move this logic out?

In shrink_folio_list(), we could simply do:
if (!folio_mapped(folio))
      goto activate_locked;

Ensure we only call folio_try_unmap() for folios that
are actually mapped.

> +
> +       was_swapbacked =3D folio_test_swapbacked(folio);
> +       if (folio_test_pmd_mappable(folio))
> +               flags |=3D TTU_SPLIT_HUGE_PMD;
> +       /*
> +        * Without TTU_SYNC, try_to_unmap will only begin to
> +        * hold PTL from the first present PTE within a large
> +        * folio. Some initial PTEs might be skipped due to
> +        * races with parallel PTE writes in which PTEs can be
> +        * cleared temporarily before being written new present
> +        * values. This will lead to a large folio is still
> +        * mapped while some subpages have been partially
> +        * unmapped after try_to_unmap; TTU_SYNC helps
> +        * try_to_unmap acquire PTL from the first PTE,
> +        * eliminating the influence of temporary PTE values.
> +        */
> +       if (folio_test_large(folio))
> +               flags |=3D TTU_SYNC;
> +
> +       try_to_unmap(folio, flags);
> +       if (folio_mapped(folio)) {
> +               stat->nr_unmap_fail +=3D nr_pages;
> +               if (!was_swapbacked &&
> +                   folio_test_swapbacked(folio))
> +                       stat->nr_lazyfree_fail +=3D nr_pages;
> +               return false;
> +       }
> +       return true;
> +}
> +
>  /*
>   * Reclaimed folios are counted in stat->nr_reclaimed.
>   */
> @@ -1491,36 +1529,8 @@ static void shrink_folio_list(struct list_head *fo=
lio_list,
>                  * The folio is mapped into the page tables of one or mor=
e
>                  * processes. Try to unmap it here.
>                  */
> -               if (folio_mapped(folio)) {
> -                       enum ttu_flags flags =3D TTU_BATCH_FLUSH;
> -                       bool was_swapbacked =3D folio_test_swapbacked(fol=
io);
> -
> -                       if (folio_test_pmd_mappable(folio))
> -                               flags |=3D TTU_SPLIT_HUGE_PMD;
> -                       /*
> -                        * Without TTU_SYNC, try_to_unmap will only begin=
 to
> -                        * hold PTL from the first present PTE within a l=
arge
> -                        * folio. Some initial PTEs might be skipped due =
to
> -                        * races with parallel PTE writes in which PTEs c=
an be
> -                        * cleared temporarily before being written new p=
resent
> -                        * values. This will lead to a large folio is sti=
ll
> -                        * mapped while some subpages have been partially
> -                        * unmapped after try_to_unmap; TTU_SYNC helps
> -                        * try_to_unmap acquire PTL from the first PTE,
> -                        * eliminating the influence of temporary PTE val=
ues.
> -                        */
> -                       if (folio_test_large(folio))
> -                               flags |=3D TTU_SYNC;
> -
> -                       try_to_unmap(folio, flags);
> -                       if (folio_mapped(folio)) {
> -                               stat->nr_unmap_fail +=3D nr_pages;
> -                               if (!was_swapbacked &&
> -                                   folio_test_swapbacked(folio))
> -                                       stat->nr_lazyfree_fail +=3D nr_pa=
ges;
> -                               goto activate_locked;
> -                       }
> -               }
> +               if (!folio_try_unmap(folio, stat, nr_pages))
> +                       goto activate_locked;
>
>                 /*
>                  * Folio is unmapped now so it cannot be newly pinned any=
more.
>
> --
> 2.43.7

Thanks
Barry

