Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7384CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A1D6B00DF; Mon, 29 Jun 2026 17:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711446B00E4; Mon, 29 Jun 2026 17:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6287F6B00E7; Mon, 29 Jun 2026 17:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEA36B00DF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:51:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCFB41C65D7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:51:46 +0000 (UTC)
X-FDA: 84934297812.28.39B842C
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id C77F9A0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:51:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=gD9G2BtJ;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.174 as permitted sender) smtp.mailfrom=xmei5@asu.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782769904;
	b=jRgqhUFjzuwXczXODNwdv9WzAEOCkF4IC7C5cFQIgIsqeEVOxuN3/fhodO1jfDarxW1age
	DSLWUdQuTvMBpbD78MDDQ8HCcXsi5wHKsxp0a/msMlv9UKc+o5+CBYn0FeA2sEQQbZowut
	TI8DoYZqHS4ZDly4dhYz7w9XcNxAjZM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782769904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03WYrwsm4jZMWkVtBwLn+efUyzktWWLHwjuIfs2qWuI=;
	b=0IyKaUT+lTazixgAtc9u1YJmLl/EGI9gPWK2womssARcej75pXOQrEohhywpVKoT/c9mdG
	l8YUFXBTZSE7XoKGcbJKKuQ2ymzskdNkMSdXRQyOkMBCpTf9DghQtY7iuTqg8R+3H4sg1n
	bOtMauGSsk1bppuwKjTTbn2ZgPML3L4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=gD9G2BtJ;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.174 as permitted sender) smtp.mailfrom=xmei5@asu.edu
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-845f2909cd4so1030325b3a.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:51:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782769904; cv=none;
        d=google.com; s=arc-20260327;
        b=M6eke7UfXeRnWqznJoZr4H5mUxVnR36fp1890u7/iAsAxbuB2ksAgVrDEZFamQSx0s
         +X6z1Bdv1q8xzG/1wO6mzPcgbYjDCiPu3F4YqhVBR9dgGsyUvFtHJTNfTtMvyLqFxVl7
         32lcd1BJjcmXYBiRnpAvTpfzKysOVGSwtTTgfrccmkIf9uVI1sL1EOLPBwhllmyeNfeN
         p36pkfEoytqGsyTX3jlUKMuZMgnC6DSNtFsB4yJpgTOp/dn6Cei11bGhJeeM5bY3uT5s
         i3KIK6biHMeExRb/6ZceOf363A9KaJa95cfiHSN1yDW7UwfRKpzu6Kre1Tl9m4e05Hxh
         Fg7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=03WYrwsm4jZMWkVtBwLn+efUyzktWWLHwjuIfs2qWuI=;
        fh=A75h8XonSSQZx6OMdYuVO0Hug2mX/J85KeYYNofMEaM=;
        b=rjZXGA6SKhj4bxqFY3F+M5ZCdxO7yH8pWMbjfLESlQv8wpdd1i5UaF8gBuYa8h9dx+
         FPQfBzmJFaPvZSN6CQerfbGX8bKnFP3aU78I9fcanFyRUVfOB0C4hNUxVhfTAwG6OpvC
         D5X89ch6fnMLvvmPcjK2rj26bnRZcGr62bzyZXvf3XBIYHa9WbLzXEnZ+oxlJ0VP/4M6
         L/qTUMO4NHky2LkPmkz48bB5I68XrK9MTDI59Vhzu/oxrTEE85fgwSbn7h3cUIR/yyom
         psSOUPrfFXGPYDo0q4cMXr9aIleXRdHJX7diEUzQBvQ4iRWF5fF3w1mUJtRl7RNHtoKF
         jqMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782769904; x=1783374704; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03WYrwsm4jZMWkVtBwLn+efUyzktWWLHwjuIfs2qWuI=;
        b=gD9G2BtJUTrIL43nvJPxc2G0lnEeFRMCR6d6irwo2Uj91fo1l1OfgrlvxbE8VC3IXY
         RLwtPZK2LN8n0lato5l4ZQ9EGS9dg1eMNbgkTea3VI9eXWhYSobae8qVr25ieihTanPX
         vPKVfewo/8BVCGel1CBJYSGlxF4+0SlE0ZYpR14Gh34Wj2UwKOQh0GaGKxCfE6rzCCCG
         +VB1bYs2msSRbfhHrHKPfSp4Pl5bwugZWFyLgRmbWUH+YoZboHLxR7/sWVvO/VqsmRSp
         p2rlZAw7SWZO1nd8WzDBaj4x3pDVFmEAkMljAi/BIlMqkfgOxqhWqDeyL0rSG3wrb3yx
         9RGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782769904; x=1783374704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=03WYrwsm4jZMWkVtBwLn+efUyzktWWLHwjuIfs2qWuI=;
        b=oZ4aFbCge1mgSKW7rn8WD2YDuIbcYPmEDYDx+CS1ytQ1E1k4nQnaxBmBq5my5FrVoW
         aPY6il2GEYLXQsWhKeuYaX4knVb+zKfY8wWM7/4ih4G3F8TnN3GSAOm/7PnP63NIcuFD
         XhmZuPgEczllnAYOBEAgqvR5pjAu1almCeqAT7ZQnJYSZfIBa8G3RaTdj9H8grRwSzZH
         xjyTVoCwyPlJJ6xrJwunZD9Z+n4RvaPe3f2GoC9MczoEpJ6kGvBLJJkRJPzz3r14iRao
         52nrI1yWQnDfHd/14zjtMHt5mP/29kpyWZqOioCKOW+PsxJ2tYSeMr64LpJmQESSMFZH
         nL8w==
