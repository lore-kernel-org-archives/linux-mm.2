Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC42CCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E308E000B; Tue, 16 Sep 2025 18:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7AE8E0001; Tue, 16 Sep 2025 18:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A69F8E000B; Tue, 16 Sep 2025 18:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 05B6D8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:27:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9777C119A42
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:27:15 +0000 (UTC)
X-FDA: 83896550430.06.FBC74EA
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB753100005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:27:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W5e9dVZ3;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758061633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5oGqStTlrxjJJErw3FSyvsriDK+5H2PHCclCCKyPlI=;
	b=J3LFhP+fwFd7lgkHQ/L97gRWZB3tzykENMz88/7SQQN2+OU7aNasW3Z74+rGCapUzdkCJy
	dde6fRuBoWWbTq2T3moWI4Y4s3S0TJ8msq8PJXe7k3dl69G/WVz9QE9hEFhTeaVz6bp1wx
	U6D2YKzVfD9kNqImWWE7h390WB/8IKU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W5e9dVZ3;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758061633; a=rsa-sha256;
	cv=none;
	b=vuVLdHuv+JCdPrTRi++7CwlX9WpK7kksrRVhqensAiBzlQFQV+Z3XaKSLWasqcDxUD3kW0
	tlmzKFBZky539yh9vcd0hUGm8lISbR6+s/He1uQaosUAtnIeCLbOpETde2EXYaHIxQFYzt
	JXqZOQCWZe5rJdQAzxJKWM7wvZBbua8=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b796ff6d45so81401cf.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758061633; x=1758666433; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5oGqStTlrxjJJErw3FSyvsriDK+5H2PHCclCCKyPlI=;
        b=W5e9dVZ3nfIWcMTDURnL9AzLdjeVs2FoqPfS0Q0kICjG53GA5t96xFFPCIHbGkaXs3
         ZoSiBm+YuLyf8GVrI4VzfT2FIi0+S1Ba8KRKccGIdqqML6TNnKQLLyBs9g82mrIDwsL2
         DbYtKcBr8L9LEkzaT7WOUqfw0FnD97o4I73C2kTCnBLQtVCzLTfcezl7thXCJ1uOjHzP
         Jl31XD/T8PMUJpfFSVan71IFrEkA57uFeu21hKb4poPEL5zQ/Yb4jJarC29rzF3KFj24
         CYCAkikzOMoLspeEwU0e2QaGmOx8c1pIS82V+9t9+KCJZveFpyaZtq/Wz4jUGwwzD8r4
         cpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758061633; x=1758666433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5oGqStTlrxjJJErw3FSyvsriDK+5H2PHCclCCKyPlI=;
        b=P47tHd/IyLM4ZxtVNwk3iij4NzMbKlseXdkrrkhOdbquCoEvMRri8zqap2HkmKFPbq
         XT71PYcTeC7rpdYbxpu/LLOOWrMHxmWx2557iR6hKhBmFl0u3WfVWuJ5Y+mVRwaUFnEc
         XRsG4vuXXnLN1TJKSBh9zfQ62ePtF5Nh0N1rtTltYIRtjCDCvnCuNT29IamotE0BMlf2
         pbrAznIbHKkJbIBe7hv4xlm8Rhi5vAS0YPQydKHpNPcCaySvdyIlBTJbNg6ZxaIgxSdG
         izNThojxenkZjgvNC1aQAyJbZy07O8VxN8ldHWA2/78GyFzrjPnKX+2Iln+XSLQySa4h
         whCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIdrA/XqoJZTPj83LbF+YeKo4biQWhN432hkmN9tw4kJhESemaSEQw8APrqbN1ReU9po+f1iZuPg==@kvack.org
