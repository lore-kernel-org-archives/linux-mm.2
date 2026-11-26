Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3566606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c3btqzB8
Received: by kanga.kvack.org (Postfix)
	id E19666B05B2; Thu, 26 Nov 2026 13:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9816B05B3; Thu, 26 Nov 2026 13:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDFD56B05B4; Thu, 26 Nov 2026 13:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC3BD6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:34:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D885C039C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:34:35 +0000 (UTC)
X-FDA: 85478120910.23.A88F3F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 326B5140007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:34:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3btqzB8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795718073;
	b=e1FK7zUC0nKqRKhBXIY5Bn5/wDO7Yom0IeR45NHfhyN/W1QT9BTczDfSE58abUfzc/+W71
	cBr+cFGhOUD034UOop6NB0Po0k2v5TyNcyyVO+bhG7yaYgKcU3PQRfT2K6B40fKKAiiOWG
	iQCtPMkJYNTtFtDtXZEyXqizhR67CWM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795718073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WpWOMOBXLpseWsTI54gapbQDoJPIf/gIWtR8WvSGak8=;
	b=oZ1BxWkYeNQNcfj5Hi9mGKF1p1rGaczptwqvBNxFET7u2XmcjMUmGBYGwx0EsK0cmuaMax
	IUbSZc43Lvd1q/C5vSVSxhXNwB7AZ1gSOSgtkd1g+Cr7XbX/OJvjFcxO/EXLJ4fwlB7fIV
	NEzbd/Y0t5V7LMug6bIPSj6GSU2PV4Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3btqzB8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FDC743F3D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE691F000D4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795718071;
	bh=WpWOMOBXLpseWsTI54gapbQDoJPIf/gIWtR8WvSGak8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=c3btqzB8gAbzCnDC2ConCPT/CRsFYpzQRQ+gN0WdiN89OEt4F3k9/Wmh64/58OdJn
	 /rLh/vhLaPLmPAC0bTVO7pqCfZquct4g48VXiVkDztK4URVyLfhcsRmof9xaE6J2ki
	 Y/mkqRTRzrOIODjFbo3tUjYbSxEtgRB5xbWzcmk1x2UsHXFJsPITOfQf0zX0U5xASd
	 lD//ZD9dKRxupdOudwLQVeAhPlu7XSCi5w7AGOhMYX2mXuqu8SCnVh7M2j51z2EkOE
	 +ONXAMrilD51v/GAHPOzdxBkM5T0dWvBlP9x/IvVwtOxFHyFrQvYKfpfO8HwCYM6YM
	 xl5YSZVR1fyew==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c516a574bffso237747966b.3
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:34:31 -0800 (PST)
X-Gm-Message-State: APuU4Z8W2tGi2LF+HD+QXtKiMYsEi/1FU6RvwlRAUH9fcwLVKLbIrFID
	FVFOEHShP+bX68vJy0uGSSyQ8kn77toi8G5WDRESz3H79qTXAqjahb/XdjgKdiSC1ZNIffTYHyh
	RWxH9UwfXepx5snDYSBOv2UBTZcpNEoh8R7ACWHHXog==
X-Received: by 2002:a17:906:369b:b0:c46:ba33:1f0a with SMTP id
 a640c23a62f3a-c513ab2d54amr1405520866b.31.1795718070544; Thu, 26 Nov 2026
 10:34:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <e920cffdb3a65905dbcf51fa3520785a8c49fcb4.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <e920cffdb3a65905dbcf51fa3520785a8c49fcb4.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 26 Nov 2026 10:34:19 -0800
X-Gmail-Original-Message-ID: <CACePvbVr7A91ya6P9Sbx9s+V6cVqba-avHCBnJDViKW2f805zg@mail.gmail.com>
X-Gm-Features: Aa3M54qnFahPYvSkr8RQaB-gaD5UQ6JhIZIe7bMtBUKRRmfXwB7jDLedU6V2ZBI
Message-ID: <CACePvbVr7A91ya6P9Sbx9s+V6cVqba-avHCBnJDViKW2f805zg@mail.gmail.com>
Subject: Re: [PATCH v5 09/19] mm/swap: avoid direct reclaim when populating
 swap cluster metadata
