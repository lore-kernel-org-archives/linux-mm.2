Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A671ACAC585
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 05:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0ABE8E0007; Tue,  9 Sep 2025 01:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB658E0001; Tue,  9 Sep 2025 01:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D15D8E0007; Tue,  9 Sep 2025 01:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1888E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:37:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19764B8455
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:37:59 +0000 (UTC)
X-FDA: 83868605478.20.2A9663F
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2BE1D160005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:37:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pQYxEt81;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757396277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aj6uuVr6aMDl/ncUa1LpZm4V0lxyD4WCQfrETfV8VE=;
	b=4bxRn8kojmCClxGWexjB8hj9mvX/QoAbFEPY9rHjhdj2AEETJQo/HTz/j6MUYfHU38qMrV
	KjXz+wRXpvSK9+gQqIDBFRyxu1FU56o1WM2sPpAY4YcHoWgBjqyMv4Pg+MVskT8BIKkq9P
	oYsK6u96LfPnZdVwkKz9iyVDUkQny7w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757396277; a=rsa-sha256;
	cv=none;
	b=I+aelDbemoqwHrR+Ml1c7Vl0zXnJ/P5JuJnnMZQ3BOCFsdkUQnCCMb12sjWvFucwCJA7EP
	PrTedX9+Gpnzem4FQT209Tnto7I0kNC58l0xiU1WTU2QBuIO8JUA2ldct8qcv0sHDyt/Gu
	koXC5g/nyGXE+2ozxlvHcH2QD0W3ums=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pQYxEt81;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61cfbb21fd1so21440a12.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 22:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757396275; x=1758001075; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2aj6uuVr6aMDl/ncUa1LpZm4V0lxyD4WCQfrETfV8VE=;
        b=pQYxEt81KjgJS6emS4UzloyAUWvEfXqRzka/R635u3gF1CaeG6ZDi4gXkpNJkT2Kub
         QpYcZIvzfYDGDGVAPvgVkz/pSauw6nIYimqeahpumRcwald+nz6N4SHeBH8F/Vk5G99r
         0Ixc/w2GcOXb031xWFvY0uCQptiSh16vE+QHP4xSkVAW30UF6+YbH9OOG3lR2rFaVXYe
         cUROOypiyFoFjord1u+3wbhrcdNq5m9rg9XnqLnCKhy+KmRVr1q6FoXkKz8oMvQExcDK
         /uSMXweCrmjibQr7RnGIqhky2fyegHwMS6Ch7y6VZ84ceGHvQYojQ00TgMoYLcHgwIu4
         PfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757396275; x=1758001075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2aj6uuVr6aMDl/ncUa1LpZm4V0lxyD4WCQfrETfV8VE=;
        b=fot844cCDFTpil3F/ANrAK6mHSzLLoAT9puU32kXtQ21ofguT6s5ZcxDTksKmZftzv
         311JmRyODNJvRHfWGmzXbbKUYiWquIZHMPUezRC8IhJmhz7tiWRdp/Tap0ohQkvMojyY
         ZjCXHHsG0Te8PG0FG2wlqQcotFSc5ZgYVC5mWDBh4u3ATMdE+AJEb1Q4N4qXuzSkWZrq
         p3dROiLy3f+hInA+HB4Tk6/vLEHLS4C/rAHLMU8DA13dt1dOf/MZIlxflBPw7sLkEDCe
         fu6eBBTOS7Bcz2ipkzcvnDvNBhEVNORE2WDrn69E7tuHuMllx2Ar8y4+rMd3FoKFEUAb
         l0kg==
X-Forwarded-Encrypted: i=1; AJvYcCU22T/sd6TYy51H/Gom/LNxoL6LtnwMHy7GFSS/AG8x4AVcvkHNdVIaMz3BZvMS7RBxWGa2ng1HWQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5yW1uzXVKpnVvIjnDMkm76bkz75o3u55cLDaIvzH7F+tVTKjB
	J+rZe1uz+N1xnHqFtZRImaOWrBwn0Q7OxoecLf6mbquSOuhDnpsJ+OViue6CgINmpXU+T/NJZsr
	Tx6UMPMjs6nEZry5wwqtt4uyQrrEvwsecoA4GVfsM
