Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391551093180
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 07:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ACC96B037E; Fri, 20 Mar 2026 03:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65DDC6B0380; Fri, 20 Mar 2026 03:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506016B0381; Fri, 20 Mar 2026 03:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38EC46B037E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:49:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC1981B8B4A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:49:13 +0000 (UTC)
X-FDA: 84565665786.19.7E0D41F
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8671F100005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:49:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=aimBZRa8;
	spf=pass (imf05.hostedemail.com: domain of ribalda@chromium.org designates 209.85.218.48 as permitted sender) smtp.mailfrom=ribalda@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773992951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14nlh+dM/2kt2q8XYaPzQ1CxlJSsUR0fH4uxcFMFqeU=;
	b=aCNmTUdxdxrEvIXmL0xmVz94N1iXQL3q/ioVT2F7Uz2yEre56rFIP9+4pcintjGHOcV5qT
	All9EG2MSOF3CBrxM8r0pREu2Pen9Glwh13MoiZ2rZAIM2twwY7ZwYEU0sOzRqz4odsuyr
	/WcAIdf3y4/zlOxjtrAP7lfSrpNtADA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=aimBZRa8;
	spf=pass (imf05.hostedemail.com: domain of ribalda@chromium.org designates 209.85.218.48 as permitted sender) smtp.mailfrom=ribalda@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773992951; a=rsa-sha256;
	cv=none;
	b=XSToV/NK62zVXULYuLdgQAt8eobfT2E5CO8xpXPdF3Qpdxo9Ful2WTIgMYgd9SgnLqYK49
	FBplxEj9+y0RkE5ll51ZXDuKZm4RuDfd1j4SSXloXWPKNBVZEkzUJ2QMJHcmUMXzvBAgLC
	ZyZBAc+fLJwns3OdfDVx+O+K2ZJy4GY=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b9825ba7e8dso174928966b.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773992949; x=1774597749; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14nlh+dM/2kt2q8XYaPzQ1CxlJSsUR0fH4uxcFMFqeU=;
        b=aimBZRa8sTLpPZInXArX2e+eLsWrudtLbqV126sWKKWF0PPEXdQWUxdRMCxo0RVFnt
         z+XusdHRV8aLhVLZ7TF5QlOkt5JdQV4gk4nNCDUlc6ob/Ny5m2qF++k7mgocfPGcnX5Z
         O4JBXFn1F8Md+4zMpqBG4I5kq0Oq3fKIjBh1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773992950; x=1774597750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=14nlh+dM/2kt2q8XYaPzQ1CxlJSsUR0fH4uxcFMFqeU=;
        b=Sg0FJi30+6pde/9p+SbXW4B2hea1eaeMmoqK90ZlMW454Vz0Mmi7H9DRVCTt4iWwKJ
         /FCZnkclsjfc+6Q5XvIj2DEMzzs0kySjm6oVuoF9XM1mjlht7AE/V/XFo2/lqc7iONWH
         dXJnnEW7IPh2eELJSV60IEs8qyMuLDoHP67CKK3HTfuYRjU9koLG24QhXHpNNZBckscB
         tNixoOtirqmQmTF/IhtL9ZjM/yXWVvnh+0UEPQKptTiELQo9WBak4tORJWh0hgeGcl4y
         rlzJF/ZNB7gw+D56TBwF/9NY2tG+BfLxA7ZKay6YIikgPsuJ271SLqRtvfCfnOGsMAgQ
         qtMA==
X-Forwarded-Encrypted: i=1; AJvYcCUr13KdY7O7qPbM98mHiZsVEIqzWsu9HyKyRYYhNYzkQAAuKFls9eXbYJ6IMaZSqgdXgBzz0OFfPA==@kvack.org
X-Gm-Message-State: AOJu0YxHT+KP3IpdHr8B+go3+dHMHJabsqfkXCb/1VGNxo5UjMH7oNsv
	VijSI7RnCgimkHezo0ldCaiFaEGAiPxcBvoXCmDTiW+m0fAjPOyTCPDn7tnAcBeoTPRFVVomFgU
	hjY0otg==
