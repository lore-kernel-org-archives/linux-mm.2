Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB535606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 03:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ph5i5kv5
Received: by kanga.kvack.org (Postfix)
	id A472F6B06DC; Thu, 19 Nov 2026 22:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E116B0736; Thu, 19 Nov 2026 22:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933E46B0737; Thu, 19 Nov 2026 22:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63E706B06DC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:59:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C70BCA0D36
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:59:51 +0000 (UTC)
X-FDA: 85454143782.06.F394247
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	by imf09.hostedemail.com (Postfix) with ESMTP id BDA1A140006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:59:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ph5i5kv5;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795147190;
	b=PbCxQV6858rdgVMVk1pPUKHOzRPssKHGfmFddS3cFbVh+3/U+QODEHxZoMxWs36Sj91AcT
	RP6l7ofxK/3SJFZ5Cao8DCrBrUCj8S+B2eKjuhtUBXbD/p18UoI+Yj07LIteabkbJPrd2c
	PmGFlVMcKFkuTRqRw5QO994WIiEyTpI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795147190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BevtVguUeQNyWju/jMWBB/Dczk4xrw2DuDLihw+PuYY=;
	b=4X+85bkKw9Ib1cyFYz1gIjJvuaV6b0ZSMagd1sM0QmdyK50VJmKi2rwq+Rvd5UiTScdbNo
	tTiF+IWOonc38A8gfk+dM9yRf042zNlQWWIwjB4G0vSz1tBW+uprS2CuHdBXkFTrzFRkUJ
	yACtaH/iK1loVULDtB5PU8qUe/mGEbQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ph5i5kv5;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1eEQ2mT1dDnX4nxZxFauoQ+3gLHeK/si6v01CaLfQ3o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795147188; v=1; x=1795751988;
 b=ph5i5kv5YBIXQiUpZX0L/NFpN6noqe5Bbfsz0qeDWSIUKZVsOwTaayjQ0++23Si9JoxLIpko
 R3Gc2Q78EQNwPnt0A7P9lfO4VdovSAaYGBFtbWEtAOnq6zLaQUvpwXx0KOmBNIeVbZmZKZKkLZD
 eT9Fp1KdldMB4ljvYviFk1Qw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 84dd2801765fca3b;
	Fri, 20 Nov 2026 03:59:48 +0000
X-Mizu-Trace-ID: 84dd2801765fca3b
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 03:59:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <01e78c2f91fa0320a5bee69f6cb47a1dcacab31f@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 04/18] mm/swap: introduce swap device iteration
 helper
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <8e1766da4ddbf22e36f8689360dfea64377269fd.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <8e1766da4ddbf22e36f8689360dfea64377269fd.1794666741.git.lianux.mm@gmail.com>
X-Rspam-User:
X-Stat-Signature: y668nx56kbnyf1k9jmonrex3wox99ghy
X-Rspamd-Queue-Id: BDA1A140006
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795147189-752438
X-HE-Meta: U2FsdGVkX1/udX33noA/IZwqyYModn8w9GMmugC19wCj/xcS8k3whHCp+zqs0ltkFT1styMUtX2xj8cgI+D+zsPMoSuTtk2MQOBnYG/1fFWxug6PGzlb4nc/AEDwRYYOCNpWJKQF384+LEh3s8SWFcahfd5wDzUgYZjhQV6mRQYwix2NKcdsfBl06X72EbZ6uu2nXY/aaTrsc7kC9t2Dgc/kkokskjroiKqwWdPF7ja3RlMHru9a9qIg2uRR1shemP8AErynaUuBeMcuy59uY+r6bjpwzhcORmc0AJbkQtTNJpSGt0OGQtUrhu7cPofqsDW8xUwUHk4Ox1jQe5FHcHoc7Y016ApCfACUQ7LLd5gOvPU40X6FsZbXeiPaAv2n5N6wJYNy/u63nzNCmf+OwQ/9s3XI237Wpu/JjlfuyB6aL0b6Avn83qbQmiV6pxtY5osJ+U+FeW3CyQsCSmT3jTXA0BEZOKIA3HxADK7rCnoAXYosPRwNMXAZz1AC8oLNw3yw2lW/LJrjtPX/KTqczXyaaom7iqsz86Qy56DVQqFIEGHBeD5c0LFNFUQSvydneVrDhyvapq/qnWWv5TXZs5/N/Mb8hzt0ziuBjWHeRpU2Jq2SlmoaK40F33WW9OF1PFQUgbasBtmTTGW5xfQ0vmF7Jd0Bq3XKoAfWPH34Sd6MYmZIMgqzMBKOfgzITDIPMcyRlhl9fZFkS983RaUkQ1yjLGhxHCieMOUDwNgFB+lsaCclt++ixZ/ETMdlOBRjrLQMk7McWM0TDnQqBGgVDpF51WB+l8j2VP8iLeI5wtvRXQOWXEUk6PCDguCjawKwHJ3bKjapUr8+PGZlUvZQN+z4ygkf5oC0JXnguRKMv0syEZjeVIjSrihnV2FRtx6CPTRVt6ljBodukPCKKGVIqwCXdrJjECFiNlHcYbu0NG2A9mwuwrBYWYOMeJoG/lsU3Dt2e7ve2YYCzHeDsPB
 Mg9Gy3xF
 /SD5NE3jOUaFtt0LrrT8c0ToYXYZ+s72iCd0SK+icxZZwBV5hZxb74pUga7bOP5m7woMR9XfF4fw6upyWH13kS+uF+uYQ+kaX6vk8OKPTJPHaBRxPb1uxj8JYGWpztgskJBXmxGnoFg8o89adDFljgCQVyMH37AlaPIOQ9mhk0icmCGzzuS3erQglAU2gVlRmh3Fu9oMczFPyF5Q4WEuwIObNSf3bSPK+Q7LYCcUQXffIbTDzFH97FwPzWF+ToghjCwIByjH6fSgzKkTirmUMhGrpgU79+mZEMa7aWrE13w3PHKxsR9THWzrU6jaXG9mmds4+RRCZNpf4sr1ZPyI7Jqt/5MouXS0iyhd/fZ5dlrTM+nQxxgLtRxUBgWi/anph1OtRE1QsEubd3DHyPYVlg2sScXz3VSL2H+T7eP6UuiKuFsLMjCEBmYKVFaojeODzcjoBbmjJPthvuFh/J+xtaQKq/21Pi5XKsZN805fNQvk5O/DPFpWQIMZiqtQNHvTrYmUH2oOK6wOzwM7EV+0OpJ5c/tyj9v1yHxhUBg4LoEV3dhBp4PLoFleO2Rdu7t2vZSsvmBRdp1BX3PlWlxWeGsb/+mT0ky8KfZaq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

