Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 771EDC98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 06:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E786B008A; Mon, 28 Sep 2026 02:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0776B0092; Mon, 28 Sep 2026 02:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6646B0093; Mon, 28 Sep 2026 02:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39FBB6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:18:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 919A5140B3E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:18:09 +0000 (UTC)
X-FDA: 85262165898.03.C1CAEED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C5DEBA0005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:18:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/Y25BkI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790576287;
	b=WQ6BHGKXUqw4L5v3Twp3+gWp1H+hmUfSegSL0z7R88inUmbZm1Yzy3Lc0ObjRwQ2CKnBwt
	rFKj4qK0kOUGBdcyBwcbR1041SCnP8Z0dHzt6GG3xC1TPIiEJVbxTYykhd4ivCZqTnWyxH
	M5xn+RaEmXvnyoHfDJZWRDk7Fvhtg6Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/Y25BkI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790576287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPA7WpGxVjb7j4LORzvG/vNPmhuOY1oBn/RwCUEkpmg=;
	b=iqFy6iUFmS8d6L4AcKnEgGAdVFk5HVo0MdNiQcr89pJ9B3UVvAH+le3SuCAcpIl8fCc178
	nDnK4aaQ0MQk1BojWjV4DIBfGiLpPZ4lTNgxhuW8nCjDwW6RpCyQ7GSakN7lN3BGIKpKU/
	ryvKTsE8rIBqW2cj1X3VHvS0NNKNtwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DAF8601FF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FB71F00899
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576287;
	bh=TPA7WpGxVjb7j4LORzvG/vNPmhuOY1oBn/RwCUEkpmg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=W/Y25BkIz2asL3xouVisLP7tVaaTsk2KFBeQfzVNmBQOxz5UpHzqCrR+pxJeMTeFg
	 O1f9E4z06ajicTiKQRIxl5y730ctLp4DxmOGfMZZ2Yjx7uu/j+t4zVClDGsig43U9L
	 A7E2ula7RkUiB+XklRoN4pl/kL7v5CuJ7kRqfe06UovcPAhb7CRgGPdPy2CTMr9/CA
	 88l/P94qIPnRKLro9/Db6A4rTUQnD33VnwY38827Gjk9sSgMI+xGzxkYCIIm1FarUb
	 vCUm3rZ4eOEp6LYLC+GBdLGnX+GzH50liD9Mtm6l73WjQrBLaMZbzHwrarguxE7e3C
	 ka4HtaW4twZDw==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2aff2c45efso186007066b.3
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:18:06 -0700 (PDT)
X-Gm-Message-State: AFuF++n+xnzPK62ItvyAZfHEYvWGWhaUqLUpcPNFhFk0YBI5CP3pHQ9G
	3UNYZoTF+iVP/SSGRwwTT9+K/5E2H/5Qtx24hRHKvtInn44A0L0YajTOqQ3wixNrKTR2htOsdn2
	ZevuZ0mboJ52uvf2pvce8OvxPbp2ZrBpn27g6wrhWVA==
X-Received: by 2002:a17:907:ea7:b0:c25:afb6:2d91 with SMTP id
 a640c23a62f3a-c2ac230f4b2mr1019122966b.2.1790576285662; Sun, 27 Sep 2026
 23:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-14-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-14-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 20:17:54 -1000
