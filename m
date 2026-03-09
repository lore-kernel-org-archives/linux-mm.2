Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF932F3C254
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222EF6B0089; Mon,  9 Mar 2026 09:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CFE46B008A; Mon,  9 Mar 2026 09:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0BE6B008C; Mon,  9 Mar 2026 09:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EADDC6B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:23:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74481140194
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:23:51 +0000 (UTC)
X-FDA: 84526592262.26.CB1DFF8
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D52140009
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:23:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FoefJVmS;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773062629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVfZ78yDnatNVZBoDLVVX+eWnnKKBNvw3ekxWv/ysDw=;
	b=Jdgoqv9ElSU3wYCRjlhNTCWneKmAAiyaZF4h5BdgCJP5KjF/RLkss4trS3RvEM0sSV2qWl
	azIg86OfkLfXErczVwJEZlNjsdGEiNHPSB1vFLh3vF9JLyQUmeu4JpPMByQm+jTJIRfJlA
	XqPmF/PeTwDtwnrSrTIN07Cjrmhy0nY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FoefJVmS;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773062629; a=rsa-sha256;
	cv=pass;
	b=GkS8VuD2fut2L4rlXfUMvy3F0nZSGhOk05dFaVi05dSIh6pcFXtW532gKCoeK+K6vU5hiq
	L2rj+CKx3e+sL58vmsHUGHqX9qEMkSmL3ecbC6+RC6wuyt+8pvhuuH+4OgMqZYagfAa3Jt
	ZgsVdvwAcnqCRJja99ypWcW/GaBmoG0=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-660dcafc85aso9709226a12.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 06:23:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773062628; cv=none;
        d=google.com; s=arc-20240605;
        b=fkjHaiPhtDaE7gmOb5lw65XXoPQghj8UFhF5Gd67whZM7P1zdAft0ZXKdZvUOPRqFJ
         RecORM6iOqXSHAmdmtmqUr6ihdsVfVksVl/hZdL/5Qn7MV07Ee/NIPHB77FBOnSpcsH4
         G4xCe8qQY377kP1hggaY7akcDnfXp5cCPpoTSE87gUFaI+xVFDsiLqh2QGvOwJ2aN5qu
         9Rq23SH/EWynBUgsG0+n2vh0+8tFar8rQdI0vvtZis1A1TE4BuNqFFUYkF5V8mMuSKa5
         gB3u69ls9nnLmLPyQNqMmkEmmPEnC+vMwY3Th8FL82Rd21gEJ19jgK4LZAiVUGmKd+Qm
         JxAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BVfZ78yDnatNVZBoDLVVX+eWnnKKBNvw3ekxWv/ysDw=;
        fh=ndVUT+8MUdebgJreP6H4oaU5MMlFF1LTeh6CrPGnzXM=;
        b=gzwiuyF07FL7GLCyUq3ZjBvGSG2YrddPat6oCDILJKAqY8A5CA4ld+R17z2FW8wvIy
         geW/RFuToGhHs6g42ISJXB9D4vV0h5yyDuun1xe8oZhkYzuRHwlluijZpQP0BxKkA2zK
         3aIAPQV+oS1xJsHFKUZazB3UPbYbU5eD9jsnOwP76wtMPAEPVYXgSbWtP3YGz1aEsmwV
         3B4fhNqbUn5fZggYTltTjGVJTf2bjWKYC7yIPzQUVSIucVfHrB3ykdZ/BXbygsbQd5fa
         oPDQecs/E2DIDRD/uF1tHczQlyVCoUWdJrrwo0UBvdphTzRa3oRqi2i+u7n99pMsBUpl
         NBZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773062628; x=1773667428; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVfZ78yDnatNVZBoDLVVX+eWnnKKBNvw3ekxWv/ysDw=;
        b=FoefJVmShSMdMGPq/PI3Yy9or04MNfx/x6xxCu3o3X2nKpQSuxkPKfCovyiSAekqBo
         /9f8dHyXPA+yC23K6/AjiROwHAYs5QMnrxYd9KqIELsRcRlAkFu+bhhpMa/IO4JzFWOm
         gHhq4e8hWEEfx/llH5ZsbU+7peTX0qat2856rUM8w1dE0yEcGjLaoY5amSKVGHkNMzXs
         BCz+5dK+RbIzKoP5UTJUOB0ADDPUtt5C+5B0nbSI9ZZhisud0Lk7SfxPhWL/JM9xQ8Ac
         Qxyn4rz9mo2p5IB5DKjc55hWjT7vVLNwjlgRRTU267/B7s5i/P/5evfMbxLmAtQAvSws
         QCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062628; x=1773667428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BVfZ78yDnatNVZBoDLVVX+eWnnKKBNvw3ekxWv/ysDw=;
        b=p3LFNqqrGVkEOFK4LphfQlv4jmckhzH6Hgkp9mR4kZ2BvZptyRMV5DinKxg5QXIplI
         qzL5ZFlOAr/WInNzcNNVmw/MuUg8/ldgrs3xTnqIx74OyoaUrQTDx4IHUwBhOhV7YVBE
         B5T/7evJgv3mkTaTuL6r9GJfFzStokFiHF/hGsKDUV1r05O97hHNq3ivI0PWhgps2IBv
         UcKMAwlfKdugZahUQfedPlruLJKT/T7906YQ7Lr/k8wiKXqarsSTv5CoaGkdbq8aihFF
         fzmP32i0nFJRY2bV+tV6A6JGuK123PtE5xqw/jXPhysd14t6JHFltirE+1v7BP8r5yMj
         EsjA==