X-Gm-Gg: ASbGncun1sB9KRsp/fgIvdhFQD5Iwt1iE3NUhP6gohkLorkToK6ocxOw9ZQad0W/0Wl
	Pg74XrInH2tSSYNSACLi5X6nBjZgagUezbj0CpYUJzgPrrk1FFR6b6e/FRop5jJx1sh65da+jeK
	hxjz+qeQSJHPYrvcrhsKDtPaq0Tkgff/0hOg4gGWhNqP/VaV8Kvy+JkFmf/cBOfecLMED2enufI
	+eJCTgwQ618x1nrpIaO2uyCWIIgB7MrQchOLfCxALgYNecaaHRf90ZSFA==
X-Google-Smtp-Source: AGHT+IE2h8TSu1f2xlTHQNzRe2M4cO1d9LN+if2AzP4uw/DfT+W19/p6yOk0Sqok9Hqo2w25G9KQAq/6ayg8a1nUC9k=
X-Received: by 2002:a50:875a:0:b0:621:dc0f:6b2c with SMTP id
 4fb4d7f45d1cf-623d2c48760mr196588a12.1.1757396275344; Mon, 08 Sep 2025
 22:37:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com>
 <CA+EESO6H7zkgEOnmDEZoPL8+5EBD6UrJOBAvcU_gXyxCNZSOZw@mail.gmail.com> <CAGsJ_4zi6kb3fBC9e8GkjR2JTpiAN9rTCpb2HmRV3ri_kDWE6w@mail.gmail.com>
In-Reply-To: <CAGsJ_4zi6kb3fBC9e8GkjR2JTpiAN9rTCpb2HmRV3ri_kDWE6w@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Mon, 8 Sep 2025 22:37:43 -0700
X-Gm-Features: Ac12FXyVeaDucZMYToF6VX-RqpdE93vDIHjv1pimD0yo8dr-BsQ83JAnCHeowxs
Message-ID: <CA+EESO6bQRLkHWWEMu5-1QbwKptQDRkkEK4vf8oi1dH6mSz3OA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2BE1D160005
X-Stat-Signature: nqq8a4nd8p67d675pzq5crpa6a3hpkej
X-Rspam-User: 
X-HE-Tag: 1757396276-793669
X-HE-Meta: U2FsdGVkX18finPiDQvn3qJAFrIDRVvif+cEc79w/f9FJxK2wnDuMG8ohZy9A2pAFU4lucdoKdowaNN92dIakL+GktIOY0kRGs3TC8Fti2S04xDkEZmoUfp3gWAhbI2N74Uv/kNbC1nxcWaqW50miDUw/sVeY+RwmWGaSuNAZ1uBmNDamAYS8sYLsvE8DXp8ZUKMWfWzSEyV8Pf3kduCQ/lRKV4ON0Z5bePgHxK98Ozr5GjOL24/pEa3jWWU4b6ABxm5cSe+EZJ+Pq7W2I2/O3/Pmy9Q8K9HviljiVMk2Y0KqtH08H4DdXNvSZzx4WobVgPNtddaONu5lm0I8YK3ZcKJ0K9zPALPPWqmHchzWHO3xrW6ljSBTKPTcXX4bym7Nkx3joErsxcEf0EW/JoVK7nerXIqAwME41EzSCO+Ku5eXZnwmsVpA4XkEz3PvnbJnUQ+0Ywxj6fxUK/LKE016/WrPD1FOdPIRTpi3FJAMPY8SaUBVOOLs2H/keiAsQ0vK6v372y2o0Y1S3mnUPm7JOv+ivvjBt0x4QWHWxh2hVjZYRZAOn68CCQSaK2mQdljXo3UQA4qvES/hizccyYV1zYPEdmKwnSzTCjGKl6YaPw2/p5T2/kq4vla9k3K9X55y6qFmD+sOP1EQmghIq36I/mlonMXJALUw4iRenQ/p/f/6Tapv2W2ghtsBcxzNBom/xbeVmH//B8Cd2M6b2aNdjtvkiHdfEk7IWS95VM7IhGKmMpn/9bfWIsNnMxcxP0djidY9CCLLbVFoZiI6SL7tOt8d591m5LiyU1O6DPZodgkAe6cqZ6zixpxaXw3QFpFYARW0LVxljfsnjtNoJYd0Ccx5BAsTGVw+B4ubi1c5+kUNzez60OzXGY1E2hNxyIg3siTzTSVP++67TqodXyfheHmmn2EAxoIS7jt/3HHuZP5Bmf6kQ4eehgVRwku7U1WanPU5oo5C5Np8RiiPxt
 xQkOGTs1
 JspSsJftf9rKi2XSLtpB7sY4zZ4NPvPfbh5ea+NhHvgie0ghsDH+WF7NPd9ohkXH+8Rd02Ee0j+io6SwXsIEvU9CuU18S/P9xE/z+/kuk6EoYvLlXa3qnA4Zb145suIZG652DcM2P6jlDy9SWRydP1KmtmcEdVQnftmNx6rRpav6hNMJ9WF+ApJnuMJyfCVSyZR5EA68DI+phsN2X+Rq3N1U+63m232WDzst6seD6gLvL02hHFWbhUlbyK1CjzTUHKzq5LbW+3C81f6H7Ea25mhK6ES0prlcoi7GgL8QOyoPAmxjz7lGoEVFXfby8lkIgm8U1MswzlIzHs7g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 5:40=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Tue, Sep 9, 2025 at 6:12=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
