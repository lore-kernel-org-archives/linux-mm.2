Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB01EC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 09:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602B66B0005; Sat, 11 Jul 2026 05:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4366B0088; Sat, 11 Jul 2026 05:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9E26B008A; Sat, 11 Jul 2026 05:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22E516B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:02:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9CBB1698B4
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:02:37 +0000 (UTC)
X-FDA: 84975905154.06.EBAFD71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B07344000A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:02:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ef2FR+jw;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783760555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOkIm/tUchk0uEoy9B7nPNLUugDa2OgwITZ/3YiqTI0=;
	b=zvTlNNC+wjc93UXyT+Qb2xW7sUzdqAVYRu6IuEKnBRr02eIQdCYb45D2pCub4MREaL3n1b
	DwriHE2AU7uKz8Xwc8pbNVBmNepb5mXGblBdTRdZWdqc8RvX52rBtyA9W6BrIXz/PHKbYc
	ViW2XampwQYnnmW8RMsXAzEsE1aMoIs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783760555;
	b=VF8SOHWr8oy0DQlN9xCzxvY9MTliL93yyoLG3/WqRjkWmvM4t8B9CV/eLdBb/eKJaF4stS
	sSi7eWTRci4Te2nqRuoQFEdO2zHT+/OOA3SlJM7c/ME8O8hCcNMYEmROpzUJUy7GN0FrNi
	BjhFb/wGC9Xa9DMKkETX5AyjeMq/IAs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ef2FR+jw;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7EE44369C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D501F00A3F
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783760554;
	bh=rOkIm/tUchk0uEoy9B7nPNLUugDa2OgwITZ/3YiqTI0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ef2FR+jwHc5t5wivvsp/Ye/64AXydZYrvaDKHAqNz3JG5496bA1QewKnT1tH4W227
	 jLphQyvLrtdiyfltoJoxR/apNq4sM0AOmbZoRSpR6BShpWlXSQAaUMOEjC22xARx97
	 vPNz4XPI458GWgMNsO2V4WMrRVMrdWi8vrWtz2Ixd2OtqnhN8hbRrmnRZ3PeAGYC2v
	 f45zdJDBuZv9qkWwdHxsWQ487/2UzXP6yYMz4Sxf/jd9wS/WxTINgEKS5Dvfz7rVyW
	 toASeUGpPTEZVRSjODBZ6JHCHe2Eisw5C4RwvDJh7xU6WbfCLBnFHFMblqSl716y6O
	 X9E13nsHpSsjQ==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-66628618509so2345643d50.2
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:02:34 -0700 (PDT)
X-Gm-Message-State: AOJu0YwAYLukSxWOeQLQL33WXx5vSQs4/JODw83Q+tfVCS+ltFusHtY4
	/i2nf7HCjWP+xYihpDL7RftbUSHXJTk2k1PMGlcWN3b8bwbB7u2J8zs8VtwcSHM43BfzzYuCd/C
	fmu5lWaS0XOYBrAbeXwWkbb8/J+DpHbWNyU/KRN6VCQ==
X-Received: by 2002:a05:690e:d46:b0:667:bae0:e565 with SMTP id
 956f58d0204a3-667d7b3af48mr1522020d50.30.1783760554102; Sat, 11 Jul 2026
 02:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <20260707082614.95030-10-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-10-baoquan.he@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 11 Jul 2026 02:02:23 -0700
