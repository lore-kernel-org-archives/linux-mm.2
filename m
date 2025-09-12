Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43C1ECAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E168E0007; Fri, 12 Sep 2025 17:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE9C8E0002; Fri, 12 Sep 2025 17:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD408E0007; Fri, 12 Sep 2025 17:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 472118E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:59:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF8E11A09C3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:59:22 +0000 (UTC)
X-FDA: 83881964964.16.150DA81
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id E96FA180003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:59:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HFIznFew;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757714361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZFaD5oyiRAoOLBuEZcvlYJuqNMd+CQKfb8R9bWF8Eg=;
	b=X/RlFq5LdTrVkwe8ZxdcnlV0mjvTVzJM3tdhM2ITYWa6NNy2fB9G61t8qGIkFSU5cyidb0
	sfQ0ULe43Jauk32Z3VwWOuoslIcJThoiqc5jZuT/duSmdoEvgWITBqQVZ2aTc1SUT3ru5/
	VKegxG36uEAvwe+qcVYpwCMA8VWSQ0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757714361; a=rsa-sha256;
	cv=none;
	b=ghIL/cZzknnNerv56FgGrFkU8zIhb6s2erCmhm/v/+GgCqHr09ftK7SFFzsH9uHTP6X8L2
	tAmek+N9bXBHBT24Bc1EpRZIvO0tn3OHC1BNTeW68E3MyHo4PhPtJG9G02OVoBxS9kuGoy
	y02rfePZ4lXBvfTVwRqZm8+dhy0fetE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HFIznFew;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45df09c7128so19843255e9.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757714359; x=1758319159; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NZFaD5oyiRAoOLBuEZcvlYJuqNMd+CQKfb8R9bWF8Eg=;
        b=HFIznFewgsLXsZVbNVIqRdXsMxUG0VwoQKdCCjlNyGMRwv9DXpgVZXEXwSTijrBe6e
         lAHWdthfyqBrW6/faD1knFoXwNWfzdx1PTmG3yh1wFPS5dKiclawVVskDVJwNzzumcnK
         T0lN0kyOrRUpFL890KTWVw4C5bY6cmekHHvQr0tQULbC92JaImGIbGCf9uX9ht8fYRX4
         PXQg7/M3h/E2Bg8J1CAAfQP1scJcFjrWe7ZGhIVTSNRt9X8UYvMlxOLMPE6aqz2DrUMk
         uwAA8I/DzQQPo/vgBV8KfV3MRhG+N59y3ID3tIXVJVgkP03S2L5lcoxFGNgGF/QCn3vZ
         d2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757714359; x=1758319159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NZFaD5oyiRAoOLBuEZcvlYJuqNMd+CQKfb8R9bWF8Eg=;
        b=N0az2NkVIJxL1uYsyJif0/udnddNhLzzglzTIiZDKvIMryICnV/2NHxOfNWrws4shO
         gRBUJ1uTnOvRudWhdeMsqmsrvCy6MwXzOlmjM/+9vXWysYVpo29BRjFbvlTVDMuN3gjH
         hWAfUo/dEXcpaxHGFL3YoJoGTWCMT/FFg8UmxsEsN7WafUL8aoJUcG2QR080b+R5np7b
         ZnY4qZDtbhQ39vBXn/nxpcGKGoPk/eHc3MKwOldAeezBCINR+Ro5CVTYJHyxIaaJmAUe
         xZwlZ8rs0oAQVynVAcsRXQg8kBVYI1YwF2BV7L1cWZBIXg1K8lzU/KGjOSDMdbyRBt+4
         GS9A==
X-Forwarded-Encrypted: i=1; AJvYcCWbMqd1g1wE4XmcJXGlzUyijAx+mhmawvSgjG59y0C+bvZlXqoh03BqyzSG1nlXnrRDn85piwIHWw==@kvack.org
X-Gm-Message-State: AOJu0YyxK2Gflbv8OIYHAWhQSLybLBkC01700IOL6ASFybA/VXm3Uica
	VThfX6XHWJdmnx2m+giF6x+gCP7+9ik3vwEeqvp2rgigMyeyxS/BEvijy7BwZG621A+31Lab93e
	YryzEsQj3hdXok2vnlF0aBdu+aUFXn+s=
