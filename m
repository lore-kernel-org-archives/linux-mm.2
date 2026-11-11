Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A82606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nwUM4nyk
Received: by kanga.kvack.org (Postfix)
	id 763DE6B00EF; Tue, 10 Nov 2026 19:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714896B05B0; Tue, 10 Nov 2026 19:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DCE6B05D7; Tue, 10 Nov 2026 19:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 224586B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:28:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93E631601AD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:28:06 +0000 (UTC)
X-FDA: 85420950972.18.94E91C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A16B640006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:28:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nwUM4nyk;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbBaRo/7L6iOQrhDinfNIJ3r1kvuz8qfg44WFld2veY=;
	b=qINEs7FmMu6IOJuWnVqSouXzKssOv3dOS7Pg5J6jlf9KkXcYKzovIrR/j8hBSJ8CFoCUyH
	Y5eIsRenbUoGTiZNc2VXSGE9YUDKifME9Dje62YjDl7T5AGlLEeIwhqCK6zOvPJwtiM8zQ
	y9O5DThenvlmZiUaIWs0DZaeHAtd5AQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356884;
	b=AdhZES0QbAjmvJUGLxY8yhvsxdQNsRe4LfKKDBYcQtTQuO2EuD7QI5ZvluQwJGwu9Zv3I2
	Tqnue6bIO2ntvKcBdtSY/ljvG+Vd2I6Q99L7TF2QaUyqjHoPERSROqTHeRuNERvkpHZWB+
	j0gOtknxbHA7h/bokEmQdZ0m10fb5CA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nwUM4nyk;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0DEF47333
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81711F00A0A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794356883;
	bh=bbBaRo/7L6iOQrhDinfNIJ3r1kvuz8qfg44WFld2veY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nwUM4nykXPopNGTyscZh/s7QXJS/OKgc04ASib+wR47Y2WPuiWkNkx/dQzj5zR/fd
	 KdpC2qkBAGTl8LwWYm/rlheh54DOzdjT9vxQyhOeM5znZ4AXE+cnNUSX80gcPLdQiw
	 8PcPac/FGedKA40KsOEC8D+7UB8oe/mJzwNSMqCrGJ6iP3Cgrp90Ap3foEn3bo53d4
	 428fKlQ+5H1/ZDRfOKnvB2pQ+1zpjfbG2/1IQ9HbOisOOFYNfPGl6NIor4BwbtH0de
	 8kLiFMwAGC5gB9G07ADVCmQnbYydJJDpKjuhai2m6JfkEk86PW4JlcpMLgRUw4PlOm
	 QzbFUP7+5OY7g==
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5eaabf28c06so1745452e0c.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:28:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFRtJShMhFzulmTBJXhiOTwnuYT6xUKiX6UwAowqSpNkXQ8oBl2oIIJmCIUz7JpNJsUhQmGfMsIxA==@kvack.org
X-Gm-Message-State: APuU4Z+xUHalea2wq6/pXAlEF48UoCDYvTPnaziiIHk0I5w6ngkEe1ld
	Z2UoD+EPmIrgkwX/9Bzmk7GG0l2ug1LOsBRHyoRWE4vxDBnh0IQKMbvvi9RNGE4++ygvENUfPmu
	VrMoz8IWUwuhZuaOWi0i2HKWkbejchFc=
X-Received: by 2002:a05:6123:64:b0:5ea:c98d:768 with SMTP id
 71dfb90a1353d-5ee1c3b55f5mr233673e0c.6.1794356883023; Tue, 10 Nov 2026
 16:28:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111000913.22943-1-shakeel.butt@linux.dev>
