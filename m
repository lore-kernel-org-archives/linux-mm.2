Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13386C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 06:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC02B6B0093; Mon, 28 Sep 2026 02:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71EA6B0095; Mon, 28 Sep 2026 02:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62E56B0096; Mon, 28 Sep 2026 02:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69D276B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:12:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B78DCA7233
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:12:50 +0000 (UTC)
X-FDA: 85262152500.25.4BE16E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D402A40002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:12:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCiOCjQO;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790575969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOvxk9bf4WjHbND3kJz0snmFw7+Hy5AGGjAgEuRz+L0=;
	b=sPY2c0DJyAPZD3+lng1r+GoRG5RM6OeWU16wl42wVULQ7/kf9S3Lv6+evoeOeNZF+CjMwd
	XtDJB7X4h13X3qkXDk9CCfFmKoLLYqxcTBsVolIV0ks02GbE5rP72rs8p457lMl3sS3WvQ
	dJRFaufE6i6bfL4UD2LitGrfOnfcAmE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790575969;
	b=m6gJc2Pm5mKEy9qlCKCCjMMev3fQBQVLv8KY5VbrChKXczhe0lxI0ErY77IsxOd9/Sjd9A
	mS+o+ZTeVYh7kBkwDtsRcq9yPKzIIHmJ6MP+jZz41BJIt5mtSM5+w2Sb+vMu6MKJCGc+s3
	vOVrjNvlMnJk8nJM3hK/ML66Ljemfx4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCiOCjQO;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1622F43ED3
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED77B1F008A0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790575968;
	bh=FOvxk9bf4WjHbND3kJz0snmFw7+Hy5AGGjAgEuRz+L0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bCiOCjQOnlRWZjoukb6HnM8P+vJIvgZxfZMSi7TsST9FZrPhX1RpEaw3kjiChJ8sj
	 lid6zKin+wXMSxvSyQVZBwGM5Cnw+ehLAXcUcDsI+Si40zjeqIVGZKp2gNY/QOslr9
	 7pHoa6dqcNtYyzgFpQQKAmpB5eZDmBTh3nBWJC4xXfdXvAg/CediffMjz8pgnxWrn5
	 fJ4saOFH4KNnb1zjJsfl+rKbzVfvv1U1ucshYF4BcssnlZqKfcYO+NMqCoWqSQqhxv
	 E5B1t1jSD/lpzlWdtgut9PfnjAViFp5PlrRcHu3Fcyw/IcKOcvqGGSgC0bgMJPe401
	 ZunAuGK08PFkA==
Received: by mail-ej2-f16.google.com with SMTP id a640c23a62f3a-c2afe9fa8e0so218921066b.2
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:12:47 -0700 (PDT)
X-Gm-Message-State: AFuF++meTb3eau+JGQrWCfgBqhP9xz1Qwg2S9YFhZIBqo9bFHFnzJ+Of
	U59nRJdfZNncvBff4JquiKGvFSThVep280a/Ji3aQDBQPjwpmKKonIMBTOy7FIA1QLSmvoXQqB8
	y45QSiYVWrb4NvRB6nG/6BHMQZVcuoDlu9TJQ+pYqbw==
X-Received: by 2002:a17:907:c71b:b0:c29:53eb:9913 with SMTP id
 a640c23a62f3a-c2ac2531dafmr977835366b.38.1790575966734; Sun, 27 Sep 2026
 23:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-13-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-13-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 20:12:35 -1000
