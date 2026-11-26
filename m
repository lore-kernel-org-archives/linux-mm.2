Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7571606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 05:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YoGC8RJg
Received: by kanga.kvack.org (Postfix)
	id D2B4D6B05B0; Thu, 26 Nov 2026 00:55:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC196B05B3; Thu, 26 Nov 2026 00:55:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCAC16B05B4; Thu, 26 Nov 2026 00:55:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53E876B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:55:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAAE21A032A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:55:05 +0000 (UTC)
X-FDA: 85476206970.10.5B13765
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E495140004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:55:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YoGC8RJg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795672504;
	b=TEV8QF4MxM3rE39bc1eTmFUKYEhewKPf2G8TUHxGnRUpUUedDezCWBUF7URcR4X8TU/9OO
	DkzmohUEBRyEEPhwcBeR7QjrPZcGYiWzphEc9UVQ9fKFYa7aEGFYfrblBoU0iaOsmNopMn
	M9NBpaK1LQX/jxHkssmrsAfz4JWB/ZU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795672504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsXnkh9rZiup8TkTxbsw+huciahwayKl9nCe3uqM0fY=;
	b=w4eAyluwTet+CNsQzdMDP+/5FcANyXgertES5B2BOcWXNf8r3kouJZR3uB7+9uj0rmKT1l
	i6d5bYhHQDSvP8yqMKRe+FeRIDJzwQJRhoO0KKWmSSGhUwoazJZaamFbogEVn9x9Bwvf09
	XbuFvarP+Q9vxv1ogLumhsbk4IfSpdU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YoGC8RJg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7917661B37
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9581F000C0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795672503;
	bh=SsXnkh9rZiup8TkTxbsw+huciahwayKl9nCe3uqM0fY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YoGC8RJgRQg97KUL43XIUZd7vkdWSIx8mHm2/nVy+5NKP2V85aKWJo2lY7UHp0NW2
	 k+4bk/jdfGn7IpwdOSlaDvjBwWah95cF3LGdS9Rjdj0x4dwm+6kzklyYyC3aYxjZL9
	 0qcNHO1ccrTsCz1iT9EZFJJPjv3P92efEp8Xc5KdG4KMZogwmBCz+Bye4cVVzuxzaw
	 Ju13QKZACtntb78tA84ElhxPF98vFYQEJKELuxDCes4jvfwcJ8Eva5N/gUFc+cmD54
	 f592twGkA6fFWJkF+Bt286N4k8wC9n+viigOHodU4batTbhh7MjG+soKmHq7V4fUH7
	 XrKemJO72Wpgw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c51bf011392so108037566b.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:55:02 -0800 (PST)
X-Gm-Message-State: APuU4Z9TJnn82rDDyRqRKeSbfSDO94BPjjjQ0olBNfGIHwV7LxoVnTp3
	hiAx/oNXIGlaVrkLUeVX6Vn4J7NDNVch5lmR93fu0OXMnIhK2LkwH2//ZHdj/9IzsEdkaF7mVnx
	HgyOy47sCRRel2f4BjFYgiugmG/IbQVglp8ABiu3VoA==
X-Received: by 2002:a17:906:4fc8:b0:c51:ab6:1c73 with SMTP id
 a640c23a62f3a-c513aaff9c8mr1746636066b.23.1795672501752; Wed, 25 Nov 2026
 21:55:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <9f3715ab29bc9ee4aaa1bb92bff47c7584b73ee7.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <9f3715ab29bc9ee4aaa1bb92bff47c7584b73ee7.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 25 Nov 2026 21:54:50 -0800
