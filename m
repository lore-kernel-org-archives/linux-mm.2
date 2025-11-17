Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1DD1CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 07:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F6A8E0011; Mon, 17 Nov 2025 02:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F958E0002; Mon, 17 Nov 2025 02:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8098E0011; Mon, 17 Nov 2025 02:09:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 171D38E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:09:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A902713C212
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 07:09:56 +0000 (UTC)
X-FDA: 84119224392.03.D82D35B
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id C8E701C0007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 07:09:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GeiXso+e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763363394; a=rsa-sha256;
	cv=none;
	b=yUOT4CY4eE7K1xvefcgucUTGT1rwGcaETsYLR/+++lpUgnvm1qAGEF4c2gPTrjLaPOFTCl
	UnG3l4ONY/B+c0oKGb4/prMCTdHE6ZYjdn4yh4vFXaGs0u3L2HIptkqc2QczzLXX3chn3y
	+sPzvU6GJYrEqhzWsq4Z6tApYYWaFHs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GeiXso+e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763363394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6kAYEEv5TQ+wrSSYWf+cvXP14kHI7w5lNXfO8IVQFc=;
	b=yfEDRPSSs5C1M611ZsDmX55+puU6Lb4N3G5MwcRJ5/JtioAti2E2oOY26darOvUS1otWzC
	WcE3v5CmiXZblNQ1sBlvJstpbu/l6ozbThZbkBidu8Eu/ho50O9CaJ2Kr+y41Mmj9dO09H
	JUklR+nmj5wdOJ2QXDMLCxeHmv3KbNY=
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6567a0d456bso1665703eaf.1
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 23:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763363394; x=1763968194; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6kAYEEv5TQ+wrSSYWf+cvXP14kHI7w5lNXfO8IVQFc=;
        b=GeiXso+e6Q+54ZBmO9JCJvIZYVVDDCS4MzPSzQVmGYvER8u2poKNhsGg/Xohb7GaAx
         8VaH7BHZbeZIpSLw/o6yiU1BOBK9ore5OTUwyC1O9t8p0I5gmMNl7G51z9wQYSVacDU/
         U8Ai/uHRt5ngA+iRoW6+odWV3hfY2gABtzaL8pYcYxzubHB3V4m/COinrEz+polotK3M
         JoWtOIlxCHd9+VXu2adMbdWuqzFnvTRzWTx+gJFjxXY1YDnFjUaOWsetMTZWPGpefxb9
         ek+Kw4JQK+H32UyqRFnOd9d+EjwNvJZwHOqBn3lB6CC01RRvPcEfxIv3tQy9yFQX62WH
         WhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763363394; x=1763968194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y6kAYEEv5TQ+wrSSYWf+cvXP14kHI7w5lNXfO8IVQFc=;
        b=leCJrElGFeSU3SiKGNpLmJ51CnMuwKjkT3s7OGm8fSBOB/vUYAYooz9fj+pgn0nwz0
         fLttTr3M/t5tnYdAhjPIzU+tEmJXMNyqtAUMEEurtv83sz9RigRhX5BnWTh433ogmXs1
         IvVG1E+2/O9F+J0OQbHu+ph47BJklEV/e8H5sX88PENwND0AOuOJae6mU9Wk81ciXEIG
         qwJvchgKVHAZnH38vF1yMJ/WcGDG8cPWpR5+Dh8qIn8VutvzpAzNw9uwXf66C247Wedv
         n16YK2IKra/NzbJmO4Yfqw2+7IUmhI9z9AMfdUgIXO0fMS4TiNFn+PoBy2USuHkO3iaa
         IkXw==
X-Forwarded-Encrypted: i=1; AJvYcCU6NOSTnI9FuQoc5SDk4LpqYXPa6IsL7WpG13+QYW8YdPVKI2mzCyJPudtate8Pj74NO8i5zf92Zg==@kvack.org
X-Gm-Message-State: AOJu0Yxoi8bK74DsJbQBnI7yDJ6GMElFMZJaWrlwEjUkd0zzaqqZKhxm
	kO42W790kdbFxZQEGZ1UiNNZwNMchpNIlc5ykgcD5YC4dlXjpoP3akryRNMXULG6aarU2cc51Dd
	Fq3Uey2Xg9eIY630EVvMvm3uL6C21AdE=
