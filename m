Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A6FFF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 22:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3BA6B0005; Fri, 24 Apr 2026 18:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A636B008A; Fri, 24 Apr 2026 18:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7894F6B008C; Fri, 24 Apr 2026 18:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66F356B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:14:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF2C94010A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:14:37 +0000 (UTC)
X-FDA: 84694854594.27.A57FF82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id F2A9C140009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:14:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ebeeNruC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777068876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYXVqpKqsqqiZGebrYCLhyMG3YQpdcTmeTVKeiiu+QA=;
	b=HqqRcYBCX+ocnY6yGNN+NUMrgmNLfG7KtbVYysFhJxCQF96nCeOs5YcgOc8Y220/cB1cqV
	gVKl2YiWouXiWOF6aTsGq24HX0HxtBABn93vz4aMickf1qv292OOYL9Yg5l4Qvtyitq9Rc
	kWmd/qi2la1J6dfwPrnXtC+WXDXHLiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777068876; a=rsa-sha256;
	cv=none;
	b=dACi7bD6m8ASzMDs9FtEvKIkH5qncqu1YQm8rAkq0MeH76gDs/tM2PTWNbweBzWfCkBviH
	r3KZ5fFSXKpXIGO3NH8+E76AbCmf5qHDUJ66+5BcSvVFCRvXx6sYl1KyBBtGON3zBQ57FP
	sd5OyBl3pq3hGDu4kz1S4KnDnvW17pc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ebeeNruC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3007E600CB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC15CC2BCB4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777068874;
	bh=7JdhL4gOCZvGQazx56hjZGljg1fb9Dkq9mfDphKamYo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ebeeNruCHqbX6nkD2pzr4XPt8IKb4UipG0lOuJ+Va9eDLvdvYhL0cATWWVDPQAXLR
	 jsvAClpYPJlDsXIbBPtvUJSw7CW29GtICGU7irDb0NxHqS9YACVoWmCnCMKCGeygXe
	 yC+PkBfIce90uJ5+uLElNlsDY+lKpRlyC0QpD81zd2XxRilVh1xdmMSW0Nq+FpaqKw
	 SphJabamLzvqsfXdbObbhlOXx6J9gWdwImvC7sKhDdshg4TiciNe5lgNcXhwiMx6UD
	 oBCke1OIzIToK/SmTvC4dv4SzASOkNyCBTGT2WeCI06o94cQ3txqgqWZGgz0iK7Omr
	 rmBfZIViHcvlw==
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6501d242e3fso8130664d50.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:14:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+MderAePmbK6mwvX/0+/mSvy6sciCTY8MizWn4CHMQSoD6kG+Gxt2DhVjbWDphMKN7upV6bkTauw==@kvack.org
X-Gm-Message-State: AOJu0YyokCeOp/c8vLzxCgFhMCJhxifipI9/lvzzutQ44sW3nwNWv9zr
	ncQNpuTEARctcdV6O4wIUDKF+BThucTzp5bNBZOgjuamc5lhlK8GKBFYJJ8upjzFDeM2+oYKSSc
	EuEimuhFu7p5tnEwdK/0y3rh9iXCmf0gsssKjTOxbrQ==
X-Received: by 2002:a53:e1fb:0:b0:651:bc7e:4687 with SMTP id
 956f58d0204a3-653109adab4mr19721533d50.42.1777068874149; Fri, 24 Apr 2026
 15:14:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
 <20260417033951.1111038-3-baoquan.he@linux.dev> <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
 <aego1T9d6PVudYqj@MiWiFi-R3L-srv> <CACePvbVHgry4oeXeouML1YNscpuMNSXSnBY9wd-McDUar4tG1Q@mail.gmail.com>
 <aemF6D3Do9FQYUOF@MiWiFi-R3L-srv> <CACePvbUih1E7cypNwPE13Xf8tMzYG5sjLoPO0+Yt7V0uL4qt+A@mail.gmail.com>
 <aer14NAJwkJ_ZCP5@MiWiFi-R3L-srv>
