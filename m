Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2A5CD68BD5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 04:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5586B0088; Wed, 24 Dec 2025 23:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93546B0089; Wed, 24 Dec 2025 23:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74946B008A; Wed, 24 Dec 2025 23:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B68B46B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 23:04:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 452AD137950
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 04:04:52 +0000 (UTC)
X-FDA: 84256652424.22.C495EEA
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 70E8F1C0012
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 04:04:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qzy9Jz7E;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766635490; a=rsa-sha256;
	cv=none;
	b=v32y/ViK4WC/Mb2LiwfXkwa8mLPNzTX4cxWRycJ6/iDtf9J/hcrUfRZLPkOBnc3t6sWxZj
	QDDnGkWFT7gwkwsi/Qr4nAi9sFc9J1faOzcos3ChsSbhw8oh4640+eZ1TxBgyy57rHlDQS
	VfMfUhpFkaTsT/P9eergq2Rwj3wpjdM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qzy9Jz7E;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766635490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kl00HqMx4VaazQgD9Bff2Tl2HFE7SDfvTomj0ahbP0k=;
	b=em2FdXaEJ/dOGrUNh0MHKZP2+fwYJOEmSOS1wbVtxVgvSVfL0Y3CWdSOGsUmWOTHTWn34b
	h8mOzG3qoW2T361jdl0zh03MKuyYwUbxjkHVOLIq1Mf0qqwdEYvqLY9dlHmOt926rwYlfR
	Z8hnSZCw2z3a4CVrvl6OC66q0kcCVA4=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8888a444300so68700556d6.1
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 20:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766635489; x=1767240289; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kl00HqMx4VaazQgD9Bff2Tl2HFE7SDfvTomj0ahbP0k=;
        b=Qzy9Jz7Ex5T5BI370n9QOMhyv/7Wty9O/maMJJBFubMdvUV8vER4NMqManc121Aqtx
         986bdlflhQTiwKXpGODt7ZTpS4t9K7CFTag5+X+QJOUG+pFMcsRDo0NRwLyYxonPaiZH
         HaqsNI4dqAGKIMZD2jaP+GQOcvcwA5A8PdT+HsmWQWubpgQZdpcf+IVLgKGGZuEqEjII
         LobPe86OB4jF6ZYgBqkNIYrh7ydeQT4dSiUytkfdMsOydSC8eR4gU3FQumDzhQxW48BH
         3Gq40bKMY3zX4rx/VqJgm2btU3cPox5esc/nIe9GkAiXDfxE8YCLV31N2KY5Hb3baXh+
         3HBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766635489; x=1767240289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kl00HqMx4VaazQgD9Bff2Tl2HFE7SDfvTomj0ahbP0k=;
        b=YLlAWBC8SHCfGHeI6GSgRHJMrvjMy87s5NyBF1hnfXN+4x31lWMIo2TlIJfRT35iYG
         0SrTDymYYwZ1tKHh0rZps0wG4NoW2+2F+gSiPCVafH0ZJUGOJJcP5SWCdE+MORc9U+0k
         +ts7xEn6ZEw4l/t4Piwmuw/JLb0nSp0ytMKbM54lE4cos+mcjhYChFyF5jDPdrvSAYFF
         EzeeB6Y5zem8/2HVLOUCprUwe4+grrUsc/wv1lNy0Aq4QdYoubgZatv81jEssjednoFL
         +ggjgWoJJ9DD3ujCu/UoUMzFtIm9aIaFGZ2Ml6Oh5WCOwXc4uVvij3yC6bGYJ3xHmZDU
         gQCg==
X-Forwarded-Encrypted: i=1; AJvYcCVCBCLLqHESEAotIHIsV5EfrzUTiRiBYfQkkZ6Y6EPAs6oM806oFe0d/Geq2eKFNtSw5Bk20bZybw==@kvack.org
X-Gm-Message-State: AOJu0YxpHtd8RhnU0Esxu3qGw8PAynZgQm0BPP3/Cyx+7+BRjEZUBm9h
	JEVAFsLhus540q1DtwfIlTEBhh/KubHr8nvGQErh8SW524c+bkrz5EOlIo8GrsTDnP3VDgzmu9m
	pdmF7X1zGiJmuItuf5ipeodufxXOT1FM=
