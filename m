Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 058F1C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 22:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9058E6B00D5; Sun, 20 Sep 2026 18:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD096B00D9; Sun, 20 Sep 2026 18:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831E76B00DB; Sun, 20 Sep 2026 18:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 636F56B00D5
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 18:50:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53DD51404BA
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:50:01 +0000 (UTC)
X-FDA: 85235635002.25.E2059CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6864C20002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:49:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nwr373SN;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789944599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMk7jaay0yUcgsKzFwtFeWuGD7mhNz4wMBMZfC59/pA=;
	b=C8V33hAdDDc5/zrb5lagpxLSz8T9n0BrMOAzbNlZwpeVYBjTHOuZQzWbevq3eaaqcJiw+F
	fRRzA1xyCO3ZQIdTu0nxsay7erRz4XrnURFbEfgILsX/dyxGTH2BitaxQqhOwxP9WjNURL
	aa1A/jlHLe/o1MqGbrceGhi/SVBfB3Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nwr373SN;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789944599;
	b=Q/xz1G0gigDKEN4eWn86btAyf5xlkhIt+5CKgGwTaRaj94luEnuTnIZPz8egbl40HqX62I
	ZCXWjSk1AdyBxyLbqilVyzuJrfeG2ork14pesoNZzXKZ8+5qoXDhpeiQ56TUAwtUtctGi6
	1irJHkl+/Mnk+mKrIhuHdNWkQDO196A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C5D1439AA
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EA91F0089F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789944598;
	bh=NMk7jaay0yUcgsKzFwtFeWuGD7mhNz4wMBMZfC59/pA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Nwr373SNLgDGYScjavq88LgEb5fyddf/ewPH30t5O/01C5LLWGrmxdCYxPdGY4nA7
	 l5imwIpx+J8wAvBy62eiOEGMfx1mCoQU1OOrlWBCB4wNgD+gkzjZKCy6hmoCa4YrWH
	 jxo9kNWdPnNSJYaCyFVaRu/Ob4jAy/70Rz8CW1z1yQyZLpzLXmPHBKm6rRdkr6SWS6
	 GOx3XpUcxIxTrYESHynifMvRqzmpA0IBWz+4tKuBWjwf7XjGIsvqUynyhEMQdX17Ry
	 5a7ntrBv4+6HckO0vRSBjwKzSKodI8/UlC82+eXHkzpwEYOgVeTCyJTHq7qK5rbViw
	 6HYXbPxKXr/xQ==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-6713d20d375so2018635d50.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:49:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzhIn3i2UjcIa67efBVZV7qeCbgdrzszNKPrxuZbJrjVr716Rs6XdaBaTEWlGFTKMQ2Jun2JNWCGQ==@kvack.org
X-Gm-Message-State: AFuF++k8xTVo9aHhHOOEIs54Wkf1RSMcxlgUjUrJFi9GNuvPjD6HPBHu
	2r/fh6sSk6Xb0j5Z47wDGHNUk40N5l+wDJV/uxIDhVdmvcEp7y/mcNMFSah1t76b66/tE9i3XKB
	3Yj1QmWenWjEZk/Mw4Lri4UK23OY4f9yAAVdv/QmCCA==
X-Received: by 2002:a05:690e:b47:b0:66f:c1be:84cd with SMTP id
 956f58d0204a3-6717fd8ee5dmr2897101d50.59.1789944597408; Sun, 20 Sep 2026
 15:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260918165642.1014988-1-ekffu200098@gmail.com>