To: Lian Wang <lianux.mm@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Jihan LIN <linjh22s@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 326B5140007
X-Rspam-User:
X-Stat-Signature: r89hpc6mqfeaix6s5kqak5w9ro5dgiuq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795718073-276230
X-HE-Meta: U2FsdGVkX18CvgmCoXgIiafLAFTOJite+8zaW6FZf7zxO8y0ySTx77ruuXZuk7G1ySoAKk2rwWLBADcXT4qFDbp3xQSdlMJM/ER1sMNvKMdmBb//xAjpH0hc275PhVnXiKtAX2ZDhFtaBSninJLJFZc2dESkkwZxVX5CMdA51k29gHbm0bpbtoDa3nHbjLsjoYIvvCsddNXYmwyLZH6LzyFWe8BVVG3eu7/qSMdFO3+JqAJMBL/V2SaSUlRDtKYTSBYEkZ3ydgs7JCekjZsa4FGU1YYHdT9GzJQi9fyunf12LdynaGixZcO0tJ3gslPADU4s4Fjth79HWld/ghTFz0lxt1uSPF+AvMHRaXJT+9pVjmnQMpgCcwP06lRRYRXhGFNelRvbJhMKB6Ei05Cbh1T7XL3h15J6+Vo+iycola/hLeIEFKA/YdFs53OF/0L01TGxx41q58TLSny1Ab0qAKMJy0f2270E1Dyzq376ZSTqbcJUQOOIex0IJRv6bqK6qBuZY6+YnqFs1kBjR5iLdLCGCTEm8XL0RSaaRldx3qi4t+AXOXlf8cRnRYmGmCTCcS24SGCzHk6A06jhx6tq3pDOVkKHNDKGT/uarYykbeZE2u8cEJ0MXmkGEt6uiFR66agZ7GfUM7XSxw4bfaBrZWiT1e9axLj/JNrHGl1sgfwCN2S7fglle/q2vaz0b9J8HeVyL+Wg6GwZbMPMQNy2spdlm0Wme4EhUAHEkVswdFEiU8t+ZGhQBYJIb7zGM6VnhaWCyqZoUCATg+W1oOvQodNmmj4a1nhPxFw8ZaA+cOwH6qi91wxt8bFmXQVKsWYccuao9XZb4Y88lcuAe2e8+7X/LgbuAunFQ8pjiqLndsElkRbX0VTVe7UFmfAYRJVpFOoGLE+Gyk9131yiapKeG+/3b5zjMyZi7d5N/VvFzGdfSJQe5Z1nLlOuPpj8m/xGHfQ/EZI/onHc6STobr5
 uD5MQK4Q
 CJzkoTkkf4XPMx5bX3DW0i8ilfHTdtEKcXZJhsekYeBJTC/3wlpsgDW4R52kPWbUuqfBm/N50+YcpnXunbNwFPGXfmNlTNWRRkHRtrreRq47kGCIAkPqgy+kHnpuiIP8hz+PIp5K28dMTKH/+VE5A+yXhDflBxBYp1H95gzXJSBk8mInTHq/t2+W5qqp59hrQ/5+f1SkTPrvBjM0hhuzan2wASdEJa+eLzeyIFBgO/LXWNtDaDkflSEGKJf1QA3ja5I7oLPzBMkPr6gjazyhnd/7lGVLNDqTDb+ZGC6ckEp3ZL9x998avneOVsUdo72ZLdEu9bwa9tW6pIuvlvrIE9nSwxnsBzJjEuaZMyodYHslzE9u2Du8iU7abl39VH1B+hpkaYwneh4a4daPB7HfNFpo5iO7iN2AiF8SHvQ/+vuc+/ve2yMhYCyxeRue8S/FlcEnihi2+g56fWR2EMg7y9a3ew0SK6r1+nMuQ5rbHGPdTYtyLF8iNF8JE1e+yKrtZW/QFljrNOzVwZvDw6u2V6Emj4djIYGd96IJocCsBCo1+6BQjyI+v+dtT07lcoukAUeJlhngpR6X8RZXfLj84VGTqA82KMOwn9XVGJlRqrDy9y7CVA3kCFXpipTIfFOJoKWZF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 6:18=E2=80=AFAM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> Swap cluster population is entered from swap allocation and may itself