In-Reply-To: <20261111000913.22943-1-shakeel.butt@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 11 Nov 2026 08:27:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zRycX9dcW6P1J2R6f+xyO4+z6_LXz1i+qbNbMEnYm9uA@mail.gmail.com>
X-Gm-Features: AclHuK8i5C1ziLIFv7nuGyug3gNnUasxxchiBj9TPgocQ0U6mI78FyGiazCDdjg
Message-ID: <CAGsJ_4zRycX9dcW6P1J2R6f+xyO4+z6_LXz1i+qbNbMEnYm9uA@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: splice all generations when reparenting a memcg
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Noah Feldt <noah@feldt.systems>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5c5ttn7e6fbzxi5c4c4cm8x18faarbiq
X-Rspamd-Queue-Id: A16B640006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794356884-312350
X-HE-Meta: U2FsdGVkX18zSkswq1zxu8ZtN8qjoiighVswKTDVsT+/VHqF1qgy1irxvOqBKDizbSxMW8Qjm0TV7hKvjOmZdNyy0XeQ3nykdd/0gTmrcHbdoxvoEB70TAn4wR6pQ1iqoY+ydVNw1y6irRUOiQs40MFNYD7E9QkeqAYJYPi4T+g+IpuLaG+Y0p00CV3EYkD/0Oujwin6XLuMnkr9WNzcQQfWeiVe0xLsh6QnyiiH6oqO6+DeabIQ6xeY95QGrJDFmKBLv8VyhkEtMAdIkGRi8cU0/NmYVkexHUaf6Dkv5l/jav7gu6Z3j2os/1fgiarwLIJOpxjBySgAaKGesD4KmlmZIIM8bvytUoolzCvFNKh+j+/IKkccjl420E/iWD3HVOPOl2uD8Eb7c1wn/CiMT/Xmpr8S0x8t1Ze3+cTZRpVwsH1fD35pjnZ9Uxutkm5UivS4k+HAjtUK8mJkHAI0ZXu3sFt0bBrRNYTntllM+sV8MPzz0aPkTKat2eKnnb84qSZuy3EJG63lfVyISoWzkGH9uMIbSFlXFXuO/k+HC03dVtkd031bb/Y22dKfzOC8x3BDvWhdVhSOOoyNGs+JSsKXO3aAJaDBkupDCjt5o1E4F/LInzEAA/NLnK/GzY6XNMjva6pbwBlldaz8z9AWeUW2RVWTWF0GBiHi++uytoHJNZt/j7bzTMzsyXYFjF6jaax6fZnp4av0uXwJsWhht8ehmOQjcmCVKFRpfK0Fo65q7wO3ZCmLqqdtjd9eEZaeFcFyElQcGH9GVOCKlwrZ7ii36ILMEn94HoiYJbMqTrGKj4prtMUTmW6raK03u/MA9obrXOLsTi71fYI2GQCQy0mJJwzs1/XOvP4qaMkDB5Ygx/FTjl4kf5VqPOnELUsg1t+/YKPcQVoKGQi8DTpMoaLuUkxEiJ2r/RnglSH+1FVVHf04N5hGpyhl3Vv+Jk3KDAsfkTPyoK26+hQjFV1
 E+u8gYgv
 CoO+LG2bR0T8mEXmkVzy6mQo1dMfjneTk14nH521UjFzj9zo+R6ISUFBKUJeI453SbUF/7WpD0/M/qUB9ROCjpFXBvzkdnFykLK0pwcwRZ2rSGzqLh0NetOU72myZkOVluRKt5cpcfC5YxmG4TjZqoUNs+Kor8fQ/5YoLSaiyYzF8ohVBvydOD6r4g6hjKlCOkTN6LRue1i1Gl14dfd5xsoSWSwNGg0GvTeZx+8HW9h2uIfotz7HGRUqMOHLt9aEF+GKvnNQ1gIRvY7KHnxvQe7k5sE7GDv0PZh9q5n9LPmIBg8Z2MVQ3k6PrZcpu+dEmPP+RGu028y6Uook=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 8:09=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> Noah reported list_del corruption on single-node hosts running 7.2.11,
> which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same
> as its node"). The bad pointer is an MGLRU list head in a freed
> mem_cgroup_per_node:
>
>   slab mem_cgroup_per_node start ff31bfa36a3c9e00 pointer offset 528 size=
 1920
