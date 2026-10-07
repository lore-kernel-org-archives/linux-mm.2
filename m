Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F00ECA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 06:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EE66B0088; Wed,  7 Oct 2026 02:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820E96B008C; Wed,  7 Oct 2026 02:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7DB6B0095; Wed,  7 Oct 2026 02:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43AA16B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:52:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C37C8160475
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:52:42 +0000 (UTC)
X-FDA: 85294912164.09.C224DD8
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id D46D4A0002
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:52:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Q/7Hlr9V";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791355960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYZ+FBTj4p2YuPmZrlm8klRINrPApDEDqaINJavTZWk=;
	b=75GchonHX4TL9Qvr4mSJc2n+dmKELxAvVwVb+Ype+qBSk6nxCfLlWithFZTrptJ433tAMC
	vNdawN0vrv875zVc2O3GIOm25cVt8D7H2AkzlqBYvbHW1rIIAs/DTHfNUBmf4utNhJJ3Wf
	wCWU1Cu618lIIOSDdwek0BZFZg3exhc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Q/7Hlr9V";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791355960;
	b=ZZ8aHUlaxMJVS/lfsxIBoCfoBJhfcjZnJFk3tVGFXR0haixA7MXE+uai3ymW0bW3GeLXpX
	wC5nEd2bwLfWQyLtdzZk93vhMyJv5ph5hAcaoox9V2KmvGVsrCEpN/jHGaKP6nFXgsl7QR
	H/M0z4xxzy9PxcZVbrs4P4LMdIxI8rI=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2acc1e170cso220413466b.1
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 23:52:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791355959; cv=none;
        d=google.com; s=arc-20260327;
        b=cGGAH7Hqm/3NyfUV68VcMg43IFa6g/8QWND9+cSc8izRNJUnRxA2BWNez7eHcmoi2/
         j/4aYE8Kd5VhAD5HcOjUrfasZOoYso/abeQl/rmKD9zK59N52Srz7azGDJ8oMWS6r6jV
         qTD6Zs4X7hXnTTMVEyCN+rvyTrVpQIXawI3OBUu/7s+GHl23/h3fW7AoNLn/9i8nVb43
         DC153i9H2CPV0DY5ne6OeVzbTPcOdthIOOdIieLsIKUSZjjiWbblAIM+K1+xP1Av1EZX
         /GP+bmFiI5fn/OTu9Ih34MwvtdeeT1ynspQeGedgl/OurWm9hq5RWpWil5dM5Hmyq+YQ
         hP6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uYZ+FBTj4p2YuPmZrlm8klRINrPApDEDqaINJavTZWk=;
        fh=7hA4/DtOkRXrU+dD6PZgS5g/08x4uElnFZrA1GeomiA=;
        b=jSrK4PDhLuN7hI/ngCw2YO1ZgfAWtWKiHILfmP2oe7AMqRUJUphyCw03Mvur5fDI1C
         Ep1j+iGRrYZGAw+GD5mREMkYtslxxA2lCNnPJEv8sOQZlIcOl9x51U4NrsPxdT6aWYbO
         Wfw7xyXDQEchrGB8ji80UwdOWaWljlDe0Z58jPsIjiqQv2WP2UftDBf1RIYD6XeP1sD3
         imb0xt4a6klKSHp///Cm8BlnLWVAc5UB9tiknDqUo1gVII90kRejj6wFt+Cd5ljOTf82
         vjmCFTri2ODbmnZXgJFvBivOH7oVxTlGP6JYiKiK/Hf+WJ+SnRE1c1mpWXofh4CAMu0y
         YHaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791355959; x=1791960759; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uYZ+FBTj4p2YuPmZrlm8klRINrPApDEDqaINJavTZWk=;
        b=Q/7Hlr9VMhBX3gSDkF2/UuewANTI9i/UFagyh9oU+o/aiE5/2vTVsTez4iUAYW/szy
         FljQPPMLr+lhzYLFNi1MeGq1wkTMCPfLkZlZHDSF17aztoaiUYphfd+hr6NaVhhpuXCl
         WDY0H/FgK84rKr4bZfzonO/TSb+mVUeAY8+LyMDk/qhrvA9Xev4qO/dRjW+Mr/r+FAqs
         16YHhN8H540zky4XRoC7OG1PoI0feWYbuTvx3EfcygCwIxDt9ineLpPVjpZa+1+6oYl6
         mmSf9Lw1UqOrUbjliNpbl7LeUA/l+wccZagaCHCGiQfhgTKmUM+3ifOEWSIN+QTRiIRi
         88Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791355959; x=1791960759;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uYZ+FBTj4p2YuPmZrlm8klRINrPApDEDqaINJavTZWk=;
        b=U8s+tSr+g84BDyK8KiYtxPMUfcNZwHHjMczMgGmZHWKKtTkIJBTPqK90SyM1B+2RsX
         RcAokvyGEe/ZbQwRGvDV5G7J8HwEPtNgjA1c5G5YWoYDEcRQ2sHZSB/FqR/VJ+1R2gPW
         wSW9lL2ZCttt5OZymOw2OXL6M1u24RH1JiBQdjCaVgK7a7Cr9xDTPm6jJooTMcHxw6F9
         /l6+pHutUYBPVC8IQmrYP3eKJWaCdsu7LX645w+0APv4b6lLGjiHlGecwONXJNPAkE7/
         CXmSEvvusV0dT5OtMqctQZgsXNciQM4Sl0fQFaKqzsF3BPFmztqfw9e9V4ndsIxqtv7Y
         AadA==
