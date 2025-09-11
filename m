Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA6ACAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E2A6B0006; Thu, 11 Sep 2025 12:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F5E66B0007; Thu, 11 Sep 2025 12:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BBC6B0008; Thu, 11 Sep 2025 12:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5E26B0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:51:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D45111DF150
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:51:47 +0000 (UTC)
X-FDA: 83877561054.20.21F47C9
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9C2040013
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:51:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KvjS25IT;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757609505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M56OV+DCbPOvXLXatH4lyJjMsHmjtzZ/ztacBy9y41M=;
	b=Ps6Q+Qm6wz8ixxiOvRWuNhRa7MkyinAea7CQgbhlpmFXvdJWTNlPKxUpM5YVnvsZI9Kpqj
	cDT53Fafc4CEJt6kWJw0NWkf8DrPsqA6yGS/a89SCeLPXv5vCAP0Uq+X6RdvasR1iHuMdj
	OC29DnCjRLTmkL37yqw93cQoprSF10I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KvjS25IT;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757609506; a=rsa-sha256;
	cv=none;
	b=Ip4HDjSEK+CmEKZePqPAPLa6LRlzvpB7MVRNgAgf66EEIFTTkaFHc/biWYeQ6M6elW6LLc
	ZAE5kIqvXPG0y59QFIrxwNJYFYaS4gUws5Xc3Lzwtm4Zr+9wl8gQY/6PMKUkW+M+QGX4NL
	x6EtwJTLn/vMtiNUxsHdwMhC59b99T0=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so16021cf.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757609505; x=1758214305; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M56OV+DCbPOvXLXatH4lyJjMsHmjtzZ/ztacBy9y41M=;
        b=KvjS25ITAhoWJl8fS+fxvByiaE78sLIVV21u2tfUquj7wiCXXTRZBR5X6lslv8b8+8
         HOAz9wBvGtLQmjlq/AdR+Trx/0ONT51AMmFQnUM1hvRI4oqrgMzshINvSB94GoBkuXEk
         qBk0lkfcvDFyw1L0Fxx/hnFCJegcIH3lR1E4g3FK6btOj43MvDplx+wC+8GpKQkfHIOm
         KSfa6e+vkvBcAjNzN/szYCj0R1Ib+b4pY5F/rPttCZXYdDNRmpTxBG7y9BoUBgoRytPh
         OeIaiPY6F1iXulsCzxArzJBQOVg0c5iIPuJZZ7JUU9Z8ZOBjhn+cZJul452wEY6agdrM
         Vzqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757609505; x=1758214305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M56OV+DCbPOvXLXatH4lyJjMsHmjtzZ/ztacBy9y41M=;
        b=HGNqKbJB7Lo4JaQZH9Se/tysprXi6LAQfZbsxKqODrdduHVVCOdi4cvSeUMMj1vHG9
         DabkwqeePb5Gy3BBxg1IsMFyFf1Tra2donAQ4bbIbhWZ+w8yxui0fc2SAw1SGQrH3h+D
         fXa5vnN4OobBZrcgI9xRdq55vfyowjhTk/qNtLvScohi8NYjwvjzfaKZ8Wvhhhx827mQ
         YRab2z0vHIFuM3fX0bW7CleMARYr11rKuzXwb89zdN/34Jt1fbEdvjkxmbO3YnSqfSbC
         iJeZxUu2eg9mSyd1Iv8TE+5luRmLJ1KQGhzf8n1EhXAXBWQ9uzXPdrYYlVY2rSWXRS6+
         ksQg==
X-Forwarded-Encrypted: i=1; AJvYcCVvgnZcM4L0o0lQ2m6A9cu6s2TgkEF79MbuotpDXb9nzcuDwWZqZKDPshrz2XscpmFFZJunOToz7Q==@kvack.org
X-Gm-Message-State: AOJu0YzqiWxW6nPFnxs0eQoc0Opmp/8CX5GR4GTQko5vSP0b36s0Nx5u
	lk9UrdhtJsNrW+gOSkPc8gDM+i8yUEC99dahrra2XpyrrtAZSh+ak5vNHLvbJizmH0L4C/bXKR3
	27xXaQdsXHVORJEEDjd2vRXAeMF1lTQ3ZGkYX4gTg
X-Gm-Gg: ASbGnctQ52VpQHcte6EZyRjsFovmRVicSWdOQBUOgue4Lf/BlIepFDykNJ9Rz8FcxhE
	0fLnJUNLnanWwIp1uuLfyq3uIN/8FRbIhBU+7W9eqru13Ly+lGlWPWQv0zhW+14xkJitZietbtL
	7GomqIBru6wiKf/5RMPULIrpOuOdCeJmieuhRnF5Q5bDtt46bLIohksHPRODtNczeC9eubzrpyv
	ktTesReSZxnfm64iso/ODO7pOE2I4RyFObnRFEGej6mq1F8Y1qY0TU=
X-Google-Smtp-Source: AGHT+IE+bObvDrZuyNPMo3PXWKyy8l5K3qtIDPqLnf9byW1C3+RMAG6A1j1o4bWTifLLF8jRBy/MYjGCUIpfRUBT0ug=
X-Received: by 2002:ac8:5e13:0:b0:4b5:e600:3d6a with SMTP id
 d75a77b69052e-4b625201ec7mr16575921cf.12.1757609504431; Thu, 11 Sep 2025
 09:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-8-Liam.Howlett@oracle.com> <CAJuCfpG4D4ikZO1c8zN7HNgLTAco1ggk21rg9AUFwoztA95qSA@mail.gmail.com>
 <dfd8b8c6-d697-4032-be2a-569b9629c564@lucifer.local>