>   list_del corruption. next->prev should be ffacf881ccc70e08, but was ff3=
1bfa36a3ca010. (next=3Dff31bfa36a3ca010)
>
> When a memcg goes offline, __lru_gen_reparent_memcg() moves its MGLRU
> lists to the parent. It moves only the generations (gens) from min_seq
> to max_seq, and it puts each list at the same index in the parent.
>
> A folio's gen in folio->flags can be ahead of the list it is on. In the
> parent, the same index can stand for an older gen, so the folio's gen
> can end up older than its list. Once the parent's min_seq passes that
> gen, sort_folio() puts the folio on the list for max_seq + 1, where it
> stays until the next aging.
>
> If the parent goes offline before that aging, the folio is not moved to
> the grandparent. It stays on the parent's list after the parent is
> freed, and the next list_del() on it touches freed memory. This needs
> two cgroups on one branch to go offline one after the other, such as a
> container and then its pod.
>
> The parent always has MAX_NR_GENS gens at this point, so every index is
> valid in it. Move all MAX_NR_GENS lists, not only the gens from min_seq
> to max_seq.
>
> A reproducer that drives these steps through the lru_gen debugfs file
> gets a KASAN use-after-free on the freed mem_cgroup_per_node without
> this patch, and no report with it.
>
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Reported-by: Noah Feldt <noah@feldt.systems>
> Closes: https://lore.kernel.org/all/20261110132853.71228-1-noah@feldt.sys=
tems/
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: <stable@vger.kernel.org>

Thanks very much, Shakeel! I saw Kairui has exactly the same code here:

[PATCH v4 14/17] mm/mglru: reparent folios from all generations
https://lore.kernel.org/linux-mm/20261016-mglru-fg-v4-14-2106750c0bfa@tence=
nt.com/

somehow, Shakeel's patch makes us need the change earlier even before
mglru-fg lands?

> ---
>  mm/vmscan.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a1af9b92349..902616a3b755 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4751,19 +4751,25 @@ void max_lru_gen_memcg(struct mem_cgroup *memcg, =
int nid)
>   * The same generation has different meanings in the parent and child me=
mcg,
>   * so this compromise method will cause the LRU inversion problem. But a=
s the
>   * system runs, this problem will be fixed automatically.
> + *
> + * Move all MAX_NR_GENS lists, not only the gens from min_seq to max_seq=
.
> + * An earlier reparenting can leave a folio whose gen is older than the =
list
> + * it is on. Once min_seq passes that gen, sort_folio() puts the folio o=
n the
> + * list for max_seq + 1, where it stays until the next aging. If that li=
st
> + * were skipped, the folio would stay behind on a memcg that is about to=
 be
> + * freed. The parent has MAX_NR_GENS gens here, so every index is valid =
in it.
>   */
>  static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct=
 lruvec *parent_lruvec,
>                                      int zone, int type)
>  {
>         struct lru_gen_folio *child_lrugen, *parent_lrugen;
>         enum lru_list lru =3D type * LRU_INACTIVE_FILE;
> -       int i;
> +       int gen;
>
>         child_lrugen =3D &child_lruvec->lrugen;
>         parent_lrugen =3D &parent_lruvec->lrugen;
>
> -       for (i =3D 0; i < get_nr_gens(child_lruvec, type); i++) {
> -               int gen =3D lru_gen_from_seq(child_lrugen->max_seq - i);
> +       for (gen =3D 0; gen < MAX_NR_GENS; gen++) {
>                 long nr_pages =3D child_lrugen->nr_pages[gen][type][zone]=
;
>                 int child_lru_active =3D lru_gen_is_active(child_lruvec, =
gen) ? LRU_ACTIVE : 0;
>                 int parent_lru_active =3D lru_gen_is_active(parent_lruvec=
, gen) ? LRU_ACTIVE : 0;
> --
> 2.51.0
>

Thanks,
Barry