X-Gmail-Original-Message-ID: <CACePvbX_rKqXnaH8vkx8baMi1bf+p=A_W5PhdYP9h=hGfcR_tA@mail.gmail.com>
X-Gm-Features: AVVi8CcxXPhM7OgUhg3WqF80vlADiJUkbByKcsJGyeeyeuqRslSvdBvzhV9teWA
Message-ID: <CACePvbX_rKqXnaH8vkx8baMi1bf+p=A_W5PhdYP9h=hGfcR_tA@mail.gmail.com>
Subject: Re: [RFC PATCH 09/10] mm/swapfile: implement swap_ghost_extend_max()
 for dynamic growth
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B07344000A
X-Stat-Signature: fpi8szkcnxdz3eocnxap8hqjqzeeahrm
X-HE-Tag: 1783760555-693065
X-HE-Meta: U2FsdGVkX1+AAWVBL8h79XcimDn1E+7Tid1cyS26rW3Zb+7cIf+r4+L+RWNcyjbMHv0SnKtcvmK5lWZBPSYVA+blGSrHfuS6DVnCRZWvSxCwsZ1hK0AtOG+Yga71yrCEupGY1CCmQ2DECFXYM0SSde3401zLbe40N0E5spbHpaZxXe8SQoQ8lJqN8IvD36yczeGmamPRdFrigiUHFOjXLGKhrestp9QeTnpW/IDvAN463z3TAacuPq5PwjI6xFiMS6IyGsvKSppmp8mbAvbOjZLdXRxWxBEnYgs67Y/WHXr7yzxS0Cb0Hw5g/O0VHrP+IwfLUqOqrntKSL6YAVgwK+TTYlX3MecgCeGdfxhbQyXbSCUwknXYlTcq+qBgZ/hkVxPJc97hGbGwDjEUBmSI26rlRIBUD1NPsDPgOeSrQ8DPMYGLIBnuYp6b7bd5qZ+3/V2/SiKkAR83Vv+V7+TtLgp8kqYtGVVcEW9y+z5rBndkIILs+BzK0k3tr7T0DLtvcNeiLk3TdV045cw3+WvEClflGMQ4vVwd93Os+tAxuzATS7bFEJb8AwgMiAtgZZb0E+Y/xyNBLmtl9RKmd9G9YDiMdpdLnJqLnu9g+uIwTLgcQJ0w5wHU/WHTokYokNFie6CRahzx3N/YzLsaHApJKAqThqQc+3/RhJxvCYEBCwHfIldvlMuUCutOv+j/Yaks31x3NLB7JkrI1tjlubi5S7XLnvBArGkLrjvROYBsyYx/Ncc/7xutTjT6Ade3icfETiOo7NvWMqzumYF1gRmwMdz8XMvwdduHSvXxjXiH17abbBTwXMoAyy8PwVN6d5sot5kb9kzWHsSzrp90+ZMCsFbbcmTPU+tdbvSm1I4GuN6l17StR5CZOoQ9lu6mWYvxciqYin2xzaBCmyVGXdLdOiYnCQMdi5xQFfjV9lKd1OQohnX+ejPkuGocPFJf36HrIagGWoNb4Ls8MZ/Dwmf
 K1916lrW
 w/aaPejYPq2dNH3nLDDYBwmbV0eCjIAidx5qZKFc1eVaD1dJlxfzglr0ccjfMEGOng3DTALzuD8SCE0h9HtpPy408L4AgLT+s63UogMb8IST7xHIa6kpQ4inW0Rvz9gRxBQInYdaZ+/XbkhJdm8pcZBXo5mFjHJzwIDdrU/VLmCpGsx4Y8FV9tqlttmw6WFJ7O2zklDq/DP9fKCWycug1GYUfPmPr1g6yOk8v30lo/2kjJjWNH/U98Kel9r1syE7WsdPdvODOaiA4xaMCjTuY9uOGdXqUA4FdvHvbqrmOWmdiK+Xw/JGXvWHBdK/JWDQJyaopLmDsiiestiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 1:27=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> Allocate additional physical pages and map them at the end of the
