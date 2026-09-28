Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA04DC98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 06:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC8C6B008C; Mon, 28 Sep 2026 02:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3DA6B0093; Mon, 28 Sep 2026 02:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE12C6B0095; Mon, 28 Sep 2026 02:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95A496B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:19:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B7181A0B18
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:19:21 +0000 (UTC)
X-FDA: 85262168922.10.815EE16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 446AA140003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:19:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFN1+q95;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790576359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+Ketq9+++QF/K7tY+yWeVcoA9YiGM/e1Warfti0y6c=;
	b=EQVzHJ5EFaIJD1e8k4VlLrBvnDMyll0ZTK+/0INkONdwyrMd17IozPGmOgQM5NFULquwXu
	JbT3pmGV+vsEs4O0livdLo4+RqX8OUGBeOxjV38u41l7H/xnzwR5hBAV3UZ9Rc5J3mUooo
	lmGXag4/obj9u/MgZgtrVD42R0FYvjw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFN1+q95;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790576359;
	b=IyBbd9vsv76OEAMxcUVogiqJUiv+SJoV3YHilsUYgAq4CkQaOjRr+kcvLwuoBmsKrJLP/0
	OcjYsMASdpHvWBlY0QjeL9PHu2mnl+BmpX8xQyhsHlrW1ewo26phqXMdsEJx4SOFYx5ZCg
	Pet5dJYeIrRqK0P9dkyJsNbwc0gM0Io=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8084244507
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683641F008A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576358;
	bh=P+Ketq9+++QF/K7tY+yWeVcoA9YiGM/e1Warfti0y6c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hFN1+q95+zKRDJujGn/4KF5W47EcA0+P2dzDTFpxB1AfBMrGkrnx+Sj5aDj5uTjk6
	 PX/tk31iWZMy6IYADNID/W7fT7mfTT4lrySE/5j03o69EWTn8tDzUJJmg5oVA5ihuA
	 8FaZnMV0Ix/4IILIS87IbDE8Y2z5FSqGav1kaJvXnhSC4+fMEvlujdFq88JHkL4Ntp
	 6vBlI6YzhWvjxhtp3IA+LD3KgFB/WYSsKQxFIXtdRmZVXEVO6fwk8bNvmEinqi4Gsq
	 vXOjBG74leR2IqU5V5YlHOOBHclqt8Es2ByC2EhbVWw/Oow8GMrvAO7RxhAMD57rbj
	 UUGIHqOZJ+z3g==
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2dc50c6edfso111496666b.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:19:18 -0700 (PDT)
X-Gm-Message-State: AFuF++klPDLD3YOr+lECrXjz8l2YrjDGibQ++teOQyZN1hiuRzacbYR1
	yCrONRXqaZjzzrkIISRZ2w1B5WqnxmQ2QTE0XBM5e8TAK9HVQ1jsOQLX0KzdE1TxIv2eJpKFBsL
	GIyWqEDWsLuwtdl/SrW4eYy/bRbzfOE2AM/EDG0uScQ==
X-Received: by 2002:a17:907:3e98:b0:c29:f5d5:5a98 with SMTP id
 a640c23a62f3a-c2ac241bd31mr1017028266b.34.1790576357244; Sun, 27 Sep 2026
 23:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-15-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-15-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 20:19:05 -1000
