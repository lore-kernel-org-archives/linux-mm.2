Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61418E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 06:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2756B0088; Thu, 19 Feb 2026 01:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C9E6B0089; Thu, 19 Feb 2026 01:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B976B008A; Thu, 19 Feb 2026 01:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7634B6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:36:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 368081C48E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:36:53 +0000 (UTC)
X-FDA: 84460248306.04.4D17C05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8EB6140003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:36:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MvDf9Wkz;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771483011; a=rsa-sha256;
	cv=none;
	b=u9NV+mqBIjJfVHh/v2L/s3ClHeMiOex+XcYT5srhFBHmltni5GY0ab+rM4itjOpr9QMdhd
	7amhMyCIc+4iFZZ4KJtD7oZMPN0g2ngaTV/gPIMbk6etogJZxIr7WcFcVY/FDBQl6yquI/
	3R4N3Zf0NugOGDvQh35yVXy+SqAjTlg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MvDf9Wkz;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771483011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtYCdyeGjStVJLWG+tylZ446zjsFMfXHhOe5ONrd/3Q=;
	b=ZOhCao97w99WNUzQ12Fsfibtt4+ZB0NbQVVMI6Q5hYaw9Al2r/VYRU0iGtyLPudK9G3Olo
	YBl0gnkbuZvvM+u65Em+3z2QJo+ykVhdOYMBcoAiMaoAkU5juTw+RJQGPG5WuJDrU+zhj4
	VnocHGaDMQ5IpAeO/i+GWt5y6IBof4s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CD04160128
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D388C2BC86
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771483010;
	bh=tjZAYbFrGgaU+LGuhexyS16pH/zVLWIODCIgjNYKYDc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MvDf9Wkz83qtqmRi4Z7dDs3kYIMBqu7LmSbnC7kB4qiIkqfLtxN6UEJlvyoZdVLYe
	 YBALmX+U/i8vBqCbqjRjBYw9rI67lk4fRGuMCCJcgOD38w/hsXpBpnzXvZA7eV4XV9
	 a+5B9jdESDEl+FAd2vycqVAlK+wEYi+swn0ucgwwslZBxS0o2iLeRNr0J5sT94+hVU
	 LDh2s55tX2+w++UPLru6ASgl1CCOVuRWJxAwMTTJb68NOOIpSGRsqezuxOIwzWDo2q
	 xpQcv7bCUnyaO7UX6n/ZFa7abnVx7kRAac/+hrX6GCkiivP5uDr22A31sFlYV/wTWI
	 3BvK/SwuUEcbw==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64ad8435f46so483713d50.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:36:50 -0800 (PST)
X-Gm-Message-State: AOJu0YxNUO+pxOB8VBMFDpiPQy0aLhDCKFdEhNuw6XEE43571kvipbC6
	/R1SxRizZrxGQFgBXBxsXSkymqdCrP9p5x/e1N0lfFC0lXeG5+xbAgSVghhJZzmY4jA7JUy8bdm
	LKNGBVmA6wBDB1e/+eI46Z6DroVn2Qawn4VJRoasZBg==
X-Received: by 2002:a05:690e:1287:b0:649:e501:21a6 with SMTP id
 956f58d0204a3-64c21a40fcdmr14060381d50.16.1771483009614; Wed, 18 Feb 2026
 22:36:49 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-1-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-1-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 22:36:38 -0800
