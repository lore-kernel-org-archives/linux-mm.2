Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B5DCF856E
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 16:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649136B0030; Thu, 20 Nov 2025 11:03:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F95F6B00B8; Thu, 20 Nov 2025 11:03:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F216B00B9; Thu, 20 Nov 2025 11:03:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 407036B0030
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:03:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 620569079
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:03:44 +0000 (UTC)
X-FDA: 84131455968.22.C6CC353
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DB521C0014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:03:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yg76wlDt;
	spf=pass (imf18.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763654622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZoJ5T7qCxoqJ0PzPFIxBpO8OSKGlINQNrAGkZu6Ryk=;
	b=ueNm4Cn9ndO67CWVw5SlAahpCgR0sJWptTQN9qZGBacKor8j4bSGOiW+YqB0ig8yDDiLPH
	KNS//1EFA/XIM1L0fbZ2X3ItX4ShTsDEpKjNtEKZyzTETQcb5FnJ/QcGpKETmuQFeLam/4
	+PXhdz+b26xW1459Kn+QsbPeHPtY9Ck=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yg76wlDt;
	spf=pass (imf18.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763654622; a=rsa-sha256;
	cv=none;
	b=cMzWEXZf1DHyOF6/fEJvuux/VDU7P5RpuF3WHLnh0Qgiho3Ze2Wudhw91SEQUNFcDr1FWk
	L2iMFrRNN89LSEnRQ9pwih3vlheOj6IPDakuI5UkiVB4uH56esyNg06hzQVliS9lF8JYT6
	nB1MuN73v+M5YKG56UlrWPre2TAb39U=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-295c64cb951so258865ad.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763654621; x=1764259421; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aZoJ5T7qCxoqJ0PzPFIxBpO8OSKGlINQNrAGkZu6Ryk=;
        b=yg76wlDteBz7of1uPf8yHz/TLfJoVUfQWLZGGctJ9o9asHtQKXXFyzgIUxUUuYaNAl
         REGfGYKbq4b7FrcY0v5Wx8s2g+FIynML6ZPMxwaXl6+MgnrUiFIT4q1hOzn1DEBWE1my
         /bdO5NvemmswG8F1H0/6Yfq5w8Oh4CCmgDX9+eIYPtdCeI7xVc4smv55jYdnsQqYsZPY
         +Ilyhk6Nhez4wifsb5+tCBhdIcC5aQfSjgLwcrs3KWTzVsUXBP92Wx9tX/Scz+nPeuuW
         ylPTRSkgU4eBnBWGdFZu1z9/8hPdhFWAMzIpSau35w01AxNqjnDdm63Tr4gmXLArKm6D
         ropg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763654621; x=1764259421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aZoJ5T7qCxoqJ0PzPFIxBpO8OSKGlINQNrAGkZu6Ryk=;
        b=Y9xSB5ESyO07/FUPKOK79zinEttmJllpYhcmU4p4Wt+bl/+fLceUbs6YmkJc/8XGxp
         RGMBipnwCkQP+LOJhbEApKLHXSTm7E9y1H/l63/XKFUFfQsY8DCRbFBgih3X8cTRVNJ8
         YBtOeUizSNZtbCm/5/hlUUGXUc4yNmsw0OSl7L5OAR7qApVsxSExaud5Nb99Ner9lIhY
         R80PqI9vf5UJmUbyRRRrCMebbTJTS/9MtxQ+1LqlwDcP8SXEtFN6kiBnEGVOZrIfrYmJ
         7x3rBBO4AqnRw3c8v3RtU59VowLV/ZgKiG0QjIcusWSQxB3yIjgjetiay1l/Jsxe3b4/
         CDLw==
X-Forwarded-Encrypted: i=1; AJvYcCVqfnQho5XndrtyXyv82rd/SMUtjFkaCKCEjxk/anlu/+0F08pRVRuicr2WtpafGgIUDGZLF9ocVQ==@kvack.org
X-Gm-Message-State: AOJu0YwKrmkR+wnLZ0ScjLtfu/X9o9WRfsKcczwiP+pbZOiYBZmPQoDO
	BVZ162dajuPMB9vdggBcNDBnrA/FpWxirVI8qTjLMJlOm5+8vXxFynDtZzqbADYNUOvcfol7i5U
	LDElcZ8rnApoORttsaLntvzCqJLlQpcfGvBfF2CVx
X-Gm-Gg: ASbGncsZPo2SQpr7WyowGwNcvuKFyYgmV6GOwI6ZemRKjvCj/wt75yQJBE0rCwYqZUA
	QUVaWj38h3pVfr96YywxefqqcV6NbkYDo8sBlgtcS532geyh/GJNOf6MmhozpIuO8DeRtrQt327
	aI/SbH6AHf+e3yJEvi5tevdp1To3RI8+qLkPtfPBD3uoZCHoAqW952Z2qDF/OhDR6WiZ2QhHZns
	2n9vGYcpBeTLPDD7Bu+iRy7g9Dz+OBSTZ62uqySdR3VitxZefnhlyYQXP4Tf0TIM/NmaMtRTGxI
	BlsmPcszrhI7m0H/DAM8vwX/3FARbFZD13ITceKXMdFsY64bKDVzEi4=
X-Google-Smtp-Source: AGHT+IF7lqOPqoBO+y+4EA6lJ6hn3ZHzn/3In/H2O8AR7c1Wu4vPP8NEpom98N1Q146cEr1Yqb+p7fQVYifcTojWkAI=
X-Received: by 2002:a17:902:c94c:b0:290:dd42:eb5f with SMTP id
 d9443c01a7336-29b5c597629mr3075335ad.12.1763654620864; Thu, 20 Nov 2025
 08:03:40 -0800 (PST)
MIME-Version: 1.0
References: <20251120152126.3126298-1-senozhatsky@chromium.org> <20251120152126.3126298-4-senozhatsky@chromium.org>
In-Reply-To: <20251120152126.3126298-4-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Thu, 20 Nov 2025 11:03:04 -0500
X-Gm-Features: AWmQ_blfFP1VArS6ZsRCtg105hCt75V1EorH-fow_aw4WlQEnVbTUnPSVIx7GRw
Message-ID: <CADyq12zV=HkDOzvfngY_5yCCavdq4n-k6XeVFJBKkVSX_eP8yw@mail.gmail.com>
Subject: Re: [RFC PATCHv5 3/6] zram: take write lock in wb limit store handlers
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DB521C0014
X-Stat-Signature: 4qpraffd869dnxohesg54rjabki1n1j8
X-Rspam-User: 
X-HE-Tag: 1763654622-299164
X-HE-Meta: U2FsdGVkX19T9nknBjPlmHwmOpLCEj4wfFbhi2qvDgC096GWG4Xwm6IU8RHslNtNUQ/6kW0uTXepILbrINyIWfIDKDQnYmo2dpRxlnnXfLD79iIKH87xBHmPkEAVDcasUmf5zXicp5XcGHFPoOherNzCy51rV+uuTvETnEqu2X/sq0go6X/SNQtdiykCX+9RL/pWDXZRenSxUEFudUldr0FhVLDmrsXkpTejIg74ddBbirBQjR0PouOEPn3WjZqAiEszSmZSV4mFLlhK9aax3NxFLgrIQ9Ah9k/63rPzhRiGkyHNN7yOO19MiimmDBDVaub40EcOtA3pP/Ol+7yj6TpQ/S9W16VbtKZG+5tFC8bWKRWfviIUTlGTFYCqCKhspdQG45Y9nUgj0AK3iXNTujdyCln6y7FsXSUxnNfjVu3zSLRjk9t4h9T2Goa/EVlTh2aF1aj62iC+iUQHfl2YNr0ua573I0Yl4LMo+rHA9nTi796GIFFk5In1sajtWpETyxhSeymE2yZ6uBkKOfxbCpiyyR1ODqyIU0atNKcRHg5xRHGe8mTRMMvzP0WKzDW306PjGupn9NfJ6KzZFPLkhDY7OVKy87kWADfIyuCxvQ5UYsxkBP18+QEtbCOLkzSAL7HWL9ZVbawlFF17q2MeBchKlINZRa4fSw9AJuKLl7OKoeimRPZejHqh0b4lzxzWW4keViM3eIA2SYRCL/cIXvpQbwp7m2BXK+1J1uv9rIr3iWzrsd6DPcteCZUradxGM8k9hpLwaRt8Ce/D402Xn7RcvOLxrTbGfrFEMKL5J0Y8DZrJUNNfnlK49OIljMD+jLeBCWoi9TA6atQQpohXN7c31nMfmAlgONpU2sSzZJjNkgaj1cmCTLRX/fquYsZtmGJlr8p5oMJLaYj9RLeSjhAhsGt/s2ewsH13ZYVZZkrvUqFSJguOWpJIQhXiHShOaTqiZgBbOpxxu5AzzjW
 NtiqkLYU
 ZtHlwwwg9tojz2RnuVYbj99VePxQXfbqvVnAWTMHwktMryz0gAmG3SDTJvNXy2soCCzsDqAwu5oxvqShs93cJZva+1dhWY0W195TJmhuiLzhfXjIsF7VO2GW74d97faznLQ6GmoLO92D5eu5SLb8OZ36jl8zVrQy6/vhtZYQF67YOWkFVVNLQn/4YRoUO2m2nsAXUlfbwMe4uYlBNpnBdGdud3HwTwQF78uNIu8HJV4rsOEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:22=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Write device attrs handlers should take write zram init_lock.
> While at it, fixup coding styles.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 7904159e9226..71f37b960812 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -519,7 +519,8 @@ struct zram_wb_req {
>  };
>
>  static ssize_t writeback_limit_enable_store(struct device *dev,
> -               struct device_attribute *attr, const char *buf, size_t le=
n)
> +                                           struct device_attribute *attr=
,
> +                                           const char *buf, size_t len)
>  {
>         struct zram *zram =3D dev_to_zram(dev);
>         u64 val;
> @@ -528,18 +529,19 @@ static ssize_t writeback_limit_enable_store(struct =
device *dev,
>         if (kstrtoull(buf, 10, &val))
>                 return ret;
>
> -       down_read(&zram->init_lock);
> +       down_write(&zram->init_lock);
>         spin_lock(&zram->wb_limit_lock);
>         zram->wb_limit_enable =3D val;
>         spin_unlock(&zram->wb_limit_lock);
> -       up_read(&zram->init_lock);
> +       up_write(&zram->init_lock);
>         ret =3D len;
>
>         return ret;
>  }
>
>  static ssize_t writeback_limit_enable_show(struct device *dev,
> -               struct device_attribute *attr, char *buf)
> +                                          struct device_attribute *attr,
> +                                          char *buf)
>  {
>         bool val;
>         struct zram *zram =3D dev_to_zram(dev);
> @@ -554,7 +556,8 @@ static ssize_t writeback_limit_enable_show(struct dev=
ice *dev,
>  }
>
>  static ssize_t writeback_limit_store(struct device *dev,
> -               struct device_attribute *attr, const char *buf, size_t le=
n)
> +                                    struct device_attribute *attr,
> +                                    const char *buf, size_t len)
>  {
>         struct zram *zram =3D dev_to_zram(dev);
>         u64 val;
> @@ -563,11 +566,11 @@ static ssize_t writeback_limit_store(struct device =
*dev,
>         if (kstrtoull(buf, 10, &val))
>                 return ret;
>
> -       down_read(&zram->init_lock);
> +       down_write(&zram->init_lock);
>         spin_lock(&zram->wb_limit_lock);
>         zram->bd_wb_limit =3D val;
>         spin_unlock(&zram->wb_limit_lock);
> -       up_read(&zram->init_lock);
> +       up_write(&zram->init_lock);
>         ret =3D len;
>
>         return ret;
> --
> 2.52.0.rc1.455.g30608eb744-goog
>

