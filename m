Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43F4C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 22:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89FE86B009D; Tue,  7 Jul 2026 18:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8299F6B009E; Tue,  7 Jul 2026 18:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA796B009F; Tue,  7 Jul 2026 18:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28E066B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:37:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51F0F1C3BF9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:37:14 +0000 (UTC)
X-FDA: 84963442788.19.DDBC9D2
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F3F980003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:37:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lq1lOU04;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783463832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4TK8lHvWPG5dly3sVNQQmvLHERELX/A9xEUlquBCaQ=;
	b=2KAIAaY4E4IMiO6OntPs3L+exEjKARd6uODAVxm+EZJplN0nOqmwopLCRYhei03vYxRdM7
	2aAg30TSbQk/dchhqaB7vu0ewE4CJHMe/Ma2msNIaIWWg6zX9/jz4+ak0p1GV7XXp/s5kH
	llzdDlrQMB9sXVC/BdqQOlfmhMKYIK8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lq1lOU04;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783463832;
	b=8aOt0qvivOtqxJtgvqYRG7VDz/m2gTZnnsQZw7+fR5Yh/mScjGFmaIDigvQPV3Vz4h9++p
	epKNmIiNQh/Ync9KeyhnzNdnXYeTstbUvETSZuce6FnPmyLly/2F1BIkq3ezVRyoUGoKcV
	3MYVmcf5W5iklxFpT0AeG2w49CIXwHE=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493c486f012so30605e9.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 15:37:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783463831; cv=none;
        d=google.com; s=arc-20260327;
        b=I3zhAEtaDxAFW2TQXJNKPyCk6whBi/0+h6U/QLwkqBFV40m+T+EMh8mKecP7/DZnZ3
         kUKUF6a3RrCncsO1fPm4TEXvcxVzdvPZ5VwbntMkzmZMc5XekfgbFazb8gXmIg62feCX
         06E6/Rx8VpKAO4+gB5ANPUW5ufRPQINg4rXyz7UGjnCvYTBtdbTG5DHBoiCd+zzO+9RH
         tqpCQFfY3mpLtX4/UijGILkqoecS8aWF6Gv7n/st8sewvKHkTcssNLZmdTEAJkqzQkFc
         M6u0eyHNe07aiFnCDpS3FQruGiLeQ+Gbo5jsAPXBFFefSn4Y7lm0K0kyIhnBud7cl1+p
         DyPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q4TK8lHvWPG5dly3sVNQQmvLHERELX/A9xEUlquBCaQ=;
        fh=vaecG6QtO6r12GzAj38pAxqRjsWQrAnjzLyMhvd9eFw=;
        b=ZpRrf41UlvpBn3UJVEPYTWfZfhNGrxu/k2we5RhKKuZx+paYOOW8tn+NmttVeyGlgP
         SVc9ed9pJOcK8Ide2oomssC9LGR9Rv8o2nGK4YNkj+IJ5GxHkg07wGD5HYuMBaspPSuh
         9283zKWEeBn783yEnIHuvBixVKjzUI8bnPFf+qnWX39SS7cfBHZ0oWECNvJifohjEllV
         Rr5vaeZy6dHP6nGGiZTwRGc2pq6KNWqYqVXwIngWnEn3sg6iNwuAWSkTgRu1Qv2swgXR
         HCltk+rTMIYSglPu23iPQUzIAgEjiPiwfOnVJvXFEnfYdRpi5QZZo87HD88mdaDnOjiC
         ojRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783463831; x=1784068631; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q4TK8lHvWPG5dly3sVNQQmvLHERELX/A9xEUlquBCaQ=;
        b=Lq1lOU04HwQ/etc0RKbiysI8cbS02yp8LvbJMv2Ik9iGvjQt1mG8n0/8HAJ/p3wYhF
         wsaRqugIABQOyxOu2OfxKv3b32GLFOiIxlg7fxAtjl3AFPcusbk3SdCX4NMlQjiI/86p
         /2Cznk/ClgOgRSWRQc1yC9VOgW60K6lsKcTNPCUfd0G74cVu3I/Hs6swpIdeKFRdfIgl
         VdTUBkWh1nmsReN/tUM+kRY7cPLiMeiKCTF3cG5l2AL5hanlDvKACOJm+lm7kLOulNoq
         zQwzRZ4Yq83CFeBcMxeeWDm45PlhLCIoYiiaDD71DUMygrMK7Vz399cvTmpXL9GVQmIe
         8yMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783463831; x=1784068631;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q4TK8lHvWPG5dly3sVNQQmvLHERELX/A9xEUlquBCaQ=;
        b=KwAQg0F/HegJKW44mgf3xXlO/RCb4HuUZvq1dRUvOMzV6JX+YR1V6yPijU8UFDfxmf
         mmwLPVe6GOMGSm8zRRVpRg2HjrYbcq1TClDJCkHMdxOReFWO5H+kq+rpk5UtDpSWCQYQ
         EVuF+sKFsDIWQgFQLrzG+SffUGGye2iDB7rURtxyaP73/56WxhUr4b0f+ztBh9HZYWdD
         Jyj6ebYn0IihH1u1YGjCCkELqMtYVP+6iF4klSNLay0dUc1sKqM6xWXjupxMSlhGkRVM
         /4cc5/Fcwtqy3XwVfaU3glV6+fPNSUCRaH1o5DrMvCoC0m+sLtzO73skCQhjXYUspKVI
         SzuQ==