> >
> > On Mon, Sep 8, 2025 at 2:47=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > On Mon, Sep 8, 2025 at 12:50=E2=80=AFPM Lokesh Gidra <lokeshgidra@goo=
gle.com> wrote:
> > > >
> > > > Prior discussion about this can be found at [1].
> > > >
> > > > rmap_walk() requires all folios, except non-KSM anon, to be locked.=
 This
> > > > implies that when threads update folio->mapping to an anon_vma with
> > > > different root (currently only done by UFFDIO MOVE), they have to
> > > > serialize against rmap_walk() with write-lock on the anon_vma, hurt=
ing
> > > > scalability. Furthermore, this necessitates rechecking anon_vma whe=
n
> > > > pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
> > > >
> > > > This can be simplified quite a bit by ensuring that rmap_walk() is
> > > > always called on locked folios. Among the few callers of rmap_walk(=
) on
> > > > unlocked anon folios, shrink_active_list()->folio_referenced() is t=
he
> > > > only performance critical one.
> > >
> > > As I understand it, shrink_inactive_list() also invokes folio_referen=
ced().
> > > Shouldn=E2=80=99t it be called just as often as shrink_active_list()?
> >
> > I'm only talking about those callers which call rmap_walk() without
> > locking anon folio. The
> > shrink_inactive_list()->folio_check_references()->folio_referenced()
> > path that you are talking about always locks the folio. So the
> > behavior in that case wouldn't change.
>
> Thanks for the clarification. Could you add a note about this if there
> is a v2?
>
Certainly, will do.
> > >
> > > >
> > > > shrink_active_list() doesn't act differently depending on what
> > > > folio_referenced() returns for an anon folio. So returning 1 when i=
t
> > > > is contended, like in case of other folio types, wouldn't have any
> > > > negative impact.
> > >
> > > A complaint was raised that the LRU could become slightly disordered:
> > > https://lore.kernel.org/linux-mm/20240219141703.3851-1-lipeifeng@oppo=
.com/
> > >
> > > We can re-test to confirm if this is the case.
> > The patch in the link you provided is suggesting to control try-lock
> > for anon_vma lock. But here we are dealing with folio lock. Not sure
> > if the ordering issue will be there in this case.
>
> Right. Not sure what percentage of folios will be contended; I assume
> it is minor. Maybe you could share some data on this in a v2?

Any suggestion on how (or which test/benchmark) would be good to
gather data on this?

IIUC, shink_active_list() doesn't behave any differently whether there
is contention or not, except when it's an executable file folio. So I
doubt such data would be any useful. Please correct me if I'm wrong.
>
> Thanks
> Barry

