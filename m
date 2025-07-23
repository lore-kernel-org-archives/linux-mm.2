Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2678C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 16:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B0E6B0157; Wed, 23 Jul 2025 12:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201BA6B0158; Wed, 23 Jul 2025 12:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118446B0159; Wed, 23 Jul 2025 12:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F12B36B0157
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 12:27:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6391E12D99B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:27:35 +0000 (UTC)
X-FDA: 83696060070.17.C756DE4
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 797C240007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:27:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MHdjXSxP;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753288052; a=rsa-sha256;
	cv=none;
	b=tfMAUf6Sml4FnwpQNqiJ8vM+kEOjphBgJdVmTsvx1VjCpwzC08lY7V5FMuemku+2xyN03H
	r2aQU/JN/dqKdW8WevMCW6Rz/druXiUbs5JPD/Dwrs5Q9ZDm38DcV2WGte2vpuFHLqgEBD
	7oQVrYjOxyrJ5+UfhXE3Y5OqwoIibwc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MHdjXSxP;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753288052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/YDbRx+5g9/YOV/bQuHC7tCIMhHWVM6ee0gV/FmYVKA=;
	b=U/j9vK3yuASn8l9dtF0NjS4/JQaxF8WFZLpNT75eZX9OM6nFQM7oIvG9CC5G3FxqU2ngFr
	06nXTsEkaDSZ3PyPWuu7EQ0kgUb7I0ICXM57MH6sDLKFKwxS+NdGuEd9NDwChN33r8JPx0
	hDbSPGHF8dmJpUfHXPx5CpBBmocoJRw=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso13442a12.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753288051; x=1753892851; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/YDbRx+5g9/YOV/bQuHC7tCIMhHWVM6ee0gV/FmYVKA=;
        b=MHdjXSxP6QUBdfTSKjNYcQcGxuJUDcDWtD9UwEpY9JIvLhhMAxYJqsWPOf50C9XkM2
         tP4I5Y6yJnYVhhYzFm6hH9QG/Zrg5sUmEJ3d176AX6pRuKAj7g9vDr7XzwqC1o5pPB3R
         bz9kXrffTgBCnVrvz60FNP+1T3BaJ+RpPwYMU8nuMJ9gA5p3ORYvm+NtxEdt90acPXKL
         DL6btOz209jGJePIOlZgGZaJeKbHoglDQF3Ot8Inu8C3a+ofbgiqlpBlHk1QHfUEKNZh
         l/Z6sRvzXqyNZmBEt6T16BD10XuCdlNiWo+tipUpgvfiitLhMFyZ98Vz4GBCeY+PCajS
         g7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753288051; x=1753892851;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/YDbRx+5g9/YOV/bQuHC7tCIMhHWVM6ee0gV/FmYVKA=;
        b=q86E8OOcXz/t8xFJDCzocUIavwwRp16qhfrj+L4W89PilWX0t8oEGmGAwbw2AS5IE3
         CCKxJvk1CSiMTqA/Mup5BsPWMKbTirL1CRvqDu+lee72S3nR6mmoIJbn84+vjWUz2YV9
         oWAvJ/fIAsBfqtUBwCinq/RVRAkFSdIOk8FeLaIKkGP134ZAhB/bjoZNYfQ9YX73n3j1
         7jgnC3/TktfMgRqHq9r+R4R0mWYRHkruANiWfHWqFtAY8/MFFwyhu/FnTxQ/v85qwjQp
         taDmCddVXYjrjachk7AUxgAbpuTXZU+1nmAmuOG85uDRADYW2F7xd4Bu/HV/5yaEn05e
         d+cg==
X-Forwarded-Encrypted: i=1; AJvYcCW2wTvvaPP7xVqiiI3e3jeIsCOROISupwz3yMUFAAphNrkmy+kMHrMaFxRDPhH06EFnHJYE8/VFuQ==@kvack.org
X-Gm-Message-State: AOJu0Yzge6ltvz5VtXI0cQfDnF2aYci1Sytls9OolWFmcz36VkUOiS8U
	NanGBWuLD2Xs6omu6vAm+1fk87jRFKjUEOoN/f/FE0Rf5bUBSAm3f1VoU/n2bc8/AXlybF1p4Lq
	8vZq3K3l+SrP23Ipps4E9fU81r/jEJCLP5Ofj3Pd+
X-Gm-Gg: ASbGnctUNII5oY7reyKROozjyk77ICwjFGQa4BgCUjieZYsLLHYdrfOprDmy4ZdgqBV
	OB9wS1MvSpgVEj34qSHgecH490EpoqD32AoS9Ltwi1r1SQasAsyG+qkZ7S4etMZ3S+VklXkG4px
	f9NNxnAF4UBsMaQT67MDeBe4FJpYW/gHnODfIjVq7+DbXaWf7VXZmwcJw9pW6S+/GnY3zdNtF9H
	Qi5zkbdnBMd6AhFctQi0BqPpbo9MT4tDhU=
