Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E5D108E1D1
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586196B0461; Thu, 19 Mar 2026 06:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DE46B0462; Thu, 19 Mar 2026 06:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D3A6B0463; Thu, 19 Mar 2026 06:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FD516B0461
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:19:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E72CB8BA4F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:19:58 +0000 (UTC)
X-FDA: 84562416876.07.539DA86
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id A2BB9160008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:19:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QCukl9iy;
	spf=pass (imf08.hostedemail.com: domain of ribalda@chromium.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=ribalda@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773915596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DL1axeEYYkM4z0ENd1c32DUllkHXHpo87BEbR8xzGZI=;
	b=Mr8il7DhA6PpOB/qjt8qI/ZtnxYuhlcR0uzkdpvgWtEE0iKW7QkLS8JY7Sa8alxOkMvKC+
	zgN6MQyTBcsqy1gC7gFz+o8n6b6RATY0VNX+C8CnD/JBbQ8VN3mBQ8tSs+lOnBv962M2OH
	j9VZmzD/a5aJ1zNfREPNI68HBz2PcDY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QCukl9iy;
	spf=pass (imf08.hostedemail.com: domain of ribalda@chromium.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=ribalda@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773915596; a=rsa-sha256;
	cv=none;
	b=jNsWHmjArE7u948+kwTEnBLVcjfg7my2Yz4lltuSpMugCOjGsnUyLbev/RqLIIzDQPZxHD
	Uif89xbyU5+MFyGp94qzAqSqvBQehOI2surW1V8AxZzOPA+g/KoNOqIKAjfpBFcoxVMbc9
	oULGAC4kU/I8gcg9IKTFinNTcHfmT4s=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-666ee394529so695392a12.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773915595; x=1774520395; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DL1axeEYYkM4z0ENd1c32DUllkHXHpo87BEbR8xzGZI=;
        b=QCukl9iyKiXsuL21fjuZYoaSfhM27xqHfq6Xypiz/quwwl4TgEixdrqjCz61SCnu1A
         oAbh+tIwAnp3XMmkKaAt4FFn78v2SuvFcru1xrdbQCxkkiXOK1LfwNqeUjYC+LoRGXAo
         EZzso+6QH9GEwzED1DsZycVEHftzTqXqj0b0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773915595; x=1774520395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DL1axeEYYkM4z0ENd1c32DUllkHXHpo87BEbR8xzGZI=;
        b=cPCK05+FyJxUxjCQB+dpJ28sRZfaAZn+g8ttVVjnoCXhyH/0g4D6Q/G9VP58FYqaXc
         p6BKsXgvIEJqFtC9HyXAzrViOeoTNAXNHn8M/olDTkZpMjzPHhYyqYYaFAVM5qkPsPe+
         jhARzecobwE4HSNUmYi9T22XHKejoGv0K7xpHOtlKCFCXvX/IOj5qBkoZaViABU+gBwx
         vN1T83vELT7kcZ9Tbp6pZzo9gw2R4vMbbV7BwI46VPaYWc2K78dyTq2pBJNFeKiLa3xV
         cxn9k4F0d+GylprE1ydoenSDVWROZG6am03Hcd/P8+Uh+o7s/pCaPudRgqTPEzq9WqCi
         +/tA==
X-Forwarded-Encrypted: i=1; AJvYcCXBz0e4oaP9RuDcZdvsLJsodqcek8zr/JKNr3WVf2DmK415xCj/2yA7hjlt0MIKuYRdCrXiTL10Bw==@kvack.org
X-Gm-Message-State: AOJu0YxIeqnhI6n3U1KqnHwhj0FfokPtLJqi23hpH4Iz5Vsrcl6eQ3GN
	gLpsoKU9EOhRlvqAoC3rudwlQlHVy/nuWKX/QS+Y/7ly8geZt1aX+uH4H0A2DxSZ+wO5eJteNuZ
	blyFfyEqg
X-Gm-Gg: ATEYQzz5KNTOxHDhqOiVfIRtHkKQnWU78K9nca9OHNafB0fk5cKEpCZZWPSs0Mte8bs
	56vkgmKBZVIG9yjmBpgh0MI+sTbJqHdy1zfApzXLE35WbHXBNEy0IeKhr+sDCS1RElBj9J9r+sH
	W2NdFKnWlpZnRu/O79/WDWG5972tbJmxPONU7CD6n6pSztRpKHjbE5aqebMTbFyMNe/2NAAXkT4
	BR/2U5nrTcc5QdcaMfsIsC5pZwZpcj6JNoiFSSiW03q8pB9849CddQPXFvn7F3Sv/5ouh6qQSjd
	/w8ndJof22zok9Bg9LXiKCNly/2KajkZ82XOrRyLSD78bWmN+U5mRSJOMu7kDyzTirYinXa26rM
	EAFpPP0z7QQJmKQNlLCDcBk4sUcEnPO71m7wO4h/PtkdQtnWPh4l4GkIm22munlc/qCjCQSpQ/D
	rqGFdz/dTR6Hxw4Ch+HueG0IZ5jsYc1b/csOebGLrv29DDpkSEgUPLvBS7MtPjHAFea9RJaPQ=
X-Received: by 2002:a05:6402:1ed5:b0:65b:93ec:597a with SMTP id 4fb4d7f45d1cf-667b2731d58mr4412430a12.19.1773915594419;
        Thu, 19 Mar 2026 03:19:54 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-66875b8e87bsm460807a12.23.2026.03.19.03.19.51
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 03:19:53 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b941762394aso61122966b.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:19:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX7ZDHmbedMhciUUv0Umdd3zykV6Tt2N9xgmF2hbZ5wcEyCFE7zqvKZjskwZISdQEScWZXSVsZArQ==@kvack.org
X-Received: by 2002:a17:907:ea6:b0:b97:fb80:dd12 with SMTP id
 a640c23a62f3a-b97fb810dcfmr378631966b.33.1773915590896; Thu, 19 Mar 2026
 03:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <abtAylIlW3I8s1T-@mail-itl>
In-Reply-To: <abtAylIlW3I8s1T-@mail-itl>
From: Ricardo Ribalda <ribalda@chromium.org>
Date: Thu, 19 Mar 2026 11:19:38 +0100
X-Gmail-Original-Message-ID: <CANiDSCvqt574XbMAz0qUunu7xDY=oScL+sx533X6ke=fcEdr+g@mail.gmail.com>
X-Gm-Features: AaiRm529aBhjryl4tL6zUIcAqTWta8UfggaeamA62HXrA2BBFdNMOj9YzlVRWC4
Message-ID: <CANiDSCvqt574XbMAz0qUunu7xDY=oScL+sx533X6ke=fcEdr+g@mail.gmail.com>
Subject: Re: Linux 7.0-rc4: v4l2src0:src: page allocation failure - increased
 memory usage in 7.0?
To: =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?= <marmarek@invisiblethingslab.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Hans de Goede <hansg@kernel.org>, 
	linux-media@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A2BB9160008
X-Rspamd-Server: rspam08
X-Stat-Signature: zpnd7xegqd3cy7x36mscxuz96yyc8i35
X-HE-Tag: 1773915596-825385
X-HE-Meta: U2FsdGVkX1/iFHqvIzR4/yY5hDH8DUOasQuj3IQUP0ZxNlg9b3z//8DTx9DhocxoV1F2VZw11Ep0mGh23buAQRNzYIknG42vgKdR2olBclIqBIF2rUoVku4U0z32IySGlmZ/MOYx2JJoenAe6rSNhhOxVlmWHG83qSBfhfm7yPBLbpJ0xuTB8y+uWnVU3Bjczc3jdVhxI05CHGCdkc2f9oSFVzMTTHhRsBLWVsvcE0zhfvSdVW8N/UaZjUp2ctwdX7aonbyFfDT2Nwz83/ALXXW5Oi3gkhf0swky/8rQtK/hm+mOnSAi8eR3/G54WMHEm/B398Dr/Lz1ntoTq4EnrR0E6MXt2FBI3Lpjo+iUIOVSQ0aXJZfkhh8pSxbYXRpNRlzjBZFU4jCL8bxwAyLmuHJ3FwN+z0mu1MwTVwyLMhU4TjKA/mL81cIqkHoppWEUyxeLD34TuWQKF/zhG6POVwk4RnRMPMGKshDmCh+gkMkuE9IWJuGnNgwCqWjL+CIMLFGSf7Nbxw0MHDwC7fTjCUKTwxyCNJ6i8BnidwzW6HvraCwsJfa+3RUvvK+hDXYSfQxM3tJra36K4JHpANGMCR25JvaQI/QWYp3xo0jNIlWduHb5Gs740X9+ervjxrsrnf7k8BTkTWRVMGViJYZ7lRf0mXahLHeJjJ+gN+X4GA1IwHBrufO0J5dTuTmm52e7K6X5zUlu4LZvmrRTjIJvJ71fLRv9Ct0g8dIbRKoMq2dmV1g87Mij61xG5XbKPL0ik42B8laS3zPDk94NjpN+fS1cM0IrH9SGMwNbJkG73h9657+MXmyuwFCJHS1L59E8/D3i84KWRQttStJRrOxTx7M4FHyoKOl5mEAaaeIeuEbswbmp7dWxgJK00+j6l8E0NgaiqjpiOzOEABMmAeaIKcjQMvBB4feUd0/wZkxOo66wkdpBnGmsXsvJ13b0ETmccIkHGocWueyO916HIoK
 OhSPiD9e
 hJNkaeTtdBNtnmynyO0VMLa7eHpJF6Qp00mLr2Xp/U922YLdLt+sVACqVqtMKNUxd7ASWcAoucJ3ZG10c5hXRle/enCbyR6OlOR6wBTYCuHPhahwYLycQXwPHgmbrktlth1ID4PoUZ/UTK4KTZJcOxoZabq2R2xqf3v+biZeqZ/ZKsjaocMLpcbCknv4hGdYheBbBh9x3r9FQa5tebjl/O0zVuShe67shVsVAluWqY4z+eea/1Vgc9CwPvqx1vhXi3hB8v7ug+2j68Y3qBxH6NHe1abrLPZyby7FS5Vk0ZoNi6gf0RwnM0gaaiHkkxMBScgiNubCpKQ6WAyt1+uxEoSqbd+ksfN3b9XBHcOk2cCcQIEyeXVZpVGgPN9gTkBQj8zcWrZ3U/b4yPKo3MzrKJs11YhbzsGoJCnvFqV3vuDcaCpHCFZ4h0LW5WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marek

Thanks a lot for the detailed report.

On Thu, 19 Mar 2026 at 01:18, Marek Marczykowski-G=C3=B3recki
<marmarek@invisiblethingslab.com> wrote:
>
> Hello,
>
> When testing 7.0-rc4 (and also got it with 7.0-rc1), I got page
> allocation failure in uvcvideo when using v4l2 camera in a VM. The setup
> is rather memory constrained - it's a HVM with just 300MB of memory
> running on Xen, with PCI passthrough of USB controllers (to which an USB
> camera is connected). But the very same setup works just fine with older
> kernel (last known good is 6.19.5, built with the same config).
>
> I'm not exactly sure if uvcvideo is really to blame here, or is it just
> a victim of something else using more memory. Any advice how to check
> for that?

I have looked at at:
git diff v6.19..linus/master drivers/media/usb/uvc/

And I have not found anything that indicate me that we allocate more
memory or we allocate it differently.

>
> The specific error is:
>
>     [  739.040844] systemd-journald[251]: Under memory pressure, flushing=
 caches.
>     [  739.193589] v4l2src0:src: page allocation failure: order:5, mode:0=
xcc4(GFP_KERNEL|GFP_DMA32), nodemask=3D(null),cpuset=3D/,mems_allowed=3D0
>     [  739.193645] CPU: 0 UID: 1000 PID: 1305 Comm: v4l2src0:src Not tain=
ted 7.0.0-0.rc4.1.qubes.1001.fc41.x86_64 #1 PREEMPT(full)
>     [  739.193648] Hardware name: Xen HVM domU, BIOS 4.19.4 03/17/2026
>     [  739.193649] Call Trace:
>     [  739.193652]  <TASK>
>     [  739.193656]  dump_stack_lvl+0x5d/0x80
>     [  739.193661]  warn_alloc+0x162/0x190
>     [  739.193665]  ? __alloc_pages_direct_compact+0x1bc/0x220
>     [  739.193669]  __alloc_pages_slowpath.constprop.0+0x4ea/0xb30
>     [  739.193672]  ? kernfs_activate+0x4c/0x60
>     [  739.193676]  __alloc_frozen_pages_noprof+0x2ff/0x340
>     [  739.193679]  __alloc_pages_noprof+0xe/0x20
>     [  739.193682]  __dma_direct_alloc_pages.isra.0+0x183/0x310
>     [  739.193688]  dma_direct_alloc_pages+0x3f/0x190
>     [  739.193693]  dma_alloc_noncontiguous+0xdd/0x290
>     [  739.193698]  ? usb_create_ep_devs+0xab/0x100
>     [  739.193701]  usb_alloc_noncoherent+0x45/0xa0
>     [  739.193709]  uvc_alloc_urb_buffers.part.0+0x93/0x130 [uvcvideo]
>     [  739.193722]  uvc_video_start_transfer+0x19d/0x4e0 [uvcvideo]
>     [  739.193735]  uvc_video_start_streaming+0xab/0x100 [uvcvideo]
>     [  739.193744]  uvc_start_streaming_video+0xec/0x110 [uvcvideo]
>     [  739.193752]  vb2_start_streaming+0x63/0x130 [videobuf2_common]
>     [  739.193761]  vb2_core_streamon+0x98/0xf0 [videobuf2_common]
>     [  739.193767]  ? vb2_ioctl_streamon+0x15/0x60 [videobuf2_v4l2]
>     [  739.193773]  __video_do_ioctl+0x419/0x540 [videodev]
>     [  739.193799]  video_usercopy+0x23b/0x630 [videodev]
>     [  739.193819]  ? __pfx___video_do_ioctl+0x10/0x10 [videodev]
>     [  739.193836]  v4l2_ioctl+0x6b/0xa0 [videodev]
>     [  739.193851]  __x64_sys_ioctl+0x96/0xe0
>     [  739.193855]  do_syscall_64+0x120/0x6c0
>     [  739.193859]  ? do_read_fault+0xf5/0x220
>     [  739.193863]  ? do_fault+0x148/0x270
>     [  739.193865]  ? __handle_mm_fault+0x470/0x6c0
>     [  739.193868]  ? count_memcg_events+0xeb/0x1b0
>     [  739.193871]  ? handle_mm_fault+0x220/0x340
>     [  739.193873]  ? do_user_addr_fault+0x1e5/0x7f0
>     [  739.193876]  ? arch_exit_to_user_mode_prepare.isra.0+0x9f/0xe0
>     [  739.193880]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>     [  739.193883] RIP: 0033:0x738e787000ed
>     [  739.193886] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 =
c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f =
05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
>     [  739.193888] RSP: 002b:0000738e730e6a00 EFLAGS: 00000246 ORIG_RAX: =
0000000000000010
>     [  739.193890] RAX: ffffffffffffffda RBX: 0000738e64008850 RCX: 00007=
38e787000ed
>     [  739.193892] RDX: 000059d3df721cf0 RSI: 0000000040045612 RDI: 00000=
00000000010
>     [  739.193893] RBP: 0000738e730e6a50 R08: 0000738e6400ae40 R09: 00000=
00000000000
>     [  739.193894] R10: 0000738e6400ae30 R11: 0000000000000246 R12: 00000=
00000000000
>     [  739.193895] R13: 0000738e640012d0 R14: 0000738e64008850 R15: 00000=
00000000002
>     [  739.193897]  </TASK>
>     [  739.193907] Mem-Info:
>     [  739.194897] active_anon:362 inactive_anon:3172 isolated_anon:0
>     [  739.194897]  active_file:2498 inactive_file:11687 isolated_file:1
>     [  739.194897]  unevictable:0 dirty:0 writeback:4
>     [  739.194897]  slab_reclaimable:3707 slab_unreclaimable:10022
>     [  739.194897]  mapped:4710 shmem:9 pagetables:1021
>     [  739.194897]  sec_pagetables:0 bounce:0
>     [  739.194897]  kernel_misc_reclaimable:0
>     [  739.194897]  free:3452 free_pcp:1 free_cma:0
>     [  739.195008] Node 0 active_anon:1448kB inactive_anon:12688kB active=
_file:9992kB inactive_file:46748kB unevictable:0kB isolated(anon):0kB isola=
ted(file):4kB mapped:18840kB dirty:0kB writeback:16kB shmem:36kB shmem_thp:=
0kB shmem_pmdmapped:0kB anon_thp:0kB kernel_stack:2416kB pagetables:4084kB =
sec_pagetables:0kB all_unreclaimable? no Balloon:16384kB
>     [  739.195097] Node 0 DMA free:2828kB boost:0kB min:132kB low:164kB h=
igh:196kB reserved_highatomic:0KB free_highatomic:0KB active_anon:224kB ina=
ctive_anon:940kB active_file:1360kB inactive_file:2408kB unevictable:0kB wr=
itepending:0kB zspages:0kB present:15992kB managed:15360kB mlocked:0kB boun=
ce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
>     [  739.195186] lowmem_reserve[]: 0 195 195 195 195
>     [  739.196280] Node 0 DMA32 free:14880kB boost:3856kB min:5572kB low:=
6000kB high:6428kB reserved_highatomic:0KB free_highatomic:0KB active_anon:=
1224kB inactive_anon:11728kB active_file:8632kB inactive_file:40024kB unevi=
ctable:0kB writepending:16kB zspages:0kB present:274348kB managed:200080kB =
mlocked:0kB bounce:0kB free_pcp:316kB local_pcp:236kB free_cma:0kB
>     [  739.196372] lowmem_reserve[]: 0 0 0 0 0
>     [  739.196388] Node 0 DMA: 193*4kB (UM) 213*8kB (UM) 22*16kB (UM) 0*3=
2kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 2828kB
>     [  739.196433] Node 0 DMA32: 1631*4kB (UME) 764*8kB (UME) 138*16kB (U=
ME) 8*32kB (UM) 3*64kB (M) 1*128kB (M) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*=
4096kB =3D 15420kB
>     [  739.196487] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepage=
s_surp=3D0 hugepages_size=3D2048kB
>     [  739.196514] 14914 total pagecache pages
>     [  739.196527] 2073 pages in swap cache
>     [  739.196539] Free swap  =3D 961672kB
>     [  739.196551] Total swap =3D 1048572kB
>     [  739.196563] 72585 pages RAM
>     [  739.196572] 0 pages HighMem/MovableOnly
>     [  739.196584] 18725 pages reserved
>     [  739.196596] 0 pages cma reserved
>     [  739.196608] 0 pages hwpoisoned
>     [  739.196620] Memory cgroup min protection 0kB -- low protection 0kB
>     [  739.196627] ------------[ cut here ]------------
>
> Additionally, this failure isn't handled gracefully, it's followed with:

That should not happen.... Could you check if this fixes it:

diff --git a/drivers/media/usb/uvc/uvc_video.c
b/drivers/media/usb/uvc/uvc_video.c
index 40c76c051da2..f6c8e3223796 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1751,7 +1751,8 @@ static void uvc_video_complete(struct urb *urb)
 /*
  * Free transfer buffers.
  */
-static void uvc_free_urb_buffers(struct uvc_streaming *stream)
+static void uvc_free_urb_buffers(struct uvc_streaming *stream,
+                                unsigned int size)
 {
        struct usb_device *udev =3D stream->dev->udev;
        struct uvc_urb *uvc_urb;
@@ -1760,7 +1761,7 @@ static void uvc_free_urb_buffers(struct
uvc_streaming *stream)
                if (!uvc_urb->buffer)
                        continue;

-               usb_free_noncoherent(udev, stream->urb_size, uvc_urb->buffe=
r,
+               usb_free_noncoherent(udev, size, uvc_urb->buffer,
                                     uvc_stream_dir(stream), uvc_urb->sgt);
                uvc_urb->buffer =3D NULL;
                uvc_urb->sgt =3D NULL;
@@ -1820,7 +1821,7 @@ static int uvc_alloc_urb_buffers(struct
uvc_streaming *stream,

                        if (!uvc_alloc_urb_buffer(stream, uvc_urb, urb_size=
,
                                                  gfp_flags)) {
-                               uvc_free_urb_buffers(stream);
+                               uvc_free_urb_buffers(stream, urb_size);
                                break;
                        }

@@ -1868,7 +1869,7 @@ static void uvc_video_stop_transfer(struct
uvc_streaming *stream,
        }

        if (free_buffers)
-               uvc_free_urb_buffers(stream);
+               uvc_free_urb_buffers(stream, stream->urb_size);
 }

 /*
>
>     [  739.196672] UBSAN: shift-out-of-bounds in /builddir/build/BUILD/ke=
rnel-latest-7.0-build/kernel-latest-7.0/linux-7.0-rc4/mm/page_alloc.c:1403:=
22
>     [  739.196710] shift exponent 52 is too large for 32-bit type 'int'
>     [  739.196730] CPU: 1 UID: 1000 PID: 1305 Comm: v4l2src0:src Not tain=
ted 7.0.0-0.rc4.1.qubes.1001.fc41.x86_64 #1 PREEMPT(full)
>     [  739.196733] Hardware name: Xen HVM domU, BIOS 4.19.4 03/17/2026
>     [  739.196734] Call Trace:
>     [  739.196737]  <TASK>
>     [  739.196739]  dump_stack_lvl+0x5d/0x80
>     [  739.196744]  ubsan_epilogue+0x5/0x2b
>     [  739.196746]  __ubsan_handle_shift_out_of_bounds.cold+0x61/0xe6
>     [  739.196749]  __free_pages_ok.cold+0x13/0xa8
>     [  739.196753]  dma_free_noncontiguous+0xbf/0xe0
>     [  739.196756]  ? usb_free_noncoherent+0x3a/0x60
>     [  739.196761]  uvc_free_urb_buffers+0x38/0x90 [uvcvideo]
>     [  739.196773]  uvc_alloc_urb_buffers.part.0+0xe6/0x130 [uvcvideo]
>     [  739.196781]  uvc_video_start_transfer+0x19d/0x4e0 [uvcvideo]
>     [  739.196789]  uvc_video_start_streaming+0xab/0x100 [uvcvideo]
>     [  739.196797]  uvc_start_streaming_video+0xec/0x110 [uvcvideo]
>     [  739.196806]  vb2_start_streaming+0x63/0x130 [videobuf2_common]
>     [  739.196813]  vb2_core_streamon+0x98/0xf0 [videobuf2_common]
>     [  739.196819]  ? vb2_ioctl_streamon+0x15/0x60 [videobuf2_v4l2]
>     [  739.196824]  __video_do_ioctl+0x419/0x540 [videodev]
>     [  739.196847]  video_usercopy+0x23b/0x630 [videodev]
>     [  739.196863]  ? __pfx___video_do_ioctl+0x10/0x10 [videodev]
>     [  739.196880]  v4l2_ioctl+0x6b/0xa0 [videodev]
>     [  739.196895]  __x64_sys_ioctl+0x96/0xe0
>     [  739.196898]  do_syscall_64+0x120/0x6c0
>     [  739.196902]  ? do_read_fault+0xf5/0x220
>     [  739.196906]  ? do_fault+0x148/0x270
>     [  739.196908]  ? __handle_mm_fault+0x470/0x6c0
>     [  739.196911]  ? count_memcg_events+0xeb/0x1b0
>     [  739.196914]  ? handle_mm_fault+0x220/0x340
>     [  739.196916]  ? do_user_addr_fault+0x1e5/0x7f0
>     [  739.196920]  ? arch_exit_to_user_mode_prepare.isra.0+0x9f/0xe0
>     [  739.196924]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>     [  739.196926] RIP: 0033:0x738e787000ed
>     [  739.196929] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 =
c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f =
05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
>     [  739.196930] RSP: 002b:0000738e730e6a00 EFLAGS: 00000246 ORIG_RAX: =
0000000000000010
>     [  739.196933] RAX: ffffffffffffffda RBX: 0000738e64008850 RCX: 00007=
38e787000ed
>     [  739.196934] RDX: 000059d3df721cf0 RSI: 0000000040045612 RDI: 00000=
00000000010
>     [  739.196935] RBP: 0000738e730e6a50 R08: 0000738e6400ae40 R09: 00000=
00000000000
>     [  739.196936] R10: 0000738e6400ae30 R11: 0000000000000246 R12: 00000=
00000000000
>     [  739.196937] R13: 0000738e640012d0 R14: 0000738e64008850 R15: 00000=
00000000002
>     [  739.196939]  </TASK>
>     [  739.196940] ---[ end trace ]---
>     [  739.197835] BUG: Bad page state in process v4l2src0:src  pfn:009a0
>     [  739.198028] page: refcount:0 mapcount:0 mapping:0000000000000000 i=
ndex:0x2a pfn:0x9a0
>     [  739.198054] flags: 0x7ffffc0000000(node=3D0|zone=3D0|lastcpupid=3D=
0x1fffff)
>     [  739.198074] page_type: f0(buddy)
>     [  739.198088] raw: 0007ffffc0000000 fffffac1c0026a08 fffffac1c0025e0=
8 0000000000000000
>     [  739.198111] raw: 000000000000002a 0000000000000002 00000000f000000=
0 0000000000000000
>     [  739.198133] page dumped because: nonzero mapcount
>     [  739.198149] Modules linked in: nft_reject_ipv6 nf_reject_ipv6 nft_=
reject_ipv4 nf_reject_ipv4 nft_reject nft_ct nft_masq nft_chain_nat nf_nat =
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables uvcvideo ath3k btusb b=
tmtk uvc videobuf2_vmalloc btrtl videobuf2_memops videobuf2_v4l2 cdc_mbim b=
tbcm cdc_ncm videobuf2_common btintel cdc_ether usbnet videodev bluetooth m=
ii cdc_wdm mc rfkill cdc_acm joydev intel_rapl_msr intel_rapl_common ghash_=
clmulni_intel xhci_pci xhci_hcd ehci_pci ehci_hcd pcspkr i2c_piix4 ata_gene=
ric pata_acpi i2c_smbus serio_raw xen_scsiback target_core_mod xen_netback =
xen_privcmd xen_gntdev xen_gntalloc xen_blkback xen_evtchn i2c_dev fuse loo=
p nfnetlink overlay xen_blkfront
>     [  739.198472] CPU: 1 UID: 1000 PID: 1305 Comm: v4l2src0:src Not tain=
ted 7.0.0-0.rc4.1.qubes.1001.fc41.x86_64 #1 PREEMPT(full)
>     [  739.198475] Hardware name: Xen HVM domU, BIOS 4.19.4 03/17/2026
>     [  739.198477] Call Trace:
>     [  739.198479]  <TASK>
>     [  739.198480]  dump_stack_lvl+0x5d/0x80
>     [  739.198485]  bad_page.cold+0x7a/0x91
>     [  739.198488]  __free_pages_ok+0x481/0x680
>     [  739.198491]  dma_free_noncontiguous+0xbf/0xe0
>     [  739.198494]  ? usb_free_noncoherent+0x3a/0x60
>     [  739.198497]  uvc_free_urb_buffers+0x38/0x90 [uvcvideo]
>     [  739.198507]  uvc_alloc_urb_buffers.part.0+0xe6/0x130 [uvcvideo]
>     [  739.198515]  uvc_video_start_transfer+0x19d/0x4e0 [uvcvideo]
>     [  739.198523]  uvc_video_start_streaming+0xab/0x100 [uvcvideo]
>     [  739.198531]  uvc_start_streaming_video+0xec/0x110 [uvcvideo]
>     [  739.198539]  vb2_start_streaming+0x63/0x130 [videobuf2_common]
>     [  739.198546]  vb2_core_streamon+0x98/0xf0 [videobuf2_common]
>     [  739.198551]  ? vb2_ioctl_streamon+0x15/0x60 [videobuf2_v4l2]
>     [  739.198555]  __video_do_ioctl+0x419/0x540 [videodev]
>     [  739.198574]  video_usercopy+0x23b/0x630 [videodev]
>     [  739.198590]  ? __pfx___video_do_ioctl+0x10/0x10 [videodev]
>     [  739.198607]  v4l2_ioctl+0x6b/0xa0 [videodev]
>     [  739.198622]  __x64_sys_ioctl+0x96/0xe0
>     [  739.198625]  do_syscall_64+0x120/0x6c0
>     [  739.198629]  ? do_read_fault+0xf5/0x220
>     [  739.198632]  ? do_fault+0x148/0x270
>     [  739.198635]  ? __handle_mm_fault+0x470/0x6c0
>     [  739.198637]  ? count_memcg_events+0xeb/0x1b0
>     [  739.198640]  ? handle_mm_fault+0x220/0x340
>     [  739.198642]  ? do_user_addr_fault+0x1e5/0x7f0
>     [  739.198645]  ? arch_exit_to_user_mode_prepare.isra.0+0x9f/0xe0
>     [  739.198648]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>     [  739.198651] RIP: 0033:0x738e787000ed
>     [  739.198653] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 =
c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f =
05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
>     [  739.198654] RSP: 002b:0000738e730e6a00 EFLAGS: 00000246 ORIG_RAX: =
0000000000000010
>     [  739.198656] RAX: ffffffffffffffda RBX: 0000738e64008850 RCX: 00007=
38e787000ed
>     [  739.198657] RDX: 000059d3df721cf0 RSI: 0000000040045612 RDI: 00000=
00000000010
>     [  739.198658] RBP: 0000738e730e6a50 R08: 0000738e6400ae40 R09: 00000=
00000000000
>     [  739.198659] R10: 0000738e6400ae30 R11: 0000000000000246 R12: 00000=
00000000000
>     [  739.198660] R13: 0000738e640012d0 R14: 0000738e64008850 R15: 00000=
00000000002
>     [  739.198662]  </TASK>
>     [  739.198663] Disabling lock debugging due to kernel taint
>
> And eventually kernel panic:
>
>     [  740.464422] BUG: unable to handle page fault for address: fffffac1=
c0800000
>     [  740.464454] #PF: supervisor read access in kernel mode
>     [  740.464471] #PF: error_code(0x0000) - not-present page
>     [  740.464488] PGD 11be0067 P4D 11be0067 PUD 1148f067 PMD 0
>
> Full console log is at: https://gist.github.com/marmarek/5d839f419b1d56e7=
1a48e74ae66f0e7a
>
> --
> Best Regards,
> Marek Marczykowski-G=C3=B3recki
> Invisible Things Lab

Thanks!

--=20
Ricardo Ribalda

