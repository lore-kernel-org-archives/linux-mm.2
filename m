Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68AEACAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 00:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10468E0002; Mon, 15 Sep 2025 20:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0B08E0001; Mon, 15 Sep 2025 20:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF8C8E0002; Mon, 15 Sep 2025 20:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9358F8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:32:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29B7B1A07AA
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:32:30 +0000 (UTC)
X-FDA: 83893237260.08.93E5DA5
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 70F57C0005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:32:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vr8LybIW;
	spf=pass (imf10.hostedemail.com: domain of jthoughton@google.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757982748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JkteiQP6NI/P8CBfx2tNSejE1W7I9xl6Dwbvtku3xk=;
	b=A42K9BMIC9+iT8MZnLtacpXeenKYCw6sz+SEpoTqjHUliZHSYeNsandD0FlXusyxZpY0gr
	xIDf8kynC51ECb9OWoK5qJvXIljnzXMUFTA6iHtMCmpXOoYfSt56160kobSaEex9I4jO0N
	JaFT6uhFYjI7ZsZehNZDa8ioyqCReHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757982748; a=rsa-sha256;
	cv=none;
	b=3DeUt4kG7Ou5ZvGOy59X1IMbggEysDFKtXVHkN0cqDRr+4eLcBntwAH5L07boc80CZ+VXZ
	kzAoEuhRG0Dc4orznhKfEAIcPE4lw9Co0RfsGDtv8V8K7r2Yj1KbPmnQV/dq7qJavAPb8S
	xQz88aSUGxlUw/HZwuYfX94/MOenPOc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vr8LybIW;
	spf=pass (imf10.hostedemail.com: domain of jthoughton@google.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e931c71a1baso4733508276.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982747; x=1758587547; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JkteiQP6NI/P8CBfx2tNSejE1W7I9xl6Dwbvtku3xk=;
        b=vr8LybIWrMOIVaCW467OGV+IoOjbY76kMFnSWbEhNObjnKU1TjR5wzRHLlZGXZO0eU
         +6J3YyP2sVNOVmXpmV22Y9qmx8Ya1LyTxzbrhmepC3Fp4BJobVZfB8aGwfl6QQAiXGde
         maOWMMRnBQTZGC7e8upehdRtla5Neji/Y6aaZUPcy+m2YpgSLGrnyQ4M2hZZAG8hEGY5
         RI01ySWkHTC3HMYgaFdewzuTDPg/BfWrQpfdSxASOZJj+Q3KS8Yg2LjqwGUzI8+hZlWK
         Zma6u/9ZlS9hW0UMRZnzGV1gXbRR7Ni+CLQYvg34DPLNHHi3CcvqeG1QIBpUsZj3X7HP
         3oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982747; x=1758587547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3JkteiQP6NI/P8CBfx2tNSejE1W7I9xl6Dwbvtku3xk=;
        b=hLT0uUoFoShR+yprEX8oRPViPuXPgftXEcr28MUyFL0VnTr81nn6e1TSgIB+FFRx+3
         WClL+uX2MIscJIGhArMZtzbjUIR36YEP5A0rXl3AvAvp4WIP2ypqIslNUyZAMJXPn2Z/
         YwGNShqmFCczvNG7PLym2xvOkIaerOA8lfGFmJaeZEHoHI1hNvaK8kPq1Q/rE/wVkolA
         Hws7YjlQGbX9wkfuUMf/YQNNPtULX6WJNGmzpfooOBnd3qwcpyLPbZ4ZXvPs5qDPOZPp
         pHewspZu03wfAKFmYFCqAkYzbbqYf5wdv18WhT83HXP3wPSa+MWQWZ+VlpXmcm7097xS
         FzyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQ2dDCHT2U/h9rzZawOAvd7gXDunqc03yqvsQAnPeh2mZh8TDViEmVj8NZ9iyacmsP7p3F+8dAVg==@kvack.org
X-Gm-Message-State: AOJu0YzNkBvKWS+u2Qf66E8TaZRgdbOEnXuVg3nLcVh1hVk780BvOcqT
	auJzIA3tKBlnPBQsEEtA6760xofwHBLR4rB27wL/wF8zfDHsmWWq9AzOarDk2KiHyF2gZutdkL5
	hehTBD/8U9arp530YABZljvhFgGXPAujoXS/7IMyo
X-Gm-Gg: ASbGncvJMpvecNVRFaxxWN1NAxo6zDujzTq/gbiiwmytXdjy1WDouq+lNE7H6bXRqr9
	cJ42w4VckeKlrvjBHjDvdLa4iv9HJla+ebuDY1dYZirt4xafk+N/qg1bBxBQoA379zEdapClduR
	TyVnStN4RcADJbaPAKF/QQFNmBj6IWa53XPcJ9bhvAV4oo2Im/0jVzYvWxMJ3eZ/Ztg6Wz2IKKh
	r+NQ2YebilbL7Ly2f5yc0pya0bwmphi6eqDF7bMogtZwzO+36sdYT8=
X-Google-Smtp-Source: AGHT+IEdJ5GW1k6DJa97Sn3qKEgLcxzUjHNQDObC/MhXDjyVi19KXNf4PNV3yyo7ie0nCjYnN/wtIrkzfDaH34CT258=
X-Received: by 2002:a25:ae8e:0:b0:e9b:e18d:38c7 with SMTP id
 3f1490d57ef6-ea3d9ae69a3mr9180380276.52.1757982746887; Mon, 15 Sep 2025
 17:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <1757967196.153116687@apps.rackspace.com> <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com>
In-Reply-To: <1757977128.137610687@apps.rackspace.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 15 Sep 2025 17:31:51 -0700
X-Gm-Features: Ac12FXxIfttjKk3Z-KZrc9_nOPc_6Joijt3UqaJCPSyno-s5EmLapBX-KiO3PiY
Message-ID: <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range fails
To: "David P. Reed" <dpreed@deepplum.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Peter Xu <peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 70F57C0005
X-Stat-Signature: peqmb9x1u4fyun48ze5qwt5iioxa17bb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757982748-540270
X-HE-Meta: U2FsdGVkX1/kNeIPCC9YwmJd3ek2IhAcXAi591TFAq97ViwL497DSkUcjJ56kAElpG6czB4pmwamfbjF1zdfcKGQW+1CNtqNYSHKWfKftkuoJQlyO4tOP6mQ1bTdYMw8d/yU3XeSp7p2e6AM0VH4qIBDhSX4ME0uH+OvyjX7++jS8EF2dVm18RkvdIUOe/Bg5/y4kX5MAOhVJFCnKasyCbjxTXOB9/S77yBq27r8RsV4PwKHUDw9BbcSYLvcEFMRYqwDzOE4Twa+tqsu5121tsNKL3AuDfe4LmSHWtIIMblb+3MHghjrBQonbk46MMfXeJJ5/y9ksJjiVZ1bT05eQF2DPjGy9kbRLF4ad/OpmrSCiwS1XbZ33jE6XEYiWvQ1ZUs41amOfGv7SqUThKqR91X3n4SGp/jrURWnBbR/4lFgT3IOCUeOb0KXzfj8DahiDYn7ABD3m8vFKOY2L+XYS0xBSLzBObCW/VhZK8gd+oJdkeIdZL2NXoCU5g988RLuDwj+3PqJl+3wc1mkdFo83jqB6p8Jxx4Ro6FEdIpPOm5OWeWxxEqyal09FIeyCPZlKcdIcG9L/Wobcfj2JSNSt+cQ6ypzVNmAj57altRG6fb08fLneUsFHgGPk8YcfMbfSZzO5K1YkrOzpwbaGMvXbesbW87yVtxyDwUtRN88arDWEoprKdx17WVUSQ0xHLVHu9wZ8fPAjyLpQ1vh3YTO6+VaRKCHgIv5uKCpVbk0p3IaRAt2XDszpVRw6v3ZIE5ztGvOjT1DhcEgFPo/TcDcIBIkKgLokmfjpLdzZ1O6EpqhnCDx96DrERW29qMeip3jgAsKpEwUylD9bTRdle8qZlBWZpgA7XrtwgJkdAsU+CqOVfV6iC0NwvsKgMl5qTyqBiUFTzrm5slN85DVBBjDffwMTqUi0hMjZ0Tx8X5H1KGuzHAzIgeiBV4JKyNq3O8oLJZ15Az9yho=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 3:58=E2=80=AFPM David P. Reed <dpreed@deepplum.com>=
 wrote:
>
>
>
> On Monday, September 15, 2025 16:24, "James Houghton" <jthoughton@google.=
com> said:
>
> > On Mon, Sep 15, 2025 at 1:13=E2=80=AFPM David P. Reed <dpreed@deepplum.=
com> wrote:
> >>
> >>
> >> [1.] One line summary of the problem: userfaultfd REGISTER minor mode =
on
> >> MAP_PRIVATE fails
> >> [2.] Full description of the problem/report:
> >> The userfaultfd man page and the kernel docs seem to indicate that an =
area
> >> mapped
> >> MAP_PRIVATE|MAP_ANONYMOUS can be registered to handle MINOR page fault=
s on
> >> regular pages.
> >> However, testing showed that not to work. MAP_SHARED does allow regist=
ration for
> >> MINOR
> >> page fault events, though.
> >> Either the documentation or the code should be fixed, IMO. Now reading=
 the code
> >> that rejects
> >> this case in the kernel source, the test in vma_can_userfault() that r=
ejects this
> >> is this
> >> line:
> >>         if ((vm_flags & VM_UFFD_MINOR) &&
> >>             (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
> >>                 return false;
> >> which probably should include !vma_is_anonymous(vma).
> >>
> >> Or maybe the COW that might happen if the program were forked is somet=
hing that
> >> can't be handled, which seems odd.
> >
> > UFFDIO_CONTINUE, the resolution ioctl for userfaultfd minor faults,
> > doesn't have defined semantics for MAP_PRIVATE mappings. The
> > documentation is unclear that MAP_PRIVATE + userfaultfd minor faults
> > is invalid, but this is intentional behavior.
> >
> > What would you like UFFDIO_CONTINUE on MAP_PRIVATE to do? Should it
> > populate a read-only PTE? Should it do CoW and populate a writable
> > PTE? I'm curious to hear more about your use case (and why UFFDIO_COPY
> > doesn't do what you want).
> >
>
> Well, I was just expecting to UFFDIO_CONTINUE to do whatever "normally" g=
ets done. So, the normal case for MAP_PRIVATE|MAP_ANONYMOUS, if the page is=
 in the swap cache and thus takes a minor fault, would depend on whether th=
e access was a write or a read.

This minor fault is not a *userfaultfd* minor fault, and even if
registering UFFD_REGISTER_MODE_MINOR on this VMA were allowed, you
wouldn't get userfaults. This is because swap-outs for MAP_ANONYMOUS
VMAs leave behind a swap entry (!pte_present() && !pte_none()).
UFFDIO_CONTINUE cannot resolve this condition, so no minor fault is
generated in the first place.

Why can't UFFDIO_CONTINUE resolve this condition? Well UFFDIO_CONTINUE
only populates pte_none() PTEs; it will not and should not obliterate
a swap entry. And no one has a use-case for making it trigger a
swap-in.

The same logic applies to CoW; CoW faults are not (minor) userfaults
because UFFDIO_CONTINUE cannot resolve them.

> For a read, the page just gets installed in the page map from the swap ca=
che.
> For a write, if the page hasn't yet been copied, a copy is made of the sw=
ap cache contents of that page at that point, and the new copy is installed=
 into the page table of the writing process.

Sure, but if this is the behavior you want, why do you want/need userfaultf=
d?

> However, the problem I'm reporting is that I can't even register such a p=
age for minor page faults.

I understand; I find it easier to speak in terms of the behavior of
the resolution ioctl (it is equivalent).

> Now there is a question of the meaning of UUFIO_COPY should be (not conti=
nue). If page is MAP_PRIVATE, MAP_COPY is like writing to the page at the t=
ime of the minor fault. So the version of the data in the swap cache for th=
e page should be ignored, replacing the  local version makes sense. Any oth=
er process that still has the original version from the time of the fork() =
that shared the page should not be affected, I would think.
>
> There is a confusing possibility, however, with the file descriptor for u=
ffd. In the case of a fork(), the file descriptor would be shared, and so e=
ither fork could end up listening via poll/select.
>
> It's hard to decide what is right semantically, because the normal use of=
 userfault is to monitor from another process, though you can use read() in=
 the same process as the faulting one - this seems to be because either for=
k or a unix-socket can be the path for sending the file descriptor to anoth=
er process. But this is just definitional, the actual user design would hav=
e to handle faults in one place or another.
>
> Now in this case, whichever process does the first read() on the file des=
criptor would get the information about the minor fault. (I assume both wou=
ld NOT, but I'm early in my use of userfaultfd). So it could continue or co=
py, as desired.
>
> Generally, anyone using userfaultfd would understand the nuances of fork(=
) and file handle duplication. So they would probably close the fd in one p=
rocess or the other, as appropriate. (I admit I haven't tested what happens=
 if both forks try to use the file descriptor, but I can imagine it might b=
e useful if they coordinate carefully).

I am not really following how the above connects to not being able to
use userfaultfd minor faults for MAP_PRIVATE.

>
> Now, if many forks end up sharing the uffd file descriptor and also end u=
p with copy-on-write shared pages in the MAP_PRIVATE region, the above defi=
nitions of the continue and copy would continue to make sense - to me anywa=
y.
>
> Hope this helps

I still don't have a solid grasp of what your use case is.