X-Forwarded-Encrypted: i=1; AJvYcCXEgxVnPoABd08ed5aBz8FAfhwiRoh5jmzecMh7g3eNXjAyEeo3qYJHStCjoKK8DCYI/qHgonC4NA==@kvack.org
X-Gm-Message-State: AOJu0Yx75QLcB87kg2fFTRYsPQcEvX8KQgIQZqbaGv8BveCHZEZesT7S
	h3voAErlrECYxjp8LuDcbC3MhyGgGOjls2lmZPXFzkBXRXuqRlw+rCF4SLgpESD9alOyylzFLp4
	owul/HKhKzuQ6KobO1hP9+ZFdB9YiWys=
X-Gm-Gg: ATEYQzyqjcgd5Hl5OsbcuiS08vgWdQ6F54hRSAYlft/lOFjrjoVIfK/8HqtKI5vjxzf
	9RfePNPJorE6FhT6nNXdhYirCxDuAWN+xX/H/Q/5zn9DCdyGg7pCnUcJLuWmBZzWMo1f8BC7Hvq
	wzmca4VgBuDb7crBcIcFBNPyD3QVALcP7iNuC8LloGjH0iDJbLoxOIbZCUwjXeqUosOWuTlEW7N
	kfTGUd2YFlDa6/3v1ZXfxGwu48WzQwt5Pw22KL/dIpuEhVeITmYOe5ZfDPSTNJ0YYYGPHMyd1yB
	B6SaMjyYQ0woGlD/ZfwlXPD2R7Zicg2xv63gBHH7
X-Received: by 2002:a17:906:2091:b0:b97:f43:2a84 with SMTP id
 a640c23a62f3a-b970f432db8mr2809466b.19.1773062627568; Mon, 09 Mar 2026
 06:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773040982.git.zhuhui@kylinos.cn> <25c1be6b4a54a69d4b57189fd84c7502c4412d7a.1773040982.git.zhuhui@kylinos.cn>
