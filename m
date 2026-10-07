Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1303CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 06:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA8D6B0088; Wed,  7 Oct 2026 02:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC0C6B008C; Wed,  7 Oct 2026 02:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A9F6B0092; Wed,  7 Oct 2026 02:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5DA6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:32:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23A121C337B
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:32:27 +0000 (UTC)
X-FDA: 85294861134.08.4AC6A33
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4930BC0006
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:32:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fBqRjibn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791354745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Bbm+Jt9jzddxkMmLohq8T3HSBTZ/bcZvbUTV/gvMg8=;
	b=w/pa153DHWo7qAYhVa8OFdtwEYdnieSDvcy0BMtFbQAyR/8Qsvv7/1XQAZERAJAWudVr8i
	yyjL7rn77EDVcXnc6bijAUDg1AUhhgA4866HSIovmBh7TyWulBZxrB3jEdbtaMMXdXI0mZ
	LO4rH4oKvqtXqk8EvsjugTFdrlxi2vo=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fBqRjibn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791354745;
	b=MtSSFA4Kl+/Cgh2/ZiD8oufa8g3qd64s/HfZ5TkIT6V+XDUok56F3FzfMTUa5BTIYROQuh
	EHYx2Uyhi+1GAjxh0b7QY8SoxrD6AjuPR6kfhAvQohg3uTuSCLBfHsY+LRSjAtJQzuW90l
	0wm+Sp0JbY59Jzn6Vw4UskUbB4Qz3FY=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49ff680331aso37150315e9.3
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 23:32:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791354744; cv=none;
        d=google.com; s=arc-20260327;
        b=MNXcpxpwzdOWmzx16rSh0+N275CjT3hFsSfRdXo8DSUw/bRKGgfDBBOoMdLM64OzSp
         1PAK/YX4dpfZEkmHqAP5mgrGkQ6SolZTeNZfChzG9VHXYQfpK7klDWeOKJAH4540EDsc
         xDwlhOtSf88xi3io11bfCPNnHYeAeTBOkehmfreBhhac809SSARyq0pMT/nj7tJf3uaq
         JjJBYzqPaE18xx7bSVxv5GFXo1ns7wNOKh7pc8rP2qnVLzAlJorA28lG09Bnwu3EDhUp
         Mna1xGwQ/49tHtv9uVLMBSSEfbmJV8cZzhcrxKJfFZMz0UVdCINr4XyD39MoNqhodw62
         i99A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Bbm+Jt9jzddxkMmLohq8T3HSBTZ/bcZvbUTV/gvMg8=;
        fh=7hA4/DtOkRXrU+dD6PZgS5g/08x4uElnFZrA1GeomiA=;
        b=ZQ9XqZxVvRashGtObbPT3hhBBXOfhX9WyxcwmSTAz6ne8E1jTP02ssgD14RNYjcTKO
         2LtSSIBEHstvy6Qr8/zYQnQVanlYrpfOJatpOKYz1OrCU4hpFGqCptT2So3FA3JVIIlh
         Qzt4BhbFo17yrV/JhE1OLF6FEAiPzz54IggEMmL/K4dItdKKt76AWYqY7+UY5b+ZliAT
         qDsb9cmAxmZ1AAKL+6qU9XpCVzKM8HzS7oj7FDTgenwyo00D4wzA5BCPTZUrlYGIT567
         uq0Wp9GGHo/yzaLDRC0YJfWNGnYJXCRgo1gqfdJsCSmZV2DWSc1XM8NUC/mo86xEl2bV
         xeNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791354744; x=1791959544; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1Bbm+Jt9jzddxkMmLohq8T3HSBTZ/bcZvbUTV/gvMg8=;
        b=fBqRjibn/nrZuprFt/FcEKL0D1dxn/XwCoeXpVSFAUEf+L1kgTkz5MXpwmtyBUySor
         ZSS7/BK5zdYmEeHcvCjSw5cQZPAVQv9VLO7OQ795k6OeQo0whn2MjsGUAnD5Vd9ozJSR
         UVQJigaodn2JXZJXiAlIYsDrys0xZXK9jXtpdUXvVHN9l06rQNSMln0fvZkIS8ANvT7l
         oIEKQ+TIeijFGAT3Fpc7VUZu1DKIHuHfVfZ9HFfbnbNraRuHpqtnIFjHoEtAx4XPZRaA
         b53oc4UN9zpHGi7P2UjWNZgWIJ66e9ORmREIBo6eTtiyVLN4qAa9LNqLzcMDlfTXRHJz
         yrhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791354744; x=1791959544;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Bbm+Jt9jzddxkMmLohq8T3HSBTZ/bcZvbUTV/gvMg8=;
        b=dF5bX4xGcKoYKX6MIjJBfcb48jqYgGlqPCPJ0dBTBNuaPcU8wQdihEmtBrbpCQtbms
         1EB6aCC4ZrY2zI3T/uWBoHjWS08lwKRcCHi/I/0WeCR2G0r2o8u4Vl58n+kZRZwRvvQD
         ZchCZ3t82ZWtf+L1DxtZd4FEc7t9shH06N1OQKok294DTnGa4hSG7f4aBqOIJsiCCpNV
         miUhgqzd1lxUMSFrB+znycqyOs9nVXHZ5aiQ73yeN31l8qbn1NuzpvpElQhOc2BavDmI
         G41Gwl64XK08uM0GzvCJ9tDLVUhuxn/CZM7DnjWvYgj3M1rMNPwEF/ezenydkHgmG7Az
         8w4g==
