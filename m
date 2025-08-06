Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0958C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 17:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C9B6B009E; Wed,  6 Aug 2025 13:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70CCD6B009F; Wed,  6 Aug 2025 13:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ADCC6B00A1; Wed,  6 Aug 2025 13:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2766B009E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:31:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3D391A066F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:31:03 +0000 (UTC)
X-FDA: 83747023206.23.3EAA5CA
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 01772140005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:31:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XvL8Nsxr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754501462; a=rsa-sha256;
	cv=none;
	b=LFmSXS6Vo5OFyzGmoUb0FFAqnMXyJjxJlZkgva0MeitBgi1AsevAauzE06xL/AmuKDB/my
	IKHbFEcItbZYjo0BWn0e7NLzsX7HtSbvoQWBEsHh/ZIvwtOZV+24eVy4+Du8W8ouj27IKH
	BmxDB9ygg0vbw1MZ7Rm1wrsiE0Jm4jM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XvL8Nsxr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754501462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2O1zwfL/UYqQtx8ceSMM8iZ39OAphqSN6A4Iks0YaB0=;
	b=NV0HMUrDxPoue9RS+h/+0c+pa8tnwgt7dJkqbnqCZhtiA4oAQncoy99xfwaT7h+emEpC7Q
	wN4MgFqnPD5X1kPccmiBlbmHg7YRUQoYARajKCAYw4TDGWUBnJvjlpgfaA98f9aq+bAQza
	hGhl6PhCxSMPneGYDV4fNBpYH3u62bg=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso816a12.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 10:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754501460; x=1755106260; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2O1zwfL/UYqQtx8ceSMM8iZ39OAphqSN6A4Iks0YaB0=;
        b=XvL8NsxrcKwjS8jLRo/jsIhuhrK/oznpSTpDl7mnvXaLizoZkYvZ6QnT5GfVzYnLlu
         zdetmcfIuw+xgYmycMjhlo/AlV/jctjdUfZelQ7yENrwMiAGkGAz0BbgMFQnWAbG+bvh
         NvcK2rwMzcnhnKm+FzfJ9vPJnBQxlTVHjj1a7Sk/8miSZX60rHQ8vRW1yuYmUc3tyGUn
         Buv72piFWBiAyRfWk1hFDTdyxfmWRL0eupAQczugI7NvH7dRkUkJgX+c6WlCo1sSkIyr
         4IEXVVajkbUAR6Tjquzt8+nNW69rOqBUz4CHlnNUd28QQhZbfP1L5PINITYLnAGDsgh4
         ATzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754501460; x=1755106260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2O1zwfL/UYqQtx8ceSMM8iZ39OAphqSN6A4Iks0YaB0=;
        b=t6oI2J1/Cwz2WQ7ft4uIqYCzIl4NMvRm/dEvLfVidXAsSgfxFPTCgueOC5jsTJFvy6
         GbblQhTudTKQy9l+gfrKqWG2BMafBWC+FYSTUE2cAvZSXekPW/9aGs4BSDz5vXS29PtR
         HinnnwdON755iHATJ8mcnFHfczjsU6uDHlXeKt3/zKGWZryKbbI4uFH0beZ24BU5EBOv
         hdq7ER3rs/6sTiULVSTJH4iD9TczFUGYMTbwNChjE7X3ELGqy2toX5EJDUIlhe56u2+S
         3hnACDOtuo+de2D7L+P5kivedJ8VGdjATWTI2YkRl2YuewRi2EKVkx0pXTBEK/R0of2a
         EGbw==
X-Forwarded-Encrypted: i=1; AJvYcCUepzoS0s0yHkx3wrOP8e5C61PukTgWkDeXKcZfiULX/kbFMDQqx5zJ2v3Q0s8IbVrnvtbhx8jiQg==@kvack.org
X-Gm-Message-State: AOJu0YzHO25sjwYWTBor2tLFuyK2kOg5ejFw92/wJ3R5m84pXIZJmHAC
	ASxqrZ+er2v7jF0FiwCYAnqZ96fp+Z5GPM/np8m/IU8KcrsvY4LeXbJbT38NQQQni+bnFrzzTCh
	wlB+emsJDveZTIZ9lL/PTdGHo2dn4zJ6vDY4NUL/9
X-Gm-Gg: ASbGncu6JrOPMzyLmuTwHXAEy5ijLpLvDLPnW7bKVfLXp5JlWnXT5UxNu4RO7nKmfNv
	z34JSrqSkC/Q2fsEmcwJX/l7fIJKn+uk9xpoLKkbJdxNvJlj5q68IHo6j4S87cySE8egmnqfGjz
	vJhISDA5G0vrdjzqfMwT7g51ufn8qRKjBROUnh8BQx753EmahS19w0AUMSDq4TpW/TAO2xlYgQo
	ctFJC4r6NEL13cnFOoiwkHBTRkVx3H+x5fqeDQESg==
