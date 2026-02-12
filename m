Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86FCCEEA852
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96FB46B0088; Thu, 12 Feb 2026 16:31:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947C66B0089; Thu, 12 Feb 2026 16:31:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854246B008A; Thu, 12 Feb 2026 16:31:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76E016B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:31:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F506B7D3E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:31:02 +0000 (UTC)
X-FDA: 84437099964.22.DBC168D
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 18C7040019
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:30:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QngmuSOc;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770931860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1MnsyejUIguL7TdGy358PcnMB5B07knhPkkSDi0PzU=;
	b=t+0o6p/6bKEwtyI20ac732nJ3O97NpRM60z6/zllPshlt+T3pQRcWw3Ypo3shyrlYNwrA3
	MLO6lHzVtSm3wthiEeTw7ATji7/0tVxBWKDjMMg8QusW/+mJMRfxGYQ420vJlMwVJxM4Fg
	IJIw+ZSXZhzEEg2uOuKaEVANY9SnMFU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QngmuSOc;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770931860; a=rsa-sha256;
	cv=pass;
	b=aHg+AUeCIVMMT1cjgtXVCS5LE7rlVU0XSktZk49nkNtc/A65hi6cGHl1i7LX6yV/jxrgyi
	KcjLgiVcJ0MeeZxYuPUMY3m9+Te+XEJk8uSBc4mEtiwUUvFj4DkTrM2/E8UFLoUGwa3l62
	7fXiMIn/bTKUfLBrZm0wqOJeCfd4eUA=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-506a355aedfso53971cf.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:30:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770931859; cv=none;
        d=google.com; s=arc-20240605;
        b=LHchrNdJ149S7/TWqNeMlSXC62evJ6hAmqMYskg1mdDalcDk3GEDaeVpqs2MdmLT4W
         mOYd6ZeIkS8u82agSDqGCfdZkB03rLlZcKM4gzcyNxWSSRgJBKf32gEBAE5AUSsbpM0u
         mrVsph+u/Bfrl166p/0yEBmIy4aL4ZWHDjR+Ub9EKao83S3GjNOt/DjVvTedOcb33Xiw
         hf3kAj5BRX1wVHZDOh8SraHJLLmD1EUSDYUYfwGHDvXS06dWXJdS+HFvc40DMGv3preo
         VeK0B96SPpxMttnOOXR/DQ8jpRyFX1NrFQPyBhEDNzKJUWtm7FORjYpciAS4gNXcEUd9
         z6/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+1MnsyejUIguL7TdGy358PcnMB5B07knhPkkSDi0PzU=;
        fh=7HnIm/EVDe+Kug20WZcxtH+/uDPZO2jJrPNFva+8F5k=;
        b=NY9z73VygxkQdm4zSmiTGVCxfGou9b5H/Dtm6TePIZlj7lm5xvVEVInTvG0uR4fUrQ
         SINepa/kH3vVtfX6lAZmm3m8UZvjF6A9wT/3jIolNEuDtprxskxqqHe4WWBfojgHExbv
         ebBC3C5oXZUNyeR1HgKXPPn3bZKEfEOVj7CJZHCxvg1eWv+DGFKD5ghspxRG1g5X2/I9
         eqII8I7hoEy0ugDCZG/uefFx3pQOKDqA9qwC9NR5yfP0fQNFgVE6gRBErNTevNKnXwEd
         tmq4Jz0Ppz7RKrdqAEK+BpeDsBG/YRl9hK1co76YDrNQ+nCwfKd7z77dMjnx4addY3qB
         Mexw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770931859; x=1771536659; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1MnsyejUIguL7TdGy358PcnMB5B07knhPkkSDi0PzU=;
        b=QngmuSOcmFuzlWn5ubHgz033l0m8Nz5hbA8zr64kK6O3vWT7dN1vkF5G15NU9eGKRq
         s++TaivufP6AkQXhNThG92ne5W8K314/AujJ7CfL2DjfCSCj+QuRXX+LNeJDgEV0paNW
         fiG/J29dK6r4JGIVkFJ9uqZ2mOqzvHXIE7/h7J7CojvPZZRmRscpTGZpHcUTEGrkT9bl
         ZsjigyTWByM4KTcBC2SDKmoTZwmndkRiWwyITY37CfVTjQiJ3HQshEktkYoCjPyPvPjK
         H9powcJ5/bKu55s+TpT7QyDHPzOugldagNbfKq6H+bGpN5BRFcsddH7QoyXTzdI0xOmx
         y97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931859; x=1771536659;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+1MnsyejUIguL7TdGy358PcnMB5B07knhPkkSDi0PzU=;
        b=Zd5Cx7ZQPquBhH7VFORHbeOKCHjWGeuNKiDm4aEVorV8MiRMrSDB7C3S6IaMVOBKlU
         ghXO1jVbmHAnjQWkfqyRQDqmp063Bc6dRySYLFq8ubC375Kj0Xx8bGmdLZofhkw38Pjl
         YDRvpmc4lsFQYIg4kUoK7lN1zG6lZnFr6obdtwoDZF5cxK2wHTLX4uk+UW9rSAxUYxqL
         B11nW7BTk6o3cwRQpHHNKVu3CoAlzlJQFXlCPOQWnQ1aWevmZps1yEydvn1E5QcK6Cia
         c795XVL4tzs2lmA8z9h2ctkVkQVepg2NynbSHwP6+B1WG57XLWrDjmjrzojV35fdvVpN
         qgnw==
