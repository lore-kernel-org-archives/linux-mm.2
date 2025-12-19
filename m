Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B38D74951
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 05:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2858D6B0088; Fri, 19 Dec 2025 00:14:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267706B0089; Fri, 19 Dec 2025 00:14:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190126B008A; Fri, 19 Dec 2025 00:14:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 068956B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:14:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8599F136734
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:14:34 +0000 (UTC)
X-FDA: 84235055268.08.D985B56
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9BB2E20011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:14:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RBYSES6o;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766121272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGZ/hpEt35stkASrOMsqxewV8TcENZ4/TxY9hCrtKf8=;
	b=tafdixffCoGcBhr1n6dx+LDUYx9zPHxssCwpKrnw6SN54hG4S24f2qiU26QBz4NheGfw8E
	AvCLq0tD0yQ0xZlV4sjBZbQwsK4KxO0QrEBpxrqvSNAJGvvpf3qWbZ7pd3scjrsYvHpy8o
	b9QY2ibONjrAvos2PjiYnGhGA9KYsns=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RBYSES6o;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766121272; a=rsa-sha256;
	cv=none;
	b=peBpxUoMQUuUdJKHVaiMWV3jR5ihkziO2t9UXgh5bXVeV+B1CndKCjOfNA2byzZMxiKMs2
	haD9uIg3WJ67do5pOSEJ95qAjlOlVTepYMxvqgXzekY7PhACHuXEc2ncTxp1zI4ZsBZINJ
	j/TLuEFr3MvOn2+4xEBQUHN+uPSxomc=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64b9d01e473so302610a12.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766121271; x=1766726071; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGZ/hpEt35stkASrOMsqxewV8TcENZ4/TxY9hCrtKf8=;
        b=RBYSES6oJDjY0TRbtmSAm/K/dEXSoWVErbsIZ2xkEpG1HOFkDzj5sHhZNyzGJdQ5aN
         EjF+xf3kWLzpyWIrKisLBNMW4ChOfw3Q1/cmRdgpqiIL6QPteuZLqWmHfw56prLx7Sk8
         avdw1QJ9xcfj0nwhdBw5VUF00XfT6kNImDIw3rRoFwLyHOaFeowOVK/2DrGqJ+l8oAau
         N6zT7up9ygGRcTD/NAYCRUTaI7iYeir4VEafyylHGpdq8mSDnCpAp9svhLmIMNKlxvf4
         euW8D/J1FNMRi2fucGMv/wfULpYs/RSON2+/Sc2h5l+h/uI6V+L5ZgqGMgDufPE6JE6x
         svIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766121271; x=1766726071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tGZ/hpEt35stkASrOMsqxewV8TcENZ4/TxY9hCrtKf8=;
        b=KesiDvSII8dXplXizgU9vmbd3WisxqbWa/kYJ39O7juS5ei8ULJcMSvSC8T7UoXVMN
         Ed5MhDWsT/VygUZPy3txHpePBrxqskkszwFmOAjZ8nYy1z6sdltG7RmAs4EwkmewgAEQ
         ESukY54Uow6fYhqHUvBXatgXwp1BE6R8ZO0CubXyiiFw7sRQzcZ4QBTPQw35ThmUU9EM
         BiNaXvT2mSBuukoT7gqSPcpvQOCGcHdXLC3riSJ/HNYPlKIa5MJJiGahaRNtIUDxRw0f
         /UTiJVGLiO6KG6SCwSyNpPrdFEVZc5fyOBmGOlzV517adM2dEjeQT4UkA2C/fs2zi9/S
         Mr+A==
X-Forwarded-Encrypted: i=1; AJvYcCUwd45ge8y/2g/lsT7O/r9evYkhi95rIm9JrpXLYqtvO2Zp1WnH67UNNZM/cYoIqVu3GsWc1tqoeQ==@kvack.org
X-Gm-Message-State: AOJu0Yzwfwz5usCXuU6wXOtKLHH9+EF71F2WR1xvwj8ZxTg0++ZaJMZd
	k+lLW7B/PAB/IL1ls453I8dBzfk2JwNn8CHymSqhjg/Qn7lgk7hVIa751mr9ARXUIqdj/0zwTKd
	5ukrfR0QH96idVL1fNkR86U1rKmSVun0=
