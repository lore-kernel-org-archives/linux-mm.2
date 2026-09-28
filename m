Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EC5C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122AB6B008C; Mon, 28 Sep 2026 01:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD2B6B0092; Mon, 28 Sep 2026 01:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6DD6B0093; Mon, 28 Sep 2026 01:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD7666B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:40:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EB1C120B8C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:40:23 +0000 (UTC)
X-FDA: 85262070726.13.E529743
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7AF1AA0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:40:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m96MPt4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790574021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MV+9uT31RGIb/UayWDRDIElXeBW1lCojsnaPgq9d99M=;
	b=5gGlXOolBWgd8ddp9DKs5j4UobfzwVVBsev6EhCseGFlFul8fBQPp4RHvfqHS6gABqbPVk
	0dmJai6Y9oXqPsBnIKT9rONT9CV0wXl7rHoECgQuFZuNq01S94VyVQ2rcPug7tlyBbhUG/
	vF2J/xQq+8NaOzAd74mb8LL/bsxUMGM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m96MPt4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790574021;
	b=sHuRQczmcpoo7BaqRMkj8DrrEUQe6o8ZXwaRDhRjJGiozXJMHcEceafPRcgTuTY3h1/pw8
	yTEeKE+NQAwE7fORnwgZFM//aUCI1xsXsahD+YMtgsGAUHcSZ2rcfaJwqWISTeumN8gFbS
	E4mkmKjLhWFHIJr1HpnDpGj2bkAeLC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C675260D7A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2EF1F0089A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790574020;
	bh=MV+9uT31RGIb/UayWDRDIElXeBW1lCojsnaPgq9d99M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=m96MPt4w/pIuDrrxyHSvgqfg2HwVD8JFouZQT0e0Ehg0riYvezvd+elyfo/xcIYbG
	 URzkLwrOePXPVnbgccvhJ7hGrI5VLSzJTPPFV1xZx/0pA6PlSmaqy92hwe15PE2CC0
	 8PZhYwcmFCHOwtSN1RxnqUbI1hYKsKMzq9NwNVdI5C7QcmPRqkEYXXQM/5+OL6KLuq
	 Tau8krt+eBxk15S2vUenqbIPvb/CNGYrSC8FzrwLxr3ZpV8O9IjDPKffSKv2uyrhFa
	 oXxb8/I6skqmqSvaoyHgOyXfqBVMgHM79GjxCnfJvtmF3HLVH0lD+h4Av+BwPm+vyC
	 HOhMqlcbCK6Ug==
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2dc50c6edfso108389266b.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:40:20 -0700 (PDT)
X-Gm-Message-State: AFuF++nu0nKV+kWTyQ5m7L+5IHGWM/1YMU/sTXOT51MtRTemfhDkl7n8
	EdK5yMvlzXHnwDdRKrxYFqk/FW6ZEVefS3AmCZQ/Q8whSMhkW+0usrh+IYaH4yge2O+bhs9uX6S
	p2vww93b6vIfqdZ/71Y9EVlvrJC2r0YVmOvlCnAwx/g==
X-Received: by 2002:a17:907:e0c7:20b0:c2d:c247:5400 with SMTP id
 a640c23a62f3a-c2dc2475ef8mr185889766b.27.1790574019351; Sun, 27 Sep 2026
 22:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-11-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-11-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 19:40:07 -1000
