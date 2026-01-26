Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 961A8D19523
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 22:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8D696B0088; Mon, 26 Jan 2026 17:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B6C6B0089; Mon, 26 Jan 2026 17:33:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C5F6B008A; Mon, 26 Jan 2026 17:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA006B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:33:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 357E116095B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 22:33:36 +0000 (UTC)
X-FDA: 84375568032.04.963E9FA
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 21F931A0002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 22:33:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c7Hl6vra;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769466814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mackZotkIKvwV0WRbHOpinSiGL+O/1eaZatL1YEdROs=;
	b=kEuZwUpgZzuqSrIsOCSzepkWgHWinx7eiWqQiGM9ONOZRsoUovjZXDSMC2tmkCgiiPkHDR
	W2gv3YWv4MVDNkJOEfOe/0rUXu4FOeuxekJuOEnqUA9X1cVWv0ZiFE28Ig/4oFnv8+GQt3
	4svt4TZf93nKYln8J9DSFWjZHMyo2jk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c7Hl6vra;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769466814; a=rsa-sha256;
	cv=pass;
	b=ccBOWQ7/f7GuJngrrOcI+aEtu35mhXgQEaIVaWOInm0nSZxOMTrh1sskflO5eOx57UrH7e
	BwA7XTirmRvUJBLbdlHLr/21EtwEKz6wOEKZdk7anYyynvW4nHyPrIuPCtOd5CKNhEdn73
	7hdn/qeClGuEIYblUMDV+Pb9FHtilEU=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50299648ae9so49501cf.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:33:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769466813; cv=none;
        d=google.com; s=arc-20240605;
        b=NhrvRrbyHAXDBGbg+oE0OqyB2EX0HTvBm6JSEh6jfHEMR2AporOlGTwPp+eHgh5HRS
         r/Q9niNFBeHrJT2eTJjuvnA682pjBLVuv4Pr9Ca3/Qp1xIXt9BoFqAiUz5l7iFhmpgJA
         W4Fqgr2MCUAiIMMgzXsbWMb8/PMi7PI02TCLt624X73VAWggIJK8Eoh+HX5A+f11QyQF
         MGnGbaIvarWd4EDOgfOY4RYSWHhNhIC0hRloiI69gDqMZlUs6ba8/QGmTXZ2LDDRZsGI
         3f3EVysrKwsrC+Ly+YsXIYJYPoZSpLVeY/keBieLNPwsHks1QuwNDP19RRWSOMAuXJZW
         GHRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mackZotkIKvwV0WRbHOpinSiGL+O/1eaZatL1YEdROs=;
        fh=H3N8cfqW7lJ2Ya0Vxz16Sam5Ny8OOpdYfQdz9+JS6i0=;
        b=WxMv7MA9hfLE0CNUzO0M4JVCpZr5Q+SXgSnt0VmxqUknx03VY5mvmYwhtatDDMBaSI
         QvdYRlSAq7UjGfNqBNNs6m4b0xCUwYIQ2YeD/jhVHj5nmwHt13qPRTuEyVBWWBa+4Iw7
         Gt5ZnOUMsIfv5Uvw4hd/3l/kkJk8YHfN52WAQmNtkTVvv56HV8uWYA/XAliVZ3xZm5Gh
         hSmhBoHXiDNVfNURF/gRqssF72QWjl0Ybu3skCw50n4utiLay5+Z1KIkOPVw93eiUaHZ
         Qzy3mkeYe4xliVXTKInLREgeldBLrsJKj7c6RRvq+kPbt9K1IF4i2dVdGhcnlg5oXUgf
         LkaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769466813; x=1770071613; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mackZotkIKvwV0WRbHOpinSiGL+O/1eaZatL1YEdROs=;
        b=c7Hl6vraiyDuDtuwJ9TY5jvHCLGmWg3AcFzxfDXmyTts8D5mvi1XGHKcn880iAeUI4
         lsirdplECm/UMBQOeql1hzFfTLllpB7sXWUY4/d8rXiXJnh8bOUJSxTkWEwE15izWhqt
         KaSpd7V2zthUwrPwfKqIePZLNvbD86pB6iAEZePliB+J3Ux5dSkUNu2bPl8YQvlVt1i6
         THnp3S2q6L1kiwI8oSSO3bzX1oG+FSWugGqskKq+HzHM2vIGd+uLoOp6d5zY3Q7wSxok
         7sQuKnBsNyxYEVY2WQJScjv1EHMvMrVRh8FLgRIgbVphEz1JK41Pkuu8RoYzqdzU73Ub
         Qnjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769466813; x=1770071613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mackZotkIKvwV0WRbHOpinSiGL+O/1eaZatL1YEdROs=;
        b=EDid4c+Nk3QfrItx4ua2xFB+MBZPHAggR4JtkSsAHcXXrcvIzJeQWfUGsUk8wN90bX
         fwNDpn22hXOlTQ/Ymh7yFwt15FLNzSsNUbV7saQ+LLEkw3S15iIOafpibvJBv5UElnbq
         oHAmoY6R8Zbl5rnfiZRap2z7XXOkx1d7mxjFSt3p0+D3WtdyLuT0hiPb8CtADkur2g7N
         aB6BgX1Sd/dfuaI2z+6afTElHi4AKh4Ourn9C24IFNheCIjpCZvnLmupexucZIK6Gwhm
         6YpCvTUQNS0UJKuusURu1znS9oYOMcJ0i/xjQDAb8HaWT1LGZIeQaqoM2ob3CJzhUKrD
         UH/w==