X-Gmail-Original-Message-ID: <CACePvbUHMZ1=tN-1KM2LAaY8AUXy+s13=Z6ijxxAzWGS9x3UpQ@mail.gmail.com>
X-Gm-Features: AZwV_QgBwbQ90_Ex1JF_aI-WtZ5YpttV9K_zceIpXNVAaJhhf-hlH3gR-IEy9pI
Message-ID: <CACePvbUHMZ1=tN-1KM2LAaY8AUXy+s13=Z6ijxxAzWGS9x3UpQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] mm, swap: protect si->swap_file properly and use
 as a mount indicator
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8EB6140003
X-Stat-Signature: f9qm7tbohgp4myo546ys39fnsk4tpy4s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771483011-290885
X-HE-Meta: U2FsdGVkX1/h9nSnJA1QwGeO6PDDxVb9AYNj01EikBB3GMxgA2Z4fO1n5sdeAVdZzt/zx/zM5kkh/idroQiy+yE7h80gl8sfwexlt7J60id0wkfXfMOPC61kUY/GPSyhDLf5wqgeWS9q9QBPvaohMaWJH9JLcfcezreFjSF1eFuYzIhg4l76c+n+ONa5FaAfrq4IDiK89CiAZ0IWNLiuykPb6wHA3j3JyusDGR1mnB/UiKlSHUS3ajTFk55oJ4Y38UdYKjvJusPsj3SB1g1vjnJb/1hUXDB1ZKQS9Lz4+uqZPLOQXCwW7eo/Rd3VZMmsV75urVhGfE0/7rFK0EVD4RqTBuxUgbVu66Zbvc1C9O30MB++LK+pOK9Iqe8hgZtOjZVaAnZFW/Mom9j9WC3mXCPYc83r8UlCNKRGvl+h+UCvxXvXcxCtrIkFEFTiNmBKAYkmQm61CzCq0dxnOC37I4d5LedXV+fNJwoUbcmrPhr3U5XiFvI9Kft24s3e/7d2BCexh8TAKttaGhfyWQMZUWxqU67zrv5zMO/tq3dKKAnbs9Br0Sy/85I/j4c7xOM/20PFDMDWvgubAbHkMF0r/iGOGJpILCqW0ZnYhNGe0BlnBTKeVFjMOi1EPTZmmysVUdT151aEw++PiRJNbl3USOqiix6iHSgdAadsEGQxi+MVyVy0kooQUxXXor80Ps0u4tIKgQ0Eag+KzxyDff7TdOXiO5VfkkW34AnNg69xCDrWknlJtZtoBhHgwatMRLP0uBjws6Vh3m5gK/JjqVv2z78J1y6/RNCCUKMpDUQv15g+49L6ZgOK+jrhi7PLftFURr1EJVSV6yab2bO8V2BYXXjsuPTclLs+h9h/bPlO9ZANXwX9AKJCwo1eq7nRKqUJm/qMloDkMYFbEMr5LS9zgWrA7OtL/THaUl+Llm6D8+72bV4+vo4C0aS17TR5h4pChIZ6wMIzD7ChaPpAiR/
 RAnWupyE
 hU6KkHj+m41J476CyEagkkFYJJpybTGcVy+NY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Tue, Feb 17, 2026 at 12:06=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> /proc/swaps uses si->swap_map as the indicator to check if the swap