X-Google-Smtp-Source: AGHT+IGZYHqMO6nOext8IXEfZFnlVxuTzvfAsD1ASp7WlH8v9FRFw+U7OqG6LSsKKeEwE87Emf/LUxOiCHp7W6/3mQY=
X-Received: by 2002:a05:6402:3082:b0:615:60d2:c013 with SMTP id
 4fb4d7f45d1cf-61797e7bc1amr91621a12.3.1754501459967; Wed, 06 Aug 2025
 10:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250805121410.1658418-1-lokeshgidra@google.com> <a00a8cca-e435-434f-855c-a3b56f2aece4@lucifer.local>
In-Reply-To: <a00a8cca-e435-434f-855c-a3b56f2aece4@lucifer.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Wed, 6 Aug 2025 10:30:47 -0700
X-Gm-Features: Ac12FXwSYt0WGCr2k_VsdRbGveIp_87zZmB7V02_hsc1VeZ3C2syDDfiVLignxw
Message-ID: <CA+EESO6F4=jQujGU35EPp_EVtHRHEG7b7_izLv1-NJW_VFvGRw@mail.gmail.com>
Subject: Re: [PATCH v2] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 21cnbao@gmail.com, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6mz5yfrrtrfznzh6p4b5rrb68j4y5we1
X-Rspam-User: 
X-Rspamd-Queue-Id: 01772140005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754501461-276274
X-HE-Meta: U2FsdGVkX19wlIwNz/zE5RNFpWi1FdveariOj2H7AhUM881y1Lhava1XM2LKpVM2igav0k17XIOS4c8l6BOi2n8E/zVEJaTpv1WMnrM2XDN+GEUm0fP25V5Kuq6ewIsx+mNyIirZu0GlLaYikCf/WSaBnL3HSDFESHT1YGpdF+eAnuHzQRl8XNHzZRAIqw2rqysOtOwB/2b6Bqjc+qUhX7IwDHO24jvVs7U2fLXWsPbxGqGVrsjgACqgY0ZS3VAEQLGQDGVAcY/1a8nTGemRYkSkQLaJlrNArnCQBYCzBYtisFnYBqAxm1GB1+XyPID6C1N4NuujXgyG/Nqq3CDmlvVcoIR044I3y6dNlDfLKtpGIeOjB2qJfpAo7rPr8Z1ig99iwxDv/RHyX0NS8eHs4ZH4MyGDC0qqQyNzwCRVkR8UBwJpvCviqv5EAkXUQo+ZZWnsOIEK20aMudFYHF8LCwNA/ow/naY+vdd5glL1C8+XKR9yws1fYpJc+zMJ8FnKEktBPq5PuGHL76W9CSmGL4VMRlKeWajEht2d7J3dFvSxK/gihL2BEaw6PZwwucFbcGt7o1NpgA+2uKs2fLJ89u0JhDNY3xNjMX6mTHRq4O8vBzpT/eQhmpGru1aFkmAF/BnSFdNEB7XRJZQcOJodB43SrEDh5PauSr5lSbQjyh6CoYFzGJBziItVd78SaF9jpVh4BSvPnxEDlYcxOqSel4/gAzBRrd+LL1Am/2tR1OHu7StvRB24YhoXe+Vyt/NpUWVRFcnOUL04JN+Ks7iEPtaoM1ZAXKFM4HLTZl4/gMCMH8G8Y3LX8RiJtgoECNTnD5L9bXXSBXeMUELS/XQYTkrn6wvLdIWlec37naZozPemTeSlho1e4Cp1dOoipcfGaiSFk0k/3q7QHRoWp1iCPR/QMnRN4BUa+NHfvzuq+tJsoj6yyqmu2JsnQLeyUdHa1JO/poPmqlISrZrUay6
 p7c5O2CR
 W+sTJFXUEyepnFFo1gd9KcvnQI+FVOvETZCv4Tx+PUusiWYKMdditt6hegnU9t7BHTHA85ZhvlbsDKxqahokSj480nJ7gQwmSRGO1LtfxMHgQQ2gPCclJWs1QRaAD95FRSA8jf1tjnPAEFbExPs+TYFrVn9eRf/JtzTOYBp12oI984SK5N/p+IO6ElNLK607xzakfTcXwjiIBM2BLNW+ENYmLtWS1RD6o7/zkH1YfnQ5Vq86xLUtC+HnafYuB9UkD8j8BHzOSXOT12ocvKe911GCDODH82c5pxP00
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 10:18=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Andrew - Could we drop this for now, please, it's splatting and has broke=
n
> mm-new.
>
> Lokesh - could you make sure to run the mm self tests with CONFIG_DBUG_VM
> set before you submit please? As this is splat is occurring immediately o=
n
> uffd-unit-tests.