In-Reply-To: <aer14NAJwkJ_ZCP5@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 24 Apr 2026 15:14:23 -0700
X-Gmail-Original-Message-ID: <CACePvbUbAY7R=ZLqMVT7KkVcbt_McRviMepg0TpdKkW1o9QUWg@mail.gmail.com>
X-Gm-Features: AQROBzA5QECQEUQIvZcsY84gek3BRuUn15PL2zCQ3g19bL4tvUaTYDPSs_Ny0lU
Message-ID: <CACePvbUbAY7R=ZLqMVT7KkVcbt_McRviMepg0TpdKkW1o9QUWg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, usama.arif@linux.dev, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F2A9C140009
X-Stat-Signature: s8iwf37pepfs8wy6nm1m6hzxq6z6ojoe
X-Rspam-User: 
X-HE-Tag: 1777068875-552607
X-HE-Meta: U2FsdGVkX1+4yPe1XKGU3omZnsJwj3bclkJXwwPZb4N7mudW+YVvSR8zLGA3eR/D7eY/uZSYo8+ZhN3i5KpjsnIHNvydMMXfzpxahOkvheSb+1xenVeSrcmxLsSeLMsNSO9oLKS+Q2h7ngyKiETn9tQFCIAsSKXRMXSdQZUQGX+VXPPPYE/kjsceTMxanDwpQUTlcsnSsM1+UstZaBfQtfokpEsvVTL0YlQlH3etXB++cJlRPiptTT12tEI0kD/6g4pMipBSbzBnE/XZ+DItafRBb9d/R6PdOd4bStpcWxBa4MaY6TvjxtrfBOVwzoX12WS5v5BmYvdvqGdycf65U+iX5Q9IVCTRHwfkHUA6db4O82aKLgFlqzmktruMa0iAG/uHWjsyoXoW3YJr9xGaBLY2ObIMexS3MPTRzechgRzh68VeTDCIN3xJViRVyiJLlDncUNVn322mictqKZuLMh+eh2+x3ElngtoVtBC+gVKnBxqHMbkiwM9jKbuAL+X8O4MH3bdqzhbz4w6bW+A65hBJy4j0pPtz8B+ZnPK7Q/8uxNr6AlbsjSOMNSJHiuKzMtZbTvLxsene/spdIcPoWvkjYQoeW1a/khAjb4cNI0HpZyAoKYIkZoOdgG+caCcNChnG44A6oEnhEF6+j9twP5X7Q4AkJGKsIdgqzPITMc3i2I7LhFJoBIBlSSiTAdgfgOZhg2m0W2LqsDzS4TWKpgJ9F/cke2newTEqTDzuPPrGRD4OuvCaVTyH3zyDszJR7iFUplbbTK2D6fmfgp6z4hha2f47yhjf8yohoKto2KbxCnfzdATFxC3wySMns1bK7/cf/+8WX9Qs6/GBaAflYBHprvS5LBFizmOxQQ8Zk8gH3RBlsMb2C47mlKF1IfLTf1pi562+GUdc3vfeKJ156IFPOP3r9quER5HJ8fqpzA0tQ5ZWIePEEvEM9JPQe/G4CwlmJjUtiOn3B20iPrW
 KyckYLt0
 GGyWYzZaqo70JgviRnoJ5QxVeH9BzyJ19edCINusAUErFipHWKKfTisSbi2z+ujaQhUnWK70lO7EGJlc9l0Rafij+N9QU1HD6vsqpr1PNoJKs7XF9BLxZmIq6RLUY32NkAtfUf1KnwqwKYHdRfyxHXnZQ2e5wxacPov6WAZXTSwpU3tX6asVQvLO9ZLzk+iRGeWN+CGVv5S2GsLCBGVy4AxmNy6ytQkdHgFo5NZfQ2CcnWBfiSid2v9UqAnT04ho1qYZIME9n1TY8PIMcTp5FjCWVcZHq4JyUeKzq8szO+OK9u47wHxaLeoWjfLneXJ5pW6KfgpIBGUb22vbxV9RY9Bnh3+vjhoqmhBR3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 9:47=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 04/23/26 at 02:48pm, Chris Li wrote:
> > The incremental change code logic looks fine.
> >
> > On Wed, Apr 22, 2026 at 7:37=E2=80=AFPM Baoquan He <baoquan.he@linux.de=
v> wrote:
> > >
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index af81fa212f1e..7644049a0919 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -3518,10 +3518,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, s=
pecialfile, int, swap_flags)
> > >                 goto bad_swap_unlock_inode;
> > >         }
> > >
> > > -       if (init_swap_ops(si)) {
> > > -               error =3D -EINVAL;
> > > +       if (error =3D init_swap_ops(si))
> >
> > Some more nitpicks:
> >
> > I think some compiler option might warn about assigning a variable
> > inside an if condition. I suggest moving the assignment outside of the
> > if condition expression. As it is, it looks very close to "error =3D=3D
> > init_swap_ops(si))", Some compiler might warn, "Is that what you mean
> > instead?"
>
> I personally prefer the one doing assignment inside if condition
> expression because it is a ittle neater with one less line. While
> it doesn't matter much.

Yes, I understand it is a matter of personal preference. It will
generate the same code.

> Here comes the new version of the incremental update. Thanks.

LGTM.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

>
> diff --git a/mm/swap_io.c b/mm/swap_io.c
> index 77aa8373c087..e2710d5fb44e 100644
> --- a/mm/swap_io.c
> +++ b/mm/swap_io.c
> @@ -625,7 +625,7 @@ int init_swap_ops(struct swap_info_struct *sis)
>                 sis->ops =3D &bdev_async_swap_ops;
>
>         if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
> -               return -1;
> +               return -EINVAL;
>
>         return 0;
>  }
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index af81fa212f1e..82d2c9b35b11 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3518,10 +3518,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>                 goto bad_swap_unlock_inode;
>         }
>
> -       if (init_swap_ops(si)) {
> -               error =3D -EINVAL;
> +       error =3D init_swap_ops(si);
> +       if (error)
>                 goto bad_swap_unlock_inode;
> -       }
>
>         si->max =3D maxpages;
>         si->pages =3D maxpages - 1;
>