X-Forwarded-Encrypted: i=1; AHgh+Rpmzrzux9uKN7jboqVUJDSHzla7FidTqjwFptpa6HkrH+hCOYUv8Qqst5V/sLTGY7Lxq8wUAceDnQ==@kvack.org
X-Gm-Message-State: AOJu0YweSoOMwvFNWXmEMGadaLEoIfomhD2sC+KFDl8H9RJq0mq2LmGQ
	XCQ0wWYepnI21PH12uadyfVwLlFFi3KHIFbNyIZbecRkyNuT14Yb1swMy9hfdUW+I5v5QS+zLk+
	smsQkrlUqp48eByTHAOTNumgS8vH1j74Q5dzg74Qc
X-Gm-Gg: AfdE7ckspn9Ko3lb7x+vWDMvOIXu+2ZqBl0/418Q+9BvR/SZQd52+zkRGelJbRgQafB
	34kjrBRW6KgueJQ8fAMEC2WB5+PE+C5joMzHcs+1gSz8HBYHvzMT70SmrMmQRKFD5iTMoJMZ24K
	EjkwyUm2+qSJ8Flk243bxwVdJEdiy/xf4jdbtK0dIEUaH5jgKfLAc/Vp4EAIsDXhFMs9g5rv/A7
	Bj6quBC1ObSS6H7zR+6QLoOfRDUfB2Io9D0RxsUrsLsON9I3ZAE/UKc5XrgAEGvjiChOXWq+SUP
	8Idj+pMPdnqrHdRUn5Hh84H/BYOXQoo=
X-Received: by 2002:a05:6a00:a8f:b0:847:9aa8:d3cd with SMTP id
 d2e1a72fcca58-8479f2b62bbmr889620b3a.38.1782769903681; Mon, 29 Jun 2026
 14:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260626173444.2252041-1-xmei5@asu.edu> <aj7UNceukU9zYeGH@pedro-suse.lan>
 <CAPpSM+RVFDOYJFT2iwgNYdjbwqF-MmrbYizpLYksd1SLb5bT9g@mail.gmail.com>
 <499a4e15-34a4-421b-946a-c855199fdbf9@zytor.com> <akH34ycu5-q2Yc_D@casper.infradead.org>
 <3c4094d8-ae5e-4ffd-b28a-0c10db50296c@zytor.com> <CAPpSM+TA6ECyCO4J3c9CrezbApMO66Fm5u8z6djDaFj5Wtagng@mail.gmail.com>
 <CAPpSM+STqnUmzdx13rxya8_7z860st8R4oj+30TRJP094zQY6Q@mail.gmail.com>