X-Forwarded-Encrypted: i=1; AJvYcCXWsBvgPnc94GzJ724BO2C/hkDbj86bYZvv6qKh/H0cp/VxwzLYo+gjBO0Sc9GV/4yuXRMIU7A5bg==@kvack.org
X-Gm-Message-State: AOJu0Yy52MZmueTtvfsoTJ813YKQLVbBSG4tdv83ADpIDnuKm4FRg4JH
	nPlgVXQ6Kb/HDu2yto3UYKFmU0a2dfKp7c+uiB2RFMkhPUbo6EUMrxrZV47Sqs7gVvdYqVXeX8v
	Aazuyht7OxDLaYIVPZu6c1agzVG4DqHvlhCzMIR3O6ErdOqQn+ugvw7fd/yo=
X-Gm-Gg: AZuq6aICzb8J85K87jcRHCuhag5nsl/tcuR/CggX1+rC8rkqGXEyAQbui++DK41rmUL
	wYnErhqeIenCshHJj6OVSn9h4x5DA+U9aYUfobrYBIa9757BHC9+jdmF5m5sFjOEOLCdU1igv+R
	qxU2bT1t8n1r137F0hh4QufeJzkHTF3g3V0n/ZIPhtRdzGQ7iaci0A4gdl2T1w5V6tczhPDiEhZ
	0/nX/HmrYAyzra5Bg1xzA2tcyHc0AOIwzelaxnzamKND01J0No4v+fxAqMEeUaV76GTTAmLJ9wk
	asUG2VXPEi6vwFJQh7FjvuaurFGkvtF0XDuS4Q==
X-Received: by 2002:a05:622a:64e:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-506a6b1ada1mr661841cf.5.1770931858680; Thu, 12 Feb 2026
 13:30:58 -0800 (PST)
