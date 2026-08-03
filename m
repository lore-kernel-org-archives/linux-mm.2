Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99B0C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 22:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87D16B007B; Mon,  3 Aug 2026 18:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38836B0088; Mon,  3 Aug 2026 18:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D005D6B008A; Mon,  3 Aug 2026 18:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92C2D6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:48:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 148BCA22D8
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:48:43 +0000 (UTC)
X-FDA: 85061449326.05.2F1F44F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 14FDA4000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:48:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcSyEC2V;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785797321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAIfynDU5M3n70OfcSMdJeSVh5VujgTdPZ8VZgKd/3E=;
	b=d6uvzPMcYLVFrImbdUxh0HrznxudusvdZBe+eIWp7LFyEjyeqrdb/6GowZSpKaEKYK+08y
	cQOr/OKQ2YbflNnGfn+vYcwqzrlAMpPLshN2T1CI4je/nkYVqDPl6NkrQzwru8v9LXYeES
	+4yuMY2LN4zvOuWn6+OoHM07y13CJQk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcSyEC2V;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785797321;
	b=KTSogEw7xoEV5H5e9aSxq34Xxra1XnvUXNW8/ocM6AuhviQCsDEH6xzsr26RBwBLRSEfqn
	6wEQmjHXp9n/QaXOuLNpnv0V3qJMsOhJV/4ntIR1mnAQ8m1okvv+CB+hy2sOirP7192Oa5
	/9kfnoNQoliKF45HA9og8BP4DDfRqz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2896042A37
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9541F000E9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785797320;
	bh=ZAIfynDU5M3n70OfcSMdJeSVh5VujgTdPZ8VZgKd/3E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HcSyEC2VG4eFVIWhSKQQGwlWOtRY7cRoEMlttQ04+6wBfWzgNZSflNXn8DGlj9GjI
	 Yr2vRwMSXnjNePj4wwczr15Bp+Fl7u9A/kcjMcwZJiiuZsybTypiMWYT8W4WRfwjBK
	 MvNANH8TUCLLgYg1LM8sMw7k9PxGP7K68fVn+8bpn4Lk0P4jcaCqRrDu4FiiIDrlVG
	 j01A49Ld2kg4xK6Kr36U5cC2mAUUkXJiAPjOkRZh/5KMVAZoyzK9ZdPDGK7Roocv4e
	 s6+HPT/UBxDq83oxvHNT6rQFzF4Sgm+PNBVx4Ss9XOWicbpgF74bAvug1B2d/Xo6ly
	 1hhmMq4V9jAzQ==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e602d2c0fso28093185a.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 15:48:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrv7wuLkaleJwCZSpkAIX13nMpOKH9NYfHuAOKuFjd/C0BIiiIPTvMuN0Gw2NlJZREV0zDT0bQWpQ==@kvack.org
X-Gm-Message-State: AOJu0YySjVeC5pd+8qvdkmQkOIwCeqElZh0cJ2eUDhPvNe5AvAvrOBtr
	OseGEsTqTADJKmYtruo/3LJB1ksu8Msvvsf1+BBlNwJ4QlGnDCySXvHNhAUK9Fzcu+n7CVqlDMn
	rRPeTgeFJRNZGQi6BRu311uqqrfO95dE=
X-Received: by 2002:a05:620a:1647:b0:92e:551d:f1a3 with SMTP id
 af79cd13be357-93631855f7fmr230832585a.8.1785797319405; Mon, 03 Aug 2026
 15:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <alG_1bhH5aqQCNEh@casper.infradead.org> <20260712132759.2030823-1-zhanghongru@xiaomi.com>
