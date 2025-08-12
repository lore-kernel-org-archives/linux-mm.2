Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F498C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 16:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135758E0172; Tue, 12 Aug 2025 12:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7DF8E0168; Tue, 12 Aug 2025 12:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0158E0172; Tue, 12 Aug 2025 12:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE6718E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:57:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A391B140119
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:57:17 +0000 (UTC)
X-FDA: 83768710914.20.6DFEE2A
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id B2F02A0011
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:57:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JWZ0F8aA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755017835; a=rsa-sha256;
	cv=none;
	b=g+dLL03kPLc4hkhf8I5b9PXqfbWbJA9tNsAf8ZCz76oA2DAp4yAVb55qh7XgvDhTbXdfME
	Oo1cgqTtWAqv3Kkdo0HZ0PPVRbJ62bAh6ANkNR+qLqRMovXTuPe/nAFO3OGmjf9X8K3UK6
	9b/Y9Gx2B74rdatBLKOBcqWWRCMNnWw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JWZ0F8aA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755017835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFHw6SHxzXcAfU/vsZyTPxWUIAjVGdLsdLAXBzbY+0o=;
	b=b/474cAkFoCPdNTFmTGrQow7fIWTX4DzFJN+Y6Hn5+vyNQel8YJ5duL57KfTJcwde0PFOM
	wW8MVU26KdRXbdM/Z6hRl1ri0ZCfAUAi9LqW1SB2qXesosdoChQlzPBtCN3HydPrmNvfie
	/yUEgNOmsf6KfLi6nWR0q8/VWXOWCus=
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3338149d8a3so1145181fa.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755017834; x=1755622634; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QFHw6SHxzXcAfU/vsZyTPxWUIAjVGdLsdLAXBzbY+0o=;
        b=JWZ0F8aAa7c5OLA43q/mGBi3iOzebxpEyxSNujL101+XYja8+KqgbUGvaSl50g5ZFT
         KaGzV5TGz/NPiTHSl8HiCXo8o1nDWe305Z6CuoTuGRef81+zGQNZ811+skLU9eEN5cAy
         fDFxa+f/oKe6dVNbfEzpyMB6NCIJ88DFIsKHSlklOu4faMLy70/gqdHCvt3LRfGRgtOO
         mips6bSve8ZKhpmLqk1DHwu+XxqVGP+A8bV30CVi5SrtoNPVabAltme2/2fnlA120vob
         acLw0AARRtCG6z/ZiUw3axk058mJ5GXsEFKhz8T+jqmLS31awnTYojcT7b4wvqCDXiuS
         f86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755017834; x=1755622634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QFHw6SHxzXcAfU/vsZyTPxWUIAjVGdLsdLAXBzbY+0o=;
        b=OGAvVgmmm5AE7xsjhc9iTtGK+4xlxpkLNhvbllr8ibR+EIj9E23JjGdDc8VCkro//K
         ny/3O8D8bK71mSPmK3EN6Ii7iyPl8F2mECyiV5lPSfq4eSC1LsM50VvHKoznogjXzxqf
         jz0+QryjtTV0pOglOXTid89kFQSlk3B2AWuQHID/JtnrUcQmw6TX5wAtSQAyXsPe8LGI
         KcbChjZtQfCyfxfujN8Vtjp21p1ippzgVdIOJkGbNQ1Kj5jTj5FCwZfLNkaiCWbeB4W8
         c4uhhZq08glfvcAC1a1PyN57dr8eVeD5RFMlHWYv8etDhW+bStArRkoZtYRNLg4gvrkN
         7urQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdhqv/Ka1wGKc7cXjfuwF7e/XxdZyWfytjXJnc2JSdS7erx78eg8R3pxUcN3JKLGJl8oE7rNG6ww==@kvack.org
X-Gm-Message-State: AOJu0Yxi2k3S3vA3oNcJvmLODGqQZsNu+XqyKn7ak/yWRjhxeiN4v1XN
	GGYG624mxEGkAL/ev23swy2uUdCNRcB48tx9z9Yw+ceKgFuzDZosB069R7919LCaai9qAfM/2bk
	TR1QGTH3xM6ZHR0IrFlrE6cZkpeB+VzxgPr+NP0YM7Q==