X-Gm-Message-State: AOJu0YzHRDMWJiZTVX1UCy/mqXfDeEKuv2JHL1Q7m8MZZrsjlxEYT7vb
	PtOjw1XKzSJEfNIFZJt74ksN/AEQi6kR914GGmnSzHH8u1sRvvbvEHWXQb/ppxOlNQPdTxH0MSk
	mcrjxhGnJ/qYlTsWgKjHAQwTchxVCMU/CRXVStil7
X-Gm-Gg: ASbGncs/i/Gv9lGP2UsnF8AW3t4PxodEuHDqtaRoA0xxdgSlewBUzzDTiJYMXqVGzUz
	eVm6euN+H3rncTWbZ1Clk4rI8P3cemEe/BA0VQ1C+a34aGdF9tQ79oTBu6x71PsJk2UFIFXIuUf
	6WScVtafbmWTh6HsXxF9LO32eSva6DoB/lz2x9IZpfLxh8aO1fMd9NUiCXgQ5Xpi2T6YYk6mWaS
	Udmmm6qVd8VGiM4u+bMbktmO/LZ84iIbkY/bQ1gZsQ7qz2FvAEj
X-Google-Smtp-Source: AGHT+IEUNWLGad5EmSZbszNpLgC7MWP+kbjMVYLNIGqPaE6Z5fcUumRp4YQSjQFFL5pYHmDte9ohw2TcDL5C7EMoxKg=
X-Received: by 2002:a05:622a:24a:b0:4b3:4ed0:c6f6 with SMTP id
 d75a77b69052e-4b9dedd96d1mr2412771cf.16.1758061632490; Tue, 16 Sep 2025
 15:27:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
 <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com>
 <a8519bca-ae16-4642-84a1-4038b12e8bb0@gmail.com> <CAJuCfpFJabb02OK8Rj08d7WU_7AM674i=vsZxzfw7i7h-PGftQ@mail.gmail.com>
 <e5e3d96a-d0aa-4466-8303-5a7e8f96bbe5@gmail.com> <CAJuCfpEULVxMixDjrk_xg7+3+97dkcMmkDd++BaR17X4tDSs6Q@mail.gmail.com>