MIME-Version: 1.0
References: <698e287a.a70a0220.2c38d7.009f.GAE@google.com> <muuhcv22gzsr2a3g4lsu4zqsjkdbjqxn7bszh7r4nuqgq2oc5a@7jqpwr6v2vez>
In-Reply-To: <muuhcv22gzsr2a3g4lsu4zqsjkdbjqxn7bszh7r4nuqgq2oc5a@7jqpwr6v2vez>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 12 Feb 2026 13:30:47 -0800
X-Gm-Features: AZwV_QjMIniB--T1WOFYw8yxF2cSZNF29_haM7ARGBVWC_C-koM4OkUeUfM7p50
Message-ID: <CAJuCfpFkHnmX_40RdjnWmicB46Miry6Bc6Lht2rfno0jopraUQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in mas_walk
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ye3jej3u64zh4pcpy6i7a51zhh57sjpc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18C7040019
X-HE-Tag: 1770931859-93399
X-HE-Meta: U2FsdGVkX19NWdaUkoBrRfze4m71YwaXJPNR2AwtW3Sqt7XeGHd5P8km7yGUSx5wSHc5oFVVYswVDk95eTaq8zwBq9eOcA4d0oktj1E6G/mEiv++BKsHVn0DXe1svT3Z3gBog4i1A+XhAAPVIIqt+rn0J6iZaKx3I2tVRUo6u+2m80I9tM1sNFNDsPV/sUkDTlbFKAMPFWSwdpS3UGo8QBkLR0Gjgu5F5Z+mq7zCPeUxHeupcXjkpIJMdVwv5fznZkd+ZyKLD1u56mwPZu+8YsIKdziSDgu3cnkg+vnJJxO4gsnNumhk/rpecR5r+J53T8OKm0bfChiry/ArM4mMkoZD8KQKry+jDW4pU06K3meE4Vs/rsP1YBIez2fF10OtsRi5z76+lq2ee2wdO2L2HIxln3UF4Mj5mbP64+ffC5ad0VFoyH5q0zrpNZLCAti0gOMHha2bglUoTf3zcuOsuHlyufBMtteXp88nRXpawoED6RQ58uG2jpLMWL0ngH/LivHXz3XuMSTzJ6p5epBbkyREQwjqpiAjKSBwsmFbATIb5eX/ZicvpVbO6LFS95NsDZ/ZF0IAznqsNOXz5kcxDlBfRoOlbBMrmEFxAB1wtHDWYrfYVFDDBc2IG/d/8CBtCn2LyYbWk1N1P2NwQM62jpTUoI14OZ30d0vbbbzrMEAtBatn0ltgXFJuVQ9JAvCkQaOw7YnXxuTcxMedYGyxfaW8T00uXsMgk4i/gFekkH38nmUKUelv/ElfBesbKTsXHSRPsGAaOv52uj05wReAAU+sYP0O9D+pZYomsdO/ojIdzZHhkci+GiXmZ71SKWtjxUqY2rSFhIkQ95a/HdZkW8w+zCItKZWZEbVCNr0vXfVhQMRJE69VHBnEAmd8E1mia8BdmMvcON30FM8YI7lVm37X4glTR91csfZhCar15K2OKA15NzJiWhllXRwDyOmbFTa1BCJq6sHqmmXNdQc
 t/oB+z6s
 k/E3QrC9I98yMJV6Fj23J5n/aMYxsdn1R+w/YAYtwn/rJsub4KRQl5vyOL/3iA46PRP5RleoCSEZAXGYMXEjcQVAA45N4dD2PjZWpReDjClho+jzwXq3T5LQio8EJs2m5TQ9JpFqQN7EpFj3FqdZrObU+47HbFRCvsFidnUYJUR9CLH3cRn8d1DR2h1YdVWH0Yssc8k8YtLibLC9hh7/dLtTSZ23mBHF0YIGdXNjHJCT/FtsU/P/10M6pqN6/W3kFa17n8maxv7Dt1SCsYEjGyZU+2UTPnkud+U9JyQjX14GbriuQgk7tpr+hY4sarGAkOOxATr1K9JpNBAq3i66mJTz9fvUL93uOMyyEBaBtZphZvviry3ETXk7qYYe2wn+XVZMJ+Mv1KHxBhtKnI1FEQdh9lUyqv2OnuedBuwSOSmZUN9gNue5Bbze4Xno+17Qps0Lsl5YyAcE81Qe3AivBYjJrZOn7k8H2/TkVKD8lfvxYjLKOQkxxGOTn4iIk9NunDN5rP3W4ftId9h0uGaTbaM3bGIVh2k/7GtZba/Ugz/WSV/2LIT0T7038DYRlbILVcoLeydZ4LPSGBzofeA5HApWvrXs78a0WtHGHwU/XnWbxRNUH010fUH0g01khYneP5Bo+t7VCoL9KXHFf/Khoe4jnELybFwBo5tZzhDorcdGD7FqwwTHlvycemPJXikfbmbj5x6eMkmNDZFrOtkarUGoHRecM7OJcimG4ZLpacVk0SlpG25sGQJ6dgcgBgtz28dYZuI1Wgzh5FZpsEWU74CAvFJ3ITGZrJ1tBbs0BPoYH/8ISD6KNoZhOUEpcdF0EpzWy+aQsbj47e/YYDK2d592mnc7I3zhv0uJCipubguKk/IMhILSEZhn6AajC21eIveKKOWU57osHyxMRvbrFuzrK2/ikQJ7QkzRTdYZaXqwDiAEVQ4HqHuR97xCDNVB3wTI+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 12:56=E2=80=AFPM Liam R. Howlett
<Liam.Howlett@oracle.com> wrote:
>
> * syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com> [260212 =
14:22]:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    192c0159402e Merge tag 'powerpc-7.0-1' of git://git.ker=
nel..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1304cc02580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Daaa1d655bee=
4457b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D54245a237762e=
7cbecf0
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for=
 Debian) 2.44
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13d40ffa5=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1704cc02580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/a42150718371/d=
isk-192c0159.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/4cda72c184d0/vmli=
nux-192c0159.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/404b09fd74ca=
/bzImage-192c0159.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com
>
> This looks like the mm is not reference counted correctly.
>
> The maple tree has been destroyed via exit_mmap() while
> do_user_addr_fault() is executing.
>
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KASAN: slab-use-after-free in ma_dead_node lib/maple_tree.c:572 [i=
nline]
> > BUG: KASAN: slab-use-after-free in mte_dead_node lib/maple_tree.c:587 [=
inline]
> > BUG: KASAN: slab-use-after-free in mas_start lib/maple_tree.c:1207 [inl=
ine]
>
> This shows it is the root node that is incorrect (which is stored in the
> mm_struct directly).
>
> > BUG: KASAN: slab-use-after-free in mas_state_walk lib/maple_tree.c:3291=
 [inline]
