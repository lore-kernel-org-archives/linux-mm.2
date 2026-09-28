Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFEFDC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 01:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2196B008C; Sun, 27 Sep 2026 21:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A538F6B0092; Sun, 27 Sep 2026 21:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968D96B0093; Sun, 27 Sep 2026 21:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 701CA6B008C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:18:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2E9A1C3A69
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:18:12 +0000 (UTC)
X-FDA: 85261410024.01.ED15922
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 308E340008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:18:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cMcGBYf7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790558291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GeSgmECTKuaHk2+F7oGmV2w3CiTIst6U8AwDjonsHaI=;
	b=Vc7XnhCWdsRFi2MDhjVh5cbB00wvJSFsd+poQ11aHcdpNcec2lFpOXXqy9v6vTl/MibHNW
	modye9m86s1EXdqFZL+cvSVy/ZgX/RWL6jbN/BLkGKTws4YHUsqaoUXysyM0TUILr7sQdw
	pT6vLCJeIQYV1mkhMMJSS0uZp58LOGc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cMcGBYf7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790558291;
	b=fdhKakV+ZKTBgBAwhNGFQRwDxEgQBSAlfjp/r/60RWr1XIQMMFWxgZ0pqk8LIL+ro1qCau
	+/xPEW4N8AVLSzgz0UpPklcuBu05uCgfEwH0mt+7dmBRKQBJlgsO0kFpJF0d3d6/JErdwD
	QtNGDvrKSBddpkRZBHP5D2fOOiDAzpw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BFA560052
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BDF1F00893
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790558290;
	bh=GeSgmECTKuaHk2+F7oGmV2w3CiTIst6U8AwDjonsHaI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cMcGBYf76yqYpZ9sQKYtcmVuUMn8uo6Zc7rHTHrTNOnyiLl8c6gBo4tqVCpOB/4XA
	 6c4kDp5oY8dIfhTBNtXr+bKRNl83w+Y7wkaSDPYy+xDJHIBaaF3A2/wNIcTdajLjMc
	 E/qIvUxcjFQtGVylSWr33Y1yINdYHQ1MxfSnaqAM82Bk8CepWzdafczOz71I0pd2i3
	 FGrHWoMLAPw+joZR8C2gzOhgpEa9dEEUrSeeUZ85hSE4KDUKhoZALNv72yniZuqU44
	 1dgownxL+7kNaYLONEbhxUHl88ij/LDI2mCScuGKvcipkFBq1jBgpHn0soX0jTctA6
	 RIsG7xt/Z/N6w==
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aafe2a64efso2072400a12.2
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:18:10 -0700 (PDT)
X-Gm-Message-State: AFq9FYI5rkLcQtFWrMrJ2MJEXi3o7bCNNnTZ28cYyydsH9/VWEHMXuo3
	26Pu3gmaDqyC1rkAV3LzjgyFpHSQO0YWEg3WG+tKUbAAQQg2rdhjpvY7nd5LwUIyK2G9N6BBttK
	inS5I9/Fd3YH9gGeSseRzHp8nNF9iWZi/ymP3LOLp+Q==
X-Received: by 2002:a05:6402:535a:20b0:6aa:e9b6:411d with SMTP id
 4fb4d7f45d1cf-6aae9b643e6mr4835243a12.35.1790558289196; Sun, 27 Sep 2026
 18:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-3-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-3-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 15:17:58 -1000
