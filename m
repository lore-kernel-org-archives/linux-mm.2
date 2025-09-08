Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF17CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291E58E000F; Mon,  8 Sep 2025 06:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2426A8E0001; Mon,  8 Sep 2025 06:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131728E000F; Mon,  8 Sep 2025 06:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F0C478E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:45:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83F9A11B21B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:45:07 +0000 (UTC)
X-FDA: 83865750654.30.DED73EB
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id A77632000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:45:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I4P9y2OA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757328305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8uzPYfPNYGeJvmQoJWthwwS6JgMfzyknVaJ66+yIXA=;
	b=rWbmZQmv+eBHOWaSaO0r4tkq3gTBfPM2AQTNPi7yYUxR7HxRaGlZiEJppSmSgHkBP3ia1N
	TiKI8/ntt3rlfyzYD7XsTUWj+O3/OtBujpeJ0VLsZi+BWkkfG9yPfnRr3McIOE9zH5XLCi
	11v5j/H7Lr6oxCS/UosrMnSieEyXqRI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I4P9y2OA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757328305; a=rsa-sha256;
	cv=none;
	b=M7KY1nRdiFE35CqZByuHpfx5hJX2JBp+aI8IDd+AP34WiE4shmq/O0ws7X1/SegNPk/Yjy
	R6ZdbRBwpZNGIS2gJSrgZeEW+Aj19hAVvd7bhc6fdoK8CuFTdyvpXbIMhJzsbRJRciA+qL
	DlaK4qQYq4TMxMBiueqUWUt9hTLt8zk=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afeec747e60so802800666b.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 03:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757328304; x=1757933104; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8uzPYfPNYGeJvmQoJWthwwS6JgMfzyknVaJ66+yIXA=;
        b=I4P9y2OA/o70V0U6Xkf0/w/WRcRDu+2yNRrRNEL9Mplf7PTGkvhpYlswH47RjDf+TH
         qv8MWaob5XgitPaVJSrAXLmfWmONDV62PQYVvv94OLjypf4VVK11Ah2a3Vn7i3xFbRFD
         wzz1hWj3+Q/Y7nViZC/fYbcL8vjuuIOE8nm/uANVMjN4MfnZHCEQ+BxKUboTOUNplo7V
         K8sALCVMIy/oyumCtg2jK8CnJZKK0WNoYWJmwTkZHbNkzMSjo/RhBMn9WrTZfC32nq1l
         YvlUTpMElKHf0NaPEWENbPWprv6pXPtbABpEs4Yd+BWLWUgcinFkVgi+9oXGifCCSf+y
         nJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757328304; x=1757933104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8uzPYfPNYGeJvmQoJWthwwS6JgMfzyknVaJ66+yIXA=;
        b=QC/E1fXNXI4ohIfp9gVBr0DYDg0KFogzSAn3X59K/P4UACHMmQqFO0w6x3yxbjP48U
         wWSg2Z2DinMK9AyY6s9VCeXwRVhTB3ftI86h79iNlp54oHm3POxNI+nx7w8DDiEaks5r
         cDCs+9Afew8S+bKKbIoIE67Mivt8/XeucATzc8SLZymj3Erayc7oWkz7Am1UfIBD1uTQ
         JpY+iLOKx6BFi48qxF3R8mKmXcGwuSfAmiMP0hTQr1aaaFGm1XuIUip8scJG8zJAf4YV
         VSlSNT9dB8wcYvqU9TzYefN22TPAfUrF1fcetl3JbYBiOUcWJncBYpQyVTVED+WhGXIx
         fzVw==
X-Gm-Message-State: AOJu0Ywnad8Ko2EnY1m7ukk8Jkl9qrfrUVhr4cksGLLoz36wMpczPwcP
	rx2gvUjeC0+hguiW6MXhK1uEYACzkBy8UFxxsS3eGDHty/oCxNpsSgrKzqvFY59WgqAiedV5JRv
	FDaaYqQG/5Mv1X65mGO8SgX2CmpUuc9U=
X-Gm-Gg: ASbGncuu0GI3Jt/pVenMyQSfOyzgppN1WD+u4y3AQIwFq3JyD2VO4axatcDKHb1NpG3
	AnX+ACpxSnBbcFwJC9oYdX0/s1L5YLqamDX38znezY+mOK/deuwZS+N46WEfQQAd3yEGbNX4FQp
	lMGaw+U4VLv4ekTnDRHjL6J+k+DgPqJVRjTLazfE1nudTekrkMbYMSip9AvT66xfkdHc2L/aojG
	w2cNjjmbyI=
X-Google-Smtp-Source: AGHT+IEhewhMF1EpxVTUIFmPOKbYonEWPpE/6YTG3sbgSQmH0PJZ4v8XEyZlCGfbHvMJoYe8Yg+2JW96OMUzuO27KoE=
X-Received: by 2002:a17:907:6d20:b0:b04:616c:d74d with SMTP id
 a640c23a62f3a-b04b0ffc2e0mr729393766b.0.1757328303776; Mon, 08 Sep 2025
 03:45:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-11-ryncsn@gmail.com>
 <f8051ae4-1b9d-42dc-8272-24a05741d86e@linux.alibaba.com>