X-Gm-Gg: ATEYQzwFpTc1L7HdbvYjZT8xA+f0lOooRsvtRS5IxNy3vt0VAmyqczEFxiE37txw5O3
	f4WYsGjB0NUR3nAacFf4PcXf7mfVRo4rewZwoLireodPn+7wNt2Yi8TzC7JbtvVqg/pXomq6I+P
	th5vVGpSK8U+nS9TvuWhgZTRutuExwGO8DqJY79/ErQUBaf9wKXSHoDIbFWSeGEgspkcAxAVkEp
	Nf8gOuVJZCHOlzFScPSvoH74zzz191nB0jqjlqgx+BUC7mVcm8tRxu8DzOL0paBGmd3B6vtB3SU
	3XxuZsrQtxCOsWi/cgTNuCvfd/8AMVEqo7lqGB/b3xW468tVqPIjKHyeIIFM6JIqUX+2wpz50B4
	2vrh6/7Ofi3mGBPPt/C1AYRzpeNkBxP7zh4wKPkAwt+1/xStLv2iCOLFNDNQpl6TrJZXpr5KwH/
	04T2i2n47Qn7JmdErC2nyiRz8OfflaQ3r02QtuFKz20m7L7j6mb5stodfKbYWp
X-Received: by 2002:a17:907:c891:b0:b98:155e:609 with SMTP id a640c23a62f3a-b982f3a3b38mr125393666b.36.1773992949156;
        Fri, 20 Mar 2026 00:49:09 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9832f42f0dsm121526466b.12.2026.03.20.00.49.07
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 00:49:07 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9825ba7e8dso174923966b.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:49:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVO7EvJfp6Nu8vKLC/qKcYk/lCHaLwoHS18WEBYGtt8v0sHoyhNBxJFtxoRlECGlHTe5yCgXH9kOA==@kvack.org
X-Received: by 2002:a17:906:c3a0:b0:b98:6dd:d87a with SMTP id
 a640c23a62f3a-b982f2454b9mr100546466b.12.1773992946641; Fri, 20 Mar 2026
 00:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <abtAylIlW3I8s1T-@mail-itl> <CANiDSCvqt574XbMAz0qUunu7xDY=oScL+sx533X6ke=fcEdr+g@mail.gmail.com>
 <20260320010747.GF950244@killaraus.ideasonboard.com>