X-Gmail-Original-Message-ID: <CACePvbXWL-CHKiG6hw6vFKbERDXLU_v3mfi7V=6hbaW1y8hs8g@mail.gmail.com>
X-Gm-Features: Aa3M54oBQMzNvzYM2e4PD29_5XhYK-wobZpG4mQp3FDlOc_DSnwaHTsE7U41QGs
Message-ID: <CACePvbXWL-CHKiG6hw6vFKbERDXLU_v3mfi7V=6hbaW1y8hs8g@mail.gmail.com>
Subject: Re: [PATCH v5 01/19] mm/swap: remove unused parameter for reading
 swap header
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
X-Stat-Signature: ctd3q9j56d11xmhtze8bobkqwbqtppxq
X-Rspamd-Queue-Id: 0E495140004
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795672503-273991
X-HE-Meta: U2FsdGVkX1/aFDwLPY6pMaC7Tf2nhgTPMz8eN+LU5uazGoR6HhniDnlXKhwPEka/iBJXu6UpPEFIxFlxKbKEnCtf0zm8US2EhA6hEinHKSbKIokH4M2jaish+e6P+a8e/qYEUrqvFqL6I0qouTix6SQ63HkSCyqOs0sndqwmR+51C5L89vEQL5R9MhVrdODgBJoFtEhW54QAwGJTNeED6x2xWNJ0Zk+6tbsZE9OIvxRsB2fNuKX9d/y0se7eLrEBvD180b4bDIu0AdcViRg0i/EDUW9CKXcEzoHsxe0GKZNSLVwpPCz3FNMzdxX7nH9mhBJZLQPE4PZLaPv3zfQjLP09OCfasr4x7/w+4VyFyLDUeSHHU+TzTa4FE7MNFQgc5AuQNldDkIO9AmiQBfEyiKpTHTZdGUu0RL3/S/BVq625zzX5tQoWSwFn/MaTJ7//q1FXJVuV9I3pBxCAbTr5TkewjWxWm2455QAibMVyKYzo4ky2GlWxum3yGVVV8Lk9MsLpkrCiBWSUPvM/Ubwxzq2NvLrSutQ2LCi8oXLKBkqf9I+ma180kABhztH8CrzOpuexP2twyXvadsDy3g5gGMcFMq2V3Ddn92MdtKPLx8EFl0r7anovN61Jr+gzp7LkREmUDUGzClh7xghQic09sz+TtsjrcJsnh+P8+BieAWcCEdkc6uX7RobMqXD2E/9rWU8Y5ja3m6QNUuIHRTmyDzORLpL8BVp5WFM9BAsJegghBqgQiRJDoKsrEuG8jglGqehKjwnp/jdY+uShuvfXoPdvvC3LKN0u7su8aDW6woHxXhMVbwv10UVylid3/5/EGJA+R7klt8LQWYVztRfeUDIJoFPftFI1bEvs8tU0rGX8iVpNGoCFkl7aPGR0HMvCs6vqJ7bZrteOzYlBWt0O58V+YFf6b2wNbT7biLzYFwkFIj2p1WC4ciz4v7THhZFRXFIte94dKIHsdhGuUN5
 KjBoUXa4
 YFDfV0P6W1X6JVFOgHy6WmJ4JGMYlWlNlrx7O+Jstyg62Rbw5wnRsYYlR5/dxmtrL/v1WXI4ZlWAgYX5F3R9Y1ePsWTqmiF3MGllg7g4cBT42MIXP4hEqP/vODrjsK9M/4lYKNutg40woEb4mv22iwh7lf/d2FzSNe6PQSnzjQstNedhcAvEDTs8hedoZaCMceghNtuDxN5fLJHr/2x3v2v6PzDc2ZRlqNxo114uC3jwIDkdUyDVcOMxB0NSKIYe9V0OC29q1xXFLjB9xI9Pp21ezkCu7wDFvLy+ZgR42cJ5NGRncNPdXTaGsFYI+LdUtixHAAxCCkMaGVtm7XIUHVlA3BYdGv/78+KLcXkynVJ21Gd07AnFo5VExgntVs4qlfInviqkGiZSDDq34ZisNjL3TgTG526HMlGMQzMkLk59ZtZGoxxgKTBi8MSQKUFqpeb8OlE8H9eCnJ9S0oFtrEI8BtumT70vnLBclDUy1vSxQO+iQRuGYHH2DyV0EOcYsCrZAWiwICd5FSuVW24suuJajWSKlo9MEAwhuU8RPI6RwxKgh5Jo8J+A1TR4m74CAnWnHbMZb8uNAjtfGOo9wE+3nphqVbKDvcibHTsP16JTDZO2AJbr82ShhS8/WxjRx8EuJnBewMkOGAfJdc0t4Oh3bcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 6:16=E2=80=AFAM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> The swap_info_struct argument to read_swap_header() is unused. Remove it
> and update the swapon() call site.
>
> No functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swapfile.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d59fa8220862..c06f9f532e74 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3630,9 +3630,8 @@ __weak unsigned long arch_max_swapfile_size(void)
>         return generic_max_swapfile_size();
>  }
>
> -static unsigned long read_swap_header(struct swap_info_struct *si,
> -                                       union swap_header *swap_header,
> -                                       struct inode *inode)
> +static unsigned long read_swap_header(union swap_header *swap_header,
> +                                     struct inode *inode)
>  {
>         int i;
>         unsigned long maxpages;
> @@ -3863,7 +3862,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         }
>         swap_header =3D kmap_local_folio(folio, 0);
>
> -       maxpages =3D read_swap_header(si, swap_header, inode);
> +       maxpages =3D read_swap_header(swap_header, inode);
>         if (unlikely(!maxpages)) {
>                 error =3D -EINVAL;
>                 goto bad_swap_unlock_inode;