X-Gm-Message-State: AFuF++nnrbA52DnuKt/e8wXVCkJz/u6HdCqeQxXXWrHpJrgkGzcPsEvk
	rA2BVzd2bh5ZcbPy+YCMVHNaROBqWct/w/ShJwovKUDMy/33owvdA0bB4MuJNxWvXgFce2rXUgX
	UuCAvhG4VNiCma23OBK0u9L/Z+1dyYPs=
X-Gm-Gg: AYBFou0c3NgZFlE4DqtasyWPaf2rvry3mV+5MA1AisHqdUfcSL5qsXPjukmP8/hZrCI
	9U4q/ORLHcJ9P4iKASEWv8G14i8v7Jz5NjD4GFyFnILDlUGQpI97psq3FhR9SUP9bYW9IBRwIhx
	mjf6lHB9nevLm+poDQS4EWvMhmHOLB0K10Ewp/yGYoMi9MegICOn4nDuSevXlN+OLQ3pXS588Dc
	V1rms0DxY8kiJqi7bMtqDMgeMkMC6wsZJoCYO7QpHoKtkVmAqfHYzToa+hGsKD7UMXK3AcH9YBH
	UQqmN2upIMbEj5xIm3+iLlzqG4E0bc+IJ+M4sQn0HwrXRehE+tj1cIZW
X-Received: by 2002:a17:907:7287:b0:c2e:2252:6ddb with SMTP id
 a640c23a62f3a-c317bdd9435mr113132166b.10.1791355958731; Tue, 06 Oct 2026
 23:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20261003003136.750633-1-hebaoquan@kylinos.cn> <20261003003136.750633-6-hebaoquan@kylinos.cn>