In-Reply-To: <CAPpSM+STqnUmzdx13rxya8_7z860st8R4oj+30TRJP094zQY6Q@mail.gmail.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Mon, 29 Jun 2026 14:51:32 -0700
X-Gm-Features: AVVi8Cfyzm6Z1AIypogKUmethePqP_yXNaOjOS6fZSlg7XPZxwqd8WokhHh_pDc
Message-ID: <CAPpSM+RQxXA-YE93rmmQL_K_gggrK4jAbpFTwVr5=-HtD3p=Hw@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	Kees Cook <kees@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>, 
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C77F9A0005
X-Rspam-User: 
X-Stat-Signature: e7dazyperadsncgy6fusswimmwmfodhj
X-HE-Tag: 1782769904-113894
X-HE-Meta: U2FsdGVkX192+zbngOyJoG88kREfwAYBWdnnx9sUsYWuvM/uDClrc50bB1i9blZTj5T7Eei/JPHDEMJ3mg6k09pTxamtiYH586UkI7tkvJ1kIEEQnBfdRMKCkqhT20WIGMUV+fot2xfghnljIqDzET9SaEmSVCd6ld3Od7OsVa40qLrKc9yA+L1g+6mmlv4jhoG8ojAa6AjaZLp6twnSsigYKu+Vu1GJYlDtQQ3p9SvlnHeI0QU5dIS5evXhnRqTZdet786apwNwIbCDinPaDjLzW05omp25c7bt3bIR4GT+RxG5IQIsQvNVU2mLzfeV8xKsdMvWGXEYkaqlV8ndJIF4cYWCJ8v6Liqrkr+0+YuY99ZLF7Ag4hv1kgxDTPoQWxeYkuVObPoBBFPjGqifmI0Tl0cvlMNo2IAIfRMfBpNlEBuLj5b2eBW+nDwbGHKAsE6cn+7nw9O4CeUJ4G0Qe3E0yPMcBvjegd06rTFWmzKkZkeuU+JuG0oNpDtMSymDLPMQ3x0FXTy48/bmo6KJgKPsBfE9onPj/m24mBxQUsXWZCl8qG9TmzCIjPfi5p0Z/Dzg81hb2JN3rdxXFwAuInlPZkshEmMGYQYTYJoXXMr408ttVSwVtDWtfzxdV7vaTQZhzyjiKFKcRLiZUEO5jqh0fbTqRopSJDUDSgbDvS6bNYxDPJWiuHs0VwbYn5zgQdih7qRf8UdMspI4H6RudeJ0fJTvYrDFlXgGxuPn597UQ3SXKxcU0DMqttStHFIKSTSrhkuuncpFGqUVEUiZ1CKzUKNogP5QByEW0LdAHCaSo6+prMwSwpbDPKZ2Lw6appdZdDDCR7BxrsKpsh5FxfSpLlc7y2AFDTOqEl8RtIfYT2R4wbesMN5ePu9AL0G/3Azw5XGbwA5pUjkIt7Kt191v0fZi5XERFcLDGHSVfUN5uwDmHPUqgHz4d+0MKb26BjcYCeTmGlolR+HtWdy
 iOvKyoID
 UFnNWj/ESgs0TnbZjotXOpcSBu/7tu+ko+d7+pg+gcIfPXPAJIZkLsxtmgeOI+KFVWLv9Un7hXQaHxKv029snMR7KQSfgxLbF8O7IzRbqR5/DkDc9E/P+kvKKJS/tb7C4laSdZwb8F8ka+X8vfZ7Akav8LvNmfbuQAwa0hAnzzlPyZupIT/a5m12ZIu60fQZUYm7wJ4rboFX4L4VIXaxK1dQZGoE/8MR4RBouUZBILH9HqU7fgv0aR9PiE0c34S0v4J0LPcNISW60LnZZjeE+IpJ/p12Eb6+QPELq1tAbTZPGrrnLLFoSVpJcwG6ltJWeb/qLaBU3+PJ2PvAchjrGwShvgV1wYRpA12hpdpIb/sAfIwRnrcY8VKvm0RWeE/U0Q68CBQQAH4GEQyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 2:50=E2=80=AFPM Xiang Mei <xmei5@asu.edu> wrote:
>
> An AI reviewer found an issue:
> https://sashiko.dev/#/patchset/20260626173444.2252041-1-xmei5@asu.edu
> And that's correct; we added one more change in v2:
>
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3217,7 +3217,7 @@ struct vm_struct *__get_vm_area_node(unsigned long =
size,
> return NULL;
> if (!(flags & VM_NO_GUARD))
> - size +=3D PAGE_SIZE;
> + size +=3D VMAP_GUARD_SIZE;
> area->flags =3D flags;
> area->caller =3D caller;
>
Sorry for my mistake; the change I made was wrong. What we added in v2 is:

```
@@ -5027,7 +5027,7 @@ struct vm_struct **pcpu_get_vm_areas(const
unsigned long *offsets,
spin_lock(&vn->busy.lock);
insert_vmap_area(vas[area], &vn->busy.root, &vn->busy.head);
- setup_vmalloc_vm(vms[area], vas[area], VM_ALLOC,
+ setup_vmalloc_vm(vms[area], vas[area], VM_ALLOC | VM_NO_GUARD,
pcpu_get_vm_areas);
spin_unlock(&vn->busy.lock);
}
```

Xiang
> v2 was sent: https://lore.kernel.org/linux-mm/20260629214712.1198680-1-xm=
ei5@asu.edu/T/#u
>
> Thanks,
> Xiang
>
> On Mon, Jun 29, 2026 at 10:21=E2=80=AFAM Xiang Mei <xmei5@asu.edu> wrote:
> >
> > On Mon, Jun 29, 2026 at 5:50=E2=80=AFAM H. Peter Anvin <hpa@zytor.com> =
wrote:
> > >
> > > On 2026-06-28 21:43, Matthew Wilcox wrote:
> > > > On Sun, Jun 28, 2026 at 07:09:37PM -0700, H. Peter Anvin wrote:
> > > >>
> > > >>> 2) `enter` is not rare since we can take part in the instruction.
> > > >>
> > > >> This sentence doesn't parse.
> > > >
> > > > They mean that we can jump into the middle of an instruction, and i=
t is
> > > > not rare to see a 'c8' byte in the instruction stream.
> > > >
> > >
> > > OK, I see the point now. The main difference is that ENTER doesn't re=
quire a
> > > REX prefix, whereas ADD/SUB/LEA do (otherwise it truncates RSP and ev=
erything
> > > immediately dies as a result of SMAP violations [you are welcome].)
> > >
> >
> > Yes, Matthew's explanation is correct. (Btw, thanks Matthew!)
> >
> > Xiang
> >
> > > This means that an offending bit combination is far less common.
> > >
> > >         -hpa
> > >

