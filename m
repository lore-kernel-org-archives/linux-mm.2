Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C536606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lV8hE1XL
Received: by kanga.kvack.org (Postfix)
	id 309276B05B0; Thu, 26 Nov 2026 15:09:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0C66B05B1; Thu, 26 Nov 2026 15:09:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E556B05B2; Thu, 26 Nov 2026 15:09:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 021306B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:09:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2A5F160217
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:09:38 +0000 (UTC)
X-FDA: 85478360436.16.9095419
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 18EC012000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:09:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lV8hE1XL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795723777;
	b=h3vpwpVeVfyi8jKDknKk/+GHXIZCzn/xy5O9iJw9twGO7bWWLC+ZxdrXYowkA7VYyO7RIZ
	MqSBajb9Ox6HJufqzNi9gBJhfq0Wslb8XpW+L0IT4tW3X16nVd98mEb5830fq+DNHblxJE
	5sNeK49e7+U5bwKPQuKJdJKEbElYtX0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795723777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhqV5yNTeb/bGSfEg8Z4WR9+47g1ctbrNRf+rLB0iJI=;
	b=ACwdbkdrE2wVr37m34EILDwAOl/IzdSVP8Ctu7iOia9m0o60lu9jEoo/VBFi4EsuXAx3bS
	nHVquNY8cZX6tNakojH4DJNQudDQGNJ9/REoIsCw2qSE6ivtYgKTrqzjPqpS6iwE//l0mR
	YzSQhMCSrhJ1/eItw5kte+3yTlrV5N0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lV8hE1XL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEB4044DDD
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54241F000C6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795723775;
	bh=QhqV5yNTeb/bGSfEg8Z4WR9+47g1ctbrNRf+rLB0iJI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lV8hE1XLfBuin3LiFGTjhaTowSIa2OI3cPxF+o+uzy6D80GJI2/E3K0FcV8BjOLXJ
	 WqXD9UrZb5CcqDxSKDrXvaOgbsgGOzqaiO0gbCD65XR/0M9IzRhzvC7FpwXMs7jbTh
	 NZTtqpTcYjrS+VObwY8O88I+2iz54j6fdCujBLvGol8rbMwDjvcYyeWcVXa+Gv+uBU
	 KXzs8EL9E/WMevAtsPo63sKno2xnGrLs1kmZ2BuqAc7XPvJ7tl56ZuGl2vBapDZ1j9
	 idrmovlNezujhDZ5CrtQ4aP1DGY+xIh4R1ksf6PCYrTWpgCOJOSog8Yi6BoapF9OV+
	 ALvD3cXI+LPmg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so1332535766b.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:09:35 -0800 (PST)
X-Gm-Message-State: APuU4Z/zlqQBDwjz1+i7mk0nLIEElDSo3ti4n/K6iMj//upwbH4DrrpL
	Q4K5isjb86paiR8+KHkL27+yRoLAuoUcHugyKjCEYuxV8ucNRbL93EbaXxp6PqId+ynoS3O0nYH
	6fTbib/a5xH5SBZhuKeRKolLFzshK0x8HgRZ1jdaVIg==
X-Received: by 2002:a17:906:f8cf:b0:c50:bf14:8ec1 with SMTP id
 a640c23a62f3a-c513ab4d93emr1278198566b.33.1795723774577; Thu, 26 Nov 2026
 12:09:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <0d61898075921b05c626accfa34a60e16472b556.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <0d61898075921b05c626accfa34a60e16472b556.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 26 Nov 2026 12:09:23 -0800