In-Reply-To: <20260712132759.2030823-1-zhanghongru@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 4 Aug 2026 06:48:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x3HiRP7QU=N-oPiWuxuTG1VvzCCdHPqr3Trdk_8WMUGw@mail.gmail.com>
X-Gm-Features: AUfX_mxt21q1lY7MgtJoykb0bDaIL6OumFi77U2eocAFVDBg1jwnCIrRPv26yn4
Message-ID: <CAGsJ_4x3HiRP7QU=N-oPiWuxuTG1VvzCCdHPqr3Trdk_8WMUGw@mail.gmail.com>
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when
 mmap_lock is not required
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, david@kernel.org, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	surenb@google.com, vbabka@kernel.org, zhanghongru@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 14FDA4000B
X-Stat-Signature: xocjpc1a6u3yugoanug8bqjo4tdzi1h8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785797320-791667
X-HE-Meta: U2FsdGVkX1+ecy/f7p3xZgyeKFW+mYEM4lLRx02iapAZ9S5VEdfe/HvoN9SZr8yJQDYQRbkRvpBcMG6ChXVKAT9mGCqsvYgZc8aMRAoyBafJ/egrEr0/A9b0+r3htZWWcY5nrGsx3XMHFf/500Ri16reLqpvWMYa5ammB+ALlXwjHeynkORXa8HdRLnikzcnWZBqUAwnCyYOh4k6Uz4FGlYNZ5kqUjP0N6gWqeITmEPG85Y2tQWD3le27jPqZJkHcATLCtdlw8WKVqvV1Uf94OAACBpL4sXDI2FuAs7U4gD3Ma+VFiTmSsg6Ajd4WBBAIkP3QXFft+Maj7FsdTBzSoQu7WGeTY49yVEGpIWZ2sjKtJsGhnuCJv6vc9BGn9TBz2l4AFHd4VC911fOCy85AwQvmqayqxGNe2uKSksTMT14dtqc1cNZUS0lxptaJ14nHVOWu1lWaTqH5SHsrNessFyIcLP4y9il1CfUlbMlF2DBsSM5HINRom6bRJBA+H72XqRQgqVO5qnt+TlIM03yr0jDWbbVZKooDuMGNGtIhsCc3dgpFwnPXzuZrUaESOMxWiqg4hN4un2zJIkKgQTJlfCh1CvMMWp6Wj+FyhWjC9Qs1sVrIz0TBHDZDPB+iJh5sa+lpSEmtBXlH7O/+68gO/2tPU/pxjBevsn+2YoyVBEFhzkOgBtCE41YXe5FCEnoGICsA/BS4G2dN2JaIdZ6p7evQzgSiNx10zTCz1vLW358lkHCzO1RJ3mst5PtEiE6+WF+NJjoOi+/+0Jn4yxUltfOdCMHVkeJAh5bwzTJwn39w5ScKndfmIEEZ2aRP7M11ylY9PGFpspzNRZFv1eMYr7Osgxtged0buCMpm76zcIaOSBk2o/cnJOagxhbg4fq6L7+agvQOVeXyNM2bLd00aoZ3QIvX/T2x+Jx+MRw8pn9xLRhPy24d1nUHoDeSDLlTjSFPRCBBq58hi5Z3Nz
 9bJH6H8F
 Sl/r+pu3fmDU1e7ldEoMskcTzCqaF5xjc8ZiA6oVzbxyArRp3ouEGXmbUhH2jEHKHBuAzCWlYOD4ocJTWCw+e8DlrgNRzvAsQOnSXLlOqQ8o0TNPhX+DMPBo3QOB/+hyRRJme0eJifU2psOH6eYTD4WIGG/Cm3dCz7fwwWZ2KHpZJ8RfIdlNz9A/3Ihb2WZ8oR/uv0sWegOGdL/GWtvcKGbWOqUe5x9VAaLDtw1ufshrIf8yOnwexaZtn3cuy1zvUqKtJhfcdNq+boK/YUpCvi4MJovFkmhlUdTlFlAuvuNRnRf6hwVaQreFXEq3m36D8FQzxtpVGSF/qQDLJvCXEGClcjzLnA5a8NgKZdqT0cTj2HYOPiXTG8/FTIo8buALSLo5iY+zTNqumKVDtBr8Fv+TaBESCV2E8SaX4XV7dA/m0zpIQFRwTUYo4oqss2ESpJHSFFGmhP9ftkDkatgch18izJOimFx1PSUHNvwvxE+177S4D87hoBArhIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 9:28=E2=80=AFPM Hongru Zhang <zhanghongru06@gmail.c=