In-Reply-To: <20260320010747.GF950244@killaraus.ideasonboard.com>
From: Ricardo Ribalda <ribalda@chromium.org>
Date: Fri, 20 Mar 2026 08:48:54 +0100
X-Gmail-Original-Message-ID: <CANiDSCu-ZuAKXz_f1XqRPHaxJkUN6v3yzLmYwU9qUsCGebkyPw@mail.gmail.com>
X-Gm-Features: AaiRm53FCDhcVLDA0NP2pjcJnM0EmBzBigeUqzk1QdFwG_u-p0Ad0tnjW3ip-IU
Message-ID: <CANiDSCu-ZuAKXz_f1XqRPHaxJkUN6v3yzLmYwU9qUsCGebkyPw@mail.gmail.com>
Subject: Re: Linux 7.0-rc4: v4l2src0:src: page allocation failure - increased
 memory usage in 7.0?
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?= <marmarek@invisiblethingslab.com>, 
	Hans de Goede <hansg@kernel.org>, linux-media@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pxjc38hksyeown63yh7y1yc3jppfm9dm
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8671F100005
X-HE-Tag: 1773992951-448866
X-HE-Meta: U2FsdGVkX19l4QyVBsAu7VHMyh12jO3k262NRZrCZn/oT3RcBzslI2bpqUj9PAtM2mFpvB3rd33KUgD3Z6b9Xj9oDxEWUP20RmjF8iLbIFIKeaQNUxFAtbaePbWEUM305QPeVknctyn6GADoIrurmqqeRigxnBBzvdqpzDqp0HKzf8X0LHNH5Uzk2v8cCRBGwCh/3rPJhWxP0hP8Brtjuqq6xrHr6+H02VjwJzimfKpbjcI+KXAgY6RaFLSN89ejP8HpXexcXr5wT/mN/PYscva4tHa+HosIbUT9jfhT138+ytPLJw3SHuY9eofbeJV6dQJReUUnskUcsNFusmFxnKRwhYNg4iHh9UWxavwDC8jnrxBCzdhVc+wjYovbmlXUW2xW725DUF83tS5A1AxNejDtaGHHvrzSIFe+FPLSZTCS9CU2TuxJhP/QdGzQxJCbtOlnBvEJzvQpaRuCVGqvEw91DNTDtwrTpZZ4TXsaDfh/9utobJK8l8Hbp0z60WvZvhYjd7QLXyJN+lz81dxfhThLch1KSSaAVyLTDtJZWDZqRuj9E2wLmFlrVrf15YgFTZullrcaudTjt8j/4nScrEn1ne3dhDeo6jktlr5LbTuoZhqJr0P+9/3rwzeErQcSRr6lT+8CUs8smHh8dcdK5JCCWFQlqAEY1vx9fRo5tIkceQt3ljmJdL75Kmq16JJkaI0yvL14GGxjfQnHxCFDKSHw0FwQs+kWGn01XUR35b66LGgJPo3uprjTdRfChhmHbdfGRIsrqkLTuPZInJPQL9ex8GVuC5YxHQtqXC36rv9wG3EPjpoa8A0o10be7w3kqs8US1PplIy7lg8Hygqblc6tORUiiGs6SARMAm+oBOKd0Sks1OuU2wrYll3CjJGt3Sp3EheklgtSZpbzFRqmWLUn/00m1YUj8U6nN6WkYi222R3yOLas2mI8nnEY/dXmGvYerhJKuZ1K0HwCEFc
 eISNQD2r
 KqAWLBUna+gpBOFctmO0yPdAa9bf/DbJTHapmDncf68fQP31Nnh5Uvnh2MtHvBmUAbc2fBxiV13wVAQ/gvOxPnT9+oIjizEdVbhCnLuYmlRNK4Yw37QPpLZnhg7ILj08yhvx8gJ6VMRE8tBDb8pKVYIF3paw2ukgoB3lYim1VjwJ3ijCDBOqS0cAnRlLMSiNwuVJBJSrZ3iMS9O2mWJH2wMLh/O/7AHMjCNH3BgzdnYr95hDBcTXjPHP09JYjzUSph/F5NM36q7Qwnr5zyGzOPSmJAIJt7IZ1bumOfKhLIi9lkBI/dSJmquVKvJvSxCnYjYuZHKAIziKjwgo7iXaTphYxDH6rJ0Bg1ZCkh/HeLD//j8ysCrHSqFRAqP5rHS567X8mBgSaOFveTpTPT61CNVqHoGZvyf7hX1Y5IZSlEMb0s4hoBUOyClU8IQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Laurent