X-Gmail-Original-Message-ID: <CACePvbWk-TK+VtiD_0ByM_pxXzyHhZiW=C0LB_mH2FtBXH99FQ@mail.gmail.com>
X-Gm-Features: Aa3M54rfv4QAGdHBq0QdP2ylbNXUTYqxGTt5VDMad8QSONEg4H11dzsHXoWD7_M
Message-ID: <CACePvbWk-TK+VtiD_0ByM_pxXzyHhZiW=C0LB_mH2FtBXH99FQ@mail.gmail.com>
Subject: Re: [PATCH v5 10/19] mm/swap: mask the off-list bit when checking
 whether swap is full
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 18EC012000A
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cdpk37ec4pggis6gxhcnqex91w4msr4h
X-HE-Tag: 1795723776-772314
X-HE-Meta: U2FsdGVkX1/6qLj+zjdTrAaWvoboELDet8EuVFpI8vtTmXiK80MEqKViitjijOZbKCb2dJZNXPxn0JOnKY3JdakUvPTwKdMGIWDDDt+GssUAFhL/9Mo39TXrN+8UApAqXgZsiwhGno1ddoAFxTyIebm90YAvRosgpRSpcPFBzi3GFeSrUOFs2zRonbpyT+buG+S9E8yrFsXt9hjKse5M/i7czyN8gxP8ICdKcH466dVcRcWkpAJNIdfD9gkHHlzXEmOQC5oJOr9SrhWCZxhcp+p6uRGwSV73tExfUHRpEwyM80rUL+3gflc01J5yfo8QPvFiOYvwpKCuIH9BwZx+eQgIHDB4VO9WXHnBGk6jVsvHMfpXhIP7bQMoqH6+WX9HEd5S6HKFSP5YevNlb3yrMv3U1uWQcjhPlQKvV4EOAfoduICDBdn5EXGOkjS4FgqVBHeiebZZMjk15Qu9CJSdKPtDIObzfAuHJImCnnvg2eEYM+3XgmeEqLGsdJuUW5iOCEfujovrlN8Op+lxyJVw8lxncmVU9cZ1VOQTykfrDSe9WLwWNNW70lgTCvWDtAvMrwNg04/WVkkS/ypzxP9kep9G4F7AF+pcVENqz+g9ofASgPqVmHnsaZTxYzkt21PCtatuRg3Bsi97maKm7uPOZo268LFXtAtHGS2PoLg8CTEvOFgOK3y+UrxrIZcP4hvtEE3PmZO+V1GcEgdF9QZJ/Lf7KwQuvZIJW1ZWWPo0F5IZ9XdEg1b0Lhi4OSODleQn6REiHEBm7/9WC2JAAMdL5jhx+7CjPvWwpyBvqYAPJuWqI7AGAmtqA2qjG2TosTpesXw48toUYY5AvGaXkDA/5ZSwYEIGp8RBBqCYJp7IkZyQ8Gqv48S8I9LqIMyxew0I1xLBVTR9bzwYyudmWqfJsqYRdkebpIngboeGOlQQKqrNdsR1o1EhtFYqgH3LCT+yhCiSFh/R6ulRoQaQJIn
 cn8+lvb+
 iG+S58ycZsVDppB17ZsoxD32//MSB0D394eVZOcHyIWZmWgegp6/pqJjkX5ntdyRwOvtkdq3WWck2XKGV/3TCew198YvJyhxEGZjrV05DdTs+NeYXA5SXkYSjmRU3lH5x0u1NOc7uhxMegfOLvHR5sGXUF69uWi6wRSFLyYopM8w6QSz7bH3AaiZcwXENDEfD/eZMRp0GaLKUjXfC49d1zoWC6kd1AWpetJfg88fvhe82ULw0ldjpmKLD7tDDobievCb0HPeazKfvB2/rY8PRHVM3pJuXC1t2GWIovC52hhcDrai2mzEiZpMPqOlH4yqONefzFQoDvaJI20fSNvIhseY3a6G78AfIzFyehfFwz5YOVuqvxfqoWMNN7SPYWNkW70zGV9PsEfEw/975AWY/IAUB1bt8VlOVxKhB5ctZtMGr6L8olG3rUNEBHTO5Gk7H7il8E22PbBKcMFXrYIiaTllAx5RRr0M7fQbqRipk4eYVQzPY6jRFGI1YGlsCEI9vme2VbgCHlSugpc7cTcFYC/FsI33O0eSbKZuY/VvHit2z58zjqG+eJhOJOrLwXP2Kmyqa6rCwlJCcb4iwJFVVOpBxh47pXE2dj4L/PXIhuLUKePsxApH3QPcJG8IPjeyD/aNa
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
> add_to_avail_list() clears SWAP_USAGE_OFFLIST_BIT with an atomic
> fetch-and. The returned value is the old count, including the bit.
> If a freed slot has already been allocated again, comparing that
> value directly with si->pages misses a full device.
>
> Mask the state bit for the comparison. Keep the cmpxchg on the live
> counter so that a concurrent free can still make the device
> available. This also applies to the existing plist allocator.
>
> Fixes: b228386cf237 ("mm, swap: clean up plist removal and adding")
> Link: https://lore.kernel.org/all/f53b388e1bcf6840457fe5041e989a3c0d0cc4d=
f@linux.dev/
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swapfile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 70913402a265..1ef5f1ead656 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1347,7 +1347,7 @@ static void add_to_avail_list(struct swap_info_stru=
ct *si)
>          * that updater happen to be here, just skip adding.
>          */
>         pages =3D si->pages;
> -       if (val =3D=3D pages) {
> +       if ((val & SWAP_USAGE_COUNTER_MASK) =3D=3D pages) {
>                 /* Just like the cmpxchg in del_from_avail_list */
>                 if (atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
>                                             pages | SWAP_USAGE_OFFLIST_BI=
T))