om> wrote:
>
> > On Tue, Jul 07, 2026 at 05:52:31PM +0100, Lorenzo Stoakes wrote:
> > > +cc Vlata, the only one from the MEMORY MAPPING - LOCKING people excl=
uded,
> > > and Willy as he's been heavily involved. But see below you need to cc=
- way
> > > more.
> >
> > Ugh, I hadn't seen this.
> >
> > No.
> >
> > I've been looking into this problem, and as usual it has turned into a
> > yak-shaving exercise.  I think I'm five yaks deep at this point:
> >
> >  - Need to start by simplifying filemap_fault
> >    https://lore.kernel.org/linux-mm/20260625195040.2508362-1-willy@infr=
adead.org/
>
> Hi Matthew,
>
> Thanks for looking at this.
>
> I understand your concern about adding more complexity to an already
> complicated fault path.
>
> However, I tested the RFC patch [1] on Android workloads and observed
> lock-wait regressions. The common pattern is that filemap_fault() can per=
form
> file-backed I/O while holding either mmap_lock or a per-VMA lock. The tra=
ces
> show three representative classes of lock-wait regressions: GUP faults,
> kernel uaccess faults, and per-VMA-lock faults blocking fork / copy_mm().
>
> 1) GUP faults under mmap_lock
>
>   APP: com.xs.fm.lite
>   lock type: mmap_lock
>   holder: Thread-77
>   faulted file: libbytehook.so
>   lock-held filemap fault time: 95.606ms
>   blocked writer: NetDownload#15 (blocked 218.971ms)
>
>   Holder stack:
>     filemap_fault+0x0
>     __do_fault+0xdc
>     do_pte_missing+0x2c8
>     handle_mm_fault+0x4c8
>     __get_user_pages+0x618
>     __gup_longterm_locked+0xac
>     pin_user_pages_remote+0x88
>     process_vm_rw+0x2cc
>     __arm64_sys_process_vm_readv+0x28
>     invoke_syscall+0x58
>     el0_svc_common+0x80
>     do_el0_svc+0x1c
>     el0_svc+0x48
>     el0t_64_sync_handler+0x70
>     el0t_64_sync+0x1bc
>
>   Blocked writer stack:
>     vm_mmap_pgoff+0x168
>     ksys_mmap_pgoff+0xa4
>     __arm64_sys_mmap+0x34
>     invoke_syscall+0x58
>     el0_svc_common+0x80
>     do_el0_svc+0x1c
>     el0_svc+0x48
>     el0t_64_sync_handler+0x70
>     el0t_64_sync+0x1bc
>
> 2) kernel uaccess faults under mmap_lock
>
>   APP: com.xingin.xhs
>   lock type: mmap_lock
>   holder: Thread-2531
>   faulted file: libtiny.so
>   lock-held filemap fault time: 172.375ms
>   blocked writer count: 5
>   writer wait range: 152.766ms - 172.006ms
>   representative blocked writer: com.xingin.xhs (main thread, blocked 172=
.006ms)
>
>   Holder stack:
>     filemap_fault+0x0
>     __do_fault+0xdc
>     do_pte_missing+0x2c8
>     handle_mm_fault+0x4c8
>     do_page_fault+0x39c
>     do_translation_fault+0x4c
>     do_mem_abort+0x54
>     el1_abort+0x3c
>     el1h_64_sync_handler+0x80
>     el1h_64_sync+0x7c
>     __arch_copy_from_user+0x1b4
>     copy_page_from_iter+0xd0
>     pipe_write+0x1ec
>     vfs_write+0x368
>     ksys_write+0x78
>     __arm64_sys_write+0x1c
>     invoke_syscall+0x58
>     el0_svc_common+0x80
>     do_el0_svc+0x1c
>     el0_svc+0x48
>     el0t_64_sync_handler+0x70
>     el0t_64_sync+0x1bc
>
>   Blocked writer stack:
>     vm_mmap_pgoff+0x168
>     ksys_mmap_pgoff+0xa4
>     __arm64_sys_mmap+0x34
>     invoke_syscall+0x58
>     el0_svc_common+0x80
>     do_el0_svc+0x1c
>     el0_svc+0x48
>     el0t_64_sync_handler+0x70
>     el0t_64_sync+0x1bc
>
> 3) filemap faults under per-VMA lock blocking fork / copy_mm()
>
> Other testing also reported similar per-VMA-lock blocking data [2], where
> filemap faults under a VMA read lock can block fork / copy_mm(). One exam=
ple
> from my trace is:
>
>   APP: com.xingin.xhs
>   lock type: per-VMA lock
>   holder: xylog_thread_po
>   faulted file: 2026-07-07-11-51-46.203.log
>   lock-held filemap fault time: 10.518ms
>   blocked writer: com.xingin.xhs (blocked 1.583ms)
>
>   Holder stack:
>     filemap_fault+0x0
>     __do_fault+0xdc
>     do_pte_missing+0x2c8
>     handle_mm_fault+0x4c8
>     do_page_fault+0x30c
>     do_translation_fault+0x4c
>     do_mem_abort+0x54
>     el0_da+0x54
>     el0t_64_sync_handler+0x50
>     el0t_64_sync+0x1bc
>
>   Blocked writer stack:
>     copy_mm+0x2a4
>     copy_process+0x4ec
>     kernel_clone+0xb0
>     __arm64_sys_clone+0x60
>     invoke_syscall+0x58
>     el0_svc_common+0x80
>     do_el0_svc+0x1c
>     el0_svc+0x48
>     el0t_64_sync_handler+0x70
>     el0t_64_sync+0x1bc
>

Thanks, Hongru. It seems these stacks clearly expose paths such as
GUP and copy_from/to_user() where I/O may be performed after
Matthew's approach is adopted.

I am putting together a list of paths that would perform I/O under
mmap_lock, along with possible ways to address them.

Performing I/O while holding mmap_lock may result in unpredictable
and potentially long mmap_lock hold times, so we need to address
these issues at least.

1. GUP doesn't support vma lock

Maybe this can be addressed by Rik van Riel's patchset? I haven't
looked into it in detail yet, so I'm not entirely sure.

mm: use per-VMA lock in __access_remote_vm for improved monitoring reliabil=
ity

https://lore.kernel.org/linux-mm/20260724222934.1463812-1-riel@surriel.com/

2. copy_from/to_user doesn't support vma lock

Maybe this can be addressed by the topic currently under
discussion?

mm: use VMA lock for kernel faults on user addresses

https://lore.kernel.org/linux-mm/20260802074018.73887-1-baohua@kernel.org/

3. first PF before retry might have been mmap_lock:

Maybe this can be addressed by `vma_start_read_unlocked()`, as we
discussed here:

mm: Unconditional per-VMA locks and cleanups

https://lore.kernel.org/linux-mm/CAJuCfpEF6SjKhRW33AuboAuUbQz5zv+QKr2eD=3D5=
2Qd_POL18Kg@mail.gmail.com/

4. The last one is the fork regression, which is unrelated to
I/O under mmap_lock.

- No approach yet. Perhaps Android could enforce some rules to
  prevent apps from calling fork() in the future?

Thanks
Barry