In-Reply-To: <CAJuCfpEULVxMixDjrk_xg7+3+97dkcMmkDd++BaR17X4tDSs6Q@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Sep 2025 22:27:01 +0000
X-Gm-Features: AS18NWCkByc0Xrj59xTWaHu3gfBggFkAKq-qIvFSK4jhhtsFXnOzESI7IWk08is
Message-ID: <CAJuCfpGgVa9X7nXhqOUZWi+p+JGz1QofiXrTJ+BF=DU3m2-64w@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, kent.overstreet@linux.dev, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB753100005
X-Stat-Signature: 545fcyff9wuez4867sb4n96rq8zsqw5d
X-HE-Tag: 1758061633-355093
X-HE-Meta: U2FsdGVkX1+SY2KkLJzgaF0ayZ2uP+ebIDGbT9fow0RwTK4VYK0F+IXQ2ahPgxxXbkUsnzY8JInpX8fgxceUyoSZM4sIlwytIXGXZhmNxfmu363AhHG0JHgUMZqGNkVt0WuJHJXDPtkfvIjOsWZqzxABnYqYuoR0w8LQTfocjE7EKcXIEqKL2hJPm5FrxsQsT4bOUhpIZ3GYb1hR8Rj/pNk7mebx8ajaLjHOk4gr0j8rLwk5Dph7fsPTlVDHWl+rcgLQt/ud5yQKMT3WOwuZl3LLurW+elMrldw5bTkvVfXjIbY2Cy966VLdNKQomUKupZhuE2YiNt1vd+eQ9YoI99pvp5Ort5mbzJoQIr2t2twukUDMY7YM+UOgIPeREELhqLSwIj5Yj7EGfa48075XbvaGkJ9ZbctLnflrxppYGQq7Uo4vHZybzPdPxaQUwpvwTOtPjETlCiNaDdv+BpZt2qNOiKzGRmB/u+fN56GGmwvWnsPFrATAESxdX/JZQ3LDK5FbD4IBSANWOkMbvjz4F0Ms5B88SvU2JcGvgxm/D6m//yz7SUqLrYIs2O2+3sdpv//3eImwIY/0rtj7bKgwt53KPERcw9oHQfDPwQw0Vl8nUMWKO0mLuapgEOXfEqz8dW47S3uo5FA4346t9xITM/whwV71MLVp+P2DdIDC/TgRCw4LALtggk1WvA6F4ahkGogaEwj3UYGDoQx9GAZqh/iFGO4Gd4124fWQIba0Gnq/b//1SYVwe83Hyd11Z95EMtjSctScB4K2Wx6wvbiBL1zT60gzf0PzhUSs6ZpZA5jFBgiaBsjqt566+IDXUmJwRv6rigmsaPkZTiGrVirfFgXhwt8w0vF+yM4KUZllP5F2idGdeHXNFegvlLACND5OVQlDwfw3No9W2hIje8BZxrXTAK5mFaKtnz97WVPSxukcztDs7LwyzaEEWo9NY/yAn0Cz2i/WqkzTSCRpcvJ
 tg0McOaH
 g6Dd01abxJrqIOse10WNTpLESaoXREIPxpA5C6fb7/9lwelMMMc9kW6XF0iDcHyTGbK1rh+TkswgwqIB0bB9LEXEHE2l2V/SEqNUWgmSItbpsJq8Mfx/hpdIF+RG/qV4rp2bMcRlUP4ktWC9lzpvYZFZhiO/Pefr/8BFgxx5pz/OUc8VPJE9gNvfYujlzTZoalwaP9xRnmDyfyq0JWnrUY+mrj944qa7OiDgr4NYNxZKd16OYka5x6v7yOOkaZAUXW7VI1i7MWou83oBb0c+ALXEPJH2Yms+K4qDD0Qz5MwDwsy7ZmqhZ1FTjRkuIuxHBkwyTqdSCYLv2TpTdr+Xg9S/dvC2n1FQpDh4p6DfYopeZRNaphfxS0JJ1m2X2tyNJRA3JoHkNwh3FgR1BY/qI9LJ0aQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 10:26=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Tue, Sep 16, 2025 at 9:52=E2=80=AFPM Usama Arif <usamaarif642@gmail.co=
m> wrote:
> >
> >
> >
> > On 16/09/2025 22:46, Suren Baghdasaryan wrote:
> > > On Tue, Sep 16, 2025 at 2:11=E2=80=AFPM Usama Arif <usamaarif642@gmai=
l.com> wrote:
> > >>
> > >>
> > >>
> > >> On 16/09/2025 16:51, Suren Baghdasaryan wrote:
> > >>> On Tue, Sep 16, 2025 at 5:57=E2=80=AFAM Vlastimil Babka <vbabka@sus=
e.cz> wrote:
> > >>>>
> > >>>> On 9/16/25 01:02, Suren Baghdasaryan wrote:
> > >>>>> While rare, memory allocation profiling can contain inaccurate co=
unters
> > >>>>> if slab object extension vector allocation fails. That allocation=
 might
> > >>>>> succeed later but prior to that, slab allocations that would have=
 used
> > >>>>> that object extension vector will not be accounted for. To indica=
te
> > >>>>> incorrect counters, "accurate:no" marker is appended to the call =
site
> > >>>>> line in the /proc/allocinfo output.
> > >>>>> Bump up /proc/allocinfo version to reflect the change in the file=
 format
> > >>>>> and update documentation.
> > >>>>>
> > >>>>> Example output with invalid counters:
> > >>>>> allocinfo - version: 2.0
> > >>>>>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_=
setup_data_nodes
> > >>>>>            0        0 arch/x86/kernel/alternative.c:2090 func:alt=
ernatives_smp_module_add
> > >>>>>            0        0 arch/x86/kernel/alternative.c:127 func:__it=
s_alloc accurate:no
> > >>>>>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstat=
eregs_set
> > >>>>>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpst=
ate_realloc
> > >>>>>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:a=
rch_enable_hybrid_capacity_scale
> > >>>>>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258=
 func:init_amd_l3_attrs
