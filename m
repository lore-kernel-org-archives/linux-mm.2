Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE45C1061B22
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0567F6B008C; Mon, 30 Mar 2026 17:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F222F6B0095; Mon, 30 Mar 2026 17:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA3B6B0096; Mon, 30 Mar 2026 17:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C57AF6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:53:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E688E114D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:53:34 +0000 (UTC)
X-FDA: 84604081548.24.1F20CB4
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6D9EF40005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:53:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a4Ftlu67;
	spf=pass (imf04.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774907612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+800wh0xLadVVDgVQkWiz6t2FN7ZV0MqxIhhbbqBwMI=;
	b=0TJV9NnuSeqGtnZln7ANbn30Qt3HcmS8on+WH8ATmYP5jjGomOAzIl2/hB5RKHdQ5UhcRc
	RmTSEXjc5c/rYKMNXqjS96ABvPe+gBPcW/DLmZV6wUx7lsLoqN42LsYEhB3Mk8HR2nlPRK
	hLS20fiBzPYZ95CjXImA8eoUVTHeJ9E=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a4Ftlu67;
	spf=pass (imf04.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774907612; a=rsa-sha256;
	cv=pass;
	b=UycSFWDkQuKWUXOOEYS3P3xNCBP29i6fqj0P/Xq/A7yVsZd9xCWvoBR/ceqGu26ogV8LrV
	neulxZyHcg9lHlYO/3uxgfkbcj+Q9a9uPZOaswrThPbBphUafV5ZK9/wngDMGk6DiVLimw
	tg3IibEmSS5oBGYYfMHrReAMZvK9xF4=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2c17d152c01so3808130eec.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:53:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774907611; cv=none;
        d=google.com; s=arc-20240605;
        b=BCtUejGbHZqJO4awwApRaXUD9kb5cJltG1lL//G98hqMcstNoBs7qq16BYhHYsMUYw
         O9DMCFFvE1DuTkjt9+JjfKzOMhCRoaVTDpiZ+bbsJynXXqOjaqAHIJ/fVXUHu5FaW/Q0
         /vTKKDvZV4Po0zj5+QTVtuIlKNs/yH4H4Jh4MJqnEIMuWaLk/z0RNbt7PMrqeqXJpt8X
         cPIOebxFYstUKa2A2p1jpqxUgiYjQ3EVE6b5jaSxroohBFxxybHAtdby6vNeiXfV65qo
         RyDpdcR3aboxXXT43hRWNVNFabdYM8oL2aelxkAsv5kTOoyKdXef9qXI1ceYISqpIsJI
         w7Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+800wh0xLadVVDgVQkWiz6t2FN7ZV0MqxIhhbbqBwMI=;
        fh=CfTuLs+9oFTC+w1LRGRmaN3MxlVtD+jTDnRO37+JY+k=;
        b=J6dxU3zUsAbfgNloq87Zgix2mVQWga5qH8OrRlnDEMgSDConBOG7f1MCGaRf9rWNiu
         df0csKFNbUNtamEu4aLcU0/VSR/kA6oX+9z+l1f5k9N6TZ7RPTMdoFHI/VUfEvY1KDE3
         8NRbk2m2tv1vvPzpNFfDJaebrAnD5N7Ergx+A7orXnUOUF3K+nt8JluQ9DcS3pAjqP63
         N8+ilP8H4Cus8m7XFGXioMndF2dlzOxaJaGqAhtJ6a26WMwDAVZTRBhJFEcNtuLNfY5+
         Kcpcc/5ztiO3tx4FsKvHZLHBRvF+7qP1bCp/EYung6zfsDF+wmO+aRkSrJvqWTiW3nn1
         8+nw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774907611; x=1775512411; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+800wh0xLadVVDgVQkWiz6t2FN7ZV0MqxIhhbbqBwMI=;
        b=a4Ftlu672yT8ZWqJRAwcipySD3iB/IUTLJXLU0arK79VMXY7krB9geGd9A+opYoEHC
         YEHtI4/HdmgbO8NZbO/s9OBO4P8uAAEwPkZ6NNkSrVbTASVO7pHnWDf170ryErEOGQZH
         b3daXRwfll70yhU0U8hu/ZUZS2veRPNUmmXMSEA/rKXvp6zrICq+M+kyMIMbyt/axext
         Mrsq8ozXBN8AxwBDbMXHKqoQst70IKp7A+3yDEdGxj/9SYYhgSChXXTsIbuNTwRsYkh+
         vUCEUE3LG//wV2N8+BlNpTnvbHKvKC3nCGki9kEccXkjqmt9oH9Mm8yR+GfPaSJBZr38
         /Uig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774907611; x=1775512411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+800wh0xLadVVDgVQkWiz6t2FN7ZV0MqxIhhbbqBwMI=;
        b=bs9qpBKIJRyI36dpaDM+8xL2p2ZMoiuwnRewY1WBgm/JF7vFkMImoTvQJHbJtJxJKx
         h9u0qxJVRdJRVpZoVMYa9v9gf29Qs9V05wPydYzn5HIA5VRLtZdwePIFB9meC8tA9WhP
         WiWXFsxmrCsUix4b+xWMk9zL03qmSp0MWDijsY7eAjoM1EAF+j1zm9hJeUIsIBQdpBw6
         0DsEzJfl+YjQUPmDWfRanWEnhu9VxL8iD/t8+ln+/id9vFk5oKPlDB0t95Ayq2HM+yya
         vA+1J+QximKZHPH5gbkDWtIinnrhAKJa81yBEStuQIOnPBFCVnN7LnGbmIUKY11GJ829
         gbMA==
X-Forwarded-Encrypted: i=1; AJvYcCWBvaYvscWzGMrEPdGuZ18U9QolAr4CSVM2+mqLnxO0LDS/K5ANILTpCpiq6x+p2hL4ZxvJTS2qVg==@kvack.org
X-Gm-Message-State: AOJu0YwGdPdkDMkbhftvrU9KZiz95vn8Z8Ug/+/KV/Hc6iPaZhkafvg3
	V1B0yF/Av2BGMtuFpUuPGdZJs9PEC8rM1fIwHy348Dh9qiyLNpPeINzxa4SJl+Adv9jbbxBf+Oh
	2KC9fShTGqekRgG0Jg3hL2gAC8J60gD0=
X-Gm-Gg: ATEYQzy/dEEu9COeim8fVmzfB3MidRyE7SZaPIUZSICfXqkpMKPH1WEQ+jj/4kQcvjx
	xXNnFMwIsD7NUbYNeD0QVDu/XtplyuZZFGOhJobbfkEyYZ0yThM1rcet+1je9sqq/vnIcKAlOrf
	uMpKTzidQ1SwxIxclDvyQnGnqzk/1F9EaPiNRXUkAVCKR+0kLOcvyFK7n6bmOGFZQWVR2tp+3qr
	HgGI+EigpY2+3RTpp4CF8S1pRukjWS3qp/mHRvuLauLo9hh6Lb81a76IL9rqYf9oIwbTgQ9i8fX
	JNp1CA==
X-Received: by 2002:a05:7301:169b:b0:2c0:f15a:ecbc with SMTP id
 5a478bee46e88-2c185f5e8d2mr7310944eec.33.1774907611112; Mon, 30 Mar 2026
 14:53:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317014802.27591-3-kanchanapsridhar2026@gmail.com> <20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
 <CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
 <CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com>
 <20260330115141.997e29f96223da1e22c0f375@linux-foundation.org>
 <CAO9r8zNRcSBdBthR8Mk929pT2z_Ew_vc8_nLJns-2FygSX630w@mail.gmail.com>
 <CACpmpodFvA_DMmXBmgZfE4A=VnH3+0rVfmAr2qKP8o738qafbQ@mail.gmail.com>
 <20260330121249.fc2cce8d2fb78ff2c68d3645@linux-foundation.org> <CAO9r8zNXqUd08zU-br_sNOQxQ_GyNRzPfQS1YZxYnk1WnyER9Q@mail.gmail.com>
In-Reply-To: <CAO9r8zNXqUd08zU-br_sNOQxQ_GyNRzPfQS1YZxYnk1WnyER9Q@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 30 Mar 2026 14:53:19 -0700
X-Gm-Features: AQROBzBMXW7xVN_idGjhXJ6bHZU5OL9BDCXBq_y0IuWglGTlU3P3nWTPU7nGqSg
Message-ID: <CACpmpodKm=_UqBrRdG0pt=rMzy4CnAENhdC1nC-_7vtzB7cTag@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D9EF40005
X-Stat-Signature: 3tko5743aj6ishcatet1xmphiiaser1f
X-Rspam-User: 
X-HE-Tag: 1774907612-703669
X-HE-Meta: U2FsdGVkX1+ZB6E5vir36HrJ7w2MYcF/5K9nhI8JHDjfhlMqCQVjDeI2uW9dAmxXRPJlr58kf+zvh4iJen+zVk7xx/V4ZoHE51qKDbco93n2LnD8P0zJ0Lm+QKdAnwXuHdTABxrcVIs8N6xiNa2saRSurL6UX2LeGGK1DJKY7M5qu/VEqoBQGhHN7+pFdEyhqfa6FGyHn4CpF+75KbaJDNDm/lpOawimgUka3qyfCNhxSDt7erlbGF5iNrVmbnsQ0zPdql2YJ97j5cW9snx4gUtRCXE6da8rkoAQVh6WuJ040I7kw+G3gdV5SDBrfv1D1fvTc8O81bwDiAmvQpW4Bxspo73ts0anh6oyxrzAjOJLuCaHmk+Y7pwDhULB12l2ODy9XQ/IfePjkEE0JvilyAxuedCTjMttdKsSgbAbiar7C1dOAXoyy9NrahVCvEnjLOLs/zS0lRLbGFpuFp+2FspxDUaH6owtvYVuGrlmwDLtb3pmYwq9LTTb4gr/CEJr3gAoll+N81KDdHF18u5JGre8tDLGdPaNT/oX/wvjLWm/g9iby9yHe3VvTAf9+PN8WrEr14pgk4oci+N9phV0FBZFbrK7R13zUQi8hvRUYWBotfj69heBQtkOO4tW3bnarLu7tfW55jc2VLrLofLFxU+3AGaDpO4AKFOaN+O9DHIqnNooCRMVFy8QJgoW+kNdwmKd0yAw+s5y27AfeaH9tgynHFtns4LOtAZF9jBdPLxaM2iaBVq35OcgNp8D1u4vTR7mVBGCqO5p3OwgJWVZsWP/yPfJRzB0wqQ5vM7ouXWr/1sdGnxx+7zMKhGuN/nBi+Mdwwb2D9BSotxzmPGx50KZ9WdRhHdVGBySvFsuAqCKCochHKtnXfIMCDqvXa9Fq8aGAd0Go7jwgpWMrKGtJfoaM878XwZmdn98yLhX9niDnzTDuoa0yy81tj2+vEazQw99lapV9mOQp9JO4dF
 sIHl36jd
 E43AzWxt0ZLhdNNKuag2qof7MJfNwLyflkiWmD6/badcSSlQoPKII2lH08L1W+zYR4ZmmzHGKoR6+hqgUQs6ajEBSFF3nrFn0tvKmGA6yx7CgM2BPDUo87Q/KsulP/VRDW4KjsGY8EXHJ3grRVjSDKJ3VzdZU9mDQlWbWgMN7SfI5BrvrVRjDVqmktCe0XxLY5UI/pzKjB9HgWSRsr5TT41D2zVUxeabtPE1ZbAmWNVF/e0njPuD4l2erhhn8GO+XTwjFig4FBL7JNF0vi509AAri9llNMqgRNPmYZ34BuBLIpUw0bVMpuzAvcMdmnlYni1jiKyR1RYqcBb/m3iTCy7KaI9wdDj5XImorFpAaz9628C+CmLwQl5txuZTZldb+fWBKo7MgrrlqHzrakl2ueioEg965BgrlTXMyL/usUpGmpVm9J/wfFFmPcT+bqt386GC2ei2L9Amdm1mHGP1h+ksCdqbN3wohHzJES8fvl4IjRcoddYOiIwIYJgzOpphVscuHnqkHvEJvb2yLxvjWlztwmMnPRbE6dzwPjbWX2XaNeB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 12:13=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Mon, Mar 30, 2026 at 12:12=E2=80=AFPM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Mon, 30 Mar 2026 11:59:04 -0700 "Kanchana P. Sridhar" <kanchanapsrid=
har2026@gmail.com> wrote:
> >
> > > On Mon, Mar 30, 2026 at 11:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > >
> > > > On Mon, Mar 30, 2026 at 11:51=E2=80=AFAM Andrew Morton
> > > > <akpm@linux-foundation.org> wrote:
> > > > >
> > > > > On Mon, 30 Mar 2026 11:32:07 -0700 Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > > > >
> > > > > > The patch looks good to me, feel free to add:
> > > > > >
> > > > > > Acked-by: Yosry Ahmed <yosry@kernel.org>
> > > > >
> > > > > Thanks.
> > > > >
> > > > > > That being said, it might be a good idea to resend the patches =
(new
> > > > > > version for rebase + Ack?) to get Sashiko to take a look,
> > > > >
> > > > > Yes please.
> > > > >
> > > > > > hopefully it will be able to apply/review the patches this time=
.
> > > > >
> > > > > I expect so, but I don't understand why Sashiko is having trouble=
 with
> > > > > this.
> > > >
> > > > I think it was a transient failure.
> > >
> > > Thanks Yosry and Andrew! Although, when I get the latest mm-unstable,
> > > it already has the v2 patches :)
> > > Should I still send a v3, with just the Acked-by added to patch 2?
> >
> > Yes please.  Just to retry the Sashiko scan.
>
> Sashiko tries to apply on mm-unstable, mm-new, mm-unstable, and
> linux-next. So the patches need to apply to one of these branches.

Got it..

Thanks,
Kanchana

