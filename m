Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18FBC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72BD26B0092; Mon, 28 Jul 2025 13:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704026B0093; Mon, 28 Jul 2025 13:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640BC6B0095; Mon, 28 Jul 2025 13:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5491A6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:55:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0623C038F
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:55:25 +0000 (UTC)
X-FDA: 83714425410.08.730175F
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 11A17180006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:55:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zYVnc0T7;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753725324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQxxK6RbpQQjsAWFxkV8xT67PH0plChmN0vYEGz1peg=;
	b=tSq4guE9HOSjnHbgSkWhzaxhICvhxrTH1i8fQsYwxpWRUwruFch8nQ/Pd91DlDLqHr/03p
	KVypMmKZ2L8ot6YA6HoKN51/fVuZCzWELyOqblBp577zOO2ooLWsDqPgG5gmgfxRQfjd7N
	mqfvxP4Pzk4JfLXLgoh84AwGvAgpmWw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zYVnc0T7;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753725324; a=rsa-sha256;
	cv=none;
	b=Be5hfBBBaLTWr7S5ht5rxGCjfwgs8VKP/7ZPGPmVnXkDF8N+DJRfg0YZj0zg6vHsqV8qLt
	uKqva+mE/itAJY/PvY4gCh4pXWlmrThM9Gi4/Y2thAULQvHuM06tiSLUEWDvHHQH0mX4Gg
	90cXGTdiqT6RTMG9EGHD1P0qIwltO/w=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ab3855fca3so39351cf.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725323; x=1754330123; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQxxK6RbpQQjsAWFxkV8xT67PH0plChmN0vYEGz1peg=;
        b=zYVnc0T7GFE9PULGuH4RTMxsL90CCWBv7z2stZaGWEcnI54JENerSaOdGR+ls6RAD+
         1TpymsmImjaJXbfwFEYzRYQMTielWdJvpNBKOHfvXkxgM/wHSqPyjkipyFZcavxdxsvP
         zhoXlhQKnKpSkiipBjsRD+vHekIc7UV3Q6W/XMlTiSuECBvLkJsBkeMrW6UQrJOb2GqO
         Yd87wYgPf0dMq7cQTFTliwTZdOMveet/afTl097+lz8zrPy0NtYRtI4qsLkU3QRU9rTh
         lUNDa4RVfjNAgVs/dZOli8U2bGfGB9xGhBvhwBkpu1ka3G7uNEkjuMS1zB9sSPMfPh9L
         6gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725323; x=1754330123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CQxxK6RbpQQjsAWFxkV8xT67PH0plChmN0vYEGz1peg=;
        b=p4JUMCCz4bAWCFutfWVisCY0uXfKO6W+y937S/kObfICg81rfY/aip9WFeuvoAG7iU
         uls7csTyvuDRbYM7pJjAWgWD3g6Ysm1/3pQwJr667tyM7j7DB4f4EoQ3WxJwHV6162S4
         c9ypenCiXGJRQc+EWpPjAlBiJf66cUjnKsASvn/we9lzYXaabP73s99wbbIH1vfGX6tE
         ISA1U7xmmlXUAnRhrXMqhyYGPgDwRVCbSZ3WUAnz1VUGx+yMBgHnJQEaorP0XuqABrR3
         Krg3+dt/uCY33YcW52mPKkHnmRRlSVYHwg+0h2nfxHUgFEr+WwyzcPNJAKaF75X6uq6I
         +cRg==
X-Forwarded-Encrypted: i=1; AJvYcCUGzLWGnhKwS8gDUDxRhTR5z2bfYxkbNjDMQoXlEjMrxKe5CPbK/5UImDh8bTbOJ/o2zDilZvMMfg==@kvack.org
X-Gm-Message-State: AOJu0YzrG2UWW31NyY3z1UC/IC88YpaUYrGNerBy2t2M3N4x/g97ON8G
	mZ4w80MDr4zQPEmcwTKeZL6M2zdcZZ09C89QF9qFKXyPknDLnogg8KFxvFlYib+zc+29LUl9/In
	ratPgbSGlnUzBFRoXnPtPUqiZAL7Gn983535afy/R8GWfLAGCLSnSMH/s+LQ=
X-Gm-Gg: ASbGncs42b3L2ul40mv0DbjM5X0lLqdsUNfaPziOOTIPamY0kA5zYQmWgXLe5erpNWx
	nJtmICggetz/CKqQaS9HLu5QxG/9DIXrpAWyeSPuuD7xMhzA0ULE/0mGjcUwxFOGDSGnKsLXGuq
	9SHXSdp9d9v9KTBEnB1M4JRooxCs++nzxIhtxz2tUXFOEpEOLfLMjd0QvipQ3+rMbW5IyX1riHZ
	mB2bGv6qqwACqU1qN3Ph+a9AkCjxf0o+NU6Dg==
X-Google-Smtp-Source: AGHT+IFFnoxBnnNVScW/VpJt6pjdkyu/boiKhrUJzdPlXt0VAhjFqNpn6IGuDGg/1A36+VHGOxFhSv/p5MrjmKydpFI=
X-Received: by 2002:ac8:5a43:0:b0:49d:88d0:145 with SMTP id
 d75a77b69052e-4aecdec4fdemr7141cf.23.1753725322548; Mon, 28 Jul 2025 10:55:22
 -0700 (PDT)
MIME-Version: 1.0
References: <20250728170950.2216966-1-surenb@google.com> <3f8c28f4-6935-4581-83ec-d3bc1e6c400e@suse.cz>
 <CAJuCfpGZXGF_k_QVQqHWZpnypB-sWB8hwZeOYMOD0xmAFOBxkA@mail.gmail.com>
 <97938dc6-5dfe-4591-ba53-3729934c1235@suse.cz> <CAJuCfpHgyzQxmAiriFM59KGi465ocxH6T5nBSBY1fcUazOj9Gw@mail.gmail.com>