X-Forwarded-Encrypted: i=1; AJvYcCUfT7eYyq6hfjAcF1Bwx5T7cIHlO26ApltsalsjnuPou8ssCszbOIcl3ivc/QYv6jeu3OoQVp6O9g==@kvack.org
X-Gm-Message-State: AOJu0YwBIPuG8Zylvys/zBzRnqTMqK64EQ4POn6AJ6FM7MXl2R46W/w2
	68segt+SGCw4/o8I7vdxN6Cs5H7wbHzjji091RQp0sfzUD7rSIfnrgmatw4ddGwncw/qri+BC47
	dWlIUdghnMk2D3GTxo0y46r6TsTxlsvWTI18IjP8K
X-Gm-Gg: AZuq6aK7UTEmbf80QOw+wJVt/v1LpU9rNVZtK4Zd8yrFUJTggbGay4mVqa3HIXJZsVl
	66AuYTNe2vrqCk1458pRD+hbYZHiQuoDMFVG9GrdLD1cHSvRdhAzo0xwOEPnYicMzmsv+R1Ttir
	IPRjQHwLy0Lgr3oS8l19nbLrxB8IfrpGH/hDhndVC0MvB2O8KfOQZFjjK01OIczG6dOXyLHQ+ra
	xfg29ztuxiwhlsp1Barxcno6rewvkyY8jwHAcPMmfiwd9w/02bRETcFcDoksl1Z/PDPxQ==
X-Received: by 2002:ac8:7e81:0:b0:4ed:70d6:6618 with SMTP id
 d75a77b69052e-5031434c53bmr5070331cf.10.1769466812800; Mon, 26 Jan 2026
 14:33:32 -0800 (PST)
MIME-Version: 1.0
References: <697400dc.a70a0220.35de72.000a.GAE@google.com> <20260124113148.2398-1-hdanton@sina.com>
 <CAJuCfpEcqAiK-z=EZ5im12F2wfGHYogiMHaTC4t5uopLmBKQPw@mail.gmail.com>
In-Reply-To: <CAJuCfpEcqAiK-z=EZ5im12F2wfGHYogiMHaTC4t5uopLmBKQPw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 26 Jan 2026 14:33:21 -0800
X-Gm-Features: AZwV_QjG0HdzQ3mdcLwZReNt28tz9EkyAA5jdwVASXhwRJhBie71_qIvsEwDqNU
Message-ID: <CAJuCfpEJUeQcpfbh-0KTsp1UdTs5yrKTbvAV6QOKdQHJZ2HWww@mail.gmail.com>
Subject: Re: [syzbot] [block?] possible deadlock in blkdev_read_iter
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com>, axboe@kernel.dk, 
	linux-block@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 21F931A0002