On Fri, 20 Mar 2026 at 02:07, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Ricardo,
>
> On Thu, Mar 19, 2026 at 11:19:38AM +0100, Ricardo Ribalda wrote:
> > On Thu, 19 Mar 2026 at 01:18, Marek Marczykowski-G=C3=B3recki wrote:
> > > Hello,
> > >
> > > When testing 7.0-rc4 (and also got it with 7.0-rc1), I got page
> > > allocation failure in uvcvideo when using v4l2 camera in a VM. The se=
tup
> > > is rather memory constrained - it's a HVM with just 300MB of memory
> > > running on Xen, with PCI passthrough of USB controllers (to which an =
USB
> > > camera is connected). But the very same setup works just fine with ol=
der
> > > kernel (last known good is 6.19.5, built with the same config).
> > >
> > > I'm not exactly sure if uvcvideo is really to blame here, or is it ju=
st
> > > a victim of something else using more memory. Any advice how to check
> > > for that?
> >
> > I have looked at at:
> > git diff v6.19..linus/master drivers/media/usb/uvc/
> >
> > And I have not found anything that indicate me that we allocate more
> > memory or we allocate it differently.
> >
> > > The specific error is:
> > >
> > >     [  739.040844] systemd-journald[251]: Under memory pressure, flus=
hing caches.
> > >     [  739.193589] v4l2src0:src: page allocation failure: order:5, mo=
de:0xcc4(GFP_KERNEL|GFP_DMA32), nodemask=3D(null),cpuset=3D/,mems_allowed=
=3D0
> > >     [  739.193645] CPU: 0 UID: 1000 PID: 1305 Comm: v4l2src0:src Not =
tainted 7.0.0-0.rc4.1.qubes.1001.fc41.x86_64 #1 PREEMPT(full)
> > >     [  739.193648] Hardware name: Xen HVM domU, BIOS 4.19.4 03/17/202=
6
> > >     [  739.193649] Call Trace:
> > >     [  739.193652]  <TASK>
> > >     [  739.193656]  dump_stack_lvl+0x5d/0x80
> > >     [  739.193661]  warn_alloc+0x162/0x190
> > >     [  739.193665]  ? __alloc_pages_direct_compact+0x1bc/0x220
> > >     [  739.193669]  __alloc_pages_slowpath.constprop.0+0x4ea/0xb30
> > >     [  739.193672]  ? kernfs_activate+0x4c/0x60
> > >     [  739.193676]  __alloc_frozen_pages_noprof+0x2ff/0x340
> > >     [  739.193679]  __alloc_pages_noprof+0xe/0x20
> > >     [  739.193682]  __dma_direct_alloc_pages.isra.0+0x183/0x310
> > >     [  739.193688]  dma_direct_alloc_pages+0x3f/0x190
> > >     [  739.193693]  dma_alloc_noncontiguous+0xdd/0x290
> > >     [  739.193698]  ? usb_create_ep_devs+0xab/0x100
> > >     [  739.193701]  usb_alloc_noncoherent+0x45/0xa0
> > >     [  739.193709]  uvc_alloc_urb_buffers.part.0+0x93/0x130 [uvcvideo=
]
> > >     [  739.193722]  uvc_video_start_transfer+0x19d/0x4e0 [uvcvideo]
> > >     [  739.193735]  uvc_video_start_streaming+0xab/0x100 [uvcvideo]
> > >     [  739.193744]  uvc_start_streaming_video+0xec/0x110 [uvcvideo]
> > >     [  739.193752]  vb2_start_streaming+0x63/0x130 [videobuf2_common]
> > >     [  739.193761]  vb2_core_streamon+0x98/0xf0 [videobuf2_common]
> > >     [  739.193767]  ? vb2_ioctl_streamon+0x15/0x60 [videobuf2_v4l2]
> > >     [  739.193773]  __video_do_ioctl+0x419/0x540 [videodev]
> > >     [  739.193799]  video_usercopy+0x23b/0x630 [videodev]
> > >     [  739.193819]  ? __pfx___video_do_ioctl+0x10/0x10 [videodev]
> > >     [  739.193836]  v4l2_ioctl+0x6b/0xa0 [videodev]
> > >     [  739.193851]  __x64_sys_ioctl+0x96/0xe0
> > >     [  739.193855]  do_syscall_64+0x120/0x6c0
> > >     [  739.193859]  ? do_read_fault+0xf5/0x220
> > >     [  739.193863]  ? do_fault+0x148/0x270
> > >     [  739.193865]  ? __handle_mm_fault+0x470/0x6c0
> > >     [  739.193868]  ? count_memcg_events+0xeb/0x1b0
> > >     [  739.193871]  ? handle_mm_fault+0x220/0x340
> > >     [  739.193873]  ? do_user_addr_fault+0x1e5/0x7f0
> > >     [  739.193876]  ? arch_exit_to_user_mode_prepare.isra.0+0x9f/0xe0
> > >     [  739.193880]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > >     [  739.193883] RIP: 0033:0x738e787000ed
> > >     [  739.193886] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45=
 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00=
 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> > >     [  739.193888] RSP: 002b:0000738e730e6a00 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000010