X-Gm-Message-State: AFuF++mSQlELDE5+xvsprdnj7ollBVvRbSq9e6DJ9Vt821DA3muUvFl0
	ZNSeDrppkj7nL7YSyF8anN3o55BqiFz31EO8igWLFESimT/NpkEHcHsHF01km1EjMlbLUtH4Z7F
	9u89Lw1H4ZsmCdwD+z9e4l3jDhRRUEpQTdn97+L7O1A==
X-Gm-Gg: AYBFou0BRTnHxH6Au+8+2ur8sK+tIQFxfBiLEZBovo7iNbrPvn4beLa5xuuT28fD9uA
	kDkmMibk9UhUHNSgO0E6+2CScDFKK1scmVo1Ym74Ur4MaEmJpkk023n1LBf3Ia1yYKOsG7vioiq
	FSQt5bhq/hpfw1TZQlXRuOYR7rbYZ+gSljKmCgYOGh2JuClIIo/sfBzkXx1cvBRJDSsv4+R3RCH
	lwTVng4Uut47tanBazRwyzvdpgxjaQdCM1zE6wRh+MFRPh862yNCDXKzp2EbTflJlj5AQQSIfT/
	vc4OmZYiUsOB5NXOBI2/jEaHpg2lzcZbaXMZwoofwhlnh61Iwul+vgqoWiJTEDDRPzCs
X-Received: by 2002:a05:600c:8115:b0:49e:7a00:b9a5 with SMTP id
 5b1f17b1804b1-4a1802dc9a6mr13837625e9.4.1791354742898; Tue, 06 Oct 2026
 23:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20261003003136.750633-1-hebaoquan@kylinos.cn> <20261003003136.750633-5-hebaoquan@kylinos.cn>
