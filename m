Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 725D5C9830E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 01:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C296B008A; Sun, 27 Sep 2026 21:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D526B008C; Sun, 27 Sep 2026 21:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343386B0092; Sun, 27 Sep 2026 21:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05DD06B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:54:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7475740ABD
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:54:04 +0000 (UTC)
X-FDA: 85261500408.10.D35C5FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D6C620002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:54:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SdYHW1O8;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790560442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zb6MMN8Vr9uHQFNaqyle+sPMSl2gdZc46ZsWpDx62o0=;
	b=itF6oahwipIQmMAx1XTIYWsVPvHX5aFtjso52BWyz8zVjrWjdxgImAjTXR2xf/dm7nNoQ+
	9CG8lEjvtGFmgCgronmVcAV5M7oseWSrt/fmyN3W3v5i4aKJ7wMKDGcTvMJByzIZJuPa0E
	eYJIg43oDl8AbcjbOr00Ar8UFQNzho4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SdYHW1O8;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790560442;
	b=BucVI7OyRVI+R56eiF/CNwB+zXyMJedQlHmWGHCGsPM2LmSh+sRO1ys7FIp/3PZGidaTo6
	L7eJULEzzSS7UR/NvFe7yfeUUw3C3ccPwh8DXofgiX+qRTJ1pH+1HsheZWkDFtUKIupcwi
	pWZV1XiD985LTm42DzMq/T2PTkcu6HE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B0B64450F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827FA1F000FF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790560441;
	bh=Zb6MMN8Vr9uHQFNaqyle+sPMSl2gdZc46ZsWpDx62o0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SdYHW1O8huQ0L5qn+9hiICb0xF7oZXcSF94NI5h8LCS6rpVsfmtbxJ2nJUNgw8X19
	 1kEvplSLBUCCqGEO1XOuhk5S8blOazXt4rVTR5rp38YelLXCfKIRhY5/h0X8XuBiKk
	 RjNuMrRG2NKGg2KreRhAiPsTJzWy/g61dU3D/+H1EnWhi+SZfgpld1Vlett7PMi0PR
	 WFFYa14TPHdRL84z8FHsQJ43tKB46RGOJJoNhTWRRElsZ0m8tbjzFx9XqT4on3gklx
	 E+XYiSG+O/20RdOIMY8eK+w05E+n/CgI7YCKtDECvts6tAm5RRFqMxBepmMGU8y17Z
	 SyYA4kUMosscg==
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aa1d00daaaso4195331a12.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:54:01 -0700 (PDT)
X-Gm-Message-State: AFq9FYK7KsUnrSDnXxPCmEGHcXRm5OlZ9M66vB+gnCiPy8huqKHGE8t9
	tOne6GeSIvmAqTGNi2ZN+yacjYcGYbUuHccCvnbCAjqKj6KiMmapwzjCfK1XpsM2rqAqu6KF4Q3
	jI58k060xvR/HzKf4sFSSVYUzzAri8nKIMbbV9r/yew==
X-Received: by 2002:a05:6402:1e93:b0:6a9:9c65:f244 with SMTP id
 4fb4d7f45d1cf-6aac8f875bbmr9091124a12.36.1790560440217; Sun, 27 Sep 2026
 18:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-6-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-6-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 15:53:47 -1000
