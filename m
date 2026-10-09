Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 049E5CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A9F6B0095; Fri,  9 Oct 2026 13:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB45F6B0096; Fri,  9 Oct 2026 13:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C946B0098; Fri,  9 Oct 2026 13:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 827B46B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:43:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0AF31C3987
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:43:05 +0000 (UTC)
X-FDA: 85303808730.02.B368F88
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id E6A8910000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:43:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GkR+ChZ2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791567783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tsYcDTlJd+/drqourkl2rTNqD7M7lEs3TS0VGr4BI8=;
	b=FE8VzhY36Z/krAlDl3reJkFVvF3hA/NhPic4f0XdBJRwTl2yyTBYZ3+Wwfcb+krJOkmC06
	ejQJTqsKMGyTEWkfR3nSpT2S+yJ62O6KIPlTF171pH+VV8xdzL21FJdxfj+GszMffSiMp3
	vDXE5Wj1G3monjrPRd8OOXY4WXdudVg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GkR+ChZ2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791567783;
	b=0uF+aWXKm5e1Pk8sfT8uwDS/dkVFtt71JKb7sbtvtu8SZTSLNe9vTCGtZEAQz744qWvI2G
	8tEwh1YOVP6qGNLJLAuX3rChPXlIpGxgJdG7OvCRZc+6c9RTNUNrMcogjEE9E5CSDlOHlL
	7GW9FypTlP6LfusZ7Gp22VZ4IkdnRlA=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-533202fe429so377901cf.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 10:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791567783; cv=none;
        d=google.com; s=arc-20260327;
        b=AdoK3DoJOeVT5R5bH3wHFh/kPnEuByfGoXTcUUKI6QPQ3OYiMJQWtFTFH81E3yt8Pe
         3YxL3VqoFqeNzktaUBhgeXtLkKpj4T3l3qp+CZs50BAaN8dmgh3OM+Tu6Vq1KvDCdpy6
         FKu0fMAafK//AhRpf8DuO0oODoBM5+SXV5uVVjvoXTfwJVuul2wffZxxiSo7RDwvTwtW
         EmUpJGWJlr5FYWxdw7UNE7Dj8y4CwelDRNwcyL7QdIaQMUvCPWTPxD48MUpx5S7E6Vxx
         xqxGgVCTf1T9duuxg/Sk6WmNO1gZlVLPUsaH6jbCPNEvYfLOntuvKF8R9Ms8DStZzQBz
         Ca+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9tsYcDTlJd+/drqourkl2rTNqD7M7lEs3TS0VGr4BI8=;
        fh=htEHEFw6Qi5HCWc/R2fpj9MENTpl0PPMptDCjlVafwo=;
        b=NLnuOIgCjM3SC3w0eI/OtvjVTNABAP+O6VAVAEoJ1p2FbMgVHlzNjkkNvLyH2qfRCd
         CRvveQVR+vHjF1XYHVJQYjBxPLvzwF2YFAmeiMasyDNZqtUbSdQxP5SRfD8LS+Cvycxa
         gh28V7K55IAzjCTVXbAss+uzmJdXhAXmkVUis4jypWlBmU9e5rdLvGtPBSXv7fwuDlUg
         uhNZ35vbJuSYnvUS+L4OKmp6mOqBMGISUUEVEosvPhUDpTRja78wJz+R9jl6EFGMI7q5
         7vTjlNwzHxreCjdOsJESwU1B+xJ2JF6yMW5ziYJmz4Ummbn+/cl/x74dq5HN56qAzYMp
         KAmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791567783; x=1792172583; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9tsYcDTlJd+/drqourkl2rTNqD7M7lEs3TS0VGr4BI8=;
        b=GkR+ChZ2+1flRqbierb9TFmWgOab1gizuORdzBwyX5qbtGe4p8iOMDL40UHfPEOBLA
         iPPJnMte13mhnYV58LHE4cgkS+yCmtQHOw3PTNvg628kWbe70kEryFdMj7yCRNrPGBR5
         4vpPTQsuvIg9tyVWMaDFwjlnZCFehSHmr2d5PQ9MqwLF4NZoHvfa5spjSJ7bI2y3X2Rj
         wk5VlUBJ09GZ237r3mt0DT9uUjOvR7gOEQTjV21Qb8srWePl4uZxP0VFOet9PMNlgEHv
         CUVWatpNZdS5vpyV2LZ+qLjlQrGHUhVqO8D1B12VUnsC72iiIWsvU7YHvyY2l+hJqqVy
         /gRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791567783; x=1792172583;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9tsYcDTlJd+/drqourkl2rTNqD7M7lEs3TS0VGr4BI8=;
        b=r7j9Jb/r77xvQx6lsijxuH/ON3AJ4dyVAGDfYdRa8FdOt6x+yn1UyufC5qgEBB9jCg
         pd5FJ4+HfCfd4djcBaykbpr0Q8A+eFRZ79IsYyGsm+IUbD3g2JcuvXhcKypI5JfSlYcd
         xxSKz0ROmgqjkqllwc05IrKID2oEEFx/D/tlgPegoWw0n7Gbl2oaZaQ3dJvjSwfAW8ya
         iWDTFsmtUggAOlM4e7luTBSjUSI/WJpGYhMSXJ+MSJJZrMUvCb3XjL85/XCOwuIHWFHS
         PCrVdqCauYf8YMGhdWoR/ryPOz+HT7gMKUb/RV+JRfjiSRXon15I6Rfa4Wty4YSmhBRv
         a7bQ==