In-Reply-To: <25c1be6b4a54a69d4b57189fd84c7502c4412d7a.1773040982.git.zhuhui@kylinos.cn>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Mar 2026 21:23:10 +0800
X-Gm-Features: AaiRm53n_u7_yf77ezKmiOFHGhAYIMKmmLQGkpctkAxwDIibfYQxACor-ZenX8o
Message-ID: <CAMgjq7Chn6B1bUiqoMiZLajqtuH9_7sQgxtdug4SQbcdwkxurw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/swap: Add VM_WARN_ON to isolate_lock_cluster()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6D52140009
X-Stat-Signature: swcqh1ogceucybpz5h6swagzx7scxpbc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773062629-50078
X-HE-Meta: U2FsdGVkX19b6uYOcZqbYkd3z07uM68ro83m2KW60ZKijdznVld3CglJP6uyNhbbyi0oLLHR/ZVZH4AWjVN2i0Tsq74a498SQRnlA2Pp7/juYn39AVj2Kvmwz7tB3eBEUI9PRziLdhItsh8ddceZt7dOWrY6zgu/JOM5lwHitpkx48+2mjCkIOTPZxhu8UFByeoePsT0EtXbJO7wiRH4XIzkapEjlVSuPjlmta4KQyT0IUgy7wdrbEnn3djMmqkC0dYlSX9x0GPUI2g3OrptbgcNC1JyE/d4MXHa1yH0lRD5XV7/xvApEguVwwYqyP8rc8Lv64qGq1KMrcHds56URgJeOLSnWAKe1jfwu8domBS/5DYm7PxOvOfQegT/ag2EbuN5BhN0YR0rfRkcH7FGcbnGnosVT6sXdmt/wQNtbofRSJmzGoTe+0PFBk/2SrgoGWaxGM/NFhN/vASAllgu+72d89CIJCpyAOZumt3hftUFM46jKOhU3i+8z1f/7HWzFkMrsl/tpWI1x/9BCpzYspiyzT5o9cTDO3RHKPvygB9Cis1Y4OetxRMpZImluI5gWC1wclocghI+i44rP3PpExFW2rIWCHBe6/q9P8pXyvItmsREzV97iC7UeXpnqA6rSB5+TIMy2hRTKe8x9zOyeFDURuTMtAB1DLGy3xZmrhxdxrRepwDZUpEyF1qnlY+VRAW8D1r2DI79OmoOl8VQ4Cd2xMHbyHKlhn7+AYRqMv4SG86GfXRBVH/ohoTP1rPqjub9JVEzfJF9HUtOrA6J0KdksZ8K8HYC+wFG7FujFmGKIIyN5FtIx39cEd2DHSU7CLbPvtAjk1zEGNYkwemSrsY6HT1lvpMkUiV1K2mjNt7chM1VmpMHVlwaYmnuHldHoO1q2Jdp/vpevwYAuOS9Do+j0yHOZysG0Tt+RkzhGLL7fS89a7kDngU8BoYQk56EfuNCEZRADcIKcSV0qIY
 ZSGVIelZ
 WczzBE20YtR2K8QarRtj7o9pwbAD0VZ9GA84wSv7HXSlfjm6Z4CBIcw7yB0DEz6mThOfSr6maTmA3SpW8KEydEv0T/QFXvBC2lUJqwFZ8aDFS0Lrz+lMcdJlujM5PHtNiv+GLcKS7NdHB4lFEuA9/bZD5S1bHQxQFnkb1tRn3cOomUR0/HISFLrdvg1PQtB1yYxC8pRl4NZn7Ffajke++wu6F1qPzlB4ublEulYNZG3lZ25eieXwlgevQP0NSjd6Wrdg8PP8EbxvoDygGB+JmtrcrMp+82y1aWKRWKTpnoD8KLCiwMcGwwxbLy1THtq4Jr4zyl8bKGTI5GcDO4dzQQkWiz9jUiME0oxFPOmcXXDQzldiK8guT9Wboi+o3VwhBTfvjc56HV+ATCN4Cl+Apw4q0/LDW8aHl3euB3NsEWvevq1xkGp+Q8grUHor1ZL6HreNm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 9, 2026 at 4:06=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> swap_cluster_alloc_table() assumes that the caller holds the following
> locks:
> ci->lock
> percpu_swap_cluster.lock
> si->global_cluster_lock (required for non-SWP_SOLIDSTATE devices)
>
> There are five call paths leading to swap_cluster_alloc_table():
> swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> ->alloc_swap_scan_list->isolate_lock_cluster->swap_cluster_alloc_table
>
> swap_alloc_slow->cluster_alloc_swap_entry->alloc_swap_scan_list
> ->isolate_lock_cluster->swap_cluster_alloc_table
>
> swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> ->swap_reclaim_full_clusters->isolate_lock_cluster
> ->swap_cluster_alloc_table
>
> swap_alloc_slow->cluster_alloc_swap_entry->swap_reclaim_full_clusters
> ->isolate_lock_cluster->swap_cluster_alloc_table
>
> swap_reclaim_work->swap_reclaim_full_clusters->isolate_lock_cluster
> ->swap_cluster_alloc_table
>
> Other paths correctly acquire the necessary locks before calling
> swap_cluster_alloc_table().
> But swap_reclaim_work() doesn't need do that because
> swap_reclaim_full_clusters() just isolate si->full_clusters that
> the tables of it must be allocated.
> Then isolate_lock_cluster() that is called by
> swap_reclaim_full_clusters() will never call swap_cluster_alloc_table().
>
> This patch add a VM_WARN_ON to warning if a fill cluster will be handle
> by swap_cluster_alloc_table()
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/swapfile.c | 3 +++
>  1 file changed, 3 insertions(+)

Hi Hui,

Thanks for the quick update.

>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94af29d1de88..3fc2eb30c187 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -596,6 +596,9 @@ static struct swap_cluster_info *isolate_lock_cluster=
(
>         spin_unlock(&si->lock);
>
>         if (found && !cluster_table_is_alloced(found)) {
> +               /* Table of full cluster must be allocated. */
> +               VM_WARN_ON(ci->flags =3D=3D CLUSTER_FLAG_FULL);
> +
>                 /* Only an empty free cluster's swap table can be freed. =
*/
>                 VM_WARN_ON_ONCE(list !=3D &si->free_clusters);
>                 VM_WARN_ON_ONCE(!cluster_is_empty(found));

Hmm, now as I see it, we actually already have the "list !=3D
&si->free_clusters" and cluster_is_empty check, adding more debug
checks seems not that necessary. Or it might be better if you check
ci->flags !=3D CLUSTER_FLAG_FREE to be more strict? I saw YoungJun have
the same idea here. Also you might want the _ONCE version.

The later lockdep check could be helpful, but for chores like this I
think having one patch is enough if there is no strong reason to split
them. These two patches are all hardening the swap table allocation
path with more sanity checks, right?