X-Gm-Gg: ASbGnct8PNUuRHpshsG561XV3qjmrEid6RLGRoIhbiAlQJuqxnjJJoix1tLVY9jQpwz
	In5WYGRoj4NWfxpE9oeVR1WaIMfTta3NFvc23X1LuNXTJIjiEQegeeQ37E6rsZylgxZE91PxoUA
	agWH6g5i6XMP2el3DPSRebNv4ilAO+3uTkgypgv4rfRp+Mq8NIZBf998q03y3Qn/Jy8g6kpHfIE
	SPB7Wo=
X-Google-Smtp-Source: AGHT+IGAXUSvPCUvMDI5+89UaP8N5N3O4+7t9/+gcbWizP3+ruBqRa1hZorGwzqmAZq+weI7GxvjOKbzFW/SRFp1TFg=
X-Received: by 2002:a2e:bc1c:0:b0:333:951f:6dd7 with SMTP id
 38308e7fff4ca-333e63fef8amr830251fa.3.1755017833531; Tue, 12 Aug 2025
 09:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org> <20250812-swap-scan-list-v3-1-6d73504d267b@kernel.org>
In-Reply-To: <20250812-swap-scan-list-v3-1-6d73504d267b@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 13 Aug 2025 00:56:35 +0800
X-Gm-Features: Ac12FXzo1AIPUJobDlH-XMCSbgV5hOCxYqeAZBXZCtl8HSzZUrmCxppKj48iRm0
Message-ID: <CAMgjq7CL1pUr25efhu+bT1PRdqw+TkAaCCsBi-1DRBfd28N4OQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/swapfile.c: introduce function alloc_swap_scan_list()
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4pdss61s4q64ru3obphj593dhjw6fbfz
X-Rspam-User: 
X-Rspamd-Queue-Id: B2F02A0011
X-Rspamd-Server: rspam02
X-HE-Tag: 1755017835-188181
X-HE-Meta: U2FsdGVkX190+y67XLA63sCojOrwQrRXbkmFTZaAgTgTHF2mz0Nio6o4x0Srkq3e/osKMAhLAsm/CSjlboYxq6+erZkLYG364fn7zaf9efI87LlZWkXGDECZgcw0BKKt2YI9h7enAFWuSLwrsRkGCFj4camctVo0lWgBqgQMQ+09yFWToqeNyLHTqD5+J0rIk3ZOh/HpEZSxlH1pGhNOe/jlSqsXS1rOtVsj395dxUvPlokhJTiuTtOjO3d9CDeNrJNOR12XQFI9cGS7/hkuVDWpdwCmrx2QiUWUObfwve+H/ahA1WJ4QCD+1z7i2reKTyS0zLdp3/81iJFKzTkZ1b2Jt7Ey+CHbBevMABeGGUpuAAWmByyiR3/C71ZslyrnjyCIpw3aG9ZEEXNBjtjfT1gHjaS1by5ZV+8ahfD3/i8rTdYP0u3KESoGq9NcXE4KkbsHn9aKqd+Oq/qvA/9HNFqj+3+m8NLTRyBIZ/0icRdcbMcnWfdVNK0/jfe476rNPJVnS65IksiWq7m03vBzG8bvGSWBxo+6VjAhyIjfPWWVULcTjTruf376HJ2Afn6sJnTfAIhvEDZSXSuUD9NQPDJuk0155/2Mcg6M1rbuqNfxT9Mj8KI7UWf5oiVbVWdG1fNQLgytCm+lYjnLsQNDPX52NqBhvdVH2bzz5cPIEUHcd10Vtn0YxnMYgFMp7oN0sAX9oLv58zsCI9ssbTheE6sXgAsWtuD60qHZaECDjs7d0G+Q9Khrq87e32/o/Kg5TbtrBJGpynWlMEqQGV5o43uomlthlrCiXKVFqs/KY511J6XhKDFOvidww/OJu/P9aaEBWjsdWIgG/hotpBQUv2XVeyriR2cBLPnVNEPjHmpFhpJeGv8WW4PgXwzl+O+ZVfYFCKjHqut3G9lQlTMVrNoPq2ujh0O0A/P9kYV6jOmQvVqcywdcIwPgfPWIK/MlWkerA1SLFbU92MOJ/Ge
 /QY2Os/x
 3h3yeQzPtUEVoDuzv+AXGy0XVgOT+8I5zVpV7LJGphsHCUiejw1Bf2jENjKddutdOevmPnzwSJ5/pVIm/N22kknmxIiTZpjMqVu2fkkMlnlKoeA2e9ZyXz7YzFD13E1b6159I1RGSAlJSWmxiF1Disrv8qJyaugm+RhOwoIWWqF40UNfD2xRe0d75IDu2xRNjgLo2/qMbjNsnVZtdO4P+QSNh8pwFqjfc47XBWPpOHR6F5RKj2P8lzfznHaTegLxUb9jaMnZIV36uTMx/aY74tQEy8shIOsk117Nj5lcZT0VRZxz+qcbZscl0QynoJbDB0SWuww6zeITUKYk6LEdIMwq279HPhSm2d2VzZOAayu/YD3YP4uwtaICeHrxxW9HWsJ8ZUKzaZxm8cFljmAQylY5miuUpaCMLJ79Ie5M/MLzuWYRxm6Q8elMh5Q6+jHG2Q2RD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 5:13=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> alloc_swap_scan_list() will scan the whole list or the first cluster.