Sincere apologies. Will be extra careful from now on.
>
> On Tue, Aug 05, 2025 at 05:14:10AM -0700, Lokesh Gidra wrote:
> > MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> > for moving present pages. Mitigate this cost by opportunistically
> > batching present contiguous pages for TLB flushing.
> >
> > Without batching, in our testing on an arm64 Android device with UFFD G=
C,
> > which uses MOVE ioctl for compaction, we observed that out of the total
> > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> > ~20% in vm_normal_folio().
> >
> > With batching, the proportion of vm_normal_folio() increases to over
> > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > includes TLB-flush overhead.
> >
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Kalesh Singh <kaleshsingh@google.com>
> > Cc: Barry Song <v-songbaohua@oppo.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > ---
> > Changes since v1 [1]
> > - Removed flush_tlb_batched_pending(), per Barry Song
> > - Unified single and multi page case, per Barry Song
>
> Splat, decoded via scripts/decode_stacktrace.sh:
>
> $ sudo ./uffd-unit-tests
> Testing UFFDIO_API (with syscall)... done
> Testing UFFDIO_API (with /dev/userfaultfd)... done
> Testing register-ioctls on anon... done
> Testing register-ioctls on shmem... done
> Testing register-ioctls on shmem-private... done
> Testing register-ioctls on hugetlb... skipped [reason: memory allocation =
failed]
> Testing register-ioctls on hugetlb-private... skipped [reason: memory all=
ocation failed]
> Testing zeropage on anon... done
> Testing zeropage on shmem... done
> Testing zeropage on shmem-private... done
> Testing zeropage on hugetlb... skipped [reason: memory allocation failed]
> Testing zeropage on hugetlb-private... skipped [reason: memory allocation=
 failed]
> Testing move on anon... [   12.230740] Kernel panic - not syncing: kernel=
: panic_on_warn set ...
> [   12.231322] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S Arch Linux 1.17.0-1-1 04/01/2014
> [   12.231655] Call Trace:
> [   12.231748]  <TASK>
> [   12.231830] dump_stack_lvl (lib/dump_stack.c:122)
> [   12.231963] vpanic (kernel/panic.c:448)
> [   12.232088] panic (kernel/panic.c:312 kernel/panic.c:303)
> [   12.232199] ? move_pages (mm/userfaultfd.c:1964 (discriminator 2))
>
> Appears to be:
>
>         VM_WARN_ON_ONCE(err > 0);
>
> [   12.232341] check_panic_on_warn.cold (kernel/panic.c:327)
> [   12.232502] __warn.cold (kernel/panic.c:839)
> [   12.232628] ? move_pages (mm/userfaultfd.c:1964 (discriminator 2))
> [   12.232764] report_bug (lib/bug.c:176 lib/bug.c:215)
> [   12.232891] handle_bug (arch/x86/kernel/traps.c:338 (discriminator 1))
> [   12.233034] ? move_pages (mm/userfaultfd.c:1964 (discriminator 2))
> [   12.233174] exc_invalid_op (arch/x86/kernel/traps.c:392 (discriminator=
 3))
> [   12.233312] asm_exc_invalid_op (./arch/x86/include/asm/idtentry.h:621)
> [   12.233460] RIP: 0010:move_pages (mm/userfaultfd.c:1964 (discriminator=
 2))
