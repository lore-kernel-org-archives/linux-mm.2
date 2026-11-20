Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F9060A2604
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uewMSCMx
Received: by kanga.kvack.org (Postfix)
	id 482C96B0673; Thu, 19 Nov 2026 23:30:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459D56B06F1; Thu, 19 Nov 2026 23:30:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370566B06EE; Thu, 19 Nov 2026 23:30:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 044696B075E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:30:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63DE9A0D46
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:30:57 +0000 (UTC)
X-FDA: 85454222154.10.5D1AF27
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	by imf02.hostedemail.com (Postfix) with ESMTP id 62D2D80006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:30:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uewMSCMx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149055;
	b=mmwudENh62Flb2WSIsFYg4XIzU4uJA5hUC4/ZOa0c9b0YBKJsIkVjGZDNrlPrFXFE73W2P
	+1xVRtTYJObsZaDMp1YeEIEL4NzaIwf/mIBN5cg/2uIXJ/O+DQDt8zrVdNA2mu8Hv4ka4j
	xfpVoFhZ6dlcz8CPBswRPWxwHH+tZRA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aptt1+YlEug156mMrf3nxJcUGwW+DDxbfeu04F3jKtg=;
	b=uThMnx1EYG9vLQI9gSwt0/povmh0yI+HKQMq18PubhWWCDE9kIOf0ENxfHhqK19mWYl8Vr
	dfXMwWFrVg7+wBMuBQt+VZCT+YHzRt3P2o0COtSMVu5C3HGKPBrjO9bP10gJlfzLBUqo0Q
	a3xlKoSYSzFsdiImAg0KrAhCFjCn8yc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uewMSCMx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QQM+GciGMRe/j+gSSQmU++uIs6+IufRUD56p0aNRWo0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149053; v=1; x=1795753853;
 b=uewMSCMxcecSjAgLrDjIC/ZYkTdOfM9PWXf5EbDdqq3qFcsjBvJrD8OuOOZCmzSpoOnSAvVn
 79kNoCoP1mtLJjpwq3WJttgs7LtW3FFeYRJedQvV2TCMeokraKkWq7IT/g+huKYQ0Nuoy3r6XPK
 XFCBgQBRtPqEPsaB+GejEixE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c99f1d5ab03ce7ff;
	Fri, 20 Nov 2026 04:30:53 +0000