> device is mounted. swap_map will be removed soon, so change it to use
> si->swap_file instead because:
>
> - si->swap_file is exactly the only dynamic content that /proc/swaps is
>   interested in. Previously, it was checking si->swap_map just to ensure
>   si->swap_file is available. si->swap_map is set under mutex
>   protection, and after si->swap_file is set, so having si->swap_map set
>   guarantees si->swap_file is set.
>
> - Checking si->flags doesn't work here. SWP_WRITEOK is cleared during
>   swapoff, but /proc/swaps is supposed to show the device under swapoff
>   too to report the swapoff progress. And SWP_USED is set even if the
>   device hasn't been properly set up.
>
> We can have another flag, but the easier way is to just check
> si->swap_file directly. So protect si->swap_file setting with mutext,
> and set si->swap_file only when the swap device is truly enabled.
>
> /proc/swaps only interested in si->swap_file and a few static data
> reading. Only si->swap_file needs protection. Reading other static
> fields is always fine.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 32e0e7545ab8..25dfe992538d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -110,6 +110,7 @@ struct swap_info_struct *swap_info[MAX_SWAPFILES];
>
>  static struct kmem_cache *swap_table_cachep;
>
> +/* Protects si->swap_file for /proc/swaps usage */
>  static DEFINE_MUTEX(swapon_mutex);
>
>  static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
> @@ -2532,7 +2533,8 @@ static void drain_mmlist(void)
>  /*
>   * Free all of a swapdev's extent information
>   */
> -static void destroy_swap_extents(struct swap_info_struct *sis)
> +static void destroy_swap_extents(struct swap_info_struct *sis,
> +                                struct file *swap_file)
>  {
>         while (!RB_EMPTY_ROOT(&sis->swap_extent_root)) {
>                 struct rb_node *rb =3D sis->swap_extent_root.rb_node;
> @@ -2543,7 +2545,6 @@ static void destroy_swap_extents(struct swap_info_s=
truct *sis)
>         }
>
>         if (sis->flags & SWP_ACTIVATED) {
> -               struct file *swap_file =3D sis->swap_file;
>                 struct address_space *mapping =3D swap_file->f_mapping;
>
>                 sis->flags &=3D ~SWP_ACTIVATED;
> @@ -2626,9 +2627,9 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
>   * Typically it is in the 1-4 megabyte range.  So we can have hundreds o=
f
>   * extents in the rbtree. - akpm.
>   */
> -static int setup_swap_extents(struct swap_info_struct *sis, sector_t *sp=
an)
> +static int setup_swap_extents(struct swap_info_struct *sis,
> +                             struct file *swap_file, sector_t *span)
>  {
> -       struct file *swap_file =3D sis->swap_file;
>         struct address_space *mapping =3D swap_file->f_mapping;
>         struct inode *inode =3D mapping->host;
>         int ret;
> @@ -2646,7 +2647,7 @@ static int setup_swap_extents(struct swap_info_stru=
ct *sis, sector_t *span)
>                 sis->flags |=3D SWP_ACTIVATED;
>                 if ((sis->flags & SWP_FS_OPS) &&
>                     sio_pool_init() !=3D 0) {
> -                       destroy_swap_extents(sis);
> +                       destroy_swap_extents(sis, swap_file);
>                         return -ENOMEM;
>                 }
>                 return ret;
> @@ -2862,7 +2863,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         flush_work(&p->reclaim_work);
>         flush_percpu_swap_cluster(p);
>
> -       destroy_swap_extents(p);
> +       destroy_swap_extents(p, p->swap_file);
>         if (p->flags & SWP_CONTINUED)
>                 free_swap_count_continuations(p);
>
> @@ -2952,7 +2953,7 @@ static void *swap_start(struct seq_file *swap, loff=
_t *pos)
>                 return SEQ_START_TOKEN;
>
>         for (type =3D 0; (si =3D swap_type_to_info(type)); type++) {
> -               if (!(si->flags & SWP_USED) || !si->swap_map)
> +               if (!(si->swap_file))
>                         continue;
>                 if (!--l)
>                         return si;
> @@ -2973,7 +2974,7 @@ static void *swap_next(struct seq_file *swap, void =
*v, loff_t *pos)
>
>         ++(*pos);
>         for (; (si =3D swap_type_to_info(type)); type++) {
> -               if (!(si->flags & SWP_USED) || !si->swap_map)
> +               if (!(si->swap_file))
>                         continue;
>                 return si;
>         }
> @@ -3390,7 +3391,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>                 goto bad_swap;
>         }
>
> -       si->swap_file =3D swap_file;
>         mapping =3D swap_file->f_mapping;
>         dentry =3D swap_file->f_path.dentry;
>         inode =3D mapping->host;
> @@ -3440,7 +3440,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>
>         si->max =3D maxpages;
>         si->pages =3D maxpages - 1;
> -       nr_extents =3D setup_swap_extents(si, &span);
> +       nr_extents =3D setup_swap_extents(si, swap_file, &span);
>         if (nr_extents < 0) {
>                 error =3D nr_extents;
>                 goto bad_swap_unlock_inode;
> @@ -3549,6 +3549,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         prio =3D DEF_SWAP_PRIO;
>         if (swap_flags & SWAP_FLAG_PREFER)
>                 prio =3D swap_flags & SWAP_FLAG_PRIO_MASK;
> +
> +       si->swap_file =3D swap_file;
>         enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
>
>         pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%l=
luk %s%s%s%s\n",
> @@ -3573,10 +3575,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>         kfree(si->global_cluster);
>         si->global_cluster =3D NULL;
>         inode =3D NULL;
> -       destroy_swap_extents(si);
> +       destroy_swap_extents(si, swap_file);
>         swap_cgroup_swapoff(si->type);
>         spin_lock(&swap_lock);
> -       si->swap_file =3D NULL;
>         si->flags =3D 0;
>         spin_unlock(&swap_lock);
>         vfree(swap_map);
>
> --
> 2.52.0
>
>

