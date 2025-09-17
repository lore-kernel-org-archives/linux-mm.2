Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA60CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18AD8280008; Wed, 17 Sep 2025 14:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162A3280002; Wed, 17 Sep 2025 14:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0787D280008; Wed, 17 Sep 2025 14:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9C9D280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:27:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BB2F871EA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:27:14 +0000 (UTC)
X-FDA: 83899574388.19.29A6F5F
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 67FCEC0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:27:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AnEr7Bg8;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758133632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giOIiZmv6I8DqOhlCekUkvEcCR09Gm73BQos2pe6CNk=;
	b=72n0vnqFu0bbPHNzArQdYWOSwIoWVWHAoz4tLjCDvrlxaxDPtgweeHZgIzCNCxN0wVdk6H
	OBJY6ybCDY+jVJCheSbJ6khlkkpUnesJt1EME3ZTXiKq7yGgtjfb9H4rC/Em/hYWjPLF8v
	MU8d1tjk/T+KLQtkMlnAN/cJCaf+Wqo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AnEr7Bg8;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758133632; a=rsa-sha256;
	cv=none;
	b=zxEqx5a6cPnf1/Dxz+61btgLNc7E8Ngxe7q4GF373sFANWi3RyProji3OwWaIvFCeF9wxj
	D5AEwbyQcsYkELINqAyPqvmd+dDgyVYroiB0DvYtpogwbGRzG3pmidwhFS2rXNRPuXx9TZ
	NOi1AKjB2O5qV8sqKsmoPhr11UAg6+s=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3eb08d8d9e7so115318f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758133631; x=1758738431; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giOIiZmv6I8DqOhlCekUkvEcCR09Gm73BQos2pe6CNk=;
        b=AnEr7Bg8yoyTD4XH4RrMFUSrYtPQv1Sr7+h0ReXvzowFmEMiBreA7kWFyzlXudaemH
         IF+Of2kG9dh33Q9OIMtUg+zqLfRuRviJ5WlHdzkgGhRH+vsbnP7up0H18FvZyZTVn0XO
         owMgbTFdz+ncJKozqt11Yt18Mm3G4Fmy7GhJUj0Z+v2b16Qp93xspS8FR7OnUvuGiSBi
         JN+RHXpXSVE7vx6oPx4HVwQBjV/oNOvT14BzoUHhoVoBVkF1tqFePhA7e8yjetZlbRnO
         4EeHc4B1kBqODM7Bfd0+WaquOvhFHk5EHmHzCZhI0Pv9z529B7nrE6CZGj/+qOE0TW6T
         QzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758133631; x=1758738431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=giOIiZmv6I8DqOhlCekUkvEcCR09Gm73BQos2pe6CNk=;
        b=Bxxa2kWwaZnSI3s6pDD5i2uLK2xyrcaDKHbayiwUGrlRHloyKIem/XbSfkGJcQ8m9s
         Ezhvt+ebznPyAuXIPWwUwjLjnmq6Qv+x7trwmH3wniCh9dhCFRs5u5Co5tLeU829LMYN
         GZ07ED8GceTY2m7cm6JXwlaog/BOzmtz64IFx0XkTwKKwM8UU9uWMZW5Aw6KKIxpGbjJ
         GIOeo5IH9o18emT1qEI0vEJiJnydzbcTWLGGforihAoBO3L9tsWfvgHoyhmQ7ltp4ckN
         gbU2C/lP/63eetZtZNB7g207AQeEG79dADXbQ/+mlpx2Wfi8m83JLNqnBEA8BIe01QWn
         F2kw==
X-Forwarded-Encrypted: i=1; AJvYcCXiGWv/DLF3WiNgOTlrKjs8VUbe62WIJlfsl5D4wBZr8c4SlzyFRY5pDaWaVWXfV/5WjSugmmYfGQ==@kvack.org
X-Gm-Message-State: AOJu0Ywi4n9cinwVUGMqp4LFWFib9tcm3nMLIkzjmSJ/G9hSKYtSlFWa
	B/a5n0bDRxSF1LU7pbvyPpAfSoXoaSBbDQe58WiPlHPJpAhVIMeHYJhH5HhsoWB40GOHKUslAtZ
	toSE3pqHFvN+MiTrilBc7yNfVag2ZCco=