X-Gmail-Original-Message-ID: <CACePvbUdDWaWA_YZW4yZ_k0zyp3iF3RzusPKO2ZOyJONh0dCrg@mail.gmail.com>
X-Gm-Features: AclHuK_T6ZaUqFOjQXs6aCMZvy5UZhShRk7BXR6yvGcUDbFTt35WUL9ktZOL7vs
Message-ID: <CACePvbUdDWaWA_YZW4yZ_k0zyp3iF3RzusPKO2ZOyJONh0dCrg@mail.gmail.com>
Subject: Re: [PATCH v3 14/14] mm, swap: shrink xswap to the ceiling when it drops
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p1gxt1ktnyixyi7j4zup3mc7mcebdj3z
X-Rspamd-Queue-Id: 446AA140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790576359-17882
X-HE-Meta: U2FsdGVkX193eT+Rbi94l5OfpNH/7R8cSriBqMcPkuEcnZfoxr3iY+Kqlp7FIjry4mw+i0Qk22PPFqPqwMJy8EEUTkw9EFVdh4BSLDZizMe+R5gki9bY3sMe0qjymGz/+JMp+A86g6julTfSFBf+b5T5QkYnUZQKWjcrsZe3+BBr4QuZOXD41r0jAyDTB9Q4cw+tFFNzmgA6kZEK8ySkZ7s1/ZY9OAAHMSMo5KDaDcLXCbBlD3rD2WIioVt3hG8xt58gxK8Cgdi32jEgY3qf3QU9kQJXWuDEkr5ueK3wWyY9CdRCj0FwqqXe0A9sMPJj4PKENk/gfXFFmTFEcnXy+07LdM55GEzBCjKUaiP3abnY7YuZBlSAactwbfE/SWbVP0HCrJ2rP+emGS94vqyFbJKvMsdJ+Ne57qTlhLwo7p0yj+UHO0BZYvYsZgW8wV/u3IPErnf57UHK5o97dELDCeIwTZnfaKFAX76Bw9H3TrBZNL/obmUkRDtOKaPm/0M5u5ITbR15aE+SSuwAg0imE7DD++Vm/84mFkB4ZUzvndAs/Io89NJZ7uXNPFGXUTW8wMAtMHP0l8fz6mi/5rsDZ6fF2seP8T3xfMouk1381SBr1iUr1sKQbzlJBD4Auehc8oGzGt1d/67DwwUlNQImh0fzKi5o1YDZSWlR3Bq20T4kGSr215mYRlG4ciY0WzT9L3LGdadr1sQK1P/PaSUAdwBfM6Vl0fsKYoncIvzv7iRIhkA2FC6SW37V6QW02xLIczzduL/6H7mhRULmP4gBjcV6c9X2u9WGVg5J3JNjTE8cTBKcHl7Trd00dVJbqvPl8wOJU7u3ymKXlIn7/UxHi8soeBENnO9upBsADhWYjl+tBcEdmVmDDOopvc7dNklhpJ8qyIjXO1b6jQOvq4tvPVK++O5dsZ3Gc9f61V/klMGsusR9kNosLY+XBQegvnhLHfXfyw72oTwQ+/BRnCv
 iooXz8Zt
 eaY478fXhCGWkunW4cfvyZrJ8xih0kniFHCxRdywBJcGa8+SgR2d2b2F/Hb9eVzu1nypIy7jSE6iVN6Rb2oWhCe0SMdVOA4H3OGV3GtIgpaFnqmTy/CSp3sGhfbyVroiQxTYjnLcbsXgw3NEpqA4dsY4VTBqGqucqRT9M3p8SwogOsE0lANUD2oemO8ZH55PPDy4fKCNjTZkQvQkAhWP1qJN9knp3dqmZhA3oqQD04adG2cfXg2XxaUoP1gciS7qsgjyaSBQaFDZhJqQCPJQB6k+LXll7RkwOI2gjgjG17bS26/45lrN1U65drO4FW2Yj8CZp04DThAhDKA/rvIuGQ016ev2z3WEaB8R47gaf7RrKe4s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:21=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> Make xswap_try_shrink() shrink down to the ceiling when the ceiling is
> lowered below the mapped range, and trigger the shrink directly from a
> limit write instead of waiting for the next free cluster.

Again, I suspect we can move the shrink into the later phase if needed
so I have less code to review.

Chris

>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  mm/swapfile.c | 59 ++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 37 insertions(+), 22 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 0fcbaf1cf0e2..ab64bfc4e0f7 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -4190,8 +4190,9 @@ static void xswap_shrink_work_fn(struct work_struct=
 *work)
