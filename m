Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA19C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 10:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8CC36B0092; Mon,  4 Aug 2025 06:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3DB86B0093; Mon,  4 Aug 2025 06:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C786B0095; Mon,  4 Aug 2025 06:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 93B5C6B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:04:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 580BD1DE0E2
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:04:25 +0000 (UTC)
X-FDA: 83738640090.10.F98E15F
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 51018160003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:04:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EEmJ7mob;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754301863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRWJTy+mLBKBSxbyP1TehFPLIqhhGVs/w1u/dbI4iZQ=;
	b=wLIeh2A5CO8FprGnYA9Yrg7bndVyKEBxSGIo5PCLh2VGJUglU+7Cp/z/mdeRAygJ1sPxGg
	eBxCLbLbj9DBspKqdX1MQ9OE29fK8BAEQsDM9824A2wu5Gz9yZ6gRTE5WrFgBGeU6z2jvu
	ynLOYtMrO0k2gvm56j2M4LffeQ+FYM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754301863; a=rsa-sha256;
	cv=none;
	b=cdhWpwp31uehJQYUYi1gPEFm6OpUp8uJggfNTavJsbMpPoFtfbSkSUwm8/4qAf4FBPqSju
	85IsfifgxAEwNf6qXs7NNdnjZ9CtETWr6gvBDITTrwH6qjL91d533TYbflbE9NjzhTHobx
	J0uxSOM0aV3MN8IFZ7iI3d6MkYCf1w8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EEmJ7mob;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-87f04817bf6so2931131241.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 03:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754301862; x=1754906662; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRWJTy+mLBKBSxbyP1TehFPLIqhhGVs/w1u/dbI4iZQ=;
        b=EEmJ7mobAAG9VCbI2QxBRu+13ZyLabknrWPAdP8sSg8NnAFVEm89XK6A59VZrsxe1C
         cf+nlaBTSVwxj+thBt8vroazNBIWjCeQTWGFpZcaaRaHns2h33/U5zk4ML88qQY/Ph1H
         k0NvZGt/1sBSVB42GSmcq3kfjfZ0mOBiQUSwTw4DG2mMENy/YZ+U7vAVDkDWt+xfnfgG
         uHZoRxFiPeY28y/KQ3fZwZlns4lR8P4VNjqU9lq7vcpiZcY7mCvNs5IUE95PO238H86x
         cBmLvLkka+r7/GVgW+d2Lcdi6wmpr3PKTWFJ0izWjjRGGrQ/wbqMWwP5he2jCwP06O08
         GxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754301862; x=1754906662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YRWJTy+mLBKBSxbyP1TehFPLIqhhGVs/w1u/dbI4iZQ=;
        b=A+PEJLUGOMXkGyLOnS7DuCO0S4MYeuwNDJT4uE6A602VCOfKsHxW0D+dGkK8gKufx4
         ipYeGBW+53vjqsi/2d28/e2mwGPUD3BV1AwcTTOEggtmSPI/5CFOyv4vXc+g4o/TzzUc
         uYoW8VHKaJDoi3OK0WyZYcCwTJyPFKJoEq4lHES/YlKAcdSc+ZOBauIBQcr03s7hBMkg
         U3ZXHke0qwLAdAbJrXvbbI4PG0BIYgE7u1yE9kBAvqoBMeNdn0V13lOCU2vwM5IcNoAM
         MYv1UGk5Ik8UX3tfWqGbcmX/+8njDDrAtVCO8WqdXLjTHlifd2nMLFc3HGmOPPO+QaWq
         IEkg==
X-Forwarded-Encrypted: i=1; AJvYcCXSdUEC9yqDN19yuxE2yi/1r61HVZa+SdkHDGV6OQj56OG9D8Dl9BRkMX1dCLac2qay8/RyWTg8kg==@kvack.org
X-Gm-Message-State: AOJu0Yy5mLAiPn31f1oHYEidO+Nt6CPNQtAFih2oueeoHfYH35Q8TDKP
	viEVS59u2+q9tVAQc4vjMav+y4vssalSNKZ3rlvnIsElqcMZbCEiVrAhBXpdGmORzlU8OETgySN
	ESuUPl44ZxpgF9IKdO9JJ3xFZl4zfbPM=