X-Gmail-Original-Message-ID: <CACePvbUD7rQ1=638nzku7mdu08BK0cg1aEX+2jJT+WDJ4PUV0w@mail.gmail.com>
X-Gm-Features: AclHuK9lbaxxfRu9uT3RykRdEUPVHrPVty2eqURRDIMaSXYeT4wqg8fVhgKsuec
Message-ID: <CACePvbUD7rQ1=638nzku7mdu08BK0cg1aEX+2jJT+WDJ4PUV0w@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: w4ms5ez7ozs878ra3ugqt31ifie1paux
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 308E340008
X-HE-Tag: 1790558291-119871
X-HE-Meta: U2FsdGVkX1+bkJA9DDCm26dkf4simkBJebOEN4F2XavRkZh+UNN6qe7L1XLI1T1owfFWe3cauRnHtMdStHbz9BNQnbvIaJO5hbnWuxAVH6ItxQfs8R6XAU9egCzNIjMfxpnuLyxt4qY010JWJeNmF31rPsh8/QdPsOBjXIoNK2V1JGj+yaN2hDuZj4MeZ32NrGmTUCySJpMcBcscpkmR9zcQ+gvLlA/E0jtG4r1proLSDDjkh1RHV1Ga/KQqj+nMs9lSL7NYlFTz/sJFWYA2KmJ4bouk5w0m7HmP3KDEXwO4mzJoL0gER6T2okOCrK9v15gpN6xizAVNOWOjWS+BAG2DKsbFO70Z3lQ8pg5MUNMsQbwz9swjUVe+byPTLZIeZw8jfFodMPFC71nJFWf9+GclvJuypuMEtRbeO/QU0Sq36sUvFizLaxyLYUneMbeD4ngWJY52r2B0o059bjupERtavxaqyblt3sF9ZE5e+2LaAdLff2WsYPhBV7TNEryJLllXnrJXkro//eyeFECz2+HNhM5xSgfH9Znp1dwCfiZE15pt+T9jRSwjatJFLEraeslS1xmj5QweSDQFM7iL6ZuD4FHATxXCRw/F8pzfPHQzRAHU1f+Z1QZh2nHcLY44zWnyqg2tTQqZl3f9ErkM8FmUON4A2mkGYbKC7T/BUmnjrYHcWCF8Ds/6RvUYmgvQ6/QseX84ha++/2Pvcgi05WLpobU9IgPVMPS6xTDLfwFbYdqW5OCOnHaG44PkCsmBSj/zZhJK3vDV8V9hHatcid/ykZzDGPZQOarVqlbA5IS4psCYZFdw97sbPe4+6nCY18C+ftUNZ+3KUcCfUHDzhc5S1VUQJY8YE5DGUmoPSy/2Ot1C2JWd1na/3xdv2XTkqSJlznqbqIAP8bRzGptR7FqIkFlZco/XbNT6xIikwSVz7ShYLYIb/tutVk1G0FuT62ZbGuOaEd9o4t670ZY
 3QNZZp2u
 0+XZKGhRwOcPGGPvJNJ/rtZjvfE6yahYs6vS/tlXqxG1IvT19aYaI2Y87Woyz91P/Wk45G6PTq+ipE4zcMfBe01GGoJAr2+2mAR8sHHandYKioebfUTuFtyLf/v2OUOFzx0nqPxNllkEA5QLJmu3J3Ng4fmKYlQ/6Om+GsyXXQ4XN7GGyjoK1FEk+HM8+R08cllOXllWIR0Qv6X34h8o0QXkALZ2LwtJmEncKmeAZkkOhEHU0d6DSk8fB6rbvhCcIv2wCeWqLlkjasZqcoxni93+9ZabsLAsRdicWJKV39vT+Op4/lroIFZ2t1yXrXEPqSWPW3JzDCPHA8lxZVfNVEIkYZr1lgNsXnVlc0JTxpWWBW83QNvGwC/iznIKcKDK/zdO/A1YbMIE03GjW7wki0lfLng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:19=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> Add CONFIG_XSWAP Kconfig option for extendable swap device support.
> It depends on SWAP && 64BIT && ZSWAP, since xswap devices are backed by
> zswap, and on SYSFS, which is currently the only way to create one.
>
> Add three fields to struct swap_info_struct under CONFIG_XSWAP:
> - cluster_vm: the VM_SPARSE vm_struct backing the cluster_info array
> - nr_clusters_max: total number of clusters in the xswap address space
> - nr_clusters_mapped: number of clusters currently mapped (lazy grow)
> These fields enable lazy vmalloc-based dynamic cluster management.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>

Can you fold this with the following patch? At least the struct
members should go with the next patch.

It seems nobody use those data structures in this patch anyway. So
this patch alone has no visible value add, other than adding the
config file.

Chris

> ---
>  include/linux/swap.h | 5 +++++
>  mm/Kconfig           | 9 +++++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index b4331ca4759a..b7882aac1eab 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -242,6 +242,11 @@ struct swap_info_struct {
>         signed char     type;           /* strange name for an index */
>         unsigned int    max;            /* size of this swap device */
>         struct swap_cluster_info *cluster_info; /* array, one entry per c=
luster */
> +#ifdef CONFIG_XSWAP
> +       struct vm_struct        *cluster_vm;    /* VM_SPARSE area for clu=
ster_info */
> +       unsigned long           nr_clusters_max;/* total clusters in the =
xswap address space */
> +       unsigned long           nr_clusters_mapped; /* currently mapped c=
luster count */
> +#endif
>         struct list_head free_clusters; /* free clusters list */
>         struct list_head full_clusters; /* full clusters list */
>         struct list_head nonfull_clusters[SWAP_NR_ORDERS];
> diff --git a/mm/Kconfig b/mm/Kconfig
> index c180d40cd671..5d6c7845c422 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -122,6 +122,15 @@ config ZSWAP_COMPRESSOR_DEFAULT
>         default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
>         default ""
>
> +config XSWAP
> +       bool "Extendable (virtual) swap device"
> +       depends on SWAP && 64BIT && ZSWAP && SYSFS
> +       help
> +         Adds support for extendable swap devices (xswap) that decouple
> +         PTE swap entries from physical backing storage. The cluster_inf=
o
> +         array is backed by a sparse vmalloc area that grows and shrinks
> +         on demand, avoiding static pre-allocation overhead.
> +
>  config ZSMALLOC
>         tristate
>
> --
> 2.54.0
>