X-Gm-Gg: AY/fxX4sKTl9y8MEdmxxMBRfzBGe3mWeXLSM0CVLSQafhLb9qGimazZ21KBnHOZr3pD
	iLH9gGljUoESHbNmogVKhhfSvIHxbYeK/N7DdzYM5/YNkHTVGW2xFr88DU1BjV4KQblZH5tBSab
	hd9rzRRE6s6XF5f+K28Wcq2nDnC1Cz/poJc611mj3XBtjiSpQkZzh+rONLvLdFPby9Lai7TFXke
	lZYc7tSplhGRvLTstEwD30wLYrShPrt1HaimklVa3vLV3n7REMaZ+KvpZDM96GA1kaAGQ==
X-Google-Smtp-Source: AGHT+IEAFQ7eLg5leUSGDjbFiw7W16I4Ceck70tfbHwtYPuN5XQBIq1LCLMzyV25FDVPJfs6H7piw9xt5u/U3Och6pk=
X-Received: by 2002:ad4:4585:0:b0:880:53e3:3a2 with SMTP id
 6a1803df08f44-88d820415demr206322816d6.11.1766635489334; Wed, 24 Dec 2025
 20:04:49 -0800 (PST)
MIME-Version: 1.0
References: <20251224094027.65842-1-21cnbao@gmail.com> <aUwcV2HhtdiXXxfJ@casper.infradead.org>
In-Reply-To: <aUwcV2HhtdiXXxfJ@casper.infradead.org>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 25 Dec 2025 17:04:38 +1300
X-Gm-Features: AQt7F2rfYhGdFsxGZs3T_CSjHFfq3NpN8zqC1DCPy1Tq7UqBRQRvROTaKOrgerI
Message-ID: <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 70E8F1C0012
X-Rspamd-Server: rspam04
X-Stat-Signature: 1mzx564chtuhf5k3adaxuxqnjgetnqu7
X-HE-Tag: 1766635490-955873
X-HE-Meta: U2FsdGVkX1+9NDfqkrPoPF/azad/ZPM8UivBiKjGue0JvrXBBA9PM05FTDl3mkVTDmbuBZl1yClPsFV4bqthXgD/NBFELEffkKATQ9QBSq8rEPsvo/u3bR854VGiKiSdNWlZsN4nn+Jk43KpfuANQY/xgBofhTXHyC73NoViQkhWBUy1UEbDU71C77QhvJs8BRtGGn2N57llGwBhpNjX920wPQfIiq3rxoM3ZBnDjd+tO6hxl/0SbK86zvP2+Yhf4NNtUkXlHm8J2T2o959Bm2da8e6E6lb4TfXnHXfpybhup3XPczjps7eHPGRdwV+5zdjmGRPd3lPu4ZNOMXn1kz51koQOhShPe233vWm3MVvXovr3gOi0eUzKYaImrefeZ6Km4Bu78XnIeWsDbpS85hGWywgbXLwn3GYaHVl+hM2yXdIbfLX0/+SWhcbmhMyk3h+WCDgfy3XNbsEcWdoGufjH8DowNIMEUWOF6oS+uZN6LWWlJAi/i9ts9Cmus0pFYIenq3M2bWPlaF1BJ+GB25Bzdp2BdXCjCShTVsd9iSzoXeRSUUphoosNGbHhh4PGnvzYbM0eSYZftzmCJDF5MyP6IQuvnWJiTJrHBk5/2eUcxMBL/D/7c9AM883QBnksQTtXNJl427MGT41frG6QrReODi3IFWDaOswJz7UdQNFpMQ+OUhzqA9QKq7hJ46z0rmfF0pLzFGWKYfDGR35XzvQzEqeeUMlY4bNEk/5Gcnyj/YPTYXuKNzzD86DkJEQVKagDE7VWKwg3VSEiZJt+qCtrTvh+K+25MwOaQzTf5yFxw3S7EcQNZLU/GFRvUUN+LvDDtlnsRcBP0xUlPk0tmnfBqv1Q1Zp+Uc95i1CXBJYVnOPwUQDw0ZfjXqhrXCUzaatLMBRdM3YkVlplWLebYs5nqydgYAMTeLn41fkGDTpbLHql8I5d/I55joKhclcp80svEP4KHO+akPwIIZg
 fSE57caJ
 /kV47x7Lqwi0cIcl7VTo2pHRsoQeVal8M9Rftx1Ow6MpTCvlOuP1CiiNPDiaspWn2P/SF6Ax8BrijERhAhWz7/XT3uQlDQ8PY+5XNG/2OktiK1Xl6pKptbjTms77X1KQ9cyNi4l5SRHwodCVSDVI3PhdF12jeewPW6Zhfr9ENcvODyxSD748gSXlSxc2wlGmE934Qlx/AKCcsTxpyGV+eAfkC67nSVWgMsVXxGCNYRniBNzCBJrKwws7kIjxr+5ea8yYyyJJk/fZqlkZks0oe5UQSEZEdHy43+6T3KTo4CRLSawui6h7wM1mWbRRD73UXl/p2+2b0By20/2mVpljZEELkkeER1cr/fOXOvAD7keEDfGHbgmL39rdpskIJ4AaqQm2x5y69E5q1H3PedV5OaBQ5DiEd/o8QH100lJ8etLcoqrukH3xQ29fFvNQhffBBVpzT0qrUajXQxBdNf2ZIDSVZXMEvWvocSB1ckdcvZSUsQi6JrKqgAlmY5plyFpCJTFxog1d32N4PcWmFnY1ftJzog2Vwm47fHCCAu3zcAWg6R7LoMW3MV0drMpUhPg9BA6mHfMd9AFGUHKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 6:01=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Dec 24, 2025 at 10:40:27PM +1300, Barry Song wrote:
> > From: Barry Song <baohua@kernel.org>
> >
> > Uninitialized folio allocated in shmem_symlink() may be accessed
> > during swap-out, causing KMSAN BUG:
>
> This would be an unfortunate way to fix it.  The vast majority of
> symlinks are short, and we'll never access past the \0 in normal
> operation, so we'll be dirtying a lot of cachelines essentially to (1)
> shut up an automated tool and (2) optimise a corner case.
>
> How about this instead which delays zeroing to swapout?

Matthew, thank you very much for your review, even during Christmas.
I would like to wish you a happy holiday!

I am not quite sure, as shm symlinks do not seem very common. Since
allocating a folio requires a symname longer than 128 bytes (where
128 =3D=3D SHORT_SYMLINK_LEN), such cases appear even rarer.

BTW, do we need to migrate the owner_2 flag in folio_migrate_flags()?
If so, I am not quite sure it is worth changing the hotpath to
accommodate this.

>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..f3b3be1b50fe 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1636,6 +1636,13 @@ int shmem_writeout(struct folio *folio, struct swa=
p_iocb **plug,
>                 folio_mark_uptodate(folio);
>         }
>
> +       /* Zero out symlink tails to help with compression */
> +       if (folio_test_owner_2(folio)) {
> +               struct inode *inode =3D folio->mapping->host;
> +               folio_zero_segment(folio, inode->i_size, folio_size(folio=
));
> +               folio_clear_owner_2(folio);
> +       }
> +
>         if (!folio_alloc_swap(folio)) {
>                 bool first_swapped =3D shmem_recalc_inode(inode, 0, nr_pa=
ges);
>                 int error;
> @@ -4133,6 +4140,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, s=
truct inode *dir,
>                 memcpy(folio_address(folio), symname, len);
>                 folio_mark_uptodate(folio);
>                 folio_mark_dirty(folio);
> +               folio_set_owner_2(folio);
>                 folio_unlock(folio);
>                 folio_put(folio);
>         }

Thanks
Barry

