Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22307CAC582
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794458E0008; Fri, 12 Sep 2025 20:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BE78E0001; Fri, 12 Sep 2025 20:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6818A8E0008; Fri, 12 Sep 2025 20:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53EB98E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:36:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DAFB11B0E4
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:36:27 +0000 (UTC)
X-FDA: 83882360814.18.61FBFE0
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4089940005
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:36:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rfve12J7;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757723785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Wan4Z3V9G+Yu/kG1/ZnuX3JBevOSUX+l3Jo1t5U2io=;
	b=u3ed8UAdDlD2ns5HTLDDhD6sdauPlipCDt16WZ/JOTZJVZmyks1QB00ophiwebnN9f+jb1
	3d8iV0sYw5dDdidvwAhm3dfuEcKsGM158ZRUeN+AtcXYmE4kN9U1nWPtro3eafCv5PhJtT
	zfKmJA5naBjF/x9Hs948FRt/DL0NZ4U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rfve12J7;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757723785; a=rsa-sha256;
	cv=none;
	b=B/TLqJxydkY+stN6uZLgjBZHhNpMk/1WUIllFxIG31lizw0Vw3vAQWSM1FUHw6JplDYCKw
	+e3LwffsQPedSsHD9bQlz/hUVmusxMruo0HW8TYfCLmuhoHLFIQrdqJF2hJC5QmtEDyd3S
	H0P/DatJipZrzzaSv8xMtVYW9eEcfmc=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b350971a2eso33271cf.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757723784; x=1758328584; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Wan4Z3V9G+Yu/kG1/ZnuX3JBevOSUX+l3Jo1t5U2io=;
        b=Rfve12J7ZoEVrO5EyqwX3E3bYQRq6rgJzq9/imzd1yAgpb6+RKx157Wu4wT0XDG8Jx
         A9Av+XaGwN0DwZDffv6bqOA0ASomxyvfZpSQISnCG/1VGJeMTg2LLHDLniSQIBJEI4pV
         RkzaO+QVncZHI7QZcEd5lPH4qAiWuD7pzHLVGxqiIQ8RmprCJTWSrmmzAir8KfT+2HNO
         eMYiV+NAOEFno3+kjcVZrBw6MNrhCWv0D18LtwuMasEjcaNptyeR/ndSUAwUyvtItTav
         /1NCgpyZ6zOPb+K7q9KxK1Ffy6mfopmiDeZPkDc8FDz0gld7EH9b3aLWE6AuYnZK6dGS
         G2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757723784; x=1758328584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Wan4Z3V9G+Yu/kG1/ZnuX3JBevOSUX+l3Jo1t5U2io=;
        b=wCrJpIZMS/1Rxy2aPHFo6ArTw1m9MTUDbbGrvF6wfqhyVKDejhruYxdVv432WLvuuv
         T3B5LUoVzb4qZfxjGu/ilMZEMG0SBO4nEuhf8GZ0LyJKIDjcpE6rXUddIyXq6k+4M5rX
         vwTzGBhhpNeJVrkjrtwoMBDafFwKsFPoh14e9Jkyx0GhZsMxq7WITvgWmCA53/KvYNDx
         75GdK2w2axLvyWPn8zfHAKcSnqy2ouRbBPQoTCD1aet2e4OUcyAxm0yvdpts/74rst2x
         S1iAF89WzVcAArBdw9SHn8hGlLCpXsBDz85XEUx+daOXDKn3t/n1q4Ed3mUmWBCwZeQ/
         rblw==
X-Forwarded-Encrypted: i=1; AJvYcCXlVc8tGVJM8oJkbo8ndY0hphYgUHSLOk3VQBekGxPh6KtK0+UJHGzO/gCEAdoCq1URD7A1WWxF7w==@kvack.org
X-Gm-Message-State: AOJu0YyUt6EDA9apdjvJw7UzX9iuzjqP5QUv7Ou7unYOroc7eDmPt1V+
	S4uKa9LH1O7M6LqRUCegggb60lbAfD+Lfhf/mQleB+04LwL3DzTDdgA50HtxvjCFDTqHW3JFOdO
	9St4IHf8eF6P7DljBQPysc4oFjS80DAe+uQH2c/Ls