In-Reply-To: <20261003003136.750633-6-hebaoquan@kylinos.cn>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Wed, 7 Oct 2026 14:52:26 +0800
X-Gm-Features: AclHuK-taMBfGgP6ilA4RKTlY22fCTFMUrc-YlRCy_S-xkzHcMNC6_ARSFLYr5o
Message-ID: <CAN_Opa-1qu9q1wzKy65sBpHBfYHqF6GzxbS-hZx9R=a6-qW9dQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/14] mm, swap: add xswap grow trigger on cluster allocation
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, klarasmodin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D46D4A0002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 1dsndoci3kp6m6pm4ekqem3wt6i6rds4
X-HE-Tag: 1791355960-852702
X-HE-Meta: U2FsdGVkX19AUbmfzw01gjMyvOPfEwCXL3uALypjPAl+dpGXJ1cyIzIDHTi+BJ2hFeNEwNV60phAfqHJNQWjz81DdiCkpw+5SUwQ6VhNS2kCRjd8g4qZVzEAr17UY1rsghqhGtPv8qYdDz+wyWuj7HPxEO8fmEvRn+GHEpgaH4PD4UslXvCTTxbvJ6buNJyMf6gkSEQKUmY7cXWeo3rm+PYpOZOMVjMAZArRUKT4eff1lZgJrB/Kgfc1hqTZ2qrmm02SetyKx/mgYADeDzRbd/O3LdHKrPKktXwD2rRuluVusOJIeqQ6RfeMCvLRXu4txN6rejrzpUmB3O3woWGtujKym64jv3G0vrsKTGuLpwu+O1l0bUNu2p0iML+F5XgpcYOMjladoIGtPTw/vLRh/Hq99WEtZhrg+nc4CT4NXrP1hm+0UE7IBHykSefL5jZtAHWStblOxuiqPQmS4aJAMqHEsha4fZfUdcBjARD6Q8avPl2MT3mBOib2GqBXQTNjSygHqmhAwCo6cDmQPDWLK0z9BDY0e66tWMIao9edpwOxkEuAtWpibOoFVe/2SMgMkNdhcphFgjnlCRgZa3M89D/7+mGFvLzpjUxbg4qTx8Oaz7k4XRIYFFhs21vqtKpIoZ21OvbGWDnFGlVl/LUPmvIfpzr6wxiEqM9lgEyK9/+YBuKtFmftgmS/Pj+SoCt8gRJcqp0QyWKVQj89S8GiEjgKLL5fy9BKvd8oXuqtV8hTQPxCi0D6pd5q7EJAjrC4oH1UEvMvVMrIepaDJTQO8ciotg3QZvc94B+xw8XsP8A6/I4AbuOYfh9RCDGZyaYpEzrM53jUrC5CiZMbLJgCb16wgo0V/PpcF4vGpLFLU5N4IJ3apc3wUEkiL55pjJ8yYaIPVYyH/cQ7suJb3pimhrxYlfpSsUskUWAQm8e8xz2SkRl4eqEA9ZcZ/bKaGeobnmn1Cu+KteQXEacIcPW
 SIxAKwGM
 FAvsrc9Gx9R+losS311jpKHtD8Jk7eV/uB8P8f1sObrJ0DPtUJq+JzChijQumMrN+kHaTVcSLGTiyfBUudMLploIADArwlAI5IQsSZog0RPtIYaIdpgZkR6JkRN+tZCgHgBXW4jdqYqGHMFMbo9xLG9wJixHUA656vD9K5QjjosjGkK3WWLrZiplb5lCl8iBWjHAv2f906Yvmqh5+ULy8Frme3RUKtroIXgFvA4+upKugA+PWwmoim4Oa11Xwcgy3lkVYx7NMRffxDQm3EmhO6ZLGKLz93TQJ302RBbuxguGuWfz0/IudGrg6eNV9SbLMO4j3Vx/jHDxwVo+WTVBdarS1VWem7OIhPk1J5vcm6i/G6R3EqvKMJ57RvxykVnV3EO0LhCkjvc3RF419+YvpKmMi/yv/dNjU2wpA6fgW+eeWznH3q+QE5OC2CQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 8:32=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> wr=