> need memory for slot metadata. Its fallback drops the device and cluster
> locks before allocating with GFP_KERNEL, which can reenter swap
> allocation through direct reclaim.
>
> Make this allocation boundary explicitly non-reclaiming so callers can
> retain outer synchronization without a recursive swap allocation.
> Clear __GFP_DIRECT_RECLAIM from the fallback request while retaining
> __GFP_HIGH and __GFP_NOMEMALLOC. The retry can still wake kswapd, but
> fails without direct reclaim when memory is unavailable.
>
> This can make metadata allocation fail earlier under memory pressure.
> Keep the existing isolated-cluster rollback and restrict this request
> without adding a task-wide PF_MEMALLOC scope.

Acked-by: Chris Li <chrisl@kernel.org>

>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index cd2cb360f274..70913402a265 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -586,13 +586,14 @@ static void swap_cluster_assert_empty(struct swap_c=
luster_info *ci,
>  }
>
>  /*
> - * Allocate swap table for one cluster. Attempt an atomic allocation fir=
st,
> - * then fallback to sleeping allocation.
> + * Allocate swap table for one cluster. Attempt allocation under the loc=
ks
> + * first, then retry with the locks dropped without entering direct recl=
aim.
>   */
>  static struct swap_cluster_info *
>  swap_cluster_populate(struct swap_info_struct *si,
>                          struct swap_cluster_info *ci)
>  {
> +       gfp_t gfp;
Nitpick:
gfp is assigned and used only once here. You might just as well make it a c=
onst:
const gfp_t gfp =3D    gfp =3D (GFP_KERNEL | __GFP_HIGH | __GFP_NOMEMALLOC)=
 &
               ~__GFP_DIRECT_RECLAIM;

Chris

>         int ret;
>
>         /*
> @@ -610,9 +611,11 @@ swap_cluster_populate(struct swap_info_struct *si,
>                 return ci;
>
>         /*
> -        * Try a sleep allocation. Each isolated free cluster may cause
> -        * a sleep allocation, but there is a limited number of them, so
> -        * the potential recursive allocation is limited.
> +        * Drop the device and cluster locks before retrying. Metadata al=
location
> +        * must not recurse into swap allocation through direct reclaim: =
callers
> +        * can retain outer synchronization across cluster population. Re=
strict
> +        * this request instead of granting the task PF_MEMALLOC, which c=
ould
> +        * give allocator hooks and failure cleanup reserve access.
>          */
>         spin_unlock(&ci->lock);
>         if (si->flags & SWP_SOLIDSTATE)
> @@ -620,8 +623,9 @@ swap_cluster_populate(struct swap_info_struct *si,
>         else
>                 spin_unlock(&si->global_cluster->lock);
>
> -       ret =3D swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEM=
ALLOC |
> -                                            GFP_KERNEL, false);
> +       gfp =3D (GFP_KERNEL | __GFP_HIGH | __GFP_NOMEMALLOC) &
> +               ~__GFP_DIRECT_RECLAIM;
> +       ret =3D swap_cluster_alloc_table(si, ci, gfp, false);
>
>         /*
>          * Back to atomic context. We might have migrated to a new CPU wi=
th a
> @@ -3160,9 +3164,8 @@ static int swap_device_disable(struct address_space=
 *mapping,
>                 return err;
>
>         /*
> -        * The swap allocator doesn't take swapon_rwsem. Looping through =
every
> -        * cluster lock after clearing SWP_WRITEOK ensures that allocator=
s see
> -        * the updated flag and that no allocation remains in flight.
> +        * Drain cluster-lock users after clearing SWP_WRITEOK, so swapof=
f
> +        * does not race with operations that started before the transiti=
on.
>          */
>         for (offset =3D 0; offset < end; offset +=3D SWAPFILE_CLUSTER) {
>                 ci =3D swap_cluster_lock(si, offset);