> > >     [  739.193890] RAX: ffffffffffffffda RBX: 0000738e64008850 RCX: 0=
000738e787000ed
> > >     [  739.193892] RDX: 000059d3df721cf0 RSI: 0000000040045612 RDI: 0=
000000000000010
> > >     [  739.193893] RBP: 0000738e730e6a50 R08: 0000738e6400ae40 R09: 0=
000000000000000
> > >     [  739.193894] R10: 0000738e6400ae30 R11: 0000000000000246 R12: 0=
000000000000000
> > >     [  739.193895] R13: 0000738e640012d0 R14: 0000738e64008850 R15: 0=
000000000000002
> > >     [  739.193897]  </TASK>
> > >     [  739.193907] Mem-Info:
> > >     [  739.194897] active_anon:362 inactive_anon:3172 isolated_anon:0
> > >     [  739.194897]  active_file:2498 inactive_file:11687 isolated_fil=
e:1
> > >     [  739.194897]  unevictable:0 dirty:0 writeback:4
> > >     [  739.194897]  slab_reclaimable:3707 slab_unreclaimable:10022
> > >     [  739.194897]  mapped:4710 shmem:9 pagetables:1021
> > >     [  739.194897]  sec_pagetables:0 bounce:0
> > >     [  739.194897]  kernel_misc_reclaimable:0
> > >     [  739.194897]  free:3452 free_pcp:1 free_cma:0
> > >     [  739.195008] Node 0 active_anon:1448kB inactive_anon:12688kB ac=
tive_file:9992kB inactive_file:46748kB unevictable:0kB isolated(anon):0kB i=
solated(file):4kB mapped:18840kB dirty:0kB writeback:16kB shmem:36kB shmem_=
thp:0kB shmem_pmdmapped:0kB anon_thp:0kB kernel_stack:2416kB pagetables:408=
4kB sec_pagetables:0kB all_unreclaimable? no Balloon:16384kB
> > >     [  739.195097] Node 0 DMA free:2828kB boost:0kB min:132kB low:164=
kB high:196kB reserved_highatomic:0KB free_highatomic:0KB active_anon:224kB=
 inactive_anon:940kB active_file:1360kB inactive_file:2408kB unevictable:0k=
B writepending:0kB zspages:0kB present:15992kB managed:15360kB mlocked:0kB =
bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> > >     [  739.195186] lowmem_reserve[]: 0 195 195 195 195
> > >     [  739.196280] Node 0 DMA32 free:14880kB boost:3856kB min:5572kB =
low:6000kB high:6428kB reserved_highatomic:0KB free_highatomic:0KB active_a=
non:1224kB inactive_anon:11728kB active_file:8632kB inactive_file:40024kB u=
nevictable:0kB writepending:16kB zspages:0kB present:274348kB managed:20008=
0kB mlocked:0kB bounce:0kB free_pcp:316kB local_pcp:236kB free_cma:0kB
> > >     [  739.196372] lowmem_reserve[]: 0 0 0 0 0
> > >     [  739.196388] Node 0 DMA: 193*4kB (UM) 213*8kB (UM) 22*16kB (UM)=
 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 2828k=
B
> > >     [  739.196433] Node 0 DMA32: 1631*4kB (UME) 764*8kB (UME) 138*16k=
B (UME) 8*32kB (UM) 3*64kB (M) 1*128kB (M) 0*256kB 0*512kB 0*1024kB 0*2048k=
B 0*4096kB =3D 15420kB
> > >     [  739.196487] Node 0 hugepages_total=3D0 hugepages_free=3D0 huge=
pages_surp=3D0 hugepages_size=3D2048kB
> > >     [  739.196514] 14914 total pagecache pages
> > >     [  739.196527] 2073 pages in swap cache
> > >     [  739.196539] Free swap  =3D 961672kB
> > >     [  739.196551] Total swap =3D 1048572kB
> > >     [  739.196563] 72585 pages RAM
> > >     [  739.196572] 0 pages HighMem/MovableOnly
> > >     [  739.196584] 18725 pages reserved
> > >     [  739.196596] 0 pages cma reserved
> > >     [  739.196608] 0 pages hwpoisoned
> > >     [  739.196620] Memory cgroup min protection 0kB -- low protection=
 0kB
