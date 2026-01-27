Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A9FD13C1B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C7C6B0088; Mon, 26 Jan 2026 21:22:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0116B0089; Mon, 26 Jan 2026 21:22:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093C16B008A; Mon, 26 Jan 2026 21:22:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E64696B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:22:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C36B160817
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:22:45 +0000 (UTC)
X-FDA: 84376145490.13.F1B17D5
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C52A100003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:22:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0DGbXcOF;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769480563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHSjF43OnNhZzIy1ezrcIZtPo8nY/C7yOJGwOUOyScY=;
	b=l0tcxZFIyUqQfI3Xwl/CTbyBx0n272Z7t4Sg74IDbpg5+GKEnx2A7pv7ZAsbTY5rRD8Xzo
	6+dxJ1zyZ3M4nZSC3uNIwc0byLnTnkuQeZn8dY+OyB1a0WN+9q3ppVCmcDP9IW2v8JwV8Y
	wZyICaoDB+tzs644rSP3V90nDlk0htg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0DGbXcOF;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769480563; a=rsa-sha256;
	cv=pass;
	b=a2BdTqw9YswXHArNmSNHdi9UDG4pfJxQ+3muqzzGFsglC92X5OVA7hvwyrF5iSTpWY9S2J
	dQG4S0wnB+M0peoXps6fEHKY44cct+O5HvOJ74I/EaLHjSNibASYUTtMtsQ/fP+oAsubxj
	6Wrl38FbZqPwtfCAHWDwGmWG6de6/y0=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-501511aa012so129101cf.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:22:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769480562; cv=none;
        d=google.com; s=arc-20240605;
        b=SU/02gXv6c4BDISICDBJPGtdfH9qheL6LdZz3eO0kj6sAWQPTfzKYYnRsGYKlIOtR/
         9DBYyrf9jHGtbYSuDiS6cNVlsLljBO5m9V9zhOHRK0t9uI7fox+/P1apNeCKGLrPO9Ms
         tGMqxPQOLlaepJz07uG4phUNz5W/JNuzwg53+DIgmYnwKQmaiq5AMM0dazgtmh5VJ9O1
         NQ2XEYtKW9xog2s/ZKlYNCqaDf/hHZit3y7aEjO5GqbY7DRvoNFaS924KstP+GgG9khn
         iDDtOLUL7Zprj/6kuLtzxLZK0oiEZ6kFW6hOP9WJYrfp3MeTJk4i9PbxehhD4LEulEnL
         Zj8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OHSjF43OnNhZzIy1ezrcIZtPo8nY/C7yOJGwOUOyScY=;
        fh=a//wfIHx+11bQb4YN8Tju+sS2w+fZEE+gvEkIdB5IqQ=;
        b=iKsIoJnultpDADUKYvHLrICOUBzPX3pmGrLDWo9auF3miSL+kw693bkbuE8HMDpVSR
         8RR6xuI+VsitHBD80UU8C7nbkh+Naxp16PY8Y1kqglkA2mT47794s+hmXHmdET13OlQE
         k8BHKdLeDXEvb6dYva3eglgwAV7E4jx++HuJm7dExRoV1tAmXs9b+R/WgQraPlWFer33
         wkaizCudb7KdjC6KDpxdZFXg5WALkC117U2zboylqYSk3uo0IfVgzCFpVCjoJDF7SRvw
         dAmBDJ4kRiu1DM1tYlFLJ6irC8dqWrTPfhk4DlN+LhJsycpBzPgBZY8rdOQgrh2nPNXl
         e/mw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769480562; x=1770085362; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHSjF43OnNhZzIy1ezrcIZtPo8nY/C7yOJGwOUOyScY=;
        b=0DGbXcOFUgtsbyUjgAdSnK2UGeR6alBu9cj+pLMkZwfdNnW6i1wyVRn/68MEKbbZa4
         rEpb9XCxfmic/FMyGS5LMvIfNCSzzUJLUG0chjAMtXSsujGmcyroAIQD5QBmShxxRZMr
         Otd9O4Agy5IFBI3JvBdnQyM/z880iyYl/aE/BVIZydh42m4d+oTJrYVzSIQBHYMwPHAR
         PNViI5s3HDs3nTT3JS2VbNLh88YhmOjuH7XiCpJYQK/flPy/9qtDFeBniBXPohvvDQbb
         B1D8Zheoua6GWfHBLLxTReB6ALyPd8a1bapLCEIUX6AjEx3sh/y/AYb3UZLLClaWFTOI
         pL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769480562; x=1770085362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OHSjF43OnNhZzIy1ezrcIZtPo8nY/C7yOJGwOUOyScY=;
        b=RRAYsK3nO9/PJZcrCnUtF1zTIopots3qHfEW9w9/NjN1TQ64fXsJerGd/NA9zFh167
         1OG4hINtPezmGA8TOGe/6G9LkkT0kDKnBP02UA41Yj6rCBAAA6/NaTDhrIj3pW4u3dUl
         P+jvU1JMrh4f6g4RpFCb4PH5HkIK1JL738jZExBIuh9SvBxEB1POpIbpCaNDeyrUJAFa
         ihGBrMIohCX3P3KPWWGKfKeENCNMMs5wyXveZxnJ+4M2B4auaXu1bYcRnpPDht2ET4i6
         L4gHmvf5nSqX9GjYUBF+yfp65xgSsNaWZCXy5bGoqyV67CCIuDTDaErt7q9bEQvVbKeV
         0SXA==