X-Gm-Gg: ASbGnctg3eRkdRol+e9criJuRo7G7NUelyg454shxTIPUA9amPhmsij6LO+fMBdnsP2
	2lA1r61MbuEKzTVtSoRACfIalXDMnuyrILALKrWf6rDKL8RYbSURqIKa1RxfUIREwBj7IWVLsfw
	j0ElHf+jjyYiJ3xNwII+QVK4vKRDDnvNkTsmcUkoAYnR8XoLx/dpk0wVQfBoO+ns2Y/oYA+vUj1
	V2pyM2DAaxFEdS9es+SVT8wKqoZYlCpWG3MKsQCDvLXdFg=
X-Google-Smtp-Source: AGHT+IGIjDIE66b7poTQjbUsClk+JTa8i87RedpfgKqXFvYZF5/Mwpf7vxUqOeoC4SPPIS3ebGzBC4ZDuD2hxOymUMo=
X-Received: by 2002:a05:6000:24c1:b0:3eb:2832:96c with SMTP id
 ffacd0b85a97d-3ede1c74f09mr448260f8f.31.1758133630484; Wed, 17 Sep 2025
 11:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
 <47aca3ca-a65b-4c0b-aaff-3a7bb6e484fe@suse.cz> <aMlZ8Au2MBikJgta@hyeyoo>
 <e7d1c20c-7164-4319-ac7e-9df0072a12ad@suse.cz> <CAADnVQLNm+0ZwX2MN_JK3ookGxpOGxEdwaaroQk+rGB401E8Jg@mail.gmail.com>
 <0beac436-1905-4542-aebe-92074aaea54f@suse.cz> <CAADnVQJbj3OqS9x6MOmnmHa=69ACVEKa=QX-KVAncyocjCn1AQ@mail.gmail.com>
 <c370486e-cb8f-4201-b70e-2bdddab9e642@suse.cz> <CAADnVQL6xGz8=NTDs=3wPfaEqxUjfQE98h5Q2ex-iyRs4yemiw@mail.gmail.com>
 <aMpdAVKZBLltOElH@hyeyoo> <aMpeADsz1Znaz8AU@hyeyoo>
