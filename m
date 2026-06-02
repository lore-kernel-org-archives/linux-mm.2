Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA670CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 23:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E1D6B0088; Tue,  2 Jun 2026 19:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1086B6B008A; Tue,  2 Jun 2026 19:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11C16B008C; Tue,  2 Jun 2026 19:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC7466B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:04:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83894C0637
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:04:08 +0000 (UTC)
X-FDA: 84836502576.30.984392E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 845E7C000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:04:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvUCuuQf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780441446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGzDjuAvcIt9jSsrnnmZfYKA/ydyZfYEEoZeMj6ExQM=;
	b=hvJm2wn0oR9Yvumj950qq+oUDXIljplE83k7MC++PNgmpmq6uP8T1V1XTadjLq9UrQI+ly
	rYBpfreLE8JFhPhdsWv690eO+R/vTBtHrIhoFIjIgoQ+Aw75znqWD0MqOS9YATEq3GqeUA
	8piSy/5acdNbP4A+XqMpguWuHsXh+r4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvUCuuQf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780441446;
	b=OVy9PxsedjLNZT2+a11UiFDpTE9KKJ5ucqBHh0Ug4G3KBf/yMzYd50x2fPlA2+GwIzD7M1
	mGd/6DYDtl1jaE+vLF7wUjgJvlNT8WU0gh2Bb/7/UGjGUko9wcL4eGOU2Gn0nMI2NPB4oO
	HaqSNViQHp8HryPl/AWUhA6CbMAzXsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6135244607
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AFC1F00A07
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780441445;
	bh=fGzDjuAvcIt9jSsrnnmZfYKA/ydyZfYEEoZeMj6ExQM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EvUCuuQfxIVQtKdieJ/ojTw7O5oTpN+1v4wSoySeJnSQ77XhNPBL4s0Qq/Y1kunRy
	 O/1dguz4EY6tg69/ld8u0YuxKtsGscTfoE3p7hvpY29oeTAInBfr4YsW9C4LSpW/dQ
	 o+FniKL/AHjEv2g5G3bwTIAbht7mdo5l8J5i+nXwa5dKa5BmC1NhTBV5ulufIVzVX9
	 GVUoQKkCgBsmCpKp4KXyQuW2FsNpAb6Pi5BgbcfO5gqv0Q59eu3/Alp+/1nEb8AWH5
	 eJqUb/x3HgusCNWLkaE9PXVaih58QSkPAATsny3gUFg84kl8gPINK1abjlxx8KyOx1
	 Z84I6M8uqEUcQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-915671abde5so230640885a.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 16:04:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+Is/LYlSZxq+78lFnrFwGRA6U5Bc2V7xNoX+86Bdo2f+a7mF6YBTYuEyHSP8L8bI+kfmJUWf5ogQ==@kvack.org
X-Gm-Message-State: AOJu0YzzOmtgn7Hg8ireOYlffJQNN19DVBRBDnZQgbSk6sTvrHwNNEmu
	3Zy+EHndYcGajDUPxM7iW1KEY5gRQf/qxRqgsRCE5j8MikshJm7FODQUf4fjgXri6HNO26rAVxz
	Rx8VmcpEZATcHyQAr1uGlSaQphCBo4oY=
X-Received: by 2002:a05:620a:25cf:b0:912:8fd0:4a5d with SMTP id
 af79cd13be357-9158a8430eamr187006285a.55.1780441444405; Tue, 02 Jun 2026
 16:04:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260527110147.17815-1-tao.wangtao@honor.com> <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com> <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com> <ahlzj--3Gm5pD9ge@lucifer>
 <a90bcb0fa3a044588350e92a78258a09@honor.com> <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
 <2e9175ab-f9be-44c6-bf1a-a82aeed18f98@linux.dev> <ah71gjj21rLIuTnb@lucifer>