X-Gmail-Original-Message-ID: <CACePvbUn4xBNkKBjyniG0TLb5bA8wGNBiJ77JTF8FDGN9EgCWQ@mail.gmail.com>
X-Gm-Features: AclHuK8WVKaVl1u64EutxBAqx3N9IFZl8yBqJ6pjUQ8gMAlho2HuiWEWZdOufEY
Message-ID: <CACePvbUn4xBNkKBjyniG0TLb5bA8wGNBiJ77JTF8FDGN9EgCWQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/14] mm, swap: refactor swapoff and add xswap_destroy
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7AF1AA0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pt88m3fejmqtwy9zqjzkqm4n8wo5fekx
X-HE-Tag: 1790574021-448708
X-HE-Meta: U2FsdGVkX1+ogxFSyhxxKnCZcJdo3UpVCthjtT+dbZiPqra+/6gtu8O1Ge65HWQ1Xaro0qFf0+YETOlCa2YC2ZpJy9bAYOGn6Te2Gj/d84LpIFIe4dIJYklpJUyApF5klk1fgNhx2lkyHhhBjsW6unGKIPMVCGE56OWcg74g5UfsFqUTrEEIGamA2+mvOd9bduhhbGm03XlZRvyJ2T9oB+ix1raZXOhtVUSYMq11WR+z/SaJqkkYw4yUWXZlyokL5CiCA+brP05WXzdz+wI5kdwFhrUcorpdY00nvjytTi7RfzRiieifh0iD/rsPecW8DfjjjywBOX122i02yzxeDibwnOcL5+rXrZO7mNvbgTLYMNchPxiHaGbqhJS2j2t/hBWjE7nRijAat6bqU8LaEq5H9EOlXidYmLACo33pdx4K01aqYTs8M6CmHwrIKxDWYvka+majCKYsTLf9+AvEftusPJ2I+Et09/rZfilR6BZx5a13yi18/2olzXh3MGBzjqkXZKfzFOnBjVMNiswaaBdOGiyr0I9LKAfLN+X5eZv/TTlkhd1wFWz+OsnOSdqT6w7wI+/7+cYSjCkepU96RaP5BVbCXC8fmSTZmJJMr5S4YELccg7EwRAy2Co78oQXfxz1lKK8M8i8CrctYW2Hrr3q/ZV3eLVik04gJfdLV+cNo8RVsThKt0Wt7TpLVnJz37LfevI4XbGKz5ipNN9aYv3rFw2ve6UA/V1EcuLtELc7ZTCmMAo0EigmDp8HHP3Rzpd++TjowzJNhadlBiXZrLCVcJyHKIhx85mYsC5KMaYSWH9fPoXARpmIKfqug4IwSDJtRM+5jQPHhdhtDH3fyGer5oT5ekKwga+InPd9hAJm//9IYrY7vXDIWn/TRX+Tsb2mRnu0XdRluWoi2DVvAf5jrfqQ/VK3dXw46b6xtQy9IWMAijI7s7wBI42QTV/Ji+exA51Elykfal61keY
 NkpA7a7S
 9LH1Vhud5YJcabjDzys2baqeeIE6Ux9ce9uH0bh/2LmjyaGWq9IluTh/OyBCbP/bRloG0nVJ0tzJRMpBp7dV83N/wno3V90lMkAPFKo9rU+AouLnH2TcBz6qcSRIZLAyJsffl0wyLeyrqaRkz8rTBwUzl7/wlOSFrurMmH2eqgbe0Rdn54wArZJWZzFLivOpl6wyKiiIuOZgMFV1Yf1x+x8P48EC9fIrrhSiQAbaFSGVHUzTOGCJWQFQWFJ9RJyQ8eKNufKXtLsLU6NT4stOLhf0YvXf/ujSlcmyeebrbLog136Z7Lank5LnST4P1YO3JpU2HoQsSK7U8u6t/wp3zmOEkKbiPmQ1O+DGLuRmKsfGeWaccxAUyuHbUf1q22qOaHWsM1YaXKzGg7zO8N5TxzoAzwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:21=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> Extract __swapoff() from sys_swapoff() so the teardown logic can be
> shared, and make it work for file-less devices.
>
> Add xswap_destroy() to tear down a file-less xswap device by swap type,
> exposed via /sys/kernel/mm/xswap/destroy. Writing a swap type tears down
> that device; it requires CAP_SYS_ADMIN.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  mm/swapfile.c | 205 +++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 151 insertions(+), 54 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 351c68bcd70b..cdcbcbaa6d87 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -73,6 +73,7 @@ static int xswap_mapped_end(pte_t *pte, unsigned long a=
ddr, void *data);
>  static void xswap_try_shrink(struct swap_info_struct *si);
>
>  static int xswap_create(int prio);
> +static int xswap_destroy(int type);
>
>  static ssize_t xswap_create_store(struct kobject *kobj,
>                                   struct kobj_attribute *attr,
> @@ -103,8 +104,35 @@ static ssize_t xswap_create_store(struct kobject *ko=
bj,
>  static struct kobj_attribute xswap_create_attr =3D __ATTR(create, 0200, =
NULL,
>                                                         xswap_create_stor=
e);
>
> +static ssize_t xswap_destroy_store(struct kobject *kobj,
> +                                  struct kobj_attribute *attr,
> +                                  const char *buf, size_t count)
> +{
> +       unsigned long type;
> +       int err;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       err =3D kstrtoul(buf, 0, &type);
> +       if (err)
> +               return err;
> +       if (type >=3D MAX_SWAPFILES)
> +               return -EINVAL;
> +
> +       err =3D xswap_destroy(type);
> +       if (err)
> +               return err;
> +
> +       return count;
> +}
> +
> +static struct kobj_attribute xswap_destroy_attr =3D __ATTR(destroy, 0200=
, NULL,
> +                                                        xswap_destroy_st=
ore);
> +
>  static struct attribute *xswap_attrs[] =3D {
>         &xswap_create_attr.attr,
> +       &xswap_destroy_attr.attr,
>         NULL,
>  };
>
> @@ -3399,65 +3427,44 @@ static void flush_percpu_swap_cluster(struct swap=
_info_struct *si)
>  }
>
>
> -SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)