>
> This reduces the repeat patterns of isolating a cluster then scanning tha=
t
> cluster. As a result, cluster_alloc_swap_entry() is shorter and shallower=
.
>
> No functional change.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> ---
>  mm/swapfile.c | 86 ++++++++++++++++++++++++++++++++---------------------=
------
>  1 file changed, 47 insertions(+), 39 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4a0cf4fb348d..a7ffabbe65ef 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -820,6 +820,29 @@ static unsigned int alloc_swap_scan_cluster(struct s=
wap_info_struct *si,
>         return found;
>  }
>
> +static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
> +                                        struct list_head *list,
> +                                        unsigned int order,
> +                                        unsigned char usage,
> +                                        bool scan_all)
> +{
> +       unsigned int found =3D SWAP_ENTRY_INVALID;
> +
> +       do {
> +               struct swap_cluster_info *ci =3D isolate_lock_cluster(si,=
 list);
> +               unsigned long offset;
> +
> +               if (!ci)
> +                       break;
> +               offset =3D cluster_offset(si, ci);
> +               found =3D alloc_swap_scan_cluster(si, ci, offset, order, =
usage);
> +               if (found)
> +                       break;
> +       } while (scan_all);
> +
> +       return found;
> +}
> +
>  static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool=
 force)
>  {
>         long to_scan =3D 1;
> @@ -913,32 +936,24 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>          * to spread out the writes.
>          */
>         if (si->flags & SWP_PAGE_DISCARD) {
> -               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> -               if (ci) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       order, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->free_clusters, or=
der, usage,
> +                                            false);
> +               if (found)
> +                       goto done;
>         }
>
>         if (order < PMD_ORDER) {
> -               while ((ci =3D isolate_lock_cluster(si, &si->nonfull_clus=
ters[order]))) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       order, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->nonfull_clusters[=
order],
> +                                            order, usage, true);
> +               if (found)
> +                       goto done;
>         }
>
>         if (!(si->flags & SWP_PAGE_DISCARD)) {
> -               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> -               if (ci) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       order, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->free_clusters, or=
der, usage,
> +                                            false);
> +               if (found)
> +                       goto done;
>         }
>
>         /* Try reclaim full clusters if free and nonfull lists are draine=
d */
> @@ -952,13 +967,10 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>                  * failure is not critical. Scanning one cluster still
>                  * keeps the list rotated and reclaimed (for HAS_CACHE).
>                  */
> -               ci =3D isolate_lock_cluster(si, &si->frag_clusters[order]=
);
> -               if (ci) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       order, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->frag_clusters[ord=
er], order,
> +                                            usage, false);
> +               if (found)
> +                       goto done;
>         }
>
>         /*
> @@ -977,19 +989,15 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>                  * Clusters here have at least one usable slots and can't=
 fail order 0
>                  * allocation, but reclaim may drop si->lock and race wit=
h another user.
>                  */
> -               while ((ci =3D isolate_lock_cluster(si, &si->frag_cluster=
s[o]))) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       0, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->frag_clusters[o],
> +                                            0, usage, true);
> +               if (found)
> +                       goto done;
>
> -               while ((ci =3D isolate_lock_cluster(si, &si->nonfull_clus=
ters[o]))) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       0, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->nonfull_clusters[=
o],
> +                                            0, usage, true);
> +               if (found)
> +                       goto done;
>         }
>  done:
>         if (!(si->flags & SWP_SOLIDSTATE))
>
> --
> 2.43.0
>

I've been testing on top of a locally updated version of V2 for about
two days, and it's identical to this one. This looks great, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