X-Gmail-Original-Message-ID: <CACePvbXDGx4jDu77nbO+G9RcOCcxc_710i4GL=b3wKaj_tF6Hw@mail.gmail.com>
X-Gm-Features: AclHuK-4gyktcF-mynmQngo5LFPr4hqasXeJ5HhS3jMGq8tYhTdJeXtB5RbOJeM
Message-ID: <CACePvbXDGx4jDu77nbO+G9RcOCcxc_710i4GL=b3wKaj_tF6Hw@mail.gmail.com>
Subject: Re: [PATCH v3 13/14] mm, swap: add sysfs per-device size limit for xswap
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 5benyhcmuianqbdfs8hzdhjqfcdfmkxb
X-Rspam-User: 
X-Rspamd-Queue-Id: C5DEBA0005
X-HE-Tag: 1790576287-127678
X-HE-Meta: U2FsdGVkX1/Y7UCyLoLkYPwOQg9G8wjDbzS2ZW3STo4kMM3/CphPdFIJ0grDBmAC6heQkHMoJ7g5iij8pDTCyHduCh7FTr27JcRBpzh+9BZJpA7Ypzn4RnJTzeMKBgmkbpruNTH1BZCFY8WrU2zuZMwMGrLq8etgrM4i51sTx4RAHQhHotpfhdkp8QmjjxtKBlP6pKsSiHdQNotSfRV+Y8inSVsbWuL21XweteXbYJQ+xw8Vl8zRb3WSXQ8sFpJ+0KeeR8iX4Oemtk+1wuLbEeZIlQSFvDDoglJ2RJqX6llZ9vwPaNbHo0xsfwijPL9LDTSlk+38EHbfO9Kbd3K84x2TIzqlCo0sE4fIRucJi1MCSUnIBDzYHLUKDpkWf2EHYCdAE0Oh2hzBuDO0Ya4S/Cgbco2ZEsHc6p6WPAiDO0uBXrVQNYHrfBeWQ6SIAVoRYw3bKkETspr4sS0TvbttcfKIHpXhN+wGKfG5qp8CSiZdlv0RoMDH1DrZ7IDG7eppwmkxNVx2WRBXYO3J8CkCOAA/qlbBjwcU7mCWwT3BXnB7fYqDTUOfQ56TyPdTRfigVQ6lSbQX/0pwgT0esOOmXMnCzB9IVkaBeO21ZUCG1icidqbfGKv9wJht+ucJqIBueu0SBaDRuuuNjGsm5uXmGVtGOSdnViEwdTzUmH5M5Eif73XXedFUOj6giGue2qLQM3FSx11kPmVewU0tOB8Vw8YXXjo3Hn/axSyZH160KACS1RExIvc5ASxg0XXEgIlBBSmXxG5mGKsEbXrszzbDiAcRFEhtzF0BCdgCB3j9AeLheCugex0CoVr8fO6OIeApMYfHx4u/HGP41j2vNGPkY0O9GlUJHVkcty6Inb+8CQfdAjFfNNikaukRWIJndb6ulF+9a9ghoZtzCwkAhjEFC/joSVLmFbA7ZeXfWQpVMbbe1GcKvXKIw3Lky0oTnBSsDECVuq+dpf2loQNGCfI
 e0vm8LRs
 81ibGGZq7pa2LtSFgcGxKT50SwO38JYJh7CgUakFHDGp4nzDjqWUcKGbZ60I94rsN50uRc36VtqmIivdbkWQXzOTQGUCb7z6RcTMQ0fYBbRNfOvn5KoQpgps8IQPvUMNOKEK4mHe8HDBsqfYaeG/YC1ehsd0xKSit7Y0q/MZz/mfP+Wznp0mqHb9gjX1tC8GDams/qAnqkomX3zjb7lZJJxqME6HewyXakGr7xr1njhRefNoLXXcnCIZholGxbxrHcM09XDkd7WYFLY14kdpZ/jTJ8MiA/9P259QlAatqC1BMjaA+4XqFkt73QXANyjGfJUNh7UjFK1BtzdXzsshqPdFQiXLiHubfNFklTlIFThPlZwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:21=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> Add a per-device sysfs knob to limit the xswap usable size:
>
>   /sys/kernel/mm/xswap/type<N>/limit    read/write, in pages
>
> Reading reports the current usable size; writing sets a new ceiling.
> The ceiling is clamped to cover the pages in use, and enforcement is
> best effort. The write requires CAP_SYS_ADMIN.

I am not sure this user interface is strictly needed.

In my mind, xswap just has a max size at swapon. Then internally, the
kernel just grows the useable part of cluster array as needed.

Chris

>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  include/linux/swap.h |  18 ++--
>  mm/swapfile.c        | 193 +++++++++++++++++++++++++++++++++++++------
>  2 files changed, 179 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 9fe82d0f1740..804189b4b4eb 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -16,6 +16,8 @@
>  #include <uapi/linux/mempolicy.h>
>  #include <asm/page.h>
>
> +struct kobject;
> +
>  #define SWAP_FLAG_PREFER       0x8000  /* set if swap priority specified=
 */