X-Gmail-Original-Message-ID: <CACePvbWKRstUOsAQwoZ7Zt_Xf+t7nMPvP2igD3h0Qe=9Rzx4gQ@mail.gmail.com>
X-Gm-Features: AclHuK-vYUha6O9a-v78F4uwNbjs_qMydb4jalHWGfKLwWnn1cUHLlCDprAuc4s
Message-ID: <CACePvbWKRstUOsAQwoZ7Zt_Xf+t7nMPvP2igD3h0Qe=9Rzx4gQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/14] mm, swap: cap xswap growth at nr_clusters
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D402A40002
X-Stat-Signature: zwdg3qretn1q7bhrxr34ipexpxsdoyqa
X-Rspam-User: 
X-HE-Tag: 1790575968-453753
X-HE-Meta: U2FsdGVkX1/CQ6Xoqar6A4ZKdJJELGP2aUt6yfArjxiUtx0ezjY65L49vxVIkXWMBrN/ldRs76QJ9gXU6KQ/kPLvoaJbkwb822Cd5OQunj3GRQK5pbcdpzh3XdjVZtIhjLJij4YO9tFOKVcNvBdz0lNXb0WaTeGpy/nLrIlwvIx0yoCLD723dsGjLUT9nv60y2p1D8+tLjUDYAIMaRQaBkOv7dWNXRTyubvPVPuU+rNpiUMAQq/CV+o7brqgMA8nb5QnpY+gjurmKMtuOaPnEAfwIXXHd2pgqnvDMM/K4TiBEz+Tsr+DtMk2/5gT6bJttcx/r4UfO6977csOKUErREs8Cz45C6Ak8/yGwfzEza7Vm4QLrrogafoNzFp0U5BEWds1T1xhOw0sQCY6xhpekj1c/f8FygCLSld4ZxYcs1zzE+2QOp3XGyficAQyhtY3qH49U8jK+lFgGYvaAWdNTnAeP/q2riJazlwtLBP1ho+kdMIo4mxJtihw4i0m4mpXCsUCD+1YCUHpNa8zRPx5lqPbSXIxB/3NcEpST5Stv03My4l1cDoXo2BQI8+8ZWAPXzwZBYreUiLVBPpGy6tZ2TTDTOZIDfWhC25M/qQAwLA3F6dU0ozv6P9Gew9p8oghghkPrgkVJZEdU5jNa6xdyuVOnN7JIDvwjl7T/iQjyBQC5g2IhROpa1/HxT5gi467f2kOAkU7J/T2m5m1cHoKblEl+HvCwYlMWwLOWxtez7PnmVxpErb7Lh+r3v+JI8u9+bTvAQhBuX2Yn/vkzmbOiK6coD9TR5hDl/TGcATipsSfkrPIz89ZZ65e7IWX8J9WeCpcihNtk7hv0ZCY5/0pMI70QHYRd37sCkvlTWEvzmAEmN0hAKtNa9Uxrg02WMRsf74pOGZwmchhvvzKNt1dgJsFtU6m9R9U3hoJIWgseH67XXCX4KO/5qQ0+m/9/2Ua3GKyuqrcAS9CEqK+2eY
 5qeyirVu
 pm81AZv5t7BGjj0EHx3i3uR0Nj/+6acy2rFIz6ocKffBlCDGTO4YwrLszyJ+6j97fHhK9PyxwGbazgJTX1VRo00JrMpoRi0iU/LGzFxGYesF3QFG0uRn/pfW3Isd8FlPsiqCQDkulsyswQ11JEdGRymkc+VQOphw+w4Nw0PwzkEvDF9+qKB0exmhCsN2QDzts+zRpQakIOPpJQEmpNoSL/gi7fKUX3HeWWibid6pvCTxiGrsR89440asuRcd9bdncemQGG6QV2t7dd7NJmzg96bvWbhmRkMqrVi1XIFd1v/dGf/gOL580SwecnFtNWj/NYkyc0SB+DQJt5nLtEgIodUmZONsEeiMkI9IenIW38cSbzUA/lptsB5k/8vV1Wlw+f6+b3bLSLO+ivZhtwwNIQxCaGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:21=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> Add si->nr_clusters as the ceiling for the cluster_info array's growth.
> It starts at the whole address space, so nothing changes yet.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  include/linux/swap.h |  1 +
>  mm/swapfile.c        | 19 +++++++++++--------
>  2 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 30642bb481df..9fe82d0f1740 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -245,6 +245,7 @@ struct swap_info_struct {
>  #ifdef CONFIG_XSWAP
>         struct vm_struct        *cluster_vm;    /* VM_SPARSE area for clu=
ster_info */
>         unsigned long           nr_clusters_max;/* total clusters in the =
xswap address space */
> +       unsigned long           nr_clusters;    /* how far the array may =
grow */

Do you mean the current usable size of the cluster array?

>         unsigned long           nr_clusters_mapped; /* currently mapped c=
luster count */
>         struct work_struct      xswap_shrink_work; /* deferred shrink tri=
gger */
>         struct mutex            xswap_lock;     /* serialize map/unmap op=
erations */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index cac084bc72d6..2cf6ba0bd0c0 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1319,16 +1319,18 @@ static unsigned long cluster_alloc_swap_entry(str=
uct swap_info_struct *si,
>
>  #ifdef CONFIG_XSWAP
>         /* For xswap: grow the cluster_info array, then retry. */
> -       if (!found && (si->flags & SWP_XSWAP) &&
> -           READ_ONCE(si->nr_clusters_mapped) < READ_ONCE(si->nr_clusters=
_max) &&
> -           list_empty(&si->free_clusters)) {
> -               unsigned long nr_new =3D min(READ_ONCE(si->nr_clusters_ma=
x) -
> -                                         READ_ONCE(si->nr_clusters_mappe=
d),
> -                                         XSWAP_GROW_CLUSTERS);
> -               unsigned long start =3D READ_ONCE(si->nr_clusters_mapped)=
;
> -               unsigned long i;
> +       if (!found && (si->flags & SWP_XSWAP) && list_empty(&si->free_clu=
sters)) {
> +               unsigned long ceiling =3D READ_ONCE(si->nr_clusters);
> +               unsigned long mapped =3D READ_ONCE(si->nr_clusters_mapped=
);

Can you help me understand what this change is doing here?
The patch description does not help me. What is the difference between
"ceiling" and "max"?

Chris


> +               unsigned long nr_new, start, i;
>                 int ret;
>
> +               if (mapped >=3D ceiling)
> +                       goto done;
> +
> +               nr_new =3D min(ceiling - mapped, XSWAP_GROW_CLUSTERS);
> +               start =3D mapped;
> +
>                 /*
>                  * Mapping pages can sleep.  The lock only guards the per=
-cpu
>                  * cluster cache, which this path does not touch.
> @@ -4294,6 +4296,7 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>                 cluster_info =3D vm->addr;
>                 si->cluster_vm =3D vm;
>                 si->nr_clusters_max =3D nr_clusters;
> +               si->nr_clusters =3D nr_clusters;
>                 si->cluster_info =3D cluster_info;
>
>                 /* Must be initialized before xswap_map_clusters() locks =
it. */
> --
> 2.54.0
>