> > >>>>>        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mc=
e_device_create accurate:no
> > >>>>>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:=
mce_gen_pool_create
> > >>>>>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce=
_threshold_create_device
> > >>>>>
> > >>>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > >>>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >>>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > >>>>> Acked-by: Usama Arif <usamaarif642@gmail.com>
> > >>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > >>>>
> > >>>> With this format you could instead print the accumulated size of a=
llocations
> > >>>> that could not allocate their objext (for the given tag). It shoul=
d be then
> > >>>> an upper bound of the actual error, because obviously we cannot re=
cognize
> > >>>> moments where these allocations are freed - so we don't know for w=
hich tag
> > >>>> to decrement. Maybe it could be more useful output than the yes/no
> > >>>> information, although of course require more storage in struct cod=
etag, so I
> > >>>> don't know if it's worth it.
> > >>>
> > >>> Yeah, I'm reluctant to add more fields to the codetag and increase =
the
> > >>> overhead until we have a usecases. If that happens and with the new
> > >>> format we can add something like error_size:<value> to indicate the
> > >>> amount of the error.
> > >>>
> > >>>>
> > >>>> Maybe a global counter of sum size for all these missed objexts co=
uld be
> > >>>> also maintained, and that wouldn't be an upper bound but an actual=
 current
> > >>>> error, that is if we can precisely determine that when freeing an =
object, we
> > >>>> don't have a tag to decrement because objext allocation had failed=
 on it and
> > >>>> thus that allocation had incremented this global error counter and=
 it's
> > >>>> correct to decrement it.
> > >>>
> > >>> That's a good idea and should be doable without too much overhead. =
Thanks!
> > >>> For the UAPI... I think for this case IOCTL would work and the use
> > >>> scenario would be that the user sees the "accurate:no" mark and iss=
ues
> > >>> ioctl command to retrieve this global counter value.
> > >>> Usama, since you initiated this feature request, do you think such =
a
> > >>> counter would be useful?
> > >>>
> > >>
> > >>
> > >> hmm, I really dont like suggesting changing /proc/allocinfo as it wi=
ll break parsers,
> > >> but it might be better to put it there?
> > >> If the value is in the file, I imagine people will be more prone to =
looking at it?
> > >> I am not completely sure if everyone will do an ioctl to try and fin=
d this out?
> > >> Especially if you just have infra that is just automatically collect=
ing info from
> > >> this file.
> > >
> > > The current file reports per-codetag data and not global counters. We
> > > could report it somewhere in the header but the first question to
> > > answer is: would this be really useful (not in a way of  "nice to
> > > have" but for a concrete usecase)? If not then I would suggest keepin=
g
> > > things simple until there is a need for it.
> > >
> >
> > I think its a nice to have. I can't think of a concrete usecase at pres=
ent.
> >
> > I guess a potential usecase is if you are trying to use memory allocati=
on
> > profiling to debug OOMs and the missed objects size is very large. I gu=
ess we
> > wont know until this happens, but I would hope this number is usually s=
mall.
>
> Hmm. Missing a large allocation and not knowing about it can be a problem=
...
> I'll start sketching a patch to see if tracking such a global counter
> has any drawbacks and in the meantime I'm open to suggestions on how
> to expose it to the userspace.
>
> About concerns on the IOCTL interface, would it be more usable if we
> get the alloctop [1] or a similar tool which can be used to easily
> issue such commands into kernel/tools?
>
> [1] https://android-review.git.corp.google.com/c/platform/system/memory/l=
ibmeminfo/+/3431860

Ugh, sorry. Externally accesible link would be
https://android-review.googlesource.com/c/platform/system/memory/libmeminfo=
/+/3431860

>
> >