X-Google-Smtp-Source: AGHT+IFrEvwgN1i9sku/yutWEMMbAcMohlNAeKYEXr7W7OC+AutvcISKoSVXg7p/IYyTxAeo2szVOKk/drT+/5inmEc=
X-Received: by 2002:a05:6402:b7c:b0:613:5007:6448 with SMTP id
 4fb4d7f45d1cf-614a02639e6mr99246a12.3.1753288050318; Wed, 23 Jul 2025
 09:27:30 -0700 (PDT)
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Wed, 23 Jul 2025 18:26:53 +0200
X-Gm-Features: Ac12FXySOH0sWCp9VMVIEtSyojG4K81A7q6dGPdxv_6wTTgoWWlIzseAlUlWUEk
Message-ID: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
Subject: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Cc: Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000006e592e063a9b2f44"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 797C240007
X-Stat-Signature: xfs3c7k8z6sc4s7m5bmdnh3am14wr4um
X-HE-Tag: 1753288052-834818
X-HE-Meta: U2FsdGVkX1++9D8CtyTQjFfOKNOqhqtq7v+8Cc8NPN5GFerh0IhkwGqC28LSEocQYxZWk2ejoY2GzVFoobZ8Q71wL3wJvuK2bpPda6aVbI3qRrmG7agmVL+kB7p+f6xu4Hq+jVAHf2L3cWmj4yuJPdBlk+6z9wd+I53Tbur8HHwXYcMG3ASgYd/tpLzUSKXYwkwy4pAtBziryCghdbqseBlrGrCSp3It56EJ84wKtcM2M8/UIdwVighACrjnza5CvUK6MyqJmSpb2lF/XxNxnXnBbj54NSQnquTZNxe1pRTKqWaPJKVaSRynoDghJyYx6EXL+7jRe32mX3GYxmL8DkwwXVqQWcvUEvHVfQNjJ1g55Df6050Ve8m8DTrFFuQrDkOXmXvVbmSz1h7ObjCoCaQlv/Nw2kpLCX+nv1pB40+266sZpw8HX2J5sRyLYHAvxKX0hP/nJT/B0/cZB5BrtWN5GPdaIbF6ABTJU/aFRSWSeycLU5sLJgOz7Y74FjJgyNzHrfWjxbc8bTN3K0JbV5Bl0CYAOA/BGX5tsowoKLoAQlEvqrTx2zHCUL2axri5AOod+hPm9lLvw5Xdlg9ePFO2o2xTMScUCkuOG6j3BTX/+Gl2XurMmjuLVJFSXio+6nKQKtBKlsSvKAgtHFb0IR6v/Oln5FRBJxHaTi5TM8HXoXdtISHpjmKlIy0dkDpfpr+Q+0ve9o/7Xr88nn3vn+sax9JcNeenktd5R0CVq43N6E1SPXzqaYFvHfFnCFqPjOo86UdtCXri3UWchBzZ5/UJ903llK3GfM8ZWWlzmcvpDhlSO45VRPxRmeKx9xanhUH9r3529KXFjqMMvWHx21tVEsmL4/L5k+0HUW9l0SP2jfVCOshi5WSqBqdrMpNXTuFe+jDpZWRa9AGzsGfmmLE8gFQs29xK80G0HrgBUYP0H+ES4Wl1gFkt7zYMeVVvnhk4HpJZeXRtBCCGXjg
 97vKzo6a
 PKat0pvt7rvZCsaz65xyEtEzluzpG1leV5HTNQ/nndqz47FXJt6y1UHPgXra9O7vxP5ZlSa/SmiDWkTWI320LkvvHEMd8Y/vsYGMyBHMnzCcZpy43k7UMTrOCf5qB2/3QKI4CWWhZ5nKgfbc7UzGmWwoUp58gyMY9tQW4dF3g4VBrYWokEebtJi57lJf7FDdRmc5fR7uVqQplFlH69aM5YYB+D10e+NEfGxjZUhS6xUW0BcEPWR3yucvpQ87XjGJnBBaD5yuTCFpNbyFQs7vtOLpVjcipcq21KVPXEAQ7rF8k0d6X43gGVjQHO1H1qSbLklD7SrZSA+jX546LeDkO/6bwEpUDD69ngKK9ZZ2bvBeM42TOHSir/vkw4QK538oCALAMPyThr4STgrWQIQLwEdooNZY8yP9PrN17V26vsTd6SB0C5JgFTP47z5N74bYWC2LgmziTA6Mb/84L6nt0xggc/hPpOONq4e57TmMptcdsmSIpmAiXyoWYQrsJCCEwB5C+x0XcUrrGE+xsGqsF12KacaRtu4zdpiQ/iVT9U/jIcms0HiYKahpkAgJpMiEwcOZwG9+Akh7xtlSHigZm8FW39p6D8es9ZkVMVOBnDr4tUsjsRZTp94/RHcLejI04Op94GqY3VSMsYpWGAGc8RJqdghZiLA0GwgEp13IYrFT7wt+FR3ID4n12vQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000006e592e063a9b2f44
Content-Type: text/plain; charset="UTF-8"