X-Gm-Gg: ASbGnctpFrtbuULmspukDTZ3IKYUPW3Yc5F836HuTtcgu2nuxY8+OOpLsJF/V137Jn3
	3oNkpf52DaoLbVLBIwZu7xQRtDBJYjcWyaiWqMJHQoNh+MUD4xF67O6ghU7fxIBYRIphz+qVowj
	nUHxVor6uTNPy7mESjeZ7aZj4I1t60F1f/NLbVimJQ9RZ+uudypTApOtXVfwmr7wh7oXkXsoA8m
	4mvOh3D2puLmEck1s5JVrtgQe/JpUwwejRcNy12Ro2/QtY=
X-Google-Smtp-Source: AGHT+IEj5hCxNC661gWndefrK0QFWrEBg3qrCVagAwTeaWebQwq+mCJEkQC4fnaq2I7BeFFFGHNJ6BjP9R+zaCJ8vC4=
X-Received: by 2002:a05:600c:1f13:b0:45d:d79c:7503 with SMTP id
 5b1f17b1804b1-45f2128cc58mr44251025e9.12.1757714359396; Fri, 12 Sep 2025
 14:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com> <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com> <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
In-Reply-To: <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 12 Sep 2025 14:59:08 -0700
X-Gm-Features: AS18NWB0F8pNvh3GzUKMDxADrrXIaRl6ltZK30yA_21OC0u6XClr7XbCRoVpX0s
Message-ID: <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9jw3ob7hwz1nes9ng34qrdqbnw7mw5j5
X-Rspamd-Queue-Id: E96FA180003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757714360-866783
X-HE-Meta: U2FsdGVkX1/KocVWzLpMhc7Pj3Yg1Ze5HyQbJMT0If1FtKYJLQuUgZKqzIAQoaoQZ90LrPJlb1HGjlyRNsBmW470rSMhveuZ53T/TrbE25tykYQCbIE2EgsaBtG35RJIhVnZ2Mv4aHZ6AvmgkHXcIOAkQVOjDEHqYMRa5nJKx0RChxSZSJY7r7BgjznF7M1pD8EHFf3USo6EfsSy8U4pUjxhzxwXMtEEmBJmDKv0fzvoGe/YHStOEgM+EYS4/mlaf2bn2MH27CjU4DEcALoT57HUmiBYePkQxIBEPf5BrLw6SvVErdxRUpmPJDj25x1nivHGAQxH2iZWioslpISc/IFOSiQBOWPB75YXi0mjppoKHmKuPKQsQkRWbtrzZfBYvXz6zG7WHVKzxnkmpJBx0WD+qYlVJKwVVBN+5zXpvBOKtYrw7LkckF7piV+hm9AoFOa/mccAYknFCtAYCRNzW/5/AjP0pXSG0E3Q4o0Z2zqW8hQzpvzG+GdkRTikl9MyMH2MvnRbhnEmWWCjMBRjWSVXikedD+gfxnjiFBTl2uhERuD9W2mHkGSmsQfC06xAkyjNOCih/6fiaINuQCiFuTZl+4MTv6KiwBkpJRcHtUx7CuK5RfEu2lT9v9WrAIXvCaTgI2kw6Y1aTJKVoJgKsPrr+r8vzrR5l2Cpb05lmKjt+abrfek/u95IVi/Cn5GtjqxKBmBMUmUoiJHQRrKv8a9sP6Gj1ptonq8cFlYExtVP/vuRe0iHo42akaZmPLLSyyrhKVOwAxnqysDyhEOgDaFNey6pkUnPCoNl/BiV7u9ujnQCNqyT1hXbk00uqHkRZuH0EoztOjNtVaGTYsnoRlwMp8e+v70jBTQoapz0+qP8iTxKfP82hJM10N8mYhCmKit1PIk9NDTVf5KRrVmiTlnADQ1+JlstgawHxgGL1lctpCfptaYoui/Ig8PGbXuAYAf0SqUfxIzUPJwlMeG
 Dj5WXvIC
 PF+WNDI4Ev3rQz0kKBS/sRsGRLEzqwm9/RCLGi2On/lVxNp4YspqLBqrX+RYZW0k4DKDvRwB+HwugIwoplh+vgV1ILxQHxs8FCBAibdkWovwM0daEiCh9YN0hjoeGynoy5m38zv/Qu8rSQC+Hmhi9E4qrgW6GnWybkYGKqGprdm7ENHth1ASvLxiDvAOhjTwMpKAtmYC30W3qbAGi3vI9y3Ba/ZgAlwrkXY5LJs1WJPgBdBwVF0H1nskeu/yZNK8a8QENumFFd0QGMpPK0gyOPWVoh91k2SCnrWtpBSUktYO5oGmjmJxzbC6wfo2e8Yu66bBePLgeSE2kyDFGPSiHuDnfQriYm5KdPK4m/iId0sHdTpB6XQcq310O5+6oDk+vqCZyxd9F/KjnqPNLffsMYA4cn73x/y9n72P64A6swk0IvBIHk1IN1vbbykFC5Ok2XMLg31MxgY7VwGKo457n824nBKw1xHnNI3wejdPjiH57N+8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 2:44=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 12, 2025 at 02:31:47PM -0700, Alexei Starovoitov wrote:
> > On Fri, Sep 12, 2025 at 2:29=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Fri, Sep 12, 2025 at 02:24:26PM -0700, Alexei Starovoitov wrote:
> > > > On Fri, Sep 12, 2025 at 2:03=E2=80=AFPM Suren Baghdasaryan <surenb@=
google.com> wrote:
> > > > >
> > > > > On Fri, Sep 12, 2025 at 12:27=E2=80=AFPM Shakeel Butt <shakeel.bu=
tt@linux.dev> wrote:
> > > > > >
> > > > > > +Suren, Roman
> > > > > >
> > > > > > On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wr=
ote:
> > > > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > > > >
> > > > > > > Since the combination of valid upper bits in slab->obj_exts w=
ith
> > > > > > > OBJEXTS_ALLOC_FAIL bit can never happen,
> > > > > > > use OBJEXTS_ALLOC_FAIL =3D=3D (1ull << 0) as a magic sentinel
> > > > > > > instead of (1ull << 2) to free up bit 2.
> > > > > > >
> > > > > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > > >
> > > > > > Are we low on bits that we need to do this or is this good to h=
ave
> > > > > > optimization but not required?
> > > > >
> > > > > That's a good question. After this change MEMCG_DATA_OBJEXTS and
> > > > > OBJEXTS_ALLOC_FAIL will have the same value and they are used wit=
h the
> > > > > same field (page->memcg_data and slab->obj_exts are aliases). Eve=
n if
> > > > > page_memcg_data_flags can never be used for slab pages I think
> > > > > overlapping these bits is not a good idea and creates additional
> > > > > risks. Unless there is a good reason to do this I would advise ag=
ainst
> > > > > it.
> > > >
> > > > Completely disagree. You both missed the long discussion
> > > > during v4. The other alternative was to increase alignment
> > > > and waste memory. Saving the bit is obviously cleaner.
> > > > The next patch is using the saved bit.
> > >
> > > I will check out that discussion and it would be good to summarize th=
at
> > > in the commit message.
> >
> > Disgaree. It's not a job of a small commit to summarize all options
> > that were discussed on the list. That's what the cover letter is for
> > and there there are links to all previous threads.
>
> Currently the commit message is only telling what the patch is doing and
> is missing the 'why' part and I think adding the 'why' part would make it
> better for future readers i.e. less effort to find why this is being
> done this way. (Anyways this is just a nit from me)

I think 'why' here is obvious. Free the bit to use it later.
From time to time people add a sentence like
"this bit will be used in the next patch",
but I never do this and sometimes remove it from other people's
commits, since "in the next patch" is plenty ambiguous and not helpful.