X-Stat-Signature: byphmnixoxxa9edz35n4dfgec3gj5h9f
X-Rspam-User: 
X-HE-Tag: 1769466813-700002
X-HE-Meta: U2FsdGVkX1/W8yqrcqHz30OynlZj27+gg0x3PAKWWIr5ocziIYw6owcVj9JJrr7JEU7kBPD/MOtef7bO1AJV9yB3N6GSi2Ooa6l2MXXo8+s0K+SbG6CfvFh08igTfz+RXRT7M6uSx2Z05FYSGiPYNmUm3c1j2VdVibSJO4kaMnD6vf7SO7yNmNCHkYZxPJA0DvJ3IikbY5jXIrv19Lq+Qro6EpKjX9npssAmEXbEca3cR+Iw/u4aNd01LUx29yT1YuTXCqmwkqCnNSlfJDws/g7O0z+kqUueOBLJqkqtjEc7pzz406/ITKuK6luduuDK4eAYSSxoKYGaz3jo+Lpl4XR1ys7xTPFsUUY+oZvEkR+RXCm1NGZc9Rvaa1kTobpQFpGDhimoPqhfwo1RHHA9JZpPyynAhwlSeTx4kcAzL+vAkmjO1qssbLqTGFgyeqn6/ggtx4vnDD53Xdl8+p7HuDl2xuxrIsT2G1AT88xXCcwCQk1jOX0eYhQYKiwsPaiKXoa2FzdsqeTp3Ar/UMpVJAOKI5v/saL+/fy5sbzQSx3dd1bLgYI7R5wYSa8sC/HCOSqfviyQgLUvZ5Yydof0bROD3sgceLnnaY9KRYOX8dXT3gXFOq2lo6ZoWdlW6BVX7Bcmdr6nlIYh/3Zg7JciqLShehmYUIntp4EeZDQnzpUJlkR4RDINnBEJ/sgA390RpGF/VcS0YCkTx34ny+TTGyBQXcniUvhrjGMUe8LA/L3aJJWFhGVe2nXFC6e/+HDbDh9Ts6kmEBkqNsrp9pEdHyK5UvhFvCKTPKQq3fifMS6qQDihef8ZaTqXPqc4wmWNieEg4bo5nzub1KLiWf3lDL+okC6ZE6jbZH8xcECVYj5HG42SN+zEgC1ld4SBrqLvLDxUbdDuHwjOkdhXboHlRhxHIPq1UdazWjgNV6Euq5e4I9X5K3Uthe5wDoKTZ+KkfqoUS9B22EO+cr1y4KG
 aZd4VUhs
 xwvSuYM6Jg/0g8aH7hJnmSS2x94USpiKmdplyXGH9tjHAEgyd7UUwhIxGDErrfBpdNm5CAEh74Ud5k8XJ1F9nkfWkRdAHEcsajYMb6Jad2PFLGRAlZehJg2t9c4r3S2odzuS71+me8XOT9Sfty7JpUpVlZpvzOP8kP8qJEXLe2XDbJDD75HKFxm2W46lkDa1KZiHGenIsLFbiW6HNTo8dHSR57uFl9Syk0dQOg6CQebZNUIWHxrHmU87n4Ih56vykS2CBzqUOaNjnf74AATQZQWD5dxR5w/sj1Twfs8ud7QwOq+KTjlldPSjniSzuw+ISo2P7lIatxI3rL9jGT3O2T5Hkeczqjj/lWLcY3S/7SHRi58UinqJ+eoF7yhH0BRaFkvUd0bNE3GRCf3rXgDUHBXXrYtZkYljO/tKHQuOyqh+Vtjme1ZgnrKhwloMSkj8vFUNDnh9g9EeG/cOL/hvcxTDI4gDKafqdvoi+S3m+bH2x0ng/tfMuNx6WcHUniAkUopgbHAGBZaegbFcGKW/3q0iriIOcKwH3JnGBt39clkzJ1uefoxUrbo3LnomGK84mTKqceYklvsGkkSpocwXrcor8MULeBkXj+QKU4e2I0UiV5/v+R8l23CpPh335lal0IAcnkiFls/o1k7taPd123UHiuprY42LRQwXrgdOOy4Hr6CighzoqU7ToCA7tkJQpejScyWeU8lHipp+M7gRKIsuIrOXhoTYlBLLlHrJLVNSdbFylhms3rOR/cOXe1g3XVBcJymmWEDsDYsBQABAPVk8LULzz8zzWdgrjaMD6D2NXvpuG3VuBUxb2IbZW2D6cprBf9Dzq/Ic4MuOUxBh0Snxw5YqEM+wL8svQa6uuxaTPennPwOnbEXvmd36Zzj0NxHwX4hiwn4KJfzP2wHYkH/6LNdh0M+ip70qra/hpTPcm0zt0URgVgnwQTkYfBEpQPxCfoAaIqIJPTF9mkq4c+7wrUF0w
 XJy/ETXx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 9:20=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Sat, Jan 24, 2026 at 3:32=E2=80=AFAM Hillf Danton <hdanton@sina.com> w=