X-Forwarded-Encrypted: i=1; AJvYcCVZlQDFG9TJ3y2+F/38oJf3BrPmfKJmr7DgBM6QeSCzCxuZMS/79N9WLv7TJ16p0OIA9SzYkQNNvg==@kvack.org
X-Gm-Message-State: AOJu0YyiNhn9lcW5yfGnOHfYwYbmt3AIYpP3s1BxNSaDIiVPef8RpLDy
	4h/F0v2ypUsPdCBT7jgrUWgUGj7Jzjc/LaTNw0KFTHNpBKKO2IfjtvbpQ+shGwuNcPs2cXa+vhW
	iqKxX4LYjqAnMEQrFoSuYIASL7VetDT8T8vNCCJ9B
X-Gm-Gg: AZuq6aICVmkTqV4CPNu/c8EacnU0sGBipXEVLDnOeStmKNeK4rpIdqr0PfehsYGzugd
	MfORyZOp11mlCCKvINVDM6uMMNr5H/I8ZiKTYgt+v90stDNotwX0j0m4BKBOlSg1DW9GmGNfaUP
	6b58X7KLegihoUNzMCiF0WJEI6Yf58FKVokAEvv4bM3IPSpcGXCCU16UaJNjfxfr6O4fmBLUqSB
	mey2SZfKbxVyyBGVH6LTf6+o3//lsGcfC3FvWRYyw8gelLDChNU3El1I9bhYxBbko9A4g==
X-Received: by 2002:ac8:5801:0:b0:502:f07e:854c with SMTP id
 d75a77b69052e-5032f4543d7mr900961cf.6.1769480561647; Mon, 26 Jan 2026
 18:22:41 -0800 (PST)
MIME-Version: 1.0
References: <697400dc.a70a0220.35de72.000a.GAE@google.com> <20260124113148.2398-1-hdanton@sina.com>
 <CAJuCfpEcqAiK-z=EZ5im12F2wfGHYogiMHaTC4t5uopLmBKQPw@mail.gmail.com> <CAJuCfpEJUeQcpfbh-0KTsp1UdTs5yrKTbvAV6QOKdQHJZ2HWww@mail.gmail.com>
In-Reply-To: <CAJuCfpEJUeQcpfbh-0KTsp1UdTs5yrKTbvAV6QOKdQHJZ2HWww@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 26 Jan 2026 18:22:30 -0800
X-Gm-Features: AZwV_QhgBEFhB5JcSIaENdWQmwwSZMM99HLcmA66zN-PUgOjFXKx_NbR2gAH7bo
Message-ID: <CAJuCfpF_a=-kTZLdOzZpKrWhO2CyowwT+PdZ7_tP-cXxe23DiQ@mail.gmail.com>
Subject: Re: [syzbot] [block?] possible deadlock in blkdev_read_iter
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com>, axboe@kernel.dk, 
	linux-block@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5C52A100003
