Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A25EE81A25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01CD6B0005; Mon, 16 Feb 2026 10:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB206B0088; Mon, 16 Feb 2026 10:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7746B0089; Mon, 16 Feb 2026 10:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0E36B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:10:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28060BE14A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:10:26 +0000 (UTC)
X-FDA: 84450656052.12.5E70843
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 35744140012
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:10:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ITr3ST4U;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771254624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKfrj2PliBq8PNbEUd9rPxprHWhT6UcRzsxId4Lm5jo=;
	b=yLchWiVN6tG0W3mr8DxKRVMyNJ/BW+K6JVAHmvf+kxClEsDVxko66fe6HhdYmujtI/7toy
	zjeLyeLZAilmTVJ7Ho8mvsOBa3vHXd2gFhjGSSTMaXfoxDhwLhPZvTOC698wAWgsEKStXB
	dthXFrMJOJ0EdKvafUyqlmnAqX0xw0M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771254624; a=rsa-sha256;
	cv=pass;
	b=UrcxRXogRLcCV8ex2TKOfBch0Mzld1LQaQAvzr+2MIvdNmvY1TtJF47JYUT2jAY4zTGXt+
	NfGgWpduvQvotWUH5m8kKH/3ZlLLdz3XVs3A4o8uFWKw1ufs6I1n2xjBTqtUXKStj4H/KM
	jKjO41ukguwFnh3nYxK1kSqqMh1N4rs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ITr3ST4U;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7964f1405a0so33666687b3.1
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:10:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771254623; cv=none;
        d=google.com; s=arc-20240605;
        b=kCoAwumUpHuzkXcNnp3EwGW3apBJC2sPwyx75s24yb6TG0FzwrRWf6/qZ9gjOELAyT
         Ex5rXYtOw540saJO+jreK2izWtCXj0YD+yh+uNFslCupfNkmju07KJNq5RhAKjfMM+pX
         uImpWTCl44ePpVlFvfvRak3yM//f7VXRqBFTJAO5nlysXxi6+Ui2GdVYfzRZzEyrgfbF
         3QC4QN6Tq3HgeuI+WT8rnnbpQQdtJdxQZxsDVqO/w+IEminbvH8RNQNsTn+h1GQSAwOR
         WbEwjAXM5O2AENEJoxc7XUnmAg4fuffZ/NB1li6iq7KzK5FHnj7KpXQBt4H/CsOpxngl
         rHrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KKfrj2PliBq8PNbEUd9rPxprHWhT6UcRzsxId4Lm5jo=;
        fh=VcrrQytyGpfnBEeFECuC75Ur94IRjERN1zDKnbUaPx8=;
        b=kKPYzsKJEOUiurzdWkQYrxkG11ZOzvX42Waq6CcbK5d/ctcKCVi8Sq8UTEVREjJBoS
         VGwV9ozxInQzL2HQDyFTgmjjEO6n7QUDLp3lLAN4gZLyJQEj1zEtkqGXCKNhi9S5c60X
         ghRP++m7Gro7/dM/rawSfSmFmHGvcsg048KetIZUnosLJiXgERb1qPJR/W8QFr+SeFrW
         0SgvolqlfqqKuh+eF2C8uQBmtkVe3yplcUmrPQ2DqhUzyl+rHAQCMGhQRV/1PLNTHTPR
         ECediuiY63+4tQWcb3ajKdbZFwFh8mzJZJ/P0MMcgjmKCeBMgytpMxfHFycM2zmSEPon
         cBXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771254623; x=1771859423; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKfrj2PliBq8PNbEUd9rPxprHWhT6UcRzsxId4Lm5jo=;
        b=ITr3ST4UYS13y9E9Qzu8q0yZ0rHRkhJcezlBf7ql1qCvfEgXx3JnHhu63fQykr01UC
         0eHuLVY5Bv+eg5l0SmiWXBZGt650TfUZLIbMk0zo/9EgYCX2A7zT3pp8vbG1fNwrAq+6
         a4FXUWu9MTYwIlls6Eow8z4Y9FXhIHbWmIli5SjnGk9eYJFLX1SkzEgKk+gEJm/+Xoqv
         E3j8YGjlmmaER/IsXqKD6Amcc7DKOSD5bc3DsXONpD2Axsiun0ESrWEMR5LJUtMlkioF
         TsY7EDBqfFisXJKDl/NVOHii/neP0v4m3f2IQmgU9DfKRGdzFjO/+v93yLZV6/mZ6Pze
         Bo0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771254623; x=1771859423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KKfrj2PliBq8PNbEUd9rPxprHWhT6UcRzsxId4Lm5jo=;
        b=abOp2Vmk8tCl6vUjVWVCnCKuLMKYzTbLOBkw7Nx6nroOoHdfg20AmMYjQKWRmWyVCG
         0/J9VXNVFn54xfq+njVu19lnunBuXnDQ/bWyPiiGnIuJVe7Xz66E71MTqYoiDzyUtiYY
         +J3rsMz0mVGMD5O3xWdIVcH1xZ1SygT36lamTlfCiSlwDWzzNgjKkTw5WrEacVLHuazc
         BR9q4lS6B43NbiJ8Km6q2lGth+tuFS5YzofroNcTeFy+qVJ8mU+x0qbKDhAGUmdpYXKZ
         04oJga3vgDV85GoOrP2/O0r+NHrT2LsVoA1WhnsD8La/DxGbDOPxpWIjSXYHDpUJ619x
         TmNw==