X-Forwarded-Encrypted: i=1; AKwUvByo02xqSziLGGrRLFstY/e/deY1yuxycC36MGvJijT6mLw7T3FbDVBBw/LZRuJWQVP1kVfbwgrqtQ==@kvack.org
X-Gm-Message-State: AFq9FYJ0sgGIoJ/qCKbFHcKSwAyxd8DpcKX8157ikC7x2U2b7AxLCg26
	4WbVRxLmCnwWwyCy9uZ8kPzrm9t2L2oMin37opvdOBy1VkOZMAWFWkc3lzUD0RcTTZQnaJmJA2c
	592RS3TDKYzz2UiYTfo1xLN5kM5miC5AHUG08Hjrl
X-Gm-Gg: AYBFou1PkIX3riDDH4MmgZqk9t89FIJc2woTV1k/8EFmuOR6jhhoIqTYhLIIvzhGxt7
	Qh8mk31M8SxSi8KxrqG9PGMg+X+JxAT1NxfkJHAGqE2KS9PigI9t7FRInjvRemBVeFyy2eYyMEa
	Ps2YNs4IAgjdMzdrQpoyWqboBxb4sni8GCeL9BuM+TbLV0F69kMckTrEkcKZXRqt6VhYVCj76dv
	Y5Ji5GxZkIfPQxUI2e+ZCaHIGmFeNJcFQMAdd1i+yhKbVmH9YWdgWkQ9dolemt0L6Xln3Zprhca
	GGtfdWwUl3yUXDx0ldh75q8VD4E7qm8gbUPTEajta7j8xh/1X5kSaelh
X-Received: by 2002:a05:622a:e346:10b0:530:5ed7:50f0 with SMTP id
 d75a77b69052e-535afc0745dmr175781cf.13.1791567782562; Fri, 09 Oct 2026
 10:43:02 -0700 (PDT)
MIME-Version: 1.0
References: <arZ5-VB0xkq-dJzG@pedro-suse.tail5790ac.ts.net>
 <CAAa6QmRt+4w9U_R8B5s+uOmS3DsFhc5JfucGcgz7D96pNDrwGA@mail.gmail.com> <asjDTxAfUSGm0obS@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <asjDTxAfUSGm0obS@pedro-suse.tail5790ac.ts.net>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Fri, 9 Oct 2026 10:42:24 -0700
