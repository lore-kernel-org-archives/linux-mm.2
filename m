Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18891C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 00:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C086B0194; Wed, 23 Jul 2025 20:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D036B0195; Wed, 23 Jul 2025 20:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349E66B0196; Wed, 23 Jul 2025 20:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2106A6B0194
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 20:14:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8ED38140232
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 00:14:10 +0000 (UTC)
X-FDA: 83697235860.23.D482BE6
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id B776520002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 00:14:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0kdU1RFz;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753316048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCvhjqOb/w6d39ZBDYQ2PSwx39tCRZDfcJu6zahOeww=;
	b=Eb0eFfwTpFhNqsEZmYCCwSBO/GTh54WNg8NIG2iW5RC2Talegz+UXPxHVsrRWCEH4uun2V
	IVgvP+bQZpsWemAPLxFgkqTIBM3aHo7pUSlfb+Y6rxF/Vk29bT1HjfGSAP+ErBErf1JCrK
	dEmSaQS7xT0Af7u7JTEXcxlmnNplHik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753316048; a=rsa-sha256;
	cv=none;
	b=tIi64xlAHhhe1Q/vZhgDTp08GJoPvJ7/17kUw0zl0VHiQiQNQpD1jl8rGeE4ZLo4f5rrQG
	QGFtYLyRaS7KgdMiwcAHI5Z05kqYg2ymGu1Y4ek+XdKk57sgSBQzhRNe/Y1WGQ7K7QXB9i
	AsU02UO4cs56+ONDxPfcVeECb1T/mWI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0kdU1RFz;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso196141cf.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753316048; x=1753920848; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCvhjqOb/w6d39ZBDYQ2PSwx39tCRZDfcJu6zahOeww=;
        b=0kdU1RFzq1kCpUIRaybJcPSiebVbr1P2qYIwTyaU/ohSTMkWQ/0VCa/ykpI4LwwXHg
         Xdf2qZaVdpapa3hKqCSpzMbpQtIQ62sQfh/6G4T37JOmr5uFq1U1SsvidckuVmBdl1Dg
         q87VV2b9I9on0O2tUzqgOLDrqFRftFwg21Pzsi5J2yjXxhFo/XXXn4HOjkIZOpYOMKSp
         2K0Zw3MatIIM1sWzW7BUTNyY40Qe4kuRP14F5NECr8JdQZP/EFh8hiv2eGpcMSwaqrMN
         vwxSV1LJBMZpU+ofPbJ4KqebVAEt24HK5l2OTFL+TG1vlEGI94uqh4vmuHB7LWyh39eT
         ITog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753316048; x=1753920848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BCvhjqOb/w6d39ZBDYQ2PSwx39tCRZDfcJu6zahOeww=;
        b=qtKlQfY8C6TjiPhXgY3nlUNyrtum8LHuqrY2S186SgBoSZ15QcTENL2Rjqkrzisa6j
         ONOfgz3Xw7F3uCdQR5KtIV5lXh68IEta5chPwSlKcB2ZZBNkNA+NvCKa2BB9vR8gB5h7
         D2JeOAwBOOji2xEN6lR2QMJr//syAsLqluwDt5tADzbONqCwk9m/QOfxpPItM6fzRghS
         F6sfa2xoOuR1EY1D3VBpDxusTEq/zjd6LRrEOFk72HTmedUC1pJ03AZ5K5/gm0ruqSG2
         nfwFcULA3gd2dq1ixjpFM2VGG05YfVFXD0QsEr2rHoQcsR43w3RBtLmtIUKpHRwl1ZE/
         C2og==
X-Forwarded-Encrypted: i=1; AJvYcCU1JzqeHOWGKy/jgRkNdPO82J0+t2euaM0lRynpXn8rRrZn9zh+ddENecbHenbCGmyQHtW57QoSvw==@kvack.org
X-Gm-Message-State: AOJu0YxKmRHnaMoCyeHqHQBar5GkIQnLiLIFAmB1umMwKAc32OFx6LD0
	+D6nqfsIUdfkMoqR97I8cBxU3RoPPQqGqKkFNSWXayRJu++fI+ns1rRfQrVdhp1mOeiD3FWGFwQ
	lQSDAW8Bo8oyTJ5JUbxX7LXbSY0OLKyk4q82Bu6iG