There's a racy UAF in `vma_refcount_put()` when called on the
`lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
without sufficient protection against concurrent object reuse:

lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
rcu_read_lock(). At that point, the VMA may be concurrently freed, and
it can be recycled by another process. vma_start_read() then
increments the vma->vm_refcnt (if it is in an acceptable range), and
if this succeeds, vma_start_read() can return a reycled VMA. (As a
sidenote, this goes against what the surrounding comments above
vma_start_read() and in lock_vma_under_rcu() say - it would probably
be cleaner to perform the vma->vm_mm check inside vma_start_read().)

In this scenario where the VMA has been recycled, lock_vma_under_rcu()
will then detect the mismatching ->vm_mm pointer and drop the VMA
through vma_end_read(), which calls vma_refcount_put().
vma_refcount_put() does this:

```
static inline void vma_refcount_put(struct vm_area_struct *vma)
{
        /* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
        struct mm_struct *mm = vma->vm_mm;
        int oldcnt;

        rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
        if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {

                if (is_vma_writer_only(oldcnt - 1))
                        rcuwait_wake_up(&mm->vma_writer_wait);
        }
}
```

This is wrong: It implicitly assumes that the caller is keeping the
VMA's mm alive, but in this scenario the caller has no relation to the
VMA's mm, so the rcuwait_wake_up() can cause UAF.

In theory, this could happen to any multithreaded process where thread
A is in the middle of pagefault handling while thread B is
manipulating adjacent VMAs such that VMA merging frees the VMA looked
up by thread A - but in practice, for UAF to actually happen, I think
you need to at least hit three race windows in a row that are each on
the order of a single memory access wide.

The interleaving leading to UAF is the following, where threads A1 and
A2 are part of one process and thread B1 is part of another process:
```
A1               A2               A3
==               ==               ==
lock_vma_under_rcu
  mas_walk
                 <VMA modification removes the VMA>
                                  mmap
                                    <reallocate the VMA>
  vma_start_read
    READ_ONCE(vma->vm_lock_seq)
    __refcount_inc_not_zero_limited_acquire
                                  munmap
                                    __vma_enter_locked
                                      refcount_add_not_zero
  vma_end_read
    vma_refcount_put
      __refcount_dec_and_test
                                      rcuwait_wait_event
                                    <finish operation>
      rcuwait_wake_up [UAF]
```

I'm not sure what the right fix is; I guess one approach would be to
have a special version of vma_refcount_put() for cases where the VMA
has been recycled by another MM that grabs an extra reference to the
MM? But then dropping a reference to the MM afterwards might be a bit
annoying and might require something like mmdrop_async()...


# Reproducer
If you want to actually reproduce this, uh, I have a way to reproduce
it but it's ugly: First apply the KASAN patch
https://lore.kernel.org/all/20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com/
, then apply the attached diff vma-lock-delay-inject.diff to inject
delays in four different places and add some logging, then build with:

CONFIG_KASAN=y
CONFIG_PREEMPT=y
CONFIG_SLUB_RCU_DEBUG must be explicitly disabled!

Then run the resulting kernel, move everything off CPU 0 by running
"for pid in $(ls /proc | grep '^[1-9]'); do taskset -p -a 0xe $pid;
done" as root, and then run the attached testcase vmalock-uaf.c.

That should result in output like:
```
[  105.018129][ T1334] vma_start_read: PRE-INCREMENT DELAY START on
VMA ffff888134b31180
[  106.026145][ T1335] vm_area_alloc: writer allocated vma ffff888134b31180
[  107.024146][ T1334] vma_start_read: PRE-INCREMENT DELAY END
[  107.025836][ T1334] vma_start_read: returning vma
[  107.026800][ T1334] vma_refcount_put: PRE-DECREMENT DELAY START
[  107.528751][ T1335] __vma_enter_locked: BEGIN DELAY
[  110.535863][ T1334] vma_refcount_put: PRE-DECREMENT DELAY END
[  110.537553][ T1334] vma_refcount_put: PRE-WAKEUP DELAY START
(is_vma_writer_only()=1)
[  111.529833][ T1335] __vma_enter_locked: END DELAY
[  121.037571][ T1334] vma_refcount_put: PRE-WAKEUP DELAY END
[  121.039259][ T1334]
==================================================================
[  121.040792][ T1334] BUG: KASAN: slab-use-after-free in
rcuwait_wake_up+0x33/0x60
[  121.042345][ T1334] Read of size 8 at addr ffff8881223545f0 by task TEST/1334
[  121.043698][ T1334]
[  121.044175][ T1334] CPU: 0 UID: 1000 PID: 1334 Comm: TEST Not
tainted 6.16.0-rc7-00002-g0df7d6c9705b-dirty #179 PREEMPT
[  121.044180][ T1334] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  121.044182][ T1334] Call Trace:
[  121.044193][ T1334]  <TASK>
[  121.044198][ T1334]  __dump_stack+0x15/0x20
[  121.044216][ T1334]  dump_stack_lvl+0x6c/0xa0
[  121.044219][ T1334]  print_report+0xbc/0x250
[  121.044224][ T1334]  ? rcuwait_wake_up+0x33/0x60
[  121.044228][ T1334]  kasan_report+0x148/0x180
[  121.044249][ T1334]  ? rcuwait_wake_up+0x33/0x60
[  121.044251][ T1334]  __asan_report_load8_noabort+0x10/0x20
[  121.044257][ T1334]  rcuwait_wake_up+0x33/0x60
[  121.044259][ T1334]  vma_refcount_put+0xbd/0x180
[  121.044267][ T1334]  lock_vma_under_rcu+0x438/0x490
[  121.044271][ T1334]  do_user_addr_fault+0x24c/0xbf0
[  121.044278][ T1334]  exc_page_fault+0x5d/0x90
[  121.044297][ T1334]  asm_exc_page_fault+0x22/0x30
[  121.044304][ T1334] RIP: 0033:0x556803378682
[  121.044317][ T1334] Code: ff 89 45 d4 83 7d d4 ff 75 19 48 8d 05 d7
0b 00 00 48 89 c6 bf 01 00 00 00 b8 00 00 00 00 e8 35 fa ff ff 48 8b
05 26 2a 00 00 <0f> b6 00 48 8d 05 d7 0b 00 00 48 89 c6 bf 0f 00 00 00
b8 00 00 00
[  121.044322][ T1334] RSP: 002b:00007ffcd73e98a0 EFLAGS: 00010213
[  121.044325][ T1334] RAX: 00007fcc5c28c000 RBX: 00007ffcd73e9aa8
RCX: 00007fcc5c18b23a
[  121.044327][ T1334] RDX: 0000000000000007 RSI: 000055680337923a
RDI: 000000000000000f
[  121.044329][ T1334] RBP: 00007ffcd73e9990 R08: 00000000ffffffff
R09: 0000000000000000
[  121.044330][ T1334] R10: 00007fcc5c1869c2 R11: 0000000000000202
R12: 0000000000000000
[  121.044332][ T1334] R13: 00007ffcd73e9ac0 R14: 00007fcc5c2cc000
R15: 000055680337add8
[  121.044335][ T1334]  </TASK>
[  121.044336][ T1334]
[  121.077313][ T1334] Allocated by task 1334:
[  121.078117][ T1334]  kasan_save_track+0x3a/0x80
[  121.078982][ T1334]  kasan_save_alloc_info+0x38/0x50
[  121.080012][ T1334]  __kasan_slab_alloc+0x47/0x60
[  121.080920][ T1334]  kmem_cache_alloc_noprof+0x19e/0x370
[  121.081936][ T1334]  copy_mm+0xb7/0x400
[  121.082724][ T1334]  copy_process+0xe1f/0x2ac0
[  121.083585][ T1334]  kernel_clone+0x14b/0x540
[  121.084511][ T1334]  __x64_sys_clone+0x11d/0x150
[  121.085397][ T1334]  x64_sys_call+0x2c55/0x2fa0
[  121.086271][ T1334]  do_syscall_64+0x48/0x120
[  121.087114][ T1334]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  121.088297][ T1334]
[  121.088730][ T1334] Freed by task 1334:
[  121.090219][ T1334]  kasan_save_track+0x3a/0x80
[  121.091083][ T1334]  kasan_save_free_info+0x42/0x50
[  121.092122][ T1334]  __kasan_slab_free+0x3d/0x60
[  121.093008][ T1334]  kmem_cache_free+0xf5/0x300
[  121.093878][ T1334]  __mmdrop+0x260/0x360
[  121.094645][ T1334]  finish_task_switch+0x29c/0x6d0
[  121.095645][ T1334]  __schedule+0x1396/0x2140
[  121.096521][ T1334]  preempt_schedule_irq+0x67/0xc0
[  121.097456][ T1334]  raw_irqentry_exit_cond_resched+0x30/0x40
[  121.098560][ T1334]  irqentry_exit+0x3f/0x50
[  121.099386][ T1334]  sysvec_apic_timer_interrupt+0x3e/0x80
[  121.100489][ T1334]  asm_sysvec_apic_timer_interrupt+0x16/0x20
[  121.101642][ T1334]
[  121.102132][ T1334] The buggy address belongs to the object at
ffff888122354500
[  121.102132][ T1334]  which belongs to the cache mm_struct of size 1304
[  121.106296][ T1334] The buggy address is located 240 bytes inside of
[  121.106296][ T1334]  freed 1304-byte region [ffff888122354500,
ffff888122354a18)
[  121.109452][ T1334]
[  121.109964][ T1334] The buggy address belongs to the physical page:
[  121.111363][ T1334] page: refcount:0 mapcount:0
mapping:0000000000000000 index:0xffff888122354ac0 pfn:0x122350
[  121.113626][ T1334] head: order:3 mapcount:0 entire_mapcount:0
nr_pages_mapped:-1 pincount:0
[  121.115475][ T1334] memcg:ffff88811b750641
[  121.116414][ T1334] flags: 0x200000000000240(workingset|head|node=0|zone=2)
[  121.117949][ T1334] page_type: f5(slab)
[  121.118815][ T1334] raw: 0200000000000240 ffff888100050640
ffff88810004e9d0 ffff88810004e9d0
[  121.121931][ T1334] raw: ffff888122354ac0 000000000016000d
00000000f5000000 ffff88811b750641
[  121.123820][ T1334] head: 0200000000000240 ffff888100050640
ffff88810004e9d0 ffff88810004e9d0
[  121.125722][ T1334] head: ffff888122354ac0 000000000016000d
00000000f5000000 ffff88811b750641
[  121.127596][ T1334] head: 0200000000000003 ffffea000488d401
ffffea00ffffffff 00000000ffffffff
[  121.129469][ T1334] head: ffffffffffffffff 0000000000000000
00000000ffffffff 0000000000000008
[  121.131335][ T1334] page dumped because: kasan: bad access detected
[  121.132823][ T1334] page_owner tracks the page as allocated
[  121.134065][ T1334] page last allocated via order 3, migratetype
Unmovable, gfp_mask
0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
pid 1165, tgid 1165 (bash), ts 98173533301, free_ts 98103770759
[  121.139486][ T1334]  post_alloc_hook+0x17a/0x190
[  121.140534][ T1334]  get_page_from_freelist+0x2edc/0x2f90
[  121.141731][ T1334]  __alloc_frozen_pages_noprof+0x1c1/0x4d0
[  121.143022][ T1334]  alloc_pages_mpol+0x14e/0x2b0
[  121.144098][ T1334]  alloc_frozen_pages_noprof+0xc4/0xf0
[  121.145318][ T1334]  allocate_slab+0x8f/0x280
[  121.146296][ T1334]  ___slab_alloc+0x3d5/0x8e0
[  121.147292][ T1334]  kmem_cache_alloc_noprof+0x229/0x370
[  121.148489][ T1334]  copy_mm+0xb7/0x400
[  121.149355][ T1334]  copy_process+0xe1f/0x2ac0
[  121.150352][ T1334]  kernel_clone+0x14b/0x540
[  121.151330][ T1334]  __x64_sys_clone+0x11d/0x150
[  121.152472][ T1334]  x64_sys_call+0x2c55/0x2fa0
[  121.153491][ T1334]  do_syscall_64+0x48/0x120
[  121.154479][ T1334]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  121.156725][ T1334] page last free pid 1321 tgid 1321 stack trace:
[  121.158098][ T1334]  __free_frozen_pages+0xa1c/0xc80
[  121.159205][ T1334]  free_frozen_pages+0xc/0x20
[  121.160229][ T1334]  __free_slab+0xad/0xc0
[  121.161149][ T1334]  free_slab+0x17/0x100
[  121.162102][ T1334]  free_to_partial_list+0x48f/0x5b0
[  121.163239][ T1334]  __slab_free+0x1e5/0x240
[  121.164210][ T1334]  ___cache_free+0xb3/0xf0
[  121.165174][ T1334]  qlist_free_all+0xb7/0x160
[  121.166176][ T1334]  kasan_quarantine_reduce+0x14b/0x170
[  121.167358][ T1334]  __kasan_slab_alloc+0x1e/0x60
[  121.168456][ T1334]  kmem_cache_alloc_noprof+0x19e/0x370
[  121.169638][ T1334]  getname_flags+0x9c/0x490
[  121.170631][ T1334]  do_sys_openat2+0x55/0x100
[  121.171629][ T1334]  __x64_sys_openat+0xf4/0x120
[  121.173713][ T1334]  x64_sys_call+0x1ab/0x2fa0
[  121.174716][ T1334]  do_syscall_64+0x48/0x120
[  121.175697][ T1334]
[  121.176216][ T1334] Memory state around the buggy address:
[  121.177433][ T1334]  ffff888122354480: fc fc fc fc fc fc fc fc fc
fc fc fc fc fc fc fc
[  121.179173][ T1334]  ffff888122354500: fa fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb
[  121.180922][ T1334] >ffff888122354580: fb fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb
[  121.182718][ T1334]
             ^
[  121.184634][ T1334]  ffff888122354600: fb fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb
[  121.186398][ T1334]  ffff888122354680: fb fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb
[  121.189204][ T1334]
==================================================================
```

--0000000000006e592e063a9b2f44
Content-Type: text/x-patch; charset="US-ASCII"; name="vma-lock-delay-inject.diff"
Content-Disposition: attachment; filename="vma-lock-delay-inject.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mdg4zcmc0>
X-Attachment-Id: f_mdg4zcmc0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW1hcF9sb2NrLmggYi9pbmNsdWRlL2xpbnV4L21t
YXBfbG9jay5oCmluZGV4IDVkYTM4NGJkMGEyNi4uMWFjYWMxYWI5ZDMwIDEwMDY0NAotLS0gYS9p
bmNsdWRlL2xpbnV4L21tYXBfbG9jay5oCisrKyBiL2luY2x1ZGUvbGludXgvbW1hcF9sb2NrLmgK
QEAgLTEyLDYgKzEyLDcgQEAgZXh0ZXJuIGludCByY3V3YWl0X3dha2VfdXAoc3RydWN0IHJjdXdh
aXQgKncpOwogI2luY2x1ZGUgPGxpbnV4L3RyYWNlcG9pbnQtZGVmcy5oPgogI2luY2x1ZGUgPGxp
bnV4L3R5cGVzLmg+CiAjaW5jbHVkZSA8bGludXgvY2xlYW51cC5oPgorI2luY2x1ZGUgPGxpbnV4
L2RlbGF5Lmg+CiAKICNkZWZpbmUgTU1BUF9MT0NLX0lOSVRJQUxJWkVSKG5hbWUpIFwKIAkubW1h
cF9sb2NrID0gX19SV1NFTV9JTklUSUFMSVpFUigobmFtZSkubW1hcF9sb2NrKSwKQEAgLTEzOSw4
ICsxNDAsMTggQEAgc3RhdGljIGlubGluZSB2b2lkIHZtYV9yZWZjb3VudF9wdXQoc3RydWN0IHZt
X2FyZWFfc3RydWN0ICp2bWEpCiAJaW50IG9sZGNudDsKIAogCXJ3c2VtX3JlbGVhc2UoJnZtYS0+
dm1sb2NrX2RlcF9tYXAsIF9SRVRfSVBfKTsKKwlpZiAoc3RyY21wKGN1cnJlbnQtPmNvbW0sICJU
RVNUIikgPT0gMCkgeworCQlwcl93YXJuKCIlczogUFJFLURFQ1JFTUVOVCBERUxBWSBTVEFSVFxu
IiwgX19mdW5jX18pOworCQltZGVsYXkoMjAwMCk7CisJCXByX3dhcm4oIiVzOiBQUkUtREVDUkVN
RU5UIERFTEFZIEVORFxuIiwgX19mdW5jX18pOworCX0KIAlpZiAoIV9fcmVmY291bnRfZGVjX2Fu
ZF90ZXN0KCZ2bWEtPnZtX3JlZmNudCwgJm9sZGNudCkpIHsKIAorCQlpZiAoc3RyY21wKGN1cnJl
bnQtPmNvbW0sICJURVNUIikgPT0gMCkgeworCQkJcHJfd2FybigiJXM6IFBSRS1XQUtFVVAgREVM
QVkgU1RBUlQgKGlzX3ZtYV93cml0ZXJfb25seSgpPSVkKVxuIiwgX19mdW5jX18sIGlzX3ZtYV93
cml0ZXJfb25seShvbGRjbnQtMSkpOworCQkJbWRlbGF5KDEwMDAwKTsKKwkJCXByX3dhcm4oIiVz
OiBQUkUtV0FLRVVQIERFTEFZIEVORFxuIiwgX19mdW5jX18pOworCQl9CiAJCWlmIChpc192bWFf
d3JpdGVyX29ubHkob2xkY250IC0gMSkpCiAJCQlyY3V3YWl0X3dha2VfdXAoJm1tLT52bWFfd3Jp
dGVyX3dhaXQpOwogCX0KQEAgLTE3MCw2ICsxODEsMTEgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3Qg
dm1fYXJlYV9zdHJ1Y3QgKnZtYV9zdGFydF9yZWFkKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLAogCWlm
IChSRUFEX09OQ0Uodm1hLT52bV9sb2NrX3NlcSkgPT0gUkVBRF9PTkNFKG1tLT5tbV9sb2NrX3Nl
cS5zZXF1ZW5jZSkpCiAJCXJldHVybiBOVUxMOwogCisJaWYgKHN0cmNtcChjdXJyZW50LT5jb21t
LCAiVEVTVCIpID09IDApIHsKKwkJcHJfd2FybigiJXM6IFBSRS1JTkNSRU1FTlQgREVMQVkgU1RB
UlQgb24gVk1BICVweFxuIiwgX19mdW5jX18sIHZtYSk7CisJCW1kZWxheSgyMDAwKTsKKwkJcHJf
d2FybigiJXM6IFBSRS1JTkNSRU1FTlQgREVMQVkgRU5EXG4iLCBfX2Z1bmNfXyk7CisJfQogCS8q
CiAJICogSWYgVk1BX0xPQ0tfT0ZGU0VUIGlzIHNldCwgX19yZWZjb3VudF9pbmNfbm90X3plcm9f
bGltaXRlZF9hY3F1aXJlKCkKIAkgKiB3aWxsIGZhaWwgYmVjYXVzZSBWTUFfUkVGX0xJTUlUIGlz
IGxlc3MgdGhhbiBWTUFfTE9DS19PRkZTRVQuCkBAIC0xNzksNiArMTk1LDggQEAgc3RhdGljIGlu
bGluZSBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYV9zdGFydF9yZWFkKHN0cnVjdCBtbV9zdHJ1
Y3QgKm1tLAogCWlmICh1bmxpa2VseSghX19yZWZjb3VudF9pbmNfbm90X3plcm9fbGltaXRlZF9h
Y3F1aXJlKCZ2bWEtPnZtX3JlZmNudCwgJm9sZGNudCwKIAkJCQkJCQkgICAgICBWTUFfUkVGX0xJ
TUlUKSkpIHsKIAkJLyogcmV0dXJuIEVBR0FJTiBpZiB2bWEgZ290IGRldGFjaGVkIGZyb20gdW5k
ZXIgdXMgKi8KKwkJaWYgKHN0cmNtcChjdXJyZW50LT5jb21tLCAiVEVTVCIpID09IDApCisJCQlw
cl93YXJuKCIlczogcmVmY291bnQgYWNxdWlyZSBmYWlsZWRcbiIsIF9fZnVuY19fKTsKIAkJcmV0
dXJuIG9sZGNudCA/IE5VTEwgOiBFUlJfUFRSKC1FQUdBSU4pOwogCX0KIApAQCAtMTk1LDEwICsy
MTMsMTQgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYV9zdGFydF9y
ZWFkKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLAogCSAqIFRoaXMgcGFpcnMgd2l0aCBSRUxFQVNFIHNl
bWFudGljcyBpbiB2bWFfZW5kX3dyaXRlX2FsbCgpLgogCSAqLwogCWlmICh1bmxpa2VseSh2bWEt
PnZtX2xvY2tfc2VxID09IHJhd19yZWFkX3NlcWNvdW50KCZtbS0+bW1fbG9ja19zZXEpKSkgewor
CQlpZiAoc3RyY21wKGN1cnJlbnQtPmNvbW0sICJURVNUIikgPT0gMCkKKwkJCXByX3dhcm4oIiVz
OiBzZXFjb3VudCBtaXNtYXRjaFxuIiwgX19mdW5jX18pOwogCQl2bWFfcmVmY291bnRfcHV0KHZt
YSk7CiAJCXJldHVybiBOVUxMOwogCX0KIAorCWlmIChzdHJjbXAoY3VycmVudC0+Y29tbSwgIlRF
U1QiKSA9PSAwKQorCQlwcl93YXJuKCIlczogcmV0dXJuaW5nIHZtYVxuIiwgX19mdW5jX18pOwog
CXJldHVybiB2bWE7CiB9CiAKZGlmZiAtLWdpdCBhL21tL21tYXBfbG9jay5jIGIvbW0vbW1hcF9s
b2NrLmMKaW5kZXggNWY3MjVjYzY3MzM0Li43YzVjYTFjMGQzMzEgMTAwNjQ0Ci0tLSBhL21tL21t
YXBfbG9jay5jCisrKyBiL21tL21tYXBfbG9jay5jCkBAIC02MCw2ICs2MCwxMiBAQCBzdGF0aWMg
aW5saW5lIGJvb2wgX192bWFfZW50ZXJfbG9ja2VkKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1h
LCBib29sIGRldGFjaGluZwogCWlmICghcmVmY291bnRfYWRkX25vdF96ZXJvKFZNQV9MT0NLX09G
RlNFVCwgJnZtYS0+dm1fcmVmY250KSkKIAkJcmV0dXJuIGZhbHNlOwogCisJaWYgKHN0cmNtcChj
dXJyZW50LT5jb21tLCAiV1JJVEVSIikgPT0gMCkgeworCQlwcl93YXJuKCIlczogQkVHSU4gREVM
QVlcbiIsIF9fZnVuY19fKTsKKwkJbWRlbGF5KDIwMDApOworCQlwcl93YXJuKCIlczogRU5EIERF
TEFZXG4iLCBfX2Z1bmNfXyk7CisJfQorCiAJcndzZW1fYWNxdWlyZSgmdm1hLT52bWxvY2tfZGVw
X21hcCwgMCwgMCwgX1JFVF9JUF8pOwogCXJjdXdhaXRfd2FpdF9ldmVudCgmdm1hLT52bV9tbS0+
dm1hX3dyaXRlcl93YWl0LAogCQkgICByZWZjb3VudF9yZWFkKCZ2bWEtPnZtX3JlZmNudCkgPT0g
dGd0X3JlZmNudCwKZGlmZiAtLWdpdCBhL21tL3ZtYV9pbml0LmMgYi9tbS92bWFfaW5pdC5jCmlu
ZGV4IDhlNTNjNzk0MzU2MS4uZmI1N2Q1NzIwNWRlIDEwMDY0NAotLS0gYS9tbS92bWFfaW5pdC5j
CisrKyBiL21tL3ZtYV9pbml0LmMKQEAgLTMxLDYgKzMxLDggQEAgc3RydWN0IHZtX2FyZWFfc3Ry
dWN0ICp2bV9hcmVhX2FsbG9jKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQogCXZtYSA9IGttZW1fY2Fj
aGVfYWxsb2Modm1fYXJlYV9jYWNoZXAsIEdGUF9LRVJORUwpOwogCWlmICghdm1hKQogCQlyZXR1
cm4gTlVMTDsKKwlpZiAoc3RyY21wKGN1cnJlbnQtPmNvbW0sICJXUklURVItUFJFUCIpID09IDAp
CisJCXByX3dhcm4oIiVzOiB3cml0ZXIgYWxsb2NhdGVkIHZtYSAlcHhcbiIsIF9fZnVuY19fLCB2
bWEpOwogCiAJdm1hX2luaXQodm1hLCBtbSk7CiAK
--0000000000006e592e063a9b2f44
Content-Type: text/x-csrc; charset="US-ASCII"; name="vmalock-uaf.c"
Content-Disposition: attachment; filename="vmalock-uaf.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mdg55efp1>
X-Attachment-Id: f_mdg55efp1

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8cHRocmVhZC5oPgojaW5jbHVkZSA8dW5pc3Rk
Lmg+CiNpbmNsdWRlIDxzY2hlZC5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPGVyci5o
PgojaW5jbHVkZSA8c2lnbmFsLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN5cy9w
cmN0bC5oPgojaW5jbHVkZSA8c3lzL21tYW4uaD4KI2luY2x1ZGUgPHN5cy9ldmVudGZkLmg+Cgoj
ZGVmaW5lIFNZU0NISyh4KSAoeyAgICAgICAgICBcCiAgdHlwZW9mKHgpIF9fcmVzID0gKHgpOyAg
ICAgIFwKICBpZiAoX19yZXMgPT0gKHR5cGVvZih4KSktMSkgXAogICAgZXJyKDEsICJTWVNDSEso
IiAjeCAiKSIpOyBcCiAgX19yZXM7ICAgICAgICAgICAgICAgICAgICAgIFwKfSkKCnN0YXRpYyB2
b2lkICpidWd2bWE7CmludCB3YWtlX2NoaWxkX2ZkID0gLTE7CnN0YXRpYyB2b2lkICp0aHJlYWRf
Zm4odm9pZCAqZHVtbXkpIHsKICBzbGVlcCgxKTsgLy8gUFJFLUxBVU5DSAoKICBzbGVlcCgxKTsK
ICAvLyBUMQogIFNZU0NISyhtdW5tYXAoYnVndm1hLCAweDEwMDApKTsKICBTWVNDSEsoZXZlbnRm
ZF93cml0ZSh3YWtlX2NoaWxkX2ZkLCAxKSk7CiAgdXNsZWVwKDUwMCoxMDAwKTsKICByZXR1cm4g
TlVMTDsKfQoKaW50IG1haW4odm9pZCkgewogIHNldGJ1ZihzdGRvdXQsIE5VTEwpOwoKICB3YWtl
X2NoaWxkX2ZkID0gU1lTQ0hLKGV2ZW50ZmQoMCwgMCkpOwogIC8vIHBpbiBhbGwgdG8gc2FtZSBj
b3JlIHRvIGVuc3VyZSB3ZSB1c2UgdGhlIHNhbWUgU0xVQiBmcmVlbGlzdAogIGNwdV9zZXRfdCBj
cHVzZXQ7CiAgQ1BVX1pFUk8oJmNwdXNldCk7CiAgQ1BVX1NFVCgwLCAmY3B1c2V0KTsKICBTWVND
SEsoc2NoZWRfc2V0YWZmaW5pdHkoMCwgc2l6ZW9mKGNwdXNldCksICZjcHVzZXQpKTsKCiAgcGlk
X3QgY2hpbGQgPSBTWVNDSEsoZm9yaygpKTsKICBpZiAoY2hpbGQgPT0gMCkgewogICAgZXZlbnRm
ZF90IGR1bW15dmFsOwogICAgU1lTQ0hLKGV2ZW50ZmRfcmVhZCh3YWtlX2NoaWxkX2ZkLCAmZHVt
bXl2YWwpKTsKCiAgICAvLyBUMQogICAgU1lTQ0hLKHByY3RsKFBSX1NFVF9OQU1FLCAiV1JJVEVS
LVBSRVAiKSk7CiAgICB2b2lkICpyZWFsbG9jID0gU1lTQ0hLKG1tYXAoTlVMTCwgMHgxMDAwLCBQ
Uk9UX1JFQUR8UFJPVF9XUklURXxQUk9UX0VYRUMsIE1BUF9QUklWQVRFfE1BUF9BTk9OWU1PVVMs
IC0xLCAwKSk7CiAgICB1c2xlZXAoMTUwMCoxMDAwKTsKICAgIC8vIFQzCiAgICBwcmludGYoIkIx
OiBiZWdpbiBtdW5tYXBcbiIpOwogICAgU1lTQ0hLKHByY3RsKFBSX1NFVF9OQU1FLCAiV1JJVEVS
IikpOwogICAgU1lTQ0hLKG11bm1hcChyZWFsbG9jLCAweDEwMDApKTsgLy8gY29udGludWVzIGF0
IFQ1CiAgICBTWVNDSEsocHJjdGwoUFJfU0VUX05BTUUsICJXUklURVItRU5ERUQiKSk7CiAgICBw
cmludGYoIkIxOiBtdW5tYXAgZG9uZVxuIik7CiAgICBleGl0KDApOwogIH0KCiAgcHRocmVhZF90
IHRocmVhZDsKICBpZiAocHRocmVhZF9jcmVhdGUoJnRocmVhZCwgTlVMTCwgdGhyZWFkX2ZuLCBO
VUxMKSkKICAgIGVycngoMSwgInB0aHJlYWRfY3JlYXRlIik7CgogIHNsZWVwKDEpOyAvLyBQUkUt
TEFVTkNICgogIGJ1Z3ZtYSA9IFNZU0NISyhtbWFwKE5VTEwsIDB4MTAwMCwgUFJPVF9SRUFEfFBS
T1RfV1JJVEV8UFJPVF9FWEVDLCBNQVBfUFJJVkFURXxNQVBfQU5PTllNT1VTLCAtMSwgMCkpOwog
IFNZU0NISyhwcmN0bChQUl9TRVRfTkFNRSwgIlRFU1QiKSk7CiAgLy8gVDAKICAqKHZvbGF0aWxl
IGNoYXIgKilidWd2bWE7IC8vIGluY3JlbWVudCBhdCBUMjsgZGVjcmVtZW50IGF0IFQ0OyBVQUYg
YXQgVDYKICBTWVNDSEsocHJjdGwoUFJfU0VUX05BTUUsICJURVNULUVOREVEIikpOwp9Cg==
--0000000000006e592e063a9b2f44--