In-Reply-To: <f8051ae4-1b9d-42dc-8272-24a05741d86e@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 18:44:27 +0800
X-Gm-Features: AS18NWCW8pRyKsBkR6B2COyqewa1UrnxjCbNfAp-Uy2-QjOXMA35_nPtuyLlG9c
Message-ID: <CAMgjq7CQSGAhah8xwzJJUOLYEEQer63ZERsP6W-JVDCt4mSFMw@mail.gmail.com>
Subject: Re: [PATCH v2 10/15] mm, swap: wrap swap cache replacement with a helper
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A77632000E
X-Stat-Signature: susnmmrunynxpzzij5chwh4pkk7bstxk
X-Rspam-User: 
X-HE-Tag: 1757328305-891260
X-HE-Meta: U2FsdGVkX1/4SoP2eIAl3CA+sgV/nkvB7ZjRVFgVXTNSFm9QKBMGzfposDCyQoNzqMB/rUGgdyAK/m18hTRhjEChsBswUgvq4EIa/00uCkDX4NWSlbrpWXn5aMDBzbNC20654w89OukId7u4dxy0vX0x+XC2sOHc9eWrZJXmuEZeJ2SdScwhnscAUbRzdHAK6BG0XDwOJN3+Ym81NOoiKSk9tTSFwecn+Ui4AFi8R6qyBDyRK9fR4rIOkic1XkCw4RhFS1pIdq4vwCGYAxcKH9hsPxysrfM6oNSelYUE0SMmu4qYgiT1y85DzVjA7el37Pkc/wQZtNqw7ekMhgOsMO12O60Zg04taueTxmkZg/tPHCyvhL0R6XHwCAjKESORGhsUMZItSxqO1URYGZpjeh9qf4QrBQ9Tt91XmbxY7liyoSUdpmxMOoeLOFSZjGTfDaDMpiMKwftk6cbujz1xU3NbUEQNT3CuCdJcEKmEXqgZHofpwPy2QjXG8FQyKV4WNWpC7E7hCDQYwnPciT4dxGcgpp9+umhdqXtyRsSg06B/hk68D2Mvr/FTa8+AVzeIuQ/5btPdkd4eHub2VCbO99R06NieeRsrFz+eq0HxBg8tzXOchEuXma9BOuJ6fCoZa+qqIjiS83Ub1MYODRe8jyXwDQgSDzq9AUyaJ1CaogXxKAJhK5SWSKwBHFe3K5CX2iv1AhhZc9HdF6VSfGRpDlcB6Yo3zUr5CyCJoB3Sm85TqaB4GnmT0JCKuBXJjbMKdLkv9W9ctxCku+DoK6/ZVI74eb8nSXfTcR9RIxhFPTVVSfacgLArCi232queu8r4Llj27jnxFsR+gaGYuvaS5oGUi4ssKDw+5N1sebNNFDbTdaugyE9GrEKrqfSJa2iOCYdEH4eFJwyOKrUJFOWgxxoPf+LH7zLN6jLuY2zC1CjYZjfatNdmOj+Brwcrx3rHyh6WfIzTRWltKBt7/WM
 /58apR4M
 6CKa7USuGyp2W1a2fTP11yxr15iMgifbXl22qrRPoSplujO3nsft00W9cpulT2Tyyh46CqRygMBNB6o6U5UMyLjVOsrsAn/u595ktBmC+X6nDCCHaGh2f9Ba/Tc8/JL/t/zJOWxayIbRm1jnayClaFcV+kI3hkw6FV/UkDmdtVXrG+sqz8GOb5usbzugxgKr+flbANpMWCsdi1WX6W/50KYgy6rUUd4FT7hx4H/hD/yIXYj36sDYDAuVk+3qpMY9oOAZBrqIUJaa64aIrHv2pfL19HBU+Xhl+2FCDEQmrsqLbPiTOZcbnVW89yhuN0jqeD3xm0BbO8/1aHH3InCUWFluTlXW/kK7TkYWtposEz9g12idFuxdLrhqD9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 11:52=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/9/6 03:13, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > There are currently three swap cache users that are trying to replace a=
n
> > existing folio with a new one: huge memory splitting, migration, and
> > shmem replacement. What they are doing is quite similar.
> >
> > Introduce a common helper for this. In later commits, they can be easil=
y
> > switched to use the swap table by updating this helper.
> >
> > The newly added helper also makes the swap cache API better defined, an=
d
> > debugging is easier.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   mm/huge_memory.c |  5 ++---
> >   mm/migrate.c     | 11 +++--------
> >   mm/shmem.c       | 10 ++--------
> >   mm/swap.h        |  3 +++
> >   mm/swap_state.c  | 32 ++++++++++++++++++++++++++++++++
> >   5 files changed, 42 insertions(+), 19 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 26cedfcd7418..a4d192c8d794 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3798,9 +3798,8 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >                        * NOTE: shmem in swap cache is not supported yet=
.
> >                        */
> >                       if (swap_cache) {
> > -                             __xa_store(&swap_cache->i_pages,
> > -                                        swap_cache_index(new_folio->sw=
ap),
> > -                                        new_folio, 0);
> > +                             __swap_cache_replace_folio(swap_cache, ne=
w_folio->swap,
> > +                                                        folio, new_fol=
io);
> >                               continue;
> >                       }
>
> IIUC, it doesn't seem like a simple function replacement here. It
> appears that the original code has a bug: if the 'new_folio' is a large
> folio after split, we need to iterate over each swap entry of the large
> swapcache folio and then restore the new 'new_folio'.
>

That should be OK. We have a check in uniform_split_supported and
non_uniform_split_supported that swapcache folio can only be splitted
into order0. And it seems there is no support for splitting pure
swapcache folio now.

Maybe we can try to enable and make use of higher order split
after this series for swapcache. I just had a try to use some hackish
code to split random folios in the swap cache to larger order, it seems
fine after this series.