> [ 12.233615] Code: 5e 41 5f c3 cc cc cc cc 49 89 c5 e9 e1 fe ff ff eb c4 =
e9 6d ff ff ff 90 0f 0b 90 45 31 ff eb cf 90 0f 0b 90 48 85 d2 7e c6 90 <0f=
> 0b 90 eb b9 90 0f 0b 90 f7 c1 ff 0f 00 00 0f 84 4e fe ff ff 90
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:   5e                      pop    %rsi
>    1:   41 5f                   pop    %r15
>    3:   c3                      ret
>    4:   cc                      int3
>    5:   cc                      int3
>    6:   cc                      int3
>    7:   cc                      int3
>    8:   49 89 c5                mov    %rax,%r13
>    b:   e9 e1 fe ff ff          jmp    0xfffffffffffffef1
>   10:   eb c4                   jmp    0xffffffffffffffd6
>   12:   e9 6d ff ff ff          jmp    0xffffffffffffff84
>   17:   90                      nop
>   18:   0f 0b                   ud2
>   1a:   90                      nop
>   1b:   45 31 ff                xor    %r15d,%r15d
>   1e:   eb cf                   jmp    0xffffffffffffffef
>   20:   90                      nop
>   21:   0f 0b                   ud2
>   23:   90                      nop
>   24:   48 85 d2                test   %rdx,%rdx
>   27:   7e c6                   jle    0xffffffffffffffef
>   29:   90                      nop
>   2a:*  0f 0b                   ud2             <-- trapping instruction
>   2c:   90                      nop
>   2d:   eb b9                   jmp    0xffffffffffffffe8
>   2f:   90                      nop
>   30:   0f 0b                   ud2
>   32:   90                      nop
>   33:   f7 c1 ff 0f 00 00       test   $0xfff,%ecx
>   39:   0f 84 4e fe ff ff       je     0xfffffffffffffe8d
>   3f:   90                      nop
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:   0f 0b                   ud2
>    2:   90                      nop
>    3:   eb b9                   jmp    0xffffffffffffffbe
>    5:   90                      nop
>    6:   0f 0b                   ud2
>    8:   90                      nop
>    9:   f7 c1 ff 0f 00 00       test   $0xfff,%ecx
>    f:   0f 84 4e fe ff ff       je     0xfffffffffffffe63
>   15:   90                      nop
> [   12.234294] RSP: 0018:ffffafeb00483d70 EFLAGS: 00010206
> [   12.234484] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 000000000=
0000002
> [   12.234738] RDX: 0000000000001000 RSI: ffff90afbb433078 RDI: ffff90afb=
c7f0080
> [   12.234997] RBP: ffff90afbc7f0000 R08: ffff90b037cae540 R09: 000000000=
0000001
> [   12.235255] R10: ffffffffffffffff R11: 0000000000000003 R12: ffff90af0=
1acb980
> [   12.235508] R13: ffff90afbc7f0240 R14: ffffefc386e80b00 R15: 000000000=
0001000
> [   12.235764] userfaultfd_ioctl (fs/userfaultfd.c:1925 fs/userfaultfd.c:=
2046)
> [   12.235917] __x64_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:598 fs/ioctl.c:5=
84 fs/ioctl.c:584)
> [   12.236065] ? ksys_read (./include/linux/file.h:63 ./include/linux/fil=
e.h:80 ./include/linux/file.h:85 fs/read_write.c:706)
> [   12.236202] do_syscall_64 (arch/x86/entry/syscall_64.c:63 (discriminat=
or 1) arch/x86/entry/syscall_64.c:94 (discriminator 1))
> [   12.236345] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:=
130)
> [   12.236524] RIP: 0033:0x7f457600fecd
> [ 12.236658] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 =
b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89=
> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:   04 25                   add    $0x25,%al
>    2:   28 00                   sub    %al,(%rax)
>    4:   00 00                   add    %al,(%rax)
>    6:   48 89 45 c8             mov    %rax,-0x38(%rbp)
>    a:   31 c0                   xor    %eax,%eax
>    c:   48 8d 45 10             lea    0x10(%rbp),%rax
>   10:   c7 45 b0 10 00 00 00    movl   $0x10,-0x50(%rbp)
>   17:   48 89 45 b8             mov    %rax,-0x48(%rbp)
>   1b:   48 8d 45 d0             lea    -0x30(%rbp),%rax
>   1f:   48 89 45 c0             mov    %rax,-0x40(%rbp)
>   23:   b8 10 00 00 00          mov    $0x10,%eax
>   28:   0f 05                   syscall
>   2a:*  89 c2                   mov    %eax,%edx                <-- trapp=
ing instruction
>   2c:   3d 00 f0 ff ff          cmp    $0xfffff000,%eax
>   31:   77 1a                   ja     0x4d
>   33:   48 8b 45 c8             mov    -0x38(%rbp),%rax
>   37:   64 48 2b 04 25 28 00    sub    %fs:0x28,%rax
>   3e:   00 00
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:   89 c2                   mov    %eax,%edx
>    2:   3d 00 f0 ff ff          cmp    $0xfffff000,%eax
>    7:   77 1a                   ja     0x23
>    9:   48 8b 45 c8             mov    -0x38(%rbp),%rax
>    d:   64 48 2b 04 25 28 00    sub    %fs:0x28,%rax
>   14:   00 00
> [   12.237333] RSP: 002b:00007f4569dfed20 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
> [   12.237599] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f457=
600fecd
> [   12.237854] RDX: 00007f4569dfeda0 RSI: 00000000c028aa05 RDI: 000000000=
0000009
> [   12.238129] RBP: 00007f4569dfed70 R08: 0000000000000000 R09: 000000000=
0000000
> [   12.238384] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffb=
974ba60
> [   12.238636] R13: 00007fffb974b830 R14: 00007f4569dffcdc R15: 00007fffb=
974b937
> [   12.238890]  </TASK>
> [   12.239094] Kernel Offset: 0x33000000 from 0xffffffff81000000 (relocat=
ion range: 0xffffffff80000000-0xffffffffbfffffff)
> [   12.239480] ---[ end Kernel panic - not syncing: kernel: panic_on_warn=
 set ... ]---