>  #define SWAP_FLAG_PRIO_MASK    0x7fff
>  #define SWAP_FLAG_DISCARD      0x10000 /* enable discard for swap */
> @@ -245,8 +247,9 @@ struct swap_info_struct {
>  #ifdef CONFIG_XSWAP
>         struct vm_struct        *cluster_vm;    /* VM_SPARSE area for clu=
ster_info */
>         unsigned long           nr_clusters_max;/* total clusters in the =
xswap address space */
> -       unsigned long           nr_clusters;    /* how far the array may =
grow */
> +       unsigned long           nr_clusters;    /* growth ceiling, set by=
 type<N>/limit */
>         unsigned long           nr_clusters_mapped; /* currently mapped c=
luster count */
> +       struct kobject          *xswap_dev_kobj; /* sysfs: /sys/kernel/mm=
/xswap/type<N>/ */
>         struct work_struct      xswap_shrink_work; /* deferred shrink tri=
gger */
>         struct mutex            xswap_lock;     /* serialize map/unmap op=
erations */
>  #endif
> @@ -256,7 +259,7 @@ struct swap_info_struct {
>                                         /* list of cluster that contains =
at least one free slot */
>         struct list_head frag_clusters[SWAP_NR_ORDERS];
>                                         /* list of cluster that are fragm=
ented or contented */
> -       unsigned int pages;             /* total of usable pages of swap =
*/
> +       unsigned int pages;             /* total of usable pages of swap;=
 mutable for xswap */
>         atomic_long_t inuse_pages;      /* number of those currently in u=
se */
>         struct swap_sequential_cluster *global_cluster; /* Use one global=
 cluster for rotating device */
>         spinlock_t global_cluster_lock; /* Serialize usage of global clus=
ter */
> @@ -269,10 +272,13 @@ struct swap_info_struct {
>                                          * inuse_pages and all cluster li=
sts.
>                                          * Other fields are only changed
>                                          * at swapon/swapoff, so are prot=
ected
> -                                        * by swap_lock. changing flags n=
eed
> -                                        * hold this lock and swap_lock. =
If
> -                                        * both locks need hold, hold swa=
p_lock
> -                                        * first.
> +                                        * by swap_lock, except for pages=
:
> +                                        * xswap updates it at runtime fr=
om
> +                                        * type<N>/limit, and readers wit=
hout
> +                                        * swap_lock use READ_ONCE(). cha=
nging
> +                                        * flags need hold this lock and
> +                                        * swap_lock. If both locks need =
hold,
> +                                        * hold swap_lock first.
>                                          */
>         struct work_struct discard_work; /* discard worker */
>         struct work_struct reclaim_work; /* reclaim worker */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 2cf6ba0bd0c0..0fcbaf1cf0e2 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -71,6 +71,8 @@ static int xswap_unmap_clusters(struct swap_info_struct=
 *si,
>                                 unsigned long start_idx, unsigned long nr=
);
>  static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
>  static void xswap_try_shrink(struct swap_info_struct *si);
> +static int xswap_dev_kobj_add(struct swap_info_struct *si);
> +static void xswap_dev_kobj_del(struct swap_info_struct *si);
>
>  static int xswap_create(int prio);
>  static int xswap_destroy(int type);
> @@ -1369,8 +1371,6 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si,
>  /* SWAP_USAGE_OFFLIST_BIT can only be set by this helper. */
>  static void del_from_avail_list(struct swap_info_struct *si, bool swapof=
f)
>  {
> -       unsigned long pages;
> -
>         spin_lock(&swap_avail_lock);
>
>         if (swapoff) {
> @@ -1388,15 +1388,19 @@ static void del_from_avail_list(struct swap_info_=
struct *si, bool swapoff)
>                 atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
>         } else {
>                 /*
> -                * If not called by swapoff, take it off-list only if it'=
s
> -                * full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
> -                * si->inuse_pages =3D=3D pages), any concurrent slot fre=
eing,
> -                * or device already removed from plist by someone else
> -                * will make this return false.
> +                * Take it off-list only if full and not already off.  Us=
e >=3D
> +                * and the current count: xswap can shrink si->pages at
> +                * runtime, so a racing allocation can push inuse_pages p=
ast
> +                * it.
>                  */
> -               pages =3D si->pages;
> -               if (!atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
> -                                            pages | SWAP_USAGE_OFFLIST_B=
IT))
> +               long val =3D atomic_long_read(&si->inuse_pages);
> +
> +               if (val & SWAP_USAGE_OFFLIST_BIT)
> +                       goto skip;
> +               if (val < READ_ONCE(si->pages))
> +                       goto skip;
> +               if (!atomic_long_try_cmpxchg(&si->inuse_pages, &val,
> +                                            val | SWAP_USAGE_OFFLIST_BIT=
))
>                         goto skip;
>         }
>
> @@ -1410,7 +1414,6 @@ static void del_from_avail_list(struct swap_info_st=
ruct *si, bool swapoff)
>  static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
>  {
>         long val;
> -       unsigned long pages;
>
>         spin_lock(&swap_avail_lock);
>
> @@ -1429,15 +1432,14 @@ static void add_to_avail_list(struct swap_info_st=
ruct *si, bool swapon)
>         val =3D atomic_long_fetch_and_relaxed(~SWAP_USAGE_OFFLIST_BIT, &s=
i->inuse_pages);
>
>         /*
> -        * When device is full and device is on the plist, only one updat=
er will
> -        * see (inuse_pages =3D=3D si->pages) and will call del_from_avai=
l_list. If
> -        * that updater happen to be here, just skip adding.
> +        * Mask off the bit to get the count.  Keep the device off-list i=
f
> +        * it is still full; use >=3D because a runtime shrink of si->pag=
es
> +        * can leave it over the limit.
>          */
> -       pages =3D si->pages;
> -       if (val =3D=3D pages) {
> -               /* Just like the cmpxchg in del_from_avail_list */
> -               if (atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
> -                                           pages | SWAP_USAGE_OFFLIST_BI=
T))
> +       val &=3D ~SWAP_USAGE_OFFLIST_BIT;
> +       if (val >=3D READ_ONCE(si->pages)) {
> +               if (atomic_long_try_cmpxchg(&si->inuse_pages, &val,
> +                                           val | SWAP_USAGE_OFFLIST_BIT)=
)
>                         goto skip;
>         }
>
> @@ -1462,7 +1464,8 @@ static bool swap_usage_add(struct swap_info_struct =
*si, unsigned int nr_entries)
>          * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
>          * remove it from the plist.
>          */
> -       if (unlikely(val =3D=3D si->pages)) {
> +       if (unlikely(!(val & SWAP_USAGE_OFFLIST_BIT) &&
> +                    val >=3D READ_ONCE(si->pages))) {
>                 del_from_avail_list(si, false);
>                 return true;
>         }
> @@ -3360,6 +3363,7 @@ static void free_swap_cluster_info(struct swap_info=
_struct *si)
>         if (si->flags & SWP_XSWAP) {
>                 unsigned long nr_mapped;
>
> +               xswap_dev_kobj_del(si);
>                 cancel_work_sync(&si->xswap_shrink_work);
>                 /*
>                  * Cluster 0 keeps the bad header slot, so it never empti=
es
> @@ -3690,7 +3694,7 @@ static int swap_show(struct seq_file *swap, void *v=
)
>                 return 0;
>         }
>
> -       bytes =3D K(si->pages);
> +       bytes =3D K(READ_ONCE(si->pages));
>         inuse =3D K(swap_usage_in_pages(si));
>
>         file =3D si->swap_file;
> @@ -4337,6 +4341,9 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>                 }
>
>                 INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
> +               if (xswap_dev_kobj_add(si))
> +                       pr_warn("xswap: failed to add sysfs interface for=
 type %d\n",
> +                               si->type);
>                 return 0;
>
>  err_unmap:
> @@ -4429,14 +4436,143 @@ static int setup_swap_clusters_info(struct swap_=
info_struct *si,
>  }
>
>  #ifdef CONFIG_XSWAP
> -/* Create a file-less xswap device.  si->max and the initial nr_clusters
> - * ceiling are both twice RAM; the runtime size can be lowered afterward=
s
> - * via /sys/kernel/mm/xswap/type<N>/limit.
> +struct xswap_sysfs_dev {
> +       struct kobject kobj;
> +       struct swap_info_struct *si;
> +};
> +
> +static ssize_t xswap_limit_show(struct kobject *kobj,
> +                               struct kobj_attribute *attr, char *buf)
> +{
> +       struct swap_info_struct *si =3D
> +               container_of(kobj, struct xswap_sysfs_dev, kobj)->si;
> +
> +       return sysfs_emit(buf, "%u\n", READ_ONCE(si->pages));
> +}
> +
> +static ssize_t xswap_limit_store(struct kobject *kobj,
> +                                struct kobj_attribute *attr,
> +                                const char *buf, size_t count)
> +{
> +       struct swap_info_struct *si =3D
> +               container_of(kobj, struct xswap_sysfs_dev, kobj)->si;
> +       unsigned long val, clusters, new_pages, used;
> +       int err;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       err =3D kstrtoul(buf, 0, &val);
> +       if (err)
> +               return err;
> +
> +       spin_lock(&swap_lock);
> +       if (!(si->flags & SWP_WRITEOK)) {
> +               spin_unlock(&swap_lock);
> +               return -ENODEV;
> +       }
> +
> +       used =3D swap_usage_in_pages(si);
> +
> +       clusters =3D DIV_ROUND_UP(val, SWAPFILE_CLUSTER);
> +       if (clusters > si->nr_clusters_max)
> +               clusters =3D si->nr_clusters_max;
> +       /*
> +        * The ceiling can never be below the pages in use: the clusters
> +        * covering them stay mapped, and si->pages is the ceiling
> +        * capacity, so the free slots in the partially used top cluster
> +        * are credited instead of being allocatable but unaccounted for.
> +        */
> +       clusters =3D max_t(unsigned long, clusters,
> +                        DIV_ROUND_UP(used + 1, SWAPFILE_CLUSTER));
> +
> +       spin_lock(&si->lock);
> +       si->nr_clusters =3D clusters;
> +       spin_unlock(&si->lock);
> +
> +       new_pages =3D min_t(unsigned long, clusters * SWAPFILE_CLUSTER, s=
i->max);
> +       if (new_pages)
> +               new_pages--;
> +
> +       if (new_pages < used)
> +               new_pages =3D used;
> +       if (new_pages !=3D si->pages) {
> +               long delta =3D (long)new_pages - (long)si->pages;
> +
> +               si->pages =3D new_pages;
> +               atomic_long_add(delta, &nr_swap_pages);
> +               total_swap_pages +=3D delta;
> +       }
> +       add_to_avail_list(si, false);
> +
> +       spin_unlock(&swap_lock);
> +
> +       return count;
> +}
> +
> +static struct kobj_attribute xswap_limit_attr =3D
> +       __ATTR(limit, 0644, xswap_limit_show, xswap_limit_store);
> +
> +static void xswap_dev_release(struct kobject *kobj)
> +{
> +       kfree(container_of(kobj, struct xswap_sysfs_dev, kobj));
> +}
> +
> +static const struct kobj_type xswap_dev_ktype =3D {
> +       .sysfs_ops =3D &kobj_sysfs_ops,
> +       .release =3D xswap_dev_release,
> +};
> +
> +static int xswap_dev_kobj_add(struct swap_info_struct *si)
> +{
> +       struct xswap_sysfs_dev *dev;
> +       int err;
> +
> +       if (!xswap_kobj)
> +               return 0;
> +
> +       dev =3D kzalloc_obj(*dev, GFP_KERNEL);
> +       if (!dev)
> +               return -ENOMEM;
> +       dev->si =3D si;
> +
> +       err =3D kobject_init_and_add(&dev->kobj, &xswap_dev_ktype, xswap_=
kobj,
> +                                  "type%d", si->type);
> +       if (err) {
> +               kobject_put(&dev->kobj);
> +               return err;
> +       }
> +
> +       err =3D sysfs_create_file(&dev->kobj, &xswap_limit_attr.attr);
> +       if (err) {
> +               kobject_del(&dev->kobj);
> +               kobject_put(&dev->kobj);
> +               return err;
> +       }
> +       si->xswap_dev_kobj =3D &dev->kobj;
> +       return 0;
> +}
> +
> +static void xswap_dev_kobj_del(struct swap_info_struct *si)
> +{
> +       struct kobject *kobj =3D si->xswap_dev_kobj;
> +
> +       if (!kobj)
> +               return;
> +       si->xswap_dev_kobj =3D NULL;
> +       sysfs_remove_file(kobj, &xswap_limit_attr.attr);
> +       kobject_del(kobj);
> +       kobject_put(kobj);
> +}
> +
> +/* Create a file-less xswap device.  The address space reaches twice RAM=
;
> + * the device is created capped at RAM, and type<N>/limit raises that ca=
p
> + * up to si->max.
>   */
>  static int xswap_create(int prio)
>  {
>         struct swap_info_struct *si;
> -       unsigned long ram, maxpages;
> +       unsigned long ram, maxpages, nr_clusters;
>         int error;
>
>         if (prio !=3D DEF_SWAP_PRIO && (prio < 0 || prio > SWAP_FLAG_PRIO=
_MASK))
> @@ -4464,10 +4600,13 @@ static int xswap_create(int prio)
>         if (maxpages < 2)
>                 maxpages =3D 2;
>
> +       nr_clusters =3D DIV_ROUND_UP(ram, SWAPFILE_CLUSTER);
> +
>         si->bdev =3D NULL;
>         si->flags |=3D SWP_XSWAP | SWP_SOLIDSTATE;
>         si->max =3D maxpages;
> -       si->pages =3D maxpages - 1;
> +       si->pages =3D min_t(unsigned long, nr_clusters * SWAPFILE_CLUSTER=
,
> +                         si->max) - 1;
>         /*
>          * No backing file: setup_swap_extents() is only reachable from t=
he
>          * file-backed swapon() path, so set ops here.  Only ops->flags i=
s
> @@ -4480,6 +4619,8 @@ static int xswap_create(int prio)
>         if (error)
>                 goto bad_swap;
>
> +       si->nr_clusters =3D min(nr_clusters, si->nr_clusters_max);
> +
>         error =3D zswap_swapon(si->type, si->max);
>         if (error)
>                 goto bad_swap;
> --
> 2.54.0
>