X-Forwarded-Encrypted: i=1; AJvYcCVd7Zn7WURYg3lByTd+gl18RfEvR+aSHfeLVQverEIL7V5RHusrjqVMhmM4XL4Hzj0Q/AURZKIgzg==@kvack.org
X-Gm-Message-State: AOJu0YxYqYt5O98PaEpLlJRCePMlUj8zYanjRAXsvSRVoWTHakAuUEwP
	OWBhiuZDgirOrlkd4O3pz24el9VILHg0XKBLIECOpNtk5LBdmr7dlNvdnBb9Id2FCtuZbBZiAPz
	rhkwXAwsj9HclAIGwJ4MB8ermvpx37nU=
X-Gm-Gg: AZuq6aKvQ++3oPZeob0PntrwB5CvShQA4teuh+dMtywjreoRHtJXRpWYvJX3Vm2jie1
	BLI6Lkdq/NyO5u9QU+G6YhiaTrDeB+ixeK/fEle7WsnAY46EyuaE7+ifzLbEYzzyctXzS8LIBlE
	F8ddrMQo4a4pr4w75XkcFr1E97tpvVidKJpeZeWT32tjbliYYVyyJTjcxGmlE9hRsRMMj83n7v0
	9FwWYMP9n7C+WRfz47gV8O95okisKxrtpLDIufXuQJPiuVef3YGDWyoG9joYd3ZP2rZBmgcsWJp
	z89DkAfbUal9WTk2Ir0=
X-Received: by 2002:a05:690c:4913:b0:797:a162:f7d7 with SMTP id
 00721157ae682-797ac668393mr59660227b3.62.1771254623145; Mon, 16 Feb 2026
 07:10:23 -0800 (PST)
MIME-Version: 1.0
References: <20260214084514.2842745-1-haowenchao22@gmail.com> <db1fa367-0fd1-48a1-a58c-73e72cfbdc05@kernel.org>
In-Reply-To: <db1fa367-0fd1-48a1-a58c-73e72cfbdc05@kernel.org>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Mon, 16 Feb 2026 23:10:11 +0800
X-Gm-Features: AaiRm53RA4pt-PBOeo9hqu0EXVSJ-q6su17FtEV3cj3P9O6ZdL2K2L6yqVIj8kQ
Message-ID: <CAOptpSMCDnnZFSiMrGwA4Kc5Zu=4-6giVbbzMa5UEEE2QzvtoA@mail.gmail.com>
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous pages
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 35744140012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ohr9zi4z4rwq7kx9c6xa1qk4t5uokkfk
X-HE-Tag: 1771254624-801420
X-HE-Meta: U2FsdGVkX198q3kMBfLa0/ZBowWvrBzBINz46EKzKvjl5+afqPV+rO/t6/0ZTUv/ilhByB6NW9Tn5nj+DsXU8owG6wDtT87vi6FfZ2DNVVdclIhG5/oeXTA8+6wsLPd7EqrAv6TEUpX47yV7bVKq5Dbr/M1G3HxiktcCojQ0PUcavFrqdrxrWpeT2e9BZTEgRzj5CDV2XDoFDZ/qIP7SWJATPSK7qC4c/uDokXU9Q/cM9/SKMZyrzBEV2Rp82jqzKMfgrVZpJwlm2w04QS7pORPIgVJu5sEyaJdsNdvIPgpSS02pU8DOdsb4JuAWRTWK7nuRfy8jNon14ez3OH5iHj1/SDvACr4Zv/iomvs/LolFbo40+/kgLnGw8Ev7W7Oubgv91YRWwBZAlyCwCRjWkSFdCPGvcQPGq2HNhQ/ouosgB2kKAI4iXRqlr5orCY1DpFzZI5cTQlfx8ML7trGvFj70V4RF2tBBvW4g4mTbPjUbOwY/bUw7xSOJ2sWcPdiK8aeUckxrZN3qY6xOTGjw4epT/lmrdYtRtpFagrxso7Cq8IL37aiBM1mhhL8wDSemv2Qt+YLqxReu1plDSbUd3CDTZ7iJ2ZUIETMMicwYFmEXpXGVjyuWCIJGaiiwZxf3wXCjozFXMeSPsW8FMPvEkCMdRMx1weqeGeElsAWZ2+OrXJBfu1Z7W3gzfCVhE1O5hjjxt9SzKIAoPxFvCXd0N4/PWMAa8B/ekUYNWa18KLu6UVBnFfh8YZszsWCJluLR83kMVFk0sfBs3Krgz8p0K56duD3rwRWyAGLdx2rW+UyZXT0VNbdlK0urx7+p9SAQm3ZH8ujkGuwk3MRT4rGs2rQZNJlL+WWlGOwpouZgaQ1PZIxnLzKtn/yaOSDmgGI1mdjrisUoKTBoE4xv/4EZMwyZv4KMagOhN0RuB2lIc9uRAhiVAruWxCS6CbJg4ns/8yOPraUzQYEDTwjFTmg
 zr4h4jYS
 IgvbH5+YUpLrt5rQYcCo6WW9CbAYnAfyvsaISNSHiV5n7+rM8GJ/lqRQ18UlbPaRiIysr0XbaSF4R/c35rU6rYZvgzfj78/qUUYhaTJoA1GfHDWg3Nj5velVT9GqJR49jB7KS6fmhLAxMhggGyRonjAv3Rpp7HYICZVuvEPWcRUVzJSx1MZuyJqxbCHVeDH0NKkcxsqq+bTRb45ef188FnI84+wSgwSHR98d30wnpXFkGpW1aZ8zGu4YqGBD/DhDf1HMyUn4tzZQ+xqiZYAjMISCOwp01Dh2BaVCrPM6tFc3q4wCinmRSJLtovmiFNkEiCUqqyysMfj0kjd71b+hoUX4KuigLxoEMMsDW0P0MQBFiPBuYBhrUzVoVh5hk9XLajY3kRjHsdkFq14rGpxVhwFNrQqMWxxNU+IIzMi7jnKtMJ0Mf6wiykvuMGRspUH2Mk1nz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 8:15=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/14/26 09:45, Wenchao Hao wrote:
> > Add kernel command line option "count_zero_page" to track anonymous pag=
es
> > have been allocated and mapped to userspace but zero-filled.
>
> "count_zero_page" is rather sub-optimal parameter name. "anonzero_in_smap=
s" or sth like that?
>
Your naming suggestion is indeed better than mine. If this patch is still n=
eeded
for further development, I will modify it according to your advice.

> Still wondering if there could be a better way to enable this dynamically=
.
>
> In particular, not using a core parameter.
>
> If you use a module parameter, you can just set on the cmdline
>
>         proc.anonzero_in_smaps=3D1
>
> And dynamically set/observe it in
>
>         /sys/module/proc/parameters/anonzero_in_smaps
>
Regarding the use of module parameters versus core_param, I think
either approach is ok.
Currently, the core_param I'm using also supports two modification methods:

1. Command line parameter: count_zero_page=3DY
2. After system boot, view or modify it via
/sys/module/kernel/parameters/count_zero_page

It is true that this modification would be more appropriately placed
in the proc module,
which aligns with your earlier suggestion.

If there is a possibility of further iteration on this change, I will
move it to the proc module instead
of using a core_param

> >
> > This feature is mainly used to debug large folio mechanism, which
> > pre-allocates and map more pages than actually needed, leading to memor=
y
> > waste from unaccessed pages.
> >
> > Export the result in /proc/pid/smaps as "AnonZero" field.
> >
> > Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowenc=
hao22@gmail.com/
> > Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
> > ---
> >   Documentation/filesystems/proc.rst |  5 +++++
> >   fs/proc/task_mmu.c                 | 10 ++++++++++
> >   2 files changed, 15 insertions(+)
> >
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesys=
tems/proc.rst
> > index b0c0d1b45b99..573c8b015e39 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -545,6 +545,11 @@ replaced by copy-on-write) part of the underlying =
shmem object out on swap.
> >   does not take into account swapped out page of underlying shmem objec=
ts.
> >   "Locked" indicates whether the mapping is locked in memory or not.
> >
> > +"AnonZero" shows the size of anonymous pages that have never been acce=
ssed
> > +after mapping, and it can reflect the memory waste caused by huge page=
s.
>
> That's not correct. They could be read/written, but with zeroes.
>
> > +Implemented by scanning the size of zero-filled pages of the VMA. It
> > +is default disabled, and enabled via cmdline param "count_zero_page=3D=
true".
>
> Probably best to keep it simpler:
>
> "AnonZero" shows the size of anonymous pages that contain zeroes. Zero-fi=
lled
> pages can indicate memory waste caused by memory-overallocation with (m)T=
HPs.
> Availability is controlled through XYZ.
>
As with your earlier suggestion, if this change is to be iterated on
further, I will update it according
to your suggestion.

Thanks.

> --
> Cheers,
>
> David