X-Gm-Gg: ASbGncscN+E44R1wcyATJ+3g1MgkqlpHMrzWMOtu1XyC8pmlPgTPsZ28zns3ZzQq8pb
	xjn9VgTEAkNZzgg7CtYPrRMMe+LheqQYVVV4peIwv/7BxNdLPTkMqmTA7oVZMlmOgxS8+h/K1lw
	oM6V6TJPi511akX6Ismx9lMHb9vnmPnsG114QTPrREJNNC/iqKsti1CzF89I+ztLf9RUioi/dQQ
	cngmfz08I6ApZ27EmIy8i3wJQMKJEhu5LTmnU+wtNk3Bs4Yy6AH3f0afd6O
X-Google-Smtp-Source: AGHT+IGtAMKdcNwX5JNP9AvmsSTEXLDU1Q/qojxQ1jBiaQ0UwDF3s8DU7QDzXU0GmdFQ/EPGLbp9Uk1nClpZkxFApGk=
X-Received: by 2002:a05:6871:e383:b0:3d3:8424:c14f with SMTP id
 586e51a60fabf-3e868e9f4e5mr5143719fac.16.1763363393578; Sun, 16 Nov 2025
 23:09:53 -0800 (PST)
MIME-Version: 1.0
References: <20251114161127.193707-1-peng8420.li@gmail.com>
 <6869aee5-0093-489d-bac7-fa718bdcb362@nvidia.com> <de65f1c5-8547-40fa-91e8-6acb06faa163@kernel.org>
In-Reply-To: <de65f1c5-8547-40fa-91e8-6acb06faa163@kernel.org>
From: peng li <peng8420.li@gmail.com>
Date: Mon, 17 Nov 2025 15:09:46 +0800
X-Gm-Features: AWmQ_bmHuuS-2q7IE4tI0HFLH7mdP-zskEDXWg4zP3VrJmAr9s-D_oaRiSmWSBs
Message-ID: <CAJFsz5z58Y_9DnuX8i_WWTQ=maM8h+9if0JpkwjXiguoeNdEOw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Remove the "FOLL_TOUCH" test code from gup_test.c.
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	osalvador@suse.de, jgg@ziepe.ca, peterx@redhat.com, 
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8E701C0007
X-Stat-Signature: 3enfdaw184e6xbn8w5ciogniszw7m9ho
X-HE-Tag: 1763363394-255627
X-HE-Meta: U2FsdGVkX19G+Z9DqnNRevHx8vqiP+XJvAi6K9rq/ge1nWVfAQUgCBmiplpXOYh7ncqUvBLCcOC2Ddy6LuLtDYuidZCEAPi477mAHq+6rON3AhQpEvGA9EakC41czXYHzaQ0VH2HAzBa2kcK+ZmnLpjUxTTVwT8Y9fKun0aWG9GVLBRY0fbGTMQ7tWepu95WXNqob6DY+3sp8H82Gulh/PyhM1n4RmkJjL5gZ7ycu1JtaCcVYQ0nuav5JBpl66h3dlk+ReXjqvJth1yRInlm8BOMUhcHcWv+YpzCV0vplIKPBIQ8PEqetPepAj3VWm8Rccb8j57NlfQtuxLhgQiBfJEfcVGgXDboXz9U1EOYiRG6LfK0N0BPfkGbyAAnQimC0M+Ubgj/6wu9TQr1xGQJfpgfCwbiJXsneNwWK7LCefi+ezNkcP+fkZZCEyWjGv0SbWqv5i8JfzGvgdCWn+YzrH7bHjCBuazN1wQ0ahZcHbLUIEgDFEYaRY8jtsUrBWUUgGiJQmV+xMeQUN7LY7EHkjCBn9+OrlEZEi4WMOkrV7+pFNvFXfIYVjTV/8g96S4jvA5Izs/KgJW1o9nd2F7pD8F0+BnJHds695AmIrMpWmEvl8HRpE3//OEP5vuOheVG9+Yc/ov4sEPaZZMj9bK4X1TnH0r0enshe9ebwLK0h/NKzDrvDAm1qOpKDmOB51T6DVkWOwdtNolZ2+A6fJPUts7H9/XTfMBiC/sOtJsE31KG1r1+zaXjtIndblxWMt6kjILUhWfVC2d+Q9P1G3tuo87VSjXvgfMEhKbHQxutlPJASp5OgiBZfW7TWLh4nX9tKA4xrk4DjRtW+xPZjFjb/Q5h5X8yGS2tnspqMOlRZX/m1O6RDJm/OTogvQCI9lwjjr5XRopbzjbU+jEqnM348/MCDtRmrvoNwjjh9gYI5OLPIFsaPVLtoVkT9iGaXst2pGF1rYDtfSBvA+zhBrP
 hTmNK80P
 5Qe4nhSaD96BzG/4RnhLUVmPSO3EwKUgTj78NQE+KVLNanAtkypEnK3bDpCey94gt/zmBRL/C/kTiLMp027c3Z6r84sGt5RZi/brj1lQ/2omZqnIJnMvPcXFny3pPLAiEv0z/5v4452/mGJHZ97zTk0jBOE2ZW7ZfeRLpWXAJTLKPgMlR688JCkRaYFHrG/CXHpgbDAvZQKHtdqtUecGY1yWQDJ+aIDJaSwA1tMP9ZtG7jvci+n7HwUeyJEjmSTEhLJzWDyL8SttN30SlARmP2+FoEQ3/Tz7u6iaCwMztWY+GSwAqVD7XKSK6l05uXt5ld6Hu6dFvqqnAYjlZcxO/VZqfqODqBzek3qchE4O12MSbCxf4xPm0AgLKOBLbSGdBJtL9XSDZTVdgpWet6nKw3dpdAyJC8IO8Xl5I/rar//W5i0xsNGTyL6D93olIb4obtF+LaT4fbgB4/vwLALFrzGQcfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand (Red Hat) <david@kernel.org> =E4=BA=8E2025=E5=B9=B411=E6=