X-Gm-Features: AclHuK-tnLYFY5jChXOCoq6liIcNyVnuhJx5nUjgYvWqLo8yinBzJkBiMdc_tDE
Message-ID: <CAAa6QmSZ1eS3R4+SrKG86mtiJ5zoP7gCH+habP=qHyg-FDP8oQ@mail.gmail.com>
Subject: Re: THP placement BoF at LPC 2026
To: Pedro Falcato <pfalcato@suse.de>
Cc: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E6A8910000B
X-Rspam-User: 
X-Stat-Signature: 3d71whwcd9m5id9tma3m6co3aw3xirwr
X-HE-Tag: 1791567783-241891
X-HE-Meta: U2FsdGVkX1+SSJUiMQt4slc8r92IkIQwCiJ2jlijNU6aNmsITEc1mQv0pgC4XovCRUfWMJF+gpmHE3ITjYzYLJ2msSefWmLxUser8nR8pMsp9mM+3/v3045+n3TpqTkJjHOQRaAZpcBz6Eq+0xR0ZfnwLyj/0+CdDFcZylO9eOVwQqDxkeX5DkSsYxxpiX6V86Q0RFvTga7xnLeK3feBwjyQ09ZlqPDQh3Ppt/0USLfNsh3mALjqWHSAuFbcwAOOTfGDwvnsltViW2KjPRBlsuxCTzPimk8hJbXYU9BX2OPMZMUBVJNz9LCrVmrrebEH3xsUxdpSLzSIVINpJIIH0gB/X5Ve54JX+97C7ud+2KTn+X5oTv/Zc/hJcDpe868J/ah6rq5yePcTOgtNSTMwWRCt8Cq/CQ2b86yi8NP0py/FEAL/bmoWJH4FWJwBE90fqxVL8CZHWXi8czc+xb545x7k2bKgglg+1cSW3tMp333PWxTELWPKVXd2fCOd7XhCw6DxpmSni56q3T7e37B0NxD1eDHiY5Q6QT6t1Z96dfs6CJFZCFUyrcC3qUg7SkebktEhH0ih+RrOaXeHf07XhRf6TjThbkf5WdBTXMWbUe7CSMovSQjNN9KpgFprvWTTsASZTiaNDHQuTWEU3pSQx6kvIJUH7NYcxSg+YRWnawLsgS8gJSbzvzwZxD8Rpka0ch5Eb+EYkj9rQeCejo/12OY1cR9Wcb98WWTOQ8JWc9kja7jPNwsnDhH2WyoUVUeEH9FSb0EaFkC75bORQx0QZFcbgKjLs1WV/uyLKATFWAMtw/gkB9HbePKDccUFQo0JB0oStNZt+yopfxiyoKQEJgRdLGEYGKR+Aisv/gzB62DPBo6RDyPNKMBo1o4ztUUdaKAxoBxD09ZlXCpRygqKWC0NN5ahhEMdYy5GVsiH34KZWwah46rQu/6M3GdhGYtvU22uKPDF+rUa9+6tFbD
 c/eTAeHO
 QC7eaoWtmV/Zgiav/IH18Q4N23/tNWBY/4qNI9cPIAxFCV2efx3kh0QA5i3hHec5sC7NPqiOvDhlsm8xe0lRHEuBFC7cgClAtGVHHXcNQUuDNf2FWhtpO5TakDaMJRHoSXk+ctLdXs+/BV/NQ0QyXeDe9R7/JxR6Qgx9x7fxzlTEMU5cxC8zHCy44RJmSU0imwoqQNNzpO2yE3nVKue16HvSRTWSSUqR6HO8Shog6r5mxZcB4+XoGuvFQhotuelfITLQtY4556kKDl20riilzyp0HFixpFh+SYCFFDJQJ4Nd+XZMXUm8A9PDFUMDjHzicBw3j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 3:46=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wro=
te:
>
> On Tue, Oct 06, 2026 at 08:23:44AM -0700, Zach O'Keefe wrote:
> > On Fri, Sep 25, 2026 at 6:57=E2=80=AFAM Pedro Falcato <pfalcato@suse.de=
> wrote:
> > >
> > > Hi folks,
> > >
> > > we will be holding a BoF about all things THP (but more focused on fi=
xing
> > > placement/not-automagic-THP issues) at Plumbers 2026.
> > >
> > > Session link: https://lpc.events/event/20/contributions/2452/
> > >
> > > The point of the session is to build upon the latest THP discussion a=
t LSFMM,
> > > and build upon the latest problems that have been raised over the las=
t few
> > > month, to get somewhere meaningful.
> > >
> > > I added a bunch of probably relevant people - it would be great to se=
e you
> > > there! and anyone else that may want to join of course :)
> >
> > Thanks Pedro.
> >
> > It seems there were some AV issues, so remote attendees couldn't see
> > or hear the talk.
> >
> > Perhaps someone who attended in-person would be so kind as to
> > summarize the discussion here, so we can continue the conversation?
>
> Hi Zach, Zi!
>
> Just got home yesterday, here are my (editorial) notes:

Thanks Pedro, appreciate it! Was disappointed to miss the discussion.

> 1) mapping 2MB THPs in ptes initially
>  - tough ask for lots of folks
>  - problems:
>   - might take too long to get a THP
>   - problematic for short workloads
>    - my counterpoint: i've done some testing with kernel builds (lots of =
short-running processes)
> and THP is mostly noise in measurements.
>   - non-obvious how to store the 2MB folio
>     - maybe hang it off the ptdesc?
>     - can also just PTE-map the whole thing and do deferred collapse on t=
hat
>      - but that's basically khugepaged's whole shtick
>  - could be possible to carefully map THPs until you have some confidence
>    the task is using them effectively (some sort of THP slow start)

Right. PTE mapping seems like a baseline necessity if we want to do
intra-THP coldness detection -- something that we increasingly want to
do given the current cost of memory, and to ensure THPs play nicely
with reclaim and demotion.

However, as you've pointed out, initially mapping by PTEs may
overly-penalize short-lived workloads.