> > >     [  739.196627] ------------[ cut here ]------------
> > >
> > > Additionally, this failure isn't handled gracefully, it's followed wi=
th:
> >
> > That should not happen.... Could you check if this fixes it:
> >
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c
> > index 40c76c051da2..f6c8e3223796 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -1751,7 +1751,8 @@ static void uvc_video_complete(struct urb *urb)
> >  /*
> >   * Free transfer buffers.
> >   */
> > -static void uvc_free_urb_buffers(struct uvc_streaming *stream)
> > +static void uvc_free_urb_buffers(struct uvc_streaming *stream,
> > +                                unsigned int size)
> >  {
> >         struct usb_device *udev =3D stream->dev->udev;
> >         struct uvc_urb *uvc_urb;
> > @@ -1760,7 +1761,7 @@ static void uvc_free_urb_buffers(struct
> > uvc_streaming *stream)
> >                 if (!uvc_urb->buffer)
> >                         continue;
> >
> > -               usb_free_noncoherent(udev, stream->urb_size, uvc_urb->b=
uffer,
> > +               usb_free_noncoherent(udev, size, uvc_urb->buffer,
> >                                      uvc_stream_dir(stream), uvc_urb->s=
gt);
> >                 uvc_urb->buffer =3D NULL;
> >                 uvc_urb->sgt =3D NULL;
> > @@ -1820,7 +1821,7 @@ static int uvc_alloc_urb_buffers(struct
> > uvc_streaming *stream,
> >
> >                         if (!uvc_alloc_urb_buffer(stream, uvc_urb, urb_=
size,
> >                                                   gfp_flags)) {
> > -                               uvc_free_urb_buffers(stream);
> > +                               uvc_free_urb_buffers(stream, urb_size);
> >                                 break;
> >                         }
> >
> > @@ -1868,7 +1869,7 @@ static void uvc_video_stop_transfer(struct
> > uvc_streaming *stream,
> >         }
> >
> >         if (free_buffers)
> > -               uvc_free_urb_buffers(stream);
> > +               uvc_free_urb_buffers(stream, stream->urb_size);
> >  }
> >
> >  /*
>
> I'm tempted to revert commit c824345288d1 ("media: uvcvideo: Pass
> allocation size directly to uvc_alloc_urb_buffer") instead. It was
> supposeed to be a pure refactoring without any functional change, and
> adding this on top makes me feel the code is getting more complex as a
> result.

I think this patch is more robust. Relying on a temporary value of
stream->urb_size can lead to errors.
But I am of course biased :)

I have sent a patch to the ML, please feel free to either go with the
revert route or review that patch.

Thanks!

>
> > >
> > >     [  739.196672] UBSAN: shift-out-of-bounds in /builddir/build/BUIL=
D/kernel-latest-7.0-build/kernel-latest-7.0/linux-7.0-rc4/mm/page_alloc.c:1=
403:22
> > >     [  739.196710] shift exponent 52 is too large for 32-bit type 'in=
t'
> > >     [  739.196730] CPU: 1 UID: 1000 PID: 1305 Comm: v4l2src0:src Not =
tainted 7.0.0-0.rc4.1.qubes.1001.fc41.x86_64 #1 PREEMPT(full)
> > >     [  739.196733] Hardware name: Xen HVM domU, BIOS 4.19.4 03/17/202=
6
> > >     [  739.196734] Call Trace:
> > >     [  739.196737]  <TASK>
> > >     [  739.196739]  dump_stack_lvl+0x5d/0x80
> > >     [  739.196744]  ubsan_epilogue+0x5/0x2b
> > >     [  739.196746]  __ubsan_handle_shift_out_of_bounds.cold+0x61/0xe6
> > >     [  739.196749]  __free_pages_ok.cold+0x13/0xa8
> > >     [  739.196753]  dma_free_noncontiguous+0xbf/0xe0
> > >     [  739.196756]  ? usb_free_noncoherent+0x3a/0x60
> > >     [  739.196761]  uvc_free_urb_buffers+0x38/0x90 [uvcvideo]
> > >     [  739.196773]  uvc_alloc_urb_buffers.part.0+0xe6/0x130 [uvcvideo=
]
> > >     [  739.196781]  uvc_video_start_transfer+0x19d/0x4e0 [uvcvideo]
> > >     [  739.196789]  uvc_video_start_streaming+0xab/0x100 [uvcvideo]
> > >     [  739.196797]  uvc_start_streaming_video+0xec/0x110 [uvcvideo]
> > >     [  739.196806]  vb2_start_streaming+0x63/0x130 [videobuf2_common]
> > >     [  739.196813]  vb2_core_streamon+0x98/0xf0 [videobuf2_common]
> > >     [  739.196819]  ? vb2_ioctl_streamon+0x15/0x60 [videobuf2_v4l2]
> > >     [  739.196824]  __video_do_ioctl+0x419/0x540 [videodev]
> > >     [  739.196847]  video_usercopy+0x23b/0x630 [videodev]
> > >     [  739.196863]  ? __pfx___video_do_ioctl+0x10/0x10 [videodev]
> > >     [  739.196880]  v4l2_ioctl+0x6b/0xa0 [videodev]
> > >     [  739.196895]  __x64_sys_ioctl+0x96/0xe0
> > >     [  739.196898]  do_syscall_64+0x120/0x6c0
> > >     [  739.196902]  ? do_read_fault+0xf5/0x220
> > >     [  739.196906]  ? do_fault+0x148/0x270
> > >     [  739.196908]  ? __handle_mm_fault+0x470/0x6c0
> > >     [  739.196911]  ? count_memcg_events+0xeb/0x1b0
> > >     [  739.196914]  ? handle_mm_fault+0x220/0x340
> > >     [  739.196916]  ? do_user_addr_fault+0x1e5/0x7f0
> > >     [  739.196920]  ? arch_exit_to_user_mode_prepare.isra.0+0x9f/0xe0
> > >     [  739.196924]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > >     [  739.196926] RIP: 0033:0x738e787000ed
> > >     [  739.196929] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45=
 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00=
 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> > >     [  739.196930] RSP: 002b:0000738e730e6a00 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000010
> > >     [  739.196933] RAX: ffffffffffffffda RBX: 0000738e64008850 RCX: 0=
000738e787000ed
> > >     [  739.196934] RDX: 000059d3df721cf0 RSI: 0000000040045612 RDI: 0=
000000000000010
> > >     [  739.196935] RBP: 0000738e730e6a50 R08: 0000738e6400ae40 R09: 0=
000000000000000
> > >     [  739.196936] R10: 0000738e6400ae30 R11: 0000000000000246 R12: 0=
000000000000000
> > >     [  739.196937] R13: 0000738e640012d0 R14: 0000738e64008850 R15: 0=
000000000000002
> > >     [  739.196939]  </TASK>
> > >     [  739.196940] ---[ end trace ]---
> > >     [  739.197835] BUG: Bad page state in process v4l2src0:src  pfn:0=
09a0
> > >     [  739.198028] page: refcount:0 mapcount:0 mapping:00000000000000=
00 index:0x2a pfn:0x9a0
> > >     [  739.198054] flags: 0x7ffffc0000000(node=3D0|zone=3D0|lastcpupi=
d=3D0x1fffff)
> > >     [  739.198074] page_type: f0(buddy)
> > >     [  739.198088] raw: 0007ffffc0000000 fffffac1c0026a08 fffffac1c00=
25e08 0000000000000000
> > >     [  739.198111] raw: 000000000000002a 0000000000000002 00000000f00=
00000 0000000000000000
> > >     [  739.198133] page dumped because: nonzero mapcount
> > >     [  739.198149] Modules linked in: nft_reject_ipv6 nf_reject_ipv6 =
nft_reject_ipv4 nf_reject_ipv4 nft_reject nft_ct nft_masq nft_chain_nat nf_=
nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables uvcvideo ath3k btu=
sb btmtk uvc videobuf2_vmalloc btrtl videobuf2_memops videobuf2_v4l2 cdc_mb=
im btbcm cdc_ncm videobuf2_common btintel cdc_ether usbnet videodev bluetoo=
th mii cdc_wdm mc rfkill cdc_acm joydev intel_rapl_msr intel_rapl_common gh=
ash_clmulni_intel xhci_pci xhci_hcd ehci_pci ehci_hcd pcspkr i2c_piix4 ata_=
generic pata_acpi i2c_smbus serio_raw xen_scsiback target_core_mod xen_netb=
ack xen_privcmd xen_gntdev xen_gntalloc xen_blkback xen_evtchn i2c_dev fuse=
 loop nfnetlink overlay xen_blkfront
> > >     [  739.198472] CPU: 1 UID: 1000 PID: 1305 Comm: v4l2src0:src Not =
tainted 7.0.0-0.rc4.1.qubes.1001.fc41.x86_64 #1 PREEMPT(full)
> > >     [  739.198475] Hardware name: Xen HVM domU, BIOS 4.19.4 03/17/202=
6
> > >     [  739.198477] Call Trace:
> > >     [  739.198479]  <TASK>
> > >     [  739.198480]  dump_stack_lvl+0x5d/0x80
> > >     [  739.198485]  bad_page.cold+0x7a/0x91
> > >     [  739.198488]  __free_pages_ok+0x481/0x680
> > >     [  739.198491]  dma_free_noncontiguous+0xbf/0xe0
> > >     [  739.198494]  ? usb_free_noncoherent+0x3a/0x60
> > >     [  739.198497]  uvc_free_urb_buffers+0x38/0x90 [uvcvideo]
> > >     [  739.198507]  uvc_alloc_urb_buffers.part.0+0xe6/0x130 [uvcvideo=
]
> > >     [  739.198515]  uvc_video_start_transfer+0x19d/0x4e0 [uvcvideo]
> > >     [  739.198523]  uvc_video_start_streaming+0xab/0x100 [uvcvideo]
> > >     [  739.198531]  uvc_start_streaming_video+0xec/0x110 [uvcvideo]
> > >     [  739.198539]  vb2_start_streaming+0x63/0x130 [videobuf2_common]
> > >     [  739.198546]  vb2_core_streamon+0x98/0xf0 [videobuf2_common]
> > >     [  739.198551]  ? vb2_ioctl_streamon+0x15/0x60 [videobuf2_v4l2]
> > >     [  739.198555]  __video_do_ioctl+0x419/0x540 [videodev]
> > >     [  739.198574]  video_usercopy+0x23b/0x630 [videodev]
> > >     [  739.198590]  ? __pfx___video_do_ioctl+0x10/0x10 [videodev]
> > >     [  739.198607]  v4l2_ioctl+0x6b/0xa0 [videodev]
> > >     [  739.198622]  __x64_sys_ioctl+0x96/0xe0
> > >     [  739.198625]  do_syscall_64+0x120/0x6c0
> > >     [  739.198629]  ? do_read_fault+0xf5/0x220
> > >     [  739.198632]  ? do_fault+0x148/0x270
> > >     [  739.198635]  ? __handle_mm_fault+0x470/0x6c0
> > >     [  739.198637]  ? count_memcg_events+0xeb/0x1b0
> > >     [  739.198640]  ? handle_mm_fault+0x220/0x340
> > >     [  739.198642]  ? do_user_addr_fault+0x1e5/0x7f0
> > >     [  739.198645]  ? arch_exit_to_user_mode_prepare.isra.0+0x9f/0xe0
> > >     [  739.198648]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > >     [  739.198651] RIP: 0033:0x738e787000ed
> > >     [  739.198653] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45=
 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00=
 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> > >     [  739.198654] RSP: 002b:0000738e730e6a00 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000010
> > >     [  739.198656] RAX: ffffffffffffffda RBX: 0000738e64008850 RCX: 0=
000738e787000ed
> > >     [  739.198657] RDX: 000059d3df721cf0 RSI: 0000000040045612 RDI: 0=
000000000000010
> > >     [  739.198658] RBP: 0000738e730e6a50 R08: 0000738e6400ae40 R09: 0=
000000000000000
> > >     [  739.198659] R10: 0000738e6400ae30 R11: 0000000000000246 R12: 0=
000000000000000
> > >     [  739.198660] R13: 0000738e640012d0 R14: 0000738e64008850 R15: 0=
000000000000002
> > >     [  739.198662]  </TASK>
> > >     [  739.198663] Disabling lock debugging due to kernel taint
> > >
> > > And eventually kernel panic:
> > >
> > >     [  740.464422] BUG: unable to handle page fault for address: ffff=
fac1c0800000
> > >     [  740.464454] #PF: supervisor read access in kernel mode
> > >     [  740.464471] #PF: error_code(0x0000) - not-present page
> > >     [  740.464488] PGD 11be0067 P4D 11be0067 PUD 1148f067 PMD 0
> > >
> > > Full console log is at: https://gist.github.com/marmarek/5d839f419b1d=
56e71a48e74ae66f0e7a
>
> --
> Regards,
>
> Laurent Pinchart



--=20
Ricardo Ribalda