In-Reply-To: <CAJuCfpHgyzQxmAiriFM59KGi465ocxH6T5nBSBY1fcUazOj9Gw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 28 Jul 2025 10:55:11 -0700
X-Gm-Features: Ac12FXzlgFF7itYZWvvVBXrV-1oKF1zTqyNKqehylT5HcvvNfhoWPx9GYVarnJM
Message-ID: <CAJuCfpF3543giq6vHuBbmLuxjUYVxNub6PgTzu0M3Zfe0H2xGA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9rx6kgrngk3iqw5694gdncnddfrxt5yy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 11A17180006
X-Rspam-User: 
X-HE-Tag: 1753725323-241547
X-HE-Meta: U2FsdGVkX19H9Kdq5yP6XNewY00mqvvJ6aUOGNgQmsYM+G1AxRIMC/55+Drtbup8o1A2oIw5fPXUADymOAyM7OfcyPxj1d397t/fXnDwgx1hiiZh7u3YEMHEG+/Iys8n0lloOkLJ2i2eG9tWrH3JmSiEIgUgYQhc40/QBlgkdGgVn+MPAQmZh7Ie7cOgM/wR9DNHUxEZ3KxGfPDvAgXpGhyvaYwe2Tb7K+2iBY0N1tXsDRXCRIEqNi0FXQSZLFeHCrAOWy3RTbqPthoGvKK+lx51qYXW4CQG1sWId/uMojVHKcRWXe9fph60cpQWAtQn5ckhATjWNB0G9Hp6kUuN1ENjIhBezvZecE53cF5EHNSJcNxiK6y1+gLjyShxKpoRx3uqRo93vWTa/Ic9GxI58lL4pe5X7Bzwpr64Slwg8de3Iu0FiKUxFFFrc6cS1wN2KHCcAe4SrAWVL0YPJgIzdn64m2pmxHhvvXfiN4gma3dVTFnyggrdxV4n9eVxE4J4pbM8HqxaWH3qQzVqNcgXmtLXpu6QSpDbuiCCN63ybNBQZWkBCtGxlfffC/2QxHKKw2/RpmQPWsU2DDP0KgA2++cNazp+dpUJNElHtsEI4fAFYt/CAUgkZZPPcMq+61cYH/ai2LV5uKrOA9Tn1WcPM5E2xu0kVBzts6BO5muNu1PylTOGHvf9aDu5TPrqTq/nOAGhHvdaOXq+32Rz6onuPVpQIYV1A8cUgZQIf2HLNfA8LT+wzrVxsjATtHola9DzmRf7VP6u1IbGmAqCV6otm6SBYFzXJ/o6zbMtsrGJpi6jW0kB4uxAHF3gcqgxE6YZ7znwrsWzgu6k4znYrZGM4t8nUMnmVkMH0ik++z6HJQZc0OSAFx9sUiqbTyBf6vwsLI6HPTPmnDBgD1kC91HH1RRrWsUyDVlGGTBQpklp790DgKzbRScQw25i3795ZfKaacNClj2N5rZodUxh8Xf
 4uCP43g2
 8Nl3cxggOtU3XRLnbmi8RhlLJtgbhATVEWnKulwEGUNE3mu0zUI+XXfmj2TEYahJDK7XqknFmhrv2JozwvuB9AM2k89tse+v6/tvNrYrgZ8tS3/4SyQCVmSrsB5DTwMCr8MNNLOF+1zesIbHzvR1Vni3R5clif1q1xEqllE3l+UoLvGYpDyN9TDeBxnlxWErh+jmRE6aVdV1ncQe63Xq6NBd+u0b9Uv8lMvwYd84X8/V+GBkUD3jyGmRk63pSFF1gwm6crhJutw5uoiFoUUUnbN836Wz7000Az5DH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:43=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Mon, Jul 28, 2025 at 10:39=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz>=
 wrote:
> >
> > On 7/28/25 19:37, Suren Baghdasaryan wrote:
> > > On Mon, Jul 28, 2025 at 10:19=E2=80=AFAM Vlastimil Babka <vbabka@suse=
.cz> wrote:
> > >> > +      */
> > >> > +     if (unlikely(vma->vm_mm !=3D mm)) {
> > >> > +             /*
> > >> > +              * __mmdrop() is a heavy operation and we don't need=
 RCU
> > >> > +              * protection here. Release RCU lock during these op=
erations.
> > >> > +              */
> > >> > +             rcu_read_unlock();
> > >> > +             mmgrab(vma->vm_mm);
> > >> > +             vma_refcount_put(vma);
> > >>
> > >> The vma can go away here.
> > >
> > > No, the vma can't go away here because we are holding vm_refcnt. So,
> > > the vma and its mm are stable up until vma_refcount_put() drops
> > > vm_refcnt.
> >
> > But that's exactly what we're doing here?
>
> Ah, you are right. At the time of mmdrop() call the vma is already
> unstable. Let me fix it by copying the mm like we do in
> vma_refcount_put().

Fixed in v2: https://lore.kernel.org/all/20250728175355.2282375-1-surenb@go=
ogle.com/
Thanks!

>
> >
> > >>
> > >> > +             mmdrop(vma->vm_mm);
> >
> > And here we reference the vma again?
> >
> > >> So we need to copy the vma->vm_mm first?
> > >>
> > >> > +             rcu_read_lock();
> > >> > +             return NULL;
> > >> > +     }
> > >> > +
> > >> >       /*
> > >> >        * Overflow of vm_lock_seq/mm_lock_seq might produce false l=
ocked result.
> > >> >        * False unlocked result is impossible because we modify and=
 check