One thought (credit: Yu Zhao), is to add a mechanism to temporarily
shatter a THP's PMD at runtime so we can do the per-PTE A-bit
harvesting. We're mostly thinking about this for anon THPs only, where
the deposited page table already exists (this does, however, conflict
w/ Usama's "mm: thp: lazy PTE page table allocation at PMD split
time"). We can then bound the number of THPs under evaluation,
providing a bound on how long any given THP might be shattered, before
(possibly) re-collapsing the PMD in-place.

> 2) there's only one accessed bit, one dirty bit in the folio
>  - this leads to hard reclaim, and write amplification for anon memory
>  - could perhaps use more memory on large folios for this stuff
>    - 64-bit field could be enough?
> 3) can we use hardware metrics for it?
>  - maybe, but sometimes they have overhead.
>  - unfortunate that hardware vendors do not supply us with more A bits
>   - could the 128-bit arm64 ptes work for this?
>  - AMD IBS could work but does it have a performance penalty?
>   - Intel PEBS definitely does.
> 4) splitting off a VMA for MADV_HUGEPAGE VM_HUGEPAGE is silly
>  - could perhaps have a parallel maple tree with these hints
>  - my thoughts: wondering if it can be made extensible for other
> hints/metadata. or if the performance penalty of needing an extra maple
> tree lookup is measurable.
> 5) THP shrinker is a bit silly
>  - in no way does "scanning for zeroes" actually indicate if the data is =
cold
>    or not, if you ever wrote to that page
>  - Per Usama & Kiryl, Meta used to have quite a lot of issues with this u=
ntil
> they fixed the userspace malloc
>    - i think that's a tough ask with a lot of setup
>  - some mallocs actually write malloc headers all over the memory chunks,=
 so
>    the zero page shrinker fails then and there
>   - and on free() you'd need to zero memory, or at least issue a madvise(=
)
>     to the kernel

Likewise, integrating with the userspace allocator has been our
biggest challenge, but that isn't necessarily specific to zero
subpages; for us, it's pointed to a stronger need to improve kernel
<-> userspace communication to avoid one side messing up the
heuristics of the other.

Note that we shouldn't conflate the zero-subpage case with
cold-subpage case. Though there might be considerable overlap, they
provide different, potentially valuable signals.

> 6) MADV_HUGEPAGE has no size hint
>  - what do users expect? unclear, they ask for "huge"
>  - problem exists for ARM64 16k and 64k page sizes
>  - I floated around the idea of defaulting to 2/4MB-ish sizes instead of
> giving out PMD-sized chunks
>   - ARM64 can do 2MB huge pages with mTHP on 16k and 64k page
>     size configurations
>   - or have userspace give hints through madvise?
>    - I don't like it, neither did anyone else
>  - overall I didn't understand if there was a positive reaction to this o=
r not
> 7) BPF was floated around as some sort of funny-pi=C3=B1ata
>  - it could certainly make things more flexible, but definitely less tran=
sparent

I think we've long-since done-away with "transparent" -- at least in
the datacenter space. We can always degeneratively fall back to
"transparent" to speed up run-of-the-mill / unsuspecting users, but
for even slightly optimized workloads, THP management matters
significantly. Note: Non-transpent !=3D gauranteed.

THPs provide large swings in both performance, and memory cost.
Increasingly, we are under pressure to use them more intelligently,
across many domains: prioritizing the hottest memory (or at least
avoiding cold memory), prioritizing regions that can't be zeropage
mapped, differential priority based on userpsace-directed priority (at
container, job, vma levels), etc. There's a rich set of policies we
want to apply / experiment with, but we lack the substrate to build
upon. There's only so many things we can bolt-onto MADV_HUGEPAGE.

I don't know if BPF is the right way to go or not. One attractive
aspect, is the ease with which we can integrate into userspace, for
things like deep system allocator coordination, or for daemons that
enact system-wide THP management. If we're ever able to establish a
set of policy hooks, personally, I rather see something like LSM hooks
-- we can always put a BPF behind that. However, we might require
something more bespoke than a simple set of hooks -- I don't know.

I think what is clear, is we need _something_ extensible. In addition
to providing a binary "yes" / "no", based on various inputs, one
central idea (I think) is prioritization: who gets the THP if we can't
allocate more? What container? What task? What specific 2MiB region?
We need a mechanism to allow us to move away from first-come
first-served.

Are others of the same opinion?


> I hope I didn't forget anything important. I'm definitely not nearly as g=
ood as
> Jon at writing ;)
>
> I'm not entirely sure on the way forward for many of these questions. I a=
m
> vaguely planning on at least attempting the PTE-mapped solution, if nothi=
ng so
> I can rule it out as a possible way forward.
>
> --
> Pedro