X-Gmail-Original-Message-ID: <CACePvbXHaFBOfgA5iK7a9cmegQqqQMsZZ5s+YLJp-NaAdWoebg@mail.gmail.com>
X-Gm-Features: AclHuK9gc6fyBSzGPlv2oQ5PVZE_lIkIhopGnaPFe7OqXhpQWG_PoxUc8VGoEiM
Message-ID: <CACePvbXHaFBOfgA5iK7a9cmegQqqQMsZZ5s+YLJp-NaAdWoebg@mail.gmail.com>
Subject: Re: [PATCH v3 05/14] mm, swap: add sysfs create interface for xswap
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D6C620002
X-Rspam-User: 
X-Stat-Signature: huh1zody5osuzhdrgoaesg4phhqhm14h
X-HE-Tag: 1790560442-580666
X-HE-Meta: U2FsdGVkX19pqcSMXl3MC1VviiS0E6OI2c8uZOaKzM7dLpakWVGFcZ0RXhApgENhgC6qq5pAWu0L0KQ70bnytVIhN3CANVTtSJE5ujxpeIiU7wvLwZ4MJrNYOt7rI6D+OI9WrwbrA5Al1rDA8Cn7PQRCZAKlLpmdz05LLeddbJGrM7UvsMBI2z8PZ1XiP+gu8Mi+PWNp44o+3q02MkOxMFfylHgs2hbTPIphDZFBOqFMi99iNkFNMyM+JnNcvnrGRQuyuspk/8m2MNG2riOBB/i0wNkckX+ibnW9NjB2IvUj245MsTsgPj57YUhJ8DulWEvSrDNBEfzuSc2NGOn7AfE74bjLj5zUYnPekv2yQqKBGM8RomEBibg8aBIR5/ix9B58gCSE1of+hqsl1IUEoDn31d2wHf+LK6bsGbISLunN9dGK3YrI2Ep5aQsgI2Y+6FRTeHisOSsv7VEF94BElSfDBOnKWEewr0Av32FgucZt13xdjMQsyzHtsw4oUU+QPZyl0AGRKkS56uXEd63bMB1OB16cAW+MYXG8bpFq1bfcgfg//DE1kHutYjLbKftjolaTZxEsmfNm6wERlNM5rcPj4rPtebuwlkjmuINfYhscRo4COzVXJwdkQUmZ27if0OYMtW9GAfkfa1xe8wnf/RXUnjHawzEdW8KwpJeEMsP4winuOmou5D/NoG0l/0KargUi1Ch/iDVHB2kEmtLB/e0mV6qGD6eRQWJZdAC4Br8xvEtUkT68h0rOaLCR+QU9niYzJNCybTnVFvqCiQa7hnOvfsmoNWqwS4HtUyVDhFzoTOwI+ck7AUkRRogwVWk+T4xIvkKxry2wQa8WtWDg1G8JyJABoXy7cd6yJ7TKYEJMg+MxdmukiN6i9bY6xTFapSG86IYytmrzMcBowzK3u4tSXSbCXcTRlPyYMYOaeHz7zZPUcUQ49AYv7tkxpwE9ntu26mT+InID+Wk71i9
 CGGHXBa7
 OZ3oyQpGyzWnowEWcTE4R8cAQ2AzUWoobUEVwHvExF7oW28k1c7n5pjd9ZOjXKRN+HVJEj9Vtp7hbngKGHq0Fpq8dXIc/wzwm3DQZLiG4qnyyOIe6/nBL0UO7l6oPMTzJbSKMbp1SWBTYVdjEmHgAG/JRFD1fkRXHyGdXzf0Zyeg10epUcKcTy0OUFeHnJKL2MVmdPPzz1Lu6Y78KnEEAHVQVb+nk8zAqHScblN3p11y7/NS+TXAPvhNqTYKTNAelJdJq/JUG/h2CidQG7E+g76ZPu/URRFt85pbqOZk5oheJwKFU0c7l3Hp3wMIhrtB/IL+iDKUYSZyBtYPmsaKSjg1XwOxTHGOD4XXYn/T2hXS9jyY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:20=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> xswap devices have no backing storage, so there is no file to swapon.
> Add a sysfs interface to create them directly:
>   /sys/kernel/mm/xswap/create    write an optional priority to create
>                                  a device (empty =3D DEF_SWAP_PRIO)
>
> A new device is created with si->max and nr_clusters_max both equal to
> twice RAM: the cluster_info array is a sparse VM_SPARSE area mapped
> lazily, so an idle device costs nothing. The runtime size can be
> lowered per device afterwards via
> /sys/kernel/mm/xswap/type<N>/limit (added later in this series).
> The optional priority follows swapon(2)'s -p semantics (default
> DEF_SWAP_PRIO, valid range -1..SWAP_FLAG_PRIO_MASK). The device shows
> up in /proc/swaps as "xswap<N>".
>
> Hibernation device discovery skips xswap devices: they have no bdev
> to carry a resume image.

The sysfs method for creating xswap is workable but not ideal in my mind.

It lacks /etc/fstab support. I wish xswap also supported /etc/fstab.
There is no standard swap on/swap off mechanism for this device.

My ideal solution would treat xswap as a swap file system. The swap
header block is the equivalent of a file system superblock.
It would have a 4K size swap header, but it would not contain any swap
data. You can think of it as a config spec file for the xswap device.
We will need to introduce one flag for XSWAP and maybe a swap file
system type name.

We will also need to modify the mkswap to create the xswap header.
Alternatively, we could introduce a `mkxswap.c` ourself. It is pretty
simple: just write out a C struct with a UUID. We can make that part
of the self test units. Maybe there is better location for it.

Those are the pretty standard ways to extend new features to a file
system. That is my north star for considering a VFS like subsystem for
swap.

Chris