X-Gm-Gg: ASbGnctyHxlMz9xaH46j9/Jk3D0INe18hDn5NKCI4+h9PeSUev/svHHfiDcnUpHbMUh
	8kMq+20wEWo8+3uvCF7cueIJsQ33XQjwSvusx+mGxZfiL15ioc65zyns4qZxRGP8tHDjW7ct19V
	3n0AixuQWEjFkhLtD06KXt4xOOjJP8cOW7BBRXIx8tFT3ua+gazFvCtGcczPYx1nx1nPfDjvpHi
	VXzfdanplyLXdZh
X-Google-Smtp-Source: AGHT+IGwJI4qBJI9EF0ou6ZB17dPdidVX9YGsc1FmMWGU3tiubRR5qNcGf7Ydbbt4t26QWu5VHFRfg+yhHipx1FY4/g=
X-Received: by 2002:ac8:5f46:0:b0:494:b4dd:befd with SMTP id
 d75a77b69052e-4ae7ca7389emr1738841cf.8.1753316047204; Wed, 23 Jul 2025
 17:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <CAJuCfpG5VeW5+GdceeRCLDgX4CuFm2xQUG6UAAoLwF7oW8aU_g@mail.gmail.com> <e419e15c-7bfc-4fc2-9089-e271a3b0576e@lucifer.local>
In-Reply-To: <e419e15c-7bfc-4fc2-9089-e271a3b0576e@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Jul 2025 17:13:56 -0700
X-Gm-Features: Ac12FXyPUArzlEQYTV-gt8Qf-fS8PxPvjmAwy6QW3lASWRK5aZpfGU6UG5IEymM
Message-ID: <CAJuCfpFdyiXFuxoNMQHj6jkVYkJMzq67rHM9400NoUBS1TJtyw@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B776520002
X-Stat-Signature: cae981rqfdeuu7fghtba9ssozgydaxaq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753316048-879651
X-HE-Meta: U2FsdGVkX1+9OwF3S2fxRAThkZg4GnyOGB+5dKzkPrcd802s3ozdfdQS5SnYy8yduFI7lYpsTGAep3BYULHkyHRCmkRJDj8yO2pE5KMytL2fjdZ5ZnbBUt5YOI9AuTxA6lO1y7SJK+/QWQFSYL2o/y9pS+RTmOpGpk3CQbWNp14fKd2UDiXkivLzwnt09rZKlUY6LZVj1rCb+R6ycxSCmeP3BAxVsfDfkomTGKg44f1q2sfYun6z/UXNpf3itJ7kqB0DkDtiAgeBdCXnSCzqCVDRb3a2CFy3ajiJNPGiRSNcWK8YhFlebPPZpEZ+JufzLlxiQmEaMWYb/QkUoCuBUYURc1cpnoGgvcD6YVZmpB25aLySZnKoXg0iI5G8zhybY51oEmjrsAT74mmjSsieXiM4gYKYjHZSCDbzjHXKH2q4HtZEjEX3ebxCoCzTJsN0YiFJvLuRj8VcTpGl1QHNXz8vw5r1v86X7phfxlHm+PituYPeAHJ0NoGHHxZoPYsSgF6gRDQLQYiBxb1ghVR9d5ogncnO5wRkE81rvHRqkq5/IpxUIlfEVEQbAS5JWgy4rHdb/D64dierCiIJT+GS/V5qTbR3ci9SC2owCxE9JrhVXda1K6s5HlxB02sQTjMiMPimQmMGsrRP/+soXJY+QIhZRoGKsd0U3628KQpRKe5ePHxOmBpwzPkDZ7+0OnHaOgipSAQo8sSV4jDKA5X7veOtFokg6skd6ANSVRi0/Tjd23u5r+NOtx+B5f3hD1lSFc+6yr78MZSHxzUSZNbhwy63MXAVTR+9Asf9R94QLUur/Gw85fQlADkfG7StTi8AvrZTPF3MPXbUyl65pt7N9N0tZFKySepCr6SES3HCX1FWiW13LiM4CMIdr5T1UMfYkZk9xMWFO3m/XOjN98Cg1zxOT32xw8Nez7aTQwtXbzwMc89mu9GGrvyyMmrTkoJ8bUfsyq60jxfcHwzEYKs
 MrHTc1hg
 1u3ulEwNX40QiSsVZCPK3onHnvqFT3JbmxQq798N2GvyN7BBmP7rnq/9sLBKPEYVzRqiw4+hq3jW63UIO1twp88d4C+6NiRrFppaIsV7fsNm22mPxf6CVGAXK/kIS0XLIEBrGGdLhsyTd40cb+SwFuB761mVfHvO/+9OHLCgLoMuTnk8ImqIe/E6kLsyLqq1VMEUX7V6KskNf8z9oWHzql8glsBCo7OsSCwdYcowrEwjh1vF3ysSnDh5kT8qMX1wq0USGE/7SCgl1UKV01ze6FAKlFbinXxh33u4rIDMWKf3PyvVOm5pqvjR042OpKlf2zkqBq79+/4BhsGMZZ+fL73JJqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 12:01=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Jul 23, 2025 at 10:55:06AM -0700, Suren Baghdasaryan wrote:
> > On Wed, Jul 23, 2025 at 10:50=E2=80=AFAM Jann Horn <jannh@google.com> w=
rote:
> > >
> > > On Wed, Jul 23, 2025 at 7:32=E2=80=AFPM Vlastimil Babka <vbabka@suse.=
cz> wrote:
> > > > On 7/23/25 18:26, Jann Horn wrote:
> > > > > There's a racy UAF in `vma_refcount_put()` when called on the
> > > > > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is use=
d
> > > > > without sufficient protection against concurrent object reuse:
> > > >
> > > > Oof.
> >
> > Thanks for analyzing this Jann. Yeah, I missed the fact that
> > vma_refcount_put() uses vma->vm_mm.
> >
> > > >
> > > > > I'm not sure what the right fix is; I guess one approach would be=
 to
> > > > > have a special version of vma_refcount_put() for cases where the =
VMA
> > > > > has been recycled by another MM that grabs an extra reference to =
the
> > > > > MM? But then dropping a reference to the MM afterwards might be a=
 bit
> > > > > annoying and might require something like mmdrop_async()...
> > > >
> > > > Would we need mmdrop_async()? Isn't this the case for mmget_not_zer=
o() and
> > > > mmput_async()?
> > >
> > > Now I'm not sure anymore if either of those approaches would work,
> > > because they rely on the task that's removing the VMA to wait until w=
e
> > > do __refcount_dec_and_test() before deleting the MM... but I don't
> > > think we have any such guarantee...
> >
> > This is tricky. Let me look into it some more before suggesting any fix=
es.
>
> Thanks Suren! :)
>
> I feel the strong desire to document this seqnum approach as it is
> intricate, so will find some time to do that for my own benefit at least.

I think we documented most of it in your document:
https://elixir.bootlin.com/linux/v6.16-rc7/source/Documentation/mm/process_=
addrs.rst#L705
but maybe we can improve?
This issue is a result of my failure to notice that vma_refcount_put()
uses vma->mm. This is my oversight, not a conceptual design flaw (at
least in my mind). We knew that lock_vma_under_rcu() should never
dereference vma->mm, that's why we added an `mm` parameter to that
function.  But unfortunately I missed this indirect usage.

>
> The fact VMAs can be recycled like this at any time makes me super nervou=
s,
> so I wonder if we could find ways to, at least in a debug mode (perhaps
> even in a CONFIG_DEBUG_VM_MAPLE_TREE-style 'we are fine with this being
> very very slow sort of way), pick up on potentially super weird
> small-race-window style issues like this.
>
> Because it feels like debugging them 'in the wild' might be really horrid=
.

What do you have in mind? A specialized test that simulates some races
for vma lookup/allocation/reuse?

>
> Or maybe it's even possible to shuffle things around and do some testing =
in
> userland via the VMA userland tests... possibly pipe dream though given t=
he
> mechanisms that would need to be put there.

I think that would be difficult if not impossible. We would have to
inject delays like Jann did to reveal such rare races in a repeatable
manner. Maybe if we had an in-kernel delay injection mechanism that
would be possible?

>
> It's sort of hard now to separate VMA locks from VMA operations in genera=
l,
> so that's something I need to think about anyway.
>
> But I'm almost certainly going to document this in an 'internal' portion =
of
> the process addrs doc page we have, at least to teach myself the deeper
> internals...
>
> Cheers, Lorenzo