=9C=8815=E6=97=A5=E5=91=A8=E5=85=AD 05:39=E5=86=99=E9=81=93=EF=BC=9A
>
> On 14.11.25 21:24, John Hubbard wrote:
> > Hi,
> >
> > The diffs look good, but the commit log and your replies have many mino=
r
> > issues that add up. So you'll want to avoid them in the future, and wit=
h
> > that in mind, I've listed all of them, along with suggested alternative=
s.
> >
> > On 11/14/25 8:11 AM, peng8420.li@gmail.com wrote:
> >> From: "peng8420.li" <peng8420.li@gmail.com>
> >
> > This should be your real name, such as (my first guess)
> > "Peng Li" <peng8420.li@gmail.com>.
> >
> > Also, if you are sending from the same email address as your "From:",
> > then the "From:" item shouldn't normally show up (it's harmless here,
> > but could be cleaner without it). Check your .gitconfig send-email
> > options and you can make it go away.
> >
> > Also, when replying, your email client is apparently using HTML, please
> > fix it to use text only!
> >
> > Please read the patch submitter guidelines, too:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/submitting-patches.rst
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/submit-checklist.rst
> >
> >> Ever since commit 0f20bba1688b ("mm/gup: explicitly define and check
> >> internal GUP flags, disallow FOLL_TOUCH") we marked FOLL_TOUCH as a GU=
P-internal flag.
> >
> > Not "ever since", but simply:
> >
> > commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
> > flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.
> >
> > Also, it's best to keep the line length within about 72 columns for
> > commit messages.
> >
> >>
> >> Therefore, remove the "FOLL_TOUCH" test code from gup_test.c;
> >
> > Trailing semicolon. Should be a period.
> >
> >>
> >> Otherwise, executing the test command "./gup_test -L -r 100 -z" will r=
eport the following warning log:
> >> TAP version 13
> >> 1..1
> >> ENCHMARK: Time: [   39.363371] WARNING: CPU: 1 PID: 117 at mm/gup.c:25=
12 is_valid_gup_args+0x66/0x8c
> >> get:2818 put:46 [   39.364043] Modules linked in:
> >> us# , truncated [   39.364311] CPU: 1 UID: 0 PID: 117 Comm: gup_test N=
ot tainted 6.18.0-rc5-00324-gd09eaf415c87 #29 NONE
> >> (size: 0)#
> >> [   39.364434] Hardware name: riscv-virtio,qemu (DT)
> >> [   39.364546] epc : is_valid_gup_args+0x66/0x8c
> >> [   39.364596]  ra : pin_user_pages+0x38/0x78
> >> [   39.364630] epc : ffffffff802079e6 ra : ffffffff8020c214 sp : ff200=
0000041bd20
> >> [   39.364650]  gp : ffffffff81a26068 tp : ff60000080b3b000 t0 : ff200=
0000041bdf8
> >> [   39.364678]  t1 : 000000000000001e t2 : 0000000000000000 s0 : ff200=
0000041bd30
> >> [   39.364697]  s1 : ff60000081300000 a0 : ff60000081300000 a1 : 00000=
00000000000
> >> [   39.364714]  a2 : ff2000000041bd3c a3 : 0000000000080000 a4 : 00000=
00000000001
> >> [   39.364731]  a5 : 0000000000010101 a6 : 0000000000000001 a7 : 00000=
00000000000
> >> [   39.364747]  s2 : 00007fff7eeed000 s3 : 0000000000000001 s4 : 00007=
fff7eeee000
> >> [   39.364761]  s5 : 00007fff7eeeb838 s6 : 0000000000000000 s7 : 00007=
fff7eeed000
> >> [   39.364825]  s8 : ff60000081300000 s9 : 0000000000000000 s10: 00000=
00000000002
> >> [   39.364842]  s11: 000000092869bfdc t3 : 2152ffffffffffc0 t4 : 00000=
000001fffff
> >> [   39.364855]  t5 : ffffffffffffffff t6 : 0000000000000000
> >> [   39.364867] status: 0000000200000120 badaddr: ffffffff802079e6 caus=
e: 0000000000000003
> >> [   39.364949] [<ffffffff802079e6>] is_valid_gup_args+0x66/0x8c
> >> [   39.365036] [<ffffffff8020c214>] pin_user_pages+0x38/0x78
> >> [   39.365049] [<ffffffff80278f78>] gup_test_ioctl+0x2b4/0xc08
> >> [   39.365060] [<ffffffff80297da6>] __riscv_sys_ioctl+0xba/0xc4
> >> [   39.365072] [<ffffffff80b93f96>] do_trap_ecall_u+0x296/0x370
> >> [   39.365093] [<ffffffff80b9ef06>] handle_exception+0x146/0x152
> >> [   39.365220] ---[ end trace 0000000000000000 ]---
> >>
> >
> > We don't need all of this output for such a simple case. Just the
> > warning will suffice, and even that is optional for this patch.
> >
> >
> >> Signed-off-by: peng8420.li <peng8420.li@gmail.com>
> >
> > Same rules for the Signed-off-by: real name needed here.
> >
> > Combining all of that, your commit message would look like this:
> >
> >
> > From: "Peng Li" <peng8420.li@gmail.com>
> >
> > commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
> > flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.
> >
> > This causes a warning to fire when running gup_test, for example:
> >
> >      $ ./gup_test -L -r 100 -z
> >
> > dmesg:
> >      WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0=
x8c
> >
> > Therefore, remove the "FOLL_TOUCH" test code from gup_test.c.
> >
> > Signed-off-by: Peng Li <peng8420.li@gmail.com>
> >
> > With the commit log fixed up, please feel free to add:
> >
> > Reviewed-by: John Hubbard <jhubbard@nvidia.com>
>
> Oh, one thing, subject should be something like
>
> "selftests/mm: gup_test: stop testing FOLL_TOUCH"
>

Got it :)
I will revise and release the next version based on your and John
Hubbard's suggestions.
Thank you very much.

> --
> Cheers
>
> David