In-Reply-To: <20261003003136.750633-5-hebaoquan@kylinos.cn>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Wed, 7 Oct 2026 14:32:11 +0800
X-Gm-Features: AclHuK8ioXsPhv8_cUzws9u2NgzD0PJNj5QWO-aICF4rQ9f-Ad3gjVsuRLcIrTg
Message-ID: <CAN_Opa9UncjeNSN9AHkaZPO1b2MqAK7VsDDweig6B9R4GpXVuA@mail.gmail.com>
Subject: Re: [PATCH v4 04/14] mm, swap: add sysfs create interface for xswap
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, klarasmodin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4930BC0006
X-Rspam-User: 
X-Stat-Signature: tax4jyhxfpfzoqu5poagyi3m7qhtos3q
X-HE-Tag: 1791354745-418754
X-HE-Meta: U2FsdGVkX194yQpy41mJDa4Se4ujpllHcCn4b5XRPS0gMR9xRCaR72htVWDIRp3Ojly4AfyP8hI9NwpLw73dun80oDmdpd29V74hxzp+gxNzuTaGQkoGBHgvdj+YfIJsmlu+M8NogVtap1g/+uqzW7GHzuN77TmsuyJKREdkBQS/NEv79E3DNg24vEvWpUEKVcewdUqbyq9JC808K96tTsr4Ka6kIJik8Yl83fIMz31HYJTG+5/B3fAm6SXdI1yoKBEYmLoy+Ft9TScLsUGreK4nl2marXwpN4u2OgrNDoiJ2qBySY5GptMOP68/GV9VTeBOvtpZj1kOjzGAxY+6O7T77HAAg1537x34YaKGHtYYo9L+kVWM6TSVZsnRg5RwWSc7CDLPlfDjXgqYmLym+Nmis0pVMcUJLq1Vb3n0LnRbPsDyKadStRtJiY66g9o81NjQBD490y5giI3ynqLcRHLPX9tmD3rqpkwUihdlG5ZHjA9WDg+h/C7iPKMJgmcEXNJtEcmkR5/PJ29jQ3KO9S/db1b7fcsFjOWsqrsTzd3g51+D29DYXh9alu3xEzQwep27It2Tk/kKRjCqJ5JL5JSNXC1fNBgx/jAvjzkcY2CgiQxr1zGGgn6+qlDCstcsieQY2vpREbEeCp0hzYDEARzd+ILUcdVc5GoTpZDaDs4Sb2zVbbjgzLlH61hO8oojaK/phsPDAK2aVJk69ClC6V34VEEyTgiMrbArKWv1KvO5PuVaCUt3TApfnKmdfwBsMu4t5FUyb5Ym266T8vWLcn7yfzbPKMR7efCVGXoaAUvVt41VfcqySXbahX7D5Jf8mrpOR/9ZFLXWN2tVwx6TkcD5rtQSZWj4hsbAzzCfz1NEz4W01r/bzukvsSCsREbA1FWZrtiP2Ql6nffJNhDB5SezTK1R11LmVSbBARQQtHIMGufh6WwVAV5B5bdblG4YIcMfSeN/LYOmXsZ5X/5
 Rc64gcOM
 jlNgBXiJRMPU/f4X2mDz3Q65jtS3b6piT3IrfcpCQQVLIfi4UQOOw1Wbp48Gn09N44+TTIJ45N1hrGLJdgPlbFWOe5fptly7oBhmq7q+VX8OB+8O8dHErKBZg1rz0ZtTwXCuWHjRe/sQR/hoqJXSAd0LnkcqsTkhWI3JC5496uSTLy+C/6rR9RvBdnOwMhA96F0r3j1wud7vq+iBLIobGOPJ7ZiCONTqMPkmyMCwEOO3F9xoqeIGJMbl8IdEj+qpTRxn/Vc9Gau7QwjJd7yzj98Ga0eKIz2SSuMd0h8qNtZBKlJZFZgMGyo0e4sHRSoKhtnYRw0IjPG/NqjJlfAFwvYWSbx9NEa+ycoN4JZ6EQ8j2EN7VJaHAf7iZueEBf1RI6FPqGhR7idcZadNWK1+VCrFuPfMGIq6A4SwG6u02dk0qAtBboeJRoVyWeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 8:32=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> wr=
ote:
>
> xswap devices have no backing storage, so there is no file to swapon.
> Add a sysfs interface to create them directly:
>
>   /sys/kernel/mm/xswap/create    write an optional priority to create
>                                  a device, empty for the default
>
> A new device is created with si->max and nr_clusters_max both equal to
> twice RAM: the cluster_info array is a sparse VM_SPARSE area mapped
> lazily, so an idle device costs nothing. The device shows up in
> /proc/swaps as "xswap<N>".
>
> It takes the highest priority by default. Swapout picks the
> highest-priority device that has room, so a real device ahead of an xswap
> one would take the page directly: zswap would still cache it, but the
> slot on the real device is taken either way, and not taking it is the
> point of xswap. A lower priority can be asked for, not a higher one.
>
> Hibernation device discovery skips xswap devices: they have no bdev
> to carry a resume image.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  mm/swapfile.c | 169 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 164 insertions(+), 5 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 767d3f46877f..9c204e455ef9 100644
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
> @@ -48,6 +50,13 @@
>  #include "swap_table.h"
>  #include "internal.h"
>  #include "swap.h"
> +#define DEF_SWAP_PRIO  -1
> +
> +/*
> + * Above every real swap device: one ahead of xswap would take the page
> + * directly, and taking that slot is what xswap exists to avoid.
> + */
> +#define DEF_XSWAP_PRIO SWAP_FLAG_PRIO_MASK
>
>  #ifdef CONFIG_XSWAP
>  /*
> @@ -66,7 +75,65 @@ static int xswap_map_clusters(struct swap_info_struct =
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
> +       int prio =3D DEF_XSWAP_PRIO;
> +       int err;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       /* "[<prio>]" is optional; a lower one is allowed, not a higher. =
*/
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
> +       if (sysfs_create_group(xswap_kobj, &xswap_attr_group)) {
> +               pr_err("xswap: failed to create sysfs group\n");
> +               kobject_put(xswap_kobj);
> +               xswap_kobj =3D NULL;
> +       }
> +}
> +#else /* !CONFIG_XSWAP */
> +static inline void xswap_sysfs_init(void)
> +{
> +}
> +#endif /* CONFIG_XSWAP */
>
>  static void swap_range_alloc(struct swap_info_struct *si,
>                              unsigned int nr_entries);
> @@ -94,7 +161,6 @@ atomic_t nr_real_swapfiles;
>  EXPORT_SYMBOL_GPL(nr_swap_pages);
>  /* protected with swap_lock. reading in vm_swap_full() doesn't need lock=
 */