rote:
> >
> > Add Lorenzo and Suren
>
> Thanks!
>
> >
> > > Date: Fri, 23 Jan 2026 15:14:36 -0800
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    24d479d26b25 Linux 6.19-rc6
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D100033fa5=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D185947683=
2863c41
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4e70c8e0a20=
17b432f7a
> > > compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Bi=
nutils for Debian) 2.40
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D11451b9=
a580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1045e8525=
80000
> > >
> > > Downloadable assets:
> > > disk image (non-bootable): https://storage.googleapis.com/syzbot-asse=
ts/d900f083ada3/non_bootable_disk-24d479d2.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/d0f3c47f6869/vm=
linux-24d479d2.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/8002315137=
03/bzImage-24d479d2.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
> > >
> > > WARNING: possible circular locking dependency detected
> > > syzkaller #0 Not tainted
> > > ------------------------------------------------------
> > > syz.0.17/6091 is trying to acquire lock:
> > > ffff8881061287a8 (
> > > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: inode_lock_shared includ=
e/linux/fs.h:1042 [inline]
> > > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: blkdev_read_iter+0x19e/0=
x500 block/fops.c:855
> > >
> > > but task is already holding lock:
> > > ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x10e/0xed0=
 mm/mmap_lock.c:334
> > >
> > > which lock already depends on the new lock.
> > >
> > >
> > > the existing dependency chain (in reverse order) is:
> > >
> > > -> #2 (vm_lock){++++}-{0:0}:
> > >        __vma_enter_locked+0x260/0x770 mm/mmap_lock.c:72
> > >        __vma_start_write+0x21/0x160 mm/mmap_lock.c:104
> > >        vma_start_write include/linux/mmap_lock.h:213 [inline]
> > >        mprotect_fixup+0x4e3/0xb80 mm/mprotect.c:768
> > >        setup_arg_pages+0x4a2/0xbb0 fs/exec.c:670
> > >        load_elf_binary+0xb5b/0x4fe0 fs/binfmt_elf.c:1028
> > >        search_binary_handler fs/exec.c:1669 [inline]
> > >        exec_binprm fs/exec.c:1701 [inline]
> > >        bprm_execve fs/exec.c:1753 [inline]
> > >        bprm_execve+0x8c2/0x1620 fs/exec.c:1729
> > >        kernel_execve+0x2ef/0x3b0 fs/exec.c:1919
> > >        try_to_run_init_process init/main.c:1506 [inline]
> > >        kernel_init+0x14a/0x2b0 init/main.c:1634
> > >        ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
> > >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> > >
> > > -> #1 (&mm->mmap_lock){++++}-{4:4}:
> > >        __might_fault mm/memory.c:7174 [inline]
> > >        __might_fault+0x113/0x190 mm/memory.c:7168
> > >        _copy_to_iter+0x1c2/0x1710 lib/iov_iter.c:196
> > >        copy_page_to_iter lib/iov_iter.c:374 [inline]
> > >        copy_page_to_iter+0x12a/0x1e0 lib/iov_iter.c:361
> > >        copy_folio_to_iter include/linux/uio.h:204 [inline]
> > >        filemap_read+0x6b1/0xe40 mm/filemap.c:2851
> > >        blkdev_read_iter+0x1ac/0x500 block/fops.c:856
> > >        new_sync_read fs/read_write.c:491 [inline]
> > >        vfs_read+0x8bf/0xcf0 fs/read_write.c:572
> > >        ksys_read+0x12a/0x250 fs/read_write.c:715
> > >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> > > -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
> > >        check_prev_add kernel/locking/lockdep.c:3165 [inline]
> > >        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> > >        validate_chain kernel/locking/lockdep.c:3908 [inline]
> > >        __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
> > >        lock_acquire kernel/locking/lockdep.c:5868 [inline]
> > >        lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> > >        down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> > >        inode_lock_shared include/linux/fs.h:1042 [inline]
> > >        blkdev_read_iter+0x19e/0x500 block/fops.c:855
> > >        __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> > >        freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> > >        __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> > >        do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> > >        procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> > >        vfs_ioctl fs/ioctl.c:51 [inline]
> > >        __do_sys_ioctl fs/ioctl.c:597 [inline]
> > >        __se_sys_ioctl fs/ioctl.c:583 [inline]
> > >        __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> > >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
>
> It looks like:
> #0 is executing PROCMAP_QUERY ioclt, read-locks vm_lock and then calls
> build_id_parse()->__build_id_parse(...,
> may_fault=3Dtrue)->__kernel_read() which eventually takes
> inode->i_rwsem.
> #1 is a file-backed page fault which asserts that it might take
> mmap_lock for read.
> #2 is load_elf_binary()->mprotect_fixup() which write-locks both
> mmap_lock and vm_lock. I'm guessing it already holds inode->i_rwsem
> before write-locking these locks.
>
> Originally I thought the issue is most liley introduced in
> d9d1c2d81797 ("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under
> per-vma locks"). But if #2 indeed takes inode->i_rwsem before
> write-locking mmap_lock, then the problem should exist even before
> that change when we didn't use vm_lock and relied on mmap_lock...
>
> I'll try to analyze this more before attempting a fix.

I was able to reproduce the same issue even after reverting
d9d1c2d81797. The deadlock in this case is simpler and involves
mmap_lock instead of vm_lock (see below).
Looks like the race is between the read() syscall and do_procmap_query().
I'll continue investigating, in the meantime CC'ing Andrii.

[   62.320932][ T9229]
[   62.321471][ T9229] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   62.323016][ T9229] WARNING: possible circular locking dependency detect=
ed
[   62.324618][ T9229] 6.19.0-rc6-00001-g40bea6261b2a #42 Not tainted
[   62.326013][ T9229] ----------------------------------------------------=
--
[   62.327560][ T9229] hillf/9229 is trying to acquire lock:
[   62.328821][ T9229] ffff888145b7b5a8
(&sb->s_type->i_mutex_key#8){++++}-{4:4}, at:
blkdev_read_iter+0x2a7/0x4e0
[   62.331102][ T9229]
[   62.331102][ T9229] but task is already holding lock:
[   62.332722][ T9229] ffff888183a6e540 (&mm->mmap_lock){++++}-{4:4},
at: do_procmap_query+0x39f/0x1050
[   62.334795][ T9229]
[   62.334795][ T9229] which lock already depends on the new lock.
[   62.334795][ T9229]
[   62.337072][ T9229]
[   62.337072][ T9229] the existing dependency chain (in reverse order) is:
[   62.338998][ T9229]
[   62.338998][ T9229] -> #1 (&mm->mmap_lock){++++}-{4:4}:
[   62.340646][ T9229]        __might_fault+0xed/0x170
[   62.341763][ T9229]        _copy_to_iter+0x118/0x1720
[   62.342913][ T9229]        copy_page_to_iter+0x12d/0x1e0
[   62.344167][ T9229]        filemap_read+0x720/0x10a0
[   62.345298][ T9229]        blkdev_read_iter+0x2b5/0x4e0
[   62.346480][ T9229]        vfs_read+0x7f4/0xae0
[   62.347518][ T9229]        ksys_read+0x12a/0x250
[   62.348584][ T9229]        do_syscall_64+0xcb/0xf80
[   62.349707][ T9229]        entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   62.351116][ T9229]
[   62.351116][ T9229] -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
[   62.353012][ T9229]        __lock_acquire+0x1509/0x26d0
[   62.354213][ T9229]        lock_acquire+0x185/0x340
[   62.355323][ T9229]        down_read+0x98/0x490
[   62.356441][ T9229]        blkdev_read_iter+0x2a7/0x4e0
[   62.357619][ T9229]        __kernel_read+0x39a/0xa90
[   62.358767][ T9229]        freader_fetch+0x1d5/0xa80
[   62.359927][ T9229]        __build_id_parse.isra.0+0xea/0x6a0
[   62.361232][ T9229]        do_procmap_query+0xd75/0x1050
[   62.362434][ T9229]        procfs_procmap_ioctl+0x7a/0xb0
[   62.363687][ T9229]        __x64_sys_ioctl+0x18e/0x210
[   62.364863][ T9229]        do_syscall_64+0xcb/0xf80
[   62.365977][ T9229]        entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   62.367394][ T9229]
[   62.367394][ T9229] other info that might help us debug this:
[   62.367394][ T9229]
[   62.369637][ T9229]  Possible unsafe locking scenario:
[   62.369637][ T9229]
[   62.371237][ T9229]        CPU0                    CPU1
[   62.372441][ T9229]        ----                    ----
[   62.373687][ T9229]   rlock(&mm->mmap_lock);
[   62.374688][ T9229]
lock(&sb->s_type->i_mutex_key#8);
[   62.376444][ T9229]                                lock(&mm->mmap_lock);
[   62.377956][ T9229]   rlock(&sb->s_type->i_mutex_key#8);
[   62.379165][ T9229]
[   62.379165][ T9229]  *** DEADLOCK ***
[   62.379165][ T9229]
[   62.380952][ T9229] 1 lock held by hillf/9229:
[   62.381971][ T9229]  #0: ffff888183a6e540
(&mm->mmap_lock){++++}-{4:4}, at: do_procmap_query+0x39f/0x1050
[   62.384162][ T9229]
[   62.384162][ T9229] stack backtrace:
[   62.385458][ T9229] CPU: 3 UID: 0 PID: 9229 Comm: hillf Not tainted
6.19.0-rc6-00001-g40bea6261b2a #42 PREEMPT(full)
[   62.385471][ T9229] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
[   62.385477][ T9229] Call Trace:
[   62.385482][ T9229]  <TASK>
[   62.385487][ T9229]  dump_stack_lvl+0x100/0x190
[   62.385505][ T9229]  print_circular_bug.cold+0x185/0x1d5
[   62.385521][ T9229]  check_noncircular+0x14a/0x170
[   62.385534][ T9229]  __lock_acquire+0x1509/0x26d0
[   62.385547][ T9229]  lock_acquire+0x185/0x340
[   62.385557][ T9229]  ? blkdev_read_iter+0x2a7/0x4e0
[   62.385569][ T9229]  ? __pfx___might_resched+0x10/0x10
[   62.385583][ T9229]  down_read+0x98/0x490
[   62.385593][ T9229]  ? blkdev_read_iter+0x2a7/0x4e0
[   62.385603][ T9229]  ? __pfx_down_read+0x10/0x10
[   62.385612][ T9229]  ? lock_acquire+0x185/0x340
[   62.385622][ T9229]  ? is_bpf_text_address+0x25/0x1a0
[   62.385634][ T9229]  blkdev_read_iter+0x2a7/0x4e0
[   62.385645][ T9229]  __kernel_read+0x39a/0xa90
[   62.385658][ T9229]  ? __pfx___kernel_read+0x10/0x10
[   62.385671][ T9229]  ? __lock_acquire+0x481/0x26d0
[   62.385683][ T9229]  freader_fetch+0x1d5/0xa80
[   62.385697][ T9229]  ? find_held_lock+0x2b/0x80
[   62.385712][ T9229]  ? __pfx_freader_fetch+0x10/0x10
[   62.385725][ T9229]  ? __asan_memset+0x27/0x50
[   62.385737][ T9229]  __build_id_parse.isra.0+0xea/0x6a0
[   62.385751][ T9229]  ? __pfx___build_id_parse.isra.0+0x10/0x10
[   62.385766][ T9229]  ? __pfx_find_vma+0x10/0x10
[   62.385774][ T9229]  ? __might_fault+0x129/0x170
[   62.385788][ T9229]  do_procmap_query+0xd75/0x1050
[   62.385798][ T9229]  ? __pfx_do_procmap_query+0x10/0x10
[   62.385807][ T9229]  ? __sanitizer_cov_trace_switch+0x53/0x90
[   62.385817][ T9229]  ? do_vfs_ioctl+0x226/0x13b0
[   62.385828][ T9229]  ? __pfx_do_vfs_ioctl+0x10/0x10
[   62.385839][ T9229]  ? putname+0xfc/0x1b0
[   62.385846][ T9229]  ? putname+0x101/0x1b0
[   62.385857][ T9229]  ? __x64_sys_openat+0x143/0x210
[   62.385867][ T9229]  procfs_procmap_ioctl+0x7a/0xb0
[   62.385877][ T9229]  ? __pfx_procfs_procmap_ioctl+0x10/0x10
[   62.385888][ T9229]  __x64_sys_ioctl+0x18e/0x210
[   62.385899][ T9229]  do_syscall_64+0xcb/0xf80
[   62.385913][ T9229]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   62.385923][ T9229] RIP: 0033:0x412209
[   62.385931][ T9229] Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f
44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8
64 89 01 48
[   62.385940][ T9229] RSP: 002b:00007fff380d5588 EFLAGS: 00000217
ORIG_RAX: 0000000000000010
[   62.385950][ T9229] RAX: ffffffffffffffda RBX: 00007fff380d56c8
RCX: 0000000000412209
[   62.385956][ T9229] RDX: 0000200000000180 RSI: 00000000c0686611
RDI: 0000000000000004
[   62.385962][ T9229] RBP: 00007fff380d55a0 R08: 0000000000000000
R09: 00007fff380d5640
[   62.385968][ T9229] R10: 0000000000000000 R11: 0000000000000217
R12: 00007fff380d56b8
[   62.385974][ T9229] R13: 0000000000000002 R14: 00000000004a0e40
R15: 0000000000000002
[   62.385982][ T9229]  </TASK>



>
> > > other info that might help us debug this:
> > >
> > > Chain exists of:
> > >   &sb->s_type->i_mutex_key#8 --> &mm->mmap_lock --> vm_lock
> > >
> > >  Possible unsafe locking scenario:
> > >
> > >        CPU0                    CPU1
> > >        ----                    ----
> > >   rlock(vm_lock);
> > >                                lock(&mm->mmap_lock);
> > >                                lock(vm_lock);
> > >   rlock(&sb->s_type->i_mutex_key#8);
> > >
> > >  *** DEADLOCK ***
> > >
> > > 1 lock held by syz.0.17/6091:
> > >  #0: ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x10e/=
0xed0 mm/mmap_lock.c:334
> > >
> > > stack backtrace:
> > > CPU: 2 UID: 0 PID: 6091 Comm: syz.0.17 Not tainted syzkaller #0 PREEM=
PT(full)
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debia=
n-1.16.3-2~bpo12+1 04/01/2014
> > > Call Trace:
> > >  <TASK>
> > >  __dump_stack lib/dump_stack.c:94 [inline]
> > >  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
> > >  print_circular_bug+0x275/0x340 kernel/locking/lockdep.c:2043
> > >  check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
> > >  check_prev_add kernel/locking/lockdep.c:3165 [inline]
> > >  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> > >  validate_chain kernel/locking/lockdep.c:3908 [inline]
> > >  __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
> > >  lock_acquire kernel/locking/lockdep.c:5868 [inline]
> > >  lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> > >  down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> > >  inode_lock_shared include/linux/fs.h:1042 [inline]
> > >  blkdev_read_iter+0x19e/0x500 block/fops.c:855
> > >  __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> > >  freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> > >  __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> > >  do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> > >  procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > >  __se_sys_ioctl fs/ioctl.c:583 [inline]
> > >  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x7ff1a238f7c9
> > > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007ffebbe538b8 EFLAGS: 00000246 ORIG_RAX: 000000000000001=
0
> > > RAX: ffffffffffffffda RBX: 00007ff1a25e5fa0 RCX: 00007ff1a238f7c9
> > > RDX: 0000200000000180 RSI: 00000000c0686611 RDI: 0000000000000004
> > > RBP: 00007ff1a2413f91 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > R13: 00007ff1a25e5fa0 R14: 00007ff1a25e5fa0 R15: 0000000000000003
> > >  </TASK>