>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  mm/swapfile.c | 163 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 158 insertions(+), 5 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index dac5e0db0e94..b0edf5421fc5 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -16,6 +16,8 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/swap.h>
>  #include <linux/vmalloc.h>
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
>  #include <linux/pagemap.h>
>  #include <linux/namei.h>
>  #include <linux/shmem_fs.h>
> @@ -48,6 +50,7 @@
>  #include "swap_table.h"
>  #include "internal.h"
>  #include "swap.h"
> +#define DEF_SWAP_PRIO  -1
>
>  #ifdef CONFIG_XSWAP
>  /*
> @@ -66,7 +69,64 @@ static int xswap_map_clusters(struct swap_info_struct =
*si,
>  static void xswap_unmap_clusters(struct swap_info_struct *si,
>                                  unsigned long start_idx, unsigned long n=
r);
>  static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
> -#endif
> +
> +static int xswap_create(int prio);
> +
> +static ssize_t xswap_create_store(struct kobject *kobj,
> +                                 struct kobj_attribute *attr,
> +                                 const char *buf, size_t count)
> +{
> +       int prio =3D DEF_SWAP_PRIO;
> +       int err;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       /* "[<prio>]" is optional; empty means DEF_SWAP_PRIO, i.e. the sa=
me
> +        * default as swapon(2) without SWAP_FLAG_PREFER.
> +        */
> +       if (*skip_spaces(buf)) {
> +               err =3D kstrtoint(buf, 10, &prio);
> +               if (err)
> +                       return err;
> +       }
> +
> +       err =3D xswap_create(prio);
> +       if (err < 0)
> +               return err;
> +
> +       return count;
> +}
> +
> +static struct kobj_attribute xswap_create_attr =3D __ATTR(create, 0200, =
NULL,
> +                                                       xswap_create_stor=
e);
> +
> +static struct attribute *xswap_attrs[] =3D {
> +       &xswap_create_attr.attr,
> +       NULL,
> +};
> +
> +static const struct attribute_group xswap_attr_group =3D {
> +       .attrs =3D xswap_attrs,
> +};
> +
> +static struct kobject *xswap_kobj;
> +
> +static void xswap_sysfs_init(void)
> +{
> +       xswap_kobj =3D kobject_create_and_add("xswap", mm_kobj);
> +       if (!xswap_kobj) {
> +               pr_err("xswap: failed to create sysfs kobject\n");
> +               return;
> +       }
> +       if (sysfs_create_group(xswap_kobj, &xswap_attr_group))
> +               pr_err("xswap: failed to create sysfs group\n");
> +}
> +#else /* !CONFIG_XSWAP */
> +static inline void xswap_sysfs_init(void)
> +{
> +}
> +#endif /* CONFIG_XSWAP */
>
>  static void swap_range_alloc(struct swap_info_struct *si,
>                              unsigned int nr_entries);
> @@ -94,7 +154,6 @@ atomic_t nr_real_swapfiles;
>  EXPORT_SYMBOL_GPL(nr_swap_pages);
>  /* protected with swap_lock. reading in vm_swap_full() doesn't need lock=
 */