X-Gm-Gg: ASbGncslho3cifvNs+lawAIR1AexglR0cbHXBPxvSylLNTt2qxHbwYfNRH33iJVbvxP
	kvKZ1Zk0fQP7XkNdcBfROSF9C61uvvDTt3AWBU4hr4xK7Vlswk7z5/9IqlijJBVCQSOQCG31a2q
	D552ks1ZZreBAuz76rLjErN0kkBXd+I9qzeBIZhe8d9oRhsXxiAJm7ueqQMrtWLq/WSpQz06SYR
	o6WRB38QlPB/5iI7A==
X-Google-Smtp-Source: AGHT+IGlyAM97ITpXb+I4johYOiMqVNP/L/7mRsJVUyDhylX/Qc4TcOFu2s16cKEM7TqfM8PRN+irC2YyyNEyde29l8=
X-Received: by 2002:a05:6102:6894:b0:4e9:8f71:bd4f with SMTP id
 ada2fe7eead31-4fdc1b4fc32mr3381516137.3.1754301862193; Mon, 04 Aug 2025
 03:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250607220150.2980-1-21cnbao@gmail.com> <aJAFrYfyzGpbm+0m@ly-workstation>
 <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com> <4fa8f492-c7ef-451c-8dc7-38b031c8a092@bytedance.com>
 <d9d0890e-2837-49dc-9ca8-1d6c28e95a21@redhat.com> <aJB0Kdc6cx1lGkdb@ly-workstation>
 <CAGsJ_4yw4Qn7OWmUJeJZYuOHLjJ7L8kov3Th3vFPa3h4y0ur_A@mail.gmail.com>
 <7d92ec18-ff8e-4929-8b9a-f0bf5c6d249f@bytedance.com> <ca86203d-89b5-4282-b318-2ac82fd2121f@bytedance.com>
In-Reply-To: <ca86203d-89b5-4282-b318-2ac82fd2121f@bytedance.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 4 Aug 2025 22:04:11 +1200
X-Gm-Features: Ac12FXwcnY8-s17fkhP2BhhtZchoFsWJziPluE5wP1XYtcDSgD7prKLao16EDn0
Message-ID: <CAGsJ_4wWUcLf79NqkQ9C+2mO684AP6HvmgispSZ0Lh3wt330Eg@mail.gmail.com>
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	Tangquan Zheng <zhengtangquan@oppo.com>, yi1.lai@intel.com, 
	"Lai, Yi" <yi1.lai@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 51018160003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: r7bh6omf91tewcsyd96xgfnuwmbh74hc
X-HE-Tag: 1754301863-32107
X-HE-Meta: U2FsdGVkX1+WNMsqPs87E7l1X3xE8A5idDz+c9m8lx8PS3yecLryqAqbwGwvDvHMmnovX8R3K0LuuYqM3D6jf4yL+trueBh6nZnczpZVqKDDUQze3RIaEbi7IWl3uxEm0T+cE/nWDIHINkegx6Xz4Ym5Jhao3XSLiP9P+spjpwi4m52k8otGrjOxBs55KkFCsoY5jm/8xl7IWENftCv953TDF5itMz7ijOfhxqoTjoAwGz5D0jssvIuBU2a1cTUdxwzsK6n7ql2XHzI0Gw8Md5PFWTNO6Xm8MrKPcB74On9kqt8rzonycUNJmtTEAi+WhfF38aRrEaRmmO/5FrdQC0ix72xqd+cfWzwUGGM7Uwh+81HZcNhD/eSct1zhl8mM6ZNxhQsU4wzEdK87ZYr4oWFT37q+0nTAUlYkhYzBcXRm9TkDKI9L1bbX2rO/nqU3tCTellyCxPOkuNBi+MnL4i54Yxig9Xn6pnuZq+HV5kFBBl2BhBlvxtRxPuMpTVoyjpLG/MLyM65Zj/f+I2KSrMo+bKhmezyoRvKqQsf1IJNrf2EPVbNYrJaPMTuwWB7lNAOy+O5u1gdUBhyXxoIN/ANZN9Z5/JloZFuefhHVbVGyKkIaMX1wS76QyUiEUbbzyu6aaGCObUUn9RffyPR/VysMQnOj2gwuKzt+iN8AgjDu0C9urKwQEYSRbWky/zn075h2H3c4e/P3NHfxaz+1ZVdjSDTA03Py8pPHhy6PTOiL4wTelsx7izycHSANgOnJEUnfjkZd6o4543NYi7jN5bcezQwCbpAWEYbmm03ZrQKc4BN+26R03nsdo1mKopTyO5dhlpKbfLaK7pgOb45sytR8L+N0xYkFHjYC5qDyRKbk1G9vAzVvlcoQgKg2TME2lKkRs0w9WhZ/+91txAssQvqyVRdDe1Pb/dEVTOyFq24x3ADo15YbY48AvFwXwggcwI8mrDoM8u+SqJbUMFN
 zttsbwkG
 54rfgnampyzgRlMzLj2bo/W0+q5llHDwg7k5O7FYarm0LUXxmcSHdrd3TwDoLDcotMVAnS6he2gvGEA98AuMDA3BfgYwujPV8wvfUZfD0E0zKhpFp77fvdndJ8d/UkJifG2pjHj43IMFbz5TX0AFOd7Y57k1yWNh+VZ+LJUek9sVPsalpvHYEasad2ggsm9DGlS9+SMkiOHc954QZkgxpyeXVqxKNxYxraNcAWUdkOX/LueH38ZD2HKNimRoYf/Z+AUNnKd0BGbjvFUTGeQJ327GtNmmbkcmt/7ZzkkGCoIWh7ZWAUWsu2yBMCXaIbfn99nnuvscJwUsWRvXI2DzL/xZSoiq9RX0KxEDUqYoq82X2IZiKj4mB0IUX1xkR4rmfBZREJcodHLW9IJnwAwQFmibV4kROyxPHlrZC1BFZGH4aCmmZ2IFcsfdCUapJkoBxpOusTj66lWZXIHEKniRh4PCdmqywjCuA56uf4bKfQnJbeULWvN1q+tgiaCqQw6yeXlsE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 9:54=E2=80=AFPM Qi Zheng <zhengqi.arch@bytedance.com=