X-Gm-Message-State: AOJu0YzBlvd9IWV1xItmNurdnWiBQ3K2ZVlin8/wFjuV47GdAxDx4xLU
	poI8PIcnUiCnhyjoK4sRdv3GoNHFomjLJ7hdgEbeB0CMlJLbqZNV6jrh/xEKUPEKNhh+qWeUcUv
	mjCFPDeCOhY473ke2lmXL8riski05uxw=
X-Gm-Gg: AfdE7cn+wZXOeHiddSl9TlnZuZfFlUGqYYXe14wOaVpj3THeFEgDSTgk4lS+lBiJ182
	SpBA4reMiKHEFWHqZxukB2a9+8i3vuYSAz8DNLWmjEuGy2nQ4tFLTbyv4DsEZTNYJDHo5ng0z/t
	EfU2VJf30maQ99vW8m4dLr8tdwMvxn7eLHksb2a9RAlmwh0iCDUgZjiIQ3AoTYp/eRUHJDKeM+a
	9XjSkA4EbaHcW380bDpIJiB490sRRw2LiGLugi3NuihEmOrRODKrQwQDTqTnzl2yp9/hWigcVPS
	fnUUtttv305w0ilGh7NqwLpUdCDUsoCjuzIgQuA=
X-Received: by 2002:a05:600c:1908:b0:492:5855:1548 with SMTP id
 5b1f17b1804b1-493df095562mr79007795e9.27.1783463830859; Tue, 07 Jul 2026
 15:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <20260707082614.95030-10-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-10-baoquan.he@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Jul 2026 15:36:59 -0700
X-Gm-Features: AVVi8Cewbd05P2hFQTHqsTM4xnyr8uYjwWgt3lEfqjaneePp7eM-lXAw54aTMh0
Message-ID: <CAKEwX=OygNR_5iD+FbWKhMD9Z7fxU3+VOfqn48aRGqZzYF2e_g@mail.gmail.com>
Subject: Re: [RFC PATCH 09/10] mm/swapfile: implement swap_ghost_extend_max()
 for dynamic growth
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6F3F980003
X-Stat-Signature: 4qm9bptngg6u4ma1rpogetod4xkfyifd
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783463832-164746
X-HE-Meta: U2FsdGVkX19kPhBIWvm58AJLy0zR6mH3IZveu0o6WhoJ9LQP9d3qVIIm4VSV0B38dqufSDDDhtEdiVErAeRCvNFFiURX68fchXElmMJPm5sVUzQhbuAg6qWcFJCVtz2Ai/yBfqDwaBTzQ36bfgsYbpkj8nxx51LayuV6PM6KbYNLS9rlW6O78BfwuaOJRx4lo8XLdTwU1/mGiRF+G9JiZkATiL/l+NQypIOxKzKjpPKJKoZ7TDekDqKnoDAkyV5Zt7TICP6bR0qKdkMK719Us+1UUkG+uVMuRqOrJLnQPE6e8Ffrkn5Di/2ENgXhzyMjsLuLQmOu/gQBKejEAwtOcJhcB/QxdHms52gtaEkOfiwTe/WYsfWluoroQbVm3vt5YK0S/0P3Pw89Mb30SRPguxVRH9RTt2d0tYHTd591dJ9ksWAfQWZg5vdZsA7FBarMMAGbHzA9MxVQr4qV3LRJOkRlpU3zO1nJqglY+H/t4Oa1KUeoZjRTQqDTZmsY02FvXV8JG2yBm5z6CWlu8nY7vWbHnJXzTG4+Kp6ZZThP3JW1kRhfb4NmezvhrLJnuO3qZniuBrTbPbtUccd6yoVKasjyS3YeeeLwWOXdmmkK3vmL3MopnnDX/iNl+o7duQRKW3VSMJMe6cm/HxokheIh1EgQ+91oZ9497d8eneLAltYXD6o6GW0RfUx/SOW9hiaLWl6O2B1zuJFuI0GD2EnFze6V/l6BbP27AjayrCSHjPmFwVINXZ1YSSzAVHuPhUwllsGVKZe2on7R3wtNgdtgvk5SYMK1Gi1lu+6hoK2cumFDKlLV+LWYjzhKP+gt49GYW4YP6ukQElp06nXxXvmjiE9PpQR0YQCRPwD3rduWWWp5NDh5DckQ7BtGBbSGoJjkom8Sve1yzRIEkC8zzzqds/4lLOsLC/s3Nz562HwHjhlJB3p7mploROF5Eo971u8PFU57BwzTsvQSrgn0yBH
 jwDZnkwW
 z3Tn8IbuAghZqC1SavSNm9RNi6OGh/Fvyv+FbLme8ibOqNld0/RGrTpwZbmRbUpikEXzFRwdkA+L2aM3jPAYnMBrHbjf+kRUYPPuNTWh+39lopI8qy6xX8nbVTyXl8+pjQW7s0FLgx9omky4frEPElbGzJkDDlUHpnFYRokwzw1f7dgfaV8R8bjkHH29KOS8rZpTGpjHl8dvbFELToq/ltIjGTJoCvQ7NPdm0UeyXeUZw30ehYoCMv22ElwHD0CFnAcr+N6bCIK1paEimc9EyQnWmgDYv5UnZazj0J2ryuQ1i93VnnR//hHe6zD/wUrvMNyTVOq0sAguTvaVvErbnDPhjO/vsQz8Bg2GGs7p6ELBQzHCqCxNiD7O5mSM9saEVOjQV3tNYoucP3GE8wLWmaw58M92T6dzlAOMy8M7zXnl0Fil1LMkOsp9pOu3RkDl9Q8Ta
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

Does this only grow? Say I have a huge but temporary spike in swap
usage, which triggers the extension of the the ghost swapfile address
space. Do these metadata space live forever?

If that's the case, might as well just swapon...?