X-Gm-Gg: AY/fxX6GoDnIFEnDxlg5O9maTTwycQb+o2288RLtE07DaEDodZcoLu//FRGhX+hAqMs
	2cJDcxyhumwW5dj9mGp8vav1Q4JwQGxHlXpG7qdjzqPJM1oyzoRONf3s0eboE2D2yyPHBRD9wy9
	sokbS0z9ObJPJth879zWtq5JwZ6+BOi8ipNcADKmDpPFhQWA+uRAeBQIHtXPPRDLziUAf35lrII
	419sD47YWit7hnU34x1hAPo1Sdwe9CKjPjx8c25JvUJqF8aDwRsN2EZ8PC+RmKhE2OBNPs/r8UZ
	EJRH7FrWpiSDYyC03/ArsFugtfwGF5PhRcHl8CSDnw==
X-Google-Smtp-Source: AGHT+IG80d97Re2nvtjF00Myk7dp9sn+3SMWE1FH0uRZ+KUjCjOgUDVFPVMEgYNGDyDo60os2DJn6f+elU3vRIkWEJ0=
X-Received: by 2002:a05:6402:210f:b0:645:d73e:6f60 with SMTP id
 4fb4d7f45d1cf-64b8e94d8fcmr1655556a12.12.1766121270771; Thu, 18 Dec 2025
 21:14:30 -0800 (PST)
MIME-Version: 1.0
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org> <CADhLXY6tueNOZKqjWEKU697_pTGuLyiTdm48CHRH=W6udmQVZg@mail.gmail.com>
 <CAJj2-QHV09Rh+s2AgDtC815YUJUnYgTs0EE9YbDvXdPM9DsKug@mail.gmail.com>
In-Reply-To: <CAJj2-QHV09Rh+s2AgDtC815YUJUnYgTs0EE9YbDvXdPM9DsKug@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 19 Dec 2025 13:13:53 +0800
X-Gm-Features: AQt7F2rKOI2q1UqKgR3tTirk88okwlFfOXhEExrJt2rJNuSNabtVRH3HRJpenLY
Message-ID: <CAMgjq7BUJ3bS6bZ0__=RxMbFRfNk+1xpeZibGZy3j-gdWajO3g@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: always allow writeback during memcg reclaim
To: Yuanchu Xie <yuanchu@google.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, 
	axelrasmussen@google.com, weixugc@google.com, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, yuzhao@google.com, heftig@archlinux.org, 
	oleksandr@natalenko.name, bgeffon@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9BB2E20011