>=20
>=20From: Kairui Song <kasong@tencent.com>
>=20
>=20Several swap users scan the swap_info array to find in-use or writabl=
e
> devices. Add for_each_swap() and for_each_avail_swap() with SWP_USED an=
d
> SWP_USED | SWP_WRITEOK filtering, and use them for hibernation lookups,
> drain_mmlist() and si_swapinfo(). Keep the swap_lock requirement for
> iteration.
>=20
>=20Move the live-reference warning from __swap_type_to_info() into
> __swap_entry_to_info(). The iterator must inspect descriptors before
> applying its flag filter, including descriptors whose device reference
> is dead; entry-based lookup retains the warning.
>=20
>=20Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swap.h | 12 ++++----
>  mm/swapfile.c | 77 +++++++++++++++++++++++++++++++--------------------
>  2 files changed, 53 insertions(+), 36 deletions(-)
>=20
>=20diff --git a/mm/swap.h b/mm/swap.h
> index d488a69c2809..70fd3ab655ff 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -108,16 +108,16 @@ static inline unsigned int swp_cluster_offset(swp=
_entry_t entry)
>  */
>  static inline struct swap_info_struct *__swap_type_to_info(int type)
>  {
> - struct swap_info_struct *si;
> -
> - si =3D READ_ONCE(swap_info[type]); /* rcu_dereference() */
> - VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff=
 */
> - return si;
> + return READ_ONCE(swap_info[type]); /* rcu_dereference() */
>  }
>=20=20
>=20 static inline struct swap_info_struct *__swap_entry_to_info(swp_entr=
y_t entry)
>  {
> - return __swap_type_to_info(swp_type(entry));
> + struct swap_info_struct *si;
> +
> + si =3D __swap_type_to_info(swp_type(entry)); /* rcu_dereference() */
> + VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff=
 */
> + return si;
>  }
>=20=20
>=20 static inline struct swap_cluster_info *__swap_offset_to_cluster(
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 6485c8020d3a..1669a46515cd 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -106,6 +106,34 @@ static DEFINE_SPINLOCK(swap_avail_lock);
>=20=20
>=20 struct swap_info_struct *swap_info[MAX_SWAPFILES];
>=20=20
>=20+static inline struct swap_info_struct *__swap_iter(int *i, unsigned =
long flag)
> +{
> + lockdep_assert_held(&swap_lock);
> + while (*i < nr_swapfiles) {
> + struct swap_info_struct *si =3D __swap_type_to_info(*i);
> +
> + VM_WARN_ON(!si);
> + (*i)++;
> + if (flag && !((si->flags & flag) =3D=3D flag))
> + continue;
> + return si;
> + }
> + return NULL;
> +}
> +
> +#define __for_each_swap(si, flag) \
> + for (int __i =3D 0; ((si) =3D __swap_iter(&__i, flag));)
> +
> +/*
> + * for_each_swap - iterate through all allocated and inuse swap device=
s
> + * @si: the iterator
> + *
> + * Context: The caller must hold swap_lock. The lock may be dropped du=
ring
> + * the loop body but must be re-acquired before the next iteration.
> + */
> +#define for_each_swap(si) __for_each_swap(si, SWP_USED)
> +#define for_each_avail_swap(si) __for_each_swap(si, SWP_USED | SWP_WRI=
TEOK)
> +
>  static struct kmem_cache *swap_table_cachep;
>=20=20
>=20 /* Protects si->swap_file for /proc/swaps usage */
> @@ -2284,26 +2312,18 @@ void swap_free_hibernation_slot(swp_entry_t ent=
ry)
>=20=20
>=20 static int __find_hibernation_swap_type(dev_t device, sector_t offse=
t)
>  {
> - int type;
> -
> - lockdep_assert_held(&swap_lock);
> + struct swap_info_struct *si;
>=20=20
>=20 if (!device)
>  return -EINVAL;
>=20=20
>=20- for (type =3D 0; type < nr_swapfiles; type++) {
> - struct swap_info_struct *sis =3D swap_info[type];
> -
> - if (!(sis->flags & SWP_WRITEOK))
> - continue;
> -
> - if (device =3D=3D sis->bdev->bd_dev) {
> - struct swap_extent *se =3D first_se(sis);
> -
> - if (se->start_block =3D=3D offset)
> - return type;
> + for_each_avail_swap(si) {
> + if (device =3D=3D si->bdev->bd_dev) {
> + if (first_se(si)->start_block =3D=3D offset)
> + return si->type;
>  }
>  }
> +
>  return -ENODEV;
>  }
>=20=20
>=20@@ -2470,16 +2490,13 @@ int find_hibernation_swap_type(dev_t device, =
sector_t offset)
>=20=20
>=20 int find_first_swap(dev_t *device)
>  {
> - int type, ret =3D -ENODEV;
> + int ret =3D -ENODEV;
> + struct swap_info_struct *si;
>=20=20
>=20 spin_lock(&swap_lock);
> - for (type =3D 0; type < nr_swapfiles; type++) {
> - struct swap_info_struct *sis =3D swap_info[type];
> -
> - if (!(sis->flags & SWP_WRITEOK))
> - continue;
> - *device =3D sis->bdev->bd_dev;
> - ret =3D type;
> + for_each_avail_swap(si) {
> + *device =3D si->bdev->bd_dev;
> + ret =3D si->type;
>  break;
>  }
>  spin_unlock(&swap_lock);
> @@ -2996,12 +3013,14 @@ static int try_to_unuse(unsigned int type)
>  */
>  static void drain_mmlist(void)
>  {
> + struct swap_info_struct *si;
>  struct list_head *p, *next;
> - unsigned int type;
>=20=20
>=20- for (type =3D 0; type < nr_swapfiles; type++)
> - if (swap_usage_in_pages(swap_info[type]))
> + for_each_swap(si) {
> + if (swap_usage_in_pages(si))
>  return;
> + }
> +
>  spin_lock(&mmlist_lock);
>  list_for_each_safe(p, next, &init_mm.mmlist)
>  list_del_init(p);
> @@ -3997,14 +4016,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, sp=
ecialfile, int, swap_flags)
>=20=20
>=20 void si_swapinfo(struct sysinfo *val)
>  {
> - unsigned int type;
> + struct swap_info_struct *si;
>  unsigned long nr_to_be_unused =3D 0;
>=20=20
>=20 spin_lock(&swap_lock);
> - for (type =3D 0; type < nr_swapfiles; type++) {
> - struct swap_info_struct *si =3D swap_info[type];
> -
> - if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
> + for_each_swap(si) {
> + if (!(si->flags & SWP_WRITEOK))
>  nr_to_be_unused +=3D swap_usage_in_pages(si);
>  }
>  val->freeswap =3D atomic_long_read(&nr_swap_pages) + nr_to_be_unused;
>