In-Reply-To: <20260918165642.1014988-1-ekffu200098@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 12:49:46 -1000
X-Gmail-Original-Message-ID: <CACePvbWuLfu1Dj=OcmWVb=szC1W=rDpkmsrBOtjouWEnN47P4g@mail.gmail.com>
X-Gm-Features: AcwNN1UYc0e_xzOQI9EqMW35lm_YvbRGUF1mHBw6FnACM5oNTXxYG9NQXrOTi7M
Message-ID: <CACePvbWuLfu1Dj=OcmWVb=szC1W=rDpkmsrBOtjouWEnN47P4g@mail.gmail.com>
Subject: Re: [PATCH] mm/swapops: remove unused is_hwpoison_entry()
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 1ozb7zqy3rezwwfeurtnisa6q99bxfdi
X-Rspamd-Queue-Id: 6864C20002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789944599-345207
X-HE-Meta: U2FsdGVkX19FMXnwd+0JdyOiEyplBqZ1bjZtWAmKmaohkJ7+9nOZYZePNjvPuPvfGHERwmyXklNwjX2KW9OYfciqoEaOVnhM/faoeFyDSl1LXerrhP4Pj7ERjoNGuh5FxRoSysect/zIm73VF17c3FCmx8W83e3z7lS/z3JVrz3/7m+9VPNqY1SIa5nL+oiA0oL24lf8EDdwX6FSg2ZeTapHErLTb16Mj9rrs+SeBYAYHIQwgnOv2adGguYzUC9StvqrCSboX1bJO4QEhRfR4mruDpXv/Hck0/i+FvuEn0lBwnpEaYZsPqGPLp4nvjfEbmBmG9AkU/F2mgSep0mhdEvKLOWVALqsK3kwlUYXtMv+dwziXtr4I0ccfO98YVlRNMLudi43yI5Xka5Qe+4U33CjZYm2Iapv7xlX1x73xoYttELHDRyqnDImuJbf+NQ8E7EU7nOvx6DxTDvhWPhohmrvHMHaU1Q6ZUxdlc2mzMpEcpbylm76qceBaM7mIqMRtbcwWCteNi126pbPMLZ8a5aTXfeL33tR4M862xBKfXj9C1IAFUd5O92Xrix0x9QKxfy/n2T3VQmbGgEo8b6Md4F4eerL6P9hHnv6WggW1V1emO2orUunIdOJmzxDlikC+ulB6tg/R+rEGU8ViT0kk9giY8ksJYbzYbbUkeTfqmZ/CIbIrFwUA55pT17kzTRgcuwJjP+59+OY1k7AeeyyjPnCS8QL8+xmqJJabRvUxY7umUOQeKsMyoghsgr2HKylPHFvYPkGwAByLTXniyhAJrB6UULriPUMgzNGULOnSXj8LABAz5ZT+IZYF5fc/VM7FC3WZfmkEwqWn0cDjaLN6x6IDYpPZ8j17QkLIEJ4Bu4sAZMygzC40EUQkrScMZj7647/Qq8GkxJRRYcNhzkBh9WSatKObRQujjM5DuKRsXljpoBX3hfuPpajZ1rqL1njC2Get41zT5h1AnxFEOV
 1Yd+/lAF
 Hb7NebYJ6woUAMxLWqbhwDwsjbeOf/SmlEFmoe8wa1HluozFXslKJVDcT9Uh2uiwuSp/ykYEpmLcMsQXvjl9oD/gquLNE41+nsfpOt4tM5xmBu9wjI4Ut0jnMn+RZoLuQheqxynk5UOBOVwvIzENLOGbQprMj5U1TepAk4W8S4DVM+Vnhh9NCDm1ognelrWrzTmDTHYB6tJCudiP3TjaHtmH2FYHwJIVlUR3fJAcWXq8OBRxBMvxpmjdEc9IM73SsC6sB9wBQ/x7uDz43hBf6drQN5SDm8fQpipJ4So91WDw760mbXJ/w5AfNMKRwHkkG4eIcWGTZr6l/ZWryQMKN1/AA6Lluw+kdfg/jFwFnUjJ8rJv9MA1bZdvkDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 6:56=E2=80=AFAM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> Since commit 93976a20345b ("mm: eliminate further swapops predicates"),
> is_hwpoison_entry() has no callers.
>
> So remove it.
>
> No functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  include/linux/swapops.h | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index e7d0d529f3e0..603f9e3f909c 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -261,11 +261,6 @@ static inline swp_entry_t make_hwpoison_entry(struct=
 page *page)
>         return swp_entry(SWP_HWPOISON, page_to_pfn(page));
>  }
>
> -static inline int is_hwpoison_entry(swp_entry_t entry)
> -{
> -       return swp_type(entry) =3D=3D SWP_HWPOISON;
> -}
> -
>  #else
>
>  static inline swp_entry_t make_hwpoison_entry(struct page *page)
> @@ -273,10 +268,6 @@ static inline swp_entry_t make_hwpoison_entry(struct=
 page *page)
>         return swp_entry(0, 0);
>  }
>
> -static inline int is_hwpoison_entry(swp_entry_t swp)
> -{
> -       return 0;
> -}
>  #endif
>
>  typedef unsigned long pte_marker;
> --
> 2.43.0
>