Here you relocate the swapoff function and causing a lot of diff
context due to the code movement.

I move your swapoff code back, right after
flush_percpu_swap_cluster(). Then the diff is much cleaner around
swapoff.

For example, here is what the new diff showed:
SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
        struct swap_info_struct *p =3D NULL;
@@ -3391,6 +3393,11 @@ SYSCALL_DEFINE1(swapoff, const char __us
        spin_unlock(&p->lock);
        spin_unlock(&swap_lock);

+#ifdef CONFIG_XSWAP
+       if (p->flags & SWP_XSWAP)
+               cancel_work_sync(&p->xswap_shrink_work);
+#endif
+
        wait_for_allocation(p);

        set_current_oom_origin();

It means we will need some swap_ops->swapoff() for handling the async
workqueue canceling.

Chris

> +/*
> + * Drop @p from the avail and active lists and undo its accounting.  The
> + * caller must hold swap_lock and have checked that @p is WRITEOK and no=
t
> + * pinned for hibernation.
> + *
> + * Returns 0, or -ENOMEM with swap_lock still held.
> + */
> +static int swap_info_remove(struct swap_info_struct *p)
>  {
> -       struct swap_info_struct *p =3D NULL;
> -       struct file *swap_file, *victim;
> -       struct address_space *mapping;
> -       struct inode *inode;
> -       int err, found =3D 0;
> -
> -       if (!capable(CAP_SYS_ADMIN))
> -               return -EPERM;
> -
> -       BUG_ON(!current->mm);
> -
> -       CLASS(filename, pathname)(specialfile);
> -       victim =3D file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
> -       if (IS_ERR(victim))
> -               return PTR_ERR(victim);
> -
> -       mapping =3D victim->f_mapping;
> -       spin_lock(&swap_lock);
> -       plist_for_each_entry(p, &swap_active_head, list) {
> -               if (p->flags & SWP_WRITEOK) {
> -                       if (p->swap_file->f_mapping =3D=3D mapping) {
> -                               found =3D 1;
> -                               break;
> -                       }
> -               }
> -       }
> -       if (!found) {
> -               err =3D -EINVAL;
> -               spin_unlock(&swap_lock);
> -               goto out_dput;
> -       }
> -
> -       /* Refuse swapoff while the device is pinned for hibernation */
> -       if (p->flags & SWP_HIBERNATION) {
> -               err =3D -EBUSY;
> -               spin_unlock(&swap_lock);
> -               goto out_dput;
> -       }
> -
>         if (!security_vm_enough_memory_mm(current->mm, p->pages))
>                 vm_unacct_memory(p->pages);
> -       else {
> -               err =3D -ENOMEM;
> -               spin_unlock(&swap_lock);
> -               goto out_dput;
> -       }
> +       else
> +               return -ENOMEM;
> +
>         spin_lock(&p->lock);
>         del_from_avail_list(p, true);
>         plist_del(&p->list, &swap_active_head);
>         atomic_long_sub(p->pages, &nr_swap_pages);
>         total_swap_pages -=3D p->pages;
>         spin_unlock(&p->lock);
> -       spin_unlock(&swap_lock);
> +       return 0;
> +}
> +
> +/* Common swap teardown after list removal; shared by sys_swapoff() and
> + * xswap_destroy().
> + */
> +static int __swapoff(struct swap_info_struct *p)
> +{
> +       struct file *swap_file =3D NULL;
> +       int err;
>
>  #ifdef CONFIG_XSWAP
> -       if (p->flags & SWP_XSWAP)
> +       if (p->flags & SWP_XSWAP) {
>                 cancel_work_sync(&p->xswap_shrink_work);
> +               /* Wait out a shrink racing us from the sysfs write path.=
 */
> +               mutex_lock(&p->xswap_lock);
> +               mutex_unlock(&p->xswap_lock);
> +       }
>  #endif
>
>         wait_for_allocation(p);
> @@ -3469,7 +3476,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         if (err) {
>                 /* re-insert swap space back into swap_list */
>                 reinsert_swap_info(p);
> -               goto out_dput;
> +               return err;
>         }
>
>         /*
> @@ -3509,15 +3516,21 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
>         kfree(p->global_cluster);
>         p->global_cluster =3D NULL;
>         free_swap_cluster_info(p);
> +       /*
> +        * The device is off swap_active_head and no longer WRITEOK, so n=
o
> +        * reader can observe these; clearing them here needs no lock.
> +        */
>         p->max =3D 0;
>         p->cluster_info =3D NULL;
>
> -       inode =3D mapping->host;
> +       if (swap_file) {
> +               struct inode *inode =3D swap_file->f_mapping->host;
>
> -       inode_lock(inode);
> -       inode->i_flags &=3D ~S_SWAPFILE;
> -       inode_unlock(inode);
> -       filp_close(swap_file, NULL);
> +               inode_lock(inode);
> +               inode->i_flags &=3D ~S_SWAPFILE;
> +               inode_unlock(inode);
> +               filp_close(swap_file, NULL);
> +       }
>
>         /*
>          * Clear the SWP_USED flag after all resources are freed so that =
swapon
> @@ -3528,10 +3541,61 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
>         p->flags =3D 0;
>         spin_unlock(&swap_lock);
>
> -       err =3D 0;
>         atomic_inc(&proc_poll_event);
>         wake_up_interruptible(&proc_poll_wait);
>
> +       return 0;
> +}
> +
> +SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> +{
> +       struct swap_info_struct *p =3D NULL;
> +       struct file *victim;
> +       struct address_space *mapping;
> +       int err, found =3D 0;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       BUG_ON(!current->mm);
> +
> +       CLASS(filename, pathname)(specialfile);
> +       victim =3D file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
> +       if (IS_ERR(victim))
> +               return PTR_ERR(victim);
> +
> +       mapping =3D victim->f_mapping;
> +       spin_lock(&swap_lock);
> +       plist_for_each_entry(p, &swap_active_head, list) {
> +               if (p->flags & SWP_WRITEOK) {
> +                       if (p->swap_file && p->swap_file->f_mapping =3D=
=3D mapping) {
> +                               found =3D 1;
> +                               break;
> +                       }
> +               }
> +       }
> +       if (!found) {
> +               err =3D -EINVAL;
> +               spin_unlock(&swap_lock);
> +               goto out_dput;
> +       }
> +
> +       /* Refuse swapoff while the device is pinned for hibernation */
> +       if (p->flags & SWP_HIBERNATION) {
> +               err =3D -EBUSY;
> +               spin_unlock(&swap_lock);
> +               goto out_dput;
> +       }
> +
> +       err =3D swap_info_remove(p);
> +       if (err) {
> +               spin_unlock(&swap_lock);
> +               goto out_dput;
> +       }
> +       spin_unlock(&swap_lock);
> +
> +       err =3D __swapoff(p);
> +
>  out_dput:
>         filp_close(victim, NULL);
>         return err;
> @@ -4128,6 +4192,10 @@ static void xswap_try_shrink(struct swap_info_stru=
ct *si)
>
>         mutex_lock(&si->xswap_lock);
>
> +       /* A swapoff raced us and is about to walk this mapping. */
> +       if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
> +               goto out_unlock;
> +
>         nr_mapped =3D READ_ONCE(si->nr_clusters_mapped);
>         if (nr_mapped <=3D 1)     /* keep cluster 0 */
>                 goto out_unlock;
> @@ -4435,6 +4503,35 @@ static int xswap_create(int prio)
>         spin_unlock(&swap_lock);
>         return error;
>  }
> +
> +/* Tear down a file-less xswap device by its swap type. */
> +static int xswap_destroy(int type)
> +{
> +       struct swap_info_struct *p;
> +       int err;
> +
> +       p =3D swap_type_to_info(type);
> +       if (!p)
> +               return -EINVAL;
> +
> +       spin_lock(&swap_lock);
> +       if (!(p->flags & SWP_WRITEOK) || !(p->flags & SWP_XSWAP)) {
> +               spin_unlock(&swap_lock);
> +               return -EINVAL;
> +       }
> +       /* Refuse swapoff while the device is pinned for hibernation */
> +       if (p->flags & SWP_HIBERNATION) {
> +               spin_unlock(&swap_lock);
> +               return -EBUSY;
> +       }
> +
> +       err =3D swap_info_remove(p);
> +       spin_unlock(&swap_lock);
> +       if (err)
> +               return err;
> +
> +       return __swapoff(p);
> +}
>  #endif /* CONFIG_XSWAP */
>
>  SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flag=
s)
> --
> 2.54.0
>