ote:
>
> Grow the mapped range before it runs out rather than after, from
> cluster_alloc_swap_entry().
>
> Growing maps pages into the VM_SPARSE area and can sleep. Doing it from
> the allocation that would otherwise have failed puts that sleep on the
> swap-out path with nothing left to fall back on. Growing at 85% in use
> instead leaves the allocation that pays for it a reserve to land in, and
> leaves one grow's worth of room in front of the next.
>
> The target is 65%: past the point where the shrink starts looking (50%)
> and short of the point that triggers the next grow (85%), so a grow
> cannot leave the range in a state the shrink would undo.
>
> Since xswap is always SWP_SOLIDSTATE, global_cluster_lock is never
> held on this path.
>
> This makes the xswap cluster space grow transparently as swap usage
> increases, without any userspace intervention.
>
> The caller holds local_lock(&percpu_swap_cluster.lock) across the whole
> slow path, so drop it around xswap_map_clusters() and take it again
> afterwards; it only protects the per-cpu cluster cache, which this path
> does not touch.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  mm/swapfile.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 93 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9c204e455ef9..45050f8a2ed8 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -70,6 +70,19 @@
>  #define XSWAP_GROW_CLUSTERS \
>         max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info)=
, 16)
>
> +/*
> + * Grow and shrink thresholds, as a percentage of the mapped range in us=
e.
> + * Each one lands inside (SHRINK_WHEN, GROW_WHEN), so neither can leave =
the
> + * range in a state that wakes the other up.
> + */
> +#define XSWAP_SHRINK_WHEN      50
> +#define XSWAP_SHRINK_UNTIL     70
> +#define XSWAP_GROW_UNTIL       65
> +#define XSWAP_GROW_WHEN                85
> +#define XSWAP_GROW_CHUNKS      4
> +
> +static bool xswap_should_grow(struct swap_info_struct *si);
> +static unsigned long xswap_grow(struct swap_info_struct *si);
>  static int xswap_map_clusters(struct swap_info_struct *si,
>                               unsigned long start_idx, unsigned long nr);
>  static void xswap_unmap_clusters(struct swap_info_struct *si,
> @@ -1204,6 +1217,17 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>         if (order && !(si->flags & SWP_BLKDEV))
>                 return 0;
>
> +#ifdef CONFIG_XSWAP
> +       /*
> +        * Top the range up early.  Every path below leaves through `done=
`,
> +        * so this has to come first; mapping pages can sleep, and doing =
it
> +        * from the allocation that would otherwise fail leaves nothing t=
o
> +        * fall back on.
> +        */
> +       if ((si->flags & SWP_XSWAP) && xswap_should_grow(si))
> +               xswap_grow(si);
> +#endif
> +
>         if (!(si->flags & SWP_SOLIDSTATE)) {
>                 /* Serialize HDD SWAP allocation for each device. */
>                 spin_lock(&si->global_cluster_lock);
> @@ -1280,6 +1304,12 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>                 if (found)
>                         goto done;
>         }
> +
> +#ifdef CONFIG_XSWAP
> +       /* A concurrent free or grow may have added clusters; retry once.=
 */
> +       if (!found && (si->flags & SWP_XSWAP))
> +               found =3D alloc_swap_scan_list(si, &si->free_clusters, fo=
lio, false);
> +#endif
>  done:
>         if (!(si->flags & SWP_SOLIDSTATE))
>                 spin_unlock(&si->global_cluster_lock);
> @@ -3909,6 +3939,69 @@ static int xswap_map_clusters(struct swap_info_str=
uct *si,
>         return -ENOMEM;
>  }
>
> +static bool xswap_should_grow(struct swap_info_struct *si)
> +{
> +       unsigned long mapped =3D READ_ONCE(si->nr_clusters_mapped);
> +
> +       if (mapped >=3D READ_ONCE(si->nr_clusters_max))
> +               return false;
> +
> +       return swap_usage_in_pages(si) * 100 >=3D
> +              mapped * SWAPFILE_CLUSTER * XSWAP_GROW_WHEN;
> +}
> +
> +/*
> + * Map more of the cluster_info array, up to GROW_UNTIL in use.  The cal=
ler
> + * holds percpu_swap_cluster.lock, which this drops while it sleeps.
> + */
> +static unsigned long xswap_grow(struct swap_info_struct *si)
> +{
> +       unsigned long mapped =3D READ_ONCE(si->nr_clusters_mapped);
> +       unsigned long nr_new, want, i;
> +       int ret;
> +
> +       /* The unmap below is paired with the caller's lock. */
> +       lockdep_assert_held(&percpu_swap_cluster.lock);
> +
> +       want =3D DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
> +                           XSWAP_GROW_UNTIL * SWAPFILE_CLUSTER);
> +       if (want <=3D mapped)
> +               return 0;
> +
> +       nr_new =3D rounddown(want - mapped, XSWAP_GROW_CLUSTERS);
> +       if (!nr_new)
> +               nr_new =3D XSWAP_GROW_CLUSTERS;
> +       if (nr_new > XSWAP_GROW_CHUNKS * XSWAP_GROW_CLUSTERS)
> +               nr_new =3D XSWAP_GROW_CHUNKS * XSWAP_GROW_CLUSTERS;
> +       nr_new =3D min(nr_new, READ_ONCE(si->nr_clusters_max) - mapped);
> +
> +       /*
> +        * Mapping pages can sleep.  The lock only guards the per-cpu
> +        * cluster cache, which this path does not touch.
> +        */
> +       local_unlock(&percpu_swap_cluster.lock);
> +       ret =3D xswap_map_clusters(si, mapped, nr_new);
> +       local_lock(&percpu_swap_cluster.lock);
> +       if (ret)
> +               return 0;
> +
> +       for (i =3D mapped; i < mapped + nr_new; i++) {
> +               struct swap_cluster_info *ci =3D &si->cluster_info[i];
> +
> +               /*
> +                * A concurrent grower may have taken these already;
> +                * only add the off-list ones.
> +                */
> +               spin_lock(&ci->lock);
> +               if (ci->flags =3D=3D CLUSTER_FLAG_NONE)
> +                       move_cluster(si, ci, &si->free_clusters,
> +                                    CLUSTER_FLAG_FREE);
> +               spin_unlock(&ci->lock);
> +       }
> +
> +       return nr_new;
> +}
> +
>  static void xswap_unmap_clusters(struct swap_info_struct *si,
>                                  unsigned long start_idx, unsigned long n=
r)
>  {
> --
> 2.54.0
>

Hi Baoquan,

The 85% grow threshold gives the allocation path headroom before
the currently mapped range is exhausted.

I also checked the lock scope in `xswap_grow()`. Dropping the
per-CPU `local_lock` around `xswap_map_clusters()` is appropriate
because the mapping operation may sleep, while this path does not
access the per-CPU cluster cache.

`xswap_should_grow()` uses `READ_ONCE()` for
`nr_clusters_mapped`, so a concurrent grow can make an allocation
miss the grow check for one round. This is benign because a
subsequent allocation will observe the updated mapped range.

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>

Thanks,
Kunwu