> > BUG: KASAN: slab-use-after-free in mas_walk+0x8cf/0x9b0 lib/maple_tree.=
c:4599
> > Read of size 8 at addr ffff888078907400 by task syz.0.18/6008
> >
> > CPU: 0 UID: 0 PID: 6008 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT=
(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 01/24/2026
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> >  print_address_description mm/kasan/report.c:378 [inline]
> >  print_report+0x156/0x4c9 mm/kasan/report.c:482
> >  kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
> >  ma_dead_node lib/maple_tree.c:572 [inline]
> >  mte_dead_node lib/maple_tree.c:587 [inline]
> >  mas_start lib/maple_tree.c:1207 [inline]
> >  mas_state_walk lib/maple_tree.c:3291 [inline]
> >  mas_walk+0x8cf/0x9b0 lib/maple_tree.c:4599
> >  lock_vma_under_rcu+0x101/0x5a0 mm/mmap_lock.c:253
> >  do_user_addr_fault+0x41f/0x12f0 arch/x86/mm/fault.c:1325
>
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> >  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
> >  exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
> >  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> > RIP: 0033:0x342000
> > Code: Unable to access opcode bytes at 0x341fd6.
> > RSP: 002b:000000000000000e EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: 00007ff2e4816090 RCX: 00007ff2e459bf79
> > RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0002000020003b4a
> > RBP: 00007ff2e46327e0 R08: 0000000000000103 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007ff2e4816128 R14: 00007ff2e4816090 R15: 00007ffc4f622688
> >  </TASK>
> >
> > Allocated by task 5934:
> >  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
> >  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
> >  unpoison_slab_object mm/kasan/common.c:340 [inline]
> >  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:366
> >  kasan_slab_alloc include/linux/kasan.h:253 [inline]
> >  slab_post_alloc_hook mm/slub.c:4953 [inline]
> >  slab_alloc_node mm/slub.c:5263 [inline]
> >  kmem_cache_alloc_noprof+0x2ad/0x780 mm/slub.c:5270
> >  mt_alloc_one lib/maple_tree.c:174 [inline]
> >  mas_dup_build lib/maple_tree.c:6299 [inline]
> >  __mt_dup+0x5a8/0xc20 lib/maple_tree.c:6382
> >  dup_mmap+0x36d/0x1e20 mm/mmap.c:1744
> >  dup_mm kernel/fork.c:1530 [inline]
> >  copy_mm kernel/fork.c:1582 [inline]
> >  copy_process+0x7371/0x79b0 kernel/fork.c:2223
> >  kernel_clone+0xfc/0x930 kernel/fork.c:2654
> >  __do_sys_clone+0xd9/0x120 kernel/fork.c:2795
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Freed by task 6003:
> >  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
> >  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
> >  kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
> >  poison_slab_object mm/kasan/common.c:253 [inline]
> >  __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
> >  kasan_slab_free include/linux/kasan.h:235 [inline]
> >  slab_free_hook mm/slub.c:2540 [inline]
> >  slab_free mm/slub.c:6674 [inline]
> >  kfree+0x1c7/0x690 mm/slub.c:6886
> >  mt_destroy_walk+0xc0a/0xfa0 lib/maple_tree.c:5028
> >  mte_destroy_walk lib/maple_tree.c:5049 [inline]
> >  mte_destroy_walk lib/maple_tree.c:5040 [inline]
> >  __mt_destroy+0x2d7/0x390 lib/maple_tree.c:6446
>
> __mt_destroy() is called with rcu disabled because the last mm_struct
> user should be gone.
>
> exit_mmap() is only called when there are no mm users left, and then the
> mm is write locked before removing the rcu protection on the tree.
>
> It appears that somehow the fault has the mm without holding a reference
> to it.

I tried reproducing on my qemu with the same head commit, config and
using C reproducer and it did not reproduce. I think the only
difference I have is the GCC version I used. Mine is gcc (Debian
15.2.0-3) 15.2.0.

>
>
> >  exit_mmap+0x5d3/0xae0 mm/mmap.c:1312
> >  __mmput+0x12a/0x410 kernel/fork.c:1174
> >  mmput+0x67/0x80 kernel/fork.c:1197
> >  exit_mm kernel/exit.c:581 [inline]
> >  do_exit+0x78a/0x2a30 kernel/exit.c:959
> >  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
> >  __do_sys_exit_group kernel/exit.c:1123 [inline]
> >  __se_sys_exit_group kernel/exit.c:1121 [inline]
> >  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
> >  x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.=
h:232
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
>
>