In-Reply-To: <ah71gjj21rLIuTnb@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Wed, 3 Jun 2026 07:03:53 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yKtEnCEyLVpzKUNDDw0AwttnFhB7c1sicBpjecBxATQw@mail.gmail.com>
X-Gm-Features: AVHnY4Khgdh1OvPc32I3tWzQ7qSOu8BOGvT2qrR5LpDulZJiDfW5EMOXKL2Djq8
Message-ID: <CAGsJ_4yKtEnCEyLVpzKUNDDw0AwttnFhB7c1sicBpjecBxATQw@mail.gmail.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "harry@kernel.org" <harry@kernel.org>, 
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 845E7C000D
X-Rspam-User: 
X-Stat-Signature: 9nqr5fbwgo4f9ndu51mpdxpxgzyeisb8
X-Rspamd-Server: rspam09
X-HE-Tag: 1780441446-678739
X-HE-Meta: U2FsdGVkX1+2gtsvKelkzLPw+KJarveqwNXCLKpLuaU2KneIdHwwX4t9/Y1JOU9MX7EeOTNhKsF6tg18DV8PEfipq9+YJvPCQ5b29uMPQTtYi0HWPd1f0KEpaJKGxCO/7CBC3gLpOOtm7sU05ZiKbCpcFO2N1v/JWdeKeH79FJhuoE5KZVNGpIbbzS4FdBxvCvi3rQTOxsylQkU2653rK4M8ntQ3nLAQg+qafvQC+G+eAWDHcUmHIAazeXQsrG/9nx2qMxToQUTA1KApFJxzP0XMztA8mnAsQqzirCS5A1mX+OAvZi/QnAUNuOTtiCEe81NJoDOWull89FZmn1Elyn4GmWeQyN/GbPlBK72iGEzfrnu552Ueetc/U/7C+kZgisVUwkpB0wRVSz+LyYh0Ol5xwhwCnJnP6Y8xn8vLIMeEGxcqD7GJ1dYYV5/RWqDLyCH0EcSHdY6URVCKRhVgaFzGnrsfYJtOu50xXYooOaSsle/V4NxK7FnAFbSoJOtEGa8RikY2OZ1W0t9lVlCtVXJklLB3m8xnEC/2efPh5twjHuIgTpFqgc2zZ7y/lPSSHEzcgvumj+XsXZjFzFgNEjuBKdA+2/ylKL1PeZYpSOUmYt5CxDiT0mQEWDTpd64/wVc9CruYBjMKtS+7p6p1ED1rwKYpdWFmdsPva9tw+B0IRIrs1dWu6prldxYDd9P/+g0/UcHOQPhCDkXXHUbdqp5UMOl8D+OtnNeMr+0EQzfOeFeyvsrkOY7CmgydCwL3BqRJ85xxI2q9oKHjIrvpco/S5P7xdhIn67gJHCreHtAfP9KPTQD+WdCsCRSFAWApyrsZp+HlOmsFhDXkGr5PEowb8ONf1t70cdzsOk/c8Vn98Pgv0h5IDasQUKdoDECEef52XSoMLulBm5QI7A6k40LcDDrPwrVpqTGhHPpDPJE2a7BlUJhwcZdiUhjgnrqFKBhDUhtycDw3E6Nb3Sr
 5YbvWaPi
 qGaPSbVzoQZgJwUCGB0Dlm7fmxOXRc/cBn3y48mH28e9/DrqJ185XgpD0JXjHoAeGhNOhYvXVrPFIiz/c6by85ccZEXsF5hFFg1S5JxUS9WczgfpMMBljd+5cljX1kBul6eKj3apkX/yZdIoyTLRHIt6TGasUP4wDYPfCIEjmcLMNsRm/RXs26ph9EqO2P7izqmwmb8r00IVxHn9GoZtplkhJntNo+hKMeGbpC/WyzW8h65p9LMIZNvAvrqjpMYrDndmKSko6B+aAoeJlN8N8vZ/O9qh/GwA0SR3hqCxZ88h/lofRgPauEPocBKDJy9bvSciR9WD4ckrMKo/PqB2WoRPNGbstTE4g5PnbjXsYr89VdFSWQehi6CGJ5uCQ8lxrptaBJCQM9rAVfIjcAAwMHr7xoxvnjgXHABqjoVF2Wg8MbnuXy7XhGcf0fnVMmar4Y3lqlZpOuW6ik6jCOh02odiaSuSP1gdq5+6uE9s8arSFWb/EFSW1X12v5jPGvGbyDt/U81o7658EBEWNjc/7f6as+Z9hW/9+mH0tEVGBTxCU/H4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 11:37=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Tue, Jun 02, 2026 at 10:46:35AM +0800, Lance Yang wrote:
> >
> >
> > On 2026/6/2 10:15, Barry Song wrote:
> > > On Mon, Jun 1, 2026 at 9:46=E2=80=AFAM wangtao <tao.wangtao@honor.com=
> wrote:
> > > [...]
> > > >
> > > > You said discussion was welcome, yet when someone offered even a
> > > > small comment, you refused to continue the discussion.
> > > >
> > > > If I had known you would be this inconsistent, I would not have
> > > > replied to you in the first place.
> > > >
> > > > This will be my last reply to you. I will not respond again.
> > > >
> > >
> > > Hi Tao,
> > >
> > > Please don't walk away from the linux-mm community. I read your
> > > patchset and found it quite valuable. It not only reduces memory
> > > overhead, but also eliminates rmap costs for exclusive folios.
> > >
> > > Since I'm not very confident discussing technical topics in English,
> > > I wrote a blog post in Chinese about your patchset:
> > >
> > > https://mp.weixin.qq.com/s/k00tzhTl8HbL3k4G6ev4SA
> > >
> > > I have to admit that I found the implementation quite complex and
> > > in need of significant improvement. However, I think the underlying
> > > idea is very interesting and worth exploring further.
> > >
> > > I'm looking forward to seeing a v2 RFC with a cleaner and simpler
> > > implementation while preserving the core concept.
> > >
> > > Regardless of whether it ultimately gets merged, I hope the discussio=
n
> > > can continue.
> >
> > Same here :)
> >
> > Tao, please don't let this thread get you down. No first RFC is
> > perfect, and the idea still looks worth discussing :)
> >
> > Thanks for working on this!
>
> Guys, this isn't helpful.
>
> We aren't extending anon_vma, and I am working on replacing it, that's th=
e
> bottom line.

Not trying to challenge your bottom line. As explained to Harry, I
have no doubt about your expertise in rmap and many other mm
areas, and I deeply respect your work on rmap.

With more discussion, we might gain additional insight and
inspiration. What Tao has inspired me with is the idea that if we
assume most real-world processes are leaf processes, could we
simplify parts of the design?

This is why I suggested a v2, to improve the clarity of the cover
letter and make the code easier to understand, and to see whether
there is something worth considering further, even if it is not
suitable for merging.

>
> I have presented compelling evidence suggesting this is AI generated. In
> response I got more AI-generated nonsense. There's no trust, the code and
> analysis are all wrong, end of discussion.

I am not an AI expert, and I do not really use AI in kernel work,
so I am not really sure what counts as AI versus non-AI. Sorry.

>
> >
> > Cheers, Lance
> >
>
> Thanks, Lorenzo
>
> P.S. maintainership is utterly thankless, and I don't really expect much =
in
> return, but honestly reading this, given the case I've made here, was
> really quite disappointing.

Understood. I see your position, and I personally have great
respect and appreciation for your work on maintenance. Sorry if
my words came across as disappointing.

Best Regards
Barry