X-Gm-Gg: ASbGncslhQdp52XBhfHbkTgLeiSMDFs+4BzSGECu3f1NVPQc0D9ESdOGZ+hgh6xTP/e
	vkZaTOsaFozU8tSNA2qce/rt+K23pS3upAUAW/I5ikfChOBXxaIJCDoxDhAAhYOpGTc48fs+4mL
	NQJXvtQ6jnsNznNg8o1yzLkYIlj6zl7hSLUc/wyyu2HV7IS2cItZW1Aj87baAIhj6GNo88cvUpI
	HJUcKa5D2f1+cz4BMzBum4=
X-Google-Smtp-Source: AGHT+IFjG8vIiW+56UbAo0I3E5fAj5f02Da+QCHTuQCtweYt/HXvNwzme/tdanRWJGZZnJXNkHXrnhitPMAtBKAkNs8=
X-Received: by 2002:ac8:5715:0:b0:4b3:1617:e616 with SMTP id
 d75a77b69052e-4b78c61e620mr1215981cf.16.1757723783978; Fri, 12 Sep 2025
 17:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
 <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
 <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
 <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
 <CAADnVQJuAo5K417ZZ77AA1LM5uZr5O2v1dRrEEue-v39zGVyVw@mail.gmail.com> <rfwbbfu4364xwgrjs7ygucm6ch5g7xvdsdhxi52mfeuew3stgi@tfzlxg3kek3x>
In-Reply-To: <rfwbbfu4364xwgrjs7ygucm6ch5g7xvdsdhxi52mfeuew3stgi@tfzlxg3kek3x>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 12 Sep 2025 17:36:12 -0700
X-Gm-Features: AS18NWBAOP8pYtIGHCZnkTwegvOoC88LO41POkcXbpJwFGUAlXXbIlzzwU7_iKc
Message-ID: <CAJuCfpHJEUypV2HWRHqE598kr-1Nz_DokMz_UgrUnq8YkFcb9w@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4089940005
X-Stat-Signature: zigzts4wq63j77adx9isk8877m3hg5wg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757723785-889599
X-HE-Meta: U2FsdGVkX19RVaSU02lwE7nhCdgwOijwJdfH292aJeT8M1uixejqau5QPzzuNGrLpTSAULJ9ioQRwqwiG3+/xTEnmpGWOlZgZoQrnszrUbN9yWrWLZXkxdkBzOR0m8GPJ1qy1FejsbDtHsS0LEf2Wz+/OWs0+DOZ13D0FQ59z+LAcarcSNDPKX3MZflClf+2E1JwGm0zUnyJhkvNfFZuA50u0989eKwpwhUN4+EcpEySbscX/RKpSTc6VI0K7WQePnPsQ0YOyShrvTQsZtZCORBwCTePi2zgqx41IjHO2JZLCDae0eOsxe+RoY/PjKhm8M6stwVoAkaFgW23oalgOaNwhAVuNXDHUWcDnunkxQssEG2OL9tkGpf6UlBSMcSRK3c+cuw0DNYrj3KaFGiHWX9bbvwcyBI6wY9p3Skd+/nHab4inBfYgncDk6u+B8107IMoJRjp+GxvV/D50CqgqQfglcjl7HArABWuEV7eh1/SWvCQr9cg/mWejB80Ae7BI1TEnnGGF0GnOJ3NzygM5sGLw/g2QFzwl7JZpOXEETbwnw6uag+Lmmm3eJb/v7wEvlrnKKLMvMTGX8aEl2cWNRaaxbm4J6ZITxwKGmQZtu/+kcOanG/IwQLtaMm6WgtJ4svNI2a7N+/b2rmDW+1J7RntqmGh2NlnqBE7yiuWg/GucRJbel4LHVi6JRZqmYHYcJMc8XLsiLpSDzOrBjie4gJyQpbu4w1CHd069CZS0A74c7ADdUxyXaDo9VH5uCieSMQpyCv4dxWLf62ciCS6rB+vsrHLT9T85U4oyi1VWxDX5Utd5CP1wmj18in75NjERD6KEMtXVCCePnmRD6mcxBI4xN1oLBIoeu3uvq/Kq5syBKCHeZLuzQEZppDrR6siD9eMW37lyFC3CEiA8Ipip68QI6xaZDaJ7ueLB+PY7oYFgabVAqL0zELSI1KJRQwthMmTEhR7fzy5pqVAETs
 J2JvJCw9
 D40nmeSn7iVlmrc2uknnJli1zGzEQWPXV6g49p7PpQorj+vZy6YsUqdXmm3/bIS6HqdjobjJu3ljh4KwEKSKdBGQeujm32xJb45qhj/9YnqUkw9fsPtkwjWPruycWv9cTwdgyuS8cp5KPdH0BovOF8S88LO8h6HDUK/5WsWJfcqYWI8K6mw//pIus5z9QviPqS6GBBTTAd5dhzFUtQm8liwnj55DBRuN4TjMqwZeXz3FZwyZDey3qJcFcqE1Fx66sbhx1WPG8Y4NPaHs0HosfTSeoUM+KyQbF8w9aKBTOln7N6fanmFNXHwCWfNiE3H6WqfK+v88yUjbudCBV3CZM6JJ2P2oTfUukDfRBwXcmfIf6GMI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 5:33=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 12, 2025 at 05:07:59PM -0700, Alexei Starovoitov wrote:
> > On Fri, Sep 12, 2025 at 5:02=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Fri, Sep 12, 2025 at 02:59:08PM -0700, Alexei Starovoitov wrote:
> > > > On Fri, Sep 12, 2025 at 2:44=E2=80=AFPM Shakeel Butt <shakeel.butt@=
linux.dev> wrote:
> > > > >
> > > > > On Fri, Sep 12, 2025 at 02:31:47PM -0700, Alexei Starovoitov wrot=
e:
> > > > > > On Fri, Sep 12, 2025 at 2:29=E2=80=AFPM Shakeel Butt <shakeel.b=
utt@linux.dev> wrote:
> > > > > > >
> > > > > > > On Fri, Sep 12, 2025 at 02:24:26PM -0700, Alexei Starovoitov =
wrote:
> > > > > > > > On Fri, Sep 12, 2025 at 2:03=E2=80=AFPM Suren Baghdasaryan =
<surenb@google.com> wrote:
> > > > > > > > >
> > > > > > > > > On Fri, Sep 12, 2025 at 12:27=E2=80=AFPM Shakeel Butt <sh=
akeel.butt@linux.dev> wrote:
> > > > > > > > > >
> > > > > > > > > > +Suren, Roman
> > > > > > > > > >
> > > > > > > > > > On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starov=
oitov wrote:
> > > > > > > > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > > > > > > > >
> > > > > > > > > > > Since the combination of valid upper bits in slab->ob=
j_exts with
> > > > > > > > > > > OBJEXTS_ALLOC_FAIL bit can never happen,
> > > > > > > > > > > use OBJEXTS_ALLOC_FAIL =3D=3D (1ull << 0) as a magic =
sentinel
> > > > > > > > > > > instead of (1ull << 2) to free up bit 2.
> > > > > > > > > > >
> > > > > > > > > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > > > > > > >
> > > > > > > > > > Are we low on bits that we need to do this or is this g=
ood to have
> > > > > > > > > > optimization but not required?
> > > > > > > > >
> > > > > > > > > That's a good question. After this change MEMCG_DATA_OBJE=
XTS and
> > > > > > > > > OBJEXTS_ALLOC_FAIL will have the same value and they are =
used with the
> > > > > > > > > same field (page->memcg_data and slab->obj_exts are alias=
es). Even if
> > > > > > > > > page_memcg_data_flags can never be used for slab pages I =
think
> > > > > > > > > overlapping these bits is not a good idea and creates add=
itional
> > > > > > > > > risks. Unless there is a good reason to do this I would a=
dvise against
> > > > > > > > > it.
> > > > > > > >
> > > > > > > > Completely disagree. You both missed the long discussion
> > > > > > > > during v4. The other alternative was to increase alignment
> > > > > > > > and waste memory. Saving the bit is obviously cleaner.
> > > > > > > > The next patch is using the saved bit.
> > > > > > >
> > > > > > > I will check out that discussion and it would be good to summ=
arize that
> > > > > > > in the commit message.
> > > > > >
> > > > > > Disgaree. It's not a job of a small commit to summarize all opt=
ions
> > > > > > that were discussed on the list. That's what the cover letter i=
s for
> > > > > > and there there are links to all previous threads.
> > > > >
> > > > > Currently the commit message is only telling what the patch is do=
ing and
> > > > > is missing the 'why' part and I think adding the 'why' part would=
 make it
