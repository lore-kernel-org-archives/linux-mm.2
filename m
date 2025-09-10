Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428A4CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDB38E0011; Wed, 10 Sep 2025 11:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3938E0006; Wed, 10 Sep 2025 11:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F06E8E0011; Wed, 10 Sep 2025 11:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBF48E0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:34:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 364881A0454
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:34:10 +0000 (UTC)
X-FDA: 83873736660.07.5B190AE
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 415B318000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:34:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WOYCvYPX;
	spf=pass (imf24.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757518448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jeizmsFhu54nan7rMKZbooFiQjONXN+394miwZ2rXQ=;
	b=4ftnOTyQOUOmuQcSvT8caLgyPH8iXXiqtWZPMWgOJ1GwWhjdwbzTzI5sTN7DtSRzMFQYKi
	yLyxxtsv1ttpi8Zr97nu+xW4kTdQsomzV1dhtkIngQ7cNV7cQ3lAp6XNuva134WvSquHDX
	KiRaLon32Z8LrnEsxIkYHjumGnbsISs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WOYCvYPX;
	spf=pass (imf24.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757518448; a=rsa-sha256;
	cv=none;
	b=VQ9ODhGCWXOoXCkWEh/WGa6/cYLnoIdkXf1aFDn9KCaEOpUgJf7/TmGAbP00Q1o4S5fw6w
	W7M2mPWNIjEDGK+dWpNsrvCO7U6Ob297P3qV0eHQq1Ch6Vn3KQ6Ehs8+yD+Id5wLt+ef1I
	C3jxEVrg8TNpVLuwNXtydxHcnKVGOsU=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61ed6eeaff9so7451a12.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757518447; x=1758123247; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jeizmsFhu54nan7rMKZbooFiQjONXN+394miwZ2rXQ=;
        b=WOYCvYPXUlIiLJCzyrdZoFpFRK1B0gq5RK9pVAB0VnVRrTa+kio1wumCd/Xg/cJtVw
         JJkLTWSSHHRQmobGavHxjipsshnWF13n0KKLrP4ZX0e5tZWJzgzZIohJrVStsePkk6Lp
         cIJZDjN7LVKPxt7e6TeEopeCnk/WHhKGLNs6imfULEuTPtxV4AEanLOj3M/882D36coM
         pbz8S3+/2xmEhK4XINeLevO1xZXvY0ycZ1bf21hqMN1srpvUEx21osspzg8gyFCGpFkn
         f2xpRae+Tr92spW8Tyluw/BdIAATytAwIPRtfSLpQPKinmzfOE+HmczaUV3dMZIIhbbR
         6V2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757518447; x=1758123247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3jeizmsFhu54nan7rMKZbooFiQjONXN+394miwZ2rXQ=;
        b=g6+l0mDMQ7eVAYQ7emB+itzpndg4oOSxq42c4OH02TxjrXmOe+aGyv7x5xC6NUEfE7
         WZG1O3SAZ+TeJIXm6JUTVVthjy4TY1OsyWEh1WFw8Z2R6F/jXpxVauahh5v5qCKZkuTi
         gXOh/i/Hsq71G1xHxCDyNZjQf/dzt6lWoURCVwfFeZm5L2TUaqMMON1CSE6td0OopSOj
         oJhineBkMKfYx3KHTVf5hBlsjKXY9Yp9JajDzseFWMUAlBIjzgMicVY1qh0rnq+WnJFl
         L0ys4q2UD3pjVb31xTOKTXBZFng3M7mxfiZzIGBvGeG41v0dNfoq70X+sDiGGlBGjyaa
         z/qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcxNa6DffNAo8q5V6HILQRJAf8cz1OK2AjO9D4ySBiwjy2j5QEoJyr+MtVOh2zXznKR2f/LKKqpA==@kvack.org
X-Gm-Message-State: AOJu0YwVnI9SVPkA6Uea/HuhyMeL9JzeQoa5WNuFAcbgMrvYxWsrDlz7
	dzh510+zyzbHbpyR+Jy9T4OE1gpQ0hz7J9X9SndKyyyKyVZJGM3h6JoD/PIpZolT4wA77Lp2KiK
	iqzDlzQs3gzdeD7G5B4n0LBH0Adbr+vAVn28nIbuL
X-Gm-Gg: ASbGncuSOpkf3E87Vz0D9CjyfJVWUm7gcnkhq47h+xqgqNCvc+Rz9/Yq/NV6NtDAvU3
	7wZpumoefOGFiWmK3x9QYEa/02/5QromR/2N+jSGyubsFdq15BnS2oM6cj7gxqumVqL7rYyPfnz
	yB2TY9JJszHV2ZpRi1XMS9zUccXD0qC0ztPqNdh433dfo5r9eIfuQIMApDuGZVbBz1AKNe76ByY
	MGBjpIGAus6owJffHNwOw2NqJ82sP8NMtIgBW+A2YavAzo=
X-Google-Smtp-Source: AGHT+IGqWbE9TuC20Fk7X+K2vUp2vIuXlayFYnPfT0+dt/PJy92lcyLqHzOTUIPIbMLERcug/5IYs1odQFB1bh3hY7w=
X-Received: by 2002:aa7:dd08:0:b0:61d:fe8:973d with SMTP id
 4fb4d7f45d1cf-62d28342bf0mr110663a12.4.1757518446427; Wed, 10 Sep 2025
 08:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com> <aMFOh1NxaIP0GtGE@hyeyoo>
In-Reply-To: <aMFOh1NxaIP0GtGE@hyeyoo>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Wed, 10 Sep 2025 08:33:54 -0700
X-Gm-Features: Ac12FXySS2m4qvWPMPU4BDzBRVYmjoZW8-2cf1GsqMgDtAU4Xf9hx0RpU9IGgbY
Message-ID: <CA+EESO4=Y4GsJ9sgnDen2tiY566z=vVOOcHF8dQYPy4nS4TPqw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 415B318000A
X-Stat-Signature: b37t49dhni7kdpxbxqfkxpqp3s3uud6m
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757518448-839975
X-HE-Meta: U2FsdGVkX1+xxM8PTQjQG6lZ0bli3qHKFojfzjPP0yROwe10NrbLKLGzJF3xK7egmUc04hPGPX7qOs+j921XTkx6NZDRiGtEsELVAZDGW4zp1taARr5FlI4WaWkEIkFmcHbwG1vD2GWWM+PzRE2H0BYUB2AVZKNHg8o21Sl4QpLuJkpMpKWf36ha1DHmL7tyRTObZS1xju9fX47hC9aAowIdg41KvLEjIWv4Kdj8x57DmhLhH/VHb75wSGbkutZQtRBZHwf+2vdDtviJe7sZolqoeDAFIRmqfMIWYNSjPi6/u+/vHOu7gRmimanbnAnsmvKPUnd3rzzy/XiFcf9d+bixSjmMWIa3s8cGiIyUEuuO7ySy+yDefqmHsKUSxv8dR8lZSKUCRZHGS19RpZLH8ZbGp00fYg7d6dX68ppkdGY1EBGInBjVl5mqu/1yjaTGUaKXm7k2A3MLHifXE+QmzeDJx0YymG2djBzFBsO7ewig55NGZ8BxfRcWmYU0MsbbwXPbzG4byQD7uKLsExiyQHusN/1scqsSgv8W+vh8OkjVZbw1GjsYiM+v8VfOPQe995qF4wVkKBsMYRoehaUgVwcJ8g4OPGR79P8D+zLtuLqtcdHE6e23WRA40/limz2+QDXnj0ND+Seyivml3Zau+X2+p33lO+7A95gHGHZstCr4KfpohGSJ3CZTmHL+0oOZw8uExF3KzYSSasCR4vFdsHIZmmplmrhJCHwdbledEF0xVsGrAEtHPRmk5oZdnudp//8P5W3pwqQX70sXB6T11eheuHfxgwU45rruW0M/jle88aGpT86bW0WPCTZsG+UJWQPIvcMktxJ6yMIYI/rwI90ZSR8TfXaNQFqdGJYevhPctpUcdx0LpCY7w6XevG07k8kjvoycYS4Gv8imnd3UxkZXTzLMruZiMTankfYuXoIyQU6XxzURCPKWYSsgP6xhYxJP6foojaRXirq1EhY
 MfywJczU
 DyYT/MYjyF7OPVZFEb0HCSHGCCCQpDm/E42Xk/zz91QQ/mLVek1HcYaGDkIpLM03j8ExQ7/Mi7AjR9JM1ZGW7EFSR2beOwittYxFQxajqMvYG76Dt80WNUSdTC4wufqs2zXeE7p90zUiSTsK+DgTQYoK8wvKeB1jZ0ZtnW7omI95WlLUOM51e5OXcd9BCuLuRGSkLy7z8MKAKCG4r7PRFAKul7KG94Nw0tIPL8Sd6hX/OSUc6wJkelcghLgpTbUt5MTz3OIMjGnCUqyPv6lPztJ6dVDftXtFnQaVPvP+gGfAUhbIkbsgUtRDzxIzFaKioUwrKVDoVjrXTeiNsMCvqoAgCmcpYgdXmJcyT2YhFAyW0spTOIwkkMW9SRWlnruy16RfdJmd97eDDvh2tiGsRNX617sXoBszaoYWODKaAeQXD3G7xd1/J8TR5cA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 3:10=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Sun, Sep 07, 2025 at 09:49:49PM -0700, Lokesh Gidra wrote:
> > Prior discussion about this can be found at [1].
> >
> > rmap_walk() requires all folios, except non-KSM anon, to be locked. Thi=
s
> > implies that when threads update folio->mapping to an anon_vma with
> > different root (currently only done by UFFDIO MOVE), they have to
> > serialize against rmap_walk() with write-lock on the anon_vma, hurting
> > scalability. Furthermore, this necessitates rechecking anon_vma when
> > pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
> >
> > This can be simplified quite a bit by ensuring that rmap_walk() is
> > always called on locked folios. Among the few callers of rmap_walk() on
> > unlocked anon folios, shrink_active_list()->folio_referenced() is the
> > only performance critical one.
> >
> > shrink_active_list() doesn't act differently depending on what
> > folio_referenced() returns for an anon folio. So returning 1 when it
> > is contended, like in case of other folio types, wouldn't have any
> > negative impact.
> >
> > Furthermore, as David pointed out in the previous discussion [2], this
> > could potentially only affect R/O pages after fork as PG_anon_exclusive
> > is not set. But, such folios are already isolated (prior to calling
> > folio_referenced()) by grabbing a reference and clearing LRU, so
> > do_wp_page()->wp_can_reuse_anon_folio() would not reuse such folios
> > anyways.
> >
> > [1] https://lore.kernel.org/all/CA*EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5*4aD=
x5jh2DvY6UHg@mail.gmail.com
> > [2] https://lore.kernel.org/all/dc92aef8-757f-4432-923e-70d92d13fb37@re=
dhat.com
> >
> > CC: David Hildenbrand <david@redhat.com>
> > CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > CC: Harry Yoo <harry.yoo@oracle.com>
> > CC: Peter Xu <peterx@redhat.com>
> > CC: Suren Baghdasaryan <surenb@google.com>
> > CC: Barry Song <baohua@kernel.org>
> > CC: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > ---
> >  mm/damon/ops-common.c | 16 ++++------------
> >  mm/page_idle.c        |  8 ++------
> >  mm/rmap.c             | 40 ++++++++++------------------------------
> >  3 files changed, 16 insertions(+), 48 deletions(-)
> >
> > @@ -557,17 +554,6 @@ struct anon_vma *folio_lock_anon_vma_read(const st=
ruct folio *folio,
> >       anon_vma =3D (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_AN=
ON);
> >       root_anon_vma =3D READ_ONCE(anon_vma->root);
> >       if (down_read_trylock(&root_anon_vma->rwsem)) {
> > -             /*
> > -              * folio_move_anon_rmap() might have changed the anon_vma=
 as we
> > -              * might not hold the folio lock here.
> > -              */
> > -             if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
=3D
> > -                          anon_mapping)) {
> > -                     up_read(&root_anon_vma->rwsem);
> > -                     rcu_read_unlock();
> > -                     goto retry;
> > -             }
> > -
>
> folio_lock_anon_vma_read() can be called without folio lock in a path:
> memory_failure() -> kill_procs_now() -> collect_procs() ->
> collect_procs_anon().
>
Thanks for catching this. Fell off the cracks for me.

> Not sure why collect_procs_{anon,ksm,file,fsdax} do not use rmap_walk()
> functionality :/
>
> Should we take folio lock before calling kill_procs_now() in
> memory_failure()?

To me it seems minimal (and sufficient) to put the collect_procs()
call in kill_procs_now() inside folio lock's critical section.
>
> --
> Cheers,
> Harry / Hyeonggon