X-Stat-Signature: z4zy9p5f5ce54giw96q74sgpxqbe8kex
X-HE-Tag: 1766121272-194477
X-HE-Meta: U2FsdGVkX18VYIzlTkZDQkQVCxe/wwJQxKic4lT3GNvUg8+ZsWs2q8moA3DUkpzJJ+gn1VHaNnUniJA/HxF06Bt9n3A9KEKIQR5wsoLEekSAyVZy12TSCyYSW4a05vqR5x42yCulf3NjpBR6+VGm21/SEKQGwAEhqAClpXREBrJj78R5UtMG/BMZZmZZlQLZbPJDeITfA1QcbOUdSeD2kGVs06Z+/X4vczVPb2t9kfCZzkAFhN5nlfZwkibPPdjMtsbK3U/+tVGXLJeK+2HNiAAEaiRTpqc2KVqS09roRz69+39FceTGXUsTFAUYah2OLotdxzNMyZa44WwOnWMYu5zTc6JI7sd8GTf+Qd/10qP3cyBcB1rTAj9hfof2s9bbMkKu3u180pks+fR70zBSDiwg+CnIccMJN1ComaBopz7wcP/1S46FyWMbapYrVIFfyO3i+xDfl3Zm0Jlnw/nqMQrdmwu5Ea1RAUA6GIsIPjqbzStxtCaB3VEvD94S+92iSrX55VLL0OxHWOIlx5ObXuy9rmWcvFCpQfMu9xlY8poU5gqcoZf5MYroe8O9dCTXZ39jXYOuCucm/9rtUeibmk88xQpI1bGiHNrqS2ejUDHhtYknhBB9R+hxsBJ8LurY+Y2D42YvxqzuDI1B5ejSe0SeWXRL+KG3OvM5bx1f6zsR/Wuvt+x8JV3GJt2r8aD91zq6SYuoEMEBuh485Sta53fZ/bw2APejICxnYyfMxDcOGl79ml67u9f2NmFqCYn/Hq9UDCHI1uirTTRTVfQgVV0axxY43irWNBu8WBSI0gH09zJqjl3WjahRpIsvyqOGhd1RqQmXlSZBIKkSQjf1npQ6UYrA7tKwGgGJtW8ZjXPHt3Qn+3gh/c4yJZ1lirSOYkskOVBc2LeJhGVPOJ40qt6AYY94VAQXXV8GGZMGh46riBBqpQp8uDBnoXbn1x6j09aPAxkT37LTdVly2yr
 dUV9p1Za
 3DzoqlQFnuE1s0dcEV7bNuL8rfqOzV0OTDFXql8m/9Shpxbp+xMKIFRwSom32c9aaKTd8F3nEXePAtspaX2uFoHvi35Xuc0sIJ0gw5uLOl8GXAZOV5TXC570eG7wnqiQA716djDQbyPzsp6VrE0xtCYzNERa1xc6e3eksQg++h6M3ni/BmfdeKvFTeiftfDdty5uZMcurN0fPxP9JYdPIvTgbLT99LzuGM57rCIfMlu2gI6eFGTFMzQCnRdJ5nGaviWEfIrIJdBOYM2NrAw0C+eXYxGev4FH1OpcLUSA7ppT9G8MRwampjZRrvZXM2HUcBK2mmA8g9RUxajAsHrYtnZsc84GTttJMnjV4R9wgZp1eCzdoUjDdnPt1mZ+YeHh1/Q7nfhRkyYNBGoaWf6DfpYlqWNR1Iu8MmmxM/gi/obOPwrYUvlZvSuxmXD7VHpXsUr7jft1lTn5ou8vf8ZQWJZk5xdWQN4hLCvgkAEBjDzPuWaEIKtTkLZudWqJzNZJqWH9oaBB/itqPDdfrKSP1/NXosz2Tik0UyQZbLh+5L60MrmFy0db7Mz160o5p7B74YmnskNgdcGfGgS4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 3:52=E2=80=AFAM Yuanchu Xie <yuanchu@google.com> wr=
ote:
>
> On Sun, Dec 14, 2025 at 10:52=E2=80=AFPM Deepanshu Kartikey
> <kartikey406@gmail.com> wrote:
> >
> > On Mon, Dec 15, 2025 at 9:42=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> >
> > > > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> > >
> > > That seems unrelated?
> >
> > Sorry for the wrong fixes. Correct  Fixes: ee814fe23daf ("mm: vmscan:
> > clean up struct scan_control")
> >
> > I'll wait for input from someone with MGLRU context on the broader disc=
ussion.
> >
> This warning came from commit e9d4e1ee7880 ("mm: multi-gen LRU:
> clarify scan_control flags") [1].
>
> The original rationale:
> > 4. sc->may_writepage and sc->may_unmap, which indicates opportunistic
> >   reclaim, are rejected, since unmapped clean folios are already
> >   prioritized. Scanning for more of them is likely futile and can
> >   cause high reclaim latency when there is a large number of memcgs.
>
> As far as I can tell this was a sanity check to ensure
> `lru_gen_shrink_lruvec` avoids extra work for minimal gain. Perhaps
> this shouldn't be a warning? Always setting may_writepage in this case
> would free more folios. I'm not against removing the warning either.
>
> @Wei Xu @Axel Rasmussen  Any opinions?
>
> [1] https://lore.kernel.org/all/20221222041905.2431096-8-yuzhao@google.co=
m/T/#u
>

Hi All,

We are also hitting this warning in our test environment. Simply
removing that WARN seems OK for us, shrink_folio_list will bounce
these folios back and everything behaves just fine.

Meanwhile, is it a good idea to add back the !sc->may_unmap check in
isolate_folio or improve isolate_folios accordingly? That might help
reduce the overhead in the worst scenarios.