X-Mizu-Trace-ID: c99f1d5ab03ce7ff
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:30:53 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <132ae48e0317aa95b8d51c4534230878d6a57ff5@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 07/18] mm/swap: consolidate swap inuse accounting
 helpers
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <4e554bbb557d0456c953d73f008875f6d983b12f.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <4e554bbb557d0456c953d73f008875f6d983b12f.1794666741.git.lianux.mm@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62D2D80006
X-Stat-Signature: zhbhrd476w8s1erctdhjqnacwfscw483
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795149055-569257
X-HE-Meta: U2FsdGVkX18ATvcOzqJcogEXOmunCVfVsEUJDHHhJEqGB2WYA0P39KdGtZwi7OLCDDEcVJkhbO9sDpVrltC+zqk8tp0nwPFi5l2LGodk8101NsNJCNsCTzwOf+DNfGQGAN8lDViy/aN4Q7vRlBrsnvZbn4fPpLoCvHIQzUIoZ59zlznjC3VkmniNdrZTBeE5skQ2b+ktyprDmhiSmFR5kKstcnhONKgYxllli0YwbGmS2iUAMn4DcLvHCC9kUsJ1lXDORi8+LJ5il0ic7BewWD3c43waxUjoz4bDDGwsc+gaDaiIZufTitzRQvF2A3JK+2IxpYaFyWCluKlN+XBJzAnAraVgJFT2iGL4hA1JSqzQ9M7iLuwbgC3Yl4DcbRbAnNQxl2aM5j1ZrntqqDR7J8Sg8dmuv3SkxtUG2ERVeE6RkzP8B0MZ1IUyS079UrQLMPy3KlsOc4CtxqKu6fbvaD3i4g2cUaqa4tSIPuD3YK0+SapIv24rElcAd8CEVa3vf5wOtEOMWVp1KDzV9jNq8ubX/jmpie8aJg1BofXlo9pnnk/hjJBSj1F12ASVsyhmZajSMkJkiI3+fZIlsI37nMbg12arV/F+j/ttE1+M8Mo7CnhzOqjFpTakoRpWTYdSAP5upEIAMMHA/iS5k36W/0qxyzt+dFqgz8iT9YAjUD9ZD5iXelsC+lapZ/DRT6Q8jBYQxwjzZ/cy2G1rkAMHQ/s40NISl+f2qCSPitEc8HZpWuJQWjQG/qUmX1TktoMoya1542m4GByQb5gqDWMTBEARPHK7pj5YM8CgEJybO+PawVnAeV/RLpDb4OAFYPkHpV4xlmW3+qBWZV0UE/un0pF82KZAycKT5zDc6k1JMkNO9PtRU4guDHxWPR6zzYFfJv9Uz2MZOffXYpXfcLxfX744b/WBVCBxBcSJQwbJ10k6G4WprOQZxFfaUPuYqQ5pyVgGTHxWB9g45P+Ef49
 qZhDmmi8
 QlO4KsHL+x4MSnBnRgKVf0x5qjeLQYxXIyN/HjAyIg2HDtaMhB8GGKnpmNY8uFQINtv811qFNEyPEfmK0MQAVs3ULBKLy+Fi3cR7LnSWY6Vlrnd1xrDT0nTVYoK1YdqnEW4BAgeGYR8dacuQyIovv+gVVAnABbnspYfutMdEKmShyHKfFV5sa0iBvr95xlKPJmAj+OSQeNfx3p8WUavwj4qBvWLX3N0BAuNi6vC6VcVj9UluOgLMMEmYVbTa+y6xEGnMtjRPVSaOoBPsVkd+ngBvLEi7misPqTTe/o4A7qD6L2EJXZNzwm9+CtDX15CFXovK5eslkWEGirFSecD0U9HdnyKcoVLRHXO3ZeaH2eiBvj1iKT7E87CKjGiAbhdyBZTtWmU2ZwURb9g1LGS5IkzbI8UhNqRR2PADpzKQhw1rePG1xyj7vxd4JLx2p4ibL2bRP3fEl3lryEx5ZHACoTF6SlAjlcOEQlkgqUotZvT3BLc3qq1diMYleonyCwPLc7fWCLmClSReeymRUWbYUU2vCo1vX9tTAy4AGZVM5N5nZafYc2rEtDUZYXMxUpLwOjgYmCkq9O3kzgIGzeyGLaxKMKohHi8KZgSdq
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
>=20Inline the swap_usage_add/sub helpers into their only callers and
> rename the callers to better reflect what they actually do: track
> per-device inuse page counts.
>=20
>=20Keep the existing accounting and allocation policy. In the inlined
> full-device path, reclaim work is scheduled before availability removal
> rather than afterwards. Slot-free notifications and zswap invalidation
> retain their existing order.
>=20
>=20Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 64 ++++++++++++++++++++++-----------------------------
>  1 file changed, 27 insertions(+), 37 deletions(-)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 277a5c749987..aa020f2706b4 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -49,8 +49,8 @@
>  #include "internal.h"
>  #include "swap.h"
>=20=20
>=20-static void swap_range_alloc(struct swap_info_struct *si,
> - unsigned int nr_entries);
> +static void swap_device_inuse_add(struct swap_info_struct *si,
> + unsigned int nr_entries);
>  static bool folio_swapcache_freeable(struct folio *folio);
>  static void move_cluster(struct swap_info_struct *si,
>  struct swap_cluster_info *ci, struct list_head *list,
> @@ -1045,7 +1045,7 @@ static bool __swap_cluster_alloc_entries(struct s=
wap_info_struct *si,
>  if (cluster_is_empty(ci))
>  ci->order =3D order;
>  ci->count +=3D nr_pages;
> - swap_range_alloc(si, nr_pages);
> + swap_device_inuse_add(si, nr_pages);
>=20=20
>=20 return true;
>  }
> @@ -1363,53 +1363,36 @@ static void add_to_avail_list(struct swap_info_=
struct *si)
>  }
>=20=20
>=20 /*
> - * swap_usage_add / swap_usage_sub of each slot are serialized by ci->=
lock
> - * within each cluster, so the total contribution to the global counte=
r should
> - * always be positive and cannot exceed the total number of usable slo=
ts.
> + * swap_device_inuse_add / swap_device_inuse_sub are called within clu=
ster
> + * update critical sections and serialized by ci->lock within each clu=
ster,
> + * so the total contribution to the global counter should always be po=
sitive
> + * and cannot exceed the total number of usable slots.
>  */
> -static bool swap_usage_add(struct swap_info_struct *si, unsigned int n=
r_entries)
> +static void swap_device_inuse_add(struct swap_info_struct *si,
> + unsigned int nr_entries)
>  {
> - long val =3D atomic_long_add_return_relaxed(nr_entries, &si->inuse_pa=
ges);
> + long inuse_pages;
>=20=20
>=20 /*
>  * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
>  * remove it from the plist.
>  */
> - if (unlikely(val =3D=3D si->pages)) {
> - del_from_avail_list(si, false);
> - return true;
> - }
> -
> - return false;
> -}
> -
> -static void swap_usage_sub(struct swap_info_struct *si, unsigned int n=
r_entries)
> -{
> - long val =3D atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pa=
ges);
> -
> - /*
> - * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
> - * add it to the plist.
> - */
> - if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
> - add_to_avail_list(si);
> -}
> -
> -static void swap_range_alloc(struct swap_info_struct *si,
> - unsigned int nr_entries)
> -{
> - if (swap_usage_add(si, nr_entries)) {
> + inuse_pages =3D atomic_long_add_return_relaxed(nr_entries, &si->inuse=
_pages);
> + if (unlikely(inuse_pages =3D=3D si->pages)) {
>  if (vm_swap_full())
>  schedule_work(&si->reclaim_work);
> + del_from_avail_list(si, false);
>  }
> +
>  atomic_long_sub(nr_entries, &nr_swap_pages);
>  }
>=20=20
>=20-static void swap_range_free(struct swap_info_struct *si, unsigned lo=
ng offset,
> - unsigned int nr_entries)
> +static void swap_device_inuse_sub(struct swap_info_struct *si, unsigne=
d long offset,
> + unsigned int nr_entries)
>  {
>  unsigned long end =3D offset + nr_entries - 1;
>  void (*swap_slot_free_notify)(struct block_device *, unsigned long);
> + long inuse_pages;
>=20=20
>=20 zswap_invalidate(si->type, offset, nr_entries);
>=20=20
>=20@@ -1431,7 +1414,14 @@ static void swap_range_free(struct swap_info_s=
truct *si, unsigned long offset,
>  */
>  smp_wmb();
>  atomic_long_add(nr_entries, &nr_swap_pages);
> - swap_usage_sub(si, nr_entries);
> +
> + /*
> + * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
> + * add it back to the plist.
> + */
> + inuse_pages =3D atomic_long_sub_return_relaxed(nr_entries, &si->inuse=
_pages);
> + if (unlikely(inuse_pages & SWAP_USAGE_OFFLIST_BIT))
> + add_to_avail_list(si);
>  }
>=20=20
>=20 static bool get_swap_device_info(struct swap_info_struct *si)
> @@ -2059,7 +2049,7 @@ void __swap_cluster_free_entries(struct swap_info=
_struct *si,
>  if (batch_id)
>  mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
>=20=20
>=20- swap_range_free(si, ci_head + ci_start, nr_pages);
> + swap_device_inuse_sub(si, ci_head + ci_start, nr_pages);
>  swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
>=20=20
>=20 if (!ci->count)
> @@ -2999,7 +2989,7 @@ static int try_to_unuse(unsigned int type)
>  success:
>  /*
>  * Make sure that further cleanups after try_to_unuse() returns happen
> - * after swap_range_free() reduces si->inuse_pages to 0.
> + * after swap_device_inuse_sub() reduces si->inuse_pages to 0.
>  */
>  smp_mb();
>  return 0;
>

