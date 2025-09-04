Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2BAECA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A36F8E0009; Thu,  4 Sep 2025 13:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B8A8E0003; Thu,  4 Sep 2025 13:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0916F8E0009; Thu,  4 Sep 2025 13:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAEC18E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:51:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B55EC13AF47
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:51:27 +0000 (UTC)
X-FDA: 83852309814.16.A7E970D
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id D2CD7120008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:51:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C6tpe+Fa;
	spf=pass (imf29.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757008285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5f4CV7/Zq9AHWfcQkbq4wqzY80LXaCxVRDw6EMIrtQ=;
	b=7b6vsicDDrkqpUDVSsUIe5gY4mKgaBwV/k94RcCV93LC8djT4MU/Xm6fDGko2q+akcckKx
	9pBZ2Fwnp61PZDXGVxPSTFjn4f5946RoB2zjZmznV+ZqhBaedUwCVyUA+mt6F/Tj/qtGAX
	vJIKGNaWShxU5JwILCZhLHUs7+Eysws=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C6tpe+Fa;
	spf=pass (imf29.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757008285; a=rsa-sha256;
	cv=none;
	b=GhVqf00kwajctoxRpWBkW1KwmLnGkAXbgTYGKkWZ/KwuBlinteF+C8Nog1dYHe8OIKHOut
	w5Zyr8PNJDZv9vf79a4zVDX/jw41thdu3WNaky+GEWnpc4rViPGRoQVX/acVPI6qu9GqvF
	AZwwap0scI34gsQI831x9iAvJchCjZw=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24b2337d1bfso21015ad.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 10:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757008285; x=1757613085; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5f4CV7/Zq9AHWfcQkbq4wqzY80LXaCxVRDw6EMIrtQ=;
        b=C6tpe+FaVNUyTq3pofGLNYMWbu2MSKu+r/KEMNkA5gcC84QakYYWm8bR1kZI7BnXeH
         gMt+u+UA2B2ONgd0ZLSp5pJTuF1r98Y1wypckbE+7nPSgjxacnAswe94eJrlHE1Cx14y
         N9KcgqwH9h8xoCn7yhk6/xI2OtA0dXOmdOm2PT5Ba7XZPuj9BUV3pABkT+VeFq7vcjrg
         KaAK+IY0RUPf+7WhcnFPHt7B/r8bD4TJLaFWlTxhq3eXtpV8L8lD46WeS+HVOmoZTsnF
         vgQ/3BxrkZ2fncaFIWLLrakTl70ZthwXX73BAJD9uC9u9Hpzs8DcllbA3soc7k6V3Y8A
         n/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757008285; x=1757613085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S5f4CV7/Zq9AHWfcQkbq4wqzY80LXaCxVRDw6EMIrtQ=;
        b=b/YCoKWgyXiL+/1KoGpjALCtgsPDnbRFv3vc8/BPXhuvsZb41leMnMWBXaojRsA0rI
         znQDHKX4gk9b/v2WgMI9IGWGKxEeOSPfquLoQuAUYj4WdSvBEGV4wIN+KcGQHNaBTkAh
         0WUIxetQ/YBAXYrE/ocxDSe+rQf5xMuyTs8aMUcoNGDWxi4OWvuwXkBJls33yhxK/rbX
         hsqTI3qJA5IU4fkDLvj2p/QgJUKDmihieta8oUuICIpGlK2uKH+3p9o3Ak3QJFeD72EJ
         sJpj1iaYWbBSJ8w0SWA09qtpExdT5F6WDXm/7dSmn/IO4vrlsiZom4OwYOMI0dMSGFlY
         Ef7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUYlkckWx5HeCVTPlZIyafxjace7tH5e8NiApGlr5ofrJK4JrVBTUBKthJmTDxb8q4LUgy1bgfBdA==@kvack.org
X-Gm-Message-State: AOJu0YxoJOpioxBbECffOlBNwqiOE6vkPtb+ke/ivGNLZRXA+Y9V0pzb
	bmxp43lszYC6brHMIKHLRLfsVzo2MqFYbm81PFMCP98Ce5FDEI6ESfBtKNkO9UOtjnOUFskkgkt
	5pjw7fG41h+cQTHZtAyxKP51QhOoQv36GgGBc9GK+
X-Gm-Gg: ASbGnctynPGSwtlxl/SNx+r93g8MlR/Wl83opEXOoSA6uOeiaOSnZ++7oWNS1IHBrgB
	SrCPF9EWTU/f1H6rklojmlcjipUZNYVoMlgiBgGw43nDq309gGMs63cjIxIbRLf5XlOcrOXOf+s
	XZEdiJmTFD1hLfiZ+CbhNEny9isp5S0RmlbaJi9IbRo+26OmIeHEGpoZfyeKUfb+efvGo0JSG3h
	xqheRNRysWFVw7AD72xa+cHVPRK2C2nLDB2CTqu8PxUzIs6YECaN5o=
X-Google-Smtp-Source: AGHT+IE/3b8sPJKpYGeK7oU85pQOncW+STxSebtEdgTCPGH/HESFfdjgboseK2XGkBZX91Fw4LOcIAmv4JXkuThCDGs=
X-Received: by 2002:a17:903:283:b0:240:5c75:4d29 with SMTP id
 d9443c01a7336-24cf5994170mr241895ad.0.1757008284007; Thu, 04 Sep 2025
 10:51:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local> <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
 <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local> <84aad392-3bff-4f98-b612-5e9a046edb36@redhat.com>
In-Reply-To: <84aad392-3bff-4f98-b612-5e9a046edb36@redhat.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 4 Sep 2025 10:51:12 -0700
X-Gm-Features: Ac12FXyT6XQaoSAVRSJwX4zOcb1nmPXZsqOrxsSrYiMr1nQbN0UJKDP2mFJkfEk
Message-ID: <CAC_TJvc=5=iS8gCumJWqH5eF4XufFSogqtWHJmiH5WBN1A6gng@mail.gmail.com>
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	akpm@linux-foundation.org, minchan@kernel.org, kernel-team@android.com, 
	android-mm@google.com, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D2CD7120008
X-Stat-Signature: imqhaknt1r455shs84wtraahsfopmp6z
X-Rspam-User: 
X-HE-Tag: 1757008285-598005
X-HE-Meta: U2FsdGVkX19Q1f2wFAHcnDc3gnMP6NirTRXX3luW2TwnmcRjP+pDmDxsPA2G5KrI3rNzJvQNejJZlCmG8drlzSRsQ3iLgHp0/3Db0mNP9qiJKTQwfSxmy+MG5gQOZqrBXyHoW/mI81i/2U9Sbl1tZA5Zc+IQ1V4CDsWx0WlkpkmpLAuWoortFn+G5BLPI09S1gGljyfBB6hk/a1zHfU56Jv/Q3WdVdvgTYvh0isb6eC7h7U/H5KxjMafdQR9Sel++d79bdJSrOrG2dPejBbuV/V5BzX+v+R9YvMCwKyJm58BjC4MJEOATh7XX6IsSx8I9qjTpXonY4Ct3BZMrEAzBUWrJ9IpnZ1ySMTmCcHg2M3PKpnzPzCS3mZPvgAuguby4Mm5Pd5hCuYv8mDx6sUeOr5X0QLXaSoG2D+S8w4FZxG9t3nYFPeAQLBNRh+WEsNhh7M5+Jw163BuXuUMP7Q2AddD4O1SXl/cglvienT3O8/wzqvDXyKBM4W/ddiT0VfjwPjivwi4eDfnjBXpVnbGYdzWZ8URIXOuHIhIMZlB1AbLLMXp/jRGC9j4Bcj14hd4UyAT/D7trXb/g3XOhFzQPOvYGZFhcsKNxCkhsc8Z4LSc4vLKW0HTpUbCf6XmXXlji+KVPei6/xxrDoYOZN4bT8EtVLn6IIS1ov8urHqVpH2E0y7TxMomt9Aw55bdxVgYCRFW+LmyDG2UswAQbOGg/runoSglWQiFukKVUM8EyOT00pkk2Kzez0h3FViH071S4XMg0mQcVCzom6UCxUnWyozR3uYW6xtTGIQOMsRnFpHv4o4ULQ92ReUfG90v8DyZhBj7bGsbn2MUrVvbNdBzskTdCgxz22ulxF2onC6PKqUaKdLzA4eDJUHNKrKSt7f5dd0d/2bb7ctIs62kljJunqe1sV7ncqUYOICYCtgmSS0eFD+PTFpAVFOX6rLB5k1y0VDHiVfbLLNOMJU2ok+
 UBBsuRiM
 +miz6WlOfO4IuQUY8uW9UzUHdJUfB/Fnz3kjDC6i63gBj2tPtZY3khRPDh6c3H4BYv6SQpFV6Ig84TfwECCEcc22aNyYqO9vQIrU8H2yd+hzl3jCkss/oSaTls5PmT/+ftiBlGPG4s8Ujsi5lj4jYcMgzX9ARgCY7Qc6N3v+kw7Udzki+c1H2HN/sPGoo2O8pq73AFO4J9plyQaTgK/qPkMfgnLd9R+NCoDVW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 10:42=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 04.09.25 19:33, Lorenzo Stoakes wrote:
> > On Thu, Sep 04, 2025 at 01:22:51PM -0400, Liam R. Howlett wrote:
> >>>> diff --git a/mm/mremap.c b/mm/mremap.c
> >>>> index e618a706aff5..793fad58302c 100644
> >>>> --- a/mm/mremap.c
> >>>> +++ b/mm/mremap.c
> >>>> @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_=
remap_struct *vrm)
> >>>>     * We'd prefer to avoid failure later on in do_munmap:
> >>>>     * which may split one vma into three before unmapping.
> >>>>     */
> >>>> -  if (current->mm->map_count >=3D sysctl_max_map_count - 3)
> >>>> +  if (exceeds_max_map_count(current->mm, 4))
> >>>>            return -ENOMEM;
> >>>
> >>> In my version this would be:
> >>>
> >>>     if (map_count_capacity(current->mm) < 4)
> >>>             return -ENOMEM;
> >>>
> >>
> >> Someone could write map_count_capacity(current->mm) <=3D 4 and reintro=
duce
> >> what this is trying to solve.  And with the way it is written in this
> >> patch, someone could pass in the wrong number.
> >
> > Right, but I think 'capacity' is pretty clear here, if the caller does =
something
> > silly then that's on them...
> >
> >>
> >> I'm not sure this is worth doing.  There are places we allow the count
> >> to go higher.
> >
> > ...But yeah, it's kinda borderline as to how useful this is.
> >
> > I _do_ however like the 'put map count in one place statically' rather =
than
> > having a global, so a minimal version of this could be to just have a h=
elper
> > function that gets the sysctl_max_map_count, e.g.:
> >
> > if (current->mm->mmap_count >=3D max_map_count() - 3)
>
> I enjoy seeing sysctl_max_map_count hidden. But map_count_capacity() is
> even more readable, so I like it.
>
> I don't complete like the "capacity" term, but I cannot think of
> something better right now. Maybe something around "free" or
> "remaining", not sure.
>
> I also don't completely like "map_count" (I know, I know, we call it
> like that in structures), because it reminds me of the mapcount ...
> talking somehow about "vmas" would be quite clear.

Thanks David, my original implementation started with vma_limit() :).
Maybe something like vma_count_remaining() ?

-- Kalesh
>
> Anyhow, just as an inspiration my 2 cents ...
>
> --
> Cheers
>
> David / dhildenb
>

