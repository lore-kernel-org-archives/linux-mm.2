Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F385E9E311
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008756B0005; Wed, 11 Feb 2026 09:50:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9086B0089; Wed, 11 Feb 2026 09:50:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAFCB6B008A; Wed, 11 Feb 2026 09:50:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C773D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:50:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 691341601E3
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:50:47 +0000 (UTC)
X-FDA: 84432462534.16.8A7E01D
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9011F80011
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:50:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ds807u73;
	spf=pass (imf02.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770821445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0poieiUh78dK7lgPhgci6XtdO97Oftu13YEbXcnaIo=;
	b=xP/G2hz6+YDaIeCemVIiqcHK/GwRt5wto+qJ3UFm1mhBz5C0x/RoE4fiU3631h8rMhpDWM
	SRO8HTYFPevQmEd4kL0M6POQE0ctCs4j1FOCXhMig+Pdxr3ABxKeuOeA5sNLB7JmPavcvw
	fCyPkW5rWM1BNMm0cTMDA4pgAmrsK34=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ds807u73;
	spf=pass (imf02.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770821445; a=rsa-sha256;
	cv=pass;
	b=umXibhmFoMACjsYBQivIw+oiLp3edg228BGpuqj5Hw2arUSXLir8igAjZq3zmDfgL4+Srx
	9J0OQbZfruj6siOw1XmtkWkQFcyLhIn/HU0xIT/QKIxK6ontd7ipxi9zqdmU3JbV4scwbN
	+/lGNWNDcHMT+oFAtw27Nq1MGhqIneU=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64ad79dfb6eso2180617d50.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:50:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770821444; cv=none;
        d=google.com; s=arc-20240605;
        b=V4P6rCF1XwSSIEBnB6spr0J5KBROzkt2FyLu+o42LptY8gRKaVblsfeleyV9+DA8WR
         vGtTjqpYyT+YNK4xNFHk5fNPdUFC7CFHgCFCnEy8HqnxDOcwBB9j3AUuolVUcTJ+nyj+
         NdTF0xI6ApTAbFALCUPRyX/rVR4LmKQTrOMcm/n0bN7g2Nqnt3jhNpp6LL9j+MEdTDwA
         zGS2kmjDiuVcDwsrZdDeTKvuKHwRWVp5OQ14i2esZMBNSHjok0NeqIeYIOQ8nFmKM8Hg
         e11ctxGdwh436N8WUWvfkeYQvtlRQknNrSExDXnsfle52mFYHlJI0vCUlbSH6ksnpfTP
         2Stw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f0poieiUh78dK7lgPhgci6XtdO97Oftu13YEbXcnaIo=;
        fh=7JiDALQeuxiY+gVc5zYuqQxaILCys0yNYiIxA6vEMSk=;
        b=QLaxxv0hUPz+O/aZs9jyPImfHjEUYsSX8VJCMZws9L5KCao2SY0jG5StGK2wW2WVm4
         5zCmHFmuGKTLobfJJLb7cb0ni9vt7t0845Q4G67NlQ2gv0qxVGU6bC82nitLmGZVunpc
         U3CHka+nCPA+V+xj23U3nsMG0Y4Mm61DI+S5LdfN02ggtGHjMHti8790OKNZ2Rc49eLb
         tzfFhRzSU+gPWaSzzacGobUK2pdDR+IxMTpnDv8My7PqqhWlD3WvMLWYQi32Xm8f8Vu2
         fy6LAOah+Ojj56V1zg2HgL2WI2Q7i4dH5FmQOTg5DsV5awttGQZL/+knCQ+9Kj92QLbM
         +iAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770821444; x=1771426244; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0poieiUh78dK7lgPhgci6XtdO97Oftu13YEbXcnaIo=;
        b=ds807u73IxijdTTv/FluP+PL3jaxrxyikDc8u2LG/1O2kvKwcHS+9hQ6wzXP5zhoYe
         /196fYjV3lO3+L0h8EcHQa0zDz720l9S1GtTUoNNv4bKK1qZT3SFz7Xhsp0BBDEBKfTS
         iVbtGW9FVt6vFCrX6cuI+kOiaNN1Ap5XGl07jxfgouOBE2jmmNSEC+DxNXULiv8oSzcp
         gxQEYJCVRSIIuJjydUnnKKMGhQKhTiQHrpnXyGTGDm0ltx/l/r3HwDoMCUJrrhh6JKkS
         su0lB65SLb1/9270KNoj5jMR/1wITik0UQZRi9zlqsoYdsPcngV6TDTjvF3XTKGsjMIF
         tLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770821444; x=1771426244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f0poieiUh78dK7lgPhgci6XtdO97Oftu13YEbXcnaIo=;
        b=Rl1O26cVnjwX6qlmha6xyOdkjQ9R6XpeCjgf3LQUJkIFHc7EVtQCCVBan/hzdWJ+im
         8Msl0kyTANHvTcqe6rDcq3P7xciNwG6ucsM/B7h9EOPRksL2eYoKJ0QuR48kRoa4TDR9
         a8daLUFS+rOgbG+/E1FMFCnXJ2vPXJZOA1YDOrmospG0SDrY/3IVTXAk08+f6Bgx+and
         zw3s99E8XO60AbGxQUujA1DqtPIaPXOJB/rfXG+WaCR+/riM8/uXh/P9KEgpKeWn3jDF
         VwhhYQEOUt50ciNOiU9g2+8ow7eyqa/ztFrYp3Y5YNZp2f9GOowThgSUR+MSfHG108lT
         A9+w==
X-Forwarded-Encrypted: i=1; AJvYcCW+On+e0Scvwfzsip3yiKKTAkHPpjKHqn0tJi7KOJqQo2uNB5BVrdafJRSzst+4Qc9yL48LovFX6A==@kvack.org
X-Gm-Message-State: AOJu0YyFPI/CqojjNJ2Up39lBiHJmV0zzMxXUGIvxruHoTs/t3uOGBQw
	1eU5U6BDi86dXe95tFoixOXBk/GTtgYQfbW3xqvEAkptadJPdr6fPv/ll4w3MvuYvHVGUi9M2Fn
	0WM7EZ6Ii/7BsGIYvbPERJDZ8J7kcSWI=
X-Gm-Gg: AZuq6aJXKcFhkv6mqIbuCPWq0HG0kw5i7c2olYNPGJm8Gypu/M2axJNvDp0Fz16JC/c
	FTkAqENamC263HEpJUezQP9HW4/3yOjId0gBVmvG3YoYNSLsO7YHKrjzTGCxMwqs43gW7/jmNty
	Wn5Yss1F7eTMtfMufLoVqQYj61+IJbbC0srkPii9eXaLF3KzhI2KOkfesPyds3qCegTTgZfDd5D
	+RHUpUz3x9Fm/0vdN+D8VDs1qGHb1WoTd0puWeUKPF1xxzeTEOOHVpq6oCec0xj58fp5UuKNb78
	Iero6MLA04p6TCSg6Ne7jW0a1n9HBVXdfWxqSUlGuFh2TRcniqxEK30gxiYUU1IkZP6A0ao=
X-Received: by 2002:a05:690e:11ca:b0:64a:ea40:b7f2 with SMTP id
 956f58d0204a3-64aea40bbdamr6832215d50.61.1770821444477; Wed, 11 Feb 2026
 06:50:44 -0800 (PST)
MIME-Version: 1.0
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org> <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org>
In-Reply-To: <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 11 Feb 2026 20:20:33 +0530
X-Gm-Features: AZwV_Qgo4LNEg9JcXUw5qulC301ZTVYLYHOxqw75VXqBk6USt2bBmq3OGzRSilY
Message-ID: <CADhLXY7f=63Xd2ZihA1T9T=Hd2ZHHabiOZgS5Ay2Rqh-BVO2Kg@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, pbonzini@redhat.com, 
	michael.roth@amd.com, vannapurve@google.com, ziy@nvidia.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	Fangrui Song <i@maskray.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9011F80011
X-Stat-Signature: be3bd5pnejfefynk63cxm1w9iwybsqih
X-Rspam-User: 
X-HE-Tag: 1770821445-28024
X-HE-Meta: U2FsdGVkX19msEBfgBPKZzfwZoPajZEulB6EPfOoho1jnw02cbEe9ejJunxsd1CqSW8YeYQuZWiyACqafcFKwn1QmHKJwVd6mOx88TWcCtGJZW1VXNzf9Jdw3BN3tWmKSEHu9FGwtQwYvNpTccjog1iXtT65Av/ARBYAmjIT9WMuRkr4fZK5NC+ltHfyDSjgLlt43S2fKHkkuqx2fnu1g580Elmiy/OhdRs3yrI5alBuEZ1gvFCzBBkMHGG2MBHiyaI2VyHSQKbr0TBpAW0kkdFnnEFnBPqOQeRF4nUTfIxDoWs1CKiU7qTfIsdLIkOwYvMKSuv/ohZDmdUxSdnPe9w/HjvOLAff7ZGmhSCNgOIvmVIvOTA06KuCRMRz1oOnTGYBEh48kqgnLS1D12QtwpQ+E+r+MHqdONrR/DAdbprmvH62H0eyadbFPmFYVuyFvIRJHVao4nFdzqvOZkywgualZKVpUPWga5vumif/XDbJ+wa8HT21TklbHtElUxoPIgx8+TsqKf+x816sqSRpJvA7rxgkmbeRaigwp0LFqt9nXvZN67ilRkCUvxNfKsJbybVBCyRCOO7ygPLe9OlqxeRd2MxqIgiAFhLxrzysZKNHT8h8BI9I3uAy/rS0g58Ru2VN/TkpMtgXLsov7ZKwxu0GSFD3VI2l0EfSV7cOPnkJeIfyaTt0jGgyTfxZS6VOqwBQJotZGsPjPFssxRkplnQ00m/FHvkWzWLClGcbl76d4AQviOP+3keHYvsayNc2HIpBlqMGuHHSC9wsfmW38vnMz1YwKCBlkxqg5ErlCK/xkBKB2ZCQhuuvyum16qk4yCMVFFSirMjMtVr0XComxXEJM+r8YICLEXIVVGBMiAiqEaFYUDLumby8ku2VhByVt3d2FX6v3qjPmUV1tPvHAxmMdgRk0iKW6x67RpIqLrdr/iExIF7fKi/xxvAQyVYGG/jTfGrCKOdJ7jJQP9n
 zNwRB41A
 VJikwjZn1qEp9N6yiOacA3i7tH9FYMqh+Dy7R6ta5zdH9UkzsWomv42xYRjtaJuAEVwFqq+cZKI9LpHNr2kaY+56STiKGS08BMHI/dysT41syf15/5QXZfBn7Iliv0NP58Ha39AEPL1+bFyDx+QuHm8dlTFqtJk8Bk2pv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 2:58=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>

>
> What about the following:
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 44ff8a648afd..9fbe5c28a6bc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -94,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_stru=
ct *vma)
>
>          inode =3D file_inode(vma->vm_file);
>
> +       if (IS_ANON_FILE(inode))
> +               return false;
> +
>          return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode)=
;
>   }
>

This is an elegant solution. Instead of depending on specific subsystems,
IS_ANON_FILE() handles all pseudo-filesystem inodes generically, so any
future pseudo-fs won't run into the same issue.