> wrote:
[...]
> >>>>
> >>> My kernel compiling steps:
> >>> 1. copy kconfig_origin to kernel_source_folder/.config
> >>> 2. make olddefconfig
> >>> 3. make bzImage -jx
> >>>
> >>> I have also uploaded the actual .config during compiling.
> >>> [2] https://github.com/laifryiee/syzkaller_logs/blob/
> >>> main/250803_193026___pte_offset_map_lock/.config
> >>> CONFIG_ARCH_SUPPORTS_PT_RECLAIM=3Dy
> >>> CONFIG_PT_RECLAIM=3Dy
> >>
> >> Thanks! I can reproduce the issue within one second.
> >
> > I also reproduced it locally.
>
> Hi Barry, can you reproduce this problem stably? I can't reproduce it
> again after reproducing it once. :(
>

Yes, the issue reliably reproduces within a short time after every reboot.

[root@test ~]# ./repro
[   18.189594] loop0: detected capacity change from 0 to 65536
[   18.339652] loop0: detected capacity change from 0 to 65536
[   18.488875] loop0: detected capacity change from 0 to 65536
[   18.658206] loop0: detected capacity change from 0 to 65536
[   18.793696] loop0: detected capacity change from 0 to 65536
[   18.796660] Oops: general protection fault, probably for
non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN NOPTI
[   18.797417] KASAN: null-ptr-deref in range
[0x0000000000000018-0x000000000000001f]
[   18.797926] CPU: 0 UID: 0 PID: 635 Comm: repro Not tainted
6.16.0-next-20250801-kvm+ #3 PREEMPT(voluntary)
[   18.798568] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   18.799324] RIP: 0010:kasan_byte_accessible+0x15/0x30
[   18.799685] Code: cc 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90
90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ef 03
48 01 c7 <0f> b6 07 3c 07 0f 96 c0 c3 cc cc cc cc 66 66 2e 0f 1f 0
[   18.800906] RSP: 0018:ffff8880136df678 EFLAGS: 00010286
[   18.801265] RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff0d=
de60c
[   18.801742] RDX: 0000000000000000 RSI: ffffffff85da2e18 RDI: dffffc00000=
00003
[   18.802224] RBP: ffff8880136df698 R08: 0000000000000001 R09: 00000000000=
00000
[   18.802702] R10: 0000000000000000 R11: ffff8880123558d8 R12: 00000000000=
00018
[   18.803181] R13: 0000000000000018 R14: ffffffff85da2e18 R15: 00000000000=
00000
[   18.803659] FS:  0000000000000000(0000) GS:ffff8880e3b40000(0000)
knlGS:0000000000000000
[   18.804199] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.804588] CR2: 00007f52bf71ffc0 CR3: 00000000119eb000 CR4: 00000000007=
50ef0
[   18.805066] PKRU: 55555554
[   18.805260] Call Trace:

Thanks
Barry