> already-reserved sparse vmalloc area via vm_area_map_pages(). The flat
> cluster_info pointer never moves =E2=80=94 new clusters appear contiguous=
ly at
> higher indices. New clusters are fully initialized (spinlocks, list
> heads, trailing BAD mask) before si->max is published via WRITE_ONCE.
>
> Page-pointer tracking in cluster_vm->pages is reallocated to accommodate
> additional entries. Returns -E2BIG if the requested size exceeds the
> reserved VA range. Extension is serialized by swapon_mutex.
>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  mm/swapfile.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 110 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index da085a75d7b5..8bf336678887 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -58,6 +58,8 @@ static void move_cluster(struct swap_info_struct *si,
>                          enum swap_cluster_flags new_flags);
>  #ifdef CONFIG_ZSWAP
>  #define GHOST_MAX_CLUSTER_BYTES (64UL * 1024 * 1024)
> +static int swap_ghost_extend_max(struct swap_info_struct *si,
> +                                unsigned int new_maxpages);
>  #endif
>
>  /*
> @@ -4247,6 +4249,114 @@ swp_entry_t ghost_redirect_to_phys(struct swap_in=
fo_struct *si, pgoff_t offset)
>
>         return (swp_entry_t){};
>  }
> +
> +/*
> + * swap_ghost_extend_max =E2=80=94 Extend an active ghost swap device.
> + * @si:  ghost device (SWP_GHOST set)
> + * @new: new max pages (> si->max)
> + *
> + * Allocates physical pages and maps them at the end of the reserved
> + * sparse vmalloc area.  si->cluster_info never moves.  New clusters
> + * are fully initialized before si->max is published via WRITE_ONCE.
> + *
> + * Returns 0, -ENOMEM, -EINVAL, or -E2BIG.  Caller holds swapon_mutex.
> + */
> +static int swap_ghost_extend_max(struct swap_info_struct *si,
> +                                unsigned int new)
> +{
> +       unsigned long old_max =3D si->max, old_nr, new_nr;
> +       unsigned long old_bytes, new_bytes, nr_new_pg;
> +       struct page **new_pglist;
> +       unsigned long i;
> +
> +       if (!(si->flags & SWP_GHOST) ||
> +           !(si->flags & (SWP_USED | SWP_WRITEOK)) ||
> +           new <=3D si->max)
> +               return -EINVAL;
> +
> +       old_nr =3D DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
> +       new_nr =3D DIV_ROUND_UP(new, SWAPFILE_CLUSTER);
> +       old_bytes =3D ALIGN(old_nr * sizeof(struct swap_cluster_info), PA=
GE_SIZE);
> +       new_bytes =3D ALIGN(new_nr * sizeof(struct swap_cluster_info), PA=
GE_SIZE);
> +       nr_new_pg =3D (new_bytes - old_bytes) / PAGE_SIZE;
> +
> +       if (old_bytes + nr_new_pg * PAGE_SIZE > si->cluster_vm->size) {
> +               pr_warn("ghost: extend to %u exceeds reserved VA (%lu byt=
es)\n",
> +                       new, si->cluster_vm->size);
> +               return -E2BIG;
> +       }
> +
> +       new_pglist =3D kvmalloc_array(si->cluster_vm->nr_pages + nr_new_p=
g,
> +                                   sizeof(struct page *), GFP_KERNEL);
> +       if (!new_pglist)
> +               return -ENOMEM;
> +       if (si->cluster_vm->pages) {
> +               memcpy(new_pglist, si->cluster_vm->pages,
> +                      si->cluster_vm->nr_pages * sizeof(struct page *));
> +               kvfree(si->cluster_vm->pages);

Can you use kvrealloc() here? I was hoping that could get rid of the
memcpy on your side.

I was considering another approach: allowing kvmalloc internally to
take two arguments for size. One is the initial size, and the other is
the vma size. That way you can specify the vma->pages with the max
size it can support but with a small inti size. Then it can grow the
backing pages incrementally to the maximum size without reallocating
the vma. I did some experiments; I might send out an RFC if there is
interest.

Chris

> +       }
> +       si->cluster_vm->pages =3D (void *)new_pglist;
> +
> +       for (i =3D 0; i < nr_new_pg; i++) {
> +               struct page *page =3D alloc_page(GFP_KERNEL | __GFP_ZERO)=
;
> +               if (!page) {
> +                       while (i-- > 0)
> +                               __free_page(new_pglist[si->cluster_vm->nr=
_pages + i]);
> +                       return -ENOMEM;
> +               }
> +               new_pglist[si->cluster_vm->nr_pages + i] =3D page;
> +       }
> +
> +       if (vm_area_map_pages(si->cluster_vm,
> +                             (unsigned long)si->cluster_vm->addr + old_b=
ytes,
> +                             (unsigned long)si->cluster_vm->addr + new_b=
ytes,
> +                             &new_pglist[si->cluster_vm->nr_pages])) {
> +               for (i =3D 0; i < nr_new_pg; i++)
> +                       __free_page(new_pglist[si->cluster_vm->nr_pages +=
 i]);
> +               return -ENOMEM;
> +       }
> +       si->cluster_vm->nr_pages +=3D nr_new_pg;
> +
> +       for (i =3D old_nr; i < new_nr; i++) {
> +               struct swap_cluster_info *ci =3D &si->cluster_info[i];
> +               spin_lock_init(&ci->lock);
> +               INIT_LIST_HEAD(&ci->list);
> +       }
> +
> +       if (new % SWAPFILE_CLUSTER) {
> +               unsigned long base =3D (new - 1) / SWAPFILE_CLUSTER *
> +                                   SWAPFILE_CLUSTER;
> +               unsigned long idx =3D base / SWAPFILE_CLUSTER;
> +               struct swap_cluster_info *ci =3D &si->cluster_info[idx];
> +
> +               if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL=
)) {
> +                       for (i =3D 0; i < nr_new_pg; i++)
> +                               __free_page(new_pglist[si->cluster_vm->nr=
_pages + i]);
> +                       return -ENOMEM;
> +               }
> +               spin_lock(&ci->lock);
> +               for (i =3D new % SWAPFILE_CLUSTER; i < SWAPFILE_CLUSTER; =
i++)
> +                       __swap_table_set(ci, i, SWP_TB_BAD);
> +               spin_unlock(&ci->lock);
> +       }
> +
> +       WRITE_ONCE(si->max, new);
> +
> +       for (i =3D old_nr; i < new_nr; i++) {
> +               struct swap_cluster_info *ci =3D &si->cluster_info[i];
> +               ci->flags =3D CLUSTER_FLAG_FREE;
> +               spin_lock(&si->lock);
> +               list_add_tail(&ci->list, &si->free_clusters);
> +               spin_unlock(&si->lock);
> +       }
> +
> +       si->pages +=3D new - old_max;
> +       atomic_long_add(new - old_max, &nr_swap_pages);
> +       spin_lock(&swap_lock);
> +       total_swap_pages +=3D new - old_max;
> +       spin_unlock(&swap_lock);
> +       return 0;
> +}
>  #endif /* CONFIG_ZSWAP */
>
>  static int __init swapfile_init(void)
> --
> 2.54.0
>