>   */
>  static void xswap_try_shrink(struct swap_info_struct *si)
>  {
> +       unsigned long nr_mapped, nr_ceiling, nr_tail, nr_unmap;
> +       unsigned long start_idx, i;
>         struct swap_cluster_info *ci;
> -       unsigned long nr_mapped, nr_tail, nr_unmap, start_idx, i;
>
>         if (!(si->flags & SWP_XSWAP))
>                 return;
> @@ -4203,35 +4204,45 @@ static void xswap_try_shrink(struct swap_info_str=
uct *si)
>                 goto out_unlock;
>
>         nr_mapped =3D READ_ONCE(si->nr_clusters_mapped);
> +       nr_ceiling =3D READ_ONCE(si->nr_clusters);
> +
>         if (nr_mapped <=3D 1)     /* keep cluster 0 */
>                 goto out_unlock;
>
>         /*
> -        * Reclaim on our own, but only once the mapped range is at most
> -        * half in use: growth is demand driven, so reclaiming on a small=
er
> -        * dip would only map the same clusters again, and every unmap co=
sts
> -        * an RCU grace period.
> +        * A cap below the mapped range shrinks on its own.  Otherwise wa=
it
> +        * until the range is at most half in use: growth follows demand,=
 so
> +        * shrinking above that would only map the same clusters again.
>          */
> -       if (swap_usage_in_pages(si) * 2 > nr_mapped * SWAPFILE_CLUSTER)
> +       if (nr_ceiling >=3D nr_mapped &&
> +           swap_usage_in_pages(si) * 2 > nr_mapped * SWAPFILE_CLUSTER)
>                 goto out_unlock;
>
> -       /*
> -        * Count the free clusters at the tail of the mapped range.  Scan=
ned,
> -        * not tracked: the count must be exact to size the unmap, and an
> -        * incremental count falls behind on out-of-order frees.
> -        */
> -       nr_tail =3D 0;
> -       while (nr_mapped - nr_tail > 1) {
> -               ci =3D &si->cluster_info[nr_mapped - nr_tail - 1];
> -               if (READ_ONCE(ci->count) ||
> -                   READ_ONCE(ci->flags) !=3D CLUSTER_FLAG_FREE)
> -                       break;
> -               nr_tail++;
> -       }
> -       if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> -               goto out_unlock;
> +       if (nr_ceiling < nr_mapped) {
> +               /* Take the excess exactly; rounding could zero a small c=
ap. */
> +               nr_unmap =3D nr_mapped - nr_ceiling;
> +               /*
> +                * Keep cluster 0: it always holds the header slot, so it=
 is
> +                * never free and must not be unmapped.
> +                */
> +               nr_unmap =3D min(nr_unmap, nr_mapped - 1);
> +       } else {
> +               /* Count the free tail; scanned, not tracked. */
> +               nr_tail =3D 0;
> +               while (nr_mapped - nr_tail > 1) {
> +                       ci =3D &si->cluster_info[nr_mapped - nr_tail - 1]=
;
> +                       if (READ_ONCE(ci->count) ||
> +                           READ_ONCE(ci->flags) !=3D CLUSTER_FLAG_FREE)
> +                               break;
> +                       nr_tail++;
> +               }
>
> -       nr_unmap =3D rounddown(nr_tail - XSWAP_SHRINK_SLACK, XSWAP_GROW_C=
LUSTERS);
> +               if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> +                       goto out_unlock;
> +
> +               nr_unmap =3D rounddown(nr_tail - XSWAP_SHRINK_SLACK,
> +                                    XSWAP_GROW_CLUSTERS);
> +       }
>         if (!nr_unmap)
>                 goto out_unlock;
>         start_idx =3D nr_mapped - nr_unmap;
> @@ -4507,6 +4518,10 @@ static ssize_t xswap_limit_store(struct kobject *k=
obj,
>
>         spin_unlock(&swap_lock);
>
> +       /* Enforce a lowered ceiling at once; raising needs no shrink. */
> +       if (clusters < READ_ONCE(si->nr_clusters_mapped))
> +               xswap_try_shrink(si);
> +
>         return count;
>  }
>
> --
> 2.54.0
>

