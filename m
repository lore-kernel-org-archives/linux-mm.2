Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC0F7EE6B69
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 22:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F156B008A; Fri,  6 Feb 2026 17:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD526B0092; Fri,  6 Feb 2026 17:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBEA66B0093; Fri,  6 Feb 2026 17:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD0D16B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:16:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38E9B1A0341
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:16:55 +0000 (UTC)
X-FDA: 84415442790.30.5508862
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4464D140003
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:16:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dM8Vl5BY;
	spf=pass (imf23.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770416213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYOL7E/u17FU0GgtA23D0PWn1tX2SHWaEdS0MvMslVk=;
	b=F5a+fnYh+sCtRwroWGhhiz05pJRc16GqWvQ5TB/y+i0Ym75zOrTlk+symJdPjnbnbNvnhx
	CB0mPEbxVlWJ3ZdEsD4XNhYXvYycvPY6If7ZFny9V63qwGLFgioe1LoHbKlEnDvEC3gQiu
	rARPECoDr/JIMxfK9mU7aWYHIRGUtXw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dM8Vl5BY;
	spf=pass (imf23.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770416213; a=rsa-sha256;
	cv=pass;
	b=iHhnQcYN+pw8My0mugKi15pdV/WWoiwZqmoENI4lN2X3EA7xB5rTKZvW+jXwpp40i4sMrk
	RAUnOxD9b+nJixD8a7zL4octCyS+CzZkzvB9hKBqxNXNcX2OtppKWVScewh2DV9vtfvtPz
	fiq7uz3WSSlrVgeJcI7/eMZV/KP6E3s=
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d1890f7cefso2257672a34.3
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 14:16:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770416212; cv=none;
        d=google.com; s=arc-20240605;
        b=hvuRIg7ZyTTbULZ3j0pP2Lu3IT+TQuniHifblPOi5RqdKz1HK/K+Nk7tpI711SrfsY
         d8hc9XJ8c0+lzSYjPdj6Q9p6/Sd81OjQMZ+ob8JnGV+n1nMxqGqpshl7VKUse4T6DoLV
         MksB6IE6r+1NUkwWnZZGRhNBrJzkFRBOz+m3xfpLpEFTB+MCKRuL0G+rMBXfq1kr96IP
         iMSQ8s31PHIWMvSGruGLqlPIwMk8wrmQ8/TXXKwooSap2WqZWlIdedQHmTeJytu7k/fa
         q3A11UhYhqplwDuQrCqQBVgK41EcNAFGFjuGDlc4UeAzbg3ejbrc2LlGqB13RymoVH56
         Fk+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TYOL7E/u17FU0GgtA23D0PWn1tX2SHWaEdS0MvMslVk=;
        fh=Cnq3kVpcE0EnoEy1VVc60KiiG0OIyGC80gYVCYO3s3g=;
        b=EQHlf/yu/pR1ezAXEAATHDt8BYp3x7TKtYNSqppSJ8/jMvw5leALHyyazfU/h5TrD3
         /psRrVoQxuyKHCildNodxgrozkql0EdRVlN4bTw3VYFd9xZIxhi148QKF54cP9tWkXzU
         YoEhJMUull+9khCx/Gb6DsMHlZlNOAI5qcS22DTMXkBOM0MVvUUX2yEZTRsG3ZmenPZu
         Narm71l5CXZQUBUmHpG0neqOTXizOHsN2zy9wm4Zvg3gRHZrpCBLRUnM+Dd05dimAnAf
         Vi9Lc734fq0BKediZ8EYsqrrFq8JsXFANyCXaY/AJeTW10wju8074cKoaEB5HOD8DwgT
         TShQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770416212; x=1771021012; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYOL7E/u17FU0GgtA23D0PWn1tX2SHWaEdS0MvMslVk=;
        b=dM8Vl5BYr6Itax2yMYG2uCA3v55fV1ovLrEyMVVYiqh4OCliZ9UjEul1XdmC8jh8+v
         kLGL38vFMBPckzm8+np7XtgPTybHl+RY278Bjy8Y29sqzBzIVoU/ivYzNxNy7qpN5bIt
         91MvQCBwEF8/NsKk51nwn8lsyOrySvf3uibLv+qxJE593WURQ84GC15mZsMOuc7ptIQe
         uUFZQjaLjUHpamYUifSFZeMGKVQls3gknRjSxft+0k0vHOqfhduJ6Hu18QptEDEusJ7J
         B0jRI9S97z9cvgxjiifYoItumyA3qwvDr8bowUalHNVsEdlq5qOMSufIvUj/u07BU/zJ
         vZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770416212; x=1771021012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TYOL7E/u17FU0GgtA23D0PWn1tX2SHWaEdS0MvMslVk=;
        b=xFFQm4RPTugk298Yp6MiGEYG2XXlFeNnTUlCU87YaY9Tb2oc92xgWQ+itNsalJYHn3
         dht6/D461YvB5rhFTYmmZL6cB3k+iC235HRA4W8RDqvsrZufbYVJ5MVajHJiWoxFqVbq
         oZJ3DRHdwBenEXlFYzI2CujjksZKIqnEhvUZHqVvSV+1PLYr2CiCfD11cTrvzZFn54Yw
         YS7aa9yTS785Ozi7EDv9xK4Afyv6HlN1VdT+BtF8XsurL5X+gHT7UqqIPHAdyZO3q1k9
         j4+Pp/Oa1ksvJkfa9NFzTpTSDo01CEitmgRlU3WOXSIzZx0ZW+maRe//Mu7j1i7BTZSj
         eodg==
X-Gm-Message-State: AOJu0Yz4zlmUE1DV8MF8EU08AAHBWyO+4LZI6izbnlF5b9fmJDWerjzb
	guW+zKiU6dsVGacCgayQ3aTmTL8RZ7kDakwUqbdXnEdFpf7lrORJ0sIaQsAAJKgwsKc9j7uHkMl
	A26mb81tOsKCeVCh8TWB20WwjzOI++zI=
X-Gm-Gg: AZuq6aI5N3Y4XWwfnQtZTo/lUVec2aDrKua5v2oswawdYZoXv5Ym4rdJjhwwsIu8HWn
	gUCCjMZpaG2F8f9l9+sSXGsn4ZBW6fjqijg0Pf6l3/CUUMsSnDOWuJ5HLUtnHC+yyqiIHQKWmVh
	T14K1SqSkcuO7jX0dhDMuq4xinDf9zK1rc8WIsvex8dUt+pf5KdN45EK0eIApgUtTFUw/oosS3w
	mH6CTEfccgEZHSeFLLOtMFWHjw9VLRSKFvG+wrcUvlFNtgf2Ot/937/qIM0VbVAcRi2Bk+KdQ==
X-Received: by 2002:a05:6830:2813:b0:7d1:4608:a2cc with SMTP id
 46e09a7af769-7d46440d800mr2362725a34.12.1770416212221; Fri, 06 Feb 2026
 14:16:52 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com> <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
 <CABXGCsOMzrQTsByYraNby_MXnTuYBNt2vbWu65KCGX6bmi11iQ@mail.gmail.com>
 <F36AF979-5BE3-4399-9420-F41A475EA87D@nvidia.com> <B6CDB0B7-CB9A-492E-90DA-F8D7E3B037E1@nvidia.com>
 <7C7CDFE7-914C-46CE-A127-B7D34304C166@nvidia.com> <4C3D8E3E-D9D6-4475-A122-FA0D930D7DAD@nvidia.com>
In-Reply-To: <4C3D8E3E-D9D6-4475-A122-FA0D930D7DAD@nvidia.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Sat, 7 Feb 2026 03:16:40 +0500
X-Gm-Features: AZwV_Qhquj3d2ADjld2_kKiioGwgM-D9iJpddB_7DMyoioUMQfiflE1Knsnij1U
Message-ID: <CABXGCsP2z6sbf_FYZjdxyLhfJZEaxz0_WrEeteS50GLyU=KQGA@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz, 
	chrisl@kernel.org, kasong@tencent.com, hughd@google.com, 
	stable@vger.kernel.org, David Hildenbrand <david@kernel.org>, surenb@google.com, 
	Matthew Wilcox <willy@infradead.org>, mhocko@suse.com, hannes@cmpxchg.org, 
	jackmanb@google.com, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4464D140003
X-Stat-Signature: 6ngrponbwx7cuna4w5rnshza1ijbdk9i
X-Rspam-User: 
X-HE-Tag: 1770416213-213987
X-HE-Meta: U2FsdGVkX18B+BhBezzILGphHLT5IkyoN9NlwJAsyYO5MU6h1iN4aRMNRJssbxi1VVgnFOM3BCvmKtFhzVwDN3N6SQpHnHsjMIbEzMEUR6ExGITU7rlMPdkCoJU3tO2yWDd0CVK5bvblI/9I5siSgRE3AaYzCtAMuQpH7YsVI8MmSyehxyKuZkGoac9+d9fgTchfHOAV6taEJuyDCTm/rjl5X3UAug+FuT6C4sloH8akYRbUpknbnBgBEC+3TCJsZFomBX/NzAe/ey0H0Z1xey6GiU/GN6LVJSBvWvm960hXsQBuWBvhymbj9rsP56kHCXW2Q7D4XyG2nc6pgRQzJV+XbdEHLa4RB5289L+HndJjDixu6EcpBWb4nDQuUiZ7gDcekGL32aEn6GUOOg/+jNX5ts6YQZ31T9IiZOTLqAzASnTUJN+gxNSLew55bMe5fcti7mDjRoTWsFUm0s4pdKoFDpDKM+/AMeiSq2S+Ja95GBO873s2EAs6nDWzpoZDHFSWwUlS3U0VYT7OZxOwsFf8ogDnc476ai9HVsC5JtPm5YATK5/Uj+yuY13YIC5zDwiQfYQTJRI30iAu5awKcg8HJr+2iuOX8ClePZ9IxsSHe4QT91m3uN8QHLyEGfg5DVshIj3V6bBN2tmxc8dVJGvojQpfwEgnxXg99wVfIGJkDCdx4tOAxlnb8VshSZNIPxfYhXdZobYp/o8vl7fbG5akDPV29E9j1T/evpe2Gqn/VQGO/bCEyzjO4GrjQ0RXdQaLUTu453sz40k2c6blzG7ZuYPBmcWPx1TYCM6NsO62ostmm5QWUqcmclexwBFU7kAlcqmsvhDe2msyxLxNkCR93LTnDc/lY1fXspXTj2wuWWNQ73lx2jnJXWhDO5owDZ5etpSc5gfHHYjmYev0A98YWNKvXL/kSg1hbzcoyG7scjS7bEz7GHoxpGc2kRdBLVj+P91YCFJigJ9tWJ4
 0OclYxeS
 sh2oVcI6Znnsy8bTvG0k1+/aN5eI7enwbwMRPKTrMY9o+L3aRLb/wItzrjM9eg/Grk0H2KKH2ZjPb7utR3ebYdr85/vmBtpWIes3W+TIa6+CNm9xFGIV7x37HI9d8W7ht7G8FfIxBWYIdbjiNMevpRB6iuHsnUceVvtt2TDfmMRUg5uIOBC9jDkNilp4xQK0l+WPPJn8NCEKFTrLYngHHuuqqbl1Q03ieZ6tD4rwoFgAFGMmKTy5icIyVGVZUk8iSI6jmz+3rLp4IQsjdOQgovmEegN2wE8D/aFaM900UpYIZXXvO5Sq28g1SuPFSCOyY1SlvUoSPhK+RJcUpx0YuzCXv2OHA420/s9SWyO8GTeBoD1p1AFrRElAnwYyw8t+vRecimaRyhvaXlnlAAmgQaVXw6zChiJjuoUML/ZCgo9PBkIKDhec/ZJ2tCPOVC2NlrOt9K3sBHPoEVMFsB03tyx8BuY08pJbR49PGRulE4AW7wOgiWjhKCbXaIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 7, 2026 at 1:49=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> It seems that I reproduced it locally after enabling KASAN. And page owne=
r
> seems to tell that it is KASAN code causing the issue. I added the patch
> below to dump_page() and dump_stack() when a freeing page=E2=80=99s priva=
te
> is not zero. It is on top of 6.19-rc7.
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cbf758e27aa2..2151c847c35d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1402,6 +1402,10 @@ __always_inline bool free_pages_prepare(struct pag=
e *page,
>  #endif
>                 }
>                 for (i =3D 1; i < (1 << order); i++) {
> +                       if ((page + i)->private) {
> +                               dump_page(page + i, "non zero private");
> +                               dump_stack();
> +                       }
>                         if (compound)
>                                 bad +=3D free_tail_page_prepare(page, pag=
e + i);
>                         if (is_check_pages_enabled()) {
>
> Kernel dump below says the page with non zero private was allocated
> in kasan_save_stack() and freed in kasan_save_stack().
>
> So fix kasan instead? ;)
>

Hi Zi,
Thanks for the deep investigation!
So the actual culprit is KASAN's kasan_save_stack() leaving non-zero
page->private.
That explains why it only reproduces with KASAN enabled.
Looking at the code, kasan_save_stack() doesn't seem to use
page->private directly - it goes through stack_depot. Is stack_depot
the actual culprit?
Happy to help investigate further if needed.
Regarding the fix location - even if we fix KASAN/stack_depot,
split_page() clearing page->private still seems like the right
defensive fix.
The contract for split_page() is that it produces independent usable
pages, and page->private being clean is part of that.
Other code could potentially leave stale values too.
I can share my .config if still needed, but it sounds like you've
already reproduced it.

--=20
Best Regards,
Mike Gavrilov.