>  long total_swap_pages;
> -#define DEF_SWAP_PRIO  -1
>  unsigned long swapfile_maximum_size;
>  #ifdef CONFIG_MIGRATION
>  bool swap_migration_ad_supported;
> @@ -2275,6 +2341,9 @@ static int __find_hibernation_swap_type(dev_t devic=
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
> @@ -2462,6 +2531,8 @@ int find_first_swap(dev_t *device)
>
>                 if (!(sis->flags & SWP_WRITEOK))
>                         continue;
> +               if (sis->flags & SWP_XSWAP)
> +                       continue;
>                 *device =3D sis->bdev->bd_dev;
>                 spin_unlock(&swap_lock);
>                 return type;
> @@ -3425,7 +3496,8 @@ static void *swap_start(struct seq_file *swap, loff=
_t *pos)
>                 return SEQ_START_TOKEN;
>
>         for (type =3D 0; (si =3D swap_type_to_info(type)); type++) {
> -               if (!(si->swap_file))
> +               if (!si->swap_file &&
> +                   !((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK=
)))
>                         continue;
>                 if (!--l)
>                         return si;
> @@ -3446,7 +3518,8 @@ static void *swap_next(struct seq_file *swap, void =
*v, loff_t *pos)
>
>         ++(*pos);
>         for (; (si =3D swap_type_to_info(type)); type++) {
> -               if (!(si->swap_file))
> +               if (!si->swap_file &&
> +                   !((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK=
)))
>                         continue;
>                 return si;
>         }
> @@ -3488,7 +3561,14 @@ static int swap_show(struct seq_file *swap, void *=
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
> @@ -4011,6 +4091,83 @@ static int setup_swap_clusters_info(struct swap_in=
fo_struct *si,
>         return err;
>  }
>
> +#ifdef CONFIG_XSWAP
> +/* Create a file-less xswap device, sized at twice RAM. */
> +static int xswap_create(int prio)
> +{
> +       struct swap_info_struct *si;
> +       unsigned long ram, maxpages;
> +       int error;
> +
> +       if (prio !=3D DEF_XSWAP_PRIO &&
> +           (prio < 0 || prio > SWAP_FLAG_PRIO_MASK))
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
> +       pr_info("xswap: adding extendable swap type %d (prio %d, %u pages=
, max %lu)\n",
> +               si->type, prio, si->pages, maxpages);
> +       mutex_unlock(&swapon_mutex);
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
> @@ -4357,6 +4514,8 @@ static int __init swapfile_init(void)
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

The create path and priority handling look consistent with the
existing swap priority rules. In particular, an xswap device has no
`swap_file`, and the changes to `swap_show()` / `swap_start()` /
`swap_next()` account for that when enumerating and displaying swap
devices.

The `VM_SPARSE` mapping avoids allocating the full cluster metadata
backing up front, while allowing the mapped range to grow later.

The overcommit interaction (`si->pages` -> `total_swap_pages` ->
`__vm_enough_memory()`) is an open design item already called out in
the cover letter. I don't see it as a reason to block this phase, but
it should remain explicitly tracked.

Acked-by: Kunwu Chan <chentao@kylinos.cn>

Thanks,
Kunwu