>  long total_swap_pages;
> -#define DEF_SWAP_PRIO  -1
>  unsigned long swapfile_maximum_size;
>  #ifdef CONFIG_MIGRATION
>  bool swap_migration_ad_supported;
> @@ -2275,6 +2334,9 @@ static int __find_hibernation_swap_type(dev_t devic=
e, sector_t offset)
>
>                 if (!(sis->flags & SWP_WRITEOK))
>                         continue;
> +               /* xswap has no bdev to match a resume device */
> +               if (sis->flags & SWP_XSWAP)
> +                       continue;
>
>                 if (device =3D=3D sis->bdev->bd_dev) {
>                         struct swap_extent *se =3D first_se(sis);
> @@ -2462,6 +2524,8 @@ int find_first_swap(dev_t *device)
>
>                 if (!(sis->flags & SWP_WRITEOK))
>                         continue;
> +               if (sis->flags & SWP_XSWAP)
> +                       continue;
>                 *device =3D sis->bdev->bd_dev;
>                 spin_unlock(&swap_lock);
>                 return type;
> @@ -3423,7 +3487,7 @@ static void *swap_start(struct seq_file *swap, loff=
_t *pos)
>                 return SEQ_START_TOKEN;
>
>         for (type =3D 0; (si =3D swap_type_to_info(type)); type++) {
> -               if (!(si->swap_file))
> +               if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
>                         continue;
>                 if (!--l)
>                         return si;
> @@ -3444,7 +3508,7 @@ static void *swap_next(struct seq_file *swap, void =
*v, loff_t *pos)
>
>         ++(*pos);
>         for (; (si =3D swap_type_to_info(type)); type++) {
> -               if (!(si->swap_file))
> +               if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
>                         continue;
>                 return si;
>         }
> @@ -3486,7 +3550,14 @@ static int swap_show(struct seq_file *swap, void *=
v)
>         inuse =3D K(swap_usage_in_pages(si));
>
>         file =3D si->swap_file;
> -       len =3D seq_file_path(swap, file, " \t\n\\");
> +       if (file)
> +               len =3D seq_file_path(swap, file, " \t\n\\");
> +       else {
> +               char name[16];
> +
> +               len =3D scnprintf(name, sizeof(name), "xswap%d", si->type=
);
> +               seq_puts(swap, name);
> +       }
>         seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
>                         len < 40 ? 40 - len : 1, " ",
>                         swap_type_str(si),
> @@ -4034,6 +4105,86 @@ static int setup_swap_clusters_info(struct swap_in=
fo_struct *si,
>         return err;
>  }
>
> +#ifdef CONFIG_XSWAP
> +/* Create a file-less xswap device.  si->max and the initial nr_clusters
> + * ceiling are both twice RAM; the runtime size can be lowered afterward=
s
> + * via /sys/kernel/mm/xswap/type<N>/limit.
> + */
> +static int xswap_create(int prio)
> +{
> +       struct swap_info_struct *si;
> +       unsigned long ram, maxpages;
> +       int error;
> +
> +       if (prio !=3D DEF_SWAP_PRIO && (prio < 0 || prio > SWAP_FLAG_PRIO=
_MASK))
> +               return -EINVAL;
> +
> +       si =3D alloc_swap_info();
> +       if (IS_ERR(si))
> +               return PTR_ERR(si);
> +
> +       INIT_WORK(&si->discard_work, swap_discard_work);
> +       INIT_WORK(&si->reclaim_work, swap_reclaim_work);
> +
> +       ram =3D totalram_pages();
> +       maxpages =3D min_t(unsigned long, ram * 2, swapfile_maximum_size)=
;
> +       /* si->max is an unsigned int: don't overflow it. */
> +       if (maxpages > UINT_MAX)
> +               maxpages =3D UINT_MAX;
> +       /* Cluster-aligned, so no cluster holds a slot past si->max. */
> +       if (maxpages > SWAPFILE_CLUSTER)
> +               maxpages =3D rounddown(maxpages, SWAPFILE_CLUSTER);
> +       if (maxpages < 2)
> +               maxpages =3D 2;
> +
> +       si->bdev =3D NULL;
> +       si->flags |=3D SWP_XSWAP | SWP_SOLIDSTATE;
> +       si->max =3D maxpages;
> +       si->pages =3D maxpages - 1;
> +       /*
> +        * No backing file: setup_swap_extents() is only reachable from t=
he
> +        * file-backed swapon() path, so set ops here.  Only ops->flags i=
s
> +        * used, by may_enter_fs(); the IO methods are never called becau=
se
> +        * swap_writeout()/swap_read_folio() short circuit xswap.
> +        */
> +       si->ops =3D &swap_bdev_ops;
> +
> +       error =3D setup_swap_clusters_info(si, NULL, maxpages);
> +       if (error)
> +               goto bad_swap;
> +
> +       error =3D zswap_swapon(si->type, si->max);
> +       if (error)
> +               goto bad_swap;
> +
> +       mutex_lock(&swapon_mutex);
> +       si->prio =3D prio;
> +       si->list.prio =3D -si->prio;
> +       si->avail_list.prio =3D -si->prio;
> +       /* si->swap_file stays NULL: this is a file-less device */
> +       enable_swap_info(si);
> +       mutex_unlock(&swapon_mutex);
> +
> +       pr_info("xswap: adding extendable swap type %d (prio %d, %u pages=
, max %lu)\n",
> +               si->type, prio, si->pages, maxpages);
> +       atomic_inc(&proc_poll_event);
> +       wake_up_interruptible(&proc_poll_wait);
> +
> +       return si->type;
> +
> +bad_swap:
> +       kfree(si->global_cluster);
> +       si->global_cluster =3D NULL;
> +       destroy_swap_extents(si, NULL); /* safe: xswap never sets SWP_ACT=
IVATED */
> +       free_swap_cluster_info(si);
> +       si->cluster_info =3D NULL;
> +       spin_lock(&swap_lock);
> +       si->flags =3D 0;
> +       spin_unlock(&swap_lock);
> +       return error;
> +}
> +#endif /* CONFIG_XSWAP */
> +
>  SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flag=
s)
>  {
>         struct swap_info_struct *si;
> @@ -4380,6 +4531,8 @@ static int __init swapfile_init(void)
>                 swap_migration_ad_supported =3D true;
>  #endif /* CONFIG_MIGRATION */
>
> +       xswap_sysfs_init();
> +
>         return 0;
>  }
>  subsys_initcall(swapfile_init);
> --
> 2.54.0
>