> > > > > better for future readers i.e. less effort to find why this is be=
ing
> > > > > done this way. (Anyways this is just a nit from me)
> > > >
> > > > I think 'why' here is obvious. Free the bit to use it later.
> > > > From time to time people add a sentence like
> > > > "this bit will be used in the next patch",
> > > > but I never do this and sometimes remove it from other people's
> > > > commits, since "in the next patch" is plenty ambiguous and not help=
ful.
> > >
> > > Yes, the part about the freed bit being used in later patch was clear=
.
> > > The part about if we really need it was not obvious and if I understa=
nd
> > > the discussion at [1] (relevant text below), it was not required but
> > > good to have.
> > > ```
> > >         > I was going to say "add a new flag to enum objext_flags",
> > >         > but all lower 3 bits of slab->obj_exts pointer are already =
in use? oh...
> > >         >
> > >         > Maybe need a magic trick to add one more flag,
> > >         > like always align the size with 16?
> > >         >
> > >         > In practice that should not lead to increase in memory cons=
umption
> > >         > anyway because most of the kmalloc-* sizes are already at l=
east
> > >         > 16 bytes aligned.
> > >
> > >         Yes. That's an option, but I think we can do better.
> > >         OBJEXTS_ALLOC_FAIL doesn't need to consume the bit.
> > > ```
> > >
> > > Anyways no objection from me but Harry had a followup request [2]:
> > > ```
> > >         This will work, but it would be helpful to add a comment clar=
ifying that
> > >         when bit 0 is set with valid upper bits, it indicates
> > >         MEMCG_DATA_OBJEXTS, but when the upper bits are all zero, it =
indicates
> > >         OBJEXTS_ALLOC_FAIL.
> > >
> > >         When someone looks at the code without checking history it mi=
ght not
> > >         be obvious at first glance.
> > > ```
> > >
> > > I think the above requested comment would be really useful.
> >
> > ... and that comment was added. pretty much verbatim copy paste
> > of the above. Don't you see it in the patch?
>
> Haha it seems I am blind, yup it is there.
>
> >
> > > Suren is
> > > fixing the condition of VM_BUG_ON_PAGE() in slab_obj_exts(). With thi=
s
> > > patch, I think, that condition will need to be changed again.
> >
> > That's orthogonal and I'm not convinced it's correct.
> > slab_obj_exts() is doing the right thing. afaict.
>
> Currently we have
>
> VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS))
>
> but it should be (before your patch) something like:
>
> VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS | OBJEXTS_ALL=
OC_FAIL)))
>
> After your patch, hmmm, the previous one would be right again and the
> newer one will be the same as the previous due to aliasing. This patch
> doesn't need to touch that VM_BUG. Older kernels will need to move to
> the second condition though.

Correct. Currently slab_obj_exts() will issue a warning when (obj_exts
=3D=3D OBJEXTS_ALLOC_FAIL), which is a perfectly valid state indicating
that previous allocation of the vector failed due to memory
exhaustion. Changing that warning to:

VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS |
OBJEXTS_ALLOC_FAIL)))

will correctly avoid this warning and after your change will still
work. (MEMCG_DATA_OBJEXTS | OBJEXTS_ALLOC_FAIL) when
(MEMCG_DATA_OBJEXTS =3D=3D OBJEXTS_ALLOC_FAIL) is technically unnecessary
but is good for documenting the conditions we are checking.