X-Stat-Signature: ft7kikw8bbtxt9tcgpynwtyyxzmyif8n
X-Rspam-User: 
X-HE-Tag: 1769480563-667448
X-HE-Meta: U2FsdGVkX1+kUxIErXNPcCXcbvqQrq9136o8hVwTVgqMDbytrI2W5Q/rgFA7nwu7Dlg6BFBsNVguTq9EO1w4NK9346ij+h1ux/+J0xOUZAgkM8My1RgoImS8lOAXlH3nG2klTHr+zPJFROKg8qvqkXG+HaefpsBgH2XzTX8q5kWgzCh31yqEXPWX49vlG7/yo+tGFg1VB+oH6l9/vGrPPFEKMSHrBTSlJ49TKHNU+Lk9BQ/F7awb2n4gnkcUFzx447yUiH2X7hwfPWZed1cZlGV8IasPjMEGreq2TaYjbr2R0CmotQ35ZK3Crt94A09a7jsL6KcTtGRoWw4DEeAYJi+oBAjlDFOCWx22z+qqXk/Awp5ebNDEzlf50LDg3VMkKUNpQ4oVujNsW0zXmGRaJO5fAcm1TlFuOjsxbWTFfzzwpxLRm9DoKQ4O4Yw4YKsIDa6Ce3QpzsugkbYC7J5Q0I/wMZbs4XB7H+P5EUZaejVPdRYOq9i0tIXTRyBwxaEpaAniAFpBFLk2OsMj9DHclV68Sbtl3v4Jp02rS5/KAlbIuoYjD1VsRyxMuw+Ex7QIpxSBp1BYin3AxrRZVCCvFbU0VQqjZiIKlJPZTpmvF54tlB+OdDTgp3E+XeIdBhR7AYAMnZg+JsMIP/RH37GnlJBebRHPiV39QIKZUBhn8H4v0SIZMzfuR/0VLUfa8KvKWtXJ0raarF6Q+WPS7kEkd03mE0HKfbdGEhKoM3tPhjFZLVGfmYhSo+GGdPrmU0aHMrxj0yrQUFGp1Aew/Esd2whYMdb+VeDQjJEVkO5XWPTPOQSe8FymPvLY35CMgNIYkCdbanB/L4m2zibfmaFv/bc6ZjKqY7/FyidzmOfMabk2PYrJ7LnhxDfj2a7s44nPAH/QALmi1FECdQP7//Viz1gfqm7nNRomfbmHmYsV0StuwO9TCnSozFCXnZwTdFfXBRR1fJ7VTEAICMyZ/At
 n3Dz+JVm
 9KsxA0/xNro/4bLxqa3n1Vxx1l4GkXELHKs4n7yqXTqJSJCvfpuGvMWATJC/5+6qM+QbpvrIANSfGQ5zRbnOjaLrIGfqyylQL9raaUr7Ij5Ax7e4VSvs6bqh0aUqqzpiwJdbO7bgV7iP80cSvKhqi7VlrwdlNtjH9spAhYLHqDQANcB8OjGS1iikjr6woYFLXg4f2jw4lCysNtJhFHJMIgDf40LB6wbzgre9gNhFZiyG4yk/U0K0n13oc8MK4PNZH4ftyKGQufhcqufDrrUf+hUEg+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 2:33=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Jan 26, 2026 at 9:20=E2=80=AFAM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Sat, Jan 24, 2026 at 3:32=E2=80=AFAM Hillf Danton <hdanton@sina.com>=
 wrote:
> > >
> > > Add Lorenzo and Suren
> >
> > Thanks!
> >
> > >
> > > > Date: Fri, 23 Jan 2026 15:14:36 -0800
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    24d479d26b25 Linux 6.19-rc6
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D100033f=
a580000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D1859476=
832863c41
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4e70c8e0a=
2017b432f7a
> > > > compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU =
Binutils for Debian) 2.40
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D11451=
b9a580000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1045e85=
2580000
> > > >
> > > > Downloadable assets:
> > > > disk image (non-bootable): https://storage.googleapis.com/syzbot-as=
sets/d900f083ada3/non_bootable_disk-24d479d2.raw.xz
> > > > vmlinux: https://storage.googleapis.com/syzbot-assets/d0f3c47f6869/=
vmlinux-24d479d2.xz
> > > > kernel image: https://storage.googleapis.com/syzbot-assets/80023151=
3703/bzImage-24d479d2.xz
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to th=
e commit:
> > > > Reported-by: syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
> > > >
> > > > WARNING: possible circular locking dependency detected
> > > > syzkaller #0 Not tainted
> > > > ------------------------------------------------------
> > > > syz.0.17/6091 is trying to acquire lock:
> > > > ffff8881061287a8 (
> > > > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: inode_lock_shared incl=
ude/linux/fs.h:1042 [inline]
> > > > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: blkdev_read_iter+0x19e=
/0x500 block/fops.c:855
> > > >
> > > > but task is already holding lock:
> > > > ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x10e/0xe=
d0 mm/mmap_lock.c:334
> > > >
> > > > which lock already depends on the new lock.
> > > >
> > > >
> > > > the existing dependency chain (in reverse order) is:
> > > >
> > > > -> #2 (vm_lock){++++}-{0:0}:
> > > >        __vma_enter_locked+0x260/0x770 mm/mmap_lock.c:72
> > > >        __vma_start_write+0x21/0x160 mm/mmap_lock.c:104
> > > >        vma_start_write include/linux/mmap_lock.h:213 [inline]
> > > >        mprotect_fixup+0x4e3/0xb80 mm/mprotect.c:768
> > > >        setup_arg_pages+0x4a2/0xbb0 fs/exec.c:670
> > > >        load_elf_binary+0xb5b/0x4fe0 fs/binfmt_elf.c:1028
> > > >        search_binary_handler fs/exec.c:1669 [inline]
> > > >        exec_binprm fs/exec.c:1701 [inline]
> > > >        bprm_execve fs/exec.c:1753 [inline]
> > > >        bprm_execve+0x8c2/0x1620 fs/exec.c:1729
> > > >        kernel_execve+0x2ef/0x3b0 fs/exec.c:1919
> > > >        try_to_run_init_process init/main.c:1506 [inline]
> > > >        kernel_init+0x14a/0x2b0 init/main.c:1634
> > > >        ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
> > > >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> > > >
> > > > -> #1 (&mm->mmap_lock){++++}-{4:4}:
> > > >        __might_fault mm/memory.c:7174 [inline]
> > > >        __might_fault+0x113/0x190 mm/memory.c:7168
> > > >        _copy_to_iter+0x1c2/0x1710 lib/iov_iter.c:196
> > > >        copy_page_to_iter lib/iov_iter.c:374 [inline]
> > > >        copy_page_to_iter+0x12a/0x1e0 lib/iov_iter.c:361
> > > >        copy_folio_to_iter include/linux/uio.h:204 [inline]
> > > >        filemap_read+0x6b1/0xe40 mm/filemap.c:2851
> > > >        blkdev_read_iter+0x1ac/0x500 block/fops.c:856
> > > >        new_sync_read fs/read_write.c:491 [inline]
> > > >        vfs_read+0x8bf/0xcf0 fs/read_write.c:572
> > > >        ksys_read+0x12a/0x250 fs/read_write.c:715
> > > >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > > >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > >
> > > > -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
> > > >        check_prev_add kernel/locking/lockdep.c:3165 [inline]
> > > >        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> > > >        validate_chain kernel/locking/lockdep.c:3908 [inline]
> > > >        __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
> > > >        lock_acquire kernel/locking/lockdep.c:5868 [inline]
> > > >        lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> > > >        down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> > > >        inode_lock_shared include/linux/fs.h:1042 [inline]
> > > >        blkdev_read_iter+0x19e/0x500 block/fops.c:855
> > > >        __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> > > >        freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> > > >        __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> > > >        do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> > > >        procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> > > >        vfs_ioctl fs/ioctl.c:51 [inline]
> > > >        __do_sys_ioctl fs/ioctl.c:597 [inline]
> > > >        __se_sys_ioctl fs/ioctl.c:583 [inline]
> > > >        __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> > > >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > > >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > >
> >
> > It looks like:
> > #0 is executing PROCMAP_QUERY ioclt, read-locks vm_lock and then calls
> > build_id_parse()->__build_id_parse(...,
> > may_fault=3Dtrue)->__kernel_read() which eventually takes
> > inode->i_rwsem.
> > #1 is a file-backed page fault which asserts that it might take
> > mmap_lock for read.
> > #2 is load_elf_binary()->mprotect_fixup() which write-locks both
> > mmap_lock and vm_lock. I'm guessing it already holds inode->i_rwsem
> > before write-locking these locks.
> >
> > Originally I thought the issue is most liley introduced in
> > d9d1c2d81797 ("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under
> > per-vma locks"). But if #2 indeed takes inode->i_rwsem before
> > write-locking mmap_lock, then the problem should exist even before
> > that change when we didn't use vm_lock and relied on mmap_lock...
> >
> > I'll try to analyze this more before attempting a fix.
>
> I was able to reproduce the same issue even after reverting
> d9d1c2d81797. The deadlock in this case is simpler and involves
> mmap_lock instead of vm_lock (see below).
> Looks like the race is between the read() syscall and do_procmap_query().
> I'll continue investigating, in the meantime CC'ing Andrii.

So, here is a cleaner version of that report (with d9d1c2d81797 reverted):

 -> #1 (&mm->mmap_lock){++++}-{4:4}:
        __might_fault+0xed/0x170
        _copy_to_iter+0x118/0x1720
        copy_page_to_iter+0x12d/0x1e0
        filemap_read+0x720/0x10a0
        blkdev_read_iter+0x2b5/0x4e0
        vfs_read+0x7f4/0xae0
        ksys_read+0x12a/0x250
        do_syscall_64+0xcb/0xf80
        entry_SYSCALL_64_after_hwframe+0x77/0x7f

 -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
        __lock_acquire+0x1509/0x26d0
        lock_acquire+0x185/0x340
        down_read+0x98/0x490
        blkdev_read_iter+0x2a7/0x4e0
        __kernel_read+0x39a/0xa90
        freader_fetch+0x1d5/0xa80
        __build_id_parse.isra.0+0xea/0x6a0
        do_procmap_query+0xd75/0x1050
        procfs_procmap_ioctl+0x7a/0xb0
        __x64_sys_ioctl+0x18e/0x210
        do_syscall_64+0xcb/0xf80
        entry_SYSCALL_64_after_hwframe+0x77/0x7f

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   rlock(&mm->mmap_lock);
                                lock(&sb->s_type->i_mutex_key#8);
                                lock(&mm->mmap_lock);
   rlock(&sb->s_type->i_mutex_key#8);

  *** DEADLOCK ***

Both threads are calling blkdev_read_iter(), which uses
inode_lock_shared() to read-lock inode->i_rwsem. I'm not sure why CPU1
shows lock() instead of rlock(). So both threads read-lock
inode->i_rwsem and mmap_lock but in a different order. IIUC, with
read-locks this should not deadlock until some other thread
write-locks the mmap_lock in between and this becomes a real deadlock:

        CPU0       CPU1         CPU2
        ----       ----         ----
   rlock(&mm->mmap_lock);
                                rlock(&sb->s_type->i_mutex_key#8);
                   wlock(&mm->mmap_lock) <-- waiting for CPU0
                                rlock(&mm->mmap_lock); <-- waiting for CPU1
   rlock(&sb->s_type->i_mutex_key#8); <-- waiting for CPU2

I believe in the original report this write-locking thread was the one
calling mprotect_fixup().

Per https://docs.kernel.org/mm/process_addrs.html#lock-ordering,
inode->i_rwsem should be locked before mm->mmap_lock, so
procfs_procmap_ioctl() has to be fixed to follow this lock ordering.
One possibility I can think of is to use build_id_parse_nofault()
first and if it fails because the required page is not faulted, we do
freader_init_from_file(), then drop the mmap/vma lock and execute
freader_fetch() outside of these locks to fault in that page. Once
that's done, we'll retry the whole operation and this time
build_id_parse_nofault() should pass (unless we already evicted that
page, which is extremely unlikely and in that case, we'll retry
again).

I tried a POC with build_id_parse_nofault() but without the whole
dance with freader_init_from_file/freader_fetch and the deadlock is
gone. Andrii, WDYT?

>
> [   62.320932][ T9229]
> [   62.321471][ T9229] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   62.323016][ T9229] WARNING: possible circular locking dependency dete=
cted
> [   62.324618][ T9229] 6.19.0-rc6-00001-g40bea6261b2a #42 Not tainted
> [   62.326013][ T9229] --------------------------------------------------=
----
> [   62.327560][ T9229] hillf/9229 is trying to acquire lock:
> [   62.328821][ T9229] ffff888145b7b5a8
> (&sb->s_type->i_mutex_key#8){++++}-{4:4}, at:
> blkdev_read_iter+0x2a7/0x4e0
> [   62.331102][ T9229]
> [   62.331102][ T9229] but task is already holding lock:
> [   62.332722][ T9229] ffff888183a6e540 (&mm->mmap_lock){++++}-{4:4},
> at: do_procmap_query+0x39f/0x1050
> [   62.334795][ T9229]
> [   62.334795][ T9229] which lock already depends on the new lock.
> [   62.334795][ T9229]
> [   62.337072][ T9229]
> [   62.337072][ T9229] the existing dependency chain (in reverse order) i=
s:
> [   62.338998][ T9229]
> [   62.338998][ T9229] -> #1 (&mm->mmap_lock){++++}-{4:4}:
> [   62.340646][ T9229]        __might_fault+0xed/0x170
> [   62.341763][ T9229]        _copy_to_iter+0x118/0x1720
> [   62.342913][ T9229]        copy_page_to_iter+0x12d/0x1e0
> [   62.344167][ T9229]        filemap_read+0x720/0x10a0
> [   62.345298][ T9229]        blkdev_read_iter+0x2b5/0x4e0
> [   62.346480][ T9229]        vfs_read+0x7f4/0xae0
> [   62.347518][ T9229]        ksys_read+0x12a/0x250
> [   62.348584][ T9229]        do_syscall_64+0xcb/0xf80
> [   62.349707][ T9229]        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   62.351116][ T9229]
> [   62.351116][ T9229] -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
> [   62.353012][ T9229]        __lock_acquire+0x1509/0x26d0
> [   62.354213][ T9229]        lock_acquire+0x185/0x340
> [   62.355323][ T9229]        down_read+0x98/0x490
> [   62.356441][ T9229]        blkdev_read_iter+0x2a7/0x4e0
> [   62.357619][ T9229]        __kernel_read+0x39a/0xa90
> [   62.358767][ T9229]        freader_fetch+0x1d5/0xa80
> [   62.359927][ T9229]        __build_id_parse.isra.0+0xea/0x6a0
> [   62.361232][ T9229]        do_procmap_query+0xd75/0x1050
> [   62.362434][ T9229]        procfs_procmap_ioctl+0x7a/0xb0
> [   62.363687][ T9229]        __x64_sys_ioctl+0x18e/0x210
> [   62.364863][ T9229]        do_syscall_64+0xcb/0xf80
> [   62.365977][ T9229]        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   62.367394][ T9229]
> [   62.367394][ T9229] other info that might help us debug this:
> [   62.367394][ T9229]
> [   62.369637][ T9229]  Possible unsafe locking scenario:
> [   62.369637][ T9229]
> [   62.371237][ T9229]        CPU0                    CPU1
> [   62.372441][ T9229]        ----                    ----
> [   62.373687][ T9229]   rlock(&mm->mmap_lock);
> [   62.374688][ T9229]
> lock(&sb->s_type->i_mutex_key#8);
> [   62.376444][ T9229]                                lock(&mm->mmap_lock=
);
> [   62.377956][ T9229]   rlock(&sb->s_type->i_mutex_key#8);
> [   62.379165][ T9229]
> [   62.379165][ T9229]  *** DEADLOCK ***
> [   62.379165][ T9229]
> [   62.380952][ T9229] 1 lock held by hillf/9229:
> [   62.381971][ T9229]  #0: ffff888183a6e540
> (&mm->mmap_lock){++++}-{4:4}, at: do_procmap_query+0x39f/0x1050
> [   62.384162][ T9229]
> [   62.384162][ T9229] stack backtrace:
> [   62.385458][ T9229] CPU: 3 UID: 0 PID: 9229 Comm: hillf Not tainted
> 6.19.0-rc6-00001-g40bea6261b2a #42 PREEMPT(full)
> [   62.385471][ T9229] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> [   62.385477][ T9229] Call Trace:
> [   62.385482][ T9229]  <TASK>
> [   62.385487][ T9229]  dump_stack_lvl+0x100/0x190
> [   62.385505][ T9229]  print_circular_bug.cold+0x185/0x1d5
> [   62.385521][ T9229]  check_noncircular+0x14a/0x170
> [   62.385534][ T9229]  __lock_acquire+0x1509/0x26d0
> [   62.385547][ T9229]  lock_acquire+0x185/0x340
> [   62.385557][ T9229]  ? blkdev_read_iter+0x2a7/0x4e0
> [   62.385569][ T9229]  ? __pfx___might_resched+0x10/0x10
> [   62.385583][ T9229]  down_read+0x98/0x490
> [   62.385593][ T9229]  ? blkdev_read_iter+0x2a7/0x4e0
> [   62.385603][ T9229]  ? __pfx_down_read+0x10/0x10
> [   62.385612][ T9229]  ? lock_acquire+0x185/0x340
> [   62.385622][ T9229]  ? is_bpf_text_address+0x25/0x1a0
> [   62.385634][ T9229]  blkdev_read_iter+0x2a7/0x4e0
> [   62.385645][ T9229]  __kernel_read+0x39a/0xa90
> [   62.385658][ T9229]  ? __pfx___kernel_read+0x10/0x10
> [   62.385671][ T9229]  ? __lock_acquire+0x481/0x26d0
> [   62.385683][ T9229]  freader_fetch+0x1d5/0xa80
> [   62.385697][ T9229]  ? find_held_lock+0x2b/0x80
> [   62.385712][ T9229]  ? __pfx_freader_fetch+0x10/0x10
> [   62.385725][ T9229]  ? __asan_memset+0x27/0x50
> [   62.385737][ T9229]  __build_id_parse.isra.0+0xea/0x6a0
> [   62.385751][ T9229]  ? __pfx___build_id_parse.isra.0+0x10/0x10
> [   62.385766][ T9229]  ? __pfx_find_vma+0x10/0x10
> [   62.385774][ T9229]  ? __might_fault+0x129/0x170
> [   62.385788][ T9229]  do_procmap_query+0xd75/0x1050
> [   62.385798][ T9229]  ? __pfx_do_procmap_query+0x10/0x10
> [   62.385807][ T9229]  ? __sanitizer_cov_trace_switch+0x53/0x90
> [   62.385817][ T9229]  ? do_vfs_ioctl+0x226/0x13b0
> [   62.385828][ T9229]  ? __pfx_do_vfs_ioctl+0x10/0x10
> [   62.385839][ T9229]  ? putname+0xfc/0x1b0
> [   62.385846][ T9229]  ? putname+0x101/0x1b0
> [   62.385857][ T9229]  ? __x64_sys_openat+0x143/0x210
> [   62.385867][ T9229]  procfs_procmap_ioctl+0x7a/0xb0
> [   62.385877][ T9229]  ? __pfx_procfs_procmap_ioctl+0x10/0x10
> [   62.385888][ T9229]  __x64_sys_ioctl+0x18e/0x210
> [   62.385899][ T9229]  do_syscall_64+0xcb/0xf80
> [   62.385913][ T9229]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   62.385923][ T9229] RIP: 0033:0x412209
> [   62.385931][ T9229] Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f
> 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
> 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8
> 64 89 01 48
> [   62.385940][ T9229] RSP: 002b:00007fff380d5588 EFLAGS: 00000217
> ORIG_RAX: 0000000000000010
> [   62.385950][ T9229] RAX: ffffffffffffffda RBX: 00007fff380d56c8
> RCX: 0000000000412209
> [   62.385956][ T9229] RDX: 0000200000000180 RSI: 00000000c0686611
> RDI: 0000000000000004
> [   62.385962][ T9229] RBP: 00007fff380d55a0 R08: 0000000000000000
> R09: 00007fff380d5640
> [   62.385968][ T9229] R10: 0000000000000000 R11: 0000000000000217
> R12: 00007fff380d56b8
> [   62.385974][ T9229] R13: 0000000000000002 R14: 00000000004a0e40
> R15: 0000000000000002
> [   62.385982][ T9229]  </TASK>
>
>
>
> >
> > > > other info that might help us debug this:
> > > >
> > > > Chain exists of:
> > > >   &sb->s_type->i_mutex_key#8 --> &mm->mmap_lock --> vm_lock
> > > >
> > > >  Possible unsafe locking scenario:
> > > >
> > > >        CPU0                    CPU1
> > > >        ----                    ----
> > > >   rlock(vm_lock);
> > > >                                lock(&mm->mmap_lock);
> > > >                                lock(vm_lock);
> > > >   rlock(&sb->s_type->i_mutex_key#8);
> > > >
> > > >  *** DEADLOCK ***
> > > >
> > > > 1 lock held by syz.0.17/6091:
> > > >  #0: ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x10=
e/0xed0 mm/mmap_lock.c:334
> > > >
> > > > stack backtrace:
> > > > CPU: 2 UID: 0 PID: 6091 Comm: syz.0.17 Not tainted syzkaller #0 PRE=
EMPT(full)
> > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-deb=
ian-1.16.3-2~bpo12+1 04/01/2014
> > > > Call Trace:
> > > >  <TASK>
> > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > >  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
> > > >  print_circular_bug+0x275/0x340 kernel/locking/lockdep.c:2043
> > > >  check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
> > > >  check_prev_add kernel/locking/lockdep.c:3165 [inline]
> > > >  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> > > >  validate_chain kernel/locking/lockdep.c:3908 [inline]
> > > >  __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
> > > >  lock_acquire kernel/locking/lockdep.c:5868 [inline]
> > > >  lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> > > >  down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> > > >  inode_lock_shared include/linux/fs.h:1042 [inline]
> > > >  blkdev_read_iter+0x19e/0x500 block/fops.c:855
> > > >  __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> > > >  freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> > > >  __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> > > >  do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> > > >  procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> > > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > > >  __se_sys_ioctl fs/ioctl.c:583 [inline]
> > > >  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> > > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > >  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > RIP: 0033:0x7ff1a238f7c9
> > > > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 4=
8 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01=
 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > > > RSP: 002b:00007ffebbe538b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000=
010
> > > > RAX: ffffffffffffffda RBX: 00007ff1a25e5fa0 RCX: 00007ff1a238f7c9
> > > > RDX: 0000200000000180 RSI: 00000000c0686611 RDI: 0000000000000004
> > > > RBP: 00007ff1a2413f91 R08: 0000000000000000 R09: 0000000000000000
> > > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > > R13: 00007ff1a25e5fa0 R14: 00007ff1a25e5fa0 R15: 0000000000000003
> > > >  </TASK>