In-Reply-To: <dfd8b8c6-d697-4032-be2a-569b9629c564@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Sep 2025 09:51:33 -0700
X-Gm-Features: AS18NWBeIrwsUJ0dxrLNZRQOjzHmferGdajI1AcDlFbkpGG2ylvimaJ6frwN608
Message-ID: <CAJuCfpGFXbSFnqQtikNq0RoMfc93cLLnqrApq8211H+FpZpJ1Q@mail.gmail.com>
Subject: Re: [PATCH v1 7/9] mm: Introduce unmap_desc struct to reduce function arguments
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, 
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E9C2040013
X-Stat-Signature: omcpfgck7ism8uniew1upmmenifbti6a
X-HE-Tag: 1757609505-361894
X-HE-Meta: U2FsdGVkX18UCUVatEXw/Pq9dnyNOACDLMts1OjAyFxGuvNq81ijUDIz59hRWpIO+MP5lrIZaAZv6fMQgL7fuT6Ah/M8bOjk3yKZz3/Km4C5DQhNGt1H1C2TxwfhUMqq2O4L442x2x+nf2tABowFZtCma/CI3ofRvOjK5ffLxZJkFxnsdL7aKUc5YzdOg57KS1F1yyhT+G+t9/y2OMcUcRZXfF+8QtIY4tLr1dkMSz1Bm5y7hFxjN7StGA8mWtdxgY0djtsczU8j6KMaYSxGDFkuqmd5to9syfBmgqCAufAYkJbyKSPdAr34fsZTmOiXdYYKTFn9UzTZmLUO/ct3cBLMx+iyA6VU/OZbwl+G/r/AJ3AZ8Sc/7CE+xA5PmliDdfmraPHc8LAXhEw794pJLRiVDn6axiiQALF41aIqBKa3yNuTJuoIfdKYdZNP7RbR/Wak8ut+n8GbYgZvFsMswwZKFM1mJwFgkHdZGg3k2k92ft+u/69e56z/jcciENhaxnq2k9LgvfDjBTf2kx4FmGwzSJcdKDnFr/oKM/ofaV9xPcc3VvdDGzyE9MfGAt3BsBcMoVZaP8y3amViTcpvrOIQYzs+8jS5GupSoonwdYe4zn0fP+aqOxa8w6njus4Y4mtl5LGJeZqZ06sQaLantXyQJ14IUv5gpxuQZpRz70Q/r8tLHgIIoZfANY06Fk2q2i8AZ35lHshUY5DZ0hh04v5ly/dvVrDFDerIwC3pPmZEjwE8KicbYI639xKGk+AwabbBIReBJk90zqyiZ756GZxyC9hpvCrngDb7YF6qUxw2qpQucPm/nrvCBCq2iLDl74YBq3EEdc41tGK0gNSYvobnFjWWAKKCTBNilFQhHotKcqFyuaG7khT+KIVnPiNL3lKKeC0TzNXP/IHdR8pjIv/yU6fYcjOkLDX4mPYKIjWL0/Guod2rwfXDV9vf7WO3XsUy2+Id1QH7IGx6c/w
 VMO/1mkL
 NILa0fqueC1qccJhLX295DilnnDSkeusZZmmjHi/GY1CAiMqgr1oiKE5VRNC9PA6nhqRcY5YaW9wZa7kSJwKQj6kOcgboTElC1dcPXR34uTwwhWigdLnynz4DkIox8Ke+AsTSHbl/isfqr6X1C0r7gzfz0muj2Rn6uAlvmQx3kKuMMyk2aifFF56WQvpg+mliIcBHKWAbbXjsmnFBJp+v7WxmrmgAmUsyvZeHzCnrnWGuhFpwvO9r3pgk13p992zjWPdD27jn5oPawQY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 2:22=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Sep 09, 2025 at 02:44:05PM -0700, Suren Baghdasaryan wrote:
> > On Tue, Sep 9, 2025 at 12:11=E2=80=AFPM Liam R. Howlett <Liam.Howlett@o=
racle.com> wrote:
> > > +struct unmap_desc {
> > > +       struct  ma_state *mas;        /* the maple state point to the=
 first vma */
> > > +       struct vm_area_struct *first; /* The first vma */
> > > +       unsigned long first_pgaddr;   /* The first pagetable address =
to free */
> > > +       unsigned long last_pgaddr;    /* The last pagetable address t=
o free */
> > > +       unsigned long vma_min;        /* The min vma address */
> > > +       unsigned long vma_max;        /* The max vma address */
> > > +       unsigned long tree_max;       /* Maximum for the vma tree sea=
rch */
> > > +       unsigned long tree_reset;     /* Where to reset the vma tree =
walk */
> > > +       bool mm_wr_locked;            /* If the mmap write lock is he=
ld */
> > > +};
> > > +
> > > +#define UNMAP_REGION(name, _vmi, _vma, _vma_min, _vma_max, _prev, _n=
ext)      \
> >
> > Maybe DEFINE_UNMAP_REGION() similar to DEFINE_PER_CPU() or DEFINE_SPINL=
OCK()?
>
> Look at MMAP_STATE(), VMG_MMAP_STATE() for precedent in vma.c

Yeah but UNMAP_REGION() sounds like an action while MMAP_STATE(),
VMG_MMAP_STATE() do not. Anyway, whatever works I guess.