In-Reply-To: <aMpeADsz1Znaz8AU@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 17 Sep 2025 11:26:57 -0700
X-Gm-Features: AS18NWAFnsgy5aitphu3UPL49R51UGNv6gxHVzc-JxbR8L-AQ1LExbbnhT_DQj0
Message-ID: <CAADnVQ+sKKV+-Ee61Bxma+=MN4unGLRypAnfqHuLOtHM6T=HEA@mail.gmail.com>
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ppmndsda1x1tznf134c8h35769f6fc3b
X-Rspam-User: 
X-Rspamd-Queue-Id: 67FCEC0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758133632-23153
X-HE-Meta: U2FsdGVkX18/j5E9yVlSSs+ibkqs9o59NodIv87DmVqxQyX+rKkTXMuk3J19sX7EqPmGlI/k7XuJxhZJBPUD/45XLmv72bBXOpWzH/mNhE2PdWUQqGyA6mHeGV/Esquwh5Le3mYIuN03mf4o/Q7La6IDoEkmMrZ2t7Cp5o4ZxGvBzZluHid2vTAkxBxioHX7c8b2Cw8h+8z1LvaO5HNPL5lvLNqUW2YamVPRYPHzE8EvReGWStHvfuarcgHVdBIsKhYDdgmvqFb22a3NFRCAjsy8Z6W6MH8z4uTsxk1Ke5EsD+mItBAYwDdoAEGQN+eDNhutUXJUx/kCA15eh4sGjYyYKwXsl3+9TwHBCNgSxzVfCEwPZERmfxiQELe3sF6CbWfDqCe1k6UgWRVdwLMiH5MjsEEYHhnIPOA24hj+XN6NUR1q1zmJspJb2tltGPdvdvng31AEDJwrDhGe7JdjBI9TnAyjIOdLWKiRmvJjYmiN4NYVSWzNEyWkltduek7OXbiHEw22U9zJV404XbLCSJHoytP13X2MOheknjFjY3ImXn4E9fk94d5bUT1c4pogi6HYbJSBHlnoH5XhTqjwp9dB0vMbxIVt28phx4OWECh+ZOpSSxyeUMy6WdN4gnMVj2/F+7WVOyEC9XNk+OV+dnEIMS2l787UOuBwx+o/uwKJin3TYqaceGdAbk3eN+r3daj1ZAGCCAl2Mjng8SKnQIpblnutmS5v9EY8qN6Xqg3uGO/swu5ZOiKPYekVTXpiLRfIxlmbtEvp2sDeuExD11i2/9cmiXVnr35T4XSWTRdHNuEG0dHvUU7N3czFuxGRkC+QQOKZ+GxFEO0BK0VyalAzO8zr2AZgmwPBMRjngoUmb0jHluOHXtvEa+GnHXchPG9ClzSPf8AipQca4UIlQgl8gg90n6V2/D8l4bBDtK4dSWZ/2kuJHIXm/ND9d5v2aBcx20OBQN41+0fbW5c
 MEYnHhE9
 e9095c4m6b4e9C6NYaCrutF6fwCsdwpdeO9eRbHnOTn5MW/16ExzDGDAO823QYprY2qD4eDcdRCy0dN4iDcQqY20P7TLMHMSXLKjY/hnr6b628VWrWb5imTh7OPSdDGBQY/NLE9F6qw3d9oW7Vzrmn3XNBtP8FzhktvttYNM0VH0Upcwi/lZPQl9jm5+cOG6sEsWqsMV9H+Ja3YSOvyIzsZpAw43qBFnaF7V7/5XrFDsVMwKhoam44cCEhGdlp+LpGwTACKY4XCyr5MX1Jz2fX61kowivwuvskeldn4inR9zhWS/Up4z1OHX/8Bea8rsjch7sF2nQqlUUWx/MnTnLxWl8glkd7EklIRkyssi3jpfLmyB9/Atufe8d2R6xWaevC9l5+Gi5NSZo028YUMEgc27YwOylulf1iwTh/eRqcxH7dsTqA3jBt/eeTUmwnSIZx6B35KviIMRMkC4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:06=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> w=
rote:
>
> On Wed, Sep 17, 2025 at 04:02:25PM +0900, Harry Yoo wrote:
> > On Tue, Sep 16, 2025 at 01:26:53PM -0700, Alexei Starovoitov wrote:
> > > On Tue, Sep 16, 2025 at 12:06=E2=80=AFPM Vlastimil Babka <vbabka@suse=
.cz> wrote:
> > > > > It's ok to call __update_cpu_freelist_fast(). It won't break anyt=
hing.
> > > > > Because only nmi can make this cpu to be in the middle of freelis=
t update.
> > > >
> > > > You're right, freeing uses the "slowpath" (local_lock protected ins=
tead of
> > > > cmpxchg16b) c->freelist manipulation only on RT. So we can't preemp=
t it with
> > > > a kprobe on !RT because it doesn't exist there at all.
> >
> > Right.
> >
> > > > The only one is in ___slab_alloc() and that's covered.
> >
> > Right.
> >
> > and this is a question not relevant to reentrant kmalloc:
> >
> > On PREEMPT_RT, disabling fastpath in the alloc path makes sense because
> > both paths updates c->freelist, but in the free path, by disabling the
> > lockless fastpath, what are we protecting against?
> >
> > the free fastpath updates c->freelist but not slab->freelist, and
> > the free slowpath updates slab->freelist but not c->freelist?
> >
> > I failed to imagine how things can go wrong if we enable the lockless
> > fastpath in the free path.
>
> Oops, sorry. it slipped my mind. Things can go wrong if the free fastpath
> is executed while the alloc slowpath is executing and gets preempted.

Agree. All that is very tricky. Probably worth adding a comment.
Long term though I think RT folks needs to reconsider the lack of
fastpath. My gut feel is that overall kernel performance is poor on RT
due to this. sheaves might help though.

